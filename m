Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA1C212924A
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 08:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbfLWHj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 02:39:28 -0500
Received: from inva020.nxp.com ([92.121.34.13]:59854 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbfLWHj2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Dec 2019 02:39:28 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 3B94E1A0E74;
        Mon, 23 Dec 2019 08:39:25 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 2FB891A0CD2;
        Mon, 23 Dec 2019 08:39:25 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id EEE742033F;
        Mon, 23 Dec 2019 08:39:24 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@oss.nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     leon@kernel.org, Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: [PATCH net,v2] dpaa_eth: fix DMA mapping leak
Date:   Mon, 23 Dec 2019 09:39:22 +0200
Message-Id: <1577086762-11453-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: git-send-email 2.1.0
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@oss.nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the error path some fragments remain DMA mapped. Adding a fix
that unmaps all the fragments. Rework cleanup path to be simpler.

Fixes: 8151ee88bad5 ("dpaa_eth: use page backed rx buffers")
Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
---

Changes from v1: used Dave's suggestion to simplify cleanup path 

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 39 +++++++++++++-------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 6a9d12dad5d9..a301f0095223 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1719,7 +1719,7 @@ static struct sk_buff *sg_fd_to_skb(const struct dpaa_priv *priv,
 	int page_offset;
 	unsigned int sz;
 	int *count_ptr;
-	int i;
+	int i, j;
 
 	vaddr = phys_to_virt(addr);
 	WARN_ON(!IS_ALIGNED((unsigned long)vaddr, SMP_CACHE_BYTES));
@@ -1736,14 +1736,14 @@ static struct sk_buff *sg_fd_to_skb(const struct dpaa_priv *priv,
 		WARN_ON(!IS_ALIGNED((unsigned long)sg_vaddr,
 				    SMP_CACHE_BYTES));
 
+		dma_unmap_page(priv->rx_dma_dev, sg_addr,
+			       DPAA_BP_RAW_SIZE, DMA_FROM_DEVICE);
+
 		/* We may use multiple Rx pools */
 		dpaa_bp = dpaa_bpid2pool(sgt[i].bpid);
 		if (!dpaa_bp)
 			goto free_buffers;
 
-		count_ptr = this_cpu_ptr(dpaa_bp->percpu_count);
-		dma_unmap_page(priv->rx_dma_dev, sg_addr,
-			       DPAA_BP_RAW_SIZE, DMA_FROM_DEVICE);
 		if (!skb) {
 			sz = dpaa_bp->size +
 				SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
@@ -1786,7 +1786,9 @@ static struct sk_buff *sg_fd_to_skb(const struct dpaa_priv *priv,
 			skb_add_rx_frag(skb, i - 1, head_page, frag_off,
 					frag_len, dpaa_bp->size);
 		}
+
 		/* Update the pool count for the current {cpu x bpool} */
+		count_ptr = this_cpu_ptr(dpaa_bp->percpu_count);
 		(*count_ptr)--;
 
 		if (qm_sg_entry_is_final(&sgt[i]))
@@ -1800,26 +1802,25 @@ static struct sk_buff *sg_fd_to_skb(const struct dpaa_priv *priv,
 	return skb;
 
 free_buffers:
-	/* compensate sw bpool counter changes */
-	for (i--; i >= 0; i--) {
-		dpaa_bp = dpaa_bpid2pool(sgt[i].bpid);
-		if (dpaa_bp) {
-			count_ptr = this_cpu_ptr(dpaa_bp->percpu_count);
-			(*count_ptr)++;
-		}
-	}
 	/* free all the SG entries */
-	for (i = 0; i < DPAA_SGT_MAX_ENTRIES ; i++) {
-		sg_addr = qm_sg_addr(&sgt[i]);
+	for (j = 0; j < DPAA_SGT_MAX_ENTRIES ; j++) {
+		sg_addr = qm_sg_addr(&sgt[j]);
 		sg_vaddr = phys_to_virt(sg_addr);
+		/* all pages 0..i were unmaped */
+		if (j > i)
+			dma_unmap_page(priv->rx_dma_dev, qm_sg_addr(&sgt[j]),
+				       DPAA_BP_RAW_SIZE, DMA_FROM_DEVICE);
 		free_pages((unsigned long)sg_vaddr, 0);
-		dpaa_bp = dpaa_bpid2pool(sgt[i].bpid);
-		if (dpaa_bp) {
-			count_ptr = this_cpu_ptr(dpaa_bp->percpu_count);
-			(*count_ptr)--;
+		/* counters 0..i-1 were decremented */
+		if (j >= i) {
+			dpaa_bp = dpaa_bpid2pool(sgt[j].bpid);
+			if (dpaa_bp) {
+				count_ptr = this_cpu_ptr(dpaa_bp->percpu_count);
+				(*count_ptr)--;
+			}
 		}
 
-		if (qm_sg_entry_is_final(&sgt[i]))
+		if (qm_sg_entry_is_final(&sgt[j]))
 			break;
 	}
 	/* free the SGT fragment */
-- 
2.1.0

