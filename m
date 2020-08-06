Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52BE23E361
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 23:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgHFVEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 17:04:45 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:49389 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgHFVEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 17:04:39 -0400
Received: from localhost.localdomain ([93.22.37.174])
        by mwinf5d46 with ME
        id CM4Z230063lSDvh03M4ZCJ; Thu, 06 Aug 2020 23:04:35 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 06 Aug 2020 23:04:35 +0200
X-ME-IP: 93.22.37.174
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        yuehaibing@huawei.com, vaibhavgupta40@gmail.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] adm8211: switch from 'pci_' to 'dma_' API
Date:   Thu,  6 Aug 2020 23:04:31 +0200
Message-Id: <20200806210431.736050-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'adm8211_alloc_rings()', GFP_KERNEL can be used
because it is called only from the probe function and no lock is acquired.
Moreover, GFP_KERNEL is already used just a few lines above in a kmalloc.

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
 drivers/net/wireless/admtek/adm8211.c | 83 +++++++++++++--------------
 1 file changed, 40 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/admtek/adm8211.c b/drivers/net/wireless/admtek/adm8211.c
index 22f9f2f8af10..5cf2045fadef 100644
--- a/drivers/net/wireless/admtek/adm8211.c
+++ b/drivers/net/wireless/admtek/adm8211.c
@@ -324,8 +324,8 @@ static void adm8211_interrupt_tci(struct ieee80211_hw *dev)
 
 		/* TODO: check TDES0_STATUS_TUF and TDES0_STATUS_TRO */
 
-		pci_unmap_single(priv->pdev, info->mapping,
-				 info->skb->len, PCI_DMA_TODEVICE);
+		dma_unmap_single(&priv->pdev->dev, info->mapping,
+				 info->skb->len, DMA_TO_DEVICE);
 
 		ieee80211_tx_info_clear_status(txi);
 
