Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39E82136C70
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 12:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgAJLzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 06:55:00 -0500
Received: from foss.arm.com ([217.140.110.172]:43188 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbgAJLyj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 06:54:39 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1F5651396;
        Fri, 10 Jan 2020 03:54:38 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E00FE3F534;
        Fri, 10 Jan 2020 03:54:36 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/14] net: axienet: Upgrade descriptors to hold 64-bit addresses
Date:   Fri, 10 Jan 2020 11:54:12 +0000
Message-Id: <20200110115415.75683-12-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200110115415.75683-1-andre.przywara@arm.com>
References: <20200110115415.75683-1-andre.przywara@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Newer revisions of the AXI DMA IP (>= v7.1) support 64-bit addresses,
both for the descriptors itself, as well as for the buffers they are
pointing to.
This is realised by adding "MSB" words for the next and phys pointer
right behind the existing address word, now named "LSB". These MSB words
live in formerly reserved areas of the descriptor.

If the hardware supports it, write both words when setting an address.
The buffer address is handled by two wrapper functions, the two
occasions where we set the next pointers are open coded.

For now this is guarded by a flag which we don't set yet.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |   9 +-
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 109 ++++++++++++------
 2 files changed, 81 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 2dacfc85b3ba..4aea4c23d3bb 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -335,6 +335,7 @@
 #define XAE_FEATURE_PARTIAL_TX_CSUM	(1 << 1)
 #define XAE_FEATURE_FULL_RX_CSUM	(1 << 2)
 #define XAE_FEATURE_FULL_TX_CSUM	(1 << 3)
+#define XAE_FEATURE_DMA_64BIT		(1 << 4)
 
 #define XAE_NO_CSUM_OFFLOAD		0
 
