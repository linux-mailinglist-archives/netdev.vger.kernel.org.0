Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC55E2F9163
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 09:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbhAQIeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 03:34:13 -0500
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:28586 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728193AbhAQIRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 03:17:35 -0500
Received: from localhost.localdomain ([92.131.99.25])
        by mwinf5d76 with ME
        id HkFi240040Ys01Y03kFiYE; Sun, 17 Jan 2021 09:15:48 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 17 Jan 2021 09:15:48 +0100
X-ME-IP: 92.131.99.25
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net/qla3xxx: switch from 'pci_' to 'dma_' API
Date:   Sun, 17 Jan 2021 09:15:42 +0100
Message-Id: <20210117081542.560021-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below and has been
hand modified to replace GFP_ with a correct flag.
It has been compile tested.

When memory is allocated in 'ql_alloc_net_req_rsp_queues()' GFP_KERNEL can
be used because it is only called from 'ql_alloc_mem_resources()' which
already calls 'ql_alloc_buffer_queues()' which uses GFP_KERNEL. (see below)

When memory is allocated in 'ql_alloc_buffer_queues()' GFP_KERNEL can be
used because this flag is already used just a few line above.

When memory is allocated in 'ql_alloc_small_buffers()' GFP_KERNEL can
be used because it is only called from 'ql_alloc_mem_resources()' which
already calls 'ql_alloc_buffer_queues()' which uses GFP_KERNEL. (see above)

When memory is allocated in 'ql_alloc_mem_resources()' GFP_KERNEL can be
used because this function already calls 'ql_alloc_buffer_queues()' which
uses GFP_KERNEL. (see above)


