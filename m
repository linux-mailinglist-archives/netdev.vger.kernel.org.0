Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18133DE462
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 04:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbhHCC3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 22:29:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233712AbhHCC3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 22:29:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A0DB60EE8;
        Tue,  3 Aug 2021 02:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627957743;
        bh=8+P8dibD/2YTsL+ab6wWAZ8cyAzdQ0nihkK7uNgpblM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LiQXq+LynLjWK0tBx4VfxL97aRnadDigCRfI75lEByWMKE6/UWGsgMnfcmVSnEzMQ
         s9CLeNzlfhSmPpgC7bXwRRlsjgHI5hBa0vOfMcBLzXYKyAinkcKXd29LxNyLQDDtzL
         7xrzOsSM+25LO4tijeQpDXNDJ/u3fBvV+p91SrcaqMo0FlPWPn2VULiSq+g0CMPl/u
         15A8QOLfj+iwUH9rVnRRKw4jVUt1IiD7O2LtC9rc20pN0J7LklkxDW+4Ut30spMb/k
         Cv7cj2FPnCTX2nE/nuD+BFUbkdmqc3Oe1q6vMh7joEdcZtHRIs78JNwPLxz3BoB05m
         ozYtYcG6lVMQw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: [net-next 09/16] net/mlx5: Embed mlx5_ttc_table
Date:   Mon,  2 Aug 2021 19:28:46 -0700
Message-Id: <20210803022853.106973-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803022853.106973-1-saeed@kernel.org>
References: <20210803022853.106973-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

mlx5_ttc_table struct shouldn't be exposed to the users so
this patch make it internal to ttc.

