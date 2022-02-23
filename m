Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04A54C195C
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243154AbiBWRFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243123AbiBWRFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:05:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F1B50B28
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:04:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78D92B8211B
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 17:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF96C340E7;
        Wed, 23 Feb 2022 17:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645635878;
        bh=3tiNQjyhau6u2L4Lcs99yliCP9JgIzgMv8Xyv8MYAk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5G80TYBFQalzckuq6x8aWVfDjPdsM7snMluB7puc0WW5j/9tT0+60I8jv8Xysmyi
         9qs3Or1plIb3bxqgabRthGPYZR2rpoTW9IdCobRsK0pk9xZJewvp5RBr6KkwxmONZ1
         ZgQgxYHuoL7s5UumLTSm6lyZ2C7gRhwsvUKPFGaYTLqWKEZJ7Ny3TOiaZ/FjP4Ymmz
         I4WrEpv2x7CBVgBjmLk1KZ4FhRGDhA8gSQYiETLSxubbUxSUI+9dWIPziKOE2foVgB
         dvloB6jkcAtTpKENaprVQR7jjUcbmfzLNY/MdDsbJUrW5pPAazbPG4P+IFsv5Sg7ky
         4x37vs4Kpkckw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 02/19] net/mlx5: DR, Cache STE shadow memory
Date:   Wed, 23 Feb 2022 09:04:13 -0800
Message-Id: <20220223170430.295595-3-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223170430.295595-1-saeed@kernel.org>
References: <20220223170430.295595-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

During rule insertion on each ICM memory chunk we also allocate shadow memory
used for management. This includes the hw_ste, dr_ste and miss list per entry.
Since the scale of these allocations is large we noticed a performance hiccup
that happens once malloc and free are stressed.
In extreme usecases when ~1M chunks are freed at once, it might take up to 40
seconds to complete this, up to the point the kernel sees this as self-detected
stall on CPU:

 rcu: INFO: rcu_sched self-detected stall on CPU

To resolve this we will increase the reuse of shadow memory.
Doing this we see that a time in the aforementioned usecase dropped from ~40
seconds to ~8-10 seconds.

Fixes: 29cf8febd185 ("net/mlx5: DR, ICM pool memory allocator")
Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_icm_pool.c | 109 ++++++++++++------
 .../mellanox/mlx5/core/steering/mlx5dr.h      |   5 +
 2 files changed, 79 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index 7f6fd9c5e371..f496b7e9401b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -136,37 +136,35 @@ static void dr_icm_pool_mr_destroy(struct mlx5dr_icm_mr *icm_mr)
 	kvfree(icm_mr);
 }
 
-static int dr_icm_chunk_ste_init(struct mlx5dr_icm_chunk *chunk)
+static int dr_icm_buddy_get_ste_size(struct mlx5dr_icm_buddy_mem *buddy)
 {
-	chunk->ste_arr = kvzalloc(chunk->num_of_entries *
-				  sizeof(chunk->ste_arr[0]), GFP_KERNEL);
-	if (!chunk->ste_arr)
-		return -ENOMEM;
-
-	chunk->hw_ste_arr = kvzalloc(chunk->num_of_entries *
-				     DR_STE_SIZE_REDUCED, GFP_KERNEL);
-	if (!chunk->hw_ste_arr)
-		goto out_free_ste_arr;
-
-	chunk->miss_list = kvmalloc(chunk->num_of_entries *
-				    sizeof(chunk->miss_list[0]), GFP_KERNEL);
-	if (!chunk->miss_list)
-		goto out_free_hw_ste_arr;
+	/* We support only one type of STE size, both for ConnectX-5 and later
+	 * devices. Once the support for match STE which has a larger tag is
+	 * added (32B instead of 16B), the STE size for devices later than
+	 * ConnectX-5 needs to account for that.
+	 */
+	return DR_STE_SIZE_REDUCED;
+}
 
-	return 0;
+static void dr_icm_chunk_ste_init(struct mlx5dr_icm_chunk *chunk, int offset)
+{
+	struct mlx5dr_icm_buddy_mem *buddy = chunk->buddy_mem;
+	int index = offset / DR_STE_SIZE;
 
-out_free_hw_ste_arr:
-	kvfree(chunk->hw_ste_arr);
-out_free_ste_arr:
-	kvfree(chunk->ste_arr);
-	return -ENOMEM;
+	chunk->ste_arr = &buddy->ste_arr[index];
+	chunk->miss_list = &buddy->miss_list[index];
+	chunk->hw_ste_arr = buddy->hw_ste_arr +
+			    index * dr_icm_buddy_get_ste_size(buddy);
 }
 
 static void dr_icm_chunk_ste_cleanup(struct mlx5dr_icm_chunk *chunk)
 {
-	kvfree(chunk->miss_list);
-	kvfree(chunk->hw_ste_arr);
-	kvfree(chunk->ste_arr);
+	struct mlx5dr_icm_buddy_mem *buddy = chunk->buddy_mem;
+
+	memset(chunk->hw_ste_arr, 0,
+	       chunk->num_of_entries * dr_icm_buddy_get_ste_size(buddy));
+	memset(chunk->ste_arr, 0,
+	       chunk->num_of_entries * sizeof(chunk->ste_arr[0]));
 }
 
 static enum mlx5dr_icm_type
