Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB25C68E50C
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 01:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjBHAhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 19:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjBHAhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 19:37:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E696C3E0A3
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 16:37:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5870961477
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 00:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE16FC433EF;
        Wed,  8 Feb 2023 00:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675816642;
        bh=YsVRJMeiujpVw9lDdpnuJkhbPYVic3SFh7cLL1GlXo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N1VZzvhew8Q/s+My088jQ/6E5WK6h8dHGZFNf+l8s7vIRnJzBHkLsOGrAe51zcpBy
         nYOoEUUupJgrLrRxrovNeugAWJHGkBp52gNjwQ2yVayqQSCw0VOmezo0dcRIAVlqZz
         v9rmeayXeEsVAXypPt39zOToe/4iTG3CtuRhvWK+cgryUkG6tQyNCw5lJSE550HXaW
         72XQS+aCCzdZZ5XCg6hB4jD7wZ0Q9gcYWll+uH/te5br66Ez4CO01HTE5PODnhrdXT
         mFbnh+/kpNzVHmCKUD2rIfZKjKsuvTNcM0JT966TkpUVYG3b1wAaSr1OubyLO+Ob99
         LrZD+e+DDbXuQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net-next 05/15] net/mlx5e: Remove redundant code for handling vlan actions
Date:   Tue,  7 Feb 2023 16:37:02 -0800
Message-Id: <20230208003712.68386-6-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208003712.68386-1-saeed@kernel.org>
References: <20230208003712.68386-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Remove unused code which was used only with deprecated HW
which didn't support vlan actions.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/act/vlan.c       |  35 +--
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   9 -
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   5 -
 .../mellanox/mlx5/core/eswitch_offloads.c     | 208 +-----------------
 4 files changed, 14 insertions(+), 243 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
index b86ac604d0c2..2e0d88b513aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
@@ -44,19 +44,17 @@ parse_tc_vlan_action(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
+	if (!mlx5_eswitch_vlan_actions_supported(priv->mdev, vlan_idx)) {
+		NL_SET_ERR_MSG_MOD(extack, "firmware vlan actions is not supported");
+		return -EOPNOTSUPP;
+	}
+
 	switch (act->id) {
 	case FLOW_ACTION_VLAN_POP:
-		if (vlan_idx) {
-			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev,
-								 MLX5_FS_VLAN_DEPTH)) {
-				NL_SET_ERR_MSG_MOD(extack, "vlan pop action is not supported");
-				return -EOPNOTSUPP;
-			}
-
+		if (vlan_idx)
 			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_POP_2;
-		} else {
+		else
 			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_POP;
-		}
 		break;
 	case FLOW_ACTION_VLAN_PUSH:
 		attr->vlan_vid[vlan_idx] = act->vlan.vid;
@@ -65,25 +63,10 @@ parse_tc_vlan_action(struct mlx5e_priv *priv,
 		if (!attr->vlan_proto[vlan_idx])
 			attr->vlan_proto[vlan_idx] = htons(ETH_P_8021Q);
 
-		if (vlan_idx) {
-			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev,
-								 MLX5_FS_VLAN_DEPTH)) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "vlan push action is not supported for vlan depth > 1");
-				return -EOPNOTSUPP;
-			}
-
+		if (vlan_idx)
 			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2;
-		} else {
-			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev, 1) &&
-			    (act->vlan.proto != htons(ETH_P_8021Q) ||
-			     act->vlan.prio)) {
-				NL_SET_ERR_MSG_MOD(extack, "vlan push action is not supported");
-				return -EOPNOTSUPP;
-			}
-
+		else
 			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH;
