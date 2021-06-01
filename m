Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A113972BA
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 13:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbhFALsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 07:48:01 -0400
Received: from mga18.intel.com ([134.134.136.126]:47601 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233657AbhFALr5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 07:47:57 -0400
IronPort-SDR: dbWZKVYEmoy8ptlkjgSrC87mT8803d4+WFh4TFqSloKqqifgnrwmc2vsqBg45XzACaAzo/0hKO
 okbR3cDI6sAQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="190884045"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="190884045"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 04:46:15 -0700
IronPort-SDR: tupNR3+Pb8Fs5EOQf9ltIo5J14EeijklF6yL9zESc4B53M+BChXaJWfobVXt1Rirm0m1/jbqNd
 4QPcGAcoTaDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="446931358"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga008.fm.intel.com with ESMTP; 01 Jun 2021 04:46:13 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH intel-next 2/2] ice: introduce XDP Tx fallback path
Date:   Tue,  1 Jun 2021 13:32:36 +0200
Message-Id: <20210601113236.42651-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210601113236.42651-1-maciej.fijalkowski@intel.com>
References: <20210601113236.42651-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Under rare circumstances there might be a situation where a requirement
of having a XDP Tx queue per core could not be fulfilled and some of the
Tx resources would have to be shared between cores. This yields a need
for placing accesses to xdp_rings array onto critical section protected
by spinlock.

Design of handling such scenario is to at first find out how many queues
are there that XDP could use. Any number that is not less than the half
of a count of cores of platform is allowed. XDP queue count < cpu count
is signalled via new VSI state ICE_VSI_XDP_FALLBACK which carries the
information further down to Rx rings where new ICE_TX_XDP_LOCKED is set
based on the mentioned VSI state. This ring flag indicates that locking
variants for getting/putting xdp_ring need to be used in fast path.

For XDP_REDIRECT the impact on standard case (one XDP ring per CPU) can
be reduced a bit by providing a separate ndo_xdp_xmit and swap it at
configuration time. However, due to the fact that net_device_ops struct
is a const, it is not possible to replace a single ndo, so for the
locking variant of ndo_xdp_xmit, whole net_device_ops needs to be
replayed.

It has an impact on performance (1-2 %) of a non-fallback path as
branches are introduced.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          | 37 +++++++++
 drivers/net/ethernet/intel/ice/ice_base.c     |  5 ++
 drivers/net/ethernet/intel/ice/ice_lib.c      |  4 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 76 ++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 62 ++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  2 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 13 +++-
 7 files changed, 191 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index e35db3ff583b..a04dbc444ed9 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -248,6 +248,7 @@ enum ice_vsi_state {
 	ICE_VSI_MMAC_FLTR_CHANGED,
 	ICE_VSI_VLAN_FLTR_CHANGED,
 	ICE_VSI_PROMISC_CHANGED,
+	ICE_VSI_XDP_FALLBACK,
 	ICE_VSI_STATE_NBITS		/* must be last */
 };
 
@@ -538,6 +539,38 @@ static inline void ice_set_ring_xdp(struct ice_ring *ring)
 	ring->flags |= ICE_TX_FLAGS_RING_XDP;
 }
 
