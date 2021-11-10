Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B688744BB6A
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 06:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhKJFvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 00:51:38 -0500
Received: from inva021.nxp.com ([92.121.34.21]:36658 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229873AbhKJFve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 00:51:34 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 35C12200C78;
        Wed, 10 Nov 2021 06:48:46 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C8C70200A95;
        Wed, 10 Nov 2021 06:48:45 +0100 (CET)
Received: from lsv03186.swis.in-blr01.nxp.com (lsv03186.swis.in-blr01.nxp.com [92.120.146.182])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 9DA4D183AC8B;
        Wed, 10 Nov 2021 13:48:44 +0800 (+08)
From:   Apeksha Gupta <apeksha.gupta@nxp.com>
To:     qiangqing.zhang@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-devel@linux.nxdi.nxp.com, LnxRevLi@nxp.com,
        sachin.saxena@nxp.com, hemant.agrawal@nxp.com, nipun.gupta@nxp.com,
        Apeksha Gupta <apeksha.gupta@nxp.com>
Subject: [PATCH 2/5] net: fec: fec-uio driver
Date:   Wed, 10 Nov 2021 11:18:35 +0530
Message-Id: <20211110054838.27907-3-apeksha.gupta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211110054838.27907-1-apeksha.gupta@nxp.com>
References: <20211110054838.27907-1-apeksha.gupta@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

i.mx: fec-uio driver

This patch adds the userspace support. In this basic
hardware initialization is performed in kernel via userspace
input/output, while the majority of code is written in the
userspace.

Module fec-uio.ko is generated.
imx8mm-evk-dpdk.dtb is required to support fec-uio driver.

Signed-off-by: Sachin Saxena <sachin.saxena@nxp.com>
Signed-off-by: Apeksha Gupta <apeksha.gupta@nxp.com>
---
 drivers/net/ethernet/freescale/Kconfig   |  10 +
 drivers/net/ethernet/freescale/Makefile  |   7 +-
 drivers/net/ethernet/freescale/fec_uio.c | 437 +++++++++++++++++++++++
 3 files changed, 451 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/freescale/fec_uio.c

diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
index e04e1c5cb013..c41289e9ebfa 100644
--- a/drivers/net/ethernet/freescale/Kconfig
+++ b/drivers/net/ethernet/freescale/Kconfig
@@ -33,6 +33,16 @@ config FEC
 	  Say Y here if you want to use the built-in 10/100 Fast ethernet
 	  controller on some Motorola ColdFire and Freescale i.MX processors.
 
+config FEC_UIO
+	tristate "FEC_UIO ethernet controller (i.MX 8M Mini CPU)"
+	default n
+	select UIO
+	help
+	  Say Y here if you want to use the built-in 10/100/1000-Mbit/s Fast
+	  ethernet controller on Freescale i.MX 8M Mini processor. Basic
+	  hardware initialization is performed in kernel via UIO, fec-uio
+	  driver adds the userspace support.
+
 config FEC_MPC52xx
 	tristate "FEC MPC52xx driver"
 	depends on PPC_MPC52xx && PPC_BESTCOMM
diff --git a/drivers/net/ethernet/freescale/Makefile b/drivers/net/ethernet/freescale/Makefile
index 61d417694e0e..a32c807a626b 100644
--- a/drivers/net/ethernet/freescale/Makefile
+++ b/drivers/net/ethernet/freescale/Makefile
@@ -2,11 +2,12 @@
 #
 # Makefile for the Freescale network device drivers.
 #
-
-common-objs := fec_phy.o
+common-obj := fec_phy.o
 
 obj-$(CONFIG_FEC) += fec.o
-fec-objs :=fec_main.o fec_ptp.o $(common-objs)
+fec-objs :=fec_main.o fec_ptp.o $(common-obj)
+obj-$(CONFIG_FEC_UIO) += enetfec_uio.o
+enetfec_uio-objs := fec_uio.o $(common-obj)
 
 obj-$(CONFIG_FEC_MPC52xx) += fec_mpc52xx.o
 ifeq ($(CONFIG_FEC_MPC52xx_MDIO),y)
diff --git a/drivers/net/ethernet/freescale/fec_uio.c b/drivers/net/ethernet/freescale/fec_uio.c
new file mode 100644
index 000000000000..5aa90e1f5c55
--- /dev/null
+++ b/drivers/net/ethernet/freescale/fec_uio.c
@@ -0,0 +1,437 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright 2021 NXP
+ */
+
+#include <linux/kernel.h>
+#include <linux/of_platform.h>
+#include <linux/uio_driver.h>
+#include <linux/pm_runtime.h>
+#include <linux/errno.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/regulator/consumer.h>
+#include <linux/clk.h>
+#include <linux/of_gpio.h>
+#include <linux/of_net.h>
+
+#include "fec.h"
+#include "fec_phy.h"
+
+struct fec_dev *fec_dev;
+static const char fec_uio_version[] = "FEC UIO driver v1.0";
+dma_addr_t bd_dma;
+int bd_size;
+struct bufdesc *cbd_base;
+
+#define NAME_LENGTH		10
+#define DRIVER_NAME		"fec-uio"
+#define FEC_PRIV_SIZE		200
+#define FEC_MAX_Q		3
+#define ENABLE_ENET		BIT(8)
+#define ETHER_EN		0x2
+
+static const char uio_device_name[] = "imx-fec-uio";
+struct fec_uio_info {
+	atomic_t ref; /* exclusive, only one open() at a time */
+	struct uio_info uio_info;
+	char name[NAME_LENGTH];
+};
+
+struct fec_dev {
+	u32 index;
+	struct device *dev;
+	struct resource *res;
+	struct fec_uio_info info;
+};
+
+struct fec_uio_devinfo {
+	u32 quirks;
+};
+
+static const struct fec_uio_devinfo fec_imx8mm_info = {
+	.quirks = FEC_QUIRK_ENET_MAC,
+};
+
+static struct platform_device_id fec_enet_uio_devtype[] = {
+	{
+		.name = DRIVER_NAME,
+		.driver_data = (kernel_ulong_t)&fec_imx8mm_info,
+	}, {
+		.name = "imx8mm-fec",
+		.driver_data = (kernel_ulong_t)&fec_imx8mm_info,
+	}, {
+		/* sentinel */
+	}
+};
+MODULE_DEVICE_TABLE(platform, fec_enet_uio_devtype);
+
+static const struct of_device_id fec_enet_uio_ids[] = {
+	{ .compatible = "fsl,imx8mm-fec-uio", .data = &fec_enet_uio_devtype },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, fec_enet_uio_ids);
+
+static unsigned char macaddr[ETH_ALEN];
+module_param_array(macaddr, byte, NULL, 0);
+MODULE_PARM_DESC(macaddr, "FEC Ethernet MAC address");
+
+static int fec_uio_open(struct uio_info *info, struct inode *inode)
+{
+	return 0;
+}
+
+static int fec_uio_release(struct uio_info *info, struct inode *inode)
+{
+	return 0;
+}
+
+static int fec_uio_mmap(struct uio_info *info, struct vm_area_struct *vma)
+{
+	u32 ret;
+	u32 pfn;
+
+	pfn = (info->mem[vma->vm_pgoff].addr) >> PAGE_SHIFT;
+
+	if (vma->vm_pgoff)
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	else
+		vma->vm_page_prot = pgprot_device(vma->vm_page_prot);
+
+	ret = remap_pfn_range(vma, vma->vm_start, pfn,
+			      vma->vm_end - vma->vm_start, vma->vm_page_prot);
+	if (ret) {
+		/* Error Handle */
+		pr_info("remap_pfn_range failed");
+	}
+	return ret;
+}
+
+static int __init fec_uio_init(struct fec_dev *fec_dev)
+{
+	struct fec_uio_info *fec_uio_info;
+	int ret;
+
+	fec_uio_info = &fec_dev->info;
+	atomic_set(&fec_uio_info->ref, 0);
+	fec_uio_info->uio_info.version = fec_uio_version;
+	fec_uio_info->uio_info.name = fec_dev->info.name;
+
+	fec_uio_info->uio_info.mem[0].name = "FEC_REG_SPACE";
+	fec_uio_info->uio_info.mem[0].addr = fec_dev->res->start;
+	fec_uio_info->uio_info.mem[0].size = 0x1000;
+	fec_uio_info->uio_info.mem[0].internal_addr = 0;
+	fec_uio_info->uio_info.mem[0].memtype = UIO_MEM_PHYS;
+
+	fec_uio_info->uio_info.mem[1].name = "FEC_BD_SPACE";
+	fec_uio_info->uio_info.mem[1].addr = bd_dma;
+	fec_uio_info->uio_info.mem[1].size = bd_size;
+	fec_uio_info->uio_info.mem[1].memtype = UIO_MEM_PHYS;
+
+	fec_uio_info->uio_info.open = fec_uio_open;
+	fec_uio_info->uio_info.release = fec_uio_release;
+	/* Custom mmap function. */
+	fec_uio_info->uio_info.mmap = fec_uio_mmap;
+	fec_uio_info->uio_info.priv = fec_dev;
+
+	ret = uio_register_device(fec_dev->dev, &fec_uio_info->uio_info);
+	/* return if driver requests probe retry */
+	if (ret == -EPROBE_DEFER)
+		return ret;
+	if (ret) {
+		dev_err(fec_dev->dev, "fec_uio: UIO registration failed\n");
+		return ret;
+	}
+	return 0;
+}
+
+/* Calculate the Rx,Tx ring size to get the total buffer discriptor(BD)
+ * size and allocate memory for BD ring.
+ */
+static int fec_enet_uio_init(struct net_device *ndev)
+{
+	unsigned int total_tx_ring_size = 0, total_rx_ring_size = 0;
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	unsigned int dsize = sizeof(struct bufdesc);
+	unsigned short tx_ring_size, rx_ring_size;
+	int ret, i;
+
+	/* Check mask of the streaming and coherent API */
+	ret = dma_set_mask_and_coherent(&fep->pdev->dev, DMA_BIT_MASK(32));
+	if (ret < 0) {
+		dev_warn(&fep->pdev->dev, "No suitable DMA available\n");
+		return ret;
+	}
+
+	tx_ring_size = TX_RING_SIZE;
+	rx_ring_size = RX_RING_SIZE;
+
+	for (i = 0; i <	FEC_ENET_MAX_TX_QS; i++)
+		total_tx_ring_size += tx_ring_size;
+	for (i = 0; i <	FEC_ENET_MAX_RX_QS; i++)
+		total_rx_ring_size += rx_ring_size;
+
+	bd_size = (total_tx_ring_size + total_rx_ring_size) * dsize;
+
+	/* Allocate memory for buffer descriptors. */
+	cbd_base = dma_alloc_coherent(&fep->pdev->dev, bd_size, &bd_dma,
+				      GFP_KERNEL);
+	if (!cbd_base) {
+		ret = -ENOMEM;
+		goto free_mem;
+	}
+
+	return 0;
+free_mem:
+	dma_free_coherent(&fep->pdev->dev, bd_size, cbd_base, bd_dma);
+	return ret;
+}
+
+static int
+fec_enet_uio_probe(struct platform_device *pdev)
+{
+	struct fec_uio_devinfo *dev_info;
+	const struct of_device_id *of_id;
+	struct fec_enet_private *fep;
+	struct net_device *ndev;
+	u32 ecntl = ETHER_EN;
+	static int dev_id;
+	bool reset_again;
+	int ret = 0;
+
+	/* Init network device */
+	ndev = alloc_etherdev_mq(sizeof(struct fec_enet_private) +
+				FEC_PRIV_SIZE, FEC_MAX_Q);
+	if (!ndev)
+		return -ENOMEM;
+
+	SET_NETDEV_DEV(ndev, &pdev->dev);
+
+	/* setup board info structure */
+	fep = netdev_priv(ndev);
+
+	of_id = of_match_device(fec_enet_uio_ids, &pdev->dev);
+	if (of_id)
+		pdev->id_entry = of_id->data;
+
+	dev_info = (struct fec_uio_devinfo *)pdev->id_entry->driver_data;
+	if (dev_info)
+		fep->quirks = dev_info->quirks;
+
+	/* Select default pin state */
+	pinctrl_pm_select_default_state(&pdev->dev);
+
+	/* allocate memory for uio structure */
+	fec_dev = kzalloc(sizeof(*fec_dev), GFP_KERNEL);
+	if (!fec_dev)
+		return -ENOMEM;
+
+	snprintf(fec_dev->info.name, sizeof(fec_dev->info.name) - 1,
+		 "%s", uio_device_name);
+
+	fec_dev->dev = &pdev->dev;
+
+	fec_dev->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	fep->hwp = ioremap(fec_dev->res->start, 0x1000);
+	if (IS_ERR(fep->hwp)) {
+		ret = PTR_ERR(fep->hwp);
+		goto failed_ioremap;
+	}
+	fep->pdev = pdev;
+	fep->dev_id = dev_id++;
+
+	platform_set_drvdata(pdev, ndev);
+
+	fep->clk_ipg = devm_clk_get(&pdev->dev, "ipg");
+	if (IS_ERR(fep->clk_ipg)) {
+		ret = PTR_ERR(fep->clk_ipg);
+		goto failed_clk;
+	}
+
+	fep->clk_ahb = devm_clk_get(&pdev->dev, "ahb");
+	if (IS_ERR(fep->clk_ahb)) {
+		ret = PTR_ERR(fep->clk_ahb);
+		goto failed_clk;
+	}
+
+	/* enet_out is optional, depends on board */
+	fep->clk_enet_out = devm_clk_get(&pdev->dev, "enet_out");
+	if (IS_ERR(fep->clk_enet_out))
+		fep->clk_enet_out = NULL;
+
+	/* clk_ref is optional, depends on board */
+	fep->clk_ref = devm_clk_get(&pdev->dev, "enet_clk_ref");
+	if (IS_ERR(fep->clk_ref))
+		fep->clk_ref = NULL;
+
+	ret = clk_prepare_enable(fep->clk_enet_out);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(fep->clk_ref);
+	if (ret)
+		goto failed_clk_ref;
+
+	fec_enet_phy_reset_after_clk_enable(ndev);
+
+	ret = clk_prepare_enable(fep->clk_ipg);
+	if (ret)
+		goto failed_clk_ipg;
+
+	ret = clk_prepare_enable(fep->clk_ahb);
+	if (ret)
+		goto failed_clk_ahb;
+
+	fep->reg_phy = devm_regulator_get_optional(&pdev->dev, "phy");
+	if (!IS_ERR(fep->reg_phy)) {
+		ret = regulator_enable(fep->reg_phy);
+		if (ret) {
+			dev_err(&pdev->dev,
+				"Failed to enable phy regulator: %d\n", ret);
+			goto failed_regulator;
+		}
+	} else {
+		if (PTR_ERR(fep->reg_phy) == -EPROBE_DEFER) {
+			ret = -EPROBE_DEFER;
+			goto failed_regulator;
+		}
+		fep->reg_phy = NULL;
+	}
+
+	pm_runtime_enable(&pdev->dev);
+	ret = fec_reset_phy(pdev);
+	if (ret)
+		goto failed_reset;
+
+	ret = fec_enet_uio_init(ndev);
+	if (ret)
+		goto failed_init;
+
+	/* Register UIO */
+	ret = fec_uio_init(fec_dev);
+	if (ret) {
+		/* return if driver requests probe retry */
+		if (ret == -EPROBE_DEFER) {
+			dev_info(&pdev->dev,
+				 "Driver request probe retry: %s\n", __func__);
+			goto out_unmap;
+		} else {
+			dev_err(&pdev->dev, "UIO init Failed\n");
+			goto abort;
+		}
+	}
+	dev_info(fec_dev->dev, "UIO device full name %s initialized\n",
+		 fec_dev->info.name);
+
+	if (fep->quirks & FEC_QUIRK_ENET_MAC) {
+		/* enable ENET endian swap */
+		ecntl |= ENABLE_ENET;
+		/* enable ENET store and forward mode */
+		writel(ENABLE_ENET, fep->hwp + FEC_X_WMRK);
+	}
+
+	/* And last, enable the transmit and receive processing */
+	writel(ecntl, fep->hwp + FEC_ECNTRL);
+
+	ret = fec_enet_mii_init(pdev);
+	if (ret)
+		goto failed_mii_init;
+
+	if (ndev->phydev && ndev->phydev->drv)
+		reset_again = false;
+	else
+		reset_again = true;
+
+	return 0;
+
+failed_mii_init:
+failed_init:
+failed_reset:
+	pm_runtime_disable(&pdev->dev);
+	if (fep->reg_phy)
+		regulator_disable(fep->reg_phy);
+failed_clk_ref:
+	clk_disable_unprepare(fep->clk_enet_out);
+failed_regulator:
+	clk_disable_unprepare(fep->clk_ahb);
+failed_clk_ahb:
+	clk_disable_unprepare(fep->clk_ipg);
+failed_clk_ipg:
+	clk_disable_unprepare(fep->clk_enet_out);
+	clk_disable_unprepare(fep->clk_ref);
+failed_clk:
+	dev_id--;
+failed_ioremap:
+	free_netdev(ndev);
+
+	return ret;
+out_unmap:
+	dev_id--;
+	kfree(fec_dev);
+	iounmap(fep->hwp);
+	dma_free_coherent(&fep->pdev->dev, bd_size, cbd_base, bd_dma);
+	free_netdev(ndev);
+	clk_disable_unprepare(fep->clk_ahb);
+	clk_disable_unprepare(fep->clk_ipg);
+	clk_disable_unprepare(fep->clk_enet_out);
+	clk_disable_unprepare(fep->clk_ref);
+	pm_runtime_disable(&pdev->dev);
+
+	return -EPROBE_DEFER;
+abort:
+	return ret;
+}
+
+static int
+fec_enet_uio_remove(struct platform_device *pdev)
+{
+	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct fec_enet_private *fep = netdev_priv(ndev);
+
+	kfree(fec_dev);
+	iounmap(fep->hwp);
+	dma_free_coherent(&fep->pdev->dev, bd_size, cbd_base, bd_dma);
+
+	uio_unregister_device(&fec_dev->info.uio_info);
+
+	fec_enet_mii_remove(fep);
+	if (fep->reg_phy)
+		regulator_disable(fep->reg_phy);
+
+	free_netdev(ndev);
+
+	clk_disable_unprepare(fep->clk_ahb);
+	clk_disable_unprepare(fep->clk_ipg);
+	pm_runtime_disable(&pdev->dev);
+
+	return 0;
+}
+
+static struct platform_driver fec_enet_uio_driver = {
+	.driver = {
+		.name = DRIVER_NAME,
+		.of_match_table = fec_enet_uio_ids,
+		.suppress_bind_attrs = true,
+	},
+	.id_table = fec_enet_uio_devtype,
+	.prevent_deferred_probe = false,
+	.probe = fec_enet_uio_probe,
+	.remove = fec_enet_uio_remove,
+};
+
+static int __init fec_enet_uio_load(void)
+{
+	return platform_driver_register(&fec_enet_uio_driver);
+}
+
+static void __exit fec_enet_uio_unload(void)
+{
+	platform_driver_unregister(&fec_enet_uio_driver);
+}
+
+module_init(fec_enet_uio_load);
+module_exit(fec_enet_uio_unload);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("NXP");
+MODULE_DESCRIPTION("i.MX FEC UIO Driver");
-- 
2.17.1

