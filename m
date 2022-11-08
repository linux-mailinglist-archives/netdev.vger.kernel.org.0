Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEDD620E8A
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 12:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbiKHLUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 06:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234070AbiKHLUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 06:20:04 -0500
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29CE29CA1
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 03:19:51 -0800 (PST)
X-QQ-mid: bizesmtp85t1667906384t3xpw7ku
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 08 Nov 2022 19:19:43 +0800 (CST)
X-QQ-SSF: 01400000000000M0M000000A0000000
X-QQ-FEAT: ao4JQgu0M3+OPY+iUeBYxgJ2gHPRH04rtB3AUoskEblB/z18dqlySOJ5hAy0n
        knhO9oNglxfWfL4KNKCJKM4i7PkqA4EY0kGQel46XSwDQ6+3MsRUl0jfjMhI/QcfzutbJrQ
        cwyzlara9jEVyQLw3WgtyCfK3V1DGZimO3fZIIQwzEgLZNXvd9e2DiCVlFmVkrPUbmaaN0i
        iUv88A8So6H7a85Xu7h6bQ3l/chOHMlysWegFbIw8UDViQpMxhTt6y2vw6DsyeSsKHPgoF2
        PI7vmr59sCVfVtBD3LdTI+Psa3xoxXOO819pocjk9kCgfNdKF61DeslywyopBMyl/maB3EK
        Z9pFJWljmldIRFY+PlYFQLyIcEvLi+bWW7h2k/5ZFKoa0rLoViMZrRdD6u3p3c+hHpx6+Nk
        SDs67fcdNPz7EHcy1mXS5w==
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next 5/5] net: ngbe: Initialize service task
Date:   Tue,  8 Nov 2022 19:19:07 +0800
Message-Id: <20221108111907.48599-6-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108111907.48599-1-mengyuanlou@net-swift.com>
References: <20221108111907.48599-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_PASS,T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initialize ngbe_wq, building the framework for task checking.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/ngbe/ngbe.h      |  21 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   |   5 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 380 +++++++++++++++++-
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |   1 +
 4 files changed, 401 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe.h b/drivers/net/ethernet/wangxun/ngbe/ngbe.h
index ac67c0403592..17b241264c2d 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe.h
@@ -36,6 +36,17 @@ struct ngbe_mac_addr {
 	u64 pools;
 };
 
