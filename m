Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4051E55EE7A
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbiF1Tx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbiF1TvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:51:00 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C433A2DD49;
        Tue, 28 Jun 2022 12:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445798; x=1687981798;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+NKlBQ5LgZgO3ibGntvsU9/Z+gabvKL1N1nJ8jtM7cg=;
  b=Wrfd+cIkjvqGmwDpV77Zs3v6GsRl1WJpSuDXnD/FpyTE847hNZNmDHow
   a9ZzHHNB3myyI9QVVAQJMW59P+06iN+rQuklVS6J1sDCgDAR23ZgJDeUH
   9Dn0AIAOGCWr/QmkTk4RElR4eA5CVjlz6tMbnBqy/fkeoeD5DBVvnmK4M
   IHtiVMzot1jJpvVumpEKAbtF+6rSF0lZyXa3QcC/KrSpETMl4HDYiS/t4
   3POzcwsg/aFTQuRYvoE+kb7IP1v4Oa4tl7/zy+iEYS8cQ/wx0+OtXYRcx
   gxlF/5blLEtqHHCbeRk0owWy+O/gVBEkLs1YJvKxITcM1WjG95paCr98V
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="343523384"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="343523384"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="658257588"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 28 Jun 2022 12:49:54 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9i022013;
        Tue, 28 Jun 2022 20:49:52 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 44/52] net, ice: allow XDP prog hot-swapping
Date:   Tue, 28 Jun 2022 21:48:04 +0200
Message-Id: <20220628194812.1453059-45-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, an interface is always being brought down on
%XDP_SETUP_PROG, no matter if there would be a global configuration
change (no prog -> prog, prog -> no prog) or just a hot-swap (prog
-> prog). That is suboptimal, especially when old_prog == new_prog,
which should be a no-op at all. Moreover, it makes it impossible to
change some aux XDP options on the fly which could be designed to
work like that.
Store &xdp_attachment_info in just one copy inside the VSI
structure, RQs will only have pointers to it. This way we only need
to rewrite it once and xdp_attachment_setup_rcu() now may be used.
Guard NAPI poll routines with RCU read locks to make sure the BPF
prog won't get freed right in the middle of a cycle. Now the old
program will be freed only when all of the rings will use the new
one already. Then do an ifdown->ifup cycle in ::ndo_bpf() only if
absolutely needed (mentioned above), the rest will be completely
safe to do on the go.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      |  8 +--
 drivers/net/ethernet/intel/ice/ice_lib.c  |  4 +-
 drivers/net/ethernet/intel/ice/ice_main.c | 61 ++++++++++-------------
 drivers/net/ethernet/intel/ice/ice_txrx.c | 11 ++--
 drivers/net/ethernet/intel/ice/ice_txrx.h |  2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c  |  2 +-
 6 files changed, 40 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 60453b3b8d23..402b71ab48e4 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -386,7 +386,7 @@ struct ice_vsi {
 	u16 num_tx_desc;
 	u16 qset_handle[ICE_MAX_TRAFFIC_CLASS];
 	struct ice_tc_cfg tc_cfg;
-	struct bpf_prog *xdp_prog;
+	struct xdp_attachment_info xdp_info;
 	struct ice_tx_ring **xdp_rings;	 /* XDP ring array */
 	unsigned long *af_xdp_zc_qps;	 /* tracks AF_XDP ZC enabled qps */
 	u16 num_xdp_txq;		 /* Used XDP queues */
@@ -672,7 +672,7 @@ static inline struct ice_pf *ice_netdev_to_pf(struct net_device *netdev)
 
 static inline bool ice_is_xdp_ena_vsi(struct ice_vsi *vsi)
 {
-	return !!READ_ONCE(vsi->xdp_prog);
+	return !!rcu_access_pointer(vsi->xdp_info.prog_rcu);
 }
 
 static inline void ice_set_ring_xdp(struct ice_tx_ring *ring)
@@ -857,8 +857,8 @@ int ice_down(struct ice_vsi *vsi);
 int ice_vsi_cfg(struct ice_vsi *vsi);
 struct ice_vsi *ice_lb_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi);
 int ice_vsi_determine_xdp_res(struct ice_vsi *vsi);
-int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog);
-int ice_destroy_xdp_rings(struct ice_vsi *vsi);
+int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct netdev_bpf *xdp);
+int ice_destroy_xdp_rings(struct ice_vsi *vsi, struct netdev_bpf *xdp);
 int
 ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 	     u32 flags);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index b28fb8eacffb..3db1271b5176 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3200,7 +3200,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 		/* return value check can be skipped here, it always returns
 		 * 0 if reset is in progress
 		 */
-		ice_destroy_xdp_rings(vsi);
+		ice_destroy_xdp_rings(vsi, NULL);
 	ice_vsi_put_qs(vsi);
 	ice_vsi_clear_rings(vsi);
 	ice_vsi_free_arrays(vsi);
@@ -3248,7 +3248,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 			ret = ice_vsi_determine_xdp_res(vsi);
 			if (ret)
 				goto err_vectors;
