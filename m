Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384FE640254
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbiLBIiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbiLBIhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:37:36 -0500
Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BA6BFCD9
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:36:19 -0800 (PST)
X-QQ-mid: bizesmtp65t1669970173ta6i179j
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 02 Dec 2022 16:36:03 +0800 (CST)
X-QQ-SSF: 01400000000000M0M000000A0000000
X-QQ-FEAT: D2GZf6M6C/hBBMk5qCOzoF4CrzNVJ+TaYqsF3YDxiIbJ5T5Qx0F4OhofTSX+h
        E9iAiKrGqHhynCMSjAMXo5mx0D5OPT7Gwqkn1Y34wmJxVbbqKTk2+Fm2UHJRbSqH9T4+dMo
        UwSOGITclt9nag+Y29XfZjdLyJn+mOagjssUDh/77owE86PjS472xepiIy6TuO7SXmKPkQq
        xZAEcTXfGLJ1v+8zWIFO2R33uilchXeGLJjYQklIa0EyC60AFoKzcDeMBpwLBzbn64tpOjF
        zpFfS9WzNqk3/ANRMhL1s1OjFGwBt7LcPqnEiz9ve+xb00mZEkDT5TCLhEENNtiTeu4eJbY
        zJzJLsg++VtVhxCDa4VrBbA+bhh72ijqddocts1BKAFzpA4xB+2NsCaL+QAyrgJbgzmrzX1
        2+QJtsF2otQ=
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next] net: ngbe: Add mdio bus driver.
Date:   Fri,  2 Dec 2022 16:35:58 +0800
Message-Id: <20221202083558.57618-1-mengyuanlou@net-swift.com>
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
Added phy changed event detection.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/Kconfig          |   3 +
 drivers/net/ethernet/wangxun/libwx/wx_hw.c    |   3 +-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |   1 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |   4 +
 drivers/net/ethernet/wangxun/ngbe/Makefile    |   2 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   |  57 ++-
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h   |   1 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  78 +++-
 drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c | 385 ++++++++++++++++++
 drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.h |  12 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  56 ++-
 11 files changed, 577 insertions(+), 25 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.h

diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index 86310588c6c1..1631f80a6474 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -25,6 +25,9 @@ config NGBE
 	tristate "Wangxun(R) GbE PCI Express adapters support"
 	depends on PCI
 	select LIBWX
+	select PHYLIB
+	select MARVELL_PHY
+	select MOTORCOMM_PHY
 	help
 	  This driver supports Wangxun(R) GbE PCI Express family of
 	  adapters.
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index c57dc3238b3f..cc4d45c97d14 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -41,7 +41,7 @@ static int wx_fmgr_cmd_op(struct wx_hw *wxhw, u32 cmd, u32 cmd_addr)
 				 false, wxhw, WX_SPI_STATUS);
 }
 
-static int wx_flash_read_dword(struct wx_hw *wxhw, u32 addr, u32 *data)
+int wx_flash_read_dword(struct wx_hw *wxhw, u32 addr, u32 *data)
 {
 	int ret = 0;
 
@@ -53,6 +53,7 @@ static int wx_flash_read_dword(struct wx_hw *wxhw, u32 addr, u32 *data)
 
 	return ret;
 }
+EXPORT_SYMBOL(wx_flash_read_dword);
 
 int wx_check_flash_load(struct wx_hw *hw, u32 check_bit)
 {
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.h b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
index a0652f5e9939..471095e8c8e7 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
@@ -4,6 +4,7 @@
 #ifndef _WX_HW_H_
 #define _WX_HW_H_
 
+int wx_flash_read_dword(struct wx_hw *wxhw, u32 addr, u32 *data);
 int wx_check_flash_load(struct wx_hw *hw, u32 check_bit);
 void wx_control_hw(struct wx_hw *wxhw, bool drv);
 int wx_mng_present(struct wx_hw *wxhw);
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
index 0e3923b3737e..bd1f8710b34f 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
@@ -38,6 +38,34 @@ int ngbe_eeprom_chksum_hostif(struct ngbe_hw *hw)
 	return -EIO;
 }
 