+enum ngbe_adapter_state {
+	NGBE_TESTING,
+	NGBE_DOWN,
+	NGBE_REMOVING,
+	NGBE_RESETTING,
+	NGBE_NEEDS_RESTART,
+	NGBE_SERVICE_SCHED,
+	NGBE_SERVICE_DIS,
+	NGBE_STATE_NBITS		/* must be last */
+};
+
 /* board specific private data structure */
 struct ngbe_adapter {
 	u8 __iomem *io_addr;    /* Mainly for iounmap use */
@@ -48,7 +59,17 @@ struct ngbe_adapter {
 	struct ngbe_mac_addr *mac_table;
 	u16 msg_enable;
 
+	DECLARE_BITMAP(state, NGBE_STATE_NBITS);
 	DECLARE_BITMAP(flags, NGBE_FLAGS_NBITS);
+	unsigned long serv_tmr_period;
+	unsigned long serv_tmr_prev;
+	struct timer_list serv_tmr;
+	struct work_struct serv_task;
+
+	unsigned long link_check_timeout;
+
+	u32 link_speed;
+	bool link_up;
 
 	/* Tx fast path data */
 	int num_tx_queues;
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
index 274d54832579..915b27b25c1c 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
@@ -8,6 +8,7 @@
 #include "../libwx/wx_type.h"
 #include "../libwx/wx_hw.h"
 #include "ngbe_type.h"
+#include "ngbe_phy.h"
 #include "ngbe_hw.h"
 #include "ngbe.h"
 
@@ -106,6 +107,10 @@ int ngbe_reset_hw(struct ngbe_hw *hw)
 	wr32(wxhw, WX_MIS_RST, reset | rd32(wxhw, WX_MIS_RST));
 	ngbe_reset_misc(hw);
 
+	status = ngbe_phy_init(hw);
+	if (status)
+		return status;
+
 	/* Store the permanent mac address */
 	wx_get_mac_addr(wxhw, wxhw->mac.perm_addr);
 
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index ebf3fcdc4719..83cc61eb3be2 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -9,14 +9,18 @@
 #include <linux/aer.h>
 #include <linux/etherdevice.h>
 #include <net/ip.h>
+#include <linux/ethtool.h>
 
 #include "../libwx/wx_type.h"
 #include "../libwx/wx_hw.h"
 #include "ngbe_type.h"
+#include "ngbe_phy.h"
 #include "ngbe_hw.h"
 #include "ngbe.h"
 char ngbe_driver_name[] = "ngbe";
 
+static struct workqueue_struct *ngbe_wq;
+
 /* ngbe_pci_tbl - PCI Device ID Table
  *
  * { Vendor ID, Device ID, SubVendor ID, SubDevice ID,
@@ -39,6 +43,81 @@ static const struct pci_device_id ngbe_pci_tbl[] = {
 	{ .device = 0 }
 };
 
+/**
+ * ngbe_service_event_schedule - schedule the service task to wake up
+ * @adapter: board private structure
+ *
+ * If not already scheduled, this puts the task into the work queue.
+ */
+static void ngbe_service_event_schedule(struct ngbe_adapter *adapter)
+{
+	if (!test_bit(NGBE_SERVICE_DIS, adapter->state) &&
+	    !test_and_set_bit(NGBE_SERVICE_SCHED, adapter->state) &&
+	    !test_bit(NGBE_NEEDS_RESTART, adapter->state))
+		queue_work(ngbe_wq, &adapter->serv_task);
+}
+
+static void ngbe_service_event_complete(struct ngbe_adapter *adapter)
+{
+	WARN_ON(!test_bit(NGBE_SERVICE_SCHED, adapter->state));
+
+	/* flush memory to make sure state is correct before next watchdog */
+	smp_mb__before_atomic();
+	clear_bit(NGBE_SERVICE_SCHED, adapter->state);
+}
+
+/**
+ * ngbe_service_event_stop - stop service task and cancel works
+ * @adapter: board private structure
+ */
+static int ngbe_service_event_stop(struct ngbe_adapter *adapter)
+{
+	int ret;
+
+	ret = test_and_set_bit(NGBE_SERVICE_DIS, adapter->state);
+	if (adapter->serv_tmr.function)
+		del_timer_sync(&adapter->serv_tmr);
+	if (adapter->serv_task.func)
+		cancel_work_sync(&adapter->serv_task);
+	clear_bit(NGBE_SERVICE_SCHED, adapter->state);
+
+	return ret;
+}
+
+/**
+ * ngbe_service_timer - timer callback to schedule service task
+ * @t: pointer to timer_list
+ */
+static void ngbe_service_timer(struct timer_list *t)
+{
+	struct ngbe_adapter *adapter =
+			from_timer(adapter, t, serv_tmr);
+
+	mod_timer(&adapter->serv_tmr, round_jiffies(adapter->serv_tmr_period + jiffies));
+	ngbe_service_event_schedule(adapter);
+}
+
+static void ngbe_sync_mac_table(struct ngbe_adapter *adapter)
+{
+	struct ngbe_hw *hw = &adapter->hw;
+	struct wx_hw *wxhw = &hw->wxhw;
+	int i;
+
+	for (i = 0; i < wxhw->mac.num_rar_entries; i++) {
+		if (adapter->mac_table[i].state & NGBE_MAC_STATE_MODIFIED) {
+			if (adapter->mac_table[i].state & NGBE_MAC_STATE_IN_USE) {
+				wx_set_rar(wxhw, i,
+					   adapter->mac_table[i].addr,
+					   adapter->mac_table[i].pools,
+					   WX_PSR_MAC_SWC_AD_H_AV);
+			} else {
+				wx_clear_rar(wxhw, i);
+			}
+			adapter->mac_table[i].state &= ~(NGBE_MAC_STATE_MODIFIED);
+		}
+	}
+}
+
 static void ngbe_mac_set_default_filter(struct ngbe_adapter *adapter, u8 *addr)
 {
 	struct ngbe_hw *hw = &adapter->hw;
@@ -52,6 +131,161 @@ static void ngbe_mac_set_default_filter(struct ngbe_adapter *adapter, u8 *addr)
 		   WX_PSR_MAC_SWC_AD_H_AV);
 }
 
+static void ngbe_flush_sw_mac_table(struct ngbe_adapter *adapter)
+{
+	struct ngbe_hw *hw = &adapter->hw;
+	struct wx_hw *wxhw = &hw->wxhw;
+	u32 i;
+
+	for (i = 0; i < wxhw->mac.num_rar_entries; i++) {
+		adapter->mac_table[i].state |= NGBE_MAC_STATE_MODIFIED;
+		adapter->mac_table[i].state &= ~NGBE_MAC_STATE_IN_USE;
+		memset(adapter->mac_table[i].addr, 0, ETH_ALEN);
+		adapter->mac_table[i].pools = 0;
+	}
+	ngbe_sync_mac_table(adapter);
+}
+
+/**
+ * ngbe_watchdog_update_link_status - update the link status
+ * @adapter: pointer to the device adapter structure
+ **/
+static void ngbe_watchdog_update_link_status(struct ngbe_adapter *adapter)
+{
+	u32 link_speed = adapter->link_speed;
+	struct ngbe_hw *hw = &adapter->hw;
+	bool link_up = adapter->link_up;
+	struct wx_hw *wxhw = &hw->wxhw;
+	u32 lan_speed = 0;
+	u32 reg;
+
+	if (!test_bit(NGBE_FLAG_NEED_LINK_UPDATE, adapter->flags))
+		return;
+
+	link_speed = SPEED_1000;
+	link_up = true;
+	ngbe_phy_check_link(hw, &link_speed, &link_up, false);
+
+	if (link_up || time_after(jiffies, (adapter->link_check_timeout +
+					    4 * HZ)))
+		set_bit(NGBE_FLAG_NEED_LINK_UPDATE, adapter->flags);
+
+	adapter->link_speed = link_speed;
+	switch (link_speed) {
+	case SPEED_1000:
+		lan_speed = 2;
+		break;
+	case SPEED_100:
+		lan_speed = 1;
+		break;
+	case SPEED_10:
+		lan_speed = 0;
+		break;
+	default:
+		break;
+	}
+	wr32m(wxhw, NGBE_CFG_LAN_SPEED, 0x3, lan_speed);
+
+	adapter->link_up = link_up;
+	adapter->link_speed = link_speed;
+	if (link_up) {
+		if (link_speed & (SPEED_1000 | SPEED_100 | SPEED_10)) {
+			reg = rd32(wxhw, WX_MAC_TX_CFG);
+			reg &= ~WX_MAC_TX_CFG_SPEED_MASK;
+			reg |= WX_MAC_TX_CFG_SPEED_1G | WX_MAC_TX_CFG_TE;
+			wr32(wxhw, WX_MAC_TX_CFG, reg);
+		}
+		/* Re configure MAC RX */
+		reg = rd32(wxhw, WX_MAC_RX_CFG);
+		wr32(wxhw, WX_MAC_RX_CFG, reg);
+		wr32(wxhw, WX_MAC_PKT_FLT, WX_MAC_PKT_FLT_PR);
+		reg = rd32(wxhw, WX_MAC_WDG_TIMEOUT);
+		wr32(wxhw, WX_MAC_WDG_TIMEOUT, reg);
+	}
+}
+
+static void ngbe_watchdog_link_is_up(struct ngbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	const char *speed_str;
+
+	/* only continue if link was previously down */
+	if (netif_carrier_ok(netdev))
+		return;
+
+	switch (adapter->link_speed) {
+	case SPEED_1000:
+		speed_str = "1 Gbps";
+		break;
+	case SPEED_100:
+		speed_str = "100 Mbps";
+		break;
+	case SPEED_10:
+		speed_str = "10 Mbps";
+		break;
+	default:
+		speed_str = "unknown speed";
+		break;
+	}
+
+	netif_info(adapter, drv, netdev,
+		   "NIC Link is Up %s\n", speed_str);
+
+	netif_carrier_on(netdev);
+}
+
+static void ngbe_watchdog_link_is_down(struct ngbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+
+	adapter->link_up = false;
+	adapter->link_speed = 0;
+
+	/* only continue if link was up previously */
+	if (!netif_carrier_ok(netdev))
+		return;
+
+	netif_info(adapter, drv, netdev, "NIC Link is Down\n");
+	netif_carrier_off(netdev);
+}
+
+/**
+ * ngbe_watchdog_subtask - check and bring link up
+ * @adapter: pointer to the device adapter structure
+ **/
+static void ngbe_watchdog_subtask(struct ngbe_adapter *adapter)
+{
+	/* if interface is down do nothing */
+	if (test_bit(NGBE_DOWN, adapter->state) ||
+	    test_bit(NGBE_REMOVING, adapter->state) ||
+	    test_bit(NGBE_RESETTING, adapter->state))
+		return;
+
+	ngbe_watchdog_update_link_status(adapter);
+
+	if (adapter->link_up)
+		ngbe_watchdog_link_is_up(adapter);
+	else
+		ngbe_watchdog_link_is_down(adapter);
+}
+
+/**
+ * ngbe_service_task - manages and runs subtasks
+ * @work: pointer to work_struct containing our data
+ **/
+static void ngbe_service_task(struct work_struct *work)
+{
+	struct ngbe_adapter *adapter = container_of(work,
+						    struct ngbe_adapter,
+						    serv_task);
+
+	if (test_bit(NGBE_DOWN, adapter->state))
+		return;
+
+	ngbe_watchdog_subtask(adapter);
+	ngbe_service_event_complete(adapter);
+}
+
 /**
  *  ngbe_init_type_code - Initialize the shared code
  *  @hw: pointer to hardware structure
@@ -221,12 +455,96 @@ static void ngbe_oem_conf_in_rom(struct ngbe_hw *hw)
 			    &hw->phy.gphy_efuse[1]);
 }
 
+static void ngbe_reset(struct ngbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	struct ngbe_hw *hw = &adapter->hw;
+	u8 old_addr[ETH_ALEN];
+	int err;
+
+	err = ngbe_reset_hw(hw);
+	if (err)
+		dev_err(&adapter->pdev->dev, "Hardware Error: %d\n", err);
+	/* do not flush user set addresses */
+	memcpy(old_addr, &adapter->mac_table[0].addr, netdev->addr_len);
+	ngbe_flush_sw_mac_table(adapter);
+	ngbe_mac_set_default_filter(adapter, old_addr);
+}
+
+static void ngbe_disable_device(struct ngbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	struct ngbe_hw *hw = &adapter->hw;
+
+	/* signal that we are down to the interrupt handler */
+	if (test_and_set_bit(NGBE_DOWN, adapter->state))
+		return; /* do nothing if already down */
+
+	wx_disable_pcie_master(&hw->wxhw);
+	/* disable receives */
+	wx_disable_rx(&hw->wxhw);
+
+	/* call carrier off first to avoid false dev_watchdog timeouts */
+	netif_carrier_off(netdev);
+	netif_tx_disable(netdev);
+
+	clear_bit(NGBE_FLAG_NEED_LINK_UPDATE, adapter->flags);
+
+	del_timer_sync(&adapter->serv_tmr);
+}
+
 static void ngbe_down(struct ngbe_adapter *adapter)
 {
-	netif_carrier_off(adapter->netdev);
-	netif_tx_disable(adapter->netdev);
+	ngbe_disable_device(adapter);
+
+	ngbe_reset(adapter);
 };
 
