Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839F41E7115
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 02:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437999AbgE2AIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 20:08:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:47400 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437990AbgE2AIk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 20:08:40 -0400
IronPort-SDR: J6j6TVWXaLVliRJbRvhuues29hS2mc1dJ3XPzTLBO971ejEwbxM9EHr+H1DBEnTu7E36x/5bBr
 1Vqq5PQIMpkg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 17:08:34 -0700
IronPort-SDR: 7Yy9iHHLAcVeG+d0MkXjY4N9kMdWqTEJc0DL/ZksJTgAuV8/4BLBumFDfIqmv7ZghNxSXsk5cN
 3P4iF6JKRheA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,446,1583222400"; 
   d="scan'208";a="302651652"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 28 May 2020 17:08:34 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/15] ice: Add functions to rebuild host VLAN/MAC config for a VF
Date:   Thu, 28 May 2020 17:08:28 -0700
Message-Id: <20200529000831.2803870-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
References: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

When resetting a VF the VLAN and MAC filter configurations need to be
replayed. Add helper functions for this purpose.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 121 +++++++++++++-----
 1 file changed, 89 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 4005a4caf2f0..3a714c81b5b2 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -540,6 +540,82 @@ static int ice_calc_vf_first_vector_idx(struct ice_pf *pf, struct ice_vf *vf)
 	return pf->sriov_base_vector + vf->vf_id * pf->num_msix_per_vf;
 }
 
