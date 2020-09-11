Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5ABD266936
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 21:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgIKTxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 15:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725817AbgIKTxL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 15:53:11 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C011B21D40;
        Fri, 11 Sep 2020 19:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599853990;
        bh=SgGaruUhbNKZhfT9Vgnq5KsepX5ELpF/tfeZ83x7HnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JaeOIdazLrQvmCSHCqJ1O84MUF4rViYtRNrVYj6u/Im3oiQN96eRBRZ9K7Qz5/6ax
         7ZbCBqxz4L6gux37Ra3PPhvsn/ALilWypXSzyp9uh8/K3hIdW5koX6wrW7LpNrTbif
         QIYa3nOg4nlDfi24aaz+c033/QVW+oWnS+/kyTKw=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com, andrew@lunn.ch,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 6/8] mlx5: add pause frame stats
Date:   Fri, 11 Sep 2020 12:52:56 -0700
Message-Id: <20200911195258.1048468-7-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200911195258.1048468-1-kuba@kernel.org>
References: <20200911195258.1048468-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Plumb through all the indirection and copy some code from
ethtool -S. The names of the group indicate that these are
the stats we are after.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 ++
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 15 ++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  9 ++++++
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 30 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  3 ++
 5 files changed, 59 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 4f33658da25a..615ac0dc248e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1053,6 +1053,8 @@ int mlx5e_ethtool_get_ts_info(struct mlx5e_priv *priv,
 			      struct ethtool_ts_info *info);
 int mlx5e_ethtool_flash_device(struct mlx5e_priv *priv,
 			       struct ethtool_flash *flash);
+void mlx5e_ethtool_get_pause_stats(struct mlx5e_priv *priv,
+				   struct ethtool_pause_stats *pause_stats);
 void mlx5e_ethtool_get_pauseparam(struct mlx5e_priv *priv,
 				  struct ethtool_pauseparam *pauseparam);
 int mlx5e_ethtool_set_pauseparam(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 5cb1e4839eb7..c9fb3c018b96 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1341,6 +1341,20 @@ static int mlx5e_set_tunable(struct net_device *dev,
 	return err;
 }
 
+void mlx5e_ethtool_get_pause_stats(struct mlx5e_priv *priv,
+				   struct ethtool_pause_stats *pause_stats)
+{
+	mlx5e_stats_pause_get(priv, pause_stats);
+}
+
+static void mlx5e_get_pause_stats(struct net_device *netdev,
+				  struct ethtool_pause_stats *pause_stats)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+
+	mlx5e_ethtool_get_pause_stats(priv, pause_stats);
+}
+
 void mlx5e_ethtool_get_pauseparam(struct mlx5e_priv *priv,
 				  struct ethtool_pauseparam *pauseparam)
 {
@@ -2033,6 +2047,7 @@ const struct ethtool_ops mlx5e_ethtool_ops = {
 	.set_rxnfc         = mlx5e_set_rxnfc,
 	.get_tunable       = mlx5e_get_tunable,
 	.set_tunable       = mlx5e_set_tunable,
+	.get_pause_stats   = mlx5e_get_pause_stats,
 	.get_pauseparam    = mlx5e_get_pauseparam,
 	.set_pauseparam    = mlx5e_set_pauseparam,
 	.get_ts_info       = mlx5e_get_ts_info,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 135ee26881c9..856ae4c8cb25 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -288,6 +288,14 @@ static u32 mlx5e_rep_get_rxfh_indir_size(struct net_device *netdev)
 	return mlx5e_ethtool_get_rxfh_indir_size(priv);
 }
 
+static void mlx5e_uplink_rep_get_pause_stats(struct net_device *netdev,
+					     struct ethtool_pause_stats *stats)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+
+	mlx5e_ethtool_get_pause_stats(priv, stats);
+}
+
 static void mlx5e_uplink_rep_get_pauseparam(struct net_device *netdev,
 					    struct ethtool_pauseparam *pauseparam)
 {
@@ -362,6 +370,7 @@ static const struct ethtool_ops mlx5e_uplink_rep_ethtool_ops = {
 	.set_rxfh          = mlx5e_set_rxfh,
 	.get_rxnfc         = mlx5e_get_rxnfc,
 	.set_rxnfc         = mlx5e_set_rxnfc,
+	.get_pause_stats   = mlx5e_uplink_rep_get_pause_stats,
 	.get_pauseparam    = mlx5e_uplink_rep_get_pauseparam,
 	.set_pauseparam    = mlx5e_uplink_rep_set_pauseparam,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index e3b2f59408e6..97b03aa7535f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -677,6 +677,36 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(802_3)
 	mlx5_core_access_reg(mdev, in, sz, out, sz, MLX5_REG_PPCNT, 0, 0);
 }
 
+#define MLX5E_READ_CTR64_BE_F(ptr, c)			\
+	be64_to_cpu(*(__be64 *)((char *)ptr +		\
+		MLX5_BYTE_OFF(ppcnt_reg,		\
+			counter_set.eth_802_3_cntrs_grp_data_layout.c##_high)))
+
+void mlx5e_stats_pause_get(struct mlx5e_priv *priv,
+			   struct ethtool_pause_stats *pause_stats)
+{
+	struct mlx5e_pport_stats *pstats = &priv->stats.pport;
+	struct mlx5_core_dev *mdev = priv->mdev;
+	u32 in[MLX5_ST_SZ_DW(ppcnt_reg)] = {0};
+	int sz = MLX5_ST_SZ_BYTES(ppcnt_reg);
+	void *out;
+
+	if (!MLX5_BASIC_PPCNT_SUPPORTED(mdev))
+		return;
+
+	MLX5_SET(ppcnt_reg, in, local_port, 1);
+	out = pstats->IEEE_802_3_counters;
+	MLX5_SET(ppcnt_reg, in, grp, MLX5_IEEE_802_3_COUNTERS_GROUP);
+	mlx5_core_access_reg(mdev, in, sz, out, sz, MLX5_REG_PPCNT, 0, 0);
+
+	pause_stats->tx_pause_frames =
+		MLX5E_READ_CTR64_BE_F(&priv->stats.pport.IEEE_802_3_counters,
+				      a_pause_mac_ctrl_frames_transmitted);
+	pause_stats->rx_pause_frames =
+		MLX5E_READ_CTR64_BE_F(&priv->stats.pport.IEEE_802_3_counters,
+				      a_pause_mac_ctrl_frames_received);
+}
+
 #define PPORT_2863_OFF(c) \
 	MLX5_BYTE_OFF(ppcnt_reg, \
 		      counter_set.eth_2863_cntrs_grp_data_layout.c##_high)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 2e1cca1923b9..9d9ee269a041 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -104,6 +104,9 @@ void mlx5e_stats_update(struct mlx5e_priv *priv);
 void mlx5e_stats_fill(struct mlx5e_priv *priv, u64 *data, int idx);
 void mlx5e_stats_fill_strings(struct mlx5e_priv *priv, u8 *data);
 
+void mlx5e_stats_pause_get(struct mlx5e_priv *priv,
+			   struct ethtool_pause_stats *pause_stats);
+
 /* Concrete NIC Stats */
 
 struct mlx5e_sw_stats {
-- 
2.26.2

