Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132E9522A53
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 05:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241667AbiEKDTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 23:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239161AbiEKDTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 23:19:46 -0400
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6BA6CAB9
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:19:27 -0700 (PDT)
X-QQ-mid: bizesmtp75t1652239154t8jeuned
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 11 May 2022 11:19:13 +0800 (CST)
X-QQ-SSF: 01400000000000F0O000B00A0000000
X-QQ-FEAT: FXvDfBZI5O77LyAiIZmIriIwugK2vKO2unBfJOFhHPyTBd+THtXM3prW9HoTk
        LvVWfMpAwcLmePLUZnSmXQnAMTxRAtRhON/9b9v/K16u4Q7PgpahXQrAWoxj+Q08oMIGBJ3
        qRQfP8o7CvkV+6NRiS/s70NHG8K01V5rJUWqQo93jxp7VwqqhoVbu4jq8uRRL0Pd+mg8+Qu
        oG6yjVPNiB25iZ0haitYXtN4tu2Qlki1veKCnT8lRco83b+UNU2qAA8V3RMbPvS+E1WkUMS
        zhTFKVtxhRhkaIBD1jpwm4hVWl/RlG2vzgIEmH2my8T4RyZfbRtsjMz/R5GYPO8S6NCqN95
        LIuuspF3llMG1QROvBT+mCodtaSP5gLKwxNu0Ia
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next 04/14] net: txgbe: Add PHY interface support
Date:   Wed, 11 May 2022 11:26:49 +0800
Message-Id: <20220511032659.641834-5-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220511032659.641834-1-jiawenwu@trustnetic.com>
References: <20220511032659.641834-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybgforeign:qybgforeign9
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support to identify PHY and fiber module, setup link and laser control.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/Makefile   |    2 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |   19 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 1755 ++++++++++++++++-
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   36 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  492 ++++-
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    |  401 ++++
 .../net/ethernet/wangxun/txgbe/txgbe_phy.h    |   54 +
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  332 ++++
 8 files changed, 3025 insertions(+), 66 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h

diff --git a/drivers/net/ethernet/wangxun/txgbe/Makefile b/drivers/net/ethernet/wangxun/txgbe/Makefile
index eaf1d46693bc..7dc73b58fe75 100644
--- a/drivers/net/ethernet/wangxun/txgbe/Makefile
+++ b/drivers/net/ethernet/wangxun/txgbe/Makefile
@@ -7,4 +7,4 @@
 obj-$(CONFIG_TXGBE) += txgbe.o
 
 txgbe-objs := txgbe_main.o \
