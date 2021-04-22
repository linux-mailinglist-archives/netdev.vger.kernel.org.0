Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30CA3685EB
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 19:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238259AbhDVRaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 13:30:24 -0400
Received: from mga03.intel.com ([134.134.136.65]:60039 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238468AbhDVRaN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 13:30:13 -0400
IronPort-SDR: MlMg9OvD6z+XZ3zA66dw5SGUO8IK/em8atIK3NFLLQy5s+JDVk5SvMHaIrYLXlBUulLzc5D/Bn
 rzymE6YShcuw==
X-IronPort-AV: E=McAfee;i="6200,9189,9962"; a="195991478"
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="195991478"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 10:29:35 -0700
IronPort-SDR: s13lCHoGW3wJkcVD6yNfZVHlJWQgTTKO56P8Q6S7pi4bF5KLuYGUpJMHP++7gHM79+3smdX9LA
 YjbcOlDjLkAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="535286264"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 22 Apr 2021 10:29:35 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Michal Swiatkowski <michal.swiatkowski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 02/12] ice: Allow ignoring opcodes on specific VF
Date:   Thu, 22 Apr 2021 10:31:20 -0700
Message-Id: <20210422173130.1143082-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210422173130.1143082-1-anthony.l.nguyen@intel.com>
References: <20210422173130.1143082-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@intel.com>

Declare bitmap of allowed commands on VF. Initialize default
opcodes list that should be always supported. Declare array of
supported opcodes for each caps used in virtchnl code.

Change allowed bitmap by setting or clearing corresponding
bit to allowlist (bit set) or denylist (bit clear).

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/Makefile       |   1 +
 .../intel/ice/ice_virtchnl_allowlist.c        | 165 ++++++++++++++++++
 .../intel/ice/ice_virtchnl_allowlist.h        |  13 ++
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  18 ++
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |   1 +
 include/linux/avf/virtchnl.h                  |   1 +
 6 files changed, 199 insertions(+)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_virtchnl_allowlist.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_virtchnl_allowlist.h

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index f391691e2c7e..07fe857e9e3a 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -26,6 +26,7 @@ ice-y := ice_main.o	\
 	 ice_fw_update.o \
 	 ice_lag.o	\
 	 ice_ethtool.o
