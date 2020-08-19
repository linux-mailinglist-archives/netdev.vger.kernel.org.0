Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEE024A82E
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 23:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgHSVJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 17:09:03 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:37062 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbgHSVJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 17:09:01 -0400
Received: from localhost.localdomain ([77.205.40.3])
        by mwinf5d50 with ME
        id HZ8v23004045PnR03Z8vTs; Wed, 19 Aug 2020 23:08:58 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 19 Aug 2020 23:08:58 +0200
X-ME-IP: 77.205.40.3
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     -kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        vaibhavgupta40@gmail.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] rtl818x_pci: switch from 'pci_' to 'dma_' API
Date:   Wed, 19 Aug 2020 23:08:52 +0200
Message-Id: <20200819210852.120826-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'rtl8180_init_rx_ring()' and
'rtl8180_init_tx_ring()' GFP_KERNEL can be used because both functions are
called from 'rtl8180_start()', which is a .start function (see struct
ieee80211_ops)
.start function can sleep, as explicitly stated in include/net/mac80211.h.


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
 .../wireless/realtek/rtl818x/rtl8180/dev.c    | 70 ++++++++++---------
 1 file changed, 37 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
index ba3286f732cc..2477e18c7cae 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
@@ -260,20 +260,20 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 			if (unlikely(!new_skb))
 				goto done;
 
