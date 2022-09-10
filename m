Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF4E5B453F
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 10:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiIJIfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 04:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiIJIfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 04:35:40 -0400
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84B54E841
        for <netdev@vger.kernel.org>; Sat, 10 Sep 2022 01:35:29 -0700 (PDT)
X-QQ-mid: bizesmtp75t1662798924t1hghdar
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 10 Sep 2022 16:35:13 +0800 (CST)
X-QQ-SSF: 01400000002000G0T000B00A0000000
X-QQ-FEAT: yVkZs+QEHHvXw3QCd9Xn4EyBkl2azs+CnhHmbPAGc+p82dh+A2MtvU/j/KbQd
        ybEeIw8NaYtA3iapipRMafrylQbSpwhJsErTD3pF2E3Q35Fbfu0lyJBl6uXJMCWH5l9F7s9
        EduVjUmRCIY4kubBwybL93e6q5/AJUhuoZd3NUZcagxn37vSpmnAOBy7JuDS7jDRdi5sGF0
        0Wn1++HDEi2N+xAoEnhFzX4fB8DVDa6ITsMiT26gzndGsCgBhHaLSGwt99AyIuIqYLmmHQ5
        2koWOgt07FjlPbXpxBJ89z+n+nzweugUCt6i+QHwii52hUTqP067eN2O7cHD3cowDb0TTiY
        z8FC2qkLt3MIE9RQpLn6NnpSNYtLtD1crv7H4m5VmWCrh+Tg2bNpEfC+JNlrw==
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [RFC PATCH net-next] net: txgbe: Store PCI info
Date:   Sat, 10 Sep 2022 16:45:40 +0800
Message-Id: <20220910084540.83610-1-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get PCI config space info, set LAN id and check flash status.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
RFC patch for Wangxun txgbe driver.
Since there was some shared code with ngbe driver, move it to libwx.
Please review that it is the correct way to do it.

 drivers/net/ethernet/wangxun/Kconfig          |  7 ++
 drivers/net/ethernet/wangxun/Makefile         |  1 +
 drivers/net/ethernet/wangxun/libwx/Makefile   |  7 ++
 drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 99 +++++++++++++++++++
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    | 10 ++
 drivers/net/ethernet/wangxun/libwx/wx_type.h  | 58 +++++++++++
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  4 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 98 +++++++++++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   | 13 +--
 9 files changed, 287 insertions(+), 10 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/libwx/Makefile
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_hw.c
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_hw.h
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_type.h

diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index f5d43d8c9629..abd4b62253cd 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -16,6 +16,12 @@ config NET_VENDOR_WANGXUN
 
 if NET_VENDOR_WANGXUN
 
+config LIBWX
+	tristate
+	default y
+	help
+	Common library for Wangxun(R) Ethernet drivers.
+
 config NGBE
 	tristate "Wangxun(R) GbE PCI Express adapters support"
 	depends on PCI
@@ -32,6 +38,7 @@ config NGBE
 config TXGBE
 	tristate "Wangxun(R) 10GbE PCI Express adapters support"
 	depends on PCI
+	select LIBWX
 	help
 	  This driver supports Wangxun(R) 10GbE PCI Express family of
 	  adapters.
diff --git a/drivers/net/ethernet/wangxun/Makefile b/drivers/net/ethernet/wangxun/Makefile
index ac3fb06b233c..ca19311dbe38 100644
--- a/drivers/net/ethernet/wangxun/Makefile
+++ b/drivers/net/ethernet/wangxun/Makefile
@@ -3,5 +3,6 @@
 # Makefile for the Wangxun network device drivers.
 #
 
+obj-$(CONFIG_LIBWX) += libwx/
 obj-$(CONFIG_TXGBE) += txgbe/
 obj-$(CONFIG_NGBE) += ngbe/
