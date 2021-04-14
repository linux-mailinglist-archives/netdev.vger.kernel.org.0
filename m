Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3107135EB8C
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 05:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbhDNDpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 23:45:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346987AbhDNDp0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 23:45:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 050E6613CC;
        Wed, 14 Apr 2021 03:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618371905;
        bh=8A5lZhz4VPC/D5uhVkzzP2eEv/lpDgk9bG0EtXRY1cM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uPQf36vpM+sWQCokfV2brAVv62RA53SvmURPBVvmy1aDJYalV+Yg1ikiq/+C+M/8S
         /uWTFJyym8UM36Vb1ox1F7klJNrQFHN1JVYmEsCwHLXlQY4JlOIS8l4WSSYsxR0okv
         sY1ExgPIOObgqh3UXqcne4AEox1AGU4G6BLmF7Opb/nbFc64Ul/7Yi+qjlMqUs4nz6
         KFE4la89EZCD1AaTgTQm9G9cuEpBnt4eIGwMwrBlYMZYsIBMtaK8cXaNNp/Kby0JlN
         HQgXE/8QQWv2xxAyd6vBm8iyehZ7bZkoBUBISgEZ/75A6H5A83LsrS+dTZbdIgoKOK
         apgWbbIc4tG8g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        saeedm@nvidia.com, leon@kernel.org, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        mkubecek@suse.cz, ariela@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 6/6] mlx5: implement ethtool::get_fec_stats
Date:   Tue, 13 Apr 2021 20:44:54 -0700
Message-Id: <20210414034454.1970967-7-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414034454.1970967-1-kuba@kernel.org>
References: <20210414034454.1970967-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report corrected bits.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  9 ++++++
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 28 +++++++++++++++++--
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  2 ++
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index c8057a44d5ab..f17690cbeeea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1602,6 +1602,14 @@ static int mlx5e_set_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
 	return mlx5_set_port_wol(mdev, mlx5_wol_mode);
 }
 
+static void mlx5e_get_fec_stats(struct net_device *netdev,
+				struct ethtool_fec_stats *fec_stats)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+
+	mlx5e_stats_fec_get(priv, fec_stats);
+}
+
 static int mlx5e_get_fecparam(struct net_device *netdev,
 			      struct ethtool_fecparam *fecparam)
 {
@@ -2209,6 +2217,7 @@ const struct ethtool_ops mlx5e_ethtool_ops = {
 	.self_test         = mlx5e_self_test,
 	.get_msglevel      = mlx5e_get_msglevel,
 	.set_msglevel      = mlx5e_set_msglevel,
+	.get_fec_stats     = mlx5e_get_fec_stats,
 	.get_fecparam      = mlx5e_get_fecparam,
 	.set_fecparam      = mlx5e_set_fecparam,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index ae0570ea08bf..aca096cc2c1c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -768,10 +768,10 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(802_3)
 	mlx5_core_access_reg(mdev, in, sz, out, sz, MLX5_REG_PPCNT, 0, 0);
 }
 
-#define MLX5E_READ_CTR64_BE_F(ptr, c)			\
+#define MLX5E_READ_CTR64_BE_F(ptr, set, c)		\
 	be64_to_cpu(*(__be64 *)((char *)ptr +		\
 		MLX5_BYTE_OFF(ppcnt_reg,		\
-			counter_set.eth_802_3_cntrs_grp_data_layout.c##_high)))
+			      counter_set.set.c##_high)))
 
 void mlx5e_stats_pause_get(struct mlx5e_priv *priv,
 			   struct ethtool_pause_stats *pause_stats)
@@ -791,9 +791,11 @@ void mlx5e_stats_pause_get(struct mlx5e_priv *priv,
 
 	pause_stats->tx_pause_frames =
 		MLX5E_READ_CTR64_BE_F(ppcnt_ieee_802_3,
+				      eth_802_3_cntrs_grp_data_layout,
 				      a_pause_mac_ctrl_frames_transmitted);
 	pause_stats->rx_pause_frames =
 		MLX5E_READ_CTR64_BE_F(ppcnt_ieee_802_3,
+				      eth_802_3_cntrs_grp_data_layout,
 				      a_pause_mac_ctrl_frames_received);
 }
 
@@ -1015,6 +1017,28 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(phy)
 	mlx5_core_access_reg(mdev, in, sz, out, sz, MLX5_REG_PPCNT, 0, 0);
 }
 
+void mlx5e_stats_fec_get(struct mlx5e_priv *priv,
+			 struct ethtool_fec_stats *fec_stats)
+{
+	u32 ppcnt_phy_statistical[MLX5_ST_SZ_DW(ppcnt_reg)];
+	struct mlx5_core_dev *mdev = priv->mdev;
+	u32 in[MLX5_ST_SZ_DW(ppcnt_reg)] = {0};
+	int sz = MLX5_ST_SZ_BYTES(ppcnt_reg);
+
+	if (!MLX5_CAP_PCAM_FEATURE(mdev, ppcnt_statistical_group))
+		return;
+
+	MLX5_SET(ppcnt_reg, in, local_port, 1);
+	MLX5_SET(ppcnt_reg, in, grp, MLX5_PHYSICAL_LAYER_STATISTICAL_GROUP);
+	mlx5_core_access_reg(mdev, in, sz, ppcnt_phy_statistical,
+			     sz, MLX5_REG_PPCNT, 0, 0);
+
+	fec_stats->corrected_bits.total =
+		MLX5E_READ_CTR64_BE_F(ppcnt_phy_statistical,
+				      phys_layer_statistical_cntrs,
+				      phy_corrected_bits);
+}
+
 #define PPORT_ETH_EXT_OFF(c) \
 	MLX5_BYTE_OFF(ppcnt_reg, \
 		      counter_set.eth_extended_cntrs_grp_data_layout.c##_high)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 21d3b8747f93..3f0789e51eed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -114,6 +114,8 @@ void mlx5e_stats_update_ndo_stats(struct mlx5e_priv *priv);
 
 void mlx5e_stats_pause_get(struct mlx5e_priv *priv,
 			   struct ethtool_pause_stats *pause_stats);
+void mlx5e_stats_fec_get(struct mlx5e_priv *priv,
+			 struct ethtool_fec_stats *fec_stats);
 
 /* Concrete NIC Stats */
 
-- 
2.30.2

