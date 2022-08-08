Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8977758C5CB
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 11:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242514AbiHHJmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 05:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242147AbiHHJmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 05:42:37 -0400
Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F921112
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 02:42:32 -0700 (PDT)
X-QQ-mid: bizesmtp74t1659951682tro8g3bm
Received: from roy-ThinkPad-T14-Gen-2a.trustne ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 08 Aug 2022 17:41:15 +0800 (CST)
X-QQ-SSF: 01400000002000L0K000B00A0000000
X-QQ-FEAT: jPZcZbXVCJd0q4S/LkeZ/lYTt65A7acgHYtH9I0AaQVN50/mAuKrtsXEXr210
        FyapvpAHdUsenmmzvrbi/WBZNEk31niWySgCiEjMstttKFk10mUZYQIX5EaI3nsqNAbJT3I
        n6wZJ/doKUW/ZjCqgaVRWUElXRzXGJxaU1P3vYUMDbW2nDP4yzFK6/odUz0IDtW7ytoC1xo
        WI1XuVlF56rcCgsftxE241MoLPEO5dtzddcXlCrNl0kQW8uNfBRYqsQKPHa3hNkNzWaF0ZC
        PDCshI7dYF6bThdjpfXwsMXhFycMCeejrT+OGcoKX8X/tmgCWzZDYE87DaaOIBV8Q1ApsGZ
        kLGs5WQlxfm78SUyhu7ZnHYdiTzalbUFbluXFZSAt19KF5w78Gr4Sm2gHivULA+tBlRbQJ2
        q6WtiLS6MEaps5zPGKs3bA==
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@net-swift.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next] net: ngbe: Add build support for ngbe
Date:   Mon,  8 Aug 2022 17:41:13 +0800
Message-Id: <20220808094113.9434-1-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add build options and guidance doc.
Initialize pci device access for Wangxun Gigabit Ethernet devices.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 .../device_drivers/ethernet/index.rst         |   1 +
 .../device_drivers/ethernet/wangxun/ngbe.rst  |  21 +++
 MAINTAINERS                                   |   4 +-
 drivers/net/ethernet/wangxun/Kconfig          |  13 ++
 drivers/net/ethernet/wangxun/Makefile         |   1 +
 drivers/net/ethernet/wangxun/ngbe/Makefile    |   9 +
 drivers/net/ethernet/wangxun/ngbe/ngbe.h      |  24 +++
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 173 ++++++++++++++++++
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  50 +++++
 9 files changed, 295 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/networking/device_drivers/ethernet/wangxun/ngbe.rst
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/Makefile
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe.h
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h

diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b/Documentation/networking/device_drivers/ethernet/index.rst
index 7f1777173abb..5196905582c5 100644
--- a/Documentation/networking/device_drivers/ethernet/index.rst
+++ b/Documentation/networking/device_drivers/ethernet/index.rst
@@ -52,6 +52,7 @@ Contents:
    ti/tlan
    toshiba/spider_net
    wangxun/txgbe
+   wangxun/ngbe
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/device_drivers/ethernet/wangxun/ngbe.rst b/Documentation/networking/device_drivers/ethernet/wangxun/ngbe.rst
new file mode 100644
index 000000000000..411768cfb257
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/wangxun/ngbe.rst
@@ -0,0 +1,21 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+================================================================
+Linux Base Driver for WangXun(R) Gigabit PCI Express Adapters
+================================================================
+
+WangXun Gigabit Linux driver.
+Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd.
+
+
+Contents
+========
+
+- Support
+
+
+Support
+=======
+ If you have problems with the software or hardware, please contact our
+ customer support team via email at nic-support@net-swift.com or check our website
+ at https://www.net-swift.com
diff --git a/MAINTAINERS b/MAINTAINERS
index 386178699ae7..13fcf6352138 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21677,9 +21677,11 @@ F:	drivers/input/tablet/wacom_serial4.c
 
 WANGXUN ETHERNET DRIVER
 M:	Jiawen Wu <jiawenwu@trustnetic.com>
