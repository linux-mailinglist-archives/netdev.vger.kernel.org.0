Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59F6358953
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhDHQLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:11:52 -0400
Received: from mga07.intel.com ([134.134.136.100]:15195 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231772AbhDHQLu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:11:50 -0400
IronPort-SDR: ku1LFHgO8WQUp0dTVJ8ae0eGOCkPXNuKqer4/AJuXrJiXUBlnL0cX8tr4q8HxRuI6y993WsA+t
 KSpHT9Sz1FeA==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="257557978"
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="257557978"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 09:11:38 -0700
IronPort-SDR: 3VC/FukQO06LbKb9hJeI/erR0tEbJ/TAA/XnmR0X064kS+UnOMfmbLfjURV/NBn3/X/4Q2HxQx
 BZgT2kjwj6aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="415841388"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 08 Apr 2021 09:11:38 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Chinh T Cao <chinh.t.cao@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 01/15] ice: Re-send some AQ commands, as result of EBUSY AQ error
Date:   Thu,  8 Apr 2021 09:13:07 -0700
Message-Id: <20210408161321.3218024-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
References: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chinh T Cao <chinh.t.cao@intel.com>

Retry sending some AQ commands, as result of EBUSY AQ error.
ice_aqc_opc_get_link_topo
ice_aqc_opc_lldp_stop
ice_aqc_opc_lldp_start
ice_aqc_opc_lldp_filter_ctrl

This change follows the latest guidelines from HW team. It is
better to retry the same AQ command several times, as the result
of EBUSY, instead of returning error to the caller right away.

Signed-off-by: Chinh T Cao <chinh.t.cao@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c   | 81 ++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_common.h   |  3 +
 drivers/net/ethernet/intel/ice/ice_controlq.c |  2 +-
 3 files changed, 84 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 54df00ee912b..bde19e30394d 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1292,6 +1292,85 @@ const struct ice_ctx_ele ice_tlan_ctx_info[] = {
  */
 DEFINE_MUTEX(ice_global_cfg_lock_sw);
 
+/**
+ * ice_should_retry_sq_send_cmd
+ * @opcode: AQ opcode
+ *
+ * Decide if we should retry the send command routine for the ATQ, depending
+ * on the opcode.
+ */
+static bool ice_should_retry_sq_send_cmd(u16 opcode)
+{
+	switch (opcode) {
+	case ice_aqc_opc_get_link_topo:
+	case ice_aqc_opc_lldp_stop:
+	case ice_aqc_opc_lldp_start:
+	case ice_aqc_opc_lldp_filter_ctrl:
+		return true;
+	}
+
+	return false;
+}
+
+/**
+ * ice_sq_send_cmd_retry - send command to Control Queue (ATQ)
+ * @hw: pointer to the HW struct
+ * @cq: pointer to the specific Control queue
+ * @desc: prefilled descriptor describing the command
+ * @buf: buffer to use for indirect commands (or NULL for direct commands)
+ * @buf_size: size of buffer for indirect commands (or 0 for direct commands)
+ * @cd: pointer to command details structure
+ *
+ * Retry sending the FW Admin Queue command, multiple times, to the FW Admin
+ * Queue if the EBUSY AQ error is returned.
+ */
+static enum ice_status
+ice_sq_send_cmd_retry(struct ice_hw *hw, struct ice_ctl_q_info *cq,
+		      struct ice_aq_desc *desc, void *buf, u16 buf_size,
+		      struct ice_sq_cd *cd)
+{
+	struct ice_aq_desc desc_cpy;
+	enum ice_status status;
+	bool is_cmd_for_retry;
+	u8 *buf_cpy = NULL;
+	u8 idx = 0;
+	u16 opcode;
+
+	opcode = le16_to_cpu(desc->opcode);
+	is_cmd_for_retry = ice_should_retry_sq_send_cmd(opcode);
+	memset(&desc_cpy, 0, sizeof(desc_cpy));
+
+	if (is_cmd_for_retry) {
+		if (buf) {
+			buf_cpy = kzalloc(buf_size, GFP_KERNEL);
+			if (!buf_cpy)
+				return ICE_ERR_NO_MEMORY;
+		}
+
+		memcpy(&desc_cpy, desc, sizeof(desc_cpy));
+	}
+
+	do {
+		status = ice_sq_send_cmd(hw, cq, desc, buf, buf_size, cd);
+
+		if (!is_cmd_for_retry || !status ||
+		    hw->adminq.sq_last_status != ICE_AQ_RC_EBUSY)
+			break;
+
+		if (buf_cpy)
+			memcpy(buf, buf_cpy, buf_size);
+
+		memcpy(desc, &desc_cpy, sizeof(desc_cpy));
+
+		mdelay(ICE_SQ_SEND_DELAY_TIME_MS);
+
+	} while (++idx < ICE_SQ_SEND_MAX_EXECUTE);
+
+	kfree(buf_cpy);
+
+	return status;
+}
+
 /**
  * ice_aq_send_cmd - send FW Admin Queue command to FW Admin Queue
  * @hw: pointer to the HW struct
@@ -1333,7 +1412,7 @@ ice_aq_send_cmd(struct ice_hw *hw, struct ice_aq_desc *desc, void *buf,
 		break;
 	}
 
-	status = ice_sq_send_cmd(hw, &hw->adminq, desc, buf, buf_size, cd);
+	status = ice_sq_send_cmd_retry(hw, &hw->adminq, desc, buf, buf_size, cd);
 	if (lock_acquired)
 		mutex_unlock(&ice_global_cfg_lock_sw);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 81fd69cb1485..d14406b11c92 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -11,6 +11,9 @@
 #include "ice_switch.h"
 #include <linux/avf/virtchnl.h>
 
+#define ICE_SQ_SEND_DELAY_TIME_MS	10
+#define ICE_SQ_SEND_MAX_EXECUTE		3
+
 enum ice_status ice_init_hw(struct ice_hw *hw);
 void ice_deinit_hw(struct ice_hw *hw);
 enum ice_status ice_check_reset(struct ice_hw *hw);
diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
index b2d8a5932b1d..0f207a42ea77 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
@@ -892,7 +892,7 @@ static bool ice_sq_done(struct ice_hw *hw, struct ice_ctl_q_info *cq)
  * ice_sq_send_cmd - send command to Control Queue (ATQ)
  * @hw: pointer to the HW struct
  * @cq: pointer to the specific Control queue
- * @desc: prefilled descriptor describing the command (non DMA mem)
+ * @desc: prefilled descriptor describing the command
  * @buf: buffer to use for indirect commands (or NULL for direct commands)
  * @buf_size: size of buffer for indirect commands (or 0 for direct commands)
  * @cd: pointer to command details structure
-- 
2.26.2

