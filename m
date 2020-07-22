Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274E422968D
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 12:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgGVKpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 06:45:46 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:44485 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgGVKpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 06:45:41 -0400
Received: from localhost.localdomain ([93.23.199.134])
        by mwinf5d52 with ME
        id 6Alb2300F2uUVcV03Alca2; Wed, 22 Jul 2020 12:45:37 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 22 Jul 2020 12:45:37 +0200
X-ME-IP: 93.23.199.134
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     mcgrof@kernel.org, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] prism54: switch from 'pci_' to 'dma_' API
Date:   Wed, 22 Jul 2020 12:45:34 +0200
Message-Id: <20200722104534.30760-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'islpci_alloc_memory()' (islpci_dev.c),
GFP_KERNEL can be used because it is only called from a probe function
and no spin_lock is taken in the between.

The call chain is:
   prism54_probe                   (probe function, in 'islpci_hotplug.c')
      --> islpci_setup             (in 'islpci_dev.c')
         --> islpci_alloc_memory   (in 'islpci_dev.c')

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
 .../wireless/intersil/prism54/islpci_dev.c    | 30 +++++++++----------
 .../wireless/intersil/prism54/islpci_eth.c    | 24 +++++++--------
 .../intersil/prism54/islpci_hotplug.c         |  2 +-
 .../wireless/intersil/prism54/islpci_mgt.c    | 21 ++++++-------
 4 files changed, 36 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/intersil/prism54/islpci_dev.c b/drivers/net/wireless/intersil/prism54/islpci_dev.c
index a9bae69222dc..efd64e555bb5 100644
--- a/drivers/net/wireless/intersil/prism54/islpci_dev.c
+++ b/drivers/net/wireless/intersil/prism54/islpci_dev.c
@@ -636,10 +636,10 @@ islpci_alloc_memory(islpci_private *priv)
 	 */
 
 	/* perform the allocation */
