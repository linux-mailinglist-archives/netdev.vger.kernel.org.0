Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C711E495E9
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 01:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbfFQXdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 19:33:25 -0400
Received: from mga12.intel.com ([192.55.52.136]:25834 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728769AbfFQXdY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 19:33:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 16:33:23 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 17 Jun 2019 16:33:25 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jakub Pawlak <jakub.pawlak@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/11] iavf: Remove timer for work triggering, use delaying work instead
Date:   Mon, 17 Jun 2019 16:33:32 -0700
Message-Id: <20190617233336.18119-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617233336.18119-1-jeffrey.t.kirsher@intel.com>
References: <20190617233336.18119-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Pawlak <jakub.pawlak@intel.com>

Remove the watchdog timer, instead declare watchdog task
as delayed work and use dedicated workqueue to service driver
tasks. The dedicated driver workqueue iavf_wq is common
for all driver instances.

Signed-off-by: Jakub Pawlak <jakub.pawlak@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h        |  4 +-
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |  4 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 66 ++++++++-----------
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  2 +-
 4 files changed, 31 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 657019418693..45dfb1a3bb40 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -216,7 +216,6 @@ struct iavf_cloud_filter {
 
 /* board specific private data structure */
 struct iavf_adapter {
-	struct timer_list watchdog_timer;
 	struct work_struct reset_task;
 	struct work_struct adminq_task;
 	struct delayed_work client_task;
@@ -303,7 +302,7 @@ struct iavf_adapter {
 	enum iavf_state_t state;
 	unsigned long crit_section;
 
-	struct work_struct watchdog_task;
+	struct delayed_work watchdog_task;
 	bool netdev_registered;
 	bool link_up;
 	enum virtchnl_link_speed link_speed;
@@ -359,6 +358,7 @@ struct iavf_device {
 /* needed by iavf_ethtool.c */
 extern char iavf_driver_name[];
 extern const char iavf_driver_version[];
+extern struct workqueue_struct *iavf_wq;
 
 int iavf_up(struct iavf_adapter *adapter);
 void iavf_down(struct iavf_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 5bdcd78f216d..dad3eec8ccd8 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -510,7 +510,7 @@ static int iavf_set_priv_flags(struct net_device *netdev, u32 flags)
 	if (changed_flags & IAVF_FLAG_LEGACY_RX) {
 		if (netif_running(netdev)) {
 			adapter->flags |= IAVF_FLAG_RESET_NEEDED;
-			schedule_work(&adapter->reset_task);
+			queue_work(iavf_wq, &adapter->reset_task);
 		}
 	}
 
@@ -622,7 +622,7 @@ static int iavf_set_ringparam(struct net_device *netdev,
 
 	if (netif_running(netdev)) {
 		adapter->flags |= IAVF_FLAG_RESET_NEEDED;
-		schedule_work(&adapter->reset_task);
+		queue_work(iavf_wq, &adapter->reset_task);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index d5f452e4aca8..f9c0d50810bb 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -57,7 +57,7 @@ MODULE_DESCRIPTION("Intel(R) Ethernet Adaptive Virtual Function Network Driver")
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION(DRV_VERSION);
 
-static struct workqueue_struct *iavf_wq;
+struct workqueue_struct *iavf_wq;
 
 /**
  * iavf_allocate_dma_mem_d - OS specific memory alloc for shared code
@@ -170,7 +170,7 @@ void iavf_schedule_reset(struct iavf_adapter *adapter)
 	if (!(adapter->flags &
 	      (IAVF_FLAG_RESET_PENDING | IAVF_FLAG_RESET_NEEDED))) {
 		adapter->flags |= IAVF_FLAG_RESET_NEEDED;
-		schedule_work(&adapter->reset_task);
+		queue_work(iavf_wq, &adapter->reset_task);
 	}
 }
 
@@ -289,7 +289,7 @@ static irqreturn_t iavf_msix_aq(int irq, void *data)
 	rd32(hw, IAVF_VFINT_ICR0_ENA1);
 
 	/* schedule work on the private workqueue */
-	schedule_work(&adapter->adminq_task);
+	queue_work(iavf_wq, &adapter->adminq_task);
 
 	return IRQ_HANDLED;
 }
@@ -980,7 +980,7 @@ static void iavf_up_complete(struct iavf_adapter *adapter)
 	adapter->aq_required |= IAVF_FLAG_AQ_ENABLE_QUEUES;
 	if (CLIENT_ENABLED(adapter))
 		adapter->flags |= IAVF_FLAG_CLIENT_NEEDS_OPEN;
-	mod_timer_pending(&adapter->watchdog_timer, jiffies + 1);
+	mod_delayed_work(iavf_wq, &adapter->watchdog_task, 0);
 }
 
 /**
@@ -1044,7 +1044,7 @@ void iavf_down(struct iavf_adapter *adapter)
 		adapter->aq_required |= IAVF_FLAG_AQ_DISABLE_QUEUES;
 	}
 
-	mod_timer_pending(&adapter->watchdog_timer, jiffies + 1);
+	mod_delayed_work(iavf_wq, &adapter->watchdog_task, 0);
 }
 
 /**
@@ -1532,19 +1532,6 @@ static int iavf_reinit_interrupt_scheme(struct iavf_adapter *adapter)
 	return err;
 }
 
-/**
- * iavf_watchdog_timer - Periodic call-back timer
- * @data: pointer to adapter disguised as unsigned long
- **/
-static void iavf_watchdog_timer(struct timer_list *t)
-{
-	struct iavf_adapter *adapter = from_timer(adapter, t,
-						    watchdog_timer);
-
-	schedule_work(&adapter->watchdog_task);
-	/* timer will be rescheduled in watchdog task */
-}
-
 /**
  * iavf_process_aq_command - process aq_required flags
  * and sends aq command
@@ -1680,7 +1667,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 {
 	struct iavf_adapter *adapter = container_of(work,
 						    struct iavf_adapter,
-						    watchdog_task);
+						    watchdog_task.work);
 	struct iavf_hw *hw = &adapter->hw;
 	u32 reg_val;
 
@@ -1696,7 +1683,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 			dev_err(&adapter->pdev->dev, "Hardware came out of reset. Attemptingreinit.\n");
 			adapter->state = __IAVF_STARTUP;
 			adapter->flags &= ~IAVF_FLAG_PF_COMMS_FAILED;
-			schedule_delayed_work(&adapter->init_task, 10);
+			queue_delayed_work(iavf_wq, &adapter->init_task, 10);
 			clear_bit(__IAVF_IN_CRITICAL_TASK,
 				  &adapter->crit_section);
 			/* Don't reschedule the watchdog, since we've restarted
@@ -1721,7 +1708,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 		adapter->state = __IAVF_RESETTING;
 		adapter->flags |= IAVF_FLAG_RESET_PENDING;
 		dev_err(&adapter->pdev->dev, "Hardware reset detected\n");
-		schedule_work(&adapter->reset_task);
+		queue_work(iavf_wq, &adapter->reset_task);
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
 		goto watchdog_done;
@@ -1753,11 +1740,11 @@ static void iavf_watchdog_task(struct work_struct *work)
 	if (adapter->state == __IAVF_REMOVE)
 		return;
 	if (adapter->aq_required)
-		mod_timer(&adapter->watchdog_timer,
-			  jiffies + msecs_to_jiffies(20));
+		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
+				   msecs_to_jiffies(20));
 	else
-		mod_timer(&adapter->watchdog_timer, jiffies + (HZ * 2));
-	schedule_work(&adapter->adminq_task);
+		queue_delayed_work(iavf_wq, &adapter->watchdog_task, HZ * 2);
+	queue_work(iavf_wq, &adapter->adminq_task);
 }
 
 static void iavf_disable_vf(struct iavf_adapter *adapter)
@@ -1981,7 +1968,7 @@ static void iavf_reset_task(struct work_struct *work)
 	adapter->aq_required |= IAVF_FLAG_AQ_ADD_CLOUD_FILTER;
 	iavf_misc_irq_enable(adapter);
 
-	mod_timer(&adapter->watchdog_timer, jiffies + 2);
+	mod_delayed_work(iavf_wq, &adapter->watchdog_task, 2);
 
 	/* We were running when the reset started, so we need to restore some
 	 * state here.
@@ -2922,7 +2909,7 @@ static int iavf_setup_tc(struct net_device *netdev, enum tc_setup_type type,
  * The open entry point is called when a network interface is made
  * active by the system (IFF_UP).  At this point all resources needed
  * for transmit and receive operations are allocated, the interrupt
- * handler is registered with the OS, the watchdog timer is started,
+ * handler is registered with the OS, the watchdog is started,
  * and the stack is notified that the interface is ready.
  **/
 static int iavf_open(struct net_device *netdev)
@@ -3057,7 +3044,7 @@ static int iavf_change_mtu(struct net_device *netdev, int new_mtu)
 		adapter->flags |= IAVF_FLAG_SERVICE_CLIENT_REQUESTED;
 	}
 	adapter->flags |= IAVF_FLAG_RESET_NEEDED;
-	schedule_work(&adapter->reset_task);
+	queue_work(iavf_wq, &adapter->reset_task);
 
 	return 0;
 }
@@ -3492,8 +3479,7 @@ static void iavf_init_task(struct work_struct *work)
 		ether_addr_copy(netdev->perm_addr, adapter->hw.mac.addr);
 	}
 
-	timer_setup(&adapter->watchdog_timer, iavf_watchdog_timer, 0);
-	mod_timer(&adapter->watchdog_timer, jiffies + 1);
+	queue_delayed_work(iavf_wq, &adapter->watchdog_task, 1);
 
 	adapter->tx_desc_count = IAVF_DEFAULT_TXD;
 	adapter->rx_desc_count = IAVF_DEFAULT_RXD;
@@ -3544,13 +3530,14 @@ static void iavf_init_task(struct work_struct *work)
 
 	if (RSS_AQ(adapter)) {
 		adapter->aq_required |= IAVF_FLAG_AQ_CONFIGURE_RSS;
-		mod_timer_pending(&adapter->watchdog_timer, jiffies + 1);
+		mod_delayed_work(iavf_wq, &adapter->watchdog_task, 1);
 	} else {
 		iavf_init_rss(adapter);
 	}
 	return;
 restart:
-	schedule_delayed_work(&adapter->init_task, msecs_to_jiffies(30));
+	queue_delayed_work(iavf_wq, &adapter->init_task,
+			   msecs_to_jiffies(30));
 	return;
 err_mem:
 	iavf_free_rss(adapter);
@@ -3568,10 +3555,10 @@ static void iavf_init_task(struct work_struct *work)
 		adapter->flags |= IAVF_FLAG_PF_COMMS_FAILED;
 		iavf_shutdown_adminq(hw);
 		adapter->state = __IAVF_STARTUP;
-		schedule_delayed_work(&adapter->init_task, HZ * 5);
+		queue_delayed_work(iavf_wq, &adapter->init_task, HZ * 5);
 		return;
 	}
-	schedule_delayed_work(&adapter->init_task, HZ);
+	queue_delayed_work(iavf_wq, &adapter->init_task, HZ);
 }
 
 /**
@@ -3696,11 +3683,11 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	INIT_WORK(&adapter->reset_task, iavf_reset_task);
 	INIT_WORK(&adapter->adminq_task, iavf_adminq_task);
-	INIT_WORK(&adapter->watchdog_task, iavf_watchdog_task);
+	INIT_DELAYED_WORK(&adapter->watchdog_task, iavf_watchdog_task);
 	INIT_DELAYED_WORK(&adapter->client_task, iavf_client_task);
 	INIT_DELAYED_WORK(&adapter->init_task, iavf_init_task);
-	schedule_delayed_work(&adapter->init_task,
-			      msecs_to_jiffies(5 * (pdev->devfn & 0x07)));
+	queue_delayed_work(iavf_wq, &adapter->init_task,
+			   msecs_to_jiffies(5 * (pdev->devfn & 0x07)));
 
 	/* Setup the wait queue for indicating transition to down status */
 	init_waitqueue_head(&adapter->down_waitqueue);
@@ -3796,7 +3783,7 @@ static int iavf_resume(struct pci_dev *pdev)
 		return err;
 	}
 
-	schedule_work(&adapter->reset_task);
+	queue_work(iavf_wq, &adapter->reset_task);
 
 	netif_device_attach(netdev);
 
@@ -3856,8 +3843,7 @@ static void iavf_remove(struct pci_dev *pdev)
 	iavf_reset_interrupt_capability(adapter);
 	iavf_free_q_vectors(adapter);
 
-	if (adapter->watchdog_timer.function)
-		del_timer_sync(&adapter->watchdog_timer);
+	cancel_delayed_work_sync(&adapter->watchdog_task);
 
 	cancel_work_sync(&adapter->adminq_task);
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index dd97509e2da1..cb7c56c5afe6 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -1238,7 +1238,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 			if (!(adapter->flags & IAVF_FLAG_RESET_PENDING)) {
 				adapter->flags |= IAVF_FLAG_RESET_PENDING;
 				dev_info(&adapter->pdev->dev, "Scheduling reset task\n");
-				schedule_work(&adapter->reset_task);
+				queue_work(iavf_wq, &adapter->reset_task);
 			}
 			break;
 		default:
-- 
2.21.0

