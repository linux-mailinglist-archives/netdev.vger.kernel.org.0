Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028F64424C2
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 01:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhKBAcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 20:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231857AbhKBAby (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 20:31:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17571610A3;
        Tue,  2 Nov 2021 00:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635812960;
        bh=HMpCX0iHY0hGWOBEuC1GVTf/1GGU7zDaZS1B8bj9BAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFTR9SCIwqhcJUQi8wN6yZV0iP3uQiiiIi7EH7dEavEYOBko4DjzrMvNM8cGr4jL5
         5zT4JmQ9vonY0kH3x3397QbSF9SxhyeotwpeHKNXden8Bd7wNnoGpJS4mos84soxLa
         418wGNxm6IjEl6ogB2BOqbakmEuAFl45G7LY8wFoJiay9u/buDi4u5kmVq+XX9xMqF
         0WDcxxBlWhx53FNUxiPy9KBeDU7fBLQbsDkpRKkXxEAh/q04pQA8R9CORgouKgZ+qe
         eZWjJrYUnWLZhIOdABRwD4FPYZo4Ze2127SHbSKopQEH3g/05MYHp0tLUuPbBYw1V9
         mLdtcOIDyDysA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 7/7] net/mlx5e: TC, Remove redundant action stack var
Date:   Mon,  1 Nov 2021 17:29:14 -0700
Message-Id: <20211102002914.1052888-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211102002914.1052888-1-saeed@kernel.org>
References: <20211102002914.1052888-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Remove the action stack var from parse tc fdb actions
and prase tc nic actions, use the flow attr action var directly.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 81 +++++++++----------
 1 file changed, 38 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index aa4da8d1e252..f14d87d103eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3452,7 +3452,6 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 	struct pedit_headers_action hdrs[2] = {};
 	const struct flow_action_entry *act;
 	struct mlx5_nic_flow_attr *nic_attr;
-	u32 action = 0;
 	int err, i;
 
 	if (!flow_action_has_entries(flow_action)) {
@@ -3473,12 +3472,12 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
 		case FLOW_ACTION_ACCEPT:
-			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
+			attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+					MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			break;
 		case FLOW_ACTION_DROP:
-			action |= MLX5_FLOW_CONTEXT_ACTION_DROP |
-				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
+			attr->action |= MLX5_FLOW_CONTEXT_ACTION_DROP |
+					MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			break;
 		case FLOW_ACTION_MANGLE:
 		case FLOW_ACTION_ADD:
@@ -3487,19 +3486,19 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 			if (err)
 				return err;
 
-			action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+			attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 			break;
 		case FLOW_ACTION_VLAN_MANGLE:
 			err = add_vlan_rewrite_action(priv,
 						      MLX5_FLOW_NAMESPACE_KERNEL,
 						      act, parse_attr, hdrs,
-						      &action, extack);
+						      &attr->action, extack);
 			if (err)
 				return err;
 
 			break;
 		case FLOW_ACTION_CSUM:
-			if (csum_offload_supported(priv, action,
+			if (csum_offload_supported(priv, attr->action,
 						   act->csum_flags,
 						   extack))
 				break;
@@ -3512,8 +3511,8 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 			    same_hw_devs(priv, netdev_priv(peer_dev))) {
 				parse_attr->mirred_ifindex[0] = peer_dev->ifindex;
 				flow_flag_set(flow, HAIRPIN);
-				action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-					  MLX5_FLOW_CONTEXT_ACTION_COUNT;
+				attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+						MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			} else {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "device is not on same HW, can't offload");
@@ -3533,17 +3532,17 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 			}
 
 			nic_attr->flow_tag = mark;
-			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+			attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 			}
 			break;
 		case FLOW_ACTION_GOTO:
-			err = validate_goto_chain(priv, flow, act, action,
+			err = validate_goto_chain(priv, flow, act, attr->action,
 						  extack);
 			if (err)
 				return err;
 
-			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
+			attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+					MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			attr->dest_chain = act->chain_index;
 			break;
 		case FLOW_ACTION_CT:
@@ -3560,8 +3559,6 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 		}
 	}
 
-	attr->action = action;
-
 	if (attr->dest_chain && parse_attr->mirred_ifindex[0]) {
 		NL_SET_ERR_MSG(extack, "Mirroring goto chain rules isn't supported");
 		return -EOPNOTSUPP;
@@ -3879,7 +3876,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	const struct flow_action_entry *act;
 	struct mlx5_esw_flow_attr *esw_attr;
 	bool encap = false, decap = false;
-	u32 action = attr->action;
 	int err, i, if_count = 0;
 	bool ptype_host = false;
 	bool mpls_push = false;
@@ -3901,8 +3897,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
 		case FLOW_ACTION_ACCEPT:
-			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-				MLX5_FLOW_CONTEXT_ACTION_COUNT;
+			attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+					MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			attr->flags |= MLX5_ESW_ATTR_FLAG_ACCEPT;
 			break;
 		case FLOW_ACTION_PTYPE:
@@ -3915,8 +3911,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			ptype_host = true;
 			break;
 		case FLOW_ACTION_DROP:
-			action |= MLX5_FLOW_CONTEXT_ACTION_DROP |
-				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
+			attr->action |= MLX5_FLOW_CONTEXT_ACTION_DROP |
+					MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			break;
 		case FLOW_ACTION_TRAP:
 			if (!flow_offload_has_one_action(flow_action)) {
@@ -3924,8 +3920,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 						   "action trap is supported as a sole action only");
 				return -EOPNOTSUPP;
 			}
