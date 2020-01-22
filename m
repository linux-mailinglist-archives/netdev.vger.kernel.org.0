Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51840145E87
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 23:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbgAVWYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 17:24:03 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:47896 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgAVWYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 17:24:02 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id 95746299BB; Wed, 22 Jan 2020 17:23:59 -0500 (EST)
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <36024a80d3f0428430752ce1428b7dc3e6f19f9e.1579730846.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1579730846.git.fthain@telegraphics.com.au>
References: <cover.1579730846.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net v3 06/12] net/sonic: Avoid needless receive descriptor EOL
 flag updates
Date:   Thu, 23 Jan 2020 09:07:26 +1100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The while loop in sonic_rx() traverses the rx descriptor ring. It stops
when it reaches a descriptor that the SONIC has not used. Each iteration
advances the EOL flag so the SONIC can keep using more descriptors.
Therefore, the while loop has no definite termination condition.

The algorithm described in the National Semiconductor literature is quite
different. It consumes descriptors up to the one with its EOL flag set
(which will also have its "in use" flag set). All freed descriptors are
then returned to the ring at once, by adjusting the EOL flags (and link
pointers).

Adopt the algorithm from datasheet as it's simpler, terminates quickly
and avoids a lot of pointless descriptor EOL flag changes.

Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/net/ethernet/natsemi/sonic.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index c666bbf15116..2cee702f49b8 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -436,6 +436,7 @@ static void sonic_rx(struct net_device *dev)
 	struct sonic_local *lp = netdev_priv(dev);
 	int status;
 	int entry = lp->cur_rx;
+	int prev_entry = lp->eol_rx;
 
 	while (sonic_rda_get(dev, entry, SONIC_RD_IN_USE) == 0) {
 		struct sk_buff *used_skb;
@@ -516,13 +517,21 @@ static void sonic_rx(struct net_device *dev)
 		/*
 		 * give back the descriptor
 		 */
-		sonic_rda_put(dev, entry, SONIC_RD_LINK,
-			sonic_rda_get(dev, entry, SONIC_RD_LINK) | SONIC_EOL);
 		sonic_rda_put(dev, entry, SONIC_RD_IN_USE, 1);
-		sonic_rda_put(dev, lp->eol_rx, SONIC_RD_LINK,
-			sonic_rda_get(dev, lp->eol_rx, SONIC_RD_LINK) & ~SONIC_EOL);
-		lp->eol_rx = entry;
-		lp->cur_rx = entry = (entry + 1) & SONIC_RDS_MASK;
+
+		prev_entry = entry;
+		entry = (entry + 1) & SONIC_RDS_MASK;
+	}
+
+	lp->cur_rx = entry;
+
+	if (prev_entry != lp->eol_rx) {
+		/* Advance the EOL flag to put descriptors back into service */
+		sonic_rda_put(dev, prev_entry, SONIC_RD_LINK, SONIC_EOL |
+			      sonic_rda_get(dev, prev_entry, SONIC_RD_LINK));
+		sonic_rda_put(dev, lp->eol_rx, SONIC_RD_LINK, ~SONIC_EOL &
+			      sonic_rda_get(dev, lp->eol_rx, SONIC_RD_LINK));
+		lp->eol_rx = prev_entry;
 	}
 	/*
 	 * If any worth-while packets have been received, netif_rx()
-- 
2.24.1

