Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73EE249581
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 08:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgHSG5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 02:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbgHSG4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 02:56:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D33FC061389;
        Tue, 18 Aug 2020 23:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Zrmu5iMLYvFiMq8HFIdWyHcjZPqxIM1+gxr5lbG6RqA=; b=XA1vL5ZQWcpYB9lkjANXS49TDB
        B4ryz2QdjuP8CSVshFHtMlIwps20n8Uvvj9no1MwDaCpcCcZfhX/Gj2uSgUWTjPAz5OXyMBrbVKGD
        ajYZW0DDlmxyRSJMsXsPSb9D2ciwmYov9Vbr1JOlaFrRvKtHMzUm08126ZCxfdvD/dyJkuTv+TeYE
        eiYvfUd6MFs1jxjBzpN7i8dKQJ07VVYHK05EuOKQJk0T3LhqKnyVRZ6e5RrKUeng0XZZZ9AyNu/Kt
        KriBqeGn5aoTmk+4GDi5WWbav59d915s38yiVnRFrqLsXZOhRHSg4Tq7mfClfeQss/JTMrVlRK8n+
        EPYZ+9Kg==;
Received: from [2001:4bb8:198:f3b2:86b6:2277:f429:37a1] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8I12-0008MJ-S1; Wed, 19 Aug 2020 06:56:09 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, nouveau@lists.freedesktop.org,
        netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 06/28] lib82596: move DMA allocation into the callers of i82596_probe
Date:   Wed, 19 Aug 2020 08:55:33 +0200
Message-Id: <20200819065555.1802761-7-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200819065555.1802761-1-hch@lst.de>
References: <20200819065555.1802761-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows us to get rid of the LIB82596_DMA_ATTR defined and prepare
for untangling the coherent vs non-coherent DMA allocation API.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/net/ethernet/i825xx/lasi_82596.c | 24 ++++++++++------
 drivers/net/ethernet/i825xx/lib82596.c   | 36 ++++++++----------------
 drivers/net/ethernet/i825xx/sni_82596.c  | 19 +++++++++----
 3 files changed, 40 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/i825xx/lasi_82596.c b/drivers/net/ethernet/i825xx/lasi_82596.c
index aec7e98bcc853a..8c5ab9b7553e75 100644
--- a/drivers/net/ethernet/i825xx/lasi_82596.c
+++ b/drivers/net/ethernet/i825xx/lasi_82596.c
@@ -96,8 +96,6 @@
 
 #define OPT_SWAP_PORT	0x0001	/* Need to wordswp on the MPU port */
 
-#define LIB82596_DMA_ATTR	DMA_ATTR_NON_CONSISTENT
-
 #define DMA_WBACK(ndev, addr, len) \
 	do { dma_cache_sync((ndev)->dev.parent, (void *)addr, len, DMA_TO_DEVICE); } while (0)
 
@@ -155,7 +153,7 @@ lan_init_chip(struct parisc_device *dev)
 {
 	struct	net_device *netdevice;
 	struct i596_private *lp;
-	int	retval;
+	int retval = -ENOMEM;
 	int i;
 
 	if (!dev->irq) {
@@ -186,12 +184,22 @@ lan_init_chip(struct parisc_device *dev)
 
 	lp = netdev_priv(netdevice);
 	lp->options = dev->id.sversion == 0x72 ? OPT_SWAP_PORT : 0;
+	lp->dma = dma_alloc_attrs(dev->dev.parent, sizeof(struct i596_dma),
+			      &lp->dma_addr, GFP_KERNEL,
+			      DMA_ATTR_NON_CONSISTENT);
+	if (!lp->dma)
+		goto out_free_netdev;
 
 	retval = i82596_probe(netdevice);
-	if (retval) {
-		free_netdev(netdevice);
-		return -ENODEV;
-	}
+	if (retval)
+		goto out_free_dma;
+	return 0;
+
+out_free_dma:
+	dma_free_attrs(dev->dev.parent, sizeof(struct i596_dma),
+		       lp->dma, lp->dma_addr, DMA_ATTR_NON_CONSISTENT);
+out_free_netdev:
+	free_netdev(netdevice);
 	return retval;
 }
 
@@ -202,7 +210,7 @@ static int __exit lan_remove_chip(struct parisc_device *pdev)
 
 	unregister_netdev (dev);
 	dma_free_attrs(&pdev->dev, sizeof(struct i596_private), lp->dma,
-		       lp->dma_addr, LIB82596_DMA_ATTR);
+		       lp->dma_addr, DMA_ATTR_NON_CONSISTENT);
 	free_netdev (dev);
 	return 0;
 }
