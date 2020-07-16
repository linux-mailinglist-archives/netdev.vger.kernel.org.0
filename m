Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871DD222D32
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 22:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgGPUsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 16:48:18 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:34563 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbgGPUsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 16:48:17 -0400
Received: from localhost.localdomain ([93.22.39.121])
        by mwinf5d12 with ME
        id 3wo8230042cqCS503wo9Tc; Thu, 16 Jul 2020 22:48:14 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 16 Jul 2020 22:48:14 +0200
X-ME-IP: 93.22.39.121
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, jes@trained-monkey.org
Cc:     linux-acenic@sunsite.dk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: alteon: switch from 'pci_' to 'dma_' API
Date:   Thu, 16 Jul 2020 22:48:02 +0200
Message-Id: <20200716204802.326057-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'ace_allocate_descriptors()' and
'ace_init()' GFP_KERNEL can be used because both functions are called from
the probe function and no lock is acquired.


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
 drivers/net/ethernet/alteon/acenic.c | 114 +++++++++++++--------------
 1 file changed, 56 insertions(+), 58 deletions(-)

diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index 5d192d551623..99431c9a899b 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -642,9 +642,8 @@ static void acenic_remove_one(struct pci_dev *pdev)
 
 			ringp = &ap->skb->rx_std_skbuff[i];
 			mapping = dma_unmap_addr(ringp, mapping);
-			pci_unmap_page(ap->pdev, mapping,
-				       ACE_STD_BUFSIZE,
-				       PCI_DMA_FROMDEVICE);
+			dma_unmap_page(&ap->pdev->dev, mapping,
+				       ACE_STD_BUFSIZE, DMA_FROM_DEVICE);
 
 			ap->rx_std_ring[i].size = 0;
 			ap->skb->rx_std_skbuff[i].skb = NULL;
@@ -662,9 +661,9 @@ static void acenic_remove_one(struct pci_dev *pdev)
 
 				ringp = &ap->skb->rx_mini_skbuff[i];
 				mapping = dma_unmap_addr(ringp,mapping);
-				pci_unmap_page(ap->pdev, mapping,
+				dma_unmap_page(&ap->pdev->dev, mapping,
 					       ACE_MINI_BUFSIZE,
-					       PCI_DMA_FROMDEVICE);
+					       DMA_FROM_DEVICE);
 
 				ap->rx_mini_ring[i].size = 0;
 				ap->skb->rx_mini_skbuff[i].skb = NULL;
@@ -681,9 +680,8 @@ static void acenic_remove_one(struct pci_dev *pdev)
 
 			ringp = &ap->skb->rx_jumbo_skbuff[i];
 			mapping = dma_unmap_addr(ringp, mapping);
-			pci_unmap_page(ap->pdev, mapping,
-				       ACE_JUMBO_BUFSIZE,
-				       PCI_DMA_FROMDEVICE);
+			dma_unmap_page(&ap->pdev->dev, mapping,
+				       ACE_JUMBO_BUFSIZE, DMA_FROM_DEVICE);
 
 			ap->rx_jumbo_ring[i].size = 0;
 			ap->skb->rx_jumbo_skbuff[i].skb = NULL;
@@ -713,8 +711,8 @@ static void ace_free_descriptors(struct net_device *dev)
 			 RX_JUMBO_RING_ENTRIES +
 			 RX_MINI_RING_ENTRIES +
 			 RX_RETURN_RING_ENTRIES));
-		pci_free_consistent(ap->pdev, size, ap->rx_std_ring,
-				    ap->rx_ring_base_dma);
+		dma_free_coherent(&ap->pdev->dev, size, ap->rx_std_ring,
+				  ap->rx_ring_base_dma);
 		ap->rx_std_ring = NULL;
 		ap->rx_jumbo_ring = NULL;
 		ap->rx_mini_ring = NULL;
@@ -722,31 +720,30 @@ static void ace_free_descriptors(struct net_device *dev)
 	}
 	if (ap->evt_ring != NULL) {
 		size = (sizeof(struct event) * EVT_RING_ENTRIES);
-		pci_free_consistent(ap->pdev, size, ap->evt_ring,
-				    ap->evt_ring_dma);
+		dma_free_coherent(&ap->pdev->dev, size, ap->evt_ring,
+				  ap->evt_ring_dma);
 		ap->evt_ring = NULL;
 	}
 	if (ap->tx_ring != NULL && !ACE_IS_TIGON_I(ap)) {
 		size = (sizeof(struct tx_desc) * MAX_TX_RING_ENTRIES);
-		pci_free_consistent(ap->pdev, size, ap->tx_ring,
-				    ap->tx_ring_dma);
+		dma_free_coherent(&ap->pdev->dev, size, ap->tx_ring,
+				  ap->tx_ring_dma);
 	}
 	ap->tx_ring = NULL;
 
 	if (ap->evt_prd != NULL) {
-		pci_free_consistent(ap->pdev, sizeof(u32),
-				    (void *)ap->evt_prd, ap->evt_prd_dma);
+		dma_free_coherent(&ap->pdev->dev, sizeof(u32),
+				  (void *)ap->evt_prd, ap->evt_prd_dma);
 		ap->evt_prd = NULL;
 	}
 	if (ap->rx_ret_prd != NULL) {
-		pci_free_consistent(ap->pdev, sizeof(u32),
-				    (void *)ap->rx_ret_prd,
-				    ap->rx_ret_prd_dma);
+		dma_free_coherent(&ap->pdev->dev, sizeof(u32),
+				  (void *)ap->rx_ret_prd, ap->rx_ret_prd_dma);
 		ap->rx_ret_prd = NULL;
 	}
 	if (ap->tx_csm != NULL) {
-		pci_free_consistent(ap->pdev, sizeof(u32),
-				    (void *)ap->tx_csm, ap->tx_csm_dma);
+		dma_free_coherent(&ap->pdev->dev, sizeof(u32),
+				  (void *)ap->tx_csm, ap->tx_csm_dma);
 		ap->tx_csm = NULL;
 	}
 }
