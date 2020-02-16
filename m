Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD2E160190
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 04:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgBPDo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 22:44:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:33370 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727787AbgBPDo5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 22:44:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Feb 2020 19:44:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,447,1574150400"; 
   d="scan'208";a="257916598"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga004.fm.intel.com with ESMTP; 15 Feb 2020 19:44:56 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/15] ice: Handle LAN overflow event for VF queues
Date:   Sat, 15 Feb 2020 19:44:45 -0800
Message-Id: <20200216034452.1251706-9-jeffrey.t.kirsher@intel.com>
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

Currently we are not handling LAN overflow events. There can be cases
where LAN overflow events occur on VF queues, especially with Link Flow
Control (LFC) enabled on the controlling PF. In order to recover from
the LAN overflow event caused by a VF we need to determine if the queue
belongs to a VF and reset that VF accordingly.

The struct ice_aqc_event_lan_overflow returns a copy of the GLDCB_RTCTQ
register, which tells us what the queue index is in the global/device
space. The global queue index needs to first be converted to a PF space
queue index and then it can be used to find if a VF owns it.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 11 ++++
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |  2 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  3 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 66 +++++++++++++++++++
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  4 ++
 5 files changed, 86 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 6873998cf145..38b6ffb6ad2e 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1661,6 +1661,13 @@ struct ice_aqc_get_pkg_info_resp {
 	struct ice_aqc_get_pkg_info pkg_info[1];
 };
 
+/* Lan Queue Overflow Event (direct, 0x1001) */
+struct ice_aqc_event_lan_overflow {
+	__le32 prtdcb_ruptq;
+	__le32 qtx_ctl;
+	u8 reserved[8];
+};
+
 /**
  * struct ice_aq_desc - Admin Queue (AQ) descriptor
  * @flags: ICE_AQ_FLAG_* flags
@@ -1730,6 +1737,7 @@ struct ice_aq_desc {
 		struct ice_aqc_alloc_free_res_cmd sw_res_ctrl;
 		struct ice_aqc_set_event_mask set_event_mask;
 		struct ice_aqc_get_link_status get_link_status;
+		struct ice_aqc_event_lan_overflow lan_overflow;
 	} params;
 };
 
@@ -1860,6 +1868,9 @@ enum ice_adminq_opc {
 	ice_aqc_opc_update_pkg				= 0x0C42,
 	ice_aqc_opc_get_pkg_info_list			= 0x0C43,
 
+	/* Standalone Commands/Events */
+	ice_aqc_opc_event_lan_overflow			= 0x1001,
+
 	/* debug commands */
 	ice_aqc_opc_fw_logging				= 0xFF09,
 	ice_aqc_opc_fw_logging_info			= 0xFF10,
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 6db3d0494127..b99ebfefe06b 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -286,6 +286,8 @@
 #define GL_PWR_MODE_CTL				0x000B820C
 #define GL_PWR_MODE_CTL_CAR_MAX_BW_S		30
 #define GL_PWR_MODE_CTL_CAR_MAX_BW_M		ICE_M(0x3, 30)
+#define GLDCB_RTCTQ_RXQNUM_S			0
+#define GLDCB_RTCTQ_RXQNUM_M			ICE_M(0x7FF, 0)
 #define GLPRT_BPRCL(_i)				(0x00381380 + ((_i) * 8))
 #define GLPRT_BPTCL(_i)				(0x00381240 + ((_i) * 8))
 #define GLPRT_CRCERRS(_i)			(0x00380100 + ((_i) * 8))
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index ced070427fd7..9bbe9d1fc9a8 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1029,6 +1029,9 @@ static int __ice_clean_ctrlq(struct ice_pf *pf, enum ice_ctl_q q_type)
 			if (ice_handle_link_event(pf, &event))
 				dev_err(dev, "Could not handle link event\n");
 			break;
+		case ice_aqc_opc_event_lan_overflow:
+			ice_vf_lan_overflow_event(pf, &event);
+			break;
 		case ice_mbx_opc_send_msg_to_pf:
 			ice_vc_process_vf_msg(pf, &event);
 			break;
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 3666647da096..53a9e09c8f21 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1513,6 +1513,72 @@ static void ice_vc_reset_vf(struct ice_vf *vf)
 	ice_reset_vf(vf, false);
 }
 
