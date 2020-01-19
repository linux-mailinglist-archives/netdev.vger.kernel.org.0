Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9A51420C0
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 00:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbgASXQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 18:16:48 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49832 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729052AbgASXQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 18:16:33 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id 6794529984; Sun, 19 Jan 2020 18:16:31 -0500 (EST)
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <8bb5d688c698c99c0d354db6f5009f9580786631.1579474569.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1579474569.git.fthain@telegraphics.com.au>
References: <cover.1579474569.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net 14/19] net/sonic: Improve receive descriptor status flag
 check
Date:   Mon, 20 Jan 2020 09:56:09 +1100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After sonic_tx_timeout() calls sonic_init(), it can happen that
sonic_rx() will subsequently encounter a receive descriptor with no
flags set. Remove the comment that says that this can't happen.

When giving a receive descriptor to the SONIC, clear the descriptor
status field. That way, any rx descriptor with flags set can only be
a newly received packet.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/net/ethernet/natsemi/sonic.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index 56098557a579..5db107b8c6ee 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -465,7 +465,6 @@ static inline int index_from_addr(struct sonic_local *lp, dma_addr_t addr,
 static void sonic_rx(struct net_device *dev)
 {
 	struct sonic_local *lp = netdev_priv(dev);
-	int status;
 	int entry = lp->cur_rx;
 	int prev_entry = lp->eol_rx;
 
@@ -476,9 +475,11 @@ static void sonic_rx(struct net_device *dev)
 		u16 bufadr_l;
 		u16 bufadr_h;
 		int pkt_len;
+		u16 status = sonic_rda_get(dev, entry, SONIC_RD_STATUS);
+
+		/* If the RD has LPKT set, the chip has finished with the RB */
 
-		status = sonic_rda_get(dev, entry, SONIC_RD_STATUS);
-		if (status & SONIC_RCR_PRX) {
+		if ((status & SONIC_RCR_PRX) && (status & SONIC_RCR_LPKT)) {
 			u32 addr = (sonic_rda_get(dev, entry,
 						  SONIC_RD_PKTPTR_H) << 16) |
 				   sonic_rda_get(dev, entry, SONIC_RD_PKTPTR_L);
@@ -526,10 +527,6 @@ static void sonic_rx(struct net_device *dev)
 			bufadr_h = (unsigned long)new_laddr >> 16;
 			sonic_rra_put(dev, i, SONIC_RR_BUFADR_L, bufadr_l);
 			sonic_rra_put(dev, i, SONIC_RR_BUFADR_H, bufadr_h);
-		} else {
-			/* This should only happen, if we enable accepting broken packets. */
-		}
-		if (status & SONIC_RCR_LPKT) {
 			/*
 			 * this was the last packet out of the current receive buffer
 			 * give the buffer back to the SONIC
@@ -542,12 +539,11 @@ static void sonic_rx(struct net_device *dev)
 					  __func__);
 				SONIC_WRITE(SONIC_ISR, SONIC_INT_RBE); /* clear the flag */
 			}
-		} else
-			printk(KERN_ERR "%s: rx desc without RCR_LPKT. Shouldn't happen !?\n",
-			     dev->name);
+		}
 		/*
 		 * give back the descriptor
 		 */
+		sonic_rda_put(dev, entry, SONIC_RD_STATUS, 0);
 		sonic_rda_put(dev, entry, SONIC_RD_IN_USE, 1);
 
 		prev_entry = entry;
-- 
2.24.1

