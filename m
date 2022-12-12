Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5417F649CFB
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 11:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbiLLKyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 05:54:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbiLLKx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 05:53:26 -0500
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4408213EA9
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 02:44:01 -0800 (PST)
X-QQ-mid: bizesmtp76t1670841724t18o36p6
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 12 Dec 2022 18:41:55 +0800 (CST)
X-QQ-SSF: 01400000000000M0N000000A0000000
X-QQ-FEAT: SvZvpX3qHzNF0jvYUAn4Sk+T2TD8smKEVOxHuzDjhpBIAjghAYiK79UMQH2l3
        vrQlaQyuPnyC5Hhc0Xr1vK++TeXfDeUjnDbN2RqLZBWQRD3bHhVwKJtm2zON54qoSlafuzd
        +hfMTIjxVJm/F/RGgVmPdL29d/z+1x1brBjQV4zmu85lsPHTkGDZnxVPYMidlsD29fMXJ4q
        vrLZITO5n6Sk9S05eKuoMJnQNIZsfKM8b/NYfqJcKO54MWlTuYDzysuVqUUnmwfzu5jnqlN
        3batYsH6efSAChbtZ3OvB748wxQYD05V8sEsM3x35j04gEcDY6Dprgll+1vtiBOj6f+fZTk
        v7r2YY84brlZXuwxkcf+xv1xOuYiaRu9iQTSMPyvpeFxEnvbeSN3LXsGJK4hjtiaocBP6OM
        GhzXmRzdg8eA2Bc1mXBHdQ==
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v5] net: ngbe: Add ngbe mdio bus driver.
Date:   Mon, 12 Dec 2022 18:41:52 +0800
Message-Id: <20221212104152.40082-1-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add mdio bus register for ngbe.
The internal phy and external phy need to be handled separately.
Add phy changed event detection.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
Change log:
v5: address comments:
	Andrew Lunn: https://lore.kernel.org/netdev/Y5RjwYgetMdzlQVZ@lunn.ch/
v4: address comments:
	Jiri Pirko: https://lore.kernel.org/netdev/Y5L9m%2FMMOG6GTNrb@nanopsycho/
v3: address comments:
	Jakub Kicinski: https://lore.kernel.org/netdev/20221208194215.55bc2ee1@kernel.org/
v2: address comments:
	Andrew Lunn: https://lore.kernel.org/netdev/Y4p0dQWijzQMlBmW@lunn.ch/

 drivers/net/ethernet/wangxun/Kconfig          |   1 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |   4 +
 drivers/net/ethernet/wangxun/ngbe/Makefile    |   2 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   |  36 ++-
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h   |   1 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  84 +++---
 drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c | 250 ++++++++++++++++++
 drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.h |  12 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  60 ++---
 9 files changed, 374 insertions(+), 76 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.h

diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index 86310588c6c1..0922beac3ec0 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -25,6 +25,7 @@ config NGBE
 	tristate "Wangxun(R) GbE PCI Express adapters support"
 	depends on PCI
 	select LIBWX
+	select PHYLIB
 	help
 	  This driver supports Wangxun(R) GbE PCI Express family of
 	  adapters.
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 1cbeef8230bf..3908f64ae9e7 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -133,11 +133,15 @@
 /************************************* ETH MAC *****************************/
 #define WX_MAC_TX_CFG                0x11000
 #define WX_MAC_TX_CFG_TE             BIT(0)
+#define WX_MAC_TX_CFG_SPEED_MASK     GENMASK(30, 29)
+#define WX_MAC_TX_CFG_SPEED_10G      (0x0 << 29)
+#define WX_MAC_TX_CFG_SPEED_1G       (0x3 << 29)
 #define WX_MAC_RX_CFG                0x11004
 #define WX_MAC_RX_CFG_RE             BIT(0)
 #define WX_MAC_RX_CFG_JE             BIT(8)
 #define WX_MAC_PKT_FLT               0x11008
 #define WX_MAC_PKT_FLT_PR            BIT(0) /* promiscuous mode */
