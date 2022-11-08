Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38755620E9A
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 12:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbiKHLUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 06:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbiKHLUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 06:20:43 -0500
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09D828E32
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 03:20:40 -0800 (PST)
X-QQ-mid: bizesmtp85t1667906367tc0qa5d3
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 08 Nov 2022 19:19:25 +0800 (CST)
X-QQ-SSF: 01400000000000M0M000000A0000000
X-QQ-FEAT: CR3LFp2JE4k1HfVaDDiWOq9n3l7ziNJyw6/F1oWOXjo8HBzIKANfPYJtidg6r
        gFH4yWWKi1h9LBdBVUIY834cLihIrgJ6f57WcCl+OoDjwGEHM2ARh/s9WPZfqML9nPg263v
        EDxoM8CRQcwztZC4FgiXxDoX/SVFZDKJhPyRupeucuEo+nGsm2kGHPHOZdiECa1uHPWtmVh
        6gtBdvNAMFtBWw99JjWsd5OAp1jefYukSgjXj8aSH2gBWvckwm8OG+CGVq1uuPN4ExagJx1
        ZpmppJjnNZe4l1wtOiTrmoPaY8wQIjYPfu4vvFHq77BcMEphuHS7T8Isg8i4DGAK5snTdTZ
        gl5+ie1oQqZqvDHHfQcNlhj7d0q/Lg88eH7PotnkuBWe0Gus9fgSnWj2FDXEo7QQOrRwYIA
        5rfE8TJYwTM=
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com
Subject: [PATCH net-next 1/5] net: txgbe: Identify PHY and SFP module
Date:   Tue,  8 Nov 2022 19:19:03 +0800
Message-Id: <20221108111907.48599-2-mengyuanlou@net-swift.com>
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

From: Jiawen Wu <jiawenwu@trustnetic.com>

Add to get media type and physical layer module, support I2C access.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 .../device_drivers/ethernet/wangxun/txgbe.rst |  37 ++
 drivers/net/ethernet/wangxun/libwx/wx_hw.c    |   6 +-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |   2 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |   1 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 421 ++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  29 +-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   | 124 ++++++
 7 files changed, 614 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst b/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
index eaa87dbe8848..3cb9549fb7b0 100644
--- a/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
+++ b/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
@@ -14,6 +14,43 @@ Contents
 - Support
 
 
+Identifying Your Adapter
+========================
+The driver is compatible with WangXun Sapphire Dual ports Ethernet Adapters.
+
+SFP+ Devices with Pluggable Optics
+----------------------------------
+The following is a list of 3rd party SFP+ modules that have been tested and verified.
+
++----------+----------------------+----------------------+
+| Supplier | Type                 | Part Numbers         |
++==========+======================+======================+
+| Avago    | SFP+                 | AFBR-709SMZ          |
++----------+----------------------+----------------------+
+| F-tone   | SFP+                 | FTCS-851X-02D        |
++----------+----------------------+----------------------+
+| Finisar  | SFP+                 | FTLX8574D3BCL        |
++----------+----------------------+----------------------+
+| Hasense  | SFP+                 | AFBR-709SMZ          |
++----------+----------------------+----------------------+
+| HGTECH   | SFP+                 | MTRS-01X11-G         |
++----------+----------------------+----------------------+
+| HP       | SFP+                 | SR SFP+ 456096-001   |
++----------+----------------------+----------------------+
+| Huawei   | SFP+                 | AFBR-709SMZ          |
++----------+----------------------+----------------------+
+| Intel    | SFP+                 | FTLX8571D3BCV-IT     |
++----------+----------------------+----------------------+
+| JDSU     | SFP+                 | PLRXPL-SC-S43        |
++----------+----------------------+----------------------+
+| SONT     | SFP+                 | XP-8G10-01           |
++----------+----------------------+----------------------+
+| Trixon   | SFP+                 | TPS-TGM3-85DCR       |
++----------+----------------------+----------------------+
+| WTD      | SFP+                 | RTXM228-551          |
++----------+----------------------+----------------------+
+
+
 Support
 =======
 If you got any problem, contact Wangxun support team via support@trustnetic.com
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index 1eb7388f1dd5..045d6e978598 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -114,12 +114,13 @@ static DEFINE_MUTEX(wx_sw_sync_lock);
  *  Releases the SW semaphore for the specified
  *  function (CSR, PHY0, PHY1, EEPROM, Flash)
  **/
-static void wx_release_sw_sync(struct wx_hw *wxhw, u32 mask)
+void wx_release_sw_sync(struct wx_hw *wxhw, u32 mask)
 {
 	mutex_lock(&wx_sw_sync_lock);
 	wr32m(wxhw, WX_MNG_SWFW_SYNC, mask, 0);
 	mutex_unlock(&wx_sw_sync_lock);
 }
