Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6231420B6
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 00:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbgASXQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 18:16:50 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49798 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728934AbgASXQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 18:16:33 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id 1FD2829970; Sun, 19 Jan 2020 18:16:31 -0500 (EST)
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <21b148324c22ff4d5c730c3a2ec29bd07beb4fe8.1579474569.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1579474569.git.fthain@telegraphics.com.au>
References: <cover.1579474569.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net 07/19] net/sonic: Clear interrupt flags immediately
Date:   Mon, 20 Jan 2020 09:56:09 +1100
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
index 84a30928d4e2..2cde692a0602 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -335,10 +335,11 @@ static irqreturn_t sonic_interrupt(int irq, void *dev_id)
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
@@ -393,7 +394,6 @@ static irqreturn_t sonic_interrupt(int irq, void *dev_id)
 			if (freed_some || lp->tx_skb[entry] == NULL)
 				netif_wake_queue(dev);  /* The ring is no longer full */
 			lp->cur_tx = entry;
-			SONIC_WRITE(SONIC_ISR, SONIC_INT_TXDN); /* clear the interrupt */
 		}
 
 		/*
@@ -403,42 +403,31 @@ static irqreturn_t sonic_interrupt(int irq, void *dev_id)
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
@@ -447,13 +436,8 @@ static irqreturn_t sonic_interrupt(int irq, void *dev_id)
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

