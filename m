Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27C284DCE28
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237743AbiCQS4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237738AbiCQSzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:55:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B531165AA5
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 11:54:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E99F0B81F9C
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 18:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413AAC340F3;
        Thu, 17 Mar 2022 18:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647543273;
        bh=8rZd9+jOy451KpypIcYhaTH1PW1J52VLGOI4/xySYww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Npz0HYzypQeUzLj0rbGDD7pzoOD84hmVTuiLhwGMwYu8O/Vgd7h3fa+RYj5VKymyo
         gd4xTw74mw0Ks1cZTbTvKlO+m/MhCqAJpK8njIAfw2I0mI1IHoAfyem+Z+vLzKNUqR
         Pc33Fm8CBgyBi6dN9yxHD8w3UK7CUUTGkZ9UZ1i4HtwKx842FuQh/zIg6nI5KJ6e7X
         pIgeJVRXY7dX68kSui/avQqRXHrvX2mrH7aezSZSA4tFdGg0Lh/ZEx4+iFvuDt7gEa
         gC4o7sHOf+wLh24bpaQAusIJg628fcAjeSPpiRDpQJlMc5DCu9NL7c0uzjPU9oVEFu
         mJUFfN1lhpeiQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Rongwei Liu <rongweil@nvidia.com>,
        Shun Hao <shunh@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/15] net/mlx5: DR, Remove num_of_entries byte_size from struct mlx5_dr_icm_chunk
Date:   Thu, 17 Mar 2022 11:54:19 -0700
Message-Id: <20220317185424.287982-11-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317185424.287982-1-saeed@kernel.org>
References: <20220317185424.287982-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rongwei Liu <rongweil@nvidia.com>

Target to reduce the memory consumption in large scale of flow rules.

They can be calculated quickly from buddy memory pool.
1. num_of_entries calls dr_icm_pool_get_chunk_num_of_entries().
2. byte_size calls dr_icm_pool_get_chunk_byte_size().

Use chunk size in dr_icm_chunk to speed up and the one in dr_ste_htbl
will be removed in the upcoming commit.

This commit reduce 8 bytes from struct mlx5_dr_icm_chunk and its
current size is 56 bytes.

Signed-off-by: Rongwei Liu <rongweil@nvidia.com>
Reviewed-by: Shun Hao <shunh@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_icm_pool.c | 34 ++++++++++++-------
 .../mellanox/mlx5/core/steering/dr_rule.c     |  2 +-
 .../mellanox/mlx5/core/steering/dr_send.c     | 12 +++----
 .../mellanox/mlx5/core/steering/dr_ste.c      | 16 +++++----
 .../mellanox/mlx5/core/steering/dr_types.h    |  5 +--
 5 files changed, 42 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index 539af89da629..4ca67fa24cc6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -76,6 +76,17 @@ u64 mlx5dr_icm_pool_get_chunk_icm_addr(struct mlx5dr_icm_chunk *chunk)
 	return (u64)chunk->buddy_mem->icm_mr->icm_start_addr + size * chunk->seg;
 }
 
+u32 mlx5dr_icm_pool_get_chunk_byte_size(struct mlx5dr_icm_chunk *chunk)
+{
+	return mlx5dr_icm_pool_chunk_size_to_byte(chunk->size,
+			chunk->buddy_mem->pool->icm_type);
+}
+
+u32 mlx5dr_icm_pool_get_chunk_num_of_entries(struct mlx5dr_icm_chunk *chunk)
+{
+	return mlx5dr_icm_pool_chunk_size_to_entries(chunk->size);
+}
+
 static struct mlx5dr_icm_mr *
 dr_icm_pool_mr_create(struct mlx5dr_icm_pool *pool)
 {
@@ -177,12 +188,13 @@ static void dr_icm_chunk_ste_init(struct mlx5dr_icm_chunk *chunk, int offset)
 
 static void dr_icm_chunk_ste_cleanup(struct mlx5dr_icm_chunk *chunk)
 {
+	int num_of_entries = mlx5dr_icm_pool_get_chunk_num_of_entries(chunk);
 	struct mlx5dr_icm_buddy_mem *buddy = chunk->buddy_mem;
 
 	memset(chunk->hw_ste_arr, 0,
-	       chunk->num_of_entries * dr_icm_buddy_get_ste_size(buddy));
+	       num_of_entries * dr_icm_buddy_get_ste_size(buddy));
 	memset(chunk->ste_arr, 0,
-	       chunk->num_of_entries * sizeof(chunk->ste_arr[0]));
+	       num_of_entries * sizeof(chunk->ste_arr[0]));
 }
 
 static enum mlx5dr_icm_type
