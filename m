Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD9C482AA5
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 10:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbiABJUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 04:20:10 -0500
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:53614 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbiABJUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 04:20:10 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id 3x26n7NltS9NT3x27nETjb; Sun, 02 Jan 2022 10:20:08 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 02 Jan 2022 10:20:08 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] qed: Use dma_set_mask_and_coherent() and simplify code
Date:   Sun,  2 Jan 2022 10:20:05 +0100
Message-Id: <40af8d810ef06bb10f45e54a61494b5c42038841.1641115135.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use dma_set_mask_and_coherent() instead of unrolling it with some
dma_set_mask()+dma_set_coherent_mask().

Moreover, as stated in [1], dma_set_mask() with a 64-bit mask will never
fail if dev->dma_mask is non-NULL.
So, if it fails, the 32 bits case will also fail for the same reason.

Simplify code and remove some dead code accordingly.

Now that qed_set_coherency_mask() is mostly a single call to
dma_set_mask_and_coherent(), fold it in its only caller.

[1]: https://lkml.org/lkml/2021/6/7/398

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 28 ++++------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 46d4207f22a3..c5003fa1a25e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -255,27 +255,6 @@ static void __exit qed_exit(void)
 }
 module_exit(qed_exit);
 
-/* Check if the DMA controller on the machine can properly handle the DMA
- * addressing required by the device.
- */
-static int qed_set_coherency_mask(struct qed_dev *cdev)
-{
-	struct device *dev = &cdev->pdev->dev;
-
-	if (dma_set_mask(dev, DMA_BIT_MASK(64)) == 0) {
-		if (dma_set_coherent_mask(dev, DMA_BIT_MASK(64)) != 0) {
-			DP_NOTICE(cdev,
-				  "Can't request 64-bit consistent allocations\n");
-			return -EIO;
-		}
-	} else if (dma_set_mask(dev, DMA_BIT_MASK(32)) != 0) {
-		DP_NOTICE(cdev, "Can't request 64b/32b DMA addresses\n");
-		return -EIO;
-	}
-
-	return 0;
-}
-
 static void qed_free_pci(struct qed_dev *cdev)
 {
 	struct pci_dev *pdev = cdev->pdev;
@@ -351,9 +330,12 @@ static int qed_init_pci(struct qed_dev *cdev, struct pci_dev *pdev)
 	if (IS_PF(cdev) && !cdev->pci_params.pm_cap)
 		DP_NOTICE(cdev, "Cannot find power management capability\n");
 
-	rc = qed_set_coherency_mask(cdev);
-	if (rc)
+	rc = dma_set_mask_and_coherent(&cdev->pdev->dev, DMA_BIT_MASK(64));
+	if (rc) {
+		DP_NOTICE(cdev, "Can't request DMA addresses\n");
+		rc = -EIO;
 		goto err2;
+	}
 
 	cdev->pci_params.mem_start = pci_resource_start(pdev, 0);
 	cdev->pci_params.mem_end = pci_resource_end(pdev, 0);
-- 
2.32.0

