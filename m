Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93779160198
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 04:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbgBPDoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 22:44:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:33359 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726652AbgBPDoz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 22:44:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Feb 2020 19:44:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,447,1574150400"; 
   d="scan'208";a="257916574"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga004.fm.intel.com with ESMTP; 15 Feb 2020 19:44:53 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/15] ice: Add initial support for QinQ
Date:   Sat, 15 Feb 2020 19:44:38 -0800
Message-Id: <20200216034452.1251706-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200216034452.1251706-1-jeffrey.t.kirsher@intel.com>
References: <20200216034452.1251706-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Allow support for S-Tag + C-Tag VLAN traffic by disabling pruning when
there are no 0x8100 VLAN interfaces currently created on top of the PF.
When an 0x8100 VLAN interface is configured, enable pruning and only
support single and double C-Tag VLAN traffic. If all of the 0x8100
interfaces that were created on top of the PF are removed via
ethtool -K <iface> rx-vlan-filter off or via ip tools, then disable
pruning and allow S-Tag + C-Tag traffic again.

Add VLAN 0 filter by default for the PF. This is because a bridge
sets the default_pvid to 1, sends the request down to
ice_vlan_rx_add_vid(), and we never get the request to add VLAN 0 via
the 8021q module which causes all untagged traffic to be dropped.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c      | 43 +++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_lib.h      |  2 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 21 ++++++---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 14 +++---
 4 files changed, 63 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index d974e2fa3e63..263d25630072 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1348,7 +1348,9 @@ int ice_vsi_add_vlan(struct ice_vsi *vsi, u16 vid)
 	list_add(&tmp->list_entry, &tmp_add_list);
 
 	status = ice_add_vlan(&pf->hw, &tmp_add_list);
