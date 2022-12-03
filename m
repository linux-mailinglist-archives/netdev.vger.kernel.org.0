Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23228641967
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 23:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiLCWOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 17:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiLCWOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 17:14:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B6D1E3DB
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 14:13:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95847B807E6
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 22:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC84C43470;
        Sat,  3 Dec 2022 22:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670105630;
        bh=t+i+NJ1nwpspShoF3O+oWgNT4UaQfL8S+UKVl4LuFj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ppq9cvIpcFIW1V6yRzsbcdi7mVUMTcuN4u0/lLc5wc7XDruLteXVhzZ5vxIgq3cVQ
         v2u5fJ5OMHFlAvVy7jRiNSJ8lIsq9Vw0KmXT4b9+pSyL4VD7WUsEnJbTkt018rGX5L
         /NLGJDLv1qqtFmQcVC3TbooufPjEJklUHofmCbo8FGPeZPzoO+eS4gsm19mgTNgOmh
         9OKCWFD/sgZHpq4NFyHs4o+HKGuzGatluXwQfwXRd/SosjGyVmXwm7SbTapoovc6/v
         FLy+SRYmWJ0iPjKvmt/aXQxMsMQKFlmvcPtdK0yu5HFm1Y+bL2noJejZE8TDuRDe4p
         oAm9kmfGAH1Ag==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net-next 07/15] net/mlx5e: TC, initialize branch flow attributes
Date:   Sat,  3 Dec 2022 14:13:29 -0800
Message-Id: <20221203221337.29267-8-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221203221337.29267-1-saeed@kernel.org>
References: <20221203221337.29267-1-saeed@kernel.org>
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

From: Oz Shlomo <ozsh@nvidia.com>

Initialize flow attribute for drop, accept, pipe and jump branching actions.

Instantiate a flow attribute instance according to the specified branch
control action. Store the branching attributes on the branching action
flow attribute during the parsing phase. Then, during the offload phase,
allocate the relevant mod header objects to the branching actions.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 156 ++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |   2 +
 2 files changed, 142 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 7eaf6c73b091..6bd71a85d56d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -160,6 +160,7 @@ static struct lock_class_key tc_ht_lock_key;
 
 static void mlx5e_put_flow_tunnel_id(struct mlx5e_tc_flow *flow);
 static void free_flow_post_acts(struct mlx5e_tc_flow *flow);
+static void mlx5_free_flow_attr(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *attr);
 
 void
 mlx5e_tc_match_to_reg_match(struct mlx5_flow_spec *spec,
@@ -1784,6 +1785,20 @@ post_process_attr(struct mlx5e_tc_flow *flow,
 		}
 	}
 
+	if (attr->branch_true &&
+	    attr->branch_true->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
+		err = mlx5e_tc_add_flow_mod_hdr(flow->priv, flow, attr->branch_true);
+		if (err)
+			goto err_out;
+	}
+
+	if (attr->branch_false &&
+	    attr->branch_false->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
+		err = mlx5e_tc_add_flow_mod_hdr(flow->priv, flow, attr->branch_false);
+		if (err)
+			goto err_out;
+	}
+
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT) {
 		err = alloc_flow_attr_counter(get_flow_counter_dev(flow), attr);
 		if (err)
@@ -1932,6 +1947,16 @@ static bool mlx5_flow_has_geneve_opt(struct mlx5e_tc_flow *flow)
 	return !!geneve_tlv_opt_0_data;
 }
 
+static void free_branch_attr(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *attr)
+{
+	if (!attr)
+		return;
+
+	mlx5_free_flow_attr(flow, attr);
+	kvfree(attr->parse_attr);
+	kfree(attr);
+}
+
 static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 				  struct mlx5e_tc_flow *flow)
 {
@@ -1987,6 +2012,8 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 		mlx5e_detach_decap(priv, flow);
 
 	free_flow_post_acts(flow);
+	free_branch_attr(flow, attr->branch_true);
+	free_branch_attr(flow, attr->branch_false);
 
 	if (flow->attr->lag.count)
 		mlx5_lag_del_mpesw_rule(esw->dev);
@@ -3659,6 +3686,8 @@ mlx5e_clone_flow_attr_for_post_act(struct mlx5_flow_attr *attr,
 		attr2->esw_attr->split_count = 0;
 	}
 
+	attr2->branch_true = NULL;
+	attr2->branch_false = NULL;
 	return attr2;
 }
 
