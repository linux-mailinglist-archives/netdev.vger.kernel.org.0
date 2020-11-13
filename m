Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03032B2707
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 22:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgKMVfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 16:35:02 -0500
Received: from mga06.intel.com ([134.134.136.31]:18351 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbgKMVet (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 16:34:49 -0500
IronPort-SDR: u8cDPYFS3wRLGxKN5peP3VZwro7752Rb3LhsMfUHh5Gxjs/K12J/iunXDiadxCAk6VpbEZ1F2O
 H2Ag+OeJlyjg==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="232152352"
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="232152352"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 13:34:38 -0800
IronPort-SDR: g7uGuKaKWsqKpQAk616Y+FS9sB4Umv8mVYxjfN1C9aqwWZYTMx5jjj9sJ5BZBgH0+xuRmh3NLh
 wtNOsNAF7A7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="366861601"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Nov 2020 13:34:38 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.neti, kuba@kernel.org
Cc:     Real Valiquette <real.valiquette@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Chinh Cao <chinh.t.cao@intel.com>,
        Brijesh Behera <brijeshx.behera@intel.com>
Subject: [net-next v2 05/15] ice: create flow profile
Date:   Fri, 13 Nov 2020 13:33:57 -0800
Message-Id: <20201113213407.2131340-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201113213407.2131340-1-anthony.l.nguyen@intel.com>
References: <20201113213407.2131340-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Real Valiquette <real.valiquette@intel.com>

Implement the initial steps for creating an ACL filter to support ntuple
masks. Create a flow profile based on a given mask rule and program it to
the hardware. Though the profile is written to hardware, no actions are
associated with the profile yet.

Co-developed-by: Chinh Cao <chinh.t.cao@intel.com>
Signed-off-by: Chinh Cao <chinh.t.cao@intel.com>
Signed-off-by: Real Valiquette <real.valiquette@intel.com>
Co-developed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Brijesh Behera <brijeshx.behera@intel.com>
---
 drivers/net/ethernet/intel/ice/Makefile       |   1 +
 drivers/net/ethernet/intel/ice/ice.h          |   9 +
 drivers/net/ethernet/intel/ice/ice_acl_main.c | 260 ++++++++++++++++
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  39 +++
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c | 290 ++++++++++++++----
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |  12 +-
 drivers/net/ethernet/intel/ice/ice_flow.c     | 178 ++++++++++-
 drivers/net/ethernet/intel/ice/ice_flow.h     |  17 +
 8 files changed, 727 insertions(+), 79 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_acl_main.c

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 0747976622cf..36a787b5ad8d 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -20,6 +20,7 @@ ice-y := ice_main.o	\
 	 ice_fltr.o	\
 	 ice_fdir.o	\
 	 ice_ethtool_fdir.o \
+	 ice_acl_main.o	\
 	 ice_acl.o	\
 	 ice_acl_ctrl.o	\
 	 ice_flex_pipe.o \
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 1008a6785e55..d813a5c765d0 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -601,16 +601,25 @@ int ice_del_ntuple_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd);
 int ice_get_ethtool_fdir_entry(struct ice_hw *hw, struct ethtool_rxnfc *cmd);
 u32 ice_ntuple_get_max_fltr_cnt(struct ice_hw *hw);
 int
+ice_ntuple_l4_proto_to_port(enum ice_flow_seg_hdr l4_proto,
+			    enum ice_flow_field *src_port,
+			    enum ice_flow_field *dst_port);
+int ice_ntuple_check_ip4_seg(struct ethtool_tcpip4_spec *tcp_ip4_spec);
+int ice_ntuple_check_ip4_usr_seg(struct ethtool_usrip4_spec *usr_ip4_spec);
+int
 ice_get_fdir_fltr_ids(struct ice_hw *hw, struct ethtool_rxnfc *cmd,
 		      u32 *rule_locs);
 void ice_fdir_release_flows(struct ice_hw *hw);
 void ice_fdir_replay_flows(struct ice_hw *hw);
 void ice_fdir_replay_fltrs(struct ice_pf *pf);
 int ice_fdir_create_dflt_rules(struct ice_pf *pf);
+enum ice_fltr_ptype ice_ethtool_flow_to_fltr(int eth);
 int ice_aq_wait_for_event(struct ice_pf *pf, u16 opcode, unsigned long timeout,
 			  struct ice_rq_event_info *event);
 int ice_open(struct net_device *netdev);
 int ice_stop(struct net_device *netdev);
 void ice_service_task_schedule(struct ice_pf *pf);
+int
+ice_acl_add_rule_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd);
 
 #endif /* _ICE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_acl_main.c b/drivers/net/ethernet/intel/ice/ice_acl_main.c
