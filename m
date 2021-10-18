Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC0D432909
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbhJRVa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:30:28 -0400
Received: from mga07.intel.com ([134.134.136.100]:15066 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229555AbhJRVa1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 17:30:27 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10141"; a="291835772"
X-IronPort-AV: E=Sophos;i="5.85,382,1624345200"; 
   d="scan'208";a="291835772"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2021 14:28:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,382,1624345200"; 
   d="scan'208";a="493775459"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 18 Oct 2021 14:28:15 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, Jakub Pawlak <jakub.pawlak@intel.com>,
        Jan Sokolowski <jan.sokolowski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 1/3] iavf: Refactor iavf state machine tracking
Date:   Mon, 18 Oct 2021 14:26:23 -0700
Message-Id: <20211018212625.2059527-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018212625.2059527-1-anthony.l.nguyen@intel.com>
References: <20211018212625.2059527-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

Replace state changes of iavf state machine
with a method that also tracks the previous
state the machine was on.

This change is required for further work with
refactoring init and watchdog state machines.

Tracking of previous state would help us
recover iavf after failure has occurred.

Signed-off-by: Jakub Pawlak <jakub.pawlak@intel.com>
Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h        | 10 +++++
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 37 ++++++++++---------
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  2 +-
 3 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 68c80f04113c..cd359cfe5cce 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -312,6 +312,7 @@ struct iavf_adapter {
 	struct iavf_hw hw; /* defined in iavf_type.h */
 
 	enum iavf_state_t state;
+	enum iavf_state_t last_state;
 	unsigned long crit_section;
 
 	struct delayed_work watchdog_task;
@@ -393,6 +394,15 @@ struct iavf_device {
 extern char iavf_driver_name[];
 extern struct workqueue_struct *iavf_wq;
 
+static inline void iavf_change_state(struct iavf_adapter *adapter,
+				     enum iavf_state_t state)
+{
+	if (adapter->state != state) {
+		adapter->last_state = adapter->state;
+		adapter->state = state;
+	}
+}
+
 int iavf_up(struct iavf_adapter *adapter);
 void iavf_down(struct iavf_adapter *adapter);
 int iavf_process_config(struct iavf_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index ca4712a73574..3df018c879e1 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -960,7 +960,7 @@ static void iavf_configure(struct iavf_adapter *adapter)
  **/
 static void iavf_up_complete(struct iavf_adapter *adapter)
 {
-	adapter->state = __IAVF_RUNNING;
+	iavf_change_state(adapter, __IAVF_RUNNING);
 	clear_bit(__IAVF_VSI_DOWN, adapter->vsi.state);
 
 	iavf_napi_enable_all(adapter);
@@ -1729,7 +1729,7 @@ static int iavf_startup(struct iavf_adapter *adapter)
 		iavf_shutdown_adminq(hw);
 		goto err;
 	}
-	adapter->state = __IAVF_INIT_VERSION_CHECK;
+	iavf_change_state(adapter, __IAVF_INIT_VERSION_CHECK);
 err:
 	return err;
 }
@@ -1753,7 +1753,7 @@ static int iavf_init_version_check(struct iavf_adapter *adapter)
 	if (!iavf_asq_done(hw)) {
 		dev_err(&pdev->dev, "Admin queue command never completed\n");
 		iavf_shutdown_adminq(hw);
-		adapter->state = __IAVF_STARTUP;
+		iavf_change_state(adapter, __IAVF_STARTUP);
 		goto err;
 	}
 
@@ -1776,8 +1776,7 @@ static int iavf_init_version_check(struct iavf_adapter *adapter)
 			err);
 		goto err;
 	}
-	adapter->state = __IAVF_INIT_GET_RESOURCES;
-
+	iavf_change_state(adapter, __IAVF_INIT_GET_RESOURCES);
 err:
 	return err;
 }
@@ -1893,7 +1892,7 @@ static int iavf_init_get_resources(struct iavf_adapter *adapter)
 	if (netdev->features & NETIF_F_GRO)
 		dev_info(&pdev->dev, "GRO is enabled\n");
 
-	adapter->state = __IAVF_DOWN;
+	iavf_change_state(adapter, __IAVF_DOWN);
 	set_bit(__IAVF_VSI_DOWN, adapter->vsi.state);
 	rtnl_unlock();
 
@@ -1941,7 +1940,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 		goto restart_watchdog;
 
 	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED)
-		adapter->state = __IAVF_COMM_FAILED;
+		iavf_change_state(adapter, __IAVF_COMM_FAILED);
 
 	switch (adapter->state) {
 	case __IAVF_COMM_FAILED:
@@ -1952,7 +1951,7 @@ static void iavf_watchdog_task(struct work_struct *work)
 			/* A chance for redemption! */
 			dev_err(&adapter->pdev->dev,
 				"Hardware came out of reset. Attempting reinit.\n");
-			adapter->state = __IAVF_STARTUP;
+			iavf_change_state(adapter, __IAVF_STARTUP);
 			adapter->flags &= ~IAVF_FLAG_PF_COMMS_FAILED;
 			queue_delayed_work(iavf_wq, &adapter->init_task, 10);
 			mutex_unlock(&adapter->crit_lock);
@@ -1999,9 +1998,10 @@ static void iavf_watchdog_task(struct work_struct *work)
 		goto restart_watchdog;
 	}
 
