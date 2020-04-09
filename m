Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEA81A3767
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 17:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgDIPse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 11:48:34 -0400
Received: from mga07.intel.com ([134.134.136.100]:53939 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728243AbgDIPsd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 11:48:33 -0400
IronPort-SDR: zVHn/2SZqvryyks8Ux2G2nNPW8RX+GwrYhfD+i2UuT8JQN1GiWlAYv/P87HqDLZuKyHQU3mmwf
 g8tQOhUN5/rw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2020 08:48:29 -0700
IronPort-SDR: UoYNkDL00XyIsPgtYTTsFqQ5WZaCIchjOJpB5ZEdFmnjRMmi6J3QTpKLOkFyaR6RDGpi+f/7t3
 m05FQblVbTkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,363,1580803200"; 
   d="scan'208";a="244349165"
Received: from unknown (HELO climb.png.intel.com) ([10.221.118.165])
  by fmsmga008.fm.intel.com with ESMTP; 09 Apr 2020 08:48:26 -0700
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
Subject: [RFC,net-next,v2, 1/1] net: stmmac: Enable SERDES power up/down sequence
Date:   Thu,  9 Apr 2020 23:48:23 +0800
Message-Id: <20200409154823.26480-2-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200409154823.26480-1-weifeng.voon@intel.com>
References: <20200409154823.26480-1-weifeng.voon@intel.com>
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
mdio address 0x15 which is defined as intel_adhoc_addr. During D0,
The driver will need to power up PHY IF by changing the power state
to P0. Likewise, for D3, the driver sets PHY IF power state to P3.

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 171 ++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  10 +
 include/linux/stmmac.h                        |   3 +
 3 files changed, 184 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 5419d4e478c0..e670d9e69e88 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -5,6 +5,7 @@
 #include <linux/clk-provider.h>
 #include <linux/pci.h>
 #include <linux/dmi.h>
+#include "dwmac-intel.h"
 #include "stmmac.h"
 
 /* This struct is used to associate PCI Function of MAC controller on a board,
@@ -49,6 +50,170 @@ static int stmmac_pci_find_phy_addr(struct pci_dev *pdev,
 	return -ENODEV;
 }
 
+static int serdes_status_poll(struct stmmac_priv *priv, int phyaddr,
+			      int phyreg, u32 mask, u32 val)
+{
+	unsigned int retries = 10;
+	int val_rd = 0;
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
+static int intel_serdes_powerup(struct net_device *ndev)
+{
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	int serdes_phy_addr = 0;
+	u32 data = 0;
+
+	if (!priv->plat->intel_adhoc_addr)
+		return 0;
+
+	serdes_phy_addr = priv->plat->intel_adhoc_addr;
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
+static void intel_serdes_powerdown(struct net_device *ndev)
+{
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	int serdes_phy_addr = 0;
+	u32 data = 0;
+
+	serdes_phy_addr = priv->plat->intel_adhoc_addr;
+
+	if (!priv->plat->intel_adhoc_addr)
+		return;
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
@@ -89,6 +254,9 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 	plat->force_sf_dma_mode = 0;
 	plat->tso_en = 1;
 
+	/* intel specific adhoc (mdio) address for serdes & etc */
+	plat->intel_adhoc_addr = 0x15;
+
 	plat->rx_sched_algorithm = MTL_RX_ALGORITHM_SP;
 
 	for (i = 0; i < plat->rx_queues_to_use; i++) {
@@ -189,6 +357,9 @@ static int ehl_sgmii_data(struct pci_dev *pdev,
 	plat->phy_addr = 0;
 	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
 
+	plat->serdes_powerup = intel_serdes_powerup;
+	plat->serdes_powerdown = intel_serdes_powerdown;
+
 	return ehl_common_data(pdev, plat);
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e6898fd5223f..06112c421ac3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4986,6 +4986,13 @@ int stmmac_dvr_probe(struct device *device,
 		goto error_netdev_register;
 	}
 
+	if (priv->plat->serdes_powerup) {
+		ret = priv->plat->serdes_powerup(ndev);
+
+		if (ret < 0)
+			return ret;
+	}
+
 #ifdef CONFIG_DEBUG_FS
 	stmmac_init_fs(ndev);
 #endif
@@ -5029,6 +5036,9 @@ int stmmac_dvr_remove(struct device *dev)
 
 	stmmac_stop_all_dma(priv);
 
+	if (priv->plat->serdes_powerdown)
+		priv->plat->serdes_powerdown(ndev);
+
 	stmmac_mac_set(priv, priv->ioaddr, false);
 	netif_carrier_off(ndev);
 	unregister_netdev(ndev);
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index fbafb353e9be..89c8729bbe5b 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -147,6 +147,7 @@ struct plat_stmmacenet_data {
 	int bus_id;
 	int phy_addr;
 	int interface;
+	int intel_adhoc_addr;
 	phy_interface_t phy_interface;
 	struct stmmac_mdio_bus_data *mdio_bus_data;
 	struct device_node *phy_node;
@@ -177,6 +178,8 @@ struct plat_stmmacenet_data {
 	struct stmmac_rxq_cfg rx_queues_cfg[MTL_MAX_RX_QUEUES];
 	struct stmmac_txq_cfg tx_queues_cfg[MTL_MAX_TX_QUEUES];
 	void (*fix_mac_speed)(void *priv, unsigned int speed);
+	int (*serdes_powerup)(struct net_device *ndev);
+	void (*serdes_powerdown)(struct net_device *ndev);
 	int (*init)(struct platform_device *pdev, void *priv);
 	void (*exit)(struct platform_device *pdev, void *priv);
 	struct mac_device_info *(*setup)(void *priv);
-- 
2.17.1

