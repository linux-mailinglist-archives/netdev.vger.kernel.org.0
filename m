Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95F4380B57
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 16:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbhENOQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 10:16:24 -0400
Received: from mga04.intel.com ([192.55.52.120]:41443 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234274AbhENOQT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 10:16:19 -0400
IronPort-SDR: Kq5etS6q83zp2F4SIixWlzizzr9fAXUJlPgP+9f3F1uncKE92PaL2STiF17WmFk+GEHxEreSqW
 l33S10dYKQEQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9984"; a="198227388"
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="198227388"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 07:15:07 -0700
IronPort-SDR: MgG++5vx5WaRXXz42ApB3A+ce1dOaCjS4Wv9sFL5metLAQk8CDalv2MmbZjH03tK8+8JWyinhH
 tFsf4/OMmIpw==
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="542867687"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.212.97.94])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 07:15:07 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v5 02/22] ice: Initialize RDMA support
Date:   Fri, 14 May 2021 09:11:54 -0500
Message-Id: <20210514141214.2120-3-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210514141214.2120-1-shiraz.saleem@intel.com>
References: <20210514141214.2120-1-shiraz.saleem@intel.com>
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
 drivers/net/ethernet/intel/ice/Makefile         |  1 +
 drivers/net/ethernet/intel/ice/ice.h            | 30 ++++++++-
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h |  1 +
 drivers/net/ethernet/intel/ice/ice_common.c     | 17 ++++-
 drivers/net/ethernet/intel/ice/ice_idc.c        | 43 +++++++++++++
 drivers/net/ethernet/intel/ice/ice_lag.c        |  2 +
 drivers/net/ethernet/intel/ice/ice_lib.c        | 11 ++++
 drivers/net/ethernet/intel/ice/ice_lib.h        |  2 +-
 drivers/net/ethernet/intel/ice/ice_main.c       | 84 +++++++++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_type.h       |  1 +
 10 files changed, 183 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc.c

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 07fe857..dfb64fb 100644
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
index e35db3f..64e3633 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -78,6 +78,8 @@
 #define ICE_MIN_LAN_OICR_MSIX	1
 #define ICE_MIN_MSIX		(ICE_MIN_LAN_TXRX_MSIX + ICE_MIN_LAN_OICR_MSIX)
 #define ICE_FDIR_MSIX		2
+#define ICE_RDMA_NUM_AEQ_MSIX	4
+#define ICE_MIN_RDMA_MSIX	2
 #define ICE_NO_VSI		0xffff
 #define ICE_VSI_MAP_CONTIG	0
 #define ICE_VSI_MAP_SCATTER	1
@@ -88,8 +90,9 @@
 #define ICE_MAX_LG_RSS_QS	256
 #define ICE_RES_VALID_BIT	0x8000
 #define ICE_RES_MISC_VEC_ID	(ICE_RES_VALID_BIT - 1)
+#define ICE_RES_RDMA_VEC_ID	(ICE_RES_MISC_VEC_ID - 1)
 /* All VF control VSIs share the same IRQ, so assign a unique ID for them */
-#define ICE_RES_VF_CTRL_VEC_ID	(ICE_RES_MISC_VEC_ID - 1)
+#define ICE_RES_VF_CTRL_VEC_ID	(ICE_RES_RDMA_VEC_ID - 1)
 #define ICE_INVAL_Q_INDEX	0xffff
 #define ICE_INVAL_VFID		256
 
