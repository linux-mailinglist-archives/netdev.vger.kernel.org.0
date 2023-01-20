Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFC8675F6F
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 22:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjATVKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 16:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjATVKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 16:10:30 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B5C95758
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 13:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674249029; x=1705785029;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v5Bo+jiyHa5QOQFAqedWWfV0DTwiGE6PKH2qniXGma4=;
  b=TPO0LWyMKYlT8+wjisHKhmxrLktgKbRbqPnvfTwhSoOhKIhSj8RLIsxr
   Liw9fpr1m/r5lv/AXM+pAoxs2jMLGDDTGbRSL0hC4CPXt1zNs7Wwh/WvQ
   I+leIepqjEkH0LG1tVP1Br6WRXkXdDLXrTssMpk8aq6JLmC/6Y7wFUFXt
   wmSp8/6/+exQmt/CrreZG/0Y2qbFAEIfIOhEISJ/qs2cuafu1AcYXhIhe
   QBXoi+VEUSu0/A6JPQj1p4xcpX9lr0Kw+gdRN+Jv8ib8Ca3js9F+R07/6
   QT4uBpyyfZ13G9JDV3l0Usb1Ou9V16gDXhMreNtAeUPEbFCrzUyCskiSy
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="352949176"
X-IronPort-AV: E=Sophos;i="5.97,233,1669104000"; 
   d="scan'208";a="352949176"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 13:10:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="784667625"
X-IronPort-AV: E=Sophos;i="5.97,233,1669104000"; 
   d="scan'208";a="784667625"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga004.jf.intel.com with ESMTP; 20 Jan 2023 13:10:26 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Schmidt <mschmidt@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Ivan Vecera <ivecera@redhat.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: [PATCH net 1/3] iavf: fix temporary deadlock and failure to set MAC address
Date:   Fri, 20 Jan 2023 13:10:34 -0800
Message-Id: <20230120211036.430946-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230120211036.430946-1-anthony.l.nguyen@intel.com>
References: <20230120211036.430946-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Schmidt <mschmidt@redhat.com>

We are seeing an issue where setting the MAC address on iavf fails with
EAGAIN after the 2.5s timeout expires in iavf_set_mac().

There is the following deadlock scenario:

iavf_set_mac(), holding rtnl_lock, waits on:
  iavf_watchdog_task (within iavf_wq) to send a message to the PF,
 and
  iavf_adminq_task (within iavf_wq) to receive a response from the PF.
In this adapter state (>=__IAVF_DOWN), these tasks do not need to take
rtnl_lock, but iavf_wq is a global single-threaded workqueue, so they
may get stuck waiting for another adapter's iavf_watchdog_task to run
iavf_init_config_adapter(), which does take rtnl_lock.

The deadlock resolves itself by the timeout in iavf_set_mac(),
which results in EAGAIN returned to userspace.

Let's break the deadlock loop by changing iavf_wq into a per-adapter
workqueue, so that one adapter's tasks are not blocked by another's.

