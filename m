Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09A96128977
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 15:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfLUOO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 09:14:58 -0500
Received: from smtp7.web4u.cz ([81.91.87.87]:51150 "EHLO mx-8.mail.web4u.cz"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726750AbfLUOO5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Dec 2019 09:14:57 -0500
Received: from mx-8.mail.web4u.cz (localhost [127.0.0.1])
        by mx-8.mail.web4u.cz (Postfix) with ESMTP id B58EE203724;
        Sat, 21 Dec 2019 15:08:29 +0100 (CET)
Received: from thor.pikron.com (unknown [89.102.8.6])
        (Authenticated sender: ppisa@pikron.com)
        by mx-8.mail.web4u.cz (Postfix) with ESMTPA id 3A29D203723;
        Sat, 21 Dec 2019 15:08:29 +0100 (CET)
From:   pisa@cmp.felk.cvut.cz
To:     devicetree@vger.kernel.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org, socketcan@hartkopp.net
Cc:     wg@grandegger.com, davem@davemloft.net, robh+dt@kernel.org,
        mark.rutland@arm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.jerabek01@gmail.com,
        ondrej.ille@gmail.com, jnovak@fel.cvut.cz, jara.beran@gmail.com,
        porazil@pikron.com, Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: [PATCH v3 4/6] can: ctucanfd: CTU CAN FD open-source IP core - PCI bus support.
Date:   Sat, 21 Dec 2019 15:07:33 +0100
Message-Id: <6c75829bb1015a562c3afb6babd0cd49be0c8125.1576922226.git.pisa@cmp.felk.cvut.cz>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
References: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
In-Reply-To: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
References: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
X-W4U-Auth: bb93f36ce79e9490b23628aed83a8bdb1aca1ede
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Pisa <pisa@cmp.felk.cvut.cz>

PCI bus adaptation for CTU CAN FD open-source IP core.

The project providing FPGA design for Intel EP4CGX15 based DB4CGX15
PCIe board with PiKRON.com designed transceiver riser shield is available
at https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd .

Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Signed-off-by: Martin Jerabek <martin.jerabek01@gmail.com>
Signed-off-by: Ondrej Ille <ondrej.ille@gmail.com>
---
 drivers/net/can/ctucanfd/Kconfig          |   9 +
 drivers/net/can/ctucanfd/Makefile         |   3 +
 drivers/net/can/ctucanfd/ctu_can_fd_pci.c | 316 ++++++++++++++++++++++++++++++
 3 files changed, 328 insertions(+)
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd_pci.c

diff --git a/drivers/net/can/ctucanfd/Kconfig b/drivers/net/can/ctucanfd/Kconfig
index a3b65088c9f7..798040e9bcef 100644
--- a/drivers/net/can/ctucanfd/Kconfig
+++ b/drivers/net/can/ctucanfd/Kconfig
@@ -15,4 +15,13 @@ config CAN_CTUCANFD
 
 if CAN_CTUCANFD
 
+config CAN_CTUCANFD_PCI
+    tristate "CTU CAN-FD IP core PCI/PCIe driver"
+    depends on PCI
+	---help---
+	  This driver adds PCI/PCIe support for CTU CAN-FD IP core.
+	  The project providing FPGA design for Intel EP4CGX15 based DB4CGX15
+	  PCIe board with PiKRON.com designed transceiver riser shield is available
+	  at https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd .
+
 endif
diff --git a/drivers/net/can/ctucanfd/Makefile b/drivers/net/can/ctucanfd/Makefile
index 8d47008d0076..eb945260952d 100644
--- a/drivers/net/can/ctucanfd/Makefile
+++ b/drivers/net/can/ctucanfd/Makefile
@@ -5,3 +5,6 @@
 
 obj-$(CONFIG_CAN_CTUCANFD) := ctucanfd.o
 ctucanfd-y := ctu_can_fd.o ctu_can_fd_hw.o
+
+obj-$(CONFIG_CAN_CTUCANFD_PCI) += ctucanfd_pci.o
+ctucanfd_pci-y := ctu_can_fd_pci.o
diff --git a/drivers/net/can/ctucanfd/ctu_can_fd_pci.c b/drivers/net/can/ctucanfd/ctu_can_fd_pci.c
new file mode 100644
index 000000000000..beecbbd341a3
--- /dev/null
+++ b/drivers/net/can/ctucanfd/ctu_can_fd_pci.c
@@ -0,0 +1,316 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*******************************************************************************
+ *
+ * CTU CAN FD IP Core
+ * Copyright (C) 2015-2018
+ *
+ * Authors:
+ *     Ondrej Ille <ondrej.ille@gmail.com>
+ *     Martin Jerabek <martin.jerabek01@gmail.com>
+ *     Jaroslav Beran <jara.beran@gmail.com>
+ *
+ * Project advisors:
+ *     Jiri Novak <jnovak@fel.cvut.cz>
+ *     Pavel Pisa <pisa@cmp.felk.cvut.cz>
+ *
+ * Department of Measurement         (http://meas.fel.cvut.cz/)
+ * Faculty of Electrical Engineering (http://www.fel.cvut.cz)
+ * Czech Technical University        (http://www.cvut.cz/)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ ******************************************************************************/
+
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include "ctu_can_fd.h"
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Martin Jerabek");
+MODULE_DESCRIPTION("CTU CAN FD for PCI bus");
+
+#define DRV_NAME	"ctucanfd_pci"
+
+#ifndef PCI_DEVICE_DATA
+#define PCI_DEVICE_DATA(vend, dev, data) \
+.vendor = PCI_VENDOR_ID_##vend, \
+.device = PCI_DEVICE_ID_##vend##_##dev, \
+.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID, 0, 0, \
+.driver_data = (kernel_ulong_t)(data)
+#endif
+#ifndef PCI_VENDOR_ID_TEDIA
+#define PCI_VENDOR_ID_TEDIA 0x1760
+#endif
+
+#define PCI_DEVICE_ID_ALTERA_CTUCAN_TEST  0xCAFD
+#define PCI_DEVICE_ID_TEDIA_CTUCAN_VER21 0xff00
+
+#define CTUCAN_BAR0_CTUCAN_ID 0x0000
+#define CTUCAN_BAR0_CRA_BASE  0x4000
+#define CYCLONE_IV_CRA_A2P_IE (0x0050)
+
+#define CTUCAN_WITHOUT_CTUCAN_ID  0
+#define CTUCAN_WITH_CTUCAN_ID     1
+
+static bool use_msi = 1;
+module_param(use_msi, bool, 0444);
+MODULE_PARM_DESC(use_msi, "PCIe implementation use MSI interrupts. Default: 1 (yes)");
+
+static bool pci_use_second = 1;
+module_param(pci_use_second, bool, 0444);
+MODULE_PARM_DESC(pci_use_second, "Use the second CAN core on PCIe card. Default: 1 (yes)");
+
+struct ctucan_pci_board_data {
+	void __iomem *bar0_base;
+	void __iomem *cra_base;
+	void __iomem *bar1_base;
+	struct list_head ndev_list_head;
+	int use_msi;
+};
+
+struct ctucan_pci_board_data *ctucan_pci_get_bdata(struct pci_dev *pdev)
+{
+	return (struct ctucan_pci_board_data *)pci_get_drvdata(pdev);
+}
+
+static void ctucan_pci_set_drvdata(struct device *dev,
+				   struct net_device *ndev)
+{
+	struct pci_dev *pdev = container_of(dev, struct pci_dev, dev);
+	struct ctucan_priv *priv = netdev_priv(ndev);
+	struct ctucan_pci_board_data *bdata = ctucan_pci_get_bdata(pdev);
+
+	list_add(&priv->peers_on_pdev, &bdata->ndev_list_head);
+	priv->irq_flags = IRQF_SHARED;
+}
+
+/**
+ * ctucan_pci_probe - PCI registration call
+ * @pdev:	Handle to the pci device structure
+ * @ent:	Pointer to the entry from ctucan_pci_tbl
+ *
+ * This function does all the memory allocation and registration for the CAN
+ * device.
+ *
+ * Return: 0 on success and failure value on error
+ */
+static int ctucan_pci_probe(struct pci_dev *pdev,
+			    const struct pci_device_id *ent)
+{
+	struct device	*dev = &pdev->dev;
+	unsigned long driver_data = ent->driver_data;
+	struct ctucan_pci_board_data *bdata;
+	void __iomem *addr;
+	void __iomem *cra_addr;
+	void __iomem *bar0_base;
+	u32 cra_a2p_ie;
+	u32 ctucan_id = 0;
+	int ret;
+	unsigned int ntxbufs;
+	unsigned int num_cores = 1;
+	unsigned int core_i = 0;
+	int irq;
+	int msi_ok = 0;
+
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_err(dev, "pci_enable_device FAILED\n");
+		goto err;
+	}
+
+	ret = pci_request_regions(pdev, KBUILD_MODNAME);
+	if (ret) {
+		dev_err(dev, "pci_request_regions FAILED\n");
+		goto err_disable_device;
+	}
+
+	if (use_msi) {
+		ret = pci_enable_msi(pdev);
+		if (!ret) {
+			dev_info(dev, "MSI enabled\n");
+			pci_set_master(pdev);
+			msi_ok = 1;
+		}
+	}
+
+	dev_info(dev, "ctucan BAR0 0x%08llx 0x%08llx\n",
+			 (long long)pci_resource_start(pdev, 0),
+			 (long long)pci_resource_len(pdev, 0));
+
+	dev_info(dev, "ctucan BAR1 0x%08llx 0x%08llx\n",
+			 (long long)pci_resource_start(pdev, 1),
+			 (long long)pci_resource_len(pdev, 1));
+
+	addr = pci_iomap(pdev, 1, pci_resource_len(pdev, 1));
+	if (!addr) {
+		dev_err(dev, "PCI BAR 1 cannot be mapped\n");
+		ret = -ENOMEM;
+		goto err_release_regions;
+	}
+
+	/* Cyclone IV PCI Express Control Registers Area */
+	bar0_base = pci_iomap(pdev, 0, pci_resource_len(pdev, 0));
+	if (!bar0_base) {
+		dev_err(dev, "PCI BAR 0 cannot be mapped\n");
+		ret = -EIO;
+		goto err_pci_iounmap_bar1;
+	}
+
+	if (driver_data == CTUCAN_WITHOUT_CTUCAN_ID) {
+		cra_addr = bar0_base;
+		num_cores = 2;
+	} else {
+		cra_addr = (char *)bar0_base + CTUCAN_BAR0_CRA_BASE;
+		ctucan_id = ioread32((char *)bar0_base + CTUCAN_BAR0_CTUCAN_ID);
+		dev_info(dev, "ctucan_id 0x%08lx\n", (unsigned long)ctucan_id);
+		num_cores = ctucan_id & 0xf;
+	}
+
+	irq = pdev->irq;
+
+	ntxbufs = 4;
+
+	bdata = kzalloc(sizeof(*bdata), GFP_KERNEL);
+	if (!bdata) {
+		ret = -ENOMEM;
+		goto err_pci_iounmap_bar0;
+	}
+
+	INIT_LIST_HEAD(&bdata->ndev_list_head);
+	bdata->bar0_base = bar0_base;
+	bdata->cra_base = cra_addr;
+	bdata->bar1_base = addr;
+	bdata->use_msi = msi_ok;
+
+	pci_set_drvdata(pdev, bdata);
+
+	ret = ctucan_probe_common(dev, addr, irq, ntxbufs, 100000000,
+							  0, ctucan_pci_set_drvdata);
+	if (ret < 0)
+		goto err_free_board;
+
+	core_i++;
+
+	while (pci_use_second && (core_i < num_cores)) {
+		addr += 0x4000;
+		ret = ctucan_probe_common(dev, addr, irq, ntxbufs, 100000000,
+								  0, ctucan_pci_set_drvdata);
+		if (ret < 0) {
+			dev_info(dev, "CTU CAN FD core %d initialization failed\n",
+					 core_i);
+			break;
+		}
+		core_i++;
+	}
+
+	/* enable interrupt in
+	 * Avalon-MM to PCI Express Interrupt Enable Register
+	 */
+	cra_a2p_ie = ioread32((char *)cra_addr + CYCLONE_IV_CRA_A2P_IE);
+	dev_info(dev, "cra_a2p_ie 0x%08x\n", cra_a2p_ie);
+	cra_a2p_ie |= 1;
+	iowrite32(cra_a2p_ie, (char *)cra_addr + CYCLONE_IV_CRA_A2P_IE);
+	cra_a2p_ie = ioread32((char *)cra_addr + CYCLONE_IV_CRA_A2P_IE);
+	dev_info(dev, "cra_a2p_ie 0x%08x\n", cra_a2p_ie);
+
+	return 0;
+
+err_free_board:
+	pci_set_drvdata(pdev, NULL);
+	kfree(bdata);
+err_pci_iounmap_bar0:
+	pci_iounmap(pdev, cra_addr);
+err_pci_iounmap_bar1:
+	pci_iounmap(pdev, addr);
+err_release_regions:
+	if (msi_ok) {
+		pci_disable_msi(pdev);
+		pci_clear_master(pdev);
+	}
+	pci_release_regions(pdev);
+err_disable_device:
+	pci_disable_device(pdev);
+err:
+	return ret;
+}
+
+/**
+ * ctucan_pci_remove - Unregister the device after releasing the resources
+ * @pdev:	Handle to the pci device structure
+ *
+ * This function frees all the resources allocated to the device.
+ * Return: 0 always
+ */
+static void ctucan_pci_remove(struct pci_dev *pdev)
+{
+	struct net_device *ndev;
+	struct ctucan_priv *priv = NULL;
+	struct ctucan_pci_board_data *bdata = ctucan_pci_get_bdata(pdev);
+
+	dev_dbg(&pdev->dev, "ctucan_remove");
+
+	if (!bdata) {
+		dev_err(&pdev->dev, "%s: no list of devices\n", __func__);
+		return;
+	}
+
+	/* disable interrupt in
+	 * Avalon-MM to PCI Express Interrupt Enable Register
+	 */
+	if (bdata->cra_base)
+		iowrite32(0, (char *)bdata->cra_base + CYCLONE_IV_CRA_A2P_IE);
+
+	while ((priv = list_first_entry_or_null(&bdata->ndev_list_head,
+		struct ctucan_priv, peers_on_pdev)) != NULL) {
+		ndev = priv->can.dev;
+
+		unregister_candev(ndev);
+
+		netif_napi_del(&priv->napi);
+
+		list_del_init(&priv->peers_on_pdev);
+		free_candev(ndev);
+	}
+
+	pci_iounmap(pdev, bdata->bar1_base);
+
+	if (bdata->use_msi) {
+		pci_disable_msi(pdev);
+		pci_clear_master(pdev);
+	}
+
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+
+	pci_iounmap(pdev, bdata->bar0_base);
+
+	pci_set_drvdata(pdev, NULL);
+	kfree(bdata);
+}
+
+static SIMPLE_DEV_PM_OPS(ctucan_pci_pm_ops, ctucan_suspend, ctucan_resume);
+
+static const struct pci_device_id ctucan_pci_tbl[] = {
+	{PCI_DEVICE_DATA(TEDIA, CTUCAN_VER21,
+		CTUCAN_WITH_CTUCAN_ID)},
+	{},
+};
+
+static struct pci_driver ctucan_pci_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = ctucan_pci_tbl,
+	.probe = ctucan_pci_probe,
+	.remove = ctucan_pci_remove,
+	.driver.pm = &ctucan_pci_pm_ops,
+};
+
+module_pci_driver(ctucan_pci_driver);
+
-- 
2.11.0

