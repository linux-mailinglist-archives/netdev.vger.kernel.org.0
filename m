Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8A44AFF95
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234735AbiBIV5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:57:40 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234388AbiBIV5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:57:19 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D2AE00FA52
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:57:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644443837; x=1675979837;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oxIal9FkWc1TZP9rZp1w6htEDUDJqF7IwCrVnEjRCn4=;
  b=NftjTdPolfR9zrBDhcU0ImVVdO13h8b4G3mMqTTEUYCkz9407r8XOShB
   37cR82QgpQq1x2ukVmV/U3fNEMZDbN7kI1gDPOqlmVvcQHrS1sRHBut+X
   hd7lv7IalMfvmLHk1Z4HFTrg2Ai+iwBGB4GR/f2+gciQnnHoJfd7VylRT
   2OhhLIiw0EqiZlbmj+7VvkwV+jDGNU6ilE1Nc3wLFdutRdgkh5L6Ok2XO
   2NV3441QQNEM/mMm2lkPmdOYh1U3qU7i+TdT5TWCxAInyOusKv21Sp3R2
   drILMStCtiueBsFFtVbppOfulTTjDZ/yuzrLsGqW+R+xboVTZs8iix8Da
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="249104092"
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="249104092"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 13:57:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,356,1635231600"; 
   d="scan'208";a="601790489"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 09 Feb 2022 13:57:15 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 05/14] ice: Refactor vf->port_vlan_info to use ice_vlan
Date:   Wed,  9 Feb 2022 13:56:57 -0800
Message-Id: <20220209215706.2468371-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220209215706.2468371-1-anthony.l.nguyen@intel.com>
References: <20220209215706.2468371-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

The current vf->port_vlan_info variable is a packed u16 that contains
the port VLAN ID and QoS/prio value. This is fine, but changes are
incoming that allow for an 802.1ad port VLAN. Add flexibility by
changing the vf->port_vlan_info member to be an ice_vlan structure.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 76 ++++++++++---------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  3 +-
 2 files changed, 44 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index fdc50b42f8ee..a36a80b64455 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -751,6 +751,21 @@ static int ice_vf_rebuild_host_tx_rate_cfg(struct ice_vf *vf)
 	return 0;
 }
 