+#define WX_MAC_WDG_TIMEOUT           0x1100C
 #define WX_MAC_RX_FLOW_CTRL          0x11090
 #define WX_MAC_RX_FLOW_CTRL_RFE      BIT(0) /* receive fc enable */
 #define WX_MMC_CONTROL               0x11800
diff --git a/drivers/net/ethernet/wangxun/ngbe/Makefile b/drivers/net/ethernet/wangxun/ngbe/Makefile
index 391c2cbc1bb4..50fdca87d2a5 100644
--- a/drivers/net/ethernet/wangxun/ngbe/Makefile
+++ b/drivers/net/ethernet/wangxun/ngbe/Makefile
@@ -6,4 +6,4 @@
 
 obj-$(CONFIG_NGBE) += ngbe.o
 
-ngbe-objs := ngbe_main.o ngbe_hw.o
+ngbe-objs := ngbe_main.o ngbe_hw.o ngbe_mdio.o
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
index 0e3923b3737e..2e8e1a4034bb 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
@@ -53,6 +53,17 @@ static int ngbe_reset_misc(struct ngbe_hw *hw)
 	return 0;
 }
 
+void ngbe_sfp_modules_txrx_powerctl(struct wx_hw *wxhw, bool swi)
+{
+	if (swi) {
+		/* gpio0 is used to power on control*/
+		wr32(wxhw, NGBE_GPIO_DR, 0);
+	} else {
+		/* gpio0 is used to power off control*/
+		wr32(wxhw, NGBE_GPIO_DR, NGBE_GPIO_DR_0);
+	}
+}
+
 /**
  *  ngbe_reset_hw - Perform hardware reset
  *  @hw: pointer to hardware structure
@@ -64,15 +75,26 @@ static int ngbe_reset_misc(struct ngbe_hw *hw)
 int ngbe_reset_hw(struct ngbe_hw *hw)
 {
 	struct wx_hw *wxhw = &hw->wxhw;
-	int status = 0;
-	u32 reset = 0;
+	u32 val = 0;
+	int ret = 0;
 
 	/* Call adapter stop to disable tx/rx and clear interrupts */
-	status = wx_stop_adapter(wxhw);
-	if (status != 0)
-		return status;
-	reset = WX_MIS_RST_LAN_RST(wxhw->bus.func);
-	wr32(wxhw, WX_MIS_RST, reset | rd32(wxhw, WX_MIS_RST));
+	ret = wx_stop_adapter(wxhw);
+	if (ret != 0)
+		return ret;
+
+	if (hw->mac_type != ngbe_mac_type_mdi) {
+		val = WX_MIS_RST_LAN_RST(wxhw->bus.func);
+		wr32(wxhw, WX_MIS_RST, val | rd32(wxhw, WX_MIS_RST));
+
+		ret = read_poll_timeout(rd32, val,
+					!(val & (BIT(9) << wxhw->bus.func)), 1000,
+					100000, false, wxhw, 0x10028);
+		if (ret) {
+			wx_err(wxhw, "Lan reset exceed s maximum times.\n");
+			return ret;
+		}
+	}
 	ngbe_reset_misc(hw);
 
 	/* Store the permanent mac address */
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
index 42476a3fe57c..977e4dd7763e 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
@@ -8,5 +8,6 @@
 #define _NGBE_HW_H_
 
 int ngbe_eeprom_chksum_hostif(struct ngbe_hw *hw);
+void ngbe_sfp_modules_txrx_powerctl(struct wx_hw *wxhw, bool swi);
 int ngbe_reset_hw(struct ngbe_hw *hw);
 #endif /* _NGBE_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index f0b24366da18..4cc2e0de5ba2 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -9,10 +9,12 @@
 #include <linux/aer.h>
 #include <linux/etherdevice.h>
 #include <net/ip.h>
+#include <linux/phy.h>
 
 #include "../libwx/wx_type.h"
 #include "../libwx/wx_hw.h"
 #include "ngbe_type.h"