+int ngbe_phy_led_oem_hostif(struct ngbe_hw *hw, u32 *data)
+{
+	struct wx_hic_read_shadow_ram buffer;
+	struct wx_hw *wxhw = &hw->wxhw;
+	int status;
+
+	buffer.hdr.req.cmd = NGBE_FW_PHY_LED_CONF;
+	buffer.hdr.req.buf_lenh = 0;
+	buffer.hdr.req.buf_lenl = 0;
+	buffer.hdr.req.checksum = NGBE_FW_CMD_DEFAULT_CHECKSUM;
+	/* convert offset from words to bytes */
+	buffer.address = 0;
+	/* one word */
+	buffer.length = 0;
+	status = wx_host_interface_command(wxhw, (u32 *)&buffer, sizeof(buffer),
+					   WX_HI_COMMAND_TIMEOUT, false);
+
+	if (status)
+		return status;
+
+	if (rd32a(wxhw, WX_MNG_MBOX, 1) == NGBE_FW_CMD_ST_PASS)
+		*data = rd32a(wxhw, WX_MNG_MBOX, 2);
+	else
+		*data = 0xffffffff;
+
+	return 0;
+}
+
 static int ngbe_reset_misc(struct ngbe_hw *hw)
 {
 	struct wx_hw *wxhw = &hw->wxhw;
@@ -64,21 +92,34 @@ static int ngbe_reset_misc(struct ngbe_hw *hw)
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
+	val = WX_MIS_RST_LAN_RST(wxhw->bus.func);
+	wr32(wxhw, WX_MIS_RST, val | rd32(wxhw, WX_MIS_RST));
+
+	ret = read_poll_timeout(rd32, val,
+				!(val & (BIT(9) << wxhw->bus.func)), 1000,
+				100000, false, wxhw, 0x10028);
+	if (ret)
+		wx_dbg(wxhw, "Lan reset exceed s maximum times.\n");
+
+	wr32(wxhw, NGBE_PHY_CONFIG(0x1f), 0xa43);
+	ret = read_poll_timeout(rd32, val, val & 0x20, 1000,
+				100000, false, wxhw, NGBE_PHY_CONFIG(0x1d));
+	if (ret)
+		wx_dbg(wxhw, "Gphy reset failed.\n");
+
 	ngbe_reset_misc(hw);
 
 	/* Store the permanent mac address */
 	wx_get_mac_addr(wxhw, wxhw->mac.perm_addr);
 
-	/* reset num_rar_entries to 128 */
+	/* reset num_rar_entries to 32 */
 	wxhw->mac.num_rar_entries = NGBE_RAR_ENTRIES;
 	wx_init_rx_addrs(wxhw);
 	pci_set_master(wxhw->pdev);
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
index 42476a3fe57c..cf4008a2b5ec 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
@@ -8,5 +8,6 @@
 #define _NGBE_HW_H_
 
 int ngbe_eeprom_chksum_hostif(struct ngbe_hw *hw);
+int ngbe_phy_led_oem_hostif(struct ngbe_hw *hw, u32 *data);
 int ngbe_reset_hw(struct ngbe_hw *hw);
 #endif /* _NGBE_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index f0b24366da18..735165b4e437 100644
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
@@ -70,22 +72,22 @@ static void ngbe_init_type_code(struct ngbe_hw *hw)
 	switch (type_mask) {
 	case NGBE_SUBID_M88E1512_SFP:
 	case NGBE_SUBID_LY_M88E1512_SFP:
-		hw->phy.type = ngbe_phy_m88e1512_sfi;
+		hw->phy.type = ngbe_phy_mv_sfi;
 		break;
 	case NGBE_SUBID_M88E1512_RJ45:
-		hw->phy.type = ngbe_phy_m88e1512;
+		hw->phy.type = ngbe_phy_mv;
 		break;
 	case NGBE_SUBID_M88E1512_MIX:
-		hw->phy.type = ngbe_phy_m88e1512_unknown;
+		hw->phy.type = ngbe_phy_mv_mix;
 		break;
 	case NGBE_SUBID_YT8521S_SFP:
 	case NGBE_SUBID_YT8521S_SFP_GPIO:
 	case NGBE_SUBID_LY_YT8521S_SFP:
-		hw->phy.type = ngbe_phy_yt8521s_sfi;
+		hw->phy.type = ngbe_phy_yt_mix;
 		break;
 	case NGBE_SUBID_INTERNAL_YT8521S_SFP:
 	case NGBE_SUBID_INTERNAL_YT8521S_SFP_GPIO:
-		hw->phy.type = ngbe_phy_internal_yt8521s_sfi;
+		hw->phy.type = ngbe_phy_internal_yt_sfi;
 		break;
 	case NGBE_SUBID_RGMII_FPGA:
 	case NGBE_SUBID_OCP_CARD:
@@ -96,7 +98,7 @@ static void ngbe_init_type_code(struct ngbe_hw *hw)
 	}
 
 	if (hw->phy.type == ngbe_phy_internal ||
-	    hw->phy.type == ngbe_phy_internal_yt8521s_sfi)
+	    hw->phy.type == ngbe_phy_internal_yt_sfi)
 		hw->mac_type = ngbe_mac_type_mdi;
 	else
 		hw->mac_type = ngbe_mac_type_rgmii;
