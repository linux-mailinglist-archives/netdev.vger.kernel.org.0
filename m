Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B66B6D8D2E
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbjDFCDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 22:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234836AbjDFCDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:03:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E633D7AAC
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 19:02:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B949A62A45
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:02:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13599C433D2;
        Thu,  6 Apr 2023 02:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680746568;
        bh=b3KJK8GEKgCpSgEHhvWHtmJnMiMyWO54Q3HOhh/miUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DPgW7WXZPLaBAkagwDJVMcTK0YS2Nh7EBvU1cNuT04/2PjMCorvrd7bmcB8w/3AFQ
         acELBfuCm1fMlTByTnak4G9prvAOCTrDH8tQByvMaw5XhDMzb8n/l50XkIRtQUjlG+
         tfTsYcC5Ax/nrQIj+NXJ4uLu7vRExLtW0yaCokGQFVRAp1VQ/6p/LsIC0P6JAyNHrp
         KCGPxcZBZfMcruTGTTCDmYLgA6Uy/L3d8q/RBNZe4gOgqwuI2ZTvln8flgy5s3mdhw
         pgKlt5gdl69VD/ZZolKkZMwenE3iICYXYWy6jiNZ/eRNLl6UR9fbZXwKOuUErUFO3h
         2U0mlRNntAG7g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 06/15] net/mlx5e: TC, Remove special handling of CT action
Date:   Wed,  5 Apr 2023 19:02:23 -0700
Message-Id: <20230406020232.83844-7-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406020232.83844-1-saeed@kernel.org>
References: <20230406020232.83844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

CT action has special treating as a per-flow action since
it was assumed to be singular and reordered to be first on
the action list.

This isn't the case anymore, and can be converted to just a
FWD to pre_ct + MODIFY_HEAD, and handled per post_act rule.

