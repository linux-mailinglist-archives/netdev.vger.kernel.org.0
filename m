Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A34C3EA534
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 22:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfJ3VMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 17:12:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:60312 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfJ3VMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 17:12:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dgAmSwK4jvd1xGgkV8CBauhdgy9Uw2ZyrAWjVkChYqk=; b=Y3WqtsUhX+EHo86VfpjPm9P9Ug
        8Bf4/V2wzj47Nc/QwB3d8PnnK/xJU4VvyR7nUdFkYYHv4stVjC5bd8xb9vX+DdoAkioyDhsYBduY6
        npAo1HJc/Hepat5uVDayJy1lZ5pGzEHZAbXHPXO7j398SK7ecKVLncK8LYMF+lNlXjdGdV9KJcWzb
        ZoQrsaobmcy671yXgGh6L6m42sdxDI78TGgW1CfnGn4DeanbWhH1SYPntF+v3HfXqY0ao/ZkQBz48
        VwfiuA/RWpjEM+WlRt6JoDKZfQyqjZgU3/MaA5eqQtmV0i/Bd7R5JNJHkg0YF/Y3a7e2Sy6Bzkfe4
        pelMG4Kw==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPvGn-0007dH-UW; Wed, 30 Oct 2019 21:12:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] net: sgi: ioc3-eth: don't abuse dma_direct_* calls
Date:   Wed, 30 Oct 2019 14:12:30 -0700
Message-Id: <20191030211233.30157-2-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030211233.30157-1-hch@lst.de>
References: <20191030211233.30157-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dma_direct_ is a low-level API that must never be used by drivers
directly.  Switch to use the proper DMA API instead.

Fixes: ed870f6a7aa2 ("net: sgi: ioc3-eth: use dma-direct for dma allocations")
Signed-off-by: Christoph Hellwig <hch@lst.de>
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
2.20.1

