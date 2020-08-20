Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE6624C0D0
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 16:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgHTOqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 10:46:31 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:54187 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727868AbgHTOqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 10:46:19 -0400
Received: from localhost.localdomain ([93.22.135.164])
        by mwinf5d87 with ME
        id Hqm82300J3YzEb903qm8Ad; Thu, 20 Aug 2020 16:46:13 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 20 Aug 2020 16:46:13 +0200
X-ME-IP: 93.22.135.164
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, Larry.Finger@lwfinger.net,
        straube.linux@gmail.com, zhengbin13@huawei.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] rtlwifi: switch from 'pci_' to 'dma_' API
Date:   Thu, 20 Aug 2020 16:46:04 +0200
Message-Id: <20200820144604.144521-1-christophe.jaillet@wanadoo.fr>
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

The only file where some GFP_ flags are updated is 'pci.c'.

When memory is allocated in '_rtl_pci_init_tx_ring()' and
'_rtl_pci_init_rx_ring()' GFP_KERNEL can be used because both functions are
called from a probe function and no spinlock is taken.

The call chain is:
  rtl_pci_probe
    --> rtl_pci_init
      --> _rtl_pci_init_trx_ring
        --> _rtl_pci_init_rx_ring
        --> _rtl_pci_init_tx_ring


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
 drivers/net/wireless/realtek/rtlwifi/pci.c    | 116 +++++++++---------
 .../wireless/realtek/rtlwifi/rtl8188ee/hw.c   |   9 +-
 .../wireless/realtek/rtlwifi/rtl8188ee/trx.c  |  13 +-
 .../wireless/realtek/rtlwifi/rtl8192ce/trx.c  |  14 +--
 .../wireless/realtek/rtlwifi/rtl8192de/trx.c  |  12 +-
 .../wireless/realtek/rtlwifi/rtl8192ee/trx.c  |  13 +-
 .../wireless/realtek/rtlwifi/rtl8192se/trx.c  |  12 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/trx.c  |  14 +--
 .../wireless/realtek/rtlwifi/rtl8723be/hw.c   |   9 +-
 .../wireless/realtek/rtlwifi/rtl8723be/trx.c  |  13 +-
 .../wireless/realtek/rtlwifi/rtl8821ae/hw.c   |   9 +-
 .../wireless/realtek/rtlwifi/rtl8821ae/trx.c  |  13 +-
 12 files changed, 115 insertions(+), 132 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 25335bd2873b..0049a322665a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -547,11 +547,10 @@ static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
 		ring->idx = (ring->idx + 1) % ring->entries;
 
 		skb = __skb_dequeue(&ring->queue);
-		pci_unmap_single(rtlpci->pdev,
-				 rtlpriv->cfg->ops->
-					     get_desc(hw, (u8 *)entry, true,
-						      HW_DESC_TXBUFF_ADDR),
-				 skb->len, PCI_DMA_TODEVICE);
+		dma_unmap_single(&rtlpci->pdev->dev,
+				 rtlpriv->cfg->ops->get_desc(hw, (u8 *)entry,
+						true, HW_DESC_TXBUFF_ADDR),
+				 skb->len, DMA_TO_DEVICE);
 
 		/* remove early mode header */
 		if (rtlpriv->rtlhal.earlymode_enable)
