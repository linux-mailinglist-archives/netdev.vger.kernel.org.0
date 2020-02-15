Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E22A716009D
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 22:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgBOVSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 16:18:03 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:34904 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgBOVSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 16:18:02 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id C667D29B2B; Sat, 15 Feb 2020 16:18:01 -0500 (EST)
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <0adf9819ded56830f460cd1643e9ce013ed33f6d.1581800613.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1581800613.git.fthain@telegraphics.com.au>
References: <cover.1581800613.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net-next 3/7] net/sonic: Remove redundant next_tx variable
Date:   Sun, 16 Feb 2020 08:03:32 +1100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The eol_tx variable is the one that matters to the tx algorithm because
packets are always placed at the end of the list. The next_tx variable
just confuses things so remove it.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/net/ethernet/natsemi/sonic.c | 8 ++++----
 drivers/net/ethernet/natsemi/sonic.h | 1 -
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index c066510b348e..9ecdd67e1410 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -300,7 +300,7 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 
 	spin_lock_irqsave(&lp->lock, flags);
 
-	entry = lp->next_tx;
+	entry = (lp->eol_tx + 1) & SONIC_TDS_MASK;
 
 	sonic_tda_put(dev, entry, SONIC_TD_STATUS, 0);       /* clear status */
 	sonic_tda_put(dev, entry, SONIC_TD_FRAG_COUNT, 1);   /* single fragment */
@@ -321,8 +321,8 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 				  sonic_tda_get(dev, lp->eol_tx, SONIC_TD_LINK) & ~SONIC_EOL);
 	lp->eol_tx = entry;
 
-	lp->next_tx = (entry + 1) & SONIC_TDS_MASK;
-	if (lp->tx_skb[lp->next_tx] != NULL) {
+	entry = (entry + 1) & SONIC_TDS_MASK;
+	if (lp->tx_skb[entry]) {
 		/* The ring is full, the ISR has yet to process the next TD. */
 		netif_dbg(lp, tx_queued, dev, "%s: stopping queue\n", __func__);
 		netif_stop_queue(dev);
@@ -811,7 +811,7 @@ static int sonic_init(struct net_device *dev)
 
 	SONIC_WRITE(SONIC_UTDA, lp->tda_laddr >> 16);
 	SONIC_WRITE(SONIC_CTDA, lp->tda_laddr & 0xffff);
-	lp->cur_tx = lp->next_tx = 0;
+	lp->cur_tx = 0;
 	lp->eol_tx = SONIC_NUM_TDS - 1;
 
 	/*
diff --git a/drivers/net/ethernet/natsemi/sonic.h b/drivers/net/ethernet/natsemi/sonic.h
index 053f12f5cf4a..3cbb62c860c8 100644
--- a/drivers/net/ethernet/natsemi/sonic.h
+++ b/drivers/net/ethernet/natsemi/sonic.h
@@ -321,7 +321,6 @@ struct sonic_local {
 	unsigned int cur_tx;           /* first unacked transmit packet */
 	unsigned int eol_rx;
 	unsigned int eol_tx;           /* last unacked transmit packet */
-	unsigned int next_tx;          /* next free TD */
 	int msg_enable;
 	struct device *device;         /* generic device */
 	struct net_device_stats stats;
-- 
2.24.1

