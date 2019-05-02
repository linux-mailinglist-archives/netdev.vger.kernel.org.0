Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8005D11595
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 10:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbfEBIjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 04:39:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:64457 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbfEBIjs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 04:39:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 01:39:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="296322403"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO VM.isw.intel.com) ([10.103.211.43])
  by orsmga004.jf.intel.com with ESMTP; 02 May 2019 01:39:44 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, brouer@redhat.com
Cc:     bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com, jakub.kicinski@netronome.com,
        xiaolong.ye@intel.com, qi.z.zhang@intel.com, maximmi@mellanox.com,
        sridhar.samudrala@intel.com, kevin.laatz@intel.com
Subject: [RFC bpf-next 2/7] net: i40e: ixgbe: tun: veth: virtio-net: centralize xdp_rxq_info and add napi id
Date:   Thu,  2 May 2019 10:39:18 +0200
Message-Id: <1556786363-28743-3-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
References: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch centralizes the xdp_rxq_info struct to only reside in a
single place and adds napi id to the information contained in it.

The reason to add napi id is that it is needed for the AF_XDP busy
poll support. The xsk code needs to know what napi id to call when it
gets a poll request on a socket that is bound to a specific queue id
on a netdev.

Previously, the xdp_req_info struct resided both in the _rx structure
and in the driver. The one in the _rx structure was used for the
XDP_SKB case and the one in the driver for the XDP_DRV case. With
busy-poll, the request to execute the napi context always comes from
the syscall path, never the driver path, so the xdp_rxq_info needs to
reside in the _rx struct for both XDP_SKB and XDP_DRV. With this,
there is no longer a need to have an extra copy in the driver that is
only valid for the XDP_DRV case. This structure has been converted to
a pointer reference to the xdp_rxq_info struct in the kernel instead,
making the code smaller and simpler.

