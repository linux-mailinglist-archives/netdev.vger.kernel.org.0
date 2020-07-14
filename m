Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FC221EC30
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 11:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgGNJGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 05:06:31 -0400
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:19671 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbgGNJG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 05:06:28 -0400
Received: from localhost.localdomain ([93.22.39.234])
        by mwinf5d69 with ME
        id 2x6M2300B537AcD03x6NtW; Tue, 14 Jul 2020 11:06:24 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 14 Jul 2020 11:06:24 +0200
X-ME-IP: 93.22.39.234
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, jdmason@kudzu.us, ast@kernel.org,
        kuba@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: neterion: s2io: switch from 'pci_' to 'dma_' API
Date:   Tue, 14 Jul 2020 11:06:20 +0200
Message-Id: <20200714090620.298884-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'init_shared_mem()' GFP_KERNEL can be used
because this flag is already used to allocate some memory in this function.

While at it, update some debug message to match the new function names.


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
 drivers/net/ethernet/neterion/s2io.c | 191 +++++++++++++--------------
 1 file changed, 90 insertions(+), 101 deletions(-)

diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 15b8b1bf8163..bc94970bea45 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -640,11 +640,11 @@ static int init_shared_mem(struct s2io_nic *nic)
 			int k = 0;
 			dma_addr_t tmp_p;
 			void *tmp_v;
-			tmp_v = pci_alloc_consistent(nic->pdev,
-						     PAGE_SIZE, &tmp_p);
+			tmp_v = dma_alloc_coherent(&nic->pdev->dev, PAGE_SIZE,
+						   &tmp_p, GFP_KERNEL);
 			if (!tmp_v) {
 				DBG_PRINT(INFO_DBG,
-					  "pci_alloc_consistent failed for TxDL\n");
+					  "dma_alloc_coherent failed for TxDL\n");
 				return -ENOMEM;
 			}
 			/* If we got a zero DMA address(can happen on
@@ -658,11 +658,12 @@ static int init_shared_mem(struct s2io_nic *nic)
 					  "%s: Zero DMA address for TxDL. "
 					  "Virtual address %p\n",
 					  dev->name, tmp_v);
-				tmp_v = pci_alloc_consistent(nic->pdev,
-							     PAGE_SIZE, &tmp_p);
+				tmp_v = dma_alloc_coherent(&nic->pdev->dev,
+							   PAGE_SIZE, &tmp_p,
+							   GFP_KERNEL);
 				if (!tmp_v) {
 					DBG_PRINT(INFO_DBG,
-						  "pci_alloc_consistent failed for TxDL\n");
+						  "dma_alloc_coherent failed for TxDL\n");
 					return -ENOMEM;
 				}
 				mem_allocated += PAGE_SIZE;
@@ -734,8 +735,8 @@ static int init_shared_mem(struct s2io_nic *nic)
 
 			rx_blocks = &ring->rx_blocks[j];
 			size = SIZE_OF_BLOCK;	/* size is always page size */
