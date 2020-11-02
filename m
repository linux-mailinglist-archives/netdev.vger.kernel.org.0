Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00CE02A367F
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 23:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgKBWYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 17:24:40 -0500
Received: from mga05.intel.com ([192.55.52.43]:16125 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726755AbgKBWYV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 17:24:21 -0500
IronPort-SDR: 50zOXlwYX9H7jHkqGQ0avxMaXd06WbkZQj619P+cy6URO2yjVD0N+y5O5dM6qK+9zsjb541jU8
 OIkaAdwWcWig==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="253670969"
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="253670969"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 14:24:18 -0800
IronPort-SDR: W/0h9pX+WelZ1dcv65or5OY8ItpPylR8C3chmRydp2qVRvIwL08WmniSrMBabDkua45T7q4tD6
 lHZaiBGx79+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="305591778"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 02 Nov 2020 14:24:17 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Real Valiquette <real.valiquette@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Chinh Cao <chinh.t.cao@intel.com>,
        Brijesh Behera <brijeshx.behera@intel.com>
Subject: [net-next 06/15] ice: create ACL entry
Date:   Mon,  2 Nov 2020 14:23:29 -0800
Message-Id: <20201102222338.1442081-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201102222338.1442081-1-anthony.l.nguyen@intel.com>
References: <20201102222338.1442081-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Real Valiquette <real.valiquette@intel.com>

Create an ACL entry for the mask match data and set the desired action.
Generate and program the associated extraction sequence.

Co-developed-by: Chinh Cao <chinh.t.cao@intel.com>
Signed-off-by: Chinh Cao <chinh.t.cao@intel.com>
Signed-off-by: Real Valiquette <real.valiquette@intel.com>
Co-developed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Brijesh Behera <brijeshx.behera@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |   4 +
 drivers/net/ethernet/intel/ice/ice_acl.c      | 171 +++++
 drivers/net/ethernet/intel/ice/ice_acl.h      |  29 +
 drivers/net/ethernet/intel/ice/ice_acl_main.c |  66 +-
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 121 +++-
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c |  35 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |   4 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |   7 +
 drivers/net/ethernet/intel/ice/ice_flow.c     | 616 +++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_flow.h     |   9 +-
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |   3 +
 11 files changed, 1039 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index d813a5c765d0..31eea8bd92f2 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -601,6 +601,10 @@ int ice_del_ntuple_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd);
 int ice_get_ethtool_fdir_entry(struct ice_hw *hw, struct ethtool_rxnfc *cmd);
 u32 ice_ntuple_get_max_fltr_cnt(struct ice_hw *hw);
 int
+ice_ntuple_set_input_set(struct ice_vsi *vsi, enum ice_block blk,
+			 struct ethtool_rx_flow_spec *fsp,
+			 struct ice_fdir_fltr *input);
+int
 ice_ntuple_l4_proto_to_port(enum ice_flow_seg_hdr l4_proto,
 			    enum ice_flow_field *src_port,
 			    enum ice_flow_field *dst_port);
diff --git a/drivers/net/ethernet/intel/ice/ice_acl.c b/drivers/net/ethernet/intel/ice/ice_acl.c
index 7ff97917aca9..767cccc3ba67 100644
--- a/drivers/net/ethernet/intel/ice/ice_acl.c
+++ b/drivers/net/ethernet/intel/ice/ice_acl.c
@@ -152,6 +152,177 @@ ice_aq_program_actpair(struct ice_hw *hw, u8 act_mem_idx, u16 act_entry_idx,
 				  act_mem_idx, act_entry_idx, buf, cd);
 }
 
+/**
+ * ice_acl_prof_aq_send - sending ACL profile AQ commands
+ * @hw: pointer to the HW struct
+ * @opc: command opcode
+ * @prof_id: profile ID
+ * @buf: ptr to buffer
+ * @cd: pointer to command details structure or NULL
+ *
+ * This function sends ACL profile commands
+ */
+static enum ice_status
+ice_acl_prof_aq_send(struct ice_hw *hw, u16 opc, u8 prof_id,
+		     struct ice_aqc_acl_prof_generic_frmt *buf,
+		     struct ice_sq_cd *cd)
+{
+	struct ice_aq_desc desc;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, opc);
+	desc.params.profile.profile_id = prof_id;
+	if (opc == ice_aqc_opc_program_acl_prof_extraction)
+		desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
+	return ice_aq_send_cmd(hw, &desc, buf, sizeof(*buf), cd);
+}
+
+/**
+ * ice_prgm_acl_prof_xtrct - program ACL profile extraction sequence
+ * @hw: pointer to the HW struct
+ * @prof_id: profile ID
+ * @buf: ptr to buffer
+ * @cd: pointer to command details structure or NULL
+ *
+ * Program ACL profile extraction (indirect 0x0C1D)
+ */
+enum ice_status
+ice_prgm_acl_prof_xtrct(struct ice_hw *hw, u8 prof_id,
+			struct ice_aqc_acl_prof_generic_frmt *buf,
+			struct ice_sq_cd *cd)
+{
+	return ice_acl_prof_aq_send(hw, ice_aqc_opc_program_acl_prof_extraction,
+				    prof_id, buf, cd);
+}
+
+/**
+ * ice_query_acl_prof - query ACL profile
+ * @hw: pointer to the HW struct
+ * @prof_id: profile ID
+ * @buf: ptr to buffer (which will contain response of this command)
+ * @cd: pointer to command details structure or NULL
+ *
+ * Query ACL profile (indirect 0x0C21)
+ */
+enum ice_status
+ice_query_acl_prof(struct ice_hw *hw, u8 prof_id,
+		   struct ice_aqc_acl_prof_generic_frmt *buf,
+		   struct ice_sq_cd *cd)
+{
+	return ice_acl_prof_aq_send(hw, ice_aqc_opc_query_acl_prof, prof_id,
+				    buf, cd);
+}
+
+/**
+ * ice_aq_acl_cntrs_chk_params - Checks ACL counter parameters
+ * @cntrs: ptr to buffer describing input and output params
+ *
+ * This function checks the counter bank range for counter type and returns
+ * success or failure.
+ */
+static enum ice_status ice_aq_acl_cntrs_chk_params(struct ice_acl_cntrs *cntrs)
+{
+	enum ice_status status = 0;
+
+	if (!cntrs || !cntrs->amount)
+		return ICE_ERR_PARAM;
+
+	switch (cntrs->type) {
+	case ICE_AQC_ACL_CNT_TYPE_SINGLE:
+		/* Single counter type - configured to count either bytes
+		 * or packets, the valid values for byte or packet counters
+		 * shall be 0-3.
+		 */
+		if (cntrs->bank > ICE_AQC_ACL_MAX_CNT_SINGLE)
+			status = ICE_ERR_OUT_OF_RANGE;
+		break;
+	case ICE_AQC_ACL_CNT_TYPE_DUAL:
+		/* Pair counter type - counts number of bytes and packets
+		 * The valid values for byte/packet counter duals shall be 0-1
+		 */
+		if (cntrs->bank > ICE_AQC_ACL_MAX_CNT_DUAL)
+			status = ICE_ERR_OUT_OF_RANGE;
+		break;
+	default:
+		/* Unspecified counter type - Invalid or error */
+		status = ICE_ERR_PARAM;
+	}
+
+	return status;
+}
+
+/**
+ * ice_aq_alloc_acl_cntrs - allocate ACL counters
+ * @hw: pointer to the HW struct
+ * @cntrs: ptr to buffer describing input and output params
+ * @cd: pointer to command details structure or NULL
+ *
+ * Allocate ACL counters (indirect 0x0C16). This function attempts to
+ * allocate a contiguous block of counters. In case of failures, caller can
+ * attempt to allocate a smaller chunk. The allocation is considered
+ * unsuccessful if returned counter value is invalid. In this case it returns
+ * an error otherwise success.
+ */
+enum ice_status
+ice_aq_alloc_acl_cntrs(struct ice_hw *hw, struct ice_acl_cntrs *cntrs,
+		       struct ice_sq_cd *cd)
+{
+	struct ice_aqc_acl_alloc_counters *cmd;
+	u16 first_cntr, last_cntr;
+	struct ice_aq_desc desc;
+	enum ice_status status;
+
+	/* check for invalid params */
+	status = ice_aq_acl_cntrs_chk_params(cntrs);
+	if (status)
+		return status;
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_alloc_acl_counters);
+	cmd = &desc.params.alloc_counters;
+	cmd->counter_amount = cntrs->amount;
+	cmd->counters_type = cntrs->type;
+	cmd->bank_alloc = cntrs->bank;
+	status = ice_aq_send_cmd(hw, &desc, NULL, 0, cd);
+	if (!status) {
+		first_cntr = le16_to_cpu(cmd->ops.resp.first_counter);
+		last_cntr = le16_to_cpu(cmd->ops.resp.last_counter);
+		if (first_cntr == ICE_AQC_ACL_ALLOC_CNT_INVAL ||
+		    last_cntr == ICE_AQC_ACL_ALLOC_CNT_INVAL)
+			return ICE_ERR_OUT_OF_RANGE;
+		cntrs->first_cntr = first_cntr;
+		cntrs->last_cntr = last_cntr;
+	}
+	return status;
+}
+
+/**
+ * ice_aq_dealloc_acl_cntrs - deallocate ACL counters
+ * @hw: pointer to the HW struct
+ * @cntrs: ptr to buffer describing input and output params
+ * @cd: pointer to command details structure or NULL
+ *
+ * De-allocate ACL counters (direct 0x0C17)
+ */
+enum ice_status
+ice_aq_dealloc_acl_cntrs(struct ice_hw *hw, struct ice_acl_cntrs *cntrs,
+			 struct ice_sq_cd *cd)
+{
+	struct ice_aqc_acl_dealloc_counters *cmd;
+	struct ice_aq_desc desc;
+	enum ice_status status;
+
+	/* check for invalid params */
+	status = ice_aq_acl_cntrs_chk_params(cntrs);
+	if (status)
+		return status;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_dealloc_acl_counters);
+	cmd = &desc.params.dealloc_counters;
+	cmd->first_counter = cpu_to_le16(cntrs->first_cntr);
+	cmd->last_counter = cpu_to_le16(cntrs->last_cntr);
+	cmd->counters_type = cntrs->type;
+	cmd->bank_alloc = cntrs->bank;
+	return ice_aq_send_cmd(hw, &desc, NULL, 0, cd);
+}
+
 /**
  * ice_aq_alloc_acl_scen - allocate ACL scenario
  * @hw: pointer to the HW struct
diff --git a/drivers/net/ethernet/intel/ice/ice_acl.h b/drivers/net/ethernet/intel/ice/ice_acl.h
index 9e776f3f749c..8235d16bd162 100644
--- a/drivers/net/ethernet/intel/ice/ice_acl.h
+++ b/drivers/net/ethernet/intel/ice/ice_acl.h
@@ -103,6 +103,21 @@ struct ice_acl_alloc_tbl {
 	} buf;
 };
 
+/* This structure is used to communicate input and output params for
+ * [de]allocate_acl_counters
+ */
+struct ice_acl_cntrs {
+	u8 amount;
+	u8 type;
+	u8 bank;
+
+	/* Next 2 variables are used for output in case of alloc_acl_counters
+	 * and input in case of deallocate_acl_counters
+	 */
+	u16 first_cntr;
+	u16 last_cntr;
+};
+
 enum ice_status
 ice_acl_create_tbl(struct ice_hw *hw, struct ice_acl_tbl_params *params);
 enum ice_status ice_acl_destroy_tbl(struct ice_hw *hw);
