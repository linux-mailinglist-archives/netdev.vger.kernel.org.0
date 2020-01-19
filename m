Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A37081420D1
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 00:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbgASXRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 18:17:38 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49806 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728949AbgASXQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 18:16:32 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id 434B72997F; Sun, 19 Jan 2020 18:16:31 -0500 (EST)
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <031786f4029e93b7df05fddaed34e1faf4c89ad7.1579474569.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1579474569.git.fthain@telegraphics.com.au>
References: <cover.1579474569.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net 10/19] net/sonic: Start packet transmission immediately
Date:   Mon, 20 Jan 2020 09:56:09 +1100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Give the transmit command as soon as the transmit descriptor is ready.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/net/ethernet/natsemi/sonic.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index 6322b4543e0b..6660bd75b699 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -287,12 +287,15 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 	sonic_tda_put(dev, entry, SONIC_TD_LINK,
 		sonic_tda_get(dev, entry, SONIC_TD_LINK) | SONIC_EOL);
 
+	sonic_tda_put(dev, lp->eol_tx, SONIC_TD_LINK, ~SONIC_EOL &
+		      sonic_tda_get(dev, lp->eol_tx, SONIC_TD_LINK));
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
@@ -305,8 +308,6 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 
 	netif_dbg(lp, tx_queued, dev, "%s: issuing Tx command\n", __func__);
 
-	SONIC_WRITE(SONIC_CMD, SONIC_CR_TXP);
-
 	local_irq_restore(flags);
 
 	return NETDEV_TX_OK;
-- 
2.24.1

