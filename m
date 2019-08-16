Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE4E2902DE
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbfHPNXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 09:23:40 -0400
Received: from mx2.mailbox.org ([80.241.60.215]:11266 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727218AbfHPNXj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 09:23:39 -0400
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2.mailbox.org (Postfix) with ESMTPS id A1A14A1068;
        Fri, 16 Aug 2019 15:23:34 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id A-V-whBbFz6w; Fri, 16 Aug 2019 15:23:30 +0200 (CEST)
From:   Stefan Roese <sr@denx.de>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org
Cc:     =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>
Subject: [PATCH net-next 4/4 v3] net: ethernet: mediatek: Add MT7628/88 SoC support
Date:   Fri, 16 Aug 2019 15:23:25 +0200
Message-Id: <20190816132325.28426-4-sr@denx.de>
In-Reply-To: <20190816132325.28426-1-sr@denx.de>
References: <20190816132325.28426-1-sr@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for the MediaTek MT7628/88 SoCs to the common
MediaTek ethernet driver. Some minor changes are needed for this and
a bigger change, as the MT7628 does not support QDMA (only PDMA).

Signed-off-by: Stefan Roese <sr@denx.de>
Cc: René van Dorst <opensource@vdorst.com>
Cc: Daniel Golle <daniel@makrotopia.org>
Cc: Sean Wang <sean.wang@mediatek.com>
Cc: John Crispin <john@phrozen.org>
---
v3:
- Corrected pointer arthmetic - use proper (void *) cast (David)

v2:
- Rebased on net-next (David)
- Used "ralink,rt5350-eth" compatible (Daniel)
- Fixed capability bit usage (Rene)
- Extracted DT bindings description to separate patch
- Introduced MTK_QDMA capability, which is used on all
  currently supported SoCs. Only the newly introcuded MT7628
  uses PDMA and does not have this capability bit set
- Added tx_int_mask_reg/tx_int_status_reg variables to better
  abstract the QDMA vs PDMA usage
  
 drivers/net/ethernet/mediatek/Kconfig        |   2 +-
 drivers/net/ethernet/mediatek/mtk_eth_path.c |   4 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c  | 480 ++++++++++++++-----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h  |  51 +-
 4 files changed, 425 insertions(+), 112 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/Kconfig b/drivers/net/ethernet/mediatek/Kconfig
index 1f7fff81f24d..b76cf2e1c9dc 100644
--- a/drivers/net/ethernet/mediatek/Kconfig
+++ b/drivers/net/ethernet/mediatek/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config NET_VENDOR_MEDIATEK
 	bool "MediaTek ethernet driver"
-	depends on ARCH_MEDIATEK || SOC_MT7621
+	depends on ARCH_MEDIATEK || SOC_MT7621 || SOC_MT7620
 	---help---
 	  If you have a Mediatek SoC with ethernet, say Y.
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_path.c b/drivers/net/ethernet/mediatek/mtk_eth_path.c
index 7f05880cf9ef..28960e4c4e43 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_path.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_path.c
@@ -315,6 +315,10 @@ int mtk_setup_hw_path(struct mtk_eth *eth, int mac_id, int phymode)
 {
 	int err;
 
+	/* No mux'ing for MT7628/88 */
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
+		return 0;
+
 	switch (phymode) {
 	case PHY_INTERFACE_MODE_TRGMII:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index d9978174b96a..8ddbb8dcf032 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -323,11 +323,14 @@ static int mtk_phy_connect(struct net_device *dev)
 		goto err_phy;
 	}
 
-	/* put the gmac into the right mode */
-	regmap_read(eth->ethsys, ETHSYS_SYSCFG0, &val);
-	val &= ~SYSCFG0_GE_MODE(SYSCFG0_GE_MASK, mac->id);
-	val |= SYSCFG0_GE_MODE(mac->ge_mode, mac->id);
-	regmap_write(eth->ethsys, ETHSYS_SYSCFG0, val);
+	/* No MT7628/88 support for now */
+	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628)) {
+		/* put the gmac into the right mode */
+		regmap_read(eth->ethsys, ETHSYS_SYSCFG0, &val);
+		val &= ~SYSCFG0_GE_MODE(SYSCFG0_GE_MASK, mac->id);
+		val |= SYSCFG0_GE_MODE(mac->ge_mode, mac->id);
+		regmap_write(eth->ethsys, ETHSYS_SYSCFG0, val);
+	}
 
 	/* couple phydev to net_device */
 	if (mtk_phy_connect_node(eth, mac, np))
@@ -395,8 +398,8 @@ static inline void mtk_tx_irq_disable(struct mtk_eth *eth, u32 mask)
 	u32 val;
 
 	spin_lock_irqsave(&eth->tx_irq_lock, flags);
-	val = mtk_r32(eth, MTK_QDMA_INT_MASK);
-	mtk_w32(eth, val & ~mask, MTK_QDMA_INT_MASK);
+	val = mtk_r32(eth, eth->tx_int_mask_reg);
+	mtk_w32(eth, val & ~mask, eth->tx_int_mask_reg);
 	spin_unlock_irqrestore(&eth->tx_irq_lock, flags);
 }
 
@@ -406,8 +409,8 @@ static inline void mtk_tx_irq_enable(struct mtk_eth *eth, u32 mask)
 	u32 val;
 
 	spin_lock_irqsave(&eth->tx_irq_lock, flags);
-	val = mtk_r32(eth, MTK_QDMA_INT_MASK);
-	mtk_w32(eth, val | mask, MTK_QDMA_INT_MASK);
+	val = mtk_r32(eth, eth->tx_int_mask_reg);
+	mtk_w32(eth, val | mask, eth->tx_int_mask_reg);
 	spin_unlock_irqrestore(&eth->tx_irq_lock, flags);
 }
 