+#include "ngbe_mdio.h"
 #include "ngbe_hw.h"
 #include "ngbe.h"
 char ngbe_driver_name[] = "ngbe";
@@ -61,46 +63,17 @@ static void ngbe_init_type_code(struct ngbe_hw *hw)
 	int wol_mask = 0, ncsi_mask = 0;
 	struct wx_hw *wxhw = &hw->wxhw;
 	u16 type_mask = 0;
+	u16 val;
 
 	wxhw->mac.type = wx_mac_em;
 	type_mask = (u16)(wxhw->subsystem_device_id & NGBE_OEM_MASK);
 	ncsi_mask = wxhw->subsystem_device_id & NGBE_NCSI_MASK;
 	wol_mask = wxhw->subsystem_device_id & NGBE_WOL_MASK;
 
-	switch (type_mask) {
-	case NGBE_SUBID_M88E1512_SFP:
-	case NGBE_SUBID_LY_M88E1512_SFP:
-		hw->phy.type = ngbe_phy_m88e1512_sfi;
-		break;
-	case NGBE_SUBID_M88E1512_RJ45:
-		hw->phy.type = ngbe_phy_m88e1512;
-		break;
-	case NGBE_SUBID_M88E1512_MIX:
-		hw->phy.type = ngbe_phy_m88e1512_unknown;
-		break;
-	case NGBE_SUBID_YT8521S_SFP:
-	case NGBE_SUBID_YT8521S_SFP_GPIO:
-	case NGBE_SUBID_LY_YT8521S_SFP:
-		hw->phy.type = ngbe_phy_yt8521s_sfi;
-		break;
-	case NGBE_SUBID_INTERNAL_YT8521S_SFP:
-	case NGBE_SUBID_INTERNAL_YT8521S_SFP_GPIO:
-		hw->phy.type = ngbe_phy_internal_yt8521s_sfi;
-		break;
-	case NGBE_SUBID_RGMII_FPGA:
-	case NGBE_SUBID_OCP_CARD:
-		fallthrough;
-	default:
-		hw->phy.type = ngbe_phy_internal;
-		break;
-	}
-
-	if (hw->phy.type == ngbe_phy_internal ||
-	    hw->phy.type == ngbe_phy_internal_yt8521s_sfi)
-		hw->mac_type = ngbe_mac_type_mdi;
-	else
-		hw->mac_type = ngbe_mac_type_rgmii;
-
+	val = rd32(&hw->wxhw, NGBE_CFG_PORT_ST);
+	hw->mac_type = (val & BIT(7)) >> 7 ?
+			ngbe_mac_type_rgmii :
+			ngbe_mac_type_mdi;
 	hw->wol_enabled = (wol_mask == NGBE_WOL_SUP) ? 1 : 0;
 	hw->ncsi_enabled = (ncsi_mask == NGBE_NCSI_MASK ||
 			   type_mask == NGBE_SUBID_OCP_CARD) ? 1 : 0;
@@ -203,12 +176,35 @@ static int ngbe_sw_init(struct ngbe_adapter *adapter)
 	return 0;
 }
 
+static void ngbe_disable_device(struct ngbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	struct ngbe_hw *hw = &adapter->hw;
+
+	/* disable receives */
+	wx_disable_rx(&hw->wxhw);
+	netif_tx_disable(netdev);
+	if (hw->gpio_ctrl)
+		ngbe_sfp_modules_txrx_powerctl(&hw->wxhw, false);
+}
+
 static void ngbe_down(struct ngbe_adapter *adapter)
 {
-	netif_carrier_off(adapter->netdev);
-	netif_tx_disable(adapter->netdev);
+	struct ngbe_hw *hw = &adapter->hw;
+
+	phy_stop(hw->phydev);
+	ngbe_disable_device(adapter);
 };
 
