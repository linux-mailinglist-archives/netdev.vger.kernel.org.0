Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A385A5C70
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiH3HFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiH3HFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:05:33 -0400
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C971F861FB
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:05:27 -0700 (PDT)
X-QQ-mid: bizesmtp76t1661843122t4uamkpl
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 30 Aug 2022 15:05:21 +0800 (CST)
X-QQ-SSF: 01400000000000G0T000B00A0000000
X-QQ-FEAT: 3ytASaWyOdV9p0qEuhEOgN/imNDdj3zv2M+ye8k8ScP1lA3OQTA1wMqlfZDcC
        HlniJJCFFqlwMyxwsfefldXTKiAAbPRY/By+reshWMV9YAauolpvnbdjnurOmS+ByMNsoLy
        IHXWwp8Dw+ZJ9xNwsqtB9fR/Wxq+SgaQZ96Ph/XvDdV7iK75RNICcJnbt3IaFUrx4xXEddf
        ZvKMhJnr6G3/ZlBVkqbcjgkZXWnqpiHkRykbW3dthfAsleonnD+yxb6ob1IDmLGwgKVjWgE
        gk6Ai27Ggqz6shTW2gCrspZeQbq9O0/AyjIq+Kr9kBVfjWB8RmCxL0g29cs47IhaMo2CTzC
        qP6t4NbVqagQlK4Fi1PJVqOzfk1T2NLg0Gxvgcx/zEDMQBol21WuWL260QdrRijvJgjoclO
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v2 01/16] net: txgbe: Store PCI info
Date:   Tue, 30 Aug 2022 15:04:39 +0800
Message-Id: <20220830070454.146211-2-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220830070454.146211-1-jiawenwu@trustnetic.com>
References: <20220830070454.146211-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get PCI config space info, set LAN id and check flash status.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/Makefile   |   3 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  23 +++
 .../net/ethernet/wangxun/txgbe/txgbe_dummy.h  |  34 ++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c |  98 ++++++++++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |  28 ++++
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 115 ++++++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   | 151 ++++++++++++++++++
 7 files changed, 450 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
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
index 38ddbde0ed0f..a271a74b7ef7 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -17,8 +17,31 @@ struct txgbe_adapter {
 	/* OS defined structs */
 	struct net_device *netdev;
 	struct pci_dev *pdev;
+
+	/* structs defined in txgbe_type.h */
+	struct txgbe_hw hw;
+	u16 msg_enable;
 };
 
 extern char txgbe_driver_name[];
 