diff --git a/drivers/net/ethernet/i825xx/lib82596.c b/drivers/net/ethernet/i825xx/lib82596.c
index b03757e169e475..b4e4b3eb5758b5 100644
--- a/drivers/net/ethernet/i825xx/lib82596.c
+++ b/drivers/net/ethernet/i825xx/lib82596.c
@@ -1047,9 +1047,8 @@ static const struct net_device_ops i596_netdev_ops = {
 
 static int i82596_probe(struct net_device *dev)
 {
-	int i;
 	struct i596_private *lp = netdev_priv(dev);
-	struct i596_dma *dma;
+	int ret;
 
 	/* This lot is ensure things have been cache line aligned. */
 	BUILD_BUG_ON(sizeof(struct i596_rfd) != 32);
@@ -1063,41 +1062,28 @@ static int i82596_probe(struct net_device *dev)
 	if (!dev->base_addr || !dev->irq)
 		return -ENODEV;
 
-	dma = dma_alloc_attrs(dev->dev.parent, sizeof(struct i596_dma),
-			      &lp->dma_addr, GFP_KERNEL,
-			      LIB82596_DMA_ATTR);
-	if (!dma) {
-		printk(KERN_ERR "%s: Couldn't get shared memory\n", __FILE__);
-		return -ENOMEM;
-	}
-
 	dev->netdev_ops = &i596_netdev_ops;
 	dev->watchdog_timeo = TX_TIMEOUT;
 
-	memset(dma, 0, sizeof(struct i596_dma));
-	lp->dma = dma;
-
-	dma->scb.command = 0;
-	dma->scb.cmd = I596_NULL;
-	dma->scb.rfd = I596_NULL;
+	memset(lp->dma, 0, sizeof(struct i596_dma));
+	lp->dma->scb.command = 0;
+	lp->dma->scb.cmd = I596_NULL;
+	lp->dma->scb.rfd = I596_NULL;
 	spin_lock_init(&lp->lock);
 
-	DMA_WBACK_INV(dev, dma, sizeof(struct i596_dma));
+	DMA_WBACK_INV(dev, lp->dma, sizeof(struct i596_dma));
 
-	i = register_netdev(dev);
-	if (i) {
-		dma_free_attrs(dev->dev.parent, sizeof(struct i596_dma),
-			       dma, lp->dma_addr, LIB82596_DMA_ATTR);
-		return i;
-	}
+	ret = register_netdev(dev);
+	if (ret)
+		return ret;
 
 	DEB(DEB_PROBE, printk(KERN_INFO "%s: 82596 at %#3lx, %pM IRQ %d.\n",
 			      dev->name, dev->base_addr, dev->dev_addr,
 			      dev->irq));
 	DEB(DEB_INIT, printk(KERN_INFO
 			     "%s: dma at 0x%p (%d bytes), lp->scb at 0x%p\n",
-			     dev->name, dma, (int)sizeof(struct i596_dma),
-			     &dma->scb));
+			     dev->name, lp->dma, (int)sizeof(struct i596_dma),
+			     &lp->dma->scb));
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/i825xx/sni_82596.c b/drivers/net/ethernet/i825xx/sni_82596.c
index 22f5887578b2bd..e80e790ffbd4d4 100644
--- a/drivers/net/ethernet/i825xx/sni_82596.c
+++ b/drivers/net/ethernet/i825xx/sni_82596.c
@@ -24,8 +24,6 @@
 
 static const char sni_82596_string[] = "snirm_82596";
 
-#define LIB82596_DMA_ATTR	0
-
 #define DMA_WBACK(priv, addr, len)     do { } while (0)
 #define DMA_INV(priv, addr, len)       do { } while (0)
 #define DMA_WBACK_INV(priv, addr, len) do { } while (0)
@@ -134,10 +132,19 @@ static int sni_82596_probe(struct platform_device *dev)
 	lp->ca = ca_addr;
 	lp->mpu_port = mpu_addr;
 
+	lp->dma = dma_alloc_coherent(dev->dev.parent, sizeof(struct i596_dma),
+				     &lp->dma_addr, GFP_KERNEL);
+	if (!lp->dma)
+		goto probe_failed;
+
 	retval = i82596_probe(netdevice);
-	if (retval == 0)
-		return 0;
+	if (retval)
+		goto probe_failed_free_dma;
+	return 0;
 
+probe_failed_free_dma:
+	dma_free_coherent(dev->dev.parent, sizeof(struct i596_dma), lp->dma,
+			  lp->dma_addr);
 probe_failed:
 	free_netdev(netdevice);
 probe_failed_free_ca:
@@ -153,8 +160,8 @@ static int sni_82596_driver_remove(struct platform_device *pdev)
 	struct i596_private *lp = netdev_priv(dev);
 
 	unregister_netdev(dev);
-	dma_free_attrs(dev->dev.parent, sizeof(struct i596_private), lp->dma,
-		       lp->dma_addr, LIB82596_DMA_ATTR);
+	dma_free_coherent(dev->dev.parent, sizeof(struct i596_private), lp->dma,
+			  lp->dma_addr);
 	iounmap(lp->ca);
 	iounmap(lp->mpu_port);
 	free_netdev (dev);
-- 
2.28.0

