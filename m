Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F84FAD778
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 13:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390922AbfIILAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 07:00:02 -0400
Received: from mga03.intel.com ([134.134.136.65]:49297 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390909AbfIIK77 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 06:59:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Sep 2019 03:59:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,484,1559545200"; 
   d="scan'208";a="213883420"
Received: from pipin.fi.intel.com ([10.237.72.175])
  by fmsmga002.fm.intel.com with ESMTP; 09 Sep 2019 03:59:57 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH 2/2] NET: m_can: add PCI glue driver
Date:   Mon,  9 Sep 2019 13:59:53 +0300
Message-Id: <20190909105953.36504-2-felipe.balbi@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190909105953.36504-1-felipe.balbi@linux.intel.com>
References: <20190909105953.36504-1-felipe.balbi@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some intel platforms support an MCAN controller attached to the PCI
bus. This minimal driver adds support for those.

Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
---
 drivers/net/can/m_can/Kconfig     |   7 +
 drivers/net/can/m_can/Makefile    |   1 +
 drivers/net/can/m_can/m_can_pci.c | 222 ++++++++++++++++++++++++++++++
 3 files changed, 230 insertions(+)
 create mode 100644 drivers/net/can/m_can/m_can_pci.c

diff --git a/drivers/net/can/m_can/Kconfig b/drivers/net/can/m_can/Kconfig
index fba73338bc38..c7fbea72491c 100644
--- a/drivers/net/can/m_can/Kconfig
+++ b/drivers/net/can/m_can/Kconfig
@@ -13,4 +13,11 @@ config CAN_M_CAN_PLATFORM
 	   Say Y here if you want to support Bosch M_CAN controller connected
 	   to the platform bus.
 
+config CAN_M_CAN_PCI
+	tristate "Generic PCI Bus based M_CAN driver"
+	depends on PCI
+	---help---
+	   Say Y here if you want to support Bosch M_CAN controller connected
+	   to the pci bus.
+
 endif
diff --git a/drivers/net/can/m_can/Makefile b/drivers/net/can/m_can/Makefile
index ac568be3de98..104de5cb6d79 100644
--- a/drivers/net/can/m_can/Makefile
+++ b/drivers/net/can/m_can/Makefile
@@ -5,3 +5,4 @@
 
 obj-$(CONFIG_CAN_M_CAN) += m_can.o
 obj-$(CONFIG_CAN_M_CAN_PLATFORM) += m_can_platform.o
