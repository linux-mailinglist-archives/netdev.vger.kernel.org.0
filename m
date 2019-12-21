Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF62128969
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 15:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfLUOPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 09:15:02 -0500
Received: from smtp7.web4u.cz ([81.91.87.87]:51180 "EHLO mx-8.mail.web4u.cz"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727109AbfLUOPB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Dec 2019 09:15:01 -0500
Received: from mx-8.mail.web4u.cz (localhost [127.0.0.1])
        by mx-8.mail.web4u.cz (Postfix) with ESMTP id 1B327203722;
        Sat, 21 Dec 2019 15:08:33 +0100 (CET)
Received: from thor.pikron.com (unknown [89.102.8.6])
        (Authenticated sender: ppisa@pikron.com)
        by mx-8.mail.web4u.cz (Postfix) with ESMTPA id B547D2036EA;
        Sat, 21 Dec 2019 15:08:32 +0100 (CET)
From:   pisa@cmp.felk.cvut.cz
To:     devicetree@vger.kernel.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org, socketcan@hartkopp.net
Cc:     wg@grandegger.com, davem@davemloft.net, robh+dt@kernel.org,
        mark.rutland@arm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.jerabek01@gmail.com,
        ondrej.ille@gmail.com, jnovak@fel.cvut.cz, jara.beran@gmail.com,
        porazil@pikron.com, Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: [PATCH v3 5/6] can: ctucanfd: CTU CAN FD open-source IP core - platform/SoC support.
Date:   Sat, 21 Dec 2019 15:07:34 +0100
Message-Id: <35776e315ff29fba5416b17f83168f2f32da5b99.1576922226.git.pisa@cmp.felk.cvut.cz>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
References: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
In-Reply-To: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
References: <cover.1576922226.git.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-W4U-Auth: f74faddb69f87e885e46213eceaf79559e6df833
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Pisa <pisa@cmp.felk.cvut.cz>

Platform bus adaptation for CTU CAN FD open-source IP core.

The core has been tested together with OpenCores SJA1000
modified to be CAN FD frames tolerant on MicroZed Zynq based
MZ_APO education kits designed by Petr Porazil from PiKRON.com
company. FPGA design https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top.
The kit description at the Computer Architectures course pages
https://cw.fel.cvut.cz/b182/courses/b35apo/documentation/mz_apo/start .

The work is documented in Martin Jeřábek's diploma theses
Open-source and Open-hardware CAN FD Protocol Support
https://dspace.cvut.cz/handle/10467/80366
.

Signed-off-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Signed-off-by: Martin Jerabek <martin.jerabek01@gmail.com>
Signed-off-by: Ondrej Ille <ondrej.ille@gmail.com>
---
 drivers/net/can/ctucanfd/Kconfig               |  11 ++
 drivers/net/can/ctucanfd/Makefile              |   3 +
 drivers/net/can/ctucanfd/ctu_can_fd_platform.c | 145 +++++++++++++++++++++++++
 3 files changed, 159 insertions(+)
 create mode 100644 drivers/net/can/ctucanfd/ctu_can_fd_platform.c

diff --git a/drivers/net/can/ctucanfd/Kconfig b/drivers/net/can/ctucanfd/Kconfig
index 798040e9bcef..c5b7c000fbb3 100644
--- a/drivers/net/can/ctucanfd/Kconfig
+++ b/drivers/net/can/ctucanfd/Kconfig
@@ -24,4 +24,15 @@ config CAN_CTUCANFD_PCI
 	  PCIe board with PiKRON.com designed transceiver riser shield is available
 	  at https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd .
 
+config CAN_CTUCANFD_PLATFORM
+	tristate "CTU CAN-FD IP core platform (FPGA, SoC) driver"
+	depends on OF
+	---help---
+	  The core has been tested together with OpenCores SJA1000
+	  modified to be CAN FD frames tolerant on MicroZed Zynq based
+	  MZ_APO education kits designed by Petr Porazil from PiKRON.com
+	  company. FPGA design https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top.
+	  The kit description at the Computer Architectures course pages
+	  https://cw.fel.cvut.cz/b182/courses/b35apo/documentation/mz_apo/start .
+
 endif
diff --git a/drivers/net/can/ctucanfd/Makefile b/drivers/net/can/ctucanfd/Makefile
index eb945260952d..a77ca72d534e 100644
--- a/drivers/net/can/ctucanfd/Makefile
+++ b/drivers/net/can/ctucanfd/Makefile
@@ -8,3 +8,6 @@ ctucanfd-y := ctu_can_fd.o ctu_can_fd_hw.o
 
 obj-$(CONFIG_CAN_CTUCANFD_PCI) += ctucanfd_pci.o
 ctucanfd_pci-y := ctu_can_fd_pci.o
+
+obj-$(CONFIG_CAN_CTUCANFD_PLATFORM) += ctucanfd_platform.o
+ctucanfd_platform-y += ctu_can_fd_platform.o
diff --git a/drivers/net/can/ctucanfd/ctu_can_fd_platform.c b/drivers/net/can/ctucanfd/ctu_can_fd_platform.c
new file mode 100644
index 000000000000..53ec3c9f8ec2
--- /dev/null
+++ b/drivers/net/can/ctucanfd/ctu_can_fd_platform.c
@@ -0,0 +1,145 @@
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
+#include <linux/netdevice.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+
+#include "ctu_can_fd.h"
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Martin Jerabek");
+MODULE_DESCRIPTION("CTU CAN FD for platform");
+
+#define DRV_NAME	"ctucanfd"
+
+static void ctucan_platform_set_drvdata(struct device *dev,
+					struct net_device *ndev)
+{
+	struct platform_device *pdev = container_of(dev, struct platform_device,
+						    dev);
+
+	platform_set_drvdata(pdev, ndev);
+}
+
+/**
+ * ctucan_platform_probe - Platform registration call
+ * @pdev:	Handle to the platform device structure
+ *
+ * This function does all the memory allocation and registration for the CAN
+ * device.
+ *
+ * Return: 0 on success and failure value on error
+ */
+static int ctucan_platform_probe(struct platform_device *pdev)
+{
+	struct resource *res; /* IO mem resources */
+	struct device	*dev = &pdev->dev;
+	void __iomem *addr;
+	int ret;
+	unsigned int ntxbufs;
+	int irq;
+
+	/* Get the virtual base address for the device */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	addr = devm_ioremap_resource(dev, res);
+	if (IS_ERR(addr)) {
+		dev_err(dev, "Cannot remap address.\n");
+		ret = PTR_ERR(addr);
+		goto err;
+	}
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(dev, "Cannot find interrupt.\n");
+		ret = irq;
+		goto err;
+	}
+
+	/* Number of tx bufs might be change in HW for future. If so,
+	 * it will be passed as property via device tree
+	 */
+	ntxbufs = 4;
+	ret = ctucan_probe_common(dev, addr, irq, ntxbufs, 0,
+				  1, ctucan_platform_set_drvdata);
+
+	if (ret < 0)
+		platform_set_drvdata(pdev, NULL);
+
+err:
+	return ret;
+}
+
+/**
+ * ctucan_platform_remove - Unregister the device after releasing the resources
+ * @pdev:	Handle to the platform device structure
+ *
+ * This function frees all the resources allocated to the device.
+ * Return: 0 always
+ */
+static int ctucan_platform_remove(struct platform_device *pdev)
+{
+	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct ctucan_priv *priv = netdev_priv(ndev);
+
+	netdev_dbg(ndev, "ctucan_remove");
+
+	unregister_candev(ndev);
+	pm_runtime_disable(&pdev->dev);
+	netif_napi_del(&priv->napi);
+	free_candev(ndev);
+
+	return 0;
+}
+
+static const struct dev_pm_ops ctucan_dev_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(ctucan_suspend, ctucan_resume)
+};
+
+/* Match table for OF platform binding */
+static const struct of_device_id ctucan_of_match[] = {
+	{ .compatible = "ctu,canfd-2", },
+	{ .compatible = "ctu,ctucanfd", },
+	{ /* end of list */ },
+};
+MODULE_DEVICE_TABLE(of, ctucan_of_match);
+
+static struct platform_driver ctucanfd_driver = {
+	.probe	= ctucan_platform_probe,
+	.remove	= ctucan_platform_remove,
+	.driver	= {
+		.name = DRV_NAME,
+		.pm = &ctucan_dev_pm_ops,
+		.of_match_table	= ctucan_of_match,
+	},
+};
+
+module_platform_driver(ctucanfd_driver);
-- 
2.11.0

