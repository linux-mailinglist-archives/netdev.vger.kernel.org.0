Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00975A5C74
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiH3HGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbiH3HFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:05:46 -0400
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832D080530
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:05:37 -0700 (PDT)
X-QQ-mid: bizesmtp76t1661843133tlv6bjqn
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 30 Aug 2022 15:05:32 +0800 (CST)
X-QQ-SSF: 01400000000000G0T000B00A0000000
X-QQ-FEAT: LE7C6P2vL8Q9YXHpDq6w9Pf1KerU/gENcYYRCbK+2rlqHSOrAu9ykGI0UkaKC
        P/J2BCrydMXnzuuTp929OIRdeIq2JBiIefLFvc6BCqZv9Rf5f7c0kRa1BqmJImXBugqbpCR
        GrdbPFw6NbimJGdaU4jYI2yJyFaKFcbqthZ4F/xLSGnd13QGhaqHldEWKCHgiZ8RZnVVGTU
        RSAMhNSeYEKtKEVIPz39o2socXLK2gMOCjjv+Ynrt3Lo40GmbxTgFL87uzvtnQLsGkHj5bR
        wd23HU4tJQ8uf5Tygi29stMvrywK9+aFsgevOuVh0kTYx300qGQ56Lxawt+Fd5j/NXQvVxd
        wRSCpHOsJDLfXAq1yLDcOyIZ1SBggUfgYR49uPSMtSpiGkSA9dDhe+vZRchv3IHXp2PO6VO
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v2 05/16] net: txgbe: Identify PHY and SFP module
Date:   Tue, 30 Aug 2022 15:04:43 +0800
Message-Id: <20220830070454.146211-6-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220830070454.146211-1-jiawenwu@trustnetic.com>
References: <20220830070454.146211-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add to get media type and physical layer module, support I2C access.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 .../device_drivers/ethernet/wangxun/txgbe.rst |  38 ++
 drivers/net/ethernet/wangxun/txgbe/Makefile   |   2 +-
 .../net/ethernet/wangxun/txgbe/txgbe_dummy.h  |  36 ++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 164 ++++++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   6 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  41 +-
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 365 ++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_phy.h    |  52 +++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   | 172 +++++++++
 9 files changed, 871 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h

diff --git a/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst b/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
index eaa87dbe8848..037d8538e848 100644
--- a/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
+++ b/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
@@ -11,9 +11,47 @@ Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd.
 Contents
 ========
 
+- Identifying Your Adapter
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
+| Avago	   | SFP+                 | AFBR-709SMZ          |
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
diff --git a/drivers/net/ethernet/wangxun/txgbe/Makefile b/drivers/net/ethernet/wangxun/txgbe/Makefile
index 78484c58b78b..875704a29c4c 100644
--- a/drivers/net/ethernet/wangxun/txgbe/Makefile
+++ b/drivers/net/ethernet/wangxun/txgbe/Makefile
@@ -7,4 +7,4 @@
 obj-$(CONFIG_TXGBE) += txgbe.o
 
 txgbe-objs := txgbe_main.o \
-              txgbe_hw.o
+              txgbe_hw.o txgbe_phy.o
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
index 51d4f9be1071..de96f5fbf014 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
@@ -18,6 +18,34 @@
 #define TUP3 TUP(p3)
 #define TUP4 TUP(p4)
 
+/* struct txgbe_phy_operations */
+static int txgbe_read_i2c_byte_dummy(struct txgbe_hw *TUP0, u8 TUP1,
+				     u8 TUP2, u8 *TUP3)
+{
+	return -EPERM;
+}
+
+static int txgbe_read_i2c_eeprom_dummy(struct txgbe_hw *TUP0,
+				       u8 TUP1, u8 *TUP2)
+{
+	return -EPERM;
+}
+
+static int txgbe_identify_module_dummy(struct txgbe_hw *TUP0)
+{
+	return -EPERM;
+}
+
+static int txgbe_identify_phy_dummy(struct txgbe_hw *TUP0)
+{
+	return -EPERM;
+}
+
+static int txgbe_init_phy_ops_dummy(struct txgbe_hw *TUP0)
+{
+	return -EPERM;
+}
+
 /* struct txgbe_mac_operations */
 static int txgbe_init_hw_dummy(struct txgbe_hw *TUP0)
 {
@@ -133,6 +161,14 @@ static void txgbe_init_ops_dummy(struct txgbe_hw *hw)
 {
 	struct txgbe_eeprom_info *eeprom = &hw->eeprom;
 	struct txgbe_mac_info *mac = &hw->mac;
+	struct txgbe_phy_info *phy = &hw->phy;
+
+	/* PHY */
+	phy->ops.read_i2c_byte = txgbe_read_i2c_byte_dummy;
+	phy->ops.read_i2c_eeprom = txgbe_read_i2c_eeprom_dummy;
+	phy->ops.identify_sfp = txgbe_identify_module_dummy;
+	phy->ops.identify = txgbe_identify_phy_dummy;
+	phy->ops.init = txgbe_init_phy_ops_dummy;
 
 	/* MAC */
 	mac->ops.init_hw = txgbe_init_hw_dummy;
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index 1b386570fb34..89736857d2fd 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd. */
 
 #include "txgbe_type.h"
+#include "txgbe_phy.h"
 #include "txgbe_hw.h"
 #include "txgbe.h"
 
@@ -12,6 +13,22 @@
 static int txgbe_get_eeprom_semaphore(struct txgbe_hw *hw);
 static void txgbe_release_eeprom_semaphore(struct txgbe_hw *hw);
 
+u32 txgbe_rd32_epcs(struct txgbe_hw *hw, u32 addr)
+{
+	unsigned int offset;
+	u32 data;
+	/* Set the LAN port indicator to offset[1] */
+	/* 1st, write the offset to IDA_ADDR register */
+	offset = TXGBE_XPCS_IDA_ADDR;
+	wr32(hw, offset, addr);
+
+	/* 2nd, read the data from IDA_DATA register */
+	offset = TXGBE_XPCS_IDA_DATA;
+	data = rd32(hw, offset);
+
+	return data;
+}
+
 int txgbe_init_hw(struct txgbe_hw *hw)
 {
 	int status;
@@ -1115,6 +1132,23 @@ int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit)
 	return err;
 }
 
+/**
+ *  txgbe_init_phy_ops - PHY/SFP specific init
+ *  @hw: pointer to hardware structure
+ *
+ *  Perform the SFP init if necessary.
+ **/
+int txgbe_init_phy_ops(struct txgbe_hw *hw)
+{
+	int ret_val = 0;
+
+	txgbe_init_i2c(hw);
+	/* Identify the PHY or SFP module */
+	ret_val = hw->phy.ops.identify(hw);
+
+	return ret_val;
+}
+
 /**
  *  txgbe_init_ops - Inits func ptrs
  *  @hw: pointer to hardware structure
@@ -1126,6 +1160,14 @@ void txgbe_init_ops(struct txgbe_hw *hw)
 {
 	struct txgbe_eeprom_info *eeprom = &hw->eeprom;
 	struct txgbe_mac_info *mac = &hw->mac;
+	struct txgbe_phy_info *phy = &hw->phy;
+
+	/* PHY */
+	phy->ops.read_i2c_byte = txgbe_read_i2c_byte;
+	phy->ops.read_i2c_eeprom = txgbe_read_i2c_eeprom;
+	phy->ops.identify_sfp = txgbe_identify_module;
+	phy->ops.identify = txgbe_identify_phy;
+	phy->ops.init = txgbe_init_phy_ops;
 
 	/* MAC */
 	mac->ops.init_hw = txgbe_init_hw;
@@ -1164,10 +1206,51 @@ void txgbe_init_ops(struct txgbe_hw *hw)
 	mac->ops.init_thermal_sensor_thresh = txgbe_init_thermal_sensor_thresh;
 }
 
