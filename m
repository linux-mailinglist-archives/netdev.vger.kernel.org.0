Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117D53628A2
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 21:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243550AbhDPT2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 15:28:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243252AbhDPT2X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 15:28:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ACDA613B4;
        Fri, 16 Apr 2021 19:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618601278;
        bh=M2y9pgwA2bI+StQMzj6UK+guWgAGe+fzstd8Xy8p9gA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RdUb5ck8Ue35bq2eYAGanq6HY7tKRHe54XdH9qYNlsEbhkMO9ksFmHyWRtL5rS36p
         xo8aCfyexU78mB0QFnXlpHBN4Dknbdo/iT1WKiFLjeBwgmoPVAQNqazZKPVEhf7o9v
         BLnvweWNzSgSpkhMLdmfEySEjZxKsNzf7eZGIMBhhE6EyoY+NkDDl9oMilIotaa88k
         3bXBLufIDNYotKpAxvBPQukKZMI/iUV50Na1RLrvxSBsSQxPyAIrbyx/Z0gJEaRDuy
         ik9cOELPM0LxjacT2dnry+uUipwK7/4IrLzDpblVukmv6zyAOgpB6QDc2QZBrmA2wV
         RbMse2N2uZeTQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, mkubecek@suse.cz,
        idosch@nvidia.com, saeedm@nvidia.com, michael.chan@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 8/9] bnxt: implement ethtool standard stats
Date:   Fri, 16 Apr 2021 12:27:44 -0700
Message-Id: <20210416192745.2851044-9-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416192745.2851044-1-kuba@kernel.org>
References: <20210416192745.2851044-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of the names seem to strongly correlate with names from
the standard and RFC. Whether ..+good_frames are indeed Frames..OK
I'm the least sure of.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 125 ++++++++++++++++++
 1 file changed, 125 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 7b90357daba1..832252313b18 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3990,6 +3990,127 @@ void bnxt_ethtool_init(struct bnxt *bp)
 	mutex_unlock(&bp->hwrm_cmd_lock);
 }
 