+static inline struct ice_ring *ice_get_xdp_ring(struct ice_vsi *vsi)
+{
+	struct ice_ring *xdp_ring;
+
+	xdp_ring = vsi->xdp_rings[smp_processor_id()];
+	/* make sparse happy */
+	__acquire(&xdp_ring->tx_lock);
+
+	return xdp_ring;
+}
+
+static inline struct ice_ring *ice_get_xdp_ring_locked(struct ice_vsi *vsi)
+{
+	struct ice_ring *xdp_ring;
+
+	xdp_ring = vsi->xdp_rings[smp_processor_id() % vsi->num_xdp_txq];
+	spin_lock(&xdp_ring->tx_lock);
+
+	return xdp_ring;
+}
+
+static inline void ice_put_xdp_ring(struct ice_ring __always_unused *xdp_ring)
+{
+	/* make sparse happy */
+	__release(&xdp_ring->tx_lock);
+}
+
+static inline void ice_put_xdp_ring_locked(struct ice_ring *xdp_ring)
+{
+	spin_unlock(&xdp_ring->tx_lock);
+}
+
 /**
  * ice_xsk_pool - get XSK buffer pool bound to a ring
  * @ring: ring to use
@@ -624,11 +657,15 @@ int ice_up(struct ice_vsi *vsi);
 int ice_down(struct ice_vsi *vsi);
 int ice_vsi_cfg(struct ice_vsi *vsi);
 struct ice_vsi *ice_lb_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi);
+int ice_vsi_determine_xdp_res(struct ice_vsi *vsi);
 int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog);
 int ice_destroy_xdp_rings(struct ice_vsi *vsi);
 int
 ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 	     u32 flags);
+int
+ice_xdp_xmit_locked(struct net_device *dev, int n, struct xdp_frame **frames,
+		    u32 flags);
 int ice_set_rss_lut(struct ice_vsi *vsi, u8 *lut, u16 lut_size);
 int ice_get_rss_lut(struct ice_vsi *vsi, u8 *lut, u16 lut_size);
 int ice_set_rss_key(struct ice_vsi *vsi, u8 *seed);
diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 5985a7e5ca8a..c8f130b77eea 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -452,6 +452,11 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	else
 		ice_set_ring_build_skb_ena(ring);
 
+	/* XDP is executed per Rx ring, so we need to indicate there is
+	 * insufficient count of XDP queues and we need a locking
+	 */
+	if (test_bit(ICE_VSI_XDP_FALLBACK, vsi->state))
+		ring->flags |= ICE_TX_XDP_LOCKED;
 	ring->rx_offset = ice_rx_offset(ring);
 
 	/* init queue specific tail register */
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 3c8668d8b964..138c6ce0359e 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3099,7 +3099,9 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 
 		ice_vsi_map_rings_to_vectors(vsi);
 		if (ice_is_xdp_ena_vsi(vsi)) {
-			vsi->num_xdp_txq = num_possible_cpus();
+			ret = ice_vsi_determine_xdp_res(vsi);
+			if (ret)
+				goto err_vectors;
 			ret = ice_prepare_xdp_rings(vsi, vsi->xdp_prog);
 			if (ret)
 				goto err_vectors;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 1915b6a734e2..6473134b492f 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -38,6 +38,7 @@ MODULE_PARM_DESC(debug, "netif level (0=none,...,16=all)");
 static struct workqueue_struct *ice_wq;
 static const struct net_device_ops ice_netdev_safe_mode_ops;
 static const struct net_device_ops ice_netdev_ops;
+static const struct net_device_ops ice_netdev_ops_xdp_locked;
 static int ice_vsi_open(struct ice_vsi *vsi);
 
 static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type);
@@ -2290,6 +2291,7 @@ static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
 			goto free_xdp_rings;
 		ice_set_ring_xdp(xdp_ring);
 		xdp_ring->xsk_pool = ice_xsk_pool(xdp_ring);
+		spin_lock_init(&xdp_ring->tx_lock);
 	}
 
 	return 0;
@@ -2355,6 +2357,12 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog)
 	if (__ice_vsi_get_qs(&xdp_qs_cfg))
 		goto err_map_xdp;
 
+	if (test_bit(ICE_VSI_XDP_FALLBACK, vsi->state)) {
+		vsi->netdev->netdev_ops = &ice_netdev_ops_xdp_locked;
+		netdev_warn(vsi->netdev,
+			    "Could not allocate one XDP Tx ring per CPU, XDP_TX/XDP_REDIRECT actions will be slower\n");
+	}
+
 	if (ice_xdp_alloc_setup_rings(vsi))
 		goto clear_xdp_rings;
 
@@ -2470,6 +2478,10 @@ int ice_destroy_xdp_rings(struct ice_vsi *vsi)
 
 	devm_kfree(ice_pf_to_dev(pf), vsi->xdp_rings);
 	vsi->xdp_rings = NULL;
+	if (test_bit(ICE_VSI_XDP_FALLBACK, vsi->state)) {
+		clear_bit(ICE_VSI_XDP_FALLBACK, vsi->state);
+		vsi->netdev->netdev_ops = &ice_netdev_ops;
+	}
 
 	if (ice_is_reset_in_progress(pf->state) || !vsi->q_vectors[0])
 		return 0;
@@ -2505,6 +2517,29 @@ static void ice_vsi_rx_napi_schedule(struct ice_vsi *vsi)
 	}
 }
 
