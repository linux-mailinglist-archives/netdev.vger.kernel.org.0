Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C2424EC32
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 10:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgHWIhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 04:37:02 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:32209 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbgHWIg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 04:36:56 -0400
Received: from localhost.localdomain ([93.22.133.217])
        by mwinf5d55 with ME
        id Jwcr2300H4hbG4l03wcsbl; Sun, 23 Aug 2020 10:36:53 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 23 Aug 2020 10:36:53 +0200
X-ME-IP: 93.22.133.217
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, leon@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] chelsio: switch from 'pci_' to 'dma_' API
Date:   Sun, 23 Aug 2020 10:36:48 +0200
Message-Id: <20200823083648.171858-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'free_rx_resources()' and
'alloc_tx_resources()' (sge.c) GFP_KERNEL can be used because it is
already used in these functions.

Moreover, they can only be called from a .ndo_open	function. So it is
guarded by the 'rtnl_lock()', which is a mutex.

While at it, a pr_err message in 'init_one()' has been updated accordingly
(s/consistent/coherent).

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
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c | 10 ++--
 drivers/net/ethernet/chelsio/cxgb/sge.c   | 64 ++++++++++++-----------
 2 files changed, 39 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 99736796e1a0..0e4a0f413960 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -997,17 +997,17 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_disable_pdev;
 	}
 
-	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
 		pci_using_dac = 1;
 
-		if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))) {
-			pr_err("%s: unable to obtain 64-bit DMA for "
-			       "consistent allocations\n", pci_name(pdev));
+		if (dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64))) {
+			pr_err("%s: unable to obtain 64-bit DMA for coherent allocations\n",
+			       pci_name(pdev));
 			err = -ENODEV;
 			goto out_disable_pdev;
 		}
 
-	} else if ((err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) != 0) {
+	} else if ((err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) != 0) {
 		pr_err("%s: no usable DMA configuration\n", pci_name(pdev));
 		goto out_disable_pdev;
 	}
diff --git a/drivers/net/ethernet/chelsio/cxgb/sge.c b/drivers/net/ethernet/chelsio/cxgb/sge.c
index 47b5c8e2104b..21016de20b2d 100644
--- a/drivers/net/ethernet/chelsio/cxgb/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb/sge.c
@@ -509,9 +509,8 @@ static void free_freelQ_buffers(struct pci_dev *pdev, struct freelQ *q)
 	while (q->credits--) {
 		struct freelQ_ce *ce = &q->centries[cidx];
 
-		pci_unmap_single(pdev, dma_unmap_addr(ce, dma_addr),
-				 dma_unmap_len(ce, dma_len),
-				 PCI_DMA_FROMDEVICE);
+		dma_unmap_single(&pdev->dev, dma_unmap_addr(ce, dma_addr),
+				 dma_unmap_len(ce, dma_len), DMA_FROM_DEVICE);
 		dev_kfree_skb(ce->skb);
 		ce->skb = NULL;
 		if (++cidx == q->size)
@@ -529,8 +528,8 @@ static void free_rx_resources(struct sge *sge)
 
 	if (sge->respQ.entries) {
 		size = sizeof(struct respQ_e) * sge->respQ.size;
-		pci_free_consistent(pdev, size, sge->respQ.entries,
-				    sge->respQ.dma_addr);
+		dma_free_coherent(&pdev->dev, size, sge->respQ.entries,
+				  sge->respQ.dma_addr);
 	}
 
 	for (i = 0; i < SGE_FREELQ_N; i++) {
@@ -542,8 +541,8 @@ static void free_rx_resources(struct sge *sge)
 		}
 		if (q->entries) {
 			size = sizeof(struct freelQ_e) * q->size;
-			pci_free_consistent(pdev, size, q->entries,
-					    q->dma_addr);
+			dma_free_coherent(&pdev->dev, size, q->entries,
+					  q->dma_addr);
 		}
 	}
 }
@@ -564,7 +563,8 @@ static int alloc_rx_resources(struct sge *sge, struct sge_params *p)
 		q->size = p->freelQ_size[i];
 		q->dma_offset = sge->rx_pkt_pad ? 0 : NET_IP_ALIGN;
 		size = sizeof(struct freelQ_e) * q->size;
-		q->entries = pci_alloc_consistent(pdev, size, &q->dma_addr);
+		q->entries = dma_alloc_coherent(&pdev->dev, size,
+						&q->dma_addr, GFP_KERNEL);
 		if (!q->entries)
 			goto err_no_mem;
 
@@ -601,7 +601,8 @@ static int alloc_rx_resources(struct sge *sge, struct sge_params *p)
 	sge->respQ.credits = 0;
 	size = sizeof(struct respQ_e) * sge->respQ.size;
 	sge->respQ.entries =
-		pci_alloc_consistent(pdev, size, &sge->respQ.dma_addr);
+		dma_alloc_coherent(&pdev->dev, size, &sge->respQ.dma_addr,
+				   GFP_KERNEL);
 	if (!sge->respQ.entries)
 		goto err_no_mem;
 	return 0;
