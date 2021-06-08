Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0EA339ED3A
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 05:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhFHD6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 23:58:39 -0400
Received: from mga04.intel.com ([192.55.52.120]:59065 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230508AbhFHD6h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 23:58:37 -0400
IronPort-SDR: R74IqX8XRhQC8Y4Ytt+1oKbEbVBZn/PDRS3DzXqlv8atIjArc3sZt+3VzL/2An5x5KTehhz0vQ
 ij+cOHlX6D0w==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="202907311"
X-IronPort-AV: E=Sophos;i="5.83,256,1616482800"; 
   d="scan'208";a="202907311"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 20:56:45 -0700
IronPort-SDR: l1L7W+UP9YLs0yl6lWj/Cu7qt91b7puFRfPZDGoqmw4c1SzoWOBx/cu6pW/D6p6fDA3WEokzV5
 wMRBS31nsDDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,256,1616482800"; 
   d="scan'208";a="440308787"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by orsmga007.jf.intel.com with ESMTP; 07 Jun 2021 20:56:40 -0700
From:   Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
To:     Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        davem@davemloft.net, mcoquelin.stm32@gmail.com,
        weifeng.voon@intel.com, boon.leong.ong@intel.com,
        tee.min.tan@intel.com, vee.khee.wong@linux.intel.com,
        vee.khee.wong@intel.com, michael.wei.hong.sit@intel.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vladimir.oltean@nxp.com
Subject: [PATCH net-next v6 3/3] net: stmmac: enable Intel mGbE 2.5Gbps link speed
Date:   Tue,  8 Jun 2021 11:51:58 +0800
Message-Id: <20210608035158.4869-4-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210608035158.4869-1-michael.wei.hong.sit@intel.com>
References: <20210608035158.4869-1-michael.wei.hong.sit@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>

The Intel mGbE supports 2.5Gbps link speed by increasing the clock rate by
2.5 times of the original rate. In this mode, the serdes/PHY operates at a
serial baud rate of 3.125 Gbps and the PCS data path and GMII interface of
the MAC operate at 312.5 MHz instead of 125 MHz.

For Intel mGbE, the overclocking of 2.5 times clock rate to support 2.5G is
only able to be configured in the BIOS during boot time. Kernel driver has
no access to modify the clock rate for 1Gbps/2.5G mode. The way to
determined the current 1G/2.5G mode is by reading a dedicated adhoc
register through mdio bus. In short, after the system boot up, it is either
in 1G mode or 2.5G mode which not able to be changed on the fly.

Compared to 1G mode, the 2.5G mode selects the 2500BASEX as PHY interface and
disables the xpcs_an_inband. This is to cater for some PHYs that only
supports 2500BASEX PHY interface with no autonegotiation.

v2: remove MAC supported link speed masking
v3: Restructure  to introduce intel_speed_mode_2500() to read serdes registers
    for max speed supported and select the appropritate configuration.
    Use max_speed to determine the supported link speed mask.

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 48 ++++++++++++++++++-
 .../net/ethernet/stmicro/stmmac/dwmac-intel.h | 13 +++++
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c |  1 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  7 +++
 include/linux/stmmac.h                        |  1 +
 5 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 2ecf93c84b9d..6a9a19b0844c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -102,6 +102,22 @@ static int intel_serdes_powerup(struct net_device *ndev, void *priv_data)
 
 	serdes_phy_addr = intel_priv->mdio_adhoc_addr;
 
+	/* Set the serdes rate and the PCLK rate */
+	data = mdiobus_read(priv->mii, serdes_phy_addr,
+			    SERDES_GCR0);
+
+	data &= ~SERDES_RATE_MASK;
+	data &= ~SERDES_PCLK_MASK;
+
+	if (priv->plat->max_speed == 2500)
+		data |= SERDES_RATE_PCIE_GEN2 << SERDES_RATE_PCIE_SHIFT |
+			SERDES_PCLK_37p5MHZ << SERDES_PCLK_SHIFT;
+	else
+		data |= SERDES_RATE_PCIE_GEN1 << SERDES_RATE_PCIE_SHIFT |
+			SERDES_PCLK_70MHZ << SERDES_PCLK_SHIFT;
+
+	mdiobus_write(priv->mii, serdes_phy_addr, SERDES_GCR0, data);
+
 	/* assert clk_req */
 	data = mdiobus_read(priv->mii, serdes_phy_addr, SERDES_GCR0);
 	data |= SERDES_PLL_CLK;
@@ -230,6 +246,32 @@ static void intel_serdes_powerdown(struct net_device *ndev, void *intel_data)
 	}
 }
 
