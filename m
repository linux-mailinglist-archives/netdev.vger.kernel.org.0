Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CE61AE351
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 19:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbgDQRKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 13:10:49 -0400
Received: from mga06.intel.com ([134.134.136.31]:24555 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727986AbgDQRKp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 13:10:45 -0400
IronPort-SDR: TrELN0eADDGokKWdfsNEsrJXpQSPsobHVbpRf+OtNt5jZQ3Pc+buMSkyubo1hBxjPzjZRpovuE
 cbqkL0I/8WKg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 10:10:40 -0700
IronPort-SDR: sq75+P4+FRy99+2qQ5IFLLFimsHY6/SQIXrhSFMUJPWwzUAaLZyJUm39HYdSY60KJaz6uCf4+N
 BftBaryKB25A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="278442112"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 17 Apr 2020 10:10:39 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net, gregkh@linuxfoundation.org
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, jgg@ziepe.ca,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 2/9] ice: Create and register virtual bus for RDMA
Date:   Fri, 17 Apr 2020 10:10:27 -0700
Message-Id: <20200417171034.1533253-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200417171034.1533253-1-jeffrey.t.kirsher@intel.com>
References: <20200417171034.1533253-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

The RDMA block does not have its own PCI function, instead it must utilize
the ice driver to gain access to the PCI device. Create a virtual bus
device so the irdma driver can register a virtual bus driver to bind to it
and receive device data. The device data contains all of the relevant
information that the irdma peer will need to access this PF's IIDC API
callbacks.

Note the header file iidc.h is located under include/linux/net/intel
as this is a unified header file to be used by all consumers of the
IIDC interface.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 MAINTAINERS                                   |   1 +
 drivers/net/ethernet/intel/Kconfig            |   1 +
 drivers/net/ethernet/intel/ice/Makefile       |   1 +
 drivers/net/ethernet/intel/ice/ice.h          |  13 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  18 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |  31 ++
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |   3 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_idc.c      | 400 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_idc_int.h  |  67 +++
 drivers/net/ethernet/intel/ice/ice_lib.c      |  11 +
 drivers/net/ethernet/intel/ice/ice_lib.h      |   2 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  56 ++-
 drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
 include/linux/net/intel/iidc.h                | 337 +++++++++++++++
 16 files changed, 941 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc_int.h
 create mode 100644 include/linux/net/intel/iidc.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 6851ef7cf1bd..473f4ee5192a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8551,6 +8551,7 @@ F:	Documentation/networking/device_drivers/intel/ixgbevf.rst
 F:	drivers/net/ethernet/intel/
 F:	drivers/net/ethernet/intel/*/
 F:	include/linux/avf/virtchnl.h
+F:	include/linux/net/intel/iidc.h
 
 INTEL FRAMEBUFFER DRIVER (excluding 810 and 815)
 M:	Maik Broemme <mbroemme@libmpq.org>
diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index ad34e4335df2..1a5d51b0f294 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -272,6 +272,7 @@ config I40EVF
 	tristate "Intel(R) Ethernet Adaptive Virtual Function support"
 	select IAVF
 	depends on PCI_MSI
+	select VIRTUAL_BUS
 	---help---
 	  This driver supports virtual functions for Intel XL710,
 	  X710, X722, XXV710, and all devices advertising support for
diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 29c6c6743450..73909045da1c 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -20,6 +20,7 @@ ice-y := ice_main.o	\
 	 ice_flex_pipe.o \
 	 ice_flow.o	\
 	 ice_devlink.o	\
+	 ice_idc.o	\
 	 ice_ethtool.o
 ice-$(CONFIG_PCI_IOV) += ice_virtchnl_pf.o ice_sriov.o
 ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_nl.o ice_dcb_lib.o
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 5c11448bfbb3..529a6743fd4e 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -33,6 +33,7 @@
 #include <linux/if_bridge.h>
 #include <linux/ctype.h>
 #include <linux/bpf.h>
+#include <linux/virtual_bus.h>
 #include <linux/avf/virtchnl.h>
 #include <net/devlink.h>
 #include <net/ipv6.h>
@@ -44,6 +45,7 @@
 #include "ice_switch.h"
 #include "ice_common.h"
 #include "ice_sched.h"
+#include "ice_idc_int.h"
 #include "ice_virtchnl_pf.h"
 #include "ice_sriov.h"
 #include "ice_xsk.h"
@@ -72,6 +74,8 @@ extern const char ice_drv_ver[];
 #define ICE_MAX_LG_RSS_QS	256
 #define ICE_RES_VALID_BIT	0x8000
 #define ICE_RES_MISC_VEC_ID	(ICE_RES_VALID_BIT - 1)
+#define ICE_RDMA_NUM_VECS	4
+#define ICE_RES_RDMA_VEC_ID	(ICE_RES_MISC_VEC_ID - 1)
 #define ICE_INVAL_Q_INDEX	0xffff
 #define ICE_INVAL_VFID		256
 
@@ -330,11 +334,13 @@ struct ice_q_vector {
 
 enum ice_pf_flags {
 	ICE_FLAG_FLTR_SYNC,
+	ICE_FLAG_IWARP_ENA,
 	ICE_FLAG_RSS_ENA,
 	ICE_FLAG_SRIOV_ENA,
 	ICE_FLAG_SRIOV_CAPABLE,
 	ICE_FLAG_DCB_CAPABLE,
 	ICE_FLAG_DCB_ENA,
+	ICE_FLAG_PEER_ENA,
 	ICE_FLAG_ADV_FEATURES,
 	ICE_FLAG_LINK_DOWN_ON_CLOSE_ENA,
 	ICE_FLAG_NO_MEDIA,
@@ -384,6 +390,8 @@ struct ice_pf {
 	struct mutex sw_mutex;		/* lock for protecting VSI alloc flow */
 	struct mutex tc_mutex;		/* lock to protect TC changes */
 	u32 msg_enable;
