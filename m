Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C494F2EED14
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 06:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbhAHFc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 00:32:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:35868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727630AbhAHFcS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 00:32:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDEB22368A;
        Fri,  8 Jan 2021 05:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610083861;
        bh=BWVnnNUhdzTuf2XjWmoXkpTWbTWBLQvs5rjTLjsPJEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ndrbxJ+JK58uVO7014rfAnVWjatNCptCU1I1l2N5OYjHE8HX/iBpxqkwcKQwrRGyl
         08Njw1BGJ+FfiF3SyGLqo4R4SRpTZ9Eo4R1OThNu+cngJHVt6WYs3lIVAtMXFM/ufd
         8rJIvDg1eo1PDIW6WLuqqDLZi5Z5Ss7xJYcaXyGKCFxMYdiT/J8LOutEMlQqGWu+ng
         1WIl72GiGEsUlEVj1n4qH6KI5otJDfGmdZzCWZfc6x1wV7frr5USwk39N/A+8QpXzO
         rq8iA7WxOzsOQKt4oL5O0dl7WYOKpOMsqT9SAQgsfLfvfqNq8X4VKF/T8/xlHJRzlv
         eoCMlYoRxesfw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/15] net/mlx5e: CT: Add support for mirroring
Date:   Thu,  7 Jan 2021 21:30:49 -0800
Message-Id: <20210108053054.660499-11-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210108053054.660499-1-saeed@kernel.org>
References: <20210108053054.660499-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Add support for mirroring before the CT action by splitting the pre ct rule.
Mirror outputs are done first on the tc chain,prio table rule (the fwd
rule), which will then forward to a per port fwd table.
On this fwd table, we insert the original pre ct rule that forwards to
ct/ct nat table.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  4 +++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 25 ++++++++++---------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index b0c357f755d4..9a189c06ab56 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1825,6 +1825,10 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
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
index 5cf7c221404b..89bb464850a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1165,19 +1165,23 @@ mlx5e_tc_offload_fdb_rules(struct mlx5_eswitch *esw,
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
@@ -1192,14 +1196,14 @@ mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
 {
 	flow_flag_clear(flow, OFFLOADED);
 
+	if (attr->esw_attr->split_count)
+		mlx5_eswitch_del_fwd_rule(esw, flow->rule[1], attr);
+
 	if (flow_flag_test(flow, CT)) {
 		mlx5_tc_ct_delete_flow(get_ct_priv(flow->priv), flow, attr);
 		return;
 	}
 
-	if (attr->esw_attr->split_count)
-		mlx5_eswitch_del_fwd_rule(esw, flow->rule[1], attr);
-
 	mlx5_eswitch_del_offloaded_rule(esw, flow->rule[0], attr);
 }
 
@@ -3264,7 +3268,8 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 	actions = flow->attr->action;
 
 	if (mlx5e_is_eswitch_flow(flow)) {
-		if (flow->attr->esw_attr->split_count && ct_flow) {
+		if (flow->attr->esw_attr->split_count && ct_flow &&
+		    !MLX5_CAP_GEN(flow->attr->esw_attr->in_mdev, reg_c_preserve)) {
 			/* All registers used by ct are cleared when using
 			 * split rules.
 			 */
@@ -4373,6 +4378,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				return err;
 
 			flow_flag_set(flow, CT);
+			esw_attr->split_count = esw_attr->out_count;
 			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "The offload action is not supported");
@@ -4432,11 +4438,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
2.26.2