+obj-$(CONFIG_CAN_M_CAN_PCI) += m_can_pci.o
diff --git a/drivers/net/can/m_can/m_can_pci.c b/drivers/net/can/m_can/m_can_pci.c
new file mode 100644
index 000000000000..fc6dfc334d34
--- /dev/null
+++ b/drivers/net/can/m_can/m_can_pci.c
@@ -0,0 +1,222 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ * m_can_pci.c - PCI Specific M_CAN Glue
+ *
+ * Copyright (C) 2018 Intel Corporation - https://www.intel.com
+ * Author: Felipe Balbi <felipe.balbi@linux.intel.com>
+ */
+
+#include <linux/bitops.h>
+#include <linux/can/dev.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/pci.h>
+#include <linux/pm_runtime.h>
+
+#include "m_can.h"
+
+#define PCI_DEVICE_ID_INTEL_EHL_1	 0x4bc1
+#define PCI_DEVICE_ID_INTEL_EHL_2	 0x4bc2
+
+#define M_CAN_PCI_MMIO_BAR		0
+#define M_CAN_MRAM_OFFSET		0x800
+
+#define M_CAN_CLOCK_FREQ_EHL		100000000
+
+static void m_can_init_mram_conf(struct m_can_priv *priv)
+{
+	priv->mcfg[MRAM_SIDF].off = 0;
+	priv->mcfg[MRAM_SIDF].num = 128;
+	priv->mcfg[MRAM_XIDF].off = priv->mcfg[MRAM_SIDF].off +
+		priv->mcfg[MRAM_SIDF].num * SIDF_ELEMENT_SIZE;
+	priv->mcfg[MRAM_XIDF].num = 64;
+	priv->mcfg[MRAM_RXF0].off = priv->mcfg[MRAM_XIDF].off +
+		priv->mcfg[MRAM_XIDF].num * XIDF_ELEMENT_SIZE;
+	priv->mcfg[MRAM_RXF0].num = 64 &
+		(RXFC_FS_MASK >> RXFC_FS_SHIFT);
+	priv->mcfg[MRAM_RXF1].off = priv->mcfg[MRAM_RXF0].off +
+		priv->mcfg[MRAM_RXF0].num * RXF0_ELEMENT_SIZE;
+	priv->mcfg[MRAM_RXF1].num = 0 &
+		(RXFC_FS_MASK >> RXFC_FS_SHIFT);
+	priv->mcfg[MRAM_RXB].off = priv->mcfg[MRAM_RXF1].off +
+		priv->mcfg[MRAM_RXF1].num * RXF1_ELEMENT_SIZE;
+	priv->mcfg[MRAM_RXB].num = 64;
+	priv->mcfg[MRAM_TXE].off = priv->mcfg[MRAM_RXB].off +
+		priv->mcfg[MRAM_RXB].num * RXB_ELEMENT_SIZE;
+	priv->mcfg[MRAM_TXE].num = 0;
+	priv->mcfg[MRAM_TXB].off = priv->mcfg[MRAM_TXE].off +
+		priv->mcfg[MRAM_TXE].num * TXE_ELEMENT_SIZE;
+	priv->mcfg[MRAM_TXB].num = 16 &
+		(TXBC_NDTB_MASK >> TXBC_NDTB_SHIFT);
+
+	dev_dbg(priv->device,
+			"mram_base %p sidf 0x%x %d xidf 0x%x %d rxf0 0x%x %d rxf1 0x%x %d rxb 0x%x %d txe 0x%x %d txb 0x%x %d\n",
+			priv->mram_base,
+			priv->mcfg[MRAM_SIDF].off, priv->mcfg[MRAM_SIDF].num,
+			priv->mcfg[MRAM_XIDF].off, priv->mcfg[MRAM_XIDF].num,
+			priv->mcfg[MRAM_RXF0].off, priv->mcfg[MRAM_RXF0].num,
+			priv->mcfg[MRAM_RXF1].off, priv->mcfg[MRAM_RXF1].num,
+			priv->mcfg[MRAM_RXB].off, priv->mcfg[MRAM_RXB].num,
+			priv->mcfg[MRAM_TXE].off, priv->mcfg[MRAM_TXE].num,
+			priv->mcfg[MRAM_TXB].off, priv->mcfg[MRAM_TXB].num);
+
+	m_can_init_ram(priv);
+}
+
+static int m_can_pci_probe(struct pci_dev *pci,
+		const struct pci_device_id *id)
+{
+	struct m_can_priv *priv;
+	struct net_device *net;
+	struct device *dev;
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
+	dev = &pci->dev;
+
+	base = pcim_iomap_table(pci)[M_CAN_PCI_MMIO_BAR];
+
+	if (!base) {
+		dev_err(dev, "failed to map BARs\n");
+		return -ENOMEM;
+	}
+
+	net = alloc_m_can_dev(1);
+	if (!net)
+		return -ENOMEM;
+
+	ret = pci_alloc_irq_vectors(pci, 1, 1, PCI_IRQ_ALL_TYPES);
+	if (ret < 0)
+		return ret;
+
+	priv = netdev_priv(net);
+	net->irq = pci_irq_vector(pci, 0);
+	priv->device = dev;
+	priv->can.clock.freq = id->driver_data;
+	priv->mram_base = base + M_CAN_MRAM_OFFSET;
+
+	pci_set_drvdata(pci, net);
+	SET_NETDEV_DEV(net, dev);
+
+	ret = m_can_dev_setup(dev, net, base);
+	if (ret)
+		goto err;
+
+	ret = register_m_can_dev(net);
+	if (ret)
+		goto err;
+
+	m_can_init_mram_conf(priv);
+	devm_can_led_init(net);
+
+	pm_runtime_set_autosuspend_delay(dev, 1000);
+	pm_runtime_use_autosuspend(dev);
+	pm_runtime_put_noidle(dev);
+	pm_runtime_allow(dev);
+
+	return 0;
+
+err:
+	pm_runtime_disable(&pci->dev);
+	pci_free_irq_vectors(pci);
+	return ret;
+}
+
+static void m_can_pci_remove(struct pci_dev *pci)
+{
+	struct net_device *dev = pci_get_drvdata(pci);
+
+	pm_runtime_forbid(&pci->dev);
+	pm_runtime_get_noresume(&pci->dev);
+
+	pci_free_irq_vectors(pci);
+	unregister_m_can_dev(dev);
+	free_m_can_dev(dev);
+}
+
+static __maybe_unused int m_can_pci_suspend(struct device *dev)
+{
+	struct pci_dev *pdev = container_of(dev, struct pci_dev, dev);
+	struct net_device *ndev = pci_get_drvdata(pdev);
+	struct m_can_priv *priv = netdev_priv(ndev);
+
+	if (netif_running(ndev)) {
+		netif_stop_queue(ndev);
+		netif_device_detach(ndev);
+		m_can_stop(ndev);
+		m_can_clk_stop(priv);
+	}
+
+	priv->can.state = CAN_STATE_SLEEPING;
+
+	return 0;
+}
+
+static __maybe_unused int m_can_pci_resume(struct device *dev)
+{
+	struct pci_dev *pdev = container_of(dev, struct pci_dev, dev);
+	struct net_device *ndev = pci_get_drvdata(pdev);
+	struct m_can_priv *priv = netdev_priv(ndev);
+
+	priv->can.state = CAN_STATE_ERROR_ACTIVE;
+
+	if (netif_running(ndev)) {
+		int ret;
+
+		ret = m_can_clk_start(priv);
+		if (ret)
+			return ret;
+
+		m_can_init_ram(priv);
+		m_can_start(ndev);
+		netif_device_attach(ndev);
+		netif_start_queue(ndev);
+	}
+
+	return 0;
+}
+
+static const struct dev_pm_ops m_can_pci_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(m_can_pci_suspend, m_can_pci_resume)
+};
+
+static const struct pci_device_id m_can_pci_id_table[] = {
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_EHL_1),
+	  M_CAN_CLOCK_FREQ_EHL, },
+
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_EHL_2),
+	  M_CAN_CLOCK_FREQ_EHL, },
+
+	{  }	/* Terminating Entry */
+};
+MODULE_DEVICE_TABLE(pci, m_can_pci_id_table);
+
+static struct pci_driver m_can_pci_driver = {
+	.name		= "m_can_pci",
+	.probe		= m_can_pci_probe,
+	.remove		= m_can_pci_remove,
+	.id_table	= m_can_pci_id_table,
+	.driver = {
+		.pm = &m_can_pci_pm_ops,
+	}
+};
+
+MODULE_AUTHOR("Felipe Balbi <felipe.balbi@linux.intel.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("CAN bus driver for Bosch M_CAN controller on PCI bus");
+
+module_pci_driver(m_can_pci_driver);
-- 
2.23.0

