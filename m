Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3436448A53F
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346253AbiAKBoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:44:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39932 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346255AbiAKBny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:43:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8893CB81864
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 01:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4056C36AF9;
        Tue, 11 Jan 2022 01:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641865432;
        bh=0ZBoMlkEH7ooZkIfCk6BkfkMIHDMlTyCe1Yi0DzYSU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MpJGlzRPEn//r3yaSsKlHAn+SNBAYmhGJEJTz4uwk5H+1m6qhukzr6fVqs9Je9h56
         pFitNfgWLFQqfUV/lgY3Gqb9zL155u1ry5Gr2MVmoTqehlmrh1DwwqosWpkPF06BUc
         p+i/xThfPBxMsf+z/ljx3ek+FtRFqIkHhkPes+ATmyRbV+HfFryRXPBjqu08oaPphq
         0DCkBi1O6IfXnN+7f/rRz53mlCUD8HLA2T50ZkwN6iStjAYC6Pjznl5RaiRtF98sKU
         X4DS5sPrhEpq2IG4xIBitIseCbFD/fj6NR7D1k4vmDrghdvhGRjhvtieD5HPXO/U9x
         n2Na2tTSRi+SQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/17] net/mlx5e: Test CT and SAMPLE on flow attr
Date:   Mon, 10 Jan 2022 17:43:31 -0800
Message-Id: <20220111014335.178121-14-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111014335.178121-1-saeed@kernel.org>
References: <20220111014335.178121-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Currently the mlx5_flow object contains a single mlx5_attr instance.
However, multi table actions (e.g. CT) instantiate multiple attr instances.
Prepare for multiple attr instances by testing for CT or SAMPLE flag on attr
flags instead of flow flag.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/act/ct.c         |  1 +
 .../mellanox/mlx5/core/en/tc/act/sample.c     |  1 +
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  | 12 +++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 95 +++++++++++++------
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  1 +
 5 files changed, 79 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
index e8ff94933688..85f0cb88127f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
@@ -48,6 +48,7 @@ tc_act_parse_ct(struct mlx5e_tc_act_parse_state *parse_state,
 		attr->esw_attr->split_count = attr->esw_attr->out_count;
 
 	if (!clear_action) {
+		attr->flags |= MLX5_ATTR_FLAG_CT;
 		flow_flag_set(parse_state->flow, CT);
 		parse_state->ct = true;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
index 8f261204fdb4..539fea13ce9f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
@@ -36,6 +36,7 @@ tc_act_parse_sample(struct mlx5e_tc_act_parse_state *parse_state,
 	if (act->sample.truncate)
 		sample_attr->trunc_size = act->sample.trunc_size;
 
+	attr->flags |= MLX5_ATTR_FLAG_SAMPLE;
 	flow_flag_set(parse_state->flow, SAMPLE);
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index 375763f1561a..e13619133d53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -112,6 +112,17 @@ struct mlx5e_tc_flow {
 	struct mlx5_flow_attr *attr;
 };
 
+struct mlx5_flow_handle *
+mlx5e_tc_rule_offload(struct mlx5e_priv *priv,
+		      struct mlx5e_tc_flow *flow,
+		      struct mlx5_flow_spec *spec,
+		      struct mlx5_flow_attr *attr);
+
+void
+mlx5e_tc_rule_unoffload(struct mlx5e_priv *priv,
+			struct mlx5e_tc_flow *flow,
+			struct mlx5_flow_attr *attr);
+
 u8 mlx5e_tc_get_ip_version(struct mlx5_flow_spec *spec, bool outer);
 
 struct mlx5_flow_handle *
@@ -174,6 +185,7 @@ struct mlx5_flow_handle *
 mlx5e_tc_offload_to_slow_path(struct mlx5_eswitch *esw,
 			      struct mlx5e_tc_flow *flow,
 			      struct mlx5_flow_spec *spec);
+
 void mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
 				  struct mlx5e_tc_flow *flow,
 				  struct mlx5_flow_attr *attr);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index d37a5f752b1c..31fdc8192879 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -295,13 +295,65 @@ mlx5_tc_rule_delete(struct mlx5e_priv *priv,
 
 	if (is_mdev_switchdev_mode(priv->mdev)) {
 		mlx5_eswitch_del_offloaded_rule(esw, rule, attr);
-
 		return;
 	}
 
 	mlx5e_del_offloaded_nic_rule(priv, rule, attr);
 }
 
+struct mlx5_flow_handle *
+mlx5e_tc_rule_offload(struct mlx5e_priv *priv,
+		      struct mlx5e_tc_flow *flow,
+		      struct mlx5_flow_spec *spec,
+		      struct mlx5_flow_attr *attr)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	u32 tun_id = mlx5e_tc_get_flow_tun_id(flow);
+
+	if (attr->flags & MLX5_ATTR_FLAG_CT) {
+		struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts =
+			&attr->parse_attr->mod_hdr_acts;
+
+		return mlx5_tc_ct_flow_offload(get_ct_priv(priv), flow,
+					       spec, attr,
+					       mod_hdr_acts);
+	}
+
+	if (!is_mdev_switchdev_mode(priv->mdev))
+		return mlx5e_add_offloaded_nic_rule(priv, spec, attr);
+
+	if (attr->flags & MLX5_ATTR_FLAG_SAMPLE)
+		return mlx5e_tc_sample_offload(get_sample_priv(priv), spec, attr, tun_id);
+
+	return mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
+}
+
+void
+mlx5e_tc_rule_unoffload(struct mlx5e_priv *priv,
+			struct mlx5e_tc_flow *flow,
+			struct mlx5_flow_attr *attr)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5_flow_handle *rule = flow->rule[0];
+
+	if (attr->flags & MLX5_ATTR_FLAG_CT) {
+		mlx5_tc_ct_delete_flow(get_ct_priv(priv), flow, attr);
+		return;
+	}
+
+	if (!is_mdev_switchdev_mode(priv->mdev)) {
+		mlx5e_del_offloaded_nic_rule(priv, rule, attr);
+		return;
+	}
+
+	if (attr->flags & MLX5_ATTR_FLAG_SAMPLE) {
+		mlx5e_tc_sample_unoffload(get_sample_priv(priv), rule, attr);
+		return;
+	}
+
+	mlx5_eswitch_del_offloaded_rule(esw, rule, attr);
+}
+
 int
 mlx5e_tc_match_to_reg_set(struct mlx5_core_dev *mdev,
 			  struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts,
@@ -1084,7 +1136,7 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 			return err;
 	}
 
