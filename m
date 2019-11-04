Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6CF5EEBDB
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 22:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbfKDVvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 16:51:31 -0500
Received: from mga17.intel.com ([192.55.52.151]:57657 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730524AbfKDVv2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 16:51:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 13:51:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,268,1569308400"; 
   d="scan'208";a="219818383"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Nov 2019 13:51:26 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 3/9] ice: Add support for XDP
Date:   Mon,  4 Nov 2019 13:51:19 -0800
Message-Id: <20191104215125.16745-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191104215125.16745-1-jeffrey.t.kirsher@intel.com>
References: <20191104215125.16745-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Add support for XDP. Implement ndo_bpf and ndo_xdp_xmit.  Upon load of
an XDP program, allocate additional Tx rings for dedicated XDP use.
The following actions are supported: XDP_TX, XDP_DROP, XDP_REDIRECT,
XDP_PASS, and XDP_ABORTED.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
v2:
- return -EOPNOTSUPP instead of ENOTSUPP for too large MTU which makes
  it impossible to attach XDP prog
- don't check for case when there's no XDP prog currently on interface
  and ice_xdp() is called with NULL bpf_prog; this happens when user
  does "ip link set eth0 xdp off" and no prog is present on VSI; no need
  for that as it is handled by higher layer
- drop the extack message for unknown xdp->command
- use the smp_processor_id() for accessing the XDP Tx ring for XDP_TX
  action
- don't leave the interface in downed state in case of any failure
  during the XDP Tx resources handling
- undo rename of ice_build_ctob

---
 drivers/net/ethernet/intel/ice/ice.h         |  24 +-
 drivers/net/ethernet/intel/ice/ice_base.c    |  28 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c |  50 ++-
 drivers/net/ethernet/intel/ice/ice_lib.c     |  68 +++-
 drivers/net/ethernet/intel/ice/ice_lib.h     |   6 +
 drivers/net/ethernet/intel/ice/ice_main.c    | 326 +++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_txrx.c    | 346 ++++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_txrx.h    |  34 +-
 8 files changed, 825 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 0b5aa8feae26..b2451f768707 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -29,8 +29,10 @@
 #include <linux/ip.h>
 #include <linux/sctp.h>
 #include <linux/ipv6.h>
+#include <linux/pkt_sched.h>
 #include <linux/if_bridge.h>
 #include <linux/ctype.h>
+#include <linux/bpf.h>
 #include <linux/avf/virtchnl.h>
 #include <net/ipv6.h>
 #include "ice_devids.h"
@@ -78,8 +80,7 @@ extern const char ice_drv_ver[];
 
 #define ICE_DFLT_NETIF_M (NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK)
 
-#define ICE_MAX_MTU	(ICE_AQ_SET_MAC_FRAME_SIZE_MAX - \
-			(ETH_HLEN + ETH_FCS_LEN + (VLAN_HLEN * 2)))
+#define ICE_MAX_MTU	(ICE_AQ_SET_MAC_FRAME_SIZE_MAX - ICE_ETH_PKT_HDR_PAD)
 
 #define ICE_UP_TABLE_TRANSLATE(val, i) \
 		(((val) << ICE_AQ_VSI_UP_TABLE_UP##i##_S) & \
@@ -282,6 +283,10 @@ struct ice_vsi {
 	u16 num_rx_desc;
 	u16 num_tx_desc;
 	struct ice_tc_cfg tc_cfg;
+	struct bpf_prog *xdp_prog;
+	struct ice_ring **xdp_rings;	 /* XDP ring array */
+	u16 num_xdp_txq;		 /* Used XDP queues */
+	u8 xdp_mapping_mode;		 /* ICE_MAP_MODE_[CONTIG|SCATTER] */
 } ____cacheline_internodealigned_in_smp;
 
 /* struct that defines an interrupt vector */
@@ -425,6 +430,16 @@ static inline struct ice_pf *ice_netdev_to_pf(struct net_device *netdev)
 	return np->vsi->back;
 }
 
+static inline bool ice_is_xdp_ena_vsi(struct ice_vsi *vsi)
+{
+	return !!vsi->xdp_prog;
+}
+
+static inline void ice_set_ring_xdp(struct ice_ring *ring)
+{
+	ring->flags |= ICE_TX_FLAGS_RING_XDP;
+}
+
 /**
  * ice_get_main_vsi - Get the PF VSI
  * @pf: PF instance
@@ -451,6 +466,11 @@ int ice_up(struct ice_vsi *vsi);
 int ice_down(struct ice_vsi *vsi);
 int ice_vsi_cfg(struct ice_vsi *vsi);
 struct ice_vsi *ice_lb_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi);
+int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog);
+int ice_destroy_xdp_rings(struct ice_vsi *vsi);
+int
+ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
+	     u32 flags);
 int ice_set_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size);
 int ice_get_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size);
 void ice_fill_rss_lut(u8 *lut, u16 rss_table_size, u16 rss_size);
diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index df9f9bacbdf8..8721934fb4ea 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -198,6 +198,9 @@ static void ice_cfg_itr_gran(struct ice_hw *hw)
  */
 static u16 ice_calc_q_handle(struct ice_vsi *vsi, struct ice_ring *ring, u8 tc)
 {
+	WARN_ONCE(ice_ring_is_xdp(ring) && tc,
+		  "XDP ring can't belong to TC other than 0");
+
 	/* Idea here for calculation is that we subtract the number of queue
 	 * count from TC that ring belongs to from it's absolute queue index
 	 * and as a result we get the queue's index within TC.
@@ -287,6 +290,22 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	/* clear the context structure first */
 	memset(&rlan_ctx, 0, sizeof(rlan_ctx));
 
+	ring->rx_buf_len = vsi->rx_buf_len;
+
+	if (ring->vsi->type == ICE_VSI_PF) {
+		if (!xdp_rxq_info_is_reg(&ring->xdp_rxq))
+			xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
+					 ring->q_index);
+
+		err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
+						 MEM_TYPE_PAGE_SHARED, NULL);
+		if (err)
+			return err;
+	}
+	/* Receive Queue Base Address.
+	 * Indicates the starting address of the descriptor queue defined in
+	 * 128 Byte units.
+	 */
 	rlan_ctx.base = ring->dma >> 7;
 
 	rlan_ctx.qlen = ring->count;
@@ -294,7 +313,7 @@ int ice_setup_rx_ctx(struct ice_ring *ring)
 	/* Receive Packet Data Buffer Size.
 	 * The Packet Data Buffer Size is defined in 128 byte units.
 	 */
-	rlan_ctx.dbuf = vsi->rx_buf_len >> ICE_RLAN_CTX_DBUF_S;
+	rlan_ctx.dbuf = ring->rx_buf_len >> ICE_RLAN_CTX_DBUF_S;
 
 	/* use 32 byte descriptors */
 	rlan_ctx.dsize = 1;
@@ -657,6 +676,13 @@ ice_cfg_txq_interrupt(struct ice_vsi *vsi, u16 txq, u16 msix_idx, u16 itr_idx)
 	      ((msix_idx << QINT_TQCTL_MSIX_INDX_S) & QINT_TQCTL_MSIX_INDX_M);
 
 	wr32(hw, QINT_TQCTL(vsi->txq_map[txq]), val);
