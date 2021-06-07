Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865CE39E489
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhFGQxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:53:10 -0400
Received: from mga07.intel.com ([134.134.136.100]:16642 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231435AbhFGQxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:53:05 -0400
IronPort-SDR: pCiEjo81D56oPTW5fiNSi3hrj0rw/ifctg4WRPlv06a3U84kkIM3Y1FPmyXeetdAxqlqM79sny
 j/HErz9sWw8w==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="268516245"
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="268516245"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 09:50:53 -0700
IronPort-SDR: JO+xTUV/VT18Z+JUU+On3OZKyO0BSeVzgwhI3SosbgS4YN/rM3AD1g0+WSmdHA2kvs2Tl27dtN
 fore3a7aROxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="484841221"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jun 2021 09:50:52 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 02/15] ice: Manage VF's MAC address for both legacy and new cases
Date:   Mon,  7 Jun 2021 09:53:12 -0700
Message-Id: <20210607165325.182087-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
References: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently there is no way for a VF driver to specify if it wants to
change it's hardware address. New bits are being added to virtchnl.h
in struct virtchnl_ether_addr that allow for the VF to correctly
communicate this information. However, legacy VF drivers that don't
support the new virtchnl.h bits still need to be supported. Make a
best effort attempt at saving the VF's primary/device address in the
legacy case and depend on the VIRTCHNL_ETHER_ADDR_PRIMARY type for
the new case.

Legacy case - If a unicast MAC is being added and the
hw_lan_addr.addr is empty, then populate it. This assumes that the
address is the VF's hardware address. If a unicast MAC is being
added and the hw_lan_addr.addr is not empty, then cache it in the
legacy_last_added_umac.addr. If a unicast MAC is being deleted and it
matches the hw_lan_addr.addr, then zero the hw_lan_addr.addr.
Also, if the legacy_last_added_umac.addr has not expired, copy the
legacy_last_added_umac.addr into the hw_lan_addr.addr. This is done
because we cannot guarantee the order of VIRTCHNL_OP_ADD_ETH_ADDR and
VIRTCHNL_OP_DEL_ETH_ADDR.

New case - If a unicast MAC is being added and it's specified as
VIRTCHNL_ETHER_ADDR_PRIMARY, then replace the current
hw_lan_addr.addr. If a unicast MAC is being deleted and it's type
is specified as VIRTCHNL_ETHER_ADDR_PRIMARY, then zero the
hw_lan_addr.addr.

Untrusted VFs - Only allow above legacy/new changes to their
hardware address if the PF has not set it administratively via
iproute2.

Trusted VFs - Always allow above legacy/new changes to their
hardware address even if the PF has administratively set it via
iproute2.

Also, change the variable dflt_lan_addr to hw_lan_addr to clearly
represent the purpose of this variable since it's purpose is to
act as a hardware programmed MAC address for the VF.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 160 +++++++++++++++---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |   8 +-
 2 files changed, 141 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index a1d22d2aa0bd..b0a15b821b15 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -937,12 +937,12 @@ static int ice_vf_rebuild_host_mac_cfg(struct ice_vf *vf)
 
 	vf->num_mac++;
 
