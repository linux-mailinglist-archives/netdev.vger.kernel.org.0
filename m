Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F55E45A923
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbhKWQrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:47:42 -0500
Received: from mga04.intel.com ([192.55.52.120]:49206 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239602AbhKWQrY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:47:24 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="233778755"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="233778755"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 08:42:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="674540196"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 23 Nov 2021 08:42:00 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANGf4X0016784;
        Tue, 23 Nov 2021 16:41:57 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2 net-next 22/26] igb: add XDP generic per-channel statistics
Date:   Tue, 23 Nov 2021 17:39:51 +0100
Message-Id: <20211123163955.154512-23-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123163955.154512-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make igb driver collect and provide all generic XDP counters.
Unfortunately, igb has an unified ice_ring structure for both Rx
and Tx, so embedding xdp_drv_rx_stats would bloat it for no good.
Store XDP stats in a separate array with a lifetime of a netdev.
Unlike other Intel drivers, igb has no support for XSK, so we can't
use full xdp_drv_stats here. IGB_MAX_ALLOC_QUEUES is introduced
purely for convenience to not hardcode 16 twice more.
Reuse previously introduced helpers where possible. Performance
wavering from incrementing a bunch of counters on hotpath is around
stddev at [64 ... 1532] frame sizes.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
---
 drivers/net/ethernet/intel/igb/igb.h      |  14 ++-
 drivers/net/ethernet/intel/igb/igb_main.c | 102 ++++++++++++++++++++--
 2 files changed, 105 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb.h b/drivers/net/ethernet/intel/igb/igb.h
index 2d3daf022651..a6c5355b82fc 100644
--- a/drivers/net/ethernet/intel/igb/igb.h
+++ b/drivers/net/ethernet/intel/igb/igb.h
@@ -303,6 +303,11 @@ struct igb_rx_queue_stats {
 	u64 alloc_failed;
 };

+struct igb_xdp_stats {
+	struct xdp_rx_drv_stats rx;
+	struct xdp_tx_drv_stats tx;
+} ____cacheline_aligned;
+
 struct igb_ring_container {
 	struct igb_ring *ring;		/* pointer to linked list of rings */
 	unsigned int total_bytes;	/* total bytes processed this int */
@@ -356,6 +361,7 @@ struct igb_ring {
 			struct u64_stats_sync rx_syncp;
 		};
 	};
+	struct igb_xdp_stats *xdp_stats;
 	struct xdp_rxq_info xdp_rxq;
 } ____cacheline_internodealigned_in_smp;

