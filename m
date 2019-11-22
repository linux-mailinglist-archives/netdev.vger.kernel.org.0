Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5836107A92
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 23:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfKVW3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 17:29:15 -0500
Received: from mga07.intel.com ([134.134.136.100]:7937 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727007AbfKVW3M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 17:29:12 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:29:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="409027364"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga006.fm.intel.com with ESMTP; 22 Nov 2019 14:29:11 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Brett Creeley <brett.creeley@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 11/15] ice: add helpers for virtchnl
Date:   Fri, 22 Nov 2019 14:29:01 -0800
Message-Id: <20191122222905.670858-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191122222905.670858-1-jeffrey.t.kirsher@intel.com>
References: <20191122222905.670858-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The virtchannel interface was repeating a lot of strings
and wasting storage space in the kernel.  There was also
inconsistent messages for the same thing.  Consolidate all
those messages and bit checks into a couple of helper functions.

Also, reduce stack space usage by simplifying getting the pointer
to the pf using a helper.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Co-developed-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 134 ++++++++----------
 1 file changed, 63 insertions(+), 71 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 269204ca0b1d..aa99d7cb7d8e 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -5,6 +5,35 @@
 #include "ice_base.h"
 #include "ice_lib.h"
 
+/**
+ * ice_validate_vf_id - helper to check if VF ID is valid
+ * @pf: pointer to the PF structure
+ * @vf_id: the ID of the VF to check
+ */
+static int ice_validate_vf_id(struct ice_pf *pf, int vf_id)
+{
+	if (vf_id >= pf->num_alloc_vfs) {
+		dev_err(ice_pf_to_dev(pf), "Invalid VF ID: %d\n", vf_id);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/**
+ * ice_check_vf_init - helper to check if VF init complete
+ * @pf: pointer to the PF structure
+ * @vf: the pointer to the VF to check
+ */
+static int ice_check_vf_init(struct ice_pf *pf, struct ice_vf *vf)
+{
+	if (!test_bit(ICE_VF_STATE_INIT, vf->vf_states)) {
+		dev_err(ice_pf_to_dev(pf), "VF ID: %d in reset. Try again.\n",
+			vf->vf_id);
+		return -EBUSY;
+	}
+	return 0;
+}
+
 /**
  * ice_err_to_virt err - translate errors for VF return code
  * @ice_err: error return code
@@ -1302,9 +1331,13 @@ void ice_vc_notify_reset(struct ice_pf *pf)
 static void ice_vc_notify_vf_reset(struct ice_vf *vf)
 {
 	struct virtchnl_pf_event pfe;
+	struct ice_pf *pf;
 
-	/* validate the request */
-	if (!vf || vf->vf_id >= vf->pf->num_alloc_vfs)
+	if (!vf)
+		return;
+
+	pf = vf->pf;
+	if (ice_validate_vf_id(pf, vf->vf_id))
 		return;
 
 	/* Bail out if VF is in disabled state, neither initialized, nor active
@@ -1317,7 +1350,7 @@ static void ice_vc_notify_vf_reset(struct ice_vf *vf)
 
 	pfe.event = VIRTCHNL_EVENT_RESET_IMPENDING;
 	pfe.severity = PF_EVENT_SEVERITY_CERTAIN_DOOM;
-	ice_aq_send_msg_to_vf(&vf->pf->hw, vf->vf_id, VIRTCHNL_OP_EVENT,
+	ice_aq_send_msg_to_vf(&pf->hw, vf->vf_id, VIRTCHNL_OP_EVENT,
 			      VIRTCHNL_STATUS_SUCCESS, (u8 *)&pfe, sizeof(pfe),
 			      NULL);
 }
@@ -1544,11 +1577,12 @@ ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
 	struct device *dev;
 	struct ice_pf *pf;
 
-	/* validate the request */
-	if (!vf || vf->vf_id >= vf->pf->num_alloc_vfs)
+	if (!vf)
 		return -EINVAL;
 
 	pf = vf->pf;
+	if (ice_validate_vf_id(pf, vf->vf_id))
+		return -EINVAL;
 
 	dev = ice_pf_to_dev(pf);
 
@@ -1622,7 +1656,7 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 	int len = 0;
 	int ret;
 
-	if (!test_bit(ICE_VF_STATE_INIT, vf->vf_states)) {
+	if (ice_check_vf_init(pf, vf)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 		goto err;
 	}
@@ -1801,7 +1835,7 @@ static int ice_vc_config_rss_key(struct ice_vf *vf, u8 *msg)
 	struct virtchnl_rss_key *vrk =
 		(struct virtchnl_rss_key *)msg;
 	struct ice_pf *pf = vf->pf;
-	struct ice_vsi *vsi = NULL;
+	struct ice_vsi *vsi;
 
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
@@ -1848,7 +1882,7 @@ static int ice_vc_config_rss_lut(struct ice_vf *vf, u8 *msg)
 	struct virtchnl_rss_lut *vrl = (struct virtchnl_rss_lut *)msg;
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
 	struct ice_pf *pf = vf->pf;
-	struct ice_vsi *vsi = NULL;
+	struct ice_vsi *vsi;
 
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
 		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
@@ -2597,19 +2631,15 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 		     __be16 vlan_proto)
 {
 	u16 vlanprio = vlan_id | (qos << ICE_VLAN_PRIORITY_S);
-	struct ice_netdev_priv *np = netdev_priv(netdev);
-	struct ice_pf *pf = np->vsi->back;
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
 	struct ice_vsi *vsi;
 	struct device *dev;
 	struct ice_vf *vf;
 	int ret = 0;
 
 	dev = ice_pf_to_dev(pf);
-	/* validate the request */
-	if (vf_id >= pf->num_alloc_vfs) {
-		dev_err(dev, "invalid VF id: %d\n", vf_id);
+	if (ice_validate_vf_id(pf, vf_id))
 		return -EINVAL;
-	}
 
 	if (vlan_id > ICE_MAX_VLANID || qos > 7) {
 		dev_err(dev, "Invalid VF Parameters\n");
@@ -2623,10 +2653,8 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 
 	vf = &pf->vf[vf_id];
 	vsi = pf->vsi[vf->lan_vsi_idx];
-	if (!test_bit(ICE_VF_STATE_INIT, vf->vf_states)) {
-		dev_err(dev, "VF %d in reset. Try again.\n", vf_id);
+	if (ice_check_vf_init(pf, vf))
 		return -EBUSY;
-	}
 
 	if (le16_to_cpu(vsi->info.pvid) == vlanprio) {
 		/* duplicate request, so just return success */
@@ -2984,7 +3012,7 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 	int err = 0;
 
 	dev = ice_pf_to_dev(pf);
-	if (vf_id >= pf->num_alloc_vfs) {
+	if (ice_validate_vf_id(pf, vf_id)) {
 		err = -EINVAL;
 		goto error_handler;
 	}
@@ -3102,24 +3130,18 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 int
 ice_get_vf_cfg(struct net_device *netdev, int vf_id, struct ifla_vf_info *ivi)
 {
-	struct ice_netdev_priv *np = netdev_priv(netdev);
-	struct ice_vsi *vsi = np->vsi;
-	struct ice_pf *pf = vsi->back;
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+	struct ice_vsi *vsi;
 	struct ice_vf *vf;
 
-	/* validate the request */
-	if (vf_id >= pf->num_alloc_vfs) {
-		netdev_err(netdev, "invalid VF id: %d\n", vf_id);
+	if (ice_validate_vf_id(pf, vf_id))
 		return -EINVAL;
-	}
 
 	vf = &pf->vf[vf_id];
 	vsi = pf->vsi[vf->lan_vsi_idx];
 
-	if (!test_bit(ICE_VF_STATE_INIT, vf->vf_states)) {
-		netdev_err(netdev, "VF %d in reset. Try again.\n", vf_id);
+	if (ice_check_vf_init(pf, vf))
 		return -EBUSY;
-	}
 
 	ivi->vf = vf_id;
 	ether_addr_copy(ivi->mac, vf->dflt_lan_addr.addr);
@@ -3152,9 +3174,8 @@ ice_get_vf_cfg(struct net_device *netdev, int vf_id, struct ifla_vf_info *ivi)
  */
 int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena)
 {
-	struct ice_netdev_priv *np = netdev_priv(netdev);
-	struct ice_vsi *vsi = np->vsi;
-	struct ice_pf *pf = vsi->back;
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+	struct ice_vsi *vsi = pf->vsi[0];
 	struct ice_vsi_ctx *ctx;
 	enum ice_status status;
 	struct device *dev;
@@ -3162,18 +3183,12 @@ int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena)
 	int ret = 0;
 
 	dev = ice_pf_to_dev(pf);
-
-	/* validate the request */
-	if (vf_id >= pf->num_alloc_vfs) {
-		netdev_err(netdev, "invalid VF id: %d\n", vf_id);
+	if (ice_validate_vf_id(pf, vf_id))
 		return -EINVAL;
-	}
 
 	vf = &pf->vf[vf_id];
-	if (!test_bit(ICE_VF_STATE_INIT, vf->vf_states)) {
-		netdev_err(netdev, "VF %d in reset. Try again.\n", vf_id);
+	if (ice_check_vf_init(pf, vf))
 		return -EBUSY;
-	}
 
 	if (ena == vf->spoofchk) {
 		dev_dbg(dev, "VF spoofchk already %s\n",
@@ -3235,17 +3250,12 @@ static void ice_wait_on_vf_reset(struct ice_vf *vf)
  */
 int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 {
-	struct ice_netdev_priv *np = netdev_priv(netdev);
-	struct ice_vsi *vsi = np->vsi;
-	struct ice_pf *pf = vsi->back;
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
 	struct ice_vf *vf;
 	int ret = 0;
 
-	/* validate the request */
-	if (vf_id >= pf->num_alloc_vfs) {
-		netdev_err(netdev, "invalid VF id: %d\n", vf_id);
+	if (ice_validate_vf_id(pf, vf_id))
 		return -EINVAL;
-	}
 
 	vf = &pf->vf[vf_id];
 	/* Don't set MAC on disabled VF */
@@ -3257,10 +3267,8 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 	 */
 	ice_wait_on_vf_reset(vf);
 
-	if (!test_bit(ICE_VF_STATE_INIT, vf->vf_states)) {
-		netdev_err(netdev, "VF %d in reset. Try again.\n", vf_id);
+	if (ice_check_vf_init(pf, vf))
 		return -EBUSY;
-	}
 
 	if (is_zero_ether_addr(mac) || is_multicast_ether_addr(mac)) {
 		netdev_err(netdev, "%pM not a valid unicast address\n", mac);
@@ -3292,19 +3300,13 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
  */
 int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 {
-	struct ice_netdev_priv *np = netdev_priv(netdev);
-	struct ice_vsi *vsi = np->vsi;
-	struct ice_pf *pf = vsi->back;
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
 	struct device *dev;
 	struct ice_vf *vf;
 
 	dev = ice_pf_to_dev(pf);
-
-	/* validate the request */
-	if (vf_id >= pf->num_alloc_vfs) {
-		dev_err(dev, "invalid VF id: %d\n", vf_id);
+	if (ice_validate_vf_id(pf, vf_id))
 		return -EINVAL;
-	}
 
 	vf = &pf->vf[vf_id];
 	/* Don't set Trusted Mode on disabled VF */
@@ -3316,10 +3318,8 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 	 */
 	ice_wait_on_vf_reset(vf);
 
-	if (!test_bit(ICE_VF_STATE_INIT, vf->vf_states)) {
-		dev_err(dev, "VF %d in reset. Try again.\n", vf_id);
+	if (ice_check_vf_init(pf, vf))
 		return -EBUSY;
-	}
 
 	/* Check if already trusted */
 	if (trusted == vf->trusted)
@@ -3343,29 +3343,21 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
  */
 int ice_set_vf_link_state(struct net_device *netdev, int vf_id, int link_state)
 {
-	struct ice_netdev_priv *np = netdev_priv(netdev);
-	struct ice_pf *pf = np->vsi->back;
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
 	struct virtchnl_pf_event pfe = { 0 };
 	struct ice_link_status *ls;
-	struct device *dev;
 	struct ice_vf *vf;
 	struct ice_hw *hw;
 
-	dev = ice_pf_to_dev(pf);
-
-	if (vf_id >= pf->num_alloc_vfs) {
-		dev_err(dev, "Invalid VF Identifier %d\n", vf_id);
+	if (ice_validate_vf_id(pf, vf_id))
 		return -EINVAL;
-	}
 
 	vf = &pf->vf[vf_id];
 	hw = &pf->hw;
 	ls = &pf->hw.port_info->phy.link_info;
 
-	if (!test_bit(ICE_VF_STATE_INIT, vf->vf_states)) {
-		dev_err(dev, "vf %d in reset. Try again.\n", vf_id);
+	if (ice_check_vf_init(pf, vf))
 		return -EBUSY;
-	}
 
 	pfe.event = VIRTCHNL_EVENT_LINK_CHANGE;
 	pfe.severity = PF_EVENT_SEVERITY_INFO;
-- 
2.23.0

