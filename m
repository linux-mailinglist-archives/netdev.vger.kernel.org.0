Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6610658E928
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 10:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbiHJI5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 04:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbiHJI5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 04:57:44 -0400
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A32868A4
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 01:57:29 -0700 (PDT)
X-QQ-mid: bizesmtp82t1660121781tckj259k
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 10 Aug 2022 16:56:21 +0800 (CST)
X-QQ-SSF: 01400000000000G0S000B00A0000000
X-QQ-FEAT: wF64VgvUy+W2V3i5IqT4wCeYRXk+0/l1VgEcOyfCU1jzdhQ8X3JSZOuVLLw7a
        +ToToRgz/nCvVSNSjFIrxL9MLyyc5OVjnOV1rbWNDIhC6ojVZ+M0gjuChng5ysouVQDYDWB
        UYrjFSy8vHPBSk4N1IvGx6Re/BVZBjrfIFrDXV90igTTcQLc0GSfwCpy3V591igI1iZ12Go
        uhRJYTwB76sjsBFGXJyEi8XtqjTiP62+WvKNU4qs3OiQZ+7maO74AsJDeo28n3rQ+5pof7n
        dZspjhWfK02/85M8E9Kj5j1AC9xJirUwKeqqTaLIpFeonvpETg3nhsoA/qQwq/AJ3aofPqU
        0dsnJ3ehTYWsyj1mF4opFaAG9oddE1IeGGWPT89U6AAw7cWyM0V2XhmUqgnT9zgM39NXPJD
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [RFC PATCH net-next 01/16] net: txgbe: Store PCI info
Date:   Wed, 10 Aug 2022 16:55:17 +0800
Message-Id: <20220810085532.246613-2-jiawenwu@trustnetic.com>
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

Get PCI config space info and store bus info.
Set LAN id and check flash status.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/Makefile   |   3 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  12 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 173 +++++++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |  30 ++
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 177 +++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   | 334 ++++++++++++++++++
 6 files changed, 727 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h

diff --git a/drivers/net/ethernet/wangxun/txgbe/Makefile b/drivers/net/ethernet/wangxun/txgbe/Makefile
index 431303ca75b4..78484c58b78b 100644
--- a/drivers/net/ethernet/wangxun/txgbe/Makefile
+++ b/drivers/net/ethernet/wangxun/txgbe/Makefile
@@ -6,4 +6,5 @@
 
 obj-$(CONFIG_TXGBE) += txgbe.o
 
-txgbe-objs := txgbe_main.o
+txgbe-objs := txgbe_main.o \
+              txgbe_hw.o
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 38ddbde0ed0f..94c43eef0cd6 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -17,8 +17,20 @@ struct txgbe_adapter {
 	/* OS defined structs */
 	struct net_device *netdev;
 	struct pci_dev *pdev;
+
+	/* structs defined in txgbe_type.h */
+	struct txgbe_hw hw;
+	u16 msg_enable;
 };
 
+s32 txgbe_init_shared_code(struct txgbe_hw *hw);
+
 extern char txgbe_driver_name[];
 
+#define TXGBE_FAILED_READ_CFG_DWORD 0xffffffffU
+#define TXGBE_FAILED_READ_CFG_WORD  0xffffU
+#define TXGBE_FAILED_READ_CFG_BYTE  0xffU
+
+extern u16 txgbe_read_pci_cfg_word(struct txgbe_hw *hw, u32 reg);
+
 #endif /* _TXGBE_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
