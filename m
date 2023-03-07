Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9BA36AE5A3
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbjCGP64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbjCGP54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:57:56 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E968F8EA27;
        Tue,  7 Mar 2023 07:56:51 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pZZgH-0001ue-1A;
        Tue, 07 Mar 2023 16:56:49 +0100
Date:   Tue, 7 Mar 2023 15:55:13 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v12 14/18] net: ethernet: mtk_eth_soc: add
 MTK_NETSYS_V1 capability bit
Message-ID: <e60efc0ca068723a9299107294376665eade3845.1678201958.git.daniel@makrotopia.org>
References: <cover.1678201958.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1678201958.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Introduce MTK_NETSYS_V1 bit in the device capabilities for
MT7621/MT7622/MT7623/MT7628/MT7629 SoCs.
Use !MTK_NETSYS_V1 instead of MTK_NETSYS_V2 in the driver codebase.
This is a preliminary patch to introduce support for MT7988 SoC.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 30 +++++++-------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 45 ++++++++++++---------
 2 files changed, 41 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 817951718681..e34065e17446 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -683,7 +683,7 @@ static void mtk_set_queue_speed(struct mtk_eth *eth, unsigned int idx,
 	      FIELD_PREP(MTK_QTX_SCH_MIN_RATE_MAN, 1) |
 	      FIELD_PREP(MTK_QTX_SCH_MIN_RATE_EXP, 4) |
 	      MTK_QTX_SCH_LEAKY_BUCKET_SIZE;
-	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1))
 		val |= MTK_QTX_SCH_LEAKY_BUCKET_EN;
 
 	if (IS_ENABLED(CONFIG_SOC_MT7621)) {
@@ -1062,7 +1062,7 @@ static bool mtk_rx_get_desc(struct mtk_eth *eth, struct mtk_rx_dma_v2 *rxd,
 	rxd->rxd1 = READ_ONCE(dma_rxd->rxd1);
 	rxd->rxd3 = READ_ONCE(dma_rxd->rxd3);
 	rxd->rxd4 = READ_ONCE(dma_rxd->rxd4);
-	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1)) {
 		rxd->rxd5 = READ_ONCE(dma_rxd->rxd5);
 		rxd->rxd6 = READ_ONCE(dma_rxd->rxd6);
 	}
@@ -1120,7 +1120,7 @@ static int mtk_init_fq_dma(struct mtk_eth *eth)
 
 		txd->txd3 = TX_DMA_PLEN0(MTK_QDMA_PAGE_SIZE);
 		txd->txd4 = 0;
-		if (MTK_HAS_CAPS(soc->caps, MTK_NETSYS_V2)) {
+		if (!MTK_HAS_CAPS(soc->caps, MTK_NETSYS_V1)) {
 			txd->txd5 = 0;
 			txd->txd6 = 0;
 			txd->txd7 = 0;
@@ -1311,7 +1311,7 @@ static void mtk_tx_set_dma_desc(struct net_device *dev, void *txd,
 	struct mtk_mac *mac = netdev_priv(dev);
 	struct mtk_eth *eth = mac->hw;
 
-	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1))
 		mtk_tx_set_dma_desc_v2(dev, txd, info);
 	else
 		mtk_tx_set_dma_desc_v1(dev, txd, info);
@@ -1962,7 +1962,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			break;
 
 		/* find out which mac the packet come from. values start at 1 */
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1))
 			mac = RX_DMA_GET_SPORT_V2(trxd.rxd5) - 1;
 		else if (!MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628) &&
 			 !(trxd.rxd4 & RX_DMA_SPECIAL_TAG))
