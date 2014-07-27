# FEATURES
# Features are common to both test and train so we load it only once
features <- read.table("UCI HAR Dataset/features.txt")
# We desire only feature containing either "mean()" either "std()"
features_index <- grep("mean\\(\\)|std\\(\\)", features$V2)
# Let's build a filter of desired features as a vector of boolean for ease of use with other data strcutures
indexes <- 1:length(features$V2)
indexes_filter <- sapply(indexes, (function(index) index %in% features_index))
desired_features <- features[features_index,]

# ACTIVITIES
# Load activity id for test and train
labels_set <- c(scan("UCI HAR Dataset/test/y_test.txt"), scan("UCI HAR Dataset/train/y_train.txt"))
# Activity labels are common to both test and train so we load it only once
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
# Replace activity ids by activity labels
Activity <- sapply(labels_set, (function(id) activities$V2[id]))

# DATA
# Concatenate test and train sets
data_set <- c(scan("UCI HAR Dataset/test/X_test.txt"), scan("UCI HAR Dataset/train/X_train.txt"))
# Extract usefull data from sets, only the features we desire, each column correspondong to one feature
mean_std <- split(data_set[rep(indexes_filter, length(data_set) / length(indexes))], 1:length(features_index))

# Just concatenate subjects from test and train
Subject <- c(scan("UCI HAR Dataset/test/subject_test.txt"), scan("UCI HAR Dataset/train/subject_train.txt"))

# Build a data frame in order to generate a beautiful CSV file
tidy_data <- data.frame(Subject, Activity, mean_std)
# I have been forced to stringify values of desired_features otherwise columns were named after desired_features original indexes
colnames(tidy_data) <- c("Subject", "Activity", sapply(desired_features$V2, (function(id) toString(id))))

# Part 1
write.csv(tidy_data, file = "tidy.csv")