+/**
+ * ice_vsi_determine_xdp_res - figure out how many Tx qs can XDP have
+ * @vsi: VSI to determine the count of XDP Tx qs
+ *
+ * returns 0 if Tx qs count is higher than at least half of CPU count,
+ * -ENOMEM otherwise
+ */
+int ice_vsi_determine_xdp_res(struct ice_vsi *vsi)
+{
+	u16 avail = ice_get_avail_txq_count(vsi->back);
+	u16 cpus = num_possible_cpus();
+
+	if (avail < cpus / 2)
+		return -ENOMEM;
+
+	vsi->num_xdp_txq = min_t(u16, avail, cpus);
+
+	if (vsi->num_xdp_txq < cpus)
+		set_bit(ICE_VSI_XDP_FALLBACK, vsi->state);
+
+	return 0;
+}
+
 /**
  * ice_xdp_setup_prog - Add or remove XDP eBPF program
  * @vsi: VSI to setup XDP for
@@ -2534,8 +2569,11 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 	}
 
 	if (!ice_is_xdp_ena_vsi(vsi) && prog) {
-		vsi->num_xdp_txq = num_possible_cpus();
-		xdp_ring_err = ice_prepare_xdp_rings(vsi, prog);
+		xdp_ring_err = ice_vsi_determine_xdp_res(vsi);
+		if (xdp_ring_err)
+			NL_SET_ERR_MSG_MOD(extack, "Not enough Tx resources for XDP");
+		else
+			xdp_ring_err = ice_prepare_xdp_rings(vsi, prog);
 		if (xdp_ring_err)
 			NL_SET_ERR_MSG_MOD(extack, "Setting up XDP Tx resources failed");
 	} else if (ice_is_xdp_ena_vsi(vsi) && !prog) {
@@ -6987,3 +7025,37 @@ static const struct net_device_ops ice_netdev_ops = {
 	.ndo_xdp_xmit = ice_xdp_xmit,
 	.ndo_xsk_wakeup = ice_xsk_wakeup,
 };
+
+static const struct net_device_ops ice_netdev_ops_xdp_locked = {
+	.ndo_open = ice_open,
+	.ndo_stop = ice_stop,
+	.ndo_start_xmit = ice_start_xmit,
+	.ndo_features_check = ice_features_check,
+	.ndo_set_rx_mode = ice_set_rx_mode,
+	.ndo_set_mac_address = ice_set_mac_address,
+	.ndo_validate_addr = eth_validate_addr,
+	.ndo_change_mtu = ice_change_mtu,
+	.ndo_get_stats64 = ice_get_stats64,
+	.ndo_set_tx_maxrate = ice_set_tx_maxrate,
+	.ndo_set_vf_spoofchk = ice_set_vf_spoofchk,
+	.ndo_set_vf_mac = ice_set_vf_mac,
+	.ndo_get_vf_config = ice_get_vf_cfg,
+	.ndo_set_vf_trust = ice_set_vf_trust,
+	.ndo_set_vf_vlan = ice_set_vf_port_vlan,
+	.ndo_set_vf_link_state = ice_set_vf_link_state,
+	.ndo_get_vf_stats = ice_get_vf_stats,
+	.ndo_vlan_rx_add_vid = ice_vlan_rx_add_vid,
+	.ndo_vlan_rx_kill_vid = ice_vlan_rx_kill_vid,
+	.ndo_set_features = ice_set_features,
+	.ndo_bridge_getlink = ice_bridge_getlink,
+	.ndo_bridge_setlink = ice_bridge_setlink,
+	.ndo_fdb_add = ice_fdb_add,
+	.ndo_fdb_del = ice_fdb_del,
+#ifdef CONFIG_RFS_ACCEL
+	.ndo_rx_flow_steer = ice_rx_flow_steer,
+#endif
+	.ndo_tx_timeout = ice_tx_timeout,
+	.ndo_bpf = ice_xdp,
+	.ndo_xdp_xmit = ice_xdp_xmit_locked,
+	.ndo_xsk_wakeup = ice_xsk_wakeup,
+};
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index e2b4b29ea207..a8112e493a45 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -531,8 +531,16 @@ ice_run_xdp(struct ice_ring *rx_ring, struct xdp_buff *xdp,
 	case XDP_PASS:
 		return ICE_XDP_PASS;
 	case XDP_TX:
-		xdp_ring = rx_ring->vsi->xdp_rings[smp_processor_id()];
-		return ice_xmit_xdp_buff(xdp, xdp_ring);
+		if (unlikely(rx_ring->flags & ICE_TX_XDP_LOCKED))
+			xdp_ring = ice_get_xdp_ring_locked(rx_ring->vsi);
+		else
+			xdp_ring = ice_get_xdp_ring(rx_ring->vsi);
+		err = ice_xmit_xdp_buff(xdp, xdp_ring);
+		if (unlikely(rx_ring->flags & ICE_TX_XDP_LOCKED))
+			ice_put_xdp_ring_locked(xdp_ring);
+		else
+			ice_put_xdp_ring(xdp_ring);
+		return err;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
 		return !err ? ICE_XDP_REDIR : ICE_XDP_CONSUMED;
@@ -595,6 +603,56 @@ ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 	return nxmit;
 }
 
+/**
+ * ice_xdp_xmit_locked - submit packets to XDP ring for tx and hold a lock
+ * @dev: netdev
+ * @n: number of XDP frames to be transmitted
+ * @frames: XDP frames to be transmitted
+ * @flags: transmit flags
+ *
+ * Returns number of frames successfully sent. Failed frames
+ * will be free'ed by XDP core.
+ * For error cases, a negative errno code is returned and no-frames
+ * are transmitted (caller must handle freeing frames).
+ * This function is used when the requirement for having a XDP Tx ring per
+ * CPU is not fulfilled.
+ */
+int
+ice_xdp_xmit_locked(struct net_device *dev, int n, struct xdp_frame **frames,
+		    u32 flags)
+{
+	struct ice_netdev_priv *np = netdev_priv(dev);
+	struct ice_vsi *vsi = np->vsi;
+	struct ice_ring *xdp_ring;
+	int nxmit = 0, i;
+
+	if (test_bit(ICE_VSI_DOWN, vsi->state))
+		return -ENETDOWN;
+
+	if (!ice_is_xdp_ena_vsi(vsi))
+		return -ENXIO;
+
+	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
+		return -EINVAL;
+
+	xdp_ring = vsi->xdp_rings[smp_processor_id() % vsi->num_xdp_txq];
+	spin_lock(&xdp_ring->tx_lock);
+	for (i = 0; i < n; i++) {
+		struct xdp_frame *xdpf = frames[i];
+		int err;
+
+		err = ice_xmit_xdp_ring(xdpf->data, xdpf->len, xdp_ring);
+		if (err != ICE_XDP_TX)
+			break;
+		nxmit++;
+	}
+
+	if (unlikely(flags & XDP_XMIT_FLUSH))
+		ice_xdp_ring_update_tail(xdp_ring);
+	spin_unlock(&xdp_ring->tx_lock);
+
+	return nxmit;
+}
 /**
  * ice_alloc_mapped_page - recycle or make a new page
  * @rx_ring: ring to use
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index c5a92ac787d6..9bcd279569fe 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -299,12 +299,14 @@ struct ice_ring {
 	u16 rx_offset;
 	/* CL3 - 3rd cacheline starts here */
 	struct xdp_rxq_info xdp_rxq;
