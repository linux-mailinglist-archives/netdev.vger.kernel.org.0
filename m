Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A724A60FAF7
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbiJ0O6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235986AbiJ0O6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:58:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D231F182C63
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 07:57:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FF9BB8267B
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 14:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D00C433D7;
        Thu, 27 Oct 2022 14:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666882677;
        bh=G+G37DZR9mnZVNUpJA2dJoYwP/IDPZljc4j+1ZjpaYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ig6z4vaa4PwYFNiHjq6pvO8yOEl0OorO5ZtSaUevUyyhCh0h8BqDbxG7L+lzSvQE2
         Bl/AulAAjhuL0QcIS7sx0EL/1JNzzN33Aqzqm8ISl4ceRBJg607u6/kqyk+yJLXxGs
         c/QvTZVovwby8AFCFIvhWL+BwdJVeUhm/jtDbCg2zMJHMv2tFfU5ezVytu0nnUFiIx
         CSt33guEKfyBbgFoBjblvV6pbhlc5d1dRCSxKkF0Zyw6FecaZYlooAJKAy6iC7Is5e
         K8FSmZOt7etsgW7dumKH06fawiYW4h9dm5kcCNksugsus12LB52xbR8oAsB1f1fvAj
         NzbSJH14NLHAw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next V2 14/14] net/mlx5: DR, Remove the buddy used_list
Date:   Thu, 27 Oct 2022 15:56:43 +0100
Message-Id: <20221027145643.6618-15-saeed@kernel.org>
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

No need to have the used_list - we don't need to keep track of the
used chunks, we only need to know the amount of used memory.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_buddy.c    |  1 -
 .../mellanox/mlx5/core/steering/dr_icm_pool.c | 50 +++++--------------
 .../mellanox/mlx5/core/steering/dr_types.h    |  1 -
 .../mellanox/mlx5/core/steering/mlx5dr.h      |  3 +-
 4 files changed, 13 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_buddy.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_buddy.c
index 7e30dc64c10c..fe228d948b47 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_buddy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_buddy.c
@@ -15,7 +15,6 @@ int mlx5dr_buddy_init(struct mlx5dr_icm_buddy_mem *buddy,
 	buddy->max_order = max_order;
 
 	INIT_LIST_HEAD(&buddy->list_node);
-	INIT_LIST_HEAD(&buddy->used_list);
 
 	buddy->bitmap = kcalloc(buddy->max_order + 1,
 				sizeof(*buddy->bitmap),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index c31608a3f11c..3eb6719bc8eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -207,17 +207,6 @@ static void dr_icm_chunk_ste_init(struct mlx5dr_icm_chunk *chunk, int offset)
 	       num_of_entries * sizeof(chunk->ste_arr[0]));
 }
 