@@ -437,6 +440,7 @@ static int mtk_set_mac_address(struct net_device *dev, void *p)
 {
 	int ret = eth_mac_addr(dev, p);
 	struct mtk_mac *mac = netdev_priv(dev);
+	struct mtk_eth *eth = mac->hw;
 	const char *macaddr = dev->dev_addr;
 
 	if (ret)
@@ -446,11 +450,19 @@ static int mtk_set_mac_address(struct net_device *dev, void *p)
 		return -EBUSY;
 
 	spin_lock_bh(&mac->hw->page_lock);
-	mtk_w32(mac->hw, (macaddr[0] << 8) | macaddr[1],
-		MTK_GDMA_MAC_ADRH(mac->id));
-	mtk_w32(mac->hw, (macaddr[2] << 24) | (macaddr[3] << 16) |
-		(macaddr[4] << 8) | macaddr[5],
-		MTK_GDMA_MAC_ADRL(mac->id));
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628)) {
+		mtk_w32(mac->hw, (macaddr[0] << 8) | macaddr[1],
+			MT7628_SDM_MAC_ADRH);
+		mtk_w32(mac->hw, (macaddr[2] << 24) | (macaddr[3] << 16) |
+			(macaddr[4] << 8) | macaddr[5],
+			MT7628_SDM_MAC_ADRL);
+	} else {
+		mtk_w32(mac->hw, (macaddr[0] << 8) | macaddr[1],
+			MTK_GDMA_MAC_ADRH(mac->id));
+		mtk_w32(mac->hw, (macaddr[2] << 24) | (macaddr[3] << 16) |
+			(macaddr[4] << 8) | macaddr[5],
+			MTK_GDMA_MAC_ADRL(mac->id));
+	}
 	spin_unlock_bh(&mac->hw->page_lock);
 
 	return 0;
@@ -626,19 +638,47 @@ static inline struct mtk_tx_buf *mtk_desc_to_tx_buf(struct mtk_tx_ring *ring,
 	return &ring->buf[idx];
 }
 
+static struct mtk_tx_dma *qdma_to_pdma(struct mtk_tx_ring *ring,
+				       struct mtk_tx_dma *dma)
+{
+	return ring->dma_pdma - ring->dma + dma;
+}
+
+static int txd_to_idx(struct mtk_tx_ring *ring, struct mtk_tx_dma *dma)
+{
+	return ((void *)dma - (void *)ring->dma) / sizeof(*dma);
+}
+
 static void mtk_tx_unmap(struct mtk_eth *eth, struct mtk_tx_buf *tx_buf)
 {
-	if (tx_buf->flags & MTK_TX_FLAGS_SINGLE0) {
-		dma_unmap_single(eth->dev,
-				 dma_unmap_addr(tx_buf, dma_addr0),
-				 dma_unmap_len(tx_buf, dma_len0),
-				 DMA_TO_DEVICE);
-	} else if (tx_buf->flags & MTK_TX_FLAGS_PAGE0) {
-		dma_unmap_page(eth->dev,
-			       dma_unmap_addr(tx_buf, dma_addr0),
-			       dma_unmap_len(tx_buf, dma_len0),
-			       DMA_TO_DEVICE);
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
+		if (tx_buf->flags & MTK_TX_FLAGS_SINGLE0) {
+			dma_unmap_single(eth->dev,
+					 dma_unmap_addr(tx_buf, dma_addr0),
+					 dma_unmap_len(tx_buf, dma_len0),
+					 DMA_TO_DEVICE);
+		} else if (tx_buf->flags & MTK_TX_FLAGS_PAGE0) {
+			dma_unmap_page(eth->dev,
+				       dma_unmap_addr(tx_buf, dma_addr0),
+				       dma_unmap_len(tx_buf, dma_len0),
+				       DMA_TO_DEVICE);
+		}
+	} else {
+		if (dma_unmap_len(tx_buf, dma_len0)) {
+			dma_unmap_page(eth->dev,
+				       dma_unmap_addr(tx_buf, dma_addr0),
+				       dma_unmap_len(tx_buf, dma_len0),
+				       DMA_TO_DEVICE);
+		}
+
+		if (dma_unmap_len(tx_buf, dma_len1)) {
+			dma_unmap_page(eth->dev,
+				       dma_unmap_addr(tx_buf, dma_addr1),
+				       dma_unmap_len(tx_buf, dma_len1),
+				       DMA_TO_DEVICE);
+		}
 	}
+
 	tx_buf->flags = 0;
 	if (tx_buf->skb &&
 	    (tx_buf->skb != (struct sk_buff *)MTK_DMA_DUMMY_DESC))
@@ -646,19 +686,45 @@ static void mtk_tx_unmap(struct mtk_eth *eth, struct mtk_tx_buf *tx_buf)
 	tx_buf->skb = NULL;
 }
 