-			ret = ice_prepare_xdp_rings(vsi, vsi->xdp_prog);
+			ret = ice_prepare_xdp_rings(vsi, NULL);
 			if (ret)
 				goto err_vectors;
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c1ac2f746714..7d049930a0a8 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2603,32 +2603,14 @@ static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
 	return -ENOMEM;
 }
 
-/**
- * ice_vsi_assign_bpf_prog - set or clear bpf prog pointer on VSI
- * @vsi: VSI to set the bpf prog on
- * @prog: the bpf prog pointer
- */
-static void ice_vsi_assign_bpf_prog(struct ice_vsi *vsi, struct bpf_prog *prog)
-{
-	struct bpf_prog *old_prog;
-	int i;
-
-	old_prog = xchg(&vsi->xdp_prog, prog);
-	if (old_prog)
-		bpf_prog_put(old_prog);
-
-	ice_for_each_rxq(vsi, i)
-		WRITE_ONCE(vsi->rx_rings[i]->xdp_prog, vsi->xdp_prog);
-}
-
 /**
  * ice_prepare_xdp_rings - Allocate, configure and setup Tx rings for XDP
  * @vsi: VSI to bring up Tx rings used by XDP
- * @prog: bpf program that will be assigned to VSI
+ * @xdp: &netdev_bpf with XDP program and additional data passed from the stack
  *
  * Return 0 on success and negative value on error
  */
-int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog)
+int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct netdev_bpf *xdp)
 {
 	u16 max_txqs[ICE_MAX_TRAFFIC_CLASS] = { 0 };
 	int xdp_rings_rem = vsi->num_xdp_txq;
@@ -2713,8 +2695,8 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog)
 	 * this is not harmful as dev_xdp_install bumps the refcount
 	 * before calling the op exposed by the driver;
 	 */
-	if (!ice_is_xdp_ena_vsi(vsi))
-		ice_vsi_assign_bpf_prog(vsi, prog);
+	if (xdp)
+		xdp_attachment_setup_rcu(&vsi->xdp_info, xdp);
 
 	return 0;
 clear_xdp_rings:
@@ -2739,11 +2721,12 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog)
 /**
  * ice_destroy_xdp_rings - undo the configuration made by ice_prepare_xdp_rings
  * @vsi: VSI to remove XDP rings
+ * @xdp: &netdev_bpf with XDP program and additional data passed from the stack
  *
  * Detach XDP rings from irq vectors, clean up the PF bitmap and free
  * resources
  */
