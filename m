Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38411E6CCE
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 22:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407371AbgE1Ury (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 16:47:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407361AbgE1Urt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 16:47:49 -0400
Received: from lore-desk.lan (unknown [151.48.140.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09F16208A7;
        Thu, 28 May 2020 20:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590698868;
        bh=vgJrR6hW1YCUyPNPAX535hp1C3q2ppzLzhfPxNuNclg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJjmLh8d2dzsRI7Su/Gcu79SpXv4aFXZiP/eCX2U6jpyN+BeDmW3Kzq0jTJXxPgJW
         9OM41HSamlGKlWpjOl6bCUN6rX9Y8qCEYPdjjIJytxZjI5xD6YlyjEYrvZOAhk+ex0
         OQCc+rZQSyMgEIehk84AiT7/y7jGpN2uv1/fLVTM=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     ast@kernel.org, davem@davemloft.net, brouer@redhat.com,
        daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: [PATCH v3 bpf-next 2/2] xdp: rename convert_to_xdp_frame in xdp_convert_buff_to_frame
Date:   Thu, 28 May 2020 22:47:29 +0200
Message-Id: <6344f739be0d1a08ab2b9607584c4d5478c8c083.1590698295.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1590698295.git.lorenzo@kernel.org>
References: <cover.1590698295.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to use standard 'xdp' prefix, rename convert_to_xdp_frame
utility routine in xdp_convert_buff_to_frame and replace all the
occurrences

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c     |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c      |  2 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c    |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c    |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c     |  2 +-
 drivers/net/ethernet/marvell/mvneta.c            |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 10 +++++-----
 drivers/net/ethernet/sfc/rx.c                    |  2 +-
 drivers/net/ethernet/socionext/netsec.c          |  2 +-
 drivers/net/ethernet/ti/cpsw_priv.c              |  2 +-
 drivers/net/tun.c                                |  2 +-
 drivers/net/veth.c                               |  2 +-
 drivers/net/virtio_net.c                         |  4 ++--
 include/net/xdp.h                                |  2 +-
 kernel/bpf/cpumap.c                              |  2 +-
 kernel/bpf/devmap.c                              |  2 +-
 16 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 46865d5bd7e7..a0af74c93971 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -263,7 +263,7 @@ static int ena_xdp_tx_map_buff(struct ena_ring *xdp_ring,
 	dma_addr_t dma = 0;
 	u32 size;
 
-	tx_info->xdpf = convert_to_xdp_frame(xdp);
+	tx_info->xdpf = xdp_convert_buff_to_frame(xdp);
 	size = tx_info->xdpf->len;
 	ena_buf = tx_info->bufs;
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index f613782f2f56..f9555c847f73 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2167,7 +2167,7 @@ static int i40e_xmit_xdp_ring(struct xdp_frame *xdpf,
 
 int i40e_xmit_xdp_tx_ring(struct xdp_buff *xdp, struct i40e_ring *xdp_ring)
 {
-	struct xdp_frame *xdpf = convert_to_xdp_frame(xdp);
+	struct xdp_frame *xdpf = xdp_convert_buff_to_frame(xdp);
 
 	if (unlikely(!xdpf))
 		return I40E_XDP_CONSUMED;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 1ba97172d8d0..b56aa46efa13 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -259,7 +259,7 @@ int ice_xmit_xdp_ring(void *data, u16 size, struct ice_ring *xdp_ring)
  */
 int ice_xmit_xdp_buff(struct xdp_buff *xdp, struct ice_ring *xdp_ring)
 {
-	struct xdp_frame *xdpf = convert_to_xdp_frame(xdp);
+	struct xdp_frame *xdpf = xdp_convert_buff_to_frame(xdp);
 
 	if (unlikely(!xdpf))
 		return ICE_XDP_CONSUMED;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 45fc7ce1a543..c878667ab581 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2215,7 +2215,7 @@ static struct sk_buff *ixgbe_run_xdp(struct ixgbe_adapter *adapter,
 	case XDP_PASS:
 		break;
 	case XDP_TX:
-		xdpf = convert_to_xdp_frame(xdp);
+		xdpf = xdp_convert_buff_to_frame(xdp);
 		if (unlikely(!xdpf)) {
 			result = IXGBE_XDP_CONSUMED;
 			break;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 86add9fbd36c..be9d2a8da515 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -107,7 +107,7 @@ static int ixgbe_run_xdp_zc(struct ixgbe_adapter *adapter,
 	case XDP_PASS:
 		break;
 	case XDP_TX:
-		xdpf = convert_to_xdp_frame(xdp);
+		xdpf = xdp_convert_buff_to_frame(xdp);
 		if (unlikely(!xdpf)) {
 			result = IXGBE_XDP_CONSUMED;
 			break;
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 37947949345c..bcd9ac444085 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2072,7 +2072,7 @@ mvneta_xdp_xmit_back(struct mvneta_port *pp, struct xdp_buff *xdp)
 	int cpu;
 	u32 ret;
 
-	xdpf = convert_to_xdp_frame(xdp);
+	xdpf = xdp_convert_buff_to_frame(xdp);
 	if (unlikely(!xdpf))
 		return MVNETA_XDP_DROPPED;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 3bea1d4be53b..c9d308e91965 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -64,7 +64,7 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 	struct xdp_frame *xdpf;
 	dma_addr_t dma_addr;
 
-	xdpf = convert_to_xdp_frame(xdp);
+	xdpf = xdp_convert_buff_to_frame(xdp);
 	if (unlikely(!xdpf))
 		return false;
 
@@ -97,10 +97,10 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 		xdpi.frame.xdpf     = xdpf;
 		xdpi.frame.dma_addr = dma_addr;
 	} else {
-		/* Driver assumes that convert_to_xdp_frame returns an xdp_frame
-		 * that points to the same memory region as the original
-		 * xdp_buff. It allows to map the memory only once and to use
-		 * the DMA_BIDIRECTIONAL mode.
+		/* Driver assumes that xdp_convert_buff_to_frame returns
+		 * an xdp_frame that points to the same memory region as
+		 * the original xdp_buff. It allows to map the memory only
+		 * once and to use the DMA_BIDIRECTIONAL mode.
 		 */
 
 		xdpi.mode = MLX5E_XDP_XMIT_MODE_PAGE;
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 68c47a8c71df..c01916cff507 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -329,7 +329,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
 
 	case XDP_TX:
 		/* Buffer ownership passes to tx on success. */
-		xdpf = convert_to_xdp_frame(&xdp);
+		xdpf = xdp_convert_buff_to_frame(&xdp);
 		err = efx_xdp_tx_buffers(efx, 1, &xdpf, true);
 		if (unlikely(err != 1)) {
 			efx_free_rx_buffers(rx_queue, rx_buf, 1);
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index e1f4be4b3d69..328bc38848bb 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -867,7 +867,7 @@ static u32 netsec_xdp_queue_one(struct netsec_priv *priv,
 static u32 netsec_xdp_xmit_back(struct netsec_priv *priv, struct xdp_buff *xdp)
 {
 	struct netsec_desc_ring *tx_ring = &priv->desc_ring[NETSEC_RING_TX];
-	struct xdp_frame *xdpf = convert_to_xdp_frame(xdp);
+	struct xdp_frame *xdpf = xdp_convert_buff_to_frame(xdp);
 	u32 ret;
 
 	if (unlikely(!xdpf))
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index d940628bff8d..a399f3659346 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -1355,7 +1355,7 @@ int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
 		ret = CPSW_XDP_PASS;
 		break;
 	case XDP_TX:
-		xdpf = convert_to_xdp_frame(xdp);
+		xdpf = xdp_convert_buff_to_frame(xdp);
 		if (unlikely(!xdpf))
 			goto drop;
 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index c54f967e2c66..f616e6a64a27 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1295,7 +1295,7 @@ static int tun_xdp_xmit(struct net_device *dev, int n,
 
 static int tun_xdp_tx(struct net_device *dev, struct xdp_buff *xdp)
 {
-	struct xdp_frame *frame = convert_to_xdp_frame(xdp);
+	struct xdp_frame *frame = xdp_convert_buff_to_frame(xdp);
 
 	if (unlikely(!frame))
 		return -EOVERFLOW;
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index fb5c17361f64..b594f03eeddb 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -541,7 +541,7 @@ static void veth_xdp_flush(struct veth_rq *rq, struct veth_xdp_tx_bq *bq)
 static int veth_xdp_tx(struct veth_rq *rq, struct xdp_buff *xdp,
 		       struct veth_xdp_tx_bq *bq)
 {
-	struct xdp_frame *frame = convert_to_xdp_frame(xdp);
+	struct xdp_frame *frame = xdp_convert_buff_to_frame(xdp);
 
 	if (unlikely(!frame))
 		return -EOVERFLOW;
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index b6951aa76295..ba38765dc490 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -703,7 +703,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 			break;
 		case XDP_TX:
 			stats->xdp_tx++;
-			xdpf = convert_to_xdp_frame(&xdp);
+			xdpf = xdp_convert_buff_to_frame(&xdp);
 			if (unlikely(!xdpf))
 				goto err_xdp;
 			err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
@@ -892,7 +892,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 			break;
 		case XDP_TX:
 			stats->xdp_tx++;
-			xdpf = convert_to_xdp_frame(&xdp);
+			xdpf = xdp_convert_buff_to_frame(&xdp);
 			if (unlikely(!xdpf))
 				goto err_xdp;
 			err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 96d4d4a9d27b..b31a81735d28 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -118,7 +118,7 @@ void xdp_convert_frame_to_buff(struct xdp_frame *frame, struct xdp_buff *xdp)
 
 /* Convert xdp_buff to xdp_frame */
 static inline
-struct xdp_frame *convert_to_xdp_frame(struct xdp_buff *xdp)
+struct xdp_frame *xdp_convert_buff_to_frame(struct xdp_buff *xdp)
 {
 	struct xdp_frame *xdp_frame;
 	int metasize;
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 8b85bfddfac7..27595fc6da56 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -621,7 +621,7 @@ int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
 {
 	struct xdp_frame *xdpf;
 
-	xdpf = convert_to_xdp_frame(xdp);
+	xdpf = xdp_convert_buff_to_frame(xdp);
 	if (unlikely(!xdpf))
 		return -EOVERFLOW;
 
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index a51d9fb7a359..f558b6ed0688 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -434,7 +434,7 @@ static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 	if (unlikely(err))
 		return err;
 
-	xdpf = convert_to_xdp_frame(xdp);
+	xdpf = xdp_convert_buff_to_frame(xdp);
 	if (unlikely(!xdpf))
 		return -EOVERFLOW;
 
-- 
2.26.2