-	if (is_valid_ether_addr(vf->dflt_lan_addr.addr)) {
-		status = ice_fltr_add_mac(vsi, vf->dflt_lan_addr.addr,
+	if (is_valid_ether_addr(vf->hw_lan_addr.addr)) {
+		status = ice_fltr_add_mac(vsi, vf->hw_lan_addr.addr,
 					  ICE_FWD_TO_VSI);
 		if (status) {
 			dev_err(dev, "failed to add default unicast MAC filter %pM for VF %u, error %s\n",
-				&vf->dflt_lan_addr.addr[0], vf->vf_id,
+				&vf->hw_lan_addr.addr[0], vf->vf_id,
 				ice_stat_str(status));
 			return ice_status_to_errno(status);
 		}
@@ -2379,7 +2379,7 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 	vfres->vsi_res[0].vsi_type = VIRTCHNL_VSI_SRIOV;
 	vfres->vsi_res[0].num_queue_pairs = vsi->num_txq;
 	ether_addr_copy(vfres->vsi_res[0].default_mac_addr,
-			vf->dflt_lan_addr.addr);
+			vf->hw_lan_addr.addr);
 
 	/* match guest capabilities */
 	vf->driver_caps = vfres->vf_cap_flags;
@@ -3659,20 +3659,94 @@ static bool ice_can_vf_change_mac(struct ice_vf *vf)
 	return true;
 }
 
+/**
+ * ice_vc_ether_addr_type - get type of virtchnl_ether_addr
+ * @vc_ether_addr: used to extract the type
+ */
+static u8
+ice_vc_ether_addr_type(struct virtchnl_ether_addr *vc_ether_addr)
+{
+	return (vc_ether_addr->type & VIRTCHNL_ETHER_ADDR_TYPE_MASK);
+}
+
+/**
+ * ice_is_vc_addr_legacy - check if the MAC address is from an older VF
+ * @vc_ether_addr: VIRTCHNL structure that contains MAC and type
+ */
+static bool
+ice_is_vc_addr_legacy(struct virtchnl_ether_addr *vc_ether_addr)
+{
+	u8 type = ice_vc_ether_addr_type(vc_ether_addr);
+
+	return (type == VIRTCHNL_ETHER_ADDR_LEGACY);
+}
+
+/**
+ * ice_is_vc_addr_primary - check if the MAC address is the VF's primary MAC
+ * @vc_ether_addr: VIRTCHNL structure that contains MAC and type
+ *
+ * This function should only be called when the MAC address in
+ * virtchnl_ether_addr is a valid unicast MAC
+ */
+static bool
+ice_is_vc_addr_primary(struct virtchnl_ether_addr __maybe_unused *vc_ether_addr)
+{
+	u8 type = ice_vc_ether_addr_type(vc_ether_addr);
+
+	return (type == VIRTCHNL_ETHER_ADDR_PRIMARY);
+}
+
+/**
+ * ice_vfhw_mac_add - update the VF's cached hardware MAC if allowed
+ * @vf: VF to update
+ * @vc_ether_addr: structure from VIRTCHNL with MAC to add
+ */
+static void
+ice_vfhw_mac_add(struct ice_vf *vf, struct virtchnl_ether_addr *vc_ether_addr)
+{
+	u8 *mac_addr = vc_ether_addr->addr;
+
+	if (!is_valid_ether_addr(mac_addr))
+		return;
+
+	/* only allow legacy VF drivers to set the hardware MAC if it is zero
+	 * and allow new VF drivers to set the hardware MAC if the type was
+	 * correctly specified over VIRTCHNL
+	 */
+	if ((ice_is_vc_addr_legacy(vc_ether_addr) &&
+	     is_zero_ether_addr(vf->hw_lan_addr.addr)) ||
+	    ice_is_vc_addr_primary(vc_ether_addr))
+		ether_addr_copy(vf->hw_lan_addr.addr, mac_addr);
+
+	/* hardware MAC is already set, but its possible that the VF driver sent
+	 * the VIRTCHNL_OP_ADD_ETH_ADDR message before the
+	 * VIRTCHNL_OP_DEL_ETH_ADDR when trying to update its MAC, so save it
+	 * away for the legacy VF driver case as it will be updated in the
+	 * delete flow for this case
+	 */
+	if (ice_is_vc_addr_legacy(vc_ether_addr)) {
+		ether_addr_copy(vf->legacy_last_added_umac.addr,
+				mac_addr);
+		vf->legacy_last_added_umac.time_modified = jiffies;
+	}
+}
+
 /**
  * ice_vc_add_mac_addr - attempt to add the MAC address passed in
  * @vf: pointer to the VF info
  * @vsi: pointer to the VF's VSI
- * @mac_addr: MAC address to add
+ * @vc_ether_addr: VIRTCHNL MAC address structure used to add MAC
  */
 static int
-ice_vc_add_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi, u8 *mac_addr)
+ice_vc_add_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi,
+		    struct virtchnl_ether_addr *vc_ether_addr)
 {
 	struct device *dev = ice_pf_to_dev(vf->pf);
+	u8 *mac_addr = vc_ether_addr->addr;
 	enum ice_status status;
 
 	/* default unicast MAC already added */
-	if (ether_addr_equal(mac_addr, vf->dflt_lan_addr.addr))
+	if (ether_addr_equal(mac_addr, vf->hw_lan_addr.addr))
 		return 0;
 
 	if (is_unicast_ether_addr(mac_addr) && !ice_can_vf_change_mac(vf)) {
@@ -3691,32 +3765,66 @@ ice_vc_add_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi, u8 *mac_addr)
 		return -EIO;
 	}
 
