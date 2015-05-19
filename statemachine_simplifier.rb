=begin 
File: statemachine_simplifier.rb 
Author: Sara Tibbetts 
Date: 04/24/2015 
Description: This program takes in .txt file with a state table 
and reduces it to its simplest form 
=end 

def dup_remove(table0)
  #Simplifies states with same output and next states 
  for i in 0..((table0.size)-1) 
    check1 = table0[i][1]
    check2 = table0[i][2]
    for j in 0..((table0.size)-1)
      if i != j then 
        #States are exactly the same 
        if (table0[i][1] == table0[j][1]) and (table0[i][2] == table0[j][2]) then 
          #Replaces all instances of state to be removed with equivalent state 
          to_rep = table0[i][0] 
          to_rem = table0[j][0]
  
          t_index = []
          #Removes the state from the array 
          table0[j] = "-1"
          for i in 0..((table0.size)-1)
            for j in 0..((table0[0].size)-1)
              if table0[i][j] == to_rem then 
                table0[i][j] = to_rep 
              end 
            end 
          end 
        end 
      end 
    end
  end
  
  #Removes the placeholders from the table 
  for i in 0..((table0.size)-1)
    if table0[i] == "-1" then 
      t_index.push(i) 
    end
  end
   
  if t_index != nil then 
    for i in 0..((t_index.size)-1)
      table0.delete_at(t_index[i])
      for j in i..((t_index.size)-1)
        t_index[j] = t_index[j]-1
      end 
    end 
  end 
  
  
  #puts table0.inspect 
  return table0
end 

#loops through the given array, and minimizes the states 
def x_out(arr1, s_table)
  puts arr1.inspect
  #puts arr1.size
  #loops through the columns 
  #puts arr1[4].inspect
  for i in 0..((arr1.size)-1)
    #Loops through each row of the columns 
    for j in 0..((arr1[i].size)-1)
     
      #print "i: " , i,  " j: " , j, "\n"
      #puts arr1[i][j].inspect
      #If the cell is not an "X"
      if arr1[i][j].size != 1
        #If the states are not equal 
        if arr1[i][j][0] != arr1[i][j][2]                                       ###################1
          #If the first state is less than the second state
          if arr1[i][j][0] < arr1[i][j][2]                                      ###################2
            #If arr1[small-1][(big-2)-(small-1)] = "X"
            if arr1[(arr1[i][j][0])-1][(arr1[i][j][2]-2)-(arr1[i][j][0]-1)] = "X"        ###################3  where the problem lies 
               
              arr1[i][j] = "X" 
            end                                                                 ###################3
            #If the first state is more than the second state 
          else                                                                  ###################2
            #If arr1[small-1][(big-2)-(small-1)] = "X"
            if arr1[arr1[i][j][2]-1][(arr1[i][j][0]-2)-(arr1[i][j][2]-1)] = "X"          ###################4  where the problem lies 
              arr1[i][j] = "X"
            end                                                                 ###################4
          end                                                                   ###################2
        end                                                                     ###################1
        if arr1[i][j] != "X"
          #If the states are not equal 
          if arr1[i][j][1] != arr1[i][j][3]
            #If the first state is less than the second state
            if arr1[i][j][1] < arr1[i][j][3]
              #If arr1[small-1][(big-2)-(small-1)] = "X"
              if arr1[(arr1[i][j][1])-1][(arr1[i][j][3]-2)-(arr1[i][j][1]-1)] = "X"                            #problem again
                arr1[i][j] = "X" 
              end 
              #If the first state is more than the second state 
            else 
              #If arr1[small-1][(big-2)-(small-1)] = "X"
              if arr1[arr1[i][j][3]-1][(arr1[i][j][1]-2)-(arr1[i][j][3]-1)] = "X"                              #problem again 
                arr1[i][j] = "X"
              end 
            end 
          end 
        end
      end 
    end 
  end 
end 

