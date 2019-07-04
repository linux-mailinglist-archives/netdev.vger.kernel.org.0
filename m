Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2C045F12A
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 04:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbfGDCMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 22:12:22 -0400
Received: from mga03.intel.com ([134.134.136.65]:7957 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726955AbfGDCMU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 22:12:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jul 2019 19:12:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,449,1557212400"; 
   d="scan'208";a="315741759"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 03 Jul 2019 19:12:18 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net, dledford@redhat.com, jgg@mellanox.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, poswald@suse.com, mustafa.ismail@intel.com,
        shiraz.saleem@intel.com, Dave Ertman <david.m.ertman@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 1/3] ice: Initialize and register platform device to provide RDMA
Date:   Wed,  3 Jul 2019 19:12:50 -0700
Message-Id: <20190704021252.15534-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190704021252.15534-1-jeffrey.t.kirsher@intel.com>
References: <20190704021252.15534-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>

The RDMA block does not advertise on the PCI bus or any other bus.
Thus the ice driver needs to provide access to the RDMA hardware block
via a virtual bus; utilize the platform bus to provide this access.

This patch initializes the driver to support RDMA as well as creates
and registers a platform device for the RDMA driver to register to. At
this point the driver is fully initialized to register a platform
driver, however, can not yet register as the ops have not been
implemented.

We refer to the interaction of this platform device as Inter-Driver
Communication (IDC); where the platform device is referred to as the peer
device and the platform driver is referred to as the peer driver.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/Makefile       |   1 +
 drivers/net/ethernet/intel/ice/ice.h          |  13 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_common.c   |   5 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |  31 ++
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |   2 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_idc.c      | 427 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_idc.h      | 360 +++++++++++++++
 drivers/net/ethernet/intel/ice/ice_idc_int.h  |  67 +++
 drivers/net/ethernet/intel/ice/ice_main.c     |  42 ++
 drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
 12 files changed, 951 insertions(+)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc_int.h

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 2d140ba83781..1500f7724b6f 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -15,6 +15,7 @@ ice-y := ice_main.o	\
 	 ice_sched.o	\
 	 ice_lib.o	\
 	 ice_txrx.o	\
+	 ice_idc.o	\
 	 ice_ethtool.o
 ice-$(CONFIG_PCI_IOV) += ice_virtchnl_pf.o ice_sriov.o
 ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_lib.o
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 9ee6b55553c0..6ee2774699f0 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -38,6 +38,7 @@
 #include "ice_switch.h"
 #include "ice_common.h"
 #include "ice_sched.h"
+#include "ice_idc_int.h"
 #include "ice_virtchnl_pf.h"
 #include "ice_sriov.h"
 
@@ -84,6 +85,7 @@ extern const char ice_drv_ver[];
 #define ICE_MAX_SMALL_RSS_QS	8
 #define ICE_RES_VALID_BIT	0x8000
 #define ICE_RES_MISC_VEC_ID	(ICE_RES_VALID_BIT - 1)
+#define ICE_RES_RDMA_VEC_ID	(ICE_RES_MISC_VEC_ID - 1)
 #define ICE_INVAL_Q_INDEX	0xffff
 #define ICE_INVAL_VFID		256
 #define ICE_MAX_VF_COUNT	256
