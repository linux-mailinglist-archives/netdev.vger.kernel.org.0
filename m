Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583D260FAF6
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbiJ0O6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235957AbiJ0O56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:57:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4C8181977
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 07:57:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EEB00B82641
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 14:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B81C433C1;
        Thu, 27 Oct 2022 14:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666882673;
        bh=m2kCh7nu4LyG9+UUYxG14cDM5RBatnYdvO/fm3FK1X8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d8iXwxvEUpAc9w47W8wM7dhLeQiki7LZUJETaAakICm2pRfbEWJiq9V+uW4/PrsJp
         oYiySCycddxeigGX55LWd1qvy53kD6UIBeuAS/z7XCDC+D2k6eyP5R6nfCVy7hHrIW
         2B/ZujEAiBzB7rAM5qrp66nX33PrJvvDCExnGL61bNjpiuZ2rvSqmHhgzWKz/fMjYG
         794HUTggotWmh//mFlotkvNaI5QLfr4Chs/iFlQFhYchGCu4nmQmofKWzTjs4UO3jN
         OOeDEkZ2MqsG9IZAIFa+NNvNTBw7zybg5O31NyJrj1XHrvNzj42FG6Xby6ESawg6vm
         Ux0WncpMxwKUA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next V2 13/14] net/mlx5: DR, Keep track of hot ICM chunks in an array instead of list
Date:   Thu, 27 Oct 2022 15:56:42 +0100
Message-Id: <20221027145643.6618-14-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221027145643.6618-1-saeed@kernel.org>
References: <20221027145643.6618-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

When ICM chunk is freed, it might still be accessed by HW until we do
sync with HW. This sync is expensive operation, so we don't do it often.
Instead, when the chunk is freed, it is moved to the buddy's "hot memory"
list. Once sync is done, we traverse the hot list and finally free all
the chunks.

It appears that traversing a long list takes unusually long time due to cache
misses on many entries, which causes a big "hiccup" during rule insertion.

This patch deals with this issue the following way:
 - Move hot chunks list from buddy to pool, so that the pool will
   keep track of all its hot memory.
 - Replace the list with pre-allocated array on the memory pool struct,
   and store only the information that is needed to later free this
   chunk in its buddy allocator.
   This cost additional memory for the array that is dynamically
   allocated, but it allows not to save long list of hot chunks,
   so at peak times it actually saves memory due to the fact that
   each array entry is much smaller than the chunk struct.

This way an overhead of traversing the long list is virtually removed:
the loop of freeing hot chunks takes ~27 msec instead of ~70 msec, where
most of it are the actual freeing activities.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_buddy.c    |  1 -
 .../mellanox/mlx5/core/steering/dr_icm_pool.c | 85 +++++++++++++++----
 .../mellanox/mlx5/core/steering/dr_types.h    |  1 +
 .../mellanox/mlx5/core/steering/mlx5dr.h      |  6 --
 4 files changed, 71 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_buddy.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_buddy.c