@@ -122,6 +137,20 @@ enum ice_status
 ice_aq_program_actpair(struct ice_hw *hw, u8 act_mem_idx, u16 act_entry_idx,
 		       struct ice_aqc_actpair *buf, struct ice_sq_cd *cd);
 enum ice_status
+ice_prgm_acl_prof_xtrct(struct ice_hw *hw, u8 prof_id,
+			struct ice_aqc_acl_prof_generic_frmt *buf,
+			struct ice_sq_cd *cd);
+enum ice_status
+ice_query_acl_prof(struct ice_hw *hw, u8 prof_id,
+		   struct ice_aqc_acl_prof_generic_frmt *buf,
+		   struct ice_sq_cd *cd);
+enum ice_status
+ice_aq_alloc_acl_cntrs(struct ice_hw *hw, struct ice_acl_cntrs *cntrs,
+		       struct ice_sq_cd *cd);
+enum ice_status
+ice_aq_dealloc_acl_cntrs(struct ice_hw *hw, struct ice_acl_cntrs *cntrs,
+			 struct ice_sq_cd *cd);
+enum ice_status
 ice_aq_alloc_acl_scen(struct ice_hw *hw, u16 *scen_id,
 		      struct ice_aqc_acl_scen *buf, struct ice_sq_cd *cd);
 enum ice_status
diff --git a/drivers/net/ethernet/intel/ice/ice_acl_main.c b/drivers/net/ethernet/intel/ice/ice_acl_main.c
index be97dfb94652..3b56194ab3fc 100644
--- a/drivers/net/ethernet/intel/ice/ice_acl_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_acl_main.c
@@ -6,6 +6,9 @@
 #include "ice.h"
 #include "ice_lib.h"
 
+/* Default ACL Action priority */
+#define ICE_ACL_ACT_PRIO	3
+
 /* Number of action */
 #define ICE_ACL_NUM_ACT		1
 
