Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92EBCA0418
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 16:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfH1OEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 10:04:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:39750 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726830AbfH1ODd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 10:03:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C860BB64E;
        Wed, 28 Aug 2019 14:03:31 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 09/15] net: sgi: ioc3-eth: split ring cleaning/freeing and allocation
Date:   Wed, 28 Aug 2019 16:03:08 +0200
Message-Id: <20190828140315.17048-10-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190828140315.17048-1-tbogendoerfer@suse.de>
References: <20190828140315.17048-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do tx ring cleaning and freeing of rx buffers, when chip is shutdown and
allocate buffers before bringing chip up.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index 191eafbeb455..e51922b5ca04 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -108,6 +108,9 @@ static inline unsigned int ioc3_hash(const unsigned char *addr);
 static void ioc3_start(struct ioc3_private *ip);
 static inline void ioc3_stop(struct ioc3_private *ip);
 static void ioc3_init(struct net_device *dev);
+static void ioc3_alloc_rx_bufs(struct net_device *dev);
+static void ioc3_free_rx_bufs(struct ioc3_private *ip);
+static inline void ioc3_clean_tx_ring(struct ioc3_private *ip);
 
 static const char ioc3_str[] = "IOC3 Ethernet";
 static const struct ethtool_ops ioc3_ethtool_ops;
@@ -660,7 +663,11 @@ static void ioc3_error(struct net_device *dev, u32 eisr)
 		netdev_err(dev, "TX PCI error.\n");
 
 	ioc3_stop(ip);
+	ioc3_free_rx_bufs(ip);
+	ioc3_clean_tx_ring(ip);
+
 	ioc3_init(dev);
+	ioc3_alloc_rx_bufs(dev);
 	ioc3_start(ip);
 	ioc3_mii_init(ip);
 
@@ -828,16 +835,6 @@ static void ioc3_alloc_rx_bufs(struct net_device *dev)
 	ip->rx_pi = RX_BUFFS;
 }
 
-static void ioc3_init_rings(struct net_device *dev)
-{
-	struct ioc3_private *ip = netdev_priv(dev);
-
-	ioc3_free_rx_bufs(ip);
-	ioc3_alloc_rx_bufs(dev);
-
-	ioc3_clean_tx_ring(ip);
-}
-
 static inline void ioc3_ssram_disc(struct ioc3_private *ip)
 {
 	struct ioc3_ethregs *regs = ip->regs;
@@ -890,8 +887,6 @@ static void ioc3_init(struct net_device *dev)
 	writel(ip->ehar_h, &regs->ehar_h);
 	writel(ip->ehar_l, &regs->ehar_l);
 	writel(42, &regs->ersr);		/* XXX should be random */
-
-	ioc3_init_rings(dev);
 }
 
 static void ioc3_start(struct ioc3_private *ip)
@@ -947,7 +942,9 @@ static int ioc3_open(struct net_device *dev)
 
 	ip->ehar_h = 0;
 	ip->ehar_l = 0;
+
 	ioc3_init(dev);
+	ioc3_alloc_rx_bufs(dev);
 	ioc3_start(ip);
 	ioc3_mii_start(ip);
 
@@ -1217,7 +1214,6 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	ioc3_init(dev);
-	ioc3_start(ip);
 
 	ip->pdev = pdev;
 
@@ -1268,9 +1264,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
 out_stop:
-	ioc3_stop(ip);
 	del_timer_sync(&ip->ioc3_timer);
-	ioc3_free_rx_bufs(ip);
 	kfree(ip->rxr);
 	kfree(ip->txr);
 out_res:
@@ -1437,7 +1431,11 @@ static void ioc3_timeout(struct net_device *dev)
 	spin_lock_irq(&ip->ioc3_lock);
 
 	ioc3_stop(ip);
+	ioc3_free_rx_bufs(ip);
+	ioc3_clean_tx_ring(ip);
+
 	ioc3_init(dev);
+	ioc3_alloc_rx_bufs(dev);
 	ioc3_start(ip);
 	ioc3_mii_init(ip);
 	ioc3_mii_start(ip);
-- 
2.13.7