@@ -203,12 +205,39 @@ static int ngbe_sw_init(struct ngbe_adapter *adapter)
 	return 0;
 }
 
+static void ngbe_disable_device(struct ngbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	struct ngbe_hw *hw = &adapter->hw;
+
+	wx_disable_pcie_master(&hw->wxhw);
+	/* disable receives */
+	wx_disable_rx(&hw->wxhw);
+	netif_tx_disable(netdev);
+	if (hw->gpio_ctrl)
+		/* gpio0 is used to power off control*/
+		wr32(&hw->wxhw, NGBE_GPIO_DR, NGBE_GPIO_DR_0);
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
+	pci_set_master(adapter->pdev);
+	if (hw->gpio_ctrl)
+		/* gpio0 is used to power on control*/
+		wr32(&hw->wxhw, NGBE_GPIO_DR, 0);
+	phy_start(hw->phydev);
+}
+
 /**
  * ngbe_open - Called when a network interface is made active
  * @netdev: network interface device structure
@@ -223,8 +252,13 @@ static int ngbe_open(struct net_device *netdev)
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
@@ -243,9 +277,11 @@ static int ngbe_open(struct net_device *netdev)
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
@@ -319,6 +355,22 @@ static const struct net_device_ops ngbe_netdev_ops = {
 	.ndo_set_mac_address    = ngbe_set_mac,
 };
 
+static void ngbe_oem_conf_in_rom(struct ngbe_hw *hw)
+{
+	struct wx_hw *wxhw = &hw->wxhw;
+
+	/* phy led oem conf*/
+	if (ngbe_phy_led_oem_hostif(hw, &hw->led_conf))
+		dev_err(&wxhw->pdev->dev, "The led_oem is not supported\n");
+
+	wx_flash_read_dword(wxhw,
+			    0xfe010 + wxhw->bus.func * 8,
+			    &hw->phy.gphy_efuse[0]);
+	wx_flash_read_dword(wxhw,
+			    0xfe010 + wxhw->bus.func + 4,
+			    &hw->phy.gphy_efuse[1]);
+}
+
 /**
  * ngbe_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -471,6 +523,12 @@ static int ngbe_probe(struct pci_dev *pdev,
 	eth_hw_addr_set(netdev, wxhw->mac.perm_addr);
 	ngbe_mac_set_default_filter(adapter, wxhw->mac.perm_addr);
 
+	/* phy Interface Configuration */
+	ngbe_oem_conf_in_rom(hw);
+	err = ngbe_mdio_init(hw);
+	if (err)
+		goto err_free_mac_table;
+
 	err = register_netdev(netdev);
 	if (err)
 		goto err_register;
@@ -481,6 +539,8 @@ static int ngbe_probe(struct pci_dev *pdev,
 		   "PHY: %s, PBA No: Wang Xun GbE Family Controller\n",
 		   hw->phy.type == ngbe_phy_internal ? "Internal" : "External");
 	netif_info(adapter, probe, netdev, "%pM\n", netdev->dev_addr);
