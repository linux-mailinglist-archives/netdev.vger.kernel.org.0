Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5329838D456
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 09:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbhEVH6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 03:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbhEVH6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 03:58:01 -0400
Received: from mout-u-204.mailbox.org (mout-u-204.mailbox.org [IPv6:2001:67c:2050:1::465:204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF72FC061574
        for <netdev@vger.kernel.org>; Sat, 22 May 2021 00:56:36 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-u-204.mailbox.org (Postfix) with ESMTPS id 4FnG5G23Q8zQjwr;
        Sat, 22 May 2021 09:56:34 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id cfyO5qczEmgQ; Sat, 22 May 2021 09:56:31 +0200 (CEST)
From:   Stefan Roese <sr@denx.de>
To:     netdev@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Reto Schneider <code@reto-schneider.ch>,
        Reto Schneider <reto.schneider@husqvarnagroup.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH v2] net: ethernet: mtk_eth_soc: Fix packet statistics support for MT7628/88
Date:   Sat, 22 May 2021 09:56:30 +0200
Message-Id: <20210522075630.2414801-1-sr@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -3.63 / 15.00 / 15.00
X-Rspamd-Queue-Id: 4B53E180D
X-Rspamd-UID: f73e09
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MT7628/88 SoC(s) have other (limited) packet counter registers than
currently supported in the mtk_eth_soc driver. This patch adds support
for reading these registers, so that the packet statistics are correctly
updated.

Additionally the defines for the non-MT7628 variant packet counter
registers are added and used in this patch instead of using hard coded
values.

Signed-off-by: Stefan Roese <sr@denx.de>
Fixes: 296c9120752b ("net: ethernet: mediatek: Add MT7628/88 SoC support")
Cc: Felix Fietkau <nbd@nbd.name>
Cc: John Crispin <john@phrozen.org>
Cc: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc: Reto Schneider <code@reto-schneider.ch>
Cc: Reto Schneider <reto.schneider@husqvarnagroup.com>
Cc: David S. Miller <davem@davemloft.net>
---
v2:
- Add and use defines for the non-MT7628 variant packet counter registers

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 67 ++++++++++++++-------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 24 +++++++-
 2 files changed, 66 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index d6cc06ee0caa..64adfd24e134 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -681,32 +681,53 @@ static int mtk_set_mac_address(struct net_device *dev, void *p)
 void mtk_stats_update_mac(struct mtk_mac *mac)
 {
 	struct mtk_hw_stats *hw_stats = mac->hw_stats;
-	unsigned int base = MTK_GDM1_TX_GBCNT;
-	u64 stats;
-
-	base += hw_stats->reg_offset;
+	struct mtk_eth *eth = mac->hw;
 
 	u64_stats_update_begin(&hw_stats->syncp);
 
-	hw_stats->rx_bytes += mtk_r32(mac->hw, base);
-	stats =  mtk_r32(mac->hw, base + 0x04);
-	if (stats)
-		hw_stats->rx_bytes += (stats << 32);
-	hw_stats->rx_packets += mtk_r32(mac->hw, base + 0x08);
-	hw_stats->rx_overflow += mtk_r32(mac->hw, base + 0x10);
-	hw_stats->rx_fcs_errors += mtk_r32(mac->hw, base + 0x14);
-	hw_stats->rx_short_errors += mtk_r32(mac->hw, base + 0x18);
-	hw_stats->rx_long_errors += mtk_r32(mac->hw, base + 0x1c);
-	hw_stats->rx_checksum_errors += mtk_r32(mac->hw, base + 0x20);
-	hw_stats->rx_flow_control_packets +=
-					mtk_r32(mac->hw, base + 0x24);
-	hw_stats->tx_skip += mtk_r32(mac->hw, base + 0x28);
-	hw_stats->tx_collisions += mtk_r32(mac->hw, base + 0x2c);
-	hw_stats->tx_bytes += mtk_r32(mac->hw, base + 0x30);
-	stats =  mtk_r32(mac->hw, base + 0x34);
-	if (stats)
-		hw_stats->tx_bytes += (stats << 32);
-	hw_stats->tx_packets += mtk_r32(mac->hw, base + 0x38);
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628)) {
+		hw_stats->tx_packets += mtk_r32(mac->hw, MT7628_SDM_TPCNT);
+		hw_stats->tx_bytes += mtk_r32(mac->hw, MT7628_SDM_TBCNT);
+		hw_stats->rx_packets += mtk_r32(mac->hw, MT7628_SDM_RPCNT);
+		hw_stats->rx_bytes += mtk_r32(mac->hw, MT7628_SDM_RBCNT);
+		hw_stats->rx_checksum_errors +=
+			mtk_r32(mac->hw, MT7628_SDM_CS_ERR);
+	} else {
+		unsigned int offs = hw_stats->reg_offset;
+		u64 stats;
+
+		hw_stats->rx_bytes += mtk_r32(mac->hw,
+					      MTK_GDM1_RX_GBCNT_L + offs);
+		stats = mtk_r32(mac->hw, MTK_GDM1_RX_GBCNT_H + offs);
+		if (stats)
+			hw_stats->rx_bytes += (stats << 32);
+		hw_stats->rx_packets +=
+			mtk_r32(mac->hw, MTK_GDM1_RX_GPCNT + offs);
+		hw_stats->rx_overflow +=
+			mtk_r32(mac->hw, MTK_GDM1_RX_OERCNT + offs);
+		hw_stats->rx_fcs_errors +=
+			mtk_r32(mac->hw, MTK_GDM1_RX_FERCNT + offs);
+		hw_stats->rx_short_errors +=
+			mtk_r32(mac->hw, MTK_GDM1_RX_SERCNT + offs);
+		hw_stats->rx_long_errors +=
+			mtk_r32(mac->hw, MTK_GDM1_RX_LENCNT + offs);
+		hw_stats->rx_checksum_errors +=
+			mtk_r32(mac->hw, MTK_GDM1_RX_CERCNT + offs);
+		hw_stats->rx_flow_control_packets +=
+			mtk_r32(mac->hw, MTK_GDM1_RX_FCCNT + offs);
+		hw_stats->tx_skip +=
+			mtk_r32(mac->hw, MTK_GDM1_TX_SKIPCNT + offs);
+		hw_stats->tx_collisions +=
+			mtk_r32(mac->hw, MTK_GDM1_TX_COLCNT + offs);
+		hw_stats->tx_bytes +=
+			mtk_r32(mac->hw, MTK_GDM1_TX_GBCNT_L + offs);
+		stats =  mtk_r32(mac->hw, MTK_GDM1_TX_GBCNT_H + offs);
+		if (stats)
+			hw_stats->tx_bytes += (stats << 32);
+		hw_stats->tx_packets +=
+			mtk_r32(mac->hw, MTK_GDM1_TX_GPCNT + offs);
+	}
+
 	u64_stats_update_end(&hw_stats->syncp);
 }
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 11331b44ba07..5ef70dd8b49c 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -278,8 +278,21 @@
 /* QDMA FQ Free Page Buffer Length Register */
 #define MTK_QDMA_FQ_BLEN	0x1B2C
 
