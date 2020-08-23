Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19BB24EBC3
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 08:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgHWGMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 02:12:02 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:57285 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbgHWGMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 02:12:01 -0400
Received: from localhost.localdomain ([93.22.133.217])
        by mwinf5d33 with ME
        id JuBt230054hbG4l03uBtgt; Sun, 23 Aug 2020 08:11:57 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 23 Aug 2020 08:11:57 +0200
X-ME-IP: 93.22.133.217
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     dave@thedillows.org, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] typhoon: switch from 'pci_' to 'dma_' API
Date:   Sun, 23 Aug 2020 08:11:50 +0200
Message-Id: <20200823061150.162135-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below and has been
hand modified to replace GFP_ with a correct flag.
It has been compile tested.

When memory is allocated in 'typhoon_init_one()' GFP_KERNEL can be used
because it is a probe function and no lock is acquired.

When memory is allocated in 'typhoon_download_firmware()', GFP_ATOMIC
must be used because it can be called from a .ndo_tx_timeout function.
So this function can be called with the 'netif_tx_lock' acquired.
The call chain is:
  --> typhoon_tx_timeout                 (.ndo_tx_timeout function)
    --> typhoon_start_runtime
      --> typhoon_download_firmware

While at is, update some comments accordingly.


@@
@@
-    PCI_DMA_BIDIRECTIONAL
+    DMA_BIDIRECTIONAL

@@
@@
-    PCI_DMA_TODEVICE
+    DMA_TO_DEVICE

@@
@@
-    PCI_DMA_FROMDEVICE
+    DMA_FROM_DEVICE

@@
@@
-    PCI_DMA_NONE
+    DMA_NONE

@@
expression e1, e2, e3;
@@
-    pci_alloc_consistent(e1, e2, e3)
+    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)

@@
expression e1, e2, e3;
@@
-    pci_zalloc_consistent(e1, e2, e3)
+    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)

