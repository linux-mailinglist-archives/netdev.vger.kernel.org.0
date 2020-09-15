Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB14826B1DB
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbgIOWff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727523AbgIOQKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 12:10:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE08BC0611C1;
        Tue, 15 Sep 2020 09:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=jNO1brRzt5ng659lhtl+4oBfakGzrKMS1ATQw8TQgTw=; b=TNPCL5eofP+HlOArQnkCfBaBcr
        YSGLdW/Qiv8AzkIHe8+EOuTfZrgbsKu9jL1zP7QoNQXeZv0pCDWNLoYO6X7GX52MyzpQm/Qd0l4TW
        s31qJRN7rvs24hSZP6bcKILlEwfoqjkT6or2AmTorYl7yaujPyXyRdb9xYCgwn0zC5nSKokjgc87s
        wAsYB3/f0N9P1i3981XSC7+myVSEdufwVNd9kMFcESiR1kuA3nHY385p7qPLuLXrEFtb5WxZTOQ3I
        4Q6UFijBo+aeSfJD4+xDoOSZN+FjexdxQU+nwsfcM9/hEd0538/gLTNdu3xeyaqFFbXJnbQhSDROE
        mrXYuVRA==;
Received: from 089144214092.atnat0023.highway.a1.net ([89.144.214.92] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIDTc-0004Iz-Az; Tue, 15 Sep 2020 16:06:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org
Cc:     Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 06/18] lib82596: move DMA allocation into the callers of i82596_probe
Date:   Tue, 15 Sep 2020 17:51:10 +0200
Message-Id: <20200915155122.1768241-7-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915155122.1768241-1-hch@lst.de>
References: <20200915155122.1768241-1-hch@lst.de>
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
index aec7e98bcc853a..a12218e940a2fa 100644
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
+	lp->dma = dma_alloc_attrs(&dev->dev, sizeof(struct i596_dma),
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
+	dma_free_attrs(&dev->dev, sizeof(struct i596_dma), lp->dma,
+			lp->dma_addr, DMA_ATTR_NON_CONSISTENT);
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
index 22f5887578b2bd..4b9ac0c6557731 100644
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
 
+	lp->dma = dma_alloc_coherent(&dev->dev, sizeof(struct i596_dma),
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
+	dma_free_coherent(&dev->dev, sizeof(struct i596_dma), lp->dma,
+			  lp->dma_addr);
 probe_failed:
 	free_netdev(netdevice);
 probe_failed_free_ca:
@@ -153,8 +160,8 @@ static int sni_82596_driver_remove(struct platform_device *pdev)
 	struct i596_private *lp = netdev_priv(dev);
 
 	unregister_netdev(dev);
-	dma_free_attrs(dev->dev.parent, sizeof(struct i596_private), lp->dma,
-		       lp->dma_addr, LIB82596_DMA_ATTR);
+	dma_free_coherent(&pdev->dev, sizeof(struct i596_private), lp->dma,
+			  lp->dma_addr);
 	iounmap(lp->ca);
 	iounmap(lp->mpu_port);
 	free_netdev (dev);
-- 
2.28.0

