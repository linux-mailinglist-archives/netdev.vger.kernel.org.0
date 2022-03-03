Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A77844CC7BC
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 22:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236490AbiCCVPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 16:15:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236457AbiCCVPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 16:15:50 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10EF4F9C5
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 13:14:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646342083; x=1677878083;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2Z9RK/xVj3003U9yY4iVvk4aqh3mBndeADPe7NK2bN4=;
  b=XP4pDuzZAub6KHxvBVdDqghdwUVETXQLeHzUBfiZ4Qf+X2PdHw6ya5eP
   4XBKZwHUCglnyIxEySnElMIOTK/bwad1tfwT3nsyRoBGYwRbO0CxC9s0E
   Aqj7igY6VW4/tDryi4wizkZ3ZjM0Ulq9QjBFzzlIk5XWawr9Ly20Q2I2l
   qNxh+e0As1oJqvl3rXsN7HKII++ZyU2X12eTxiuYo8Msx+lTgDDG6WCdf
   Q0GdEtQdr1vsNzOrWn8/8cwNPsMAJTD2a7ZWtSlj7JVyq9AdoEuMtfpmi
   c9qUxM0wNWVP2ZEWLqDnc8hkIg20KGIiVHFB25sDRX/06cDm9TM8j1s72
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="340245738"
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="340245738"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 13:14:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="640347734"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 03 Mar 2022 13:14:42 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 10/11] ice: introduce VF accessor functions
Date:   Thu,  3 Mar 2022 13:14:48 -0800
Message-Id: <20220303211449.899956-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220303211449.899956-1-anthony.l.nguyen@intel.com>
References: <20220303211449.899956-1-anthony.l.nguyen@intel.com>
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

From: Jacob Keller <jacob.e.keller@intel.com>

Before we switch the VF data structure storage mechanism to a hash,
introduce new accessor functions to define the new interface.

* ice_get_vf_by_id is a function used to obtain a reference to a VF from
  the table based on its VF ID
* ice_has_vfs is used to quickly check if any VFs are configured
* ice_get_num_vfs is used to get an exact count of how many VFs are
  configured

We can drop the old ice_validate_vf_id function, since every caller was
just going to immediately access the VF table to get a reference
anyways. This way we simply use the single ice_get_vf_by_id to both
validate the VF ID is within range and that there exists a VF with that
ID.

This change enables us to more easily convert the codebase to the hash
table since most callers now properly use the interface.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c  |   6 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      |   4 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 131 +++++++++++-------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  25 ++++
 5 files changed, 115 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index 7bcba782f74c..c27013afcadb 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -182,10 +182,10 @@ static void ice_eswitch_remap_rings_to_vectors(struct ice_pf *pf)
 		struct ice_repr *repr;
 		struct ice_vf *vf;
 
-		if (WARN_ON(q_id >= pf->vfs.num_alloc))
+		vf = ice_get_vf_by_id(pf, q_id);
+		if (WARN_ON(!vf))
 			continue;
 
-		vf = &pf->vfs.table[q_id];
 		repr = vf->repr;
 		q_vector = repr->q_vector;
 		tx_ring = vsi->tx_rings[q_id];
@@ -535,7 +535,7 @@ ice_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	if (pf->eswitch_mode == mode)
 		return 0;
 