diff --git a/drivers/net/ethernet/wangxun/libwx/Makefile b/drivers/net/ethernet/wangxun/libwx/Makefile
new file mode 100644
index 000000000000..1ed5e23af944
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/libwx/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd.
+#
+
+obj-$(CONFIG_LIBWX) += libwx.o
+
+libwx-objs := wx_hw.o
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
new file mode 100644
index 000000000000..790fcee4408e
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -0,0 +1,99 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd. */
+
+#include <linux/iopoll.h>
+#include <linux/pci.h>
+
+#include "wx_type.h"
+#include "wx_hw.h"
+
+/* cmd_addr is used for some special command:
+ * 1. to be sector address, when implemented erase sector command
+ * 2. to be flash address when implemented read, write flash address
+ */
+static int wx_fmgr_cmd_op(struct wx_hw *wxhw, u32 cmd, u32 cmd_addr)
+{
+	u32 cmd_val = 0, val = 0;
+
+	cmd_val = WX_SPI_CMD_CMD(cmd) |
+		  WX_SPI_CMD_CLK(WX_SPI_CLK_DIV) |
+		  cmd_addr;
+	wr32(wxhw, WX_SPI_CMD, cmd_val);
+
+	return read_poll_timeout(rd32, val, (val & 0x1), 10, 100000,
+				 false, wxhw, WX_SPI_STATUS);
+}
+
+static int wx_flash_read_dword(struct wx_hw *wxhw, u32 addr, u32 *data)
+{
+	int ret = 0;
+
+	ret = wx_fmgr_cmd_op(wxhw, WX_SPI_CMD_READ_DWORD, addr);
+	if (ret < 0)
+		return ret;
+
+	*data = rd32(wxhw, WX_SPI_DATA);
+
+	return ret;
+}
+
+static int wx_check_flash_load(struct wx_hw *hw, u32 check_bit)
+{
+	u32 reg = 0;
+	int err = 0;
+
+	/* if there's flash existing */
+	if (!(rd32(hw, WX_SPI_STATUS) &
+	      WX_SPI_STATUS_FLASH_BYPASS)) {
+		/* wait hw load flash done */
+		err = read_poll_timeout(rd32, reg, !(reg & check_bit), 20000, 2000000,
+					false, hw, WX_SPI_ILDR_STATUS);
+		if (err < 0)
+			wx_err(hw, "Check flash load timeout.\n");
+	}
+
+	return err;
+}
+
+int wx_flash_load(struct wx_hw *wxhw)
+{
+	int err = 0;
+
+	err = wx_check_flash_load(wxhw, WX_SPI_ILDR_STATUS_PERST);
+	if (err)
+		return err;
+
+	return wx_check_flash_load(wxhw, WX_SPI_ILDR_STATUS_PWRRST);
+}
+EXPORT_SYMBOL(wx_flash_load);
+
+int wx_sw_init(struct wx_hw *wxhw)
+{
+	struct pci_dev *pdev = wxhw->pdev;
+	u32 ssid = 0;
+	int err = 0;
+
+	wxhw->vendor_id = pdev->vendor;
+	wxhw->device_id = pdev->device;
+	wxhw->revision_id = pdev->revision;
+	wxhw->oem_svid = pdev->subsystem_vendor;
+	wxhw->oem_ssid = pdev->subsystem_device;
+	wxhw->bus.device = PCI_SLOT(pdev->devfn);
+	wxhw->bus.func = PCI_FUNC(pdev->devfn);
+
+	if (wxhw->oem_svid == PCI_VENDOR_ID_WANGXUN) {
+		wxhw->subsystem_vendor_id = pdev->subsystem_vendor;
+		wxhw->subsystem_device_id = pdev->subsystem_device;
+	} else {
+		err = wx_flash_read_dword(wxhw, 0xfffdc, &ssid);
+		if (!err)
+			wxhw->subsystem_device_id = swab16((u16)ssid);
+
+		return err;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(wx_sw_init);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.h b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
new file mode 100644
index 000000000000..db7df2a87b58
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd. */
+
+#ifndef _WX_HW_H_
+#define _WX_HW_H_
+
+int wx_flash_load(struct wx_hw *wxhw);
+int wx_sw_init(struct wx_hw *wxhw);
+
+#endif /* _WX_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
new file mode 100644
index 000000000000..ade542ffe2e6
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd. */
+
+#ifndef _WX_TYPE_H_
+#define _WX_TYPE_H_
+
+/* Vendor ID */
+#ifndef PCI_VENDOR_ID_WANGXUN
+#define PCI_VENDOR_ID_WANGXUN                   0x8088
+#endif
+
+/* FMGR Registers */
+#define WX_SPI_CMD                   0x10104
+#define WX_SPI_CMD_READ_DWORD        0x1
+#define WX_SPI_CLK_DIV               0x3
+#define WX_SPI_CMD_CMD(_v)           (((_v) & 0x7) << 28)
+#define WX_SPI_CMD_CLK(_v)           (((_v) & 0x7) << 25)
+#define WX_SPI_CMD_ADDR(_v)          (((_v) & 0xFFFFFF))
+#define WX_SPI_DATA                  0x10108
+#define WX_SPI_DATA_BYPASS           BIT(31)
+#define WX_SPI_DATA_STATUS(_v)       (((_v) & 0xFF) << 16)
+#define WX_SPI_DATA_OP_DONE          BIT(0)
+#define WX_SPI_STATUS                0x1010C
+#define WX_SPI_STATUS_OPDONE         BIT(0)
+#define WX_SPI_STATUS_FLASH_BYPASS   BIT(31)
+#define WX_SPI_ILDR_STATUS           0x10120
+#define WX_SPI_ILDR_STATUS_PERST     BIT(0) /* PCIE_PERST is done */
+#define WX_SPI_ILDR_STATUS_PWRRST    BIT(1) /* Power on reset is done */
+
+/* Bus parameters */
+struct wx_bus_info {
+	u8 func;
+	u16 device;
+};
+
+struct wx_hw {
+	u8 __iomem *hw_addr;
+	struct pci_dev *pdev;
+	struct wx_bus_info bus;
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
+#define wx_err(wxhw, fmt, arg...) \
+	dev_err(&(wxhw)->pdev->dev, fmt, ##arg)
+
+#endif /* _WX_TYPE_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 38ddbde0ed0f..9a97b85be3ac 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -17,6 +17,10 @@ struct txgbe_adapter {
 	/* OS defined structs */
 	struct net_device *netdev;
 	struct pci_dev *pdev;
+
+	/* structs defined in txgbe_type.h */
+	struct txgbe_hw hw;
+	u16 msg_enable;
 };
 
 extern char txgbe_driver_name[];
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index d3b9f73ecba4..8d8b69d9b854 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -9,6 +9,8 @@
 #include <linux/aer.h>
 #include <linux/etherdevice.h>
 
+#include "../libwx/wx_type.h"
+#include "../libwx/wx_hw.h"
 #include "txgbe.h"
 
 char txgbe_driver_name[] = "txgbe";
@@ -30,6 +32,69 @@ static const struct pci_device_id txgbe_pci_tbl[] = {
 
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
+	struct wx_hw *wxhw = &hw->wxhw;
+	int err;
+
+	wxhw->hw_addr = adapter->io_addr;
+	wxhw->pdev = pdev;
+
+	/* PCI config space info */
+	err = wx_sw_init(wxhw);
+	if (err < 0) {
+		netif_err(adapter, probe, adapter->netdev,
+			  "read of internal subsystem device id failed\n");
+		return err;
+	}
+
+	return 0;
+}
+
 static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 {
 	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
@@ -67,8 +132,10 @@ static int txgbe_probe(struct pci_dev *pdev,
 		       const struct pci_device_id __always_unused *ent)
 {
 	struct txgbe_adapter *adapter = NULL;
+	struct txgbe_hw *hw = NULL;
+	struct wx_hw *wxhw = NULL;
 	struct net_device *netdev;
-	int err;
+	int err, expected_gts;
 
 	err = pci_enable_device_mem(pdev);
 	if (err)
@@ -107,6 +174,9 @@ static int txgbe_probe(struct pci_dev *pdev,
 	adapter = netdev_priv(netdev);
 	adapter->netdev = netdev;
 	adapter->pdev = pdev;
+	hw = &adapter->hw;
+	wxhw = &hw->wxhw;
+	adapter->msg_enable = (1 << DEFAULT_DEBUG_LEVEL_SHIFT) - 1;
 
 	adapter->io_addr = devm_ioremap(&pdev->dev,
 					pci_resource_start(pdev, 0),
@@ -116,10 +186,36 @@ static int txgbe_probe(struct pci_dev *pdev,
 		goto err_pci_release_regions;
 	}
 
+	strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
+
+	/* setup the private structure */
+	err = txgbe_sw_init(adapter);
+	if (err)
+		goto err_pci_release_regions;
+
+	/* check if flash load is done after hw power up */
+	err = wx_flash_load(wxhw);
+	if (err)
+		goto err_pci_release_regions;
+
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
index b2e329f50bae..0d9406c99e31 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -4,15 +4,6 @@
 #ifndef _TXGBE_TYPE_H_
 #define _TXGBE_TYPE_H_
 
-#include <linux/types.h>
-#include <linux/netdevice.h>
-
-/************ txgbe_register.h ************/
-/* Vendor ID */
-#ifndef PCI_VENDOR_ID_WANGXUN
-#define PCI_VENDOR_ID_WANGXUN                   0x8088
-#endif
-
 /* Device IDs */
 #define TXGBE_DEV_ID_SP1000                     0x1001
 #define TXGBE_DEV_ID_WX1820                     0x2001
@@ -54,4 +45,8 @@
 /* Revision ID */
 #define TXGBE_SP_MPW  1
 
+struct txgbe_hw {
+	struct wx_hw wxhw;
+};
+
 #endif /* _TXGBE_TYPE_H_ */
-- 
2.27.0

