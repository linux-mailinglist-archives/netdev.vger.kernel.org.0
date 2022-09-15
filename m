Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066AC5B9C2E
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 15:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiIONoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 09:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiIONnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 09:43:55 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27878993F
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 06:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663249433; x=1694785433;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cJ1d+KPgbWFrLzkM1/Jdx1RUCiaFa52aisb5dz3ERNA=;
  b=FcuGUuSZ3FaA6mr06YlEtJkoa2fFw9nXkPHlJefStVUgskJXq9sAlBMh
   vtngyyvWjVidFxTh/PAd5JKazDAE6pZigKRC+8QOLcAaNOv9Y8S/RFM2I
   a+7ZHs9bgoaV7mOnGXzg/Fzq7390FacUguD/ghnZ0KcahABoNurv9AIcV
   gvL+/da1aMiEz+sVNg1TQdabPd9UqlLmezB4PkY+2EkZUV/QK0ww7kaB5
   2vqfB7rKabRjYBPtCp89oMRDbvCs0U0Y3MGxTStl/y4lwR50U3t6aIgF5
   /qPZIqarYebby4hU3HarZiorBliRhBOo7ee/2YegGun91e5jYUwVv6g5x
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="279100013"
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="279100013"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 06:43:52 -0700
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="617278943"
Received: from unknown (HELO DCG-LAB-MODULE2.gar.corp.intel.com) ([10.123.220.6])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 06:43:49 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, dchumak@nvidia.com, maximmi@nvidia.com,
        jiri@resnulli.us, simon.horman@corigine.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com,
        Ben Shelton <benjamin.h.shelton@intel.com>,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [RFC PATCH net-next v4 1/6] ice: Add function for move/reconfigure TxQ AQ command
Date:   Thu, 15 Sep 2022 15:42:34 +0200
Message-Id: <20220915134239.1935604-2-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220915134239.1935604-1-michal.wilczynski@intel.com>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Shelton <benjamin.h.shelton@intel.com>

Currently there is no way to reconfigure queues in ice driver
Tx scheduler topology. Add a function that will allow us to do
so. This will enable us to allow user to change this manually
using devlink-rate interface.

Signed-off-by: Ben Shelton <benjamin.h.shelton@intel.com>
Co-developed-by: Michal Wilczynski <michal.wilczynski@intel.com>
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 37 ++++++++++
 drivers/net/ethernet/intel/ice/ice_common.c   | 70 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h   |  8 +++
 drivers/net/ethernet/intel/ice/ice_main.c     |  2 +
 4 files changed, 117 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 1bdc70aa979d..7574267f014e 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1910,6 +1910,40 @@ struct ice_aqc_dis_txq_item {
 	__le16 q_id[];
 } __packed;
 