+EXPORT_SYMBOL(wx_release_sw_sync);
 
 /**
  *  wx_acquire_sw_sync - Acquire SW semaphore
@@ -129,7 +130,7 @@ static void wx_release_sw_sync(struct wx_hw *wxhw, u32 mask)
  *  Acquires the SW semaphore for the specified
  *  function (CSR, PHY0, PHY1, EEPROM, Flash)
  **/
-static int wx_acquire_sw_sync(struct wx_hw *wxhw, u32 mask)
+int wx_acquire_sw_sync(struct wx_hw *wxhw, u32 mask)
 {
 	u32 sem = 0;
 	int ret = 0;
@@ -147,6 +148,7 @@ static int wx_acquire_sw_sync(struct wx_hw *wxhw, u32 mask)
 
 	return ret;
 }
+EXPORT_SYMBOL(wx_acquire_sw_sync);
 
 /**
  *  wx_host_interface_command - Issue command to manageability block
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.h b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
index a0652f5e9939..5058774381c1 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
@@ -7,6 +7,8 @@
 int wx_check_flash_load(struct wx_hw *hw, u32 check_bit);
 void wx_control_hw(struct wx_hw *wxhw, bool drv);
 int wx_mng_present(struct wx_hw *wxhw);
+void wx_release_sw_sync(struct wx_hw *wxhw, u32 mask);
+int wx_acquire_sw_sync(struct wx_hw *wxhw, u32 mask);
 int wx_host_interface_command(struct wx_hw *wxhw, u32 *buffer,
 			      u32 length, u32 timeout, bool return_data);
 int wx_read_ee_hostif(struct wx_hw *wxhw, u16 offset, u16 *data);
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 1cbeef8230bf..c95cda53bf67 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -123,6 +123,7 @@
 
 /************************************** MNG ********************************/
 #define WX_MNG_SWFW_SYNC             0x1E008
+#define WX_MNG_SWFW_SYNC_SW_PHY      BIT(0)
 #define WX_MNG_SWFW_SYNC_SW_MB       BIT(2)
 #define WX_MNG_SWFW_SYNC_SW_FLASH    BIT(3)
 #define WX_MNG_MBOX                  0x1E100
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index 0b1032195859..77a44e48fc9e 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -14,6 +14,375 @@
 #include "txgbe_hw.h"
 #include "txgbe.h"
 