@@ -646,10 +645,10 @@ static int _rtl_pci_init_one_rxdesc(struct ieee80211_hw *hw,
 remap:
 	/* just set skb->cb to mapping addr for pci_unmap_single use */
 	*((dma_addr_t *)skb->cb) =
-		pci_map_single(rtlpci->pdev, skb_tail_pointer(skb),
-			       rtlpci->rxbuffersize, PCI_DMA_FROMDEVICE);
+		dma_map_single(&rtlpci->pdev->dev, skb_tail_pointer(skb),
+			       rtlpci->rxbuffersize, DMA_FROM_DEVICE);
 	bufferaddress = *((dma_addr_t *)skb->cb);
-	if (pci_dma_mapping_error(rtlpci->pdev, bufferaddress))
+	if (dma_mapping_error(&rtlpci->pdev->dev, bufferaddress))
 		return 0;
 	rtlpci->rx_ring[rxring_idx].rx_buf[desc_idx] = skb;
 	if (rtlpriv->use_new_trx_flow) {
@@ -773,8 +772,8 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 		 * AAAAAAttention !!!
 		 * We can NOT access 'skb' before 'pci_unmap_single'
 		 */
-		pci_unmap_single(rtlpci->pdev, *((dma_addr_t *)skb->cb),
-				 rtlpci->rxbuffersize, PCI_DMA_FROMDEVICE);
+		dma_unmap_single(&rtlpci->pdev->dev, *((dma_addr_t *)skb->cb),
+				 rtlpci->rxbuffersize, DMA_FROM_DEVICE);
 
 		/* get a new skb - if fail, old one will be reused */
 		new_skb = dev_alloc_skb(rtlpci->rxbuffersize);
@@ -1092,10 +1091,10 @@ static void _rtl_pci_prepare_bcn_tasklet(unsigned long data)
 	else
 		entry = (u8 *)(&ring->desc[ring->idx]);
 	if (pskb) {
-		pci_unmap_single(rtlpci->pdev,
-				 rtlpriv->cfg->ops->get_desc(
-				 hw, (u8 *)entry, true, HW_DESC_TXBUFF_ADDR),
-				 pskb->len, PCI_DMA_TODEVICE);
+		dma_unmap_single(&rtlpci->pdev->dev,
+				 rtlpriv->cfg->ops->get_desc(hw, (u8 *)entry,
+						true, HW_DESC_TXBUFF_ADDR),
+				 pskb->len, DMA_TO_DEVICE);
 		kfree_skb(pskb);
 	}
 
@@ -1218,9 +1217,9 @@ static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
 	/* alloc tx buffer desc for new trx flow*/
 	if (rtlpriv->use_new_trx_flow) {
 		buffer_desc =
-		   pci_zalloc_consistent(rtlpci->pdev,
-					 sizeof(*buffer_desc) * entries,
-					 &buffer_desc_dma);
+		   dma_alloc_coherent(&rtlpci->pdev->dev,
+				      sizeof(*buffer_desc) * entries,
+				      &buffer_desc_dma, GFP_KERNEL);
 
 		if (!buffer_desc || (unsigned long)buffer_desc & 0xFF) {
 			pr_err("Cannot allocate TX ring (prio = %d)\n",
@@ -1236,8 +1235,8 @@ static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
 	}
 
 	/* alloc dma for this ring */
-	desc = pci_zalloc_consistent(rtlpci->pdev,
-				     sizeof(*desc) * entries, &desc_dma);
+	desc = dma_alloc_coherent(&rtlpci->pdev->dev, sizeof(*desc) * entries,
+				  &desc_dma, GFP_KERNEL);
 
 	if (!desc || (unsigned long)desc & 0xFF) {
 		pr_err("Cannot allocate TX ring (prio = %d)\n", prio);
@@ -1280,11 +1279,10 @@ static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw, int rxring_idx)
 		struct rtl_rx_buffer_desc *entry = NULL;
 		/* alloc dma for this ring */
 		rtlpci->rx_ring[rxring_idx].buffer_desc =
-		    pci_zalloc_consistent(rtlpci->pdev,
-					  sizeof(*rtlpci->rx_ring[rxring_idx].
-						 buffer_desc) *
-						 rtlpci->rxringcount,
-					  &rtlpci->rx_ring[rxring_idx].dma);
+		    dma_alloc_coherent(&rtlpci->pdev->dev,
+				       sizeof(*rtlpci->rx_ring[rxring_idx].buffer_desc) *
+				       rtlpci->rxringcount,
+				       &rtlpci->rx_ring[rxring_idx].dma, GFP_KERNEL);
 		if (!rtlpci->rx_ring[rxring_idx].buffer_desc ||
 		    (ulong)rtlpci->rx_ring[rxring_idx].buffer_desc & 0xFF) {
 			pr_err("Cannot allocate RX ring\n");
@@ -1304,10 +1302,10 @@ static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw, int rxring_idx)
 		u8 tmp_one = 1;
 		/* alloc dma for this ring */
 		rtlpci->rx_ring[rxring_idx].desc =
-		    pci_zalloc_consistent(rtlpci->pdev,
-					  sizeof(*rtlpci->rx_ring[rxring_idx].
-					  desc) * rtlpci->rxringcount,
-					  &rtlpci->rx_ring[rxring_idx].dma);
+		    dma_alloc_coherent(&rtlpci->pdev->dev,
+				       sizeof(*rtlpci->rx_ring[rxring_idx].desc) *
+				       rtlpci->rxringcount,
+				       &rtlpci->rx_ring[rxring_idx].dma, GFP_KERNEL);
 		if (!rtlpci->rx_ring[rxring_idx].desc ||
 		    (unsigned long)rtlpci->rx_ring[rxring_idx].desc & 0xFF) {
 			pr_err("Cannot allocate RX ring\n");
@@ -1347,24 +1345,23 @@ static void _rtl_pci_free_tx_ring(struct ieee80211_hw *hw,
 		else
 			entry = (u8 *)(&ring->desc[ring->idx]);
 
-		pci_unmap_single(rtlpci->pdev,
+		dma_unmap_single(&rtlpci->pdev->dev,
 				 rtlpriv->cfg->ops->get_desc(hw, (u8 *)entry,
-						   true,
-						   HW_DESC_TXBUFF_ADDR),
-				 skb->len, PCI_DMA_TODEVICE);
+						true, HW_DESC_TXBUFF_ADDR),
+				 skb->len, DMA_TO_DEVICE);
 		kfree_skb(skb);
 		ring->idx = (ring->idx + 1) % ring->entries;
 	}
 
 	/* free dma of this ring */
-	pci_free_consistent(rtlpci->pdev,
-			    sizeof(*ring->desc) * ring->entries,
-			    ring->desc, ring->dma);
+	dma_free_coherent(&rtlpci->pdev->dev,
+			  sizeof(*ring->desc) * ring->entries, ring->desc,
+			  ring->dma);
 	ring->desc = NULL;
 	if (rtlpriv->use_new_trx_flow) {
-		pci_free_consistent(rtlpci->pdev,
-				    sizeof(*ring->buffer_desc) * ring->entries,
-				    ring->buffer_desc, ring->buffer_desc_dma);
+		dma_free_coherent(&rtlpci->pdev->dev,
+				  sizeof(*ring->buffer_desc) * ring->entries,
+				  ring->buffer_desc, ring->buffer_desc_dma);
 		ring->buffer_desc = NULL;
 	}
 }
@@ -1381,25 +1378,25 @@ static void _rtl_pci_free_rx_ring(struct ieee80211_hw *hw, int rxring_idx)
 
 		if (!skb)
 			continue;
-		pci_unmap_single(rtlpci->pdev, *((dma_addr_t *)skb->cb),
-				 rtlpci->rxbuffersize, PCI_DMA_FROMDEVICE);
+		dma_unmap_single(&rtlpci->pdev->dev, *((dma_addr_t *)skb->cb),
+				 rtlpci->rxbuffersize, DMA_FROM_DEVICE);
 		kfree_skb(skb);
 	}
 
 	/* free dma of this ring */
 	if (rtlpriv->use_new_trx_flow) {
-		pci_free_consistent(rtlpci->pdev,
-				    sizeof(*rtlpci->rx_ring[rxring_idx].
-				    buffer_desc) * rtlpci->rxringcount,
-				    rtlpci->rx_ring[rxring_idx].buffer_desc,
-				    rtlpci->rx_ring[rxring_idx].dma);
+		dma_free_coherent(&rtlpci->pdev->dev,
+				  sizeof(*rtlpci->rx_ring[rxring_idx].buffer_desc) *
+				  rtlpci->rxringcount,
+				  rtlpci->rx_ring[rxring_idx].buffer_desc,
+				  rtlpci->rx_ring[rxring_idx].dma);
 		rtlpci->rx_ring[rxring_idx].buffer_desc = NULL;
 	} else {
-		pci_free_consistent(rtlpci->pdev,
-				    sizeof(*rtlpci->rx_ring[rxring_idx].desc) *
-				    rtlpci->rxringcount,
-				    rtlpci->rx_ring[rxring_idx].desc,
-				    rtlpci->rx_ring[rxring_idx].dma);
+		dma_free_coherent(&rtlpci->pdev->dev,
+				  sizeof(*rtlpci->rx_ring[rxring_idx].desc) *
+				  rtlpci->rxringcount,
+				  rtlpci->rx_ring[rxring_idx].desc,
+				  rtlpci->rx_ring[rxring_idx].dma);
 		rtlpci->rx_ring[rxring_idx].desc = NULL;
 	}
 }
@@ -1527,13 +1524,10 @@ int rtl_pci_reset_trx_ring(struct ieee80211_hw *hw)
 				else
 					entry = (u8 *)(&ring->desc[ring->idx]);
 
-				pci_unmap_single(rtlpci->pdev,
-						 rtlpriv->cfg->ops->
-							 get_desc(hw, (u8 *)
-							 entry,
-							 true,
-							 HW_DESC_TXBUFF_ADDR),
-						 skb->len, PCI_DMA_TODEVICE);
+				dma_unmap_single(&rtlpci->pdev->dev,
+						 rtlpriv->cfg->ops->get_desc(hw, (u8 *)entry,
+								true, HW_DESC_TXBUFF_ADDR),
+						 skb->len, DMA_TO_DEVICE);
 				dev_kfree_skb_irq(skb);
 				ring->idx = (ring->idx + 1) % ring->entries;
 			}
