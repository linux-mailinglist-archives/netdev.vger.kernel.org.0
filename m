Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE09C3EF41D
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 22:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbhHQUdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 16:33:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:49427 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234360AbhHQUd0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 16:33:26 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10079"; a="216186352"
X-IronPort-AV: E=Sophos;i="5.84,329,1620716400"; 
   d="scan'208";a="216186352"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 13:32:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,329,1620716400"; 
   d="scan'208";a="488169519"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 17 Aug 2021 13:32:23 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Stefan Assmann <sassmann@kpanic.de>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: [PATCH net-next 1/2] iavf: use mutexes for locking of critical sections
Date:   Tue, 17 Aug 2021 13:35:48 -0700
Message-Id: <20210817203549.3529860-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210817203549.3529860-1-anthony.l.nguyen@intel.com>
References: <20210817203549.3529860-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

As follow-up to the discussion with Jakub Kicinski about iavf locking
being insufficient [1] convert iavf to use mutexes instead of bitops.
The locking logic is kept as is, just a drop-in replacement of
enum iavf_critical_section_t with separate mutexes.
The only difference is that the mutexes will be destroyed before the
module is unloaded.

[1] https://lwn.net/ml/netdev/20210316150210.00007249%40intel.com/

Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h        |   9 +-
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |  10 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 100 +++++++++---------
 3 files changed, 56 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index e8bd04100ecd..b351ad653d12 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -185,12 +185,6 @@ enum iavf_state_t {
 	__IAVF_RUNNING,		/* opened, working */
 };
 
-enum iavf_critical_section_t {
-	__IAVF_IN_CRITICAL_TASK,	/* cannot be interrupted */
-	__IAVF_IN_CLIENT_TASK,
-	__IAVF_IN_REMOVE_TASK,	/* device being removed */
-};
-
 #define IAVF_CLOUD_FIELD_OMAC		0x01
 #define IAVF_CLOUD_FIELD_IMAC		0x02
 #define IAVF_CLOUD_FIELD_IVLAN	0x04
