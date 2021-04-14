Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0971635FE25
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236991AbhDNXHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:07:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:55804 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234225AbhDNXHO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 19:07:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 37B94B0B8;
        Wed, 14 Apr 2021 23:06:51 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 04/10] net: korina: Remove nested helpers
Date:   Thu, 15 Apr 2021 01:06:41 +0200
Message-Id: <20210414230648.76129-5-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210414230648.76129-1-tsbogend@alpha.franken.de>
References: <20210414230648.76129-1-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove helpers, which are only used in one call site.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 drivers/net/ethernet/korina.c | 28 +++-------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 408cb2dedb95..479142c5166f 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -142,12 +142,6 @@ struct korina_private {
 
 extern unsigned int idt_cpu_freq;
 
-static inline void korina_start_dma(struct dma_reg *ch, u32 dma_addr)
-{
-	writel(0, &ch->dmandptr);
-	writel(dma_addr, &ch->dmadptr);
-}
-
 static inline void korina_abort_dma(struct net_device *dev,
 					struct dma_reg *ch)
 {
@@ -164,11 +158,6 @@ static inline void korina_abort_dma(struct net_device *dev,
 	writel(0, &ch->dmandptr);
 }
 
-static inline void korina_chain_dma(struct dma_reg *ch, u32 dma_addr)
-{
-	writel(dma_addr, &ch->dmandptr);
-}
-
 static void korina_abort_tx(struct net_device *dev)
 {
 	struct korina_private *lp = netdev_priv(dev);
@@ -183,18 +172,6 @@ static void korina_abort_rx(struct net_device *dev)
 	korina_abort_dma(dev, lp->rx_dma_regs);
 }
 
-static void korina_start_rx(struct korina_private *lp,
-					struct dma_desc *rd)
-{
-	korina_start_dma(lp->rx_dma_regs, CPHYSADDR(rd));
-}
-
-static void korina_chain_rx(struct korina_private *lp,
-					struct dma_desc *rd)
-{
-	korina_chain_dma(lp->rx_dma_regs, CPHYSADDR(rd));
-}
-
 /* transmit packet */
 static int korina_send_packet(struct sk_buff *skb, struct net_device *dev)
 {
@@ -461,7 +438,7 @@ static int korina_rx(struct net_device *dev, int limit)
 		rd->devcs = 0;
 		skb = lp->rx_skb[lp->rx_next_done];
 		rd->ca = CPHYSADDR(skb->data);
-		korina_chain_rx(lp, rd);
+		writel(CPHYSADDR(rd), &lp->rx_dma_regs->dmandptr);
 	}
 
 	return count;
@@ -838,7 +815,8 @@ static int korina_init(struct net_device *dev)
 
 	writel(0, &lp->rx_dma_regs->dmas);
 	/* Start Rx DMA */
-	korina_start_rx(lp, &lp->rd_ring[0]);
+	writel(0, &lp->rx_dma_regs->dmandptr);
+	writel(CPHYSADDR(&lp->rd_ring[0]), &lp->rx_dma_regs->dmadptr);
 
 	writel(readl(&lp->tx_dma_regs->dmasm) &
 			~(DMA_STAT_FINI | DMA_STAT_ERR),
-- 
2.29.2

