Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61207275172
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 08:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgIWGZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 02:25:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726774AbgIWGYo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 02:24:44 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12E152376E;
        Wed, 23 Sep 2020 06:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600842283;
        bh=tCsZSrPLLTM7XQjwFdn1In5wbM2BYoUpETxVmvA1LUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iaCAaiTuao1tbZxxZyAZf+VaBHaH9LUFlKVpRACKNcnPRD+gQzFa/rIXWj7DESDS2
         XRCAuHcukffaTwcb8xHsicxP5we6FzMs4WbAi7Rpfa4fDTPeDiO4JvAcp0W5g9EbFA
         i+x2fQjUgi9Ax4CvxUfFIOaEkTuxG45I/idc3R8Y=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/15] net/mlx5e: Add tc chains offload support for nic flows
Date:   Tue, 22 Sep 2020 23:24:29 -0700
Message-Id: <20200923062438.15997-7-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923062438.15997-1-saeed@kernel.org>
References: <20200923062438.15997-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@mellanox.com>

Allow adding nic tc flow rules with goto chain action.

Connecting the nic flows to the mlx5 chains infrastructure in previous
patches allows us to support the creation of chained flow tables and
rules that direct to another chain for further packet processing.
This is a required preparation to support CT offloads for nic tc flows.

We allow the creation of 256 different chains for nic flows since we
have 8 bits available for the chain restore tag in case of a miss.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  10 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 252 ++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  34 ++-
 .../mellanox/mlx5/core/lib/fs_chains.c        |  11 +-
 4 files changed, 250 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 310533fc9950..599f5b5ebc97 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1260,6 +1260,11 @@ static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	}
 
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
+
+	if (mlx5e_cqe_regb_chain(cqe))
+		if (!mlx5e_tc_update_skb(cqe, skb))
+			goto free_wqe;
+
 	napi_gro_receive(rq->cq.napi, skb);
 
 free_wqe:
@@ -1521,6 +1526,11 @@ static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cq
 		goto mpwrq_cqe_out;
 
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
+
+	if (mlx5e_cqe_regb_chain(cqe))
+		if (!mlx5e_tc_update_skb(cqe, skb))
+			goto mpwrq_cqe_out;
+
 	napi_gro_receive(rq->cq.napi, skb);
 
 mpwrq_cqe_out:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a54821107566..da05c4c195ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -177,6 +177,15 @@ struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
 	[MARK_TO_REG] = mark_to_reg_ct,
 	[LABELS_TO_REG] = labels_to_reg_ct,
 	[FTEID_TO_REG] = fteid_to_reg_ct,
+	/* For NIC rules we store the retore metadata directly
+	 * into reg_b that is passed to SW since we don't
+	 * jump between steering domains.
+	 */
+	[NIC_CHAIN_TO_REG] = {
+		.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_B,
+		.moffset = 0,
+		.mlen = 2,
+	},
 };
 
 static void mlx5e_put_flow_tunnel_id(struct mlx5e_tc_flow *flow);
@@ -879,6 +888,7 @@ mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
 			     struct mlx5_flow_attr *attr)
 {
 	struct mlx5_flow_context *flow_context = &spec->flow_context;
+	struct mlx5_fs_chains *nic_chains = nic_chains(priv);
 	struct mlx5_nic_flow_attr *nic_attr = attr->nic_attr;
 	struct mlx5e_tc_table *tc = &priv->fs.tc;
 	struct mlx5_flow_destination dest[2] = {};
@@ -887,6 +897,7 @@ mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
 		.flags    = FLOW_ACT_NO_APPEND,
 	};
 	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_table *ft;
 	int dest_ix = 0;
 
 	flow_context->flags |= FLOW_CONTEXT_HAS_TAG;
@@ -902,10 +913,22 @@ mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
 		dest_ix++;
 	} else if (attr->action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
 		dest[dest_ix].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-		dest[dest_ix].ft = priv->fs.vlan.ft.t;
+		if (attr->dest_chain) {
+			dest[dest_ix].ft = mlx5_chains_get_table(nic_chains,
+								 attr->dest_chain, 1,
+								 MLX5E_TC_FT_LEVEL);
+			if (IS_ERR(dest[dest_ix].ft))
+				return ERR_CAST(dest[dest_ix].ft);
+		} else {
+			dest[dest_ix].ft = priv->fs.vlan.ft.t;
+		}
 		dest_ix++;
 	}
 
