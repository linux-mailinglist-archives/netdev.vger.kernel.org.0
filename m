Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53DF9145E85
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 23:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgAVWYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 17:24:30 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:47894 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgAVWYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 17:24:03 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id 7EC5D299AA; Wed, 22 Jan 2020 17:23:59 -0500 (EST)
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <02f71a07f0194f3020f4ed8f8456e2c2c4c6a685.1579730846.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1579730846.git.fthain@telegraphics.com.au>
References: <cover.1579730846.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net v3 05/12] net/sonic: Fix receive buffer handling
Date:   Thu, 23 Jan 2020 09:07:26 +1100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SONIC can sometimes advance its rx buffer pointer (RRP register)
without advancing its rx descriptor pointer (CRDA register). As a result
the index of the current rx descriptor may not equal that of the current
rx buffer. The driver mistakenly assumes that they are always equal.
This assumption leads to incorrect packet lengths and possible packet
duplication. Avoid this by calling a new function to locate the buffer
corresponding to a given descriptor.

Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
Changed since v2:
 - Removed 'inline' keyword.
 - Removed blank line.
---
 drivers/net/ethernet/natsemi/sonic.c | 35 ++++++++++++++++++++++++----
 drivers/net/ethernet/natsemi/sonic.h |  5 ++--
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index b31c7af32dfa..c666bbf15116 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -413,6 +413,21 @@ static irqreturn_t sonic_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+/* Return the array index corresponding to a given Receive Buffer pointer. */
+static int index_from_addr(struct sonic_local *lp, dma_addr_t addr,
+			   unsigned int last)
+{
+	unsigned int i = last;
+
+	do {
+		i = (i + 1) & SONIC_RRS_MASK;
+		if (addr == lp->rx_laddr[i])
+			return i;
+	} while (i != last);
+
+	return -ENOENT;
+}
+
 /*
  * We have a good packet(s), pass it/them up the network stack.
  */
@@ -432,6 +447,16 @@ static void sonic_rx(struct net_device *dev)
 
 		status = sonic_rda_get(dev, entry, SONIC_RD_STATUS);
 		if (status & SONIC_RCR_PRX) {
+			u32 addr = (sonic_rda_get(dev, entry,
+						  SONIC_RD_PKTPTR_H) << 16) |
+				   sonic_rda_get(dev, entry, SONIC_RD_PKTPTR_L);
+			int i = index_from_addr(lp, addr, entry);
+
+			if (i < 0) {
+				WARN_ONCE(1, "failed to find buffer!\n");
+				break;
+			}
+
 			/* Malloc up new buffer. */
 			new_skb = netdev_alloc_skb(dev, SONIC_RBSIZE + 2);
 			if (new_skb == NULL) {
@@ -453,7 +478,7 @@ static void sonic_rx(struct net_device *dev)
 
 			/* now we have a new skb to replace it, pass the used one up the stack */
 			dma_unmap_single(lp->device, lp->rx_laddr[entry], SONIC_RBSIZE, DMA_FROM_DEVICE);
-			used_skb = lp->rx_skb[entry];
+			used_skb = lp->rx_skb[i];
 			pkt_len = sonic_rda_get(dev, entry, SONIC_RD_PKTLEN);
 			skb_trim(used_skb, pkt_len);
 			used_skb->protocol = eth_type_trans(used_skb, dev);
@@ -462,13 +487,13 @@ static void sonic_rx(struct net_device *dev)
 			lp->stats.rx_bytes += pkt_len;
 
 			/* and insert the new skb */
-			lp->rx_laddr[entry] = new_laddr;
-			lp->rx_skb[entry] = new_skb;
+			lp->rx_laddr[i] = new_laddr;
+			lp->rx_skb[i] = new_skb;
 
 			bufadr_l = (unsigned long)new_laddr & 0xffff;
 			bufadr_h = (unsigned long)new_laddr >> 16;
-			sonic_rra_put(dev, entry, SONIC_RR_BUFADR_L, bufadr_l);
-			sonic_rra_put(dev, entry, SONIC_RR_BUFADR_H, bufadr_h);
+			sonic_rra_put(dev, i, SONIC_RR_BUFADR_L, bufadr_l);
+			sonic_rra_put(dev, i, SONIC_RR_BUFADR_H, bufadr_h);
 		} else {
 			/* This should only happen, if we enable accepting broken packets. */
 		}
diff --git a/drivers/net/ethernet/natsemi/sonic.h b/drivers/net/ethernet/natsemi/sonic.h
index 9e4ff8dd032d..e6d47e45c5c2 100644
--- a/drivers/net/ethernet/natsemi/sonic.h
+++ b/drivers/net/ethernet/natsemi/sonic.h
@@ -275,8 +275,9 @@
 #define SONIC_NUM_RDS   SONIC_NUM_RRS /* number of receive descriptors */
 #define SONIC_NUM_TDS   16            /* number of transmit descriptors */
 
-#define SONIC_RDS_MASK  (SONIC_NUM_RDS-1)
-#define SONIC_TDS_MASK  (SONIC_NUM_TDS-1)
+#define SONIC_RRS_MASK  (SONIC_NUM_RRS - 1)
+#define SONIC_RDS_MASK  (SONIC_NUM_RDS - 1)
+#define SONIC_TDS_MASK  (SONIC_NUM_TDS - 1)
 
 #define SONIC_RBSIZE	1520          /* size of one resource buffer */
 
-- 
2.24.1

