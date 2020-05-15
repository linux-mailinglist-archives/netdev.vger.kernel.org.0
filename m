Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2CC21D4DAF
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 14:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgEOMal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 08:30:41 -0400
Received: from inva020.nxp.com ([92.121.34.13]:35724 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbgEOMal (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 08:30:41 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 18AD41A06EF;
        Fri, 15 May 2020 14:30:39 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 07E6C1A06E6;
        Fri, 15 May 2020 14:30:39 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B2EC020328;
        Fri, 15 May 2020 14:30:38 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH] dpaa2-eth: properly handle buffer size restrictions
Date:   Fri, 15 May 2020 15:30:22 +0300
Message-Id: <20200515123022.31227-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Depending on the WRIOP version, the buffer size on the RX path must by a
multiple of 64 or 256. Handle this restriction properly by aligning down
the buffer size to the necessary value. Also, use the new buffer size
dynamically computed instead of the compile time one.

Fixes: 27c874867c4e ("dpaa2-eth: Use a single page per Rx buffer")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 29 +++++++++++--------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  1 +
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index b1c64288a1fb..4388d1039822 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -86,7 +86,7 @@ static void free_rx_fd(struct dpaa2_eth_priv *priv,
 	for (i = 1; i < DPAA2_ETH_MAX_SG_ENTRIES; i++) {
 		addr = dpaa2_sg_get_addr(&sgt[i]);
 		sg_vaddr = dpaa2_iova_to_virt(priv->iommu_domain, addr);
-		dma_unmap_page(dev, addr, DPAA2_ETH_RX_BUF_SIZE,
+		dma_unmap_page(dev, addr, priv->rx_buf_size,
 			       DMA_BIDIRECTIONAL);
 
 		free_pages((unsigned long)sg_vaddr, 0);
@@ -144,7 +144,7 @@ static struct sk_buff *build_frag_skb(struct dpaa2_eth_priv *priv,
 		/* Get the address and length from the S/G entry */
 		sg_addr = dpaa2_sg_get_addr(sge);
 		sg_vaddr = dpaa2_iova_to_virt(priv->iommu_domain, sg_addr);
-		dma_unmap_page(dev, sg_addr, DPAA2_ETH_RX_BUF_SIZE,
+		dma_unmap_page(dev, sg_addr, priv->rx_buf_size,
 			       DMA_BIDIRECTIONAL);
 
 		sg_length = dpaa2_sg_get_len(sge);
@@ -185,7 +185,7 @@ static struct sk_buff *build_frag_skb(struct dpaa2_eth_priv *priv,
 				(page_address(page) - page_address(head_page));
 
 			skb_add_rx_frag(skb, i - 1, head_page, page_offset,
-					sg_length, DPAA2_ETH_RX_BUF_SIZE);
+					sg_length, priv->rx_buf_size);
 		}
 
 		if (dpaa2_sg_is_final(sge))
@@ -211,7 +211,7 @@ static void free_bufs(struct dpaa2_eth_priv *priv, u64 *buf_array, int count)
 
 	for (i = 0; i < count; i++) {
 		vaddr = dpaa2_iova_to_virt(priv->iommu_domain, buf_array[i]);
-		dma_unmap_page(dev, buf_array[i], DPAA2_ETH_RX_BUF_SIZE,
+		dma_unmap_page(dev, buf_array[i], priv->rx_buf_size,
 			       DMA_BIDIRECTIONAL);
 		free_pages((unsigned long)vaddr, 0);
 	}
@@ -382,7 +382,7 @@ static u32 run_xdp(struct dpaa2_eth_priv *priv,
 		break;
 	case XDP_REDIRECT:
 		dma_unmap_page(priv->net_dev->dev.parent, addr,
-			       DPAA2_ETH_RX_BUF_SIZE, DMA_BIDIRECTIONAL);
+			       priv->rx_buf_size, DMA_BIDIRECTIONAL);
 		ch->buf_count--;
 		xdp.data_hard_start = vaddr;
 		err = xdp_do_redirect(priv->net_dev, &xdp, xdp_prog);
@@ -421,7 +421,7 @@ static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 	trace_dpaa2_rx_fd(priv->net_dev, fd);
 
 	vaddr = dpaa2_iova_to_virt(priv->iommu_domain, addr);
-	dma_sync_single_for_cpu(dev, addr, DPAA2_ETH_RX_BUF_SIZE,
+	dma_sync_single_for_cpu(dev, addr, priv->rx_buf_size,
 				DMA_BIDIRECTIONAL);
 
 	fas = dpaa2_get_fas(vaddr, false);
@@ -440,13 +440,13 @@ static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 			return;
 		}
 
-		dma_unmap_page(dev, addr, DPAA2_ETH_RX_BUF_SIZE,
+		dma_unmap_page(dev, addr, priv->rx_buf_size,
 			       DMA_BIDIRECTIONAL);
 		skb = build_linear_skb(ch, fd, vaddr);
 	} else if (fd_format == dpaa2_fd_sg) {
 		WARN_ON(priv->xdp_prog);
 
-		dma_unmap_page(dev, addr, DPAA2_ETH_RX_BUF_SIZE,
+		dma_unmap_page(dev, addr, priv->rx_buf_size,
 			       DMA_BIDIRECTIONAL);
 		skb = build_frag_skb(priv, ch, buf_data);
 		free_pages((unsigned long)vaddr, 0);
@@ -1022,7 +1022,7 @@ static int add_bufs(struct dpaa2_eth_priv *priv,
 		if (!page)
 			goto err_alloc;
 
-		addr = dma_map_page(dev, page, 0, DPAA2_ETH_RX_BUF_SIZE,
+		addr = dma_map_page(dev, page, 0, priv->rx_buf_size,
 				    DMA_BIDIRECTIONAL);
 		if (unlikely(dma_mapping_error(dev, addr)))
 			goto err_map;
@@ -1032,7 +1032,7 @@ static int add_bufs(struct dpaa2_eth_priv *priv,
 		/* tracing point */
 		trace_dpaa2_eth_buf_seed(priv->net_dev,
 					 page, DPAA2_ETH_RX_BUF_RAW_SIZE,
-					 addr, DPAA2_ETH_RX_BUF_SIZE,
+					 addr, priv->rx_buf_size,
 					 bpid);
 	}
 
@@ -1772,7 +1772,7 @@ static bool xdp_mtu_valid(struct dpaa2_eth_priv *priv, int mtu)
 	int mfl, linear_mfl;
 
 	mfl = DPAA2_ETH_L2_MAX_FRM(mtu);
-	linear_mfl = DPAA2_ETH_RX_BUF_SIZE - DPAA2_ETH_RX_HWA_SIZE -
+	linear_mfl = priv->rx_buf_size - DPAA2_ETH_RX_HWA_SIZE -
 		     dpaa2_eth_rx_head_room(priv) - XDP_PACKET_HEADROOM;
 
 	if (mfl > linear_mfl) {
@@ -2507,6 +2507,11 @@ static int set_buffer_layout(struct dpaa2_eth_priv *priv)
 	else
 		rx_buf_align = DPAA2_ETH_RX_BUF_ALIGN;
 
+	/* We need to ensure that the buffer size seen by WRIOP is a multiple
+	 * of 64 or 256 bytes depending on the WRIOP version.
+	 */
+	priv->rx_buf_size = ALIGN_DOWN(DPAA2_ETH_RX_BUF_SIZE, rx_buf_align);
+
 	/* tx buffer */
 	buf_layout.private_data_size = DPAA2_ETH_SWA_SIZE;
 	buf_layout.pass_timestamp = true;
@@ -3192,7 +3197,7 @@ static int bind_dpni(struct dpaa2_eth_priv *priv)
 	pools_params.num_dpbp = 1;
 	pools_params.pools[0].dpbp_id = priv->dpbp_dev->obj_desc.id;
 	pools_params.pools[0].backup_pool = 0;
-	pools_params.pools[0].buffer_size = DPAA2_ETH_RX_BUF_SIZE;
+	pools_params.pools[0].buffer_size = priv->rx_buf_size;
 	err = dpni_set_pools(priv->mc_io, 0, priv->mc_token, &pools_params);
 	if (err) {
 		dev_err(dev, "dpni_set_pools() failed\n");
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 9c37b6946cec..0581fbf1f98c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -394,6 +394,7 @@ struct dpaa2_eth_priv {
 	u16 tx_data_offset;
 
 	struct fsl_mc_device *dpbp_dev;
+	u16 rx_buf_size;
 	u16 bpid;
 	struct iommu_domain *iommu_domain;
 
-- 
2.17.1