-	if (status) {
+	if (!status) {
+		vsi->num_vlan++;
+	} else {
 		err = -ENODEV;
 		dev_err(dev, "Failure Adding VLAN %d on VSI %i\n", vid,
 			vsi->vsi_num);
@@ -1390,10 +1392,12 @@ int ice_vsi_kill_vlan(struct ice_vsi *vsi, u16 vid)
 	list_add(&list->list_entry, &tmp_add_list);
 
 	status = ice_remove_vlan(&pf->hw, &tmp_add_list);
-	if (status == ICE_ERR_DOES_NOT_EXIST) {
+	if (!status) {
+		vsi->num_vlan--;
+	} else if (status == ICE_ERR_DOES_NOT_EXIST) {
 		dev_dbg(dev, "Failed to remove VLAN %d on VSI %i, it does not exist, status: %d\n",
 			vid, vsi->vsi_num, status);
-	} else if (status) {
+	} else {
 		dev_err(dev, "Error removing VLAN %d on vsi %i error: %d\n",
 			vid, vsi->vsi_num, status);
 		err = -EIO;
@@ -1755,6 +1759,26 @@ int ice_vsi_stop_xdp_tx_rings(struct ice_vsi *vsi)
 	return ice_vsi_stop_tx_rings(vsi, ICE_NO_RESET, 0, vsi->xdp_rings);
 }
 
+/**
+ * ice_vsi_is_vlan_pruning_ena - check if VLAN pruning is enabled or not
+ * @vsi: VSI to check whether or not VLAN pruning is enabled.
+ *
+ * returns true if Rx VLAN pruning and Tx VLAN anti-spoof is enabled and false
+ * otherwise.
+ */
+bool ice_vsi_is_vlan_pruning_ena(struct ice_vsi *vsi)
+{
+	u8 rx_pruning = ICE_AQ_VSI_SW_FLAG_RX_VLAN_PRUNE_ENA;
+	u8 tx_pruning = ICE_AQ_VSI_SEC_TX_VLAN_PRUNE_ENA <<
+		ICE_AQ_VSI_SEC_TX_PRUNE_ENA_S;
+
+	if (!vsi)
+		return false;
+
+	return ((vsi->info.sw_flags2 & rx_pruning) &&
+		(vsi->info.sec_flags & tx_pruning));
+}
+
 /**
  * ice_cfg_vlan_pruning - enable or disable VLAN pruning on the VSI
  * @vsi: VSI to enable or disable VLAN pruning on
@@ -2025,6 +2049,17 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 		if (ret)
 			goto unroll_vector_base;
 
+		/* Always add VLAN ID 0 switch rule by default. This is needed
+		 * in order to allow all untagged and 0 tagged priority traffic
+		 * if Rx VLAN pruning is enabled. Also there are cases where we
+		 * don't get the call to add VLAN 0 via ice_vlan_rx_add_vid()
+		 * so this handles those cases (i.e. adding the PF to a bridge
+		 * without the 8021q module loaded).
+		 */
+		ret = ice_vsi_add_vlan(vsi, 0);
+		if (ret)
+			goto unroll_clear_rings;
+
 		ice_vsi_map_rings_to_vectors(vsi);
 
 		/* Do not exit if configuring RSS had an issue, at least
@@ -2104,6 +2139,8 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 
 	return vsi;
 
+unroll_clear_rings:
+	ice_vsi_clear_rings(vsi);
 unroll_vector_base:
 	/* reclaim SW interrupts back to the common pool */
 	ice_free_res(pf->irq_tracker, vsi->base_vector, vsi->idx);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index e2c0dadce920..3c87e6b509ed 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -42,6 +42,8 @@ int ice_vsi_cfg_xdp_txqs(struct ice_vsi *vsi);
 
 int ice_vsi_stop_xdp_tx_rings(struct ice_vsi *vsi);
 
+bool ice_vsi_is_vlan_pruning_ena(struct ice_vsi *vsi);
+
 int ice_cfg_vlan_pruning(struct ice_vsi *vsi, bool ena, bool vlan_promisc);
 
 void ice_cfg_sw_lldp(struct ice_vsi *vsi, bool tx, bool create);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 5ef28052c0f8..bd6e84f51fd4 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2461,16 +2461,19 @@ ice_vlan_rx_add_vid(struct net_device *netdev, __always_unused __be16 proto,
 	if (vsi->info.pvid)
 		return -EINVAL;
 
-	/* Enable VLAN pruning when VLAN 0 is added */
-	if (unlikely(!vid)) {
+	/* VLAN 0 is added by default during load/reset */
+	if (!vid)
+		return 0;
+
+	/* Enable VLAN pruning when a VLAN other than 0 is added */
+	if (!ice_vsi_is_vlan_pruning_ena(vsi)) {
 		ret = ice_cfg_vlan_pruning(vsi, true, false);
 		if (ret)
 			return ret;
 	}
 
-	/* Add all VLAN IDs including 0 to the switch filter. VLAN ID 0 is
-	 * needed to continue allowing all untagged packets since VLAN prune
-	 * list is applied to all packets by the switch
+	/* Add a switch rule for this VLAN ID so its corresponding VLAN tagged
+	 * packets aren't pruned by the device's internal switch on Rx
 	 */
 	ret = ice_vsi_add_vlan(vsi, vid);
 	if (!ret) {
@@ -2500,6 +2503,10 @@ ice_vlan_rx_kill_vid(struct net_device *netdev, __always_unused __be16 proto,
 	if (vsi->info.pvid)
 		return -EINVAL;
 
+	/* don't allow removal of VLAN 0 */
+	if (!vid)
+		return 0;
+
 	/* Make sure ice_vsi_kill_vlan is successful before updating VLAN
 	 * information
 	 */
@@ -2507,8 +2514,8 @@ ice_vlan_rx_kill_vid(struct net_device *netdev, __always_unused __be16 proto,
 	if (ret)
 		return ret;
 
-	/* Disable VLAN pruning when VLAN 0 is removed */
-	if (unlikely(!vid))
+	/* Disable pruning when VLAN 0 is the only VLAN rule */
+	if (vsi->num_vlan == 1 && ice_vsi_is_vlan_pruning_ena(vsi))
 		ret = ice_cfg_vlan_pruning(vsi, false, false);
 
 	vsi->vlan_ena = false;
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 262714d5f54a..a8178a73ccd1 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2868,9 +2868,9 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 				goto error_param;
 			}
 
-			vsi->num_vlan++;
-			/* Enable VLAN pruning when VLAN is added */
-			if (!vlan_promisc) {
+			/* Enable VLAN pruning when non-zero VLAN is added */
+			if (!vlan_promisc && vid &&
+			    !ice_vsi_is_vlan_pruning_ena(vsi)) {
 				status = ice_cfg_vlan_pruning(vsi, true, false);
 				if (status) {
 					v_ret = VIRTCHNL_STATUS_ERR_PARAM;
@@ -2878,7 +2878,7 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 						vid, status);
 					goto error_param;
 				}
-			} else {
+			} else if (vlan_promisc) {
 				/* Enable Ucast/Mcast VLAN promiscuous mode */
 				promisc_m = ICE_PROMISC_VLAN_TX |
 					    ICE_PROMISC_VLAN_RX;
@@ -2922,9 +2922,9 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 				goto error_param;
 			}
 
-			vsi->num_vlan--;
-			/* Disable VLAN pruning when the last VLAN is removed */
-			if (!vsi->num_vlan)
+			/* Disable VLAN pruning when only VLAN 0 is left */
+			if (vsi->num_vlan == 1 &&
+			    ice_vsi_is_vlan_pruning_ena(vsi))
 				ice_cfg_vlan_pruning(vsi, false, false);
 
 			/* Disable Unicast/Multicast VLAN promiscuous mode */
-- 
2.24.1

