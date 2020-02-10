Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCA0B1584C0
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 22:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbgBJV1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 16:27:12 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:59762 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbgBJV0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 16:26:50 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id 50EA929B53; Mon, 10 Feb 2020 16:26:48 -0500 (EST)
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <dfc072d93a97b794235bc43a6c2c8c81f0b9de50.1581369531.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1581369530.git.fthain@telegraphics.com.au>
References: <cover.1581369530.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net-next 7/7] net/macsonic: Remove interrupt handler wrapper
Date:   Tue, 11 Feb 2020 08:18:50 +1100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On m68k, local irqs remain enabled while interrupt handlers execute.
Therefore the macsonic driver has had to disable interrupts to avoid
re-entering sonic_interrupt().

As of commit 865ad2f2201d ("net/sonic: Add mutual exclusion for accessing
shared state"), sonic_interrupt() became re-entrant, and its wrapper
became redundant.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/net/ethernet/natsemi/macsonic.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/macsonic.c b/drivers/net/ethernet/natsemi/macsonic.c
index 0f4d0c25d626..1b5559aacb38 100644
--- a/drivers/net/ethernet/natsemi/macsonic.c
+++ b/drivers/net/ethernet/natsemi/macsonic.c
@@ -114,17 +114,6 @@ static inline void bit_reverse_addr(unsigned char addr[6])
 		addr[i] = bitrev8(addr[i]);
 }
 
-static irqreturn_t macsonic_interrupt(int irq, void *dev_id)
-{
-	irqreturn_t result;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	result = sonic_interrupt(irq, dev_id);
-	local_irq_restore(flags);
-	return result;
-}
-
 static int macsonic_open(struct net_device* dev)
 {
 	int retval;
@@ -135,12 +124,12 @@ static int macsonic_open(struct net_device* dev)
 				dev->name, dev->irq);
 		goto err;
 	}
-	/* Under the A/UX interrupt scheme, the onboard SONIC interrupt comes
-	 * in at priority level 3. However, we sometimes get the level 2 inter-
-	 * rupt as well, which must prevent re-entrance of the sonic handler.
+	/* Under the A/UX interrupt scheme, the onboard SONIC interrupt gets
+	 * moved from level 2 to level 3. Unfortunately we still get some
+	 * level 2 interrupts so register the handler for both.
 	 */
 	if (dev->irq == IRQ_AUTO_3) {
-		retval = request_irq(IRQ_NUBUS_9, macsonic_interrupt, 0,
+		retval = request_irq(IRQ_NUBUS_9, sonic_interrupt, 0,
 				     "sonic", dev);
 		if (retval) {
 			printk(KERN_ERR "%s: unable to get IRQ %d.\n",
-- 
2.24.1

