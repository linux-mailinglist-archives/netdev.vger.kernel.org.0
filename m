Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0DFF3B31
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbfKGWPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:15:51 -0500
Received: from mga07.intel.com ([134.134.136.100]:16692 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727544AbfKGWOq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 17:14:46 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Nov 2019 14:14:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,279,1569308400"; 
   d="scan'208";a="233420937"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 07 Nov 2019 14:14:45 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/15] ice: use more accurate ICE_DBG mask types
Date:   Thu,  7 Nov 2019 14:14:37 -0800
Message-Id: <20191107221438.17994-15-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191107221438.17994-1-jeffrey.t.kirsher@intel.com>
References: <20191107221438.17994-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

ice_debug_cq is passed a mask which is always ICE_DBG_AQ_CMD. Modify this
function, removing the mask parameter entirely, and directly use the more
appropriate ICE_DBG_AQ_DESC and ICE_DBG_AQ_DESC_BUF.

The function is only called from ice_controlq.c, and has no
other callers outside of that file. Move it and mark it static to avoid
namespace pollution.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c   | 50 ----------------
 drivers/net/ethernet/intel/ice/ice_common.h   |  2 -
 drivers/net/ethernet/intel/ice/ice_controlq.c | 57 +++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_type.h     |  2 +
 4 files changed, 53 insertions(+), 58 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 3e0d50c1bc7a..36be501ae623 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1251,56 +1251,6 @@ const struct ice_ctx_ele ice_tlan_ctx_info[] = {
 	{ 0 }
 };
 
-/**
- * ice_debug_cq
- * @hw: pointer to the hardware structure
- * @mask: debug mask
- * @desc: pointer to control queue descriptor
- * @buf: pointer to command buffer
- * @buf_len: max length of buf
- *
- * Dumps debug log about control command with descriptor contents.
- */
-void
-ice_debug_cq(struct ice_hw *hw, u32 __maybe_unused mask, void *desc, void *buf,
-	     u16 buf_len)
-{
-	struct ice_aq_desc *cq_desc = (struct ice_aq_desc *)desc;
-	u16 len;
-
-#ifndef CONFIG_DYNAMIC_DEBUG
-	if (!(mask & hw->debug_mask))
-		return;
-#endif
-
-	if (!desc)
-		return;
-
-	len = le16_to_cpu(cq_desc->datalen);
-
-	ice_debug(hw, mask,
-		  "CQ CMD: opcode 0x%04X, flags 0x%04X, datalen 0x%04X, retval 0x%04X\n",
-		  le16_to_cpu(cq_desc->opcode),
-		  le16_to_cpu(cq_desc->flags),
-		  le16_to_cpu(cq_desc->datalen), le16_to_cpu(cq_desc->retval));
-	ice_debug(hw, mask, "\tcookie (h,l) 0x%08X 0x%08X\n",
-		  le32_to_cpu(cq_desc->cookie_high),
-		  le32_to_cpu(cq_desc->cookie_low));
-	ice_debug(hw, mask, "\tparam (0,1)  0x%08X 0x%08X\n",
-		  le32_to_cpu(cq_desc->params.generic.param0),
-		  le32_to_cpu(cq_desc->params.generic.param1));
-	ice_debug(hw, mask, "\taddr (h,l)   0x%08X 0x%08X\n",
-		  le32_to_cpu(cq_desc->params.generic.addr_high),
-		  le32_to_cpu(cq_desc->params.generic.addr_low));
-	if (buf && cq_desc->datalen != 0) {
-		ice_debug(hw, mask, "Buffer:\n");
-		if (buf_len < len)
-			len = buf_len;
-
-		ice_debug_array(hw, mask, 16, 1, (u8 *)buf, len);
-	}
-}
-
 /* FW Admin Queue command wrappers */
 
 /* Software lock/mutex that is meant to be held while the Global Config Lock
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 5a52f3b3e688..b22aa561e253 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -13,8 +13,6 @@
 
 enum ice_status ice_nvm_validate_checksum(struct ice_hw *hw);
 
-void
-ice_debug_cq(struct ice_hw *hw, u32 mask, void *desc, void *buf, u16 buf_len);
 enum ice_status ice_init_hw(struct ice_hw *hw);
 void ice_deinit_hw(struct ice_hw *hw);
 enum ice_status
diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
index c68709c7ef81..947728aada46 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
@@ -809,6 +809,52 @@ static u16 ice_clean_sq(struct ice_hw *hw, struct ice_ctl_q_info *cq)
 	return ICE_CTL_Q_DESC_UNUSED(sq);
 }
 
+/**
+ * ice_debug_cq
+ * @hw: pointer to the hardware structure
+ * @desc: pointer to control queue descriptor
+ * @buf: pointer to command buffer
+ * @buf_len: max length of buf
+ *
+ * Dumps debug log about control command with descriptor contents.
+ */
+static void ice_debug_cq(struct ice_hw *hw, void *desc, void *buf, u16 buf_len)
+{
+	struct ice_aq_desc *cq_desc = (struct ice_aq_desc *)desc;
+	u16 len;
+
+	if (!IS_ENABLED(CONFIG_DYNAMIC_DEBUG) &&
+	    !((ICE_DBG_AQ_DESC | ICE_DBG_AQ_DESC_BUF) & hw->debug_mask))
+		return;
+
+	if (!desc)
+		return;
+
+	len = le16_to_cpu(cq_desc->datalen);
+
+	ice_debug(hw, ICE_DBG_AQ_DESC,
+		  "CQ CMD: opcode 0x%04X, flags 0x%04X, datalen 0x%04X, retval 0x%04X\n",
+		  le16_to_cpu(cq_desc->opcode),
+		  le16_to_cpu(cq_desc->flags),
+		  le16_to_cpu(cq_desc->datalen), le16_to_cpu(cq_desc->retval));
+	ice_debug(hw, ICE_DBG_AQ_DESC, "\tcookie (h,l) 0x%08X 0x%08X\n",
+		  le32_to_cpu(cq_desc->cookie_high),
+		  le32_to_cpu(cq_desc->cookie_low));
+	ice_debug(hw, ICE_DBG_AQ_DESC, "\tparam (0,1)  0x%08X 0x%08X\n",
+		  le32_to_cpu(cq_desc->params.generic.param0),
+		  le32_to_cpu(cq_desc->params.generic.param1));
+	ice_debug(hw, ICE_DBG_AQ_DESC, "\taddr (h,l)   0x%08X 0x%08X\n",
+		  le32_to_cpu(cq_desc->params.generic.addr_high),
+		  le32_to_cpu(cq_desc->params.generic.addr_low));
+	if (buf && cq_desc->datalen != 0) {
+		ice_debug(hw, ICE_DBG_AQ_DESC_BUF, "Buffer:\n");
+		if (buf_len < len)
+			len = buf_len;
+
+		ice_debug_array(hw, ICE_DBG_AQ_DESC_BUF, 16, 1, (u8 *)buf, len);
+	}
+}
+
 /**
  * ice_sq_done - check if FW has processed the Admin Send Queue (ATQ)
  * @hw: pointer to the HW struct
@@ -934,10 +980,10 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 	}
 
 	/* Debug desc and buffer */
