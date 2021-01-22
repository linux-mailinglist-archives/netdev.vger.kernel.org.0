Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61EB830112B
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 00:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbhAVXvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 18:51:49 -0500
Received: from mga05.intel.com ([192.55.52.43]:55261 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbhAVXus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 18:50:48 -0500
IronPort-SDR: 7We0hC4DNQts4+nXDFJ2JGJ4OFkr+ydvk82np2Mc31hzjAEUXsY5+IGDFfN10B0Ztvz6Gjz5uI
 IFvL01O8+WbA==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="264346852"
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="264346852"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 15:50:07 -0800
IronPort-SDR: zcUXpdp8pAh7fetOD9z9jh7DbzOLYq6yUaGTqoMLEPFspWNA1jZuucBClP9CqTDCQeH/WTcf5Z
 +596DHZF4uQw==
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="574869400"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.251.4.95])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 15:50:05 -0800
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, david.m.ertman@intel.com,
        anthony.l.nguyen@intel.com
Subject: [PATCH 02/22] ice: Initialize RDMA support
Date:   Fri, 22 Jan 2021 17:48:07 -0600
Message-Id: <20210122234827.1353-3-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210122234827.1353-1-shiraz.saleem@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

Probe the device's capabilities to see if it supports RDMA. If so, allocate
and reserve resources to support its operation; populate structures with
initial values.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/Makefile         |   1 +
 drivers/net/ethernet/intel/ice/ice.h            |  15 +
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h |   1 +
 drivers/net/ethernet/intel/ice/ice_common.c     |  17 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c    |  37 ++
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h    |   3 +
 drivers/net/ethernet/intel/ice/ice_idc.c        | 437 ++++++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_idc_int.h    |  54 +++
 drivers/net/ethernet/intel/ice/ice_lib.c        |  11 +
 drivers/net/ethernet/intel/ice/ice_lib.h        |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c       |  61 +++-
 drivers/net/ethernet/intel/ice/ice_type.h       |   1 +
 12 files changed, 637 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc_int.h

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 6da4f43..650000b 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -22,6 +22,7 @@ ice-y := ice_main.o	\
 	 ice_ethtool_fdir.o \
 	 ice_flex_pipe.o \
 	 ice_flow.o	\
+	 ice_idc.o	\
 	 ice_devlink.o	\
 	 ice_fw_update.o \
 	 ice_ethtool.o
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 5672535..22c2ed1 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -50,6 +50,7 @@
 #include "ice_switch.h"
 #include "ice_common.h"
 #include "ice_sched.h"
+#include "ice_idc_int.h"
 #include "ice_virtchnl_pf.h"
 #include "ice_sriov.h"
 #include "ice_fdir.h"
@@ -70,6 +71,7 @@
 #define ICE_MBXSQ_LEN		64
 #define ICE_MIN_MSIX		2
 #define ICE_FDIR_MSIX		1
+#define ICE_RDMA_NUM_AEQ_MSIX	4
 #define ICE_NO_VSI		0xffff
 #define ICE_VSI_MAP_CONTIG	0
 #define ICE_VSI_MAP_SCATTER	1
@@ -80,6 +82,7 @@
 #define ICE_MAX_LG_RSS_QS	256
 #define ICE_RES_VALID_BIT	0x8000
 #define ICE_RES_MISC_VEC_ID	(ICE_RES_VALID_BIT - 1)
+#define ICE_RES_RDMA_VEC_ID	(ICE_RES_MISC_VEC_ID - 1)
 #define ICE_INVAL_Q_INDEX	0xffff
 #define ICE_INVAL_VFID		256
 
