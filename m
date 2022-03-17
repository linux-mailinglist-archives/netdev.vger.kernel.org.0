Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2699D4DCE37
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237741AbiCQSz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237419AbiCQSzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:55:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24E8164D3A
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 11:54:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1B6B617C0
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 18:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183ECC340EC;
        Thu, 17 Mar 2022 18:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647543272;
        bh=68UWEBoD3TsKQwmuBVkzyhI75csaN+yPjDzuvN0m7oQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t49PiFeLPLDxIDNrvJJd6l7dK04M/Cz9sMuM/07nquJi5IgzS4d/9d2x+XM28Gq1i
         ULvgCuvHHtbZM45H59YMiF5+QCUsIDXZ+I47ipzqw/HifZVwhIZfLeWu6UiVBC5og5
         Epaald0XIFyPZCCUWCpeITQ6CrsNd7TTo38lqIn3ubbknWu0jL7hCGaNXoelomli1W
         jd8QFEiwAV8Xh/Ychy77voeQCkfjTI1j/R/y7u2l5VtipNMnju3fdk+JqpXa5PnyHG
         E4vqg5qMcdEzzbyDfXBtFKf7Qd0k+i/wfhy4DrHG/GW8jS1DFywJTE9rvANmBb01Aj
         1uziQAX1LbBVg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Rongwei Liu <rongweil@nvidia.com>,
        Shun Hao <shunh@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/15] net/mlx5: DR, Remove mr_addr rkey from struct mlx5dr_icm_chunk
Date:   Thu, 17 Mar 2022 11:54:17 -0700
Message-Id: <20220317185424.287982-9-saeed@kernel.org>
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

Reduce memory footprint by removing mr_addr and rkey from
mlx5_dr_icm_chunk.
1. mr_addr is calculated by mlx5dr_icm_pool_get_chunk_mr_addr()
2. rkey is calculated by mlx5dr_icm_pool_get_chunk_rkey()
The two new functions are very lightweight and straightforward.

Reduce 8 bytes from struct mlx5_dr_icm_chunk, its current size is
72 bytes.

Signed-off-by: Rongwei Liu <rongweil@nvidia.com>
Reviewed-by: Shun Hao <shunh@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_icm_pool.c      | 14 ++++++++++++--
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c | 11 ++++++-----
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |  2 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |  5 +++--
 4 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index e289cfdbce07..672d385a8f40 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -57,6 +57,18 @@ static int dr_icm_create_dm_mkey(struct mlx5_core_dev *mdev,
 	return mlx5_core_create_mkey(mdev, mkey, in, inlen);
 }
 