+__maybe_unused static struct device *txgbe_hw_to_dev(const struct txgbe_hw *hw)
+{
+	struct txgbe_adapter *adapter = container_of(hw, struct txgbe_adapter, hw);
+
+	return &adapter->pdev->dev;
+}
+
+__maybe_unused static struct net_device *txgbe_hw_to_netdev(const struct txgbe_hw *hw)
+{
+	struct txgbe_adapter *adapter =
+		container_of(hw, struct txgbe_adapter, hw);
+	return adapter->netdev;
+}
+
+#define txgbe_dbg(hw, fmt, arg...) \
+	netdev_dbg(txgbe_hw_to_netdev(hw), fmt, ##arg)
+#define txgbe_info(hw, fmt, arg...) \
+	dev_info(txgbe_hw_to_dev(hw), fmt, ##arg)
+
 #endif /* _TXGBE_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
new file mode 100644
index 000000000000..822306f5eaba
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd. */
+
+#ifndef _TXGBE_DUMMY_H_
+#define _TXGBE_DUMMY_H_
+
+#ifdef TUP
+#elif defined(__GNUC__)
+  #define TUP(x) x##_unused __always_unused
+#elif defined(__LCLINT__)
+  #define TUP(x) x /*@unused@*/
+#else
+  #define TUP(x) x
+#endif /*TUP*/
+#define TUP0 TUP(p0)
+#define TUP1 TUP(p1)
+#define TUP2 TUP(p2)
+#define TUP3 TUP(p3)
+#define TUP4 TUP(p4)
+
+/* struct txgbe_mac_operations */
+static void txgbe_bus_set_lan_id_dummy(struct txgbe_hw *TUP0)
+{
+}
+
+static void txgbe_init_ops_dummy(struct txgbe_hw *hw)
+{
+	struct txgbe_mac_info *mac = &hw->mac;
+
+	/* MAC */
+	mac->ops.set_lan_id = txgbe_bus_set_lan_id_dummy;
+}
+
+#endif /* _TXGBE_TYPE_DUMMY_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
new file mode 100644
index 000000000000..6477f5305c6a
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -0,0 +1,98 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd. */
+
+#include "txgbe_type.h"
+#include "txgbe_hw.h"
+#include "txgbe.h"
+
+/**
+ *  txgbe_set_lan_id_multi_port_pcie - Set LAN id for PCIe multiple port devices
+ *  @hw: pointer to the HW structure
+ *
+ *  Determines the LAN function id by reading memory-mapped registers
+ *  and swaps the port value if requested.
+ **/
+void txgbe_set_lan_id_multi_port_pcie(struct txgbe_hw *hw)
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
+}
+
+/* cmd_addr is used for some special command:
+ * 1. to be sector address, when implemented erase sector command
+ * 2. to be flash address when implemented read, write flash address
+ */
+int txgbe_fmgr_cmd_op(struct txgbe_hw *hw, u32 cmd, u32 cmd_addr)
+{
+	u32 cmd_val = 0, val = 0;
+
+	cmd_val = (cmd << SPI_CLK_CMD_OFFSET) |
+		  (SPI_CLK_DIV << SPI_CLK_DIV_OFFSET) | cmd_addr;
+	wr32(hw, SPI_H_CMD_REG_ADDR, cmd_val);
+
+	return read_poll_timeout(rd32, val, (val & 0x1), 10, SPI_TIME_OUT_VALUE,
+				 false, hw, SPI_H_STA_REG_ADDR);
+}
+
+int txgbe_flash_read_dword(struct txgbe_hw *hw, u32 addr, u32 *data)
+{
+	int ret = 0;
+
+	ret = txgbe_fmgr_cmd_op(hw, SPI_CMD_READ_DWORD, addr);
+	if (ret == -ETIMEDOUT)
+		return ret;
+
+	*data = rd32(hw, SPI_H_DAT_REG_ADDR);
+
+	return ret;
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
+		if (i == TXGBE_MAX_FLASH_LOAD_POLL_TIME) {
+			err = -ETIMEDOUT;
+			txgbe_info(hw, "Check flash load timeout.\n");
+		}
+	}
+	return err;
+}
+
+/**
+ *  txgbe_init_ops - Inits func ptrs
+ *  @hw: pointer to hardware structure
+ *
+ *  Initialize the function pointers.
+ *  Does not touch the hardware.
+ **/
+void txgbe_init_ops(struct txgbe_hw *hw)
+{
+	struct txgbe_mac_info *mac = &hw->mac;
+
+	/* MAC */
+	mac->ops.set_lan_id = txgbe_set_lan_id_multi_port_pcie;
+}
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
new file mode 100644
index 000000000000..778d134def03
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -0,0 +1,28 @@
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
+#define SPI_TIME_OUT_VALUE           100000
+#define SPI_H_CMD_REG_ADDR           0x10104  /* SPI Command register address */
+#define SPI_H_DAT_REG_ADDR           0x10108  /* SPI Data register address */
+#define SPI_H_STA_REG_ADDR           0x1010c  /* SPI Status register address */
+
+void txgbe_set_lan_id_multi_port_pcie(struct txgbe_hw *hw);
+
+int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit);
+
+void txgbe_init_ops(struct txgbe_hw *hw);
+
+int txgbe_fmgr_cmd_op(struct txgbe_hw *hw, u32 cmd, u32 cmd_addr);
+int txgbe_flash_read_dword(struct txgbe_hw *hw, u32 addr, u32 *data);
+
+#endif /* _TXGBE_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index d3b9f73ecba4..6b7431e13981 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -10,6 +10,8 @@
 #include <linux/etherdevice.h>
 
 #include "txgbe.h"
+#include "txgbe_hw.h"
+#include "txgbe_dummy.h"
 
 char txgbe_driver_name[] = "txgbe";
 