@@ -2058,7 +2058,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		skb->dev = netdev;
 		bytes += skb->len;
 
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+		if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1)) {
 			reason = FIELD_GET(MTK_RXD5_PPE_CPU_REASON, trxd.rxd5);
 			hash = trxd.rxd5 & MTK_RXD5_FOE_ENTRY;
 			if (hash != MTK_RXD5_FOE_ENTRY)
@@ -2084,7 +2084,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			mtk_ppe_check_skb(eth->ppe[0], skb, hash);
 
 		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
-			if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+			if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1)) {
 				if (trxd.rxd3 & RX_DMA_VTAG_V2) {
 					vlan_proto = RX_DMA_VPID(trxd.rxd4);
 					vlan_tci = RX_DMA_VID(trxd.rxd4);
@@ -2409,7 +2409,7 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 		txd->txd2 = next_ptr;
 		txd->txd3 = TX_DMA_LS0 | TX_DMA_OWNER_CPU;
 		txd->txd4 = 0;
-		if (MTK_HAS_CAPS(soc->caps, MTK_NETSYS_V2)) {
+		if (!MTK_HAS_CAPS(soc->caps, MTK_NETSYS_V1)) {
 			txd->txd5 = 0;
 			txd->txd6 = 0;
 			txd->txd7 = 0;
@@ -2462,7 +2462,7 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 			      FIELD_PREP(MTK_QTX_SCH_MIN_RATE_MAN, 1) |
 			      FIELD_PREP(MTK_QTX_SCH_MIN_RATE_EXP, 4) |
 			      MTK_QTX_SCH_LEAKY_BUCKET_SIZE;
-			if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+			if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1))
 				val |= MTK_QTX_SCH_LEAKY_BUCKET_EN;
 			mtk_w32(eth, val, soc->reg_map->qdma.qtx_sch + ofs);
 			ofs += MTK_QTX_OFFSET;
@@ -2598,7 +2598,7 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 
 		rxd->rxd3 = 0;
 		rxd->rxd4 = 0;
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+		if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1)) {
 			rxd->rxd5 = 0;
 			rxd->rxd6 = 0;
 			rxd->rxd7 = 0;
@@ -3164,7 +3164,7 @@ static int mtk_start_dma(struct mtk_eth *eth)
 		       MTK_TX_BT_32DWORDS | MTK_NDP_CO_PRO |
 		       MTK_RX_2B_OFFSET | MTK_TX_WB_DDONE;
 
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1))
 			val |= MTK_MUTLI_CNT | MTK_RESV_BUF |
 			       MTK_WCOMP_EN | MTK_DMAD_WR_WDONE |
 			       MTK_CHK_DDONE_EN | MTK_LEAKY_BUCKET_EN;
@@ -3567,7 +3567,7 @@ static void mtk_hw_reset(struct mtk_eth *eth)
 {
 	u32 val;
 
-	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1)) {
 		regmap_write(eth->ethsys, ETHSYS_FE_RST_CHK_IDLE_EN, 0);
 		val = RSTCTRL_PPE0_V2;
 	} else {
@@ -3579,7 +3579,7 @@ static void mtk_hw_reset(struct mtk_eth *eth)
 
 	ethsys_reset(eth, RSTCTRL_ETH | RSTCTRL_FE | val);
 
-	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1))
 		regmap_write(eth->ethsys, ETHSYS_FE_RST_CHK_IDLE_EN,
 			     0x3ffffff);
 }
@@ -3775,7 +3775,7 @@ static int mtk_hw_init(struct mtk_eth *eth, bool reset)
 	else
 		mtk_hw_reset(eth);
 
