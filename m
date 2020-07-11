Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755DC21C62F
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 22:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgGKUf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 16:35:27 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:53497 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgGKUf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 16:35:27 -0400
Received: from localhost.localdomain ([93.22.151.150])
        by mwinf5d51 with ME
        id 1wbK230083Ewh7h03wbLVj; Sat, 11 Jul 2020 22:35:24 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 11 Jul 2020 22:35:24 +0200
X-ME-IP: 93.22.151.150
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     mlindner@marvell.com, stephen@networkplumber.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: skge: switch from 'pci_' to 'dma_' API
Date:   Sat, 11 Jul 2020 22:35:18 +0200
Message-Id: <20200711203518.256545-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below and has been
hand modified to replace GPF_ with a correct flag.
It has been compile tested.

When memory is allocated in 'skge_up()', GFP_KERNEL can be used because
some other memory allocations done a few lines below in 'skge_ring_alloc()'
already use this flag.

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
 drivers/net/ethernet/marvell/skge.c | 76 ++++++++++++++---------------
 1 file changed, 36 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 3c89206f18a7..869392867131 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -939,10 +939,10 @@ static int skge_rx_setup(struct skge_port *skge, struct skge_element *e,
 	struct skge_rx_desc *rd = e->desc;
 	dma_addr_t map;
 
-	map = pci_map_single(skge->hw->pdev, skb->data, bufsize,
-			     PCI_DMA_FROMDEVICE);
+	map = dma_map_single(&skge->hw->pdev->dev, skb->data, bufsize,
+			     DMA_FROM_DEVICE);
 
-	if (pci_dma_mapping_error(skge->hw->pdev, map))
+	if (dma_mapping_error(&skge->hw->pdev->dev, map))
 		return -1;
 
 	rd->dma_lo = lower_32_bits(map);
@@ -990,10 +990,10 @@ static void skge_rx_clean(struct skge_port *skge)
 		struct skge_rx_desc *rd = e->desc;
 		rd->control = 0;
 		if (e->skb) {
-			pci_unmap_single(hw->pdev,
+			dma_unmap_single(&hw->pdev->dev,
 					 dma_unmap_addr(e, mapaddr),
 					 dma_unmap_len(e, maplen),
-					 PCI_DMA_FROMDEVICE);
+					 DMA_FROM_DEVICE);
 			dev_kfree_skb(e->skb);
 			e->skb = NULL;
 		}
@@ -2547,14 +2547,15 @@ static int skge_up(struct net_device *dev)
 	rx_size = skge->rx_ring.count * sizeof(struct skge_rx_desc);
 	tx_size = skge->tx_ring.count * sizeof(struct skge_tx_desc);
 	skge->mem_size = tx_size + rx_size;
-	skge->mem = pci_alloc_consistent(hw->pdev, skge->mem_size, &skge->dma);
+	skge->mem = dma_alloc_coherent(&hw->pdev->dev, skge->mem_size,
+				       &skge->dma, GFP_KERNEL);
 	if (!skge->mem)
 		return -ENOMEM;
 
 	BUG_ON(skge->dma & 7);
 
 	if (upper_32_bits(skge->dma) != upper_32_bits(skge->dma + skge->mem_size)) {
-		dev_err(&hw->pdev->dev, "pci_alloc_consistent region crosses 4G boundary\n");
+		dev_err(&hw->pdev->dev, "dma_alloc_coherent region crosses 4G boundary\n");
 		err = -EINVAL;
 		goto free_pci_mem;
 	}
@@ -2625,7 +2626,8 @@ static int skge_up(struct net_device *dev)
 	skge_rx_clean(skge);
 	kfree(skge->rx_ring.start);
  free_pci_mem:
-	pci_free_consistent(hw->pdev, skge->mem_size, skge->mem, skge->dma);
+	dma_free_coherent(&hw->pdev->dev, skge->mem_size, skge->mem,
+			  skge->dma);
 	skge->mem = NULL;
 
 	return err;
@@ -2715,7 +2717,8 @@ static int skge_down(struct net_device *dev)
 
 	kfree(skge->rx_ring.start);
 	kfree(skge->tx_ring.start);
-	pci_free_consistent(hw->pdev, skge->mem_size, skge->mem, skge->dma);
+	dma_free_coherent(&hw->pdev->dev, skge->mem_size, skge->mem,
+			  skge->dma);
 	skge->mem = NULL;
 	return 0;
 }
