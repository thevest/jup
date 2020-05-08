using LinearAlgebra

include("fibonacci.jl")

# By considering the terms in the Fibonacci sequence whose values do not exceed four million,
# find the sum of the even-valued terms.
#
# https://projecteuler.net/problem=2
function p2()
  i = 1
  fibs = []
  while true
    nf = fibonacci(i)
    if nf > 4e6
      break
    end
    push!(fibs, fibonacci(i))
    i += 1
  end
  reduce(+, filter(x -> x % 2 == 0, fibs))
end

# https://projecteuler.net/problem=4
function p4()
  largest = 0
  for i = 100:999
    for j = 100:999
      value = i*j
      if digits(value) == reverse(digits(value)) && value > largest
        largest = value
      end
    end
  end
  largest
end

# 2520 is the smallest number that can be divided by each of the numbers from 1 to 10 without any remainder.
#
# What is the smallest positive number that is evenly divisible by all of the numbers from 1 to 20?
#
# https://projecteuler.net/problem=5
function p5(upto=20)
  function checker(x)
    for i = 1:upto
      if x % i != 0
        return false
      end
    end
    return true
  end
  x = upto
  while true
    if checker(x)
      return x
    else
      x += 1
    end
  end
end

function p6(n=100)
  total_square = 0
  total_sum = 0
  for i = 1:n
    total_square += i^2
    total_sum += i
  end
  total_sum_square = total_sum^2
  total_sum_square - total_square
end

function p8(n=13)
  digs = digits(7316717653133062491922511967442657474235534919493496983520312774506326239578318016984801869478851843858615607891129494954595017379583319528532088055111254069874715852386305071569329096329522744304355766896648950445244523161731856403098711121722383113622298934233803081353362766142828064444866452387493035890729629049156044077239071381051585930796086670172427121883998797908792274921901699720888093776657273330010533678812202354218097512545405947522435258490771167055601360483958644670632441572215539753697817977846174064955149290862569321978468622482839722413756570560574902614079729686524145351004748216637048440319989000889524345065854122758866688116427171479924442928230863465674813919123162824586178664583591245665294765456828489128831426076900422421902267105562632111110937054421750694165896040807198403850962455444362981230987879927244284909188845801561660979191338754992005240636899125607176060588611646710940507754100225698315520005593572972571636269561882670428252483600823257530420752963450)
  parts = []
  i = 1
  while true
    part = []
    for j = i:i+n-1
      push!(part, digs[j])
    end
    push!(parts, reduce(*, part))
    i += 1
    if i + n > length(digs)
      break
    end
  end
  largest = 0
  for p in parts
    if p > largest
      largest = p
    end
  end
  largest
end

function p25(d=1000)
  i = 1
  c = 0
  while length(digits(c)) != d
    c = fibonacci(i)
    i += 1
  end
  println(c)
  i
end

# This one was more challenging than expected because I did not think about the diagonals that cut to the
# left instead of the right. This was a good chance to get familiar with aspects of julia arrays and matrices
# especially the ability iterate rows or cols, extract the nth diagonal, and rotate the matrix. I also spent
# a bit of time to shorten / condense everything down, julia is awesomepawsome.
#
# https://projecteuler.net/problem=11
function p11()
  data = [
    08 02 22 97 38 15 00 40 00 75 04 05 07 78 52 12 50 77 91 08
    49 49 99 40 17 81 18 57 60 87 17 40 98 43 69 48 04 56 62 00
    81 49 31 73 55 79 14 29 93 71 40 67 53 88 30 03 49 13 36 65
    52 70 95 23 04 60 11 42 69 24 68 56 01 32 56 71 37 02 36 91
    22 31 16 71 51 67 63 89 41 92 36 54 22 40 40 28 66 33 13 80
    24 47 32 60 99 03 45 02 44 75 33 53 78 36 84 20 35 17 12 50
    32 98 81 28 64 23 67 10 26 38 40 67 59 54 70 66 18 38 64 70
    67 26 20 68 02 62 12 20 95 63 94 39 63 08 40 91 66 49 94 21
    24 55 58 05 66 73 99 26 97 17 78 78 96 83 14 88 34 89 63 72
    21 36 23 09 75 00 76 44 20 45 35 14 00 61 33 97 34 31 33 95
    78 17 53 28 22 75 31 67 15 94 03 80 04 62 16 14 09 53 56 92
    16 39 05 42 96 35 31 47 55 58 88 24 00 17 54 24 36 29 85 57
    86 56 00 48 35 71 89 07 05 44 44 37 44 60 21 58 51 54 17 58
    19 80 81 68 05 94 47 69 28 73 92 13 86 52 17 77 04 89 55 40
    04 52 08 83 97 35 99 16 07 97 57 32 16 26 26 79 33 27 98 66
    88 36 68 87 57 62 20 72 03 46 33 67 46 55 12 32 63 93 53 69
    04 42 16 73 38 25 39 11 24 94 72 18 08 46 29 32 40 62 76 36
    20 69 36 41 72 30 23 88 34 62 99 69 82 67 59 85 74 04 36 16
    20 73 35 29 78 31 90 01 74 31 49 71 48 86 81 16 23 57 05 54
    01 70 54 71 83 51 54 69 16 92 33 48 61 43 52 01 89 19 67 48
  ]

  largest = 0
  grid = reshape(data, 20, 20)
  rotatedgrid = rotl90(grid, 1)

  update(x) = x > largest ? x : largest
  handler(part) = foreach(i -> largest = update(reduce(*, part[i:i+3])), 1:17)
  foreach(handler, eachrow(grid))
  foreach(handler, eachcol(grid))

  for i = -16:16
    regpart = diag(grid, i)
    foreach(i -> largest = update(reduce(*, regpart[i:i+3])), 1:length(regpart)-3)

    rotpart = diag(rotatedgrid, i)
    foreach(i -> largest = update(reduce(*, rotpart[i:i+3])), 1:length(rotpart)-3)
  end

  largest
end


# Given a square that is nxm there are some number of combinations of rows and columns into rectangles.
#
# For example 3x2 can be broken down into 18 different rectangles:
#
# 6 + 3 + 2 + 4 + 2 + 1
function rectangular(n, m)
  # count = 1 + n + m + n*m + max(0, n*m*(n-2)) + max(0, n*m*(m-2))

  total = n*m


  count = 1 + n + m + total

  count
end
# https://projecteuler.net/problem=85


# I think using the same kind of block cuts of matrices that I am using for the data grid below might work

# # whole rectangle counts as a block
# total = 1
# # trivial 1x1 blocks
# total += n*m
# # rows and cols make rectangles
# total += n # n rectangles of length m
# total += m # m rectangles of length n
# # now we need to go column by column finding the combinations
# x = n
# xt = 0
# while x > 2
#   x -= 1
#   xt += x
# end
# total += m*xt
# # last row by row to find combinations
# y = m
# yt = 0
# while y > 2
#   y -= 1
#   yt += y
# end
# total += n*yt
#
# total