@@ -3697,28 +3726,15 @@ mlx5e_tc_unoffload_flow_post_acts(struct mlx5e_tc_flow *flow)
 static void
 free_flow_post_acts(struct mlx5e_tc_flow *flow)
 {
-	struct mlx5_core_dev *counter_dev = get_flow_counter_dev(flow);
-	struct mlx5e_post_act *post_act = get_post_action(flow->priv);
 	struct mlx5_flow_attr *attr, *tmp;
-	bool vf_tun;
 
 	list_for_each_entry_safe(attr, tmp, &flow->attrs, list) {
 		if (list_is_last(&attr->list, &flow->attrs))
 			break;
 
-		if (attr->post_act_handle)
-			mlx5e_tc_post_act_del(post_act, attr->post_act_handle);
-
-		clean_encap_dests(flow->priv, flow, attr, &vf_tun);
-
-		if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
-			mlx5_fc_destroy(counter_dev, attr->counter);
-
-		if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
-			mlx5e_mod_hdr_dealloc(&attr->parse_attr->mod_hdr_acts);
-			if (attr->modify_hdr)
-				mlx5_modify_header_dealloc(flow->priv->mdev, attr->modify_hdr);
-		}
+		mlx5_free_flow_attr(flow, attr);
+		free_branch_attr(flow, attr->branch_true);
+		free_branch_attr(flow, attr->branch_false);
 
 		list_del(&attr->list);
 		kvfree(attr->parse_attr);
@@ -3825,6 +3841,86 @@ alloc_flow_post_acts(struct mlx5e_tc_flow *flow, struct netlink_ext_ack *extack)
 	return err;
 }
 
+static int
+alloc_branch_attr(struct mlx5e_tc_flow *flow,
+		  struct mlx5e_tc_act_branch_ctrl *cond,
+		  struct mlx5_flow_attr **cond_attr,
+		  u32 *jump_count,
+		  struct netlink_ext_ack *extack)
+{
+	struct mlx5_flow_attr *attr;
+	int err = 0;
+
+	*cond_attr = mlx5e_clone_flow_attr_for_post_act(flow->attr,
+							mlx5e_get_flow_namespace(flow));
+	if (!(*cond_attr))
+		return -ENOMEM;
+
+	attr = *cond_attr;
+
+	switch (cond->act_id) {
+	case FLOW_ACTION_DROP:
+		attr->action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
+		break;
+	case FLOW_ACTION_ACCEPT:
+	case FLOW_ACTION_PIPE:
+		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+		attr->dest_ft = mlx5e_tc_post_act_get_ft(get_post_action(flow->priv));
+		break;
+	case FLOW_ACTION_JUMP:
+		if (*jump_count) {
+			NL_SET_ERR_MSG_MOD(extack, "Cannot offload flows with nested jumps");
+			err = -EOPNOTSUPP;
+			goto out_err;
+		}
+		*jump_count = cond->extval;
+		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+		attr->dest_ft = mlx5e_tc_post_act_get_ft(get_post_action(flow->priv));
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		goto out_err;
+	}
+
+	return err;
+out_err:
+	kfree(*cond_attr);
+	*cond_attr = NULL;
+	return err;
+}
+
+static int
+parse_branch_ctrl(struct flow_action_entry *act, struct mlx5e_tc_act *tc_act,
+		  struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *attr,
+		  struct netlink_ext_ack *extack)
+{
+	struct mlx5e_tc_act_branch_ctrl cond_true, cond_false;
+	u32 jump_count;
+	int err;
+
+	if (!tc_act->get_branch_ctrl)
+		return 0;
+
+	tc_act->get_branch_ctrl(act, &cond_true, &cond_false);
+
+	err = alloc_branch_attr(flow, &cond_true,
+				&attr->branch_true, &jump_count, extack);
+	if (err)
+		goto out_err;
+
+	err = alloc_branch_attr(flow, &cond_false,
+				&attr->branch_false, &jump_count, extack);
+	if (err)
+		goto err_branch_false;
+
+	return 0;
+
+err_branch_false:
+	free_branch_attr(flow, attr->branch_true);
+out_err:
+	return err;
+}
+
 static int
 parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 		 struct flow_action *flow_action)
@@ -3868,6 +3964,10 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 		if (err)
 			goto out_free;
 
+		err = parse_branch_ctrl(act, tc_act, flow, attr, extack);
+		if (err)
+			goto out_free;
+
 		parse_state->actions |= attr->action;
 
 		/* Split attr for multi table act if not the last act. */
@@ -4196,6 +4296,30 @@ mlx5_alloc_flow_attr(enum mlx5_flow_namespace_type type)
 	return attr;
 }
 
+static void
+mlx5_free_flow_attr(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *attr)
+{
+	struct mlx5_core_dev *counter_dev = get_flow_counter_dev(flow);
+	bool vf_tun;
+
+	if (!attr)
+		return;
+
+	if (attr->post_act_handle)
+		mlx5e_tc_post_act_del(get_post_action(flow->priv), attr->post_act_handle);
+
+	clean_encap_dests(flow->priv, flow, attr, &vf_tun);
+
+	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
+		mlx5_fc_destroy(counter_dev, attr->counter);
+
+	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
+		mlx5e_mod_hdr_dealloc(&attr->parse_attr->mod_hdr_acts);
+		if (attr->modify_hdr)
+			mlx5_modify_header_dealloc(flow->priv->mdev, attr->modify_hdr);
+	}
+}
+
 static int
 mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 		 struct flow_cls_offload *f, unsigned long flow_flags,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 0db41fa4a9a6..cee88f7dd50f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -95,6 +95,8 @@ struct mlx5_flow_attr {
 		 */
 		bool count;
 	} lag;
+	struct mlx5_flow_attr *branch_true;
+	struct mlx5_flow_attr *branch_false;
 	/* keep this union last */
 	union {
 		DECLARE_FLEX_ARRAY(struct mlx5_esw_flow_attr, esw_attr);
-- 
2.38.1

