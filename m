Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08845346E05
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 01:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbhCXADy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 20:03:54 -0400
Received: from mga17.intel.com ([192.55.52.151]:37587 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234346AbhCXADW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 20:03:22 -0400
IronPort-SDR: GF0U/I4Rd4DcQigF0DloB/TlD4NXGZJizSK4p+NRTXeDO2X6SaAIWOvYEztVefDIuZZW//OQEo
 WCfWajkHcckw==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="170556544"
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="170556544"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 17:03:22 -0700
IronPort-SDR: orT+E9sk2pbBJMwulH25UhdfSn4TWld7H4t3xu9BesvOLYiaHceqiwLxkkApcdub3JS9y89k/W
 2k6i1l8ZErXA==
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="381542188"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.209.103.207])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 17:03:21 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v2 02/23] ice: Initialize RDMA support
Date:   Tue, 23 Mar 2021 18:59:46 -0500
Message-Id: <20210324000007.1450-3-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210324000007.1450-1-shiraz.saleem@intel.com>
References: <20210324000007.1450-1-shiraz.saleem@intel.com>
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
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 drivers/net/ethernet/intel/ice/Makefile         |   1 +
 drivers/net/ethernet/intel/ice/ice.h            |  33 ++++
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h |   1 +
 drivers/net/ethernet/intel/ice/ice_common.c     |  17 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c    |  35 ++++
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h    |   3 +
 drivers/net/ethernet/intel/ice/ice_idc.c        | 232 ++++++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_idc_int.h    |  17 ++
 drivers/net/ethernet/intel/ice/ice_lag.c        |   2 +
 drivers/net/ethernet/intel/ice/ice_lib.c        |  11 ++
 drivers/net/ethernet/intel/ice/ice_lib.h        |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c       |  99 +++++++++-
 drivers/net/ethernet/intel/ice/ice_type.h       |   1 +
 13 files changed, 446 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc_int.h

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 73da4f7..5d00352 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -22,6 +22,7 @@ ice-y := ice_main.o	\
 	 ice_ethtool_fdir.o \
 	 ice_flex_pipe.o \
 	 ice_flow.o	\
+	 ice_idc.o	\
 	 ice_devlink.o	\
 	 ice_fw_update.o \
 	 ice_lag.o	\
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 3577064..ebd2159 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -51,6 +51,7 @@
 #include "ice_switch.h"
 #include "ice_common.h"
 #include "ice_sched.h"
+#include "ice_idc_int.h"
 #include "ice_virtchnl_pf.h"
 #include "ice_sriov.h"
 #include "ice_fdir.h"
@@ -74,6 +75,8 @@
 #define ICE_MIN_LAN_OICR_MSIX	1
 #define ICE_MIN_MSIX		(ICE_MIN_LAN_TXRX_MSIX + ICE_MIN_LAN_OICR_MSIX)
 #define ICE_FDIR_MSIX		1
+#define ICE_RDMA_NUM_AEQ_MSIX	4
+#define ICE_MIN_RDMA_MSIX	2
 #define ICE_NO_VSI		0xffff
 #define ICE_VSI_MAP_CONTIG	0
 #define ICE_VSI_MAP_SCATTER	1
@@ -84,6 +87,7 @@
 #define ICE_MAX_LG_RSS_QS	256
 #define ICE_RES_VALID_BIT	0x8000
 #define ICE_RES_MISC_VEC_ID	(ICE_RES_VALID_BIT - 1)
+#define ICE_RES_RDMA_VEC_ID	(ICE_RES_MISC_VEC_ID - 1)
 #define ICE_INVAL_Q_INDEX	0xffff
 #define ICE_INVAL_VFID		256
 
