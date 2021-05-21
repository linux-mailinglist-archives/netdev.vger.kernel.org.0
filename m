Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3931138BEC1
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 07:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbhEUF6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 01:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbhEUF6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 01:58:44 -0400
Received: from mout-u-204.mailbox.org (mout-u-204.mailbox.org [IPv6:2001:67c:2050:1::465:204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CF4C061574
        for <netdev@vger.kernel.org>; Thu, 20 May 2021 22:57:22 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-u-204.mailbox.org (Postfix) with ESMTPS id 4FmbV76hlDzQk0t;
        Fri, 21 May 2021 07:57:19 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id JXTzgFJnG3Lf; Fri, 21 May 2021 07:57:16 +0200 (CEST)
From:   Stefan Roese <sr@denx.de>
To:     netdev@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Reto Schneider <code@reto-schneider.ch>,
        Reto Schneider <reto.schneider@husqvarnagroup.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net] net: ethernet: mtk_eth_soc: Fix packet statistics support for MT7628/88
Date:   Fri, 21 May 2021 07:57:15 +0200
Message-Id: <20210521055715.1844707-1-sr@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -2.54 / 15.00 / 15.00
X-Rspamd-Queue-Id: C91C83B
X-Rspamd-UID: 2b9fd2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MT7628/88 SoC(s) have other (limited) packet counter registers than
currently supported in the mtk_eth_soc driver. This patch adds support
for reading these registers, so that the packet statistics are correctly
updated.

Signed-off-by: Stefan Roese <sr@denx.de>
Fixes: 296c9120752b ("net: ethernet: mediatek: Add MT7628/88 SoC support")
Cc: Felix Fietkau <nbd@nbd.name>
Cc: John Crispin <john@phrozen.org>
Cc: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc: Reto Schneider <code@reto-schneider.ch>
Cc: Reto Schneider <reto.schneider@husqvarnagroup.com>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 56 ++++++++++++---------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  7 +++
 2 files changed, 40 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index d6cc06ee0caa..ba9a49186909 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -681,32 +681,42 @@ static int mtk_set_mac_address(struct net_device *dev, void *p)
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
+		unsigned int base = MTK_GDM1_TX_GBCNT + hw_stats->reg_offset;
+		u64 stats;
+
+		hw_stats->rx_bytes += mtk_r32(mac->hw, base);
+		stats =  mtk_r32(mac->hw, base + 0x04);
+		if (stats)
+			hw_stats->rx_bytes += (stats << 32);
+		hw_stats->rx_packets += mtk_r32(mac->hw, base + 0x08);
+		hw_stats->rx_overflow += mtk_r32(mac->hw, base + 0x10);
+		hw_stats->rx_fcs_errors += mtk_r32(mac->hw, base + 0x14);
+		hw_stats->rx_short_errors += mtk_r32(mac->hw, base + 0x18);
+		hw_stats->rx_long_errors += mtk_r32(mac->hw, base + 0x1c);
+		hw_stats->rx_checksum_errors += mtk_r32(mac->hw, base + 0x20);
+		hw_stats->rx_flow_control_packets +=
+			mtk_r32(mac->hw, base + 0x24);
+		hw_stats->tx_skip += mtk_r32(mac->hw, base + 0x28);
+		hw_stats->tx_collisions += mtk_r32(mac->hw, base + 0x2c);
+		hw_stats->tx_bytes += mtk_r32(mac->hw, base + 0x30);
+		stats =  mtk_r32(mac->hw, base + 0x34);
+		if (stats)
+			hw_stats->tx_bytes += (stats << 32);
+		hw_stats->tx_packets += mtk_r32(mac->hw, base + 0x38);
+	}
+
 	u64_stats_update_end(&hw_stats->syncp);
 }
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 11331b44ba07..42968c7141da 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -502,6 +502,13 @@
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