-	/* Set the default LAN address to the latest unicast MAC address added
-	 * by the VF. The default LAN address is reported by the PF via
-	 * ndo_get_vf_config.
-	 */
-	if (is_unicast_ether_addr(mac_addr))
-		ether_addr_copy(vf->dflt_lan_addr.addr, mac_addr);
+	ice_vfhw_mac_add(vf, vc_ether_addr);
 
 	vf->num_mac++;
 
 	return 0;
 }
 
+/**
+ * ice_is_legacy_umac_expired - check if last added legacy unicast MAC expired
+ * @last_added_umac: structure used to check expiration
+ */
+static bool ice_is_legacy_umac_expired(struct ice_time_mac *last_added_umac)
+{
+#define ICE_LEGACY_VF_MAC_CHANGE_EXPIRE_TIME	msecs_to_jiffies(3000)
+	return time_is_before_jiffies(last_added_umac->time_modified +
+				      ICE_LEGACY_VF_MAC_CHANGE_EXPIRE_TIME);
+}
+
+/**
+ * ice_vfhw_mac_del - update the VF's cached hardware MAC if allowed
+ * @vf: VF to update
+ * @vc_ether_addr: structure from VIRTCHNL with MAC to delete
+ */
+static void
+ice_vfhw_mac_del(struct ice_vf *vf, struct virtchnl_ether_addr *vc_ether_addr)
+{
+	u8 *mac_addr = vc_ether_addr->addr;
+
+	if (!is_valid_ether_addr(mac_addr) ||
+	    !ether_addr_equal(vf->hw_lan_addr.addr, mac_addr))
+		return;
+
+	/* allow the hardware MAC to be repopulated in the add flow */
+	eth_zero_addr(vf->hw_lan_addr.addr);
+
+	/* only update cached hardware MAC for legacy VF drivers on delete
+	 * because we cannot guarantee order/type of MAC from the VF driver
+	 */
+	if (ice_is_vc_addr_legacy(vc_ether_addr) &&
+	    !ice_is_legacy_umac_expired(&vf->legacy_last_added_umac))
+		ether_addr_copy(vf->hw_lan_addr.addr,
+				vf->legacy_last_added_umac.addr);
+}
+
 /**
  * ice_vc_del_mac_addr - attempt to delete the MAC address passed in
  * @vf: pointer to the VF info
  * @vsi: pointer to the VF's VSI
- * @mac_addr: MAC address to delete
+ * @vc_ether_addr: VIRTCHNL MAC address structure used to delete MAC
  */
 static int
-ice_vc_del_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi, u8 *mac_addr)
+ice_vc_del_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi,
+		    struct virtchnl_ether_addr *vc_ether_addr)
 {
 	struct device *dev = ice_pf_to_dev(vf->pf);
+	u8 *mac_addr = vc_ether_addr->addr;
 	enum ice_status status;
 
 	if (!ice_can_vf_change_mac(vf) &&
-	    ether_addr_equal(mac_addr, vf->dflt_lan_addr.addr))
+	    ether_addr_equal(mac_addr, vf->hw_lan_addr.addr))
 		return 0;
 
 	status = ice_fltr_remove_mac(vsi, mac_addr, ICE_FWD_TO_VSI);
@@ -3730,8 +3838,7 @@ ice_vc_del_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi, u8 *mac_addr)
 		return -EIO;
 	}
 
-	if (ether_addr_equal(mac_addr, vf->dflt_lan_addr.addr))
-		eth_zero_addr(vf->dflt_lan_addr.addr);
+	ice_vfhw_mac_del(vf, vc_ether_addr);
 
 	vf->num_mac--;
 
@@ -3750,7 +3857,8 @@ static int
 ice_vc_handle_mac_addr_msg(struct ice_vf *vf, u8 *msg, bool set)
 {
 	int (*ice_vc_cfg_mac)
-		(struct ice_vf *vf, struct ice_vsi *vsi, u8 *mac_addr);
+		(struct ice_vf *vf, struct ice_vsi *vsi,
+		 struct virtchnl_ether_addr *virtchnl_ether_addr);
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
 	struct virtchnl_ether_addr_list *al =
 	    (struct virtchnl_ether_addr_list *)msg;
@@ -3799,7 +3907,7 @@ ice_vc_handle_mac_addr_msg(struct ice_vf *vf, u8 *msg, bool set)
 		    is_zero_ether_addr(mac_addr))
 			continue;
 