@@ -30,6 +32,82 @@ static const struct pci_device_id txgbe_pci_tbl[] = {
 
 #define DEFAULT_DEBUG_LEVEL_SHIFT 3
 
+static void txgbe_check_minimum_link(struct txgbe_adapter *adapter)
+{
+	struct pci_dev *pdev;
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
+static int txgbe_enumerate_functions(struct txgbe_adapter *adapter)
+{
+	struct pci_dev *entry, *pdev = adapter->pdev;
+	int physfns = 0;
+
+	list_for_each_entry(entry, &pdev->bus->devices, bus_list) {
+		/* When the devices on the bus don't all match our device ID,
+		 * we can't reliably determine the correct number of
+		 * functions. This can occur if a function has been direct
+		 * attached to a virtual machine using VT-d.
+		 */
+		if (entry->vendor != pdev->vendor ||
+		    entry->device != pdev->device)
+			return -EINVAL;
+
+		physfns++;
+	}
+
+	return physfns;
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
+		err = txgbe_flash_read_dword(hw, 0xfffdc, &ssid);
+		if (err == -ETIMEDOUT) {
+			netif_err(adapter, probe, adapter->netdev,
+				  "read of internal subsystem device id failed\n");
+			return -ENODEV;
+		}
+		hw->subsystem_device_id = (u16)ssid >> 8 | (u16)ssid << 8;
+	}
+
+	/* assign function pointers */
+	txgbe_init_ops_dummy(hw);
+	txgbe_init_ops(hw);
+
+	return 0;
+}
+
 static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 {
 	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
@@ -67,8 +145,9 @@ static int txgbe_probe(struct pci_dev *pdev,
 		       const struct pci_device_id __always_unused *ent)
 {
 	struct txgbe_adapter *adapter = NULL;
+	struct txgbe_hw *hw = NULL;
 	struct net_device *netdev;
-	int err;
+	int err, expected_gts;
 
 	err = pci_enable_device_mem(pdev);
 	if (err)
@@ -107,6 +186,8 @@ static int txgbe_probe(struct pci_dev *pdev,
 	adapter = netdev_priv(netdev);
 	adapter->netdev = netdev;
 	adapter->pdev = pdev;
+	hw = &adapter->hw;
+	adapter->msg_enable = (1 << DEFAULT_DEBUG_LEVEL_SHIFT) - 1;
 
 	adapter->io_addr = devm_ioremap(&pdev->dev,
 					pci_resource_start(pdev, 0),
@@ -115,11 +196,43 @@ static int txgbe_probe(struct pci_dev *pdev,
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
+	hw->mac.ops.set_lan_id(hw);
+
+	/* check if flash load is done after hw power up */
+	err = txgbe_check_flash_load(hw, TXGBE_SPI_ILDR_STATUS_PERST);
+	if (err)
+		goto err_pci_release_regions;
+	err = txgbe_check_flash_load(hw, TXGBE_SPI_ILDR_STATUS_PWRRST);
+	if (err)
+		goto err_pci_release_regions;
 
 	netdev->features |= NETIF_F_HIGHDMA;
 
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
+	else
+		dev_warn(&pdev->dev, "Failed to enumerate PF devices.\n");
+
 	return 0;
 
 err_pci_release_regions:
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index b2e329f50bae..3b1dd104373b 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -4,7 +4,9 @@
 #ifndef _TXGBE_TYPE_H_
 #define _TXGBE_TYPE_H_
 
+#include <linux/pci.h>
 #include <linux/types.h>
+#include <linux/iopoll.h>
 #include <linux/netdevice.h>
 
 /************ txgbe_register.h ************/
@@ -54,4 +56,153 @@
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
+
+/* Bus parameters */
+struct txgbe_bus_info {
+	u16 func;
+	u16 lan_id;
+};
+
+/* forward declaration */
+struct txgbe_hw;
+
+struct txgbe_mac_operations {
+	void (*set_lan_id)(struct txgbe_hw *hw);
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
+/**
+ * register operations
+ **/
+#define wr32(a, reg, value)	writel((value), ((a)->hw_addr + (reg)))
+#define rd32(a, reg)		readl((a)->hw_addr + (reg))
+
 #endif /* _TXGBE_TYPE_H_ */
-- 
2.27.0

