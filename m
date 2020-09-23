Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B35275170
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 08:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgIWGYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 02:24:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgIWGYn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 02:24:43 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F374221D43;
        Wed, 23 Sep 2020 06:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600842282;
        bh=D+xLY9K355Fvf3dundDziARL0NdhZ2l7QUYskevftcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDf8ikWBecTtqDr67yzu0z/rBdiUGY52pkSBEWKF0QQqXlRrCofUoGJrEIvrt2Nrk
         NkBJtuvVYjxIkMTEJDjcWez66VWITKVEJsoQLwsQ0Kz8V0QZOnlEQkKVfoZgWeWntE
         l2B+sSgP/7VWps22YMTYQb7rL55MqvDUxH5n0Tl8=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/15] net/mlx5e: Split nic tc flow allocation and creation
Date:   Tue, 22 Sep 2020 23:24:27 -0700
Message-Id: <20200923062438.15997-5-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923062438.15997-1-saeed@kernel.org>
References: <20200923062438.15997-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@mellanox.com>

For future support of CT offload with nic tc flows, where
the flow rule is not created immediately but rather following
a future event, the patch is splitting the nic rule creation
and deletion into 2 parts:
1. Creating/Deleting and setting the rule attributes.
2. Creating/Deleting the flow table and flow rule itself.

This way the attributes can be prepared and stored in the
flow handle when the tc flow is created but the rule can
actually be created at any point in the future, using these
pre allocated attributes.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 116 +++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |   7 ++
 2 files changed, 77 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 0cc81f8d2f5e..4b810ad9d6d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -891,39 +891,31 @@ static void mlx5e_hairpin_flow_del(struct mlx5e_priv *priv,
 	flow->hpe = NULL;
 }
 
-static int
-mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
-		      struct mlx5e_tc_flow_parse_attr *parse_attr,
-		      struct mlx5e_tc_flow *flow,
-		      struct netlink_ext_ack *extack)
+struct mlx5_flow_handle *
+mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
+			     struct mlx5_flow_spec *spec,
+			     struct mlx5_nic_flow_attr *attr)
 {
-	struct mlx5_flow_context *flow_context = &parse_attr->spec.flow_context;
-	struct mlx5_nic_flow_attr *attr = flow->nic_attr;
+	struct mlx5_flow_context *flow_context = &spec->flow_context;
 	struct mlx5e_tc_table *tc = &priv->fs.tc;
-	struct mlx5_core_dev *dev = priv->mdev;
 	struct mlx5_flow_destination dest[2] = {};
 	struct mlx5_flow_act flow_act = {
 		.action = attr->action,
 		.flags    = FLOW_ACT_NO_APPEND,
 	};
-	struct mlx5_fc *counter = NULL;
-	int err, dest_ix = 0;
+	struct mlx5_flow_handle *rule;
+	int dest_ix = 0;
 
 	flow_context->flags |= FLOW_CONTEXT_HAS_TAG;
 	flow_context->flow_tag = attr->flow_tag;
 
-	if (flow_flag_test(flow, HAIRPIN)) {
-		err = mlx5e_hairpin_flow_add(priv, flow, parse_attr, extack);
-		if (err)
-			return err;
-
-		if (flow_flag_test(flow, HAIRPIN_RSS)) {
-			dest[dest_ix].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-			dest[dest_ix].ft = attr->hairpin_ft;
-		} else {
-			dest[dest_ix].type = MLX5_FLOW_DESTINATION_TYPE_TIR;
-			dest[dest_ix].tir_num = attr->hairpin_tirn;
-		}
+	if (attr->hairpin_ft) {
+		dest[dest_ix].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+		dest[dest_ix].ft = attr->hairpin_ft;
+		dest_ix++;
+	} else if (attr->hairpin_tirn) {
+		dest[dest_ix].type = MLX5_FLOW_DESTINATION_TYPE_TIR;
+		dest[dest_ix].tir_num = attr->hairpin_tirn;
 		dest_ix++;
 	} else if (attr->action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
 		dest[dest_ix].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
@@ -931,24 +923,14 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 		dest_ix++;
 	}
 
-	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT) {
-		counter = mlx5_fc_create(dev, true);
-		if (IS_ERR(counter))
-			return PTR_ERR(counter);
-
+	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_COUNT) {
 		dest[dest_ix].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
-		dest[dest_ix].counter_id = mlx5_fc_id(counter);
+		dest[dest_ix].counter_id = mlx5_fc_id(attr->counter);
 		dest_ix++;
-		attr->counter = counter;
 	}
 
-	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
-		err = mlx5e_attach_mod_hdr(priv, flow, parse_attr);
+	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		flow_act.modify_hdr = attr->modify_hdr;
-		dealloc_mod_hdr_actions(&parse_attr->mod_hdr_acts);
-		if (err)
-			return err;
-	}
 
 	mutex_lock(&tc->t_lock);
 	if (IS_ERR_OR_NULL(tc->t)) {
@@ -958,35 +940,77 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 
 		if (IS_ERR(tc->t)) {
 			mutex_unlock(&tc->t_lock);
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Failed to create tc offload table");
 			netdev_err(priv->netdev,
 				   "Failed to create tc offload table\n");
-			return PTR_ERR(tc->t);
+			return ERR_CAST(tc->t);
 		}
 	}