-static void dr_icm_chunk_destroy(struct mlx5dr_icm_chunk *chunk)
-{
-	struct kmem_cache *chunks_cache =
-		chunk->buddy_mem->pool->chunks_kmem_cache;
-
-	chunk->buddy_mem->used_memory -= mlx5dr_icm_pool_get_chunk_byte_size(chunk);
-	list_del(&chunk->chunk_list);
-
-	kmem_cache_free(chunks_cache, chunk);
-}
-
 static int dr_icm_buddy_init_ste_cache(struct mlx5dr_icm_buddy_mem *buddy)
 {
 	int num_of_entries =
@@ -297,11 +286,6 @@ static int dr_icm_buddy_create(struct mlx5dr_icm_pool *pool)
 
 static void dr_icm_buddy_destroy(struct mlx5dr_icm_buddy_mem *buddy)
 {
-	struct mlx5dr_icm_chunk *chunk, *next;
-
-	list_for_each_entry_safe(chunk, next, &buddy->used_list, chunk_list)
-		dr_icm_chunk_destroy(chunk);
-
 	dr_icm_pool_mr_destroy(buddy->icm_mr);
 
 	mlx5dr_buddy_cleanup(buddy);
@@ -312,36 +296,25 @@ static void dr_icm_buddy_destroy(struct mlx5dr_icm_buddy_mem *buddy)
 	kvfree(buddy);
 }
 
-static struct mlx5dr_icm_chunk *
-dr_icm_chunk_create(struct mlx5dr_icm_pool *pool,
-		    enum mlx5dr_icm_chunk_size chunk_size,
-		    struct mlx5dr_icm_buddy_mem *buddy_mem_pool,
-		    unsigned int seg)
+static void
+dr_icm_chunk_init(struct mlx5dr_icm_chunk *chunk,
+		  struct mlx5dr_icm_pool *pool,
+		  enum mlx5dr_icm_chunk_size chunk_size,
+		  struct mlx5dr_icm_buddy_mem *buddy_mem_pool,
+		  unsigned int seg)
 {
-	struct kmem_cache *chunks_cache = buddy_mem_pool->pool->chunks_kmem_cache;
-	struct mlx5dr_icm_chunk *chunk;
 	int offset;
 
-	chunk = kmem_cache_alloc(chunks_cache, GFP_KERNEL);
-	if (!chunk)
-		return NULL;
-
-	offset = mlx5dr_icm_pool_dm_type_to_entry_size(pool->icm_type) * seg;
-
 	chunk->seg = seg;
 	chunk->size = chunk_size;
 	chunk->buddy_mem = buddy_mem_pool;
 
-	if (pool->icm_type == DR_ICM_TYPE_STE)
+	if (pool->icm_type == DR_ICM_TYPE_STE) {
+		offset = mlx5dr_icm_pool_dm_type_to_entry_size(pool->icm_type) * seg;
 		dr_icm_chunk_ste_init(chunk, offset);
+	}
 
 	buddy_mem_pool->used_memory += mlx5dr_icm_pool_get_chunk_byte_size(chunk);
-	INIT_LIST_HEAD(&chunk->chunk_list);
-
-	/* chunk now is part of the used_list */
-	list_add_tail(&chunk->chunk_list, &buddy_mem_pool->used_list);
-
-	return chunk;
 }
 
 static bool dr_icm_pool_is_sync_required(struct mlx5dr_icm_pool *pool)
@@ -463,10 +436,12 @@ mlx5dr_icm_alloc_chunk(struct mlx5dr_icm_pool *pool,
 	if (ret)
 		goto out;
 
-	chunk = dr_icm_chunk_create(pool, chunk_size, buddy, seg);
+	chunk = kmem_cache_alloc(pool->chunks_kmem_cache, GFP_KERNEL);
 	if (!chunk)
 		goto out_err;
 
+	dr_icm_chunk_init(chunk, pool, chunk_size, buddy, seg);
+
 	goto out;
 
 out_err:
@@ -495,7 +470,6 @@ void mlx5dr_icm_free_chunk(struct mlx5dr_icm_chunk *chunk)
 	hot_chunk->seg = chunk->seg;
 	hot_chunk->size = chunk->size;
 
-	list_del(&chunk->chunk_list);
 	kmem_cache_free(chunks_cache, chunk);
 
 	/* Check if we have chunks that are waiting for sync-ste */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index bd2c3073591e..41a37b9ac98b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1111,7 +1111,6 @@ int mlx5dr_rule_get_reverse_rule_members(struct mlx5dr_ste **ste_arr,
 
 struct mlx5dr_icm_chunk {
 	struct mlx5dr_icm_buddy_mem *buddy_mem;
-	struct list_head chunk_list;
 
 	/* indicates the index of this chunk in the whole memory,
 	 * used for deleting the chunk from the buddy
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 674efb3607b1..84ed77763b21 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -164,8 +164,7 @@ struct mlx5dr_icm_buddy_mem {
 	struct mlx5dr_icm_mr	*icm_mr;
 	struct mlx5dr_icm_pool	*pool;
 
-	/* This is the list of used chunks. HW may be accessing this memory */
-	struct list_head	used_list;
+	/* Amount of memory in used chunks - HW may be accessing this memory */
 	u64			used_memory;
 
 	/* Memory optimisation */
-- 
2.37.3

