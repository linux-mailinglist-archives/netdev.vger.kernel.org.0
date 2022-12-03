Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C798A641969
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 23:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiLCWOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 17:14:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiLCWOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 17:14:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3035F1E3E8
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 14:13:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8065B807E9
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 22:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64077C433C1;
        Sat,  3 Dec 2022 22:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670105631;
        bh=rFbFIns5sp0SUwOWEu8dmGe499KCdgUBoMosI3hdQnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t85rjbppSIY1o1TISfhIfh8glaM3XP3Yaul/dwVY29Ilw/0pO1pGWN1tp/bLC+m/7
         3LabCAOFETDgHQ1okpzi7XzztIJMYpvLFKleV5nXL9Vci4kndDYO0P4ncPaC5dmEPK
         sX0UOIXFTE9OQW8b7NqrgrADnjc9acZDm6KeT8GRKdVWGp6qQ3g5W9pMdFnBLWRSfD
         z0nkyxY45OEmA2MY2SMNaETnS+1NrgUYDwIaabIVrUdlrfb/wn0MtlrcX7TqvCEeAg
         6UIGJsT1PBKINWTp7wJLtKaUKNACwINujdssv1bZAw27uAT/GLJ7I/5f0y7eohlbP+
         2B4ZhqTfnwzfQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net-next 08/15] net/mlx5e: TC, initialize branching action with target attr
Date:   Sat,  3 Dec 2022 14:13:30 -0800
Message-Id: <20221203221337.29267-9-saeed@kernel.org>
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

Identify the jump target action when iterating the action list.
Initialize the jump target attr with the jumping attribute during the
parsing phase. Initialize the jumping attr post action with the target
during the offload phase.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 86 +++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  2 +
 2 files changed, 83 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 6bd71a85d56d..d52f8601fef4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -132,6 +132,15 @@ struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
 	[PACKET_COLOR_TO_REG] = packet_color_to_reg,
 };
 
+struct mlx5e_tc_jump_state {
+	u32 jump_count;
+	bool jump_target;
+	struct mlx5_flow_attr *jumping_attr;
+
+	enum flow_action_id last_id;
+	u32 last_index;
+};
+
 struct mlx5e_tc_table *mlx5e_tc_table_alloc(void)
 {
 	struct mlx5e_tc_table *tc;
@@ -3688,6 +3697,7 @@ mlx5e_clone_flow_attr_for_post_act(struct mlx5_flow_attr *attr,
 
 	attr2->branch_true = NULL;
 	attr2->branch_false = NULL;
+	attr2->jumping_attr = NULL;
 	return attr2;
 }
 
@@ -3796,7 +3806,9 @@ alloc_flow_post_acts(struct mlx5e_tc_flow *flow, struct netlink_ext_ack *extack)
 		if (!next_attr) {
 			/* Set counter action on last post act rule. */
 			attr->action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
-		} else {
+		}
+
+		if (next_attr && !(attr->flags & MLX5_ATTR_FLAG_TERMINATING)) {
 			err = mlx5e_tc_act_set_next_post_act(flow, attr, next_attr);
 			if (err)
 				goto out_free;
@@ -3823,6 +3835,13 @@ alloc_flow_post_acts(struct mlx5e_tc_flow *flow, struct netlink_ext_ack *extack)
 		}
 
 		attr->post_act_handle = handle;
+
+		if (attr->jumping_attr) {
+			err = mlx5e_tc_act_set_next_post_act(flow, attr->jumping_attr, attr);
+			if (err)
+				goto out_free;
+		}
+
 		next_attr = attr;
 	}
 
@@ -3889,13 +3908,58 @@ alloc_branch_attr(struct mlx5e_tc_flow *flow,
 	return err;
 }
 
