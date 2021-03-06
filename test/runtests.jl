using ClimateTools
using Base.Test

# write your own tests here

# Prcp1
d = Date(2003,1,1):Date(2005,12,31)
data= vcat(ones(365,1), zeros(366,1), ones(365))
Results = Array{Int64, 2}(3, 1); Results[1] = 365; Results[2] = 0; Results[3] = 365;
@test prcp1(data, d) == Results

data = Array{Float64,3}(1096, 2, 2)
data[:,1,1] = vcat(ones(365,1), zeros(366,1), ones(365))
data[:,2,1] = vcat(ones(365,1), zeros(366,1), ones(365))
data[:,1,2] = vcat(ones(365,1), zeros(366,1), ones(365))
data[:,2,2] = vcat(ones(365,1), zeros(366,1), ones(365))
Results = Array{Int64, 3}(3, 2, 2); Results[1,1,1] = 365; Results[2,1,1] = 0; Results[3,1,1] = 365; Results[1,2,1] = 365; Results[2,2,1] = 0; Results[3,2,1] = 365; Results[1,1,2] = 365; Results[2,1,2] = 0; Results[3,1,2] = 365; Results[1,2,2] = 365; Results[2,2,2] = 0; Results[3,2,2] = 365;
@test prcp1(data, d) == Results


# Frostdays
data= vcat(-ones(365,1), -ones(366),zeros(365,1))
Results = Array{Int64, 2}(3, 1); Results[1] = 365; Results[2] = 366; Results[3] = 0;
@test frostdays(data, d) == Results
@test icingdays(data, d) == Results

data = Array{Float64,3}(1096, 2, 2)
data[:,1,1] = vcat(-ones(365,1), -ones(366,1), zeros(365))
data[:,2,1] = vcat(-ones(365,1), -ones(366,1), zeros(365))
data[:,1,2] = vcat(-ones(365,1), -ones(366,1), zeros(365))
data[:,2,2] = vcat(-ones(365,1), -ones(366,1), zeros(365))
Results = Array{Int64, 3}(3, 2, 2); Results[1,1,1] = 365; Results[2,1,1] = 366; Results[3,1,1] = 0; Results[1,2,1] = 365; Results[2,2,1] = 366; Results[3,2,1] = 0; Results[1,1,2] = 365; Results[2,1,2] = 366; Results[3,1,2] = 0; Results[1,2,2] = 365; Results[2,2,2] = 366; Results[3,2,2] = 0;
@test frostdays(data, d) == Results
@test icingdays(data, d) == Results

# Summer Days
d = Date(2003,1,1):Date(2007,12,31)
data = collect(1.:1826.)
@test summerdays(data, d) == [341, 366, 365, 365, 365]''

data = hcat(collect(1.:1826.), collect(1.:1826.))
@test summerdays(data, d) == hcat([341, 366, 365, 365, 365],[341, 366, 365, 365, 365])

data = Array{Float64, 3}(1826, 2, 2)
data[:, 1, 1] = collect(1.:1826.); data[:, 1, 2] = collect(1.:1826.);data[:, 2, 1] = collect(1.:1826.);data[:, 2, 2] = collect(1.:1826.);
Results = Array{Int64, 3}(5, 2, 2); Results[:, 1, 1] = [341, 366, 365, 365, 365]''; Results[:, 1, 2] = [341, 366, 365, 365, 365]''; Results[:, 2, 1] = [341, 366, 365, 365, 365]''; Results[:, 2, 2] = [341, 366, 365, 365, 365]'';
@test summerdays(data, d) == Results

# Tropical Nights
d = Date(2003,1,1):Date(2007,12,31)
data = collect(1.:1826.)
@test tropicalnights(data, d) == [346, 366, 365, 365, 365]''

data = hcat(collect(1.:1826.), collect(1.:1826.))
@test tropicalnights(data, d) == hcat([346, 366, 365, 365, 365],[346, 366, 365, 365, 365])