-	if (flow_flag_test(flow, CT))
+	if (attr->flags & MLX5_ATTR_FLAG_CT)
 		flow->rule[0] = mlx5_tc_ct_flow_offload(get_ct_priv(priv), flow, &parse_attr->spec,
 							attr, &parse_attr->mod_hdr_acts);
 	else
@@ -1119,7 +1171,7 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 
 	flow_flag_clear(flow, OFFLOADED);
 
-	if (flow_flag_test(flow, CT))
+	if (attr->flags & MLX5_ATTR_FLAG_CT)
 		mlx5_tc_ct_delete_flow(get_ct_priv(flow->priv), flow, attr);
 	else if (!IS_ERR_OR_NULL(flow->rule[0]))
 		mlx5e_del_offloaded_nic_rule(priv, flow->rule[0], attr);
@@ -1154,40 +1206,27 @@ mlx5e_tc_offload_fdb_rules(struct mlx5_eswitch *esw,
 			   struct mlx5_flow_spec *spec,
 			   struct mlx5_flow_attr *attr)
 {
-	struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts;
 	struct mlx5_flow_handle *rule;
 
 	if (attr->flags & MLX5_ATTR_FLAG_SLOW_PATH)
 		return mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
 
-	if (flow_flag_test(flow, CT)) {
-		mod_hdr_acts = &attr->parse_attr->mod_hdr_acts;
-
-		rule = mlx5_tc_ct_flow_offload(get_ct_priv(flow->priv),
-					       flow, spec, attr,
-					       mod_hdr_acts);
-	} else if (flow_flag_test(flow, SAMPLE)) {
-		rule = mlx5e_tc_sample_offload(get_sample_priv(flow->priv), spec, attr,
-					       mlx5e_tc_get_flow_tun_id(flow));
-	} else {
-		rule = mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
-	}
+	rule = mlx5e_tc_rule_offload(flow->priv, flow, spec, attr);
 
 	if (IS_ERR(rule))
 		return rule;
 
 	if (attr->esw_attr->split_count) {
 		flow->rule[1] = mlx5_eswitch_add_fwd_rule(esw, spec, attr);
-		if (IS_ERR(flow->rule[1])) {
-			if (flow_flag_test(flow, CT))
-				mlx5_tc_ct_delete_flow(get_ct_priv(flow->priv), flow, attr);
-			else
-				mlx5_eswitch_del_offloaded_rule(esw, rule, attr);
-			return flow->rule[1];
-		}
+		if (IS_ERR(flow->rule[1]))
+			goto err_rule1;
 	}
 
 	return rule;
+
+err_rule1:
+	mlx5e_tc_rule_unoffload(flow->priv, flow, attr);
+	return flow->rule[1];
 }
 
 void mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
@@ -1197,18 +1236,12 @@ void mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
 	flow_flag_clear(flow, OFFLOADED);
 
 	if (attr->flags & MLX5_ATTR_FLAG_SLOW_PATH)
-		goto offload_rule_0;
+		return mlx5_eswitch_del_offloaded_rule(esw, flow->rule[0], attr);
 
 	if (attr->esw_attr->split_count)
 		mlx5_eswitch_del_fwd_rule(esw, flow->rule[1], attr);
 
-	if (flow_flag_test(flow, CT))
-		mlx5_tc_ct_delete_flow(get_ct_priv(flow->priv), flow, attr);
-	else if (flow_flag_test(flow, SAMPLE))
-		mlx5e_tc_sample_unoffload(get_sample_priv(flow->priv), flow->rule[0], attr);
-	else
-offload_rule_0:
-		mlx5_eswitch_del_offloaded_rule(esw, flow->rule[0], attr);
+	mlx5e_tc_rule_unoffload(flow->priv, flow, attr);
 }
 
 struct mlx5_flow_handle *
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 277515916526..722702be7e91 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -96,6 +96,7 @@ enum {
 	MLX5_ATTR_FLAG_SRC_REWRITE   = BIT(3),
 	MLX5_ATTR_FLAG_SAMPLE        = BIT(4),
 	MLX5_ATTR_FLAG_ACCEPT        = BIT(5),
+	MLX5_ATTR_FLAG_CT            = BIT(6),
 };
 
 /* Returns true if any of the flags that require skipping further TC/NF processing are set. */
-- 
2.34.1

