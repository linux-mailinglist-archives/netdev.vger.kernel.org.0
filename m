Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8101446FD
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 23:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgAUWKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 17:10:36 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:44726 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728205AbgAUWKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 17:10:36 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id 0A88F29986; Tue, 21 Jan 2020 17:10:36 -0500 (EST)
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <e18e30216a9ef02c661266182dd40d12bdd0c134.1579641728.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1579641728.git.fthain@telegraphics.com.au>
References: <cover.1579641728.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net v2 02/12] net/sonic: Clear interrupt flags immediately
Date:   Wed, 22 Jan 2020 08:22:08 +1100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The chip can change a packet's descriptor status flags at any time.
However, an active interrupt flag gets cleared rather late. This
allows a race condition that could theoretically lose an interrupt.
Fix this by clearing asserted interrupt flags immediately.

Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/net/ethernet/natsemi/sonic.c | 28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index 9e99ba57f86a..a2e1d06ebf9f 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -299,10 +299,11 @@ static irqreturn_t sonic_interrupt(int irq, void *dev_id)
 	}
 
 	do {
+		SONIC_WRITE(SONIC_ISR, status); /* clear the interrupt(s) */
+
 		if (status & SONIC_INT_PKTRX) {
 			netif_dbg(lp, intr, dev, "%s: packet rx\n", __func__);
 			sonic_rx(dev);	/* got packet(s) */
-			SONIC_WRITE(SONIC_ISR, SONIC_INT_PKTRX); /* clear the interrupt */
 		}
 
 		if (status & SONIC_INT_TXDN) {
@@ -357,7 +358,6 @@ static irqreturn_t sonic_interrupt(int irq, void *dev_id)
 			if (freed_some || lp->tx_skb[entry] == NULL)
 				netif_wake_queue(dev);  /* The ring is no longer full */
 			lp->cur_tx = entry;
-			SONIC_WRITE(SONIC_ISR, SONIC_INT_TXDN); /* clear the interrupt */
 		}
 
 		/*
@@ -367,42 +367,31 @@ static irqreturn_t sonic_interrupt(int irq, void *dev_id)
 			netif_dbg(lp, rx_err, dev, "%s: rx fifo overrun\n",
 				  __func__);
 			lp->stats.rx_fifo_errors++;
-			SONIC_WRITE(SONIC_ISR, SONIC_INT_RFO); /* clear the interrupt */
 		}
 		if (status & SONIC_INT_RDE) {
 			netif_dbg(lp, rx_err, dev, "%s: rx descriptors exhausted\n",
 				  __func__);
 			lp->stats.rx_dropped++;
-			SONIC_WRITE(SONIC_ISR, SONIC_INT_RDE); /* clear the interrupt */
 		}
 		if (status & SONIC_INT_RBAE) {
 			netif_dbg(lp, rx_err, dev, "%s: rx buffer area exceeded\n",
 				  __func__);
 			lp->stats.rx_dropped++;
-			SONIC_WRITE(SONIC_ISR, SONIC_INT_RBAE); /* clear the interrupt */
 		}
 
 		/* counter overruns; all counters are 16bit wide */
-		if (status & SONIC_INT_FAE) {
+		if (status & SONIC_INT_FAE)
 			lp->stats.rx_frame_errors += 65536;
-			SONIC_WRITE(SONIC_ISR, SONIC_INT_FAE); /* clear the interrupt */
-		}
-		if (status & SONIC_INT_CRC) {
+		if (status & SONIC_INT_CRC)
 			lp->stats.rx_crc_errors += 65536;
-			SONIC_WRITE(SONIC_ISR, SONIC_INT_CRC); /* clear the interrupt */
-		}
-		if (status & SONIC_INT_MP) {
+		if (status & SONIC_INT_MP)
 			lp->stats.rx_missed_errors += 65536;
-			SONIC_WRITE(SONIC_ISR, SONIC_INT_MP); /* clear the interrupt */
-		}
 
 		/* transmit error */
-		if (status & SONIC_INT_TXER) {
+		if (status & SONIC_INT_TXER)
 			if (SONIC_READ(SONIC_TCR) & SONIC_TCR_FU)
 				netif_dbg(lp, tx_err, dev, "%s: tx fifo underrun\n",
 					  __func__);
-			SONIC_WRITE(SONIC_ISR, SONIC_INT_TXER); /* clear the interrupt */
-		}
 
 		/* bus retry */
 		if (status & SONIC_INT_BR) {
@@ -411,13 +400,8 @@ static irqreturn_t sonic_interrupt(int irq, void *dev_id)
 			/* ... to help debug DMA problems causing endless interrupts. */
 			/* Bounce the eth interface to turn on the interrupt again. */
 			SONIC_WRITE(SONIC_IMR, 0);
-			SONIC_WRITE(SONIC_ISR, SONIC_INT_BR); /* clear the interrupt */
 		}
 
-		/* load CAM done */
-		if (status & SONIC_INT_LCD)
-			SONIC_WRITE(SONIC_ISR, SONIC_INT_LCD); /* clear the interrupt */
-
 		status = SONIC_READ(SONIC_ISR) & SONIC_IMR_DEFAULT;
 	} while (status);
 
-- 
2.24.1