@@ -624,9 +625,10 @@ static void free_cmdQ_buffers(struct sge *sge, struct cmdQ *q, unsigned int n)
 	ce = &q->centries[cidx];
 	while (n--) {
 		if (likely(dma_unmap_len(ce, dma_len))) {
-			pci_unmap_single(pdev, dma_unmap_addr(ce, dma_addr),
+			dma_unmap_single(&pdev->dev,
+					 dma_unmap_addr(ce, dma_addr),
 					 dma_unmap_len(ce, dma_len),
-					 PCI_DMA_TODEVICE);
+					 DMA_TO_DEVICE);
 			if (q->sop)
 				q->sop = 0;
 		}
@@ -663,8 +665,8 @@ static void free_tx_resources(struct sge *sge)
 		}
 		if (q->entries) {
 			size = sizeof(struct cmdQ_e) * q->size;
-			pci_free_consistent(pdev, size, q->entries,
-					    q->dma_addr);
+			dma_free_coherent(&pdev->dev, size, q->entries,
+					  q->dma_addr);
 		}
 	}
 }
@@ -689,7 +691,8 @@ static int alloc_tx_resources(struct sge *sge, struct sge_params *p)
 		q->stop_thres = 0;
 		spin_lock_init(&q->lock);
 		size = sizeof(struct cmdQ_e) * q->size;
-		q->entries = pci_alloc_consistent(pdev, size, &q->dma_addr);
+		q->entries = dma_alloc_coherent(&pdev->dev, size,
+						&q->dma_addr, GFP_KERNEL);
 		if (!q->entries)
 			goto err_no_mem;
 
@@ -837,8 +840,8 @@ static void refill_free_list(struct sge *sge, struct freelQ *q)
 			break;
 
 		skb_reserve(skb, q->dma_offset);
-		mapping = pci_map_single(pdev, skb->data, dma_len,
-					 PCI_DMA_FROMDEVICE);
+		mapping = dma_map_single(&pdev->dev, skb->data, dma_len,
+					 DMA_FROM_DEVICE);
 		skb_reserve(skb, sge->rx_pkt_pad);
 
 		ce->skb = skb;
@@ -1049,15 +1052,15 @@ static inline struct sk_buff *get_packet(struct adapter *adapter,
 			goto use_orig_buf;
 
 		skb_put(skb, len);
-		pci_dma_sync_single_for_cpu(pdev,
-					    dma_unmap_addr(ce, dma_addr),
-					    dma_unmap_len(ce, dma_len),
-					    PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_cpu(&pdev->dev,
+					dma_unmap_addr(ce, dma_addr),
+					dma_unmap_len(ce, dma_len),
+					DMA_FROM_DEVICE);
 		skb_copy_from_linear_data(ce->skb, skb->data, len);
-		pci_dma_sync_single_for_device(pdev,
-					       dma_unmap_addr(ce, dma_addr),
-					       dma_unmap_len(ce, dma_len),
-					       PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_device(&pdev->dev,
+					   dma_unmap_addr(ce, dma_addr),
+					   dma_unmap_len(ce, dma_len),
+					   DMA_FROM_DEVICE);
 		recycle_fl_buf(fl, fl->cidx);
 		return skb;
 	}
@@ -1068,8 +1071,8 @@ static inline struct sk_buff *get_packet(struct adapter *adapter,
 		return NULL;
 	}
 
-	pci_unmap_single(pdev, dma_unmap_addr(ce, dma_addr),
-			 dma_unmap_len(ce, dma_len), PCI_DMA_FROMDEVICE);
+	dma_unmap_single(&pdev->dev, dma_unmap_addr(ce, dma_addr),
+			 dma_unmap_len(ce, dma_len), DMA_FROM_DEVICE);
 	skb = ce->skb;
 	prefetch(skb->data);
 
@@ -1091,8 +1094,9 @@ static void unexpected_offload(struct adapter *adapter, struct freelQ *fl)
 	struct freelQ_ce *ce = &fl->centries[fl->cidx];
 	struct sk_buff *skb = ce->skb;
 
-	pci_dma_sync_single_for_cpu(adapter->pdev, dma_unmap_addr(ce, dma_addr),
-			    dma_unmap_len(ce, dma_len), PCI_DMA_FROMDEVICE);
+	dma_sync_single_for_cpu(&adapter->pdev->dev,
+				dma_unmap_addr(ce, dma_addr),
+				dma_unmap_len(ce, dma_len), DMA_FROM_DEVICE);
 	pr_err("%s: unexpected offload packet, cmd %u\n",
 	       adapter->name, *skb->data);
 	recycle_fl_buf(fl, fl->cidx);
@@ -1209,8 +1213,8 @@ static inline void write_tx_descs(struct adapter *adapter, struct sk_buff *skb,
 	e = e1 = &q->entries[pidx];
 	ce = &q->centries[pidx];
 
-	mapping = pci_map_single(adapter->pdev, skb->data,
-				 skb_headlen(skb), PCI_DMA_TODEVICE);
+	mapping = dma_map_single(&adapter->pdev->dev, skb->data,
+				 skb_headlen(skb), DMA_TO_DEVICE);
 
 	desc_mapping = mapping;
 	desc_len = skb_headlen(skb);
-- 
2.25.1

