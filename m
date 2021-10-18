Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B73E43290A
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbhJRVa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:30:29 -0400
Received: from mga07.intel.com ([134.134.136.100]:15066 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231920AbhJRVa2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 17:30:28 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10141"; a="291835773"
X-IronPort-AV: E=Sophos;i="5.85,382,1624345200"; 
   d="scan'208";a="291835773"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2021 14:28:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,382,1624345200"; 
   d="scan'208";a="493775463"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 18 Oct 2021 14:28:15 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, Jakub Pawlak <jakub.pawlak@intel.com>,
        Jan Sokolowski <jan.sokolowski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 2/3] iavf: Add __IAVF_INIT_FAILED state
Date:   Mon, 18 Oct 2021 14:26:24 -0700
Message-Id: <20211018212625.2059527-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018212625.2059527-1-anthony.l.nguyen@intel.com>
References: <20211018212625.2059527-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

This commit adds a new state, __IAVF_INIT_FAILED to the state machine.
From now on initialization functions report errors not by returning an
error value, but by changing the state to indicate that something went
wrong.

Signed-off-by: Jakub Pawlak <jakub.pawlak@intel.com>
Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf.h      |  1 +
 drivers/net/ethernet/intel/iavf/iavf_main.c | 35 ++++++++++++---------
 2 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index cd359cfe5cce..d27821d5b4ad 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -177,6 +177,7 @@ enum iavf_state_t {
 	__IAVF_INIT_VERSION_CHECK,	/* aq msg sent, awaiting reply */
 	__IAVF_INIT_GET_RESOURCES,	/* aq msg sent, awaiting reply */
 	__IAVF_INIT_SW,		/* got resources, setting up structs */
+	__IAVF_INIT_FAILED,	/* init failed, restarting procedure */
 	__IAVF_RESETTING,		/* in reset */
 	__IAVF_COMM_FAILED,		/* communication with PF failed */
 	/* Below here, watchdog is running */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 3df018c879e1..291473ba70af 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -14,7 +14,7 @@
 static int iavf_setup_all_tx_resources(struct iavf_adapter *adapter);
 static int iavf_setup_all_rx_resources(struct iavf_adapter *adapter);
 static int iavf_close(struct net_device *netdev);
-static int iavf_init_get_resources(struct iavf_adapter *adapter);
+static void iavf_init_get_resources(struct iavf_adapter *adapter);
 static int iavf_check_reset_complete(struct iavf_hw *hw);
 
 char iavf_driver_name[] = "iavf";
@@ -1688,9 +1688,9 @@ static int iavf_process_aq_command(struct iavf_adapter *adapter)
  *
  * Function process __IAVF_STARTUP driver state.
  * When success the state is changed to __IAVF_INIT_VERSION_CHECK
- * when fails it returns -EAGAIN
+ * when fails the state is changed to __IAVF_INIT_FAILED
  **/
-static int iavf_startup(struct iavf_adapter *adapter)
+static void iavf_startup(struct iavf_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
 	struct iavf_hw *hw = &adapter->hw;
@@ -1730,8 +1730,9 @@ static int iavf_startup(struct iavf_adapter *adapter)
 		goto err;
 	}
 	iavf_change_state(adapter, __IAVF_INIT_VERSION_CHECK);
+	return;
 err:
-	return err;
+	iavf_change_state(adapter, __IAVF_INIT_FAILED);
 }
 
 /**
@@ -1740,9 +1741,9 @@ static int iavf_startup(struct iavf_adapter *adapter)
  *
  * Function process __IAVF_INIT_VERSION_CHECK driver state.
  * When success the state is changed to __IAVF_INIT_GET_RESOURCES
- * when fails it returns -EAGAIN
+ * when fails the state is changed to __IAVF_INIT_FAILED
  **/
-static int iavf_init_version_check(struct iavf_adapter *adapter)
+static void iavf_init_version_check(struct iavf_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
 	struct iavf_hw *hw = &adapter->hw;
@@ -1777,8 +1778,9 @@ static int iavf_init_version_check(struct iavf_adapter *adapter)
 		goto err;
 	}
 	iavf_change_state(adapter, __IAVF_INIT_GET_RESOURCES);
+	return;
 err:
-	return err;
+	iavf_change_state(adapter, __IAVF_INIT_FAILED);
 }
 
 /**
@@ -1788,9 +1790,9 @@ static int iavf_init_version_check(struct iavf_adapter *adapter)
  * Function process __IAVF_INIT_GET_RESOURCES driver state and
  * finishes driver initialization procedure.
  * When success the state is changed to __IAVF_DOWN
- * when fails it returns -EAGAIN
+ * when fails the state is changed to __IAVF_INIT_FAILED
  **/
-static int iavf_init_get_resources(struct iavf_adapter *adapter)
+static void iavf_init_get_resources(struct iavf_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
 	struct pci_dev *pdev = adapter->pdev;
@@ -1818,7 +1820,7 @@ static int iavf_init_get_resources(struct iavf_adapter *adapter)
 		 */
 		iavf_shutdown_adminq(hw);
 		dev_err(&pdev->dev, "Unable to get VF config due to PF error condition, not retrying\n");
-		return 0;
+		return;
 	}
 	if (err) {
 		dev_err(&pdev->dev, "Unable to get VF config (%d)\n", err);
@@ -1910,7 +1912,7 @@ static int iavf_init_get_resources(struct iavf_adapter *adapter)
 	else
 		iavf_init_rss(adapter);
 
-	return err;
+	return;
 err_mem:
 	iavf_free_rss(adapter);
 err_register:
@@ -1921,7 +1923,7 @@ static int iavf_init_get_resources(struct iavf_adapter *adapter)
 	kfree(adapter->vf_res);
 	adapter->vf_res = NULL;
 err:
-	return err;
+	iavf_change_state(adapter, __IAVF_INIT_FAILED);
 }
 
 /**
@@ -3658,15 +3660,18 @@ static void iavf_init_task(struct work_struct *work)
 	}
 	switch (adapter->state) {
 	case __IAVF_STARTUP:
-		if (iavf_startup(adapter) < 0)
+		iavf_startup(adapter);
+		if (adapter->state == __IAVF_INIT_FAILED)
 			goto init_failed;
 		break;
 	case __IAVF_INIT_VERSION_CHECK:
-		if (iavf_init_version_check(adapter) < 0)
+		iavf_init_version_check(adapter);
+		if (adapter->state == __IAVF_INIT_FAILED)
 			goto init_failed;
 		break;
 	case __IAVF_INIT_GET_RESOURCES:
-		if (iavf_init_get_resources(adapter) < 0)
+		iavf_init_get_resources(adapter);
+		if (adapter->state == __IAVF_INIT_FAILED)
 			goto init_failed;
 		goto out;
 	default:
-- 
2.31.1