+static u16 ice_vf_get_port_vlan_id(struct ice_vf *vf)
+{
+	return vf->port_vlan_info.vid;
+}
+
+static u8 ice_vf_get_port_vlan_prio(struct ice_vf *vf)
+{
+	return vf->port_vlan_info.prio;
+}
+
+static bool ice_vf_is_port_vlan_ena(struct ice_vf *vf)
+{
+	return (ice_vf_get_port_vlan_id(vf) || ice_vf_get_port_vlan_prio(vf));
+}
+
 /**
  * ice_vf_rebuild_host_vlan_cfg - add VLAN 0 filter or rebuild the Port VLAN
  * @vf: VF to add MAC filters for
@@ -760,16 +775,12 @@ static int ice_vf_rebuild_host_tx_rate_cfg(struct ice_vf *vf)
  */
 static int ice_vf_rebuild_host_vlan_cfg(struct ice_vf *vf)
 {
-	u8 vlan_prio = (vf->port_vlan_info & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
-	u16 vlan_id = vf->port_vlan_info & VLAN_VID_MASK;
 	struct device *dev = ice_pf_to_dev(vf->pf);
 	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
-	struct ice_vlan vlan;
 	int err;
 
-	vlan = ICE_VLAN(vlan_id, vlan_prio);
-	if (vf->port_vlan_info) {
-		err = vsi->vlan_ops.set_port_vlan(vsi, &vlan);
+	if (ice_vf_is_port_vlan_ena(vf)) {
+		err = vsi->vlan_ops.set_port_vlan(vsi, &vf->port_vlan_info);
 		if (err) {
 			dev_err(dev, "failed to configure port VLAN via VSI parameters for VF %u, error %d\n",
 				vf->vf_id, err);
@@ -777,12 +788,11 @@ static int ice_vf_rebuild_host_vlan_cfg(struct ice_vf *vf)
 		}
 	}
 
-	/* vlan_id will either be 0 or the port VLAN number */
-	err = vsi->vlan_ops.add_vlan(vsi, &vlan);
+	err = vsi->vlan_ops.add_vlan(vsi, &vf->port_vlan_info);
 	if (err) {
-		dev_err(dev, "failed to add %s VLAN %u filter for VF %u, error %d\n",
-			vf->port_vlan_info ? "port" : "", vlan_id, vf->vf_id,
-			err);
+		dev_err(dev, "failed to add VLAN %u filter for VF %u during VF rebuild, error %d\n",
+			ice_vf_is_port_vlan_ena(vf) ?
+			ice_vf_get_port_vlan_id(vf) : 0, vf->vf_id, err);
 		return err;
 	}
 
@@ -1256,9 +1266,9 @@ ice_vf_set_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m)
 	struct ice_hw *hw = &vsi->back->hw;
 	int status;
 
-	if (vf->port_vlan_info)
+	if (ice_vf_is_port_vlan_ena(vf))
 		status = ice_fltr_set_vsi_promisc(hw, vsi->idx, promisc_m,
-						  vf->port_vlan_info & VLAN_VID_MASK);
+						  ice_vf_get_port_vlan_id(vf));
 	else if (vsi->num_vlan > 1)
 		status = ice_fltr_set_vlan_vsi_promisc(hw, vsi, promisc_m);
 	else
@@ -1279,9 +1289,9 @@ ice_vf_clear_vsi_promisc(struct ice_vf *vf, struct ice_vsi *vsi, u8 promisc_m)
 	struct ice_hw *hw = &vsi->back->hw;
 	int status;
 
-	if (vf->port_vlan_info)
+	if (ice_vf_is_port_vlan_ena(vf))
 		status = ice_fltr_clear_vsi_promisc(hw, vsi->idx, promisc_m,
-						    vf->port_vlan_info & VLAN_VID_MASK);
+						    ice_vf_get_port_vlan_id(vf));
 	else if (vsi->num_vlan > 1)
 		status = ice_fltr_clear_vlan_vsi_promisc(hw, vsi, promisc_m);
 	else
@@ -1656,7 +1666,7 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	 */
 	if (test_bit(ICE_VF_STATE_UC_PROMISC, vf->vf_states) ||
 	    test_bit(ICE_VF_STATE_MC_PROMISC, vf->vf_states)) {
-		if (vf->port_vlan_info || vsi->num_vlan)
+		if (ice_vf_is_port_vlan_ena(vf) || vsi->num_vlan)
 			promisc_m = ICE_UCAST_VLAN_PROMISC_BITS;
 		else
 			promisc_m = ICE_UCAST_PROMISC_BITS;
@@ -2279,7 +2289,7 @@ static u16 ice_vc_get_max_frame_size(struct ice_vf *vf)
 
 	max_frame_size = pi->phy.link_info.max_frame_size;
 
-	if (vf->port_vlan_info)
+	if (ice_vf_is_port_vlan_ena(vf))
 		max_frame_size -= VLAN_HLEN;
 
 	return max_frame_size;
@@ -2328,7 +2338,7 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 		goto err;
 	}
 