-			tmp_v_addr = pci_alloc_consistent(nic->pdev, size,
-							  &tmp_p_addr);
+			tmp_v_addr = dma_alloc_coherent(&nic->pdev->dev, size,
+							&tmp_p_addr, GFP_KERNEL);
 			if (tmp_v_addr == NULL) {
 				/*
 				 * In case of failure, free_shared_mem()
@@ -835,8 +836,8 @@ static int init_shared_mem(struct s2io_nic *nic)
 	/* Allocation and initialization of Statistics block */
 	size = sizeof(struct stat_block);
 	mac_control->stats_mem =
-		pci_alloc_consistent(nic->pdev, size,
-				     &mac_control->stats_mem_phy);
+		dma_alloc_coherent(&nic->pdev->dev, size,
+				   &mac_control->stats_mem_phy, GFP_KERNEL);
 
 	if (!mac_control->stats_mem) {
 		/*
@@ -906,18 +907,18 @@ static void free_shared_mem(struct s2io_nic *nic)
 			fli = &fifo->list_info[mem_blks];
 			if (!fli->list_virt_addr)
 				break;
-			pci_free_consistent(nic->pdev, PAGE_SIZE,
-					    fli->list_virt_addr,
-					    fli->list_phy_addr);
+			dma_free_coherent(&nic->pdev->dev, PAGE_SIZE,
+					  fli->list_virt_addr,
+					  fli->list_phy_addr);
 			swstats->mem_freed += PAGE_SIZE;
 		}
 		/* If we got a zero DMA address during allocation,
 		 * free the page now
 		 */
 		if (mac_control->zerodma_virt_addr) {
-			pci_free_consistent(nic->pdev, PAGE_SIZE,
-					    mac_control->zerodma_virt_addr,
-					    (dma_addr_t)0);
+			dma_free_coherent(&nic->pdev->dev, PAGE_SIZE,
+					  mac_control->zerodma_virt_addr,
+					  (dma_addr_t)0);
 			DBG_PRINT(INIT_DBG,
 				  "%s: Freeing TxDL with zero DMA address. "
 				  "Virtual address %p\n",
@@ -939,8 +940,8 @@ static void free_shared_mem(struct s2io_nic *nic)
 			tmp_p_addr = ring->rx_blocks[j].block_dma_addr;
 			if (tmp_v_addr == NULL)
 				break;
-			pci_free_consistent(nic->pdev, size,
-					    tmp_v_addr, tmp_p_addr);
+			dma_free_coherent(&nic->pdev->dev, size, tmp_v_addr,
+					  tmp_p_addr);
 			swstats->mem_freed += size;
 			kfree(ring->rx_blocks[j].rxds);
 			swstats->mem_freed += sizeof(struct rxd_info) *
@@ -993,10 +994,9 @@ static void free_shared_mem(struct s2io_nic *nic)
 
 	if (mac_control->stats_mem) {
 		swstats->mem_freed += mac_control->stats_mem_sz;
-		pci_free_consistent(nic->pdev,
-				    mac_control->stats_mem_sz,
-				    mac_control->stats_mem,
-				    mac_control->stats_mem_phy);
+		dma_free_coherent(&nic->pdev->dev, mac_control->stats_mem_sz,
+				  mac_control->stats_mem,
+				  mac_control->stats_mem_phy);
 	}
 }
 
@@ -2316,8 +2316,9 @@ static struct sk_buff *s2io_txdl_getskb(struct fifo_info *fifo_data,
 
 	txds = txdlp;
 	if (txds->Host_Control == (u64)(long)fifo_data->ufo_in_band_v) {
-		pci_unmap_single(nic->pdev, (dma_addr_t)txds->Buffer_Pointer,
-				 sizeof(u64), PCI_DMA_TODEVICE);
+		dma_unmap_single(&nic->pdev->dev,
+				 (dma_addr_t)txds->Buffer_Pointer,
+				 sizeof(u64), DMA_TO_DEVICE);
 		txds++;
 	}
 
@@ -2326,8 +2327,8 @@ static struct sk_buff *s2io_txdl_getskb(struct fifo_info *fifo_data,
 		memset(txdlp, 0, (sizeof(struct TxD) * fifo_data->max_txds));
 		return NULL;
 	}
-	pci_unmap_single(nic->pdev, (dma_addr_t)txds->Buffer_Pointer,
-			 skb_headlen(skb), PCI_DMA_TODEVICE);
+	dma_unmap_single(&nic->pdev->dev, (dma_addr_t)txds->Buffer_Pointer,
+			 skb_headlen(skb), DMA_TO_DEVICE);
 	frg_cnt = skb_shinfo(skb)->nr_frags;
 	if (frg_cnt) {
 		txds++;
@@ -2335,9 +2336,9 @@ static struct sk_buff *s2io_txdl_getskb(struct fifo_info *fifo_data,
 			const skb_frag_t *frag = &skb_shinfo(skb)->frags[j];
 			if (!txds->Buffer_Pointer)
 				break;
-			pci_unmap_page(nic->pdev,
+			dma_unmap_page(&nic->pdev->dev,
 				       (dma_addr_t)txds->Buffer_Pointer,
-				       skb_frag_size(frag), PCI_DMA_TODEVICE);
+				       skb_frag_size(frag), DMA_TO_DEVICE);
 		}
 	}
 	memset(txdlp, 0, (sizeof(struct TxD) * fifo_data->max_txds));
@@ -2521,11 +2522,10 @@ static int fill_rx_buffers(struct s2io_nic *nic, struct ring_info *ring,
 			memset(rxdp, 0, sizeof(struct RxD1));
 			skb_reserve(skb, NET_IP_ALIGN);
 			rxdp1->Buffer0_ptr =
-				pci_map_single(ring->pdev, skb->data,
+				dma_map_single(&ring->pdev->dev, skb->data,
 					       size - NET_IP_ALIGN,
-					       PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(nic->pdev,
-						  rxdp1->Buffer0_ptr))
+					       DMA_FROM_DEVICE);
+			if (dma_mapping_error(&nic->pdev->dev, rxdp1->Buffer0_ptr))
 				goto pci_map_failed;
 
 			rxdp->Control_2 =
@@ -2557,17 +2557,16 @@ static int fill_rx_buffers(struct s2io_nic *nic, struct ring_info *ring,
 
 			if (from_card_up) {
 				rxdp3->Buffer0_ptr =
-					pci_map_single(ring->pdev, ba->ba_0,
-						       BUF0_LEN,
-						       PCI_DMA_FROMDEVICE);
-				if (pci_dma_mapping_error(nic->pdev,
-							  rxdp3->Buffer0_ptr))
+					dma_map_single(&ring->pdev->dev,
+						       ba->ba_0, BUF0_LEN,
+						       DMA_FROM_DEVICE);
+				if (dma_mapping_error(&nic->pdev->dev, rxdp3->Buffer0_ptr))
 					goto pci_map_failed;
 			} else
-				pci_dma_sync_single_for_device(ring->pdev,
-							       (dma_addr_t)rxdp3->Buffer0_ptr,
-							       BUF0_LEN,
-							       PCI_DMA_FROMDEVICE);
+				dma_sync_single_for_device(&ring->pdev->dev,
+							   (dma_addr_t)rxdp3->Buffer0_ptr,
+							   BUF0_LEN,
+							   DMA_FROM_DEVICE);
 
 			rxdp->Control_2 = SET_BUFFER0_SIZE_3(BUF0_LEN);
 			if (ring->rxd_mode == RXD_MODE_3B) {
@@ -2577,29 +2576,28 @@ static int fill_rx_buffers(struct s2io_nic *nic, struct ring_info *ring,
 				 * Buffer2 will have L3/L4 header plus
 				 * L4 payload
 				 */
-				rxdp3->Buffer2_ptr = pci_map_single(ring->pdev,
+				rxdp3->Buffer2_ptr = dma_map_single(&ring->pdev->dev,
 								    skb->data,
 								    ring->mtu + 4,
-								    PCI_DMA_FROMDEVICE);
+								    DMA_FROM_DEVICE);
 
-				if (pci_dma_mapping_error(nic->pdev,
-							  rxdp3->Buffer2_ptr))
+				if (dma_mapping_error(&nic->pdev->dev, rxdp3->Buffer2_ptr))
 					goto pci_map_failed;
 
 				if (from_card_up) {
 					rxdp3->Buffer1_ptr =
-						pci_map_single(ring->pdev,
+						dma_map_single(&ring->pdev->dev,
 							       ba->ba_1,
 							       BUF1_LEN,
-							       PCI_DMA_FROMDEVICE);
+							       DMA_FROM_DEVICE);
 
-					if (pci_dma_mapping_error(nic->pdev,
-								  rxdp3->Buffer1_ptr)) {
-						pci_unmap_single(ring->pdev,
+					if (dma_mapping_error(&nic->pdev->dev,
+							      rxdp3->Buffer1_ptr)) {
+						dma_unmap_single(&ring->pdev->dev,
 								 (dma_addr_t)(unsigned long)
 								 skb->data,
 								 ring->mtu + 4,
-								 PCI_DMA_FROMDEVICE);
+								 DMA_FROM_DEVICE);
 						goto pci_map_failed;
 					}
 				}
@@ -2668,27 +2666,24 @@ static void free_rxd_blk(struct s2io_nic *sp, int ring_no, int blk)
 			continue;
 		if (sp->rxd_mode == RXD_MODE_1) {
 			rxdp1 = (struct RxD1 *)rxdp;
-			pci_unmap_single(sp->pdev,
+			dma_unmap_single(&sp->pdev->dev,
 					 (dma_addr_t)rxdp1->Buffer0_ptr,
 					 dev->mtu +
 					 HEADER_ETHERNET_II_802_3_SIZE +
 					 HEADER_802_2_SIZE + HEADER_SNAP_SIZE,
-					 PCI_DMA_FROMDEVICE);
+					 DMA_FROM_DEVICE);
 			memset(rxdp, 0, sizeof(struct RxD1));
 		} else if (sp->rxd_mode == RXD_MODE_3B) {
 			rxdp3 = (struct RxD3 *)rxdp;
-			pci_unmap_single(sp->pdev,
+			dma_unmap_single(&sp->pdev->dev,
 					 (dma_addr_t)rxdp3->Buffer0_ptr,
-					 BUF0_LEN,
-					 PCI_DMA_FROMDEVICE);
-			pci_unmap_single(sp->pdev,
+					 BUF0_LEN, DMA_FROM_DEVICE);
+			dma_unmap_single(&sp->pdev->dev,
 					 (dma_addr_t)rxdp3->Buffer1_ptr,
-					 BUF1_LEN,
-					 PCI_DMA_FROMDEVICE);
-			pci_unmap_single(sp->pdev,
+					 BUF1_LEN, DMA_FROM_DEVICE);
+			dma_unmap_single(&sp->pdev->dev,
 					 (dma_addr_t)rxdp3->Buffer2_ptr,
-					 dev->mtu + 4,
-					 PCI_DMA_FROMDEVICE);
+					 dev->mtu + 4, DMA_FROM_DEVICE);
 			memset(rxdp, 0, sizeof(struct RxD3));
 		}
 		swstats->mem_freed += skb->truesize;
@@ -2919,23 +2914,21 @@ static int rx_intr_handler(struct ring_info *ring_data, int budget)
 		}
 		if (ring_data->rxd_mode == RXD_MODE_1) {
 			rxdp1 = (struct RxD1 *)rxdp;
-			pci_unmap_single(ring_data->pdev, (dma_addr_t)
-					 rxdp1->Buffer0_ptr,
+			dma_unmap_single(&ring_data->pdev->dev,
+					 (dma_addr_t)rxdp1->Buffer0_ptr,
 					 ring_data->mtu +
 					 HEADER_ETHERNET_II_802_3_SIZE +
 					 HEADER_802_2_SIZE +
 					 HEADER_SNAP_SIZE,
-					 PCI_DMA_FROMDEVICE);
+					 DMA_FROM_DEVICE);
 		} else if (ring_data->rxd_mode == RXD_MODE_3B) {
 			rxdp3 = (struct RxD3 *)rxdp;
-			pci_dma_sync_single_for_cpu(ring_data->pdev,
-						    (dma_addr_t)rxdp3->Buffer0_ptr,
-						    BUF0_LEN,
-						    PCI_DMA_FROMDEVICE);
-			pci_unmap_single(ring_data->pdev,
+			dma_sync_single_for_cpu(&ring_data->pdev->dev,
+						(dma_addr_t)rxdp3->Buffer0_ptr,
+						BUF0_LEN, DMA_FROM_DEVICE);
+			dma_unmap_single(&ring_data->pdev->dev,
 					 (dma_addr_t)rxdp3->Buffer2_ptr,
-					 ring_data->mtu + 4,
-					 PCI_DMA_FROMDEVICE);
+					 ring_data->mtu + 4, DMA_FROM_DEVICE);
 		}
 		prefetch(skb->data);
 		rx_osm_handler(ring_data, rxdp);
@@ -4117,9 +4110,9 @@ static netdev_tx_t s2io_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	frg_len = skb_headlen(skb);
-	txdp->Buffer_Pointer = pci_map_single(sp->pdev, skb->data,
-					      frg_len, PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(sp->pdev, txdp->Buffer_Pointer))
+	txdp->Buffer_Pointer = dma_map_single(&sp->pdev->dev, skb->data,
+					      frg_len, DMA_TO_DEVICE);
+	if (dma_mapping_error(&sp->pdev->dev, txdp->Buffer_Pointer))
 		goto pci_map_failed;
 
 	txdp->Host_Control = (unsigned long)skb;
@@ -6772,10 +6765,10 @@ static int set_rxd_buffer_pointer(struct s2io_nic *sp, struct RxD_t *rxdp,
 			 * Host Control is NULL
 			 */
 			rxdp1->Buffer0_ptr = *temp0 =
-				pci_map_single(sp->pdev, (*skb)->data,
+				dma_map_single(&sp->pdev->dev, (*skb)->data,
 					       size - NET_IP_ALIGN,
-					       PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(sp->pdev, rxdp1->Buffer0_ptr))
+					       DMA_FROM_DEVICE);
+			if (dma_mapping_error(&sp->pdev->dev, rxdp1->Buffer0_ptr))
 				goto memalloc_failed;
 			rxdp->Host_Control = (unsigned long) (*skb);
 		}
@@ -6798,37 +6791,34 @@ static int set_rxd_buffer_pointer(struct s2io_nic *sp, struct RxD_t *rxdp,
 			}
 			stats->mem_allocated += (*skb)->truesize;
 			rxdp3->Buffer2_ptr = *temp2 =
-				pci_map_single(sp->pdev, (*skb)->data,
-					       dev->mtu + 4,
-					       PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(sp->pdev, rxdp3->Buffer2_ptr))
+				dma_map_single(&sp->pdev->dev, (*skb)->data,
+					       dev->mtu + 4, DMA_FROM_DEVICE);
+			if (dma_mapping_error(&sp->pdev->dev, rxdp3->Buffer2_ptr))
 				goto memalloc_failed;
 			rxdp3->Buffer0_ptr = *temp0 =
-				pci_map_single(sp->pdev, ba->ba_0, BUF0_LEN,
-					       PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(sp->pdev,
-						  rxdp3->Buffer0_ptr)) {
-				pci_unmap_single(sp->pdev,
+				dma_map_single(&sp->pdev->dev, ba->ba_0,
+					       BUF0_LEN, DMA_FROM_DEVICE);
+			if (dma_mapping_error(&sp->pdev->dev, rxdp3->Buffer0_ptr)) {
+				dma_unmap_single(&sp->pdev->dev,
 						 (dma_addr_t)rxdp3->Buffer2_ptr,
 						 dev->mtu + 4,
-						 PCI_DMA_FROMDEVICE);
+						 DMA_FROM_DEVICE);
 				goto memalloc_failed;
 			}
 			rxdp->Host_Control = (unsigned long) (*skb);
 
 			/* Buffer-1 will be dummy buffer not used */
 			rxdp3->Buffer1_ptr = *temp1 =
-				pci_map_single(sp->pdev, ba->ba_1, BUF1_LEN,
-					       PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(sp->pdev,
-						  rxdp3->Buffer1_ptr)) {
-				pci_unmap_single(sp->pdev,
+				dma_map_single(&sp->pdev->dev, ba->ba_1,
+					       BUF1_LEN, DMA_FROM_DEVICE);
+			if (dma_mapping_error(&sp->pdev->dev, rxdp3->Buffer1_ptr)) {
+				dma_unmap_single(&sp->pdev->dev,
 						 (dma_addr_t)rxdp3->Buffer0_ptr,
-						 BUF0_LEN, PCI_DMA_FROMDEVICE);
-				pci_unmap_single(sp->pdev,
+						 BUF0_LEN, DMA_FROM_DEVICE);
+				dma_unmap_single(&sp->pdev->dev,
 						 (dma_addr_t)rxdp3->Buffer2_ptr,
 						 dev->mtu + 4,
-						 PCI_DMA_FROMDEVICE);
+						 DMA_FROM_DEVICE);
 				goto memalloc_failed;
 			}
 		}
@@ -7675,17 +7665,16 @@ s2io_init_nic(struct pci_dev *pdev, const struct pci_device_id *pre)
 		return ret;
 	}
 
-	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
 		DBG_PRINT(INIT_DBG, "%s: Using 64bit DMA\n", __func__);
 		dma_flag = true;
-		if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))) {
+		if (dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64))) {
 			DBG_PRINT(ERR_DBG,
-				  "Unable to obtain 64bit DMA "
-				  "for consistent allocations\n");
+				  "Unable to obtain 64bit DMA for coherent allocations\n");
 			pci_disable_device(pdev);
 			return -ENOMEM;
 		}
-	} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
+	} else if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) {
 		DBG_PRINT(INIT_DBG, "%s: Using 32bit DMA\n", __func__);
 	} else {
 		pci_disable_device(pdev);
-- 
2.25.1

