Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0307D25EDD7
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 14:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbgIFMq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 08:46:58 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:31243 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728873AbgIFMpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 08:45:53 -0400
Received: from localhost.localdomain ([93.22.36.58])
        by mwinf5d13 with ME
        id Qclj2300a1FFwYV03clkf7; Sun, 06 Sep 2020 14:45:47 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 06 Sep 2020 14:45:47 +0200
X-ME-IP: 93.22.36.58
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     benve@cisco.com, govind@gmx.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] enic: switch from 'pci_' to 'dma_' API
Date:   Sun,  6 Sep 2020 14:45:41 +0200
Message-Id: <20200906124541.309003-1-christophe.jaillet@wanadoo.fr>
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

When memory is allocated in 'vnic_dev_classifier()', 'vnic_dev_fw_info()',
'vnic_dev_notify_set()' and 'vnic_dev_stats_dump()' (vnic_dev.c) GFP_ATOMIC
must be used because its callers take a spinlock before calling these
functions.

When memory is allocated in '__enic_set_rsskey()' and 'enic_set_rsscpu()'
GFP_ATOMIC must be used because they can be called with a spinlock.
The call chain is:
  enic_reset                         <-- takes 'enic->enic_api_lock'
    --> enic_set_rss_nic_cfg
      --> enic_set_rsskey
        --> __enic_set_rsskey        <-- uses dma_alloc_coherent
      --> enic_set_rsscpu            <-- uses dma_alloc_coherent

When memory is allocated in 'vnic_dev_init_prov2()' GFP_ATOMIC must be used
because a spinlock is hidden in the ENIC_DEVCMD_PROXY_BY_INDEX macro, when
this function is called in 'enic_set_port_profile()'.

When memory is allocated in 'vnic_dev_alloc_desc_ring()' GFP_KERNEL can be
used because it is only called from 5 functions ('vnic_dev_init_devcmd2()',
'vnic_cq_alloc()', 'vnic_rq_alloc()', 'vnic_wq_alloc()' and
'enic_wq_devcmd2_alloc()'.

  'vnic_dev_init_devcmd2()': already uses GFP_KERNEL and no lock is taken
     in the between.
  'enic_wq_devcmd2_alloc()': is called from ' vnic_dev_init_devcmd2()'
     which already uses GFP_KERNEL and no lock is taken in the between.
  'vnic_cq_alloc()', 'vnic_rq_alloc()', 'vnic_wq_alloc()': are called
     from 'enic_alloc_vnic_resources()'
'enic_alloc_vnic_resources()' has only 2 call chains:

  1) enic_probe
      --> enic_dev_init
        --> enic_alloc_vnic_resources
'enic_probe()' is a probe function and no lock is taken in the between

  2) enic_set_ringparam
      --> enic_alloc_vnic_resources
'enic_set_ringparam()' is a .set_ringparam function (see struct
ethtool_ops). It seems to only take a mutex and no spinlock.


So all paths are safe to use GFP_KERNEL.


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


This patch and its explanation is a bit tricky, so review carefully !
Tricky means error prone, so maybe it would be safer to keep GFP_ATOMIC in
'vnic_dev_alloc_desc_ring()'
---
 drivers/net/ethernet/cisco/enic/enic_main.c | 76 +++++++++++----------
 drivers/net/ethernet/cisco/enic/vnic_dev.c  | 66 +++++++++---------
 2 files changed, 72 insertions(+), 70 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 552d89fdf54a..bcf3c0adedb0 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -326,11 +326,11 @@ static void enic_free_wq_buf(struct vnic_wq *wq, struct vnic_wq_buf *buf)
 	struct enic *enic = vnic_dev_priv(wq->vdev);
 
 	if (buf->sop)
-		pci_unmap_single(enic->pdev, buf->dma_addr,
-			buf->len, PCI_DMA_TODEVICE);
+		dma_unmap_single(&enic->pdev->dev, buf->dma_addr, buf->len,
+				 DMA_TO_DEVICE);
 	else
-		pci_unmap_page(enic->pdev, buf->dma_addr,
-			buf->len, PCI_DMA_TODEVICE);
+		dma_unmap_page(&enic->pdev->dev, buf->dma_addr, buf->len,
+			       DMA_TO_DEVICE);
 
 	if (buf->os_buf)
 		dev_kfree_skb_any(buf->os_buf);