-			action |= (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-				   MLX5_FLOW_CONTEXT_ACTION_COUNT);
+			attr->action |= (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+					 MLX5_FLOW_CONTEXT_ACTION_COUNT);
 			attr->flags |= MLX5_ESW_ATTR_FLAG_SLOW_PATH;
 			break;
 		case FLOW_ACTION_MPLS_PUSH:
@@ -3956,7 +3952,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			}
 
 			parse_attr->eth.h_proto = act->mpls_pop.proto;
-			action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+			attr->action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
 			flow_flag_set(flow, L3_TO_L2_DECAP);
 			break;
 		case FLOW_ACTION_MANGLE:
@@ -3967,12 +3963,12 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				return err;
 
 			if (!flow_flag_test(flow, L3_TO_L2_DECAP)) {
-				action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+				attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 				esw_attr->split_count = esw_attr->out_count;
 			}
 			break;
 		case FLOW_ACTION_CSUM:
-			if (csum_offload_supported(priv, action,
+			if (csum_offload_supported(priv, attr->action,
 						   act->csum_flags, extack))
 				break;
 
@@ -4058,8 +4054,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				return -EOPNOTSUPP;
 			}
 
-			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
+			attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+					MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			if (encap) {
 				parse_attr->mirred_ifindex[esw_attr->out_count] =
 					out_dev->ifindex;
@@ -4095,14 +4091,14 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				if (is_vlan_dev(out_dev)) {
 					err = add_vlan_push_action(priv, attr,
 								   &out_dev,
-								   &action, extack);
+								   &attr->action, extack);
 					if (err)
 						return err;
 				}
 
 				if (is_vlan_dev(parse_attr->filter_dev)) {
 					err = add_vlan_pop_action(priv, attr,
-								  &action, extack);
+								  &attr->action, extack);
 					if (err)
 						return err;
 				}
@@ -4173,15 +4169,16 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		case FLOW_ACTION_VLAN_PUSH:
 		case FLOW_ACTION_VLAN_POP:
 			if (act->id == FLOW_ACTION_VLAN_PUSH &&
-			    (action & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP)) {
+			    (attr->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP)) {
 				/* Replace vlan pop+push with vlan modify */
-				action &= ~MLX5_FLOW_CONTEXT_ACTION_VLAN_POP;
+				attr->action &= ~MLX5_FLOW_CONTEXT_ACTION_VLAN_POP;
 				err = add_vlan_rewrite_action(priv,
 							      MLX5_FLOW_NAMESPACE_FDB,
 							      act, parse_attr, hdrs,
-							      &action, extack);
+							      &attr->action, extack);
 			} else {
-				err = parse_tc_vlan_action(priv, act, esw_attr, &action, extack);
+				err = parse_tc_vlan_action(priv, act, esw_attr, &attr->action,
+							   extack);
 			}
 			if (err)
 				return err;
@@ -4192,7 +4189,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			err = add_vlan_rewrite_action(priv,
 						      MLX5_FLOW_NAMESPACE_FDB,
 						      act, parse_attr, hdrs,
-						      &action, extack);
+						      &attr->action, extack);
 			if (err)
 				return err;
 
@@ -4202,13 +4199,13 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			decap = true;
 			break;
 		case FLOW_ACTION_GOTO:
-			err = validate_goto_chain(priv, flow, act, action,
+			err = validate_goto_chain(priv, flow, act, attr->action,
 						  extack);
 			if (err)
 				return err;
 
-			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
+			attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+					MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			attr->dest_chain = act->chain_index;
 			break;
 		case FLOW_ACTION_CT:
@@ -4253,19 +4250,17 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	attr->ip_version = mlx5e_tc_get_ip_version(&parse_attr->spec, true);
 
 	if (MLX5_CAP_GEN(esw->dev, prio_tag_required) &&
-	    action & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP) {
+	    attr->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP) {
 		/* For prio tag mode, replace vlan pop with rewrite vlan prio
 		 * tag rewrite.
 		 */
-		action &= ~MLX5_FLOW_CONTEXT_ACTION_VLAN_POP;
+		attr->action &= ~MLX5_FLOW_CONTEXT_ACTION_VLAN_POP;
 		err = add_vlan_prio_tag_rewrite_action(priv, parse_attr, hdrs,
-						       &action, extack);
+						       &attr->action, extack);
 		if (err)
 			return err;
 	}
 
-	attr->action = action;
-
 	err = actions_prepare_mod_hdr_actions(priv, flow, attr, hdrs, extack);
 	if (err)
 		return err;
-- 
2.31.1