+/**
+ * ngbe_phy_setlink_config - set up non-SFP+ link
+ * @hw: pointer to private hardware struct
+ *
+ * Returns 0 on success, negative on failure
+ **/
+static int ngbe_phy_setlink_config(struct ngbe_hw *hw)
+{
+	u32 speed = 0;
+	int ret = 0;
+
+	hw->phy.autoneg = 1;
+	speed = SPEED_1000 | SPEED_100 | SPEED_10;
+
+	if (hw->wol_enabled || hw->ncsi_enabled)
+		return 0;
+
+	ret = ngbe_phy_setup_link(hw, speed, false);
+
+	return ret;
+}
+
+static void ngbe_up_complete(struct ngbe_adapter *adapter)
+{
+	struct ngbe_hw *hw = &adapter->hw;
+	int err;
+
+	wx_control_hw(&hw->wxhw, true);
+
+	/* make sure to complete pre-operations */
+	smp_mb__before_atomic();
+	clear_bit(NGBE_DOWN, adapter->state);
+
+	err = ngbe_phy_setlink_config(hw);
+	if (err)
+		dev_err(&adapter->pdev->dev, "Phy hardware Error: %d\n", err);
+
+	/* bring the link up in the watchdog, this could race with our first
+	 * link up interrupt but shouldn't be a problem
+	 */
+	set_bit(NGBE_FLAG_NEED_LINK_UPDATE, adapter->flags);
+	adapter->link_check_timeout = jiffies;
+	mod_timer(&adapter->serv_tmr, round_jiffies(jiffies + adapter->serv_tmr_period));
+}
+
 /**
  * ngbe_open - Called when a network interface is made active
  * @netdev: network interface device structure
@@ -239,10 +557,8 @@ static void ngbe_down(struct ngbe_adapter *adapter)
 static int ngbe_open(struct net_device *netdev)
 {
 	struct ngbe_adapter *adapter = netdev_priv(netdev);
-	struct ngbe_hw *hw = &adapter->hw;
-	struct wx_hw *wxhw = &hw->wxhw;
 
-	wx_control_hw(wxhw, true);
+	ngbe_up_complete(adapter);
 
 	return 0;
 }
@@ -491,6 +807,15 @@ static int ngbe_probe(struct pci_dev *pdev,
 	eth_hw_addr_set(netdev, wxhw->mac.perm_addr);
 	ngbe_mac_set_default_filter(adapter, wxhw->mac.perm_addr);
 
+	/* setup service timer and periodic service task */
+	timer_setup(&adapter->serv_tmr, ngbe_service_timer, 0);
+	adapter->serv_tmr_period = HZ;
+	INIT_WORK(&adapter->serv_task, ngbe_service_task);
+	clear_bit(NGBE_SERVICE_SCHED, adapter->state);
+	clear_bit(NGBE_SERVICE_DIS, adapter->state);
+	/* since everything is good, start the service timer */
+	mod_timer(&adapter->serv_tmr, round_jiffies(jiffies + adapter->serv_tmr_period));
+
 	err = register_netdev(netdev);
 	if (err)
 		goto err_register;