+/**
+ * ice_get_vf_from_pfq - get the VF who owns the PF space queue passed in
+ * @pf: PF used to index all VFs
+ * @pfq: queue index relative to the PF's function space
+ *
+ * If no VF is found who owns the pfq then return NULL, otherwise return a
+ * pointer to the VF who owns the pfq
+ */
+static struct ice_vf *ice_get_vf_from_pfq(struct ice_pf *pf, u16 pfq)
+{
+	int vf_id;
+
+	ice_for_each_vf(pf, vf_id) {
+		struct ice_vf *vf = &pf->vf[vf_id];
+		struct ice_vsi *vsi;
+		u16 rxq_idx;
+
+		vsi = pf->vsi[vf->lan_vsi_idx];
+
+		ice_for_each_rxq(vsi, rxq_idx)
+			if (vsi->rxq_map[rxq_idx] == pfq)
+				return vf;
+	}
+
+	return NULL;
+}
+
+/**
+ * ice_globalq_to_pfq - convert from global queue index to PF space queue index
+ * @pf: PF used for conversion
+ * @globalq: global queue index used to convert to PF space queue index
+ */
+static u32 ice_globalq_to_pfq(struct ice_pf *pf, u32 globalq)
+{
+	return globalq - pf->hw.func_caps.common_cap.rxq_first_id;
+}
+
+/**
+ * ice_vf_lan_overflow_event - handle LAN overflow event for a VF
+ * @pf: PF that the LAN overflow event happened on
+ * @event: structure holding the event information for the LAN overflow event
+ *
+ * Determine if the LAN overflow event was caused by a VF queue. If it was not
+ * caused by a VF, do nothing. If a VF caused this LAN overflow event trigger a
+ * reset on the offending VF.
+ */
+void
+ice_vf_lan_overflow_event(struct ice_pf *pf, struct ice_rq_event_info *event)
+{
+	u32 gldcb_rtctq, queue;
+	struct ice_vf *vf;
+
+	gldcb_rtctq = le32_to_cpu(event->desc.params.lan_overflow.prtdcb_ruptq);
+	dev_dbg(ice_pf_to_dev(pf), "GLDCB_RTCTQ: 0x%08x\n", gldcb_rtctq);
+
+	/* event returns device global Rx queue number */
+	queue = (gldcb_rtctq & GLDCB_RTCTQ_RXQNUM_M) >>
+		GLDCB_RTCTQ_RXQNUM_S;
+
+	vf = ice_get_vf_from_pfq(pf, ice_globalq_to_pfq(pf, queue));
+	if (!vf)
+		return;
+
+	ice_vc_reset_vf(vf);
+}
+
 /**
  * ice_vc_send_msg_to_vf - Send message to VF
  * @vf: pointer to the VF info
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index a1bb196d417a..c65269c15dfc 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -122,6 +122,9 @@ void ice_set_vf_state_qs_dis(struct ice_vf *vf);
 int
 ice_get_vf_stats(struct net_device *netdev, int vf_id,
 		 struct ifla_vf_stats *vf_stats);
+void
+ice_vf_lan_overflow_event(struct ice_pf *pf, struct ice_rq_event_info *event);
+
 #else /* CONFIG_PCI_IOV */
 #define ice_process_vflr_event(pf) do {} while (0)
 #define ice_free_vfs(pf) do {} while (0)
@@ -129,6 +132,7 @@ ice_get_vf_stats(struct net_device *netdev, int vf_id,
 #define ice_vc_notify_link_state(pf) do {} while (0)
 #define ice_vc_notify_reset(pf) do {} while (0)
 #define ice_set_vf_state_qs_dis(vf) do {} while (0)
+#define ice_vf_lan_overflow_event(pf, event) do {} while (0)
 
 static inline bool
 ice_reset_all_vfs(struct ice_pf __always_unused *pf,
-- 
2.24.1