+static u32 txgbe_rd32_epcs(struct txgbe_hw *hw, u32 addr)
+{
+	struct wx_hw *wxhw = &hw->wxhw;
+	u32 offset;
+
+	/* Set the LAN port indicator to offset[1] */
+	/* 1st, write the offset to IDA_ADDR register */
+	offset = TXGBE_XPCS_IDA_ADDR;
+	wr32(wxhw, offset, addr);
+
+	/* 2nd, read the data from IDA_DATA register */
+	offset = TXGBE_XPCS_IDA_DATA;
+	return rd32(wxhw, offset);
+}
+
+static void txgbe_init_i2c(struct txgbe_hw *hw)
+{
+	struct wx_hw *wxhw = &hw->wxhw;
+
+	wr32(wxhw, TXGBE_I2C_ENABLE, 0);
+
+	wr32(wxhw, TXGBE_I2C_CON,
+	     (TXGBE_I2C_CON_MASTER_MODE |
+	      TXGBE_I2C_CON_SPEED(1) |
+	      TXGBE_I2C_CON_RESTART_EN |
+	      TXGBE_I2C_CON_SLAVE_DISABLE));
+	/* Default addr is 0xA0 ,bit 0 is configure for read/write! */
+	wr32(wxhw, TXGBE_I2C_TAR, TXGBE_I2C_SLAVE_ADDR);
+	wr32(wxhw, TXGBE_I2C_SS_SCL_HCNT, 600);
+	wr32(wxhw, TXGBE_I2C_SS_SCL_LCNT, 600);
+	wr32(wxhw, TXGBE_I2C_RX_TL, 0); /* 1byte for rx full signal */
+	wr32(wxhw, TXGBE_I2C_TX_TL, 4);
+	wr32(wxhw, TXGBE_I2C_SCL_STUCK_TIMEOUT, 0xFFFFFF);
+	wr32(wxhw, TXGBE_I2C_SDA_STUCK_TIMEOUT, 0xFFFFFF);
+
+	wr32(wxhw, TXGBE_I2C_INTR_MASK, 0);
+	wr32(wxhw, TXGBE_I2C_ENABLE, 1);
+}
+
+/**
+ *  txgbe_read_i2c_byte_int - Reads 8 bit word over I2C
+ *  @hw: pointer to hardware structure
+ *  @byte_offset: byte offset to read
+ *  @data: value read
+ *
+ *  Performs byte read operation to SFP module's EEPROM over I2C interface at
+ *  a specified device address.
+ **/
+static int txgbe_read_i2c_byte_int(struct txgbe_hw *hw, u8 byte_offset, u8 *data)
+{
+	u32 sync = WX_MNG_SWFW_SYNC_SW_PHY;
+	struct wx_hw *wxhw = &hw->wxhw;
+	int status = 0;
+	u32 val;
+
+	status = wx_acquire_sw_sync(wxhw, sync);
+	if (status != 0)
+		return status;
+
+	/* wait tx empty */
+	status = read_poll_timeout(rd32, val,
+				   (val & TXGBE_I2C_INTR_STAT_TEMP) == TXGBE_I2C_INTR_STAT_TEMP,
+				   100, 1000, false, wxhw, TXGBE_I2C_RAW_INTR_STAT);
+	if (status != 0)
+		goto out;
+
+	/* read data */
+	wr32(wxhw, TXGBE_I2C_DATA_CMD, byte_offset | TXGBE_I2C_DATA_CMD_STOP);
+	wr32(wxhw, TXGBE_I2C_DATA_CMD, TXGBE_I2C_DATA_CMD_READ);
+
+	/* wait for read complete */
+	status = read_poll_timeout(rd32, val,
+				   (val & TXGBE_I2C_INTR_STAT_RFUL) == TXGBE_I2C_INTR_STAT_RFUL,
+				   100, 1000, false, wxhw, TXGBE_I2C_RAW_INTR_STAT);
+	if (status != 0)
+		goto out;
+
+	*data = 0xFF & rd32(wxhw, TXGBE_I2C_DATA_CMD);
+
+out:
+	wx_release_sw_sync(wxhw, sync);
+	return status;
+}
+
+/**
+ *  txgbe_switch_i2c_slave_addr - Switch I2C slave address
+ *  @hw: pointer to hardware structure
+ *  @dev_addr: slave addr to switch
+ **/
+static void txgbe_switch_i2c_slave_addr(struct txgbe_hw *hw, u8 dev_addr)
+{
+	struct wx_hw *wxhw = &hw->wxhw;
+
+	wr32(wxhw, TXGBE_I2C_ENABLE, 0);
+	wr32(wxhw, TXGBE_I2C_TAR, dev_addr >> 1);
+	wr32(wxhw, TXGBE_I2C_ENABLE, 1);
+}
+
+/**
+ *  txgbe_read_i2c_byte - Reads 8 bit word over I2C
+ *  @hw: pointer to hardware structure
+ *  @byte_offset: byte offset to read
+ *  @dev_addr: device address
+ *  @data: value read
+ *
+ *  Performs byte read operation to SFP module's EEPROM over I2C interface at
+ *  a specified device address.
+ **/
+static int txgbe_read_i2c_byte(struct txgbe_hw *hw, u8 byte_offset,
+			       u8 dev_addr, u8 *data)
+{
+	txgbe_switch_i2c_slave_addr(hw, dev_addr);
+
+	return txgbe_read_i2c_byte_int(hw, byte_offset, data);
+}
+
+/**
+ *  txgbe_read_i2c_eeprom - Reads 8 bit EEPROM word over I2C interface
+ *  @hw: pointer to hardware structure
+ *  @byte_offset: EEPROM byte offset to read
+ *  @eeprom_data: value read
+ *
+ *  Performs byte read operation to SFP module's EEPROM over I2C interface.
+ **/
+static int txgbe_read_i2c_eeprom(struct txgbe_hw *hw, u8 byte_offset,
+				 u8 *eeprom_data)
+{
+	return txgbe_read_i2c_byte(hw, byte_offset,
+				   TXGBE_I2C_EEPROM_DEV_ADDR,
+				   eeprom_data);
+}
+
+/**
+ *  txgbe_identify_sfp_module - Identifies SFP modules
+ *  @hw: pointer to hardware structure
+ *
+ *  Searches for and identifies the SFP module and assigns appropriate PHY type.
+ **/
+static int txgbe_identify_sfp_module(struct txgbe_hw *hw)
+{
+	u8 oui_bytes[3] = {0, 0, 0};
+	u8 comp_codes_10g = 0;
+	u8 comp_codes_1g = 0;
+	int status = -EFAULT;
+	u32 vendor_oui = 0;
+	u8 identifier = 0;
+	u8 cable_tech = 0;
+	u8 cable_spec = 0;
+
+	/* LAN ID is needed for I2C access */
+	txgbe_init_i2c(hw);
+
+	status = txgbe_read_i2c_eeprom(hw, TXGBE_SFF_IDENTIFIER, &identifier);
+	if (status != 0)
+		goto err_read_i2c_eeprom;
+
+	if (identifier != TXGBE_SFF_IDENTIFIER_SFP) {
+		hw->phy.type = txgbe_phy_sfp_unsupported;
+		status = -ENODEV;
+	} else {
+		status = txgbe_read_i2c_eeprom(hw, TXGBE_SFF_1GBE_COMP_CODES,
+					       &comp_codes_1g);
+		if (status != 0)
+			goto err_read_i2c_eeprom;
+
+		status = txgbe_read_i2c_eeprom(hw, TXGBE_SFF_10GBE_COMP_CODES,
+					       &comp_codes_10g);
+		if (status != 0)
+			goto err_read_i2c_eeprom;
+
+		status = txgbe_read_i2c_eeprom(hw, TXGBE_SFF_CABLE_TECHNOLOGY,
+					       &cable_tech);
+		if (status != 0)
+			goto err_read_i2c_eeprom;
+
+		 /* ID Module
+		  * =========
+		  * 1   SFP_DA_CORE
+		  * 2   SFP_SR/LR_CORE
+		  * 3   SFP_act_lmt_DA_CORE
+		  * 4   SFP_1g_cu_CORE
+		  * 5   SFP_1g_sx_CORE
+		  * 6   SFP_1g_lx_CORE
+		  */
+		if (cable_tech & TXGBE_SFF_DA_PASSIVE_CABLE) {
+			hw->phy.sfp_type = txgbe_sfp_type_da_cu_core;
+		} else if (cable_tech & TXGBE_SFF_DA_ACTIVE_CABLE) {
+			txgbe_read_i2c_eeprom(hw, TXGBE_SFF_CABLE_SPEC_COMP,
+					      &cable_spec);
+			if (cable_spec & TXGBE_SFF_DA_SPEC_ACTIVE_LIMITING)
+				hw->phy.sfp_type = txgbe_sfp_type_da_act_lmt_core;
+			else
+				hw->phy.sfp_type = txgbe_sfp_type_unknown;
+		} else if (comp_codes_10g & (TXGBE_SFF_10GBASESR_CAPABLE |
+					     TXGBE_SFF_10GBASELR_CAPABLE)) {
+			hw->phy.sfp_type = txgbe_sfp_type_srlr_core;
+		} else if (comp_codes_1g & TXGBE_SFF_1GBASET_CAPABLE) {
+			hw->phy.sfp_type = txgbe_sfp_type_1g_cu_core;
+		} else if (comp_codes_1g & TXGBE_SFF_1GBASESX_CAPABLE) {
+			hw->phy.sfp_type = txgbe_sfp_type_1g_sx_core;
+		} else if (comp_codes_1g & TXGBE_SFF_1GBASELX_CAPABLE) {
+			hw->phy.sfp_type = txgbe_sfp_type_1g_lx_core;
+		} else {
+			hw->phy.sfp_type = txgbe_sfp_type_unknown;
+		}
+
+		/* Determine if the SFP+ PHY is dual speed or not. */
+		hw->phy.multispeed_fiber = false;
+		if (((comp_codes_1g & TXGBE_SFF_1GBASESX_CAPABLE) &&
+		     (comp_codes_10g & TXGBE_SFF_10GBASESR_CAPABLE)) ||
+		    ((comp_codes_1g & TXGBE_SFF_1GBASELX_CAPABLE) &&
+		     (comp_codes_10g & TXGBE_SFF_10GBASELR_CAPABLE)))
+			hw->phy.multispeed_fiber = true;
+
+		/* Determine PHY vendor */
+		status = txgbe_read_i2c_eeprom(hw,
+					       TXGBE_SFF_VENDOR_OUI_BYTE0,
+					       &oui_bytes[0]);
+		if (status != 0)
+			goto err_read_i2c_eeprom;
+
+		status = txgbe_read_i2c_eeprom(hw,
+					       TXGBE_SFF_VENDOR_OUI_BYTE1,
+					       &oui_bytes[1]);
+		if (status != 0)
+			goto err_read_i2c_eeprom;
+
+		status = txgbe_read_i2c_eeprom(hw,
+					       TXGBE_SFF_VENDOR_OUI_BYTE2,
+					       &oui_bytes[2]);
+		if (status != 0)
+			goto err_read_i2c_eeprom;
+
+		vendor_oui =
+			((oui_bytes[0] << TXGBE_SFF_VENDOR_OUI_BYTE0_SHIFT) |
+			 (oui_bytes[1] << TXGBE_SFF_VENDOR_OUI_BYTE1_SHIFT) |
+			 (oui_bytes[2] << TXGBE_SFF_VENDOR_OUI_BYTE2_SHIFT));
+
+		switch (vendor_oui) {
+		case TXGBE_SFF_VENDOR_OUI_TYCO:
+			if (cable_tech & TXGBE_SFF_DA_PASSIVE_CABLE)
+				hw->phy.type = txgbe_phy_sfp_passive_tyco;
+			break;
+		case TXGBE_SFF_VENDOR_OUI_FTL:
+			if (cable_tech & TXGBE_SFF_DA_ACTIVE_CABLE)
+				hw->phy.type = txgbe_phy_sfp_ftl_active;
+			else
+				hw->phy.type = txgbe_phy_sfp_ftl;
+			break;
+		case TXGBE_SFF_VENDOR_OUI_AVAGO:
+			hw->phy.type = txgbe_phy_sfp_avago;
+			break;
+		case TXGBE_SFF_VENDOR_OUI_INTEL:
+			hw->phy.type = txgbe_phy_sfp_intel;
+			break;
+		default:
+			if (cable_tech & TXGBE_SFF_DA_PASSIVE_CABLE)
+				hw->phy.type = txgbe_phy_sfp_passive_unknown;
+			else if (cable_tech & TXGBE_SFF_DA_ACTIVE_CABLE)
+				hw->phy.type = txgbe_phy_sfp_active_unknown;
+			else
+				hw->phy.type = txgbe_phy_sfp_unknown;
+			break;
+		}
+
+		/* Allow any DA cable vendor */
+		if (cable_tech & (TXGBE_SFF_DA_PASSIVE_CABLE |
+				  TXGBE_SFF_DA_ACTIVE_CABLE))
+			return 0;
+
+		/* Verify supported 1G SFP modules */
+		if (comp_codes_10g == 0 &&
+		    !(hw->phy.sfp_type == txgbe_sfp_type_1g_cu_core ||
+		      hw->phy.sfp_type == txgbe_sfp_type_1g_lx_core ||
+		      hw->phy.sfp_type == txgbe_sfp_type_1g_sx_core)) {
+			hw->phy.type = txgbe_phy_sfp_unsupported;
+			return -ENODEV;
+		}
+	}
+
+	return status;
+
+err_read_i2c_eeprom:
+	hw->phy.sfp_type = txgbe_sfp_type_not_present;
+	hw->phy.type = txgbe_phy_unknown;
+
+	return -ENODEV;
+}
+
+/**
+ *  txgbe_get_media_type - Get media type
+ *  @hw: pointer to hardware structure
+ *
+ *  Returns the media type (fiber, copper, backplane)
+ **/
+static enum txgbe_media_type txgbe_get_media_type(struct txgbe_hw *hw)
+{
+	enum txgbe_media_type media_type;
+	struct wx_hw *wxhw = &hw->wxhw;
+	u8 device_type;
+
+	device_type = wxhw->subsystem_device_id & 0xF0;
+	switch (device_type) {
+	case TXGBE_ID_MAC_XAUI:
+	case TXGBE_ID_MAC_SGMII:
+	case TXGBE_ID_KR_KX_KX4:
+		/* Default device ID is mezzanine card KX/KX4 */
+		media_type = txgbe_media_type_backplane;
+		break;
+	case TXGBE_ID_SFP:
+		media_type = txgbe_media_type_fiber;
+		break;
+	case TXGBE_ID_XAUI:
+	case TXGBE_ID_SGMII:
+		media_type = txgbe_media_type_copper;
+		break;
+	case TXGBE_ID_SFI_XAUI:
+		if (wxhw->bus.func == 0)
+			media_type = txgbe_media_type_fiber;
+		else
+			media_type = txgbe_media_type_copper;
+		break;
+	default:
+		media_type = txgbe_media_type_unknown;
+		break;
+	}
+
+	return media_type;
+}
+
+/**
+ *  txgbe_identify_phy - Get physical layer module
+ *  @hw: pointer to hardware structure
+ *
+ *  Determines the physical layer module found on the current adapter.
+ *  If PHY already detected, maintains current PHY type in hw struct,
+ *  otherwise executes the PHY detection routine.
+ **/
+static int txgbe_identify_phy(struct txgbe_hw *hw)
+{
+	int status;
+
+	/* Detect PHY if not unknown - returns success if already detected. */
+	hw->phy.media_type = txgbe_get_media_type(hw);
+	if (hw->phy.media_type == txgbe_media_type_fiber) {
+		status = txgbe_identify_sfp_module(hw);
+	} else {
+		hw->phy.type = txgbe_phy_none;
+		status = 0;
+	}
+
+	return status;
+}
+
+/**
+ *  txgbe_init_phy - PHY/SFP specific init
+ *  @hw: pointer to hardware structure
+ **/
+static int txgbe_init_phy(struct txgbe_hw *hw)
+{
+	int ret_val = 0;
+
+	txgbe_init_i2c(hw);
+	/* Identify the PHY or SFP module */
+	ret_val = txgbe_identify_phy(hw);
+
+	return ret_val;
+}
+
 /**
  *  txgbe_init_thermal_sensor_thresh - Inits thermal sensor thresholds
  *  @hw: pointer to hardware structure
@@ -260,6 +629,7 @@ static void txgbe_reset_misc(struct txgbe_hw *hw)
 {
 	struct wx_hw *wxhw = &hw->wxhw;
 
+	txgbe_init_i2c(hw);
 	wx_reset_misc(wxhw);
 	txgbe_init_thermal_sensor_thresh(hw);
 }
@@ -277,11 +647,30 @@ int txgbe_reset_hw(struct txgbe_hw *hw)
 	struct wx_hw *wxhw = &hw->wxhw;
 	int status;
 
+	u32 sr_pcs_ctl, sr_pma_mmd_ctl1, sr_an_mmd_ctl, sr_an_mmd_adv_reg2;
+	u32 vr_xs_or_pcs_mmd_digi_ctl1, curr_vr_xs_or_pcs_mmd_digi_ctl1;
+	u32 curr_sr_an_mmd_ctl, curr_sr_an_mmd_adv_reg2;
+	u32 curr_sr_pcs_ctl, curr_sr_pma_mmd_ctl1;
+
 	/* Call adapter stop to disable tx/rx and clear interrupts */
 	status = wx_stop_adapter(wxhw);
 	if (status != 0)
 		return status;
 
