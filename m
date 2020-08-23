Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE73D24EC1A
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 10:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728411AbgHWIEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 04:04:09 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:16592 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728388AbgHWIEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 04:04:08 -0400
Received: from localhost.localdomain ([93.22.133.217])
        by mwinf5d55 with ME
        id Jw3x230044hbG4l03w3x28; Sun, 23 Aug 2020 10:04:03 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 23 Aug 2020 10:04:03 +0200
X-ME-IP: 93.22.133.217
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jcliburn@gmail.com, chris.snook@gmail.com, davem@davemloft.net,
        kuba@kernel.org, yanaijie@huawei.com, hkallweit1@gmail.com,
        mhabets@solarflare.com, mst@redhat.com, leon@kernel.org,
        colin.king@canonical.com, yuehaibing@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: atheros: switch from 'pci_' to 'dma_' API
Date:   Sun, 23 Aug 2020 10:03:53 +0200
Message-Id: <20200823080353.169306-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'atl1e_setup_ring_resources()' (atl1e_main.c),
'atl1_setup_ring_resources()' (atl1.c) and 'atl2_setup_ring_resources()'
(atl2.c) GFP_KERNEL can be used because it can be called from a .ndo_open.

'atl1_setup_ring_resources()' (atl1.c) can also be called from a
'.set_ringparam' (see struct ethtool_ops) where sleep is also allowed.