@@ -2749,8 +2752,8 @@ static netdev_tx_t skge_xmit_frame(struct sk_buff *skb,
 	BUG_ON(td->control & BMU_OWN);
 	e->skb = skb;
 	len = skb_headlen(skb);
-	map = pci_map_single(hw->pdev, skb->data, len, PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(hw->pdev, map))
+	map = dma_map_single(&hw->pdev->dev, skb->data, len, DMA_TO_DEVICE);
+	if (dma_mapping_error(&hw->pdev->dev, map))
 		goto mapping_error;
 
 	dma_unmap_addr_set(e, mapaddr, map);
@@ -2830,16 +2833,12 @@ static netdev_tx_t skge_xmit_frame(struct sk_buff *skb,
 
 mapping_unwind:
 	e = skge->tx_ring.to_use;
-	pci_unmap_single(hw->pdev,
-			 dma_unmap_addr(e, mapaddr),
-			 dma_unmap_len(e, maplen),
-			 PCI_DMA_TODEVICE);
+	dma_unmap_single(&hw->pdev->dev, dma_unmap_addr(e, mapaddr),
+			 dma_unmap_len(e, maplen), DMA_TO_DEVICE);
 	while (i-- > 0) {
 		e = e->next;
-		pci_unmap_page(hw->pdev,
-			       dma_unmap_addr(e, mapaddr),
-			       dma_unmap_len(e, maplen),
-			       PCI_DMA_TODEVICE);
+		dma_unmap_page(&hw->pdev->dev, dma_unmap_addr(e, mapaddr),
+			       dma_unmap_len(e, maplen), DMA_TO_DEVICE);
 	}
 
 mapping_error:
@@ -2856,13 +2855,11 @@ static inline void skge_tx_unmap(struct pci_dev *pdev, struct skge_element *e,
 {
 	/* skb header vs. fragment */
 	if (control & BMU_STF)
-		pci_unmap_single(pdev, dma_unmap_addr(e, mapaddr),
-				 dma_unmap_len(e, maplen),
-				 PCI_DMA_TODEVICE);
+		dma_unmap_single(&pdev->dev, dma_unmap_addr(e, mapaddr),
+				 dma_unmap_len(e, maplen), DMA_TO_DEVICE);
 	else
-		pci_unmap_page(pdev, dma_unmap_addr(e, mapaddr),
-			       dma_unmap_len(e, maplen),
-			       PCI_DMA_TODEVICE);
+		dma_unmap_page(&pdev->dev, dma_unmap_addr(e, mapaddr),
+			       dma_unmap_len(e, maplen), DMA_TO_DEVICE);
 }
 
 /* Free all buffers in transmit ring */
@@ -3072,15 +3069,15 @@ static struct sk_buff *skge_rx_get(struct net_device *dev,
 		if (!skb)
 			goto resubmit;
 
-		pci_dma_sync_single_for_cpu(skge->hw->pdev,
-					    dma_unmap_addr(e, mapaddr),
-					    dma_unmap_len(e, maplen),
-					    PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_cpu(&skge->hw->pdev->dev,
+					dma_unmap_addr(e, mapaddr),
+					dma_unmap_len(e, maplen),
+					DMA_FROM_DEVICE);
 		skb_copy_from_linear_data(e->skb, skb->data, len);
-		pci_dma_sync_single_for_device(skge->hw->pdev,
-					       dma_unmap_addr(e, mapaddr),
-					       dma_unmap_len(e, maplen),
-					       PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_device(&skge->hw->pdev->dev,
+					   dma_unmap_addr(e, mapaddr),
+					   dma_unmap_len(e, maplen),
+					   DMA_FROM_DEVICE);
 		skge_rx_reuse(e, skge->rx_buf_size);
 	} else {
 		struct skge_element ee;
@@ -3100,10 +3097,9 @@ static struct sk_buff *skge_rx_get(struct net_device *dev,
 			goto resubmit;
 		}
 
-		pci_unmap_single(skge->hw->pdev,
+		dma_unmap_single(&skge->hw->pdev->dev,
 				 dma_unmap_addr(&ee, mapaddr),
-				 dma_unmap_len(&ee, maplen),
-				 PCI_DMA_FROMDEVICE);
+				 dma_unmap_len(&ee, maplen), DMA_FROM_DEVICE);
 	}
 
 	skb_put(skb, len);
@@ -3895,12 +3891,12 @@ static int skge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_master(pdev);
 
-	if (!only_32bit_dma && !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+	if (!only_32bit_dma && !dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
 		using_dac = 1;
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
-	} else if (!(err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))) {
+		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
+	} else if (!(err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32)))) {
 		using_dac = 0;
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 	}
 
 	if (err) {
-- 
2.25.1

