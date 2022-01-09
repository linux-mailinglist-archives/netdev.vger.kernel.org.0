Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD59488A62
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 17:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235975AbiAIQEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 11:04:52 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:59156 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbiAIQEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 11:04:52 -0500
Received: from pop-os.home ([90.11.185.88])
        by smtp.orange.fr with ESMTPA
        id 6agcnj72KIEdl6agcnRQHw; Sun, 09 Jan 2022 17:04:51 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 09 Jan 2022 17:04:51 +0100
X-ME-IP: 90.11.185.88
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] rocker: Remove useless DMA-32 fallback configuration
Date:   Sun,  9 Jan 2022 17:04:48 +0100
Message-Id: <9ba2d13099d216f3df83e50ad33a05504c90fe7c.1641744274.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As stated in [1], dma_set_mask() with a 64-bit mask never fails if
dev->dma_mask is non-NULL.
So, if it fails, the 32 bits case will also fail for the same reason.

Simplify code and remove some dead code accordingly.

[1]: https://lkml.org/lkml/2021/6/7/398

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/rocker/rocker_main.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index b620470c7905..3fcea211716c 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2870,19 +2870,10 @@ static int rocker_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_pci_request_regions;
 	}
 
-	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
-	if (!err) {
-		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
-		if (err) {
-			dev_err(&pdev->dev, "dma_set_coherent_mask failed\n");
-			goto err_pci_set_dma_mask;
-		}
-	} else {
-		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
-		if (err) {
-			dev_err(&pdev->dev, "dma_set_mask failed\n");
-			goto err_pci_set_dma_mask;
-		}
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (err) {
+		dev_err(&pdev->dev, "dma_set_mask failed\n");
+		goto err_pci_set_dma_mask;
 	}
 
 	if (pci_resource_len(pdev, 0) < ROCKER_PCI_BAR0_SIZE) {
-- 
2.32.0