@@ -246,15 +249,76 @@ ice_acl_check_input_set(struct ice_pf *pf, struct ethtool_rx_flow_spec *fsp)
  */
 int ice_acl_add_rule_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd)
 {
+	struct ice_flow_action acts[ICE_ACL_NUM_ACT];
 	struct ethtool_rx_flow_spec *fsp;
+	struct ice_fd_hw_prof *hw_prof;
+	struct ice_fdir_fltr *input;
+	enum ice_fltr_ptype flow;
+	enum ice_status status;
+	struct device *dev;
 	struct ice_pf *pf;
+	struct ice_hw *hw;
+	u64 entry_h = 0;
+	int act_cnt;
+	int ret;
 
 	if (!vsi || !cmd)
 		return -EINVAL;
 
 	pf = vsi->back;
+	hw = &pf->hw;
+	dev = ice_pf_to_dev(pf);
 
 	fsp = (struct ethtool_rx_flow_spec *)&cmd->fs;
 
-	return ice_acl_check_input_set(pf, fsp);
+	ret = ice_acl_check_input_set(pf, fsp);
+	if (ret)
+		return ret;
+
+	/* Add new rule */
+	input = devm_kzalloc(dev, sizeof(*input), GFP_KERNEL);
+	if (!input)
+		return -ENOMEM;
+
+	ret = ice_ntuple_set_input_set(vsi, ICE_BLK_ACL, fsp, input);
+	if (ret)
+		goto free_input;
+
+	memset(&acts, 0, sizeof(acts));
+	act_cnt = 1;
+	if (fsp->ring_cookie == RX_CLS_FLOW_DISC) {
+		acts[0].type = ICE_FLOW_ACT_DROP;
+		acts[0].data.acl_act.mdid = ICE_MDID_RX_PKT_DROP;
+		acts[0].data.acl_act.prio = ICE_ACL_ACT_PRIO;
+		acts[0].data.acl_act.value = cpu_to_le16(0x1);
+	} else {
+		acts[0].type = ICE_FLOW_ACT_FWD_QUEUE;
+		acts[0].data.acl_act.mdid = ICE_MDID_RX_DST_Q;
+		acts[0].data.acl_act.prio = ICE_ACL_ACT_PRIO;
+		acts[0].data.acl_act.value = cpu_to_le16(input->q_index);
+	}
+
+	flow = ice_ethtool_flow_to_fltr(fsp->flow_type & ~FLOW_EXT);
+	hw_prof = hw->acl_prof[flow];
+
+	status = ice_flow_add_entry(hw, ICE_BLK_ACL, flow, fsp->location,
+				    vsi->idx, ICE_FLOW_PRIO_NORMAL, input, acts,
+				    act_cnt, &entry_h);
+	if (status) {
+		dev_err(dev, "Could not add flow entry %d\n", flow);
+		ret = ice_status_to_errno(status);
+		goto free_input;
+	}
+
+	if (!hw_prof->cnt || vsi->idx != hw_prof->vsi_h[hw_prof->cnt - 1]) {
+		hw_prof->vsi_h[hw_prof->cnt] = vsi->idx;
+		hw_prof->entry_h[hw_prof->cnt++][0] = entry_h;
+	}
+
+	return 0;
+
+free_input:
+	devm_kfree(dev, input);
+
+	return ret;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index f5fdab2b7058..5449c5f6e10c 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1787,6 +1787,68 @@ struct ice_aqc_acl_scen {
 	u8 act_mem_cfg[ICE_AQC_MAX_ACTION_MEMORIES];
 };
 
+/* Allocate ACL counters (indirect 0x0C16) */
+struct ice_aqc_acl_alloc_counters {
+	/* Amount of contiguous counters requested. Min value is 1 and
+	 * max value is 255
+	 */
+	u8 counter_amount;
+
+	/* Counter type: 'single counter' which can be configured to count
+	 * either bytes or packets
+	 */
+#define ICE_AQC_ACL_CNT_TYPE_SINGLE	0x0
+
+	/* Counter type: 'counter pair' which counts number of bytes and number
+	 * of packets.
+	 */
+#define ICE_AQC_ACL_CNT_TYPE_DUAL	0x1
+	/* requested counter type, single/dual */
+	u8 counters_type;
+
+	/* counter bank allocation shall be 0-3 for 'byte or packet counter' */
+#define ICE_AQC_ACL_MAX_CNT_SINGLE	0x3
+	/* counter bank allocation shall be 0-1 for 'byte and packet counter dual' */
+#define ICE_AQC_ACL_MAX_CNT_DUAL	0x1
+	/* requested counter bank allocation */
+	u8 bank_alloc;
+
+	u8 reserved;
+
+	union {
+		/* Applicable only in case of command */
+		struct {
+			u8 reserved[12];
+		} cmd;
+		/* Applicable only in case of response */
+#define ICE_AQC_ACL_ALLOC_CNT_INVAL	0xFFFF
+		struct {
+			/* Index of first allocated counter. 0xFFFF in case
+			 * of unsuccessful allocation
+			 */
+			__le16 first_counter;
+			/* Index of last allocated counter. 0xFFFF in case
+			 * of unsuccessful allocation
+			 */
+			__le16 last_counter;
+			u8 rsvd[8];
+		} resp;
+	} ops;
+};
+
+/* De-allocate ACL counters (direct 0x0C17) */
+struct ice_aqc_acl_dealloc_counters {
+	/* first counter being released */
+	__le16 first_counter;
+	/* last counter being released */
+	__le16 last_counter;
+	/* requested counter type, single/dual */
+	u8 counters_type;
+	/* requested counter bank allocation */
+	u8 bank_alloc;
+	u8 reserved[10];
+};
+
 /* Program ACL actionpair (indirect 0x0C1C) */
 struct ice_aqc_acl_actpair {
 	/* action mem index to program/update */
@@ -1816,13 +1878,57 @@ struct ice_aqc_actpair {
 	struct ice_acl_act_entry act[ICE_ACL_NUM_ACT_PER_ACT_PAIR];
 };
 
-/* The first byte of the byte selection base is reserved to keep the
- * first byte of the field vector where the packet direction info is
- * available. Thus we should start at index 1 of the field vector to
- * map its entries to the byte selection base.
+/* Generic format used to describe either input or response buffer
+ * for admin commands related to ACL profile
  */
+struct ice_aqc_acl_prof_generic_frmt {
+	/* The first byte of the byte selection base is reserved to keep the
+	 * first byte of the field vector where the packet direction info is
+	 * available. Thus we should start at index 1 of the field vector to
+	 * map its entries to the byte selection base.
+	 */
 #define ICE_AQC_ACL_PROF_BYTE_SEL_START_IDX	1
+	/* In each byte:
+	 * Bit 0..5 = Byte selection for the byte selection base from the
+	 * extracted fields (expressed as byte offset in extracted fields).
+	 * Applicable values are 0..63
+	 * Bit 6..7 = Reserved
+	 */
 #define ICE_AQC_ACL_PROF_BYTE_SEL_ELEMS		30
+	u8 byte_selection[ICE_AQC_ACL_PROF_BYTE_SEL_ELEMS];
+	/* In each byte:
+	 * Bit 0..4 = Word selection for the word selection base from the
+	 * extracted fields (expressed as word offset in extracted fields).
+	 * Applicable values are 0..31
+	 * Bit 5..7 = Reserved
+	 */
+#define ICE_AQC_ACL_PROF_WORD_SEL_ELEMS		32
+	u8 word_selection[ICE_AQC_ACL_PROF_WORD_SEL_ELEMS];
+	/* In each byte:
+	 * Bit 0..3 = Double word selection for the double-word selection base
+	 * from the extracted fields (expressed as double-word offset in
+	 * extracted fields).
+	 * Applicable values are 0..15
+	 * Bit 4..7 = Reserved
+	 */
+#define ICE_AQC_ACL_PROF_DWORD_SEL_ELEMS	15
+	u8 dword_selection[ICE_AQC_ACL_PROF_DWORD_SEL_ELEMS];
+	/* Scenario numbers for individual Physical Function's */
+#define ICE_AQC_ACL_PROF_PF_SCEN_NUM_ELEMS	8
+	u8 pf_scenario_num[ICE_AQC_ACL_PROF_PF_SCEN_NUM_ELEMS];
+};
+
+/* Program ACL profile extraction (indirect 0x0C1D)
+ * Program ACL profile ranges (indirect 0x0C1E)
+ * Query ACL profile (indirect 0x0C21)
+ * Query ACL profile ranges (indirect 0x0C22)
+ */
+struct ice_aqc_acl_profile {
+	u8 profile_id; /* Programmed/Updated profile ID */
+	u8 reserved[7];
+	__le32 addr_high;
+	__le32 addr_low;
+};
 
 /* Input buffer format for program profile extraction admin command and
  * response buffer format for query profile admin command is as defined
@@ -2150,8 +2256,11 @@ struct ice_aq_desc {
 		struct ice_aqc_acl_alloc_scen alloc_scen;
 		struct ice_aqc_acl_dealloc_scen dealloc_scen;
 		struct ice_aqc_acl_update_query_scen update_query_scen;
+		struct ice_aqc_acl_alloc_counters alloc_counters;
+		struct ice_aqc_acl_dealloc_counters dealloc_counters;
 		struct ice_aqc_acl_entry program_query_entry;
 		struct ice_aqc_acl_actpair program_query_actpair;
+		struct ice_aqc_acl_profile profile;
 		struct ice_aqc_add_txqs add_txqs;
 		struct ice_aqc_dis_txqs dis_txqs;
 		struct ice_aqc_add_get_update_free_vsi vsi_cmd;
@@ -2301,9 +2410,13 @@ enum ice_adminq_opc {
 	ice_aqc_opc_dealloc_acl_tbl			= 0x0C11,
 	ice_aqc_opc_alloc_acl_scen			= 0x0C14,
 	ice_aqc_opc_dealloc_acl_scen			= 0x0C15,
+	ice_aqc_opc_alloc_acl_counters			= 0x0C16,
+	ice_aqc_opc_dealloc_acl_counters		= 0x0C17,
 	ice_aqc_opc_update_acl_scen			= 0x0C1B,
 	ice_aqc_opc_program_acl_actpair			= 0x0C1C,
+	ice_aqc_opc_program_acl_prof_extraction		= 0x0C1D,
 	ice_aqc_opc_program_acl_entry			= 0x0C20,
+	ice_aqc_opc_query_acl_prof			= 0x0C21,
 	ice_aqc_opc_query_acl_scen			= 0x0C23,
 
 	/* Tx queue handling commands/events */
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
index ef641bc8ca0e..dd495f6a4adf 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
@@ -402,7 +402,7 @@ void ice_fdir_replay_flows(struct ice_hw *hw)
 							 prof->vsi_h[0],
 							 prof->vsi_h[j],
 							 prio, prof->fdir_seg,
-							 &entry_h);
+							 NULL, 0, &entry_h);
 				if (err) {
 					dev_err(ice_hw_to_dev(hw), "Could not replay Flow Director, flow type %d\n",
 						flow);
@@ -606,14 +606,14 @@ ice_fdir_set_hw_fltr_rule(struct ice_pf *pf, struct ice_flow_seg_info *seg,
 		return ice_status_to_errno(status);
 	status = ice_flow_add_entry(hw, ICE_BLK_FD, prof_id, main_vsi->idx,
 				    main_vsi->idx, ICE_FLOW_PRIO_NORMAL,
-				    seg, &entry1_h);
+				    seg, NULL, 0, &entry1_h);
 	if (status) {
 		err = ice_status_to_errno(status);
 		goto err_prof;
 	}
 	status = ice_flow_add_entry(hw, ICE_BLK_FD, prof_id, main_vsi->idx,
 				    ctrl_vsi->idx, ICE_FLOW_PRIO_NORMAL,
-				    seg, &entry2_h);
+				    seg, NULL, 0, &entry2_h);
 	if (status) {
 		err = ice_status_to_errno(status);
 		goto err_entry;
@@ -1642,24 +1642,33 @@ static bool ice_is_acl_filter(struct ethtool_rx_flow_spec *fsp)
 }
 
 /**
- * ice_ntuple_set_input_set - Set the input set for Flow Director
+ * ice_ntuple_set_input_set - Set the input set for specified block
  * @vsi: pointer to target VSI
+ * @blk: filter block to configure
  * @fsp: pointer to ethtool Rx flow specification
  * @input: filter structure
  */