+/**
+ *  txgbe_get_media_type - Get media type
+ *  @hw: pointer to hardware structure
+ *
+ *  Returns the media type (fiber, copper, backplane)
+ **/
+enum txgbe_media_type txgbe_get_media_type(struct txgbe_hw *hw)
+{
+	u8 device_type = hw->subsystem_device_id & 0xF0;
+	enum txgbe_media_type media_type;
+
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
+		if (hw->bus.lan_id == 0)
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
 void txgbe_reset_misc(struct txgbe_hw *hw)
 {
 	int i;
 
+	txgbe_init_i2c(hw);
+
 	/* receive packets that size > 2048 */
 	wr32m(hw, TXGBE_MAC_RX_CFG,
 	      TXGBE_MAC_RX_CFG_JE, TXGBE_MAC_RX_CFG_JE);
@@ -1219,11 +1302,30 @@ int txgbe_reset_hw(struct txgbe_hw *hw)
 	u32 reset = 0;
 	int status;
 
+	u32 sr_pcs_ctl, sr_pma_mmd_ctl1, sr_an_mmd_ctl, sr_an_mmd_adv_reg2;
+	u32 vr_xs_or_pcs_mmd_digi_ctl1, curr_vr_xs_or_pcs_mmd_digi_ctl1;
+	u32 curr_sr_an_mmd_ctl, curr_sr_an_mmd_adv_reg2;
+	u32 curr_sr_pcs_ctl, curr_sr_pma_mmd_ctl1;
+
 	/* Call adapter stop to disable tx/rx and clear interrupts */
 	status = hw->mac.ops.stop_adapter(hw);
 	if (status != 0)
 		return status;
 
+	/* Identify PHY and related function pointers */
+	status = hw->phy.ops.init(hw);
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
 	if (txgbe_mng_present(hw)) {
 		if (!(((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP) ||
 		      ((hw->subsystem_device_id & TXGBE_WOL_MASK) == TXGBE_WOL_SUP))) {
@@ -1251,6 +1353,38 @@ int txgbe_reset_hw(struct txgbe_hw *hw)
 
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
+	if (!hw->mac.orig_link_settings_stored) {
+		hw->mac.orig_sr_pcs_ctl2 = sr_pcs_ctl;
+		hw->mac.orig_sr_pma_mmd_ctl1 = sr_pma_mmd_ctl1;
+		hw->mac.orig_sr_an_mmd_ctl = sr_an_mmd_ctl;
+		hw->mac.orig_sr_an_mmd_adv_reg2 = sr_an_mmd_adv_reg2;
+		hw->mac.orig_vr_xs_or_pcs_mmd_digi_ctl1 =
+						vr_xs_or_pcs_mmd_digi_ctl1;
+		hw->mac.orig_link_settings_stored = true;
+	} else {
+		hw->mac.orig_sr_pcs_ctl2 = curr_sr_pcs_ctl;
+		hw->mac.orig_sr_pma_mmd_ctl1 = curr_sr_pma_mmd_ctl1;
+		hw->mac.orig_sr_an_mmd_ctl = curr_sr_an_mmd_ctl;
+		hw->mac.orig_sr_an_mmd_adv_reg2 =
+					curr_sr_an_mmd_adv_reg2;
+		hw->mac.orig_vr_xs_or_pcs_mmd_digi_ctl1 =
+					curr_vr_xs_or_pcs_mmd_digi_ctl1;
+	}
+
+	/*make sure phy power is up*/
+	msleep(100);
+
 	/* Store the permanent mac address */
 	hw->mac.ops.get_mac_addr(hw, hw->mac.perm_addr);
 
@@ -1298,6 +1432,9 @@ void txgbe_start_hw(struct txgbe_hw *hw)
 {
 	u32 i;
 
+	/* Set the media type */
+	hw->phy.media_type = txgbe_get_media_type(hw);
+
 	/* Clear the rate limiters */
 	for (i = 0; i < hw->mac.max_tx_queues; i++) {
 		wr32(hw, TXGBE_TDM_RP_IDX, i);
@@ -1312,6 +1449,33 @@ void txgbe_start_hw(struct txgbe_hw *hw)
 	hw->mac.autotry_restart = true;
 }
 
+/**
+ *  txgbe_identify_phy - Get physical layer module
+ *  @hw: pointer to hardware structure
+ *
+ *  Determines the physical layer module found on the current adapter.
+ *  If PHY already detected, maintains current PHY type in hw struct,
+ *  otherwise executes the PHY detection routine.
+ **/
+int txgbe_identify_phy(struct txgbe_hw *hw)
+{
+	int status;
+
+	if (!hw->phy.phy_semaphore_mask)
+		hw->phy.phy_semaphore_mask = TXGBE_MNG_SWFW_SYNC_SW_PHY;
+
+	/* Detect PHY if not unknown - returns success if already detected. */
+	hw->phy.media_type = txgbe_get_media_type(hw);
+	if (hw->phy.media_type == txgbe_media_type_fiber) {
+		status = txgbe_identify_module(hw);
+	} else {
+		hw->phy.type = txgbe_phy_none;
+		status = 0;
+	}
+
+	return status;
+}
+
 /**
  *  txgbe_init_eeprom_params - Initialize EEPROM params
  *  @hw: pointer to hardware structure
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index 7a37de43af62..77fc3ac38351 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -56,8 +56,11 @@ void txgbe_init_thermal_sensor_thresh(struct txgbe_hw *hw);
 void txgbe_disable_rx(struct txgbe_hw *hw);
 int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit);
 
+enum txgbe_media_type txgbe_get_media_type(struct txgbe_hw *hw);
 void txgbe_reset_misc(struct txgbe_hw *hw);
 int txgbe_reset_hw(struct txgbe_hw *hw);
+int txgbe_identify_phy(struct txgbe_hw *hw);
+int txgbe_init_phy_ops(struct txgbe_hw *hw);
 void txgbe_init_ops(struct txgbe_hw *hw);
 
 void txgbe_init_eeprom_params(struct txgbe_hw *hw);
@@ -68,6 +71,9 @@ int txgbe_read_ee_hostif_buffer(struct txgbe_hw *hw,
 				u16 offset, u16 words, u16 *data);
 int txgbe_read_ee_hostif_data(struct txgbe_hw *hw, u16 offset, u16 *data);
 int txgbe_read_ee_hostif(struct txgbe_hw *hw, u16 offset, u16 *data);
+u32 txgbe_rd32_epcs(struct txgbe_hw *hw, u32 addr);
+void txgbe_wr32_epcs(struct txgbe_hw *hw, u32 addr, u32 data);
+void txgbe_wr32_ephy(struct txgbe_hw *hw, u32 addr, u32 data);
 
 int txgbe_fmgr_cmd_op(struct txgbe_hw *hw, u32 cmd, u32 cmd_addr);
 int txgbe_flash_read_dword(struct txgbe_hw *hw, u32 addr, u32 *data);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index c50c67a95974..25764d76dea6 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -11,6 +11,7 @@
 
 #include "txgbe.h"
 #include "txgbe_hw.h"
+#include "txgbe_phy.h"
 #include "txgbe_dummy.h"
 
 char txgbe_driver_name[] = "txgbe";
@@ -32,6 +33,8 @@ static const struct pci_device_id txgbe_pci_tbl[] = {
 
 #define DEFAULT_DEBUG_LEVEL_SHIFT 3
 
+static bool txgbe_is_sfp(struct txgbe_hw *hw);
+
 static void txgbe_check_minimum_link(struct txgbe_adapter *adapter)
 {
 	struct pci_dev *pdev;
@@ -169,6 +172,16 @@ int txgbe_del_mac_filter(struct txgbe_adapter *adapter, u8 *addr, u16 pool)
 	return -ENOMEM;
 }
 
+static bool txgbe_is_sfp(struct txgbe_hw *hw)
+{
+	switch (hw->phy.media_type) {
+	case txgbe_media_type_fiber:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static void txgbe_up_complete(struct txgbe_adapter *adapter)
 {
 	txgbe_get_hw_control(adapter);
@@ -182,7 +195,9 @@ void txgbe_reset(struct txgbe_adapter *adapter)
 	int err;
 
 	err = hw->mac.ops.init_hw(hw);
-	if (err != 0)
+	if (err != 0 &&
+	    hw->phy.sfp_type != txgbe_sfp_type_not_present &&
+	    hw->phy.type != txgbe_phy_sfp_unsupported)
 		dev_err(&adapter->pdev->dev, "Hardware Error: %d\n", err);
 
 	/* do not flush user set addresses */
@@ -544,9 +559,19 @@ static int txgbe_probe(struct pci_dev *pdev,
 		goto err_free_mac_table;
 
 	err = hw->mac.ops.reset_hw(hw);
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
@@ -639,6 +664,14 @@ static int txgbe_probe(struct pci_dev *pdev,
 	err = txgbe_read_pba_string(hw, part_str, TXGBE_PBANUM_LENGTH);
 	if (err)
 		strncpy(part_str, "Unknown", TXGBE_PBANUM_LENGTH);
+	if (txgbe_is_sfp(hw) && hw->phy.sfp_type != txgbe_sfp_type_not_present)
+		netif_info(adapter, probe, netdev,
+			   "PHY: %d, SFP+: %d, PBA No: %s\n",
+			   hw->phy.type, hw->phy.sfp_type, part_str);
+	else
+		netif_info(adapter, probe, netdev,
+			   "PHY: %d, PBA No: %s\n",
+			   hw->phy.type, part_str);
 
 	netif_info(adapter, probe, netdev, "%02x:%02x:%02x:%02x:%02x:%02x\n",
 		   netdev->dev_addr[0], netdev->dev_addr[1],
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
new file mode 100644
index 000000000000..426b1ee9050a
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -0,0 +1,365 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd. */
+
+#include "txgbe_phy.h"
+
+/**
+ *  txgbe_identify_module - Identifies module type
+ *  @hw: pointer to hardware structure
+ *
+ *  Determines HW type and calls appropriate function.
+ **/
+int txgbe_identify_module(struct txgbe_hw *hw)
+{
+	int status;
+
+	switch (hw->phy.media_type) {
+	case txgbe_media_type_fiber:
+		status = txgbe_identify_sfp_module(hw);
+		break;
+	default:
+		hw->phy.sfp_type = txgbe_sfp_type_not_present;
+		status = -ENODEV;
+		break;
+	}
+
+	return status;
+}
+
+/**
+ *  txgbe_identify_sfp_module - Identifies SFP modules
+ *  @hw: pointer to hardware structure
+ *
+ *  Searches for and identifies the SFP module and assigns appropriate PHY type.
+ **/
+int txgbe_identify_sfp_module(struct txgbe_hw *hw)
+{
+	int status = -EFAULT;
+	u8 oui_bytes[3] = {0, 0, 0};
+	u8 comp_codes_10g = 0;
+	u8 comp_codes_1g = 0;
+	u32 vendor_oui = 0;
+	u8 identifier = 0;
+	u8 cable_tech = 0;
+	u8 cable_spec = 0;
+
+	/* LAN ID is needed for I2C access */
+	txgbe_init_i2c(hw);
+	status = hw->phy.ops.read_i2c_eeprom(hw,
+					     TXGBE_SFF_IDENTIFIER,
+					     &identifier);
+
+	if (status != 0)
+		goto err_read_i2c_eeprom;
+
+	if (identifier != TXGBE_SFF_IDENTIFIER_SFP) {
+		hw->phy.type = txgbe_phy_sfp_unsupported;
+		status = -ENODEV;
+	} else {
+		status = hw->phy.ops.read_i2c_eeprom(hw,
+						     TXGBE_SFF_1GBE_COMP_CODES,
+						     &comp_codes_1g);
+
+		if (status != 0)
+			goto err_read_i2c_eeprom;
+
+		status = hw->phy.ops.read_i2c_eeprom(hw,
+						     TXGBE_SFF_10GBE_COMP_CODES,
+						     &comp_codes_10g);
+
+		if (status != 0)
+			goto err_read_i2c_eeprom;
+		status = hw->phy.ops.read_i2c_eeprom(hw,
+						     TXGBE_SFF_CABLE_TECHNOLOGY,
+						     &cable_tech);
+
+		if (status != 0)
+			goto err_read_i2c_eeprom;
+
+		 /* ID Module
+		  * =========
+		  * 0   SFP_DA_CU
+		  * 1   SFP_SR
+		  * 2   SFP_LR
+		  * 3   SFP_DA_CORE0
+		  * 4   SFP_DA_CORE1
+		  * 5   SFP_SR/LR_CORE0
+		  * 6   SFP_SR/LR_CORE1
+		  * 7   SFP_act_lmt_DA_CORE0
+		  * 8   SFP_act_lmt_DA_CORE1
+		  * 9   SFP_1g_cu_CORE0
+		  * 10  SFP_1g_cu_CORE1
+		  * 11  SFP_1g_sx_CORE0
+		  * 12  SFP_1g_sx_CORE1
+		  */
+
+		if (cable_tech & TXGBE_SFF_DA_PASSIVE_CABLE) {
+			if (hw->bus.lan_id == 0)
+				hw->phy.sfp_type =
+					     txgbe_sfp_type_da_cu_core0;
+			else
+				hw->phy.sfp_type =
+					     txgbe_sfp_type_da_cu_core1;
+		} else if (cable_tech & TXGBE_SFF_DA_ACTIVE_CABLE) {
+			hw->phy.ops.read_i2c_eeprom(hw,
+						    TXGBE_SFF_CABLE_SPEC_COMP,
+						    &cable_spec);
+			if (cable_spec &
+			    TXGBE_SFF_DA_SPEC_ACTIVE_LIMITING) {
+				if (hw->bus.lan_id == 0)
+					hw->phy.sfp_type =
+					txgbe_sfp_type_da_act_lmt_core0;
+				else
+					hw->phy.sfp_type =
+					txgbe_sfp_type_da_act_lmt_core1;
+			} else {
+				hw->phy.sfp_type =
+						txgbe_sfp_type_unknown;
+			}
+		} else if (comp_codes_10g &
+			   (TXGBE_SFF_10GBASESR_CAPABLE |
+			    TXGBE_SFF_10GBASELR_CAPABLE)) {
+			if (hw->bus.lan_id == 0)
+				hw->phy.sfp_type =
+					      txgbe_sfp_type_srlr_core0;
+			else
+				hw->phy.sfp_type =
+					      txgbe_sfp_type_srlr_core1;
+		} else if (comp_codes_1g & TXGBE_SFF_1GBASET_CAPABLE) {
+			if (hw->bus.lan_id == 0)
+				hw->phy.sfp_type =
+					txgbe_sfp_type_1g_cu_core0;
+			else
+				hw->phy.sfp_type =
+					txgbe_sfp_type_1g_cu_core1;
+		} else if (comp_codes_1g & TXGBE_SFF_1GBASESX_CAPABLE) {
+			if (hw->bus.lan_id == 0)
+				hw->phy.sfp_type =
+					txgbe_sfp_type_1g_sx_core0;
+			else
+				hw->phy.sfp_type =
+					txgbe_sfp_type_1g_sx_core1;
+		} else if (comp_codes_1g & TXGBE_SFF_1GBASELX_CAPABLE) {
+			if (hw->bus.lan_id == 0)
+				hw->phy.sfp_type =
+					txgbe_sfp_type_1g_lx_core0;
+			else
+				hw->phy.sfp_type =
+					txgbe_sfp_type_1g_lx_core1;
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
+		if (hw->phy.type != txgbe_phy_nl) {
+			status = hw->phy.ops.read_i2c_eeprom(hw,
+							     TXGBE_SFF_VENDOR_OUI_BYTE0,
+							     &oui_bytes[0]);
+
+			if (status != 0)
+				goto err_read_i2c_eeprom;
+
+			status = hw->phy.ops.read_i2c_eeprom(hw,
+							     TXGBE_SFF_VENDOR_OUI_BYTE1,
+							     &oui_bytes[1]);
+
+			if (status != 0)
+				goto err_read_i2c_eeprom;
+
+			status = hw->phy.ops.read_i2c_eeprom(hw,
+							     TXGBE_SFF_VENDOR_OUI_BYTE2,
+							     &oui_bytes[2]);
+
+			if (status != 0)
+				goto err_read_i2c_eeprom;
+
+			vendor_oui =
+			  ((oui_bytes[0] << TXGBE_SFF_VENDOR_OUI_BYTE0_SHIFT) |
+			   (oui_bytes[1] << TXGBE_SFF_VENDOR_OUI_BYTE1_SHIFT) |
+			   (oui_bytes[2] << TXGBE_SFF_VENDOR_OUI_BYTE2_SHIFT));
+
+			switch (vendor_oui) {
+			case TXGBE_SFF_VENDOR_OUI_TYCO:
+				if (cable_tech & TXGBE_SFF_DA_PASSIVE_CABLE)
+					hw->phy.type =
+						    txgbe_phy_sfp_passive_tyco;
+				break;
+			case TXGBE_SFF_VENDOR_OUI_FTL:
+				if (cable_tech & TXGBE_SFF_DA_ACTIVE_CABLE)
+					hw->phy.type = txgbe_phy_sfp_ftl_active;
+				else
+					hw->phy.type = txgbe_phy_sfp_ftl;
+				break;
+			case TXGBE_SFF_VENDOR_OUI_AVAGO:
+				hw->phy.type = txgbe_phy_sfp_avago;
+				break;
+			case TXGBE_SFF_VENDOR_OUI_INTEL:
+				hw->phy.type = txgbe_phy_sfp_intel;
+				break;
+			default:
+				if (cable_tech & TXGBE_SFF_DA_PASSIVE_CABLE)
+					hw->phy.type =
+						 txgbe_phy_sfp_passive_unknown;
+				else if (cable_tech & TXGBE_SFF_DA_ACTIVE_CABLE)
+					hw->phy.type =
+						txgbe_phy_sfp_active_unknown;
+				else
+					hw->phy.type = txgbe_phy_sfp_unknown;
+				break;
+			}
+		}
+
+		/* Allow any DA cable vendor */
+		if (cable_tech & (TXGBE_SFF_DA_PASSIVE_CABLE |
+		    TXGBE_SFF_DA_ACTIVE_CABLE)) {
+			status = 0;
+			goto out;
+		}
+
+		/* Verify supported 1G SFP modules */
+		if (comp_codes_10g == 0 &&
+		    !(hw->phy.sfp_type == txgbe_sfp_type_1g_cu_core1 ||
+		      hw->phy.sfp_type == txgbe_sfp_type_1g_cu_core0 ||
+		      hw->phy.sfp_type == txgbe_sfp_type_1g_lx_core0 ||
+		      hw->phy.sfp_type == txgbe_sfp_type_1g_lx_core1 ||
+		      hw->phy.sfp_type == txgbe_sfp_type_1g_sx_core0 ||
+		      hw->phy.sfp_type == txgbe_sfp_type_1g_sx_core1)) {
+			hw->phy.type = txgbe_phy_sfp_unsupported;
+			status = -ENODEV;
+			goto out;
+		}
+	}
+
+out:
+	return status;
+
+err_read_i2c_eeprom:
+	hw->phy.sfp_type = txgbe_sfp_type_not_present;
+	if (hw->phy.type != txgbe_phy_nl)
+		hw->phy.type = txgbe_phy_unknown;
+
+	return -ENODEV;
+}
+
+void txgbe_init_i2c(struct txgbe_hw *hw)
+{
+	wr32(hw, TXGBE_I2C_ENABLE, 0);
+
+	wr32(hw, TXGBE_I2C_CON,
+	     (TXGBE_I2C_CON_MASTER_MODE |
+	      TXGBE_I2C_CON_SPEED(1) |
+	      TXGBE_I2C_CON_RESTART_EN |
+	      TXGBE_I2C_CON_SLAVE_DISABLE));
+	/* Default addr is 0xA0 ,bit 0 is configure for read/write! */
+	wr32(hw, TXGBE_I2C_TAR, TXGBE_I2C_SLAVE_ADDR);
+	wr32(hw, TXGBE_I2C_SS_SCL_HCNT, 600);
+	wr32(hw, TXGBE_I2C_SS_SCL_LCNT, 600);
+	wr32(hw, TXGBE_I2C_RX_TL, 0); /* 1byte for rx full signal */
+	wr32(hw, TXGBE_I2C_TX_TL, 4);
+	wr32(hw, TXGBE_I2C_SCL_STUCK_TIMEOUT, 0xFFFFFF);
+	wr32(hw, TXGBE_I2C_SDA_STUCK_TIMEOUT, 0xFFFFFF);
+
+	wr32(hw, TXGBE_I2C_INTR_MASK, 0);
+	wr32(hw, TXGBE_I2C_ENABLE, 1);
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
+int txgbe_read_i2c_eeprom(struct txgbe_hw *hw, u8 byte_offset,
+			  u8 *eeprom_data)
+{
+	return hw->phy.ops.read_i2c_byte(hw, byte_offset,
+					 TXGBE_I2C_EEPROM_DEV_ADDR,
+					 eeprom_data);
+}
+
+/**
+ *  txgbe_read_i2c_byte_int - Reads 8 bit word over I2C
+ *  @hw: pointer to hardware structure
+ *  @byte_offset: byte offset to read
+ *  @dev_addr: device address
+ *  @data: value read
+ *
+ *  Performs byte read operation to SFP module's EEPROM over I2C interface at
+ *  a specified device address.
+ **/
+static int txgbe_read_i2c_byte_int(struct txgbe_hw *hw, u8 byte_offset,
+				   u8 __maybe_unused dev_addr, u8 *data)
+{
+	u32 swfw_mask = hw->phy.phy_semaphore_mask;
+	int status = 0;
+	u32 val;
+
+	status = hw->mac.ops.acquire_swfw_sync(hw, swfw_mask);
+	if (status != 0)
+		return status;
+
+	/* wait tx empty */
+	status = read_poll_timeout(rd32, val,
+				   (val & TXGBE_I2C_INTR_STAT_TEMP) == TXGBE_I2C_INTR_STAT_TEMP,
+				   100, 1000, false, hw, TXGBE_I2C_RAW_INTR_STAT);
+	if (status != 0)
+		goto out;
+
+	/* read data */
+	wr32(hw, TXGBE_I2C_DATA_CMD,
+	     byte_offset | TXGBE_I2C_DATA_CMD_STOP);
+	wr32(hw, TXGBE_I2C_DATA_CMD, TXGBE_I2C_DATA_CMD_READ);
+
+	/* wait for read complete */
+	status = read_poll_timeout(rd32, val,
+				   (val & TXGBE_I2C_INTR_STAT_RFUL) == TXGBE_I2C_INTR_STAT_RFUL,
+				   100, 1000, false, hw, TXGBE_I2C_RAW_INTR_STAT);
+	if (status != 0)
+		goto out;
+
+	*data = 0xFF & rd32(hw, TXGBE_I2C_DATA_CMD);
+
+out:
+	hw->mac.ops.release_swfw_sync(hw, swfw_mask);
+	return status;
+}
+
+/**
+ *  txgbe_switch_i2c_slave_addr - Switch I2C slave address
+ *  @hw: pointer to hardware structure
+ *  @dev_addr: slave addr to switch
+ **/
+void txgbe_switch_i2c_slave_addr(struct txgbe_hw *hw, u8 dev_addr)
+{
+	wr32(hw, TXGBE_I2C_ENABLE, 0);
+	wr32(hw, TXGBE_I2C_TAR, dev_addr >> 1);
+	wr32(hw, TXGBE_I2C_ENABLE, 1);
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
+int txgbe_read_i2c_byte(struct txgbe_hw *hw, u8 byte_offset,
+			u8 dev_addr, u8 *data)
+{
+	txgbe_switch_i2c_slave_addr(hw, dev_addr);
+
+	return txgbe_read_i2c_byte_int(hw, byte_offset, dev_addr, data);
+}
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
new file mode 100644
index 000000000000..509e112c3885
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd. */
+
+#ifndef _TXGBE_PHY_H_
+#define _TXGBE_PHY_H_
+
+#include "txgbe.h"
+
+#define TXGBE_I2C_EEPROM_DEV_ADDR       0xA0
+
+/* EEPROM byte offsets */
+#define TXGBE_SFF_IDENTIFIER            0x0
+#define TXGBE_SFF_IDENTIFIER_SFP        0x3
+#define TXGBE_SFF_VENDOR_OUI_BYTE0      0x25
+#define TXGBE_SFF_VENDOR_OUI_BYTE1      0x26
+#define TXGBE_SFF_VENDOR_OUI_BYTE2      0x27
+#define TXGBE_SFF_1GBE_COMP_CODES       0x6
+#define TXGBE_SFF_10GBE_COMP_CODES      0x3
+#define TXGBE_SFF_CABLE_TECHNOLOGY      0x8
+#define TXGBE_SFF_CABLE_SPEC_COMP       0x3C
+
+/* Bitmasks */
+#define TXGBE_SFF_DA_PASSIVE_CABLE      0x4
+#define TXGBE_SFF_DA_ACTIVE_CABLE       0x8
+#define TXGBE_SFF_DA_SPEC_ACTIVE_LIMITING       0x4
+#define TXGBE_SFF_1GBASESX_CAPABLE      0x1
+#define TXGBE_SFF_1GBASELX_CAPABLE      0x2
+#define TXGBE_SFF_1GBASET_CAPABLE       0x8
+#define TXGBE_SFF_10GBASESR_CAPABLE     0x10
+#define TXGBE_SFF_10GBASELR_CAPABLE     0x20
+/* Bit-shift macros */
+#define TXGBE_SFF_VENDOR_OUI_BYTE0_SHIFT        24
+#define TXGBE_SFF_VENDOR_OUI_BYTE1_SHIFT        16
+#define TXGBE_SFF_VENDOR_OUI_BYTE2_SHIFT        8
+
+/* Vendor OUIs: format of OUI is 0x[byte0][byte1][byte2][00] */
+#define TXGBE_SFF_VENDOR_OUI_TYCO       0x00407600
+#define TXGBE_SFF_VENDOR_OUI_FTL        0x00906500
+#define TXGBE_SFF_VENDOR_OUI_AVAGO      0x00176A00
+#define TXGBE_SFF_VENDOR_OUI_INTEL      0x001B2100
+
+int txgbe_identify_module(struct txgbe_hw *hw);
+int txgbe_identify_sfp_module(struct txgbe_hw *hw);
+void txgbe_init_i2c(struct txgbe_hw *hw);
+void txgbe_switch_i2c_slave_addr(struct txgbe_hw *hw, u8 dev_addr);
+int txgbe_read_i2c_byte(struct txgbe_hw *hw, u8 byte_offset,
+			u8 dev_addr, u8 *data);
+
+int txgbe_read_i2c_eeprom(struct txgbe_hw *hw, u8 byte_offset,
+			  u8 *eeprom_data);
+
+#endif /* _TXGBE_PHY_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 2fe848a33892..57cd8158e508 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -56,6 +56,25 @@
 /* Revision ID */
 #define TXGBE_SP_MPW  1
 
+/* ETH PHY Registers */
+#define TXGBE_SR_XS_PCS_MMD_STATUS1             0x30001
+#define TXGBE_SR_PCS_CTL2                       0x30007
+#define TXGBE_SR_PMA_MMD_CTL1                   0x10000
+#define TXGBE_SR_AN_MMD_CTL                     0x70000
+#define TXGBE_SR_AN_MMD_ADV_REG1                0x70010
+#define TXGBE_SR_AN_MMD_ADV_REG1_PAUSE(_v)      ((0x3 & (_v)) << 10)
+#define TXGBE_SR_AN_MMD_ADV_REG1_PAUSE_SYM      0x400
+#define TXGBE_SR_AN_MMD_ADV_REG1_PAUSE_ASM      0x800
+#define TXGBE_SR_AN_MMD_ADV_REG2                0x70011
+#define TXGBE_SR_AN_MMD_LP_ABL1                 0x70013
+#define TXGBE_VR_AN_KR_MODE_CL                  0x78003
+#define TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1        0x38000
+#define TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS      0x38010
+
+#define TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_R        0x0
+#define TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_X        0x1
+#define TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_MASK     0x3
+
 /**************** Global Registers ****************************/
 /* chip control Registers */
 #define TXGBE_MIS_RST                   0x1000C
@@ -163,6 +182,66 @@ struct txgbe_thermal_sensor_data {
 #define TXGBE_SPI_ECC_ST                0x10138
 #define TXGBE_SPI_ILDR_SWPTR            0x10124
 
+/************************* Port Registers ************************************/
+/* I2C registers */
+#define TXGBE_I2C_CON                   0x14900 /* I2C Control */
+#define TXGBE_I2C_CON_SLAVE_DISABLE     ((1 << 6))
+#define TXGBE_I2C_CON_RESTART_EN        ((1 << 5))
+#define TXGBE_I2C_CON_10BITADDR_MASTER  ((1 << 4))
+#define TXGBE_I2C_CON_10BITADDR_SLAVE   ((1 << 3))
+#define TXGBE_I2C_CON_SPEED(_v)         (((_v) & 0x3) << 1)
+#define TXGBE_I2C_CON_MASTER_MODE       ((1 << 0))
+#define TXGBE_I2C_TAR                   0x14904 /* I2C Target Address */
+#define TXGBE_I2C_DATA_CMD              0x14910 /* I2C Rx/Tx Data Buf and Cmd */
+#define TXGBE_I2C_DATA_CMD_STOP         ((1 << 9))
+#define TXGBE_I2C_DATA_CMD_READ         ((1 << 8) | TXGBE_I2C_DATA_CMD_STOP)
+#define TXGBE_I2C_DATA_CMD_WRITE        ((0 << 8) | TXGBE_I2C_DATA_CMD_STOP)
+#define TXGBE_I2C_SS_SCL_HCNT           0x14914 /* Standard speed I2C Clock SCL High Count */
+#define TXGBE_I2C_SS_SCL_LCNT           0x14918 /* Standard speed I2C Clock SCL Low Count */
+#define TXGBE_I2C_FS_SCL_HCNT           0x1491C
+#define TXGBE_I2C_FS_SCL_LCNT           0x14920
+#define TXGBE_I2C_HS_SCL_HCNT           0x14924 /* High speed I2C Clock SCL High Count */
+#define TXGBE_I2C_HS_SCL_LCNT           0x14928 /* High speed I2C Clock SCL Low Count */
+#define TXGBE_I2C_INTR_STAT             0x1492C /* I2C Interrupt Status */
+#define TXGBE_I2C_RAW_INTR_STAT         0x14934 /* I2C Raw Interrupt Status */
+#define TXGBE_I2C_INTR_STAT_RFUL        ((0x1) << 2)
+#define TXGBE_I2C_INTR_STAT_TEMP        ((0x1) << 4)
+#define TXGBE_I2C_INTR_MASK             0x14930 /* I2C Interrupt Mask */
+#define TXGBE_I2C_RX_TL                 0x14938 /* I2C Receive FIFO Threshold */
+#define TXGBE_I2C_TX_TL                 0x1493C /* I2C TX FIFO Threshold */
+#define TXGBE_I2C_CLR_INTR              0x14940 /* Clear Combined and Individual Int */
+#define TXGBE_I2C_CLR_RX_UNDER          0x14944 /* Clear RX_UNDER Interrupt */
+#define TXGBE_I2C_CLR_RX_OVER           0x14948 /* Clear RX_OVER Interrupt */
+#define TXGBE_I2C_CLR_TX_OVER           0x1494C /* Clear TX_OVER Interrupt */
+#define TXGBE_I2C_CLR_RD_REQ            0x14950 /* Clear RD_REQ Interrupt */
+#define TXGBE_I2C_CLR_TX_ABRT           0x14954 /* Clear TX_ABRT Interrupt */
+#define TXGBE_I2C_CLR_RX_DONE           0x14958 /* Clear RX_DONE Interrupt */
+#define TXGBE_I2C_CLR_ACTIVITY          0x1495C /* Clear ACTIVITY Interrupt */
+#define TXGBE_I2C_CLR_STOP_DET          0x14960 /* Clear STOP_DET Interrupt */
+#define TXGBE_I2C_CLR_START_DET         0x14964 /* Clear START_DET Interrupt */
+#define TXGBE_I2C_CLR_GEN_CALL          0x14968 /* Clear GEN_CALL Interrupt */
+#define TXGBE_I2C_ENABLE                0x1496C /* I2C Enable */
+#define TXGBE_I2C_STATUS                0x14970 /* I2C Status register */
+#define TXGBE_I2C_STATUS_MST_ACTIVITY   ((1U << 5))
+#define TXGBE_I2C_TXFLR                 0x14974 /* Transmit FIFO Level Reg */
+#define TXGBE_I2C_RXFLR                 0x14978 /* Receive FIFO Level Reg */
+#define TXGBE_I2C_SDA_HOLD              0x1497C /* SDA hold time length reg */
+#define TXGBE_I2C_TX_ABRT_SOURCE        0x14980 /* I2C TX Abort Status Reg */
+#define TXGBE_I2C_SDA_SETUP             0x14994 /* I2C SDA Setup Register */
+#define TXGBE_I2C_ENABLE_STATUS         0x1499C /* I2C Enable Status Register */
+#define TXGBE_I2C_FS_SPKLEN             0x149A0 /* ISS and FS spike suppression limit */
+#define TXGBE_I2C_HS_SPKLEN             0x149A4 /* HS spike suppression limit */
+#define TXGBE_I2C_SCL_STUCK_TIMEOUT     0x149AC /* I2C SCL stuck at low timeout register */
+#define TXGBE_I2C_SDA_STUCK_TIMEOUT     0x149B0 /*I2C SDA Stuck at Low Timeout*/
+#define TXGBE_I2C_CLR_SCL_STUCK_DET     0x149B4 /* Clear SCL Stuck at Low Detect Interrupt */
+#define TXGBE_I2C_DEVICE_ID             0x149b8 /* I2C Device ID */
+#define TXGBE_I2C_COMP_PARAM_1          0x149f4 /* Component Parameter Reg */
+#define TXGBE_I2C_COMP_VERSION          0x149f8 /* Component Version ID */
+#define TXGBE_I2C_COMP_TYPE             0x149fc /* DesignWare Component Type Reg */
+
+#define TXGBE_I2C_SLAVE_ADDR            (0xA0 >> 1)
+#define TXGBE_I2C_THERMAL_SENSOR_ADDR   0xF8
+
 /* port cfg Registers */
 #define TXGBE_CFG_PORT_CTL              0x14400
 #define TXGBE_CFG_PORT_ST               0x14404
@@ -290,6 +369,12 @@ struct txgbe_thermal_sensor_data {
 #define TXGBE_PSR_LAN_FLEX_DW_H(_i)     (0x15C04 + ((_i) * 16))
 #define TXGBE_PSR_LAN_FLEX_MSK(_i)      (0x15C08 + ((_i) * 16))
 #define TXGBE_PSR_LAN_FLEX_CTL  0x15CFC
+/************************************** ETH PHY ******************************/
+#define TXGBE_XPCS_IDA_ADDR    0x13000
+#define TXGBE_XPCS_IDA_DATA    0x13004
+#define TXGBE_ETHPHY_IDA_ADDR  0x13008
+#define TXGBE_ETHPHY_IDA_DATA  0x1300C
+
 /************************************** MNG ********************************/
 #define TXGBE_MNG_FW_SM         0x1E000
 #define TXGBE_MNG_SW_SM         0x1E004
@@ -544,6 +629,67 @@ enum txgbe_eeprom_type {
 	txgbe_eeprom_none /* No NVM support */
 };
 
+enum txgbe_phy_type {
+	txgbe_phy_unknown = 0,
+	txgbe_phy_none,
+	txgbe_phy_tn,
+	txgbe_phy_aq,
+	txgbe_phy_cu_unknown,
+	txgbe_phy_qt,
+	txgbe_phy_xaui,
+	txgbe_phy_nl,
+	txgbe_phy_sfp_passive_tyco,
+	txgbe_phy_sfp_passive_unknown,
+	txgbe_phy_sfp_active_unknown,
+	txgbe_phy_sfp_avago,
+	txgbe_phy_sfp_ftl,
+	txgbe_phy_sfp_ftl_active,
+	txgbe_phy_sfp_unknown,
+	txgbe_phy_sfp_intel,
+	txgbe_phy_sfp_unsupported, /*Enforce bit set with unsupported module*/
+	txgbe_phy_generic
+};
+
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
+	txgbe_sfp_type_da_cu = 0,
+	txgbe_sfp_type_sr = 1,
+	txgbe_sfp_type_lr = 2,
+	txgbe_sfp_type_da_cu_core0 = 3,
+	txgbe_sfp_type_da_cu_core1 = 4,
+	txgbe_sfp_type_srlr_core0 = 5,
+	txgbe_sfp_type_srlr_core1 = 6,
+	txgbe_sfp_type_da_act_lmt_core0 = 7,
+	txgbe_sfp_type_da_act_lmt_core1 = 8,
+	txgbe_sfp_type_1g_cu_core0 = 9,
+	txgbe_sfp_type_1g_cu_core1 = 10,
+	txgbe_sfp_type_1g_sx_core0 = 11,
+	txgbe_sfp_type_1g_sx_core1 = 12,
+	txgbe_sfp_type_1g_lx_core0 = 13,
+	txgbe_sfp_type_1g_lx_core1 = 14,
+	txgbe_sfp_type_not_present = 0xFFFE,
+	txgbe_sfp_type_unknown = 0xFFFF
+};
+
+enum txgbe_media_type {
+	txgbe_media_type_unknown = 0,
+	txgbe_media_type_fiber,
+	txgbe_media_type_copper,
+	txgbe_media_type_backplane,
+	txgbe_media_type_virtual
+};
+
 struct txgbe_addr_filter_info {
 	u32 num_mc_addrs;
 	u32 rar_used_count;
@@ -600,6 +746,16 @@ struct txgbe_mac_operations {
 	void (*init_thermal_sensor_thresh)(struct txgbe_hw *hw);
 };
 
+struct txgbe_phy_operations {
+	int (*identify)(struct txgbe_hw *hw);
+	int (*identify_sfp)(struct txgbe_hw *hw);
+	int (*init)(struct txgbe_hw *hw);
+	int (*read_i2c_byte)(struct txgbe_hw *hw, u8 byte_offset,
+			     u8 dev_addr, u8 *data);
+	int (*read_i2c_eeprom)(struct txgbe_hw *hw, u8 byte_offset,
+			       u8 *eeprom_data);
+};
+
 struct txgbe_eeprom_info {
 	struct txgbe_eeprom_operations ops;
 	enum txgbe_eeprom_type type;
@@ -622,12 +778,27 @@ struct txgbe_mac_info {
 	u32 num_rar_entries;
 	u32 max_tx_queues;
 	u32 max_rx_queues;
+	u32 orig_sr_pcs_ctl2;
+	u32 orig_sr_pma_mmd_ctl1;
+	u32 orig_sr_an_mmd_ctl;
+	u32 orig_sr_an_mmd_adv_reg2;
+	u32 orig_vr_xs_or_pcs_mmd_digi_ctl1;
 	u8  san_mac_rar_index;
+	bool orig_link_settings_stored;
 	bool autotry_restart;
 	struct txgbe_thermal_sensor_data  thermal_sensor_data;
 	bool set_lben;
 };
 
+struct txgbe_phy_info {
+	struct txgbe_phy_operations ops;
+	enum txgbe_phy_type type;
+	enum txgbe_sfp_type sfp_type;
+	enum txgbe_media_type media_type;
+	u32 phy_semaphore_mask;
+	bool multispeed_fiber;
+};
+
 enum txgbe_reset_type {
 	TXGBE_LAN_RESET = 0,
 	TXGBE_SW_RESET,
@@ -638,6 +809,7 @@ struct txgbe_hw {
 	u8 __iomem *hw_addr;
 	struct txgbe_mac_info mac;
 	struct txgbe_addr_filter_info addr_ctrl;
+	struct txgbe_phy_info phy;
 	struct txgbe_eeprom_info eeprom;
 	struct txgbe_bus_info bus;
 	u16 device_id;
-- 
2.27.0