+	if (dest[0].type == MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE &&
+	    MLX5_CAP_FLOWTABLE_NIC_RX(priv->mdev, ignore_flow_level))
+		flow_act.flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
+
 	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_COUNT) {
 		dest[dest_ix].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
 		dest[dest_ix].counter_id = mlx5_fc_id(attr->counter);
@@ -919,26 +942,47 @@ mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
 	if (IS_ERR_OR_NULL(tc->t)) {
 		/* Create the root table here if doesn't exist yet */
 		tc->t =
-			mlx5_chains_get_table(nic_chains(priv), 0, 1, MLX5E_TC_FT_LEVEL);
+			mlx5_chains_get_table(nic_chains, 0, 1, MLX5E_TC_FT_LEVEL);
 
 		if (IS_ERR(tc->t)) {
 			mutex_unlock(&tc->t_lock);
 			netdev_err(priv->netdev,
 				   "Failed to create tc offload table\n");
-			return ERR_CAST(tc->t);
+			rule = ERR_CAST(priv->fs.tc.t);
+			goto err_ft_get;
 		}
 	}
 	mutex_unlock(&tc->t_lock);
 
+	ft = mlx5_chains_get_table(nic_chains,
+				   attr->chain, attr->prio,
+				   MLX5E_TC_FT_LEVEL);
+	if (IS_ERR(ft)) {
+		rule = ERR_CAST(ft);
+		goto err_ft_get;
+	}
+
 	if (attr->outer_match_level != MLX5_MATCH_NONE)
 		spec->match_criteria_enable |= MLX5_MATCH_OUTER_HEADERS;
 
-	rule = mlx5_add_flow_rules(tc->t, spec,
+	rule = mlx5_add_flow_rules(ft, spec,
 				   &flow_act, dest, dest_ix);
 	if (IS_ERR(rule))
-		return ERR_CAST(rule);
+		goto err_rule;
 
 	return rule;
+
+err_rule:
+	mlx5_chains_put_table(nic_chains,
+			      attr->chain, attr->prio,
+			      MLX5E_TC_FT_LEVEL);
+err_ft_get:
+	if (attr->dest_chain)
+		mlx5_chains_put_table(nic_chains,
+				      attr->dest_chain, 1,
+				      MLX5E_TC_FT_LEVEL);
+
+	return ERR_CAST(rule);
 }
 
 static int
@@ -980,9 +1024,19 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 }
 
 void mlx5e_del_offloaded_nic_rule(struct mlx5e_priv *priv,
-				  struct mlx5_flow_handle *rule)
+				  struct mlx5_flow_handle *rule,
+				  struct mlx5_flow_attr *attr)
 {
+	struct mlx5_fs_chains *nic_chains = nic_chains(priv);
+
 	mlx5_del_flow_rules(rule);
+
+	mlx5_chains_put_table(nic_chains, attr->chain, attr->prio,
+			      MLX5E_TC_FT_LEVEL);
+
+	if (attr->dest_chain)
+		mlx5_chains_put_table(nic_chains, attr->dest_chain, 1,
+				      MLX5E_TC_FT_LEVEL);
 }
 
 static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
@@ -992,9 +1046,14 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 	struct mlx5e_tc_table *tc = &priv->fs.tc;
 
 	if (!IS_ERR_OR_NULL(flow->rule[0]))
-		mlx5e_del_offloaded_nic_rule(priv, flow->rule[0]);
+		mlx5e_del_offloaded_nic_rule(priv, flow->rule[0], attr);
 	mlx5_fc_destroy(priv->mdev, attr->counter);
 
+	flow_flag_clear(flow, OFFLOADED);
+
+	/* Remove root table if no rules are left to avoid
+	 * extra steering hops.
+	 */
 	mutex_lock(&priv->fs.tc.t_lock);
 	if (!mlx5e_tc_num_filters(priv, MLX5_TC_FLAG(NIC_OFFLOAD)) &&
 	    !IS_ERR_OR_NULL(tc->t)) {
@@ -3247,6 +3306,57 @@ add_vlan_prio_tag_rewrite_action(struct mlx5e_priv *priv,
 				       extack);
 }
 
