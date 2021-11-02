Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D03B443236
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 17:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbhKBQCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 12:02:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233684AbhKBQCf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 12:02:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 890676112D;
        Tue,  2 Nov 2021 16:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635868800;
        bh=5LtcTdqX9mOYiQzmb/gGeVgreS304xKY2ruZiwu+Dww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iPmLn8UyCgNAIJm1TZYktCCcYiLVoBx6CVE37DP7RkPEyCAwFT4vgq+WsRbmrJrAf
         DObj7j7bsMw5hHyGWkjBzv9Iuq5f5CFPkigdxmMwtlYWqcu7N+rud2PaiUZgfWX/Co
         sEmKF8D6azr//Xa9Q4wAkwARKSGfJBD5TBzZ1idEvishOZSa6rBi0jEh/7l/3BNX6S
         LwMyw6zIBt9vAtOa68RDKCOBTlv93i7m1n789cbRcLDTiI3JMTi4dnGNnV7qZ9AH5j
         HVKfkX3Jz+t/TdxZdSU6PtgDJynlYZJUFFIXH8wxg0ajN03Zx2e87crBtShjzVnUCC
         N8WJSdbABC0Ng==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v2 7/7] net/mlx5e: TC, Remove redundant action stack var
Date:   Tue,  2 Nov 2021 08:59:48 -0700
Message-Id: <20211102155948.1143487-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211102155948.1143487-1-saeed@kernel.org>
References: <20211102155948.1143487-1-saeed@kernel.org>
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
 .../mellanox/mlx5/core/en/tc_tun_encap.c      |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 89 +++++++++----------
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  1 -
 3 files changed, 42 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 660cca73c36c..9111b6971ee6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -28,7 +28,7 @@ static int mlx5e_set_int_port_tunnel(struct mlx5e_priv *priv,
 
 	err = mlx5e_set_fwd_to_int_port_actions(priv, attr, e->route_dev_ifindex,
 						MLX5E_TC_INT_PORT_EGRESS,
-						&attr->action, out_index);
+						out_index);
 
 out:
 	if (route_dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index aa4da8d1e252..e2bb7f8a0833 100644
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
@@ -3827,7 +3824,6 @@ int mlx5e_set_fwd_to_int_port_actions(struct mlx5e_priv *priv,
 				      struct mlx5_flow_attr *attr,
 				      int ifindex,
 				      enum mlx5e_tc_int_port_type type,
-				      u32 *action,
 				      int out_index)
 {
 	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
@@ -3851,7 +3847,7 @@ int mlx5e_set_fwd_to_int_port_actions(struct mlx5e_priv *priv,
 		return err;
 	}
 
-	*action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 
 	esw_attr->dest_int_port = dest_int_port;
 	esw_attr->dests[out_index].flags |= MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE;
@@ -3879,7 +3875,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	const struct flow_action_entry *act;
 	struct mlx5_esw_flow_attr *esw_attr;
 	bool encap = false, decap = false;
-	u32 action = attr->action;
 	int err, i, if_count = 0;
 	bool ptype_host = false;
 	bool mpls_push = false;
@@ -3901,8 +3896,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
@@ -3915,8 +3910,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
@@ -3924,8 +3919,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
@@ -3956,7 +3951,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			}
 
 			parse_attr->eth.h_proto = act->mpls_pop.proto;
-			action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
+			attr->action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
 			flow_flag_set(flow, L3_TO_L2_DECAP);
 			break;
 		case FLOW_ACTION_MANGLE:
@@ -3967,12 +3962,12 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
 
@@ -4008,12 +4003,12 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				return -EOPNOTSUPP;
 			}
 
-			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+			attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
 				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
 
 			err = mlx5e_set_fwd_to_int_port_actions(priv, attr, out_dev->ifindex,
 								MLX5E_TC_INT_PORT_INGRESS,
-								&action, esw_attr->out_count);
+								esw_attr->out_count);
 			if (err)
 				return err;
 
@@ -4058,8 +4053,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				return -EOPNOTSUPP;
 			}
 
-			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
+			attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+					MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			if (encap) {
 				parse_attr->mirred_ifindex[esw_attr->out_count] =
 					out_dev->ifindex;
@@ -4095,14 +4090,14 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
@@ -4135,7 +4130,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				err = mlx5e_set_fwd_to_int_port_actions(priv, attr,
 									out_dev->ifindex,
 									MLX5E_TC_INT_PORT_EGRESS,
-									&action,
 									esw_attr->out_count);
 				if (err)
 					return err;
@@ -4173,15 +4167,16 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
@@ -4192,7 +4187,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			err = add_vlan_rewrite_action(priv,
 						      MLX5_FLOW_NAMESPACE_FDB,
 						      act, parse_attr, hdrs,
-						      &action, extack);
+						      &attr->action, extack);
 			if (err)
 				return err;
 
@@ -4202,13 +4197,13 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
@@ -4253,19 +4248,17 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index eb042f0f5a41..3a470ec78c0b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -285,7 +285,6 @@ int mlx5e_set_fwd_to_int_port_actions(struct mlx5e_priv *priv,
 				      struct mlx5_flow_attr *attr,
 				      int ifindex,
 				      enum mlx5e_tc_int_port_type type,
-				      u32 *action,
 				      int out_index);
 #else /* CONFIG_MLX5_CLS_ACT */
 static inline int  mlx5e_tc_nic_init(struct mlx5e_priv *priv) { return 0; }
-- 
2.31.1