+M:	Mengyuan Lou <mengyuanlou@net-swift.com>
+W:	https://www.net-swift.com
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
+F:	Documentation/networking/device_drivers/ethernet/wangxun/*
 F:	drivers/net/ethernet/wangxun/
 
 WATCHDOG DEVICE DRIVERS
diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index b4a4fa0a58f8..f5d43d8c9629 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -16,6 +16,19 @@ config NET_VENDOR_WANGXUN
 
 if NET_VENDOR_WANGXUN
 
+config NGBE
+	tristate "Wangxun(R) GbE PCI Express adapters support"
+	depends on PCI
+	help
+	  This driver supports Wangxun(R) GbE PCI Express family of
+	  adapters.
+
+	  More specific information on configuring the driver is in
+	  <file:Documentation/networking/device_drivers/ethernet/wangxun/ngbe.rst>.
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called ngbe.
+
 config TXGBE
 	tristate "Wangxun(R) 10GbE PCI Express adapters support"
 	depends on PCI
diff --git a/drivers/net/ethernet/wangxun/Makefile b/drivers/net/ethernet/wangxun/Makefile
index c34db1bead25..1193b4f738b8 100644
--- a/drivers/net/ethernet/wangxun/Makefile
+++ b/drivers/net/ethernet/wangxun/Makefile
@@ -4,3 +4,4 @@
 #
 
 obj-$(CONFIG_TXGBE) += txgbe/
+obj-$(CONFIG_TXGBE) += ngbe/
diff --git a/drivers/net/ethernet/wangxun/ngbe/Makefile b/drivers/net/ethernet/wangxun/ngbe/Makefile
new file mode 100644
index 000000000000..0baf75907496
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/ngbe/Makefile
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd.
+#
+# Makefile for the Wangxun(R) GbE PCI Express ethernet driver
+#
+
+obj-$(CONFIG_NGBE) += ngbe.o
+
+ngbe-objs := ngbe_main.o
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe.h b/drivers/net/ethernet/wangxun/ngbe/ngbe.h
new file mode 100644
index 000000000000..f5fa6e5238cc
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd. */
+
+#ifndef _NGBE_H_
+#define _NGBE_H_
+
+#include "ngbe_type.h"
+
+#define NGBE_MAX_FDIR_INDICES		7
+
+#define NGBE_MAX_RX_QUEUES		(NGBE_MAX_FDIR_INDICES + 1)
+#define NGBE_MAX_TX_QUEUES		(NGBE_MAX_FDIR_INDICES + 1)
+
+/* board specific private data structure */
+struct ngbe_adapter {
+	u8 __iomem *io_addr;    /* Mainly for iounmap use */
+	/* OS defined structs */
+	struct net_device *netdev;
+	struct pci_dev *pdev;
+};
+
+extern char ngbe_driver_name[];
+
+#endif /* _NGBE_H_ */
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
new file mode 100644
index 000000000000..05b418b6fe07
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -0,0 +1,173 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd. */
+
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/netdevice.h>
+#include <linux/string.h>
+#include <linux/aer.h>
+#include <linux/etherdevice.h>
+
+#include "ngbe.h"
+char ngbe_driver_name[] = "ngbe";
+
+/* ngbe_pci_tbl - PCI Device ID Table
+ *
+ * Wildcard entries (PCI_ANY_ID) should come last
+ * Last entry must be all 0s
+ *
+ * { Vendor ID, Device ID, SubVendor ID, SubDevice ID,
+ *   Class, Class Mask, private data (not used) }
+ */
+static const struct pci_device_id ngbe_pci_tbl[] = {
+	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860AL_W), 0},
+	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860A2), 0},
+	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860A2S), 0},
+	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860A4), 0},
+	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860A4S), 0},
+	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860AL2), 0},
+	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860AL2S), 0},
+	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860AL4), 0},
+	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860AL4S), 0},
+	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860LC), 0},
+	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860A1), 0},
+	{ PCI_VDEVICE(WANGXUN, NGBE_DEV_ID_EM_WX1860A1L), 0},
+	/* required last entry */
+	{ .device = 0 }
+};
+
+static void ngbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
+{
+	struct ngbe_adapter *adapter = pci_get_drvdata(pdev);
+	struct net_device *netdev = adapter->netdev;
+
+	netif_device_detach(netdev);
+
+	pci_disable_device(pdev);
+}
+
+static void ngbe_shutdown(struct pci_dev *pdev)
+{
+	bool wake;
+
+	ngbe_dev_shutdown(pdev, &wake);
+
+	if (system_state == SYSTEM_POWER_OFF) {
+		pci_wake_from_d3(pdev, wake);
+		pci_set_power_state(pdev, PCI_D3hot);
+	}
+}
+
+/**
+ * ngbe_probe - Device Initialization Routine
+ * @pdev: PCI device information struct
+ * @ent: entry in ngbe_pci_tbl
+ *
+ * Returns 0 on success, negative on failure
+ *
+ * ngbe_probe initializes an adapter identified by a pci_dev structure.
+ * The OS initialization, configuring of the adapter private structure,
+ * and a hardware reset occur.
+ **/
+static int ngbe_probe(struct pci_dev *pdev,
+		      const struct pci_device_id __always_unused *ent)
+{
+	struct ngbe_adapter *adapter = NULL;
+	struct net_device *netdev;
+	int err;
+
+	err = pci_enable_device_mem(pdev);
+	if (err)
+		return err;
+
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (err) {
+		dev_err(&pdev->dev,
+			"No usable DMA configuration, aborting\n");
+		goto err_pci_disable_dev;
+	}
+
+	err = pci_request_selected_regions(pdev,
+					   pci_select_bars(pdev, IORESOURCE_MEM),
+					   ngbe_driver_name);
+	if (err) {
+		dev_err(&pdev->dev,
+			"pci_request_selected_regions failed 0x%x\n", err);
+		goto err_pci_disable_dev;
+	}
+
+	pci_enable_pcie_error_reporting(pdev);
+	pci_set_master(pdev);
+
+	netdev = devm_alloc_etherdev_mqs(&pdev->dev,
+					 sizeof(struct ngbe_adapter),
+					 ngbe_MAX_TX_QUEUES,
+					 ngbe_MAX_RX_QUEUES);
+	if (!netdev) {
+		err = -ENOMEM;
+		goto err_pci_release_regions;
+	}
+
+	SET_NETDEV_DEV(netdev, &pdev->dev);
+
+	adapter = netdev_priv(netdev);
+	adapter->netdev = netdev;
+	adapter->pdev = pdev;
+
+	adapter->io_addr = devm_ioremap(&pdev->dev,
+					pci_resource_start(pdev, 0),
+					pci_resource_len(pdev, 0));
+	if (!adapter->io_addr) {
+		err = -EIO;
+		goto err_pci_release_regions;
+	}
+
+	netdev->features |= NETIF_F_HIGHDMA;
+
+	pci_set_drvdata(pdev, adapter);
+
+	return 0;
+
+err_pci_release_regions:
+	pci_disable_pcie_error_reporting(pdev);
+	pci_release_selected_regions(pdev,
+				     pci_select_bars(pdev, IORESOURCE_MEM));
+err_pci_disable_dev:
+	pci_disable_device(pdev);
+	return err;
+}
+
+/**
+ * ngbe_remove - Device Removal Routine
+ * @pdev: PCI device information struct
+ *
+ * ngbe_remove is called by the PCI subsystem to alert the driver
+ * that it should release a PCI device.  The could be caused by a
+ * Hot-Plug event, or because the driver is going to be removed from
+ * memory.
+ **/
+static void ngbe_remove(struct pci_dev *pdev)
+{
+	pci_release_selected_regions(pdev,
+				     pci_select_bars(pdev, IORESOURCE_MEM));
+
+	pci_disable_pcie_error_reporting(pdev);
+
+	pci_disable_device(pdev);
+}
+
+static struct pci_driver ngbe_driver = {
+	.name     = ngbe_driver_name,
+	.id_table = ngbe_pci_tbl,
+	.probe    = ngbe_probe,
+	.remove   = ngbe_remove,
+	.shutdown = ngbe_shutdown,
+};
+
+module_pci_driver(ngbe_driver);
+
+MODULE_DEVICE_TABLE(pci, ngbe_pci_tbl);
+MODULE_AUTHOR("Beijing WangXun Technology Co., Ltd, <software@net-swift.com>");
+MODULE_DESCRIPTION("WangXun(R) Gigabit PCI Express Network Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
new file mode 100644
index 000000000000..26e776c3539a
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd. */
+
+#ifndef _NGBE_TYPE_H_
+#define _NGBE_TYPE_H_
+
+#include <linux/types.h>
+#include <linux/netdevice.h>
+
+/************ NGBE_register.h ************/
+/* Vendor ID */
+#ifndef PCI_VENDOR_ID_WANGXUN
+#define PCI_VENDOR_ID_WANGXUN			0x8088
+#endif
+
+/* Device IDs */
+#define NGBE_DEV_ID_EM_WX1860AL_W		0x0100
+#define NGBE_DEV_ID_EM_WX1860A2			0x0101
+#define NGBE_DEV_ID_EM_WX1860A2S		0x0102
+#define NGBE_DEV_ID_EM_WX1860A4			0x0103
+#define NGBE_DEV_ID_EM_WX1860A4S		0x0104
+#define NGBE_DEV_ID_EM_WX1860AL2		0x0105
+#define NGBE_DEV_ID_EM_WX1860AL2S		0x0106
+#define NGBE_DEV_ID_EM_WX1860AL4		0x0107
+#define NGBE_DEV_ID_EM_WX1860AL4S		0x0108
+#define NGBE_DEV_ID_EM_WX1860LC			0x0109
+#define NGBE_DEV_ID_EM_WX1860A1			0x010a
+#define NGBE_DEV_ID_EM_WX1860A1L		0x010b
+
+/* Subsystem ID */
+#define NGBE_SUBID_M88E1512_SFP			0x0003
+#define NGBE_SUBID_OCP_CARD			0x0040
+#define NGBE_SUBID_LY_M88E1512_SFP		0x0050
+#define NGBE_SUBID_M88E1512_RJ45		0x0051
+#define NGBE_SUBID_M88E1512_MIX			0x0052
+#define NGBE_SUBID_YT8521S_SFP			0x0060
+#define NGBE_SUBID_INTERNAL_YT8521S_SFP		0x0061
+#define NGBE_SUBID_YT8521S_SFP_GPIO		0x0062
+#define NGBE_SUBID_INTERNAL_YT8521S_SFP_GPIO	0x0064
+#define NGBE_SUBID_LY_YT8521S_SFP		0x0070
+#define NGBE_SUBID_RGMII_FPGA			0x0080
+
+#define NGBE_OEM_MASK				0x00FF
+
+#define NGBE_NCSI_SUP				0x8000
+#define NGBE_NCSI_MASK				0x8000
+#define NGBE_WOL_SUP				0x4000
+#define NGBE_WOL_MASK				0x4000
+
+#endif /* _NGBE_TYPE_H_ */
-- 
2.25.1