+static void ngbe_up(struct ngbe_adapter *adapter)
+{
+	struct ngbe_hw *hw = &adapter->hw;
+
+	if (hw->gpio_ctrl)
+		ngbe_sfp_modules_txrx_powerctl(&hw->wxhw, true);
+	phy_start(hw->phydev);
+}
+
 /**
  * ngbe_open - Called when a network interface is made active
  * @netdev: network interface device structure
@@ -223,8 +219,13 @@ static int ngbe_open(struct net_device *netdev)
 	struct ngbe_adapter *adapter = netdev_priv(netdev);
 	struct ngbe_hw *hw = &adapter->hw;
 	struct wx_hw *wxhw = &hw->wxhw;
+	int ret;
 
 	wx_control_hw(wxhw, true);
+	ret = ngbe_phy_connect(hw);
+	if (ret)
+		return ret;
+	ngbe_up(adapter);
 
 	return 0;
 }
@@ -243,9 +244,11 @@ static int ngbe_open(struct net_device *netdev)
 static int ngbe_close(struct net_device *netdev)
 {
 	struct ngbe_adapter *adapter = netdev_priv(netdev);
+	struct ngbe_hw *hw = &adapter->hw;
 
 	ngbe_down(adapter);
-	wx_control_hw(&adapter->hw.wxhw, false);
+	phy_disconnect(hw->phydev);
+	wx_control_hw(&hw->wxhw, false);
 
 	return 0;
 }
@@ -471,6 +474,11 @@ static int ngbe_probe(struct pci_dev *pdev,
 	eth_hw_addr_set(netdev, wxhw->mac.perm_addr);
 	ngbe_mac_set_default_filter(adapter, wxhw->mac.perm_addr);
 
+	/* phy Interface Configuration */
+	err = ngbe_mdio_init(hw);
+	if (err)
+		goto err_free_mac_table;
+
 	err = register_netdev(netdev);
 	if (err)
 		goto err_register;
