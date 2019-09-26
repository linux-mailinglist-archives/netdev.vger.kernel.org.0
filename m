Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C194ABF6E9
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 18:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbfIZQpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 12:45:32 -0400
Received: from mga18.intel.com ([134.134.136.126]:60795 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727454AbfIZQpb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 12:45:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 09:45:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,552,1559545200"; 
   d="scan'208";a="219465101"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 26 Sep 2019 09:45:27 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     dledford@redhat.com, jgg@mellanox.com, gregkh@linuxfoundation.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Dave Ertman <david.m.ertman@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [RFC 01/20] ice: Initialize and register multi-function device to provide RDMA
Date:   Thu, 26 Sep 2019 09:45:00 -0700
Message-Id: <20190926164519.10471-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>

The RDMA block does not advertise on the PCI bus or any other bus.
Thus the ice driver needs to provide access to the RDMA hardware block
via a virtual bus; utilize a multi-function device to provide this access.

This patch initializes the driver to support RDMA as well as creates
and registers a multi-function device for the RDMA driver to register to.
At this point the driver is fully initialized to register a platform
driver, however, can not yet register as the ops have not been
implemented.

We refer to the interaction of this platform device as Inter-Driver
Communication (IDC); where the platform device is referred to as the peer
device and the platform driver is referred to as the peer driver.

Note that the header file iidc.h has been located under
include/linux/net/intel as this file is a unified header file to be used by
the ice and irdma driver.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 MAINTAINERS                                   |   1 +
 drivers/net/ethernet/intel/Kconfig            |   1 +
 drivers/net/ethernet/intel/ice/Makefile       |   1 +
 drivers/net/ethernet/intel/ice/ice.h          |  16 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_common.c   |   5 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |  31 ++
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |   3 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_idc.c      | 442 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_idc_int.h  |  81 ++++
 drivers/net/ethernet/intel/ice/ice_lib.c      |  11 +
 drivers/net/ethernet/intel/ice/ice_lib.h      |   1 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  70 ++-
 drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
 include/linux/net/intel/iidc.h                | 355 ++++++++++++++
 16 files changed, 1019 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc_int.h
 create mode 100644 include/linux/net/intel/iidc.h

diff --git a/MAINTAINERS b/MAINTAINERS
index b2326dece28e..07c374fa1975 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8205,6 +8205,7 @@ F:	Documentation/networking/device_drivers/intel/ice.rst
 F:	drivers/net/ethernet/intel/
 F:	drivers/net/ethernet/intel/*/
 F:	include/linux/avf/virtchnl.h
+F:	include/linux/net/intel/iidc.h
 
 INTEL FRAMEBUFFER DRIVER (excluding 810 and 815)
 M:	Maik Broemme <mbroemme@libmpq.org>
diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 154e2e818ec6..48ec63f27869 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -294,6 +294,7 @@ config ICE
 	tristate "Intel(R) Ethernet Connection E800 Series Support"
 	default n
 	depends on PCI_MSI
+	select MFD_CORE
 	---help---
 	  This driver supports Intel(R) Ethernet Connection E800 Series of
 	  devices.  For more information on how to identify your adapter, go
diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 9edde960b4f2..2f0ba4aa4957 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -16,6 +16,7 @@ ice-y := ice_main.o	\
 	 ice_lib.o	\
 	 ice_txrx.o	\
 	 ice_flex_pipe.o	\
+	 ice_idc.o	\
 	 ice_ethtool.o
 ice-$(CONFIG_PCI_IOV) += ice_virtchnl_pf.o ice_sriov.o
 ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_lib.o
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 45e100666049..7160556ec55e 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -32,6 +32,7 @@
 #include <linux/if_bridge.h>
 #include <linux/ctype.h>
 #include <linux/avf/virtchnl.h>
+#include <linux/mfd/core.h>
 #include <net/ipv6.h>
 #include "ice_devids.h"
 #include "ice_type.h"
@@ -40,6 +41,7 @@
 #include "ice_switch.h"
 #include "ice_common.h"
 #include "ice_sched.h"
+#include "ice_idc_int.h"
 #include "ice_virtchnl_pf.h"
 #include "ice_sriov.h"
 
@@ -69,6 +71,7 @@ extern const char ice_drv_ver[];
 #define ICE_MAX_SMALL_RSS_QS	8
 #define ICE_RES_VALID_BIT	0x8000
 #define ICE_RES_MISC_VEC_ID	(ICE_RES_VALID_BIT - 1)
+#define ICE_RES_RDMA_VEC_ID	(ICE_RES_MISC_VEC_ID - 1)
 #define ICE_INVAL_Q_INDEX	0xffff
 #define ICE_INVAL_VFID		256
 
@@ -303,11 +306,13 @@ struct ice_q_vector {
 
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
@@ -347,6 +352,9 @@ struct ice_pf {
 	struct mutex avail_q_mutex;	/* protects access to avail_[rx|tx]qs */
 	struct mutex sw_mutex;		/* lock for protecting VSI alloc flow */
 	u32 msg_enable;
+	/* Total number of MSIX vectors reserved for base driver */
+	u32 num_rdma_msix;
+	u32 rdma_base_vector;
 	u32 hw_csum_rx_error;
 	u32 oicr_idx;		/* Other interrupt cause MSIX vector index */
 	u32 num_avail_sw_msix;	/* remaining MSIX SW vectors left unclaimed */
@@ -373,6 +381,8 @@ struct ice_pf {
 	unsigned long tx_timeout_last_recovery;
 	u32 tx_timeout_recovery_level;
 	char int_name[ICE_INT_NAME_STR_LEN];
+	struct ice_peer_dev_int **peers;
+	int peer_idx;
 	u32 sw_int_count;
 };
 
@@ -380,6 +390,8 @@ struct ice_netdev_priv {
 	struct ice_vsi *vsi;
 };
 
+extern struct ida ice_peer_index_ida;
+
 /**
  * ice_irq_dynamic_ena - Enable default interrupt generation settings
  * @hw: pointer to HW struct
@@ -447,6 +459,10 @@ int ice_set_rss(struct ice_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size);
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
index 023e3d2fee5f..c54e78492395 100644
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
index 3a6b3950eb0e..ed59eec57a52 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1748,6 +1748,11 @@ ice_parse_caps(struct ice_hw *hw, void *buf, u32 cap_count,
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
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index dd47869c4ad4..ed639ef5da42 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -613,6 +613,37 @@ ice_tx_prepare_vlan_flags_dcb(struct ice_ring *tx_ring,
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
index 661a6f7bca64..6c0585d1bc97 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
@@ -20,6 +20,8 @@ int
 ice_tx_prepare_vlan_flags_dcb(struct ice_ring *tx_ring,
 			      struct ice_tx_buf *first);
 void
+ice_setup_dcb_qos_info(struct ice_pf *pf, struct iidc_qos_params *qos_info);
+void
 ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
 				    struct ice_rq_event_info *event);
 void ice_vsi_cfg_netdev_tc(struct ice_vsi *vsi, u8 ena_tc);
@@ -57,6 +59,7 @@ ice_tx_prepare_vlan_flags_dcb(struct ice_ring __always_unused *tx_ring,
 
 #define ice_update_dcb_stats(pf) do {} while (0)
 #define ice_vsi_cfg_dcb_rings(vsi) do {} while (0)
+#define ice_setup_dcb_qos_info(pf, qos_info) do {} while (0)
 #define ice_dcb_process_lldp_set_mib_change(pf, event) do {} while (0)
 #define ice_set_cgd_num(tlan_ctx, ring) do {} while (0)
 #define ice_vsi_cfg_netdev_tc(vsi, ena_tc) do {} while (0)
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 152fbd556e9b..05a71f223c5d 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -55,6 +55,7 @@
 #define PRTDCB_GENS				0x00083020
 #define PRTDCB_GENS_DCBX_STATUS_S		0
 #define PRTDCB_GENS_DCBX_STATUS_M		ICE_M(0x7, 0)
+#define PRTDCB_TUP2TC				0x001D26C0
 #define GL_PREEXT_L2_PMASK0(_i)			(0x0020F0FC + ((_i) * 4))
 #define GL_PREEXT_L2_PMASK1(_i)			(0x0020F108 + ((_i) * 4))
 #define GLFLXP_RXDID_FLAGS(_i, _j)		(0x0045D000 + ((_i) * 4 + (_j) * 256))
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
new file mode 100644
index 000000000000..0850773ee679
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -0,0 +1,442 @@
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
+static struct mfd_cell ice_mfd_cells[] = ASSIGN_PEER_INFO;
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
+	struct device *dev;
+
+	dev = bus_find_device_by_name(&platform_bus_type, NULL,
+				      peer_dev->plat_name);
+
+	if (!locked)
+		mutex_lock(&peer_dev->peer_dev_state_mutex);
+
+	switch (new_state) {
+	case ICE_PEER_DEV_STATE_INIT:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_REMOVED,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_INIT, peer_dev->state);
+			dev_dbg(dev,
+				"state transition from _REMOVED to _INIT\n");
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
+			dev_dbg(dev,
+				"state transition from _INIT to _PROBED\n");
+		} else if (test_and_clear_bit(ICE_PEER_DEV_STATE_REMOVED,
+					      peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_PROBED, peer_dev->state);
+			dev_dbg(dev,
+				"state transition from _REMOVED to _PROBED\n");
+		} else if (test_and_clear_bit(ICE_PEER_DEV_STATE_OPENING,
+					      peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_PROBED, peer_dev->state);
+			dev_dbg(dev,
+				"state transition from _OPENING to _PROBED\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_OPENING:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_PROBED,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_OPENING, peer_dev->state);
+			dev_dbg(dev,
+				"state transition from _PROBED to _OPENING\n");
+		} else if (test_and_clear_bit(ICE_PEER_DEV_STATE_CLOSED,
+					      peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_OPENING, peer_dev->state);
+			dev_dbg(dev,
+				"state transition from _CLOSED to _OPENING\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_OPENED:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_OPENING,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_OPENED, peer_dev->state);
+			dev_dbg(dev,
+				"state transition from _OPENING to _OPENED\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_PREP_RST:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_OPENED,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_PREP_RST, peer_dev->state);
+			dev_dbg(dev,
+				"state transition from _OPENED to _PREP_RST\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_PREPPED:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_PREP_RST,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_PREPPED, peer_dev->state);
+			dev_dbg(dev,
+				"state transition _PREP_RST to _PREPPED\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_CLOSING:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_OPENED,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_CLOSING, peer_dev->state);
+			dev_dbg(dev,
+				"state transition from _OPENED to _CLOSING\n");
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
+			dev_warn(dev,
+				 "WARN: Peer state PREP_RST to _CLOSING\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_CLOSED:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_CLOSING,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_CLOSED, peer_dev->state);
+			dev_dbg(dev,
+				"state transition from _CLOSING to _CLOSED\n");
+		}
+		break;
+	case ICE_PEER_DEV_STATE_REMOVED:
+		if (test_and_clear_bit(ICE_PEER_DEV_STATE_OPENED,
+				       peer_dev->state) ||
+		    test_and_clear_bit(ICE_PEER_DEV_STATE_CLOSED,
+				       peer_dev->state)) {
+			set_bit(ICE_PEER_DEV_STATE_REMOVED, peer_dev->state);
+			dev_dbg(dev,
+				"state from _OPENED/_CLOSED to _REMOVED\n");
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
+ * ice_peer_update_vsi - update the pf_vsi info in peer_dev struct
+ * @peer_dev_int: pointer to peer dev internal struct
+ * @data: opaque pointer - VSI to be updated
+ */
+int ice_peer_update_vsi(struct ice_peer_dev_int *peer_dev_int, void *data)
+{
+	struct ice_vsi *vsi = (struct ice_vsi *)data;
+	struct iidc_peer_dev *peer_dev;
+
+	peer_dev = ice_get_peer_dev(peer_dev_int);
+	if (!peer_dev)
+		return 0;
+
+	peer_dev->pf_vsi_num = vsi->vsi_num;
+	return 0;
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
+	int i;
+
+	if (!pf->peers)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(ice_mfd_cells); i++) {
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
+	struct iidc_peer_dev *peer_dev;
+	struct pci_dev *pdev;
+	struct ice_pf *pf;
+
+	if (!peer_dev_int)
+		return 0;
+
+	peer_dev = ice_get_peer_dev(peer_dev_int);
+	pdev = peer_dev->pdev;
+	if (!pdev)
+		return 0;
+
+	pf = pci_get_drvdata(pdev);
+	if (!pf)
+		return 0;
+
+	mfd_remove_devices(&pdev->dev);
+
+	peer_drv_int = peer_dev_int->peer_drv_int;
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
+	devm_kfree(&pf->pdev->dev, peer_drv_int);
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
+	struct iidc_peer_dev *peer_dev;
+	struct ice_pf *pf;
+
+	peer_dev = ice_get_peer_dev(peer_dev_int);
+	if (!peer_dev)
+		return 0;
+
+	pf = pci_get_drvdata(peer_dev->pdev);
+	if (!pf)
+		return 0;
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
+ * ice_init_peer_devices - initializes peer devices
+ * @pf: ptr to ice_pf
+ *
+ * This function initializes peer devices and associates them with specified
+ * pci_dev as their parent.
+ */
+int ice_init_peer_devices(struct ice_pf *pf)
+{
+	struct ice_vsi *vsi = pf->vsi[0];
+	struct pci_dev *pdev = pf->pdev;
+	struct device *dev = &pdev->dev;
+	int status = 0;
+	int i;
+
+	/* Reserve vector resources */
+	status = ice_reserve_peer_qvector(pf);
+	if (status < 0) {
+		dev_err(dev, "failed to reserve vectors for peer drivers\n");
+		return status;
+	}
+	for (i = 0; i < ARRAY_SIZE(ice_mfd_cells); i++) {
+		struct iidc_peer_dev_platform_data *platform_data;
+		struct ice_peer_dev_int *peer_dev_int;
+		struct ice_peer_drv_int *peer_drv_int;
+		struct iidc_qos_params *qos_info;
+		struct msix_entry *entry = NULL;
+		struct iidc_peer_dev *peer_dev;
+		int j;
+
+		peer_dev_int = devm_kzalloc(dev, sizeof(*peer_dev_int),
+					    GFP_KERNEL);
+		if (!peer_dev_int)
+			return -ENOMEM;
+		pf->peers[i] = peer_dev_int;
+
+		peer_drv_int = devm_kzalloc(dev, sizeof(*peer_drv_int),
+					    GFP_KERNEL);
+		if (!peer_drv_int) {
+			devm_kfree(&pf->pdev->dev, peer_dev_int);
+			return -ENOMEM;
+		}
+
+		peer_dev_int->peer_drv_int = peer_drv_int;
+
+		/* Initialize driver values */
+		for (j = 0; j < IIDC_EVENT_NBITS; j++)
+			bitmap_zero(peer_drv_int->current_events[j].type,
+				    IIDC_EVENT_NBITS);
+
+		mutex_init(&peer_dev_int->peer_dev_state_mutex);
+
+		peer_dev = ice_get_peer_dev(peer_dev_int);
+		peer_dev_int->plat_data.peer_dev = peer_dev;
+		platform_data = &peer_dev_int->plat_data;
+		peer_dev->peer_ops = NULL;
+		peer_dev->hw_addr = (u8 __iomem *)pf->hw.hw_addr;
+		peer_dev->ver.major = IIDC_PEER_MAJOR_VER;
+		peer_dev->ver.minor = IIDC_PEER_MINOR_VER;
+		peer_dev->peer_dev_id = ice_mfd_cells[i].id;
+		peer_dev->pf_vsi_num = vsi->vsi_num;
+		peer_dev->netdev = vsi->netdev;
+
+		ice_mfd_cells[i].platform_data = platform_data;
+		ice_mfd_cells[i].pdata_size = sizeof(*platform_data);
+
+		peer_dev_int->ice_peer_wq =
+			alloc_ordered_workqueue("ice_peer_wq_%d", WQ_UNBOUND,
+						i);
+		if (!peer_dev_int->ice_peer_wq)
+			return -ENOMEM;
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
+		switch (ice_mfd_cells[i].id) {
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
+	}
+
+	status = ida_simple_get(&ice_peer_index_ida, 0, 0, GFP_KERNEL);
+	if (status < 0) {
+		dev_err(&pdev->dev,
+			"failed to get unique index for device\n");
+		return status;
+	}
+
+	pf->peer_idx = status;
+
+	status = mfd_add_devices(dev, pf->peer_idx, ice_mfd_cells,
+				 ARRAY_SIZE(ice_mfd_cells), NULL, 0, NULL);
+	if (status)
+		dev_err(dev, "Failure adding MFD devs for peers: %d\n", status);
+
+	for (i = 0; i < ARRAY_SIZE(ice_mfd_cells); i++) {
+		snprintf(pf->peers[i]->plat_name, ICE_MAX_PEER_NAME, "%s.%d",
+			 ice_mfd_cells[i].name,
+			 pf->peer_idx + ice_mfd_cells[i].id);
+		dev = bus_find_device_by_name(&platform_bus_type, NULL,
+					      pf->peers[i]->plat_name);
+		dev_dbg(dev, "Peer Created: %s %d\n", pf->peers[i]->plat_name,
+			pf->peer_idx);
+	}
+
+	return status;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_idc_int.h b/drivers/net/ethernet/intel/ice/ice_idc_int.h
new file mode 100644
index 000000000000..26ecd45faf16
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_idc_int.h
@@ -0,0 +1,81 @@
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
+#define ICE_MAX_PEER_NAME 64
+
+struct ice_peer_dev_int {
+	struct iidc_peer_dev peer_dev;
+	struct ice_peer_drv_int *peer_drv_int; /* driver private structure */
+	char plat_name[ICE_MAX_PEER_NAME];
+	struct iidc_peer_dev_platform_data plat_data;
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
+int ice_peer_update_vsi(struct ice_peer_dev_int *peer_dev_int, void *data);
+int ice_unroll_peer(struct ice_peer_dev_int *peer_dev_int, void *data);
+int ice_unreg_peer_device(struct ice_peer_dev_int *peer_dev_int, void *data);
+
+static inline struct
+iidc_peer_dev *ice_get_peer_dev(struct ice_peer_dev_int *peer_dev_int)
+{
+	if (peer_dev_int)
+		return &peer_dev_int->peer_dev;
+	else
+		return NULL;
+}
+#endif /* !_ICE_IDC_INT_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index cc755382df25..5b95efab5f5c 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -763,6 +763,17 @@ bool ice_is_safe_mode(struct ice_pf *pf)
 	return !test_bit(ICE_FLAG_ADV_FEATURES, pf->flags);
 }
 
+/*
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
  * ice_rss_clean - Delete RSS related VSI structures that hold user inputs
  * @vsi: the VSI being removed
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 47bc033fff20..578de33493b6 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -126,4 +126,5 @@ enum ice_status
 ice_vsi_cfg_mac_fltr(struct ice_vsi *vsi, const u8 *macaddr, bool set);
 
 bool ice_is_safe_mode(struct ice_pf *pf);
+bool ice_is_peer_ena(struct ice_pf *pf);
 #endif /* !_ICE_LIB_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 214cd6eca405..706e5f5cadfc 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2321,6 +2321,12 @@ static void ice_set_pf_caps(struct ice_pf *pf)
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
@@ -2400,6 +2406,17 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 	v_budget += needed;
 	v_left -= needed;
 
+	/* reserve vectors for RDMA peer driver */
+	if (test_bit(ICE_FLAG_IWARP_ENA, pf->flags)) {
+		/* RDMA peer driver needs one extra to handle misc causes */
+		needed = min_t(int, num_online_cpus(), v_left) + 1;
+		if (v_left < needed)
+			goto no_hw_vecs_left_err;
+		pf->num_rdma_msix = needed;
+		v_budget += needed;
+		v_left -= needed;
+	}
+
 	pf->msix_entries = devm_kcalloc(&pf->pdev->dev, v_budget,
 					sizeof(*pf->msix_entries), GFP_KERNEL);
 
@@ -2425,16 +2442,19 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 		dev_warn(&pf->pdev->dev,
 			 "not enough OS MSI-X vectors. requested = %d, obtained = %d\n",
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
 
@@ -2451,6 +2471,7 @@ static int ice_ena_msix_range(struct ice_pf *pf)
 	err = -ERANGE;
 exit_err:
 	pf->num_lan_msix = 0;
+	pf->num_rdma_msix = 0;
 	return err;
 }
 
@@ -2960,6 +2981,26 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 		goto err_alloc_sw_unroll;
 	}
 
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
 	ice_verify_cacheline_size(pf);
 
 	/* If no DDP driven features have to be setup, return here */
@@ -2978,6 +3019,15 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
 	return 0;
 
+	/* Unwind non-managed device resources, etc. if something failed */
+err_init_peer_unroll:
+	if (ice_is_peer_ena(pf)) {
+		ice_for_each_peer(pf, NULL, ice_unroll_peer);
+		if (pf->peers) {
+			devm_kfree(dev, pf->peers);
+			pf->peers = NULL;
+		}
+	}
 err_alloc_sw_unroll:
 	set_bit(__ICE_SERVICE_DIS, pf->state);
 	set_bit(__ICE_DOWN, pf->state);
@@ -3019,6 +3069,7 @@ static void ice_remove(struct pci_dev *pdev)
 	if (test_bit(ICE_FLAG_SRIOV_ENA, pf->flags))
 		ice_free_vfs(pf);
 	ice_vsi_release_all(pf);
+	ice_for_each_peer(pf, NULL, ice_unreg_peer_device);
 	ice_free_irq_msix_misc(pf);
 	ice_for_each_vsi(pf, i) {
 		if (!pf->vsi[i])
@@ -3223,6 +3274,7 @@ static int __init ice_module_init(void)
 	if (status) {
 		pr_err("failed to register PCI driver, err %d\n", status);
 		destroy_workqueue(ice_wq);
+		ida_destroy(&ice_peer_index_ida);
 	}
 
 	return status;
@@ -3239,6 +3291,10 @@ static void __exit ice_module_exit(void)
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
@@ -4291,6 +4347,16 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
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
 	if (test_bit(ICE_FLAG_SRIOV_ENA, pf->flags)) {
 		err = ice_vsi_rebuild_by_type(pf, ICE_VSI_VF);
 		if (err) {
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 6667d17a4206..d3e44a220d5d 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -174,6 +174,7 @@ struct ice_hw_common_caps {
 	u8 rss_table_entry_width;	/* RSS Entry width in bits */
 
 	u8 dcb;
+	u8 iwarp;
 };
 
 /* Function specific capabilities */
diff --git a/include/linux/net/intel/iidc.h b/include/linux/net/intel/iidc.h
new file mode 100644
index 000000000000..406169084a95
--- /dev/null
+++ b/include/linux/net/intel/iidc.h
@@ -0,0 +1,355 @@
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
+
+/* This major and minor version represent IDC API version information.
+ * During peer driver registration, peer driver specifies major and minor
+ * version information (via. peer_driver:ver_info). It gets checked against
+ * following defines and if mismatch, then peer driver registration
+ * fails and appropriate message gets logged.
+ */
+#define IIDC_PEER_MAJOR_VER		8
+#define IIDC_PEER_MINOR_VER		0
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
+	IIDC_REASON_EMPR_REQ,
+	IIDC_REASON_PFR_REQ,
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
+/* This information is needed to handle peer driver registration,
+ * instead of adding more params to peer_drv_registration function,
+ * let's get it thru' peer_drv object.
+ */
+struct iidc_ver_info {
+	u16 major;
+	u16 minor;
+	u64 support;
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
+#define IIDC_PEER_RDMA_NAME	"iidc_rdma"
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
+	struct iidc_ver_info ver;
+	struct pci_dev *pdev; /* PCI device of corresponding to main function */
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
+struct iidc_peer_dev_platform_data {
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
+	struct iidc_ver_info ver;
+	const char *name;
+
+};
+#endif /* _IIDC_H_*/
-- 
2.21.0