Remove special handling of CT action, and offload it while
post parsing each ct attribute.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/act/act.h        |   1 -
 .../mellanox/mlx5/core/en/tc/act/ct.c         |  39 +---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 169 +++++-------------
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    |  31 +---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  31 +---
 5 files changed, 58 insertions(+), 213 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index d7615e329e6d..033afd44fc4f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -18,7 +18,6 @@ struct mlx5e_tc_act_parse_state {
 	struct netlink_ext_ack *extack;
 	u32 actions;
 	bool ct;
-	bool ct_clear;
 	bool encap;
 	bool decap;
 	bool mpls_push;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
index fce1c0fd2453..36bfed07d400 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
@@ -28,30 +28,16 @@ tc_act_parse_ct(struct mlx5e_tc_act_parse_state *parse_state,
 		struct mlx5e_priv *priv,
 		struct mlx5_flow_attr *attr)
 {
-	bool clear_action = act->ct.action & TCA_CT_ACT_CLEAR;
 	int err;
 
-	/* It's redundant to do ct clear more than once. */
-	if (clear_action && parse_state->ct_clear)
-		return 0;
-
-	err = mlx5_tc_ct_parse_action(parse_state->ct_priv, attr,
-				      &attr->parse_attr->mod_hdr_acts,
-				      act, parse_state->extack);
+	err = mlx5_tc_ct_parse_action(parse_state->ct_priv, attr, act, parse_state->extack);
 	if (err)
 		return err;
 
-
 	if (mlx5e_is_eswitch_flow(parse_state->flow))
 		attr->esw_attr->split_count = attr->esw_attr->out_count;
 
-	if (clear_action) {
-		parse_state->ct_clear = true;
-	} else {
-		attr->flags |= MLX5_ATTR_FLAG_CT;
-		flow_flag_set(parse_state->flow, CT);
-		parse_state->ct = true;
-	}
+	attr->flags |= MLX5_ATTR_FLAG_CT;
 
 	return 0;
 }
@@ -61,27 +47,10 @@ tc_act_post_parse_ct(struct mlx5e_tc_act_parse_state *parse_state,
 		     struct mlx5e_priv *priv,
 		     struct mlx5_flow_attr *attr)
 {
-	struct mlx5e_tc_mod_hdr_acts *mod_acts = &attr->parse_attr->mod_hdr_acts;
-	int err;
-
-	/* If ct action exist, we can ignore previous ct_clear actions */
-	if (parse_state->ct)
+	if (!(attr->flags & MLX5_ATTR_FLAG_CT))
 		return 0;
 
-	if (parse_state->ct_clear) {
-		err = mlx5_tc_ct_set_ct_clear_regs(parse_state->ct_priv, mod_acts);
-		if (err) {
-			NL_SET_ERR_MSG_MOD(parse_state->extack,
-					   "Failed to set registers for ct clear");
-			return err;
-		}
-		attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-
-		/* Prevent handling of additional, redundant clear actions */
-		parse_state->ct_clear = false;
-	}
-
-	return 0;
+	return mlx5_tc_ct_flow_offload(parse_state->ct_priv, attr);
 }
 
 static bool
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 314983bc6f08..24badbaad935 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -83,12 +83,6 @@ struct mlx5_tc_ct_priv {
 	struct mlx5_tc_ct_debugfs debugfs;
 };
 
-struct mlx5_ct_flow {
-	struct mlx5_flow_attr *pre_ct_attr;
-	struct mlx5_flow_handle *pre_ct_rule;
-	struct mlx5_ct_ft *ft;
-};
-
 struct mlx5_ct_zone_rule {
 	struct mlx5_ct_fs_rule *rule;
 	struct mlx5e_mod_hdr_handle *mh;
@@ -598,12 +592,6 @@ mlx5_tc_ct_entry_set_registers(struct mlx5_tc_ct_priv *ct_priv,
 	return 0;
 }
 
-int mlx5_tc_ct_set_ct_clear_regs(struct mlx5_tc_ct_priv *priv,
-				 struct mlx5e_tc_mod_hdr_acts *mod_acts)
-{
-		return mlx5_tc_ct_entry_set_registers(priv, mod_acts, 0, 0, 0, 0);
-}
-
 static int
 mlx5_tc_ct_parse_mangle_to_mod_act(struct flow_action_entry *act,
 				   char *modact)
@@ -1545,7 +1533,6 @@ mlx5_tc_ct_match_add(struct mlx5_tc_ct_priv *priv,
 int
 mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 			struct mlx5_flow_attr *attr,
-			struct mlx5e_tc_mod_hdr_acts *mod_acts,
 			const struct flow_action_entry *act,
 			struct netlink_ext_ack *extack)
 {
@@ -1555,8 +1542,8 @@ mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
+	attr->ct_attr.ct_action |= act->ct.action; /* So we can have clear + ct */
 	attr->ct_attr.zone = act->ct.zone;
-	attr->ct_attr.ct_action = act->ct.action;
 	attr->ct_attr.nf_ft = act->ct.flow_table;
 	attr->ct_attr.act_miss_cookie = act->miss_cookie;
 
@@ -1892,14 +1879,14 @@ mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
 
 /* We translate the tc filter with CT action to the following HW model:
  *
- *	+---------------------+
- *	+ ft prio (tc chain)  +
- *	+ original match      +
- *	+---------------------+
+ *	+-----------------------+
+ *	+ rule (either original +
+ *	+ or post_act rule)     +
+ *	+-----------------------+
  *		 | set act_miss_cookie mapping
  *		 | set fte_id
  *		 | set tunnel_id
- *		 | do decap
+ *		 | rest of actions before the CT action (for this orig/post_act rule)
  *		 |
  * +-------------+
  * | Chain 0	 |
@@ -1924,32 +1911,21 @@ mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
  *		 | do nat (if needed)
  *		 v
  *	+--------------+
- *	+ post_act     + original filter actions
+ *	+ post_act     + rest of parsed filter's actions
  *	+ fte_id match +------------------------>
  *	+--------------+
  *
  */
-static struct mlx5_flow_handle *
+static int
 __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
-			  struct mlx5_flow_spec *orig_spec,
 			  struct mlx5_flow_attr *attr)
 {
 	bool nat = attr->ct_attr.ct_action & TCA_CT_ACT_NAT;
 	struct mlx5e_priv *priv = netdev_priv(ct_priv->netdev);
-	struct mlx5e_tc_mod_hdr_acts *pre_mod_acts;
-	u32 attr_sz = ns_to_attr_sz(ct_priv->ns_type);
-	struct mlx5_flow_attr *pre_ct_attr;
-	struct mlx5_modify_hdr *mod_hdr;
-	struct mlx5_ct_flow *ct_flow;
 	int act_miss_mapping = 0, err;
 	struct mlx5_ct_ft *ft;
 	u16 zone;
 
-	ct_flow = kzalloc(sizeof(*ct_flow), GFP_KERNEL);
-	if (!ct_flow) {
-		return ERR_PTR(-ENOMEM);
-	}
-
 	/* Register for CT established events */
 	ft = mlx5_tc_ct_add_ft_cb(ct_priv, attr->ct_attr.zone,
 				  attr->ct_attr.nf_ft);
@@ -1958,23 +1934,7 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 		ct_dbg("Failed to register to ft callback");
 		goto err_ft;
 	}
-	ct_flow->ft = ft;
-
-	/* Base flow attributes of both rules on original rule attribute */
-	ct_flow->pre_ct_attr = mlx5_alloc_flow_attr(ct_priv->ns_type);
-	if (!ct_flow->pre_ct_attr) {
-		err = -ENOMEM;
-		goto err_alloc_pre;
-	}
-
-	pre_ct_attr = ct_flow->pre_ct_attr;
-	memcpy(pre_ct_attr, attr, attr_sz);
-	pre_mod_acts = &pre_ct_attr->parse_attr->mod_hdr_acts;
-
-	/* Modify the original rule's action to fwd and modify, leave decap */
-	pre_ct_attr->action = attr->action & MLX5_FLOW_CONTEXT_ACTION_DECAP;
-	pre_ct_attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-			       MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+	attr->ct_attr.ft = ft;
 
 	err = mlx5e_tc_action_miss_mapping_get(ct_priv->priv, attr, attr->ct_attr.act_miss_cookie,
 					       &act_miss_mapping);
@@ -1982,136 +1942,89 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 		ct_dbg("Failed to get register mapping for act miss");
 		goto err_get_act_miss;
 	}
-	attr->ct_attr.act_miss_mapping = act_miss_mapping;
 
-	err = mlx5e_tc_match_to_reg_set(priv->mdev, pre_mod_acts, ct_priv->ns_type,
-					MAPPED_OBJ_TO_REG, act_miss_mapping);
+	err = mlx5e_tc_match_to_reg_set(priv->mdev, &attr->parse_attr->mod_hdr_acts,
+					ct_priv->ns_type, MAPPED_OBJ_TO_REG, act_miss_mapping);
 	if (err) {
 		ct_dbg("Failed to set act miss register mapping");
 		goto err_mapping;
 	}
 
-	/* If original flow is decap, we do it before going into ct table
-	 * so add a rewrite for the tunnel match_id.
-	 */
-	if ((pre_ct_attr->action & MLX5_FLOW_CONTEXT_ACTION_DECAP) &&
-	    attr->chain == 0) {
-		err = mlx5e_tc_match_to_reg_set(priv->mdev, pre_mod_acts,
-						ct_priv->ns_type,
-						TUNNEL_TO_REG,
-						attr->tunnel_id);
-		if (err) {
-			ct_dbg("Failed to set tunnel register mapping");
-			goto err_mapping;
-		}
-	}
-
-	/* Change original rule point to ct table
-	 * Chain 0 sets the zone and jumps to ct table
+	/* Chain 0 sets the zone and jumps to ct table
 	 * Other chains jump to pre_ct table to align with act_ct cached logic
 	 */
-	pre_ct_attr->dest_chain = 0;
 	if (!attr->chain) {
 		zone = ft->zone & MLX5_CT_ZONE_MASK;
-		err = mlx5e_tc_match_to_reg_set(priv->mdev, pre_mod_acts, ct_priv->ns_type,
-						ZONE_TO_REG, zone);
+		err = mlx5e_tc_match_to_reg_set(priv->mdev, &attr->parse_attr->mod_hdr_acts,
+						ct_priv->ns_type, ZONE_TO_REG, zone);
 		if (err) {
 			ct_dbg("Failed to set zone register mapping");
 			goto err_mapping;
 		}
 
-		pre_ct_attr->dest_ft = nat ? ct_priv->ct_nat : ct_priv->ct;
+		attr->dest_ft = nat ? ct_priv->ct_nat : ct_priv->ct;
 	} else {
-		pre_ct_attr->dest_ft = nat ? ft->pre_ct_nat.ft : ft->pre_ct.ft;
-	}
-
-	mod_hdr = mlx5_modify_header_alloc(priv->mdev, ct_priv->ns_type,
-					   pre_mod_acts->num_actions,
-					   pre_mod_acts->actions);
-	if (IS_ERR(mod_hdr)) {
-		err = PTR_ERR(mod_hdr);
-		ct_dbg("Failed to create pre ct mod hdr");
-		goto err_mapping;
-	}
-	pre_ct_attr->modify_hdr = mod_hdr;
-	ct_flow->pre_ct_rule = mlx5_tc_rule_insert(priv, orig_spec,
-						   pre_ct_attr);
-	if (IS_ERR(ct_flow->pre_ct_rule)) {
-		err = PTR_ERR(ct_flow->pre_ct_rule);
-		ct_dbg("Failed to add pre ct rule");
-		goto err_insert_orig;
+		attr->dest_ft = nat ? ft->pre_ct_nat.ft : ft->pre_ct.ft;
 	}
 
-	attr->ct_attr.ct_flow = ct_flow;
-	mlx5e_mod_hdr_dealloc(pre_mod_acts);
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+	attr->ct_attr.act_miss_mapping = act_miss_mapping;
 
-	return ct_flow->pre_ct_rule;
+	return 0;
 
-err_insert_orig:
-	mlx5_modify_header_dealloc(priv->mdev, pre_ct_attr->modify_hdr);
 err_mapping:
-	mlx5e_mod_hdr_dealloc(pre_mod_acts);
 	mlx5e_tc_action_miss_mapping_put(ct_priv->priv, attr, act_miss_mapping);
 err_get_act_miss:
-	kfree(ct_flow->pre_ct_attr);
-err_alloc_pre:
 	mlx5_tc_ct_del_ft_cb(ct_priv, ft);
 err_ft:
-	kfree(ct_flow);
 	netdev_warn(priv->netdev, "Failed to offload ct flow, err %d\n", err);
-	return ERR_PTR(err);
+	return err;
 }
 