-	if (pf->vfs.num_alloc) {
+	if (ice_has_vfs(pf)) {
 		dev_info(ice_pf_to_dev(pf), "Changing eswitch mode is allowed only if there is no VFs created");
 		NL_SET_ERR_MSG_MOD(extack, "Changing eswitch mode is allowed only if there is no VFs created");
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 1181f41ff5fe..83680eaa3565 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1297,7 +1297,7 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 	}
 
 	if (test_bit(ICE_FLAG_VF_VLAN_PRUNING, change_flags) &&
-	    pf->vfs.num_alloc) {
+	    ice_has_vfs(pf)) {
 		dev_err(dev, "vf-vlan-pruning: VLAN pruning cannot be changed while VFs are active.\n");
 		/* toggle bit back to previous state */
 		change_bit(ICE_FLAG_VF_VLAN_PRUNING, pf->flags);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index ebb7d74fa7b0..6ea1d9741808 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -215,8 +215,8 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, struct ice_vf *vf)
 		/* The number of queues for ctrl VSI is equal to number of VFs.
 		 * Each ring is associated to the corresponding VF_PR netdev.
 		 */
-		vsi->alloc_txq = pf->vfs.num_alloc;
-		vsi->alloc_rxq = pf->vfs.num_alloc;
+		vsi->alloc_txq = ice_get_num_vfs(pf);
+		vsi->alloc_rxq = vsi->alloc_txq;
 		vsi->num_q_vectors = 1;
 		break;
 	case ICE_VSI_VF:
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index fd83fa39d0cf..535d5f1a763f 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -175,18 +175,58 @@ struct ice_vsi *ice_get_vf_vsi(struct ice_vf *vf)
 }
 
 /**
- * ice_validate_vf_id - helper to check if VF ID is valid
- * @pf: pointer to the PF structure
- * @vf_id: the ID of the VF to check
+ * ice_get_vf_by_id - Get pointer to VF by ID
+ * @pf: the PF private structure
+ * @vf_id: the VF ID to locate
+ *
+ * Locate and return a pointer to the VF structure associated with a given ID.
+ * Returns NULL if the ID does not have a valid VF structure associated with
+ * it.
  */
-static int ice_validate_vf_id(struct ice_pf *pf, u16 vf_id)
+struct ice_vf *ice_get_vf_by_id(struct ice_pf *pf, u16 vf_id)
 {
-	/* vf_id range is only valid for 0-255, and should always be unsigned */
+	if (!pf->vfs.table) {
+		dev_err(ice_pf_to_dev(pf), "VF table not allocated\n");
+		return NULL;
+	}
+
 	if (vf_id >= pf->vfs.num_alloc) {
-		dev_err(ice_pf_to_dev(pf), "Invalid VF ID: %u\n", vf_id);
-		return -EINVAL;
+		dev_err(ice_pf_to_dev(pf), "Out of range VF ID: %u\n",
+			vf_id);
+		return NULL;
 	}
-	return 0;
+
+	return &pf->vfs.table[vf_id];
+}
+
+/**
+ * ice_has_vfs - Return true if the PF has any associated VFs
+ * @pf: the PF private structure
+ *
+ * Return whether or not the PF has any allocated VFs.
+ *
+ * Note that this function only guarantees that there are no VFs at the point
+ * of calling it. It does not guarantee that no more VFs will be added.
+ */
+bool ice_has_vfs(struct ice_pf *pf)
+{
+	return pf->vfs.table && pf->vfs.num_alloc > 0;
+}
+
+/**
+ * ice_get_num_vfs - Get number of allocated VFs
+ * @pf: the PF private structure
+ *
+ * Return the total number of allocated VFs. NOTE: VF IDs are not guaranteed
+ * to be contiguous. Do not assume that a VF ID is guaranteed to be less than
+ * the output of this function.
+ */
+u16 ice_get_num_vfs(struct ice_pf *pf)
+{
+	if (!pf->vfs.table)
+		return 0;
+
+	return pf->vfs.num_alloc;
 }
 
 /**
@@ -503,7 +543,7 @@ void ice_free_vfs(struct ice_pf *pf)
 	struct ice_vf *vf;
 	unsigned int bkt;
 
-	if (!vfs->table)
+	if (!ice_has_vfs(pf))
 		return;
 
 	ice_eswitch_release(pf);
@@ -1464,7 +1504,7 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 	unsigned int bkt;
 
 	/* If we don't have any VFs, then there is nothing to reset */
-	if (!pf->vfs.num_alloc)
+	if (!ice_has_vfs(pf))
 		return false;
 
 	/* clear all malicious info if the VFs are getting reset */
