Return-Path: <netdev+bounces-9858-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14B7C72AFD3
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 02:39:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C32EF2813FE
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 00:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E96F210E3;
	Sun, 11 Jun 2023 00:39:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9807F0
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 00:39:11 +0000 (UTC)
Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7F130F6;
	Sat, 10 Jun 2023 17:39:09 -0700 (PDT)
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.96)
	(envelope-from <daniel@makrotopia.org>)
	id 1q896o-0005EM-2E;
	Sun, 11 Jun 2023 00:39:06 +0000
Date: Sun, 11 Jun 2023 01:38:23 +0100
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
Subject: [PATCH net-next 5/8] net: ethernet: mtk_eth_soc: add MTK_NETSYS_V3
 capability bit
Message-ID: <ZIUXf9APDFCNaUG1@makrotopia.org>
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

Introduce MTK_NETSYS_V3 bit in the device capabilities.
This is a preliminary patch to introduce support for MT7988 SoC.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 115 ++++++++++++++++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  37 ++++++-
 2 files changed, 127 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 45b6f85f0822c..d516917effca6 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -943,17 +943,32 @@ void mtk_stats_update_mac(struct mtk_mac *mac)
 			mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x20 + offs);
 		hw_stats->rx_flow_control_packets +=
 			mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x24 + offs);
-		hw_stats->tx_skip +=
-			mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x28 + offs);
-		hw_stats->tx_collisions +=
-			mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x2c + offs);
-		hw_stats->tx_bytes +=
-			mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x30 + offs);
-		stats =  mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x34 + offs);
-		if (stats)
-			hw_stats->tx_bytes += (stats << 32);
-		hw_stats->tx_packets +=
-			mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x38 + offs);
+
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V3)) {
+			hw_stats->tx_skip +=
+				mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x50 + offs);
+			hw_stats->tx_collisions +=
+				mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x54 + offs);
+			hw_stats->tx_bytes +=
+				mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x40 + offs);
+			stats =  mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x44 + offs);
+			if (stats)
+				hw_stats->tx_bytes += (stats << 32);
+			hw_stats->tx_packets +=
+				mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x48 + offs);
+		} else {
+			hw_stats->tx_skip +=
+				mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x28 + offs);
+			hw_stats->tx_collisions +=
+				mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x2c + offs);
+			hw_stats->tx_bytes +=
+				mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x30 + offs);
+			stats =  mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x34 + offs);
+			if (stats)
+				hw_stats->tx_bytes += (stats << 32);
+			hw_stats->tx_packets +=
+				mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x38 + offs);
+		}
 	}
 
 	u64_stats_update_end(&hw_stats->syncp);
@@ -1257,7 +1272,10 @@ static void mtk_tx_set_dma_desc_v2(struct net_device *dev, void *txd,
 		data |= TX_DMA_LS0;
 	WRITE_ONCE(desc->txd3, data);
 
-	data = (mac->id + 1) << TX_DMA_FPORT_SHIFT_V2; /* forward port */
+	if (mac->id == MTK_GMAC3_ID)
+		data = PSE_GDM3_PORT;
+	else
+		data = (mac->id + 1) << TX_DMA_FPORT_SHIFT_V2; /* forward port */
 	data |= TX_DMA_SWC_V2 | QID_BITS_V2(info->qid);
 	WRITE_ONCE(desc->txd4, data);
 
@@ -1268,6 +1286,9 @@ static void mtk_tx_set_dma_desc_v2(struct net_device *dev, void *txd,
 		/* tx checksum offload */
 		if (info->csum)
 			data |= TX_DMA_CHKSUM_V2;
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V3) &&
+		    netdev_uses_dsa(dev))
+			data |= TX_DMA_SPTAG_V3;
 	}
 	WRITE_ONCE(desc->txd5, data);
 
@@ -1333,8 +1354,13 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 	mtk_tx_set_dma_desc(dev, itxd, &txd_info);
 
 	itx_buf->flags |= MTK_TX_FLAGS_SINGLE0;
-	itx_buf->flags |= (!mac->id) ? MTK_TX_FLAGS_FPORT0 :
-			  MTK_TX_FLAGS_FPORT1;
+	if (mac->id == MTK_GMAC1_ID)
+		itx_buf->flags |= MTK_TX_FLAGS_FPORT0;
+	else if (mac->id == MTK_GMAC2_ID)
+		itx_buf->flags |= MTK_TX_FLAGS_FPORT1;
+	else
+		itx_buf->flags |= MTK_TX_FLAGS_FPORT2;
+
 	setup_tx_buf(eth, itx_buf, itxd_pdma, txd_info.addr, txd_info.size,
 		     k++);
 