new file mode 100644
index 000000000000..1baf965e50d7
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -0,0 +1,173 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd. */
+
+#include "txgbe_type.h"
+#include "txgbe_hw.h"
+#include "txgbe.h"
+
+/**
+ *  txgbe_set_pci_config_data - Generic store PCI bus info
+ *  @hw: pointer to hardware structure
+ *  @link_status: the link status returned by the PCI config space
+ *
+ *  Stores the PCI bus info (speed, width, type) within the txgbe_hw structure
+ **/
+void txgbe_set_pci_config_data(struct txgbe_hw *hw, u16 link_status)
+{
+	if (hw->bus.type == txgbe_bus_type_unknown)
+		hw->bus.type = txgbe_bus_type_pci_express;
+
+	switch (link_status & TXGBE_PCI_LINK_WIDTH) {
+	case TXGBE_PCI_LINK_WIDTH_1:
+		hw->bus.width = txgbe_bus_width_pcie_x1;
+		break;
+	case TXGBE_PCI_LINK_WIDTH_2:
+		hw->bus.width = txgbe_bus_width_pcie_x2;
+		break;
+	case TXGBE_PCI_LINK_WIDTH_4:
+		hw->bus.width = txgbe_bus_width_pcie_x4;
+		break;
+	case TXGBE_PCI_LINK_WIDTH_8:
+		hw->bus.width = txgbe_bus_width_pcie_x8;
+		break;
+	default:
+		hw->bus.width = txgbe_bus_width_unknown;
+		break;
+	}
+
+	switch (link_status & TXGBE_PCI_LINK_SPEED) {
+	case TXGBE_PCI_LINK_SPEED_2500:
+		hw->bus.speed = txgbe_bus_speed_2500;
+		break;
+	case TXGBE_PCI_LINK_SPEED_5000:
+		hw->bus.speed = txgbe_bus_speed_5000;
+		break;
+	case TXGBE_PCI_LINK_SPEED_8000:
+		hw->bus.speed = txgbe_bus_speed_8000;
+		break;
+	default:
+		hw->bus.speed = txgbe_bus_speed_unknown;
+		break;
+	}
+}
+
+/**
+ *  txgbe_get_bus_info - Generic set PCI bus info
+ *  @hw: pointer to hardware structure
+ *
+ *  Gets the PCI bus info (speed, width, type) then calls helper function to
+ *  store this data within the txgbe_hw structure.
+ **/
+s32 txgbe_get_bus_info(struct txgbe_hw *hw)
+{
+	u16 link_status;
+
+	/* Get the negotiated link width and speed from PCI config space */
+	link_status = txgbe_read_pci_cfg_word(hw, TXGBE_PCI_LINK_STATUS);
+
+	txgbe_set_pci_config_data(hw, link_status);
+
+	return 0;
+}
+
+/**
+ *  txgbe_set_lan_id_multi_port_pcie - Set LAN id for PCIe multiple port devices
+ *  @hw: pointer to the HW structure
+ *
+ *  Determines the LAN function id by reading memory-mapped registers
+ *  and swaps the port value if requested.
+ **/
+s32 txgbe_set_lan_id_multi_port_pcie(struct txgbe_hw *hw)
+{
+	struct txgbe_bus_info *bus = &hw->bus;
+	u32 reg;
+
+	reg = rd32(hw, TXGBE_CFG_PORT_ST);
+	bus->lan_id = TXGBE_CFG_PORT_ST_LAN_ID(reg);
+
+	/* check for a port swap */
+	reg = rd32(hw, TXGBE_MIS_PWR);
+	if (TXGBE_MIS_PWR_LAN_ID(reg) == TXGBE_MIS_PWR_LAN_ID_1)
+		bus->func = 0;
+	else
+		bus->func = bus->lan_id;
+
+	return 0;
+}
+
+/* cmd_addr is used for some special command:
+ * 1. to be sector address, when implemented erase sector command
+ * 2. to be flash address when implemented read, write flash address
+ */
+u8 fmgr_cmd_op(struct txgbe_hw *hw, u32 cmd, u32 cmd_addr)
+{
+	u32 cmd_val = 0;
+	u32 time_out = 0;
+
+	cmd_val = (cmd << SPI_CLK_CMD_OFFSET) |
+		  (SPI_CLK_DIV << SPI_CLK_DIV_OFFSET) | cmd_addr;
+	wr32(hw, SPI_H_CMD_REG_ADDR, cmd_val);
+	while (1) {
+		if (rd32(hw, SPI_H_STA_REG_ADDR) & 0x1)
+			break;
+
+		if (time_out == SPI_TIME_OUT_VALUE)
+			return 1;
+
+		time_out = time_out + 1;
+		usleep_range(10, 20);
+	}
+
+	return 0;
+}
+
+u32 txgbe_flash_read_dword(struct txgbe_hw *hw, u32 addr)
+{
+	u8 status = fmgr_cmd_op(hw, SPI_CMD_READ_DWORD, addr);
+
+	if (status)
+		return (u32)status;
+
+	return rd32(hw, SPI_H_DAT_REG_ADDR);
+}
+
+int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit)
+{
+	u32 i = 0, reg = 0;
+	int err = 0;
+
+	/* if there's flash existing */
+	if (!(rd32(hw, TXGBE_SPI_STATUS) &
+	      TXGBE_SPI_STATUS_FLASH_BYPASS)) {
+		/* wait hw load flash done */
+		for (i = 0; i < TXGBE_MAX_FLASH_LOAD_POLL_TIME; i++) {
+			reg = rd32(hw, TXGBE_SPI_ILDR_STATUS);
+			if (!(reg & check_bit)) {
+				/* done */
+				break;
+			}
+			msleep(200);
+		}
+		if (i == TXGBE_MAX_FLASH_LOAD_POLL_TIME)
+			err = TXGBE_ERR_FLASH_LOADING_FAILED;
+	}
+	return err;
+}
+
+/**
+ *  txgbe_init_ops - Inits func ptrs and MAC type
+ *  @hw: pointer to hardware structure
+ *
+ *  Initialize the function pointers and assign the MAC type for sapphire.
+ *  Does not touch the hardware.
+ **/
+s32 txgbe_init_ops(struct txgbe_hw *hw)
+{
+	struct txgbe_mac_info *mac = &hw->mac;
+
+	/* MAC */
+	mac->ops.get_bus_info = txgbe_get_bus_info;
+	mac->ops.set_lan_id = txgbe_set_lan_id_multi_port_pcie;
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
new file mode 100644
index 000000000000..fb250c99ddfd
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd. */
+
+#ifndef _TXGBE_HW_H_
+#define _TXGBE_HW_H_
+
+#define SPI_CLK_DIV           2
+
+#define SPI_CMD_READ_DWORD    1  /* SPI read a dword command */
+
+#define SPI_CLK_CMD_OFFSET    28  /* SPI command field offset in Command register */
+#define SPI_CLK_DIV_OFFSET    25  /* SPI clock divide field offset in Command register */
+
+#define SPI_TIME_OUT_VALUE           10000
+#define SPI_H_CMD_REG_ADDR           0x10104  /* SPI Command register address */
+#define SPI_H_DAT_REG_ADDR           0x10108  /* SPI Data register address */
+#define SPI_H_STA_REG_ADDR           0x1010c  /* SPI Status register address */
+
+s32 txgbe_get_bus_info(struct txgbe_hw *hw);
+void txgbe_set_pci_config_data(struct txgbe_hw *hw, u16 link_status);
+s32 txgbe_set_lan_id_multi_port_pcie(struct txgbe_hw *hw);
+
+int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit);
+
+s32 txgbe_init_ops(struct txgbe_hw *hw);
+
+u8 fmgr_cmd_op(struct txgbe_hw *hw, u32 cmd, u32 cmd_addr);
+u32 txgbe_flash_read_dword(struct txgbe_hw *hw, u32 addr);
+
+#endif /* _TXGBE_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index d3b9f73ecba4..d6145eca7b0a 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -10,6 +10,7 @@
 #include <linux/etherdevice.h>
 
 #include "txgbe.h"
