Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E28262115
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729876AbgIHU2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:28:05 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:51395 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728617AbgIHU2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 16:28:02 -0400
Received: from localhost.localdomain ([93.22.150.22])
        by mwinf5d58 with ME
        id RYTp230040VEKhH03YTpGu; Tue, 08 Sep 2020 22:27:58 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 08 Sep 2020 22:27:58 +0200
X-ME-IP: 93.22.150.22
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        mhabets@solarflare.com, tony.felice@timesys.com, mst@redhat.com,
        gustavo@embeddedor.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: tc35815: switch from 'pci_' to 'dma_' API
Date:   Tue,  8 Sep 2020 22:27:47 +0200
Message-Id: <20200908202747.330007-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'tc35815_init_queues()' GFP_ATOMIC must be used
because it can be called from 'tc35815_restart()' where some spinlock are
taken.
The call chain is:
  tc35815_restart
    --> tc35815_clear_queues
      --> tc35815_init_queues


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
 drivers/net/ethernet/toshiba/tc35815.c | 48 +++++++++++++++-----------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/tc35815.c b/drivers/net/ethernet/toshiba/tc35815.c
index 6bcda20ed7e7..eb82f5483023 100644
--- a/drivers/net/ethernet/toshiba/tc35815.c
+++ b/drivers/net/ethernet/toshiba/tc35815.c
@@ -454,9 +454,9 @@ static struct sk_buff *alloc_rxbuf_skb(struct net_device *dev,
 	skb = netdev_alloc_skb(dev, RX_BUF_SIZE);
 	if (!skb)
 		return NULL;
-	*dma_handle = pci_map_single(hwdev, skb->data, RX_BUF_SIZE,
-				     PCI_DMA_FROMDEVICE);
-	if (pci_dma_mapping_error(hwdev, *dma_handle)) {
+	*dma_handle = dma_map_single(&hwdev->dev, skb->data, RX_BUF_SIZE,
+				     DMA_FROM_DEVICE);
+	if (dma_mapping_error(&hwdev->dev, *dma_handle)) {
 		dev_kfree_skb_any(skb);
 		return NULL;
 	}
@@ -466,8 +466,8 @@ static struct sk_buff *alloc_rxbuf_skb(struct net_device *dev,
 
 static void free_rxbuf_skb(struct pci_dev *hwdev, struct sk_buff *skb, dma_addr_t dma_handle)
 {
-	pci_unmap_single(hwdev, dma_handle, RX_BUF_SIZE,
-			 PCI_DMA_FROMDEVICE);
+	dma_unmap_single(&hwdev->dev, dma_handle, RX_BUF_SIZE,
+			 DMA_FROM_DEVICE);
 	dev_kfree_skb_any(skb);
 }
 
@@ -876,9 +876,9 @@ tc35815_init_queues(struct net_device *dev)
 		       sizeof(struct TxFD) * TX_FD_NUM >
 		       PAGE_SIZE * FD_PAGE_NUM);
 
-		lp->fd_buf = pci_alloc_consistent(lp->pci_dev,
-						  PAGE_SIZE * FD_PAGE_NUM,
-						  &lp->fd_buf_dma);
+		lp->fd_buf = dma_alloc_coherent(&lp->pci_dev->dev,
+						PAGE_SIZE * FD_PAGE_NUM,
+						&lp->fd_buf_dma, GFP_ATOMIC);
 		if (!lp->fd_buf)
 			return -ENOMEM;
 		for (i = 0; i < RX_BUF_NUM; i++) {
@@ -892,10 +892,9 @@ tc35815_init_queues(struct net_device *dev)
 						       lp->rx_skbs[i].skb_dma);
 					lp->rx_skbs[i].skb = NULL;
 				}
-				pci_free_consistent(lp->pci_dev,
-						    PAGE_SIZE * FD_PAGE_NUM,
-						    lp->fd_buf,
-						    lp->fd_buf_dma);
+				dma_free_coherent(&lp->pci_dev->dev,
+						  PAGE_SIZE * FD_PAGE_NUM,
+						  lp->fd_buf, lp->fd_buf_dma);
 				lp->fd_buf = NULL;
 				return -ENOMEM;
 			}