-			mapping = pci_map_single(priv->pdev,
-					       skb_tail_pointer(new_skb),
-					       MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
+			mapping = dma_map_single(&priv->pdev->dev,
+						 skb_tail_pointer(new_skb),
+						 MAX_RX_SIZE, DMA_FROM_DEVICE);
 
-			if (pci_dma_mapping_error(priv->pdev, mapping)) {
+			if (dma_mapping_error(&priv->pdev->dev, mapping)) {
 				kfree_skb(new_skb);
 				dev_err(&priv->pdev->dev, "RX DMA map error\n");
 
 				goto done;
 			}
 
-			pci_unmap_single(priv->pdev,
+			dma_unmap_single(&priv->pdev->dev,
 					 *((dma_addr_t *)skb->cb),
-					 MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
+					 MAX_RX_SIZE, DMA_FROM_DEVICE);
 			skb_put(skb, flags & 0xFFF);
 
 			rx_status.antenna = (flags2 >> 15) & 1;
@@ -355,8 +355,8 @@ static void rtl8180_handle_tx(struct ieee80211_hw *dev, unsigned int prio)
 
 		ring->idx = (ring->idx + 1) % ring->entries;
 		skb = __skb_dequeue(&ring->queue);
-		pci_unmap_single(priv->pdev, le32_to_cpu(entry->tx_buf),
-				 skb->len, PCI_DMA_TODEVICE);
+		dma_unmap_single(&priv->pdev->dev, le32_to_cpu(entry->tx_buf),
+				 skb->len, DMA_TO_DEVICE);
 
 		info = IEEE80211_SKB_CB(skb);
 		ieee80211_tx_info_clear_status(info);
@@ -473,10 +473,10 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
 	prio = skb_get_queue_mapping(skb);
 	ring = &priv->tx_ring[prio];
 
-	mapping = pci_map_single(priv->pdev, skb->data,
-				 skb->len, PCI_DMA_TODEVICE);
+	mapping = dma_map_single(&priv->pdev->dev, skb->data, skb->len,
+				 DMA_TO_DEVICE);
 
-	if (pci_dma_mapping_error(priv->pdev, mapping)) {
+	if (dma_mapping_error(&priv->pdev->dev, mapping)) {
 		kfree_skb(skb);
 		dev_err(&priv->pdev->dev, "TX DMA mapping error\n");
 		return;
@@ -1004,8 +1004,9 @@ static int rtl8180_init_rx_ring(struct ieee80211_hw *dev)
 	else
 		priv->rx_ring_sz = sizeof(struct rtl8180_rx_desc);
 
-	priv->rx_ring = pci_zalloc_consistent(priv->pdev, priv->rx_ring_sz * 32,
-					      &priv->rx_ring_dma);
+	priv->rx_ring = dma_alloc_coherent(&priv->pdev->dev,
+					   priv->rx_ring_sz * 32,
+					   &priv->rx_ring_dma, GFP_KERNEL);
 	if (!priv->rx_ring || (unsigned long)priv->rx_ring & 0xFF) {
 		wiphy_err(dev->wiphy, "Cannot allocate RX ring\n");
 		return -ENOMEM;
@@ -1018,20 +1019,23 @@ static int rtl8180_init_rx_ring(struct ieee80211_hw *dev)
 		dma_addr_t *mapping;
 		entry = priv->rx_ring + priv->rx_ring_sz*i;
 		if (!skb) {
-			pci_free_consistent(priv->pdev, priv->rx_ring_sz * 32,
-					priv->rx_ring, priv->rx_ring_dma);
+			dma_free_coherent(&priv->pdev->dev,
+					  priv->rx_ring_sz * 32,
+					  priv->rx_ring, priv->rx_ring_dma);
 			wiphy_err(dev->wiphy, "Cannot allocate RX skb\n");
 			return -ENOMEM;
 		}
 		priv->rx_buf[i] = skb;
 		mapping = (dma_addr_t *)skb->cb;
-		*mapping = pci_map_single(priv->pdev, skb_tail_pointer(skb),
-					  MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
+		*mapping = dma_map_single(&priv->pdev->dev,
+					  skb_tail_pointer(skb), MAX_RX_SIZE,
+					  DMA_FROM_DEVICE);
 
-		if (pci_dma_mapping_error(priv->pdev, *mapping)) {
+		if (dma_mapping_error(&priv->pdev->dev, *mapping)) {
 			kfree_skb(skb);
-			pci_free_consistent(priv->pdev, priv->rx_ring_sz * 32,
-					priv->rx_ring, priv->rx_ring_dma);
+			dma_free_coherent(&priv->pdev->dev,
+					  priv->rx_ring_sz * 32,
+					  priv->rx_ring, priv->rx_ring_dma);
 			wiphy_err(dev->wiphy, "Cannot map DMA for RX skb\n");
 			return -ENOMEM;
 		}
@@ -1054,14 +1058,13 @@ static void rtl8180_free_rx_ring(struct ieee80211_hw *dev)
 		if (!skb)
 			continue;
 
-		pci_unmap_single(priv->pdev,
-				 *((dma_addr_t *)skb->cb),
-				 MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
+		dma_unmap_single(&priv->pdev->dev, *((dma_addr_t *)skb->cb),
+				 MAX_RX_SIZE, DMA_FROM_DEVICE);
 		kfree_skb(skb);
 	}
 
-	pci_free_consistent(priv->pdev, priv->rx_ring_sz * 32,
-			    priv->rx_ring, priv->rx_ring_dma);
+	dma_free_coherent(&priv->pdev->dev, priv->rx_ring_sz * 32,
+			  priv->rx_ring, priv->rx_ring_dma);
 	priv->rx_ring = NULL;
 }
 
@@ -1073,8 +1076,8 @@ static int rtl8180_init_tx_ring(struct ieee80211_hw *dev,
 	dma_addr_t dma;
 	int i;
 
-	ring = pci_zalloc_consistent(priv->pdev, sizeof(*ring) * entries,
-				     &dma);
+	ring = dma_alloc_coherent(&priv->pdev->dev, sizeof(*ring) * entries,
+				  &dma, GFP_KERNEL);
 	if (!ring || (unsigned long)ring & 0xFF) {
 		wiphy_err(dev->wiphy, "Cannot allocate TX ring (prio = %d)\n",
 			  prio);
@@ -1103,14 +1106,15 @@ static void rtl8180_free_tx_ring(struct ieee80211_hw *dev, unsigned int prio)
 		struct rtl8180_tx_desc *entry = &ring->desc[ring->idx];
 		struct sk_buff *skb = __skb_dequeue(&ring->queue);
 
-		pci_unmap_single(priv->pdev, le32_to_cpu(entry->tx_buf),
-				 skb->len, PCI_DMA_TODEVICE);
+		dma_unmap_single(&priv->pdev->dev, le32_to_cpu(entry->tx_buf),
+				 skb->len, DMA_TO_DEVICE);
 		kfree_skb(skb);
 		ring->idx = (ring->idx + 1) % ring->entries;
 	}
 
-	pci_free_consistent(priv->pdev, sizeof(*ring->desc)*ring->entries,
-			    ring->desc, ring->dma);
+	dma_free_coherent(&priv->pdev->dev,
+			  sizeof(*ring->desc) * ring->entries, ring->desc,
+			  ring->dma);
 	ring->desc = NULL;
 }
 
@@ -1754,8 +1758,8 @@ static int rtl8180_probe(struct pci_dev *pdev,
 		goto err_free_reg;
 	}
 
-	if ((err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) ||
-	    (err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))) {
+	if ((err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) ||
+	    (err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32)))) {
 		printk(KERN_ERR "%s (rtl8180): No suitable DMA available\n",
 		       pci_name(pdev));
 		goto err_free_reg;
-- 
2.25.1

