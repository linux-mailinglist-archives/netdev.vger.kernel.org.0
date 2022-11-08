Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12562620E9C
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 12:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbiKHLVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 06:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233895AbiKHLU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 06:20:58 -0500
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E6E48761
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 03:20:53 -0800 (PST)
X-QQ-mid: bizesmtp85t1667906380tfior9ei
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 08 Nov 2022 19:19:39 +0800 (CST)
X-QQ-SSF: 01400000000000M0M000000A0000000
X-QQ-FEAT: Yl5FOsZ5kXn6mUhwivhji20Fj04SM4kHqIYUxufQYPzAmIIjxKAixWwQNMiNW
        aBrDrufPZ6kk+jdLn3SZ+T2tLLqkiHiAAO6iUvTjdpCq/w4kF+yOO7Qn7TK9KSMJiZ9FIbV
        YZ+1DFefedIimfmnLg98RLmTR5nDGc6Vrxb/ou38dpLOTDwtrXN4GqVzCLaVsZP05gmj6z0
        /yElRAJ19izWSv3nXkFVBW7tE4sshsO4i5IB0oT4pijlNLveE3sLRVSmLE4V7i6ecixm3G1
        IkIjlHNKndxKRz6pWjHb1FbjeUnsBG4GstGb4wxNzYlXOUbXvPWkpVZHlAkl9DMy3+uyZdt
        t5D5Chfz+GV51yy3tRE2ljofaPzObhYdfhb+IAOweBCwUhNvTSUTSTL0Ge/iKFpL0B7JGRz
        79cILPsifOmotusy7pGo9w==
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next 4/5] net: ngbe: Initialize phy information
Date:   Tue,  8 Nov 2022 19:19:06 +0800
Message-Id: <20221108111907.48599-5-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108111907.48599-1-mengyuanlou@net-swift.com>
References: <20221108111907.48599-1-mengyuanlou@net-swift.com>
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

Initialize phy media type.
Initialize phy ops functions.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c    |    3 +-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |    1 +
 drivers/net/ethernet/wangxun/ngbe/Makefile    |    2 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe.h      |    2 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   |   31 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h   |    1 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |   28 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_phy.c  | 1113 +++++++++++++++++
 drivers/net/ethernet/wangxun/ngbe/ngbe_phy.h  |   22 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  113 +-
 10 files changed, 1305 insertions(+), 11 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_phy.c
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_phy.h

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index 045d6e978598..fb76a19ba613 100644
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
index 5058774381c1..f562dcfa2d0f 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
@@ -4,6 +4,7 @@
 #ifndef _WX_HW_H_
 #define _WX_HW_H_
 
+int wx_flash_read_dword(struct wx_hw *wxhw, u32 addr, u32 *data);
 int wx_check_flash_load(struct wx_hw *hw, u32 check_bit);
 void wx_control_hw(struct wx_hw *wxhw, bool drv);
 int wx_mng_present(struct wx_hw *wxhw);
diff --git a/drivers/net/ethernet/wangxun/ngbe/Makefile b/drivers/net/ethernet/wangxun/ngbe/Makefile
index 391c2cbc1bb4..56bd8cf800c8 100644
--- a/drivers/net/ethernet/wangxun/ngbe/Makefile
+++ b/drivers/net/ethernet/wangxun/ngbe/Makefile
@@ -6,4 +6,4 @@
 
 obj-$(CONFIG_NGBE) += ngbe.o
 
-ngbe-objs := ngbe_main.o ngbe_hw.o
+ngbe-objs := ngbe_main.o ngbe_hw.o ngbe_phy.o
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe.h b/drivers/net/ethernet/wangxun/ngbe/ngbe.h
index af147ca8605c..ac67c0403592 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe.h
@@ -48,6 +48,8 @@ struct ngbe_adapter {
 	struct ngbe_mac_addr *mac_table;
 	u16 msg_enable;
 
+	DECLARE_BITMAP(flags, NGBE_FLAGS_NBITS);
+
 	/* Tx fast path data */
 	int num_tx_queues;
 	u16 tx_itr_setting;
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
index 0e3923b3737e..274d54832579 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
@@ -38,6 +38,37 @@ int ngbe_eeprom_chksum_hostif(struct ngbe_hw *hw)
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
+
+	/* convert offset from words to bytes */
+	buffer.address = 0;
+	/* one word */
+	buffer.length = 0;
+
+	status = wx_host_interface_command(wxhw, (u32 *)&buffer, sizeof(buffer),
+					   WX_HI_COMMAND_TIMEOUT, false);
+
+	if (status)
+		return status;
+
+	*data = rd32a(wxhw, WX_MNG_MBOX, 1);
+	if (*data == NGBE_FW_CMD_ST_PASS)
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
index f0b24366da18..ebf3fcdc4719 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -76,16 +76,16 @@ static void ngbe_init_type_code(struct ngbe_hw *hw)
 		hw->phy.type = ngbe_phy_m88e1512;
 		break;
 	case NGBE_SUBID_M88E1512_MIX:
-		hw->phy.type = ngbe_phy_m88e1512_unknown;
+		hw->phy.type = ngbe_phy_m88e1512_mix;
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
@@ -96,7 +96,7 @@ static void ngbe_init_type_code(struct ngbe_hw *hw)
 	}
 
 	if (hw->phy.type == ngbe_phy_internal ||
-	    hw->phy.type == ngbe_phy_internal_yt8521s_sfi)
+	    hw->phy.type == ngbe_phy_internal_yt_sfi)
 		hw->mac_type = ngbe_mac_type_mdi;
 	else
 		hw->mac_type = ngbe_mac_type_rgmii;
@@ -116,6 +116,8 @@ static void ngbe_init_type_code(struct ngbe_hw *hw)
 		hw->gpio_ctrl = 0;
 		break;
 	}
