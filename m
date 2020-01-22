Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCBA145E8A
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 23:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgAVWYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 17:24:40 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:47910 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbgAVWYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 17:24:03 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id E6E0B299BE; Wed, 22 Jan 2020 17:23:59 -0500 (EST)
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <071a456ba88517a7d02b1eab29469efde6e55849.1579730846.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1579730846.git.fthain@telegraphics.com.au>
References: <cover.1579730846.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net v3 10/12] net/sonic: Fix command register usage
Date:   Thu, 23 Jan 2020 09:07:26 +1100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several issues relating to command register usage during
chip initialization.

Firstly, the SONIC sometimes comes out of software reset with the
Start Timer bit set. This gets logged as,

    macsonic macsonic eth0: sonic_init: status=24, i=101

Avoid this by giving the Stop Timer command earlier than later.

Secondly, the loop that waits for the Read RRA command to complete has
the break condition inverted. That's why the for loop iterates until
its termination condition. Call the helper for this instead.

Finally, give the Receiver Enable command after clearing interrupts,
not before, to avoid the possibility of losing an interrupt.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/net/ethernet/natsemi/sonic.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index 42a6b87d8886..914cec2ccc28 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -664,7 +664,6 @@ static void sonic_multicast_list(struct net_device *dev)
  */
 static int sonic_init(struct net_device *dev)
 {
-	unsigned int cmd;
 	struct sonic_local *lp = netdev_priv(dev);
 	int i;
 
@@ -681,7 +680,7 @@ static int sonic_init(struct net_device *dev)
 	 * enable interrupts, then completely initialize the SONIC
 	 */
 	SONIC_WRITE(SONIC_CMD, 0);
-	SONIC_WRITE(SONIC_CMD, SONIC_CR_RXDIS);
+	SONIC_WRITE(SONIC_CMD, SONIC_CR_RXDIS | SONIC_CR_STP);
 	sonic_quiesce(dev, SONIC_CR_ALL);
 
 	/*
@@ -711,14 +710,7 @@ static int sonic_init(struct net_device *dev)
 	netif_dbg(lp, ifup, dev, "%s: issuing RRRA command\n", __func__);
 
 	SONIC_WRITE(SONIC_CMD, SONIC_CR_RRRA);
-	i = 0;
-	while (i++ < 100) {
-		if (SONIC_READ(SONIC_CMD) & SONIC_CR_RRRA)
-			break;
-	}
-
-	netif_dbg(lp, ifup, dev, "%s: status=%x, i=%d\n", __func__,
-		  SONIC_READ(SONIC_CMD), i);
+	sonic_quiesce(dev, SONIC_CR_RRRA);
 
 	/*
 	 * Initialize the receive descriptors so that they
@@ -806,15 +798,11 @@ static int sonic_init(struct net_device *dev)
 	 * enable receiver, disable loopback
 	 * and enable all interrupts
 	 */
-	SONIC_WRITE(SONIC_CMD, SONIC_CR_RXEN | SONIC_CR_STP);
 	SONIC_WRITE(SONIC_RCR, SONIC_RCR_DEFAULT);
 	SONIC_WRITE(SONIC_TCR, SONIC_TCR_DEFAULT);
 	SONIC_WRITE(SONIC_ISR, 0x7fff);
 	SONIC_WRITE(SONIC_IMR, SONIC_IMR_DEFAULT);
-
-	cmd = SONIC_READ(SONIC_CMD);
-	if ((cmd & SONIC_CR_RXEN) == 0 || (cmd & SONIC_CR_STP) == 0)
-		printk(KERN_ERR "sonic_init: failed, status=%x\n", cmd);
+	SONIC_WRITE(SONIC_CMD, SONIC_CR_RXEN);
 
 	netif_dbg(lp, ifup, dev, "%s: new status=%x\n", __func__,
 		  SONIC_READ(SONIC_CMD));
-- 
2.24.1

