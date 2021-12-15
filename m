Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F4C47522A
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 06:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239942AbhLOFdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 00:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239913AbhLOFdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 00:33:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8910BC061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 21:33:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5433AB81EA2
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 05:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6641C34604;
        Wed, 15 Dec 2021 05:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639546388;
        bh=E4MbMgMzbVkX6Bf1pcC4GrsZ2WkDj5nwz/c4f/pbyA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bNM1GctOmiC8eu2UPtNLL15XeQQpBztrwLbFc4LUpBfFXN8YOXoqzhdA8ChHMTG47
         zmLmEEawH+eVmP8dlRzOFr5OMjQTmP9VfcjISPWI6fz9Sw0iGD1OmHNGa7lWHPE767
         rGVw5PJCXVkjuMgbqeZZgZEbq7KNLXOGwT5CHTrBtzoaP+B8YJ6q/5S/hCdxDHk9MR
         YSCjVsjIephS7CyKR49HI/0gK6lrgJErJDeZZPa+j+azakubPUYMHMdfpNXXmw9eoY
         AMcGVVnRo2IT5xvEwfyLc5I4TZfTdFvUOczOQnMELYeilbfgx8JJVUw+NaOjEgOgG8
         iQG4HVFlPwXNg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 12/16] net/mlx5e: TC action parsing loop
Date:   Tue, 14 Dec 2021 21:32:56 -0800
Message-Id: <20211215053300.130679-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211215053300.130679-1-saeed@kernel.org>
References: <20211215053300.130679-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Introduce a common function to implement the generic parsing loop.
The same function can be used for parsing NIC and FDB (Switchdev mode) flows.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 88 ++++++++++---------
 1 file changed, 46 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 7fc89d41d971..a3f414171ca5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3138,6 +3138,39 @@ add_vlan_prio_tag_rewrite_action(struct mlx5e_priv *priv,
 						    extack);
 }
 
+static int
+parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
+		 struct flow_action *flow_action)
+{
+	struct netlink_ext_ack *extack = parse_state->extack;
+	struct mlx5e_tc_flow *flow = parse_state->flow;
+	struct mlx5_flow_attr *attr = flow->attr;
+	enum mlx5_flow_namespace_type ns_type;
+	struct mlx5e_priv *priv = flow->priv;
+	const struct flow_action_entry *act;
+	struct mlx5e_tc_act *tc_act;
+	int err, i;
+
+	ns_type = mlx5e_get_flow_namespace(flow);
+
+	flow_action_for_each(i, act, flow_action) {
+		tc_act = mlx5e_tc_act_get(act->id, ns_type);
+		if (!tc_act) {
+			NL_SET_ERR_MSG_MOD(extack, "Not implemented offload action");
+			return -EOPNOTSUPP;
+		}
+
+		if (!tc_act->can_offload(parse_state, act, i))
+			return -EOPNOTSUPP;
+
+		err = tc_act->parse_action(parse_state, act, priv, attr);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 static int
 actions_prepare_mod_hdr_actions(struct mlx5e_priv *priv,
 				struct mlx5e_tc_flow *flow,
@@ -3204,11 +3237,8 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 	struct mlx5e_tc_act_parse_state *parse_state;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
-	enum mlx5_flow_namespace_type ns_type;
-	const struct flow_action_entry *act;
 	struct pedit_headers_action *hdrs;
-	struct mlx5e_tc_act *tc_act;
-	int err, i;
+	int err;
 
 	err = flow_action_supported(flow_action, extack);
 	if (err)
@@ -3219,23 +3249,11 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 	parse_state = &parse_attr->parse_state;
 	mlx5e_tc_act_init_parse_state(parse_state, flow, flow_action, extack);
 	parse_state->ct_priv = get_ct_priv(priv);
-	ns_type = mlx5e_get_flow_namespace(flow);
 	hdrs = parse_state->hdrs;
 
-	flow_action_for_each(i, act, flow_action) {
-		tc_act = mlx5e_tc_act_get(act->id, ns_type);
-		if (!tc_act) {
-			NL_SET_ERR_MSG_MOD(extack, "Not implemented offload action");
-			return -EOPNOTSUPP;
-		}
-
-		if (!tc_act->can_offload(parse_state, act, i))
-			return -EOPNOTSUPP;
-
-		err = tc_act->parse_action(parse_state, act, priv, attr);
-		if (err)
-			return err;
-	}
+	err = parse_tc_actions(parse_state, flow_action);
+	if (err)
+		return err;
 
 	if (attr->dest_chain && parse_attr->mirred_ifindex[0]) {
 		NL_SET_ERR_MSG(extack, "Mirroring goto chain rules isn't supported");
@@ -3337,21 +3355,19 @@ int mlx5e_set_fwd_to_int_port_actions(struct mlx5e_priv *priv,
 	return 0;
 }
 
-static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
-				struct flow_action *flow_action,
-				struct mlx5e_tc_flow *flow,
-				struct netlink_ext_ack *extack)
+static int
+parse_tc_fdb_actions(struct mlx5e_priv *priv,
+		     struct flow_action *flow_action,
+		     struct mlx5e_tc_flow *flow,
+		     struct netlink_ext_ack *extack)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5e_tc_act_parse_state *parse_state;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
-	enum mlx5_flow_namespace_type ns_type;
-	const struct flow_action_entry *act;
 	struct mlx5_esw_flow_attr *esw_attr;
 	struct pedit_headers_action *hdrs;
-	struct mlx5e_tc_act *tc_act;
-	int err, i;
+	int err;
 
 	err = flow_action_supported(flow_action, extack);
 	if (err)
@@ -3362,23 +3378,11 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	parse_state = &parse_attr->parse_state;
 	mlx5e_tc_act_init_parse_state(parse_state, flow, flow_action, extack);
 	parse_state->ct_priv = get_ct_priv(priv);
-	ns_type = mlx5e_get_flow_namespace(flow);
 	hdrs = parse_state->hdrs;
 
-	flow_action_for_each(i, act, flow_action) {
-		tc_act = mlx5e_tc_act_get(act->id, ns_type);
-		if (!tc_act) {
-			NL_SET_ERR_MSG_MOD(extack, "Not implemented offload action");
-			return -EOPNOTSUPP;
-		}
-
-		if (!tc_act->can_offload(parse_state, act, i))
-			return -EOPNOTSUPP;
-
-		err = tc_act->parse_action(parse_state, act, priv, attr);
-		if (err)
-			return err;
-	}
+	err = parse_tc_actions(parse_state, flow_action);
+	if (err)
+		return err;
 
 	/* Forward to/from internal port can only have 1 dest */
 	if ((netif_is_ovs_master(parse_attr->filter_dev) || esw_attr->dest_int_port) &&
-- 
2.31.1

