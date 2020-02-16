Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E04316018D
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 04:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbgBPDo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 22:44:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:33359 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727723AbgBPDo4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 22:44:56 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Feb 2020 19:44:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,447,1574150400"; 
   d="scan'208";a="257916583"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga004.fm.intel.com with ESMTP; 15 Feb 2020 19:44:55 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/15] ice: Fix Port VLAN priority bits
Date:   Sat, 15 Feb 2020 19:44:41 -0800
Message-Id: <20200216034452.1251706-5-jeffrey.t.kirsher@intel.com>
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

Currently when configuring a port VLAN for a VF we are only shifting the
QoS bits by 12. This is incorrect. Fix this by getting rid of the ICE
specific VLAN defines and use the kernel VLAN defines instead.

Also, don't assign a value to vlanprio until the VLAN ID and QoS
parameters have been validated.

Also, there are many places we do (le16_to_cpu(vsi->info.pvid) &
VLAN_VID_MASK). Instead do (vf->port_vlan_info & VLAN_VID_MASK) because
we always save what's stored in vsi->info.pvid to vf->port_vlan_info in
the CPU's endianness.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 27 +++++++++----------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  5 ----
 2 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 62ef3be4b184..17bb79f0a30b 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -528,7 +528,7 @@ static int ice_alloc_vsi_res(struct ice_vf *vf)
 	/* Check if port VLAN exist before, and restore it accordingly */
 	if (vf->port_vlan_info) {
 		ice_vsi_manage_pvid(vsi, vf->port_vlan_info, true);
-		ice_vsi_add_vlan(vsi, vf->port_vlan_info & ICE_VLAN_M);
+		ice_vsi_add_vlan(vsi, vf->port_vlan_info & VLAN_VID_MASK);
 	}
 
 	eth_broadcast_addr(broadcast);
@@ -2684,19 +2684,20 @@ int
 ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 		     __be16 vlan_proto)
 {
-	u16 vlanprio = vlan_id | (qos << ICE_VLAN_PRIORITY_S);
 	struct ice_pf *pf = ice_netdev_to_pf(netdev);
 	struct ice_vsi *vsi;
 	struct device *dev;
 	struct ice_vf *vf;
+	u16 vlanprio;
 	int ret = 0;
 
 	dev = ice_pf_to_dev(pf);
 	if (ice_validate_vf_id(pf, vf_id))
 		return -EINVAL;
 
-	if (vlan_id > ICE_MAX_VLANID || qos > 7) {
-		dev_err(dev, "Invalid VF Parameters\n");
+	if (vlan_id >= VLAN_N_VID || qos > 7) {
+		dev_err(dev, "Invalid Port VLAN parameters for VF %d, ID %d, QoS %d\n",
+			vf_id, vlan_id, qos);
 		return -EINVAL;
 	}
 
@@ -2710,16 +2711,17 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 	if (ice_check_vf_init(pf, vf))
 		return -EBUSY;
 
-	if (le16_to_cpu(vsi->info.pvid) == vlanprio) {
+	vlanprio = vlan_id | (qos << VLAN_PRIO_SHIFT);
+
+	if (vf->port_vlan_info == vlanprio) {
 		/* duplicate request, so just return success */
 		dev_dbg(dev, "Duplicate pvid %d request\n", vlanprio);
 		return ret;
 	}
 
 	/* If PVID, then remove all filters on the old VLAN */
-	if (vsi->info.pvid)
-		ice_vsi_kill_vlan(vsi, (le16_to_cpu(vsi->info.pvid) &
-				  VLAN_VID_MASK));
+	if (vf->port_vlan_info)
+		ice_vsi_kill_vlan(vsi, vf->port_vlan_info & VLAN_VID_MASK);
 
 	if (vlan_id || qos) {
 		ret = ice_vsi_manage_pvid(vsi, vlanprio, true);
@@ -2800,7 +2802,7 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 	}
 
 	for (i = 0; i < vfl->num_elements; i++) {
-		if (vfl->vlan_id[i] > ICE_MAX_VLANID) {
+		if (vfl->vlan_id[i] >= VLAN_N_VID) {
 			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 			dev_err(dev, "invalid VF VLAN id %d\n",
 				vfl->vlan_id[i]);
@@ -3197,14 +3199,12 @@ int
 ice_get_vf_cfg(struct net_device *netdev, int vf_id, struct ifla_vf_info *ivi)
 {
 	struct ice_pf *pf = ice_netdev_to_pf(netdev);
-	struct ice_vsi *vsi;
 	struct ice_vf *vf;
 
 	if (ice_validate_vf_id(pf, vf_id))
 		return -EINVAL;
 
 	vf = &pf->vf[vf_id];
-	vsi = pf->vsi[vf->lan_vsi_idx];
 
 	if (ice_check_vf_init(pf, vf))
 		return -EBUSY;
@@ -3213,9 +3213,8 @@ ice_get_vf_cfg(struct net_device *netdev, int vf_id, struct ifla_vf_info *ivi)
 	ether_addr_copy(ivi->mac, vf->dflt_lan_addr.addr);
 
 	/* VF configuration for VLAN and applicable QoS */
-	ivi->vlan = le16_to_cpu(vsi->info.pvid) & ICE_VLAN_M;
-	ivi->qos = (le16_to_cpu(vsi->info.pvid) & ICE_PRIORITY_M) >>
-		    ICE_VLAN_PRIORITY_S;
+	ivi->vlan = vf->port_vlan_info & VLAN_VID_MASK;
+	ivi->qos = (vf->port_vlan_info & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
 
 	ivi->trusted = vf->trusted;
 	ivi->spoofchk = vf->spoofchk;
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 80bb1acc7c28..a1bb196d417a 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -5,11 +5,6 @@
 #define _ICE_VIRTCHNL_PF_H_
 #include "ice.h"
 
-#define ICE_MAX_VLANID			4095
-#define ICE_VLAN_PRIORITY_S		12
-#define ICE_VLAN_M			0xFFF
-#define ICE_PRIORITY_M			0x7000
-
 /* Restrict number of MAC Addr and VLAN that non-trusted VF can programmed */
 #define ICE_MAX_VLAN_PER_VF		8
 #define ICE_MAX_MACADDR_PER_VF		12
-- 
2.24.1

