Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7351DF558
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 08:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387654AbgEWGzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 02:55:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:52995 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387672AbgEWGzC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 02:55:02 -0400
IronPort-SDR: pLLL50/QMg6TFY1YB5pV1u4yDEb2G0lrpc3ain5u2BDmgjSODztW5o6/8t0ohkuIRNon4omZ8l
 yPpUkqsFT/aw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 23:48:49 -0700
IronPort-SDR: XesA0G9CHcmM5y2uA8XNW1ErpmPZyT3h39P2j86zvZRs9UFgNzFRSh7MW878VZHwESFRszgbOQ
 96cv3v7aqDfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="374966876"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2020 23:48:48 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Henry Tieman <henry.w.tieman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/16] ice: Initialize Flow Director resources
Date:   Fri, 22 May 2020 23:48:33 -0700
Message-Id: <20200523064847.3972158-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
References: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Henry Tieman <henry.w.tieman@intel.com>

Flow Director allows for redirection based on ntuple rules. Rules are
programmed using the ethtool set-ntuple interface. Supported actions are
redirect to queue and drop.

Setup the initial framework to process Flow Director filters. Create and
allocate resources to manage and program filters to the hardware. Filters
are processed via a sideband interface; a control VSI is created to manage
communication and process requests through the sideband. Upon allocation of
resources, update the hardware tables to accept perfect filters.

Signed-off-by: Henry Tieman <henry.w.tieman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/Makefile       |   2 +
 drivers/net/ethernet/intel/ice/ice.h          |  24 ++
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   9 +
 drivers/net/ethernet/intel/ice/ice_base.c     |   1 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  36 ++
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  11 +-
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c | 399 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_fdir.c     |  54 +++
 drivers/net/ethernet/intel/ice/ice_fdir.h     |  12 +
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 224 ++++++++++
 drivers/net/ethernet/intel/ice/ice_flow.c     | 169 +++++++-
 drivers/net/ethernet/intel/ice/ice_flow.h     |  32 +-
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |  11 +
 drivers/net/ethernet/intel/ice/ice_lib.c      | 210 +++++++--
 drivers/net/ethernet/intel/ice/ice_lib.h      |   2 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 160 ++++++-
 .../ethernet/intel/ice/ice_protocol_type.h    |   1 +
 drivers/net/ethernet/intel/ice/ice_switch.c   |  75 ++++
 drivers/net/ethernet/intel/ice/ice_switch.h   |   7 +
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 100 ++++-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   7 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |  45 +-
 22 files changed, 1553 insertions(+), 38 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_fdir.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_fdir.h

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 2055e61eaf24..9ffa2e366766 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -18,6 +18,8 @@ ice-y := ice_main.o	\
 	 ice_txrx_lib.o	\
 	 ice_txrx.o	\
 	 ice_fltr.o	\
+	 ice_fdir.o	\
+	 ice_ethtool_fdir.o \
 	 ice_flex_pipe.o \
 	 ice_flow.o	\
 	 ice_devlink.o	\
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 58d0d6436c7f..ffd11bc2e5f0 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -50,6 +50,7 @@
 #include "ice_sched.h"
 #include "ice_virtchnl_pf.h"
 #include "ice_sriov.h"
+#include "ice_fdir.h"
 #include "ice_xsk.h"
 
 extern const char ice_drv_ver[];
@@ -66,6 +67,7 @@ extern const char ice_drv_ver[];
 #define ICE_AQ_LEN		64
 #define ICE_MBXSQ_LEN		64
 #define ICE_MIN_MSIX		2
+#define ICE_FDIR_MSIX		1
 #define ICE_NO_VSI		0xffff
 #define ICE_VSI_MAP_CONTIG	0
 #define ICE_VSI_MAP_SCATTER	1
