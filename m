Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504A36D8D2C
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234827AbjDFCDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 22:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234789AbjDFCCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:02:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93307A8D
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 19:02:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C925162A15
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1A5C433D2;
        Thu,  6 Apr 2023 02:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680746567;
        bh=xXyiHi8aVFBnx430qYXVSkwuvvC7olWpkrdJoNaMgUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JflyCcTIgmEhQOA+/y+VnbTrdPBqOVYCds6fNM3pQJIWZAkA232HXkrpgF1CXxXE3
         4W+E+Rsi9orlWsGhXnwqnBtCR9eF5jMA5tehf0jB0oWGG4Du6tHP0qq+xJ9ETmMBtu
         0fhWTmsA3dUhcJa2zLphgUKA6Vd6Ccq/5nBDT4pN6S7KJatHLS/N30wjPT96vNU/L4
         LEaWyiM78spFYWdFjRJGyYjYmOXrPetTGXeyDKu6y1rRTS6GXMH8dnL2QGjwpPXjnG
         5EAMCpRSF/No8LXLuEEEh2sNBuG2FFP9GoZnmclEt90E2D6MqcJoygYz/kqiDwpHXp
         Z3/ucEchBiDUw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 05/15] net/mlx5e: TC, Remove CT action reordering
Date:   Wed,  5 Apr 2023 19:02:22 -0700
Message-Id: <20230406020232.83844-6-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406020232.83844-1-saeed@kernel.org>
References: <20230406020232.83844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

CT action reordering was done as a workaround when CT misses
used to restore the relevant filter's tc chain and continuing sw processing
from that chain. As such, there was a need to reorder CT action to be before
any packet modifying actions (e.g mac rewrite).

Currently (after patch "net/mlx5e: TC, Set CT miss to the specific ct
action instance"), CT misses continues from the relevant ct action in
software, and so reordering isn't needed anymore.

Remove the reordering.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/act/act.c        | 20 ------------
 .../mellanox/mlx5/core/en/tc/act/act.h        |  4 ---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 32 ++++++-------------
 3 files changed, 9 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
index eba0c8698926..fc923a99b6a4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
@@ -82,26 +82,6 @@ mlx5e_tc_act_init_parse_state(struct mlx5e_tc_act_parse_state *parse_state,
 	parse_state->flow_action = flow_action;
 }
 
-void
-mlx5e_tc_act_reorder_flow_actions(struct flow_action *flow_action,
-				  struct mlx5e_tc_flow_action *flow_action_reorder)
-{
-	struct flow_action_entry *act;
-	int i, j = 0;
-
-	flow_action_for_each(i, act, flow_action) {
-		/* Add CT action to be first. */
-		if (act->id == FLOW_ACTION_CT)
-			flow_action_reorder->entries[j++] = act;
-	}
-
-	flow_action_for_each(i, act, flow_action) {
-		if (act->id == FLOW_ACTION_CT)
-			continue;
-		flow_action_reorder->entries[j++] = act;
-	}
-}
-
 int
 mlx5e_tc_act_post_parse(struct mlx5e_tc_act_parse_state *parse_state,
 			struct flow_action *flow_action,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index cdcddf6e1b08..d7615e329e6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -112,10 +112,6 @@ mlx5e_tc_act_init_parse_state(struct mlx5e_tc_act_parse_state *parse_state,
 			      struct flow_action *flow_action,
 			      struct netlink_ext_ack *extack);
 
-void
-mlx5e_tc_act_reorder_flow_actions(struct flow_action *flow_action,
-				  struct mlx5e_tc_flow_action *flow_action_reorder);
-
 int
 mlx5e_tc_act_post_parse(struct mlx5e_tc_act_parse_state *parse_state,
 			struct flow_action *flow_action,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 32b50d685312..15deb1df4df3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4045,32 +4045,22 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 		 struct flow_action *flow_action)
 {
 	struct netlink_ext_ack *extack = parse_state->extack;
-	struct mlx5e_tc_flow_action flow_action_reorder;
 	struct mlx5e_tc_flow *flow = parse_state->flow;
 	struct mlx5e_tc_jump_state jump_state = {};
 	struct mlx5_flow_attr *attr = flow->attr;
 	enum mlx5_flow_namespace_type ns_type;
 	struct mlx5e_priv *priv = flow->priv;
-	struct flow_action_entry *act, **_act;
 	struct mlx5_flow_attr *prev_attr;
+	struct flow_action_entry *act;
 	struct mlx5e_tc_act *tc_act;
 	bool is_missable;
 	int err, i;
 
-	flow_action_reorder.num_entries = flow_action->num_entries;
-	flow_action_reorder.entries = kcalloc(flow_action->num_entries,
-					      sizeof(flow_action), GFP_KERNEL);
-	if (!flow_action_reorder.entries)
-		return -ENOMEM;
-
-	mlx5e_tc_act_reorder_flow_actions(flow_action, &flow_action_reorder);
-
 	ns_type = mlx5e_get_flow_namespace(flow);
 	list_add(&attr->list, &flow->attrs);
 
-	flow_action_for_each(i, _act, &flow_action_reorder) {
+	flow_action_for_each(i, act, flow_action) {
 		jump_state.jump_target = false;
-		act = *_act;
 		is_missable = false;
 		prev_attr = attr;
 
@@ -4078,23 +4068,23 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 		if (!tc_act) {
 			NL_SET_ERR_MSG_MOD(extack, "Not implemented offload action");
 			err = -EOPNOTSUPP;
-			goto out_free;
+			goto out_free_post_acts;
 		}
 
 		if (tc_act->can_offload && !tc_act->can_offload(parse_state, act, i, attr)) {
 			err = -EOPNOTSUPP;
-			goto out_free;
+			goto out_free_post_acts;
 		}
 
 		err = tc_act->parse_action(parse_state, act, priv, attr);
 		if (err)
-			goto out_free;
+			goto out_free_post_acts;
 
 		dec_jump_count(act, tc_act, attr, priv, &jump_state);
 
 		err = parse_branch_ctrl(act, tc_act, flow, attr, &jump_state, extack);
 		if (err)
-			goto out_free;
+			goto out_free_post_acts;
 
 		parse_state->actions |= attr->action;
 
@@ -4102,17 +4092,17 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 		if (jump_state.jump_target ||
 		    (tc_act->is_multi_table_act &&
 		    tc_act->is_multi_table_act(priv, act, attr) &&
-		    i < flow_action_reorder.num_entries - 1)) {
+		    i < flow_action->num_entries - 1)) {
 			is_missable = tc_act->is_missable ? tc_act->is_missable(act) : false;
 
 			err = mlx5e_tc_act_post_parse(parse_state, flow_action, attr, ns_type);
 			if (err)
-				goto out_free;
+				goto out_free_post_acts;
 
 			attr = mlx5e_clone_flow_attr_for_post_act(flow->attr, ns_type);
 			if (!attr) {
 				err = -ENOMEM;
-				goto out_free;
+				goto out_free_post_acts;
 			}
 
 			list_add(&attr->list, &flow->attrs);
@@ -4129,8 +4119,6 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 		}
 	}
 
-	kfree(flow_action_reorder.entries);
-
 	err = mlx5e_tc_act_post_parse(parse_state, flow_action, attr, ns_type);
 	if (err)
 		goto out_free_post_acts;
@@ -4141,8 +4129,6 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 
 	return 0;
 
-out_free:
-	kfree(flow_action_reorder.entries);
 out_free_post_acts:
 	free_flow_post_acts(flow);
 
-- 
2.39.2

