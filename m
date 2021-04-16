Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CF0361795
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 04:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238314AbhDPC23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 22:28:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238261AbhDPC2W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 22:28:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10D1F611AB;
        Fri, 16 Apr 2021 02:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618540078;
        bh=Lln+QZEXE/QrEx2kxCYru6ga/SHfwvu0L11GRlNQUp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D1lTkX0qYIFamyEpfNp2G8eA8AB/PETcuggsds+PFtUT2J+/fVK7Ne/Id4H8WSef7
         /RHsr7mUTcARKnq/6o5Ieb4qXURBEirH2rl9glVO7FDeI1YpgKSaRSAV6XyRbj6oDk
         5ayxmXpmLlEBL20d/gXv3uhqTl8tDvm79yygyOI/wKxHggMEzsS7MY6OuIXxeYoyu2
         Lwp7F6pB3sx+wU0naoe/OyeGgsHKPBRVs3q5whUegkRCpsjWlxNSuTtXi99mvmh8nB
         e87sJn5XOipkJNDLBfFAt8mOYWDOg+MRwpQLmbhxVzuIVdt1EN2Qn+6fiWl0VymG2y
         BSAhKtgGOSrKg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, mkubecek@suse.cz,
        idosch@nvidia.com, saeedm@nvidia.com, michael.chan@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 7/9] mlxsw: implement ethtool standard stats
Date:   Thu, 15 Apr 2021 19:27:50 -0700
Message-Id: <20210416022752.2814621-8-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416022752.2814621-1-kuba@kernel.org>
References: <20210416022752.2814621-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlxsw has nicely grouped stats, add support for standard uAPI.
I'm guessing the register access part. Compile tested only.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../mellanox/mlxsw/spectrum_ethtool.c         | 129 ++++++++++++++++++
 1 file changed, 129 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 078601d31cde..c8061beed6db 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -1059,6 +1059,131 @@ mlxsw_sp_get_ts_info(struct net_device *netdev, struct ethtool_ts_info *info)
 	return mlxsw_sp->ptp_ops->get_ts_info(mlxsw_sp, info);
 }
 