+ice-$(CONFIG_PCI_IOV) += ice_virtchnl_allowlist.o
 ice-$(CONFIG_PCI_IOV) += ice_virtchnl_pf.o ice_sriov.o ice_virtchnl_fdir.o
 ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_nl.o ice_dcb_lib.o
 ice-$(CONFIG_RFS_ACCEL) += ice_arfs.o
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_allowlist.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_allowlist.c
new file mode 100644
index 000000000000..5a0fbb47346f
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_allowlist.c
@@ -0,0 +1,165 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021, Intel Corporation. */
+
+#include "ice_virtchnl_allowlist.h"
+
+/* Purpose of this file is to share functionality to allowlist or denylist
+ * opcodes used in PF <-> VF communication. Group of opcodes:
+ * - default -> should be always allowed after creating VF,
+ *   default_allowlist_opcodes
+ * - opcodes needed by VF to work correctly, but not associated with caps ->
+ *   should be allowed after successful VF resources allocation,
+ *   working_allowlist_opcodes
+ * - opcodes needed by VF when caps are activated
+ *
+ * Caps that don't use new opcodes (no opcodes should be allowed):
+ * - VIRTCHNL_VF_OFFLOAD_RSS_AQ
+ * - VIRTCHNL_VF_OFFLOAD_RSS_REG
+ * - VIRTCHNL_VF_OFFLOAD_WB_ON_ITR
+ * - VIRTCHNL_VF_OFFLOAD_CRC
+ * - VIRTCHNL_VF_OFFLOAD_RX_POLLING
+ * - VIRTCHNL_VF_OFFLOAD_RSS_PCTYPE_V2
+ * - VIRTCHNL_VF_OFFLOAD_ENCAP
+ * - VIRTCHNL_VF_OFFLOAD_ENCAP_CSUM
+ * - VIRTCHNL_VF_OFFLOAD_RX_ENCAP_CSUM
+ * - VIRTCHNL_VF_OFFLOAD_USO
+ */
+
+/* default opcodes to communicate with VF */
+static const u32 default_allowlist_opcodes[] = {
+	VIRTCHNL_OP_GET_VF_RESOURCES, VIRTCHNL_OP_VERSION, VIRTCHNL_OP_RESET_VF,
+};
+
+/* opcodes supported after successful VIRTCHNL_OP_GET_VF_RESOURCES */
+static const u32 working_allowlist_opcodes[] = {
+	VIRTCHNL_OP_CONFIG_TX_QUEUE, VIRTCHNL_OP_CONFIG_RX_QUEUE,
+	VIRTCHNL_OP_CONFIG_VSI_QUEUES, VIRTCHNL_OP_CONFIG_IRQ_MAP,
+	VIRTCHNL_OP_ENABLE_QUEUES, VIRTCHNL_OP_DISABLE_QUEUES,
+	VIRTCHNL_OP_GET_STATS, VIRTCHNL_OP_EVENT,
+};
+
+/* VIRTCHNL_VF_OFFLOAD_L2 */
+static const u32 l2_allowlist_opcodes[] = {
+	VIRTCHNL_OP_ADD_ETH_ADDR, VIRTCHNL_OP_DEL_ETH_ADDR,
+	VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
+};
+
+/* VIRTCHNL_VF_OFFLOAD_REQ_QUEUES */
+static const u32 req_queues_allowlist_opcodes[] = {
+	VIRTCHNL_OP_REQUEST_QUEUES,
+};
+
+/* VIRTCHNL_VF_OFFLOAD_VLAN */
+static const u32 vlan_allowlist_opcodes[] = {
+	VIRTCHNL_OP_ADD_VLAN, VIRTCHNL_OP_DEL_VLAN,
+	VIRTCHNL_OP_ENABLE_VLAN_STRIPPING, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING,
+};
+
+/* VIRTCHNL_VF_OFFLOAD_RSS_PF */
+static const u32 rss_pf_allowlist_opcodes[] = {
+	VIRTCHNL_OP_CONFIG_RSS_KEY, VIRTCHNL_OP_CONFIG_RSS_LUT,
+	VIRTCHNL_OP_GET_RSS_HENA_CAPS, VIRTCHNL_OP_SET_RSS_HENA,
+};
+
+/* VIRTCHNL_VF_OFFLOAD_FDIR_PF */
+static const u32 fdir_pf_allowlist_opcodes[] = {
+	VIRTCHNL_OP_ADD_FDIR_FILTER, VIRTCHNL_OP_DEL_FDIR_FILTER,
+};
+
+struct allowlist_opcode_info {
+	const u32 *opcodes;
+	size_t size;
+};
+
+#define BIT_INDEX(caps) (HWEIGHT((caps) - 1))
+#define ALLOW_ITEM(caps, list) \
+	[BIT_INDEX(caps)] = { \
+		.opcodes = list, \
+		.size = ARRAY_SIZE(list) \
+	}
+static const struct allowlist_opcode_info allowlist_opcodes[] = {
+	ALLOW_ITEM(VIRTCHNL_VF_OFFLOAD_L2, l2_allowlist_opcodes),
+	ALLOW_ITEM(VIRTCHNL_VF_OFFLOAD_REQ_QUEUES, req_queues_allowlist_opcodes),
+	ALLOW_ITEM(VIRTCHNL_VF_OFFLOAD_VLAN, vlan_allowlist_opcodes),
+	ALLOW_ITEM(VIRTCHNL_VF_OFFLOAD_RSS_PF, rss_pf_allowlist_opcodes),
+	ALLOW_ITEM(VIRTCHNL_VF_OFFLOAD_FDIR_PF, fdir_pf_allowlist_opcodes),
+};
+
+/**
+ * ice_vc_is_opcode_allowed - check if this opcode is allowed on this VF
+ * @vf: pointer to VF structure
+ * @opcode: virtchnl opcode
+ *
+ * Return true if message is allowed on this VF
+ */
+bool ice_vc_is_opcode_allowed(struct ice_vf *vf, u32 opcode)
+{
+	if (opcode >= VIRTCHNL_OP_MAX)
+		return false;
+
+	return test_bit(opcode, vf->opcodes_allowlist);
+}
+
+/**
+ * ice_vc_allowlist_opcodes - allowlist selected opcodes
+ * @vf: pointer to VF structure
+ * @opcodes: array of opocodes to allowlist
+ * @size: size of opcodes array
+ *
+ * Function should be called to allowlist opcodes on VF.
+ */
+static void
+ice_vc_allowlist_opcodes(struct ice_vf *vf, const u32 *opcodes, size_t size)
+{
+	unsigned int i;
+
+	for (i = 0; i < size; i++)
+		set_bit(opcodes[i], vf->opcodes_allowlist);
+}
+
+/**
+ * ice_vc_clear_allowlist - clear all allowlist opcodes
+ * @vf: pointer to VF structure
+ */
+static void ice_vc_clear_allowlist(struct ice_vf *vf)
+{
+	bitmap_zero(vf->opcodes_allowlist, VIRTCHNL_OP_MAX);
+}
+
+/**
+ * ice_vc_set_default_allowlist - allowlist default opcodes for VF
+ * @vf: pointer to VF structure
+ */
+void ice_vc_set_default_allowlist(struct ice_vf *vf)
+{
+	ice_vc_clear_allowlist(vf);
+	ice_vc_allowlist_opcodes(vf, default_allowlist_opcodes,
+				 ARRAY_SIZE(default_allowlist_opcodes));
+}
+
+/**
+ * ice_vc_set_working_allowlist - allowlist opcodes needed to by VF to work
+ * @vf: pointer to VF structure
+ *
+ * allowlist opcodes that aren't associated with specific caps, but
+ * are needed by VF to work.
+ */
+void ice_vc_set_working_allowlist(struct ice_vf *vf)
+{
+	ice_vc_allowlist_opcodes(vf, working_allowlist_opcodes,
+				 ARRAY_SIZE(working_allowlist_opcodes));
+}
+
+/**
+ * ice_vc_set_caps_allowlist - allowlist VF opcodes according caps
+ * @vf: pointer to VF structure
+ */
+void ice_vc_set_caps_allowlist(struct ice_vf *vf)
+{
+	unsigned long caps = vf->driver_caps;
+	unsigned int i;
+
+	for_each_set_bit(i, &caps, ARRAY_SIZE(allowlist_opcodes))
+		ice_vc_allowlist_opcodes(vf, allowlist_opcodes[i].opcodes,
+					 allowlist_opcodes[i].size);
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_allowlist.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_allowlist.h
new file mode 100644
index 000000000000..d3ae86ded219
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_allowlist.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021, Intel Corporation. */
+
+#ifndef _ICE_VIRTCHNL_ALLOWLIST_H_
+#define _ICE_VIRTCHNL_ALLOWLIST_H_
+#include "ice.h"
+
+bool ice_vc_is_opcode_allowed(struct ice_vf *vf, u32 opcode);
+
+void ice_vc_set_default_allowlist(struct ice_vf *vf);
+void ice_vc_set_working_allowlist(struct ice_vf *vf);
+void ice_vc_set_caps_allowlist(struct ice_vf *vf);
+#endif /* _ICE_VIRTCHNL_ALLOWLIST_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index a3ed4b84bba6..ccd6b3e8a5a9 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -5,6 +5,7 @@
 #include "ice_base.h"
 #include "ice_lib.h"
 #include "ice_fltr.h"
+#include "ice_virtchnl_allowlist.h"
 
 /**
  * ice_validate_vf_id - helper to check if VF ID is valid
@@ -1314,6 +1315,9 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 	ice_for_each_vf(pf, v) {
 		vf = &pf->vf[v];
 
+		vf->driver_caps = 0;
+		ice_vc_set_default_allowlist(vf);
+
 		ice_vf_fdir_exit(vf);
 		/* clean VF control VSI when resetting VFs since it should be
 		 * setup only when VF creates its first FDIR rule.
@@ -1418,6 +1422,9 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 		usleep_range(10, 20);
 	}
 
+	vf->driver_caps = 0;
+	ice_vc_set_default_allowlist(vf);
+
 	/* Display a warning if VF didn't manage to reset in time, but need to
 	 * continue on with the operation.
 	 */
@@ -1625,6 +1632,7 @@ static void ice_set_dflt_settings_vfs(struct ice_pf *pf)
 		set_bit(ICE_VIRTCHNL_VF_CAP_L2, &vf->vf_caps);
 		vf->spoofchk = true;
 		vf->num_vf_qs = pf->num_qps_per_vf;
+		ice_vc_set_default_allowlist(vf);
 
 		/* ctrl_vsi_idx will be set to a valid value only when VF
 		 * creates its first fdir rule.
@@ -2127,6 +2135,9 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 	/* match guest capabilities */
 	vf->driver_caps = vfres->vf_cap_flags;
 
+	ice_vc_set_caps_allowlist(vf);
+	ice_vc_set_working_allowlist(vf);
+
 	set_bit(ICE_VF_STATE_ACTIVE, vf->vf_states);
 
 err:
@@ -3840,6 +3851,13 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 			err = -EINVAL;
 	}
 