NOTE: this patch needs to include moving over all drivers to the new
interface. I only did a handful here to demonstrate the changes. When
we agree on how to do it, I will move over all of them.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c |  2 -
 drivers/net/ethernet/intel/i40e/i40e_main.c    |  8 ++--
 drivers/net/ethernet/intel/i40e/i40e_txrx.c    | 16 +++++---
 drivers/net/ethernet/intel/i40e/i40e_txrx.h    |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c     |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h       |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c  | 36 +++++++++++-------
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c   |  2 +-
 drivers/net/tun.c                              | 14 +++----
 drivers/net/veth.c                             | 10 ++---
 drivers/net/virtio_net.c                       |  8 ++--
 include/net/xdp.h                              | 13 ++++---
 net/core/dev.c                                 | 19 +---------
 net/core/xdp.c                                 | 51 +++++++++++++++++---------
 14 files changed, 102 insertions(+), 83 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 9eaea1b..dcb5144 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -2006,8 +2006,6 @@ static int i40e_set_ringparam(struct net_device *netdev,
 			 */
 			rx_rings[i].desc = NULL;
 			rx_rings[i].rx_bi = NULL;
-			/* Clear cloned XDP RX-queue info before setup call */
-			memset(&rx_rings[i].xdp_rxq, 0, sizeof(rx_rings[i].xdp_rxq));
 			/* this is to allow wr32 to have something to write to
 			 * during early allocation of Rx buffers
 			 */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 65c2b9d..763c48c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3238,7 +3238,7 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	memset(&rx_ctx, 0, sizeof(rx_ctx));
 
 	if (ring->vsi->type == I40E_VSI_MAIN)
-		xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
+		xdp_rxq_info_unreg_mem_model(ring->netdev, ring->queue_index);
 
 	ring->xsk_umem = i40e_xsk_umem(ring);
 	if (ring->xsk_umem) {
@@ -3250,7 +3250,8 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 		 */
 		chain_len = 1;
 		ring->zca.free = i40e_zca_free;
-		ret = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
+		ret = xdp_rxq_info_reg_mem_model(ring->netdev,
+						 ring->queue_index,
 						 MEM_TYPE_ZERO_COPY,
 						 &ring->zca);
 		if (ret)
@@ -3262,7 +3263,8 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	} else {
 		ring->rx_buf_len = vsi->rx_buf_len;
 		if (ring->vsi->type == I40E_VSI_MAIN) {
-			ret = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
+			ret = xdp_rxq_info_reg_mem_model(ring->netdev,
+							 ring->queue_index,
 							 MEM_TYPE_PAGE_SHARED,
 							 NULL);
 			if (ret)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index e193170..74132ad 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1408,8 +1408,10 @@ void i40e_clean_rx_ring(struct i40e_ring *rx_ring)
 void i40e_free_rx_resources(struct i40e_ring *rx_ring)
 {
 	i40e_clean_rx_ring(rx_ring);
-	if (rx_ring->vsi->type == I40E_VSI_MAIN)
-		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
+	if (rx_ring->vsi->type == I40E_VSI_MAIN) {
+		xdp_rxq_info_unreg(rx_ring->vsi->netdev, rx_ring->queue_index);
+		rx_ring->xdp_rxq = NULL;
+	}
 	rx_ring->xdp_prog = NULL;
 	kfree(rx_ring->rx_bi);
 	rx_ring->rx_bi = NULL;
@@ -1460,15 +1462,19 @@ int i40e_setup_rx_descriptors(struct i40e_ring *rx_ring)
 
 	/* XDP RX-queue info only needed for RX rings exposed to XDP */
 	if (rx_ring->vsi->type == I40E_VSI_MAIN) {
-		err = xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
-				       rx_ring->queue_index);
+		err = xdp_rxq_info_reg(rx_ring->netdev, rx_ring->queue_index,
+				       rx_ring->q_vector->napi.napi_id);
 		if (err < 0)
 			goto err;
+
+		rx_ring->xdp_rxq = xdp_rxq_info_get(rx_ring->netdev,
+						    rx_ring->queue_index);
 	}
 
 	rx_ring->xdp_prog = rx_ring->vsi->xdp_prog;
 
 	return 0;
+
 err:
 	kfree(rx_ring->rx_bi);
 	rx_ring->rx_bi = NULL;
@@ -2335,7 +2341,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 	bool failure = false;
 	struct xdp_buff xdp;
 
-	xdp.rxq = &rx_ring->xdp_rxq;
+	xdp.rxq = rx_ring->xdp_rxq;
 
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		struct i40e_rx_buffer *rx_buffer;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index 100e92d..066f616 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -417,7 +417,7 @@ struct i40e_ring {
 					 */
 
 	struct i40e_channel *ch;
-	struct xdp_rxq_info xdp_rxq;
+	struct xdp_rxq_info *xdp_rxq;
 	struct xdp_umem *xsk_umem;
 	struct zero_copy_allocator zca; /* ZC allocator anchor */
 } ____cacheline_internodealigned_in_smp;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 1b17486..2eba2bc 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -536,7 +536,7 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 	struct sk_buff *skb;
 	struct xdp_buff xdp;
 
-	xdp.rxq = &rx_ring->xdp_rxq;
+	xdp.rxq = rx_ring->xdp_rxq;
 
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		struct i40e_rx_buffer *bi;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index 08d85e3..ea320b9 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -351,7 +351,7 @@ struct ixgbe_ring {
 		struct ixgbe_tx_queue_stats tx_stats;
 		struct ixgbe_rx_queue_stats rx_stats;
 	};
-	struct xdp_rxq_info xdp_rxq;
+	struct xdp_rxq_info *xdp_rxq;
 	struct xdp_umem *xsk_umem;
 	struct zero_copy_allocator zca; /* ZC allocator anchor */
 	u16 ring_idx;		/* {rx,tx,xdp}_ring back reference idx */
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 7b90320..3afb521 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2285,7 +2285,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 	unsigned int xdp_xmit = 0;
 	struct xdp_buff xdp;
 
-	xdp.rxq = &rx_ring->xdp_rxq;
+	xdp.rxq = rx_ring->xdp_rxq;
 
 	while (likely(total_rx_packets < budget)) {
 		union ixgbe_adv_rx_desc *rx_desc;
@@ -4066,17 +4066,19 @@ void ixgbe_configure_rx_ring(struct ixgbe_adapter *adapter,
 	u32 rxdctl;
 	u8 reg_idx = ring->reg_idx;
 
-	xdp_rxq_info_unreg_mem_model(&ring->xdp_rxq);
+	xdp_rxq_info_unreg_mem_model(ring->netdev, ring->queue_index);
 	ring->xsk_umem = ixgbe_xsk_umem(adapter, ring);
 	if (ring->xsk_umem) {
 		ring->zca.free = ixgbe_zca_free;
-		WARN_ON(xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
+		(void)xdp_rxq_info_reg_mem_model(ring->netdev,
+						   ring->queue_index,
 						   MEM_TYPE_ZERO_COPY,
-						   &ring->zca));
+						   &ring->zca);
 
 	} else {
-		WARN_ON(xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
-						   MEM_TYPE_PAGE_SHARED, NULL));
+		(void)xdp_rxq_info_reg_mem_model(ring->netdev,
+						   ring->queue_index,
+						   MEM_TYPE_PAGE_SHARED, NULL);
 	}
 
 	/* disable queue to avoid use of these values while updating state */
@@ -6514,6 +6516,7 @@ int ixgbe_setup_rx_resources(struct ixgbe_adapter *adapter,
 	struct device *dev = rx_ring->dev;
 	int orig_node = dev_to_node(dev);
 	int ring_node = NUMA_NO_NODE;
+	int err = -ENOMEM;
 	int size;
 
 	size = sizeof(struct ixgbe_rx_buffer) * rx_ring->count;
@@ -6527,6 +6530,14 @@ int ixgbe_setup_rx_resources(struct ixgbe_adapter *adapter,
 	if (!rx_ring->rx_buffer_info)
 		goto err;
 
+	/* XDP RX-queue info */
+	err = xdp_rxq_info_reg(adapter->netdev, rx_ring->queue_index,
+			       rx_ring->q_vector->napi.napi_id);
+	if (err)
+		goto err;
+	rx_ring->xdp_rxq = xdp_rxq_info_get(rx_ring->netdev,
+					    rx_ring->queue_index);
+
 	/* Round up to nearest 4K */
 	rx_ring->size = rx_ring->count * sizeof(union ixgbe_adv_rx_desc);
 	rx_ring->size = ALIGN(rx_ring->size, 4096);
@@ -6540,17 +6551,14 @@ int ixgbe_setup_rx_resources(struct ixgbe_adapter *adapter,
 	if (!rx_ring->desc)
 		rx_ring->desc = dma_alloc_coherent(dev, rx_ring->size,
 						   &rx_ring->dma, GFP_KERNEL);
-	if (!rx_ring->desc)
+	if (!rx_ring->desc) {
+		err = -ENOMEM;
 		goto err;
+	}
 
 	rx_ring->next_to_clean = 0;
 	rx_ring->next_to_use = 0;
 
-	/* XDP RX-queue info */
-	if (xdp_rxq_info_reg(&rx_ring->xdp_rxq, adapter->netdev,
-			     rx_ring->queue_index) < 0)
-		goto err;
-
 	rx_ring->xdp_prog = adapter->xdp_prog;
 
 	return 0;
@@ -6558,7 +6566,7 @@ int ixgbe_setup_rx_resources(struct ixgbe_adapter *adapter,
 	vfree(rx_ring->rx_buffer_info);
 	rx_ring->rx_buffer_info = NULL;
 	dev_err(dev, "Unable to allocate memory for the Rx descriptor ring\n");
-	return -ENOMEM;
+	return err;
 }
 
 /**
@@ -6648,7 +6656,7 @@ void ixgbe_free_rx_resources(struct ixgbe_ring *rx_ring)
 	ixgbe_clean_rx_ring(rx_ring);
 
 	rx_ring->xdp_prog = NULL;
-	xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
+	xdp_rxq_info_unreg(rx_ring->netdev, rx_ring->queue_index);
 	vfree(rx_ring->rx_buffer_info);
 	rx_ring->rx_buffer_info = NULL;
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index bfe95ce..9c10c93 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -487,7 +487,7 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 	struct sk_buff *skb;
 	struct xdp_buff xdp;
 
-	xdp.rxq = &rx_ring->xdp_rxq;
+	xdp.rxq = rx_ring->xdp_rxq;
 
 	while (likely(total_rx_packets < budget)) {
 		union ixgbe_adv_rx_desc *rx_desc;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 9d72f8c..b05c239 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -726,7 +726,7 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 				unregister_netdevice(tun->dev);
 		}
 		if (tun)
-			xdp_rxq_info_unreg(&tfile->xdp_rxq);
+			xdp_rxq_info_unreg(tun->dev, tfile->queue_index);
 		ptr_ring_cleanup(&tfile->tx_ring, tun_ptr_free);
 		sock_put(&tfile->sk);
 	}
@@ -774,13 +774,13 @@ static void tun_detach_all(struct net_device *dev)
 		tun_napi_del(tfile);
 		/* Drop read queue */
 		tun_queue_purge(tfile);
-		xdp_rxq_info_unreg(&tfile->xdp_rxq);
+		xdp_rxq_info_unreg(dev, tfile->queue_index);
 		sock_put(&tfile->sk);
 	}
 	list_for_each_entry_safe(tfile, tmp, &tun->disabled, next) {
 		tun_enable_queue(tfile);
 		tun_queue_purge(tfile);
-		xdp_rxq_info_unreg(&tfile->xdp_rxq);
+		xdp_rxq_info_unreg(dev, tfile->queue_index);
 		sock_put(&tfile->sk);
 	}
 	BUG_ON(tun->numdisabled != 0);
@@ -842,14 +842,14 @@ static int tun_attach(struct tun_struct *tun, struct file *file,
 			tfile->xdp_rxq.queue_index = tfile->queue_index;
 	} else {
 		/* Setup XDP RX-queue info, for new tfile getting attached */
-		err = xdp_rxq_info_reg(&tfile->xdp_rxq,
-				       tun->dev, tfile->queue_index);
+		err = xdp_rxq_info_reg(tun->dev, tfile->queue_index,
+				       tfile->napi.napi_id);
 		if (err < 0)
 			goto out;
-		err = xdp_rxq_info_reg_mem_model(&tfile->xdp_rxq,
+		err = xdp_rxq_info_reg_mem_model(dev, tfile->queue_index,
 						 MEM_TYPE_PAGE_SHARED, NULL);
 		if (err < 0) {
-			xdp_rxq_info_unreg(&tfile->xdp_rxq);
+			xdp_rxq_info_unreg(dev, tfile->queue_index);
 			goto out;
 		}
 		err = 0;
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 09a1433..a5bc608a 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -817,11 +817,11 @@ static int veth_enable_xdp(struct net_device *dev)
 		for (i = 0; i < dev->real_num_rx_queues; i++) {
 			struct veth_rq *rq = &priv->rq[i];
 
-			err = xdp_rxq_info_reg(&rq->xdp_rxq, dev, i);
+			err = xdp_rxq_info_reg(dev, i, rq->xdp_napi.napi_id);
 			if (err < 0)
 				goto err_rxq_reg;
 
-			err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
+			err = xdp_rxq_info_reg_mem_model(dev, i,
 							 MEM_TYPE_PAGE_SHARED,
 							 NULL);
 			if (err < 0)
@@ -841,10 +841,10 @@ static int veth_enable_xdp(struct net_device *dev)
 
 	return 0;
 err_reg_mem:
-	xdp_rxq_info_unreg(&priv->rq[i].xdp_rxq);
+	xdp_rxq_info_unreg(dev, i);
 err_rxq_reg:
 	for (i--; i >= 0; i--)
-		xdp_rxq_info_unreg(&priv->rq[i].xdp_rxq);
+		xdp_rxq_info_unreg(dev, i);
 
 	return err;
 }
@@ -861,7 +861,7 @@ static void veth_disable_xdp(struct net_device *dev)
 		struct veth_rq *rq = &priv->rq[i];
 
 		rq->xdp_rxq.mem = rq->xdp_mem;
-		xdp_rxq_info_unreg(&rq->xdp_rxq);
+		xdp_rxq_info_unreg(dev, i);
 	}
 }
 
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 559c48e6..f15b3d5 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1469,14 +1469,14 @@ static int virtnet_open(struct net_device *dev)
 			if (!try_fill_recv(vi, &vi->rq[i], GFP_KERNEL))
 				schedule_delayed_work(&vi->refill, 0);
 
-		err = xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, i);
+		err = xdp_rxq_info_reg(dev, i, vi->rq[i].napi.napi_id);
 		if (err < 0)
 			return err;
 
-		err = xdp_rxq_info_reg_mem_model(&vi->rq[i].xdp_rxq,
+		err = xdp_rxq_info_reg_mem_model(dev, i,
 						 MEM_TYPE_PAGE_SHARED, NULL);
 		if (err < 0) {
-			xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
+			xdp_rxq_info_unreg(dev, i);
 			return err;
 		}
 
@@ -1817,7 +1817,7 @@ static int virtnet_close(struct net_device *dev)
 	cancel_delayed_work_sync(&vi->refill);
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
-		xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
+		xdp_rxq_info_unreg(dev, i);
 		napi_disable(&vi->rq[i].napi);
 		virtnet_napi_tx_disable(&vi->sq[i].napi);
 	}
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 0f25b36..d5fb5c0 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -60,6 +60,7 @@ struct xdp_rxq_info {
 	struct net_device *dev;
 	u32 queue_index;
 	u32 reg_state;
+	unsigned int napi_id;
 	struct xdp_mem_info mem;
 } ____cacheline_aligned; /* perf critical, avoid false-sharing */
 
@@ -129,14 +130,16 @@ void xdp_return_frame(struct xdp_frame *xdpf);
 void xdp_return_frame_rx_napi(struct xdp_frame *xdpf);
 void xdp_return_buff(struct xdp_buff *xdp);
 
-int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
-		     struct net_device *dev, u32 queue_index);
-void xdp_rxq_info_unreg(struct xdp_rxq_info *xdp_rxq);
+void xdp_rxq_info_init(struct net_device *dev, u32 queue_index);
+int xdp_rxq_info_reg(struct net_device *dev, u32 queue_index,
+		     unsigned int napi_id);
+void xdp_rxq_info_unreg(struct net_device *net, u32 queue_index);
+struct xdp_rxq_info *xdp_rxq_info_get(struct net_device *dev, u32 queue_index);
 void xdp_rxq_info_unused(struct xdp_rxq_info *xdp_rxq);
 bool xdp_rxq_info_is_reg(struct xdp_rxq_info *xdp_rxq);
-int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
+int xdp_rxq_info_reg_mem_model(struct net_device *dev, u32 queue_index,
 			       enum xdp_mem_type type, void *allocator);
-void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq);
+void xdp_rxq_info_unreg_mem_model(struct net_device *dev, u32 queue_index);
 
 /* Drivers not supporting XDP metadata can use this helper, which
  * rejects any room expansion for metadata as a result.
diff --git a/net/core/dev.c b/net/core/dev.c
index e82fc44..0d6b3ed 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4383,6 +4383,7 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 
 	rxqueue = netif_get_rxqueue(skb);
 	xdp->rxq = &rxqueue->xdp_rxq;
+	xdp->rxq->napi_id = skb->napi_id;
 
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
@@ -8530,7 +8531,6 @@ static int netif_alloc_rx_queues(struct net_device *dev)
 	unsigned int i, count = dev->num_rx_queues;
 	struct netdev_rx_queue *rx;
 	size_t sz = count * sizeof(*rx);
-	int err = 0;
 
 	BUG_ON(count < 1);
 
@@ -8544,32 +8544,17 @@ static int netif_alloc_rx_queues(struct net_device *dev)
 		rx[i].dev = dev;
 
 		/* XDP RX-queue setup */
-		err = xdp_rxq_info_reg(&rx[i].xdp_rxq, dev, i);
-		if (err < 0)
-			goto err_rxq_info;
+		xdp_rxq_info_init(dev, i);
 	}
 	return 0;
-
-err_rxq_info:
-	/* Rollback successful reg's and free other resources */
-	while (i--)
-		xdp_rxq_info_unreg(&rx[i].xdp_rxq);
-	kvfree(dev->_rx);
-	dev->_rx = NULL;
-	return err;
 }
 
 static void netif_free_rx_queues(struct net_device *dev)
 {
-	unsigned int i, count = dev->num_rx_queues;
-
 	/* netif_alloc_rx_queues alloc failed, resources have been unreg'ed */
 	if (!dev->_rx)
 		return;
 
-	for (i = 0; i < count; i++)
-		xdp_rxq_info_unreg(&dev->_rx[i].xdp_rxq);
-
 	kvfree(dev->_rx);
 }
 
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 4b2b194..ed691f9 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -94,8 +94,9 @@ static void __xdp_mem_allocator_rcu_free(struct rcu_head *rcu)
 	kfree(xa);
 }
 
