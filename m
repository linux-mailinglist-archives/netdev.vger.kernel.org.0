Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9EE52F245
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 20:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352470AbiETSNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 14:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352469AbiETSNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 14:13:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CFD18FF03;
        Fri, 20 May 2022 11:13:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03F2CB82D77;
        Fri, 20 May 2022 18:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE066C34114;
        Fri, 20 May 2022 18:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653070377;
        bh=89mGVCDs5WpPImVKuyWK4ZWdnVhr/6Da/1I72VS/o08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uWLRrOWcJPSZqdE9jKeTTiJOK3IBettYk9qRMD40Iby/0/8AUbvKYvSo3pqgKQyxA
         NaKsfwH/xXo/+6gave4qBggOfwA3iSmlKWx9/JvUJM8e741cPlkm50h0RO896QF3YJ
         3mwQTbwqT5ilNHwnttJG3pAHIZfBaFZfX9yJGXq6zcyZz0dPxYCmYqTpGr5OU05BXK
         Mp7WTjZkM9XqRHv5iehG6eT1mP0aj4vAoMnLzJmfTbTohSkevqQtj0LfHu8N/mTKlN
         oap1iZYKvZvOAHYwwMYWTQiMQ3Jf0ogLgPyfwUopoK8Fvoz+jDbsYSOH5bK5fAp0JU
         cRa+MqQH8WedA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        robh@kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v3 net-next 12/16] net: ethernet: mtk_eth_soc: introduce device register map
Date:   Fri, 20 May 2022 20:11:35 +0200
Message-Id: <96dc79ff93df47be7f290387f387ed72c5ecfec5.1653069056.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1653069056.git.lorenzo@kernel.org>
References: <cover.1653069056.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce reg_map structure to add the capability to support different
register definitions. Move register definitions in mtk_regmap structure.
This is a preliminary patch to introduce mt7986 ethernet support.

Tested-by: Sam Shih <sam.shih@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 223 +++++++++++++-------
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 146 ++++---------
 2 files changed, 188 insertions(+), 181 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 4706e3708bbc..503829a9c270 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -34,6 +34,59 @@ MODULE_PARM_DESC(msg_level, "Message level (-1=defaults,0=none,...,16=all)");
 #define MTK_ETHTOOL_STAT(x) { #x, \
 			      offsetof(struct mtk_hw_stats, x) / sizeof(u64) }
 
+static const struct mtk_reg_map mtk_reg_map = {
+	.tx_irq_mask		= 0x1a1c,
+	.tx_irq_status		= 0x1a18,
+	.pdma = {
+		.rx_ptr		= 0x0900,
+		.rx_cnt_cfg	= 0x0904,
+		.pcrx_ptr	= 0x0908,
+		.glo_cfg	= 0x0a04,
+		.rst_idx	= 0x0a08,
+		.delay_irq	= 0x0a0c,
+		.irq_status	= 0x0a20,
+		.irq_mask	= 0x0a28,
+		.int_grp	= 0x0a50,
+	},
+	.qdma = {
+		.qtx_cfg	= 0x1800,
+		.rx_ptr		= 0x1900,
+		.rx_cnt_cfg	= 0x1904,
+		.qcrx_ptr	= 0x1908,
+		.glo_cfg	= 0x1a04,
+		.rst_idx	= 0x1a08,
+		.delay_irq	= 0x1a0c,
+		.fc_th		= 0x1a10,
+		.int_grp	= 0x1a20,
+		.hred		= 0x1a44,
+		.ctx_ptr	= 0x1b00,
+		.dtx_ptr	= 0x1b04,
+		.crx_ptr	= 0x1b10,
+		.drx_ptr	= 0x1b14,
+		.fq_head	= 0x1b20,
+		.fq_tail	= 0x1b24,
+		.fq_count	= 0x1b28,
+		.fq_blen	= 0x1b2c,
+	},
+	.gdm1_cnt		= 0x2400,
+};
+
+static const struct mtk_reg_map mt7628_reg_map = {
+	.tx_irq_mask		= 0x0a28,
+	.tx_irq_status		= 0x0a20,
+	.pdma = {
+		.rx_ptr		= 0x0900,
+		.rx_cnt_cfg	= 0x0904,
+		.pcrx_ptr	= 0x0908,
+		.glo_cfg	= 0x0a04,
+		.rst_idx	= 0x0a08,
+		.delay_irq	= 0x0a0c,
+		.irq_status	= 0x0a20,
+		.irq_mask	= 0x0a28,
+		.int_grp	= 0x0a50,
+	},
+};
+
 /* strings used by ethtool */
 static const struct mtk_ethtool_stats {
 	char str[ETH_GSTRING_LEN];
@@ -600,8 +653,8 @@ static inline void mtk_tx_irq_disable(struct mtk_eth *eth, u32 mask)
 	u32 val;
 
 	spin_lock_irqsave(&eth->tx_irq_lock, flags);
-	val = mtk_r32(eth, eth->tx_int_mask_reg);
-	mtk_w32(eth, val & ~mask, eth->tx_int_mask_reg);
+	val = mtk_r32(eth, eth->soc->reg_map->tx_irq_mask);
+	mtk_w32(eth, val & ~mask, eth->soc->reg_map->tx_irq_mask);
 	spin_unlock_irqrestore(&eth->tx_irq_lock, flags);
 }
 
@@ -611,8 +664,8 @@ static inline void mtk_tx_irq_enable(struct mtk_eth *eth, u32 mask)
 	u32 val;
 
 	spin_lock_irqsave(&eth->tx_irq_lock, flags);
