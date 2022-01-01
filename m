Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9932482846
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 20:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbiAATEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jan 2022 14:04:51 -0500
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:60852 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbiAATEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jan 2022 14:04:50 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id 3jgMnLu6Bbyf93jgMn77BQ; Sat, 01 Jan 2022 20:04:49 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 01 Jan 2022 20:04:49 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jgg@ziepe.ca, davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        tanghui20@huawei.com, gustavoars@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] sun/cassini: Use dma_set_mask_and_coherent() and simplify code
Date:   Sat,  1 Jan 2022 20:04:45 +0100
Message-Id: <9608eda38887c50ac7399ea1b41f977709678ea3.1641063795.git.christophe.jaillet@wanadoo.fr>
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

That said, 'pci_using_dac' can only be 1 after a successful
dma_set_mask_and_coherent().

Simplify code and remove some dead code accordingly.

[1]: https://lkml.org/lkml/2021/6/7/398

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/sun/cassini.c | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index d2d4f47c7e28..dba9f12efa1c 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -4893,8 +4893,8 @@ static int cas_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	unsigned long casreg_len;
 	struct net_device *dev;
 	struct cas *cp;
-	int i, err, pci_using_dac;
 	u16 pci_cmd;
+	int i, err;
 	u8 orig_cacheline_size = 0, cas_cacheline_size = 0;
 
 	if (cas_version_printed++ == 0)
@@ -4965,23 +4965,10 @@ static int cas_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 
 	/* Configure DMA attributes. */
-	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
-		pci_using_dac = 1;
-		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
-		if (err < 0) {
-			dev_err(&pdev->dev, "Unable to obtain 64-bit DMA "
-			       "for consistent allocations\n");
-			goto err_out_free_res;
-		}
-
-	} else {
-		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
-		if (err) {
-			dev_err(&pdev->dev, "No usable DMA configuration, "
-			       "aborting\n");
-			goto err_out_free_res;
-		}
-		pci_using_dac = 0;
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (err) {
+		dev_err(&pdev->dev, "No usable DMA configuration, aborting\n");
+		goto err_out_free_res;
 	}
 
 	casreg_len = pci_resource_len(pdev, 0);
@@ -5087,8 +5074,7 @@ static int cas_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if ((cp->cas_flags & CAS_FLAG_NO_HW_CSUM) == 0)
 		dev->features |= NETIF_F_HW_CSUM | NETIF_F_SG;
 
-	if (pci_using_dac)
-		dev->features |= NETIF_F_HIGHDMA;
+	dev->features |= NETIF_F_HIGHDMA;
 
 	/* MTU range: 60 - varies or 9000 */
 	dev->min_mtu = CAS_MIN_MTU;
-- 
2.32.0

