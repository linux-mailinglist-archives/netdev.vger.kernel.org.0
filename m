Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35F5C135F9D
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 18:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388310AbgAIRrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 12:47:17 -0500
Received: from mga17.intel.com ([192.55.52.151]:61385 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388302AbgAIRrR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 12:47:17 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 09:47:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="254669804"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga002.fm.intel.com with ESMTP; 09 Jan 2020 09:47:15 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net 7/7] e1000e: Revert "e1000e: Make watchdog use delayed work"
Date:   Thu,  9 Jan 2020 09:47:13 -0800
Message-Id: <20200109174713.2940499-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109174713.2940499-1-jeffrey.t.kirsher@intel.com>
References: <20200109174713.2940499-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 59653e6497d16f7ac1d9db088f3959f57ee8c3db.

This is due to this commit causing driver crashes and connections to
reset unexpectedly.

Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
---
 drivers/net/ethernet/intel/e1000e/e1000.h  |  5 +-
 drivers/net/ethernet/intel/e1000e/netdev.c | 54 ++++++++++------------
 2 files changed, 27 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethernet/intel/e1000e/e1000.h
index 6c51b1bad8c4..37a2314d3e6b 100644
--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -185,13 +185,12 @@ struct e1000_phy_regs {
 
 /* board specific private data structure */
 struct e1000_adapter {
+	struct timer_list watchdog_timer;
 	struct timer_list phy_info_timer;
 	struct timer_list blink_timer;
 
 	struct work_struct reset_task;
-	struct delayed_work watchdog_task;
-
-	struct workqueue_struct *e1000_workqueue;
+	struct work_struct watchdog_task;
 
 	const struct e1000_info *ei;
 
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index fe7997c18a10..7c5b18d87b49 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -1780,8 +1780,7 @@ static irqreturn_t e1000_intr_msi(int __always_unused irq, void *data)
 		}
 		/* guard against interrupt when we're going down */
 		if (!test_bit(__E1000_DOWN, &adapter->state))
-			mod_delayed_work(adapter->e1000_workqueue,
-					 &adapter->watchdog_task, HZ);
+			mod_timer(&adapter->watchdog_timer, jiffies + 1);
 	}
 
 	/* Reset on uncorrectable ECC error */
@@ -1861,8 +1860,7 @@ static irqreturn_t e1000_intr(int __always_unused irq, void *data)
 		}
 		/* guard against interrupt when we're going down */
 		if (!test_bit(__E1000_DOWN, &adapter->state))
-			mod_delayed_work(adapter->e1000_workqueue,
-					 &adapter->watchdog_task, HZ);
+			mod_timer(&adapter->watchdog_timer, jiffies + 1);
 	}
 
 	/* Reset on uncorrectable ECC error */
@@ -1907,8 +1905,7 @@ static irqreturn_t e1000_msix_other(int __always_unused irq, void *data)
 		hw->mac.get_link_status = true;
 		/* guard against interrupt when we're going down */
 		if (!test_bit(__E1000_DOWN, &adapter->state))
-			mod_delayed_work(adapter->e1000_workqueue,
-					 &adapter->watchdog_task, HZ);
+			mod_timer(&adapter->watchdog_timer, jiffies + 1);
 	}
 
 	if (!test_bit(__E1000_DOWN, &adapter->state))
@@ -4284,6 +4281,7 @@ void e1000e_down(struct e1000_adapter *adapter, bool reset)
 
 	napi_synchronize(&adapter->napi);
 
+	del_timer_sync(&adapter->watchdog_timer);
 	del_timer_sync(&adapter->phy_info_timer);
 
 	spin_lock(&adapter->stats64_lock);
@@ -5155,11 +5153,25 @@ static void e1000e_check_82574_phy_workaround(struct e1000_adapter *adapter)
 	}
 }
 