+static void setup_tx_buf(struct mtk_eth *eth, struct mtk_tx_buf *tx_buf,
+			 struct mtk_tx_dma *txd, dma_addr_t mapped_addr,
+			 size_t size, int idx)
+{
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
+		dma_unmap_addr_set(tx_buf, dma_addr0, mapped_addr);
+		dma_unmap_len_set(tx_buf, dma_len0, size);
+	} else {
+		if (idx & 1) {
+			txd->txd3 = mapped_addr;
+			txd->txd2 |= TX_DMA_PLEN1(size);
+			dma_unmap_addr_set(tx_buf, dma_addr1, mapped_addr);
+			dma_unmap_len_set(tx_buf, dma_len1, size);
+		} else {
+			tx_buf->skb = (struct sk_buff *)MTK_DMA_DUMMY_DESC;
+			txd->txd1 = mapped_addr;
+			txd->txd2 = TX_DMA_PLEN0(size);
+			dma_unmap_addr_set(tx_buf, dma_addr0, mapped_addr);
+			dma_unmap_len_set(tx_buf, dma_len0, size);
+		}
+	}
+}
+
 static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 		      int tx_num, struct mtk_tx_ring *ring, bool gso)
 {
 	struct mtk_mac *mac = netdev_priv(dev);
 	struct mtk_eth *eth = mac->hw;
 	struct mtk_tx_dma *itxd, *txd;
+	struct mtk_tx_dma *itxd_pdma, *txd_pdma;
 	struct mtk_tx_buf *itx_buf, *tx_buf;
 	dma_addr_t mapped_addr;
 	unsigned int nr_frags;
 	int i, n_desc = 1;
 	u32 txd4 = 0, fport;
+	int k = 0;
 
 	itxd = ring->next_free;
+	itxd_pdma = qdma_to_pdma(ring, itxd);
 	if (itxd == ring->last_free)
 		return -ENOMEM;
 
@@ -689,12 +755,14 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 	itx_buf->flags |= MTK_TX_FLAGS_SINGLE0;
 	itx_buf->flags |= (!mac->id) ? MTK_TX_FLAGS_FPORT0 :
 			  MTK_TX_FLAGS_FPORT1;
-	dma_unmap_addr_set(itx_buf, dma_addr0, mapped_addr);
-	dma_unmap_len_set(itx_buf, dma_len0, skb_headlen(skb));
+	setup_tx_buf(eth, itx_buf, itxd_pdma, mapped_addr, skb_headlen(skb),
+		     k++);
 
 	/* TX SG offload */
 	txd = itxd;
+	txd_pdma = qdma_to_pdma(ring, txd);
 	nr_frags = skb_shinfo(skb)->nr_frags;
+
 	for (i = 0; i < nr_frags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		unsigned int offset = 0;
@@ -703,12 +771,21 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 		while (frag_size) {
 			bool last_frag = false;
 			unsigned int frag_map_size;
+			bool new_desc = true;
+
+			if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA) ||
+			    (i & 0x1)) {
+				txd = mtk_qdma_phys_to_virt(ring, txd->txd2);
+				txd_pdma = qdma_to_pdma(ring, txd);
+				if (txd == ring->last_free)
+					goto err_dma;
+
+				n_desc++;
+			} else {
+				new_desc = false;
+			}
 
-			txd = mtk_qdma_phys_to_virt(ring, txd->txd2);
-			if (txd == ring->last_free)
-				goto err_dma;
 
-			n_desc++;
 			frag_map_size = min(frag_size, MTK_TX_DMA_BUF_LEN);
 			mapped_addr = skb_frag_dma_map(eth->dev, frag, offset,
 						       frag_map_size,
@@ -727,14 +804,16 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 			WRITE_ONCE(txd->txd4, fport);
 
 			tx_buf = mtk_desc_to_tx_buf(ring, txd);
-			memset(tx_buf, 0, sizeof(*tx_buf));
+			if (new_desc)
+				memset(tx_buf, 0, sizeof(*tx_buf));
 			tx_buf->skb = (struct sk_buff *)MTK_DMA_DUMMY_DESC;
 			tx_buf->flags |= MTK_TX_FLAGS_PAGE0;
 			tx_buf->flags |= (!mac->id) ? MTK_TX_FLAGS_FPORT0 :
 					 MTK_TX_FLAGS_FPORT1;
 
-			dma_unmap_addr_set(tx_buf, dma_addr0, mapped_addr);
-			dma_unmap_len_set(tx_buf, dma_len0, frag_map_size);
+			setup_tx_buf(eth, tx_buf, txd_pdma, mapped_addr,
+				     frag_map_size, k++);
+
 			frag_size -= frag_map_size;
 			offset += frag_map_size;
 		}
@@ -746,6 +825,12 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 	WRITE_ONCE(itxd->txd4, txd4);
 	WRITE_ONCE(itxd->txd3, (TX_DMA_SWC | TX_DMA_PLEN0(skb_headlen(skb)) |
 				(!nr_frags * TX_DMA_LS0)));
+	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
+		if (k & 0x1)
+			txd_pdma->txd2 |= TX_DMA_LS0;
+		else
+			txd_pdma->txd2 |= TX_DMA_LS1;
+	}
 
 	netdev_sent_queue(dev, skb->len);
 	skb_tx_timestamp(skb);
@@ -758,9 +843,15 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 	 */
 	wmb();
 
-	if (netif_xmit_stopped(netdev_get_tx_queue(dev, 0)) ||
-	    !netdev_xmit_more())
-		mtk_w32(eth, txd->txd2, MTK_QTX_CTX_PTR);
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
+		if (netif_xmit_stopped(netdev_get_tx_queue(dev, 0)) ||
+		    !netdev_xmit_more())
+			mtk_w32(eth, txd->txd2, MTK_QTX_CTX_PTR);
+	} else {
+		int next_idx = NEXT_DESP_IDX(txd_to_idx(ring, txd),
+					     ring->dma_size);
+		mtk_w32(eth, next_idx, MT7628_TX_CTX_IDX0);
+	}
 
 	return 0;
 
@@ -772,7 +863,11 @@ static int mtk_tx_map(struct sk_buff *skb, struct net_device *dev,
 		mtk_tx_unmap(eth, tx_buf);
 
 		itxd->txd3 = TX_DMA_LS0 | TX_DMA_OWNER_CPU;
+		if (!MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
+			itxd_pdma->txd2 = TX_DMA_DESP2_DEF;
+
 		itxd = mtk_qdma_phys_to_virt(ring, itxd->txd2);
+		itxd_pdma = qdma_to_pdma(ring, itxd);
 	} while (itxd != txd);
 
 	return -ENOMEM;
@@ -946,7 +1041,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		struct net_device *netdev;
 		unsigned int pktlen;
 		dma_addr_t dma_addr;
-		int mac = 0;
+		int mac;
 
 		ring = mtk_get_rx_ring(eth);
 		if (unlikely(!ring))
@@ -961,9 +1056,13 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			break;
 
 		/* find out which mac the packet come from. values start at 1 */
-		mac = (trxd.rxd4 >> RX_DMA_FPORT_SHIFT) &
-		      RX_DMA_FPORT_MASK;
-		mac--;
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628)) {
+			mac = 0;
+		} else {
+			mac = (trxd.rxd4 >> RX_DMA_FPORT_SHIFT) &
+				RX_DMA_FPORT_MASK;
+			mac--;
+		}
 
 		if (unlikely(mac < 0 || mac >= MTK_MAC_COUNT ||
 			     !eth->netdev[mac]))
@@ -981,7 +1080,8 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			goto release_desc;
 		}
 		dma_addr = dma_map_single(eth->dev,
-					  new_data + NET_SKB_PAD,
+					  new_data + NET_SKB_PAD +
+					  eth->ip_align,
 					  ring->buf_size,
 					  DMA_FROM_DEVICE);
 		if (unlikely(dma_mapping_error(eth->dev, dma_addr))) {
@@ -1004,7 +1104,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		pktlen = RX_DMA_GET_PLEN0(trxd.rxd2);
 		skb->dev = netdev;
 		skb_put(skb, pktlen);
-		if (trxd.rxd4 & RX_DMA_L4_VALID)
+		if (trxd.rxd4 & eth->rx_dma_l4_valid)
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 		else
 			skb_checksum_none_assert(skb);
@@ -1021,7 +1121,10 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		rxd->rxd1 = (unsigned int)dma_addr;
 
 release_desc:
-		rxd->rxd2 = RX_DMA_PLEN0(ring->buf_size);
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
+			rxd->rxd2 = RX_DMA_LSO;
+		else
+			rxd->rxd2 = RX_DMA_PLEN0(ring->buf_size);
 
 		ring->calc_idx = idx;
 
@@ -1040,19 +1143,14 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 	return done;
 }
 
