Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793E02EB5D6
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbhAEXG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:06:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:57482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727569AbhAEXGc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 18:06:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1854B23101;
        Tue,  5 Jan 2021 23:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609887914;
        bh=hvxAa+7jRssig2HYihqn8PtD2D9xxLLg9zgLuzwKZQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rytEZ+cZfjsaK0qtNA7cXrVCdn4pfKfPxs68N0Bj0W1SF/0pdrEN9GDS5NMs7Xv5k
         1Lh3062LlzXnYn5+QJAjGUBZwWgG1aBPRoTLWCqFRLvgDzEJEPh6+ACqvW6VSKrDb7
         EItxgpGzoFEtkixPgkWYvNVMz/zXX86+Vzs3MErYRwZ2hYwuYeUZujkyAi8sNrZdJQ
         kQBVP19gruDKopEahxz6REV8Vx/iiRQ0JeRGagI3kW7tIIOLXPVfBzxVxsz/R0QHuX
         35PWMpZNBWKxm2OuSxE9NG/d+tu7pcmLofEU+C0fzt/4v6D1zCRds5LL+xxefaWOce
         fBHVhZ/De6Dcw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/16] net/mlx5: DR, Move STEv0 setters and getters
Date:   Tue,  5 Jan 2021 15:03:29 -0800
Message-Id: <20210105230333.239456-13-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210105230333.239456-1-saeed@kernel.org>
References: <20210105230333.239456-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Use the new setters and getters API for STEv0: move HW specific setter and
getters from dr_ste to STEv0 file. Since STEv0 and STEv1 format are
different each version should implemented different setters and getters.
Rename remaining static functions w/o mlx5 prefix.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   |   5 +-
 .../mellanox/mlx5/core/steering/dr_rule.c     |  49 ++++--
 .../mellanox/mlx5/core/steering/dr_ste.c      | 147 ++++++++----------
 .../mellanox/mlx5/core/steering/dr_ste_v0.c   |  77 +++++++++
 .../mellanox/mlx5/core/steering/dr_types.h    |  20 ++-
 5 files changed, 195 insertions(+), 103 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 60f504d693ff..9b2552a87af9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -383,13 +383,14 @@ static void dr_actions_apply(struct mlx5dr_domain *dmn,
 			     struct mlx5dr_ste_actions_attr *attr,
 			     u32 *new_num_stes)
 {
+	struct mlx5dr_ste_ctx *ste_ctx = dmn->ste_ctx;
 	u32 added_stes = 0;
 
 	if (ste_type == MLX5DR_STE_TYPE_RX)
-		mlx5dr_ste_set_actions_rx(dmn, action_type_set,
+		mlx5dr_ste_set_actions_rx(ste_ctx, dmn, action_type_set,
 					  last_ste, attr, &added_stes);
 	else
-		mlx5dr_ste_set_actions_tx(dmn, action_type_set,
+		mlx5dr_ste_set_actions_tx(ste_ctx, dmn, action_type_set,
 					  last_ste, attr, &added_stes);
 
 	*new_num_stes += added_stes;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index 6d73719db1f4..ddcb7017e121 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -10,7 +10,8 @@ struct mlx5dr_rule_action_member {
 	struct list_head list;
 };
 
-static int dr_rule_append_to_miss_list(struct mlx5dr_ste *new_last_ste,
+static int dr_rule_append_to_miss_list(struct mlx5dr_ste_ctx *ste_ctx,
+				       struct mlx5dr_ste *new_last_ste,
 				       struct list_head *miss_list,
 				       struct list_head *send_list)
 {
@@ -25,7 +26,7 @@ static int dr_rule_append_to_miss_list(struct mlx5dr_ste *new_last_ste,
 	if (!ste_info_last)
 		return -ENOMEM;
 
-	mlx5dr_ste_set_miss_addr(last_ste->hw_ste,
+	mlx5dr_ste_set_miss_addr(ste_ctx, last_ste->hw_ste,
 				 mlx5dr_ste_get_icm_addr(new_last_ste));
 	list_add_tail(&new_last_ste->miss_list_node, miss_list);
 
@@ -42,6 +43,7 @@ dr_rule_create_collision_htbl(struct mlx5dr_matcher *matcher,
 			      u8 *hw_ste)
 {
 	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
+	struct mlx5dr_ste_ctx *ste_ctx = dmn->ste_ctx;
 	struct mlx5dr_ste_htbl *new_htbl;
 	struct mlx5dr_ste *ste;
 
@@ -57,7 +59,8 @@ dr_rule_create_collision_htbl(struct mlx5dr_matcher *matcher,
 
 	/* One and only entry, never grows */
 	ste = new_htbl->ste_arr;
-	mlx5dr_ste_set_miss_addr(hw_ste, nic_matcher->e_anchor->chunk->icm_addr);
+	mlx5dr_ste_set_miss_addr(ste_ctx, hw_ste,
+				 nic_matcher->e_anchor->chunk->icm_addr);
 	mlx5dr_htbl_get(new_htbl);
 
 	return ste;
@@ -169,6 +172,7 @@ dr_rule_rehash_handle_collision(struct mlx5dr_matcher *matcher,
 				struct mlx5dr_ste *col_ste,
 				u8 *hw_ste)
 {
+	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
 	struct mlx5dr_ste *new_ste;
 	int ret;
 
@@ -180,11 +184,11 @@ dr_rule_rehash_handle_collision(struct mlx5dr_matcher *matcher,
 	new_ste->htbl->miss_list = mlx5dr_ste_get_miss_list(col_ste);
 
 	/* Update the previous from the list */
-	ret = dr_rule_append_to_miss_list(new_ste,
+	ret = dr_rule_append_to_miss_list(dmn->ste_ctx, new_ste,
 					  mlx5dr_ste_get_miss_list(col_ste),
 					  update_list);
 	if (ret) {
-		mlx5dr_dbg(matcher->tbl->dmn, "Failed update dup entry\n");
+		mlx5dr_dbg(dmn, "Failed update dup entry\n");
 		goto err_exit;
 	}
 
@@ -224,6 +228,7 @@ dr_rule_rehash_copy_ste(struct mlx5dr_matcher *matcher,
 			struct mlx5dr_ste_htbl *new_htbl,
 			struct list_head *update_list)
 {
+	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
 	struct mlx5dr_ste_send_info *ste_info;
 	bool use_update_list = false;
 	u8 hw_ste[DR_STE_SIZE] = {};
@@ -237,7 +242,8 @@ dr_rule_rehash_copy_ste(struct mlx5dr_matcher *matcher,
 
 	/* Copy STE control and tag */
 	memcpy(hw_ste, cur_ste->hw_ste, DR_STE_SIZE_REDUCED);
-	mlx5dr_ste_set_miss_addr(hw_ste, nic_matcher->e_anchor->chunk->icm_addr);
+	mlx5dr_ste_set_miss_addr(dmn->ste_ctx, hw_ste,
+				 nic_matcher->e_anchor->chunk->icm_addr);
 
 	new_idx = mlx5dr_ste_calc_hash_index(hw_ste, new_htbl);
 	new_ste = &new_htbl->ste_arr[new_idx];
@@ -253,7 +259,7 @@ dr_rule_rehash_copy_ste(struct mlx5dr_matcher *matcher,
 							  new_ste,
 							  hw_ste);
 		if (!new_ste) {
-			mlx5dr_dbg(matcher->tbl->dmn, "Failed adding collision entry, index: %d\n",
+			mlx5dr_dbg(dmn, "Failed adding collision entry, index: %d\n",
 				   new_idx);
 			return NULL;
 		}
@@ -391,7 +397,8 @@ dr_rule_rehash_htbl(struct mlx5dr_rule *rule,
 	/* Write new table to HW */
 	info.type = CONNECT_MISS;
 	info.miss_icm_addr = nic_matcher->e_anchor->chunk->icm_addr;
-	mlx5dr_ste_set_formatted_ste(dmn->info.caps.gvmi,
+	mlx5dr_ste_set_formatted_ste(dmn->ste_ctx,
+				     dmn->info.caps.gvmi,
 				     nic_dmn,
 				     new_htbl,
 				     formatted_ste,
@@ -436,13 +443,15 @@ dr_rule_rehash_htbl(struct mlx5dr_rule *rule,
 		/* It is safe to operate dr_ste_set_hit_addr on the hw_ste here
 		 * (48B len) which works only on first 32B
 		 */
-		mlx5dr_ste_set_hit_addr(prev_htbl->ste_arr[0].hw_ste,
+		mlx5dr_ste_set_hit_addr(dmn->ste_ctx,
+					prev_htbl->ste_arr[0].hw_ste,
 					new_htbl->chunk->icm_addr,
 					new_htbl->chunk->num_of_entries);
 
 		ste_to_update = &prev_htbl->ste_arr[0];
 	} else {
-		mlx5dr_ste_set_hit_addr_by_next_htbl(cur_htbl->pointing_ste->hw_ste,
+		mlx5dr_ste_set_hit_addr_by_next_htbl(dmn->ste_ctx,
+						     cur_htbl->pointing_ste->hw_ste,
 						     new_htbl);
 		ste_to_update = cur_htbl->pointing_ste;
 	}
@@ -496,6 +505,8 @@ dr_rule_handle_collision(struct mlx5dr_matcher *matcher,
 			 struct list_head *miss_list,
 			 struct list_head *send_list)
 {
+	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
+	struct mlx5dr_ste_ctx *ste_ctx = dmn->ste_ctx;
 	struct mlx5dr_ste_send_info *ste_info;
 	struct mlx5dr_ste *new_ste;
 
@@ -507,8 +518,9 @@ dr_rule_handle_collision(struct mlx5dr_matcher *matcher,
 	if (!new_ste)
 		goto free_send_info;
 
-	if (dr_rule_append_to_miss_list(new_ste, miss_list, send_list)) {
-		mlx5dr_dbg(matcher->tbl->dmn, "Failed to update prev miss_list\n");
+	if (dr_rule_append_to_miss_list(ste_ctx, new_ste,
+					miss_list, send_list)) {
+		mlx5dr_dbg(dmn, "Failed to update prev miss_list\n");
 		goto err_exit;
 	}
 
@@ -659,6 +671,7 @@ static int dr_rule_handle_action_stes(struct mlx5dr_rule *rule,
 	struct mlx5dr_ste_send_info *ste_info_arr[DR_ACTION_MAX_STES];
 	u8 num_of_builders = nic_matcher->num_of_builders;
 	struct mlx5dr_matcher *matcher = rule->matcher;
+	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
 	u8 *curr_hw_ste, *prev_hw_ste;
 	struct mlx5dr_ste *action_ste;
 	int i, k, ret;
@@ -692,10 +705,12 @@ static int dr_rule_handle_action_stes(struct mlx5dr_rule *rule,
 			goto err_exit;
 
 		/* Point current ste to the new action */
-		mlx5dr_ste_set_hit_addr_by_next_htbl(prev_hw_ste, action_ste->htbl);
+		mlx5dr_ste_set_hit_addr_by_next_htbl(dmn->ste_ctx,
+						     prev_hw_ste,
+						     action_ste->htbl);
 		ret = dr_rule_add_member(nic_rule, action_ste);
 		if (ret) {
-			mlx5dr_dbg(matcher->tbl->dmn, "Failed adding rule member\n");
+			mlx5dr_dbg(dmn, "Failed adding rule member\n");
 			goto free_ste_info;
 		}
 		mlx5dr_send_fill_and_append_ste_send_info(action_ste, DR_STE_SIZE, 0,
@@ -722,6 +737,7 @@ static int dr_rule_handle_empty_entry(struct mlx5dr_matcher *matcher,
 				      struct list_head *miss_list,
 				      struct list_head *send_list)
 {
+	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
 	struct mlx5dr_ste_send_info *ste_info;
 
 	/* Take ref on table, only on first time this ste is used */
@@ -730,7 +746,8 @@ static int dr_rule_handle_empty_entry(struct mlx5dr_matcher *matcher,
 	/* new entry -> new branch */
 	list_add_tail(&ste->miss_list_node, miss_list);
 
-	mlx5dr_ste_set_miss_addr(hw_ste, nic_matcher->e_anchor->chunk->icm_addr);
+	mlx5dr_ste_set_miss_addr(dmn->ste_ctx, hw_ste,
+				 nic_matcher->e_anchor->chunk->icm_addr);
 
 	ste->ste_chain_location = ste_location;
 
@@ -743,7 +760,7 @@ static int dr_rule_handle_empty_entry(struct mlx5dr_matcher *matcher,
 					ste,
 					hw_ste,
 					DR_CHUNK_SIZE_1)) {
-		mlx5dr_dbg(matcher->tbl->dmn, "Failed allocating table\n");
+		mlx5dr_dbg(dmn, "Failed allocating table\n");
 		goto clean_ste_info;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 18d044e092ce..19eb49d3c571 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -172,21 +172,6 @@ static void dr_ste_set_hit_gvmi(u8 *hw_ste_p, u16 gvmi)
 	MLX5_SET(ste_general, hw_ste_p, next_table_base_63_48, gvmi);
 }
 
-static void dr_ste_init(u8 *hw_ste_p, u16 lu_type, u8 entry_type,
-			u16 gvmi)
-{
-	MLX5_SET(ste_general, hw_ste_p, entry_type, entry_type);
-	MLX5_SET(ste_general, hw_ste_p, entry_sub_type, lu_type);
-	MLX5_SET(ste_general, hw_ste_p, next_lu_type, MLX5DR_STE_LU_TYPE_DONT_CARE);
-
-	/* Set GVMI once, this is the same for RX/TX
-	 * bits 63_48 of next table base / miss address encode the next GVMI
-	 */
-	MLX5_SET(ste_rx_steering_mult, hw_ste_p, gvmi, gvmi);
-	MLX5_SET(ste_rx_steering_mult, hw_ste_p, next_table_base_63_48, gvmi);
-	MLX5_SET(ste_rx_steering_mult, hw_ste_p, miss_address_63_48, gvmi);
-}
-
 static void dr_ste_set_always_hit(struct dr_hw_ste_format *hw_ste)
 {
 	memset(&hw_ste->tag, 0, sizeof(hw_ste->tag));
@@ -199,40 +184,26 @@ static void dr_ste_set_always_miss(struct dr_hw_ste_format *hw_ste)
 	hw_ste->mask[0] = 0;
 }
 
-void mlx5dr_ste_set_miss_addr(u8 *hw_ste_p, u64 miss_addr)
+void mlx5dr_ste_set_miss_addr(struct mlx5dr_ste_ctx *ste_ctx,
+			      u8 *hw_ste_p, u64 miss_addr)
 {
-	u64 index = miss_addr >> 6;
-
-	/* Miss address for TX and RX STEs located in the same offsets */
-	MLX5_SET(ste_rx_steering_mult, hw_ste_p, miss_address_39_32, index >> 26);
-	MLX5_SET(ste_rx_steering_mult, hw_ste_p, miss_address_31_6, index);
-}
-
-static u64 dr_ste_get_miss_addr(u8 *hw_ste)
-{
-	u64 index =
-		(MLX5_GET(ste_rx_steering_mult, hw_ste, miss_address_31_6) |
-		 MLX5_GET(ste_rx_steering_mult, hw_ste, miss_address_39_32) << 26);
-
-	return index << 6;
+	ste_ctx->set_miss_addr(hw_ste_p, miss_addr);
 }
 
-static void dr_ste_always_miss_addr(struct mlx5dr_ste *ste, u64 miss_addr)
+static void dr_ste_always_miss_addr(struct mlx5dr_ste_ctx *ste_ctx,
+				    struct mlx5dr_ste *ste, u64 miss_addr)
 {
 	u8 *hw_ste_p = ste->hw_ste;
 
-	MLX5_SET(ste_rx_steering_mult, hw_ste_p, next_lu_type,
-		 MLX5DR_STE_LU_TYPE_DONT_CARE);
-	mlx5dr_ste_set_miss_addr(hw_ste_p, miss_addr);
+	ste_ctx->set_next_lu_type(hw_ste_p, MLX5DR_STE_LU_TYPE_DONT_CARE);
+	ste_ctx->set_miss_addr(hw_ste_p, miss_addr);
 	dr_ste_set_always_miss((struct dr_hw_ste_format *)ste->hw_ste);
 }
 
-void mlx5dr_ste_set_hit_addr(u8 *hw_ste, u64 icm_addr, u32 ht_size)
+void mlx5dr_ste_set_hit_addr(struct mlx5dr_ste_ctx *ste_ctx,
+			     u8 *hw_ste, u64 icm_addr, u32 ht_size)
 {
-	u64 index = (icm_addr >> 5) | ht_size;
-
-	MLX5_SET(ste_general, hw_ste, next_table_base_39_32_size, index >> 27);
-	MLX5_SET(ste_general, hw_ste, next_table_base_31_5_size, index);
+	ste_ctx->set_hit_addr(hw_ste, icm_addr, ht_size);
 }
 
 u64 mlx5dr_ste_get_icm_addr(struct mlx5dr_ste *ste)
@@ -256,15 +227,16 @@ struct list_head *mlx5dr_ste_get_miss_list(struct mlx5dr_ste *ste)
 	return &ste->htbl->miss_list[index];
 }
 
-static void dr_ste_always_hit_htbl(struct mlx5dr_ste *ste,
+static void dr_ste_always_hit_htbl(struct mlx5dr_ste_ctx *ste_ctx,
+				   struct mlx5dr_ste *ste,
 				   struct mlx5dr_ste_htbl *next_htbl)
 {
 	struct mlx5dr_icm_chunk *chunk = next_htbl->chunk;
 	u8 *hw_ste = ste->hw_ste;
 
-	MLX5_SET(ste_general, hw_ste, byte_mask, next_htbl->byte_mask);
-	MLX5_SET(ste_general, hw_ste, next_lu_type, next_htbl->lu_type);
-	mlx5dr_ste_set_hit_addr(hw_ste, chunk->icm_addr, chunk->num_of_entries);
+	ste_ctx->set_byte_mask(hw_ste, next_htbl->byte_mask);
+	ste_ctx->set_next_lu_type(hw_ste, next_htbl->lu_type);
+	ste_ctx->set_hit_addr(hw_ste, chunk->icm_addr, chunk->num_of_entries);
 
 	dr_ste_set_always_hit((struct dr_hw_ste_format *)ste->hw_ste);
 }
@@ -302,7 +274,8 @@ static void dr_ste_replace(struct mlx5dr_ste *dst, struct mlx5dr_ste *src)
 
 /* Free ste which is the head and the only one in miss_list */
 static void
-dr_ste_remove_head_ste(struct mlx5dr_ste *ste,
+dr_ste_remove_head_ste(struct mlx5dr_ste_ctx *ste_ctx,
+		       struct mlx5dr_ste *ste,
 		       struct mlx5dr_matcher_rx_tx *nic_matcher,
 		       struct mlx5dr_ste_send_info *ste_info_head,
 		       struct list_head *send_ste_list,
@@ -319,7 +292,7 @@ dr_ste_remove_head_ste(struct mlx5dr_ste *ste,
 	 */
 	memcpy(tmp_ste.hw_ste, ste->hw_ste, DR_STE_SIZE_REDUCED);
 	miss_addr = nic_matcher->e_anchor->chunk->icm_addr;
-	dr_ste_always_miss_addr(&tmp_ste, miss_addr);
+	dr_ste_always_miss_addr(ste_ctx, &tmp_ste, miss_addr);
 	memcpy(ste->hw_ste, tmp_ste.hw_ste, DR_STE_SIZE_REDUCED);
 
 	list_del_init(&ste->miss_list_node);
@@ -375,7 +348,8 @@ dr_ste_replace_head_ste(struct mlx5dr_ste *ste, struct mlx5dr_ste *next_ste,
 /* Free ste that is located in the middle of the miss list:
  * |__| -->|_prev_ste_|->|_ste_|-->|_next_ste_|
  */
-static void dr_ste_remove_middle_ste(struct mlx5dr_ste *ste,
+static void dr_ste_remove_middle_ste(struct mlx5dr_ste_ctx *ste_ctx,
+				     struct mlx5dr_ste *ste,
 				     struct mlx5dr_ste_send_info *ste_info,
 				     struct list_head *send_ste_list,
 				     struct mlx5dr_ste_htbl *stats_tbl)
@@ -387,8 +361,8 @@ static void dr_ste_remove_middle_ste(struct mlx5dr_ste *ste,
 	if (WARN_ON(!prev_ste))
 		return;
 
-	miss_addr = dr_ste_get_miss_addr(ste->hw_ste);
-	mlx5dr_ste_set_miss_addr(prev_ste->hw_ste, miss_addr);
+	miss_addr = ste_ctx->get_miss_addr(ste->hw_ste);
+	ste_ctx->set_miss_addr(prev_ste->hw_ste, miss_addr);
 
 	mlx5dr_send_fill_and_append_ste_send_info(prev_ste, DR_STE_SIZE_REDUCED, 0,
 						  prev_ste->hw_ste, ste_info,
@@ -406,6 +380,7 @@ void mlx5dr_ste_free(struct mlx5dr_ste *ste,
 {
 	struct mlx5dr_ste_send_info *cur_ste_info, *tmp_ste_info;
 	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
+	struct mlx5dr_ste_ctx *ste_ctx = dmn->ste_ctx;
 	struct mlx5dr_ste_send_info ste_info_head;
 	struct mlx5dr_ste *next_ste, *first_ste;
 	bool put_on_origin_table = true;
@@ -434,7 +409,8 @@ void mlx5dr_ste_free(struct mlx5dr_ste *ste,
 
 		if (!next_ste) {
 			/* One and only entry in the list */
-			dr_ste_remove_head_ste(ste, nic_matcher,
+			dr_ste_remove_head_ste(ste_ctx, ste,
+					       nic_matcher,
 					       &ste_info_head,
 					       &send_ste_list,
 					       stats_tbl);
@@ -445,7 +421,9 @@ void mlx5dr_ste_free(struct mlx5dr_ste *ste,
 			put_on_origin_table = false;
 		}
 	} else { /* Ste in the middle of the list */
-		dr_ste_remove_middle_ste(ste, &ste_info_head, &send_ste_list, stats_tbl);
+		dr_ste_remove_middle_ste(ste_ctx, ste,
+					 &ste_info_head, &send_ste_list,
+					 stats_tbl);
 	}
 
 	/* Update HW */
@@ -469,16 +447,18 @@ bool mlx5dr_ste_equal_tag(void *src, void *dst)
 	return !memcmp(s_hw_ste->tag, d_hw_ste->tag, DR_STE_SIZE_TAG);
 }
 
-void mlx5dr_ste_set_hit_addr_by_next_htbl(u8 *hw_ste,
+void mlx5dr_ste_set_hit_addr_by_next_htbl(struct mlx5dr_ste_ctx *ste_ctx,
+					  u8 *hw_ste,
 					  struct mlx5dr_ste_htbl *next_htbl)
 {
 	struct mlx5dr_icm_chunk *chunk = next_htbl->chunk;
 
-	mlx5dr_ste_set_hit_addr(hw_ste, chunk->icm_addr, chunk->num_of_entries);
+	ste_ctx->set_hit_addr(hw_ste, chunk->icm_addr, chunk->num_of_entries);
 }
 
 /* Init one ste as a pattern for ste data array */
-void mlx5dr_ste_set_formatted_ste(u16 gvmi,
+void mlx5dr_ste_set_formatted_ste(struct mlx5dr_ste_ctx *ste_ctx,
+				  u16 gvmi,
 				  struct mlx5dr_domain_rx_tx *nic_dmn,
 				  struct mlx5dr_ste_htbl *htbl,
 				  u8 *formatted_ste,
@@ -486,13 +466,13 @@ void mlx5dr_ste_set_formatted_ste(u16 gvmi,
 {
 	struct mlx5dr_ste ste = {};
 
-	dr_ste_init(formatted_ste, htbl->lu_type, nic_dmn->ste_type, gvmi);
+	ste_ctx->ste_init(formatted_ste, htbl->lu_type, nic_dmn->ste_type, gvmi);
 	ste.hw_ste = formatted_ste;
 
 	if (connect_info->type == CONNECT_HIT)
-		dr_ste_always_hit_htbl(&ste, connect_info->hit_next_htbl);
+		dr_ste_always_hit_htbl(ste_ctx, &ste, connect_info->hit_next_htbl);
 	else
-		dr_ste_always_miss_addr(&ste, connect_info->miss_icm_addr);
+		dr_ste_always_miss_addr(ste_ctx, &ste, connect_info->miss_icm_addr);
 }
 
 int mlx5dr_ste_htbl_init_and_postsend(struct mlx5dr_domain *dmn,
@@ -503,7 +483,8 @@ int mlx5dr_ste_htbl_init_and_postsend(struct mlx5dr_domain *dmn,
 {
 	u8 formatted_ste[DR_STE_SIZE] = {};
 
-	mlx5dr_ste_set_formatted_ste(dmn->info.caps.gvmi,
+	mlx5dr_ste_set_formatted_ste(dmn->ste_ctx,
+				     dmn->info.caps.gvmi,
 				     nic_dmn,
 				     htbl,
 				     formatted_ste,
@@ -518,9 +499,9 @@ int mlx5dr_ste_create_next_htbl(struct mlx5dr_matcher *matcher,
 				u8 *cur_hw_ste,
 				enum mlx5dr_icm_chunk_size log_table_size)
 {
-	struct dr_hw_ste_format *hw_ste = (struct dr_hw_ste_format *)cur_hw_ste;
 	struct mlx5dr_domain_rx_tx *nic_dmn = nic_matcher->nic_tbl->nic_dmn;
 	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
+	struct mlx5dr_ste_ctx *ste_ctx = dmn->ste_ctx;
 	struct mlx5dr_htbl_connect_info info;
 	struct mlx5dr_ste_htbl *next_htbl;
 
@@ -528,8 +509,8 @@ int mlx5dr_ste_create_next_htbl(struct mlx5dr_matcher *matcher,
 		u16 next_lu_type;
 		u16 byte_mask;
 
-		next_lu_type = MLX5_GET(ste_general, hw_ste, next_lu_type);
-		byte_mask = MLX5_GET(ste_general, hw_ste, byte_mask);
+		next_lu_type = ste_ctx->get_next_lu_type(cur_hw_ste);
+		byte_mask = ste_ctx->get_byte_mask(cur_hw_ste);
 
 		next_htbl = mlx5dr_ste_htbl_alloc(dmn->ste_icm_pool,
 						  log_table_size,
@@ -549,7 +530,8 @@ int mlx5dr_ste_create_next_htbl(struct mlx5dr_matcher *matcher,
 			goto free_table;
 		}
 
-		mlx5dr_ste_set_hit_addr_by_next_htbl(cur_hw_ste, next_htbl);
+		mlx5dr_ste_set_hit_addr_by_next_htbl(ste_ctx,
+						     cur_hw_ste, next_htbl);
 		ste->next_htbl = next_htbl;
 		next_htbl->pointing_ste = ste;
 	}
@@ -630,17 +612,19 @@ int mlx5dr_ste_htbl_free(struct mlx5dr_ste_htbl *htbl)
 	return 0;
 }
 
-static void dr_ste_arr_init_next_ste(u8 **last_ste,
+static void dr_ste_arr_init_next_ste(struct mlx5dr_ste_ctx *ste_ctx,
+				     u8 **last_ste,
 				     u32 *added_stes,
 				     enum mlx5dr_ste_entry_type entry_type,
 				     u16 gvmi)
 {
 	(*added_stes)++;
 	*last_ste += DR_STE_SIZE;
-	dr_ste_init(*last_ste, MLX5DR_STE_LU_TYPE_DONT_CARE, entry_type, gvmi);
+	ste_ctx->ste_init(*last_ste, MLX5DR_STE_LU_TYPE_DONT_CARE, entry_type, gvmi);
 }
 
-void mlx5dr_ste_set_actions_tx(struct mlx5dr_domain *dmn,
+void mlx5dr_ste_set_actions_tx(struct mlx5dr_ste_ctx *ste_ctx,
+			       struct mlx5dr_domain *dmn,
 			       u8 *action_type_set,
 			       u8 *last_ste,
 			       struct mlx5dr_ste_actions_attr *attr,
@@ -665,7 +649,8 @@ void mlx5dr_ste_set_actions_tx(struct mlx5dr_domain *dmn,
 
 		for (i = 0; i < attr->vlans.count; i++) {
 			if (i || action_type_set[DR_ACTION_TYP_MODIFY_HDR])
-				dr_ste_arr_init_next_ste(&last_ste,
+				dr_ste_arr_init_next_ste(ste_ctx,
+							 &last_ste,
 							 added_stes,
 							 MLX5DR_STE_TYPE_TX,
 							 attr->gvmi);
@@ -683,7 +668,8 @@ void mlx5dr_ste_set_actions_tx(struct mlx5dr_domain *dmn,
 		 */
 		if (action_type_set[DR_ACTION_TYP_MODIFY_HDR] ||
 		    action_type_set[DR_ACTION_TYP_PUSH_VLAN])
-			dr_ste_arr_init_next_ste(&last_ste,
+			dr_ste_arr_init_next_ste(ste_ctx,
+						 &last_ste,
 						 added_stes,
 						 MLX5DR_STE_TYPE_TX,
 						 attr->gvmi);
@@ -705,10 +691,11 @@ void mlx5dr_ste_set_actions_tx(struct mlx5dr_domain *dmn,
 		dr_ste_set_counter_id(last_ste, attr->ctr_id);
 
 	dr_ste_set_hit_gvmi(last_ste, attr->hit_gvmi);
-	mlx5dr_ste_set_hit_addr(last_ste, attr->final_icm_addr, 1);
+	mlx5dr_ste_set_hit_addr(ste_ctx, last_ste, attr->final_icm_addr, 1);
 }
 
-void mlx5dr_ste_set_actions_rx(struct mlx5dr_domain *dmn,
+void mlx5dr_ste_set_actions_rx(struct mlx5dr_ste_ctx *ste_ctx,
+			       struct mlx5dr_domain *dmn,
 			       u8 *action_type_set,
 			       u8 *last_ste,
 			       struct mlx5dr_ste_actions_attr *attr,
@@ -735,7 +722,8 @@ void mlx5dr_ste_set_actions_rx(struct mlx5dr_domain *dmn,
 			if (i ||
 			    action_type_set[DR_ACTION_TYP_TNL_L2_TO_L2] ||
 			    action_type_set[DR_ACTION_TYP_TNL_L3_TO_L2])
-				dr_ste_arr_init_next_ste(&last_ste,
+				dr_ste_arr_init_next_ste(ste_ctx,
+							 &last_ste,
 							 added_stes,
 							 MLX5DR_STE_TYPE_RX,
 							 attr->gvmi);
@@ -746,7 +734,8 @@ void mlx5dr_ste_set_actions_rx(struct mlx5dr_domain *dmn,
 
 	if (action_type_set[DR_ACTION_TYP_MODIFY_HDR]) {
 		if (dr_ste_get_entry_type(last_ste) == MLX5DR_STE_TYPE_MODIFY_PKT)
-			dr_ste_arr_init_next_ste(&last_ste,
+			dr_ste_arr_init_next_ste(ste_ctx,
+						 &last_ste,
 						 added_stes,
 						 MLX5DR_STE_TYPE_MODIFY_PKT,
 						 attr->gvmi);
@@ -760,7 +749,8 @@ void mlx5dr_ste_set_actions_rx(struct mlx5dr_domain *dmn,
 
 	if (action_type_set[DR_ACTION_TYP_TAG]) {
 		if (dr_ste_get_entry_type(last_ste) == MLX5DR_STE_TYPE_MODIFY_PKT)
-			dr_ste_arr_init_next_ste(&last_ste,
+			dr_ste_arr_init_next_ste(ste_ctx,
+						 &last_ste,
 						 added_stes,
 						 MLX5DR_STE_TYPE_RX,
 						 attr->gvmi);
@@ -769,7 +759,7 @@ void mlx5dr_ste_set_actions_rx(struct mlx5dr_domain *dmn,
 	}
 
 	dr_ste_set_hit_gvmi(last_ste, attr->hit_gvmi);
-	mlx5dr_ste_set_hit_addr(last_ste, attr->final_icm_addr, 1);
+	mlx5dr_ste_set_hit_addr(ste_ctx, last_ste, attr->final_icm_addr, 1);
 }
 
 int mlx5dr_ste_build_pre_check(struct mlx5dr_domain *dmn,
@@ -801,6 +791,7 @@ int mlx5dr_ste_build_ste_arr(struct mlx5dr_matcher *matcher,
 {
 	struct mlx5dr_domain_rx_tx *nic_dmn = nic_matcher->nic_tbl->nic_dmn;
 	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
+	struct mlx5dr_ste_ctx *ste_ctx = dmn->ste_ctx;
 	struct mlx5dr_ste_build *sb;
 	int ret, i;
 
@@ -811,10 +802,10 @@ int mlx5dr_ste_build_ste_arr(struct mlx5dr_matcher *matcher,
 
 	sb = nic_matcher->ste_builder;
 	for (i = 0; i < nic_matcher->num_of_builders; i++) {
-		dr_ste_init(ste_arr,
-			    sb->lu_type,
-			    nic_dmn->ste_type,
-			    dmn->info.caps.gvmi);
+		ste_ctx->ste_init(ste_arr,
+				  sb->lu_type,
+				  nic_dmn->ste_type,
+				  dmn->info.caps.gvmi);
 
 		mlx5dr_ste_set_bit_mask(ste_arr, sb->bit_mask);
 
@@ -828,8 +819,8 @@ int mlx5dr_ste_build_ste_arr(struct mlx5dr_matcher *matcher,
 			 * not relevant for the last ste in the chain.
 			 */
 			sb++;
-			MLX5_SET(ste_general, ste_arr, next_lu_type, sb->lu_type);
-			MLX5_SET(ste_general, ste_arr, byte_mask, sb->byte_mask);
+			ste_ctx->set_next_lu_type(ste_arr, sb->lu_type);
+			ste_ctx->set_byte_mask(ste_arr, sb->byte_mask);
 		}
 		ste_arr += DR_STE_SIZE;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index 2d8a7b1791d0..f23085a67b70 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -54,6 +54,72 @@ enum {
 	DR_STE_V0_LU_TYPE_DONT_CARE			= MLX5DR_STE_LU_TYPE_DONT_CARE,
 };
 
+static void dr_ste_v0_set_miss_addr(u8 *hw_ste_p, u64 miss_addr)
+{
+	u64 index = miss_addr >> 6;
+
+	/* Miss address for TX and RX STEs located in the same offsets */
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, miss_address_39_32, index >> 26);
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, miss_address_31_6, index);
+}
+
+static u64 dr_ste_v0_get_miss_addr(u8 *hw_ste_p)
+{
+	u64 index =
+		(MLX5_GET(ste_rx_steering_mult, hw_ste_p, miss_address_31_6) |
+		 MLX5_GET(ste_rx_steering_mult, hw_ste_p, miss_address_39_32) << 26);
+
+	return index << 6;
+}
+
+static void dr_ste_v0_set_byte_mask(u8 *hw_ste_p, u16 byte_mask)
+{
+	MLX5_SET(ste_general, hw_ste_p, byte_mask, byte_mask);
+}
+
+static u16 dr_ste_v0_get_byte_mask(u8 *hw_ste_p)
+{
+	return MLX5_GET(ste_general, hw_ste_p, byte_mask);
+}
+
+static void dr_ste_v0_set_lu_type(u8 *hw_ste_p, u16 lu_type)
+{
+	MLX5_SET(ste_general, hw_ste_p, entry_sub_type, lu_type);
+}
+
+static void dr_ste_v0_set_next_lu_type(u8 *hw_ste_p, u16 lu_type)
+{
+	MLX5_SET(ste_general, hw_ste_p, next_lu_type, lu_type);
+}
+
+static u16 dr_ste_v0_get_next_lu_type(u8 *hw_ste_p)
+{
+	return MLX5_GET(ste_general, hw_ste_p, next_lu_type);
+}
+
+static void dr_ste_v0_set_hit_addr(u8 *hw_ste_p, u64 icm_addr, u32 ht_size)
+{
+	u64 index = (icm_addr >> 5) | ht_size;
+
+	MLX5_SET(ste_general, hw_ste_p, next_table_base_39_32_size, index >> 27);
+	MLX5_SET(ste_general, hw_ste_p, next_table_base_31_5_size, index);
+}
+
+static void dr_ste_v0_init(u8 *hw_ste_p, u16 lu_type,
+			   u8 entry_type, u16 gvmi)
+{
+	MLX5_SET(ste_general, hw_ste_p, entry_type, entry_type);
+	dr_ste_v0_set_lu_type(hw_ste_p, lu_type);
+	dr_ste_v0_set_next_lu_type(hw_ste_p, MLX5DR_STE_LU_TYPE_DONT_CARE);
+
+	/* Set GVMI once, this is the same for RX/TX
+	 * bits 63_48 of next table base / miss address encode the next GVMI
+	 */
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, gvmi, gvmi);
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, next_table_base_63_48, gvmi);
+	MLX5_SET(ste_rx_steering_mult, hw_ste_p, miss_address_63_48, gvmi);
+}
+
 static void
 dr_ste_v0_build_eth_l2_src_dst_bit_mask(struct mlx5dr_match_param *value,
 					bool inner, u8 *bit_mask)
@@ -970,6 +1036,7 @@ dr_ste_v0_build_src_gvmi_qpn_init(struct mlx5dr_ste_build *sb,
 }
 
 struct mlx5dr_ste_ctx ste_ctx_v0 = {
+	/* Builders */
 	.build_eth_l2_src_dst_init	= &dr_ste_v0_build_eth_l2_src_dst_init,
 	.build_eth_l3_ipv6_src_init	= &dr_ste_v0_build_eth_l3_ipv6_src_init,
 	.build_eth_l3_ipv6_dst_init	= &dr_ste_v0_build_eth_l3_ipv6_dst_init,
@@ -990,4 +1057,14 @@ struct mlx5dr_ste_ctx ste_ctx_v0 = {
 	.build_register_0_init		= &dr_ste_v0_build_register_0_init,
 	.build_register_1_init		= &dr_ste_v0_build_register_1_init,
 	.build_src_gvmi_qpn_init	= &dr_ste_v0_build_src_gvmi_qpn_init,
+
+	/* Getters and Setters */
+	.ste_init			= &dr_ste_v0_init,
+	.set_next_lu_type		= &dr_ste_v0_set_next_lu_type,
+	.get_next_lu_type		= &dr_ste_v0_get_next_lu_type,
+	.set_miss_addr			= &dr_ste_v0_set_miss_addr,
+	.get_miss_addr			= &dr_ste_v0_get_miss_addr,
+	.set_hit_addr			= &dr_ste_v0_set_hit_addr,
+	.set_byte_mask			= &dr_ste_v0_set_byte_mask,
+	.get_byte_mask			= &dr_ste_v0_get_byte_mask,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 46812c209044..10f7cd56bc05 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -220,8 +220,13 @@ static inline void mlx5dr_htbl_get(struct mlx5dr_ste_htbl *htbl)
 
 /* STE utils */
 u32 mlx5dr_ste_calc_hash_index(u8 *hw_ste_p, struct mlx5dr_ste_htbl *htbl);
-void mlx5dr_ste_set_miss_addr(u8 *hw_ste, u64 miss_addr);
-void mlx5dr_ste_set_hit_addr(u8 *hw_ste, u64 icm_addr, u32 ht_size);
+void mlx5dr_ste_set_miss_addr(struct mlx5dr_ste_ctx *ste_ctx,
+			      u8 *hw_ste, u64 miss_addr);
+void mlx5dr_ste_set_hit_addr(struct mlx5dr_ste_ctx *ste_ctx,
+			     u8 *hw_ste, u64 icm_addr, u32 ht_size);
+void mlx5dr_ste_set_hit_addr_by_next_htbl(struct mlx5dr_ste_ctx *ste_ctx,
+					  u8 *hw_ste,
+					  struct mlx5dr_ste_htbl *next_htbl);
 void mlx5dr_ste_set_bit_mask(u8 *hw_ste_p, u8 *bit_mask);
 bool mlx5dr_ste_is_last_in_rule(struct mlx5dr_matcher_rx_tx *nic_matcher,
 				u8 ste_location);
@@ -250,12 +255,14 @@ struct mlx5dr_ste_actions_attr {
 	} vlans;
 };
 
-void mlx5dr_ste_set_actions_rx(struct mlx5dr_domain *dmn,
+void mlx5dr_ste_set_actions_rx(struct mlx5dr_ste_ctx *ste_ctx,
+			       struct mlx5dr_domain *dmn,
 			       u8 *action_type_set,
 			       u8 *last_ste,
 			       struct mlx5dr_ste_actions_attr *attr,
 			       u32 *added_stes);
-void mlx5dr_ste_set_actions_tx(struct mlx5dr_domain *dmn,
+void mlx5dr_ste_set_actions_tx(struct mlx5dr_ste_ctx *ste_ctx,
+			       struct mlx5dr_domain *dmn,
 			       u8 *action_type_set,
 			       u8 *last_ste,
 			       struct mlx5dr_ste_actions_attr *attr,
@@ -285,8 +292,6 @@ static inline bool mlx5dr_ste_is_not_used(struct mlx5dr_ste *ste)
 	return !ste->refcount;
 }
 
-void mlx5dr_ste_set_hit_addr_by_next_htbl(u8 *hw_ste,
-					  struct mlx5dr_ste_htbl *next_htbl);
 bool mlx5dr_ste_equal_tag(void *src, void *dst);
 int mlx5dr_ste_create_next_htbl(struct mlx5dr_matcher *matcher,
 				struct mlx5dr_matcher_rx_tx *nic_matcher,
@@ -1035,7 +1040,8 @@ int mlx5dr_ste_htbl_init_and_postsend(struct mlx5dr_domain *dmn,
 				      struct mlx5dr_ste_htbl *htbl,
 				      struct mlx5dr_htbl_connect_info *connect_info,
 				      bool update_hw_ste);
-void mlx5dr_ste_set_formatted_ste(u16 gvmi,
+void mlx5dr_ste_set_formatted_ste(struct mlx5dr_ste_ctx *ste_ctx,
+				  u16 gvmi,
 				  struct mlx5dr_domain_rx_tx *nic_dmn,
 				  struct mlx5dr_ste_htbl *htbl,
 				  u8 *formatted_ste,
-- 
2.26.2

