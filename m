Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D9A4DCE2F
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237744AbiCQS4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237733AbiCQSzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:55:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDC7164D0B
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 11:54:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D718B81E97
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 18:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E37C340F2;
        Thu, 17 Mar 2022 18:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647543273;
        bh=HadG2JCFxiMMcBx5Yu37cFrH8DIn6pRKjBGzfStPP40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=svkHDstgj34OWwFW9OoCvubj6DLmBlbUMxgPcS24i8f6sYgcGR6N+l9p3t380takj
         W6RLLArWOb5JVG7tOms+kEiUzC37EC2DhRDhQsAJog6sCXdcS8f1RJ9iVq6nPXh+/5
         wNZIHry5TUoz0uTj0V3esFTn5QnJ3oYGM3BRIg38EWnjoIBA6SYw0YKRs/N0568gCm
         isXhKHBMxSRzL2fFukFsCXxFo43FdXWBiSpBkv4Dz5CRMajqSs4eozsl6UeJybMrRM
         wMuJnvgupY71wYFEx74vi3eaYmZn0fmqYk5kkTbZPnz+xi3OuRfrMLiEUASNyIfJCE
         dcIfCmyjcM/aQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Rongwei Liu <rongweil@nvidia.com>,
        Shun Hao <shunh@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/15] net/mlx5: DR, Remove icm_addr from mlx5dr_icm_chunk to reduce memory
Date:   Thu, 17 Mar 2022 11:54:18 -0700
Message-Id: <20220317185424.287982-10-saeed@kernel.org>
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

It can be calculated quickly from buddy memory pool by
function mlx5dr_icm_pool_get_chunk_icm_addr().
This function is very lightweight and straightforward.

Reduce 8 bytes and current size of struct mlx5_dr_icm_chunk
is 64 bytes.

Signed-off-by: Rongwei Liu <rongweil@nvidia.com>
Reviewed-by: Shun Hao <shunh@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 12 +++++++-----
 .../mellanox/mlx5/core/steering/dr_dbg.c      | 11 ++++++++---
 .../mellanox/mlx5/core/steering/dr_icm_pool.c |  9 +++++++--
 .../mellanox/mlx5/core/steering/dr_matcher.c  |  2 +-
 .../mellanox/mlx5/core/steering/dr_rule.c     | 19 +++++++++++--------
 .../mellanox/mlx5/core/steering/dr_ste.c      | 14 +++++++++-----
 .../mellanox/mlx5/core/steering/dr_table.c    | 18 ++++++++++--------
 .../mellanox/mlx5/core/steering/dr_types.h    |  2 +-
 8 files changed, 54 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 743422acc3d8..850937cd8bf9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -570,6 +570,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 
 	for (i = 0; i < num_actions; i++) {
 		struct mlx5dr_action_dest_tbl *dest_tbl;
+		struct mlx5dr_icm_chunk *chunk;
 		struct mlx5dr_action *action;
 		int max_actions_type = 1;
 		u32 action_type;
@@ -598,9 +599,9 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 						   matcher->tbl->level,
 						   dest_tbl->tbl->level);
 				}
-				attr.final_icm_addr = rx_rule ?
-					dest_tbl->tbl->rx.s_anchor->chunk->icm_addr :
-					dest_tbl->tbl->tx.s_anchor->chunk->icm_addr;
+				chunk = rx_rule ? dest_tbl->tbl->rx.s_anchor->chunk :
+					dest_tbl->tbl->tx.s_anchor->chunk;
+				attr.final_icm_addr = mlx5dr_icm_pool_get_chunk_icm_addr(chunk);
 			} else {
 				struct mlx5dr_cmd_query_flow_table_details output;
 				int ret;
@@ -1123,7 +1124,8 @@ dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
 		}
 
 		action->rewrite->data = (void *)hw_actions;
