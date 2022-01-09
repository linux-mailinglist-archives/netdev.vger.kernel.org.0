Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD02488951
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 13:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235487AbiAIMT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 07:19:56 -0500
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:57515 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233254AbiAIMT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 07:19:56 -0500
Received: from pop-os.home ([90.11.185.88])
        by smtp.orange.fr with ESMTPA
        id 6XAunC92uUujj6XAvnIOjd; Sun, 09 Jan 2022 13:19:54 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 09 Jan 2022 13:19:54 +0100
X-ME-IP: 90.11.185.88
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] bnx2x: Remove useless DMA-32 fallback configuration
Date:   Sun,  9 Jan 2022 13:19:28 +0100
Message-Id: <29608a525876afddceabf8f11b2ba606da8748fc.1641730747.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As stated in [1], dma_set_mask() with a 64-bit mask never fails if
dev->dma_mask is non-NULL.
So, if it fails, the 32 bits case will also fail for the same reason.

Moreover, dma_set_mask_and_coherent() returns 0 or -EIO, so the return
code of the function can be used directly.

Finally, inline bnx2x_set_coherency_mask() because it is now only a wrapper
for a single dma_set_mask_and_coherent() call.


Simplify code and remove some dead code accordingly.

[1]: https://lkml.org/lkml/2021/6/7/398

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 4953f5e1e390..774c1f1a57c3 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -13044,19 +13044,6 @@ static const struct net_device_ops bnx2x_netdev_ops = {
 	.ndo_features_check	= bnx2x_features_check,
 };
 
-static int bnx2x_set_coherency_mask(struct bnx2x *bp)
-{
-	struct device *dev = &bp->pdev->dev;
-
-	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)) != 0 &&
-	    dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32)) != 0) {
-		dev_err(dev, "System does not support DMA, aborting\n");
-		return -EIO;
-	}
-
-	return 0;
-}
-
 static void bnx2x_disable_pcie_error_reporting(struct bnx2x *bp)
 {
 	if (bp->flags & AER_ENABLED) {
@@ -13134,9 +13121,11 @@ static int bnx2x_init_dev(struct bnx2x *bp, struct pci_dev *pdev,
 		goto err_out_release;
 	}
 
-	rc = bnx2x_set_coherency_mask(bp);
-	if (rc)
+	rc = dma_set_mask_and_coherent(&bp->pdev->dev, DMA_BIT_MASK(64));
+	if (rc) {
+		dev_err(&bp->pdev->dev, "System does not support DMA, aborting\n");
 		goto err_out_release;
+	}
 
 	dev->mem_start = pci_resource_start(pdev, 0);
 	dev->base_addr = dev->mem_start;
-- 
2.32.0

