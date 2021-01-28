Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445E830803F
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 22:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbhA1VJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 16:09:28 -0500
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:53429 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229677AbhA1VJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 16:09:25 -0500
Received: from localhost.localdomain ([92.131.99.25])
        by mwinf5d73 with ME
        id NM7e240070Ys01Y03M7ear; Thu, 28 Jan 2021 22:07:41 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 28 Jan 2021 22:07:41 +0100
X-ME-IP: 92.131.99.25
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, aaron.f.brown@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH resend] e100: switch from 'pci_' to 'dma_' API
Date:   Thu, 28 Jan 2021 22:07:36 +0100
Message-Id: <20210128210736.749724-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'e100_alloc()', GFP_KERNEL can be used because
it is only called from the probe function and no lock is acquired.


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
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
---
If needed, see post from Christoph Hellwig on the kernel-janitors ML:
   https://marc.info/?l=kernel-janitors&m=158745678307186&w=4

First sent on 18 Jul. 2020, see:
    https://lore.kernel.org/lkml/20200718115546.358240-1-christophe.jaillet@wanadoo.fr/
It still applies cleanly with latest linux-next

Tested tag, see:
   https://lore.kernel.org/lkml/DM6PR11MB289001E5538E536F0CB60A1FBC070@DM6PR11MB2890.namprd11.prod.outlook.com/