new file mode 100644
index 000000000000..be97dfb94652
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_acl_main.c
@@ -0,0 +1,260 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2018-2020, Intel Corporation. */
+
+/* ACL support for ice */
+
+#include "ice.h"
+#include "ice_lib.h"
+
+/* Number of action */
+#define ICE_ACL_NUM_ACT		1
+
+/**
+ * ice_acl_set_ip4_addr_seg
+ * @seg: flow segment for programming
+ *
+ * Set the IPv4 source and destination address mask for the given flow segment
+ */
+static void ice_acl_set_ip4_addr_seg(struct ice_flow_seg_info *seg)
+{
+	u16 val_loc, mask_loc;
+
+	/* IP source address */
+	val_loc = offsetof(struct ice_fdir_fltr, ip.v4.src_ip);
+	mask_loc = offsetof(struct ice_fdir_fltr, mask.v4.src_ip);
+
+	ice_flow_set_fld(seg, ICE_FLOW_FIELD_IDX_IPV4_SA, val_loc,
+			 mask_loc, ICE_FLOW_FLD_OFF_INVAL, false);
+
+	/* IP destination address */
+	val_loc = offsetof(struct ice_fdir_fltr, ip.v4.dst_ip);
+	mask_loc = offsetof(struct ice_fdir_fltr, mask.v4.dst_ip);
+
+	ice_flow_set_fld(seg, ICE_FLOW_FIELD_IDX_IPV4_DA, val_loc,
+			 mask_loc, ICE_FLOW_FLD_OFF_INVAL, false);
+}
+
+/**
+ * ice_acl_set_ip4_port_seg
+ * @seg: flow segment for programming
+ * @l4_proto: Layer 4 protocol to program
+ *
+ * Set the source and destination port for the given flow segment based on the
+ * provided layer 4 protocol
+ */
+static int
+ice_acl_set_ip4_port_seg(struct ice_flow_seg_info *seg,
+			 enum ice_flow_seg_hdr l4_proto)
+{
+	enum ice_flow_field src_port, dst_port;
+	u16 val_loc, mask_loc;
+	int err;
+
+	err = ice_ntuple_l4_proto_to_port(l4_proto, &src_port, &dst_port);
+	if (err)
+		return err;
+
+	/* Layer 4 source port */
+	val_loc = offsetof(struct ice_fdir_fltr, ip.v4.src_port);
+	mask_loc = offsetof(struct ice_fdir_fltr, mask.v4.src_port);
+
+	ice_flow_set_fld(seg, src_port, val_loc, mask_loc,
+			 ICE_FLOW_FLD_OFF_INVAL, false);
+
+	/* Layer 4 destination port */
+	val_loc = offsetof(struct ice_fdir_fltr, ip.v4.dst_port);
+	mask_loc = offsetof(struct ice_fdir_fltr, mask.v4.dst_port);
+
+	ice_flow_set_fld(seg, dst_port, val_loc, mask_loc,
+			 ICE_FLOW_FLD_OFF_INVAL, false);
+
+	return 0;
+}
+
+/**
+ * ice_acl_set_ip4_seg
+ * @seg: flow segment for programming
+ * @tcp_ip4_spec: mask data from ethtool
+ * @l4_proto: Layer 4 protocol to program
+ *
+ * Set the mask data into the flow segment to be used to program HW
+ * table based on provided L4 protocol for IPv4
+ */
+static int
+ice_acl_set_ip4_seg(struct ice_flow_seg_info *seg,
+		    struct ethtool_tcpip4_spec *tcp_ip4_spec,
+		    enum ice_flow_seg_hdr l4_proto)
+{
+	int err;
+
+	if (!seg)
+		return -EINVAL;
+
+	err = ice_ntuple_check_ip4_seg(tcp_ip4_spec);
+	if (err)
+		return err;
+
+	ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_IPV4 | l4_proto);
+	ice_acl_set_ip4_addr_seg(seg);
+
+	return ice_acl_set_ip4_port_seg(seg, l4_proto);
+}
+
+/**
+ * ice_acl_set_ip4_usr_seg
+ * @seg: flow segment for programming
+ * @usr_ip4_spec: ethtool userdef packet offset
+ *
+ * Set the offset data into the flow segment to be used to program HW
+ * table for IPv4
+ */
+static int
+ice_acl_set_ip4_usr_seg(struct ice_flow_seg_info *seg,
+			struct ethtool_usrip4_spec *usr_ip4_spec)
+{
+	int err;
+
+	if (!seg)
+		return -EINVAL;
+
+	err = ice_ntuple_check_ip4_usr_seg(usr_ip4_spec);
+	if (err)
+		return err;
+
+	ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_IPV4);
+	ice_acl_set_ip4_addr_seg(seg);
+
+	return 0;
+}
+
+/**
+ * ice_acl_check_input_set - Checks that a given ACL input set is valid
+ * @pf: ice PF structure
+ * @fsp: pointer to ethtool Rx flow specification
+ *
+ * Returns 0 on success and negative values for failure
+ */
+static int
+ice_acl_check_input_set(struct ice_pf *pf, struct ethtool_rx_flow_spec *fsp)
+{
+	struct ice_fd_hw_prof *hw_prof = NULL;
+	struct ice_flow_prof *prof = NULL;
+	struct ice_flow_seg_info *old_seg;
+	struct ice_flow_seg_info *seg;
+	enum ice_fltr_ptype fltr_type;
+	struct ice_hw *hw = &pf->hw;
+	enum ice_status status;
+	struct device *dev;
+	int err;
+
+	if (!fsp)
+		return -EINVAL;
+
+	dev = ice_pf_to_dev(pf);
+	seg = devm_kzalloc(dev, sizeof(*seg), GFP_KERNEL);
+	if (!seg)
+		return -ENOMEM;
+
+	switch (fsp->flow_type & ~FLOW_EXT) {
+	case TCP_V4_FLOW:
+		err = ice_acl_set_ip4_seg(seg, &fsp->m_u.tcp_ip4_spec,
+					  ICE_FLOW_SEG_HDR_TCP);
+		break;
+	case UDP_V4_FLOW:
+		err = ice_acl_set_ip4_seg(seg, &fsp->m_u.tcp_ip4_spec,
+					  ICE_FLOW_SEG_HDR_UDP);
+		break;
+	case SCTP_V4_FLOW:
+		err = ice_acl_set_ip4_seg(seg, &fsp->m_u.tcp_ip4_spec,
+					  ICE_FLOW_SEG_HDR_SCTP);
+		break;
+	case IPV4_USER_FLOW:
+		err = ice_acl_set_ip4_usr_seg(seg, &fsp->m_u.usr_ip4_spec);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+	}
+	if (err)
+		goto err_exit;
+
+	fltr_type = ice_ethtool_flow_to_fltr(fsp->flow_type & ~FLOW_EXT);
+
+	if (!hw->acl_prof) {
+		hw->acl_prof = devm_kcalloc(dev, ICE_FLTR_PTYPE_MAX,
+					    sizeof(*hw->acl_prof), GFP_KERNEL);
+		if (!hw->acl_prof) {
+			err = -ENOMEM;
+			goto err_exit;
+		}
+	}
+	if (!hw->acl_prof[fltr_type]) {
+		hw->acl_prof[fltr_type] = devm_kzalloc(dev,
+						       sizeof(**hw->acl_prof),
+						       GFP_KERNEL);
+		if (!hw->acl_prof[fltr_type]) {
+			err = -ENOMEM;
+			goto err_acl_prof_exit;
+		}
+		hw->acl_prof[fltr_type]->cnt = 0;
+	}
+
+	hw_prof = hw->acl_prof[fltr_type];
+	old_seg = hw_prof->fdir_seg[0];
+	if (old_seg) {
+		/* This flow_type already has an input set.
+		 * If it matches the requested input set then we are
+		 * done. If it's different then it's an error.
+		 */
+		if (!memcmp(old_seg, seg, sizeof(*seg))) {
+			devm_kfree(dev, seg);
+			return 0;
+		}
+
+		err = -EINVAL;
+		goto err_acl_prof_flow_exit;
+	}
+
+	/* Adding a profile for the given flow specification with no
+	 * actions (NULL) and zero actions 0.
+	 */
+	status = ice_flow_add_prof(hw, ICE_BLK_ACL, ICE_FLOW_RX, fltr_type,
+				   seg, 1, &prof);
+	if (status) {
+		err = ice_status_to_errno(status);
+		goto err_exit;
+	}
+
+	hw_prof->fdir_seg[0] = seg;
+	return 0;
+
+err_acl_prof_flow_exit:
+	devm_kfree(dev, hw->acl_prof[fltr_type]);
+err_acl_prof_exit:
+	devm_kfree(dev, hw->acl_prof);
+err_exit:
+	devm_kfree(dev, seg);
+
+	return err;
+}
+
+/**
+ * ice_acl_add_rule_ethtool - Adds an ACL rule
+ * @vsi: pointer to target VSI
+ * @cmd: command to add or delete ACL rule
+ *
+ * Returns 0 on success and negative values for failure
+ */
+int ice_acl_add_rule_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd)
+{
+	struct ethtool_rx_flow_spec *fsp;
+	struct ice_pf *pf;
+
+	if (!vsi || !cmd)
+		return -EINVAL;
+
+	pf = vsi->back;
+
+	fsp = (struct ethtool_rx_flow_spec *)&cmd->fs;
+
+	return ice_acl_check_input_set(pf, fsp);
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 062a90248f8f..f5fdab2b7058 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -234,6 +234,8 @@ struct ice_aqc_get_sw_cfg_resp_elem {
 #define ICE_AQC_RES_TYPE_FDIR_COUNTER_BLOCK		0x21
 #define ICE_AQC_RES_TYPE_FDIR_GUARANTEED_ENTRIES	0x22
 #define ICE_AQC_RES_TYPE_FDIR_SHARED_ENTRIES		0x23
+#define ICE_AQC_RES_TYPE_ACL_PROF_BLDR_PROFID		0x50
+#define ICE_AQC_RES_TYPE_ACL_PROF_BLDR_TCAM		0x51
 #define ICE_AQC_RES_TYPE_FD_PROF_BLDR_PROFID		0x58
 #define ICE_AQC_RES_TYPE_FD_PROF_BLDR_TCAM		0x59
 #define ICE_AQC_RES_TYPE_HASH_PROF_BLDR_PROFID		0x60
@@ -1814,6 +1816,43 @@ struct ice_aqc_actpair {
 	struct ice_acl_act_entry act[ICE_ACL_NUM_ACT_PER_ACT_PAIR];
 };
 
+/* The first byte of the byte selection base is reserved to keep the
+ * first byte of the field vector where the packet direction info is
+ * available. Thus we should start at index 1 of the field vector to
+ * map its entries to the byte selection base.
+ */
+#define ICE_AQC_ACL_PROF_BYTE_SEL_START_IDX	1
+#define ICE_AQC_ACL_PROF_BYTE_SEL_ELEMS		30
+
+/* Input buffer format for program profile extraction admin command and
+ * response buffer format for query profile admin command is as defined
+ * in struct ice_aqc_acl_prof_generic_frmt
+ */
+
+/* Input buffer format for program profile ranges and query profile ranges
+ * admin commands. Same format is used for response buffer in case of query
+ * profile ranges command
+ */
+struct ice_acl_rng_data {
+	/* The range checker output shall be sent when the value
+	 * related to this range checker is lower than low boundary
+	 */
+	__be16 low_boundary;
+	/* The range checker output shall be sent when the value
+	 * related to this range checker is higher than high boundary
+	 */
+	__be16 high_boundary;
+	/* A value of '0' in bit shall clear the relevant bit input
+	 * to the range checker
+	 */
+	__be16 mask;
+};
+
+struct ice_aqc_acl_profile_ranges {
+#define ICE_AQC_ACL_PROF_RANGES_NUM_CFG 8
+	struct ice_acl_rng_data checker_cfg[ICE_AQC_ACL_PROF_RANGES_NUM_CFG];
+};
+
 /* Program ACL entry (indirect 0x0C20) */
 struct ice_aqc_acl_entry {
 	u8 tcam_index; /* Updated TCAM block index */
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
index 6869357624ab..ef641bc8ca0e 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
@@ -68,7 +68,7 @@ static int ice_fltr_to_ethtool_flow(enum ice_fltr_ptype flow)
  *
  * Returns flow enum
  */
-static enum ice_fltr_ptype ice_ethtool_flow_to_fltr(int eth)
+enum ice_fltr_ptype ice_ethtool_flow_to_fltr(int eth)
 {
 	switch (eth) {
 	case TCP_V4_FLOW:
@@ -773,6 +773,56 @@ ice_create_init_fdir_rule(struct ice_pf *pf, enum ice_fltr_ptype flow)
 	return -EOPNOTSUPP;
 }
 
+/**
+ * ice_ntuple_check_ip4_seg - Check valid fields are provided for filter
+ * @tcp_ip4_spec: mask data from ethtool
+ */
+int ice_ntuple_check_ip4_seg(struct ethtool_tcpip4_spec *tcp_ip4_spec)
+{
+	if (!tcp_ip4_spec)
+		return -EINVAL;
+
+	/* make sure we don't have any empty rule */
+	if (!tcp_ip4_spec->psrc && !tcp_ip4_spec->ip4src &&
+	    !tcp_ip4_spec->pdst && !tcp_ip4_spec->ip4dst)
+		return -EINVAL;
+
+	/* filtering on TOS not supported */
+	if (tcp_ip4_spec->tos)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+/**
+ * ice_ntuple_l4_proto_to_port
+ * @l4_proto: Layer 4 protocol to program
+ * @src_port: source flow field value for provided l4 protocol
+ * @dst_port: destination flow field value for provided l4 protocol
+ *
+ * Set associated src and dst port for given l4 protocol
+ */
+int
+ice_ntuple_l4_proto_to_port(enum ice_flow_seg_hdr l4_proto,
+			    enum ice_flow_field *src_port,
+			    enum ice_flow_field *dst_port)
+{
+	if (l4_proto == ICE_FLOW_SEG_HDR_TCP) {
+		*src_port = ICE_FLOW_FIELD_IDX_TCP_SRC_PORT;
+		*dst_port = ICE_FLOW_FIELD_IDX_TCP_DST_PORT;
+	} else if (l4_proto == ICE_FLOW_SEG_HDR_UDP) {
+		*src_port = ICE_FLOW_FIELD_IDX_UDP_SRC_PORT;
+		*dst_port = ICE_FLOW_FIELD_IDX_UDP_DST_PORT;
+	} else if (l4_proto == ICE_FLOW_SEG_HDR_SCTP) {
+		*src_port = ICE_FLOW_FIELD_IDX_SCTP_SRC_PORT;
+		*dst_port = ICE_FLOW_FIELD_IDX_SCTP_DST_PORT;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 /**
  * ice_set_fdir_ip4_seg
  * @seg: flow segment for programming
@@ -790,28 +840,18 @@ ice_set_fdir_ip4_seg(struct ice_flow_seg_info *seg,
 		     enum ice_flow_seg_hdr l4_proto, bool *perfect_fltr)
 {
 	enum ice_flow_field src_port, dst_port;
+	int ret;
 
-	/* make sure we don't have any empty rule */
-	if (!tcp_ip4_spec->psrc && !tcp_ip4_spec->ip4src &&
-	    !tcp_ip4_spec->pdst && !tcp_ip4_spec->ip4dst)
+	if (!seg || !perfect_fltr)
 		return -EINVAL;
 
-	/* filtering on TOS not supported */
-	if (tcp_ip4_spec->tos)
-		return -EOPNOTSUPP;
+	ret = ice_ntuple_check_ip4_seg(tcp_ip4_spec);
+	if (ret)
+		return ret;
 
-	if (l4_proto == ICE_FLOW_SEG_HDR_TCP) {
-		src_port = ICE_FLOW_FIELD_IDX_TCP_SRC_PORT;
-		dst_port = ICE_FLOW_FIELD_IDX_TCP_DST_PORT;
-	} else if (l4_proto == ICE_FLOW_SEG_HDR_UDP) {
-		src_port = ICE_FLOW_FIELD_IDX_UDP_SRC_PORT;
-		dst_port = ICE_FLOW_FIELD_IDX_UDP_DST_PORT;
-	} else if (l4_proto == ICE_FLOW_SEG_HDR_SCTP) {
-		src_port = ICE_FLOW_FIELD_IDX_SCTP_SRC_PORT;
-		dst_port = ICE_FLOW_FIELD_IDX_SCTP_DST_PORT;
-	} else {
-		return -EOPNOTSUPP;
-	}
+	ret = ice_ntuple_l4_proto_to_port(l4_proto, &src_port, &dst_port);
+	if (ret)
+		return ret;
 
 	*perfect_fltr = true;
 	ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_IPV4 | l4_proto);
@@ -860,20 +900,14 @@ ice_set_fdir_ip4_seg(struct ice_flow_seg_info *seg,
 }
 
 /**
- * ice_set_fdir_ip4_usr_seg
- * @seg: flow segment for programming
+ * ice_ntuple_check_ip4_usr_seg - Check valid fields are provided for filter
  * @usr_ip4_spec: ethtool userdef packet offset
- * @perfect_fltr: only valid on success; returns true if perfect filter,
- *		  false if not
- *
- * Set the offset data into the flow segment to be used to program HW
- * table for IPv4
  */
-static int
-ice_set_fdir_ip4_usr_seg(struct ice_flow_seg_info *seg,
-			 struct ethtool_usrip4_spec *usr_ip4_spec,
-			 bool *perfect_fltr)
+int ice_ntuple_check_ip4_usr_seg(struct ethtool_usrip4_spec *usr_ip4_spec)
 {
+	if (!usr_ip4_spec)
+		return -EINVAL;
+
 	/* first 4 bytes of Layer 4 header */
 	if (usr_ip4_spec->l4_4_bytes)
 		return -EINVAL;
@@ -888,6 +922,33 @@ ice_set_fdir_ip4_usr_seg(struct ice_flow_seg_info *seg,
 	if (!usr_ip4_spec->ip4src && !usr_ip4_spec->ip4dst)
 		return -EINVAL;
 
+	return 0;
+}
+
+/**
+ * ice_set_fdir_ip4_usr_seg
+ * @seg: flow segment for programming
+ * @usr_ip4_spec: ethtool userdef packet offset
+ * @perfect_fltr: only set on success; returns true if perfect filter, false if
+ *		  not
+ *
+ * Set the offset data into the flow segment to be used to program HW
+ * table for IPv4
+ */
+static int
+ice_set_fdir_ip4_usr_seg(struct ice_flow_seg_info *seg,
+			 struct ethtool_usrip4_spec *usr_ip4_spec,
+			 bool *perfect_fltr)
+{
+	int ret;
+
+	if (!seg || !perfect_fltr)
+		return -EINVAL;
+
+	ret = ice_ntuple_check_ip4_usr_seg(usr_ip4_spec);
+	if (ret)
+		return ret;
+
 	*perfect_fltr = true;
 	ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_IPV4);
 
@@ -914,6 +975,30 @@ ice_set_fdir_ip4_usr_seg(struct ice_flow_seg_info *seg,
 	return 0;
 }
 
+/**
+ * ice_ntuple_check_ip6_seg - Check valid fields are provided for filter
+ * @tcp_ip6_spec: mask data from ethtool
+ */
+static int ice_ntuple_check_ip6_seg(struct ethtool_tcpip6_spec *tcp_ip6_spec)
+{
+	if (!tcp_ip6_spec)
+		return -EINVAL;
+
+	/* make sure we don't have any empty rule */
+	if (!memcmp(tcp_ip6_spec->ip6src, &zero_ipv6_addr_mask,
+		    sizeof(struct in6_addr)) &&
+	    !memcmp(tcp_ip6_spec->ip6dst, &zero_ipv6_addr_mask,
+		    sizeof(struct in6_addr)) &&
+	    !tcp_ip6_spec->psrc && !tcp_ip6_spec->pdst)
+		return -EINVAL;
+
+	/* filtering on TC not supported */
+	if (tcp_ip6_spec->tclass)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
 /**
  * ice_set_fdir_ip6_seg
  * @seg: flow segment for programming
@@ -931,31 +1016,18 @@ ice_set_fdir_ip6_seg(struct ice_flow_seg_info *seg,
 		     enum ice_flow_seg_hdr l4_proto, bool *perfect_fltr)
 {
 	enum ice_flow_field src_port, dst_port;
+	int ret;
 
-	/* make sure we don't have any empty rule */
-	if (!memcmp(tcp_ip6_spec->ip6src, &zero_ipv6_addr_mask,
-		    sizeof(struct in6_addr)) &&
-	    !memcmp(tcp_ip6_spec->ip6dst, &zero_ipv6_addr_mask,
-		    sizeof(struct in6_addr)) &&
-	    !tcp_ip6_spec->psrc && !tcp_ip6_spec->pdst)
+	if (!seg || !perfect_fltr)
 		return -EINVAL;
 
-	/* filtering on TC not supported */
-	if (tcp_ip6_spec->tclass)
-		return -EOPNOTSUPP;
+	ret = ice_ntuple_check_ip6_seg(tcp_ip6_spec);
+	if (ret)
+		return ret;
 
-	if (l4_proto == ICE_FLOW_SEG_HDR_TCP) {
-		src_port = ICE_FLOW_FIELD_IDX_TCP_SRC_PORT;
-		dst_port = ICE_FLOW_FIELD_IDX_TCP_DST_PORT;
-	} else if (l4_proto == ICE_FLOW_SEG_HDR_UDP) {
-		src_port = ICE_FLOW_FIELD_IDX_UDP_SRC_PORT;
-		dst_port = ICE_FLOW_FIELD_IDX_UDP_DST_PORT;
-	} else if (l4_proto == ICE_FLOW_SEG_HDR_SCTP) {
-		src_port = ICE_FLOW_FIELD_IDX_SCTP_SRC_PORT;
-		dst_port = ICE_FLOW_FIELD_IDX_SCTP_DST_PORT;
-	} else {
-		return -EINVAL;
-	}
+	ret = ice_ntuple_l4_proto_to_port(l4_proto, &src_port, &dst_port);
+	if (ret)
+		return ret;
 
 	*perfect_fltr = true;
 	ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_IPV6 | l4_proto);
@@ -1006,20 +1078,15 @@ ice_set_fdir_ip6_seg(struct ice_flow_seg_info *seg,
 }
 
 /**
- * ice_set_fdir_ip6_usr_seg
- * @seg: flow segment for programming
+ * ice_ntuple_check_ip6_usr_seg - Check valid fields are provided for filter
  * @usr_ip6_spec: ethtool userdef packet offset
- * @perfect_fltr: only valid on success; returns true if perfect filter,
- *		  false if not
- *
- * Set the offset data into the flow segment to be used to program HW
- * table for IPv6
  */
 static int
-ice_set_fdir_ip6_usr_seg(struct ice_flow_seg_info *seg,
-			 struct ethtool_usrip6_spec *usr_ip6_spec,
-			 bool *perfect_fltr)
+ice_ntuple_check_ip6_usr_seg(struct ethtool_usrip6_spec *usr_ip6_spec)
 {
+	if (!usr_ip6_spec)
+		return -EINVAL;
+
 	/* filtering on Layer 4 bytes not supported */
 	if (usr_ip6_spec->l4_4_bytes)
 		return -EOPNOTSUPP;
@@ -1036,6 +1103,33 @@ ice_set_fdir_ip6_usr_seg(struct ice_flow_seg_info *seg,
 		    sizeof(struct in6_addr)))
 		return -EINVAL;
 
+	return 0;
+}
+
+/**
+ * ice_set_fdir_ip6_usr_seg
+ * @seg: flow segment for programming
+ * @usr_ip6_spec: ethtool userdef packet offset
+ * @perfect_fltr: only set on success; returns true if perfect filter, false if
+ *		  not
+ *
+ * Set the offset data into the flow segment to be used to program HW
+ * table for IPv6
+ */
+static int
+ice_set_fdir_ip6_usr_seg(struct ice_flow_seg_info *seg,
+			 struct ethtool_usrip6_spec *usr_ip6_spec,
+			 bool *perfect_fltr)
+{
+	int ret;
+
+	if (!seg || !perfect_fltr)
+		return -EINVAL;
+
+	ret = ice_ntuple_check_ip6_usr_seg(usr_ip6_spec);
+	if (ret)
+		return ret;
+
 	*perfect_fltr = true;
 	ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_IPV6);
 
@@ -1489,6 +1583,64 @@ int ice_del_ntuple_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd)
 	return val;
 }
 
+/**
+ * ice_is_acl_filter - Checks if it's a FD or ACL filter
+ * @fsp: pointer to ethtool Rx flow specification
+ *
+ * If any field of the provided filter is using a partial mask then this is
+ * an ACL filter.
+ *
+ * Returns true if ACL filter otherwise false.
+ */
+static bool ice_is_acl_filter(struct ethtool_rx_flow_spec *fsp)
+{
+	struct ethtool_tcpip4_spec *tcp_ip4_spec;
+	struct ethtool_usrip4_spec *usr_ip4_spec;
+
+	switch (fsp->flow_type & ~FLOW_EXT) {
+	case TCP_V4_FLOW:
+	case UDP_V4_FLOW:
+	case SCTP_V4_FLOW:
+		tcp_ip4_spec = &fsp->m_u.tcp_ip4_spec;
+
+		/* IP source address */
+		if (tcp_ip4_spec->ip4src &&
+		    tcp_ip4_spec->ip4src != htonl(0xFFFFFFFF))
+			return true;
+
+		/* IP destination address */
+		if (tcp_ip4_spec->ip4dst &&
+		    tcp_ip4_spec->ip4dst != htonl(0xFFFFFFFF))
+			return true;
+
+		/* Layer 4 source port */
+		if (tcp_ip4_spec->psrc && tcp_ip4_spec->psrc != htons(0xFFFF))
+			return true;
+
+		/* Layer 4 destination port */
+		if (tcp_ip4_spec->pdst && tcp_ip4_spec->pdst != htons(0xFFFF))
+			return true;
+
+		break;
+	case IPV4_USER_FLOW:
+		usr_ip4_spec = &fsp->m_u.usr_ip4_spec;
+
+		/* IP source address */
+		if (usr_ip4_spec->ip4src &&
+		    usr_ip4_spec->ip4src != htonl(0xFFFFFFFF))
+			return true;
+
+		/* IP destination address */
+		if (usr_ip4_spec->ip4dst &&
+		    usr_ip4_spec->ip4dst != htonl(0xFFFFFFFF))
+			return true;
+
+		break;
+	}
+
+	return false;
+}
+
 /**
  * ice_ntuple_set_input_set - Set the input set for Flow Director
  * @vsi: pointer to target VSI
@@ -1651,7 +1803,7 @@ int ice_add_ntuple_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd)
 
 	/* Do not program filters during reset */
 	if (ice_is_reset_in_progress(pf->state)) {
-		dev_err(dev, "Device is resetting - adding Flow Director filters not supported during reset\n");
+		dev_err(dev, "Device is resetting - adding ntuple filters not supported during reset\n");
 		return -EBUSY;
 	}
 
@@ -1663,15 +1815,19 @@ int ice_add_ntuple_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd)
 	if (fsp->flow_type & FLOW_MAC_EXT)
 		return -EINVAL;
 
-	ret = ice_cfg_fdir_xtrct_seq(pf, fsp, &userdata);
-	if (ret)
-		return ret;
-
 	if (fsp->location >= ice_ntuple_get_max_fltr_cnt(hw)) {
-		dev_err(dev, "Failed to add filter.  The maximum number of flow director filters has been reached.\n");
+		dev_err(dev, "Failed to add filter.  The maximum number of ntuple filters has been reached.\n");
 		return -ENOSPC;
 	}
 
+	/* ACL filter */
+	if (pf->hw.acl_tbl && ice_is_acl_filter(fsp))
+		return ice_acl_add_rule_ethtool(vsi, cmd);
+
+	ret = ice_cfg_fdir_xtrct_seq(pf, fsp, &userdata);
+	if (ret)
+		return ret;
+
 	/* return error if not an update and no available filters */
 	fltrs_needed = ice_get_open_tunnel_port(hw, &tunnel_port) ? 2 : 1;
 	if (!ice_fdir_find_fltr_by_idx(hw, fsp->location) &&
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 9095b4d274ad..696d08e6716d 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -2409,6 +2409,9 @@ ice_find_prof_id(struct ice_hw *hw, enum ice_block blk,
 static bool ice_prof_id_rsrc_type(enum ice_block blk, u16 *rsrc_type)
 {
 	switch (blk) {
+	case ICE_BLK_ACL:
+		*rsrc_type = ICE_AQC_RES_TYPE_ACL_PROF_BLDR_PROFID;
+		break;
 	case ICE_BLK_FD:
 		*rsrc_type = ICE_AQC_RES_TYPE_FD_PROF_BLDR_PROFID;
 		break;
@@ -2429,6 +2432,9 @@ static bool ice_prof_id_rsrc_type(enum ice_block blk, u16 *rsrc_type)
 static bool ice_tcam_ent_rsrc_type(enum ice_block blk, u16 *rsrc_type)
 {
 	switch (blk) {
+	case ICE_BLK_ACL:
+		*rsrc_type = ICE_AQC_RES_TYPE_ACL_PROF_BLDR_TCAM;
+		break;
 	case ICE_BLK_FD:
 		*rsrc_type = ICE_AQC_RES_TYPE_FD_PROF_BLDR_TCAM;
 		break;
@@ -3800,7 +3806,6 @@ ice_add_prof(struct ice_hw *hw, enum ice_block blk, u64 id, u8 ptypes[],
 				 BITS_PER_BYTE) {
 			u16 ptype;
 			u8 ptg;
-			u8 m;
 
 			ptype = byte * BITS_PER_BYTE + bit;
 
@@ -3819,11 +3824,6 @@ ice_add_prof(struct ice_hw *hw, enum ice_block blk, u64 id, u8 ptypes[],
 
 			if (++prof->ptg_cnt >= ICE_MAX_PTG_PER_PROFILE)
 				break;
-
-			/* nothing left in byte, then exit */
-			m = ~(u8)((1 << (bit + 1)) - 1);
-			if (!(ptypes[byte] & m))
-				break;
 		}
 
 		bytes--;
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
index 2a92071bd7d1..d2df5101ef74 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.c
+++ b/drivers/net/ethernet/intel/ice/ice_flow.c
@@ -346,6 +346,42 @@ ice_flow_proc_seg_hdrs(struct ice_flow_prof_params *params)
 	return 0;
 }
 
+/**
+ * ice_flow_xtract_pkt_flags - Create an extr sequence entry for packet flags
+ * @hw: pointer to the HW struct
+ * @params: information about the flow to be processed
+ * @flags: The value of pkt_flags[x:x] in Rx/Tx MDID metadata.
+ *
+ * This function will allocate an extraction sequence entries for a DWORD size
+ * chunk of the packet flags.
+ */
+static enum ice_status
+ice_flow_xtract_pkt_flags(struct ice_hw *hw,
+			  struct ice_flow_prof_params *params,
+			  enum ice_flex_mdid_pkt_flags flags)
+{
+	u8 fv_words = hw->blk[params->blk].es.fvw;
+	u8 idx;
+
+	/* Make sure the number of extraction sequence entries required does not
+	 * exceed the block's capacity.
+	 */
+	if (params->es_cnt >= fv_words)
+		return ICE_ERR_MAX_LIMIT;
+
+	/* some blocks require a reversed field vector layout */
+	if (hw->blk[params->blk].es.reverse)
+		idx = fv_words - params->es_cnt - 1;
+	else
+		idx = params->es_cnt;
+
+	params->es[idx].prot_id = ICE_PROT_META_ID;
+	params->es[idx].off = flags;
+	params->es_cnt++;
+
+	return 0;
+}
+
 /**
  * ice_flow_xtract_fld - Create an extraction sequence entry for the given field
  * @hw: pointer to the HW struct
@@ -528,19 +564,29 @@ static enum ice_status
 ice_flow_create_xtrct_seq(struct ice_hw *hw,
 			  struct ice_flow_prof_params *params)
 {
-	struct ice_flow_prof *prof = params->prof;
 	enum ice_status status = 0;
 	u8 i;
 
-	for (i = 0; i < prof->segs_cnt; i++) {
-		u8 j;
+	/* For ACL, we also need to extract the direction bit (Rx,Tx) data from
+	 * packet flags
+	 */
+	if (params->blk == ICE_BLK_ACL) {
+		status = ice_flow_xtract_pkt_flags(hw, params,
+						   ICE_RX_MDID_PKT_FLAGS_15_0);
+		if (status)
+			return status;
+	}
 
-		for_each_set_bit(j, (unsigned long *)&prof->segs[i].match,
+	for (i = 0; i < params->prof->segs_cnt; i++) {
+		u64 match = params->prof->segs[i].match;
+		enum ice_flow_field j;
+
+		for_each_set_bit(j, (unsigned long *)&match,
 				 ICE_FLOW_FIELD_IDX_MAX) {
-			status = ice_flow_xtract_fld(hw, params, i,
-						     (enum ice_flow_field)j);
+			status = ice_flow_xtract_fld(hw, params, i, j);
 			if (status)
 				return status;
+			clear_bit(j, (unsigned long *)&match);
 		}
 
 		/* Process raw matching bytes */
@@ -552,6 +598,118 @@ ice_flow_create_xtrct_seq(struct ice_hw *hw,
 	return status;
 }
 
+/**
+ * ice_flow_sel_acl_scen - returns the specific scenario
+ * @hw: pointer to the hardware structure
+ * @params: information about the flow to be processed
+ *
+ * This function will return the specific scenario based on the
+ * params passed to it
+ */
+static enum ice_status
+ice_flow_sel_acl_scen(struct ice_hw *hw, struct ice_flow_prof_params *params)
+{
+	/* Find the best-fit scenario for the provided match width */
+	struct ice_acl_scen *cand_scen = NULL, *scen;
+
+	if (!hw->acl_tbl)
+		return ICE_ERR_DOES_NOT_EXIST;
+
+	/* Loop through each scenario and match against the scenario width
+	 * to select the specific scenario
+	 */
+	list_for_each_entry(scen, &hw->acl_tbl->scens, list_entry)
+		if (scen->eff_width >= params->entry_length &&
+		    (!cand_scen || cand_scen->eff_width > scen->eff_width))
+			cand_scen = scen;
+	if (!cand_scen)
+		return ICE_ERR_DOES_NOT_EXIST;
+
+	params->prof->cfg.scen = cand_scen;
+
+	return 0;
+}
+
+/**
+ * ice_flow_acl_def_entry_frmt - Determine the layout of flow entries
+ * @params: information about the flow to be processed
+ */
+static enum ice_status
+ice_flow_acl_def_entry_frmt(struct ice_flow_prof_params *params)
+{
+	u16 index, i, range_idx = 0;
+
+	index = ICE_AQC_ACL_PROF_BYTE_SEL_START_IDX;
+
+	for (i = 0; i < params->prof->segs_cnt; i++) {
+		struct ice_flow_seg_info *seg = &params->prof->segs[i];
+		u8 j;
+
+		for_each_set_bit(j, (unsigned long *)&seg->match,
+				 ICE_FLOW_FIELD_IDX_MAX) {
+			struct ice_flow_fld_info *fld = &seg->fields[j];
+
+			fld->entry.mask = ICE_FLOW_FLD_OFF_INVAL;
+
+			if (fld->type == ICE_FLOW_FLD_TYPE_RANGE) {
+				fld->entry.last = ICE_FLOW_FLD_OFF_INVAL;
+
+				/* Range checking only supported for single
+				 * words
+				 */
+				if (DIV_ROUND_UP(ice_flds_info[j].size +
+						 fld->xtrct.disp,
+						 BITS_PER_BYTE * 2) > 1)
+					return ICE_ERR_PARAM;
+
+				/* Ranges must define low and high values */
+				if (fld->src.val == ICE_FLOW_FLD_OFF_INVAL ||
+				    fld->src.last == ICE_FLOW_FLD_OFF_INVAL)
+					return ICE_ERR_PARAM;
+
+				fld->entry.val = range_idx++;
+			} else {
+				/* Store adjusted byte-length of field for later
+				 * use, taking into account potential
+				 * non-byte-aligned displacement
+				 */
+				fld->entry.last = DIV_ROUND_UP(ice_flds_info[j].size +
+							       (fld->xtrct.disp % BITS_PER_BYTE),
+							       BITS_PER_BYTE);
+				fld->entry.val = index;
+				index += fld->entry.last;
+			}
+		}
+
+		for (j = 0; j < seg->raws_cnt; j++) {
+			struct ice_flow_seg_fld_raw *raw = &seg->raws[j];
+
+			raw->info.entry.mask = ICE_FLOW_FLD_OFF_INVAL;
+			raw->info.entry.val = index;
+			raw->info.entry.last = raw->info.src.last;
+			index += raw->info.entry.last;
+		}
+	}
+
+	/* Currently only support using the byte selection base, which only
+	 * allows for an effective entry size of 30 bytes. Reject anything
+	 * larger.
+	 */
+	if (index > ICE_AQC_ACL_PROF_BYTE_SEL_ELEMS)
+		return ICE_ERR_PARAM;
+
+	/* Only 8 range checkers per profile, reject anything trying to use
+	 * more
+	 */
+	if (range_idx > ICE_AQC_ACL_PROF_RANGES_NUM_CFG)
+		return ICE_ERR_PARAM;
+
+	/* Store # bytes required for entry for later use */
+	params->entry_length = index - ICE_AQC_ACL_PROF_BYTE_SEL_START_IDX;
+
+	return 0;
+}
+
 /**
  * ice_flow_proc_segs - process all packet segments associated with a profile
  * @hw: pointer to the HW struct
@@ -575,6 +733,14 @@ ice_flow_proc_segs(struct ice_hw *hw, struct ice_flow_prof_params *params)
 	case ICE_BLK_RSS:
 		status = 0;
 		break;
+	case ICE_BLK_ACL:
+		status = ice_flow_acl_def_entry_frmt(params);
+		if (status)
+			return status;
+		status = ice_flow_sel_acl_scen(hw, params);
+		if (status)
+			return status;
+		break;
 	default:
 		return ICE_ERR_NOT_IMPL;
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.h b/drivers/net/ethernet/intel/ice/ice_flow.h
index 00109262f152..f0cea38e8e78 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.h
+++ b/drivers/net/ethernet/intel/ice/ice_flow.h
@@ -231,6 +231,23 @@ struct ice_rss_cfg {
 	u32 packet_hdr;
 };
 
+enum ice_flow_action_type {
+	ICE_FLOW_ACT_NOP,
+	ICE_FLOW_ACT_DROP,
+	ICE_FLOW_ACT_CNTR_PKT,
+	ICE_FLOW_ACT_FWD_QUEUE,
+	ICE_FLOW_ACT_CNTR_BYTES,
+	ICE_FLOW_ACT_CNTR_PKT_BYTES,
+};
+
+struct ice_flow_action {
+	enum ice_flow_action_type type;
+	union {
+		struct ice_acl_act_entry acl_act;
+		u32 dummy;
+	} data;
+};
+
 enum ice_status
 ice_flow_add_prof(struct ice_hw *hw, enum ice_block blk, enum ice_flow_dir dir,
 		  u64 prof_id, struct ice_flow_seg_info *segs, u8 segs_cnt,
-- 
2.26.2