While at it, use 'dma_set_mask_and_coherent()' instead of 'dma_set_mask()/
dma_set_coherent_mask()' in order to slightly simplify code.


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
 drivers/net/ethernet/qlogic/qla3xxx.c | 196 ++++++++++++--------------
 1 file changed, 87 insertions(+), 109 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 27740c027681..214e347097a7 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -315,12 +315,11 @@ static void ql_release_to_lrg_buf_free_list(struct ql3_adapter *qdev,
 			 * buffer
 			 */
 			skb_reserve(lrg_buf_cb->skb, QL_HEADER_SPACE);
-			map = pci_map_single(qdev->pdev,
+			map = dma_map_single(&qdev->pdev->dev,
 					     lrg_buf_cb->skb->data,
-					     qdev->lrg_buffer_len -
-					     QL_HEADER_SPACE,
-					     PCI_DMA_FROMDEVICE);
-			err = pci_dma_mapping_error(qdev->pdev, map);
+					     qdev->lrg_buffer_len - QL_HEADER_SPACE,
+					     DMA_FROM_DEVICE);
+			err = dma_mapping_error(&qdev->pdev->dev, map);
 			if (err) {
 				netdev_err(qdev->ndev,
 					   "PCI mapping failed with error: %d\n",
@@ -1802,13 +1801,12 @@ static int ql_populate_free_queue(struct ql3_adapter *qdev)
 				 * first buffer
 				 */
 				skb_reserve(lrg_buf_cb->skb, QL_HEADER_SPACE);
-				map = pci_map_single(qdev->pdev,
+				map = dma_map_single(&qdev->pdev->dev,
 						     lrg_buf_cb->skb->data,
-						     qdev->lrg_buffer_len -
-						     QL_HEADER_SPACE,
-						     PCI_DMA_FROMDEVICE);
+						     qdev->lrg_buffer_len - QL_HEADER_SPACE,
+						     DMA_FROM_DEVICE);
 
-				err = pci_dma_mapping_error(qdev->pdev, map);
+				err = dma_mapping_error(&qdev->pdev->dev, map);
 				if (err) {
 					netdev_err(qdev->ndev,
 						   "PCI mapping failed with error: %d\n",
@@ -1943,18 +1941,16 @@ static void ql_process_mac_tx_intr(struct ql3_adapter *qdev,
 		goto invalid_seg_count;
 	}
 
-	pci_unmap_single(qdev->pdev,
+	dma_unmap_single(&qdev->pdev->dev,
 			 dma_unmap_addr(&tx_cb->map[0], mapaddr),
-			 dma_unmap_len(&tx_cb->map[0], maplen),
-			 PCI_DMA_TODEVICE);
+			 dma_unmap_len(&tx_cb->map[0], maplen), DMA_TO_DEVICE);
 	tx_cb->seg_count--;
 	if (tx_cb->seg_count) {
 		for (i = 1; i < tx_cb->seg_count; i++) {
-			pci_unmap_page(qdev->pdev,
-				       dma_unmap_addr(&tx_cb->map[i],
-						      mapaddr),
+			dma_unmap_page(&qdev->pdev->dev,
+				       dma_unmap_addr(&tx_cb->map[i], mapaddr),
 				       dma_unmap_len(&tx_cb->map[i], maplen),
-				       PCI_DMA_TODEVICE);
+				       DMA_TO_DEVICE);
 		}
 	}
 	qdev->ndev->stats.tx_packets++;
@@ -2021,10 +2017,9 @@ static void ql_process_mac_rx_intr(struct ql3_adapter *qdev,
 	qdev->ndev->stats.rx_bytes += length;
 
 	skb_put(skb, length);
-	pci_unmap_single(qdev->pdev,
+	dma_unmap_single(&qdev->pdev->dev,
 			 dma_unmap_addr(lrg_buf_cb2, mapaddr),
-			 dma_unmap_len(lrg_buf_cb2, maplen),
-			 PCI_DMA_FROMDEVICE);
+			 dma_unmap_len(lrg_buf_cb2, maplen), DMA_FROM_DEVICE);
 	prefetch(skb->data);
 	skb_checksum_none_assert(skb);
 	skb->protocol = eth_type_trans(skb, qdev->ndev);
@@ -2067,10 +2062,9 @@ static void ql_process_macip_rx_intr(struct ql3_adapter *qdev,
 	skb2 = lrg_buf_cb2->skb;
 
 	skb_put(skb2, length);	/* Just the second buffer length here. */
-	pci_unmap_single(qdev->pdev,
+	dma_unmap_single(&qdev->pdev->dev,
 			 dma_unmap_addr(lrg_buf_cb2, mapaddr),
-			 dma_unmap_len(lrg_buf_cb2, maplen),
-			 PCI_DMA_FROMDEVICE);
+			 dma_unmap_len(lrg_buf_cb2, maplen), DMA_FROM_DEVICE);
 	prefetch(skb2->data);
 
 	skb_checksum_none_assert(skb2);
@@ -2319,9 +2313,9 @@ static int ql_send_map(struct ql3_adapter *qdev,
 	/*
 	 * Map the skb buffer first.
 	 */
-	map = pci_map_single(qdev->pdev, skb->data, len, PCI_DMA_TODEVICE);
+	map = dma_map_single(&qdev->pdev->dev, skb->data, len, DMA_TO_DEVICE);
 
-	err = pci_dma_mapping_error(qdev->pdev, map);
+	err = dma_mapping_error(&qdev->pdev->dev, map);
 	if (err) {
 		netdev_err(qdev->ndev, "PCI mapping failed with error: %d\n",
 			   err);
@@ -2357,11 +2351,11 @@ static int ql_send_map(struct ql3_adapter *qdev,
 		    (seg == 7 && seg_cnt > 8) ||
 		    (seg == 12 && seg_cnt > 13) ||
 		    (seg == 17 && seg_cnt > 18)) {
-			map = pci_map_single(qdev->pdev, oal,
+			map = dma_map_single(&qdev->pdev->dev, oal,
 					     sizeof(struct oal),
-					     PCI_DMA_TODEVICE);
+					     DMA_TO_DEVICE);
 
-			err = pci_dma_mapping_error(qdev->pdev, map);
+			err = dma_mapping_error(&qdev->pdev->dev, map);
 			if (err) {
 				netdev_err(qdev->ndev,
 					   "PCI mapping outbound address list with error: %d\n",
@@ -2423,24 +2417,24 @@ static int ql_send_map(struct ql3_adapter *qdev,
 		    (seg == 7 && seg_cnt > 8) ||
 		    (seg == 12 && seg_cnt > 13) ||
 		    (seg == 17 && seg_cnt > 18)) {
-			pci_unmap_single(qdev->pdev,
-				dma_unmap_addr(&tx_cb->map[seg], mapaddr),
-				dma_unmap_len(&tx_cb->map[seg], maplen),
-				 PCI_DMA_TODEVICE);
+			dma_unmap_single(&qdev->pdev->dev,
+					 dma_unmap_addr(&tx_cb->map[seg], mapaddr),
+					 dma_unmap_len(&tx_cb->map[seg], maplen),
+					 DMA_TO_DEVICE);
 			oal++;
 			seg++;
 		}
 
-		pci_unmap_page(qdev->pdev,
+		dma_unmap_page(&qdev->pdev->dev,
 			       dma_unmap_addr(&tx_cb->map[seg], mapaddr),
 			       dma_unmap_len(&tx_cb->map[seg], maplen),
-			       PCI_DMA_TODEVICE);
+			       DMA_TO_DEVICE);
 	}
 
-	pci_unmap_single(qdev->pdev,
+	dma_unmap_single(&qdev->pdev->dev,
 			 dma_unmap_addr(&tx_cb->map[0], mapaddr),
 			 dma_unmap_addr(&tx_cb->map[0], maplen),
-			 PCI_DMA_TODEVICE);
+			 DMA_TO_DEVICE);
 
 	return NETDEV_TX_BUSY;
 
@@ -2525,9 +2519,8 @@ static int ql_alloc_net_req_rsp_queues(struct ql3_adapter *qdev)
 	wmb();
 
 	qdev->req_q_virt_addr =
-	    pci_alloc_consistent(qdev->pdev,
-				 (size_t) qdev->req_q_size,
-				 &qdev->req_q_phy_addr);
+	    dma_alloc_coherent(&qdev->pdev->dev, (size_t)qdev->req_q_size,
+			       &qdev->req_q_phy_addr, GFP_KERNEL);
 
 	if ((qdev->req_q_virt_addr == NULL) ||
 	    LS_64BITS(qdev->req_q_phy_addr) & (qdev->req_q_size - 1)) {
@@ -2536,16 +2529,14 @@ static int ql_alloc_net_req_rsp_queues(struct ql3_adapter *qdev)
 	}
 
 	qdev->rsp_q_virt_addr =
-	    pci_alloc_consistent(qdev->pdev,
-				 (size_t) qdev->rsp_q_size,
-				 &qdev->rsp_q_phy_addr);
+	    dma_alloc_coherent(&qdev->pdev->dev, (size_t)qdev->rsp_q_size,
+			       &qdev->rsp_q_phy_addr, GFP_KERNEL);
 
 	if ((qdev->rsp_q_virt_addr == NULL) ||
 	    LS_64BITS(qdev->rsp_q_phy_addr) & (qdev->rsp_q_size - 1)) {
 		netdev_err(qdev->ndev, "rspQ allocation failed\n");
-		pci_free_consistent(qdev->pdev, (size_t) qdev->req_q_size,
-				    qdev->req_q_virt_addr,
-				    qdev->req_q_phy_addr);
+		dma_free_coherent(&qdev->pdev->dev, (size_t)qdev->req_q_size,
+				  qdev->req_q_virt_addr, qdev->req_q_phy_addr);
 		return -ENOMEM;
 	}
 
@@ -2561,15 +2552,13 @@ static void ql_free_net_req_rsp_queues(struct ql3_adapter *qdev)
 		return;
 	}
 
-	pci_free_consistent(qdev->pdev,
-			    qdev->req_q_size,
-			    qdev->req_q_virt_addr, qdev->req_q_phy_addr);
+	dma_free_coherent(&qdev->pdev->dev, qdev->req_q_size,
+			  qdev->req_q_virt_addr, qdev->req_q_phy_addr);
 
 	qdev->req_q_virt_addr = NULL;
 
-	pci_free_consistent(qdev->pdev,
-			    qdev->rsp_q_size,
-			    qdev->rsp_q_virt_addr, qdev->rsp_q_phy_addr);
+	dma_free_coherent(&qdev->pdev->dev, qdev->rsp_q_size,
+			  qdev->rsp_q_virt_addr, qdev->rsp_q_phy_addr);
 
 	qdev->rsp_q_virt_addr = NULL;
 
@@ -2593,9 +2582,9 @@ static int ql_alloc_buffer_queues(struct ql3_adapter *qdev)
 		return -ENOMEM;
 
 	qdev->lrg_buf_q_alloc_virt_addr =
-		pci_alloc_consistent(qdev->pdev,
-				     qdev->lrg_buf_q_alloc_size,
-				     &qdev->lrg_buf_q_alloc_phy_addr);
+		dma_alloc_coherent(&qdev->pdev->dev,
+				   qdev->lrg_buf_q_alloc_size,
+				   &qdev->lrg_buf_q_alloc_phy_addr, GFP_KERNEL);
 
 	if (qdev->lrg_buf_q_alloc_virt_addr == NULL) {
 		netdev_err(qdev->ndev, "lBufQ failed\n");
@@ -2613,15 +2602,16 @@ static int ql_alloc_buffer_queues(struct ql3_adapter *qdev)
 		qdev->small_buf_q_alloc_size = qdev->small_buf_q_size * 2;
 
 	qdev->small_buf_q_alloc_virt_addr =
-		pci_alloc_consistent(qdev->pdev,
-				     qdev->small_buf_q_alloc_size,
-				     &qdev->small_buf_q_alloc_phy_addr);
+		dma_alloc_coherent(&qdev->pdev->dev,
+				   qdev->small_buf_q_alloc_size,
+				   &qdev->small_buf_q_alloc_phy_addr, GFP_KERNEL);
 
 	if (qdev->small_buf_q_alloc_virt_addr == NULL) {
 		netdev_err(qdev->ndev, "Small Buffer Queue allocation failed\n");
-		pci_free_consistent(qdev->pdev, qdev->lrg_buf_q_alloc_size,
-				    qdev->lrg_buf_q_alloc_virt_addr,
-				    qdev->lrg_buf_q_alloc_phy_addr);
+		dma_free_coherent(&qdev->pdev->dev,
+				  qdev->lrg_buf_q_alloc_size,
+				  qdev->lrg_buf_q_alloc_virt_addr,
+				  qdev->lrg_buf_q_alloc_phy_addr);
 		return -ENOMEM;
 	}
 
@@ -2638,17 +2628,15 @@ static void ql_free_buffer_queues(struct ql3_adapter *qdev)
 		return;
 	}
 	kfree(qdev->lrg_buf);
-	pci_free_consistent(qdev->pdev,
-			    qdev->lrg_buf_q_alloc_size,
-			    qdev->lrg_buf_q_alloc_virt_addr,
-			    qdev->lrg_buf_q_alloc_phy_addr);
+	dma_free_coherent(&qdev->pdev->dev, qdev->lrg_buf_q_alloc_size,
+			  qdev->lrg_buf_q_alloc_virt_addr,
+			  qdev->lrg_buf_q_alloc_phy_addr);
 
 	qdev->lrg_buf_q_virt_addr = NULL;
 
-	pci_free_consistent(qdev->pdev,
-			    qdev->small_buf_q_alloc_size,
-			    qdev->small_buf_q_alloc_virt_addr,
-			    qdev->small_buf_q_alloc_phy_addr);
+	dma_free_coherent(&qdev->pdev->dev, qdev->small_buf_q_alloc_size,
+			  qdev->small_buf_q_alloc_virt_addr,
+			  qdev->small_buf_q_alloc_phy_addr);
 
 	qdev->small_buf_q_virt_addr = NULL;
 
@@ -2666,9 +2654,9 @@ static int ql_alloc_small_buffers(struct ql3_adapter *qdev)
 		 QL_SMALL_BUFFER_SIZE);
 
 	qdev->small_buf_virt_addr =
-		pci_alloc_consistent(qdev->pdev,
-				     qdev->small_buf_total_size,
-				     &qdev->small_buf_phy_addr);
+		dma_alloc_coherent(&qdev->pdev->dev,
+				   qdev->small_buf_total_size,
+				   &qdev->small_buf_phy_addr, GFP_KERNEL);
 
 	if (qdev->small_buf_virt_addr == NULL) {
 		netdev_err(qdev->ndev, "Failed to get small buffer memory\n");
@@ -2701,10 +2689,10 @@ static void ql_free_small_buffers(struct ql3_adapter *qdev)
 		return;
 	}
 	if (qdev->small_buf_virt_addr != NULL) {
-		pci_free_consistent(qdev->pdev,
-				    qdev->small_buf_total_size,
-				    qdev->small_buf_virt_addr,
-				    qdev->small_buf_phy_addr);
+		dma_free_coherent(&qdev->pdev->dev,
+				  qdev->small_buf_total_size,
+				  qdev->small_buf_virt_addr,
+				  qdev->small_buf_phy_addr);
 
 		qdev->small_buf_virt_addr = NULL;
 	}
@@ -2719,10 +2707,10 @@ static void ql_free_large_buffers(struct ql3_adapter *qdev)
 		lrg_buf_cb = &qdev->lrg_buf[i];
 		if (lrg_buf_cb->skb) {
 			dev_kfree_skb(lrg_buf_cb->skb);
-			pci_unmap_single(qdev->pdev,
+			dma_unmap_single(&qdev->pdev->dev,
 					 dma_unmap_addr(lrg_buf_cb, mapaddr),
 					 dma_unmap_len(lrg_buf_cb, maplen),
-					 PCI_DMA_FROMDEVICE);
+					 DMA_FROM_DEVICE);
 			memset(lrg_buf_cb, 0, sizeof(struct ql_rcv_buf_cb));
 		} else {
 			break;
@@ -2774,13 +2762,11 @@ static int ql_alloc_large_buffers(struct ql3_adapter *qdev)
 			 * buffer
 			 */
 			skb_reserve(skb, QL_HEADER_SPACE);
-			map = pci_map_single(qdev->pdev,
-					     skb->data,
-					     qdev->lrg_buffer_len -
-					     QL_HEADER_SPACE,
-					     PCI_DMA_FROMDEVICE);
+			map = dma_map_single(&qdev->pdev->dev, skb->data,
+					     qdev->lrg_buffer_len - QL_HEADER_SPACE,
+					     DMA_FROM_DEVICE);
 
-			err = pci_dma_mapping_error(qdev->pdev, map);
+			err = dma_mapping_error(&qdev->pdev->dev, map);
 			if (err) {
 				netdev_err(qdev->ndev,
 					   "PCI mapping failed with error: %d\n",
@@ -2865,8 +2851,8 @@ static int ql_alloc_mem_resources(struct ql3_adapter *qdev)
 	 * Network Completion Queue Producer Index Register
 	 */
 	qdev->shadow_reg_virt_addr =
-		pci_alloc_consistent(qdev->pdev,
-				     PAGE_SIZE, &qdev->shadow_reg_phy_addr);
+		dma_alloc_coherent(&qdev->pdev->dev, PAGE_SIZE,
+				   &qdev->shadow_reg_phy_addr, GFP_KERNEL);
 
 	if (qdev->shadow_reg_virt_addr != NULL) {
 		qdev->preq_consumer_index = qdev->shadow_reg_virt_addr;
@@ -2921,10 +2907,9 @@ static int ql_alloc_mem_resources(struct ql3_adapter *qdev)
 err_buffer_queues:
 	ql_free_net_req_rsp_queues(qdev);
 err_req_rsp:
-	pci_free_consistent(qdev->pdev,
-			    PAGE_SIZE,
-			    qdev->shadow_reg_virt_addr,
-			    qdev->shadow_reg_phy_addr);
+	dma_free_coherent(&qdev->pdev->dev, PAGE_SIZE,
+			  qdev->shadow_reg_virt_addr,
+			  qdev->shadow_reg_phy_addr);
 
 	return -ENOMEM;
 }
@@ -2937,10 +2922,9 @@ static void ql_free_mem_resources(struct ql3_adapter *qdev)
 	ql_free_buffer_queues(qdev);
 	ql_free_net_req_rsp_queues(qdev);
 	if (qdev->shadow_reg_virt_addr != NULL) {
-		pci_free_consistent(qdev->pdev,
-				    PAGE_SIZE,
-				    qdev->shadow_reg_virt_addr,
-				    qdev->shadow_reg_phy_addr);
+		dma_free_coherent(&qdev->pdev->dev, PAGE_SIZE,
+				  qdev->shadow_reg_virt_addr,
+				  qdev->shadow_reg_phy_addr);
 		qdev->shadow_reg_virt_addr = NULL;
 	}
 }
@@ -3641,18 +3625,15 @@ static void ql_reset_work(struct work_struct *work)
 			if (tx_cb->skb) {
 				netdev_printk(KERN_DEBUG, ndev,
 					      "Freeing lost SKB\n");
-				pci_unmap_single(qdev->pdev,
-					 dma_unmap_addr(&tx_cb->map[0],
-							mapaddr),
-					 dma_unmap_len(&tx_cb->map[0], maplen),
-					 PCI_DMA_TODEVICE);
+				dma_unmap_single(&qdev->pdev->dev,
+						 dma_unmap_addr(&tx_cb->map[0], mapaddr),
+						 dma_unmap_len(&tx_cb->map[0], maplen),
+						 DMA_TO_DEVICE);
 				for (j = 1; j < tx_cb->seg_count; j++) {
-					pci_unmap_page(qdev->pdev,
-					       dma_unmap_addr(&tx_cb->map[j],
-							      mapaddr),
-					       dma_unmap_len(&tx_cb->map[j],
-							     maplen),
-					       PCI_DMA_TODEVICE);
+					dma_unmap_page(&qdev->pdev->dev,
+						       dma_unmap_addr(&tx_cb->map[j], mapaddr),
+						       dma_unmap_len(&tx_cb->map[j], maplen),
+						       DMA_TO_DEVICE);
 				}
 				dev_kfree_skb(tx_cb->skb);
 				tx_cb->skb = NULL;
@@ -3784,13 +3765,10 @@ static int ql3xxx_probe(struct pci_dev *pdev,
 
 	pci_set_master(pdev);
 
-	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+	if (!dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)))
 		pci_using_dac = 1;
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
-	} else if (!(err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))) {
+	else if (!(err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))))
 		pci_using_dac = 0;
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
-	}
 
 	if (err) {
 		pr_err("%s no usable DMA configuration\n", pci_name(pdev));
-- 
2.27.0