+#include "txgbe_hw.h"
 
 char txgbe_driver_name[] = "txgbe";
 
@@ -30,6 +31,130 @@ static const struct pci_device_id txgbe_pci_tbl[] = {
 
 #define DEFAULT_DEBUG_LEVEL_SHIFT 3
 
+static void txgbe_check_minimum_link(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	struct pci_dev *pdev;
+
+	/* Some devices are not connected over PCIe and thus do not negotiate
+	 * speed. These devices do not have valid bus info, and thus any report
+	 * we generate may not be correct.
+	 */
+	if (hw->bus.type == txgbe_bus_type_internal)
+		return;
+
+	pdev = adapter->pdev;
+	pcie_print_link_status(pdev);
+}
+
+/**
+ * txgbe_enumerate_functions - Get the number of ports this device has
+ * @adapter: adapter structure
+ *
+ * This function enumerates the phsyical functions co-located on a single slot,
+ * in order to determine how many ports a device has. This is most useful in
+ * determining the required GT/s of PCIe bandwidth necessary for optimal
+ * performance.
+ **/
+static inline int txgbe_enumerate_functions(struct txgbe_adapter *adapter)
+{
+	struct pci_dev *entry, *pdev = adapter->pdev;
+	int physfns = 0;
+
+	list_for_each_entry(entry, &pdev->bus->devices, bus_list) {
+		/* When the devices on the bus don't all match our device ID,
+		 * we can't reliably determine the correct number of
+		 * functions. This can occur if a function has been direct
+		 * attached to a virtual machine using VT-d, for example. In
+		 * this case, simply return -1 to indicate this.
+		 */
+		if (entry->vendor != pdev->vendor ||
+		    entry->device != pdev->device)
+			return -1;
+
+		physfns++;
+	}
+
+	return physfns;
+}
+
+static void txgbe_remove_adapter(struct txgbe_hw *hw)
+{
+	struct txgbe_adapter *adapter = container_of(hw, struct txgbe_adapter, hw);
+
+	if (!hw->hw_addr)
+		return;
+	hw->hw_addr = NULL;
+	dev_info(&adapter->pdev->dev, "Adapter removed\n");
+}
+
+static bool txgbe_check_cfg_remove(struct txgbe_hw *hw, struct pci_dev *pdev)
+{
+	u16 value;
+
+	pci_read_config_word(pdev, PCI_VENDOR_ID, &value);
+	if (value == TXGBE_FAILED_READ_CFG_WORD) {
+		txgbe_remove_adapter(hw);
+		return true;
+	}
+	return false;
+}
+
+/**
+ *  txgbe_init_shared_code - Initialize the shared code
+ *  @hw: pointer to hardware structure
+ *
+ *  This will assign function pointers and assign the MAC type and PHY code.
+ **/
+s32 txgbe_init_shared_code(struct txgbe_hw *hw)
+{
+	s32 status;
+
+	status = txgbe_init_ops(hw);
+	return status;
+}
+
+/**
+ * txgbe_sw_init - Initialize general software structures (struct txgbe_adapter)
+ * @adapter: board private structure to initialize
+ **/
+static int txgbe_sw_init(struct txgbe_adapter *adapter)
+{
+	struct pci_dev *pdev = adapter->pdev;
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 ssid = 0;
+	int err = 0;
+
+	/* PCI config space info */
+	hw->vendor_id = pdev->vendor;
+	hw->device_id = pdev->device;
+	hw->revision_id = pdev->revision;
+	hw->oem_svid = pdev->subsystem_vendor;
+	hw->oem_ssid = pdev->subsystem_device;
+
+	if (hw->oem_svid == PCI_VENDOR_ID_WANGXUN) {
+		hw->subsystem_vendor_id = pdev->subsystem_vendor;
+		hw->subsystem_device_id = pdev->subsystem_device;
+	} else {
+		ssid = txgbe_flash_read_dword(hw, 0xfffdc);
+		if (ssid == 0x1) {
+			netif_err(adapter, probe, adapter->netdev,
+				  "read of internal subsystem device id failed\n");
+			return -ENODEV;
+		}
+		hw->subsystem_device_id = (u16)ssid >> 8 | (u16)ssid << 8;
+	}
+
+	err = txgbe_init_shared_code(hw);
+	if (err) {
+		netif_err(adapter, probe, adapter->netdev,
+			  "init_shared_code failed: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
 static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 {
 	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
@@ -67,8 +192,9 @@ static int txgbe_probe(struct pci_dev *pdev,
 		       const struct pci_device_id __always_unused *ent)
 {
 	struct txgbe_adapter *adapter = NULL;
+	struct txgbe_hw *hw = NULL;
 	struct net_device *netdev;
-	int err;
+	int err, expected_gts;
 
 	err = pci_enable_device_mem(pdev);
 	if (err)
@@ -107,6 +233,8 @@ static int txgbe_probe(struct pci_dev *pdev,
 	adapter = netdev_priv(netdev);
 	adapter->netdev = netdev;
 	adapter->pdev = pdev;
+	hw = &adapter->hw;
+	adapter->msg_enable = (1 << DEFAULT_DEBUG_LEVEL_SHIFT) - 1;
 
 	adapter->io_addr = devm_ioremap(&pdev->dev,
 					pci_resource_start(pdev, 0),
@@ -115,11 +243,44 @@ static int txgbe_probe(struct pci_dev *pdev,
 		err = -EIO;
 		goto err_pci_release_regions;
 	}
+	hw->hw_addr = adapter->io_addr;
+
+	strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
+
+	/* setup the private structure */
+	err = txgbe_sw_init(adapter);
+	if (err)
+		goto err_pci_release_regions;
+
+	TCALL(hw, mac.ops.set_lan_id);
+
+	/* check if flash load is done after hw power up */
+	err = txgbe_check_flash_load(hw, TXGBE_SPI_ILDR_STATUS_PERST);
+	if (err)
+		goto err_pci_release_regions;
+	err = txgbe_check_flash_load(hw, TXGBE_SPI_ILDR_STATUS_PWRRST);
+	if (err)
+		goto err_pci_release_regions;
 
 	netdev->features |= NETIF_F_HIGHDMA;
 
+	/* pick up the PCI bus settings for reporting later */
+	TCALL(hw, mac.ops.get_bus_info);
+
 	pci_set_drvdata(pdev, adapter);
 
+	/* calculate the expected PCIe bandwidth required for optimal
+	 * performance. Note that some older parts will never have enough
+	 * bandwidth due to being older generation PCIe parts. We clamp these
+	 * parts to ensure that no warning is displayed, as this could confuse
+	 * users otherwise.
+	 */
+	expected_gts = txgbe_enumerate_functions(adapter) * 10;
+
+	/* don't check link if we failed to enumerate functions */
+	if (expected_gts > 0)
+		txgbe_check_minimum_link(adapter);
+
 	return 0;
 
 err_pci_release_regions:
@@ -150,6 +311,20 @@ static void txgbe_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
+u16 txgbe_read_pci_cfg_word(struct txgbe_hw *hw, u32 reg)
+{
+	struct txgbe_adapter *adapter = container_of(hw, struct txgbe_adapter, hw);
+	u16 value;
+
+	if (TXGBE_REMOVED(hw->hw_addr))
+		return TXGBE_FAILED_READ_CFG_WORD;
+	pci_read_config_word(adapter->pdev, reg, &value);
+	if (value == TXGBE_FAILED_READ_CFG_WORD &&
+	    txgbe_check_cfg_remove(hw, adapter->pdev))
+		return TXGBE_FAILED_READ_CFG_WORD;
+	return value;
+}
+
 static struct pci_driver txgbe_driver = {
 	.name     = txgbe_driver_name,
 	.id_table = txgbe_pci_tbl,
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index b2e329f50bae..b769af5e6cbb 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -54,4 +54,338 @@
 /* Revision ID */
 #define TXGBE_SP_MPW  1
 
+/**************** Global Registers ****************************/
+/* chip control Registers */
+#define TXGBE_MIS_RST                   0x1000C
+#define TXGBE_MIS_PWR                   0x10000
+#define TXGBE_MIS_CTL                   0x10004
+#define TXGBE_MIS_PF_SM                 0x10008
+#define TXGBE_MIS_PRB_CTL               0x10010
+#define TXGBE_MIS_ST                    0x10028
+#define TXGBE_MIS_SWSM                  0x1002C
+#define TXGBE_MIS_RST_ST                0x10030
+
+#define TXGBE_MIS_RST_SW_RST            0x00000001U
+#define TXGBE_MIS_RST_LAN0_RST          0x00000002U
+#define TXGBE_MIS_RST_LAN1_RST          0x00000004U
+#define TXGBE_MIS_RST_LAN0_CHG_ETH_MODE 0x20000000U
+#define TXGBE_MIS_RST_LAN1_CHG_ETH_MODE 0x40000000U
+#define TXGBE_MIS_RST_GLOBAL_RST        0x80000000U
+#define TXGBE_MIS_RST_MASK      (TXGBE_MIS_RST_SW_RST | \
+				 TXGBE_MIS_RST_LAN0_RST | \
+				 TXGBE_MIS_RST_LAN1_RST)
+#define TXGBE_MIS_PWR_LAN_ID(_r)        ((0xC0000000U & (_r)) >> 30)
+#define TXGBE_MIS_PWR_LAN_ID_0          (1)
+#define TXGBE_MIS_PWR_LAN_ID_1          (2)
+#define TXGBE_MIS_PWR_LAN_ID_A          (3)
+#define TXGBE_MIS_ST_MNG_INIT_DN        0x00000001U
+#define TXGBE_MIS_ST_MNG_VETO           0x00000100U
+#define TXGBE_MIS_ST_LAN0_ECC           0x00010000U
+#define TXGBE_MIS_ST_LAN1_ECC           0x00020000U
+#define TXGBE_MIS_ST_MNG_ECC            0x00040000U
+#define TXGBE_MIS_ST_PCORE_ECC          0x00080000U
+#define TXGBE_MIS_ST_PCIWRP_ECC         0x00100000U
+#define TXGBE_MIS_SWSM_SMBI             1
+#define TXGBE_MIS_RST_ST_DEV_RST_ST_DONE        0x00000000U
+#define TXGBE_MIS_RST_ST_DEV_RST_ST_REQ         0x00080000U
+#define TXGBE_MIS_RST_ST_DEV_RST_ST_INPROGRESS  0x00100000U
+#define TXGBE_MIS_RST_ST_DEV_RST_ST_MASK        0x00180000U
+#define TXGBE_MIS_RST_ST_DEV_RST_TYPE_MASK      0x00070000U
+#define TXGBE_MIS_RST_ST_DEV_RST_TYPE_SHIFT     16
+#define TXGBE_MIS_RST_ST_DEV_RST_TYPE_SW_RST    0x3
+#define TXGBE_MIS_RST_ST_DEV_RST_TYPE_GLOBAL_RST 0x5
+#define TXGBE_MIS_RST_ST_RST_INIT       0x0000FF00U
+#define TXGBE_MIS_RST_ST_RST_INI_SHIFT  8
+#define TXGBE_MIS_RST_ST_RST_TIM        0x000000FFU
+#define TXGBE_MIS_PF_SM_SM              1
+#define TXGBE_MIS_PRB_CTL_LAN0_UP       0x2
+#define TXGBE_MIS_PRB_CTL_LAN1_UP       0x1
+
+/* FMGR Registers */
+#define TXGBE_SPI_ILDR_STATUS           0x10120
+#define TXGBE_SPI_ILDR_STATUS_PERST     0x00000001U /* PCIE_PERST is done */
+#define TXGBE_SPI_ILDR_STATUS_PWRRST    0x00000002U /* Power on reset is done */
+#define TXGBE_SPI_ILDR_STATUS_SW_RESET  0x00000080U /* software reset is done */
+#define TXGBE_SPI_ILDR_STATUS_LAN0_SW_RST 0x00000200U /* lan0 soft reset done */
+#define TXGBE_SPI_ILDR_STATUS_LAN1_SW_RST 0x00000400U /* lan1 soft reset done */
+
+#define TXGBE_MAX_FLASH_LOAD_POLL_TIME  10
+
+#define TXGBE_SPI_CMD                   0x10104
+#define TXGBE_SPI_CMD_CMD(_v)           (((_v) & 0x7) << 28)
+#define TXGBE_SPI_CMD_CLK(_v)           (((_v) & 0x7) << 25)
+#define TXGBE_SPI_CMD_ADDR(_v)          (((_v) & 0xFFFFFF))
+#define TXGBE_SPI_DATA                  0x10108
+#define TXGBE_SPI_DATA_BYPASS           ((0x1) << 31)
+#define TXGBE_SPI_DATA_STATUS(_v)       (((_v) & 0xFF) << 16)
+#define TXGBE_SPI_DATA_OP_DONE          ((0x1))
+
+#define TXGBE_SPI_STATUS                0x1010C
+#define TXGBE_SPI_STATUS_OPDONE         ((0x1))
+#define TXGBE_SPI_STATUS_FLASH_BYPASS   ((0x1) << 31)
+
+#define TXGBE_SPI_USR_CMD               0x10110
+#define TXGBE_SPI_CMDCFG0               0x10114
+#define TXGBE_SPI_CMDCFG1               0x10118
+#define TXGBE_SPI_ECC_CTL               0x10130
+#define TXGBE_SPI_ECC_INJ               0x10134
+#define TXGBE_SPI_ECC_ST                0x10138
+#define TXGBE_SPI_ILDR_SWPTR            0x10124
+
+/* port cfg Registers */
+#define TXGBE_CFG_PORT_CTL              0x14400
+#define TXGBE_CFG_PORT_ST               0x14404
+#define TXGBE_CFG_EX_VTYPE              0x14408
+#define TXGBE_CFG_LED_CTL               0x14424
+#define TXGBE_CFG_VXLAN                 0x14410
+#define TXGBE_CFG_VXLAN_GPE             0x14414
+#define TXGBE_CFG_GENEVE                0x14418
+#define TXGBE_CFG_TEREDO                0x1441C
+#define TXGBE_CFG_TCP_TIME              0x14420
+#define TXGBE_CFG_TAG_TPID(_i)          (0x14430 + ((_i) * 4))
+/* port cfg bit */
+#define TXGBE_CFG_PORT_CTL_PFRSTD       0x00004000U /* Phy Function Reset Done */
+#define TXGBE_CFG_PORT_CTL_D_VLAN       0x00000001U /* double vlan*/
+#define TXGBE_CFG_PORT_CTL_ETAG_ETYPE_VLD 0x00000002U
+#define TXGBE_CFG_PORT_CTL_QINQ         0x00000004U
+#define TXGBE_CFG_PORT_CTL_DRV_LOAD     0x00000008U
+#define TXGBE_CFG_PORT_CTL_FORCE_LKUP   0x00000010U /* force link up */
+#define TXGBE_CFG_PORT_CTL_DCB_EN       0x00000400U /* dcb enabled */
+#define TXGBE_CFG_PORT_CTL_NUM_TC_MASK  0x00000800U /* number of TCs */
+#define TXGBE_CFG_PORT_CTL_NUM_TC_4     0x00000000U
+#define TXGBE_CFG_PORT_CTL_NUM_TC_8     0x00000800U
+#define TXGBE_CFG_PORT_CTL_NUM_VT_MASK  0x00003000U /* number of TVs */
+#define TXGBE_CFG_PORT_CTL_NUM_VT_NONE  0x00000000U
+#define TXGBE_CFG_PORT_CTL_NUM_VT_16    0x00001000U
+#define TXGBE_CFG_PORT_CTL_NUM_VT_32    0x00002000U
+#define TXGBE_CFG_PORT_CTL_NUM_VT_64    0x00003000U
+/* Status Bit */
+#define TXGBE_CFG_PORT_ST_LINK_UP       0x00000001U
+#define TXGBE_CFG_PORT_ST_LINK_10G      0x00000002U
+#define TXGBE_CFG_PORT_ST_LINK_1G       0x00000004U
+#define TXGBE_CFG_PORT_ST_LINK_100M     0x00000008U
+#define TXGBE_CFG_PORT_ST_LAN_ID(_r)    ((0x00000100U & (_r)) >> 8)
+#define TXGBE_LINK_UP_TIME              90
+/* LED CTL Bit */
+#define TXGBE_CFG_LED_CTL_LINK_BSY_SEL  0x00000010U
+#define TXGBE_CFG_LED_CTL_LINK_100M_SEL 0x00000008U
+#define TXGBE_CFG_LED_CTL_LINK_1G_SEL   0x00000004U
+#define TXGBE_CFG_LED_CTL_LINK_10G_SEL  0x00000002U
+#define TXGBE_CFG_LED_CTL_LINK_UP_SEL   0x00000001U
+#define TXGBE_CFG_LED_CTL_LINK_OD_SHIFT 16
+/******************************** PCI Bus Info *******************************/
+#define TXGBE_PCI_DEVICE_STATUS         0xAA
+#define TXGBE_PCI_DEVICE_STATUS_TRANSACTION_PENDING     0x0020
+#define TXGBE_PCI_LINK_STATUS           0xB2
+#define TXGBE_PCI_DEVICE_CONTROL2       0xC8
+#define TXGBE_PCI_LINK_WIDTH            0x3F0
+#define TXGBE_PCI_LINK_WIDTH_1          0x10
+#define TXGBE_PCI_LINK_WIDTH_2          0x20
+#define TXGBE_PCI_LINK_WIDTH_4          0x40
+#define TXGBE_PCI_LINK_WIDTH_8          0x80
+#define TXGBE_PCI_LINK_SPEED            0xF
+#define TXGBE_PCI_LINK_SPEED_2500       0x1
+#define TXGBE_PCI_LINK_SPEED_5000       0x2
+#define TXGBE_PCI_LINK_SPEED_8000       0x3
+#define TXGBE_PCI_HEADER_TYPE_REGISTER  0x0E
+#define TXGBE_PCI_HEADER_TYPE_MULTIFUNC 0x80
+#define TXGBE_PCI_DEVICE_CONTROL2_16ms  0x0005
+
+#define TXGBE_PCIDEVCTRL2_RELAX_ORDER_OFFSET    4
+#define TXGBE_PCIDEVCTRL2_RELAX_ORDER_MASK      \
+				(0x0001 << TXGBE_PCIDEVCTRL2_RELAX_ORDER_OFFSET)
+#define TXGBE_PCIDEVCTRL2_RELAX_ORDER_ENABLE    \
+				(0x01 << TXGBE_PCIDEVCTRL2_RELAX_ORDER_OFFSET)
+
+#define TXGBE_PCIDEVCTRL2_TIMEO_MASK    0xf
+#define TXGBE_PCIDEVCTRL2_16_32ms_def   0x0
+#define TXGBE_PCIDEVCTRL2_50_100us      0x1
+#define TXGBE_PCIDEVCTRL2_1_2ms         0x2
+#define TXGBE_PCIDEVCTRL2_16_32ms       0x5
+#define TXGBE_PCIDEVCTRL2_65_130ms      0x6
+#define TXGBE_PCIDEVCTRL2_260_520ms     0x9
+#define TXGBE_PCIDEVCTRL2_1_2s          0xa
+#define TXGBE_PCIDEVCTRL2_4_8s          0xd
+#define TXGBE_PCIDEVCTRL2_17_34s        0xe
+
+/* PCI bus types */
+enum txgbe_bus_type {
+	txgbe_bus_type_unknown = 0,
+	txgbe_bus_type_pci,
+	txgbe_bus_type_pcix,
+	txgbe_bus_type_pci_express,
+	txgbe_bus_type_internal,
+	txgbe_bus_type_reserved
+};
+
+/* PCI bus speeds */
+enum txgbe_bus_speed {
+	txgbe_bus_speed_unknown	= 0,
+	txgbe_bus_speed_33	= 33,
+	txgbe_bus_speed_66	= 66,
+	txgbe_bus_speed_100	= 100,
+	txgbe_bus_speed_120	= 120,
+	txgbe_bus_speed_133	= 133,
+	txgbe_bus_speed_2500	= 2500,
+	txgbe_bus_speed_5000	= 5000,
+	txgbe_bus_speed_8000	= 8000,
+	txgbe_bus_speed_reserved
+};
+
+/* PCI bus widths */
+enum txgbe_bus_width {
+	txgbe_bus_width_unknown	= 0,
+	txgbe_bus_width_pcie_x1	= 1,
+	txgbe_bus_width_pcie_x2	= 2,
+	txgbe_bus_width_pcie_x4	= 4,
+	txgbe_bus_width_pcie_x8	= 8,
+	txgbe_bus_width_32	= 32,
+	txgbe_bus_width_64	= 64,
+	txgbe_bus_width_reserved
+};
+
+/* Bus parameters */
+struct txgbe_bus_info {
+	enum txgbe_bus_speed speed;
+	enum txgbe_bus_width width;
+	enum txgbe_bus_type type;
+
+	u16 func;
+	u16 lan_id;
+};
+
+/* forward declaration */
+struct txgbe_hw;
+
+struct txgbe_mac_operations {
+	s32 (*get_bus_info)(struct txgbe_hw *hw);
+	s32 (*set_lan_id)(struct txgbe_hw *hw);
+
+};
+
+struct txgbe_mac_info {
+	struct txgbe_mac_operations ops;
+};
+
+struct txgbe_hw {
+	u8 __iomem *hw_addr;
+	struct txgbe_mac_info mac;
+	struct txgbe_bus_info bus;
+	u16 device_id;
+	u16 vendor_id;
+	u16 subsystem_device_id;
+	u16 subsystem_vendor_id;
+	u8 revision_id;
+	u16 oem_ssid;
+	u16 oem_svid;
+};
+
+#define TCALL(hw, func, args...) (((hw)->func) \
+		? (hw)->func((hw), ##args) : TXGBE_NOT_IMPLEMENTED)
+
+/* Error Codes */
+#define TXGBE_ERR                                100
+#define TXGBE_NOT_IMPLEMENTED                    0x7FFFFFFF
+/* (-TXGBE_ERR, TXGBE_ERR): reserved for non-txgbe defined error code */
+#define TXGBE_ERR_NOSUPP                        -(TXGBE_ERR + 0)
+#define TXGBE_ERR_EEPROM                        -(TXGBE_ERR + 1)
+#define TXGBE_ERR_EEPROM_CHECKSUM               -(TXGBE_ERR + 2)
+#define TXGBE_ERR_PHY                           -(TXGBE_ERR + 3)
+#define TXGBE_ERR_CONFIG                        -(TXGBE_ERR + 4)
+#define TXGBE_ERR_PARAM                         -(TXGBE_ERR + 5)
+#define TXGBE_ERR_MAC_TYPE                      -(TXGBE_ERR + 6)
+#define TXGBE_ERR_UNKNOWN_PHY                   -(TXGBE_ERR + 7)
+#define TXGBE_ERR_LINK_SETUP                    -(TXGBE_ERR + 8)
+#define TXGBE_ERR_ADAPTER_STOPPED               -(TXGBE_ERR + 9)
+#define TXGBE_ERR_INVALID_MAC_ADDR              -(TXGBE_ERR + 10)
+#define TXGBE_ERR_DEVICE_NOT_SUPPORTED          -(TXGBE_ERR + 11)
+#define TXGBE_ERR_MASTER_REQUESTS_PENDING       -(TXGBE_ERR + 12)
+#define TXGBE_ERR_INVALID_LINK_SETTINGS         -(TXGBE_ERR + 13)
+#define TXGBE_ERR_AUTONEG_NOT_COMPLETE          -(TXGBE_ERR + 14)
+#define TXGBE_ERR_RESET_FAILED                  -(TXGBE_ERR + 15)
+#define TXGBE_ERR_SWFW_SYNC                     -(TXGBE_ERR + 16)
+#define TXGBE_ERR_PHY_ADDR_INVALID              -(TXGBE_ERR + 17)
+#define TXGBE_ERR_I2C                           -(TXGBE_ERR + 18)
+#define TXGBE_ERR_SFP_NOT_SUPPORTED             -(TXGBE_ERR + 19)
+#define TXGBE_ERR_SFP_NOT_PRESENT               -(TXGBE_ERR + 20)
+#define TXGBE_ERR_SFP_NO_INIT_SEQ_PRESENT       -(TXGBE_ERR + 21)
+#define TXGBE_ERR_NO_SAN_ADDR_PTR               -(TXGBE_ERR + 22)
+#define TXGBE_ERR_FDIR_REINIT_FAILED            -(TXGBE_ERR + 23)
+#define TXGBE_ERR_EEPROM_VERSION                -(TXGBE_ERR + 24)
+#define TXGBE_ERR_NO_SPACE                      -(TXGBE_ERR + 25)
+#define TXGBE_ERR_OVERTEMP                      -(TXGBE_ERR + 26)
+#define TXGBE_ERR_UNDERTEMP                     -(TXGBE_ERR + 27)
+#define TXGBE_ERR_FC_NOT_NEGOTIATED             -(TXGBE_ERR + 28)
+#define TXGBE_ERR_FC_NOT_SUPPORTED              -(TXGBE_ERR + 29)
+#define TXGBE_ERR_SFP_SETUP_NOT_COMPLETE        -(TXGBE_ERR + 30)
+#define TXGBE_ERR_PBA_SECTION                   -(TXGBE_ERR + 31)
+#define TXGBE_ERR_INVALID_ARGUMENT              -(TXGBE_ERR + 32)
+#define TXGBE_ERR_HOST_INTERFACE_COMMAND        -(TXGBE_ERR + 33)
+#define TXGBE_ERR_OUT_OF_MEM                    -(TXGBE_ERR + 34)
+#define TXGBE_ERR_FEATURE_NOT_SUPPORTED         -(TXGBE_ERR + 36)
+#define TXGBE_ERR_EEPROM_PROTECTED_REGION       -(TXGBE_ERR + 37)
+#define TXGBE_ERR_FDIR_CMD_INCOMPLETE           -(TXGBE_ERR + 38)
+#define TXGBE_ERR_FLASH_LOADING_FAILED          -(TXGBE_ERR + 39)
+#define TXGBE_ERR_XPCS_POWER_UP_FAILED          -(TXGBE_ERR + 40)
+#define TXGBE_ERR_FW_RESP_INVALID               -(TXGBE_ERR + 41)
+#define TXGBE_ERR_PHY_INIT_NOT_DONE             -(TXGBE_ERR + 42)
+#define TXGBE_ERR_TIMEOUT                       -(TXGBE_ERR + 43)
+#define TXGBE_ERR_TOKEN_RETRY                   -(TXGBE_ERR + 44)
+#define TXGBE_ERR_REGISTER                      -(TXGBE_ERR + 45)
+#define TXGBE_ERR_MBX                           -(TXGBE_ERR + 46)
+#define TXGBE_ERR_MNG_ACCESS_FAILED             -(TXGBE_ERR + 47)
+
+/**
+ * register operations
+ **/
+/* read register */
+#define TXGBE_DEAD_READ_RETRIES     10
+#define TXGBE_DEAD_READ_REG         0xdeadbeefU
+#define TXGBE_DEAD_READ_REG64       0xdeadbeefdeadbeefULL
+#define TXGBE_FAILED_READ_REG       0xffffffffU
+#define TXGBE_FAILED_READ_REG64     0xffffffffffffffffULL
+
+static inline bool TXGBE_REMOVED(void __iomem *addr)
+{
+	return unlikely(!addr);
+}
+
+static inline u32
+txgbe_rd32(u8 __iomem *base)
+{
+	return readl(base);
+}
+
+static inline u32
+rd32(struct txgbe_hw *hw, u32 reg)
+{
+	u8 __iomem *base = READ_ONCE(hw->hw_addr);
+	u32 val = TXGBE_FAILED_READ_REG;
+
+	if (unlikely(!base))
+		return val;
+
+	val = txgbe_rd32(base + reg);
+
+	return val;
+}
+
+/* write register */
+static inline void
+txgbe_wr32(u8 __iomem *base, u32 val)
+{
+	writel(val, base);
+}
+
+static inline void
+wr32(struct txgbe_hw *hw, u32 reg, u32 val)
+{
+	u8 __iomem *base = READ_ONCE(hw->hw_addr);
+
+	if (unlikely(!base))
+		return;
+
+	txgbe_wr32(base + reg, val);
+}
+
 #endif /* _TXGBE_TYPE_H_ */
-- 
2.27.0

