Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3609E1420CC
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 00:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbgASXR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 18:17:28 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49838 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729061AbgASXQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 18:16:33 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id A5644299A7; Sun, 19 Jan 2020 18:16:31 -0500 (EST)
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <43f9cf226bd227cfdbcc94512d6f9dc02e84ccf7.1579474569.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1579474569.git.fthain@telegraphics.com.au>
References: <cover.1579474569.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net 19/19] net/sonic: Prevent tx watchdog timeout
Date:   Mon, 20 Jan 2020 09:56:09 +1100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Section 5.5.3.2 of the datasheet says,

    If FIFO Underrun, Byte Count Mismatch, Excessive Collision, or
    Excessive Deferral (if enabled) errors occur, transmission ceases.

In this situation, the chip asserts a TXER interrupt rather than TXDN.
But the handler for the TXDN is the only way that the transmit queue
gets restarted. Hence, an aborted transmission can result in a watchdog
timeout.

This problem can be reproduced on congested link, as that can result in
excessive transmitter collisions. Another way to reproduce this is with
a FIFO Underrun, which may be caused by DMA latency.

In event of a TXER interrupt, prevent a watchdog timeout by restarting
transmission.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/net/ethernet/natsemi/sonic.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index 1a569df63fde..bebdbb00a595 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -446,10 +446,19 @@ static irqreturn_t sonic_interrupt(int irq, void *dev_id)
 			lp->stats.rx_missed_errors += 65536;
 
 		/* transmit error */
-		if (status & SONIC_INT_TXER)
-			if (SONIC_READ(SONIC_TCR) & SONIC_TCR_FU)
-				netif_dbg(lp, tx_err, dev, "%s: tx fifo underrun\n",
-					  __func__);
+		if (status & SONIC_INT_TXER) {
+			u16 tcr = SONIC_READ(SONIC_TCR);
+
+			netif_dbg(lp, tx_err, dev, "%s: TXER intr, TCR %04x\n",
+				  __func__, tcr);
+
+			if (tcr & (SONIC_TCR_EXD | SONIC_TCR_EXC |
+				   SONIC_TCR_FU | SONIC_TCR_BCM)) {
+				/* Aborted transmission. Try again. */
+				netif_stop_queue(dev);
+				SONIC_WRITE(SONIC_CMD, SONIC_CR_TXP);
+			}
+		}
 
 		/* bus retry */
 		if (status & SONIC_INT_BR) {
-- 
2.24.1

