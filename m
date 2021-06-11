Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0E13A465A
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 18:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhFKQTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 12:19:53 -0400
Received: from mga07.intel.com ([134.134.136.100]:16330 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229777AbhFKQTj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 12:19:39 -0400
IronPort-SDR: V5n2izz6ui4YwgpxRoGQr3W9Q02xF8ManrKaAWSrwN+hXMqGtY2oFz7li2Luf5LaXFXeKDm8Pu
 h695irs9Gt/g==
X-IronPort-AV: E=McAfee;i="6200,9189,10012"; a="269404868"
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="269404868"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2021 09:17:26 -0700
IronPort-SDR: jk7gvVgdkuYSjWU9XUoSIfqzqE23ada5IxF6t8dfCJKZHG33Gxda/ZOs8wkDxQWiC3lCZR+it2
 lwuORO8dbF8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="620423475"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 11 Jun 2021 09:17:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 1/8] ice: add support for sideband messages
Date:   Fri, 11 Jun 2021 09:19:53 -0700
Message-Id: <20210611162000.2438023-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
References: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

In order to support certain device features, including enabling the PTP
hardware clock, the ice driver needs to control some registers on the
device PHY.

These registers are accessed by sending sideband messages. For some
hardware, these messages must be sent over the device admin queue, while
other hardware has a dedicated control queue for the sideband messages.

Add the neighbor device message structure for sending a message to the
neighboring device. Where supported, initialize the sideband control
queue and handle cleanup.

Add a wrapper function for sending sideband control queue messages that
read or write a neighboring device register.

Because some devices send sideband messages over the AdminQ, also
increase the length of the admin queue to allow more messages to be
queued up. This is important because the sideband messages add
additional pressure on the AQ usage.

This support will be used in following patches to enable support for
CONFIG_1588_PTP_CLOCK.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  4 +-
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 13 +++
 drivers/net/ethernet/intel/ice/ice_common.c   | 58 ++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h   |  3 +
 drivers/net/ethernet/intel/ice/ice_controlq.c | 62 +++++++++++++
 drivers/net/ethernet/intel/ice/ice_controlq.h |  2 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   | 51 ++++++++++
 drivers/net/ethernet/intel/ice/ice_lib.c      | 11 ++-
 drivers/net/ethernet/intel/ice/ice_main.c     | 47 ++++++++++
 drivers/net/ethernet/intel/ice/ice_sbq_cmd.h  | 92 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_type.h     |  2 +
 11 files changed, 343 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_sbq_cmd.h

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 317b19901053..b745e250ced9 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -74,8 +74,9 @@
 
 #define ICE_DFLT_TRAFFIC_CLASS	BIT(0)
 #define ICE_INT_NAME_STR_LEN	(IFNAMSIZ + 16)
-#define ICE_AQ_LEN		64
+#define ICE_AQ_LEN		192
 #define ICE_MBXSQ_LEN		64
+#define ICE_SBQ_LEN		64
 #define ICE_MIN_LAN_TXRX_MSIX	1
 #define ICE_MIN_LAN_OICR_MSIX	1
 #define ICE_MIN_MSIX		(ICE_MIN_LAN_TXRX_MSIX + ICE_MIN_LAN_OICR_MSIX)
