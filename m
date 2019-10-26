Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A53FE5B4A
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729277AbfJZNWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:22:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729233AbfJZNV6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:21:58 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B422121E6F;
        Sat, 26 Oct 2019 13:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096117;
        bh=L5zoxb0wbpj0jGsgu8jeGcj7RqnKzG1JmW48JRAly48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K0AfIi18ZZVgWFouDRGoeObT+BtlvU2BgyWtEwU1t3fPUj8NukuGw197Cmwqld3js
         rWHKXJbZml18GcjGytIcHVdenU632HckeEGQSbMrV6GLSBThy6sqEfreIOPIH/G6y2
         wqXHzPyqNg7zXVSE3QA0Dt+u7BcG33kx6AyCRI/4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 23/33] net: i82596: fix dma_alloc_attr for sni_82596
Date:   Sat, 26 Oct 2019 09:21:00 -0400
Message-Id: <20191026132110.4026-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026132110.4026-1-sashal@kernel.org>
References: <20191026132110.4026-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

[ Upstream commit 61c1d33daf7b5146f44d4363b3322f8cda6a6c43 ]

Commit 7f683b920479 ("i825xx: switch to switch to dma_alloc_attrs")
switched dma allocation over to dma_alloc_attr, but didn't convert
the SNI part to request consistent DMA memory. This broke sni_82596
since driver doesn't do dma_cache_sync for performance reasons.
Fix this by using different DMA_ATTRs for lasi_82596 and sni_82596.

Fixes: 7f683b920479 ("i825xx: switch to switch to dma_alloc_attrs")
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/i825xx/lasi_82596.c | 4 +++-
 drivers/net/ethernet/i825xx/lib82596.c   | 4 ++--
 drivers/net/ethernet/i825xx/sni_82596.c  | 4 +++-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/i825xx/lasi_82596.c b/drivers/net/ethernet/i825xx/lasi_82596.c
index b69c622ba8b2d..6f0e4019adefa 100644
--- a/drivers/net/ethernet/i825xx/lasi_82596.c
+++ b/drivers/net/ethernet/i825xx/lasi_82596.c
@@ -96,6 +96,8 @@
 
 #define OPT_SWAP_PORT	0x0001	/* Need to wordswp on the MPU port */
 
+#define LIB82596_DMA_ATTR	DMA_ATTR_NON_CONSISTENT
+
 #define DMA_WBACK(ndev, addr, len) \
 	do { dma_cache_sync((ndev)->dev.parent, (void *)addr, len, DMA_TO_DEVICE); } while (0)
 
@@ -199,7 +201,7 @@ static int __exit lan_remove_chip(struct parisc_device *pdev)
 
 	unregister_netdev (dev);
 	dma_free_attrs(&pdev->dev, sizeof(struct i596_private), lp->dma,
-		       lp->dma_addr, DMA_ATTR_NON_CONSISTENT);
+		       lp->dma_addr, LIB82596_DMA_ATTR);
 	free_netdev (dev);
 	return 0;
 }
diff --git a/drivers/net/ethernet/i825xx/lib82596.c b/drivers/net/ethernet/i825xx/lib82596.c
index f00a1dc2128cb..da3758fdf025f 100644
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
index b2c04a789744f..43c1fd18670b0 100644
--- a/drivers/net/ethernet/i825xx/sni_82596.c
+++ b/drivers/net/ethernet/i825xx/sni_82596.c
@@ -23,6 +23,8 @@
 
 static const char sni_82596_string[] = "snirm_82596";
 
+#define LIB82596_DMA_ATTR	0
+
 #define DMA_WBACK(priv, addr, len)     do { } while (0)
 #define DMA_INV(priv, addr, len)       do { } while (0)
 #define DMA_WBACK_INV(priv, addr, len) do { } while (0)
@@ -151,7 +153,7 @@ static int sni_82596_driver_remove(struct platform_device *pdev)
 
 	unregister_netdev(dev);
 	dma_free_attrs(dev->dev.parent, sizeof(struct i596_private), lp->dma,
-		       lp->dma_addr, DMA_ATTR_NON_CONSISTENT);
+		       lp->dma_addr, LIB82596_DMA_ATTR);
 	iounmap(lp->ca);
 	iounmap(lp->mpu_port);
 	free_netdev (dev);
-- 
2.20.1

