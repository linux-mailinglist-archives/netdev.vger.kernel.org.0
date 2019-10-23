Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA29E1561
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 11:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403772AbfJWJJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 05:09:16 -0400
Received: from inva020.nxp.com ([92.121.34.13]:34238 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390666AbfJWJJP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 05:09:15 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E0D481A0A9E;
        Wed, 23 Oct 2019 11:09:12 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C98281A07B5;
        Wed, 23 Oct 2019 11:09:12 +0200 (CEST)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 8B654205FE;
        Wed, 23 Oct 2019 11:09:12 +0200 (CEST)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, laurentiu.tudor@nxp.com,
        jakub.kicinski@netronome.com, Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net-next v3 5/7] dpaa_eth: change DMA device
Date:   Wed, 23 Oct 2019 12:08:44 +0300
Message-Id: <1571821726-6624-6-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1571821726-6624-1-git-send-email-madalin.bucur@nxp.com>
References: <1571821726-6624-1-git-send-email-madalin.bucur@nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DPAA Ethernet driver is using the FMan MAC as the device for DMA
mapping. This is not actually correct, as the real DMA device is the
FMan port (the FMan Rx port for reception and the FMan Tx port for
transmission). Changing the device used for DMA mapping to the Fman
Rx and Tx port devices.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 105 +++++++++++++------------
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.h |   8 +-
 2 files changed, 62 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 8d5686d88d30..e376c32fa003 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1335,15 +1335,15 @@ static void dpaa_fd_release(const struct net_device *net_dev,
 		vaddr = phys_to_virt(qm_fd_addr(fd));
 		sgt = vaddr + qm_fd_get_offset(fd);
 
-		dma_unmap_single(dpaa_bp->dev, qm_fd_addr(fd), dpaa_bp->size,
-				 DMA_FROM_DEVICE);
+		dma_unmap_single(dpaa_bp->priv->rx_dma_dev, qm_fd_addr(fd),
+				 dpaa_bp->size, DMA_FROM_DEVICE);
 
 		dpaa_release_sgt_members(sgt);
 
-		addr = dma_map_single(dpaa_bp->dev, vaddr, dpaa_bp->size,
-				      DMA_FROM_DEVICE);
-		if (dma_mapping_error(dpaa_bp->dev, addr)) {
-			dev_err(dpaa_bp->dev, "DMA mapping failed");
+		addr = dma_map_single(dpaa_bp->priv->rx_dma_dev, vaddr,
+				      dpaa_bp->size, DMA_FROM_DEVICE);
+		if (dma_mapping_error(dpaa_bp->priv->rx_dma_dev, addr)) {
+			netdev_err(net_dev, "DMA mapping failed\n");
 			return;
 		}
 		bm_buffer_set64(&bmb, addr);
@@ -1488,7 +1488,7 @@ static int dpaa_enable_tx_csum(struct dpaa_priv *priv,
 
 static int dpaa_bp_add_8_bufs(const struct dpaa_bp *dpaa_bp)
 {
-	struct device *dev = dpaa_bp->dev;
+	struct net_device *net_dev = dpaa_bp->priv->net_dev;
 	struct bm_buffer bmb[8];
 	dma_addr_t addr;
 	void *new_buf;
@@ -1497,16 +1497,18 @@ static int dpaa_bp_add_8_bufs(const struct dpaa_bp *dpaa_bp)
 	for (i = 0; i < 8; i++) {
 		new_buf = netdev_alloc_frag(dpaa_bp->raw_size);
 		if (unlikely(!new_buf)) {
-			dev_err(dev, "netdev_alloc_frag() failed, size %zu\n",
-				dpaa_bp->raw_size);
+			netdev_err(net_dev,
+				   "netdev_alloc_frag() failed, size %zu\n",
+				   dpaa_bp->raw_size);
 			goto release_previous_buffs;
 		}
 		new_buf = PTR_ALIGN(new_buf, SMP_CACHE_BYTES);
 
-		addr = dma_map_single(dev, new_buf,
+		addr = dma_map_single(dpaa_bp->priv->rx_dma_dev, new_buf,
 				      dpaa_bp->size, DMA_FROM_DEVICE);
-		if (unlikely(dma_mapping_error(dev, addr))) {
-			dev_err(dpaa_bp->dev, "DMA map failed");
+		if (unlikely(dma_mapping_error(dpaa_bp->priv->rx_dma_dev,
+					       addr))) {
+			netdev_err(net_dev, "DMA map failed\n");
 			goto release_previous_buffs;
 		}
 
@@ -1634,7 +1636,7 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 
 	if (unlikely(qm_fd_get_format(fd) == qm_fd_sg)) {
 		nr_frags = skb_shinfo(skb)->nr_frags;
-		dma_unmap_single(dev, addr,
+		dma_unmap_single(priv->tx_dma_dev, addr,
 				 qm_fd_get_offset(fd) + DPAA_SGT_SIZE,
 				 dma_dir);
 
@@ -1644,21 +1646,21 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
 		sgt = phys_to_virt(addr + qm_fd_get_offset(fd));
 
 		/* sgt[0] is from lowmem, was dma_map_single()-ed */
-		dma_unmap_single(dev, qm_sg_addr(&sgt[0]),
+		dma_unmap_single(priv->tx_dma_dev, qm_sg_addr(&sgt[0]),
 				 qm_sg_entry_get_len(&sgt[0]), dma_dir);
 
 		/* remaining pages were mapped with skb_frag_dma_map() */
 		for (i = 1; i <= nr_frags; i++) {
 			WARN_ON(qm_sg_entry_is_ext(&sgt[i]));
 
-			dma_unmap_page(dev, qm_sg_addr(&sgt[i]),
+			dma_unmap_page(priv->tx_dma_dev, qm_sg_addr(&sgt[i]),
 				       qm_sg_entry_get_len(&sgt[i]), dma_dir);
 		}
 
 		/* Free the page frag that we allocated on Tx */
 		skb_free_frag(phys_to_virt(addr));
 	} else {
-		dma_unmap_single(dev, addr,
+		dma_unmap_single(priv->tx_dma_dev, addr,
 				 skb_tail_pointer(skb) - (u8 *)skbh, dma_dir);
 	}
 
@@ -1762,8 +1764,8 @@ static struct sk_buff *sg_fd_to_skb(const struct dpaa_priv *priv,
 			goto free_buffers;
 
 		count_ptr = this_cpu_ptr(dpaa_bp->percpu_count);
-		dma_unmap_single(dpaa_bp->dev, sg_addr, dpaa_bp->size,
-				 DMA_FROM_DEVICE);
+		dma_unmap_single(dpaa_bp->priv->rx_dma_dev, sg_addr,
+				 dpaa_bp->size, DMA_FROM_DEVICE);
 		if (!skb) {
 			sz = dpaa_bp->size +
 				SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
@@ -1853,7 +1855,6 @@ static int skb_to_contig_fd(struct dpaa_priv *priv,
 			    int *offset)
 {
 	struct net_device *net_dev = priv->net_dev;
-	struct device *dev = net_dev->dev.parent;
 	enum dma_data_direction dma_dir;
 	unsigned char *buffer_start;
 	struct sk_buff **skbh;
@@ -1889,9 +1890,9 @@ static int skb_to_contig_fd(struct dpaa_priv *priv,
 	fd->cmd |= cpu_to_be32(FM_FD_CMD_FCO);
 
 	/* Map the entire buffer size that may be seen by FMan, but no more */
-	addr = dma_map_single(dev, skbh,
+	addr = dma_map_single(priv->tx_dma_dev, skbh,
 			      skb_tail_pointer(skb) - buffer_start, dma_dir);
-	if (unlikely(dma_mapping_error(dev, addr))) {
+	if (unlikely(dma_mapping_error(priv->tx_dma_dev, addr))) {
 		if (net_ratelimit())
 			netif_err(priv, tx_err, net_dev, "dma_map_single() failed\n");
 		return -EINVAL;
@@ -1907,7 +1908,6 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
 	const enum dma_data_direction dma_dir = DMA_TO_DEVICE;
 	const int nr_frags = skb_shinfo(skb)->nr_frags;
 	struct net_device *net_dev = priv->net_dev;
-	struct device *dev = net_dev->dev.parent;
 	struct qm_sg_entry *sgt;
 	struct sk_buff **skbh;
 	int i, j, err, sz;
@@ -1946,10 +1946,10 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
 	qm_sg_entry_set_len(&sgt[0], frag_len);
 	sgt[0].bpid = FSL_DPAA_BPID_INV;
 	sgt[0].offset = 0;
-	addr = dma_map_single(dev, skb->data,
+	addr = dma_map_single(priv->tx_dma_dev, skb->data,
 			      skb_headlen(skb), dma_dir);
-	if (unlikely(dma_mapping_error(dev, addr))) {
-		dev_err(dev, "DMA mapping failed");
+	if (unlikely(dma_mapping_error(priv->tx_dma_dev, addr))) {
+		netdev_err(priv->net_dev, "DMA mapping failed\n");
 		err = -EINVAL;
 		goto sg0_map_failed;
 	}
@@ -1960,10 +1960,10 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
 		frag = &skb_shinfo(skb)->frags[i];
 		frag_len = skb_frag_size(frag);
 		WARN_ON(!skb_frag_page(frag));
-		addr = skb_frag_dma_map(dev, frag, 0,
+		addr = skb_frag_dma_map(priv->tx_dma_dev, frag, 0,
 					frag_len, dma_dir);
-		if (unlikely(dma_mapping_error(dev, addr))) {
-			dev_err(dev, "DMA mapping failed");
+		if (unlikely(dma_mapping_error(priv->tx_dma_dev, addr))) {
+			netdev_err(priv->net_dev, "DMA mapping failed\n");
 			err = -EINVAL;
 			goto sg_map_failed;
 		}
@@ -1986,10 +1986,10 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
 	skbh = (struct sk_buff **)buffer_start;
 	*skbh = skb;
 
-	addr = dma_map_single(dev, buffer_start,
+	addr = dma_map_single(priv->tx_dma_dev, buffer_start,
 			      priv->tx_headroom + DPAA_SGT_SIZE, dma_dir);
-	if (unlikely(dma_mapping_error(dev, addr))) {
-		dev_err(dev, "DMA mapping failed");
+	if (unlikely(dma_mapping_error(priv->tx_dma_dev, addr))) {
+		netdev_err(priv->net_dev, "DMA mapping failed\n");
 		err = -EINVAL;
 		goto sgt_map_failed;
 	}
@@ -2003,7 +2003,7 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
 sgt_map_failed:
 sg_map_failed:
 	for (j = 0; j < i; j++)
-		dma_unmap_page(dev, qm_sg_addr(&sgt[j]),
+		dma_unmap_page(priv->tx_dma_dev, qm_sg_addr(&sgt[j]),
 			       qm_sg_entry_get_len(&sgt[j]), dma_dir);
 sg0_map_failed:
 csum_failed:
@@ -2304,7 +2304,8 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 		return qman_cb_dqrr_consume;
 	}
 
-	dma_unmap_single(dpaa_bp->dev, addr, dpaa_bp->size, DMA_FROM_DEVICE);
+	dma_unmap_single(dpaa_bp->priv->rx_dma_dev, addr, dpaa_bp->size,
+			 DMA_FROM_DEVICE);
 
 	/* prefetch the first 64 bytes of the frame or the SGT start */
 	vaddr = phys_to_virt(addr);
@@ -2659,7 +2660,7 @@ static inline void dpaa_bp_free_pf(const struct dpaa_bp *bp,
 {
 	dma_addr_t addr = bm_buf_addr(bmb);
 
-	dma_unmap_single(bp->dev, addr, bp->size, DMA_FROM_DEVICE);
+	dma_unmap_single(bp->priv->rx_dma_dev, addr, bp->size, DMA_FROM_DEVICE);
 
 	skb_free_frag(phys_to_virt(addr));
 }
@@ -2769,25 +2770,27 @@ static int dpaa_eth_probe(struct platform_device *pdev)
 	int err = 0, i, channel;
 	struct device *dev;
 
+	dev = &pdev->dev;
+
 	err = bman_is_probed();
 	if (!err)
 		return -EPROBE_DEFER;
 	if (err < 0) {
-		dev_err(&pdev->dev, "failing probe due to bman probe error\n");
+		dev_err(dev, "failing probe due to bman probe error\n");
 		return -ENODEV;
 	}
 	err = qman_is_probed();
 	if (!err)
 		return -EPROBE_DEFER;
 	if (err < 0) {
-		dev_err(&pdev->dev, "failing probe due to qman probe error\n");
+		dev_err(dev, "failing probe due to qman probe error\n");
 		return -ENODEV;
 	}
 	err = bman_portals_probed();
 	if (!err)
 		return -EPROBE_DEFER;
 	if (err < 0) {
-		dev_err(&pdev->dev,
+		dev_err(dev,
 			"failing probe due to bman portals probe error\n");
 		return -ENODEV;
 	}
@@ -2795,19 +2798,11 @@ static int dpaa_eth_probe(struct platform_device *pdev)
 	if (!err)
 		return -EPROBE_DEFER;
 	if (err < 0) {
-		dev_err(&pdev->dev,
+		dev_err(dev,
 			"failing probe due to qman portals probe error\n");
 		return -ENODEV;
 	}
 
-	/* device used for DMA mapping */
-	dev = pdev->dev.parent;
-	err = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(40));
-	if (err) {
-		dev_err(dev, "dma_coerce_mask_and_coherent() failed\n");
-		return err;
-	}
-
 	/* Allocate this early, so we can store relevant information in
 	 * the private area
 	 */
@@ -2828,11 +2823,23 @@ static int dpaa_eth_probe(struct platform_device *pdev)
 
 	mac_dev = dpaa_mac_dev_get(pdev);
 	if (IS_ERR(mac_dev)) {
-		dev_err(dev, "dpaa_mac_dev_get() failed\n");
+		netdev_err(net_dev, "dpaa_mac_dev_get() failed\n");
 		err = PTR_ERR(mac_dev);
 		goto free_netdev;
 	}
 
+	/* Devices used for DMA mapping */
+	priv->rx_dma_dev = fman_port_get_device(mac_dev->port[RX]);
+	priv->tx_dma_dev = fman_port_get_device(mac_dev->port[TX]);
+	err = dma_coerce_mask_and_coherent(priv->rx_dma_dev, DMA_BIT_MASK(40));
+	if (!err)
+		err = dma_coerce_mask_and_coherent(priv->tx_dma_dev,
+						   DMA_BIT_MASK(40));
+	if (err) {
+		netdev_err(net_dev, "dma_coerce_mask_and_coherent() failed\n");
+		return err;
+	}
+
 	/* If fsl_fm_max_frm is set to a higher value than the all-common 1500,
 	 * we choose conservatively and let the user explicitly set a higher
 	 * MTU via ifconfig. Otherwise, the user may end up with different MTUs
@@ -2859,7 +2866,7 @@ static int dpaa_eth_probe(struct platform_device *pdev)
 		dpaa_bps[i]->raw_size = bpool_buffer_raw_size(i, DPAA_BPS_NUM);
 		/* avoid runtime computations by keeping the usable size here */
 		dpaa_bps[i]->size = dpaa_bp_size(dpaa_bps[i]->raw_size);
-		dpaa_bps[i]->dev = dev;
+		dpaa_bps[i]->priv = priv;
 
 		err = dpaa_bp_alloc_pool(dpaa_bps[i]);
 		if (err < 0)
@@ -2982,7 +2989,7 @@ static int dpaa_remove(struct platform_device *pdev)
 	struct device *dev;
 	int err;
 
-	dev = pdev->dev.parent;
+	dev = &pdev->dev;
 	net_dev = dev_get_drvdata(dev);
 
 	priv = netdev_priv(net_dev);
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
index f7e59e8db075..1bdfead1d334 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
@@ -80,9 +80,11 @@ struct dpaa_fq_cbs {
 	struct qman_fq egress_ern;
 };
 
+struct dpaa_priv;
+
 struct dpaa_bp {
-	/* device used in the DMA mapping operations */
-	struct device *dev;
+	/* used in the DMA mapping operations */
+	struct dpaa_priv *priv;
 	/* current number of buffers in the buffer pool alloted to each CPU */
 	int __percpu *percpu_count;
 	/* all buffers allocated for this pool have this raw size */
@@ -153,6 +155,8 @@ struct dpaa_priv {
 	u16 tx_headroom;
 	struct net_device *net_dev;
 	struct mac_device *mac_dev;
+	struct device *rx_dma_dev;
+	struct device *tx_dma_dev;
 	struct qman_fq *egress_fqs[DPAA_ETH_TXQ_NUM];
 	struct qman_fq *conf_fqs[DPAA_ETH_TXQ_NUM];
 
-- 
2.1.0