-		/* check for hw reset */
+	/* check for hw reset */
 	reg_val = rd32(hw, IAVF_VF_ARQLEN1) & IAVF_VF_ARQLEN1_ARQENABLE_MASK;
 	if (!reg_val) {
+		iavf_change_state(adapter, __IAVF_RESETTING);
 		adapter->flags |= IAVF_FLAG_RESET_PENDING;
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
@@ -2081,7 +2081,7 @@ static void iavf_disable_vf(struct iavf_adapter *adapter)
 	adapter->netdev->flags &= ~IFF_UP;
 	mutex_unlock(&adapter->crit_lock);
 	adapter->flags &= ~IAVF_FLAG_RESET_PENDING;
-	adapter->state = __IAVF_DOWN;
+	iavf_change_state(adapter, __IAVF_DOWN);
 	wake_up(&adapter->down_waitqueue);
 	dev_info(&adapter->pdev->dev, "Reset task did not complete, VF disabled\n");
 }
@@ -2191,7 +2191,7 @@ static void iavf_reset_task(struct work_struct *work)
 	}
 	iavf_irq_disable(adapter);
 
-	adapter->state = __IAVF_RESETTING;
+	iavf_change_state(adapter, __IAVF_RESETTING);
 	adapter->flags &= ~IAVF_FLAG_RESET_PENDING;
 
 	/* free the Tx/Rx rings and descriptors, might be better to just
@@ -2291,11 +2291,14 @@ static void iavf_reset_task(struct work_struct *work)
 
 		iavf_configure(adapter);
 
+		/* iavf_up_complete() will switch device back
+		 * to __IAVF_RUNNING
+		 */
 		iavf_up_complete(adapter);
 
 		iavf_irq_enable(adapter, true);
 	} else {
-		adapter->state = __IAVF_DOWN;
+		iavf_change_state(adapter, __IAVF_DOWN);
 		wake_up(&adapter->down_waitqueue);
 	}
 	mutex_unlock(&adapter->client_lock);
@@ -3297,7 +3300,7 @@ static int iavf_close(struct net_device *netdev)
 		adapter->flags |= IAVF_FLAG_CLIENT_NEEDS_CLOSE;
 
 	iavf_down(adapter);
-	adapter->state = __IAVF_DOWN_PENDING;
+	iavf_change_state(adapter, __IAVF_DOWN_PENDING);
 	iavf_free_traffic_irqs(adapter);
 
 	mutex_unlock(&adapter->crit_lock);
@@ -3679,7 +3682,7 @@ static void iavf_init_task(struct work_struct *work)
 			"Failed to communicate with PF; waiting before retry\n");
 		adapter->flags |= IAVF_FLAG_PF_COMMS_FAILED;
 		iavf_shutdown_adminq(hw);
-		adapter->state = __IAVF_STARTUP;
+		iavf_change_state(adapter, __IAVF_STARTUP);
 		queue_delayed_work(iavf_wq, &adapter->init_task, HZ * 5);
 		goto out;
 	}
@@ -3705,7 +3708,7 @@ static void iavf_shutdown(struct pci_dev *pdev)
 	if (iavf_lock_timeout(&adapter->crit_lock, 5000))
 		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __FUNCTION__);
 	/* Prevent the watchdog from running. */
-	adapter->state = __IAVF_REMOVE;
+	iavf_change_state(adapter, __IAVF_REMOVE);
 	adapter->aq_required = 0;
 	mutex_unlock(&adapter->crit_lock);
 
@@ -3778,7 +3781,7 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	hw->back = adapter;
 
 	adapter->msg_enable = BIT(DEFAULT_DEBUG_LEVEL_SHIFT) - 1;
-	adapter->state = __IAVF_STARTUP;
+	iavf_change_state(adapter, __IAVF_STARTUP);
 
 	/* Call save state here because it relies on the adapter struct. */
 	pci_save_state(pdev);
@@ -3954,7 +3957,7 @@ static void iavf_remove(struct pci_dev *pdev)
 		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __FUNCTION__);
 
 	/* Shut down all the garbage mashers on the detention level */
-	adapter->state = __IAVF_REMOVE;
+	iavf_change_state(adapter, __IAVF_REMOVE);
 	adapter->aq_required = 0;
 	adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
 	iavf_free_all_tx_resources(adapter);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 8eb8d4663a81..8c3f0f77cb57 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -1735,7 +1735,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		iavf_free_all_tx_resources(adapter);
 		iavf_free_all_rx_resources(adapter);
 		if (adapter->state == __IAVF_DOWN_PENDING) {
-			adapter->state = __IAVF_DOWN;
+			iavf_change_state(adapter, __IAVF_DOWN);
 			wake_up(&adapter->down_waitqueue);
 		}
 		break;
-- 
2.31.1