+static void bnxt_get_eth_phy_stats(struct net_device *dev,
+				   struct ethtool_eth_phy_stats *phy_stats)
+{
+	struct bnxt *bp = netdev_priv(dev);
+	u64 *rx;
+
+	if (BNXT_VF(bp) || !(bp->flags & BNXT_FLAG_PORT_STATS_EXT))
+		return;
+
+	rx = bp->rx_port_stats_ext.sw_stats;
+	phy_stats->SymbolErrorDuringCarrier =
+		*(rx + BNXT_RX_STATS_EXT_OFFSET(rx_pcs_symbol_err));
+}
+
+static void bnxt_get_eth_mac_stats(struct net_device *dev,
+				   struct ethtool_eth_mac_stats *mac_stats)
+{
+	struct bnxt *bp = netdev_priv(dev);
+	u64 *rx, *tx;
+
+	if (BNXT_VF(bp) || !(bp->flags & BNXT_FLAG_PORT_STATS))
+		return;
+
+	rx = bp->port_stats.sw_stats;
+	tx = bp->port_stats.sw_stats + BNXT_TX_PORT_STATS_BYTE_OFFSET / 8;
+
+	mac_stats->FramesReceivedOK =
+		BNXT_GET_RX_PORT_STATS64(rx, rx_good_frames);
+	mac_stats->FramesTransmittedOK =
+		BNXT_GET_TX_PORT_STATS64(tx, tx_good_frames);
+}
+
+static void bnxt_get_eth_ctrl_stats(struct net_device *dev,
+				    struct ethtool_eth_ctrl_stats *ctrl_stats)
+{
+	struct bnxt *bp = netdev_priv(dev);
+	u64 *rx;
+
+	if (BNXT_VF(bp) || !(bp->flags & BNXT_FLAG_PORT_STATS))
+		return;
+
+	rx = bp->port_stats.sw_stats;
+	ctrl_stats->MACControlFramesReceived =
+		BNXT_GET_RX_PORT_STATS64(rx, rx_ctrl_frames);
+}
+
+static const struct ethtool_rmon_hist_range bnxt_rmon_ranges[] = {
+	{    0,    64 },
+	{   65,   127 },
+	{  128,   255 },
+	{  256,   511 },
+	{  512,  1023 },
+	{ 1024,  1518 },
+	{ 1519,  2047 },
+	{ 2048,  4095 },
+	{ 4096,  9216 },
+	{ 9217, 16383 },
+	{}
+};
+
+static void bnxt_get_rmon_stats(struct net_device *dev,
+				struct ethtool_rmon_stats *rmon_stats,
+				const struct ethtool_rmon_hist_range **ranges)
+{
+	struct bnxt *bp = netdev_priv(dev);
+	u64 *rx, *tx;
+
+	if (BNXT_VF(bp) || !(bp->flags & BNXT_FLAG_PORT_STATS))
+		return;
+
+	rx = bp->port_stats.sw_stats;
+	tx = bp->port_stats.sw_stats + BNXT_TX_PORT_STATS_BYTE_OFFSET / 8;
+
+	rmon_stats->jabbers =
+		BNXT_GET_RX_PORT_STATS64(rx, rx_jbr_frames);
+	rmon_stats->oversize_pkts =
+		BNXT_GET_RX_PORT_STATS64(rx, rx_ovrsz_frames);
+	rmon_stats->undersize_pkts =
+		BNXT_GET_RX_PORT_STATS64(rx, rx_undrsz_frames);
+
+	rmon_stats->hist[0] = BNXT_GET_RX_PORT_STATS64(rx, rx_64b_frames);
+	rmon_stats->hist[1] = BNXT_GET_RX_PORT_STATS64(rx, rx_65b_127b_frames);
+	rmon_stats->hist[2] = BNXT_GET_RX_PORT_STATS64(rx, rx_128b_255b_frames);
+	rmon_stats->hist[3] = BNXT_GET_RX_PORT_STATS64(rx, rx_256b_511b_frames);
+	rmon_stats->hist[4] =
+		BNXT_GET_RX_PORT_STATS64(rx, rx_512b_1023b_frames);
+	rmon_stats->hist[5] =
+		BNXT_GET_RX_PORT_STATS64(rx, rx_1024b_1518b_frames);
+	rmon_stats->hist[6] =
+		BNXT_GET_RX_PORT_STATS64(rx, rx_1519b_2047b_frames);
+	rmon_stats->hist[7] =
+		BNXT_GET_RX_PORT_STATS64(rx, rx_2048b_4095b_frames);
+	rmon_stats->hist[8] =
+		BNXT_GET_RX_PORT_STATS64(rx, rx_4096b_9216b_frames);
+	rmon_stats->hist[9] =
+		BNXT_GET_RX_PORT_STATS64(rx, rx_9217b_16383b_frames);
+
+	rmon_stats->hist_tx[0] =
+		BNXT_GET_TX_PORT_STATS64(tx, tx_64b_frames);
+	rmon_stats->hist_tx[1] =
+		BNXT_GET_TX_PORT_STATS64(tx, tx_65b_127b_frames);
+	rmon_stats->hist_tx[2] =
+		BNXT_GET_TX_PORT_STATS64(tx, tx_128b_255b_frames);
+	rmon_stats->hist_tx[3] =
+		BNXT_GET_TX_PORT_STATS64(tx, tx_256b_511b_frames);
+	rmon_stats->hist_tx[4] =
+		BNXT_GET_TX_PORT_STATS64(tx, tx_512b_1023b_frames);
+	rmon_stats->hist_tx[5] =
+		BNXT_GET_TX_PORT_STATS64(tx, tx_1024b_1518b_frames);
+	rmon_stats->hist_tx[6] =
+		BNXT_GET_TX_PORT_STATS64(tx, tx_1519b_2047b_frames);
+	rmon_stats->hist_tx[7] =
+		BNXT_GET_TX_PORT_STATS64(tx, tx_2048b_4095b_frames);
+	rmon_stats->hist_tx[8] =
+		BNXT_GET_TX_PORT_STATS64(tx, tx_4096b_9216b_frames);
+	rmon_stats->hist_tx[9] =
+		BNXT_GET_TX_PORT_STATS64(tx, tx_9217b_16383b_frames);
+
+	*ranges = bnxt_rmon_ranges;
+}
+
 void bnxt_ethtool_free(struct bnxt *bp)
 {
 	kfree(bp->test_info);
@@ -4049,4 +4170,8 @@ const struct ethtool_ops bnxt_ethtool_ops = {
 	.set_dump		= bnxt_set_dump,
 	.get_dump_flag		= bnxt_get_dump_flag,
 	.get_dump_data		= bnxt_get_dump_data,
+	.get_eth_phy_stats	= bnxt_get_eth_phy_stats,
+	.get_eth_mac_stats	= bnxt_get_eth_mac_stats,
+	.get_eth_ctrl_stats	= bnxt_get_eth_ctrl_stats,
+	.get_rmon_stats		= bnxt_get_rmon_stats,
 };
-- 
2.30.2

