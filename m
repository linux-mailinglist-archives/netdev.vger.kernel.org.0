Return-Path: <netdev+bounces-9855-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D27672AFC8
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 02:34:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 442D82811DF
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 00:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 876E710E3;
	Sun, 11 Jun 2023 00:34:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FDD7F0
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 00:34:38 +0000 (UTC)
Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9151935AD;
	Sat, 10 Jun 2023 17:34:36 -0700 (PDT)
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.96)
	(envelope-from <daniel@makrotopia.org>)
	id 1q892R-0005C4-07;
	Sun, 11 Jun 2023 00:34:35 +0000
Date: Sun, 11 Jun 2023 01:33:51 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Mark Lee <Mark-MC.Lee@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>, John Crispin <john@phrozen.org>,
	Felix Fietkau <nbd@nbd.name>, Conor Dooley <conor+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Rob Herring <robh+dt@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sam Shih <Sam.Shih@mediatek.com>
Subject: [PATCH net-next 2/8] net: ethernet: mtk_eth_soc: add MTK_NETSYS_V1
 capability bit
Message-ID: <ZIUWb2T4hwfO_pfe@makrotopia.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Lorenzo Bianconi <lorenzo@kernel.org>

Introduce MTK_NETSYS_V1 bit in the device capabilities for
MT7621/MT7622/MT7623/MT7628/MT7629 SoCs.
Use !MTK_NETSYS_V1 instead of MTK_NETSYS_V2 in the driver codebase.
This is a preliminary patch to introduce support for MT7988 SoC.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 28 ++++++-------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 45 ++++++++++++---------
 2 files changed, 40 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 834c644b67db5..7014e0d108b27 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -659,7 +659,7 @@ static void mtk_set_queue_speed(struct mtk_eth *eth, unsigned int idx,
 	      FIELD_PREP(MTK_QTX_SCH_MIN_RATE_MAN, 1) |
 	      FIELD_PREP(MTK_QTX_SCH_MIN_RATE_EXP, 4) |
 	      MTK_QTX_SCH_LEAKY_BUCKET_SIZE;
-	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1))
 		val |= MTK_QTX_SCH_LEAKY_BUCKET_EN;
 
 	if (IS_ENABLED(CONFIG_SOC_MT7621)) {
@@ -1037,7 +1037,7 @@ static bool mtk_rx_get_desc(struct mtk_eth *eth, struct mtk_rx_dma_v2 *rxd,
 	rxd->rxd1 = READ_ONCE(dma_rxd->rxd1);
 	rxd->rxd3 = READ_ONCE(dma_rxd->rxd3);
 	rxd->rxd4 = READ_ONCE(dma_rxd->rxd4);
-	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1)) {
 		rxd->rxd5 = READ_ONCE(dma_rxd->rxd5);
 		rxd->rxd6 = READ_ONCE(dma_rxd->rxd6);
 	}
@@ -1095,7 +1095,7 @@ static int mtk_init_fq_dma(struct mtk_eth *eth)
 
 		txd->txd3 = TX_DMA_PLEN0(MTK_QDMA_PAGE_SIZE);
 		txd->txd4 = 0;
-		if (MTK_HAS_CAPS(soc->caps, MTK_NETSYS_V2)) {
+		if (!MTK_HAS_CAPS(soc->caps, MTK_NETSYS_V1)) {
 			txd->txd5 = 0;
 			txd->txd6 = 0;
 			txd->txd7 = 0;
@@ -1286,7 +1286,7 @@ static void mtk_tx_set_dma_desc(struct net_device *dev, void *txd,
 	struct mtk_mac *mac = netdev_priv(dev);
 	struct mtk_eth *eth = mac->hw;
 
-	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1))
 		mtk_tx_set_dma_desc_v2(dev, txd, info);
 	else
 		mtk_tx_set_dma_desc_v1(dev, txd, info);
@@ -1935,7 +1935,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			break;
 
 		/* find out which mac the packet come from. values start at 1 */
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1))
 			mac = RX_DMA_GET_SPORT_V2(trxd.rxd5) - 1;
 		else if (!MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628) &&
 			 !(trxd.rxd4 & RX_DMA_SPECIAL_TAG))