@@ -373,12 +376,14 @@ struct ice_q_vector {
 
 enum ice_pf_flags {
 	ICE_FLAG_FLTR_SYNC,
+	ICE_FLAG_RDMA_ENA,
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
@@ -439,6 +444,8 @@ struct ice_pf {
 	struct mutex sw_mutex;		/* lock for protecting VSI alloc flow */
 	struct mutex tc_mutex;		/* lock to protect TC changes */
 	u32 msg_enable;
+	u16 num_rdma_msix;		/* Total MSIX vectors for RDMA driver */
+	u16 rdma_base_vector;
 
 	/* spinlock to protect the AdminQ wait list */
 	spinlock_t aq_wait_lock;
@@ -471,6 +478,8 @@ struct ice_pf {
 	unsigned long tx_timeout_last_recovery;
 	u32 tx_timeout_recovery_level;
 	char int_name[ICE_INT_NAME_STR_LEN];
+	struct auxiliary_device *adev;
+	int aux_idx;
 	u32 sw_int_count;
 
 	__le64 nvm_phy_type_lo; /* NVM PHY type low */
@@ -636,6 +645,7 @@ static inline void ice_clear_sriov_cap(struct ice_pf *pf)
 void ice_fill_rss_lut(u8 *lut, u16 rss_table_size, u16 rss_size);
 int ice_schedule_reset(struct ice_pf *pf, enum ice_reset_req reset);
 void ice_print_link_msg(struct ice_vsi *vsi, bool isup);
+int ice_init_rdma(struct ice_pf *pf);
 const char *ice_stat_str(enum ice_status stat_err);
 const char *ice_aq_str(enum ice_aq_err aq_err);
 bool ice_is_wol_supported(struct ice_hw *hw);
@@ -660,4 +670,22 @@ int ice_aq_wait_for_event(struct ice_pf *pf, u16 opcode, unsigned long timeout,
 int ice_stop(struct net_device *netdev);
 void ice_service_task_schedule(struct ice_pf *pf);
 
+/**
+ * ice_set_rdma_cap - enable RDMA support
+ * @pf: PF struct
+ */
+static inline void ice_set_rdma_cap(struct ice_pf *pf)
+{
+	if (pf->hw.func_caps.common_cap.rdma && pf->num_rdma_msix)
+		set_bit(ICE_FLAG_RDMA_ENA, pf->flags);
+}
+
+/**
+ * ice_clear_rdma_cap - disable RDMA support
+ * @pf: PF struct
+ */
+static inline void ice_clear_rdma_cap(struct ice_pf *pf)
+{
+	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
+}
 #endif /* _ICE_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 5cdfe40..cba6933 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -115,6 +115,7 @@ struct ice_aqc_list_caps_elem {
 #define ICE_AQC_CAPS_PENDING_OROM_VER			0x004B
 #define ICE_AQC_CAPS_NET_VER				0x004C
 #define ICE_AQC_CAPS_PENDING_NET_VER			0x004D
+#define ICE_AQC_CAPS_RDMA				0x0051
 #define ICE_AQC_CAPS_NVM_MGMT				0x0080
 
 	u8 major_ver;
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index e93b1e4..6d649e5 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1062,7 +1062,8 @@ enum ice_status ice_check_reset(struct ice_hw *hw)
 				 GLNVM_ULD_POR_DONE_1_M |\
 				 GLNVM_ULD_PCIER_DONE_2_M)
 
-	uld_mask = ICE_RESET_DONE_MASK;
+	uld_mask = ICE_RESET_DONE_MASK | (hw->func_caps.common_cap.rdma ?
+					  GLNVM_ULD_PE_DONE_M : 0);
 
 	/* Device is Active; check Global Reset processes are done */
 	for (cnt = 0; cnt < ICE_PF_RESET_WAIT_COUNT; cnt++) {
@@ -1938,6 +1939,10 @@ static u32 ice_get_num_per_func(struct ice_hw *hw, u32 max)
 		ice_debug(hw, ICE_DBG_INIT, "%s: nvm_unified_update = %d\n", prefix,
 			  caps->nvm_unified_update);
 		break;
+	case ICE_AQC_CAPS_RDMA:
+		caps->rdma = (number == 1);
+		ice_debug(hw, ICE_DBG_INIT, "%s: rdma = %d\n", prefix, caps->rdma);
+		break;
 	case ICE_AQC_CAPS_MAX_MTU:
 		caps->max_mtu = number;
 		ice_debug(hw, ICE_DBG_INIT, "%s: max_mtu = %d\n",
@@ -1971,6 +1976,16 @@ static u32 ice_get_num_per_func(struct ice_hw *hw, u32 max)
 		caps->maxtc = 4;
 		ice_debug(hw, ICE_DBG_INIT, "reducing maxtc to %d (based on #ports)\n",
 			  caps->maxtc);
+		if (caps->rdma) {
+			ice_debug(hw, ICE_DBG_INIT, "forcing RDMA off\n");
+			caps->rdma = 0;
+		}
+
+		/* print message only when processing device capabilities
+		 * during initialization.
+		 */
+		if (caps == &hw->dev_caps.common_cap)
+			dev_info(ice_hw_to_dev(hw), "RDMA functionality is not available with the current device configuration.\n");
 	}
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
new file mode 100644
index 0000000..c419c9c
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2021, Intel Corporation. */
+
+/* Inter-Driver Communication */
+#include "ice.h"
+#include "ice_lib.h"
+#include "ice_dcb_lib.h"
+
+/**
+ * ice_reserve_rdma_qvector - Reserve vector resources for RDMA driver
+ * @pf: board private structure to initialize
+ */
+static int ice_reserve_rdma_qvector(struct ice_pf *pf)
+{
+	if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags)) {
+		int index;
+
+		index = ice_get_res(pf, pf->irq_tracker, pf->num_rdma_msix,
+				    ICE_RES_RDMA_VEC_ID);
+		if (index < 0)
+			return index;
+		pf->num_avail_sw_msix -= pf->num_rdma_msix;
+		pf->rdma_base_vector = (u16)index;
+	}
+	return 0;
+}
+
+/**
+ * ice_init_rdma - initializes PF for RDMA use
+ * @pf: ptr to ice_pf
+ */
+int ice_init_rdma(struct ice_pf *pf)
+{
+	struct device *dev = &pf->pdev->dev;
+	int ret;
+
+	/* Reserve vector resources */
+	ret = ice_reserve_rdma_qvector(pf);
+	if (ret < 0)
+		dev_err(dev, "failed to reserve vectors for RDMA\n");
+
+	return ret;
+}
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
index 82e2ce23..56e1ae5 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -617,6 +617,17 @@ bool ice_is_safe_mode(struct ice_pf *pf)
 }
 
 /**
+ * ice_is_aux_ena
+ * @pf: pointer to the PF struct
+ *
+ * returns true if AUX devices/drivers are supported, false otherwise
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
index 511c231..5ec857f 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -102,7 +102,7 @@ enum ice_status
 ice_vsi_cfg_mac_fltr(struct ice_vsi *vsi, const u8 *macaddr, bool set);
 
 bool ice_is_safe_mode(struct ice_pf *pf);
-
+bool ice_is_aux_ena(struct ice_pf *pf);
 bool ice_is_dflt_vsi_in_use(struct ice_sw *sw);
 
 bool ice_is_vsi_dflt_vsi(struct ice_sw *sw, struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 4ee85a2..e307317 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -35,6 +35,8 @@
 MODULE_PARM_DESC(debug, "netif level (0=none,...,16=all)");
 #endif /* !CONFIG_DYNAMIC_DEBUG */
 
+static DEFINE_IDA(ice_aux_ida);
+
 static struct workqueue_struct *ice_wq;
 static const struct net_device_ops ice_netdev_safe_mode_ops;
 static const struct net_device_ops ice_netdev_ops;
@@ -3276,6 +3278,12 @@ static void ice_set_pf_caps(struct ice_pf *pf)
 {
 	struct ice_hw_func_caps *func_caps = &pf->hw.func_caps;
 
+	clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
+	clear_bit(ICE_FLAG_AUX_ENA, pf->flags);
+	if (func_caps->common_cap.rdma) {
+		set_bit(ICE_FLAG_RDMA_ENA, pf->flags);
+		set_bit(ICE_FLAG_AUX_ENA, pf->flags);
+	}
 	clear_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
 	if (func_caps->common_cap.dcb)
 		set_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
@@ -3355,11 +3363,12 @@ static int ice_init_pf(struct ice_pf *pf)
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
@@ -3381,13 +3390,23 @@ static int ice_ena_msix_range(struct ice_pf *pf)
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
+	if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags)) {
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
@@ -3417,16 +3436,46 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 			err = -ERANGE;
 			goto msix_err;
 		} else {
-			int v_traffic = v_actual - v_other;
+			int v_remain = v_actual - v_other;
+			int v_rdma = 0, v_min_rdma = 0;
+
+			if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags)) {
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
+				clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
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
+			if (test_bit(ICE_FLAG_RDMA_ENA, pf->flags))
+				dev_notice(dev, "Enabled %d MSI-X vectors for RDMA.\n",
+					   pf->num_rdma_msix);
 		}
 	}
 
