Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9039A3DF2B9
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbhHCQhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:37:47 -0400
Received: from mga17.intel.com ([192.55.52.151]:62851 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234241AbhHCQhn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:37:43 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="194013638"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="194013638"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 09:37:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="511394690"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Aug 2021 09:37:21 -0700
Received: from alobakin-mobl.ger.corp.intel.com (eflejszm-mobl2.ger.corp.intel.com [10.213.26.164])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 173GahEw029968;
        Tue, 3 Aug 2021 17:37:16 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lukasz Czapnik <lukasz.czapnik@intel.com>,
        Marcin Kubiak <marcin.kubiak@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Shay Agroskin <shayagr@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jian Shen <shenjian15@huawei.com>,
        Petr Vorel <petr.vorel@gmail.com>, Dan Murphy <dmurphy@ti.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH net-next 08/21] ethernet, enetc: convert to standard XDP stats
Date:   Tue,  3 Aug 2021 18:36:28 +0200
Message-Id: <20210803163641.3743-9-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803163641.3743-1-alexandr.lobakin@intel.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver has 6 per-channel XDP counters. Convert them to 5
standard XDP stats (redirect_sg and redirect_failures go under
the same redirect_errors).
As this driver theoretically can have different numbers of RX
and TX rings, collect statistics separately for each direction.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 .../ethernet/freescale/enetc/enetc_ethtool.c  | 58 ++++++++++++++-----
 1 file changed, 44 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index ebccaf02411c..1b94cb488850 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -192,18 +192,12 @@ static const struct {
 static const char rx_ring_stats[][ETH_GSTRING_LEN] = {
 	"Rx ring %2d frames",
 	"Rx ring %2d alloc errors",
-	"Rx ring %2d XDP drops",
 	"Rx ring %2d recycles",
 	"Rx ring %2d recycle failures",
-	"Rx ring %2d redirects",
-	"Rx ring %2d redirect failures",
-	"Rx ring %2d redirect S/G",
 };
 
 static const char tx_ring_stats[][ETH_GSTRING_LEN] = {
 	"Tx ring %2d frames",
-	"Tx ring %2d XDP frames",
-	"Tx ring %2d XDP drops",
 };
 
 static int enetc_get_sset_count(struct net_device *ndev, int sset)
@@ -275,21 +269,14 @@ static void enetc_get_ethtool_stats(struct net_device *ndev,
 	for (i = 0; i < ARRAY_SIZE(enetc_si_counters); i++)
 		data[o++] = enetc_rd64(hw, enetc_si_counters[i].reg);
 
-	for (i = 0; i < priv->num_tx_rings; i++) {
+	for (i = 0; i < priv->num_tx_rings; i++)
 		data[o++] = priv->tx_ring[i]->stats.packets;
-		data[o++] = priv->tx_ring[i]->stats.xdp_tx;
-		data[o++] = priv->tx_ring[i]->stats.xdp_tx_drops;
-	}
 
 	for (i = 0; i < priv->num_rx_rings; i++) {
 		data[o++] = priv->rx_ring[i]->stats.packets;
 		data[o++] = priv->rx_ring[i]->stats.rx_alloc_errs;
-		data[o++] = priv->rx_ring[i]->stats.xdp_drops;
 		data[o++] = priv->rx_ring[i]->stats.recycles;
 		data[o++] = priv->rx_ring[i]->stats.recycle_failures;
-		data[o++] = priv->rx_ring[i]->stats.xdp_redirect;
-		data[o++] = priv->rx_ring[i]->stats.xdp_redirect_failures;
-		data[o++] = priv->rx_ring[i]->stats.xdp_redirect_sg;
 	}
 
 	if (!enetc_si_is_pf(priv->si))
@@ -299,6 +286,45 @@ static void enetc_get_ethtool_stats(struct net_device *ndev,
 		data[o++] = enetc_port_rd(hw, enetc_port_counters[i].reg);
 }
 
+static int enetc_get_std_stats_channels(struct net_device *ndev, u32 sset)
+{
+	const struct enetc_ndev_priv *priv = netdev_priv(ndev);
+
+	switch (sset) {
+	case ETH_SS_STATS_XDP:
+		return max(priv->num_rx_rings, priv->num_tx_rings);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void enetc_get_xdp_stats(struct net_device *ndev,
+				struct ethtool_xdp_stats *xdp_stats)
+{
+	const struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	const struct enetc_ring_stats *stats;
+	struct ethtool_xdp_stats *iter;
+	u32 i;
+
+	for (i = 0; i < priv->num_tx_rings; i++) {
+		stats = &priv->tx_ring[i]->stats;
+		iter = xdp_stats + i;
+
+		iter->tx = stats->xdp_tx;
+		iter->tx_errors = stats->xdp_tx_drops;
+	}
+
+	for (i = 0; i < priv->num_rx_rings; i++) {
+		stats = &priv->rx_ring[i]->stats;
+		iter = xdp_stats + i;
+
+		iter->drop = stats->xdp_drops;
+		iter->redirect = stats->xdp_redirect;
+		iter->redirect_errors = stats->xdp_redirect_failures;
+		iter->redirect_errors += stats->xdp_redirect_sg;
+	}
+}
+
 #define ENETC_RSSHASH_L3 (RXH_L2DA | RXH_VLAN | RXH_L3_PROTO | RXH_IP_SRC | \
 			  RXH_IP_DST)
 #define ENETC_RSSHASH_L4 (ENETC_RSSHASH_L3 | RXH_L4_B_0_1 | RXH_L4_B_2_3)
@@ -772,6 +798,8 @@ static const struct ethtool_ops enetc_pf_ethtool_ops = {
 	.set_wol = enetc_set_wol,
 	.get_pauseparam = enetc_get_pauseparam,
 	.set_pauseparam = enetc_set_pauseparam,
+	.get_std_stats_channels = enetc_get_std_stats_channels,
+	.get_xdp_stats = enetc_get_xdp_stats,
 };
 
 static const struct ethtool_ops enetc_vf_ethtool_ops = {
@@ -793,6 +821,8 @@ static const struct ethtool_ops enetc_vf_ethtool_ops = {
 	.set_coalesce = enetc_set_coalesce,
 	.get_link = ethtool_op_get_link,
 	.get_ts_info = enetc_get_ts_info,
+	.get_std_stats_channels = enetc_get_std_stats_channels,
+	.get_xdp_stats = enetc_get_xdp_stats,
 };
 
 void enetc_set_ethtool_ops(struct net_device *ndev)
-- 
2.31.1

