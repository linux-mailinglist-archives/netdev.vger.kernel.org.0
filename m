Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7276721DEF1
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbgGMRnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:43:31 -0400
Received: from mga14.intel.com ([192.55.52.115]:39715 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729969AbgGMRn2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 13:43:28 -0400
IronPort-SDR: qgGCdvMFf1TNccjSoFYYKBepUfk/KAM1ov/p8s8hp53qWjew8nr0aQ+Zv0T/vXJTRbiVu4yzlh
 KDVhOQpsquiw==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="147810212"
X-IronPort-AV: E=Sophos;i="5.75,348,1589266800"; 
   d="scan'208";a="147810212"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 10:43:27 -0700
IronPort-SDR: L+yug3U7wj+8Uu4YAMaSrwR6dyL7TR6V7iAQDhK8Y10pS6By9J6DMP/w2gI732FnQbv/I2X8Ca
 yROcjUc0jH7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,348,1589266800"; 
   d="scan'208";a="317450186"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 13 Jul 2020 10:43:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Haiyue Wang <haiyue.wang@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Nannan Lu <nannan.lu@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Date:   Mon, 13 Jul 2020 10:43:16 -0700
Message-Id: <20200713174320.3982049-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200713174320.3982049-1-anthony.l.nguyen@intel.com>
References: <20200713174320.3982049-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyue Wang <haiyue.wang@intel.com>

The DCF (Device Config Function) is a named trust VF (always with ID 0,
single entity per PF port) that can act as a sole controlling entity to
exercise advance functionality such as adding switch rules for the rest
of VFs.

To achieve this approach, this VF is permitted to send some basic AdminQ
commands to the PF through virtual channel (mailbox), then the PF driver
sends these commands to the firmware, and returns the response to the VF
again through virtual channel.

The AdminQ command from DCF is split into two parts: one is the AdminQ
descriptor, the other is the buffer (the descriptor has BUF flag set).
These two parts should be sent in order, so that the PF can handle them
correctly.

Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Tested-by: Nannan Lu <nannan.lu@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/Makefile       |   2 +-
 drivers/net/ethernet/intel/ice/ice.h          |   2 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   6 +
 drivers/net/ethernet/intel/ice/ice_dcf.c      |  49 +++++++
 drivers/net/ethernet/intel/ice/ice_dcf.h      |  20 +++
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 130 ++++++++++++++++++
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |   1 +
 include/linux/avf/virtchnl.h                  |  10 ++
 8 files changed, 219 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_dcf.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_dcf.h

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 980bbcc64b4b..eb83b5fe11c3 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -24,7 +24,7 @@ ice-y := ice_main.o	\
 	 ice_flow.o	\
 	 ice_devlink.o	\
 	 ice_ethtool.o
-ice-$(CONFIG_PCI_IOV) += ice_virtchnl_pf.o ice_sriov.o
+ice-$(CONFIG_PCI_IOV) += ice_virtchnl_pf.o ice_sriov.o ice_dcf.o
 ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_nl.o ice_dcb_lib.o
 ice-$(CONFIG_RFS_ACCEL) += ice_arfs.o
 ice-$(CONFIG_XDP_SOCKETS) += ice_xsk.o
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 7486d010a619..a6e419a3f547 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -435,6 +435,8 @@ struct ice_pf {
 	u32 tx_timeout_recovery_level;
 	char int_name[ICE_INT_NAME_STR_LEN];
 	u32 sw_int_count;
+
+	struct ice_dcf dcf;
 };
 
 struct ice_netdev_priv {
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 99c39249613a..89b91ccaf533 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1830,6 +1830,12 @@ enum ice_adminq_opc {
 	ice_aqc_opc_update_vsi				= 0x0211,
 	ice_aqc_opc_free_vsi				= 0x0213,
 
+	/* recipe commands */
+	ice_aqc_opc_add_recipe				= 0x0290,
+	ice_aqc_opc_recipe_to_profile			= 0x0291,
+	ice_aqc_opc_get_recipe				= 0x0292,
+	ice_aqc_opc_get_recipe_to_profile		= 0x0293,
+
 	/* switch rules population commands */
 	ice_aqc_opc_add_sw_rules			= 0x02A0,
 	ice_aqc_opc_update_sw_rules			= 0x02A1,
diff --git a/drivers/net/ethernet/intel/ice/ice_dcf.c b/drivers/net/ethernet/intel/ice/ice_dcf.c
new file mode 100644
index 000000000000..cbe60a0cb2d2
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_dcf.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2018-2020, Intel Corporation. */
+
+#include "ice.h"
+
+static const enum ice_adminq_opc aqc_permitted_tbl[] = {
+	/* Generic Firmware Admin commands */
+	ice_aqc_opc_get_ver,
+	ice_aqc_opc_req_res,
+	ice_aqc_opc_release_res,
+	ice_aqc_opc_list_func_caps,
+	ice_aqc_opc_list_dev_caps,
+
+	/* Package Configuration Admin Commands */
+	ice_aqc_opc_update_pkg,
+	ice_aqc_opc_get_pkg_info_list,
+
+	/* PHY commands */
+	ice_aqc_opc_get_phy_caps,
+	ice_aqc_opc_get_link_status,
+
+	/* Switch Block */
+	ice_aqc_opc_get_sw_cfg,
+	ice_aqc_opc_alloc_res,
+	ice_aqc_opc_free_res,
+	ice_aqc_opc_add_recipe,
+	ice_aqc_opc_recipe_to_profile,
+	ice_aqc_opc_get_recipe,
+	ice_aqc_opc_get_recipe_to_profile,
+	ice_aqc_opc_add_sw_rules,
+	ice_aqc_opc_update_sw_rules,
+	ice_aqc_opc_remove_sw_rules,
+};
+
+/**
+ * ice_dcf_aq_cmd_permitted - validate the AdminQ command permitted or not
+ * @desc: descriptor describing the command
+ */
+bool ice_dcf_aq_cmd_permitted(struct ice_aq_desc *desc)
+{
+	u16 opc = le16_to_cpu(desc->opcode);
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(aqc_permitted_tbl); i++)
+		if (opc == aqc_permitted_tbl[i])
+			return true;
+
+	return false;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_dcf.h b/drivers/net/ethernet/intel/ice/ice_dcf.h
new file mode 100644
index 000000000000..9edb2d5d9d8f
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_dcf.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2018-2020, Intel Corporation. */
+
+#ifndef _ICE_DCF_H_
+#define _ICE_DCF_H_
+
+struct ice_dcf {
+	/* Handle the AdminQ command between the DCF (Device Config Function)
+	 * and the firmware.
+	 */
+#define ICE_DCF_AQ_DESC_TIMEOUT	(HZ / 10)
+	struct ice_aq_desc aq_desc;
+	u8 aq_desc_received;
+	unsigned long aq_desc_expires;
+};
+
+#ifdef CONFIG_PCI_IOV
+bool ice_dcf_aq_cmd_permitted(struct ice_aq_desc *desc);
+#endif /* CONFIG_PCI_IOV */
+#endif /* _ICE_DCF_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 16a2f2526ccc..0851944b8fd4 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3652,6 +3652,130 @@ static int ice_vf_init_vlan_stripping(struct ice_vf *vf)
 		return ice_vsi_manage_vlan_stripping(vsi, false);
 }
 
+/**
+ * ice_dcf_handle_aq_cmd - handle the AdminQ command from DCF to FW
+ * @vf: pointer to the VF info
+ * @aq_desc: the AdminQ command descriptor
+ * @aq_buf: the AdminQ command buffer if aq_buf_size is non-zero
+ * @aq_buf_size: the AdminQ command buffer size
+ *
+ * The VF splits the AdminQ command into two parts: one is the descriptor of
+ * AdminQ command, the other is the buffer of AdminQ command (the descriptor
+ * has BUF flag set). When both of them are received by PF, this function will
+ * forward them to firmware once to get the AdminQ's response. And also, the
+ * filled descriptor and buffer of the response will be sent back to VF one by
+ * one through the virtchnl.
+ */
+static int
+ice_dcf_handle_aq_cmd(struct ice_vf *vf, struct ice_aq_desc *aq_desc,
+		      u8 *aq_buf, u16 aq_buf_size)
+{
+	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
+	struct ice_pf *pf = vf->pf;
+	enum virtchnl_ops v_op;
+	enum ice_status aq_ret;
+	u16 v_msg_len = 0;
+	u8 *v_msg = NULL;
+	int ret;
+
+	pf->dcf.aq_desc_received = false;
+
+	if ((aq_buf && !aq_buf_size) || (!aq_buf && aq_buf_size))
+		return -EINVAL;
+
+	aq_ret = ice_aq_send_cmd(&pf->hw, aq_desc, aq_buf, aq_buf_size, NULL);
+	/* It needs to send back the AQ response message if ICE_ERR_AQ_ERROR
+	 * returns, some AdminQ handlers will use the error code filled by FW
+	 * to do exception handling.
+	 */
+	if (aq_ret && aq_ret != ICE_ERR_AQ_ERROR) {
+		v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
+		v_op = VIRTCHNL_OP_DCF_CMD_DESC;
+		goto err;
+	}
+
+	ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DCF_CMD_DESC, v_ret,
+				    (u8 *)aq_desc, sizeof(*aq_desc));
+	/* Bail out so we don't send the VIRTCHNL_OP_DCF_CMD_BUFF message
+	 * below if failure happens or no AdminQ command buffer.
+	 */
+	if (ret || !aq_buf_size)
+		return ret;
+
+	v_op = VIRTCHNL_OP_DCF_CMD_BUFF;
+	v_msg_len = le16_to_cpu(aq_desc->datalen);
+
+	/* buffer is not updated if data length exceeds buffer size */
+	if (v_msg_len > aq_buf_size)
+		v_msg_len = 0;
+	else if (v_msg_len)
+		v_msg = aq_buf;
+
+	/* send the response back to the VF */
+err:
+	return ice_vc_send_msg_to_vf(vf, v_op, v_ret, v_msg, v_msg_len);
+}
+
+/**
+ * ice_vc_dcf_cmd_desc_msg - handle the DCF AdminQ command descriptor
+ * @vf: pointer to the VF info
+ * @msg: pointer to the msg buffer which holds the command descriptor
+ * @len: length of the message
+ */
+static int ice_vc_dcf_cmd_desc_msg(struct ice_vf *vf, u8 *msg, u16 len)
+{
+	struct ice_aq_desc *aq_desc = (struct ice_aq_desc *)msg;
+	struct ice_pf *pf = vf->pf;
+
+	if (len != sizeof(*aq_desc) || !ice_dcf_aq_cmd_permitted(aq_desc)) {
+		/* In case to avoid the VIRTCHNL_OP_DCF_CMD_DESC message with
+		 * the ICE_AQ_FLAG_BUF set followed by another bad message
+		 * VIRTCHNL_OP_DCF_CMD_DESC.
+		 */
+		pf->dcf.aq_desc_received = false;
+		goto err;
+	}
+
+	/* The AdminQ descriptor needs to be stored for use when the followed
+	 * VIRTCHNL_OP_DCF_CMD_BUFF is received.
+	 */
+	if (aq_desc->flags & cpu_to_le16(ICE_AQ_FLAG_BUF)) {
+		pf->dcf.aq_desc = *aq_desc;
+		pf->dcf.aq_desc_received = true;
+		pf->dcf.aq_desc_expires = jiffies + ICE_DCF_AQ_DESC_TIMEOUT;
+		return 0;
+	}
+
+	return ice_dcf_handle_aq_cmd(vf, aq_desc, NULL, 0);
+
+	/* send the response back to the VF */
+err:
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DCF_CMD_DESC,
+				     VIRTCHNL_STATUS_ERR_PARAM, NULL, 0);
+}
+
+/**
+ * ice_vc_dcf_cmd_buff_msg - handle the DCF AdminQ command buffer
+ * @vf: pointer to the VF info
+ * @msg: pointer to the msg buffer which holds the command buffer
+ * @len: length of the message
+ */
+static int ice_vc_dcf_cmd_buff_msg(struct ice_vf *vf, u8 *msg, u16 len)
+{
+	struct ice_pf *pf = vf->pf;
+
+	if (!len || !pf->dcf.aq_desc_received ||
+	    time_is_before_jiffies(pf->dcf.aq_desc_expires))
+		goto err;
+
+	return ice_dcf_handle_aq_cmd(vf, &pf->dcf.aq_desc, msg, len);
+
+	/* send the response back to the VF */
+err:
+	return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DCF_CMD_BUFF,
+				     VIRTCHNL_STATUS_ERR_PARAM, NULL, 0);
+}
+
 /**
  * ice_vc_process_vf_msg - Process request from VF
  * @pf: pointer to the PF structure
@@ -3762,6 +3886,12 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 	case VIRTCHNL_OP_DISABLE_VLAN_STRIPPING:
 		err = ice_vc_dis_vlan_stripping(vf);
 		break;
+	case VIRTCHNL_OP_DCF_CMD_DESC:
+		err = ice_vc_dcf_cmd_desc_msg(vf, msg, msglen);
+		break;
+	case VIRTCHNL_OP_DCF_CMD_BUFF:
+		err = ice_vc_dcf_cmd_buff_msg(vf, msg, msglen);
+		break;
 	case VIRTCHNL_OP_UNKNOWN:
 	default:
 		dev_err(dev, "Unsupported opcode %d from VF %d\n", v_opcode,
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 67aa9110fdd1..4a257415f6a5 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -4,6 +4,7 @@
 #ifndef _ICE_VIRTCHNL_PF_H_
 #define _ICE_VIRTCHNL_PF_H_
 #include "ice.h"
+#include "ice_dcf.h"
 
 /* Restrict number of MAC Addr and VLAN that non-trusted VF can programmed */
 #define ICE_MAX_VLAN_PER_VF		8
diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index 40bad71865ea..cd627a217b1c 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -136,6 +136,9 @@ enum virtchnl_ops {
 	VIRTCHNL_OP_DISABLE_CHANNELS = 31,
 	VIRTCHNL_OP_ADD_CLOUD_FILTER = 32,
 	VIRTCHNL_OP_DEL_CLOUD_FILTER = 33,
+	/* opcode 34, 35, 36, 37 and 38 are reserved */
+	VIRTCHNL_OP_DCF_CMD_DESC = 39,
+	VIRTCHNL_OP_DCF_CMD_BUFF = 40,
 };
 
 /* These macros are used to generate compilation errors if a structure/union
@@ -828,6 +831,13 @@ virtchnl_vc_validate_vf_msg(struct virtchnl_version_info *ver, u32 v_opcode,
 	case VIRTCHNL_OP_DEL_CLOUD_FILTER:
 		valid_len = sizeof(struct virtchnl_filter);
 		break;
+	case VIRTCHNL_OP_DCF_CMD_DESC:
+	case VIRTCHNL_OP_DCF_CMD_BUFF:
+		/* These two opcodes are specific to handle the AdminQ command,
+		 * so the validation needs to be done in PF's context.
+		 */
+		valid_len = msglen;
+		break;
 	/* These are always errors coming from the VF. */
 	case VIRTCHNL_OP_EVENT:
 	case VIRTCHNL_OP_UNKNOWN:
-- 
2.26.2

