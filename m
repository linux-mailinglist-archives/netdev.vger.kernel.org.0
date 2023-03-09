Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D70006B2241
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 12:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbjCILGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 06:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjCILFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 06:05:30 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF91AEBAC1;
        Thu,  9 Mar 2023 03:00:24 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1paE0T-0003gB-37;
        Thu, 09 Mar 2023 12:00:22 +0100
Date:   Thu, 9 Mar 2023 10:58:44 +0000
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
Cc:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: [PATCH net-next v13 15/16] net: ethernet: mtk_eth_soc: add
 MTK_NETSYS_V3 capability bit
Message-ID: <89e3ee07b988801b1237af3c93d08386d456d87a.1678357225.git.daniel@makrotopia.org>
References: <cover.1678357225.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1678357225.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Introduce MTK_NETSYS_V3 bit in the device capabilities.
This is a preliminary patch to introduce support for MT7988 SoC.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 115 ++++++++++++++++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  44 +++++++-
 2 files changed, 134 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index ce4f2eb3ed0d..08cbbef42555 100644
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
@@ -1937,11 +1968,24 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
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
@@ -2187,7 +2231,9 @@ static int mtk_poll_tx_qdma(struct mtk_eth *eth, int budget,
 		tx_buf = mtk_desc_to_tx_buf(ring, desc,
 					    eth->soc->txrx.txd_size);
 		if (tx_buf->flags & MTK_TX_FLAGS_FPORT1)
-			mac = 1;
+			mac = MTK_GMAC2_ID;
+		else if (tx_buf->flags & MTK_TX_FLAGS_FPORT2)
+			mac = MTK_GMAC3_ID;
 
 		if (!tx_buf->data)
 			break;
@@ -3810,7 +3856,26 @@ static int mtk_hw_init(struct mtk_eth *eth, bool reset)
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
 
@@ -4383,7 +4448,11 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
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
index 8c5f72603604..e4f6cca8a3a8 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -123,6 +123,7 @@
 #define MTK_GDMA_ICS_EN		BIT(22)
 #define MTK_GDMA_TCS_EN		BIT(21)
 #define MTK_GDMA_UCS_EN		BIT(20)
+#define MTK_GDMA_STRP_CRC	BIT(16)
 #define MTK_GDMA_TO_PDMA	0x0
 #define MTK_GDMA_DROP_ALL       0x7777
 
@@ -288,8 +289,6 @@
 /* QDMA Interrupt grouping registers */
 #define MTK_RLS_DONE_INT	BIT(0)
 
-#define MTK_STAT_OFFSET		0x40
-
 /* QDMA TX NUM */
 #define QID_BITS_V2(x)		(((x) & 0x3f) << 16)
 #define MTK_QDMA_GMAC2_QID	8
@@ -302,6 +301,8 @@
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
@@ -725,6 +727,42 @@ enum mtk_dev_state {
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
+/* GDM Type */
+enum mtk_gdm_type {
+	MTK_GDM_TYPE = 0,
+	MTK_XGDM_TYPE,
+	MTK_GDM_TYPE_MAX
+};
+
 enum mtk_tx_buf_type {
 	MTK_TYPE_SKB,
 	MTK_TYPE_XDP_TX,
@@ -821,6 +859,7 @@ enum mkt_eth_capabilities {
 	MTK_QDMA_BIT,
 	MTK_NETSYS_V1_BIT,
 	MTK_NETSYS_V2_BIT,
+	MTK_NETSYS_V3_BIT,
 	MTK_SOC_MT7628_BIT,
 	MTK_RSTCTRL_PPE1_BIT,
 	MTK_U3_COPHY_V2_BIT,
@@ -857,6 +896,7 @@ enum mkt_eth_capabilities {
 #define MTK_QDMA		BIT(MTK_QDMA_BIT)
 #define MTK_NETSYS_V1		BIT(MTK_NETSYS_V1_BIT)
 #define MTK_NETSYS_V2		BIT(MTK_NETSYS_V2_BIT)
+#define MTK_NETSYS_V3		BIT(MTK_NETSYS_V3_BIT)
 #define MTK_SOC_MT7628		BIT(MTK_SOC_MT7628_BIT)
 #define MTK_RSTCTRL_PPE1	BIT(MTK_RSTCTRL_PPE1_BIT)
 #define MTK_U3_COPHY_V2		BIT(MTK_U3_COPHY_V2_BIT)
-- 
2.39.2

