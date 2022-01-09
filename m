Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3C1488A4B
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 16:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235921AbiAIPl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 10:41:58 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:64102 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235914AbiAIPl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 10:41:58 -0500
Received: from pop-os.home ([90.11.185.88])
        by smtp.orange.fr with ESMTPA
        id 6aKQniyrAIEdl6aKQnROA1; Sun, 09 Jan 2022 16:41:56 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 09 Jan 2022 16:41:56 +0100
X-ME-IP: 90.11.185.88
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Yangbo Lu <yangbo.lu@nxp.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] net: enetc: Remove useless DMA-32 fallback configuration
Date:   Sun,  9 Jan 2022 16:41:43 +0100
Message-Id: <dbecd4eb49a9586ee343b5473dda4b84c42112e9.1641742884.git.christophe.jaillet@wanadoo.fr>
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
 drivers/net/ethernet/freescale/enetc/enetc.c     | 8 ++------
 drivers/net/ethernet/freescale/enetc/enetc_ptp.c | 9 ++-------
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index eacb41f86bdb..d6930a797c6c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2897,12 +2897,8 @@ int enetc_pci_probe(struct pci_dev *pdev, const char *name, int sizeof_priv)
 	/* set up for high or low dma */
 	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (err) {
-		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
-		if (err) {
-			dev_err(&pdev->dev,
-				"DMA configuration failed: 0x%x\n", err);
-			goto err_dma;
-		}
+		dev_err(&pdev->dev, "DMA configuration failed: 0x%x\n", err);
+		goto err_dma;
 	}
 
 	err = pci_request_mem_regions(pdev, name);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ptp.c b/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
index 36b4f51dd297..17c097cef7d4 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ptp.c
@@ -42,15 +42,10 @@ static int enetc_ptp_probe(struct pci_dev *pdev,
 	if (err)
 		return dev_err_probe(&pdev->dev, err, "device enable failed\n");
 
-	/* set up for high or low dma */
 	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (err) {
-		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
-		if (err) {
-			dev_err(&pdev->dev,
-				"DMA configuration failed: 0x%x\n", err);
-			goto err_dma;
-		}
+		dev_err(&pdev->dev, "DMA configuration failed: 0x%x\n", err);
+		goto err_dma;
 	}
 
 	err = pci_request_mem_regions(pdev, KBUILD_MODNAME);
-- 
2.32.0

