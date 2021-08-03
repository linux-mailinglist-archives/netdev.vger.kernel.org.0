Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664733DE460
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 04:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbhHCC3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 22:29:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233685AbhHCC3M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 22:29:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07B1361078;
        Tue,  3 Aug 2021 02:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627957742;
        bh=mFY3r0jEbkX1BZL8tHBmNVdswQtSigmjJS07GTK77Jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hx1HBnAaX9OltoTvrT1bPnRs4ENJ1HBrWOQOgF4k7MWAFofE3TaUP1xwStOUxyU4n
         bVxDJwkySw1xgRMDPfCDAOzhTkzftdsM12deUfTgM3HxQ6Pet9oxw5MaSjQ390hg1E
         qw8iNPptWp596PJYiMNerSSumGSoOMpn6I5aZjJxseos0KjkEYze1ypcJ82yEU7Sqn
         +K2/VdRYZtYb++mWnocUIIunVsdbO2OONKY9VNNrg+UIKzdusGLZHcNUixpQ2B8IL3
         MMvjExG93mbPmB8dNkT2cMnCGuSZO2UcXZu+b+rPLBFm1mZWpPxnL4bTL69lu/UQDO
         8MKWhBpMMOdIg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/16] net/mlx5e: Decouple TTC logic from mlx5e
