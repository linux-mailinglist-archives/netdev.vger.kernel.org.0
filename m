Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5E94A33C9
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 11:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbfH3JZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 05:25:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:41792 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728152AbfH3JZ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 05:25:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DF4C9AF50;
        Fri, 30 Aug 2019 09:25:54 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 net-next 06/15] net: sgi: ioc3-eth: get rid of ioc3_clean_rx_ring()
Date:   Fri, 30 Aug 2019 11:25:29 +0200
Message-Id: <20190830092539.24550-7-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190830092539.24550-1-tbogendoerfer@suse.de>
References: <20190830092539.24550-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move clearing of the descriptor valid bit into ioc3_alloc_rings. This
makes ioc3_clean_rx_ring obsolete.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index e84239734338..fe77e4d7732f 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -761,26 +761,6 @@ static void ioc3_mii_start(struct ioc3_private *ip)
 	add_timer(&ip->ioc3_timer);
 }
 
-static inline void ioc3_clean_rx_ring(struct ioc3_private *ip)
-{
-	struct ioc3_erxbuf *rxb;
-	struct sk_buff *skb;
-	int i;
-
-	for (i = ip->rx_ci; i & 15; i++) {
-		ip->rx_skbs[ip->rx_pi] = ip->rx_skbs[ip->rx_ci];
-		ip->rxr[ip->rx_pi++] = ip->rxr[ip->rx_ci++];
-	}
-	ip->rx_pi &= RX_RING_MASK;
-	ip->rx_ci &= RX_RING_MASK;
-
-	for (i = ip->rx_ci; i != ip->rx_pi; i = (i + 1) & RX_RING_MASK) {
-		skb = ip->rx_skbs[i];
-		rxb = (struct ioc3_erxbuf *)(skb->data - RX_OFFSET);
-		rxb->w0 = 0;
-	}
-}
-
 static inline void ioc3_clean_tx_ring(struct ioc3_private *ip)
 {
 	struct sk_buff *skb;
@@ -838,6 +818,7 @@ static void ioc3_alloc_rings(struct net_device *dev)
 		/* Because we reserve afterwards. */
 		skb_put(skb, (1664 + RX_OFFSET));
 		rxb = (struct ioc3_erxbuf *)skb->data;
+		rxb->w0 = 0;	/* Clear valid flag */
 		ip->rxr[i] = cpu_to_be64(ioc3_map(rxb, 1));
 		skb_reserve(skb, RX_OFFSET);
 	}
@@ -857,7 +838,6 @@ static void ioc3_init_rings(struct net_device *dev)
 	ioc3_free_rings(ip);
 	ioc3_alloc_rings(dev);
 
-	ioc3_clean_rx_ring(ip);
 	ioc3_clean_tx_ring(ip);
 
 	/* Now the rx ring base, consume & produce registers.  */
-- 
2.13.7