@@ -2172,8 +2166,8 @@ int rtl_pci_probe(struct pci_dev *pdev,
 	}
 
 	if (((struct rtl_hal_cfg *)id->driver_data)->mod_params->dma64 &&
-	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
-		if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))) {
+	    !dma_set_mask(&pdev->dev, DMA_BIT_MASK(64))) {
+		if (dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64))) {
 			WARN_ONCE(true,
 				  "Unable to obtain 64bit DMA for consistent allocations\n");
 			err = -ENOMEM;
@@ -2181,8 +2175,8 @@ int rtl_pci_probe(struct pci_dev *pdev,
 		}
 
 		platform_enable_dma64(pdev, true);
-	} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
-		if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
+	} else if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(32))) {
+		if (dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32))) {
 			WARN_ONCE(true,
 				  "rtlwifi: Unable to obtain 32bit DMA for consistent allocations\n");
 			err = -ENOMEM;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
index 70716631de85..805e997f8c8e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
@@ -75,11 +75,10 @@ static void _rtl88ee_return_beacon_queue_skb(struct ieee80211_hw *hw)
 		struct rtl_tx_desc *entry = &ring->desc[ring->idx];
 		struct sk_buff *skb = __skb_dequeue(&ring->queue);
 
-		pci_unmap_single(rtlpci->pdev,
-				 rtlpriv->cfg->ops->get_desc(
-				 hw,
-				 (u8 *)entry, true, HW_DESC_TXBUFF_ADDR),
-				 skb->len, PCI_DMA_TODEVICE);
+		dma_unmap_single(&rtlpci->pdev->dev,
+				 rtlpriv->cfg->ops->get_desc(hw, (u8 *)entry,
+						true, HW_DESC_TXBUFF_ADDR),
+				 skb->len, DMA_TO_DEVICE);
 		kfree_skb(skb);
 		ring->idx = (ring->idx + 1) % ring->entries;
 	}
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
index a5d2d6ece8db..6efc81bc4503 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
@@ -515,9 +515,9 @@ void rtl88ee_tx_fill_desc(struct ieee80211_hw *hw,
 		memset(skb->data, 0, EM_HDR_LEN);
 	}
 	buf_len = skb->len;
