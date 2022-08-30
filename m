Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715095A5C8E
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbiH3HHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbiH3HHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:07:13 -0400
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECF8C57AF
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:06:45 -0700 (PDT)
X-QQ-mid: bizesmtp76t1661843135tbmrom33
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 30 Aug 2022 15:05:35 +0800 (CST)
X-QQ-SSF: 01400000000000G0T000B00A0000000
X-QQ-FEAT: 5x8Sgf4S6/je300/8juTTTPHCdhbQQfcGckQ496R+8yHVuN7uRHFPD6/L3nMm
        xcZPObrwvLXlbg4mceRMT7LWxdt6vPra8XSgVr+ty4gIP7h5+WRGqbvKmdz8tB8di8Sv43r
        PR0m375WZ65ZBT6YxBMM5Nu1GvyDzK/gQc9yW7jufUOX4hLdDHKg5xE5Q2f6u4Wbi8fZmKZ
        A0YMejx/GnjbYla6ZEgjO4LOK13rbLVf8f6ekvi1k5o4NV3W8OVxOctTpex+dgeoeX4lZg0
        AMKTmTBW0kgmu4E4/15a5NfX0hMrCUaZ+Ej+cjbG3z6l/9NqYmhtDi4GYVUjRiw5LMC3HpY
        EhkxXmvgpe4U+cCzou9jSiqFdqz59ky76c/dxDyU9sDikvhA1yq/Mh1956ZBsrgmmHyLthc
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v2 06/16] net: txgbe: Initialize service task
Date:   Tue, 30 Aug 2022 15:04:44 +0800
Message-Id: <20220830070454.146211-7-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220830070454.146211-1-jiawenwu@trustnetic.com>
References: <20220830070454.146211-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
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
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 113 +++++++++++++++++-
 2 files changed, 126 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index cd182fe09712..d45aa8eea9dd 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -35,6 +35,8 @@ struct txgbe_adapter {
 	struct net_device *netdev;
 	struct pci_dev *pdev;
 
+	unsigned long state;
+
 	/* Tx fast path data */
 	int num_tx_queues;
 
@@ -45,6 +47,9 @@ struct txgbe_adapter {
 	struct txgbe_hw hw;
 	u16 msg_enable;
 
+	struct timer_list service_timer;
+	struct work_struct service_task;
+
 	char eeprom_id[32];
 	bool netdev_registered;
 
@@ -52,7 +57,19 @@ struct txgbe_adapter {
 
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
index 25764d76dea6..52310b8c8455 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -33,6 +33,8 @@ static const struct pci_device_id txgbe_pci_tbl[] = {
 
 #define DEFAULT_DEBUG_LEVEL_SHIFT 3
 
+static struct workqueue_struct *txgbe_wq;
+
 static bool txgbe_is_sfp(struct txgbe_hw *hw);
 
 static void txgbe_check_minimum_link(struct txgbe_adapter *adapter)
@@ -73,6 +75,24 @@ static int txgbe_enumerate_functions(struct txgbe_adapter *adapter)
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
 static void txgbe_release_hw_control(struct txgbe_adapter *adapter)
 {
 	/* Let firmware take over control of hw */
@@ -215,6 +235,10 @@ void txgbe_disable_device(struct txgbe_adapter *adapter)
 	struct txgbe_hw *hw = &adapter->hw;
 	u32 i;
 
+	/* signal that we are down to the interrupt handler */
+	if (test_and_set_bit(__TXGBE_DOWN, &adapter->state))
+		return; /* do nothing if already down */
+
 	txgbe_disable_pcie_master(hw);
 	/* disable receives */
 	hw->mac.ops.disable_rx(hw);
@@ -222,6 +246,8 @@ void txgbe_disable_device(struct txgbe_adapter *adapter)
 	netif_carrier_off(netdev);
 	netif_tx_disable(netdev);
 
+	del_timer_sync(&adapter->service_timer);
+
 	if (hw->bus.lan_id == 0)
 		wr32m(hw, TXGBE_MIS_PRB_CTL, TXGBE_MIS_PRB_CTL_LAN0_UP, 0);
 	else if (hw->bus.lan_id == 1)
@@ -297,6 +323,8 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
 		return -ENOMEM;
 	}
 
+	set_bit(__TXGBE_DOWN, &adapter->state);
+
 	return 0;
 }
 
@@ -368,7 +396,8 @@ static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 
 	txgbe_release_hw_control(adapter);
 
-	pci_disable_device(pdev);
+	if (!test_and_set_bit(__TXGBE_DISABLED, &adapter->state))
+		pci_disable_device(pdev);
 }
 
 static void txgbe_shutdown(struct pci_dev *pdev)
@@ -383,6 +412,32 @@ static void txgbe_shutdown(struct pci_dev *pdev)
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
+
+	txgbe_service_event_complete(adapter);
+}
+
 /**
  * txgbe_set_mac - Change the Ethernet Address of the NIC
  * @netdev: network interface device structure
@@ -483,6 +538,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	struct txgbe_adapter *adapter = NULL;
 	struct txgbe_hw *hw = NULL;
 	struct net_device *netdev;
+	bool disable_dev = false;
 	int err, expected_gts;
 
 	u16 eeprom_verh = 0, eeprom_verl = 0, offset = 0;
@@ -541,6 +597,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	hw->hw_addr = adapter->io_addr;
 
 	txgbe_assign_netdev_ops(netdev);
+	netdev->watchdog_timeo = 5 * HZ;
 	strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
 
 	/* setup the private structure */
@@ -595,6 +652,12 @@ static int txgbe_probe(struct pci_dev *pdev,
 
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
@@ -693,11 +756,13 @@ static int txgbe_probe(struct pci_dev *pdev,
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
 
@@ -714,8 +779,11 @@ static void txgbe_remove(struct pci_dev *pdev)
 {
 	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
 	struct net_device *netdev;
+	bool disable_dev;
 
 	netdev = adapter->netdev;
+	set_bit(__TXGBE_REMOVING, &adapter->state);
+	cancel_work_sync(&adapter->service_task);
 
 	/* remove the added san mac */
 	txgbe_del_sanmac_netdev(netdev);
@@ -731,10 +799,12 @@ static void txgbe_remove(struct pci_dev *pdev)
 				     pci_select_bars(pdev, IORESOURCE_MEM));
 
 	kfree(adapter->mac_table);
+	disable_dev = !test_and_set_bit(__TXGBE_DISABLED, &adapter->state);
 
 	pci_disable_pcie_error_reporting(pdev);
 
-	pci_disable_device(pdev);
+	if (disable_dev)
+		pci_disable_device(pdev);
 }
 
 static struct pci_driver txgbe_driver = {
@@ -745,7 +815,42 @@ static struct pci_driver txgbe_driver = {
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

