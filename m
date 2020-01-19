Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94B771420BC
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 00:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbgASXQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 18:16:32 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49724 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728886AbgASXQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 18:16:31 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id C34032991A; Sun, 19 Jan 2020 18:16:30 -0500 (EST)
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <5057d7da0f23a99fb0945bb26e2a0100e7031e75.1579474569.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1579474569.git.fthain@telegraphics.com.au>
References: <cover.1579474569.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net 02/19] net/sonic: Remove redundant next_tx variable
Date:   Mon, 20 Jan 2020 09:56:09 +1100
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
 drivers/net/ethernet/natsemi/sonic.c | 10 ++++++----
 drivers/net/ethernet/natsemi/sonic.h |  1 -
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index 657b5327baf9..f31cb19ded50 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -215,7 +215,7 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 	struct sonic_local *lp = netdev_priv(dev);
 	dma_addr_t laddr;
 	int length;
-	int entry = lp->next_tx;
+	int entry;
 
 	netif_dbg(lp, tx_queued, dev, "%s: skb=%p\n", __func__, skb);
 
@@ -237,6 +237,8 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_OK;
 	}
 
+	entry = (lp->eol_tx + 1) & SONIC_TDS_MASK;
+
 	sonic_tda_put(dev, entry, SONIC_TD_STATUS, 0);       /* clear status */
 	sonic_tda_put(dev, entry, SONIC_TD_FRAG_COUNT, 1);   /* single fragment */
 	sonic_tda_put(dev, entry, SONIC_TD_PKTSIZE, length); /* length of packet */
@@ -260,8 +262,8 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 				  sonic_tda_get(dev, lp->eol_tx, SONIC_TD_LINK) & ~SONIC_EOL);
 	lp->eol_tx = entry;
 
-	lp->next_tx = (entry + 1) & SONIC_TDS_MASK;
-	if (lp->tx_skb[lp->next_tx] != NULL) {
+	entry = (entry + 1) & SONIC_TDS_MASK;
+	if (lp->tx_skb[entry]) {
 		/* The ring is full, the ISR has yet to process the next TD. */
 		netif_dbg(lp, tx_queued, dev, "%s: stopping queue\n", __func__);
 		netif_stop_queue(dev);
@@ -684,7 +686,7 @@ static int sonic_init(struct net_device *dev)
 
 	SONIC_WRITE(SONIC_UTDA, lp->tda_laddr >> 16);
 	SONIC_WRITE(SONIC_CTDA, lp->tda_laddr & 0xffff);
-	lp->cur_tx = lp->next_tx = 0;
+	lp->cur_tx = 0;
 	lp->eol_tx = SONIC_NUM_TDS - 1;
 
 	/*
diff --git a/drivers/net/ethernet/natsemi/sonic.h b/drivers/net/ethernet/natsemi/sonic.h
index 2b27f7049acb..e402dc29d2aa 100644
--- a/drivers/net/ethernet/natsemi/sonic.h
+++ b/drivers/net/ethernet/natsemi/sonic.h
@@ -318,7 +318,6 @@ struct sonic_local {
 	unsigned int cur_tx;           /* first unacked transmit packet */
 	unsigned int eol_rx;
 	unsigned int eol_tx;           /* last unacked transmit packet */
-	unsigned int next_tx;          /* next free TD */
 	int msg_enable;
 	struct device *device;         /* generic device */
 	struct net_device_stats stats;
-- 
2.24.1