-              txgbe_hw.o
+              txgbe_hw.o txgbe_phy.o
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 4c5de310292f..58a89d43046f 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -38,10 +38,21 @@ struct txgbe_mac_addr {
 #define TXGBE_MAC_STATE_MODIFIED        0x2
 #define TXGBE_MAC_STATE_IN_USE          0x4
 
+/* default to trying for four seconds */
+#define TXGBE_TRY_LINK_TIMEOUT  (4 * HZ)
+#define TXGBE_SFP_POLL_JIFFIES  (2 * HZ)        /* SFP poll every 2 seconds */
+
+/**
+ * txgbe_adapter.flag
+ **/
+#define TXGBE_FLAG_NEED_LINK_UPDATE             ((u32)(1 << 0))
+#define TXGBE_FLAG_NEED_LINK_CONFIG             ((u32)(1 << 1))
+
 /**
  * txgbe_adapter.flag2
  **/
 #define TXGBE_FLAG2_MNG_REG_ACCESS_DISABLED     (1U << 0)
+#define TXGBE_FLAG2_SFP_NEEDS_RESET             (1U << 1)
 
 /* board specific private data structure */
 struct txgbe_adapter {
@@ -54,7 +65,10 @@ struct txgbe_adapter {
 	/* Some features need tri-state capability,
 	 * thus the additional *_CAPABLE flags.
 	 */
+	u32 flags;
 	u32 flags2;
+	u8 backplane_an;
+	u8 an37;
 	/* Tx fast path data */
 	int num_tx_queues;
 	u16 tx_itr_setting;
@@ -72,6 +86,11 @@ struct txgbe_adapter {
 	struct txgbe_hw hw;
 	u16 msg_enable;
 
+	u32 link_speed;
+	bool link_up;
+	unsigned long sfp_poll_time;
+	unsigned long link_check_timeout;
+
 	struct timer_list service_timer;
 	struct work_struct service_task;
 	u32 atr_sample_rate;
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index 9865ae301133..0c1260ba7c72 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -3,6 +3,7 @@
 
 #include "txgbe_type.h"
 #include "txgbe_hw.h"
+#include "txgbe_phy.h"
 #include "txgbe.h"
 
 #define TXGBE_SP_MAX_TX_QUEUES  128
@@ -12,6 +13,50 @@
 static s32 txgbe_get_eeprom_semaphore(struct txgbe_hw *hw);
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
+void txgbe_wr32_ephy(struct txgbe_hw *hw, u32 addr, u32 data)
+{
+	unsigned int offset;
+
+	/* Set the LAN port indicator to offset[1] */
+	/* 1st, write the offset to IDA_ADDR register */
+	offset = TXGBE_ETHPHY_IDA_ADDR;
+	wr32(hw, offset, addr);
+
+	/* 2nd, read the data from IDA_DATA register */
+	offset = TXGBE_ETHPHY_IDA_DATA;
+	wr32(hw, offset, data);
+}
+
+void txgbe_wr32_epcs(struct txgbe_hw *hw, u32 addr, u32 data)
+{
+	unsigned int offset;
+
+	/* Set the LAN port indicator to offset[1] */
+	/* 1st, write the offset to IDA_ADDR register */
+	offset = TXGBE_XPCS_IDA_ADDR;
+	wr32(hw, offset, addr);
+
+	/* 2nd, read the data from IDA_DATA register */
+	offset = TXGBE_XPCS_IDA_DATA;
+	wr32(hw, offset, data);
+}
+
 s32 txgbe_init_hw(struct txgbe_hw *hw)
 {
 	s32 status;
@@ -305,6 +350,40 @@ s32 txgbe_stop_adapter(struct txgbe_hw *hw)
 	return txgbe_disable_pcie_master(hw);
 }
 
+/**
+ *  txgbe_led_on - Turns on the software controllable LEDs.
+ *  @hw: pointer to hardware structure
+ *  @index: led number to turn on
+ **/
+s32 txgbe_led_on(struct txgbe_hw *hw, u32 index)
+{
+	u32 led_reg = rd32(hw, TXGBE_CFG_LED_CTL);
+
+	/* To turn on the LED, set mode to ON. */
+	led_reg |= index | (index << TXGBE_CFG_LED_CTL_LINK_OD_SHIFT);
+	wr32(hw, TXGBE_CFG_LED_CTL, led_reg);
+	TXGBE_WRITE_FLUSH(hw);
+
+	return 0;
+}
+
+/**
+ *  txgbe_led_off - Turns off the software controllable LEDs.
+ *  @hw: pointer to hardware structure
+ *  @index: led number to turn off
+ **/
+s32 txgbe_led_off(struct txgbe_hw *hw, u32 index)
+{
+	u32 led_reg = rd32(hw, TXGBE_CFG_LED_CTL);
+
+	/* To turn off the LED, set mode to OFF. */
+	led_reg &= ~(index << TXGBE_CFG_LED_CTL_LINK_OD_SHIFT);
+	led_reg |= index;
+	wr32(hw, TXGBE_CFG_LED_CTL, led_reg);
+	TXGBE_WRITE_FLUSH(hw);
+	return 0;
+}
+
 /**
  *  txgbe_get_eeprom_semaphore - Get hardware semaphore
  *  @hw: pointer to hardware structure
@@ -1121,6 +1200,7 @@ s32 txgbe_reset_hostif(struct txgbe_hw *hw)
 		if (reset_cmd.hdr.cmd_or_resp.ret_status ==
 		    FW_CEM_RESP_STATUS_SUCCESS) {
 			status = 0;
+			hw->link_status = TXGBE_LINK_STATUS_NONE;
 		} else {
 			status = TXGBE_ERR_HOST_INTERFACE_COMMAND;
 		}
@@ -1230,6 +1310,141 @@ bool txgbe_check_mng_access(struct txgbe_hw *hw)
 	return ret;
 }
 
+/**
+ *  txgbe_setup_mac_link_multispeed_fiber - Set MAC link speed
+ *  @hw: pointer to hardware structure
+ *  @speed: new link speed
+ *  @autoneg_wait_to_complete: true when waiting for completion is needed
+ *
+ *  Set the link speed in the MAC and/or PHY register and restarts link.
+ **/
+s32 txgbe_setup_mac_link_multispeed_fiber(struct txgbe_hw *hw,
+					  u32 speed,
+					  bool autoneg_wait_to_complete)
+{
+	u32 link_speed = TXGBE_LINK_SPEED_UNKNOWN;
+	u32 highest_link_speed = TXGBE_LINK_SPEED_UNKNOWN;
+	s32 status = 0;
+	u32 speedcnt = 0;
+	u32 i = 0;
+	bool autoneg, link_up = false;
+
+	/* Mask off requested but non-supported speeds */
+	status = TCALL(hw, mac.ops.get_link_capabilities,
+		       &link_speed, &autoneg);
+	if (status != 0)
+		return status;
+
+	speed &= link_speed;
+
+	/* Try each speed one by one, highest priority first.  We do this in
+	 * software because 10Gb fiber doesn't support speed autonegotiation.
+	 */
+	if (speed & TXGBE_LINK_SPEED_10GB_FULL) {
+		speedcnt++;
+		highest_link_speed = TXGBE_LINK_SPEED_10GB_FULL;
+
+		/* If we already have link at this speed, just jump out */
+		status = TCALL(hw, mac.ops.check_link,
+			       &link_speed, &link_up, false);
+		if (status != 0)
+			return status;
+
+		if (link_speed == TXGBE_LINK_SPEED_10GB_FULL && link_up)
+			goto out;
+
+		/* Allow module to change analog characteristics (1G->10G) */
+		msec_delay(40);
+
+		status = TCALL(hw, mac.ops.setup_mac_link,
+			       TXGBE_LINK_SPEED_10GB_FULL,
+			       autoneg_wait_to_complete);
+		if (status != 0)
+			return status;
+
+		/* Flap the Tx laser if it has not already been done */
+		TCALL(hw, mac.ops.flap_tx_laser);
+
+		/* Wait for the controller to acquire link.  Per IEEE 802.3ap,
+		 * Section 73.10.2, we may have to wait up to 500ms if KR is
+		 * attempted.  sapphire uses the same timing for 10g SFI.
+		 */
+		for (i = 0; i < 5; i++) {
+			/* Wait for the link partner to also set speed */
+			msec_delay(100);
+
+			/* If we have link, just jump out */
+			status = TCALL(hw, mac.ops.check_link,
+				       &link_speed, &link_up, false);
+			if (status != 0)
+				return status;
+
+			if (link_up)
+				goto out;
+		}
+	}
+
+	if (speed & TXGBE_LINK_SPEED_1GB_FULL) {
+		speedcnt++;
+		if (highest_link_speed == TXGBE_LINK_SPEED_UNKNOWN)
+			highest_link_speed = TXGBE_LINK_SPEED_1GB_FULL;
+
+		/* If we already have link at this speed, just jump out */
+		status = TCALL(hw, mac.ops.check_link,
+			       &link_speed, &link_up, false);
+		if (status != 0)
+			return status;
+
+		if (link_speed == TXGBE_LINK_SPEED_1GB_FULL && link_up)
+			goto out;
+
+		/* Allow module to change analog characteristics (10G->1G) */
+		msec_delay(40);
+
+		status = TCALL(hw, mac.ops.setup_mac_link,
+			       TXGBE_LINK_SPEED_1GB_FULL,
+			       autoneg_wait_to_complete);
+		if (status != 0)
+			return status;
+
+		/* Flap the Tx laser if it has not already been done */
+		TCALL(hw, mac.ops.flap_tx_laser);
+
+		/* Wait for the link partner to also set speed */
+		msec_delay(100);
+
+		/* If we have link, just jump out */
+		status = TCALL(hw, mac.ops.check_link,
+			       &link_speed, &link_up, false);
+		if (status != 0)
+			return status;
+
+		if (link_up)
+			goto out;
+	}
+
+	/* We didn't get link.  Configure back to the highest speed we tried,
+	 * (if there was more than one).  We call ourselves back with just the
+	 * single highest speed that the user requested.
+	 */
+	if (speedcnt > 1)
+		status = txgbe_setup_mac_link_multispeed_fiber(hw,
+							       highest_link_speed,
+							       autoneg_wait_to_complete);
+
+out:
+	/* Set autoneg_advertised value based on input link speed */
+	hw->phy.autoneg_advertised = 0;
+
+	if (speed & TXGBE_LINK_SPEED_10GB_FULL)
+		hw->phy.autoneg_advertised |= TXGBE_LINK_SPEED_10GB_FULL;
+
+	if (speed & TXGBE_LINK_SPEED_1GB_FULL)
+		hw->phy.autoneg_advertised |= TXGBE_LINK_SPEED_1GB_FULL;
+
+	return status;
+}
+
 int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit)
 {
 	u32 i = 0;
@@ -1253,6 +1468,62 @@ int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit)
 	return err;
 }
 
+void txgbe_init_mac_link_ops(struct txgbe_hw *hw)
+{
+	struct txgbe_mac_info *mac = &hw->mac;
+
+	/* enable the laser control functions for SFP+ fiber
+	 * and MNG not enabled
+	 */
+	if ((TCALL(hw, mac.ops.get_media_type) == txgbe_media_type_fiber) &&
+	    !txgbe_mng_present(hw)) {
+		mac->ops.disable_tx_laser = txgbe_disable_tx_laser_multispeed_fiber;
+		mac->ops.enable_tx_laser = txgbe_enable_tx_laser_multispeed_fiber;
+		mac->ops.flap_tx_laser = txgbe_flap_tx_laser_multispeed_fiber;
+
+	} else {
+		mac->ops.disable_tx_laser = NULL;
+		mac->ops.enable_tx_laser = NULL;
+		mac->ops.flap_tx_laser = NULL;
+	}
+
+	if (hw->phy.multispeed_fiber) {
+		/* Set up dual speed SFP+ support */
+		mac->ops.setup_link = txgbe_setup_mac_link_multispeed_fiber;
+		mac->ops.setup_mac_link = txgbe_setup_mac_link;
+		mac->ops.set_rate_select_speed = txgbe_set_hard_rate_select_speed;
+	} else {
+		mac->ops.setup_link = txgbe_setup_mac_link;
+		mac->ops.set_rate_select_speed = txgbe_set_hard_rate_select_speed;
+	}
+}
+
+/**
+ *  txgbe_init_phy_ops - PHY/SFP specific init
+ *  @hw: pointer to hardware structure
+ *
+ *  Initialize any function pointers that were not able to be
+ *  set during init_shared_code because the PHY/SFP type was
+ *  not known.  Perform the SFP init if necessary.
+ *
+ **/
+s32 txgbe_init_phy_ops(struct txgbe_hw *hw)
+{
+	s32 ret_val = 0;
+
+	txgbe_init_i2c(hw);
+	/* Identify the PHY or SFP module */
+	ret_val = TCALL(hw, phy.ops.identify);
+	if (ret_val == TXGBE_ERR_SFP_NOT_SUPPORTED)
+		goto init_phy_ops_out;
+
+	/* Setup function pointers based on detected SFP module and speeds */
+	txgbe_init_mac_link_ops(hw);
+
+init_phy_ops_out:
+	return ret_val;
+}
+
 /**
  *  txgbe_init_ops - Inits func ptrs and MAC type
  *  @hw: pointer to hardware structure
@@ -1264,8 +1535,16 @@ int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit)
 s32 txgbe_init_ops(struct txgbe_hw *hw)
 {
 	struct txgbe_mac_info *mac = &hw->mac;
+	struct txgbe_phy_info *phy = &hw->phy;
 	struct txgbe_eeprom_info *eeprom = &hw->eeprom;
 
+	/* PHY */
+	phy->ops.read_i2c_byte = txgbe_read_i2c_byte;
+	phy->ops.read_i2c_eeprom = txgbe_read_i2c_eeprom;
+	phy->ops.identify_sfp = txgbe_identify_module;
+	phy->ops.identify = txgbe_identify_phy;
+	phy->ops.init = txgbe_init_phy_ops;
+
 	/* MAC */
 	mac->ops.init_hw = txgbe_init_hw;
 	mac->ops.get_mac_addr = txgbe_get_mac_addr;
@@ -1275,16 +1554,25 @@ s32 txgbe_init_ops(struct txgbe_hw *hw)
 	mac->ops.acquire_swfw_sync = txgbe_acquire_swfw_sync;
 	mac->ops.release_swfw_sync = txgbe_release_swfw_sync;
 	mac->ops.reset_hw = txgbe_reset_hw;
+	mac->ops.get_media_type = txgbe_get_media_type;
 	mac->ops.start_hw = txgbe_start_hw;
 	mac->ops.get_san_mac_addr = txgbe_get_san_mac_addr;
 	mac->ops.get_wwn_prefix = txgbe_get_wwn_prefix;
 
+	/* LEDs */
+	mac->ops.led_on = txgbe_led_on;
+	mac->ops.led_off = txgbe_led_off;
+
 	/* RAR */
 	mac->ops.set_rar = txgbe_set_rar;
 	mac->ops.clear_rar = txgbe_clear_rar;
 	mac->ops.init_rx_addrs = txgbe_init_rx_addrs;
 	mac->ops.init_uta_tables = txgbe_init_uta_tables;
 
+
+	/* Link */
+	mac->ops.get_link_capabilities = txgbe_get_link_capabilities;
+	mac->ops.check_link = txgbe_check_mac_link;
 	mac->num_rar_entries    = TXGBE_SP_RAR_ENTRIES;
 	mac->max_rx_queues      = TXGBE_SP_MAX_RX_QUEUES;
 	mac->max_tx_queues      = TXGBE_SP_MAX_TX_QUEUES;
@@ -1305,88 +1593,1242 @@ s32 txgbe_init_ops(struct txgbe_hw *hw)
 	return 0;
 }
 
-int txgbe_reset_misc(struct txgbe_hw *hw)
+/**
+ *  txgbe_get_link_capabilities - Determines link capabilities
+ *  @hw: pointer to hardware structure
+ *  @speed: pointer to link speed
+ *  @autoneg: true when autoneg or autotry is enabled
+ *
+ *  Determines the link capabilities by reading the AUTOC register.
+ **/
+s32 txgbe_get_link_capabilities(struct txgbe_hw *hw,
+				u32 *speed,
+				bool *autoneg)
 {
-	int i;
+	s32 status = 0;
+	u32 sr_pcs_ctl, sr_pma_mmd_ctl1, sr_an_mmd_ctl;
+	u32 sr_an_mmd_adv_reg2;
+
+	/* Check if 1G SFP module. */
+	if (hw->phy.sfp_type == txgbe_sfp_type_1g_cu_core0 ||
+	    hw->phy.sfp_type == txgbe_sfp_type_1g_cu_core1 ||
+	    hw->phy.sfp_type == txgbe_sfp_type_1g_lx_core0 ||
+	    hw->phy.sfp_type == txgbe_sfp_type_1g_lx_core1 ||
+	    hw->phy.sfp_type == txgbe_sfp_type_1g_sx_core0 ||
+	    hw->phy.sfp_type == txgbe_sfp_type_1g_sx_core1) {
+		*speed = TXGBE_LINK_SPEED_1GB_FULL;
+		*autoneg = false;
+	} else if (hw->phy.multispeed_fiber) {
+		*speed = TXGBE_LINK_SPEED_10GB_FULL |
+			  TXGBE_LINK_SPEED_1GB_FULL;
+		*autoneg = true;
+	}
+	/* SFP */
+	else if (txgbe_get_media_type(hw) == txgbe_media_type_fiber) {
+		*speed = TXGBE_LINK_SPEED_10GB_FULL;
+		*autoneg = false;
+	}
+	/* SGMII */
+	else if ((hw->subsystem_id & 0xF0) == TXGBE_ID_SGMII) {
+		*speed = TXGBE_LINK_SPEED_1GB_FULL |
+			TXGBE_LINK_SPEED_100_FULL |
+			TXGBE_LINK_SPEED_10_FULL;
+		*autoneg = false;
+		hw->phy.link_mode = TXGBE_PHYSICAL_LAYER_1000BASE_T |
+				TXGBE_PHYSICAL_LAYER_100BASE_TX;
+	/* MAC XAUI */
+	} else if ((hw->subsystem_id & 0xF0) == TXGBE_ID_MAC_XAUI) {
+		*speed = TXGBE_LINK_SPEED_10GB_FULL;
+		*autoneg = false;
+		hw->phy.link_mode = TXGBE_PHYSICAL_LAYER_10GBASE_KX4;
+	/* MAC SGMII */
+	} else if ((hw->subsystem_id & 0xF0) == TXGBE_ID_MAC_SGMII) {
+		*speed = TXGBE_LINK_SPEED_1GB_FULL;
+		*autoneg = false;
+		hw->phy.link_mode = TXGBE_PHYSICAL_LAYER_1000BASE_KX;
+	} else { /* KR KX KX4 */
+		/* Determine link capabilities based on the stored value,
+		 * which represents EEPROM defaults.  If value has not
+		 * been stored, use the current register values.
+		 */
+		if (hw->mac.orig_link_settings_stored) {
+			sr_pcs_ctl = hw->mac.orig_sr_pcs_ctl2;
+			sr_pma_mmd_ctl1 = hw->mac.orig_sr_pma_mmd_ctl1;
+			sr_an_mmd_ctl = hw->mac.orig_sr_an_mmd_ctl;
+			sr_an_mmd_adv_reg2 = hw->mac.orig_sr_an_mmd_adv_reg2;
+		} else {
+			sr_pcs_ctl = txgbe_rd32_epcs(hw, TXGBE_SR_PCS_CTL2);
+			sr_pma_mmd_ctl1 = txgbe_rd32_epcs(hw,
+							  TXGBE_SR_PMA_MMD_CTL1);
+			sr_an_mmd_ctl = txgbe_rd32_epcs(hw,
+							TXGBE_SR_AN_MMD_CTL);
+			sr_an_mmd_adv_reg2 = txgbe_rd32_epcs(hw,
+							     TXGBE_SR_AN_MMD_ADV_REG2);
+		}
 
-	/* receive packets that size > 2048 */
-	wr32m(hw, TXGBE_MAC_RX_CFG,
-	      TXGBE_MAC_RX_CFG_JE, TXGBE_MAC_RX_CFG_JE);
+		if ((sr_pcs_ctl & TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_MASK) ==
+				TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_X &&
+		    (sr_pma_mmd_ctl1 & TXGBE_SR_PMA_MMD_CTL1_SPEED_SEL_MASK) ==
+				TXGBE_SR_PMA_MMD_CTL1_SPEED_SEL_1G &&
+		    (sr_an_mmd_ctl & TXGBE_SR_AN_MMD_CTL_ENABLE) == 0) {
+			/* 1G or KX - no backplane auto-negotiation */
+			*speed = TXGBE_LINK_SPEED_1GB_FULL;
+			*autoneg = false;
+			hw->phy.link_mode = TXGBE_PHYSICAL_LAYER_1000BASE_KX;
+		} else if ((sr_pcs_ctl & TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_MASK) ==
+				TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_X &&
+			   (sr_pma_mmd_ctl1 & TXGBE_SR_PMA_MMD_CTL1_SPEED_SEL_MASK) ==
+				TXGBE_SR_PMA_MMD_CTL1_SPEED_SEL_10G &&
+			   (sr_an_mmd_ctl & TXGBE_SR_AN_MMD_CTL_ENABLE) == 0) {
+			*speed = TXGBE_LINK_SPEED_10GB_FULL;
+			*autoneg = false;
+			hw->phy.link_mode = TXGBE_PHYSICAL_LAYER_10GBASE_KX4;
+		} else if ((sr_pcs_ctl & TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_MASK) ==
+				TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_R &&
+			   (sr_an_mmd_ctl & TXGBE_SR_AN_MMD_CTL_ENABLE) == 0) {
+			/* 10 GbE serial link (KR -no backplane auto-negotiation) */
+			*speed = TXGBE_LINK_SPEED_10GB_FULL;
+			*autoneg = false;
+			hw->phy.link_mode = TXGBE_PHYSICAL_LAYER_10GBASE_KR;
+		} else if (sr_an_mmd_ctl & TXGBE_SR_AN_MMD_CTL_ENABLE) {
+			/* KX/KX4/KR backplane auto-negotiation enable */
+			*speed = TXGBE_LINK_SPEED_UNKNOWN;
+			if (sr_an_mmd_adv_reg2 & TXGBE_SR_AN_MMD_ADV_REG2_BP_TYPE_KR)
+				*speed |= TXGBE_LINK_SPEED_10GB_FULL;
+			if (sr_an_mmd_adv_reg2 & TXGBE_SR_AN_MMD_ADV_REG2_BP_TYPE_KX4)
+				*speed |= TXGBE_LINK_SPEED_10GB_FULL;
+			if (sr_an_mmd_adv_reg2 & TXGBE_SR_AN_MMD_ADV_REG2_BP_TYPE_KX)
+				*speed |= TXGBE_LINK_SPEED_1GB_FULL;
+			*autoneg = true;
+			hw->phy.link_mode = TXGBE_PHYSICAL_LAYER_10GBASE_KR |
+					TXGBE_PHYSICAL_LAYER_10GBASE_KX4 |
+					TXGBE_PHYSICAL_LAYER_1000BASE_KX;
+		} else {
+			status = TXGBE_ERR_LINK_SETUP;
+			goto out;
+		}
+	}
 
-	/* clear counters on read */
-	wr32m(hw, TXGBE_MMC_CONTROL,
-	      TXGBE_MMC_CONTROL_RSTONRD, TXGBE_MMC_CONTROL_RSTONRD);
+out:
+	return status;
+}
 
-	wr32m(hw, TXGBE_MAC_RX_FLOW_CTRL,
-	      TXGBE_MAC_RX_FLOW_CTRL_RFE, TXGBE_MAC_RX_FLOW_CTRL_RFE);
+/**
+ *  txgbe_get_media_type - Get media type
+ *  @hw: pointer to hardware structure
+ *
+ *  Returns the media type (fiber, copper, backplane)
+ **/
+enum txgbe_media_type txgbe_get_media_type(struct txgbe_hw *hw)
+{
+	enum txgbe_media_type media_type;
+	u8 device_type = hw->subsystem_id & 0xF0;
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
 
-	wr32(hw, TXGBE_MAC_PKT_FLT, TXGBE_MAC_PKT_FLT_PR);
+	return media_type;
+}
 
-	wr32m(hw, TXGBE_MIS_RST_ST,
-	      TXGBE_MIS_RST_ST_RST_INIT, 0x1E00);
+/**
+ *  txgbe_disable_tx_laser_multispeed_fiber - Disable Tx laser
+ *  @hw: pointer to hardware structure
+ *
+ *  The base drivers may require better control over SFP+ module
+ *  PHY states.  This includes selectively shutting down the Tx
+ *  laser on the PHY, effectively halting physical link.
+ **/
+void txgbe_disable_tx_laser_multispeed_fiber(struct txgbe_hw *hw)
+{
+	u32 esdp_reg = rd32(hw, TXGBE_GPIO_DR);
+
+	if (!(TCALL(hw, mac.ops.get_media_type) == txgbe_media_type_fiber))
+		return;
+	/* Blocked by MNG FW so bail */
+	txgbe_check_reset_blocked(hw);
+
+	if (txgbe_close_notify(hw))
+		/* over write led when ifconfig down */
+		TCALL(hw, mac.ops.led_off, TXGBE_LED_LINK_UP |
+		      TXGBE_LED_LINK_10G | TXGBE_LED_LINK_1G |
+		      TXGBE_LED_LINK_ACTIVE);
+
+	/* Disable Tx laser; allow 100us to go dark per spec */
+	esdp_reg |= TXGBE_GPIO_DR_1 | TXGBE_GPIO_DR_0;
+	wr32(hw, TXGBE_GPIO_DR, esdp_reg);
+	TXGBE_WRITE_FLUSH(hw);
+	usec_delay(100);
+}
 
-	/* errata 4: initialize mng flex tbl and wakeup flex tbl*/
-	wr32(hw, TXGBE_PSR_MNG_FLEX_SEL, 0);
-	for (i = 0; i < 16; i++) {
-		wr32(hw, TXGBE_PSR_MNG_FLEX_DW_L(i), 0);
-		wr32(hw, TXGBE_PSR_MNG_FLEX_DW_H(i), 0);
-		wr32(hw, TXGBE_PSR_MNG_FLEX_MSK(i), 0);
+/**
+ *  txgbe_enable_tx_laser_multispeed_fiber - Enable Tx laser
+ *  @hw: pointer to hardware structure
+ *
+ *  The base drivers may require better control over SFP+ module
+ *  PHY states.  This includes selectively turning on the Tx
+ *  laser on the PHY, effectively starting physical link.
+ **/
+void txgbe_enable_tx_laser_multispeed_fiber(struct txgbe_hw *hw)
+{
+	if (!(TCALL(hw, mac.ops.get_media_type) == txgbe_media_type_fiber))
+		return;
+	if (txgbe_open_notify(hw))
+		/* recover led configure when ifconfig up */
+		wr32(hw, TXGBE_CFG_LED_CTL, 0);
+
+	/* Enable Tx laser; allow 100ms to light up */
+	wr32m(hw, TXGBE_GPIO_DR,
+	      TXGBE_GPIO_DR_0 | TXGBE_GPIO_DR_1, 0);
+	TXGBE_WRITE_FLUSH(hw);
+	msec_delay(100);
+}
+
+/**
+ *  txgbe_flap_tx_laser_multispeed_fiber - Flap Tx laser
+ *  @hw: pointer to hardware structure
+ *
+ *  When the driver changes the link speeds that it can support,
+ *  it sets autotry_restart to true to indicate that we need to
+ *  initiate a new autotry session with the link partner.  To do
+ *  so, we set the speed then disable and re-enable the Tx laser, to
+ *  alert the link partner that it also needs to restart autotry on its
+ *  end.  This is consistent with true clause 37 autoneg, which also
+ *  involves a loss of signal.
+ **/
+void txgbe_flap_tx_laser_multispeed_fiber(struct txgbe_hw *hw)
+{
+	/* Blocked by MNG FW so bail */
+	txgbe_check_reset_blocked(hw);
+
+	if (hw->mac.autotry_restart) {
+		txgbe_disable_tx_laser_multispeed_fiber(hw);
+		txgbe_enable_tx_laser_multispeed_fiber(hw);
+		hw->mac.autotry_restart = false;
 	}
-	wr32(hw, TXGBE_PSR_LAN_FLEX_SEL, 0);
-	for (i = 0; i < 16; i++) {
-		wr32(hw, TXGBE_PSR_LAN_FLEX_DW_L(i), 0);
-		wr32(hw, TXGBE_PSR_LAN_FLEX_DW_H(i), 0);
-		wr32(hw, TXGBE_PSR_LAN_FLEX_MSK(i), 0);
+}
+
+/**
+ *  txgbe_set_hard_rate_select_speed - Set module link speed
+ *  @hw: pointer to hardware structure
+ *  @speed: link speed to set
+ *
+ *  Set module link speed via RS0/RS1 rate select pins.
+ */
+void txgbe_set_hard_rate_select_speed(struct txgbe_hw *hw,
+				      u32 speed)
+{
+	u32 esdp_reg = rd32(hw, TXGBE_GPIO_DR);
+
+	switch (speed) {
+	case TXGBE_LINK_SPEED_10GB_FULL:
+		esdp_reg |= TXGBE_GPIO_DR_5 | TXGBE_GPIO_DR_4;
+		break;
+	case TXGBE_LINK_SPEED_1GB_FULL:
+		esdp_reg &= ~(TXGBE_GPIO_DR_5 | TXGBE_GPIO_DR_4);
+		break;
+	default:
+		DEBUGOUT("Invalid fixed module speed\n");
+		return;
 	}
 
-	/* set pause frame dst mac addr */
-	wr32(hw, TXGBE_RDB_PFCMACDAL, 0xC2000001);
-	wr32(hw, TXGBE_RDB_PFCMACDAH, 0x0180);
+	wr32(hw, TXGBE_GPIO_DDR,
+	     TXGBE_GPIO_DDR_5 | TXGBE_GPIO_DDR_4 |
+	     TXGBE_GPIO_DDR_1 | TXGBE_GPIO_DDR_0);
 
-	txgbe_init_thermal_sensor_thresh(hw);
+	wr32(hw, TXGBE_GPIO_DR, esdp_reg);
+
+	TXGBE_WRITE_FLUSH(hw);
+}
 
+s32 txgbe_set_sgmii_an37_ability(struct txgbe_hw *hw)
+{
+	u32 value;
+
+	txgbe_wr32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1, 0x3002);
+	/* for sgmii + external phy, set to 0x0105 (phy sgmii mode) */
+	/* for sgmii direct link, set to 0x010c (mac sgmii mode) */
+	if ((hw->subsystem_id & 0xF0) == TXGBE_ID_MAC_SGMII ||
+	    txgbe_get_media_type(hw) == txgbe_media_type_fiber) {
+		txgbe_wr32_epcs(hw, TXGBE_SR_MII_MMD_AN_CTL, 0x010c);
+	} else if ((hw->subsystem_id & 0xF0) == TXGBE_ID_SGMII ||
+		   (hw->subsystem_id & 0xF0) == TXGBE_ID_XAUI) {
+		txgbe_wr32_epcs(hw, TXGBE_SR_MII_MMD_AN_CTL, 0x0105);
+	}
+	txgbe_wr32_epcs(hw, TXGBE_SR_MII_MMD_DIGI_CTL, 0x0200);
+	value = txgbe_rd32_epcs(hw, TXGBE_SR_MII_MMD_CTL);
+	value = (value & ~0x1200) | (0x1 << 12) | (0x1 << 9);
+	txgbe_wr32_epcs(hw, TXGBE_SR_MII_MMD_CTL, value);
 	return 0;
 }
 
-/**
- *  txgbe_reset_hw - Perform hardware reset
- *  @hw: pointer to hardware structure
- *
- *  Resets the hardware by resetting the transmit and receive units, masks
- *  and clears all interrupts, perform a PHY reset, and perform a link (MAC)
- *  reset.
- **/
-s32 txgbe_reset_hw(struct txgbe_hw *hw)
+s32 txgbe_set_link_to_kr(struct txgbe_hw *hw, bool autoneg)
 {
-	s32 status;
-	u32 reset = 0;
 	u32 i;
+	s32 status = 0;
+	struct txgbe_adapter *adapter = hw->back;
 
-	u32 reset_status = 0;
-	u32 rst_delay = 0;
+	/* 1. Wait xpcs power-up good */
+	for (i = 0; i < TXGBE_XPCS_POWER_GOOD_MAX_POLLING_TIME; i++) {
+		if ((txgbe_rd32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS) &
+		    TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_MASK) ==
+		    TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_POWER_GOOD)
+			break;
+		msleep(10);
+	}
+	if (i == TXGBE_XPCS_POWER_GOOD_MAX_POLLING_TIME) {
+		status = TXGBE_ERR_XPCS_POWER_UP_FAILED;
+		goto out;
+	}
+	txgbe_dev_info("It is set to kr.\n");
 
-	/* Call adapter stop to disable tx/rx and clear interrupts */
-	status = TCALL(hw, mac.ops.stop_adapter);
-	if (status != 0)
-		goto reset_hw_out;
+	txgbe_wr32_epcs(hw, 0x78001, 0x7);
 
-	/* Issue global reset to the MAC.  Needs to be SW reset if link is up.
-	 * If link reset is used when link is up, it might reset the PHY when
-	 * mng is using it.  If link is down or the flag to force full link
-	 * reset is set, then perform link reset.
-	 */
-	if (hw->force_full_reset) {
-		rst_delay = (rd32(hw, TXGBE_MIS_RST_ST) &
-			     TXGBE_MIS_RST_ST_RST_INIT) >>
-			     TXGBE_MIS_RST_ST_RST_INI_SHIFT;
-		if (hw->reset_type == TXGBE_SW_RESET) {
-			for (i = 0; i < rst_delay + 20; i++) {
-				reset_status =
-					rd32(hw, TXGBE_MIS_RST_ST);
-				if (!(reset_status &
-				    TXGBE_MIS_RST_ST_DEV_RST_ST_MASK))
-					break;
-				msleep(100);
+	if (1) {
+		/* 2. Disable xpcs AN-73 */
+		if (adapter->backplane_an == 1) {
+			txgbe_wr32_epcs(hw, TXGBE_SR_AN_MMD_CTL, 0x3000);
+			txgbe_wr32_epcs(hw, TXGBE_VR_AN_KR_MODE_CL, 0x1);
+		} else {
+			txgbe_wr32_epcs(hw, TXGBE_SR_AN_MMD_CTL, 0x0);
+			txgbe_wr32_epcs(hw, TXGBE_VR_AN_KR_MODE_CL, 0x0);
+		}
+
+		/* 3. Set VR_XS_PMA_Gen5_12G_MPLLA_CTRL3 Register */
+		/* Bit[10:0](MPLLA_BANDWIDTH) = 11'd123 (default: 11'd16) */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_MPLLA_CTL3,
+				TXGBE_PHY_MPLLA_CTL3_MULTIPLIER_BW_10GBASER_KR);
+
+		/* 4. Set VR_XS_PMA_Gen5_12G_MISC_CTRL0 Register */
+		/* Bit[12:8](RX_VREF_CTRL) = 5'hF (default: 5'h11) */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_MISC_CTL0, 0xCF00);
+
+		/* 5. Set VR_XS_PMA_Gen5_12G_RX_EQ_CTRL0 Register */
+		/* Bit[15:8](VGA1/2_GAIN_0) = 8'h77,
+		 * Bit[7:5](CTLE_POLE_0) = 3'h2
+		 * Bit[4:0](CTLE_BOOST_0) = 4'hA
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_CTL0, 0x774A);
+
+		/* 6. Set VR_MII_Gen5_12G_RX_GENCTRL3 Register */
+		/* Bit[2:0](LOS_TRSHLD_0) = 3'h4 (default: 3) */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_RX_GEN_CTL3, 0x0004);
+		/* 7. Initialize the mode by setting VR XS or PCS MMD Digital */
+		/* Control1 Register Bit[15](VR_RST) */
+		txgbe_wr32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1, 0xA000);
+		/* wait phy initialization done */
+		for (i = 0; i < TXGBE_PHY_INIT_DONE_POLLING_TIME; i++) {
+			if ((txgbe_rd32_epcs(hw,
+					     TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1) &
+			    TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1_VR_RST) == 0)
+				break;
+			msleep(100);
+		}
+		if (i == TXGBE_PHY_INIT_DONE_POLLING_TIME) {
+			status = TXGBE_ERR_PHY_INIT_NOT_DONE;
+			goto out;
+		}
+	} else {
+		txgbe_wr32_epcs(hw, TXGBE_VR_AN_KR_MODE_CL, 0x1);
+	}
+
+out:
+	return status;
+}
+
+s32 txgbe_set_link_to_kx4(struct txgbe_hw *hw, bool autoneg)
+{
+	u32 i;
+	s32 status = 0;
+	u32 value;
+	struct txgbe_adapter *adapter = hw->back;
+
+	/* check link status, if already set, skip setting it again */
+	if (hw->link_status == TXGBE_LINK_STATUS_KX4)
+		goto out;
+
+	txgbe_dev_info("It is set to kx4.\n");
+
+	/* 1. Wait xpcs power-up good */
+	for (i = 0; i < TXGBE_XPCS_POWER_GOOD_MAX_POLLING_TIME; i++) {
+		if ((txgbe_rd32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS) &
+			TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_MASK) ==
+			TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_POWER_GOOD)
+			break;
+		msleep(10);
+	}
+	if (i == TXGBE_XPCS_POWER_GOOD_MAX_POLLING_TIME) {
+		status = TXGBE_ERR_XPCS_POWER_UP_FAILED;
+		goto out;
+	}
+
+	wr32m(hw, TXGBE_MAC_TX_CFG, TXGBE_MAC_TX_CFG_TE, ~TXGBE_MAC_TX_CFG_TE);
+
+	/* 2. Disable xpcs AN-73 */
+	if (!autoneg)
+		txgbe_wr32_epcs(hw, TXGBE_SR_AN_MMD_CTL, 0x0);
+	else
+		txgbe_wr32_epcs(hw, TXGBE_SR_AN_MMD_CTL, 0x3000);
+
+	if (hw->revision_id == TXGBE_SP_MPW) {
+		/* Disable PHY MPLLA */
+		txgbe_wr32_ephy(hw, 0x4, 0x2501);
+		/* Reset rx lane0-3 clock */
+		txgbe_wr32_ephy(hw, 0x1005, 0x4001);
+		txgbe_wr32_ephy(hw, 0x1105, 0x4001);
+		txgbe_wr32_ephy(hw, 0x1205, 0x4001);
+		txgbe_wr32_ephy(hw, 0x1305, 0x4001);
+	} else {
+		/* Disable PHY MPLLA for eth mode change(after ECO) */
+		txgbe_wr32_ephy(hw, 0x4, 0x250A);
+		TXGBE_WRITE_FLUSH(hw);
+		msleep(1);
+
+		/* Set the eth change_mode bit first in mis_rst register
+		 * for corresponding LAN port
+		 */
+		if (hw->bus.lan_id == 0)
+			wr32(hw, TXGBE_MIS_RST,
+			     TXGBE_MIS_RST_LAN0_CHG_ETH_MODE);
+		else
+			wr32(hw, TXGBE_MIS_RST,
+			     TXGBE_MIS_RST_LAN1_CHG_ETH_MODE);
+	}
+
+	/* Set SR PCS Control2 Register Bits[1:0] = 2'b01
+	 * PCS_TYPE_SEL: non KR
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_SR_PCS_CTL2,
+			TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_X);
+	/* Set SR PMA MMD Control1 Register Bit[13] = 1'b1  SS13: 10G speed */
+	txgbe_wr32_epcs(hw, TXGBE_SR_PMA_MMD_CTL1,
+			TXGBE_SR_PMA_MMD_CTL1_SPEED_SEL_10G);
+
+	value = (0xf5f0 & ~0x7F0) | (0x5 << 8) | (0x7 << 5) | 0xF0;
+	txgbe_wr32_epcs(hw, TXGBE_PHY_TX_GENCTRL1, value);
+
+	if ((hw->subsystem_id & 0xF0) == TXGBE_ID_MAC_XAUI)
+		txgbe_wr32_epcs(hw, TXGBE_PHY_MISC_CTL0, 0xCF00);
+	else
+		txgbe_wr32_epcs(hw, TXGBE_PHY_MISC_CTL0, 0x4F00);
+
+	for (i = 0; i < 4; i++) {
+		if (i == 0)
+			value = (0x45 & ~0xFFFF) | (0x7 << 12) |
+				(0x7 << 8) | 0x6;
+		else
+			value = (0xff06 & ~0xFFFF) | (0x7 << 12) |
+				(0x7 << 8) | 0x6;
+		txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_CTL0 + i, value);
+	}
+
+	value = 0x0 & ~0x7777;
+	txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_ATT_LVL0, value);
+
+	txgbe_wr32_epcs(hw, TXGBE_PHY_DFE_TAP_CTL0, 0x0);
+
+	value = (0x6db & ~0xFFF) | (0x1 << 9) | (0x1 << 6) | (0x1 << 3) | 0x1;
+	txgbe_wr32_epcs(hw, TXGBE_PHY_RX_GEN_CTL3, value);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY MPLLA */
+	/* Control 0 Register Bit[7:0] = 8'd40  MPLLA_MULTIPLIER */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_MPLLA_CTL0,
+			TXGBE_PHY_MPLLA_CTL0_MULTIPLIER_OTHER);
+	/* Set VR XS, PMA or MII Synopsys Enterprise Gen5 12G PHY MPLLA */
+	/* Control 3 Register Bit[10:0] = 11'd86  MPLLA_BANDWIDTH */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_MPLLA_CTL3,
+			TXGBE_PHY_MPLLA_CTL3_MULTIPLIER_BW_OTHER);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY VCO */
+	/* Calibration Load 0 Register  Bit[12:0] = 13'd1360 VCO_LD_VAL_0 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_LD0, TXGBE_PHY_VCO_CAL_LD0_OTHER);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY VCO */
+	/* Calibration Load 1 Register  Bit[12:0] = 13'd1360 VCO_LD_VAL_1 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_LD1, TXGBE_PHY_VCO_CAL_LD0_OTHER);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY VCO */
+	/* Calibration Load 2 Register  Bit[12:0] = 13'd1360 VCO_LD_VAL_2 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_LD2, TXGBE_PHY_VCO_CAL_LD0_OTHER);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY VCO */
+	/* Calibration Load 3 Register  Bit[12:0] = 13'd1360 VCO_LD_VAL_3 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_LD3, TXGBE_PHY_VCO_CAL_LD0_OTHER);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY VCO */
+	/* Calibration Reference 0 Register Bit[5:0] = 6'd34 VCO_REF_LD_0/1 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_REF0, 0x2222);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY VCO */
+	/* Calibration Reference 1 Register Bit[5:0] = 6'd34 VCO_REF_LD_2/3 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_REF1, 0x2222);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY AFE-DFE */
+	/* Enable Register Bit[7:0] = 8'd0  AFE_EN_0/3_1, DFE_EN_0/3_1 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_AFE_DFE_ENABLE, 0x0);
+
+	/* Set  VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY Rx */
+	/* Equalization Control 4 Register Bit[3:0] = 4'd0 CONT_ADAPT_0/3_1 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_CTL, 0x00F0);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY Tx Rate */
+	/* Control Register Bit[14:12], Bit[10:8], Bit[6:4], Bit[2:0],
+	 * all rates to 3'b010  TX0/1/2/3_RATE
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_TX_RATE_CTL, 0x2222);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY Rx Rate */
+	/* Control Register Bit[13:12], Bit[9:8], Bit[5:4], Bit[1:0],
+	 * all rates to 2'b10  RX0/1/2/3_RATE
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_RX_RATE_CTL, 0x2222);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY Tx General */
+	/* Control 2 Register Bit[15:8] = 2'b01  TX0/1/2/3_WIDTH: 10bits */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_TX_GEN_CTL2, 0x5500);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY Rx General */
+	/* Control 2 Register Bit[15:8] = 2'b01  RX0/1/2/3_WIDTH: 10bits */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_RX_GEN_CTL2, 0x5500);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY MPLLA Control
+	 * 2 Register Bit[10:8] = 3'b010
+	 * MPLLA_DIV16P5_CLK_EN=0, MPLLA_DIV10_CLK_EN=1, MPLLA_DIV8_CLK_EN=0
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_MPLLA_CTL2,
+			TXGBE_PHY_MPLLA_CTL2_DIV_CLK_EN_10);
+
+	txgbe_wr32_epcs(hw, 0x1f0000, 0x0);
+	txgbe_wr32_epcs(hw, 0x1f8001, 0x0);
+	txgbe_wr32_epcs(hw, TXGBE_SR_MII_MMD_DIGI_CTL, 0x0);
+
+	/* 10. Initialize the mode by setting VR XS or PCS MMD Digital Control1
+	 * Register Bit[15](VR_RST)
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1, 0xA000);
+
+	/* wait phy initialization done */
+	for (i = 0; i < TXGBE_PHY_INIT_DONE_POLLING_TIME; i++) {
+		if ((txgbe_rd32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1) &
+			TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1_VR_RST) == 0)
+			break;
+		msleep(100);
+	}
+
+	/* if success, set link status */
+	hw->link_status = TXGBE_LINK_STATUS_KX4;
+
+	if (i == TXGBE_PHY_INIT_DONE_POLLING_TIME) {
+		status = TXGBE_ERR_PHY_INIT_NOT_DONE;
+		goto out;
+	}
+
+out:
+	return status;
+}
+
+s32 txgbe_set_link_to_kx(struct txgbe_hw *hw, u32 speed, bool autoneg)
+{
+	u32 i;
+	s32 status = 0;
+	u32 wdata = 0;
+	u32 value;
+	struct txgbe_adapter *adapter = hw->back;
+
+	/* check link status, if already set, skip setting it again */
+	if (hw->link_status == TXGBE_LINK_STATUS_KX)
+		goto out;
+
+	txgbe_dev_info("It is set to kx. speed =0x%x\n", speed);
+
+	/* 1. Wait xpcs power-up good */
+	for (i = 0; i < TXGBE_XPCS_POWER_GOOD_MAX_POLLING_TIME; i++) {
+		if ((txgbe_rd32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS) &
+			TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_MASK) ==
+			TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_POWER_GOOD)
+			break;
+		msleep(10);
+	}
+	if (i == TXGBE_XPCS_POWER_GOOD_MAX_POLLING_TIME) {
+		status = TXGBE_ERR_XPCS_POWER_UP_FAILED;
+		goto out;
+	}
+
+	wr32m(hw, TXGBE_MAC_TX_CFG, TXGBE_MAC_TX_CFG_TE, ~TXGBE_MAC_TX_CFG_TE);
+
+	/* 2. Disable xpcs AN-73 */
+	if (!autoneg)
+		txgbe_wr32_epcs(hw, TXGBE_SR_AN_MMD_CTL, 0x0);
+	else
+		txgbe_wr32_epcs(hw, TXGBE_SR_AN_MMD_CTL, 0x3000);
+
+	if (hw->revision_id == TXGBE_SP_MPW) {
+		/* Disable PHY MPLLA */
+		txgbe_wr32_ephy(hw, 0x4, 0x2401);
+		/* Reset rx lane0 clock */
+		txgbe_wr32_ephy(hw, 0x1005, 0x4001);
+	} else {
+		/* Disable PHY MPLLA for eth mode change(after ECO) */
+		txgbe_wr32_ephy(hw, 0x4, 0x240A);
+		TXGBE_WRITE_FLUSH(hw);
+		msleep(1);
+
+		/* Set the eth change_mode bit first in mis_rst register */
+		/* for corresponding LAN port */
+		if (hw->bus.lan_id == 0)
+			wr32(hw, TXGBE_MIS_RST,
+			     TXGBE_MIS_RST_LAN0_CHG_ETH_MODE);
+		else
+			wr32(hw, TXGBE_MIS_RST,
+			     TXGBE_MIS_RST_LAN1_CHG_ETH_MODE);
+	}
+
+	/* Set SR PCS Control2 Register Bits[1:0] = 2'b01
+	 * PCS_TYPE_SEL: non KR
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_SR_PCS_CTL2,
+			TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_X);
+
+	/* Set SR PMA MMD Control1 Register Bit[13] = 1'b0 SS13: 1G speed */
+	txgbe_wr32_epcs(hw, TXGBE_SR_PMA_MMD_CTL1,
+			TXGBE_SR_PMA_MMD_CTL1_SPEED_SEL_1G);
+
+	/* Set SR MII MMD Control Register to corresponding speed: {Bit[6],
+	 * Bit[13]}=[2'b00,2'b01,2'b10]->[10M,100M,1G]
+	 */
+	if (speed == TXGBE_LINK_SPEED_100_FULL)
+		wdata = 0x2100;
+	else if (speed == TXGBE_LINK_SPEED_1GB_FULL)
+		wdata = 0x0140;
+	else if (speed == TXGBE_LINK_SPEED_10_FULL)
+		wdata = 0x0100;
+	txgbe_wr32_epcs(hw, TXGBE_SR_MII_MMD_CTL, wdata);
+
+	value = (0xf5f0 & ~0x710) | (0x5 << 8) | 0x10;
+	txgbe_wr32_epcs(hw, TXGBE_PHY_TX_GENCTRL1, value);
+
+	txgbe_wr32_epcs(hw, TXGBE_PHY_MISC_CTL0, 0xCF00);
+
+	for (i = 0; i < 4; i++) {
+		if (i)
+			value = 0xff06;
+		else
+			value = (0x45 & ~0xFFFF) | (0x7 << 12) |
+				(0x7 << 8) | 0x6;
+
+		txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_CTL0 + i, value);
+	}
+
+	value = 0x0 & ~0x7;
+	txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_ATT_LVL0, value);
+
+	txgbe_wr32_epcs(hw, TXGBE_PHY_DFE_TAP_CTL0, 0x0);
+
+	value = (0x6db & ~0x7) | 0x4;
+	txgbe_wr32_epcs(hw, TXGBE_PHY_RX_GEN_CTL3, value);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY MPLLA Control
+	 * 0 Register Bit[7:0] = 8'd32  MPLLA_MULTIPLIER
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_MPLLA_CTL0,
+			TXGBE_PHY_MPLLA_CTL0_MULTIPLIER_1GBASEX_KX);
+
+	/* Set VR XS, PMA or MII Synopsys Enterprise Gen5 12G PHY MPLLA Control
+	 * 3 Register Bit[10:0] = 11'd70  MPLLA_BANDWIDTH
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_MPLLA_CTL3,
+			TXGBE_PHY_MPLLA_CTL3_MULTIPLIER_BW_1GBASEX_KX);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY VCO
+	 * Calibration Load 0 Register  Bit[12:0] = 13'd1344  VCO_LD_VAL_0
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_LD0,
+			TXGBE_PHY_VCO_CAL_LD0_1GBASEX_KX);
+
+	txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_LD1, 0x549);
+	txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_LD2, 0x549);
+	txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_LD3, 0x549);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY VCO
+	 * Calibration Reference 0 Register Bit[5:0] = 6'd42  VCO_REF_LD_0
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_REF0,
+			TXGBE_PHY_VCO_CAL_REF0_LD0_1GBASEX_KX);
+
+	txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_REF1, 0x2929);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY AFE-DFE
+	 * Enable Register Bit[4], Bit[0] = 1'b0  AFE_EN_0, DFE_EN_0
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_AFE_DFE_ENABLE, 0x0);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY Rx
+	 * Equalization Control 4 Register Bit[0] = 1'b0  CONT_ADAPT_0
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_CTL, 0x0010);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY Tx Rate
+	 * Control Register Bit[2:0] = 3'b011  TX0_RATE
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_TX_RATE_CTL,
+			TXGBE_PHY_TX_RATE_CTL_TX0_RATE_1GBASEX_KX);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY Rx Rate
+	 * Control Register Bit[2:0] = 3'b011 RX0_RATE
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_RX_RATE_CTL,
+			TXGBE_PHY_RX_RATE_CTL_RX0_RATE_1GBASEX_KX);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY Tx General
+	 * Control 2 Register Bit[9:8] = 2'b01  TX0_WIDTH: 10bits
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_TX_GEN_CTL2,
+			TXGBE_PHY_TX_GEN_CTL2_TX0_WIDTH_OTHER);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY Rx General
+	 * Control 2 Register Bit[9:8] = 2'b01  RX0_WIDTH: 10bits
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_RX_GEN_CTL2,
+			TXGBE_PHY_RX_GEN_CTL2_RX0_WIDTH_OTHER);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY MPLLA Control
+	 * 2 Register Bit[10:8] = 3'b010	MPLLA_DIV16P5_CLK_EN=0,
+	 * MPLLA_DIV10_CLK_EN=1, MPLLA_DIV8_CLK_EN=0
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_MPLLA_CTL2,
+			TXGBE_PHY_MPLLA_CTL2_DIV_CLK_EN_10);
+
+	/* VR MII MMD AN Control Register Bit[8] = 1'b1 MII_CTRL */
+	/* Set to 8bit MII (required in 10M/100M SGMII) */
+	txgbe_wr32_epcs(hw, TXGBE_SR_MII_MMD_AN_CTL, 0x0100);
+
+	/* 10. Initialize the mode by setting VR XS or PCS MMD Digital Control1
+	 * Register Bit[15](VR_RST)
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1, 0xA000);
+	/* wait phy initialization done */
+	for (i = 0; i < TXGBE_PHY_INIT_DONE_POLLING_TIME; i++) {
+		if ((txgbe_rd32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1) &
+			TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1_VR_RST) == 0)
+			break;
+		msleep(100);
+	}
+
+	/* if success, set link status */
+	hw->link_status = TXGBE_LINK_STATUS_KX;
+
+	if (i == TXGBE_PHY_INIT_DONE_POLLING_TIME) {
+		status = TXGBE_ERR_PHY_INIT_NOT_DONE;
+		goto out;
+	}
+
+	txgbe_dev_info("Set KX TX_EQ MAIN:24 PRE:4 POST:16\n");
+	/* 5. Set VR_XS_PMA_Gen5_12G_TX_EQ_CTRL0 Register
+	 * Bit[13:8](TX_EQ_MAIN) = 6'd30, Bit[5:0](TX_EQ_PRE) = 6'd4
+	 */
+	value = txgbe_rd32_epcs(hw, TXGBE_PHY_TX_EQ_CTL0);
+	value = (value & ~0x3F3F) | (24 << 8) | 4;
+	txgbe_wr32_epcs(hw, TXGBE_PHY_TX_EQ_CTL0, value);
+	/* 6. Set VR_XS_PMA_Gen5_12G_TX_EQ_CTRL1 Register
+	 * Bit[6](TX_EQ_OVR_RIDE) = 1'b1, Bit[5:0](TX_EQ_POST) = 6'd36
+	 */
+	value = txgbe_rd32_epcs(hw, TXGBE_PHY_TX_EQ_CTL1);
+	value = (value & ~0x7F) | 16 | (1 << 6);
+	txgbe_wr32_epcs(hw, TXGBE_PHY_TX_EQ_CTL1, value);
+
+out:
+	return status;
+}
+
+s32 txgbe_set_link_to_sfi(struct txgbe_hw *hw, u32 speed)
+{
+	u32 i;
+	s32 status = 0;
+	u32 value = 0;
+
+	/* Set the module link speed */
+	TCALL(hw, mac.ops.set_rate_select_speed, speed);
+
+	/* 1. Wait xpcs power-up good */
+	for (i = 0; i < TXGBE_XPCS_POWER_GOOD_MAX_POLLING_TIME; i++) {
+		if ((txgbe_rd32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS) &
+			TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_MASK) ==
+			TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_POWER_GOOD)
+			break;
+		msleep(10);
+	}
+	if (i == TXGBE_XPCS_POWER_GOOD_MAX_POLLING_TIME) {
+		status = TXGBE_ERR_XPCS_POWER_UP_FAILED;
+		goto out;
+	}
+
+	wr32m(hw, TXGBE_MAC_TX_CFG, TXGBE_MAC_TX_CFG_TE, ~TXGBE_MAC_TX_CFG_TE);
+
+	/* 2. Disable xpcs AN-73 */
+	txgbe_wr32_epcs(hw, TXGBE_SR_AN_MMD_CTL, 0x0);
+
+	if (hw->revision_id != TXGBE_SP_MPW) {
+		/* Disable PHY MPLLA for eth mode change(after ECO) */
+		txgbe_wr32_ephy(hw, 0x4, 0x243A);
+		TXGBE_WRITE_FLUSH(hw);
+		msleep(1);
+		/* Set the eth change_mode bit first in mis_rst register
+		 * for corresponding LAN port
+		 */
+		if (hw->bus.lan_id == 0)
+			wr32(hw, TXGBE_MIS_RST,
+			     TXGBE_MIS_RST_LAN0_CHG_ETH_MODE);
+		else
+			wr32(hw, TXGBE_MIS_RST,
+			     TXGBE_MIS_RST_LAN1_CHG_ETH_MODE);
+	}
+	if (speed == TXGBE_LINK_SPEED_10GB_FULL) {
+		/* Set SR PCS Control2 Register Bits[1:0] = 2'b00
+		 * PCS_TYPE_SEL: KR
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_SR_PCS_CTL2, 0);
+		value = txgbe_rd32_epcs(hw, TXGBE_SR_PMA_MMD_CTL1);
+		value = value | 0x2000;
+		txgbe_wr32_epcs(hw, TXGBE_SR_PMA_MMD_CTL1, value);
+		/* Set VR_XS_PMA_Gen5_12G_MPLLA_CTRL0 Register Bit[7:0] = 8'd33
+		 * MPLLA_MULTIPLIER
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_MPLLA_CTL0, 0x0021);
+		/* 3. Set VR_XS_PMA_Gen5_12G_MPLLA_CTRL3 Register
+		 * Bit[10:0](MPLLA_BANDWIDTH) = 11'd0
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_MPLLA_CTL3, 0);
+		value = txgbe_rd32_epcs(hw, TXGBE_PHY_TX_GENCTRL1);
+		value = (value & ~0x700) | 0x500;
+		txgbe_wr32_epcs(hw, TXGBE_PHY_TX_GENCTRL1, value);
+		/* 4.Set VR_XS_PMA_Gen5_12G_MISC_CTRL0 Register
+		 * Bit[12:8](RX_VREF_CTRL) = 5'hF
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_MISC_CTL0, 0xCF00);
+		/* Set VR_XS_PMA_Gen5_12G_VCO_CAL_LD0 Register
+		 * Bit[12:0] = 13'd1353 VCO_LD_VAL_0
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_LD0, 0x0549);
+		/* Set VR_XS_PMA_Gen5_12G_VCO_CAL_REF0 Register Bit[5:0] = 6'd41
+		 * VCO_REF_LD_0
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_REF0, 0x0029);
+		/* Set VR_XS_PMA_Gen5_12G_TX_RATE_CTRL Register
+		 * Bit[2:0] = 3'b000 TX0_RATE
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_TX_RATE_CTL, 0);
+		/* Set VR_XS_PMA_Gen5_12G_RX_RATE_CTRL Register
+		 * Bit[2:0] = 3'b000 RX0_RATE
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_RX_RATE_CTL, 0);
+		/* Set VR_XS_PMA_Gen5_12G_TX_GENCTRL2 Register Bit[9:8] = 2'b11
+		 * TX0_WIDTH: 20bits
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_TX_GEN_CTL2, 0x0300);
+		/* Set VR_XS_PMA_Gen5_12G_RX_GENCTRL2 Register Bit[9:8] = 2'b11
+		 * RX0_WIDTH: 20bits
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_RX_GEN_CTL2, 0x0300);
+		/* Set VR_XS_PMA_Gen5_12G_MPLLA_CTRL2 Register
+		 * Bit[10:8] = 3'b110 MPLLA_DIV16P5_CLK_EN=1,
+		 * MPLLA_DIV10_CLK_EN=1, MPLLA_DIV8_CLK_EN=0
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_MPLLA_CTL2, 0x0600);
+
+		if (hw->phy.sfp_type == txgbe_sfp_type_da_cu_core0 ||
+		    hw->phy.sfp_type == txgbe_sfp_type_da_cu_core1) {
+			/* 7. Set VR_XS_PMA_Gen5_12G_RX_EQ_CTRL0 Register
+			 * Bit[15:8](VGA1/2_GAIN_0) = 8'h77, Bit[7:5]
+			 * (CTLE_POLE_0) = 3'h2, Bit[4:0](CTLE_BOOST_0) = 4'hF
+			 */
+			txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_CTL0, 0x774F);
+		} else {
+			/* 7. Set VR_XS_PMA_Gen5_12G_RX_EQ_CTRL0 Register
+			 * Bit[15:8] (VGA1/2_GAIN_0) = 8'h00,
+			 * Bit[7:5](CTLE_POLE_0) = 3'h2,
+			 * Bit[4:0](CTLE_BOOST_0) = 4'hA
+			 */
+			value = txgbe_rd32_epcs(hw, TXGBE_PHY_RX_EQ_CTL0);
+			value = (value & ~0xFFFF) | (2 << 5) | 0x05;
+			txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_CTL0, value);
+		}
+		value = txgbe_rd32_epcs(hw, TXGBE_PHY_RX_EQ_ATT_LVL0);
+		value &= ~0x7;
+		txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_ATT_LVL0, value);
+
+		if (hw->phy.sfp_type == txgbe_sfp_type_da_cu_core0 ||
+		    hw->phy.sfp_type == txgbe_sfp_type_da_cu_core1) {
+			/* 8. Set VR_XS_PMA_Gen5_12G_DFE_TAP_CTRL0 Register
+			 * Bit[7:0](DFE_TAP1_0) = 8'd20
+			 */
+			txgbe_wr32_epcs(hw, TXGBE_PHY_DFE_TAP_CTL0, 0x0014);
+			value = txgbe_rd32_epcs(hw, TXGBE_PHY_AFE_DFE_ENABLE);
+			value = (value & ~0x11) | 0x11;
+			txgbe_wr32_epcs(hw, TXGBE_PHY_AFE_DFE_ENABLE, value);
+		} else {
+			/* 8. Set VR_XS_PMA_Gen5_12G_DFE_TAP_CTRL0 Register
+			 * Bit[7:0](DFE_TAP1_0) = 8'd20
+			 */
+			txgbe_wr32_epcs(hw, TXGBE_PHY_DFE_TAP_CTL0, 0xBE);
+			/* 9. Set VR_MII_Gen5_12G_AFE_DFE_EN_CTRL Register
+			 * Bit[4](DFE_EN_0) = 1'b0, Bit[0](AFE_EN_0) = 1'b0
+			 */
+			value = txgbe_rd32_epcs(hw, TXGBE_PHY_AFE_DFE_ENABLE);
+			value = (value & ~0x11) | 0x0;
+			txgbe_wr32_epcs(hw, TXGBE_PHY_AFE_DFE_ENABLE, value);
+		}
+		value = txgbe_rd32_epcs(hw, TXGBE_PHY_RX_EQ_CTL);
+		value = value & ~0x1;
+		txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_CTL, value);
+	} else {
+		if (hw->revision_id == TXGBE_SP_MPW) {
+			/* Disable PHY MPLLA */
+			txgbe_wr32_ephy(hw, 0x4, 0x2401);
+			/* Reset rx lane0 clock */
+			txgbe_wr32_ephy(hw, 0x1005, 0x4001);
+		}
+		/* Set SR PCS Control2 Register Bits[1:0] = 2'b00
+		 * PCS_TYPE_SEL: KR
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_SR_PCS_CTL2, 0x1);
+		/* Set SR PMA MMD Control1 Register Bit[13] = 1'b0
+		 * SS13: 1G speed
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_SR_PMA_MMD_CTL1, 0x0000);
+		/* Set SR MII MMD Control Register to corresponding speed: */
+		txgbe_wr32_epcs(hw, TXGBE_SR_MII_MMD_CTL, 0x0140);
+
+		value = txgbe_rd32_epcs(hw, TXGBE_PHY_TX_GENCTRL1);
+		value = (value & ~0x710) | 0x500;
+		txgbe_wr32_epcs(hw, TXGBE_PHY_TX_GENCTRL1, value);
+		/* 4. Set VR_XS_PMA_Gen5_12G_MISC_CTRL0 Register
+		 * Bit[12:8](RX_VREF_CTRL) = 5'hF
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_MISC_CTL0, 0xCF00);
+		/* 5. Set VR_XS_PMA_Gen5_12G_TX_EQ_CTRL0 Register
+		 * Bit[13:8](TX_EQ_MAIN) = 6'd30, Bit[5:0](TX_EQ_PRE) = 6'd4
+		 */
+		value = txgbe_rd32_epcs(hw, TXGBE_PHY_TX_EQ_CTL0);
+		value = (value & ~0x3F3F) | (24 << 8) | 4;
+		txgbe_wr32_epcs(hw, TXGBE_PHY_TX_EQ_CTL0, value);
+		/* 6. Set VR_XS_PMA_Gen5_12G_TX_EQ_CTRL1 Register
+		 * Bit[6](TX_EQ_OVR_RIDE) = 1'b1, Bit[5:0](TX_EQ_POST) = 6'd36
+		 */
+		value = txgbe_rd32_epcs(hw, TXGBE_PHY_TX_EQ_CTL1);
+		value = (value & ~0x7F) | 16 | (1 << 6);
+		txgbe_wr32_epcs(hw, TXGBE_PHY_TX_EQ_CTL1, value);
+		if (hw->phy.sfp_type == txgbe_sfp_type_da_cu_core0 ||
+		    hw->phy.sfp_type == txgbe_sfp_type_da_cu_core1) {
+			txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_CTL0, 0x774F);
+		} else {
+			/* 7. Set VR_XS_PMA_Gen5_12G_RX_EQ_CTRL0 Register
+			 * Bit[15:8] (VGA1/2_GAIN_0) = 8'h00,
+			 * Bit[7:5](CTLE_POLE_0) = 3'h2,
+			 * Bit[4:0](CTLE_BOOST_0) = 4'hA
+			 */
+			value = txgbe_rd32_epcs(hw, TXGBE_PHY_RX_EQ_CTL0);
+			value = (value & ~0xFFFF) | 0x7706;
+			txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_CTL0, value);
+		}
+		value = txgbe_rd32_epcs(hw, TXGBE_PHY_RX_EQ_ATT_LVL0);
+		value = (value & ~0x7) | 0x0;
+		txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_ATT_LVL0, value);
+		/* 8. Set VR_XS_PMA_Gen5_12G_DFE_TAP_CTRL0 Register
+		 * Bit[7:0](DFE_TAP1_0) = 8'd00
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_DFE_TAP_CTL0, 0x0);
+		/* Set VR_XS_PMA_Gen5_12G_RX_GENCTRL3 Register
+		 * Bit[2:0] LOS_TRSHLD_0 = 4
+		 */
+		value = txgbe_rd32_epcs(hw, TXGBE_PHY_RX_GEN_CTL3);
+		value = (value & ~0x7) | 0x4;
+		txgbe_wr32_epcs(hw, TXGBE_PHY_RX_GEN_CTL3, value);
+		/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY
+		 * MPLLA Control 0 Register Bit[7:0] = 8'd32  MPLLA_MULTIPLIER
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_MPLLA_CTL0, 0x0020);
+		/* Set VR XS, PMA or MII Synopsys Enterprise Gen5 12G PHY MPLLA
+		 * Control 3 Register Bit[10:0] = 11'd70  MPLLA_BANDWIDTH
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_MPLLA_CTL3, 0x0046);
+		/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY VCO
+		 * Calibration Load 0 Register
+		 * Bit[12:0] = 13'd1344  VCO_LD_VAL_0
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_LD0, 0x0540);
+		/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY VCO
+		 * Calibration Reference 0 Register
+		 * Bit[5:0] = 6'd42 VCO_REF_LD_0
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_REF0, 0x002A);
+		/* Set VR XS, PMA, MII Synopsys Enterprise Gen5 12G PHY AFE-DFE
+		 * Enable Register Bit[4], Bit[0] = 1'b0  AFE_EN_0, DFE_EN_0
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_AFE_DFE_ENABLE, 0x0);
+		/* Set  VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY Rx
+		 * Equalization Control 4 Register Bit[0] = 1'b0  CONT_ADAPT_0
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_CTL, 0x0010);
+		/* Set VR XS, PMA, MII Synopsys Enterprise Gen5 12G PHY Tx Rate
+		 * Control Register Bit[2:0] = 3'b011  TX0_RATE
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_TX_RATE_CTL, 0x0003);
+		/* Set VR XS, PMA, MII Synopsys Enterprise Gen5 12G PHY Rx Rate
+		 * Control Register Bit[2:0] = 3'b011
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_RX_RATE_CTL, 0x0003);
+		/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY
+		 * Tx General Control 2 Register
+		 * Bit[9:8] = 2'b01  TX0_WIDTH: 10bits
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_TX_GEN_CTL2, 0x0100);
+		/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY
+		 * Rx General Control 2 Register
+		 * Bit[9:8] = 2'b01  RX0_WIDTH: 10bits
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_RX_GEN_CTL2, 0x0100);
+		/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY MPLLA
+		 * Control 2 Register Bit[10:8] = 3'b010 MPLLA_DIV16P5_CLK_EN=0,
+		 * MPLLA_DIV10_CLK_EN=1, MPLLA_DIV8_CLK_EN=0
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_MPLLA_CTL2, 0x0200);
+		/* VR MII MMD AN Control Register Bit[8] = 1'b1 MII_CTRL */
+		txgbe_wr32_epcs(hw, TXGBE_SR_MII_MMD_AN_CTL, 0x0100);
+	}
+	/* 10. Initialize the mode by setting VR XS or PCS MMD Digital Control1
+	 * Register Bit[15](VR_RST)
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1, 0xA000);
+	/* wait phy initialization done */
+	for (i = 0; i < TXGBE_PHY_INIT_DONE_POLLING_TIME; i++) {
+		if ((txgbe_rd32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1) &
+			TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1_VR_RST) == 0)
+			break;
+		msleep(100);
+	}
+	if (i == TXGBE_PHY_INIT_DONE_POLLING_TIME) {
+		status = TXGBE_ERR_PHY_INIT_NOT_DONE;
+		goto out;
+	}
+
+out:
+	return status;
+}
+
+/**
+ *  txgbe_setup_mac_link - Set MAC link speed
+ *  @hw: pointer to hardware structure
+ *  @speed: new link speed
+ *  @autoneg_wait_to_complete: true when waiting for completion is needed
+ *
+ *  Set the link speed.
+ **/
+s32 txgbe_setup_mac_link(struct txgbe_hw *hw,
+			 u32 speed,
+			 bool __maybe_unused autoneg_wait_to_complete)
+{
+	bool autoneg = false;
+	s32 status = 0;
+	u32 link_capabilities = TXGBE_LINK_SPEED_UNKNOWN;
+	struct txgbe_adapter *adapter = hw->back;
+	u32 link_speed = TXGBE_LINK_SPEED_UNKNOWN;
+	bool link_up = false;
+	u16 sub_dev_id = hw->subsystem_device_id;
+
+	/* Check to see if speed passed in is supported. */
+	status = TCALL(hw, mac.ops.get_link_capabilities,
+		       &link_capabilities, &autoneg);
+	if (status)
+		goto out;
+
+	speed &= link_capabilities;
+
+	if (speed == TXGBE_LINK_SPEED_UNKNOWN) {
+		status = TXGBE_ERR_LINK_SETUP;
+		goto out;
+	}
+
+	if (!(((sub_dev_id & TXGBE_DEV_MASK) == TXGBE_ID_KR_KX_KX4) ||
+	      ((sub_dev_id & TXGBE_DEV_MASK) == TXGBE_ID_MAC_XAUI) ||
+	      ((sub_dev_id & TXGBE_DEV_MASK) == TXGBE_ID_MAC_SGMII))) {
+		status = TCALL(hw, mac.ops.check_link,
+			       &link_speed, &link_up, false);
+		if (status != 0)
+			goto out;
+		if (link_speed == speed && link_up)
+			goto out;
+	}
+
+	if ((hw->subsystem_id & TXGBE_DEV_MASK) == TXGBE_ID_KR_KX_KX4) {
+		if (!autoneg) {
+			switch (hw->phy.link_mode) {
+			case TXGBE_PHYSICAL_LAYER_10GBASE_KR:
+				txgbe_set_link_to_kr(hw, autoneg);
+				break;
+			case TXGBE_PHYSICAL_LAYER_10GBASE_KX4:
+				txgbe_set_link_to_kx4(hw, autoneg);
+				break;
+			case TXGBE_PHYSICAL_LAYER_1000BASE_KX:
+				txgbe_set_link_to_kx(hw, speed, autoneg);
+				break;
+			default:
+				status = TXGBE_ERR_PHY;
+				goto out;
+			}
+		} else {
+			txgbe_set_link_to_kr(hw, autoneg);
+		}
+	} else if ((hw->subsystem_id & TXGBE_DEV_MASK) == TXGBE_ID_XAUI ||
+		   (hw->subsystem_id & TXGBE_DEV_MASK) == TXGBE_ID_MAC_XAUI ||
+		   (hw->subsystem_id & TXGBE_DEV_MASK) == TXGBE_ID_SGMII ||
+		   (hw->subsystem_id & TXGBE_DEV_MASK) == TXGBE_ID_MAC_SGMII) {
+		if (speed == TXGBE_LINK_SPEED_10GB_FULL) {
+			txgbe_set_link_to_kx4(hw, 0);
+		} else {
+			txgbe_set_link_to_kx(hw, speed, 0);
+			if (adapter->an37)
+				txgbe_set_sgmii_an37_ability(hw);
+		}
+	} else if (txgbe_get_media_type(hw) == txgbe_media_type_fiber) {
+		txgbe_set_link_to_sfi(hw, speed);
+		if (speed == TXGBE_LINK_SPEED_1GB_FULL)
+			txgbe_set_sgmii_an37_ability(hw);
+	}
+
+out:
+	return status;
+}
+
+int txgbe_reset_misc(struct txgbe_hw *hw)
+{
+	int i;
+	u32 value;
+
+	txgbe_init_i2c(hw);
+
+	value = txgbe_rd32_epcs(hw, TXGBE_SR_PCS_CTL2);
+	if ((value & 0x3) != TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_X)
+		hw->link_status = TXGBE_LINK_STATUS_NONE;
+
+	/* receive packets that size > 2048 */
+	wr32m(hw, TXGBE_MAC_RX_CFG,
+	      TXGBE_MAC_RX_CFG_JE, TXGBE_MAC_RX_CFG_JE);
+
+	/* clear counters on read */
+	wr32m(hw, TXGBE_MMC_CONTROL,
+	      TXGBE_MMC_CONTROL_RSTONRD, TXGBE_MMC_CONTROL_RSTONRD);
+
+	wr32m(hw, TXGBE_MAC_RX_FLOW_CTRL,
+	      TXGBE_MAC_RX_FLOW_CTRL_RFE, TXGBE_MAC_RX_FLOW_CTRL_RFE);
+
+	wr32(hw, TXGBE_MAC_PKT_FLT, TXGBE_MAC_PKT_FLT_PR);
+
+	wr32m(hw, TXGBE_MIS_RST_ST,
+	      TXGBE_MIS_RST_ST_RST_INIT, 0x1E00);
+
+	/* errata 4: initialize mng flex tbl and wakeup flex tbl*/
+	wr32(hw, TXGBE_PSR_MNG_FLEX_SEL, 0);
+	for (i = 0; i < 16; i++) {
+		wr32(hw, TXGBE_PSR_MNG_FLEX_DW_L(i), 0);
+		wr32(hw, TXGBE_PSR_MNG_FLEX_DW_H(i), 0);
+		wr32(hw, TXGBE_PSR_MNG_FLEX_MSK(i), 0);
+	}
+	wr32(hw, TXGBE_PSR_LAN_FLEX_SEL, 0);
+	for (i = 0; i < 16; i++) {
+		wr32(hw, TXGBE_PSR_LAN_FLEX_DW_L(i), 0);
+		wr32(hw, TXGBE_PSR_LAN_FLEX_DW_H(i), 0);
+		wr32(hw, TXGBE_PSR_LAN_FLEX_MSK(i), 0);
+	}
+
+	/* set pause frame dst mac addr */
+	wr32(hw, TXGBE_RDB_PFCMACDAL, 0xC2000001);
+	wr32(hw, TXGBE_RDB_PFCMACDAH, 0x0180);
+
+	txgbe_init_thermal_sensor_thresh(hw);
+
+	return 0;
+}
+
+/**
+ *  txgbe_reset_hw - Perform hardware reset
+ *  @hw: pointer to hardware structure
+ *
+ *  Resets the hardware by resetting the transmit and receive units, masks
+ *  and clears all interrupts, perform a PHY reset, and perform a link (MAC)
+ *  reset.
+ **/
+s32 txgbe_reset_hw(struct txgbe_hw *hw)
+{
+	s32 status;
+	u32 reset = 0;
+	u32 i;
+
+	u32 sr_pcs_ctl, sr_pma_mmd_ctl1, sr_an_mmd_ctl, sr_an_mmd_adv_reg2;
+	u32 vr_xs_or_pcs_mmd_digi_ctl1, curr_vr_xs_or_pcs_mmd_digi_ctl1;
+	u32 curr_sr_pcs_ctl, curr_sr_pma_mmd_ctl1;
+	u32 curr_sr_an_mmd_ctl, curr_sr_an_mmd_adv_reg2;
+
+	u32 reset_status = 0;
+	u32 rst_delay = 0;
+
+	/* Call adapter stop to disable tx/rx and clear interrupts */
+	status = TCALL(hw, mac.ops.stop_adapter);
+	if (status != 0)
+		goto reset_hw_out;
+
+	/* Identify PHY and related function pointers */
+	status = TCALL(hw, phy.ops.init);
+
+	if (status == TXGBE_ERR_SFP_NOT_SUPPORTED)
+		goto reset_hw_out;
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
+	/* Issue global reset to the MAC.  Needs to be SW reset if link is up.
+	 * If link reset is used when link is up, it might reset the PHY when
+	 * mng is using it.  If link is down or the flag to force full link
+	 * reset is set, then perform link reset.
+	 */
+	if (hw->force_full_reset) {
+		rst_delay = (rd32(hw, TXGBE_MIS_RST_ST) &
+			     TXGBE_MIS_RST_ST_RST_INIT) >>
+			     TXGBE_MIS_RST_ST_RST_INI_SHIFT;
+		if (hw->reset_type == TXGBE_SW_RESET) {
+			for (i = 0; i < rst_delay + 20; i++) {
+				reset_status =
+					rd32(hw, TXGBE_MIS_RST_ST);
+				if (!(reset_status &
+				    TXGBE_MIS_RST_ST_DEV_RST_ST_MASK))
+					break;
+				msleep(100);
 			}
 
 			if (reset_status & TXGBE_MIS_RST_ST_DEV_RST_ST_MASK) {
@@ -1444,6 +2886,38 @@ s32 txgbe_reset_hw(struct txgbe_hw *hw)
 	if (status != 0)
 		goto reset_hw_out;
 
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
 	TCALL(hw, mac.ops.get_mac_addr, hw->mac.perm_addr);
 
@@ -1492,6 +2966,9 @@ s32 txgbe_start_hw(struct txgbe_hw *hw)
 	int ret_val = 0;
 	u32 i;
 
+	/* Set the media type */
+	hw->phy.media_type = TCALL(hw, mac.ops.get_media_type);
+
 	/* Clear the rate limiters */
 	for (i = 0; i < hw->mac.max_tx_queues; i++) {
 		wr32(hw, TXGBE_TDM_RP_IDX, i);
@@ -1508,6 +2985,38 @@ s32 txgbe_start_hw(struct txgbe_hw *hw)
 	return ret_val;
 }
 
+/**
+ *  txgbe_identify_phy - Get physical layer module
+ *  @hw: pointer to hardware structure
+ *
+ *  Determines the physical layer module found on the current adapter.
+ *  If PHY already detected, maintains current PHY type in hw struct,
+ *  otherwise executes the PHY detection routine.
+ **/
+s32 txgbe_identify_phy(struct txgbe_hw *hw)
+{
+	/* Detect PHY if not unknown - returns success if already detected. */
+	s32 status = TXGBE_ERR_PHY_ADDR_INVALID;
+	enum txgbe_media_type media_type;
+
+	if (!hw->phy.phy_semaphore_mask)
+		hw->phy.phy_semaphore_mask = TXGBE_MNG_SWFW_SYNC_SW_PHY;
+
+	media_type = TCALL(hw, mac.ops.get_media_type);
+	if (media_type == txgbe_media_type_fiber) {
+		status = txgbe_identify_module(hw);
+	} else {
+		hw->phy.type = txgbe_phy_none;
+		status = 0;
+	}
+
+	/* Return error if SFP module has been detected but is not supported */
+	if (hw->phy.type == txgbe_phy_sfp_unsupported)
+		return TXGBE_ERR_SFP_NOT_SUPPORTED;
+
+	return status;
+}
+
 /**
  *  txgbe_init_eeprom_params - Initialize EEPROM params
  *  @hw: pointer to hardware structure
@@ -1691,6 +3200,76 @@ s32 txgbe_read_ee_hostif_buffer(struct txgbe_hw *hw,
 	return status;
 }
 
+s32 txgbe_close_notify(struct txgbe_hw *hw)
+{
+	int tmp;
+	s32 status;
+	struct txgbe_hic_write_shadow_ram buffer;
+
+	buffer.hdr.req.cmd = FW_DW_CLOSE_NOTIFY;
+	buffer.hdr.req.buf_lenh = 0;
+	buffer.hdr.req.buf_lenl = 0;
+	buffer.hdr.req.checksum = FW_DEFAULT_CHECKSUM;
+
+	/* one word */
+	buffer.length = 0;
+	buffer.address = 0;
+
+	status = txgbe_host_interface_command(hw, (u32 *)&buffer,
+					      sizeof(buffer),
+					      TXGBE_HI_COMMAND_TIMEOUT, false);
+	if (status)
+		return status;
+
+	if (txgbe_check_mng_access(hw)) {
+		tmp = (u32)rd32(hw, TXGBE_MNG_SW_SM);
+		if (tmp == TXGBE_CHECKSUM_CAP_ST_PASS)
+			status = 0;
+		else
+			status = TXGBE_ERR_EEPROM_CHECKSUM;
+	} else {
+		status = TXGBE_ERR_MNG_ACCESS_FAILED;
+		return status;
+	}
+
+	return status;
+}
+
+s32 txgbe_open_notify(struct txgbe_hw *hw)
+{
+	int tmp;
+	s32 status;
+	struct txgbe_hic_write_shadow_ram buffer;
+
+	buffer.hdr.req.cmd = FW_DW_OPEN_NOTIFY;
+	buffer.hdr.req.buf_lenh = 0;
+	buffer.hdr.req.buf_lenl = 0;
+	buffer.hdr.req.checksum = FW_DEFAULT_CHECKSUM;
+
+	/* one word */
+	buffer.length = 0;
+	buffer.address = 0;
+
+	status = txgbe_host_interface_command(hw, (u32 *)&buffer,
+					      sizeof(buffer),
+					      TXGBE_HI_COMMAND_TIMEOUT, false);
+	if (status)
+		return status;
+
+	if (txgbe_check_mng_access(hw)) {
+		tmp = (u32)rd32(hw, TXGBE_MNG_SW_SM);
+		if (tmp == TXGBE_CHECKSUM_CAP_ST_PASS)
+			status = 0;
+		else
+			status = TXGBE_ERR_EEPROM_CHECKSUM;
+	} else {
+		status = TXGBE_ERR_MNG_ACCESS_FAILED;
+		return status;
+	}
+
+	return status;
+}
+
 /**
  *  txgbe_calc_eeprom_checksum - Calculates and returns the checksum
  *  @hw: pointer to hardware structure
@@ -1793,3 +3372,55 @@ s32 txgbe_validate_eeprom_checksum(struct txgbe_hw *hw,
 	return status;
 }
 
+/**
+ *  txgbe_check_mac_link - Determine link and speed status
+ *  @hw: pointer to hardware structure
+ *  @speed: pointer to link speed
+ *  @link_up: true when link is up
+ *  @link_up_wait_to_complete: bool used to wait for link up or not
+ *
+ *  Reads the links register to determine if link is up and the current speed
+ **/
+s32 txgbe_check_mac_link(struct txgbe_hw *hw, u32 *speed,
+			 bool *link_up, bool link_up_wait_to_complete)
+{
+	u32 links_reg = 0;
+	u32 i;
+
+	if (link_up_wait_to_complete) {
+		for (i = 0; i < TXGBE_LINK_UP_TIME; i++) {
+			links_reg = rd32(hw, TXGBE_CFG_PORT_ST);
+			if (links_reg & TXGBE_CFG_PORT_ST_LINK_UP) {
+				*link_up = true;
+				break;
+			}
+			*link_up = false;
+			msleep(100);
+		}
+	} else {
+		links_reg = rd32(hw, TXGBE_CFG_PORT_ST);
+		if (links_reg & TXGBE_CFG_PORT_ST_LINK_UP)
+			*link_up = true;
+		else
+			*link_up = false;
+	}
+
+	if (*link_up) {
+		if ((links_reg & TXGBE_CFG_PORT_ST_LINK_10G) ==
+				TXGBE_CFG_PORT_ST_LINK_10G)
+			*speed = TXGBE_LINK_SPEED_10GB_FULL;
+		else if ((links_reg & TXGBE_CFG_PORT_ST_LINK_1G) ==
+				TXGBE_CFG_PORT_ST_LINK_1G)
+			*speed = TXGBE_LINK_SPEED_1GB_FULL;
+		else if ((links_reg & TXGBE_CFG_PORT_ST_LINK_100M) ==
+				TXGBE_CFG_PORT_ST_LINK_100M)
+			*speed = TXGBE_LINK_SPEED_100_FULL;
+		else
+			*speed = TXGBE_LINK_SPEED_10_FULL;
+	} else {
+		*speed = TXGBE_LINK_SPEED_UNKNOWN;
+	}
+
+	return 0;
+}
+
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index 700d344ba6c1..2273afaea4e2 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -14,6 +14,9 @@ void txgbe_set_pci_config_data(struct txgbe_hw *hw, u16 link_status);
 void txgbe_set_lan_id_multi_port_pcie(struct txgbe_hw *hw);
 s32 txgbe_stop_adapter(struct txgbe_hw *hw);
 
+s32 txgbe_led_on(struct txgbe_hw *hw, u32 index);
+s32 txgbe_led_off(struct txgbe_hw *hw, u32 index);
+
 s32 txgbe_set_rar(struct txgbe_hw *hw, u32 index, u8 *addr, u64 pools,
 		  u32 enable_addr);
 s32 txgbe_clear_rar(struct txgbe_hw *hw, u32 index);
@@ -44,10 +47,27 @@ bool txgbe_check_mng_access(struct txgbe_hw *hw);
 
 s32 txgbe_init_thermal_sensor_thresh(struct txgbe_hw *hw);
 void txgbe_disable_rx(struct txgbe_hw *hw);
+s32 txgbe_setup_mac_link_multispeed_fiber(struct txgbe_hw *hw,
+					  u32 speed,
+					  bool autoneg_wait_to_complete);
 int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit);
 
+s32 txgbe_get_link_capabilities(struct txgbe_hw *hw,
+				u32 *speed, bool *autoneg);
+enum txgbe_media_type txgbe_get_media_type(struct txgbe_hw *hw);
+void txgbe_disable_tx_laser_multispeed_fiber(struct txgbe_hw *hw);
+void txgbe_enable_tx_laser_multispeed_fiber(struct txgbe_hw *hw);
+void txgbe_flap_tx_laser_multispeed_fiber(struct txgbe_hw *hw);
+void txgbe_set_hard_rate_select_speed(struct txgbe_hw *hw, u32 speed);
+s32 txgbe_setup_mac_link(struct txgbe_hw *hw, u32 speed,
+			 bool autoneg_wait_to_complete);
+s32 txgbe_check_mac_link(struct txgbe_hw *hw, u32 *speed,
+			 bool *link_up, bool link_up_wait_to_complete);
+void txgbe_init_mac_link_ops(struct txgbe_hw *hw);
 int txgbe_reset_misc(struct txgbe_hw *hw);
 s32 txgbe_reset_hw(struct txgbe_hw *hw);
+s32 txgbe_identify_phy(struct txgbe_hw *hw);
+s32 txgbe_init_phy_ops(struct txgbe_hw *hw);
 s32 txgbe_init_ops(struct txgbe_hw *hw);
 
 s32 txgbe_init_eeprom_params(struct txgbe_hw *hw);
@@ -58,5 +78,21 @@ s32 txgbe_read_ee_hostif_buffer(struct txgbe_hw *hw,
 				u16 offset, u16 words, u16 *data);
 s32 txgbe_read_ee_hostif_data(struct txgbe_hw *hw, u16 offset, u16 *data);
 s32 txgbe_read_ee_hostif(struct txgbe_hw *hw, u16 offset, u16 *data);
+u32 txgbe_rd32_epcs(struct txgbe_hw *hw, u32 addr);
+void txgbe_wr32_epcs(struct txgbe_hw *hw, u32 addr, u32 data);
+void txgbe_wr32_ephy(struct txgbe_hw *hw, u32 addr, u32 data);
+
+s32 txgbe_upgrade_flash_hostif(struct txgbe_hw *hw,  u32 region,
+			       const u8 *data, u32 size);
+
+s32 txgbe_close_notify(struct txgbe_hw *hw);
+s32 txgbe_open_notify(struct txgbe_hw *hw);
+
+s32 txgbe_set_link_to_kr(struct txgbe_hw *hw, bool autoneg);
+s32 txgbe_set_link_to_kx4(struct txgbe_hw *hw, bool autoneg);
+
+s32 txgbe_set_link_to_kx(struct txgbe_hw *hw,
+			 u32 speed,
+			 bool autoneg);
 
 #endif /* _TXGBE_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 9336eadfc690..e49a31cefb67 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -13,6 +13,7 @@
 
 #include "txgbe.h"
 #include "txgbe_hw.h"
+#include "txgbe_phy.h"
 
 char txgbe_driver_name[32] = TXGBE_NAME;
 static const char txgbe_driver_string[] =
@@ -45,6 +46,7 @@ MODULE_LICENSE("GPL");
 
 static struct workqueue_struct *txgbe_wq;
 
+static bool txgbe_is_sfp(struct txgbe_hw *hw);
 static bool txgbe_check_cfg_remove(struct txgbe_hw *hw, struct pci_dev *pdev);
 
 static void txgbe_check_minimum_link(struct txgbe_adapter *adapter,
@@ -124,6 +126,20 @@ static void txgbe_remove_adapter(struct txgbe_hw *hw)
 		txgbe_service_event_schedule(adapter);
 }
 
+static void txgbe_release_hw_control(struct txgbe_adapter *adapter)
+{
+	/* Let firmware take over control of hw */
+	wr32m(&adapter->hw, TXGBE_CFG_PORT_CTL,
+	      TXGBE_CFG_PORT_CTL_DRV_LOAD, 0);
+}
+
+static void txgbe_get_hw_control(struct txgbe_adapter *adapter)
+{
+	/* Let firmware know the driver has taken over */
+	wr32m(&adapter->hw, TXGBE_CFG_PORT_CTL,
+	      TXGBE_CFG_PORT_CTL_DRV_LOAD, TXGBE_CFG_PORT_CTL_DRV_LOAD);
+}
+
 static void txgbe_sync_mac_table(struct txgbe_adapter *adapter)
 {
 	struct txgbe_hw *hw = &adapter->hw;
@@ -175,6 +191,93 @@ static void txgbe_flush_sw_mac_table(struct txgbe_adapter *adapter)
 	txgbe_sync_mac_table(adapter);
 }
 
+static bool txgbe_is_sfp(struct txgbe_hw *hw)
+{
+	switch (TCALL(hw, mac.ops.get_media_type)) {
+	case txgbe_media_type_fiber:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool txgbe_is_backplane(struct txgbe_hw *hw)
+{
+	switch (TCALL(hw, mac.ops.get_media_type)) {
+	case txgbe_media_type_backplane:
+		return true;
+	default:
+		return false;
+	}
+}
+
+/**
+ * txgbe_sfp_link_config - set up SFP+ link
+ * @adapter: pointer to private adapter struct
+ **/
+static void txgbe_sfp_link_config(struct txgbe_adapter *adapter)
+{
+	/* We are assuming the worst case scenerio here, and that
+	 * is that an SFP was inserted/removed after the reset
+	 * but before SFP detection was enabled.  As such the best
+	 * solution is to just start searching as soon as we start
+	 */
+
+	adapter->flags2 |= TXGBE_FLAG2_SFP_NEEDS_RESET;
+	adapter->sfp_poll_time = 0;
+}
+
+static void txgbe_up_complete(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 links_reg;
+
+	txgbe_get_hw_control(adapter);
+
+	/* enable the optics for SFP+ fiber */
+	TCALL(hw, mac.ops.enable_tx_laser);
+
+	smp_mb__before_atomic();
+	clear_bit(__TXGBE_DOWN, &adapter->state);
+
+	if (txgbe_is_sfp(hw)) {
+		txgbe_sfp_link_config(adapter);
+	} else if (txgbe_is_backplane(hw)) {
+		adapter->flags |= TXGBE_FLAG_NEED_LINK_CONFIG;
+		txgbe_service_event_schedule(adapter);
+	}
+
+	links_reg = rd32(hw, TXGBE_CFG_PORT_ST);
+	if (links_reg & TXGBE_CFG_PORT_ST_LINK_UP) {
+		if (links_reg & TXGBE_CFG_PORT_ST_LINK_10G) {
+			wr32(hw, TXGBE_MAC_TX_CFG,
+			     (rd32(hw, TXGBE_MAC_TX_CFG) &
+			      ~TXGBE_MAC_TX_CFG_SPEED_MASK) |
+			     TXGBE_MAC_TX_CFG_SPEED_10G);
+		} else if (links_reg & (TXGBE_CFG_PORT_ST_LINK_1G | TXGBE_CFG_PORT_ST_LINK_100M)) {
+			wr32(hw, TXGBE_MAC_TX_CFG,
+			     (rd32(hw, TXGBE_MAC_TX_CFG) &
+			      ~TXGBE_MAC_TX_CFG_SPEED_MASK) |
+			     TXGBE_MAC_TX_CFG_SPEED_1G);
+		}
+	}
+
+	if (hw->bus.lan_id == 0) {
+		wr32m(hw, TXGBE_MIS_PRB_CTL,
+		      TXGBE_MIS_PRB_CTL_LAN0_UP, TXGBE_MIS_PRB_CTL_LAN0_UP);
+	} else if (hw->bus.lan_id == 1) {
+		wr32m(hw, TXGBE_MIS_PRB_CTL,
+		      TXGBE_MIS_PRB_CTL_LAN1_UP, TXGBE_MIS_PRB_CTL_LAN1_UP);
+	} else {
+		txgbe_err(probe, "%s:invalid bus lan id %d\n",
+			  __func__, hw->bus.lan_id);
+	}
+
+	/* Set PF Reset Done bit so PF/VF Mail Ops can work */
+	wr32m(hw, TXGBE_CFG_PORT_CTL,
+	      TXGBE_CFG_PORT_CTL_PFRSTD, TXGBE_CFG_PORT_CTL_PFRSTD);
+}
+
 void txgbe_reset(struct txgbe_adapter *adapter)
 {
 	struct txgbe_hw *hw = &adapter->hw;
@@ -184,10 +287,19 @@ void txgbe_reset(struct txgbe_adapter *adapter)
 
 	if (TXGBE_REMOVED(hw->hw_addr))
 		return;
+	/* lock SFP init bit to prevent race conditions with the watchdog */
+	while (test_and_set_bit(__TXGBE_IN_SFP_INIT, &adapter->state))
+		usleep_range(1000, 2000);
+
+	/* clear all SFP and link config related flags while holding SFP_INIT */
+	adapter->flags2 &= ~TXGBE_FLAG2_SFP_NEEDS_RESET;
+	adapter->flags &= ~TXGBE_FLAG_NEED_LINK_CONFIG;
 
 	err = TCALL(hw, mac.ops.init_hw);
 	switch (err) {
 	case 0:
+	case TXGBE_ERR_SFP_NOT_PRESENT:
+	case TXGBE_ERR_SFP_NOT_SUPPORTED:
 		break;
 	case TXGBE_ERR_MASTER_REQUESTS_PENDING:
 		txgbe_dev_err("master disable timed out\n");
@@ -196,6 +308,7 @@ void txgbe_reset(struct txgbe_adapter *adapter)
 		txgbe_dev_err("Hardware Error: %d\n", err);
 	}
 
+	clear_bit(__TXGBE_IN_SFP_INIT, &adapter->state);
 	/* do not flush user set addresses */
 	memcpy(old_addr, &adapter->mac_table[0].addr, netdev->addr_len);
 	txgbe_flush_sw_mac_table(adapter);
@@ -223,6 +336,8 @@ void txgbe_disable_device(struct txgbe_adapter *adapter)
 	netif_carrier_off(netdev);
 	netif_tx_disable(netdev);
 
+	adapter->flags &= ~TXGBE_FLAG_NEED_LINK_UPDATE;
+
 	del_timer_sync(&adapter->service_timer);
 
 	if (hw->bus.lan_id == 0)
@@ -251,8 +366,14 @@ void txgbe_disable_device(struct txgbe_adapter *adapter)
 
 void txgbe_down(struct txgbe_adapter *adapter)
 {
+	struct txgbe_hw *hw = &adapter->hw;
+
 	txgbe_disable_device(adapter);
 	txgbe_reset(adapter);
+
+	if (!(((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP)))
+		/* power down the optics for SFP+ fiber */
+		TCALL(&adapter->hw, mac.ops.disable_tx_laser);
 }
 
 /**
@@ -330,6 +451,67 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
 	return err;
 }
 
+/**
+ * txgbe_open - Called when a network interface is made active
+ * @netdev: network interface device structure
+ *
+ * Returns 0 on success, negative value on failure
+ *
+ * The open entry point is called when a network interface is made
+ * active by the system (IFF_UP).  At this point all resources needed
+ * for transmit and receive operations are allocated, the interrupt
+ * handler is registered with the OS, the watchdog timer is started,
+ * and the stack is notified that the interface is ready.
+ **/
+int txgbe_open(struct net_device *netdev)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+
+	netif_carrier_off(netdev);
+
+	txgbe_up_complete(adapter);
+
+	return 0;
+}
+
+/**
+ * txgbe_close_suspend - actions necessary to both suspend and close flows
+ * @adapter: the private adapter struct
+ *
+ * This function should contain the necessary work common to both suspending
+ * and closing of the device.
+ */
+static void txgbe_close_suspend(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+
+	txgbe_disable_device(adapter);
+	if (!((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP))
+		TCALL(hw, mac.ops.disable_tx_laser);
+}
+
+/**
+ * txgbe_close - Disables a network interface
+ * @netdev: network interface device structure
+ *
+ * Returns 0, this is not allowed to fail
+ *
+ * The close entry point is called when an interface is de-activated
+ * by the OS.  The hardware is still under the drivers control, but
+ * needs to be disabled.  A global MAC reset is issued to stop the
+ * hardware, and all transmit and receive resources are freed.
+ **/
+int txgbe_close(struct net_device *netdev)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+
+	txgbe_down(adapter);
+
+	txgbe_release_hw_control(adapter);
+
+	return 0;
+}
+
 static int __txgbe_shutdown(struct pci_dev *pdev, bool *enable_wake)
 {
 	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
@@ -337,6 +519,13 @@ static int __txgbe_shutdown(struct pci_dev *pdev, bool *enable_wake)
 
 	netif_device_detach(netdev);
 
+	rtnl_lock();
+	if (netif_running(netdev))
+		txgbe_close_suspend(adapter);
+	rtnl_unlock();
+
+	txgbe_release_hw_control(adapter);
+
 	if (!test_and_set_bit(__TXGBE_DISABLED, &adapter->state))
 		pci_disable_device(pdev);
 
@@ -355,6 +544,247 @@ static void txgbe_shutdown(struct pci_dev *pdev)
 	}
 }
 
+/**
+ * txgbe_watchdog_update_link - update the link status
+ * @adapter - pointer to the device adapter structure
+ * @link_speed - pointer to a u32 to store the link_speed
+ **/
+static void txgbe_watchdog_update_link(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 link_speed = adapter->link_speed;
+	bool link_up = adapter->link_up;
+	u32 reg;
+	u32 i = 1;
+
+	if (!(adapter->flags & TXGBE_FLAG_NEED_LINK_UPDATE))
+		return;
+
+	link_speed = TXGBE_LINK_SPEED_10GB_FULL;
+	link_up = true;
+	TCALL(hw, mac.ops.check_link, &link_speed, &link_up, false);
+
+	if (link_up || time_after(jiffies, (adapter->link_check_timeout +
+		TXGBE_TRY_LINK_TIMEOUT))) {
+		adapter->flags &= ~TXGBE_FLAG_NEED_LINK_UPDATE;
+	}
+
+	for (i = 0; i < 3; i++) {
+		TCALL(hw, mac.ops.check_link, &link_speed, &link_up, false);
+		msleep(1);
+	}
+
+	adapter->link_up = link_up;
+	adapter->link_speed = link_speed;
+
+	if (link_up) {
+		if (link_speed & TXGBE_LINK_SPEED_10GB_FULL) {
+			wr32(hw, TXGBE_MAC_TX_CFG,
+			     (rd32(hw, TXGBE_MAC_TX_CFG) &
+			      ~TXGBE_MAC_TX_CFG_SPEED_MASK) | TXGBE_MAC_TX_CFG_TE |
+			     TXGBE_MAC_TX_CFG_SPEED_10G);
+		} else if (link_speed & (TXGBE_LINK_SPEED_1GB_FULL |
+			   TXGBE_LINK_SPEED_100_FULL | TXGBE_LINK_SPEED_10_FULL)) {
+			wr32(hw, TXGBE_MAC_TX_CFG,
+			     (rd32(hw, TXGBE_MAC_TX_CFG) &
+			      ~TXGBE_MAC_TX_CFG_SPEED_MASK) | TXGBE_MAC_TX_CFG_TE |
+			     TXGBE_MAC_TX_CFG_SPEED_1G);
+		}
+
+		/* Re configure MAC RX */
+		reg = rd32(hw, TXGBE_MAC_RX_CFG);
+		wr32(hw, TXGBE_MAC_RX_CFG, reg);
+		wr32(hw, TXGBE_MAC_PKT_FLT, TXGBE_MAC_PKT_FLT_PR);
+		reg = rd32(hw, TXGBE_MAC_WDG_TIMEOUT);
+		wr32(hw, TXGBE_MAC_WDG_TIMEOUT, reg);
+	}
+}
+
+/**
+ * txgbe_watchdog_link_is_up - update netif_carrier status and
+ *                             print link up message
+ * @adapter - pointer to the device adapter structure
+ **/
+static void txgbe_watchdog_link_is_up(struct txgbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 link_speed = adapter->link_speed;
+	bool flow_rx, flow_tx;
+
+	/* only continue if link was previously down */
+	if (netif_carrier_ok(netdev))
+		return;
+
+	/* flow_rx, flow_tx report link flow control status */
+	flow_rx = (rd32(hw, TXGBE_MAC_RX_FLOW_CTRL) & 0x101) == 0x1;
+	flow_tx = !!(TXGBE_RDB_RFCC_RFCE_802_3X &
+		     rd32(hw, TXGBE_RDB_RFCC));
+
+	txgbe_info(drv, "NIC Link is Up %s, Flow Control: %s\n",
+		   (link_speed == TXGBE_LINK_SPEED_10GB_FULL ?
+		    "10 Gbps" :
+		    (link_speed == TXGBE_LINK_SPEED_1GB_FULL ?
+		     "1 Gbps" :
+		     (link_speed == TXGBE_LINK_SPEED_100_FULL ?
+		      "100 Mbps" :
+		      (link_speed == TXGBE_LINK_SPEED_10_FULL ?
+		       "10 Mbps" :
+		       "unknown speed")))),
+		  ((flow_rx && flow_tx) ? "RX/TX" :
+		   (flow_rx ? "RX" :
+		    (flow_tx ? "TX" : "None"))));
+
+	netif_carrier_on(netdev);
+}
+
+/**
+ * txgbe_watchdog_link_is_down - update netif_carrier status and
+ *                               print link down message
+ * @adapter - pointer to the adapter structure
+ **/
+static void txgbe_watchdog_link_is_down(struct txgbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+
+	adapter->link_up = false;
+	adapter->link_speed = 0;
+
+	/* only continue if link was up previously */
+	if (!netif_carrier_ok(netdev))
+		return;
+
+	txgbe_info(drv, "NIC Link is Down\n");
+	netif_carrier_off(netdev);
+}
+
+/**
+ * txgbe_watchdog_subtask - check and bring link up
+ * @adapter - pointer to the device adapter structure
+ **/
+static void txgbe_watchdog_subtask(struct txgbe_adapter *adapter)
+{
+	/* if interface is down do nothing */
+	if (test_bit(__TXGBE_DOWN, &adapter->state) ||
+	    test_bit(__TXGBE_REMOVING, &adapter->state) ||
+	    test_bit(__TXGBE_RESETTING, &adapter->state))
+		return;
+
+	txgbe_watchdog_update_link(adapter);
+
+	if (adapter->link_up)
+		txgbe_watchdog_link_is_up(adapter);
+	else
+		txgbe_watchdog_link_is_down(adapter);
+}
+
+/**
+ * txgbe_sfp_detection_subtask - poll for SFP+ cable
+ * @adapter - the txgbe adapter structure
+ **/
+static void txgbe_sfp_detection_subtask(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	struct txgbe_mac_info *mac = &hw->mac;
+	s32 err;
+
+	/* not searching for SFP so there is nothing to do here */
+	if (!(adapter->flags2 & TXGBE_FLAG2_SFP_NEEDS_RESET))
+		return;
+
+	if (adapter->sfp_poll_time &&
+	    time_after(adapter->sfp_poll_time, jiffies))
+		return; /* If not yet time to poll for SFP */
+
+	/* someone else is in init, wait until next service event */
+	if (test_and_set_bit(__TXGBE_IN_SFP_INIT, &adapter->state))
+		return;
+
+	adapter->sfp_poll_time = jiffies + TXGBE_SFP_POLL_JIFFIES - 1;
+
+	err = TCALL(hw, phy.ops.identify_sfp);
+	if (err == TXGBE_ERR_SFP_NOT_SUPPORTED)
+		goto sfp_out;
+
+	if (err == TXGBE_ERR_SFP_NOT_PRESENT) {
+		/* If no cable is present, then we need to reset
+		 * the next time we find a good cable.
+		 */
+		adapter->flags2 |= TXGBE_FLAG2_SFP_NEEDS_RESET;
+	}
+
+	/* exit on error */
+	if (err)
+		goto sfp_out;
+
+	/* exit if reset not needed */
+	if (!(adapter->flags2 & TXGBE_FLAG2_SFP_NEEDS_RESET))
+		goto sfp_out;
+
+	adapter->flags2 &= ~TXGBE_FLAG2_SFP_NEEDS_RESET;
+
+	if (hw->phy.multispeed_fiber) {
+		/* Set up dual speed SFP+ support */
+		mac->ops.setup_link = txgbe_setup_mac_link_multispeed_fiber;
+		mac->ops.setup_mac_link = txgbe_setup_mac_link;
+		mac->ops.set_rate_select_speed = txgbe_set_hard_rate_select_speed;
+	} else {
+		mac->ops.setup_link = txgbe_setup_mac_link;
+		mac->ops.set_rate_select_speed = txgbe_set_hard_rate_select_speed;
+		hw->phy.autoneg_advertised = 0;
+	}
+
+	adapter->flags |= TXGBE_FLAG_NEED_LINK_CONFIG;
+	txgbe_info(probe, "detected SFP+: %d\n", hw->phy.sfp_type);
+
+sfp_out:
+	clear_bit(__TXGBE_IN_SFP_INIT, &adapter->state);
+
+	if (err == TXGBE_ERR_SFP_NOT_SUPPORTED && adapter->netdev_registered)
+		txgbe_dev_err("failed to initialize because an unsupported SFP+ module type was detected.\n");
+}
+
+/**
+ * txgbe_sfp_link_config_subtask - set up link SFP after module install
+ * @adapter - the txgbe adapter structure
+ **/
+static void txgbe_sfp_link_config_subtask(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 speed;
+	bool autoneg = false;
+	u8 device_type = hw->subsystem_id & 0xF0;
+
+	if (!(adapter->flags & TXGBE_FLAG_NEED_LINK_CONFIG))
+		return;
+
+	/* someone else is in init, wait until next service event */
+	if (test_and_set_bit(__TXGBE_IN_SFP_INIT, &adapter->state))
+		return;
+
+	adapter->flags &= ~TXGBE_FLAG_NEED_LINK_CONFIG;
+
+	if (device_type == TXGBE_ID_MAC_SGMII) {
+		speed = TXGBE_LINK_SPEED_1GB_FULL;
+	} else {
+		speed = hw->phy.autoneg_advertised;
+		if (!speed && hw->mac.ops.get_link_capabilities) {
+			TCALL(hw, mac.ops.get_link_capabilities, &speed, &autoneg);
+			/* setup the highest link when no autoneg */
+			if (!autoneg) {
+				if (speed & TXGBE_LINK_SPEED_10GB_FULL)
+					speed = TXGBE_LINK_SPEED_10GB_FULL;
+			}
+		}
+	}
+
+	TCALL(hw, mac.ops.setup_link, speed, false);
+
+	adapter->flags |= TXGBE_FLAG_NEED_LINK_UPDATE;
+	adapter->link_check_timeout = jiffies;
+	clear_bit(__TXGBE_IN_SFP_INIT, &adapter->state);
+}
+
 /**
  * txgbe_service_timer - Timer Call-back
  * @data: pointer to adapter cast into an unsigned long
@@ -363,8 +793,17 @@ static void txgbe_service_timer(struct timer_list *t)
 {
 	struct txgbe_adapter *adapter = from_timer(adapter, t, service_timer);
 	unsigned long next_event_offset;
+	struct txgbe_hw *hw = &adapter->hw;
 
-	next_event_offset = HZ * 2;
+	/* poll faster when waiting for link */
+	if (adapter->flags & TXGBE_FLAG_NEED_LINK_UPDATE) {
+		if ((hw->subsystem_device_id & 0xF0) == TXGBE_ID_KR_KX_KX4)
+			next_event_offset = HZ;
+		else
+			next_event_offset = HZ / 10;
+	} else {
+		next_event_offset = HZ * 2;
+	}
 
 	/* Reset the timer */
 	mod_timer(&adapter->service_timer, next_event_offset + jiffies);
@@ -391,6 +830,10 @@ static void txgbe_service_task(struct work_struct *work)
 		return;
 	}
 
+	txgbe_sfp_detection_subtask(adapter);
+	txgbe_sfp_link_config_subtask(adapter);
+	txgbe_watchdog_subtask(adapter);
+
 	txgbe_service_event_complete(adapter);
 }
 
@@ -440,6 +883,16 @@ static int txgbe_del_sanmac_netdev(struct net_device *dev)
 	return err;
 }
 
+static const struct net_device_ops txgbe_netdev_ops = {
+	.ndo_open               = txgbe_open,
+	.ndo_stop               = txgbe_close,
+};
+
+void txgbe_assign_netdev_ops(struct net_device *dev)
+{
+	dev->netdev_ops = &txgbe_netdev_ops;
+}
+
 /**
  * txgbe_probe - Device Initialization Routine
  * @pdev: PCI device information struct
@@ -457,6 +910,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	struct net_device *netdev;
 	struct txgbe_adapter *adapter = NULL;
 	struct txgbe_hw *hw = NULL;
+	static int cards_found;
 	int err, pci_using_dac, expected_gts;
 	u16 offset = 0;
 	u16 eeprom_verh = 0, eeprom_verl = 0;
@@ -540,6 +994,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 		goto err_ioremap;
 	}
 
+	txgbe_assign_netdev_ops(netdev);
 	netdev->watchdog_timeo = 5 * HZ;
 	strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
 
@@ -559,7 +1014,13 @@ static int txgbe_probe(struct pci_dev *pdev,
 		goto err_sw_init;
 
 	err = TCALL(hw, mac.ops.reset_hw);
-	if (err) {
+	if (err == TXGBE_ERR_SFP_NOT_PRESENT) {
+		err = 0;
+	} else if (err == TXGBE_ERR_SFP_NOT_SUPPORTED) {
+		txgbe_dev_err("failed to load because an unsupported SFP+ module type was detected.\n");
+		txgbe_dev_err("Reload the driver after installing a supported module.\n");
+		goto err_sw_init;
+	} else if (err) {
 		txgbe_dev_err("HW Init failed: %d\n", err);
 		goto err_sw_init;
 	}
@@ -647,6 +1108,10 @@ static int txgbe_probe(struct pci_dev *pdev,
 	pci_set_drvdata(pdev, adapter);
 	adapter->netdev_registered = true;
 
+	if (!((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP))
+		/* power down the optics for SFP+ fiber */
+		TCALL(hw, mac.ops.disable_tx_laser);
+
 	/* carrier off reporting is important to ethtool even BEFORE open */
 	netif_carrier_off(netdev);
 
@@ -670,8 +1135,14 @@ static int txgbe_probe(struct pci_dev *pdev,
 	/* First try to read PBA as a string */
 	err = txgbe_read_pba_string(hw, part_str, TXGBE_PBANUM_LENGTH);
 	if (err)
-
 		strncpy(part_str, "Unknown", TXGBE_PBANUM_LENGTH);
+	if (txgbe_is_sfp(hw) && hw->phy.sfp_type != txgbe_sfp_type_not_present)
+		txgbe_info(probe, "PHY: %d, SFP+: %d, PBA No: %s\n",
+			   hw->phy.type, hw->phy.sfp_type, part_str);
+	else
+		txgbe_info(probe, "PHY: %d, PBA No: %s\n",
+			   hw->phy.type, part_str);
+
 	txgbe_dev_info("%02x:%02x:%02x:%02x:%02x:%02x\n",
 		       netdev->dev_addr[0], netdev->dev_addr[1],
 		       netdev->dev_addr[2], netdev->dev_addr[3],
@@ -683,7 +1154,20 @@ static int txgbe_probe(struct pci_dev *pdev,
 	/* add san mac addr to netdev */
 	txgbe_add_sanmac_netdev(netdev);
 
+	txgbe_info(probe, "WangXun(R) 10 Gigabit Network Connection\n");
+	cards_found++;
+
+	/* setup link for SFP devices with MNG FW, else wait for TXGBE_UP */
+	if (txgbe_mng_present(hw) && txgbe_is_sfp(hw) &&
+	    ((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP))
+		TCALL(hw, mac.ops.setup_link,
+		      TXGBE_LINK_SPEED_10GB_FULL | TXGBE_LINK_SPEED_1GB_FULL,
+		      true);
+
+	return 0;
+
 err_register:
+	txgbe_release_hw_control(adapter);
 err_sw_init:
 	kfree(adapter->mac_table);
 	iounmap(adapter->io_addr);
@@ -731,6 +1215,8 @@ static void txgbe_remove(struct pci_dev *pdev)
 		adapter->netdev_registered = false;
 	}
 
+	txgbe_release_hw_control(adapter);
+
 	iounmap(adapter->io_addr);
 	pci_release_selected_regions(pdev,
 				     pci_select_bars(pdev, IORESOURCE_MEM));
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
new file mode 100644
index 000000000000..bd4c5e117358
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -0,0 +1,401 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2015 - 2017 Beijing WangXun Technology Co., Ltd. */
+
+#include "txgbe_phy.h"
+
+/**
+ * txgbe_check_reset_blocked - check status of MNG FW veto bit
+ * @hw: pointer to the hardware structure
+ *
+ * This function checks the MMNGC.MNG_VETO bit to see if there are
+ * any constraints on link from manageability.  For MAC's that don't
+ * have this bit just return faluse since the link can not be blocked
+ * via this method.
+ **/
+s32 txgbe_check_reset_blocked(struct txgbe_hw *hw)
+{
+	u32 mmngc;
+
+	mmngc = rd32(hw, TXGBE_MIS_ST);
+	if (mmngc & TXGBE_MIS_ST_MNG_VETO) {
+		ERROR_REPORT1(TXGBE_ERROR_SOFTWARE,
+			      "MNG_VETO bit detected.\n");
+		return true;
+	}
+
+	return false;
+}
+
+/**
+ *  txgbe_identify_module - Identifies module type
+ *  @hw: pointer to hardware structure
+ *
+ *  Determines HW type and calls appropriate function.
+ **/
+s32 txgbe_identify_module(struct txgbe_hw *hw)
+{
+	s32 status = TXGBE_ERR_SFP_NOT_PRESENT;
+
+	switch (TCALL(hw, mac.ops.get_media_type)) {
+	case txgbe_media_type_fiber:
+		status = txgbe_identify_sfp_module(hw);
+		break;
+
+	default:
+		hw->phy.sfp_type = txgbe_sfp_type_not_present;
+		status = TXGBE_ERR_SFP_NOT_PRESENT;
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
+s32 txgbe_identify_sfp_module(struct txgbe_hw *hw)
+{
+	s32 status = TXGBE_ERR_PHY_ADDR_INVALID;
+	u32 vendor_oui = 0;
+	u8 identifier = 0;
+	u8 comp_codes_1g = 0;
+	u8 comp_codes_10g = 0;
+	u8 oui_bytes[3] = {0, 0, 0};
+	u8 cable_tech = 0;
+	u8 cable_spec = 0;
+
+	if (TCALL(hw, mac.ops.get_media_type) != txgbe_media_type_fiber) {
+		hw->phy.sfp_type = txgbe_sfp_type_not_present;
+		status = TXGBE_ERR_SFP_NOT_PRESENT;
+		goto out;
+	}
+
+	/* LAN ID is needed for I2C access */
+	txgbe_init_i2c(hw);
+	status = TCALL(hw, phy.ops.read_i2c_eeprom,
+		       TXGBE_SFF_IDENTIFIER,
+		       &identifier);
+
+	if (status != 0)
+		goto err_read_i2c_eeprom;
+
+	if (identifier != TXGBE_SFF_IDENTIFIER_SFP) {
+		hw->phy.type = txgbe_phy_sfp_unsupported;
+		status = TXGBE_ERR_SFP_NOT_SUPPORTED;
+	} else {
+		status = TCALL(hw, phy.ops.read_i2c_eeprom,
+			       TXGBE_SFF_1GBE_COMP_CODES,
+			       &comp_codes_1g);
+
+		if (status != 0)
+			goto err_read_i2c_eeprom;
+
+		status = TCALL(hw, phy.ops.read_i2c_eeprom,
+			       TXGBE_SFF_10GBE_COMP_CODES,
+			       &comp_codes_10g);
+
+		if (status != 0)
+			goto err_read_i2c_eeprom;
+		status = TCALL(hw, phy.ops.read_i2c_eeprom,
+			       TXGBE_SFF_CABLE_TECHNOLOGY,
+			       &cable_tech);
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
+		{
+			if (cable_tech & TXGBE_SFF_DA_PASSIVE_CABLE) {
+				if (hw->bus.lan_id == 0)
+					hw->phy.sfp_type =
+						     txgbe_sfp_type_da_cu_core0;
+				else
+					hw->phy.sfp_type =
+						     txgbe_sfp_type_da_cu_core1;
+			} else if (cable_tech & TXGBE_SFF_DA_ACTIVE_CABLE) {
+				TCALL(hw, phy.ops.read_i2c_eeprom,
+				      TXGBE_SFF_CABLE_SPEC_COMP,
+				      &cable_spec);
+				if (cable_spec &
+				    TXGBE_SFF_DA_SPEC_ACTIVE_LIMITING) {
+					if (hw->bus.lan_id == 0)
+						hw->phy.sfp_type =
+						txgbe_sfp_type_da_act_lmt_core0;
+					else
+						hw->phy.sfp_type =
+						txgbe_sfp_type_da_act_lmt_core1;
+				} else {
+					hw->phy.sfp_type =
+							txgbe_sfp_type_unknown;
+				}
+			} else if (comp_codes_10g &
+				   (TXGBE_SFF_10GBASESR_CAPABLE |
+				    TXGBE_SFF_10GBASELR_CAPABLE)) {
+				if (hw->bus.lan_id == 0)
+					hw->phy.sfp_type =
+						      txgbe_sfp_type_srlr_core0;
+				else
+					hw->phy.sfp_type =
+						      txgbe_sfp_type_srlr_core1;
+			} else if (comp_codes_1g & TXGBE_SFF_1GBASET_CAPABLE) {
+				if (hw->bus.lan_id == 0)
+					hw->phy.sfp_type =
+						txgbe_sfp_type_1g_cu_core0;
+				else
+					hw->phy.sfp_type =
+						txgbe_sfp_type_1g_cu_core1;
+			} else if (comp_codes_1g & TXGBE_SFF_1GBASESX_CAPABLE) {
+				if (hw->bus.lan_id == 0)
+					hw->phy.sfp_type =
+						txgbe_sfp_type_1g_sx_core0;
+				else
+					hw->phy.sfp_type =
+						txgbe_sfp_type_1g_sx_core1;
+			} else if (comp_codes_1g & TXGBE_SFF_1GBASELX_CAPABLE) {
+				if (hw->bus.lan_id == 0)
+					hw->phy.sfp_type =
+						txgbe_sfp_type_1g_lx_core0;
+				else
+					hw->phy.sfp_type =
+						txgbe_sfp_type_1g_lx_core1;
+			} else {
+				hw->phy.sfp_type = txgbe_sfp_type_unknown;
+			}
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
+			status = TCALL(hw, phy.ops.read_i2c_eeprom,
+				       TXGBE_SFF_VENDOR_OUI_BYTE0,
+				       &oui_bytes[0]);
+
+			if (status != 0)
+				goto err_read_i2c_eeprom;
+
+			status = TCALL(hw, phy.ops.read_i2c_eeprom,
+				       TXGBE_SFF_VENDOR_OUI_BYTE1,
+				       &oui_bytes[1]);
+
+			if (status != 0)
+				goto err_read_i2c_eeprom;
+
+			status = TCALL(hw, phy.ops.read_i2c_eeprom,
+				       TXGBE_SFF_VENDOR_OUI_BYTE2,
+				       &oui_bytes[2]);
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
+			status = TXGBE_ERR_SFP_NOT_SUPPORTED;
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
+	return TXGBE_ERR_SFP_NOT_PRESENT;
+}
+
+s32 txgbe_init_i2c(struct txgbe_hw *hw)
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
+	return 0;
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
+s32 txgbe_read_i2c_eeprom(struct txgbe_hw *hw, u8 byte_offset,
+			  u8 *eeprom_data)
+{
+	return TCALL(hw, phy.ops.read_i2c_byte, byte_offset,
+		     TXGBE_I2C_EEPROM_DEV_ADDR,
+		     eeprom_data);
+}
+
+/**
+ *  txgbe_read_i2c_byte_int - Reads 8 bit word over I2C
+ *  @hw: pointer to hardware structure
+ *  @byte_offset: byte offset to read
+ *  @data: value read
+ *  @lock: true if to take and release semaphore
+ *
+ *  Performs byte read operation to SFP module's EEPROM over I2C interface at
+ *  a specified device address.
+ **/
+static s32 txgbe_read_i2c_byte_int(struct txgbe_hw *hw, u8 byte_offset,
+				   u8 __maybe_unused dev_addr, u8 *data, bool lock)
+{
+	s32 status = 0;
+	u32 swfw_mask = hw->phy.phy_semaphore_mask;
+
+	if (lock && 0 != TCALL(hw, mac.ops.acquire_swfw_sync, swfw_mask))
+		return TXGBE_ERR_SWFW_SYNC;
+
+	/* wait tx empty */
+	status = po32m(hw, TXGBE_I2C_RAW_INTR_STAT,
+		       TXGBE_I2C_INTR_STAT_TX_EMPTY,
+		       TXGBE_I2C_INTR_STAT_TX_EMPTY,
+		       TXGBE_I2C_TIMEOUT, 10);
+	if (status != 0)
+		goto out;
+
+	/* read data */
+	wr32(hw, TXGBE_I2C_DATA_CMD,
+	     byte_offset | TXGBE_I2C_DATA_CMD_STOP);
+	wr32(hw, TXGBE_I2C_DATA_CMD, TXGBE_I2C_DATA_CMD_READ);
+
+	/* wait for read complete */
+	status = po32m(hw, TXGBE_I2C_RAW_INTR_STAT,
+		       TXGBE_I2C_INTR_STAT_RX_FULL,
+		       TXGBE_I2C_INTR_STAT_RX_FULL,
+		       TXGBE_I2C_TIMEOUT, 10);
+	if (status != 0)
+		goto out;
+
+	*data = 0xFF & rd32(hw, TXGBE_I2C_DATA_CMD);
+
+out:
+	if (lock)
+		TCALL(hw, mac.ops.release_swfw_sync, swfw_mask);
+	return status;
+}
+
+/**
+ *  txgbe_switch_i2c_slave_addr - Switch I2C slave address
+ *  @hw: pointer to hardware structure
+ *  @dev_addr: slave addr to switch
+ *
+ **/
+s32 txgbe_switch_i2c_slave_addr(struct txgbe_hw *hw, u8 dev_addr)
+{
+	wr32(hw, TXGBE_I2C_ENABLE, 0);
+	wr32(hw, TXGBE_I2C_TAR, dev_addr >> 1);
+	wr32(hw, TXGBE_I2C_ENABLE, 1);
+	return 0;
+}
+
+/**
+ *  txgbe_read_i2c_byte - Reads 8 bit word over I2C
+ *  @hw: pointer to hardware structure
+ *  @byte_offset: byte offset to read
+ *  @data: value read
+ *
+ *  Performs byte read operation to SFP module's EEPROM over I2C interface at
+ *  a specified device address.
+ **/
+s32 txgbe_read_i2c_byte(struct txgbe_hw *hw, u8 byte_offset,
+			u8 dev_addr, u8 *data)
+{
+	txgbe_switch_i2c_slave_addr(hw, dev_addr);
+
+	return txgbe_read_i2c_byte_int(hw, byte_offset, dev_addr,
+				       data, true);
+}
+
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
new file mode 100644
index 000000000000..4798623fb735
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2015 - 2017 Beijing WangXun Technology Co., Ltd. */
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
+s32 txgbe_check_reset_blocked(struct txgbe_hw *hw);
+
+s32 txgbe_identify_module(struct txgbe_hw *hw);
+s32 txgbe_identify_sfp_module(struct txgbe_hw *hw);
+s32 txgbe_init_i2c(struct txgbe_hw *hw);
+s32 txgbe_switch_i2c_slave_addr(struct txgbe_hw *hw, u8 dev_addr);
+s32 txgbe_read_i2c_byte(struct txgbe_hw *hw, u8 byte_offset,
+			u8 dev_addr, u8 *data);
+
+s32 txgbe_read_i2c_eeprom(struct txgbe_hw *hw, u8 byte_offset,
+			  u8 *eeprom_data);
+
+#endif /* _TXGBE_PHY_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index e1b438e18edc..c068fa933ab6 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -72,6 +72,149 @@
 
 /* Revision ID */
 #define TXGBE_SP_MPW  1
+/* ETH PHY Registers */
+#define TXGBE_SR_XS_PCS_MMD_STATUS1             0x30001
+#define TXGBE_SR_PCS_CTL2                       0x30007
+#define TXGBE_SR_PMA_MMD_CTL1                   0x10000
+#define TXGBE_SR_MII_MMD_CTL                    0x1F0000
+#define TXGBE_SR_MII_MMD_DIGI_CTL               0x1F8000
+#define TXGBE_SR_MII_MMD_AN_CTL                 0x1F8001
+#define TXGBE_SR_MII_MMD_AN_ADV                 0x1F0004
+#define TXGBE_SR_MII_MMD_AN_ADV_PAUSE(_v)       ((0x3 & (_v)) << 7)
+#define TXGBE_SR_MII_MMD_AN_ADV_PAUSE_ASM       0x80
+#define TXGBE_SR_MII_MMD_AN_ADV_PAUSE_SYM       0x100
+#define TXGBE_SR_MII_MMD_LP_BABL                0x1F0005
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
+#define TXGBE_PHY_MPLLA_CTL0                    0x18071
+#define TXGBE_PHY_MPLLA_CTL3                    0x18077
+#define TXGBE_PHY_MISC_CTL0                     0x18090
+#define TXGBE_PHY_VCO_CAL_LD0                   0x18092
+#define TXGBE_PHY_VCO_CAL_LD1                   0x18093
+#define TXGBE_PHY_VCO_CAL_LD2                   0x18094
+#define TXGBE_PHY_VCO_CAL_LD3                   0x18095
+#define TXGBE_PHY_VCO_CAL_REF0                  0x18096
+#define TXGBE_PHY_VCO_CAL_REF1                  0x18097
+#define TXGBE_PHY_RX_AD_ACK                     0x18098
+#define TXGBE_PHY_AFE_DFE_ENABLE                0x1805D
+#define TXGBE_PHY_DFE_TAP_CTL0                  0x1805E
+#define TXGBE_PHY_RX_EQ_ATT_LVL0                0x18057
+#define TXGBE_PHY_RX_EQ_CTL0                    0x18058
+#define TXGBE_PHY_RX_EQ_CTL                     0x1805C
+#define TXGBE_PHY_TX_EQ_CTL0                    0x18036
+#define TXGBE_PHY_TX_EQ_CTL1                    0x18037
+#define TXGBE_PHY_TX_RATE_CTL                   0x18034
+#define TXGBE_PHY_RX_RATE_CTL                   0x18054
+#define TXGBE_PHY_TX_GEN_CTL2                   0x18032
+#define TXGBE_PHY_RX_GEN_CTL2                   0x18052
+#define TXGBE_PHY_RX_GEN_CTL3                   0x18053
+#define TXGBE_PHY_MPLLA_CTL2                    0x18073
+#define TXGBE_PHY_RX_POWER_ST_CTL               0x18055
+#define TXGBE_PHY_TX_POWER_ST_CTL               0x18035
+#define TXGBE_PHY_TX_GENCTRL1                   0x18031
+
+#define TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_R        0x0
+#define TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_X        0x1
+#define TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_MASK     0x3
+#define TXGBE_SR_PMA_MMD_CTL1_SPEED_SEL_1G      0x0
+#define TXGBE_SR_PMA_MMD_CTL1_SPEED_SEL_10G     0x2000
+#define TXGBE_SR_PMA_MMD_CTL1_SPEED_SEL_MASK    0x2000
+#define TXGBE_SR_PMA_MMD_CTL1_LB_EN             0x1
+#define TXGBE_SR_MII_MMD_CTL_AN_EN              0x1000
+#define TXGBE_SR_MII_MMD_CTL_RESTART_AN         0x0200
+#define TXGBE_SR_AN_MMD_CTL_RESTART_AN          0x0200
+#define TXGBE_SR_AN_MMD_CTL_ENABLE              0x1000
+#define TXGBE_SR_AN_MMD_ADV_REG2_BP_TYPE_KX4    0x40
+#define TXGBE_SR_AN_MMD_ADV_REG2_BP_TYPE_KX     0x20
+#define TXGBE_SR_AN_MMD_ADV_REG2_BP_TYPE_KR     0x80
+#define TXGBE_SR_AN_MMD_ADV_REG2_BP_TYPE_MASK   0xFFFF
+#define TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1_ENABLE 0x1000
+#define TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1_VR_RST 0x8000
+#define TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_MASK            0x1C
+#define TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_POWER_GOOD      0x10
+
+#define TXGBE_PHY_MPLLA_CTL0_MULTIPLIER_1GBASEX_KX              32
+#define TXGBE_PHY_MPLLA_CTL0_MULTIPLIER_10GBASER_KR             33
+#define TXGBE_PHY_MPLLA_CTL0_MULTIPLIER_OTHER                   40
+#define TXGBE_PHY_MPLLA_CTL0_MULTIPLIER_MASK                    0xFF
+#define TXGBE_PHY_MPLLA_CTL3_MULTIPLIER_BW_1GBASEX_KX           0x56
+#define TXGBE_PHY_MPLLA_CTL3_MULTIPLIER_BW_10GBASER_KR          0x7B
+#define TXGBE_PHY_MPLLA_CTL3_MULTIPLIER_BW_OTHER                0x56
+#define TXGBE_PHY_MPLLA_CTL3_MULTIPLIER_BW_MASK                 0x7FF
+#define TXGBE_PHY_MISC_CTL0_TX2RX_LB_EN_0                       0x1
+#define TXGBE_PHY_MISC_CTL0_TX2RX_LB_EN_3_1                     0xE
+#define TXGBE_PHY_MISC_CTL0_RX_VREF_CTRL                        0x1F00
+#define TXGBE_PHY_VCO_CAL_LD0_1GBASEX_KX                        1344
+#define TXGBE_PHY_VCO_CAL_LD0_10GBASER_KR                       1353
+#define TXGBE_PHY_VCO_CAL_LD0_OTHER                             1360
+#define TXGBE_PHY_VCO_CAL_LD0_MASK                              0x1000
+#define TXGBE_PHY_VCO_CAL_REF0_LD0_1GBASEX_KX                   42
+#define TXGBE_PHY_VCO_CAL_REF0_LD0_10GBASER_KR                  41
+#define TXGBE_PHY_VCO_CAL_REF0_LD0_OTHER                        34
+#define TXGBE_PHY_VCO_CAL_REF0_LD0_MASK                         0x3F
+#define TXGBE_PHY_AFE_DFE_ENABLE_DFE_EN0                        0x10
+#define TXGBE_PHY_AFE_DFE_ENABLE_AFE_EN0                        0x1
+#define TXGBE_PHY_AFE_DFE_ENABLE_MASK                           0xFF
+#define TXGBE_PHY_RX_EQ_CTL_CONT_ADAPT0                         0x1
+#define TXGBE_PHY_RX_EQ_CTL_CONT_ADAPT_MASK                     0xF
+#define TXGBE_PHY_TX_RATE_CTL_TX0_RATE_10GBASER_KR              0x0
+#define TXGBE_PHY_TX_RATE_CTL_TX0_RATE_RXAUI                    0x1
+#define TXGBE_PHY_TX_RATE_CTL_TX0_RATE_1GBASEX_KX               0x3
+#define TXGBE_PHY_TX_RATE_CTL_TX0_RATE_OTHER                    0x2
+#define TXGBE_PHY_TX_RATE_CTL_TX1_RATE_OTHER                    0x20
+#define TXGBE_PHY_TX_RATE_CTL_TX2_RATE_OTHER                    0x200
+#define TXGBE_PHY_TX_RATE_CTL_TX3_RATE_OTHER                    0x2000
+#define TXGBE_PHY_TX_RATE_CTL_TX0_RATE_MASK                     0x7
+#define TXGBE_PHY_TX_RATE_CTL_TX1_RATE_MASK                     0x70
+#define TXGBE_PHY_TX_RATE_CTL_TX2_RATE_MASK                     0x700
+#define TXGBE_PHY_TX_RATE_CTL_TX3_RATE_MASK                     0x7000
+#define TXGBE_PHY_RX_RATE_CTL_RX0_RATE_10GBASER_KR              0x0
+#define TXGBE_PHY_RX_RATE_CTL_RX0_RATE_RXAUI                    0x1
+#define TXGBE_PHY_RX_RATE_CTL_RX0_RATE_1GBASEX_KX               0x3
+#define TXGBE_PHY_RX_RATE_CTL_RX0_RATE_OTHER                    0x2
+#define TXGBE_PHY_RX_RATE_CTL_RX1_RATE_OTHER                    0x20
+#define TXGBE_PHY_RX_RATE_CTL_RX2_RATE_OTHER                    0x200
+#define TXGBE_PHY_RX_RATE_CTL_RX3_RATE_OTHER                    0x2000
+#define TXGBE_PHY_RX_RATE_CTL_RX0_RATE_MASK                     0x7
+#define TXGBE_PHY_RX_RATE_CTL_RX1_RATE_MASK                     0x70
+#define TXGBE_PHY_RX_RATE_CTL_RX2_RATE_MASK                     0x700
+#define TXGBE_PHY_RX_RATE_CTL_RX3_RATE_MASK                     0x7000
+#define TXGBE_PHY_TX_GEN_CTL2_TX0_WIDTH_10GBASER_KR             0x200
+#define TXGBE_PHY_TX_GEN_CTL2_TX0_WIDTH_10GBASER_KR_RXAUI       0x300
+#define TXGBE_PHY_TX_GEN_CTL2_TX0_WIDTH_OTHER                   0x100
+#define TXGBE_PHY_TX_GEN_CTL2_TX0_WIDTH_MASK                    0x300
+#define TXGBE_PHY_TX_GEN_CTL2_TX1_WIDTH_OTHER                   0x400
+#define TXGBE_PHY_TX_GEN_CTL2_TX1_WIDTH_MASK                    0xC00
+#define TXGBE_PHY_TX_GEN_CTL2_TX2_WIDTH_OTHER                   0x1000
+#define TXGBE_PHY_TX_GEN_CTL2_TX2_WIDTH_MASK                    0x3000
+#define TXGBE_PHY_TX_GEN_CTL2_TX3_WIDTH_OTHER                   0x4000
+#define TXGBE_PHY_TX_GEN_CTL2_TX3_WIDTH_MASK                    0xC000
+#define TXGBE_PHY_RX_GEN_CTL2_RX0_WIDTH_10GBASER_KR             0x200
+#define TXGBE_PHY_RX_GEN_CTL2_RX0_WIDTH_10GBASER_KR_RXAUI       0x300
+#define TXGBE_PHY_RX_GEN_CTL2_RX0_WIDTH_OTHER                   0x100
+#define TXGBE_PHY_RX_GEN_CTL2_RX0_WIDTH_MASK                    0x300
+#define TXGBE_PHY_RX_GEN_CTL2_RX1_WIDTH_OTHER                   0x400
+#define TXGBE_PHY_RX_GEN_CTL2_RX1_WIDTH_MASK                    0xC00
+#define TXGBE_PHY_RX_GEN_CTL2_RX2_WIDTH_OTHER                   0x1000
+#define TXGBE_PHY_RX_GEN_CTL2_RX2_WIDTH_MASK                    0x3000
+#define TXGBE_PHY_RX_GEN_CTL2_RX3_WIDTH_OTHER                   0x4000
+#define TXGBE_PHY_RX_GEN_CTL2_RX3_WIDTH_MASK                    0xC000
+
+#define TXGBE_PHY_MPLLA_CTL2_DIV_CLK_EN_8                       0x100
+#define TXGBE_PHY_MPLLA_CTL2_DIV_CLK_EN_10                      0x200
+#define TXGBE_PHY_MPLLA_CTL2_DIV_CLK_EN_16P5                    0x400
+#define TXGBE_PHY_MPLLA_CTL2_DIV_CLK_EN_MASK                    0x700
+
+#define TXGBE_XPCS_POWER_GOOD_MAX_POLLING_TIME  100
+#define TXGBE_PHY_INIT_DONE_POLLING_TIME        100
 
 /**************** Global Registers ****************************/
 /* chip control Registers */
@@ -1554,11 +1697,18 @@ enum TXGBE_MSCA_CMD_value {
 #define FW_CEM_RESP_STATUS_SUCCESS      0x1
 #define FW_READ_SHADOW_RAM_CMD          0x31
 #define FW_READ_SHADOW_RAM_LEN          0x6
+#define FW_WRITE_SHADOW_RAM_CMD         0x33
+#define FW_WRITE_SHADOW_RAM_LEN         0xA /* 8 plus 1 WORD to write */
 #define FW_DEFAULT_CHECKSUM             0xFF /* checksum always 0xFF */
 #define FW_NVM_DATA_OFFSET              3
 #define FW_MAX_READ_BUFFER_SIZE         244
 #define FW_RESET_CMD                    0xDF
 #define FW_RESET_LEN                    0x2
+#define FW_DW_OPEN_NOTIFY               0xE9
+#define FW_DW_CLOSE_NOTIFY              0xEA
+
+#define TXGBE_CHECKSUM_CAP_ST_PASS      0x80658383
+#define TXGBE_CHECKSUM_CAP_ST_FAIL      0x70657376
 
 /* Host Interface Command Structures */
 struct txgbe_hic_hdr {
@@ -1611,6 +1761,15 @@ struct txgbe_hic_read_shadow_ram {
 	u16 pad3;
 };
 
+struct txgbe_hic_write_shadow_ram {
+	union txgbe_hic_hdr2 hdr;
+	u32 address;
+	u16 length;
+	u16 pad2;
+	u16 data;
+	u16 pad3;
+};
+
 struct txgbe_hic_reset {
 	struct txgbe_hic_hdr hdr;
 	u16 lan_id;
@@ -1619,6 +1778,38 @@ struct txgbe_hic_reset {
 
 /* Number of 100 microseconds we wait for PCI Express master disable */
 #define TXGBE_PCI_MASTER_DISABLE_TIMEOUT        800
+
+/* Autonegotiation advertised speeds */
+typedef u32 txgbe_autoneg_advertised;
+/* Link speed */
+#define TXGBE_LINK_SPEED_UNKNOWN        0
+#define TXGBE_LINK_SPEED_100_FULL       1
+#define TXGBE_LINK_SPEED_1GB_FULL       2
+#define TXGBE_LINK_SPEED_10GB_FULL      4
+#define TXGBE_LINK_SPEED_10_FULL        8
+#define TXGBE_LINK_SPEED_AUTONEG  (TXGBE_LINK_SPEED_100_FULL | \
+				   TXGBE_LINK_SPEED_1GB_FULL | \
+				   TXGBE_LINK_SPEED_10GB_FULL | \
+				   TXGBE_LINK_SPEED_10_FULL)
+
+/* Physical layer type */
+typedef u32 txgbe_physical_layer;
+#define TXGBE_PHYSICAL_LAYER_UNKNOWN            0
+#define TXGBE_PHYSICAL_LAYER_10GBASE_T          0x0001
+#define TXGBE_PHYSICAL_LAYER_1000BASE_T         0x0002
+#define TXGBE_PHYSICAL_LAYER_100BASE_TX         0x0004
+#define TXGBE_PHYSICAL_LAYER_SFP_PLUS_CU        0x0008
+#define TXGBE_PHYSICAL_LAYER_10GBASE_LR         0x0010
+#define TXGBE_PHYSICAL_LAYER_10GBASE_LRM        0x0020
+#define TXGBE_PHYSICAL_LAYER_10GBASE_SR         0x0040
+#define TXGBE_PHYSICAL_LAYER_10GBASE_KX4        0x0080
+#define TXGBE_PHYSICAL_LAYER_1000BASE_KX        0x0200
+#define TXGBE_PHYSICAL_LAYER_1000BASE_BX        0x0400
+#define TXGBE_PHYSICAL_LAYER_10GBASE_KR         0x0800
+#define TXGBE_PHYSICAL_LAYER_10GBASE_XAUI       0x1000
+#define TXGBE_PHYSICAL_LAYER_SFP_ACTIVE_DA      0x2000
+#define TXGBE_PHYSICAL_LAYER_1000BASE_SX        0x4000
+
 enum txgbe_eeprom_type {
 	txgbe_eeprom_uninitialized = 0,
 	txgbe_eeprom_spi,
@@ -1626,6 +1817,66 @@ enum txgbe_eeprom_type {
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
 
 /* PCI bus types */
 enum txgbe_bus_type {
@@ -1698,6 +1949,7 @@ struct txgbe_mac_operations {
 	s32 (*init_hw)(struct txgbe_hw *hw);
 	s32 (*reset_hw)(struct txgbe_hw *hw);
 	s32 (*start_hw)(struct txgbe_hw *hw);
+	enum txgbe_media_type (*get_media_type)(struct txgbe_hw *hw);
 	s32 (*get_mac_addr)(struct txgbe_hw *hw, u8 *mac_addr);
 	s32 (*get_san_mac_addr)(struct txgbe_hw *hw, u8 *san_mac_addr);
 	s32 (*get_wwn_prefix)(struct txgbe_hw *hw, u16 *wwnn_prefix,
@@ -1708,6 +1960,24 @@ struct txgbe_mac_operations {
 	s32 (*acquire_swfw_sync)(struct txgbe_hw *hw, u32 mask);
 	void (*release_swfw_sync)(struct txgbe_hw *hw, u32 mask);
 
+	/* Link */
+	void (*disable_tx_laser)(struct txgbe_hw *hw);
+	void (*enable_tx_laser)(struct txgbe_hw *hw);
+	void (*flap_tx_laser)(struct txgbe_hw *hw);
+	s32 (*setup_link)(struct txgbe_hw *hw, u32 speed,
+			  bool autoneg_wait_to_complete);
+	s32 (*setup_mac_link)(struct txgbe_hw *hw, u32 speed,
+			      bool autoneg_wait_to_complete);
+	s32 (*check_link)(struct txgbe_hw *hw, u32 *speed,
+			  bool *link_up, bool link_up_wait_to_complete);
+	s32 (*get_link_capabilities)(struct txgbe_hw *hw, u32 *speed,
+				     bool *autoneg);
+	void (*set_rate_select_speed)(struct txgbe_hw *hw, u32 speed);
+
+	/* LED */
+	s32 (*led_on)(struct txgbe_hw *hw, u32 index);
+	s32 (*led_off)(struct txgbe_hw *hw, u32 index);
+
 	/* RAR */
 	s32 (*set_rar)(struct txgbe_hw *hw, u32 index, u8 *addr, u64 pools,
 		       u32 enable_addr);
@@ -1724,6 +1994,16 @@ struct txgbe_mac_operations {
 	void (*disable_rx)(struct txgbe_hw *hw);
 };
 
+struct txgbe_phy_operations {
+	s32 (*identify)(struct txgbe_hw *hw);
+	s32 (*identify_sfp)(struct txgbe_hw *hw);
+	s32 (*init)(struct txgbe_hw *hw);
+	s32 (*read_i2c_byte)(struct txgbe_hw *hw, u8 byte_offset,
+			     u8 dev_addr, u8 *data);
+	s32 (*read_i2c_eeprom)(struct txgbe_hw *hw, u8 byte_offset,
+			       u8 *eeprom_data);
+};
+
 struct txgbe_eeprom_info {
 	struct txgbe_eeprom_operations ops;
 	enum txgbe_eeprom_type type;
@@ -1746,23 +2026,47 @@ struct txgbe_mac_info {
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
+	txgbe_autoneg_advertised autoneg_advertised;
+	bool multispeed_fiber;
+	txgbe_physical_layer link_mode;
+};
+
 enum txgbe_reset_type {
 	TXGBE_LAN_RESET = 0,
 	TXGBE_SW_RESET,
 	TXGBE_GLOBAL_RESET
 };
 
+enum txgbe_link_status {
+	TXGBE_LINK_STATUS_NONE = 0,
+	TXGBE_LINK_STATUS_KX,
+	TXGBE_LINK_STATUS_KX4
+};
+
 struct txgbe_hw {
 	u8 __iomem *hw_addr;
 	void *back;
 	struct txgbe_mac_info mac;
 	struct txgbe_addr_filter_info addr_ctrl;
+	struct txgbe_phy_info phy;
 	struct txgbe_eeprom_info eeprom;
 	struct txgbe_bus_info bus;
 	u16 device_id;
@@ -1773,6 +2077,7 @@ struct txgbe_hw {
 	bool adapter_stopped;
 	enum txgbe_reset_type reset_type;
 	bool force_full_reset;
+	enum txgbe_link_status link_status;
 	u16 subsystem_id;
 };
 
@@ -1923,6 +2228,33 @@ wr32m(struct txgbe_hw *hw, u32 reg, u32 mask, u32 field)
 	txgbe_wr32(base + reg, val);
 }
 
+/* poll register */
+#define TXGBE_I2C_TIMEOUT  1000
+static inline s32
+po32m(struct txgbe_hw *hw, u32 reg, u32 mask,
+	u32 field, int usecs, int count)
+{
+	int loop;
+
+	loop = (count ? count : (usecs + 9) / 10);
+	usecs = (loop ? (usecs + loop - 1) / loop : 0);
+
+	count = loop;
+	do {
+		u32 value = rd32(hw, reg);
+
+		if ((value & mask) == (field & mask))
+			break;
+
+		if (loop-- <= 0)
+			break;
+
+		udelay(usecs);
+	} while (true);
+
+	return (count - loop <= count ? 0 : TXGBE_ERR_TIMEOUT);
+}
+
 #define TXGBE_WRITE_FLUSH(H) rd32(H, TXGBE_MIS_PWR)
 
 #endif /* _TXGBE_TYPE_H_ */
-- 
2.27.0



