Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89331E97A3
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgEaMgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:36:43 -0400
Received: from mga12.intel.com ([192.55.52.136]:12468 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728103AbgEaMgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 08:36:25 -0400
IronPort-SDR: dE2fbGQEKO2kyuuLAXE4rHRx+pbbLREDwbzwjh34EnoriV8bMhnpqebxEVqe5/bCPI/ZyJhxQI
 +GC6Ruv6ROFw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2020 05:36:23 -0700
IronPort-SDR: 5wNlBdSJzdfrNGR6n9BLu2/+JJQJ4Xmom1OWZ1Q0kDoXxiELgMHrSga9nvlDWTDplqoygWWcXK
 ORcTeK300l3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,456,1583222400"; 
   d="scan'208";a="303345433"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 31 May 2020 05:36:22 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/14] ice: Reset VF for all port VLAN changes from host
Date:   Sun, 31 May 2020 05:36:11 -0700
Message-Id: <20200531123619.2887469-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
References: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently the PF is modifying the VF's port VLAN on the fly when
configured via iproute. This is okay for most cases, but if the VF
already has guest VLANs configured the PF has to remove all of those
filters so only VLAN tagged traffic that matches the port VLAN will
pass. Instead of adding functionality to track which guest VLANs have
been added, just reset the VF each time port VLAN parameters are
modified.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 42 +++----------------
 1 file changed, 5 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 9550501f9279..2916cfb9d032 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3295,7 +3295,6 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 		     __be16 vlan_proto)
 {
 	struct ice_pf *pf = ice_netdev_to_pf(netdev);
-	struct ice_vsi *vsi;
 	struct device *dev;
 	struct ice_vf *vf;
 	u16 vlanprio;
@@ -3317,8 +3316,6 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 	}
 
 	vf = &pf->vf[vf_id];
-	vsi = pf->vsi[vf->lan_vsi_idx];
-
 	ret = ice_check_vf_ready_for_cfg(vf);
 	if (ret)
 		return ret;
@@ -3331,44 +3328,15 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 		return 0;
 	}
 
-	if (vlan_id || qos) {
-		/* remove VLAN 0 filter set by default when transitioning from
-		 * no port VLAN to a port VLAN. No change to old port VLAN on
-		 * failure.
-		 */
-		ret = ice_vsi_kill_vlan(vsi, 0);
-		if (ret)
-			return ret;
-		ret = ice_vsi_manage_pvid(vsi, vlanprio, true);
-		if (ret)
-			return ret;
-	} else {
-		/* add VLAN 0 filter back when transitioning from port VLAN to
-		 * no port VLAN. No change to old port VLAN on failure.
-		 */
-		ret = ice_vsi_add_vlan(vsi, 0, ICE_FWD_TO_VSI);
-		if (ret)
-			return ret;
-		ret = ice_vsi_manage_pvid(vsi, 0, false);
-		if (ret)
-			return ret;
-	}
+	vf->port_vlan_info = vlanprio;
 
-	if (vlan_id) {
+	if (vf->port_vlan_info)
 		dev_info(dev, "Setting VLAN %d, QoS 0x%x on VF %d\n",
 			 vlan_id, qos, vf_id);
+	else
+		dev_info(dev, "Clearing port VLAN on VF %d\n", vf_id);
 
-		/* add VLAN filter for the port VLAN */
-		ret = ice_vsi_add_vlan(vsi, vlan_id, ICE_FWD_TO_VSI);
-		if (ret)
-			return ret;
-	}
-	/* remove old port VLAN filter with valid VLAN ID or QoS fields */
-	if (vf->port_vlan_info)
-		ice_vsi_kill_vlan(vsi, vf->port_vlan_info & VLAN_VID_MASK);
-
-	/* keep port VLAN information persistent on resets */
-	vf->port_vlan_info = le16_to_cpu(vsi->info.pvid);
+	ice_vc_reset_vf(vf);
 
 	return 0;
 }
-- 
2.26.2

