Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75B53CF973
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 14:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731243AbfJHMLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 08:11:48 -0400
Received: from inva020.nxp.com ([92.121.34.13]:54354 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731184AbfJHMLh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 08:11:37 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E3F341A0249;
        Tue,  8 Oct 2019 14:11:34 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D6BE21A002E;
        Tue,  8 Oct 2019 14:11:34 +0200 (CEST)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 9555C205DB;
        Tue,  8 Oct 2019 14:11:34 +0200 (CEST)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, laurentiu.tudor@nxp.com,
        linux-kernel@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH 19/20] dpaa_eth: add dpaa_dma_to_virt()
Date:   Tue,  8 Oct 2019 15:10:40 +0300
Message-Id: <1570536641-25104-20-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1570536641-25104-1-git-send-email-madalin.bucur@nxp.com>
References: <1570536641-25104-1-git-send-email-madalin.bucur@nxp.com>
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Centralize the phys_to_virt() calls.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 45 ++++++++++++++------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 77edf2e026e8..c178f1b8c5e5 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -189,6 +189,15 @@ static int dpaa_rx_extra_headroom;
 #define dpaa_get_max_mtu()	\
 	(dpaa_max_frm - (VLAN_ETH_HLEN + ETH_FCS_LEN))
 
+static void *dpaa_dma_to_virt(struct device *dev, dma_addr_t addr)
+{
+	if (!addr) {
+		dev_err(dev, "Invalid address\n");
+		return NULL;
+	}
+	return phys_to_virt(addr);
+}
+
 static int dpaa_netdev_init(struct net_device *net_dev,
 			    const struct net_device_ops *dpaa_ops,
 			    u16 tx_timeout)
