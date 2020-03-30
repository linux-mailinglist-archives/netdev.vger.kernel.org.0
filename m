Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A12B51981DB
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730285AbgC3RFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:05:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:10809 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730268AbgC3RFT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 13:05:19 -0400
IronPort-SDR: SL68Y4Daijf/peGRfbYc+MswlT5AChrHfE9oHYY3bRjbxx2rQroWQr5/aLLW8GL7ZoHv65JdOf
 D0IgvqDu/iFw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 10:05:19 -0700
IronPort-SDR: yp7DbzDF7z59+kFfGni7unki3TM3L/QZS64qvoNLjbjFn+OXmSj/qK1FmVXsFlaXXvwHQ/Vekc
 cupuk16AQukQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,325,1580803200"; 
   d="scan'208";a="294667203"
Received: from unknown (HELO climb.png.intel.com) ([10.221.118.165])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Mar 2020 10:05:16 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [net-next,v2, 1/3] net: stmmac: create dwmac-intel.c to contain all Intel platform
Date:   Tue, 31 Mar 2020 01:05:10 +0800
Message-Id: <20200330170512.22240-2-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330170512.22240-1-weifeng.voon@intel.com>
References: <20200330170512.22240-1-weifeng.voon@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As stmmac_pci.c file is getting bigger and more complex, it is reasonable
to separate all the Intel specific dwmac pci device to a different file.
This move includes Intel Quark, TGL and EHL. A new kernel config
CONFIG_DWMAC_INTEL is introduced and depends on X86. For this initial
patch, all the necessary function such as probe() and exit() are identical
besides the function name.

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |   9 +
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 509 ++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/stmmac_pci.c  | 313 -----------
 4 files changed, 519 insertions(+), 313 deletions(-)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 9ad927f646e8..bd6a232f891d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -198,6 +198,15 @@ config DWMAC_SUN8I
 	  EMAC ethernet controller.
 endif
 
+config DWMAC_INTEL
+	tristate "Intel GMAC support"
+	default X86
+	depends on X86 && STMMAC_ETH && PCI
+	depends on COMMON_CLK
+	---help---
+	  This selects the Intel platform specific bus support for the
+	  stmmac driver. This driver is used for Intel Quark/EHL/TGL.
+
 config STMMAC_PCI
 	tristate "STMMAC PCI bus support"
 	depends on STMMAC_ETH && PCI
diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
index c59926d96bcc..5a6f265bc540 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Makefile
+++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
@@ -30,5 +30,6 @@ obj-$(CONFIG_DWMAC_GENERIC)	+= dwmac-generic.o
 stmmac-platform-objs:= stmmac_platform.o
 dwmac-altr-socfpga-objs := altr_tse_pcs.o dwmac-socfpga.o
 
