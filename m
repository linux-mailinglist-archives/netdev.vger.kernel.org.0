Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BABCA58E91F
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 10:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbiHJI4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 04:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiHJI4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 04:56:44 -0400
Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4716E8AC
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 01:56:38 -0700 (PDT)
X-QQ-mid: bizesmtp82t1660121792t2wpab88
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 10 Aug 2022 16:56:32 +0800 (CST)
X-QQ-SSF: 01400000000000G0S000B00A0000000
X-QQ-FEAT: C2zsvWT0ctX+dWLk1fGqTd1y5fknAJiHmeuxtGxOfIk+LDs4SqL4zQ2rGZyj3
        EpRgQ5l/jSTEayQZBwT7YydMXeoE0x0e2Zt/VJkLyZey0tn6EXgTUmA1hDpi0O8c5o00ROt
        ryYElxZldzWUidPWUs+2mSjbWQWSwA5Gt4WIqeqpYXUgfUInwgtkxRaWzvyloZ9Lk55u3BR
        VYZg0k0xCHVebOxx0kROwNXL9oFo0SfGX1CcWSV0DnedQo7jrslXBXWBlRbgNMxtdH5stpp
        6+RDGRzyKZomB3jUpgdzlBVInOMoljMWIUylY88HVfNudygoVi50V7viGz8F4MHPjSi42yn
        NbUTXDL/VWgM7dkYtFAgTTwtz1ENqnjO8+/vDMxX1uRmAXS/yAg6m1mb/wvYKfUjppSuEHh
        7I8QOkZSi0w=
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [RFC PATCH net-next 06/16] net: txgbe: Initialize service task
Date:   Wed, 10 Aug 2022 16:55:22 +0800
Message-Id: <20220810085532.246613-7-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220810085532.246613-1-jiawenwu@trustnetic.com>
References: <20220810085532.246613-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Setup work queue, and initialize service task to process the following
tasks.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  17 +++
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 124 +++++++++++++++++-
 2 files changed, 137 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index d0ea817e2f42..397241df4078 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -36,6 +36,8 @@ struct txgbe_adapter {
 	struct net_device *netdev;
 	struct pci_dev *pdev;
 
+	unsigned long state;
+
 	/* Tx fast path data */
 	int num_tx_queues;
 
@@ -46,6 +48,9 @@ struct txgbe_adapter {
 	struct txgbe_hw hw;
 	u16 msg_enable;
 
+	struct timer_list service_timer;
+	struct work_struct service_task;
+
 	char eeprom_id[32];
 	bool netdev_registered;
 
@@ -53,7 +58,19 @@ struct txgbe_adapter {
 
 };
 
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
 /* needed by txgbe_main.c */
+void txgbe_service_event_schedule(struct txgbe_adapter *adapter);
 void txgbe_assign_netdev_ops(struct net_device *netdev);
 
 int txgbe_open(struct net_device *netdev);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index da5193c871b3..30bac8a049df 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -32,6 +32,8 @@ static const struct pci_device_id txgbe_pci_tbl[] = {
 
 #define DEFAULT_DEBUG_LEVEL_SHIFT 3
 
+static struct workqueue_struct *txgbe_wq;
+
 static bool txgbe_is_sfp(struct txgbe_hw *hw);
 
 static void txgbe_check_minimum_link(struct txgbe_adapter *adapter)
@@ -81,6 +83,24 @@ static inline int txgbe_enumerate_functions(struct txgbe_adapter *adapter)
 	return physfns;
 }
 
+void txgbe_service_event_schedule(struct txgbe_adapter *adapter)
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
 static void txgbe_remove_adapter(struct txgbe_hw *hw)
 {
 	struct txgbe_adapter *adapter = container_of(hw, struct txgbe_adapter, hw);
@@ -89,6 +109,8 @@ static void txgbe_remove_adapter(struct txgbe_hw *hw)
 		return;
 	hw->hw_addr = NULL;
 	dev_info(&adapter->pdev->dev, "Adapter removed\n");
+	if (test_bit(__TXGBE_SERVICE_INITED, &adapter->state))
+		txgbe_service_event_schedule(adapter);
 }
 
 static bool txgbe_check_cfg_remove(struct txgbe_hw *hw, struct pci_dev *pdev)
@@ -221,6 +243,10 @@ void txgbe_disable_device(struct txgbe_adapter *adapter)
 	struct txgbe_hw *hw = &adapter->hw;
 	u32 i;
 
+	/* signal that we are down to the interrupt handler */
+	if (test_and_set_bit(__TXGBE_DOWN, &adapter->state))
+		return; /* do nothing if already down */
+
 	txgbe_disable_pcie_master(hw);
 	/* disable receives */
 	TCALL(hw, mac.ops.disable_rx);
@@ -228,6 +254,8 @@ void txgbe_disable_device(struct txgbe_adapter *adapter)
 	netif_carrier_off(netdev);
 	netif_tx_disable(netdev);
 
+	del_timer_sync(&adapter->service_timer);
+
 	if (hw->bus.lan_id == 0)
 		wr32m(hw, TXGBE_MIS_PRB_CTL, TXGBE_MIS_PRB_CTL_LAN0_UP, 0);
 	else if (hw->bus.lan_id == 1)
@@ -320,6 +348,8 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
 		return err;
 	}
 
+	set_bit(__TXGBE_DOWN, &adapter->state);
+
 	return 0;
 }
 
