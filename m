Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2804827B7
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 15:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbiAAOCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jan 2022 09:02:51 -0500
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:56580 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiAAOCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jan 2022 09:02:50 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id 3ey6ngUjHTdRT3ey6nTwT7; Sat, 01 Jan 2022 15:02:47 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 01 Jan 2022 15:02:47 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     benve@cisco.com, govind@gmx.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] enic: Use dma_set_mask_and_coherent()
Date:   Sat,  1 Jan 2022 15:02:45 +0100
Message-Id: <f926eab883a3e5c4dbfd3eb5108b3e1828e6513b.1641045708.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use dma_set_mask_and_coherent() instead of unrolling it with some
dma_set_mask()+dma_set_coherent_mask().

This simplifies code and removes some dead code (dma_set_coherent_mask()
can not fail after a successful dma_set_mask())

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/cisco/enic/enic_main.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 2faba079b4fb..1c81b161de52 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -2718,26 +2718,14 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * fail to 32-bit.
 	 */
 
-	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(47));
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(47));
 	if (err) {
-		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
+		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 		if (err) {
 			dev_err(dev, "No usable DMA configuration, aborting\n");
 			goto err_out_release_regions;
 		}
-		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
-		if (err) {
-			dev_err(dev, "Unable to obtain %u-bit DMA "
-				"for consistent allocations, aborting\n", 32);
-			goto err_out_release_regions;
-		}
 	} else {
-		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(47));
-		if (err) {
-			dev_err(dev, "Unable to obtain %u-bit DMA "
-				"for consistent allocations, aborting\n", 47);
-			goto err_out_release_regions;
-		}
 		using_dac = 1;
 	}
 
-- 
2.32.0

