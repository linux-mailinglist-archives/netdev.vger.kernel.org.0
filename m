Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06EC4888D2
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 12:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbiAILO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 06:14:26 -0500
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:64295 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiAILOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 06:14:25 -0500
Received: from pop-os.home ([90.11.185.88])
        by smtp.orange.fr with ESMTPA
        id 6W9WnFFLj2lVY6W9WnYKn7; Sun, 09 Jan 2022 12:14:23 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 09 Jan 2022 12:14:23 +0100
X-ME-IP: 90.11.185.88
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Mark Einon <mark.einon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] et131x: Remove useless DMA-32 fallback configuration
Date:   Sun,  9 Jan 2022 12:13:47 +0100
Message-Id: <b9aa46e7e5a5aa61f56aac5ea439930f41ad9946.1641726804.git.christophe.jaillet@wanadoo.fr>
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
code of the function can be used directly. There is no need to 'rc = -EIO'
explicitly.


Simplify code and remove some dead code accordingly.

[1]: https://lkml.org/lkml/2021/6/7/398

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/agere/et131x.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/agere/et131x.c b/drivers/net/ethernet/agere/et131x.c
index f4edc616388c..537e6a85e18d 100644
--- a/drivers/net/ethernet/agere/et131x.c
+++ b/drivers/net/ethernet/agere/et131x.c
@@ -3914,10 +3914,9 @@ static int et131x_pci_setup(struct pci_dev *pdev,
 	pci_set_master(pdev);
 
 	/* Check the DMA addressing support of this device */
-	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) &&
-	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))) {
+	rc = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (rc) {
 		dev_err(&pdev->dev, "No usable DMA addressing method\n");
-		rc = -EIO;
 		goto err_release_res;
 	}
 
-- 
2.32.0