+/**
+ * e1000_watchdog - Timer Call-back
+ * @data: pointer to adapter cast into an unsigned long
+ **/
+static void e1000_watchdog(struct timer_list *t)
+{
+	struct e1000_adapter *adapter = from_timer(adapter, t, watchdog_timer);
+
+	/* Do the rest outside of interrupt context */
+	schedule_work(&adapter->watchdog_task);
+
+	/* TODO: make this use queue_delayed_work() */
+}
+
 static void e1000_watchdog_task(struct work_struct *work)
 {
 	struct e1000_adapter *adapter = container_of(work,
 						     struct e1000_adapter,
-						     watchdog_task.work);
+						     watchdog_task);
 	struct net_device *netdev = adapter->netdev;
 	struct e1000_mac_info *mac = &adapter->hw.mac;
 	struct e1000_phy_info *phy = &adapter->hw.phy;
@@ -5407,9 +5419,8 @@ static void e1000_watchdog_task(struct work_struct *work)
 
 	/* Reset the timer */
 	if (!test_bit(__E1000_DOWN, &adapter->state))
-		queue_delayed_work(adapter->e1000_workqueue,
-				   &adapter->watchdog_task,
-				   round_jiffies(2 * HZ));
+		mod_timer(&adapter->watchdog_timer,
+			  round_jiffies(jiffies + 2 * HZ));
 }
 
 #define E1000_TX_FLAGS_CSUM		0x00000001
@@ -7449,21 +7460,11 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_eeprom;
 	}
 
-	adapter->e1000_workqueue = alloc_workqueue("%s", WQ_MEM_RECLAIM, 0,
-						   e1000e_driver_name);
-
-	if (!adapter->e1000_workqueue) {
-		err = -ENOMEM;
-		goto err_workqueue;
-	}
-
-	INIT_DELAYED_WORK(&adapter->watchdog_task, e1000_watchdog_task);
-	queue_delayed_work(adapter->e1000_workqueue, &adapter->watchdog_task,
-			   0);
-
+	timer_setup(&adapter->watchdog_timer, e1000_watchdog, 0);
 	timer_setup(&adapter->phy_info_timer, e1000_update_phy_info, 0);
 
 	INIT_WORK(&adapter->reset_task, e1000_reset_task);
+	INIT_WORK(&adapter->watchdog_task, e1000_watchdog_task);
 	INIT_WORK(&adapter->downshift_task, e1000e_downshift_workaround);
 	INIT_WORK(&adapter->update_phy_task, e1000e_update_phy_task);
 	INIT_WORK(&adapter->print_hang_task, e1000_print_hw_hang);
@@ -7557,9 +7558,6 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
 err_register:
-	flush_workqueue(adapter->e1000_workqueue);
-	destroy_workqueue(adapter->e1000_workqueue);
-err_workqueue:
 	if (!(adapter->flags & FLAG_HAS_AMT))
 		e1000e_release_hw_control(adapter);
 err_eeprom:
@@ -7604,17 +7602,15 @@ static void e1000_remove(struct pci_dev *pdev)
 	 * from being rescheduled.
 	 */
 	set_bit(__E1000_DOWN, &adapter->state);
+	del_timer_sync(&adapter->watchdog_timer);
 	del_timer_sync(&adapter->phy_info_timer);
 
 	cancel_work_sync(&adapter->reset_task);
+	cancel_work_sync(&adapter->watchdog_task);
 	cancel_work_sync(&adapter->downshift_task);
 	cancel_work_sync(&adapter->update_phy_task);
 	cancel_work_sync(&adapter->print_hang_task);
 
-	cancel_delayed_work(&adapter->watchdog_task);
-	flush_workqueue(adapter->e1000_workqueue);
-	destroy_workqueue(adapter->e1000_workqueue);
-
 	if (adapter->flags & FLAG_HAS_HW_TIMESTAMP) {
 		cancel_work_sync(&adapter->tx_hwtstamp_work);
 		if (adapter->tx_hwtstamp_skb) {
-- 
2.24.1

