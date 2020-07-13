Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951A021DEEE
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730276AbgGMRnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:43:32 -0400
Received: from mga14.intel.com ([192.55.52.115]:39717 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729700AbgGMRn2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 13:43:28 -0400
IronPort-SDR: bqMssnaAiLpoQw9l5tE18g4I81fAA1CngJBhCWxQfZKJLOpmkPyzkZSrc5cxQkJfKiJZV9ENbA
 +btoZyvFqOVQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="147810220"
X-IronPort-AV: E=Sophos;i="5.75,348,1589266800"; 
   d="scan'208";a="147810220"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 10:43:27 -0700
IronPort-SDR: q//wZv4CP3Tt4lXy7Wh/HK07BKqCBe2B+tDF/mPkH6AeoxbTgvDIlP6bX6vRQNS9y7evwxW1nL
 Mw88VuoJHw7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,348,1589266800"; 
   d="scan'208";a="317450191"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 13 Jul 2020 10:43:27 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Haiyue Wang <haiyue.wang@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Xiaoyun Li <xiaoyun.li@intel.com>,
        Nannan Lu <nannan.lu@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 2/5] ice: add DCF cap negotiation and state machine
Date:   Mon, 13 Jul 2020 10:43:17 -0700
Message-Id: <20200713174320.3982049-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200713174320.3982049-1-anthony.l.nguyen@intel.com>
References: <20200713174320.3982049-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyue Wang <haiyue.wang@intel.com>

The trust VF0 needs to negotiate the DCF capability firstly. Then the PF
driver may allow this VF to enter into DCF "ON" state if various checks
are passed. In DCF "ON" state, the VF0 can send the AdminQ command to do
advanced switch rules creation for other VFs.

If one of the VFs resets, its hardware VSI number may be changed, so the
VF0 will enter into the DCF "BUSY" state immediately to avoid adding the
wrong rule. After the reset is done, the DCF state is changed to "PAUSE"
mode, and a DCF_VSI_MAP_UPDATE event will be sent to the VF0. This event
notifies the VF0 to restart negotiating the DCF capability again.

Also the VF0 can exits the DCF service gracefully by issuing the virtual
channel command OP_DCF_DISABLE.

The system administrator can disable the DCF service by changing the
trust mode to untrusted.

Signed-off-by: Xiaoyun Li <xiaoyun.li@intel.com>
Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Tested-by: Nannan Lu <nannan.lu@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcf.c      | 77 +++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_dcf.h      | 24 ++++++
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 85 ++++++++++++++++++-
 include/linux/avf/virtchnl.h                  |  9 ++
 4 files changed, 194 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcf.c b/drivers/net/ethernet/intel/ice/ice_dcf.c
index cbe60a0cb2d2..e7d37735aaa5 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcf.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcf.c
@@ -47,3 +47,80 @@ bool ice_dcf_aq_cmd_permitted(struct ice_aq_desc *desc)
 
 	return false;
 }
