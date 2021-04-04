Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F422A353677
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 06:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237014AbhDDEUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 00:20:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230405AbhDDEUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 00:20:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 293BF61383;
        Sun,  4 Apr 2021 04:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617510013;
        bh=pd0FTWLK2u6Ggv+yqy3kZ1ua+FRcHCai0zTayQGQKbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=luiKaY0PJNWBt9JV1OWRhZyHMOxK0xqTSL9e4msK7zxcFtsz5qHoeHh2ITgsgwwo1
         2F1cUL8o0PMHfZOWCQSAlpvmCYWG4TyK1MVIBV8+pBkbf4yIQZIuopmT3Viqn9Gul2
         NNw3oKbt9hZCJzZBbJmjRJRhXoHZgb6hRQhlll0L06KMbdNAZJmKvRVg7sWZ+2RV7i
         Zxi9OxuyG87Yj2aQsHFGSD2egSg77shaan1gvGBLNgAJ+WqFbOC0C+BL7dpRoD7d4L
         X0VkCTIegxSepH5GXadlcaPOE0k85ETCmdp4crn4olNSnSwF7z9BAKV46QVmEc1Due
         k9lbRKpzIYqOQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 16/16] net/mlx5e: Dynamic alloc vlan table for netdev when needed
Date:   Sat,  3 Apr 2021 21:19:54 -0700
Message-Id: <20210404041954.146958-17-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210404041954.146958-1-saeed@kernel.org>
References: <20210404041954.146958-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@nvidia.com>

Dynamic allocate vlan table in mlx5e_priv for EN netdev
when needed. Don't allocate it for representor netdev.

Signed-off-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  18 +--
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 132 +++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   4 +-
 4 files changed, 90 insertions(+), 67 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index cbfe31fb2b12..373bd89484cb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -49,18 +49,10 @@ struct mlx5e_promisc_table {
 	struct mlx5_flow_handle	*rule;
 };
 