-	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1)) {
 		/* Set FE to PDMAv2 if necessary */
 		val = mtk_r32(eth, MTK_FE_GLO_MISC);
 		mtk_w32(eth,  val | BIT(4), MTK_FE_GLO_MISC);
@@ -3812,7 +3812,7 @@ static int mtk_hw_init(struct mtk_eth *eth, bool reset)
 	 */
 	val = mtk_r32(eth, MTK_CDMQ_IG_CTRL);
 	mtk_w32(eth, val | MTK_CDMQ_STAG_EN, MTK_CDMQ_IG_CTRL);
-	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1)) {
 		val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
 		mtk_w32(eth, val | MTK_CDMP_STAG_EN, MTK_CDMP_IG_CTRL);
 	}
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 3dfa880da41a..cb3cdf0b38d5 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -820,6 +820,7 @@ enum mkt_eth_capabilities {
 	MTK_SHARED_INT_BIT,
 	MTK_TRGMII_MT7621_CLK_BIT,
 	MTK_QDMA_BIT,
+	MTK_NETSYS_V1_BIT,
 	MTK_NETSYS_V2_BIT,
 	MTK_SOC_MT7628_BIT,
 	MTK_RSTCTRL_PPE1_BIT,
@@ -855,6 +856,7 @@ enum mkt_eth_capabilities {
 #define MTK_SHARED_INT		BIT(MTK_SHARED_INT_BIT)
 #define MTK_TRGMII_MT7621_CLK	BIT(MTK_TRGMII_MT7621_CLK_BIT)
 #define MTK_QDMA		BIT(MTK_QDMA_BIT)
+#define MTK_NETSYS_V1		BIT(MTK_NETSYS_V1_BIT)
 #define MTK_NETSYS_V2		BIT(MTK_NETSYS_V2_BIT)
 #define MTK_SOC_MT7628		BIT(MTK_SOC_MT7628_BIT)
 #define MTK_RSTCTRL_PPE1	BIT(MTK_RSTCTRL_PPE1_BIT)
@@ -911,25 +913,30 @@ enum mkt_eth_capabilities {
 
 #define MTK_HAS_CAPS(caps, _x)		(((caps) & (_x)) == (_x))
 
-#define MT7621_CAPS  (MTK_GMAC1_RGMII | MTK_GMAC1_TRGMII | \
-		      MTK_GMAC2_RGMII | MTK_SHARED_INT | \
-		      MTK_TRGMII_MT7621_CLK | MTK_QDMA)
-
-#define MT7622_CAPS  (MTK_GMAC1_RGMII | MTK_GMAC1_SGMII | MTK_GMAC2_RGMII | \
-		      MTK_GMAC2_SGMII | MTK_GDM1_ESW | \
-		      MTK_MUX_GDM1_TO_GMAC1_ESW | \
-		      MTK_MUX_GMAC1_GMAC2_TO_SGMII_RGMII | MTK_QDMA)
-
-#define MT7623_CAPS  (MTK_GMAC1_RGMII | MTK_GMAC1_TRGMII | MTK_GMAC2_RGMII | \
-		      MTK_QDMA)
-
-#define MT7628_CAPS  (MTK_SHARED_INT | MTK_SOC_MT7628)
-
-#define MT7629_CAPS  (MTK_GMAC1_SGMII | MTK_GMAC2_SGMII | MTK_GMAC2_GEPHY | \
-		      MTK_GDM1_ESW | MTK_MUX_GDM1_TO_GMAC1_ESW | \
-		      MTK_MUX_GMAC2_GMAC0_TO_GEPHY | \
-		      MTK_MUX_U3_GMAC2_TO_QPHY | \
-		      MTK_MUX_GMAC12_TO_GEPHY_SGMII | MTK_QDMA)
+#define MT7621_CAPS  (MTK_GMAC1_RGMII | MTK_GMAC1_TRGMII |	\
+		      MTK_GMAC2_RGMII | MTK_SHARED_INT |	\
+		      MTK_TRGMII_MT7621_CLK | MTK_QDMA |	\
+		      MTK_NETSYS_V1)
+
+#define MT7622_CAPS  (MTK_GMAC1_RGMII | MTK_GMAC1_SGMII |	\
+		      MTK_GMAC2_RGMII | MTK_GMAC2_SGMII |	\
+		      MTK_GDM1_ESW | MTK_MUX_GDM1_TO_GMAC1_ESW |\
+		      MTK_MUX_GMAC1_GMAC2_TO_SGMII_RGMII |	\
+		      MTK_QDMA | MTK_NETSYS_V1)
+
+#define MT7623_CAPS  (MTK_GMAC1_RGMII | MTK_GMAC1_TRGMII |	\
+		      MTK_GMAC2_RGMII | MTK_QDMA |		\
+		      MTK_NETSYS_V1)
+
+#define MT7628_CAPS  (MTK_SHARED_INT | MTK_SOC_MT7628 |		\
+		      MTK_NETSYS_V1)
+
+#define MT7629_CAPS  (MTK_GMAC1_SGMII | MTK_GMAC2_SGMII |	\
+		      MTK_GMAC2_GEPHY | MTK_GDM1_ESW |		\
+		      MTK_MUX_GMAC2_GMAC0_TO_GEPHY | MTK_QDMA |	\
+		      MTK_MUX_U3_GMAC2_TO_QPHY | MTK_NETSYS_V1 |\
+		      MTK_MUX_GDM1_TO_GMAC1_ESW |		\
+		      MTK_MUX_GMAC12_TO_GEPHY_SGMII)
 
 #define MT7981_CAPS  (MTK_GMAC1_SGMII | MTK_GMAC2_SGMII | MTK_GMAC2_GEPHY | \
 		      MTK_MUX_GMAC12_TO_GEPHY_SGMII | MTK_QDMA | \
-- 
2.39.2