@@ -227,6 +228,7 @@ enum ice_pf_state {
 	ICE_STATE_NOMINAL_CHECK_BITS,
 	ICE_ADMINQ_EVENT_PENDING,
 	ICE_MAILBOXQ_EVENT_PENDING,
+	ICE_SIDEBANDQ_EVENT_PENDING,
 	ICE_MDD_EVENT_PENDING,
 	ICE_VFLR_EVENT_PENDING,
 	ICE_FLTR_OVERFLOW_PROMISC,
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index a9a7d2d1aca7..272d1600268e 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1611,6 +1611,15 @@ struct ice_aqc_get_set_rss_lut {
 	__le32 addr_low;
 };
 
+/* Sideband Control Interface Commands */
+/* Neighbor Device Request (indirect 0x0C00); also used for the response. */
+struct ice_aqc_neigh_dev_req {
+	__le16 sb_data_len;
+	u8 reserved[6];
+	__le32 addr_high;
+	__le32 addr_low;
+};
+
 /* Add Tx LAN Queues (indirect 0x0C30) */
 struct ice_aqc_add_txqs {
 	u8 num_qgrps;
@@ -1911,6 +1920,7 @@ struct ice_aq_desc {
 		struct ice_aqc_lldp_filter_ctrl lldp_filter_ctrl;
 		struct ice_aqc_get_set_rss_lut get_set_rss_lut;
 		struct ice_aqc_get_set_rss_key get_set_rss_key;
+		struct ice_aqc_neigh_dev_req neigh_dev;
 		struct ice_aqc_add_txqs add_txqs;
 		struct ice_aqc_dis_txqs dis_txqs;
 		struct ice_aqc_add_rdma_qset add_rdma_qset;
@@ -2059,6 +2069,9 @@ enum ice_adminq_opc {
 	ice_aqc_opc_get_rss_key				= 0x0B04,
 	ice_aqc_opc_get_rss_lut				= 0x0B05,
 
+	/* Sideband Control Interface commands */
+	ice_aqc_opc_neighbour_device_request		= 0x0C00,
+
 	/* Tx queue handling commands/events */
 	ice_aqc_opc_add_txqs				= 0x0C30,
 	ice_aqc_opc_dis_txqs				= 0x0C31,
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index f687d1f6b765..298e654583bd 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1293,6 +1293,64 @@ const struct ice_ctx_ele ice_tlan_ctx_info[] = {
 	{ 0 }
 };
 
+/* Sideband Queue command wrappers */
+
+/**
+ * ice_sbq_send_cmd - send Sideband Queue command to Sideband Queue
+ * @hw: pointer to the HW struct
+ * @desc: descriptor describing the command
+ * @buf: buffer to use for indirect commands (NULL for direct commands)
+ * @buf_size: size of buffer for indirect commands (0 for direct commands)
+ * @cd: pointer to command details structure
+ */
+static int
+ice_sbq_send_cmd(struct ice_hw *hw, struct ice_sbq_cmd_desc *desc,
+		 void *buf, u16 buf_size, struct ice_sq_cd *cd)
+{
+	return ice_status_to_errno(ice_sq_send_cmd(hw, ice_get_sbq(hw),
+						   (struct ice_aq_desc *)desc,
+						   buf, buf_size, cd));
+}
+
+/**
+ * ice_sbq_rw_reg - Fill Sideband Queue command
+ * @hw: pointer to the HW struct
+ * @in: message info to be filled in descriptor
+ */
+int ice_sbq_rw_reg(struct ice_hw *hw, struct ice_sbq_msg_input *in)
+{
+	struct ice_sbq_cmd_desc desc = {0};
+	struct ice_sbq_msg_req msg = {0};
+	u16 msg_len;
+	int status;
+
+	msg_len = sizeof(msg);
+
+	msg.dest_dev = in->dest_dev;
+	msg.opcode = in->opcode;
+	msg.flags = ICE_SBQ_MSG_FLAGS;
+	msg.sbe_fbe = ICE_SBQ_MSG_SBE_FBE;
+	msg.msg_addr_low = cpu_to_le16(in->msg_addr_low);
+	msg.msg_addr_high = cpu_to_le32(in->msg_addr_high);
+
+	if (in->opcode)
+		msg.data = cpu_to_le32(in->data);
+	else
+		/* data read comes back in completion, so shorten the struct by
+		 * sizeof(msg.data)
+		 */
+		msg_len -= sizeof(msg.data);
+
+	desc.flags = cpu_to_le16(ICE_AQ_FLAG_RD);
+	desc.opcode = cpu_to_le16(ice_sbq_opc_neigh_dev_req);
+	desc.param0.cmd_len = cpu_to_le16(msg_len);
+	status = ice_sbq_send_cmd(hw, &desc, &msg, msg_len, NULL);
+	if (!status && !in->opcode)
+		in->data = le32_to_cpu
+			(((struct ice_sbq_msg_cmpl *)&msg)->data);
+	return status;
+}
+
 /* FW Admin Queue command wrappers */
 
 /* Software lock/mutex that is meant to be held while the Global Config Lock
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 0fdda597fbc8..86bc261177d6 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -40,6 +40,8 @@ enum ice_status
 ice_aq_alloc_free_res(struct ice_hw *hw, u16 num_entries,
 		      struct ice_aqc_alloc_free_res_elem *buf, u16 buf_size,
 		      enum ice_adminq_opc opc, struct ice_sq_cd *cd);
+bool ice_is_sbq_supported(struct ice_hw *hw);
+struct ice_ctl_q_info *ice_get_sbq(struct ice_hw *hw);
 enum ice_status
 ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 		struct ice_aq_desc *desc, void *buf, u16 buf_size,
@@ -173,6 +175,7 @@ void ice_replay_post(struct ice_hw *hw);
 void ice_output_fw_log(struct ice_hw *hw, struct ice_aq_desc *desc, void *buf);
 struct ice_q_ctx *
 ice_get_lan_q_ctx(struct ice_hw *hw, u16 vsi_handle, u8 tc, u16 q_handle);
+int ice_sbq_rw_reg(struct ice_hw *hw, struct ice_sbq_msg_input *in);
 void
 ice_stat_update40(struct ice_hw *hw, u32 reg, bool prev_stat_loaded,
 		  u64 *prev_stat, u64 *cur_stat);
diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
index 87b33bdd4960..03bdb125be36 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
@@ -51,6 +51,19 @@ static void ice_mailbox_init_regs(struct ice_hw *hw)
 	ICE_CQ_INIT_REGS(cq, PF_MBX);
 }
 
+/**
+ * ice_sb_init_regs - Initialize Sideband registers
+ * @hw: pointer to the hardware structure
+ *
+ * This assumes the alloc_sq and alloc_rq functions have already been called
+ */
+static void ice_sb_init_regs(struct ice_hw *hw)
+{
+	struct ice_ctl_q_info *cq = &hw->sbq;
+
+	ICE_CQ_INIT_REGS(cq, PF_SB);
+}
+
 /**
  * ice_check_sq_alive
  * @hw: pointer to the HW struct
@@ -609,6 +622,10 @@ static enum ice_status ice_init_ctrlq(struct ice_hw *hw, enum ice_ctl_q q_type)
 		ice_adminq_init_regs(hw);
 		cq = &hw->adminq;
 		break;
+	case ICE_CTL_Q_SB:
+		ice_sb_init_regs(hw);
+		cq = &hw->sbq;
+		break;
 	case ICE_CTL_Q_MAILBOX:
 		ice_mailbox_init_regs(hw);
 		cq = &hw->mailboxq;
@@ -645,6 +662,32 @@ static enum ice_status ice_init_ctrlq(struct ice_hw *hw, enum ice_ctl_q q_type)
 	return ret_code;
 }
 
+/**
+ * ice_is_sbq_supported - is the sideband queue supported
+ * @hw: pointer to the hardware structure
+ *
+ * Returns true if the sideband control queue interface is
+ * supported for the device, false otherwise
+ */
+bool ice_is_sbq_supported(struct ice_hw *hw)
+{
+	/* The device sideband queue is only supported on devices with the
+	 * generic MAC type.
+	 */
+	return hw->mac_type == ICE_MAC_GENERIC;
+}
+
+/**
+ * ice_get_sbq - returns the right control queue to use for sideband
+ * @hw: pointer to the hardware structure
+ */
+struct ice_ctl_q_info *ice_get_sbq(struct ice_hw *hw)
+{
+	if (ice_is_sbq_supported(hw))
+		return &hw->sbq;
+	return &hw->adminq;
+}
+
 /**
  * ice_shutdown_ctrlq - shutdown routine for any control queue
  * @hw: pointer to the hardware structure
@@ -662,6 +705,9 @@ static void ice_shutdown_ctrlq(struct ice_hw *hw, enum ice_ctl_q q_type)
 		if (ice_check_sq_alive(hw, cq))
 			ice_aq_q_shutdown(hw, true);
 		break;
+	case ICE_CTL_Q_SB:
+		cq = &hw->sbq;
+		break;
 	case ICE_CTL_Q_MAILBOX:
 		cq = &hw->mailboxq;
 		break;
@@ -685,6 +731,9 @@ void ice_shutdown_all_ctrlq(struct ice_hw *hw)
 {
 	/* Shutdown FW admin queue */
 	ice_shutdown_ctrlq(hw, ICE_CTL_Q_ADMIN);
+	/* Shutdown PHY Sideband */
+	if (ice_is_sbq_supported(hw))
+		ice_shutdown_ctrlq(hw, ICE_CTL_Q_SB);
 	/* Shutdown PF-VF Mailbox */
 	ice_shutdown_ctrlq(hw, ICE_CTL_Q_MAILBOX);
 }
@@ -724,6 +773,15 @@ enum ice_status ice_init_all_ctrlq(struct ice_hw *hw)
 
 	if (status)
 		return status;
+	/* sideband control queue (SBQ) interface is not supported on some
+	 * devices. Initialize if supported, else fallback to the admin queue
+	 * interface
+	 */
+	if (ice_is_sbq_supported(hw)) {
+		status = ice_init_ctrlq(hw, ICE_CTL_Q_SB);
+		if (status)
+			return status;
+	}
 	/* Init Mailbox queue */
 	return ice_init_ctrlq(hw, ICE_CTL_Q_MAILBOX);
 }
@@ -759,6 +817,8 @@ static void ice_init_ctrlq_locks(struct ice_ctl_q_info *cq)
 enum ice_status ice_create_all_ctrlq(struct ice_hw *hw)
 {
 	ice_init_ctrlq_locks(&hw->adminq);
+	if (ice_is_sbq_supported(hw))
+		ice_init_ctrlq_locks(&hw->sbq);
 	ice_init_ctrlq_locks(&hw->mailboxq);
 
 	return ice_init_all_ctrlq(hw);
@@ -791,6 +851,8 @@ void ice_destroy_all_ctrlq(struct ice_hw *hw)
 	ice_shutdown_all_ctrlq(hw);
 
 	ice_destroy_ctrlq_locks(&hw->adminq);
+	if (ice_is_sbq_supported(hw))
+		ice_destroy_ctrlq_locks(&hw->sbq);
 	ice_destroy_ctrlq_locks(&hw->mailboxq);
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.h b/drivers/net/ethernet/intel/ice/ice_controlq.h
index fe75871e48ca..c07e9cc9fc6e 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.h
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.h
@@ -9,6 +9,7 @@
 /* Maximum buffer lengths for all control queue types */
 #define ICE_AQ_MAX_BUF_LEN 4096
 #define ICE_MBXQ_MAX_BUF_LEN 4096
+#define ICE_SBQ_MAX_BUF_LEN 512
 
 #define ICE_CTL_Q_DESC(R, i) \
 	(&(((struct ice_aq_desc *)((R).desc_buf.va))[i]))
@@ -29,6 +30,7 @@ enum ice_ctl_q {
 	ICE_CTL_Q_UNKNOWN = 0,
 	ICE_CTL_Q_ADMIN,
 	ICE_CTL_Q_MAILBOX,
+	ICE_CTL_Q_SB,
 };
 
 /* Control Queue timeout settings - max delay 1s */
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 5386285c39e7..84d5d43fe029 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -52,6 +52,54 @@
 #define PF_MBX_ATQLEN_ATQCRIT_M			BIT(30)
 #define PF_MBX_ATQLEN_ATQENABLE_M		BIT(31)
 #define PF_MBX_ATQT				0x0022E300
+#define PF_SB_ARQBAH				0x0022FF00
+#define PF_SB_ARQBAH_ARQBAH_S			0
+#define PF_SB_ARQBAH_ARQBAH_M			ICE_M(0xFFFFFFFF, 0)
+#define PF_SB_ARQBAL				0x0022FE80
+#define PF_SB_ARQBAL_ARQBAL_LSB_S		0
+#define PF_SB_ARQBAL_ARQBAL_LSB_M		ICE_M(0x3F, 0)
+#define PF_SB_ARQBAL_ARQBAL_S			6
+#define PF_SB_ARQBAL_ARQBAL_M			ICE_M(0x3FFFFFF, 6)
+#define PF_SB_ARQH				0x00230000
+#define PF_SB_ARQH_ARQH_S			0
+#define PF_SB_ARQH_ARQH_M			ICE_M(0x3FF, 0)
+#define PF_SB_ARQLEN				0x0022FF80
+#define PF_SB_ARQLEN_ARQLEN_S			0
+#define PF_SB_ARQLEN_ARQLEN_M			ICE_M(0x3FF, 0)
+#define PF_SB_ARQLEN_ARQVFE_S			28
+#define PF_SB_ARQLEN_ARQVFE_M			BIT(28)
+#define PF_SB_ARQLEN_ARQOVFL_S			29
+#define PF_SB_ARQLEN_ARQOVFL_M			BIT(29)
+#define PF_SB_ARQLEN_ARQCRIT_S			30
+#define PF_SB_ARQLEN_ARQCRIT_M			BIT(30)
+#define PF_SB_ARQLEN_ARQENABLE_S		31
+#define PF_SB_ARQLEN_ARQENABLE_M		BIT(31)
+#define PF_SB_ARQT				0x00230080
+#define PF_SB_ARQT_ARQT_S			0
+#define PF_SB_ARQT_ARQT_M			ICE_M(0x3FF, 0)
+#define PF_SB_ATQBAH				0x0022FC80
+#define PF_SB_ATQBAH_ATQBAH_S			0
+#define PF_SB_ATQBAH_ATQBAH_M			ICE_M(0xFFFFFFFF, 0)
+#define PF_SB_ATQBAL				0x0022FC00
+#define PF_SB_ATQBAL_ATQBAL_S			6
+#define PF_SB_ATQBAL_ATQBAL_M			ICE_M(0x3FFFFFF, 6)
+#define PF_SB_ATQH				0x0022FD80
+#define PF_SB_ATQH_ATQH_S			0
+#define PF_SB_ATQH_ATQH_M			ICE_M(0x3FF, 0)
+#define PF_SB_ATQLEN				0x0022FD00
+#define PF_SB_ATQLEN_ATQLEN_S			0
+#define PF_SB_ATQLEN_ATQLEN_M			ICE_M(0x3FF, 0)
+#define PF_SB_ATQLEN_ATQVFE_S			28
+#define PF_SB_ATQLEN_ATQVFE_M			BIT(28)
+#define PF_SB_ATQLEN_ATQOVFL_S			29
+#define PF_SB_ATQLEN_ATQOVFL_M			BIT(29)
+#define PF_SB_ATQLEN_ATQCRIT_S			30
+#define PF_SB_ATQLEN_ATQCRIT_M			BIT(30)
+#define PF_SB_ATQLEN_ATQENABLE_S		31
+#define PF_SB_ATQLEN_ATQENABLE_M		BIT(31)
+#define PF_SB_ATQT				0x0022FE00
+#define PF_SB_ATQT_ATQT_S			0
+#define PF_SB_ATQT_ATQT_M			ICE_M(0x3FF, 0)
 #define PRTDCB_GENC				0x00083000
 #define PRTDCB_GENC_PFCLDA_S			16
 #define PRTDCB_GENC_PFCLDA_M			ICE_M(0xFFFF, 16)
@@ -169,6 +217,9 @@
 #define PFINT_OICR_CTL_ITR_INDX_M		ICE_M(0x3, 11)
 #define PFINT_OICR_CTL_CAUSE_ENA_M		BIT(30)
 #define PFINT_OICR_ENA				0x0016C900
+#define PFINT_SB_CTL				0x0016B600
+#define PFINT_SB_CTL_MSIX_INDX_M		ICE_M(0x7FF, 0)
+#define PFINT_SB_CTL_CAUSE_ENA_M		BIT(30)
 #define QINT_RQCTL(_QRX)			(0x00150000 + ((_QRX) * 4))
 #define QINT_RQCTL_MSIX_INDX_S			0
 #define QINT_RQCTL_MSIX_INDX_M			ICE_M(0x7FF, 0)
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index c14be5c00d2d..db36ce9c0b1c 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3392,13 +3392,22 @@ int ice_status_to_errno(enum ice_status err)
 	case ICE_ERR_DOES_NOT_EXIST:
 		return -ENOENT;
 	case ICE_ERR_OUT_OF_RANGE:
-		return -ENOTTY;
+	case ICE_ERR_AQ_ERROR:
+	case ICE_ERR_AQ_TIMEOUT:
+	case ICE_ERR_AQ_EMPTY:
+	case ICE_ERR_AQ_FW_CRITICAL:
+		return -EIO;
 	case ICE_ERR_PARAM:
+	case ICE_ERR_INVAL_SIZE:
 		return -EINVAL;
 	case ICE_ERR_NO_MEMORY:
 		return -ENOMEM;
 	case ICE_ERR_MAX_LIMIT:
 		return -EAGAIN;
+	case ICE_ERR_RESET_ONGOING:
+		return -EBUSY;
+	case ICE_ERR_AQ_FULL:
+		return -ENOSPC;
 	default:
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 4c0412d87b1a..4b6911955f7c 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -1231,6 +1231,10 @@ static int __ice_clean_ctrlq(struct ice_pf *pf, enum ice_ctl_q q_type)
 		cq = &hw->adminq;
 		qtype = "Admin";
 		break;
+	case ICE_CTL_Q_SB:
+		cq = &hw->sbq;
+		qtype = "Sideband";
+		break;
 	case ICE_CTL_Q_MAILBOX:
 		cq = &hw->mailboxq;
 		qtype = "Mailbox";
@@ -1404,6 +1408,34 @@ static void ice_clean_mailboxq_subtask(struct ice_pf *pf)
 	ice_flush(hw);
 }
 
+/**
+ * ice_clean_sbq_subtask - clean the Sideband Queue rings
+ * @pf: board private structure
+ */
+static void ice_clean_sbq_subtask(struct ice_pf *pf)
+{
+	struct ice_hw *hw = &pf->hw;
+
+	/* Nothing to do here if sideband queue is not supported */
+	if (!ice_is_sbq_supported(hw)) {
+		clear_bit(ICE_SIDEBANDQ_EVENT_PENDING, pf->state);
+		return;
+	}
+
+	if (!test_bit(ICE_SIDEBANDQ_EVENT_PENDING, pf->state))
+		return;
+
+	if (__ice_clean_ctrlq(pf, ICE_CTL_Q_SB))
+		return;
+
+	clear_bit(ICE_SIDEBANDQ_EVENT_PENDING, pf->state);
+
+	if (ice_ctrlq_pending(hw, &hw->sbq))
+		__ice_clean_ctrlq(pf, ICE_CTL_Q_SB);
+
+	ice_flush(hw);
+}
+
 /**
  * ice_service_task_schedule - schedule the service task to wake up
  * @pf: board private structure
@@ -2106,6 +2138,7 @@ static void ice_service_task(struct work_struct *work)
 
 	ice_process_vflr_event(pf);
 	ice_clean_mailboxq_subtask(pf);
+	ice_clean_sbq_subtask(pf);
 	ice_sync_arfs_fltrs(pf);
 	ice_flush_fdir_ctx(pf);
 
@@ -2121,6 +2154,7 @@ static void ice_service_task(struct work_struct *work)
 	    test_bit(ICE_VFLR_EVENT_PENDING, pf->state) ||
 	    test_bit(ICE_MAILBOXQ_EVENT_PENDING, pf->state) ||
 	    test_bit(ICE_FD_VF_FLUSH_CTX, pf->state) ||
+	    test_bit(ICE_SIDEBANDQ_EVENT_PENDING, pf->state) ||
 	    test_bit(ICE_ADMINQ_EVENT_PENDING, pf->state))
 		mod_timer(&pf->serv_tmr, jiffies);
 }
@@ -2139,6 +2173,10 @@ static void ice_set_ctrlq_len(struct ice_hw *hw)
 	hw->mailboxq.num_sq_entries = ICE_MBXSQ_LEN;
 	hw->mailboxq.rq_buf_size = ICE_MBXQ_MAX_BUF_LEN;
 	hw->mailboxq.sq_buf_size = ICE_MBXQ_MAX_BUF_LEN;
+	hw->sbq.num_rq_entries = ICE_SBQ_LEN;
+	hw->sbq.num_sq_entries = ICE_SBQ_LEN;
+	hw->sbq.rq_buf_size = ICE_SBQ_MAX_BUF_LEN;
+	hw->sbq.sq_buf_size = ICE_SBQ_MAX_BUF_LEN;
 }
 
 /**
@@ -2679,6 +2717,7 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 	dev = ice_pf_to_dev(pf);
 	set_bit(ICE_ADMINQ_EVENT_PENDING, pf->state);
 	set_bit(ICE_MAILBOXQ_EVENT_PENDING, pf->state);
+	set_bit(ICE_SIDEBANDQ_EVENT_PENDING, pf->state);
 
 	oicr = rd32(hw, PFINT_OICR);
 	ena_mask = rd32(hw, PFINT_OICR_ENA);
@@ -2800,6 +2839,9 @@ static void ice_dis_ctrlq_interrupts(struct ice_hw *hw)
 	wr32(hw, PFINT_MBX_CTL,
 	     rd32(hw, PFINT_MBX_CTL) & ~PFINT_MBX_CTL_CAUSE_ENA_M);
 
+	wr32(hw, PFINT_SB_CTL,
+	     rd32(hw, PFINT_SB_CTL) & ~PFINT_SB_CTL_CAUSE_ENA_M);
+
 	/* disable Control queue Interrupt causes */
 	wr32(hw, PFINT_OICR_CTL,
 	     rd32(hw, PFINT_OICR_CTL) & ~PFINT_OICR_CTL_CAUSE_ENA_M);
@@ -2854,6 +2896,11 @@ static void ice_ena_ctrlq_interrupts(struct ice_hw *hw, u16 reg_idx)
 	       PFINT_MBX_CTL_CAUSE_ENA_M);
 	wr32(hw, PFINT_MBX_CTL, val);
 
+	/* This enables Sideband queue Interrupt causes */
+	val = ((reg_idx & PFINT_SB_CTL_MSIX_INDX_M) |
+	       PFINT_SB_CTL_CAUSE_ENA_M);
+	wr32(hw, PFINT_SB_CTL, val);
+
 	ice_flush(hw);
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_sbq_cmd.h b/drivers/net/ethernet/intel/ice/ice_sbq_cmd.h
new file mode 100644
index 000000000000..ead75fe2bcda
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_sbq_cmd.h
@@ -0,0 +1,92 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2021, Intel Corporation. */
+
+#ifndef _ICE_SBQ_CMD_H_
+#define _ICE_SBQ_CMD_H_
+
+/* This header file defines the Sideband Queue commands, error codes and
+ * descriptor format. It is shared between Firmware and Software.
+ */
+
+/* Sideband Queue command structure and opcodes */
+enum ice_sbq_opc {
+	/* Sideband Queue commands */
+	ice_sbq_opc_neigh_dev_req			= 0x0C00,
+	ice_sbq_opc_neigh_dev_ev			= 0x0C01
+};
+
+/* Sideband Queue descriptor. Indirect command
+ * and non posted
+ */
+struct ice_sbq_cmd_desc {
+	__le16 flags;
+	__le16 opcode;
+	__le16 datalen;
+	__le16 cmd_retval;
+
+	/* Opaque message data */
+	__le32 cookie_high;
+	__le32 cookie_low;
+
+	union {
+		__le16 cmd_len;
+		__le16 cmpl_len;
+	} param0;
+
+	u8 reserved[6];
+	__le32 addr_high;
+	__le32 addr_low;
+};
+
+struct ice_sbq_evt_desc {
+	__le16 flags;
+	__le16 opcode;
+	__le16 datalen;
+	__le16 cmd_retval;
+	u8 data[24];
+};
+
+enum ice_sbq_msg_dev {
+	rmn_0	= 0x02,
+	rmn_1	= 0x03,
+	rmn_2	= 0x04,
+	cgu	= 0x06
+};
+
+enum ice_sbq_msg_opcode {
+	ice_sbq_msg_rd	= 0x00,
+	ice_sbq_msg_wr	= 0x01
+};
+
+#define ICE_SBQ_MSG_FLAGS	0x40
+#define ICE_SBQ_MSG_SBE_FBE	0x0F
+
+struct ice_sbq_msg_req {
+	u8 dest_dev;
+	u8 src_dev;
+	u8 opcode;
+	u8 flags;
+	u8 sbe_fbe;
+	u8 func_id;
+	__le16 msg_addr_low;
+	__le32 msg_addr_high;
+	__le32 data;
+};
+
+struct ice_sbq_msg_cmpl {
+	u8 dest_dev;
+	u8 src_dev;
+	u8 opcode;
+	u8 flags;
+	__le32 data;
+};
+
+/* Internal struct */
+struct ice_sbq_msg_input {
+	u8 dest_dev;
+	u8 opcode;
+	u16 msg_addr_low;
+	u32 msg_addr_high;
+	u32 data;
+};
+#endif /* _ICE_SBQ_CMD_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 61ea46dd80b7..4a40e2b3732a 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -14,6 +14,7 @@
 #include "ice_lan_tx_rx.h"
 #include "ice_flex_type.h"
 #include "ice_protocol_type.h"
+#include "ice_sbq_cmd.h"
 
 static inline bool ice_is_tc_ena(unsigned long bitmap, u8 tc)
 {
@@ -754,6 +755,7 @@ struct ice_hw {
 
 	/* Control Queue info */
 	struct ice_ctl_q_info adminq;
+	struct ice_ctl_q_info sbq;
 	struct ice_ctl_q_info mailboxq;
 
 	u8 api_branch;		/* API branch version */
-- 
2.26.2

