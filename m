Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72C14EB2E4
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 15:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbfJaOiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 10:38:08 -0400
Received: from inva020.nxp.com ([92.121.34.13]:54762 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727905AbfJaOiH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 10:38:07 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id EFD1F1A0556;
        Thu, 31 Oct 2019 15:38:04 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E30F31A0209;
        Thu, 31 Oct 2019 15:38:04 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id A607B205E9;
        Thu, 31 Oct 2019 15:38:04 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, jakub.kicinski@netronome.com, joe@perches.com,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [net-next v2 02/13] dpaa_eth: use page backed rx buffers
Date:   Thu, 31 Oct 2019 16:37:48 +0200
Message-Id: <1572532679-472-3-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1572532679-472-1-git-send-email-madalin.bucur@nxp.com>
References: <1572532679-472-1-git-send-email-madalin.bucur@nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the buffers used for reception from netdev_frags to pages.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 51 +++++++++++---------------
 1 file changed, 22 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 60d63c1be9c6..388d3ccb5fdb 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -180,13 +180,7 @@ static struct dpaa_bp *dpaa_bp_array[BM_MAX_NUM_OF_POOLS];
 
 #define DPAA_BP_RAW_SIZE 4096
 
-/* FMan-DMA requires 16-byte alignment for Rx buffers, but SKB_DATA_ALIGN is
- * even stronger (SMP_CACHE_BYTES-aligned), so we just get away with that,
- * via SKB_WITH_OVERHEAD(). We can't rely on netdev_alloc_frag() giving us
- * half-page-aligned buffers, so we reserve some more space for start-of-buffer
- * alignment.
- */
-#define dpaa_bp_size(raw_size) SKB_WITH_OVERHEAD((raw_size) - SMP_CACHE_BYTES)
+#define dpaa_bp_size(raw_size) SKB_WITH_OVERHEAD(raw_size)
 
 static int dpaa_max_frm;
 
@@ -1313,13 +1307,14 @@ static void dpaa_fd_release(const struct net_device *net_dev,
 		vaddr = phys_to_virt(qm_fd_addr(fd));
 		sgt = vaddr + qm_fd_get_offset(fd);
 
-		dma_unmap_single(dpaa_bp->priv->rx_dma_dev, qm_fd_addr(fd),
-				 dpaa_bp->size, DMA_FROM_DEVICE);
+		dma_unmap_page(dpaa_bp->priv->rx_dma_dev, qm_fd_addr(fd),
+			       DPAA_BP_RAW_SIZE, DMA_FROM_DEVICE);
 
 		dpaa_release_sgt_members(sgt);
 
-		addr = dma_map_single(dpaa_bp->priv->rx_dma_dev, vaddr,
-				      dpaa_bp->size, DMA_FROM_DEVICE);
+		addr = dma_map_page(dpaa_bp->priv->rx_dma_dev,
+				    virt_to_page(vaddr), 0, DPAA_BP_RAW_SIZE,
+				    DMA_FROM_DEVICE);
 		if (dma_mapping_error(dpaa_bp->priv->rx_dma_dev, addr)) {
 			netdev_err(net_dev, "DMA mapping failed\n");
 			return;
@@ -1469,21 +1464,18 @@ static int dpaa_bp_add_8_bufs(const struct dpaa_bp *dpaa_bp)
 	struct net_device *net_dev = dpaa_bp->priv->net_dev;
 	struct bm_buffer bmb[8];
 	dma_addr_t addr;
-	void *new_buf;
+	struct page *p;
 	u8 i;
 
 	for (i = 0; i < 8; i++) {
-		new_buf = netdev_alloc_frag(dpaa_bp->raw_size);
-		if (unlikely(!new_buf)) {
-			netdev_err(net_dev,
-				   "netdev_alloc_frag() failed, size %zu\n",
-				   dpaa_bp->raw_size);
+		p = dev_alloc_pages(0);
+		if (unlikely(!p)) {
+			netdev_err(net_dev, "dev_alloc_pages() failed\n");
 			goto release_previous_buffs;
 		}
-		new_buf = PTR_ALIGN(new_buf, SMP_CACHE_BYTES);
 
-		addr = dma_map_single(dpaa_bp->priv->rx_dma_dev, new_buf,
-				      dpaa_bp->size, DMA_FROM_DEVICE);
+		addr = dma_map_page(dpaa_bp->priv->rx_dma_dev, p, 0,
+				    DPAA_BP_RAW_SIZE, DMA_FROM_DEVICE);
 		if (unlikely(dma_mapping_error(dpaa_bp->priv->rx_dma_dev,
 					       addr))) {
 			netdev_err(net_dev, "DMA map failed\n");
@@ -1694,7 +1686,7 @@ static struct sk_buff *contig_fd_to_skb(const struct dpaa_priv *priv,
 	return skb;
 
 free_buffer:
-	skb_free_frag(vaddr);
+	free_pages((unsigned long)vaddr, 0);
 	return NULL;
 }
 
@@ -1741,8 +1733,8 @@ static struct sk_buff *sg_fd_to_skb(const struct dpaa_priv *priv,
 			goto free_buffers;
 
 		count_ptr = this_cpu_ptr(dpaa_bp->percpu_count);
-		dma_unmap_single(dpaa_bp->priv->rx_dma_dev, sg_addr,
-				 dpaa_bp->size, DMA_FROM_DEVICE);
+		dma_unmap_page(priv->rx_dma_dev, sg_addr,
+			       DPAA_BP_RAW_SIZE, DMA_FROM_DEVICE);
 		if (!skb) {
 			sz = dpaa_bp->size +
 				SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
@@ -1794,7 +1786,7 @@ static struct sk_buff *sg_fd_to_skb(const struct dpaa_priv *priv,
 	WARN_ONCE(i == DPAA_SGT_MAX_ENTRIES, "No final bit on SGT\n");
 
 	/* free the SG table buffer */
-	skb_free_frag(vaddr);
+	free_pages((unsigned long)vaddr, 0);
 
 	return skb;
 
@@ -1811,7 +1803,7 @@ static struct sk_buff *sg_fd_to_skb(const struct dpaa_priv *priv,
 	for (i = 0; i < DPAA_SGT_MAX_ENTRIES ; i++) {
 		sg_addr = qm_sg_addr(&sgt[i]);
 		sg_vaddr = phys_to_virt(sg_addr);
-		skb_free_frag(sg_vaddr);
+		free_pages((unsigned long)sg_vaddr, 0);
 		dpaa_bp = dpaa_bpid2pool(sgt[i].bpid);
 		if (dpaa_bp) {
 			count_ptr = this_cpu_ptr(dpaa_bp->percpu_count);
@@ -1822,7 +1814,7 @@ static struct sk_buff *sg_fd_to_skb(const struct dpaa_priv *priv,
 			break;
 	}
 	/* free the SGT fragment */
-	skb_free_frag(vaddr);
+	free_pages((unsigned long)vaddr, 0);
 
 	return NULL;
 }
@@ -2281,8 +2273,8 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 		return qman_cb_dqrr_consume;
 	}
 
-	dma_unmap_single(dpaa_bp->priv->rx_dma_dev, addr, dpaa_bp->size,
-			 DMA_FROM_DEVICE);
+	dma_unmap_page(dpaa_bp->priv->rx_dma_dev, addr, DPAA_BP_RAW_SIZE,
+		       DMA_FROM_DEVICE);
 
 	/* prefetch the first 64 bytes of the frame or the SGT start */
 	vaddr = phys_to_virt(addr);
@@ -2637,7 +2629,8 @@ static inline void dpaa_bp_free_pf(const struct dpaa_bp *bp,
 {
 	dma_addr_t addr = bm_buf_addr(bmb);
 
-	dma_unmap_single(bp->priv->rx_dma_dev, addr, bp->size, DMA_FROM_DEVICE);
+	dma_unmap_page(bp->priv->rx_dma_dev, addr, DPAA_BP_RAW_SIZE,
+		       DMA_FROM_DEVICE);
 
 	skb_free_frag(phys_to_virt(addr));
 }
-- 
2.1.0

