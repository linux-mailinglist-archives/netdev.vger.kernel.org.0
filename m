Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AB9350A8D
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 01:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbhCaXHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 19:07:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:62991 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231650AbhCaXH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 19:07:27 -0400
IronPort-SDR: H+1cMmqLiDSkDAIpHBkrKPFQ8vAxwjAzpaDBh2g2vLsNNU1FqAb5Kxu4MeBoCRF2A2sORGDpf7
 cBpgx0JirHuA==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="191587986"
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="191587986"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 16:07:25 -0700
IronPort-SDR: hJt93aoDdpU4aBwDKEFhMsGJDd+mqp5LsWgXk5Kn8tRNUrX/GvzVRvtLKy8fuawPt24dYhzZ6B
 NtIXvl4DK25Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="610680145"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 31 Mar 2021 16:07:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 13/15] ice: Consolidate VSI state and flags
Date:   Wed, 31 Mar 2021 16:08:56 -0700
Message-Id: <20210331230858.782492-14-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
References: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

struct ice_vsi has two fields, state and flags which seem to
be serving the same purpose. Consolidate them into one field
'state'.

enum ice_state is used to represent state information of the PF.
While some of these enum values can be use to represent VSI state,
it makes more sense to represent VSI state with its own enum. So
derive a new enum ice_vsi_state from ice_vsi_flags and ice_state
and use it. Also rename enum ice_state to ice_pf_state for clarity.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         | 21 ++++----
 drivers/net/ethernet/intel/ice/ice_ethtool.c |  2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c     | 14 +++---
 drivers/net/ethernet/intel/ice/ice_main.c    | 50 ++++++++++----------
 drivers/net/ethernet/intel/ice/ice_txrx.c    |  6 +--
 5 files changed, 47 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 17705db51022..02badaaf818c 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -193,7 +193,7 @@ struct ice_sw {
 	u8 dflt_vsi_ena:1;	/* true if above dflt_vsi is enabled */
 };
 
