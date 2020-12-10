Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0579D2D57AB
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 10:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgLJJ42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 04:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728096AbgLJJ4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 04:56:20 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD3EC0611CB
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 01:55:21 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1knIfP-00013W-NW
        for netdev@vger.kernel.org; Thu, 10 Dec 2020 10:55:19 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id E60A45AA1D4
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 09:55:17 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 707E05AA1A0;
        Thu, 10 Dec 2020 09:55:10 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id e031015c;
        Thu, 10 Dec 2020 09:55:08 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Felipe Balbi <balbi@kernel.org>,
        Raymond Tan <raymond.tan@intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 5/7] can: m_can: add PCI glue driver for Intel Elkhart Lake
Date:   Thu, 10 Dec 2020 10:55:05 +0100
Message-Id: <20201210095507.1551220-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210095507.1551220-1-mkl@pengutronix.de>
References: <20201210095507.1551220-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

Add support for M_CAN controller on Intel Elkhart Lake attached to the PCI bus.
It integrates the Bosch M_CAN controller with Message RAM and the wrapper IP
block with additional registers which all of them are within the same MMIO
range.

Currently only interrupt control register from wrapper IP is used and the MRAM
configuration is expected to come from the firmware via "bosch,mram-cfg" device
property and parsed by m_can.c core.

Initial implementation is done by Felipe Balbi while he was working at Intel
with later changes from Raymond Tan and me.

Co-developed-by: Felipe Balbi (Intel) <balbi@kernel.org>
Co-developed-by: Raymond Tan <raymond.tan@intel.com>
Signed-off-by: Felipe Balbi (Intel) <balbi@kernel.org>
Signed-off-by: Raymond Tan <raymond.tan@intel.com>
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/20201117160827.3636264-1-jarkko.nikula@linux.intel.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/Kconfig     |   7 ++
 drivers/net/can/m_can/Makefile    |   1 +
 drivers/net/can/m_can/m_can_pci.c | 186 ++++++++++++++++++++++++++++++
 3 files changed, 194 insertions(+)
 create mode 100644 drivers/net/can/m_can/m_can_pci.c

diff --git a/drivers/net/can/m_can/Kconfig b/drivers/net/can/m_can/Kconfig
index e3eb69b76cf5..45ad1b3f0cd0 100644
--- a/drivers/net/can/m_can/Kconfig
+++ b/drivers/net/can/m_can/Kconfig
@@ -7,6 +7,13 @@ menuconfig CAN_M_CAN
 
 if CAN_M_CAN
 
+config CAN_M_CAN_PCI
+	tristate "Generic PCI Bus based M_CAN driver"
+	depends on PCI
+	help
+	  Say Y here if you want to support Bosch M_CAN controller connected
+	  to the pci bus.
+
 config CAN_M_CAN_PLATFORM
 	tristate "Bosch M_CAN support for io-mapped devices"
 	depends on HAS_IOMEM
diff --git a/drivers/net/can/m_can/Makefile b/drivers/net/can/m_can/Makefile
index 52a4a6fbe527..ef7963ff2006 100644
--- a/drivers/net/can/m_can/Makefile
+++ b/drivers/net/can/m_can/Makefile
@@ -4,5 +4,6 @@
 #
 
 obj-$(CONFIG_CAN_M_CAN) += m_can.o
+obj-$(CONFIG_CAN_M_CAN_PCI) += m_can_pci.o
 obj-$(CONFIG_CAN_M_CAN_PLATFORM) += m_can_platform.o
 obj-$(CONFIG_CAN_M_CAN_TCAN4X5X) += tcan4x5x.o