@@ -574,8 +574,8 @@ static int enic_queue_wq_skb_vlan(struct enic *enic, struct vnic_wq *wq,
 	dma_addr_t dma_addr;
 	int err = 0;
 
-	dma_addr = pci_map_single(enic->pdev, skb->data, head_len,
-				  PCI_DMA_TODEVICE);
+	dma_addr = dma_map_single(&enic->pdev->dev, skb->data, head_len,
+				  DMA_TO_DEVICE);
 	if (unlikely(enic_dma_map_check(enic, dma_addr)))
 		return -ENOMEM;
 
@@ -605,8 +605,8 @@ static int enic_queue_wq_skb_csum_l4(struct enic *enic, struct vnic_wq *wq,
 	dma_addr_t dma_addr;
 	int err = 0;
 
-	dma_addr = pci_map_single(enic->pdev, skb->data, head_len,
-				  PCI_DMA_TODEVICE);
+	dma_addr = dma_map_single(&enic->pdev->dev, skb->data, head_len,
+				  DMA_TO_DEVICE);
 	if (unlikely(enic_dma_map_check(enic, dma_addr)))
 		return -ENOMEM;
 
@@ -693,8 +693,9 @@ static int enic_queue_wq_skb_tso(struct enic *enic, struct vnic_wq *wq,
 	 */
 	while (frag_len_left) {
 		len = min(frag_len_left, (unsigned int)WQ_ENET_MAX_DESC_LEN);
-		dma_addr = pci_map_single(enic->pdev, skb->data + offset, len,
-					  PCI_DMA_TODEVICE);
+		dma_addr = dma_map_single(&enic->pdev->dev,
+					  skb->data + offset, len,
+					  DMA_TO_DEVICE);
 		if (unlikely(enic_dma_map_check(enic, dma_addr)))
 			return -ENOMEM;
 		enic_queue_wq_desc_tso(wq, skb, dma_addr, len, mss, hdr_len,
@@ -752,8 +753,8 @@ static inline int enic_queue_wq_skb_encap(struct enic *enic, struct vnic_wq *wq,
 	dma_addr_t dma_addr;
 	int err = 0;
 
-	dma_addr = pci_map_single(enic->pdev, skb->data, head_len,
-				  PCI_DMA_TODEVICE);
+	dma_addr = dma_map_single(&enic->pdev->dev, skb->data, head_len,
+				  DMA_TO_DEVICE);
 	if (unlikely(enic_dma_map_check(enic, dma_addr)))
 		return -ENOMEM;
 
@@ -1222,8 +1223,8 @@ static void enic_free_rq_buf(struct vnic_rq *rq, struct vnic_rq_buf *buf)
 	if (!buf->os_buf)
 		return;
 
-	pci_unmap_single(enic->pdev, buf->dma_addr,
-		buf->len, PCI_DMA_FROMDEVICE);
+	dma_unmap_single(&enic->pdev->dev, buf->dma_addr, buf->len,
+			 DMA_FROM_DEVICE);
 	dev_kfree_skb_any(buf->os_buf);
 	buf->os_buf = NULL;
 }
@@ -1248,8 +1249,8 @@ static int enic_rq_alloc_buf(struct vnic_rq *rq)
 	if (!skb)
 		return -ENOMEM;
 
-	dma_addr = pci_map_single(enic->pdev, skb->data, len,
-				  PCI_DMA_FROMDEVICE);
+	dma_addr = dma_map_single(&enic->pdev->dev, skb->data, len,
+				  DMA_FROM_DEVICE);
 	if (unlikely(enic_dma_map_check(enic, dma_addr))) {
 		dev_kfree_skb(skb);
 		return -ENOMEM;
@@ -1281,8 +1282,8 @@ static bool enic_rxcopybreak(struct net_device *netdev, struct sk_buff **skb,
 	new_skb = netdev_alloc_skb_ip_align(netdev, len);
 	if (!new_skb)
 		return false;
-	pci_dma_sync_single_for_cpu(enic->pdev, buf->dma_addr, len,
-				    DMA_FROM_DEVICE);
+	dma_sync_single_for_cpu(&enic->pdev->dev, buf->dma_addr, len,
+				DMA_FROM_DEVICE);
 	memcpy(new_skb->data, (*skb)->data, len);
 	*skb = new_skb;
 
@@ -1331,8 +1332,8 @@ static void enic_rq_indicate_buf(struct vnic_rq *rq,
 				enic->rq_truncated_pkts++;
 		}
 
-		pci_unmap_single(enic->pdev, buf->dma_addr, buf->len,
-				 PCI_DMA_FROMDEVICE);
+		dma_unmap_single(&enic->pdev->dev, buf->dma_addr, buf->len,
+				 DMA_FROM_DEVICE);
 		dev_kfree_skb_any(skb);
 		buf->os_buf = NULL;
 
@@ -1346,8 +1347,8 @@ static void enic_rq_indicate_buf(struct vnic_rq *rq,
 
 		if (!enic_rxcopybreak(netdev, &skb, buf, bytes_written)) {
 			buf->os_buf = NULL;
-			pci_unmap_single(enic->pdev, buf->dma_addr, buf->len,
-					 PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&enic->pdev->dev, buf->dma_addr,
+					 buf->len, DMA_FROM_DEVICE);
 		}
 		prefetch(skb->data - NET_IP_ALIGN);
 
@@ -1420,8 +1421,8 @@ static void enic_rq_indicate_buf(struct vnic_rq *rq,
 		/* Buffer overflow
 		 */
 
-		pci_unmap_single(enic->pdev, buf->dma_addr, buf->len,
-				 PCI_DMA_FROMDEVICE);
+		dma_unmap_single(&enic->pdev->dev, buf->dma_addr, buf->len,
+				 DMA_FROM_DEVICE);
 		dev_kfree_skb_any(skb);
 		buf->os_buf = NULL;
 	}
@@ -2178,9 +2179,9 @@ int __enic_set_rsskey(struct enic *enic)
 	dma_addr_t rss_key_buf_pa;
 	int i, kidx, bidx, err;
 
-	rss_key_buf_va = pci_zalloc_consistent(enic->pdev,
-					       sizeof(union vnic_rss_key),
-					       &rss_key_buf_pa);
+	rss_key_buf_va = dma_alloc_coherent(&enic->pdev->dev,
+					    sizeof(union vnic_rss_key),
+					    &rss_key_buf_pa, GFP_ATOMIC);
 	if (!rss_key_buf_va)
 		return -ENOMEM;
 
@@ -2195,8 +2196,8 @@ int __enic_set_rsskey(struct enic *enic)
 		sizeof(union vnic_rss_key));
 	spin_unlock_bh(&enic->devcmd_lock);
 
-	pci_free_consistent(enic->pdev, sizeof(union vnic_rss_key),
-		rss_key_buf_va, rss_key_buf_pa);
+	dma_free_coherent(&enic->pdev->dev, sizeof(union vnic_rss_key),
+			  rss_key_buf_va, rss_key_buf_pa);
 
 	return err;
 }
@@ -2215,8 +2216,9 @@ static int enic_set_rsscpu(struct enic *enic, u8 rss_hash_bits)
 	unsigned int i;
 	int err;
 
-	rss_cpu_buf_va = pci_alloc_consistent(enic->pdev,
-		sizeof(union vnic_rss_cpu), &rss_cpu_buf_pa);
+	rss_cpu_buf_va = dma_alloc_coherent(&enic->pdev->dev,
+					    sizeof(union vnic_rss_cpu),
+					    &rss_cpu_buf_pa, GFP_ATOMIC);
 	if (!rss_cpu_buf_va)
 		return -ENOMEM;
 
@@ -2229,8 +2231,8 @@ static int enic_set_rsscpu(struct enic *enic, u8 rss_hash_bits)
 		sizeof(union vnic_rss_cpu));
 	spin_unlock_bh(&enic->devcmd_lock);
 
-	pci_free_consistent(enic->pdev, sizeof(union vnic_rss_cpu),
-		rss_cpu_buf_va, rss_cpu_buf_pa);
+	dma_free_coherent(&enic->pdev->dev, sizeof(union vnic_rss_cpu),
+			  rss_cpu_buf_va, rss_cpu_buf_pa);
 
 	return err;
 }
@@ -2699,21 +2701,21 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * fail to 32-bit.
 	 */
 
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(47));
+	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(47));
 	if (err) {
-		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 		if (err) {
 			dev_err(dev, "No usable DMA configuration, aborting\n");
 			goto err_out_release_regions;
 		}
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 		if (err) {
 			dev_err(dev, "Unable to obtain %u-bit DMA "
 				"for consistent allocations, aborting\n", 32);
 			goto err_out_release_regions;
 		}
 	} else {
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(47));
+		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(47));
 		if (err) {
 			dev_err(dev, "Unable to obtain %u-bit DMA "
 				"for consistent allocations, aborting\n", 47);
diff --git a/drivers/net/ethernet/cisco/enic/vnic_dev.c b/drivers/net/ethernet/cisco/enic/vnic_dev.c
index 901e44b0b795..45015931b335 100644
--- a/drivers/net/ethernet/cisco/enic/vnic_dev.c
+++ b/drivers/net/ethernet/cisco/enic/vnic_dev.c
@@ -193,9 +193,10 @@ int vnic_dev_alloc_desc_ring(struct vnic_dev *vdev, struct vnic_dev_ring *ring,
 {
 	vnic_dev_desc_ring_size(ring, desc_count, desc_size);
 
-	ring->descs_unaligned = pci_alloc_consistent(vdev->pdev,
-		ring->size_unaligned,
-		&ring->base_addr_unaligned);
+	ring->descs_unaligned = dma_alloc_coherent(&vdev->pdev->dev,
+						   ring->size_unaligned,
+						   &ring->base_addr_unaligned,
+						   GFP_KERNEL);
 
 	if (!ring->descs_unaligned) {
 		vdev_err(vdev, "Failed to allocate ring (size=%d), aborting\n",
@@ -218,10 +219,9 @@ int vnic_dev_alloc_desc_ring(struct vnic_dev *vdev, struct vnic_dev_ring *ring,
 void vnic_dev_free_desc_ring(struct vnic_dev *vdev, struct vnic_dev_ring *ring)
 {
 	if (ring->descs) {
-		pci_free_consistent(vdev->pdev,
-			ring->size_unaligned,
-			ring->descs_unaligned,
-			ring->base_addr_unaligned);
+		dma_free_coherent(&vdev->pdev->dev, ring->size_unaligned,
+				  ring->descs_unaligned,
+				  ring->base_addr_unaligned);
 		ring->descs = NULL;
 	}
 }
@@ -551,9 +551,9 @@ int vnic_dev_fw_info(struct vnic_dev *vdev,
 	int err = 0;
 
 	if (!vdev->fw_info) {
-		vdev->fw_info = pci_zalloc_consistent(vdev->pdev,
-						      sizeof(struct vnic_devcmd_fw_info),
-						      &vdev->fw_info_pa);
+		vdev->fw_info = dma_alloc_coherent(&vdev->pdev->dev,
+						   sizeof(struct vnic_devcmd_fw_info),
+						   &vdev->fw_info_pa, GFP_ATOMIC);
 		if (!vdev->fw_info)
 			return -ENOMEM;
 
@@ -603,8 +603,9 @@ int vnic_dev_stats_dump(struct vnic_dev *vdev, struct vnic_stats **stats)
 	int wait = 1000;
 
 	if (!vdev->stats) {
-		vdev->stats = pci_alloc_consistent(vdev->pdev,
-			sizeof(struct vnic_stats), &vdev->stats_pa);
+		vdev->stats = dma_alloc_coherent(&vdev->pdev->dev,
+						 sizeof(struct vnic_stats),
+						 &vdev->stats_pa, GFP_ATOMIC);
 		if (!vdev->stats)
 			return -ENOMEM;
 	}
@@ -852,9 +853,9 @@ int vnic_dev_notify_set(struct vnic_dev *vdev, u16 intr)
 		return -EINVAL;
 	}
 
-	notify_addr = pci_alloc_consistent(vdev->pdev,
-			sizeof(struct vnic_devcmd_notify),
-			&notify_pa);
+	notify_addr = dma_alloc_coherent(&vdev->pdev->dev,
+					 sizeof(struct vnic_devcmd_notify),
+					 &notify_pa, GFP_ATOMIC);
 	if (!notify_addr)
 		return -ENOMEM;
 
@@ -882,10 +883,9 @@ static int vnic_dev_notify_unsetcmd(struct vnic_dev *vdev)
 int vnic_dev_notify_unset(struct vnic_dev *vdev)
 {
 	if (vdev->notify) {
-		pci_free_consistent(vdev->pdev,
-			sizeof(struct vnic_devcmd_notify),
-			vdev->notify,
-			vdev->notify_pa);
+		dma_free_coherent(&vdev->pdev->dev,
+				  sizeof(struct vnic_devcmd_notify),
+				  vdev->notify, vdev->notify_pa);
 	}
 
 	return vnic_dev_notify_unsetcmd(vdev);
@@ -1046,18 +1046,17 @@ void vnic_dev_unregister(struct vnic_dev *vdev)
 {
 	if (vdev) {
 		if (vdev->notify)
-			pci_free_consistent(vdev->pdev,
-				sizeof(struct vnic_devcmd_notify),
-				vdev->notify,
-				vdev->notify_pa);
+			dma_free_coherent(&vdev->pdev->dev,
+					  sizeof(struct vnic_devcmd_notify),
+					  vdev->notify, vdev->notify_pa);
 		if (vdev->stats)
-			pci_free_consistent(vdev->pdev,
-				sizeof(struct vnic_stats),
-				vdev->stats, vdev->stats_pa);
+			dma_free_coherent(&vdev->pdev->dev,
+					  sizeof(struct vnic_stats),
+					  vdev->stats, vdev->stats_pa);
 		if (vdev->fw_info)
-			pci_free_consistent(vdev->pdev,
-				sizeof(struct vnic_devcmd_fw_info),
-				vdev->fw_info, vdev->fw_info_pa);
+			dma_free_coherent(&vdev->pdev->dev,
+					  sizeof(struct vnic_devcmd_fw_info),
+					  vdev->fw_info, vdev->fw_info_pa);
 		if (vdev->devcmd2)
 			vnic_dev_deinit_devcmd2(vdev);
 
@@ -1127,7 +1126,7 @@ int vnic_dev_init_prov2(struct vnic_dev *vdev, u8 *buf, u32 len)
 	void *prov_buf;
 	int ret;
 
-	prov_buf = pci_alloc_consistent(vdev->pdev, len, &prov_pa);
+	prov_buf = dma_alloc_coherent(&vdev->pdev->dev, len, &prov_pa, GFP_ATOMIC);
 	if (!prov_buf)
 		return -ENOMEM;
 
@@ -1137,7 +1136,7 @@ int vnic_dev_init_prov2(struct vnic_dev *vdev, u8 *buf, u32 len)
 
 	ret = vnic_dev_cmd(vdev, CMD_INIT_PROV_INFO2, &a0, &a1, wait);
 
-	pci_free_consistent(vdev->pdev, len, prov_buf, prov_pa);
+	dma_free_coherent(&vdev->pdev->dev, len, prov_buf, prov_pa);
 
 	return ret;
 }
@@ -1217,7 +1216,8 @@ int vnic_dev_classifier(struct vnic_dev *vdev, u8 cmd, u16 *entry,
 		tlv_size = sizeof(struct filter) +
 			   sizeof(struct filter_action) +
 			   2 * sizeof(struct filter_tlv);
-		tlv_va = pci_alloc_consistent(vdev->pdev, tlv_size, &tlv_pa);
+		tlv_va = dma_alloc_coherent(&vdev->pdev->dev, tlv_size,
+					    &tlv_pa, GFP_ATOMIC);
 		if (!tlv_va)
 			return -ENOMEM;
 		tlv = tlv_va;
@@ -1240,7 +1240,7 @@ int vnic_dev_classifier(struct vnic_dev *vdev, u8 cmd, u16 *entry,
 
 		ret = vnic_dev_cmd(vdev, CMD_ADD_FILTER, &a0, &a1, wait);
 		*entry = (u16)a0;
-		pci_free_consistent(vdev->pdev, tlv_size, tlv_va, tlv_pa);
+		dma_free_coherent(&vdev->pdev->dev, tlv_size, tlv_va, tlv_pa);
 	} else if (cmd == CLSF_DEL) {
 		a0 = *entry;
 		ret = vnic_dev_cmd(vdev, CMD_DEL_FILTER, &a0, &a1, wait);
-- 
2.25.1