-struct mlx5e_vlan_table {
-	struct mlx5e_flow_table		ft;
-	DECLARE_BITMAP(active_cvlans, VLAN_N_VID);
-	DECLARE_BITMAP(active_svlans, VLAN_N_VID);
-	struct mlx5_flow_handle	*active_cvlans_rule[VLAN_N_VID];
-	struct mlx5_flow_handle	*active_svlans_rule[VLAN_N_VID];
-	struct mlx5_flow_handle	*untagged_rule;
-	struct mlx5_flow_handle	*any_cvlan_rule;
-	struct mlx5_flow_handle	*any_svlan_rule;
-	struct mlx5_flow_handle	*trap_rule;
-	bool			cvlan_filter_disabled;
-};
+/* Forward declaration and APIs to get private fields of vlan_table */
+struct mlx5e_vlan_table;
+unsigned long *mlx5e_vlan_get_active_svlans(struct mlx5e_vlan_table *vlan);
+struct mlx5_flow_table *mlx5e_vlan_get_flowtable(struct mlx5e_vlan_table *vlan);
 
 struct mlx5e_l2_table {
 	struct mlx5e_flow_table    ft;
@@ -231,7 +223,7 @@ struct mlx5e_flow_steering {
 #endif
 	struct mlx5e_tc_table           tc;
 	struct mlx5e_promisc_table      promisc;
-	struct mlx5e_vlan_table         vlan;
+	struct mlx5e_vlan_table         *vlan;
 	struct mlx5e_l2_table           l2;
 	struct mlx5e_ttc_table          ttc;
 	struct mlx5e_ttc_table          inner_ttc;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 98f0b857947e..0d571a0c76d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -108,6 +108,29 @@ static void mlx5e_del_l2_from_hash(struct mlx5e_l2_hash_node *hn)
 	kfree(hn);
 }
 
+struct mlx5e_vlan_table {
+	struct mlx5e_flow_table		ft;
+	DECLARE_BITMAP(active_cvlans, VLAN_N_VID);
+	DECLARE_BITMAP(active_svlans, VLAN_N_VID);
+	struct mlx5_flow_handle	*active_cvlans_rule[VLAN_N_VID];
+	struct mlx5_flow_handle	*active_svlans_rule[VLAN_N_VID];
+	struct mlx5_flow_handle	*untagged_rule;
+	struct mlx5_flow_handle	*any_cvlan_rule;
+	struct mlx5_flow_handle	*any_svlan_rule;
+	struct mlx5_flow_handle	*trap_rule;
+	bool			cvlan_filter_disabled;
+};
+
+unsigned long *mlx5e_vlan_get_active_svlans(struct mlx5e_vlan_table *vlan)
+{
+	return vlan->active_svlans;
+}
+
+struct mlx5_flow_table *mlx5e_vlan_get_flowtable(struct mlx5e_vlan_table *vlan)
+{
+	return vlan->ft.t;
+}
+
 static int mlx5e_vport_context_update_vlans(struct mlx5e_priv *priv)
 {
 	struct net_device *ndev = priv->netdev;
@@ -119,7 +142,7 @@ static int mlx5e_vport_context_update_vlans(struct mlx5e_priv *priv)
 	int i;
 
 	list_size = 0;
-	for_each_set_bit(vlan, priv->fs.vlan.active_cvlans, VLAN_N_VID)
+	for_each_set_bit(vlan, priv->fs.vlan->active_cvlans, VLAN_N_VID)
 		list_size++;
 
 	max_list_size = 1 << MLX5_CAP_GEN(priv->mdev, log_max_vlan_list);
@@ -136,7 +159,7 @@ static int mlx5e_vport_context_update_vlans(struct mlx5e_priv *priv)
 		return -ENOMEM;
 
 	i = 0;
-	for_each_set_bit(vlan, priv->fs.vlan.active_cvlans, VLAN_N_VID) {
+	for_each_set_bit(vlan, priv->fs.vlan->active_cvlans, VLAN_N_VID) {
 		if (i >= list_size)
 			break;
 		vlans[i++] = vlan;
@@ -163,7 +186,7 @@ static int __mlx5e_add_vlan_rule(struct mlx5e_priv *priv,
 				 enum mlx5e_vlan_rule_type rule_type,
 				 u16 vid, struct mlx5_flow_spec *spec)
 {
-	struct mlx5_flow_table *ft = priv->fs.vlan.ft.t;
+	struct mlx5_flow_table *ft = priv->fs.vlan->ft.t;
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_handle **rule_p;
 	MLX5_DECLARE_FLOW_ACT(flow_act);
@@ -180,24 +203,24 @@ static int __mlx5e_add_vlan_rule(struct mlx5e_priv *priv,
 		 * disabled in match value means both S & C tags
 		 * don't exist (untagged of both)
 		 */
-		rule_p = &priv->fs.vlan.untagged_rule;
+		rule_p = &priv->fs.vlan->untagged_rule;
 		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
 				 outer_headers.cvlan_tag);
 		break;
 	case MLX5E_VLAN_RULE_TYPE_ANY_CTAG_VID:
-		rule_p = &priv->fs.vlan.any_cvlan_rule;
+		rule_p = &priv->fs.vlan->any_cvlan_rule;
 		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
 				 outer_headers.cvlan_tag);
 		MLX5_SET(fte_match_param, spec->match_value, outer_headers.cvlan_tag, 1);
 		break;
 	case MLX5E_VLAN_RULE_TYPE_ANY_STAG_VID:
-		rule_p = &priv->fs.vlan.any_svlan_rule;
+		rule_p = &priv->fs.vlan->any_svlan_rule;
 		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
 				 outer_headers.svlan_tag);
 		MLX5_SET(fte_match_param, spec->match_value, outer_headers.svlan_tag, 1);
 		break;
 	case MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID:
-		rule_p = &priv->fs.vlan.active_svlans_rule[vid];
+		rule_p = &priv->fs.vlan->active_svlans_rule[vid];
 		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
 				 outer_headers.svlan_tag);
 		MLX5_SET(fte_match_param, spec->match_value, outer_headers.svlan_tag, 1);
@@ -207,7 +230,7 @@ static int __mlx5e_add_vlan_rule(struct mlx5e_priv *priv,
 			 vid);
 		break;
 	default: /* MLX5E_VLAN_RULE_TYPE_MATCH_CTAG_VID */
-		rule_p = &priv->fs.vlan.active_cvlans_rule[vid];
+		rule_p = &priv->fs.vlan->active_cvlans_rule[vid];
 		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
 				 outer_headers.cvlan_tag);
 		MLX5_SET(fte_match_param, spec->match_value, outer_headers.cvlan_tag, 1);
@@ -257,33 +280,33 @@ static void mlx5e_del_vlan_rule(struct mlx5e_priv *priv,
 {
 	switch (rule_type) {
 	case MLX5E_VLAN_RULE_TYPE_UNTAGGED:
-		if (priv->fs.vlan.untagged_rule) {
-			mlx5_del_flow_rules(priv->fs.vlan.untagged_rule);
-			priv->fs.vlan.untagged_rule = NULL;
+		if (priv->fs.vlan->untagged_rule) {
+			mlx5_del_flow_rules(priv->fs.vlan->untagged_rule);
+			priv->fs.vlan->untagged_rule = NULL;
 		}
 		break;
 	case MLX5E_VLAN_RULE_TYPE_ANY_CTAG_VID:
-		if (priv->fs.vlan.any_cvlan_rule) {
-			mlx5_del_flow_rules(priv->fs.vlan.any_cvlan_rule);
-			priv->fs.vlan.any_cvlan_rule = NULL;
+		if (priv->fs.vlan->any_cvlan_rule) {
+			mlx5_del_flow_rules(priv->fs.vlan->any_cvlan_rule);
+			priv->fs.vlan->any_cvlan_rule = NULL;
 		}
 		break;
 	case MLX5E_VLAN_RULE_TYPE_ANY_STAG_VID:
-		if (priv->fs.vlan.any_svlan_rule) {
-			mlx5_del_flow_rules(priv->fs.vlan.any_svlan_rule);
-			priv->fs.vlan.any_svlan_rule = NULL;
+		if (priv->fs.vlan->any_svlan_rule) {
+			mlx5_del_flow_rules(priv->fs.vlan->any_svlan_rule);
+			priv->fs.vlan->any_svlan_rule = NULL;
 		}
 		break;
 	case MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID:
-		if (priv->fs.vlan.active_svlans_rule[vid]) {
-			mlx5_del_flow_rules(priv->fs.vlan.active_svlans_rule[vid]);
-			priv->fs.vlan.active_svlans_rule[vid] = NULL;
+		if (priv->fs.vlan->active_svlans_rule[vid]) {
+			mlx5_del_flow_rules(priv->fs.vlan->active_svlans_rule[vid]);
+			priv->fs.vlan->active_svlans_rule[vid] = NULL;
 		}
 		break;
 	case MLX5E_VLAN_RULE_TYPE_MATCH_CTAG_VID:
-		if (priv->fs.vlan.active_cvlans_rule[vid]) {
-			mlx5_del_flow_rules(priv->fs.vlan.active_cvlans_rule[vid]);
-			priv->fs.vlan.active_cvlans_rule[vid] = NULL;
+		if (priv->fs.vlan->active_cvlans_rule[vid]) {
+			mlx5_del_flow_rules(priv->fs.vlan->active_cvlans_rule[vid]);
+			priv->fs.vlan->active_cvlans_rule[vid] = NULL;
 		}
 		mlx5e_vport_context_update_vlans(priv);
 		break;
@@ -330,27 +353,27 @@ mlx5e_add_trap_rule(struct mlx5_flow_table *ft, int trap_id, int tir_num)
 
 int mlx5e_add_vlan_trap(struct mlx5e_priv *priv, int trap_id, int tir_num)
 {
-	struct mlx5_flow_table *ft = priv->fs.vlan.ft.t;
+	struct mlx5_flow_table *ft = priv->fs.vlan->ft.t;
 	struct mlx5_flow_handle *rule;
 	int err;
 
 	rule = mlx5e_add_trap_rule(ft, trap_id, tir_num);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
-		priv->fs.vlan.trap_rule = NULL;
+		priv->fs.vlan->trap_rule = NULL;
 		netdev_err(priv->netdev, "%s: add VLAN trap rule failed, err %d\n",
 			   __func__, err);
 		return err;
 	}
-	priv->fs.vlan.trap_rule = rule;
+	priv->fs.vlan->trap_rule = rule;
 	return 0;
 }
 
 void mlx5e_remove_vlan_trap(struct mlx5e_priv *priv)
 {
-	if (priv->fs.vlan.trap_rule) {
-		mlx5_del_flow_rules(priv->fs.vlan.trap_rule);
-		priv->fs.vlan.trap_rule = NULL;
+	if (priv->fs.vlan->trap_rule) {
+		mlx5_del_flow_rules(priv->fs.vlan->trap_rule);
+		priv->fs.vlan->trap_rule = NULL;
 	}
 }
 
@@ -382,10 +405,10 @@ void mlx5e_remove_mac_trap(struct mlx5e_priv *priv)
 
 void mlx5e_enable_cvlan_filter(struct mlx5e_priv *priv)
 {
-	if (!priv->fs.vlan.cvlan_filter_disabled)
+	if (!priv->fs.vlan->cvlan_filter_disabled)
 		return;
 
-	priv->fs.vlan.cvlan_filter_disabled = false;
+	priv->fs.vlan->cvlan_filter_disabled = false;
 	if (priv->netdev->flags & IFF_PROMISC)
 		return;
 	mlx5e_del_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_ANY_CTAG_VID, 0);
@@ -393,10 +416,10 @@ void mlx5e_enable_cvlan_filter(struct mlx5e_priv *priv)
 
 void mlx5e_disable_cvlan_filter(struct mlx5e_priv *priv)
 {
-	if (priv->fs.vlan.cvlan_filter_disabled)
+	if (priv->fs.vlan->cvlan_filter_disabled)
 		return;
 
-	priv->fs.vlan.cvlan_filter_disabled = true;
+	priv->fs.vlan->cvlan_filter_disabled = true;
 	if (priv->netdev->flags & IFF_PROMISC)
 		return;
 	mlx5e_add_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_ANY_CTAG_VID, 0);
@@ -406,11 +429,11 @@ static int mlx5e_vlan_rx_add_cvid(struct mlx5e_priv *priv, u16 vid)
 {
 	int err;
 
-	set_bit(vid, priv->fs.vlan.active_cvlans);
+	set_bit(vid, priv->fs.vlan->active_cvlans);
 
 	err = mlx5e_add_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_MATCH_CTAG_VID, vid);
 	if (err)
-		clear_bit(vid, priv->fs.vlan.active_cvlans);
+		clear_bit(vid, priv->fs.vlan->active_cvlans);
 
 	return err;
 }
@@ -420,11 +443,11 @@ static int mlx5e_vlan_rx_add_svid(struct mlx5e_priv *priv, u16 vid)
 	struct net_device *netdev = priv->netdev;
 	int err;
 
-	set_bit(vid, priv->fs.vlan.active_svlans);
+	set_bit(vid, priv->fs.vlan->active_svlans);
 
 	err = mlx5e_add_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID, vid);
 	if (err) {
-		clear_bit(vid, priv->fs.vlan.active_svlans);
+		clear_bit(vid, priv->fs.vlan->active_svlans);
 		return err;
 	}
 
@@ -456,10 +479,10 @@ int mlx5e_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid)
 		return 0; /* no vlan table for uplink rep */
 
 	if (be16_to_cpu(proto) == ETH_P_8021Q) {
-		clear_bit(vid, priv->fs.vlan.active_cvlans);
+		clear_bit(vid, priv->fs.vlan->active_cvlans);
 		mlx5e_del_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_MATCH_CTAG_VID, vid);
 	} else if (be16_to_cpu(proto) == ETH_P_8021AD) {
-		clear_bit(vid, priv->fs.vlan.active_svlans);
+		clear_bit(vid, priv->fs.vlan->active_svlans);
 		mlx5e_del_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID, vid);
 		netdev_update_features(dev);
 	}
@@ -473,14 +496,14 @@ static void mlx5e_add_vlan_rules(struct mlx5e_priv *priv)
 
 	mlx5e_add_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_UNTAGGED, 0);
 
-	for_each_set_bit(i, priv->fs.vlan.active_cvlans, VLAN_N_VID) {
+	for_each_set_bit(i, priv->fs.vlan->active_cvlans, VLAN_N_VID) {
 		mlx5e_add_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_MATCH_CTAG_VID, i);
 	}
 
-	for_each_set_bit(i, priv->fs.vlan.active_svlans, VLAN_N_VID)
+	for_each_set_bit(i, priv->fs.vlan->active_svlans, VLAN_N_VID)
 		mlx5e_add_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID, i);
 
-	if (priv->fs.vlan.cvlan_filter_disabled)
+	if (priv->fs.vlan->cvlan_filter_disabled)
 		mlx5e_add_any_vid_rules(priv);
 }
 
@@ -490,11 +513,11 @@ static void mlx5e_del_vlan_rules(struct mlx5e_priv *priv)
 
 	mlx5e_del_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_UNTAGGED, 0);
 
