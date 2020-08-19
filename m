Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6BF32496F8
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgHSHTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:19:12 -0400
Received: from smtp12.smtpout.orange.fr ([80.12.242.134]:33573 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbgHSHTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 03:19:11 -0400
Received: from localhost.localdomain ([92.140.170.113])
        by mwinf5d35 with ME
        id HKK12300E2T8iuL03KK3bd; Wed, 19 Aug 2020 09:19:09 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 19 Aug 2020 09:19:09 +0200
X-ME-IP: 92.140.170.113
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     amitkarwar@gmail.com, ganapathi.bhat@nxp.com,
        huxinming820@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] mwifiex: Clean up some err and dbg messages
Date:   Wed, 19 Aug 2020 09:18:53 +0200
Message-Id: <20200819071853.113185-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error message if 'pci_set_consistent_dma_mask()' fails is misleading.
The function call uses 32 bits, but the error message reports 64.

Moreover, according to the comment above 'dma_set_mask_and_coherent()'
definition, such an error can never happen.

So, simplify code, axe the misleading message and use
'dma_set_mask_and_coherent()' instead of 'dma_set_mask()' +
'dma_set_coherent_mask()'

While at it, make some clean-up:
   - add # when reporting allocated length to be consistent between
     functions
   - s/consistent/coherent/
   - s/unsigned int/u32/ to be consistent between functions
   - align some code

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 25 +++++++++------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 94fe121bc45f..cc6289aaf6c0 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -850,13 +850,14 @@ static int mwifiex_pcie_create_txbd_ring(struct mwifiex_adapter *adapter)
 						   GFP_KERNEL);
 	if (!card->txbd_ring_vbase) {
 		mwifiex_dbg(adapter, ERROR,
-			    "allocate consistent memory (%d bytes) failed!\n",
+			    "allocate coherent memory (%d bytes) failed!\n",
 			    card->txbd_ring_size);
 		return -ENOMEM;
 	}
+
 	mwifiex_dbg(adapter, DATA,
-		    "info: txbd_ring - base: %p, pbase: %#x:%x, len: %x\n",
-		    card->txbd_ring_vbase, (unsigned int)card->txbd_ring_pbase,
+		    "info: txbd_ring - base: %p, pbase: %#x:%x, len: %#x\n",
+		    card->txbd_ring_vbase, (u32)card->txbd_ring_pbase,
 		    (u32)((u64)card->txbd_ring_pbase >> 32),
 		    card->txbd_ring_size);
 
@@ -915,7 +916,7 @@ static int mwifiex_pcie_create_rxbd_ring(struct mwifiex_adapter *adapter)
 						   GFP_KERNEL);
 	if (!card->rxbd_ring_vbase) {
 		mwifiex_dbg(adapter, ERROR,
-			    "allocate consistent memory (%d bytes) failed!\n",
+			    "allocate coherent memory (%d bytes) failed!\n",
 			    card->rxbd_ring_size);
 		return -ENOMEM;
 	}
@@ -973,14 +974,14 @@ static int mwifiex_pcie_create_evtbd_ring(struct mwifiex_adapter *adapter)
 
 	mwifiex_dbg(adapter, INFO,
 		    "info: evtbd_ring: Allocating %d bytes\n",
-		card->evtbd_ring_size);
+		    card->evtbd_ring_size);
 	card->evtbd_ring_vbase = dma_alloc_coherent(&card->dev->dev,
 						    card->evtbd_ring_size,
 						    &card->evtbd_ring_pbase,
 						    GFP_KERNEL);
 	if (!card->evtbd_ring_vbase) {
 		mwifiex_dbg(adapter, ERROR,
-			    "allocate consistent memory (%d bytes) failed!\n",
+			    "allocate coherent memory (%d bytes) failed!\n",
 			    card->evtbd_ring_size);
 		return -ENOMEM;
 	}
@@ -1086,7 +1087,7 @@ static int mwifiex_pcie_alloc_sleep_cookie_buf(struct mwifiex_adapter *adapter)
 						      GFP_KERNEL);
 	if (!card->sleep_cookie_vbase) {
 		mwifiex_dbg(adapter, ERROR,
-			    "pci_alloc_consistent failed!\n");
+			    "dma_alloc_coherent failed!\n");
 		return -ENOMEM;
 	}
 	/* Init val of Sleep Cookie */
@@ -2928,15 +2929,9 @@ static int mwifiex_init_pcie(struct mwifiex_adapter *adapter)
 
 	pci_set_master(pdev);
 
-	ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
-	if (ret) {
-		pr_err("set_dma_mask(32) failed: %d\n", ret);
-		goto err_set_dma_mask;
-	}
-
-	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (ret) {
-		pr_err("set_consistent_dma_mask(64) failed\n");
+		pr_err("dma_set_mask(32) failed: %d\n", ret);
 		goto err_set_dma_mask;
 	}
 
-- 
2.25.1