In addition add a getter function to get the TTC flow table for users
that need to add a rule which points on it.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  7 +-
 .../mellanox/mlx5/core/en/fs_tt_redirect.c    | 13 ++--
 .../mellanox/mlx5/core/en_accel/fs_tcp.c      |  6 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  7 +-
 .../net/ethernet/mellanox/mlx5/core/en_arfs.c |  4 +-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 74 +++++++++++++------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 14 ++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 16 ++--
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  6 +-
 .../ethernet/mellanox/mlx5/core/lib/fs_ttc.c  | 58 ++++++++++-----
 .../ethernet/mellanox/mlx5/core/lib/fs_ttc.h  | 21 ++----
 11 files changed, 137 insertions(+), 89 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 8e7794c3d330..e348c276eaa1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -169,8 +169,8 @@ struct mlx5e_flow_steering {
 	struct mlx5e_promisc_table      promisc;
 	struct mlx5e_vlan_table         *vlan;
 	struct mlx5e_l2_table           l2;
-	struct mlx5_ttc_table           ttc;
-	struct mlx5_ttc_table           inner_ttc;
+	struct mlx5_ttc_table           *ttc;
+	struct mlx5_ttc_table           *inner_ttc;
 #ifdef CONFIG_MLX5_EN_ARFS
 	struct mlx5e_arfs_tables       *arfs;
 #endif
@@ -185,6 +185,9 @@ struct mlx5e_flow_steering {
 void mlx5e_set_ttc_params(struct mlx5e_priv *priv,
 			  struct ttc_params *ttc_params, bool tunnel);
 
+void mlx5e_destroy_ttc_table(struct mlx5e_priv *priv);
+int mlx5e_create_ttc_table(struct mlx5e_priv *priv);
+
 void mlx5e_destroy_flow_table(struct mlx5e_flow_table *ft);
 
 void mlx5e_enable_cvlan_filter(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
index 68cc3a8fd6b7..7aa25a5e29d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
@@ -124,7 +124,7 @@ static int fs_udp_add_default_rule(struct mlx5e_priv *priv, enum fs_udp_type typ
 	fs_udp = priv->fs.udp;
 	fs_udp_t = &fs_udp->tables[type];
 
-	dest = mlx5_ttc_get_default_dest(&priv->fs.ttc, fs_udp2tt(type));
+	dest = mlx5_ttc_get_default_dest(priv->fs.ttc, fs_udp2tt(type));
 	rule = mlx5_add_flow_rules(fs_udp_t->t, NULL, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
@@ -259,7 +259,7 @@ static int fs_udp_disable(struct mlx5e_priv *priv)
 
 	for (i = 0; i < FS_UDP_NUM_TYPES; i++) {
 		/* Modify ttc rules destination to point back to the indir TIRs */
-		err = mlx5_ttc_fwd_default_dest(&priv->fs.ttc, fs_udp2tt(i));
+		err = mlx5_ttc_fwd_default_dest(priv->fs.ttc, fs_udp2tt(i));
 		if (err) {
 			netdev_err(priv->netdev,
 				   "%s: modify ttc[%d] default destination failed, err(%d)\n",
@@ -281,8 +281,7 @@ static int fs_udp_enable(struct mlx5e_priv *priv)
 		dest.ft = priv->fs.udp->tables[i].t;
 
 		/* Modify ttc rules destination to point on the accel_fs FTs */
-		err = mlx5_ttc_fwd_dest(&priv->fs.ttc, fs_udp2tt(i),
-					&dest);
+		err = mlx5_ttc_fwd_dest(priv->fs.ttc, fs_udp2tt(i), &dest);
 		if (err) {
 			netdev_err(priv->netdev,
 				   "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
@@ -402,7 +401,7 @@ static int fs_any_add_default_rule(struct mlx5e_priv *priv)
 	fs_any = priv->fs.any;
 	fs_any_t = &fs_any->table;
 
-	dest = mlx5_ttc_get_default_dest(&priv->fs.ttc, MLX5_TT_ANY);
+	dest = mlx5_ttc_get_default_dest(priv->fs.ttc, MLX5_TT_ANY);
 	rule = mlx5_add_flow_rules(fs_any_t->t, NULL, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
@@ -515,7 +514,7 @@ static int fs_any_disable(struct mlx5e_priv *priv)
 	int err;
 
 	/* Modify ttc rules destination to point back to the indir TIRs */
-	err = mlx5_ttc_fwd_default_dest(&priv->fs.ttc, MLX5_TT_ANY);
+	err = mlx5_ttc_fwd_default_dest(priv->fs.ttc, MLX5_TT_ANY);
 	if (err) {
 		netdev_err(priv->netdev,
 			   "%s: modify ttc[%d] default destination failed, err(%d)\n",
@@ -534,7 +533,7 @@ static int fs_any_enable(struct mlx5e_priv *priv)
 	dest.ft = priv->fs.any->table.t;
 
 	/* Modify ttc rules destination to point on the accel_fs FTs */
-	err = mlx5_ttc_fwd_dest(&priv->fs.ttc, MLX5_TT_ANY, &dest);
+	err = mlx5_ttc_fwd_dest(priv->fs.ttc, MLX5_TT_ANY, &dest);
 	if (err) {
 		netdev_err(priv->netdev,
 			   "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index a82be377e9f7..4c4ee524176c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -161,7 +161,7 @@ static int accel_fs_tcp_add_default_rule(struct mlx5e_priv *priv,
 	fs_tcp = priv->fs.accel_tcp;
 	accel_fs_t = &fs_tcp->tables[type];
 
-	dest = mlx5_ttc_get_default_dest(&priv->fs.ttc, fs_accel2tt(type));
+	dest = mlx5_ttc_get_default_dest(priv->fs.ttc, fs_accel2tt(type));
 	rule = mlx5_add_flow_rules(accel_fs_t->t, NULL, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
@@ -307,7 +307,7 @@ static int accel_fs_tcp_disable(struct mlx5e_priv *priv)
 
 	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++) {
 		/* Modify ttc rules destination to point back to the indir TIRs */
-		err = mlx5_ttc_fwd_default_dest(&priv->fs.ttc, fs_accel2tt(i));
+		err = mlx5_ttc_fwd_default_dest(priv->fs.ttc, fs_accel2tt(i));
 		if (err) {
 			netdev_err(priv->netdev,
 				   "%s: modify ttc[%d] default destination failed, err(%d)\n",
@@ -329,7 +329,7 @@ static int accel_fs_tcp_enable(struct mlx5e_priv *priv)
 		dest.ft = priv->fs.accel_tcp->tables[i].t;
 
 		/* Modify ttc rules destination to point on the accel_fs FTs */
-		err = mlx5_ttc_fwd_dest(&priv->fs.ttc, fs_accel2tt(i), &dest);
+		err = mlx5_ttc_fwd_dest(priv->fs.ttc, fs_accel2tt(i), &dest);
 		if (err) {
 			netdev_err(priv->netdev,
 				   "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index ff177bb74bb4..17da23dff0ed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -265,7 +265,8 @@ static int rx_create(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 	accel_esp = priv->ipsec->rx_fs;
 	fs_prot = &accel_esp->fs_prot[type];
 
-	fs_prot->default_dest = mlx5_ttc_get_default_dest(&priv->fs.ttc, fs_esp2tt(type));
+	fs_prot->default_dest =
+		mlx5_ttc_get_default_dest(priv->fs.ttc, fs_esp2tt(type));
 
 	err = rx_err_create_ft(priv, fs_prot, &fs_prot->rx_err);
 	if (err)
@@ -301,7 +302,7 @@ static int rx_ft_get(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 	/* connect */
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest.ft = fs_prot->ft;
-	mlx5_ttc_fwd_dest(&priv->fs.ttc, fs_esp2tt(type), &dest);
+	mlx5_ttc_fwd_dest(priv->fs.ttc, fs_esp2tt(type), &dest);
 
 out:
 	mutex_unlock(&fs_prot->prot_mutex);
@@ -320,7 +321,7 @@ static void rx_ft_put(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 		goto out;
 
 	/* disconnect */
-	mlx5_ttc_fwd_default_dest(&priv->fs.ttc, fs_esp2tt(type));
+	mlx5_ttc_fwd_default_dest(priv->fs.ttc, fs_esp2tt(type));
 
 	/* remove FT */
 	rx_destroy(priv, type);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index 374e262d9917..fe5d82fa6e92 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -120,7 +120,7 @@ static int arfs_disable(struct mlx5e_priv *priv)
 
 	for (i = 0; i < ARFS_NUM_TYPES; i++) {
 		/* Modify ttc rules destination back to their default */
-		err = mlx5_ttc_fwd_default_dest(&priv->fs.ttc, arfs_get_tt(i));
+		err = mlx5_ttc_fwd_default_dest(priv->fs.ttc, arfs_get_tt(i));
 		if (err) {
 			netdev_err(priv->netdev,
 				   "%s: modify ttc[%d] default destination failed, err(%d)\n",
@@ -149,7 +149,7 @@ int mlx5e_arfs_enable(struct mlx5e_priv *priv)
 	for (i = 0; i < ARFS_NUM_TYPES; i++) {
 		dest.ft = priv->fs.arfs->arfs_tables[i].ft.t;
 		/* Modify ttc rules destination to point on the aRFS FTs */
-		err = mlx5_ttc_fwd_dest(&priv->fs.ttc, arfs_get_tt(i), &dest);
+		err = mlx5_ttc_fwd_dest(priv->fs.ttc, arfs_get_tt(i), &dest);
 		if (err) {
 			netdev_err(priv->netdev,
 				   "%s: modify ttc[%d] dest to arfs, failed err(%d)\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index cbad05760551..5c754e9af669 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -718,7 +718,7 @@ static int mlx5e_add_promisc_rule(struct mlx5e_priv *priv)
 	if (!spec)
 		return -ENOMEM;
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest.ft = priv->fs.ttc.t;
+	dest.ft = mlx5_get_ttc_flow_table(priv->fs.ttc);
 
 	rule_p = &priv->fs.promisc.rule;
 	*rule_p = mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
@@ -904,7 +904,8 @@ void mlx5e_set_ttc_params(struct mlx5e_priv *priv,
 	for (tt = 0; tt < MLX5_NUM_TUNNEL_TT; tt++) {
 		ttc_params->tunnel_dests[tt].type =
 			MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-		ttc_params->tunnel_dests[tt].ft = priv->fs.inner_ttc.t;
+		ttc_params->tunnel_dests[tt].ft =
+			mlx5_get_ttc_flow_table(priv->fs.inner_ttc);
 	}
 }
 
@@ -938,7 +939,7 @@ static int mlx5e_add_l2_flow_rule(struct mlx5e_priv *priv,
 			       outer_headers.dmac_47_16);
 
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest.ft = priv->fs.ttc.t;
+	dest.ft = mlx5_get_ttc_flow_table(priv->fs.ttc);
 
 	switch (type) {
 	case MLX5E_FULLMATCH:
@@ -1234,9 +1235,45 @@ static void mlx5e_destroy_vlan_table(struct mlx5e_priv *priv)
 	kvfree(priv->fs.vlan);
 }
 
-int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
+static void mlx5e_destroy_inner_ttc_table(struct mlx5e_priv *priv)
+{
+	if (!mlx5_tunnel_inner_ft_supported(priv->mdev))
+		return;
+	mlx5_destroy_ttc_table(priv->fs.inner_ttc);
+}
+
+void mlx5e_destroy_ttc_table(struct mlx5e_priv *priv)
+{
+	mlx5_destroy_ttc_table(priv->fs.ttc);
+}
+
+static int mlx5e_create_inner_ttc_table(struct mlx5e_priv *priv)
+{
+	struct ttc_params ttc_params = {};
+
+	if (!mlx5_tunnel_inner_ft_supported(priv->mdev))
+		return 0;
+
+	mlx5e_set_inner_ttc_params(priv, &ttc_params);
+	priv->fs.inner_ttc = mlx5_create_ttc_table(priv->mdev, &ttc_params);
+	if (IS_ERR(priv->fs.inner_ttc))
+		return PTR_ERR(priv->fs.inner_ttc);
+	return 0;
+}
+
+int mlx5e_create_ttc_table(struct mlx5e_priv *priv)
 {
 	struct ttc_params ttc_params = {};
+
+	mlx5e_set_ttc_params(priv, &ttc_params, true);
+	priv->fs.ttc = mlx5_create_ttc_table(priv->mdev, &ttc_params);
+	if (IS_ERR(priv->fs.ttc))
+		return PTR_ERR(priv->fs.ttc);
+	return 0;
+}
+
+int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
+{
 	int err;
 
 	priv->fs.ns = mlx5_get_flow_namespace(priv->mdev,
@@ -1252,20 +1289,15 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 		priv->netdev->hw_features &= ~NETIF_F_NTUPLE;
 	}
 
-	if (mlx5_tunnel_inner_ft_supported(priv->mdev)) {
-		mlx5e_set_inner_ttc_params(priv, &ttc_params);
-		err = mlx5_create_inner_ttc_table(priv->mdev, &ttc_params,
-						  &priv->fs.inner_ttc);
-		if (err) {
-			netdev_err(priv->netdev,
-				   "Failed to create inner ttc table, err=%d\n",
-				   err);
-			goto err_destroy_arfs_tables;
-		}
+	err = mlx5e_create_inner_ttc_table(priv);
+	if (err) {
+		netdev_err(priv->netdev,
+			   "Failed to create inner ttc table, err=%d\n",
+			   err);
+		goto err_destroy_arfs_tables;
 	}
 
-	mlx5e_set_ttc_params(priv, &ttc_params, true);
-	err = mlx5_create_ttc_table(priv->mdev, &ttc_params, &priv->fs.ttc);
+	err = mlx5e_create_ttc_table(priv);
 	if (err) {
 		netdev_err(priv->netdev, "Failed to create ttc table, err=%d\n",
 			   err);
@@ -1299,10 +1331,9 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 err_destroy_l2_table:
 	mlx5e_destroy_l2_table(priv);
 err_destroy_ttc_table:
-	mlx5_destroy_ttc_table(&priv->fs.ttc);
+	mlx5e_destroy_ttc_table(priv);
 err_destroy_inner_ttc_table:
-	if (mlx5_tunnel_inner_ft_supported(priv->mdev))
-		mlx5_destroy_inner_ttc_table(&priv->fs.inner_ttc);
+	mlx5e_destroy_inner_ttc_table(priv);
 err_destroy_arfs_tables:
 	mlx5e_arfs_destroy_tables(priv);
 
@@ -1314,9 +1345,8 @@ void mlx5e_destroy_flow_steering(struct mlx5e_priv *priv)
 	mlx5e_ptp_free_rx_fs(priv);
 	mlx5e_destroy_vlan_table(priv);
 	mlx5e_destroy_l2_table(priv);
-	mlx5_destroy_ttc_table(&priv->fs.ttc);
-	if (mlx5_tunnel_inner_ft_supported(priv->mdev))
-		mlx5_destroy_inner_ttc_table(&priv->fs.inner_ttc);
+	mlx5e_destroy_ttc_table(priv);
+	mlx5e_destroy_inner_ttc_table(priv);
 	mlx5e_arfs_destroy_tables(priv);
 	mlx5e_ethtool_cleanup_steering(priv);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 9817a176916a..1e520640f7e0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -660,9 +660,11 @@ static int mlx5e_create_rep_ttc_table(struct mlx5e_priv *priv)
 		/* To give uplik rep TTC a lower level for chaining from root ft */
 		ttc_params.ft_attr.level = MLX5E_TTC_FT_LEVEL + 1;
 
-	err = mlx5_create_ttc_table(priv->mdev, &ttc_params, &priv->fs.ttc);
-	if (err) {
-		netdev_err(priv->netdev, "Failed to create rep ttc table, err=%d\n", err);
+	priv->fs.ttc = mlx5_create_ttc_table(priv->mdev, &ttc_params);
+	if (IS_ERR(priv->fs.ttc)) {
+		err = PTR_ERR(priv->fs.ttc);
+		netdev_err(priv->netdev, "Failed to create rep ttc table, err=%d\n",
+			   err);
 		return err;
 	}
 	return 0;
@@ -680,7 +682,7 @@ static int mlx5e_create_rep_root_ft(struct mlx5e_priv *priv)
 		/* non uplik reps will skip any bypass tables and go directly to
 		 * their own ttc
 		 */
-		rpriv->root_ft = priv->fs.ttc.t;
+		rpriv->root_ft = mlx5_get_ttc_flow_table(priv->fs.ttc);
 		return 0;
 	}
 
@@ -794,7 +796,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 err_destroy_root_ft:
 	mlx5e_destroy_rep_root_ft(priv);
 err_destroy_ttc_table:
-	mlx5_destroy_ttc_table(&priv->fs.ttc);
+	mlx5_destroy_ttc_table(priv->fs.ttc);
 err_destroy_rx_res:
 	mlx5e_rx_res_destroy(priv->rx_res);
 err_close_drop_rq:
@@ -809,7 +811,7 @@ static void mlx5e_cleanup_rep_rx(struct mlx5e_priv *priv)
 	mlx5e_ethtool_cleanup_steering(priv);
 	rep_vport_rx_rule_destroy(priv);
 	mlx5e_destroy_rep_root_ft(priv);
-	mlx5_destroy_ttc_table(&priv->fs.ttc);
+	mlx5_destroy_ttc_table(priv->fs.ttc);
 	mlx5e_rx_res_destroy(priv->rx_res);
 	mlx5e_close_drop_rq(&priv->drop_rq);
 	mlx5e_rx_res_free(priv->rx_res);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index afbd0caf31ae..1a606dc8bed5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -345,7 +345,7 @@ struct mlx5e_hairpin {
 	int num_channels;
 	struct mlx5e_rqt indir_rqt;
 	struct mlx5e_tir indir_tir[MLX5E_NUM_INDIR_TIRS];
-	struct mlx5_ttc_table ttc;
+	struct mlx5_ttc_table *ttc;
 };
 
 struct mlx5e_hairpin_entry {
@@ -624,12 +624,15 @@ static int mlx5e_hairpin_rss_init(struct mlx5e_hairpin *hp)
 		goto err_create_indirect_tirs;
 
 	mlx5e_hairpin_set_ttc_params(hp, &ttc_params);
-	err = mlx5_create_ttc_table(priv->mdev, &ttc_params, &hp->ttc);
-	if (err)
+	hp->ttc = mlx5_create_ttc_table(priv->mdev, &ttc_params);
+	if (IS_ERR(hp->ttc)) {
+		err = PTR_ERR(hp->ttc);
 		goto err_create_ttc_table;
+	}
 
 	netdev_dbg(priv->netdev, "add hairpin: using %d channels rss ttc table id %x\n",
-		   hp->num_channels, hp->ttc.t->id);
+		   hp->num_channels,
+		   mlx5_get_ttc_flow_table(priv->fs.ttc)->id);
 
 	return 0;
 
@@ -643,7 +646,7 @@ static int mlx5e_hairpin_rss_init(struct mlx5e_hairpin *hp)
 
 static void mlx5e_hairpin_rss_cleanup(struct mlx5e_hairpin *hp)
 {
-	mlx5_destroy_ttc_table(&hp->ttc);
+	mlx5_destroy_ttc_table(hp->ttc);
 	mlx5e_hairpin_destroy_indirect_tirs(hp);
 	mlx5e_rqt_destroy(&hp->indir_rqt);
 }
@@ -887,7 +890,8 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *priv,
 attach_flow:
 	if (hpe->hp->num_channels > 1) {
 		flow_flag_set(flow, HAIRPIN_RSS);
-		flow->attr->nic_attr->hairpin_ft = hpe->hp->ttc.t;
+		flow->attr->nic_attr->hairpin_ft =
+			mlx5_get_ttc_flow_table(hpe->hp->ttc);
 	} else {
 		flow->attr->nic_attr->hairpin_tirn = mlx5e_tir_get_tirn(&hpe->hp->direct_tir);
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index e04b758f20e3..67571e5040d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -314,7 +314,6 @@ static void mlx5i_cleanup_tx(struct mlx5e_priv *priv)
 
 static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 {
-	struct ttc_params ttc_params = {};
 	int err;
 
 	priv->fs.ns = mlx5_get_flow_namespace(priv->mdev,
@@ -330,8 +329,7 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 		priv->netdev->hw_features &= ~NETIF_F_NTUPLE;
 	}
 
-	mlx5e_set_ttc_params(priv, &ttc_params, true);
-	err = mlx5_create_ttc_table(priv->mdev, &ttc_params, &priv->fs.ttc);
+	err = mlx5e_create_ttc_table(priv);
 	if (err) {
 		netdev_err(priv->netdev, "Failed to create ttc table, err=%d\n",
 			   err);
@@ -348,7 +346,7 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 
 static void mlx5i_destroy_flow_steering(struct mlx5e_priv *priv)
 {
-	mlx5_destroy_ttc_table(&priv->fs.ttc);
+	mlx5e_destroy_ttc_table(priv);
 	mlx5e_arfs_destroy_tables(priv);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c
index 4b54b4127d33..749d17c0057d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c
@@ -25,6 +25,20 @@
 					 MLX5_INNER_TTC_GROUP2_SIZE +\
 					 MLX5_INNER_TTC_GROUP3_SIZE)
 
+/* L3/L4 traffic type classifier */
+struct mlx5_ttc_table {
+	int num_groups;
+	struct mlx5_flow_table *t;
+	struct mlx5_flow_group **g;
+	struct mlx5_ttc_rule rules[MLX5_NUM_TT];
+	struct mlx5_flow_handle *tunnel_rules[MLX5_NUM_TUNNEL_TT];
+};
+
+struct mlx5_flow_table *mlx5_get_ttc_flow_table(struct mlx5_ttc_table *ttc)
+{
+	return ttc->t;
+}
+
 static void mlx5_cleanup_ttc_rules(struct mlx5_ttc_table *ttc)
 {
 	int i;
@@ -473,19 +487,23 @@ static int mlx5_create_inner_ttc_table_groups(struct mlx5_ttc_table *ttc)
 	return err;
 }
 
-int mlx5_create_inner_ttc_table(struct mlx5_core_dev *dev,
-				struct ttc_params *params,
-				struct mlx5_ttc_table *ttc)
+struct mlx5_ttc_table *mlx5_create_inner_ttc_table(struct mlx5_core_dev *dev,
+						   struct ttc_params *params)
 {
+	struct mlx5_ttc_table *ttc;
 	int err;
 
+	ttc = kvzalloc(sizeof(*ttc), GFP_KERNEL);
+	if (!ttc)
+		return ERR_PTR(-ENOMEM);
+
 	WARN_ON_ONCE(params->ft_attr.max_fte);
 	params->ft_attr.max_fte = MLX5_INNER_TTC_TABLE_SIZE;
 	ttc->t = mlx5_create_flow_table(params->ns, &params->ft_attr);
 	if (IS_ERR(ttc->t)) {
 		err = PTR_ERR(ttc->t);
-		ttc->t = NULL;
-		return err;
+		kvfree(ttc);
+		return ERR_PTR(err);
 	}
 
 	err = mlx5_create_inner_ttc_table_groups(ttc);
@@ -496,11 +514,11 @@ int mlx5_create_inner_ttc_table(struct mlx5_core_dev *dev,
 	if (err)
 		goto destroy_ft;
 
-	return 0;
+	return ttc;
 
 destroy_ft:
 	mlx5_destroy_ttc_table(ttc);
-	return err;
+	return ERR_PTR(err);
 }
 
 void mlx5_destroy_ttc_table(struct mlx5_ttc_table *ttc)
@@ -514,32 +532,31 @@ void mlx5_destroy_ttc_table(struct mlx5_ttc_table *ttc)
 		ttc->g[i] = NULL;
 	}
 
-	ttc->num_groups = 0;
 	kfree(ttc->g);
 	mlx5_destroy_flow_table(ttc->t);
-	ttc->t = NULL;
+	kvfree(ttc);
 }
 
-void mlx5_destroy_inner_ttc_table(struct mlx5_ttc_table *ttc)
-{
-	mlx5_destroy_ttc_table(ttc);
-}
-
-int mlx5_create_ttc_table(struct mlx5_core_dev *dev, struct ttc_params *params,
-			  struct mlx5_ttc_table *ttc)
+struct mlx5_ttc_table *mlx5_create_ttc_table(struct mlx5_core_dev *dev,
+					     struct ttc_params *params)
 {
 	bool match_ipv_outer =
 		MLX5_CAP_FLOWTABLE_NIC_RX(dev,
 					  ft_field_support.outer_ip_version);
+	struct mlx5_ttc_table *ttc;
 	int err;
 
+	ttc = kvzalloc(sizeof(*ttc), GFP_KERNEL);
+	if (!ttc)
+		return ERR_PTR(-ENOMEM);
+
 	WARN_ON_ONCE(params->ft_attr.max_fte);
 	params->ft_attr.max_fte = MLX5_TTC_TABLE_SIZE;
 	ttc->t = mlx5_create_flow_table(params->ns, &params->ft_attr);
 	if (IS_ERR(ttc->t)) {
 		err = PTR_ERR(ttc->t);
-		ttc->t = NULL;
-		return err;
+		kvfree(ttc);
+		return ERR_PTR(err);
 	}
 
 	err = mlx5_create_ttc_table_groups(ttc, match_ipv_outer);
@@ -550,10 +567,11 @@ int mlx5_create_ttc_table(struct mlx5_core_dev *dev, struct ttc_params *params,
 	if (err)
 		goto destroy_ft;
 
-	return 0;
+	return ttc;
+
 destroy_ft:
 	mlx5_destroy_ttc_table(ttc);
-	return err;
+	return ERR_PTR(err);
 }
 
 int mlx5_ttc_fwd_dest(struct mlx5_ttc_table *ttc, enum mlx5_traffic_types type,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.h
index 1010e00c10bd..ce95be8f8382 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_ttc.h
@@ -37,14 +37,7 @@ struct mlx5_ttc_rule {
 	struct mlx5_flow_destination default_dest;
 };
 
-/* L3/L4 traffic type classifier */
-struct mlx5_ttc_table {
-	int num_groups;
-	struct mlx5_flow_table *t;
-	struct mlx5_flow_group **g;
-	struct mlx5_ttc_rule rules[MLX5_NUM_TT];
-	struct mlx5_flow_handle *tunnel_rules[MLX5_NUM_TUNNEL_TT];
-};
+struct mlx5_ttc_table;
 
 struct ttc_params {
 	struct mlx5_flow_namespace *ns;
@@ -54,14 +47,14 @@ struct ttc_params {
 	struct mlx5_flow_destination tunnel_dests[MLX5_NUM_TUNNEL_TT];
 };
 
-int mlx5_create_ttc_table(struct mlx5_core_dev *dev, struct ttc_params *params,
-			  struct mlx5_ttc_table *ttc);
+struct mlx5_flow_table *mlx5_get_ttc_flow_table(struct mlx5_ttc_table *ttc);
+
+struct mlx5_ttc_table *mlx5_create_ttc_table(struct mlx5_core_dev *dev,
+					     struct ttc_params *params);
 void mlx5_destroy_ttc_table(struct mlx5_ttc_table *ttc);
 
-int mlx5_create_inner_ttc_table(struct mlx5_core_dev *dev,
-				struct ttc_params *params,
-				struct mlx5_ttc_table *ttc);
-void mlx5_destroy_inner_ttc_table(struct mlx5_ttc_table *ttc);
+struct mlx5_ttc_table *mlx5_create_inner_ttc_table(struct mlx5_core_dev *dev,
+						   struct ttc_params *params);
 
 int mlx5_ttc_fwd_dest(struct mlx5_ttc_table *ttc, enum mlx5_traffic_types type,
 		      struct mlx5_flow_destination *new_dest);
-- 
2.31.1