-static int mtk_poll_tx(struct mtk_eth *eth, int budget)
+static int mtk_poll_tx_qdma(struct mtk_eth *eth, int budget,
+			    unsigned int *done, unsigned int *bytes)
 {
 	struct mtk_tx_ring *ring = &eth->tx_ring;
 	struct mtk_tx_dma *desc;
 	struct sk_buff *skb;
 	struct mtk_tx_buf *tx_buf;
-	unsigned int done[MTK_MAX_DEVS];
-	unsigned int bytes[MTK_MAX_DEVS];
 	u32 cpu, dma;
-	int total = 0, i;
-
-	memset(done, 0, sizeof(done));
-	memset(bytes, 0, sizeof(bytes));
 
 	cpu = mtk_r32(eth, MTK_QTX_CRX_PTR);
 	dma = mtk_r32(eth, MTK_QTX_DRX_PTR);
@@ -1090,6 +1188,62 @@ static int mtk_poll_tx(struct mtk_eth *eth, int budget)
 
 	mtk_w32(eth, cpu, MTK_QTX_CRX_PTR);
 
+	return budget;
+}
+
+static int mtk_poll_tx_pdma(struct mtk_eth *eth, int budget,
+			    unsigned int *done, unsigned int *bytes)
+{
+	struct mtk_tx_ring *ring = &eth->tx_ring;
+	struct mtk_tx_dma *desc;
+	struct sk_buff *skb;
+	struct mtk_tx_buf *tx_buf;
+	u32 cpu, dma;
+
+	cpu = ring->cpu_idx;
+	dma = mtk_r32(eth, MT7628_TX_DTX_IDX0);
+
+	while ((cpu != dma) && budget) {
+		tx_buf = &ring->buf[cpu];
+		skb = tx_buf->skb;
+		if (!skb)
+			break;
+
+		if (skb != (struct sk_buff *)MTK_DMA_DUMMY_DESC) {
+			bytes[0] += skb->len;
+			done[0]++;
+			budget--;
+		}
+
+		mtk_tx_unmap(eth, tx_buf);
+
+		desc = &ring->dma[cpu];
+		ring->last_free = desc;
+		atomic_inc(&ring->free_count);
+
+		cpu = NEXT_DESP_IDX(cpu, ring->dma_size);
+	}
+
+	ring->cpu_idx = cpu;
+
+	return budget;
+}
+
+static int mtk_poll_tx(struct mtk_eth *eth, int budget)
+{
+	struct mtk_tx_ring *ring = &eth->tx_ring;
+	unsigned int done[MTK_MAX_DEVS];
+	unsigned int bytes[MTK_MAX_DEVS];
+	int total = 0, i;
+
+	memset(done, 0, sizeof(done));
+	memset(bytes, 0, sizeof(bytes));
+
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
+		budget = mtk_poll_tx_qdma(eth, budget, done, bytes);
+	else
+		budget = mtk_poll_tx_pdma(eth, budget, done, bytes);
+
 	for (i = 0; i < MTK_MAC_COUNT; i++) {
 		if (!eth->netdev[i] || !done[i])
 			continue;
@@ -1121,13 +1275,14 @@ static int mtk_napi_tx(struct napi_struct *napi, int budget)
 	u32 status, mask;
 	int tx_done = 0;
 
-	mtk_handle_status_irq(eth);
-	mtk_w32(eth, MTK_TX_DONE_INT, MTK_QDMA_INT_STATUS);
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
+		mtk_handle_status_irq(eth);
+	mtk_w32(eth, MTK_TX_DONE_INT, eth->tx_int_status_reg);
 	tx_done = mtk_poll_tx(eth, budget);
 
 	if (unlikely(netif_msg_intr(eth))) {
-		status = mtk_r32(eth, MTK_QDMA_INT_STATUS);
-		mask = mtk_r32(eth, MTK_QDMA_INT_MASK);
+		status = mtk_r32(eth, eth->tx_int_status_reg);
+		mask = mtk_r32(eth, eth->tx_int_mask_reg);
 		dev_info(eth->dev,
 			 "done tx %d, intr 0x%08x/0x%x\n",
 			 tx_done, status, mask);
@@ -1136,7 +1291,7 @@ static int mtk_napi_tx(struct napi_struct *napi, int budget)
 	if (tx_done == budget)
 		return budget;
 
-	status = mtk_r32(eth, MTK_QDMA_INT_STATUS);
+	status = mtk_r32(eth, eth->tx_int_status_reg);
 	if (status & MTK_TX_DONE_INT)
 		return budget;
 
@@ -1203,6 +1358,24 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 		ring->dma[i].txd3 = TX_DMA_LS0 | TX_DMA_OWNER_CPU;
 	}
 
+	/* On MT7688 (PDMA only) this driver uses the ring->dma structs
+	 * only as the framework. The real HW descriptors are the PDMA
+	 * descriptors in ring->dma_pdma.
+	 */
+	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
+		ring->dma_pdma = dma_alloc_coherent(eth->dev, MTK_DMA_SIZE * sz,
+						    &ring->phys_pdma,
+						    GFP_ATOMIC);
+		if (!ring->dma_pdma)
+			goto no_tx_mem;
+
+		for (i = 0; i < MTK_DMA_SIZE; i++) {
+			ring->dma_pdma[i].txd2 = TX_DMA_DESP2_DEF;
+			ring->dma_pdma[i].txd4 = 0;
+		}
+	}
+
+	ring->dma_size = MTK_DMA_SIZE;
 	atomic_set(&ring->free_count, MTK_DMA_SIZE - 2);
 	ring->next_free = &ring->dma[0];
 	ring->last_free = &ring->dma[MTK_DMA_SIZE - 1];
@@ -1213,15 +1386,23 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 	 */
 	wmb();
 
-	mtk_w32(eth, ring->phys, MTK_QTX_CTX_PTR);
-	mtk_w32(eth, ring->phys, MTK_QTX_DTX_PTR);
-	mtk_w32(eth,
-		ring->phys + ((MTK_DMA_SIZE - 1) * sz),
-		MTK_QTX_CRX_PTR);
-	mtk_w32(eth,
-		ring->phys + ((MTK_DMA_SIZE - 1) * sz),
-		MTK_QTX_DRX_PTR);
-	mtk_w32(eth, (QDMA_RES_THRES << 8) | QDMA_RES_THRES, MTK_QTX_CFG(0));
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
+		mtk_w32(eth, ring->phys, MTK_QTX_CTX_PTR);
+		mtk_w32(eth, ring->phys, MTK_QTX_DTX_PTR);
+		mtk_w32(eth,
+			ring->phys + ((MTK_DMA_SIZE - 1) * sz),
+			MTK_QTX_CRX_PTR);
+		mtk_w32(eth,
+			ring->phys + ((MTK_DMA_SIZE - 1) * sz),
+			MTK_QTX_DRX_PTR);
+		mtk_w32(eth, (QDMA_RES_THRES << 8) | QDMA_RES_THRES,
+			MTK_QTX_CFG(0));
+	} else {
+		mtk_w32(eth, ring->phys_pdma, MT7628_TX_BASE_PTR0);
+		mtk_w32(eth, MTK_DMA_SIZE, MT7628_TX_MAX_CNT0);
+		mtk_w32(eth, 0, MT7628_TX_CTX_IDX0);
+		mtk_w32(eth, MT7628_PST_DTX_IDX0, MTK_PDMA_RST_IDX);
+	}
 
 	return 0;
 