-void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
+void xdp_rxq_info_unreg_mem_model(struct net_device *dev, u32 queue_index)
 {
+	struct xdp_rxq_info *xdp_rxq = &dev->_rx[queue_index].xdp_rxq;
 	struct xdp_mem_allocator *xa;
 	int id = xdp_rxq->mem.id;
 
@@ -122,18 +123,33 @@ void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
 }
 EXPORT_SYMBOL_GPL(xdp_rxq_info_unreg_mem_model);
 
-void xdp_rxq_info_unreg(struct xdp_rxq_info *xdp_rxq)
+static void _xdp_rxq_info_init(struct xdp_rxq_info *xdp_rxq)
 {
+	memset(xdp_rxq, 0, sizeof(*xdp_rxq));
+}
+
+void xdp_rxq_info_init(struct net_device *dev, u32 queue_index)
+{
+	struct xdp_rxq_info *xdp_rxq = &dev->_rx[queue_index].xdp_rxq;
+
+	_xdp_rxq_info_init(xdp_rxq);
+	xdp_rxq->dev = dev;
+	xdp_rxq->queue_index = queue_index;
+}
+
+void xdp_rxq_info_unreg(struct net_device *dev, u32 queue_index)
+{
+	struct xdp_rxq_info *xdp_rxq = &dev->_rx[queue_index].xdp_rxq;
+
 	/* Simplify driver cleanup code paths, allow unreg "unused" */
 	if (xdp_rxq->reg_state == REG_STATE_UNUSED)
 		return;
 
 	WARN(!(xdp_rxq->reg_state == REG_STATE_REGISTERED), "Driver BUG");
 
-	xdp_rxq_info_unreg_mem_model(xdp_rxq);
+	xdp_rxq_info_unreg_mem_model(dev, queue_index);
 
 	xdp_rxq->reg_state = REG_STATE_UNREGISTERED;
-	xdp_rxq->dev = NULL;
 
 	/* Reset mem info to defaults */
 	xdp_rxq->mem.id = 0;
@@ -141,15 +157,12 @@ void xdp_rxq_info_unreg(struct xdp_rxq_info *xdp_rxq)
 }
 EXPORT_SYMBOL_GPL(xdp_rxq_info_unreg);
 