+	u32 num_rdma_msix;	/* Total MSIX vectors for RDMA driver */
+	u32 rdma_base_vector;
 	u32 hw_csum_rx_error;
 	u32 oicr_idx;		/* Other interrupt cause MSIX vector index */
 	u32 num_avail_sw_msix;	/* remaining MSIX SW vectors left unclaimed */
@@ -410,6 +418,7 @@ struct ice_pf {
 	unsigned long tx_timeout_last_recovery;
 	u32 tx_timeout_recovery_level;
 	char int_name[ICE_INT_NAME_STR_LEN];
+	struct ice_peer_dev_int **peers;
 	u32 sw_int_count;
 };
 
@@ -523,6 +532,10 @@ int ice_get_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size);
 void ice_fill_rss_lut(u8 *lut, u16 rss_table_size, u16 rss_size);
 int ice_schedule_reset(struct ice_pf *pf, enum ice_reset_req reset);
 void ice_print_link_msg(struct ice_vsi *vsi, bool isup);
+int ice_init_peer_devices(struct ice_pf *pf);
+int
+ice_for_each_peer(struct ice_pf *pf, void *data,
+		  int (*fn)(struct ice_peer_dev_int *, void *));
 int ice_open(struct net_device *netdev);
 int ice_stop(struct net_device *netdev);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 2381b4014ed6..51baab0621a2 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -108,6 +108,7 @@ struct ice_aqc_list_caps_elem {
 #define ICE_AQC_CAPS_TXQS				0x0042
 #define ICE_AQC_CAPS_MSIX				0x0043
 #define ICE_AQC_CAPS_MAX_MTU				0x0047
+#define ICE_AQC_CAPS_IWARP				0x0051
 
 	u8 major_ver;
 	u8 minor_ver;
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 2c0d8fd3d5cd..2dca49aed5bb 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -825,7 +825,8 @@ enum ice_status ice_check_reset(struct ice_hw *hw)
 				 GLNVM_ULD_POR_DONE_1_M |\
 				 GLNVM_ULD_PCIER_DONE_2_M)
 