index 7df11a019df9..7e30dc64c10c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_buddy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_buddy.c
@@ -16,7 +16,6 @@ int mlx5dr_buddy_init(struct mlx5dr_icm_buddy_mem *buddy,
 
 	INIT_LIST_HEAD(&buddy->list_node);
 	INIT_LIST_HEAD(&buddy->used_list);
-	INIT_LIST_HEAD(&buddy->hot_list);
 
 	buddy->bitmap = kcalloc(buddy->max_order + 1,
 				sizeof(*buddy->bitmap),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index 286b7ce6bc0b..c31608a3f11c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -6,6 +6,12 @@
 #define DR_ICM_MODIFY_HDR_ALIGN_BASE 64
 #define DR_ICM_POOL_HOT_MEMORY_FRACTION 4
 
+struct mlx5dr_icm_hot_chunk {
+	struct mlx5dr_icm_buddy_mem *buddy_mem;
+	unsigned int seg;
+	enum mlx5dr_icm_chunk_size size;
+};
+
 struct mlx5dr_icm_pool {
 	enum mlx5dr_icm_type icm_type;
 	enum mlx5dr_icm_chunk_size max_log_chunk_sz;
@@ -15,6 +21,13 @@ struct mlx5dr_icm_pool {
 	/* memory management */
 	struct mutex mutex; /* protect the ICM pool and ICM buddy */
 	struct list_head buddy_mem_list;
+
+	/* Hardware may be accessing this memory but at some future,
+	 * undetermined time, it might cease to do so.
+	 * sync_ste command sets them free.
+	 */
+	struct mlx5dr_icm_hot_chunk *hot_chunks_arr;
+	u32 hot_chunks_num;
 	u64 hot_memory_size;
 };
 
@@ -286,9 +299,6 @@ static void dr_icm_buddy_destroy(struct mlx5dr_icm_buddy_mem *buddy)
 {
 	struct mlx5dr_icm_chunk *chunk, *next;
 
-	list_for_each_entry_safe(chunk, next, &buddy->hot_list, chunk_list)
-		dr_icm_chunk_destroy(chunk);
-
 	list_for_each_entry_safe(chunk, next, &buddy->used_list, chunk_list)
 		dr_icm_chunk_destroy(chunk);
 
@@ -347,10 +357,28 @@ static bool dr_icm_pool_is_sync_required(struct mlx5dr_icm_pool *pool)
 	return pool->hot_memory_size > allow_hot_size;
 }
 
+static void dr_icm_pool_clear_hot_chunks_arr(struct mlx5dr_icm_pool *pool)
+{
+	struct mlx5dr_icm_hot_chunk *hot_chunk;
+	u32 i, num_entries;
+
+	for (i = 0; i < pool->hot_chunks_num; i++) {
+		hot_chunk = &pool->hot_chunks_arr[i];
+		num_entries = mlx5dr_icm_pool_chunk_size_to_entries(hot_chunk->size);
+		mlx5dr_buddy_free_mem(hot_chunk->buddy_mem,
+				      hot_chunk->seg, ilog2(num_entries));
+		hot_chunk->buddy_mem->used_memory -=
+			mlx5dr_icm_pool_chunk_size_to_byte(hot_chunk->size,
+							   pool->icm_type);
+	}
+
+	pool->hot_chunks_num = 0;
+	pool->hot_memory_size = 0;
+}
+
 static int dr_icm_pool_sync_all_buddy_pools(struct mlx5dr_icm_pool *pool)
 {
 	struct mlx5dr_icm_buddy_mem *buddy, *tmp_buddy;
-	u32 num_entries;
 	int err;
 
 	err = mlx5dr_cmd_sync_steering(pool->dmn->mdev);
@@ -359,16 +387,9 @@ static int dr_icm_pool_sync_all_buddy_pools(struct mlx5dr_icm_pool *pool)
 		return err;
 	}
 
-	list_for_each_entry_safe(buddy, tmp_buddy, &pool->buddy_mem_list, list_node) {
-		struct mlx5dr_icm_chunk *chunk, *tmp_chunk;
-
-		list_for_each_entry_safe(chunk, tmp_chunk, &buddy->hot_list, chunk_list) {
-			num_entries = mlx5dr_icm_pool_get_chunk_num_of_entries(chunk);
-			mlx5dr_buddy_free_mem(buddy, chunk->seg, ilog2(num_entries));
-			pool->hot_memory_size -= mlx5dr_icm_pool_get_chunk_byte_size(chunk);
-			dr_icm_chunk_destroy(chunk);
-		}
+	dr_icm_pool_clear_hot_chunks_arr(pool);
 
+	list_for_each_entry_safe(buddy, tmp_buddy, &pool->buddy_mem_list, list_node) {
 		if (!buddy->used_memory && pool->icm_type == DR_ICM_TYPE_STE)
 			dr_icm_buddy_destroy(buddy);
 	}
@@ -459,12 +480,24 @@ void mlx5dr_icm_free_chunk(struct mlx5dr_icm_chunk *chunk)
 {
 	struct mlx5dr_icm_buddy_mem *buddy = chunk->buddy_mem;
 	struct mlx5dr_icm_pool *pool = buddy->pool;
+	struct mlx5dr_icm_hot_chunk *hot_chunk;
+	struct kmem_cache *chunks_cache;
+
+	chunks_cache = pool->chunks_kmem_cache;
 
-	/* move the memory to the waiting list AKA "hot" */
+	/* move the chunk to the waiting chunks array, AKA "hot" memory */
 	mutex_lock(&pool->mutex);
-	list_move_tail(&chunk->chunk_list, &buddy->hot_list);
+
 	pool->hot_memory_size += mlx5dr_icm_pool_get_chunk_byte_size(chunk);
 
+	hot_chunk = &pool->hot_chunks_arr[pool->hot_chunks_num++];
+	hot_chunk->buddy_mem = chunk->buddy_mem;
+	hot_chunk->seg = chunk->seg;
+	hot_chunk->size = chunk->size;
+
+	list_del(&chunk->chunk_list);
+	kmem_cache_free(chunks_cache, chunk);
+
 	/* Check if we have chunks that are waiting for sync-ste */
 	if (dr_icm_pool_is_sync_required(pool))
 		dr_icm_pool_sync_all_buddy_pools(pool);
@@ -485,6 +518,7 @@ void mlx5dr_icm_pool_free_htbl(struct mlx5dr_icm_pool *pool, struct mlx5dr_ste_h
 struct mlx5dr_icm_pool *mlx5dr_icm_pool_create(struct mlx5dr_domain *dmn,
 					       enum mlx5dr_icm_type icm_type)
 {
+	u32 num_of_chunks, entry_size, max_hot_size;
 	enum mlx5dr_icm_chunk_size max_log_chunk_sz;
 	struct mlx5dr_icm_pool *pool;
 
@@ -506,16 +540,37 @@ struct mlx5dr_icm_pool *mlx5dr_icm_pool_create(struct mlx5dr_domain *dmn,
 
 	mutex_init(&pool->mutex);
 
+	entry_size = mlx5dr_icm_pool_dm_type_to_entry_size(pool->icm_type);
+
+	max_hot_size = mlx5dr_icm_pool_chunk_size_to_byte(pool->max_log_chunk_sz,
+							  pool->icm_type) /
+		       DR_ICM_POOL_HOT_MEMORY_FRACTION;
+
+	num_of_chunks = DIV_ROUND_UP(max_hot_size, entry_size) + 1;
+
+	pool->hot_chunks_arr = kvcalloc(num_of_chunks,
+					sizeof(struct mlx5dr_icm_hot_chunk),
+					GFP_KERNEL);
+	if (!pool->hot_chunks_arr)
+		goto free_pool;
+
 	return pool;
+
+free_pool:
+	kvfree(pool);
+	return NULL;
 }
 
 void mlx5dr_icm_pool_destroy(struct mlx5dr_icm_pool *pool)
 {
 	struct mlx5dr_icm_buddy_mem *buddy, *tmp_buddy;
 
+	dr_icm_pool_clear_hot_chunks_arr(pool);
+
 	list_for_each_entry_safe(buddy, tmp_buddy, &pool->buddy_mem_list, list_node)
 		dr_icm_buddy_destroy(buddy);
 
+	kvfree(pool->hot_chunks_arr);
 	mutex_destroy(&pool->mutex);
 	kvfree(pool);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index b645c0ab9a72..bd2c3073591e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -147,6 +147,7 @@ struct mlx5dr_rule_rx_tx;
 struct mlx5dr_matcher_rx_tx;
 struct mlx5dr_ste_ctx;
 struct mlx5dr_send_info_pool;
+struct mlx5dr_icm_hot_chunk;
 
 struct mlx5dr_ste {
 	/* refcount: indicates the num of rules that using this ste */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 226a0d7bb06d..674efb3607b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -168,12 +168,6 @@ struct mlx5dr_icm_buddy_mem {
 	struct list_head	used_list;
 	u64			used_memory;
 
-	/* Hardware may be accessing this memory but at some future,
-	 * undetermined time, it might cease to do so.
-	 * sync_ste command sets them free.
-	 */
-	struct list_head	hot_list;
-
 	/* Memory optimisation */
 	struct mlx5dr_ste	*ste_arr;
 	struct list_head	*miss_list;
-- 
2.37.3