-	val = mtk_r32(eth, eth->tx_int_mask_reg);
-	mtk_w32(eth, val | mask, eth->tx_int_mask_reg);
+	val = mtk_r32(eth, eth->soc->reg_map->tx_irq_mask);
+	mtk_w32(eth, val | mask, eth->soc->reg_map->tx_irq_mask);
 	spin_unlock_irqrestore(&eth->tx_irq_lock, flags);
 }
 
@@ -622,8 +675,8 @@ static inline void mtk_rx_irq_disable(struct mtk_eth *eth, u32 mask)
 	u32 val;
 
 	spin_lock_irqsave(&eth->rx_irq_lock, flags);
-	val = mtk_r32(eth, MTK_PDMA_INT_MASK);
-	mtk_w32(eth, val & ~mask, MTK_PDMA_INT_MASK);
+	val = mtk_r32(eth, eth->soc->reg_map->pdma.irq_mask);
+	mtk_w32(eth, val & ~mask, eth->soc->reg_map->pdma.irq_mask);
 	spin_unlock_irqrestore(&eth->rx_irq_lock, flags);
 }
 
@@ -633,8 +686,8 @@ static inline void mtk_rx_irq_enable(struct mtk_eth *eth, u32 mask)
 	u32 val;
 
 	spin_lock_irqsave(&eth->rx_irq_lock, flags);
-	val = mtk_r32(eth, MTK_PDMA_INT_MASK);
-	mtk_w32(eth, val | mask, MTK_PDMA_INT_MASK);
+	val = mtk_r32(eth, eth->soc->reg_map->pdma.irq_mask);
+	mtk_w32(eth, val | mask, eth->soc->reg_map->pdma.irq_mask);
 	spin_unlock_irqrestore(&eth->rx_irq_lock, flags);
 }
 
@@ -685,39 +738,39 @@ void mtk_stats_update_mac(struct mtk_mac *mac)
 		hw_stats->rx_checksum_errors +=
 			mtk_r32(mac->hw, MT7628_SDM_CS_ERR);
 	} else {
+		const struct mtk_reg_map *reg_map = eth->soc->reg_map;
 		unsigned int offs = hw_stats->reg_offset;
 		u64 stats;
 
-		hw_stats->rx_bytes += mtk_r32(mac->hw,
-					      MTK_GDM1_RX_GBCNT_L + offs);
-		stats = mtk_r32(mac->hw, MTK_GDM1_RX_GBCNT_H + offs);
+		hw_stats->rx_bytes += mtk_r32(mac->hw, reg_map->gdm1_cnt + offs);
+		stats = mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x4 + offs);
 		if (stats)
 			hw_stats->rx_bytes += (stats << 32);
 		hw_stats->rx_packets +=
-			mtk_r32(mac->hw, MTK_GDM1_RX_GPCNT + offs);
+			mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x8 + offs);
 		hw_stats->rx_overflow +=
-			mtk_r32(mac->hw, MTK_GDM1_RX_OERCNT + offs);
+			mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x10 + offs);
 		hw_stats->rx_fcs_errors +=
-			mtk_r32(mac->hw, MTK_GDM1_RX_FERCNT + offs);
+			mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x14 + offs);
 		hw_stats->rx_short_errors +=
-			mtk_r32(mac->hw, MTK_GDM1_RX_SERCNT + offs);
+			mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x18 + offs);
 		hw_stats->rx_long_errors +=
-			mtk_r32(mac->hw, MTK_GDM1_RX_LENCNT + offs);
+			mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x1c + offs);
 		hw_stats->rx_checksum_errors +=
-			mtk_r32(mac->hw, MTK_GDM1_RX_CERCNT + offs);
+			mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x20 + offs);
 		hw_stats->rx_flow_control_packets +=
-			mtk_r32(mac->hw, MTK_GDM1_RX_FCCNT + offs);
+			mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x24 + offs);
 		hw_stats->tx_skip +=
-			mtk_r32(mac->hw, MTK_GDM1_TX_SKIPCNT + offs);
+			mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x28 + offs);
 		hw_stats->tx_collisions +=
-			mtk_r32(mac->hw, MTK_GDM1_TX_COLCNT + offs);
+			mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x2c + offs);
 		hw_stats->tx_bytes +=
-			mtk_r32(mac->hw, MTK_GDM1_TX_GBCNT_L + offs);
-		stats =  mtk_r32(mac->hw, MTK_GDM1_TX_GBCNT_H + offs);
+			mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x30 + offs);
+		stats =  mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x34 + offs);
 		if (stats)
 			hw_stats->tx_bytes += (stats << 32);
 		hw_stats->tx_packets +=
-			mtk_r32(mac->hw, MTK_GDM1_TX_GPCNT + offs);
+			mtk_r32(mac->hw, reg_map->gdm1_cnt + 0x38 + offs);
 	}
 
 	u64_stats_update_end(&hw_stats->syncp);
@@ -846,10 +899,10 @@ static int mtk_init_fq_dma(struct mtk_eth *eth)
 		txd->txd4 = 0;
 	}
 
-	mtk_w32(eth, eth->phy_scratch_ring, MTK_QDMA_FQ_HEAD);
-	mtk_w32(eth, phy_ring_tail, MTK_QDMA_FQ_TAIL);
-	mtk_w32(eth, (cnt << 16) | cnt, MTK_QDMA_FQ_CNT);
-	mtk_w32(eth, MTK_QDMA_PAGE_SIZE << 16, MTK_QDMA_FQ_BLEN);
+	mtk_w32(eth, eth->phy_scratch_ring, soc->reg_map->qdma.fq_head);
+	mtk_w32(eth, phy_ring_tail, soc->reg_map->qdma.fq_tail);
+	mtk_w32(eth, (cnt << 16) | cnt, soc->reg_map->qdma.fq_count);
+	mtk_w32(eth, MTK_QDMA_PAGE_SIZE << 16, soc->reg_map->qdma.fq_blen);
 
 	return 0;
 }
