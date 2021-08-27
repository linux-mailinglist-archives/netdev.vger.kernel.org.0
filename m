Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A993FA031
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 21:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhH0T53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 15:57:29 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:23230 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231590AbhH0T50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 15:57:26 -0400
Received: from pop-os.home ([90.126.253.178])
        by mwinf5d77 with ME
        id mjwU2500F3riaq203jwVS9; Fri, 27 Aug 2021 21:56:35 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 27 Aug 2021 21:56:35 +0200
X-ME-IP: 90.126.253.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     kou.ishizaki@toshiba.co.jp, geoff@infradead.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: spider_net: switch from 'pci_' to 'dma_' API
Date:   Fri, 27 Aug 2021 21:56:28 +0200
Message-Id: <60abc3d0c8b4ef8368a4d63326a25a5cb3cd218c.1630094078.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In [1], Christoph Hellwig has proposed to remove the wrappers in
include/linux/pci-dma-compat.h.

Some reasons why this API should be removed have been given by Julia
Lawall in [2].

A coccinelle script has been used to perform the needed transformation
Only relevant parts are given below.

@@ @@
-    PCI_DMA_BIDIRECTIONAL
+    DMA_BIDIRECTIONAL

@@ @@
-    PCI_DMA_TODEVICE
+    DMA_TO_DEVICE

@@ @@
-    PCI_DMA_FROMDEVICE
+    DMA_FROM_DEVICE

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
expression e1, e2;
@@
-    pci_dma_mapping_error(e1, e2)
+    dma_mapping_error(&e1->dev, e2)


[1]: https://lore.kernel.org/kernel-janitors/20200421081257.GA131897@infradead.org/
[2]: https://lore.kernel.org/kernel-janitors/alpine.DEB.2.22.394.2007120902170.2424@hadrien/

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
It has *not* been compile tested because I don't have the needed
configuration or cross-compiler. However, the modification is completely
mechanical and done by coccinelle.
---
 drivers/net/ethernet/toshiba/spider_net.c | 27 +++++++++++++----------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index 087f0af56c50..66d4e024d11e 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -354,9 +354,10 @@ spider_net_free_rx_chain_contents(struct spider_net_card *card)
 	descr = card->rx_chain.head;
 	do {
 		if (descr->skb) {
-			pci_unmap_single(card->pdev, descr->hwdescr->buf_addr,
+			dma_unmap_single(&card->pdev->dev,
+					 descr->hwdescr->buf_addr,
 					 SPIDER_NET_MAX_FRAME,
-					 PCI_DMA_BIDIRECTIONAL);
+					 DMA_BIDIRECTIONAL);
 			dev_kfree_skb(descr->skb);
 			descr->skb = NULL;
 		}
@@ -411,9 +412,9 @@ spider_net_prepare_rx_descr(struct spider_net_card *card,
 	if (offset)
 		skb_reserve(descr->skb, SPIDER_NET_RXBUF_ALIGN - offset);
 	/* iommu-map the skb */
-	buf = pci_map_single(card->pdev, descr->skb->data,
-			SPIDER_NET_MAX_FRAME, PCI_DMA_FROMDEVICE);
-	if (pci_dma_mapping_error(card->pdev, buf)) {
+	buf = dma_map_single(&card->pdev->dev, descr->skb->data,
+			     SPIDER_NET_MAX_FRAME, DMA_FROM_DEVICE);
+	if (dma_mapping_error(&card->pdev->dev, buf)) {
 		dev_kfree_skb_any(descr->skb);
 		descr->skb = NULL;
 		if (netif_msg_rx_err(card) && net_ratelimit())
@@ -653,8 +654,9 @@ spider_net_prepare_tx_descr(struct spider_net_card *card,
 	dma_addr_t buf;
 	unsigned long flags;
 
-	buf = pci_map_single(card->pdev, skb->data, skb->len, PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(card->pdev, buf)) {
+	buf = dma_map_single(&card->pdev->dev, skb->data, skb->len,
+			     DMA_TO_DEVICE);
+	if (dma_mapping_error(&card->pdev->dev, buf)) {
 		if (netif_msg_tx_err(card) && net_ratelimit())
 			dev_err(&card->netdev->dev, "could not iommu-map packet (%p, %i). "
 				  "Dropping packet\n", skb->data, skb->len);
@@ -666,7 +668,8 @@ spider_net_prepare_tx_descr(struct spider_net_card *card,
 	descr = card->tx_chain.head;
 	if (descr->next == chain->tail->prev) {
 		spin_unlock_irqrestore(&chain->lock, flags);
-		pci_unmap_single(card->pdev, buf, skb->len, PCI_DMA_TODEVICE);
+		dma_unmap_single(&card->pdev->dev, buf, skb->len,
+				 DMA_TO_DEVICE);
 		return -ENOMEM;
 	}
 	hwdescr = descr->hwdescr;
@@ -822,8 +825,8 @@ spider_net_release_tx_chain(struct spider_net_card *card, int brutal)
 
 		/* unmap the skb */
 		if (skb) {
-			pci_unmap_single(card->pdev, buf_addr, skb->len,
-					PCI_DMA_TODEVICE);
+			dma_unmap_single(&card->pdev->dev, buf_addr, skb->len,
+					 DMA_TO_DEVICE);
 			dev_consume_skb_any(skb);
 		}
 	}
@@ -1165,8 +1168,8 @@ spider_net_decode_one_descr(struct spider_net_card *card)
 	/* unmap descriptor */
 	hw_buf_addr = hwdescr->buf_addr;
 	hwdescr->buf_addr = 0xffffffff;
-	pci_unmap_single(card->pdev, hw_buf_addr,
-			SPIDER_NET_MAX_FRAME, PCI_DMA_FROMDEVICE);
+	dma_unmap_single(&card->pdev->dev, hw_buf_addr, SPIDER_NET_MAX_FRAME,
+			 DMA_FROM_DEVICE);
 
 	if ( (status == SPIDER_NET_DESCR_RESPONSE_ERROR) ||
 	     (status == SPIDER_NET_DESCR_PROTECTION_ERROR) ||
-- 
2.30.2

