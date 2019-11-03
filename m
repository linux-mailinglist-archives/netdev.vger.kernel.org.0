Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA6AED2DF
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 11:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfKCKfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 05:35:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:56864 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726408AbfKCKfG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Nov 2019 05:35:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3CAFAB13E;
        Sun,  3 Nov 2019 10:35:04 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>
Subject: [net v2 1/4] net: sgi: ioc3-eth: don't abuse dma_direct_* calls
Date:   Sun,  3 Nov 2019 11:34:30 +0100
Message-Id: <20191103103433.26826-1-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

dma_direct_ is a low-level API that must never be used by drivers
directly.  Switch to use the proper DMA API instead.

Change in v2:
- ensure that tx ring is 16kB aligned

Fixes: ed870f6a7aa2 ("net: sgi: ioc3-eth: use dma-direct for dma allocations")
Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 drivers/net/ethernet/sgi/ioc3-eth.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index deb636d653f3..4879dedf1f60 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -48,7 +48,7 @@
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/skbuff.h>
-#include <linux/dma-direct.h>
+#include <linux/dma-mapping.h>
 
 #include <net/ip.h>
 
@@ -89,6 +89,7 @@ struct ioc3_private {
 	struct device *dma_dev;
 	u32 *ssram;
 	unsigned long *rxr;		/* pointer to receiver ring */
+	void *tx_ring;
 	struct ioc3_etxd *txr;
 	dma_addr_t rxr_dma;
 	dma_addr_t txr_dma;
@@ -1242,8 +1243,8 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ioc3_stop(ip);
 
 	/* Allocate rx ring.  4kb = 512 entries, must be 4kb aligned */
-	ip->rxr = dma_direct_alloc_pages(ip->dma_dev, RX_RING_SIZE,
-					 &ip->rxr_dma, GFP_ATOMIC, 0);
+	ip->rxr = dma_alloc_coherent(ip->dma_dev, RX_RING_SIZE, &ip->rxr_dma,
+				     GFP_ATOMIC);
 	if (!ip->rxr) {
 		pr_err("ioc3-eth: rx ring allocation failed\n");
 		err = -ENOMEM;
@@ -1251,14 +1252,16 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* Allocate tx rings.  16kb = 128 bufs, must be 16kb aligned  */
-	ip->txr = dma_direct_alloc_pages(ip->dma_dev, TX_RING_SIZE,
-					 &ip->txr_dma,
-					 GFP_KERNEL | __GFP_ZERO, 0);
-	if (!ip->txr) {
+	ip->tx_ring = dma_alloc_coherent(ip->dma_dev, TX_RING_SIZE + SZ_16K - 1,
+					 &ip->txr_dma, GFP_KERNEL | __GFP_ZERO);
+	if (!ip->tx_ring) {
 		pr_err("ioc3-eth: tx ring allocation failed\n");
 		err = -ENOMEM;
 		goto out_stop;
 	}
+	/* Align TX ring */
+	ip->txr = PTR_ALIGN(ip->tx_ring, SZ_16K);
+	ip->txr_dma = ALIGN(ip->txr_dma, SZ_16K);
 
 	ioc3_init(dev);
 
@@ -1313,11 +1316,11 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 out_stop:
 	del_timer_sync(&ip->ioc3_timer);
 	if (ip->rxr)
-		dma_direct_free_pages(ip->dma_dev, RX_RING_SIZE, ip->rxr,
-				      ip->rxr_dma, 0);
-	if (ip->txr)
-		dma_direct_free_pages(ip->dma_dev, TX_RING_SIZE, ip->txr,
-				      ip->txr_dma, 0);
+		dma_free_coherent(ip->dma_dev, RX_RING_SIZE, ip->rxr,
+				  ip->rxr_dma);
+	if (ip->tx_ring)
+		dma_free_coherent(ip->dma_dev, TX_RING_SIZE, ip->tx_ring,
+				  ip->txr_dma);
 out_res:
 	pci_release_regions(pdev);
 out_free:
@@ -1335,10 +1338,8 @@ static void ioc3_remove_one(struct pci_dev *pdev)
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct ioc3_private *ip = netdev_priv(dev);
 
-	dma_direct_free_pages(ip->dma_dev, RX_RING_SIZE, ip->rxr,
-			      ip->rxr_dma, 0);
-	dma_direct_free_pages(ip->dma_dev, TX_RING_SIZE, ip->txr,
-			      ip->txr_dma, 0);
+	dma_free_coherent(ip->dma_dev, RX_RING_SIZE, ip->rxr, ip->rxr_dma);
+	dma_free_coherent(ip->dma_dev, TX_RING_SIZE, ip->tx_ring, ip->txr_dma);
 
 	unregister_netdev(dev);
 	del_timer_sync(&ip->ioc3_timer);
-- 
2.16.4