+	if (ice_is_xdp_ena_vsi(vsi)) {
+		u32 xdp_txq = txq + vsi->num_xdp_txq;
+
+		wr32(hw, QINT_TQCTL(vsi->txq_map[xdp_txq]),
+		     val);
+	}
+	ice_flush(hw);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 7e23034df955..6cee99b5865b 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2577,6 +2577,7 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 {
 	struct ice_ring *tx_rings = NULL, *rx_rings = NULL;
 	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_ring *xdp_rings = NULL;
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
 	int i, timeout = 50, err = 0;
@@ -2624,6 +2625,11 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 			vsi->tx_rings[i]->count = new_tx_cnt;
 		for (i = 0; i < vsi->alloc_rxq; i++)
 			vsi->rx_rings[i]->count = new_rx_cnt;
+		if (ice_is_xdp_ena_vsi(vsi))
+			for (i = 0; i < vsi->num_xdp_txq; i++)
+				vsi->xdp_rings[i]->count = new_tx_cnt;
+		vsi->num_tx_desc = new_tx_cnt;
+		vsi->num_rx_desc = new_rx_cnt;
 		netdev_dbg(netdev, "Link is down, descriptor count change happens when link is brought up\n");
 		goto done;
 	}
@@ -2650,15 +2656,43 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 		tx_rings[i].tx_buf = NULL;
 		err = ice_setup_tx_ring(&tx_rings[i]);
 		if (err) {
-			while (i) {
-				i--;
+			while (i--)
 				ice_clean_tx_ring(&tx_rings[i]);
-			}
 			devm_kfree(&pf->pdev->dev, tx_rings);
 			goto done;
 		}
 	}
 
+	if (!ice_is_xdp_ena_vsi(vsi))
+		goto process_rx;
+
+	/* alloc updated XDP resources */
+	netdev_info(netdev, "Changing XDP descriptor count from %d to %d\n",
+		    vsi->xdp_rings[0]->count, new_tx_cnt);
+
+	xdp_rings = devm_kcalloc(&pf->pdev->dev, vsi->num_xdp_txq,
+				 sizeof(*xdp_rings), GFP_KERNEL);
+	if (!xdp_rings) {
+		err = -ENOMEM;
+		goto free_tx;
+	}
+
+	for (i = 0; i < vsi->num_xdp_txq; i++) {
+		/* clone ring and setup updated count */
+		xdp_rings[i] = *vsi->xdp_rings[i];
+		xdp_rings[i].count = new_tx_cnt;
+		xdp_rings[i].desc = NULL;
+		xdp_rings[i].tx_buf = NULL;
+		err = ice_setup_tx_ring(&xdp_rings[i]);
+		if (err) {
+			while (i--)
+				ice_clean_tx_ring(&xdp_rings[i]);
+			devm_kfree(&pf->pdev->dev, xdp_rings);
+			goto free_tx;
+		}
+		ice_set_ring_xdp(&xdp_rings[i]);
+	}
+
 process_rx:
 	if (new_rx_cnt == vsi->rx_rings[0]->count)
 		goto process_link;
@@ -2737,6 +2771,16 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 			devm_kfree(&pf->pdev->dev, rx_rings);
 		}
 
+		if (xdp_rings) {
+			for (i = 0; i < vsi->num_xdp_txq; i++) {
+				ice_free_tx_ring(vsi->xdp_rings[i]);
+				*vsi->xdp_rings[i] = xdp_rings[i];
+			}
+			devm_kfree(&pf->pdev->dev, xdp_rings);
+		}
+
+		vsi->num_tx_desc = new_tx_cnt;
+		vsi->num_rx_desc = new_rx_cnt;
 		ice_up(vsi);
 	}
 	goto done;
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 87f890363608..3794e42b1d69 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -46,7 +46,8 @@ static int ice_vsi_alloc_arrays(struct ice_vsi *vsi)
 	if (!vsi->rx_rings)
 		goto err_rings;
 
-	vsi->txq_map = devm_kcalloc(&pf->pdev->dev, vsi->alloc_txq,
+	/* XDP will have vsi->alloc_txq Tx queues as well, so double the size */
+	vsi->txq_map = devm_kcalloc(&pf->pdev->dev, (2 * vsi->alloc_txq),
 				    sizeof(*vsi->txq_map), GFP_KERNEL);
 
 	if (!vsi->txq_map)
@@ -1183,6 +1184,20 @@ int ice_vsi_kill_vlan(struct ice_vsi *vsi, u16 vid)
 	return err;
 }
 
+/**
+ * ice_vsi_cfg_frame_size - setup max frame size and Rx buffer length
+ * @vsi: VSI
+ */
+void ice_vsi_cfg_frame_size(struct ice_vsi *vsi)
+{
+	if (vsi->netdev && vsi->netdev->mtu > ETH_DATA_LEN)
+		vsi->max_frame = vsi->netdev->mtu + ICE_ETH_PKT_HDR_PAD;
+	else
+		vsi->max_frame = ICE_RXBUF_2048;
+
+	vsi->rx_buf_len = ICE_RXBUF_2048;
+}
+
 /**
  * ice_vsi_cfg_rxqs - Configure the VSI for Rx
  * @vsi: the VSI being configured
@@ -1197,13 +1212,7 @@ int ice_vsi_cfg_rxqs(struct ice_vsi *vsi)
 	if (vsi->type == ICE_VSI_VF)
 		goto setup_rings;
 
-	if (vsi->netdev && vsi->netdev->mtu > ETH_DATA_LEN)
-		vsi->max_frame = vsi->netdev->mtu +
-			ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
-	else
-		vsi->max_frame = ICE_RXBUF_2048;
-
-	vsi->rx_buf_len = ICE_RXBUF_2048;
+	ice_vsi_cfg_frame_size(vsi);
 setup_rings:
 	/* set up individual rings */
 	for (i = 0; i < vsi->num_rxq; i++) {
@@ -1265,6 +1274,18 @@ int ice_vsi_cfg_lan_txqs(struct ice_vsi *vsi)
 	return ice_vsi_cfg_txqs(vsi, vsi->tx_rings);
 }
 