@@ -391,7 +421,8 @@ static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 
 	txgbe_release_hw_control(adapter);
 
-	pci_disable_device(pdev);
+	if (!test_and_set_bit(__TXGBE_DISABLED, &adapter->state))
+		pci_disable_device(pdev);
 }
 
 static void txgbe_shutdown(struct pci_dev *pdev)
@@ -406,6 +437,41 @@ static void txgbe_shutdown(struct pci_dev *pdev)
 	}
 }
 
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
+	if (TXGBE_REMOVED(adapter->hw.hw_addr)) {
+		if (!test_bit(__TXGBE_DOWN, &adapter->state)) {
+			rtnl_lock();
+			txgbe_down(adapter);
+			rtnl_unlock();
+		}
+		txgbe_service_event_complete(adapter);
+		return;
+	}
+
+	txgbe_service_event_complete(adapter);
+}
+
 /**
  * txgbe_add_sanmac_netdev - Add the SAN MAC address to the corresponding
  * netdev->dev_addr_list
@@ -479,6 +545,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	struct txgbe_adapter *adapter = NULL;
 	struct txgbe_hw *hw = NULL;
 	struct net_device *netdev;
+	bool disable_dev = false;
 	int err, expected_gts;
 
 	u16 eeprom_verh = 0, eeprom_verl = 0, offset = 0;
@@ -537,6 +604,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	hw->hw_addr = adapter->io_addr;
 
 	txgbe_assign_netdev_ops(netdev);
+	netdev->watchdog_timeo = 5 * HZ;
 	strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
 
 	/* setup the private structure */
@@ -588,6 +656,12 @@ static int txgbe_probe(struct pci_dev *pdev,
 
 	txgbe_mac_set_default_filter(adapter, hw->mac.perm_addr);
 
+	timer_setup(&adapter->service_timer, txgbe_service_timer, 0);
+
+	INIT_WORK(&adapter->service_task, txgbe_service_task);
+	set_bit(__TXGBE_SERVICE_INITED, &adapter->state);
+	clear_bit(__TXGBE_SERVICE_SCHED, &adapter->state);
+
 	/* Save off EEPROM version number and Option Rom version which
 	 * together make a unique identify for the eeprom
 	 */
@@ -689,11 +763,13 @@ static int txgbe_probe(struct pci_dev *pdev,
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
 
@@ -710,8 +786,11 @@ static void txgbe_remove(struct pci_dev *pdev)
 {
 	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
 	struct net_device *netdev;
+	bool disable_dev;
 
 	netdev = adapter->netdev;
+	set_bit(__TXGBE_REMOVING, &adapter->state);
+	cancel_work_sync(&adapter->service_task);
 
 	/* remove the added san mac */
 	txgbe_del_sanmac_netdev(netdev);
@@ -727,10 +806,12 @@ static void txgbe_remove(struct pci_dev *pdev)
 				     pci_select_bars(pdev, IORESOURCE_MEM));
 
 	kfree(adapter->mac_table);
+	disable_dev = !test_and_set_bit(__TXGBE_DISABLED, &adapter->state);
 
 	pci_disable_pcie_error_reporting(pdev);
 
-	pci_disable_device(pdev);
+	if (disable_dev)
+		pci_disable_device(pdev);
 }
 
 u16 txgbe_read_pci_cfg_word(struct txgbe_hw *hw, u32 reg)
@@ -755,7 +836,42 @@ static struct pci_driver txgbe_driver = {
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
+	if (txgbe_wq)
+		destroy_workqueue(txgbe_wq);
+}
+
+module_exit(txgbe_exit_module);
 
 MODULE_DEVICE_TABLE(pci, txgbe_pci_tbl);
 MODULE_AUTHOR("Beijing WangXun Technology Co., Ltd, <software@trustnetic.com>");
-- 
2.27.0

