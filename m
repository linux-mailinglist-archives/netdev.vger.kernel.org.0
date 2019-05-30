Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 992192FD74
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 16:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfE3OT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 10:19:59 -0400
Received: from inva021.nxp.com ([92.121.34.21]:47256 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbfE3OT7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 10:19:59 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 978E22005F6;
        Thu, 30 May 2019 16:19:56 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 944CB200280;
        Thu, 30 May 2019 16:19:56 +0200 (CEST)
Received: from fsr-ub1864-101.ea.freescale.net (fsr-ub1864-101.ea.freescale.net [10.171.82.13])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 0BA872026B;
        Thu, 30 May 2019 16:19:56 +0200 (CEST)
From:   laurentiu.tudor@nxp.com
To:     netdev@vger.kernel.org, madalin.bucur@nxp.com, roy.pledge@nxp.com,
        camelia.groza@nxp.com, leoyang.li@nxp.com
Cc:     Joakim.Tjernlund@infinera.com, davem@davemloft.net,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: [PATCH v3 5/6] dpaa_eth: fix iova handling for contiguous frames
Date:   Thu, 30 May 2019 17:19:50 +0300
Message-Id: <20190530141951.6704-6-laurentiu.tudor@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190530141951.6704-1-laurentiu.tudor@nxp.com>
References: <20190530141951.6704-1-laurentiu.tudor@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

The driver relies on the no longer valid assumption that dma addresses
(iovas) are identical to physical addressees and uses phys_to_virt() to
make iova -> vaddr conversions. Fix this by adding a function that does
proper iova -> phys conversions using the iommu api and update the code
to use it.
Also, a dma_unmap_single() call had to be moved further down the code
because iova -> vaddr conversions were required before the unmap.
For now only the contiguous frame case is handled and the SG case is
split in a following patch.
While at it, clean-up a redundant dpaa_bpid2pool() and pass the bp
as parameter.

Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Acked-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 42 ++++++++++---------
 .../net/ethernet/freescale/dpaa/dpaa_eth.h    |  2 +
 2 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index f54b0cd0d175..46194a04617a 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -50,6 +50,7 @@
 #include <linux/highmem.h>
 #include <linux/percpu.h>
 #include <linux/dma-mapping.h>
+#include <linux/iommu.h>
 #include <linux/sort.h>
 #include <linux/phy_fixed.h>
 #include <soc/fsl/bman.h>
@@ -1595,6 +1596,12 @@ static int dpaa_eth_refill_bpools(struct dpaa_priv *priv)
 	return 0;
 }
 
+static phys_addr_t dpaa_iova_to_phys(const struct dpaa_priv *priv,
+				     dma_addr_t addr)
+{
+	return priv->domain ? iommu_iova_to_phys(priv->domain, addr) : addr;
+}
+
 /* Cleanup function for outgoing frame descriptors that were built on Tx path,
  * either contiguous frames or scatter/gather ones.
  * Skb freeing is not handled here.
@@ -1617,7 +1624,7 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 	int nr_frags, i;
 	u64 ns;
 
-	skbh = (struct sk_buff **)phys_to_virt(addr);
+	skbh = (struct sk_buff **)phys_to_virt(dpaa_iova_to_phys(priv, addr));
 	skb = *skbh;
 
 	if (priv->tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
@@ -1687,25 +1694,21 @@ static u8 rx_csum_offload(const struct dpaa_priv *priv, const struct qm_fd *fd)
  * accommodate the shared info area of the skb.
  */
 static struct sk_buff *contig_fd_to_skb(const struct dpaa_priv *priv,
-					const struct qm_fd *fd)
+					const struct qm_fd *fd,
+					struct dpaa_bp *dpaa_bp,
+					void *vaddr)
 {
 	ssize_t fd_off = qm_fd_get_offset(fd);
-	dma_addr_t addr = qm_fd_addr(fd);
-	struct dpaa_bp *dpaa_bp;
 	struct sk_buff *skb;
-	void *vaddr;
 
-	vaddr = phys_to_virt(addr);
 	WARN_ON(!IS_ALIGNED((unsigned long)vaddr, SMP_CACHE_BYTES));
 
-	dpaa_bp = dpaa_bpid2pool(fd->bpid);
-	if (!dpaa_bp)
-		goto free_buffer;
-
 	skb = build_skb(vaddr, dpaa_bp->size +
 			SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
-	if (WARN_ONCE(!skb, "Build skb failure on Rx\n"))
-		goto free_buffer;
+	if (WARN_ONCE(!skb, "Build skb failure on Rx\n")) {
+		skb_free_frag(vaddr);
+		return NULL;
+	}
 	WARN_ON(fd_off != priv->rx_headroom);
 	skb_reserve(skb, fd_off);
 	skb_put(skb, qm_fd_get_length(fd));
@@ -1713,10 +1716,6 @@ static struct sk_buff *contig_fd_to_skb(const struct dpaa_priv *priv,
 	skb->ip_summed = rx_csum_offload(priv, fd);
 
 	return skb;
-
-free_buffer:
-	skb_free_frag(vaddr);
-	return NULL;
 }
 
 /* Build an skb with the data of the first S/G entry in the linear portion and
@@ -2309,12 +2308,12 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 	if (!dpaa_bp)
 		return qman_cb_dqrr_consume;
 
-	dma_unmap_single(dpaa_bp->dev, addr, dpaa_bp->size, DMA_FROM_DEVICE);
-
 	/* prefetch the first 64 bytes of the frame or the SGT start */
-	vaddr = phys_to_virt(addr);
+	vaddr = phys_to_virt(dpaa_iova_to_phys(priv, addr));
 	prefetch(vaddr + qm_fd_get_offset(fd));
 
+	dma_unmap_single(dpaa_bp->dev, addr, dpaa_bp->size, DMA_FROM_DEVICE);
+
 	/* The only FD types that we may receive are contig and S/G */
 	WARN_ON((fd_format != qm_fd_contig) && (fd_format != qm_fd_sg));
 
@@ -2325,7 +2324,7 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 	(*count_ptr)--;
 
 	if (likely(fd_format == qm_fd_contig))
-		skb = contig_fd_to_skb(priv, fd);
+		skb = contig_fd_to_skb(priv, fd, dpaa_bp, vaddr);
 	else
 		skb = sg_fd_to_skb(priv, fd);
 	if (!skb)
@@ -2836,6 +2835,9 @@ static int dpaa_eth_probe(struct platform_device *pdev)
 	priv = netdev_priv(net_dev);
 	priv->net_dev = net_dev;
 
+	/* cache iommu domain */
+	priv->domain = iommu_get_domain_for_dev(dev);
+
 	priv->msg_enable = netif_msg_init(debug, DPAA_MSG_DEFAULT);
 
 	/* If fsl_fm_max_frm is set to a higher value than the all-common 1500,
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
index af320f83c742..1548cb67b448 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
@@ -185,6 +185,8 @@ struct dpaa_priv {
 
 	bool tx_tstamp; /* Tx timestamping enabled */
 	bool rx_tstamp; /* Rx timestamping enabled */
+
+	struct iommu_domain *domain;
 };
 
 /* from dpaa_ethtool.c */
-- 
2.17.1

