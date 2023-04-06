Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291A86D8D2B
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbjDFCDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 22:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234721AbjDFCCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:02:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073B94EE8
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 19:02:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD9CC618D7
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D790C433EF;
        Thu,  6 Apr 2023 02:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680746566;
        bh=DIAekIct+vuNyOWqCYzb+ouwI5LodI5G1xkqZ/tzXOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxPf5TpANdDbfdJ7y+tNk12+S0MtaYa4so0pWNM/XmUmD6SoSfSUx9iEdVBpD7Pr4
         7AliDaODJR11tEgIsgbTafWq+uvDgqQPbOWq08lTwDesFxDmZCLwXjEHBU0Vc6Z6ST
         fpLH2BN9NDk8kTZXKiywt2YkykXY6W11+Lajw9VuHvJNX/SLe5L/RDfLyc58B7BZSP
         c+N/r/hYih8LqYVSNYSqEscyX3eot9vsnbRVG74yH60HCUuidqUaKDZYnNx+wRS5We
         T2WDFubHxA4O6DAyAaJG+h+GB2e+Gja9EERqZMRtp08Iub2wC5OtztwKilfT1kFbZF
         rUG467g8UwHFw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 04/15] net/mlx5e: CT: Use per action stats
Date:   Wed,  5 Apr 2023 19:02:21 -0700
Message-Id: <20230406020232.83844-5-saeed@kernel.org>
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

CT action can miss in a middle of an action list, use
per action stats to correctly report stats for missed
packets.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/act/act.h        |  2 ++
 .../mellanox/mlx5/core/en/tc/act/ct.c         |  9 ++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 19 +++++++++++++++++--
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index 8346557eeaf6..cdcddf6e1b08 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -56,6 +56,8 @@ struct mlx5e_tc_act {
 				   const struct flow_action_entry *act,
 				   struct mlx5_flow_attr *attr);
 
+	bool (*is_missable)(const struct flow_action_entry *act);
+
 	int (*offload_action)(struct mlx5e_priv *priv,
 			      struct flow_offload_action *fl_act,
 			      struct flow_action_entry *act);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
index a829c94289c1..fce1c0fd2453 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
@@ -95,10 +95,17 @@ tc_act_is_multi_table_act_ct(struct mlx5e_priv *priv,
 	return true;
 }
 
+static bool
+tc_act_is_missable_ct(const struct flow_action_entry *act)
+{
+	return !(act->ct.action & TCA_CT_ACT_CLEAR);
+}
+
 struct mlx5e_tc_act mlx5e_tc_act_ct = {
 	.can_offload = tc_act_can_offload_ct,
 	.parse_action = tc_act_parse_ct,
-	.is_multi_table_act = tc_act_is_multi_table_act_ct,
 	.post_parse = tc_act_post_parse_ct,
+	.is_multi_table_act = tc_act_is_multi_table_act_ct,
+	.is_missable = tc_act_is_missable_ct,
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index cafab7634fb8..32b50d685312 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4052,7 +4052,9 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 	enum mlx5_flow_namespace_type ns_type;
 	struct mlx5e_priv *priv = flow->priv;
 	struct flow_action_entry *act, **_act;
+	struct mlx5_flow_attr *prev_attr;
 	struct mlx5e_tc_act *tc_act;
+	bool is_missable;
 	int err, i;
 
 	flow_action_reorder.num_entries = flow_action->num_entries;
@@ -4069,6 +4071,9 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 	flow_action_for_each(i, _act, &flow_action_reorder) {
 		jump_state.jump_target = false;
 		act = *_act;
+		is_missable = false;
+		prev_attr = attr;
+
 		tc_act = mlx5e_tc_act_get(act->id, ns_type);
 		if (!tc_act) {
 			NL_SET_ERR_MSG_MOD(extack, "Not implemented offload action");
@@ -4092,14 +4097,14 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 			goto out_free;
 
 		parse_state->actions |= attr->action;
-		if (!tc_act->stats_action)
-			attr->tc_act_cookies[attr->tc_act_cookies_count++] = act->cookie;
 
 		/* Split attr for multi table act if not the last act. */
 		if (jump_state.jump_target ||
 		    (tc_act->is_multi_table_act &&
 		    tc_act->is_multi_table_act(priv, act, attr) &&
 		    i < flow_action_reorder.num_entries - 1)) {
+			is_missable = tc_act->is_missable ? tc_act->is_missable(act) : false;
+
 			err = mlx5e_tc_act_post_parse(parse_state, flow_action, attr, ns_type);
 			if (err)
 				goto out_free;
@@ -4112,6 +4117,16 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 
 			list_add(&attr->list, &flow->attrs);
 		}
+
+		if (is_missable) {
+			/* Add counter to prev, and assign act to new (next) attr */
+			prev_attr->action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
+			flow_flag_set(flow, USE_ACT_STATS);
+
+			attr->tc_act_cookies[attr->tc_act_cookies_count++] = act->cookie;
+		} else if (!tc_act->stats_action) {
+			prev_attr->tc_act_cookies[prev_attr->tc_act_cookies_count++] = act->cookie;
+		}
 	}
 
 	kfree(flow_action_reorder.entries);
-- 
2.39.2

