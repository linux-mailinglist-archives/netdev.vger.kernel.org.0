Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E8E35FA46
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 20:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352296AbhDNSHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 14:07:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352111AbhDNSGj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 14:06:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2980061168;
        Wed, 14 Apr 2021 18:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618423577;
        bh=VozQ9ZshisX5NBhMkbb4RwXEocai18wlHXcZSckMRE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bR6bnkeQuYWXTUxy6mj8Lcu2qa4q5zdwV6ZT3eCgA7omAAtNXILIFK3Fl4E9a2/Yj
         w/8Fr88pdIaEfoJYUjVi71vQPBDqiyMEXkonbVnbx3JkDnB5WUZdDKgtBrpEV/Ux1N
         C175zsnR2xlW4Ktz3Yroo0oLtjQcnph5YLWI7aNYC5YDtdmI8EZmpwuGNOHbi4ZFME
         uAql2GfMdMtjreKpTgayQQ2Qq7z6APldcK9138F4jt+zYqThm8aaiiYPewPsPTbsnN
         e/Ho8fAJxIxrwTBA0+FeLaMTdutzaiOqvm/WAu/4tUYIUdtwF99Zfj/w3RplJHDfNC
         5/gBd6ECanJ/w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 10/16] net/mlx5: DR, Use variably sized data structures for different actions
Date:   Wed, 14 Apr 2021 11:05:59 -0700
Message-Id: <20210414180605.111070-11-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414180605.111070-1-saeed@kernel.org>
References: <20210414180605.111070-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@nvidia.com>