-static int
-ice_ntuple_set_input_set(struct ice_vsi *vsi, struct ethtool_rx_flow_spec *fsp,
+int
+ice_ntuple_set_input_set(struct ice_vsi *vsi, enum ice_block blk,
+			 struct ethtool_rx_flow_spec *fsp,
 			 struct ice_fdir_fltr *input)
 {
 	u16 dest_vsi, q_index = 0;
+	int flow_type, flow_mask;
 	struct ice_pf *pf;
 	struct ice_hw *hw;
-	int flow_type;
 	u8 dest_ctl;
 
 	if (!vsi || !fsp || !input)
 		return -EINVAL;
 
+	if (blk == ICE_BLK_FD)
+		flow_mask = FLOW_EXT;
+	else if (blk == ICE_BLK_ACL)
+		flow_mask = FLOW_MAC_EXT;
+	else
+		return -EINVAL;
+
 	pf = vsi->back;
 	hw = &pf->hw;
 
@@ -1671,8 +1680,8 @@ ice_ntuple_set_input_set(struct ice_vsi *vsi, struct ethtool_rx_flow_spec *fsp,
 		u8 vf = ethtool_get_flow_spec_ring_vf(fsp->ring_cookie);
 
 		if (vf) {
-			dev_err(ice_pf_to_dev(pf), "Failed to add filter. Flow director filters are not supported on VF queues.\n");
-			return -EINVAL;
+			dev_err(ice_pf_to_dev(pf), "Failed to add filter. %s filters are not supported on VF queues.\n",
+				blk == ICE_BLK_FD ? "Flow Director" : "ACL");
 		}
 
 		if (ring >= vsi->num_rxq)
@@ -1684,7 +1693,7 @@ ice_ntuple_set_input_set(struct ice_vsi *vsi, struct ethtool_rx_flow_spec *fsp,
 
 	input->fltr_id = fsp->location;
 	input->q_index = q_index;
-	flow_type = fsp->flow_type & ~FLOW_EXT;
+	flow_type = fsp->flow_type & ~flow_mask;
 
 	input->dest_vsi = dest_vsi;
 	input->dest_ctl = dest_ctl;
@@ -1733,9 +1742,9 @@ ice_ntuple_set_input_set(struct ice_vsi *vsi, struct ethtool_rx_flow_spec *fsp,
 	case TCP_V6_FLOW:
 	case UDP_V6_FLOW:
 	case SCTP_V6_FLOW:
-		memcpy(input->ip.v6.dst_ip, fsp->h_u.usr_ip6_spec.ip6dst,
+		memcpy(input->ip.v6.dst_ip, fsp->h_u.tcp_ip6_spec.ip6dst,
 		       sizeof(struct in6_addr));
-		memcpy(input->ip.v6.src_ip, fsp->h_u.usr_ip6_spec.ip6src,
+		memcpy(input->ip.v6.src_ip, fsp->h_u.tcp_ip6_spec.ip6src,
 		       sizeof(struct in6_addr));
 		input->ip.v6.dst_port = fsp->h_u.tcp_ip6_spec.pdst;
 		input->ip.v6.src_port = fsp->h_u.tcp_ip6_spec.psrc;
@@ -1840,7 +1849,7 @@ int ice_add_ntuple_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd)
 	if (!input)
 		return -ENOMEM;
 
-	ret = ice_ntuple_set_input_set(vsi, fsp, input);
+	ret = ice_ntuple_set_input_set(vsi, ICE_BLK_FD, fsp, input);
 	if (ret)
 		goto free_input;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 696d08e6716d..da9797c11a8d 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -649,7 +649,7 @@ static bool ice_bits_max_set(const u8 *mask, u16 size, u16 max)
  *	dc == NULL --> dc mask is all 0's (no don't care bits)
  *	nm == NULL --> nm mask is all 0's (no never match bits)
  */
-static enum ice_status
+enum ice_status
 ice_set_key(u8 *key, u16 size, u8 *val, u8 *upd, u8 *dc, u8 *nm, u16 off,
 	    u16 len)
 {
@@ -3847,7 +3847,7 @@ ice_add_prof(struct ice_hw *hw, enum ice_block blk, u64 id, u8 ptypes[],
  * This will search for a profile tracking ID which was previously added.
  * The profile map lock should be held before calling this function.
  */
-static struct ice_prof_map *
+struct ice_prof_map *
 ice_search_prof_id(struct ice_hw *hw, enum ice_block blk, u64 id)
 {
 	struct ice_prof_map *entry = NULL;
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
index 20deddb807c5..61fd8f2fc959 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
@@ -40,6 +40,13 @@ void ice_free_seg(struct ice_hw *hw);
 void ice_fill_blk_tbls(struct ice_hw *hw);
 void ice_clear_hw_tbls(struct ice_hw *hw);
 void ice_free_hw_tbls(struct ice_hw *hw);
+struct ice_prof_map *
+ice_search_prof_id(struct ice_hw *hw, enum ice_block blk, u64 id);
 enum ice_status
 ice_rem_prof(struct ice_hw *hw, enum ice_block blk, u64 id);
+
+enum ice_status
+ice_set_key(u8 *key, u16 size, u8 *val, u8 *upd, u8 *dc, u8 *nm, u16 off,
+	    u16 len);
+
 #endif /* _ICE_FLEX_PIPE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
index d2df5101ef74..7ea94a627c5d 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.c
+++ b/drivers/net/ethernet/intel/ice/ice_flow.c
@@ -833,9 +833,161 @@ ice_dealloc_flow_entry(struct ice_hw *hw, struct ice_flow_entry *entry)
 	if (entry->entry)
 		devm_kfree(ice_hw_to_dev(hw), entry->entry);
 
+	if (entry->range_buf) {
+		devm_kfree(ice_hw_to_dev(hw), entry->range_buf);
+		entry->range_buf = NULL;
+	}
+
+	if (entry->acts) {
+		devm_kfree(ice_hw_to_dev(hw), entry->acts);
+		entry->acts = NULL;
+		entry->acts_cnt = 0;
+	}
+
 	devm_kfree(ice_hw_to_dev(hw), entry);
 }
 
+/**
+ * ice_flow_get_hw_prof - return the HW profile for a specific profile ID handle
+ * @hw: pointer to the HW struct
+ * @blk: classification stage
+ * @prof_id: the profile ID handle
+ * @hw_prof_id: pointer to variable to receive the HW profile ID
+ */
+static enum ice_status
+ice_flow_get_hw_prof(struct ice_hw *hw, enum ice_block blk, u64 prof_id,
+		     u8 *hw_prof_id)
+{
+	enum ice_status status = ICE_ERR_DOES_NOT_EXIST;
+	struct ice_prof_map *map;
+
+	mutex_lock(&hw->blk[blk].es.prof_map_lock);
+	map = ice_search_prof_id(hw, blk, prof_id);
+	if (map) {
+		*hw_prof_id = map->prof_id;
+		status = 0;
+	}
+	mutex_unlock(&hw->blk[blk].es.prof_map_lock);
+	return status;
+}
+
+#define ICE_ACL_INVALID_SCEN	0x3f
+
+/**
+ * ice_flow_acl_is_prof_in_use - Verify if the profile is associated to any PF
+ * @hw: pointer to the hardware structure
+ * @prof: pointer to flow profile
+ * @buf: destination buffer function writes partial extraction sequence to
+ *
+ * returns ICE_SUCCESS if no PF is associated to the given profile
+ * returns ICE_ERR_IN_USE if at least one PF is associated to the given profile
+ * returns other error code for real error
+ */
+static enum ice_status
+ice_flow_acl_is_prof_in_use(struct ice_hw *hw, struct ice_flow_prof *prof,
+			    struct ice_aqc_acl_prof_generic_frmt *buf)
+{
+	enum ice_status status;
+	u8 prof_id = 0;
+
+	status = ice_flow_get_hw_prof(hw, ICE_BLK_ACL, prof->id, &prof_id);
+	if (status)
+		return status;
+
+	status = ice_query_acl_prof(hw, prof_id, buf, NULL);
+	if (status)
+		return status;
+
+	/* If all PF's associated scenarios are all 0 or all
+	 * ICE_ACL_INVALID_SCEN (63) for the given profile then the latter has
+	 * not been configured yet.
+	 */
+	if (buf->pf_scenario_num[0] == 0 && buf->pf_scenario_num[1] == 0 &&
+	    buf->pf_scenario_num[2] == 0 && buf->pf_scenario_num[3] == 0 &&
+	    buf->pf_scenario_num[4] == 0 && buf->pf_scenario_num[5] == 0 &&
+	    buf->pf_scenario_num[6] == 0 && buf->pf_scenario_num[7] == 0)
+		return 0;
+
+	if (buf->pf_scenario_num[0] == ICE_ACL_INVALID_SCEN &&
+	    buf->pf_scenario_num[1] == ICE_ACL_INVALID_SCEN &&
+	    buf->pf_scenario_num[2] == ICE_ACL_INVALID_SCEN &&
+	    buf->pf_scenario_num[3] == ICE_ACL_INVALID_SCEN &&
+	    buf->pf_scenario_num[4] == ICE_ACL_INVALID_SCEN &&
+	    buf->pf_scenario_num[5] == ICE_ACL_INVALID_SCEN &&
+	    buf->pf_scenario_num[6] == ICE_ACL_INVALID_SCEN &&
+	    buf->pf_scenario_num[7] == ICE_ACL_INVALID_SCEN)
+		return 0;
+
+	return ICE_ERR_IN_USE;
+}
+
+/**
+ * ice_flow_acl_free_act_cntr - Free the ACL rule's actions
+ * @hw: pointer to the hardware structure
+ * @acts: array of actions to be performed on a match
+ * @acts_cnt: number of actions
+ */
+static enum ice_status
+ice_flow_acl_free_act_cntr(struct ice_hw *hw, struct ice_flow_action *acts,
+			   u8 acts_cnt)
+{
+	int i;
+
+	for (i = 0; i < acts_cnt; i++) {
+		if (acts[i].type == ICE_FLOW_ACT_CNTR_PKT ||
+		    acts[i].type == ICE_FLOW_ACT_CNTR_BYTES ||
+		    acts[i].type == ICE_FLOW_ACT_CNTR_PKT_BYTES) {
+			struct ice_acl_cntrs cntrs;
+			enum ice_status status;
+
+			cntrs.bank = 0; /* Only bank0 for the moment */
+			cntrs.first_cntr =
+					le16_to_cpu(acts[i].data.acl_act.value);
+			cntrs.last_cntr =
+					le16_to_cpu(acts[i].data.acl_act.value);
+
+			if (acts[i].type == ICE_FLOW_ACT_CNTR_PKT_BYTES)
+				cntrs.type = ICE_AQC_ACL_CNT_TYPE_DUAL;
+			else
+				cntrs.type = ICE_AQC_ACL_CNT_TYPE_SINGLE;
+
+			status = ice_aq_dealloc_acl_cntrs(hw, &cntrs, NULL);
+			if (status)
+				return status;
+		}
+	}
+	return 0;
+}
+
+/**
+ * ice_flow_acl_disassoc_scen - Disassociate the scenario from the profile
+ * @hw: pointer to the hardware structure
+ * @prof: pointer to flow profile
+ *
+ * Disassociate the scenario from the profile for the PF of the VSI.
+ */
+static enum ice_status
+ice_flow_acl_disassoc_scen(struct ice_hw *hw, struct ice_flow_prof *prof)
+{
+	struct ice_aqc_acl_prof_generic_frmt buf;
+	enum ice_status status = 0;
+	u8 prof_id = 0;
+
+	memset(&buf, 0, sizeof(buf));
+
+	status = ice_flow_get_hw_prof(hw, ICE_BLK_ACL, prof->id, &prof_id);
+	if (status)
+		return status;
+
+	status = ice_query_acl_prof(hw, prof_id, &buf, NULL);
+	if (status)
+		return status;
+
+	/* Clear scenario for this PF */
+	buf.pf_scenario_num[hw->pf_id] = ICE_ACL_INVALID_SCEN;
+	return ice_prgm_acl_prof_xtrct(hw, prof_id, &buf, NULL);
+}
+
 /**
  * ice_flow_rem_entry_sync - Remove a flow entry
  * @hw: pointer to the HW struct
@@ -843,12 +995,19 @@ ice_dealloc_flow_entry(struct ice_hw *hw, struct ice_flow_entry *entry)
  * @entry: flow entry to be removed
  */
 static enum ice_status
-ice_flow_rem_entry_sync(struct ice_hw *hw, enum ice_block __always_unused blk,
+ice_flow_rem_entry_sync(struct ice_hw *hw, enum ice_block blk,
 			struct ice_flow_entry *entry)
 {
 	if (!entry)
 		return ICE_ERR_BAD_PTR;
 
+	if (blk == ICE_BLK_ACL) {
+		/* Checks if we need to release an ACL counter. */
+		if (entry->acts_cnt && entry->acts)
+			ice_flow_acl_free_act_cntr(hw, entry->acts,
+						   entry->acts_cnt);
+	}
+
 	list_del(&entry->l_entry);
 
 	ice_dealloc_flow_entry(hw, entry);
@@ -966,6 +1125,13 @@ ice_flow_rem_prof_sync(struct ice_hw *hw, enum ice_block blk,
 		mutex_unlock(&prof->entries_lock);
 	}
 
+	if (blk == ICE_BLK_ACL) {
+		/* Disassociate the scenario from the profile for the PF */
+		status = ice_flow_acl_disassoc_scen(hw, prof);
+		if (status)
+			return status;
+	}
+
 	/* Remove all hardware profiles associated with this flow profile */
 	status = ice_rem_prof(hw, blk, prof->id);
 	if (!status) {
@@ -977,6 +1143,89 @@ ice_flow_rem_prof_sync(struct ice_hw *hw, enum ice_block blk,
 	return status;
 }
 
+/**
+ * ice_flow_acl_set_xtrct_seq_fld - Populate xtrct seq for single field
+ * @buf: Destination buffer function writes partial xtrct sequence to
+ * @info: Info about field
+ */
+static void
+ice_flow_acl_set_xtrct_seq_fld(struct ice_aqc_acl_prof_generic_frmt *buf,
+			       struct ice_flow_fld_info *info)
+{
+	u16 dst, i;
+	u8 src;
+
+	src = info->xtrct.idx * ICE_FLOW_FV_EXTRACT_SZ +
+		info->xtrct.disp / BITS_PER_BYTE;
+	dst = info->entry.val;
+	for (i = 0; i < info->entry.last; i++)
+		/* HW stores field vector words in LE, convert words back to BE
+		 * so constructed entries will end up in network order
+		 */
+		buf->byte_selection[dst++] = src++ ^ 1;
+}
+
+/**
+ * ice_flow_acl_set_xtrct_seq - Program ACL extraction sequence
+ * @hw: pointer to the hardware structure
+ * @prof: pointer to flow profile
+ */
+static enum ice_status
+ice_flow_acl_set_xtrct_seq(struct ice_hw *hw, struct ice_flow_prof *prof)
+{
+	struct ice_aqc_acl_prof_generic_frmt buf;
+	struct ice_flow_fld_info *info;
+	enum ice_status status;
+	u8 prof_id = 0;
+	u16 i;
+
+	memset(&buf, 0, sizeof(buf));
+
+	status = ice_flow_get_hw_prof(hw, ICE_BLK_ACL, prof->id, &prof_id);
+	if (status)
+		return status;
+
+	status = ice_flow_acl_is_prof_in_use(hw, prof, &buf);
+	if (status && status != ICE_ERR_IN_USE)
+		return status;
+
+	if (!status) {
+		/* Program the profile dependent configuration. This is done
+		 * only once regardless of the number of PFs using that profile
+		 */
+		memset(&buf, 0, sizeof(buf));
+
+		for (i = 0; i < prof->segs_cnt; i++) {
+			struct ice_flow_seg_info *seg = &prof->segs[i];
+			u16 j;
+
+			for_each_set_bit(j, (unsigned long *)&seg->match,
+					 ICE_FLOW_FIELD_IDX_MAX) {
+				info = &seg->fields[j];
+
+				if (info->type == ICE_FLOW_FLD_TYPE_RANGE)
+					buf.word_selection[info->entry.val] =
+						info->xtrct.idx;
+				else
+					ice_flow_acl_set_xtrct_seq_fld(&buf,
+								       info);
+			}
+
+			for (j = 0; j < seg->raws_cnt; j++) {
+				info = &seg->raws[j].info;
+				ice_flow_acl_set_xtrct_seq_fld(&buf, info);
+			}
+		}
+
+		memset(&buf.pf_scenario_num[0], ICE_ACL_INVALID_SCEN,
+		       ICE_AQC_ACL_PROF_PF_SCEN_NUM_ELEMS);
+	}
+
+	/* Update the current PF */
+	buf.pf_scenario_num[hw->pf_id] = (u8)prof->cfg.scen->id;
+	return ice_prgm_acl_prof_xtrct(hw, prof_id, &buf, NULL);
+}
+
 /**
  * ice_flow_assoc_prof - associate a VSI with a flow profile
  * @hw: pointer to the hardware structure
@@ -994,6 +1243,11 @@ ice_flow_assoc_prof(struct ice_hw *hw, enum ice_block blk,
 	enum ice_status status = 0;
 
 	if (!test_bit(vsi_handle, prof->vsis)) {
+		if (blk == ICE_BLK_ACL) {
+			status = ice_flow_acl_set_xtrct_seq(hw, prof);
+			if (status)
+				return status;
+		}
 		status = ice_add_prof_id_flow(hw, blk,
 					      ice_get_hw_vsi_num(hw,
 								 vsi_handle),
@@ -1112,6 +1366,341 @@ ice_flow_rem_prof(struct ice_hw *hw, enum ice_block blk, u64 prof_id)
 	return status;
 }
 
+/**
+ * ice_flow_acl_check_actions - Checks the ACL rule's actions
+ * @hw: pointer to the hardware structure
+ * @acts: array of actions to be performed on a match
+ * @acts_cnt: number of actions
+ * @cnt_alloc: indicates if an ACL counter has been allocated.
+ */
+static enum ice_status
+ice_flow_acl_check_actions(struct ice_hw *hw, struct ice_flow_action *acts,
+			   u8 acts_cnt, bool *cnt_alloc)
+{
+	DECLARE_BITMAP(dup_check, ICE_AQC_TBL_MAX_ACTION_PAIRS * 2);
+	int i;
+
+	bitmap_zero(dup_check, ICE_AQC_TBL_MAX_ACTION_PAIRS * 2);
+	*cnt_alloc = false;
+
+	if (acts_cnt > ICE_FLOW_ACL_MAX_NUM_ACT)
+		return ICE_ERR_OUT_OF_RANGE;
+
+	for (i = 0; i < acts_cnt; i++) {
+		if (acts[i].type != ICE_FLOW_ACT_NOP &&
+		    acts[i].type != ICE_FLOW_ACT_DROP &&
+		    acts[i].type != ICE_FLOW_ACT_CNTR_PKT &&
+		    acts[i].type != ICE_FLOW_ACT_FWD_QUEUE)
+			return ICE_ERR_CFG;
+
+		/* If the caller want to add two actions of the same type, then
+		 * it is considered invalid configuration.
+		 */
+		if (test_and_set_bit(acts[i].type, dup_check))
+			return ICE_ERR_PARAM;
+	}
+
+	/* Checks if ACL counters are needed. */
+	for (i = 0; i < acts_cnt; i++) {
+		if (acts[i].type == ICE_FLOW_ACT_CNTR_PKT ||
+		    acts[i].type == ICE_FLOW_ACT_CNTR_BYTES ||
+		    acts[i].type == ICE_FLOW_ACT_CNTR_PKT_BYTES) {
+			struct ice_acl_cntrs cntrs;
+			enum ice_status status;
+
+			cntrs.amount = 1;
+			cntrs.bank = 0; /* Only bank0 for the moment */
+
+			if (acts[i].type == ICE_FLOW_ACT_CNTR_PKT_BYTES)
+				cntrs.type = ICE_AQC_ACL_CNT_TYPE_DUAL;
+			else
+				cntrs.type = ICE_AQC_ACL_CNT_TYPE_SINGLE;
+
+			status = ice_aq_alloc_acl_cntrs(hw, &cntrs, NULL);
+			if (status)
+				return status;
+			/* Counter index within the bank */
+			acts[i].data.acl_act.value =
+						cpu_to_le16(cntrs.first_cntr);
+			*cnt_alloc = true;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * ice_flow_acl_frmt_entry_range - Format an ACL range checker for a given field
+ * @fld: number of the given field
+ * @info: info about field
+ * @range_buf: range checker configuration buffer
+ * @data: pointer to a data buffer containing flow entry's match values/masks
+ * @range: Input/output param indicating which range checkers are being used
+ */
+static void
+ice_flow_acl_frmt_entry_range(u16 fld, struct ice_flow_fld_info *info,
+			      struct ice_aqc_acl_profile_ranges *range_buf,
+			      u8 *data, u8 *range)
+{
+	u16 new_mask;
+
+	/* If not specified, default mask is all bits in field */
+	new_mask = (info->src.mask == ICE_FLOW_FLD_OFF_INVAL ?
+		    BIT(ice_flds_info[fld].size) - 1 :
+		    (*(u16 *)(data + info->src.mask))) << info->xtrct.disp;
+
+	/* If the mask is 0, then we don't need to worry about this input
+	 * range checker value.
+	 */
+	if (new_mask) {
+		u16 new_high =
+			(*(u16 *)(data + info->src.last)) << info->xtrct.disp;
+		u16 new_low =
+			(*(u16 *)(data + info->src.val)) << info->xtrct.disp;
+		u8 range_idx = info->entry.val;
+
+		range_buf->checker_cfg[range_idx].low_boundary =
+			cpu_to_be16(new_low);
+		range_buf->checker_cfg[range_idx].high_boundary =
+			cpu_to_be16(new_high);
+		range_buf->checker_cfg[range_idx].mask = cpu_to_be16(new_mask);
+
+		/* Indicate which range checker is being used */
+		*range |= BIT(range_idx);
+	}
+}
+
+/**
+ * ice_flow_acl_frmt_entry_fld - Partially format ACL entry for a given field
+ * @fld: number of the given field
+ * @info: info about the field
+ * @buf: buffer containing the entry
+ * @dontcare: buffer containing don't care mask for entry
+ * @data: pointer to a data buffer containing flow entry's match values/masks
+ */
+static void
+ice_flow_acl_frmt_entry_fld(u16 fld, struct ice_flow_fld_info *info, u8 *buf,
+			    u8 *dontcare, u8 *data)
+{
+	u16 dst, src, mask, k, end_disp, tmp_s = 0, tmp_m = 0;
+	bool use_mask = false;
+	u8 disp;
+
+	src = info->src.val;
+	mask = info->src.mask;
+	dst = info->entry.val - ICE_AQC_ACL_PROF_BYTE_SEL_START_IDX;
+	disp = info->xtrct.disp % BITS_PER_BYTE;
+
+	if (mask != ICE_FLOW_FLD_OFF_INVAL)
+		use_mask = true;
+
+	for (k = 0; k < info->entry.last; k++, dst++) {
+		/* Add overflow bits from previous byte */
+		buf[dst] = (tmp_s & 0xff00) >> 8;
+
+		/* If mask is not valid, tmp_m is always zero, so just setting
+		 * dontcare to 0 (no masked bits). If mask is valid, pulls in
+		 * overflow bits of mask from prev byte
+		 */
+		dontcare[dst] = (tmp_m & 0xff00) >> 8;
+
+		/* If there is displacement, last byte will only contain
+		 * displaced data, but there is no more data to read from user
+		 * buffer, so skip so as not to potentially read beyond end of
+		 * user buffer
+		 */
+		if (!disp || k < info->entry.last - 1) {
+			/* Store shifted data to use in next byte */
+			tmp_s = data[src++] << disp;
+
+			/* Add current (shifted) byte */
+			buf[dst] |= tmp_s & 0xff;
+
+			/* Handle mask if valid */
+			if (use_mask) {
+				tmp_m = (~data[mask++] & 0xff) << disp;
+				dontcare[dst] |= tmp_m & 0xff;
+			}
+		}
+	}
+
+	/* Fill in don't care bits at beginning of field */
+	if (disp) {
+		dst = info->entry.val - ICE_AQC_ACL_PROF_BYTE_SEL_START_IDX;
+		for (k = 0; k < disp; k++)
+			dontcare[dst] |= BIT(k);
+	}
+
+	end_disp = (disp + ice_flds_info[fld].size) % BITS_PER_BYTE;
+
+	/* Fill in don't care bits at end of field */
+	if (end_disp) {
+		dst = info->entry.val - ICE_AQC_ACL_PROF_BYTE_SEL_START_IDX +
+		      info->entry.last - 1;
+		for (k = end_disp; k < BITS_PER_BYTE; k++)
+			dontcare[dst] |= BIT(k);
+	}
+}
+
+/**
+ * ice_flow_acl_frmt_entry - Format ACL entry
+ * @hw: pointer to the hardware structure
+ * @prof: pointer to flow profile
+ * @e: pointer to the flow entry
+ * @data: pointer to a data buffer containing flow entry's match values/masks
+ * @acts: array of actions to be performed on a match
+ * @acts_cnt: number of actions
+ *
+ * Formats the key (and key_inverse) to be matched from the data passed in,
+ * along with data from the flow profile. This key/key_inverse pair makes up
+ * the 'entry' for an ACL flow entry.
+ */
+static enum ice_status
+ice_flow_acl_frmt_entry(struct ice_hw *hw, struct ice_flow_prof *prof,
+			struct ice_flow_entry *e, u8 *data,
+			struct ice_flow_action *acts, u8 acts_cnt)
+{
+	u8 *buf = NULL, *dontcare = NULL, *key = NULL, range = 0, dir_flag_msk;
+	struct ice_aqc_acl_profile_ranges *range_buf = NULL;
+	enum ice_status status;
+	bool cnt_alloc;
+	u8 prof_id = 0;
+	u16 i, buf_sz;
+
+	status = ice_flow_get_hw_prof(hw, ICE_BLK_ACL, prof->id, &prof_id);
+	if (status)
+		return status;
+
+	/* Format the result action */
+
+	status = ice_flow_acl_check_actions(hw, acts, acts_cnt, &cnt_alloc);
+	if (status)
+		return status;
+
+	status = ICE_ERR_NO_MEMORY;
+
+	e->acts = devm_kmemdup(ice_hw_to_dev(hw), acts,
+			       acts_cnt * sizeof(*acts), GFP_KERNEL);
+	if (!e->acts)
+		goto out;
+
+	e->acts_cnt = acts_cnt;
+
+	/* Format the matching data */
+	buf_sz = prof->cfg.scen->width;
+	buf = kzalloc(buf_sz, GFP_KERNEL);
+	if (!buf)
+		goto out;
+
+	dontcare = kzalloc(buf_sz, GFP_KERNEL);
+	if (!dontcare)
+		goto out;
+
+	/* 'key' buffer will store both key and key_inverse, so must be twice
+	 * size of buf
+	 */
+	key = devm_kzalloc(ice_hw_to_dev(hw), buf_sz * 2, GFP_KERNEL);
+	if (!key)
+		goto out;
+
+	range_buf = devm_kzalloc(ice_hw_to_dev(hw),
+				 sizeof(struct ice_aqc_acl_profile_ranges),
+				 GFP_KERNEL);
+	if (!range_buf)
+		goto out;
+
+	/* Set don't care mask to all 1's to start, will zero out used bytes */
+	memset(dontcare, 0xff, buf_sz);
+
+	for (i = 0; i < prof->segs_cnt; i++) {
+		struct ice_flow_seg_info *seg = &prof->segs[i];
+		u8 j;
+
+		for_each_set_bit(j, (unsigned long *)&seg->match,
+				 ICE_FLOW_FIELD_IDX_MAX) {
+			struct ice_flow_fld_info *info = &seg->fields[j];
+
+			if (info->type == ICE_FLOW_FLD_TYPE_RANGE)
+				ice_flow_acl_frmt_entry_range(j, info,
+							      range_buf, data,
+							      &range);
+			else
+				ice_flow_acl_frmt_entry_fld(j, info, buf,
+							    dontcare, data);
+		}
+
+		for (j = 0; j < seg->raws_cnt; j++) {
+			struct ice_flow_fld_info *info = &seg->raws[j].info;
+			u16 dst, src, mask, k;
+			bool use_mask = false;
+
+			src = info->src.val;
+			dst = info->entry.val -
+					ICE_AQC_ACL_PROF_BYTE_SEL_START_IDX;
+			mask = info->src.mask;
+
+			if (mask != ICE_FLOW_FLD_OFF_INVAL)
+				use_mask = true;
+
+			for (k = 0; k < info->entry.last; k++, dst++) {
+				buf[dst] = data[src++];
+				if (use_mask)
+					dontcare[dst] = ~data[mask++];
+				else
+					dontcare[dst] = 0;
+			}
+		}
+	}
+
+	buf[prof->cfg.scen->pid_idx] = (u8)prof_id;
+	dontcare[prof->cfg.scen->pid_idx] = 0;
+
+	/* Format the buffer for direction flags */
+	dir_flag_msk = BIT(ICE_FLG_PKT_DIR);
+
+	if (prof->dir == ICE_FLOW_RX)
+		buf[prof->cfg.scen->pkt_dir_idx] = dir_flag_msk;
+
+	if (range) {
+		buf[prof->cfg.scen->rng_chk_idx] = range;
+		/* Mark any unused range checkers as don't care */
+		dontcare[prof->cfg.scen->rng_chk_idx] = ~range;
+		e->range_buf = range_buf;
+	} else {
+		devm_kfree(ice_hw_to_dev(hw), range_buf);
+	}
+
+	status = ice_set_key(key, buf_sz * 2, buf, NULL, dontcare, NULL, 0,
+			     buf_sz);
+	if (status)
+		goto out;
+
+	e->entry = key;
+	e->entry_sz = buf_sz * 2;
+
+out:
+	kfree(buf);
+	kfree(dontcare);
+
+	if (status && key)
+		devm_kfree(ice_hw_to_dev(hw), key);
+
+	if (status && range_buf) {
+		devm_kfree(ice_hw_to_dev(hw), range_buf);
+		e->range_buf = NULL;
+	}
+
+	if (status && e->acts) {
+		devm_kfree(ice_hw_to_dev(hw), e->acts);
+		e->acts = NULL;
+		e->acts_cnt = 0;
+	}
+
+	if (status && cnt_alloc)
+		ice_flow_acl_free_act_cntr(hw, acts, acts_cnt);
+
+	return status;
+}
 /**
  * ice_flow_add_entry - Add a flow entry
  * @hw: pointer to the HW struct
@@ -1121,17 +1710,24 @@ ice_flow_rem_prof(struct ice_hw *hw, enum ice_block blk, u64 prof_id)
  * @vsi_handle: software VSI handle for the flow entry
  * @prio: priority of the flow entry
  * @data: pointer to a data buffer containing flow entry's match values/masks
+ * @acts: arrays of actions to be performed on a match
+ * @acts_cnt: number of actions
  * @entry_h: pointer to buffer that receives the new flow entry's handle
  */
 enum ice_status
 ice_flow_add_entry(struct ice_hw *hw, enum ice_block blk, u64 prof_id,
 		   u64 entry_id, u16 vsi_handle, enum ice_flow_priority prio,
-		   void *data, u64 *entry_h)
+		   void *data, struct ice_flow_action *acts, u8 acts_cnt,
+		   u64 *entry_h)
 {
 	struct ice_flow_entry *e = NULL;
 	struct ice_flow_prof *prof;
 	enum ice_status status;
 
+	/* ACL entries must indicate an action */
+	if (blk == ICE_BLK_ACL && (!acts || !acts_cnt))
+		return ICE_ERR_PARAM;
+
 	/* No flow entry data is expected for RSS */
 	if (!entry_h || (!data && blk != ICE_BLK_RSS))
 		return ICE_ERR_BAD_PTR;
@@ -1168,14 +1764,24 @@ ice_flow_add_entry(struct ice_hw *hw, enum ice_block blk, u64 prof_id,
 	case ICE_BLK_FD:
 	case ICE_BLK_RSS:
 		break;
+	case ICE_BLK_ACL:
+		/* ACL will handle the entry management */
+		status = ice_flow_acl_frmt_entry(hw, prof, e, (u8 *)data, acts,
+						 acts_cnt);
+		if (status)
+			goto out;
+		break;
 	default:
 		status = ICE_ERR_NOT_IMPL;
 		goto out;
 	}
 
-	mutex_lock(&prof->entries_lock);
-	list_add(&e->l_entry, &prof->entries);
-	mutex_unlock(&prof->entries_lock);
+	if (blk != ICE_BLK_ACL) {
+		/* ACL will handle the entry management */
+		mutex_lock(&prof->entries_lock);
+		list_add(&e->l_entry, &prof->entries);
+		mutex_unlock(&prof->entries_lock);
+	}
 
 	*entry_h = ICE_FLOW_ENTRY_HNDL(e);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.h b/drivers/net/ethernet/intel/ice/ice_flow.h
index f0cea38e8e78..ba3ceaf30b93 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.h
+++ b/drivers/net/ethernet/intel/ice/ice_flow.h
@@ -189,11 +189,17 @@ struct ice_flow_entry {
 
 	u64 id;
 	struct ice_flow_prof *prof;
+	/* Action list */
+	struct ice_flow_action *acts;
 	/* Flow entry's content */
 	void *entry;
+	/* Range buffer (For ACL only) */
+	struct ice_aqc_acl_profile_ranges *range_buf;
 	enum ice_flow_priority priority;
 	u16 vsi_handle;
 	u16 entry_sz;
+#define ICE_FLOW_ACL_MAX_NUM_ACT	2
+	u8 acts_cnt;
 };
 
 #define ICE_FLOW_ENTRY_HNDL(e)	((u64)(uintptr_t)e)
@@ -257,7 +263,8 @@ ice_flow_rem_prof(struct ice_hw *hw, enum ice_block blk, u64 prof_id);
 enum ice_status
 ice_flow_add_entry(struct ice_hw *hw, enum ice_block blk, u64 prof_id,
 		   u64 entry_id, u16 vsi, enum ice_flow_priority prio,
-		   void *data, u64 *entry_h);
+		   void *data, struct ice_flow_action *acts, u8 acts_cnt,
+		   u64 *entry_h);
 enum ice_status
 ice_flow_rem_entry(struct ice_hw *hw, enum ice_block blk, u64 entry_h);
 void
diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
index 4ec24c3e813f..d2360a514e3e 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -309,6 +309,8 @@ enum ice_flex_mdid_pkt_flags {
 enum ice_flex_rx_mdid {
 	ICE_RX_MDID_FLOW_ID_LOWER	= 5,
 	ICE_RX_MDID_FLOW_ID_HIGH,
+	ICE_MDID_RX_PKT_DROP	= 8,
+	ICE_MDID_RX_DST_Q		= 12,
 	ICE_RX_MDID_SRC_VSI		= 19,
 	ICE_RX_MDID_HASH_LOW		= 56,
 	ICE_RX_MDID_HASH_HIGH,
@@ -317,6 +319,7 @@ enum ice_flex_rx_mdid {
 /* Rx/Tx Flag64 packet flag bits */
 enum ice_flg64_bits {
 	ICE_FLG_PKT_DSI		= 0,
+	ICE_FLG_PKT_DIR		= 4,
 	ICE_FLG_EVLAN_x8100	= 14,
 	ICE_FLG_EVLAN_x9100,
 	ICE_FLG_VLAN_x8100,
-- 
2.26.2