+	/* Identify PHY and related function pointers */
+	status = txgbe_init_phy(hw);
+	if (status != 0 && hw->phy.type == txgbe_phy_sfp_unsupported)
+		return status;
+
+	/* Remember internal phy regs from before we reset */
+	curr_sr_pcs_ctl = txgbe_rd32_epcs(hw, TXGBE_SR_PCS_CTL2);
+	curr_sr_pma_mmd_ctl1 = txgbe_rd32_epcs(hw, TXGBE_SR_PMA_MMD_CTL1);
+	curr_sr_an_mmd_ctl = txgbe_rd32_epcs(hw, TXGBE_SR_AN_MMD_CTL);
+	curr_sr_an_mmd_adv_reg2 = txgbe_rd32_epcs(hw,
+						  TXGBE_SR_AN_MMD_ADV_REG2);
+	curr_vr_xs_or_pcs_mmd_digi_ctl1 =
+		txgbe_rd32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1);
+
 	if (!(((wxhw->subsystem_device_id & WX_NCSI_MASK) == WX_NCSI_SUP) ||
 	      ((wxhw->subsystem_device_id & WX_WOL_MASK) == WX_WOL_SUP)))
 		wx_reset_hostif(wxhw);
@@ -294,6 +683,38 @@ int txgbe_reset_hw(struct txgbe_hw *hw)
 
 	txgbe_reset_misc(hw);
 
