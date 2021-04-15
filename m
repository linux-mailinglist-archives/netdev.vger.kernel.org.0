Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4135C3615BA
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 00:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237620AbhDOWx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 18:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237571AbhDOWxr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 18:53:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A781B61131;
        Thu, 15 Apr 2021 22:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618527204;
        bh=wASNzTEQeRkwVYVbO4HyH/2Qt2Yk3jbGJD7L07Jm0y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OemglftIKZEX1NESoxG5HIiXcJBzJGL9wYrU+s2JVmZJMwFNC6b6kTZKZmg6nLRg/
         +yTTv/mIuG/YGv4rFS34QZJeRIdjAti8CD9/RY0X01dyleJVg+u1uwZ+khs6uIN4Rs
         7p1inR4MxNxgpbF4WeFJTH13rIQjMFdps78/M6MhMP/YMNpPr4jz8A5NBN1Pp0ELPo
         tUaoX0bDe9OcdjP1Fio0Gw0MBtJt3VjyN+9eZJdBOAkNsY6xYAAjBscgfVfBOYIUWn
         d05/mYidgFGla3RNllj+xpcQXuMDTiwVitS7+TxEd+JIa/l4zf6h5ycj7/muXEYJfS
         tuEH41OiWOkDQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        saeedm@nvidia.com, leon@kernel.org, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        mkubecek@suse.cz, ariela@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 6/6] mlx5: implement ethtool::get_fec_stats
Date:   Thu, 15 Apr 2021 15:53:18 -0700
Message-Id: <20210415225318.2726095-7-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210415225318.2726095-1-kuba@kernel.org>
References: <20210415225318.2726095-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report corrected bits.

v2: catch reg access errors (Saeed)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  9 ++++++
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 29 +++++++++++++++++--
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  2 ++
 3 files changed, 38 insertions(+), 2 deletions(-)

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
index ae0570ea08bf..353513bd0d5e 100644
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
 
@@ -1015,6 +1017,29 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(phy)
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
+	if (mlx5_core_access_reg(mdev, in, sz, ppcnt_phy_statistical,
+				 sz, MLX5_REG_PPCNT, 0, 0))
+		return;
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