+	mutex_unlock(&tc->t_lock);
 
 	if (attr->match_level != MLX5_MATCH_NONE)
-		parse_attr->spec.match_criteria_enable |= MLX5_MATCH_OUTER_HEADERS;
+		spec->match_criteria_enable |= MLX5_MATCH_OUTER_HEADERS;
 
-	flow->rule[0] = mlx5_add_flow_rules(priv->fs.tc.t, &parse_attr->spec,
-					    &flow_act, dest, dest_ix);
-	mutex_unlock(&priv->fs.tc.t_lock);
+	rule = mlx5_add_flow_rules(tc->t, spec,
+				   &flow_act, dest, dest_ix);
+	if (IS_ERR(rule))
+		return ERR_CAST(rule);
+
+	return rule;
+}
+
+static int
+mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
+		      struct mlx5e_tc_flow_parse_attr *parse_attr,
+		      struct mlx5e_tc_flow *flow,
+		      struct netlink_ext_ack *extack)
+{
+	struct mlx5_nic_flow_attr *attr = flow->nic_attr;
+	struct mlx5_core_dev *dev = priv->mdev;
+	struct mlx5_fc *counter = NULL;
+	int err;
+
+	if (flow_flag_test(flow, HAIRPIN)) {
+		err = mlx5e_hairpin_flow_add(priv, flow, parse_attr, extack);
+		if (err)
+			return err;
+	}
+
+	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT) {
+		counter = mlx5_fc_create(dev, true);
+		if (IS_ERR(counter))
+			return PTR_ERR(counter);
+
+		attr->counter = counter;
+	}
+
+	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
+		err = mlx5e_attach_mod_hdr(priv, flow, parse_attr);
+		dealloc_mod_hdr_actions(&parse_attr->mod_hdr_acts);
+		if (err)
+			return err;
+	}
+
+	flow->rule[0] = mlx5e_add_offloaded_nic_rule(priv, &parse_attr->spec,
+						     attr);
 
 	return PTR_ERR_OR_ZERO(flow->rule[0]);
 }
 
+void mlx5e_del_offloaded_nic_rule(struct mlx5e_priv *priv,
+				  struct mlx5_flow_handle *rule)
+{
+	mlx5_del_flow_rules(rule);
+}
+
 static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 				  struct mlx5e_tc_flow *flow)
 {
 	struct mlx5_nic_flow_attr *attr = flow->nic_attr;
 	struct mlx5e_tc_table *tc = &priv->fs.tc;
-	struct mlx5_fc *counter = NULL;
 
-	counter = attr->counter;
 	if (!IS_ERR_OR_NULL(flow->rule[0]))
-		mlx5_del_flow_rules(flow->rule[0]);
-	mlx5_fc_destroy(priv->mdev, counter);
+		mlx5e_del_offloaded_nic_rule(priv, flow->rule[0]);
+	mlx5_fc_destroy(priv->mdev, attr->counter);
 
 	mutex_lock(&priv->fs.tc.t_lock);
 	if (!mlx5e_tc_num_filters(priv, MLX5_TC_FLAG(NIC_OFFLOAD)) &&
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 437f680728fd..2d63a75a9326 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -181,6 +181,13 @@ void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv);
 int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 			    void *cb_priv);
 
+struct mlx5_nic_flow_attr;
+struct mlx5_flow_handle *
+mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
+			     struct mlx5_flow_spec *spec,
+			     struct mlx5_nic_flow_attr *attr);
+void mlx5e_del_offloaded_nic_rule(struct mlx5e_priv *priv,
+				  struct mlx5_flow_handle *rule);
 #else /* CONFIG_MLX5_CLS_ACT */
 static inline int  mlx5e_tc_nic_init(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv) {}
-- 
2.26.2

