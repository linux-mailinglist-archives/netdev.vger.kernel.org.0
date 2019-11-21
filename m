Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4F9104CCE
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 08:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfKUHqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 02:46:16 -0500
Received: from mga12.intel.com ([192.55.52.136]:4523 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726568AbfKUHqP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 02:46:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2019 23:46:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,224,1571727600"; 
   d="scan'208";a="216077530"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga001.fm.intel.com with ESMTP; 20 Nov 2019 23:46:14 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/15] ice: Disallow VF VLAN opcodes if VLAN offloads disabled
Date:   Wed, 20 Nov 2019 23:46:00 -0800
Message-Id: <20191121074612.3055661-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191121074612.3055661-1-jeffrey.t.kirsher@intel.com>
References: <20191121074612.3055661-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently if the host disables VLAN offloads on the VF by
not setting the VIRTCHNL_VF_OFFLOAD_VLAN capability bit
we will still honor VF VLAN configuration messages over
VIRTCHNL. These messages (i.e. enable/disable VLAN stripping
and VLAN filtering) should be blocked when the feature
is not supported. Fix that by adding a helper function to
determine if the VF is allowed to do VLAN operations based
on the host's VF configuration.

Also, mirror the VF communicated capabilities in the host's
VF configuration.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 29 +++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 2ac83ad3d1a6..3cb394bdfe51 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1686,6 +1686,9 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 	ether_addr_copy(vfres->vsi_res[0].default_mac_addr,
 			vf->dflt_lan_addr.addr);
 
+	/* match guest capabilities */
+	vf->driver_caps = vfres->vf_cap_flags;
+
 	set_bit(ICE_VF_STATE_ACTIVE, vf->vf_states);
 
 err:
@@ -2653,6 +2656,17 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 	return ret;
 }
 
+/**
+ * ice_vf_vlan_offload_ena - determine if capabilities support VLAN offloads
+ * @caps: VF driver negotiated capabilities
+ *
+ * Return true if VIRTCHNL_VF_OFFLOAD_VLAN capability is set, else return false
+ */
+static bool ice_vf_vlan_offload_ena(u32 caps)
+{
+	return !!(caps & VIRTCHNL_VF_OFFLOAD_VLAN);
+}
+
 /**
  * ice_vc_process_vlan_msg
  * @vf: pointer to the VF info
@@ -2679,6 +2693,11 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 		goto error_param;
 	}
 
+	if (!ice_vf_vlan_offload_ena(vf->driver_caps)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
+
 	if (!ice_vc_isvalid_vsi_id(vf, vfl->vsi_id)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
@@ -2864,6 +2883,11 @@ static int ice_vc_ena_vlan_stripping(struct ice_vf *vf)
 		goto error_param;
 	}
 
+	if (!ice_vf_vlan_offload_ena(vf->driver_caps)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
+
 	vsi = pf->vsi[vf->lan_vsi_idx];
 	if (ice_vsi_manage_vlan_stripping(vsi, true))
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
@@ -2890,6 +2914,11 @@ static int ice_vc_dis_vlan_stripping(struct ice_vf *vf)
 		goto error_param;
 	}
 
+	if (!ice_vf_vlan_offload_ena(vf->driver_caps)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto error_param;
+	}
+
 	vsi = pf->vsi[vf->lan_vsi_idx];
 	if (!vsi) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-- 
2.23.0