@@ -196,7 +208,7 @@ static void dr_icm_chunk_destroy(struct mlx5dr_icm_chunk *chunk,
 {
 	enum mlx5dr_icm_type icm_type = get_chunk_icm_type(chunk);
 
-	buddy->used_memory -= chunk->byte_size;
+	buddy->used_memory -= mlx5dr_icm_pool_get_chunk_byte_size(chunk);
 	list_del(&chunk->chunk_list);
 
 	if (icm_type == DR_ICM_TYPE_STE)
@@ -317,17 +329,14 @@ dr_icm_chunk_create(struct mlx5dr_icm_pool *pool,
 
 	offset = mlx5dr_icm_pool_dm_type_to_entry_size(pool->icm_type) * seg;
 
-	chunk->num_of_entries =
-		mlx5dr_icm_pool_chunk_size_to_entries(chunk_size);
-	chunk->byte_size =
-		mlx5dr_icm_pool_chunk_size_to_byte(chunk_size, pool->icm_type);
 	chunk->seg = seg;
+	chunk->size = chunk_size;
 	chunk->buddy_mem = buddy_mem_pool;
 
 	if (pool->icm_type == DR_ICM_TYPE_STE)
 		dr_icm_chunk_ste_init(chunk, offset);
 
-	buddy_mem_pool->used_memory += chunk->byte_size;
+	buddy_mem_pool->used_memory += mlx5dr_icm_pool_get_chunk_byte_size(chunk);
 	INIT_LIST_HEAD(&chunk->chunk_list);
 
 	/* chunk now is part of the used_list */
@@ -351,6 +360,7 @@ static bool dr_icm_pool_is_sync_required(struct mlx5dr_icm_pool *pool)
 static int dr_icm_pool_sync_all_buddy_pools(struct mlx5dr_icm_pool *pool)
 {
 	struct mlx5dr_icm_buddy_mem *buddy, *tmp_buddy;
+	u32 num_entries;
 	int err;
 
 	err = mlx5dr_cmd_sync_steering(pool->dmn->mdev);
@@ -363,9 +373,9 @@ static int dr_icm_pool_sync_all_buddy_pools(struct mlx5dr_icm_pool *pool)
 		struct mlx5dr_icm_chunk *chunk, *tmp_chunk;
 
 		list_for_each_entry_safe(chunk, tmp_chunk, &buddy->hot_list, chunk_list) {
-			mlx5dr_buddy_free_mem(buddy, chunk->seg,
-					      ilog2(chunk->num_of_entries));
-			pool->hot_memory_size -= chunk->byte_size;
+			num_entries = mlx5dr_icm_pool_get_chunk_num_of_entries(chunk);
+			mlx5dr_buddy_free_mem(buddy, chunk->seg, ilog2(num_entries));
+			pool->hot_memory_size -= mlx5dr_icm_pool_get_chunk_byte_size(chunk);
 			dr_icm_chunk_destroy(chunk, buddy);
 		}
 
@@ -463,7 +473,7 @@ void mlx5dr_icm_free_chunk(struct mlx5dr_icm_chunk *chunk)
 	/* move the memory to the waiting list AKA "hot" */
 	mutex_lock(&pool->mutex);
 	list_move_tail(&chunk->chunk_list, &buddy->hot_list);
-	pool->hot_memory_size += chunk->byte_size;
+	pool->hot_memory_size += mlx5dr_icm_pool_get_chunk_byte_size(chunk);
 
 	/* Check if we have chunks that are waiting for sync-ste */
 	if (dr_icm_pool_is_sync_required(pool))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index e76c1fda2ac9..91be9d9d95a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -450,7 +450,7 @@ dr_rule_rehash_htbl(struct mlx5dr_rule *rule,
 		mlx5dr_ste_set_hit_addr(dmn->ste_ctx,
 					prev_htbl->ste_arr[0].hw_ste,
 					mlx5dr_icm_pool_get_chunk_icm_addr(new_htbl->chunk),
-					new_htbl->chunk->num_of_entries);
+					mlx5dr_icm_pool_get_chunk_num_of_entries(new_htbl->chunk));
 
 		ste_to_update = &prev_htbl->ste_arr[0];
 	} else {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 57765d231993..e0470dbd3116 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -407,17 +407,17 @@ static int dr_get_tbl_copy_details(struct mlx5dr_domain *dmn,
 				   int *iterations,
 				   int *num_stes)
 {
+	u32 chunk_byte_size = mlx5dr_icm_pool_get_chunk_byte_size(htbl->chunk);
 	int alloc_size;
 
-	if (htbl->chunk->byte_size > dmn->send_ring->max_post_send_size) {
-		*iterations = htbl->chunk->byte_size /
-			dmn->send_ring->max_post_send_size;
+	if (chunk_byte_size > dmn->send_ring->max_post_send_size) {
+		*iterations = chunk_byte_size / dmn->send_ring->max_post_send_size;
 		*byte_size = dmn->send_ring->max_post_send_size;
 		alloc_size = *byte_size;
 		*num_stes = *byte_size / DR_STE_SIZE;
 	} else {
 		*iterations = 1;
-		*num_stes = htbl->chunk->num_of_entries;
+		*num_stes = mlx5dr_icm_pool_get_chunk_num_of_entries(htbl->chunk);
 		alloc_size = *num_stes * DR_STE_SIZE;
 	}
 
@@ -462,7 +462,7 @@ int mlx5dr_send_postsend_htbl(struct mlx5dr_domain *dmn,
 			      struct mlx5dr_ste_htbl *htbl,
 			      u8 *formatted_ste, u8 *mask)
 {
-	u32 byte_size = htbl->chunk->byte_size;
+	u32 byte_size = mlx5dr_icm_pool_get_chunk_byte_size(htbl->chunk);
 	int num_stes_per_iter;
 	int iterations;
 	u8 *data;
@@ -530,7 +530,7 @@ int mlx5dr_send_postsend_formatted_htbl(struct mlx5dr_domain *dmn,
 					u8 *ste_init_data,
 					bool update_hw_ste)
 {
-	u32 byte_size = htbl->chunk->byte_size;
+	u32 byte_size = mlx5dr_icm_pool_get_chunk_byte_size(htbl->chunk);
 	int iterations;
 	int num_stes;
 	u8 *copy_dst;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 0208b859205c..3ff568e80e0e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -25,6 +25,7 @@ bool mlx5dr_ste_supp_ttl_cs_recalc(struct mlx5dr_cmd_caps *caps)
 
 u32 mlx5dr_ste_calc_hash_index(u8 *hw_ste_p, struct mlx5dr_ste_htbl *htbl)
 {
+	u32 num_entries = mlx5dr_icm_pool_get_chunk_num_of_entries(htbl->chunk);
 	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)hw_ste_p;
 	u8 masked[DR_STE_SIZE_TAG] = {};
 	u32 crc32, index;
@@ -32,7 +33,7 @@ u32 mlx5dr_ste_calc_hash_index(u8 *hw_ste_p, struct mlx5dr_ste_htbl *htbl)
 	int i;
 
 	/* Don't calculate CRC if the result is predicted */
-	if (htbl->chunk->num_of_entries == 1 || htbl->byte_mask == 0)
+	if (num_entries == 1 || htbl->byte_mask == 0)
 		return 0;
 
 	/* Mask tag using byte mask, bit per byte */
@@ -45,7 +46,7 @@ u32 mlx5dr_ste_calc_hash_index(u8 *hw_ste_p, struct mlx5dr_ste_htbl *htbl)
 	}
 
 	crc32 = dr_ste_crc32_calc(masked, DR_STE_SIZE_TAG);
-	index = crc32 & (htbl->chunk->num_of_entries - 1);
+	index = crc32 & (num_entries - 1);
 
 	return index;
 }
@@ -143,7 +144,7 @@ static void dr_ste_always_hit_htbl(struct mlx5dr_ste_ctx *ste_ctx,
 	ste_ctx->set_byte_mask(hw_ste, next_htbl->byte_mask);
 	ste_ctx->set_next_lu_type(hw_ste, next_htbl->lu_type);
 	ste_ctx->set_hit_addr(hw_ste, mlx5dr_icm_pool_get_chunk_icm_addr(chunk),
-			      chunk->num_of_entries);
+			      mlx5dr_icm_pool_get_chunk_num_of_entries(chunk));
 
 	dr_ste_set_always_hit((struct dr_hw_ste_format *)ste->hw_ste);
 }
@@ -367,9 +368,10 @@ void mlx5dr_ste_set_hit_addr_by_next_htbl(struct mlx5dr_ste_ctx *ste_ctx,
 					  struct mlx5dr_ste_htbl *next_htbl)
 {
 	u64 icm_addr = mlx5dr_icm_pool_get_chunk_icm_addr(next_htbl->chunk);
-	struct mlx5dr_icm_chunk *chunk = next_htbl->chunk;
+	u32 num_entries =
+		mlx5dr_icm_pool_get_chunk_num_of_entries(next_htbl->chunk);
 
-	ste_ctx->set_hit_addr(hw_ste, icm_addr, chunk->num_of_entries);
+	ste_ctx->set_hit_addr(hw_ste, icm_addr, num_entries);
 }
 
 void mlx5dr_ste_prepare_for_postsend(struct mlx5dr_ste_ctx *ste_ctx,
@@ -474,6 +476,7 @@ struct mlx5dr_ste_htbl *mlx5dr_ste_htbl_alloc(struct mlx5dr_icm_pool *pool,
 {
 	struct mlx5dr_icm_chunk *chunk;
 	struct mlx5dr_ste_htbl *htbl;
+	u32 num_entries;
 	int i;
 
 	htbl = kzalloc(sizeof(*htbl), GFP_KERNEL);
@@ -491,8 +494,9 @@ struct mlx5dr_ste_htbl *mlx5dr_ste_htbl_alloc(struct mlx5dr_icm_pool *pool,
 	htbl->hw_ste_arr = chunk->hw_ste_arr;
 	htbl->miss_list = chunk->miss_list;
 	htbl->refcount = 0;
+	num_entries = mlx5dr_icm_pool_get_chunk_num_of_entries(chunk);
 
-	for (i = 0; i < chunk->num_of_entries; i++) {
+	for (i = 0; i < num_entries; i++) {
 		struct mlx5dr_ste *ste = &htbl->ste_arr[i];
 
 		ste->hw_ste = htbl->hw_ste_arr + i * DR_STE_SIZE_REDUCED;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 4fe0c8c623ce..9660296d36aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1097,13 +1097,12 @@ int mlx5dr_rule_get_reverse_rule_members(struct mlx5dr_ste **ste_arr,
 struct mlx5dr_icm_chunk {
 	struct mlx5dr_icm_buddy_mem *buddy_mem;
 	struct list_head chunk_list;
-	u32 num_of_entries;
-	u32 byte_size;
 
 	/* indicates the index of this chunk in the whole memory,
 	 * used for deleting the chunk from the buddy
 	 */
 	unsigned int seg;
+	enum mlx5dr_icm_chunk_size size;
 
 	/* Memory optimisation */
 	struct mlx5dr_ste *ste_arr;
@@ -1146,6 +1145,8 @@ int mlx5dr_matcher_select_builders(struct mlx5dr_matcher *matcher,
 u64 mlx5dr_icm_pool_get_chunk_mr_addr(struct mlx5dr_icm_chunk *chunk);
 u32 mlx5dr_icm_pool_get_chunk_rkey(struct mlx5dr_icm_chunk *chunk);
 u64 mlx5dr_icm_pool_get_chunk_icm_addr(struct mlx5dr_icm_chunk *chunk);
+u32 mlx5dr_icm_pool_get_chunk_num_of_entries(struct mlx5dr_icm_chunk *chunk);
+u32 mlx5dr_icm_pool_get_chunk_byte_size(struct mlx5dr_icm_chunk *chunk);
 
 static inline int
 mlx5dr_icm_pool_dm_type_to_entry_size(enum mlx5dr_icm_type icm_type)
-- 
2.35.1

