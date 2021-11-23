Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532BA45A916
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239365AbhKWQq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:46:28 -0500
Received: from mga03.intel.com ([134.134.136.65]:56569 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239320AbhKWQph (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:45:37 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="235006814"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="235006814"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 08:42:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="606869360"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga004.jf.intel.com with ESMTP; 23 Nov 2021 08:41:59 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANGf4Wx016784;
        Tue, 23 Nov 2021 16:41:55 GMT
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
Subject: [PATCH v2 net-next 21/26] ice: add XDP and XSK generic per-channel statistics
Date:   Tue, 23 Nov 2021 17:39:50 +0100
Message-Id: <20211123163955.154512-22-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123163955.154512-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make ice driver collect and provide all generic XDP/XSK counters.
Unfortunately, XDP rings have a lifetime of an XDP prog, and all
ring stats structures get wiped on xsk_pool attach/detach, so
store them in a separate array with a lifetime of a VSI. New
alloc_xdp_stats field is used to calculate the maximum possible
number of XDP-enabled queues just once and refer to it later.
Reuse all previously introduced helpers and
xdp_get_drv_stats_generic(). Performance wavering from incrementing
a bunch of counters on hotpath is around stddev at [64 ... 1532]
frame sizes.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  2 +
 drivers/net/ethernet/intel/ice/ice_lib.c      | 21 ++++++++
 drivers/net/ethernet/intel/ice/ice_main.c     | 17 +++++++
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 33 +++++++++---
 drivers/net/ethernet/intel/ice/ice_txrx.h     | 12 +++--
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  3 ++
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 51 ++++++++++++++-----
 7 files changed, 118 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index b67ad51cbcc9..6cef8b4e887f 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -387,8 +387,10 @@ struct ice_vsi {
 	struct ice_tc_cfg tc_cfg;
 	struct bpf_prog *xdp_prog;
 	struct ice_tx_ring **xdp_rings;	 /* XDP ring array */
+	struct xdp_drv_stats *xdp_stats; /* XDP stats array */
 	unsigned long *af_xdp_zc_qps;	 /* tracks AF_XDP ZC enabled qps */
 	u16 num_xdp_txq;		 /* Used XDP queues */
+	u16 alloc_xdp_stats;		 /* Length of xdp_stats array */
 	u8 xdp_mapping_mode;		 /* ICE_MAP_MODE_[CONTIG|SCATTER] */

 	struct net_device **target_netdevs;
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 40562600a8cf..934152216df5 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -73,6 +73,7 @@ static int ice_vsi_alloc_arrays(struct ice_vsi *vsi)
 {
 	struct ice_pf *pf = vsi->back;
 	struct device *dev;
+	u32 i;

 	dev = ice_pf_to_dev(pf);
 	if (vsi->type == ICE_VSI_CHNL)
@@ -115,8 +116,23 @@ static int ice_vsi_alloc_arrays(struct ice_vsi *vsi)
 	if (!vsi->af_xdp_zc_qps)
 		goto err_zc_qps;

+	vsi->alloc_xdp_stats = max_t(u16, vsi->alloc_rxq, num_possible_cpus());
+
+	vsi->xdp_stats = kcalloc(vsi->alloc_xdp_stats, sizeof(*vsi->xdp_stats),
+				 GFP_KERNEL);
+	if (!vsi->xdp_stats)
+		goto err_xdp_stats;
+
+	for (i = 0; i < vsi->alloc_xdp_stats; i++)
+		xdp_init_drv_stats(vsi->xdp_stats + i);
+
 	return 0;

+err_xdp_stats:
+	vsi->alloc_xdp_stats = 0;
+
+	bitmap_free(vsi->af_xdp_zc_qps);
+	vsi->af_xdp_zc_qps = NULL;
 err_zc_qps:
 	devm_kfree(dev, vsi->q_vectors);
 err_vectors:
@@ -317,6 +333,10 @@ static void ice_vsi_free_arrays(struct ice_vsi *vsi)

 	dev = ice_pf_to_dev(pf);

+	kfree(vsi->xdp_stats);
+	vsi->xdp_stats = NULL;
+	vsi->alloc_xdp_stats = 0;
+
 	if (vsi->af_xdp_zc_qps) {
 		bitmap_free(vsi->af_xdp_zc_qps);
 		vsi->af_xdp_zc_qps = NULL;
@@ -1422,6 +1442,7 @@ static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
 		ring->netdev = vsi->netdev;
 		ring->dev = dev;
 		ring->count = vsi->num_rx_desc;
+		ring->xdp_stats = vsi->xdp_stats + i;
 		WRITE_ONCE(vsi->rx_rings[i], ring);
 	}

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index f2a5f2f965d1..94d0bf440a49 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2481,6 +2481,7 @@ static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
 		xdp_ring->next_rs = ICE_TX_THRESH - 1;
 		xdp_ring->dev = dev;
 		xdp_ring->count = vsi->num_tx_desc;
+		xdp_ring->xdp_stats = vsi->xdp_stats + i;
 		WRITE_ONCE(vsi->xdp_rings[i], xdp_ring);
 		if (ice_setup_tx_ring(xdp_ring))
 			goto free_xdp_rings;
@@ -2837,6 +2838,19 @@ static int ice_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	}
 }

+static int ice_get_xdp_stats_nch(const struct net_device *dev, u32 attr_id)
+{
+	const struct ice_netdev_priv *np = netdev_priv(dev);
+
+	switch (attr_id) {
+	case IFLA_XDP_XSTATS_TYPE_XDP:
+	case IFLA_XDP_XSTATS_TYPE_XSK:
+		return np->vsi->alloc_xdp_stats;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 /**
  * ice_ena_misc_vector - enable the non-queue interrupts
  * @pf: board private structure
@@ -3280,6 +3294,7 @@ static int ice_cfg_netdev(struct ice_vsi *vsi)
 	ice_set_netdev_features(netdev);

 	ice_set_ops(netdev);
+	netdev->xstats = vsi->xdp_stats;

 	if (vsi->type == ICE_VSI_PF) {
 		SET_NETDEV_DEV(netdev, ice_pf_to_dev(vsi->back));
@@ -8608,4 +8623,6 @@ static const struct net_device_ops ice_netdev_ops = {
 	.ndo_bpf = ice_xdp,
 	.ndo_xdp_xmit = ice_xdp_xmit,
 	.ndo_xsk_wakeup = ice_xsk_wakeup,
+	.ndo_get_xdp_stats_nch = ice_get_xdp_stats_nch,
+	.ndo_get_xdp_stats = xdp_get_drv_stats_generic,
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index bc3ba19dc88f..d32d6f2975b5 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -532,19 +532,25 @@ ice_rx_frame_truesize(struct ice_rx_ring *rx_ring, unsigned int __maybe_unused s
  * @xdp: xdp_buff used as input to the XDP program
  * @xdp_prog: XDP program to run
  * @xdp_ring: ring to be used for XDP_TX action
+ * @lrstats: onstack Rx XDP stats
  *
  * Returns any of ICE_XDP_{PASS, CONSUMED, TX, REDIR}
  */
 static int
 ice_run_xdp(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
-	    struct bpf_prog *xdp_prog, struct ice_tx_ring *xdp_ring)
+	    struct bpf_prog *xdp_prog, struct ice_tx_ring *xdp_ring,
+	    struct xdp_rx_drv_stats_local *lrstats)
 {
 	int err;
 	u32 act;

+	lrstats->bytes += xdp->data_end - xdp->data;
+	lrstats->packets++;
+
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 	switch (act) {
 	case XDP_PASS:
+		lrstats->pass++;
 		return ICE_XDP_PASS;
 	case XDP_TX:
 		if (static_branch_unlikely(&ice_xdp_locking_key))
@@ -552,22 +558,31 @@ ice_run_xdp(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
 		err = ice_xmit_xdp_ring(xdp->data, xdp->data_end - xdp->data, xdp_ring);
 		if (static_branch_unlikely(&ice_xdp_locking_key))
 			spin_unlock(&xdp_ring->tx_lock);
-		if (err == ICE_XDP_CONSUMED)
+		if (err == ICE_XDP_CONSUMED) {
+			lrstats->tx_errors++;
 			goto out_failure;
+		}
+		lrstats->tx++;
 		return err;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		if (err)
+		if (err) {
+			lrstats->redirect_errors++;
 			goto out_failure;
+		}
+		lrstats->redirect++;
 		return ICE_XDP_REDIR;
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
+		return ICE_XDP_CONSUMED;
 	case XDP_DROP:
+		lrstats->drop++;
 		return ICE_XDP_CONSUMED;
 	}
 }
@@ -627,6 +642,9 @@ ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 	if (static_branch_unlikely(&ice_xdp_locking_key))
 		spin_unlock(&xdp_ring->tx_lock);

+	if (unlikely(nxmit < n))
+		xdp_update_tx_drv_err(&xdp_ring->xdp_stats->xdp_tx, n - nxmit);
+
 	return nxmit;
 }

@@ -1089,6 +1107,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 {
 	unsigned int total_rx_bytes = 0, total_rx_pkts = 0, frame_sz = 0;
 	u16 cleaned_count = ICE_DESC_UNUSED(rx_ring);
+	struct xdp_rx_drv_stats_local lrstats = { };
 	unsigned int offset = rx_ring->rx_offset;
 	struct ice_tx_ring *xdp_ring = NULL;
 	unsigned int xdp_res, xdp_xmit = 0;
@@ -1173,7 +1192,8 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 		if (!xdp_prog)
 			goto construct_skb;

-		xdp_res = ice_run_xdp(rx_ring, &xdp, xdp_prog, xdp_ring);
+		xdp_res = ice_run_xdp(rx_ring, &xdp, xdp_prog, xdp_ring,
+				      &lrstats);
 		if (!xdp_res)
 			goto construct_skb;
 		if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR)) {
@@ -1254,6 +1274,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 	rx_ring->skb = skb;

 	ice_update_rx_ring_stats(rx_ring, total_rx_pkts, total_rx_bytes);
+	xdp_update_rx_drv_stats(&rx_ring->xdp_stats->xdp_rx, &lrstats);

 	/* guarantee a trip back through this routine if there was a failure */
 	return failure ? budget : (int)total_rx_pkts;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index c56dd1749903..c54be60c3479 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -284,9 +284,9 @@ struct ice_rx_ring {
 	struct ice_rxq_stats rx_stats;
 	struct ice_q_stats	stats;
 	struct u64_stats_sync syncp;
+	struct xdp_drv_stats *xdp_stats;

-	struct rcu_head rcu;		/* to avoid race on free */
-	/* CL4 - 3rd cacheline starts here */
+	/* CL4 - 4rd cacheline starts here */
 	struct ice_channel *ch;
 	struct bpf_prog *xdp_prog;
 	struct ice_tx_ring *xdp_ring;
@@ -298,6 +298,9 @@ struct ice_rx_ring {
 	u8 dcb_tc;			/* Traffic class of ring */
 	u8 ptp_rx;
 	u8 flags;
+
+	/* CL5 - 5th cacheline starts here */
+	struct rcu_head rcu;		/* to avoid race on free */
 } ____cacheline_internodealigned_in_smp;

 struct ice_tx_ring {
@@ -324,13 +327,16 @@ struct ice_tx_ring {
 	/* stats structs */
 	struct ice_q_stats	stats;
 	struct u64_stats_sync syncp;
-	struct ice_txq_stats tx_stats;
+	struct xdp_drv_stats *xdp_stats;

 	/* CL3 - 3rd cacheline starts here */
+	struct ice_txq_stats tx_stats;
 	struct rcu_head rcu;		/* to avoid race on free */
 	DECLARE_BITMAP(xps_state, ICE_TX_NBITS);	/* XPS Config State */
 	struct ice_channel *ch;
 	struct ice_ptp_tx *tx_tstamps;
+
+	/* CL4 - 4th cacheline starts here */
 	spinlock_t tx_lock;
 	u32 txq_teid;			/* Added Tx queue TEID */
 #define ICE_TX_FLAGS_RING_XDP		BIT(0)
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 1dd7e84f41f8..7dc287bc3a1a 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -258,6 +258,8 @@ static void ice_clean_xdp_irq(struct ice_tx_ring *xdp_ring)
 		xdp_ring->next_dd = ICE_TX_THRESH - 1;
 	xdp_ring->next_to_clean = ntc;
 	ice_update_tx_ring_stats(xdp_ring, total_pkts, total_bytes);
+	xdp_update_tx_drv_stats(&xdp_ring->xdp_stats->xdp_tx, total_pkts,
+				total_bytes);
 }

 /**
@@ -277,6 +279,7 @@ int ice_xmit_xdp_ring(void *data, u16 size, struct ice_tx_ring *xdp_ring)
 		ice_clean_xdp_irq(xdp_ring);

 	if (!unlikely(ICE_DESC_UNUSED(xdp_ring))) {
+		xdp_update_tx_drv_full(&xdp_ring->xdp_stats->xdp_tx);
 		xdp_ring->tx_stats.tx_busy++;
 		return ICE_XDP_CONSUMED;
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index ff55cb415b11..62ef47a38d93 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -454,42 +454,58 @@ ice_construct_skb_zc(struct ice_rx_ring *rx_ring, struct xdp_buff **xdp_arr)
  * @xdp: xdp_buff used as input to the XDP program
  * @xdp_prog: XDP program to run
  * @xdp_ring: ring to be used for XDP_TX action
+ * @lrstats: onstack Rx XDP stats
  *
  * Returns any of ICE_XDP_{PASS, CONSUMED, TX, REDIR}
  */
 static int
 ice_run_xdp_zc(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
-	       struct bpf_prog *xdp_prog, struct ice_tx_ring *xdp_ring)
+	       struct bpf_prog *xdp_prog, struct ice_tx_ring *xdp_ring,
+	       struct xdp_rx_drv_stats_local *lrstats)
 {
 	int err, result = ICE_XDP_PASS;
 	u32 act;

+	lrstats->bytes += xdp->data_end - xdp->data;
+	lrstats->packets++;
+
 	act = bpf_prog_run_xdp(xdp_prog, xdp);

 	if (likely(act == XDP_REDIRECT)) {
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
-		if (err)
+		if (err) {
+			lrstats->redirect_errors++;
 			goto out_failure;
+		}
+		lrstats->redirect++;
 		return ICE_XDP_REDIR;
 	}

 	switch (act) {
 	case XDP_PASS:
+		lrstats->pass++;
 		break;
 	case XDP_TX:
 		result = ice_xmit_xdp_buff(xdp, xdp_ring);
-		if (result == ICE_XDP_CONSUMED)
+		if (result == ICE_XDP_CONSUMED) {
+			lrstats->tx_errors++;
 			goto out_failure;
+		}
+		lrstats->tx++;
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
+		result = ICE_XDP_CONSUMED;
+		break;
 	case XDP_DROP:
 		result = ICE_XDP_CONSUMED;
+		lrstats->drop++;
 		break;
 	}

@@ -507,6 +523,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 {
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
 	u16 cleaned_count = ICE_DESC_UNUSED(rx_ring);
+	struct xdp_rx_drv_stats_local lrstats = { };
 	struct ice_tx_ring *xdp_ring;
 	unsigned int xdp_xmit = 0;
 	struct bpf_prog *xdp_prog;
@@ -548,7 +565,8 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 		xsk_buff_set_size(*xdp, size);
 		xsk_buff_dma_sync_for_cpu(*xdp, rx_ring->xsk_pool);

-		xdp_res = ice_run_xdp_zc(rx_ring, *xdp, xdp_prog, xdp_ring);
+		xdp_res = ice_run_xdp_zc(rx_ring, *xdp, xdp_prog, xdp_ring,
+					 &lrstats);
 		if (xdp_res) {
 			if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR))
 				xdp_xmit |= xdp_res;
@@ -598,6 +616,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)

 	ice_finalize_xdp_rx(xdp_ring, xdp_xmit);
 	ice_update_rx_ring_stats(rx_ring, total_rx_packets, total_rx_bytes);
+	xdp_update_rx_drv_stats(&rx_ring->xdp_stats->xsk_rx, &lrstats);

 	if (xsk_uses_need_wakeup(rx_ring->xsk_pool)) {
 		if (failure || rx_ring->next_to_clean == rx_ring->next_to_use)
@@ -629,6 +648,7 @@ static bool ice_xmit_zc(struct ice_tx_ring *xdp_ring, int budget)
 		struct ice_tx_buf *tx_buf;

 		if (unlikely(!ICE_DESC_UNUSED(xdp_ring))) {
+			xdp_update_tx_drv_full(&xdp_ring->xdp_stats->xsk_tx);
 			xdp_ring->tx_stats.tx_busy++;
 			work_done = false;
 			break;
@@ -686,11 +706,11 @@ ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
  */
 bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring, int budget)
 {
-	int total_packets = 0, total_bytes = 0;
 	s16 ntc = xdp_ring->next_to_clean;
+	u32 xdp_frames = 0, xdp_bytes = 0;
+	u32 xsk_frames = 0, xsk_bytes = 0;
 	struct ice_tx_desc *tx_desc;
 	struct ice_tx_buf *tx_buf;
-	u32 xsk_frames = 0;
 	bool xmit_done;

 	tx_desc = ICE_TX_DESC(xdp_ring, ntc);
@@ -702,13 +722,14 @@ bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring, int budget)
 		      cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)))
 			break;

-		total_bytes += tx_buf->bytecount;
-		total_packets++;
-
 		if (tx_buf->raw_buf) {
 			ice_clean_xdp_tx_buf(xdp_ring, tx_buf);
 			tx_buf->raw_buf = NULL;
+
+			xdp_bytes += tx_buf->bytecount;
+			xdp_frames++;
 		} else {
+			xsk_bytes += tx_buf->bytecount;
 			xsk_frames++;
 		}

@@ -736,7 +757,13 @@ bool ice_clean_tx_irq_zc(struct ice_tx_ring *xdp_ring, int budget)
 	if (xsk_uses_need_wakeup(xdp_ring->xsk_pool))
 		xsk_set_tx_need_wakeup(xdp_ring->xsk_pool);

-	ice_update_tx_ring_stats(xdp_ring, total_packets, total_bytes);
+	ice_update_tx_ring_stats(xdp_ring, xdp_frames + xsk_frames,
+				 xdp_bytes + xsk_bytes);
+	xdp_update_tx_drv_stats(&xdp_ring->xdp_stats->xdp_tx, xdp_frames,
+				xdp_bytes);
+	xdp_update_tx_drv_stats(&xdp_ring->xdp_stats->xsk_tx, xsk_frames,
+				xsk_bytes);
+
 	xmit_done = ice_xmit_zc(xdp_ring, ICE_DFLT_IRQ_WORK);

 	return budget > 0 && xmit_done;
--
2.33.1