---
 drivers/net/ethernet/intel/e100.c | 92 ++++++++++++++++---------------
 1 file changed, 49 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 91c64f91a835..ec6b1024cd8a 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -1739,10 +1739,10 @@ static int e100_xmit_prepare(struct nic *nic, struct cb *cb,
 	dma_addr_t dma_addr;
 	cb->command = nic->tx_command;
 
-	dma_addr = pci_map_single(nic->pdev,
-				  skb->data, skb->len, PCI_DMA_TODEVICE);
+	dma_addr = dma_map_single(&nic->pdev->dev, skb->data, skb->len,
+				  DMA_TO_DEVICE);
 	/* If we can't map the skb, have the upper layer try later */
-	if (pci_dma_mapping_error(nic->pdev, dma_addr)) {
+	if (dma_mapping_error(&nic->pdev->dev, dma_addr)) {
 		dev_kfree_skb_any(skb);
 		skb = NULL;
 		return -ENOMEM;
@@ -1828,10 +1828,10 @@ static int e100_tx_clean(struct nic *nic)
 			dev->stats.tx_packets++;
 			dev->stats.tx_bytes += cb->skb->len;
 
-			pci_unmap_single(nic->pdev,
-				le32_to_cpu(cb->u.tcb.tbd.buf_addr),
-				le16_to_cpu(cb->u.tcb.tbd.size),
-				PCI_DMA_TODEVICE);
+			dma_unmap_single(&nic->pdev->dev,
+					 le32_to_cpu(cb->u.tcb.tbd.buf_addr),
+					 le16_to_cpu(cb->u.tcb.tbd.size),
+					 DMA_TO_DEVICE);
 			dev_kfree_skb_any(cb->skb);
 			cb->skb = NULL;
 			tx_cleaned = 1;
@@ -1855,10 +1855,10 @@ static void e100_clean_cbs(struct nic *nic)
 		while (nic->cbs_avail != nic->params.cbs.count) {
 			struct cb *cb = nic->cb_to_clean;
 			if (cb->skb) {
-				pci_unmap_single(nic->pdev,
-					le32_to_cpu(cb->u.tcb.tbd.buf_addr),
-					le16_to_cpu(cb->u.tcb.tbd.size),
-					PCI_DMA_TODEVICE);
+				dma_unmap_single(&nic->pdev->dev,
+						 le32_to_cpu(cb->u.tcb.tbd.buf_addr),
+						 le16_to_cpu(cb->u.tcb.tbd.size),
+						 DMA_TO_DEVICE);
 				dev_kfree_skb(cb->skb);
 			}
 			nic->cb_to_clean = nic->cb_to_clean->next;
@@ -1925,10 +1925,10 @@ static int e100_rx_alloc_skb(struct nic *nic, struct rx *rx)
 
 	/* Init, and map the RFD. */
 	skb_copy_to_linear_data(rx->skb, &nic->blank_rfd, sizeof(struct rfd));
-	rx->dma_addr = pci_map_single(nic->pdev, rx->skb->data,
-		RFD_BUF_LEN, PCI_DMA_BIDIRECTIONAL);
+	rx->dma_addr = dma_map_single(&nic->pdev->dev, rx->skb->data,
+				      RFD_BUF_LEN, DMA_BIDIRECTIONAL);
 
-	if (pci_dma_mapping_error(nic->pdev, rx->dma_addr)) {
+	if (dma_mapping_error(&nic->pdev->dev, rx->dma_addr)) {
 		dev_kfree_skb_any(rx->skb);
 		rx->skb = NULL;
 		rx->dma_addr = 0;
@@ -1941,8 +1941,10 @@ static int e100_rx_alloc_skb(struct nic *nic, struct rx *rx)
 	if (rx->prev->skb) {
 		struct rfd *prev_rfd = (struct rfd *)rx->prev->skb->data;
 		put_unaligned_le32(rx->dma_addr, &prev_rfd->link);
-		pci_dma_sync_single_for_device(nic->pdev, rx->prev->dma_addr,
-			sizeof(struct rfd), PCI_DMA_BIDIRECTIONAL);
+		dma_sync_single_for_device(&nic->pdev->dev,
+					   rx->prev->dma_addr,
+					   sizeof(struct rfd),
+					   DMA_BIDIRECTIONAL);
 	}
 
 	return 0;
@@ -1961,8 +1963,8 @@ static int e100_rx_indicate(struct nic *nic, struct rx *rx,
 		return -EAGAIN;
 
 	/* Need to sync before taking a peek at cb_complete bit */
-	pci_dma_sync_single_for_cpu(nic->pdev, rx->dma_addr,
-		sizeof(struct rfd), PCI_DMA_BIDIRECTIONAL);
+	dma_sync_single_for_cpu(&nic->pdev->dev, rx->dma_addr,
+				sizeof(struct rfd), DMA_BIDIRECTIONAL);
 	rfd_status = le16_to_cpu(rfd->status);
 
 	netif_printk(nic, rx_status, KERN_DEBUG, nic->netdev,
@@ -1981,9 +1983,9 @@ static int e100_rx_indicate(struct nic *nic, struct rx *rx,
 
 			if (ioread8(&nic->csr->scb.status) & rus_no_res)
 				nic->ru_running = RU_SUSPENDED;
-		pci_dma_sync_single_for_device(nic->pdev, rx->dma_addr,
-					       sizeof(struct rfd),
-					       PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_device(&nic->pdev->dev, rx->dma_addr,
+					   sizeof(struct rfd),
+					   DMA_FROM_DEVICE);
 		return -ENODATA;
 	}
 
@@ -1995,8 +1997,8 @@ static int e100_rx_indicate(struct nic *nic, struct rx *rx,
 		actual_size = RFD_BUF_LEN - sizeof(struct rfd);
 
 	/* Get data */
-	pci_unmap_single(nic->pdev, rx->dma_addr,
-		RFD_BUF_LEN, PCI_DMA_BIDIRECTIONAL);
+	dma_unmap_single(&nic->pdev->dev, rx->dma_addr, RFD_BUF_LEN,
+			 DMA_BIDIRECTIONAL);
 
 	/* If this buffer has the el bit, but we think the receiver
 	 * is still running, check to see if it really stopped while
@@ -2097,22 +2099,25 @@ static void e100_rx_clean(struct nic *nic, unsigned int *work_done,
 			(struct rfd *)new_before_last_rx->skb->data;
 		new_before_last_rfd->size = 0;
 		new_before_last_rfd->command |= cpu_to_le16(cb_el);
-		pci_dma_sync_single_for_device(nic->pdev,
-			new_before_last_rx->dma_addr, sizeof(struct rfd),
-			PCI_DMA_BIDIRECTIONAL);
+		dma_sync_single_for_device(&nic->pdev->dev,
+					   new_before_last_rx->dma_addr,
+					   sizeof(struct rfd),
+					   DMA_BIDIRECTIONAL);
 
 		/* Now that we have a new stopping point, we can clear the old
 		 * stopping point.  We must sync twice to get the proper
 		 * ordering on the hardware side of things. */
 		old_before_last_rfd->command &= ~cpu_to_le16(cb_el);
-		pci_dma_sync_single_for_device(nic->pdev,
-			old_before_last_rx->dma_addr, sizeof(struct rfd),
-			PCI_DMA_BIDIRECTIONAL);
+		dma_sync_single_for_device(&nic->pdev->dev,
+					   old_before_last_rx->dma_addr,
+					   sizeof(struct rfd),
+					   DMA_BIDIRECTIONAL);
 		old_before_last_rfd->size = cpu_to_le16(VLAN_ETH_FRAME_LEN
 							+ ETH_FCS_LEN);
-		pci_dma_sync_single_for_device(nic->pdev,
-			old_before_last_rx->dma_addr, sizeof(struct rfd),
-			PCI_DMA_BIDIRECTIONAL);
+		dma_sync_single_for_device(&nic->pdev->dev,
+					   old_before_last_rx->dma_addr,
+					   sizeof(struct rfd),
+					   DMA_BIDIRECTIONAL);
 	}
 
 	if (restart_required) {
@@ -2134,8 +2139,9 @@ static void e100_rx_clean_list(struct nic *nic)
 	if (nic->rxs) {
 		for (rx = nic->rxs, i = 0; i < count; rx++, i++) {
 			if (rx->skb) {
-				pci_unmap_single(nic->pdev, rx->dma_addr,
-					RFD_BUF_LEN, PCI_DMA_BIDIRECTIONAL);
+				dma_unmap_single(&nic->pdev->dev,
+						 rx->dma_addr, RFD_BUF_LEN,
+						 DMA_BIDIRECTIONAL);
 				dev_kfree_skb(rx->skb);
 			}
 		}
@@ -2177,8 +2183,8 @@ static int e100_rx_alloc_list(struct nic *nic)
 	before_last = (struct rfd *)rx->skb->data;
 	before_last->command |= cpu_to_le16(cb_el);
 	before_last->size = 0;
-	pci_dma_sync_single_for_device(nic->pdev, rx->dma_addr,
-		sizeof(struct rfd), PCI_DMA_BIDIRECTIONAL);
+	dma_sync_single_for_device(&nic->pdev->dev, rx->dma_addr,
+				   sizeof(struct rfd), DMA_BIDIRECTIONAL);
 
 	nic->rx_to_use = nic->rx_to_clean = nic->rxs;
 	nic->ru_running = RU_SUSPENDED;
@@ -2377,8 +2383,8 @@ static int e100_loopback_test(struct nic *nic, enum loopback loopback_mode)
 
 	msleep(10);
 
-	pci_dma_sync_single_for_cpu(nic->pdev, nic->rx_to_clean->dma_addr,
-			RFD_BUF_LEN, PCI_DMA_BIDIRECTIONAL);
+	dma_sync_single_for_cpu(&nic->pdev->dev, nic->rx_to_clean->dma_addr,
+				RFD_BUF_LEN, DMA_BIDIRECTIONAL);
 
 	if (memcmp(nic->rx_to_clean->skb->data + sizeof(struct rfd),
 	   skb->data, ETH_DATA_LEN))
@@ -2751,16 +2757,16 @@ static int e100_do_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 
 static int e100_alloc(struct nic *nic)
 {
-	nic->mem = pci_alloc_consistent(nic->pdev, sizeof(struct mem),
-		&nic->dma_addr);
+	nic->mem = dma_alloc_coherent(&nic->pdev->dev, sizeof(struct mem),
+				      &nic->dma_addr, GFP_KERNEL);
 	return nic->mem ? 0 : -ENOMEM;
 }
 
 static void e100_free(struct nic *nic)
 {
 	if (nic->mem) {
-		pci_free_consistent(nic->pdev, sizeof(struct mem),
-			nic->mem, nic->dma_addr);
+		dma_free_coherent(&nic->pdev->dev, sizeof(struct mem),
+				  nic->mem, nic->dma_addr);
 		nic->mem = NULL;
 	}
 }
@@ -2853,7 +2859,7 @@ static int e100_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_disable_pdev;
 	}
 
-	if ((err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))) {
+	if ((err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32)))) {
 		netif_err(nic, probe, nic->netdev, "No usable DMA configuration, aborting\n");
 		goto err_out_free_res;
 	}
-- 
2.25.1