Both cases are protected by 'rtnl_lock()' which is a mutex. So these
function can sleep.


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
 .../net/ethernet/atheros/atl1c/atl1c_main.c   | 48 ++++++++--------
 .../net/ethernet/atheros/atl1e/atl1e_main.c   | 57 +++++++++++--------
 drivers/net/ethernet/atheros/atlx/atl1.c      | 48 ++++++++--------
 drivers/net/ethernet/atheros/atlx/atl2.c      | 12 ++--
 4 files changed, 88 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index decab9a8e4a8..b930dc49fe8e 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -826,16 +826,16 @@ static inline void atl1c_clean_buffer(struct pci_dev *pdev,
 		return;
 	if (buffer_info->dma) {
 		if (buffer_info->flags & ATL1C_PCIMAP_FROMDEVICE)
-			pci_driection = PCI_DMA_FROMDEVICE;
+			pci_driection = DMA_FROM_DEVICE;
 		else
-			pci_driection = PCI_DMA_TODEVICE;
+			pci_driection = DMA_TO_DEVICE;
 
 		if (buffer_info->flags & ATL1C_PCIMAP_SINGLE)
-			pci_unmap_single(pdev, buffer_info->dma,
-					buffer_info->length, pci_driection);
+			dma_unmap_single(&pdev->dev, buffer_info->dma,
+					 buffer_info->length, pci_driection);
 		else if (buffer_info->flags & ATL1C_PCIMAP_PAGE)
-			pci_unmap_page(pdev, buffer_info->dma,
-					buffer_info->length, pci_driection);
+			dma_unmap_page(&pdev->dev, buffer_info->dma,
+				       buffer_info->length, pci_driection);
 	}
 	if (buffer_info->skb)
 		dev_consume_skb_any(buffer_info->skb);
@@ -933,9 +933,8 @@ static void atl1c_free_ring_resources(struct atl1c_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
 
-	pci_free_consistent(pdev, adapter->ring_header.size,
-					adapter->ring_header.desc,
-					adapter->ring_header.dma);
+	dma_free_coherent(&pdev->dev, adapter->ring_header.size,
+			  adapter->ring_header.desc, adapter->ring_header.dma);
 	adapter->ring_header.desc = NULL;
 
 	/* Note: just free tdp_ring.buffer_info,
@@ -1717,10 +1716,9 @@ static int atl1c_alloc_rx_buffer(struct atl1c_adapter *adapter)
 		ATL1C_SET_BUFFER_STATE(buffer_info, ATL1C_BUFFER_BUSY);
 		buffer_info->skb = skb;
 		buffer_info->length = adapter->rx_buffer_len;
-		mapping = pci_map_single(pdev, vir_addr,
-						buffer_info->length,
-						PCI_DMA_FROMDEVICE);
-		if (unlikely(pci_dma_mapping_error(pdev, mapping))) {
+		mapping = dma_map_single(&pdev->dev, vir_addr,
+					 buffer_info->length, DMA_FROM_DEVICE);
+		if (unlikely(dma_mapping_error(&pdev->dev, mapping))) {
 			dev_kfree_skb(skb);
 			buffer_info->skb = NULL;
 			buffer_info->length = 0;
@@ -1831,8 +1829,8 @@ static void atl1c_clean_rx_irq(struct atl1c_adapter *adapter,
 			rfd_index = (rrs->word0 >> RRS_RX_RFD_INDEX_SHIFT) &
 					RRS_RX_RFD_INDEX_MASK;
 			buffer_info = &rfd_ring->buffer_info[rfd_index];
-			pci_unmap_single(pdev, buffer_info->dma,
-				buffer_info->length, PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&pdev->dev, buffer_info->dma,
+					 buffer_info->length, DMA_FROM_DEVICE);
 			skb = buffer_info->skb;
 		} else {
 			/* TODO */
@@ -2106,10 +2104,10 @@ static int atl1c_tx_map(struct atl1c_adapter *adapter,
 
 		buffer_info = atl1c_get_tx_buffer(adapter, use_tpd);
 		buffer_info->length = map_len;
-		buffer_info->dma = pci_map_single(adapter->pdev,
-					skb->data, hdr_len, PCI_DMA_TODEVICE);
-		if (unlikely(pci_dma_mapping_error(adapter->pdev,
-						   buffer_info->dma)))
+		buffer_info->dma = dma_map_single(&adapter->pdev->dev,
+						  skb->data, hdr_len,
+						  DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(&adapter->pdev->dev, buffer_info->dma)))
 			goto err_dma;
 		ATL1C_SET_BUFFER_STATE(buffer_info, ATL1C_BUFFER_BUSY);
 		ATL1C_SET_PCIMAP_TYPE(buffer_info, ATL1C_PCIMAP_SINGLE,
@@ -2131,10 +2129,10 @@ static int atl1c_tx_map(struct atl1c_adapter *adapter,
 		buffer_info = atl1c_get_tx_buffer(adapter, use_tpd);
 		buffer_info->length = buf_len - mapped_len;
 		buffer_info->dma =
-			pci_map_single(adapter->pdev, skb->data + mapped_len,
-					buffer_info->length, PCI_DMA_TODEVICE);
-		if (unlikely(pci_dma_mapping_error(adapter->pdev,
-						   buffer_info->dma)))
+			dma_map_single(&adapter->pdev->dev,
+				       skb->data + mapped_len,
+				       buffer_info->length, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(&adapter->pdev->dev, buffer_info->dma)))
 			goto err_dma;
 
 		ATL1C_SET_BUFFER_STATE(buffer_info, ATL1C_BUFFER_BUSY);
@@ -2542,8 +2540,8 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * various kernel subsystems to support the mechanics required by a
 	 * fixed-high-32-bit system.
 	 */
-	if ((pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0) ||
-	    (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)) {
+	if ((dma_set_mask(&pdev->dev, DMA_BIT_MASK(32)) != 0) ||
+	    (dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32)) != 0)) {
 		dev_err(&pdev->dev, "No usable DMA configuration,aborting\n");
 		goto err_dma;
 	}
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 223ef846123e..fb78f6c31708 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -654,11 +654,13 @@ static void atl1e_clean_tx_ring(struct atl1e_adapter *adapter)
 		tx_buffer = &tx_ring->tx_buffer[index];
 		if (tx_buffer->dma) {
 			if (tx_buffer->flags & ATL1E_TX_PCIMAP_SINGLE)
-				pci_unmap_single(pdev, tx_buffer->dma,
-					tx_buffer->length, PCI_DMA_TODEVICE);
+				dma_unmap_single(&pdev->dev, tx_buffer->dma,
+						 tx_buffer->length,
+						 DMA_TO_DEVICE);
 			else if (tx_buffer->flags & ATL1E_TX_PCIMAP_PAGE)
-				pci_unmap_page(pdev, tx_buffer->dma,
-					tx_buffer->length, PCI_DMA_TODEVICE);
+				dma_unmap_page(&pdev->dev, tx_buffer->dma,
+					       tx_buffer->length,
+					       DMA_TO_DEVICE);
 			tx_buffer->dma = 0;
 		}
 	}
@@ -774,8 +776,8 @@ static void atl1e_free_ring_resources(struct atl1e_adapter *adapter)
 	atl1e_clean_rx_ring(adapter);
 
 	if (adapter->ring_vir_addr) {
-		pci_free_consistent(pdev, adapter->ring_size,
-				adapter->ring_vir_addr, adapter->ring_dma);
+		dma_free_coherent(&pdev->dev, adapter->ring_size,
+				  adapter->ring_vir_addr, adapter->ring_dma);
 		adapter->ring_vir_addr = NULL;
 	}
 
@@ -810,11 +812,12 @@ static int atl1e_setup_ring_resources(struct atl1e_adapter *adapter)
 	/* real ring DMA buffer */
 
 	size = adapter->ring_size;
-	adapter->ring_vir_addr = pci_zalloc_consistent(pdev, adapter->ring_size,
-						       &adapter->ring_dma);
+	adapter->ring_vir_addr = dma_alloc_coherent(&pdev->dev,
+						    adapter->ring_size,
+						    &adapter->ring_dma, GFP_KERNEL);
 	if (adapter->ring_vir_addr == NULL) {
 		netdev_err(adapter->netdev,
-			   "pci_alloc_consistent failed, size = D%d\n", size);
+			   "dma_alloc_coherent failed, size = D%d\n", size);
 		return -ENOMEM;
 	}
 
