Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A287935F7D0
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352352AbhDNPaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:30:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:33180 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344386AbhDNPaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 11:30:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AED40B01C;
        Wed, 14 Apr 2021 15:29:48 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 3/9] net: korina: Remove not needed cache flushes
Date:   Wed, 14 Apr 2021 17:29:39 +0200
Message-Id: <20210414152946.12517-4-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210414152946.12517-1-tsbogend@alpha.franken.de>
References: <20210414152946.12517-1-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Descriptors are mapped uncached so there is no need to do any cache
handling for them.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 drivers/net/ethernet/korina.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 3a454f6214b0..b6dcbb6d5e05 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -230,7 +230,6 @@ static int korina_send_packet(struct sk_buff *skb, struct net_device *dev)
 	dma_cache_wback((u32)skb->data, skb->len);
 
 	/* Setup the transmit descriptor. */
-	dma_cache_inv((u32) td, sizeof(*td));
 	td->ca = CPHYSADDR(skb->data);
 	chain_prev = (lp->tx_chain_tail - 1) & KORINA_TDS_MASK;
 	chain_next = (lp->tx_chain_tail + 1) & KORINA_TDS_MASK;
@@ -283,7 +282,6 @@ static int korina_send_packet(struct sk_buff *skb, struct net_device *dev)
 			lp->tx_chain_tail = chain_next;
 		}
 	}
-	dma_cache_wback((u32) td, sizeof(*td));
 
 	netif_trans_update(dev);
 	spin_unlock_irqrestore(&lp->lock, flags);
@@ -374,8 +372,6 @@ static int korina_rx(struct net_device *dev, int limit)
 	u32 devcs, pkt_len, dmas;
 	int count;
 
-	dma_cache_inv((u32)rd, sizeof(*rd));
-
 	for (count = 0; count < limit; count++) {
 		skb = lp->rx_skb[lp->rx_next_done];
 		skb_new = NULL;
@@ -454,7 +450,6 @@ static int korina_rx(struct net_device *dev, int limit)
 			~DMA_DESC_COD;
 
 		lp->rx_next_done = (lp->rx_next_done + 1) & KORINA_RDS_MASK;
-		dma_cache_wback((u32)rd, sizeof(*rd));
 		rd = &lp->rd_ring[lp->rx_next_done];
 		writel(~DMA_STAT_DONE, &lp->rx_dma_regs->dmas);
 	}
@@ -469,7 +464,6 @@ static int korina_rx(struct net_device *dev, int limit)
 		rd->devcs = 0;
 		skb = lp->rx_skb[lp->rx_next_done];
 		rd->ca = CPHYSADDR(skb->data);
-		dma_cache_wback((u32)rd, sizeof(*rd));
 		korina_chain_rx(lp, rd);
 	}
 
-- 
2.29.2

