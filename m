Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13629620E84
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 12:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbiKHLTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 06:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233792AbiKHLTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 06:19:39 -0500
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B403F588
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 03:19:37 -0800 (PST)
X-QQ-mid: bizesmtp85t1667906372tk0m9kdr
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 08 Nov 2022 19:19:30 +0800 (CST)
X-QQ-SSF: 01400000000000M0M000000A0000000
X-QQ-FEAT: ELPc6+jLxfaPqEXvWKS/nQq4Em1YaoB2TKbok51cVqNeC6fDrnCXWbj7LoheX
        eDP5s1B+zQTqoy9YJrZXZIxAaAnPpzOYZMar55I5G1K1rpptQ9/V2Bx2YnLURjmyCKNX9+8
        Z4+2YhZODgKvLWS4ic0++daSqo4OoKNbe+M4kJt+J4QF6X3+ClwyBvX5UrzYnJt3VtLeHnP
        /lP1YGJrOtVIrDYA1Hi74DRQqU1EHwVwihXfS3wfYVsd3kQOY8i3Bsf7TBABPV63QEGNT0u
        BxegKfUD4c3+dw2onYsyK1g4Rzo2wDgAa3JHoSTRETPF8o0NH5Pwwa2r4Hu7duGHN/bRzgF
        B6foEVZm8Ot9QedmHEJ+ge2uN9FPxgVnq6l3ioB4+1p05L0/V9OkrrvpGy25CsbFYv8o3wx
        u4FCySSyDNf7tBtQNaPg0Q==
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com
Subject: [PATCH net-next 2/5] net: txgbe: Initialize service task
Date:   Tue,  8 Nov 2022 19:19:04 +0800
Message-Id: <20221108111907.48599-3-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108111907.48599-1-mengyuanlou@net-swift.com>
References: <20221108111907.48599-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiawen Wu <jiawenwu@trustnetic.com>

