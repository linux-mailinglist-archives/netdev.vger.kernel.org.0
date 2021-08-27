Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB23C3F91B2
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 03:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244091AbhH0A7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 20:59:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244085AbhH0A7S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 20:59:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C0CB60F91;
        Fri, 27 Aug 2021 00:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630025897;
        bh=317xJbddfP/k7C6tZlwLmaAonLcbtU1k93oJj+eZ9BQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6KMu01LWvvnXfh6gw6Hp6Vl4EFsmjOyku67+cD1Opk/OsBlKt9lp/AYjtPEdwQ2W
         PnBWg/tbaVyVwQDcJHRJjlWm4vEHJ62ZID88Uq6GVWwIDGMMm9sdIEkYqS5i4u7yxP
         608RsiE8lXEpY5QlDhWYEVO1TUQM6miPEDt1bBTDozrxpewhjEoh4F3sEIkok3Lbf+
         Q5oqkrHo9gbDSJOjNMD3MhF6Xf8sI6+qai6mlFskPR7zVN6NXp0EjIvRawBAS6CAPM
         cpTm6p0BzdqW+zCekfbBBSAYn0L7A1sYiwRP38aXDaxwlPXQXte6UQwJLJ2e7k6vG4
         7++B65rhue1sg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/17] net/mlx5: DR, Improve error flow in actions_build_ste_arr
Date:   Thu, 26 Aug 2021 17:57:50 -0700
Message-Id: <20210827005802.236119-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827005802.236119-1-saeed@kernel.org>
References: <20210827005802.236119-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Improve error flow and print actions sequence when an
invalid/unsupported sequence provided.

Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 72 ++++++++++++++-----
 1 file changed, 56 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index bdaeb1b54640..e311faa78f9e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -25,6 +25,32 @@ enum dr_action_valid_state {
 	DR_ACTION_STATE_MAX,
 };
 
