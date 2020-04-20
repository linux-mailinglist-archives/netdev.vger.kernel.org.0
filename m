Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5851B106D
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbgDTPnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:43:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:12546 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbgDTPnA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 11:43:00 -0400
IronPort-SDR: qmO0NLDHVXW+ZxVSLhxktclRAojP8DSBeYA0E8GCQtOLuDMs3D7qTTPOSKdU2QIc46Ernzgjju
 ZUDA2ORUaSDQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 08:42:59 -0700
IronPort-SDR: tGIYQ/8jXtt0Gi4cMrmtuBCH1XeutUPCZsqE6F/ysEEiQ9lB8A52Nv7Xw81fkxl7EU9QCE/oBY
 5sYjPZAmYuyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,407,1580803200"; 
   d="scan'208";a="429169860"
Received: from unknown (HELO climb.png.intel.com) ([10.221.118.165])
  by orsmga005.jf.intel.com with ESMTP; 20 Apr 2020 08:42:56 -0700
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
Subject: [net-next,v1, 1/1] net: stmmac: Enable SERDES power up/down sequence
Date:   Mon, 20 Apr 2020 23:42:52 +0800
Message-Id: <20200420154252.8000-2-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200420154252.8000-1-weifeng.voon@intel.com>
References: <20200420154252.8000-1-weifeng.voon@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to enable Intel SERDES power up/down sequence. The SERDES
converts 8/10 bits data to SGMII signal. Below is an example of
HW configuration for SGMII mode. The SERDES is located in the PHY IF
in the diagram below.

<-----------------GBE Controller---------->|<--External PHY chip-->
+----------+         +----+            +---+           +----------+
|   EQoS   | <-GMII->| DW | < ------ > |PHY| <-SGMII-> | External |
|   MAC    |         |xPCS|            |IF |           | PHY      |
+----------+         +----+            +---+           +----------+
       ^               ^                 ^                ^
       |               |                 |                |
       +---------------------MDIO-------------------------+

PHY IF configuration and status registers are accessible through
mdio address 0x15 which is defined as mdio_adhoc_addr. During D0,
The driver will need to power up PHY IF by changing the power state
to P0. Likewise, for D3, the driver sets PHY IF power state to P3.

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 189 ++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/dwmac-intel.h |  23 +++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  23 +++
 include/linux/stmmac.h                        |   2 +
 4 files changed, 237 insertions(+)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 5419d4e478c0..2e4aaedb93f5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -5,8 +5,13 @@
 #include <linux/clk-provider.h>
 #include <linux/pci.h>
 #include <linux/dmi.h>
+#include "dwmac-intel.h"
 #include "stmmac.h"
 