-	for_each_set_bit(i, priv->fs.vlan.active_cvlans, VLAN_N_VID) {
+	for_each_set_bit(i, priv->fs.vlan->active_cvlans, VLAN_N_VID) {
 		mlx5e_del_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_MATCH_CTAG_VID, i);
 	}
 
-	for_each_set_bit(i, priv->fs.vlan.active_svlans, VLAN_N_VID)
+	for_each_set_bit(i, priv->fs.vlan->active_svlans, VLAN_N_VID)
 		mlx5e_del_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID, i);
 
 	WARN_ON_ONCE(!(test_bit(MLX5E_STATE_DESTROYING, &priv->state)));
@@ -504,7 +527,7 @@ static void mlx5e_del_vlan_rules(struct mlx5e_priv *priv)
 	/* must be called after DESTROY bit is set and
 	 * set_rx_mode is called and flushed
 	 */
-	if (priv->fs.vlan.cvlan_filter_disabled)
+	if (priv->fs.vlan->cvlan_filter_disabled)
 		mlx5e_del_any_vid_rules(priv);
 }
 
@@ -1692,10 +1715,15 @@ static int mlx5e_create_vlan_table_groups(struct mlx5e_flow_table *ft)
 
 static int mlx5e_create_vlan_table(struct mlx5e_priv *priv)
 {
-	struct mlx5e_flow_table *ft = &priv->fs.vlan.ft;
 	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5e_flow_table *ft;
 	int err;
 
+	priv->fs.vlan = kvzalloc(sizeof(*priv->fs.vlan), GFP_KERNEL);
+	if (!priv->fs.vlan)
+		return -ENOMEM;
+
+	ft = &priv->fs.vlan->ft;
 	ft->num_groups = 0;
 
 	ft_attr.max_fte = MLX5E_VLAN_TABLE_SIZE;
@@ -1703,12 +1731,11 @@ static int mlx5e_create_vlan_table(struct mlx5e_priv *priv)
 	ft_attr.prio = MLX5E_NIC_PRIO;
 
 	ft->t = mlx5_create_flow_table(priv->fs.ns, &ft_attr);
-
 	if (IS_ERR(ft->t)) {
 		err = PTR_ERR(ft->t);
-		ft->t = NULL;
-		return err;
+		goto err_free_t;
 	}
+
 	ft->g = kcalloc(MLX5E_NUM_VLAN_GROUPS, sizeof(*ft->g), GFP_KERNEL);
 	if (!ft->g) {
 		err = -ENOMEM;
@@ -1727,7 +1754,9 @@ static int mlx5e_create_vlan_table(struct mlx5e_priv *priv)
 	kfree(ft->g);
 err_destroy_vlan_table:
 	mlx5_destroy_flow_table(ft->t);
-	ft->t = NULL;
+err_free_t:
+	kvfree(priv->fs.vlan);
+	priv->fs.vlan = NULL;
 
 	return err;
 }
@@ -1735,7 +1764,8 @@ static int mlx5e_create_vlan_table(struct mlx5e_priv *priv)
 static void mlx5e_destroy_vlan_table(struct mlx5e_priv *priv)
 {
 	mlx5e_del_vlan_rules(priv);
-	mlx5e_destroy_flow_table(&priv->fs.vlan.ft);
+	mlx5e_destroy_flow_table(&priv->fs.vlan->ft);
+	kvfree(priv->fs.vlan);
 }
 
 int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index db2942b61fd5..773449c1424b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3823,7 +3823,8 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 
 	mutex_lock(&priv->state_lock);
 	params = &priv->channels.params;
-	if (!bitmap_empty(priv->fs.vlan.active_svlans, VLAN_N_VID)) {
+	if (!priv->fs.vlan ||
+	    !bitmap_empty(mlx5e_vlan_get_active_svlans(priv->fs.vlan), VLAN_N_VID)) {
 		/* HW strips the outer C-tag header, this is a problem
 		 * for S-tag traffic.
 		 */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a4a4cdecbdea..bb1e0d442b5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -906,7 +906,7 @@ mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
 			if (IS_ERR(dest[dest_ix].ft))
 				return ERR_CAST(dest[dest_ix].ft);
 		} else {
-			dest[dest_ix].ft = priv->fs.vlan.ft.t;
+			dest[dest_ix].ft = mlx5e_vlan_get_flowtable(priv->fs.vlan);
 		}
 		dest_ix++;
 	}
@@ -4753,7 +4753,7 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	attr.ns = MLX5_FLOW_NAMESPACE_KERNEL;
 	attr.max_ft_sz = mlx5e_tc_nic_get_ft_size(dev);
 	attr.max_grp_num = MLX5E_TC_TABLE_NUM_GROUPS;
-	attr.default_ft = priv->fs.vlan.ft.t;
+	attr.default_ft = mlx5e_vlan_get_flowtable(priv->fs.vlan);
 
 	tc->chains = mlx5_chains_create(dev, &attr);
 	if (IS_ERR(tc->chains)) {
-- 
2.30.2