@@ -235,6 +229,9 @@ struct iavf_adapter {
 	struct iavf_q_vector *q_vectors;
 	struct list_head vlan_filter_list;
 	struct list_head mac_filter_list;
+	struct mutex crit_lock;
+	struct mutex client_lock;
+	struct mutex remove_lock;
 	/* Lock to protect accesses to MAC and VLAN lists */
 	spinlock_t mac_vlan_list_lock;
 	char misc_vector_name[IFNAMSIZ + 9];
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index af43fbd8cb75..edbeb27213f8 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -1352,8 +1352,7 @@ static int iavf_add_fdir_ethtool(struct iavf_adapter *adapter, struct ethtool_rx
 	if (!fltr)
 		return -ENOMEM;
 
-	while (test_and_set_bit(__IAVF_IN_CRITICAL_TASK,
-				&adapter->crit_section)) {
+	while (!mutex_trylock(&adapter->crit_lock)) {
 		if (--count == 0) {
 			kfree(fltr);
 			return -EINVAL;
@@ -1378,7 +1377,7 @@ static int iavf_add_fdir_ethtool(struct iavf_adapter *adapter, struct ethtool_rx
 	if (err && fltr)
 		kfree(fltr);
 
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 	return err;
 }
 
@@ -1563,8 +1562,7 @@ iavf_set_adv_rss_hash_opt(struct iavf_adapter *adapter,
 		return -EINVAL;
 	}
 
-	while (test_and_set_bit(__IAVF_IN_CRITICAL_TASK,
-				&adapter->crit_section)) {
+	while (!mutex_trylock(&adapter->crit_lock)) {
 		if (--count == 0) {
 			kfree(rss_new);
 			return -EINVAL;
@@ -1600,7 +1598,7 @@ iavf_set_adv_rss_hash_opt(struct iavf_adapter *adapter,
 	if (!err)
 		mod_delayed_work(iavf_wq, &adapter->watchdog_task, 0);
 
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 
 	if (!rss_new_add)
 		kfree(rss_new);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index eadde6dc1a2f..197789167a49 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -132,21 +132,18 @@ enum iavf_status iavf_free_virt_mem_d(struct iavf_hw *hw,
 }
 
 /**
- * iavf_lock_timeout - try to set bit but give up after timeout
- * @adapter: board private structure
- * @bit: bit to set
+ * iavf_lock_timeout - try to lock mutex but give up after timeout
+ * @lock: mutex that should be locked
  * @msecs: timeout in msecs
  *
  * Returns 0 on success, negative on failure
  **/
-static int iavf_lock_timeout(struct iavf_adapter *adapter,
-			     enum iavf_critical_section_t bit,
-			     unsigned int msecs)
+static int iavf_lock_timeout(struct mutex *lock, unsigned int msecs)
 {
 	unsigned int wait, delay = 10;
 
 	for (wait = 0; wait < msecs; wait += delay) {
-		if (!test_and_set_bit(bit, &adapter->crit_section))
+		if (mutex_trylock(lock))
 			return 0;
 
 		msleep(delay);
@@ -1939,7 +1936,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 	struct iavf_hw *hw = &adapter->hw;
 	u32 reg_val;
 
-	if (test_and_set_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section))
+	if (!mutex_trylock(&adapter->crit_lock))
 		goto restart_watchdog;
 
 	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)
@@ -1957,8 +1954,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 			adapter->state = __IAVF_STARTUP;
 			adapter->flags &= ~IAVF_FLAG_PF_COMMS_FAILED;
 			queue_delayed_work(iavf_wq, &adapter->init_task, 10);
-			clear_bit(__IAVF_IN_CRITICAL_TASK,
-				  &adapter->crit_section);
+			mutex_unlock(&adapter->crit_lock);
 			/* Don't reschedule the watchdog, since we've restarted
 			 * the init task. When init_task contacts the PF and
 			 * gets everything set up again, it'll restart the
@@ -1968,14 +1964,13 @@ static void iavf_watchdog_task(struct work_struct *work)
 		}
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
-		clear_bit(__IAVF_IN_CRITICAL_TASK,
-			  &adapter->crit_section);
+		mutex_unlock(&adapter->crit_lock);
 		queue_delayed_work(iavf_wq,
 				   &adapter->watchdog_task,
 				   msecs_to_jiffies(10));
 		goto watchdog_done;
 	case __IAVF_RESETTING:
-		clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+		mutex_unlock(&adapter->crit_lock);
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task, HZ * 2);
 		return;
 	case __IAVF_DOWN:
@@ -1998,7 +1993,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 		}
 		break;
 	case __IAVF_REMOVE:
-		clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+		mutex_unlock(&adapter->crit_lock);
 		return;
 	default:
 		goto restart_watchdog;
@@ -2020,7 +2015,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 	if (adapter->state == __IAVF_RUNNING ||
 	    adapter->state == __IAVF_COMM_FAILED)
 		iavf_detect_recover_hung(&adapter->vsi);
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 restart_watchdog:
 	if (adapter->aq_required)
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
@@ -2084,7 +2079,7 @@ static void iavf_disable_vf(struct iavf_adapter *adapter)
 	memset(adapter->vf_res, 0, IAVF_VIRTCHNL_VF_RESOURCE_SIZE);
 	iavf_shutdown_adminq(&adapter->hw);
 	adapter->netdev->flags &= ~IFF_UP;
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 	adapter->flags &= ~IAVF_FLAG_RESET_PENDING;
 	adapter->state = __IAVF_DOWN;
 	wake_up(&adapter->down_waitqueue);
@@ -2117,15 +2112,14 @@ static void iavf_reset_task(struct work_struct *work)
 	/* When device is being removed it doesn't make sense to run the reset
 	 * task, just return in such a case.
 	 */
-	if (test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
+	if (mutex_is_locked(&adapter->remove_lock))
 		return;
 
-	if (iavf_lock_timeout(adapter, __IAVF_IN_CRITICAL_TASK, 200)) {
+	if (iavf_lock_timeout(&adapter->crit_lock, 200)) {
 		schedule_work(&adapter->reset_task);
 		return;
 	}
-	while (test_and_set_bit(__IAVF_IN_CLIENT_TASK,
-				&adapter->crit_section))
+	while (!mutex_trylock(&adapter->client_lock))
 		usleep_range(500, 1000);
 	if (CLIENT_ENABLED(adapter)) {
 		adapter->flags &= ~(IAVF_FLAG_CLIENT_NEEDS_OPEN |
@@ -2177,7 +2171,7 @@ static void iavf_reset_task(struct work_struct *work)
 		dev_err(&adapter->pdev->dev, "Reset never finished (%x)\n",
 			reg_val);
 		iavf_disable_vf(adapter);
-		clear_bit(__IAVF_IN_CLIENT_TASK, &adapter->crit_section);
+		mutex_unlock(&adapter->client_lock);
 		return; /* Do not attempt to reinit. It's dead, Jim. */
 	}
 
@@ -2304,13 +2298,13 @@ static void iavf_reset_task(struct work_struct *work)
 		adapter->state = __IAVF_DOWN;
 		wake_up(&adapter->down_waitqueue);
 	}
-	clear_bit(__IAVF_IN_CLIENT_TASK, &adapter->crit_section);
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->client_lock);
+	mutex_unlock(&adapter->crit_lock);
 
 	return;
 reset_err:
-	clear_bit(__IAVF_IN_CLIENT_TASK, &adapter->crit_section);
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->client_lock);
+	mutex_unlock(&adapter->crit_lock);
 	dev_err(&adapter->pdev->dev, "failed to allocate resources during reinit\n");
 	iavf_close(netdev);
 }
@@ -2338,7 +2332,7 @@ static void iavf_adminq_task(struct work_struct *work)
 	if (!event.msg_buf)
 		goto out;
 
-	if (iavf_lock_timeout(adapter, __IAVF_IN_CRITICAL_TASK, 200))
+	if (iavf_lock_timeout(&adapter->crit_lock, 200))
 		goto freedom;
 	do {
 		ret = iavf_clean_arq_element(hw, &event, &pending);
@@ -2353,7 +2347,7 @@ static void iavf_adminq_task(struct work_struct *work)
 		if (pending != 0)
 			memset(event.msg_buf, 0, IAVF_MAX_AQ_BUF_SIZE);
 	} while (pending);
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 
 	if ((adapter->flags &
 	     (IAVF_FLAG_RESET_PENDING | IAVF_FLAG_RESET_NEEDED)) ||
@@ -2420,7 +2414,7 @@ static void iavf_client_task(struct work_struct *work)
 	 * later.
 	 */
 
-	if (test_and_set_bit(__IAVF_IN_CLIENT_TASK, &adapter->crit_section))
+	if (!mutex_trylock(&adapter->client_lock))
 		return;
 
 	if (adapter->flags & IAVF_FLAG_SERVICE_CLIENT_REQUESTED) {
@@ -2443,7 +2437,7 @@ static void iavf_client_task(struct work_struct *work)
 		adapter->flags &= ~IAVF_FLAG_CLIENT_NEEDS_OPEN;
 	}
 out:
-	clear_bit(__IAVF_IN_CLIENT_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->client_lock);
 }
 
 /**
@@ -3046,8 +3040,7 @@ static int iavf_configure_clsflower(struct iavf_adapter *adapter,
 	if (!filter)
 		return -ENOMEM;
 
-	while (test_and_set_bit(__IAVF_IN_CRITICAL_TASK,
-				&adapter->crit_section)) {
+	while (!mutex_trylock(&adapter->crit_lock)) {
 		if (--count == 0)
 			goto err;
 		udelay(1);
@@ -3078,7 +3071,7 @@ static int iavf_configure_clsflower(struct iavf_adapter *adapter,
 	if (err)
 		kfree(filter);
 
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 	return err;
 }
 
@@ -3225,8 +3218,7 @@ static int iavf_open(struct net_device *netdev)
 		return -EIO;
 	}
 
-	while (test_and_set_bit(__IAVF_IN_CRITICAL_TASK,
-				&adapter->crit_section))
+	while (!mutex_trylock(&adapter->crit_lock))
 		usleep_range(500, 1000);
 
 	if (adapter->state != __IAVF_DOWN) {
@@ -3261,7 +3253,7 @@ static int iavf_open(struct net_device *netdev)
 
 	iavf_irq_enable(adapter, true);
 
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 
 	return 0;
 
@@ -3273,7 +3265,7 @@ static int iavf_open(struct net_device *netdev)
 err_setup_tx:
 	iavf_free_all_tx_resources(adapter);
 err_unlock:
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 
 	return err;
 }
@@ -3297,8 +3289,7 @@ static int iavf_close(struct net_device *netdev)
 	if (adapter->state <= __IAVF_DOWN_PENDING)
 		return 0;
 
-	while (test_and_set_bit(__IAVF_IN_CRITICAL_TASK,
-				&adapter->crit_section))
+	while (!mutex_trylock(&adapter->crit_lock))
 		usleep_range(500, 1000);
 
 	set_bit(__IAVF_VSI_DOWN, adapter->vsi.state);
@@ -3309,7 +3300,7 @@ static int iavf_close(struct net_device *netdev)
 	adapter->state = __IAVF_DOWN_PENDING;
 	iavf_free_traffic_irqs(adapter);
 
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 
 	/* We explicitly don't free resources here because the hardware is
 	 * still active and can DMA into memory. Resources are cleared in
@@ -3658,8 +3649,8 @@ static void iavf_init_task(struct work_struct *work)
 						    init_task.work);
 	struct iavf_hw *hw = &adapter->hw;
 
-	if (iavf_lock_timeout(adapter, __IAVF_IN_CRITICAL_TASK, 5000)) {
-		dev_warn(&adapter->pdev->dev, "failed to set __IAVF_IN_CRITICAL_TASK in %s\n", __FUNCTION__);
+	if (iavf_lock_timeout(&adapter->crit_lock, 5000)) {
+		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __FUNCTION__);
 		return;
 	}
 	switch (adapter->state) {
@@ -3694,7 +3685,7 @@ static void iavf_init_task(struct work_struct *work)
 	}
 	queue_delayed_work(iavf_wq, &adapter->init_task, HZ);
 out:
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 }
 
 /**
@@ -3711,12 +3702,12 @@ static void iavf_shutdown(struct pci_dev *pdev)
 	if (netif_running(netdev))
 		iavf_close(netdev);
 
-	if (iavf_lock_timeout(adapter, __IAVF_IN_CRITICAL_TASK, 5000))
-		dev_warn(&adapter->pdev->dev, "failed to set __IAVF_IN_CRITICAL_TASK in %s\n", __FUNCTION__);
+	if (iavf_lock_timeout(&adapter->crit_lock, 5000))
+		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __FUNCTION__);
 	/* Prevent the watchdog from running. */
 	adapter->state = __IAVF_REMOVE;
 	adapter->aq_required = 0;
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 
 #ifdef CONFIG_PM
 	pci_save_state(pdev);
@@ -3810,6 +3801,9 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* set up the locks for the AQ, do this only once in probe
 	 * and destroy them only once in remove
 	 */
+	mutex_init(&adapter->crit_lock);
+	mutex_init(&adapter->client_lock);
+	mutex_init(&adapter->remove_lock);
 	mutex_init(&hw->aq.asq_mutex);
 	mutex_init(&hw->aq.arq_mutex);
 
@@ -3861,8 +3855,7 @@ static int __maybe_unused iavf_suspend(struct device *dev_d)
 
 	netif_device_detach(netdev);
 
-	while (test_and_set_bit(__IAVF_IN_CRITICAL_TASK,
-				&adapter->crit_section))
+	while (!mutex_trylock(&adapter->crit_lock))
 		usleep_range(500, 1000);
 
 	if (netif_running(netdev)) {
@@ -3873,7 +3866,7 @@ static int __maybe_unused iavf_suspend(struct device *dev_d)
 	iavf_free_misc_irq(adapter);
 	iavf_reset_interrupt_capability(adapter);
 
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 
 	return 0;
 }
@@ -3935,7 +3928,7 @@ static void iavf_remove(struct pci_dev *pdev)
 	struct iavf_hw *hw = &adapter->hw;
 	int err;
 	/* Indicate we are in remove and not to run reset_task */
-	set_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section);
+	mutex_lock(&adapter->remove_lock);
 	cancel_delayed_work_sync(&adapter->init_task);
 	cancel_work_sync(&adapter->reset_task);
 	cancel_delayed_work_sync(&adapter->client_task);
@@ -3957,8 +3950,8 @@ static void iavf_remove(struct pci_dev *pdev)
 		iavf_request_reset(adapter);
 		msleep(50);
 	}
-	if (iavf_lock_timeout(adapter, __IAVF_IN_CRITICAL_TASK, 5000))
-		dev_warn(&adapter->pdev->dev, "failed to set __IAVF_IN_CRITICAL_TASK in %s\n", __FUNCTION__);
+	if (iavf_lock_timeout(&adapter->crit_lock, 5000))
+		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __FUNCTION__);
 
 	/* Shut down all the garbage mashers on the detention level */
 	adapter->state = __IAVF_REMOVE;
@@ -3983,6 +3976,11 @@ static void iavf_remove(struct pci_dev *pdev)
 	/* destroy the locks only once, here */
 	mutex_destroy(&hw->aq.arq_mutex);
 	mutex_destroy(&hw->aq.asq_mutex);
+	mutex_destroy(&adapter->client_lock);
+	mutex_unlock(&adapter->crit_lock);
+	mutex_destroy(&adapter->crit_lock);
+	mutex_unlock(&adapter->remove_lock);
+	mutex_destroy(&adapter->remove_lock);
 
 	iounmap(hw->hw_addr);
 	pci_release_regions(pdev);
-- 
2.26.2

