Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E043628A4
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 21:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243431AbhDPT2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 15:28:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243388AbhDPT2Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 15:28:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BDDB613BB;
        Fri, 16 Apr 2021 19:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618601279;
        bh=DBgSdS/7qOS901XCFHQcgBrx7flqpvdDh6vG7gusX4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=imLfOty0Pxjb+v084noPY9vU/or0otS/bBvtH4EXWe84YKKIUSMrr4OR+uQ/woOM+
         5zkaJyUOev5cANa3WnuLWQwrK5Y6ci79eRI5DY9TehoY1FBe2MBgGtixX5R94rKKIT
         in5LFi4LcBGzk45FLgP48wsALxdbFxwY3fOudh/06kxKsUqSh+xiG/JHkvTEoX+dNK
         WKCSgNvjTE1E4t9TyhBswO49sKWSUHFnKMJIFeibHY2HnYU/JwOh/Da6E5+SOyXbsF
         hHMq8m1Tz2/0IJchFDYBAvswKki82ha2KBuOPzBQ/piFBSfoLFEOycw9vNuNvE+Sa7
         VaNCqMas3N7eQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, mkubecek@suse.cz,
        idosch@nvidia.com, saeedm@nvidia.com, michael.chan@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 9/9] mlx5: implement ethtool standard stats
Date:   Fri, 16 Apr 2021 12:27:45 -0700
Message-Id: <20210416192745.2851044-10-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416192745.2851044-1-kuba@kernel.org>
References: <20210416192745.2851044-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for PHY/MAC/Ctrl/RMON stats.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  37 +++++
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 142 +++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  10 ++
 3 files changed, 182 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index f17690cbeeea..c3375c68c577 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -2176,6 +2176,39 @@ int mlx5e_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 	return mlx5e_ethtool_set_rxnfc(dev, cmd);
 }
 
+static void mlx5e_get_eth_phy_stats(struct net_device *netdev,
+				    struct ethtool_eth_phy_stats *phy_stats)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+
+	mlx5e_stats_eth_phy_get(priv, phy_stats);
+}
+
+static void mlx5e_get_eth_mac_stats(struct net_device *netdev,
+				    struct ethtool_eth_mac_stats *mac_stats)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+
+	mlx5e_stats_eth_mac_get(priv, mac_stats);
+}
+
+static void mlx5e_get_eth_ctrl_stats(struct net_device *netdev,
+				     struct ethtool_eth_ctrl_stats *ctrl_stats)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+
+	mlx5e_stats_eth_ctrl_get(priv, ctrl_stats);
+}
+
+static void mlx5e_get_rmon_stats(struct net_device *netdev,
+				 struct ethtool_rmon_stats *rmon_stats,
+				 const struct ethtool_rmon_hist_range **ranges)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+
+	mlx5e_stats_rmon_get(priv, rmon_stats, ranges);
+}
+
 const struct ethtool_ops mlx5e_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES |
@@ -2220,4 +2253,8 @@ const struct ethtool_ops mlx5e_ethtool_ops = {
 	.get_fec_stats     = mlx5e_get_fec_stats,
 	.get_fecparam      = mlx5e_get_fecparam,
 	.set_fecparam      = mlx5e_set_fecparam,
+	.get_eth_phy_stats = mlx5e_get_eth_phy_stats,
+	.get_eth_mac_stats = mlx5e_get_eth_mac_stats,
+	.get_eth_ctrl_stats = mlx5e_get_eth_ctrl_stats,
+	.get_rmon_stats    = mlx5e_get_rmon_stats,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 353513bd0d5e..f4db99cae64c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -773,21 +773,29 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(802_3)
 		MLX5_BYTE_OFF(ppcnt_reg,		\
 			      counter_set.set.c##_high)))
 
-void mlx5e_stats_pause_get(struct mlx5e_priv *priv,
-			   struct ethtool_pause_stats *pause_stats)
+static int mlx5e_stats_get_ieee(struct mlx5_core_dev *mdev,
+				u32 *ppcnt_ieee_802_3)
 {
-	u32 ppcnt_ieee_802_3[MLX5_ST_SZ_DW(ppcnt_reg)];
-	struct mlx5_core_dev *mdev = priv->mdev;
 	u32 in[MLX5_ST_SZ_DW(ppcnt_reg)] = {};
 	int sz = MLX5_ST_SZ_BYTES(ppcnt_reg);
 
 	if (!MLX5_BASIC_PPCNT_SUPPORTED(mdev))
-		return;
+		return -EOPNOTSUPP;
 
 	MLX5_SET(ppcnt_reg, in, local_port, 1);
 	MLX5_SET(ppcnt_reg, in, grp, MLX5_IEEE_802_3_COUNTERS_GROUP);
-	mlx5_core_access_reg(mdev, in, sz, ppcnt_ieee_802_3,
-			     sz, MLX5_REG_PPCNT, 0, 0);
+	return mlx5_core_access_reg(mdev, in, sz, ppcnt_ieee_802_3,
+				    sz, MLX5_REG_PPCNT, 0, 0);
+}
+
+void mlx5e_stats_pause_get(struct mlx5e_priv *priv,
+			   struct ethtool_pause_stats *pause_stats)
+{
+	u32 ppcnt_ieee_802_3[MLX5_ST_SZ_DW(ppcnt_reg)];
+	struct mlx5_core_dev *mdev = priv->mdev;
+
+	if (mlx5e_stats_get_ieee(mdev, ppcnt_ieee_802_3))
+		return;
 
 	pause_stats->tx_pause_frames =
 		MLX5E_READ_CTR64_BE_F(ppcnt_ieee_802_3,
@@ -799,6 +807,73 @@ void mlx5e_stats_pause_get(struct mlx5e_priv *priv,
 				      a_pause_mac_ctrl_frames_received);
 }
 
+void mlx5e_stats_eth_phy_get(struct mlx5e_priv *priv,
+			     struct ethtool_eth_phy_stats *phy_stats)
+{
+	u32 ppcnt_ieee_802_3[MLX5_ST_SZ_DW(ppcnt_reg)];
+	struct mlx5_core_dev *mdev = priv->mdev;
+
+	if (mlx5e_stats_get_ieee(mdev, ppcnt_ieee_802_3))
+		return;
+
+	phy_stats->SymbolErrorDuringCarrier =
+		MLX5E_READ_CTR64_BE_F(ppcnt_ieee_802_3,
+				      eth_802_3_cntrs_grp_data_layout,
+				      a_symbol_error_during_carrier);
+}
+
+void mlx5e_stats_eth_mac_get(struct mlx5e_priv *priv,
+			     struct ethtool_eth_mac_stats *mac_stats)
+{
+	u32 ppcnt_ieee_802_3[MLX5_ST_SZ_DW(ppcnt_reg)];
+	struct mlx5_core_dev *mdev = priv->mdev;
+
+	if (mlx5e_stats_get_ieee(mdev, ppcnt_ieee_802_3))
+		return;
+
+#define RD(name)							\
+	MLX5E_READ_CTR64_BE_F(ppcnt_ieee_802_3,				\
+			      eth_802_3_cntrs_grp_data_layout,		\
+			      name)
+
+	mac_stats->FramesTransmittedOK	= RD(a_frames_transmitted_ok);
+	mac_stats->FramesReceivedOK	= RD(a_frames_received_ok);
+	mac_stats->FrameCheckSequenceErrors = RD(a_frame_check_sequence_errors);
+	mac_stats->OctetsTransmittedOK	= RD(a_octets_transmitted_ok);
+	mac_stats->OctetsReceivedOK	= RD(a_octets_received_ok);
+	mac_stats->MulticastFramesXmittedOK = RD(a_multicast_frames_xmitted_ok);
+	mac_stats->BroadcastFramesXmittedOK = RD(a_broadcast_frames_xmitted_ok);
+	mac_stats->MulticastFramesReceivedOK = RD(a_multicast_frames_received_ok);
+	mac_stats->BroadcastFramesReceivedOK = RD(a_broadcast_frames_received_ok);
+	mac_stats->InRangeLengthErrors	= RD(a_in_range_length_errors);
+	mac_stats->OutOfRangeLengthField = RD(a_out_of_range_length_field);
+	mac_stats->FrameTooLongErrors	= RD(a_frame_too_long_errors);
+#undef RD
+}
+
+void mlx5e_stats_eth_ctrl_get(struct mlx5e_priv *priv,
+			      struct ethtool_eth_ctrl_stats *ctrl_stats)
+{
+	u32 ppcnt_ieee_802_3[MLX5_ST_SZ_DW(ppcnt_reg)];
+	struct mlx5_core_dev *mdev = priv->mdev;
+
+	if (mlx5e_stats_get_ieee(mdev, ppcnt_ieee_802_3))
+		return;
+
+	ctrl_stats->MACControlFramesTransmitted =
+		MLX5E_READ_CTR64_BE_F(ppcnt_ieee_802_3,
+				      eth_802_3_cntrs_grp_data_layout,
+				      a_mac_control_frames_transmitted);
+	ctrl_stats->MACControlFramesReceived =
+		MLX5E_READ_CTR64_BE_F(ppcnt_ieee_802_3,
+				      eth_802_3_cntrs_grp_data_layout,
+				      a_mac_control_frames_received);
+	ctrl_stats->UnsupportedOpcodesReceived =
+		MLX5E_READ_CTR64_BE_F(ppcnt_ieee_802_3,
+				      eth_802_3_cntrs_grp_data_layout,
+				      a_unsupported_opcodes_received);
+}
+
 #define PPORT_2863_OFF(c) \
 	MLX5_BYTE_OFF(ppcnt_reg, \
 		      counter_set.eth_2863_cntrs_grp_data_layout.c##_high)
@@ -910,6 +985,59 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(2819)
 	mlx5_core_access_reg(mdev, in, sz, out, sz, MLX5_REG_PPCNT, 0, 0);
 }
 
+static const struct ethtool_rmon_hist_range mlx5e_rmon_ranges[] = {
+	{    0,    64 },
+	{   65,   127 },
+	{  128,   255 },
+	{  256,   511 },
+	{  512,  1023 },
+	{ 1024,  1518 },
+	{ 1519,  2047 },
+	{ 2048,  4095 },
+	{ 4096,  8191 },
+	{ 8192, 10239 },
+	{}
+};
+
+void mlx5e_stats_rmon_get(struct mlx5e_priv *priv,
+			  struct ethtool_rmon_stats *rmon,
+			  const struct ethtool_rmon_hist_range **ranges)
+{
+	u32 ppcnt_RFC_2819_counters[MLX5_ST_SZ_DW(ppcnt_reg)];
+	struct mlx5_core_dev *mdev = priv->mdev;
+	u32 in[MLX5_ST_SZ_DW(ppcnt_reg)] = {0};
+	int sz = MLX5_ST_SZ_BYTES(ppcnt_reg);
+
+	MLX5_SET(ppcnt_reg, in, local_port, 1);
+	MLX5_SET(ppcnt_reg, in, grp, MLX5_RFC_2819_COUNTERS_GROUP);
+	if (mlx5_core_access_reg(mdev, in, sz, ppcnt_RFC_2819_counters,
+				 sz, MLX5_REG_PPCNT, 0, 0))
+		return;
+
+#define RD(name)						\
+	MLX5E_READ_CTR64_BE_F(ppcnt_RFC_2819_counters,		\
+			      eth_2819_cntrs_grp_data_layout,	\
+			      name)
+
+	rmon->undersize_pkts	= RD(ether_stats_undersize_pkts);
+	rmon->fragments		= RD(ether_stats_fragments);
+	rmon->jabbers		= RD(ether_stats_jabbers);
+
+	rmon->hist[0]		= RD(ether_stats_pkts64octets);
+	rmon->hist[1]		= RD(ether_stats_pkts65to127octets);
+	rmon->hist[2]		= RD(ether_stats_pkts128to255octets);
+	rmon->hist[3]		= RD(ether_stats_pkts256to511octets);
+	rmon->hist[4]		= RD(ether_stats_pkts512to1023octets);
+	rmon->hist[5]		= RD(ether_stats_pkts1024to1518octets);
+	rmon->hist[6]		= RD(ether_stats_pkts1519to2047octets);
+	rmon->hist[7]		= RD(ether_stats_pkts2048to4095octets);
+	rmon->hist[8]		= RD(ether_stats_pkts4096to8191octets);
+	rmon->hist[9]		= RD(ether_stats_pkts8192to10239octets);
+#undef RD
+
+	*ranges = mlx5e_rmon_ranges;
+}
+
 #define PPORT_PHY_STATISTICAL_OFF(c) \
 	MLX5_BYTE_OFF(ppcnt_reg, \
 		      counter_set.phys_layer_statistical_cntrs.c##_high)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 3f0789e51eed..5b80a173e71c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -117,6 +117,16 @@ void mlx5e_stats_pause_get(struct mlx5e_priv *priv,
 void mlx5e_stats_fec_get(struct mlx5e_priv *priv,
 			 struct ethtool_fec_stats *fec_stats);
 
+void mlx5e_stats_eth_phy_get(struct mlx5e_priv *priv,
+			     struct ethtool_eth_phy_stats *phy_stats);
+void mlx5e_stats_eth_mac_get(struct mlx5e_priv *priv,
+			     struct ethtool_eth_mac_stats *mac_stats);
+void mlx5e_stats_eth_ctrl_get(struct mlx5e_priv *priv,
+			      struct ethtool_eth_ctrl_stats *ctrl_stats);
+void mlx5e_stats_rmon_get(struct mlx5e_priv *priv,
+			  struct ethtool_rmon_stats *rmon,
+			  const struct ethtool_rmon_hist_range **ranges);
+
 /* Concrete NIC Stats */
 
 struct mlx5e_sw_stats {
-- 
2.30.2