+/**
+ * ice_vsi_cfg_xdp_txqs - Configure Tx queues dedicated for XDP in given VSI
+ * @vsi: the VSI being configured
+ *
+ * Return 0 on success and a negative value on error
+ * Configure the Tx queues dedicated for XDP in given VSI for operation.
+ */
+int ice_vsi_cfg_xdp_txqs(struct ice_vsi *vsi)
+{
+	return ice_vsi_cfg_txqs(vsi, vsi->xdp_rings);
+}
+
 /**
  * ice_intrl_usec_to_reg - convert interrupt rate limit to register value
  * @intrl: interrupt rate limit in usecs
@@ -1488,6 +1509,15 @@ ice_vsi_stop_lan_tx_rings(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 	return ice_vsi_stop_tx_rings(vsi, rst_src, rel_vmvf_num, vsi->tx_rings);
 }
 
+/**
+ * ice_vsi_stop_xdp_tx_rings - Disable XDP Tx rings
+ * @vsi: the VSI being configured
+ */
+int ice_vsi_stop_xdp_tx_rings(struct ice_vsi *vsi)
+{
+	return ice_vsi_stop_tx_rings(vsi, ICE_NO_RESET, 0, vsi->xdp_rings);
+}
+
 /**
  * ice_cfg_vlan_pruning - enable or disable VLAN pruning on the VSI
  * @vsi: VSI to enable or disable VLAN pruning on
@@ -1885,6 +1915,11 @@ static void ice_vsi_release_msix(struct ice_vsi *vsi)
 		wr32(hw, GLINT_ITR(ICE_IDX_ITR1, reg_idx), 0);
 		for (q = 0; q < q_vector->num_ring_tx; q++) {
 			wr32(hw, QINT_TQCTL(vsi->txq_map[txq]), 0);
+			if (ice_is_xdp_ena_vsi(vsi)) {
+				u32 xdp_txq = txq + vsi->num_xdp_txq;
+
+				wr32(hw, QINT_TQCTL(vsi->txq_map[xdp_txq]), 0);
+			}
 			txq++;
 		}
 
@@ -2259,6 +2294,11 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 		vsi->base_vector = 0;
 	}
 
+	if (ice_is_xdp_ena_vsi(vsi))
+		/* return value check can be skipped here, it always returns
+		 * 0 if reset is in progress
+		 */
+		ice_destroy_xdp_rings(vsi);
 	ice_vsi_put_qs(vsi);
 	ice_vsi_clear_rings(vsi);
 	ice_vsi_free_arrays(vsi);
@@ -2299,6 +2339,12 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 			goto err_vectors;
 
 		ice_vsi_map_rings_to_vectors(vsi);
+		if (ice_is_xdp_ena_vsi(vsi)) {
+			vsi->num_xdp_txq = vsi->alloc_txq;
+			ret = ice_prepare_xdp_rings(vsi, vsi->xdp_prog);
+			if (ret)
+				goto err_vectors;
+		}
 		/* Do not exit if configuring RSS had an issue, at least
 		 * receive traffic on first queue. Hence no need to capture
 		 * return value
@@ -2325,9 +2371,13 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 	}
 
 	/* configure VSI nodes based on number of queues and TC's */
-	for (i = 0; i < vsi->tc_cfg.numtc; i++)
+	for (i = 0; i < vsi->tc_cfg.numtc; i++) {
 		max_txqs[i] = vsi->alloc_txq;
 
+		if (ice_is_xdp_ena_vsi(vsi))
+			max_txqs[i] += vsi->num_xdp_txq;
+	}
+
 	status = ice_cfg_vsi_lan(vsi->port_info, vsi->idx, vsi->tc_cfg.ena_tc,
 				 max_txqs);
 	if (status) {
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 2fd5da3d0275..8e92c37a0f21 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -36,6 +36,10 @@ int
 ice_vsi_stop_lan_tx_rings(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 			  u16 rel_vmvf_num);
 
+int ice_vsi_cfg_xdp_txqs(struct ice_vsi *vsi);
+
+int ice_vsi_stop_xdp_tx_rings(struct ice_vsi *vsi);
+
 int ice_cfg_vlan_pruning(struct ice_vsi *vsi, bool ena, bool vlan_promisc);
 
 void ice_cfg_sw_lldp(struct ice_vsi *vsi, bool tx, bool create);
@@ -79,6 +83,8 @@ void ice_vsi_free_tx_rings(struct ice_vsi *vsi);
 
 int ice_vsi_manage_rss_lut(struct ice_vsi *vsi, bool ena);
 
+void ice_vsi_cfg_frame_size(struct ice_vsi *vsi);
+
 u32 ice_intrl_usec_to_reg(u8 intrl, u8 gran);
 
 char *ice_nvm_version_str(struct ice_hw *hw);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index bf9c4438cbfb..3ee61ed21976 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1661,6 +1661,309 @@ static int ice_vsi_req_irq_msix(struct ice_vsi *vsi, char *basename)
 	return err;
 }
 