+static int validate_goto_chain(struct mlx5e_priv *priv,
+			       struct mlx5e_tc_flow *flow,
+			       const struct flow_action_entry *act,
+			       u32 actions,
+			       struct netlink_ext_ack *extack)
+{
+	bool is_esw = mlx5e_is_eswitch_flow(flow);
+	struct mlx5_flow_attr *attr = flow->attr;
+	bool ft_flow = mlx5e_is_ft_flow(flow);
+	u32 dest_chain = act->chain_index;
+	struct mlx5_fs_chains *chains;
+	struct mlx5_eswitch *esw;
+	u32 reformat_and_fwd;
+	u32 max_chain;
+
+	esw = priv->mdev->priv.eswitch;
+	chains = is_esw ? esw_chains(esw) : nic_chains(priv);
+	max_chain = mlx5_chains_get_chain_range(chains);
+	reformat_and_fwd = is_esw ?
+			   MLX5_CAP_ESW_FLOWTABLE_FDB(priv->mdev, reformat_and_fwd_to_table) :
+			   MLX5_CAP_FLOWTABLE_NIC_RX(priv->mdev, reformat_and_fwd_to_table);
+
+	if (ft_flow) {
+		NL_SET_ERR_MSG_MOD(extack, "Goto action is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (!mlx5_chains_backwards_supported(chains) &&
+	    dest_chain <= attr->chain) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Goto lower numbered chain isn't supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (dest_chain > max_chain) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Requested destination chain is out of supported range");
+		return -EOPNOTSUPP;
+	}
+
+	if (actions & (MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT |
+		       MLX5_FLOW_CONTEXT_ACTION_DECAP) &&
+	    !reformat_and_fwd) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Goto chain is not allowed if action has reformat or decap");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 				struct flow_action *flow_action,
 				struct mlx5e_tc_flow_parse_attr *parse_attr,
@@ -3290,8 +3400,7 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 			if (err)
 				return err;
 
-			action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR |
-				  MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+			action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 			break;
 		case FLOW_ACTION_VLAN_MANGLE:
 			err = add_vlan_rewrite_action(priv,
@@ -3340,6 +3449,15 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 			action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 			}
 			break;
+		case FLOW_ACTION_GOTO:
+			err = validate_goto_chain(priv, flow, act, action,
+						  extack);
+			if (err)
+				return err;
+
+			action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
+			attr->dest_chain = act->chain_index;
+			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "The offload action is not supported");
 			return -EOPNOTSUPP;
@@ -3362,6 +3480,18 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 	}
 
 	attr->action = action;
+
+	if (attr->dest_chain) {
+		if (attr->action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
+			NL_SET_ERR_MSG(extack, "Mirroring goto chain rules isn't supported");
+			return -EOPNOTSUPP;
+		}
+		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	}
+
+	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
+		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+
 	if (!actions_match_supported(priv, flow_action, parse_attr, flow, extack))
 		return -EOPNOTSUPP;
 
@@ -3855,45 +3985,6 @@ static bool is_duplicated_output_device(struct net_device *dev,
 	return false;
 }
 
-static int mlx5_validate_goto_chain(struct mlx5_eswitch *esw,
-				    struct mlx5e_tc_flow *flow,
-				    const struct flow_action_entry *act,
-				    u32 actions,
-				    struct netlink_ext_ack *extack)
-{
-	u32 max_chain = mlx5_chains_get_chain_range(esw_chains(esw));
-	struct mlx5_flow_attr *attr = flow->attr;
-	bool ft_flow = mlx5e_is_ft_flow(flow);
-	u32 dest_chain = act->chain_index;
-
-	if (ft_flow) {
-		NL_SET_ERR_MSG_MOD(extack, "Goto action is not supported");
-		return -EOPNOTSUPP;
-	}
-
-	if (!mlx5_chains_backwards_supported(esw_chains(esw)) &&
-	    dest_chain <= attr->chain) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Goto lower numbered chain isn't supported");
-		return -EOPNOTSUPP;
-	}
-	if (dest_chain > max_chain) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Requested destination chain is out of supported range");
-		return -EOPNOTSUPP;
-	}
-
-	if (actions & (MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT |
-		       MLX5_FLOW_CONTEXT_ACTION_DECAP) &&
-	    !MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, reformat_and_fwd_to_table)) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Goto chain is not allowed if action has reformat or decap");
-		return -EOPNOTSUPP;
-	}
-
-	return 0;
-}
-
 static int verify_uplink_forwarding(struct mlx5e_priv *priv,
 				    struct mlx5e_tc_flow *flow,
 				    struct net_device *out_dev,
@@ -4188,8 +4279,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			decap = true;
 			break;
 		case FLOW_ACTION_GOTO:
-			err = mlx5_validate_goto_chain(esw, flow, act, action,
-						       extack);
+			err = validate_goto_chain(priv, flow, act, action,
+						  extack);
 			if (err)
 				return err;
 
@@ -4402,6 +4493,16 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 	return err;
 }
 