@@ -763,8 +760,8 @@ static int ace_allocate_descriptors(struct net_device *dev)
 		 RX_MINI_RING_ENTRIES +
 		 RX_RETURN_RING_ENTRIES));
 
-	ap->rx_std_ring = pci_alloc_consistent(ap->pdev, size,
-					       &ap->rx_ring_base_dma);
+	ap->rx_std_ring = dma_alloc_coherent(&ap->pdev->dev, size,
+					     &ap->rx_ring_base_dma, GFP_KERNEL);
 	if (ap->rx_std_ring == NULL)
 		goto fail;
 
@@ -774,7 +771,8 @@ static int ace_allocate_descriptors(struct net_device *dev)
 
 	size = (sizeof(struct event) * EVT_RING_ENTRIES);
 
-	ap->evt_ring = pci_alloc_consistent(ap->pdev, size, &ap->evt_ring_dma);
+	ap->evt_ring = dma_alloc_coherent(&ap->pdev->dev, size,
+					  &ap->evt_ring_dma, GFP_KERNEL);
 
 	if (ap->evt_ring == NULL)
 		goto fail;
@@ -786,25 +784,25 @@ static int ace_allocate_descriptors(struct net_device *dev)
 	if (!ACE_IS_TIGON_I(ap)) {
 		size = (sizeof(struct tx_desc) * MAX_TX_RING_ENTRIES);
 
-		ap->tx_ring = pci_alloc_consistent(ap->pdev, size,
-						   &ap->tx_ring_dma);
+		ap->tx_ring = dma_alloc_coherent(&ap->pdev->dev, size,
+						 &ap->tx_ring_dma, GFP_KERNEL);
 
 		if (ap->tx_ring == NULL)
 			goto fail;
 	}
 
-	ap->evt_prd = pci_alloc_consistent(ap->pdev, sizeof(u32),
-					   &ap->evt_prd_dma);
+	ap->evt_prd = dma_alloc_coherent(&ap->pdev->dev, sizeof(u32),
+					 &ap->evt_prd_dma, GFP_KERNEL);
 	if (ap->evt_prd == NULL)
 		goto fail;
 
-	ap->rx_ret_prd = pci_alloc_consistent(ap->pdev, sizeof(u32),
-					      &ap->rx_ret_prd_dma);
+	ap->rx_ret_prd = dma_alloc_coherent(&ap->pdev->dev, sizeof(u32),
+					    &ap->rx_ret_prd_dma, GFP_KERNEL);
 	if (ap->rx_ret_prd == NULL)
 		goto fail;
 
-	ap->tx_csm = pci_alloc_consistent(ap->pdev, sizeof(u32),
-					  &ap->tx_csm_dma);
+	ap->tx_csm = dma_alloc_coherent(&ap->pdev->dev, sizeof(u32),
+					&ap->tx_csm_dma, GFP_KERNEL);
 	if (ap->tx_csm == NULL)
 		goto fail;
 
@@ -830,8 +828,8 @@ static void ace_init_cleanup(struct net_device *dev)
 	ace_free_descriptors(dev);
 
 	if (ap->info)
-		pci_free_consistent(ap->pdev, sizeof(struct ace_info),
-				    ap->info, ap->info_dma);
+		dma_free_coherent(&ap->pdev->dev, sizeof(struct ace_info),
+				  ap->info, ap->info_dma);
 	kfree(ap->skb);
 	kfree(ap->trace_buf);
 
@@ -1129,9 +1127,9 @@ static int ace_init(struct net_device *dev)
 	/*
 	 * Configure DMA attributes.
 	 */
-	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
 		ap->pci_using_dac = 1;