@@ -362,12 +366,14 @@ struct ice_q_vector {
 
 enum ice_pf_flags {
 	ICE_FLAG_FLTR_SYNC,
+	ICE_FLAG_IWARP_ENA,
 	ICE_FLAG_RSS_ENA,
 	ICE_FLAG_SRIOV_ENA,
 	ICE_FLAG_SRIOV_CAPABLE,
 	ICE_FLAG_DCB_CAPABLE,
 	ICE_FLAG_DCB_ENA,
 	ICE_FLAG_FD_ENA,
+	ICE_FLAG_AUX_ENA,
 	ICE_FLAG_ADV_FEATURES,
 	ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA,
 	ICE_FLAG_TOTAL_PORT_SHUTDOWN_ENA,
@@ -427,6 +433,8 @@ struct ice_pf {
 	struct mutex sw_mutex;		/* lock for protecting VSI alloc flow */
 	struct mutex tc_mutex;		/* lock to protect TC changes */
 	u32 msg_enable;
+	u16 num_rdma_msix;		/* Total MSIX vectors for RDMA driver */
+	u16 rdma_base_vector;
 
 	/* spinlock to protect the AdminQ wait list */
 	spinlock_t aq_wait_lock;
@@ -459,6 +467,8 @@ struct ice_pf {
 	unsigned long tx_timeout_last_recovery;
 	u32 tx_timeout_recovery_level;
 	char int_name[ICE_INT_NAME_STR_LEN];
+	struct iidc_core_dev_info **cdev_infos;
+	int aux_idx;
 	u32 sw_int_count;
 
 	__le64 nvm_phy_type_lo; /* NVM PHY type low */
@@ -622,6 +632,11 @@ static inline void ice_clear_sriov_cap(struct ice_pf *pf)
 void ice_fill_rss_lut(u8 *lut, u16 rss_table_size, u16 rss_size);
 int ice_schedule_reset(struct ice_pf *pf, enum ice_reset_req reset);
 void ice_print_link_msg(struct ice_vsi *vsi, bool isup);
+int ice_init_aux_devices(struct ice_pf *pf);
+int
+ice_for_each_aux(struct ice_pf *pf, void *data,
+		 int (*fn)(struct iidc_core_dev_info *, void *));
+void ice_cdev_info_refresh_msix(struct ice_pf *pf);
 const char *ice_stat_str(enum ice_status stat_err);
 const char *ice_aq_str(enum ice_aq_err aq_err);
 bool ice_is_wol_supported(struct ice_pf *pf);
@@ -645,4 +660,22 @@ int ice_aq_wait_for_event(struct ice_pf *pf, u16 opcode, unsigned long timeout,
 int ice_stop(struct net_device *netdev);
 void ice_service_task_schedule(struct ice_pf *pf);
 
+/**
+ * ice_set_rdma_cap - enable RDMA support
+ * @pf: PF struct
+ */
+static inline void ice_set_rdma_cap(struct ice_pf *pf)
+{
+	if (pf->hw.func_caps.common_cap.iwarp && pf->num_rdma_msix)
+		set_bit(ICE_FLAG_IWARP_ENA, pf->flags);
+}
+
+/**
+ * ice_clear_rdma_cap - disable RDMA support
+ * @pf: PF struct
+ */
+static inline void ice_clear_rdma_cap(struct ice_pf *pf)
+{
+	clear_bit(ICE_FLAG_IWARP_ENA, pf->flags);
+}
 #endif /* _ICE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 8018658..81735e5 100644
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
index 3d9475e..d7b15c3 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1057,7 +1057,8 @@ enum ice_status ice_check_reset(struct ice_hw *hw)
 				 GLNVM_ULD_POR_DONE_1_M |\
 				 GLNVM_ULD_PCIER_DONE_2_M)
 
-	uld_mask = ICE_RESET_DONE_MASK;
+	uld_mask = ICE_RESET_DONE_MASK | (hw->func_caps.common_cap.iwarp ?
+					  GLNVM_ULD_PE_DONE_M : 0);
 
 	/* Device is Active; check Global Reset processes are done */
 	for (cnt = 0; cnt < ICE_PF_RESET_WAIT_COUNT; cnt++) {
@@ -1854,6 +1855,10 @@ static u32 ice_get_num_per_func(struct ice_hw *hw, u32 max)
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
@@ -1887,6 +1892,16 @@ static u32 ice_get_num_per_func(struct ice_hw *hw, u32 max)
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
index 1e8f71f..3aebfa8 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -640,6 +640,7 @@ static int ice_dcb_noncontig_cfg(struct ice_pf *pf)
 void ice_pf_dcb_recfg(struct ice_pf *pf)
 {
 	struct ice_dcbx_cfg *dcbcfg = &pf->hw.port_info->qos_cfg.local_dcbx_cfg;
+	struct iidc_core_dev_info *rcdi;
 	u8 tc_map = 0;
 	int v, ret;
 
@@ -675,6 +676,9 @@ void ice_pf_dcb_recfg(struct ice_pf *pf)
 		if (vsi->type == ICE_VSI_PF)
 			ice_dcbnl_set_all(vsi);
 	}
+	rcdi = ice_find_cdev_info_by_id(pf, IIDC_RDMA_ID);
+	if (rcdi)
+		ice_setup_dcb_qos_info(pf, &rcdi->qos_info);
 }
 
 /**
@@ -816,6 +820,37 @@ void ice_update_dcb_stats(struct ice_pf *pf)
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
+	dcbx_cfg = &pf->hw.port_info->qos_cfg.local_dcbx_cfg;
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
index 00000000..ef54cf7
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -0,0 +1,232 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021, Intel Corporation. */
+
+/* Inter-Driver Communication */
+#include "ice.h"
+#include "ice_lib.h"
+#include "ice_dcb_lib.h"
+
+static DEFINE_IDA(ice_cdev_info_ida);
+
+static struct cdev_info_id ice_cdev_ids[] = ASSIGN_IIDC_INFO;
+
+/**
+ * ice_for_each_aux - iterate across and call function for each aux driver
+ * @pf: pointer to private board struct
+ * @data: data to pass to function on each call
+ * @fn: pointer to function to call for each aux driver
+ */
+int
+ice_for_each_aux(struct ice_pf *pf, void *data,
+		 int (*fn)(struct iidc_core_dev_info *, void *))
+{
+	unsigned int i;
+
+	if (!pf->cdev_infos)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(ice_cdev_ids); i++) {
+		struct iidc_core_dev_info *cdev_info;
+
+		cdev_info = pf->cdev_infos[i];
+		if (cdev_info) {
+			int ret = fn(cdev_info, data);
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
+ * ice_unroll_cdev_info - destroy cdev_info resources
+ * @cdev_info: ptr to cdev_info struct
+ * @data: ptr to opaque data
+ *
+ * This function releases resources for cdev_info objects.
+ * Meant to be called from a ice_for_each_aux invocation
+ */
+int ice_unroll_cdev_info(struct iidc_core_dev_info *cdev_info,
+			 void __always_unused *data)
+{
+	if (!cdev_info)
+		return 0;
+
+	kfree(cdev_info);
+
+	return 0;
+}
+
+/**
+ * ice_cdev_info_refresh_msix - load new values into iidc_core_dev_info structs
+ * @pf: pointer to private board struct
+ */
+void ice_cdev_info_refresh_msix(struct ice_pf *pf)
+{
+	struct iidc_core_dev_info *cdev_info;
+	unsigned int i;
+
+	if (!pf->cdev_infos)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(ice_cdev_ids); i++) {
+		if (!pf->cdev_infos[i])
+			continue;
+
+		cdev_info = pf->cdev_infos[i];
+
+		switch (cdev_info->cdev_info_id) {
+		case IIDC_RDMA_ID:
+			cdev_info->msix_count = pf->num_rdma_msix;
+			cdev_info->msix_entries =
+				&pf->msix_entries[pf->rdma_base_vector];
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+/**
+ * ice_reserve_cdev_info_qvector - Reserve vector resources for aux drivers
+ * @pf: board private structure to initialize
+ */
+static int ice_reserve_cdev_info_qvector(struct ice_pf *pf)
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
+ * ice_find_cdev_info_by_id - find cdev_info instance by its ID
+ * @pf: pointer to private board struct
+ * @cdev_info_id: aux driver ID
+ */
+struct iidc_core_dev_info *
+ice_find_cdev_info_by_id(struct ice_pf *pf, int cdev_info_id)
+{
+	struct iidc_core_dev_info *cdev_info = NULL;
+	unsigned int i;
+
+	if (!pf->cdev_infos)
+		return NULL;
+
+	for (i = 0; i < ARRAY_SIZE(ice_cdev_ids); i++) {
+		cdev_info = pf->cdev_infos[i];
+		if (cdev_info && cdev_info->cdev_info_id == cdev_info_id)
+			break;
+		cdev_info = NULL;
+	}
+	return cdev_info;
+}
+
+/**
+ * ice_cdev_info_update_vsi - update the pf_vsi info in cdev_info struct
+ * @cdev_info: pointer to cdev_info struct
+ * @data: opaque pointer - VSI to be updated
+ */
+int ice_cdev_info_update_vsi(struct iidc_core_dev_info *cdev_info, void *data)
+{
+	struct ice_vsi *vsi = data;
+
+	if (!cdev_info)
+		return 0;
+
+	cdev_info->vport_id = vsi->vsi_num;
+	return 0;
+}
+
+/**
+ * ice_init_aux_devices - initializes cdev_info objects and aux devices
+ * @pf: ptr to ice_pf
+ */
+int ice_init_aux_devices(struct ice_pf *pf)
+{
+	struct ice_vsi *vsi = ice_get_main_vsi(pf);
+	struct pci_dev *pdev = pf->pdev;
+	struct device *dev = &pdev->dev;
+	unsigned int i;
+	int ret;
+
+	/* Reserve vector resources */
+	ret = ice_reserve_cdev_info_qvector(pf);
+	if (ret) {
+		dev_err(dev, "failed to reserve vectors for aux drivers\n");
+		return ret;
+	}
+
+	/* This PFs auxiliary ID value */
+	pf->aux_idx = ida_alloc(&ice_cdev_info_ida, GFP_KERNEL);
+	if (pf->aux_idx < 0) {
+		dev_err(dev, "failed to allocate device ID for aux drvs\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(ice_cdev_ids); i++) {
+		struct iidc_core_dev_info *cdev_info;
+		struct iidc_qos_params *qos_info;
+		struct msix_entry *entry = NULL;
+		int j;
+
+		cdev_info = kzalloc(sizeof(*cdev_info), GFP_KERNEL);
+		if (!cdev_info) {
+			ida_simple_remove(&ice_cdev_info_ida, pf->aux_idx);
+			pf->aux_idx = -1;
+			return -ENOMEM;
+		}
+
+		pf->cdev_infos[i] = cdev_info;
+
+		cdev_info->hw_addr = (u8 __iomem *)pf->hw.hw_addr;
+		cdev_info->cdev_info_id = ice_cdev_ids[i].id;
+		cdev_info->vport_id = vsi->vsi_num;
+		cdev_info->netdev = vsi->netdev;
+
+		cdev_info->pdev = pdev;
+		qos_info = &cdev_info->qos_info;
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
+		/* make sure aux specific resources such as msix_count and
+		 * msix_entries are initialized
+		 */
+		switch (ice_cdev_ids[i].id) {
+		case IIDC_RDMA_ID:
+			if (test_bit(ICE_FLAG_IWARP_ENA, pf->flags)) {
+				cdev_info->msix_count = pf->num_rdma_msix;
+				entry = &pf->msix_entries[pf->rdma_base_vector];
+			}
+			cdev_info->rdma_protocol = IIDC_RDMA_PROTOCOL_IWARP;
+			cdev_info->rdma_limits_sel = IIDC_RDMA_LIMITS_SEL_3;
+			break;
+		default:
+			break;
+		}
+
+		cdev_info->msix_entries = entry;
+	}
+
+	return ret;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_idc_int.h b/drivers/net/ethernet/intel/ice/ice_idc_int.h
new file mode 100644
index 00000000..67b63c6
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_idc_int.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2021, Intel Corporation. */
+
+#ifndef _ICE_IDC_INT_H_
+#define _ICE_IDC_INT_H_
+
+#include <linux/net/intel/iidc.h>
+#include "ice.h"
+
+struct ice_pf;
+
+int ice_cdev_info_update_vsi(struct iidc_core_dev_info *cdev_info, void *data);
+int ice_unroll_cdev_info(struct iidc_core_dev_info *cdev_info, void *data);
+struct iidc_core_dev_info *
+ice_find_cdev_info_by_id(struct ice_pf *pf, int cdev_info_id);
+
+#endif /* !_ICE_IDC_INT_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ethernet/intel/ice/ice_lag.c
index 4599fc3..37c18c6 100644
--- a/drivers/net/ethernet/intel/ice/ice_lag.c
+++ b/drivers/net/ethernet/intel/ice/ice_lag.c
@@ -172,6 +172,7 @@ static void ice_lag_info_event(struct ice_lag *lag, void *ptr)
 	}
 
 	ice_clear_sriov_cap(pf);
+	ice_clear_rdma_cap(pf);
 
 	lag->bonded = true;
 	lag->role = ICE_LAG_UNSET;
@@ -222,6 +223,7 @@ static void ice_lag_info_event(struct ice_lag *lag, void *ptr)
 	}
 
 	ice_set_sriov_cap(pf);
+	ice_set_rdma_cap(pf);
 	lag->bonded = false;
 	lag->role = ICE_LAG_NONE;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 8d4e2ad..a897ce0 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -600,6 +600,17 @@ bool ice_is_safe_mode(struct ice_pf *pf)
 }
 
 /**
+ * ice_is_aux_ena
+ * @pf: pointer to the PF struct
+ *
+ * returns true if aux devices/drivers are supported, false otherwise
+ */
+bool ice_is_aux_ena(struct ice_pf *pf)
+{
+	return test_bit(ICE_FLAG_AUX_ENA, pf->flags);
+}
+
+/**
  * ice_vsi_clean_rss_flow_fld - Delete RSS configuration
  * @vsi: the VSI being cleaned up
  *
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 3da1789..0f794d7 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -99,7 +99,7 @@ enum ice_status
 ice_vsi_cfg_mac_fltr(struct ice_vsi *vsi, const u8 *macaddr, bool set);
 
 bool ice_is_safe_mode(struct ice_pf *pf);
-
+bool ice_is_aux_ena(struct ice_pf *pf);
 bool ice_is_dflt_vsi_in_use(struct ice_sw *sw);
 
 bool ice_is_vsi_dflt_vsi(struct ice_sw *sw, struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2c23c8f..f569d58 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3312,6 +3312,12 @@ static void ice_set_pf_caps(struct ice_pf *pf)
 {
 	struct ice_hw_func_caps *func_caps = &pf->hw.func_caps;
 
+	clear_bit(ICE_FLAG_IWARP_ENA, pf->flags);
+	clear_bit(ICE_FLAG_AUX_ENA, pf->flags);
+	if (func_caps->common_cap.iwarp) {
+		set_bit(ICE_FLAG_IWARP_ENA, pf->flags);
+		set_bit(ICE_FLAG_AUX_ENA, pf->flags);
+	}
 	clear_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
 	if (func_caps->common_cap.dcb)
 		set_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
@@ -3391,11 +3397,12 @@ static int ice_init_pf(struct ice_pf *pf)
  */
 static int ice_ena_msix_range(struct ice_pf *pf)
 {
-	int v_left, v_actual, v_other, v_budget = 0;
+	int num_cpus, v_left, v_actual, v_other, v_budget = 0;
 	struct device *dev = ice_pf_to_dev(pf);
 	int needed, err, i;
 
 	v_left = pf->hw.func_caps.common_cap.num_msix_vectors;
+	num_cpus = num_online_cpus();
 
 	/* reserve for LAN miscellaneous handler */
 	needed = ICE_MIN_LAN_OICR_MSIX;
@@ -3417,13 +3424,23 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 	v_other = v_budget;
 
 	/* reserve vectors for LAN traffic */
-	needed = min_t(int, num_online_cpus(), v_left);
+	needed = num_cpus;
 	if (v_left < needed)
 		goto no_hw_vecs_left_err;
 	pf->num_lan_msix = needed;
 	v_budget += needed;
 	v_left -= needed;
 
+	/* reserve vectors for RDMA auxiliary driver */
+	if (test_bit(ICE_FLAG_IWARP_ENA, pf->flags)) {
+		needed = num_cpus + ICE_RDMA_NUM_AEQ_MSIX;
+		if (v_left < needed)
+			goto no_hw_vecs_left_err;
+		pf->num_rdma_msix = needed;
+		v_budget += needed;
+		v_left -= needed;
+	}
+
 	pf->msix_entries = devm_kcalloc(dev, v_budget,
 					sizeof(*pf->msix_entries), GFP_KERNEL);
 	if (!pf->msix_entries) {
@@ -3453,16 +3470,46 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 			err = -ERANGE;
 			goto msix_err;
 		} else {
-			int v_traffic = v_actual - v_other;
+			int v_remain = v_actual - v_other;
+			int v_rdma = 0, v_min_rdma = 0;
+
+			if (test_bit(ICE_FLAG_IWARP_ENA, pf->flags)) {
+				/* Need at least 1 interrupt in addition to
+				 * AEQ MSIX
+				 */
+				v_rdma = ICE_RDMA_NUM_AEQ_MSIX + 1;
+				v_min_rdma = ICE_MIN_RDMA_MSIX;
+			}
 
 			if (v_actual == ICE_MIN_MSIX ||
-			    v_traffic < ICE_MIN_LAN_TXRX_MSIX)
+			    v_remain < ICE_MIN_LAN_TXRX_MSIX + v_min_rdma) {
+				dev_warn(dev, "Not enough MSI-X vectors to support RDMA.\n");
+				clear_bit(ICE_FLAG_IWARP_ENA, pf->flags);
+
+				pf->num_rdma_msix = 0;
 				pf->num_lan_msix = ICE_MIN_LAN_TXRX_MSIX;
-			else
-				pf->num_lan_msix = v_traffic;
+			} else if ((v_remain < ICE_MIN_LAN_TXRX_MSIX + v_rdma) ||
+				   (v_remain - v_rdma < v_rdma)) {
+				/* Support minimum RDMA and give remaining
+				 * vectors to LAN MSIX
+				 */
+				pf->num_rdma_msix = v_min_rdma;
+				pf->num_lan_msix = v_remain - v_min_rdma;
+			} else {
+				/* Split remaining MSIX with RDMA after
+				 * accounting for AEQ MSIX
+				 */
+				pf->num_rdma_msix = (v_remain - ICE_RDMA_NUM_AEQ_MSIX) / 2 +
+						    ICE_RDMA_NUM_AEQ_MSIX;
+				pf->num_lan_msix = v_remain - pf->num_rdma_msix;
+			}
 
 			dev_notice(dev, "Enabled %d MSI-X vectors for LAN traffic.\n",
 				   pf->num_lan_msix);
+
+			if (test_bit(ICE_FLAG_IWARP_ENA, pf->flags))
+				dev_notice(dev, "Enabled %d MSI-X vectors for RDMA.\n",
+					   pf->num_rdma_msix);
 		}
 	}
 
@@ -3477,6 +3524,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 		needed, v_left);
 	err = -ERANGE;
 exit_err:
+	pf->num_rdma_msix = 0;
 	pf->num_lan_msix = 0;
 	return err;
 }
@@ -4267,8 +4315,37 @@ static void ice_print_wake_reason(struct ice_pf *pf)
 probe_done:
 	/* ready to go, so clear down state bit */
 	clear_bit(__ICE_DOWN, pf->state);
+	/* init aux devices only if supported */
+	if (ice_is_aux_ena(pf)) {
+		pf->cdev_infos = devm_kcalloc(dev, IIDC_MAX_NUM_AUX,
+					      sizeof(*pf->cdev_infos),
+					      GFP_KERNEL);
+		if (!pf->cdev_infos) {
+			err = -ENOMEM;
+			goto err_init_aux_unroll;
+		}
+
+		err = ice_init_aux_devices(pf);
+		if (err) {
+			dev_err(dev, "Failed to initialize aux devs: %d\n",
+				err);
+			err = -EIO;
+			goto err_init_aux_unroll;
+		}
+	} else {
+		dev_warn(dev, "RDMA is not supported on this device\n");
+	}
+
 	return 0;
 
+err_init_aux_unroll:
+	if (ice_is_aux_ena(pf)) {
+		ice_for_each_aux(pf, NULL, ice_unroll_cdev_info);
+		if (pf->cdev_infos) {
+			devm_kfree(dev, pf->cdev_infos);
+			pf->cdev_infos = NULL;
+		}
+	}
 err_send_version_unroll:
 	ice_vsi_release_all(pf);
 err_alloc_sw_unroll:
@@ -4614,6 +4691,8 @@ static int __maybe_unused ice_resume(struct device *dev)
 	if (ret)
 		dev_err(dev, "Cannot restore interrupt scheme: %d\n", ret);
 
+	ice_cdev_info_refresh_msix(pf);
+
 	clear_bit(__ICE_DOWN, pf->state);
 	/* Now perform PF reset and rebuild */
 	reset_type = ICE_RESET_PFR;
@@ -5980,6 +6059,7 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 	struct device *dev = ice_pf_to_dev(pf);
 	struct ice_hw *hw = &pf->hw;
 	enum ice_status ret;
+	struct ice_vsi *vsi;
 	int err;
 
 	if (test_bit(__ICE_DOWN, pf->state))
@@ -6067,6 +6147,13 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 		goto err_vsi_rebuild;
 	}
 
+	vsi = ice_get_main_vsi(pf);
+	if (!vsi) {
+		dev_err(dev, "No PF_VSI to update aux drivers\n");
+		goto err_vsi_rebuild;
+	}
+	ice_for_each_aux(pf, vsi, ice_cdev_info_update_vsi);
+
 	/* If Flow Director is active */
 	if (test_bit(ICE_FLAG_FD_ENA, pf->flags)) {
 		err = ice_vsi_rebuild_by_type(pf, ICE_VSI_CTRL);
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index a6cb0c35..4eaab60 100644
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