mlx5dr_action is a generally used data structure, and there is an
union for different types of actions in it. The size of mlx5dr_action
is about 72 bytes, but for those actions with fewer fields, most of
the allocated memory is wasted.
Remove this union, and mlx5dr_action becomes a generic action header.
Then actions are dynamically allocated with needed memory, the data
for each action is stored right after the header.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 242 ++++++++++--------
 .../mellanox/mlx5/core/steering/dr_send.c     |   8 +-
 .../mellanox/mlx5/core/steering/dr_table.c    |   4 +-
 .../mellanox/mlx5/core/steering/dr_types.h    | 104 ++++----
 4 files changed, 199 insertions(+), 159 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 28a7971cac6a..949879cf2092 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -313,8 +313,8 @@ static int dr_action_handle_cs_recalc(struct mlx5dr_domain *dmn,
 		 * table, since there is an *assumption* that in such case FW
 		 * will recalculate the CS.
 		 */
-		if (dest_action->dest_tbl.is_fw_tbl) {
-			*final_icm_addr = dest_action->dest_tbl.fw_tbl.rx_icm_addr;
+		if (dest_action->dest_tbl->is_fw_tbl) {
+			*final_icm_addr = dest_action->dest_tbl->fw_tbl.rx_icm_addr;
 		} else {
 			mlx5dr_dbg(dmn,
 				   "Destination FT should be terminating when modify TTL is used\n");
@@ -326,8 +326,8 @@ static int dr_action_handle_cs_recalc(struct mlx5dr_domain *dmn,
 		/* If destination is vport we will get the FW flow table
 		 * that recalculates the CS and forwards to the vport.
 		 */
-		ret = mlx5dr_domain_cache_get_recalc_cs_ft_addr(dest_action->vport.dmn,
-								dest_action->vport.caps->num,
+		ret = mlx5dr_domain_cache_get_recalc_cs_ft_addr(dest_action->vport->dmn,
+								dest_action->vport->caps->num,
 								final_icm_addr);
 		if (ret) {
 			mlx5dr_err(dmn, "Failed to get FW cs recalc flow table\n");
@@ -369,6 +369,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 	action_domain = dr_action_get_action_domain(dmn->type, nic_dmn->ste_type);
 
 	for (i = 0; i < num_actions; i++) {
+		struct mlx5dr_action_dest_tbl *dest_tbl;
 		struct mlx5dr_action *action;
 		int max_actions_type = 1;
 		u32 action_type;
@@ -382,37 +383,38 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 			break;
 		case DR_ACTION_TYP_FT:
 			dest_action = action;
-			if (!action->dest_tbl.is_fw_tbl) {
-				if (action->dest_tbl.tbl->dmn != dmn) {
+			dest_tbl = action->dest_tbl;
+			if (!dest_tbl->is_fw_tbl) {
+				if (dest_tbl->tbl->dmn != dmn) {
 					mlx5dr_err(dmn,
 						   "Destination table belongs to a different domain\n");
 					goto out_invalid_arg;
 				}
-				if (action->dest_tbl.tbl->level <= matcher->tbl->level) {
+				if (dest_tbl->tbl->level <= matcher->tbl->level) {
 					mlx5_core_warn_once(dmn->mdev,
 							    "Connecting table to a lower/same level destination table\n");
 					mlx5dr_dbg(dmn,
 						   "Connecting table at level %d to a destination table at level %d\n",
 						   matcher->tbl->level,
-						   action->dest_tbl.tbl->level);
+						   dest_tbl->tbl->level);
 				}
 				attr.final_icm_addr = rx_rule ?
-					action->dest_tbl.tbl->rx.s_anchor->chunk->icm_addr :
-					action->dest_tbl.tbl->tx.s_anchor->chunk->icm_addr;
+					dest_tbl->tbl->rx.s_anchor->chunk->icm_addr :
+					dest_tbl->tbl->tx.s_anchor->chunk->icm_addr;
 			} else {
 				struct mlx5dr_cmd_query_flow_table_details output;
 				int ret;
 
 				/* get the relevant addresses */
-				if (!action->dest_tbl.fw_tbl.rx_icm_addr) {
+				if (!action->dest_tbl->fw_tbl.rx_icm_addr) {
 					ret = mlx5dr_cmd_query_flow_table(dmn->mdev,
-									  action->dest_tbl.fw_tbl.type,
-									  action->dest_tbl.fw_tbl.id,
+									  dest_tbl->fw_tbl.type,
+									  dest_tbl->fw_tbl.id,
 									  &output);
 					if (!ret) {
-						action->dest_tbl.fw_tbl.tx_icm_addr =
+						dest_tbl->fw_tbl.tx_icm_addr =
 							output.sw_owner_icm_root_1;
-						action->dest_tbl.fw_tbl.rx_icm_addr =
+						dest_tbl->fw_tbl.rx_icm_addr =
 							output.sw_owner_icm_root_0;
 					} else {
 						mlx5dr_err(dmn,
@@ -422,50 +424,50 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 					}
 				}
 				attr.final_icm_addr = rx_rule ?
-					action->dest_tbl.fw_tbl.rx_icm_addr :
-					action->dest_tbl.fw_tbl.tx_icm_addr;
+					dest_tbl->fw_tbl.rx_icm_addr :
+					dest_tbl->fw_tbl.tx_icm_addr;
 			}
 			break;
 		case DR_ACTION_TYP_QP:
 			mlx5dr_info(dmn, "Domain doesn't support QP\n");
 			goto out_invalid_arg;
 		case DR_ACTION_TYP_CTR:
-			attr.ctr_id = action->ctr.ctr_id +
-				action->ctr.offeset;
+			attr.ctr_id = action->ctr->ctr_id +
+				action->ctr->offeset;
 			break;
 		case DR_ACTION_TYP_TAG:
-			attr.flow_tag = action->flow_tag;
+			attr.flow_tag = action->flow_tag->flow_tag;
 			break;
 		case DR_ACTION_TYP_TNL_L2_TO_L2:
 			break;
 		case DR_ACTION_TYP_TNL_L3_TO_L2:
-			attr.decap_index = action->rewrite.index;
-			attr.decap_actions = action->rewrite.num_of_actions;
+			attr.decap_index = action->rewrite->index;
+			attr.decap_actions = action->rewrite->num_of_actions;
 			attr.decap_with_vlan =
 				attr.decap_actions == WITH_VLAN_NUM_HW_ACTIONS;
 			break;
 		case DR_ACTION_TYP_MODIFY_HDR:
-			attr.modify_index = action->rewrite.index;
-			attr.modify_actions = action->rewrite.num_of_actions;
-			recalc_cs_required = action->rewrite.modify_ttl &&
+			attr.modify_index = action->rewrite->index;
+			attr.modify_actions = action->rewrite->num_of_actions;
+			recalc_cs_required = action->rewrite->modify_ttl &&
 					     !mlx5dr_ste_supp_ttl_cs_recalc(&dmn->info.caps);
 			break;
 		case DR_ACTION_TYP_L2_TO_TNL_L2:
 		case DR_ACTION_TYP_L2_TO_TNL_L3:
-			attr.reformat_size = action->reformat.reformat_size;
-			attr.reformat_id = action->reformat.reformat_id;
+			attr.reformat_size = action->reformat->reformat_size;
+			attr.reformat_id = action->reformat->reformat_id;
 			break;
 		case DR_ACTION_TYP_VPORT:
-			attr.hit_gvmi = action->vport.caps->vhca_gvmi;
+			attr.hit_gvmi = action->vport->caps->vhca_gvmi;
 			dest_action = action;
 			if (rx_rule) {
 				/* Loopback on WIRE vport is not supported */
-				if (action->vport.caps->num == WIRE_PORT)
+				if (action->vport->caps->num == WIRE_PORT)
 					goto out_invalid_arg;
 
-				attr.final_icm_addr = action->vport.caps->icm_address_rx;
+				attr.final_icm_addr = action->vport->caps->icm_address_rx;
 			} else {
-				attr.final_icm_addr = action->vport.caps->icm_address_tx;
+				attr.final_icm_addr = action->vport->caps->icm_address_tx;
 			}
 			break;
 		case DR_ACTION_TYP_POP_VLAN:
@@ -477,7 +479,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 			if (attr.vlans.count == MLX5DR_MAX_VLANS)
 				return -EINVAL;
 
-			attr.vlans.headers[attr.vlans.count++] = action->push_vlan.vlan_hdr;
+			attr.vlans.headers[attr.vlans.count++] = action->push_vlan->vlan_hdr;
 			break;
 		default:
 			goto out_invalid_arg;
@@ -530,17 +532,37 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 	return -EINVAL;
 }
 
+static unsigned int action_size[DR_ACTION_TYP_MAX] = {
+	[DR_ACTION_TYP_TNL_L2_TO_L2] = sizeof(struct mlx5dr_action_reformat),
+	[DR_ACTION_TYP_L2_TO_TNL_L2] = sizeof(struct mlx5dr_action_reformat),
+	[DR_ACTION_TYP_TNL_L3_TO_L2] = sizeof(struct mlx5dr_action_rewrite),
+	[DR_ACTION_TYP_L2_TO_TNL_L3] = sizeof(struct mlx5dr_action_reformat),
+	[DR_ACTION_TYP_FT]           = sizeof(struct mlx5dr_action_dest_tbl),
+	[DR_ACTION_TYP_CTR]          = sizeof(struct mlx5dr_action_ctr),
+	[DR_ACTION_TYP_TAG]          = sizeof(struct mlx5dr_action_flow_tag),
+	[DR_ACTION_TYP_MODIFY_HDR]   = sizeof(struct mlx5dr_action_rewrite),
+	[DR_ACTION_TYP_VPORT]        = sizeof(struct mlx5dr_action_vport),
+	[DR_ACTION_TYP_PUSH_VLAN]    = sizeof(struct mlx5dr_action_push_vlan),
+};
+
 static struct mlx5dr_action *
 dr_action_create_generic(enum mlx5dr_action_type action_type)
 {
 	struct mlx5dr_action *action;
+	int extra_size;
+
+	if (action_type < DR_ACTION_TYP_MAX)
+		extra_size = action_size[action_type];
+	else
+		return NULL;
 
-	action = kzalloc(sizeof(*action), GFP_KERNEL);
+	action = kzalloc(sizeof(*action) + extra_size, GFP_KERNEL);
 	if (!action)
 		return NULL;
 
 	action->action_type = action_type;
 	refcount_set(&action->refcount, 1);
+	action->data = action + 1;
 
 	return action;
 }
@@ -559,10 +581,10 @@ mlx5dr_action_create_dest_table_num(struct mlx5dr_domain *dmn, u32 table_num)
 	if (!action)
 		return NULL;
 
-	action->dest_tbl.is_fw_tbl = true;
-	action->dest_tbl.fw_tbl.dmn = dmn;
-	action->dest_tbl.fw_tbl.id = table_num;
-	action->dest_tbl.fw_tbl.type = FS_FT_FDB;
+	action->dest_tbl->is_fw_tbl = true;
+	action->dest_tbl->fw_tbl.dmn = dmn;
+	action->dest_tbl->fw_tbl.id = table_num;
+	action->dest_tbl->fw_tbl.type = FS_FT_FDB;
 	refcount_inc(&dmn->refcount);
 
 	return action;
@@ -579,7 +601,7 @@ mlx5dr_action_create_dest_table(struct mlx5dr_table *tbl)
 	if (!action)
 		goto dec_ref;
 
-	action->dest_tbl.tbl = tbl;
+	action->dest_tbl->tbl = tbl;
 
 	return action;
 
@@ -624,12 +646,12 @@ mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
 		case DR_ACTION_TYP_VPORT:
 			hw_dests[i].vport.flags = MLX5_FLOW_DEST_VPORT_VHCA_ID;
 			hw_dests[i].type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
-			hw_dests[i].vport.num = dest_action->vport.caps->num;
-			hw_dests[i].vport.vhca_id = dest_action->vport.caps->vhca_gvmi;
+			hw_dests[i].vport.num = dest_action->vport->caps->num;
+			hw_dests[i].vport.vhca_id = dest_action->vport->caps->vhca_gvmi;
 			if (reformat_action) {
 				reformat_req = true;
 				hw_dests[i].vport.reformat_id =
-					reformat_action->reformat.reformat_id;
+					reformat_action->reformat->reformat_id;
 				ref_actions[num_of_ref++] = reformat_action;
 				hw_dests[i].vport.flags |= MLX5_FLOW_DEST_VPORT_REFORMAT_ID;
 			}
@@ -637,10 +659,10 @@ mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
 
 		case DR_ACTION_TYP_FT:
 			hw_dests[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-			if (dest_action->dest_tbl.is_fw_tbl)
-				hw_dests[i].ft_id = dest_action->dest_tbl.fw_tbl.id;
+			if (dest_action->dest_tbl->is_fw_tbl)
+				hw_dests[i].ft_id = dest_action->dest_tbl->fw_tbl.id;
 			else
-				hw_dests[i].ft_id = dest_action->dest_tbl.tbl->table_id;
+				hw_dests[i].ft_id = dest_action->dest_tbl->tbl->table_id;
 			break;
 
 		default:
@@ -657,8 +679,8 @@ mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
 				      hw_dests,
 				      num_of_dests,
 				      reformat_req,
-				      &action->dest_tbl.fw_tbl.id,
-				      &action->dest_tbl.fw_tbl.group_id);
+				      &action->dest_tbl->fw_tbl.id,
+				      &action->dest_tbl->fw_tbl.group_id);
 	if (ret)
 		goto free_action;
 
@@ -667,11 +689,11 @@ mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
 	for (i = 0; i < num_of_ref; i++)
 		refcount_inc(&ref_actions[i]->refcount);
 
-	action->dest_tbl.is_fw_tbl = true;
-	action->dest_tbl.fw_tbl.dmn = dmn;
-	action->dest_tbl.fw_tbl.type = FS_FT_FDB;
-	action->dest_tbl.fw_tbl.ref_actions = ref_actions;
-	action->dest_tbl.fw_tbl.num_of_ref_actions = num_of_ref;
+	action->dest_tbl->is_fw_tbl = true;
+	action->dest_tbl->fw_tbl.dmn = dmn;
+	action->dest_tbl->fw_tbl.type = FS_FT_FDB;
+	action->dest_tbl->fw_tbl.ref_actions = ref_actions;
+	action->dest_tbl->fw_tbl.num_of_ref_actions = num_of_ref;
 
 	kfree(hw_dests);
 
@@ -696,10 +718,10 @@ mlx5dr_action_create_dest_flow_fw_table(struct mlx5dr_domain *dmn,
 	if (!action)
 		return NULL;
 
-	action->dest_tbl.is_fw_tbl = 1;
-	action->dest_tbl.fw_tbl.type = ft->type;
-	action->dest_tbl.fw_tbl.id = ft->id;
-	action->dest_tbl.fw_tbl.dmn = dmn;
+	action->dest_tbl->is_fw_tbl = 1;
+	action->dest_tbl->fw_tbl.type = ft->type;
+	action->dest_tbl->fw_tbl.id = ft->id;
+	action->dest_tbl->fw_tbl.dmn = dmn;
 
 	refcount_inc(&dmn->refcount);
 
@@ -715,7 +737,7 @@ mlx5dr_action_create_flow_counter(u32 counter_id)
 	if (!action)
 		return NULL;
 
-	action->ctr.ctr_id = counter_id;
+	action->ctr->ctr_id = counter_id;
 
 	return action;
 }
@@ -728,7 +750,7 @@ struct mlx5dr_action *mlx5dr_action_create_tag(u32 tag_value)
 	if (!action)
 		return NULL;
 
-	action->flow_tag = tag_value & 0xffffff;
+	action->flow_tag->flow_tag = tag_value & 0xffffff;
 
 	return action;
 }
@@ -794,8 +816,8 @@ dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
 		if (ret)
 			return ret;
 
-		action->reformat.reformat_id = reformat_id;
-		action->reformat.reformat_size = data_sz;
+		action->reformat->reformat_id = reformat_id;
+		action->reformat->reformat_size = data_sz;
 		return 0;
 	}
 	case DR_ACTION_TYP_TNL_L2_TO_L2:
@@ -811,28 +833,28 @@ dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
 							  data, data_sz,
 							  hw_actions,
 							  ACTION_CACHE_LINE_SIZE,
-							  &action->rewrite.num_of_actions);
+							  &action->rewrite->num_of_actions);
 		if (ret) {
 			mlx5dr_dbg(dmn, "Failed creating decap l3 action list\n");
 			return ret;
 		}
 
-		action->rewrite.chunk = mlx5dr_icm_alloc_chunk(dmn->action_icm_pool,
-							       DR_CHUNK_SIZE_8);
-		if (!action->rewrite.chunk) {
+		action->rewrite->chunk = mlx5dr_icm_alloc_chunk(dmn->action_icm_pool,
+								DR_CHUNK_SIZE_8);
+		if (!action->rewrite->chunk) {
 			mlx5dr_dbg(dmn, "Failed allocating modify header chunk\n");
 			return -ENOMEM;
 		}
 
-		action->rewrite.data = (void *)hw_actions;
-		action->rewrite.index = (action->rewrite.chunk->icm_addr -
+		action->rewrite->data = (void *)hw_actions;
+		action->rewrite->index = (action->rewrite->chunk->icm_addr -
 					 dmn->info.caps.hdr_modify_icm_addr) /
 					 ACTION_CACHE_LINE_SIZE;
 
 		ret = mlx5dr_send_postsend_action(dmn, action);
 		if (ret) {
 			mlx5dr_dbg(dmn, "Writing decap l3 actions to ICM failed\n");
-			mlx5dr_icm_free_chunk(action->rewrite.chunk);
+			mlx5dr_icm_free_chunk(action->rewrite->chunk);
 			return ret;
 		}
 		return 0;
@@ -867,7 +889,7 @@ struct mlx5dr_action *mlx5dr_action_create_push_vlan(struct mlx5dr_domain *dmn,
 	if (!action)
 		return NULL;
 
-	action->push_vlan.vlan_hdr = vlan_hdr_h;
+	action->push_vlan->vlan_hdr = vlan_hdr_h;
 	return action;
 }
 
@@ -898,7 +920,7 @@ mlx5dr_action_create_packet_reformat(struct mlx5dr_domain *dmn,
 	if (!action)
 		goto dec_ref;
 
-	action->reformat.dmn = dmn;
+	action->reformat->dmn = dmn;
 
 	ret = dr_action_create_reformat_action(dmn,
 					       data_sz,
@@ -1104,17 +1126,17 @@ dr_action_modify_check_set_field_limitation(struct mlx5dr_action *action,
 					    const __be64 *sw_action)
 {
 	u16 sw_field = MLX5_GET(set_action_in, sw_action, field);
-	struct mlx5dr_domain *dmn = action->rewrite.dmn;
+	struct mlx5dr_domain *dmn = action->rewrite->dmn;
 
 	if (sw_field == MLX5_ACTION_IN_FIELD_METADATA_REG_A) {
-		action->rewrite.allow_rx = 0;
+		action->rewrite->allow_rx = 0;
 		if (dmn->type != MLX5DR_DOMAIN_TYPE_NIC_TX) {
 			mlx5dr_dbg(dmn, "Unsupported field %d for RX/FDB set action\n",
 				   sw_field);
 			return -EINVAL;
 		}
 	} else if (sw_field == MLX5_ACTION_IN_FIELD_METADATA_REG_B) {
-		action->rewrite.allow_tx = 0;
+		action->rewrite->allow_tx = 0;
 		if (dmn->type != MLX5DR_DOMAIN_TYPE_NIC_RX) {
 			mlx5dr_dbg(dmn, "Unsupported field %d for TX/FDB set action\n",
 				   sw_field);
@@ -1122,7 +1144,7 @@ dr_action_modify_check_set_field_limitation(struct mlx5dr_action *action,
 		}
 	}
 
-	if (!action->rewrite.allow_rx && !action->rewrite.allow_tx) {
+	if (!action->rewrite->allow_rx && !action->rewrite->allow_tx) {
 		mlx5dr_dbg(dmn, "Modify SET actions not supported on both RX and TX\n");
 		return -EINVAL;
 	}
@@ -1135,7 +1157,7 @@ dr_action_modify_check_add_field_limitation(struct mlx5dr_action *action,
 					    const __be64 *sw_action)
 {
 	u16 sw_field = MLX5_GET(set_action_in, sw_action, field);
-	struct mlx5dr_domain *dmn = action->rewrite.dmn;
+	struct mlx5dr_domain *dmn = action->rewrite->dmn;
 
 	if (sw_field != MLX5_ACTION_IN_FIELD_OUT_IP_TTL &&
 	    sw_field != MLX5_ACTION_IN_FIELD_OUT_IPV6_HOPLIMIT &&
@@ -1153,7 +1175,7 @@ static int
 dr_action_modify_check_copy_field_limitation(struct mlx5dr_action *action,
 					     const __be64 *sw_action)
 {
-	struct mlx5dr_domain *dmn = action->rewrite.dmn;
+	struct mlx5dr_domain *dmn = action->rewrite->dmn;
 	u16 sw_fields[2];
 	int i;
 
@@ -1162,14 +1184,14 @@ dr_action_modify_check_copy_field_limitation(struct mlx5dr_action *action,
 
 	for (i = 0; i < 2; i++) {
 		if (sw_fields[i] == MLX5_ACTION_IN_FIELD_METADATA_REG_A) {
-			action->rewrite.allow_rx = 0;
+			action->rewrite->allow_rx = 0;
 			if (dmn->type != MLX5DR_DOMAIN_TYPE_NIC_TX) {
 				mlx5dr_dbg(dmn, "Unsupported field %d for RX/FDB set action\n",
 					   sw_fields[i]);
 				return -EINVAL;
 			}
 		} else if (sw_fields[i] == MLX5_ACTION_IN_FIELD_METADATA_REG_B) {
-			action->rewrite.allow_tx = 0;
+			action->rewrite->allow_tx = 0;
 			if (dmn->type != MLX5DR_DOMAIN_TYPE_NIC_RX) {
 				mlx5dr_dbg(dmn, "Unsupported field %d for TX/FDB set action\n",
 					   sw_fields[i]);
@@ -1178,7 +1200,7 @@ dr_action_modify_check_copy_field_limitation(struct mlx5dr_action *action,
 		}
 	}
 
-	if (!action->rewrite.allow_rx && !action->rewrite.allow_tx) {
+	if (!action->rewrite->allow_rx && !action->rewrite->allow_tx) {
 		mlx5dr_dbg(dmn, "Modify copy actions not supported on both RX and TX\n");
 		return -EINVAL;
 	}
@@ -1190,7 +1212,7 @@ static int
 dr_action_modify_check_field_limitation(struct mlx5dr_action *action,
 					const __be64 *sw_action)
 {
-	struct mlx5dr_domain *dmn = action->rewrite.dmn;
+	struct mlx5dr_domain *dmn = action->rewrite->dmn;
 	u8 action_type;
 	int ret;
 
@@ -1239,7 +1261,7 @@ static int dr_actions_convert_modify_header(struct mlx5dr_action *action,
 {
 	const struct mlx5dr_ste_action_modify_field *hw_dst_action_info;
 	const struct mlx5dr_ste_action_modify_field *hw_src_action_info;
-	struct mlx5dr_domain *dmn = action->rewrite.dmn;
+	struct mlx5dr_domain *dmn = action->rewrite->dmn;
 	int ret, i, hw_idx = 0;
 	__be64 *sw_action;
 	__be64 hw_action;
@@ -1249,8 +1271,8 @@ static int dr_actions_convert_modify_header(struct mlx5dr_action *action,
 
 	*modify_ttl = false;
 
-	action->rewrite.allow_rx = 1;
-	action->rewrite.allow_tx = 1;
+	action->rewrite->allow_rx = 1;
+	action->rewrite->allow_tx = 1;
 
 	for (i = 0; i < num_sw_actions; i++) {
 		sw_action = &sw_actions[i];
@@ -1358,13 +1380,13 @@ static int dr_action_create_modify_action(struct mlx5dr_domain *dmn,
 	if (ret)
 		goto free_hw_actions;
 
-	action->rewrite.chunk = chunk;
-	action->rewrite.modify_ttl = modify_ttl;
-	action->rewrite.data = (u8 *)hw_actions;
-	action->rewrite.num_of_actions = num_hw_actions;
-	action->rewrite.index = (chunk->icm_addr -
-				 dmn->info.caps.hdr_modify_icm_addr) /
-				 ACTION_CACHE_LINE_SIZE;
+	action->rewrite->chunk = chunk;
+	action->rewrite->modify_ttl = modify_ttl;
+	action->rewrite->data = (u8 *)hw_actions;
+	action->rewrite->num_of_actions = num_hw_actions;
+	action->rewrite->index = (chunk->icm_addr -
+				  dmn->info.caps.hdr_modify_icm_addr) /
+				  ACTION_CACHE_LINE_SIZE;
 
 	ret = mlx5dr_send_postsend_action(dmn, action);
 	if (ret)
@@ -1399,7 +1421,7 @@ mlx5dr_action_create_modify_header(struct mlx5dr_domain *dmn,
 	if (!action)
 		goto dec_ref;
 
-	action->rewrite.dmn = dmn;
+	action->rewrite->dmn = dmn;
 
 	ret = dr_action_create_modify_action(dmn,
 					     actions_sz,
@@ -1451,8 +1473,8 @@ mlx5dr_action_create_dest_vport(struct mlx5dr_domain *dmn,
 	if (!action)
 		return NULL;
 
-	action->vport.dmn = vport_dmn;
-	action->vport.caps = vport_cap;
+	action->vport->dmn = vport_dmn;
+	action->vport->caps = vport_cap;
 
 	return action;
 }
@@ -1464,44 +1486,44 @@ int mlx5dr_action_destroy(struct mlx5dr_action *action)
 
 	switch (action->action_type) {
 	case DR_ACTION_TYP_FT:
-		if (action->dest_tbl.is_fw_tbl)
-			refcount_dec(&action->dest_tbl.fw_tbl.dmn->refcount);
+		if (action->dest_tbl->is_fw_tbl)
+			refcount_dec(&action->dest_tbl->fw_tbl.dmn->refcount);
 		else
-			refcount_dec(&action->dest_tbl.tbl->refcount);
+			refcount_dec(&action->dest_tbl->tbl->refcount);
 
-		if (action->dest_tbl.is_fw_tbl &&
-		    action->dest_tbl.fw_tbl.num_of_ref_actions) {
+		if (action->dest_tbl->is_fw_tbl &&
+		    action->dest_tbl->fw_tbl.num_of_ref_actions) {
 			struct mlx5dr_action **ref_actions;
 			int i;
 
-			ref_actions = action->dest_tbl.fw_tbl.ref_actions;
-			for (i = 0; i < action->dest_tbl.fw_tbl.num_of_ref_actions; i++)
+			ref_actions = action->dest_tbl->fw_tbl.ref_actions;
+			for (i = 0; i < action->dest_tbl->fw_tbl.num_of_ref_actions; i++)
 				refcount_dec(&ref_actions[i]->refcount);
 
 			kfree(ref_actions);
 
-			mlx5dr_fw_destroy_md_tbl(action->dest_tbl.fw_tbl.dmn,
-						 action->dest_tbl.fw_tbl.id,
-						 action->dest_tbl.fw_tbl.group_id);
+			mlx5dr_fw_destroy_md_tbl(action->dest_tbl->fw_tbl.dmn,
+						 action->dest_tbl->fw_tbl.id,
+						 action->dest_tbl->fw_tbl.group_id);
 		}
 		break;
 	case DR_ACTION_TYP_TNL_L2_TO_L2:
-		refcount_dec(&action->reformat.dmn->refcount);
+		refcount_dec(&action->reformat->dmn->refcount);
 		break;
 	case DR_ACTION_TYP_TNL_L3_TO_L2:
-		mlx5dr_icm_free_chunk(action->rewrite.chunk);
-		refcount_dec(&action->reformat.dmn->refcount);
+		mlx5dr_icm_free_chunk(action->rewrite->chunk);
+		refcount_dec(&action->rewrite->dmn->refcount);
 		break;
 	case DR_ACTION_TYP_L2_TO_TNL_L2:
 	case DR_ACTION_TYP_L2_TO_TNL_L3:
-		mlx5dr_cmd_destroy_reformat_ctx((action->reformat.dmn)->mdev,
-						action->reformat.reformat_id);
-		refcount_dec(&action->reformat.dmn->refcount);
+		mlx5dr_cmd_destroy_reformat_ctx((action->reformat->dmn)->mdev,
+						action->reformat->reformat_id);
+		refcount_dec(&action->reformat->dmn->refcount);
 		break;
 	case DR_ACTION_TYP_MODIFY_HDR:
-		mlx5dr_icm_free_chunk(action->rewrite.chunk);
-		kfree(action->rewrite.data);
-		refcount_dec(&action->rewrite.dmn->refcount);
+		mlx5dr_icm_free_chunk(action->rewrite->chunk);
+		kfree(action->rewrite->data);
+		refcount_dec(&action->rewrite->dmn->refcount);
 		break;
 	default:
 		break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 8a6a56f9dc4e..24acced415d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -572,12 +572,12 @@ int mlx5dr_send_postsend_action(struct mlx5dr_domain *dmn,
 	struct postsend_info send_info = {};
 	int ret;
 
-	send_info.write.addr = (uintptr_t)action->rewrite.data;
-	send_info.write.length = action->rewrite.num_of_actions *
+	send_info.write.addr = (uintptr_t)action->rewrite->data;
+	send_info.write.length = action->rewrite->num_of_actions *
 				 DR_MODIFY_ACTION_SIZE;
 	send_info.write.lkey = 0;
-	send_info.remote_addr = action->rewrite.chunk->mr_addr;
-	send_info.rkey = action->rewrite.chunk->rkey;
+	send_info.remote_addr = action->rewrite->chunk->mr_addr;
+	send_info.rkey = action->rewrite->chunk->rkey;
 
 	ret = dr_postsend_icm_data(dmn, &send_info);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
index b599b6beb5b9..30ae3cda6d2e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -29,7 +29,7 @@ int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
 			last_htbl = tbl->rx.s_anchor;
 
 		tbl->rx.default_icm_addr = action ?
-			action->dest_tbl.tbl->rx.s_anchor->chunk->icm_addr :
+			action->dest_tbl->tbl->rx.s_anchor->chunk->icm_addr :
 			tbl->rx.nic_dmn->default_icm_addr;
 
 		info.type = CONNECT_MISS;
@@ -53,7 +53,7 @@ int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
 			last_htbl = tbl->tx.s_anchor;
 
 		tbl->tx.default_icm_addr = action ?
-			action->dest_tbl.tbl->tx.s_anchor->chunk->icm_addr :
+			action->dest_tbl->tbl->tx.s_anchor->chunk->icm_addr :
 			tbl->tx.nic_dmn->default_icm_addr;
 
 		info.type = CONNECT_MISS;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 4af0e4e6a13c..462673947f3c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -806,53 +806,71 @@ struct mlx5dr_ste_action_modify_field {
 	u8 l4_type;
 };
 
+struct mlx5dr_action_rewrite {
+	struct mlx5dr_domain *dmn;
+	struct mlx5dr_icm_chunk *chunk;
+	u8 *data;
+	u16 num_of_actions;
+	u32 index;
+	u8 allow_rx:1;
+	u8 allow_tx:1;
+	u8 modify_ttl:1;
+};
+
+struct mlx5dr_action_reformat {
+	struct mlx5dr_domain *dmn;
+	u32 reformat_id;
+	u32 reformat_size;
+};
+
+struct mlx5dr_action_dest_tbl {
+	u8 is_fw_tbl:1;
+	union {
+		struct mlx5dr_table *tbl;
+		struct {
+			struct mlx5dr_domain *dmn;
+			u32 id;
+			u32 group_id;
+			enum fs_flow_table_type type;
+			u64 rx_icm_addr;
+			u64 tx_icm_addr;
+			struct mlx5dr_action **ref_actions;
+			u32 num_of_ref_actions;
+		} fw_tbl;
+	};
+};
+
+struct mlx5dr_action_ctr {
+	u32 ctr_id;
+	u32 offeset;
+};
+
+struct mlx5dr_action_vport {
+	struct mlx5dr_domain *dmn;
+	struct mlx5dr_cmd_vport_cap *caps;
+};
+
+struct mlx5dr_action_push_vlan {
+	u32 vlan_hdr; /* tpid_pcp_dei_vid */
+};
+
+struct mlx5dr_action_flow_tag {
+	u32 flow_tag;
+};
+
 struct mlx5dr_action {
 	enum mlx5dr_action_type action_type;
 	refcount_t refcount;
+
 	union {
-		struct {
-			struct mlx5dr_domain *dmn;
-			struct mlx5dr_icm_chunk *chunk;
-			u8 *data;
-			u16 num_of_actions;
-			u32 index;
-			u8 allow_rx:1;
-			u8 allow_tx:1;
-			u8 modify_ttl:1;
-		} rewrite;
-		struct {
-			struct mlx5dr_domain *dmn;
-			u32 reformat_id;
-			u32 reformat_size;
-		} reformat;
-		struct {
-			u8 is_fw_tbl:1;
-			union {
-				struct mlx5dr_table *tbl;
-				struct {
-					struct mlx5dr_domain *dmn;
-					u32 id;
-					u32 group_id;
-					enum fs_flow_table_type type;
-					u64 rx_icm_addr;
-					u64 tx_icm_addr;
-					struct mlx5dr_action **ref_actions;
-					u32 num_of_ref_actions;
-				} fw_tbl;
-			};
-		} dest_tbl;
-		struct {
-			u32 ctr_id;
-			u32 offeset;
-		} ctr;
-		struct {
-			struct mlx5dr_domain *dmn;
-			struct mlx5dr_cmd_vport_cap *caps;
-		} vport;
-		struct {
-			u32 vlan_hdr; /* tpid_pcp_dei_vid */
-		} push_vlan;
-		u32 flow_tag;
+		void *data;
+		struct mlx5dr_action_rewrite *rewrite;
+		struct mlx5dr_action_reformat *reformat;
+		struct mlx5dr_action_dest_tbl *dest_tbl;
+		struct mlx5dr_action_ctr *ctr;
+		struct mlx5dr_action_vport *vport;
+		struct mlx5dr_action_push_vlan *push_vlan;
+		struct mlx5dr_action_flow_tag *flow_tag;
 	};
 };
 
-- 
2.30.2