@@ -347,9 +348,9 @@
 /**
  * struct axidma_bd - Axi Dma buffer descriptor layout
  * @next:         MM2S/S2MM Next Descriptor Pointer
- * @reserved1:    Reserved and not used
+ * @next_msb:     MM2S/S2MM Next Descriptor Pointer (high 32 bits)
  * @phys:         MM2S/S2MM Buffer Address
- * @reserved2:    Reserved and not used
+ * @phys_msb:     MM2S/S2MM Buffer Address (high 32 bits)
  * @reserved3:    Reserved and not used
  * @reserved4:    Reserved and not used
  * @cntrl:        MM2S/S2MM Control value
@@ -362,9 +363,9 @@
  */
 struct axidma_bd {
 	u32 next;	/* Physical address of next buffer descriptor */
-	u32 reserved1;
+	u32 next_msb;	/* high 32 bits for IP >= v7.1, reserved on older IP */
 	u32 phys;
-	u32 reserved2;
+	u32 phys_msb; 	/* for IP >= v7.1, reserved for older IP */
 	u32 reserved3;
 	u32 reserved4;
 	u32 cntrl;
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index bbdda4b0c677..133f088d797e 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -153,6 +153,25 @@ static void axienet_dma_out_addr(struct axienet_local *lp, off_t reg,
 	axienet_dma_out32(lp, reg, lower_32_bits(addr));
 }
 
+static void desc_set_phys_addr(struct axienet_local *lp, dma_addr_t addr,
+			       struct axidma_bd *desc)
+{
+	desc->phys = lower_32_bits(addr);
+	if (lp->features & XAE_FEATURE_DMA_64BIT)
+		desc->phys_msb = upper_32_bits(addr);
+}
+
+static dma_addr_t desc_get_phys_addr(struct axienet_local *lp,
+				     struct axidma_bd *desc)
+{
+	dma_addr_t ret = desc->phys;
+
+	if (lp->features & XAE_FEATURE_DMA_64BIT)
+		ret |= (dma_addr_t)desc->phys_msb << 32;
+
+	return ret;
+}
+
 /**
  * axienet_dma_bd_release - Release buffer descriptor rings
  * @ndev:	Pointer to the net_device structure
@@ -176,6 +195,8 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 		return;
 
 	for (i = 0; i < lp->rx_bd_num; i++) {
+		dma_addr_t phys;
+
 		/* A NULL skb means this descriptor has not been initialised
 		 * at all.
 		 */
@@ -188,9 +209,11 @@ static void axienet_dma_bd_release(struct net_device *ndev)
 		 * descriptor size, after it had been successfully allocated.
 		 * So a non-zero value in there means we need to unmap it.
 		 */
-		if (lp->rx_bd_v[i].cntrl)
-			dma_unmap_single(ndev->dev.parent, lp->rx_bd_v[i].phys,
+		if (lp->rx_bd_v[i].cntrl) {
+			phys = desc_get_phys_addr(lp, &lp->rx_bd_v[i]);
+			dma_unmap_single(ndev->dev.parent, phys,
 					 lp->max_frm_size, DMA_FROM_DEVICE);
+		}
 	}
 
 	dma_free_coherent(ndev->dev.parent,
@@ -235,29 +258,36 @@ static int axienet_dma_bd_init(struct net_device *ndev)
 		goto out;
 
 	for (i = 0; i < lp->tx_bd_num; i++) {
-		lp->tx_bd_v[i].next = lp->tx_bd_p +
-				      sizeof(*lp->tx_bd_v) *
-				      ((i + 1) % lp->tx_bd_num);
+		dma_addr_t addr = lp->tx_bd_p +
+				  sizeof(*lp->tx_bd_v) *
+				  ((i + 1) % lp->tx_bd_num);
+
+		lp->tx_bd_v[i].next = lower_32_bits(addr);
+		if (lp->features & XAE_FEATURE_DMA_64BIT)
+			lp->tx_bd_v[i].next_msb = upper_32_bits(addr);
 	}
 
 	for (i = 0; i < lp->rx_bd_num; i++) {
-		lp->rx_bd_v[i].next = lp->rx_bd_p +
-				      sizeof(*lp->rx_bd_v) *
-				      ((i + 1) % lp->rx_bd_num);
+		dma_addr_t addr;
+
+		addr = lp->rx_bd_p + sizeof(*lp->rx_bd_v) *
+			((i + 1) % lp->rx_bd_num);
+		lp->rx_bd_v[i].next = lower_32_bits(addr);
+		if (lp->features & XAE_FEATURE_DMA_64BIT)
+			lp->rx_bd_v[i].next_msb = upper_32_bits(addr);
 
 		skb = netdev_alloc_skb_ip_align(ndev, lp->max_frm_size);
 		if (!skb)
 			goto out;
 
 		lp->rx_bd_v[i].skb = skb;
-		lp->rx_bd_v[i].phys = dma_map_single(ndev->dev.parent,
-						     skb->data,
-						     lp->max_frm_size,
-						     DMA_FROM_DEVICE);
-		if (dma_mapping_error(ndev->dev.parent, lp->rx_bd_v[i].phys)) {
+		addr = dma_map_single(ndev->dev.parent, skb->data,
+				      lp->max_frm_size, DMA_FROM_DEVICE);
+		if (dma_mapping_error(ndev->dev.parent, addr)) {
 			dev_kfree_skb(skb);
 			goto out;
 		}
+		desc_set_phys_addr(lp, addr, &lp->rx_bd_v[i]);
 
 		lp->rx_bd_v[i].cntrl = lp->max_frm_size;
 	}
@@ -565,6 +595,7 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 	struct axienet_local *lp = netdev_priv(ndev);
 	int max_bds = (nr_bds != -1) ? nr_bds : lp->tx_bd_num;
 	struct axidma_bd *cur_p;
+	dma_addr_t phys;
 	unsigned int status;
 	int i;
 
@@ -578,7 +609,8 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 		if (nr_bds == -1 && !(status & XAXIDMA_BD_STS_COMPLETE_MASK))
 			break;
 
-		dma_unmap_single(ndev->dev.parent, cur_p->phys,
+		phys = desc_get_phys_addr(lp, cur_p);
+		dma_unmap_single(ndev->dev.parent, phys,
 				(cur_p->cntrl & XAXIDMA_BD_CTRL_LENGTH_MASK),
 				DMA_TO_DEVICE);
 
@@ -676,7 +708,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	u32 csum_start_off;
 	u32 csum_index_off;
 	skb_frag_t *frag;
-	dma_addr_t tail_p;
+	dma_addr_t tail_p, phys;
 	struct axienet_local *lp = netdev_priv(ndev);
 	struct axidma_bd *cur_p;
 	u32 orig_tail_ptr = lp->tx_bd_tail;
@@ -715,10 +747,11 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		cur_p->app0 |= 2; /* Tx Full Checksum Offload Enabled */
 	}
 
-	cur_p->phys = dma_map_single(ndev->dev.parent, skb->data,
-				     skb_headlen(skb), DMA_TO_DEVICE);
-	if (dma_mapping_error(ndev->dev.parent, cur_p->phys))
+	phys = dma_map_single(ndev->dev.parent, skb->data,
+			      skb_headlen(skb), DMA_TO_DEVICE);
+	if (dma_mapping_error(ndev->dev.parent, phys))
 		return NETDEV_TX_BUSY;
+	desc_set_phys_addr(lp, phys, cur_p);
 	cur_p->cntrl = skb_headlen(skb) | XAXIDMA_BD_CTRL_TXSOF_MASK;
 
 	for (ii = 0; ii < num_frag; ii++) {
@@ -726,17 +759,18 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			lp->tx_bd_tail = 0;
 		cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 		frag = &skb_shinfo(skb)->frags[ii];
-		cur_p->phys = dma_map_single(ndev->dev.parent,
-					     skb_frag_address(frag),
-					     skb_frag_size(frag),
-					     DMA_TO_DEVICE);
-		if (dma_mapping_error(ndev->dev.parent, cur_p->phys)) {
+		phys = dma_map_single(ndev->dev.parent,
+				      skb_frag_address(frag),
+				      skb_frag_size(frag),
+				      DMA_TO_DEVICE);
+		if (dma_mapping_error(ndev->dev.parent, phys)) {
 			axienet_free_tx_chain(ndev, orig_tail_ptr, ii + 1,
 					      NULL);
 			lp->tx_bd_tail = orig_tail_ptr;
 
 			return NETDEV_TX_BUSY;
 		}
+		desc_set_phys_addr(lp, phys, cur_p);
 		cur_p->cntrl = skb_frag_size(frag);
 	}
 
@@ -775,10 +809,12 @@ static void axienet_recv(struct net_device *ndev)
 	cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
 
 	while ((cur_p->status & XAXIDMA_BD_STS_COMPLETE_MASK)) {
+		dma_addr_t phys;
+
 		tail_p = lp->rx_bd_p + sizeof(*lp->rx_bd_v) * lp->rx_bd_ci;
 
-		dma_unmap_single(ndev->dev.parent, cur_p->phys,
-				 lp->max_frm_size,
+		phys = desc_get_phys_addr(lp, cur_p);
+		dma_unmap_single(ndev->dev.parent, phys, lp->max_frm_size,
 				 DMA_FROM_DEVICE);
 
 		skb = cur_p->skb;
@@ -814,13 +850,14 @@ static void axienet_recv(struct net_device *ndev)
 		if (!new_skb)
 			return;
 
-		cur_p->phys = dma_map_single(ndev->dev.parent, new_skb->data,
-					     lp->max_frm_size,
-					     DMA_FROM_DEVICE);
-		if (dma_mapping_error(ndev->dev.parent, cur_p->phys)) {
+		phys = dma_map_single(ndev->dev.parent, new_skb->data,
+				      lp->max_frm_size,
+				      DMA_FROM_DEVICE);
+		if (dma_mapping_error(ndev->dev.parent, phys)) {
 			dev_kfree_skb(new_skb);
 			return;
 		}
+		desc_set_phys_addr(lp, phys, cur_p);
 
 		cur_p->cntrl = lp->max_frm_size;
 		cur_p->status = 0;
@@ -865,7 +902,8 @@ static irqreturn_t axienet_tx_irq(int irq, void *_ndev)
 		return IRQ_NONE;
 	if (status & XAXIDMA_IRQ_ERROR_MASK) {
 		dev_err(&ndev->dev, "DMA Tx error 0x%x\n", status);
-		dev_err(&ndev->dev, "Current BD is at: 0x%x\n",
+		dev_err(&ndev->dev, "Current BD is at: 0x%x%08x\n",
+			(lp->tx_bd_v[lp->tx_bd_ci]).phys_msb,
 			(lp->tx_bd_v[lp->tx_bd_ci]).phys);
 
 		cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
@@ -914,7 +952,8 @@ static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
 		return IRQ_NONE;
 	if (status & XAXIDMA_IRQ_ERROR_MASK) {
 		dev_err(&ndev->dev, "DMA Rx error 0x%x\n", status);
-		dev_err(&ndev->dev, "Current BD is at: 0x%x\n",
+		dev_err(&ndev->dev, "Current BD is at: 0x%x%08x\n",
+			(lp->rx_bd_v[lp->rx_bd_ci]).phys_msb,
 			(lp->rx_bd_v[lp->rx_bd_ci]).phys);
 
 		cr = axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
@@ -1622,14 +1661,18 @@ static void axienet_dma_err_handler(unsigned long data)
 
 	for (i = 0; i < lp->tx_bd_num; i++) {
 		cur_p = &lp->tx_bd_v[i];
-		if (cur_p->cntrl)
-			dma_unmap_single(ndev->dev.parent, cur_p->phys,
+		if (cur_p->cntrl) {
+			dma_addr_t addr = desc_get_phys_addr(lp, cur_p);
+
+			dma_unmap_single(ndev->dev.parent, addr,
 					 (cur_p->cntrl &
 					  XAXIDMA_BD_CTRL_LENGTH_MASK),
 					 DMA_TO_DEVICE);
+		}
 		if (cur_p->skb)
 			dev_kfree_skb_irq(cur_p->skb);
 		cur_p->phys = 0;
+		cur_p->phys_msb = 0;
 		cur_p->cntrl = 0;
 		cur_p->status = 0;
 		cur_p->app0 = 0;
-- 
2.17.1

