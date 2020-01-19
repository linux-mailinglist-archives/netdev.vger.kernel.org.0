Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 648E71420D9
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 00:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbgASXSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 18:18:05 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49810 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729014AbgASXQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 18:16:32 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id 4DDF429980; Sun, 19 Jan 2020 18:16:31 -0500 (EST)
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <0e2a77f40f47ce7a5fcc66f86014b880968a88cd.1579474569.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1579474569.git.fthain@telegraphics.com.au>
References: <cover.1579474569.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net 11/19] net/sonic: Fix interface error stats collection
Date:   Mon, 20 Jan 2020 09:56:09 +1100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tx_aborted_errors statistic should count packets flagged with EXD,
EXC, FU, or BCM bits because those bits denote an aborted transmission.
That corresponds to the bitmask 0x0446, not 0x0642. Use macros for these
constants to avoid mistakes. Better to leave out FIFO Underruns (FU) as
there's a separate counter for that purpose.

Don't lump all these errors in with the general tx_errors counter as
that's used for tx timeout events.

On the rx side, don't count RDE and RBAE interrupts as dropped packets.
These interrupts don't indicate a lost packet, just a lack of resources.
When a lack of resources results in a lost packet, this gets reported
in the rx_missed_errors counter (along with RFO events).

Don't double-count rx_frame_errors and rx_crc_errors.

Don't use the general rx_errors counter for events that already have
special counters.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/net/ethernet/natsemi/sonic.c | 21 +++++++--------------
 drivers/net/ethernet/natsemi/sonic.h |  1 +
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index 6660bd75b699..ea74c3c2c501 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -360,18 +360,19 @@ static irqreturn_t sonic_interrupt(int irq, void *dev_id)
 				if ((td_status = sonic_tda_get(dev, entry, SONIC_TD_STATUS)) == 0)
 					break;
 
-				if (td_status & 0x0001) {
+				if (td_status & SONIC_TCR_PTX) {
 					lp->stats.tx_packets++;
 					lp->stats.tx_bytes += sonic_tda_get(dev, entry, SONIC_TD_PKTSIZE);
 				} else {
-					lp->stats.tx_errors++;
-					if (td_status & 0x0642)
+					if (td_status & (SONIC_TCR_EXD |
+					    SONIC_TCR_EXC | SONIC_TCR_BCM))
 						lp->stats.tx_aborted_errors++;
-					if (td_status & 0x0180)
+					if (td_status &
+					    (SONIC_TCR_NCRS | SONIC_TCR_CRLS))
 						lp->stats.tx_carrier_errors++;
-					if (td_status & 0x0020)
+					if (td_status & SONIC_TCR_OWC)
 						lp->stats.tx_window_errors++;
-					if (td_status & 0x0004)
+					if (td_status & SONIC_TCR_FU)
 						lp->stats.tx_fifo_errors++;
 				}
 
@@ -401,17 +402,14 @@ static irqreturn_t sonic_interrupt(int irq, void *dev_id)
 		if (status & SONIC_INT_RFO) {
 			netif_dbg(lp, rx_err, dev, "%s: rx fifo overrun\n",
 				  __func__);
-			lp->stats.rx_fifo_errors++;
 		}
 		if (status & SONIC_INT_RDE) {
 			netif_dbg(lp, rx_err, dev, "%s: rx descriptors exhausted\n",
 				  __func__);
-			lp->stats.rx_dropped++;
 		}
 		if (status & SONIC_INT_RBAE) {
 			netif_dbg(lp, rx_err, dev, "%s: rx buffer area exceeded\n",
 				  __func__);
-			lp->stats.rx_dropped++;
 		}
 
 		/* counter overruns; all counters are 16bit wide */
@@ -503,11 +501,6 @@ static void sonic_rx(struct net_device *dev)
 			sonic_rra_put(dev, entry, SONIC_RR_BUFADR_H, bufadr_h);
 		} else {
 			/* This should only happen, if we enable accepting broken packets. */
-			lp->stats.rx_errors++;
-			if (status & SONIC_RCR_FAER)
-				lp->stats.rx_frame_errors++;
-			if (status & SONIC_RCR_CRCR)
-				lp->stats.rx_crc_errors++;
 		}
 		if (status & SONIC_RCR_LPKT) {
 			/*
diff --git a/drivers/net/ethernet/natsemi/sonic.h b/drivers/net/ethernet/natsemi/sonic.h
index f4aa1e4159da..227975eb4cb8 100644
--- a/drivers/net/ethernet/natsemi/sonic.h
+++ b/drivers/net/ethernet/natsemi/sonic.h
@@ -175,6 +175,7 @@
 #define SONIC_TCR_NCRS          0x0100
 #define SONIC_TCR_CRLS          0x0080
 #define SONIC_TCR_EXC           0x0040
+#define SONIC_TCR_OWC           0x0020
 #define SONIC_TCR_PMB           0x0008
 #define SONIC_TCR_FU            0x0004
 #define SONIC_TCR_BCM           0x0002
-- 
2.24.1