+u64 mlx5dr_icm_pool_get_chunk_mr_addr(struct mlx5dr_icm_chunk *chunk)
+{
+	u32 offset = mlx5dr_icm_pool_dm_type_to_entry_size(chunk->buddy_mem->pool->icm_type);
+
+	return (u64)offset * chunk->seg;
+}
+
+u32 mlx5dr_icm_pool_get_chunk_rkey(struct mlx5dr_icm_chunk *chunk)
+{
+	return chunk->buddy_mem->icm_mr->mkey;
+}
+
 static struct mlx5dr_icm_mr *
 dr_icm_pool_mr_create(struct mlx5dr_icm_pool *pool)
 {
@@ -298,8 +310,6 @@ dr_icm_chunk_create(struct mlx5dr_icm_pool *pool,
 
 	offset = mlx5dr_icm_pool_dm_type_to_entry_size(pool->icm_type) * seg;
 
-	chunk->rkey = buddy_mem_pool->icm_mr->mkey;
-	chunk->mr_addr = offset;
 	chunk->icm_addr =
 		(uintptr_t)buddy_mem_pool->icm_mr->icm_start_addr + offset;
 	chunk->num_of_entries =
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 00aef47d7682..57765d231993 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -453,7 +453,7 @@ int mlx5dr_send_postsend_ste(struct mlx5dr_domain *dmn, struct mlx5dr_ste *ste,
 	send_info.write.length = size;
 	send_info.write.lkey = 0;
 	send_info.remote_addr = mlx5dr_ste_get_mr_addr(ste) + offset;
-	send_info.rkey = ste->htbl->chunk->rkey;
+	send_info.rkey = mlx5dr_icm_pool_get_chunk_rkey(ste->htbl->chunk);
 
 	return dr_postsend_icm_data(dmn, &send_info);
 }
@@ -512,7 +512,7 @@ int mlx5dr_send_postsend_htbl(struct mlx5dr_domain *dmn,
 		send_info.write.lkey = 0;
 		send_info.remote_addr =
 			mlx5dr_ste_get_mr_addr(htbl->ste_arr + ste_index);
-		send_info.rkey = htbl->chunk->rkey;
+		send_info.rkey = mlx5dr_icm_pool_get_chunk_rkey(htbl->chunk);
 
 		ret = dr_postsend_icm_data(dmn, &send_info);
 		if (ret)
@@ -569,7 +569,7 @@ int mlx5dr_send_postsend_formatted_htbl(struct mlx5dr_domain *dmn,
 		send_info.write.lkey = 0;
 		send_info.remote_addr =
 			mlx5dr_ste_get_mr_addr(htbl->ste_arr + ste_index);
-		send_info.rkey = htbl->chunk->rkey;
+		send_info.rkey = mlx5dr_icm_pool_get_chunk_rkey(htbl->chunk);
 
 		ret = dr_postsend_icm_data(dmn, &send_info);
 		if (ret)
@@ -591,8 +591,9 @@ int mlx5dr_send_postsend_action(struct mlx5dr_domain *dmn,
 	send_info.write.length = action->rewrite->num_of_actions *
 				 DR_MODIFY_ACTION_SIZE;
 	send_info.write.lkey = 0;
-	send_info.remote_addr = action->rewrite->chunk->mr_addr;
-	send_info.rkey = action->rewrite->chunk->rkey;
+	send_info.remote_addr =
+		mlx5dr_icm_pool_get_chunk_mr_addr(action->rewrite->chunk);
+	send_info.rkey = mlx5dr_icm_pool_get_chunk_rkey(action->rewrite->chunk);
 
 	ret = dr_postsend_icm_data(dmn, &send_info);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 518e949847a3..c1465eb04a5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -122,7 +122,7 @@ u64 mlx5dr_ste_get_mr_addr(struct mlx5dr_ste *ste)
 {
 	u32 index = ste - ste->htbl->ste_arr;
 
-	return ste->htbl->chunk->mr_addr + DR_STE_SIZE * index;
+	return mlx5dr_icm_pool_get_chunk_mr_addr(ste->htbl->chunk) + DR_STE_SIZE * index;
 }
 
 struct list_head *mlx5dr_ste_get_miss_list(struct mlx5dr_ste *ste)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index e906fef615a4..dd5b013e901c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1097,11 +1097,9 @@ int mlx5dr_rule_get_reverse_rule_members(struct mlx5dr_ste **ste_arr,
 struct mlx5dr_icm_chunk {
 	struct mlx5dr_icm_buddy_mem *buddy_mem;
 	struct list_head chunk_list;
-	u32 rkey;
 	u32 num_of_entries;
 	u32 byte_size;
 	u64 icm_addr;
-	u64 mr_addr;
 
 	/* indicates the index of this chunk in the whole memory,
 	 * used for deleting the chunk from the buddy
@@ -1146,6 +1144,9 @@ int mlx5dr_matcher_select_builders(struct mlx5dr_matcher *matcher,
 				   enum mlx5dr_ipv outer_ipv,
 				   enum mlx5dr_ipv inner_ipv);
 
+u64 mlx5dr_icm_pool_get_chunk_mr_addr(struct mlx5dr_icm_chunk *chunk);
+u32 mlx5dr_icm_pool_get_chunk_rkey(struct mlx5dr_icm_chunk *chunk);
+
 static inline int
 mlx5dr_icm_pool_dm_type_to_entry_size(enum mlx5dr_icm_type icm_type)
 {
-- 
2.35.1