+obj-$(CONFIG_DWMAC_INTEL) += dwmac-intel.o
 obj-$(CONFIG_STMMAC_PCI) += stmmac-pci.o
 stmmac-pci-objs:= stmmac_pci.o
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
new file mode 100644
index 000000000000..6c19aa361444
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -0,0 +1,509 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020, Intel Corporation
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/pci.h>
+#include <linux/dmi.h>
+#include "stmmac.h"
+
+/* This struct is used to associate PCI Function of MAC controller on a board,
+ * discovered via DMI, with the address of PHY connected to the MAC. The
+ * negative value of the address means that MAC controller is not connected
+ * with PHY.
+ */
+struct stmmac_pci_func_data {
+	unsigned int func;
+	int phy_addr;
+};
+
+struct stmmac_pci_dmi_data {
+	const struct stmmac_pci_func_data *func;
+	size_t nfuncs;
+};
+
+struct stmmac_pci_info {
+	int (*setup)(struct pci_dev *pdev, struct plat_stmmacenet_data *plat);
+};
+
+static int stmmac_pci_find_phy_addr(struct pci_dev *pdev,
+				    const struct dmi_system_id *dmi_list)
+{
+	const struct stmmac_pci_func_data *func_data;
+	const struct stmmac_pci_dmi_data *dmi_data;
+	const struct dmi_system_id *dmi_id;
+	int func = PCI_FUNC(pdev->devfn);
+	size_t n;
+
+	dmi_id = dmi_first_match(dmi_list);
+	if (!dmi_id)
+		return -ENODEV;
+
+	dmi_data = dmi_id->driver_data;
+	func_data = dmi_data->func;
+
+	for (n = 0; n < dmi_data->nfuncs; n++, func_data++)
+		if (func_data->func == func)
+			return func_data->phy_addr;
+
+	return -ENODEV;
+}
+
+static void common_default_data(struct plat_stmmacenet_data *plat)
+{
+	plat->clk_csr = 2;	/* clk_csr_i = 20-35MHz & MDC = clk_csr_i/16 */
+	plat->has_gmac = 1;
+	plat->force_sf_dma_mode = 1;
+
+	plat->mdio_bus_data->needs_reset = true;
+
+	/* Set default value for multicast hash bins */
+	plat->multicast_filter_bins = HASH_TABLE_SIZE;
+
+	/* Set default value for unicast filter entries */
+	plat->unicast_filter_entries = 1;
+
+	/* Set the maxmtu to a default of JUMBO_LEN */
+	plat->maxmtu = JUMBO_LEN;
+
+	/* Set default number of RX and TX queues to use */
+	plat->tx_queues_to_use = 1;
+	plat->rx_queues_to_use = 1;
+
+	/* Disable Priority config by default */
+	plat->tx_queues_cfg[0].use_prio = false;
+	plat->rx_queues_cfg[0].use_prio = false;
+
+	/* Disable RX queues routing by default */
+	plat->rx_queues_cfg[0].pkt_route = 0x0;
+}
+
+static int intel_mgbe_common_data(struct pci_dev *pdev,
+				  struct plat_stmmacenet_data *plat)
+{
+	int i;
+
+	plat->clk_csr = 5;
+	plat->has_gmac = 0;
+	plat->has_gmac4 = 1;
+	plat->force_sf_dma_mode = 0;
+	plat->tso_en = 1;
+
+	plat->rx_sched_algorithm = MTL_RX_ALGORITHM_SP;
+
+	for (i = 0; i < plat->rx_queues_to_use; i++) {
+		plat->rx_queues_cfg[i].mode_to_use = MTL_QUEUE_DCB;
+		plat->rx_queues_cfg[i].chan = i;
+
+		/* Disable Priority config by default */
+		plat->rx_queues_cfg[i].use_prio = false;
+
+		/* Disable RX queues routing by default */
+		plat->rx_queues_cfg[i].pkt_route = 0x0;
+	}
+
+	for (i = 0; i < plat->tx_queues_to_use; i++) {
+		plat->tx_queues_cfg[i].mode_to_use = MTL_QUEUE_DCB;
+
+		/* Disable Priority config by default */
+		plat->tx_queues_cfg[i].use_prio = false;
+	}
+
+	/* FIFO size is 4096 bytes for 1 tx/rx queue */
+	plat->tx_fifo_size = plat->tx_queues_to_use * 4096;
+	plat->rx_fifo_size = plat->rx_queues_to_use * 4096;
+
+	plat->tx_sched_algorithm = MTL_TX_ALGORITHM_WRR;
+	plat->tx_queues_cfg[0].weight = 0x09;
+	plat->tx_queues_cfg[1].weight = 0x0A;
+	plat->tx_queues_cfg[2].weight = 0x0B;
+	plat->tx_queues_cfg[3].weight = 0x0C;
+	plat->tx_queues_cfg[4].weight = 0x0D;
+	plat->tx_queues_cfg[5].weight = 0x0E;
+	plat->tx_queues_cfg[6].weight = 0x0F;
+	plat->tx_queues_cfg[7].weight = 0x10;
+
+	plat->dma_cfg->pbl = 32;
+	plat->dma_cfg->pblx8 = true;
+	plat->dma_cfg->fixed_burst = 0;
+	plat->dma_cfg->mixed_burst = 0;
+	plat->dma_cfg->aal = 0;
+
+	plat->axi = devm_kzalloc(&pdev->dev, sizeof(*plat->axi),
+				 GFP_KERNEL);
+	if (!plat->axi)
+		return -ENOMEM;
+
+	plat->axi->axi_lpi_en = 0;
+	plat->axi->axi_xit_frm = 0;
+	plat->axi->axi_wr_osr_lmt = 1;
+	plat->axi->axi_rd_osr_lmt = 1;
+	plat->axi->axi_blen[0] = 4;
+	plat->axi->axi_blen[1] = 8;
+	plat->axi->axi_blen[2] = 16;
+
+	plat->ptp_max_adj = plat->clk_ptp_rate;
+
+	/* Set system clock */
+	plat->stmmac_clk = clk_register_fixed_rate(&pdev->dev,
+						   "stmmac-clk", NULL, 0,
+						   plat->clk_ptp_rate);
+
+	if (IS_ERR(plat->stmmac_clk)) {
+		dev_warn(&pdev->dev, "Fail to register stmmac-clk\n");
+		plat->stmmac_clk = NULL;
+	}
+	clk_prepare_enable(plat->stmmac_clk);
+
+	/* Set default value for multicast hash bins */
+	plat->multicast_filter_bins = HASH_TABLE_SIZE;
+
+	/* Set default value for unicast filter entries */
+	plat->unicast_filter_entries = 1;
+
+	/* Set the maxmtu to a default of JUMBO_LEN */
+	plat->maxmtu = JUMBO_LEN;
+
+	return 0;
+}
+
+static int ehl_common_data(struct pci_dev *pdev,
+			   struct plat_stmmacenet_data *plat)
+{
+	int ret;
+
+	plat->rx_queues_to_use = 8;
+	plat->tx_queues_to_use = 8;
+	plat->clk_ptp_rate = 200000000;
+	ret = intel_mgbe_common_data(pdev, plat);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int ehl_sgmii_data(struct pci_dev *pdev,
+			  struct plat_stmmacenet_data *plat)
+{
+	plat->bus_id = 1;
+	plat->phy_addr = 0;
+	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
+
+	return ehl_common_data(pdev, plat);
+}
+
+static struct stmmac_pci_info ehl_sgmii1g_pci_info = {
+	.setup = ehl_sgmii_data,
+};
+
+static int ehl_rgmii_data(struct pci_dev *pdev,
+			  struct plat_stmmacenet_data *plat)
+{
+	plat->bus_id = 1;
+	plat->phy_addr = 0;
+	plat->phy_interface = PHY_INTERFACE_MODE_RGMII;
+
+	return ehl_common_data(pdev, plat);
+}
+
+static struct stmmac_pci_info ehl_rgmii1g_pci_info = {
+	.setup = ehl_rgmii_data,
+};
+
+static int tgl_common_data(struct pci_dev *pdev,
+			   struct plat_stmmacenet_data *plat)
+{
+	int ret;
+
+	plat->rx_queues_to_use = 6;
+	plat->tx_queues_to_use = 4;
+	plat->clk_ptp_rate = 200000000;
+	ret = intel_mgbe_common_data(pdev, plat);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int tgl_sgmii_data(struct pci_dev *pdev,
+			  struct plat_stmmacenet_data *plat)
+{
+	plat->bus_id = 1;
+	plat->phy_addr = 0;
+	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
+	return tgl_common_data(pdev, plat);
+}
+
+static struct stmmac_pci_info tgl_sgmii1g_pci_info = {
+	.setup = tgl_sgmii_data,
+};
+
+static const struct stmmac_pci_func_data galileo_stmmac_func_data[] = {
+	{
+		.func = 6,
+		.phy_addr = 1,
+	},
+};
+
+static const struct stmmac_pci_dmi_data galileo_stmmac_dmi_data = {
+	.func = galileo_stmmac_func_data,
+	.nfuncs = ARRAY_SIZE(galileo_stmmac_func_data),
+};
+
+static const struct stmmac_pci_func_data iot2040_stmmac_func_data[] = {
+	{
+		.func = 6,
+		.phy_addr = 1,
+	},
+	{
+		.func = 7,
+		.phy_addr = 1,
+	},
+};
+
+static const struct stmmac_pci_dmi_data iot2040_stmmac_dmi_data = {
+	.func = iot2040_stmmac_func_data,
+	.nfuncs = ARRAY_SIZE(iot2040_stmmac_func_data),
+};
+
+static const struct dmi_system_id quark_pci_dmi[] = {
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "Galileo"),
+		},
+		.driver_data = (void *)&galileo_stmmac_dmi_data,
+	},
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "GalileoGen2"),
+		},
+		.driver_data = (void *)&galileo_stmmac_dmi_data,
+	},
+	/* There are 2 types of SIMATIC IOT2000: IOT2020 and IOT2040.
+	 * The asset tag "6ES7647-0AA00-0YA2" is only for IOT2020 which
+	 * has only one pci network device while other asset tags are
+	 * for IOT2040 which has two.
+	 */
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "SIMATIC IOT2000"),
+			DMI_EXACT_MATCH(DMI_BOARD_ASSET_TAG,
+					"6ES7647-0AA00-0YA2"),
+		},
+		.driver_data = (void *)&galileo_stmmac_dmi_data,
+	},
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "SIMATIC IOT2000"),
+		},
+		.driver_data = (void *)&iot2040_stmmac_dmi_data,
+	},
+	{}
+};
+
+static int quark_default_data(struct pci_dev *pdev,
+			      struct plat_stmmacenet_data *plat)
+{
+	int ret;
+
+	/* Set common default data first */
+	common_default_data(plat);
+
+	/* Refuse to load the driver and register net device if MAC controller
+	 * does not connect to any PHY interface.
+	 */
+	ret = stmmac_pci_find_phy_addr(pdev, quark_pci_dmi);
+	if (ret < 0) {
+		/* Return error to the caller on DMI enabled boards. */
+		if (dmi_get_system_info(DMI_BOARD_NAME))
+			return ret;
+
+		/* Galileo boards with old firmware don't support DMI. We always
+		 * use 1 here as PHY address, so at least the first found MAC
+		 * controller would be probed.
+		 */
+		ret = 1;
+	}
+
+	plat->bus_id = pci_dev_id(pdev);
+	plat->phy_addr = ret;
+	plat->phy_interface = PHY_INTERFACE_MODE_RMII;
+
+	plat->dma_cfg->pbl = 16;
+	plat->dma_cfg->pblx8 = true;
+	plat->dma_cfg->fixed_burst = 1;
+	/* AXI (TODO) */
+
+	return 0;
+}
+
+static const struct stmmac_pci_info quark_pci_info = {
+	.setup = quark_default_data,
+};
+
+/**
+ * intel_eth_pci_probe
+ *
+ * @pdev: pci device pointer
+ * @id: pointer to table of device id/id's.
+ *
+ * Description: This probing function gets called for all PCI devices which
+ * match the ID table and are not "owned" by other driver yet. This function
+ * gets passed a "struct pci_dev *" for each device whose entry in the ID table
+ * matches the device. The probe functions returns zero when the driver choose
+ * to take "ownership" of the device or an error code(-ve no) otherwise.
+ */
+static int intel_eth_pci_probe(struct pci_dev *pdev,
+			       const struct pci_device_id *id)
+{
+	struct stmmac_pci_info *info = (struct stmmac_pci_info *)id->driver_data;
+	struct plat_stmmacenet_data *plat;
+	struct stmmac_resources res;
+	int i;
+	int ret;
+
+	plat = devm_kzalloc(&pdev->dev, sizeof(*plat), GFP_KERNEL);
+	if (!plat)
+		return -ENOMEM;
+
+	plat->mdio_bus_data = devm_kzalloc(&pdev->dev,
+					   sizeof(*plat->mdio_bus_data),
+					   GFP_KERNEL);
+	if (!plat->mdio_bus_data)
+		return -ENOMEM;
+
+	plat->dma_cfg = devm_kzalloc(&pdev->dev, sizeof(*plat->dma_cfg),
+				     GFP_KERNEL);
+	if (!plat->dma_cfg)
+		return -ENOMEM;
+
+	/* Enable pci device */
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "%s: ERROR: failed to enable device\n",
+			__func__);
+		return ret;
+	}
+
+	/* Get the base address of device */
+	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
+		if (pci_resource_len(pdev, i) == 0)
+			continue;
+		ret = pcim_iomap_regions(pdev, BIT(i), pci_name(pdev));
+		if (ret)
+			return ret;
+		break;
+	}
+
+	pci_set_master(pdev);
+
+	ret = info->setup(pdev, plat);
+	if (ret)
+		return ret;
+
+	pci_enable_msi(pdev);
+
+	memset(&res, 0, sizeof(res));
+	res.addr = pcim_iomap_table(pdev)[i];
+	res.wol_irq = pdev->irq;
+	res.irq = pdev->irq;
+
+	return stmmac_dvr_probe(&pdev->dev, plat, &res);
+}
+
+/**
+ * intel_eth_pci_remove
+ *
+ * @pdev: platform device pointer
+ * Description: this function calls the main to free the net resources
+ * and releases the PCI resources.
+ */
+static void intel_eth_pci_remove(struct pci_dev *pdev)
+{
+	struct net_device *ndev = dev_get_drvdata(&pdev->dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	int i;
+
+	stmmac_dvr_remove(&pdev->dev);
+
+	if (priv->plat->stmmac_clk)
+		clk_unregister_fixed_rate(priv->plat->stmmac_clk);
+
+	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
+		if (pci_resource_len(pdev, i) == 0)
+			continue;
+		pcim_iounmap_regions(pdev, BIT(i));
+		break;
+	}
+
+	pci_disable_device(pdev);
+}
+
+static int __maybe_unused intel_eth_pci_suspend(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	int ret;
+
+	ret = stmmac_suspend(dev);
+	if (ret)
+		return ret;
+
+	ret = pci_save_state(pdev);
+	if (ret)
+		return ret;
+
+	pci_disable_device(pdev);
+	pci_wake_from_d3(pdev, true);
+	return 0;
+}
+
+static int __maybe_unused intel_eth_pci_resume(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	int ret;
+
+	pci_restore_state(pdev);
+	pci_set_power_state(pdev, PCI_D0);
+
+	ret = pci_enable_device(pdev);
+	if (ret)
+		return ret;
+
+	pci_set_master(pdev);
+
+	return stmmac_resume(dev);
+}
+
+static SIMPLE_DEV_PM_OPS(intel_eth_pm_ops, intel_eth_pci_suspend,
+			 intel_eth_pci_resume);
+
+#define PCI_DEVICE_ID_INTEL_QUARK_ID		0x0937
+#define PCI_DEVICE_ID_INTEL_EHL_RGMII1G_ID	0x4b30
+#define PCI_DEVICE_ID_INTEL_EHL_SGMII1G_ID	0x4b31
+#define PCI_DEVICE_ID_INTEL_TGL_SGMII1G_ID	0xa0ac
+
+static const struct pci_device_id intel_eth_pci_id_table[] = {
+	{ PCI_DEVICE_DATA(INTEL, QUARK_ID, &quark_pci_info) },
+	{ PCI_DEVICE_DATA(INTEL, EHL_RGMII1G_ID, &ehl_rgmii1g_pci_info) },
+	{ PCI_DEVICE_DATA(INTEL, EHL_SGMII1G_ID, &ehl_sgmii1g_pci_info) },
+	{ PCI_DEVICE_DATA(INTEL, TGL_SGMII1G_ID, &tgl_sgmii1g_pci_info) },
+	{}
+};
+
+MODULE_DEVICE_TABLE(pci, intel_eth_pci_id_table);
+
+static struct pci_driver intel_eth_pci_driver = {
+	.name = "intel-eth-pci",
+	.id_table = intel_eth_pci_id_table,
+	.probe = intel_eth_pci_probe,
+	.remove = intel_eth_pci_remove,
+	.driver         = {
+		.pm     = &intel_eth_pm_ops,
+	},
+};
+
+module_pci_driver(intel_eth_pci_driver);
+
+MODULE_DESCRIPTION("INTEL 10/100/1000 Ethernet PCI driver");
+MODULE_AUTHOR("Voon Weifeng <weifeng.voon@intel.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index 7acbac73c29c..3fb21f7ac9fb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -15,49 +15,10 @@
 
 #include "stmmac.h"
 
-/*
- * This struct is used to associate PCI Function of MAC controller on a board,
- * discovered via DMI, with the address of PHY connected to the MAC. The
- * negative value of the address means that MAC controller is not connected
- * with PHY.
- */
-struct stmmac_pci_func_data {
-	unsigned int func;
-	int phy_addr;
-};
-
-struct stmmac_pci_dmi_data {
-	const struct stmmac_pci_func_data *func;
-	size_t nfuncs;
-};
-
 struct stmmac_pci_info {
 	int (*setup)(struct pci_dev *pdev, struct plat_stmmacenet_data *plat);
 };
 
-static int stmmac_pci_find_phy_addr(struct pci_dev *pdev,
-				    const struct dmi_system_id *dmi_list)
-{
-	const struct stmmac_pci_func_data *func_data;
-	const struct stmmac_pci_dmi_data *dmi_data;
-	const struct dmi_system_id *dmi_id;
-	int func = PCI_FUNC(pdev->devfn);
-	size_t n;
-
-	dmi_id = dmi_first_match(dmi_list);
-	if (!dmi_id)
-		return -ENODEV;
-
-	dmi_data = dmi_id->driver_data;
-	func_data = dmi_data->func;
-
-	for (n = 0; n < dmi_data->nfuncs; n++, func_data++)
-		if (func_data->func == func)
-			return func_data->phy_addr;
-
-	return -ENODEV;
-}
-
 static void common_default_data(struct plat_stmmacenet_data *plat)
 {
 	plat->clk_csr = 2;	/* clk_csr_i = 20-35MHz & MDC = clk_csr_i/16 */
@@ -108,272 +69,6 @@ static const struct stmmac_pci_info stmmac_pci_info = {
 	.setup = stmmac_default_data,
 };
 
-static int intel_mgbe_common_data(struct pci_dev *pdev,
-				  struct plat_stmmacenet_data *plat)
-{
-	int i;
-
-	plat->clk_csr = 5;
-	plat->has_gmac = 0;
-	plat->has_gmac4 = 1;
-	plat->force_sf_dma_mode = 0;
-	plat->tso_en = 1;
-
-	plat->rx_sched_algorithm = MTL_RX_ALGORITHM_SP;
-
-	for (i = 0; i < plat->rx_queues_to_use; i++) {
-		plat->rx_queues_cfg[i].mode_to_use = MTL_QUEUE_DCB;
-		plat->rx_queues_cfg[i].chan = i;
-
-		/* Disable Priority config by default */
-		plat->rx_queues_cfg[i].use_prio = false;
-
-		/* Disable RX queues routing by default */
-		plat->rx_queues_cfg[i].pkt_route = 0x0;
-	}
-
-	for (i = 0; i < plat->tx_queues_to_use; i++) {
-		plat->tx_queues_cfg[i].mode_to_use = MTL_QUEUE_DCB;
-
-		/* Disable Priority config by default */
-		plat->tx_queues_cfg[i].use_prio = false;
-	}
-
-	/* FIFO size is 4096 bytes for 1 tx/rx queue */
-	plat->tx_fifo_size = plat->tx_queues_to_use * 4096;
-	plat->rx_fifo_size = plat->rx_queues_to_use * 4096;
-
-	plat->tx_sched_algorithm = MTL_TX_ALGORITHM_WRR;
-	plat->tx_queues_cfg[0].weight = 0x09;
-	plat->tx_queues_cfg[1].weight = 0x0A;
-	plat->tx_queues_cfg[2].weight = 0x0B;
-	plat->tx_queues_cfg[3].weight = 0x0C;
-	plat->tx_queues_cfg[4].weight = 0x0D;
-	plat->tx_queues_cfg[5].weight = 0x0E;
-	plat->tx_queues_cfg[6].weight = 0x0F;
-	plat->tx_queues_cfg[7].weight = 0x10;
-
-	plat->dma_cfg->pbl = 32;
-	plat->dma_cfg->pblx8 = true;
-	plat->dma_cfg->fixed_burst = 0;
-	plat->dma_cfg->mixed_burst = 0;
-	plat->dma_cfg->aal = 0;
-
-	plat->axi = devm_kzalloc(&pdev->dev, sizeof(*plat->axi),
-				 GFP_KERNEL);
-	if (!plat->axi)
-		return -ENOMEM;
-
-	plat->axi->axi_lpi_en = 0;
-	plat->axi->axi_xit_frm = 0;
-	plat->axi->axi_wr_osr_lmt = 1;
-	plat->axi->axi_rd_osr_lmt = 1;
-	plat->axi->axi_blen[0] = 4;
-	plat->axi->axi_blen[1] = 8;
-	plat->axi->axi_blen[2] = 16;
-
-	plat->ptp_max_adj = plat->clk_ptp_rate;
-
-	/* Set system clock */
-	plat->stmmac_clk = clk_register_fixed_rate(&pdev->dev,
-						   "stmmac-clk", NULL, 0,
-						   plat->clk_ptp_rate);
-
-	if (IS_ERR(plat->stmmac_clk)) {
-		dev_warn(&pdev->dev, "Fail to register stmmac-clk\n");
-		plat->stmmac_clk = NULL;
-	}
-	clk_prepare_enable(plat->stmmac_clk);
-
-	/* Set default value for multicast hash bins */
-	plat->multicast_filter_bins = HASH_TABLE_SIZE;
-
-	/* Set default value for unicast filter entries */
-	plat->unicast_filter_entries = 1;
-
-	/* Set the maxmtu to a default of JUMBO_LEN */
-	plat->maxmtu = JUMBO_LEN;
-
-	return 0;
-}
-
-static int ehl_common_data(struct pci_dev *pdev,
-			   struct plat_stmmacenet_data *plat)
-{
-	int ret;
-
-	plat->rx_queues_to_use = 8;
-	plat->tx_queues_to_use = 8;
-	plat->clk_ptp_rate = 200000000;
-	ret = intel_mgbe_common_data(pdev, plat);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
-static int ehl_sgmii_data(struct pci_dev *pdev,
-			  struct plat_stmmacenet_data *plat)
-{
-	plat->bus_id = 1;
-	plat->phy_addr = 0;
-	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
-
-	return ehl_common_data(pdev, plat);
-}
-
-static struct stmmac_pci_info ehl_sgmii1g_pci_info = {
-	.setup = ehl_sgmii_data,
-};
-
-static int ehl_rgmii_data(struct pci_dev *pdev,
-			  struct plat_stmmacenet_data *plat)
-{
-	plat->bus_id = 1;
-	plat->phy_addr = 0;
-	plat->phy_interface = PHY_INTERFACE_MODE_RGMII;
-
-	return ehl_common_data(pdev, plat);
-}
-
-static struct stmmac_pci_info ehl_rgmii1g_pci_info = {
-	.setup = ehl_rgmii_data,
-};
-
-static int tgl_common_data(struct pci_dev *pdev,
-			   struct plat_stmmacenet_data *plat)
-{
-	int ret;
-
-	plat->rx_queues_to_use = 6;
-	plat->tx_queues_to_use = 4;
-	plat->clk_ptp_rate = 200000000;
-	ret = intel_mgbe_common_data(pdev, plat);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-
-static int tgl_sgmii_data(struct pci_dev *pdev,
-			  struct plat_stmmacenet_data *plat)
-{
-	plat->bus_id = 1;
-	plat->phy_addr = 0;
-	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
-	return tgl_common_data(pdev, plat);
-}
-
-static struct stmmac_pci_info tgl_sgmii1g_pci_info = {
-	.setup = tgl_sgmii_data,
-};
-
-static const struct stmmac_pci_func_data galileo_stmmac_func_data[] = {
-	{
-		.func = 6,
-		.phy_addr = 1,
-	},
-};
-
-static const struct stmmac_pci_dmi_data galileo_stmmac_dmi_data = {
-	.func = galileo_stmmac_func_data,
-	.nfuncs = ARRAY_SIZE(galileo_stmmac_func_data),
-};
-
-static const struct stmmac_pci_func_data iot2040_stmmac_func_data[] = {
-	{
-		.func = 6,
-		.phy_addr = 1,
-	},
-	{
-		.func = 7,
-		.phy_addr = 1,
-	},
-};
-
-static const struct stmmac_pci_dmi_data iot2040_stmmac_dmi_data = {
-	.func = iot2040_stmmac_func_data,
-	.nfuncs = ARRAY_SIZE(iot2040_stmmac_func_data),
-};
-
-static const struct dmi_system_id quark_pci_dmi[] = {
-	{
-		.matches = {
-			DMI_EXACT_MATCH(DMI_BOARD_NAME, "Galileo"),
-		},
-		.driver_data = (void *)&galileo_stmmac_dmi_data,
-	},
-	{
-		.matches = {
-			DMI_EXACT_MATCH(DMI_BOARD_NAME, "GalileoGen2"),
-		},
-		.driver_data = (void *)&galileo_stmmac_dmi_data,
-	},
-	/*
-	 * There are 2 types of SIMATIC IOT2000: IOT2020 and IOT2040.
-	 * The asset tag "6ES7647-0AA00-0YA2" is only for IOT2020 which
-	 * has only one pci network device while other asset tags are
-	 * for IOT2040 which has two.
-	 */
-	{
-		.matches = {
-			DMI_EXACT_MATCH(DMI_BOARD_NAME, "SIMATIC IOT2000"),
-			DMI_EXACT_MATCH(DMI_BOARD_ASSET_TAG,
-					"6ES7647-0AA00-0YA2"),
-		},
-		.driver_data = (void *)&galileo_stmmac_dmi_data,
-	},
-	{
-		.matches = {
-			DMI_EXACT_MATCH(DMI_BOARD_NAME, "SIMATIC IOT2000"),
-		},
-		.driver_data = (void *)&iot2040_stmmac_dmi_data,
-	},
-	{}
-};
-
-static int quark_default_data(struct pci_dev *pdev,
-			      struct plat_stmmacenet_data *plat)
-{
-	int ret;
-
-	/* Set common default data first */
-	common_default_data(plat);
-
-	/*
-	 * Refuse to load the driver and register net device if MAC controller
-	 * does not connect to any PHY interface.
-	 */
-	ret = stmmac_pci_find_phy_addr(pdev, quark_pci_dmi);
-	if (ret < 0) {
-		/* Return error to the caller on DMI enabled boards. */
-		if (dmi_get_system_info(DMI_BOARD_NAME))
-			return ret;
-
-		/*
-		 * Galileo boards with old firmware don't support DMI. We always
-		 * use 1 here as PHY address, so at least the first found MAC
-		 * controller would be probed.
-		 */
-		ret = 1;
-	}
-
-	plat->bus_id = pci_dev_id(pdev);
-	plat->phy_addr = ret;
-	plat->phy_interface = PHY_INTERFACE_MODE_RMII;
-
-	plat->dma_cfg->pbl = 16;
-	plat->dma_cfg->pblx8 = true;
-	plat->dma_cfg->fixed_burst = 1;
-	/* AXI (TODO) */
-
-	return 0;
-}
-
-static const struct stmmac_pci_info quark_pci_info = {
-	.setup = quark_default_data,
-};
-
 static int snps_gmac5_default_data(struct pci_dev *pdev,
 				   struct plat_stmmacenet_data *plat)
 {
@@ -582,19 +277,11 @@ static SIMPLE_DEV_PM_OPS(stmmac_pm_ops, stmmac_pci_suspend, stmmac_pci_resume);
 #define PCI_VENDOR_ID_STMMAC		0x0700
 
 #define PCI_DEVICE_ID_STMMAC_STMMAC		0x1108
-#define PCI_DEVICE_ID_INTEL_QUARK_ID		0x0937
-#define PCI_DEVICE_ID_INTEL_EHL_RGMII1G_ID	0x4b30
-#define PCI_DEVICE_ID_INTEL_EHL_SGMII1G_ID	0x4b31
-#define PCI_DEVICE_ID_INTEL_TGL_SGMII1G_ID	0xa0ac
 #define PCI_DEVICE_ID_SYNOPSYS_GMAC5_ID		0x7102
 
 static const struct pci_device_id stmmac_id_table[] = {
 	{ PCI_DEVICE_DATA(STMMAC, STMMAC, &stmmac_pci_info) },
 	{ PCI_DEVICE_DATA(STMICRO, MAC, &stmmac_pci_info) },
-	{ PCI_DEVICE_DATA(INTEL, QUARK_ID, &quark_pci_info) },
-	{ PCI_DEVICE_DATA(INTEL, EHL_RGMII1G_ID, &ehl_rgmii1g_pci_info) },
-	{ PCI_DEVICE_DATA(INTEL, EHL_SGMII1G_ID, &ehl_sgmii1g_pci_info) },
-	{ PCI_DEVICE_DATA(INTEL, TGL_SGMII1G_ID, &tgl_sgmii1g_pci_info) },
 	{ PCI_DEVICE_DATA(SYNOPSYS, GMAC5_ID, &snps_gmac5_pci_info) },
 	{}
 };
-- 
2.17.1

