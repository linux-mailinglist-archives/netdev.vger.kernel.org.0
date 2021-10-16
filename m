Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B0F42FF76
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 02:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239365AbhJPAlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 20:41:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239313AbhJPAlN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 20:41:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0DEF6124D;
        Sat, 16 Oct 2021 00:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634344746;
        bh=/DNf3TfvmYzABMEZZtuUhvvZ/4AeajXYRo7hAL5MExw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dE8VpzI0GdxdtmxzCQccgph424cPFS+Av1Nnmo3RcQTaU4gEf3fBO7gis9nCsvO05
         kQpoG5oQmxK5K9MUtz47ZvXVllb3UMYkHdBjOLHmf/zHGw/6Cs2LWnv9cpyC/HuEHI
         ABAS0Fh9lmSKMTKC3mnet5JJi0q6ixtRWk7d6hzkYar5vdnKqJjVXkk6mUpoVtJPU9
         J0Pj7+VVB7YrqttG/Bfz4WOH2h9pyBxEh7RBaMpzMtO347o+rqGmSvPcg5mxQCdAlB
         p9hx40z19GFN6MV7/EfDl5JJGFgMmDA1fCmIRt9o1Jc3AeYSzhflk4hDehXAOFqI43
         9Qpo6XXsp+vwg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moosa Baransi <moosab@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/13] net/mlx5i: Enable Rx steering for IPoIB via ethtool
Date:   Fri, 15 Oct 2021 17:38:54 -0700
Message-Id: <20211016003902.57116-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211016003902.57116-1-saeed@kernel.org>
References: <20211016003902.57116-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moosa Baransi <moosab@nvidia.com>

Enable steering IPoIB packets via ethtool, the same way it is done today
for Ethernet packets.

Signed-off-by: Moosa Baransi <moosab@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  8 ++---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  6 ++--
 .../mellanox/mlx5/core/en_fs_ethtool.c        |  6 ++--
 .../mellanox/mlx5/core/ipoib/ethtool.c        | 30 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  3 ++
 5 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 41684a6c44e9..1c23453a041d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -125,15 +125,15 @@ struct mlx5e_ethtool_steering {
 
 void mlx5e_ethtool_init_steering(struct mlx5e_priv *priv);
 void mlx5e_ethtool_cleanup_steering(struct mlx5e_priv *priv);
-int mlx5e_ethtool_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd);
-int mlx5e_ethtool_get_rxnfc(struct net_device *dev,
+int mlx5e_ethtool_set_rxnfc(struct mlx5e_priv *priv, struct ethtool_rxnfc *cmd);
+int mlx5e_ethtool_get_rxnfc(struct mlx5e_priv *priv,
 			    struct ethtool_rxnfc *info, u32 *rule_locs);
 #else
 static inline void mlx5e_ethtool_init_steering(struct mlx5e_priv *priv)    { }
 static inline void mlx5e_ethtool_cleanup_steering(struct mlx5e_priv *priv) { }
-static inline int mlx5e_ethtool_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
+static inline int mlx5e_ethtool_set_rxnfc(struct mlx5e_priv *priv, struct ethtool_rxnfc *cmd)
 { return -EOPNOTSUPP; }
-static inline int mlx5e_ethtool_get_rxnfc(struct net_device *dev,
+static inline int mlx5e_ethtool_get_rxnfc(struct mlx5e_priv *priv,
 					  struct ethtool_rxnfc *info, u32 *rule_locs)
 { return -EOPNOTSUPP; }
 #endif /* CONFIG_MLX5_EN_RXNFC */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 7a97e0e21fd7..25926e581d18 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -2137,12 +2137,14 @@ int mlx5e_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info,
 		return 0;
 	}
 
-	return mlx5e_ethtool_get_rxnfc(dev, info, rule_locs);
+	return mlx5e_ethtool_get_rxnfc(priv, info, rule_locs);
 }
 
 int mlx5e_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 {
-	return mlx5e_ethtool_set_rxnfc(dev, cmd);
+	struct mlx5e_priv *priv = netdev_priv(dev);
+
+	return mlx5e_ethtool_set_rxnfc(priv, cmd);
 }
 
 static int query_port_status_opcode(struct mlx5_core_dev *mdev, u32 *status_opcode)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