+	/* print PCI link speed and width */
+	pcie_print_link_status(pdev);
 
 	return 0;
 
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c
new file mode 100644
index 000000000000..4d2d59280de7
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c
@@ -0,0 +1,385 @@
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
+	return (u16)rd32(&hw->wxhw, NGBE_PHY_CONFIG(regnum));
+}
+
+static int ngbe_phy_write_reg_internal(struct mii_bus *bus, int phy_addr, int regnum, u16 value)
+{
+	struct ngbe_hw *hw = bus->priv;
+
+	wr32(&hw->wxhw, NGBE_PHY_CONFIG(regnum), value);
+	return 0;
+}
+
+static int ngbe_phy_read_reg_mdi(struct mii_bus *bus, int phy_addr, int regnum)
+{
+	u32 command = 0, device_type = 0;
+	struct ngbe_hw *hw = bus->priv;
+	struct wx_hw *wxhw = &hw->wxhw;
+	u32 phy_data = 0;
+	u32 val = 0;
+	int ret = 0;
+
+	/* setup and write the address cycle command */
+	command = NGBE_MSCA_RA(regnum) |
+		  NGBE_MSCA_PA(phy_addr) |
+		  NGBE_MSCA_DA(device_type);
+	wr32(wxhw, NGBE_MSCA, command);
+
+	command = NGBE_MSCC_CMD(NGBE_MSCA_CMD_READ) |
+		  NGBE_MSCC_BUSY |
+		  NGBE_MDIO_CLK(6);
+	wr32(wxhw, NGBE_MSCC, command);
+
+	/* wait to complete */
+	ret = read_poll_timeout(rd32, val, !(val & NGBE_MSCC_BUSY), 20000,
+				200000, false, wxhw, NGBE_MSCC);
+
+	if (ret)
+		wx_dbg(wxhw, "PHY address command did not complete.\n");
+
+	/* read data from MSCC */
+	phy_data = 0xffff & rd32(wxhw, NGBE_MSCC);
+
+	return phy_data;
+}
+
+static int ngbe_phy_write_reg_mdi(struct mii_bus *bus, int phy_addr, int regnum, u16 value)
+{
+	u32 command = 0, device_type = 0;
+	struct ngbe_hw *hw = bus->priv;
+	struct wx_hw *wxhw = &hw->wxhw;
+	int ret = 0;
+	u16 val = 0;
+
+	/* setup and write the address cycle command */
+	command = NGBE_MSCA_RA(regnum) |
+		  NGBE_MSCA_PA(phy_addr) |
+		  NGBE_MSCA_DA(device_type);
+	wr32(wxhw, NGBE_MSCA, command);
+
+	command = value |
+		  NGBE_MSCC_CMD(NGBE_MSCA_CMD_WRITE) |
+		  NGBE_MSCC_BUSY |
+		  NGBE_MDIO_CLK(6);
+	wr32(wxhw, NGBE_MSCC, command);
+
+	/* wait to complete */
+	ret = read_poll_timeout(rd32, val, !(val & NGBE_MSCC_BUSY), 20000,
+				200000, false, wxhw, NGBE_MSCC);
+
+	if (ret)
+		wx_dbg(wxhw, "PHY address command did not complete.\n");
+
+	return ret;
+}
+
+static int ngbe_phy_read_reg(struct mii_bus *bus, int phy_addr, int regnum)
+{
+	struct ngbe_hw *hw = bus->priv;
+	u16 phy_data = 0;
+
+	if (hw->mac_type == ngbe_mac_type_mdi)
+		phy_data = ngbe_phy_read_reg_internal(bus, phy_addr, regnum);
+	else if (hw->mac_type == ngbe_mac_type_rgmii)
+		phy_data = ngbe_phy_read_reg_mdi(bus, phy_addr, regnum);
+
+	return phy_data;
+}
+
+static int ngbe_phy_write_reg(struct mii_bus *bus, int phy_addr, int regnum, u16 value)
+{
+	struct ngbe_hw *hw = bus->priv;
+	int ret = 0;
+
+	if (hw->mac_type == ngbe_mac_type_mdi)
+		ret = ngbe_phy_write_reg_internal(bus, phy_addr, regnum, value);
+	else if (hw->mac_type == ngbe_mac_type_rgmii)
+		ret = ngbe_phy_write_reg_mdi(bus, phy_addr, regnum, value);
+	return ret;
+}
+
+static void ngbe_gphy_wait_mdio_access_on(struct phy_device *phydev)
+{
+	u16 val;
+	int ret;
+
+	/* select page to 0xa43*/
+	phy_write(phydev, 0x1f, 0x0a43);
+	/* wait to phy can access */
+	ret = read_poll_timeout(phy_read, val, val & 0x20, 100,
+				2000, false, phydev, 0x1d);
+
+	if (ret)
+		phydev_err(phydev, "Access to phy timeout\n");
+}
+
+static void ngbe_gphy_dis_eee(struct phy_device *phydev)
+{
+	phy_write(phydev, 0x1f, 0x0a4b);
+	phy_write(phydev, 0x11, 0x1110);
+	phy_write(phydev, 0x1f, 0x0000);
+	phy_write(phydev, 0xd, 0x0007);
+	phy_write(phydev, 0xe, 0x003c);
+	phy_write(phydev, 0xd, 0x4007);
+	phy_write(phydev, 0xe, 0x0000);
+}
+
+static int ngbe_gphy_efuse_calibration(struct ngbe_hw *hw)
+{
+	struct phy_device *phydev = hw->phydev;
+	u32 efuse[2];
+
+	efuse[0] = hw->phy.gphy_efuse[0];
+	efuse[1] = hw->phy.gphy_efuse[1];
+
+	if (!efuse[0] && !efuse[1]) {
+		efuse[0] = 0xFFFFFFFF;
+		efuse[1] = 0xFFFFFFFF;
+	}
+
+	/* calibration */
+	efuse[0] |= 0xF0000100;
+	efuse[1] |= 0xFF807FFF;
+
+	/* EODR, Efuse Output Data Register */
+	phy_write(phydev, 0x1f, 0x0a46);
+	phy_write(phydev, 0x10, (efuse[0] >>  0) & 0xFFFF);
+	phy_write(phydev, 0x11, (efuse[0] >> 16) & 0xFFFF);
+	phy_write(phydev, 0x12, (efuse[1] >>  0) & 0xFFFF);
+	phy_write(phydev, 0x13, (efuse[1] >> 16) & 0xFFFF);
+
+	/* set efuse ready */
+	phy_write(phydev, 20, 0x0001);
+	ngbe_gphy_wait_mdio_access_on(phydev);
+	phy_write(phydev, 0x1f, 0x0a43);
+	phy_write(phydev, 27, 0x8011);
+	phy_write(phydev, 28, 0x5737);
+	ngbe_gphy_dis_eee(phydev);
+
+	return 0;
+}
+
+static int ngbe_phy_led_ctrl_mv(struct ngbe_hw *hw)
+{
+	struct phy_device *phydev = hw->phydev;
+	u16 val;
+
+	if (hw->led_conf != 0xffffffff)
+		return 0;
+	/* LED control */
+	phy_write(phydev, 0x16, 3);
+	val = phy_read(phydev, 0x10);
+	val &= ~GENMASK(7, 0);
+	val |= (NGBE_LED1_CONF_MV << 4) | NGBE_LED0_CONF_MV;
+	phy_write(phydev, 0x10, val);
+	val = phy_read(phydev, 0x11);
+	val &= ~GENMASK(3, 0);
+	val |= (NGBE_LED1_POL_MV << 2) | NGBE_LED0_POL_MV;
+	phy_write(phydev, 0x11, val);
+	return 0;
+}
+
+static void ngbe_phy_led_ctrl_internal(struct ngbe_hw *hw)
+{
+	struct phy_device *phydev = hw->phydev;
+	u16 val;
+
+	if (hw->led_conf != 0xffffffff)
+		val = (u16)hw->led_conf;
+	else
+		val = 0x205B;
+
+	/* select page to 0xd04 */
+	phy_write(phydev, 0x1f, 0xd04);
+	phy_write(phydev, 0x10, val);
+	phy_write(phydev, 0x11, 0x0);
+
+	val = phy_read(phydev, 0x12);
+	if (hw->led_conf != 0xffffffff) {
+		val &= ~0x73;
+		val |= hw->led_conf >> 16;
+	} else {
+		val = val & GENMASK(15, 2);
+		/*act led blinking mode set to 60ms*/
+		val |= 0x2;
+	}
+	phy_write(phydev, 0x12, val);
+}
+
+static int ngbe_phy_setup_powerup(struct ngbe_hw *hw)
+{
+	struct phy_device *phydev = hw->phydev;
+	u16 val;
+	int ret;
+
+	phy_write(phydev, 0x1f, 0x0a46);
+	val = phy_read(phydev, 20);
+	if ((val & 0x2) == 2)
+		return 0;
+	ngbe_gphy_efuse_calibration(hw);
+	/* set efuse ready */
+	phy_write(phydev, 0x1f, 0x0a46);
+	phy_write(phydev, 20, 0x0002);
+	ngbe_gphy_wait_mdio_access_on(phydev);
+
+	phy_write(phydev, 0x1f, 0x0a42);
+	ret = read_poll_timeout(phy_read, val, ((val & 0x7) == 3),
+				1000, 100000, false, phydev, 0x10);
+
+	if (ret)
+		phydev_err(phydev, "PHY reset exceeds maximum times.\n");
+
+	return ret;
+}
+
+static void ngbe_handle_link_change(struct net_device *dev)
+{
+	struct ngbe_adapter *adapter = netdev_priv(dev);
+	struct ngbe_hw *hw = &adapter->hw;
+	struct wx_hw *wxhw = &hw->wxhw;
+	bool changed = false;
+	u32 lan_speed, reg;
+
+	struct phy_device *phydev = hw->phydev;
+
+	if (hw->link != phydev->link ||
+	    hw->speed != phydev->speed ||
+	    hw->duplex != phydev->duplex) {
+		changed = true;
+		hw->link = phydev->link;
+		hw->speed = phydev->speed;
+		hw->duplex = phydev->duplex;
+	}
+
+	if (!changed)
+		return;
+
+	switch (phydev->speed) {
+	case SPEED_1000:
+		lan_speed = 2;
+		break;
+	case SPEED_100:
+		lan_speed = 1;
+		break;
+	case SPEED_10:
+		lan_speed = 0;
+		break;
+	default:
+		break;
+	}
+	wr32m(wxhw, NGBE_CFG_LAN_SPEED, 0x3, lan_speed);
+
+	if (phydev->link) {
+		if (phydev->speed & (SPEED_1000 | SPEED_100 | SPEED_10)) {
+			reg = rd32(wxhw, WX_MAC_TX_CFG);
+			reg &= ~WX_MAC_TX_CFG_SPEED_MASK;
+			reg |= WX_MAC_TX_CFG_SPEED_1G | WX_MAC_TX_CFG_TE;
+			wr32(wxhw, WX_MAC_TX_CFG, reg);
+		}
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
+static void ngbe_phy_init_fixup(struct ngbe_hw *hw)
+{
+	switch (hw->phy.type) {
+	case ngbe_phy_internal_yt_sfi:
+	case ngbe_phy_internal:
+		ngbe_phy_setup_powerup(hw);
+		ngbe_phy_led_ctrl_internal(hw);
+		break;
+	case ngbe_phy_mv_mix:
+	case ngbe_phy_mv_sfi:
+	case ngbe_phy_mv:
+		ngbe_phy_led_ctrl_mv(hw);
+		break;
+	default:
+		break;
+	}
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
+				 PHY_INTERFACE_MODE_RGMII);
+	if (ret) {
+		wx_err(&hw->wxhw,
+		       "PHY connect failed.\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+int ngbe_mdio_init(struct ngbe_hw *hw)
+{
+	struct pci_dev *pdev = hw->wxhw.pdev;
+	int ret;
+
+	hw->mii_bus = devm_mdiobus_alloc(&pdev->dev);
+	if (!hw->mii_bus)
+		return -ENOMEM;
+
+	hw->mii_bus->name = "ngbe_mii_bus";
+	hw->mii_bus->read = &ngbe_phy_read_reg;
+	hw->mii_bus->write = &ngbe_phy_write_reg;
+	hw->mii_bus->phy_mask = 0xfffffffe;
+	hw->mii_bus->parent = &pdev->dev;
+	hw->mii_bus->priv = hw;
+
+	snprintf(hw->mii_bus->id, MII_BUS_ID_SIZE, "ngbe-%x",
+		 (pdev->bus->number << 8) |
+		 pdev->devfn);
+
+	ret = devm_mdiobus_register(&pdev->dev, hw->mii_bus);
+	if (ret)
+		return ret;
+
+	hw->phydev = mdiobus_get_phy(hw->mii_bus, 0);
+	if (!hw->phydev) {
+		return -ENODEV;
+	} else if (!hw->phydev->drv) {
+		wx_err(&hw->wxhw,
+		       "No dedicated PHY driver found for PHY ID 0x%08x.\n",
+		       hw->phydev->phy_id);
+		return -EUNATCH;
+	}
+	ngbe_phy_init_fixup(hw);
+	phy_attached_info(hw->phydev);
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
index 39f6c03f1a54..ef6d1b515769 100644
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
@@ -85,21 +105,34 @@
 #define NGBE_PSR_WKUP_CTL_IPV6			BIT(7) /* Directed IPv6 Pkt Wakeup Enable */
 
 #define NGBE_FW_EEPROM_CHECKSUM_CMD		0xE9
+#define NGBE_FW_PHY_LED_CONF			0xF1
 #define NGBE_FW_NVM_DATA_OFFSET			3
 #define NGBE_FW_CMD_DEFAULT_CHECKSUM		0xFF /* checksum always 0xFF */
 #define NGBE_FW_CMD_ST_PASS			0x80658383
 #define NGBE_FW_CMD_ST_FAIL			0x70657376
 
+#define NGBE_PHY_CONFIG(reg_offset)		(0x14000 + ((reg_offset) * 4))
+#define NGBE_CFG_LAN_SPEED			0x14440
+
+/* LED conf */
+#define NGBE_LED1_CONF_MV			0x6
+#define NGBE_LED0_CONF_MV			0x1
+/* LED polarity */
+#define NGBE_LED1_POL_MV			0x1
+#define NGBE_LED0_POL_MV			0x1
+
+/* PHY LED override */
+#define NGBE_CFG_LED_CTL			0x14424
+
 enum ngbe_phy_type {
 	ngbe_phy_unknown = 0,
 	ngbe_phy_none,
 	ngbe_phy_internal,
-	ngbe_phy_m88e1512,
-	ngbe_phy_m88e1512_sfi,
-	ngbe_phy_m88e1512_unknown,
-	ngbe_phy_yt8521s,
-	ngbe_phy_yt8521s_sfi,
-	ngbe_phy_internal_yt8521s_sfi,
+	ngbe_phy_mv,
+	ngbe_phy_mv_sfi,
+	ngbe_phy_mv_mix,
+	ngbe_phy_yt_mix,
+	ngbe_phy_internal_yt_sfi,
 	ngbe_phy_generic
 };
 
@@ -123,6 +156,7 @@ struct ngbe_phy_info {
 	u32 addr;
 	u32 id;
 
+	u32 gphy_efuse[2];
 	bool reset_if_overtemp;
 
 };
@@ -132,8 +166,18 @@ struct ngbe_hw {
 	struct ngbe_phy_info phy;
 	enum ngbe_mac_type mac_type;
 
+	/* PHY stuff */
+	struct mii_bus *mii_bus;
+	unsigned int link;
+	int speed;
+	int duplex;
+
+	struct phy_device *phydev;
+
 	bool wol_enabled;
 	bool ncsi_enabled;
 	bool gpio_ctrl;
+
+	u32 led_conf;
 };
 #endif /* _NGBE_TYPE_H_ */
-- 
2.38.1

