Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21C8B7CEE1
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbfGaUlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:41:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:2709 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728724AbfGaUlu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 16:41:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jul 2019 13:41:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,331,1559545200"; 
   d="scan'208";a="323901016"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 31 Jul 2019 13:41:48 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/16] ice: separate out control queue lock creation
Date:   Wed, 31 Jul 2019 13:41:36 -0700
Message-Id: <20190731204147.8582-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
References: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_init_all_ctrlq and ice_shutdown_all_ctrlq functions create and
destroy the locks used to protect the send and receive process of each
control queue.

This is problematic, as the driver may use these functions to shutdown
and re-initialize the control queues at run time. For example, it may do
this in response to a device reset.

If the driver failed to recover from a reset, it might leave the control
queues offline. In this case, the locks will no longer be initialized.
A later call to ice_sq_send_cmd will then attempt to acquire a lock that
has been destroyed.

It is incorrect behavior to access a lock that has been destroyed.

Indeed, ice_aq_send_cmd already tries to avoid accessing an offline
control queue, but the check occurs inside the lock.

The root of the problem is that the locks are destroyed at run time.

Modify ice_init_all_ctrlq and ice_shutdown_all_ctrlq such that they no
longer create or destroy the locks.

Introduce new functions, ice_create_all_ctrlq and ice_destroy_all_ctrlq.
Call these functions in ice_init_hw and ice_deinit_hw.

Now, the control queue locks will remain valid for the life of the
driver, and will not be destroyed until the driver unloads.

This also allows removing a duplicate check of the sq.count and
rq.count values when shutting down the controlqs. The ice_shutdown_ctrlq
function already checks this value under the lock. Previously
commit dec64ff10ed9 ("ice: use [sr]q.count when checking if queue is
initialized") needed this check to happen outside the lock, because it
prevented duplicate attempts at destroying the locks.

The driver may now safely use ice_init_all_ctrlq and
ice_shutdown_all_ctrlq while handling reset events, without causing the
locks to be invalid.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c   |   6 +-
 drivers/net/ethernet/intel/ice/ice_common.h   |   2 +
 drivers/net/ethernet/intel/ice/ice_controlq.c | 112 ++++++++++++++----
 3 files changed, 91 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 01e5ecaaa322..5f9dc76699d2 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -740,7 +740,7 @@ enum ice_status ice_init_hw(struct ice_hw *hw)
 
 	ice_get_itr_intrl_gran(hw);
 
-	status = ice_init_all_ctrlq(hw);
+	status = ice_create_all_ctrlq(hw);
 	if (status)
 		goto err_unroll_cqinit;
 
@@ -855,7 +855,7 @@ enum ice_status ice_init_hw(struct ice_hw *hw)
 err_unroll_alloc:
 	devm_kfree(ice_hw_to_dev(hw), hw->port_info);
 err_unroll_cqinit:
-	ice_shutdown_all_ctrlq(hw);
+	ice_destroy_all_ctrlq(hw);
 	return status;
 }
 
@@ -881,7 +881,7 @@ void ice_deinit_hw(struct ice_hw *hw)
 
 	/* Attempt to disable FW logging before shutting down control queues */
 	ice_cfg_fw_log(hw, false);
-	ice_shutdown_all_ctrlq(hw);
+	ice_destroy_all_ctrlq(hw);
 
 	/* Clear VSI contexts if not already cleared */
 	ice_clear_all_vsi_ctx(hw);
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 68218e63afc2..e376d1eadba4 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -17,8 +17,10 @@ enum ice_status ice_init_hw(struct ice_hw *hw);
 void ice_deinit_hw(struct ice_hw *hw);
 enum ice_status ice_check_reset(struct ice_hw *hw);
 enum ice_status ice_reset(struct ice_hw *hw, enum ice_reset_req req);
+enum ice_status ice_create_all_ctrlq(struct ice_hw *hw);
 enum ice_status ice_init_all_ctrlq(struct ice_hw *hw);
 void ice_shutdown_all_ctrlq(struct ice_hw *hw);
+void ice_destroy_all_ctrlq(struct ice_hw *hw);
 enum ice_status
 ice_clean_rq_elem(struct ice_hw *hw, struct ice_ctl_q_info *cq,
 		  struct ice_rq_event_info *e, u16 *pending);
diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
index e91ac4df0242..2353166c654e 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
@@ -310,7 +310,7 @@ ice_cfg_rq_regs(struct ice_hw *hw, struct ice_ctl_q_info *cq)
  * @cq: pointer to the specific Control queue
  *
  * This is the main initialization routine for the Control Send Queue
- * Prior to calling this function, drivers *MUST* set the following fields
+ * Prior to calling this function, the driver *MUST* set the following fields
  * in the cq->structure:
  *     - cq->num_sq_entries
  *     - cq->sq_buf_size
@@ -369,7 +369,7 @@ static enum ice_status ice_init_sq(struct ice_hw *hw, struct ice_ctl_q_info *cq)
  * @cq: pointer to the specific Control queue
  *
  * The main initialization routine for the Admin Receive (Event) Queue.
- * Prior to calling this function, drivers *MUST* set the following fields
+ * Prior to calling this function, the driver *MUST* set the following fields
  * in the cq->structure:
  *     - cq->num_rq_entries
  *     - cq->rq_buf_size
@@ -569,14 +569,8 @@ static enum ice_status ice_init_check_adminq(struct ice_hw *hw)
 	return 0;
 
 init_ctrlq_free_rq:
-	if (cq->rq.count) {
-		ice_shutdown_rq(hw, cq);
-		mutex_destroy(&cq->rq_lock);
-	}
-	if (cq->sq.count) {
-		ice_shutdown_sq(hw, cq);
-		mutex_destroy(&cq->sq_lock);
-	}
+	ice_shutdown_rq(hw, cq);
+	ice_shutdown_sq(hw, cq);
 	return status;
 }
 
@@ -585,12 +579,14 @@ static enum ice_status ice_init_check_adminq(struct ice_hw *hw)
  * @hw: pointer to the hardware structure
  * @q_type: specific Control queue type
  *
- * Prior to calling this function, drivers *MUST* set the following fields
+ * Prior to calling this function, the driver *MUST* set the following fields
  * in the cq->structure:
  *     - cq->num_sq_entries
  *     - cq->num_rq_entries
  *     - cq->rq_buf_size
  *     - cq->sq_buf_size
+ *
+ * NOTE: this function does not initialize the controlq locks
  */
 static enum ice_status ice_init_ctrlq(struct ice_hw *hw, enum ice_ctl_q q_type)
 {
@@ -616,8 +612,6 @@ static enum ice_status ice_init_ctrlq(struct ice_hw *hw, enum ice_ctl_q q_type)
 	    !cq->rq_buf_size || !cq->sq_buf_size) {
 		return ICE_ERR_CFG;
 	}
-	mutex_init(&cq->sq_lock);
-	mutex_init(&cq->rq_lock);
 
 	/* setup SQ command write back timeout */
 	cq->sq_cmd_timeout = ICE_CTL_Q_SQ_CMD_TIMEOUT;
@@ -625,7 +619,7 @@ static enum ice_status ice_init_ctrlq(struct ice_hw *hw, enum ice_ctl_q q_type)
 	/* allocate the ATQ */
 	ret_code = ice_init_sq(hw, cq);
 	if (ret_code)
-		goto init_ctrlq_destroy_locks;
+		return ret_code;
 
 	/* allocate the ARQ */
 	ret_code = ice_init_rq(hw, cq);
@@ -637,9 +631,6 @@ static enum ice_status ice_init_ctrlq(struct ice_hw *hw, enum ice_ctl_q q_type)
 
 init_ctrlq_free_sq:
 	ice_shutdown_sq(hw, cq);
-init_ctrlq_destroy_locks:
-	mutex_destroy(&cq->sq_lock);
-	mutex_destroy(&cq->rq_lock);
 	return ret_code;
 }
 
@@ -647,12 +638,14 @@ static enum ice_status ice_init_ctrlq(struct ice_hw *hw, enum ice_ctl_q q_type)
  * ice_init_all_ctrlq - main initialization routine for all control queues
  * @hw: pointer to the hardware structure
  *
- * Prior to calling this function, drivers *MUST* set the following fields
+ * Prior to calling this function, the driver MUST* set the following fields
  * in the cq->structure for all control queues:
  *     - cq->num_sq_entries
  *     - cq->num_rq_entries
  *     - cq->rq_buf_size
  *     - cq->sq_buf_size