-static void xdp_rxq_info_init(struct xdp_rxq_info *xdp_rxq)
-{
-	memset(xdp_rxq, 0, sizeof(*xdp_rxq));
-}
-
 /* Returns 0 on success, negative on failure */
-int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
-		     struct net_device *dev, u32 queue_index)
+int xdp_rxq_info_reg(struct net_device *dev, u32 queue_index,
+		     unsigned int napi_id)
 {
+	struct xdp_rxq_info *xdp_rxq = &dev->_rx[queue_index].xdp_rxq;
+
 	if (xdp_rxq->reg_state == REG_STATE_UNUSED) {
 		WARN(1, "Driver promised not to register this");
 		return -EINVAL;
@@ -157,7 +170,7 @@ int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
 
 	if (xdp_rxq->reg_state == REG_STATE_REGISTERED) {
 		WARN(1, "Missing unregister, handled but fix driver");
-		xdp_rxq_info_unreg(xdp_rxq);
+		xdp_rxq_info_unreg(dev, queue_index);
 	}
 
 	if (!dev) {
@@ -166,15 +179,18 @@ int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
 	}
 
 	/* State either UNREGISTERED or NEW */
-	xdp_rxq_info_init(xdp_rxq);
-	xdp_rxq->dev = dev;
-	xdp_rxq->queue_index = queue_index;
-
+	xdp_rxq->napi_id = napi_id;
 	xdp_rxq->reg_state = REG_STATE_REGISTERED;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xdp_rxq_info_reg);
 
+struct xdp_rxq_info *xdp_rxq_info_get(struct net_device *dev, u32 queue_index)
+{
+	return &dev->_rx[queue_index].xdp_rxq;
+}
+EXPORT_SYMBOL_GPL(xdp_rxq_info_get);
+
 void xdp_rxq_info_unused(struct xdp_rxq_info *xdp_rxq)
 {
 	xdp_rxq->reg_state = REG_STATE_UNUSED;
@@ -249,9 +265,10 @@ static bool __is_supported_mem_type(enum xdp_mem_type type)
 	return true;
 }
 
-int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
+int xdp_rxq_info_reg_mem_model(struct net_device *dev, u32 queue_index,
 			       enum xdp_mem_type type, void *allocator)
 {
+	struct xdp_rxq_info *xdp_rxq = &dev->_rx[queue_index].xdp_rxq;
 	struct xdp_mem_allocator *xdp_alloc;
 	gfp_t gfp = GFP_KERNEL;
 	int id, errno, ret;
-- 
2.7.4