-	mapping = pci_map_single(rtlpci->pdev, skb->data, skb->len,
-				 PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
+	mapping = dma_map_single(&rtlpci->pdev->dev, skb->data, skb->len,
+				 DMA_TO_DEVICE);
+	if (dma_mapping_error(&rtlpci->pdev->dev, mapping)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
 			 "DMA mapping error\n");
 		return;
@@ -674,14 +674,13 @@ void rtl88ee_tx_fill_cmddesc(struct ieee80211_hw *hw,
 	u8 fw_queue = QSLT_BEACON;
 	__le32 *pdesc = (__le32 *)pdesc8;
 
-	dma_addr_t mapping = pci_map_single(rtlpci->pdev,
-					    skb->data, skb->len,
-					    PCI_DMA_TODEVICE);
+	dma_addr_t mapping = dma_map_single(&rtlpci->pdev->dev, skb->data,
+					    skb->len, DMA_TO_DEVICE);
 
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
 	__le16 fc = hdr->frame_control;
 
-	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
+	if (dma_mapping_error(&rtlpci->pdev->dev, mapping)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
 			 "DMA mapping error\n");
 		return;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
index 8fc3cb824066..21e7804d08d4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
@@ -361,13 +361,12 @@ void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
 	bool lastseg = ((hdr->frame_control &
 			 cpu_to_le16(IEEE80211_FCTL_MOREFRAGS)) == 0);
 
-	dma_addr_t mapping = pci_map_single(rtlpci->pdev,
-					    skb->data, skb->len,
-					    PCI_DMA_TODEVICE);
+	dma_addr_t mapping = dma_map_single(&rtlpci->pdev->dev, skb->data,
+					    skb->len, DMA_TO_DEVICE);
 
 	u8 bw_40 = 0;
 
-	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
+	if (dma_mapping_error(&rtlpci->pdev->dev, mapping)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
 			 "DMA mapping error\n");
 		return;
@@ -528,14 +527,13 @@ void rtl92ce_tx_fill_cmddesc(struct ieee80211_hw *hw,
 	u8 fw_queue = QSLT_BEACON;
 	__le32 *pdesc = (__le32 *)pdesc8;
 
-	dma_addr_t mapping = pci_map_single(rtlpci->pdev,
-					    skb->data, skb->len,
-					    PCI_DMA_TODEVICE);
+	dma_addr_t mapping = dma_map_single(&rtlpci->pdev->dev, skb->data,
+					    skb->len, DMA_TO_DEVICE);
 
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
 	__le16 fc = hdr->frame_control;
 
-	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
+	if (dma_mapping_error(&rtlpci->pdev->dev, mapping)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
 			 "DMA mapping error\n");
 		return;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
index ab5b05ef168e..020d1bbe39c1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
@@ -508,9 +508,9 @@ void rtl92de_tx_fill_desc(struct ieee80211_hw *hw,
 		memset(skb->data, 0, EM_HDR_LEN);
 	}
 	buf_len = skb->len;
-	mapping = pci_map_single(rtlpci->pdev, skb->data, skb->len,
-				 PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
+	mapping = dma_map_single(&rtlpci->pdev->dev, skb->data, skb->len,
+				 DMA_TO_DEVICE);
+	if (dma_mapping_error(&rtlpci->pdev->dev, mapping)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
 			 "DMA mapping error\n");
 		return;
@@ -664,13 +664,13 @@ void rtl92de_tx_fill_cmddesc(struct ieee80211_hw *hw,
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtlpriv);
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	u8 fw_queue = QSLT_BEACON;
-	dma_addr_t mapping = pci_map_single(rtlpci->pdev,
-		    skb->data, skb->len, PCI_DMA_TODEVICE);
+	dma_addr_t mapping = dma_map_single(&rtlpci->pdev->dev, skb->data,
+					    skb->len, DMA_TO_DEVICE);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
 	__le16 fc = hdr->frame_control;
 	__le32 *pdesc = (__le32 *)pdesc8;
 
-	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
+	if (dma_mapping_error(&rtlpci->pdev->dev, mapping)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
 			 "DMA mapping error\n");
 		return;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
index dc7b515bdc85..ecc624e86e56 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
@@ -675,9 +675,9 @@ void rtl92ee_tx_fill_desc(struct ieee80211_hw *hw,
 		skb_push(skb, EM_HDR_LEN);
 		memset(skb->data, 0, EM_HDR_LEN);
 	}
-	mapping = pci_map_single(rtlpci->pdev, skb->data, skb->len,
-				 PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
+	mapping = dma_map_single(&rtlpci->pdev->dev, skb->data, skb->len,
+				 DMA_TO_DEVICE);
+	if (dma_mapping_error(&rtlpci->pdev->dev, mapping)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
 			 "DMA mapping error\n");
 		return;
@@ -834,13 +834,12 @@ void rtl92ee_tx_fill_cmddesc(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	u8 fw_queue = QSLT_BEACON;
-	dma_addr_t mapping = pci_map_single(rtlpci->pdev,
-					    skb->data, skb->len,
-					    PCI_DMA_TODEVICE);
+	dma_addr_t mapping = dma_map_single(&rtlpci->pdev->dev, skb->data,
+					    skb->len, DMA_TO_DEVICE);
 	u8 txdesc_len = 40;
 	__le32 *pdesc = (__le32 *)pdesc8;
 
-	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
+	if (dma_mapping_error(&rtlpci->pdev->dev, mapping)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
 			 "DMA mapping error\n");
 		return;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
index 9eaa5348b556..f61f1a1583c3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
@@ -328,11 +328,11 @@ void rtl92se_tx_fill_desc(struct ieee80211_hw *hw,
 	bool firstseg = (!(hdr->seq_ctrl & cpu_to_le16(IEEE80211_SCTL_FRAG)));
 	bool lastseg = (!(hdr->frame_control &
 			cpu_to_le16(IEEE80211_FCTL_MOREFRAGS)));
-	dma_addr_t mapping = pci_map_single(rtlpci->pdev, skb->data, skb->len,
-		    PCI_DMA_TODEVICE);
+	dma_addr_t mapping = dma_map_single(&rtlpci->pdev->dev, skb->data,
+					    skb->len, DMA_TO_DEVICE);
 	u8 bw_40 = 0;
 
-	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
+	if (dma_mapping_error(&rtlpci->pdev->dev, mapping)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
 			 "DMA mapping error\n");
 		return;
@@ -500,10 +500,10 @@ void rtl92se_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc8,
 	struct rtl_tcb_desc *tcb_desc = (struct rtl_tcb_desc *)(skb->cb);
 	__le32 *pdesc = (__le32 *)pdesc8;
 
-	dma_addr_t mapping = pci_map_single(rtlpci->pdev, skb->data, skb->len,
-			PCI_DMA_TODEVICE);
+	dma_addr_t mapping = dma_map_single(&rtlpci->pdev->dev, skb->data,
+					    skb->len, DMA_TO_DEVICE);
 
-	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
+	if (dma_mapping_error(&rtlpci->pdev->dev, mapping)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
 			 "DMA mapping error\n");
 		return;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
index a04ce15d5538..82b09f7f8739 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
@@ -362,12 +362,11 @@ void rtl8723e_tx_fill_desc(struct ieee80211_hw *hw,
 	bool lastseg = ((hdr->frame_control &
 			 cpu_to_le16(IEEE80211_FCTL_MOREFRAGS)) == 0);
 
-	dma_addr_t mapping = pci_map_single(rtlpci->pdev,
-					    skb->data, skb->len,
-					    PCI_DMA_TODEVICE);
+	dma_addr_t mapping = dma_map_single(&rtlpci->pdev->dev, skb->data,
+					    skb->len, DMA_TO_DEVICE);
 	u8 bw_40 = 0;
 
-	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
+	if (dma_mapping_error(&rtlpci->pdev->dev, mapping)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
 			 "DMA mapping error\n");
 		return;
@@ -529,14 +528,13 @@ void rtl8723e_tx_fill_cmddesc(struct ieee80211_hw *hw,
 	u8 fw_queue = QSLT_BEACON;
 	__le32 *pdesc = (__le32 *)pdesc8;
 
-	dma_addr_t mapping = pci_map_single(rtlpci->pdev,
-					    skb->data, skb->len,
-					    PCI_DMA_TODEVICE);
+	dma_addr_t mapping = dma_map_single(&rtlpci->pdev->dev, skb->data,
+					    skb->len, DMA_TO_DEVICE);
 
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
 	__le16 fc = hdr->frame_control;
 
-	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
+	if (dma_mapping_error(&rtlpci->pdev->dev, mapping)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
 			 "DMA mapping error\n");
 		return;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index 979e5bfe5f45..0023c2c413e0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -37,11 +37,10 @@ static void _rtl8723be_return_beacon_queue_skb(struct ieee80211_hw *hw)
 		struct rtl_tx_desc *entry = &ring->desc[ring->idx];
 		struct sk_buff *skb = __skb_dequeue(&ring->queue);
 
-		pci_unmap_single(rtlpci->pdev,
-				 rtlpriv->cfg->ops->get_desc(
-				 hw,
-				 (u8 *)entry, true, HW_DESC_TXBUFF_ADDR),
-				 skb->len, PCI_DMA_TODEVICE);
+		dma_unmap_single(&rtlpci->pdev->dev,
+				 rtlpriv->cfg->ops->get_desc(hw, (u8 *)entry,
+						true, HW_DESC_TXBUFF_ADDR),
+				 skb->len, DMA_TO_DEVICE);
 		kfree_skb(skb);
 		ring->idx = (ring->idx + 1) % ring->entries;
 	}
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
index b8081e196cdf..7f03b235f8bd 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
@@ -442,9 +442,9 @@ void rtl8723be_tx_fill_desc(struct ieee80211_hw *hw,
 		memset(skb->data, 0, EM_HDR_LEN);
 	}
 	buf_len = skb->len;
-	mapping = pci_map_single(rtlpci->pdev, skb->data, skb->len,
-				 PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
+	mapping = dma_map_single(&rtlpci->pdev->dev, skb->data, skb->len,
+				 DMA_TO_DEVICE);
+	if (dma_mapping_error(&rtlpci->pdev->dev, mapping)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE, "DMA mapping error\n");
 		return;
 	}
@@ -595,11 +595,10 @@ void rtl8723be_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc8,
 	u8 fw_queue = QSLT_BEACON;
 	__le32 *pdesc = (__le32 *)pdesc8;
 
-	dma_addr_t mapping = pci_map_single(rtlpci->pdev,
-					    skb->data, skb->len,
-					    PCI_DMA_TODEVICE);
+	dma_addr_t mapping = dma_map_single(&rtlpci->pdev->dev, skb->data,
+					    skb->len, DMA_TO_DEVICE);
 
-	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
+	if (dma_mapping_error(&rtlpci->pdev->dev, mapping)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
 			 "DMA mapping error\n");
 		return;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index 198d419ebb9c..11cd0ee302e1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -33,11 +33,10 @@ static void _rtl8821ae_return_beacon_queue_skb(struct ieee80211_hw *hw)
 		struct rtl_tx_desc *entry = &ring->desc[ring->idx];
 		struct sk_buff *skb = __skb_dequeue(&ring->queue);
 
-		pci_unmap_single(rtlpci->pdev,
-				 rtlpriv->cfg->ops->get_desc(
-				 hw,
-				 (u8 *)entry, true, HW_DESC_TXBUFF_ADDR),
-				 skb->len, PCI_DMA_TODEVICE);
+		dma_unmap_single(&rtlpci->pdev->dev,
+				 rtlpriv->cfg->ops->get_desc(hw, (u8 *)entry,
+						true, HW_DESC_TXBUFF_ADDR),
+				 skb->len, DMA_TO_DEVICE);
 		kfree_skb(skb);
 		ring->idx = (ring->idx + 1) % ring->entries;
 	}
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
index cd809c992245..ff2819ddc908 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
@@ -690,9 +690,9 @@ void rtl8821ae_tx_fill_desc(struct ieee80211_hw *hw,
 		memset(skb->data, 0, EM_HDR_LEN);
 	}
 	buf_len = skb->len;
-	mapping = pci_map_single(rtlpci->pdev, skb->data, skb->len,
-				 PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
+	mapping = dma_map_single(&rtlpci->pdev->dev, skb->data, skb->len,
+				 DMA_TO_DEVICE);
+	if (dma_mapping_error(&rtlpci->pdev->dev, mapping)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
 			 "DMA mapping error\n");
 		return;
@@ -834,11 +834,10 @@ void rtl8821ae_tx_fill_cmddesc(struct ieee80211_hw *hw,
 	u8 fw_queue = QSLT_BEACON;
 	__le32 *pdesc = (__le32 *)pdesc8;
 
-	dma_addr_t mapping = pci_map_single(rtlpci->pdev,
-					    skb->data, skb->len,
-					    PCI_DMA_TODEVICE);
+	dma_addr_t mapping = dma_map_single(&rtlpci->pdev->dev, skb->data,
+					    skb->len, DMA_TO_DEVICE);
 
-	if (pci_dma_mapping_error(rtlpci->pdev, mapping)) {
+	if (dma_mapping_error(&rtlpci->pdev->dev, mapping)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_TRACE,
 			 "DMA mapping error\n");
 		return;
-- 
2.25.1

