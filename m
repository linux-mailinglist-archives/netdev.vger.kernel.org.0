Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC0F3A040C
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 16:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfH1ODv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 10:03:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:39794 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726857AbfH1ODe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 10:03:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1B7ACB650;
        Wed, 28 Aug 2019 14:03:33 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 14/15] net: sgi: ioc3-eth: protect emcr in all cases
Date:   Wed, 28 Aug 2019 16:03:13 +0200
Message-Id: <20190828140315.17048-15-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190828140315.17048-1-tbogendoerfer@suse.de>
References: <20190828140315.17048-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

emcr in private struct wasn't always protected by spinlock.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index b8aea19fbeba..5de8300e5eb2 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -729,6 +729,8 @@ static inline void ioc3_setup_duplex(struct ioc3_private *ip)
 {
 	struct ioc3_ethregs *regs = ip->regs;
 
+	spin_lock_irq(&ip->ioc3_lock);
+
 	if (ip->mii.full_duplex) {
 		writel(ETCSR_FD, &regs->etcsr);
 		ip->emcr |= EMCR_DUPLEX;
@@ -737,6 +739,8 @@ static inline void ioc3_setup_duplex(struct ioc3_private *ip)
 		ip->emcr &= ~EMCR_DUPLEX;
 	}
 	writel(ip->emcr, &regs->emcr);
+
+	spin_unlock_irq(&ip->ioc3_lock);
 }
 
 static void ioc3_timer(struct timer_list *t)
@@ -1627,6 +1631,8 @@ static void ioc3_set_multicast_list(struct net_device *dev)
 
 	netif_stop_queue(dev);				/* Lock out others. */
 
+	spin_lock_irq(&ip->ioc3_lock);
+
 	if (dev->flags & IFF_PROMISC) {			/* Set promiscuous.  */
 		ip->emcr |= EMCR_PROMISC;
 		writel(ip->emcr, &regs->emcr);
@@ -1655,6 +1661,8 @@ static void ioc3_set_multicast_list(struct net_device *dev)
 		writel(ip->ehar_l, &regs->ehar_l);
 	}
 
+	spin_unlock_irq(&ip->ioc3_lock);
+
 	netif_wake_queue(dev);			/* Let us get going again. */
 }
 
-- 
2.13.7

