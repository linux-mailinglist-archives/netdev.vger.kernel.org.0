Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63AB921EA96
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 09:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgGNHwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 03:52:34 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:16714 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgGNHwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 03:52:33 -0400
Received: from localhost.localdomain ([93.22.39.234])
        by mwinf5d17 with ME
        id 2vsS2300B537AcD03vsSQz; Tue, 14 Jul 2020 09:52:31 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 14 Jul 2020 09:52:31 +0200
X-ME-IP: 93.22.39.234
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, bryan.whitehead@microchip.com,
        UNGLinuxDriver@microchip.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] lan743x: switch from 'pci_' to 'dma_' API
Date:   Tue, 14 Jul 2020 09:52:24 +0200
Message-Id: <20200714075224.290759-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'lan743x_tx_ring_cleanup()' and
'lan743x_rx_ring_init()', GFP_KERNEL can be used because this flag is
already used to allocate some memory in these functions.

While at it, remove a useless (void *) casting in the first hunk in so that
the code is more consistent.


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
 drivers/net/ethernet/microchip/lan743x_main.c | 46 +++++++++----------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 2373e72d2d29..f6479384dc4f 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1742,10 +1742,9 @@ static int lan743x_tx_napi_poll(struct napi_struct *napi, int weight)
 static void lan743x_tx_ring_cleanup(struct lan743x_tx *tx)
 {
 	if (tx->head_cpu_ptr) {
-		pci_free_consistent(tx->adapter->pdev,
-				    sizeof(*tx->head_cpu_ptr),
-				    (void *)(tx->head_cpu_ptr),
-				    tx->head_dma_ptr);
+		dma_free_coherent(&tx->adapter->pdev->dev,
+				  sizeof(*tx->head_cpu_ptr), tx->head_cpu_ptr,
+				  tx->head_dma_ptr);
 		tx->head_cpu_ptr = NULL;
 		tx->head_dma_ptr = 0;
 	}
@@ -1753,10 +1752,9 @@ static void lan743x_tx_ring_cleanup(struct lan743x_tx *tx)
 	tx->buffer_info = NULL;
 
 	if (tx->ring_cpu_ptr) {
-		pci_free_consistent(tx->adapter->pdev,
-				    tx->ring_allocation_size,
-				    tx->ring_cpu_ptr,
-				    tx->ring_dma_ptr);
+		dma_free_coherent(&tx->adapter->pdev->dev,
+				  tx->ring_allocation_size, tx->ring_cpu_ptr,
+				  tx->ring_dma_ptr);
 		tx->ring_allocation_size = 0;
 		tx->ring_cpu_ptr = NULL;
 		tx->ring_dma_ptr = 0;
@@ -1780,8 +1778,8 @@ static int lan743x_tx_ring_init(struct lan743x_tx *tx)
 				     sizeof(struct lan743x_tx_descriptor),
 				     PAGE_SIZE);
 	dma_ptr = 0;
-	cpu_ptr = pci_zalloc_consistent(tx->adapter->pdev,
-					ring_allocation_size, &dma_ptr);
+	cpu_ptr = dma_alloc_coherent(&tx->adapter->pdev->dev,
+				     ring_allocation_size, &dma_ptr, GFP_KERNEL);
 	if (!cpu_ptr) {
 		ret = -ENOMEM;
 		goto cleanup;
@@ -1798,8 +1796,9 @@ static int lan743x_tx_ring_init(struct lan743x_tx *tx)
 	}
 	tx->buffer_info = (struct lan743x_tx_buffer_info *)cpu_ptr;
 	dma_ptr = 0;
-	cpu_ptr = pci_zalloc_consistent(tx->adapter->pdev,
-					sizeof(*tx->head_cpu_ptr), &dma_ptr);
+	cpu_ptr = dma_alloc_coherent(&tx->adapter->pdev->dev,
+				     sizeof(*tx->head_cpu_ptr), &dma_ptr,
+				     GFP_KERNEL);
 	if (!cpu_ptr) {
 		ret = -ENOMEM;
 		goto cleanup;
@@ -2281,10 +2280,9 @@ static void lan743x_rx_ring_cleanup(struct lan743x_rx *rx)
 	}
 
 	if (rx->head_cpu_ptr) {
-		pci_free_consistent(rx->adapter->pdev,
-				    sizeof(*rx->head_cpu_ptr),
-				    rx->head_cpu_ptr,
-				    rx->head_dma_ptr);
+		dma_free_coherent(&rx->adapter->pdev->dev,
+				  sizeof(*rx->head_cpu_ptr), rx->head_cpu_ptr,
+				  rx->head_dma_ptr);
 		rx->head_cpu_ptr = NULL;
 		rx->head_dma_ptr = 0;
 	}
@@ -2293,10 +2291,9 @@ static void lan743x_rx_ring_cleanup(struct lan743x_rx *rx)
 	rx->buffer_info = NULL;
 
 	if (rx->ring_cpu_ptr) {
-		pci_free_consistent(rx->adapter->pdev,
-				    rx->ring_allocation_size,
-				    rx->ring_cpu_ptr,
-				    rx->ring_dma_ptr);
+		dma_free_coherent(&rx->adapter->pdev->dev,
+				  rx->ring_allocation_size, rx->ring_cpu_ptr,
+				  rx->ring_dma_ptr);
 		rx->ring_allocation_size = 0;
 		rx->ring_cpu_ptr = NULL;
 		rx->ring_dma_ptr = 0;
@@ -2327,8 +2324,8 @@ static int lan743x_rx_ring_init(struct lan743x_rx *rx)
 				     sizeof(struct lan743x_rx_descriptor),
 				     PAGE_SIZE);
 	dma_ptr = 0;
-	cpu_ptr = pci_zalloc_consistent(rx->adapter->pdev,
-					ring_allocation_size, &dma_ptr);
+	cpu_ptr = dma_alloc_coherent(&rx->adapter->pdev->dev,
+				     ring_allocation_size, &dma_ptr, GFP_KERNEL);
 	if (!cpu_ptr) {
 		ret = -ENOMEM;
 		goto cleanup;
@@ -2345,8 +2342,9 @@ static int lan743x_rx_ring_init(struct lan743x_rx *rx)
 	}
 	rx->buffer_info = (struct lan743x_rx_buffer_info *)cpu_ptr;
 	dma_ptr = 0;
-	cpu_ptr = pci_zalloc_consistent(rx->adapter->pdev,
-					sizeof(*rx->head_cpu_ptr), &dma_ptr);
+	cpu_ptr = dma_alloc_coherent(&rx->adapter->pdev->dev,
+				     sizeof(*rx->head_cpu_ptr), &dma_ptr,
+				     GFP_KERNEL);
 	if (!cpu_ptr) {
 		ret = -ENOMEM;
 		goto cleanup;
-- 
2.25.1