@@ -1093,7 +1146,7 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 	if (MTK_HAS_CAPS(soc->caps, MTK_QDMA)) {
 		if (netif_xmit_stopped(netdev_get_tx_queue(dev, 0)) ||
 		    !netdev_xmit_more())
-			mtk_w32(eth, txd->txd2, MTK_QTX_CTX_PTR);
+			mtk_w32(eth, txd->txd2, soc->reg_map->qdma.ctx_ptr);
 	} else {
 		int next_idx;
 
@@ -1407,6 +1460,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 static int mtk_poll_tx_qdma(struct mtk_eth *eth, int budget,
 			    unsigned int *done, unsigned int *bytes)
 {
+	const struct mtk_reg_map *reg_map = eth->soc->reg_map;
 	struct mtk_tx_ring *ring = &eth->tx_ring;
 	struct mtk_tx_dma *desc;
 	struct sk_buff *skb;
@@ -1414,7 +1468,7 @@ static int mtk_poll_tx_qdma(struct mtk_eth *eth, int budget,
 	u32 cpu, dma;
 
 	cpu = ring->last_free_ptr;
-	dma = mtk_r32(eth, MTK_QTX_DRX_PTR);
+	dma = mtk_r32(eth, reg_map->qdma.drx_ptr);
 
 	desc = mtk_qdma_phys_to_virt(ring, cpu);
 
@@ -1449,7 +1503,7 @@ static int mtk_poll_tx_qdma(struct mtk_eth *eth, int budget,
 	}
 
 	ring->last_free_ptr = cpu;
-	mtk_w32(eth, cpu, MTK_QTX_CRX_PTR);
+	mtk_w32(eth, cpu, reg_map->qdma.crx_ptr);
 
 	return budget;
 }
@@ -1542,24 +1596,25 @@ static void mtk_handle_status_irq(struct mtk_eth *eth)
 static int mtk_napi_tx(struct napi_struct *napi, int budget)
 {
 	struct mtk_eth *eth = container_of(napi, struct mtk_eth, tx_napi);
+	const struct mtk_reg_map *reg_map = eth->soc->reg_map;
 	int tx_done = 0;
 
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
 		mtk_handle_status_irq(eth);
-	mtk_w32(eth, MTK_TX_DONE_INT, eth->tx_int_status_reg);
+	mtk_w32(eth, MTK_TX_DONE_INT, reg_map->tx_irq_status);
 	tx_done = mtk_poll_tx(eth, budget);
 
 	if (unlikely(netif_msg_intr(eth))) {
 		dev_info(eth->dev,
 			 "done tx %d, intr 0x%08x/0x%x\n", tx_done,
-			 mtk_r32(eth, eth->tx_int_status_reg),
-			 mtk_r32(eth, eth->tx_int_mask_reg));
+			 mtk_r32(eth, reg_map->tx_irq_status),
+			 mtk_r32(eth, reg_map->tx_irq_mask));
 	}
 
 	if (tx_done == budget)
 		return budget;
 
-	if (mtk_r32(eth, eth->tx_int_status_reg) & MTK_TX_DONE_INT)
+	if (mtk_r32(eth, reg_map->tx_irq_status) & MTK_TX_DONE_INT)
 		return budget;
 
 	if (napi_complete_done(napi, tx_done))
@@ -1571,6 +1626,7 @@ static int mtk_napi_tx(struct napi_struct *napi, int budget)
 static int mtk_napi_rx(struct napi_struct *napi, int budget)
 {
 	struct mtk_eth *eth = container_of(napi, struct mtk_eth, rx_napi);
+	const struct mtk_reg_map *reg_map = eth->soc->reg_map;
 	int rx_done_total = 0;
 
 	mtk_handle_status_irq(eth);
@@ -1578,21 +1634,21 @@ static int mtk_napi_rx(struct napi_struct *napi, int budget)
 	do {
 		int rx_done;
 
-		mtk_w32(eth, MTK_RX_DONE_INT, MTK_PDMA_INT_STATUS);
+		mtk_w32(eth, MTK_RX_DONE_INT, reg_map->pdma.irq_status);
 		rx_done = mtk_poll_rx(napi, budget - rx_done_total, eth);
 		rx_done_total += rx_done;
 
 		if (unlikely(netif_msg_intr(eth))) {
 			dev_info(eth->dev,
 				 "done rx %d, intr 0x%08x/0x%x\n", rx_done,
-				 mtk_r32(eth, MTK_PDMA_INT_STATUS),
-				 mtk_r32(eth, MTK_PDMA_INT_MASK));
+				 mtk_r32(eth, reg_map->pdma.irq_status),
+				 mtk_r32(eth, reg_map->pdma.irq_mask));
 		}
 
 		if (rx_done_total == budget)
 			return budget;
 
-	} while (mtk_r32(eth, MTK_PDMA_INT_STATUS) & MTK_RX_DONE_INT);
+	} while (mtk_r32(eth, reg_map->pdma.irq_status) & MTK_RX_DONE_INT);
 
 	if (napi_complete_done(napi, rx_done_total))
 		mtk_rx_irq_enable(eth, MTK_RX_DONE_INT);
@@ -1655,20 +1711,20 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 	 */
 	wmb();
 
-	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
-		mtk_w32(eth, ring->phys, MTK_QTX_CTX_PTR);
-		mtk_w32(eth, ring->phys, MTK_QTX_DTX_PTR);
+	if (MTK_HAS_CAPS(soc->caps, MTK_QDMA)) {
+		mtk_w32(eth, ring->phys, soc->reg_map->qdma.ctx_ptr);
+		mtk_w32(eth, ring->phys, soc->reg_map->qdma.dtx_ptr);
 		mtk_w32(eth,
 			ring->phys + ((MTK_DMA_SIZE - 1) * sz),
-			MTK_QTX_CRX_PTR);
-		mtk_w32(eth, ring->last_free_ptr, MTK_QTX_DRX_PTR);
+			soc->reg_map->qdma.crx_ptr);
+		mtk_w32(eth, ring->last_free_ptr, soc->reg_map->qdma.drx_ptr);
 		mtk_w32(eth, (QDMA_RES_THRES << 8) | QDMA_RES_THRES,
-			MTK_QTX_CFG(0));
+			soc->reg_map->qdma.qtx_cfg);
 	} else {
 		mtk_w32(eth, ring->phys_pdma, MT7628_TX_BASE_PTR0);
 		mtk_w32(eth, MTK_DMA_SIZE, MT7628_TX_MAX_CNT0);
 		mtk_w32(eth, 0, MT7628_TX_CTX_IDX0);
-		mtk_w32(eth, MT7628_PST_DTX_IDX0, MTK_PDMA_RST_IDX);
+		mtk_w32(eth, MT7628_PST_DTX_IDX0, soc->reg_map->pdma.rst_idx);
 	}
 
 	return 0;