@@ -189,6 +187,44 @@ static void dr_icm_chunk_destroy(struct mlx5dr_icm_chunk *chunk,
 	kvfree(chunk);
 }
 
+static int dr_icm_buddy_init_ste_cache(struct mlx5dr_icm_buddy_mem *buddy)
+{
+	int num_of_entries =
+		mlx5dr_icm_pool_chunk_size_to_entries(buddy->pool->max_log_chunk_sz);
+
+	buddy->ste_arr = kvcalloc(num_of_entries,
+				  sizeof(struct mlx5dr_ste), GFP_KERNEL);
+	if (!buddy->ste_arr)
+		return -ENOMEM;
+
+	/* Preallocate full STE size on non-ConnectX-5 devices since
+	 * we need to support both full and reduced with the same cache.
+	 */
+	buddy->hw_ste_arr = kvcalloc(num_of_entries,
+				     dr_icm_buddy_get_ste_size(buddy), GFP_KERNEL);
+	if (!buddy->hw_ste_arr)
+		goto free_ste_arr;
+
+	buddy->miss_list = kvmalloc(num_of_entries * sizeof(struct list_head), GFP_KERNEL);
+	if (!buddy->miss_list)
+		goto free_hw_ste_arr;
+
+	return 0;
+
+free_hw_ste_arr:
+	kvfree(buddy->hw_ste_arr);
+free_ste_arr:
+	kvfree(buddy->ste_arr);
+	return -ENOMEM;
+}
+
+static void dr_icm_buddy_cleanup_ste_cache(struct mlx5dr_icm_buddy_mem *buddy)
+{
+	kvfree(buddy->ste_arr);
+	kvfree(buddy->hw_ste_arr);
+	kvfree(buddy->miss_list);
+}
+
 static int dr_icm_buddy_create(struct mlx5dr_icm_pool *pool)
 {
 	struct mlx5dr_icm_buddy_mem *buddy;
@@ -208,11 +244,19 @@ static int dr_icm_buddy_create(struct mlx5dr_icm_pool *pool)
 	buddy->icm_mr = icm_mr;
 	buddy->pool = pool;
 
+	if (pool->icm_type == DR_ICM_TYPE_STE) {
+		/* Reduce allocations by preallocating and reusing the STE structures */
+		if (dr_icm_buddy_init_ste_cache(buddy))
+			goto err_cleanup_buddy;
+	}
+
 	/* add it to the -start- of the list in order to search in it first */
 	list_add(&buddy->list_node, &pool->buddy_mem_list);
 
 	return 0;
 
+err_cleanup_buddy:
+	mlx5dr_buddy_cleanup(buddy);
 err_free_buddy:
 	kvfree(buddy);
 free_mr:
@@ -234,6 +278,9 @@ static void dr_icm_buddy_destroy(struct mlx5dr_icm_buddy_mem *buddy)
 
 	mlx5dr_buddy_cleanup(buddy);
 
+	if (buddy->pool->icm_type == DR_ICM_TYPE_STE)
+		dr_icm_buddy_cleanup_ste_cache(buddy);
+
 	kvfree(buddy);
 }
 
@@ -261,26 +308,18 @@ dr_icm_chunk_create(struct mlx5dr_icm_pool *pool,
 	chunk->byte_size =
 		mlx5dr_icm_pool_chunk_size_to_byte(chunk_size, pool->icm_type);
 	chunk->seg = seg;
+	chunk->buddy_mem = buddy_mem_pool;
 
-	if (pool->icm_type == DR_ICM_TYPE_STE && dr_icm_chunk_ste_init(chunk)) {
-		mlx5dr_err(pool->dmn,
-			   "Failed to init ste arrays (order: %d)\n",
-			   chunk_size);
-		goto out_free_chunk;
-	}
+	if (pool->icm_type == DR_ICM_TYPE_STE)
+		dr_icm_chunk_ste_init(chunk, offset);
 
 	buddy_mem_pool->used_memory += chunk->byte_size;
-	chunk->buddy_mem = buddy_mem_pool;
 	INIT_LIST_HEAD(&chunk->chunk_list);
 
 	/* chunk now is part of the used_list */
 	list_add_tail(&chunk->chunk_list, &buddy_mem_pool->used_list);
 
 	return chunk;
-
-out_free_chunk:
-	kvfree(chunk);
-	return NULL;
 }
 
 static bool dr_icm_pool_is_sync_required(struct mlx5dr_icm_pool *pool)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index c7c93131b762..dfa223415fe2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -160,6 +160,11 @@ struct mlx5dr_icm_buddy_mem {
 	 * sync_ste command sets them free.
 	 */
 	struct list_head	hot_list;
+
+	/* Memory optimisation */
+	struct mlx5dr_ste	*ste_arr;
+	struct list_head	*miss_list;
+	u8			*hw_ste_arr;
 };
 
 int mlx5dr_buddy_init(struct mlx5dr_icm_buddy_mem *buddy,
-- 
2.35.1