+	spinlock_t tx_lock;
 	struct sk_buff *skb;
 	/* CLX - the below items are only accessed infrequently and should be
 	 * in their own cache line if possible
 	 */
 #define ICE_TX_FLAGS_RING_XDP		BIT(0)
 #define ICE_RX_FLAGS_RING_BUILD_SKB	BIT(1)
+#define ICE_TX_XDP_LOCKED		BIT(2)
 	u8 flags;
 	dma_addr_t dma;			/* physical address of ring */
 	unsigned int size;		/* length of descriptor ring in bytes */
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index e1c05d69f017..13ca2ba2fc3b 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -274,13 +274,20 @@ int ice_xmit_xdp_buff(struct xdp_buff *xdp, struct ice_ring *xdp_ring)
  */
 void ice_finalize_xdp_rx(struct ice_ring *rx_ring, unsigned int xdp_res)
 {
+	struct ice_ring *xdp_ring;
+
 	if (xdp_res & ICE_XDP_REDIR)
 		xdp_do_flush_map();
 
 	if (xdp_res & ICE_XDP_TX) {
-		struct ice_ring *xdp_ring =
-			rx_ring->vsi->xdp_rings[smp_processor_id()];
-
+		if (unlikely(rx_ring->flags & ICE_TX_XDP_LOCKED))
+			xdp_ring = ice_get_xdp_ring_locked(rx_ring->vsi);
+		else
+			xdp_ring = ice_get_xdp_ring(rx_ring->vsi);
 		ice_xdp_ring_update_tail(xdp_ring);
+		if (unlikely(rx_ring->flags & ICE_TX_XDP_LOCKED))
+			ice_put_xdp_ring_locked(xdp_ring);
+		else
+			ice_put_xdp_ring(xdp_ring);
 	}
 }
-- 
2.20.1