+static void intel_speed_mode_2500(struct net_device *ndev, void *intel_data)
+{
+	struct intel_priv_data *intel_priv = intel_data;
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	int serdes_phy_addr = 0;
+	u32 data = 0;
+
+	serdes_phy_addr = intel_priv->mdio_adhoc_addr;
+
+	/* Determine the link speed mode: 2.5Gbps/1Gbps */
+	data = mdiobus_read(priv->mii, serdes_phy_addr,
+			    SERDES_GCR);
+
+	if (((data & SERDES_LINK_MODE_MASK) >> SERDES_LINK_MODE_SHIFT) ==
+	    SERDES_LINK_MODE_2G5) {
+		dev_info(priv->device, "Link Speed Mode: 2.5Gbps\n");
+		priv->plat->max_speed = 2500;
+		priv->plat->phy_interface = PHY_INTERFACE_MODE_2500BASEX;
+		priv->plat->mdio_bus_data->xpcs_an_inband = false;
+	} else {
+		priv->plat->max_speed = 1000;
+		priv->plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
+		priv->plat->mdio_bus_data->xpcs_an_inband = true;
+	}
+}
+
 /* Program PTP Clock Frequency for different variant of
  * Intel mGBE that has slightly different GPO mapping
  */
@@ -586,7 +628,7 @@ static int ehl_sgmii_data(struct pci_dev *pdev,
 {
 	plat->bus_id = 1;
 	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
-
+	plat->speed_mode_2500 = intel_speed_mode_2500;
 	plat->serdes_powerup = intel_serdes_powerup;
 	plat->serdes_powerdown = intel_serdes_powerdown;
 
@@ -639,6 +681,7 @@ static int ehl_pse0_sgmii1g_data(struct pci_dev *pdev,
 				 struct plat_stmmacenet_data *plat)
 {
 	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
+	plat->speed_mode_2500 = intel_speed_mode_2500;
 	plat->serdes_powerup = intel_serdes_powerup;
 	plat->serdes_powerdown = intel_serdes_powerdown;
 	return ehl_pse0_common_data(pdev, plat);
@@ -677,6 +720,7 @@ static int ehl_pse1_sgmii1g_data(struct pci_dev *pdev,
 				 struct plat_stmmacenet_data *plat)
 {
 	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
+	plat->speed_mode_2500 = intel_speed_mode_2500;
 	plat->serdes_powerup = intel_serdes_powerup;
 	plat->serdes_powerdown = intel_serdes_powerdown;
 	return ehl_pse1_common_data(pdev, plat);
@@ -711,6 +755,7 @@ static int tgl_sgmii_phy0_data(struct pci_dev *pdev,
 {
 	plat->bus_id = 1;
 	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
+	plat->speed_mode_2500 = intel_speed_mode_2500;
 	plat->serdes_powerup = intel_serdes_powerup;
 	plat->serdes_powerdown = intel_serdes_powerdown;
 	return tgl_common_data(pdev, plat);
@@ -725,6 +770,7 @@ static int tgl_sgmii_phy1_data(struct pci_dev *pdev,
 {
 	plat->bus_id = 2;
 	plat->phy_interface = PHY_INTERFACE_MODE_SGMII;
+	plat->speed_mode_2500 = intel_speed_mode_2500;
 	plat->serdes_powerup = intel_serdes_powerup;
 	plat->serdes_powerdown = intel_serdes_powerdown;
 	return tgl_common_data(pdev, plat);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h
index 542acb8ce467..20d14e588044 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h
@@ -9,6 +9,7 @@
 #define POLL_DELAY_US 8
 
 /* SERDES Register */
+#define SERDES_GCR	0x0	/* Global Conguration */
 #define SERDES_GSR0	0x5	/* Global Status Reg0 */
 #define SERDES_GCR0	0xb	/* Global Configuration Reg0 */
 
@@ -17,8 +18,20 @@
 #define SERDES_PHY_RX_CLK	BIT(1)		/* PSE SGMII PHY rx clk */
 #define SERDES_RST		BIT(2)		/* Serdes Reset */
 #define SERDES_PWR_ST_MASK	GENMASK(6, 4)	/* Serdes Power state*/
+#define SERDES_RATE_MASK	GENMASK(9, 8)
+#define SERDES_PCLK_MASK	GENMASK(14, 12)	/* PCLK rate to PHY */
+#define SERDES_LINK_MODE_MASK	GENMASK(2, 1)
+#define SERDES_LINK_MODE_SHIFT	1
 #define SERDES_PWR_ST_SHIFT	4
 #define SERDES_PWR_ST_P0	0x0
 #define SERDES_PWR_ST_P3	0x3
+#define SERDES_LINK_MODE_2G5	0x3
+#define SERSED_LINK_MODE_1G	0x2
+#define SERDES_PCLK_37p5MHZ	0x0
+#define SERDES_PCLK_70MHZ	0x1
+#define SERDES_RATE_PCIE_GEN1	0x0
+#define SERDES_RATE_PCIE_GEN2	0x1
+#define SERDES_RATE_PCIE_SHIFT	8
+#define SERDES_PCLK_SHIFT	12
 
 #endif /* __DWMAC_INTEL_H__ */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index f35c03c9f91e..67ba083eb90c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -1358,6 +1358,7 @@ int dwmac4_setup(struct stmmac_priv *priv)
 	mac->link.speed10 = GMAC_CONFIG_PS;
 	mac->link.speed100 = GMAC_CONFIG_FES | GMAC_CONFIG_PS;
 	mac->link.speed1000 = 0;
+	mac->link.speed2500 = GMAC_CONFIG_FES;
 	mac->link.speed_mask = GMAC_CONFIG_FES | GMAC_CONFIG_PS;
 	mac->mii.addr = GMAC_MDIO_ADDR;
 	mac->mii.data = GMAC_MDIO_DATA;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index af406ea3dd46..1b12a2f8bfb5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -931,6 +931,10 @@ static void stmmac_validate(struct phylink_config *config,
 	if ((max_speed > 0) && (max_speed < 1000)) {
 		phylink_set(mask, 1000baseT_Full);
 		phylink_set(mask, 1000baseX_Full);
+	} else if (priv->plat->has_gmac4) {
+		if (!max_speed || max_speed >= 2500)
+			phylink_set(mac_supported, 2500baseT_Full);
+			phylink_set(mac_supported, 2500baseX_Full);
 	} else if (priv->plat->has_xgmac) {
 		if (!max_speed || (max_speed >= 2500)) {
 			phylink_set(mac_supported, 2500baseT_Full);
@@ -6993,6 +6997,9 @@ int stmmac_dvr_probe(struct device *device,
 		}
 	}
 
+	if (priv->plat->speed_mode_2500)
+		priv->plat->speed_mode_2500(ndev, priv->plat->bsp_priv);
+
 	if (priv->plat->mdio_bus_data) {
 		if (priv->plat->mdio_bus_data->has_xpcs) {
 			ret = stmmac_xpcs_setup(priv->mii);
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index e55a4807e3ea..b10be3385a30 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -223,6 +223,7 @@ struct plat_stmmacenet_data {
 	void (*fix_mac_speed)(void *priv, unsigned int speed);
 	int (*serdes_powerup)(struct net_device *ndev, void *priv);
 	void (*serdes_powerdown)(struct net_device *ndev, void *priv);
+	void (*speed_mode_2500)(struct net_device *ndev, void *priv);
 	void (*ptp_clk_freq_config)(void *priv);
 	int (*init)(struct platform_device *pdev, void *priv);
 	void (*exit)(struct platform_device *pdev, void *priv);
-- 
2.17.1

