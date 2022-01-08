Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308874883F4
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 15:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234398AbiAHO0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 09:26:11 -0500
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:54046 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiAHO0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 09:26:10 -0500
Received: from pop-os.home ([90.11.185.88])
        by smtp.orange.fr with ESMTPA
        id 6CfYnLecOBazo6CfYn7PvY; Sat, 08 Jan 2022 15:26:09 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 08 Jan 2022 15:26:09 +0100
X-ME-IP: 90.11.185.88
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jes@trained-monkey.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-acenic@sunsite.dk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: alteon: Simplify DMA setting
Date:   Sat,  8 Jan 2022 15:26:06 +0100
Message-Id: <1a414c05c27b21c661aef61dffe1adcd1578b1f5.1641651917.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As stated in [1], dma_set_mask() with a 64-bit mask will never fail if
dev->dma_mask is non-NULL.
So, if it fails, the 32 bits case will also fail for the same reason.

If dma_set_mask_and_coherent() succeeds, 'ap->pci_using_dac' is known to be
1. So 'pci_using_dac' can be removed from the 'struct ace_private'.

Simplify code and remove some dead code accordingly.


[1]: https://lkml.org/lkml/2021/6/7/398

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/alteon/acenic.c | 9 ++-------
 drivers/net/ethernet/alteon/acenic.h | 1 -
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index 732da15a3827..22fe98555b24 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -589,8 +589,7 @@ static int acenic_probe_one(struct pci_dev *pdev,
 	}
 	ap->name = dev->name;
 
-	if (ap->pci_using_dac)
-		dev->features |= NETIF_F_HIGHDMA;
+	dev->features |= NETIF_F_HIGHDMA;
 
 	pci_set_drvdata(pdev, dev);
 
@@ -1130,11 +1129,7 @@ static int ace_init(struct net_device *dev)
 	/*
 	 * Configure DMA attributes.
 	 */
-	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
-		ap->pci_using_dac = 1;
-	} else if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) {
-		ap->pci_using_dac = 0;
-	} else {
+	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
 		ecode = -ENODEV;
 		goto init_error;
 	}
diff --git a/drivers/net/ethernet/alteon/acenic.h b/drivers/net/ethernet/alteon/acenic.h
index 265fa601a258..ca5ce0cbbad1 100644
--- a/drivers/net/ethernet/alteon/acenic.h
+++ b/drivers/net/ethernet/alteon/acenic.h
@@ -692,7 +692,6 @@ struct ace_private
 				__attribute__ ((aligned (SMP_CACHE_BYTES)));
 	u32			last_tx, last_std_rx, last_mini_rx;
 #endif
-	int			pci_using_dac;
 	u8			firmware_major;
 	u8			firmware_minor;
 	u8			firmware_fix;
-- 
2.32.0

