Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6AB1F2CD1
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 11:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388130AbfKGKvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 05:51:44 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:40847 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727528AbfKGKvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 05:51:44 -0500
X-UUID: 0a16776730d64210b5d3d295eaac7464-20191107
X-UUID: 0a16776730d64210b5d3d295eaac7464-20191107
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <mark-mc.lee@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1004045333; Thu, 07 Nov 2019 18:51:38 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 7 Nov 2019 18:51:34 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 7 Nov 2019 18:51:34 +0800
From:   MarkLee <Mark-MC.Lee@mediatek.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rene van Dorst <opensource@vdorst.com>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        MarkLee <Mark-MC.Lee@mediatek.com>
Subject: [PATCH net] net: ethernet: mediatek: rework GDM setup flow
Date:   Thu, 7 Nov 2019 18:51:35 +0800
Message-ID: <20191107105135.1403-1-Mark-MC.Lee@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net: ethernet: mediatek: rework GDM setup flow

The mt762x GDM block is mainly used to setup the HW 
internal rx path - from GMAC port to RX DMA engine(PDMA/QDMA). 
And the internal packet switching engine(PSE) is responsed 
to do the data forward/drop following the GDM configuration.

This pacth target to simpfy the GDM setup flow by integrating 
them into one single function "mtk_gdm_config".
Besides, accroding to the mt762x HW design, it is recommended to 
enable PSE to forward data after DMA has been started and 
set PSE to drop all data before stopping DMA. 

Note, mt7628 is a different IP from other mt762x, so we exclude it
in mtk_gdm_config function.

Signed-off-by: MarkLee <Mark-MC.Lee@mediatek.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 44 ++++++++++++++-------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  2 +
 2 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 703adb96429e..7220abb3e731 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2180,6 +2180,31 @@ static int mtk_start_dma(struct mtk_eth *eth)
 	return 0;
 }
 
+static void mtk_gdm_config(struct mtk_eth *eth, u32 config)
+{
+	int i;
+
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
+		return;
+
+	for (i = 0; i < 2; i++) {
+		u32 val = mtk_r32(eth, MTK_GDMA_FWD_CFG(i));
+
+		/* Always enable RX checksum */
+		val |= MTK_GDMA_ICS_EN | MTK_GDMA_TCS_EN | MTK_GDMA_UCS_EN;
+
+		/* default setup the forward port to send frame to PDMA */
+		val &= ~0xffff;
+
+		val |= config;
+
+		mtk_w32(eth, val, MTK_GDMA_FWD_CFG(i));
+	}
+	/*Reset and enable PSE*/
+	mtk_w32(eth, RST_GL_PSE, MTK_RST_GL);
+	mtk_w32(eth, 0, MTK_RST_GL);
+}
+
 static int mtk_open(struct net_device *dev)
 {
 	struct mtk_mac *mac = netdev_priv(dev);
@@ -2200,6 +2225,8 @@ static int mtk_open(struct net_device *dev)
 		if (err)
 			return err;
 
+		mtk_gdm_config(eth, MTK_GDMA_TO_PDMA);
+
 		napi_enable(&eth->tx_napi);
 		napi_enable(&eth->rx_napi);
 		mtk_tx_irq_enable(eth, MTK_TX_DONE_INT);
@@ -2252,6 +2279,8 @@ static int mtk_stop(struct net_device *dev)
 	if (!refcount_dec_and_test(&eth->dma_refcnt))
 		return 0;
 
+	mtk_gdm_config(eth, MTK_GDMA_DROP_ALL);
+
 	mtk_tx_irq_disable(eth, MTK_TX_DONE_INT);
 	mtk_rx_irq_disable(eth, MTK_RX_DONE_INT);
 	napi_disable(&eth->tx_napi);
@@ -2375,8 +2404,6 @@ static int mtk_hw_init(struct mtk_eth *eth)
 	mtk_w32(eth, 0, MTK_QDMA_DELAY_INT);
 	mtk_tx_irq_disable(eth, ~0);
 	mtk_rx_irq_disable(eth, ~0);
-	mtk_w32(eth, RST_GL_PSE, MTK_RST_GL);
-	mtk_w32(eth, 0, MTK_RST_GL);
 
 	/* FE int grouping */
 	mtk_w32(eth, MTK_TX_DONE_INT, MTK_PDMA_INT_GRP1);
@@ -2385,19 +2412,6 @@ static int mtk_hw_init(struct mtk_eth *eth)
 	mtk_w32(eth, MTK_RX_DONE_INT, MTK_QDMA_INT_GRP2);
 	mtk_w32(eth, 0x21021000, MTK_FE_INT_GRP);
 
-	for (i = 0; i < MTK_MAC_COUNT; i++) {
-		u32 val = mtk_r32(eth, MTK_GDMA_FWD_CFG(i));
-
-		/* setup the forward port to send frame to PDMA */
-		val &= ~0xffff;
-
-		/* Enable RX checksum */
-		val |= MTK_GDMA_ICS_EN | MTK_GDMA_TCS_EN | MTK_GDMA_UCS_EN;
-
-		/* setup the mac dma */
-		mtk_w32(eth, val, MTK_GDMA_FWD_CFG(i));
-	}
-
 	return 0;
 
 err_disable_pm:
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 76bd12cb8150..b8bcfdfc995e 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -84,6 +84,8 @@
 #define MTK_GDMA_ICS_EN		BIT(22)
 #define MTK_GDMA_TCS_EN		BIT(21)
 #define MTK_GDMA_UCS_EN		BIT(20)
+#define MTK_GDMA_DROP_ALL	0x7777
+#define MTK_GDMA_TO_PDMA	0x0
 
 /* Unicast Filter MAC Address Register - Low */
 #define MTK_GDMA_MAC_ADRL(x)	(0x508 + (x * 0x1000))
-- 
2.17.1

