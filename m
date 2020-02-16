Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8818016018E
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 04:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgBPDo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 22:44:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:33362 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727755AbgBPDo4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 22:44:56 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Feb 2020 19:44:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,447,1574150400"; 
   d="scan'208";a="257916586"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga004.fm.intel.com with ESMTP; 15 Feb 2020 19:44:55 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/15] ice: Only allow tagged bcast/mcast traffic for VF in port VLAN
Date:   Sat, 15 Feb 2020 19:44:42 -0800
Message-Id: <20200216034452.1251706-6-jeffrey.t.kirsher@intel.com>
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

Currently the VF can see other's broadcast and multicast traffic because
it always has a VLAN filter for VLAN 0. Fix this by removing/adding the
VF's VLAN 0 filter when a port VLAN is added/removed respectively.

This required a few changes.

1. Move where we add VLAN 0 by default for the VF into
ice_alloc_vsi_res() because this is when we determine if a port VLAN is
present for load and reset.

2. Moved where we kill the old port VLAN filter in
ice_set_vf_port_vlan() to the very end of the function because it allows
us to save the old port VLAN configuration upon any failure case.

3. During adding/removing of a port VLAN via ice_set_vf_port_vlan() we
also need to remove/add the VLAN 0 filter rule respectively.

4. Improve log messages.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 49 ++++++++++++-------
 1 file changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 17bb79f0a30b..19c576625762 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -528,7 +528,18 @@ static int ice_alloc_vsi_res(struct ice_vf *vf)
 	/* Check if port VLAN exist before, and restore it accordingly */
 	if (vf->port_vlan_info) {
 		ice_vsi_manage_pvid(vsi, vf->port_vlan_info, true);
-		ice_vsi_add_vlan(vsi, vf->port_vlan_info & VLAN_VID_MASK);
+		if (ice_vsi_add_vlan(vsi, vf->port_vlan_info & VLAN_VID_MASK))
+			dev_warn(ice_pf_to_dev(pf), "Failed to add Port VLAN %d filter for VF %d\n",
+				 vf->port_vlan_info & VLAN_VID_MASK, vf->vf_id);
+	} else {
+		/* set VLAN 0 filter by default when no port VLAN is
+		 * enabled. If a port VLAN is enabled we don't want
+		 * untagged broadcast/multicast traffic seen on the VF
+		 * interface.
+		 */
+		if (ice_vsi_add_vlan(vsi, 0))
+			dev_warn(ice_pf_to_dev(pf), "Failed to add VLAN 0 filter for VF %d, MDD events will trigger. Reset the VF, disable spoofchk, or enable 8021q module on the guest\n",
+				 vf->vf_id);
 	}
 
 	eth_broadcast_addr(broadcast);
@@ -936,17 +947,9 @@ static void ice_cleanup_and_realloc_vf(struct ice_vf *vf)
 
 	/* reallocate VF resources to finish resetting the VSI state */
 	if (!ice_alloc_vf_res(vf)) {
-		struct ice_vsi *vsi;
-
 		ice_ena_vf_mappings(vf);
 		set_bit(ICE_VF_STATE_ACTIVE, vf->vf_states);
 		clear_bit(ICE_VF_STATE_DIS, vf->vf_states);
-
-		vsi = pf->vsi[vf->lan_vsi_idx];
-		if (ice_vsi_add_vlan(vsi, 0))
-			dev_warn(ice_pf_to_dev(pf),
-				 "Failed to add VLAN 0 filter for VF %d, MDD events will trigger. Reset the VF, disable spoofchk, or enable 8021q module on the guest",
-				 vf->vf_id);
 	}
 
 	/* Tell the VF driver the reset is done. This needs to be done only
@@ -2719,15 +2722,24 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 		return ret;
 	}
 
-	/* If PVID, then remove all filters on the old VLAN */
-	if (vf->port_vlan_info)
-		ice_vsi_kill_vlan(vsi, vf->port_vlan_info & VLAN_VID_MASK);
-
 	if (vlan_id || qos) {
+		/* remove VLAN 0 filter set by default when transitioning from
+		 * no port VLAN to a port VLAN. No change to old port VLAN on
+		 * failure.
+		 */
+		ret = ice_vsi_kill_vlan(vsi, 0);
+		if (ret)
+			return ret;
 		ret = ice_vsi_manage_pvid(vsi, vlanprio, true);
 		if (ret)
-			goto error_manage_pvid;
+			return ret;
 	} else {
+		/* add VLAN 0 filter back when transitioning from port VLAN to
+		 * no port VLAN. No change to old port VLAN on failure.
+		 */
+		ret = ice_vsi_add_vlan(vsi, 0);
+		if (ret)
+			return ret;
 		ret = ice_vsi_manage_pvid(vsi, 0, false);
 		if (ret)
 			goto error_manage_pvid;
@@ -2737,15 +2749,16 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 		dev_info(dev, "Setting VLAN %d, QoS 0x%x on VF %d\n",
 			 vlan_id, qos, vf_id);
 
-		/* add new VLAN filter for each MAC */
+		/* add VLAN filter for the port VLAN */
 		ret = ice_vsi_add_vlan(vsi, vlan_id);
 		if (ret)
 			goto error_manage_pvid;
 	}
+	/* remove old port VLAN filter with valid VLAN ID or QoS fields */
+	if (vf->port_vlan_info)
+		ice_vsi_kill_vlan(vsi, vf->port_vlan_info & VLAN_VID_MASK);
 
-	/* The Port VLAN needs to be saved across resets the same as the
-	 * default LAN MAC address.
-	 */
+	/* keep port VLAN information persistent on resets */
 	vf->port_vlan_info = le16_to_cpu(vsi->info.pvid);
 
 error_manage_pvid:
-- 
2.24.1

