Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C627748A535
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346176AbiAKBnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:43:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48782 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344470AbiAKBns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:43:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06DCA61490
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 01:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61721C36AF3;
        Tue, 11 Jan 2022 01:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641865427;
        bh=+NC2czLkB85lMvdulJeKgGVpSGFoWbyuF0cSEuMpWO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGvPR9jGyege3el3y29yjffATmnXqO5yxXpxY8QhknISt5BssljaOIFbLtyadW+17
         UIMt4vIeTygMktSm0eXNSCt48s3ac9hMBgyA9c1HaMOX5nctm1z8tsEQavNJw+e/7Y
         FIL+8IQ6hUXf285+NaIKyWcvvxPNWww9HSRFEXKhIMnLzJ34/oeGhnssoBmMMuNf1y
         PvFHAIZ7C4lk2NHDIHYDElxJ1NeamHpA0/0N0DbSpucrsJg9ACtpDLFcOYJBtCDrfO
         8myun09DuJIDtP7eYPnkbAxfmvd+2cHIpTo4nN4AIRIkvAmYDF+oOseV6H5wHolyz9
         w7/hRr/F4B6xQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/17] net/mlx5e: TC, Move pedit_headers_action to parse_attr
Date:   Mon, 10 Jan 2022 17:43:23 -0800
Message-Id: <20220111014335.178121-6-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111014335.178121-1-saeed@kernel.org>
References: <20220111014335.178121-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Move pedit_headers_action from flow parse_state to flow parse_attr.
In a follow up commit we are going to have multiple attr per flow
and pedit_headers_action are unique per attr.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/act/act.h        |  1 -
 .../mellanox/mlx5/core/en/tc/act/pedit.c      |  8 +++---
 .../mellanox/mlx5/core/en/tc/act/pedit.h      |  1 -
 .../mellanox/mlx5/core/en/tc/act/vlan.c       | 10 +++-----
 .../mellanox/mlx5/core/en/tc/act/vlan.h       |  1 -
 .../mlx5/core/en/tc/act/vlan_mangle.c         |  6 ++---
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 25 +++++++------------
 8 files changed, 19 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index 26efa33de56f..48c06a20aecf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -21,7 +21,6 @@ struct mlx5e_tc_act_parse_state {
 	bool mpls_push;
 	bool ptype_host;
 	const struct ip_tunnel_info *tun_info;
-	struct pedit_headers_action hdrs[__PEDIT_CMD_MAX];
 	int ifindexes[MLX5_MAX_FLOW_FWD_VPORTS];
 	int if_count;
 	struct mlx5_tc_ct_priv *ct_priv;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.c
index 79addbbef087..a70460c1b98d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.c
@@ -46,9 +46,9 @@ static int
 parse_pedit_to_modify_hdr(struct mlx5e_priv *priv,
 			  const struct flow_action_entry *act, int namespace,
 			  struct mlx5e_tc_flow_parse_attr *parse_attr,
-			  struct pedit_headers_action *hdrs,
 			  struct netlink_ext_ack *extack)
 {
+	struct pedit_headers_action *hdrs = parse_attr->hdrs;
 	u8 cmd = (act->id == FLOW_ACTION_MANGLE) ? 0 : 1;
 	u8 htype = act->mangle.htype;
 	int err = -EOPNOTSUPP;
@@ -110,14 +110,13 @@ int
 mlx5e_tc_act_pedit_parse_action(struct mlx5e_priv *priv,
 				const struct flow_action_entry *act, int namespace,
 				struct mlx5e_tc_flow_parse_attr *parse_attr,
-				struct pedit_headers_action *hdrs,
 				struct mlx5e_tc_flow *flow,
 				struct netlink_ext_ack *extack)
 {
 	if (flow && flow_flag_test(flow, L3_TO_L2_DECAP))
 		return parse_pedit_to_reformat(act, parse_attr, extack);
 
-	return parse_pedit_to_modify_hdr(priv, act, namespace, parse_attr, hdrs, extack);
+	return parse_pedit_to_modify_hdr(priv, act, namespace, parse_attr, extack);
 }
 
 static bool
@@ -141,8 +140,7 @@ tc_act_parse_pedit(struct mlx5e_tc_act_parse_state *parse_state,
 
 	ns_type = mlx5e_get_flow_namespace(flow);
 
-	err = mlx5e_tc_act_pedit_parse_action(flow->priv, act, ns_type,
-					      attr->parse_attr, parse_state->hdrs,
+	err = mlx5e_tc_act_pedit_parse_action(flow->priv, act, ns_type, attr->parse_attr,
 					      flow, parse_state->extack);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.h
index da8ab03af58f..258f030a2dc6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.h
@@ -25,7 +25,6 @@ int
 mlx5e_tc_act_pedit_parse_action(struct mlx5e_priv *priv,
 				const struct flow_action_entry *act, int namespace,
 				struct mlx5e_tc_flow_parse_attr *parse_attr,
-				struct pedit_headers_action *hdrs,
 				struct mlx5e_tc_flow *flow,
 				struct netlink_ext_ack *extack);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
index 70fc0c2d8813..f4659254f8f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
@@ -9,7 +9,6 @@
 static int
 add_vlan_prio_tag_rewrite_action(struct mlx5e_priv *priv,
 				 struct mlx5e_tc_flow_parse_attr *parse_attr,
-				 struct pedit_headers_action *hdrs,
 				 u32 *action, struct netlink_ext_ack *extack)
 {
 	const struct flow_action_entry prio_tag_act = {
@@ -26,7 +25,7 @@ add_vlan_prio_tag_rewrite_action(struct mlx5e_priv *priv,
 	};
 
 	return mlx5e_tc_act_vlan_add_rewrite_action(priv, MLX5_FLOW_NAMESPACE_FDB,
-						    &prio_tag_act, parse_attr, hdrs, action,
+						    &prio_tag_act, parse_attr, action,
 						    extack);
 }
 
@@ -170,8 +169,8 @@ tc_act_parse_vlan(struct mlx5e_tc_act_parse_state *parse_state,
 		/* Replace vlan pop+push with vlan modify */
 		attr->action &= ~MLX5_FLOW_CONTEXT_ACTION_VLAN_POP;
 		err = mlx5e_tc_act_vlan_add_rewrite_action(priv, MLX5_FLOW_NAMESPACE_FDB, act,
-							   attr->parse_attr, parse_state->hdrs,
-							   &attr->action, parse_state->extack);
+							   attr->parse_attr, &attr->action,
+							   parse_state->extack);
 	} else {
 		err = parse_tc_vlan_action(priv, act, esw_attr, &attr->action,
 					   parse_state->extack);
@@ -191,7 +190,6 @@ tc_act_post_parse_vlan(struct mlx5e_tc_act_parse_state *parse_state,
 		       struct mlx5_flow_attr *attr)
 {
 	struct mlx5e_tc_flow_parse_attr *parse_attr = attr->parse_attr;
-	struct pedit_headers_action *hdrs = parse_state->hdrs;
 	struct netlink_ext_ack *extack = parse_state->extack;
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	int err;
@@ -202,7 +200,7 @@ tc_act_post_parse_vlan(struct mlx5e_tc_act_parse_state *parse_state,
 		 * tag rewrite.
 		 */
 		attr->action &= ~MLX5_FLOW_CONTEXT_ACTION_VLAN_POP;
-		err = add_vlan_prio_tag_rewrite_action(priv, parse_attr, hdrs,
+		err = add_vlan_prio_tag_rewrite_action(priv, parse_attr,
 						       &attr->action, extack);
 		if (err)
 			return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.h
index 3d62f13ab61f..2fa58c6f44eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.h
@@ -24,7 +24,6 @@ int
 mlx5e_tc_act_vlan_add_rewrite_action(struct mlx5e_priv *priv, int namespace,
 				     const struct flow_action_entry *act,
 				     struct mlx5e_tc_flow_parse_attr *parse_attr,
-				     struct pedit_headers_action *hdrs,
 				     u32 *action, struct netlink_ext_ack *extack);
 
 #endif /* __MLX5_EN_TC_ACT_VLAN_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan_mangle.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan_mangle.c
index 63e36e7f53e3..396b32e4b6e2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan_mangle.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan_mangle.c
@@ -12,7 +12,6 @@ int
 mlx5e_tc_act_vlan_add_rewrite_action(struct mlx5e_priv *priv, int namespace,
 				     const struct flow_action_entry *act,
 				     struct mlx5e_tc_flow_parse_attr *parse_attr,
-				     struct pedit_headers_action *hdrs,
 				     u32 *action, struct netlink_ext_ack *extack)
 {
 	u16 mask16 = VLAN_VID_MASK;
@@ -44,7 +43,7 @@ mlx5e_tc_act_vlan_add_rewrite_action(struct mlx5e_priv *priv, int namespace,
 		return -EOPNOTSUPP;
 	}
 
-	err = mlx5e_tc_act_pedit_parse_action(priv, &pedit_act, namespace, parse_attr, hdrs,
+	err = mlx5e_tc_act_pedit_parse_action(priv, &pedit_act, namespace, parse_attr,
 					      NULL, extack);
 	*action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 
@@ -69,8 +68,7 @@ tc_act_parse_vlan_mangle(struct mlx5e_tc_act_parse_state *parse_state,
 	int err;
 
 	ns_type = mlx5e_get_flow_namespace(parse_state->flow);
-	err = mlx5e_tc_act_vlan_add_rewrite_action(priv, ns_type, act,
-						   attr->parse_attr, parse_state->hdrs,
+	err = mlx5e_tc_act_vlan_add_rewrite_action(priv, ns_type, act, attr->parse_attr,
 						   &attr->action, parse_state->extack);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index f832c26ff2c3..375763f1561a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -37,6 +37,7 @@ struct mlx5e_tc_flow_parse_attr {
 	const struct ip_tunnel_info *tun_info[MLX5_MAX_FLOW_FWD_VPORTS];
 	struct net_device *filter_dev;
 	struct mlx5_flow_spec spec;
+	struct pedit_headers_action hdrs[__PEDIT_CMD_MAX];
 	struct mlx5e_tc_mod_hdr_acts mod_hdr_acts;
 	int mirred_ifindex[MLX5_MAX_FLOW_FWD_VPORTS];
 	struct ethhdr eth;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 978c79912cc9..e4677f1a8341 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2859,14 +2859,15 @@ static unsigned long mask_to_le(unsigned long mask, int size)
 
 	return mask;
 }
+
 static int offload_pedit_fields(struct mlx5e_priv *priv,
 				int namespace,
-				struct pedit_headers_action *hdrs,
 				struct mlx5e_tc_flow_parse_attr *parse_attr,
 				u32 *action_flags,
 				struct netlink_ext_ack *extack)
 {
 	struct pedit_headers *set_masks, *add_masks, *set_vals, *add_vals;
+	struct pedit_headers_action *hdrs = parse_attr->hdrs;
 	void *headers_c, *headers_v, *action, *vals_p;
 	u32 *s_masks_p, *a_masks_p, s_mask, a_mask;
 	struct mlx5e_tc_mod_hdr_acts *mod_acts;
@@ -2994,7 +2995,6 @@ static const struct pedit_headers zero_masks = {};
 
 static int alloc_tc_pedit_action(struct mlx5e_priv *priv, int namespace,
 				 struct mlx5e_tc_flow_parse_attr *parse_attr,
-				 struct pedit_headers_action *hdrs,
 				 u32 *action_flags,
 				 struct netlink_ext_ack *extack)
 {
@@ -3002,16 +3002,14 @@ static int alloc_tc_pedit_action(struct mlx5e_priv *priv, int namespace,
 	int err;
 	u8 cmd;
 
-	err = offload_pedit_fields(priv, namespace, hdrs, parse_attr,
-				   action_flags, extack);
+	err = offload_pedit_fields(priv, namespace, parse_attr, action_flags, extack);
 	if (err < 0)
 		goto out_dealloc_parsed_actions;
 
 	for (cmd = 0; cmd < __PEDIT_CMD_MAX; cmd++) {
-		cmd_masks = &hdrs[cmd].masks;
+		cmd_masks = &parse_attr->hdrs[cmd].masks;
 		if (memcmp(cmd_masks, &zero_masks, sizeof(zero_masks))) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "attempt to offload an unsupported field");
+			NL_SET_ERR_MSG_MOD(extack, "attempt to offload an unsupported field");
 			netdev_warn(priv->netdev, "attempt to offload an unsupported field (cmd %d)\n", cmd);
 			print_hex_dump(KERN_WARNING, "mask: ", DUMP_PREFIX_ADDRESS,
 				       16, 1, cmd_masks, sizeof(zero_masks), true);
@@ -3319,10 +3317,10 @@ static int
 actions_prepare_mod_hdr_actions(struct mlx5e_priv *priv,
 				struct mlx5e_tc_flow *flow,
 				struct mlx5_flow_attr *attr,
-				struct pedit_headers_action *hdrs,
 				struct netlink_ext_ack *extack)
 {
 	struct mlx5e_tc_flow_parse_attr *parse_attr = attr->parse_attr;
+	struct pedit_headers_action *hdrs = parse_attr->hdrs;
 	enum mlx5_flow_namespace_type ns_type;
 	int err;
 
@@ -3332,8 +3330,7 @@ actions_prepare_mod_hdr_actions(struct mlx5e_priv *priv,
 
 	ns_type = mlx5e_get_flow_namespace(flow);
 
-	err = alloc_tc_pedit_action(priv, ns_type, parse_attr, hdrs,
-				    &attr->action, extack);
+	err = alloc_tc_pedit_action(priv, ns_type, parse_attr, &attr->action, extack);
 	if (err)
 		return err;
 
@@ -3381,7 +3378,6 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 	struct mlx5e_tc_act_parse_state *parse_state;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
-	struct pedit_headers_action *hdrs;
 	int err;
 
 	err = flow_action_supported(flow_action, extack);
@@ -3393,13 +3389,12 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 	parse_state = &parse_attr->parse_state;
 	mlx5e_tc_act_init_parse_state(parse_state, flow, flow_action, extack);
 	parse_state->ct_priv = get_ct_priv(priv);
-	hdrs = parse_state->hdrs;
 
 	err = parse_tc_actions(parse_state, flow_action);
 	if (err)
 		return err;
 
-	err = actions_prepare_mod_hdr_actions(priv, flow, attr, hdrs, extack);
+	err = actions_prepare_mod_hdr_actions(priv, flow, attr, extack);
 	if (err)
 		return err;
 
@@ -3504,7 +3499,6 @@ parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
 	struct mlx5_esw_flow_attr *esw_attr;
-	struct pedit_headers_action *hdrs;
 	int err;
 
 	err = flow_action_supported(flow_action, extack);
@@ -3516,7 +3510,6 @@ parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	parse_state = &parse_attr->parse_state;
 	mlx5e_tc_act_init_parse_state(parse_state, flow, flow_action, extack);
 	parse_state->ct_priv = get_ct_priv(priv);
-	hdrs = parse_state->hdrs;
 
 	err = parse_tc_actions(parse_state, flow_action);
 	if (err)
@@ -3530,7 +3523,7 @@ parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
-	err = actions_prepare_mod_hdr_actions(priv, flow, attr, hdrs, extack);
+	err = actions_prepare_mod_hdr_actions(priv, flow, attr, extack);
 	if (err)
 		return err;
 
-- 
2.34.1