-		action->rewrite->index = (action->rewrite->chunk->icm_addr -
+		action->rewrite->index = (mlx5dr_icm_pool_get_chunk_icm_addr
+					  (action->rewrite->chunk) -
 					 dmn->info.caps.hdr_modify_icm_addr) /
 					 ACTION_CACHE_LINE_SIZE;
 
@@ -1702,7 +1704,7 @@ static int dr_action_create_modify_action(struct mlx5dr_domain *dmn,
 	action->rewrite->modify_ttl = modify_ttl;
 	action->rewrite->data = (u8 *)hw_actions;
 	action->rewrite->num_of_actions = num_hw_actions;
-	action->rewrite->index = (chunk->icm_addr -
+	action->rewrite->index = (mlx5dr_icm_pool_get_chunk_icm_addr(chunk) -
 				  dmn->info.caps.hdr_modify_icm_addr) /
 				  ACTION_CACHE_LINE_SIZE;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
index d232f1ea34a2..8fd98b628740 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
@@ -346,16 +346,19 @@ dr_dump_matcher_rx_tx(struct seq_file *file, bool is_rx,
 		      const u64 matcher_id)
 {
 	enum dr_dump_rec_type rec_type;
+	u64 s_icm_addr, e_icm_addr;
 	int i, ret;
 
 	rec_type = is_rx ? DR_DUMP_REC_TYPE_MATCHER_RX :
 			   DR_DUMP_REC_TYPE_MATCHER_TX;
 
+	s_icm_addr = mlx5dr_icm_pool_get_chunk_icm_addr(matcher_rx_tx->s_htbl->chunk);
+	e_icm_addr = mlx5dr_icm_pool_get_chunk_icm_addr(matcher_rx_tx->e_anchor->chunk);
 	seq_printf(file, "%d,0x%llx,0x%llx,%d,0x%llx,0x%llx\n",
 		   rec_type, DR_DBG_PTR_TO_ID(matcher_rx_tx),
 		   matcher_id, matcher_rx_tx->num_of_builders,
-		   dr_dump_icm_to_idx(matcher_rx_tx->s_htbl->chunk->icm_addr),
-		   dr_dump_icm_to_idx(matcher_rx_tx->e_anchor->chunk->icm_addr));
+		   dr_dump_icm_to_idx(s_icm_addr),
+		   dr_dump_icm_to_idx(e_icm_addr));
 
 	for (i = 0; i < matcher_rx_tx->num_of_builders; i++) {
 		ret = dr_dump_matcher_builder(file,
@@ -426,12 +429,14 @@ dr_dump_table_rx_tx(struct seq_file *file, bool is_rx,
 		    const u64 table_id)
 {
 	enum dr_dump_rec_type rec_type;
+	u64 s_icm_addr;
 
 	rec_type = is_rx ? DR_DUMP_REC_TYPE_TABLE_RX :
 			   DR_DUMP_REC_TYPE_TABLE_TX;
 
+	s_icm_addr = mlx5dr_icm_pool_get_chunk_icm_addr(table_rx_tx->s_anchor->chunk);
 	seq_printf(file, "%d,0x%llx,0x%llx\n", rec_type, table_id,
-		   dr_dump_icm_to_idx(table_rx_tx->s_anchor->chunk->icm_addr));
+		   dr_dump_icm_to_idx(s_icm_addr));
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index 672d385a8f40..539af89da629 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -69,6 +69,13 @@ u32 mlx5dr_icm_pool_get_chunk_rkey(struct mlx5dr_icm_chunk *chunk)
 	return chunk->buddy_mem->icm_mr->mkey;
 }
 
+u64 mlx5dr_icm_pool_get_chunk_icm_addr(struct mlx5dr_icm_chunk *chunk)
+{
+	u32 size = mlx5dr_icm_pool_dm_type_to_entry_size(chunk->buddy_mem->pool->icm_type);
+
+	return (u64)chunk->buddy_mem->icm_mr->icm_start_addr + size * chunk->seg;
+}
+
 static struct mlx5dr_icm_mr *
 dr_icm_pool_mr_create(struct mlx5dr_icm_pool *pool)
 {
@@ -310,8 +317,6 @@ dr_icm_chunk_create(struct mlx5dr_icm_pool *pool,
 
 	offset = mlx5dr_icm_pool_dm_type_to_entry_size(pool->icm_type) * seg;
 
-	chunk->icm_addr =
-		(uintptr_t)buddy_mem_pool->icm_mr->icm_start_addr + offset;
 	chunk->num_of_entries =
 		mlx5dr_icm_pool_chunk_size_to_entries(chunk_size);
 	chunk->byte_size =
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index a4b5b415df90..35154ec9673a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -705,7 +705,7 @@ static int dr_nic_matcher_connect(struct mlx5dr_domain *dmn,
 
 	/* Connect start hash table to end anchor */
 	info.type = CONNECT_MISS;
-	info.miss_icm_addr = curr_nic_matcher->e_anchor->chunk->icm_addr;
+	info.miss_icm_addr = mlx5dr_icm_pool_get_chunk_icm_addr(curr_nic_matcher->e_anchor->chunk);
 	ret = mlx5dr_ste_htbl_init_and_postsend(dmn, nic_dmn,
 						curr_nic_matcher->s_htbl,
 						&info, false);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index b4374578425b..e76c1fda2ac9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -41,6 +41,7 @@ dr_rule_create_collision_htbl(struct mlx5dr_matcher *matcher,
 	struct mlx5dr_ste_ctx *ste_ctx = dmn->ste_ctx;
 	struct mlx5dr_ste_htbl *new_htbl;
 	struct mlx5dr_ste *ste;
+	u64 icm_addr;
 
 	/* Create new table for miss entry */
 	new_htbl = mlx5dr_ste_htbl_alloc(dmn->ste_icm_pool,
@@ -54,8 +55,8 @@ dr_rule_create_collision_htbl(struct mlx5dr_matcher *matcher,
 
 	/* One and only entry, never grows */
 	ste = new_htbl->ste_arr;
-	mlx5dr_ste_set_miss_addr(ste_ctx, hw_ste,
-				 nic_matcher->e_anchor->chunk->icm_addr);
+	icm_addr = mlx5dr_icm_pool_get_chunk_icm_addr(nic_matcher->e_anchor->chunk);
+	mlx5dr_ste_set_miss_addr(ste_ctx, hw_ste, icm_addr);
 	mlx5dr_htbl_get(new_htbl);
 
 	return ste;
@@ -235,6 +236,7 @@ dr_rule_rehash_copy_ste(struct mlx5dr_matcher *matcher,
 	bool use_update_list = false;
 	u8 hw_ste[DR_STE_SIZE] = {};
 	struct mlx5dr_ste *new_ste;
+	u64 icm_addr;
 	int new_idx;
 	u8 sb_idx;
 
@@ -243,9 +245,9 @@ dr_rule_rehash_copy_ste(struct mlx5dr_matcher *matcher,
 	mlx5dr_ste_set_bit_mask(hw_ste, nic_matcher->ste_builder[sb_idx].bit_mask);
 
 	/* Copy STE control and tag */
+	icm_addr = mlx5dr_icm_pool_get_chunk_icm_addr(nic_matcher->e_anchor->chunk);
 	memcpy(hw_ste, cur_ste->hw_ste, DR_STE_SIZE_REDUCED);
-	mlx5dr_ste_set_miss_addr(dmn->ste_ctx, hw_ste,
-				 nic_matcher->e_anchor->chunk->icm_addr);
+	mlx5dr_ste_set_miss_addr(dmn->ste_ctx, hw_ste, icm_addr);
 
 	new_idx = mlx5dr_ste_calc_hash_index(hw_ste, new_htbl);
 	new_ste = &new_htbl->ste_arr[new_idx];
@@ -398,7 +400,7 @@ dr_rule_rehash_htbl(struct mlx5dr_rule *rule,
 
 	/* Write new table to HW */
 	info.type = CONNECT_MISS;
-	info.miss_icm_addr = nic_matcher->e_anchor->chunk->icm_addr;
+	info.miss_icm_addr = mlx5dr_icm_pool_get_chunk_icm_addr(nic_matcher->e_anchor->chunk);
 	mlx5dr_ste_set_formatted_ste(dmn->ste_ctx,
 				     dmn->info.caps.gvmi,
 				     nic_dmn->type,
@@ -447,7 +449,7 @@ dr_rule_rehash_htbl(struct mlx5dr_rule *rule,
 		 */
 		mlx5dr_ste_set_hit_addr(dmn->ste_ctx,
 					prev_htbl->ste_arr[0].hw_ste,
-					new_htbl->chunk->icm_addr,
+					mlx5dr_icm_pool_get_chunk_icm_addr(new_htbl->chunk),
 					new_htbl->chunk->num_of_entries);
 
 		ste_to_update = &prev_htbl->ste_arr[0];
@@ -755,6 +757,7 @@ static int dr_rule_handle_empty_entry(struct mlx5dr_matcher *matcher,
 {
 	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
 	struct mlx5dr_ste_send_info *ste_info;
+	u64 icm_addr;
 
 	/* Take ref on table, only on first time this ste is used */
 	mlx5dr_htbl_get(cur_htbl);
@@ -762,8 +765,8 @@ static int dr_rule_handle_empty_entry(struct mlx5dr_matcher *matcher,
 	/* new entry -> new branch */
 	list_add_tail(&ste->miss_list_node, miss_list);
 
-	mlx5dr_ste_set_miss_addr(dmn->ste_ctx, hw_ste,
-				 nic_matcher->e_anchor->chunk->icm_addr);
+	icm_addr = mlx5dr_icm_pool_get_chunk_icm_addr(nic_matcher->e_anchor->chunk);
+	mlx5dr_ste_set_miss_addr(dmn->ste_ctx, hw_ste, icm_addr);
 
 	ste->ste_chain_location = ste_location;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index c1465eb04a5b..0208b859205c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -113,9 +113,10 @@ void mlx5dr_ste_set_hit_addr(struct mlx5dr_ste_ctx *ste_ctx,
 
 u64 mlx5dr_ste_get_icm_addr(struct mlx5dr_ste *ste)
 {
+	u64 base_icm_addr = mlx5dr_icm_pool_get_chunk_icm_addr(ste->htbl->chunk);
 	u32 index = ste - ste->htbl->ste_arr;
 
-	return ste->htbl->chunk->icm_addr + DR_STE_SIZE * index;
+	return base_icm_addr + DR_STE_SIZE * index;
 }
 
 u64 mlx5dr_ste_get_mr_addr(struct mlx5dr_ste *ste)
@@ -141,7 +142,8 @@ static void dr_ste_always_hit_htbl(struct mlx5dr_ste_ctx *ste_ctx,
 
 	ste_ctx->set_byte_mask(hw_ste, next_htbl->byte_mask);
 	ste_ctx->set_next_lu_type(hw_ste, next_htbl->lu_type);
-	ste_ctx->set_hit_addr(hw_ste, chunk->icm_addr, chunk->num_of_entries);
+	ste_ctx->set_hit_addr(hw_ste, mlx5dr_icm_pool_get_chunk_icm_addr(chunk),
+			      chunk->num_of_entries);
 
 	dr_ste_set_always_hit((struct dr_hw_ste_format *)ste->hw_ste);
 }
@@ -193,7 +195,7 @@ dr_ste_remove_head_ste(struct mlx5dr_ste_ctx *ste_ctx,
 	 * touches bit_mask area which doesn't exist at ste->hw_ste.
 	 */
 	memcpy(tmp_ste.hw_ste, ste->hw_ste, DR_STE_SIZE_REDUCED);
-	miss_addr = nic_matcher->e_anchor->chunk->icm_addr;
+	miss_addr = mlx5dr_icm_pool_get_chunk_icm_addr(nic_matcher->e_anchor->chunk);
 	dr_ste_always_miss_addr(ste_ctx, &tmp_ste, miss_addr);
 	memcpy(ste->hw_ste, tmp_ste.hw_ste, DR_STE_SIZE_REDUCED);
 
@@ -364,9 +366,10 @@ void mlx5dr_ste_set_hit_addr_by_next_htbl(struct mlx5dr_ste_ctx *ste_ctx,
 					  u8 *hw_ste,
 					  struct mlx5dr_ste_htbl *next_htbl)
 {
+	u64 icm_addr = mlx5dr_icm_pool_get_chunk_icm_addr(next_htbl->chunk);
 	struct mlx5dr_icm_chunk *chunk = next_htbl->chunk;
 
-	ste_ctx->set_hit_addr(hw_ste, chunk->icm_addr, chunk->num_of_entries);
+	ste_ctx->set_hit_addr(hw_ste, icm_addr, chunk->num_of_entries);
 }
 
 void mlx5dr_ste_prepare_for_postsend(struct mlx5dr_ste_ctx *ste_ctx,
@@ -444,7 +447,8 @@ int mlx5dr_ste_create_next_htbl(struct mlx5dr_matcher *matcher,
 
 		/* Write new table to HW */
 		info.type = CONNECT_MISS;
-		info.miss_icm_addr = nic_matcher->e_anchor->chunk->icm_addr;
+		info.miss_icm_addr =
+			mlx5dr_icm_pool_get_chunk_icm_addr(nic_matcher->e_anchor->chunk);
 		if (mlx5dr_ste_htbl_init_and_postsend(dmn, nic_dmn, next_htbl,
 						      &info, false)) {
 			mlx5dr_info(dmn, "Failed writing table to HW\n");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
index f5f2d356e75f..e5f6412baea9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -10,6 +10,7 @@ static int dr_table_set_miss_action_nic(struct mlx5dr_domain *dmn,
 	struct mlx5dr_matcher_rx_tx *last_nic_matcher = NULL;
 	struct mlx5dr_htbl_connect_info info;
 	struct mlx5dr_ste_htbl *last_htbl;
+	struct mlx5dr_icm_chunk *chunk;
 	int ret;
 
 	if (!list_empty(&nic_tbl->nic_matcher_list))
@@ -22,13 +23,14 @@ static int dr_table_set_miss_action_nic(struct mlx5dr_domain *dmn,
 	else
 		last_htbl = nic_tbl->s_anchor;
 
-	if (action)
-		nic_tbl->default_icm_addr =
-			nic_tbl->nic_dmn->type == DR_DOMAIN_NIC_TYPE_RX ?
-				action->dest_tbl->tbl->rx.s_anchor->chunk->icm_addr :
-				action->dest_tbl->tbl->tx.s_anchor->chunk->icm_addr;
-	else
+	if (action) {
+		chunk = nic_tbl->nic_dmn->type == DR_DOMAIN_NIC_TYPE_RX ?
+			action->dest_tbl->tbl->rx.s_anchor->chunk :
+			action->dest_tbl->tbl->tx.s_anchor->chunk;
+		nic_tbl->default_icm_addr = mlx5dr_icm_pool_get_chunk_icm_addr(chunk);
+	} else {
 		nic_tbl->default_icm_addr = nic_tbl->nic_dmn->default_icm_addr;
+	}
 
 	info.type = CONNECT_MISS;
 	info.miss_icm_addr = nic_tbl->default_icm_addr;
@@ -222,10 +224,10 @@ static int dr_table_create_sw_owned_tbl(struct mlx5dr_table *tbl)
 	int ret;
 
 	if (tbl->rx.s_anchor)
-		icm_addr_rx = tbl->rx.s_anchor->chunk->icm_addr;
+		icm_addr_rx = mlx5dr_icm_pool_get_chunk_icm_addr(tbl->rx.s_anchor->chunk);
 
 	if (tbl->tx.s_anchor)
-		icm_addr_tx = tbl->tx.s_anchor->chunk->icm_addr;
+		icm_addr_tx = mlx5dr_icm_pool_get_chunk_icm_addr(tbl->tx.s_anchor->chunk);
 
 	ft_attr.table_type = tbl->table_type;
 	ft_attr.icm_addr_rx = icm_addr_rx;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index dd5b013e901c..4fe0c8c623ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1099,7 +1099,6 @@ struct mlx5dr_icm_chunk {
 	struct list_head chunk_list;
 	u32 num_of_entries;
 	u32 byte_size;
-	u64 icm_addr;
 
 	/* indicates the index of this chunk in the whole memory,
 	 * used for deleting the chunk from the buddy
@@ -1146,6 +1145,7 @@ int mlx5dr_matcher_select_builders(struct mlx5dr_matcher *matcher,
 
 u64 mlx5dr_icm_pool_get_chunk_mr_addr(struct mlx5dr_icm_chunk *chunk);
 u32 mlx5dr_icm_pool_get_chunk_rkey(struct mlx5dr_icm_chunk *chunk);
+u64 mlx5dr_icm_pool_get_chunk_icm_addr(struct mlx5dr_icm_chunk *chunk);
 
 static inline int
 mlx5dr_icm_pool_dm_type_to_entry_size(enum mlx5dr_icm_type icm_type)
-- 
2.35.1