-struct mlx5_flow_handle *
-mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *priv,
-			struct mlx5_flow_spec *spec,
-			struct mlx5_flow_attr *attr,
-			struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts)
+int
+mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *priv, struct mlx5_flow_attr *attr)
 {
-	struct mlx5_flow_handle *rule;
+	int err;
 
 	if (!priv)
-		return ERR_PTR(-EOPNOTSUPP);
+		return -EOPNOTSUPP;
+
+	if (attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR) {
+		err = mlx5_tc_ct_entry_set_registers(priv, &attr->parse_attr->mod_hdr_acts,
+						     0, 0, 0, 0);
+		if (err)
+			return err;
+
+		attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+	}
+
+	if (!attr->ct_attr.nf_ft) /* means only ct clear action, and not ct_clear,ct() */
+		return 0;
 
 	mutex_lock(&priv->control_lock);
-	rule = __mlx5_tc_ct_flow_offload(priv, spec, attr);
+	err = __mlx5_tc_ct_flow_offload(priv, attr);
 	mutex_unlock(&priv->control_lock);
 
-	return rule;
+	return err;
 }
 
 static void
 __mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *ct_priv,
-			 struct mlx5_ct_flow *ct_flow,
 			 struct mlx5_flow_attr *attr)
 {
-	struct mlx5_flow_attr *pre_ct_attr = ct_flow->pre_ct_attr;
-	struct mlx5e_priv *priv = netdev_priv(ct_priv->netdev);
-
-	mlx5_tc_rule_delete(priv, ct_flow->pre_ct_rule, pre_ct_attr);
-	mlx5_modify_header_dealloc(priv->mdev, pre_ct_attr->modify_hdr);
-
 	mlx5e_tc_action_miss_mapping_put(ct_priv->priv, attr, attr->ct_attr.act_miss_mapping);
-	mlx5_tc_ct_del_ft_cb(ct_priv, ct_flow->ft);
-
-	kfree(ct_flow->pre_ct_attr);
-	kfree(ct_flow);
+	mlx5_tc_ct_del_ft_cb(ct_priv, attr->ct_attr.ft);
 }
 
 void
 mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *priv,
 		       struct mlx5_flow_attr *attr)
 {
-	struct mlx5_ct_flow *ct_flow = attr->ct_attr.ct_flow;
-
-	/* We are called on error to clean up stuff from parsing
-	 * but we don't have anything for now
-	 */
-	if (!ct_flow)
+	if (!attr->ct_attr.nf_ft) /* means only ct clear action, and not ct_clear,ct() */
 		return;
 
 	mutex_lock(&priv->control_lock);
-	__mlx5_tc_ct_delete_flow(priv, ct_flow, attr);
+	__mlx5_tc_ct_delete_flow(priv, attr);
 	mutex_unlock(&priv->control_lock);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 5c5ddaa83055..8e9316fa46d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -25,11 +25,11 @@ struct nf_flowtable;
 struct mlx5_ct_attr {
 	u16 zone;
 	u16 ct_action;
-	struct mlx5_ct_flow *ct_flow;
 	struct nf_flowtable *nf_ft;
 	u32 ct_labels_id;
 	u32 act_miss_mapping;
 	u64 act_miss_cookie;
+	struct mlx5_ct_ft *ft;
 };
 
 #define zone_to_reg_ct {\
@@ -113,15 +113,12 @@ int mlx5_tc_ct_add_no_trk_match(struct mlx5_flow_spec *spec);
 int
 mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 			struct mlx5_flow_attr *attr,
-			struct mlx5e_tc_mod_hdr_acts *mod_acts,
 			const struct flow_action_entry *act,
 			struct netlink_ext_ack *extack);
 