@@ -331,6 +333,7 @@ struct ice_q_vector {
 enum ice_pf_flags {
 	ICE_FLAG_MSIX_ENA,
 	ICE_FLAG_FLTR_SYNC,
+	ICE_FLAG_IWARP_ENA,
 	ICE_FLAG_RSS_ENA,
 	ICE_FLAG_SRIOV_ENA,
 	ICE_FLAG_SRIOV_CAPABLE,
@@ -373,6 +376,9 @@ struct ice_pf {
 	struct mutex avail_q_mutex;	/* protects access to avail_[rx|tx]qs */
 	struct mutex sw_mutex;		/* lock for protecting VSI alloc flow */
 	u32 msg_enable;
+	/* Total number of MSIX vectors reserved for base driver */
+	u32 num_rdma_msix;
+	u32 rdma_base_vector;
 	u32 hw_csum_rx_error;
 	u32 oicr_idx;		/* Other interrupt cause MSIX vector index */
 	u32 num_avail_sw_msix;	/* remaining MSIX SW vectors left unclaimed */
@@ -399,6 +405,7 @@ struct ice_pf {
 	unsigned long tx_timeout_last_recovery;
 	u32 tx_timeout_recovery_level;
 	char int_name[ICE_INT_NAME_STR_LEN];
+	struct ice_peer_dev_int **peers;
 	u32 sw_int_count;
 };
 
@@ -406,6 +413,8 @@ struct ice_netdev_priv {
 	struct ice_vsi *vsi;
 };
 
+extern struct ida ice_peer_index_ida;
+
 /**
  * ice_irq_dynamic_ena - Enable default interrupt generation settings
  * @hw: pointer to HW struct
@@ -463,6 +472,10 @@ int ice_set_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size);
 int ice_get_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size);
 void ice_fill_rss_lut(u8 *lut, u16 rss_table_size, u16 rss_size);
 void ice_print_link_msg(struct ice_vsi *vsi, bool isup);
+int ice_init_peer_devices(struct ice_pf *pf);
+int
+ice_for_each_peer(struct ice_pf *pf, void *data,
+		  int (*fn)(struct ice_peer_dev_int *, void *));
 #ifdef CONFIG_DCB
 int ice_pf_ena_all_vsi(struct ice_pf *pf, bool locked);
 void ice_pf_dis_all_vsi(struct ice_pf *pf, bool locked);
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 765e3c2ed045..1e1bd5f0c2a2 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -96,6 +96,7 @@ struct ice_aqc_list_caps_elem {
 #define ICE_AQC_CAPS_TXQS				0x0042
 #define ICE_AQC_CAPS_MSIX				0x0043
 #define ICE_AQC_CAPS_MAX_MTU				0x0047
+#define ICE_AQC_CAPS_IWARP				0x0051
 
 	u8 major_ver;
 	u8 minor_ver;
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 2e0731c1e1a3..2788b2ede440 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1613,6 +1613,11 @@ ice_parse_caps(struct ice_hw *hw, void *buf, u32 cap_count,
 				  "%s: MSIX first vector index = %d\n", prefix,
 				  caps->msix_vector_first_id);
 			break;
+		case ICE_AQC_CAPS_IWARP:
+			caps->iwarp = (number == 1);
+			ice_debug(hw, ICE_DBG_INIT,
+				  "%s: iWARP = %d\n", prefix, caps->iwarp);
+			break;
 		case ICE_AQC_CAPS_MAX_MTU:
 			caps->max_mtu = number;
 			ice_debug(hw, ICE_DBG_INIT, "%s: max MTU = %d\n",
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index fe88b127ca42..c6466e16eef1 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -501,6 +501,37 @@ ice_tx_prepare_vlan_flags_dcb(struct ice_ring *tx_ring,
 	return 0;
 }
 
+/**
+ * ice_setup_dcb_qos_info - Setup DCB QoS information
+ * @pf: ptr to ice_pf
+ * @qos_info: QoS param instance
+ */
+void ice_setup_dcb_qos_info(struct ice_pf *pf, struct ice_qos_params *qos_info)
+{
+	struct ice_dcbx_cfg *dcbx_cfg;
+	u32 up2tc;
+	int i;
+
+	dcbx_cfg = &pf->hw.port_info->local_dcbx_cfg;
+	up2tc = rd32(&pf->hw, PRTDCB_TUP2TC);
+	qos_info->num_apps = dcbx_cfg->numapps;
+
+	qos_info->num_tc = ice_dcb_get_num_tc(dcbx_cfg);
+
+	for (i = 0; i < ICE_IDC_MAX_USER_PRIORITY; i++)
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
 /**
  * ice_dcb_need_recfg - Check if DCB needs reconfig
  * @pf: board private structure
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
index 819081053ff5..bce3899afb3a 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
@@ -19,6 +19,7 @@ void ice_update_dcb_stats(struct ice_pf *pf);
 int
 ice_tx_prepare_vlan_flags_dcb(struct ice_ring *tx_ring,
 			      struct ice_tx_buf *first);
+void ice_setup_dcb_qos_info(struct ice_pf *pf, struct ice_qos_params *qos_info);
 void
 ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 				    struct ice_rq_event_info *event);
@@ -56,6 +57,7 @@ ice_tx_prepare_vlan_flags_dcb(struct ice_ring __always_unused *tx_ring,
 
 #define ice_update_dcb_stats(pf) do {} while (0)
 #define ice_vsi_cfg_dcb_rings(vsi) do {} while (0)
+#define ice_setup_dcb_qos_info(pf, qos_info) do {} while (0)
 #define ice_dcb_process_lldp_set_mib_change(pf, event) do {} while (0)
 #define ice_set_cgd_num(tlan_ctx, ring) do {} while (0)
 #endif /* CONFIG_DCB */
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 6c5ce05742b1..0fa393f909dd 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -55,6 +55,7 @@
 #define PRTDCB_GENS				0x00083020
 #define PRTDCB_GENS_DCBX_STATUS_S		0
 #define PRTDCB_GENS_DCBX_STATUS_M		ICE_M(0x7, 0)
+#define PRTDCB_TUP2TC				0x001D26C0
 #define GLFLXP_RXDID_FLAGS(_i, _j)		(0x0045D000 + ((_i) * 4 + (_j) * 256))
 #define GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_S	0
 #define GLFLXP_RXDID_FLAGS_FLEXIFLAG_4N_M	ICE_M(0x3F, 0)
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
new file mode 100644
index 000000000000..0bf66e9fa159
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -0,0 +1,427 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019, Intel Corporation. */
+
+/* Inter-Driver Communication */
+#include "ice.h"
+#include "ice_lib.h"
+#include "ice_dcb_lib.h"
+
+DEFINE_IDA(ice_peer_index_ida);
+
+static const struct peer_dev_id peer_dev_ids[] = ASSIGN_PEER_INFO;
+
+/**
+ * ice_peer_state_change - manage state machine for peer
+ * @peer_dev: pointer to peer's configuration
+ * @new_state: the state requested to transition into
+ * @locked: boolean to determine if call made with mutex held
+ *
+ * This function handles all state transitions for peer devices.
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
+ */
+static void
+ice_peer_state_change(struct ice_peer_dev_int *peer_dev, long new_state,
+		      bool locked)
+{
+	if (!locked)
+		mutex_lock(&peer_dev->peer_dev_state_mutex);
+
+	switch (new_state) {
+	case ICE_PEER_DEV_STATE_INIT:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_REMOVED,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_INIT, peer_dev->state);
+			dev_info(&peer_dev->peer_dev.platform_dev.dev,
+				 "state transition from _REMOVED to _INIT\n");
+		} else {
+			set_bit(ICE_PEER_DEV_STATE_INIT, peer_dev->state);
+			dev_info(&peer_dev->peer_dev.platform_dev.dev,
+				 "state set to _INIT\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_PROBED:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_INIT,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_PROBED, peer_dev->state);
+			dev_info(&peer_dev->peer_dev.platform_dev.dev,
+				 "state transition from _INIT to _PROBED\n");
+		} else if (test_and_clear_bit(ICE_PEER_DEV_STATE_REMOVED,
+					      peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_PROBED, peer_dev->state);
+			dev_info(&peer_dev->peer_dev.platform_dev.dev,
+				 "state transition from _REMOVED to _PROBED\n");
+		} else if (test_and_clear_bit(ICE_PEER_DEV_STATE_OPENING,
+					      peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_PROBED, peer_dev->state);
+			dev_info(&peer_dev->peer_dev.platform_dev.dev,
+				 "state transition from _OPENING to _PROBED\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_OPENING:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_PROBED,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_OPENING, peer_dev->state);
+			dev_info(&peer_dev->peer_dev.platform_dev.dev,
+				 "state transition from _PROBED to _OPENING\n");
+		} else if (test_and_clear_bit(ICE_PEER_DEV_STATE_CLOSED,
+					      peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_OPENING, peer_dev->state);
+			dev_info(&peer_dev->peer_dev.platform_dev.dev,
+				 "state transition from _CLOSED to _OPENING\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_OPENED:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_OPENING,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_OPENED, peer_dev->state);
+			dev_info(&peer_dev->peer_dev.platform_dev.dev,
+				 "state transition from _OPENING to _OPENED\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_PREP_RST:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_OPENED,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_PREP_RST, peer_dev->state);
+			dev_info(&peer_dev->peer_dev.platform_dev.dev,
+				 "state transition from _OPENED to _PREP_RST\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_PREPPED:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_PREP_RST,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_PREPPED, peer_dev->state);
+			dev_info(&peer_dev->peer_dev.platform_dev.dev,
+				 "state transition _PREP_RST to _PREPPED\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_CLOSING:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_OPENED,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_CLOSING, peer_dev->state);
+			dev_info(&peer_dev->peer_dev.platform_dev.dev,
+				 "state transition from _OPENED to _CLOSING\n");
+		}
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_PREPPED,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_CLOSING, peer_dev->state);
+			dev_info(&peer_dev->peer_dev.platform_dev.dev,
+				 "state transition _PREPPED to _CLOSING\n");
+		}
+		/* NOTE - up to peer to handle this situation correctly */
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_PREP_RST,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_CLOSING, peer_dev->state);
+			dev_warn(&peer_dev->peer_dev.platform_dev.dev,
+				 "WARN: Peer state PREP_RST to _CLOSING\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_CLOSED:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_CLOSING,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_CLOSED, peer_dev->state);
+			dev_info(&peer_dev->peer_dev.platform_dev.dev,
+				 "state transition from _CLOSING to _CLOSED\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_REMOVED:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_OPENED,
+				       peer_dev->state) ||
+		    test_and_clear_bit(ICE_PEER_DEV_STATE_CLOSED,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_REMOVED, peer_dev->state);
+			dev_info(&peer_dev->peer_dev.platform_dev.dev,
+				 "state from _OPENED/_CLOSED to _REMOVED\n");
+			/* Clear registration for events when peer removed */
+			bitmap_zero(peer_dev->events, ICE_PEER_DEV_STATE_NBITS);
+		}
+		break;
+	default:
+		break;
+	}
+
+	if (!locked)
+		mutex_unlock(&peer_dev->peer_dev_state_mutex);
+}
+
+/**
+ * ice_for_each_peer - iterate across and call function for each peer dev
+ * @pf: pointer to private board struct
+ * @data: data to pass to function on each call
+ * @fn: pointer to function to call for each peer
+ *
+ * This function is to be used similarly to ice_for_each_peer
+ */
+int
+ice_for_each_peer(struct ice_pf *pf, void *data,
+		  int (*fn)(struct ice_peer_dev_int *, void *))
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(peer_dev_ids); i++) {
+		struct ice_peer_dev_int *peer_dev_int;
+		int ret;
+
+		peer_dev_int = pf->peers[i];
+		if (peer_dev_int) {
+			ret = fn(peer_dev_int, data);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * ice_unreg_peer_device - unregister specified device
+ * @peer_dev_int: ptr to peer device internal
+ * @data: ptr to opaque data
+ *
+ * This function invokes device unregistration, removes ID associated with
+ * the specified device.
+ */
+int
+ice_unreg_peer_device(struct ice_peer_dev_int *peer_dev_int,
+		      void __always_unused *data)
+{
+	struct ice_pf *pf;
+
+	if (!peer_dev_int)
+		return 0;
+
+	platform_device_unregister(&peer_dev_int->peer_dev.platform_dev);
+
+	pf = pci_get_drvdata(peer_dev_int->peer_dev.pdev);
+	if (!pf)
+		return 0;
+
+	if (peer_dev_int->ice_peer_wq) {
+		if (peer_dev_int->peer_prep_task.func)
+			cancel_work_sync(&peer_dev_int->peer_prep_task);
+
+		if (peer_dev_int->peer_close_task.func)
+			cancel_work_sync(&peer_dev_int->peer_close_task);
+		destroy_workqueue(peer_dev_int->ice_peer_wq);
+	}
+
+	/* Cleanup the allocated ID for this peer device */
+	ida_simple_remove(&ice_peer_index_ida, peer_dev_int->peer_dev.index);
+
+	devm_kfree(&pf->pdev->dev, peer_dev_int);
+
+	return 0;
+}
+
+/**
+ * ice_unroll_peer - destroy peers and peer_wq in case of error
+ * @peer_dev_int: ptr to peer device internal struct
+ * @data: ptr to opaque data
+ *
+ * This function releases resources in the event of a failure in creating
+ * peer devices or their individual work_queues. Meant to be called from
+ * a ice_for_each_peer invocation
+ */
+int
+ice_unroll_peer(struct ice_peer_dev_int *peer_dev_int,
+		void __always_unused *data)
+{
+	struct ice_pf *pf;
+
+	pf = pci_get_drvdata(peer_dev_int->peer_dev.pdev);
+
+	if (peer_dev_int->ice_peer_wq)
+		destroy_workqueue(peer_dev_int->ice_peer_wq);
+	devm_kfree(&pf->pdev->dev, peer_dev_int);
+
+	return 0;
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
+		index = ice_get_res(pf, pf->irq_tracker, pf->num_rdma_msix,
+				    ICE_RES_RDMA_VEC_ID);
+		if (index < 0)
+			return index;
+		pf->num_avail_sw_msix -= pf->num_rdma_msix;
+		pf->rdma_base_vector = index;
+	}
+	return 0;
+}
+
+/**
+ * ice_peer_device_release - release function for platform peer device
+ * @dev: pointer to device structure
+ *
+ * This callback function is accessed by platform bus infrastructure when
+ * all references on the peer platform device we registered are removed
+ * (e.g. the peer priver has been removed).  We will use this opportunity
+ * to set the peer's state to init to be ready if the peer driver re-loads.
+ */
+static void ice_peer_device_release(struct device *dev)
+{
+	struct ice_peer_dev_int *peer_dev_int;
+	struct ice_peer_dev *peer_dev;
+
+	peer_dev = dev_to_ice_peer(dev);
+	peer_dev_int = container_of(peer_dev, struct ice_peer_dev_int,
+				    peer_dev);
+
+	ice_peer_state_change(peer_dev_int, ICE_PEER_DEV_STATE_INIT, false);
+}
+
+/**
+ * ice_init_peer_devices - initializes peer devices
+ * @pf: ptr to ice_pf
+ *
+ * This function initializes peer devices and associates them with specified
+ * pci_dev as their parent.
+ */
+int ice_init_peer_devices(struct ice_pf *pf)
+{
+	struct pci_dev *pdev = pf->pdev;
+	struct msix_entry *entry = NULL;
+	struct ice_port_info *port_info;
+	struct ice_vsi *vsi;
+	int status = 0;
+	int i;
+
+	/* Reserve vector resources */
+	status = ice_reserve_peer_qvector(pf);
+	if (status < 0) {
+		dev_err(&pdev->dev,
+			"failed to reserve vectors for peer drivers\n");
+		return status;
+	}
+	for (i = 0; i < ARRAY_SIZE(peer_dev_ids); i++) {
+		struct ice_peer_dev_int *peer_dev_int;
+		struct platform_device *platform_dev;
+		struct ice_qos_params *qos_info;
+		struct ice_peer_dev *peer_dev;
+		int j;
+
+		/* don't create an RDMA platform_device if NIC does not
+		 * support RDMA functionality
+		 */
+		if (peer_dev_ids[i].id == ICE_PEER_RDMA_DEV &&
+		    !test_bit(ICE_FLAG_IWARP_ENA, pf->flags)) {
+			dev_warn(&pf->pdev->dev,
+				 "RDMA not possible with this device config\n");
+			continue;
+		}
+
+		peer_dev_int = devm_kzalloc(&pdev->dev, sizeof(*peer_dev_int),
+					    GFP_KERNEL);
+		if (!peer_dev_int)
+			return -ENOMEM;
+		pf->peers[i] = peer_dev_int;
+
+		mutex_init(&peer_dev_int->peer_dev_state_mutex);
+
+		peer_dev = &peer_dev_int->peer_dev;
+		peer_dev->peer_ops = NULL;
+		peer_dev->hw_addr = (u8 __iomem *)pf->hw.hw_addr;
+		peer_dev->ver.major = ICE_PEER_MAJOR_VER;
+		peer_dev->ver.minor = ICE_PEER_MINOR_VER;
+		peer_dev->ver.support = ICE_IDC_FEATURES;
+		peer_dev->peer_dev_id = peer_dev_ids[i].id;
+		port_info = pf->hw.port_info;
+		vsi = pf->vsi[0];
+		peer_dev->pf_vsi_num = vsi->vsi_num;
+		peer_dev->netdev = vsi->netdev;
+		peer_dev->initial_mtu = vsi->netdev->mtu;
+		ether_addr_copy(peer_dev->lan_addr, port_info->mac.lan_addr);
+
+		platform_dev = &peer_dev->platform_dev;
+		platform_dev->name = peer_dev_ids[i].name;
+		platform_dev->id = PLATFORM_DEVID_AUTO;
+		platform_dev->id_auto = true;
+		platform_dev->dev.release = ice_peer_device_release;
+		platform_dev->dev.parent = &pdev->dev;
+		peer_dev_int->ice_peer_wq =
+			alloc_ordered_workqueue("ice_peer_wq_%d", WQ_UNBOUND,
+						i);
+		if (!peer_dev_int->ice_peer_wq)
+			return -ENOMEM;
+
+		/* Assign a unique index and hence name for peer device */
+		status = ida_simple_get(&ice_peer_index_ida, 0, 0, GFP_KERNEL);
+		if (status < 0) {
+			dev_err(&pdev->dev,
+				"failed to get unique index for device\n");
+			devm_kfree(&pdev->dev, peer_dev);
+			return status;
+		}
+		peer_dev->index = status;
+		peer_dev->pdev = pdev;
+		peer_dev->ari_ena = pci_ari_enabled(pdev->bus);
+		peer_dev->bus_num = PCI_BUS_NUM(pdev->devfn);
+		if (!peer_dev->ari_ena) {
+			peer_dev->dev_num = PCI_SLOT(pdev->devfn);
+			peer_dev->fn_num = PCI_FUNC(pdev->devfn);
+		} else {
+			peer_dev->dev_num = 0;
+			peer_dev->fn_num = pdev->devfn & 0xff;
+		}
+
+		qos_info = &peer_dev->initial_qos_info;
+
+		/* setup qos_info fields with defaults */
+		qos_info->num_apps = 0;
+		qos_info->num_tc = 1;
+
+		for (j = 0; j < ICE_IDC_MAX_USER_PRIORITY; j++)
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
+		switch (peer_dev_ids[i].id) {
+		case ICE_PEER_RDMA_DEV:
+			if (test_bit(ICE_FLAG_IWARP_ENA, pf->flags)) {
+				peer_dev->msix_count = pf->num_rdma_msix;
+				entry = &pf->msix_entries[pf->rdma_base_vector];
+			}
+			break;
+		default:
+			break;
+		}
+
+		peer_dev->msix_entries = entry;
+		ice_peer_state_change(peer_dev_int, ICE_PEER_DEV_STATE_INIT,
+				      false);
+		status = platform_device_register(platform_dev);
+		if (status) {
+			pr_err("Failed to register peer device %s\n",
+			       platform_dev->name);
+			return status;
+		}
+	}
+
+	return status;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.h b/drivers/net/ethernet/intel/ice/ice_idc.h
new file mode 100644
index 000000000000..d29e946fe2f1
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_idc.h
@@ -0,0 +1,360 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019, Intel Corporation. */
+
+#ifndef _ICE_IDC_H_
+#define _ICE_IDC_H_
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/if_ether.h>
+#include <linux/netdevice.h>
+#include <linux/dcbnl.h>
+#include <linux/platform_device.h>
+
+/* This major and minor version represent IDC API version information.
+ * During peer driver registration, peer driver specifies major and minor
+ * version information (via. peer_driver:ver_info). It gets checked against
+ * following defines and if mismatch, then peer driver registration
+ * fails and appropriate message gets logged.
+ */
+#define ICE_PEER_MAJOR_VER		6
+#define ICE_PEER_MINOR_VER		1
+
+enum ice_peer_features {
+	ICE_PEER_FEATURE_ADK_SUPPORT,
+	ICE_PEER_FEATURE_PTP_SUPPORT,
+	ICE_PEER_FEATURE_SRIOV_SUPPORT,
+	ICE_PEER_FEATURE_PCIIOV_SUPPORT,
+	ICE_PEER_FEATURE_NBITS
+};
+
+#define ICE_SRIOV_SUP		BIT(ICE_PEER_FEATURE_SRIOV_SUPPORT)
+
+#ifdef CONFIG_PCI_IOV
+#define ICE_PCIIOV_SUP		BIT(ICE_PEER_FEATURE_PCIIOV_SUPPORT)
+#else
+#define ICE_PCIIOV_SUP		0
+#endif /* CONFIG_PCI_IOV */
+
+#define ICE_IDC_FEATURES (ICE_SRIOV_SUP | ICE_PCIIOV_SUP)
+
+enum ice_event_type {
+	ICE_EVENT_LINK_CHANGE = 0x0,
+	ICE_EVENT_MTU_CHANGE,
+	ICE_EVENT_TC_CHANGE,
+	ICE_EVENT_API_CHANGE,
+	ICE_EVENT_MBX_CHANGE,
+	ICE_EVENT_NBITS		/* must be last */
+};
+
+enum ice_res_type {
+	ICE_INVAL_RES = 0x0,
+	ICE_VSI,
+	ICE_VEB,
+	ICE_EVENT_Q,
+	ICE_EGRESS_CMPL_Q,
+	ICE_CMPL_EVENT_Q,
+	ICE_ASYNC_EVENT_Q,
+	ICE_DOORBELL_Q,
+	ICE_RDMA_QSETS_TXSCHED,
+};
+
+enum ice_peer_reset_type {
+	ICE_PEER_PFR = 0,
+	ICE_PEER_CORER,
+	ICE_PEER_CORER_SW_CORE,
+	ICE_PEER_CORER_SW_FULL,
+	ICE_PEER_GLOBR,
+};
+
+/* reason notified to peer driver as part of event handling */
+enum ice_close_reason {
+	ICE_REASON_INVAL = 0x0,
+	ICE_REASON_HW_UNRESPONSIVE,
+	ICE_REASON_INTERFACE_DOWN, /* Administrative down */
+	ICE_REASON_PEER_DRV_UNREG, /* peer driver getting unregistered */
+	ICE_REASON_PEER_DEV_UNINIT,
+	ICE_REASON_GLOBR_REQ,
+	ICE_REASON_CORER_REQ,
+	ICE_REASON_EMPR_REQ,
+	ICE_REASON_PFR_REQ,
+	ICE_REASON_HW_RESET_PENDING,
+	ICE_REASON_PARAM_CHANGE,
+};
+
+enum ice_rdma_filter {
+	ICE_RDMA_FILTER_INVAL = 0x0,
+	ICE_RDMA_FILTER_IWARP,
+	ICE_RDMA_FILTER_ROCEV2,
+	ICE_RDMA_FILTER_BOTH,
+};
+
+/* This information is needed to handle peer driver registration,
+ * instead of adding more params to peer_drv_registration function,
+ * let's get it thru' peer_drv object.
+ */
+struct ice_ver_info {
+	u16 major;
+	u16 minor;
+	u64 support;
+};
+
+/* Struct to hold per DCB APP info */
+struct ice_dcb_app_info {
+	u8  priority;
+	u8  selector;
+	u16 prot_id;
+};
+
+struct ice_peer_dev;
+struct ice_peer_dev_int;
+
+#define ICE_IDC_MAX_USER_PRIORITY	8
+#define ICE_IDC_MAX_APPS		8
+
+/* Struct to hold per RDMA Qset info */
+struct ice_rdma_qset_params {
+	u32 teid;	/* qset TEID */
+	u16 qs_handle; /* RDMA driver provides this */
+	u16 vsi_id; /* VSI index */
+	u8 tc; /* TC branch the QSet should belong to */
+	u8 reserved[3];
+};
+
+struct ice_res_base {
+	/* Union for future provision e.g. other res_type */
+	union {
+		struct ice_rdma_qset_params qsets;
+	} res;
+};
+
+struct ice_res {
+	/* Type of resource. Filled by peer driver */
+	enum ice_res_type res_type;
+	/* Count requested by peer driver */
+	u16 cnt_req;
+
+	/* Number of resources allocated. Filled in by callee.
+	 * Based on this value, caller to fill up "resources"
+	 */
+	u16 res_allocated;
+
+	/* Unique handle to resources allocated. Zero if call fails.
+	 * Allocated by callee and for now used by caller for internal
+	 * tracking purpose.
+	 */
+	u32 res_handle;
+
+	/* Peer driver has to allocate sufficient memory, to accommodate
+	 * cnt_requested before calling this function.
+	 * Memory has to be zero initialized. It is input/output param.
+	 * As a result of alloc_res API, this structures will be populated.
+	 */
+	struct ice_res_base res[1];
+};
+
+struct ice_qos_info {
+	u64 tc_ctx;
+	u8 rel_bw;
+	u8 prio_type;
+	u8 egress_virt_up;
+	u8 ingress_virt_up;
+};
+
+/* Struct to hold QoS info */
+struct ice_qos_params {
+	struct ice_qos_info tc_info[IEEE_8021QAZ_MAX_TCS];
+	u8 up2tc[ICE_IDC_MAX_USER_PRIORITY];
+	u8 vsi_relative_bw;
+	u8 vsi_priority_type;
+	u32 num_apps;
+	struct ice_dcb_app_info apps[ICE_IDC_MAX_APPS];
+	u8 num_tc;
+};
+
+union ice_event_info {
+	/* ICE_EVENT_LINK_CHANGE */
+	struct {
+		struct net_device *lwr_nd;
+		u16 vsi_num; /* HW index of VSI corresponding to lwr ndev */
+		u8 new_link_state;
+		u8 lport;
+	} link_info;
+	/* ICE_EVENT_MTU_CHANGE */
+	u16 mtu;
+	/* ICE_EVENT_TC_CHANGE */
+	struct ice_qos_params port_qos;
+	/* ICE_EVENT_API_CHANGE */
+	u8 api_rdy;
+	/* ICE_EVENT_MBX_CHANGE */
+	u8 mbx_rdy;
+};
+
+/* ice_event elements are to be passed back and forth between the ice driver
+ * and the peer drivers. They are to be used to both register/unregister
+ * for event reporting and to report an event (events can be either ice
+ * generated or peer generated).
+ *
+ * For (un)registering for events, the structure needs to be populated with:
+ *   reporter - pointer to the ice_peer_dev struct of the peer (un)registering
+ *   type - bitmap with bits set for event types to (un)register for
+ *
+ * For reporting events, the structure needs to be populated with:
+ *   reporter - pointer to peer that generated the event (NULL for ice)
+ *   type - bitmap with single bit set for this event type
+ *   info - union containing data relevant to this event type
+ */
+struct ice_event {
+	struct ice_peer_dev *reporter;
+	DECLARE_BITMAP(type, ICE_EVENT_NBITS);
+	union ice_event_info info;
+};
+
+/* Following APIs are implemented by ICE driver and invoked by peer drivers */
+struct ice_ops {
+	/* APIs to allocate resources such as VEB, VSI, Doorbell queues,
+	 * completion queues, Tx/Rx queues, etc...
+	 */
+	int (*alloc_res)(struct ice_peer_dev *peer_dev,
+			 struct ice_res *res,
+			 int partial_acceptable);
+	int (*free_res)(struct ice_peer_dev *peer_dev,
+			struct ice_res *res);
+
+	int (*is_vsi_ready)(struct ice_peer_dev *peer_dev);
+	int (*peer_register)(struct ice_peer_dev *peer_dev);
+	int (*peer_unregister)(struct ice_peer_dev *peer_dev);
+	int (*request_reset)(struct ice_peer_dev *dev,
+			     enum ice_peer_reset_type reset_type);
+
+	void (*notify_state_change)(struct ice_peer_dev *dev,
+				    struct ice_event *event);
+
+	/* Notification APIs */
+	void (*reg_for_notification)(struct ice_peer_dev *dev,
+				     struct ice_event *event);
+	void (*unreg_for_notification)(struct ice_peer_dev *dev,
+				       struct ice_event *event);
+	int (*update_vsi_filter)(struct ice_peer_dev *peer_dev,
+				 enum ice_rdma_filter filter, bool enable);
+	int (*vc_send)(struct ice_peer_dev *peer_dev, u32 vf_id, u8 *msg,
+		       u16 len);
+};
+
+/* Following APIs are implemented by peer drivers and invoked by ICE driver */
+struct ice_peer_ops {
+	void (*event_handler)(struct ice_peer_dev *peer_dev,
+			      struct ice_event *event);
+
+	/* Why we have 'open' and when it is expected to be called:
+	 * 1. symmetric set of API w.r.t close
+	 * 2. To be invoked form driver initialization path
+	 *     - call peer_driver:open once ice driver is fully initialized
+	 * 3. To be invoked upon RESET complete
+	 *
+	 * Calls to open are performed from ice_finish_init_peer_device
+	 * which is invoked from the service task. This helps keep devices
+	 * from having their open called until the ice driver is ready and
+	 * has scheduled its service task.
+	 */
+	int (*open)(struct ice_peer_dev *peer_dev);
+
+	/* Peer's close function is to be called when the peer needs to be
+	 * quiesced. This can be for a variety of reasons (enumerated in the
+	 * ice_close_reason enum struct). A call to close will only be
+	 * followed by a call to either remove or open. No IDC calls from the
+	 * peer should be accepted until it is re-opened.
+	 *
+	 * The *reason* parameter is the reason for the call to close. This
+	 * can be for any reason enumerated in the ice_close_reason struct.
+	 * It's primary reason is for the peer's bookkeeping and in case the
+	 * peer want to perform any different tasks dictated by the reason.
+	 */
+	void (*close)(struct ice_peer_dev *peer_dev,
+		      enum ice_close_reason reason);
+
+	int (*vc_receive)(struct ice_peer_dev *peer_dev, u32 vf_id, u8 *msg,
+			  u16 len);
+	/* tell RDMA peer to prepare for TC change in a blocking call
+	 * that will directly precede the change event
+	 */
+	void (*prep_tc_change)(struct ice_peer_dev *peer_dev);
+};
+
+#define ICE_PEER_RDMA_NAME	"ice_rdma"
+#define ICE_PEER_RDMA_DEV	0x00000010
+#define ICE_MAX_NUM_PEERS	4
+
+/* The const struct that instantiates peer_dev_id needs to be initialized
+ * in the .c with the macro ASSIGN_PEER_INFO.
+ * For example:
+ * static const struct peer_dev_id peer_dev_ids[] = ASSIGN_PEER_INFO;
+ */
+struct peer_dev_id {
+	char *name;
+	int id;
+};
+
+#define ASSIGN_PEER_INFO					\
+{								\
+	{ ICE_PEER_RDMA_NAME, ICE_PEER_RDMA_DEV },		\
+}
+
+/* structure representing peer device */
+struct ice_peer_dev {
+	struct platform_device platform_dev;
+	struct ice_ver_info ver;
+	struct pci_dev *pdev; /* PCI device of corresponding to main function */
+	/* KVA / Linear address corresponding to BAR0 of underlying
+	 * pci_device.
+	 */
+	u8 __iomem *hw_addr;
+	int peer_dev_id;
+
+	unsigned int index;
+
+	u8 ftype;	/* PF(false) or VF (true) */
+
+	/* Data VSI created by driver */
+	u16 pf_vsi_num;
+
+	u8 lan_addr[ETH_ALEN]; /* default MAC address of main netdev */
+	u16 initial_mtu; /* Initial MTU of main netdev */
+	struct ice_qos_params initial_qos_info;
+	struct net_device *netdev;
+	/* PCI info */
+	u8 ari_ena;
+	u16 bus_num;
+	u16 dev_num;
+	u16 fn_num;
+
+	/* Based on peer driver type, this shall point to corresponding MSIx
+	 * entries in pf->msix_entries (which were allocated as part of driver
+	 * initialization) e.g. for RDMA driver, msix_entries reserved will be
+	 * num_online_cpus + 1.
+	 */
+	u16 msix_count; /* How many vectors are reserved for this device */
+	struct msix_entry *msix_entries;
+
+	/* Following struct contains function pointers to be initialized
+	 * by ICE driver and called by peer driver
+	 */
+	const struct ice_ops *ops;
+
+	/* Following struct contains function pointers to be initialized
+	 * by peer driver and called by ICE driver
+	 */
+	const struct ice_peer_ops *peer_ops;
+
+	/* Pointer to peer_drv struct to be populated by peer driver */
+	struct ice_peer_drv *peer_drv;
+};
+
+static inline struct ice_peer_dev *dev_to_ice_peer(struct device *_dev)
+{
+	struct platform_device *platform_dev;
+
+	platform_dev = container_of(_dev, struct platform_device, dev);
+	return container_of(platform_dev, struct ice_peer_dev, platform_dev);
+}
+#endif /* _ICE_IDC_H_*/
diff --git a/drivers/net/ethernet/intel/ice/ice_idc_int.h b/drivers/net/ethernet/intel/ice/ice_idc_int.h
new file mode 100644
index 000000000000..f8ff8cac7a26
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_idc_int.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019, Intel Corporation. */
+
+#ifndef _ICE_IDC_INT_H_
+#define _ICE_IDC_INT_H_
+
+#include "ice_idc.h"
+
+int ice_unroll_peer(struct ice_peer_dev_int *peer_dev_int, void *data);
+int ice_unreg_peer_device(struct ice_peer_dev_int *peer_dev_int, void *data);
+
+enum ice_peer_dev_state {
+	ICE_PEER_DEV_STATE_INIT,
+	ICE_PEER_DEV_STATE_PROBED,
+	ICE_PEER_DEV_STATE_OPENING,
+	ICE_PEER_DEV_STATE_OPENED,
+	ICE_PEER_DEV_STATE_PREP_RST,
+	ICE_PEER_DEV_STATE_PREPPED,
+	ICE_PEER_DEV_STATE_CLOSING,
+	ICE_PEER_DEV_STATE_CLOSED,
+	ICE_PEER_DEV_STATE_REMOVED,
+	ICE_PEER_DEV_STATE_API_RDY,
+	ICE_PEER_DEV_STATE_NBITS,	/* must be last */
+};
+
+enum ice_peer_drv_state {
+	ICE_PEER_DRV_STATE_MBX_RDY,
+	ICE_PEER_DRV_STATE_NBITS,	/* must be last */
+};
+
+struct ice_peer_drv_int {
+	struct ice_peer_drv *peer_drv;
+	struct ice_peer_dev *peer_dev;
+
+	/* States associated with peer driver */
+	DECLARE_BITMAP(state, ICE_PEER_DRV_STATE_NBITS);
+
+	/* if this peer_dev is the originator of an event, these are the
+	 * most recent events of each type
+	 */
+	struct ice_event current_events[ICE_EVENT_NBITS];
+};
+
+struct ice_peer_dev_int {
+	struct ice_peer_dev peer_dev; /* public structure */
+	struct ice_peer_drv_int *peer_drv_int; /* driver private structure */
+
+	/* if this peer_dev is the originator of an event, these are the
+	 * most recent events of each type
+	 */
+	struct ice_event current_events[ICE_EVENT_NBITS];
+	/* Events a peer has registered to be notified about */
+	DECLARE_BITMAP(events, ICE_EVENT_NBITS);
+
+	/* States associated with peer device */
+	DECLARE_BITMAP(state, ICE_PEER_DEV_STATE_NBITS);
+	struct mutex peer_dev_state_mutex; /* peer_dev state mutex */
+
+	/* per peer workqueue */
+	struct workqueue_struct *ice_peer_wq;
+
+	struct work_struct peer_prep_task;
+	struct work_struct peer_close_task;
+
+	enum ice_close_reason rst_type;
+};
+#endif /* !_ICE_IDC_INT_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 28ec0d57941d..08bce0d67634 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2092,6 +2092,8 @@ static void ice_init_pf(struct ice_pf *pf)
 {
 	bitmap_zero(pf->flags, ICE_PF_FLAGS_NBITS);
 	set_bit(ICE_FLAG_MSIX_ENA, pf->flags);
+	if (pf->hw.func_caps.common_cap.iwarp)
+		set_bit(ICE_FLAG_IWARP_ENA, pf->flags);
 #ifdef CONFIG_PCI_IOV
 	if (pf->hw.func_caps.common_cap.sr_iov_1_1) {
 		struct ice_hw *hw = &pf->hw;
@@ -2145,6 +2147,17 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 	v_budget += pf->num_lan_msix;
 	v_left -= pf->num_lan_msix;
 
+	/* reserve vectors for RDMA peer driver */
+	if (test_bit(ICE_FLAG_IWARP_ENA, pf->flags)) {
+		/* RDMA peer driver needs one extra to handle misc causes */
+		needed = min_t(int, num_online_cpus(), v_left) + 1;
+		if (v_left < needed)
+			goto no_vecs_left_err;
+		pf->num_rdma_msix = needed;
+		v_budget += needed;
+		v_left -= needed;
+	}
+
 	pf->msix_entries = devm_kcalloc(&pf->pdev->dev, v_budget,
 					sizeof(*pf->msix_entries), GFP_KERNEL);
 
@@ -2171,6 +2184,8 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 			 "not enough vectors. requested = %d, obtained = %d\n",
 			 v_budget, v_actual);
 		if (v_actual >= (pf->num_lan_msix + 1)) {
+			clear_bit(ICE_FLAG_IWARP_ENA, pf->flags);
+			pf->num_rdma_msix = 0;
 			pf->num_avail_sw_msix = v_actual -
 						(pf->num_lan_msix + 1);
 		} else if (v_actual >= 2) {
@@ -2189,6 +2204,11 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 	devm_kfree(&pf->pdev->dev, pf->msix_entries);
 	goto exit_err;
 
+no_vecs_left_err:
+	dev_err(&pf->pdev->dev,
+		"not enough vectors. requested = %d, available = %d\n",
+		needed, v_left);
+	err = -ERANGE;
 exit_err:
 	pf->num_lan_msix = 0;
 	clear_bit(ICE_FLAG_MSIX_ENA, pf->flags);
@@ -2351,6 +2371,12 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
 	ice_init_pf(pf);
 
+	pf->peers = devm_kcalloc(dev, ICE_MAX_NUM_PEERS, sizeof(*pf->peers),
+				 GFP_KERNEL);
+	if (!pf->peers) {
+		err = -ENOMEM;
+		goto err_init_peer_unroll;
+	}
 	err = ice_init_pf_dcb(pf, false);
 	if (err) {
 		clear_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
@@ -2432,10 +2458,20 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		goto err_alloc_sw_unroll;
 	}
 
+	err = ice_init_peer_devices(pf);
+	if (err) {
+		dev_err(dev, "Failed to initialize peer devices: 0x%x\n", err);
+		err = -EIO;
+		goto err_init_peer_unroll;
+	}
+
 	ice_verify_cacheline_size(pf);
 
 	return 0;
 
+	/* Unwind non-managed device resources, etc. if something failed */
+err_init_peer_unroll:
+	ice_for_each_peer(pf, NULL, ice_unroll_peer);
 err_alloc_sw_unroll:
 	set_bit(__ICE_SERVICE_DIS, pf->state);
 	set_bit(__ICE_DOWN, pf->state);
@@ -2477,6 +2513,7 @@ static void ice_remove(struct pci_dev *pdev)
 	if (test_bit(ICE_FLAG_SRIOV_ENA, pf->flags))
 		ice_free_vfs(pf);
 	ice_vsi_release_all(pf);
+	ice_for_each_peer(pf, NULL, ice_unreg_peer_device);
 	ice_free_irq_msix_misc(pf);
 	ice_for_each_vsi(pf, i) {
 		if (!pf->vsi[i])
@@ -2676,6 +2713,7 @@ static int __init ice_module_init(void)
 	if (status) {
 		pr_err("failed to register PCI driver, err %d\n", status);
 		destroy_workqueue(ice_wq);
+		ida_destroy(&ice_peer_index_ida);
 	}
 
 	return status;
@@ -2692,6 +2730,10 @@ static void __exit ice_module_exit(void)
 {
 	pci_unregister_driver(&ice_driver);
 	destroy_workqueue(ice_wq);
+	/* release all cached layer within ida tree, associated with
+	 * ice_peer_index_ida object
+	 */
+	ida_destroy(&ice_peer_index_ida);
 	pr_info("module unloaded\n");
 }
 module_exit(ice_module_exit);
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 24bbef8bbe69..99822b4e8621 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -161,6 +161,7 @@ struct ice_hw_common_caps {
 	u8 rss_table_entry_width;	/* RSS Entry width in bits */
 
 	u8 dcb;
+	u8 iwarp;
 };
 
 /* Function specific capabilities */
-- 
2.21.0