@@ -1382,8 +1408,13 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 				memset(tx_buf, 0, sizeof(*tx_buf));
 			tx_buf->data = (void *)MTK_DMA_DUMMY_DESC;
 			tx_buf->flags |= MTK_TX_FLAGS_PAGE0;
-			tx_buf->flags |= (!mac->id) ? MTK_TX_FLAGS_FPORT0 :
-					 MTK_TX_FLAGS_FPORT1;
+
+			if (mac->id == MTK_GMAC1_ID)
+				tx_buf->flags |= MTK_TX_FLAGS_FPORT0;
+			else if (mac->id == MTK_GMAC2_ID)
+				tx_buf->flags |= MTK_TX_FLAGS_FPORT1;
+			else
+				tx_buf->flags |= MTK_TX_FLAGS_FPORT2;
 
 			setup_tx_buf(eth, tx_buf, txd_pdma, txd_info.addr,
 				     txd_info.size, k++);
@@ -1935,11 +1966,24 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			break;
 
 		/* find out which mac the packet come from. values start at 1 */
-		if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1))
-			mac = RX_DMA_GET_SPORT_V2(trxd.rxd5) - 1;
-		else if (!MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628) &&
-			 !(trxd.rxd4 & RX_DMA_SPECIAL_TAG))
+		if (!MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V1)) {
+			u32 val = RX_DMA_GET_SPORT_V2(trxd.rxd5);
+
+			switch (val) {
+			case PSE_GDM1_PORT:
+			case PSE_GDM2_PORT:
+				mac = val - 1;
+				break;
+			case PSE_GDM3_PORT:
+				mac = MTK_GMAC3_ID;
+				break;
+			default:
+				break;
+			}
+		} else if (!MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628) &&
+			 !(trxd.rxd4 & RX_DMA_SPECIAL_TAG)) {
 			mac = RX_DMA_GET_SPORT(trxd.rxd4) - 1;
+		}
 
 		if (unlikely(mac < 0 || mac >= eth->soc->num_devs ||
 			     !eth->netdev[mac]))
@@ -2170,7 +2214,9 @@ static int mtk_poll_tx_qdma(struct mtk_eth *eth, int budget,
 		tx_buf = mtk_desc_to_tx_buf(ring, desc,
 					    eth->soc->txrx.txd_size);
 		if (tx_buf->flags & MTK_TX_FLAGS_FPORT1)
-			mac = 1;
+			mac = MTK_GMAC2_ID;
+		else if (tx_buf->flags & MTK_TX_FLAGS_FPORT2)
+			mac = MTK_GMAC3_ID;
 
 		if (!tx_buf->data)
 			break;
@@ -3783,7 +3829,26 @@ static int mtk_hw_init(struct mtk_eth *eth, bool reset)
 	mtk_w32(eth, eth->soc->txrx.rx_irq_done_mask, reg_map->qdma.int_grp + 4);
 	mtk_w32(eth, 0x21021000, MTK_FE_INT_GRP);
 
-	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V3)) {
+		/* PSE should not drop port1, port8 and port9 packets */
+		mtk_w32(eth, 0x00000302, PSE_DROP_CFG);
+
+		/* GDM and CDM Threshold */
+		mtk_w32(eth, 0x00000707, MTK_CDMW0_THRES);
+		mtk_w32(eth, 0x00000077, MTK_CDMW1_THRES);
+
+		/* Disable GDM1 RX CRC stripping */
+		val = mtk_r32(eth, MTK_GDMA_FWD_CFG(0));
+		val &= ~MTK_GDMA_STRP_CRC;
+		mtk_w32(eth, val, MTK_GDMA_FWD_CFG(0));
+
+		/* PSE GDM3 MIB counter has incorrect hw default values,
+		 * so the driver ought to read clear the values beforehand
+		 * in case ethtool retrieve wrong mib values.
+		 */
+		for (i = 0; i < 0x80; i += 0x4)
+			mtk_r32(eth, reg_map->gdm1_cnt + 0x100 + i);
+	} else if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
 		/* PSE should not drop port8 and port9 packets from WDMA Tx */
 		mtk_w32(eth, 0x00000300, PSE_DROP_CFG);
 
@@ -4356,7 +4421,11 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 	}
 	spin_lock_init(&mac->hw_stats->stats_lock);
 	u64_stats_init(&mac->hw_stats->syncp);