-struct mlx5_flow_handle *
-mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *priv,
-			struct mlx5_flow_spec *spec,
-			struct mlx5_flow_attr *attr,
-			struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts);
+int
+mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *priv, struct mlx5_flow_attr *attr);
+
 void
 mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *priv,
 		       struct mlx5_flow_attr *attr);
@@ -130,10 +127,6 @@ bool
 mlx5e_tc_ct_restore_flow(struct mlx5_tc_ct_priv *ct_priv,
 			 struct sk_buff *skb, u8 zone_restore_id);
 
-int
-mlx5_tc_ct_set_ct_clear_regs(struct mlx5_tc_ct_priv *priv,
-			     struct mlx5e_tc_mod_hdr_acts *mod_acts);
-
 #else /* CONFIG_MLX5_TC_CT */
 
 static inline struct mlx5_tc_ct_priv *
@@ -175,17 +168,9 @@ mlx5_tc_ct_add_no_trk_match(struct mlx5_flow_spec *spec)
 	return 0;
 }
 
-static inline int
-mlx5_tc_ct_set_ct_clear_regs(struct mlx5_tc_ct_priv *priv,
-			     struct mlx5e_tc_mod_hdr_acts *mod_acts)
-{
-	return -EOPNOTSUPP;
-}
-
 static inline int
 mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 			struct mlx5_flow_attr *attr,
