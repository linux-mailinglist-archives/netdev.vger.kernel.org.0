Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BAE488A5C
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 16:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbiAIP66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 10:58:58 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:55962 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbiAIP65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 10:58:57 -0500
Received: from pop-os.home ([90.11.185.88])
        by smtp.orange.fr with ESMTPA
        id 6aatnj4tcIEdl6aatnRPiu; Sun, 09 Jan 2022 16:58:55 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 09 Jan 2022 16:58:55 +0100
X-ME-IP: 90.11.185.88
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] hinic: Remove useless DMA-32 fallback configuration
Date:   Sun,  9 Jan 2022 16:57:50 +0100
Message-Id: <23541c28df8d0dcd3663b5dbe0f76af71e70e9cc.1641743855.git.christophe.jaillet@wanadoo.fr>
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
 drivers/net/ethernet/huawei/hinic/hinic_main.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 1e1b1be86174..05329292d940 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -1392,12 +1392,8 @@ static int hinic_probe(struct pci_dev *pdev,
 
 	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (err) {
-		dev_warn(&pdev->dev, "Couldn't set 64-bit DMA mask\n");
-		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
-		if (err) {
-			dev_err(&pdev->dev, "Failed to set DMA mask\n");
-			goto err_dma_mask;
-		}
+		dev_err(&pdev->dev, "Failed to set DMA mask\n");
+		goto err_dma_mask;
 	}
 
 	err = nic_dev_init(pdev);
-- 
2.32.0

