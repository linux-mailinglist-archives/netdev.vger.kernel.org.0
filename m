Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3327F4C4F13
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 20:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbiBYTqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 14:46:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235370AbiBYTqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 14:46:47 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01369210468
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 11:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645818374; x=1677354374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7mhCvE9NOJ5X0APUPK6aZ7NwjRvopqMut3qqVYTiPzs=;
  b=Gsn+lRZJZvLl8Cg+7/O1cDFshoJM3AxUzdZqF6/uBaxwFv5aHbve0RMX
   6gujVBiyhiW7FwiYjQhBSWm7N2lq7eeO9oITmdO13KU6FEoTn3WfHVAxO
   2X6ynH2Z3IhN+g/dnTlb0qvHVqB3EY5TWDr+fGvOOwZ4jIZNsj14U/TnY
   y6G/OSj1vKEcSpaZKQPTDgwqtp8tl94ziXhapO64ChsMOoOTJMCpWLYe9
   8kdfJy6j8MRfel9yz7+VrTXk7UAqqCRW/9CyPIFnrzU3O+HyEy25o0cJL
   KsLk2tVMFxWROzY45rK27Az+BsfenYSl9U4mRGiAPYzWNrsgkB/yp1Nql
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="339004860"
X-IronPort-AV: E=Sophos;i="5.90,137,1643702400"; 
   d="scan'208";a="339004860"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 11:46:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,137,1643702400"; 
   d="scan'208";a="707972176"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 25 Feb 2022 11:46:11 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Slawomir Laba <slawomirx.laba@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Phani Burra <phani.r.burra@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 3/8] iavf: Fix init state closure on remove
Date:   Fri, 25 Feb 2022 11:46:09 -0800
Message-Id: <20220225194614.136571-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220225194614.136571-1-anthony.l.nguyen@intel.com>
References: <20220225194614.136571-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Slawomir Laba <slawomirx.laba@intel.com>

When init states of the adapter work, the errors like lack
of communication with the PF might hop in. If such events
occur the driver restores previous states in order to retry
initialization in a proper way. When remove task kicks in,
this situation could lead to races with unregistering the
netdevice as well as resources cleanup. With the commit
introducing the waiting in remove for init to complete,
this problem turns into an endless waiting if init never
recovers from errors.

Introduce __IAVF_IN_REMOVE_TASK bit to indicate that the
remove thread has started.

Make __IAVF_COMM_FAILED adapter state respect the
__IAVF_IN_REMOVE_TASK bit and set the __IAVF_INIT_FAILED
state and return without any action instead of trying to
recover.

Make __IAVF_INIT_FAILED adapter state respect the
__IAVF_IN_REMOVE_TASK bit and return without any further
actions.

Make the loop in the remove handler break when adapter has
__IAVF_INIT_FAILED state set.

Fixes: 898ef1cb1cb2 ("iavf: Combine init and watchdog state machines")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h      |  4 ++++
 drivers/net/ethernet/intel/iavf/iavf_main.c | 24 ++++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 44f83e06486d..f259fd517b2c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -201,6 +201,10 @@ enum iavf_state_t {
 	__IAVF_RUNNING,		/* opened, working */
 };
 
+enum iavf_critical_section_t {
+	__IAVF_IN_REMOVE_TASK,	/* device being removed */
+};
+
 #define IAVF_CLOUD_FIELD_OMAC		0x01
 #define IAVF_CLOUD_FIELD_IMAC		0x02
 #define IAVF_CLOUD_FIELD_IVLAN	0x04
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 5e71b38e9154..be51da978e7c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2424,6 +2424,15 @@ static void iavf_watchdog_task(struct work_struct *work)
 				   msecs_to_jiffies(1));
 		return;
 	case __IAVF_INIT_FAILED:
+		if (test_bit(__IAVF_IN_REMOVE_TASK,
+			     &adapter->crit_section)) {
+			/* Do not update the state and do not reschedule
+			 * watchdog task, iavf_remove should handle this state
+			 * as it can loop forever
+			 */
+			mutex_unlock(&adapter->crit_lock);
+			return;
+		}
 		if (++adapter->aq_wait_count > IAVF_AQ_MAX_ERR) {
 			dev_err(&adapter->pdev->dev,
 				"Failed to communicate with PF; waiting before retry\n");
@@ -2440,6 +2449,17 @@ static void iavf_watchdog_task(struct work_struct *work)
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task, HZ);
 		return;
 	case __IAVF_COMM_FAILED:
+		if (test_bit(__IAVF_IN_REMOVE_TASK,
+			     &adapter->crit_section)) {
+			/* Set state to __IAVF_INIT_FAILED and perform remove
+			 * steps. Remove IAVF_FLAG_PF_COMMS_FAILED so the task
+			 * doesn't bring the state back to __IAVF_COMM_FAILED.
+			 */
+			iavf_change_state(adapter, __IAVF_INIT_FAILED);
+			adapter->flags &= ~IAVF_FLAG_PF_COMMS_FAILED;
+			mutex_unlock(&adapter->crit_lock);
+			return;
+		}
 		reg_val = rd32(hw, IAVF_VFGEN_RSTAT) &
 			  IAVF_VFGEN_RSTAT_VFR_STATE_MASK;
 		if (reg_val == VIRTCHNL_VFR_VFACTIVE ||
@@ -4567,13 +4587,15 @@ static void iavf_remove(struct pci_dev *pdev)
 	struct iavf_hw *hw = &adapter->hw;
 	int err;
 
+	set_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section);
 	/* Wait until port initialization is complete.
 	 * There are flows where register/unregister netdev may race.
 	 */
 	while (1) {
 		mutex_lock(&adapter->crit_lock);
 		if (adapter->state == __IAVF_RUNNING ||
-		    adapter->state == __IAVF_DOWN) {
+		    adapter->state == __IAVF_DOWN ||
+		    adapter->state == __IAVF_INIT_FAILED) {
 			mutex_unlock(&adapter->crit_lock);
 			break;
 		}
-- 
2.31.1