data = Array{Float64, 3}(1826, 2, 2)
data[:, 1, 1] = collect(1.:1826.); data[:, 1, 2] = collect(1.:1826.);data[:, 2, 1] = collect(1.:1826.);data[:, 2, 2] = collect(1.:1826.);
Results = Array{Int64, 3}(5, 2, 2); Results[:, 1, 1] = [346, 366, 365, 365, 365]''; Results[:, 1, 2] = [346, 366, 365, 365, 365]''; Results[:, 2, 1] = [346, 366, 365, 365, 365]''; Results[:, 2, 2] = [346, 366, 365, 365, 365]'';
@test tropicalnights(data, d) == Results

## inpoly
@test leftorright(0.5,0.5, 1,0,1,1) == -1
@test leftorright(1.5,.5, 1,0,1,1) == 1
@test leftorright(1,0.5, 1,0,1,1) == 0

poly = Float64[0 0
               0 1
               1 1
               1 0
               0 0]'
p1 = [0.5, 0.5]
p2 = [0.5, 0.99]
p22 = [0.5, 1] # on edge
p23 = [0.5, 0] # on edge
p24 = [0, 0]   # on corner
p25 = [0, .4]   # on edge
p3 = [0.5, 1.1]

@test inpoly(p1, poly)
@test inpoly(p2, poly)
@test inpoly(p22, poly)
@test inpoly(p23, poly)
@test inpoly(p24, poly)
@test inpoly(p25, poly)
@test !inpoly(p3, poly)

# clockwise poly
poly = Float64[0 0
               1 0
               1 1
               0 1
               0 0]'

@test inpoly(p1, poly)
@test inpoly(p2, poly)
@test inpoly(p22, poly)
@test inpoly(p23, poly)
@test inpoly(p24, poly)
@test inpoly(p25, poly)
@test !inpoly(p3, poly)


# cross-over poly
poly = Float64[0 0
               1 0
               0 1
               1 1
               0 0]'
if VERSION >= v"0.5-"
    eval(:(@test_broken inpoly(p1, poly) )) # should be true
end
@test inpoly(p2, poly)
@test inpoly(p22, poly)
@test inpoly(p23, poly)
@test inpoly(p24, poly)
@test !inpoly(p25, poly) # different
@test !inpoly(p3, poly)


# with interior region
poly = Float64[0 0
               # interior
               0.1 0.1
               0.1 0.6
               0.6 0.6
               0.6 0.1
               0.1 0.1
               # exterior
               0 0
               0 1
               1 1
               1 0
               0 0]'
# inside interior poly: i.e. labeled as outside
@test !inpoly([0.3,0.3], poly)
@test !inpoly([0.3,0.5], poly)

poly = Float64[0 0
               # interior
               0.1 0.1
               0.1 0.6
               0.6 0.6
               # in-interior
               0.4 0.4
               0.4 0.2
               0.2 0.2
               0.2 0.4
               0.4 0.4
               # interior
               0.6 0.6
               0.6 0.1
               0.1 0.1
               # exterior
               0 0
               0 1
               1 1
               1 0
               0 0]'
# inside in-interior poly
@test inpoly([0.3,0.3], poly)
@test !inpoly([0.3,0.5], poly)

poly = Float64[0 0
               # interior
               0.1 0.1
               0.1 0.6
               0.6 0.6
               # in-interior
               0.4 0.4
               0.2 0.4
               0.2 0.2
               0.4 0.2
               0.4 0.4
               # interior
               0.6 0.6
               0.6 0.1
               0.1 0.1
               # exterior
               0 0
               0 1
               1 1
               1 0
               0 0]'
# inside in-interior poly
@test inpoly([0.3,0.3], poly)
@test !inpoly([0.3,0.5], poly)

poly = Float64[0 0
               # interior #1
               0.1 0.1
               0.1 0.6
               0.4 0.6
               0.4 0.6
               0.4 0.1
               0.1 0.1
               0 0
               # interior #2
               0.6 0.4
               0.6 0.6
               0.8 0.6
               0.8 0.4
               0.6 0.4
               0 0
               # exterior
               0 1
               1 1
               1 0
               0 0]'
@test !inpoly([0.2,0.4], poly)
@test !inpoly([0.3,0.15], poly)
@test inpoly([0.5,0.4], poly)
@test inpoly([0.5,0.2], poly)
@test !inpoly([0.7,0.5], poly)