+
+	hw->phy.id = 0;
 }
 
 /**
@@ -203,6 +205,22 @@ static int ngbe_sw_init(struct ngbe_adapter *adapter)
 	return 0;
 }
 
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
 static void ngbe_down(struct ngbe_adapter *adapter)
 {
 	netif_carrier_off(adapter->netdev);
@@ -442,6 +460,8 @@ static int ngbe_probe(struct pci_dev *pdev,
 		}
 	}
 
+	ngbe_oem_conf_in_rom(hw);
+
 	adapter->wol = 0;
 	if (hw->wol_enabled)
 		adapter->wol = NGBE_PSR_WKUP_CTL_MAG;
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_phy.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_phy.c
new file mode 100644
index 000000000000..874d929285b0
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_phy.c
@@ -0,0 +1,1113 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd. */
+
+#include <linux/ethtool.h>
+#include <linux/iopoll.h>
+#include <linux/pci.h>
+
+#include "../libwx/wx_type.h"
+#include "../libwx/wx_hw.h"
+#include "ngbe_type.h"
+#include "ngbe_phy.h"
+#include "ngbe.h"
+
+static u16 ngbe_phy_read_reg_internal(struct ngbe_hw *hw, u32 reg_addr)
+{
+	u16 phy_data = 0;
+
+	phy_data = (u16)rd32(&hw->wxhw, NGBE_PHY_CONFIG(reg_addr));
+	return phy_data;
+}
+
+static void ngbe_phy_write_reg_internal(struct ngbe_hw *hw, u32 reg_addr, u16 phy_data)
+{
+	wr32(&hw->wxhw, NGBE_PHY_CONFIG(reg_addr), phy_data);
+}
+
+/**
+ *  ngbe_phy_read_reg_mdi - Reads a val from an external PHY register
+ *  @hw: pointer to hardware structure
+ *  @reg_addr: 32 bit address of PHY register to read
+ **/
+static u16 ngbe_phy_read_reg_mdi(struct ngbe_hw *hw, u32 reg_addr)
+{
+	u32 command = 0, device_type = 0;
+	struct wx_hw *wxhw = &hw->wxhw;
+	u32 phy_addr = 0;
+	u16 phy_data = 0;
+	u32 val = 0;
+	int ret = 0;
+
+	/* setup and write the address cycle command */
+	command = NGBE_MSCA_RA(reg_addr) |
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
+	ret = read_poll_timeout(rd32, val, val & NGBE_MSCC_BUSY, 1000,
+				20000, false, wxhw, NGBE_MSCC);
+	if (ret)
+		wx_dbg(wxhw, "PHY address command did not complete.\n");
+
+	/* read data from MSCC */
+	phy_data = (u16)rd32(wxhw, NGBE_MSCC);
+
+	return phy_data;
+}
+
+/**
+ *  ngbe_phy_write_reg_mdi - Writes a val to external PHY register
+ *  @hw: pointer to hardware structure
+ *  @reg_addr: 32 bit PHY register to write
+ *  @phy_data: Data to write to the PHY register
+ **/
+static void ngbe_phy_write_reg_mdi(struct ngbe_hw *hw, u32 reg_addr, u16 phy_data)
+{
+	u32 command = 0, device_type = 0;
+	struct wx_hw *wxhw = &hw->wxhw;
+	u32 phy_addr = 0;
+	int ret = 0;
+	u16 val = 0;
+
+	/* setup and write the address cycle command */
+	command = NGBE_MSCA_RA(reg_addr) |
+		  NGBE_MSCA_PA(phy_addr) |
+		  NGBE_MSCA_DA(device_type);
+	wr32(wxhw, NGBE_MSCA, command);
+
+	command = phy_data |
+		  NGBE_MSCC_CMD(NGBE_MSCA_CMD_WRITE) |
+		  NGBE_MSCC_BUSY |
+		  NGBE_MDIO_CLK(6);
+	wr32(wxhw, NGBE_MSCC, command);
+
+	/* wait to complete */
+	ret = read_poll_timeout(rd32, val, val & NGBE_MSCC_BUSY, 1000,
+				20000, false, wxhw, NGBE_MSCC);
+	if (ret)
+		wx_dbg(wxhw, "PHY address command did not complete.\n");
+}
+
+static u16 ngbe_phy_read_reg_ext_yt(struct ngbe_hw *hw,
+				    u32 reg_addr)
+{
+	u16 val = 0;
+
+	ngbe_phy_write_reg_mdi(hw, 0x1e, reg_addr);
+	val = ngbe_phy_read_reg_mdi(hw, 0x1f);
+
+	return val;
+}
+
+static void ngbe_phy_write_reg_ext_yt(struct ngbe_hw *hw,
+				      u32 reg_addr,
+				      u16 phy_data)
+{
+	ngbe_phy_write_reg_mdi(hw, 0x1e, reg_addr);
+	ngbe_phy_write_reg_mdi(hw, 0x1f, phy_data);
+}
+
+static u16 ngbe_phy_read_reg_sds_ext_yt(struct ngbe_hw *hw,
+					u32 reg_addr)
+{
+	u16 val = 0;
+
+	ngbe_phy_write_reg_ext_yt(hw, 0xa000, 0x02);
+	val = ngbe_phy_read_reg_ext_yt(hw, reg_addr);
+	ngbe_phy_write_reg_ext_yt(hw, 0xa000, 0x00);
+
+	return val;
+}
+
+static void ngbe_phy_write_reg_sds_ext_yt(struct ngbe_hw *hw,
+					  u32 reg_addr,
+					  u16 phy_data)
+{
+	ngbe_phy_write_reg_ext_yt(hw, 0xa000, 0x02);
+	ngbe_phy_write_reg_ext_yt(hw, reg_addr, phy_data);
+	ngbe_phy_write_reg_ext_yt(hw, 0xa000, 0x00);
+}
+
+static u16 ngbe_phy_read_reg_sds_mii_yt(struct ngbe_hw *hw,
+					u32 reg_addr)
+{
+	u16 val = 0;
+
+	ngbe_phy_write_reg_ext_yt(hw, 0xa000, 0x02);
+	val = ngbe_phy_read_reg_mdi(hw, reg_addr);
+	ngbe_phy_write_reg_ext_yt(hw, 0xa000, 0x00);
+
+	return val;
+}
+
+static void ngbe_phy_write_reg_sds_mii_yt(struct ngbe_hw *hw,
+					  u32 reg_addr,
+					  u16 phy_data)
+{
+	ngbe_phy_write_reg_ext_yt(hw, 0xa000, 0x02);
+	ngbe_phy_write_reg_mdi(hw, reg_addr, phy_data);
+	ngbe_phy_write_reg_ext_yt(hw, 0xa000, 0x00);
+}
+
+static void ngbe_phy_led_ctrl_mv(struct ngbe_hw *hw)
+{
+	u16 val = 0;
+
+	if (hw->led_conf == 0xffffffff) {
+		/* LED control */
+		ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_MV, 3);
+		val = ngbe_phy_read_reg(hw, NGBE_PHY_LED_FUNC_CTRL_REG_MV);
+		val &= ~0x00FF;
+		val |= (NGBE_LED1_CONF_MV << 4) | NGBE_LED0_CONF_MV;
+		ngbe_phy_write_reg(hw, NGBE_PHY_LED_FUNC_CTRL_REG_MV, val);
+		val = ngbe_phy_read_reg(hw, NGBE_PHY_LED_POL_CTRL_REG_MV);
+		val &= ~0x000F;
+		val |= (NGBE_LED1_POL_MV << 2) | NGBE_LED0_POL_MV;
+		ngbe_phy_write_reg(hw, NGBE_PHY_LED_POL_CTRL_REG_MV, val);
+	}
+}
+
+static void ngbe_phy_led_ctrl_internal(struct ngbe_hw *hw)
+{
+	u16 val = 0;
+
+	if (hw->led_conf != 0xffffffff)
+		val = hw->led_conf & 0xffff;
+	else
+		val = 0x205B;
+
+	/* select page to 0xd04 */
+	ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_INTERNAL, 0xd04);
+	ngbe_phy_write_reg(hw, 0x10, val);
+	ngbe_phy_write_reg(hw, 0x11, 0x0);
+
+	val = ngbe_phy_read_reg(hw, 0x12);
+	if (hw->led_conf != 0xffffffff) {
+		val &= ~0x73;
+		val |= hw->led_conf >> 16;
+	} else {
+		val = val & 0xFFFC;
+		/*act led blinking mode set to 60ms*/
+		val |= 0x2;
+	}
+	ngbe_phy_write_reg(hw, 0x12, val);
+}
+
+static int ngbe_gphy_wait_mdio_access_on(struct ngbe_hw *hw)
+{
+	u16 val = 0;
+	int ret = 0;
+
+	/* select page to 0xa43*/
+	ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_INTERNAL, 0xa43);
+	/* wait to phy can access */
+	ret = read_poll_timeout(ngbe_phy_read_reg, val, val & 0x20, 1000,
+				100000, false, hw, 0x1d);
+
+	if (ret)
+		wx_dbg(&hw->wxhw, "Access to phy timeout\n");
+
+	return ret;
+}
+
+static int ngbe_phy_init_m88e1512(struct ngbe_hw *hw)
+{
+	u16 val = 0;
+	int ret = 0;
+
+	/* select page to 0x2 */
+	ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_MV, 0x2);
+	val = ngbe_phy_read_reg(hw, 0x15);
+	val &= ~NGBE_RGM_TTC_MV;
+	val |= NGBE_RGM_RTC_MV;
+	ngbe_phy_write_reg(hw, 0x15, val);
+
+	/* phy reset */
+	ret = ngbe_phy_reset(hw);
+	if (!ret)
+		return ret;
+
+	/* set LED2 to interrupt output and INTn active low */
+	/* select page to 0x3 */
+	ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_MV, 0x3);
+	val = ngbe_phy_read_reg(hw, NGBE_PHY_INTM_REG);
+	val |= NGBE_INT_EN_MV;
+	val &= ~(NGBE_INT_POL_MV);
+	ngbe_phy_write_reg(hw, NGBE_PHY_INTM_REG, val);
+
+	return 0;
+}
+
+static int ngbe_get_phy_media_type(struct ngbe_hw *hw)
+{
+	u8 phy_mode = 0;
+	u32 val = 0;
+
+	if (hw->phy.media_type != ngbe_media_type_unknown)
+		return 0;
+
+	switch (hw->phy.type) {
+	case ngbe_phy_internal_yt_sfi:
+	case ngbe_phy_internal:
+	case ngbe_phy_m88e1512:
+		hw->phy.media_type = ngbe_media_type_copper;
+		break;
+	case ngbe_phy_m88e1512_sfi:
+		hw->phy.media_type = ngbe_media_type_fiber;
+		break;
+	case ngbe_phy_m88e1512_mix:
+	case ngbe_phy_yt_mix:
+		hw->phy.media_type = ngbe_media_type_unknown;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (hw->phy.media_type)
+		return 0;
+
+	if (hw->phy.type == ngbe_phy_yt_mix) {
+		ngbe_phy_write_reg(hw, 0x1e, 0xa001);
+		val = ngbe_phy_read_reg(hw, 0x1f);
+		phy_mode = val & 0x7;
+		switch (phy_mode) {
+		case 0:
+			hw->phy.media_type = ngbe_media_type_copper;
+			break;
+		case 1:
+		case 2:
+			hw->phy.media_type = ngbe_media_type_fiber;
+			break;
+		case 4:
+		case 5:
+			hw->phy.media_type = ngbe_media_type_backplane;
+			break;
+		default:
+			hw->phy.media_type = ngbe_media_type_unknown;
+			return -EINVAL;
+		}
+	} else if (hw->phy.type == ngbe_phy_m88e1512_mix) {
+		wx_flash_read_dword(&hw->wxhw, 0xff010, &val);
+
+		phy_mode = (u8)(val >> (8 * hw->wxhw.bus.func));
+		phy_mode = phy_mode & 0x7;
+		switch (phy_mode) {
+		case 0:
+			hw->phy.media_type = ngbe_media_type_copper;
+			break;
+		case 2:
+			hw->phy.media_type = ngbe_media_type_fiber;
+			break;
+		default:
+			hw->phy.media_type = ngbe_media_type_unknown;
+			return -EINVAL;
+		}
+	}
+
+	hw->phy.phy_mode = phy_mode;
+	return 0;
+}
+
+static void ngbe_check_phy_id(struct ngbe_hw *hw)
+{
+	u16 phy_id_high = 0, phy_id_low = 0;
+	u32 phy_id = 0xffffffff;
+
+	phy_id_high = ngbe_phy_read_reg(hw, NGBE_PHY_ID1_REG);
+	phy_id_low = ngbe_phy_read_reg(hw, NGBE_PHY_ID2_REG);
+
+	phy_id = phy_id_high << 6;
+	phy_id |= (phy_id_low & NGBE_PHY_ID_MASK) >> 10;
+
+	/* for yt 8521s phy id is 0 */
+	if (!phy_id) {
+		if (phy_id_low)
+			hw->phy.id = phy_id_low;
+		else
+			wx_dbg(&hw->wxhw, "Can not get phy id.\n");
+	}
+	hw->phy.id = phy_id;
+}
+
+/**
+ *  ngbe_phy_identify - Identifies phy
+ *  @hw: pointer to hardware structure
+ *
+ *  Check whether the phy is accessible
+ **/
+static int ngbe_phy_identify(struct ngbe_hw *hw)
+{
+	struct wx_hw *wxhw = &hw->wxhw;
+	u32 phy_id = 0;
+	int ret = 0;
+
+	if (hw->phy.id)
+		return ret;
+	switch (hw->phy.type) {
+	case ngbe_phy_internal:
+	case ngbe_phy_internal_yt_sfi:
+		ngbe_gphy_wait_mdio_access_on(hw);
+		phy_id = NGBE_PHY_ID_INTERNAL;
+		break;
+	case ngbe_phy_m88e1512:
+	case ngbe_phy_m88e1512_sfi:
+	case ngbe_phy_m88e1512_mix:
+		phy_id = NGBE_PHY_ID_MV;
+		break;
+	case ngbe_phy_yt_mix:
+		phy_id = NGBE_PHY_ID_YT8521S | NGBE_PHY_ID_YT8531S;
+		break;
+	default:
+		ret =  -EINVAL;
+	}
+
+	ngbe_check_phy_id(hw);
+	if ((hw->phy.id & phy_id) != hw->phy.id) {
+		wx_err(wxhw, "Phy id 0x%x not supported.\n", phy_id);
+		return -EINVAL;
+	}
+
+	return ret;
+}
+
+/**
+ *  ngbe_phy_init - PHY specific init
+ *  @hw: pointer to hardware structure
+ *
+ *  Check phy id, Initialize phy mode and media type, Enable the required interrupt.
+ **/
+int ngbe_phy_init(struct ngbe_hw *hw)
+{
+	int ret = 0;
+	u16 val = 0;
+
+	/* Identify the PHY*/
+	ret = ngbe_phy_identify(hw);
+	if (ret)
+		return ret;
+
+	ret = ngbe_get_phy_media_type(hw);
+	if (ret) {
+		wx_err(&hw->wxhw, "The phy mode is not supported.\n");
+		return ret;
+	}
+
+	switch (hw->phy.type) {
+	case ngbe_phy_internal:
+	case ngbe_phy_internal_yt_sfi:
+		val = NGBE_PHY_INT_STATUS_LSC_INTERNAL |
+		      NGBE_PHY_INT_STATUS_ANC_INTERNAL;
+		/* select page to 0xa42 */
+		ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_INTERNAL, 0xa42);
+		break;
+	case ngbe_phy_m88e1512:
+		ngbe_phy_init_m88e1512(hw);
+		/* select page to 0x0 */
+		ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_MV, 0x0);
+		/* enable link status change and AN complete interrupts */
+		val = NGBE_PHY_INT_STATUS_ANC_MV | NGBE_PHY_INT_STATUS_LSC_MV;
+		break;
+	case ngbe_phy_m88e1512_sfi:
+		ngbe_phy_init_m88e1512(hw);
+		/* select page to 0x1 */
+		ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_MV, 0x1);
+		val = ngbe_phy_read_reg(hw, 0x10);
+		val &= ~0x4;
+		ngbe_phy_write_reg(hw, 0x10, val);
+
+		/* enable link status change and AN complete interrupts */
+		val = NGBE_PHY_INT_STATUS_ANC_MV | NGBE_PHY_INT_STATUS_LSC_MV;
+		break;
+	case ngbe_phy_yt_mix:
+		/* select sds area register */
+		ngbe_phy_write_reg(hw, 0x1e, 0xa000);
+		ngbe_phy_write_reg(hw, 0x1f, 0x0);
+
+		/* enable interrupt */
+		val = NGBE_PHY_INT_STATUS_SDSLNKUP_YT |
+		      NGBE_PHY_INT_STATUS_SDSLNKDN_YT |
+		      NGBE_PHY_INT_STATUS_UTPLNKUP_YT |
+		      NGBE_PHY_INT_STATUS_UTPLNKDN_YT;
+		break;
+	default:
+		ret =  -EINVAL;
+	}
+	/* write interrupts bits to register */
+	ngbe_phy_write_reg(hw, NGBE_PHY_INTM_REG, val);
+
+	return ret;
+}
+
+static void ngbe_phy_setup_link_copper(struct ngbe_hw *hw,
+				       u32 speed)
+{
+	u16 value_r4 = 0, value_r9 = 0;
+	u16 val = 0;
+
+	if (!hw->phy.autoneg) {
+		switch (speed) {
+		case SPEED_1000:
+			val = NGBE_PHY_SPEED_SELECT1;
+			break;
+		case SPEED_100:
+			val = NGBE_PHY_SPEED_SELECT0;
+			break;
+		case SPEED_10:
+			val = 0;
+			break;
+		default:
+			val = NGBE_PHY_SPEED_SELECT1 | NGBE_PHY_SPEED_SELECT0;
+			wx_dbg(&hw->wxhw, "unknown speed = 0x%x.\n", speed);
+		}
+		/* duplex full */
+		val |= NGBE_PHY_DUPLEX;
+		ngbe_phy_write_reg(hw, NGBE_PHY_BASE_CTRL_REG, val);
+	}
+	if (speed & SPEED_1000)
+		value_r9 |= NGBE_PHY_1000BASET_FULL;
+	if (speed & SPEED_100)
+		value_r4 |= NGBE_PHY_100BASETX_FULL;
+	if (speed & SPEED_10)
+		value_r4 |= NGBE_PHY_10BASET_FULL;
+
+	val = ngbe_phy_read_reg(hw, NGBE_PHY_ANAR_REG);
+	/* clear all speed 100/10 full/half bit mask  */
+	val &= ~(NGBE_PHY_100BASETX_HALF |
+		 NGBE_PHY_100BASETX_FULL |
+		 NGBE_PHY_10BASET_HALF |
+		 NGBE_PHY_10BASET_FULL);
+	/* set current speed 100/10 bit mask */
+	value_r4 |= val;
+	ngbe_phy_write_reg(hw, NGBE_PHY_ANAR_REG, value_r4);
+
+	val = ngbe_phy_read_reg(hw, NGBE_PHY_GBCR_REG);
+	/* clear all speed 1000 full/half bit mask  */
+	val &= ~(NGBE_PHY_1000BASET_HALF |
+		 NGBE_PHY_1000BASET_FULL);
+	/* set current speed 1000 bit mask */
+	value_r9 |= val;
+	ngbe_phy_write_reg(hw, NGBE_PHY_GBCR_REG, value_r9);
+}
+
+static void ngbe_phy_dis_eee_internal(struct ngbe_hw *hw)
+{
+	ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_INTERNAL, 0xa4b);
+	ngbe_phy_write_reg(hw, 0x11, 0x1110);
+	ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_INTERNAL, 0x0);
+	ngbe_phy_write_reg(hw, 0xd, 0x0007);
+	ngbe_phy_write_reg(hw, 0xe, 0x003c);
+	ngbe_phy_write_reg(hw, 0xd, 0x4007);
+	ngbe_phy_write_reg(hw, 0xe, 0x0000);
+}
+
+static int ngbe_gphy_efuse_calibration(struct ngbe_hw *hw)
+{
+	u32 efuse[2] = {0, 0};
+
+	ngbe_gphy_wait_mdio_access_on(hw);
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
+	ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_INTERNAL, 0xa46);
+	ngbe_phy_write_reg(hw, 16, (efuse[0] >>  0) & 0xFFFF);
+	ngbe_phy_write_reg(hw, 17, (efuse[0] >> 16) & 0xFFFF);
+	ngbe_phy_write_reg(hw, 18, (efuse[1] >>  0) & 0xFFFF);
+	ngbe_phy_write_reg(hw, 19, (efuse[1] >> 16) & 0xFFFF);
+
+	/* set efuse ready */
+	ngbe_phy_write_reg(hw, 20, 0x01);
+	ngbe_gphy_wait_mdio_access_on(hw);
+	ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_INTERNAL, 0xa43);
+	ngbe_phy_write_reg(hw, 27, 0x8011);
+	ngbe_phy_write_reg(hw, 28, 0x5737);
+	ngbe_phy_dis_eee_internal(hw);
+
+	return 0;
+}
+
+static void ngbe_phy_setup_powerup(struct ngbe_hw *hw)
+{
+	struct wx_hw *wxhw = &hw->wxhw;
+	u16 val = 0;
+	int ret = 0;
+
+	ret = read_poll_timeout(rd32, val,
+				!(val & (BIT(9) << wxhw->bus.func)), 1000,
+				100000, false, wxhw, 0x10028);
+
+	if (ret)
+		wx_dbg(wxhw, "Lan reset exceeds maximum times.\n");
+
+	ngbe_gphy_efuse_calibration(hw);
+	ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_INTERNAL, 0xa46);
+	/* set efuse ready */
+	ngbe_phy_write_reg(hw, 20, 0x02);
+	ngbe_gphy_wait_mdio_access_on(hw);
+
+	ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_INTERNAL, 0xa42);
+	ret = read_poll_timeout(ngbe_phy_read_reg, val, ((val & 0x7) == 3),
+				1000, 20000, false, hw, 0x10);
+
+	if (ret)
+		wx_dbg(wxhw, "PHY reset exceeds maximum times.\n");
+}
+
+static int ngbe_phy_setup_link_internal(struct ngbe_hw *hw,
+					u32 speed,
+					bool need_restart_AN)
+{
+	u16 val = 0;
+
+	ngbe_phy_setup_powerup(hw);
+	/* select page to 0x0 */
+	ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_INTERNAL, 0x0);
+	ngbe_phy_setup_link_copper(hw, speed);
+
+	val = ngbe_phy_read_reg(hw, NGBE_PHY_BASE_CTRL_REG);
+	if (hw->phy.autoneg) {
+		/* restart AN and wait AN done interrupt */
+		if (hw->ncsi_enabled) {
+			val |= NGBE_PHY_ANE;
+			if (need_restart_AN)
+				val |= NGBE_PHY_ANE;
+		} else {
+			val |= NGBE_PHY_RESTART_AN | NGBE_PHY_ANE;
+		}
+	}
+	ngbe_phy_write_reg(hw, NGBE_PHY_BASE_CTRL_REG, val);
+	ngbe_phy_led_ctrl_internal(hw);
+	ngbe_check_phy_event(hw);
+
+	return 0;
+}
+
+static int ngbe_phy_setup_link_mv(struct ngbe_hw *hw,
+				  u32 speed,
+				  bool autoneg_wait_to_complete)
+{
+	u16 val;
+
+	if (hw->phy.media_type == ngbe_media_type_copper) {
+		ngbe_phy_setup_link_copper(hw, speed);
+		val = ngbe_phy_read_reg(hw, NGBE_PHY_BASE_CTRL_REG);
+		if (hw->phy.autoneg)
+			val = NGBE_PHY_RESTART_AN | NGBE_PHY_ANE;
+		val |= NGBE_PHY_RESET;
+		ngbe_phy_write_reg(hw, NGBE_PHY_BASE_CTRL_REG, val);
+	} else {
+		ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_MV, 1);
+		val = ngbe_phy_read_reg(hw, NGBE_PHY_ANAR_REG);
+		val |= NGBE_PHY_1000BASEX_FULL_MV;
+		ngbe_phy_write_reg(hw, NGBE_PHY_ANAR_REG, val);
+
+		val = NGBE_PHY_RESET |
+		      NGBE_PHY_DUPLEX |
+		      NGBE_PHY_SPEED_SELECT1;
+		if (hw->phy.autoneg)
+			val |= NGBE_PHY_RESTART_AN |
+			      NGBE_PHY_ANE;
+		ngbe_phy_write_reg(hw, NGBE_PHY_BASE_CTRL_REG, val);
+	}
+	/* sw reset power down bit is retain */
+	val = ngbe_phy_read_reg(hw, NGBE_PHY_BASE_CTRL_REG);
+	val &= ~NGBE_PHY_POWER_DOWN;
+	ngbe_phy_write_reg(hw, NGBE_PHY_BASE_CTRL_REG, val);
+	ngbe_phy_led_ctrl_mv(hw);
+	ngbe_check_phy_event(hw);
+
+	return 0;
+}
+
+static int ngbe_phy_setup_link_yt(struct ngbe_hw *hw,
+				  u32 speed,
+				  bool autoneg_wait_to_complete)
+{
+	u16 value_r4 = 0;
+	u16 value_r9 = 0;
+	int ret_val = 0;
+	u16 val;
+
+	hw->phy.autoneg_advertised = 0;
+	if (hw->phy.phy_mode == 0) {/* utp_to_rgmii */
+		ngbe_phy_setup_link_copper(hw, speed);
+		/* software reset to make the above configuration take effect*/
+		val = ngbe_phy_read_reg(hw, NGBE_PHY_BASE_CTRL_REG);
+		if (hw->phy.autoneg)
+			val = NGBE_PHY_RESTART_AN | NGBE_PHY_ANE;
+		val |= NGBE_PHY_RESET;
+		ngbe_phy_write_reg(hw, NGBE_PHY_BASE_CTRL_REG, val);
+	} else if (hw->phy.phy_mode == 1) {/* fiber_to_rgmii */
+		if (!hw->phy.autoneg) {
+			switch (speed) {
+			case SPEED_1000:
+				val = SPEED_1000;
+				break;
+			case SPEED_100:
+				val = SPEED_100;
+				break;
+			default:
+				val = SPEED_1000;
+				break;
+			}
+
+			val = ngbe_phy_read_reg_ext_yt(hw, 0xA006);
+			if (hw->phy.autoneg_advertised & SPEED_1000)
+				val |= 0x1;
+			else if (hw->phy.autoneg_advertised & SPEED_100)
+				val &= ~0x1;
+			ngbe_phy_write_reg_ext_yt(hw, 0xA006, val);
+
+			/* close auto sensing */
+			val = ngbe_phy_read_reg_sds_ext_yt(hw, 0xA5);
+			val &= ~0x8000;
+			ngbe_phy_write_reg_sds_ext_yt(hw, 0xA5, val);
+
+			val = ngbe_phy_read_reg_ext_yt(hw, 0xA001);
+			val &= ~0x8000;
+			ngbe_phy_write_reg_ext_yt(hw, 0xA001, val);
+
+			goto skip_an_fiber;
+		}
+
+		/* open auto sensing */
+		val = ngbe_phy_read_reg_sds_ext_yt(hw, 0xA5);
+		val |= 0x8000;
+		ngbe_phy_write_reg_sds_ext_yt(hw, 0xA5, val);
+
+		val = ngbe_phy_read_reg_ext_yt(hw, 0xA006);
+		val |= 0x1;
+		ngbe_phy_write_reg_ext_yt(hw, 0xA006, val);
+skip_an_fiber:
+		/* RGMII_Config1 : Config rx and tx training delay */
+		ngbe_phy_write_reg_ext_yt(hw, 0xA003, 0x3cf1);
+		ngbe_phy_write_reg_ext_yt(hw, 0xA001, 0x8041);
+
+		/* software reset */
+		if (hw->phy.autoneg)
+			ngbe_phy_write_reg_sds_mii_yt(hw, 0x0, 0x9340);
+		else
+			ngbe_phy_write_reg_sds_mii_yt(hw, 0x0, 0x8140);
+	} else if (hw->phy.phy_mode == 2) {
+		/* power on in UTP mode */
+		val = ngbe_phy_read_reg(hw, 0x0);
+		val &= ~0x800;
+		ngbe_phy_write_reg(hw, 0x0, val);
+
+		/* power on in Fiber mode */
+		val = ngbe_phy_read_reg_sds_mii_yt(hw, 0x0);
+		val &= ~0x800;
+		ngbe_phy_write_reg_sds_mii_yt(hw, 0x0, val);
+
+		val = ngbe_phy_read_reg_sds_mii_yt(hw, 0x11);
+
+		if (val & 0x400) { /* fiber up */
+			hw->phy.autoneg_advertised |= SPEED_1000;
+		} else { /* utp up */
+			value_r4 = 0x1E0;
+			value_r9 = 0x300;
+			/*disable 100/10base-T Self-negotiation ability*/
+			val = ngbe_phy_read_reg_mdi(hw, 0x4);
+			val &= ~value_r4;
+			ngbe_phy_write_reg_mdi(hw, 0x4, val);
+
+			/*disable 1000base-T Self-negotiation ability*/
+			val = ngbe_phy_read_reg_mdi(hw, 0x9);
+			val &= ~value_r9;
+			ngbe_phy_write_reg_mdi(hw, 0x9, val);
+
+			value_r4 = 0x0;
+			value_r9 = 0x0;
+
+			if (speed & SPEED_1000) {
+				hw->phy.autoneg_advertised |= SPEED_1000;
+				value_r9 |= 0x200;
+			}
+			if (speed & SPEED_100) {
+				hw->phy.autoneg_advertised |= SPEED_1000;
+				value_r4 |= 0x100;
+			}
+			if (speed & SPEED_10) {
+				hw->phy.autoneg_advertised |= SPEED_1000;
+				value_r4 |= 0x40;
+			}
+
+			/* enable 1000base-T Self-negotiation ability */
+			val = ngbe_phy_read_reg_mdi(hw, 0x9);
+			val |= value_r9;
+			ngbe_phy_write_reg_mdi(hw, 0x9, val);
+
+			/* enable 100/10base-T Self-negotiation ability */
+			val = ngbe_phy_read_reg_mdi(hw, 0x4);
+			val |= value_r4;
+			ngbe_phy_write_reg_mdi(hw, 0x4, val);
+
+			/* software reset to make the above configuration take effect*/
+			val = ngbe_phy_read_reg_mdi(hw, 0x0);
+			val |= 0x8000;
+			ngbe_phy_write_reg_mdi(hw, 0x0, val);
+		}
+	} else if (hw->phy.phy_mode == 4) {
+		hw->phy.autoneg_advertised |= SPEED_1000;
+
+		val = ngbe_phy_read_reg_ext_yt(hw, 0xA003);
+		val |= 0x8000;
+		ngbe_phy_write_reg_ext_yt(hw, 0xA003, val);
+
+		val = ngbe_phy_read_reg_ext_yt(hw, 0xA004);
+		val &= ~0xf0;
+		val |= 0xb0;
+		ngbe_phy_write_reg_ext_yt(hw, 0xA004, val);
+
+		val = ngbe_phy_read_reg_ext_yt(hw, 0xA001);
+		val &= ~0x8000;
+		ngbe_phy_write_reg_ext_yt(hw, 0xA001, val);
+
+		/* power on phy */
+		val = ngbe_phy_read_reg_sds_mii_yt(hw, 0x0);
+		val &= ~0x800;
+		ngbe_phy_write_reg_sds_mii_yt(hw, 0x0, val);
+	} else if (hw->phy.phy_mode == 5) {/* sgmii_to_rgmii */
+		if (!hw->phy.autoneg) {
+			switch (speed) {
+			case SPEED_1000:
+				val = NGBE_PHY_SPEED_SELECT1;
+				break;
+			case SPEED_100:
+				val = NGBE_PHY_SPEED_SELECT0;
+				break;
+			case SPEED_10:
+				val = 0;
+				break;
+			default:
+				val = NGBE_PHY_SPEED_SELECT0 | NGBE_PHY_SPEED_SELECT1;
+				wx_dbg(&hw->wxhw, "unknown speed = 0x%x.\n", speed);
+				break;
+			}
+			/* duplex full */
+			val |= NGBE_PHY_DUPLEX | NGBE_PHY_RESET;
+			ngbe_phy_write_reg_sds_mii_yt(hw, 0x0, val);
+
+			goto skip_an_sr;
+		}
+
+		val = 0;
+		if (speed & SPEED_1000)
+			val |= 0x40;
+		if (speed & SPEED_100)
+			val |= 0x2000;
+		if (speed & SPEED_100)
+			val |= 0x0;
+		/* duplex full */
+		val |= NGBE_PHY_DUPLEX | 0x8000;
+		ngbe_phy_write_reg_sds_mii_yt(hw, 0x0, val);
+
+		/* software reset to make the above configuration take effect */
+		val = ngbe_phy_read_reg_sds_mii_yt(hw, 0x0);
+		val |= 0x9200;
+		ngbe_phy_write_reg_sds_mii_yt(hw, 0x0, val);
+skip_an_sr:
+		/* power on in UTP mode */
+		val = ngbe_phy_read_reg_sds_mii_yt(hw, 0x0);
+		val &= ~0x800;
+		ngbe_phy_write_reg_sds_mii_yt(hw, 0x0, val);
+	}
+	ngbe_check_phy_event(hw);
+
+	return ret_val;
+}
+
+/**
+ *  ngbe_check_phy_link_internal - Determine link and speed status
+ *  @hw: pointer to hardware structure
+ *  @speed: pointer to link speed
+ *  @link_up: true when link is up
+ *  @link_up_wait_to_complete: bool used to wait for link up or not
+ *
+ *  Reads the links register to determine if link is up and the current speed
+ **/
+static void ngbe_check_phy_link_internal(struct ngbe_hw *hw,
+					 u32 *speed,
+					 bool *link_up,
+					 bool link_up_wait_to_complete)
+{
+	u16 speed_sta = 0;
+	u16 val = 0;
+
+	/* select page to 0xa43 */
+	ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_INTERNAL, 0xa43);
+	val = ngbe_phy_read_reg(hw, NGBE_PHY_PHYSR_REG_INTERNAL);
+	if (val & 0x4)
+		*link_up = true;
+	else
+		*link_up = false;
+
+	speed_sta = val & 0x38;
+	if (*link_up) {
+		if (speed_sta == 0x28)
+			*speed = SPEED_1000;
+		else if (speed_sta == 0x18)
+			*speed = SPEED_100;
+		else if (speed_sta == 0x8)
+			*speed = SPEED_10;
+	} else {
+		*speed = 0;
+	}
+	if (*speed == SPEED_1000) {
+		ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_INTERNAL, 0xa43);
+		val = ngbe_phy_read_reg(hw, 0xa);
+		if (!(val & 0x2000))
+			*link_up = false;
+	}
+}
+
+static void ngbe_check_phy_link_mv(struct ngbe_hw *hw,
+				   u32 *speed,
+				   bool *link_up,
+				   bool link_up_wait_to_complete)
+{
+	u16 speed_sta = 0;
+	u16 val = 0;
+
+	if (hw->phy.media_type == ngbe_media_type_copper)
+		/* select page to 0x0 */
+		ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_MV, 0x0);
+	else
+		/* select page to 0x1 */
+		ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_MV, 0x1);
+	val = ngbe_phy_read_reg(hw, 0x11);
+	if (val & 0x400)
+		*link_up = true;
+	else
+		*link_up = false;
+
+	speed_sta = val & 0xC000;
+	if (*link_up) {
+		if (speed_sta == 0x8000)
+			*speed = SPEED_1000;
+		else if (speed_sta == 0x4000)
+			*speed = SPEED_100;
+		else if (speed_sta == 0x0000)
+			*speed = SPEED_10;
+	} else {
+		*speed = 0;
+	}
+}
+
+static void ngbe_check_phy_link_yt(struct ngbe_hw *hw,
+				   u32 *speed,
+				   bool *link_up,
+				   bool link_up_wait_to_complete)
+{
+	u16 speed_sta = 0;
+	u16 val = 0;
+
+	val = ngbe_phy_read_reg_sds_mii_yt(hw, 0x11);
+	if (val & 0x400) {
+		*link_up = true;
+	} else {
+		*link_up = false;
+
+		val = ngbe_phy_read_reg(hw, 0x11);
+		if (val & 0x400)
+			*link_up = true;
+		else
+			*link_up = false;
+	}
+
+	speed_sta = val & 0xC000;
+	if (*link_up) {
+		if (speed_sta == 0x8000) {
+			*speed = SPEED_1000;
+			wr32m(&hw->wxhw, NGBE_CFG_LED_CTL, 0xE | BIT(17), BIT(1) | BIT(17));
+		} else if (speed_sta == 0x4000) {
+			*speed = SPEED_100;
+			wr32m(&hw->wxhw, NGBE_CFG_LED_CTL, 0xE | BIT(17), BIT(2) | BIT(17));
+		} else if (speed_sta == 0x0000) {
+			*speed = SPEED_10;
+			wr32m(&hw->wxhw, NGBE_CFG_LED_CTL, 0xE | BIT(17), BIT(3) | BIT(17));
+		}
+	} else {
+		*speed = 0;
+		wr32m(&hw->wxhw, NGBE_CFG_LED_CTL, 0xE | BIT(17), 0);
+	}
+}
+
+u16 ngbe_phy_read_reg(struct ngbe_hw *hw, u32 reg_addr)
+{
+	u16 phy_data = 0;
+
+	if (hw->mac_type == ngbe_mac_type_mdi)
+		phy_data = ngbe_phy_read_reg_internal(hw, reg_addr);
+	else if (hw->mac_type == ngbe_mac_type_rgmii)
+		phy_data = ngbe_phy_read_reg_mdi(hw, reg_addr);
+
+	return phy_data;
+}
+
+void ngbe_phy_write_reg(struct ngbe_hw *hw, u32 reg_addr, u16 phy_data)
+{
+	if (hw->mac_type == ngbe_mac_type_mdi)
+		ngbe_phy_write_reg_internal(hw, reg_addr, phy_data);
+	else if (hw->mac_type == ngbe_mac_type_rgmii)
+		ngbe_phy_write_reg_mdi(hw, reg_addr, phy_data);
+}
+
+int ngbe_phy_setup_link(struct ngbe_hw *hw,
+			u32 speed,
+			bool autoneg_wait_to_complete)
+{
+	int ret = 0;
+
+	switch (hw->phy.type) {
+	case ngbe_phy_m88e1512:
+	case ngbe_phy_m88e1512_sfi:
+	case ngbe_phy_m88e1512_mix:
+		ret = ngbe_phy_setup_link_mv(hw, speed, false);
+		break;
+	case ngbe_phy_yt_mix:
+		ret = ngbe_phy_setup_link_yt(hw, speed, false);
+		break;
+	case ngbe_phy_internal_yt_sfi:
+	case ngbe_phy_internal:
+		ret = ngbe_phy_setup_link_internal(hw, speed, false);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+int ngbe_phy_check_link(struct ngbe_hw *hw,
+			u32 *speed,
+			bool *link_up,
+			bool link_up_wait_to_complete)
+{
+	int ret = 0;
+
+	switch (hw->phy.type) {
+	case ngbe_phy_m88e1512_sfi:
+	case ngbe_phy_m88e1512:
+		ngbe_check_phy_link_mv(hw, speed, link_up, false);
+		break;
+	case ngbe_phy_yt_mix:
+		ngbe_check_phy_link_yt(hw, speed, link_up, false);
+		break;
+	case ngbe_phy_internal_yt_sfi:
+	case ngbe_phy_internal:
+		/* select page to 0x0 */
+		ngbe_check_phy_link_internal(hw, speed, link_up, false);
+		break;
+	default:
+		ret = -EIO;
+		break;
+	}
+
+	return ret;
+}
+
+int ngbe_phy_reset(struct ngbe_hw *hw)
+{
+	int ret = 0;
+	u16 val = 0;
+
+	switch (hw->phy.type) {
+	case ngbe_phy_m88e1512_sfi:
+		/* select page to 0x1 */
+		ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_MV, 0x1);
+		break;
+	case ngbe_phy_m88e1512:
+		/* select page to 0x0 */
+		ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_MV, 0x0);
+		break;
+	case ngbe_phy_yt_mix:
+		if (hw->phy.media_type == ngbe_media_type_fiber) {
+			ngbe_phy_write_reg(hw, 0x1e, 0xa000);
+			ngbe_phy_write_reg(hw, 0x1f, 0x2);
+		}
+		break;
+	case ngbe_phy_internal_yt_sfi:
+	case ngbe_phy_internal:
+		/* select page to 0x0 */
+		ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_INTERNAL, 0x0);
+		break;
+	default:
+		ret =  -EIO;
+	}
+	val = ngbe_phy_read_reg(hw, NGBE_PHY_BASE_CTRL_REG);
+	val |= NGBE_PHY_RESET;
+	ngbe_phy_write_reg(hw, NGBE_PHY_BASE_CTRL_REG, val);
+
+	ret = read_poll_timeout(ngbe_phy_read_reg, val, val & NGBE_PHY_RESET, 1000,
+				100000, false, hw, 0x0);
+
+	if (!ret)
+		wx_err(&hw->wxhw,
+		       "phy reset exceeds maximum waiting period.\n");
+
+	return ret;
+}
+
+void ngbe_check_phy_event(struct ngbe_hw *hw)
+{
+	struct ngbe_adapter *adapter =
+			container_of(hw, struct ngbe_adapter, hw);
+	u16 int_mask = 0;
+	u16 val = 0;
+
+	switch (hw->phy.type) {
+	case ngbe_phy_m88e1512:
+		int_mask = NGBE_PHY_INT_STATUS_ANC_MV |
+			   NGBE_PHY_INT_STATUS_LSC_MV;
+		/* select page to 0x0 */
+		ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_MV, 0x0);
+		val = ngbe_phy_read_reg(hw, NGBE_PHY_INT_STATUS_REG_MV);
+		break;
+	case ngbe_phy_m88e1512_sfi:
+		int_mask = NGBE_PHY_INT_STATUS_ANC_MV |
+			   NGBE_PHY_INT_STATUS_LSC_MV;
+		/* select page to 0x1 */
+		ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_MV, 0x1);
+		val = ngbe_phy_read_reg(hw, NGBE_PHY_INT_STATUS_REG_MV);
+		break;
+	case ngbe_phy_yt_mix:
+		int_mask = NGBE_PHY_INT_STATUS_SDSLNKUP_YT |
+			   NGBE_PHY_INT_STATUS_SDSLNKDN_YT |
+			   NGBE_PHY_INT_STATUS_UTPLNKUP_YT |
+			   NGBE_PHY_INT_STATUS_UTPLNKDN_YT;
+		ngbe_phy_write_reg_ext_yt(hw, 0xa000, 0x0);
+		val = ngbe_phy_read_reg(hw, NGBE_PHY_INT_STATUS_REG_YT);
+		break;
+	case ngbe_phy_internal_yt_sfi:
+	case ngbe_phy_internal:
+		int_mask = NGBE_PHY_INT_STATUS_LSC_INTERNAL |
+			   NGBE_PHY_INT_STATUS_ANC_INTERNAL;
+		/* select page to 0xa43 */
+		ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_INTERNAL, 0xa43);
+		val = ngbe_phy_read_reg(hw, NGBE_PHY_INT_STATUS_REG_INTERNAL);
+		break;
+	default:
+		break;
+	}
+
+	if (val | int_mask)
+		set_bit(NGBE_FLAG_NEED_LINK_UPDATE, adapter->flags);
+}
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_phy.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_phy.h
new file mode 100644
index 000000000000..5d94f00194cf
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_phy.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * WangXun Gigabit PCI Express Linux driver
+ * Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd.
+ */
+
+#ifndef _NGBE_PHY_H_
+#define _NGBE_PHY_H_
+
+u16 ngbe_phy_read_reg(struct ngbe_hw *hw, u32 reg_addr);
+void ngbe_phy_write_reg(struct ngbe_hw *hw, u32 reg_addr, u16 phy_data);
+int ngbe_phy_init(struct ngbe_hw *hw);
+int ngbe_phy_reset(struct ngbe_hw *hw);
+int ngbe_phy_setup_link(struct ngbe_hw *hw,
+			u32 speed,
+			bool autoneg_wait_to_complete);
+int ngbe_phy_check_link(struct ngbe_hw *hw,
+			u32 *speed,
+			bool *link_up,
+			bool link_up_wait_to_complete);
+void ngbe_check_phy_event(struct ngbe_hw *hw);
+#endif /* _NGBE_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
index 39f6c03f1a54..f6b257e84319 100644
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
@@ -85,21 +105,95 @@
 #define NGBE_PSR_WKUP_CTL_IPV6			BIT(7) /* Directed IPv6 Pkt Wakeup Enable */
 
 #define NGBE_FW_EEPROM_CHECKSUM_CMD		0xE9