-	uld_mask = ICE_RESET_DONE_MASK;
+	uld_mask = ICE_RESET_DONE_MASK | (hw->func_caps.common_cap.iwarp ?
+					  GLNVM_ULD_PE_DONE_M : 0);
 
 	/* Device is Active; check Global Reset processes are done */
 	for (cnt = 0; cnt < ICE_PF_RESET_WAIT_COUNT; cnt++) {
@@ -1678,6 +1679,11 @@ ice_parse_caps(struct ice_hw *hw, void *buf, u32 cap_count,
 				  "%s: msix_vector_first_id = %d\n", prefix,
 				  caps->msix_vector_first_id);
 			break;
+		case ICE_AQC_CAPS_IWARP:
+			caps->iwarp = (number == 1);
+			ice_debug(hw, ICE_DBG_INIT,
+				  "%s: iwarp = %d\n", prefix, caps->iwarp);
+			break;
 		case ICE_AQC_CAPS_MAX_MTU:
 			caps->max_mtu = number;
 			ice_debug(hw, ICE_DBG_INIT, "%s: max_mtu = %d\n",
@@ -1701,6 +1707,16 @@ ice_parse_caps(struct ice_hw *hw, void *buf, u32 cap_count,
 		ice_debug(hw, ICE_DBG_INIT,
 			  "%s: maxtc = %d (based on #ports)\n", prefix,
 			  caps->maxtc);
+		if (caps->iwarp) {
+			ice_debug(hw, ICE_DBG_INIT, "%s: forcing RDMA off\n",
+				  prefix);
+			caps->iwarp = 0;
+		}
+
+		/* print message only when processing device capabilities */
+		if (dev_p)
+			dev_info(ice_hw_to_dev(hw),
+				 "RDMA functionality is not available with the current device configuration.\n");
 	}
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 7bea09363b42..24c0a60fe172 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -763,6 +763,37 @@ ice_tx_prepare_vlan_flags_dcb(struct ice_ring *tx_ring,
 	return 0;
 }
 
+/**
+ * ice_setup_dcb_qos_info - Setup DCB QoS information
+ * @pf: ptr to ice_pf
+ * @qos_info: QoS param instance
+ */
+void ice_setup_dcb_qos_info(struct ice_pf *pf, struct iidc_qos_params *qos_info)
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
 /**
  * ice_dcb_process_lldp_set_mib_change - Process MIB change
  * @pf: ptr to ice_pf
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
index 37680e815b02..11457b6ba145 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
@@ -29,6 +29,8 @@ int
 ice_tx_prepare_vlan_flags_dcb(struct ice_ring *tx_ring,
 			      struct ice_tx_buf *first);
 void
+ice_setup_dcb_qos_info(struct ice_pf *pf, struct iidc_qos_params *qos_info);
+void
 ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 				    struct ice_rq_event_info *event);
 void ice_vsi_cfg_netdev_tc(struct ice_vsi *vsi, u8 ena_tc);
@@ -82,6 +84,7 @@ ice_tx_prepare_vlan_flags_dcb(struct ice_ring __always_unused *tx_ring,
 #define ice_update_dcb_stats(pf) do {} while (0)
 #define ice_pf_dcb_recfg(pf) do {} while (0)
 #define ice_vsi_cfg_dcb_rings(vsi) do {} while (0)
+#define ice_setup_dcb_qos_info(pf, qos_info) do {} while (0)
 #define ice_dcb_process_lldp_set_mib_change(pf, event) do {} while (0)
 #define ice_set_cgd_num(tlan_ctx, ring) do {} while (0)
 #define ice_vsi_cfg_netdev_tc(vsi, ena_tc) do {} while (0)
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 1d37a9f02c1c..3f40736a8295 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -58,6 +58,7 @@
 #define PRTDCB_GENS				0x00083020
 #define PRTDCB_GENS_DCBX_STATUS_S		0
 #define PRTDCB_GENS_DCBX_STATUS_M		ICE_M(0x7, 0)
+#define PRTDCB_TUP2TC				0x001D26C0
 #define GL_PREEXT_L2_PMASK0(_i)			(0x0020F0FC + ((_i) * 4))
 #define GL_PREEXT_L2_PMASK1(_i)			(0x0020F108 + ((_i) * 4))
 #define GLFLXP_RXDID_FLX_WRD_0(_i)		(0x0045c800 + ((_i) * 4))
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
new file mode 100644
index 000000000000..ffd13e13a15e
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -0,0 +1,400 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019, Intel Corporation. */
+
+/* Inter-Driver Communication */
+#include "ice.h"
+#include "ice_lib.h"
+#include "ice_dcb_lib.h"
+
+static struct peer_dev_id ice_peers[] = ASSIGN_PEER_INFO;
+
+/**
+ * ice_peer_state_change - manage state machine for peer
+ * @peer_dev: pointer to peer's configuration
+ * @new_state: the state requested to transition into
+ * @locked: boolean to determine if call made with mutex held
+ *
+ * Any function that calls this is responsible for verifying that
+ * the peer_dev_int struct is valid and capable of handling a
+ * state change
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
+	struct device *dev = &peer_dev->peer_dev.vdev->dev;
+
+	if (!locked)
+		mutex_lock(&peer_dev->peer_dev_state_mutex);
+
+	switch (new_state) {
+	case ICE_PEER_DEV_STATE_INIT:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_REMOVED,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_INIT, peer_dev->state);
+			dev_dbg(dev, "state transition from _REMOVED to _INIT\n");
+		} else {
+			set_bit(ICE_PEER_DEV_STATE_INIT, peer_dev->state);
+			if (dev)
+				dev_dbg(dev, "state set to _INIT\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_PROBED:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_INIT,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_PROBED, peer_dev->state);
+			dev_dbg(dev, "state transition from _INIT to _PROBED\n");
+		} else if (test_and_clear_bit(ICE_PEER_DEV_STATE_REMOVED,
+					      peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_PROBED, peer_dev->state);
+			dev_dbg(dev, "state transition from _REMOVED to _PROBED\n");
+		} else if (test_and_clear_bit(ICE_PEER_DEV_STATE_OPENING,
+					      peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_PROBED, peer_dev->state);
+			dev_dbg(dev, "state transition from _OPENING to _PROBED\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_OPENING:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_PROBED,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_OPENING, peer_dev->state);
+			dev_dbg(dev, "state transition from _PROBED to _OPENING\n");
+		} else if (test_and_clear_bit(ICE_PEER_DEV_STATE_CLOSED,
+					      peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_OPENING, peer_dev->state);
+			dev_dbg(dev, "state transition from _CLOSED to _OPENING\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_OPENED:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_OPENING,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_OPENED, peer_dev->state);
+			dev_dbg(dev, "state transition from _OPENING to _OPENED\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_PREP_RST:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_OPENED,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_PREP_RST, peer_dev->state);
+			dev_dbg(dev, "state transition from _OPENED to _PREP_RST\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_PREPPED:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_PREP_RST,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_PREPPED, peer_dev->state);
+			dev_dbg(dev, "state transition _PREP_RST to _PREPPED\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_CLOSING:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_OPENED,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_CLOSING, peer_dev->state);
+			dev_dbg(dev, "state transition from _OPENED to _CLOSING\n");
+		}
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_PREPPED,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_CLOSING, peer_dev->state);
+			dev_dbg(dev, "state transition _PREPPED to _CLOSING\n");
+		}
+		/* NOTE - up to peer to handle this situation correctly */
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_PREP_RST,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_CLOSING, peer_dev->state);
+			dev_warn(dev, "WARN: Peer state PREP_RST to _CLOSING\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_CLOSED:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_CLOSING,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_CLOSED, peer_dev->state);
+			dev_dbg(dev, "state transition from _CLOSING to _CLOSED\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_REMOVED:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_OPENED,
+				       peer_dev->state) ||
+		    test_and_clear_bit(ICE_PEER_DEV_STATE_CLOSED,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_REMOVED, peer_dev->state);
+			dev_dbg(dev, "state from _OPENED/_CLOSED to _REMOVED\n");
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
+ */
+int
+ice_for_each_peer(struct ice_pf *pf, void *data,
+		  int (*fn)(struct ice_peer_dev_int *, void *))
+{
+	unsigned int i;
+
+	if (!pf->peers)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(ice_peers); i++) {
+		struct ice_peer_dev_int *peer_dev_int;
+
+		peer_dev_int = pf->peers[i];
+		if (peer_dev_int) {
+			int ret = fn(peer_dev_int, data);
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
+	struct ice_peer_drv_int *peer_drv_int;
+
+	if (!peer_dev_int)
+		return 0;
+
+	virtbus_unregister_device(peer_dev_int->peer_dev.vdev);
+
+	peer_drv_int = peer_dev_int->peer_drv_int;
+
+	if (peer_dev_int->ice_peer_wq) {
+		if (peer_dev_int->peer_prep_task.func)
+			cancel_work_sync(&peer_dev_int->peer_prep_task);
+		destroy_workqueue(peer_dev_int->ice_peer_wq);
+	}
+
+	kfree(peer_drv_int);
+
+	kfree(peer_dev_int);
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
+	if (peer_dev_int->ice_peer_wq)
+		destroy_workqueue(peer_dev_int->ice_peer_wq);
+	kfree(peer_dev_int);
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
+ * ice_peer_vdev_release - function to map to virtbus_devices release callback
+ * @vdev: pointer to virtbus_device to free
+ */
+static void ice_peer_vdev_release(struct virtbus_device *vdev)
+{
+	struct iidc_virtbus_object *vbo;
+
+	vbo = container_of(vdev, struct iidc_virtbus_object, vdev);
+	kfree(vbo);
+}
+
+/**
+ * ice_init_peer_devices - initializes peer devices
+ * @pf: ptr to ice_pf
+ *
+ * This function initializes peer devices on the virtual bus.
+ */
+int ice_init_peer_devices(struct ice_pf *pf)
+{
+	struct ice_vsi *vsi = pf->vsi[0];
+	struct pci_dev *pdev = pf->pdev;
+	struct device *dev = &pdev->dev;
+	int status = 0;
+	unsigned int i;
+
+	/* Reserve vector resources */
+	status = ice_reserve_peer_qvector(pf);
+	if (status < 0) {
+		dev_err(dev, "failed to reserve vectors for peer drivers\n");
+		return status;
+	}
+	for (i = 0; i < ARRAY_SIZE(ice_peers); i++) {
+		struct ice_peer_dev_int *peer_dev_int;
+		struct ice_peer_drv_int *peer_drv_int;
+		struct iidc_qos_params *qos_info;
+		struct iidc_virtbus_object *vbo;
+		struct msix_entry *entry = NULL;
+		struct iidc_peer_dev *peer_dev;
+		struct virtbus_device *vdev;
+		int j;
+
+		/* structure layout needed for container_of's looks like:
+		 * ice_peer_dev_int (internal only ice peer superstruct)
+		 * |--> iidc_peer_dev
+		 * |--> *ice_peer_drv_int
+		 *
+		 * iidc_virtbus_object (container_of parent for vdev)
+		 * |--> virtbus_device
+		 * |--> *iidc_peer_dev (pointer from internal struct)
+		 *
+		 * ice_peer_drv_int (internal only peer_drv struct)
+		 */
+		peer_dev_int = kzalloc(sizeof(*peer_dev_int), GFP_KERNEL);
+		if (!peer_dev_int)
+			return -ENOMEM;
+
+		vbo = kzalloc(sizeof(*vbo), GFP_KERNEL);
+		if (!vbo) {
+			kfree(peer_dev_int);
+			return -ENOMEM;
+		}
+
+		peer_drv_int = kzalloc(sizeof(*peer_drv_int), GFP_KERNEL);
+		if (!peer_drv_int) {
+			kfree(peer_dev_int);
+			kfree(vbo);
+			return -ENOMEM;
+		}
+
+		pf->peers[i] = peer_dev_int;
+		vbo->peer_dev = &peer_dev_int->peer_dev;
+		peer_dev_int->peer_drv_int = peer_drv_int;
+		peer_dev_int->peer_dev.vdev = &vbo->vdev;
+
+		/* Initialize driver values */
+		for (j = 0; j < IIDC_EVENT_NBITS; j++)
+			bitmap_zero(peer_drv_int->current_events[j].type,
+				    IIDC_EVENT_NBITS);
+
+		mutex_init(&peer_dev_int->peer_dev_state_mutex);
+
+		peer_dev = &peer_dev_int->peer_dev;
+		peer_dev->peer_ops = NULL;
+		peer_dev->hw_addr = (u8 __iomem *)pf->hw.hw_addr;
+		peer_dev->peer_dev_id = ice_peers[i].id;
+		peer_dev->pf_vsi_num = vsi->vsi_num;
+		peer_dev->netdev = vsi->netdev;
+
+		peer_dev_int->ice_peer_wq =
+			alloc_ordered_workqueue("ice_peer_wq_%d", WQ_UNBOUND,
+						i);
+		if (!peer_dev_int->ice_peer_wq) {
+			kfree(peer_dev_int);
+			kfree(peer_drv_int);
+			kfree(vbo);
+			return -ENOMEM;
+		}
+
+		peer_dev->pdev = pdev;
+		qos_info = &peer_dev->initial_qos_info;
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
+
+		vdev = &vbo->vdev;
+		vdev->name = ice_peers[i].name;
+		vdev->release = ice_peer_vdev_release;
+		vdev->dev.parent = &pdev->dev;
+
+		status = virtbus_register_device(vdev);
+		if (status) {
+			kfree(peer_dev_int);
+			kfree(peer_drv_int);
+			vdev = NULL;
+			return status;
+		}
+	}
+
+	return status;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_idc_int.h b/drivers/net/ethernet/intel/ice/ice_idc_int.h
new file mode 100644
index 000000000000..daac19c45490
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_idc_int.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019, Intel Corporation. */
+
+#ifndef _ICE_IDC_INT_H_
+#define _ICE_IDC_INT_H_
+
+#include <linux/net/intel/iidc.h>
+#include "ice.h"
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
+	ICE_PEER_DEV_STATE_NBITS,               /* must be last */
+};
+
+enum ice_peer_drv_state {
+	ICE_PEER_DRV_STATE_MBX_RDY,
+	ICE_PEER_DRV_STATE_NBITS,               /* must be last */
+};
+
+struct ice_peer_drv_int {
+	struct iidc_peer_drv *peer_drv;
+
+	/* States associated with peer driver */
+	DECLARE_BITMAP(state, ICE_PEER_DRV_STATE_NBITS);
+
+	/* if this peer_dev is the originator of an event, these are the
+	 * most recent events of each type
+	 */
+	struct iidc_event current_events[IIDC_EVENT_NBITS];
+};
+
+struct ice_peer_dev_int {
+	struct ice_peer_drv_int *peer_drv_int; /* driver private structure */
+	struct iidc_peer_dev peer_dev;
+
+	/* if this peer_dev is the originator of an event, these are the
+	 * most recent events of each type
+	 */
+	struct iidc_event current_events[IIDC_EVENT_NBITS];
+	/* Events a peer has registered to be notified about */
+	DECLARE_BITMAP(events, IIDC_EVENT_NBITS);
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
+	enum iidc_close_reason rst_type;
+};
+
+int ice_unroll_peer(struct ice_peer_dev_int *peer_dev_int, void *data);
+int ice_unreg_peer_device(struct ice_peer_dev_int *peer_dev_int, void *data);
+#endif /* !_ICE_IDC_INT_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 2f256bf45efc..205ac5900551 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -504,6 +504,17 @@ bool ice_is_safe_mode(struct ice_pf *pf)
 	return !test_bit(ICE_FLAG_ADV_FEATURES, pf->flags);
 }
 
+/**
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
 /**
  * ice_vsi_clean_rss_flow_fld - Delete RSS configuration
  * @vsi: the VSI being cleaned up
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 04ca00799364..db07cc065b10 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -104,6 +104,8 @@ ice_vsi_cfg_mac_fltr(struct ice_vsi *vsi, const u8 *macaddr, bool set);
 
 bool ice_is_safe_mode(struct ice_pf *pf);
 
+bool ice_is_peer_ena(struct ice_pf *pf);
+
 bool ice_is_dflt_vsi_in_use(struct ice_sw *sw);
 
 bool ice_is_vsi_dflt_vsi(struct ice_sw *sw, struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 5b190c257124..9f8747e6133f 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2690,6 +2690,12 @@ static void ice_set_pf_caps(struct ice_pf *pf)
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
@@ -2769,6 +2775,16 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 	v_budget += needed;
 	v_left -= needed;
 
+	/* reserve vectors for RDMA peer driver */
+	if (test_bit(ICE_FLAG_IWARP_ENA, pf->flags)) {
+		needed = ICE_RDMA_NUM_VECS;
+		if (v_left < needed)
+			goto no_hw_vecs_left_err;
+		pf->num_rdma_msix = needed;
+		v_budget += needed;
+		v_left -= needed;
+	}
+
 	pf->msix_entries = devm_kcalloc(dev, v_budget,
 					sizeof(*pf->msix_entries), GFP_KERNEL);
 
@@ -2793,16 +2809,19 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 	if (v_actual < v_budget) {
 		dev_warn(dev, "not enough OS MSI-X vectors. requested = %d, obtained = %d\n",
 			 v_budget, v_actual);
-/* 2 vectors for LAN (traffic + OICR) */
+/* 2 vectors for LAN and RDMA (traffic + OICR) */
 #define ICE_MIN_LAN_VECS 2
+#define ICE_MIN_RDMA_VECS 2
+#define ICE_MIN_VECS (ICE_MIN_LAN_VECS + ICE_MIN_RDMA_VECS)
 
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
 
@@ -2818,6 +2837,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 	err = -ERANGE;
 exit_err:
 	pf->num_lan_msix = 0;
+	pf->num_rdma_msix = 0;
 	return err;
 }
 
@@ -3362,6 +3382,26 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
 	/* initialize DDP driven features */
 
+	/* init peers only if supported */
+	if (ice_is_peer_ena(pf)) {
+		pf->peers = devm_kcalloc(dev, IIDC_MAX_NUM_PEERS,
+					 sizeof(*pf->peers), GFP_KERNEL);
+		if (!pf->peers) {
+			err = -ENOMEM;
+			goto err_init_peer_unroll;
+		}
+
+		err = ice_init_peer_devices(pf);
+		if (err) {
+			dev_err(dev, "Failed to initialize peer devices: 0x%x\n",
+				err);
+			err = -EIO;
+			goto err_init_peer_unroll;
+		}
+	} else {
+		dev_warn(dev, "RDMA is not supported on this device\n");
+	}
+
 	/* Note: DCB init failure is non-fatal to load */
 	if (ice_init_pf_dcb(pf, false)) {
 		clear_bit(ICE_FLAG_DCB_CAPABLE, pf->flags);
@@ -3375,6 +3415,14 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
 	return 0;
 
+err_init_peer_unroll:
+	if (ice_is_peer_ena(pf)) {
+		ice_for_each_peer(pf, NULL, ice_unroll_peer);
+		if (pf->peers) {
+			devm_kfree(dev, pf->peers);
+			pf->peers = NULL;
+		}
+	}
 err_alloc_sw_unroll:
 	ice_devlink_destroy_port(pf);
 	set_bit(__ICE_SERVICE_DIS, pf->state);
@@ -3423,6 +3471,10 @@ static void ice_remove(struct pci_dev *pdev)
 
 	ice_devlink_destroy_port(pf);
 	ice_vsi_release_all(pf);
+	if (ice_is_peer_ena(pf)) {
+		ice_for_each_peer(pf, NULL, ice_unreg_peer_device);
+		devm_kfree(&pdev->dev, pf->peers);
+	}
 	ice_free_irq_msix_misc(pf);
 	ice_for_each_vsi(pf, i) {
 		if (!pf->vsi[i])
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 4ce5f92fca4a..42b2d700bc1f 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -189,6 +189,7 @@ struct ice_hw_common_caps {
 	u8 rss_table_entry_width;	/* RSS Entry width in bits */
 
 	u8 dcb;
+	u8 iwarp;
 };
 
 /* Function specific capabilities */
diff --git a/include/linux/net/intel/iidc.h b/include/linux/net/intel/iidc.h
new file mode 100644
index 000000000000..8056e6d8c4cc
--- /dev/null
+++ b/include/linux/net/intel/iidc.h
@@ -0,0 +1,337 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019, Intel Corporation. */
+
+#ifndef _IIDC_H_
+#define _IIDC_H_
+
+#include <linux/dcbnl.h>
+#include <linux/device.h>
+#include <linux/if_ether.h>
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/virtual_bus.h>
+
+enum iidc_event_type {
+	IIDC_EVENT_LINK_CHANGE,
+	IIDC_EVENT_MTU_CHANGE,
+	IIDC_EVENT_TC_CHANGE,
+	IIDC_EVENT_API_CHANGE,
+	IIDC_EVENT_MBX_CHANGE,
+	IIDC_EVENT_NBITS		/* must be last */
+};
+
+enum iidc_res_type {
+	IIDC_INVAL_RES,
+	IIDC_VSI,
+	IIDC_VEB,
+	IIDC_EVENT_Q,
+	IIDC_EGRESS_CMPL_Q,
+	IIDC_CMPL_EVENT_Q,
+	IIDC_ASYNC_EVENT_Q,
+	IIDC_DOORBELL_Q,
+	IIDC_RDMA_QSETS_TXSCHED,
+};
+
+enum iidc_peer_reset_type {
+	IIDC_PEER_PFR,
+	IIDC_PEER_CORER,
+	IIDC_PEER_CORER_SW_CORE,
+	IIDC_PEER_CORER_SW_FULL,
+	IIDC_PEER_GLOBR,
+};
+
+/* reason notified to peer driver as part of event handling */
+enum iidc_close_reason {
+	IIDC_REASON_INVAL,
+	IIDC_REASON_HW_UNRESPONSIVE,
+	IIDC_REASON_INTERFACE_DOWN, /* Administrative down */
+	IIDC_REASON_PEER_DRV_UNREG, /* peer driver getting unregistered */
+	IIDC_REASON_PEER_DEV_UNINIT,
+	IIDC_REASON_GLOBR_REQ,
+	IIDC_REASON_CORER_REQ,
+	/* Reason #7 reserved */
+	IIDC_REASON_PFR_REQ = 8,
+	IIDC_REASON_HW_RESET_PENDING,
+	IIDC_REASON_RECOVERY_MODE,
+	IIDC_REASON_PARAM_CHANGE,
+};
+
+enum iidc_rdma_filter {
+	IIDC_RDMA_FILTER_INVAL,
+	IIDC_RDMA_FILTER_IWARP,
+	IIDC_RDMA_FILTER_ROCEV2,
+	IIDC_RDMA_FILTER_BOTH,
+};
+
+/* Struct to hold per DCB APP info */
+struct iidc_dcb_app_info {
+	u8  priority;
+	u8  selector;
+	u16 prot_id;
+};
+
+struct iidc_peer_dev;
+
+#define IIDC_MAX_USER_PRIORITY		8
+#define IIDC_MAX_APPS			8
+
+/* Struct to hold per RDMA Qset info */
+struct iidc_rdma_qset_params {
+	u32 teid;	/* qset TEID */
+	u16 qs_handle; /* RDMA driver provides this */
+	u16 vsi_id; /* VSI index */
+	u8 tc; /* TC branch the QSet should belong to */
+	u8 reserved[3];
+};
+
+struct iidc_res_base {
+	/* Union for future provision e.g. other res_type */
+	union {
+		struct iidc_rdma_qset_params qsets;
+	} res;
+};
+
+struct iidc_res {
+	/* Type of resource. Filled by peer driver */
+	enum iidc_res_type res_type;
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
+	struct iidc_res_base res[1];
+};
+
+struct iidc_qos_info {
+	u64 tc_ctx;
+	u8 rel_bw;
+	u8 prio_type;
+	u8 egress_virt_up;
+	u8 ingress_virt_up;
+};
+
+/* Struct to hold QoS info */
+struct iidc_qos_params {
+	struct iidc_qos_info tc_info[IEEE_8021QAZ_MAX_TCS];
+	u8 up2tc[IIDC_MAX_USER_PRIORITY];
+	u8 vsi_relative_bw;
+	u8 vsi_priority_type;
+	u32 num_apps;
+	struct iidc_dcb_app_info apps[IIDC_MAX_APPS];
+	u8 num_tc;
+};
+
+union iidc_event_info {
+	/* IIDC_EVENT_LINK_CHANGE */
+	struct {
+		struct net_device *lwr_nd;
+		u16 vsi_num; /* HW index of VSI corresponding to lwr ndev */
+		u8 new_link_state;
+		u8 lport;
+	} link_info;
+	/* IIDC_EVENT_MTU_CHANGE */
+	u16 mtu;
+	/* IIDC_EVENT_TC_CHANGE */
+	struct iidc_qos_params port_qos;
+	/* IIDC_EVENT_API_CHANGE */
+	u8 api_rdy;
+	/* IIDC_EVENT_MBX_CHANGE */
+	u8 mbx_rdy;
+};
+
+/* iidc_event elements are to be passed back and forth between the device
+ * owner and the peer drivers. They are to be used to both register/unregister
+ * for event reporting and to report an event (events can be either device
+ * owner generated or peer generated).
+ *
+ * For (un)registering for events, the structure needs to be populated with:
+ *   reporter - pointer to the iidc_peer_dev struct of the peer (un)registering
+ *   type - bitmap with bits set for event types to (un)register for
+ *
+ * For reporting events, the structure needs to be populated with:
+ *   reporter - pointer to peer that generated the event (NULL for ice)
+ *   type - bitmap with single bit set for this event type
+ *   info - union containing data relevant to this event type
+ */
+struct iidc_event {
+	struct iidc_peer_dev *reporter;
+	DECLARE_BITMAP(type, IIDC_EVENT_NBITS);
+	union iidc_event_info info;
+};
+
+/* Following APIs are implemented by device owner and invoked by peer
+ * drivers
+ */
+struct iidc_ops {
+	/* APIs to allocate resources such as VEB, VSI, Doorbell queues,
+	 * completion queues, Tx/Rx queues, etc...
+	 */
+	int (*alloc_res)(struct iidc_peer_dev *peer_dev,
+			 struct iidc_res *res,
+			 int partial_acceptable);
+	int (*free_res)(struct iidc_peer_dev *peer_dev,
+			struct iidc_res *res);
+
+	int (*is_vsi_ready)(struct iidc_peer_dev *peer_dev);
+	int (*peer_register)(struct iidc_peer_dev *peer_dev);
+	int (*peer_unregister)(struct iidc_peer_dev *peer_dev);
+	int (*request_reset)(struct iidc_peer_dev *dev,
+			     enum iidc_peer_reset_type reset_type);
+
+	void (*notify_state_change)(struct iidc_peer_dev *dev,
+				    struct iidc_event *event);
+
+	/* Notification APIs */
+	void (*reg_for_notification)(struct iidc_peer_dev *dev,
+				     struct iidc_event *event);
+	void (*unreg_for_notification)(struct iidc_peer_dev *dev,
+				       struct iidc_event *event);
+	int (*update_vsi_filter)(struct iidc_peer_dev *peer_dev,
+				 enum iidc_rdma_filter filter, bool enable);
+	int (*vc_send)(struct iidc_peer_dev *peer_dev, u32 vf_id, u8 *msg,
+		       u16 len);
+};
+
+/* Following APIs are implemented by peer drivers and invoked by device
+ * owner
+ */
+struct iidc_peer_ops {
+	void (*event_handler)(struct iidc_peer_dev *peer_dev,
+			      struct iidc_event *event);
+
+	/* Why we have 'open' and when it is expected to be called:
+	 * 1. symmetric set of API w.r.t close
+	 * 2. To be invoked form driver initialization path
+	 *     - call peer_driver:open once device owner is fully
+	 *     initialized
+	 * 3. To be invoked upon RESET complete
+	 */
+	int (*open)(struct iidc_peer_dev *peer_dev);
+
+	/* Peer's close function is to be called when the peer needs to be
+	 * quiesced. This can be for a variety of reasons (enumerated in the
+	 * iidc_close_reason enum struct). A call to close will only be
+	 * followed by a call to either remove or open. No IDC calls from the
+	 * peer should be accepted until it is re-opened.
+	 *
+	 * The *reason* parameter is the reason for the call to close. This
+	 * can be for any reason enumerated in the iidc_close_reason struct.
+	 * It's primary reason is for the peer's bookkeeping and in case the
+	 * peer want to perform any different tasks dictated by the reason.
+	 */
+	void (*close)(struct iidc_peer_dev *peer_dev,
+		      enum iidc_close_reason reason);
+
+	int (*vc_receive)(struct iidc_peer_dev *peer_dev, u32 vf_id, u8 *msg,
+			  u16 len);
+	/* tell RDMA peer to prepare for TC change in a blocking call
+	 * that will directly precede the change event
+	 */
+	void (*prep_tc_change)(struct iidc_peer_dev *peer_dev);
+};
+
+#define IIDC_PEER_RDMA_NAME	"intel,ice,rdma"
+#define IIDC_PEER_RDMA_ID	0x00000010
+#define IIDC_MAX_NUM_PEERS	4
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
+#define ASSIGN_PEER_INFO						\
+{									\
+	{ .name = IIDC_PEER_RDMA_NAME, .id = IIDC_PEER_RDMA_ID },	\
+}
+
+#define iidc_peer_priv(x) ((x)->peer_priv)
+
+/* Structure representing peer specific information, each peer using the IIDC
+ * interface will have an instance of this struct dedicated to it.
+ */
+struct iidc_peer_dev {
+	struct pci_dev *pdev; /* PCI device of corresponding to main function */
+	struct virtbus_device *vdev; /* virtual device for this peer */
+	/* KVA / Linear address corresponding to BAR0 of underlying
+	 * pci_device.
+	 */
+	u8 __iomem *hw_addr;
+	int peer_dev_id;
+
+	/* Opaque pointer for peer specific data tracking.  This memory will
+	 * be alloc'd and freed by the peer driver and used for private data
+	 * accessible only to the specific peer.  It is stored here so that
+	 * when this struct is passed to the peer via an IDC call, the data
+	 * can be accessed by the peer at that time.
+	 * The peers should only retrieve the pointer by the macro:
+	 *    iidc_peer_priv(struct iidc_peer_dev *)
+	 */
+	void *peer_priv;
+
+	u8 ftype;	/* PF(false) or VF (true) */
+
+	/* Data VSI created by driver */
+	u16 pf_vsi_num;
+
+	struct iidc_qos_params initial_qos_info;
+	struct net_device *netdev;
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
+	 * by device owner and called by peer driver
+	 */
+	const struct iidc_ops *ops;
+
+	/* Following struct contains function pointers to be initialized
+	 * by peer driver and called by device owner
+	 */
+	const struct iidc_peer_ops *peer_ops;
+
+	/* Pointer to peer_drv struct to be populated by peer driver */
+	struct iidc_peer_drv *peer_drv;
+};
+
+struct iidc_virtbus_object {
+	struct virtbus_device vdev;
+	struct iidc_peer_dev *peer_dev;
+};
+
+/* structure representing peer driver
+ * Peer driver to initialize those function ptrs and it will be invoked
+ * by device owner as part of driver_registration via bus infrastructure
+ */
+struct iidc_peer_drv {
+	u16 driver_id;
+#define IIDC_PEER_DEVICE_OWNER		0
+#define IIDC_PEER_RDMA_DRIVER		4
+
+	const char *name;
+
+};
+#endif /* _IIDC_H_*/
-- 
2.25.2

