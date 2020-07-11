Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9394F21C63D
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 22:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgGKUtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 16:49:51 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:40248 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbgGKUtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 16:49:51 -0400
Received: from localhost.localdomain ([93.22.151.150])
        by mwinf5d51 with ME
        id 1wpm2300E3Ewh7h03wpn2a; Sat, 11 Jul 2020 22:49:47 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 11 Jul 2020 22:49:47 +0200
X-ME-IP: 93.22.151.150
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     mlindner@marvell.com, stephen@networkplumber.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: sky2: switch from 'pci_' to 'dma_' API
Date:   Sat, 11 Jul 2020 22:49:44 +0200
Message-Id: <20200711204944.259152-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'sky2_alloc_buffers()', GFP_KERNEL can be used
because some other memory allocations in the same function already use this
flag.

When memory is allocated in 'sky2_probe()', GFP_KERNEL can be used
because another memory allocations in the same function already uses this
flag.


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
 drivers/net/ethernet/marvell/sky2.c | 89 +++++++++++++++--------------
 1 file changed, 46 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index fe54764caea9..adb1a9c19505 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -1209,8 +1209,9 @@ static int sky2_rx_map_skb(struct pci_dev *pdev, struct rx_ring_info *re,
 	struct sk_buff *skb = re->skb;
 	int i;
 
-	re->data_addr = pci_map_single(pdev, skb->data, size, PCI_DMA_FROMDEVICE);
-	if (pci_dma_mapping_error(pdev, re->data_addr))
+	re->data_addr = dma_map_single(&pdev->dev, skb->data, size,
+				       DMA_FROM_DEVICE);
+	if (dma_mapping_error(&pdev->dev, re->data_addr))
 		goto mapping_error;
 
 	dma_unmap_len_set(re, data_size, size);
@@ -1229,13 +1230,13 @@ static int sky2_rx_map_skb(struct pci_dev *pdev, struct rx_ring_info *re,
 
 map_page_error:
 	while (--i >= 0) {
-		pci_unmap_page(pdev, re->frag_addr[i],
+		dma_unmap_page(&pdev->dev, re->frag_addr[i],
 			       skb_frag_size(&skb_shinfo(skb)->frags[i]),
-			       PCI_DMA_FROMDEVICE);
+			       DMA_FROM_DEVICE);
 	}
 
-	pci_unmap_single(pdev, re->data_addr, dma_unmap_len(re, data_size),
-			 PCI_DMA_FROMDEVICE);
+	dma_unmap_single(&pdev->dev, re->data_addr,
+			 dma_unmap_len(re, data_size), DMA_FROM_DEVICE);
 
 mapping_error:
 	if (net_ratelimit())
@@ -1249,13 +1250,13 @@ static void sky2_rx_unmap_skb(struct pci_dev *pdev, struct rx_ring_info *re)
 	struct sk_buff *skb = re->skb;
 	int i;
 
-	pci_unmap_single(pdev, re->data_addr, dma_unmap_len(re, data_size),
-			 PCI_DMA_FROMDEVICE);
+	dma_unmap_single(&pdev->dev, re->data_addr,
+			 dma_unmap_len(re, data_size), DMA_FROM_DEVICE);
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
-		pci_unmap_page(pdev, re->frag_addr[i],
-			       skb_frag_size(&skb_shinfo(skb)->frags[i]),
-			       PCI_DMA_FROMDEVICE);
+		dma_unmap_page(&pdev->dev, re->frag_addr[i],
+			       skb_frag_size(&skb_shinfo(skb)->frags[i]),
+			       DMA_FROM_DEVICE);
 }
 
 /* Tell chip where to start receive checksum.
@@ -1592,10 +1593,9 @@ static int sky2_alloc_buffers(struct sky2_port *sky2)
 	struct sky2_hw *hw = sky2->hw;
 
 	/* must be power of 2 */
-	sky2->tx_le = pci_alloc_consistent(hw->pdev,
-					   sky2->tx_ring_size *
-					   sizeof(struct sky2_tx_le),
-					   &sky2->tx_le_map);
+	sky2->tx_le = dma_alloc_coherent(&hw->pdev->dev,
+					 sky2->tx_ring_size * sizeof(struct sky2_tx_le),
+					 &sky2->tx_le_map, GFP_KERNEL);
 	if (!sky2->tx_le)
 		goto nomem;
 
@@ -1604,8 +1604,8 @@ static int sky2_alloc_buffers(struct sky2_port *sky2)
 	if (!sky2->tx_ring)
 		goto nomem;
 
-	sky2->rx_le = pci_zalloc_consistent(hw->pdev, RX_LE_BYTES,
-					    &sky2->rx_le_map);
+	sky2->rx_le = dma_alloc_coherent(&hw->pdev->dev, RX_LE_BYTES,
+					 &sky2->rx_le_map, GFP_KERNEL);
 	if (!sky2->rx_le)
 		goto nomem;
 
@@ -1626,14 +1626,14 @@ static void sky2_free_buffers(struct sky2_port *sky2)
 	sky2_rx_clean(sky2);
 
 	if (sky2->rx_le) {
-		pci_free_consistent(hw->pdev, RX_LE_BYTES,
-				    sky2->rx_le, sky2->rx_le_map);
+		dma_free_coherent(&hw->pdev->dev, RX_LE_BYTES, sky2->rx_le,
+				  sky2->rx_le_map);
 		sky2->rx_le = NULL;
 	}
 	if (sky2->tx_le) {
-		pci_free_consistent(hw->pdev,
-				    sky2->tx_ring_size * sizeof(struct sky2_tx_le),
-				    sky2->tx_le, sky2->tx_le_map);
+		dma_free_coherent(&hw->pdev->dev,
+				  sky2->tx_ring_size * sizeof(struct sky2_tx_le),
+				  sky2->tx_le, sky2->tx_le_map);
 		sky2->tx_le = NULL;
 	}
 	kfree(sky2->tx_ring);
@@ -1806,13 +1806,11 @@ static unsigned tx_le_req(const struct sk_buff *skb)
 static void sky2_tx_unmap(struct pci_dev *pdev, struct tx_ring_info *re)
 {
 	if (re->flags & TX_MAP_SINGLE)
-		pci_unmap_single(pdev, dma_unmap_addr(re, mapaddr),
-				 dma_unmap_len(re, maplen),
-				 PCI_DMA_TODEVICE);
+		dma_unmap_single(&pdev->dev, dma_unmap_addr(re, mapaddr),
+				 dma_unmap_len(re, maplen), DMA_TO_DEVICE);
 	else if (re->flags & TX_MAP_PAGE)
-		pci_unmap_page(pdev, dma_unmap_addr(re, mapaddr),
-			       dma_unmap_len(re, maplen),
-			       PCI_DMA_TODEVICE);
+		dma_unmap_page(&pdev->dev, dma_unmap_addr(re, mapaddr),
+			       dma_unmap_len(re, maplen), DMA_TO_DEVICE);
 	re->flags = 0;
 }
 
@@ -1840,9 +1838,10 @@ static netdev_tx_t sky2_xmit_frame(struct sk_buff *skb,
   		return NETDEV_TX_BUSY;
 
 	len = skb_headlen(skb);
-	mapping = pci_map_single(hw->pdev, skb->data, len, PCI_DMA_TODEVICE);
+	mapping = dma_map_single(&hw->pdev->dev, skb->data, len,
+				 DMA_TO_DEVICE);
 
-	if (pci_dma_mapping_error(hw->pdev, mapping))
+	if (dma_mapping_error(&hw->pdev->dev, mapping))
 		goto mapping_error;
 
 	slot = sky2->tx_prod;
@@ -2464,16 +2463,17 @@ static struct sk_buff *receive_copy(struct sky2_port *sky2,
 
 	skb = netdev_alloc_skb_ip_align(sky2->netdev, length);
 	if (likely(skb)) {
-		pci_dma_sync_single_for_cpu(sky2->hw->pdev, re->data_addr,
-					    length, PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_cpu(&sky2->hw->pdev->dev, re->data_addr,
+					length, DMA_FROM_DEVICE);
 		skb_copy_from_linear_data(re->skb, skb->data, length);
 		skb->ip_summed = re->skb->ip_summed;
 		skb->csum = re->skb->csum;
 		skb_copy_hash(skb, re->skb);
 		__vlan_hwaccel_copy_tag(skb, re->skb);
 
-		pci_dma_sync_single_for_device(sky2->hw->pdev, re->data_addr,
-					       length, PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_device(&sky2->hw->pdev->dev,
+					   re->data_addr, length,
+					   DMA_FROM_DEVICE);
 		__vlan_hwaccel_clear_tag(re->skb);
 		skb_clear_hash(re->skb);
 		re->skb->ip_summed = CHECKSUM_NONE;
@@ -4985,16 +4985,16 @@ static int sky2_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_set_master(pdev);
 
 	if (sizeof(dma_addr_t) > sizeof(u32) &&
-	    !(err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64)))) {
+	    !(err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)))) {
 		using_dac = 1;
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
 		if (err < 0) {
 			dev_err(&pdev->dev, "unable to obtain 64 bit DMA "
 				"for consistent allocations\n");
 			goto err_out_free_regions;
 		}
 	} else {
-		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 		if (err) {
 			dev_err(&pdev->dev, "no usable DMA configuration\n");
 			goto err_out_free_regions;
@@ -5038,8 +5038,9 @@ static int sky2_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* ring for status responses */
 	hw->st_size = hw->ports * roundup_pow_of_two(3*RX_MAX_PENDING + TX_MAX_PENDING);
-	hw->st_le = pci_alloc_consistent(pdev, hw->st_size * sizeof(struct sky2_status_le),
-					 &hw->st_dma);
+	hw->st_le = dma_alloc_coherent(&pdev->dev,
+				       hw->st_size * sizeof(struct sky2_status_le),
+				       &hw->st_dma, GFP_KERNEL);
 	if (!hw->st_le) {
 		err = -ENOMEM;
 		goto err_out_reset;
@@ -5119,8 +5120,9 @@ static int sky2_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		pci_disable_msi(pdev);
 	free_netdev(dev);
 err_out_free_pci:
-	pci_free_consistent(pdev, hw->st_size * sizeof(struct sky2_status_le),
-			    hw->st_le, hw->st_dma);
+	dma_free_coherent(&pdev->dev,
+			  hw->st_size * sizeof(struct sky2_status_le),
+			  hw->st_le, hw->st_dma);
 err_out_reset:
 	sky2_write8(hw, B0_CTST, CS_RST_SET);
 err_out_iounmap:
@@ -5164,8 +5166,9 @@ static void sky2_remove(struct pci_dev *pdev)
 
 	if (hw->flags & SKY2_HW_USE_MSI)
 		pci_disable_msi(pdev);
-	pci_free_consistent(pdev, hw->st_size * sizeof(struct sky2_status_le),
-			    hw->st_le, hw->st_dma);
+	dma_free_coherent(&pdev->dev,
+			  hw->st_size * sizeof(struct sky2_status_le),
+			  hw->st_le, hw->st_dma);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 
-- 
2.25.1