-	} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
+	} else if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) {
 		ap->pci_using_dac = 0;
 	} else {
 		ecode = -ENODEV;
@@ -1143,8 +1141,8 @@ static int ace_init(struct net_device *dev)
 	 * and the control blocks for the transmit and receive rings
 	 * as they need to be setup once and for all.
 	 */
-	if (!(info = pci_alloc_consistent(ap->pdev, sizeof(struct ace_info),
-					  &ap->info_dma))) {
+	if (!(info = dma_alloc_coherent(&ap->pdev->dev, sizeof(struct ace_info),
+					&ap->info_dma, GFP_KERNEL))) {
 		ecode = -EAGAIN;
 		goto init_error;
 	}
@@ -1646,10 +1644,10 @@ static void ace_load_std_rx_ring(struct net_device *dev, int nr_bufs)
 		if (!skb)
 			break;
 
-		mapping = pci_map_page(ap->pdev, virt_to_page(skb->data),
+		mapping = dma_map_page(&ap->pdev->dev,
+				       virt_to_page(skb->data),
 				       offset_in_page(skb->data),
-				       ACE_STD_BUFSIZE,
-				       PCI_DMA_FROMDEVICE);
+				       ACE_STD_BUFSIZE, DMA_FROM_DEVICE);
 		ap->skb->rx_std_skbuff[idx].skb = skb;
 		dma_unmap_addr_set(&ap->skb->rx_std_skbuff[idx],
 				   mapping, mapping);
@@ -1707,10 +1705,10 @@ static void ace_load_mini_rx_ring(struct net_device *dev, int nr_bufs)
 		if (!skb)
 			break;
 
-		mapping = pci_map_page(ap->pdev, virt_to_page(skb->data),
+		mapping = dma_map_page(&ap->pdev->dev,
+				       virt_to_page(skb->data),
 				       offset_in_page(skb->data),
-				       ACE_MINI_BUFSIZE,
-				       PCI_DMA_FROMDEVICE);
+				       ACE_MINI_BUFSIZE, DMA_FROM_DEVICE);
 		ap->skb->rx_mini_skbuff[idx].skb = skb;
 		dma_unmap_addr_set(&ap->skb->rx_mini_skbuff[idx],
 				   mapping, mapping);
@@ -1763,10 +1761,10 @@ static void ace_load_jumbo_rx_ring(struct net_device *dev, int nr_bufs)
 		if (!skb)
 			break;
 
-		mapping = pci_map_page(ap->pdev, virt_to_page(skb->data),
+		mapping = dma_map_page(&ap->pdev->dev,
+				       virt_to_page(skb->data),
 				       offset_in_page(skb->data),
-				       ACE_JUMBO_BUFSIZE,
-				       PCI_DMA_FROMDEVICE);
+				       ACE_JUMBO_BUFSIZE, DMA_FROM_DEVICE);
 		ap->skb->rx_jumbo_skbuff[idx].skb = skb;
 		dma_unmap_addr_set(&ap->skb->rx_jumbo_skbuff[idx],
 				   mapping, mapping);
@@ -1977,10 +1975,8 @@ static void ace_rx_int(struct net_device *dev, u32 rxretprd, u32 rxretcsm)
 
 		skb = rip->skb;
 		rip->skb = NULL;
-		pci_unmap_page(ap->pdev,
-			       dma_unmap_addr(rip, mapping),
-			       mapsize,
-			       PCI_DMA_FROMDEVICE);
+		dma_unmap_page(&ap->pdev->dev, dma_unmap_addr(rip, mapping),
+			       mapsize, DMA_FROM_DEVICE);
 		skb_put(skb, retdesc->size);
 
 		/*
@@ -2046,9 +2042,10 @@ static inline void ace_tx_int(struct net_device *dev,
 		skb = info->skb;
 
 		if (dma_unmap_len(info, maplen)) {
-			pci_unmap_page(ap->pdev, dma_unmap_addr(info, mapping),
+			dma_unmap_page(&ap->pdev->dev,
+				       dma_unmap_addr(info, mapping),
 				       dma_unmap_len(info, maplen),
-				       PCI_DMA_TODEVICE);
+				       DMA_TO_DEVICE);
 			dma_unmap_len_set(info, maplen, 0);
 		}
 
@@ -2337,9 +2334,10 @@ static int ace_close(struct net_device *dev)
 			} else
 				memset(ap->tx_ring + i, 0,
 				       sizeof(struct tx_desc));
-			pci_unmap_page(ap->pdev, dma_unmap_addr(info, mapping),
+			dma_unmap_page(&ap->pdev->dev,
+				       dma_unmap_addr(info, mapping),
 				       dma_unmap_len(info, maplen),
-				       PCI_DMA_TODEVICE);
+				       DMA_TO_DEVICE);
 			dma_unmap_len_set(info, maplen, 0);
 		}
 		if (skb) {
@@ -2369,9 +2367,9 @@ ace_map_tx_skb(struct ace_private *ap, struct sk_buff *skb,
 	dma_addr_t mapping;
 	struct tx_ring_info *info;
 
-	mapping = pci_map_page(ap->pdev, virt_to_page(skb->data),
-			       offset_in_page(skb->data),
-			       skb->len, PCI_DMA_TODEVICE);
+	mapping = dma_map_page(&ap->pdev->dev, virt_to_page(skb->data),
+			       offset_in_page(skb->data), skb->len,
+			       DMA_TO_DEVICE);
 
 	info = ap->skb->tx_skbuff + idx;
 	info->skb = tail;
-- 
2.25.1

