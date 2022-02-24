Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84ADA4C30F3
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 17:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbiBXQJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 11:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiBXQJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 11:09:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C656718886B;
        Thu, 24 Feb 2022 08:08:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22192616A0;
        Thu, 24 Feb 2022 16:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF009C340E9;
        Thu, 24 Feb 2022 16:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645718820;
        bh=kJbsQ1SyKQBcOIF90Cd1CS9YzTGxK6ab/SLif+LghU8=;
        h=From:To:Cc:Subject:Date:From;
        b=T9i/B7IRZEAXJ/7wh6925nd6jnClctyy/1vPiIO23Oose0eEdyjSEauAwZRk/ETkQ
         FoGh+Vfrscfs7Fk4DqAsLLSxtnVdnLv0Zo7Rq2R1PZGKVVKxcLUeV037TNDv9RXJK8
         MVZtl3XeslsOUcPFY8uEbA06OD2c6rE8txj4iXXLUi5i9vpzreq/lwgYUhcgQNK0Pq
         Qqn23dL1pGaRKqCMtLlpdEhr507X/JEvc2RwMr6pnbENNK55hjZ11NhSAPwHH0OH9k
         Z2xQN+vA+wQTjaoF7HhXxFijeWzotPrHb+lc3ZBcrWQcdmmLmWxt/i3VXBbSFKKlZC
         LM9tHRR9QXQ6A==
From:   broonie@kernel.org
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Date:   Thu, 24 Feb 2022 16:06:54 +0000
Message-Id: <20220224160654.3751264-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Today's linux-next merge of the net-next tree got conflicts in:

  drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
  drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c

between commits:

  fb7e76ea3f3b6 ("net/mlx5e: TC, Skip redundant ct clear actions")
  c63741b426e11 ("net/mlx5e: Fix MPLSoUDP encap to use MPLS action information")

from the net tree and commits:

  09bf97923224f ("net/mlx5e: TC, Move pedit_headers_action to parse_attr")
  09bf97923224f ("net/mlx5e: TC, Move pedit_headers_action to parse_attr")
  3b49a7edec1df ("net/mlx5e: TC, Reject rules with multiple CT actions")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index 9cc844bd00f59..9f6a3b7620321 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -17,13 +17,14 @@ struct mlx5e_tc_act_parse_state {
 	struct mlx5e_tc_flow *flow;
 	struct netlink_ext_ack *extack;
 	bool ct_clear;
+	u32 actions;
+	bool ct;
 	bool encap;
 	bool decap;
 	bool mpls_push;
 	bool ptype_host;
 	const struct ip_tunnel_info *tun_info;
 	struct mlx5e_mpls_info mpls_info;
-	struct pedit_headers_action hdrs[__PEDIT_CMD_MAX];
 	int ifindexes[MLX5_MAX_FLOW_FWD_VPORTS];
 	int if_count;
 	struct mlx5_tc_ct_priv *ct_priv;
@@ -32,7 +33,8 @@ struct mlx5e_tc_act_parse_state {
 struct mlx5e_tc_act {
 	bool (*can_offload)(struct mlx5e_tc_act_parse_state *parse_state,
 			    const struct flow_action_entry *act,
-			    int act_index);
+			    int act_index,
+			    struct mlx5_flow_attr *attr);
 
 	int (*parse_action)(struct mlx5e_tc_act_parse_state *parse_state,
 			    const struct flow_action_entry *act,
@@ -42,6 +44,15 @@ struct mlx5e_tc_act {
 	int (*post_parse)(struct mlx5e_tc_act_parse_state *parse_state,
 			  struct mlx5e_priv *priv,
 			  struct mlx5_flow_attr *attr);
+
+	bool (*is_multi_table_act)(struct mlx5e_priv *priv,
+				   const struct flow_action_entry *act,
+				   struct mlx5_flow_attr *attr);
+};
+
+struct mlx5e_tc_flow_action {
+	unsigned int num_entries;
+	struct flow_action_entry **entries;
 };
 
 extern struct mlx5e_tc_act mlx5e_tc_act_drop;
@@ -74,4 +85,19 @@ mlx5e_tc_act_init_parse_state(struct mlx5e_tc_act_parse_state *parse_state,
 			      struct flow_action *flow_action,
 			      struct netlink_ext_ack *extack);
 
+void
+mlx5e_tc_act_reorder_flow_actions(struct flow_action *flow_action,
+				  struct mlx5e_tc_flow_action *flow_action_reorder);
+
+int
+mlx5e_tc_act_post_parse(struct mlx5e_tc_act_parse_state *parse_state,
+			struct flow_action *flow_action,
+			struct mlx5_flow_attr *attr,
+			enum mlx5_flow_namespace_type ns_type);
+
+int
+mlx5e_tc_act_set_next_post_act(struct mlx5e_tc_flow *flow,
+			       struct mlx5_flow_attr *attr,
+			       struct mlx5_flow_attr *next_attr);
+
 #endif /* __MLX5_EN_TC_ACT_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
index 58cc33f1363d2..6e63d898d3d53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
@@ -8,13 +8,14 @@
 static bool
 tc_act_can_offload_ct(struct mlx5e_tc_act_parse_state *parse_state,
 		      const struct flow_action_entry *act,
-		      int act_index)
+		      int act_index,
+		      struct mlx5_flow_attr *attr)
 {
+	bool clear_action = act->ct.action & TCA_CT_ACT_CLEAR;
 	struct netlink_ext_ack *extack = parse_state->extack;
 
-	if (flow_flag_test(parse_state->flow, SAMPLE)) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Sample action with connection tracking is not supported");
+	if (parse_state->ct && !clear_action) {
+		NL_SET_ERR_MSG_MOD(extack, "Multiple CT actions are not supported");
 		return false;
 	}
 
@@ -40,18 +41,34 @@ tc_act_parse_ct(struct mlx5e_tc_act_parse_state *parse_state,
 	if (err)
 		return err;
 
-	flow_flag_set(parse_state->flow, CT);
 
 	if (mlx5e_is_eswitch_flow(parse_state->flow))
 		attr->esw_attr->split_count = attr->esw_attr->out_count;
 
 	parse_state->ct_clear = clear_action;
+	if (!clear_action) {
+		attr->flags |= MLX5_ATTR_FLAG_CT;
+		flow_flag_set(parse_state->flow, CT);
+		parse_state->ct = true;
+	}
 
 	return 0;
 }
 
+static bool
+tc_act_is_multi_table_act_ct(struct mlx5e_priv *priv,
+			     const struct flow_action_entry *act,
+			     struct mlx5_flow_attr *attr)
+{
+	if (act->ct.action & TCA_CT_ACT_CLEAR)
+		return false;
+
+	return true;
+}
+
 struct mlx5e_tc_act mlx5e_tc_act_ct = {
 	.can_offload = tc_act_can_offload_ct,
 	.parse_action = tc_act_parse_ct,
+	.is_multi_table_act = tc_act_is_multi_table_act_ct,
 };
 