Setup work queue, and initialize service task to process the following
tasks.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  15 +++
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 113 +++++++++++++++++-
 2 files changed, 124 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 19e61377bd00..fb8fd413b755 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -24,6 +24,17 @@ struct txgbe_mac_addr {
 #define TXGBE_MAC_STATE_MODIFIED        0x2
 #define TXGBE_MAC_STATE_IN_USE          0x4
 
+enum txgbe_state_t {
+	__TXGBE_TESTING,
+	__TXGBE_RESETTING,
+	__TXGBE_DOWN,
+	__TXGBE_HANGING,
+	__TXGBE_DISABLED,
+	__TXGBE_REMOVING,
+	__TXGBE_SERVICE_SCHED,
+	__TXGBE_SERVICE_INITED,
+};
+
 /* board specific private data structure */
 struct txgbe_adapter {
 	u8 __iomem *io_addr;    /* Mainly for iounmap use */
@@ -31,6 +42,10 @@ struct txgbe_adapter {
 	struct net_device *netdev;
 	struct pci_dev *pdev;
 
+	unsigned long state;
+	struct timer_list service_timer;
+	struct work_struct service_task;
+
 	/* structs defined in txgbe_type.h */
 	struct txgbe_hw hw;
 	u16 msg_enable;
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 1c00ecbc1c6a..cb86c001baa6 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -35,6 +35,8 @@ static const struct pci_device_id txgbe_pci_tbl[] = {
 
 #define DEFAULT_DEBUG_LEVEL_SHIFT 3
 
+static struct workqueue_struct *txgbe_wq;
+
 static void txgbe_check_minimum_link(struct txgbe_adapter *adapter)
 {
 	struct pci_dev *pdev;
@@ -73,6 +75,50 @@ static int txgbe_enumerate_functions(struct txgbe_adapter *adapter)
 	return physfns;
 }
 
+static void txgbe_service_event_schedule(struct txgbe_adapter *adapter)
+{
+	if (!test_bit(__TXGBE_DOWN, &adapter->state) &&
+	    !test_bit(__TXGBE_REMOVING, &adapter->state) &&
+	    !test_and_set_bit(__TXGBE_SERVICE_SCHED, &adapter->state))
+		queue_work(txgbe_wq, &adapter->service_task);
+}
+
+static void txgbe_service_event_complete(struct txgbe_adapter *adapter)
+{
+	if (WARN_ON(!test_bit(__TXGBE_SERVICE_SCHED, &adapter->state)))
+		return;
+
+	/* flush memory to make sure state is correct before next watchdog */
+	smp_mb__before_atomic();
+	clear_bit(__TXGBE_SERVICE_SCHED, &adapter->state);
+}
+
+static void txgbe_service_timer(struct timer_list *t)
+{
+	struct txgbe_adapter *adapter = from_timer(adapter, t, service_timer);
+	unsigned long next_event_offset;
+
+	next_event_offset = HZ * 2;
+
+	/* Reset the timer */
+	mod_timer(&adapter->service_timer, next_event_offset + jiffies);
+
+	txgbe_service_event_schedule(adapter);
+}
+
+/**
+ * txgbe_service_task - manages and runs subtasks
+ * @work: pointer to work_struct containing our data
+ **/
+static void txgbe_service_task(struct work_struct *work)
+{
+	struct txgbe_adapter *adapter = container_of(work,
+						     struct txgbe_adapter,
+						     service_task);
+
+	txgbe_service_event_complete(adapter);
+}
+
 static void txgbe_sync_mac_table(struct txgbe_adapter *adapter)
 {
 	struct txgbe_hw *hw = &adapter->hw;
@@ -190,6 +236,10 @@ static void txgbe_disable_device(struct txgbe_adapter *adapter)
 	struct net_device *netdev = adapter->netdev;
 	struct wx_hw *wxhw = &adapter->hw.wxhw;
 
+	/* signal that we are down to the interrupt handler */
+	if (test_and_set_bit(__TXGBE_DOWN, &adapter->state))
+		return; /* do nothing if already down */
+
 	wx_disable_pcie_master(wxhw);
 	/* disable receives */
 	wx_disable_rx(wxhw);
@@ -197,6 +247,8 @@ static void txgbe_disable_device(struct txgbe_adapter *adapter)
 	netif_carrier_off(netdev);
 	netif_tx_disable(netdev);
 
+	del_timer_sync(&adapter->service_timer);
+
 	if (wxhw->bus.func < 2)
 		wr32m(wxhw, TXGBE_MIS_PRB_CTL, TXGBE_MIS_PRB_CTL_LAN_UP(wxhw->bus.func), 0);
 	else
@@ -266,6 +318,8 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
 		return -ENOMEM;
 	}
 
+	set_bit(__TXGBE_DOWN, &adapter->state);
+
 	return 0;
 }
 
@@ -336,7 +390,8 @@ static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 
 	wx_control_hw(wxhw, false);
 
-	pci_disable_device(pdev);
+	if (!test_and_set_bit(__TXGBE_DISABLED, &adapter->state))
+		pci_disable_device(pdev);
 }
 
 static void txgbe_shutdown(struct pci_dev *pdev)
@@ -410,6 +465,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	struct txgbe_hw *hw = NULL;
 	struct wx_hw *wxhw = NULL;
 	struct net_device *netdev;
+	bool disable_dev = false;
 	int err, expected_gts;
 
 	u16 eeprom_verh = 0, eeprom_verl = 0, offset = 0;
@@ -468,6 +524,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	}
 
 	netdev->netdev_ops = &txgbe_netdev_ops;
+	netdev->watchdog_timeo = 5 * HZ;
 
 	/* setup the private structure */
 	err = txgbe_sw_init(adapter);
@@ -518,6 +575,11 @@ static int txgbe_probe(struct pci_dev *pdev,
 	eth_hw_addr_set(netdev, wxhw->mac.perm_addr);
 	txgbe_mac_set_default_filter(adapter, wxhw->mac.perm_addr);
 
+	timer_setup(&adapter->service_timer, txgbe_service_timer, 0);
+	INIT_WORK(&adapter->service_task, txgbe_service_task);
+	set_bit(__TXGBE_SERVICE_INITED, &adapter->state);
+	clear_bit(__TXGBE_SERVICE_SCHED, &adapter->state);
+
 	/* Save off EEPROM version number and Option Rom version which
 	 * together make a unique identify for the eeprom
 	 */
@@ -599,11 +661,13 @@ static int txgbe_probe(struct pci_dev *pdev,
 err_free_mac_table:
 	kfree(adapter->mac_table);
 err_pci_release_regions:
+	disable_dev = !test_and_set_bit(__TXGBE_DISABLED, &adapter->state);
 	pci_disable_pcie_error_reporting(pdev);
 	pci_release_selected_regions(pdev,
 				     pci_select_bars(pdev, IORESOURCE_MEM));
 err_pci_disable_dev:
-	pci_disable_device(pdev);
+	if (!adapter || disable_dev)
+		pci_disable_device(pdev);
 	return err;
 }
 
@@ -620,18 +684,25 @@ static void txgbe_remove(struct pci_dev *pdev)
 {
 	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
 	struct net_device *netdev;
+	bool disable_dev;
 
 	netdev = adapter->netdev;
+
+	set_bit(__TXGBE_REMOVING, &adapter->state);
+	cancel_work_sync(&adapter->service_task);
+
 	unregister_netdev(netdev);
 
 	pci_release_selected_regions(pdev,
 				     pci_select_bars(pdev, IORESOURCE_MEM));
 
 	kfree(adapter->mac_table);
+	disable_dev = !test_and_set_bit(__TXGBE_DISABLED, &adapter->state);
 
 	pci_disable_pcie_error_reporting(pdev);
 
-	pci_disable_device(pdev);
+	if (disable_dev)
+		pci_disable_device(pdev);
 }
 
 static struct pci_driver txgbe_driver = {
@@ -642,7 +713,41 @@ static struct pci_driver txgbe_driver = {
 	.shutdown = txgbe_shutdown,
 };
 
-module_pci_driver(txgbe_driver);
+/**
+ * txgbe_init_module - Driver Registration Routine
+ *
+ * txgbe_init_module is the first routine called when the driver is
+ * loaded. All it does is register with the PCI subsystem.
+ **/
+static int __init txgbe_init_module(void)
+{
+	int ret;
+
+	txgbe_wq = create_singlethread_workqueue(txgbe_driver_name);
+	if (!txgbe_wq) {
+		pr_err("%s: Failed to create workqueue\n", txgbe_driver_name);
+		return -ENOMEM;
+	}
+
+	ret = pci_register_driver(&txgbe_driver);
+	return ret;
+}
+
+module_init(txgbe_init_module);
+
+/**
+ * txgbe_exit_module - Driver Exit Cleanup Routine
+ *
+ * txgbe_exit_module is called just before the driver is removed
+ * from memory.
+ **/
+static void __exit txgbe_exit_module(void)
+{
+	pci_unregister_driver(&txgbe_driver);
+	destroy_workqueue(txgbe_wq);
+}
+
+module_exit(txgbe_exit_module);
 
 MODULE_DEVICE_TABLE(pci, txgbe_pci_tbl);
 MODULE_AUTHOR("Beijing WangXun Technology Co., Ltd, <software@trustnetic.com>");
-- 
2.38.1

