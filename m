Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3EE33D152
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 11:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbhCPKCg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Mar 2021 06:02:36 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:49785 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235852AbhCPKCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 06:02:01 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-R1DbDuoePriB3rwkJ-2bww-1; Tue, 16 Mar 2021 06:01:55 -0400
X-MC-Unique: R1DbDuoePriB3rwkJ-2bww-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFB36107ACCD;
        Tue, 16 Mar 2021 10:01:53 +0000 (UTC)
Received: from p50.redhat.com (ovpn-112-37.ams2.redhat.com [10.36.112.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14E736C32E;
        Tue, 16 Mar 2021 10:01:51 +0000 (UTC)
From:   Stefan Assmann <sassmann@kpanic.de>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        lihong.yang@intel.com, jesse.brandeburg@intel.com,
        slawomirx.laba@intel.com, nicholas.d.nunley@intel.com,
        sassmann@kpanic.de
Subject: [PATCH] iavf: fix locking of critical sections
Date:   Tue, 16 Mar 2021 11:01:41 +0100
Message-Id: <20210316100141.53551-1-sassmann@kpanic.de>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sassmann@kpanic.de
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kpanic.de
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To avoid races between iavf_init_task(), iavf_reset_task(),
iavf_watchdog_task(), iavf_adminq_task() as well as the shutdown and
remove functions more locking is required.
The current protection by __IAVF_IN_CRITICAL_TASK is needed in
additional places.

- The reset task performs state transitions, therefore needs locking.
- The adminq task acts on replies from the PF in
  iavf_virtchnl_completion() which may alter the states.
- The init task is not only run during probe but also if a VF gets stuck
  to reinitialize it.
- The shutdown function performs a state transition.
- The remove function perorms a state transition and also free's
  resources.

iavf_lock_timeout() is introduced to avoid waiting infinitely
and cause a deadlock. Rather unlock and print a warning.

Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 57 ++++++++++++++++++---
 1 file changed, 50 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index dc5b3c06d1e0..538b7aa43fa5 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -131,6 +131,30 @@ enum iavf_status iavf_free_virt_mem_d(struct iavf_hw *hw,
 	return 0;
 }
 
+/**
+ * iavf_timeout - try to set bit but give up after timeout
+ * @adapter: board private structure
+ * @bit: bit to set
+ * @msecs: timeout in msecs
+ *
+ * Returns 0 on success, negative on failure
+ **/
+static inline int iavf_lock_timeout(struct iavf_adapter *adapter,
+				    enum iavf_critical_section_t bit,
+				    unsigned int msecs)
+{
+	unsigned int wait, delay = 10;
+
+	for (wait = 0; wait < msecs; wait += delay) {
+		if (!test_and_set_bit(bit, &adapter->crit_section))
+			return 0;
+
+		msleep(delay);
+	}
+
+	return -1;
+}
+
 /**
  * iavf_schedule_reset - Set the flags and schedule a reset event
  * @adapter: board private structure
@@ -2069,6 +2093,10 @@ static void iavf_reset_task(struct work_struct *work)
 	if (test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
 		return;
 
+	if (iavf_lock_timeout(adapter, __IAVF_IN_CRITICAL_TASK, 200)) {
+		schedule_work(&adapter->reset_task);
+		return;
+	}
 	while (test_and_set_bit(__IAVF_IN_CLIENT_TASK,
 				&adapter->crit_section))
 		usleep_range(500, 1000);
@@ -2275,6 +2303,8 @@ static void iavf_adminq_task(struct work_struct *work)
 	if (!event.msg_buf)
 		goto out;
 
+	if (iavf_lock_timeout(adapter, __IAVF_IN_CRITICAL_TASK, 200))
+		goto freedom;
 	do {
 		ret = iavf_clean_arq_element(hw, &event, &pending);
 		v_op = (enum virtchnl_ops)le32_to_cpu(event.desc.cookie_high);
@@ -2288,6 +2318,7 @@ static void iavf_adminq_task(struct work_struct *work)
 		if (pending != 0)
 			memset(event.msg_buf, 0, IAVF_MAX_AQ_BUF_SIZE);
 	} while (pending);
+	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
 
 	if ((adapter->flags &
 	     (IAVF_FLAG_RESET_PENDING | IAVF_FLAG_RESET_NEEDED)) ||
@@ -3590,6 +3621,10 @@ static void iavf_init_task(struct work_struct *work)
 						    init_task.work);
 	struct iavf_hw *hw = &adapter->hw;
 
+	if (iavf_lock_timeout(adapter, __IAVF_IN_CRITICAL_TASK, 5000)) {
+		dev_warn(&adapter->pdev->dev, "failed to set __IAVF_IN_CRITICAL_TASK in %s\n", __FUNCTION__);
+		return;
+	}
 	switch (adapter->state) {
 	case __IAVF_STARTUP:
 		if (iavf_startup(adapter) < 0)
@@ -3602,14 +3637,14 @@ static void iavf_init_task(struct work_struct *work)
 	case __IAVF_INIT_GET_RESOURCES:
 		if (iavf_init_get_resources(adapter) < 0)
 			goto init_failed;
-		return;
+		goto out;
 	default:
 		goto init_failed;
 	}
 
 	queue_delayed_work(iavf_wq, &adapter->init_task,
 			   msecs_to_jiffies(30));
-	return;
+	goto out;
 init_failed:
 	if (++adapter->aq_wait_count > IAVF_AQ_MAX_ERR) {
 		dev_err(&adapter->pdev->dev,
@@ -3618,9 +3653,11 @@ static void iavf_init_task(struct work_struct *work)
 		iavf_shutdown_adminq(hw);
 		adapter->state = __IAVF_STARTUP;
 		queue_delayed_work(iavf_wq, &adapter->init_task, HZ * 5);
-		return;
+		goto out;
 	}
 	queue_delayed_work(iavf_wq, &adapter->init_task, HZ);
+out:
+	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
 }
 
 /**
@@ -3637,9 +3674,12 @@ static void iavf_shutdown(struct pci_dev *pdev)
 	if (netif_running(netdev))
 		iavf_close(netdev);
 
+	if (iavf_lock_timeout(adapter, __IAVF_IN_CRITICAL_TASK, 5000))
+		dev_warn(&adapter->pdev->dev, "failed to set __IAVF_IN_CRITICAL_TASK in %s\n", __FUNCTION__);
 	/* Prevent the watchdog from running. */
 	adapter->state = __IAVF_REMOVE;
 	adapter->aq_required = 0;
+	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
 
 #ifdef CONFIG_PM
 	pci_save_state(pdev);
@@ -3866,10 +3906,6 @@ static void iavf_remove(struct pci_dev *pdev)
 				 err);
 	}
 
-	/* Shut down all the garbage mashers on the detention level */
-	adapter->state = __IAVF_REMOVE;
-	adapter->aq_required = 0;
-	adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
 	iavf_request_reset(adapter);
 	msleep(50);
 	/* If the FW isn't responding, kick it once, but only once. */
@@ -3877,6 +3913,13 @@ static void iavf_remove(struct pci_dev *pdev)
 		iavf_request_reset(adapter);
 		msleep(50);
 	}
+	if (iavf_lock_timeout(adapter, __IAVF_IN_CRITICAL_TASK, 5000))
+		dev_warn(&adapter->pdev->dev, "failed to set __IAVF_IN_CRITICAL_TASK in %s\n", __FUNCTION__);
+
+	/* Shut down all the garbage mashers on the detention level */
+	adapter->state = __IAVF_REMOVE;
+	adapter->aq_required = 0;
+	adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
 	iavf_free_all_tx_resources(adapter);
 	iavf_free_all_rx_resources(adapter);
 	iavf_misc_irq_disable(adapter);
-- 
2.29.2