+static void
+dec_jump_count(struct flow_action_entry *act, struct mlx5e_tc_act *tc_act,
+	       struct mlx5_flow_attr *attr, struct mlx5e_priv *priv,
+	       struct mlx5e_tc_jump_state *jump_state)
+{
+	if (!jump_state->jump_count)
+		return;
+
+	/* Single tc action can instantiate multiple offload actions (e.g. pedit)
+	 * Jump only over a tc action
+	 */
+	if (act->id == jump_state->last_id && act->hw_index == jump_state->last_index)
+		return;
+
+	jump_state->last_id = act->id;
+	jump_state->last_index = act->hw_index;
+
+	/* nothing to do for intermediate actions */
+	if (--jump_state->jump_count > 1)
+		return;
+
+	if (jump_state->jump_count == 1) { /* last action in the jump action list */
+
+		/* create a new attribute after this action */
+		jump_state->jump_target = true;
+
+		if (tc_act->is_terminating_action) { /* the branch ends here */
+			attr->flags |= MLX5_ATTR_FLAG_TERMINATING;
+			attr->action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
+		} else { /* the branch continues executing the rest of the actions */
+			struct mlx5e_post_act *post_act;
+
+			attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+			post_act = get_post_action(priv);
+			attr->dest_ft = mlx5e_tc_post_act_get_ft(post_act);
+		}
+	} else if (jump_state->jump_count == 0) { /* first attr after the jump action list */
+		/* This is the post action for the jumping attribute (either red or green)
+		 * Use the stored jumping_attr to set the post act id on the jumping attribute
+		 */
+		attr->jumping_attr = jump_state->jumping_attr;
+	}
+}
+
 static int
 parse_branch_ctrl(struct flow_action_entry *act, struct mlx5e_tc_act *tc_act,
 		  struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *attr,
+		  struct mlx5e_tc_jump_state *jump_state,
 		  struct netlink_ext_ack *extack)
 {
 	struct mlx5e_tc_act_branch_ctrl cond_true, cond_false;
-	u32 jump_count;
+	u32 jump_count = jump_state->jump_count;
 	int err;
 
 	if (!tc_act->get_branch_ctrl)
@@ -3908,11 +3972,18 @@ parse_branch_ctrl(struct flow_action_entry *act, struct mlx5e_tc_act *tc_act,
 	if (err)
 		goto out_err;
 
+	if (jump_count)
+		jump_state->jumping_attr = attr->branch_true;
+
 	err = alloc_branch_attr(flow, &cond_false,
 				&attr->branch_false, &jump_count, extack);
 	if (err)
 		goto err_branch_false;
 
+	if (jump_count && !jump_state->jumping_attr)
+		jump_state->jumping_attr = attr->branch_false;
+
+	jump_state->jump_count = jump_count;
 	return 0;
 
 err_branch_false:
@@ -3928,6 +3999,7 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 	struct netlink_ext_ack *extack = parse_state->extack;
 	struct mlx5e_tc_flow_action flow_action_reorder;
 	struct mlx5e_tc_flow *flow = parse_state->flow;
+	struct mlx5e_tc_jump_state jump_state = {};
 	struct mlx5_flow_attr *attr = flow->attr;
 	enum mlx5_flow_namespace_type ns_type;
 	struct mlx5e_priv *priv = flow->priv;
@@ -3947,6 +4019,7 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 	list_add(&attr->list, &flow->attrs);
 
 	flow_action_for_each(i, _act, &flow_action_reorder) {
+		jump_state.jump_target = false;
 		act = *_act;
 		tc_act = mlx5e_tc_act_get(act->id, ns_type);
 		if (!tc_act) {
@@ -3964,16 +4037,19 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 		if (err)
 			goto out_free;
 
-		err = parse_branch_ctrl(act, tc_act, flow, attr, extack);
+		dec_jump_count(act, tc_act, attr, priv, &jump_state);
+
+		err = parse_branch_ctrl(act, tc_act, flow, attr, &jump_state, extack);
 		if (err)
 			goto out_free;
 
 		parse_state->actions |= attr->action;
 
 		/* Split attr for multi table act if not the last act. */
-		if (tc_act->is_multi_table_act &&
+		if (jump_state.jump_target ||
+		    (tc_act->is_multi_table_act &&
 		    tc_act->is_multi_table_act(priv, act, attr) &&
-		    i < flow_action_reorder.num_entries - 1) {
+		    i < flow_action_reorder.num_entries - 1)) {
 			err = mlx5e_tc_act_post_parse(parse_state, flow_action, attr, ns_type);
 			if (err)
 				goto out_free;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index cee88f7dd50f..f2677d9ca0b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -97,6 +97,7 @@ struct mlx5_flow_attr {
 	} lag;
 	struct mlx5_flow_attr *branch_true;
 	struct mlx5_flow_attr *branch_false;
+	struct mlx5_flow_attr *jumping_attr;
 	/* keep this union last */
 	union {
 		DECLARE_FLEX_ARRAY(struct mlx5_esw_flow_attr, esw_attr);
@@ -112,6 +113,7 @@ enum {
 	MLX5_ATTR_FLAG_SAMPLE        = BIT(4),
 	MLX5_ATTR_FLAG_ACCEPT        = BIT(5),
 	MLX5_ATTR_FLAG_CT            = BIT(6),
+	MLX5_ATTR_FLAG_TERMINATING   = BIT(7),
 };
 
 /* Returns true if any of the flags that require skipping further TC/NF processing are set. */
-- 
2.38.1