+struct intel_priv_data {
+	int mdio_adhoc_addr;	/* mdio address for serdes & etc */
+};
+
 /* This struct is used to associate PCI Function of MAC controller on a board,
  * discovered via DMI, with the address of PHY connected to the MAC. The
  * negative value of the address means that MAC controller is not connected
@@ -49,6 +54,172 @@ static int stmmac_pci_find_phy_addr(struct pci_dev *pdev,
 	return -ENODEV;
 }
 
+static int serdes_status_poll(struct stmmac_priv *priv, int phyaddr,
+			      int phyreg, u32 mask, u32 val)
+{
+	unsigned int retries = 10;
+	int val_rd;
+
+	do {
+		val_rd = mdiobus_read(priv->mii, phyaddr, phyreg);
+		if ((val_rd & mask) == (val & mask))
+			return 0;
+		udelay(POLL_DELAY_US);
+	} while (--retries);
+
+	return -ETIMEDOUT;
+}
+
+static int intel_serdes_powerup(struct net_device *ndev, void *priv_data)
+{
+	struct intel_priv_data *intel_priv = priv_data;
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	int serdes_phy_addr = 0;
+	u32 data = 0;
+
+	if (!intel_priv->mdio_adhoc_addr)
+		return 0;
+
+	serdes_phy_addr = intel_priv->mdio_adhoc_addr;
+
+	/* assert clk_req */
+	data = mdiobus_read(priv->mii, serdes_phy_addr,
+			    SERDES_GCR0);
+
+	data |= SERDES_PLL_CLK;
+
+	mdiobus_write(priv->mii, serdes_phy_addr,
+		      SERDES_GCR0, data);
+
+	/* check for clk_ack assertion */
+	data = serdes_status_poll(priv, serdes_phy_addr,
+				  SERDES_GSR0,
+				  SERDES_PLL_CLK,
+				  SERDES_PLL_CLK);
+
+	if (data) {
+		dev_err(priv->device, "Serdes PLL clk request timeout\n");
+		return data;
+	}
+
+	/* assert lane reset */
+	data = mdiobus_read(priv->mii, serdes_phy_addr,
+			    SERDES_GCR0);
+
+	data |= SERDES_RST;
+
+	mdiobus_write(priv->mii, serdes_phy_addr,
+		      SERDES_GCR0, data);
+
+	/* check for assert lane reset reflection */
+	data = serdes_status_poll(priv, serdes_phy_addr,
+				  SERDES_GSR0,
+				  SERDES_RST,
+				  SERDES_RST);
+
+	if (data) {
+		dev_err(priv->device, "Serdes assert lane reset timeout\n");
+		return data;
+	}
+
+	/*  move power state to P0 */
+	data = mdiobus_read(priv->mii, serdes_phy_addr,
+			    SERDES_GCR0);
+
+	data &= ~SERDES_PWR_ST_MASK;
+	data |= SERDES_PWR_ST_P0 << SERDES_PWR_ST_SHIFT;
+
+	mdiobus_write(priv->mii, serdes_phy_addr,
+		      SERDES_GCR0, data);
+
+	/* Check for P0 state */
+	data = serdes_status_poll(priv, serdes_phy_addr,
+				  SERDES_GSR0,
+				  SERDES_PWR_ST_MASK,
+				  SERDES_PWR_ST_P0 << SERDES_PWR_ST_SHIFT);
+
+	if (data) {
+		dev_err(priv->device, "Serdes power state P0 timeout.\n");
+		return data;
+	}
+
+	return 0;
+}
+
+static void intel_serdes_powerdown(struct net_device *ndev, void *intel_data)
+{
+	struct intel_priv_data *intel_priv = intel_data;
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	int serdes_phy_addr = 0;
+	u32 data = 0;
+
+	if (!intel_priv->mdio_adhoc_addr)
+		return;
+
+	serdes_phy_addr = intel_priv->mdio_adhoc_addr;
+
+	/*  move power state to P3 */
+	data = mdiobus_read(priv->mii, serdes_phy_addr,
+			    SERDES_GCR0);
+
+	data &= ~SERDES_PWR_ST_MASK;
+	data |= SERDES_PWR_ST_P3 << SERDES_PWR_ST_SHIFT;
+
+	mdiobus_write(priv->mii, serdes_phy_addr,
+		      SERDES_GCR0, data);
+
+	/* Check for P3 state */
+	data = serdes_status_poll(priv, serdes_phy_addr,
+				  SERDES_GSR0,
+				  SERDES_PWR_ST_MASK,
+				  SERDES_PWR_ST_P3 << SERDES_PWR_ST_SHIFT);
+
+	if (data) {
+		dev_err(priv->device, "Serdes power state P3 timeout\n");
+		return;
+	}
+
+	/* de-assert clk_req */
+	data = mdiobus_read(priv->mii, serdes_phy_addr,
+			    SERDES_GCR0);
+
+	data &= ~SERDES_PLL_CLK;
+
+	mdiobus_write(priv->mii, serdes_phy_addr,
+		      SERDES_GCR0, data);
+
+	/* check for clk_ack de-assert */
+	data = serdes_status_poll(priv, serdes_phy_addr,
+				  SERDES_GSR0,
+				  SERDES_PLL_CLK,
+				  (u32)~SERDES_PLL_CLK);
+
+	if (data) {
+		dev_err(priv->device, "Serdes PLL clk de-assert timeout\n");
+		return;
+	}
+
+	/* de-assert lane reset */
+	data = mdiobus_read(priv->mii, serdes_phy_addr,
+			    SERDES_GCR0);
+
+	data &= ~SERDES_RST;
+
+	mdiobus_write(priv->mii, serdes_phy_addr,
+		      SERDES_GCR0, data);
+
+	/* check for de-assert lane reset reflection */
+	data = serdes_status_poll(priv, serdes_phy_addr,
+				  SERDES_GSR0,
+				  SERDES_RST,
+				  (u32)~SERDES_RST);
+
+	if (data) {
+		dev_err(priv->device, "Serdes de-assert lane reset timeout\n");
+		return;
+	}
+}
+
 static void common_default_data(struct plat_stmmacenet_data *plat)
 {
 	plat->clk_csr = 2;	/* clk_csr_i = 20-35MHz & MDC = clk_csr_i/16 */
@@ -189,6 +360,9 @@ static int ehl_sgmii_data(struct pci_dev *pdev,
 	plat->phy_addr = 0;
 	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
 
+	plat->serdes_powerup = intel_serdes_powerup;
+	plat->serdes_powerdown = intel_serdes_powerdown;
+
 	return ehl_common_data(pdev, plat);
 }
 
@@ -233,6 +407,8 @@ static int ehl_pse0_sgmii1g_data(struct pci_dev *pdev,
 				 struct plat_stmmacenet_data *plat)
 {
 	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
+	plat->serdes_powerup = intel_serdes_powerup;
+	plat->serdes_powerdown = intel_serdes_powerdown;
 	return ehl_pse0_common_data(pdev, plat);
 }
 
@@ -263,6 +439,8 @@ static int ehl_pse1_sgmii1g_data(struct pci_dev *pdev,
 				 struct plat_stmmacenet_data *plat)
 {
 	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
+	plat->serdes_powerup = intel_serdes_powerup;
+	plat->serdes_powerdown = intel_serdes_powerdown;
 	return ehl_pse1_common_data(pdev, plat);
 }
 
@@ -291,6 +469,8 @@ static int tgl_sgmii_data(struct pci_dev *pdev,
 	plat->bus_id = 1;
 	plat->phy_addr = 0;
 	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
+	plat->serdes_powerup = intel_serdes_powerup;
+	plat->serdes_powerdown = intel_serdes_powerdown;
 	return tgl_common_data(pdev, plat);
 }
 
@@ -417,11 +597,17 @@ static int intel_eth_pci_probe(struct pci_dev *pdev,
 			       const struct pci_device_id *id)
 {
 	struct stmmac_pci_info *info = (struct stmmac_pci_info *)id->driver_data;
+	struct intel_priv_data *intel_priv;
 	struct plat_stmmacenet_data *plat;
 	struct stmmac_resources res;
 	int i;
 	int ret;
 
+	intel_priv = devm_kzalloc(&pdev->dev, sizeof(*intel_priv),
+				  GFP_KERNEL);
+	if (!intel_priv)
+		return -ENOMEM;
+
 	plat = devm_kzalloc(&pdev->dev, sizeof(*plat), GFP_KERNEL);
 	if (!plat)
 		return -ENOMEM;
@@ -457,6 +643,9 @@ static int intel_eth_pci_probe(struct pci_dev *pdev,
 
 	pci_set_master(pdev);
 
+	plat->bsp_priv = intel_priv;
+	intel_priv->mdio_adhoc_addr = 0x15;
+
 	ret = info->setup(pdev, plat);
 	if (ret)
 		return ret;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h
new file mode 100644
index 000000000000..e723096c0b15
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2020, Intel Corporation
+ * DWMAC Intel header file
+ */
+
+#ifndef __DWMAC_INTEL_H__
+#define __DWMAC_INTEL_H__
+
+#define POLL_DELAY_US 8
+
+/* SERDES Register */
+#define SERDES_GSR0	0x5	/* Global Status Reg0 */
+#define SERDES_GCR0	0xb	/* Global Configuration Reg0 */
+
+/* SERDES defines */
+#define SERDES_PLL_CLK		BIT(0)		/* PLL clk valid signal */
+#define SERDES_RST		BIT(2)		/* Serdes Reset */
+#define SERDES_PWR_ST_MASK	GENMASK(6, 4)	/* Serdes Power state*/
+#define SERDES_PWR_ST_SHIFT	4
+#define SERDES_PWR_ST_P0	0x0
+#define SERDES_PWR_ST_P3	0x3
+
+#endif /* __DWMAC_INTEL_H__ */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e6898fd5223f..565da6498c84 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4986,6 +4986,14 @@ int stmmac_dvr_probe(struct device *device,
 		goto error_netdev_register;
 	}
 
+	if (priv->plat->serdes_powerup) {
+		ret = priv->plat->serdes_powerup(ndev,
+						 priv->plat->bsp_priv);
+
+		if (ret < 0)
+			return ret;
+	}
+
 #ifdef CONFIG_DEBUG_FS
 	stmmac_init_fs(ndev);
 #endif
@@ -5029,6 +5037,9 @@ int stmmac_dvr_remove(struct device *dev)
 
 	stmmac_stop_all_dma(priv);
 
+	if (priv->plat->serdes_powerdown)
+		priv->plat->serdes_powerdown(ndev, priv->plat->bsp_priv);
+
 	stmmac_mac_set(priv, priv->ioaddr, false);
 	netif_carrier_off(ndev);
 	unregister_netdev(ndev);
@@ -5081,6 +5092,9 @@ int stmmac_suspend(struct device *dev)
 	/* Stop TX/RX DMA */
 	stmmac_stop_all_dma(priv);
 
+	if (priv->plat->serdes_powerdown)
+		priv->plat->serdes_powerdown(ndev, priv->plat->bsp_priv);
+
 	/* Enable Power down mode by programming the PMT regs */
 	if (device_may_wakeup(priv->device)) {
 		stmmac_pmt(priv, priv->hw, priv->wolopts);
@@ -5143,6 +5157,7 @@ int stmmac_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
+	int ret;
 
 	if (!netif_running(ndev))
 		return 0;
@@ -5170,6 +5185,14 @@ int stmmac_resume(struct device *dev)
 			stmmac_mdio_reset(priv->mii);
 	}
 
+	if (priv->plat->serdes_powerup) {
+		ret = priv->plat->serdes_powerup(ndev,
+						 priv->plat->bsp_priv);
+
+		if (ret < 0)
+			return ret;
+	}
+
 	netif_device_attach(ndev);
 
 	mutex_lock(&priv->lock);
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index fbafb353e9be..bd964c31d333 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -177,6 +177,8 @@ struct plat_stmmacenet_data {
 	struct stmmac_rxq_cfg rx_queues_cfg[MTL_MAX_RX_QUEUES];
 	struct stmmac_txq_cfg tx_queues_cfg[MTL_MAX_TX_QUEUES];
 	void (*fix_mac_speed)(void *priv, unsigned int speed);
+	int (*serdes_powerup)(struct net_device *ndev, void *priv);
+	void (*serdes_powerdown)(struct net_device *ndev, void *priv);
 	int (*init)(struct platform_device *pdev, void *priv);
 	void (*exit)(struct platform_device *pdev, void *priv);
 	struct mac_device_info *(*setup)(void *priv);
-- 
2.17.1