-	ice_debug(hw, ICE_DBG_AQ_MSG,
+	ice_debug(hw, ICE_DBG_AQ_DESC,
 		  "ATQ: Control Send queue desc and buffer:\n");
 
-	ice_debug_cq(hw, ICE_DBG_AQ_CMD, (void *)desc_on_ring, buf, buf_size);
+	ice_debug_cq(hw, (void *)desc_on_ring, buf, buf_size);
 
 	(cq->sq.next_to_use)++;
 	if (cq->sq.next_to_use == cq->sq.count)
@@ -986,7 +1032,7 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 	ice_debug(hw, ICE_DBG_AQ_MSG,
 		  "ATQ: desc and buffer writeback:\n");
 
-	ice_debug_cq(hw, ICE_DBG_AQ_CMD, (void *)desc, buf, buf_size);
+	ice_debug_cq(hw, (void *)desc, buf, buf_size);
 
 	/* save writeback AQ if requested */
 	if (details->wb_desc)
@@ -1084,10 +1130,9 @@ ice_clean_rq_elem(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 	if (e->msg_buf && e->msg_len)
 		memcpy(e->msg_buf, cq->rq.r.rq_bi[desc_idx].va, e->msg_len);
 
-	ice_debug(hw, ICE_DBG_AQ_MSG, "ARQ: desc and buffer:\n");
+	ice_debug(hw, ICE_DBG_AQ_DESC, "ARQ: desc and buffer:\n");
 
-	ice_debug_cq(hw, ICE_DBG_AQ_CMD, (void *)desc, e->msg_buf,
-		     cq->rq_buf_size);
+	ice_debug_cq(hw, (void *)desc, e->msg_buf, cq->rq_buf_size);
 
 	/* Restore the original datalen and buffer address in the desc,
 	 * FW updates datalen to indicate the event message size
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index d3d7049c97f0..eba8b04b8cbd 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -46,6 +46,8 @@ static inline u32 ice_round_to_num(u32 N, u32 R)
 #define ICE_DBG_PKG		BIT_ULL(16)
 #define ICE_DBG_RES		BIT_ULL(17)
 #define ICE_DBG_AQ_MSG		BIT_ULL(24)
+#define ICE_DBG_AQ_DESC		BIT_ULL(25)
+#define ICE_DBG_AQ_DESC_BUF	BIT_ULL(26)
 #define ICE_DBG_AQ_CMD		BIT_ULL(27)
 #define ICE_DBG_USER		BIT_ULL(31)
 
-- 
2.21.0

