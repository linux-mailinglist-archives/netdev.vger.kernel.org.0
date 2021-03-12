Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96DB339A11
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 00:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235896AbhCLXja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 18:39:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:32842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235826AbhCLXjB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 18:39:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94F6964F89;
        Fri, 12 Mar 2021 23:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615592340;
        bh=eu4j/xXHVScm2qElUVqxDINeoVNSl+rSIuym8P4gWto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A8FBWROgni1/kVroUrU3LNaauKIfUzmlcigofxiLUDzmgjsqwSoE1h6EgB6AQjed4
         8tF4hyt+wK0ZbaCHC3wPaDDT2P9ihN6L4TLtbuLIGH52q55/40fOkLycw6QhrugYdL
         bdR4XfuhtpEyMsRd9U4FnxwQnavedSrYl3fzq3MDlQL8+hHdLzFz/F+qp2AC0x4P2r
         d4+moXJCKW4IGllL42Ns2uQzXWZFgOCgkHZV5z1T9ZwcvG3xJ28SxUqZQ1niqNin1H
         5EQ9W+EJToxhSlTWJH8JeW7YimDCcJoTUy55IIerC5aGhmd4v2qbbcGIou7OqhBt9q
         aj/L0EkJRy05Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/13] net/mlx5: CT: Add support for mirroring
Date:   Fri, 12 Mar 2021 15:38:50 -0800
Message-Id: <20210312233851.494832-13-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312233851.494832-1-saeed@kernel.org>
References: <20210312233851.494832-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Add support for mirroring before the CT action by spliting the pre ct rule.
Mirror outputs are done first on the tc chain,prio table rule (the fwd
rule), which will then forward to a per port fwd table.
On this fwd table, we insert the original pre ct rule that forwards to
ct/ct nat table.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  4 ++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 19 ++++++++++---------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 3a6095c912f1..5e3d31b888ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1797,6 +1797,10 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 	ct_flow->post_ct_attr->prio = 0;
 	ct_flow->post_ct_attr->ft = ct_priv->post_ct;
 
+	/* Splits were handled before CT */
+	if (ct_priv->ns_type == MLX5_FLOW_NAMESPACE_FDB)
+		ct_flow->post_ct_attr->esw_attr->split_count = 0;
+
 	ct_flow->post_ct_attr->inner_match_level = MLX5_MATCH_NONE;
 	ct_flow->post_ct_attr->outer_match_level = MLX5_MATCH_NONE;
 	ct_flow->post_ct_attr->action &= ~(MLX5_FLOW_CONTEXT_ACTION_DECAP);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index c72725c3f53b..121f0a744e55 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1087,19 +1087,23 @@ mlx5e_tc_offload_fdb_rules(struct mlx5_eswitch *esw,
 	if (flow_flag_test(flow, CT)) {
 		mod_hdr_acts = &attr->parse_attr->mod_hdr_acts;
 
-		return mlx5_tc_ct_flow_offload(get_ct_priv(flow->priv),
+		rule = mlx5_tc_ct_flow_offload(get_ct_priv(flow->priv),
 					       flow, spec, attr,
 					       mod_hdr_acts);
+	} else {
+		rule = mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
 	}
 
-	rule = mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
 	if (IS_ERR(rule))
 		return rule;
 
 	if (attr->esw_attr->split_count) {
 		flow->rule[1] = mlx5_eswitch_add_fwd_rule(esw, spec, attr);
 		if (IS_ERR(flow->rule[1])) {
-			mlx5_eswitch_del_offloaded_rule(esw, rule, attr);
+			if (flow_flag_test(flow, CT))
+				mlx5_tc_ct_delete_flow(get_ct_priv(flow->priv), flow, attr);
+			else
+				mlx5_eswitch_del_offloaded_rule(esw, rule, attr);
 			return flow->rule[1];
 		}
 	}
@@ -2989,7 +2993,8 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 	actions = flow->attr->action;
 
 	if (mlx5e_is_eswitch_flow(flow)) {
-		if (flow->attr->esw_attr->split_count && ct_flow) {
+		if (flow->attr->esw_attr->split_count && ct_flow &&
+		    !MLX5_CAP_GEN(flow->attr->esw_attr->in_mdev, reg_c_preserve)) {
 			/* All registers used by ct are cleared when using
 			 * split rules.
 			 */
@@ -3789,6 +3794,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				return err;
 
 			flow_flag_set(flow, CT);
+			esw_attr->split_count = esw_attr->out_count;
 			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "The offload action is not supported");
@@ -3851,11 +3857,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			return -EOPNOTSUPP;
 		}
 
-		if (attr->action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Mirroring goto chain rules isn't supported");
-			return -EOPNOTSUPP;
-		}
 		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	}
 
-- 
2.29.2