+static void
+mlx5e_flow_attr_init(struct mlx5_flow_attr *attr,
+		     struct mlx5e_tc_flow_parse_attr *parse_attr,
+		     struct flow_cls_offload *f)
+{
+	attr->parse_attr = parse_attr;
+	attr->chain = f->common.chain_index;
+	attr->prio = f->common.prio;
+}
+
 static void
 mlx5e_flow_esw_attr_init(struct mlx5_flow_attr *attr,
 			 struct mlx5e_priv *priv,
@@ -4413,9 +4514,7 @@ mlx5e_flow_esw_attr_init(struct mlx5_flow_attr *attr,
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
 
-	attr->parse_attr = parse_attr;
-	attr->chain = f->common.chain_index;
-	attr->prio = f->common.prio;
+	mlx5e_flow_attr_init(attr, parse_attr, f);
 
 	esw_attr->in_rep = in_rep;
 	esw_attr->in_mdev = in_mdev;
@@ -4583,9 +4682,12 @@ mlx5e_add_nic_flow(struct mlx5e_priv *priv,
 	struct mlx5e_tc_flow *flow;
 	int attr_size, err;
 
-	/* multi-chain not supported for NIC rules */
-	if (!tc_cls_can_offload_and_chain0(priv->netdev, &f->common))
+	if (!MLX5_CAP_FLOWTABLE_NIC_RX(priv->mdev, ignore_flow_level)) {
+		if (!tc_cls_can_offload_and_chain0(priv->netdev, &f->common))
+			return -EOPNOTSUPP;
+	} else if (!tc_can_offload_extack(priv->netdev, f->common.extack)) {
 		return -EOPNOTSUPP;
+	}
 
 	flow_flags |= BIT(MLX5E_TC_FLOW_FLAG_NIC);
 	attr_size  = sizeof(struct mlx5_nic_flow_attr);
@@ -4595,6 +4697,8 @@ mlx5e_add_nic_flow(struct mlx5e_priv *priv,
 		goto out;
 
 	parse_attr->filter_dev = filter_dev;
+	mlx5e_flow_attr_init(flow->attr, parse_attr, f);
+
 	err = parse_cls_flower(flow->priv, flow, &parse_attr->spec,
 			       f, filter_dev);
 	if (err)
@@ -5023,6 +5127,11 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	if (err)
 		return err;
 
+	if (MLX5_CAP_FLOWTABLE_NIC_RX(priv->mdev, ignore_flow_level)) {
+		attr.flags = MLX5_CHAINS_AND_PRIOS_SUPPORTED |
+			MLX5_CHAINS_IGNORE_FLOW_LEVEL_SUPPORTED;
+		attr.max_restore_tag = MLX5E_TC_TABLE_CHAIN_TAG_MASK;
+	}
 	attr.ns = MLX5_FLOW_NAMESPACE_KERNEL;
 	attr.max_ft_sz = mlx5e_tc_nic_get_ft_size(dev);
 	attr.max_grp_num = MLX5E_TC_TABLE_NUM_GROUPS;
@@ -5208,3 +5317,36 @@ int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 		return -EOPNOTSUPP;
 	}
 }
+
+bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
+			 struct sk_buff *skb)
+{
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	struct mlx5e_priv *priv = netdev_priv(skb->dev);
+	u32 chain = 0, chain_tag, reg_b;
+	struct tc_skb_ext *tc_skb_ext;
+	int err;
+
+	reg_b = be32_to_cpu(cqe->ft_metadata);
+
+	chain_tag = reg_b & MLX5E_TC_TABLE_CHAIN_TAG_MASK;
+
+	err = mlx5_get_chain_for_tag(nic_chains(priv), chain_tag, &chain);
+	if (err) {
+		netdev_dbg(priv->netdev,
+			   "Couldn't find chain for chain tag: %d, err: %d\n",
+			   chain_tag, err);
+		return false;
+	}
+
+	if (chain) {
+		tc_skb_ext = skb_ext_add(skb, TC_SKB_EXT);
+		if (WARN_ON(!tc_skb_ext))
+			return false;
+
+		tc_skb_ext->chain = chain;
+	}
+#endif /* CONFIG_NET_TC_SKB_EXT */
+
+	return true;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 9e84f03eebce..fa78289489b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -77,6 +77,9 @@ struct mlx5_flow_attr {
 	};
 };
 
+#define MLX5E_TC_TABLE_CHAIN_TAG_BITS 16
+#define MLX5E_TC_TABLE_CHAIN_TAG_MASK GENMASK(MLX5E_TC_TABLE_CHAIN_TAG_BITS - 1, 0)
+
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
 
 struct tunnel_match_key {
@@ -164,6 +167,7 @@ enum mlx5e_tc_attr_to_reg {
 	MARK_TO_REG,
 	LABELS_TO_REG,
 	FTEID_TO_REG,
+	NIC_CHAIN_TO_REG,
 };
 
 struct mlx5e_tc_attr_to_reg_mapping {
@@ -217,13 +221,16 @@ mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
 			     struct mlx5_flow_spec *spec,
 			     struct mlx5_flow_attr *attr);
 void mlx5e_del_offloaded_nic_rule(struct mlx5e_priv *priv,
-				  struct mlx5_flow_handle *rule);
+				  struct mlx5_flow_handle *rule,
+				  struct mlx5_flow_attr *attr);
+
 #else /* CONFIG_MLX5_CLS_ACT */
 static inline int  mlx5e_tc_nic_init(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv) {}
 static inline int
 mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
 { return -EOPNOTSUPP; }
+
 #endif /* CONFIG_MLX5_CLS_ACT */
 
 struct mlx5_flow_attr *mlx5_alloc_flow_attr(enum mlx5_flow_namespace_type type);
@@ -242,4 +249,29 @@ mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
 { return -EOPNOTSUPP; }
 #endif
 
+#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
+static inline bool mlx5e_cqe_regb_chain(struct mlx5_cqe64 *cqe)
+{
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	u32 chain, reg_b;
+
+	reg_b = be32_to_cpu(cqe->ft_metadata);
+
+	chain = reg_b & MLX5E_TC_TABLE_CHAIN_TAG_MASK;
+	if (chain)
+		return true;
+#endif
+
+	return false;
+}
+
+bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe, struct sk_buff *skb);
+#else /* CONFIG_MLX5_CLS_ACT */
+static inline bool mlx5e_cqe_regb_chain(struct mlx5_cqe64 *cqe)
+{ return false; }
+static inline bool
+mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe, struct sk_buff *skb)
+{ return true; }
+#endif
+
 #endif /* __MLX5_EN_TC_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index 5bd65cdc9b07..947f346bdc2d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -330,6 +330,12 @@ create_chain_restore(struct fs_chain *chain)
 			err = PTR_ERR(chain->restore_rule);
 			goto err_rule;
 		}
+	} else if (chains->ns == MLX5_FLOW_NAMESPACE_KERNEL) {
+		/* For NIC RX we don't need a restore rule
+		 * since we write the metadata to reg_b
+		 * that is passed to SW directly.
+		 */
+		chain_to_reg = NIC_CHAIN_TO_REG;
 	} else {
 		err = -EINVAL;
 		goto err_rule;
@@ -447,7 +453,10 @@ mlx5_chains_add_miss_rule(struct fs_chain *chain,
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_act act = {};
 
-	act.flags  = FLOW_ACT_IGNORE_FLOW_LEVEL | FLOW_ACT_NO_APPEND;
+	act.flags  = FLOW_ACT_NO_APPEND;
+	if (mlx5_chains_ignore_flow_level_supported(chain->chains))
+		act.flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
+
 	act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	dest.type  = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest.ft = next_ft;
-- 
2.26.2