@@ -3441,6 +3490,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 		needed, v_left);
 	err = -ERANGE;
 exit_err:
+	pf->num_rdma_msix = 0;
 	pf->num_lan_msix = 0;
 	return err;
 }
@@ -4268,8 +4318,29 @@ static int ice_register_netdev(struct ice_pf *pf)
 
 	/* ready to go, so clear down state bit */
 	clear_bit(ICE_DOWN, pf->state);
+	if (ice_is_aux_ena(pf)) {
+		pf->aux_idx = ida_alloc(&ice_aux_ida, GFP_KERNEL);
+		if (pf->aux_idx < 0) {
+			dev_err(dev, "Failed to allocate device ID for AUX driver\n");
+			err = -ENOMEM;
+			goto err_netdev_reg;
+		}
+
+		err = ice_init_rdma(pf);
+		if (err) {
+			dev_err(dev, "Failed to initialize RDMA: %d\n", err);
+			err = -EIO;
+			goto err_init_aux_unroll;
+		}
+	} else {
+		dev_warn(dev, "RDMA is not supported on this device\n");
+	}
+
 	return 0;
 
+err_init_aux_unroll:
+	pf->adev = NULL;
+	ida_free(&ice_aux_ida, pf->aux_idx);
 err_netdev_reg:
 err_send_version_unroll:
 	ice_vsi_release_all(pf);
@@ -4383,6 +4454,7 @@ static void ice_remove(struct pci_dev *pdev)
 	ice_service_task_stop(pf);
 
 	ice_aq_cancel_waiting_tasks(pf);
+	ida_free(&ice_aux_ida, pf->aux_idx);
 
 	mutex_destroy(&(&pf->hw)->fdir_fltr_lock);
 	ice_deinit_lag(pf);
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 4474dd6..b86ae79 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -262,6 +262,7 @@ struct ice_hw_common_caps {
 	u8 rss_table_entry_width;	/* RSS Entry width in bits */
 
 	u8 dcb;
+	u8 rdma;
 
 	bool nvm_update_pending_nvm;
 	bool nvm_update_pending_orom;
-- 
1.8.3.1