+/**
+ * ice_vf_rebuild_host_vlan_cfg - add VLAN 0 filter or rebuild the Port VLAN
+ * @vf: VF to add MAC filters for
+ *
+ * Called after a VF VSI has been re-added/rebuilt during reset. The PF driver
+ * always re-adds either a VLAN 0 or port VLAN based filter after reset.
+ */
+static int ice_vf_rebuild_host_vlan_cfg(struct ice_vf *vf)
+{
+	struct ice_vsi *vsi = vf->pf->vsi[vf->lan_vsi_idx];
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	u16 vlan_id = 0;
+	int err;
+
+	if (vf->port_vlan_info) {
+		err = ice_vsi_manage_pvid(vsi, vf->port_vlan_info, true);
+		if (err) {
+			dev_err(dev, "failed to configure port VLAN via VSI parameters for VF %u, error %d\n",
+				vf->vf_id, err);
+			return err;
+		}
+
+		vlan_id = vf->port_vlan_info & VLAN_VID_MASK;
+	}
+
+	/* vlan_id will either be 0 or the port VLAN number */
+	err = ice_vsi_add_vlan(vsi, vlan_id, ICE_FWD_TO_VSI);
+	if (err) {
+		dev_err(dev, "failed to add %s VLAN %u filter for VF %u, error %d\n",
+			vf->port_vlan_info ? "port" : "", vlan_id, vf->vf_id,
+			err);
+		return err;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_vf_rebuild_host_mac_cfg - add broadcast and the VF's perm_addr/LAA
+ * @vf: VF to add MAC filters for
+ *
+ * Called after a VF VSI has been re-added/rebuilt during reset. The PF driver
+ * always re-adds a broadcast filter and the VF's perm_addr/LAA after reset.
+ */
+static int ice_vf_rebuild_host_mac_cfg(struct ice_vf *vf)
+{
+	struct ice_vsi *vsi = vf->pf->vsi[vf->lan_vsi_idx];
+	struct device *dev = ice_pf_to_dev(vf->pf);
+	enum ice_status status;
+	u8 broadcast[ETH_ALEN];
+
+	eth_broadcast_addr(broadcast);
+	status = ice_fltr_add_mac(vsi, broadcast, ICE_FWD_TO_VSI);
+	if (status) {
+		dev_err(dev, "failed to add broadcast MAC filter for VF %u, error %s\n",
+			vf->vf_id, ice_stat_str(status));
+		return ice_status_to_errno(status);
+	}
+
+	vf->num_mac++;
+
+	if (is_valid_ether_addr(vf->dflt_lan_addr.addr)) {
+		status = ice_fltr_add_mac(vsi, vf->dflt_lan_addr.addr,
+					  ICE_FWD_TO_VSI);
+		if (status) {
+			dev_err(dev, "failed to add default unicast MAC filter %pM for VF %u, error %s\n",
+				&vf->dflt_lan_addr.addr[0], vf->vf_id,
+				ice_stat_str(status));
+			return ice_status_to_errno(status);
+		}
+		vf->num_mac++;
+	}
+
+	return 0;
+}
+
 /**
  * ice_alloc_vsi_res - Setup VF VSI and its resources
  * @vf: pointer to the VF structure
@@ -549,10 +625,9 @@ static int ice_calc_vf_first_vector_idx(struct ice_pf *pf, struct ice_vf *vf)
 static int ice_alloc_vsi_res(struct ice_vf *vf)
 {
 	struct ice_pf *pf = vf->pf;
-	u8 broadcast[ETH_ALEN];
 	struct ice_vsi *vsi;
 	struct device *dev;
-	int status = 0;
+	int ret;
 
 	dev = ice_pf_to_dev(pf);
 	/* first vector index is the VFs OICR index */
@@ -567,38 +642,20 @@ static int ice_alloc_vsi_res(struct ice_vf *vf)
 	vf->lan_vsi_idx = vsi->idx;
 	vf->lan_vsi_num = vsi->vsi_num;
 
-	/* Check if port VLAN exist before, and restore it accordingly */
-	if (vf->port_vlan_info) {
-		ice_vsi_manage_pvid(vsi, vf->port_vlan_info, true);
-		if (ice_vsi_add_vlan(vsi, vf->port_vlan_info & VLAN_VID_MASK,
-				     ICE_FWD_TO_VSI))
-			dev_warn(ice_pf_to_dev(pf), "Failed to add Port VLAN %d filter for VF %d\n",
-				 vf->port_vlan_info & VLAN_VID_MASK, vf->vf_id);
-	} else {
-		/* set VLAN 0 filter by default when no port VLAN is
-		 * enabled. If a port VLAN is enabled we don't want
-		 * untagged broadcast/multicast traffic seen on the VF
-		 * interface.
-		 */
-		if (ice_vsi_add_vlan(vsi, 0, ICE_FWD_TO_VSI))
-			dev_warn(ice_pf_to_dev(pf), "Failed to add VLAN 0 filter for VF %d, MDD events will trigger. Reset the VF, disable spoofchk, or enable 8021q module on the guest\n",
-				 vf->vf_id);
+	ret = ice_vf_rebuild_host_vlan_cfg(vf);
+	if (ret) {
+		dev_err(dev, "failed to rebuild default MAC configuration for VF %d, error %d\n",
+			vf->vf_id, ret);
+		goto ice_alloc_vsi_res_exit;
 	}
 
-	if (is_valid_ether_addr(vf->dflt_lan_addr.addr)) {
-		status = ice_fltr_add_mac(vsi, vf->dflt_lan_addr.addr,
-					  ICE_FWD_TO_VSI);
-		if (status)
-			goto ice_alloc_vsi_res_exit;
-	}
 
-	eth_broadcast_addr(broadcast);
-	status = ice_fltr_add_mac(vsi, broadcast, ICE_FWD_TO_VSI);
-	if (status)
-		dev_err(dev, "could not add mac filters error %d\n",
-			status);
-	else
-		vf->num_mac = 1;
+	ret = ice_vf_rebuild_host_mac_cfg(vf);
+	if (ret) {
+		dev_err(dev, "failed to rebuild default MAC configuration for VF %d, error %d\n",
+			vf->vf_id, ret);
+		goto ice_alloc_vsi_res_exit;
+	}
 
 	/* Clear this bit after VF initialization since we shouldn't reclaim
 	 * and reassign interrupts for synchronous or asynchronous VFR events.
@@ -607,7 +664,7 @@ static int ice_alloc_vsi_res(struct ice_vf *vf)
 	 * more vectors.
 	 */
 ice_alloc_vsi_res_exit:
-	return status;
+	return ret;
 }
 
 /**
-- 
2.26.2