-	mac->hw_stats->reg_offset = id * MTK_STAT_OFFSET;
+
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V3))
+		mac->hw_stats->reg_offset = id * 0x80;
+	else
+		mac->hw_stats->reg_offset = id * 0x40;
 
 	/* phylink create */
 	err = of_get_phy_mode(np, &phy_mode);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 2af7e46cadcbb..08d1e73985f08 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -122,6 +122,7 @@
 #define MTK_GDMA_ICS_EN		BIT(22)
 #define MTK_GDMA_TCS_EN		BIT(21)
 #define MTK_GDMA_UCS_EN		BIT(20)
+#define MTK_GDMA_STRP_CRC	BIT(16)
 #define MTK_GDMA_TO_PDMA	0x0
 #define MTK_GDMA_DROP_ALL       0x7777
 
@@ -287,8 +288,6 @@
 /* QDMA Interrupt grouping registers */
 #define MTK_RLS_DONE_INT	BIT(0)
 
-#define MTK_STAT_OFFSET		0x40
-
 /* QDMA TX NUM */
 #define QID_BITS_V2(x)		(((x) & 0x3f) << 16)
 #define MTK_QDMA_GMAC2_QID	8
@@ -301,6 +300,8 @@
 #define TX_DMA_CHKSUM_V2	(0x7 << 28)
 #define TX_DMA_TSO_V2		BIT(31)
 
+#define TX_DMA_SPTAG_V3         BIT(27)
+
 /* QDMA V2 descriptor txd4 */
 #define TX_DMA_FPORT_SHIFT_V2	8
 #define TX_DMA_FPORT_MASK_V2	0xf
@@ -640,6 +641,7 @@ enum mtk_tx_flags {
 	 */
 	MTK_TX_FLAGS_FPORT0	= 0x04,
 	MTK_TX_FLAGS_FPORT1	= 0x08,
+	MTK_TX_FLAGS_FPORT2	= 0x10,
 };
 
 /* This enum allows us to identify how the clock is defined on the array of the
@@ -725,6 +727,35 @@ enum mtk_dev_state {
 	MTK_RESETTING
 };
 
+/* PSE Port Definition */
+enum mtk_pse_port {
+	PSE_ADMA_PORT = 0,
+	PSE_GDM1_PORT,
+	PSE_GDM2_PORT,
+	PSE_PPE0_PORT,
+	PSE_PPE1_PORT,
+	PSE_QDMA_TX_PORT,
+	PSE_QDMA_RX_PORT,
+	PSE_DROP_PORT,
+	PSE_WDMA0_PORT,
+	PSE_WDMA1_PORT,
+	PSE_TDMA_PORT,
+	PSE_NONE_PORT,
+	PSE_PPE2_PORT,
+	PSE_WDMA2_PORT,
+	PSE_EIP197_PORT,
+	PSE_GDM3_PORT,
+	PSE_PORT_MAX
+};
+
+/* GMAC Identifier */
+enum mtk_gmac_id {
+	MTK_GMAC1_ID = 0,
+	MTK_GMAC2_ID,
+	MTK_GMAC3_ID,
+	MTK_GMAC_ID_MAX
+};
+
 enum mtk_tx_buf_type {
 	MTK_TYPE_SKB,
 	MTK_TYPE_XDP_TX,
@@ -821,6 +852,7 @@ enum mkt_eth_capabilities {
 	MTK_QDMA_BIT,
 	MTK_NETSYS_V1_BIT,
 	MTK_NETSYS_V2_BIT,
+	MTK_NETSYS_V3_BIT,
 	MTK_SOC_MT7628_BIT,
 	MTK_RSTCTRL_PPE1_BIT,
 	MTK_U3_COPHY_V2_BIT,
@@ -857,6 +889,7 @@ enum mkt_eth_capabilities {
 #define MTK_QDMA		BIT(MTK_QDMA_BIT)
 #define MTK_NETSYS_V1		BIT(MTK_NETSYS_V1_BIT)
 #define MTK_NETSYS_V2		BIT(MTK_NETSYS_V2_BIT)
+#define MTK_NETSYS_V3		BIT(MTK_NETSYS_V3_BIT)
 #define MTK_SOC_MT7628		BIT(MTK_SOC_MT7628_BIT)
 #define MTK_RSTCTRL_PPE1	BIT(MTK_RSTCTRL_PPE1_BIT)
 #define MTK_U3_COPHY_V2		BIT(MTK_U3_COPHY_V2_BIT)
-- 
2.41.0


