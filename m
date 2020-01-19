Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 211031420B0
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 00:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgASXQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 18:16:33 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49796 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729045AbgASXQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 18:16:33 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id 754CE299A4; Sun, 19 Jan 2020 18:16:31 -0500 (EST)
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <a4377f6caa3532d40a5b46e9eeafe3ff775975bc.1579474569.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1579474569.git.fthain@telegraphics.com.au>
References: <cover.1579474569.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net 15/19] net/sonic: Fix receive buffer replenishment
Date:   Mon, 20 Jan 2020 09:56:09 +1100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As soon as the driver is finished with a receive buffer it allocs a new
one and overwrites the corresponding RRA entry with a new buffer pointer.

Problem is, the buffer pointer is split across two word-sized registers.
It can't be updated in one atomic store. So this operation races with the
chip while it stores received packets and advances its RRP register.

Avoid this problem by adding buffers only at the location given by the
RWP register, in accordance with the National Semiconductor datasheet.

Re-factor this code into separate functions to calculate a RRA pointer
and to update the RWP.

Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/net/ethernet/natsemi/sonic.c | 149 ++++++++++++++++-----------
 drivers/net/ethernet/natsemi/sonic.h |  18 +++-
 2 files changed, 104 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index 5db107b8c6ee..343a8a7a6edf 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -459,6 +459,58 @@ static inline int index_from_addr(struct sonic_local *lp, dma_addr_t addr,
 	return -ENOENT;
 }
 
+/* Allocate and map a new skb to be used as a receive buffer. */
+
+static bool sonic_alloc_rb(struct net_device *dev, struct sonic_local *lp,
+			   struct sk_buff **new_skb, dma_addr_t *new_addr)
+{
+	*new_skb = netdev_alloc_skb(dev, SONIC_RBSIZE + 2);
+	if (!*new_skb)
+		return false;
+
+	if (SONIC_BUS_SCALE(lp->dma_bitmode) == 2)
+		skb_reserve(*new_skb, 2);
+
+	*new_addr = dma_map_single(lp->device, skb_put(*new_skb, SONIC_RBSIZE),
+				   SONIC_RBSIZE, DMA_FROM_DEVICE);
+	if (!*new_addr) {
+		dev_kfree_skb(*new_skb);
+		*new_skb = NULL;
+		return false;
+	}
+
+	return true;
+}
+
+/* Place a new receive resource in the Receive Resource Area and update RWP. */
+
+static void sonic_update_rra(struct net_device *dev, struct sonic_local *lp,
+			     dma_addr_t old_addr, dma_addr_t new_addr)
+{
+	unsigned int entry = sonic_rr_entry(dev, SONIC_READ(SONIC_RWP));
+	unsigned int end = sonic_rr_entry(dev, SONIC_READ(SONIC_RRP));
+
+	/* The resources in the range [RRP, RWP) belong to the SONIC. This loop
+	 * scans the other resources in the RRA, those in the range [RWP, RRP).
+	 */
+	do {
+		u32 buf = (sonic_rra_get(dev, entry, SONIC_RR_BUFADR_H) << 16) |
+			  sonic_rra_get(dev, entry, SONIC_RR_BUFADR_L);
+
+		if (buf == old_addr)
+			break;
+
+		entry = (entry + 1) & SONIC_RRS_MASK;
+	} while (entry != end);
+
+	sonic_rra_put(dev, entry, SONIC_RR_BUFADR_H, new_addr >> 16);
+	sonic_rra_put(dev, entry, SONIC_RR_BUFADR_L, new_addr & 0xffff);
+
+	entry = (entry + 1) & SONIC_RRS_MASK;
+
+	SONIC_WRITE(SONIC_RWP, sonic_rr_addr(dev, entry));
+}
+
 /*
  * We have a good packet(s), pass it/them up the network stack.
  */
@@ -467,19 +519,16 @@ static void sonic_rx(struct net_device *dev)
 	struct sonic_local *lp = netdev_priv(dev);
 	int entry = lp->cur_rx;
 	int prev_entry = lp->eol_rx;