Fixes: 35a2443d0910 ("iavf: Add waiting for response from PF in set mac")
Co-developed-by: Ivan Vecera <ivecera@redhat.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h        |  2 +-
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 10 +--
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 86 +++++++++----------
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  2 +-
 4 files changed, 49 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 0d1bab4ac1b0..2a9f1eeeb701 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -249,6 +249,7 @@ struct iavf_cloud_filter {
 
 /* board specific private data structure */
 struct iavf_adapter {
+	struct workqueue_struct *wq;
 	struct work_struct reset_task;
 	struct work_struct adminq_task;
 	struct delayed_work client_task;
@@ -459,7 +460,6 @@ struct iavf_device {
 
 /* needed by iavf_ethtool.c */
 extern char iavf_driver_name[];
-extern struct workqueue_struct *iavf_wq;
 
 static inline const char *iavf_state_str(enum iavf_state_t state)
 {
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index d79ead5e8d0c..6f171d1d85b7 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -532,7 +532,7 @@ static int iavf_set_priv_flags(struct net_device *netdev, u32 flags)
 	if (changed_flags & IAVF_FLAG_LEGACY_RX) {
 		if (netif_running(netdev)) {
 			adapter->flags |= IAVF_FLAG_RESET_NEEDED;
-			queue_work(iavf_wq, &adapter->reset_task);
+			queue_work(adapter->wq, &adapter->reset_task);
 		}
 	}
 
@@ -672,7 +672,7 @@ static int iavf_set_ringparam(struct net_device *netdev,
 
 	if (netif_running(netdev)) {
 		adapter->flags |= IAVF_FLAG_RESET_NEEDED;
-		queue_work(iavf_wq, &adapter->reset_task);
+		queue_work(adapter->wq, &adapter->reset_task);
 	}
 
 	return 0;
@@ -1433,7 +1433,7 @@ static int iavf_add_fdir_ethtool(struct iavf_adapter *adapter, struct ethtool_rx
 	adapter->aq_required |= IAVF_FLAG_AQ_ADD_FDIR_FILTER;
 	spin_unlock_bh(&adapter->fdir_fltr_lock);
 
-	mod_delayed_work(iavf_wq, &adapter->watchdog_task, 0);
+	mod_delayed_work(adapter->wq, &adapter->watchdog_task, 0);
 
 ret:
 	if (err && fltr)
@@ -1474,7 +1474,7 @@ static int iavf_del_fdir_ethtool(struct iavf_adapter *adapter, struct ethtool_rx
 	spin_unlock_bh(&adapter->fdir_fltr_lock);
 
 	if (fltr && fltr->state == IAVF_FDIR_FLTR_DEL_REQUEST)
-		mod_delayed_work(iavf_wq, &adapter->watchdog_task, 0);
+		mod_delayed_work(adapter->wq, &adapter->watchdog_task, 0);
 
 	return err;
 }
@@ -1658,7 +1658,7 @@ iavf_set_adv_rss_hash_opt(struct iavf_adapter *adapter,
 	spin_unlock_bh(&adapter->adv_rss_lock);
 
 	if (!err)
-		mod_delayed_work(iavf_wq, &adapter->watchdog_task, 0);
+		mod_delayed_work(adapter->wq, &adapter->watchdog_task, 0);
 
 	mutex_unlock(&adapter->crit_lock);
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index adc02adef83a..0aa32c164ecf 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -49,7 +49,6 @@ MODULE_DESCRIPTION("Intel(R) Ethernet Adaptive Virtual Function Network Driver")
 MODULE_LICENSE("GPL v2");
 
 static const struct net_device_ops iavf_netdev_ops;
-struct workqueue_struct *iavf_wq;
 
 int iavf_status_to_errno(enum iavf_status status)
 {
@@ -277,7 +276,7 @@ void iavf_schedule_reset(struct iavf_adapter *adapter)
 	if (!(adapter->flags &
 	      (IAVF_FLAG_RESET_PENDING | IAVF_FLAG_RESET_NEEDED))) {
 		adapter->flags |= IAVF_FLAG_RESET_NEEDED;
-		queue_work(iavf_wq, &adapter->reset_task);
+		queue_work(adapter->wq, &adapter->reset_task);
 	}
 }
 
@@ -291,7 +290,7 @@ void iavf_schedule_reset(struct iavf_adapter *adapter)
 void iavf_schedule_request_stats(struct iavf_adapter *adapter)
 {
 	adapter->aq_required |= IAVF_FLAG_AQ_REQUEST_STATS;
-	mod_delayed_work(iavf_wq, &adapter->watchdog_task, 0);
+	mod_delayed_work(adapter->wq, &adapter->watchdog_task, 0);
 }
 
 /**
@@ -411,7 +410,7 @@ static irqreturn_t iavf_msix_aq(int irq, void *data)
 
 	if (adapter->state != __IAVF_REMOVE)
 		/* schedule work on the private workqueue */
-		queue_work(iavf_wq, &adapter->adminq_task);
+		queue_work(adapter->wq, &adapter->adminq_task);
 
 	return IRQ_HANDLED;
 }
@@ -1034,7 +1033,7 @@ int iavf_replace_primary_mac(struct iavf_adapter *adapter,
 
 	/* schedule the watchdog task to immediately process the request */
 	if (f) {
-		queue_work(iavf_wq, &adapter->watchdog_task.work);
+		queue_work(adapter->wq, &adapter->watchdog_task.work);
 		return 0;
 	}
 	return -ENOMEM;
@@ -1257,7 +1256,7 @@ static void iavf_up_complete(struct iavf_adapter *adapter)
 	adapter->aq_required |= IAVF_FLAG_AQ_ENABLE_QUEUES;
 	if (CLIENT_ENABLED(adapter))
 		adapter->flags |= IAVF_FLAG_CLIENT_NEEDS_OPEN;
-	mod_delayed_work(iavf_wq, &adapter->watchdog_task, 0);
+	mod_delayed_work(adapter->wq, &adapter->watchdog_task, 0);
 }
 
 /**
@@ -1414,7 +1413,7 @@ void iavf_down(struct iavf_adapter *adapter)
 		adapter->aq_required |= IAVF_FLAG_AQ_DISABLE_QUEUES;
 	}
 
-	mod_delayed_work(iavf_wq, &adapter->watchdog_task, 0);
+	mod_delayed_work(adapter->wq, &adapter->watchdog_task, 0);
 }
 
 /**
@@ -2248,7 +2247,7 @@ iavf_set_vlan_offload_features(struct iavf_adapter *adapter,
 
 	if (aq_required) {
 		adapter->aq_required |= aq_required;
-		mod_delayed_work(iavf_wq, &adapter->watchdog_task, 0);
+		mod_delayed_work(adapter->wq, &adapter->watchdog_task, 0);
 	}
 }
 
@@ -2700,7 +2699,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
 		mutex_unlock(&adapter->crit_lock);
-		queue_work(iavf_wq, &adapter->reset_task);
+		queue_work(adapter->wq, &adapter->reset_task);
 		return;
 	}
 
@@ -2708,31 +2707,31 @@ static void iavf_watchdog_task(struct work_struct *work)
 	case __IAVF_STARTUP:
 		iavf_startup(adapter);
 		mutex_unlock(&adapter->crit_lock);
-		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
+		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(30));
 		return;
 	case __IAVF_INIT_VERSION_CHECK:
 		iavf_init_version_check(adapter);
 		mutex_unlock(&adapter->crit_lock);
-		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
+		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(30));
 		return;
 	case __IAVF_INIT_GET_RESOURCES:
 		iavf_init_get_resources(adapter);
 		mutex_unlock(&adapter->crit_lock);
-		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
+		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(1));
 		return;
 	case __IAVF_INIT_EXTENDED_CAPS:
 		iavf_init_process_extended_caps(adapter);
 		mutex_unlock(&adapter->crit_lock);
-		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
+		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(1));
 		return;
 	case __IAVF_INIT_CONFIG_ADAPTER:
 		iavf_init_config_adapter(adapter);
 		mutex_unlock(&adapter->crit_lock);
-		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
+		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(1));
 		return;
 	case __IAVF_INIT_FAILED:
@@ -2751,14 +2750,14 @@ static void iavf_watchdog_task(struct work_struct *work)
 			adapter->flags |= IAVF_FLAG_PF_COMMS_FAILED;
 			iavf_shutdown_adminq(hw);
 			mutex_unlock(&adapter->crit_lock);
-			queue_delayed_work(iavf_wq,
+			queue_delayed_work(adapter->wq,
 					   &adapter->watchdog_task, (5 * HZ));
 			return;
 		}
 		/* Try again from failed step*/
 		iavf_change_state(adapter, adapter->last_state);
 		mutex_unlock(&adapter->crit_lock);
-		queue_delayed_work(iavf_wq, &adapter->watchdog_task, HZ);
+		queue_delayed_work(adapter->wq, &adapter->watchdog_task, HZ);
 		return;
 	case __IAVF_COMM_FAILED:
 		if (test_bit(__IAVF_IN_REMOVE_TASK,
@@ -2789,13 +2788,14 @@ static void iavf_watchdog_task(struct work_struct *work)
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
 		mutex_unlock(&adapter->crit_lock);
-		queue_delayed_work(iavf_wq,
+		queue_delayed_work(adapter->wq,
 				   &adapter->watchdog_task,
 				   msecs_to_jiffies(10));
 		return;
 	case __IAVF_RESETTING:
 		mutex_unlock(&adapter->crit_lock);
-		queue_delayed_work(iavf_wq, &adapter->watchdog_task, HZ * 2);
+		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
+				   HZ * 2);
 		return;
 	case __IAVF_DOWN:
 	case __IAVF_DOWN_PENDING:
@@ -2834,9 +2834,9 @@ static void iavf_watchdog_task(struct work_struct *work)
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
 		dev_err(&adapter->pdev->dev, "Hardware reset detected\n");
-		queue_work(iavf_wq, &adapter->reset_task);
+		queue_work(adapter->wq, &adapter->reset_task);
 		mutex_unlock(&adapter->crit_lock);
-		queue_delayed_work(iavf_wq,
+		queue_delayed_work(adapter->wq,
 				   &adapter->watchdog_task, HZ * 2);
 		return;
 	}
@@ -2845,12 +2845,13 @@ static void iavf_watchdog_task(struct work_struct *work)
 	mutex_unlock(&adapter->crit_lock);
 restart_watchdog:
 	if (adapter->state >= __IAVF_DOWN)
-		queue_work(iavf_wq, &adapter->adminq_task);
+		queue_work(adapter->wq, &adapter->adminq_task);
 	if (adapter->aq_required)
-		queue_delayed_work(iavf_wq, &adapter->watchdog_task,
+		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
 				   msecs_to_jiffies(20));
 	else
-		queue_delayed_work(iavf_wq, &adapter->watchdog_task, HZ * 2);
+		queue_delayed_work(adapter->wq, &adapter->watchdog_task,
+				   HZ * 2);
 }
 
 /**
@@ -2952,7 +2953,7 @@ static void iavf_reset_task(struct work_struct *work)
 	 */
 	if (!mutex_trylock(&adapter->crit_lock)) {
 		if (adapter->state != __IAVF_REMOVE)
-			queue_work(iavf_wq, &adapter->reset_task);
+			queue_work(adapter->wq, &adapter->reset_task);
 
 		goto reset_finish;
 	}
@@ -3116,7 +3117,7 @@ static void iavf_reset_task(struct work_struct *work)
 	bitmap_clear(adapter->vsi.active_cvlans, 0, VLAN_N_VID);
 	bitmap_clear(adapter->vsi.active_svlans, 0, VLAN_N_VID);
 
-	mod_delayed_work(iavf_wq, &adapter->watchdog_task, 2);
+	mod_delayed_work(adapter->wq, &adapter->watchdog_task, 2);
 
 	/* We were running when the reset started, so we need to restore some
 	 * state here.
@@ -3208,7 +3209,7 @@ static void iavf_adminq_task(struct work_struct *work)
 		if (adapter->state == __IAVF_REMOVE)
 			return;
 
-		queue_work(iavf_wq, &adapter->adminq_task);
+		queue_work(adapter->wq, &adapter->adminq_task);
 		goto out;
 	}
 
@@ -4349,7 +4350,7 @@ static int iavf_change_mtu(struct net_device *netdev, int new_mtu)
 
 	if (netif_running(netdev)) {
 		adapter->flags |= IAVF_FLAG_RESET_NEEDED;
-		queue_work(iavf_wq, &adapter->reset_task);
+		queue_work(adapter->wq, &adapter->reset_task);
 	}
 
 	return 0;
@@ -4898,6 +4899,13 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	hw = &adapter->hw;
 	hw->back = adapter;
 
+	adapter->wq = alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM,
+					      iavf_driver_name);
+	if (!adapter->wq) {
+		err = -ENOMEM;
+		goto err_alloc_wq;
+	}
+
 	adapter->msg_enable = BIT(DEFAULT_DEBUG_LEVEL_SHIFT) - 1;
 	iavf_change_state(adapter, __IAVF_STARTUP);
 
@@ -4942,7 +4950,7 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	INIT_WORK(&adapter->adminq_task, iavf_adminq_task);
 	INIT_DELAYED_WORK(&adapter->watchdog_task, iavf_watchdog_task);
 	INIT_DELAYED_WORK(&adapter->client_task, iavf_client_task);
-	queue_delayed_work(iavf_wq, &adapter->watchdog_task,
+	queue_delayed_work(adapter->wq, &adapter->watchdog_task,
 			   msecs_to_jiffies(5 * (pdev->devfn & 0x07)));
 
 	/* Setup the wait queue for indicating transition to down status */
@@ -4954,6 +4962,8 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
 err_ioremap:
+	destroy_workqueue(adapter->wq);
+err_alloc_wq:
 	free_netdev(netdev);
 err_alloc_etherdev:
 	pci_disable_pcie_error_reporting(pdev);
@@ -5023,7 +5033,7 @@ static int __maybe_unused iavf_resume(struct device *dev_d)
 		return err;
 	}
 
-	queue_work(iavf_wq, &adapter->reset_task);
+	queue_work(adapter->wq, &adapter->reset_task);
 
 	netif_device_attach(adapter->netdev);
 
@@ -5170,6 +5180,8 @@ static void iavf_remove(struct pci_dev *pdev)
 	}
 	spin_unlock_bh(&adapter->adv_rss_lock);
 
+	destroy_workqueue(adapter->wq);
+
 	free_netdev(netdev);
 
 	pci_disable_pcie_error_reporting(pdev);
@@ -5196,24 +5208,11 @@ static struct pci_driver iavf_driver = {
  **/
 static int __init iavf_init_module(void)
 {
-	int ret;
-
 	pr_info("iavf: %s\n", iavf_driver_string);
 
 	pr_info("%s\n", iavf_copyright);
 
-	iavf_wq = alloc_workqueue("%s", WQ_UNBOUND | WQ_MEM_RECLAIM, 1,
-				  iavf_driver_name);
-	if (!iavf_wq) {
-		pr_err("%s: Failed to create workqueue\n", iavf_driver_name);
-		return -ENOMEM;
-	}
-
-	ret = pci_register_driver(&iavf_driver);
-	if (ret)
-		destroy_workqueue(iavf_wq);
-
-	return ret;
+	return pci_register_driver(&iavf_driver);
 }
 
 module_init(iavf_init_module);
@@ -5227,7 +5226,6 @@ module_init(iavf_init_module);
 static void __exit iavf_exit_module(void)
 {
 	pci_unregister_driver(&iavf_driver);
-	destroy_workqueue(iavf_wq);
 }
 
 module_exit(iavf_exit_module);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 24a701fd140e..0752fd67c96e 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -1952,7 +1952,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 			if (!(adapter->flags & IAVF_FLAG_RESET_PENDING)) {
 				adapter->flags |= IAVF_FLAG_RESET_PENDING;
 				dev_info(&adapter->pdev->dev, "Scheduling reset task\n");
-				queue_work(iavf_wq, &adapter->reset_task);
+				queue_work(adapter->wq, &adapter->reset_task);
 			}
 			break;
 		default:
-- 
2.38.1