+	/* Store the original values if they have not been stored
+	 * off yet.  Otherwise restore the stored original values
+	 * since the reset operation sets back to defaults.
+	 */
+	sr_pcs_ctl = txgbe_rd32_epcs(hw, TXGBE_SR_PCS_CTL2);
+	sr_pma_mmd_ctl1 = txgbe_rd32_epcs(hw, TXGBE_SR_PMA_MMD_CTL1);
+	sr_an_mmd_ctl = txgbe_rd32_epcs(hw, TXGBE_SR_AN_MMD_CTL);
+	sr_an_mmd_adv_reg2 = txgbe_rd32_epcs(hw, TXGBE_SR_AN_MMD_ADV_REG2);
+	vr_xs_or_pcs_mmd_digi_ctl1 =
+		txgbe_rd32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1);
+
+	if (!hw->phy.orig_link_settings_stored) {
+		hw->phy.orig_sr_pcs_ctl2 = sr_pcs_ctl;
+		hw->phy.orig_sr_pma_mmd_ctl1 = sr_pma_mmd_ctl1;
+		hw->phy.orig_sr_an_mmd_ctl = sr_an_mmd_ctl;
+		hw->phy.orig_sr_an_mmd_adv_reg2 = sr_an_mmd_adv_reg2;
+		hw->phy.orig_vr_xs_or_pcs_mmd_digi_ctl1 =
+						vr_xs_or_pcs_mmd_digi_ctl1;
+		hw->phy.orig_link_settings_stored = true;
+	} else {
+		hw->phy.orig_sr_pcs_ctl2 = curr_sr_pcs_ctl;
+		hw->phy.orig_sr_pma_mmd_ctl1 = curr_sr_pma_mmd_ctl1;
+		hw->phy.orig_sr_an_mmd_ctl = curr_sr_an_mmd_ctl;
+		hw->phy.orig_sr_an_mmd_adv_reg2 =
+					curr_sr_an_mmd_adv_reg2;
+		hw->phy.orig_vr_xs_or_pcs_mmd_digi_ctl1 =
+					curr_vr_xs_or_pcs_mmd_digi_ctl1;
+	}
+
+	/*make sure phy power is up*/
+	msleep(100);
+
 	/* Store the permanent mac address */
 	wx_get_mac_addr(wxhw, wxhw->mac.perm_addr);
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 36780e7f05b7..1c00ecbc1c6a 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -174,7 +174,9 @@ static void txgbe_reset(struct txgbe_adapter *adapter)
 	int err;
 
 	err = txgbe_reset_hw(hw);