@@ -1307,7 +1316,8 @@ static void dpaa_fd_release(const struct net_device *net_dev,
 		return;
 
 	if (qm_fd_get_format(fd) == qm_fd_sg) {
-		vaddr = phys_to_virt(qm_fd_addr(fd));
+		vaddr = dpaa_dma_to_virt(dpaa_bp->priv->rx_dma_dev,
+					 qm_fd_addr(fd));
 		sgt = vaddr + qm_fd_get_offset(fd);
 
 		dma_unmap_page(dpaa_bp->priv->rx_dma_dev, qm_fd_addr(fd),
@@ -1588,12 +1598,13 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 	struct device *dev = priv->net_dev->dev.parent;
 	struct skb_shared_hwtstamps shhwtstamps;
 	dma_addr_t addr = qm_fd_addr(fd);
-	void *vaddr = phys_to_virt(addr);
 	const struct qm_sg_entry *sgt;
 	struct sk_buff *skb;
+	void *vaddr;
 	u64 ns;
 	int i;
 
+	vaddr = dpaa_dma_to_virt(priv->rx_dma_dev, addr);
 	if (unlikely(qm_fd_get_format(fd) == qm_fd_sg)) {
 		dma_unmap_page(priv->tx_dma_dev, addr,
 			       qm_fd_get_offset(fd) + DPAA_SGT_SIZE,
@@ -1667,16 +1678,11 @@ static u8 rx_csum_offload(const struct dpaa_priv *priv, const struct qm_fd *fd)
  * accommodate the shared info area of the skb.
  */
 static struct sk_buff *contig_fd_to_skb(const struct dpaa_priv *priv,
-					const struct qm_fd *fd)
+					const struct qm_fd *fd, void *vaddr)
 {
 	ssize_t fd_off = qm_fd_get_offset(fd);
-	dma_addr_t addr = qm_fd_addr(fd);
 	struct dpaa_bp *dpaa_bp;
 	struct sk_buff *skb;
-	void *vaddr;
-
-	vaddr = phys_to_virt(addr);
-	WARN_ON(!IS_ALIGNED((unsigned long)vaddr, SMP_CACHE_BYTES));
 
 	dpaa_bp = dpaa_bpid2pool(fd->bpid);
 	if (!dpaa_bp)
@@ -1705,14 +1711,13 @@ static struct sk_buff *contig_fd_to_skb(const struct dpaa_priv *priv,
  * The page fragment holding the S/G Table is recycled here.
  */
 static struct sk_buff *sg_fd_to_skb(const struct dpaa_priv *priv,
-				    const struct qm_fd *fd)
+				    const struct qm_fd *fd, void *vaddr)
 {
 	ssize_t fd_off = qm_fd_get_offset(fd);
-	dma_addr_t addr = qm_fd_addr(fd);
 	const struct qm_sg_entry *sgt;
 	struct page *page, *head_page;
 	struct dpaa_bp *dpaa_bp;
-	void *vaddr, *sg_vaddr;
+	void *sg_vaddr;
 	int frag_off, frag_len;
 	struct sk_buff *skb;
 	dma_addr_t sg_addr;
@@ -1721,9 +1726,6 @@ static struct sk_buff *sg_fd_to_skb(const struct dpaa_priv *priv,
 	int *count_ptr;
 	int i;
 
-	vaddr = phys_to_virt(addr);
-	WARN_ON(!IS_ALIGNED((unsigned long)vaddr, SMP_CACHE_BYTES));
-
 	/* Iterate through the SGT entries and add data buffers to the skb */
 	sgt = vaddr + fd_off;
 	skb = NULL;
@@ -1732,7 +1734,7 @@ static struct sk_buff *sg_fd_to_skb(const struct dpaa_priv *priv,
 		WARN_ON(qm_sg_entry_is_ext(&sgt[i]));
 
 		sg_addr = qm_sg_addr(&sgt[i]);
-		sg_vaddr = phys_to_virt(sg_addr);
+		sg_vaddr = dpaa_dma_to_virt(priv->rx_dma_dev, sg_addr);
 		WARN_ON(!IS_ALIGNED((unsigned long)sg_vaddr,
 				    SMP_CACHE_BYTES));
 
@@ -1811,7 +1813,7 @@ static struct sk_buff *sg_fd_to_skb(const struct dpaa_priv *priv,
 	/* free all the SG entries */
 	for (i = 0; i < DPAA_SGT_MAX_ENTRIES ; i++) {
 		sg_addr = qm_sg_addr(&sgt[i]);
-		sg_vaddr = phys_to_virt(sg_addr);
+		sg_vaddr = dpaa_dma_to_virt(priv->rx_dma_dev, sg_addr);
 		free_pages((unsigned long)sg_vaddr, 0);
 		dpaa_bp = dpaa_bpid2pool(sgt[i].bpid);
 		if (dpaa_bp) {
@@ -2281,11 +2283,12 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 		return qman_cb_dqrr_consume;
 	}
 
-	dma_unmap_page(dpaa_bp->priv->rx_dma_dev, addr, DPAA_BP_RAW_SIZE,
+	vaddr = dpaa_dma_to_virt(priv->rx_dma_dev, addr);
+
+	dma_unmap_page(priv->rx_dma_dev, addr, DPAA_BP_RAW_SIZE,
 		       DMA_FROM_DEVICE);
 
 	/* prefetch the first 64 bytes of the frame or the SGT start */
-	vaddr = phys_to_virt(addr);
 	prefetch(vaddr + qm_fd_get_offset(fd));
 
 	/* The only FD types that we may receive are contig and S/G */
@@ -2298,9 +2301,9 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 	(*count_ptr)--;
 
 	if (likely(fd_format == qm_fd_contig))
-		skb = contig_fd_to_skb(priv, fd);
+		skb = contig_fd_to_skb(priv, fd, vaddr);
 	else
-		skb = sg_fd_to_skb(priv, fd);
+		skb = sg_fd_to_skb(priv, fd, vaddr);
 	if (!skb)
 		return qman_cb_dqrr_consume;
 
@@ -2640,7 +2643,7 @@ static inline void dpaa_bp_free_pf(const struct dpaa_bp *bp,
 	dma_unmap_page(bp->priv->rx_dma_dev, addr, DPAA_BP_RAW_SIZE,
 		       DMA_FROM_DEVICE);
 
-	skb_free_frag(phys_to_virt(addr));
+	skb_free_frag(dpaa_dma_to_virt(bp->priv->rx_dma_dev, addr));
 }
 
 /* Alloc the dpaa_bp struct and configure default values */
-- 
2.1.0