+	bool rbe = false;
 
 	while (sonic_rda_get(dev, entry, SONIC_RD_IN_USE) == 0) {
-		struct sk_buff *used_skb;
-		struct sk_buff *new_skb;
-		dma_addr_t new_laddr;
-		u16 bufadr_l;
-		u16 bufadr_h;
-		int pkt_len;
 		u16 status = sonic_rda_get(dev, entry, SONIC_RD_STATUS);
 
 		/* If the RD has LPKT set, the chip has finished with the RB */
 
 		if ((status & SONIC_RCR_PRX) && (status & SONIC_RCR_LPKT)) {
+			struct sk_buff *new_skb;
+			dma_addr_t new_laddr;
 			u32 addr = (sonic_rda_get(dev, entry,
 						  SONIC_RD_PKTPTR_H) << 16) |
 				   sonic_rda_get(dev, entry, SONIC_RD_PKTPTR_L);
@@ -490,55 +539,35 @@ static void sonic_rx(struct net_device *dev)
 				break;
 			}
 
-			/* Malloc up new buffer. */
-			new_skb = netdev_alloc_skb(dev, SONIC_RBSIZE + 2);
-			if (new_skb == NULL) {
+			if (sonic_alloc_rb(dev, lp, &new_skb, &new_laddr)) {
+				struct sk_buff *used_skb = lp->rx_skb[i];
+				int pkt_len;
+
+				/* Pass the used buffer up the stack */
+				dma_unmap_single(lp->device, addr, SONIC_RBSIZE,
+						 DMA_FROM_DEVICE);
+
+				pkt_len = sonic_rda_get(dev, entry,
+							SONIC_RD_PKTLEN);
+				skb_trim(used_skb, pkt_len);
+				used_skb->protocol = eth_type_trans(used_skb,
+								    dev);
+				netif_rx(used_skb);
+				lp->stats.rx_packets++;
+				lp->stats.rx_bytes += pkt_len;
+
+				lp->rx_skb[i] = new_skb;
+				lp->rx_laddr[i] = new_laddr;
+			} else {
+				/* Failed to obtain a new buffer so re-use it */
+				new_laddr = addr;
 				lp->stats.rx_dropped++;
-				break;
 			}
-			/* provide 16 byte IP header alignment unless DMA requires otherwise */
-			if(SONIC_BUS_SCALE(lp->dma_bitmode) == 2)
-				skb_reserve(new_skb, 2);
-
-			new_laddr = dma_map_single(lp->device, skb_put(new_skb, SONIC_RBSIZE),
-		                               SONIC_RBSIZE, DMA_FROM_DEVICE);
-			if (!new_laddr) {
-				dev_kfree_skb(new_skb);
-				printk(KERN_ERR "%s: Failed to map rx buffer, dropping packet.\n", dev->name);
-				lp->stats.rx_dropped++;
-				break;
-			}
-
-			/* now we have a new skb to replace it, pass the used one up the stack */
-			dma_unmap_single(lp->device, lp->rx_laddr[entry], SONIC_RBSIZE, DMA_FROM_DEVICE);
-			used_skb = lp->rx_skb[i];
-			pkt_len = sonic_rda_get(dev, entry, SONIC_RD_PKTLEN);
-			skb_trim(used_skb, pkt_len);
-			used_skb->protocol = eth_type_trans(used_skb, dev);
-			netif_rx(used_skb);
-			lp->stats.rx_packets++;
-			lp->stats.rx_bytes += pkt_len;
-
-			/* and insert the new skb */
-			lp->rx_laddr[i] = new_laddr;
-			lp->rx_skb[i] = new_skb;
-
-			bufadr_l = (unsigned long)new_laddr & 0xffff;
-			bufadr_h = (unsigned long)new_laddr >> 16;
-			sonic_rra_put(dev, i, SONIC_RR_BUFADR_L, bufadr_l);
-			sonic_rra_put(dev, i, SONIC_RR_BUFADR_H, bufadr_h);
-			/*
-			 * this was the last packet out of the current receive buffer
-			 * give the buffer back to the SONIC
+			/* If RBE is already asserted when RWP advances then
+			 * it's safe to clear RBE after processing this packet.
 			 */
-			lp->cur_rwp += SIZEOF_SONIC_RR * SONIC_BUS_SCALE(lp->dma_bitmode);
-			if (lp->cur_rwp >= lp->rra_end) lp->cur_rwp = lp->rra_laddr & 0xffff;
-			SONIC_WRITE(SONIC_RWP, lp->cur_rwp);
-			if (SONIC_READ(SONIC_ISR) & SONIC_INT_RBE) {
-				netif_dbg(lp, rx_err, dev, "%s: rx buffer exhausted\n",
-					  __func__);
-				SONIC_WRITE(SONIC_ISR, SONIC_INT_RBE); /* clear the flag */
-			}
+			rbe = rbe || SONIC_READ(SONIC_ISR) & SONIC_INT_RBE;
+			sonic_update_rra(dev, lp, addr, new_laddr);
 		}
 		/*
 		 * give back the descriptor
@@ -560,6 +589,9 @@ static void sonic_rx(struct net_device *dev)
 			      sonic_rda_get(dev, lp->eol_rx, SONIC_RD_LINK));
 		lp->eol_rx = prev_entry;
 	}
+
+	if (rbe)
+		SONIC_WRITE(SONIC_ISR, SONIC_INT_RBE);
 }
 
 
@@ -669,15 +701,10 @@ static int sonic_init(struct net_device *dev)
 	}
 
 	/* initialize all RRA registers */
-	lp->rra_end = (lp->rra_laddr + SONIC_NUM_RRS * SIZEOF_SONIC_RR *
-					SONIC_BUS_SCALE(lp->dma_bitmode)) & 0xffff;
-	lp->cur_rwp = (lp->rra_laddr + (SONIC_NUM_RRS - 1) * SIZEOF_SONIC_RR *
-					SONIC_BUS_SCALE(lp->dma_bitmode)) & 0xffff;
-
-	SONIC_WRITE(SONIC_RSA, lp->rra_laddr & 0xffff);
-	SONIC_WRITE(SONIC_REA, lp->rra_end);
-	SONIC_WRITE(SONIC_RRP, lp->rra_laddr & 0xffff);
-	SONIC_WRITE(SONIC_RWP, lp->cur_rwp);
+	SONIC_WRITE(SONIC_RSA, sonic_rr_addr(dev, 0));
+	SONIC_WRITE(SONIC_REA, sonic_rr_addr(dev, SONIC_NUM_RRS));
+	SONIC_WRITE(SONIC_RRP, sonic_rr_addr(dev, 0));
+	SONIC_WRITE(SONIC_RWP, sonic_rr_addr(dev, SONIC_NUM_RRS - 1));
 	SONIC_WRITE(SONIC_URRA, lp->rra_laddr >> 16);
 	SONIC_WRITE(SONIC_EOBC, (SONIC_RBSIZE >> 1) - (lp->dma_bitmode ? 2 : 1));
 
diff --git a/drivers/net/ethernet/natsemi/sonic.h b/drivers/net/ethernet/natsemi/sonic.h
index 46052a0cfe22..61f253be92a0 100644
--- a/drivers/net/ethernet/natsemi/sonic.h
+++ b/drivers/net/ethernet/natsemi/sonic.h
@@ -314,8 +314,6 @@ struct sonic_local {
 	u32 rda_laddr;              /* logical DMA address of RDA */
 	dma_addr_t rx_laddr[SONIC_NUM_RRS]; /* logical DMA addresses of rx skbuffs */
 	dma_addr_t tx_laddr[SONIC_NUM_TDS]; /* logical DMA addresses of tx skbuffs */
-	unsigned int rra_end;
-	unsigned int cur_rwp;
 	unsigned int cur_rx;
 	unsigned int cur_tx;           /* first unacked transmit packet */
 	unsigned int eol_rx;
@@ -449,6 +447,22 @@ static inline __u16 sonic_rra_get(struct net_device* dev, int entry,
 			     (entry * SIZEOF_SONIC_RR) + offset);
 }
 
+static inline u16 sonic_rr_addr(struct net_device *dev, int entry)
+{
+	struct sonic_local *lp = netdev_priv(dev);
+
+	return lp->rra_laddr +
+	       entry * SIZEOF_SONIC_RR * SONIC_BUS_SCALE(lp->dma_bitmode);
+}
+
+static inline u16 sonic_rr_entry(struct net_device *dev, u16 addr)
+{
+	struct sonic_local *lp = netdev_priv(dev);
+
+	return (addr - (u16)lp->rra_laddr) / (SIZEOF_SONIC_RR *
+					      SONIC_BUS_SCALE(lp->dma_bitmode));
+}
+
 static const char version[] =
     "sonic.c:v0.92 20.9.98 tsbogend@alpha.franken.de\n";
 
-- 
2.24.1