@@
expression e1, e2, e3, e4;
@@
-    pci_free_consistent(e1, e2, e3, e4)
+    dma_free_coherent(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_map_single(e1, e2, e3, e4)
+    dma_map_single(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_single(e1, e2, e3, e4)
+    dma_unmap_single(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4, e5;
@@
-    pci_map_page(e1, e2, e3, e4, e5)
+    dma_map_page(&e1->dev, e2, e3, e4, e5)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_page(e1, e2, e3, e4)
+    dma_unmap_page(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_map_sg(e1, e2, e3, e4)
+    dma_map_sg(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_sg(e1, e2, e3, e4)
+    dma_unmap_sg(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_single_for_cpu(e1, e2, e3, e4)
+    dma_sync_single_for_cpu(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_single_for_device(e1, e2, e3, e4)
+    dma_sync_single_for_device(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_sg_for_cpu(e1, e2, e3, e4)
+    dma_sync_sg_for_cpu(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_sg_for_device(e1, e2, e3, e4)
+    dma_sync_sg_for_device(&e1->dev, e2, e3, e4)

@@
expression e1, e2;
@@
-    pci_dma_mapping_error(e1, e2)
+    dma_mapping_error(&e1->dev, e2)

@@
expression e1, e2;
@@
-    pci_set_dma_mask(e1, e2)
+    dma_set_mask(&e1->dev, e2)

@@
expression e1, e2;
@@
-    pci_set_consistent_dma_mask(e1, e2)
+    dma_set_coherent_mask(&e1->dev, e2)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
If needed, see post from Christoph Hellwig on the kernel-janitors ML:
   https://marc.info/?l=kernel-janitors&m=158745678307186&w=4
---
 drivers/net/ethernet/3com/typhoon.c | 61 ++++++++++++++---------------
 1 file changed, 30 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index d3b30bacc94e..f11474cac59f 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -789,8 +789,8 @@ typhoon_start_tx(struct sk_buff *skb, struct net_device *dev)
 	 * it with zeros to ETH_ZLEN for us.
 	 */
 	if (skb_shinfo(skb)->nr_frags == 0) {
-		skb_dma = pci_map_single(tp->tx_pdev, skb->data, skb->len,
-				       PCI_DMA_TODEVICE);
+		skb_dma = dma_map_single(&tp->tx_pdev->dev, skb->data,
+					 skb->len, DMA_TO_DEVICE);
 		txd->flags = TYPHOON_FRAG_DESC | TYPHOON_DESC_VALID;
 		txd->len = cpu_to_le16(skb->len);
 		txd->frag.addr = cpu_to_le32(skb_dma);
@@ -800,8 +800,8 @@ typhoon_start_tx(struct sk_buff *skb, struct net_device *dev)
 		int i, len;
 
 		len = skb_headlen(skb);
-		skb_dma = pci_map_single(tp->tx_pdev, skb->data, len,
-				         PCI_DMA_TODEVICE);
+		skb_dma = dma_map_single(&tp->tx_pdev->dev, skb->data, len,
+					 DMA_TO_DEVICE);
 		txd->flags = TYPHOON_FRAG_DESC | TYPHOON_DESC_VALID;
 		txd->len = cpu_to_le16(len);
 		txd->frag.addr = cpu_to_le32(skb_dma);
@@ -818,8 +818,8 @@ typhoon_start_tx(struct sk_buff *skb, struct net_device *dev)
 
 			len = skb_frag_size(frag);
 			frag_addr = skb_frag_address(frag);
-			skb_dma = pci_map_single(tp->tx_pdev, frag_addr, len,
-					 PCI_DMA_TODEVICE);
+			skb_dma = dma_map_single(&tp->tx_pdev->dev, frag_addr,
+						 len, DMA_TO_DEVICE);
 			txd->flags = TYPHOON_FRAG_DESC | TYPHOON_DESC_VALID;
 			txd->len = cpu_to_le16(len);
 			txd->frag.addr = cpu_to_le32(skb_dma);
@@ -1349,12 +1349,12 @@ typhoon_download_firmware(struct typhoon *tp)
 	image_data = typhoon_fw->data;
 	fHdr = (struct typhoon_file_header *) image_data;
 
-	/* Cannot just map the firmware image using pci_map_single() as
+	/* Cannot just map the firmware image using dma_map_single() as
 	 * the firmware is vmalloc()'d and may not be physically contiguous,
-	 * so we allocate some consistent memory to copy the sections into.
+	 * so we allocate some coherent memory to copy the sections into.
 	 */
 	err = -ENOMEM;
-	dpage = pci_alloc_consistent(pdev, PAGE_SIZE, &dpage_dma);
+	dpage = dma_alloc_coherent(&pdev->dev, PAGE_SIZE, &dpage_dma, GFP_ATOMIC);
 	if (!dpage) {
 		netdev_err(tp->dev, "no DMA mem for firmware\n");
 		goto err_out;
@@ -1460,7 +1460,7 @@ typhoon_download_firmware(struct typhoon *tp)
 	iowrite32(irqMasked, ioaddr + TYPHOON_REG_INTR_MASK);
 	iowrite32(irqEnabled, ioaddr + TYPHOON_REG_INTR_ENABLE);
 
-	pci_free_consistent(pdev, PAGE_SIZE, dpage, dpage_dma);
+	dma_free_coherent(&pdev->dev, PAGE_SIZE, dpage, dpage_dma);
 
 err_out:
 	return err;
@@ -1527,8 +1527,8 @@ typhoon_clean_tx(struct typhoon *tp, struct transmit_ring *txRing,
 			 */
 			skb_dma = (dma_addr_t) le32_to_cpu(tx->frag.addr);
 			dma_len = le16_to_cpu(tx->len);
-			pci_unmap_single(tp->pdev, skb_dma, dma_len,
-				       PCI_DMA_TODEVICE);
+			dma_unmap_single(&tp->pdev->dev, skb_dma, dma_len,
+					 DMA_TO_DEVICE);
 		}
 
 		tx->flags = 0;
@@ -1609,8 +1609,8 @@ typhoon_alloc_rx_skb(struct typhoon *tp, u32 idx)
 	skb_reserve(skb, 2);
 #endif
 
-	dma_addr = pci_map_single(tp->pdev, skb->data,
-				  PKT_BUF_SZ, PCI_DMA_FROMDEVICE);
+	dma_addr = dma_map_single(&tp->pdev->dev, skb->data, PKT_BUF_SZ,
+				  DMA_FROM_DEVICE);
 
 	/* Since no card does 64 bit DAC, the high bits will never
 	 * change from zero.
@@ -1665,20 +1665,19 @@ typhoon_rx(struct typhoon *tp, struct basic_ring *rxRing, volatile __le32 * read
 		if (pkt_len < rx_copybreak &&
 		   (new_skb = netdev_alloc_skb(tp->dev, pkt_len + 2)) != NULL) {
 			skb_reserve(new_skb, 2);
-			pci_dma_sync_single_for_cpu(tp->pdev, dma_addr,
-						    PKT_BUF_SZ,
-						    PCI_DMA_FROMDEVICE);
+			dma_sync_single_for_cpu(&tp->pdev->dev, dma_addr,
+						PKT_BUF_SZ, DMA_FROM_DEVICE);
 			skb_copy_to_linear_data(new_skb, skb->data, pkt_len);
-			pci_dma_sync_single_for_device(tp->pdev, dma_addr,
-						       PKT_BUF_SZ,
-						       PCI_DMA_FROMDEVICE);
+			dma_sync_single_for_device(&tp->pdev->dev, dma_addr,
+						   PKT_BUF_SZ,
+						   DMA_FROM_DEVICE);
 			skb_put(new_skb, pkt_len);
 			typhoon_recycle_rx_skb(tp, idx);
 		} else {
 			new_skb = skb;
 			skb_put(new_skb, pkt_len);
-			pci_unmap_single(tp->pdev, dma_addr, PKT_BUF_SZ,
-				       PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&tp->pdev->dev, dma_addr, PKT_BUF_SZ,
+					 DMA_FROM_DEVICE);
 			typhoon_alloc_rx_skb(tp, idx);
 		}
 		new_skb->protocol = eth_type_trans(new_skb, tp->dev);
@@ -1792,8 +1791,8 @@ typhoon_free_rx_rings(struct typhoon *tp)
 	for (i = 0; i < RXENT_ENTRIES; i++) {
 		struct rxbuff_ent *rxb = &tp->rxbuffers[i];
 		if (rxb->skb) {
-			pci_unmap_single(tp->pdev, rxb->dma_addr, PKT_BUF_SZ,
-				       PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&tp->pdev->dev, rxb->dma_addr,
+					 PKT_BUF_SZ, DMA_FROM_DEVICE);
 			dev_kfree_skb(rxb->skb);
 			rxb->skb = NULL;
 		}
@@ -2306,7 +2305,7 @@ typhoon_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto error_out_disable;
 	}
 
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (err < 0) {
 		err_msg = "No usable DMA configuration";
 		goto error_out_mwi;
@@ -2355,8 +2354,8 @@ typhoon_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* allocate pci dma space for rx and tx descriptor rings
 	 */
-	shared = pci_alloc_consistent(pdev, sizeof(struct typhoon_shared),
-				      &shared_dma);
+	shared = dma_alloc_coherent(&pdev->dev, sizeof(struct typhoon_shared),
+				    &shared_dma, GFP_KERNEL);
 	if (!shared) {
 		err_msg = "could not allocate DMA memory";
 		err = -ENOMEM;
@@ -2509,8 +2508,8 @@ typhoon_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	typhoon_reset(ioaddr, NoWait);
 
 error_out_dma:
-	pci_free_consistent(pdev, sizeof(struct typhoon_shared),
-			    shared, shared_dma);
+	dma_free_coherent(&pdev->dev, sizeof(struct typhoon_shared), shared,
+			  shared_dma);
 error_out_remap:
 	pci_iounmap(pdev, ioaddr);
 error_out_regions:
@@ -2537,8 +2536,8 @@ typhoon_remove_one(struct pci_dev *pdev)
 	pci_restore_state(pdev);
 	typhoon_reset(tp->ioaddr, NoWait);
 	pci_iounmap(pdev, tp->ioaddr);
-	pci_free_consistent(pdev, sizeof(struct typhoon_shared),
-			    tp->shared, tp->shared_dma);
+	dma_free_coherent(&pdev->dev, sizeof(struct typhoon_shared),
+			  tp->shared, tp->shared_dma);
 	pci_release_regions(pdev);
 	pci_clear_mwi(pdev);
 	pci_disable_device(pdev);
-- 
2.25.1