@@ -531,6 +537,8 @@ struct igb_mac_addr {
 #define IGB_MAC_STATE_SRC_ADDR	0x4
 #define IGB_MAC_STATE_QUEUE_STEERING 0x8

+#define IGB_MAX_ALLOC_QUEUES	16
+
 /* board specific private data structure */
 struct igb_adapter {
 	unsigned long active_vlans[BITS_TO_LONGS(VLAN_N_VID)];
@@ -554,11 +562,11 @@ struct igb_adapter {
 	u16 tx_work_limit;
 	u32 tx_timeout_count;
 	int num_tx_queues;
-	struct igb_ring *tx_ring[16];
+	struct igb_ring *tx_ring[IGB_MAX_ALLOC_QUEUES];

 	/* RX */
 	int num_rx_queues;
-	struct igb_ring *rx_ring[16];
+	struct igb_ring *rx_ring[IGB_MAX_ALLOC_QUEUES];

 	u32 max_frame_size;
 	u32 min_frame_size;
@@ -664,6 +672,8 @@ struct igb_adapter {
 	struct igb_mac_addr *mac_table;
 	struct vf_mac_filter vf_macs;
 	struct vf_mac_filter *vf_mac_list;
+
+	struct igb_xdp_stats *xdp_stats;
 };

 /* flags controlling PTP/1588 function */
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 18a019a47182..c4e1ea9bc4a8 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -1266,6 +1266,7 @@ static int igb_alloc_q_vector(struct igb_adapter *adapter,

 		u64_stats_init(&ring->tx_syncp);
 		u64_stats_init(&ring->tx_syncp2);
+		ring->xdp_stats = adapter->xdp_stats + txr_idx;

 		/* assign ring to adapter */
 		adapter->tx_ring[txr_idx] = ring;
@@ -1300,6 +1301,7 @@ static int igb_alloc_q_vector(struct igb_adapter *adapter,
 		ring->queue_index = rxr_idx;

 		u64_stats_init(&ring->rx_syncp);
+		ring->xdp_stats = adapter->xdp_stats + rxr_idx;

 		/* assign ring to adapter */
 		adapter->rx_ring[rxr_idx] = ring;
@@ -2973,6 +2975,9 @@ static int igb_xdp_xmit(struct net_device *dev, int n,
 		nxmit++;
 	}

+	if (unlikely(nxmit < n))
+		xdp_update_tx_drv_err(&tx_ring->xdp_stats->tx, n - nxmit);
+
 	__netif_tx_unlock(nq);

 	if (unlikely(flags & XDP_XMIT_FLUSH))
@@ -2981,6 +2986,42 @@ static int igb_xdp_xmit(struct net_device *dev, int n,
 	return nxmit;
 }

+static int igb_get_xdp_stats_nch(const struct net_device *dev, u32 attr_id)
+{
+	switch (attr_id) {
+	case IFLA_XDP_XSTATS_TYPE_XDP:
+		return IGB_MAX_ALLOC_QUEUES;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int igb_get_xdp_stats(const struct net_device *dev, u32 attr_id,
+			     void *attr_data)
+{
+	const struct igb_adapter *adapter = netdev_priv(dev);
+	const struct igb_xdp_stats *drv_iter = adapter->xdp_stats;
+	struct ifla_xdp_stats *iter = attr_data;
+	u32 i;
+
+	switch (attr_id) {
+	case IFLA_XDP_XSTATS_TYPE_XDP:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	for (i = 0; i < IGB_MAX_ALLOC_QUEUES; i++) {
+		xdp_fetch_rx_drv_stats(iter, &drv_iter->rx);
+		xdp_fetch_tx_drv_stats(iter, &drv_iter->tx);
+
+		drv_iter++;
+		iter++;
+	}
+
+	return 0;
+}
+
 static const struct net_device_ops igb_netdev_ops = {
 	.ndo_open		= igb_open,
 	.ndo_stop		= igb_close,
@@ -3007,6 +3048,8 @@ static const struct net_device_ops igb_netdev_ops = {
 	.ndo_setup_tc		= igb_setup_tc,
 	.ndo_bpf		= igb_xdp,
 	.ndo_xdp_xmit		= igb_xdp_xmit,
+	.ndo_get_xdp_stats_nch	= igb_get_xdp_stats_nch,
+	.ndo_get_xdp_stats	= igb_get_xdp_stats,
 };

 /**
@@ -3620,6 +3663,7 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (hw->flash_address)
 		iounmap(hw->flash_address);
 err_sw_init:
+	kfree(adapter->xdp_stats);
 	kfree(adapter->mac_table);
 	kfree(adapter->shadow_vfta);
 	igb_clear_interrupt_scheme(adapter);
@@ -3833,6 +3877,7 @@ static void igb_remove(struct pci_dev *pdev)
 		iounmap(hw->flash_address);
 	pci_release_mem_regions(pdev);

+	kfree(adapter->xdp_stats);
 	kfree(adapter->mac_table);
 	kfree(adapter->shadow_vfta);
 	free_netdev(netdev);
@@ -3962,6 +4007,7 @@ static int igb_sw_init(struct igb_adapter *adapter)
 	struct e1000_hw *hw = &adapter->hw;
 	struct net_device *netdev = adapter->netdev;
 	struct pci_dev *pdev = adapter->pdev;
+	u32 i;

 	pci_read_config_word(pdev, PCI_COMMAND, &hw->bus.pci_cmd_word);

@@ -4019,6 +4065,19 @@ static int igb_sw_init(struct igb_adapter *adapter)
 	if (!adapter->shadow_vfta)
 		return -ENOMEM;

+	adapter->xdp_stats = kcalloc(IGB_MAX_ALLOC_QUEUES,
+				     sizeof(*adapter->xdp_stats),
+				     GFP_KERNEL);
+	if (!adapter->xdp_stats)
+		return -ENOMEM;
+
+	for (i = 0; i < IGB_MAX_ALLOC_QUEUES; i++) {
+		struct igb_xdp_stats *xdp_stats = adapter->xdp_stats + i;
+
+		xdp_init_rx_drv_stats(&xdp_stats->rx);
+		xdp_init_tx_drv_stats(&xdp_stats->tx);
+	}
+
 	/* This call may decrease the number of queues */
 	if (igb_init_interrupt_scheme(adapter, true)) {
 		dev_err(&pdev->dev, "Unable to allocate memory for queues\n");
@@ -6264,8 +6323,10 @@ int igb_xmit_xdp_ring(struct igb_adapter *adapter,

 	len = xdpf->len;

-	if (unlikely(!igb_desc_unused(tx_ring)))
+	if (unlikely(!igb_desc_unused(tx_ring))) {
+		xdp_update_tx_drv_full(&tx_ring->xdp_stats->tx);
 		return IGB_XDP_CONSUMED;
+	}

 	dma = dma_map_single(tx_ring->dev, xdpf->data, len, DMA_TO_DEVICE);
 	if (dma_mapping_error(tx_ring->dev, dma))
@@ -8045,6 +8106,7 @@ static bool igb_clean_tx_irq(struct igb_q_vector *q_vector, int napi_budget)
 	unsigned int total_bytes = 0, total_packets = 0;
 	unsigned int budget = q_vector->tx.work_limit;
 	unsigned int i = tx_ring->next_to_clean;
+	u32 xdp_packets = 0, xdp_bytes = 0;

 	if (test_bit(__IGB_DOWN, &adapter->state))
 		return true;
@@ -8075,10 +8137,13 @@ static bool igb_clean_tx_irq(struct igb_q_vector *q_vector, int napi_budget)
 		total_packets += tx_buffer->gso_segs;

 		/* free the skb */
-		if (tx_buffer->type == IGB_TYPE_SKB)
+		if (tx_buffer->type == IGB_TYPE_SKB) {
 			napi_consume_skb(tx_buffer->skb, napi_budget);
-		else
+		} else {
 			xdp_return_frame(tx_buffer->xdpf);
+			xdp_bytes += tx_buffer->bytecount;
+			xdp_packets++;
+		}

 		/* unmap skb header data */
 		dma_unmap_single(tx_ring->dev,
@@ -8135,6 +8200,8 @@ static bool igb_clean_tx_irq(struct igb_q_vector *q_vector, int napi_budget)
 	tx_ring->tx_stats.bytes += total_bytes;
 	tx_ring->tx_stats.packets += total_packets;
 	u64_stats_update_end(&tx_ring->tx_syncp);
+	xdp_update_tx_drv_stats(&tx_ring->xdp_stats->tx, xdp_packets,
+				xdp_bytes);
 	q_vector->tx.total_bytes += total_bytes;
 	q_vector->tx.total_packets += total_packets;

@@ -8393,7 +8460,8 @@ static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,

 static struct sk_buff *igb_run_xdp(struct igb_adapter *adapter,
 				   struct igb_ring *rx_ring,
-				   struct xdp_buff *xdp)
+				   struct xdp_buff *xdp,
+				   struct xdp_rx_drv_stats_local *lrstats)
 {
 	int err, result = IGB_XDP_PASS;
 	struct bpf_prog *xdp_prog;
@@ -8404,32 +8472,46 @@ static struct sk_buff *igb_run_xdp(struct igb_adapter *adapter,
 	if (!xdp_prog)
 		goto xdp_out;

+	lrstats->bytes += xdp->data_end - xdp->data;
+	lrstats->packets++;
+
 	prefetchw(xdp->data_hard_start); /* xdp_frame write */

 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 	switch (act) {
 	case XDP_PASS:
+		lrstats->pass++;
 		break;
 	case XDP_TX:
 		result = igb_xdp_xmit_back(adapter, xdp);
-		if (result == IGB_XDP_CONSUMED)
+		if (result == IGB_XDP_CONSUMED) {
+			lrstats->tx_errors++;
 			goto out_failure;
+		}
+		lrstats->tx++;
 		break;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(adapter->netdev, xdp, xdp_prog);
-		if (err)
+		if (err) {
+			lrstats->redirect_errors++;
 			goto out_failure;
+		}
 		result = IGB_XDP_REDIR;
+		lrstats->redirect++;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
-		fallthrough;
+		lrstats->invalid++;
+		goto out_failure;
 	case XDP_ABORTED:
+		lrstats->aborted++;
 out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
-		fallthrough;
+		result = IGB_XDP_CONSUMED;
+		break;
 	case XDP_DROP:
 		result = IGB_XDP_CONSUMED;
+		lrstats->drop++;
 		break;
 	}
 xdp_out:
@@ -8677,6 +8759,7 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 {
 	struct igb_adapter *adapter = q_vector->adapter;
 	struct igb_ring *rx_ring = q_vector->rx.ring;
+	struct xdp_rx_drv_stats_local lrstats = { };
 	struct sk_buff *skb = rx_ring->skb;
 	unsigned int total_bytes = 0, total_packets = 0;
 	u16 cleaned_count = igb_desc_unused(rx_ring);
@@ -8740,7 +8823,7 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 			/* At larger PAGE_SIZE, frame_sz depend on len size */
 			xdp.frame_sz = igb_rx_frame_truesize(rx_ring, size);
 #endif
-			skb = igb_run_xdp(adapter, rx_ring, &xdp);
+			skb = igb_run_xdp(adapter, rx_ring, &xdp, &lrstats);
 		}

 		if (IS_ERR(skb)) {
@@ -8814,6 +8897,7 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 	rx_ring->rx_stats.packets += total_packets;
 	rx_ring->rx_stats.bytes += total_bytes;
 	u64_stats_update_end(&rx_ring->rx_syncp);
+	xdp_update_rx_drv_stats(&rx_ring->xdp_stats->rx, &lrstats);
 	q_vector->rx.total_packets += total_packets;
 	q_vector->rx.total_bytes += total_bytes;

--
2.33.1