+	if (!ice_vc_is_opcode_allowed(vf, v_opcode)) {
+		ice_vc_send_msg_to_vf(vf, v_opcode,
+				      VIRTCHNL_STATUS_ERR_NOT_SUPPORTED, NULL,
+				      0);
+		return;
+	}
+
 error_handler:
 	if (err) {
 		ice_vc_send_msg_to_vf(vf, v_opcode, VIRTCHNL_STATUS_ERR_PARAM,
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index bcc2890c930a..d800ed83d6c3 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -103,6 +103,7 @@ struct ice_vf {
 	u16 num_vf_qs;			/* num of queue configured per VF */
 	struct ice_mdd_vf_events mdd_rx_events;
 	struct ice_mdd_vf_events mdd_tx_events;
+	DECLARE_BITMAP(opcodes_allowlist, VIRTCHNL_OP_MAX);
 };
 
 #ifdef CONFIG_PCI_IOV
diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index 40dd6afbfd81..debdd196773b 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -139,6 +139,7 @@ enum virtchnl_ops {
 	/* opcode 34 - 46 are reserved */
 	VIRTCHNL_OP_ADD_FDIR_FILTER = 47,
 	VIRTCHNL_OP_DEL_FDIR_FILTER = 48,
+	VIRTCHNL_OP_MAX,
 };
 
 /* These macros are used to generate compilation errors if a structure/union
-- 
2.26.2