@@ -2031,7 +2031,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		skb->dev = netdev;
 		bytes += skb->len;
 
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+		if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1)) {
 			reason = FIELD_GET(MTK_RXD5_PPE_CPU_REASON, trxd.rxd5);
 			hash = trxd.rxd5 & MTK_RXD5_FOE_ENTRY;
 			if (hash != MTK_RXD5_FOE_ENTRY)
@@ -2367,7 +2367,7 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 		txd->txd2 = next_ptr;
 		txd->txd3 = TX_DMA_LS0 | TX_DMA_OWNER_CPU;
 		txd->txd4 = 0;
-		if (MTK_HAS_CAPS(soc->caps, MTK_NETSYS_V2)) {
+		if (!MTK_HAS_CAPS(soc->caps, MTK_NETSYS_V1)) {
 			txd->txd5 = 0;
 			txd->txd6 = 0;
 			txd->txd7 = 0;
@@ -2420,7 +2420,7 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 			      FIELD_PREP(MTK_QTX_SCH_MIN_RATE_MAN, 1) |
 			      FIELD_PREP(MTK_QTX_SCH_MIN_RATE_EXP, 4) |
 			      MTK_QTX_SCH_LEAKY_BUCKET_SIZE;
-			if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+			if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1))
 				val |= MTK_QTX_SCH_LEAKY_BUCKET_EN;
 			mtk_w32(eth, val, soc->reg_map->qdma.qtx_sch + ofs);
 			ofs += MTK_QTX_OFFSET;
@@ -2556,7 +2556,7 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 
 		rxd->rxd3 = 0;
 		rxd->rxd4 = 0;
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+		if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1)) {
 			rxd->rxd5 = 0;
 			rxd->rxd6 = 0;
 			rxd->rxd7 = 0;
@@ -3104,7 +3104,7 @@ static int mtk_start_dma(struct mtk_eth *eth)
 		       MTK_TX_BT_32DWORDS | MTK_NDP_CO_PRO |
 		       MTK_RX_2B_OFFSET | MTK_TX_WB_DDONE;
 
-		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1))
 			val |= MTK_MUTLI_CNT | MTK_RESV_BUF |
 			       MTK_WCOMP_EN | MTK_DMAD_WR_WDONE |
 			       MTK_CHK_DDONE_EN | MTK_LEAKY_BUCKET_EN;
@@ -3516,7 +3516,7 @@ static void mtk_hw_reset(struct mtk_eth *eth)
 {
 	u32 val;
 
-	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1)) {
 		regmap_write(eth->ethsys, ETHSYS_FE_RST_CHK_IDLE_EN, 0);
 		val = RSTCTRL_PPE0_V2;
 	} else {
@@ -3528,7 +3528,7 @@ static void mtk_hw_reset(struct mtk_eth *eth)
 
 	ethsys_reset(eth, RSTCTRL_ETH | RSTCTRL_FE | val);
 
-	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1))
 		regmap_write(eth->ethsys, ETHSYS_FE_RST_CHK_IDLE_EN,
 			     0x3ffffff);
 }
@@ -3724,7 +3724,7 @@ static int mtk_hw_init(struct mtk_eth *eth, bool reset)
 	else
 		mtk_hw_reset(eth);
 
-	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1)) {
 		/* Set FE to PDMAv2 if necessary */
 		val = mtk_r32(eth, MTK_FE_GLO_MISC);
 		mtk_w32(eth,  val | BIT(4), MTK_FE_GLO_MISC);
@@ -3761,7 +3761,7 @@ static int mtk_hw_init(struct mtk_eth *eth, bool reset)
 	 */
 	val = mtk_r32(eth, MTK_CDMQ_IG_CTRL);
 	mtk_w32(eth, val | MTK_CDMQ_STAG_EN, MTK_CDMQ_IG_CTRL);
-	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1)) {
 		val = mtk_r32(eth, MTK_CDMP_IG_CTRL);
 		mtk_w32(eth, val | MTK_CDMP_STAG_EN, MTK_CDMP_IG_CTRL);
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 707445f6bcb1b..c74c3918113a5 100644
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
2.41.0