@@ -1707,6 +1763,7 @@ static void mtk_tx_clean(struct mtk_eth *eth)
 
 static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 {
+	const struct mtk_reg_map *reg_map = eth->soc->reg_map;
 	struct mtk_rx_ring *ring;
 	int rx_data_len, rx_dma_size;
 	int i;
@@ -1772,16 +1829,18 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 	ring->dma_size = rx_dma_size;
 	ring->calc_idx_update = false;
 	ring->calc_idx = rx_dma_size - 1;
-	ring->crx_idx_reg = MTK_PRX_CRX_IDX_CFG(ring_no);
+	ring->crx_idx_reg = reg_map->pdma.pcrx_ptr + ring_no * MTK_QRX_OFFSET;
 	/* make sure that all changes to the dma ring are flushed before we
 	 * continue
 	 */
 	wmb();
 
-	mtk_w32(eth, ring->phys, MTK_PRX_BASE_PTR_CFG(ring_no) + offset);
-	mtk_w32(eth, rx_dma_size, MTK_PRX_MAX_CNT_CFG(ring_no) + offset);
+	mtk_w32(eth, ring->phys,
+		reg_map->pdma.rx_ptr + ring_no * MTK_QRX_OFFSET + offset);
+	mtk_w32(eth, rx_dma_size,
+		reg_map->pdma.rx_cnt_cfg + ring_no * MTK_QRX_OFFSET + offset);
 	mtk_w32(eth, ring->calc_idx, ring->crx_idx_reg + offset);
-	mtk_w32(eth, MTK_PST_DRX_IDX_CFG(ring_no), MTK_PDMA_RST_IDX + offset);
+	mtk_w32(eth, MTK_PST_DRX_IDX_CFG(ring_no), reg_map->pdma.rst_idx + offset);
 
 	return 0;
 }
@@ -2087,9 +2146,9 @@ static int mtk_dma_busy_wait(struct mtk_eth *eth)
 	u32 val;
 
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
-		reg = MTK_QDMA_GLO_CFG;
+		reg = eth->soc->reg_map->qdma.glo_cfg;
 	else
-		reg = MTK_PDMA_GLO_CFG;
+		reg = eth->soc->reg_map->pdma.glo_cfg;
 
 	ret = readx_poll_timeout_atomic(__raw_readl, eth->base + reg, val,
 					!(val & (MTK_RX_DMA_BUSY | MTK_TX_DMA_BUSY)),
@@ -2147,8 +2206,8 @@ static int mtk_dma_init(struct mtk_eth *eth)
 		 * automatically
 		 */
 		mtk_w32(eth, FC_THRES_DROP_MODE | FC_THRES_DROP_EN |
-			FC_THRES_MIN, MTK_QDMA_FC_THRES);
-		mtk_w32(eth, 0x0, MTK_QDMA_HRED2);
+			FC_THRES_MIN, eth->soc->reg_map->qdma.fc_th);
+		mtk_w32(eth, 0x0, eth->soc->reg_map->qdma.hred);
 	}
 
 	return 0;
