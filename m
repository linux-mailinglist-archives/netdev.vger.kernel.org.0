Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD842466EDC
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 01:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343763AbhLCA74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 19:59:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60670 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244843AbhLCA7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 19:59:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AACD6291C
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 00:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BED6C53FCC;
        Fri,  3 Dec 2021 00:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638492989;
        bh=WDg9siaRXBuQYSoALqIXc5gfTWy7a8fgQTZKIWHLjVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KVLLvP0v/CvYOkng82akPrBIqSKQ2nq4/9F6AVq7C2987SicZH6/R5U8o6Z0fY8z6
         g2ths9OWDcEaYQ+n+mTp7w8xLUOLYHExFowXis318LThYCvUeH4DBzyLBJVMa9pYlK
         Sy7ctwxTxvDV/wN2vlPv81nNSxJa+qAOfhM8AyJ0E+TqNShxMWBDozxlQLWNq29n9Z
         FNZU6+GT8g6BxATqkfKFSwoARgd/oJWnVbX38d4MpQMP0aYiO3eeYlY6sd+/NcVr6g
         xsfEul+rH6LLbtoURrZ4iEzFkJbCSXLPrJYasJ7a2bczZK+SJ32TDK+lErKx8BNF6C
         3mCsJoPSL0RrQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 09/14] net/mlx5e: TC, Remove redundant action stack var
Date:   Thu,  2 Dec 2021 16:56:17 -0800
Message-Id: <20211203005622.183325-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203005622.183325-1-saeed@kernel.org>
References: <20211203005622.183325-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Remove the action stack var from parse tc fdb actions
and prase tc nic actions, use the flow attr action var directly.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 89 +++++++++----------
 1 file changed, 42 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index ca74ed616382..d869907fdb70 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3457,7 +3457,6 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 	struct pedit_headers_action hdrs[2] = {};
 	const struct flow_action_entry *act;
 	struct mlx5_nic_flow_attr *nic_attr;
-	u32 action = 0;
 	int err, i;
 
 	if (!flow_action_has_entries(flow_action)) {
@@ -3478,12 +3477,12 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
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
@@ -3492,19 +3491,19 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
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
@@ -3517,8 +3516,8 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
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
@@ -3538,17 +3537,17 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
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
@@ -3567,8 +3566,6 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 		}
 	}
 
-	attr->action = action;
-
 	if (attr->dest_chain && parse_attr->mirred_ifindex[0]) {
 		NL_SET_ERR_MSG(extack, "Mirroring goto chain rules isn't supported");
 		return -EOPNOTSUPP;
@@ -3886,7 +3883,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	const struct flow_action_entry *act;
 	struct mlx5_esw_flow_attr *esw_attr;
 	bool encap = false, decap = false;
-	u32 action = attr->action;
 	int err, i, if_count = 0;
 	bool ptype_host = false;
 	bool mpls_push = false;
@@ -3908,8 +3904,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
@@ -3922,8 +3918,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
@@ -3931,8 +3927,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
@@ -3963,7 +3959,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			}
 
 			parse_attr->eth.h_proto = act->mpls_pop.proto;
-			action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+			attr->action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
 			flow_flag_set(flow, L3_TO_L2_DECAP);
 			break;
 		case FLOW_ACTION_MANGLE:
@@ -3974,12 +3970,12 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
 
@@ -4015,12 +4011,12 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				return -EOPNOTSUPP;
 			}
 
-			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
+			attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+					MLX5_FLOW_CONTEXT_ACTION_COUNT;
 
 			err = mlx5e_set_fwd_to_int_port_actions(priv, attr, out_dev->ifindex,
 								MLX5E_TC_INT_PORT_INGRESS,
-								&action, esw_attr->out_count);
+								&attr->action, esw_attr->out_count);
 			if (err)
 				return err;
 
@@ -4065,8 +4061,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				return -EOPNOTSUPP;
 			}
 
-			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
+			attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+					MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			if (encap) {
 				parse_attr->mirred_ifindex[esw_attr->out_count] =
 					out_dev->ifindex;
@@ -4102,14 +4098,14 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
@@ -4142,7 +4138,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				err = mlx5e_set_fwd_to_int_port_actions(priv, attr,
 									out_dev->ifindex,
 									MLX5E_TC_INT_PORT_EGRESS,
-									&action,
+									&attr->action,
 									esw_attr->out_count);
 				if (err)
 					return err;
@@ -4180,15 +4176,16 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
@@ -4199,7 +4196,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			err = add_vlan_rewrite_action(priv,
 						      MLX5_FLOW_NAMESPACE_FDB,
 						      act, parse_attr, hdrs,
-						      &action, extack);
+						      &attr->action, extack);
 			if (err)
 				return err;
 
@@ -4209,13 +4206,13 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
@@ -4262,19 +4259,17 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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

