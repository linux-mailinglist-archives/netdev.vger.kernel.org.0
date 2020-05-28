Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7E71E588D
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgE1H0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:26:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:14688 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbgE1HZo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 03:25:44 -0400
IronPort-SDR: bP60wIWXmHeM9QvvFd8tWQkBhpsfzHyR2z/xtnDn1V60nfVl2Qq2xuL0Y6uiXUjDFWJlb98Z7S
 NZC1qZTRhJBA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 00:25:43 -0700
IronPort-SDR: +d0BhzgArZa8ivZxH5+P/g6JmMmZHFpmleQxQSBq/shZEeXo4Rg7EDZa34FKSy6rb10qKx6dga
 WhbMpEWGt8vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,443,1583222400"; 
   d="scan'208";a="310831130"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 28 May 2020 00:25:42 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Evan Swanson <evan.swanson@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 09/15] ice: Handle critical FW error during admin queue initialization
Date:   Thu, 28 May 2020 00:25:32 -0700
Message-Id: <20200528072538.1621790-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
References: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Evan Swanson <evan.swanson@intel.com>

A race condition between FW and SW can occur between admin queue setup and
the first command sent. A link event may occur and FW attempts to notify a
non-existent queue. FW will set the critical error bit and disable the
queue. When this happens retry queue setup.

Signed-off-by: Evan Swanson <evan.swanson@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_controlq.c | 126 ++++++++++--------
 drivers/net/ethernet/intel/ice/ice_controlq.h |   3 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   2 +
 drivers/net/ethernet/intel/ice/ice_main.c     |   2 +
 drivers/net/ethernet/intel/ice/ice_status.h   |   1 +
 5 files changed, 80 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
index 62c2c1e621d2..479a74efc536 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
@@ -12,6 +12,7 @@ do {								\
 	(qinfo)->sq.bal = prefix##_ATQBAL;			\
 	(qinfo)->sq.len_mask = prefix##_ATQLEN_ATQLEN_M;	\
 	(qinfo)->sq.len_ena_mask = prefix##_ATQLEN_ATQENABLE_M;	\
+	(qinfo)->sq.len_crit_mask = prefix##_ATQLEN_ATQCRIT_M;	\
 	(qinfo)->sq.head_mask = prefix##_ATQH_ATQH_M;		\
 	(qinfo)->rq.head = prefix##_ARQH;			\
 	(qinfo)->rq.tail = prefix##_ARQT;			\
@@ -20,6 +21,7 @@ do {								\
 	(qinfo)->rq.bal = prefix##_ARQBAL;			\
 	(qinfo)->rq.len_mask = prefix##_ARQLEN_ARQLEN_M;	\
 	(qinfo)->rq.len_ena_mask = prefix##_ARQLEN_ARQENABLE_M;	\
+	(qinfo)->rq.len_crit_mask = prefix##_ARQLEN_ARQCRIT_M;	\
 	(qinfo)->rq.head_mask = prefix##_ARQH_ARQH_M;		\
 } while (0)
 
@@ -641,6 +643,50 @@ static enum ice_status ice_init_ctrlq(struct ice_hw *hw, enum ice_ctl_q q_type)
 	return ret_code;
 }
 