@@ -505,6 +830,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 	return 0;
 
 err_register:
+	ngbe_service_event_stop(adapter);
 	wx_control_hw(wxhw, false);
 err_free_mac_table:
 	kfree(adapter->mac_table);
@@ -531,6 +857,10 @@ static void ngbe_remove(struct pci_dev *pdev)
 	struct ngbe_adapter *adapter = pci_get_drvdata(pdev);
 	struct net_device *netdev;
 
+	set_bit(NGBE_REMOVING, adapter->state);
+	cancel_work_sync(&adapter->serv_task);
+	ngbe_service_event_stop(adapter);
+
 	netdev = adapter->netdev;
 	unregister_netdev(netdev);
 	pci_release_selected_regions(pdev,
@@ -550,7 +880,45 @@ static struct pci_driver ngbe_driver = {
 	.shutdown = ngbe_shutdown,
 };
 
-module_pci_driver(ngbe_driver);
+/**
+ * ngbe_module_init - Driver registration routine
+ *
+ * ngbe_module_init is the first routine called when the driver is
+ * loaded. All it does is register with the PCI subsystem.
+ */
+static int __init ngbe_module_init(void)
+{
+	int status;
+
+	ngbe_wq = alloc_workqueue("%s", WQ_MEM_RECLAIM, 0, KBUILD_MODNAME);
+	if (!ngbe_wq) {
+		pr_err("Failed to create workqueue\n");
+		return -ENOMEM;
+	}
+
+	status = pci_register_driver(&ngbe_driver);
+	if (status) {
+		pr_err("failed to register PCI driver, err %d\n", status);
+		destroy_workqueue(ngbe_wq);
+	}
+
+	return status;
+}
+module_init(ngbe_module_init);
+
+/**
+ * ngbe_module_exit - Driver exit cleanup routine
+ *
+ * ngbe_module_exit is called just before the driver is removed
+ * from memory.
+ */
+static void __exit ngbe_module_exit(void)
+{
+	pci_unregister_driver(&ngbe_driver);
+	destroy_workqueue(ngbe_wq);
+	pr_info("module unloaded\n");
+}
+module_exit(ngbe_module_exit);
 
 MODULE_DEVICE_TABLE(pci, ngbe_pci_tbl);
 MODULE_AUTHOR("Beijing WangXun Technology Co., Ltd, <software@net-swift.com>");
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
index f6b257e84319..672716e47042 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
@@ -83,6 +83,7 @@ enum NGBE_MSCA_CMD_value {
 #define NGBE_MSCC_BUSY				BIT(22)
 #define NGBE_MDIO_CLK(v)			((0x7 & (v)) << 19)
 
+#define NGBE_CFG_LAN_SPEED			0x14440
 /* GPIO Registers */
 #define NGBE_GPIO_DR				0x14800
 #define NGBE_GPIO_DDR				0x14804
-- 
2.38.1