+struct ice_aqc_move_txqs {
+	u8 cmd_type;
+#define ICE_AQC_Q_CMD_TYPE_M		GENMASK(1, 0)
+#define ICE_AQC_Q_CMD_TYPE_MOVE		1
+#define ICE_AQC_Q_CMD_TYPE_TC_CHANGE	2
+#define ICE_AQC_Q_CMD_TYPE_MOVE_AND_TC	3
+#define ICE_AQC_Q_CMD_SUBSEQ_CALL	BIT(2)
+#define ICE_AQC_Q_CMD_FLUSH_PIPE	BIT(3)
+
+	u8 num_qs;
+	u8 rsvd;
+	u8 timeout;
+#define ICE_AQC_Q_CMD_TIMEOUT_M		GENMASK(5, 2)
+
+	__le32 blocked_cgds;
+	__le32 addr_high;
+	__le32 addr_low;
+};
+
+static_assert(sizeof(struct ice_aqc_move_txqs) == 16);
+
+struct ice_aqc_move_txqs_elem {
+	__le16 txq_id;
+	u8 q_cgd;
+	u8 rsvd;
+	__le32 q_teid;
+};
+
+struct ice_aqc_move_txqs_data {
+	__le32 src_teid;
+	__le32 dest_teid;
+	struct ice_aqc_move_txqs_elem txqs[];
+};
+
 /* Add Tx RDMA Queue Set (indirect 0x0C33) */
 struct ice_aqc_add_rdma_qset {
 	u8 num_qset_grps;
@@ -2148,6 +2182,7 @@ struct ice_aq_desc {
 		struct ice_aqc_get_topo get_topo;
 		struct ice_aqc_sched_elem_cmd sched_elem_cmd;
 		struct ice_aqc_query_txsched_res query_sched_res;
+		struct ice_aqc_move_txqs move_txqs;
 		struct ice_aqc_query_port_ets port_ets;
 		struct ice_aqc_rl_profile rl_profile;
 		struct ice_aqc_nvm nvm;
@@ -2207,6 +2242,7 @@ enum ice_aq_err {
 	ICE_AQ_RC_OK		= 0,  /* Success */
 	ICE_AQ_RC_EPERM		= 1,  /* Operation not permitted */
 	ICE_AQ_RC_ENOENT	= 2,  /* No such element */
+	ICE_AQ_RC_EAGAIN	= 8,  /* Try again */
 	ICE_AQ_RC_ENOMEM	= 9,  /* Out of memory */
 	ICE_AQ_RC_EBUSY		= 12, /* Device or resource busy */
 	ICE_AQ_RC_EEXIST	= 13, /* Object already exists */
@@ -2342,6 +2378,7 @@ enum ice_adminq_opc {
 	/* Tx queue handling commands/events */
 	ice_aqc_opc_add_txqs				= 0x0C30,
 	ice_aqc_opc_dis_txqs				= 0x0C31,
+	ice_aqc_opc_move_recfg_txqs			= 0x0C32,
 	ice_aqc_opc_add_rdma_qset			= 0x0C33,
 
 	/* package commands */
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index bec770e34f39..39769141c8e8 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -7,6 +7,7 @@
 #include "ice_flow.h"
 
 #define ICE_PF_RESET_WAIT_COUNT	300
+#define ICE_LAN_TXQ_MOVE_TIMEOUT_MAX	50
 
 static const char * const ice_link_mode_str_low[] = {
 	[0] = "100BASE_TX",
@@ -4189,6 +4190,75 @@ ice_aq_dis_lan_txq(struct ice_hw *hw, u8 num_qgrps,
 	return status;
 }
 
+/**
+ * ice_aq_move_recfg_lan_txq
+ * @hw: pointer to the hardware structure
+ * @num_qs: number of queues to move/reconfigure
+ * @is_move: true if this operation involves node movement
+ * @is_tc_change: true if this operation involves a TC change
+ * @subseq_call: true if this operation is a subsequent call
+ * @flush_pipe: on timeout, true to flush pipe, false to return EAGAIN
+ * @timeout: timeout in units of 100 usec (valid values 0-50)
+ * @blocked_cgds: out param, bitmap of CGDs that timed out if returning EAGAIN
+ * @buf: struct containing src/dest TEID and per-queue info
+ * @buf_size: size of buffer for indirect command
+ * @txqs_moved: out param, number of queues successfully moved
+ * @cd: pointer to command details structure or NULL
+ *
+ * Move / Reconfigure Tx LAN queues (0x0C32)
+ */
+int
+ice_aq_move_recfg_lan_txq(struct ice_hw *hw, u8 num_qs, bool is_move,
+			  bool is_tc_change, bool subseq_call, bool flush_pipe,
+			  u8 timeout, u32 *blocked_cgds,
+			  struct ice_aqc_move_txqs_data *buf, u16 buf_size,
+			  u8 *txqs_moved, struct ice_sq_cd *cd)
+{
+	struct ice_aqc_move_txqs *cmd;
+	struct ice_aq_desc desc;
+	int status;
+
+	cmd = &desc.params.move_txqs;
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_move_recfg_txqs);
+
+	if (timeout > ICE_LAN_TXQ_MOVE_TIMEOUT_MAX)
+		return -EINVAL;
+
+	if (is_tc_change && !flush_pipe && !blocked_cgds)
+		return -EINVAL;
+
+	if (!is_move && !is_tc_change)
+		return -EINVAL;
+
+	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
+
+	if (is_move)
+		cmd->cmd_type |= FIELD_PREP(ICE_AQC_Q_CMD_TYPE_M, ICE_AQC_Q_CMD_TYPE_MOVE);
+
+	if (is_tc_change)
+		cmd->cmd_type |= FIELD_PREP(ICE_AQC_Q_CMD_TYPE_M, ICE_AQC_Q_CMD_TYPE_TC_CHANGE);
+
+	if (subseq_call)
+		cmd->cmd_type |= ICE_AQC_Q_CMD_SUBSEQ_CALL;
+
+	if (flush_pipe)
+		cmd->cmd_type |= ICE_AQC_Q_CMD_FLUSH_PIPE;
+
+	cmd->num_qs = num_qs;
+	cmd->timeout = FIELD_PREP(ICE_AQC_Q_CMD_TIMEOUT_M, timeout);
+
+	status = ice_aq_send_cmd(hw, &desc, buf, buf_size, cd);
+
+	if (!status && txqs_moved)
+		*txqs_moved = cmd->num_qs;
+
+	if (hw->adminq.sq_last_status == ICE_AQ_RC_EAGAIN &&
+	    is_tc_change && !flush_pipe)
+		*blocked_cgds = le32_to_cpu(cmd->blocked_cgds);
+
+	return status;
+}
+
 /**
  * ice_aq_add_rdma_qsets
  * @hw: pointer to the hardware structure
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 8b6712b92e84..996dc7d81f62 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -185,6 +185,14 @@ int
 ice_ena_vsi_txq(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u16 q_handle,
 		u8 num_qgrps, struct ice_aqc_add_tx_qgrp *buf, u16 buf_size,
 		struct ice_sq_cd *cd);
+
+int
+ice_aq_move_recfg_lan_txq(struct ice_hw *hw, u8 num_qs, bool is_move,
+			  bool is_tc_change, bool subseq_call, bool flush_pipe,
+			  u8 timeout, u32 *blocked_cgds,
+			  struct ice_aqc_move_txqs_data *buf, u16 buf_size,
+			  u8 *txqs_moved, struct ice_sq_cd *cd);
+
 int ice_replay_vsi(struct ice_hw *hw, u16 vsi_handle);
 void ice_replay_post(struct ice_hw *hw);
 void ice_output_fw_log(struct ice_hw *hw, struct ice_aq_desc *desc, void *buf);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 7f59050e4122..20f8bb08e479 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -7377,6 +7377,8 @@ const char *ice_aq_str(enum ice_aq_err aq_err)
 	switch (aq_err) {
 	case ICE_AQ_RC_OK:
 		return "OK";
+	case ICE_AQ_RC_EAGAIN:
+		return "ICE_AQ_RC_EAGAIN";
 	case ICE_AQ_RC_EPERM:
 		return "ICE_AQ_RC_EPERM";
 	case ICE_AQ_RC_ENOENT:
-- 
2.37.2