-		}
 		break;
 	case FLOW_ACTION_VLAN_POP_ETH:
 		parse_state->eth_pop = true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 4e6f5caf8ab6..bf4cff8b1d42 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1884,7 +1884,6 @@ post_process_attr(struct mlx5e_tc_flow *flow,
 		  struct mlx5_flow_attr *attr,
 		  struct netlink_ext_ack *extack)
 {
-	struct mlx5_eswitch *esw = flow->priv->mdev->priv.eswitch;
 	bool vf_tun;
 	int err = 0;
 
@@ -1896,12 +1895,6 @@ post_process_attr(struct mlx5e_tc_flow *flow,
 	if (err)
 		goto err_out;
 
-	if (mlx5e_is_eswitch_flow(flow)) {
-		err = mlx5_eswitch_add_vlan_action(esw, attr);
-		if (err)
-			goto err_out;
-	}
-
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
 		err = mlx5e_tc_attach_mod_hdr(flow->priv, flow, attr);
 		if (err)
@@ -2105,8 +2098,6 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	if (mlx5_flow_has_geneve_opt(flow))
 		mlx5_geneve_tlv_option_del(priv->mdev->geneve);
 
-	mlx5_eswitch_del_vlan_action(esw, attr);
-
 	if (flow->decap_route)
 		mlx5e_detach_decap_route(priv, flow);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 5b5a215a7dc5..fd03f076551b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -222,7 +222,6 @@ struct mlx5_eswitch_fdb {
 			struct mlx5_flow_handle **send_to_vport_meta_rules;
 			struct mlx5_flow_handle *miss_rule_uni;
 			struct mlx5_flow_handle *miss_rule_multi;
-			int vlan_push_pop_refcount;
 
 			struct mlx5_fs_chains *esw_chains_priv;
 			struct {
@@ -520,10 +519,6 @@ int mlx5_devlink_port_fn_migratable_set(struct devlink_port *port, bool enable,
 					struct netlink_ext_ack *extack);
 void *mlx5_eswitch_get_uplink_priv(struct mlx5_eswitch *esw, u8 rep_type);
 
-int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw,
-				 struct mlx5_flow_attr *attr);
-int mlx5_eswitch_del_vlan_action(struct mlx5_eswitch *esw,
-				 struct mlx5_flow_attr *attr);
 int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 				  u16 vport, u16 vlan, u8 qos, u8 set_flags);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 3a82e385544d..8fb09143e9e8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -579,16 +579,16 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 	if (esw->mode != MLX5_ESWITCH_OFFLOADS)
 		return ERR_PTR(-EOPNOTSUPP);
 
+	if (!mlx5_eswitch_vlan_actions_supported(esw->dev, 1))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	dest = kcalloc(MLX5_MAX_FLOW_FWD_VPORTS + 1, sizeof(*dest), GFP_KERNEL);
 	if (!dest)
 		return ERR_PTR(-ENOMEM);
 
 	flow_act.action = attr->action;
-	/* if per flow vlan pop/push is emulated, don't set that into the firmware */
-	if (!mlx5_eswitch_vlan_actions_supported(esw->dev, 1))
-		flow_act.action &= ~(MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH |
-				     MLX5_FLOW_CONTEXT_ACTION_VLAN_POP);
-	else if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH) {
+
+	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH) {
 		flow_act.vlan[0].ethtype = ntohs(esw_attr->vlan_proto[0]);
 		flow_act.vlan[0].vid = esw_attr->vlan_vid[0];
 		flow_act.vlan[0].prio = esw_attr->vlan_prio[0];
@@ -829,204 +829,6 @@ mlx5_eswitch_del_fwd_rule(struct mlx5_eswitch *esw,
 	__mlx5_eswitch_del_rule(esw, rule, attr, true);
 }
 
-static int esw_set_global_vlan_pop(struct mlx5_eswitch *esw, u8 val)
-{
-	struct mlx5_eswitch_rep *rep;
-	unsigned long i;
-	int err = 0;
-
-	esw_debug(esw->dev, "%s applying global %s policy\n", __func__, val ? "pop" : "none");
-	mlx5_esw_for_each_host_func_vport(esw, i, rep, esw->esw_funcs.num_vfs) {
-		if (atomic_read(&rep->rep_data[REP_ETH].state) != REP_LOADED)
-			continue;
-
-		err = __mlx5_eswitch_set_vport_vlan(esw, rep->vport, 0, 0, val);
-		if (err)
-			goto out;
-	}
-
-out:
-	return err;
-}
-
-static struct mlx5_eswitch_rep *
-esw_vlan_action_get_vport(struct mlx5_esw_flow_attr *attr, bool push, bool pop)
-{
-	struct mlx5_eswitch_rep *in_rep, *out_rep, *vport = NULL;
-
-	in_rep  = attr->in_rep;
-	out_rep = attr->dests[0].rep;
-
-	if (push)
-		vport = in_rep;
-	else if (pop)
-		vport = out_rep;
-	else
-		vport = in_rep;
-
-	return vport;
-}
-
-static int esw_add_vlan_action_check(struct mlx5_esw_flow_attr *attr,
-				     bool push, bool pop, bool fwd)
-{
-	struct mlx5_eswitch_rep *in_rep, *out_rep;
-
-	if ((push || pop) && !fwd)
-		goto out_notsupp;
-
-	in_rep  = attr->in_rep;
-	out_rep = attr->dests[0].rep;
-
-	if (push && in_rep->vport == MLX5_VPORT_UPLINK)
-		goto out_notsupp;
-
-	if (pop && out_rep->vport == MLX5_VPORT_UPLINK)
-		goto out_notsupp;
-
-	/* vport has vlan push configured, can't offload VF --> wire rules w.o it */
-	if (!push && !pop && fwd)
-		if (in_rep->vlan && out_rep->vport == MLX5_VPORT_UPLINK)
-			goto out_notsupp;
-
-	/* protects against (1) setting rules with different vlans to push and
-	 * (2) setting rules w.o vlans (attr->vlan = 0) && w. vlans to push (!= 0)
-	 */
-	if (push && in_rep->vlan_refcount && (in_rep->vlan != attr->vlan_vid[0]))
-		goto out_notsupp;
-
-	return 0;
-
-out_notsupp:
-	return -EOPNOTSUPP;
-}
-
-int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw,
-				 struct mlx5_flow_attr *attr)
-{
-	struct offloads_fdb *offloads = &esw->fdb_table.offloads;
-	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
-	struct mlx5_eswitch_rep *vport = NULL;
-	bool push, pop, fwd;
-	int err = 0;
-
-	/* nop if we're on the vlan push/pop non emulation mode */
-	if (mlx5_eswitch_vlan_actions_supported(esw->dev, 1))
-		return 0;
-
-	push = !!(attr->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH);
-	pop  = !!(attr->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP);
-	fwd  = !!((attr->action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) &&
-		   !attr->dest_chain);
-
-	mutex_lock(&esw->state_lock);
-
-	err = esw_add_vlan_action_check(esw_attr, push, pop, fwd);
-	if (err)
-		goto unlock;
-
-	attr->flags &= ~MLX5_ATTR_FLAG_VLAN_HANDLED;
-
-	vport = esw_vlan_action_get_vport(esw_attr, push, pop);
-
-	if (!push && !pop && fwd) {
-		/* tracks VF --> wire rules without vlan push action */
-		if (esw_attr->dests[0].rep->vport == MLX5_VPORT_UPLINK) {
-			vport->vlan_refcount++;
-			attr->flags |= MLX5_ATTR_FLAG_VLAN_HANDLED;
-		}
-
-		goto unlock;
-	}
-
-	if (!push && !pop)
-		goto unlock;
-
-	if (!(offloads->vlan_push_pop_refcount)) {
-		/* it's the 1st vlan rule, apply global vlan pop policy */
-		err = esw_set_global_vlan_pop(esw, SET_VLAN_STRIP);
-		if (err)
-			goto out;
-	}
-	offloads->vlan_push_pop_refcount++;
-
-	if (push) {
-		if (vport->vlan_refcount)
-			goto skip_set_push;
-
-		err = __mlx5_eswitch_set_vport_vlan(esw, vport->vport, esw_attr->vlan_vid[0],
-						    0, SET_VLAN_INSERT | SET_VLAN_STRIP);
-		if (err)
-			goto out;
-		vport->vlan = esw_attr->vlan_vid[0];
-skip_set_push:
-		vport->vlan_refcount++;
-	}
-out:
-	if (!err)
-		attr->flags |= MLX5_ATTR_FLAG_VLAN_HANDLED;
-unlock:
-	mutex_unlock(&esw->state_lock);
-	return err;
-}
-
-int mlx5_eswitch_del_vlan_action(struct mlx5_eswitch *esw,
-				 struct mlx5_flow_attr *attr)
-{
-	struct offloads_fdb *offloads = &esw->fdb_table.offloads;
-	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
-	struct mlx5_eswitch_rep *vport = NULL;
-	bool push, pop, fwd;
-	int err = 0;
-
-	/* nop if we're on the vlan push/pop non emulation mode */
-	if (mlx5_eswitch_vlan_actions_supported(esw->dev, 1))
-		return 0;
-
-	if (!(attr->flags & MLX5_ATTR_FLAG_VLAN_HANDLED))
-		return 0;
-
-	push = !!(attr->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH);
-	pop  = !!(attr->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP);
-	fwd  = !!(attr->action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST);
-
-	mutex_lock(&esw->state_lock);
-
-	vport = esw_vlan_action_get_vport(esw_attr, push, pop);
-
-	if (!push && !pop && fwd) {
-		/* tracks VF --> wire rules without vlan push action */
-		if (esw_attr->dests[0].rep->vport == MLX5_VPORT_UPLINK)
-			vport->vlan_refcount--;
-
-		goto out;
-	}
-
-	if (push) {
-		vport->vlan_refcount--;
-		if (vport->vlan_refcount)
-			goto skip_unset_push;
-
-		vport->vlan = 0;
-		err = __mlx5_eswitch_set_vport_vlan(esw, vport->vport,
-						    0, 0, SET_VLAN_STRIP);
-		if (err)
-			goto out;
-	}
-
-skip_unset_push:
-	offloads->vlan_push_pop_refcount--;
-	if (offloads->vlan_push_pop_refcount)
-		goto out;
-
-	/* no more vlan rules, stop global vlan pop policy */
-	err = esw_set_global_vlan_pop(esw, 0);
-
-out:
-	mutex_unlock(&esw->state_lock);
-	return err;
-}
-
 struct mlx5_flow_handle *
 mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *on_esw,
 				    struct mlx5_eswitch *from_esw,
-- 
2.39.1