+static void
+mlxsw_sp_get_eth_phy_stats(struct net_device *dev,
+			   struct ethtool_eth_phy_stats *phy_stats)
+{
+	char ppcnt_pl[MLXSW_REG_PPCNT_LEN];
+
+	if (mlxsw_sp_port_get_stats_raw(dev, MLXSW_REG_PPCNT_IEEE_8023_CNT,
+					0, ppcnt_pl))
+		return;
+
+	phy_stats->SymbolErrorDuringCarrier =
+		mlxsw_reg_ppcnt_a_symbol_error_during_carrier_get(ppcnt_pl);
+}
+
+static void
+mlxsw_sp_get_eth_mac_stats(struct net_device *dev,
+			   struct ethtool_eth_mac_stats *mac_stats)
+{
+	char ppcnt_pl[MLXSW_REG_PPCNT_LEN];
+
+	if (mlxsw_sp_port_get_stats_raw(dev, MLXSW_REG_PPCNT_IEEE_8023_CNT,
+					0, ppcnt_pl))
+		return;
+
+	mac_stats->FramesTransmittedOK =
+		mlxsw_reg_ppcnt_a_frames_transmitted_ok_get(ppcnt_pl);
+	mac_stats->FramesReceivedOK =
+		mlxsw_reg_ppcnt_a_frames_received_ok_get(ppcnt_pl);
+	mac_stats->FrameCheckSequenceErrors =
+		mlxsw_reg_ppcnt_a_frame_check_sequence_errors_get(ppcnt_pl);
+	mac_stats->AlignmentErrors =
+		mlxsw_reg_ppcnt_a_alignment_errors_get(ppcnt_pl);
+	mac_stats->OctetsTransmittedOK =
+		mlxsw_reg_ppcnt_a_octets_transmitted_ok_get(ppcnt_pl);
+	mac_stats->OctetsReceivedOK =
+		mlxsw_reg_ppcnt_a_octets_received_ok_get(ppcnt_pl);
+	mac_stats->MulticastFramesXmittedOK =
+		mlxsw_reg_ppcnt_a_multicast_frames_xmitted_ok_get(ppcnt_pl);
+	mac_stats->BroadcastFramesXmittedOK =
+		mlxsw_reg_ppcnt_a_broadcast_frames_xmitted_ok_get(ppcnt_pl);
+	mac_stats->MulticastFramesReceivedOK =
+		mlxsw_reg_ppcnt_a_multicast_frames_received_ok_get(ppcnt_pl);
+	mac_stats->BroadcastFramesReceivedOK =
+		mlxsw_reg_ppcnt_a_broadcast_frames_received_ok_get(ppcnt_pl);
+	mac_stats->InRangeLengthErrors =
+		mlxsw_reg_ppcnt_a_in_range_length_errors_get(ppcnt_pl);
+	mac_stats->OutOfRangeLengthField =
+		mlxsw_reg_ppcnt_a_out_of_range_length_field_get(ppcnt_pl);
+	mac_stats->FrameTooLongErrors =
+		mlxsw_reg_ppcnt_a_frame_too_long_errors_get(ppcnt_pl);
+}
+
+static void
+mlxsw_sp_get_eth_ctrl_stats(struct net_device *dev,
+			    struct ethtool_eth_ctrl_stats *ctrl_stats)
+{
+	char ppcnt_pl[MLXSW_REG_PPCNT_LEN];
+
+	if (mlxsw_sp_port_get_stats_raw(dev, MLXSW_REG_PPCNT_IEEE_8023_CNT,
+					0, ppcnt_pl))
+		return;
+
+	ctrl_stats->MACControlFramesTransmitted =
+		mlxsw_reg_ppcnt_a_mac_control_frames_transmitted_get(ppcnt_pl);
+	ctrl_stats->MACControlFramesReceived =
+		mlxsw_reg_ppcnt_a_mac_control_frames_received_get(ppcnt_pl);
+	ctrl_stats->UnsupportedOpcodesReceived =
+		mlxsw_reg_ppcnt_a_unsupported_opcodes_received_get(ppcnt_pl);
+}
+
+static const struct ethtool_rmon_hist_range mlxsw_rmon_ranges[] = {
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
+static void
+mlxsw_sp_get_rmon_stats(struct net_device *dev,
+			struct ethtool_rmon_stats *rmon,
+			const struct ethtool_rmon_hist_range **ranges)
+{
+	char ppcnt_pl[MLXSW_REG_PPCNT_LEN];
+
+	if (mlxsw_sp_port_get_stats_raw(dev, MLXSW_REG_PPCNT_RFC_2819_CNT,
+					0, ppcnt_pl))
+		return;
+
+	rmon->undersize_pkts =
+		mlxsw_reg_ppcnt_ether_stats_undersize_pkts_get(ppcnt_pl);
+	rmon->oversize_pkts =
+		mlxsw_reg_ppcnt_ether_stats_oversize_pkts_get(ppcnt_pl);
+	rmon->fragments =
+		mlxsw_reg_ppcnt_ether_stats_fragments_get(ppcnt_pl);
+
+	rmon->hist[0] = mlxsw_reg_ppcnt_ether_stats_pkts64octets_get(ppcnt_pl);
+	rmon->hist[1] =
+		mlxsw_reg_ppcnt_ether_stats_pkts65to127octets_get(ppcnt_pl);
+	rmon->hist[2] =
+		mlxsw_reg_ppcnt_ether_stats_pkts128to255octets_get(ppcnt_pl);
+	rmon->hist[3] =
+		mlxsw_reg_ppcnt_ether_stats_pkts256to511octets_get(ppcnt_pl);
+	rmon->hist[4] =
+		mlxsw_reg_ppcnt_ether_stats_pkts512to1023octets_get(ppcnt_pl);
+	rmon->hist[5] =
+		mlxsw_reg_ppcnt_ether_stats_pkts1024to1518octets_get(ppcnt_pl);
+	rmon->hist[6] =
+		mlxsw_reg_ppcnt_ether_stats_pkts1519to2047octets_get(ppcnt_pl);
+	rmon->hist[7] =
+		mlxsw_reg_ppcnt_ether_stats_pkts2048to4095octets_get(ppcnt_pl);
+	rmon->hist[8] =
+		mlxsw_reg_ppcnt_ether_stats_pkts4096to8191octets_get(ppcnt_pl);
+	rmon->hist[9] =
+		mlxsw_reg_ppcnt_ether_stats_pkts8192to10239octets_get(ppcnt_pl);
+
+	*ranges = mlxsw_rmon_ranges;
+}
+
 const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
 	.cap_link_lanes_supported	= true,
 	.get_drvinfo			= mlxsw_sp_port_get_drvinfo,
@@ -1075,6 +1200,10 @@ const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
 	.get_module_info		= mlxsw_sp_get_module_info,
 	.get_module_eeprom		= mlxsw_sp_get_module_eeprom,
 	.get_ts_info			= mlxsw_sp_get_ts_info,
+	.get_eth_phy_stats		= mlxsw_sp_get_eth_phy_stats,
+	.get_eth_mac_stats		= mlxsw_sp_get_eth_mac_stats,
+	.get_eth_ctrl_stats		= mlxsw_sp_get_eth_ctrl_stats,
+	.get_rmon_stats			= mlxsw_sp_get_rmon_stats,
 };
 
 struct mlxsw_sp1_port_link_mode {
-- 
2.30.2