-enum ice_state {
+enum ice_pf_state {
 	__ICE_TESTING,
 	__ICE_DOWN,
 	__ICE_NEEDS_RESTART,
@@ -236,12 +236,14 @@ enum ice_state {
 	__ICE_STATE_NBITS		/* must be last */
 };
 
-enum ice_vsi_flags {
-	ICE_VSI_FLAG_UMAC_FLTR_CHANGED,
-	ICE_VSI_FLAG_MMAC_FLTR_CHANGED,
-	ICE_VSI_FLAG_VLAN_FLTR_CHANGED,
-	ICE_VSI_FLAG_PROMISC_CHANGED,
-	ICE_VSI_FLAG_NBITS		/* must be last */
+enum ice_vsi_state {
+	ICE_VSI_DOWN,
+	ICE_VSI_NEEDS_RESTART,
+	ICE_VSI_UMAC_FLTR_CHANGED,
+	ICE_VSI_MMAC_FLTR_CHANGED,
+	ICE_VSI_VLAN_FLTR_CHANGED,
+	ICE_VSI_PROMISC_CHANGED,
+	ICE_VSI_STATE_NBITS		/* must be last */
 };
 
 /* struct that defines a VSI, associated with a dev */
@@ -257,8 +259,7 @@ struct ice_vsi {
 	irqreturn_t (*irq_handler)(int irq, void *data);
 
 	u64 tx_linearize;
-	DECLARE_BITMAP(state, __ICE_STATE_NBITS);
-	DECLARE_BITMAP(flags, ICE_VSI_FLAG_NBITS);
+	DECLARE_BITMAP(state, ICE_VSI_STATE_NBITS);
 	unsigned int current_netdev_flags;
 	u32 tx_restart;
 	u32 tx_busy;
@@ -504,7 +505,7 @@ ice_irq_dynamic_ena(struct ice_hw *hw, struct ice_vsi *vsi,
 	val = GLINT_DYN_CTL_INTENA_M | GLINT_DYN_CTL_CLEARPBA_M |
 	      (itr << GLINT_DYN_CTL_ITR_INDX_S);
 	if (vsi)
-		if (test_bit(__ICE_DOWN, vsi->state))
+		if (test_bit(ICE_VSI_DOWN, vsi->state))
 			return;
 	wr32(hw, GLINT_DYN_CTL(vector), val);
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 998629b9767f..15152e63f204 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2886,7 +2886,7 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring)
 	/* Bring interface down, copy in the new ring info, then restore the
 	 * interface. if VSI is up, bring it down and then back up
 	 */
-	if (!test_and_set_bit(__ICE_DOWN, vsi->state)) {
+	if (!test_and_set_bit(ICE_VSI_DOWN, vsi->state)) {
 		ice_down(vsi);
 
 		if (tx_rings) {
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index d3b99b1ea32a..6041ca2830de 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -422,7 +422,7 @@ ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type vsi_type, u16 vf_id)
 
 	vsi->type = vsi_type;
 	vsi->back = pf;
-	set_bit(__ICE_DOWN, vsi->state);
+	set_bit(ICE_VSI_DOWN, vsi->state);
 
 	if (vsi_type == ICE_VSI_VF)
 		ice_vsi_set_num_qs(vsi, vf_id);
@@ -2593,7 +2593,7 @@ void ice_vsi_free_rx_rings(struct ice_vsi *vsi)
  */
 void ice_vsi_close(struct ice_vsi *vsi)
 {
-	if (!test_and_set_bit(__ICE_DOWN, vsi->state))
+	if (!test_and_set_bit(ICE_VSI_DOWN, vsi->state))
 		ice_down(vsi);
 
 	ice_vsi_free_irq(vsi);
@@ -2610,10 +2610,10 @@ int ice_ena_vsi(struct ice_vsi *vsi, bool locked)
 {
 	int err = 0;
 
-	if (!test_bit(__ICE_NEEDS_RESTART, vsi->state))
+	if (!test_bit(ICE_VSI_NEEDS_RESTART, vsi->state))
 		return 0;
 
-	clear_bit(__ICE_NEEDS_RESTART, vsi->state);
+	clear_bit(ICE_VSI_NEEDS_RESTART, vsi->state);
 
 	if (vsi->netdev && vsi->type == ICE_VSI_PF) {
 		if (netif_running(vsi->netdev)) {
@@ -2639,10 +2639,10 @@ int ice_ena_vsi(struct ice_vsi *vsi, bool locked)
  */
 void ice_dis_vsi(struct ice_vsi *vsi, bool locked)
 {
-	if (test_bit(__ICE_DOWN, vsi->state))
+	if (test_bit(ICE_VSI_DOWN, vsi->state))
 		return;
 
-	set_bit(__ICE_NEEDS_RESTART, vsi->state);
+	set_bit(ICE_VSI_NEEDS_RESTART, vsi->state);
 
 	if (vsi->type == ICE_VSI_PF && vsi->netdev) {
 		if (netif_running(vsi->netdev)) {
@@ -2812,7 +2812,7 @@ int ice_vsi_release(struct ice_vsi *vsi)
 	ice_vsi_free_q_vectors(vsi);
 
 	/* make sure unregister_netdev() was called by checking __ICE_DOWN */
-	if (vsi->netdev && test_bit(__ICE_DOWN, vsi->state)) {
+	if (vsi->netdev && test_bit(ICE_VSI_DOWN, vsi->state)) {
 		free_netdev(vsi->netdev);
 		vsi->netdev = NULL;
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 9410af2067d2..b3c1cadecf21 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -84,7 +84,7 @@ static void ice_check_for_hang_subtask(struct ice_pf *pf)
 			break;
 		}
 
-	if (!vsi || test_bit(__ICE_DOWN, vsi->state))
+	if (!vsi || test_bit(ICE_VSI_DOWN, vsi->state))
 		return;
 
 	if (!(vsi->netdev && netif_carrier_ok(vsi->netdev)))
@@ -198,9 +198,9 @@ static int ice_add_mac_to_unsync_list(struct net_device *netdev, const u8 *addr)
  */
 static bool ice_vsi_fltr_changed(struct ice_vsi *vsi)
 {
-	return test_bit(ICE_VSI_FLAG_UMAC_FLTR_CHANGED, vsi->flags) ||
-	       test_bit(ICE_VSI_FLAG_MMAC_FLTR_CHANGED, vsi->flags) ||
-	       test_bit(ICE_VSI_FLAG_VLAN_FLTR_CHANGED, vsi->flags);
+	return test_bit(ICE_VSI_UMAC_FLTR_CHANGED, vsi->state) ||
+	       test_bit(ICE_VSI_MMAC_FLTR_CHANGED, vsi->state) ||
+	       test_bit(ICE_VSI_VLAN_FLTR_CHANGED, vsi->state);
 }
 
 /**
@@ -267,9 +267,9 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 	INIT_LIST_HEAD(&vsi->tmp_unsync_list);
 
 	if (ice_vsi_fltr_changed(vsi)) {
-		clear_bit(ICE_VSI_FLAG_UMAC_FLTR_CHANGED, vsi->flags);
-		clear_bit(ICE_VSI_FLAG_MMAC_FLTR_CHANGED, vsi->flags);
-		clear_bit(ICE_VSI_FLAG_VLAN_FLTR_CHANGED, vsi->flags);
+		clear_bit(ICE_VSI_UMAC_FLTR_CHANGED, vsi->state);
+		clear_bit(ICE_VSI_MMAC_FLTR_CHANGED, vsi->state);
+		clear_bit(ICE_VSI_VLAN_FLTR_CHANGED, vsi->state);
 
 		/* grab the netdev's addr_list_lock */
 		netif_addr_lock_bh(netdev);
@@ -350,8 +350,8 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 	}
 
 	if (((changed_flags & IFF_PROMISC) || promisc_forced_on) ||
-	    test_bit(ICE_VSI_FLAG_PROMISC_CHANGED, vsi->flags)) {
-		clear_bit(ICE_VSI_FLAG_PROMISC_CHANGED, vsi->flags);
+	    test_bit(ICE_VSI_PROMISC_CHANGED, vsi->state)) {
+		clear_bit(ICE_VSI_PROMISC_CHANGED, vsi->state);
 		if (vsi->current_netdev_flags & IFF_PROMISC) {
 			/* Apply Rx filter rule to get traffic from wire */
 			if (!ice_is_dflt_vsi_in_use(pf->first_sw)) {
@@ -384,12 +384,12 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 	goto exit;
 
 out_promisc:
-	set_bit(ICE_VSI_FLAG_PROMISC_CHANGED, vsi->flags);
+	set_bit(ICE_VSI_PROMISC_CHANGED, vsi->state);
 	goto exit;
 out:
 	/* if something went wrong then set the changed flag so we try again */
-	set_bit(ICE_VSI_FLAG_UMAC_FLTR_CHANGED, vsi->flags);
-	set_bit(ICE_VSI_FLAG_MMAC_FLTR_CHANGED, vsi->flags);
+	set_bit(ICE_VSI_UMAC_FLTR_CHANGED, vsi->state);
+	set_bit(ICE_VSI_MMAC_FLTR_CHANGED, vsi->state);
 exit:
 	clear_bit(__ICE_CFG_BUSY, vsi->state);
 	return err;
@@ -753,7 +753,7 @@ static void ice_vsi_link_event(struct ice_vsi *vsi, bool link_up)
 	if (!vsi)
 		return;
 
-	if (test_bit(__ICE_DOWN, vsi->state) || !vsi->netdev)
+	if (test_bit(ICE_VSI_DOWN, vsi->state) || !vsi->netdev)
 		return;
 
 	if (vsi->type == ICE_VSI_PF) {
@@ -2009,7 +2009,7 @@ static void ice_check_media_subtask(struct ice_pf *pf)
 		/* PHY settings are reset on media insertion, reconfigure
 		 * PHY to preserve settings.
 		 */
-		if (test_bit(__ICE_DOWN, vsi->state) &&
+		if (test_bit(ICE_VSI_DOWN, vsi->state) &&
 		    test_bit(ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA, vsi->back->flags))
 			return;
 
@@ -2520,7 +2520,7 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 	}
 
 	/* need to stop netdev while setting up the program for Rx rings */
-	if (if_running && !test_and_set_bit(__ICE_DOWN, vsi->state)) {
+	if (if_running && !test_and_set_bit(ICE_VSI_DOWN, vsi->state)) {
 		ret = ice_down(vsi);
 		if (ret) {
 			NL_SET_ERR_MSG_MOD(extack, "Preparing device for XDP attach failed");
@@ -3103,7 +3103,7 @@ ice_vlan_rx_add_vid(struct net_device *netdev, __always_unused __be16 proto,
 	 */
 	ret = ice_vsi_add_vlan(vsi, vid, ICE_FWD_TO_VSI);
 	if (!ret)
-		set_bit(ICE_VSI_FLAG_VLAN_FLTR_CHANGED, vsi->flags);
+		set_bit(ICE_VSI_VLAN_FLTR_CHANGED, vsi->state);
 
 	return ret;
 }
@@ -3142,7 +3142,7 @@ ice_vlan_rx_kill_vid(struct net_device *netdev, __always_unused __be16 proto,
 	if (vsi->num_vlan == 1 && ice_vsi_is_vlan_pruning_ena(vsi))
 		ret = ice_cfg_vlan_pruning(vsi, false, false);
 
-	set_bit(ICE_VSI_FLAG_VLAN_FLTR_CHANGED, vsi->flags);
+	set_bit(ICE_VSI_VLAN_FLTR_CHANGED, vsi->state);
 	return ret;
 }
 
@@ -4973,8 +4973,8 @@ static void ice_set_rx_mode(struct net_device *netdev)
 	 * ndo_set_rx_mode may be triggered even without a change in netdev
 	 * flags
 	 */
-	set_bit(ICE_VSI_FLAG_UMAC_FLTR_CHANGED, vsi->flags);
-	set_bit(ICE_VSI_FLAG_MMAC_FLTR_CHANGED, vsi->flags);
+	set_bit(ICE_VSI_UMAC_FLTR_CHANGED, vsi->state);
+	set_bit(ICE_VSI_MMAC_FLTR_CHANGED, vsi->state);
 	set_bit(ICE_FLAG_FLTR_SYNC, vsi->back->flags);
 
 	/* schedule our worker thread which will take care of
@@ -5247,7 +5247,7 @@ static int ice_up_complete(struct ice_vsi *vsi)
 	if (err)
 		return err;
 
-	clear_bit(__ICE_DOWN, vsi->state);
+	clear_bit(ICE_VSI_DOWN, vsi->state);
 	ice_napi_enable_all(vsi);
 	ice_vsi_ena_irq(vsi);
 
@@ -5390,7 +5390,7 @@ void ice_update_vsi_stats(struct ice_vsi *vsi)
 	struct ice_eth_stats *cur_es = &vsi->eth_stats;
 	struct ice_pf *pf = vsi->back;
 
-	if (test_bit(__ICE_DOWN, vsi->state) ||
+	if (test_bit(ICE_VSI_DOWN, vsi->state) ||
 	    test_bit(__ICE_CFG_BUSY, pf->state))
 		return;
 
@@ -5595,7 +5595,7 @@ void ice_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
 	 * But, only call the update routine and read the registers if VSI is
 	 * not down.
 	 */
-	if (!test_bit(__ICE_DOWN, vsi->state))
+	if (!test_bit(ICE_VSI_DOWN, vsi->state))
 		ice_update_vsi_ring_stats(vsi);
 	stats->tx_packets = vsi_stats->tx_packets;
 	stats->tx_bytes = vsi_stats->tx_bytes;
@@ -5795,7 +5795,7 @@ int ice_vsi_open_ctrl(struct ice_vsi *vsi)
 	if (err)
 		goto err_up_complete;
 
-	clear_bit(__ICE_DOWN, vsi->state);
+	clear_bit(ICE_VSI_DOWN, vsi->state);
 	ice_vsi_ena_irq(vsi);
 
 	return 0;
@@ -6182,7 +6182,7 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 	netdev->mtu = (unsigned int)new_mtu;
 
 	/* if VSI is up, bring it down and then back up */
-	if (!test_and_set_bit(__ICE_DOWN, vsi->state)) {
+	if (!test_and_set_bit(ICE_VSI_DOWN, vsi->state)) {
 		int err;
 
 		err = ice_down(vsi);
@@ -6651,7 +6651,7 @@ static void ice_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 	default:
 		netdev_err(netdev, "tx_timeout recovery unsuccessful, device is in unrecoverable state.\n");
 		set_bit(__ICE_DOWN, pf->state);
-		set_bit(__ICE_NEEDS_RESTART, vsi->state);
+		set_bit(ICE_VSI_NEEDS_RESTART, vsi->state);
 		set_bit(__ICE_SERVICE_DIS, pf->state);
 		break;
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index c71f2fbbb262..dfdf2c1fa9d3 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -309,7 +309,7 @@ static bool ice_clean_tx_irq(struct ice_ring *tx_ring, int napi_budget)
 		smp_mb();
 		if (__netif_subqueue_stopped(tx_ring->netdev,
 					     tx_ring->q_index) &&
-		    !test_bit(__ICE_DOWN, vsi->state)) {
+		    !test_bit(ICE_VSI_DOWN, vsi->state)) {
 			netif_wake_subqueue(tx_ring->netdev,
 					    tx_ring->q_index);
 			++tx_ring->tx_stats.restart_q;
@@ -569,7 +569,7 @@ ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 	struct ice_ring *xdp_ring;
 	int nxmit = 0, i;
 
-	if (test_bit(__ICE_DOWN, vsi->state))
+	if (test_bit(ICE_VSI_DOWN, vsi->state))
 		return -ENETDOWN;
 
 	if (!ice_is_xdp_ena_vsi(vsi) || queue_index >= vsi->num_xdp_txq)
@@ -1520,7 +1520,7 @@ static void ice_update_ena_itr(struct ice_q_vector *q_vector)
 			q_vector->itr_countdown--;
 	}
 
-	if (!test_bit(__ICE_DOWN, vsi->state))
+	if (!test_bit(ICE_VSI_DOWN, vsi->state))
 		wr32(&vsi->back->hw, GLINT_DYN_CTL(q_vector->reg_idx), itr_val);
 }
 
-- 
2.26.2