def main()
  #Reads in the .txt file 
  print("Enter a file: ")
  filename = gets.chomp
  
  
  
  #Creates array to store information from file 
  s_table = ""
  i = 0 
  j = 0 
  
  
  f = File.open(filename,"r")
    puts "\nState table input: \n"
  f.each_line do |line|
    puts line
    s_table = s_table + line 
  end
  
  s_table = s_table.split("\n")
  s_table = s_table.map { |data| data.split(' ') }
    
  #Groups states based on outputs 
  table1 = []
  table0 = []
        
  for i in 0..((s_table.size)-1)
    if s_table[i][3] == "1" then 
      table1.push(s_table[i])
    elsif s_table[i][3] == "0" then 
      table0.push(s_table[i])
    end
  end
  
  while dup_remove(table0) != table0
    table0 = dup_remove(table0)
  end
  
  while dup_remove(table1) != table1 
    table1 = dup_remove(table1)
  end
  
  
  #Removes the rest of the unnecessary states 
  
  #table of states that have the possibility of being combined 
  pos_comb = []
   
  #Need to make table reflecting staircase [ [AB, AC, AD, AE, AF, AG], [BC, BD, BE, BF, BG], [CD, CE, CF, CG], [DE, DF, DG], [EF, EG], [FG] ]
  for i in 0..((s_table.size)-2)
    # 0 :6, 1: 5, 2:4 . . . 
    #(s_table.size)-(i+1)
    pos_comb[i] = Array.new(s_table.size-(i+1), "0")
  end 
  
  #puts pos_comb.inspect
  
  #Creates an array with a numerical equivalent of the state number 
  s0_arr = Array.new(table0.size)
  for i in 0..((s0_arr.size)-1)
    if (table0[i][0].ord >= 30) && (table0[i][0].ord <= 57)  
      s0_arr[i] = table0[i][0] 
    elsif (table0[i][0].ord >= 65) && (table0[i][0].ord <= 90)  
      s0_arr[i] = table0[i][0].ord - 64
    else 
      s0_arr[i] = table0[i][0].ord - 96
    end 
  end 
  
  
  s1_arr = Array.new(table1.size)
  for i in 0..((s1_arr.size)-1)
    if (table1[i][0].ord >= 30) && (table1[i][0].ord <= 57)  
      s1_arr[i] = table1[i][0] 
    elsif (table1[i][0].ord >= 65) && (table1[i][0].ord <= 90)  
      s1_arr[i] = table1[i][0].ord - 64
    else 
      s1_arr[i] = table1[i][0].ord - 96
    end 
  end 
   
  #Loops through all of the items in the s1_arr and s0_arr and places 
  # an "X" on their combined position in the pos_comb array 
  for i in 0..((s0_arr.size)-1)
    for j in 0..((s1_arr.size)-1)
      if s0_arr[i] < s1_arr[j] then 
        #puts (s1_arr[j]-s0_arr[i]-1)
        pos_comb[s0_arr[i]-1][(s1_arr[j]-s0_arr[i])-1] = "X"
      else 
        pos_comb[s1_arr[j]-1][(s0_arr[i]-s1_arr[j])-1] = "X"
      end 
    end 
  end 
  
#  #reverses the items in the pos_comb arrays 
#  for i in 0..((pos_comb.size)-1)
#    pos_comb[i].reverse
#  end 
  
  #puts pos_comb.inspect
  #puts pos_comb[0][5]
  
  #Need to go through the pos_comb array, and wherever there is not an X, fill the 
  #next states of the combination 
  
  #Loops through the pos_comb array, and wherever there is not an X, places an array of 
  #to hold the next states of the combination 
  for i in 0..((pos_comb.size)-1) 
    for j in 0..((pos_comb[i].size)-1)
      if pos_comb[i][j] != "X"
        pos_comb[i][j] = Array.new(4, 0)
        
        #Places numerical form of state transitions into new array 
        
        #Columns 
        for k in 0 .. 1
          #numbers 
          if (s_table[i][k+1].ord >= 30) && (s_table[i][k+1].ord <= 57)
            pos_comb[i][j][k] = s_table[i][k-1]
          #uppercase
          elsif (s_table[i][k+1].ord >= 65) && (s_table[i][k+1].ord <= 90)
            pos_comb[i][j][k] = s_table[i][k+1].ord - 64
          #lowercase
          else 
            pos_comb[i][j][k] = s_table[i][k+1].ord - 96
          end 
        end 
        
        #Rows 
        for k in 2 .. 3
          #numbers 
          #puts s_table[j].inspect
          if (s_table[(i+j)+1][k-1].ord >= 30) && (s_table[(i+j)+1][k-1].ord <= 57)
            pos_comb[i][j][k] = s_table[j+1][k-1]
          #uppercase
          elsif (s_table[(i+j)+1][k-1].ord >= 65) && (s_table[(i+j)+1][k-1].ord <= 90)
            pos_comb[i][j][k] = s_table[(i+j)+1][k-1].ord - 64
          #lowercase
          else 
            pos_comb[i][j][k] = s_table[(i+j)+1][k-1].ord - 96
          end 
        end 
        
      end 
    end 
  end 
  
  #puts pos_comb.inspect 
    
  #puts pos_comb.inspect
  
while x_out(pos_comb, s_table) != pos_comb
  pos_comb = x_out(pos_comb, s_table)
end
  
end

main()