index 03693fa74a70..81ebf281cdb4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
@@ -937,9 +937,8 @@ static int mlx5e_get_rss_hash_opt(struct mlx5e_priv *priv,
 	return 0;
 }
 
-int mlx5e_ethtool_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
+int mlx5e_ethtool_set_rxnfc(struct mlx5e_priv *priv, struct ethtool_rxnfc *cmd)
 {
-	struct mlx5e_priv *priv = netdev_priv(dev);
 	int err = 0;
 
 	switch (cmd->cmd) {
@@ -960,10 +959,9 @@ int mlx5e_ethtool_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 	return err;
 }
 
-int mlx5e_ethtool_get_rxnfc(struct net_device *dev,
+int mlx5e_ethtool_get_rxnfc(struct mlx5e_priv *priv,
 			    struct ethtool_rxnfc *info, u32 *rule_locs)
 {
-	struct mlx5e_priv *priv = netdev_priv(dev);
 	int err = 0;
 
 	switch (info->cmd) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index 0c8594c7df21..ee0eb4a4b819 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -33,6 +33,11 @@
 #include "en.h"
 #include "ipoib.h"
 
+static u32 mlx5i_flow_type_mask(u32 flow_type)
+{
+	return flow_type & ~(FLOW_EXT | FLOW_MAC_EXT | FLOW_RSS);
+}
+
 static void mlx5i_get_drvinfo(struct net_device *dev,
 			      struct ethtool_drvinfo *drvinfo)
 {
@@ -217,6 +222,27 @@ static int mlx5i_get_link_ksettings(struct net_device *netdev,
 	return 0;
 }
 
+#ifdef CONFIG_MLX5_EN_RXNFC
+static int mlx5i_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
+{
+	struct mlx5e_priv *priv = mlx5i_epriv(dev);
+	struct ethtool_rx_flow_spec *fs = &cmd->fs;
+
+	if (mlx5i_flow_type_mask(fs->flow_type) == ETHER_FLOW)
+		return -EINVAL;
+
+	return mlx5e_ethtool_set_rxnfc(priv, cmd);
+}
+
+static int mlx5i_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info,
+			   u32 *rule_locs)
+{
+	struct mlx5e_priv *priv = mlx5i_epriv(dev);
+
+	return mlx5e_ethtool_get_rxnfc(priv, info, rule_locs);
+}
+#endif
+
 const struct ethtool_ops mlx5i_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES |
@@ -233,6 +259,10 @@ const struct ethtool_ops mlx5i_ethtool_ops = {
 	.get_coalesce       = mlx5i_get_coalesce,
 	.set_coalesce       = mlx5i_set_coalesce,
 	.get_ts_info        = mlx5i_get_ts_info,
+#ifdef CONFIG_MLX5_EN_RXNFC
+	.get_rxnfc          = mlx5i_get_rxnfc,
+	.set_rxnfc          = mlx5i_set_rxnfc,
+#endif
 	.get_link_ksettings = mlx5i_get_link_ksettings,
 	.get_link           = ethtool_op_get_link,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index f7ebc1f9283f..3b8d8ada1a01 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -336,6 +336,8 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 		goto err_destroy_arfs_tables;
 	}
 
+	mlx5e_ethtool_init_steering(priv);
+
 	return 0;
 
 err_destroy_arfs_tables:
@@ -348,6 +350,7 @@ static void mlx5i_destroy_flow_steering(struct mlx5e_priv *priv)
 {
 	mlx5e_destroy_ttc_table(priv);
 	mlx5e_arfs_destroy_tables(priv);
+	mlx5e_ethtool_cleanup_steering(priv);
 }
 
 static int mlx5i_init_rx(struct mlx5e_priv *priv)
-- 
2.31.1

