Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A1824C133
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 17:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbgHTPG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 11:06:56 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:19345 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728274AbgHTPGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 11:06:51 -0400
Received: from localhost.localdomain ([93.22.135.164])
        by mwinf5d87 with ME
        id Hr6n2300H3YzEb903r6o4Z; Thu, 20 Aug 2020 17:06:49 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 20 Aug 2020 17:06:49 +0200
X-ME-IP: 93.22.135.164
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     yhchuang@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] rtw88: switch from 'pci_' to 'dma_' API
Date:   Thu, 20 Aug 2020 17:06:43 +0200
Message-Id: <20200820150643.148219-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'rtw_pci_init_tx_ring()' and
'rtw_pci_init_rx_ring()' GFP_KERNEL can be used because both functions are
called from a probe function and no spinlock is taken.

The call chain is:
  rtw_pci_probe
    --> rtw_pci_setup_resource
      --> rtw_pci_init
        --> rtw_pci_init_trx_ring
          --> rtw_pci_init_tx_ring
          --> rtw_pci_init_rx_ring


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
 drivers/net/wireless/realtek/rtw88/pci.c | 33 ++++++++++++------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 3413973bc475..135dd331691c 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -109,7 +109,7 @@ static void rtw_pci_free_tx_ring_skbs(struct rtw_dev *rtwdev,
 		tx_data = rtw_pci_get_tx_data(skb);
 		dma = tx_data->dma;
 
-		pci_unmap_single(pdev, dma, skb->len, PCI_DMA_TODEVICE);
+		dma_unmap_single(&pdev->dev, dma, skb->len, DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
 	}
 }
@@ -125,7 +125,7 @@ static void rtw_pci_free_tx_ring(struct rtw_dev *rtwdev,
 	rtw_pci_free_tx_ring_skbs(rtwdev, tx_ring);
 
 	/* free the ring itself */
-	pci_free_consistent(pdev, ring_sz, head, tx_ring->r.dma);
+	dma_free_coherent(&pdev->dev, ring_sz, head, tx_ring->r.dma);
 	tx_ring->r.head = NULL;
 }
 
@@ -144,7 +144,7 @@ static void rtw_pci_free_rx_ring_skbs(struct rtw_dev *rtwdev,
 			continue;
 
 		dma = *((dma_addr_t *)skb->cb);
-		pci_unmap_single(pdev, dma, buf_sz, PCI_DMA_FROMDEVICE);
+		dma_unmap_single(&pdev->dev, dma, buf_sz, DMA_FROM_DEVICE);
 		dev_kfree_skb(skb);
 		rx_ring->buf[i] = NULL;
 	}
@@ -159,7 +159,7 @@ static void rtw_pci_free_rx_ring(struct rtw_dev *rtwdev,
 
 	rtw_pci_free_rx_ring_skbs(rtwdev, rx_ring);
 
-	pci_free_consistent(pdev, ring_sz, head, rx_ring->r.dma);
+	dma_free_coherent(&pdev->dev, ring_sz, head, rx_ring->r.dma);
 }
 
 static void rtw_pci_free_trx_ring(struct rtw_dev *rtwdev)
@@ -194,7 +194,7 @@ static int rtw_pci_init_tx_ring(struct rtw_dev *rtwdev,
 		return -EINVAL;
 	}
 
-	head = pci_zalloc_consistent(pdev, ring_sz, &dma);
+	head = dma_alloc_coherent(&pdev->dev, ring_sz, &dma, GFP_KERNEL);
 	if (!head) {
 		rtw_err(rtwdev, "failed to allocate tx ring\n");
 		return -ENOMEM;
@@ -223,8 +223,8 @@ static int rtw_pci_reset_rx_desc(struct rtw_dev *rtwdev, struct sk_buff *skb,
 	if (!skb)
 		return -EINVAL;
 
-	dma = pci_map_single(pdev, skb->data, buf_sz, PCI_DMA_FROMDEVICE);
-	if (pci_dma_mapping_error(pdev, dma))
+	dma = dma_map_single(&pdev->dev, skb->data, buf_sz, DMA_FROM_DEVICE);
+	if (dma_mapping_error(&pdev->dev, dma))
 		return -EBUSY;
 
 	*((dma_addr_t *)skb->cb) = dma;
@@ -272,7 +272,7 @@ static int rtw_pci_init_rx_ring(struct rtw_dev *rtwdev,
 		return -EINVAL;
 	}
 
-	head = pci_zalloc_consistent(pdev, ring_sz, &dma);
+	head = dma_alloc_coherent(&pdev->dev, ring_sz, &dma, GFP_KERNEL);
 	if (!head) {
 		rtw_err(rtwdev, "failed to allocate rx ring\n");
 		return -ENOMEM;
@@ -311,11 +311,11 @@ static int rtw_pci_init_rx_ring(struct rtw_dev *rtwdev,
 		if (!skb)
 			continue;
 		dma = *((dma_addr_t *)skb->cb);
-		pci_unmap_single(pdev, dma, buf_sz, PCI_DMA_FROMDEVICE);
+		dma_unmap_single(&pdev->dev, dma, buf_sz, DMA_FROM_DEVICE);
 		dev_kfree_skb_any(skb);
 		rx_ring->buf[i] = NULL;
 	}
-	pci_free_consistent(pdev, ring_sz, head, dma);
+	dma_free_coherent(&pdev->dev, ring_sz, head, dma);
 
 	rtw_err(rtwdev, "failed to init rx buffer\n");
 
@@ -675,8 +675,7 @@ static void rtw_pci_release_rsvd_page(struct rtw_pci *rtwpci,
 
 	tx_data = rtw_pci_get_tx_data(prev);
 	dma = tx_data->dma;
-	pci_unmap_single(rtwpci->pdev, dma, prev->len,
-			 PCI_DMA_TODEVICE);
+	dma_unmap_single(&rtwpci->pdev->dev, dma, prev->len, DMA_TO_DEVICE);
 	dev_kfree_skb_any(prev);
 }
 
@@ -755,9 +754,9 @@ static int rtw_pci_tx_write_data(struct rtw_dev *rtwdev,
 	memset(pkt_desc, 0, tx_pkt_desc_sz);
 	pkt_info->qsel = rtw_pci_get_tx_qsel(skb, queue);
 	rtw_tx_fill_tx_desc(pkt_info, skb);
-	dma = pci_map_single(rtwpci->pdev, skb->data, skb->len,
-			     PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(rtwpci->pdev, dma))
+	dma = dma_map_single(&rtwpci->pdev->dev, skb->data, skb->len,
+			     DMA_TO_DEVICE);
+	if (dma_mapping_error(&rtwpci->pdev->dev, dma))
 		return -EBUSY;
 
 	/* after this we got dma mapped, there is no way back */
@@ -896,8 +895,8 @@ static void rtw_pci_tx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 			break;
 		}
 		tx_data = rtw_pci_get_tx_data(skb);
-		pci_unmap_single(rtwpci->pdev, tx_data->dma, skb->len,
-				 PCI_DMA_TODEVICE);
+		dma_unmap_single(&rtwpci->pdev->dev, tx_data->dma, skb->len,
+				 DMA_TO_DEVICE);
 
 		/* just free command packets from host to card */
 		if (hw_queue == RTW_TX_QUEUE_H2C) {
-- 
2.25.1