@@ -2222,13 +2281,14 @@ static irqreturn_t mtk_handle_irq_tx(int irq, void *_eth)
 static irqreturn_t mtk_handle_irq(int irq, void *_eth)
 {
 	struct mtk_eth *eth = _eth;
+	const struct mtk_reg_map *reg_map = eth->soc->reg_map;
 
-	if (mtk_r32(eth, MTK_PDMA_INT_MASK) & MTK_RX_DONE_INT) {
-		if (mtk_r32(eth, MTK_PDMA_INT_STATUS) & MTK_RX_DONE_INT)
+	if (mtk_r32(eth, reg_map->pdma.irq_mask) & MTK_RX_DONE_INT) {
+		if (mtk_r32(eth, reg_map->pdma.irq_status) & MTK_RX_DONE_INT)
 			mtk_handle_irq_rx(irq, _eth);
 	}
-	if (mtk_r32(eth, eth->tx_int_mask_reg) & MTK_TX_DONE_INT) {
-		if (mtk_r32(eth, eth->tx_int_status_reg) & MTK_TX_DONE_INT)
+	if (mtk_r32(eth, reg_map->tx_irq_mask) & MTK_TX_DONE_INT) {
+		if (mtk_r32(eth, reg_map->tx_irq_status) & MTK_TX_DONE_INT)
 			mtk_handle_irq_tx(irq, _eth);
 	}
 
@@ -2252,6 +2312,7 @@ static void mtk_poll_controller(struct net_device *dev)
 static int mtk_start_dma(struct mtk_eth *eth)
 {
 	u32 rx_2b_offset = (NET_IP_ALIGN == 2) ? MTK_RX_2B_OFFSET : 0;
+	const struct mtk_reg_map *reg_map = eth->soc->reg_map;
 	int err;
 
 	err = mtk_dma_init(eth);
@@ -2266,16 +2327,15 @@ static int mtk_start_dma(struct mtk_eth *eth)
 			MTK_TX_BT_32DWORDS | MTK_NDP_CO_PRO |
 			MTK_RX_DMA_EN | MTK_RX_2B_OFFSET |
 			MTK_RX_BT_32DWORDS,
-			MTK_QDMA_GLO_CFG);
-
+			reg_map->qdma.glo_cfg);
 		mtk_w32(eth,
 			MTK_RX_DMA_EN | rx_2b_offset |
 			MTK_RX_BT_32DWORDS | MTK_MULTI_EN,
-			MTK_PDMA_GLO_CFG);
+			reg_map->pdma.glo_cfg);
 	} else {
 		mtk_w32(eth, MTK_TX_WB_DDONE | MTK_TX_DMA_EN | MTK_RX_DMA_EN |
 			MTK_MULTI_EN | MTK_PDMA_SIZE_8DWORDS,
-			MTK_PDMA_GLO_CFG);
+			reg_map->pdma.glo_cfg);
 	}
 
 	return 0;
@@ -2398,8 +2458,8 @@ static int mtk_stop(struct net_device *dev)
 	cancel_work_sync(&eth->tx_dim.work);
 
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
-		mtk_stop_dma(eth, MTK_QDMA_GLO_CFG);
-	mtk_stop_dma(eth, MTK_PDMA_GLO_CFG);
+		mtk_stop_dma(eth, eth->soc->reg_map->qdma.glo_cfg);
+	mtk_stop_dma(eth, eth->soc->reg_map->pdma.glo_cfg);
 
 	mtk_dma_free(eth);
 
@@ -2453,6 +2513,7 @@ static void mtk_dim_rx(struct work_struct *work)
 {
 	struct dim *dim = container_of(work, struct dim, work);
 	struct mtk_eth *eth = container_of(dim, struct mtk_eth, rx_dim);
+	const struct mtk_reg_map *reg_map = eth->soc->reg_map;
 	struct dim_cq_moder cur_profile;
 	u32 val, cur;
 
@@ -2460,7 +2521,7 @@ static void mtk_dim_rx(struct work_struct *work)
 						dim->profile_ix);
 	spin_lock_bh(&eth->dim_lock);
 
-	val = mtk_r32(eth, MTK_PDMA_DELAY_INT);
+	val = mtk_r32(eth, reg_map->pdma.delay_irq);
 	val &= MTK_PDMA_DELAY_TX_MASK;
 	val |= MTK_PDMA_DELAY_RX_EN;
 
@@ -2470,9 +2531,9 @@ static void mtk_dim_rx(struct work_struct *work)
 	cur = min_t(u32, cur_profile.pkts, MTK_PDMA_DELAY_PINT_MASK);
 	val |= cur << MTK_PDMA_DELAY_RX_PINT_SHIFT;
 
-	mtk_w32(eth, val, MTK_PDMA_DELAY_INT);
+	mtk_w32(eth, val, reg_map->pdma.delay_irq);
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
-		mtk_w32(eth, val, MTK_QDMA_DELAY_INT);
+		mtk_w32(eth, val, reg_map->qdma.delay_irq);
 
 	spin_unlock_bh(&eth->dim_lock);
 
@@ -2483,6 +2544,7 @@ static void mtk_dim_tx(struct work_struct *work)
 {
 	struct dim *dim = container_of(work, struct dim, work);
 	struct mtk_eth *eth = container_of(dim, struct mtk_eth, tx_dim);
+	const struct mtk_reg_map *reg_map = eth->soc->reg_map;
 	struct dim_cq_moder cur_profile;
 	u32 val, cur;
 
@@ -2490,7 +2552,7 @@ static void mtk_dim_tx(struct work_struct *work)
 						dim->profile_ix);
 	spin_lock_bh(&eth->dim_lock);
 
-	val = mtk_r32(eth, MTK_PDMA_DELAY_INT);
+	val = mtk_r32(eth, reg_map->pdma.delay_irq);
 	val &= MTK_PDMA_DELAY_RX_MASK;
 	val |= MTK_PDMA_DELAY_TX_EN;
 
@@ -2500,9 +2562,9 @@ static void mtk_dim_tx(struct work_struct *work)
 	cur = min_t(u32, cur_profile.pkts, MTK_PDMA_DELAY_PINT_MASK);
 	val |= cur << MTK_PDMA_DELAY_TX_PINT_SHIFT;
 
