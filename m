Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46714EDCCA
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 11:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbfKDKpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 05:45:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:45080 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727320AbfKDKpY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 05:45:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8EF1FB1CC;
        Mon,  4 Nov 2019 10:45:22 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>
Subject: [net v3 1/5] net: sgi: ioc3-eth: don't abuse dma_direct_* calls
Date:   Mon,  4 Nov 2019 11:45:11 +0100
Message-Id: <20191104104515.7066-1-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

dma_direct_ is a low-level API that must never be used by drivers
directly.  Switch to use the proper DMA API instead.

Fixes: ed870f6a7aa2 ("net: sgi: ioc3-eth: use dma-direct for dma allocations")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index deb636d653f3..477af82bf8a9 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -48,7 +48,7 @@
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/skbuff.h>
-#include <linux/dma-direct.h>
+#include <linux/dma-mapping.h>
 
 #include <net/ip.h>
 
@@ -1242,8 +1242,8 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ioc3_stop(ip);
 
 	/* Allocate rx ring.  4kb = 512 entries, must be 4kb aligned */
-	ip->rxr = dma_direct_alloc_pages(ip->dma_dev, RX_RING_SIZE,
-					 &ip->rxr_dma, GFP_ATOMIC, 0);
+	ip->rxr = dma_alloc_coherent(ip->dma_dev, RX_RING_SIZE, &ip->rxr_dma,
+				     GFP_ATOMIC);
 	if (!ip->rxr) {
 		pr_err("ioc3-eth: rx ring allocation failed\n");
 		err = -ENOMEM;
@@ -1251,9 +1251,8 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	/* Allocate tx rings.  16kb = 128 bufs, must be 16kb aligned  */
-	ip->txr = dma_direct_alloc_pages(ip->dma_dev, TX_RING_SIZE,
-					 &ip->txr_dma,
-					 GFP_KERNEL | __GFP_ZERO, 0);
+	ip->txr = dma_alloc_coherent(ip->dma_dev, TX_RING_SIZE, &ip->txr_dma,
+				     GFP_KERNEL | __GFP_ZERO);
 	if (!ip->txr) {
 		pr_err("ioc3-eth: tx ring allocation failed\n");
 		err = -ENOMEM;
@@ -1313,11 +1312,11 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 out_stop:
 	del_timer_sync(&ip->ioc3_timer);
 	if (ip->rxr)
-		dma_direct_free_pages(ip->dma_dev, RX_RING_SIZE, ip->rxr,
-				      ip->rxr_dma, 0);
+		dma_free_coherent(ip->dma_dev, RX_RING_SIZE, ip->rxr,
+				  ip->rxr_dma);
 	if (ip->txr)
-		dma_direct_free_pages(ip->dma_dev, TX_RING_SIZE, ip->txr,
-				      ip->txr_dma, 0);
+		dma_free_coherent(ip->dma_dev, TX_RING_SIZE, ip->txr,
+				  ip->txr_dma);
 out_res:
 	pci_release_regions(pdev);
 out_free:
@@ -1335,10 +1334,8 @@ static void ioc3_remove_one(struct pci_dev *pdev)
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct ioc3_private *ip = netdev_priv(dev);
 
-	dma_direct_free_pages(ip->dma_dev, RX_RING_SIZE, ip->rxr,
-			      ip->rxr_dma, 0);
-	dma_direct_free_pages(ip->dma_dev, TX_RING_SIZE, ip->txr,
-			      ip->txr_dma, 0);
+	dma_free_coherent(ip->dma_dev, RX_RING_SIZE, ip->rxr, ip->rxr_dma);
+	dma_free_coherent(ip->dma_dev, TX_RING_SIZE, ip->txr, ip->txr_dma);
 
 	unregister_netdev(dev);
 	del_timer_sync(&ip->ioc3_timer);
-- 
2.16.4

