Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE882791EB
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgIYUTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:19:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726311AbgIYURc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 16:17:32 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F33FD23730;
        Fri, 25 Sep 2020 19:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601062698;
        bh=FQI4v+o00F3sJeCA692bgLrxAEcINOXspq8u45yMg7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i+/tt0zkL7itLVIDSPfvhoM8x5MWT5c/D/mC9CnvOZ5eWH+sK7E2PSlostg+3uc2K
         GagEKIyZnh7V7vwhuRST8xbT/fWrqzxe4Kgh7oTN6XnxHv36noT4YQUpFc3N8TZly1
         ZCILa5wCHfR1OWnbxWa9VdqqTjKR6bf/WdDo/iqY=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/15] net/mlx5: DR, Handle ICM memory via buddy allocation instead of bucket management
Date:   Fri, 25 Sep 2020 12:37:56 -0700
Message-Id: <20200925193809.463047-3-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925193809.463047-1-saeed@kernel.org>
References: <20200925193809.463047-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Till now in order to manage the ICM memory we used bucket
mechanism, which kept a bucket per specified size (sizes were
between 1 block to 2^21 blocks).

Now changing that with buddy-system mechanism, which gives us much
more flexible way to manage the ICM memory.
Its biggest advantage over the bucket is by using the same ICM memory
area for all the sizes of blocks, which reduces the memory consumption.

Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_icm_pool.c | 501 +++++++-----------
 .../mellanox/mlx5/core/steering/dr_types.h    |  24 +-
 2 files changed, 211 insertions(+), 314 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index cc33515b9aba..2c5886b469f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -6,48 +6,13 @@
 #define DR_ICM_MODIFY_HDR_ALIGN_BASE 64
 #define DR_ICM_SYNC_THRESHOLD (64 * 1024 * 1024)
 