@@ -1248,6 +1429,14 @@ static void mtk_tx_clean(struct mtk_eth *eth)
 				  ring->phys);
 		ring->dma = NULL;
 	}
+
+	if (ring->dma_pdma) {
+		dma_free_coherent(eth->dev,
+				  MTK_DMA_SIZE * sizeof(*ring->dma_pdma),
+				  ring->dma_pdma,
+				  ring->phys_pdma);
+		ring->dma_pdma = NULL;
+	}
 }
 
 static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
@@ -1295,14 +1484,17 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 
 	for (i = 0; i < rx_dma_size; i++) {
 		dma_addr_t dma_addr = dma_map_single(eth->dev,
-				ring->data[i] + NET_SKB_PAD,
+				ring->data[i] + NET_SKB_PAD + eth->ip_align,
 				ring->buf_size,
 				DMA_FROM_DEVICE);
 		if (unlikely(dma_mapping_error(eth->dev, dma_addr)))
 			return -ENOMEM;
 		ring->dma[i].rxd1 = (unsigned int)dma_addr;
 
-		ring->dma[i].rxd2 = RX_DMA_PLEN0(ring->buf_size);
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
+			ring->dma[i].rxd2 = RX_DMA_LSO;
+		else
+			ring->dma[i].rxd2 = RX_DMA_PLEN0(ring->buf_size);
 	}
 	ring->dma_size = rx_dma_size;
 	ring->calc_idx_update = false;
@@ -1618,9 +1810,16 @@ static int mtk_dma_busy_wait(struct mtk_eth *eth)
 	unsigned long t_start = jiffies;
 
 	while (1) {
-		if (!(mtk_r32(eth, MTK_QDMA_GLO_CFG) &
-		      (MTK_RX_DMA_BUSY | MTK_TX_DMA_BUSY)))
-			return 0;
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
+			if (!(mtk_r32(eth, MTK_QDMA_GLO_CFG) &
+			      (MTK_RX_DMA_BUSY | MTK_TX_DMA_BUSY)))
+				return 0;
+		} else {
+			if (!(mtk_r32(eth, MTK_PDMA_GLO_CFG) &
+			      (MTK_RX_DMA_BUSY | MTK_TX_DMA_BUSY)))
+				return 0;
+		}
+
 		if (time_after(jiffies, t_start + MTK_DMA_BUSY_TIMEOUT))
 			break;
 	}
@@ -1637,20 +1836,24 @@ static int mtk_dma_init(struct mtk_eth *eth)
 	if (mtk_dma_busy_wait(eth))
 		return -EBUSY;
 
-	/* QDMA needs scratch memory for internal reordering of the
-	 * descriptors
-	 */
-	err = mtk_init_fq_dma(eth);
-	if (err)
-		return err;
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
+		/* QDMA needs scratch memory for internal reordering of the
+		 * descriptors
+		 */
+		err = mtk_init_fq_dma(eth);
+		if (err)
+			return err;
+	}
 
 	err = mtk_tx_alloc(eth);
 	if (err)
 		return err;
 
-	err = mtk_rx_alloc(eth, 0, MTK_RX_FLAGS_QDMA);
-	if (err)
-		return err;
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
+		err = mtk_rx_alloc(eth, 0, MTK_RX_FLAGS_QDMA);
+		if (err)
+			return err;
+	}
 
 	err = mtk_rx_alloc(eth, 0, MTK_RX_FLAGS_NORMAL);
 	if (err)
@@ -1667,10 +1870,14 @@ static int mtk_dma_init(struct mtk_eth *eth)
 			return err;
 	}
 
-	/* Enable random early drop and set drop threshold automatically */
-	mtk_w32(eth, FC_THRES_DROP_MODE | FC_THRES_DROP_EN | FC_THRES_MIN,
-		MTK_QDMA_FC_THRES);
-	mtk_w32(eth, 0x0, MTK_QDMA_HRED2);
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
+		/* Enable random early drop and set drop threshold
+		 * automatically
+		 */
+		mtk_w32(eth, FC_THRES_DROP_MODE | FC_THRES_DROP_EN |
+			FC_THRES_MIN, MTK_QDMA_FC_THRES);
+		mtk_w32(eth, 0x0, MTK_QDMA_HRED2);
+	}
 
 	return 0;
 }