+ *
+ * NOTE: this function does not initialize the controlq locks.
  */
 enum ice_status ice_init_all_ctrlq(struct ice_hw *hw)
 {
@@ -671,10 +664,48 @@ enum ice_status ice_init_all_ctrlq(struct ice_hw *hw)
 	return ice_init_ctrlq(hw, ICE_CTL_Q_MAILBOX);
 }
 
+/**
+ * ice_init_ctrlq_locks - Initialize locks for a control queue
+ * @cq: pointer to the control queue
+ *
+ * Initializes the send and receive queue locks for a given control queue.
+ */
+static void ice_init_ctrlq_locks(struct ice_ctl_q_info *cq)
+{
+	mutex_init(&cq->sq_lock);
+	mutex_init(&cq->rq_lock);
+}
+
+/**
+ * ice_create_all_ctrlq - main initialization routine for all control queues
+ * @hw: pointer to the hardware structure
+ *
+ * Prior to calling this function, the driver *MUST* set the following fields
+ * in the cq->structure for all control queues:
+ *     - cq->num_sq_entries
+ *     - cq->num_rq_entries
+ *     - cq->rq_buf_size
+ *     - cq->sq_buf_size
+ *
+ * This function creates all the control queue locks and then calls
+ * ice_init_all_ctrlq. It should be called once during driver load. If the
+ * driver needs to re-initialize control queues at run time it should call
+ * ice_init_all_ctrlq instead.
+ */
+enum ice_status ice_create_all_ctrlq(struct ice_hw *hw)
+{
+	ice_init_ctrlq_locks(&hw->adminq);
+	ice_init_ctrlq_locks(&hw->mailboxq);
+
+	return ice_init_all_ctrlq(hw);
+}
+
 /**
  * ice_shutdown_ctrlq - shutdown routine for any control queue
  * @hw: pointer to the hardware structure
  * @q_type: specific Control queue type
+ *
+ * NOTE: this function does not destroy the control queue locks.
  */
 static void ice_shutdown_ctrlq(struct ice_hw *hw, enum ice_ctl_q q_type)
 {
@@ -693,19 +724,17 @@ static void ice_shutdown_ctrlq(struct ice_hw *hw, enum ice_ctl_q q_type)
 		return;
 	}
 
-	if (cq->sq.count) {
-		ice_shutdown_sq(hw, cq);
-		mutex_destroy(&cq->sq_lock);
-	}
-	if (cq->rq.count) {
-		ice_shutdown_rq(hw, cq);
-		mutex_destroy(&cq->rq_lock);
-	}
+	ice_shutdown_sq(hw, cq);
+	ice_shutdown_rq(hw, cq);
 }
 
 /**
  * ice_shutdown_all_ctrlq - shutdown routine for all control queues
  * @hw: pointer to the hardware structure
+ *
+ * NOTE: this function does not destroy the control queue locks. The driver
+ * may call this at runtime to shutdown and later restart control queues, such
+ * as in response to a reset event.
  */
 void ice_shutdown_all_ctrlq(struct ice_hw *hw)
 {
@@ -715,6 +744,37 @@ void ice_shutdown_all_ctrlq(struct ice_hw *hw)
 	ice_shutdown_ctrlq(hw, ICE_CTL_Q_MAILBOX);
 }
 
+/**
+ * ice_destroy_ctrlq_locks - Destroy locks for a control queue
+ * @cq: pointer to the control queue
+ *
+ * Destroys the send and receive queue locks for a given control queue.
+ */
+static void
+ice_destroy_ctrlq_locks(struct ice_ctl_q_info *cq)
+{
+	mutex_destroy(&cq->sq_lock);
+	mutex_destroy(&cq->rq_lock);
+}
+
+/**
+ * ice_destroy_all_ctrlq - exit routine for all control queues
+ * @hw: pointer to the hardware structure
+ *
+ * This function shuts down all the control queues and then destroys the
+ * control queue locks. It should be called once during driver unload. The
+ * driver should call ice_shutdown_all_ctrlq if it needs to shut down and
+ * reinitialize control queues, such as in response to a reset event.
+ */
+void ice_destroy_all_ctrlq(struct ice_hw *hw)
+{
+	/* shut down all the control queues first */
+	ice_shutdown_all_ctrlq(hw);
+
+	ice_destroy_ctrlq_locks(&hw->adminq);
+	ice_destroy_ctrlq_locks(&hw->mailboxq);
+}
+
 /**
  * ice_clean_sq - cleans Admin send queue (ATQ)
  * @hw: pointer to the hardware structure
-- 
2.21.0

