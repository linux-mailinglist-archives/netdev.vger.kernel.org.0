Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45F6A160096
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 22:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgBOVSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 16:18:04 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:34950 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727668AbgBOVSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 16:18:03 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id EE9C429B31; Sat, 15 Feb 2020 16:18:01 -0500 (EST)
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <c245a8b67448c7395244df97d53c68ca789eff85.1581800613.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1581800613.git.fthain@telegraphics.com.au>
References: <cover.1581800613.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net-next 6/7] net/sonic: Start packet transmission immediately
Date:   Sun, 16 Feb 2020 08:03:32 +1100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Give the transmit command as soon as the transmit descriptor is ready.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/net/ethernet/natsemi/sonic.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index 508c6a80fc6e..dd3605aa5f23 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -311,12 +311,17 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 	sonic_tda_put(dev, entry, SONIC_TD_LINK,
 		sonic_tda_get(dev, entry, SONIC_TD_LINK) | SONIC_EOL);
 
+	sonic_tda_put(dev, lp->eol_tx, SONIC_TD_LINK, ~SONIC_EOL &
+		      sonic_tda_get(dev, lp->eol_tx, SONIC_TD_LINK));
+
+	netif_dbg(lp, tx_queued, dev, "%s: issuing Tx command\n", __func__);
+
+	SONIC_WRITE(SONIC_CMD, SONIC_CR_TXP);
+
 	lp->tx_len[entry] = length;
 	lp->tx_laddr[entry] = laddr;
 	lp->tx_skb[entry] = skb;
 
-	sonic_tda_put(dev, lp->eol_tx, SONIC_TD_LINK,
-				  sonic_tda_get(dev, lp->eol_tx, SONIC_TD_LINK) & ~SONIC_EOL);
 	lp->eol_tx = entry;
 
 	entry = (entry + 1) & SONIC_TDS_MASK;
@@ -327,10 +332,6 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 		/* after this packet, wait for ISR to free up some TDAs */
 	}
 
-	netif_dbg(lp, tx_queued, dev, "%s: issuing Tx command\n", __func__);
-
-	SONIC_WRITE(SONIC_CMD, SONIC_CR_TXP);
-
 	spin_unlock_irqrestore(&lp->lock, flags);
 
 	return NETDEV_TX_OK;
-- 
2.24.1