@@ -356,12 +359,14 @@ struct ice_q_vector {
 
 enum ice_pf_flags {
 	ICE_FLAG_FLTR_SYNC,
+	ICE_FLAG_IWARP_ENA,
 	ICE_FLAG_RSS_ENA,
 	ICE_FLAG_SRIOV_ENA,
 	ICE_FLAG_SRIOV_CAPABLE,
 	ICE_FLAG_DCB_CAPABLE,
 	ICE_FLAG_DCB_ENA,
 	ICE_FLAG_FD_ENA,
+	ICE_FLAG_PEER_ENA,
 	ICE_FLAG_ADV_FEATURES,
 	ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA,
 	ICE_FLAG_TOTAL_PORT_SHUTDOWN_ENA,
@@ -414,6 +419,9 @@ struct ice_pf {
 	struct mutex sw_mutex;		/* lock for protecting VSI alloc flow */
 	struct mutex tc_mutex;		/* lock to protect TC changes */
 	u32 msg_enable;
+	u16 num_rdma_msix;		/* Total MSIX vectors for RDMA driver */
+	u16 rdma_base_vector;
+	struct iidc_peer_obj *rdma_peer;
 
 	/* spinlock to protect the AdminQ wait list */
 	spinlock_t aq_wait_lock;
@@ -448,6 +456,7 @@ struct ice_pf {
 	unsigned long tx_timeout_last_recovery;
 	u32 tx_timeout_recovery_level;
 	char int_name[ICE_INT_NAME_STR_LEN];
+	struct ice_peer_obj_int **peers;
 	u32 sw_int_count;
 
 	__le64 nvm_phy_type_lo; /* NVM PHY type low */
@@ -584,6 +593,12 @@ static inline struct ice_vsi *ice_get_ctrl_vsi(struct ice_pf *pf)
 void ice_fill_rss_lut(u8 *lut, u16 rss_table_size, u16 rss_size);
 int ice_schedule_reset(struct ice_pf *pf, enum ice_reset_req reset);
 void ice_print_link_msg(struct ice_vsi *vsi, bool isup);
+int ice_init_peer_devices(struct ice_pf *pf);
+void ice_uninit_peer_devices(struct ice_pf *pf);
+int
+ice_for_each_peer(struct ice_pf *pf, void *data,
+		  int (*fn)(struct ice_peer_obj_int *, void *));
+void ice_peer_refresh_msix(struct ice_pf *pf);
 const char *ice_stat_str(enum ice_status stat_err);
 const char *ice_aq_str(enum ice_aq_err aq_err);
 bool ice_is_wol_supported(struct ice_pf *pf);
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index b06fbe9..b7c1637 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -115,6 +115,7 @@ struct ice_aqc_list_caps_elem {
 #define ICE_AQC_CAPS_PENDING_OROM_VER			0x004B
 #define ICE_AQC_CAPS_NET_VER				0x004C
 #define ICE_AQC_CAPS_PENDING_NET_VER			0x004D
+#define ICE_AQC_CAPS_IWARP				0x0051
 #define ICE_AQC_CAPS_NVM_MGMT				0x0080
 
 	u8 major_ver;
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 6d7e7dd..ff68d25 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1056,7 +1056,8 @@ enum ice_status ice_check_reset(struct ice_hw *hw)
 				 GLNVM_ULD_POR_DONE_1_M |\
 				 GLNVM_ULD_PCIER_DONE_2_M)
 
-	uld_mask = ICE_RESET_DONE_MASK;
+	uld_mask = ICE_RESET_DONE_MASK | (hw->func_caps.common_cap.iwarp ?
+					  GLNVM_ULD_PE_DONE_M : 0);
 
 	/* Device is Active; check Global Reset processes are done */
 	for (cnt = 0; cnt < ICE_PF_RESET_WAIT_COUNT; cnt++) {
@@ -1853,6 +1854,10 @@ static u32 ice_get_num_per_func(struct ice_hw *hw, u32 max)
 		ice_debug(hw, ICE_DBG_INIT, "%s: nvm_unified_update = %d\n", prefix,
 			  caps->nvm_unified_update);
 		break;
+	case ICE_AQC_CAPS_IWARP:
+		caps->iwarp = (number == 1);
+		ice_debug(hw, ICE_DBG_INIT, "%s: iwarp = %d\n", prefix, caps->iwarp);
+		break;
 	case ICE_AQC_CAPS_MAX_MTU:
 		caps->max_mtu = number;
 		ice_debug(hw, ICE_DBG_INIT, "%s: max_mtu = %d\n",
@@ -1886,6 +1891,16 @@ static u32 ice_get_num_per_func(struct ice_hw *hw, u32 max)
 		caps->maxtc = 4;
 		ice_debug(hw, ICE_DBG_INIT, "reducing maxtc to %d (based on #ports)\n",
 			  caps->maxtc);
+		if (caps->iwarp) {
+			ice_debug(hw, ICE_DBG_INIT, "forcing RDMA off\n");
+			caps->iwarp = 0;
+		}
+
+		/* print message only when processing device capabilities
+		 * during initialization.
+		 */
+		if (caps == &hw->dev_caps.common_cap)
+			dev_info(ice_hw_to_dev(hw), "RDMA functionality is not available with the current device configuration.\n");
 	}
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 36abd6b..00e8741 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -674,6 +674,12 @@ void ice_pf_dcb_recfg(struct ice_pf *pf)
 		if (vsi->type == ICE_VSI_PF)
 			ice_dcbnl_set_all(vsi);
 	}
+	/* If the RDMA peer is registered, update that peer's initial_qos_info struct.
+	 * The peer is closed during this process, so when it is opened, it will access
+	 * the initial_qos_info element to configure itself.
+	 */
+	if (pf->rdma_peer)
+		ice_setup_dcb_qos_info(pf, &pf->rdma_peer->initial_qos_info);
 }
 
 /**
@@ -815,6 +821,37 @@ void ice_update_dcb_stats(struct ice_pf *pf)
 }
 
 /**
+ * ice_setup_dcb_qos_info - Setup DCB QoS information
+ * @pf: ptr to ice_pf
+ * @qos_info: QoS param instance
+ */
+void ice_setup_dcb_qos_info(struct ice_pf *pf, struct iidc_qos_params *qos_info)
+{
+	struct ice_dcbx_cfg *dcbx_cfg;
+	unsigned int i;
+	u32 up2tc;
+
+	dcbx_cfg = &pf->hw.port_info->local_dcbx_cfg;
+	up2tc = rd32(&pf->hw, PRTDCB_TUP2TC);
+	qos_info->num_apps = dcbx_cfg->numapps;
+
+	qos_info->num_tc = ice_dcb_get_num_tc(dcbx_cfg);
+
+	for (i = 0; i < IIDC_MAX_USER_PRIORITY; i++)
+		qos_info->up2tc[i] = (up2tc >> (i * 3)) & 0x7;
+
+	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++)
+		qos_info->tc_info[i].rel_bw =
+			dcbx_cfg->etscfg.tcbwtable[i];
+
+	for (i = 0; i < qos_info->num_apps; i++) {
+		qos_info->apps[i].priority = dcbx_cfg->app[i].priority;
+		qos_info->apps[i].prot_id = dcbx_cfg->app[i].prot_id;
+		qos_info->apps[i].selector = dcbx_cfg->app[i].selector;
+	}
+}
+
+/**
  * ice_dcb_process_lldp_set_mib_change - Process MIB change
  * @pf: ptr to ice_pf
  * @event: pointer to the admin queue receive event
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
index 35c21d9..b41c7ba 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
@@ -31,6 +31,8 @@
 ice_tx_prepare_vlan_flags_dcb(struct ice_ring *tx_ring,
 			      struct ice_tx_buf *first);
 void
+ice_setup_dcb_qos_info(struct ice_pf *pf, struct iidc_qos_params *qos_info);
+void
 ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 				    struct ice_rq_event_info *event);
 void ice_vsi_cfg_netdev_tc(struct ice_vsi *vsi, u8 ena_tc);
@@ -116,6 +118,7 @@ static inline bool ice_is_dcb_active(struct ice_pf __always_unused *pf)
 #define ice_update_dcb_stats(pf) do {} while (0)
 #define ice_pf_dcb_recfg(pf) do {} while (0)
 #define ice_vsi_cfg_dcb_rings(vsi) do {} while (0)
+#define ice_setup_dcb_qos_info(pf, qos_info) do {} while (0)
 #define ice_dcb_process_lldp_set_mib_change(pf, event) do {} while (0)
 #define ice_set_cgd_num(tlan_ctx, ring) do {} while (0)
 #define ice_vsi_cfg_netdev_tc(vsi, ena_tc) do {} while (0)
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
new file mode 100644
index 0000000..aec0951
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -0,0 +1,437 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2018-2021, Intel Corporation. */
+
+/* Inter-Driver Communication */
+#include "ice.h"
+#include "ice_lib.h"
+#include "ice_dcb_lib.h"
+
+static struct peer_obj_id ice_peers[] = ASSIGN_PEER_INFO;
+
+/**
+ * ice_peer_state_change - manage state machine for peer
+ * @peer_obj: pointer to peer's configuration
+ * @new_state: the state requested to transition into
+ * @locked: boolean to determine if call made with mutex held
+ *
+ * Any function that calls this is responsible for verifying that
+ * the peer_obj_int struct is valid and capable of handling a state change.
+ *
+ * This function handles all state transitions for peer objects.
+ *
+ * The state machine is as follows:
+ *
+ *     +<-----------------------+<-----------------------------+
+ *				|<-------+<----------+	       +
+ *				\/	 +	     +	       +
+ *    INIT  --------------> PROBED --> OPENING	  CLOSED --> REMOVED
+ *					 +           +
+ *				       OPENED --> CLOSING
+ *					 +	     +
+ *				       PREP_RST	     +
+ *					 +	     +
+ *				      PREPPED	     +
+ *					 +---------->+
+ *
+ * NOTE: there is an error condition that can take a peer from OPENING
+ * to REMOVED.
+ */
+static void
+ice_peer_state_change(struct ice_peer_obj_int *peer_obj, long new_state,
+		      bool locked)
+{
+	struct iidc_peer_obj *peer = ice_get_peer_obj(peer_obj);
+	struct device *dev = NULL;
+
+	if (peer && peer->adev)
+		dev = &peer->adev->dev;
+
+	if (!locked)
+		mutex_lock(&peer_obj->peer_obj_state_mutex);
+
+	switch (new_state) {
+	case ICE_PEER_OBJ_STATE_INIT:
+		if (test_and_clear_bit(ICE_PEER_OBJ_STATE_REMOVED,
+				       peer_obj->state)) {
+			set_bit(ICE_PEER_OBJ_STATE_INIT, peer_obj->state);
+			dev_dbg(dev, "state transition from _REMOVED to _INIT\n");
+		} else {
+			set_bit(ICE_PEER_OBJ_STATE_INIT, peer_obj->state);
+			if (dev)
+				dev_dbg(dev, "state set to _INIT\n");
+		}
+		break;
+	case ICE_PEER_OBJ_STATE_PROBED:
+		if (test_and_clear_bit(ICE_PEER_OBJ_STATE_INIT,
+				       peer_obj->state)) {
+			set_bit(ICE_PEER_OBJ_STATE_PROBED, peer_obj->state);
+			dev_dbg(dev, "state transition from _INIT to _PROBED\n");
+		} else if (test_and_clear_bit(ICE_PEER_OBJ_STATE_REMOVED,
+					      peer_obj->state)) {
+			set_bit(ICE_PEER_OBJ_STATE_PROBED, peer_obj->state);
+			dev_dbg(dev, "state transition from _REMOVED to _PROBED\n");
+		} else if (test_and_clear_bit(ICE_PEER_OBJ_STATE_OPENING,
+					      peer_obj->state)) {
+			set_bit(ICE_PEER_OBJ_STATE_PROBED, peer_obj->state);
+			dev_dbg(dev, "state transition from _OPENING to _PROBED\n");
+		}
+		break;
+	case ICE_PEER_OBJ_STATE_OPENING:
+		if (test_and_clear_bit(ICE_PEER_OBJ_STATE_PROBED,
+				       peer_obj->state)) {
+			set_bit(ICE_PEER_OBJ_STATE_OPENING, peer_obj->state);
+			dev_dbg(dev, "state transition from _PROBED to _OPENING\n");
+		} else if (test_and_clear_bit(ICE_PEER_OBJ_STATE_CLOSED,
+					      peer_obj->state)) {
+			set_bit(ICE_PEER_OBJ_STATE_OPENING, peer_obj->state);
+			dev_dbg(dev, "state transition from _CLOSED to _OPENING\n");
+		}
+		break;
+	case ICE_PEER_OBJ_STATE_OPENED:
+		if (test_and_clear_bit(ICE_PEER_OBJ_STATE_OPENING,
+				       peer_obj->state)) {
+			set_bit(ICE_PEER_OBJ_STATE_OPENED, peer_obj->state);
+			dev_dbg(dev, "state transition from _OPENING to _OPENED\n");
+		}
+		break;
+	case ICE_PEER_OBJ_STATE_PREP_RST:
+		if (test_and_clear_bit(ICE_PEER_OBJ_STATE_OPENED,
+				       peer_obj->state)) {
+			set_bit(ICE_PEER_OBJ_STATE_PREP_RST, peer_obj->state);
+			dev_dbg(dev, "state transition from _OPENED to _PREP_RST\n");
+		}
+		break;
+	case ICE_PEER_OBJ_STATE_PREPPED:
+		if (test_and_clear_bit(ICE_PEER_OBJ_STATE_PREP_RST,
+				       peer_obj->state)) {
+			set_bit(ICE_PEER_OBJ_STATE_PREPPED, peer_obj->state);
+			dev_dbg(dev, "state transition _PREP_RST to _PREPPED\n");
+		}
+		break;
+	case ICE_PEER_OBJ_STATE_CLOSING:
+		if (test_and_clear_bit(ICE_PEER_OBJ_STATE_OPENED,
+				       peer_obj->state)) {
+			set_bit(ICE_PEER_OBJ_STATE_CLOSING, peer_obj->state);
+			dev_dbg(dev, "state transition from _OPENED to _CLOSING\n");
+		}
+		if (test_and_clear_bit(ICE_PEER_OBJ_STATE_PREPPED,
+				       peer_obj->state)) {
+			set_bit(ICE_PEER_OBJ_STATE_CLOSING, peer_obj->state);
+			dev_dbg(dev, "state transition _PREPPED to _CLOSING\n");
+		}
+		/* NOTE - up to peer to handle this situation correctly */
+		if (test_and_clear_bit(ICE_PEER_OBJ_STATE_PREP_RST,
+				       peer_obj->state)) {
+			set_bit(ICE_PEER_OBJ_STATE_CLOSING, peer_obj->state);
+			dev_warn(dev, "Peer state _PREP_RST to _CLOSING\n");
+		}
+		break;
+	case ICE_PEER_OBJ_STATE_CLOSED:
+		if (test_and_clear_bit(ICE_PEER_OBJ_STATE_CLOSING,
+				       peer_obj->state)) {
+			set_bit(ICE_PEER_OBJ_STATE_CLOSED, peer_obj->state);
+			dev_dbg(dev, "state transition from _CLOSING to _CLOSED\n");
+		}
+		break;
+	case ICE_PEER_OBJ_STATE_REMOVED:
+		if (test_and_clear_bit(ICE_PEER_OBJ_STATE_OPENED,
+				       peer_obj->state) ||
+		    test_and_clear_bit(ICE_PEER_OBJ_STATE_CLOSED,
+				       peer_obj->state)) {
+			set_bit(ICE_PEER_OBJ_STATE_REMOVED, peer_obj->state);
+			dev_dbg(dev, "state from _OPENED/_CLOSED to _REMOVED\n");
+		}
+		if (test_and_clear_bit(ICE_PEER_OBJ_STATE_OPENING,
+				       peer_obj->state)) {
+			set_bit(ICE_PEER_OBJ_STATE_REMOVED, peer_obj->state);
+			dev_warn(dev, "Peer failed to open, set to _REMOVED");
+		}
+		break;
+	default:
+		break;
+	}
+
+	if (!locked)
+		mutex_unlock(&peer_obj->peer_obj_state_mutex);
+}
+
+/**
+ * ice_for_each_peer - iterate across and call function for each peer obj
+ * @pf: pointer to private board struct
+ * @data: data to pass to function on each call
+ * @fn: pointer to function to call for each peer
+ */
+int
+ice_for_each_peer(struct ice_pf *pf, void *data,
+		  int (*fn)(struct ice_peer_obj_int *, void *))
+{
+	unsigned int i;
+
+	if (!pf->peers)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(ice_peers); i++) {
+		struct ice_peer_obj_int *peer_obj_int;
+
+		peer_obj_int = pf->peers[i];
+		if (peer_obj_int) {
+			int ret = fn(peer_obj_int, data);
+
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * ice_unreg_peer_obj - unregister specified peer object
+ * @peer_obj_int: ptr to peer object internal
+ * @data: ptr to opaque data
+ *
+ * This function invokes object unregistration, removes ID associated with
+ * the specified object.
+ */
+static int
+ice_unreg_peer_obj(struct ice_peer_obj_int *peer_obj_int,
+		   void __always_unused *data)
+{
+	struct ice_peer_drv_int *peer_drv_int;
+
+	if (!peer_obj_int)
+		return 0;
+
+	peer_drv_int = peer_obj_int->peer_drv_int;
+
+	if (peer_obj_int->ice_peer_wq) {
+		if (peer_obj_int->peer_prep_task.func)
+			cancel_work_sync(&peer_obj_int->peer_prep_task);
+
+		destroy_workqueue(peer_obj_int->ice_peer_wq);
+	}
+
+	kfree(peer_drv_int);
+
+	kfree(peer_obj_int);
+
+	return 0;
+}
+
+/**
+ * ice_unroll_peer - destroy peers and peer_wq in case of error
+ * @peer_obj_int: ptr to peer object internal struct
+ * @data: ptr to opaque data
+ *
+ * This function releases resources in the event of a failure in creating
+ * peer objects or their individual work_queues. Meant to be called from
+ * a ice_for_each_peer invocation
+ */
+int ice_unroll_peer(struct ice_peer_obj_int *peer_obj_int, void __always_unused *data)
+{
+	struct iidc_peer_obj *peer_obj;
+	struct ice_pf *pf;
+
+	peer_obj = ice_get_peer_obj(peer_obj_int);
+	if (!peer_obj || !peer_obj->pdev)
+		return 0;
+
+	pf = pci_get_drvdata(peer_obj->pdev);
+	if (!pf)
+		return 0;
+
+	if (peer_obj_int->ice_peer_wq)
+		destroy_workqueue(peer_obj_int->ice_peer_wq);
+
+	kfree(peer_obj_int->peer_drv_int);
+
+	kfree(peer_obj_int);
+
+	return 0;
+}
+
+/**
+ * ice_peer_refresh_msix - load new values into iidc_peer_obj structs
+ * @pf: pointer to private board struct
+ */
+void __maybe_unused ice_peer_refresh_msix(struct ice_pf *pf)
+{
+	struct iidc_peer_obj *peer;
+	unsigned int i;
+
+	if (!pf->peers)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(ice_peers); i++) {
+		if (!pf->peers[i])
+			continue;
+
+		peer = ice_get_peer_obj(pf->peers[i]);
+		if (!peer)
+			continue;
+
+		switch (peer->peer_obj_id) {
+		case IIDC_PEER_RDMA_ID:
+			peer->msix_count = pf->num_rdma_msix;
+			peer->msix_entries = &pf->msix_entries[pf->rdma_base_vector];
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+/**
+ * ice_reserve_peer_qvector - Reserve vector resources for peer drivers
+ * @pf: board private structure to initialize
+ */
+static int ice_reserve_peer_qvector(struct ice_pf *pf)
+{
+	if (test_bit(ICE_FLAG_IWARP_ENA, pf->flags)) {
+		int index;
+
+		index = ice_get_res(pf, pf->irq_tracker, pf->num_rdma_msix, ICE_RES_RDMA_VEC_ID);
+		if (index < 0)
+			return index;
+		pf->num_avail_sw_msix -= pf->num_rdma_msix;
+		pf->rdma_base_vector = (u16)index;
+	}
+	return 0;
+}
+
+/**
+ * ice_peer_update_vsi - update the pf_vsi info in peer_obj struct
+ * @peer_obj_int: pointer to peer_obj internal struct
+ * @data: opaque pointer - VSI to be updated
+ */
+int ice_peer_update_vsi(struct ice_peer_obj_int *peer_obj_int, void *data)
+{
+	struct ice_vsi *vsi = (struct ice_vsi *)data;
+	struct iidc_peer_obj *peer_obj;
+
+	peer_obj = ice_get_peer_obj(peer_obj_int);
+	if (!peer_obj)
+		return 0;
+
+	peer_obj->pf_vsi_num = vsi->vsi_num;
+	return 0;
+}
+
+/**
+ * ice_init_peer_devices - initializes peer objects and aux devices
+ * @pf: ptr to ice_pf
+ *
+ * This function initializes peer objects and auxiliary devices.
+ */
+int ice_init_peer_devices(struct ice_pf *pf)
+{
+	struct ice_vsi *vsi = ice_get_main_vsi(pf);
+	struct pci_dev *pdev = pf->pdev;
+	struct device *dev = &pdev->dev;
+	unsigned int i;
+	int ret;
+
+	/* Reserve vector resources */
+	ret = ice_reserve_peer_qvector(pf);
+	if (ret) {
+		dev_err(dev, "failed to reserve vectors for peer drivers\n");
+		return ret;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(ice_peers); i++) {
+		struct ice_peer_obj_int *peer_obj_int;
+		struct ice_peer_drv_int *peer_drv_int;
+		struct iidc_qos_params *qos_info;
+		struct msix_entry *entry = NULL;
+		struct iidc_peer_obj *peer_obj;
+		int j;
+
+		/* structure layout needed for container_of's looks like:
+		 * ice_peer_obj_int (internal only ice peer superstruct)
+		 * |--> iidc_peer_obj
+		 * |--> *ice_peer_drv_int
+		 *
+		 * ice_peer_drv_int (internal only peer_drv struct)
+		 */
+		peer_obj_int = kzalloc(sizeof(*peer_obj_int), GFP_KERNEL);
+		if (!peer_obj_int)
+			return -ENOMEM;
+
+		peer_drv_int = kzalloc(sizeof(*peer_drv_int), GFP_KERNEL);
+		if (!peer_drv_int) {
+			kfree(peer_obj_int);
+			return -ENOMEM;
+		}
+
+		pf->peers[i] = peer_obj_int;
+		peer_obj_int->peer_drv_int = peer_drv_int;
+
+		mutex_init(&peer_obj_int->peer_obj_state_mutex);
+
+		peer_obj = ice_get_peer_obj(peer_obj_int);
+		peer_obj->peer_ops = NULL;
+		peer_obj->hw_addr = (u8 __iomem *)pf->hw.hw_addr;
+		peer_obj->peer_obj_id = ice_peers[i].id;
+		peer_obj->pf_vsi_num = vsi->vsi_num;
+		peer_obj->netdev = vsi->netdev;
+
+		peer_obj_int->ice_peer_wq =
+			alloc_ordered_workqueue("ice_peer_wq_%d", WQ_UNBOUND,
+						i);
+		if (!peer_obj_int->ice_peer_wq) {
+			kfree(peer_obj_int);
+			kfree(peer_drv_int);
+			return -ENOMEM;
+		}
+
+		peer_obj->pdev = pdev;
+		qos_info = &peer_obj->initial_qos_info;
+
+		/* setup qos_info fields with defaults */
+		qos_info->num_apps = 0;
+		qos_info->num_tc = 1;
+
+		for (j = 0; j < IIDC_MAX_USER_PRIORITY; j++)
+			qos_info->up2tc[j] = 0;
+
+		qos_info->tc_info[0].rel_bw = 100;
+		for (j = 1; j < IEEE_8021QAZ_MAX_TCS; j++)
+			qos_info->tc_info[j].rel_bw = 0;
+
+		/* for DCB, override the qos_info defaults. */
+		ice_setup_dcb_qos_info(pf, qos_info);
+
+		/* make sure peer specific resources such as msix_count and
+		 * msix_entries are initialized
+		 */
+		switch (ice_peers[i].id) {
+		case IIDC_PEER_RDMA_ID:
+			if (test_bit(ICE_FLAG_IWARP_ENA, pf->flags)) {
+				peer_obj->msix_count = pf->num_rdma_msix;
+				entry = &pf->msix_entries[pf->rdma_base_vector];
+			}
+			pf->rdma_peer = peer_obj;
+			break;
+		default:
+			break;
+		}
+
+		peer_obj->msix_entries = entry;
+		ice_peer_state_change(peer_obj_int, ICE_PEER_OBJ_STATE_INIT,
+				      false);
+	}
+
+	return ret;
+}
+
+/**
+ * ice_uninit_peer_devices - cleanup and unregister peer devices
+ * @pf: PF struct pointer
+ */
+void ice_uninit_peer_devices(struct ice_pf *pf)
+{
+	if (ice_is_peer_ena(pf)) {
+		ice_for_each_peer(pf, NULL, ice_unreg_peer_obj);
+		devm_kfree(&pf->pdev->dev, pf->peers);
+	}
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_idc_int.h b/drivers/net/ethernet/intel/ice/ice_idc_int.h
new file mode 100644
index 0000000..de5cc46
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_idc_int.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019, Intel Corporation. */
+
+#ifndef _ICE_IDC_INT_H_
+#define _ICE_IDC_INT_H_
+
+#include <linux/net/intel/iidc.h>
+#include "ice.h"
+
+enum ice_peer_obj_state {
+	ICE_PEER_OBJ_STATE_INIT,
+	ICE_PEER_OBJ_STATE_PROBED,
+	ICE_PEER_OBJ_STATE_OPENING,
+	ICE_PEER_OBJ_STATE_OPENED,
+	ICE_PEER_OBJ_STATE_PREP_RST,
+	ICE_PEER_OBJ_STATE_PREPPED,
+	ICE_PEER_OBJ_STATE_CLOSING,
+	ICE_PEER_OBJ_STATE_CLOSED,
+	ICE_PEER_OBJ_STATE_REMOVED,
+	ICE_PEER_OBJ_STATE_NBITS,               /* must be last */
+};
+
+struct ice_peer_drv_int {
+	struct iidc_peer_drv *peer_drv;
+};
+
+struct ice_peer_obj_int {
+	struct iidc_peer_obj peer_obj;
+	struct ice_peer_drv_int *peer_drv_int; /* driver private structure */
+
+	/* States associated with peer_obj */
+	DECLARE_BITMAP(state, ICE_PEER_OBJ_STATE_NBITS);
+	struct mutex peer_obj_state_mutex; /* peer_obj state mutex */
+
+	/* per peer workqueue */
+	struct workqueue_struct *ice_peer_wq;
+
+	struct work_struct peer_prep_task;
+
+	enum iidc_close_reason rst_type;
+};
+
+static inline struct
+iidc_peer_obj *ice_get_peer_obj(struct ice_peer_obj_int *peer_obj_int)
+{
+	if (peer_obj_int)
+		return &peer_obj_int->peer_obj;
+
+	return NULL;
+}
+
+int ice_peer_update_vsi(struct ice_peer_obj_int *peer_obj_int, void *data);
+int ice_unroll_peer(struct ice_peer_obj_int *peer_obj_int, void *data);
+#endif /* !_ICE_IDC_INT_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 3df6748..e52d300 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -596,6 +596,17 @@ bool ice_is_safe_mode(struct ice_pf *pf)
 }
 
 /**
+ * ice_is_peer_ena
+ * @pf: pointer to the PF struct
+ *
+ * returns true if peer devices/drivers are supported, false otherwise
+ */
+bool ice_is_peer_ena(struct ice_pf *pf)
+{
+	return test_bit(ICE_FLAG_PEER_ENA, pf->flags);
+}
+
+/**
  * ice_vsi_clean_rss_flow_fld - Delete RSS configuration
  * @vsi: the VSI being cleaned up
  *
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 3da1789..87ef365 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -99,7 +99,7 @@ enum ice_status
 ice_vsi_cfg_mac_fltr(struct ice_vsi *vsi, const u8 *macaddr, bool set);
 
 bool ice_is_safe_mode(struct ice_pf *pf);
-
+bool ice_is_peer_ena(struct ice_pf *pf);
 bool ice_is_dflt_vsi_in_use(struct ice_sw *sw);
 
 bool ice_is_vsi_dflt_vsi(struct ice_sw *sw, struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c52b9bb..b04147f 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3297,6 +3297,12 @@ static void ice_set_pf_caps(struct ice_pf *pf)
 {
 	struct ice_hw_func_caps *func_caps = &pf->hw.func_caps;
 
+	clear_bit(ICE_FLAG_IWARP_ENA, pf->flags);
+	clear_bit(ICE_FLAG_PEER_ENA, pf->flags);
+	if (func_caps->common_cap.iwarp) {
+		set_bit(ICE_FLAG_IWARP_ENA, pf->flags);
+		set_bit(ICE_FLAG_PEER_ENA, pf->flags);
+	}
 	clear_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
 	if (func_caps->common_cap.dcb)
 		set_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
@@ -3406,6 +3412,16 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 		v_left -= needed;
 	}
 
+	/* reserve vectors for RDMA peer driver */
+	if (test_bit(ICE_FLAG_IWARP_ENA, pf->flags)) {
+		needed = ICE_RDMA_NUM_AEQ_MSIX;
+		if (v_left < needed)
+			goto no_hw_vecs_left_err;
+		pf->num_rdma_msix = needed;
+		v_budget += needed;
+		v_left -= needed;
+	}
+
 	pf->msix_entries = devm_kcalloc(dev, v_budget,
 					sizeof(*pf->msix_entries), GFP_KERNEL);
 
@@ -3435,13 +3451,14 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 #define ICE_MIN_RDMA_VECS 2
 #define ICE_MIN_VECS (ICE_MIN_LAN_VECS + ICE_MIN_RDMA_VECS + 1)
 
-		if (v_actual < ICE_MIN_LAN_VECS) {
+		if (v_actual < ICE_MIN_VECS) {
 			/* error if we can't get minimum vectors */
 			pci_disable_msix(pf->pdev);
 			err = -ERANGE;
 			goto msix_err;
 		} else {
 			pf->num_lan_msix = ICE_MIN_LAN_VECS;
+			pf->num_rdma_msix = ICE_MIN_RDMA_VECS;
 		}
 	}
 
@@ -3457,6 +3474,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 	err = -ERANGE;
 exit_err:
 	pf->num_lan_msix = 0;
+	pf->num_rdma_msix = 0;
 	return err;
 }
 
@@ -4218,6 +4236,26 @@ static void ice_print_wake_reason(struct ice_pf *pf)
 	/* Disable WoL at init, wait for user to enable */
 	device_set_wakeup_enable(dev, false);
 
+	/* init peers only if supported */
+	if (ice_is_peer_ena(pf)) {
+		pf->peers = devm_kcalloc(dev, IIDC_MAX_NUM_PEERS,
+					 sizeof(*pf->peers), GFP_KERNEL);
+		if (!pf->peers) {
+			err = -ENOMEM;
+			goto err_send_version_unroll;
+		}
+
+		err = ice_init_peer_devices(pf);
+		if (err) {
+			dev_err(dev, "Failed to initialize peer devices: %d\n",
+				err);
+			err = -EIO;
+			goto err_init_peer_unroll;
+		}
+	} else {
+		dev_warn(dev, "RDMA is not supported on this device\n");
+	}
+
 	if (ice_is_safe_mode(pf)) {
 		ice_set_safe_mode_vlan_cfg(pf);
 		goto probe_done;
@@ -4245,6 +4283,14 @@ static void ice_print_wake_reason(struct ice_pf *pf)
 	clear_bit(__ICE_DOWN, pf->state);
 	return 0;
 
+err_init_peer_unroll:
+	if (ice_is_peer_ena(pf)) {
+		ice_for_each_peer(pf, NULL, ice_unroll_peer);
+		if (pf->peers) {
+			devm_kfree(dev, pf->peers);
+			pf->peers = NULL;
+		}
+	}
 err_send_version_unroll:
 	ice_vsi_release_all(pf);
 err_alloc_sw_unroll:
@@ -4363,6 +4409,7 @@ static void ice_remove(struct pci_dev *pdev)
 		ice_remove_arfs(pf);
 	ice_setup_mc_magic_wake(pf);
 	ice_vsi_release_all(pf);
+	ice_uninit_peer_devices(pf);
 	ice_set_wake(pf);
 	ice_free_irq_msix_misc(pf);
 	ice_for_each_vsi(pf, i) {
@@ -4589,6 +4636,8 @@ static int __maybe_unused ice_resume(struct device *dev)
 	if (ret)
 		dev_err(dev, "Cannot restore interrupt scheme: %d\n", ret);
 
+	ice_peer_refresh_msix(pf);
+
 	clear_bit(__ICE_DOWN, pf->state);
 	/* Now perform PF reset and rebuild */
 	reset_type = ICE_RESET_PFR;
@@ -6036,6 +6085,16 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 		goto err_vsi_rebuild;
 	}
 
+	if (ice_is_peer_ena(pf)) {
+		struct ice_vsi *vsi = ice_get_main_vsi(pf);
+
+		if (!vsi) {
+			dev_err(dev, "No PF_VSI to update peer\n");
+			goto err_vsi_rebuild;
+		}
+		ice_for_each_peer(pf, vsi, ice_peer_update_vsi);
+	}
+
 	/* If Flow Director is active */
 	if (test_bit(ICE_FLAG_FD_ENA, pf->flags)) {
 		err = ice_vsi_rebuild_by_type(pf, ICE_VSI_CTRL);
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 2226a29..c112ba0 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -244,6 +244,7 @@ struct ice_hw_common_caps {
 	u8 rss_table_entry_width;	/* RSS Entry width in bits */
 
 	u8 dcb;
+	u8 iwarp;
 
 	bool nvm_update_pending_nvm;
 	bool nvm_update_pending_orom;
-- 
1.8.3.1