-	if (err != 0)
+	if (err != 0 &&
+	    hw->phy.type != txgbe_phy_sfp_unsupported &&
+	    hw->phy.sfp_type != txgbe_sfp_type_not_present)
 		dev_err(&adapter->pdev->dev, "Hardware Error: %d\n", err);
 
 	/* do not flush user set addresses */
@@ -487,9 +489,19 @@ static int txgbe_probe(struct pci_dev *pdev,
 	}
 
 	err = txgbe_reset_hw(hw);
-	if (err) {
-		dev_err(&pdev->dev, "HW Init failed: %d\n", err);
-		goto err_free_mac_table;
+	if (err != 0) {
+		if (hw->phy.sfp_type == txgbe_sfp_type_not_present) {
+			err = 0;
+		} else if (hw->phy.type == txgbe_phy_sfp_unsupported) {
+			dev_err(&pdev->dev,
+				"An unsupported SFP+ module type was detected.\n");
+			dev_err(&pdev->dev,
+				"Reload the driver after installing a supported module.\n");
+			goto err_free_mac_table;
+		} else {
+			dev_err(&pdev->dev, "HW Init failed: %d\n", err);
+			goto err_free_mac_table;
+		}
 	}
 
 	netdev->features |= NETIF_F_HIGHDMA;
@@ -568,6 +580,15 @@ static int txgbe_probe(struct pci_dev *pdev,
 	err = txgbe_read_pba_string(hw, part_str, TXGBE_PBANUM_LENGTH);
 	if (err)
 		strncpy(part_str, "Unknown", TXGBE_PBANUM_LENGTH);
+	if (hw->phy.media_type == txgbe_media_type_fiber &&
+	    hw->phy.sfp_type != txgbe_sfp_type_not_present)
+		netif_info(adapter, probe, netdev,
+			   "PHY: %d, SFP+: %d, PBA No: %s\n",
+			   hw->phy.type, hw->phy.sfp_type, part_str);
+	else
+		netif_info(adapter, probe, netdev,
+			   "PHY: %d, PBA No: %s\n",
+			   hw->phy.type, part_str);
 
 	netif_info(adapter, probe, netdev, "%pM\n", netdev->dev_addr);
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 740a1c447e20..2f8be0118157 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -53,6 +53,72 @@
 #define TXGBE_TS_CTL                            0x10300
 #define TXGBE_TS_CTL_EVAL_MD                    BIT(31)
 
+/*********************** ETH PHY ***********************/
+#define TXGBE_XPCS_IDA_ADDR                     0x13000
+#define TXGBE_XPCS_IDA_DATA                     0x13004
+/* ETH PHY Registers */
+#define TXGBE_SR_PCS_CTL2                       0x30007
+#define TXGBE_SR_PMA_MMD_CTL1                   0x10000
+#define TXGBE_SR_AN_MMD_CTL                     0x70000
+#define TXGBE_SR_AN_MMD_ADV_REG2                0x70011
+#define TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1        0x38000
+/* I2C registers */
+#define TXGBE_I2C_CON                           0x14900 /* I2C Control */
+#define TXGBE_I2C_CON_SLAVE_DISABLE             BIT(6)
+#define TXGBE_I2C_CON_RESTART_EN                BIT(5)
+#define TXGBE_I2C_CON_SPEED(_v)                 (((_v) & 0x3) << 1)
+#define TXGBE_I2C_CON_MASTER_MODE               BIT(0)
+#define TXGBE_I2C_TAR                           0x14904 /* I2C Target Address */
+#define TXGBE_I2C_DATA_CMD                      0x14910 /* I2C Rx/Tx Data Buf and Cmd */
+#define TXGBE_I2C_DATA_CMD_STOP                 BIT(9)
+#define TXGBE_I2C_DATA_CMD_READ                 (BIT(8) | TXGBE_I2C_DATA_CMD_STOP)
+#define TXGBE_I2C_SS_SCL_HCNT                   0x14914
+#define TXGBE_I2C_SS_SCL_LCNT                   0x14918
+#define TXGBE_I2C_INTR_MASK                     0x14930 /* I2C Interrupt Mask */
+#define TXGBE_I2C_RAW_INTR_STAT                 0x14934 /* I2C Raw Interrupt Status */
+#define TXGBE_I2C_INTR_STAT_RFUL                BIT(2)
+#define TXGBE_I2C_INTR_STAT_TEMP                BIT(4)
+#define TXGBE_I2C_RX_TL                         0x14938 /* I2C Receive FIFO Threshold */
+#define TXGBE_I2C_TX_TL                         0x1493C /* I2C TX FIFO Threshold */
+#define TXGBE_I2C_ENABLE                        0x1496C /* I2C Enable */
+#define TXGBE_I2C_SCL_STUCK_TIMEOUT             0x149AC
+#define TXGBE_I2C_SDA_STUCK_TIMEOUT             0x149B0
+
+#define TXGBE_I2C_SLAVE_ADDR                    (0xA0 >> 1)
+#define TXGBE_I2C_EEPROM_DEV_ADDR               0xA0
+
+/* EEPROM byte offsets */
+#define TXGBE_SFF_IDENTIFIER                    0x0
+#define TXGBE_SFF_IDENTIFIER_SFP                0x3
+#define TXGBE_SFF_VENDOR_OUI_BYTE0              0x25
+#define TXGBE_SFF_VENDOR_OUI_BYTE1              0x26
+#define TXGBE_SFF_VENDOR_OUI_BYTE2              0x27
+#define TXGBE_SFF_1GBE_COMP_CODES               0x6
+#define TXGBE_SFF_10GBE_COMP_CODES              0x3
+#define TXGBE_SFF_CABLE_TECHNOLOGY              0x8
+#define TXGBE_SFF_CABLE_SPEC_COMP               0x3C
+
+/* Bitmasks */
+#define TXGBE_SFF_DA_PASSIVE_CABLE              BIT(2)
+#define TXGBE_SFF_DA_ACTIVE_CABLE               BIT(3)
+#define TXGBE_SFF_DA_SPEC_ACTIVE_LIMITING       BIT(2)
+#define TXGBE_SFF_1GBASESX_CAPABLE              BIT(0)
+#define TXGBE_SFF_1GBASELX_CAPABLE              BIT(1)
+#define TXGBE_SFF_1GBASET_CAPABLE               BIT(3)
+#define TXGBE_SFF_10GBASESR_CAPABLE             BIT(4)
+#define TXGBE_SFF_10GBASELR_CAPABLE             BIT(5)
+
+/* Bit-shift macros */
+#define TXGBE_SFF_VENDOR_OUI_BYTE0_SHIFT        24
+#define TXGBE_SFF_VENDOR_OUI_BYTE1_SHIFT        16
+#define TXGBE_SFF_VENDOR_OUI_BYTE2_SHIFT        8
+
+/* Vendor OUIs: format of OUI is 0x[byte0][byte1][byte2][00] */
+#define TXGBE_SFF_VENDOR_OUI_TYCO               0x00407600
+#define TXGBE_SFF_VENDOR_OUI_FTL                0x00906500
+#define TXGBE_SFF_VENDOR_OUI_AVAGO              0x00176A00
+#define TXGBE_SFF_VENDOR_OUI_INTEL              0x001B2100
+
 /* Part Number String Length */
 #define TXGBE_PBANUM_LENGTH                     32
 
@@ -67,8 +133,66 @@
 #define TXGBE_PBANUM1_PTR                       0x06
 #define TXGBE_PBANUM_PTR_GUARD                  0xFAFA
 
+/* SFP+ module type IDs:
+ *
+ * ID   Module Type
+ * =============
+ * 0    SFP_DA_CU
+ * 1    SFP_SR
+ * 2    SFP_LR
+ * 3    SFP_DA_CU_CORE0
+ * 4    SFP_DA_CU_CORE1
+ * 5    SFP_SR/LR_CORE0
+ * 6    SFP_SR/LR_CORE1
+ */
+enum txgbe_sfp_type {
+	txgbe_sfp_type_da_cu_core = 1,
+	txgbe_sfp_type_srlr_core = 2,
+	txgbe_sfp_type_da_act_lmt_core = 3,
+	txgbe_sfp_type_1g_cu_core = 4,
+	txgbe_sfp_type_1g_sx_core = 5,
+	txgbe_sfp_type_1g_lx_core = 6,
+	txgbe_sfp_type_not_present = 0xFFFE,
+	txgbe_sfp_type_unknown = 0xFFFF
+};
+
+enum txgbe_phy_type {
+	txgbe_phy_unknown = 0,
+	txgbe_phy_none,
+	txgbe_phy_sfp_passive_tyco,
+	txgbe_phy_sfp_passive_unknown,
+	txgbe_phy_sfp_active_unknown,
+	txgbe_phy_sfp_avago,
+	txgbe_phy_sfp_ftl,
+	txgbe_phy_sfp_ftl_active,
+	txgbe_phy_sfp_unknown,
+	txgbe_phy_sfp_intel,
+	txgbe_phy_sfp_unsupported
+};
+
+enum txgbe_media_type {
+	txgbe_media_type_unknown = 0,
+	txgbe_media_type_fiber,
+	txgbe_media_type_copper,
+	txgbe_media_type_backplane
+};
+
+struct txgbe_phy_info {
+	enum txgbe_sfp_type sfp_type;
+	enum txgbe_phy_type type;
+	enum txgbe_media_type media_type;
+	u32 orig_sr_pcs_ctl2;
+	u32 orig_sr_pma_mmd_ctl1;
+	u32 orig_sr_an_mmd_ctl;
+	u32 orig_sr_an_mmd_adv_reg2;
+	u32 orig_vr_xs_or_pcs_mmd_digi_ctl1;
+	bool orig_link_settings_stored;
+	bool multispeed_fiber;
+};
+
 struct txgbe_hw {
 	struct wx_hw wxhw;
+	struct txgbe_phy_info phy;
 };
 
 #endif /* _TXGBE_TYPE_H_ */
-- 
2.38.1