-			struct mlx5e_tc_mod_hdr_acts *mod_acts,
 			const struct flow_action_entry *act,
 			struct netlink_ext_ack *extack)
 {
@@ -193,13 +178,11 @@ mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 	return -EOPNOTSUPP;
 }
 
-static inline struct mlx5_flow_handle *
+static inline int
 mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *priv,
-			struct mlx5_flow_spec *spec,
-			struct mlx5_flow_attr *attr,
-			struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts)
+			struct mlx5_flow_attr *attr)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	return -EOPNOTSUPP;
 }
 
 static inline void
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 15deb1df4df3..d8fa8f0c0fbf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -488,15 +488,6 @@ mlx5e_tc_rule_offload(struct mlx5e_priv *priv,
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	int err;
 
-	if (attr->flags & MLX5_ATTR_FLAG_CT) {
-		struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts =
-			&attr->parse_attr->mod_hdr_acts;
-
-		return mlx5_tc_ct_flow_offload(get_ct_priv(priv),
-					       spec, attr,
-					       mod_hdr_acts);
-	}
-
 	if (!is_mdev_switchdev_mode(priv->mdev))
 		return mlx5e_add_offloaded_nic_rule(priv, spec, attr);
 
@@ -519,11 +510,6 @@ mlx5e_tc_rule_unoffload(struct mlx5e_priv *priv,
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 
-	if (attr->flags & MLX5_ATTR_FLAG_CT) {
-		mlx5_tc_ct_delete_flow(get_ct_priv(priv), attr);
-		return;
-	}
-
 	if (!is_mdev_switchdev_mode(priv->mdev)) {
 		mlx5e_del_offloaded_nic_rule(priv, rule, attr);
 		return;
@@ -1396,13 +1382,7 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 			return err;
 	}
 
-	if (attr->flags & MLX5_ATTR_FLAG_CT)
-		flow->rule[0] = mlx5_tc_ct_flow_offload(get_ct_priv(priv), &parse_attr->spec,
-							attr, &parse_attr->mod_hdr_acts);
-	else
-		flow->rule[0] = mlx5e_add_offloaded_nic_rule(priv, &parse_attr->spec,
-							     attr);
-
+	flow->rule[0] = mlx5e_add_offloaded_nic_rule(priv, &parse_attr->spec, attr);
 	return PTR_ERR_OR_ZERO(flow->rule[0]);
 }
 
@@ -1433,9 +1413,7 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 
 	flow_flag_clear(flow, OFFLOADED);
 
-	if (attr->flags & MLX5_ATTR_FLAG_CT)
-		mlx5_tc_ct_delete_flow(get_ct_priv(flow->priv), attr);
-	else if (!IS_ERR_OR_NULL(flow->rule[0]))
+	if (!IS_ERR_OR_NULL(flow->rule[0]))
 		mlx5e_del_offloaded_nic_rule(priv, flow->rule[0], attr);
 
 	/* Remove root table if no rules are left to avoid
@@ -3734,6 +3712,7 @@ mlx5e_clone_flow_attr_for_post_act(struct mlx5_flow_attr *attr,
 	attr2->dest_chain = 0;
 	attr2->dest_ft = NULL;
 	attr2->act_id_restore_rule = NULL;
+	memset(&attr2->ct_attr, 0, sizeof(attr2->ct_attr));
 
 	if (ns_type == MLX5_FLOW_NAMESPACE_FDB) {
 		attr2->esw_attr->out_count = 0;
@@ -4443,6 +4422,8 @@ mlx5_free_flow_attr_actions(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *a
 		mlx5e_tc_detach_mod_hdr(flow->priv, flow, attr);
 	}
 
+	mlx5_tc_ct_delete_flow(get_ct_priv(flow->priv), attr);
+
 	free_branch_attr(flow, attr->branch_true);
 	free_branch_attr(flow, attr->branch_false);
 }
@@ -4906,7 +4887,7 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 		goto errout;
 	}
 
-	if (mlx5e_is_offloaded_flow(flow) || flow_flag_test(flow, CT)) {
+	if (mlx5e_is_offloaded_flow(flow)) {
 		if (flow_flag_test(flow, USE_ACT_STATS)) {
 			f->use_act_stats = true;
 		} else {
-- 
2.39.2

