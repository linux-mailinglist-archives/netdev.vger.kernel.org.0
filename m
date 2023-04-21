Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847206EA116
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 03:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbjDUBjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 21:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233095AbjDUBjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 21:39:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B725FE2
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:39:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 512F06422E
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42448C433D2;
        Fri, 21 Apr 2023 01:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682041146;
        bh=Pk7B7NU5N//S9ysWCKmIjxCCaGmo87QoHgJslM2pJVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A+OoYPAPL/ib9ULhvWPig1nw8hH09D3XJpArSAeH2DZM4WgpihgVrgK4Lz97/EZrv
         gnnwpT8/GyViw0rS2OTpYJhnNAajSkKrc21QB0tPO9/WlFBlVQrFdAXYJijkiImjU8
         k1yer2WFMi5tU6GpUBwU5x/m2Pktg9UgmXPFuLFS4EtHB8WTsXnt827xMD03Sh0+LE
         GPkS3caWk46vWDiGS4XXO52jCTTnZFuUz5UPCanb9E/2CxKZvq8GtVwT89lvwarPwd
         7zHX+SJBHp3iNdheVbQDkLeFkWmroOuMYJn/V/ME3dz+VZ5H/KiM2flo7weq0oJLrZ
         KWJdbjE3gKS/w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>
Subject: [net-next 02/15] net/mlx5: DR, Calculate sync threshold of each pool according to its type
Date:   Thu, 20 Apr 2023 18:38:37 -0700
Message-Id: <20230421013850.349646-3-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421013850.349646-1-saeed@kernel.org>
References: <20230421013850.349646-1-saeed@kernel.org>
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

When certain ICM chunk is no longer needed, it needs to be freed.
Fully freeing ICM memory involves issuing FW SYNC_STEERING command.
This is very time consuming, and it is impractical to do it for every
freed chunk.
Instead, we manage these 'freed' chunks in hot list (list of chunks
that are not required by SW any more, but HW might still access them).
When size of the hot list reaches certain threshold, we purge it and
issue SYNC_STEERING FW command.
There is one threshold for all the different ICM types, which is not
optimal, as different ICM types require different approach: STEs pool
is very large, and it is very 'dynamic' in its nature, so letting hot
list to become too large will result in a significant perf hiccup when
purging the hot list. Modify action is much smaller and less dynamic,
so we can let the hot list to grow to almost the size of the whole pool.

This patch fixes this problem: instead of having same hot memory
threshold for all the pools, sync operation will be triggered in
accordance with the ICM type.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_icm_pool.c | 33 ++++++++++---------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index 04fc170a6c16..19e9b4d78454 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -4,7 +4,9 @@
 #include "dr_types.h"
 
 #define DR_ICM_MODIFY_HDR_ALIGN_BASE 64
-#define DR_ICM_POOL_HOT_MEMORY_FRACTION 4
+#define DR_ICM_POOL_STE_HOT_MEM_PERCENT 25
+#define DR_ICM_POOL_MODIFY_HDR_PTRN_HOT_MEM_PERCENT 50
+#define DR_ICM_POOL_MODIFY_ACTION_HOT_MEM_PERCENT 90
 
 struct mlx5dr_icm_hot_chunk {
 	struct mlx5dr_icm_buddy_mem *buddy_mem;
@@ -29,6 +31,8 @@ struct mlx5dr_icm_pool {
 	struct mlx5dr_icm_hot_chunk *hot_chunks_arr;
 	u32 hot_chunks_num;
 	u64 hot_memory_size;
+	/* hot memory size threshold for triggering sync */
+	u64 th;
 };
 
 struct mlx5dr_icm_dm {
@@ -330,15 +334,7 @@ dr_icm_chunk_init(struct mlx5dr_icm_chunk *chunk,
 
 static bool dr_icm_pool_is_sync_required(struct mlx5dr_icm_pool *pool)
 {
-	int allow_hot_size;
-
-	/* sync when hot memory reaches a certain fraction of the pool size */
-	allow_hot_size =
-		mlx5dr_icm_pool_chunk_size_to_byte(pool->max_log_chunk_sz,
-						   pool->icm_type) /
-		DR_ICM_POOL_HOT_MEMORY_FRACTION;
-
-	return pool->hot_memory_size > allow_hot_size;
+	return pool->hot_memory_size > pool->th;
 }
 
 static void dr_icm_pool_clear_hot_chunks_arr(struct mlx5dr_icm_pool *pool)
@@ -503,8 +499,9 @@ void mlx5dr_icm_pool_free_htbl(struct mlx5dr_icm_pool *pool, struct mlx5dr_ste_h
 struct mlx5dr_icm_pool *mlx5dr_icm_pool_create(struct mlx5dr_domain *dmn,
 					       enum mlx5dr_icm_type icm_type)
 {
-	u32 num_of_chunks, entry_size, max_hot_size;
+	u32 num_of_chunks, entry_size;
 	struct mlx5dr_icm_pool *pool;
+	u32 max_hot_size = 0;
 
 	pool = kvzalloc(sizeof(*pool), GFP_KERNEL);
 	if (!pool)
@@ -520,12 +517,21 @@ struct mlx5dr_icm_pool *mlx5dr_icm_pool_create(struct mlx5dr_domain *dmn,
 	switch (icm_type) {
 	case DR_ICM_TYPE_STE:
 		pool->max_log_chunk_sz = dmn->info.max_log_sw_icm_sz;
+		max_hot_size = mlx5dr_icm_pool_chunk_size_to_byte(pool->max_log_chunk_sz,
+								  pool->icm_type) *
+			       DR_ICM_POOL_STE_HOT_MEM_PERCENT / 100;
 		break;
 	case DR_ICM_TYPE_MODIFY_ACTION:
 		pool->max_log_chunk_sz = dmn->info.max_log_action_icm_sz;
+		max_hot_size = mlx5dr_icm_pool_chunk_size_to_byte(pool->max_log_chunk_sz,
+								  pool->icm_type) *
+			       DR_ICM_POOL_MODIFY_ACTION_HOT_MEM_PERCENT / 100;
 		break;
 	case DR_ICM_TYPE_MODIFY_HDR_PTRN:
 		pool->max_log_chunk_sz = dmn->info.max_log_modify_hdr_pattern_icm_sz;
+		max_hot_size = mlx5dr_icm_pool_chunk_size_to_byte(pool->max_log_chunk_sz,
+								  pool->icm_type) *
+			       DR_ICM_POOL_MODIFY_HDR_PTRN_HOT_MEM_PERCENT / 100;
 		break;
 	default:
 		WARN_ON(icm_type);
@@ -533,11 +539,8 @@ struct mlx5dr_icm_pool *mlx5dr_icm_pool_create(struct mlx5dr_domain *dmn,
 
 	entry_size = mlx5dr_icm_pool_dm_type_to_entry_size(pool->icm_type);
 
-	max_hot_size = mlx5dr_icm_pool_chunk_size_to_byte(pool->max_log_chunk_sz,
-							  pool->icm_type) /
-		       DR_ICM_POOL_HOT_MEMORY_FRACTION;
-
 	num_of_chunks = DIV_ROUND_UP(max_hot_size, entry_size) + 1;
+	pool->th = max_hot_size;
 
 	pool->hot_chunks_arr = kvcalloc(num_of_chunks,
 					sizeof(struct mlx5dr_icm_hot_chunk),
-- 
2.39.2