Date:   Mon,  2 Aug 2021 19:28:44 -0700
Message-Id: <20210803022853.106973-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803022853.106973-1-saeed@kernel.org>
References: <20210803022853.106973-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Remove dependency in the mlx5e driver from the TTC implementation
by changing the TTC related functions to receive mlx5 generic arguments.
It allows to decouple TTC logic from mlx5e and reused by other parts of
mlx5 driver.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  44 +--
 .../mellanox/mlx5/core/en/fs_tt_redirect.c    |  13 +-
 .../mellanox/mlx5/core/en_accel/fs_tcp.c      |   6 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |   6 +-
 .../net/ethernet/mellanox/mlx5/core/en_arfs.c |   6 +-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 355 +++++++++---------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  17 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  26 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  12 +-
 9 files changed, 250 insertions(+), 235 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 6b01a28e1d93..c289f7004e10 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -106,15 +106,17 @@ enum mlx5_tunnel_types {
 
 bool mlx5_tunnel_inner_ft_supported(struct mlx5_core_dev *mdev);
 
-struct mlx5e_ttc_rule {
+struct mlx5_ttc_rule {
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_destination default_dest;
 };
 
 /* L3/L4 traffic type classifier */
-struct mlx5e_ttc_table {
-	struct mlx5e_flow_table ft;
-	struct mlx5e_ttc_rule rules[MLX5_NUM_TT];
+struct mlx5_ttc_table {
+	int num_groups;
+	struct mlx5_flow_table *t;
+	struct mlx5_flow_group **g;
+	struct mlx5_ttc_rule rules[MLX5_NUM_TT];
 	struct mlx5_flow_handle *tunnel_rules[MLX5_NUM_TUNNEL_TT];
 };
 
@@ -223,8 +225,8 @@ struct mlx5e_flow_steering {
 	struct mlx5e_promisc_table      promisc;
 	struct mlx5e_vlan_table         *vlan;
 	struct mlx5e_l2_table           l2;
-	struct mlx5e_ttc_table          ttc;
-	struct mlx5e_ttc_table          inner_ttc;
+	struct mlx5_ttc_table           ttc;
+	struct mlx5_ttc_table           inner_ttc;
 #ifdef CONFIG_MLX5_EN_ARFS
 	struct mlx5e_arfs_tables       *arfs;
 #endif
@@ -237,28 +239,28 @@ struct mlx5e_flow_steering {
 };
 
 struct ttc_params {
+	struct mlx5_flow_namespace *ns;
 	struct mlx5_flow_table_attr ft_attr;
-	u32 any_tt_tirn;
-	u32 indir_tirn[MLX5E_NUM_INDIR_TIRS];
-	struct mlx5e_ttc_table *inner_ttc;
+	struct mlx5_flow_destination dests[MLX5_NUM_TT];
+	bool   inner_ttc;
+	struct mlx5_flow_destination tunnel_dests[MLX5_NUM_TUNNEL_TT];
 };
 
-void mlx5e_set_ttc_basic_params(struct mlx5e_priv *priv, struct ttc_params *ttc_params);
-void mlx5e_set_ttc_ft_params(struct ttc_params *ttc_params);
+void mlx5e_set_ttc_params(struct mlx5e_priv *priv,
+			  struct ttc_params *ttc_params, bool tunnel);
 
-int mlx5e_create_ttc_table(struct mlx5e_priv *priv, struct ttc_params *params,
-			   struct mlx5e_ttc_table *ttc);
-void mlx5e_destroy_ttc_table(struct mlx5e_priv *priv,
-			     struct mlx5e_ttc_table *ttc);
+int mlx5_create_ttc_table(struct mlx5_core_dev *dev, struct ttc_params *params,
+			  struct mlx5_ttc_table *ttc);
+void mlx5_destroy_ttc_table(struct mlx5_ttc_table *ttc);
 
 void mlx5e_destroy_flow_table(struct mlx5e_flow_table *ft);
-int mlx5e_ttc_fwd_dest(struct mlx5e_priv *priv, enum mlx5_traffic_types type,
-		       struct mlx5_flow_destination *new_dest);
+int mlx5_ttc_fwd_dest(struct mlx5_ttc_table *ttc, enum mlx5_traffic_types type,
+		      struct mlx5_flow_destination *new_dest);
 struct mlx5_flow_destination
-mlx5e_ttc_get_default_dest(struct mlx5e_priv *priv,
-			   enum mlx5_traffic_types type);
-int mlx5e_ttc_fwd_default_dest(struct mlx5e_priv *priv,
-			       enum mlx5_traffic_types type);
+mlx5_ttc_get_default_dest(struct mlx5_ttc_table *ttc,
+			  enum mlx5_traffic_types type);
+int mlx5_ttc_fwd_default_dest(struct mlx5_ttc_table *ttc,
+			      enum mlx5_traffic_types type);
 
 void mlx5e_enable_cvlan_filter(struct mlx5e_priv *priv);
 void mlx5e_disable_cvlan_filter(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
index 5645e8032218..68cc3a8fd6b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
@@ -124,7 +124,7 @@ static int fs_udp_add_default_rule(struct mlx5e_priv *priv, enum fs_udp_type typ
 	fs_udp = priv->fs.udp;
 	fs_udp_t = &fs_udp->tables[type];
 
-	dest = mlx5e_ttc_get_default_dest(priv, fs_udp2tt(type));
+	dest = mlx5_ttc_get_default_dest(&priv->fs.ttc, fs_udp2tt(type));
 	rule = mlx5_add_flow_rules(fs_udp_t->t, NULL, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
@@ -259,7 +259,7 @@ static int fs_udp_disable(struct mlx5e_priv *priv)
 
 	for (i = 0; i < FS_UDP_NUM_TYPES; i++) {
 		/* Modify ttc rules destination to point back to the indir TIRs */
-		err = mlx5e_ttc_fwd_default_dest(priv, fs_udp2tt(i));
+		err = mlx5_ttc_fwd_default_dest(&priv->fs.ttc, fs_udp2tt(i));
 		if (err) {
 			netdev_err(priv->netdev,
 				   "%s: modify ttc[%d] default destination failed, err(%d)\n",
@@ -281,7 +281,8 @@ static int fs_udp_enable(struct mlx5e_priv *priv)
 		dest.ft = priv->fs.udp->tables[i].t;
 
 		/* Modify ttc rules destination to point on the accel_fs FTs */
-		err = mlx5e_ttc_fwd_dest(priv, fs_udp2tt(i), &dest);
+		err = mlx5_ttc_fwd_dest(&priv->fs.ttc, fs_udp2tt(i),
+					&dest);
 		if (err) {
 			netdev_err(priv->netdev,
 				   "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
@@ -401,7 +402,7 @@ static int fs_any_add_default_rule(struct mlx5e_priv *priv)
 	fs_any = priv->fs.any;
 	fs_any_t = &fs_any->table;
 
-	dest = mlx5e_ttc_get_default_dest(priv, MLX5_TT_ANY);
+	dest = mlx5_ttc_get_default_dest(&priv->fs.ttc, MLX5_TT_ANY);
 	rule = mlx5_add_flow_rules(fs_any_t->t, NULL, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
@@ -514,7 +515,7 @@ static int fs_any_disable(struct mlx5e_priv *priv)
 	int err;
 
 	/* Modify ttc rules destination to point back to the indir TIRs */
-	err = mlx5e_ttc_fwd_default_dest(priv, MLX5_TT_ANY);
+	err = mlx5_ttc_fwd_default_dest(&priv->fs.ttc, MLX5_TT_ANY);
 	if (err) {
 		netdev_err(priv->netdev,
 			   "%s: modify ttc[%d] default destination failed, err(%d)\n",
@@ -533,7 +534,7 @@ static int fs_any_enable(struct mlx5e_priv *priv)
 	dest.ft = priv->fs.any->table.t;
 
 	/* Modify ttc rules destination to point on the accel_fs FTs */
-	err = mlx5e_ttc_fwd_dest(priv, MLX5_TT_ANY, &dest);
+	err = mlx5_ttc_fwd_dest(&priv->fs.ttc, MLX5_TT_ANY, &dest);
 	if (err) {
 		netdev_err(priv->netdev,
 			   "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index 90095507a2ca..a82be377e9f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -161,7 +161,7 @@ static int accel_fs_tcp_add_default_rule(struct mlx5e_priv *priv,
 	fs_tcp = priv->fs.accel_tcp;
 	accel_fs_t = &fs_tcp->tables[type];
 
-	dest = mlx5e_ttc_get_default_dest(priv, fs_accel2tt(type));
+	dest = mlx5_ttc_get_default_dest(&priv->fs.ttc, fs_accel2tt(type));
 	rule = mlx5_add_flow_rules(accel_fs_t->t, NULL, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
@@ -307,7 +307,7 @@ static int accel_fs_tcp_disable(struct mlx5e_priv *priv)
 
 	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++) {
 		/* Modify ttc rules destination to point back to the indir TIRs */
-		err = mlx5e_ttc_fwd_default_dest(priv, fs_accel2tt(i));
+		err = mlx5_ttc_fwd_default_dest(&priv->fs.ttc, fs_accel2tt(i));
 		if (err) {
 			netdev_err(priv->netdev,
 				   "%s: modify ttc[%d] default destination failed, err(%d)\n",
@@ -329,7 +329,7 @@ static int accel_fs_tcp_enable(struct mlx5e_priv *priv)
 		dest.ft = priv->fs.accel_tcp->tables[i].t;
 
 		/* Modify ttc rules destination to point on the accel_fs FTs */
-		err = mlx5e_ttc_fwd_dest(priv, fs_accel2tt(i), &dest);
+		err = mlx5_ttc_fwd_dest(&priv->fs.ttc, fs_accel2tt(i), &dest);
 		if (err) {
 			netdev_err(priv->netdev,
 				   "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 9d9e40a64d0c..ff177bb74bb4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -265,7 +265,7 @@ static int rx_create(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 	accel_esp = priv->ipsec->rx_fs;
 	fs_prot = &accel_esp->fs_prot[type];
 
-	fs_prot->default_dest = mlx5e_ttc_get_default_dest(priv, fs_esp2tt(type));
+	fs_prot->default_dest = mlx5_ttc_get_default_dest(&priv->fs.ttc, fs_esp2tt(type));
 
 	err = rx_err_create_ft(priv, fs_prot, &fs_prot->rx_err);
 	if (err)
@@ -301,7 +301,7 @@ static int rx_ft_get(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 	/* connect */
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest.ft = fs_prot->ft;
-	mlx5e_ttc_fwd_dest(priv, fs_esp2tt(type), &dest);
+	mlx5_ttc_fwd_dest(&priv->fs.ttc, fs_esp2tt(type), &dest);
 
 out:
 	mutex_unlock(&fs_prot->prot_mutex);
@@ -320,7 +320,7 @@ static void rx_ft_put(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 		goto out;
 
 	/* disconnect */
-	mlx5e_ttc_fwd_default_dest(priv, fs_esp2tt(type));
+	mlx5_ttc_fwd_default_dest(&priv->fs.ttc, fs_esp2tt(type));
 
 	/* remove FT */
 	rx_destroy(priv, type);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index a9c984fb0447..374e262d9917 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -120,7 +120,7 @@ static int arfs_disable(struct mlx5e_priv *priv)
 
 	for (i = 0; i < ARFS_NUM_TYPES; i++) {
 		/* Modify ttc rules destination back to their default */
-		err = mlx5e_ttc_fwd_default_dest(priv, arfs_get_tt(i));
+		err = mlx5_ttc_fwd_default_dest(&priv->fs.ttc, arfs_get_tt(i));
 		if (err) {
 			netdev_err(priv->netdev,
 				   "%s: modify ttc[%d] default destination failed, err(%d)\n",
@@ -149,7 +149,7 @@ int mlx5e_arfs_enable(struct mlx5e_priv *priv)
 	for (i = 0; i < ARFS_NUM_TYPES; i++) {
 		dest.ft = priv->fs.arfs->arfs_tables[i].ft.t;
 		/* Modify ttc rules destination to point on the aRFS FTs */
-		err = mlx5e_ttc_fwd_dest(priv, arfs_get_tt(i), &dest);
+		err = mlx5_ttc_fwd_dest(&priv->fs.ttc, arfs_get_tt(i), &dest);
 		if (err) {
 			netdev_err(priv->netdev,
 				   "%s: modify ttc[%d] dest to arfs, failed err(%d)\n",
@@ -205,7 +205,7 @@ static int arfs_add_default_rule(struct mlx5e_priv *priv,
 		return -EINVAL;
 	}
 
-	/* FIXME: Must use mlx5e_ttc_get_default_dest(),
+	/* FIXME: Must use mlx5_ttc_get_default_dest(),
 	 * but can't since TTC default is not setup yet !
 	 */
 	dest.tir_num = mlx5e_rx_res_get_tirn_rss(priv->rx_res, tt);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 14a9011ea1a1..a03842d132f6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -718,7 +718,7 @@ static int mlx5e_add_promisc_rule(struct mlx5e_priv *priv)
 	if (!spec)
 		return -ENOMEM;
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest.ft = priv->fs.ttc.ft.t;
+	dest.ft = priv->fs.ttc.t;
 
 	rule_p = &priv->fs.promisc.rule;
 	*rule_p = mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
@@ -854,7 +854,7 @@ void mlx5e_destroy_flow_table(struct mlx5e_flow_table *ft)
 	ft->t = NULL;
 }
 
-static void mlx5e_cleanup_ttc_rules(struct mlx5e_ttc_table *ttc)
+static void mlx5_cleanup_ttc_rules(struct mlx5_ttc_table *ttc)
 {
 	int i;
 
@@ -1004,13 +1004,12 @@ static u8 mlx5_etype_to_ipv(u16 ethertype)
 }
 
 static struct mlx5_flow_handle *
-mlx5e_generate_ttc_rule(struct mlx5e_priv *priv,
-			struct mlx5_flow_table *ft,
-			struct mlx5_flow_destination *dest,
-			u16 etype,
-			u8 proto)
+mlx5_generate_ttc_rule(struct mlx5_core_dev *dev, struct mlx5_flow_table *ft,
+		       struct mlx5_flow_destination *dest, u16 etype, u8 proto)
 {
-	int match_ipv_outer = MLX5_CAP_FLOWTABLE_NIC_RX(priv->mdev, ft_field_support.outer_ip_version);
+	int match_ipv_outer =
+		MLX5_CAP_FLOWTABLE_NIC_RX(dev,
+					  ft_field_support.outer_ip_version);
 	MLX5_DECLARE_FLOW_ACT(flow_act);
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
@@ -1041,60 +1040,51 @@ mlx5e_generate_ttc_rule(struct mlx5e_priv *priv,
 	rule = mlx5_add_flow_rules(ft, spec, &flow_act, dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
-		netdev_err(priv->netdev, "%s: add rule failed\n", __func__);
+		mlx5_core_err(dev, "%s: add rule failed\n", __func__);
 	}
 
 	kvfree(spec);
 	return err ? ERR_PTR(err) : rule;
 }
 
-static int mlx5e_generate_ttc_table_rules(struct mlx5e_priv *priv,
-					  struct ttc_params *params,
-					  struct mlx5e_ttc_table *ttc)
+static int mlx5_generate_ttc_table_rules(struct mlx5_core_dev *dev,
+					 struct ttc_params *params,
+					 struct mlx5_ttc_table *ttc)
 {
-	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_handle **trules;
-	struct mlx5e_ttc_rule *rules;
+	struct mlx5_ttc_rule *rules;
 	struct mlx5_flow_table *ft;
 	int tt;
 	int err;
 
-	ft = ttc->ft.t;
+	ft = ttc->t;
 	rules = ttc->rules;
-
-	dest.type = MLX5_FLOW_DESTINATION_TYPE_TIR;
 	for (tt = 0; tt < MLX5_NUM_TT; tt++) {
-		struct mlx5e_ttc_rule *rule = &rules[tt];
-
-		if (tt == MLX5_TT_ANY)
-			dest.tir_num = params->any_tt_tirn;
-		else
-			dest.tir_num = params->indir_tirn[tt];
+		struct mlx5_ttc_rule *rule = &rules[tt];
 
-		rule->rule = mlx5e_generate_ttc_rule(priv, ft, &dest,
-						     ttc_rules[tt].etype,
-						     ttc_rules[tt].proto);
+		rule->rule = mlx5_generate_ttc_rule(dev, ft, &params->dests[tt],
+						    ttc_rules[tt].etype,
+						    ttc_rules[tt].proto);
 		if (IS_ERR(rule->rule)) {
 			err = PTR_ERR(rule->rule);
 			rule->rule = NULL;
 			goto del_rules;
 		}
-		rule->default_dest = dest;
+		rule->default_dest = params->dests[tt];
 	}
 
-	if (!params->inner_ttc || !mlx5_tunnel_inner_ft_supported(priv->mdev))
+	if (!params->inner_ttc || !mlx5_tunnel_inner_ft_supported(dev))
 		return 0;
 
 	trules    = ttc->tunnel_rules;
-	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest.ft = params->inner_ttc->ft.t;
 	for (tt = 0; tt < MLX5_NUM_TUNNEL_TT; tt++) {
-		if (!mlx5_tunnel_proto_supported_rx(priv->mdev,
+		if (!mlx5_tunnel_proto_supported_rx(dev,
 						    ttc_tunnel_rules[tt].proto))
 			continue;
-		trules[tt] = mlx5e_generate_ttc_rule(priv, ft, &dest,
-						     ttc_tunnel_rules[tt].etype,
-						     ttc_tunnel_rules[tt].proto);
+		trules[tt] = mlx5_generate_ttc_rule(dev, ft,
+						    &params->tunnel_dests[tt],
+						    ttc_tunnel_rules[tt].etype,
+						    ttc_tunnel_rules[tt].proto);
 		if (IS_ERR(trules[tt])) {
 			err = PTR_ERR(trules[tt]);
 			trules[tt] = NULL;
@@ -1105,28 +1095,26 @@ static int mlx5e_generate_ttc_table_rules(struct mlx5e_priv *priv,
 	return 0;
 
 del_rules:
-	mlx5e_cleanup_ttc_rules(ttc);
+	mlx5_cleanup_ttc_rules(ttc);
 	return err;
 }
 
-static int mlx5e_create_ttc_table_groups(struct mlx5e_ttc_table *ttc,
-					 bool use_ipv)
+static int mlx5_create_ttc_table_groups(struct mlx5_ttc_table *ttc,
+					bool use_ipv)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
-	struct mlx5e_flow_table *ft = &ttc->ft;
 	int ix = 0;
 	u32 *in;
 	int err;
 	u8 *mc;
 
-	ft->g = kcalloc(MLX5_TTC_NUM_GROUPS,
-			sizeof(*ft->g), GFP_KERNEL);
-	if (!ft->g)
+	ttc->g = kcalloc(MLX5_TTC_NUM_GROUPS, sizeof(*ttc->g), GFP_KERNEL);
+	if (!ttc->g)
 		return -ENOMEM;
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in) {
-		kfree(ft->g);
-		ft->g = NULL;
+		kfree(ttc->g);
+		ttc->g = NULL;
 		return -ENOMEM;
 	}
 
@@ -1141,47 +1129,47 @@ static int mlx5e_create_ttc_table_groups(struct mlx5e_ttc_table *ttc,
 	MLX5_SET_CFG(in, start_flow_index, ix);
 	ix += MLX5_TTC_GROUP1_SIZE;
 	MLX5_SET_CFG(in, end_flow_index, ix - 1);
-	ft->g[ft->num_groups] = mlx5_create_flow_group(ft->t, in);
-	if (IS_ERR(ft->g[ft->num_groups]))
+	ttc->g[ttc->num_groups] = mlx5_create_flow_group(ttc->t, in);
+	if (IS_ERR(ttc->g[ttc->num_groups]))
 		goto err;
-	ft->num_groups++;
+	ttc->num_groups++;
 
 	/* L3 Group */
 	MLX5_SET(fte_match_param, mc, outer_headers.ip_protocol, 0);
 	MLX5_SET_CFG(in, start_flow_index, ix);
 	ix += MLX5_TTC_GROUP2_SIZE;
 	MLX5_SET_CFG(in, end_flow_index, ix - 1);
-	ft->g[ft->num_groups] = mlx5_create_flow_group(ft->t, in);
-	if (IS_ERR(ft->g[ft->num_groups]))
+	ttc->g[ttc->num_groups] = mlx5_create_flow_group(ttc->t, in);
+	if (IS_ERR(ttc->g[ttc->num_groups]))
 		goto err;
-	ft->num_groups++;
+	ttc->num_groups++;
 
 	/* Any Group */
 	memset(in, 0, inlen);
 	MLX5_SET_CFG(in, start_flow_index, ix);
 	ix += MLX5_TTC_GROUP3_SIZE;
 	MLX5_SET_CFG(in, end_flow_index, ix - 1);
-	ft->g[ft->num_groups] = mlx5_create_flow_group(ft->t, in);
-	if (IS_ERR(ft->g[ft->num_groups]))
+	ttc->g[ttc->num_groups] = mlx5_create_flow_group(ttc->t, in);
+	if (IS_ERR(ttc->g[ttc->num_groups]))
 		goto err;
-	ft->num_groups++;
+	ttc->num_groups++;
 
 	kvfree(in);
 	return 0;
 
 err:
-	err = PTR_ERR(ft->g[ft->num_groups]);
-	ft->g[ft->num_groups] = NULL;
+	err = PTR_ERR(ttc->g[ttc->num_groups]);
+	ttc->g[ttc->num_groups] = NULL;
 	kvfree(in);
 
 	return err;
 }
 
 static struct mlx5_flow_handle *
-mlx5e_generate_inner_ttc_rule(struct mlx5e_priv *priv,
-			      struct mlx5_flow_table *ft,
-			      struct mlx5_flow_destination *dest,
-			      u16 etype, u8 proto)
+mlx5_generate_inner_ttc_rule(struct mlx5_core_dev *dev,
+			     struct mlx5_flow_table *ft,
+			     struct mlx5_flow_destination *dest,
+			     u16 etype, u8 proto)
 {
 	MLX5_DECLARE_FLOW_ACT(flow_act);
 	struct mlx5_flow_handle *rule;
@@ -1209,70 +1197,64 @@ mlx5e_generate_inner_ttc_rule(struct mlx5e_priv *priv,
 	rule = mlx5_add_flow_rules(ft, spec, &flow_act, dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
-		netdev_err(priv->netdev, "%s: add rule failed\n", __func__);
+		mlx5_core_err(dev, "%s: add inner TTC rule failed\n", __func__);
 	}
 
 	kvfree(spec);
 	return err ? ERR_PTR(err) : rule;
 }
 
-static int mlx5e_generate_inner_ttc_table_rules(struct mlx5e_priv *priv,
-						struct ttc_params *params,
-						struct mlx5e_ttc_table *ttc)
+static int mlx5_generate_inner_ttc_table_rules(struct mlx5_core_dev *dev,
+					       struct ttc_params *params,
+					       struct mlx5_ttc_table *ttc)
 {
-	struct mlx5_flow_destination dest = {};
-	struct mlx5e_ttc_rule *rules;
+	struct mlx5_ttc_rule *rules;
 	struct mlx5_flow_table *ft;
 	int err;
 	int tt;
 
-	ft = ttc->ft.t;
+	ft = ttc->t;
 	rules = ttc->rules;
-	dest.type = MLX5_FLOW_DESTINATION_TYPE_TIR;
 
 	for (tt = 0; tt < MLX5_NUM_TT; tt++) {
-		struct mlx5e_ttc_rule *rule = &rules[tt];
-
-		if (tt == MLX5_TT_ANY)
-			dest.tir_num = params->any_tt_tirn;
-		else
-			dest.tir_num = params->indir_tirn[tt];
+		struct mlx5_ttc_rule *rule = &rules[tt];
 
-		rule->rule = mlx5e_generate_inner_ttc_rule(priv, ft, &dest,
-							   ttc_rules[tt].etype,
-							   ttc_rules[tt].proto);
+		rule->rule = mlx5_generate_inner_ttc_rule(dev, ft,
+							  &params->dests[tt],
+							  ttc_rules[tt].etype,
+							  ttc_rules[tt].proto);
 		if (IS_ERR(rule->rule)) {
 			err = PTR_ERR(rule->rule);
 			rule->rule = NULL;
 			goto del_rules;
 		}
-		rule->default_dest = dest;
+		rule->default_dest = params->dests[tt];
 	}
 
 	return 0;
 
 del_rules:
 
-	mlx5e_cleanup_ttc_rules(ttc);
+	mlx5_cleanup_ttc_rules(ttc);
 	return err;
 }
 
-static int mlx5e_create_inner_ttc_table_groups(struct mlx5e_ttc_table *ttc)
+static int mlx5_create_inner_ttc_table_groups(struct mlx5_ttc_table *ttc)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
-	struct mlx5e_flow_table *ft = &ttc->ft;
 	int ix = 0;
 	u32 *in;
 	int err;
 	u8 *mc;
 
-	ft->g = kcalloc(MLX5_INNER_TTC_NUM_GROUPS, sizeof(*ft->g), GFP_KERNEL);
-	if (!ft->g)
+	ttc->g = kcalloc(MLX5_INNER_TTC_NUM_GROUPS, sizeof(*ttc->g),
+			 GFP_KERNEL);
+	if (!ttc->g)
 		return -ENOMEM;
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in) {
-		kfree(ft->g);
-		ft->g = NULL;
+		kfree(ttc->g);
+		ttc->g = NULL;
 		return -ENOMEM;
 	}
 
@@ -1284,148 +1266,191 @@ static int mlx5e_create_inner_ttc_table_groups(struct mlx5e_ttc_table *ttc)
 	MLX5_SET_CFG(in, start_flow_index, ix);
 	ix += MLX5_INNER_TTC_GROUP1_SIZE;
 	MLX5_SET_CFG(in, end_flow_index, ix - 1);
-	ft->g[ft->num_groups] = mlx5_create_flow_group(ft->t, in);
-	if (IS_ERR(ft->g[ft->num_groups]))
+	ttc->g[ttc->num_groups] = mlx5_create_flow_group(ttc->t, in);
+	if (IS_ERR(ttc->g[ttc->num_groups]))
 		goto err;
-	ft->num_groups++;
+	ttc->num_groups++;
 
 	/* L3 Group */
 	MLX5_SET(fte_match_param, mc, inner_headers.ip_protocol, 0);
 	MLX5_SET_CFG(in, start_flow_index, ix);
 	ix += MLX5_INNER_TTC_GROUP2_SIZE;
 	MLX5_SET_CFG(in, end_flow_index, ix - 1);
-	ft->g[ft->num_groups] = mlx5_create_flow_group(ft->t, in);
-	if (IS_ERR(ft->g[ft->num_groups]))
+	ttc->g[ttc->num_groups] = mlx5_create_flow_group(ttc->t, in);
+	if (IS_ERR(ttc->g[ttc->num_groups]))
 		goto err;
-	ft->num_groups++;
+	ttc->num_groups++;
 
 	/* Any Group */
 	memset(in, 0, inlen);
 	MLX5_SET_CFG(in, start_flow_index, ix);
 	ix += MLX5_INNER_TTC_GROUP3_SIZE;
 	MLX5_SET_CFG(in, end_flow_index, ix - 1);
-	ft->g[ft->num_groups] = mlx5_create_flow_group(ft->t, in);
-	if (IS_ERR(ft->g[ft->num_groups]))
+	ttc->g[ttc->num_groups] = mlx5_create_flow_group(ttc->t, in);
+	if (IS_ERR(ttc->g[ttc->num_groups]))
 		goto err;
-	ft->num_groups++;
+	ttc->num_groups++;
 
 	kvfree(in);
 	return 0;
 
 err:
-	err = PTR_ERR(ft->g[ft->num_groups]);
-	ft->g[ft->num_groups] = NULL;
+	err = PTR_ERR(ttc->g[ttc->num_groups]);
+	ttc->g[ttc->num_groups] = NULL;
 	kvfree(in);
 
 	return err;
 }
 
-void mlx5e_set_ttc_basic_params(struct mlx5e_priv *priv,
-				struct ttc_params *ttc_params)
-{
-	ttc_params->any_tt_tirn = mlx5e_rx_res_get_tirn_direct(priv->rx_res, 0);
-	ttc_params->inner_ttc = &priv->fs.inner_ttc;
-}
-
-static void mlx5e_set_inner_ttc_ft_params(struct ttc_params *ttc_params)
+static void mlx5e_set_inner_ttc_params(struct mlx5e_priv *priv,
+				       struct ttc_params *ttc_params)
 {
 	struct mlx5_flow_table_attr *ft_attr = &ttc_params->ft_attr;
+	int tt;
 
-	ft_attr->max_fte = MLX5_INNER_TTC_TABLE_SIZE;
+	memset(ttc_params, 0, sizeof(*ttc_params));
+	ttc_params->ns = mlx5_get_flow_namespace(priv->mdev,
+						 MLX5_FLOW_NAMESPACE_KERNEL);
 	ft_attr->level = MLX5E_INNER_TTC_FT_LEVEL;
 	ft_attr->prio = MLX5E_NIC_PRIO;
+
+	for (tt = 0; tt < MLX5_NUM_TT; tt++) {
+		ttc_params->dests[tt].type = MLX5_FLOW_DESTINATION_TYPE_TIR;
+		ttc_params->dests[tt].tir_num =
+			tt == MLX5_TT_ANY ?
+				mlx5e_rx_res_get_tirn_direct(priv->rx_res, 0) :
+				mlx5e_rx_res_get_tirn_rss_inner(priv->rx_res,
+								tt);
+	}
 }
 
-void mlx5e_set_ttc_ft_params(struct ttc_params *ttc_params)
+void mlx5e_set_ttc_params(struct mlx5e_priv *priv,
+			  struct ttc_params *ttc_params, bool tunnel)
 
 {
 	struct mlx5_flow_table_attr *ft_attr = &ttc_params->ft_attr;
+	int tt;
 
-	ft_attr->max_fte = MLX5_TTC_TABLE_SIZE;
+	memset(ttc_params, 0, sizeof(*ttc_params));
+	ttc_params->ns = mlx5_get_flow_namespace(priv->mdev,
+						 MLX5_FLOW_NAMESPACE_KERNEL);
 	ft_attr->level = MLX5E_TTC_FT_LEVEL;
 	ft_attr->prio = MLX5E_NIC_PRIO;
+
+	for (tt = 0; tt < MLX5_NUM_TT; tt++) {
+		ttc_params->dests[tt].type = MLX5_FLOW_DESTINATION_TYPE_TIR;
+		ttc_params->dests[tt].tir_num =
+			tt == MLX5_TT_ANY ?
+				mlx5e_rx_res_get_tirn_direct(priv->rx_res, 0) :
+				mlx5e_rx_res_get_tirn_rss(priv->rx_res, tt);
+	}
+
+	ttc_params->inner_ttc = tunnel;
+	if (!tunnel || !mlx5_tunnel_inner_ft_supported(priv->mdev))
+		return;
+
+	for (tt = 0; tt < MLX5_NUM_TUNNEL_TT; tt++) {
+		ttc_params->tunnel_dests[tt].type =
+			MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+		ttc_params->tunnel_dests[tt].ft = priv->fs.inner_ttc.t;
+	}
 }
 
-static int mlx5e_create_inner_ttc_table(struct mlx5e_priv *priv, struct ttc_params *params,
-					struct mlx5e_ttc_table *ttc)
+static int mlx5_create_inner_ttc_table(struct mlx5_core_dev *dev,
+				       struct ttc_params *params,
+				       struct mlx5_ttc_table *ttc)
 {
-	struct mlx5e_flow_table *ft = &ttc->ft;
 	int err;
 
-	ft->t = mlx5_create_flow_table(priv->fs.ns, &params->ft_attr);
-	if (IS_ERR(ft->t)) {
-		err = PTR_ERR(ft->t);
-		ft->t = NULL;
+	WARN_ON_ONCE(params->ft_attr.max_fte);
+	params->ft_attr.max_fte = MLX5_INNER_TTC_TABLE_SIZE;
+	ttc->t = mlx5_create_flow_table(params->ns, &params->ft_attr);
+	if (IS_ERR(ttc->t)) {
+		err = PTR_ERR(ttc->t);
+		ttc->t = NULL;
 		return err;
 	}
 
-	err = mlx5e_create_inner_ttc_table_groups(ttc);
+	err = mlx5_create_inner_ttc_table_groups(ttc);
 	if (err)
-		goto err;
+		goto destroy_ttc;
 
-	err = mlx5e_generate_inner_ttc_table_rules(priv, params, ttc);
+	err = mlx5_generate_inner_ttc_table_rules(dev, params, ttc);
 	if (err)
-		goto err;
+		goto destroy_ttc;
 
 	return 0;
 
-err:
-	mlx5e_destroy_flow_table(ft);
+destroy_ttc:
+	mlx5_destroy_ttc_table(ttc);
 	return err;
 }
 
-static void mlx5e_destroy_inner_ttc_table(struct mlx5e_priv *priv,
-					  struct mlx5e_ttc_table *ttc)
+void mlx5_destroy_ttc_table(struct mlx5_ttc_table *ttc)
 {
-	mlx5e_cleanup_ttc_rules(ttc);
-	mlx5e_destroy_flow_table(&ttc->ft);
+	int i;
+
+	mlx5_cleanup_ttc_rules(ttc);
+	for (i = ttc->num_groups - 1; i >= 0; i--) {
+		if (!IS_ERR_OR_NULL(ttc->g[i]))
+			mlx5_destroy_flow_group(ttc->g[i]);
+		ttc->g[i] = NULL;
+	}
+
+	ttc->num_groups = 0;
+	kfree(ttc->g);
+	mlx5_destroy_flow_table(ttc->t);
+	ttc->t = NULL;
 }
 
-void mlx5e_destroy_ttc_table(struct mlx5e_priv *priv,
-			     struct mlx5e_ttc_table *ttc)
+static void mlx5_destroy_inner_ttc_table(struct mlx5_ttc_table *ttc)
 {
-	mlx5e_cleanup_ttc_rules(ttc);
-	mlx5e_destroy_flow_table(&ttc->ft);
+	mlx5_destroy_ttc_table(ttc);
 }
 
-int mlx5e_create_ttc_table(struct mlx5e_priv *priv, struct ttc_params *params,
-			   struct mlx5e_ttc_table *ttc)
+int mlx5_create_ttc_table(struct mlx5_core_dev *dev, struct ttc_params *params,
+			  struct mlx5_ttc_table *ttc)
 {
-	bool match_ipv_outer = MLX5_CAP_FLOWTABLE_NIC_RX(priv->mdev, ft_field_support.outer_ip_version);
-	struct mlx5e_flow_table *ft = &ttc->ft;
+	bool match_ipv_outer =
+		MLX5_CAP_FLOWTABLE_NIC_RX(dev,
+					  ft_field_support.outer_ip_version);
 	int err;
 
-	ft->t = mlx5_create_flow_table(priv->fs.ns, &params->ft_attr);
-	if (IS_ERR(ft->t)) {
-		err = PTR_ERR(ft->t);
-		ft->t = NULL;
+	WARN_ON_ONCE(params->ft_attr.max_fte);
+	params->ft_attr.max_fte = MLX5_TTC_TABLE_SIZE;
+	ttc->t = mlx5_create_flow_table(params->ns, &params->ft_attr);
+	if (IS_ERR(ttc->t)) {
+		err = PTR_ERR(ttc->t);
+		ttc->t = NULL;
 		return err;
 	}
 
-	err = mlx5e_create_ttc_table_groups(ttc, match_ipv_outer);
+	err = mlx5_create_ttc_table_groups(ttc, match_ipv_outer);
 	if (err)
-		goto err;
+		goto destroy_ttc;
 
-	err = mlx5e_generate_ttc_table_rules(priv, params, ttc);
+	err = mlx5_generate_ttc_table_rules(dev, params, ttc);
 	if (err)
-		goto err;
+		goto destroy_ttc;
 
 	return 0;
-err:
-	mlx5e_destroy_flow_table(ft);
+destroy_ttc:
+	mlx5_destroy_ttc_table(ttc);
 	return err;
 }
 
-int mlx5e_ttc_fwd_dest(struct mlx5e_priv *priv, enum mlx5_traffic_types type,
-		       struct mlx5_flow_destination *new_dest)
+int mlx5_ttc_fwd_dest(struct mlx5_ttc_table *ttc, enum mlx5_traffic_types type,
+		      struct mlx5_flow_destination *new_dest)
 {
-	return mlx5_modify_rule_destination(priv->fs.ttc.rules[type].rule, new_dest, NULL);
+	return mlx5_modify_rule_destination(ttc->rules[type].rule, new_dest,
+					    NULL);
 }
 
 struct mlx5_flow_destination
-mlx5e_ttc_get_default_dest(struct mlx5e_priv *priv, enum mlx5_traffic_types type)
+mlx5_ttc_get_default_dest(struct mlx5_ttc_table *ttc,
+			  enum mlx5_traffic_types type)
 {
-	struct mlx5_flow_destination *dest = &priv->fs.ttc.rules[type].default_dest;
+	struct mlx5_flow_destination *dest = &ttc->rules[type].default_dest;
 
 	WARN_ONCE(dest->type != MLX5_FLOW_DESTINATION_TYPE_TIR,
 		  "TTC[%d] default dest is not setup yet", type);
@@ -1433,11 +1458,12 @@ mlx5e_ttc_get_default_dest(struct mlx5e_priv *priv, enum mlx5_traffic_types type
 	return *dest;
 }
 
-int mlx5e_ttc_fwd_default_dest(struct mlx5e_priv *priv, enum mlx5_traffic_types type)
+int mlx5_ttc_fwd_default_dest(struct mlx5_ttc_table *ttc,
+			      enum mlx5_traffic_types type)
 {
-	struct mlx5_flow_destination dest = mlx5e_ttc_get_default_dest(priv, type);
+	struct mlx5_flow_destination dest = mlx5_ttc_get_default_dest(ttc, type);
 
-	return mlx5e_ttc_fwd_dest(priv, type, &dest);
+	return mlx5_ttc_fwd_dest(ttc, type, &dest);
 }
 
 static void mlx5e_del_l2_flow_rule(struct mlx5e_priv *priv,
@@ -1470,7 +1496,7 @@ static int mlx5e_add_l2_flow_rule(struct mlx5e_priv *priv,
 			       outer_headers.dmac_47_16);
 
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest.ft = priv->fs.ttc.ft.t;
+	dest.ft = priv->fs.ttc.t;
 
 	switch (type) {
 	case MLX5E_FULLMATCH:
@@ -1769,7 +1795,7 @@ static void mlx5e_destroy_vlan_table(struct mlx5e_priv *priv)
 int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 {
 	struct ttc_params ttc_params = {};
-	int tt, err;
+	int err;
 
 	priv->fs.ns = mlx5_get_flow_namespace(priv->mdev,
 					       MLX5_FLOW_NAMESPACE_KERNEL);
@@ -1784,27 +1810,20 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 		priv->netdev->hw_features &= ~NETIF_F_NTUPLE;
 	}
 
-	mlx5e_set_ttc_basic_params(priv, &ttc_params);
-
 	if (mlx5_tunnel_inner_ft_supported(priv->mdev)) {
-		mlx5e_set_inner_ttc_ft_params(&ttc_params);
-		for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
-			ttc_params.indir_tirn[tt] =
-				mlx5e_rx_res_get_tirn_rss_inner(priv->rx_res, tt);
-
-		err = mlx5e_create_inner_ttc_table(priv, &ttc_params, &priv->fs.inner_ttc);
+		mlx5e_set_inner_ttc_params(priv, &ttc_params);
+		err = mlx5_create_inner_ttc_table(priv->mdev, &ttc_params,
+						  &priv->fs.inner_ttc);
 		if (err) {
-			netdev_err(priv->netdev, "Failed to create inner ttc table, err=%d\n",
+			netdev_err(priv->netdev,
+				   "Failed to create inner ttc table, err=%d\n",
 				   err);
 			goto err_destroy_arfs_tables;
 		}
 	}
 
-	mlx5e_set_ttc_ft_params(&ttc_params);
-	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
-		ttc_params.indir_tirn[tt] = mlx5e_rx_res_get_tirn_rss(priv->rx_res, tt);
-
-	err = mlx5e_create_ttc_table(priv, &ttc_params, &priv->fs.ttc);
+	mlx5e_set_ttc_params(priv, &ttc_params, true);
+	err = mlx5_create_ttc_table(priv->mdev, &ttc_params, &priv->fs.ttc);
 	if (err) {
 		netdev_err(priv->netdev, "Failed to create ttc table, err=%d\n",
 			   err);
@@ -1838,10 +1857,10 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 err_destroy_l2_table:
 	mlx5e_destroy_l2_table(priv);
 err_destroy_ttc_table:
-	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
+	mlx5_destroy_ttc_table(&priv->fs.ttc);
 err_destroy_inner_ttc_table:
 	if (mlx5_tunnel_inner_ft_supported(priv->mdev))
-		mlx5e_destroy_inner_ttc_table(priv, &priv->fs.inner_ttc);
+		mlx5_destroy_inner_ttc_table(&priv->fs.inner_ttc);
 err_destroy_arfs_tables:
 	mlx5e_arfs_destroy_tables(priv);
 
@@ -1853,9 +1872,9 @@ void mlx5e_destroy_flow_steering(struct mlx5e_priv *priv)
 	mlx5e_ptp_free_rx_fs(priv);
 	mlx5e_destroy_vlan_table(priv);
 	mlx5e_destroy_l2_table(priv);
-	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
+	mlx5_destroy_ttc_table(&priv->fs.ttc);
 	if (mlx5_tunnel_inner_ft_supported(priv->mdev))
-		mlx5e_destroy_inner_ttc_table(priv, &priv->fs.inner_ttc);
+		mlx5_destroy_inner_ttc_table(&priv->fs.inner_ttc);
 	mlx5e_arfs_destroy_tables(priv);
 	mlx5e_ethtool_cleanup_steering(priv);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index f6e96b7d4698..9817a176916a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -647,25 +647,20 @@ static int mlx5e_create_rep_ttc_table(struct mlx5e_priv *priv)
 {
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
-	struct mlx5e_rx_res *res = priv->rx_res;
 	struct ttc_params ttc_params = {};
-	int tt, err;
+	int err;
 
 	priv->fs.ns = mlx5_get_flow_namespace(priv->mdev,
 					      MLX5_FLOW_NAMESPACE_KERNEL);
 
 	/* The inner_ttc in the ttc params is intentionally not set */
-	ttc_params.any_tt_tirn = mlx5e_rx_res_get_tirn_direct(res, 0);
-	mlx5e_set_ttc_ft_params(&ttc_params);
+	mlx5e_set_ttc_params(priv, &ttc_params, false);
 
 	if (rep->vport != MLX5_VPORT_UPLINK)
 		/* To give uplik rep TTC a lower level for chaining from root ft */
 		ttc_params.ft_attr.level = MLX5E_TTC_FT_LEVEL + 1;
 
-	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
-		ttc_params.indir_tirn[tt] = mlx5e_rx_res_get_tirn_rss(res, tt);
-
-	err = mlx5e_create_ttc_table(priv, &ttc_params, &priv->fs.ttc);
+	err = mlx5_create_ttc_table(priv->mdev, &ttc_params, &priv->fs.ttc);
 	if (err) {
 		netdev_err(priv->netdev, "Failed to create rep ttc table, err=%d\n", err);
 		return err;
@@ -685,7 +680,7 @@ static int mlx5e_create_rep_root_ft(struct mlx5e_priv *priv)
 		/* non uplik reps will skip any bypass tables and go directly to
 		 * their own ttc
 		 */
-		rpriv->root_ft = priv->fs.ttc.ft.t;
+		rpriv->root_ft = priv->fs.ttc.t;
 		return 0;
 	}
 
@@ -799,7 +794,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 err_destroy_root_ft:
 	mlx5e_destroy_rep_root_ft(priv);
 err_destroy_ttc_table:
-	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
+	mlx5_destroy_ttc_table(&priv->fs.ttc);
 err_destroy_rx_res:
 	mlx5e_rx_res_destroy(priv->rx_res);
 err_close_drop_rq:
@@ -814,7 +809,7 @@ static void mlx5e_cleanup_rep_rx(struct mlx5e_priv *priv)
 	mlx5e_ethtool_cleanup_steering(priv);
 	rep_vport_rx_rule_destroy(priv);
 	mlx5e_destroy_rep_root_ft(priv);
-	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
+	mlx5_destroy_ttc_table(&priv->fs.ttc);
 	mlx5e_rx_res_destroy(priv->rx_res);
 	mlx5e_close_drop_rq(&priv->drop_rq);
 	mlx5e_rx_res_free(priv->rx_res);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 300a37c83c17..afbd0caf31ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -345,7 +345,7 @@ struct mlx5e_hairpin {
 	int num_channels;
 	struct mlx5e_rqt indir_rqt;
 	struct mlx5e_tir indir_tir[MLX5E_NUM_INDIR_TIRS];
-	struct mlx5e_ttc_table ttc;
+	struct mlx5_ttc_table ttc;
 };
 
 struct mlx5e_hairpin_entry {
@@ -595,12 +595,16 @@ static void mlx5e_hairpin_set_ttc_params(struct mlx5e_hairpin *hp,
 
 	memset(ttc_params, 0, sizeof(*ttc_params));
 
-	ttc_params->any_tt_tirn = mlx5e_tir_get_tirn(&hp->direct_tir);
-
-	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
-		ttc_params->indir_tirn[tt] = mlx5e_tir_get_tirn(&hp->indir_tir[tt]);
+	ttc_params->ns = mlx5_get_flow_namespace(hp->func_mdev,
+						 MLX5_FLOW_NAMESPACE_KERNEL);
+	for (tt = 0; tt < MLX5_NUM_TT; tt++) {
+		ttc_params->dests[tt].type = MLX5_FLOW_DESTINATION_TYPE_TIR;
+		ttc_params->dests[tt].tir_num =
+			tt == MLX5_TT_ANY ?
+				mlx5e_tir_get_tirn(&hp->direct_tir) :
+				mlx5e_tir_get_tirn(&hp->indir_tir[tt]);
+	}
 
-	ft_attr->max_fte = MLX5_TTC_TABLE_SIZE;
 	ft_attr->level = MLX5E_TC_TTC_FT_LEVEL;
 	ft_attr->prio = MLX5E_TC_PRIO;
 }
@@ -620,12 +624,12 @@ static int mlx5e_hairpin_rss_init(struct mlx5e_hairpin *hp)
 		goto err_create_indirect_tirs;
 
 	mlx5e_hairpin_set_ttc_params(hp, &ttc_params);
-	err = mlx5e_create_ttc_table(priv, &ttc_params, &hp->ttc);
+	err = mlx5_create_ttc_table(priv->mdev, &ttc_params, &hp->ttc);
 	if (err)
 		goto err_create_ttc_table;
 
 	netdev_dbg(priv->netdev, "add hairpin: using %d channels rss ttc table id %x\n",
-		   hp->num_channels, hp->ttc.ft.t->id);
+		   hp->num_channels, hp->ttc.t->id);
 
 	return 0;
 
@@ -639,9 +643,7 @@ static int mlx5e_hairpin_rss_init(struct mlx5e_hairpin *hp)
 
 static void mlx5e_hairpin_rss_cleanup(struct mlx5e_hairpin *hp)
 {
-	struct mlx5e_priv *priv = hp->func_priv;
-
-	mlx5e_destroy_ttc_table(priv, &hp->ttc);
+	mlx5_destroy_ttc_table(&hp->ttc);
 	mlx5e_hairpin_destroy_indirect_tirs(hp);
 	mlx5e_rqt_destroy(&hp->indir_rqt);
 }
@@ -885,7 +887,7 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *priv,
 attach_flow:
 	if (hpe->hp->num_channels > 1) {
 		flow_flag_set(flow, HAIRPIN_RSS);
-		flow->attr->nic_attr->hairpin_ft = hpe->hp->ttc.ft.t;
+		flow->attr->nic_attr->hairpin_ft = hpe->hp->ttc.t;
 	} else {
 		flow->attr->nic_attr->hairpin_tirn = mlx5e_tir_get_tirn(&hpe->hp->direct_tir);
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 1f118678ea9d..e04b758f20e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -315,7 +315,7 @@ static void mlx5i_cleanup_tx(struct mlx5e_priv *priv)
 static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 {
 	struct ttc_params ttc_params = {};
-	int tt, err;
+	int err;
 
 	priv->fs.ns = mlx5_get_flow_namespace(priv->mdev,
 					       MLX5_FLOW_NAMESPACE_KERNEL);
@@ -330,12 +330,8 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 		priv->netdev->hw_features &= ~NETIF_F_NTUPLE;
 	}
 
-	mlx5e_set_ttc_basic_params(priv, &ttc_params);
-	mlx5e_set_ttc_ft_params(&ttc_params);
-	for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
-		ttc_params.indir_tirn[tt] = mlx5e_rx_res_get_tirn_rss(priv->rx_res, tt);
-
-	err = mlx5e_create_ttc_table(priv, &ttc_params, &priv->fs.ttc);
+	mlx5e_set_ttc_params(priv, &ttc_params, true);
+	err = mlx5_create_ttc_table(priv->mdev, &ttc_params, &priv->fs.ttc);
 	if (err) {
 		netdev_err(priv->netdev, "Failed to create ttc table, err=%d\n",
 			   err);
@@ -352,7 +348,7 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 
 static void mlx5i_destroy_flow_steering(struct mlx5e_priv *priv)
 {
-	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
+	mlx5_destroy_ttc_table(&priv->fs.ttc);
 	mlx5e_arfs_destroy_tables(priv);
 }
 
-- 
2.31.1