+/**
+ * ice_xdp_alloc_setup_rings - Allocate and setup Tx rings for XDP
+ * @vsi: VSI to setup Tx rings used by XDP
+ *
+ * Return 0 on success and negative value on error
+ */
+static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
+{
+	struct device *dev = &vsi->back->pdev->dev;
+	int i;
+
+	for (i = 0; i < vsi->num_xdp_txq; i++) {
+		u16 xdp_q_idx = vsi->alloc_txq + i;
+		struct ice_ring *xdp_ring;
+
+		xdp_ring = kzalloc(sizeof(*xdp_ring), GFP_KERNEL);
+
+		if (!xdp_ring)
+			goto free_xdp_rings;
+
+		xdp_ring->q_index = xdp_q_idx;
+		xdp_ring->reg_idx = vsi->txq_map[xdp_q_idx];
+		xdp_ring->ring_active = false;
+		xdp_ring->vsi = vsi;
+		xdp_ring->netdev = NULL;
+		xdp_ring->dev = dev;
+		xdp_ring->count = vsi->num_tx_desc;
+		vsi->xdp_rings[i] = xdp_ring;
+		if (ice_setup_tx_ring(xdp_ring))
+			goto free_xdp_rings;
+		ice_set_ring_xdp(xdp_ring);
+	}
+
+	return 0;
+
+free_xdp_rings:
+	for (; i >= 0; i--)
+		if (vsi->xdp_rings[i] && vsi->xdp_rings[i]->desc)
+			ice_free_tx_ring(vsi->xdp_rings[i]);
+	return -ENOMEM;
+}
+
+/**
+ * ice_vsi_assign_bpf_prog - set or clear bpf prog pointer on VSI
+ * @vsi: VSI to set the bpf prog on
+ * @prog: the bpf prog pointer
+ */
+static void ice_vsi_assign_bpf_prog(struct ice_vsi *vsi, struct bpf_prog *prog)
+{
+	struct bpf_prog *old_prog;
+	int i;
+
+	old_prog = xchg(&vsi->xdp_prog, prog);
+	if (old_prog)
+		bpf_prog_put(old_prog);
+
+	ice_for_each_rxq(vsi, i)
+		WRITE_ONCE(vsi->rx_rings[i]->xdp_prog, vsi->xdp_prog);
+}
+
+/**
+ * ice_prepare_xdp_rings - Allocate, configure and setup Tx rings for XDP
+ * @vsi: VSI to bring up Tx rings used by XDP
+ * @prog: bpf program that will be assigned to VSI
+ *
+ * Return 0 on success and negative value on error
+ */
+int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog)
+{
+	u16 max_txqs[ICE_MAX_TRAFFIC_CLASS] = { 0 };
+	int xdp_rings_rem = vsi->num_xdp_txq;
+	struct ice_pf *pf = vsi->back;
+	struct ice_qs_cfg xdp_qs_cfg = {
+		.qs_mutex = &pf->avail_q_mutex,
+		.pf_map = pf->avail_txqs,
+		.pf_map_size = pf->max_pf_txqs,
+		.q_count = vsi->num_xdp_txq,
+		.scatter_count = ICE_MAX_SCATTER_TXQS,
+		.vsi_map = vsi->txq_map,
+		.vsi_map_offset = vsi->alloc_txq,
+		.mapping_mode = ICE_VSI_MAP_CONTIG
+	};
+	enum ice_status status;
+	int i, v_idx;
+
+	vsi->xdp_rings = devm_kcalloc(&pf->pdev->dev, vsi->num_xdp_txq,
+				      sizeof(*vsi->xdp_rings), GFP_KERNEL);
+	if (!vsi->xdp_rings)
+		return -ENOMEM;
+
+	vsi->xdp_mapping_mode = xdp_qs_cfg.mapping_mode;
+	if (__ice_vsi_get_qs(&xdp_qs_cfg))
+		goto err_map_xdp;
+
+	if (ice_xdp_alloc_setup_rings(vsi))
+		goto clear_xdp_rings;
+
+	/* follow the logic from ice_vsi_map_rings_to_vectors */
+	ice_for_each_q_vector(vsi, v_idx) {
+		struct ice_q_vector *q_vector = vsi->q_vectors[v_idx];
+		int xdp_rings_per_v, q_id, q_base;
+
+		xdp_rings_per_v = DIV_ROUND_UP(xdp_rings_rem,
+					       vsi->num_q_vectors - v_idx);
+		q_base = vsi->num_xdp_txq - xdp_rings_rem;
+
+		for (q_id = q_base; q_id < (q_base + xdp_rings_per_v); q_id++) {
+			struct ice_ring *xdp_ring = vsi->xdp_rings[q_id];
+
+			xdp_ring->q_vector = q_vector;
+			xdp_ring->next = q_vector->tx.ring;
+			q_vector->tx.ring = xdp_ring;
+		}
+		xdp_rings_rem -= xdp_rings_per_v;
+	}
+
+	/* omit the scheduler update if in reset path; XDP queues will be
+	 * taken into account at the end of ice_vsi_rebuild, where
+	 * ice_cfg_vsi_lan is being called
+	 */
+	if (ice_is_reset_in_progress(pf->state))
+		return 0;
+
+	/* tell the Tx scheduler that right now we have
+	 * additional queues
+	 */
+	for (i = 0; i < vsi->tc_cfg.numtc; i++)
+		max_txqs[i] = vsi->num_txq + vsi->num_xdp_txq;
+
+	status = ice_cfg_vsi_lan(vsi->port_info, vsi->idx, vsi->tc_cfg.ena_tc,
+				 max_txqs);
+	if (status) {
+		dev_err(&pf->pdev->dev,
+			"Failed VSI LAN queue config for XDP, error:%d\n",
+			status);
+		goto clear_xdp_rings;
+	}
+	ice_vsi_assign_bpf_prog(vsi, prog);
+
+	return 0;
+clear_xdp_rings:
+	for (i = 0; i < vsi->num_xdp_txq; i++)
+		if (vsi->xdp_rings[i]) {
+			kfree_rcu(vsi->xdp_rings[i], rcu);
+			vsi->xdp_rings[i] = NULL;
+		}
+
+err_map_xdp:
+	mutex_lock(&pf->avail_q_mutex);
+	for (i = 0; i < vsi->num_xdp_txq; i++) {
+		clear_bit(vsi->txq_map[i + vsi->alloc_txq], pf->avail_txqs);
+		vsi->txq_map[i + vsi->alloc_txq] = ICE_INVAL_Q_INDEX;
+	}
+	mutex_unlock(&pf->avail_q_mutex);
+
+	devm_kfree(&pf->pdev->dev, vsi->xdp_rings);
+	return -ENOMEM;
+}
+
+/**
+ * ice_destroy_xdp_rings - undo the configuration made by ice_prepare_xdp_rings
+ * @vsi: VSI to remove XDP rings
+ *
+ * Detach XDP rings from irq vectors, clean up the PF bitmap and free
+ * resources
+ */
+int ice_destroy_xdp_rings(struct ice_vsi *vsi)
+{
+	u16 max_txqs[ICE_MAX_TRAFFIC_CLASS] = { 0 };
+	struct ice_pf *pf = vsi->back;
+	int i, v_idx;
+
+	/* q_vectors are freed in reset path so there's no point in detaching
+	 * rings; in case of rebuild being triggered not from reset reset bits
+	 * in pf->state won't be set, so additionally check first q_vector
+	 * against NULL
+	 */
+	if (ice_is_reset_in_progress(pf->state) || !vsi->q_vectors[0])
+		goto free_qmap;
+
+	ice_for_each_q_vector(vsi, v_idx) {
+		struct ice_q_vector *q_vector = vsi->q_vectors[v_idx];
+		struct ice_ring *ring;
+
+		ice_for_each_ring(ring, q_vector->tx)
+			if (!ring->tx_buf || !ice_ring_is_xdp(ring))
+				break;
+
+		/* restore the value of last node prior to XDP setup */
+		q_vector->tx.ring = ring;
+	}
+
+free_qmap:
+	mutex_lock(&pf->avail_q_mutex);
+	for (i = 0; i < vsi->num_xdp_txq; i++) {
+		clear_bit(vsi->txq_map[i + vsi->alloc_txq], pf->avail_txqs);
+		vsi->txq_map[i + vsi->alloc_txq] = ICE_INVAL_Q_INDEX;
+	}
+	mutex_unlock(&pf->avail_q_mutex);
+
+	for (i = 0; i < vsi->num_xdp_txq; i++)
+		if (vsi->xdp_rings[i]) {
+			if (vsi->xdp_rings[i]->desc)
+				ice_free_tx_ring(vsi->xdp_rings[i]);
+			kfree_rcu(vsi->xdp_rings[i], rcu);
+			vsi->xdp_rings[i] = NULL;
+		}
+
+	devm_kfree(&pf->pdev->dev, vsi->xdp_rings);
+	vsi->xdp_rings = NULL;
+
+	if (ice_is_reset_in_progress(pf->state) || !vsi->q_vectors[0])
+		return 0;
+
+	ice_vsi_assign_bpf_prog(vsi, NULL);
+
+	/* notify Tx scheduler that we destroyed XDP queues and bring
+	 * back the old number of child nodes
+	 */
+	for (i = 0; i < vsi->tc_cfg.numtc; i++)
+		max_txqs[i] = vsi->num_txq;
+
+	return ice_cfg_vsi_lan(vsi->port_info, vsi->idx, vsi->tc_cfg.ena_tc,
+			       max_txqs);
+}
+
+/**
+ * ice_xdp_setup_prog - Add or remove XDP eBPF program
+ * @vsi: VSI to setup XDP for
+ * @prog: XDP program
+ * @extack: netlink extended ack
+ */
+static int
+ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
+		   struct netlink_ext_ack *extack)
+{
+	int frame_size = vsi->netdev->mtu + ICE_ETH_PKT_HDR_PAD;
+	bool if_running = netif_running(vsi->netdev);
+	int ret = 0, xdp_ring_err = 0;
+
+	if (frame_size > vsi->rx_buf_len) {
+		NL_SET_ERR_MSG_MOD(extack, "MTU too large for loading XDP");
+		return -EOPNOTSUPP;
+	}
+
+	/* need to stop netdev while setting up the program for Rx rings */
+	if (if_running && !test_and_set_bit(__ICE_DOWN, vsi->state)) {
+		ret = ice_down(vsi);
+		if (ret) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Preparing device for XDP attach failed");
+			return ret;
+		}
+	}
+
+	if (!ice_is_xdp_ena_vsi(vsi) && prog) {
+		vsi->num_xdp_txq = vsi->alloc_txq;
+		xdp_ring_err = ice_prepare_xdp_rings(vsi, prog);
+		if (xdp_ring_err)
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Setting up XDP Tx resources failed");
+	} else if (ice_is_xdp_ena_vsi(vsi) && !prog) {
+		xdp_ring_err = ice_destroy_xdp_rings(vsi);
+		if (xdp_ring_err)
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Freeing XDP Tx resources failed");
+	} else {
+		ice_vsi_assign_bpf_prog(vsi, prog);
+	}
+
+	if (if_running)
+		ret = ice_up(vsi);
+
+	return (ret || xdp_ring_err) ? -ENOMEM : 0;
+}
+
+/**
+ * ice_xdp - implements XDP handler
+ * @dev: netdevice
+ * @xdp: XDP command
+ */
+static int ice_xdp(struct net_device *dev, struct netdev_bpf *xdp)
+{
+	struct ice_netdev_priv *np = netdev_priv(dev);
+	struct ice_vsi *vsi = np->vsi;
+
+	if (vsi->type != ICE_VSI_PF) {
+		NL_SET_ERR_MSG_MOD(xdp->extack,
+				   "XDP can be loaded only on PF VSI");
+		return -EINVAL;
+	}
+
+	switch (xdp->command) {
+	case XDP_SETUP_PROG:
+		return ice_xdp_setup_prog(vsi, xdp->prog, xdp->extack);
+	case XDP_QUERY_PROG:
+		xdp->prog_id = vsi->xdp_prog ? vsi->xdp_prog->aux->id : 0;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 /**
  * ice_ena_misc_vector - enable the non-queue interrupts
  * @pf: board private structure
@@ -2220,6 +2523,8 @@ static int ice_setup_pf_sw(struct ice_pf *pf)
 		status = -ENODEV;
 		goto unroll_vsi_setup;
 	}
+	/* netdev has to be configured before setting frame size */
+	ice_vsi_cfg_frame_size(vsi);
 
 	/* registering the NAPI handler requires both the queues and
 	 * netdev to be created, which are done in ice_pf_vsi_setup()
@@ -3506,6 +3811,8 @@ int ice_vsi_cfg(struct ice_vsi *vsi)
 	ice_vsi_cfg_dcb_rings(vsi);
 
 	err = ice_vsi_cfg_lan_txqs(vsi);
+	if (!err && ice_is_xdp_ena_vsi(vsi))
+		err = ice_vsi_cfg_xdp_txqs(vsi);
 	if (!err)
 		err = ice_vsi_cfg_rxqs(vsi);
 
@@ -3921,6 +4228,13 @@ int ice_down(struct ice_vsi *vsi)
 		netdev_err(vsi->netdev,
 			   "Failed stop Tx rings, VSI %d error %d\n",
 			   vsi->vsi_num, tx_err);
+	if (!tx_err && ice_is_xdp_ena_vsi(vsi)) {
+		tx_err = ice_vsi_stop_xdp_tx_rings(vsi);
+		if (tx_err)
+			netdev_err(vsi->netdev,
+				   "Failed stop XDP rings, VSI %d error %d\n",
+				   vsi->vsi_num, tx_err);
+	}
 
 	rx_err = ice_vsi_stop_rx_rings(vsi);
 	if (rx_err)
@@ -4348,6 +4662,16 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 		return 0;
 	}
 
+	if (ice_is_xdp_ena_vsi(vsi)) {
+		int frame_size = ICE_RXBUF_2048 - XDP_PACKET_HEADROOM;
+
+		if (new_mtu + ICE_ETH_PKT_HDR_PAD > frame_size) {
+			netdev_err(netdev, "max MTU for XDP usage is %d\n",
+				   frame_size);
+			return -EINVAL;
+		}
+	}
+
 	if (new_mtu < netdev->min_mtu) {
 		netdev_err(netdev, "new MTU invalid. min_mtu is %d\n",
 			   netdev->min_mtu);
@@ -4879,4 +5203,6 @@ static const struct net_device_ops ice_netdev_ops = {
 	.ndo_fdb_add = ice_fdb_add,
 	.ndo_fdb_del = ice_fdb_del,
 	.ndo_tx_timeout = ice_tx_timeout,
+	.ndo_bpf = ice_xdp,
+	.ndo_xdp_xmit = ice_xdp_xmit,
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 33dd103035dc..f79a9376159b 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -5,6 +5,9 @@
 
 #include <linux/prefetch.h>
 #include <linux/mm.h>
+#include <linux/bpf_trace.h>
+#include <net/xdp.h>
+#include "ice_lib.h"
 #include "ice.h"
 #include "ice_dcb_lib.h"
 
@@ -19,7 +22,10 @@ static void
 ice_unmap_and_free_tx_buf(struct ice_ring *ring, struct ice_tx_buf *tx_buf)
 {
 	if (tx_buf->skb) {
-		dev_kfree_skb_any(tx_buf->skb);
+		if (ice_ring_is_xdp(ring))
+			page_frag_free(tx_buf->raw_buf);
+		else
+			dev_kfree_skb_any(tx_buf->skb);
 		if (dma_unmap_len(tx_buf, len))
 			dma_unmap_single(ring->dev,
 					 dma_unmap_addr(tx_buf, dma),
@@ -136,8 +142,11 @@ static bool ice_clean_tx_irq(struct ice_ring *tx_ring, int napi_budget)
 		total_bytes += tx_buf->bytecount;
 		total_pkts += tx_buf->gso_segs;
 
-		/* free the skb */
-		napi_consume_skb(tx_buf->skb, napi_budget);
+		if (ice_ring_is_xdp(tx_ring))
+			page_frag_free(tx_buf->raw_buf);
+		else
+			/* free the skb */
+			napi_consume_skb(tx_buf->skb, napi_budget);
 
 		/* unmap skb header data */
 		dma_unmap_single(tx_ring->dev,
@@ -195,6 +204,9 @@ static bool ice_clean_tx_irq(struct ice_ring *tx_ring, int napi_budget)
 	tx_ring->q_vector->tx.total_bytes += total_bytes;
 	tx_ring->q_vector->tx.total_pkts += total_pkts;
 
+	if (ice_ring_is_xdp(tx_ring))
+		return !!budget;
+
 	netdev_tx_completed_queue(txring_txq(tx_ring), total_pkts,
 				  total_bytes);
 
@@ -319,6 +331,10 @@ void ice_clean_rx_ring(struct ice_ring *rx_ring)
 void ice_free_rx_ring(struct ice_ring *rx_ring)
 {
 	ice_clean_rx_ring(rx_ring);
+	if (rx_ring->vsi->type == ICE_VSI_PF)
+		if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
+			xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
+	rx_ring->xdp_prog = NULL;
 	devm_kfree(rx_ring->dev, rx_ring->rx_buf);
 	rx_ring->rx_buf = NULL;
 
@@ -363,6 +379,15 @@ int ice_setup_rx_ring(struct ice_ring *rx_ring)
 
 	rx_ring->next_to_use = 0;
 	rx_ring->next_to_clean = 0;
+
+	if (ice_is_xdp_ena_vsi(rx_ring->vsi))
+		WRITE_ONCE(rx_ring->xdp_prog, rx_ring->vsi->xdp_prog);
+
+	if (rx_ring->vsi->type == ICE_VSI_PF &&
+	    !xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
+		if (xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
+				     rx_ring->q_index))
+			goto err;
 	return 0;
 
 err:
@@ -402,6 +427,214 @@ static void ice_release_rx_desc(struct ice_ring *rx_ring, u32 val)
 	}
 }
 
+/**
+ * ice_rx_offset - Return expected offset into page to access data
+ * @rx_ring: Ring we are requesting offset of
+ *
+ * Returns the offset value for ring into the data buffer.
+ */
+static unsigned int ice_rx_offset(struct ice_ring *rx_ring)
+{
+	return ice_is_xdp_ena_vsi(rx_ring->vsi) ? XDP_PACKET_HEADROOM : 0;
+}
+
+/**
+ * ice_xdp_ring_update_tail - Updates the XDP Tx ring tail register
+ * @xdp_ring: XDP Tx ring
+ *
+ * This function updates the XDP Tx ring tail register.
+ */
+static void ice_xdp_ring_update_tail(struct ice_ring *xdp_ring)
+{
+	/* Force memory writes to complete before letting h/w
+	 * know there are new descriptors to fetch.
+	 */
+	wmb();
+	writel_relaxed(xdp_ring->next_to_use, xdp_ring->tail);
+}
+
+/**
+ * ice_xmit_xdp_ring - submit single packet to XDP ring for transmission
+ * @data: packet data pointer
+ * @size: packet data size
+ * @xdp_ring: XDP ring for transmission
+ */
+static int ice_xmit_xdp_ring(void *data, u16 size, struct ice_ring *xdp_ring)
+{
+	u16 i = xdp_ring->next_to_use;
+	struct ice_tx_desc *tx_desc;
+	struct ice_tx_buf *tx_buf;
+	dma_addr_t dma;
+
+	if (!unlikely(ICE_DESC_UNUSED(xdp_ring))) {
+		xdp_ring->tx_stats.tx_busy++;
+		return ICE_XDP_CONSUMED;
+	}
+
+	dma = dma_map_single(xdp_ring->dev, data, size, DMA_TO_DEVICE);
+	if (dma_mapping_error(xdp_ring->dev, dma))
+		return ICE_XDP_CONSUMED;
+
+	tx_buf = &xdp_ring->tx_buf[i];
+	tx_buf->bytecount = size;
+	tx_buf->gso_segs = 1;
+	tx_buf->raw_buf = data;
+
+	/* record length, and DMA address */
+	dma_unmap_len_set(tx_buf, len, size);
+	dma_unmap_addr_set(tx_buf, dma, dma);
+
+	tx_desc = ICE_TX_DESC(xdp_ring, i);
+	tx_desc->buf_addr = cpu_to_le64(dma);
+	tx_desc->cmd_type_offset_bsz = build_ctob(ICE_TXD_LAST_DESC_CMD, 0,
+						  size, 0);
+
+	/* Make certain all of the status bits have been updated
+	 * before next_to_watch is written.
+	 */
+	smp_wmb();
+
+	i++;
+	if (i == xdp_ring->count)
+		i = 0;
+
+	tx_buf->next_to_watch = tx_desc;
+	xdp_ring->next_to_use = i;
+
+	return ICE_XDP_TX;
+}
+
+/**
+ * ice_xmit_xdp_buff - convert an XDP buffer to an XDP frame and send it
+ * @xdp: XDP buffer
+ * @xdp_ring: XDP Tx ring
+ *
+ * Returns negative on failure, 0 on success.
+ */
+static int ice_xmit_xdp_buff(struct xdp_buff *xdp, struct ice_ring *xdp_ring)
+{
+	struct xdp_frame *xdpf = convert_to_xdp_frame(xdp);
+
+	if (unlikely(!xdpf))
+		return ICE_XDP_CONSUMED;
+
+	return ice_xmit_xdp_ring(xdpf->data, xdpf->len, xdp_ring);
+}
+
+/**
+ * ice_run_xdp - Executes an XDP program on initialized xdp_buff
+ * @rx_ring: Rx ring
+ * @xdp: xdp_buff used as input to the XDP program
+ * @xdp_prog: XDP program to run
+ *
+ * Returns any of ICE_XDP_{PASS, CONSUMED, TX, REDIR}
+ */
+static int
+ice_run_xdp(struct ice_ring *rx_ring, struct xdp_buff *xdp,
+	    struct bpf_prog *xdp_prog)
+{
+	int err, result = ICE_XDP_PASS;
+	struct ice_ring *xdp_ring;
+	u32 act;
+
+	act = bpf_prog_run_xdp(xdp_prog, xdp);
+	switch (act) {
+	case XDP_PASS:
+		break;
+	case XDP_TX:
+		xdp_ring = rx_ring->vsi->xdp_rings[smp_processor_id()];
+		result = ice_xmit_xdp_buff(xdp, xdp_ring);
+		break;
+	case XDP_REDIRECT:
+		err = xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
+		result = !err ? ICE_XDP_REDIR : ICE_XDP_CONSUMED;
+		break;
+	default:
+		bpf_warn_invalid_xdp_action(act);
+		/* fallthrough -- not supported action */
+	case XDP_ABORTED:
+		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
+		/* fallthrough -- handle aborts by dropping frame */
+	case XDP_DROP:
+		result = ICE_XDP_CONSUMED;
+		break;
+	}
+
+	return result;
+}
+
+/**
+ * ice_xdp_xmit - submit packets to XDP ring for transmission
+ * @dev: netdev
+ * @n: number of XDP frames to be transmitted
+ * @frames: XDP frames to be transmitted
+ * @flags: transmit flags
+ *
+ * Returns number of frames successfully sent. Frames that fail are
+ * free'ed via XDP return API.
+ * For error cases, a negative errno code is returned and no-frames
+ * are transmitted (caller must handle freeing frames).
+ */
+int
+ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
+	     u32 flags)
+{
+	struct ice_netdev_priv *np = netdev_priv(dev);
+	unsigned int queue_index = smp_processor_id();
+	struct ice_vsi *vsi = np->vsi;
+	struct ice_ring *xdp_ring;
+	int drops = 0, i;
+
+	if (test_bit(__ICE_DOWN, vsi->state))
+		return -ENETDOWN;
+
+	if (!ice_is_xdp_ena_vsi(vsi) || queue_index >= vsi->num_xdp_txq)
+		return -ENXIO;
+
+	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
+		return -EINVAL;
+
+	xdp_ring = vsi->xdp_rings[queue_index];
+	for (i = 0; i < n; i++) {
+		struct xdp_frame *xdpf = frames[i];
+		int err;
+
+		err = ice_xmit_xdp_ring(xdpf->data, xdpf->len, xdp_ring);
+		if (err != ICE_XDP_TX) {
+			xdp_return_frame_rx_napi(xdpf);
+			drops++;
+		}
+	}
+
+	if (unlikely(flags & XDP_XMIT_FLUSH))
+		ice_xdp_ring_update_tail(xdp_ring);
+
+	return n - drops;
+}
+
+/**
+ * ice_finalize_xdp_rx - Bump XDP Tx tail and/or flush redirect map
+ * @rx_ring: Rx ring
+ * @xdp_res: Result of the receive batch
+ *
+ * This function bumps XDP Tx tail and/or flush redirect map, and
+ * should be called when a batch of packets has been processed in the
+ * napi loop.
+ */
+static void
+ice_finalize_xdp_rx(struct ice_ring *rx_ring, unsigned int xdp_res)
+{
+	if (xdp_res & ICE_XDP_REDIR)
+		xdp_do_flush_map();
+
+	if (xdp_res & ICE_XDP_TX) {
+		struct ice_ring *xdp_ring =
+			rx_ring->vsi->xdp_rings[rx_ring->q_index];
+
+		ice_xdp_ring_update_tail(xdp_ring);
+	}
+}
+
 /**
  * ice_alloc_mapped_page - recycle or make a new page
  * @rx_ring: ring to use
@@ -444,7 +677,7 @@ ice_alloc_mapped_page(struct ice_ring *rx_ring, struct ice_rx_buf *bi)
 
 	bi->dma = dma;
 	bi->page = page;
-	bi->page_offset = 0;
+	bi->page_offset = ice_rx_offset(rx_ring);
 	page_ref_add(page, USHRT_MAX - 1);
 	bi->pagecnt_bias = USHRT_MAX;
 
@@ -682,7 +915,7 @@ ice_get_rx_buf(struct ice_ring *rx_ring, struct sk_buff **skb,
  * ice_construct_skb - Allocate skb and populate it
  * @rx_ring: Rx descriptor ring to transact packets on
  * @rx_buf: Rx buffer to pull data from
- * @size: the length of the packet
+ * @xdp: xdp_buff pointing to the data
  *
  * This function allocates an skb. It then populates it with the page
  * data from the current receive descriptor, taking care to set up the
@@ -690,16 +923,16 @@ ice_get_rx_buf(struct ice_ring *rx_ring, struct sk_buff **skb,
  */
 static struct sk_buff *
 ice_construct_skb(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
-		  unsigned int size)
+		  struct xdp_buff *xdp)
 {
-	void *va = page_address(rx_buf->page) + rx_buf->page_offset;
+	unsigned int size = xdp->data_end - xdp->data;
 	unsigned int headlen;
 	struct sk_buff *skb;
 
 	/* prefetch first cache line of first page */
-	prefetch(va);
+	prefetch(xdp->data);
 #if L1_CACHE_BYTES < 128
-	prefetch((u8 *)va + L1_CACHE_BYTES);
+	prefetch((void *)(xdp->data + L1_CACHE_BYTES));
 #endif /* L1_CACHE_BYTES */
 
 	/* allocate a skb to store the frags */
@@ -712,10 +945,11 @@ ice_construct_skb(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
 	/* Determine available headroom for copy */
 	headlen = size;
 	if (headlen > ICE_RX_HDR_SIZE)
-		headlen = eth_get_headlen(skb->dev, va, ICE_RX_HDR_SIZE);
+		headlen = eth_get_headlen(skb->dev, xdp->data, ICE_RX_HDR_SIZE);
 
 	/* align pull length to size of long to optimize memcpy performance */
-	memcpy(__skb_put(skb, headlen), va, ALIGN(headlen, sizeof(long)));
+	memcpy(__skb_put(skb, headlen), xdp->data, ALIGN(headlen,
+							 sizeof(long)));
 
 	/* if we exhaust the linear part then add what is left as a frag */
 	size -= headlen;
@@ -745,11 +979,18 @@ ice_construct_skb(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
  * @rx_ring: Rx descriptor ring to transact packets on
  * @rx_buf: Rx buffer to pull data from
  *
- * This function will  clean up the contents of the rx_buf. It will
- * either recycle the buffer or unmap it and free the associated resources.
+ * This function will update next_to_clean and then clean up the contents
+ * of the rx_buf. It will either recycle the buffer or unmap it and free
+ * the associated resources.
  */
 static void ice_put_rx_buf(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
 {
+	u32 ntc = rx_ring->next_to_clean + 1;
+
+	/* fetch, update, and store next to clean */
+	ntc = (ntc < rx_ring->count) ? ntc : 0;
+	rx_ring->next_to_clean = ntc;
+
 	if (!rx_buf)
 		return;
 
@@ -813,30 +1054,20 @@ ice_test_staterr(union ice_32b_rx_flex_desc *rx_desc, const u16 stat_err_bits)
  * @rx_desc: Rx descriptor for current buffer
  * @skb: Current socket buffer containing buffer in progress
  *
- * This function updates next to clean. If the buffer is an EOP buffer
- * this function exits returning false, otherwise it will place the
- * sk_buff in the next buffer to be chained and return true indicating
- * that this is in fact a non-EOP buffer.
+ * If the buffer is an EOP buffer, this function exits returning false,
+ * otherwise return true indicating that this is in fact a non-EOP buffer.
  */
 static bool
 ice_is_non_eop(struct ice_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc,
 	       struct sk_buff *skb)
 {
-	u32 ntc = rx_ring->next_to_clean + 1;
-
-	/* fetch, update, and store next to clean */
-	ntc = (ntc < rx_ring->count) ? ntc : 0;
-	rx_ring->next_to_clean = ntc;
-
-	prefetch(ICE_RX_DESC(rx_ring, ntc));
-
 	/* if we are the last buffer then there is nothing else to do */
 #define ICE_RXD_EOF BIT(ICE_RX_FLEX_DESC_STATUS0_EOF_S)
 	if (likely(ice_test_staterr(rx_desc, ICE_RXD_EOF)))
 		return false;
 
 	/* place skb in next buffer to be received */
-	rx_ring->rx_buf[ntc].skb = skb;
+	rx_ring->rx_buf[rx_ring->next_to_clean].skb = skb;
 	rx_ring->rx_stats.non_eop_descs++;
 
 	return true;
@@ -1006,8 +1237,13 @@ static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 {
 	unsigned int total_rx_bytes = 0, total_rx_pkts = 0;
 	u16 cleaned_count = ICE_DESC_UNUSED(rx_ring);
+	unsigned int xdp_res, xdp_xmit = 0;
+	struct bpf_prog *xdp_prog = NULL;
+	struct xdp_buff xdp;
 	bool failure;
 
+	xdp.rxq = &rx_ring->xdp_rxq;
+
 	/* start the loop to process Rx packets bounded by 'budget' */
 	while (likely(total_rx_pkts < (unsigned int)budget)) {
 		union ice_32b_rx_flex_desc *rx_desc;
@@ -1042,10 +1278,46 @@ static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		/* retrieve a buffer from the ring */
 		rx_buf = ice_get_rx_buf(rx_ring, &skb, size);
 
+		if (!size) {
+			xdp.data = NULL;
+			xdp.data_end = NULL;
+			goto construct_skb;
+		}
+
+		xdp.data = page_address(rx_buf->page) + rx_buf->page_offset;
+		xdp.data_hard_start = xdp.data - ice_rx_offset(rx_ring);
+		xdp_set_data_meta_invalid(&xdp);
+		xdp.data_end = xdp.data + size;
+
+		rcu_read_lock();
+		xdp_prog = READ_ONCE(rx_ring->xdp_prog);
+		if (!xdp_prog) {
+			rcu_read_unlock();
+			goto construct_skb;
+		}
+
+		xdp_res = ice_run_xdp(rx_ring, &xdp, xdp_prog);
+		rcu_read_unlock();
+		if (xdp_res) {
+			if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR)) {
+				xdp_xmit |= xdp_res;
+				ice_rx_buf_adjust_pg_offset(rx_buf,
+							    ICE_RXBUF_2048);
+			} else {
+				rx_buf->pagecnt_bias++;
+			}
+			total_rx_bytes += size;
+			total_rx_pkts++;
+
+			cleaned_count++;
+			ice_put_rx_buf(rx_ring, rx_buf);
+			continue;
+		}
+construct_skb:
 		if (skb)
 			ice_add_rx_frag(rx_buf, skb, size);
 		else
-			skb = ice_construct_skb(rx_ring, rx_buf, size);
+			skb = ice_construct_skb(rx_ring, rx_buf, &xdp);
 
 		/* exit if we failed to retrieve a buffer */
 		if (!skb) {
@@ -1099,6 +1371,9 @@ static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 	/* return up to cleaned_count buffers to hardware */
 	failure = ice_alloc_rx_bufs(rx_ring, cleaned_count);
 
+	if (xdp_prog)
+		ice_finalize_xdp_rx(rx_ring, xdp_xmit);
+
 	/* update queue and vector specific stats */
 	u64_stats_update_begin(&rx_ring->syncp);
 	rx_ring->stats.pkts += total_rx_pkts;
@@ -1527,17 +1802,6 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 	return min_t(int, work_done, budget - 1);
 }
 
-/* helper function for building cmd/type/offset */
-static __le64
-build_ctob(u64 td_cmd, u64 td_offset, unsigned int size, u64 td_tag)
-{
-	return cpu_to_le64(ICE_TX_DESC_DTYPE_DATA |
-			   (td_cmd    << ICE_TXD_QW1_CMD_S) |
-			   (td_offset << ICE_TXD_QW1_OFFSET_S) |
-			   ((u64)size << ICE_TXD_QW1_TX_BUF_SZ_S) |
-			   (td_tag    << ICE_TXD_QW1_L2TAG1_S));
-}
-
 /**
  * __ice_maybe_stop_tx - 2nd level check for Tx stop conditions
  * @tx_ring: the ring to be checked
@@ -1689,9 +1953,9 @@ ice_tx_map(struct ice_ring *tx_ring, struct ice_tx_buf *first,
 		i = 0;
 
 	/* write last descriptor with RS and EOP bits */
-	td_cmd |= (u64)(ICE_TX_DESC_CMD_EOP | ICE_TX_DESC_CMD_RS);
-	tx_desc->cmd_type_offset_bsz =
-			build_ctob(td_cmd, td_offset, size, td_tag);
+	td_cmd |= (u64)ICE_TXD_LAST_DESC_CMD;
+	tx_desc->cmd_type_offset_bsz = build_ctob(td_cmd, td_offset, size,
+						  td_tag);
 
 	/* Force memory writes to complete before letting h/w know there
 	 * are new descriptors to fetch.
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index a914e603b2ed..e40b4cb54ce3 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -22,6 +22,16 @@
 #define ICE_RX_BUF_WRITE	16	/* Must be power of 2 */
 #define ICE_MAX_TXQ_PER_TXQG	128
 
+static inline __le64
+build_ctob(u64 td_cmd, u64 td_offset, unsigned int size, u64 td_tag)
+{
+	return cpu_to_le64(ICE_TX_DESC_DTYPE_DATA |
+			   (td_cmd    << ICE_TXD_QW1_CMD_S) |
+			   (td_offset << ICE_TXD_QW1_OFFSET_S) |
+			   ((u64)size << ICE_TXD_QW1_TX_BUF_SZ_S) |
+			   (td_tag    << ICE_TXD_QW1_L2TAG1_S));
+}
+
 /* We are assuming that the cache line is always 64 Bytes here for ice.
  * In order to make sure that is a correct assumption there is a check in probe
  * to print a warning if the read from GLPCI_CNF2 tells us that the cache line
@@ -49,12 +59,24 @@
 #define ICE_TX_FLAGS_VLAN_PR_S	29
 #define ICE_TX_FLAGS_VLAN_S	16
 
+#define ICE_XDP_PASS		0
+#define ICE_XDP_CONSUMED	BIT(0)
+#define ICE_XDP_TX		BIT(1)
+#define ICE_XDP_REDIR		BIT(2)
+
 #define ICE_RX_DMA_ATTR \
 	(DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
 
+#define ICE_ETH_PKT_HDR_PAD	(ETH_HLEN + ETH_FCS_LEN + (VLAN_HLEN * 2))
+
+#define ICE_TXD_LAST_DESC_CMD (ICE_TX_DESC_CMD_EOP | ICE_TX_DESC_CMD_RS)
+
 struct ice_tx_buf {
 	struct ice_tx_desc *next_to_watch;
-	struct sk_buff *skb;
+	union {
+		struct sk_buff *skb;
+		void *raw_buf; /* used for XDP */
+	};
 	unsigned int bytecount;
 	unsigned short gso_segs;
 	u32 tx_flags;
@@ -198,9 +220,14 @@ struct ice_ring {
 	};
 
 	struct rcu_head rcu;		/* to avoid race on free */
+	struct bpf_prog *xdp_prog;
+	/* CL3 - 3rd cacheline starts here */
+	struct xdp_rxq_info xdp_rxq;
 	/* CLX - the below items are only accessed infrequently and should be
 	 * in their own cache line if possible
 	 */
+#define ICE_TX_FLAGS_RING_XDP		BIT(0)
+	u8 flags;
 	dma_addr_t dma;			/* physical address of ring */
 	unsigned int size;		/* length of descriptor ring in bytes */
 	u32 txq_teid;			/* Added Tx queue TEID */
@@ -208,6 +235,11 @@ struct ice_ring {
 	u8 dcb_tc;			/* Traffic class of ring */
 } ____cacheline_internodealigned_in_smp;
 
+static inline bool ice_ring_is_xdp(struct ice_ring *ring)
+{
+	return !!(ring->flags & ICE_TX_FLAGS_RING_XDP);
+}
+
 struct ice_ring_container {
 	/* head of linked-list of rings */
 	struct ice_ring *ring;
-- 
2.21.0