@@ -382,35 +382,34 @@ static void adm8211_interrupt_rci(struct ieee80211_hw *dev)
 		} else if (pktlen < RX_COPY_BREAK) {
 			skb = dev_alloc_skb(pktlen);
 			if (skb) {
-				pci_dma_sync_single_for_cpu(
-					priv->pdev,
-					priv->rx_buffers[entry].mapping,
-					pktlen, PCI_DMA_FROMDEVICE);
+				dma_sync_single_for_cpu(&priv->pdev->dev,
+							priv->rx_buffers[entry].mapping,
+							pktlen,
+							DMA_FROM_DEVICE);
 				skb_put_data(skb,
 					     skb_tail_pointer(priv->rx_buffers[entry].skb),
 					     pktlen);
-				pci_dma_sync_single_for_device(
-					priv->pdev,
-					priv->rx_buffers[entry].mapping,
-					RX_PKT_SIZE, PCI_DMA_FROMDEVICE);
+				dma_sync_single_for_device(&priv->pdev->dev,
+							   priv->rx_buffers[entry].mapping,
+							   RX_PKT_SIZE,
+							   DMA_FROM_DEVICE);
 			}
 		} else {
 			newskb = dev_alloc_skb(RX_PKT_SIZE);
 			if (newskb) {
 				skb = priv->rx_buffers[entry].skb;
 				skb_put(skb, pktlen);
-				pci_unmap_single(
-					priv->pdev,
-					priv->rx_buffers[entry].mapping,
-					RX_PKT_SIZE, PCI_DMA_FROMDEVICE);
+				dma_unmap_single(&priv->pdev->dev,
+						 priv->rx_buffers[entry].mapping,
+						 RX_PKT_SIZE, DMA_FROM_DEVICE);
 				priv->rx_buffers[entry].skb = newskb;
 				priv->rx_buffers[entry].mapping =
-					pci_map_single(priv->pdev,
+					dma_map_single(&priv->pdev->dev,
 						       skb_tail_pointer(newskb),
 						       RX_PKT_SIZE,
-						       PCI_DMA_FROMDEVICE);
-				if (pci_dma_mapping_error(priv->pdev,
-					   priv->rx_buffers[entry].mapping)) {
+						       DMA_FROM_DEVICE);
+				if (dma_mapping_error(&priv->pdev->dev,
+						      priv->rx_buffers[entry].mapping)) {
 					priv->rx_buffers[entry].skb = NULL;
 					dev_kfree_skb(newskb);
 					skb = NULL;
@@ -1449,11 +1448,11 @@ static int adm8211_init_rings(struct ieee80211_hw *dev)
 		rx_info->skb = dev_alloc_skb(RX_PKT_SIZE);
 		if (rx_info->skb == NULL)
 			break;
-		rx_info->mapping = pci_map_single(priv->pdev,
+		rx_info->mapping = dma_map_single(&priv->pdev->dev,
 						  skb_tail_pointer(rx_info->skb),
 						  RX_PKT_SIZE,
-						  PCI_DMA_FROMDEVICE);
-		if (pci_dma_mapping_error(priv->pdev, rx_info->mapping)) {
+						  DMA_FROM_DEVICE);
+		if (dma_mapping_error(&priv->pdev->dev, rx_info->mapping)) {
 			dev_kfree_skb(rx_info->skb);
 			rx_info->skb = NULL;
 			break;
@@ -1490,10 +1489,9 @@ static void adm8211_free_rings(struct ieee80211_hw *dev)
 		if (!priv->rx_buffers[i].skb)
 			continue;
 
-		pci_unmap_single(
-			priv->pdev,
-			priv->rx_buffers[i].mapping,
-			RX_PKT_SIZE, PCI_DMA_FROMDEVICE);
+		dma_unmap_single(&priv->pdev->dev,
+				 priv->rx_buffers[i].mapping, RX_PKT_SIZE,
+				 DMA_FROM_DEVICE);
 
 		dev_kfree_skb(priv->rx_buffers[i].skb);
 	}
@@ -1502,10 +1500,9 @@ static void adm8211_free_rings(struct ieee80211_hw *dev)
 		if (!priv->tx_buffers[i].skb)
 			continue;
 
-		pci_unmap_single(priv->pdev,
+		dma_unmap_single(&priv->pdev->dev,
 				 priv->tx_buffers[i].mapping,
-				 priv->tx_buffers[i].skb->len,
-				 PCI_DMA_TODEVICE);
+				 priv->tx_buffers[i].skb->len, DMA_TO_DEVICE);
 
 		dev_kfree_skb(priv->tx_buffers[i].skb);
 	}
@@ -1632,9 +1629,9 @@ static int adm8211_tx_raw(struct ieee80211_hw *dev, struct sk_buff *skb,
 	unsigned int entry;
 	u32 flag;
 
-	mapping = pci_map_single(priv->pdev, skb->data, skb->len,
-				 PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(priv->pdev, mapping))
+	mapping = dma_map_single(&priv->pdev->dev, skb->data, skb->len,
+				 DMA_TO_DEVICE);
+	if (dma_mapping_error(&priv->pdev->dev, mapping))
 		return -ENOMEM;
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -1745,8 +1742,8 @@ static int adm8211_alloc_rings(struct ieee80211_hw *dev)
 	/* Allocate TX/RX descriptors */
 	ring_size = sizeof(struct adm8211_desc) * priv->rx_ring_size +
 		    sizeof(struct adm8211_desc) * priv->tx_ring_size;
-	priv->rx_ring = pci_alloc_consistent(priv->pdev, ring_size,
-					     &priv->rx_ring_dma);
+	priv->rx_ring = dma_alloc_coherent(&priv->pdev->dev, ring_size,
+					   &priv->rx_ring_dma, GFP_KERNEL);
 
 	if (!priv->rx_ring) {
 		kfree(priv->rx_buffers);
@@ -1818,8 +1815,8 @@ static int adm8211_probe(struct pci_dev *pdev,
 		return err; /* someone else grabbed it? don't disable it */
 	}
 
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) ||
-	    pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
+	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(32)) ||
+	    dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32))) {
 		printk(KERN_ERR "%s (adm8211): No suitable DMA available\n",
 		       pci_name(pdev));
 		goto err_free_reg;
@@ -1929,10 +1926,10 @@ static int adm8211_probe(struct pci_dev *pdev,
 	kfree(priv->eeprom);
 
  err_free_desc:
-	pci_free_consistent(pdev,
-			    sizeof(struct adm8211_desc) * priv->rx_ring_size +
-			    sizeof(struct adm8211_desc) * priv->tx_ring_size,
-			    priv->rx_ring, priv->rx_ring_dma);
+	dma_free_coherent(&pdev->dev,
+			  sizeof(struct adm8211_desc) * priv->rx_ring_size +
+			  sizeof(struct adm8211_desc) * priv->tx_ring_size,
+			  priv->rx_ring, priv->rx_ring_dma);
 	kfree(priv->rx_buffers);
 
  err_iounmap:
@@ -1962,10 +1959,10 @@ static void adm8211_remove(struct pci_dev *pdev)
 
 	priv = dev->priv;
 
-	pci_free_consistent(pdev,
-			    sizeof(struct adm8211_desc) * priv->rx_ring_size +
-			    sizeof(struct adm8211_desc) * priv->tx_ring_size,
-			    priv->rx_ring, priv->rx_ring_dma);
+	dma_free_coherent(&pdev->dev,
+			  sizeof(struct adm8211_desc) * priv->rx_ring_size +
+			  sizeof(struct adm8211_desc) * priv->tx_ring_size,
+			  priv->rx_ring, priv->rx_ring_dma);
 
 	kfree(priv->rx_buffers);
 	kfree(priv->eeprom);
-- 
2.25.1