+/**
+ * ice_shutdown_ctrlq - shutdown routine for any control queue
+ * @hw: pointer to the hardware structure
+ * @q_type: specific Control queue type
+ *
+ * NOTE: this function does not destroy the control queue locks.
+ */
+static void ice_shutdown_ctrlq(struct ice_hw *hw, enum ice_ctl_q q_type)
+{
+	struct ice_ctl_q_info *cq;
+
+	switch (q_type) {
+	case ICE_CTL_Q_ADMIN:
+		cq = &hw->adminq;
+		if (ice_check_sq_alive(hw, cq))
+			ice_aq_q_shutdown(hw, true);
+		break;
+	case ICE_CTL_Q_MAILBOX:
+		cq = &hw->mailboxq;
+		break;
+	default:
+		return;
+	}
+
+	ice_shutdown_sq(hw, cq);
+	ice_shutdown_rq(hw, cq);
+}
+
+/**
+ * ice_shutdown_all_ctrlq - shutdown routine for all control queues
+ * @hw: pointer to the hardware structure
+ *
+ * NOTE: this function does not destroy the control queue locks. The driver
+ * may call this at runtime to shutdown and later restart control queues, such
+ * as in response to a reset event.
+ */
+void ice_shutdown_all_ctrlq(struct ice_hw *hw)
+{
+	/* Shutdown FW admin queue */
+	ice_shutdown_ctrlq(hw, ICE_CTL_Q_ADMIN);
+	/* Shutdown PF-VF Mailbox */
+	ice_shutdown_ctrlq(hw, ICE_CTL_Q_MAILBOX);
+}
+
 /**
  * ice_init_all_ctrlq - main initialization routine for all control queues
  * @hw: pointer to the hardware structure
@@ -656,17 +702,27 @@ static enum ice_status ice_init_ctrlq(struct ice_hw *hw, enum ice_ctl_q q_type)
  */
 enum ice_status ice_init_all_ctrlq(struct ice_hw *hw)
 {
-	enum ice_status ret_code;
+	enum ice_status status;
+	u32 retry = 0;
 
 	/* Init FW admin queue */
-	ret_code = ice_init_ctrlq(hw, ICE_CTL_Q_ADMIN);
-	if (ret_code)
-		return ret_code;
+	do {
+		status = ice_init_ctrlq(hw, ICE_CTL_Q_ADMIN);
+		if (status)
+			return status;
 
-	ret_code = ice_init_check_adminq(hw);
-	if (ret_code)
-		return ret_code;
+		status = ice_init_check_adminq(hw);
+		if (status != ICE_ERR_AQ_FW_CRITICAL)
+			break;
 
+		ice_debug(hw, ICE_DBG_AQ_MSG,
+			  "Retry Admin Queue init due to FW critical error\n");
+		ice_shutdown_ctrlq(hw, ICE_CTL_Q_ADMIN);
+		msleep(ICE_CTL_Q_ADMIN_INIT_MSEC);
+	} while (retry++ < ICE_CTL_Q_ADMIN_INIT_TIMEOUT);
+
+	if (status)
+		return status;
 	/* Init Mailbox queue */
 	return ice_init_ctrlq(hw, ICE_CTL_Q_MAILBOX);
 }
@@ -707,50 +763,6 @@ enum ice_status ice_create_all_ctrlq(struct ice_hw *hw)
 	return ice_init_all_ctrlq(hw);
 }
 
-/**
- * ice_shutdown_ctrlq - shutdown routine for any control queue
- * @hw: pointer to the hardware structure
- * @q_type: specific Control queue type
- *
- * NOTE: this function does not destroy the control queue locks.
- */
-static void ice_shutdown_ctrlq(struct ice_hw *hw, enum ice_ctl_q q_type)
-{
-	struct ice_ctl_q_info *cq;
-
-	switch (q_type) {
-	case ICE_CTL_Q_ADMIN:
-		cq = &hw->adminq;
-		if (ice_check_sq_alive(hw, cq))
-			ice_aq_q_shutdown(hw, true);
-		break;
-	case ICE_CTL_Q_MAILBOX:
-		cq = &hw->mailboxq;
-		break;
-	default:
-		return;
-	}
-
-	ice_shutdown_sq(hw, cq);
-	ice_shutdown_rq(hw, cq);
-}
-
-/**
- * ice_shutdown_all_ctrlq - shutdown routine for all control queues
- * @hw: pointer to the hardware structure
- *
- * NOTE: this function does not destroy the control queue locks. The driver
- * may call this at runtime to shutdown and later restart control queues, such
- * as in response to a reset event.
- */
-void ice_shutdown_all_ctrlq(struct ice_hw *hw)
-{
-	/* Shutdown FW admin queue */
-	ice_shutdown_ctrlq(hw, ICE_CTL_Q_ADMIN);
-	/* Shutdown PF-VF Mailbox */
-	ice_shutdown_ctrlq(hw, ICE_CTL_Q_MAILBOX);
-}
-
 /**
  * ice_destroy_ctrlq_locks - Destroy locks for a control queue
  * @cq: pointer to the control queue
@@ -1049,9 +1061,15 @@ ice_sq_send_cmd(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 
 	/* update the error if time out occurred */
 	if (!cmd_completed) {
-		ice_debug(hw, ICE_DBG_AQ_MSG,
-			  "Control Send Queue Writeback timeout.\n");
-		status = ICE_ERR_AQ_TIMEOUT;
+		if (rd32(hw, cq->rq.len) & cq->rq.len_crit_mask ||
+		    rd32(hw, cq->sq.len) & cq->sq.len_crit_mask) {
+			ice_debug(hw, ICE_DBG_AQ_MSG, "Critical FW error.\n");
+			status = ICE_ERR_AQ_FW_CRITICAL;
+		} else {
+			ice_debug(hw, ICE_DBG_AQ_MSG,
+				  "Control Send Queue Writeback timeout.\n");
+			status = ICE_ERR_AQ_TIMEOUT;
+		}
 	}
 
 sq_send_command_error:
diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.h b/drivers/net/ethernet/intel/ice/ice_controlq.h
index bf0ebe6149e8..faaa08e8171b 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.h
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.h
@@ -34,6 +34,8 @@ enum ice_ctl_q {
 /* Control Queue timeout settings - max delay 250ms */
 #define ICE_CTL_Q_SQ_CMD_TIMEOUT	2500  /* Count 2500 times */
 #define ICE_CTL_Q_SQ_CMD_USEC		100   /* Check every 100usec */
+#define ICE_CTL_Q_ADMIN_INIT_TIMEOUT	10    /* Count 10 times */
+#define ICE_CTL_Q_ADMIN_INIT_MSEC	100   /* Check every 100msec */
 
 struct ice_ctl_q_ring {
 	void *dma_head;			/* Virtual address to DMA head */
@@ -59,6 +61,7 @@ struct ice_ctl_q_ring {
 	u32 bal;
 	u32 len_mask;
 	u32 len_ena_mask;
+	u32 len_crit_mask;
 	u32 head_mask;
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 2f1c776747a4..1086c9f778b4 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -39,6 +39,7 @@
 #define PF_MBX_ARQH_ARQH_M			ICE_M(0x3FF, 0)
 #define PF_MBX_ARQLEN				0x0022E480
 #define PF_MBX_ARQLEN_ARQLEN_M			ICE_M(0x3FF, 0)
+#define PF_MBX_ARQLEN_ARQCRIT_M			BIT(30)
 #define PF_MBX_ARQLEN_ARQENABLE_M		BIT(31)
 #define PF_MBX_ARQT				0x0022E580
 #define PF_MBX_ATQBAH				0x0022E180
@@ -47,6 +48,7 @@
 #define PF_MBX_ATQH_ATQH_M			ICE_M(0x3FF, 0)
 #define PF_MBX_ATQLEN				0x0022E200
 #define PF_MBX_ATQLEN_ATQLEN_M			ICE_M(0x3FF, 0)
+#define PF_MBX_ATQLEN_ATQCRIT_M			BIT(30)
 #define PF_MBX_ATQLEN_ATQENABLE_M		BIT(31)
 #define PF_MBX_ATQT				0x0022E300
 #define PRTDCB_GENC				0x00083000
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 93a42ff7496b..247e7b186b3c 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5207,6 +5207,8 @@ const char *ice_stat_str(enum ice_status stat_err)
 		return "ICE_ERR_AQ_NO_WORK";
 	case ICE_ERR_AQ_EMPTY:
 		return "ICE_ERR_AQ_EMPTY";
+	case ICE_ERR_AQ_FW_CRITICAL:
+		return "ICE_ERR_AQ_FW_CRITICAL";
 	}
 
 	return "ICE_ERR_UNKNOWN";
diff --git a/drivers/net/ethernet/intel/ice/ice_status.h b/drivers/net/ethernet/intel/ice/ice_status.h
index 546a02856d09..4028c6365172 100644
--- a/drivers/net/ethernet/intel/ice/ice_status.h
+++ b/drivers/net/ethernet/intel/ice/ice_status.h
@@ -37,6 +37,7 @@ enum ice_status {
 	ICE_ERR_AQ_FULL				= -102,
 	ICE_ERR_AQ_NO_WORK			= -103,
 	ICE_ERR_AQ_EMPTY			= -104,
+	ICE_ERR_AQ_FW_CRITICAL			= -105,
 };
 
 #endif /* _ICE_STATUS_H_ */
-- 
2.26.2