@@ -479,7 +487,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 
 	netif_info(adapter, probe, netdev,
 		   "PHY: %s, PBA No: Wang Xun GbE Family Controller\n",
-		   hw->phy.type == ngbe_phy_internal ? "Internal" : "External");
+		   hw->mac_type == ngbe_mac_type_mdi ? "Internal" : "External");
 	netif_info(adapter, probe, netdev, "%pM\n", netdev->dev_addr);
 
 	return 0;
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c
new file mode 100644
index 000000000000..1b681f70a46e
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c
@@ -0,0 +1,250 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd. */
+
+#include <linux/ethtool.h>
+#include <linux/iopoll.h>
+#include <linux/pci.h>
+#include <linux/phy.h>
+
+#include "../libwx/wx_type.h"
+#include "../libwx/wx_hw.h"
+#include "ngbe_type.h"
+#include "ngbe_mdio.h"
+#include "ngbe.h"
+
+static int ngbe_phy_read_reg_internal(struct mii_bus *bus, int phy_addr, int regnum)
+{
+	struct ngbe_hw *hw = bus->priv;
+
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+	return (u16)rd32(&hw->wxhw, NGBE_PHY_CONFIG(regnum));
+}
+
+static int ngbe_phy_write_reg_internal(struct mii_bus *bus, int phy_addr, int regnum, u16 value)
+{
+	struct ngbe_hw *hw = bus->priv;
+
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+	wr32(&hw->wxhw, NGBE_PHY_CONFIG(regnum), value);
+	return 0;
+}
+
+static int ngbe_phy_read_reg_mdi(struct mii_bus *bus, int phy_addr, int regnum)
+{
+	struct ngbe_hw *hw = bus->priv;
+	struct wx_hw *wxhw = &hw->wxhw;
+	u32 command, device_type = 0;
+	u32 val;
+	int ret;
+
+	if (regnum & MII_ADDR_C45) {
+		wr32(wxhw, NGBE_MDIO_CLAUSE_SELECT, 0x0);
+		/* setup and write the address cycle command */
+		command = NGBE_MSCA_RA(mdiobus_c45_regad(regnum)) |
+			  NGBE_MSCA_PA(phy_addr) |
+			  NGBE_MSCA_DA(mdiobus_c45_devad(regnum));
+	} else {
+		wr32(wxhw, NGBE_MDIO_CLAUSE_SELECT, 0xF);
+		/* setup and write the address cycle command */
+		command = NGBE_MSCA_RA(regnum) |
+			  NGBE_MSCA_PA(phy_addr) |
+			  NGBE_MSCA_DA(device_type);
+	}
+	wr32(wxhw, NGBE_MSCA, command);
+	command = NGBE_MSCC_CMD(NGBE_MSCA_CMD_READ) |
+		  NGBE_MSCC_BUSY |
+		  NGBE_MDIO_CLK(6);
+	wr32(wxhw, NGBE_MSCC, command);
+
+	/* wait to complete */
+	ret = read_poll_timeout(rd32, val, !(val & NGBE_MSCC_BUSY), 1000,
+				100000, false, wxhw, NGBE_MSCC);
+	if (ret) {
+		wx_err(wxhw, "PHY address command did not complete.\n");
+		return ret;
+	}
+
+	return (u16)rd32(wxhw, NGBE_MSCC);
+}
+
+static int ngbe_phy_write_reg_mdi(struct mii_bus *bus, int phy_addr, int regnum, u16 value)
+{
+	struct ngbe_hw *hw = bus->priv;
+	struct wx_hw *wxhw = &hw->wxhw;
+	u32 command, device_type = 0;
+	int ret;
+	u16 val;
+
+	if (regnum & MII_ADDR_C45) {
+		wr32(wxhw, NGBE_MDIO_CLAUSE_SELECT, 0x0);
+		/* setup and write the address cycle command */
+		command = NGBE_MSCA_RA(mdiobus_c45_regad(regnum)) |
+			  NGBE_MSCA_PA(phy_addr) |
+			  NGBE_MSCA_DA(mdiobus_c45_devad(regnum));
+	} else {
+		wr32(wxhw, NGBE_MDIO_CLAUSE_SELECT, 0xF);
+		/* setup and write the address cycle command */
+		command = NGBE_MSCA_RA(regnum) |
+			  NGBE_MSCA_PA(phy_addr) |
+			  NGBE_MSCA_DA(device_type);
+	}
+	wr32(wxhw, NGBE_MSCA, command);
+	command = value |
+		  NGBE_MSCC_CMD(NGBE_MSCA_CMD_WRITE) |
+		  NGBE_MSCC_BUSY |
+		  NGBE_MDIO_CLK(6);
+	wr32(wxhw, NGBE_MSCC, command);
+
+	/* wait to complete */
+	ret = read_poll_timeout(rd32, val, !(val & NGBE_MSCC_BUSY), 1000,
+				100000, false, wxhw, NGBE_MSCC);
+	if (ret)
+		wx_err(wxhw, "PHY address command did not complete.\n");
+
+	return ret;
+}
+
+static int ngbe_phy_read_reg(struct mii_bus *bus, int phy_addr, int regnum)
+{
+	struct ngbe_hw *hw = bus->priv;
+	u16 phy_data;
+
+	if (hw->mac_type == ngbe_mac_type_mdi)
+		phy_data = ngbe_phy_read_reg_internal(bus, phy_addr, regnum);
+	else
+		phy_data = ngbe_phy_read_reg_mdi(bus, phy_addr, regnum);
+
+	return phy_data;
+}
+
+static int ngbe_phy_write_reg(struct mii_bus *bus, int phy_addr, int regnum, u16 value)
+{
+	struct ngbe_hw *hw = bus->priv;
+	int ret;
+
+	if (hw->mac_type == ngbe_mac_type_mdi)
+		ret = ngbe_phy_write_reg_internal(bus, phy_addr, regnum, value);
+	else
+		ret = ngbe_phy_write_reg_mdi(bus, phy_addr, regnum, value);
+
+	return ret;
+}
+
+static void ngbe_handle_link_change(struct net_device *dev)
+{
+	struct ngbe_adapter *adapter = netdev_priv(dev);
+	struct ngbe_hw *hw = &adapter->hw;
+	struct wx_hw *wxhw = &hw->wxhw;
+	struct phy_device *phydev;
+	u32 lan_speed, reg;
+
+	phydev = hw->phydev;
+	if (!(hw->link != phydev->link ||
+	      hw->speed != phydev->speed ||
+	      hw->duplex != phydev->duplex))
+		return;
+
+	hw->link = phydev->link;
+	hw->speed = phydev->speed;
+	hw->duplex = phydev->duplex;
+	switch (phydev->speed) {
+	case SPEED_10:
+		lan_speed = 0;
+		break;
+	case SPEED_100:
+		lan_speed = 1;
+		break;
+	case SPEED_1000:
+	default:
+		lan_speed = 2;
+		break;
+	}
+	wr32m(wxhw, NGBE_CFG_LAN_SPEED, 0x3, lan_speed);
+
+	if (phydev->link) {
+		reg = rd32(wxhw, WX_MAC_TX_CFG);
+		reg &= ~WX_MAC_TX_CFG_SPEED_MASK;
+		reg |= WX_MAC_TX_CFG_SPEED_1G | WX_MAC_TX_CFG_TE;
+		wr32(wxhw, WX_MAC_TX_CFG, reg);
+		/* Re configure MAC RX */
+		reg = rd32(wxhw, WX_MAC_RX_CFG);
+		wr32(wxhw, WX_MAC_RX_CFG, reg);
+		wr32(wxhw, WX_MAC_PKT_FLT, WX_MAC_PKT_FLT_PR);
+		reg = rd32(wxhw, WX_MAC_WDG_TIMEOUT);
+		wr32(wxhw, WX_MAC_WDG_TIMEOUT, reg);
+	}
+	phy_print_status(phydev);
+}
+
+int ngbe_phy_connect(struct ngbe_hw *hw)
+{
+	struct ngbe_adapter *adapter = container_of(hw,
+						    struct ngbe_adapter,
+						    hw);
+	int ret;
+
+	ret = phy_connect_direct(adapter->netdev,
+				 hw->phydev,
+				 ngbe_handle_link_change,
+				 PHY_INTERFACE_MODE_RGMII_ID);
+	if (ret) {
+		wx_err(&hw->wxhw, "PHY connect failed.\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static void ngbe_phy_fixup(struct ngbe_hw *hw)
+{
+	struct phy_device *phydev = hw->phydev;
+	struct ethtool_eee eee;
+
+	if (hw->mac_type != ngbe_mac_type_mdi)
+		return;
+	/* disable EEE, EEE not supported by mac */
+	memset(&eee, 0, sizeof(eee));
+	phy_ethtool_set_eee(phydev, &eee);
+
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
+	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
+}
+
+int ngbe_mdio_init(struct ngbe_hw *hw)
+{
+	struct pci_dev *pdev = hw->wxhw.pdev;
+	struct mii_bus *mii_bus;
+	int ret;
+
+	mii_bus = devm_mdiobus_alloc(&pdev->dev);
+	if (!mii_bus)
+		return -ENOMEM;
+
+	mii_bus->name = "ngbe_mii_bus";
+	mii_bus->read = ngbe_phy_read_reg;
+	mii_bus->write = ngbe_phy_write_reg;
+	mii_bus->phy_mask = GENMASK(31, 4);
+	mii_bus->probe_capabilities = MDIOBUS_C22_C45;
+	mii_bus->parent = &pdev->dev;
+	mii_bus->priv = hw;
+
+	snprintf(mii_bus->id, MII_BUS_ID_SIZE, "ngbe-%x",
+		 (pdev->bus->number << 8) | pdev->devfn);
+	ret = devm_mdiobus_register(&pdev->dev, mii_bus);
+	if (ret)
+		return ret;
+	hw->phydev = phy_find_first(mii_bus);
+	if (!hw->phydev)
+		return -ENODEV;
+	phy_attached_info(hw->phydev);
+	ngbe_phy_fixup(hw);
+
+	hw->link = 0;
+	hw->speed = 0;
+	hw->duplex = 0;
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.h
new file mode 100644
index 000000000000..9095f2183d92
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * WangXun Gigabit PCI Express Linux driver
+ * Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd.
+ */
+
+#ifndef _NGBE_MDIO_H_
+#define _NGBE_MDIO_H_
+
+int ngbe_phy_connect(struct ngbe_hw *hw);
+int ngbe_mdio_init(struct ngbe_hw *hw);
+#endif /* _NGBE_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
index 39f6c03f1a54..e618e75d8c2b 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
@@ -63,6 +63,26 @@
 /* Media-dependent registers. */
 #define NGBE_MDIO_CLAUSE_SELECT			0x11220
 
+/* mdio access */
+#define NGBE_MSCA				0x11200
+#define NGBE_MSCA_RA(v)				((0xFFFF & (v)))
+#define NGBE_MSCA_PA(v)				((0x1F & (v)) << 16)
+#define NGBE_MSCA_DA(v)				((0x1F & (v)) << 21)
+#define NGBE_MSCC				0x11204
+#define NGBE_MSCC_DATA(v)			((0xFFFF & (v)))
+#define NGBE_MSCC_CMD(v)			((0x3 & (v)) << 16)
+
+enum NGBE_MSCA_CMD_value {
+	NGBE_MSCA_CMD_RSV = 0,
+	NGBE_MSCA_CMD_WRITE,
+	NGBE_MSCA_CMD_POST_READ,
+	NGBE_MSCA_CMD_READ,
+};
+
+#define NGBE_MSCC_SADDR				BIT(18)
+#define NGBE_MSCC_BUSY				BIT(22)
+#define NGBE_MDIO_CLK(v)			((0x7 & (v)) << 19)
+
 /* GPIO Registers */
 #define NGBE_GPIO_DR				0x14800
 #define NGBE_GPIO_DDR				0x14804
@@ -90,25 +110,10 @@
 #define NGBE_FW_CMD_ST_PASS			0x80658383
 #define NGBE_FW_CMD_ST_FAIL			0x70657376
 
-enum ngbe_phy_type {
-	ngbe_phy_unknown = 0,
-	ngbe_phy_none,
-	ngbe_phy_internal,
-	ngbe_phy_m88e1512,
-	ngbe_phy_m88e1512_sfi,
-	ngbe_phy_m88e1512_unknown,
-	ngbe_phy_yt8521s,
-	ngbe_phy_yt8521s_sfi,
-	ngbe_phy_internal_yt8521s_sfi,
-	ngbe_phy_generic
-};
+#define NGBE_PHY_CONFIG(reg_offset)		(0x14000 + ((reg_offset) * 4))
+#define NGBE_CFG_LAN_SPEED			0x14440
 
-enum ngbe_media_type {
-	ngbe_media_type_unknown = 0,
-	ngbe_media_type_fiber,
-	ngbe_media_type_copper,
-	ngbe_media_type_backplane,
-};
+#define NGBE_CFG_PORT_ST			0x14404
 
 enum ngbe_mac_type {
 	ngbe_mac_type_unknown = 0,
@@ -116,22 +121,17 @@ enum ngbe_mac_type {
 	ngbe_mac_type_rgmii
 };
 
-struct ngbe_phy_info {
-	enum ngbe_phy_type type;
-	enum ngbe_media_type media_type;
-
-	u32 addr;
-	u32 id;
-
-	bool reset_if_overtemp;
-
-};
-
 struct ngbe_hw {
 	struct wx_hw wxhw;
-	struct ngbe_phy_info phy;
 	enum ngbe_mac_type mac_type;
 
+	/* PHY stuff */
+	unsigned int link;
+	int speed;
+	int duplex;
+
+	struct phy_device *phydev;
+
 	bool wol_enabled;
 	bool ncsi_enabled;
 	bool gpio_ctrl;
-- 
2.38.1