-struct mlx5dr_icm_pool;
-
-struct mlx5dr_icm_bucket {
-	struct mlx5dr_icm_pool *pool;
-
-	/* Chunks that aren't visible to HW not directly and not in cache */
-	struct list_head free_list;
-	unsigned int free_list_count;
-
-	/* Used chunks, HW may be accessing this memory */
-	struct list_head used_list;
-	unsigned int used_list_count;
-
-	/* HW may be accessing this memory but at some future,
-	 * undetermined time, it might cease to do so. Before deciding to call
-	 * sync_ste, this list is moved to sync_list
-	 */
-	struct list_head hot_list;
-	unsigned int hot_list_count;
-
-	/* Pending sync list, entries from the hot list are moved to this list.
-	 * sync_ste is executed and then sync_list is concatenated to the free list
-	 */
-	struct list_head sync_list;
-	unsigned int sync_list_count;
-
-	u32 total_chunks;
-	u32 num_of_entries;
-	u32 entry_size;
-	/* protect the ICM bucket */
-	struct mutex mutex;
-};
-
 struct mlx5dr_icm_pool {
-	struct mlx5dr_icm_bucket *buckets;
 	enum mlx5dr_icm_type icm_type;
 	enum mlx5dr_icm_chunk_size max_log_chunk_sz;
-	enum mlx5dr_icm_chunk_size num_of_buckets;
-	struct list_head icm_mr_list;
-	/* protect the ICM MR list */
-	struct mutex mr_mutex;
 	struct mlx5dr_domain *dmn;
+	/* memory management */
+	struct mutex mutex; /* protect the ICM pool and ICM buddy */
+	struct list_head buddy_mem_list;
 };
 
 struct mlx5dr_icm_dm {
@@ -58,13 +23,11 @@ struct mlx5dr_icm_dm {
 };
 
 struct mlx5dr_icm_mr {
-	struct mlx5dr_icm_pool *pool;
 	struct mlx5_core_mkey mkey;
 	struct mlx5dr_icm_dm dm;
-	size_t used_length;
+	struct mlx5dr_domain *dmn;
 	size_t length;
 	u64 icm_start_addr;
-	struct list_head mr_list;
 };
 
 static int dr_icm_create_dm_mkey(struct mlx5_core_dev *mdev,
@@ -107,8 +70,7 @@ dr_icm_pool_mr_create(struct mlx5dr_icm_pool *pool)
 	if (!icm_mr)
 		return NULL;
 
-	icm_mr->pool = pool;
-	INIT_LIST_HEAD(&icm_mr->mr_list);
+	icm_mr->dmn = pool->dmn;
 
 	icm_mr->dm.length = mlx5dr_icm_pool_chunk_size_to_byte(pool->max_log_chunk_sz,
 							       pool->icm_type);
@@ -150,8 +112,6 @@ dr_icm_pool_mr_create(struct mlx5dr_icm_pool *pool)
 		goto free_mkey;
 	}
 
-	list_add_tail(&icm_mr->mr_list, &pool->icm_mr_list);
-
 	return icm_mr;
 
 free_mkey:
@@ -166,10 +126,9 @@ dr_icm_pool_mr_create(struct mlx5dr_icm_pool *pool)
 
 static void dr_icm_pool_mr_destroy(struct mlx5dr_icm_mr *icm_mr)
 {
-	struct mlx5_core_dev *mdev = icm_mr->pool->dmn->mdev;
+	struct mlx5_core_dev *mdev = icm_mr->dmn->mdev;
 	struct mlx5dr_icm_dm *dm = &icm_mr->dm;
 
-	list_del(&icm_mr->mr_list);
 	mlx5_core_destroy_mkey(mdev, &icm_mr->mkey);
 	mlx5_dm_sw_icm_dealloc(mdev, dm->type, dm->length, 0,
 			       dm->addr, dm->obj_id);
@@ -178,19 +137,17 @@ static void dr_icm_pool_mr_destroy(struct mlx5dr_icm_mr *icm_mr)
 
 static int dr_icm_chunk_ste_init(struct mlx5dr_icm_chunk *chunk)
 {
-	struct mlx5dr_icm_bucket *bucket = chunk->bucket;
-
-	chunk->ste_arr = kvzalloc(bucket->num_of_entries *
+	chunk->ste_arr = kvzalloc(chunk->num_of_entries *
 				  sizeof(chunk->ste_arr[0]), GFP_KERNEL);
 	if (!chunk->ste_arr)
 		return -ENOMEM;
 
-	chunk->hw_ste_arr = kvzalloc(bucket->num_of_entries *
+	chunk->hw_ste_arr = kvzalloc(chunk->num_of_entries *
 				     DR_STE_SIZE_REDUCED, GFP_KERNEL);
 	if (!chunk->hw_ste_arr)
 		goto out_free_ste_arr;
 
-	chunk->miss_list = kvmalloc(bucket->num_of_entries *
+	chunk->miss_list = kvmalloc(chunk->num_of_entries *
 				    sizeof(chunk->miss_list[0]), GFP_KERNEL);
 	if (!chunk->miss_list)
 		goto out_free_hw_ste_arr;
@@ -204,72 +161,6 @@ static int dr_icm_chunk_ste_init(struct mlx5dr_icm_chunk *chunk)
 	return -ENOMEM;
 }
 
-static int dr_icm_chunks_create(struct mlx5dr_icm_bucket *bucket)
-{
-	size_t mr_free_size, mr_req_size, mr_row_size;
-	struct mlx5dr_icm_pool *pool = bucket->pool;
-	struct mlx5dr_icm_mr *icm_mr = NULL;
-	struct mlx5dr_icm_chunk *chunk;
-	int i, err = 0;
-
-	mr_req_size = bucket->num_of_entries * bucket->entry_size;
-	mr_row_size = mlx5dr_icm_pool_chunk_size_to_byte(pool->max_log_chunk_sz,
-							 pool->icm_type);
-	mutex_lock(&pool->mr_mutex);
-	if (!list_empty(&pool->icm_mr_list)) {
-		icm_mr = list_last_entry(&pool->icm_mr_list,
-					 struct mlx5dr_icm_mr, mr_list);
-
-		if (icm_mr)
-			mr_free_size = icm_mr->dm.length - icm_mr->used_length;
-	}
-
-	if (!icm_mr || mr_free_size < mr_row_size) {
-		icm_mr = dr_icm_pool_mr_create(pool);
-		if (!icm_mr) {
-			err = -ENOMEM;
-			goto out_err;
-		}
-	}
-
-	/* Create memory aligned chunks */
-	for (i = 0; i < mr_row_size / mr_req_size; i++) {
-		chunk = kvzalloc(sizeof(*chunk), GFP_KERNEL);
-		if (!chunk) {
-			err = -ENOMEM;
-			goto out_err;
-		}
-
-		chunk->bucket = bucket;
-		chunk->rkey = icm_mr->mkey.key;
-		/* mr start addr is zero based */
-		chunk->mr_addr = icm_mr->used_length;
-		chunk->icm_addr = (uintptr_t)icm_mr->icm_start_addr + icm_mr->used_length;
-		icm_mr->used_length += mr_req_size;
-		chunk->num_of_entries = bucket->num_of_entries;
-		chunk->byte_size = chunk->num_of_entries * bucket->entry_size;
-
-		if (pool->icm_type == DR_ICM_TYPE_STE) {
-			err = dr_icm_chunk_ste_init(chunk);
-			if (err)
-				goto out_free_chunk;
-		}
-
-		INIT_LIST_HEAD(&chunk->chunk_list);
-		list_add(&chunk->chunk_list, &bucket->free_list);
-		bucket->free_list_count++;
-		bucket->total_chunks++;
-	}
-	mutex_unlock(&pool->mr_mutex);
-	return 0;
-
-out_free_chunk:
-	kvfree(chunk);
-out_err:
-	mutex_unlock(&pool->mr_mutex);
-	return err;
-}
-
 static void dr_icm_chunk_ste_cleanup(struct mlx5dr_icm_chunk *chunk)
 {
 	kvfree(chunk->miss_list);
@@ -277,166 +168,208 @@ static void dr_icm_chunk_ste_cleanup(struct mlx5dr_icm_chunk *chunk)
 	kvfree(chunk->ste_arr);
 }
 
+static enum mlx5dr_icm_type
+get_chunk_icm_type(struct mlx5dr_icm_chunk *chunk)
+{
+	return chunk->buddy_mem->pool->icm_type;
+}
+
 static void dr_icm_chunk_destroy(struct mlx5dr_icm_chunk *chunk)
 {
-	struct mlx5dr_icm_bucket *bucket = chunk->bucket;
+	enum mlx5dr_icm_type icm_type = get_chunk_icm_type(chunk);
 
 	list_del(&chunk->chunk_list);
-	bucket->total_chunks--;
 
-	if (bucket->pool->icm_type == DR_ICM_TYPE_STE)
+	if (icm_type == DR_ICM_TYPE_STE)
 		dr_icm_chunk_ste_cleanup(chunk);
 
 	kvfree(chunk);
 }
 
-static void dr_icm_bucket_init(struct mlx5dr_icm_pool *pool,
-			       struct mlx5dr_icm_bucket *bucket,
-			       enum mlx5dr_icm_chunk_size chunk_size)
+static int dr_icm_buddy_create(struct mlx5dr_icm_pool *pool)
 {
-	if (pool->icm_type == DR_ICM_TYPE_STE)
-		bucket->entry_size = DR_STE_SIZE;
-	else
-		bucket->entry_size = DR_MODIFY_ACTION_SIZE;
-
-	bucket->num_of_entries = mlx5dr_icm_pool_chunk_size_to_entries(chunk_size);
-	bucket->pool = pool;
-	mutex_init(&bucket->mutex);
-	INIT_LIST_HEAD(&bucket->free_list);
-	INIT_LIST_HEAD(&bucket->used_list);
-	INIT_LIST_HEAD(&bucket->hot_list);
-	INIT_LIST_HEAD(&bucket->sync_list);
+	struct mlx5dr_icm_buddy_mem *buddy;
+	struct mlx5dr_icm_mr *icm_mr;
+
+	icm_mr = dr_icm_pool_mr_create(pool);
+	if (!icm_mr)
+		return -ENOMEM;
+
+	buddy = kvzalloc(sizeof(*buddy), GFP_KERNEL);
+	if (!buddy)
+		goto free_mr;
+
+	if (mlx5dr_buddy_init(buddy, pool->max_log_chunk_sz))
+		goto err_free_buddy;
+
+	buddy->icm_mr = icm_mr;
+	buddy->pool = pool;
+
+	/* add it to the -start- of the list in order to search in it first */
+	list_add(&buddy->list_node, &pool->buddy_mem_list);
+
+	return 0;
+
+err_free_buddy:
+	kvfree(buddy);
+free_mr:
+	dr_icm_pool_mr_destroy(icm_mr);
+	return -ENOMEM;
 }
 
-static void dr_icm_bucket_cleanup(struct mlx5dr_icm_bucket *bucket)
+static void dr_icm_buddy_destroy(struct mlx5dr_icm_buddy_mem *buddy)
 {
 	struct mlx5dr_icm_chunk *chunk, *next;
 
-	mutex_destroy(&bucket->mutex);
-	list_splice_tail_init(&bucket->sync_list, &bucket->free_list);
-	list_splice_tail_init(&bucket->hot_list, &bucket->free_list);
+	list_for_each_entry_safe(chunk, next, &buddy->hot_list, chunk_list)
+		dr_icm_chunk_destroy(chunk);
 
-	list_for_each_entry_safe(chunk, next, &bucket->free_list, chunk_list)
+	list_for_each_entry_safe(chunk, next, &buddy->used_list, chunk_list)
 		dr_icm_chunk_destroy(chunk);
 
-	WARN_ON(bucket->total_chunks != 0);
+	dr_icm_pool_mr_destroy(buddy->icm_mr);
 
-	/* Cleanup of unreturned chunks */
-	list_for_each_entry_safe(chunk, next, &bucket->used_list, chunk_list)
-		dr_icm_chunk_destroy(chunk);
+	mlx5dr_buddy_cleanup(buddy);
+
+	kvfree(buddy);
 }
 
-static u64 dr_icm_hot_mem_size(struct mlx5dr_icm_pool *pool)
+static struct mlx5dr_icm_chunk *
+dr_icm_chunk_create(struct mlx5dr_icm_pool *pool,
+		    enum mlx5dr_icm_chunk_size chunk_size,
+		    struct mlx5dr_icm_buddy_mem *buddy_mem_pool,
+		    unsigned int seg)
 {
-	u64 hot_size = 0;
-	int chunk_order;
+	struct mlx5dr_icm_chunk *chunk;
+	int offset;
 
-	for (chunk_order = 0; chunk_order < pool->num_of_buckets; chunk_order++)
-		hot_size += pool->buckets[chunk_order].hot_list_count *
-			    mlx5dr_icm_pool_chunk_size_to_byte(chunk_order, pool->icm_type);
+	chunk = kvzalloc(sizeof(*chunk), GFP_KERNEL);
+	if (!chunk)
+		return NULL;
 
-	return hot_size;
-}
+	offset = mlx5dr_icm_pool_dm_type_to_entry_size(pool->icm_type) * seg;
+
+	chunk->rkey = buddy_mem_pool->icm_mr->mkey.key;
+	chunk->mr_addr = offset;
+	chunk->icm_addr =
+		(uintptr_t)buddy_mem_pool->icm_mr->icm_start_addr + offset;
+	chunk->num_of_entries =
+		mlx5dr_icm_pool_chunk_size_to_entries(chunk_size);
+	chunk->byte_size =
+		mlx5dr_icm_pool_chunk_size_to_byte(chunk_size, pool->icm_type);
+	chunk->seg = seg;
+
+	if (pool->icm_type == DR_ICM_TYPE_STE && dr_icm_chunk_ste_init(chunk)) {
+		mlx5dr_err(pool->dmn,
+			   "Failed to init ste arrays (order: %d)\n",
+			   chunk_size);
+		goto out_free_chunk;
+	}
 
-static bool dr_icm_reuse_hot_entries(struct mlx5dr_icm_pool *pool,
-				     struct mlx5dr_icm_bucket *bucket)
-{
-	u64 bytes_for_sync;
+	chunk->buddy_mem = buddy_mem_pool;
+	INIT_LIST_HEAD(&chunk->chunk_list);
 
-	bytes_for_sync = dr_icm_hot_mem_size(pool);
-	if (bytes_for_sync < DR_ICM_SYNC_THRESHOLD || !bucket->hot_list_count)
-		return false;
+	/* chunk now is part of the used_list */
+	list_add_tail(&chunk->chunk_list, &buddy_mem_pool->used_list);
 
-	return true;
-}
+	return chunk;
 
-static void dr_icm_chill_bucket_start(struct mlx5dr_icm_bucket *bucket)
-{
-	list_splice_tail_init(&bucket->hot_list, &bucket->sync_list);
-	bucket->sync_list_count += bucket->hot_list_count;
-	bucket->hot_list_count = 0;
+out_free_chunk:
+	kvfree(chunk);
+	return NULL;
 }
 
-static void dr_icm_chill_bucket_end(struct mlx5dr_icm_bucket *bucket)
+static bool dr_icm_pool_is_sync_required(struct mlx5dr_icm_pool *pool)
 {
-	list_splice_tail_init(&bucket->sync_list, &bucket->free_list);
-	bucket->free_list_count += bucket->sync_list_count;
-	bucket->sync_list_count = 0;
-}
+	u64 allow_hot_size, all_hot_mem = 0;
+	struct mlx5dr_icm_buddy_mem *buddy;
+
+	list_for_each_entry(buddy, &pool->buddy_mem_list, list_node) {
+		allow_hot_size =
+			mlx5dr_icm_pool_chunk_size_to_byte((buddy->max_order - 2),
+							   pool->icm_type);
+		all_hot_mem += buddy->hot_memory_size;
+
+		if (buddy->hot_memory_size > allow_hot_size ||
+		    all_hot_mem > DR_ICM_SYNC_THRESHOLD)
+			return true;
+	}
 
-static void dr_icm_chill_bucket_abort(struct mlx5dr_icm_bucket *bucket)
-{
-	list_splice_tail_init(&bucket->sync_list, &bucket->hot_list);
-	bucket->hot_list_count += bucket->sync_list_count;
-	bucket->sync_list_count = 0;
+	return false;
 }
 
-static void dr_icm_chill_buckets_start(struct mlx5dr_icm_pool *pool,
-				       struct mlx5dr_icm_bucket *cb,
-				       bool buckets[DR_CHUNK_SIZE_MAX])
+static int dr_icm_pool_sync_all_buddy_pools(struct mlx5dr_icm_pool *pool)
 {
-	struct mlx5dr_icm_bucket *bucket;
-	int i;
-
-	for (i = 0; i < pool->num_of_buckets; i++) {
-		bucket = &pool->buckets[i];
-		if (bucket == cb) {
-			dr_icm_chill_bucket_start(bucket);
-			continue;
-		}
+	struct mlx5dr_icm_buddy_mem *buddy, *tmp_buddy;
+	int err;
 
-		/* Freeing the mutex is done at the end of that process, after
-		 * sync_ste was executed at dr_icm_chill_buckets_end func.
-		 */
-		if (mutex_trylock(&bucket->mutex)) {
-			dr_icm_chill_bucket_start(bucket);
-			buckets[i] = true;
-		}
+	err = mlx5dr_cmd_sync_steering(pool->dmn->mdev);
+	if (err) {
+		mlx5dr_err(pool->dmn, "Failed to sync to HW (err: %d)\n", err);
+		return err;
 	}
-}
-
-static void dr_icm_chill_buckets_end(struct mlx5dr_icm_pool *pool,
-				     struct mlx5dr_icm_bucket *cb,
-				     bool buckets[DR_CHUNK_SIZE_MAX])
-{
-	struct mlx5dr_icm_bucket *bucket;
-	int i;
-
-	for (i = 0; i < pool->num_of_buckets; i++) {
-		bucket = &pool->buckets[i];
-		if (bucket == cb) {
-			dr_icm_chill_bucket_end(bucket);
-			continue;
-		}
 
-		if (!buckets[i])
-			continue;
+	list_for_each_entry_safe(buddy, tmp_buddy, &pool->buddy_mem_list, list_node) {
+		struct mlx5dr_icm_chunk *chunk, *tmp_chunk;
 
-		dr_icm_chill_bucket_end(bucket);
-		mutex_unlock(&bucket->mutex);
+		list_for_each_entry_safe(chunk, tmp_chunk, &buddy->hot_list, chunk_list) {
+			mlx5dr_buddy_free_mem(buddy, chunk->seg,
+					      ilog2(chunk->num_of_entries));
+			buddy->hot_memory_size -= chunk->byte_size;
+			dr_icm_chunk_destroy(chunk);
+		}
 	}
+
+	return 0;
 }
 
-static void dr_icm_chill_buckets_abort(struct mlx5dr_icm_pool *pool,
-				       struct mlx5dr_icm_bucket *cb,
-				       bool buckets[DR_CHUNK_SIZE_MAX])
+static int dr_icm_handle_buddies_get_mem(struct mlx5dr_icm_pool *pool,
+					 enum mlx5dr_icm_chunk_size chunk_size,
+					 struct mlx5dr_icm_buddy_mem **buddy,
+					 unsigned int *seg)
 {
-	struct mlx5dr_icm_bucket *bucket;
-	int i;
-
-	for (i = 0; i < pool->num_of_buckets; i++) {
-		bucket = &pool->buckets[i];
-		if (bucket == cb) {
-			dr_icm_chill_bucket_abort(bucket);
-			continue;
-		}
+	struct mlx5dr_icm_buddy_mem *buddy_mem_pool;
+	bool new_mem = false;
+	int err;
 
-		if (!buckets[i])
-			continue;
+	/* Check if we have chunks that are waiting for sync-ste */
+	if (dr_icm_pool_is_sync_required(pool))
+		dr_icm_pool_sync_all_buddy_pools(pool);
+
+alloc_buddy_mem:
+	/* find the next free place from the buddy list */
+	list_for_each_entry(buddy_mem_pool, &pool->buddy_mem_list, list_node) {
+		err = mlx5dr_buddy_alloc_mem(buddy_mem_pool,
+					     chunk_size, seg);
+		if (!err)
+			goto found;
+
+		if (WARN_ON(new_mem)) {
+			/* We have new memory pool, first in the list */
+			mlx5dr_err(pool->dmn,
+				   "No memory for order: %d\n",
+				   chunk_size);
+			goto out;
+		}
+	}
 
-		dr_icm_chill_bucket_abort(bucket);
-		mutex_unlock(&bucket->mutex);
+	/* no more available allocators in that pool, create new */
+	err = dr_icm_buddy_create(pool);
+	if (err) {
+		mlx5dr_err(pool->dmn,
+			   "Failed creating buddy for order %d\n",
+			   chunk_size);
+		goto out;
 	}
+
+	/* mark we have new memory, first in list */
+	new_mem = true;
+	goto alloc_buddy_mem;
+
+found:
+	*buddy = buddy_mem_pool;
+out:
+	return err;
 }
 
 /* Allocate an ICM chunk, each chunk holds a piece of ICM memory and
@@ -446,68 +379,42 @@ struct mlx5dr_icm_chunk *
 mlx5dr_icm_alloc_chunk(struct mlx5dr_icm_pool *pool,
 		       enum mlx5dr_icm_chunk_size chunk_size)
 {
-	struct mlx5dr_icm_chunk *chunk = NULL; /* Fix compilation warning */
-	bool buckets[DR_CHUNK_SIZE_MAX] = {};
-	struct mlx5dr_icm_bucket *bucket;
-	int err;
+	struct mlx5dr_icm_chunk *chunk = NULL;
+	struct mlx5dr_icm_buddy_mem *buddy;
+	unsigned int seg;
+	int ret;
 
 	if (chunk_size > pool->max_log_chunk_sz)
 		return NULL;
 
-	bucket = &pool->buckets[chunk_size];
-
-	mutex_lock(&bucket->mutex);
-
-	/* Take chunk from pool if available, otherwise allocate new chunks */
-	if (list_empty(&bucket->free_list)) {
-		if (dr_icm_reuse_hot_entries(pool, bucket)) {
-			dr_icm_chill_buckets_start(pool, bucket, buckets);
-			err = mlx5dr_cmd_sync_steering(pool->dmn->mdev);
-			if (err) {
-				dr_icm_chill_buckets_abort(pool, bucket, buckets);
-				mlx5dr_err(pool->dmn, "Sync_steering failed\n");
-				chunk = NULL;
-				goto out;
-			}
-			dr_icm_chill_buckets_end(pool, bucket, buckets);
-		} else {
-			dr_icm_chunks_create(bucket);
-		}
-	}
+	mutex_lock(&pool->mutex);
+	/* find mem, get back the relevant buddy pool and seg in that mem */
+	ret = dr_icm_handle_buddies_get_mem(pool, chunk_size, &buddy, &seg);
+	if (ret)
+		goto out;
 
-	if (!list_empty(&bucket->free_list)) {
-		chunk = list_last_entry(&bucket->free_list,
-					struct mlx5dr_icm_chunk,
-					chunk_list);
-		if (chunk) {
-			list_del_init(&chunk->chunk_list);
-			list_add_tail(&chunk->chunk_list, &bucket->used_list);
-			bucket->free_list_count--;
-			bucket->used_list_count++;
-		}
-	}
+	chunk = dr_icm_chunk_create(pool, chunk_size, buddy, seg);
+	if (!chunk)
+		goto out_err;
+
+	goto out;
+
+out_err:
+	mlx5dr_buddy_free_mem(buddy, seg, chunk_size);
 out:
-	mutex_unlock(&bucket->mutex);
+	mutex_unlock(&pool->mutex);
 	return chunk;
 }
 
 void mlx5dr_icm_free_chunk(struct mlx5dr_icm_chunk *chunk)
 {
-	struct mlx5dr_icm_bucket *bucket = chunk->bucket;
-
-	if (bucket->pool->icm_type == DR_ICM_TYPE_STE) {
-		memset(chunk->ste_arr, 0,
-		       bucket->num_of_entries * sizeof(chunk->ste_arr[0]));
-		memset(chunk->hw_ste_arr, 0,
-		       bucket->num_of_entries * DR_STE_SIZE_REDUCED);
-	}
+	struct mlx5dr_icm_buddy_mem *buddy = chunk->buddy_mem;
 
-	mutex_lock(&bucket->mutex);
-	list_del_init(&chunk->chunk_list);
-	list_add_tail(&chunk->chunk_list, &bucket->hot_list);
-	bucket->hot_list_count++;
-	bucket->used_list_count--;
-	mutex_unlock(&bucket->mutex);
+	/* move the memory to the waiting list AKA "hot" */
+	mutex_lock(&buddy->pool->mutex);
+	list_move_tail(&chunk->chunk_list, &buddy->hot_list);
+	buddy->hot_memory_size += chunk->byte_size;
+	mutex_unlock(&buddy->pool->mutex);
 }
 
 struct mlx5dr_icm_pool *mlx5dr_icm_pool_create(struct mlx5dr_domain *dmn,
@@ -515,7 +422,6 @@ struct mlx5dr_icm_pool *mlx5dr_icm_pool_create(struct mlx5dr_domain *dmn,
 {
 	enum mlx5dr_icm_chunk_size max_log_chunk_sz;
 	struct mlx5dr_icm_pool *pool;
-	int i;
 
 	if (icm_type == DR_ICM_TYPE_STE)
 		max_log_chunk_sz = dmn->info.max_log_sw_icm_sz;
@@ -526,43 +432,24 @@ struct mlx5dr_icm_pool *mlx5dr_icm_pool_create(struct mlx5dr_domain *dmn,
 	if (!pool)
 		return NULL;
 
-	pool->buckets = kcalloc(max_log_chunk_sz + 1,
-				sizeof(pool->buckets[0]),
-				GFP_KERNEL);
-	if (!pool->buckets)
-		goto free_pool;
-
 	pool->dmn = dmn;
 	pool->icm_type = icm_type;
 	pool->max_log_chunk_sz = max_log_chunk_sz;
-	pool->num_of_buckets = max_log_chunk_sz + 1;
-	INIT_LIST_HEAD(&pool->icm_mr_list);
 
-	for (i = 0; i < pool->num_of_buckets; i++)
-		dr_icm_bucket_init(pool, &pool->buckets[i], i);
+	INIT_LIST_HEAD(&pool->buddy_mem_list);
 
-	mutex_init(&pool->mr_mutex);
+	mutex_init(&pool->mutex);
 
 	return pool;
-
-free_pool:
-	kvfree(pool);
-	return NULL;
 }
 
 void mlx5dr_icm_pool_destroy(struct mlx5dr_icm_pool *pool)
 {
-	struct mlx5dr_icm_mr *icm_mr, *next;
-	int i;
-
-	mutex_destroy(&pool->mr_mutex);
-
-	list_for_each_entry_safe(icm_mr, next, &pool->icm_mr_list, mr_list)
-		dr_icm_pool_mr_destroy(icm_mr);
+	struct mlx5dr_icm_buddy_mem *buddy, *tmp_buddy;
 
-	for (i = 0; i < pool->num_of_buckets; i++)
-		dr_icm_bucket_cleanup(&pool->buckets[i]);
+	list_for_each_entry_safe(buddy, tmp_buddy, &pool->buddy_mem_list, list_node)
+		dr_icm_buddy_destroy(buddy);
 
-	kfree(pool->buckets);
+	mutex_destroy(&pool->mutex);
 	kvfree(pool);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 0883956c58c0..f71ca74f96fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -114,7 +114,7 @@ enum mlx5dr_ipv {
 
 struct mlx5dr_icm_pool;
 struct mlx5dr_icm_chunk;
-struct mlx5dr_icm_bucket;
+struct mlx5dr_icm_buddy_mem;
 struct mlx5dr_ste_htbl;
 struct mlx5dr_match_param;
 struct mlx5dr_cmd_caps;
@@ -799,7 +799,7 @@ void mlx5dr_rule_update_rule_member(struct mlx5dr_ste *new_ste,
 				    struct mlx5dr_ste *ste);
 
 struct mlx5dr_icm_chunk {
-	struct mlx5dr_icm_bucket *bucket;
+	struct mlx5dr_icm_buddy_mem *buddy_mem;
 	struct list_head chunk_list;
 	u32 rkey;
 	u32 num_of_entries;
@@ -807,6 +807,11 @@ struct mlx5dr_icm_chunk {
 	u64 icm_addr;
 	u64 mr_addr;
 
+	/* indicates the index of this chunk in the whole memory,
+	 * used for deleting the chunk from the buddy
+	 */
+	unsigned int seg;
+
 	/* Memory optimisation */
 	struct mlx5dr_ste *ste_arr;
 	u8 *hw_ste_arr;
@@ -852,6 +857,15 @@ int mlx5dr_matcher_select_builders(struct mlx5dr_matcher *matcher,
 				   enum mlx5dr_ipv outer_ipv,
 				   enum mlx5dr_ipv inner_ipv);
 
+static inline int
+mlx5dr_icm_pool_dm_type_to_entry_size(enum mlx5dr_icm_type icm_type)
+{
+	if (icm_type == DR_ICM_TYPE_STE)
+		return DR_STE_SIZE;
+
+	return DR_MODIFY_ACTION_SIZE;
+}
+
 static inline u32
 mlx5dr_icm_pool_chunk_size_to_entries(enum mlx5dr_icm_chunk_size chunk_size)
 {
@@ -865,11 +879,7 @@ mlx5dr_icm_pool_chunk_size_to_byte(enum mlx5dr_icm_chunk_size chunk_size,
 	int num_of_entries;
 	int entry_size;
 
-	if (icm_type == DR_ICM_TYPE_STE)
-		entry_size = DR_STE_SIZE;
-	else
-		entry_size = DR_MODIFY_ACTION_SIZE;
-
+	entry_size = mlx5dr_icm_pool_dm_type_to_entry_size(icm_type);
 	num_of_entries = mlx5dr_icm_pool_chunk_size_to_entries(chunk_size);
 
 	return entry_size * num_of_entries;
-- 
2.26.2

