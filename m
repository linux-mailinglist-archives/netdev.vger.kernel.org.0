Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4F5DD78F1
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 16:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732875AbfJOOmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 10:42:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:60884 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732636AbfJOOmx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 10:42:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E4200AF22;
        Tue, 15 Oct 2019 14:42:51 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: i82596: fix dma_alloc_attr for sni_82596
Date:   Tue, 15 Oct 2019 16:42:45 +0200
Message-Id: <20191015144245.11182-1-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 7f683b920479 ("i825xx: switch to switch to dma_alloc_attrs")
switched dma allocation over to dma_alloc_attr, but didn't convert
the SNI part to request consistent DMA memory. This broke sni_82596
since driver doesn't do dma_cache_sync for performance reasons.
Fix this by using different DMA_ATTRs for lasi_82596 and sni_82596.

Fixes: 7f683b920479 ("i825xx: switch to switch to dma_alloc_attrs")
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/net/ethernet/i825xx/lasi_82596.c | 4 +++-
 drivers/net/ethernet/i825xx/lib82596.c   | 4 ++--
 drivers/net/ethernet/i825xx/sni_82596.c  | 4 +++-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/i825xx/lasi_82596.c b/drivers/net/ethernet/i825xx/lasi_82596.c
index 211c5f74b4c8..aec7e98bcc85 100644
--- a/drivers/net/ethernet/i825xx/lasi_82596.c
+++ b/drivers/net/ethernet/i825xx/lasi_82596.c
@@ -96,6 +96,8 @@
 
 #define OPT_SWAP_PORT	0x0001	/* Need to wordswp on the MPU port */
 
+#define LIB82596_DMA_ATTR	DMA_ATTR_NON_CONSISTENT
+
 #define DMA_WBACK(ndev, addr, len) \
 	do { dma_cache_sync((ndev)->dev.parent, (void *)addr, len, DMA_TO_DEVICE); } while (0)
 
@@ -200,7 +202,7 @@ static int __exit lan_remove_chip(struct parisc_device *pdev)
 
 	unregister_netdev (dev);
 	dma_free_attrs(&pdev->dev, sizeof(struct i596_private), lp->dma,
-		       lp->dma_addr, DMA_ATTR_NON_CONSISTENT);
+		       lp->dma_addr, LIB82596_DMA_ATTR);
 	free_netdev (dev);
 	return 0;
 }
diff --git a/drivers/net/ethernet/i825xx/lib82596.c b/drivers/net/ethernet/i825xx/lib82596.c
index 1274ad24d6af..f9742af7f142 100644
--- a/drivers/net/ethernet/i825xx/lib82596.c
+++ b/drivers/net/ethernet/i825xx/lib82596.c
@@ -1065,7 +1065,7 @@ static int i82596_probe(struct net_device *dev)
 
 	dma = dma_alloc_attrs(dev->dev.parent, sizeof(struct i596_dma),
 			      &lp->dma_addr, GFP_KERNEL,
-			      DMA_ATTR_NON_CONSISTENT);
+			      LIB82596_DMA_ATTR);
 	if (!dma) {
 		printk(KERN_ERR "%s: Couldn't get shared memory\n", __FILE__);
 		return -ENOMEM;
@@ -1087,7 +1087,7 @@ static int i82596_probe(struct net_device *dev)
 	i = register_netdev(dev);
 	if (i) {
 		dma_free_attrs(dev->dev.parent, sizeof(struct i596_dma),
-			       dma, lp->dma_addr, DMA_ATTR_NON_CONSISTENT);
+			       dma, lp->dma_addr, LIB82596_DMA_ATTR);
 		return i;
 	}
 
diff --git a/drivers/net/ethernet/i825xx/sni_82596.c b/drivers/net/ethernet/i825xx/sni_82596.c
index 6eb6c2ff7f09..6436a98c5953 100644
--- a/drivers/net/ethernet/i825xx/sni_82596.c
+++ b/drivers/net/ethernet/i825xx/sni_82596.c
@@ -24,6 +24,8 @@
 
 static const char sni_82596_string[] = "snirm_82596";
 
+#define LIB82596_DMA_ATTR	0
+
 #define DMA_WBACK(priv, addr, len)     do { } while (0)
 #define DMA_INV(priv, addr, len)       do { } while (0)
 #define DMA_WBACK_INV(priv, addr, len) do { } while (0)
@@ -152,7 +154,7 @@ static int sni_82596_driver_remove(struct platform_device *pdev)
 
 	unregister_netdev(dev);
 	dma_free_attrs(dev->dev.parent, sizeof(struct i596_private), lp->dma,
-		       lp->dma_addr, DMA_ATTR_NON_CONSISTENT);
+		       lp->dma_addr, LIB82596_DMA_ATTR);
 	iounmap(lp->ca);
 	iounmap(lp->mpu_port);
 	free_netdev (dev);
-- 
2.16.4