-	if (!vsi->info.pvid)
+	if (!ice_vf_is_port_vlan_ena(vf))
 		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_VLAN;
 
 	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_RSS_PF) {
@@ -3051,7 +3061,7 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 
 	rm_promisc = !allmulti && !alluni;
 
-	if (vsi->num_vlan || vf->port_vlan_info) {
+	if (vsi->num_vlan || ice_vf_is_port_vlan_ena(vf)) {
 		if (rm_promisc)
 			ret = vsi->vlan_ops.ena_rx_filtering(vsi);
 		else
@@ -3087,7 +3097,7 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 	} else {
 		u8 mcast_m, ucast_m;
 
-		if (vf->port_vlan_info || vsi->num_vlan > 1) {
+		if (ice_vf_is_port_vlan_ena(vf) || vsi->num_vlan > 1) {
 			mcast_m = ICE_MCAST_VLAN_PROMISC_BITS;
 			ucast_m = ICE_UCAST_VLAN_PROMISC_BITS;
 		} else {
@@ -3670,7 +3680,7 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 			/* add space for the port VLAN since the VF driver is not
 			 * expected to account for it in the MTU calculation
 			 */
-			if (vf->port_vlan_info)
+			if (ice_vf_is_port_vlan_ena(vf))
 				vsi->max_frame += VLAN_HLEN;
 
 			if (ice_vsi_cfg_single_rxq(vsi, q_idx)) {
@@ -4098,7 +4108,6 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 	struct ice_pf *pf = ice_netdev_to_pf(netdev);
 	struct device *dev;
 	struct ice_vf *vf;
-	u16 vlanprio;
 	int ret;
 
 	dev = ice_pf_to_dev(pf);
@@ -4121,20 +4130,19 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 	if (ret)
 		return ret;
 
-	vlanprio = vlan_id | (qos << VLAN_PRIO_SHIFT);
-
-	if (vf->port_vlan_info == vlanprio) {
+	if (ice_vf_get_port_vlan_prio(vf) == qos &&
+	    ice_vf_get_port_vlan_id(vf) == vlan_id) {
 		/* duplicate request, so just return success */
-		dev_dbg(dev, "Duplicate pvid %d request\n", vlanprio);
+		dev_dbg(dev, "Duplicate port VLAN %u, QoS %u request\n",
+			vlan_id, qos);
 		return 0;
 	}
 
 	mutex_lock(&vf->cfg_lock);
 
-	vf->port_vlan_info = vlanprio;
-
-	if (vf->port_vlan_info)
-		dev_info(dev, "Setting VLAN %d, QoS 0x%x on VF %d\n",
+	vf->port_vlan_info = ICE_VLAN(vlan_id, qos);
+	if (ice_vf_is_port_vlan_ena(vf))
+		dev_info(dev, "Setting VLAN %u, QoS %u on VF %d\n",
 			 vlan_id, qos, vf_id);
 	else
 		dev_info(dev, "Clearing port VLAN on VF %d\n", vf_id);
@@ -4220,7 +4228,7 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
 		goto error_param;
 	}
 
-	if (vsi->info.pvid) {
+	if (ice_vf_is_port_vlan_ena(vf)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto error_param;
 	}
@@ -4446,7 +4454,7 @@ static int ice_vf_init_vlan_stripping(struct ice_vf *vf)
 		return -EINVAL;
 
 	/* don't modify stripping if port VLAN is configured */
-	if (vsi->info.pvid)
+	if (ice_vf_is_port_vlan_ena(vf))
 		return 0;
 
 	if (ice_vf_vlan_offload_ena(vf->driver_caps))
@@ -4816,8 +4824,8 @@ ice_get_vf_cfg(struct net_device *netdev, int vf_id, struct ifla_vf_info *ivi)
 	ether_addr_copy(ivi->mac, vf->hw_lan_addr.addr);
 
 	/* VF configuration for VLAN and applicable QoS */
-	ivi->vlan = vf->port_vlan_info & VLAN_VID_MASK;
-	ivi->qos = (vf->port_vlan_info & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
+	ivi->vlan = ice_vf_get_port_vlan_id(vf);
+	ivi->qos = ice_vf_get_port_vlan_prio(vf);
 
 	ivi->trusted = vf->trusted;
 	ivi->spoofchk = vf->spoofchk;
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 752487a1bdd6..5079a3b72698 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -5,6 +5,7 @@
 #define _ICE_VIRTCHNL_PF_H_
 #include "ice.h"
 #include "ice_virtchnl_fdir.h"
+#include "ice_vsi_vlan_ops.h"
 
 /* Restrict number of MAC Addr and VLAN that non-trusted VF can programmed */
 #define ICE_MAX_VLAN_PER_VF		8
@@ -119,7 +120,7 @@ struct ice_vf {
 	struct ice_time_mac legacy_last_added_umac;
 	DECLARE_BITMAP(txq_ena, ICE_MAX_RSS_QS_PER_VF);
 	DECLARE_BITMAP(rxq_ena, ICE_MAX_RSS_QS_PER_VF);
-	u16 port_vlan_info;		/* Port VLAN ID and QoS */
+	struct ice_vlan port_vlan_info;	/* Port VLAN ID and QoS */
 	u8 pf_set_mac:1;		/* VF MAC address set by VMM admin */
 	u8 trusted:1;
 	u8 spoofchk:1;
-- 
2.31.1

