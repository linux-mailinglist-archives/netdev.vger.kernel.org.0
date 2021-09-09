Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45004049C9
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbhIILnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:43:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236729AbhIILmu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:42:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 249276103D;
        Thu,  9 Sep 2021 11:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187701;
        bh=+oD3Z40EPoxc+Zp2fbcCpgeZeVQzVYMYQ5lI2GkuKSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SicdkUKx1td5oCcfOiJtjFlia4ruoBBQkz9tTXYRtYOWKLYEdMxJ+1WOASH3YNCXq
         J/NtjhEgsdfgepUjp06TZE+6fFyeYw+QyJqJNpgcg3hpfzBS/Plq4pSHlFwKw+SY49
         B7bUW+ar8OhbszvFqSVaIeKvGShY0hR/Y9lRHM3NZH/oIgOsP4M7ifAjhmENXhSkJz
         QpKzKmywSg+Jzw0/fyFNZbCo6GDZDFbLHEoWNgWE8mT2JKfr0rDOa/DEx+CuTtsUcy
         eUliezH1iG1CBYAUQqqmGUKTcfvM4ytkVYOof995Q+ExcfFib4Pc5IkE1DhiMA04+z
         jA2tUymiF3yDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Assmann <sassmann@kpanic.de>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 026/252] iavf: fix locking of critical sections
Date:   Thu,  9 Sep 2021 07:37:20 -0400
Message-Id: <20210909114106.141462-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

[ Upstream commit 226d528512cfac890a1619aea4301f3dd314fe60 ]

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
- The remove function performs a state transition and also free's
  resources.

iavf_lock_timeout() is introduced to avoid waiting infinitely
and cause a deadlock. Rather unlock and print a warning.

Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 57 ++++++++++++++++++---
 1 file changed, 50 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 0d0f16617dde..e5e6a5b11e6d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -131,6 +131,30 @@ enum iavf_status iavf_free_virt_mem_d(struct iavf_hw *hw,
 	return 0;
 }
 
+/**
+ * iavf_lock_timeout - try to set bit but give up after timeout
+ * @adapter: board private structure
+ * @bit: bit to set
+ * @msecs: timeout in msecs
+ *
+ * Returns 0 on success, negative on failure
+ **/
+static int iavf_lock_timeout(struct iavf_adapter *adapter,
+			     enum iavf_critical_section_t bit,
+			     unsigned int msecs)
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
@@ -2097,6 +2121,10 @@ static void iavf_reset_task(struct work_struct *work)
 	if (test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
 		return;
 
+	if (iavf_lock_timeout(adapter, __IAVF_IN_CRITICAL_TASK, 200)) {
+		schedule_work(&adapter->reset_task);
+		return;
+	}
 	while (test_and_set_bit(__IAVF_IN_CLIENT_TASK,
 				&adapter->crit_section))
 		usleep_range(500, 1000);
@@ -2311,6 +2339,8 @@ static void iavf_adminq_task(struct work_struct *work)
 	if (!event.msg_buf)
 		goto out;
 
+	if (iavf_lock_timeout(adapter, __IAVF_IN_CRITICAL_TASK, 200))
+		goto freedom;
 	do {
 		ret = iavf_clean_arq_element(hw, &event, &pending);
 		v_op = (enum virtchnl_ops)le32_to_cpu(event.desc.cookie_high);
@@ -2324,6 +2354,7 @@ static void iavf_adminq_task(struct work_struct *work)
 		if (pending != 0)
 			memset(event.msg_buf, 0, IAVF_MAX_AQ_BUF_SIZE);
 	} while (pending);
+	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
 
 	if ((adapter->flags &
 	     (IAVF_FLAG_RESET_PENDING | IAVF_FLAG_RESET_NEEDED)) ||
@@ -3628,6 +3659,10 @@ static void iavf_init_task(struct work_struct *work)
 						    init_task.work);
 	struct iavf_hw *hw = &adapter->hw;
 
+	if (iavf_lock_timeout(adapter, __IAVF_IN_CRITICAL_TASK, 5000)) {
+		dev_warn(&adapter->pdev->dev, "failed to set __IAVF_IN_CRITICAL_TASK in %s\n", __FUNCTION__);
+		return;
+	}
 	switch (adapter->state) {
 	case __IAVF_STARTUP:
 		if (iavf_startup(adapter) < 0)
@@ -3640,14 +3675,14 @@ static void iavf_init_task(struct work_struct *work)
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
@@ -3656,9 +3691,11 @@ static void iavf_init_task(struct work_struct *work)
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
@@ -3675,9 +3712,12 @@ static void iavf_shutdown(struct pci_dev *pdev)
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
@@ -3911,10 +3951,6 @@ static void iavf_remove(struct pci_dev *pdev)
 				 err);
 	}
 
-	/* Shut down all the garbage mashers on the detention level */
-	adapter->state = __IAVF_REMOVE;
-	adapter->aq_required = 0;
-	adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
 	iavf_request_reset(adapter);
 	msleep(50);
 	/* If the FW isn't responding, kick it once, but only once. */
@@ -3922,6 +3958,13 @@ static void iavf_remove(struct pci_dev *pdev)
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
2.30.2