@@ -990,7 +989,9 @@ tc35815_clear_queues(struct net_device *dev)
 		BUG_ON(lp->tx_skbs[i].skb != skb);
 #endif
 		if (skb) {
-			pci_unmap_single(lp->pci_dev, lp->tx_skbs[i].skb_dma, skb->len, PCI_DMA_TODEVICE);
+			dma_unmap_single(&lp->pci_dev->dev,
+					 lp->tx_skbs[i].skb_dma, skb->len,
+					 DMA_TO_DEVICE);
 			lp->tx_skbs[i].skb = NULL;
 			lp->tx_skbs[i].skb_dma = 0;
 			dev_kfree_skb_any(skb);
@@ -1022,7 +1023,9 @@ tc35815_free_queues(struct net_device *dev)
 			BUG_ON(lp->tx_skbs[i].skb != skb);
 #endif
 			if (skb) {
-				pci_unmap_single(lp->pci_dev, lp->tx_skbs[i].skb_dma, skb->len, PCI_DMA_TODEVICE);
+				dma_unmap_single(&lp->pci_dev->dev,
+						 lp->tx_skbs[i].skb_dma,
+						 skb->len, DMA_TO_DEVICE);
 				dev_kfree_skb(skb);
 				lp->tx_skbs[i].skb = NULL;
 				lp->tx_skbs[i].skb_dma = 0;
@@ -1044,8 +1047,8 @@ tc35815_free_queues(struct net_device *dev)
 		}
 	}
 	if (lp->fd_buf) {
-		pci_free_consistent(lp->pci_dev, PAGE_SIZE * FD_PAGE_NUM,
-				    lp->fd_buf, lp->fd_buf_dma);
+		dma_free_coherent(&lp->pci_dev->dev, PAGE_SIZE * FD_PAGE_NUM,
+				  lp->fd_buf, lp->fd_buf_dma);
 		lp->fd_buf = NULL;
 	}
 }
@@ -1292,7 +1295,10 @@ tc35815_send_packet(struct sk_buff *skb, struct net_device *dev)
 	BUG_ON(lp->tx_skbs[lp->tfd_start].skb);
 #endif
 	lp->tx_skbs[lp->tfd_start].skb = skb;
-	lp->tx_skbs[lp->tfd_start].skb_dma = pci_map_single(lp->pci_dev, skb->data, skb->len, PCI_DMA_TODEVICE);
+	lp->tx_skbs[lp->tfd_start].skb_dma = dma_map_single(&lp->pci_dev->dev,
+							    skb->data,
+							    skb->len,
+							    DMA_TO_DEVICE);
 
 	/*add to ring */
 	txfd = &lp->tfd_base[lp->tfd_start];
@@ -1500,9 +1506,9 @@ tc35815_rx(struct net_device *dev, int limit)
 			skb = lp->rx_skbs[cur_bd].skb;
 			prefetch(skb->data);
 			lp->rx_skbs[cur_bd].skb = NULL;
-			pci_unmap_single(lp->pci_dev,
+			dma_unmap_single(&lp->pci_dev->dev,
 					 lp->rx_skbs[cur_bd].skb_dma,
-					 RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
+					 RX_BUF_SIZE, DMA_FROM_DEVICE);
 			if (!HAVE_DMA_RXALIGN(lp) && NET_IP_ALIGN != 0)
 				memmove(skb->data, skb->data - NET_IP_ALIGN,
 					pkt_len);
@@ -1756,7 +1762,9 @@ tc35815_txdone(struct net_device *dev)
 #endif
 		if (skb) {
 			dev->stats.tx_bytes += skb->len;
-			pci_unmap_single(lp->pci_dev, lp->tx_skbs[lp->tfd_end].skb_dma, skb->len, PCI_DMA_TODEVICE);
+			dma_unmap_single(&lp->pci_dev->dev,
+					 lp->tx_skbs[lp->tfd_end].skb_dma,
+					 skb->len, DMA_TO_DEVICE);
 			lp->tx_skbs[lp->tfd_end].skb = NULL;
 			lp->tx_skbs[lp->tfd_end].skb_dma = 0;
 			dev_kfree_skb_any(skb);
-- 
2.25.1