@@ -1741,13 +1948,15 @@ static irqreturn_t mtk_handle_irq_tx(int irq, void *_eth)
 static irqreturn_t mtk_handle_irq(int irq, void *_eth)
 {
 	struct mtk_eth *eth = _eth;
+	u32 status;
 
+	status = mtk_r32(eth, MTK_PDMA_INT_STATUS);
 	if (mtk_r32(eth, MTK_PDMA_INT_MASK) & MTK_RX_DONE_INT) {
 		if (mtk_r32(eth, MTK_PDMA_INT_STATUS) & MTK_RX_DONE_INT)
 			mtk_handle_irq_rx(irq, _eth);
 	}
-	if (mtk_r32(eth, MTK_QDMA_INT_MASK) & MTK_TX_DONE_INT) {
-		if (mtk_r32(eth, MTK_QDMA_INT_STATUS) & MTK_TX_DONE_INT)
+	if (mtk_r32(eth, eth->tx_int_mask_reg) & MTK_TX_DONE_INT) {
+		if (mtk_r32(eth, eth->tx_int_status_reg) & MTK_TX_DONE_INT)
 			mtk_handle_irq_tx(irq, _eth);
 	}
 
@@ -1779,17 +1988,23 @@ static int mtk_start_dma(struct mtk_eth *eth)
 		return err;
 	}
 
-	mtk_w32(eth,
-		MTK_TX_WB_DDONE | MTK_TX_DMA_EN |
-		MTK_DMA_SIZE_16DWORDS | MTK_NDP_CO_PRO |
-		MTK_RX_DMA_EN | MTK_RX_2B_OFFSET |
-		MTK_RX_BT_32DWORDS,
-		MTK_QDMA_GLO_CFG);
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
+		mtk_w32(eth,
+			MTK_TX_WB_DDONE | MTK_TX_DMA_EN |
+			MTK_DMA_SIZE_16DWORDS | MTK_NDP_CO_PRO |
+			MTK_RX_DMA_EN | MTK_RX_2B_OFFSET |
+			MTK_RX_BT_32DWORDS,
+			MTK_QDMA_GLO_CFG);
 
-	mtk_w32(eth,
-		MTK_RX_DMA_EN | rx_2b_offset |
-		MTK_RX_BT_32DWORDS | MTK_MULTI_EN,
-		MTK_PDMA_GLO_CFG);
+		mtk_w32(eth,
+			MTK_RX_DMA_EN | rx_2b_offset |
+			MTK_RX_BT_32DWORDS | MTK_MULTI_EN,
+			MTK_PDMA_GLO_CFG);
+	} else {
+		mtk_w32(eth, MTK_TX_WB_DDONE | MTK_TX_DMA_EN | MTK_RX_DMA_EN |
+			MTK_MULTI_EN | MTK_PDMA_SIZE_8DWORDS,
+			MTK_PDMA_GLO_CFG);
+	}
 
 	return 0;
 }
@@ -1817,7 +2032,6 @@ static int mtk_open(struct net_device *dev)
 
 	phy_start(dev->phydev);
 	netif_start_queue(dev);
-
 	return 0;
 }
 
@@ -1861,7 +2075,8 @@ static int mtk_stop(struct net_device *dev)
 	napi_disable(&eth->tx_napi);
 	napi_disable(&eth->rx_napi);
 
-	mtk_stop_dma(eth, MTK_QDMA_GLO_CFG);
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
+		mtk_stop_dma(eth, MTK_QDMA_GLO_CFG);
 	mtk_stop_dma(eth, MTK_PDMA_GLO_CFG);
 
 	mtk_dma_free(eth);
@@ -1923,6 +2138,24 @@ static int mtk_hw_init(struct mtk_eth *eth)
 	if (ret)
 		goto err_disable_pm;
 
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628)) {
+		ret = device_reset(eth->dev);
+		if (ret) {
+			dev_err(eth->dev, "MAC reset failed!\n");
+			goto err_disable_pm;
+		}
+
+		/* enable interrupt delay for RX */
+		mtk_w32(eth, MTK_PDMA_DELAY_RX_DELAY, MTK_PDMA_DELAY_INT);
+
+		/* disable delay and normal interrupt */
+		mtk_tx_irq_disable(eth, ~0);
+		mtk_rx_irq_disable(eth, ~0);
+
+		return 0;
+	}
+
+	/* Non-MT7628 handling... */
 	ethsys_reset(eth, RSTCTRL_FE);
 	ethsys_reset(eth, RSTCTRL_PPE);
 
@@ -2426,13 +2659,13 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 	eth->netdev[id]->netdev_ops = &mtk_netdev_ops;
 	eth->netdev[id]->base_addr = (unsigned long)eth->base;
 
-	eth->netdev[id]->hw_features = MTK_HW_FEATURES;
+	eth->netdev[id]->hw_features = eth->soc->hw_features;
 	if (eth->hwlro)
 		eth->netdev[id]->hw_features |= NETIF_F_LRO;
 
-	eth->netdev[id]->vlan_features = MTK_HW_FEATURES &
+	eth->netdev[id]->vlan_features = eth->soc->hw_features &
 		~(NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX);
-	eth->netdev[id]->features |= MTK_HW_FEATURES;
+	eth->netdev[id]->features |= eth->soc->hw_features;
 	eth->netdev[id]->ethtool_ops = &mtk_ethtool_ops;
 
 	eth->netdev[id]->irq = eth->irq[0];
@@ -2463,15 +2696,32 @@ static int mtk_probe(struct platform_device *pdev)
 	if (IS_ERR(eth->base))
 		return PTR_ERR(eth->base);
 
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA)) {
+		eth->tx_int_mask_reg = MTK_QDMA_INT_MASK;
+		eth->tx_int_status_reg = MTK_QDMA_INT_STATUS;
+	} else {
+		eth->tx_int_mask_reg = MTK_PDMA_INT_MASK;
+		eth->tx_int_status_reg = MTK_PDMA_INT_STATUS;
+	}
+
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628)) {
+		eth->rx_dma_l4_valid = RX_DMA_L4_VALID_PDMA;
+		eth->ip_align = NET_IP_ALIGN;
+	} else {
+		eth->rx_dma_l4_valid = RX_DMA_L4_VALID;
+	}
+
 	spin_lock_init(&eth->page_lock);
 	spin_lock_init(&eth->tx_irq_lock);
 	spin_lock_init(&eth->rx_irq_lock);
 