@@ -1709,7 +1749,7 @@ void ice_vc_notify_reset(struct ice_pf *pf)
 {
 	struct virtchnl_pf_event pfe;
 
-	if (!pf->vfs.num_alloc)
+	if (!ice_has_vfs(pf))
 		return;
 
 	pfe.event = VIRTCHNL_EVENT_RESET_IMPENDING;
@@ -1725,14 +1765,7 @@ void ice_vc_notify_reset(struct ice_pf *pf)
 static void ice_vc_notify_vf_reset(struct ice_vf *vf)
 {
 	struct virtchnl_pf_event pfe;
-	struct ice_pf *pf;
-
-	if (!vf)
-		return;
-
-	pf = vf->pf;
-	if (ice_validate_vf_id(pf, vf->vf_id))
-		return;
+	struct ice_pf *pf = vf->pf;
 
 	/* Bail out if VF is in disabled state, neither initialized, nor active
 	 * state - otherwise proceed with notifications
@@ -2097,7 +2130,7 @@ void ice_process_vflr_event(struct ice_pf *pf)
 	u32 reg;
 
 	if (!test_and_clear_bit(ICE_VFLR_EVENT_PENDING, pf->state) ||
-	    !pf->vfs.num_alloc)
+	    !ice_has_vfs(pf))
 		return;
 
 	ice_for_each_vf(pf, bkt, vf) {
@@ -2968,10 +3001,11 @@ int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena)
 	int ret;
 
 	dev = ice_pf_to_dev(pf);
-	if (ice_validate_vf_id(pf, vf_id))
+
+	vf = ice_get_vf_by_id(pf, vf_id);
+	if (!vf)
 		return -EINVAL;
 
-	vf = &pf->vfs.table[vf_id];
 	ret = ice_check_vf_ready_for_cfg(vf);
 	if (ret)
 		return ret;
@@ -4159,8 +4193,6 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 	int ret;
 
 	dev = ice_pf_to_dev(pf);
-	if (ice_validate_vf_id(pf, vf_id))
-		return -EINVAL;
 
 	if (vlan_id >= VLAN_N_VID || qos > 7) {
 		dev_err(dev, "Invalid Port VLAN parameters for VF %d, ID %d, QoS %d\n",
@@ -4174,7 +4206,10 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 		return -EPROTONOSUPPORT;
 	}
 
-	vf = &pf->vfs.table[vf_id];
+	vf = ice_get_vf_by_id(pf, vf_id);
+	if (!vf)
+		return -EINVAL;
+
 	ret = ice_check_vf_ready_for_cfg(vf);
 	if (ret)
 		return ret;
@@ -5722,14 +5757,14 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 	int err = 0;
 
 	dev = ice_pf_to_dev(pf);
-	if (ice_validate_vf_id(pf, vf_id)) {
+
+	vf = ice_get_vf_by_id(pf, vf_id);
+	if (!vf) {
 		dev_err(dev, "Unable to locate VF for message from VF ID %d, opcode %d, len %d\n",
 			vf_id, v_opcode, msglen);
 		return;
 	}
 
-	vf = &pf->vfs.table[vf_id];
-
 	/* Check if VF is disabled. */
 	if (test_bit(ICE_VF_STATE_DIS, vf->vf_states)) {
 		err = -EPERM;
@@ -5898,14 +5933,15 @@ ice_get_vf_cfg(struct net_device *netdev, int vf_id, struct ifla_vf_info *ivi)
 {
 	struct ice_pf *pf = ice_netdev_to_pf(netdev);
 	struct ice_vf *vf;
+	int ret;
 
-	if (ice_validate_vf_id(pf, vf_id))
+	vf = ice_get_vf_by_id(pf, vf_id);
+	if (!vf)
 		return -EINVAL;
 
-	vf = &pf->vfs.table[vf_id];
-
-	if (ice_check_vf_init(pf, vf))
-		return -EBUSY;
+	ret = ice_check_vf_ready_for_cfg(vf);
+	if (ret)
+		return ret;
 
 	ivi->vf = vf_id;
 	ether_addr_copy(ivi->mac, vf->hw_lan_addr.addr);
@@ -5976,15 +6012,15 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 	struct ice_vf *vf;
 	int ret;
 
-	if (ice_validate_vf_id(pf, vf_id))
-		return -EINVAL;
-
 	if (is_multicast_ether_addr(mac)) {
 		netdev_err(netdev, "%pM not a valid unicast address\n", mac);
 		return -EINVAL;
 	}
 
-	vf = &pf->vfs.table[vf_id];
+	vf = ice_get_vf_by_id(pf, vf_id);
+	if (!vf)
+		return -EINVAL;
+
 	/* nothing left to do, unicast MAC already set */
 	if (ether_addr_equal(vf->dev_lan_addr.addr, mac) &&
 	    ether_addr_equal(vf->hw_lan_addr.addr, mac))
@@ -6043,10 +6079,10 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 		return -EOPNOTSUPP;
 	}
 
-	if (ice_validate_vf_id(pf, vf_id))
+	vf = ice_get_vf_by_id(pf, vf_id);
+	if (!vf)
 		return -EINVAL;
 
-	vf = &pf->vfs.table[vf_id];
 	ret = ice_check_vf_ready_for_cfg(vf);
 	if (ret)
 		return ret;
@@ -6081,10 +6117,10 @@ int ice_set_vf_link_state(struct net_device *netdev, int vf_id, int link_state)
 	struct ice_vf *vf;
 	int ret;
 
-	if (ice_validate_vf_id(pf, vf_id))
+	vf = ice_get_vf_by_id(pf, vf_id);
+	if (!vf)
 		return -EINVAL;
 
-	vf = &pf->vfs.table[vf_id];
 	ret = ice_check_vf_ready_for_cfg(vf);
 	if (ret)
 		return ret;
@@ -6176,10 +6212,11 @@ ice_set_vf_bw(struct net_device *netdev, int vf_id, int min_tx_rate,
 	int ret;
 
 	dev = ice_pf_to_dev(pf);
-	if (ice_validate_vf_id(pf, vf_id))
+
+	vf = ice_get_vf_by_id(pf, vf_id);
+	if (!vf)
 		return -EINVAL;
 
-	vf = &pf->vfs.table[vf_id];
 	ret = ice_check_vf_ready_for_cfg(vf);
 	if (ret)
 		return ret;
@@ -6243,10 +6280,10 @@ int ice_get_vf_stats(struct net_device *netdev, int vf_id,
 	struct ice_vf *vf;
 	int ret;
 
-	if (ice_validate_vf_id(pf, vf_id))
+	vf = ice_get_vf_by_id(pf, vf_id);
+	if (!vf)
 		return -EINVAL;
 
-	vf = &pf->vfs.table[vf_id];
 	ret = ice_check_vf_ready_for_cfg(vf);
 	if (ret)
 		return ret;
@@ -6384,10 +6421,10 @@ ice_is_malicious_vf(struct ice_pf *pf, struct ice_rq_event_info *event,
 	struct ice_vf *vf;
 	int status;
 
-	if (ice_validate_vf_id(pf, vf_id))
+	vf = ice_get_vf_by_id(pf, vf_id);
+	if (!vf)
 		return false;
 
-	vf = &pf->vfs.table[vf_id];
 	/* Check if VF is disabled. */
 	if (test_bit(ICE_VF_STATE_DIS, vf->vf_states))
 		return false;
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 1448e3177215..bc86358fc8e2 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -39,6 +39,13 @@
 #define ICE_MAX_VF_RESET_TRIES		40
 #define ICE_MAX_VF_RESET_SLEEP_MS	20
 
+/* VF Hash Table access functions
+ *
+ * These functions provide abstraction for interacting with the VF hash table.
+ * In general, direct access to the hash table should be avoided outside of
+ * these functions where possible.
+ */
+
 /**
  * ice_for_each_vf - Iterate over each VF entry
  * @pf: pointer to the PF private structure
@@ -185,6 +192,9 @@ struct ice_vf {
 };
 
 #ifdef CONFIG_PCI_IOV
+struct ice_vf *ice_get_vf_by_id(struct ice_pf *pf, u16 vf_id);
+bool ice_has_vfs(struct ice_pf *pf);
+u16 ice_get_num_vfs(struct ice_pf *pf);
 struct ice_vsi *ice_get_vf_vsi(struct ice_vf *vf);
 void ice_process_vflr_event(struct ice_pf *pf);
 int ice_sriov_configure(struct pci_dev *pdev, int num_vfs);
@@ -244,6 +254,21 @@ ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
 bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id);
 bool ice_vf_is_port_vlan_ena(struct ice_vf *vf);
 #else /* CONFIG_PCI_IOV */
+static inline struct ice_vf *ice_get_vf_by_id(struct ice_pf *pf, u16 vf_id)
+{
+	return NULL;
+}
+
+static inline bool ice_has_vfs(struct ice_pf *pf)
+{
+	return false;
+}
+
+static inline u16 ice_get_num_vfs(struct ice_pf *pf)
+{
+	return 0;
+}
+
 static inline void ice_process_vflr_event(struct ice_pf *pf) { }
 static inline void ice_free_vfs(struct ice_pf *pf) { }
 static inline
-- 
2.31.1

