Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74DCD48A53B
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239060AbiAKBn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346240AbiAKBnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:43:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78FAC061756
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 17:43:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 557DC6149C
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 01:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9933C36AE5;
        Tue, 11 Jan 2022 01:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641865431;
        bh=SyAU5DKv15EKgibJSwJ/UdQqFFEDuDDpCzB/Dlibfhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BM2UXJtFaZs4jxDKc5XF2+rWZJ3peGk9o7JecCxJdG6ppoMSp81IiJbhH9mCC0ctO
         8kadcsugRq5pkeyFiyY8Fm6ebEk/D4HJgyu7RD0daJK6BFXcsRzpwLHjvViC+O9J0L
         wUdMGFtMhRcMBIrcV+uKYw0i079qXulf9/CcJfzEsg0vFT6WHHNNV1KqA5N5JxPHBh
         92kTEaC/MsDY64lNojEpK/j2ohJ30MM1X4wV/rgsygawTnRgFUCVT5q78ZgeBtlaB4
         HWpfgI79Kp6hT92mHmUv3+Qq8OwnZL2VshkOMUO9/JWCukzJQMlXzCCFqjLpysrRiG
         QlohQMV+hm3Jw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/17] net/mlx5e: CT, Don't set flow flag CT for ct clear flow
Date:   Mon, 10 Jan 2022 17:43:29 -0800
Message-Id: <20220111014335.178121-12-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111014335.178121-1-saeed@kernel.org>
References: <20220111014335.178121-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

ct clear action is a normal flow with a modify header for registers to
0. there is no need for any special handling in tc_ct.c.
Parsing of ct clear action still allocates mod acts to set 0 on the
registers and the driver continue to add a normal rule with modify hdr
context.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/act/ct.c         |  5 +-
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 72 +------------------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  3 +-
 3 files changed, 6 insertions(+), 74 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
index 4a04e0a7a52e..e8ff94933688 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
@@ -43,13 +43,14 @@ tc_act_parse_ct(struct mlx5e_tc_act_parse_state *parse_state,
 	if (err)
 		return err;
 
-	flow_flag_set(parse_state->flow, CT);
 
 	if (mlx5e_is_eswitch_flow(parse_state->flow))
 		attr->esw_attr->split_count = attr->esw_attr->out_count;
 
-	if (!clear_action)
+	if (!clear_action) {
+		flow_flag_set(parse_state->flow, CT);
 		parse_state->ct = true;
+	}
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 4a0d38d219ed..090e02548a75 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1926,68 +1926,6 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 	return ERR_PTR(err);
 }
 
-static struct mlx5_flow_handle *
-__mlx5_tc_ct_flow_offload_clear(struct mlx5_tc_ct_priv *ct_priv,
-				struct mlx5_flow_spec *orig_spec,
-				struct mlx5_flow_attr *attr,
-				struct mlx5e_tc_mod_hdr_acts *mod_acts)
-{
-	struct mlx5e_priv *priv = netdev_priv(ct_priv->netdev);
-	u32 attr_sz = ns_to_attr_sz(ct_priv->ns_type);
-	struct mlx5_flow_attr *pre_ct_attr;
-	struct mlx5_modify_hdr *mod_hdr;
-	struct mlx5_flow_handle *rule;
-	struct mlx5_ct_flow *ct_flow;
-	int err;
-
-	ct_flow = kzalloc(sizeof(*ct_flow), GFP_KERNEL);
-	if (!ct_flow)
-		return ERR_PTR(-ENOMEM);
-
-	/* Base esw attributes on original rule attribute */
-	pre_ct_attr = mlx5_alloc_flow_attr(ct_priv->ns_type);
-	if (!pre_ct_attr) {
-		err = -ENOMEM;
-		goto err_attr;
-	}
-
-	memcpy(pre_ct_attr, attr, attr_sz);
-
-	mod_hdr = mlx5_modify_header_alloc(priv->mdev, ct_priv->ns_type,
-					   mod_acts->num_actions,
-					   mod_acts->actions);
-	if (IS_ERR(mod_hdr)) {
-		err = PTR_ERR(mod_hdr);
-		ct_dbg("Failed to add create ct clear mod hdr");
-		goto err_mod_hdr;
-	}
-
-	pre_ct_attr->modify_hdr = mod_hdr;
-
-	rule = mlx5_tc_rule_insert(priv, orig_spec, pre_ct_attr);
-	if (IS_ERR(rule)) {
-		err = PTR_ERR(rule);
-		ct_dbg("Failed to add ct clear rule");
-		goto err_insert;
-	}
-
-	attr->ct_attr.ct_flow = ct_flow;
-	ct_flow->pre_ct_attr = pre_ct_attr;
-	ct_flow->pre_ct_rule = rule;
-	return rule;
-
-err_insert:
-	mlx5_modify_header_dealloc(priv->mdev, mod_hdr);
-err_mod_hdr:
-	netdev_warn(priv->netdev,
-		    "Failed to offload ct clear flow, err %d\n", err);
-	kfree(pre_ct_attr);
-err_attr:
-	kfree(ct_flow);
-
-	return ERR_PTR(err);
-}
-
 struct mlx5_flow_handle *
 mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *priv,
 			struct mlx5e_tc_flow *flow,
@@ -1995,18 +1933,13 @@ mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *priv,
 			struct mlx5_flow_attr *attr,
 			struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts)
 {
-	bool clear_action = attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR;
 	struct mlx5_flow_handle *rule;
 
 	if (!priv)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	mutex_lock(&priv->control_lock);
-
-	if (clear_action)
-		rule = __mlx5_tc_ct_flow_offload_clear(priv, spec, attr, mod_hdr_acts);
-	else
-		rule = __mlx5_tc_ct_flow_offload(priv, flow, spec, attr);
+	rule = __mlx5_tc_ct_flow_offload(priv, flow, spec, attr);
 	mutex_unlock(&priv->control_lock);
 
 	return rule;
@@ -2020,8 +1953,7 @@ __mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *ct_priv,
 	struct mlx5_flow_attr *pre_ct_attr = ct_flow->pre_ct_attr;
 	struct mlx5e_priv *priv = netdev_priv(ct_priv->netdev);
 
-	mlx5_tc_rule_delete(priv, ct_flow->pre_ct_rule,
-			    pre_ct_attr);
+	mlx5_tc_rule_delete(priv, ct_flow->pre_ct_rule, pre_ct_attr);
 	mlx5_modify_header_dealloc(priv->mdev, pre_ct_attr->modify_hdr);
 
 	if (ct_flow->post_act_handle) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index e3195f6e67c7..a1007af89ddc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1574,8 +1574,7 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	if (err)
 		goto err_out;
 
-	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
-	    !(attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR)) {
+	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
 		if (vf_tun) {
 			err = mlx5e_tc_add_flow_mod_hdr(priv, flow, attr);
 			if (err)
-- 
2.34.1