-	mtk_w32(eth, val, MTK_PDMA_DELAY_INT);
+	mtk_w32(eth, val, reg_map->pdma.delay_irq);
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
-		mtk_w32(eth, val, MTK_QDMA_DELAY_INT);
+		mtk_w32(eth, val, reg_map->qdma.delay_irq);
 
 	spin_unlock_bh(&eth->dim_lock);
 
@@ -2513,6 +2575,7 @@ static int mtk_hw_init(struct mtk_eth *eth)
 {
 	u32 dma_mask = ETHSYS_DMA_AG_MAP_PDMA | ETHSYS_DMA_AG_MAP_QDMA |
 		       ETHSYS_DMA_AG_MAP_PPE;
+	const struct mtk_reg_map *reg_map = eth->soc->reg_map;
 	int i, val, ret;
 
 	if (test_and_set_bit(MTK_HW_INIT, &eth->state))
@@ -2587,10 +2650,10 @@ static int mtk_hw_init(struct mtk_eth *eth)
 	mtk_rx_irq_disable(eth, ~0);
 
 	/* FE int grouping */
-	mtk_w32(eth, MTK_TX_DONE_INT, MTK_PDMA_INT_GRP1);
-	mtk_w32(eth, MTK_RX_DONE_INT, MTK_PDMA_INT_GRP2);
-	mtk_w32(eth, MTK_TX_DONE_INT, MTK_QDMA_INT_GRP1);
-	mtk_w32(eth, MTK_RX_DONE_INT, MTK_QDMA_INT_GRP2);
+	mtk_w32(eth, MTK_TX_DONE_INT, reg_map->pdma.int_grp);
+	mtk_w32(eth, MTK_RX_DONE_INT, reg_map->pdma.int_grp + 4);
+	mtk_w32(eth, MTK_TX_DONE_INT, reg_map->qdma.int_grp);
+	mtk_w32(eth, MTK_RX_DONE_INT, reg_map->qdma.int_grp + 4);
 	mtk_w32(eth, 0x21021000, MTK_FE_INT_GRP);
 
 	return 0;
@@ -3153,14 +3216,6 @@ static int mtk_probe(struct platform_device *pdev)
 	if (IS_ERR(eth->base))
 		return PTR_ERR(eth->base);
 
-	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
-		eth->tx_int_mask_reg = MTK_QDMA_INT_MASK;
-		eth->tx_int_status_reg = MTK_QDMA_INT_STATUS;
-	} else {
-		eth->tx_int_mask_reg = MTK_PDMA_INT_MASK;
-		eth->tx_int_status_reg = MTK_PDMA_INT_STATUS;
-	}
-
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628)) {
 		eth->rx_dma_l4_valid = RX_DMA_L4_VALID_PDMA;
 		eth->ip_align = NET_IP_ALIGN;
@@ -3394,6 +3449,7 @@ static int mtk_remove(struct platform_device *pdev)
 }
 
 static const struct mtk_soc_data mt2701_data = {
+	.reg_map = &mtk_reg_map,
 	.caps = MT7623_CAPS | MTK_HWLRO,
 	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7623_CLKS_BITMAP,
@@ -3405,6 +3461,7 @@ static const struct mtk_soc_data mt2701_data = {
 };
 
 static const struct mtk_soc_data mt7621_data = {
+	.reg_map = &mtk_reg_map,
 	.caps = MT7621_CAPS,
 	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7621_CLKS_BITMAP,
@@ -3417,6 +3474,7 @@ static const struct mtk_soc_data mt7621_data = {
 };
 
 static const struct mtk_soc_data mt7622_data = {
+	.reg_map = &mtk_reg_map,
 	.ana_rgc3 = 0x2028,
 	.caps = MT7622_CAPS | MTK_HWLRO,
 	.hw_features = MTK_HW_FEATURES,
@@ -3430,6 +3488,7 @@ static const struct mtk_soc_data mt7622_data = {
 };
 
 static const struct mtk_soc_data mt7623_data = {
+	.reg_map = &mtk_reg_map,
 	.caps = MT7623_CAPS | MTK_HWLRO,
 	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7623_CLKS_BITMAP,
@@ -3442,6 +3501,7 @@ static const struct mtk_soc_data mt7623_data = {
 };
 
 static const struct mtk_soc_data mt7629_data = {
+	.reg_map = &mtk_reg_map,
 	.ana_rgc3 = 0x128,
 	.caps = MT7629_CAPS | MTK_HWLRO,
 	.hw_features = MTK_HW_FEATURES,
@@ -3454,6 +3514,7 @@ static const struct mtk_soc_data mt7629_data = {
 };
 
 static const struct mtk_soc_data rt5350_data = {
+	.reg_map = &mt7628_reg_map,
 	.caps = MT7628_CAPS,
 	.hw_features = MTK_HW_FEATURES_MT7628,
 	.required_clks = MT7628_CLKS_BITMAP,
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index dcbf4b5c70e0..7e29f042357f 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -48,6 +48,8 @@
 #define MTK_HW_FEATURES_MT7628	(NETIF_F_SG | NETIF_F_RXCSUM)
 #define NEXT_DESP_IDX(X, Y)	(((X) + 1) & ((Y) - 1))
 
+#define MTK_QRX_OFFSET		0x10
+
 #define MTK_MAX_RX_RING_NUM	4
 #define MTK_HW_LRO_DMA_SIZE	8
 
@@ -100,18 +102,6 @@
 /* Unicast Filter MAC Address Register - High */
 #define MTK_GDMA_MAC_ADRH(x)	(0x50C + (x * 0x1000))
 
-/* PDMA RX Base Pointer Register */
-#define MTK_PRX_BASE_PTR0	0x900
-#define MTK_PRX_BASE_PTR_CFG(x)	(MTK_PRX_BASE_PTR0 + (x * 0x10))
-
-/* PDMA RX Maximum Count Register */
-#define MTK_PRX_MAX_CNT0	0x904
-#define MTK_PRX_MAX_CNT_CFG(x)	(MTK_PRX_MAX_CNT0 + (x * 0x10))
-
-/* PDMA RX CPU Pointer Register */
-#define MTK_PRX_CRX_IDX0	0x908
-#define MTK_PRX_CRX_IDX_CFG(x)	(MTK_PRX_CRX_IDX0 + (x * 0x10))
-
 /* PDMA HW LRO Control Registers */
 #define MTK_PDMA_LRO_CTRL_DW0	0x980
 #define MTK_LRO_EN			BIT(0)
@@ -126,18 +116,19 @@
 #define MTK_ADMA_MODE		BIT(15)
 #define MTK_LRO_MIN_RXD_SDL	(MTK_HW_LRO_SDL_REMAIN_ROOM << 16)
 
-/* PDMA Global Configuration Register */
-#define MTK_PDMA_GLO_CFG	0xa04
+#define MTK_RX_DMA_LRO_EN	BIT(8)
 #define MTK_MULTI_EN		BIT(10)
 #define MTK_PDMA_SIZE_8DWORDS	(1 << 4)
 
+/* PDMA Global Configuration Register */
+#define MTK_PDMA_LRO_SDL	0x3000
+#define MTK_RX_CFG_SDL_OFFSET	16
+
 /* PDMA Reset Index Register */
-#define MTK_PDMA_RST_IDX	0xa08
 #define MTK_PST_DRX_IDX0	BIT(16)
 #define MTK_PST_DRX_IDX_CFG(x)	(MTK_PST_DRX_IDX0 << (x))
 
 /* PDMA Delay Interrupt Register */
-#define MTK_PDMA_DELAY_INT		0xa0c
 #define MTK_PDMA_DELAY_RX_MASK		GENMASK(15, 0)
 #define MTK_PDMA_DELAY_RX_EN		BIT(15)
 #define MTK_PDMA_DELAY_RX_PINT_SHIFT	8
@@ -151,19 +142,9 @@
 #define MTK_PDMA_DELAY_PINT_MASK	0x7f
 #define MTK_PDMA_DELAY_PTIME_MASK	0xff
 
-/* PDMA Interrupt Status Register */
-#define MTK_PDMA_INT_STATUS	0xa20
-
-/* PDMA Interrupt Mask Register */
-#define MTK_PDMA_INT_MASK	0xa28
-
 /* PDMA HW LRO Alter Flow Delta Register */
 #define MTK_PDMA_LRO_ALT_SCORE_DELTA	0xa4c
 
-/* PDMA Interrupt grouping registers */
-#define MTK_PDMA_INT_GRP1	0xa50
-#define MTK_PDMA_INT_GRP2	0xa54
-
 /* PDMA HW LRO IP Setting Registers */
 #define MTK_LRO_RX_RING0_DIP_DW0	0xb04
 #define MTK_LRO_DIP_DW0_CFG(x)		(MTK_LRO_RX_RING0_DIP_DW0 + (x * 0x40))
@@ -185,26 +166,9 @@
 #define MTK_RING_MAX_AGG_CNT_H		((MTK_HW_LRO_MAX_AGG_CNT >> 6) & 0x3)
 
 /* QDMA TX Queue Configuration Registers */
-#define MTK_QTX_CFG(x)		(0x1800 + (x * 0x10))
 #define QDMA_RES_THRES		4
 
-/* QDMA TX Queue Scheduler Registers */
-#define MTK_QTX_SCH(x)		(0x1804 + (x * 0x10))
-
-/* QDMA RX Base Pointer Register */
-#define MTK_QRX_BASE_PTR0	0x1900
-
-/* QDMA RX Maximum Count Register */
-#define MTK_QRX_MAX_CNT0	0x1904
-
-/* QDMA RX CPU Pointer Register */
-#define MTK_QRX_CRX_IDX0	0x1908
-
-/* QDMA RX DMA Pointer Register */
-#define MTK_QRX_DRX_IDX0	0x190C
-
 /* QDMA Global Configuration Register */
-#define MTK_QDMA_GLO_CFG	0x1A04
 #define MTK_RX_2B_OFFSET	BIT(31)
 #define MTK_RX_BT_32DWORDS	(3 << 11)
 #define MTK_NDP_CO_PRO		BIT(10)
@@ -216,20 +180,12 @@
 #define MTK_TX_DMA_EN		BIT(0)
 #define MTK_DMA_BUSY_TIMEOUT_US	1000000
 
-/* QDMA Reset Index Register */
-#define MTK_QDMA_RST_IDX	0x1A08
-
-/* QDMA Delay Interrupt Register */
-#define MTK_QDMA_DELAY_INT	0x1A0C
-
 /* QDMA Flow Control Register */
-#define MTK_QDMA_FC_THRES	0x1A10
 #define FC_THRES_DROP_MODE	BIT(20)
 #define FC_THRES_DROP_EN	(7 << 16)
 #define FC_THRES_MIN		0x4444
 
 /* QDMA Interrupt Status Register */
-#define MTK_QDMA_INT_STATUS	0x1A18
 #define MTK_RX_DONE_DLY		BIT(30)
 #define MTK_TX_DONE_DLY		BIT(28)
 #define MTK_RX_DONE_INT3	BIT(19)
@@ -244,55 +200,8 @@
 #define MTK_TX_DONE_INT		MTK_TX_DONE_DLY
 
 /* QDMA Interrupt grouping registers */
-#define MTK_QDMA_INT_GRP1	0x1a20
-#define MTK_QDMA_INT_GRP2	0x1a24
 #define MTK_RLS_DONE_INT	BIT(0)
 
-/* QDMA Interrupt Status Register */
-#define MTK_QDMA_INT_MASK	0x1A1C
-
-/* QDMA Interrupt Mask Register */
-#define MTK_QDMA_HRED2		0x1A44
-
-/* QDMA TX Forward CPU Pointer Register */
-#define MTK_QTX_CTX_PTR		0x1B00
-
-/* QDMA TX Forward DMA Pointer Register */
-#define MTK_QTX_DTX_PTR		0x1B04
-
-/* QDMA TX Release CPU Pointer Register */
-#define MTK_QTX_CRX_PTR		0x1B10
-
-/* QDMA TX Release DMA Pointer Register */
-#define MTK_QTX_DRX_PTR		0x1B14
-
-/* QDMA FQ Head Pointer Register */
-#define MTK_QDMA_FQ_HEAD	0x1B20
-
-/* QDMA FQ Head Pointer Register */
-#define MTK_QDMA_FQ_TAIL	0x1B24
-
-/* QDMA FQ Free Page Counter Register */
-#define MTK_QDMA_FQ_CNT		0x1B28
-
-/* QDMA FQ Free Page Buffer Length Register */
-#define MTK_QDMA_FQ_BLEN	0x1B2C
-
-/* GMA1 counter / statics register */
-#define MTK_GDM1_RX_GBCNT_L	0x2400
-#define MTK_GDM1_RX_GBCNT_H	0x2404
-#define MTK_GDM1_RX_GPCNT	0x2408
-#define MTK_GDM1_RX_OERCNT	0x2410
-#define MTK_GDM1_RX_FERCNT	0x2414
-#define MTK_GDM1_RX_SERCNT	0x2418
-#define MTK_GDM1_RX_LENCNT	0x241c
-#define MTK_GDM1_RX_CERCNT	0x2420
-#define MTK_GDM1_RX_FCCNT	0x2424
-#define MTK_GDM1_TX_SKIPCNT	0x2428
-#define MTK_GDM1_TX_COLCNT	0x242c
-#define MTK_GDM1_TX_GBCNT_L	0x2430
-#define MTK_GDM1_TX_GBCNT_H	0x2434
-#define MTK_GDM1_TX_GPCNT	0x2438
 #define MTK_STAT_OFFSET		0x40
 
 #define MTK_WDMA0_BASE		0x2800
@@ -857,8 +766,46 @@ struct mtk_tx_dma_desc_info {
 	u8		last:1;
 };
 
+struct mtk_reg_map {
+	u32	tx_irq_mask;
+	u32	tx_irq_status;
+	struct {
+		u32	rx_ptr;		/* rx base pointer */
+		u32	rx_cnt_cfg;	/* rx max count configuration */
+		u32	pcrx_ptr;	/* rx cpu pointer */
+		u32	glo_cfg;	/* global configuration */
+		u32	rst_idx;	/* reset index */
+		u32	delay_irq;	/* delay interrupt */
+		u32	irq_status;	/* interrupt status */
+		u32	irq_mask;	/* interrupt mask */
+		u32	int_grp;
+	} pdma;
+	struct {
+		u32	qtx_cfg;	/* tx queue configuration */
+		u32	rx_ptr;		/* rx base pointer */
+		u32	rx_cnt_cfg;	/* rx max count configuration */
+		u32	qcrx_ptr;	/* rx cpu pointer */
+		u32	glo_cfg;	/* global configuration */
+		u32	rst_idx;	/* reset index */
+		u32	delay_irq;	/* delay interrupt */
+		u32	fc_th;		/* flow control */
+		u32	int_grp;
+		u32	hred;		/* interrupt mask */
+		u32	ctx_ptr;	/* tx acquire cpu pointer */
+		u32	dtx_ptr;	/* tx acquire dma pointer */
+		u32	crx_ptr;	/* tx release cpu pointer */
+		u32	drx_ptr;	/* tx release dma pointer */
+		u32	fq_head;	/* fq head pointer */
+		u32	fq_tail;	/* fq tail pointer */
+		u32	fq_count;	/* fq free page count */
+		u32	fq_blen;	/* fq free page buffer length */
+	} qdma;
+	u32	gdm1_cnt;
+};
+
 /* struct mtk_eth_data -	This is the structure holding all differences
  *				among various plaforms
+ * @reg_map			Soc register map.
  * @ana_rgc3:                   The offset for register ANA_RGC3 related to
  *				sgmiisys syscon
  * @caps			Flags shown the extra capability for the SoC
@@ -871,6 +818,7 @@ struct mtk_tx_dma_desc_info {
  * @rxd_size			Rx DMA descriptor size.
  */
 struct mtk_soc_data {
+	const struct mtk_reg_map *reg_map;
 	u32             ana_rgc3;
 	u32		caps;
 	u32		required_clks;
@@ -999,8 +947,6 @@ struct mtk_eth {
 	u32				tx_bytes;
 	struct dim			tx_dim;
 
-	u32				tx_int_mask_reg;
-	u32				tx_int_status_reg;
 	u32				rx_dma_l4_valid;
 	int				ip_align;
 
-- 
2.35.3