@@ -870,8 +873,8 @@ static int atl1e_setup_ring_resources(struct atl1e_adapter *adapter)
 	return 0;
 failed:
 	if (adapter->ring_vir_addr != NULL) {
-		pci_free_consistent(pdev, adapter->ring_size,
-				adapter->ring_vir_addr, adapter->ring_dma);
+		dma_free_coherent(&pdev->dev, adapter->ring_size,
+				  adapter->ring_vir_addr, adapter->ring_dma);
 		adapter->ring_vir_addr = NULL;
 	}
 	return err;
@@ -1233,11 +1236,15 @@ static bool atl1e_clean_tx_irq(struct atl1e_adapter *adapter)
 		tx_buffer = &tx_ring->tx_buffer[next_to_clean];
 		if (tx_buffer->dma) {
 			if (tx_buffer->flags & ATL1E_TX_PCIMAP_SINGLE)
-				pci_unmap_single(adapter->pdev, tx_buffer->dma,
-					tx_buffer->length, PCI_DMA_TODEVICE);
+				dma_unmap_single(&adapter->pdev->dev,
+						 tx_buffer->dma,
+						 tx_buffer->length,
+						 DMA_TO_DEVICE);
 			else if (tx_buffer->flags & ATL1E_TX_PCIMAP_PAGE)
-				pci_unmap_page(adapter->pdev, tx_buffer->dma,
-					tx_buffer->length, PCI_DMA_TODEVICE);
+				dma_unmap_page(&adapter->pdev->dev,
+					       tx_buffer->dma,
+					       tx_buffer->length,
+					       DMA_TO_DEVICE);
 			tx_buffer->dma = 0;
 		}
 
