Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C07D1600A2
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 22:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbgBOVS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 16:18:29 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:34906 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbgBOVSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 16:18:02 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id D1EA229B2E; Sat, 15 Feb 2020 16:18:01 -0500 (EST)
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <aab0449ddb0bc15bce268f86d0b2ee7afb0e49c6.1581800613.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1581800613.git.fthain@telegraphics.com.au>
References: <cover.1581800613.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net-next 4/7] net/sonic: Remove redundant netif_start_queue()
 call
Date:   Sun, 16 Feb 2020 08:03:32 +1100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The transmit queue must be running already otherwise sonic_send_packet()
would not have been called. If the queue was stopped by the interrupt
handler, the interrupt handler will restart it again.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/net/ethernet/natsemi/sonic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index 9ecdd67e1410..1d6de6706875 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -327,7 +327,7 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 		netif_dbg(lp, tx_queued, dev, "%s: stopping queue\n", __func__);
 		netif_stop_queue(dev);
 		/* after this packet, wait for ISR to free up some TDAs */
-	} else netif_start_queue(dev);
+	}
 
 	netif_dbg(lp, tx_queued, dev, "%s: issuing Tx command\n", __func__);
 
-- 
2.24.1