diff --git a/drivers/net/can/m_can/m_can_pci.c b/drivers/net/can/m_can/m_can_pci.c
new file mode 100644
index 000000000000..04010ee0407c
--- /dev/null
+++ b/drivers/net/can/m_can/m_can_pci.c
@@ -0,0 +1,186 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * PCI Specific M_CAN Glue
+ *
+ * Copyright (C) 2018-2020 Intel Corporation
+ * Author: Felipe Balbi (Intel)
+ * Author: Jarkko Nikula <jarkko.nikula@linux.intel.com>
+ * Author: Raymond Tan <raymond.tan@intel.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/pci.h>
+#include <linux/pm_runtime.h>
+
+#include "m_can.h"
+
+#define M_CAN_PCI_MMIO_BAR		0
+
+#define M_CAN_CLOCK_FREQ_EHL		100000000
+#define CTL_CSR_INT_CTL_OFFSET		0x508
+
+struct m_can_pci_priv {
+	void __iomem *base;
+};
+
+static u32 iomap_read_reg(struct m_can_classdev *cdev, int reg)
+{
+	struct m_can_pci_priv *priv = cdev->device_data;
+
+	return readl(priv->base + reg);
+}
+
+static u32 iomap_read_fifo(struct m_can_classdev *cdev, int offset)
+{
+	struct m_can_pci_priv *priv = cdev->device_data;
+
+	return readl(priv->base + offset);
+}
+
+static int iomap_write_reg(struct m_can_classdev *cdev, int reg, int val)
+{
+	struct m_can_pci_priv *priv = cdev->device_data;
+
+	writel(val, priv->base + reg);
+
+	return 0;
+}
+
+static int iomap_write_fifo(struct m_can_classdev *cdev, int offset, int val)
+{
+	struct m_can_pci_priv *priv = cdev->device_data;
+
+	writel(val, priv->base + offset);
+
+	return 0;
+}
+
+static struct m_can_ops m_can_pci_ops = {
+	.read_reg = iomap_read_reg,
+	.write_reg = iomap_write_reg,
+	.write_fifo = iomap_write_fifo,
+	.read_fifo = iomap_read_fifo,
+};
+
+static int m_can_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
+{
+	struct device *dev = &pci->dev;
+	struct m_can_classdev *mcan_class;
+	struct m_can_pci_priv *priv;
+	void __iomem *base;
+	int ret;
+
+	ret = pcim_enable_device(pci);
+	if (ret)
+		return ret;
+
+	pci_set_master(pci);
+
+	ret = pcim_iomap_regions(pci, BIT(M_CAN_PCI_MMIO_BAR), pci_name(pci));
+	if (ret)
+		return ret;
+
+	base = pcim_iomap_table(pci)[M_CAN_PCI_MMIO_BAR];
+
+	if (!base) {
+		dev_err(dev, "failed to map BARs\n");
+		return -ENOMEM;
+	}
+
+	priv = devm_kzalloc(&pci->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	mcan_class = m_can_class_allocate_dev(&pci->dev);
+	if (!mcan_class)
+		return -ENOMEM;
+
+	priv->base = base;
+
+	ret = pci_alloc_irq_vectors(pci, 1, 1, PCI_IRQ_ALL_TYPES);
+	if (ret < 0)
+		return ret;
+
+	mcan_class->device_data = priv;
+	mcan_class->dev = &pci->dev;
+	mcan_class->net->irq = pci_irq_vector(pci, 0);
+	mcan_class->pm_clock_support = 1;
+	mcan_class->can.clock.freq = id->driver_data;
+	mcan_class->ops = &m_can_pci_ops;
+
+	pci_set_drvdata(pci, mcan_class->net);
+
+	ret = m_can_class_register(mcan_class);
+	if (ret)
+		goto err;
+
+	/* Enable interrupt control at CAN wrapper IP */
+	writel(0x1, base + CTL_CSR_INT_CTL_OFFSET);
+
+	pm_runtime_set_autosuspend_delay(dev, 1000);
+	pm_runtime_use_autosuspend(dev);
+	pm_runtime_put_noidle(dev);
+	pm_runtime_allow(dev);
+
+	return 0;
+
+err:
+	pci_free_irq_vectors(pci);
+	return ret;
+}
+
+static void m_can_pci_remove(struct pci_dev *pci)
+{
+	struct net_device *dev = pci_get_drvdata(pci);
+	struct m_can_classdev *mcan_class = netdev_priv(dev);
+	struct m_can_pci_priv *priv = mcan_class->device_data;
+
+	pm_runtime_forbid(&pci->dev);
+	pm_runtime_get_noresume(&pci->dev);
+
+	/* Disable interrupt control at CAN wrapper IP */
+	writel(0x0, priv->base + CTL_CSR_INT_CTL_OFFSET);
+
+	m_can_class_unregister(mcan_class);
+	pci_free_irq_vectors(pci);
+}
+
+static __maybe_unused int m_can_pci_suspend(struct device *dev)
+{
+	return m_can_class_suspend(dev);
+}
+
+static __maybe_unused int m_can_pci_resume(struct device *dev)
+{
+	return m_can_class_resume(dev);
+}
+
+static SIMPLE_DEV_PM_OPS(m_can_pci_pm_ops,
+			 m_can_pci_suspend, m_can_pci_resume);
+
+static const struct pci_device_id m_can_pci_id_table[] = {
+	{ PCI_VDEVICE(INTEL, 0x4bc1), M_CAN_CLOCK_FREQ_EHL, },
+	{ PCI_VDEVICE(INTEL, 0x4bc2), M_CAN_CLOCK_FREQ_EHL, },
+	{  }	/* Terminating Entry */
+};
+MODULE_DEVICE_TABLE(pci, m_can_pci_id_table);
+
+static struct pci_driver m_can_pci_driver = {
+	.name = "m_can_pci",
+	.probe = m_can_pci_probe,
+	.remove = m_can_pci_remove,
+	.id_table = m_can_pci_id_table,
+	.driver = {
+		.pm = &m_can_pci_pm_ops,
+	},
+};
+
+module_pci_driver(m_can_pci_driver);
+
+MODULE_AUTHOR("Felipe Balbi (Intel)");
+MODULE_AUTHOR("Jarkko Nikula <jarkko.nikula@linux.intel.com>");
+MODULE_AUTHOR("Raymond Tan <raymond.tan@intel.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("CAN bus driver for Bosch M_CAN controller on PCI bus");
-- 
2.29.2