@@ -1710,8 +1717,9 @@ static int atl1e_tx_map(struct atl1e_adapter *adapter,
 
 		tx_buffer = atl1e_get_tx_buffer(adapter, use_tpd);
 		tx_buffer->length = map_len;
-		tx_buffer->dma = pci_map_single(adapter->pdev,
-					skb->data, hdr_len, PCI_DMA_TODEVICE);
+		tx_buffer->dma = dma_map_single(&adapter->pdev->dev,
+						skb->data, hdr_len,
+						DMA_TO_DEVICE);
 		if (dma_mapping_error(&adapter->pdev->dev, tx_buffer->dma))
 			return -ENOSPC;
 
@@ -1739,8 +1747,9 @@ static int atl1e_tx_map(struct atl1e_adapter *adapter,
 			((buf_len - mapped_len) >= MAX_TX_BUF_LEN) ?
 			MAX_TX_BUF_LEN : (buf_len - mapped_len);
 		tx_buffer->dma =
-			pci_map_single(adapter->pdev, skb->data + mapped_len,
-					map_len, PCI_DMA_TODEVICE);
+			dma_map_single(&adapter->pdev->dev,
+				       skb->data + mapped_len, map_len,
+				       DMA_TO_DEVICE);
 
 		if (dma_mapping_error(&adapter->pdev->dev, tx_buffer->dma)) {
 			/* We need to unwind the mappings we've done */
@@ -1749,8 +1758,10 @@ static int atl1e_tx_map(struct atl1e_adapter *adapter,
 			while (adapter->tx_ring.next_to_use != ring_end) {
 				tpd = atl1e_get_tpd(adapter);
 				tx_buffer = atl1e_get_tx_buffer(adapter, tpd);
-				pci_unmap_single(adapter->pdev, tx_buffer->dma,
-						 tx_buffer->length, PCI_DMA_TODEVICE);
+				dma_unmap_single(&adapter->pdev->dev,
+						 tx_buffer->dma,
+						 tx_buffer->length,
+						 DMA_TO_DEVICE);
 			}
 			/* Reset the tx rings next pointer */
 			adapter->tx_ring.next_to_use = ring_start;
@@ -2300,8 +2311,8 @@ static int atl1e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * various kernel subsystems to support the mechanics required by a
 	 * fixed-high-32-bit system.
 	 */
-	if ((pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0) ||
-	    (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)) {
+	if ((dma_set_mask(&pdev->dev, DMA_BIT_MASK(32)) != 0) ||
+	    (dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32)) != 0)) {
 		dev_err(&pdev->dev, "No usable DMA configuration,aborting\n");
 		goto err_dma;
 	}
diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index b35fcfcd692d..60f8aa79deb2 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -1050,11 +1050,11 @@ static s32 atl1_setup_ring_resources(struct atl1_adapter *adapter)
 		+ sizeof(struct stats_msg_block)
 		+ 40;
 
-	ring_header->desc = pci_alloc_consistent(pdev, ring_header->size,
-		&ring_header->dma);
+	ring_header->desc = dma_alloc_coherent(&pdev->dev, ring_header->size,
+					       &ring_header->dma, GFP_KERNEL);
 	if (unlikely(!ring_header->desc)) {
 		if (netif_msg_drv(adapter))
-			dev_err(&pdev->dev, "pci_alloc_consistent failed\n");
+			dev_err(&pdev->dev, "dma_alloc_coherent failed\n");
 		goto err_nomem;
 	}
 
@@ -1136,8 +1136,8 @@ static void atl1_clean_rx_ring(struct atl1_adapter *adapter)
 	for (i = 0; i < rfd_ring->count; i++) {
 		buffer_info = &rfd_ring->buffer_info[i];
 		if (buffer_info->dma) {
-			pci_unmap_page(pdev, buffer_info->dma,
-				buffer_info->length, PCI_DMA_FROMDEVICE);
+			dma_unmap_page(&pdev->dev, buffer_info->dma,
+				       buffer_info->length, DMA_FROM_DEVICE);
 			buffer_info->dma = 0;
 		}
 		if (buffer_info->skb) {
@@ -1175,8 +1175,8 @@ static void atl1_clean_tx_ring(struct atl1_adapter *adapter)
 	for (i = 0; i < tpd_ring->count; i++) {
 		buffer_info = &tpd_ring->buffer_info[i];
 		if (buffer_info->dma) {
-			pci_unmap_page(pdev, buffer_info->dma,
-				buffer_info->length, PCI_DMA_TODEVICE);
+			dma_unmap_page(&pdev->dev, buffer_info->dma,
+				       buffer_info->length, DMA_TO_DEVICE);
 			buffer_info->dma = 0;
 		}
 	}
@@ -1217,8 +1217,8 @@ static void atl1_free_ring_resources(struct atl1_adapter *adapter)
 	atl1_clean_rx_ring(adapter);
 
 	kfree(tpd_ring->buffer_info);
-	pci_free_consistent(pdev, ring_header->size, ring_header->desc,
-		ring_header->dma);
+	dma_free_coherent(&pdev->dev, ring_header->size, ring_header->desc,
+			  ring_header->dma);
 
 	tpd_ring->buffer_info = NULL;
 	tpd_ring->desc = NULL;
@@ -1866,9 +1866,9 @@ static u16 atl1_alloc_rx_buffers(struct atl1_adapter *adapter)
 		buffer_info->length = (u16) adapter->rx_buffer_len;
 		page = virt_to_page(skb->data);
 		offset = offset_in_page(skb->data);
-		buffer_info->dma = pci_map_page(pdev, page, offset,
+		buffer_info->dma = dma_map_page(&pdev->dev, page, offset,
 						adapter->rx_buffer_len,
-						PCI_DMA_FROMDEVICE);
+						DMA_FROM_DEVICE);
 		rfd_desc->buffer_addr = cpu_to_le64(buffer_info->dma);
 		rfd_desc->buf_len = cpu_to_le16(adapter->rx_buffer_len);
 		rfd_desc->coalese = 0;
@@ -1992,8 +1992,8 @@ static int atl1_intr_rx(struct atl1_adapter *adapter, int budget)
 		}
 
 		/* Good Receive */
-		pci_unmap_page(adapter->pdev, buffer_info->dma,
-			       buffer_info->length, PCI_DMA_FROMDEVICE);
+		dma_unmap_page(&adapter->pdev->dev, buffer_info->dma,
+			       buffer_info->length, DMA_FROM_DEVICE);
 		buffer_info->dma = 0;
 		skb = buffer_info->skb;
 		length = le16_to_cpu(rrd->xsz.xsum_sz.pkt_size);
@@ -2062,8 +2062,8 @@ static int atl1_intr_tx(struct atl1_adapter *adapter)
 	while (cmb_tpd_next_to_clean != sw_tpd_next_to_clean) {
 		buffer_info = &tpd_ring->buffer_info[sw_tpd_next_to_clean];
 		if (buffer_info->dma) {
-			pci_unmap_page(adapter->pdev, buffer_info->dma,
-				       buffer_info->length, PCI_DMA_TODEVICE);
+			dma_unmap_page(&adapter->pdev->dev, buffer_info->dma,
+				       buffer_info->length, DMA_TO_DEVICE);
 			buffer_info->dma = 0;
 		}
 
@@ -2210,9 +2210,9 @@ static void atl1_tx_map(struct atl1_adapter *adapter, struct sk_buff *skb,
 		buffer_info->length = hdr_len;
 		page = virt_to_page(skb->data);
 		offset = offset_in_page(skb->data);
-		buffer_info->dma = pci_map_page(adapter->pdev, page,
+		buffer_info->dma = dma_map_page(&adapter->pdev->dev, page,
 						offset, hdr_len,
-						PCI_DMA_TODEVICE);
+						DMA_TO_DEVICE);
 
 		if (++next_to_use == tpd_ring->count)
 			next_to_use = 0;
@@ -2235,9 +2235,10 @@ static void atl1_tx_map(struct atl1_adapter *adapter, struct sk_buff *skb,
 					(hdr_len + i * ATL1_MAX_TX_BUF_LEN));
 				offset = offset_in_page(skb->data +
 					(hdr_len + i * ATL1_MAX_TX_BUF_LEN));
-				buffer_info->dma = pci_map_page(adapter->pdev,
-					page, offset, buffer_info->length,
-					PCI_DMA_TODEVICE);
+				buffer_info->dma = dma_map_page(&adapter->pdev->dev,
+								page, offset,
+								buffer_info->length,
+								DMA_TO_DEVICE);
 				if (++next_to_use == tpd_ring->count)
 					next_to_use = 0;
 			}
@@ -2247,8 +2248,9 @@ static void atl1_tx_map(struct atl1_adapter *adapter, struct sk_buff *skb,
 		buffer_info->length = buf_len;
 		page = virt_to_page(skb->data);
 		offset = offset_in_page(skb->data);
-		buffer_info->dma = pci_map_page(adapter->pdev, page,
-			offset, buf_len, PCI_DMA_TODEVICE);
+		buffer_info->dma = dma_map_page(&adapter->pdev->dev, page,
+						offset, buf_len,
+						DMA_TO_DEVICE);
 		if (++next_to_use == tpd_ring->count)
 			next_to_use = 0;
 	}
@@ -2922,7 +2924,7 @@ static int atl1_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * various kernel subsystems to support the mechanics required by a
 	 * fixed-high-32-bit system.
 	 */
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (err) {
 		dev_err(&pdev->dev, "no usable DMA configuration\n");
 		goto err_dma;
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index c915852b8892..22c9e23195d8 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -281,8 +281,8 @@ static s32 atl2_setup_ring_resources(struct atl2_adapter *adapter)
 		adapter->txs_ring_size * 4 + 7 +	/* dword align */
 		adapter->rxd_ring_size * 1536 + 127;	/* 128bytes align */
 
-	adapter->ring_vir_addr = pci_alloc_consistent(pdev, size,
-		&adapter->ring_dma);
+	adapter->ring_vir_addr = dma_alloc_coherent(&pdev->dev, size,
+						    &adapter->ring_dma, GFP_KERNEL);
 	if (!adapter->ring_vir_addr)
 		return -ENOMEM;
 
@@ -663,8 +663,8 @@ static int atl2_request_irq(struct atl2_adapter *adapter)
 static void atl2_free_ring_resources(struct atl2_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
-	pci_free_consistent(pdev, adapter->ring_size, adapter->ring_vir_addr,
-		adapter->ring_dma);
+	dma_free_coherent(&pdev->dev, adapter->ring_size,
+			  adapter->ring_vir_addr, adapter->ring_dma);
 }
 
 /**
@@ -1328,8 +1328,8 @@ static int atl2_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * until the kernel has the proper infrastructure to support 64-bit DMA
 	 * on these devices.
 	 */
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) &&
-		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
+	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(32)) &&
+	    dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32))) {
 		printk(KERN_ERR "atl2: No usable DMA configuration, aborting\n");
 		err = -EIO;
 		goto err_dma;
-- 
2.25.1