+#define NGBE_FW_PHY_LED_CONF			0xF1
 #define NGBE_FW_NVM_DATA_OFFSET			3
 #define NGBE_FW_CMD_DEFAULT_CHECKSUM		0xFF /* checksum always 0xFF */
 #define NGBE_FW_CMD_ST_PASS			0x80658383
 #define NGBE_FW_CMD_ST_FAIL			0x70657376
 
+/* NGBE phy base registers and BITs*/
+#define NGBE_PHY_BASE_CTRL_REG			0x0
+#define NGBE_PHY_ID1_REG			0x2
+#define NGBE_PHY_ID2_REG			0x3
+#define NGBE_PHY_ANAR_REG			0x4
+#define NGBE_PHY_GBCR_REG			0x9
+#define NGBE_PHY_INTM_REG			0x12
+#define NGBE_PHY_ID_MASK			0xFFFFFC00U
+
+/* NGBE_PHY_BASE_CTRL_REG bit mask*/
+#define NGBE_PHY_SPEED_SELECT1			BIT(6)
+#define NGBE_PHY_DUPLEX				BIT(8)
+#define NGBE_PHY_RESTART_AN			BIT(9)
+#define NGBE_PHY_POWER_DOWN			BIT(11)
+#define NGBE_PHY_ANE				BIT(12)
+#define NGBE_PHY_SPEED_SELECT0			BIT(13)
+#define NGBE_PHY_RESET				BIT(15)
+
+/* NGBE_PHY_ANAR_REG bit mask */
+#define NGBE_PHY_10BASET_HALF			BIT(5)
+#define NGBE_PHY_10BASET_FULL			BIT(6)
+#define NGBE_PHY_100BASETX_HALF			BIT(7)
+#define NGBE_PHY_100BASETX_FULL			BIT(8)
+
+#define NGBE_PHY_1000BASEX_FULL_MV		BIT(5)
+
+/* NGBE_PHY_GBCR_REG bit mask*/
+#define NGBE_PHY_1000BASET_HALF			BIT(8)
+#define NGBE_PHY_1000BASET_FULL			BIT(9)
+
+/* M88E1512 */
+#define NGBE_PHY_ID_MV				0x005043
+#define NGBE_PHY_PAGE_ACCESS_MV			0x16
+#define NGBE_PHY_INT_STATUS_REG_MV		0x13
+#define NGBE_PHY_LED_FUNC_CTRL_REG_MV		0x10
+#define NGBE_PHY_LED_POL_CTRL_REG_MV		0x11
+
+/* reg 19_0 INT status*/
+#define NGBE_PHY_INT_STATUS_ANC_MV		BIT(11)
+#define NGBE_PHY_INT_STATUS_LSC_MV		BIT(10)
+/* reg 21_2 */
+#define NGBE_RGM_TTC_MV				BIT(4)
+#define NGBE_RGM_RTC_MV				BIT(5)
+/* reg 18_3 */
+#define NGBE_INT_EN_MV				BIT(7)
+#define NGBE_INT_POL_MV				BIT(11)
+
+/* LED conf */
+#define NGBE_LED1_CONF_MV			0x6
+#define NGBE_LED0_CONF_MV			0x1
+/* LED polarity */
+#define NGBE_LED1_POL_MV			0x1
+#define NGBE_LED0_POL_MV			0x1
+
+/* YT8521s/YT8531s */
+#define NGBE_PHY_ID_YT8521S			0x011a
+#define NGBE_PHY_ID_YT8531S			0xe91a
+#define NGBE_PHY_INT_STATUS_REG_YT		0x13
+#define NGBE_PHY_INT_STATUS_SDSLNKUP_YT		BIT(2)
+#define NGBE_PHY_INT_STATUS_SDSLNKDN_YT		BIT(3)
+#define NGBE_PHY_INT_STATUS_UTPLNKUP_YT		BIT(10)
+#define NGBE_PHY_INT_STATUS_UTPLNKDN_YT		BIT(11)
+
+/* INTERNAL PHY*/
+#define NGBE_CFG_LED_CTL			0x14424
+#define NGBE_PHY_ID_INTERNAL			0x000732
+#define NGBE_PHY_CONFIG(reg_offset)		(0x14000 + ((reg_offset) * 4))
+#define NGBE_PHY_PAGE_ACCESS_INTERNAL		0x1F
+#define NGBE_PHY_INT_STATUS_REG_INTERNAL	0x1d
+#define NGBE_PHY_PHYSR_REG_INTERNAL		0x1a
+#define NGBE_PHY_INT_STATUS_LSC_INTERNAL	BIT(4)
+#define NGBE_PHY_INT_STATUS_ANC_INTERNAL	BIT(3)
+
 enum ngbe_phy_type {
 	ngbe_phy_unknown = 0,
 	ngbe_phy_none,
 	ngbe_phy_internal,
 	ngbe_phy_m88e1512,
 	ngbe_phy_m88e1512_sfi,
-	ngbe_phy_m88e1512_unknown,
-	ngbe_phy_yt8521s,
-	ngbe_phy_yt8521s_sfi,
-	ngbe_phy_internal_yt8521s_sfi,
+	ngbe_phy_m88e1512_mix,
+	ngbe_phy_yt,
+	ngbe_phy_yt_mix,
+	ngbe_phy_internal_yt_sfi,
 	ngbe_phy_generic
 };
 
@@ -122,9 +216,16 @@ struct ngbe_phy_info {
 
 	u32 addr;
 	u32 id;
+	u8 phy_mode;
+	u32 gphy_efuse[2];
 
-	bool reset_if_overtemp;
+	bool autoneg;
+	u32 autoneg_advertised;
+};
 
+enum ngbe_pf_flags {
+	NGBE_FLAG_NEED_LINK_UPDATE,
+	NGBE_FLAGS_NBITS		/* must be last */
 };
 
 struct ngbe_hw {
@@ -135,5 +236,7 @@ struct ngbe_hw {
 	bool wol_enabled;
 	bool ncsi_enabled;
 	bool gpio_ctrl;
+
+	u32 led_conf;
 };
 #endif /* _NGBE_TYPE_H_ */
-- 
2.38.1