-	priv->driver_mem_address = pci_alloc_consistent(priv->pdev,
-							HOST_MEM_BLOCK,
-							&priv->
-							device_host_address);
+	priv->driver_mem_address = dma_alloc_coherent(&priv->pdev->dev,
+						      HOST_MEM_BLOCK,
+						      &priv->device_host_address,
+						      GFP_KERNEL);
 
 	if (!priv->driver_mem_address) {
 		/* error allocating the block of PCI memory */
@@ -692,11 +692,9 @@ islpci_alloc_memory(islpci_private *priv)
 
 		/* map the allocated skb data area to pci */
 		priv->pci_map_rx_address[counter] =
-		    pci_map_single(priv->pdev, (void *) skb->data,
-				   MAX_FRAGMENT_SIZE_RX + 2,
-				   PCI_DMA_FROMDEVICE);
-		if (pci_dma_mapping_error(priv->pdev,
-					  priv->pci_map_rx_address[counter])) {
+		    dma_map_single(&priv->pdev->dev, (void *)skb->data,
+				   MAX_FRAGMENT_SIZE_RX + 2, DMA_FROM_DEVICE);
+		if (dma_mapping_error(&priv->pdev->dev, priv->pci_map_rx_address[counter])) {
 			priv->pci_map_rx_address[counter] = 0;
 			/* error mapping the buffer to device
 			   accessible memory address */
@@ -727,9 +725,9 @@ islpci_free_memory(islpci_private *priv)
 
 	/* free consistent DMA area... */
 	if (priv->driver_mem_address)
-		pci_free_consistent(priv->pdev, HOST_MEM_BLOCK,
-				    priv->driver_mem_address,
-				    priv->device_host_address);
+		dma_free_coherent(&priv->pdev->dev, HOST_MEM_BLOCK,
+				  priv->driver_mem_address,
+				  priv->device_host_address);
 
 	/* clear some dangling pointers */
 	priv->driver_mem_address = NULL;
@@ -741,8 +739,8 @@ islpci_free_memory(islpci_private *priv)
         for (counter = 0; counter < ISL38XX_CB_MGMT_QSIZE; counter++) {
 		struct islpci_membuf *buf = &priv->mgmt_rx[counter];
 		if (buf->pci_addr)
-			pci_unmap_single(priv->pdev, buf->pci_addr,
-					 buf->size, PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&priv->pdev->dev, buf->pci_addr,
+					 buf->size, DMA_FROM_DEVICE);
 		buf->pci_addr = 0;
 		kfree(buf->mem);
 		buf->size = 0;
@@ -752,10 +750,10 @@ islpci_free_memory(islpci_private *priv)
 	/* clean up data rx buffers */
 	for (counter = 0; counter < ISL38XX_CB_RX_QSIZE; counter++) {
 		if (priv->pci_map_rx_address[counter])
-			pci_unmap_single(priv->pdev,
+			dma_unmap_single(&priv->pdev->dev,
 					 priv->pci_map_rx_address[counter],
 					 MAX_FRAGMENT_SIZE_RX + 2,
-					 PCI_DMA_FROMDEVICE);
+					 DMA_FROM_DEVICE);
 		priv->pci_map_rx_address[counter] = 0;
 
 		if (priv->data_low_rx[counter])
diff --git a/drivers/net/wireless/intersil/prism54/islpci_eth.c b/drivers/net/wireless/intersil/prism54/islpci_eth.c
index 8d680250a281..74dd65716afd 100644
--- a/drivers/net/wireless/intersil/prism54/islpci_eth.c
+++ b/drivers/net/wireless/intersil/prism54/islpci_eth.c
@@ -50,9 +50,9 @@ islpci_eth_cleanup_transmit(islpci_private *priv,
 			      skb, skb->data, skb->len, skb->truesize);
 #endif
 
-			pci_unmap_single(priv->pdev,
+			dma_unmap_single(&priv->pdev->dev,
 					 priv->pci_map_tx_address[index],
-					 skb->len, PCI_DMA_TODEVICE);
+					 skb->len, DMA_TO_DEVICE);
 			dev_kfree_skb_irq(skb);
 			skb = NULL;
 		}
@@ -176,10 +176,9 @@ islpci_eth_transmit(struct sk_buff *skb, struct net_device *ndev)
 #endif
 
 	/* map the skb buffer to pci memory for DMA operation */
-	pci_map_address = pci_map_single(priv->pdev,
-					 (void *) skb->data, skb->len,
-					 PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(priv->pdev, pci_map_address)) {
+	pci_map_address = dma_map_single(&priv->pdev->dev, (void *)skb->data,
+					 skb->len, DMA_TO_DEVICE);
+	if (dma_mapping_error(&priv->pdev->dev, pci_map_address)) {
 		printk(KERN_WARNING "%s: cannot map buffer to PCI\n",
 		       ndev->name);
 		goto drop_free;
@@ -323,9 +322,8 @@ islpci_eth_receive(islpci_private *priv)
 #endif
 
 	/* delete the streaming DMA mapping before processing the skb */
-	pci_unmap_single(priv->pdev,
-			 priv->pci_map_rx_address[index],
-			 MAX_FRAGMENT_SIZE_RX + 2, PCI_DMA_FROMDEVICE);
+	dma_unmap_single(&priv->pdev->dev, priv->pci_map_rx_address[index],
+			 MAX_FRAGMENT_SIZE_RX + 2, DMA_FROM_DEVICE);
 
 	/* update the skb structure and align the buffer */
 	skb_put(skb, size);
@@ -431,11 +429,9 @@ islpci_eth_receive(islpci_private *priv)
 
 		/* set the streaming DMA mapping for proper PCI bus operation */
 		priv->pci_map_rx_address[index] =
-		    pci_map_single(priv->pdev, (void *) skb->data,
-				   MAX_FRAGMENT_SIZE_RX + 2,
-				   PCI_DMA_FROMDEVICE);
-		if (pci_dma_mapping_error(priv->pdev,
-					  priv->pci_map_rx_address[index])) {
+		    dma_map_single(&priv->pdev->dev, (void *)skb->data,
+				   MAX_FRAGMENT_SIZE_RX + 2, DMA_FROM_DEVICE);
+		if (dma_mapping_error(&priv->pdev->dev, priv->pci_map_rx_address[index])) {
 			/* error mapping the buffer to device accessible memory address */
 			DEBUG(SHOW_ERROR_MESSAGES,
 			      "Error mapping DMA address\n");
diff --git a/drivers/net/wireless/intersil/prism54/islpci_hotplug.c b/drivers/net/wireless/intersil/prism54/islpci_hotplug.c
index 20291c0d962d..a8835c4507d9 100644
--- a/drivers/net/wireless/intersil/prism54/islpci_hotplug.c
+++ b/drivers/net/wireless/intersil/prism54/islpci_hotplug.c
@@ -106,7 +106,7 @@ prism54_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	/* enable PCI DMA */
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
+	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) {
 		printk(KERN_ERR "%s: 32-bit PCI DMA not supported", DRV_NAME);
 		goto do_pci_disable_device;
         }
diff --git a/drivers/net/wireless/intersil/prism54/islpci_mgt.c b/drivers/net/wireless/intersil/prism54/islpci_mgt.c
index e336eb106429..0c7fb76c7d1c 100644
--- a/drivers/net/wireless/intersil/prism54/islpci_mgt.c
+++ b/drivers/net/wireless/intersil/prism54/islpci_mgt.c
@@ -115,10 +115,11 @@ islpci_mgmt_rx_fill(struct net_device *ndev)
 			buf->size = MGMT_FRAME_SIZE;
 		}
 		if (buf->pci_addr == 0) {
-			buf->pci_addr = pci_map_single(priv->pdev, buf->mem,
+			buf->pci_addr = dma_map_single(&priv->pdev->dev,
+						       buf->mem,
 						       MGMT_FRAME_SIZE,
-						       PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(priv->pdev, buf->pci_addr)) {
+						       DMA_FROM_DEVICE);
+			if (dma_mapping_error(&priv->pdev->dev, buf->pci_addr)) {
 				printk(KERN_WARNING
 				       "Failed to make memory DMA'able.\n");
 				return -ENOMEM;
@@ -203,9 +204,9 @@ islpci_mgt_transmit(struct net_device *ndev, int operation, unsigned long oid,
 #endif
 
 	err = -ENOMEM;
-	buf.pci_addr = pci_map_single(priv->pdev, buf.mem, frag_len,
-				      PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(priv->pdev, buf.pci_addr)) {
+	buf.pci_addr = dma_map_single(&priv->pdev->dev, buf.mem, frag_len,
+				      DMA_TO_DEVICE);
+	if (dma_mapping_error(&priv->pdev->dev, buf.pci_addr)) {
 		printk(KERN_WARNING "%s: cannot map PCI memory for mgmt\n",
 		       ndev->name);
 		goto error_free;
@@ -302,8 +303,8 @@ islpci_mgt_receive(struct net_device *ndev)
 		}
 
 		/* Ensure the results of device DMA are visible to the CPU. */
-		pci_dma_sync_single_for_cpu(priv->pdev, buf->pci_addr,
-					    buf->size, PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_cpu(&priv->pdev->dev, buf->pci_addr,
+					buf->size, DMA_FROM_DEVICE);
 
 		/* Perform endianess conversion for PIMFOR header in-place. */
 		header = pimfor_decode_header(buf->mem, frag_len);
@@ -414,8 +415,8 @@ islpci_mgt_cleanup_transmit(struct net_device *ndev)
 	for (; priv->index_mgmt_tx < curr_frag; priv->index_mgmt_tx++) {
 		int index = priv->index_mgmt_tx % ISL38XX_CB_MGMT_QSIZE;
 		struct islpci_membuf *buf = &priv->mgmt_tx[index];
-		pci_unmap_single(priv->pdev, buf->pci_addr, buf->size,
-				 PCI_DMA_TODEVICE);
+		dma_unmap_single(&priv->pdev->dev, buf->pci_addr, buf->size,
+				 DMA_TO_DEVICE);
 		buf->pci_addr = 0;
 		kfree(buf->mem);
 		buf->mem = NULL;
-- 
2.25.1