-	eth->ethsys = syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
-						      "mediatek,ethsys");
-	if (IS_ERR(eth->ethsys)) {
-		dev_err(&pdev->dev, "no ethsys regmap found\n");
-		return PTR_ERR(eth->ethsys);
+	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628)) {
+		eth->ethsys = syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
+							      "mediatek,ethsys");
+		if (IS_ERR(eth->ethsys)) {
+			dev_err(&pdev->dev, "no ethsys regmap found\n");
+			return PTR_ERR(eth->ethsys);
+		}
 	}
 
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_INFRA)) {
@@ -2572,9 +2822,12 @@ static int mtk_probe(struct platform_device *pdev)
 	if (err)
 		goto err_free_dev;
 
-	err = mtk_mdio_init(eth);
-	if (err)
-		goto err_free_dev;
+	/* No MT7628/88 support yet */
+	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628)) {
+		err = mtk_mdio_init(eth);
+		if (err)
+			goto err_free_dev;
+	}
 
 	for (i = 0; i < MTK_MAX_DEVS; i++) {
 		if (!eth->netdev[i])
@@ -2637,12 +2890,14 @@ static int mtk_remove(struct platform_device *pdev)
 
 static const struct mtk_soc_data mt2701_data = {
 	.caps = MT7623_CAPS | MTK_HWLRO,
+	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7623_CLKS_BITMAP,
 	.required_pctl = true,
 };
 
 static const struct mtk_soc_data mt7621_data = {
 	.caps = MT7621_CAPS,
+	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7621_CLKS_BITMAP,
 	.required_pctl = false,
 };
@@ -2650,12 +2905,14 @@ static const struct mtk_soc_data mt7621_data = {
 static const struct mtk_soc_data mt7622_data = {
 	.ana_rgc3 = 0x2028,
 	.caps = MT7622_CAPS | MTK_HWLRO,
+	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7622_CLKS_BITMAP,
 	.required_pctl = false,
 };
 
 static const struct mtk_soc_data mt7623_data = {
 	.caps = MT7623_CAPS | MTK_HWLRO,
+	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7623_CLKS_BITMAP,
 	.required_pctl = true,
 };
@@ -2663,16 +2920,25 @@ static const struct mtk_soc_data mt7623_data = {
 static const struct mtk_soc_data mt7629_data = {
 	.ana_rgc3 = 0x128,
 	.caps = MT7629_CAPS | MTK_HWLRO,
+	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7629_CLKS_BITMAP,
 	.required_pctl = false,
 };
 
+static const struct mtk_soc_data rt5350_data = {
+	.caps = MT7628_CAPS,
+	.hw_features = MTK_HW_FEATURES_MT7628,
+	.required_clks = MT7628_CLKS_BITMAP,
+	.required_pctl = false,
+};
+
 const struct of_device_id of_mtk_match[] = {
 	{ .compatible = "mediatek,mt2701-eth", .data = &mt2701_data},
 	{ .compatible = "mediatek,mt7621-eth", .data = &mt7621_data},
 	{ .compatible = "mediatek,mt7622-eth", .data = &mt7622_data},
 	{ .compatible = "mediatek,mt7623-eth", .data = &mt7623_data},
 	{ .compatible = "mediatek,mt7629-eth", .data = &mt7629_data},
+	{ .compatible = "ralink,rt5350-eth", .data = &rt5350_data},
 	{},
 };
 MODULE_DEVICE_TABLE(of, of_mtk_match);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 556644f28eae..cc1466ae0926 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -39,6 +39,7 @@
 				 NETIF_F_SG | NETIF_F_TSO | \
 				 NETIF_F_TSO6 | \
 				 NETIF_F_IPV6_CSUM)
+#define MTK_HW_FEATURES_MT7628	(NETIF_F_SG | NETIF_F_RXCSUM)
 #define NEXT_DESP_IDX(X, Y)	(((X) + 1) & ((Y) - 1))
 
 #define MTK_MAX_RX_RING_NUM	4
@@ -118,6 +119,7 @@
 /* PDMA Global Configuration Register */
 #define MTK_PDMA_GLO_CFG	0xa04
 #define MTK_MULTI_EN		BIT(10)
+#define MTK_PDMA_SIZE_8DWORDS	(1 << 4)
 
 /* PDMA Reset Index Register */
 #define MTK_PDMA_RST_IDX	0xa08
@@ -276,11 +278,18 @@
 #define TX_DMA_OWNER_CPU	BIT(31)
 #define TX_DMA_LS0		BIT(30)
 #define TX_DMA_PLEN0(_x)	(((_x) & MTK_TX_DMA_BUF_LEN) << 16)
+#define TX_DMA_PLEN1(_x)	((_x) & MTK_TX_DMA_BUF_LEN)
 #define TX_DMA_SWC		BIT(14)
 #define TX_DMA_SDL(_x)		(((_x) & 0x3fff) << 16)
 
+/* PDMA on MT7628 */
+#define TX_DMA_DONE		BIT(31)
+#define TX_DMA_LS1		BIT(14)
+#define TX_DMA_DESP2_DEF	(TX_DMA_LS0 | TX_DMA_DONE)
+
 /* QDMA descriptor rxd2 */
 #define RX_DMA_DONE		BIT(31)
+#define RX_DMA_LSO		BIT(30)
 #define RX_DMA_PLEN0(_x)	(((_x) & 0x3fff) << 16)
 #define RX_DMA_GET_PLEN0(_x)	(((_x) >> 16) & 0x3fff)
 
@@ -289,6 +298,7 @@
 
 /* QDMA descriptor rxd4 */
 #define RX_DMA_L4_VALID		BIT(24)
+#define RX_DMA_L4_VALID_PDMA	BIT(30)		/* when PDMA is used */
 #define RX_DMA_FPORT_SHIFT	19
 #define RX_DMA_FPORT_MASK	0x7
 
@@ -412,6 +422,19 @@
 #define CO_QPHY_SEL            BIT(0)
 #define GEPHY_MAC_SEL          BIT(1)
 
+/* MT7628/88 specific stuff */
+#define MT7628_PDMA_OFFSET	0x0800
+#define MT7628_SDM_OFFSET	0x0c00
+
+#define MT7628_TX_BASE_PTR0	(MT7628_PDMA_OFFSET + 0x00)
+#define MT7628_TX_MAX_CNT0	(MT7628_PDMA_OFFSET + 0x04)
+#define MT7628_TX_CTX_IDX0	(MT7628_PDMA_OFFSET + 0x08)
+#define MT7628_TX_DTX_IDX0	(MT7628_PDMA_OFFSET + 0x0c)
+#define MT7628_PST_DTX_IDX0	BIT(0)
+
+#define MT7628_SDM_MAC_ADRL	(MT7628_SDM_OFFSET + 0x0c)
+#define MT7628_SDM_MAC_ADRH	(MT7628_SDM_OFFSET + 0x10)
+
 struct mtk_rx_dma {
 	unsigned int rxd1;
 	unsigned int rxd2;
@@ -509,6 +532,7 @@ enum mtk_clks_map {
 				 BIT(MTK_CLK_SGMII_CK) | \
 				 BIT(MTK_CLK_ETH2PLL))
 #define MT7621_CLKS_BITMAP	(0)
+#define MT7628_CLKS_BITMAP	(0)
 #define MT7629_CLKS_BITMAP	(BIT(MTK_CLK_ETHIF) | BIT(MTK_CLK_ESW) |  \
 				 BIT(MTK_CLK_GP0) | BIT(MTK_CLK_GP1) | \
 				 BIT(MTK_CLK_GP2) | BIT(MTK_CLK_FE) | \
@@ -563,6 +587,10 @@ struct mtk_tx_ring {
 	struct mtk_tx_dma *last_free;
 	u16 thresh;
 	atomic_t free_count;
+	int dma_size;
+	struct mtk_tx_dma *dma_pdma;	/* For MT7628/88 PDMA handling */
+	dma_addr_t phys_pdma;
+	int cpu_idx;
 };
 
 /* PDMA rx ring mode */
@@ -604,6 +632,8 @@ enum mkt_eth_capabilities {
 	MTK_HWLRO_BIT,
 	MTK_SHARED_INT_BIT,
 	MTK_TRGMII_MT7621_CLK_BIT,
+	MTK_QDMA_BIT,
+	MTK_SOC_MT7628_BIT,
 
 	/* MUX BITS*/
 	MTK_ETH_MUX_GDM1_TO_GMAC1_ESW_BIT,
@@ -634,6 +664,8 @@ enum mkt_eth_capabilities {
 #define MTK_HWLRO		BIT(MTK_HWLRO_BIT)
 #define MTK_SHARED_INT		BIT(MTK_SHARED_INT_BIT)
 #define MTK_TRGMII_MT7621_CLK	BIT(MTK_TRGMII_MT7621_CLK_BIT)
+#define MTK_QDMA		BIT(MTK_QDMA_BIT)
+#define MTK_SOC_MT7628		BIT(MTK_SOC_MT7628_BIT)
 
 #define MTK_ETH_MUX_GDM1_TO_GMAC1_ESW		\
 	BIT(MTK_ETH_MUX_GDM1_TO_GMAC1_ESW_BIT)
@@ -687,26 +719,31 @@ enum mkt_eth_capabilities {
 #define MTK_HAS_CAPS(caps, _x)		(((caps) & (_x)) == (_x))
 
 #define MT7621_CAPS  (MTK_GMAC1_RGMII | MTK_GMAC1_TRGMII | \
-		      MTK_GMAC2_RGMII | MTK_SHARED_INT | MTK_TRGMII_MT7621_CLK)
+		      MTK_GMAC2_RGMII | MTK_SHARED_INT | \
+		      MTK_TRGMII_MT7621_CLK | MTK_QDMA)
 
 #define MT7622_CAPS  (MTK_GMAC1_RGMII | MTK_GMAC1_SGMII | MTK_GMAC2_RGMII | \
 		      MTK_GMAC2_SGMII | MTK_GDM1_ESW | \
 		      MTK_MUX_GDM1_TO_GMAC1_ESW | \
-		      MTK_MUX_GMAC1_GMAC2_TO_SGMII_RGMII)
+		      MTK_MUX_GMAC1_GMAC2_TO_SGMII_RGMII | MTK_QDMA)
+
+#define MT7623_CAPS  (MTK_GMAC1_RGMII | MTK_GMAC1_TRGMII | MTK_GMAC2_RGMII | \
+		      MTK_QDMA)
 
-#define MT7623_CAPS  (MTK_GMAC1_RGMII | MTK_GMAC1_TRGMII | MTK_GMAC2_RGMII)
+#define MT7628_CAPS  (MTK_SHARED_INT | MTK_SOC_MT7628)
 
 #define MT7629_CAPS  (MTK_GMAC1_SGMII | MTK_GMAC2_SGMII | MTK_GMAC2_GEPHY | \
 		      MTK_GDM1_ESW | MTK_MUX_GDM1_TO_GMAC1_ESW | \
 		      MTK_MUX_GMAC2_GMAC0_TO_GEPHY | \
 		      MTK_MUX_U3_GMAC2_TO_QPHY | \
-		      MTK_MUX_GMAC12_TO_GEPHY_SGMII)
+		      MTK_MUX_GMAC12_TO_GEPHY_SGMII | MTK_QDMA)
 
 /* struct mtk_eth_data -	This is the structure holding all differences
  *				among various plaforms
  * @ana_rgc3:                   The offset for register ANA_RGC3 related to
  *				sgmiisys syscon
  * @caps			Flags shown the extra capability for the SoC
+ * @hw_features			Flags shown HW features
  * @required_clks		Flags shown the bitmap for required clocks on
  *				the target SoC
  * @required_pctl		A bool value to show whether the SoC requires
@@ -717,6 +754,7 @@ struct mtk_soc_data {
 	u32		caps;
 	u32		required_clks;
 	bool		required_pctl;
+	netdev_features_t hw_features;
 };
 
 /* currently no SoC has more than 2 macs */
@@ -810,6 +848,11 @@ struct mtk_eth {
 	unsigned long			state;
 
 	const struct mtk_soc_data	*soc;
+
+	u32				tx_int_mask_reg;
+	u32				tx_int_status_reg;
+	u32				rx_dma_l4_valid;
+	int				ip_align;
 };
 
 /* struct mtk_mac -	the structure that holds the info about the MACs of the
-- 
2.22.1