+
+/**
+ * ice_check_dcf_allowed - check if DCF is allowed based on various checks
+ * @vf: pointer to the VF to check
+ */
+bool ice_check_dcf_allowed(struct ice_vf *vf)
+{
+	struct ice_pf *pf = vf->pf;
+	struct device *dev;
+
+	dev = ice_pf_to_dev(pf);
+
+	if (vf->vf_id != ICE_DCF_VFID) {
+		dev_err(dev, "VF %d requested DCF capability, but only VF %d is allowed to request DCF capability\n",
+			vf->vf_id, ICE_DCF_VFID);
+		return false;
+	}
+
+	if (!vf->trusted) {
+		dev_err(dev, "VF needs to be trusted to configure DCF capability\n");
+		return false;
+	}
+
+	return true;
+}
+
+/**
+ * ice_vf_is_dcf - helper to check if the assigned VF is a DCF
+ * @vf: the assigned VF to be checked
+ */
+bool ice_is_vf_dcf(struct ice_vf *vf)
+{
+	return vf == vf->pf->dcf.vf;
+}
+
+/**
+ * ice_dcf_get_state - Get DCF state of the associated PF
+ * @pf: PF instance
+ */
+enum ice_dcf_state ice_dcf_get_state(struct ice_pf *pf)
+{
+	return pf->dcf.vf ? pf->dcf.state : ICE_DCF_STATE_OFF;
+}
+
+/**
+ * ice_dcf_state_str - convert DCF state code to a string
+ * @state: the DCF state code to convert
+ */
+static const char *ice_dcf_state_str(enum ice_dcf_state state)
+{
+	switch (state) {
+	case ICE_DCF_STATE_OFF:
+		return "ICE_DCF_STATE_OFF";
+	case ICE_DCF_STATE_ON:
+		return "ICE_DCF_STATE_ON";
+	case ICE_DCF_STATE_BUSY:
+		return "ICE_DCF_STATE_BUSY";
+	case ICE_DCF_STATE_PAUSE:
+		return "ICE_DCF_STATE_PAUSE";
+	}
+
+	return "ICE_DCF_STATE_UNKNOWN";
+}
+
+/**
+ * ice_dcf_set_state - Set DCF state for the associated PF
+ * @pf: PF instance
+ * @state: new DCF state
+ */
+void ice_dcf_set_state(struct ice_pf *pf, enum ice_dcf_state state)
+{
+	dev_dbg(ice_pf_to_dev(pf), "DCF state is changing from %s to %s\n",
+		ice_dcf_state_str(pf->dcf.state),
+		ice_dcf_state_str(state));
+
+	pf->dcf.state = state;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_dcf.h b/drivers/net/ethernet/intel/ice/ice_dcf.h
index 9edb2d5d9d8f..1dabcca6f753 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcf.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcf.h
@@ -4,7 +4,27 @@
 #ifndef _ICE_DCF_H_
 #define _ICE_DCF_H_
 
+struct ice_vf;
+struct ice_pf;
+
+#define ICE_DCF_VFID	0
+
+/* DCF mode states */
+enum ice_dcf_state {
+	/* DCF mode is fully off */
+	ICE_DCF_STATE_OFF = 0,
+	/* Process is live, acquired capability to send DCF CMD */
+	ICE_DCF_STATE_ON,
+	/* Kernel is busy, deny DCF CMD */
+	ICE_DCF_STATE_BUSY,
+	/* Kernel is ready for Process to Re-establish, deny DCF CMD */
+	ICE_DCF_STATE_PAUSE,
+};
+
 struct ice_dcf {
+	struct ice_vf *vf;
+	enum ice_dcf_state state;
+
 	/* Handle the AdminQ command between the DCF (Device Config Function)
 	 * and the firmware.
 	 */
@@ -16,5 +36,9 @@ struct ice_dcf {
 
 #ifdef CONFIG_PCI_IOV
 bool ice_dcf_aq_cmd_permitted(struct ice_aq_desc *desc);
+bool ice_check_dcf_allowed(struct ice_vf *vf);
+bool ice_is_vf_dcf(struct ice_vf *vf);
+enum ice_dcf_state ice_dcf_get_state(struct ice_pf *pf);
+void ice_dcf_set_state(struct ice_pf *pf, enum ice_dcf_state state);
 #endif /* CONFIG_PCI_IOV */
 #endif /* _ICE_DCF_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 0851944b8fd4..86ca35d0942f 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -360,6 +360,11 @@ void ice_free_vfs(struct ice_pf *pf)
 	else
 		dev_warn(dev, "VFs are assigned - not disabling SR-IOV\n");
 
+	if (ice_dcf_get_state(pf) != ICE_DCF_STATE_OFF) {
+		ice_dcf_set_state(pf, ICE_DCF_STATE_OFF);
+		pf->dcf.vf = NULL;
+	}
+
 	/* Avoid wait time by stopping all VFs at the same time */
 	ice_for_each_vf(pf, i)
 		if (test_bit(ICE_VF_STATE_QS_ENA, pf->vf[i].vf_states))
@@ -1285,6 +1290,9 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	set_bit(ICE_VF_STATE_DIS, vf->vf_states);
 	ice_trigger_vf_reset(vf, is_vflr, false);
 
+	if (ice_dcf_get_state(pf) == ICE_DCF_STATE_ON)
+		ice_dcf_set_state(pf, ICE_DCF_STATE_BUSY);
+
 	vsi = pf->vsi[vf->lan_vsi_idx];
 
 	if (test_bit(ICE_VF_STATE_QS_ENA, vf->vf_states))
@@ -1340,6 +1348,21 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	ice_vf_rebuild_vsi_with_release(vf);
 	ice_vf_post_vsi_rebuild(vf);
 
+	if (ice_dcf_get_state(pf) == ICE_DCF_STATE_BUSY) {
+		struct virtchnl_pf_event pfe = { 0 };
+
+		ice_dcf_set_state(pf, ICE_DCF_STATE_PAUSE);
+
+		pfe.event = VIRTCHNL_EVENT_DCF_VSI_MAP_UPDATE;
+		pfe.event_data.vf_vsi_map.vf_id = vf->vf_id;
+		pfe.event_data.vf_vsi_map.vsi_id = vf->lan_vsi_num;
+
+		ice_aq_send_msg_to_vf(&pf->hw, ICE_DCF_VFID,
+				      VIRTCHNL_OP_EVENT,
+				      VIRTCHNL_STATUS_SUCCESS,
+				      (u8 *)&pfe, sizeof(pfe), NULL);
+	}
+
 	return true;
 }
 
@@ -1977,6 +2000,24 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 	if (vf->driver_caps & VIRTCHNL_VF_CAP_ADV_LINK_SPEED)
 		vfres->vf_cap_flags |= VIRTCHNL_VF_CAP_ADV_LINK_SPEED;
 
+	/* Negotiate DCF capability. */
+	if (vf->driver_caps & VIRTCHNL_VF_CAP_DCF) {
+		if (!ice_check_dcf_allowed(vf)) {
+			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+			goto err;
+		}
+		vfres->vf_cap_flags |= VIRTCHNL_VF_CAP_DCF;
+		pf->dcf.vf = vf;
+		ice_dcf_set_state(pf, ICE_DCF_STATE_ON);
+		dev_info(ice_pf_to_dev(pf), "Grant request for DCF functionality to VF%d\n",
+			 ICE_DCF_VFID);
+	} else if (ice_is_vf_dcf(vf) &&
+		   ice_dcf_get_state(pf) != ICE_DCF_STATE_OFF) {
+		ice_dcf_set_state(pf, ICE_DCF_STATE_OFF);
+		pf->dcf.vf = NULL;
+		ice_reset_vf(vf, false);
+	}
+
 	vfres->num_vsis = 1;
 	/* Tx and Rx queue are equal for VF */
 	vfres->num_queue_pairs = vsi->num_txq;
@@ -3727,6 +3768,9 @@ static int ice_vc_dcf_cmd_desc_msg(struct ice_vf *vf, u8 *msg, u16 len)
 	struct ice_aq_desc *aq_desc = (struct ice_aq_desc *)msg;
 	struct ice_pf *pf = vf->pf;
 
+	if (!ice_is_vf_dcf(vf) || ice_dcf_get_state(pf) != ICE_DCF_STATE_ON)
+		goto err;
+
 	if (len != sizeof(*aq_desc) || !ice_dcf_aq_cmd_permitted(aq_desc)) {
 		/* In case to avoid the VIRTCHNL_OP_DCF_CMD_DESC message with
 		 * the ICE_AQ_FLAG_BUF set followed by another bad message
@@ -3764,7 +3808,8 @@ static int ice_vc_dcf_cmd_buff_msg(struct ice_vf *vf, u8 *msg, u16 len)
 {
 	struct ice_pf *pf = vf->pf;
 
-	if (!len || !pf->dcf.aq_desc_received ||
+	if (!ice_is_vf_dcf(vf) || ice_dcf_get_state(pf) != ICE_DCF_STATE_ON ||
+	    !len || !pf->dcf.aq_desc_received ||
 	    time_is_before_jiffies(pf->dcf.aq_desc_expires))
 		goto err;
 
@@ -3776,6 +3821,34 @@ static int ice_vc_dcf_cmd_buff_msg(struct ice_vf *vf, u8 *msg, u16 len)
 				     VIRTCHNL_STATUS_ERR_PARAM, NULL, 0);
 }
 
+/**
+ * ice_vc_dis_dcf_cap - disable DCF capability for the VF
+ * @vf: pointer to the VF
+ */
+static int ice_vc_dis_dcf_cap(struct ice_vf *vf)
+{
+	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+
+	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto err;
+	}
+
+	if (!ice_is_vf_dcf(vf)) {
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto err;
+	}
+
+	if (vf->driver_caps & VIRTCHNL_VF_CAP_DCF) {
+		vf->driver_caps &= ~VIRTCHNL_VF_CAP_DCF;
+		ice_dcf_set_state(vf->pf, ICE_DCF_STATE_OFF);
+		vf->pf->dcf.vf = NULL;
+	}
+err:
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DCF_DISABLE,
+				     v_ret, NULL, 0);
+}
+
 /**
  * ice_vc_process_vf_msg - Process request from VF
  * @pf: pointer to the PF structure
@@ -3892,6 +3965,9 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 	case VIRTCHNL_OP_DCF_CMD_BUFF:
 		err = ice_vc_dcf_cmd_buff_msg(vf, msg, msglen);
 		break;
+	case VIRTCHNL_OP_DCF_DISABLE:
+		err = ice_vc_dis_dcf_cap(vf);
+		break;
 	case VIRTCHNL_OP_UNKNOWN:
 	default:
 		dev_err(dev, "Unsupported opcode %d from VF %d\n", v_opcode,
@@ -4068,6 +4144,13 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 	if (trusted == vf->trusted)
 		return 0;
 
+	if (ice_is_vf_dcf(vf) && !trusted &&
+	    ice_dcf_get_state(pf) != ICE_DCF_STATE_OFF) {
+		ice_dcf_set_state(pf, ICE_DCF_STATE_OFF);
+		pf->dcf.vf = NULL;
+		vf->driver_caps &= ~VIRTCHNL_VF_CAP_DCF;
+	}
+
 	vf->trusted = trusted;
 	ice_vc_reset_vf(vf);
 	dev_info(ice_pf_to_dev(pf), "VF %u is now %strusted\n",
diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index cd627a217b1c..2ff8e31f3172 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -139,6 +139,7 @@ enum virtchnl_ops {
 	/* opcode 34, 35, 36, 37 and 38 are reserved */
 	VIRTCHNL_OP_DCF_CMD_DESC = 39,
 	VIRTCHNL_OP_DCF_CMD_BUFF = 40,
+	VIRTCHNL_OP_DCF_DISABLE = 41,
 };
 
 /* These macros are used to generate compilation errors if a structure/union
@@ -250,6 +251,7 @@ VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_vsi_resource);
 #define VIRTCHNL_VF_OFFLOAD_ENCAP_CSUM		0X00200000
 #define VIRTCHNL_VF_OFFLOAD_RX_ENCAP_CSUM	0X00400000
 #define VIRTCHNL_VF_OFFLOAD_ADQ			0X00800000
+#define VIRTCHNL_VF_CAP_DCF			0X40000000
 
 /* Define below the capability flags that are not offloads */
 #define VIRTCHNL_VF_CAP_ADV_LINK_SPEED		0x00000080
@@ -592,6 +594,7 @@ enum virtchnl_event_codes {
 	VIRTCHNL_EVENT_LINK_CHANGE,
 	VIRTCHNL_EVENT_RESET_IMPENDING,
 	VIRTCHNL_EVENT_PF_DRIVER_CLOSE,
+	VIRTCHNL_EVENT_DCF_VSI_MAP_UPDATE,
 };
 
 #define PF_EVENT_SEVERITY_INFO		0
@@ -618,6 +621,10 @@ struct virtchnl_pf_event {
 			u8 link_status;
 			u8 pad[3];
 		} link_event_adv;
+		struct {
+			u16 vf_id;
+			u16 vsi_id;
+		} vf_vsi_map;
 	} event_data;
 
 	int severity;
@@ -838,6 +845,8 @@ virtchnl_vc_validate_vf_msg(struct virtchnl_version_info *ver, u32 v_opcode,
 		 */
 		valid_len = msglen;
 		break;
+	case VIRTCHNL_OP_DCF_DISABLE:
+		break;
 	/* These are always errors coming from the VF. */
 	case VIRTCHNL_OP_EVENT:
 	case VIRTCHNL_OP_UNKNOWN:
-- 
2.26.2

