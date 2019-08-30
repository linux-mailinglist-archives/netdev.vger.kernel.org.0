Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08642A33E7
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 11:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbfH3J0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 05:26:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:41818 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728158AbfH3JZ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 05:25:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A83CBAFA9;
        Fri, 30 Aug 2019 09:25:55 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v3 net-next 08/15] net: sgi: ioc3-eth: introduce chip start function
Date:   Fri, 30 Aug 2019 11:25:31 +0200
Message-Id: <20190830092539.24550-9-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190830092539.24550-1-tbogendoerfer@suse.de>
References: <20190830092539.24550-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ioc3_init did everything from reset to init rings to starting the chip.
This change move out chip start into a new function as preparation
for easier handling of receive buffer allocation failures.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 49 ++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index 29b9e5098052..d32d245dcf18 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -105,6 +105,7 @@ static void ioc3_set_multicast_list(struct net_device *dev);
 static netdev_tx_t ioc3_start_xmit(struct sk_buff *skb, struct net_device *dev);
 static void ioc3_timeout(struct net_device *dev);
 static inline unsigned int ioc3_hash(const unsigned char *addr);
+static void ioc3_start(struct ioc3_private *ip);
 static inline void ioc3_stop(struct ioc3_private *ip);
 static void ioc3_init(struct net_device *dev);
 
@@ -660,6 +661,7 @@ static void ioc3_error(struct net_device *dev, u32 eisr)
 
 	ioc3_stop(ip);
 	ioc3_init(dev);
+	ioc3_start(ip);
 	ioc3_mii_init(ip);
 
 	netif_wake_queue(dev);
@@ -827,31 +829,11 @@ static void ioc3_alloc_rx_bufs(struct net_device *dev)
 static void ioc3_init_rings(struct net_device *dev)
 {
 	struct ioc3_private *ip = netdev_priv(dev);
-	struct ioc3_ethregs *regs = ip->regs;
-	unsigned long ring;
 
 	ioc3_free_rx_bufs(ip);
 	ioc3_alloc_rx_bufs(dev);
 
 	ioc3_clean_tx_ring(ip);
-
-	/* Now the rx ring base, consume & produce registers.  */
-	ring = ioc3_map(ip->rxr, 0);
-	writel(ring >> 32, &regs->erbr_h);
-	writel(ring & 0xffffffff, &regs->erbr_l);
-	writel(ip->rx_ci << 3, &regs->ercir);
-	writel((ip->rx_pi << 3) | ERPIR_ARM, &regs->erpir);
-
-	ring = ioc3_map(ip->txr, 0);
-
-	ip->txqlen = 0;					/* nothing queued  */
-
-	/* Now the tx ring base, consume & produce registers.  */
-	writel(ring >> 32, &regs->etbr_h);
-	writel(ring & 0xffffffff, &regs->etbr_l);
-	writel(ip->tx_pi << 7, &regs->etpir);
-	writel(ip->tx_ci << 7, &regs->etcir);
-	readl(&regs->etcir);				/* Flush */
 }
 
 static inline void ioc3_ssram_disc(struct ioc3_private *ip)
@@ -908,6 +890,30 @@ static void ioc3_init(struct net_device *dev)
 	writel(42, &regs->ersr);		/* XXX should be random */
 
 	ioc3_init_rings(dev);
+}
+
+static void ioc3_start(struct ioc3_private *ip)
+{
+	struct ioc3_ethregs *regs = ip->regs;
+	unsigned long ring;
+
+	/* Now the rx ring base, consume & produce registers.  */
+	ring = ioc3_map(ip->rxr, 0);
+	writel(ring >> 32, &regs->erbr_h);
+	writel(ring & 0xffffffff, &regs->erbr_l);
+	writel(ip->rx_ci << 3, &regs->ercir);
+	writel((ip->rx_pi << 3) | ERPIR_ARM, &regs->erpir);
+
+	ring = ioc3_map(ip->txr, 0);
+
+	ip->txqlen = 0;					/* nothing queued  */
+
+	/* Now the tx ring base, consume & produce registers.  */
+	writel(ring >> 32, &regs->etbr_h);
+	writel(ring & 0xffffffff, &regs->etbr_l);
+	writel(ip->tx_pi << 7, &regs->etpir);
+	writel(ip->tx_ci << 7, &regs->etcir);
+	readl(&regs->etcir);				/* Flush */
 
 	ip->emcr |= ((RX_OFFSET / 2) << EMCR_RXOFF_SHIFT) | EMCR_TXDMAEN |
 		    EMCR_TXEN | EMCR_RXDMAEN | EMCR_RXEN | EMCR_PADEN;
@@ -940,6 +946,7 @@ static int ioc3_open(struct net_device *dev)
 	ip->ehar_h = 0;
 	ip->ehar_l = 0;
 	ioc3_init(dev);
+	ioc3_start(ip);
 	ioc3_mii_start(ip);
 
 	netif_start_queue(dev);
@@ -1208,6 +1215,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	ioc3_init(dev);
+	ioc3_start(ip);
 
 	ip->pdev = pdev;
 
@@ -1430,6 +1438,7 @@ static void ioc3_timeout(struct net_device *dev)
 
 	ioc3_stop(ip);
 	ioc3_init(dev);
+	ioc3_start(ip);
 	ioc3_mii_init(ip);
 	ioc3_mii_start(ip);
 
-- 
2.13.7