-		result = ice_vc_cfg_mac(vf, vsi, mac_addr);
+		result = ice_vc_cfg_mac(vf, vsi, &al->list[i]);
 		if (result == -EEXIST || result == -ENOENT) {
 			continue;
 		} else if (result) {
@@ -4437,7 +4545,7 @@ ice_get_vf_cfg(struct net_device *netdev, int vf_id, struct ifla_vf_info *ivi)
 		return -EBUSY;
 
 	ivi->vf = vf_id;
-	ether_addr_copy(ivi->mac, vf->dflt_lan_addr.addr);
+	ether_addr_copy(ivi->mac, vf->hw_lan_addr.addr);
 
 	/* VF configuration for VLAN and applicable QoS */
 	ivi->vlan = vf->port_vlan_info & VLAN_VID_MASK;
@@ -4513,7 +4621,7 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 
 	vf = &pf->vf[vf_id];
 	/* nothing left to do, unicast MAC already set */
-	if (ether_addr_equal(vf->dflt_lan_addr.addr, mac))
+	if (ether_addr_equal(vf->hw_lan_addr.addr, mac))
 		return 0;
 
 	ret = ice_check_vf_ready_for_cfg(vf);
@@ -4529,7 +4637,7 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 	/* VF is notified of its new MAC via the PF's response to the
 	 * VIRTCHNL_OP_GET_VF_RESOURCES message after the VF has been reset
 	 */
-	ether_addr_copy(vf->dflt_lan_addr.addr, mac);
+	ether_addr_copy(vf->hw_lan_addr.addr, mac);
 	if (is_zero_ether_addr(mac)) {
 		/* VF will send VIRTCHNL_OP_ADD_ETH_ADDR message with its MAC */
 		vf->pf_set_mac = false;
@@ -4682,7 +4790,7 @@ void ice_print_vf_rx_mdd_event(struct ice_vf *vf)
 
 	dev_info(dev, "%d Rx Malicious Driver Detection events detected on PF %d VF %d MAC %pM. mdd-auto-reset-vfs=%s\n",
 		 vf->mdd_rx_events.count, pf->hw.pf_id, vf->vf_id,
-		 vf->dflt_lan_addr.addr,
+		 vf->hw_lan_addr.addr,
 		 test_bit(ICE_FLAG_MDD_AUTO_RESET_VF, pf->flags)
 			  ? "on" : "off");
 }
@@ -4726,7 +4834,7 @@ void ice_print_vfs_mdd_events(struct ice_pf *pf)
 
 			dev_info(dev, "%d Tx Malicious Driver Detection events detected on PF %d VF %d MAC %pM.\n",
 				 vf->mdd_tx_events.count, hw->pf_id, i,
-				 vf->dflt_lan_addr.addr);
+				 vf->hw_lan_addr.addr);
 		}
 	}
 }
@@ -4816,7 +4924,7 @@ ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
 
 			if (pf_vsi)
 				dev_warn(dev, "VF MAC %pM on PF MAC %pM is generating asynchronous messages and may be overflowing the PF message queue. Please see the Adapter User Guide for more information\n",
-					 &vf->dflt_lan_addr.addr[0],
+					 &vf->hw_lan_addr.addr[0],
 					 pf_vsi->netdev->dev_addr);
 		}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index d800ed83d6c3..91749c67129b 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -58,6 +58,11 @@ enum ice_virtchnl_cap {
 	ICE_VIRTCHNL_VF_CAP_PRIVILEGE,
 };
 
+struct ice_time_mac {
+	unsigned long time_modified;
+	u8 addr[ETH_ALEN];
+};
+
 /* VF MDD events print structure */
 struct ice_mdd_vf_events {
 	u16 count;			/* total count of Rx|Tx events */
@@ -78,7 +83,8 @@ struct ice_vf {
 	struct ice_sw *vf_sw_id;	/* switch ID the VF VSIs connect to */
 	struct virtchnl_version_info vf_ver;
 	u32 driver_caps;		/* reported by VF driver */
-	struct virtchnl_ether_addr dflt_lan_addr;
+	struct virtchnl_ether_addr hw_lan_addr;
+	struct ice_time_mac legacy_last_added_umac;
 	DECLARE_BITMAP(txq_ena, ICE_MAX_RSS_QS_PER_VF);
 	DECLARE_BITMAP(rxq_ena, ICE_MAX_RSS_QS_PER_VF);
 	u16 port_vlan_info;		/* Port VLAN ID and QoS */
-- 
2.26.2