+static const char * const action_type_to_str[] = {
+	[DR_ACTION_TYP_TNL_L2_TO_L2] = "DR_ACTION_TYP_TNL_L2_TO_L2",
+	[DR_ACTION_TYP_L2_TO_TNL_L2] = "DR_ACTION_TYP_L2_TO_TNL_L2",
+	[DR_ACTION_TYP_TNL_L3_TO_L2] = "DR_ACTION_TYP_TNL_L3_TO_L2",
+	[DR_ACTION_TYP_L2_TO_TNL_L3] = "DR_ACTION_TYP_L2_TO_TNL_L3",
+	[DR_ACTION_TYP_DROP] = "DR_ACTION_TYP_DROP",
+	[DR_ACTION_TYP_QP] = "DR_ACTION_TYP_QP",
+	[DR_ACTION_TYP_FT] = "DR_ACTION_TYP_FT",
+	[DR_ACTION_TYP_CTR] = "DR_ACTION_TYP_CTR",
+	[DR_ACTION_TYP_TAG] = "DR_ACTION_TYP_TAG",
+	[DR_ACTION_TYP_MODIFY_HDR] = "DR_ACTION_TYP_MODIFY_HDR",
+	[DR_ACTION_TYP_VPORT] = "DR_ACTION_TYP_VPORT",
+	[DR_ACTION_TYP_POP_VLAN] = "DR_ACTION_TYP_POP_VLAN",
+	[DR_ACTION_TYP_PUSH_VLAN] = "DR_ACTION_TYP_PUSH_VLAN",
+	[DR_ACTION_TYP_INSERT_HDR] = "DR_ACTION_TYP_INSERT_HDR",
+	[DR_ACTION_TYP_REMOVE_HDR] = "DR_ACTION_TYP_REMOVE_HDR",
+	[DR_ACTION_TYP_MAX] = "DR_ACTION_UNKNOWN",
+};
+
+static const char *dr_action_id_to_str(enum mlx5dr_action_type action_id)
+{
+	if (action_id > DR_ACTION_TYP_MAX)
+		action_id = DR_ACTION_TYP_MAX;
+	return action_type_to_str[action_id];
+}
+
 static const enum dr_action_valid_state
 next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX] = {
 	[DR_ACTION_DOMAIN_NIC_INGRESS] = {
@@ -503,6 +529,18 @@ static int dr_action_handle_cs_recalc(struct mlx5dr_domain *dmn,
 	return 0;
 }
 
+static void dr_action_print_sequence(struct mlx5dr_domain *dmn,
+				     struct mlx5dr_action *actions[],
+				     int last_idx)
+{
+	int i;
+
+	for (i = 0; i <= last_idx; i++)
+		mlx5dr_err(dmn, "< %s (%d) > ",
+			   dr_action_id_to_str(actions[i]->action_type),
+			   actions[i]->action_type);
+}
+
 #define WITH_VLAN_NUM_HW_ACTIONS 6
 
 int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
@@ -549,7 +587,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 				if (dest_tbl->tbl->dmn != dmn) {
 					mlx5dr_err(dmn,
 						   "Destination table belongs to a different domain\n");
-					goto out_invalid_arg;
+					return -EINVAL;
 				}
 				if (dest_tbl->tbl->level <= matcher->tbl->level) {
 					mlx5_core_warn_once(dmn->mdev,
@@ -591,7 +629,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 			break;
 		case DR_ACTION_TYP_QP:
 			mlx5dr_info(dmn, "Domain doesn't support QP\n");
-			goto out_invalid_arg;
+			return -EOPNOTSUPP;
 		case DR_ACTION_TYP_CTR:
 			attr.ctr_id = action->ctr->ctr_id +
 				action->ctr->offeset;
@@ -618,7 +656,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 			if (rx_rule &&
 			    !(dmn->ste_ctx->actions_caps & DR_STE_CTX_ACTION_CAP_RX_ENCAP)) {
 				mlx5dr_info(dmn, "Device doesn't support Encap on RX\n");
-				goto out_invalid_arg;
+				return -EOPNOTSUPP;
 			}
 			attr.reformat.size = action->reformat->size;
 			attr.reformat.id = action->reformat->id;
@@ -631,10 +669,10 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 			attr.hit_gvmi = action->vport->caps->vhca_gvmi;
 			dest_action = action;
 			if (rx_rule) {
-				/* Loopback on WIRE vport is not supported */
-				if (action->vport->caps->num == WIRE_PORT)
-					goto out_invalid_arg;
-
+				if (action->vport->caps->num == WIRE_PORT) {
+					mlx5dr_dbg(dmn, "Device doesn't support Loopback on WIRE vport\n");
+					return -EOPNOTSUPP;
+				}
 				attr.final_icm_addr = action->vport->caps->icm_address_rx;
 			} else {
 				attr.final_icm_addr = action->vport->caps->icm_address_tx;
@@ -644,7 +682,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 			if (!rx_rule && !(dmn->ste_ctx->actions_caps &
 					  DR_STE_CTX_ACTION_CAP_TX_POP)) {
 				mlx5dr_dbg(dmn, "Device doesn't support POP VLAN action on TX\n");
-				goto out_invalid_arg;
+				return -EOPNOTSUPP;
 			}
 
 			max_actions_type = MLX5DR_MAX_VLANS;
@@ -654,12 +692,14 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 			if (rx_rule && !(dmn->ste_ctx->actions_caps &
 					 DR_STE_CTX_ACTION_CAP_RX_PUSH)) {
 				mlx5dr_dbg(dmn, "Device doesn't support PUSH VLAN action on RX\n");
-				goto out_invalid_arg;
+				return -EOPNOTSUPP;
 			}
 
 			max_actions_type = MLX5DR_MAX_VLANS;
-			if (attr.vlans.count == MLX5DR_MAX_VLANS)
+			if (attr.vlans.count == MLX5DR_MAX_VLANS) {
+				mlx5dr_dbg(dmn, "Max VLAN push/pop count exceeded\n");
 				return -EINVAL;
+			}
 
 			attr.vlans.headers[attr.vlans.count++] = action->push_vlan->vlan_hdr;
 			break;
@@ -671,21 +711,24 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 			attr.reformat.param_1 = action->reformat->param_1;
 			break;
 		default:
-			goto out_invalid_arg;
+			mlx5dr_err(dmn, "Unsupported action type %d\n", action_type);
+			return -EINVAL;
 		}
 
 		/* Check action duplication */
 		if (++action_type_set[action_type] > max_actions_type) {
 			mlx5dr_err(dmn, "Action type %d supports only max %d time(s)\n",
 				   action_type, max_actions_type);
-			goto out_invalid_arg;
+			return -EINVAL;
 		}
 
 		/* Check action state machine is valid */
 		if (dr_action_validate_and_get_next_state(action_domain,
 							  action_type,
 							  &state)) {
-			mlx5dr_err(dmn, "Invalid action sequence provided\n");
+			mlx5dr_err(dmn, "Invalid action (gvmi: %d, is_rx: %d) sequence provided:",
+				   attr.gvmi, rx_rule);
+			dr_action_print_sequence(dmn, actions, i);
 			return -EOPNOTSUPP;
 		}
 	}
@@ -716,9 +759,6 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 			 new_hw_ste_arr_sz);
 
 	return 0;
-
-out_invalid_arg:
-	return -EINVAL;
 }
 
 static unsigned int action_size[DR_ACTION_TYP_MAX] = {
-- 
2.31.1