-/* GMA1 Received Good Byte Count Register */
-#define MTK_GDM1_TX_GBCNT	0x2400
+/* GMA1 counter / statics register */
+#define MTK_GDM1_RX_GBCNT_L	0x2400
+#define MTK_GDM1_RX_GBCNT_H	0x2404
+#define MTK_GDM1_RX_GPCNT	0x2408
+#define MTK_GDM1_RX_OERCNT	0x2410
+#define MTK_GDM1_RX_FERCNT	0x2414
+#define MTK_GDM1_RX_SERCNT	0x2418
+#define MTK_GDM1_RX_LENCNT	0x241c
+#define MTK_GDM1_RX_CERCNT	0x2420
+#define MTK_GDM1_RX_FCCNT	0x2424
+#define MTK_GDM1_TX_SKIPCNT	0x2428
+#define MTK_GDM1_TX_COLCNT	0x242c
+#define MTK_GDM1_TX_GBCNT_L	0x2430
+#define MTK_GDM1_TX_GBCNT_H	0x2434
+#define MTK_GDM1_TX_GPCNT	0x2438
 #define MTK_STAT_OFFSET		0x40
 
 /* QDMA descriptor txd4 */
@@ -502,6 +515,13 @@
 #define MT7628_SDM_MAC_ADRL	(MT7628_SDM_OFFSET + 0x0c)
 #define MT7628_SDM_MAC_ADRH	(MT7628_SDM_OFFSET + 0x10)
 
+/* Counter / stat register */
+#define MT7628_SDM_TPCNT	(MT7628_SDM_OFFSET + 0x100)
+#define MT7628_SDM_TBCNT	(MT7628_SDM_OFFSET + 0x104)
+#define MT7628_SDM_RPCNT	(MT7628_SDM_OFFSET + 0x108)
+#define MT7628_SDM_RBCNT	(MT7628_SDM_OFFSET + 0x10c)
+#define MT7628_SDM_CS_ERR	(MT7628_SDM_OFFSET + 0x110)
+
 struct mtk_rx_dma {
 	unsigned int rxd1;
 	unsigned int rxd2;
-- 
2.31.1