-int ice_destroy_xdp_rings(struct ice_vsi *vsi)
+int ice_destroy_xdp_rings(struct ice_vsi *vsi, struct netdev_bpf *xdp)
 {
 	u16 max_txqs[ICE_MAX_TRAFFIC_CLASS] = { 0 };
 	struct ice_pf *pf = vsi->back;
@@ -2796,7 +2779,11 @@ int ice_destroy_xdp_rings(struct ice_vsi *vsi)
 	if (ice_is_reset_in_progress(pf->state) || !vsi->q_vectors[0])
 		return 0;
 
-	ice_vsi_assign_bpf_prog(vsi, NULL);
+	/* Symmetrically to ice_prepare_xdp_rings(), touch XDP program only
+	 * when called from ::ndo_bpf().
+	 */
+	if (xdp)
+		xdp_attachment_setup_rcu(&vsi->xdp_info, xdp);
 
 	/* notify Tx scheduler that we destroyed XDP queues and bring
 	 * back the old number of child nodes
@@ -2853,15 +2840,14 @@ int ice_vsi_determine_xdp_res(struct ice_vsi *vsi)
 /**
  * ice_xdp_setup_prog - Add or remove XDP eBPF program
  * @vsi: VSI to setup XDP for
- * @prog: XDP program
- * @extack: netlink extended ack
+ * @xdp: &netdev_bpf with XDP program and additional data passed from the stack
  */
 static int
-ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
-		   struct netlink_ext_ack *extack)
+ice_xdp_setup_prog(struct ice_vsi *vsi, struct netdev_bpf *xdp)
 {
 	int frame_size = vsi->netdev->mtu + ICE_ETH_PKT_HDR_PAD;
-	bool if_running = netif_running(vsi->netdev);
+	struct netlink_ext_ack *extack = xdp->extack;
+	bool restart = false, prog = !!xdp->prog;
 	int ret = 0, xdp_ring_err = 0;
 
 	if (frame_size > vsi->rx_buf_len) {
@@ -2870,12 +2856,15 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 	}
 
 	/* need to stop netdev while setting up the program for Rx rings */
-	if (if_running && !test_and_set_bit(ICE_VSI_DOWN, vsi->state)) {
+	if (ice_is_xdp_ena_vsi(vsi) != prog && netif_running(vsi->netdev) &&
+	    !test_and_set_bit(ICE_VSI_DOWN, vsi->state)) {
 		ret = ice_down(vsi);
 		if (ret) {
 			NL_SET_ERR_MSG_MOD(extack, "Preparing device for XDP attach failed");
 			return ret;
 		}
+
+		restart = true;
 	}
 
 	if (!ice_is_xdp_ena_vsi(vsi) && prog) {
@@ -2883,24 +2872,24 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 		if (xdp_ring_err) {
 			NL_SET_ERR_MSG_MOD(extack, "Not enough Tx resources for XDP");
 		} else {
-			xdp_ring_err = ice_prepare_xdp_rings(vsi, prog);
+			xdp_ring_err = ice_prepare_xdp_rings(vsi, xdp);
 			if (xdp_ring_err)
 				NL_SET_ERR_MSG_MOD(extack, "Setting up XDP Tx resources failed");
 		}
 	} else if (ice_is_xdp_ena_vsi(vsi) && !prog) {
-		xdp_ring_err = ice_destroy_xdp_rings(vsi);
+		xdp_ring_err = ice_destroy_xdp_rings(vsi, xdp);
 		if (xdp_ring_err)
 			NL_SET_ERR_MSG_MOD(extack, "Freeing XDP Tx resources failed");
 	} else {
-		/* safe to call even when prog == vsi->xdp_prog as
+		/* safe to call even when prog == vsi->xdp_info.prog as
 		 * dev_xdp_install in net/core/dev.c incremented prog's
 		 * refcount so corresponding bpf_prog_put won't cause
 		 * underflow
 		 */
-		ice_vsi_assign_bpf_prog(vsi, prog);
+		xdp_attachment_setup_rcu(&vsi->xdp_info, xdp);
 	}
 
-	if (if_running)
+	if (restart)
 		ret = ice_up(vsi);
 
 	if (!ret && prog)
@@ -2940,7 +2929,7 @@ static int ice_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
-		return ice_xdp_setup_prog(vsi, xdp->prog, xdp->extack);
+		return ice_xdp_setup_prog(vsi, xdp);
 	case XDP_SETUP_XSK_POOL:
 		return ice_xsk_pool_setup(vsi, xdp->xsk.pool,
 					  xdp->xsk.queue_id);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 3f8b7274ed2f..25383bbf8245 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -454,7 +454,7 @@ void ice_free_rx_ring(struct ice_rx_ring *rx_ring)
 	if (rx_ring->vsi->type == ICE_VSI_PF)
 		if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
 			xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
-	rx_ring->xdp_prog = NULL;
+
 	if (rx_ring->xsk_pool) {
 		kfree(rx_ring->xdp_buf);
 		rx_ring->xdp_buf = NULL;
@@ -507,8 +507,7 @@ int ice_setup_rx_ring(struct ice_rx_ring *rx_ring)
 	rx_ring->next_to_use = 0;
 	rx_ring->next_to_clean = 0;
 
-	if (ice_is_xdp_ena_vsi(rx_ring->vsi))
-		WRITE_ONCE(rx_ring->xdp_prog, rx_ring->vsi->xdp_prog);
+	rx_ring->xdp_info = &rx_ring->vsi->xdp_info;
 
 	if (rx_ring->vsi->type == ICE_VSI_PF &&
 	    !xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
@@ -1123,7 +1122,7 @@ int ice_clean_rx_irq(struct ice_rx_ring *rx_ring, int budget)
 #endif
 	xdp_init_buff(&xdp, frame_sz, &rx_ring->xdp_rxq);
 
-	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
+	xdp_prog = rcu_dereference(rx_ring->xdp_info->prog_rcu);
 	if (xdp_prog)
 		xdp_ring = rx_ring->xdp_ring;
 
@@ -1489,6 +1488,8 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 		/* Max of 1 Rx ring in this q_vector so give it the budget */
 		budget_per_ring = budget;
 
+	rcu_read_lock();
+
 	ice_for_each_rx_ring(rx_ring, q_vector->rx) {
 		int cleaned;
 
@@ -1505,6 +1506,8 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 			clean_complete = false;
 	}
 
+	rcu_read_unlock();
+
 	/* If work not completed, return budget and polling will return */
 	if (!clean_complete) {
 		/* Set the writeback on ITR so partial completions of
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index ca902af54bb4..1fc31ab0bf33 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -290,7 +290,7 @@ struct ice_rx_ring {
 	struct rcu_head rcu;		/* to avoid race on free */
 	/* CL4 - 3rd cacheline starts here */
 	struct ice_channel *ch;
-	struct bpf_prog *xdp_prog;
+	const struct xdp_attachment_info *xdp_info;
 	struct ice_tx_ring *xdp_ring;
 	struct xsk_buff_pool *xsk_pool;
 	struct sk_buff *skb;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 49ba8bfdbf04..eb994cf68ff4 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -597,7 +597,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 	/* ZC patch is enabled only when XDP program is set,
 	 * so here it can not be NULL
 	 */
-	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
+	xdp_prog = rcu_dereference(rx_ring->xdp_info->prog_rcu);
 	xdp_ring = rx_ring->xdp_ring;
 
 	while (likely(total_rx_packets < (unsigned int)budget)) {
-- 
2.36.1

