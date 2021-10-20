Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6323F435214
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhJTR6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:58:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230360AbhJTR6p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 13:58:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6842361391;
        Wed, 20 Oct 2021 17:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634752590;
        bh=p8Y+J81QzNGdDvwGOkrfgOKajAbHq6Lq23uFhT1FR4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KCTC/Dso5NPHqvG4MatMpaQu5+k6yuLjHfwfVgsgsiHi1ndVJ/txtbfCeJlpVM+Qu
         shvlAymkFtu0zOJex59VUX46UjvQ5jliETBjT0+XlQOjof6jl7vNNRErGCshhs1z5A
         ISKFPdZhFtuOtkZjETtydlkaOFYN04MnwIcHmITCuFjfZ9smTlx+TQFyoK2rvWll76
         esUMIYNQt16oz57BOxSJ+zWybCt7yfBAF2BqWk/R9wsAUsWUPTe3JdO/9WncV3j4We
         XRD188hN+faLKrw0qBaPZTX4MYhrqGUWQSwJKwZuM3l0O4Ta49y/OXAJ0QIa1vcJxI
         reNWsN2/Hi5jg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 3/5] net/mlx5e: Fix vlan data lost during suspend flow
Date:   Wed, 20 Oct 2021 10:56:25 -0700
Message-Id: <20211020175627.269138-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020175627.269138-1-saeed@kernel.org>
References: <20211020175627.269138-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

During suspend flow the driver calls mlx5e_destroy_vlan_table() which
does not only delete the vlans steering flow rules, but also frees the
data on currently active vlans, thus it is not restored during resume
flow.

This fix keeps the vlan data on suspend flow and frees it only on driver
remove flow.

Fixes: 6783f0a21a3c ("net/mlx5e: Dynamic alloc vlan table for netdev when needed")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  3 ++
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 28 +++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  7 +++++
 3 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 41684a6c44e9..a88a1a48229f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -199,6 +199,9 @@ void mlx5e_disable_cvlan_filter(struct mlx5e_priv *priv);
 int mlx5e_create_flow_steering(struct mlx5e_priv *priv);
 void mlx5e_destroy_flow_steering(struct mlx5e_priv *priv);
 
+int mlx5e_fs_init(struct mlx5e_priv *priv);
+void mlx5e_fs_cleanup(struct mlx5e_priv *priv);
+
 int mlx5e_add_vlan_trap(struct mlx5e_priv *priv, int  trap_id, int tir_num);
 void mlx5e_remove_vlan_trap(struct mlx5e_priv *priv);
 int mlx5e_add_mac_trap(struct mlx5e_priv *priv, int  trap_id, int tir_num);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index c06b4b938ae7..d226cc5ab1d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -1186,10 +1186,6 @@ static int mlx5e_create_vlan_table(struct mlx5e_priv *priv)
 	struct mlx5e_flow_table *ft;
 	int err;
 
-	priv->fs.vlan = kvzalloc(sizeof(*priv->fs.vlan), GFP_KERNEL);
-	if (!priv->fs.vlan)
-		return -ENOMEM;
-
 	ft = &priv->fs.vlan->ft;
 	ft->num_groups = 0;
 
@@ -1198,10 +1194,8 @@ static int mlx5e_create_vlan_table(struct mlx5e_priv *priv)
 	ft_attr.prio = MLX5E_NIC_PRIO;
 
 	ft->t = mlx5_create_flow_table(priv->fs.ns, &ft_attr);
-	if (IS_ERR(ft->t)) {
-		err = PTR_ERR(ft->t);
-		goto err_free_t;
-	}
+	if (IS_ERR(ft->t))
+		return PTR_ERR(ft->t);
 
 	ft->g = kcalloc(MLX5E_NUM_VLAN_GROUPS, sizeof(*ft->g), GFP_KERNEL);
 	if (!ft->g) {
@@ -1221,9 +1215,6 @@ static int mlx5e_create_vlan_table(struct mlx5e_priv *priv)
 	kfree(ft->g);
 err_destroy_vlan_table:
 	mlx5_destroy_flow_table(ft->t);
-err_free_t:
-	kvfree(priv->fs.vlan);
-	priv->fs.vlan = NULL;
 
 	return err;
 }
@@ -1232,7 +1223,6 @@ static void mlx5e_destroy_vlan_table(struct mlx5e_priv *priv)
 {
 	mlx5e_del_vlan_rules(priv);
 	mlx5e_destroy_flow_table(&priv->fs.vlan->ft);
-	kvfree(priv->fs.vlan);
 }
 
 static void mlx5e_destroy_inner_ttc_table(struct mlx5e_priv *priv)
@@ -1351,3 +1341,17 @@ void mlx5e_destroy_flow_steering(struct mlx5e_priv *priv)
 	mlx5e_arfs_destroy_tables(priv);
 	mlx5e_ethtool_cleanup_steering(priv);
 }
+
+int mlx5e_fs_init(struct mlx5e_priv *priv)
+{
+	priv->fs.vlan = kvzalloc(sizeof(*priv->fs.vlan), GFP_KERNEL);
+	if (!priv->fs.vlan)
+		return -ENOMEM;
+	return 0;
+}
+
+void mlx5e_fs_cleanup(struct mlx5e_priv *priv)
+{
+	kvfree(priv->fs.vlan);
+	priv->fs.vlan = NULL;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 09c8b71b186c..41ef6eb70a58 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4578,6 +4578,12 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 
 	mlx5e_timestamp_init(priv);
 
+	err = mlx5e_fs_init(priv);
+	if (err) {
+		mlx5_core_err(mdev, "FS initialization failed, %d\n", err);
+		return err;
+	}
+
 	err = mlx5e_ipsec_init(priv);
 	if (err)
 		mlx5_core_err(mdev, "IPSec initialization failed, %d\n", err);
@@ -4595,6 +4601,7 @@ static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 	mlx5e_health_destroy_reporters(priv);
 	mlx5e_tls_cleanup(priv);
 	mlx5e_ipsec_cleanup(priv);
+	mlx5e_fs_cleanup(priv);
 }
 
 static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
-- 
2.31.1