@@ -257,6 +259,8 @@ struct ice_vsi {
 	s16 vf_id;			/* VF ID for SR-IOV VSIs */
 
 	u16 ethtype;			/* Ethernet protocol for pause frame */
+	u16 num_gfltr;
+	u16 num_bfltr;
 
 	/* RSS config */
 	u16 rss_table_size;	/* HW RSS table size */
@@ -339,6 +343,7 @@ enum ice_pf_flags {
 	ICE_FLAG_SRIOV_CAPABLE,
 	ICE_FLAG_DCB_CAPABLE,
 	ICE_FLAG_DCB_ENA,
+	ICE_FLAG_FD_ENA,
 	ICE_FLAG_ADV_FEATURES,
 	ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA,
 	ICE_FLAG_NO_MEDIA,
@@ -367,6 +372,8 @@ struct ice_pf {
 	 */
 	u16 sriov_base_vector;
 
+	u16 ctrl_vsi_idx;		/* control VSI index in pf->vsi array */
+
 	struct ice_vsi **vsi;		/* VSIs created by the driver */
 	struct ice_sw *first_sw;	/* first switch created by firmware */
 	/* Virtchnl/SR-IOV config info */
@@ -505,8 +512,22 @@ static inline struct ice_vsi *ice_get_main_vsi(struct ice_pf *pf)
 	return NULL;
 }
 
+/**
+ * ice_get_ctrl_vsi - Get the control VSI
+ * @pf: PF instance
+ */
+static inline struct ice_vsi *ice_get_ctrl_vsi(struct ice_pf *pf)
+{
+	/* if pf->ctrl_vsi_idx is ICE_NO_VSI, control VSI was not set up */
+	if (!pf->vsi || pf->ctrl_vsi_idx == ICE_NO_VSI)
+		return NULL;
+
+	return pf->vsi[pf->ctrl_vsi_idx];
+}
+
 int ice_vsi_setup_tx_rings(struct ice_vsi *vsi);
 int ice_vsi_setup_rx_rings(struct ice_vsi *vsi);
+int ice_vsi_open_ctrl(struct ice_vsi *vsi);
 void ice_set_ethtool_ops(struct net_device *netdev);
 void ice_set_ethtool_safe_mode_ops(struct net_device *netdev);
 u16 ice_get_avail_txq_count(struct ice_pf *pf);
@@ -530,6 +551,9 @@ int ice_schedule_reset(struct ice_pf *pf, enum ice_reset_req reset);
 void ice_print_link_msg(struct ice_vsi *vsi, bool isup);
 const char *ice_stat_str(enum ice_status stat_err);
 const char *ice_aq_str(enum ice_aq_err aq_err);
+void ice_vsi_manage_fdir(struct ice_vsi *vsi, bool ena);
+void ice_fdir_release_flows(struct ice_hw *hw);
+int ice_fdir_create_dflt_rules(struct ice_pf *pf);
 int ice_open(struct net_device *netdev);
 int ice_stop(struct net_device *netdev);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 979e9c6254af..deada2e3d7c0 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -107,6 +107,7 @@ struct ice_aqc_list_caps_elem {
 #define ICE_AQC_CAPS_RXQS				0x0041
 #define ICE_AQC_CAPS_TXQS				0x0042
 #define ICE_AQC_CAPS_MSIX				0x0043
+#define ICE_AQC_CAPS_FD					0x0045
 #define ICE_AQC_CAPS_MAX_MTU				0x0047
 
 	u8 major_ver;
@@ -232,6 +233,11 @@ struct ice_aqc_get_sw_cfg_resp {
  */
 #define ICE_AQC_RES_TYPE_VSI_LIST_REP			0x03
 #define ICE_AQC_RES_TYPE_VSI_LIST_PRUNE			0x04
+#define ICE_AQC_RES_TYPE_FDIR_COUNTER_BLOCK		0x21
+#define ICE_AQC_RES_TYPE_FDIR_GUARANTEED_ENTRIES	0x22
+#define ICE_AQC_RES_TYPE_FDIR_SHARED_ENTRIES		0x23
+#define ICE_AQC_RES_TYPE_FD_PROF_BLDR_PROFID		0x58
+#define ICE_AQC_RES_TYPE_FD_PROF_BLDR_TCAM		0x59
 #define ICE_AQC_RES_TYPE_HASH_PROF_BLDR_PROFID		0x60
 #define ICE_AQC_RES_TYPE_HASH_PROF_BLDR_TCAM		0x61
 
@@ -240,6 +246,9 @@ struct ice_aqc_get_sw_cfg_resp {
 
 #define ICE_AQC_RES_TYPE_FLAG_DEDICATED			0x00
 
+#define ICE_AQC_RES_TYPE_S	0
+#define ICE_AQC_RES_TYPE_M	(0x07F << ICE_AQC_RES_TYPE_S)
+
 /* Allocate Resources command (indirect 0x0208)
  * Free Resources command (indirect 0x0209)
  */
diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index 4c835c144907..00c072f61a32 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -246,6 +246,7 @@ ice_setup_tx_ctx(struct ice_ring *ring, struct ice_tlan_ctx *tlan_ctx, u16 pf_q)
 	 */
 	switch (vsi->type) {
 	case ICE_VSI_LB:
+	case ICE_VSI_CTRL:
 	case ICE_VSI_PF:
 		tlan_ctx->vmvf_type = ICE_TLAN_CTX_VMVF_TYPE_PF;
 		break;
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 1a613199d6cb..3a4c14150107 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -653,6 +653,10 @@ enum ice_status ice_init_hw(struct ice_hw *hw)
 	if (status)
 		goto err_unroll_cqinit;
 
+	/* Set bit to enable Flow Director filters */
+	wr32(hw, PFQF_FD_ENA, PFQF_FD_ENA_FD_ENA_M);
+	INIT_LIST_HEAD(&hw->fdir_list_head);
+
 	ice_clear_pxe_mode(hw);
 
 	status = ice_init_nvm(hw);
@@ -741,6 +745,10 @@ enum ice_status ice_init_hw(struct ice_hw *hw)
 	status = ice_aq_manage_mac_read(hw, mac_buf, mac_buf_len, NULL);
 	devm_kfree(ice_hw_to_dev(hw), mac_buf);
 
+	if (status)
+		goto err_unroll_fltr_mgmt_struct;
+	/* Obtain counter base index which would be used by flow director */
+	status = ice_alloc_fd_res_cntr(hw, &hw->fd_ctr_base);
 	if (status)
 		goto err_unroll_fltr_mgmt_struct;
 	status = ice_init_hw_tbls(hw);
@@ -770,6 +778,7 @@ enum ice_status ice_init_hw(struct ice_hw *hw)
  */
 void ice_deinit_hw(struct ice_hw *hw)
 {
+	ice_free_fd_res_cntr(hw, hw->fd_ctr_base);
 	ice_cleanup_fltr_mgmt_struct(hw);
 
 	ice_sched_cleanup_all(hw);
@@ -1680,6 +1689,33 @@ ice_parse_caps(struct ice_hw *hw, void *buf, u32 cap_count,
 				  "%s: msix_vector_first_id = %d\n", prefix,
 				  caps->msix_vector_first_id);
 			break;
+		case ICE_AQC_CAPS_FD:
+			if (dev_p) {
+				dev_p->num_flow_director_fltr = number;
+				ice_debug(hw, ICE_DBG_INIT,
+					  "%s: num_flow_director_fltr = %d\n",
+					  prefix,
+					  dev_p->num_flow_director_fltr);
+			}
+			if (func_p) {
+				u32 reg_val, val;
+
+				reg_val = rd32(hw, GLQF_FD_SIZE);
+				val = (reg_val & GLQF_FD_SIZE_FD_GSIZE_M) >>
+				      GLQF_FD_SIZE_FD_GSIZE_S;
+				func_p->fd_fltr_guar =
+				      ice_get_num_per_func(hw, val);
+				val = (reg_val & GLQF_FD_SIZE_FD_BSIZE_M) >>
+				      GLQF_FD_SIZE_FD_BSIZE_S;
+				func_p->fd_fltr_best_effort = val;
+				ice_debug(hw, ICE_DBG_INIT,
+					  "%s: fd_fltr_guar = %d\n",
+					  prefix, func_p->fd_fltr_guar);
+				ice_debug(hw, ICE_DBG_INIT,
+					  "%s: fd_fltr_best_effort = %d\n",
+					  prefix, func_p->fd_fltr_best_effort);
+			}
+			break;
 		case ICE_AQC_CAPS_MAX_MTU:
 			caps->max_mtu = number;
 			ice_debug(hw, ICE_DBG_INIT, "%s: max_mtu = %d\n",
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 9fb82c993df9..d11960b21474 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3184,6 +3184,10 @@ ice_get_channels(struct net_device *dev, struct ethtool_channels *ch)
 	ch->combined_count = ice_get_combined_cnt(vsi);
 	ch->rx_count = vsi->num_rxq - ch->combined_count;
 	ch->tx_count = vsi->num_txq - ch->combined_count;
+
+	/* report other queues */
+	ch->other_count = test_bit(ICE_FLAG_FD_ENA, pf->flags) ? 1 : 0;
+	ch->max_other = ch->other_count;
 }
 
 /**
@@ -3256,9 +3260,14 @@ static int ice_set_channels(struct net_device *dev, struct ethtool_channels *ch)
 		return -EOPNOTSUPP;
 	}
 	/* do not support changing other_count */
-	if (ch->other_count)
+	if (ch->other_count != (test_bit(ICE_FLAG_FD_ENA, pf->flags) ? 1U : 0U))
 		return -EINVAL;
 
+	if (test_bit(ICE_FLAG_FD_ENA, pf->flags) && pf->hw.fdir_active_fltr) {
+		netdev_err(dev, "Cannot set channels when Flow Director filters are active\n");
+		return -EOPNOTSUPP;
+	}
+
 	curr_combined = ice_get_combined_cnt(vsi);
 
 	/* these checks are for cases where user didn't specify a particular
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
new file mode 100644
index 000000000000..425bf6f00db1
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
@@ -0,0 +1,399 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2018-2020, Intel Corporation. */
+
+/* flow director ethtool support for ice */
+
+#include "ice.h"
+#include "ice_lib.h"
+#include "ice_flow.h"
+
+/* calls to ice_flow_add_prof require the number of segments in the array
+ * for segs_cnt. In this code that is one more than the index.
+ */
+#define TNL_SEG_CNT(_TNL_) ((_TNL_) + 1)
+
+/**
+ * ice_fdir_get_hw_prof - return the ice_fd_hw_proc associated with a flow
+ * @hw: hardware structure containing the filter list
+ * @blk: hardware block
+ * @flow: FDir flow type to release
+ */
+static struct ice_fd_hw_prof *
+ice_fdir_get_hw_prof(struct ice_hw *hw, enum ice_block blk, int flow)
+{
+	if (blk == ICE_BLK_FD && hw->fdir_prof)
+		return hw->fdir_prof[flow];
+
+	return NULL;
+}
+
+/**
+ * ice_fdir_erase_flow_from_hw - remove a flow from the HW profile tables
+ * @hw: hardware structure containing the filter list
+ * @blk: hardware block
+ * @flow: FDir flow type to release
+ */
+static void
+ice_fdir_erase_flow_from_hw(struct ice_hw *hw, enum ice_block blk, int flow)
+{
+	struct ice_fd_hw_prof *prof = ice_fdir_get_hw_prof(hw, blk, flow);
+	int tun;
+
+	if (!prof)
+		return;
+
+	for (tun = 0; tun < ICE_FD_HW_SEG_MAX; tun++) {
+		u64 prof_id;
+		int j;
+
+		prof_id = flow + tun * ICE_FLTR_PTYPE_MAX;
+		for (j = 0; j < prof->cnt; j++) {
+			u16 vsi_num;
+
+			if (!prof->entry_h[j][tun] || !prof->vsi_h[j])
+				continue;
+			vsi_num = ice_get_hw_vsi_num(hw, prof->vsi_h[j]);
+			ice_rem_prof_id_flow(hw, blk, vsi_num, prof_id);
+			ice_flow_rem_entry(hw, blk, prof->entry_h[j][tun]);
+			prof->entry_h[j][tun] = 0;
+		}
+		ice_flow_rem_prof(hw, blk, prof_id);
+	}
+}
+
+/**
+ * ice_fdir_rem_flow - release the ice_flow structures for a filter type
+ * @hw: hardware structure containing the filter list
+ * @blk: hardware block
+ * @flow_type: FDir flow type to release
+ */
+static void
+ice_fdir_rem_flow(struct ice_hw *hw, enum ice_block blk,
+		  enum ice_fltr_ptype flow_type)
+{
+	int flow = (int)flow_type & ~FLOW_EXT;
+	struct ice_fd_hw_prof *prof;
+	int tun, i;
+
+	prof = ice_fdir_get_hw_prof(hw, blk, flow);
+	if (!prof)
+		return;
+
+	ice_fdir_erase_flow_from_hw(hw, blk, flow);
+	for (i = 0; i < prof->cnt; i++)
+		prof->vsi_h[i] = 0;
+	for (tun = 0; tun < ICE_FD_HW_SEG_MAX; tun++) {
+		if (!prof->fdir_seg[tun])
+			continue;
+		devm_kfree(ice_hw_to_dev(hw), prof->fdir_seg[tun]);
+		prof->fdir_seg[tun] = NULL;
+	}
+	prof->cnt = 0;
+}
+
+/**
+ * ice_fdir_release_flows - release all flows in use for later replay
+ * @hw: pointer to HW instance
+ */
+void ice_fdir_release_flows(struct ice_hw *hw)
+{
+	int flow;
+
+	/* release Flow Director HW table entries */
+	for (flow = 0; flow < ICE_FLTR_PTYPE_MAX; flow++)
+		ice_fdir_erase_flow_from_hw(hw, ICE_BLK_FD, flow);
+}
+
+/**
+ * ice_fdir_alloc_flow_prof - allocate FDir flow profile structure(s)
+ * @hw: HW structure containing the FDir flow profile structure(s)
+ * @flow: flow type to allocate the flow profile for
+ *
+ * Allocate the fdir_prof and fdir_prof[flow] if not already created. Return 0
+ * on success and negative on error.
+ */
+static int
+ice_fdir_alloc_flow_prof(struct ice_hw *hw, enum ice_fltr_ptype flow)
+{
+	if (!hw)
+		return -EINVAL;
+
+	if (!hw->fdir_prof) {
+		hw->fdir_prof = devm_kcalloc(ice_hw_to_dev(hw),
+					     ICE_FLTR_PTYPE_MAX,
+					     sizeof(*hw->fdir_prof),
+					     GFP_KERNEL);
+		if (!hw->fdir_prof)
+			return -ENOMEM;
+	}
+
+	if (!hw->fdir_prof[flow]) {
+		hw->fdir_prof[flow] = devm_kzalloc(ice_hw_to_dev(hw),
+						   sizeof(**hw->fdir_prof),
+						   GFP_KERNEL);
+		if (!hw->fdir_prof[flow])
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+/**
+ * ice_fdir_set_hw_fltr_rule - Configure HW tables to generate a FDir rule
+ * @pf: pointer to the PF structure
+ * @seg: protocol header description pointer
+ * @flow: filter enum
+ * @tun: FDir segment to program
+ */
+static int
+ice_fdir_set_hw_fltr_rule(struct ice_pf *pf, struct ice_flow_seg_info *seg,
+			  enum ice_fltr_ptype flow, enum ice_fd_hw_seg tun)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_vsi *main_vsi, *ctrl_vsi;
+	struct ice_flow_seg_info *old_seg;
+	struct ice_flow_prof *prof = NULL;
+	struct ice_fd_hw_prof *hw_prof;
+	struct ice_hw *hw = &pf->hw;
+	enum ice_status status;
+	u64 entry1_h = 0;
+	u64 entry2_h = 0;
+	u64 prof_id;
+	int err;
+
+	main_vsi = ice_get_main_vsi(pf);
+	if (!main_vsi)
+		return -EINVAL;
+
+	ctrl_vsi = ice_get_ctrl_vsi(pf);
+	if (!ctrl_vsi)
+		return -EINVAL;
+
+	err = ice_fdir_alloc_flow_prof(hw, flow);
+	if (err)
+		return err;
+
+	hw_prof = hw->fdir_prof[flow];
+	old_seg = hw_prof->fdir_seg[tun];
+	if (old_seg) {
+		/* This flow_type already has a changed input set.
+		 * If it matches the requested input set then we are
+		 * done. Or, if it's different then it's an error.
+		 */
+		if (!memcmp(old_seg, seg, sizeof(*seg)))
+			return -EEXIST;
+
+		/* remove HW filter definition */
+		ice_fdir_rem_flow(hw, ICE_BLK_FD, flow);
+	}
+
+	/* Adding a profile, but there is only one header supported.
+	 * That is the final parameters are 1 header (segment), no
+	 * actions (NULL) and zero actions 0.
+	 */
+	prof_id = flow + tun * ICE_FLTR_PTYPE_MAX;
+	status = ice_flow_add_prof(hw, ICE_BLK_FD, ICE_FLOW_RX, prof_id, seg,
+				   TNL_SEG_CNT(tun), &prof);
+	if (status)
+		return ice_status_to_errno(status);
+	status = ice_flow_add_entry(hw, ICE_BLK_FD, prof_id, main_vsi->idx,
+				    main_vsi->idx, ICE_FLOW_PRIO_NORMAL,
+				    seg, &entry1_h);
+	if (status) {
+		err = ice_status_to_errno(status);
+		goto err_prof;
+	}
+	status = ice_flow_add_entry(hw, ICE_BLK_FD, prof_id, main_vsi->idx,
+				    ctrl_vsi->idx, ICE_FLOW_PRIO_NORMAL,
+				    seg, &entry2_h);
+	if (status) {
+		err = ice_status_to_errno(status);
+		goto err_entry;
+	}
+
+	hw_prof->fdir_seg[tun] = seg;
+	hw_prof->entry_h[0][tun] = entry1_h;
+	hw_prof->entry_h[1][tun] = entry2_h;
+	hw_prof->vsi_h[0] = main_vsi->idx;
+	hw_prof->vsi_h[1] = ctrl_vsi->idx;
+	if (!hw_prof->cnt)
+		hw_prof->cnt = 2;
+
+	return 0;
+
+err_entry:
+	ice_rem_prof_id_flow(hw, ICE_BLK_FD,
+			     ice_get_hw_vsi_num(hw, main_vsi->idx), prof_id);
+	ice_flow_rem_entry(hw, ICE_BLK_FD, entry1_h);
+err_prof:
+	ice_flow_rem_prof(hw, ICE_BLK_FD, prof_id);
+	dev_err(dev, "Failed to add filter.  Flow director filters on each port must have the same input set.\n");
+
+	return err;
+}
+
+/**
+ * ice_set_init_fdir_seg
+ * @seg: flow segment for programming
+ * @l4_proto: ICE_FLOW_SEG_HDR_TCP or ICE_FLOW_SEG_HDR_UDP
+ *
+ * Set the configuration for perfect filters to the provided flow segment for
+ * programming the HW filter. This is to be called only when initializing
+ * filters as this function it assumes no filters exist.
+ */
+static int
+ice_set_init_fdir_seg(struct ice_flow_seg_info *seg,
+		      enum ice_flow_seg_hdr l4_proto)
+{
+	enum ice_flow_field src_port, dst_port;
+
+	if (!seg)
+		return -EINVAL;
+
+	if (l4_proto == ICE_FLOW_SEG_HDR_TCP) {
+		src_port = ICE_FLOW_FIELD_IDX_TCP_SRC_PORT;
+		dst_port = ICE_FLOW_FIELD_IDX_TCP_DST_PORT;
+	} else if (l4_proto == ICE_FLOW_SEG_HDR_UDP) {
+		src_port = ICE_FLOW_FIELD_IDX_UDP_SRC_PORT;
+		dst_port = ICE_FLOW_FIELD_IDX_UDP_DST_PORT;
+	} else {
+		return -EINVAL;
+	}
+
+	ICE_FLOW_SET_HDRS(seg, ICE_FLOW_SEG_HDR_IPV4 | l4_proto);
+
+	/* IP source address */
+	ice_flow_set_fld(seg, ICE_FLOW_FIELD_IDX_IPV4_SA,
+			 ICE_FLOW_FLD_OFF_INVAL, ICE_FLOW_FLD_OFF_INVAL,
+			 ICE_FLOW_FLD_OFF_INVAL, false);
+
+	/* IP destination address */
+	ice_flow_set_fld(seg, ICE_FLOW_FIELD_IDX_IPV4_DA,
+			 ICE_FLOW_FLD_OFF_INVAL, ICE_FLOW_FLD_OFF_INVAL,
+			 ICE_FLOW_FLD_OFF_INVAL, false);
+
+	/* Layer 4 source port */
+	ice_flow_set_fld(seg, src_port, ICE_FLOW_FLD_OFF_INVAL,
+			 ICE_FLOW_FLD_OFF_INVAL, ICE_FLOW_FLD_OFF_INVAL, false);
+
+	/* Layer 4 destination port */
+	ice_flow_set_fld(seg, dst_port, ICE_FLOW_FLD_OFF_INVAL,
+			 ICE_FLOW_FLD_OFF_INVAL, ICE_FLOW_FLD_OFF_INVAL, false);
+
+	return 0;
+}
+
+/**
+ * ice_create_init_fdir_rule
+ * @pf: PF structure
+ * @flow: filter enum
+ *
+ * Return error value or 0 on success.
+ */
+static int
+ice_create_init_fdir_rule(struct ice_pf *pf, enum ice_fltr_ptype flow)
+{
+	struct ice_flow_seg_info *seg, *tun_seg;
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_hw *hw = &pf->hw;
+	int ret;
+
+	/* if there is already a filter rule for kind return -EINVAL */
+	if (hw->fdir_prof && hw->fdir_prof[flow] &&
+	    hw->fdir_prof[flow]->fdir_seg[0])
+		return -EINVAL;
+
+	seg = devm_kzalloc(dev, sizeof(*seg), GFP_KERNEL);
+	if (!seg)
+		return -ENOMEM;
+
+	tun_seg = devm_kzalloc(dev, sizeof(*seg) * ICE_FD_HW_SEG_MAX,
+			       GFP_KERNEL);
+	if (!tun_seg) {
+		devm_kfree(dev, seg);
+		return -ENOMEM;
+	}
+
+	if (flow == ICE_FLTR_PTYPE_NONF_IPV4_TCP)
+		ret = ice_set_init_fdir_seg(seg, ICE_FLOW_SEG_HDR_TCP);
+	else if (flow == ICE_FLTR_PTYPE_NONF_IPV4_UDP)
+		ret = ice_set_init_fdir_seg(seg, ICE_FLOW_SEG_HDR_UDP);
+	else
+		ret = -EINVAL;
+	if (ret)
+		goto err_exit;
+
+	/* add filter for outer headers */
+	ret = ice_fdir_set_hw_fltr_rule(pf, seg, flow, ICE_FD_HW_SEG_NON_TUN);
+	if (ret)
+		/* could not write filter, free memory */
+		goto err_exit;
+
+	/* make tunneled filter HW entries if possible */
+	memcpy(&tun_seg[1], seg, sizeof(*seg));
+	ret = ice_fdir_set_hw_fltr_rule(pf, tun_seg, flow, ICE_FD_HW_SEG_TUN);
+	if (ret)
+		/* could not write tunnel filter, but outer header filter
+		 * exists
+		 */
+		devm_kfree(dev, tun_seg);
+
+	set_bit(flow, hw->fdir_perfect_fltr);
+	return ret;
+err_exit:
+	devm_kfree(dev, tun_seg);
+	devm_kfree(dev, seg);
+
+	return -EOPNOTSUPP;
+}
+
+/**
+ * ice_fdir_create_dflt_rules - create default perfect filters
+ * @pf: PF data structure
+ *
+ * Returns 0 for success or error.
+ */
+int ice_fdir_create_dflt_rules(struct ice_pf *pf)
+{
+	int err;
+
+	/* Create perfect TCP and UDP rules in hardware. */
+	err = ice_create_init_fdir_rule(pf, ICE_FLTR_PTYPE_NONF_IPV4_TCP);
+	if (err)
+		return err;
+
+	err = ice_create_init_fdir_rule(pf, ICE_FLTR_PTYPE_NONF_IPV4_UDP);
+
+	return err;
+}
+
+/**
+ * ice_vsi_manage_fdir - turn on/off flow director
+ * @vsi: the VSI being changed
+ * @ena: boolean value indicating if this is an enable or disable request
+ */
+void ice_vsi_manage_fdir(struct ice_vsi *vsi, bool ena)
+{
+	struct ice_pf *pf = vsi->back;
+	struct ice_hw *hw = &pf->hw;
+	enum ice_fltr_ptype flow;
+
+	if (ena) {
+		set_bit(ICE_FLAG_FD_ENA, pf->flags);
+		ice_fdir_create_dflt_rules(pf);
+		return;
+	}
+
+	mutex_lock(&hw->fdir_fltr_lock);
+	if (!test_and_clear_bit(ICE_FLAG_FD_ENA, pf->flags))
+		goto release_lock;
+
+	if (hw->fdir_prof)
+		for (flow = ICE_FLTR_PTYPE_NONF_NONE; flow < ICE_FLTR_PTYPE_MAX;
+		     flow++)
+			if (hw->fdir_prof[flow])
+				ice_fdir_rem_flow(hw, ICE_BLK_FD, flow);
+
+release_lock:
+	mutex_unlock(&hw->fdir_fltr_lock);
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_fdir.c b/drivers/net/ethernet/intel/ice/ice_fdir.c
new file mode 100644
index 000000000000..878fa4df9453
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_fdir.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2018-2020, Intel Corporation. */
+
+#include "ice_common.h"
+
+/**
+ * ice_alloc_fd_res_cntr - obtain counter resource for FD type
+ * @hw: pointer to the hardware structure
+ * @cntr_id: returns counter index
+ */
+enum ice_status ice_alloc_fd_res_cntr(struct ice_hw *hw, u16 *cntr_id)
+{
+	return ice_alloc_res_cntr(hw, ICE_AQC_RES_TYPE_FDIR_COUNTER_BLOCK,
+				  ICE_AQC_RES_TYPE_FLAG_DEDICATED, 1, cntr_id);
+}
+
+/**
+ * ice_free_fd_res_cntr - Free counter resource for FD type
+ * @hw: pointer to the hardware structure
+ * @cntr_id: counter index to be freed
+ */
+enum ice_status ice_free_fd_res_cntr(struct ice_hw *hw, u16 cntr_id)
+{
+	return ice_free_res_cntr(hw, ICE_AQC_RES_TYPE_FDIR_COUNTER_BLOCK,
+				 ICE_AQC_RES_TYPE_FLAG_DEDICATED, 1, cntr_id);
+}
+
+/**
+ * ice_alloc_fd_guar_item - allocate resource for FD guaranteed entries
+ * @hw: pointer to the hardware structure
+ * @cntr_id: returns counter index
+ * @num_fltr: number of filter entries to be allocated
+ */
+enum ice_status
+ice_alloc_fd_guar_item(struct ice_hw *hw, u16 *cntr_id, u16 num_fltr)
+{
+	return ice_alloc_res_cntr(hw, ICE_AQC_RES_TYPE_FDIR_GUARANTEED_ENTRIES,
+				  ICE_AQC_RES_TYPE_FLAG_DEDICATED, num_fltr,
+				  cntr_id);
+}
+
+/**
+ * ice_alloc_fd_shrd_item - allocate resource for flow director shared entries
+ * @hw: pointer to the hardware structure
+ * @cntr_id: returns counter index
+ * @num_fltr: number of filter entries to be allocated
+ */
+enum ice_status
+ice_alloc_fd_shrd_item(struct ice_hw *hw, u16 *cntr_id, u16 num_fltr)
+{
+	return ice_alloc_res_cntr(hw, ICE_AQC_RES_TYPE_FDIR_SHARED_ENTRIES,
+				  ICE_AQC_RES_TYPE_FLAG_DEDICATED, num_fltr,
+				  cntr_id);
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_fdir.h b/drivers/net/ethernet/intel/ice/ice_fdir.h
new file mode 100644
index 000000000000..feac47adde6e
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_fdir.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2018-2020, Intel Corporation. */
+
+#ifndef _ICE_FDIR_H_
+#define _ICE_FDIR_H_
+enum ice_status ice_alloc_fd_res_cntr(struct ice_hw *hw, u16 *cntr_id);
+enum ice_status ice_free_fd_res_cntr(struct ice_hw *hw, u16 cntr_id);
+enum ice_status
+ice_alloc_fd_guar_item(struct ice_hw *hw, u16 *cntr_id, u16 num_fltr);
+enum ice_status
+ice_alloc_fd_shrd_item(struct ice_hw *hw, u16 *cntr_id, u16 num_fltr);
+#endif /* _ICE_FDIR_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 38c37f506257..fe2f04f706e7 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -2353,6 +2353,9 @@ ice_find_prof_id(struct ice_hw *hw, enum ice_block blk,
 static bool ice_prof_id_rsrc_type(enum ice_block blk, u16 *rsrc_type)
 {
 	switch (blk) {
+	case ICE_BLK_FD:
+		*rsrc_type = ICE_AQC_RES_TYPE_FD_PROF_BLDR_PROFID;
+		break;
 	case ICE_BLK_RSS:
 		*rsrc_type = ICE_AQC_RES_TYPE_HASH_PROF_BLDR_PROFID;
 		break;
@@ -2370,6 +2373,9 @@ static bool ice_prof_id_rsrc_type(enum ice_block blk, u16 *rsrc_type)
 static bool ice_tcam_ent_rsrc_type(enum ice_block blk, u16 *rsrc_type)
 {
 	switch (blk) {
+	case ICE_BLK_FD:
+		*rsrc_type = ICE_AQC_RES_TYPE_FD_PROF_BLDR_TCAM;
+		break;
 	case ICE_BLK_RSS:
 		*rsrc_type = ICE_AQC_RES_TYPE_HASH_PROF_BLDR_TCAM;
 		break;
@@ -2813,6 +2819,12 @@ static void ice_free_flow_profs(struct ice_hw *hw, u8 blk_idx)
 
 	mutex_lock(&hw->fl_profs_locks[blk_idx]);
 	list_for_each_entry_safe(p, tmp, &hw->fl_profs[blk_idx], l_entry) {
+		struct ice_flow_entry *e, *t;
+
+		list_for_each_entry_safe(e, t, &p->entries, l_entry)
+			ice_flow_rem_entry(hw, (enum ice_block)blk_idx,
+					   ICE_FLOW_ENTRY_HNDL(e));
+
 		list_del(&p->l_entry);
 		devm_kfree(ice_hw_to_dev(hw), p);
 	}
@@ -3441,6 +3453,206 @@ ice_upd_prof_hw(struct ice_hw *hw, enum ice_block blk,
 	return status;
 }
 
+/**
+ * ice_update_fd_mask - set Flow Director Field Vector mask for a profile
+ * @hw: pointer to the HW struct
+ * @prof_id: profile ID
+ * @mask_sel: mask select
+ *
+ * This function enable any of the masks selected by the mask select parameter
+ * for the profile specified.
+ */
+static void ice_update_fd_mask(struct ice_hw *hw, u16 prof_id, u32 mask_sel)
+{
+	wr32(hw, GLQF_FDMASK_SEL(prof_id), mask_sel);
+
+	ice_debug(hw, ICE_DBG_INIT, "fd mask(%d): %x = %x\n", prof_id,
+		  GLQF_FDMASK_SEL(prof_id), mask_sel);
+}
+
+struct ice_fd_src_dst_pair {
+	u8 prot_id;
+	u8 count;
+	u16 off;
+};
+
+static const struct ice_fd_src_dst_pair ice_fd_pairs[] = {
+	/* These are defined in pairs */
+	{ ICE_PROT_IPV4_OF_OR_S, 2, 12 },
+	{ ICE_PROT_IPV4_OF_OR_S, 2, 16 },
+
+	{ ICE_PROT_IPV4_IL, 2, 12 },
+	{ ICE_PROT_IPV4_IL, 2, 16 },
+
+	{ ICE_PROT_TCP_IL, 1, 0 },
+	{ ICE_PROT_TCP_IL, 1, 2 },
+
+	{ ICE_PROT_UDP_OF, 1, 0 },
+	{ ICE_PROT_UDP_OF, 1, 2 },
+
+	{ ICE_PROT_UDP_IL_OR_S, 1, 0 },
+	{ ICE_PROT_UDP_IL_OR_S, 1, 2 },
+
+	{ ICE_PROT_SCTP_IL, 1, 0 },
+	{ ICE_PROT_SCTP_IL, 1, 2 }
+};
+
+#define ICE_FD_SRC_DST_PAIR_COUNT	ARRAY_SIZE(ice_fd_pairs)
+
+/**
+ * ice_update_fd_swap - set register appropriately for a FD FV extraction
+ * @hw: pointer to the HW struct
+ * @prof_id: profile ID
+ * @es: extraction sequence (length of array is determined by the block)
+ */
+static enum ice_status
+ice_update_fd_swap(struct ice_hw *hw, u16 prof_id, struct ice_fv_word *es)
+{
+	DECLARE_BITMAP(pair_list, ICE_FD_SRC_DST_PAIR_COUNT);
+	u8 pair_start[ICE_FD_SRC_DST_PAIR_COUNT] = { 0 };
+#define ICE_FD_FV_NOT_FOUND (-2)
+	s8 first_free = ICE_FD_FV_NOT_FOUND;
+	u8 used[ICE_MAX_FV_WORDS] = { 0 };
+	s8 orig_free, si;
+	u32 mask_sel = 0;
+	u8 i, j, k;
+
+	bitmap_zero(pair_list, ICE_FD_SRC_DST_PAIR_COUNT);
+
+	/* This code assumes that the Flow Director field vectors are assigned
+	 * from the end of the FV indexes working towards the zero index, that
+	 * only complete fields will be included and will be consecutive, and
+	 * that there are no gaps between valid indexes.
+	 */
+
+	/* Determine swap fields present */
+	for (i = 0; i < hw->blk[ICE_BLK_FD].es.fvw; i++) {
+		/* Find the first free entry, assuming right to left population.
+		 * This is where we can start adding additional pairs if needed.
+		 */
+		if (first_free == ICE_FD_FV_NOT_FOUND && es[i].prot_id !=
+		    ICE_PROT_INVALID)
+			first_free = i - 1;
+
+		for (j = 0; j < ICE_FD_SRC_DST_PAIR_COUNT; j++)
+			if (es[i].prot_id == ice_fd_pairs[j].prot_id &&
+			    es[i].off == ice_fd_pairs[j].off) {
+				set_bit(j, pair_list);
+				pair_start[j] = i;
+			}
+	}
+
+	orig_free = first_free;
+
+	/* determine missing swap fields that need to be added */
+	for (i = 0; i < ICE_FD_SRC_DST_PAIR_COUNT; i += 2) {
+		u8 bit1 = test_bit(i + 1, pair_list);
+		u8 bit0 = test_bit(i, pair_list);
+
+		if (bit0 ^ bit1) {
+			u8 index;
+
+			/* add the appropriate 'paired' entry */
+			if (!bit0)
+				index = i;
+			else
+				index = i + 1;
+
+			/* check for room */
+			if (first_free + 1 < (s8)ice_fd_pairs[index].count)
+				return ICE_ERR_MAX_LIMIT;
+
+			/* place in extraction sequence */
+			for (k = 0; k < ice_fd_pairs[index].count; k++) {
+				es[first_free - k].prot_id =
+					ice_fd_pairs[index].prot_id;
+				es[first_free - k].off =
+					ice_fd_pairs[index].off + (k * 2);
+
+				if (k > first_free)
+					return ICE_ERR_OUT_OF_RANGE;
+
+				/* keep track of non-relevant fields */
+				mask_sel |= BIT(first_free - k);
+			}
+
+			pair_start[index] = first_free;
+			first_free -= ice_fd_pairs[index].count;
+		}
+	}
+
+	/* fill in the swap array */
+	si = hw->blk[ICE_BLK_FD].es.fvw - 1;
+	while (si >= 0) {
+		u8 indexes_used = 1;
+
+		/* assume flat at this index */
+#define ICE_SWAP_VALID	0x80
+		used[si] = si | ICE_SWAP_VALID;
+
+		if (orig_free == ICE_FD_FV_NOT_FOUND || si <= orig_free) {
+			si -= indexes_used;
+			continue;
+		}
+
+		/* check for a swap location */
+		for (j = 0; j < ICE_FD_SRC_DST_PAIR_COUNT; j++)
+			if (es[si].prot_id == ice_fd_pairs[j].prot_id &&
+			    es[si].off == ice_fd_pairs[j].off) {
+				u8 idx;
+
+				/* determine the appropriate matching field */
+				idx = j + ((j % 2) ? -1 : 1);
+
+				indexes_used = ice_fd_pairs[idx].count;
+				for (k = 0; k < indexes_used; k++) {
+					used[si - k] = (pair_start[idx] - k) |
+						ICE_SWAP_VALID;
+				}
+
+				break;
+			}
+
+		si -= indexes_used;
+	}
+
+	/* for each set of 4 swap and 4 inset indexes, write the appropriate
+	 * register
+	 */
+	for (j = 0; j < hw->blk[ICE_BLK_FD].es.fvw / 4; j++) {
+		u32 raw_swap = 0;
+		u32 raw_in = 0;
+
+		for (k = 0; k < 4; k++) {
+			u8 idx;
+
+			idx = (j * 4) + k;
+			if (used[idx] && !(mask_sel & BIT(idx))) {
+				raw_swap |= used[idx] << (k * BITS_PER_BYTE);
+#define ICE_INSET_DFLT 0x9f
+				raw_in |= ICE_INSET_DFLT << (k * BITS_PER_BYTE);
+			}
+		}
+
+		/* write the appropriate swap register set */
+		wr32(hw, GLQF_FDSWAP(prof_id, j), raw_swap);
+
+		ice_debug(hw, ICE_DBG_INIT, "swap wr(%d, %d): %x = %08x\n",
+			  prof_id, j, GLQF_FDSWAP(prof_id, j), raw_swap);
+
+		/* write the appropriate inset register set */
+		wr32(hw, GLQF_FDINSET(prof_id, j), raw_in);
+
+		ice_debug(hw, ICE_DBG_INIT, "inset wr(%d, %d): %x = %08x\n",
+			  prof_id, j, GLQF_FDINSET(prof_id, j), raw_in);
+	}
+
+	/* initially clear the mask select for this profile */
+	ice_update_fd_mask(hw, prof_id, 0);
+
+	return 0;
+}
+
 /**
  * ice_add_prof - add profile
  * @hw: pointer to the HW struct
@@ -3476,6 +3688,18 @@ ice_add_prof(struct ice_hw *hw, enum ice_block blk, u64 id, u8 ptypes[],
 		status = ice_alloc_prof_id(hw, blk, &prof_id);
 		if (status)
 			goto err_ice_add_prof;
+		if (blk == ICE_BLK_FD) {
+			/* For Flow Director block, the extraction sequence may
+			 * need to be altered in the case where there are paired
+			 * fields that have no match. This is necessary because
+			 * for Flow Director, src and dest fields need to paired
+			 * for filter programming and these values are swapped
+			 * during Tx.
+			 */
+			status = ice_update_fd_swap(hw, prof_id, es);
+			if (status)
+				goto err_ice_add_prof;
+		}
 
 		/* and write new es */
 		ice_write_es(hw, blk, prof_id, es);
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
index 07875db08c3f..f4b6c3933564 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.c
+++ b/drivers/net/ethernet/intel/ice/ice_flow.c
@@ -397,10 +397,8 @@ ice_flow_proc_segs(struct ice_hw *hw, struct ice_flow_prof_params *params)
 		return status;
 
 	switch (params->blk) {
+	case ICE_BLK_FD:
 	case ICE_BLK_RSS:
-		/* Only header information is provided for RSS configuration.
-		 * No further processing is needed.
-		 */
 		status = 0;
 		break;
 	default:
@@ -481,6 +479,43 @@ ice_flow_find_prof_id(struct ice_hw *hw, enum ice_block blk, u64 prof_id)
 	return NULL;
 }
 
+/**
+ * ice_dealloc_flow_entry - Deallocate flow entry memory
+ * @hw: pointer to the HW struct
+ * @entry: flow entry to be removed
+ */
+static void
+ice_dealloc_flow_entry(struct ice_hw *hw, struct ice_flow_entry *entry)
+{
+	if (!entry)
+		return;
+
+	if (entry->entry)
+		devm_kfree(ice_hw_to_dev(hw), entry->entry);
+
+	devm_kfree(ice_hw_to_dev(hw), entry);
+}
+
+/**
+ * ice_flow_rem_entry_sync - Remove a flow entry
+ * @hw: pointer to the HW struct
+ * @blk: classification stage
+ * @entry: flow entry to be removed
+ */
+static enum ice_status
+ice_flow_rem_entry_sync(struct ice_hw *hw, enum ice_block __always_unused blk,
+			struct ice_flow_entry *entry)
+{
+	if (!entry)
+		return ICE_ERR_BAD_PTR;
+
+	list_del(&entry->l_entry);
+
+	ice_dealloc_flow_entry(hw, entry);
+
+	return 0;
+}
+
 /**
  * ice_flow_add_prof_sync - Add a flow profile for packet segments and fields
  * @hw: pointer to the HW struct
@@ -568,6 +603,21 @@ ice_flow_rem_prof_sync(struct ice_hw *hw, enum ice_block blk,
 {
 	enum ice_status status;
 
+	/* Remove all remaining flow entries before removing the flow profile */
+	if (!list_empty(&prof->entries)) {
+		struct ice_flow_entry *e, *t;
+
+		mutex_lock(&prof->entries_lock);
+
+		list_for_each_entry_safe(e, t, &prof->entries, l_entry) {
+			status = ice_flow_rem_entry_sync(hw, blk, e);
+			if (status)
+				break;
+		}
+
+		mutex_unlock(&prof->entries_lock);
+	}
+
 	/* Remove all hardware profiles associated with this flow profile */
 	status = ice_rem_prof(hw, blk, prof->id);
 	if (!status) {
@@ -653,7 +703,7 @@ ice_flow_disassoc_prof(struct ice_hw *hw, enum ice_block blk,
  * @segs_cnt: number of packet segments provided
  * @prof: stores the returned flow profile added
  */
-static enum ice_status
+enum ice_status
 ice_flow_add_prof(struct ice_hw *hw, enum ice_block blk, enum ice_flow_dir dir,
 		  u64 prof_id, struct ice_flow_seg_info *segs, u8 segs_cnt,
 		  struct ice_flow_prof **prof)
@@ -691,7 +741,7 @@ ice_flow_add_prof(struct ice_hw *hw, enum ice_block blk, enum ice_flow_dir dir,
  * @blk: the block for which the flow profile is to be removed
  * @prof_id: unique ID of the flow profile to be removed
  */
-static enum ice_status
+enum ice_status
 ice_flow_rem_prof(struct ice_hw *hw, enum ice_block blk, u64 prof_id)
 {
 	struct ice_flow_prof *prof;
@@ -714,6 +764,113 @@ ice_flow_rem_prof(struct ice_hw *hw, enum ice_block blk, u64 prof_id)
 	return status;
 }
 
+/**
+ * ice_flow_add_entry - Add a flow entry
+ * @hw: pointer to the HW struct
+ * @blk: classification stage
+ * @prof_id: ID of the profile to add a new flow entry to
+ * @entry_id: unique ID to identify this flow entry
+ * @vsi_handle: software VSI handle for the flow entry
+ * @prio: priority of the flow entry
+ * @data: pointer to a data buffer containing flow entry's match values/masks
+ * @entry_h: pointer to buffer that receives the new flow entry's handle
+ */
+enum ice_status
+ice_flow_add_entry(struct ice_hw *hw, enum ice_block blk, u64 prof_id,
+		   u64 entry_id, u16 vsi_handle, enum ice_flow_priority prio,
+		   void *data, u64 *entry_h)
+{
+	struct ice_flow_entry *e = NULL;
+	struct ice_flow_prof *prof;
+	enum ice_status status;
+
+	/* No flow entry data is expected for RSS */
+	if (!entry_h || (!data && blk != ICE_BLK_RSS))
+		return ICE_ERR_BAD_PTR;
+
+	if (!ice_is_vsi_valid(hw, vsi_handle))
+		return ICE_ERR_PARAM;
+
+	mutex_lock(&hw->fl_profs_locks[blk]);
+
+	prof = ice_flow_find_prof_id(hw, blk, prof_id);
+	if (!prof) {
+		status = ICE_ERR_DOES_NOT_EXIST;
+	} else {
+		/* Allocate memory for the entry being added and associate
+		 * the VSI to the found flow profile
+		 */
+		e = devm_kzalloc(ice_hw_to_dev(hw), sizeof(*e), GFP_KERNEL);
+		if (!e)
+			status = ICE_ERR_NO_MEMORY;
+		else
+			status = ice_flow_assoc_prof(hw, blk, prof, vsi_handle);
+	}
+
+	mutex_unlock(&hw->fl_profs_locks[blk]);
+	if (status)
+		goto out;
+
+	e->id = entry_id;
+	e->vsi_handle = vsi_handle;
+	e->prof = prof;
+	e->priority = prio;
+
+	switch (blk) {
+	case ICE_BLK_FD:
+	case ICE_BLK_RSS:
+		break;
+	default:
+		status = ICE_ERR_NOT_IMPL;
+		goto out;
+	}
+
+	mutex_lock(&prof->entries_lock);
+	list_add(&e->l_entry, &prof->entries);
+	mutex_unlock(&prof->entries_lock);
+
+	*entry_h = ICE_FLOW_ENTRY_HNDL(e);
+
+out:
+	if (status && e) {
+		if (e->entry)
+			devm_kfree(ice_hw_to_dev(hw), e->entry);
+		devm_kfree(ice_hw_to_dev(hw), e);
+	}
+
+	return status;
+}
+
+/**
+ * ice_flow_rem_entry - Remove a flow entry
+ * @hw: pointer to the HW struct
+ * @blk: classification stage
+ * @entry_h: handle to the flow entry to be removed
+ */
+enum ice_status ice_flow_rem_entry(struct ice_hw *hw, enum ice_block blk,
+				   u64 entry_h)
+{
+	struct ice_flow_entry *entry;
+	struct ice_flow_prof *prof;
+	enum ice_status status = 0;
+
+	if (entry_h == ICE_FLOW_ENTRY_HANDLE_INVAL)
+		return ICE_ERR_PARAM;
+
+	entry = ICE_FLOW_ENTRY_PTR(entry_h);
+
+	/* Retain the pointer to the flow profile as the entry will be freed */
+	prof = entry->prof;
+
+	if (prof) {
+		mutex_lock(&prof->entries_lock);
+		status = ice_flow_rem_entry_sync(hw, blk, entry);
+		mutex_unlock(&prof->entries_lock);
+	}
+
+	return status;
+}
+
 /**
  * ice_flow_set_fld_ext - specifies locations of field from entry's input buffer
  * @seg: packet segment the field being set belongs to
@@ -776,7 +933,7 @@ ice_flow_set_fld_ext(struct ice_flow_seg_info *seg, enum ice_flow_field fld,
  * create the content of a match entry. This function should only be used for
  * fixed-size data structures.
  */
-static void
+void
 ice_flow_set_fld(struct ice_flow_seg_info *seg, enum ice_flow_field fld,
 		 u16 val_loc, u16 mask_loc, u16 last_loc, bool range)
 {
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.h b/drivers/net/ethernet/intel/ice/ice_flow.h
index 00f2b7a9feed..3c784c3b5db2 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.h
+++ b/drivers/net/ethernet/intel/ice/ice_flow.h
@@ -172,6 +172,22 @@ struct ice_flow_seg_info {
 	struct ice_flow_fld_info fields[ICE_FLOW_FIELD_IDX_MAX];
 };
 
+/* This structure describes a flow entry, and is tracked only in this file */
+struct ice_flow_entry {
+	struct list_head l_entry;
+
+	u64 id;
+	struct ice_flow_prof *prof;
+	/* Flow entry's content */
+	void *entry;
+	enum ice_flow_priority priority;
+	u16 vsi_handle;
+	u16 entry_sz;
+};
+
+#define ICE_FLOW_ENTRY_HNDL(e)	((u64)e)
+#define ICE_FLOW_ENTRY_PTR(h)	((struct ice_flow_entry *)(h))
+
 struct ice_flow_prof {
 	struct list_head l_entry;
 
@@ -197,7 +213,21 @@ struct ice_rss_cfg {
 	u32 packet_hdr;
 };
 
-enum ice_status ice_flow_rem_entry(struct ice_hw *hw, u64 entry_h);
+enum ice_status
+ice_flow_add_prof(struct ice_hw *hw, enum ice_block blk, enum ice_flow_dir dir,
+		  u64 prof_id, struct ice_flow_seg_info *segs, u8 segs_cnt,
+		  struct ice_flow_prof **prof);
+enum ice_status
+ice_flow_rem_prof(struct ice_hw *hw, enum ice_block blk, u64 prof_id);
+enum ice_status
+ice_flow_add_entry(struct ice_hw *hw, enum ice_block blk, u64 prof_id,
+		   u64 entry_id, u16 vsi, enum ice_flow_priority prio,
+		   void *data, u64 *entry_h);
+enum ice_status
+ice_flow_rem_entry(struct ice_hw *hw, enum ice_block blk, u64 entry_h);
+void
+ice_flow_set_fld(struct ice_flow_seg_info *seg, enum ice_flow_field fld,
+		 u16 val_loc, u16 mask_loc, u16 last_loc, bool range);
 void ice_rem_vsi_rss_list(struct ice_hw *hw, u16 vsi_handle);
 enum ice_status ice_replay_rss_cfg(struct ice_hw *hw, u16 vsi_handle);
 enum ice_status
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index bc48eda67c81..3c61b2a04fc4 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -290,6 +290,17 @@
 #define GL_PWR_MODE_CTL				0x000B820C
 #define GL_PWR_MODE_CTL_CAR_MAX_BW_S		30
 #define GL_PWR_MODE_CTL_CAR_MAX_BW_M		ICE_M(0x3, 30)
+#define GLQF_FD_SIZE				0x00460010
+#define GLQF_FD_SIZE_FD_GSIZE_S			0
+#define GLQF_FD_SIZE_FD_GSIZE_M			ICE_M(0x7FFF, 0)
+#define GLQF_FD_SIZE_FD_BSIZE_S			16
+#define GLQF_FD_SIZE_FD_BSIZE_M			ICE_M(0x7FFF, 16)
+#define GLQF_FDINSET(_i, _j)			(0x00412000 + ((_i) * 4 + (_j) * 512))
+#define GLQF_FDMASK_SEL(_i)			(0x00410400 + ((_i) * 4))
+#define GLQF_FDSWAP(_i, _j)			(0x00413000 + ((_i) * 4 + (_j) * 512))
+#define PFQF_FD_ENA				0x0043A000
+#define PFQF_FD_ENA_FD_ENA_M			BIT(0)
+#define PFQF_FD_SIZE				0x00460100
 #define GLDCB_RTCTQ_RXQNUM_S			0
 #define GLDCB_RTCTQ_RXQNUM_M			ICE_M(0x7FF, 0)
 #define GLPRT_BPRCL(_i)				(0x00381380 + ((_i) * 8))
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index c73c977f6967..43c949e0a760 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -19,6 +19,8 @@ const char *ice_vsi_type_str(enum ice_vsi_type vsi_type)
 		return "ICE_VSI_PF";
 	case ICE_VSI_VF:
 		return "ICE_VSI_VF";
+	case ICE_VSI_CTRL:
+		return "ICE_VSI_CTRL";
 	case ICE_VSI_LB:
 		return "ICE_VSI_LB";
 	default:
@@ -123,6 +125,7 @@ static void ice_vsi_set_num_desc(struct ice_vsi *vsi)
 {
 	switch (vsi->type) {
 	case ICE_VSI_PF:
+	case ICE_VSI_CTRL:
 	case ICE_VSI_LB:
 		vsi->num_rx_desc = ICE_DFLT_NUM_RX_DESC;
 		vsi->num_tx_desc = ICE_DFLT_NUM_TX_DESC;
@@ -187,6 +190,11 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, u16 vf_id)
 		 */
 		vsi->num_q_vectors = pf->num_msix_per_vf - ICE_NONQ_VECS_VF;
 		break;
+	case ICE_VSI_CTRL:
+		vsi->alloc_txq = 1;
+		vsi->alloc_rxq = 1;
+		vsi->num_q_vectors = 1;
+		break;
 	case ICE_VSI_LB:
 		vsi->alloc_txq = 1;
 		vsi->alloc_rxq = 1;
@@ -322,7 +330,7 @@ int ice_vsi_clear(struct ice_vsi *vsi)
 	/* updates the PF for this cleared VSI */
 
 	pf->vsi[vsi->idx] = NULL;
-	if (vsi->idx < pf->next_vsi)
+	if (vsi->idx < pf->next_vsi && vsi->type != ICE_VSI_CTRL)
 		pf->next_vsi = vsi->idx;
 
 	ice_vsi_free_arrays(vsi);
@@ -332,6 +340,25 @@ int ice_vsi_clear(struct ice_vsi *vsi)
 	return 0;
 }
 
+/**
+ * ice_msix_clean_ctrl_vsi - MSIX mode interrupt handler for ctrl VSI
+ * @irq: interrupt number
+ * @data: pointer to a q_vector
+ */
+static irqreturn_t ice_msix_clean_ctrl_vsi(int __always_unused irq, void *data)
+{
+	struct ice_q_vector *q_vector = (struct ice_q_vector *)data;
+
+	if (!q_vector->tx.ring)
+		return IRQ_HANDLED;
+
+#define FDIR_RX_DESC_CLEAN_BUDGET 64
+	ice_clean_rx_irq(q_vector->rx.ring, FDIR_RX_DESC_CLEAN_BUDGET);
+	ice_clean_ctrl_tx_irq(q_vector->tx.ring);
+
+	return IRQ_HANDLED;
+}
+
 /**
  * ice_msix_clean_rings - MSIX mode Interrupt Handler
  * @irq: interrupt number
@@ -383,8 +410,6 @@ ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type vsi_type, u16 vf_id)
 	vsi->back = pf;
 	set_bit(__ICE_DOWN, vsi->state);
 
-	vsi->idx = pf->next_vsi;
-
 	if (vsi_type == ICE_VSI_VF)
 		ice_vsi_set_num_qs(vsi, vf_id);
 	else
@@ -398,6 +423,13 @@ ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type vsi_type, u16 vf_id)
 		/* Setup default MSIX irq handler for VSI */
 		vsi->irq_handler = ice_msix_clean_rings;
 		break;
+	case ICE_VSI_CTRL:
+		if (ice_vsi_alloc_arrays(vsi))
+			goto err_rings;
+
+		/* Setup ctrl VSI MSIX irq handler */
+		vsi->irq_handler = ice_msix_clean_ctrl_vsi;
+		break;
 	case ICE_VSI_VF:
 		if (ice_vsi_alloc_arrays(vsi))
 			goto err_rings;
@@ -411,12 +443,20 @@ ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type vsi_type, u16 vf_id)
 		goto unlock_pf;
 	}
 
-	/* fill VSI slot in the PF struct */
-	pf->vsi[pf->next_vsi] = vsi;
+	if (vsi->type == ICE_VSI_CTRL) {
+		/* Use the last VSI slot as the index for the control VSI */
+		vsi->idx = pf->num_alloc_vsi - 1;
+		pf->ctrl_vsi_idx = vsi->idx;
+		pf->vsi[vsi->idx] = vsi;
+	} else {
+		/* fill slot and make note of the index */
+		vsi->idx = pf->next_vsi;
+		pf->vsi[pf->next_vsi] = vsi;
 
-	/* prepare pf->next_vsi for next use */
-	pf->next_vsi = ice_get_free_slot(pf->vsi, pf->num_alloc_vsi,
-					 pf->next_vsi);
+		/* prepare pf->next_vsi for next use */
+		pf->next_vsi = ice_get_free_slot(pf->vsi, pf->num_alloc_vsi,
+						 pf->next_vsi);
+	}
 	goto unlock_pf;
 
 err_rings:
@@ -427,6 +467,48 @@ ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type vsi_type, u16 vf_id)
 	return vsi;
 }
 
+/**
+ * ice_alloc_fd_res - Allocate FD resource for a VSI
+ * @vsi: pointer to the ice_vsi
+ *
+ * This allocates the FD resources
+ *
+ * Returns 0 on success, -EPERM on no-op or -EIO on failure
+ */
+static int ice_alloc_fd_res(struct ice_vsi *vsi)
+{
+	struct ice_pf *pf = vsi->back;
+	u32 g_val, b_val;
+
+	/* Flow Director filters are only allocated/assigned to the PF VSI which
+	 * passes the traffic. The CTRL VSI is only used to add/delete filters
+	 * so we don't allocate resources to it
+	 */
+
+	/* FD filters from guaranteed pool per VSI */
+	g_val = pf->hw.func_caps.fd_fltr_guar;
+	if (!g_val)
+		return -EPERM;
+
+	/* FD filters from best effort pool */
+	b_val = pf->hw.func_caps.fd_fltr_best_effort;
+	if (!b_val)
+		return -EPERM;
+
+	if (vsi->type != ICE_VSI_PF)
+		return -EPERM;
+
+	if (!test_bit(ICE_FLAG_FD_ENA, pf->flags))
+		return -EPERM;
+
+	vsi->num_gfltr = g_val / pf->num_alloc_vsi;
+
+	/* each VSI gets same "best_effort" quota */
+	vsi->num_bfltr = b_val;
+
+	return 0;
+}
+
 /**
  * ice_vsi_get_qs - Assign queues from PF to VSI
  * @vsi: the VSI to assign queues to
@@ -583,8 +665,8 @@ static void ice_vsi_set_rss_params(struct ice_vsi *vsi)
 	case ICE_VSI_LB:
 		break;
 	default:
-		dev_warn(ice_pf_to_dev(pf), "Unknown VSI type %d\n",
-			 vsi->type);
+		dev_dbg(ice_pf_to_dev(pf), "Unsupported VSI type %s\n",
+			ice_vsi_type_str(vsi->type));
 		break;
 	}
 }
@@ -753,6 +835,51 @@ static void ice_vsi_setup_q_map(struct ice_vsi *vsi, struct ice_vsi_ctx *ctxt)
 	ctxt->info.q_mapping[1] = cpu_to_le16(vsi->num_rxq);
 }
 
+/**
+ * ice_set_fd_vsi_ctx - Set FD VSI context before adding a VSI
+ * @ctxt: the VSI context being set
+ * @vsi: the VSI being configured
+ */
+static void ice_set_fd_vsi_ctx(struct ice_vsi_ctx *ctxt, struct ice_vsi *vsi)
+{
+	u8 dflt_q_group, dflt_q_prio;
+	u16 dflt_q, report_q, val;
+
+	if (vsi->type != ICE_VSI_PF && vsi->type != ICE_VSI_CTRL)
+		return;
+
+	val = ICE_AQ_VSI_PROP_FLOW_DIR_VALID;
+	ctxt->info.valid_sections |= cpu_to_le16(val);
+	dflt_q = 0;
+	dflt_q_group = 0;
+	report_q = 0;
+	dflt_q_prio = 0;
+
+	/* enable flow director filtering/programming */
+	val = ICE_AQ_VSI_FD_ENABLE | ICE_AQ_VSI_FD_PROG_ENABLE;
+	ctxt->info.fd_options = cpu_to_le16(val);
+	/* max of allocated flow director filters */
+	ctxt->info.max_fd_fltr_dedicated =
+			cpu_to_le16(vsi->num_gfltr);
+	/* max of shared flow director filters any VSI may program */
+	ctxt->info.max_fd_fltr_shared =
+			cpu_to_le16(vsi->num_bfltr);
+	/* default queue index within the VSI of the default FD */
+	val = ((dflt_q << ICE_AQ_VSI_FD_DEF_Q_S) &
+	       ICE_AQ_VSI_FD_DEF_Q_M);
+	/* target queue or queue group to the FD filter */
+	val |= ((dflt_q_group << ICE_AQ_VSI_FD_DEF_GRP_S) &
+		ICE_AQ_VSI_FD_DEF_GRP_M);
+	ctxt->info.fd_def_q = cpu_to_le16(val);
+	/* queue index on which FD filter completion is reported */
+	val = ((report_q << ICE_AQ_VSI_FD_REPORT_Q_S) &
+	       ICE_AQ_VSI_FD_REPORT_Q_M);
+	/* priority of the default qindex action */
+	val |= ((dflt_q_prio << ICE_AQ_VSI_FD_DEF_PRIORITY_S) &
+		ICE_AQ_VSI_FD_DEF_PRIORITY_M);
+	ctxt->info.fd_report_opt = cpu_to_le16(val);
+}
+
 /**
  * ice_set_rss_vsi_ctx - Set RSS VSI context before adding a VSI
  * @ctxt: the VSI context being set
@@ -778,13 +905,10 @@ static void ice_set_rss_vsi_ctx(struct ice_vsi_ctx *ctxt, struct ice_vsi *vsi)
 		lut_type = ICE_AQ_VSI_Q_OPT_RSS_LUT_VSI;
 		hash_type = ICE_AQ_VSI_Q_OPT_RSS_TPLZ;
 		break;
-	case ICE_VSI_LB:
+	default:
 		dev_dbg(dev, "Unsupported VSI type %s\n",
 			ice_vsi_type_str(vsi->type));
 		return;
-	default:
-		dev_warn(dev, "Unknown VSI type %d\n", vsi->type);
-		return;
 	}
 
 	ctxt->info.q_opt_rss = ((lut_type << ICE_AQ_VSI_Q_OPT_RSS_LUT_S) &
@@ -816,6 +940,7 @@ static int ice_vsi_init(struct ice_vsi *vsi, bool init_vsi)
 
 	ctxt->info = vsi->info;
 	switch (vsi->type) {
+	case ICE_VSI_CTRL:
 	case ICE_VSI_LB:
 	case ICE_VSI_PF:
 		ctxt->flags = ICE_AQ_VSI_TYPE_PF;
@@ -831,12 +956,15 @@ static int ice_vsi_init(struct ice_vsi *vsi, bool init_vsi)
 	}
 
 	ice_set_dflt_vsi_ctx(ctxt);
+	if (test_bit(ICE_FLAG_FD_ENA, pf->flags))
+		ice_set_fd_vsi_ctx(ctxt, vsi);
 	/* if the switch is in VEB mode, allow VSI loopback */
 	if (vsi->vsw->bridge_mode == BRIDGE_MODE_VEB)
 		ctxt->info.sw_flags |= ICE_AQ_VSI_SW_FLAG_ALLOW_LB;
 
 	/* Set LUT type and HASH type if RSS is enabled */
-	if (test_bit(ICE_FLAG_RSS_ENA, pf->flags)) {
+	if (test_bit(ICE_FLAG_RSS_ENA, pf->flags) &&
+	    vsi->type != ICE_VSI_CTRL) {
 		ice_set_rss_vsi_ctx(ctxt, vsi);
 		/* if updating VSI context, make sure to set valid_section:
 		 * to indicate which section of VSI context being updated
@@ -1986,10 +2114,12 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 	if (vsi->type == ICE_VSI_VF)
 		vsi->vf_id = vf_id;
 
+	ice_alloc_fd_res(vsi);
+
 	if (ice_vsi_get_qs(vsi)) {
 		dev_err(dev, "Failed to allocate queues. vsi->idx = %d\n",
 			vsi->idx);
-		goto unroll_get_qs;
+		goto unroll_vsi_alloc;
 	}
 
 	/* set RSS capabilities */
@@ -2004,6 +2134,7 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 		goto unroll_get_qs;
 
 	switch (vsi->type) {
+	case ICE_VSI_CTRL:
 	case ICE_VSI_PF:
 		ret = ice_vsi_alloc_q_vectors(vsi);
 		if (ret)
@@ -2034,14 +2165,16 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 
 		ice_vsi_map_rings_to_vectors(vsi);
 
-		/* Do not exit if configuring RSS had an issue, at least
-		 * receive traffic on first queue. Hence no need to capture
-		 * return value
-		 */
-		if (test_bit(ICE_FLAG_RSS_ENA, pf->flags)) {
-			ice_vsi_cfg_rss_lut_key(vsi);
-			ice_vsi_set_rss_flow_fld(vsi);
-		}
+		/* ICE_VSI_CTRL does not need RSS so skip RSS processing */
+		if (vsi->type != ICE_VSI_CTRL)
+			/* Do not exit if configuring RSS had an issue, at
+			 * least receive traffic on first queue. Hence no
+			 * need to capture return value
+			 */
+			if (test_bit(ICE_FLAG_RSS_ENA, pf->flags)) {
+				ice_vsi_cfg_rss_lut_key(vsi);
+				ice_vsi_set_rss_flow_fld(vsi);
+			}
 		break;
 	case ICE_VSI_VF:
 		/* VF driver will take care of creating netdev for this type and
@@ -2122,6 +2255,7 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 	ice_vsi_delete(vsi);
 unroll_get_qs:
 	ice_vsi_put_qs(vsi);
+unroll_vsi_alloc:
 	ice_vsi_clear(vsi);
 
 	return NULL;
@@ -2274,6 +2408,8 @@ int ice_ena_vsi(struct ice_vsi *vsi, bool locked)
 			if (!locked)
 				rtnl_unlock();
 		}
+	} else if (vsi->type == ICE_VSI_CTRL) {
+		err = ice_vsi_open_ctrl(vsi);
 	}
 
 	return err;
@@ -2303,6 +2439,8 @@ void ice_dis_vsi(struct ice_vsi *vsi, bool locked)
 		} else {
 			ice_vsi_close(vsi);
 		}
+	} else if (vsi->type == ICE_VSI_CTRL) {
+		ice_vsi_close(vsi);
 	}
 }
 
@@ -2848,6 +2986,30 @@ void ice_update_rx_ring_stats(struct ice_ring *rx_ring, u64 pkts, u64 bytes)
 	u64_stats_update_end(&rx_ring->syncp);
 }
 
+/**
+ * ice_status_to_errno - convert from enum ice_status to Linux errno
+ * @err: ice_status value to convert
+ */
+int ice_status_to_errno(enum ice_status err)
+{
+	switch (err) {
+	case ICE_SUCCESS:
+		return 0;
+	case ICE_ERR_DOES_NOT_EXIST:
+		return -ENOENT;
+	case ICE_ERR_OUT_OF_RANGE:
+		return -ENOTTY;
+	case ICE_ERR_PARAM:
+		return -EINVAL;
+	case ICE_ERR_NO_MEMORY:
+		return -ENOMEM;
+	case ICE_ERR_MAX_LIMIT:
+		return -EAGAIN;
+	default:
+		return -EINVAL;
+	}
+}
+
 /**
  * ice_is_dflt_vsi_in_use - check if the default forwarding VSI is being used
  * @sw: switch to check if its default forwarding VSI is free
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 9746de9b25fe..076e635e0c9f 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -92,6 +92,8 @@ void ice_update_rx_ring_stats(struct ice_ring *ring, u64 pkts, u64 bytes);
 
 void ice_vsi_cfg_frame_size(struct ice_vsi *vsi);
 
+int ice_status_to_errno(enum ice_status err);
+
 u32 ice_intrl_usec_to_reg(u8 intrl, u8 gran);
 
 enum ice_status
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c3e5c4334e26..2cc1f345c845 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2319,6 +2319,7 @@ static void ice_set_netdev_features(struct net_device *netdev)
 
 	dflt_features = NETIF_F_SG	|
 			NETIF_F_HIGHDMA	|
+			NETIF_F_NTUPLE	|
 			NETIF_F_RXHASH;
 
 	csumo_features = NETIF_F_RXCSUM	  |
@@ -2458,6 +2459,20 @@ ice_pf_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi)
 	return ice_vsi_setup(pf, pi, ICE_VSI_PF, ICE_INVAL_VFID);
 }
 
+/**
+ * ice_ctrl_vsi_setup - Set up a control VSI
+ * @pf: board private structure
+ * @pi: pointer to the port_info instance
+ *
+ * Returns pointer to the successfully allocated VSI software struct
+ * on success, otherwise returns NULL on failure.
+ */
+static struct ice_vsi *
+ice_ctrl_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi)
+{
+	return ice_vsi_setup(pf, pi, ICE_VSI_CTRL, ICE_INVAL_VFID);
+}
+
 /**
  * ice_lb_vsi_setup - Set up a loopback VSI
  * @pf: board private structure
@@ -2706,6 +2721,23 @@ static void ice_set_pf_caps(struct ice_pf *pf)
 	if (func_caps->common_cap.rss_table_size)
 		set_bit(ICE_FLAG_RSS_ENA, pf->flags);
 
+	clear_bit(ICE_FLAG_FD_ENA, pf->flags);
+	if (func_caps->fd_fltr_guar > 0 || func_caps->fd_fltr_best_effort > 0) {
+		u16 unused;
+
+		/* ctrl_vsi_idx will be set to a valid value when flow director
+		 * is setup by ice_init_fdir
+		 */
+		pf->ctrl_vsi_idx = ICE_NO_VSI;
+		set_bit(ICE_FLAG_FD_ENA, pf->flags);
+		/* force guaranteed filter pool for PF */
+		ice_alloc_fd_guar_item(&pf->hw, &unused,
+				       func_caps->fd_fltr_guar);
+		/* force shared filter pool for PF */
+		ice_alloc_fd_shrd_item(&pf->hw, &unused,
+				       func_caps->fd_fltr_best_effort);
+	}
+
 	pf->max_pf_txqs = func_caps->common_cap.num_txq;
 	pf->max_pf_rxqs = func_caps->common_cap.num_rxq;
 }
@@ -2772,6 +2804,15 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 	v_budget += needed;
 	v_left -= needed;
 
+	/* reserve one vector for flow director */
+	if (test_bit(ICE_FLAG_FD_ENA, pf->flags)) {
+		needed = ICE_FDIR_MSIX;
+		if (v_left < needed)
+			goto no_hw_vecs_left_err;
+		v_budget += needed;
+		v_left -= needed;
+	}
+
 	pf->msix_entries = devm_kcalloc(dev, v_budget,
 					sizeof(*pf->msix_entries), GFP_KERNEL);
 
@@ -2796,8 +2837,10 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 	if (v_actual < v_budget) {
 		dev_warn(dev, "not enough OS MSI-X vectors. requested = %d, obtained = %d\n",
 			 v_budget, v_actual);
-/* 2 vectors for LAN (traffic + OICR) */
+/* 2 vectors each for LAN and RDMA (traffic + OICR), one for flow director */
 #define ICE_MIN_LAN_VECS 2
+#define ICE_MIN_RDMA_VECS 2
+#define ICE_MIN_VECS (ICE_MIN_LAN_VECS + ICE_MIN_RDMA_VECS + 1)
 
 		if (v_actual < ICE_MIN_LAN_VECS) {
 			/* error if we can't get minimum vectors */
@@ -3102,6 +3145,53 @@ static enum ice_status ice_send_version(struct ice_pf *pf)
 	return ice_aq_send_driver_ver(&pf->hw, &dv, NULL);
 }
 
+/**
+ * ice_init_fdir - Initialize flow director VSI and configuration
+ * @pf: pointer to the PF instance
+ *
+ * returns 0 on success, negative on error
+ */
+static int ice_init_fdir(struct ice_pf *pf)
+{
+	struct device *dev = ice_pf_to_dev(pf);
+	struct ice_vsi *ctrl_vsi;
+	int err;
+
+	/* Side Band Flow Director needs to have a control VSI.
+	 * Allocate it and store it in the PF.
+	 */
+	ctrl_vsi = ice_ctrl_vsi_setup(pf, pf->hw.port_info);
+	if (!ctrl_vsi) {
+		dev_dbg(dev, "could not create control VSI\n");
+		return -ENOMEM;
+	}
+
+	err = ice_vsi_open_ctrl(ctrl_vsi);
+	if (err) {
+		dev_dbg(dev, "could not open control VSI\n");
+		goto err_vsi_open;
+	}
+
+	mutex_init(&pf->hw.fdir_fltr_lock);
+
+	err = ice_fdir_create_dflt_rules(pf);
+	if (err)
+		goto err_fdir_rule;
+
+	return 0;
+
+err_fdir_rule:
+	ice_fdir_release_flows(&pf->hw);
+	ice_vsi_close(ctrl_vsi);
+err_vsi_open:
+	ice_vsi_release(ctrl_vsi);
+	if (pf->ctrl_vsi_idx != ICE_NO_VSI) {
+		pf->vsi[pf->ctrl_vsi_idx] = NULL;
+		pf->ctrl_vsi_idx = ICE_NO_VSI;
+	}
+	return err;
+}
+
 /**
  * ice_get_opt_fw_name - return optional firmware file name or NULL
  * @pf: pointer to the PF instance
@@ -3362,6 +3452,10 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
 	/* initialize DDP driven features */
 
+	/* Note: Flow director init failure is non-fatal to load */
+	if (ice_init_fdir(pf))
+		dev_err(dev, "could not initialize flow director\n");
+
 	/* Note: DCB init failure is non-fatal to load */
 	if (ice_init_pf_dcb(pf, false)) {
 		clear_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
@@ -3424,6 +3518,7 @@ static void ice_remove(struct pci_dev *pdev)
 	set_bit(__ICE_DOWN, pf->state);
 	ice_service_task_stop(pf);
 
+	mutex_destroy(&(&pf->hw)->fdir_fltr_lock);
 	ice_devlink_destroy_port(pf);
 	ice_vsi_release_all(pf);
 	ice_free_irq_msix_misc(pf);
@@ -3940,6 +4035,13 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 		 (netdev->features & NETIF_F_HW_VLAN_CTAG_FILTER))
 		ret = ice_cfg_vlan_pruning(vsi, false, false);
 
+	if ((features & NETIF_F_NTUPLE) &&
+	    !(netdev->features & NETIF_F_NTUPLE))
+		ice_vsi_manage_fdir(vsi, true);
+	else if (!(features & NETIF_F_NTUPLE) &&
+		 (netdev->features & NETIF_F_NTUPLE))
+		ice_vsi_manage_fdir(vsi, false);
+
 	return ret;
 }
 
@@ -4494,6 +4596,62 @@ int ice_vsi_setup_rx_rings(struct ice_vsi *vsi)
 	return err;
 }
 
+/**
+ * ice_vsi_open_ctrl - open control VSI for use
+ * @vsi: the VSI to open
+ *
+ * Initialization of the Control VSI
+ *
+ * Returns 0 on success, negative value on error
+ */
+int ice_vsi_open_ctrl(struct ice_vsi *vsi)
+{
+	char int_name[ICE_INT_NAME_STR_LEN];
+	struct ice_pf *pf = vsi->back;
+	struct device *dev;
+	int err;
+
+	dev = ice_pf_to_dev(pf);
+	/* allocate descriptors */
+	err = ice_vsi_setup_tx_rings(vsi);
+	if (err)
+		goto err_setup_tx;
+
+	err = ice_vsi_setup_rx_rings(vsi);
+	if (err)
+		goto err_setup_rx;
+
+	err = ice_vsi_cfg(vsi);
+	if (err)
+		goto err_setup_rx;
+
+	snprintf(int_name, sizeof(int_name) - 1, "%s-%s:ctrl",
+		 dev_driver_string(dev), dev_name(dev));
+	err = ice_vsi_req_irq_msix(vsi, int_name);
+	if (err)
+		goto err_setup_rx;
+
+	ice_vsi_cfg_msix(vsi);
+
+	err = ice_vsi_start_all_rx_rings(vsi);
+	if (err)
+		goto err_up_complete;
+
+	clear_bit(__ICE_DOWN, vsi->state);
+	ice_vsi_ena_irq(vsi);
+
+	return 0;
+
+err_up_complete:
+	ice_down(vsi);
+err_setup_rx:
+	ice_vsi_free_rx_rings(vsi);
+err_setup_tx:
+	ice_vsi_free_tx_rings(vsi);
+
+	return err;
+}
+
 /**
  * ice_vsi_open - Called when a network interface is made active
  * @vsi: the VSI to open
diff --git a/drivers/net/ethernet/intel/ice/ice_protocol_type.h b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
index 678db6bf7f57..babe4a485fd6 100644
--- a/drivers/net/ethernet/intel/ice/ice_protocol_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
@@ -17,6 +17,7 @@ enum ice_prot_id {
 	ICE_PROT_IPV6_OF_OR_S	= 40,
 	ICE_PROT_IPV6_IL	= 41,
 	ICE_PROT_TCP_IL		= 49,
+	ICE_PROT_UDP_OF		= 52,
 	ICE_PROT_UDP_IL_OR_S	= 53,
 	ICE_PROT_GRE_OF		= 64,
 	ICE_PROT_SCTP_IL	= 96,
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 7d88944de31a..0156b73df1b1 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -2677,6 +2677,81 @@ void ice_remove_vsi_fltr(struct ice_hw *hw, u16 vsi_handle)
 	ice_remove_vsi_lkup_fltr(hw, vsi_handle, ICE_SW_LKUP_PROMISC_VLAN);
 }
 
+/**
+ * ice_alloc_res_cntr - allocating resource counter
+ * @hw: pointer to the hardware structure
+ * @type: type of resource
+ * @alloc_shared: if set it is shared else dedicated
+ * @num_items: number of entries requested for FD resource type
+ * @counter_id: counter index returned by AQ call
+ */
+enum ice_status
+ice_alloc_res_cntr(struct ice_hw *hw, u8 type, u8 alloc_shared, u16 num_items,
+		   u16 *counter_id)
+{
+	struct ice_aqc_alloc_free_res_elem *buf;
+	enum ice_status status;
+	u16 buf_len;
+
+	/* Allocate resource */
+	buf_len = sizeof(*buf);
+	buf = kzalloc(buf_len, GFP_KERNEL);
+	if (!buf)
+		return ICE_ERR_NO_MEMORY;
+
+	buf->num_elems = cpu_to_le16(num_items);
+	buf->res_type = cpu_to_le16(((type << ICE_AQC_RES_TYPE_S) &
+				      ICE_AQC_RES_TYPE_M) | alloc_shared);
+
+	status = ice_aq_alloc_free_res(hw, 1, buf, buf_len,
+				       ice_aqc_opc_alloc_res, NULL);
+	if (status)
+		goto exit;
+
+	*counter_id = le16_to_cpu(buf->elem[0].e.sw_resp);
+
+exit:
+	kfree(buf);
+	return status;
+}
+
+/**
+ * ice_free_res_cntr - free resource counter
+ * @hw: pointer to the hardware structure
+ * @type: type of resource
+ * @alloc_shared: if set it is shared else dedicated
+ * @num_items: number of entries to be freed for FD resource type
+ * @counter_id: counter ID resource which needs to be freed
+ */
+enum ice_status
+ice_free_res_cntr(struct ice_hw *hw, u8 type, u8 alloc_shared, u16 num_items,
+		  u16 counter_id)
+{
+	struct ice_aqc_alloc_free_res_elem *buf;
+	enum ice_status status;
+	u16 buf_len;
+
+	/* Free resource */
+	buf_len = sizeof(*buf);
+	buf = kzalloc(buf_len, GFP_KERNEL);
+	if (!buf)
+		return ICE_ERR_NO_MEMORY;
+
+	buf->num_elems = cpu_to_le16(num_items);
+	buf->res_type = cpu_to_le16(((type << ICE_AQC_RES_TYPE_S) &
+				      ICE_AQC_RES_TYPE_M) | alloc_shared);
+	buf->elem[0].e.sw_resp = cpu_to_le16(counter_id);
+
+	status = ice_aq_alloc_free_res(hw, 1, buf, buf_len,
+				       ice_aqc_opc_free_res, NULL);
+	if (status)
+		ice_debug(hw, ICE_DBG_SW,
+			  "counter resource could not be freed\n");
+
+	kfree(buf);
+	return status;
+}
+
 /**
  * ice_replay_vsi_fltr - Replay filters for requested VSI
  * @hw: pointer to the hardware structure
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.h b/drivers/net/ethernet/intel/ice/ice_switch.h
index fa14b9545dab..8b4f9d35c860 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.h
+++ b/drivers/net/ethernet/intel/ice/ice_switch.h
@@ -208,6 +208,13 @@ void ice_clear_all_vsi_ctx(struct ice_hw *hw);
 /* Switch config */
 enum ice_status ice_get_initial_sw_cfg(struct ice_hw *hw);
 
+enum ice_status
+ice_alloc_res_cntr(struct ice_hw *hw, u8 type, u8 alloc_shared, u16 num_items,
+		   u16 *counter_id);
+enum ice_status
+ice_free_res_cntr(struct ice_hw *hw, u8 type, u8 alloc_shared, u16 num_items,
+		  u16 counter_id);
+
 /* Switch/bridge related commands */
 enum ice_status ice_update_sw_rule_bridge_mode(struct ice_hw *hw);
 enum ice_status ice_add_mac(struct ice_hw *hw, struct list_head *m_lst);
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 0d90e32efab9..173a167c96d9 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -15,6 +15,8 @@
 
 #define ICE_RX_HDR_SIZE		256
 
+#define FDIR_DESC_RXDID 0x40
+
 /**
  * ice_unmap_and_free_tx_buf - Release a Tx buffer
  * @ring: the ring that owns the buffer
@@ -24,7 +26,9 @@ static void
 ice_unmap_and_free_tx_buf(struct ice_ring *ring, struct ice_tx_buf *tx_buf)
 {
 	if (tx_buf->skb) {
-		if (ice_ring_is_xdp(ring))
+		if (tx_buf->tx_flags & ICE_TX_FLAGS_DUMMY_PKT)
+			devm_kfree(ring->dev, tx_buf->raw_buf);
+		else if (ice_ring_is_xdp(ring))
 			page_frag_free(tx_buf->raw_buf);
 		else
 			dev_kfree_skb_any(tx_buf->skb);
@@ -599,7 +603,8 @@ bool ice_alloc_rx_bufs(struct ice_ring *rx_ring, u16 cleaned_count)
 	struct ice_rx_buf *bi;
 
 	/* do nothing if no valid netdev defined */
-	if (!rx_ring->netdev || !cleaned_count)
+	if ((!rx_ring->netdev && rx_ring->vsi->type != ICE_VSI_CTRL) ||
+	    !cleaned_count)
 		return false;
 
 	/* get the Rx descriptor and buffer based on next_to_use */
@@ -997,7 +1002,7 @@ ice_is_non_eop(struct ice_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc,
  *
  * Returns amount of work completed
  */
-static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
+int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 {
 	unsigned int total_rx_bytes = 0, total_rx_pkts = 0;
 	u16 cleaned_count = ICE_DESC_UNUSED(rx_ring);
@@ -1040,6 +1045,12 @@ static int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		 */
 		dma_rmb();
 
+		if (rx_desc->wb.rxdid == FDIR_DESC_RXDID || !rx_ring->netdev) {
+			ice_put_rx_buf(rx_ring, NULL);
+			cleaned_count++;
+			continue;
+		}
+
 		size = le16_to_cpu(rx_desc->wb.pkt_len) &
 			ICE_RX_FLX_DESC_PKT_LEN_M;
 
@@ -2378,3 +2389,86 @@ netdev_tx_t ice_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	return ice_xmit_frame_ring(skb, tx_ring);
 }
+
+/**
+ * ice_clean_ctrl_tx_irq - interrupt handler for flow director Tx queue
+ * @tx_ring: tx_ring to clean
+ */
+void ice_clean_ctrl_tx_irq(struct ice_ring *tx_ring)
+{
+	struct ice_vsi *vsi = tx_ring->vsi;
+	s16 i = tx_ring->next_to_clean;
+	int budget = ICE_DFLT_IRQ_WORK;
+	struct ice_tx_desc *tx_desc;
+	struct ice_tx_buf *tx_buf;
+
+	tx_buf = &tx_ring->tx_buf[i];
+	tx_desc = ICE_TX_DESC(tx_ring, i);
+	i -= tx_ring->count;
+
+	do {
+		struct ice_tx_desc *eop_desc = tx_buf->next_to_watch;
+
+		/* if next_to_watch is not set then there is no pending work */
+		if (!eop_desc)
+			break;
+
+		/* prevent any other reads prior to eop_desc */
+		smp_rmb();
+
+		/* if the descriptor isn't done, no work to do */
+		if (!(eop_desc->cmd_type_offset_bsz &
+		      cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE)))
+			break;
+
+		/* clear next_to_watch to prevent false hangs */
+		tx_buf->next_to_watch = NULL;
+		tx_desc->buf_addr = 0;
+		tx_desc->cmd_type_offset_bsz = 0;
+
+		/* move past filter desc */
+		tx_buf++;
+		tx_desc++;
+		i++;
+		if (unlikely(!i)) {
+			i -= tx_ring->count;
+			tx_buf = tx_ring->tx_buf;
+			tx_desc = ICE_TX_DESC(tx_ring, 0);
+		}
+
+		/* unmap the data header */
+		if (dma_unmap_len(tx_buf, len))
+			dma_unmap_single(tx_ring->dev,
+					 dma_unmap_addr(tx_buf, dma),
+					 dma_unmap_len(tx_buf, len),
+					 DMA_TO_DEVICE);
+		if (tx_buf->tx_flags & ICE_TX_FLAGS_DUMMY_PKT)
+			devm_kfree(tx_ring->dev, tx_buf->raw_buf);
+
+		/* clear next_to_watch to prevent false hangs */
+		tx_buf->raw_buf = NULL;
+		tx_buf->tx_flags = 0;
+		tx_buf->next_to_watch = NULL;
+		dma_unmap_len_set(tx_buf, len, 0);
+		tx_desc->buf_addr = 0;
+		tx_desc->cmd_type_offset_bsz = 0;
+
+		/* move past eop_desc for start of next FD desc */
+		tx_buf++;
+		tx_desc++;
+		i++;
+		if (unlikely(!i)) {
+			i -= tx_ring->count;
+			tx_buf = tx_ring->tx_buf;
+			tx_desc = ICE_TX_DESC(tx_ring, 0);
+		}
+
+		budget--;
+	} while (likely(budget));
+
+	i += tx_ring->count;
+	tx_ring->next_to_clean = i;
+
+	/* re-enable interrupt if needed */
+	ice_irq_dynamic_ena(&vsi->back->hw, vsi, vsi->q_vectors[0]);
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 025dd642cf28..2209583c993e 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -113,6 +113,10 @@ static inline int ice_skb_pad(void)
 #define ICE_TX_FLAGS_TSO	BIT(0)
 #define ICE_TX_FLAGS_HW_VLAN	BIT(1)
 #define ICE_TX_FLAGS_SW_VLAN	BIT(2)
+/* ICE_TX_FLAGS_DUMMY_PKT is used to mark dummy packets that should be
+ * freed instead of returned like skb packets.
+ */
+#define ICE_TX_FLAGS_DUMMY_PKT	BIT(3)
 #define ICE_TX_FLAGS_IPV4	BIT(5)
 #define ICE_TX_FLAGS_IPV6	BIT(6)
 #define ICE_TX_FLAGS_TUNNEL	BIT(7)
@@ -376,5 +380,6 @@ int ice_setup_rx_ring(struct ice_ring *rx_ring);
 void ice_free_tx_ring(struct ice_ring *tx_ring);
 void ice_free_rx_ring(struct ice_ring *rx_ring);
 int ice_napi_poll(struct napi_struct *napi, int budget);
-
+int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget);
+void ice_clean_ctrl_tx_irq(struct ice_ring *tx_ring);
 #endif /* _ICE_TXRX_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 9f6578eb4672..74bdc00e869c 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -118,7 +118,8 @@ enum ice_media_type {
 
 enum ice_vsi_type {
 	ICE_VSI_PF = 0,
-	ICE_VSI_VF,
+	ICE_VSI_VF = 1,
+	ICE_VSI_CTRL = 3,	/* equates to ICE_VSI_PF with 1 queue pair */
 	ICE_VSI_LB = 6,
 };
 
@@ -161,6 +162,34 @@ struct ice_phy_info {
 	u8 get_link_info;
 };
 
+/* protocol enumeration for filters */
+enum ice_fltr_ptype {
+	/* NONE - used for undef/error */
+	ICE_FLTR_PTYPE_NONF_NONE = 0,
+	ICE_FLTR_PTYPE_NONF_IPV4_UDP,
+	ICE_FLTR_PTYPE_NONF_IPV4_TCP,
+	ICE_FLTR_PTYPE_NONF_IPV4_SCTP,
+	ICE_FLTR_PTYPE_NONF_IPV4_OTHER,
+	ICE_FLTR_PTYPE_FRAG_IPV4,
+	ICE_FLTR_PTYPE_MAX,
+};
+
+enum ice_fd_hw_seg {
+	ICE_FD_HW_SEG_NON_TUN = 0,
+	ICE_FD_HW_SEG_TUN,
+	ICE_FD_HW_SEG_MAX,
+};
+
+/* 2 VSI = 1 ICE_VSI_PF + 1 ICE_VSI_CTRL */
+#define ICE_MAX_FDIR_VSI_PER_FILTER	2
+
+struct ice_fd_hw_prof {
+	struct ice_flow_seg_info *fdir_seg[ICE_FD_HW_SEG_MAX];
+	int cnt;
+	u64 entry_h[ICE_MAX_FDIR_VSI_PER_FILTER][ICE_FD_HW_SEG_MAX];
+	u16 vsi_h[ICE_MAX_FDIR_VSI_PER_FILTER];
+};
+
 /* Common HW capabilities for SW use */
 struct ice_hw_common_caps {
 	u32 valid_functions;
@@ -197,6 +226,8 @@ struct ice_hw_func_caps {
 	u32 num_allocd_vfs;		/* Number of allocated VFs */
 	u32 vf_base_id;			/* Logical ID of the first VF */
 	u32 guar_num_vsi;
+	u32 fd_fltr_guar;		/* Number of filters guaranteed */
+	u32 fd_fltr_best_effort;	/* Number of best effort filters */
 };
 
 /* Device wide capabilities */
@@ -204,6 +235,7 @@ struct ice_hw_dev_caps {
 	struct ice_hw_common_caps common_cap;
 	u32 num_vfs_exposed;		/* Total number of VFs exposed */
 	u32 num_vsi_allocd_to_host;	/* Excluding EMP VSI */
+	u32 num_flow_director_fltr;	/* Number of FD filters available */
 	u32 num_funcs;
 };
 
@@ -489,6 +521,8 @@ struct ice_hw {
 	u64 debug_mask;		/* bitmap for debug mask */
 	enum ice_mac_type mac_type;
 
+	u16 fd_ctr_base;	/* FD counter base index */
+
 	/* pci info */
 	u16 device_id;
 	u16 vendor_id;
@@ -587,6 +621,15 @@ struct ice_hw {
 	struct ice_blk_info blk[ICE_BLK_COUNT];
 	struct mutex fl_profs_locks[ICE_BLK_COUNT];	/* lock fltr profiles */
 	struct list_head fl_profs[ICE_BLK_COUNT];
+
+	/* Flow Director filter info */
+	int fdir_active_fltr;
+
+	struct mutex fdir_fltr_lock;	/* protect Flow Director */
+	struct list_head fdir_list_head;
+
+	struct ice_fd_hw_prof **fdir_prof;
+	DECLARE_BITMAP(fdir_perfect_fltr, ICE_FLTR_PTYPE_MAX);
 	struct mutex rss_locks;	/* protect RSS configuration */
 	struct list_head rss_list_head;
 };
-- 
2.26.2

