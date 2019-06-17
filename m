Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDEC3495ED
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 01:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729111AbfFQXdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 19:33:33 -0400
Received: from mga12.intel.com ([192.55.52.136]:25830 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728776AbfFQXdY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 19:33:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 16:33:24 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 17 Jun 2019 16:33:25 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jan Sokolowski <jan.sokolowski@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Jakub Pawlak <jakub.pawlak@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/11] iavf: Refactor the watchdog state machine
Date:   Mon, 17 Jun 2019 16:33:33 -0700
Message-Id: <20190617233336.18119-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617233336.18119-1-jeffrey.t.kirsher@intel.com>
References: <20190617233336.18119-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jan Sokolowski <jan.sokolowski@intel.com>

Refactor the watchdog state machine implementation.
Add the additional state __IAVF_COMM_FAILED to process
the PF communication fails. Prepare the watchdog state machine
to integrate with init state machine.

Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
Signed-off-by: Jakub Pawlak <jakub.pawlak@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h      |  1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c | 73 ++++++++++++---------
 2 files changed, 44 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 45dfb1a3bb40..9fc635d816d2 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -171,6 +171,7 @@ enum iavf_state_t {
 	__IAVF_INIT_GET_RESOURCES,	/* aq msg sent, awaiting reply */
 	__IAVF_INIT_SW,		/* got resources, setting up structs */
 	__IAVF_RESETTING,		/* in reset */
+	__IAVF_COMM_FAILED,		/* communication with PF failed */
 	/* Below here, watchdog is running */
 	__IAVF_DOWN,			/* ready, can be opened */
 	__IAVF_DOWN_PENDING,		/* descending, waiting for watchdog */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index f9c0d50810bb..b3694bd4194b 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1674,13 +1674,18 @@ static void iavf_watchdog_task(struct work_struct *work)
 	if (test_and_set_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section))
 		goto restart_watchdog;
 
-	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED) {
+	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)
+		adapter->state = __IAVF_COMM_FAILED;
+
+	switch (adapter->state) {
+	case __IAVF_COMM_FAILED:
 		reg_val = rd32(hw, IAVF_VFGEN_RSTAT) &
 			  IAVF_VFGEN_RSTAT_VFR_STATE_MASK;
 		if (reg_val == VIRTCHNL_VFR_VFACTIVE ||
 		    reg_val == VIRTCHNL_VFR_COMPLETED) {
 			/* A chance for redemption! */
-			dev_err(&adapter->pdev->dev, "Hardware came out of reset. Attemptingreinit.\n");
+			dev_err(&adapter->pdev->dev,
+				"Hardware came out of reset. Attempting reinit.\n");
 			adapter->state = __IAVF_STARTUP;
 			adapter->flags &= ~IAVF_FLAG_PF_COMMS_FAILED;
 			queue_delayed_work(iavf_wq, &adapter->init_task, 10);
@@ -1695,50 +1700,58 @@ static void iavf_watchdog_task(struct work_struct *work)
 		}
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
+		clear_bit(__IAVF_IN_CRITICAL_TASK,
+			  &adapter->crit_section);
+		queue_delayed_work(iavf_wq,
+				   &adapter->watchdog_task,
+				   msecs_to_jiffies(10));
 		goto watchdog_done;
+	case __IAVF_RESETTING:
+		clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+		queue_delayed_work(iavf_wq, &adapter->watchdog_task, HZ * 2);
+		return;
+	case __IAVF_DOWN:
+	case __IAVF_DOWN_PENDING:
+	case __IAVF_TESTING:
+	case __IAVF_RUNNING:
+		if (adapter->current_op) {
+			if (!iavf_asq_done(hw)) {
+				dev_dbg(&adapter->pdev->dev,
+					"Admin queue timeout\n");
+				iavf_send_api_ver(adapter);
+			}
+		} else {
+			if (!iavf_process_aq_command(adapter) &&
+			    adapter->state == __IAVF_RUNNING)
+				iavf_request_stats(adapter);
+		}
+		break;
+	case __IAVF_REMOVE:
+		clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+		return;
+	default:
+		goto restart_watchdog;
 	}
 
-	if (adapter->state < __IAVF_DOWN ||
-	    (adapter->flags & IAVF_FLAG_RESET_PENDING))
-		goto watchdog_done;
-
-	/* check for reset */
+		/* check for hw reset */
 	reg_val = rd32(hw, IAVF_VF_ARQLEN1) & IAVF_VF_ARQLEN1_ARQENABLE_MASK;
-	if (!(adapter->flags & IAVF_FLAG_RESET_PENDING) && !reg_val) {
+	if (!reg_val) {
 		adapter->state = __IAVF_RESETTING;
 		adapter->flags |= IAVF_FLAG_RESET_PENDING;
-		dev_err(&adapter->pdev->dev, "Hardware reset detected\n");
-		queue_work(iavf_wq, &adapter->reset_task);
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
+		dev_err(&adapter->pdev->dev, "Hardware reset detected\n");
+		queue_work(iavf_wq, &adapter->reset_task);
 		goto watchdog_done;
 	}
 
-	/* Process admin queue tasks. After init, everything gets done
-	 * here so we don't race on the admin queue.
-	 * The check is made against -EAGAIN, as it's the error code that
-	 * would be returned on no op to run. Failures of called functions
-	 * return other values.
-	 */
-	if (adapter->current_op) {
-		if (!iavf_asq_done(hw)) {
-			dev_dbg(&adapter->pdev->dev, "Admin queue timeout\n");
-			iavf_send_api_ver(adapter);
-		}
-	} else if (iavf_process_aq_command(adapter) == -EAGAIN &&
-		   adapter->state == __IAVF_RUNNING) {
-		iavf_request_stats(adapter);
-	}
-
 	schedule_delayed_work(&adapter->client_task, msecs_to_jiffies(5));
-
 watchdog_done:
-	if (adapter->state == __IAVF_RUNNING)
+	if (adapter->state == __IAVF_RUNNING ||
+	    adapter->state == __IAVF_COMM_FAILED)
 		iavf_detect_recover_hung(&adapter->vsi);
 	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
 restart_watchdog:
-	if (adapter->state == __IAVF_REMOVE)
-		return;
 	if (adapter->aq_required)
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(20));
-- 
2.21.0

