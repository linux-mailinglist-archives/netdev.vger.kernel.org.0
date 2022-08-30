Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A445A5C88
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbiH3HHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiH3HHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:07:13 -0400
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF87C6CC9
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:06:47 -0700 (PDT)
X-QQ-mid: bizesmtp76t1661843138tyjqy4u8
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 30 Aug 2022 15:05:38 +0800 (CST)
X-QQ-SSF: 01400000000000G0T000B00A0000000
X-QQ-FEAT: +ynUkgUhZJkoNiMhjbUnqkXiD+E/PAMY6JKJic4M/m98OcrFRNnFwFNbjS7yU
        OxwvCtNTzkxv2kRCvCfJ0v884j6nt6e4Jj4L+JJUCVTdMTJdY7v4HyTLTfdTczTGA/xqbCB
        /irx/qd5fLpuAYQSCc66XTeNni+uf1UuqRPOHJTxfgeI061dN5fbpRxBcHuACKa2ZIMTCP2
        zDLj/l3oxtNatjqkM6tFDwS4hwzqzgnMaRbOt/urB3r7uM4eMPLiS950xbiz7AGUYJwXW77
        GwzERAEtqn5XlLFhZw98mVcZkyhtOZXKS1GGO+sxVZZGSF6r2VdzShBP1jKkjNHBL/YS6Bj
        zGGnp6+okkl1Aqh7M0nYCC3UOAjm/XJL+DwVXeyt6oUCBEJONv9VImrr0MmOYQsk9Tsdiw9
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v2 07/16] net: txgbe: Support to setup link
Date:   Tue, 30 Aug 2022 15:04:45 +0800
Message-Id: <20220830070454.146211-8-jiawenwu@trustnetic.com>
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

Get link capabilities, setup MAC and PHY link, and support to enable
or disable Tx laser.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 .../device_drivers/ethernet/wangxun/txgbe.rst |    5 +
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |   25 +
 .../net/ethernet/wangxun/txgbe/txgbe_dummy.h  |   47 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 1232 ++++++++++++++++-
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   18 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  355 ++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  198 +++
 7 files changed, 1876 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst b/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
index 037d8538e848..3c7656057c69 100644
--- a/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
+++ b/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
@@ -51,6 +51,11 @@ The following is a list of 3rd party SFP+ modules that have been tested and veri
 | WTD      | SFP+                 | RTXM228-551          |
 +----------+----------------------+----------------------+
 
+Laser turns off for SFP+ when ifconfig ethX down
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+"ifconfig ethX down" turns off the laser for SFP+ fiber adapters.
+"ifconfig ethX up" turns on the laser.
+
 
 Support
 =======
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index d45aa8eea9dd..374d9b715882 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -6,6 +6,7 @@
 
 #include <net/ip.h>
 #include <linux/etherdevice.h>
+#include <linux/timecounter.h>
 
 #include "txgbe_type.h"
 
@@ -28,6 +29,22 @@ struct txgbe_mac_addr {
 #define TXGBE_MAC_STATE_MODIFIED        0x2
 #define TXGBE_MAC_STATE_IN_USE          0x4
 
+/* default to trying for four seconds */
+#define TXGBE_TRY_LINK_TIMEOUT  (4 * HZ)
+#define TXGBE_SFP_POLL_JIFFIES  (2 * HZ)        /* SFP poll every 2 seconds */
+
+/**
+ * txgbe_adapter.flag
+ **/
+#define TXGBE_FLAG_NEED_LINK_UPDATE             BIT(0)
+#define TXGBE_FLAG_NEED_LINK_CONFIG             BIT(1)
+
+/**
+ * txgbe_adapter.flag2
+ **/
+#define TXGBE_FLAG2_MNG_REG_ACCESS_DISABLED     BIT(0)
+#define TXGBE_FLAG2_SFP_NEEDS_RESET             BIT(1)
+
 /* board specific private data structure */
 struct txgbe_adapter {
 	u8 __iomem *io_addr;    /* Mainly for iounmap use */
@@ -37,6 +54,8 @@ struct txgbe_adapter {
 
 	unsigned long state;
 
+	u32 flags;
+	u32 flags2;
 	/* Tx fast path data */
 	int num_tx_queues;
 
@@ -47,6 +66,11 @@ struct txgbe_adapter {
 	struct txgbe_hw hw;
 	u16 msg_enable;
 
+	u32 link_speed;
+	bool link_up;
+	unsigned long sfp_poll_time;
+	unsigned long link_check_timeout;
+
 	struct timer_list service_timer;
 	struct work_struct service_task;
 
@@ -66,6 +90,7 @@ enum txgbe_state_t {
 	__TXGBE_REMOVING,
 	__TXGBE_SERVICE_SCHED,
 	__TXGBE_SERVICE_INITED,
+	__TXGBE_IN_SFP_INIT,
 };
 
 /* needed by txgbe_main.c */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
index de96f5fbf014..202e80d1b2ff 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
@@ -121,6 +121,35 @@ static void txgbe_init_uta_tables_dummy(struct txgbe_hw *TUP0)
 {
 }
 
+static int txgbe_get_link_capabilities_dummy(struct txgbe_hw *TUP0,
+					     u32 *TUP1, bool *TUP2)
+{
+	return -EPERM;
+}
+
+static void txgbe_check_mac_link_dummy(struct txgbe_hw *TUP0, u32 *TUP1,
+				       bool *TUP3, bool TUP4)
+{
+}
+
+static int txgbe_setup_link_dummy(struct txgbe_hw *TUP0, u32 TUP1, bool TUP2)
+{
+	return -EPERM;
+}
+
+static int txgbe_setup_mac_link_dummy(struct txgbe_hw *TUP0, u32 TUP1, bool TUP2)
+{
+	return -EPERM;
+}
+
+static void txgbe_flap_tx_laser_multispeed_fiber_dummy(struct txgbe_hw *TUP0)
+{
+}
+
+static void txgbe_set_hard_rate_select_speed_dummy(struct txgbe_hw *TUP0, u32 TUP1)
+{
+}
+
 static int txgbe_set_fw_drv_ver_dummy(struct txgbe_hw *TUP0, u8 TUP1,
 				      u8 TUP2, u8 TUP3, u8 TUP4)
 {
@@ -131,6 +160,14 @@ static void txgbe_init_thermal_sensor_thresh_dummy(struct txgbe_hw *TUP0)
 {
 }
 
+static void txgbe_disable_tx_laser_multispeed_fiber_dummy(struct txgbe_hw *TUP0)
+{
+}
+
+static void txgbe_enable_tx_laser_multispeed_fiber_dummy(struct txgbe_hw *TUP0)
+{
+}
+
 /* struct txgbe_eeprom_operations */
 static void txgbe_init_eeprom_params_dummy(struct txgbe_hw *TUP0)
 {
@@ -191,6 +228,16 @@ static void txgbe_init_ops_dummy(struct txgbe_hw *hw)
 	mac->ops.set_vmdq_san_mac = txgbe_set_vmdq_san_mac_dummy;
 	mac->ops.init_uta_tables = txgbe_init_uta_tables_dummy;
 
+	/* Link */
+	mac->ops.disable_tx_laser = txgbe_disable_tx_laser_multispeed_fiber_dummy;
+	mac->ops.enable_tx_laser = txgbe_enable_tx_laser_multispeed_fiber_dummy;
+	mac->ops.get_link_capabilities = txgbe_get_link_capabilities_dummy;
+	mac->ops.check_link = txgbe_check_mac_link_dummy;
+	mac->ops.setup_link = txgbe_setup_link_dummy;
+	mac->ops.setup_mac_link = txgbe_setup_mac_link_dummy;
+	mac->ops.flap_tx_laser = txgbe_flap_tx_laser_multispeed_fiber_dummy;
+	mac->ops.set_rate_select_speed = txgbe_set_hard_rate_select_speed_dummy;
+
 	/* EEPROM */
 	eeprom->ops.init_params = txgbe_init_eeprom_params_dummy;
 	eeprom->ops.calc_checksum = txgbe_calc_eeprom_checksum_dummy;
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index 89736857d2fd..7920bcf6a965 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -29,6 +29,34 @@ u32 txgbe_rd32_epcs(struct txgbe_hw *hw, u32 addr)
 	return data;
 }
 
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
 int txgbe_init_hw(struct txgbe_hw *hw)
 {
 	int status;
@@ -992,10 +1020,12 @@ int txgbe_reset_hostif(struct txgbe_hw *hw)
 			continue;
 
 		if (reset_cmd.hdr.cmd_or_resp.ret_status ==
-		    FW_CEM_RESP_STATUS_SUCCESS)
+		    FW_CEM_RESP_STATUS_SUCCESS) {
 			ret_val = 0;
-		else
+			hw->link_status = TXGBE_LINK_STATUS_NONE;
+		} else {
 			ret_val = -EFAULT;
+		}
 
 		break;
 	}
@@ -1107,6 +1137,124 @@ bool txgbe_check_mng_access(struct txgbe_hw *hw)
 	return true;
 }
 
+/**
+ *  txgbe_setup_mac_link_multispeed_fiber - Set MAC link speed
+ *  @hw: pointer to hardware structure
+ *  @speed: new link speed
+ *  @autoneg_wait_to_complete: true when waiting for completion is needed
+ *
+ *  Set the link speed in the MAC and/or PHY register and restarts link.
+ **/
+int txgbe_setup_mac_link_multispeed_fiber(struct txgbe_hw *hw,
+					  u32 speed,
+					  bool autoneg_wait_to_complete)
+{
+	u32 highest_link_speed = TXGBE_LINK_SPEED_UNKNOWN;
+	u32 link_speed = TXGBE_LINK_SPEED_UNKNOWN;
+	bool autoneg, link_up = false;
+	u32 speedcnt = 0;
+	int status = 0;
+	u32 i = 0;
+
+	/* Mask off requested but non-supported speeds */
+	status = hw->mac.ops.get_link_capabilities(hw, &link_speed, &autoneg);
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
+		hw->mac.ops.check_link(hw, &link_speed, &link_up, false);
+		if (link_speed == TXGBE_LINK_SPEED_10GB_FULL && link_up)
+			goto out;
+
+		/* Allow module to change analog characteristics (1G->10G) */
+		msleep(40);
+
+		status = hw->mac.ops.setup_mac_link(hw,
+						    TXGBE_LINK_SPEED_10GB_FULL,
+						    autoneg_wait_to_complete);
+		if (status != 0)
+			return status;
+
+		/* Flap the Tx laser if it has not already been done */
+		hw->mac.ops.flap_tx_laser(hw);
+
+		/* Wait for the controller to acquire link.  Per IEEE 802.3ap,
+		 * Section 73.10.2, we may have to wait up to 500ms if KR is
+		 * attempted.  sapphire uses the same timing for 10g SFI.
+		 */
+		for (i = 0; i < 5; i++) {
+			/* Wait for the link partner to also set speed */
+			msleep(100);
+
+			/* If we have link, just jump out */
+			hw->mac.ops.check_link(hw, &link_speed, &link_up, false);
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
+		hw->mac.ops.check_link(hw, &link_speed, &link_up, false);
+		if (link_speed == TXGBE_LINK_SPEED_1GB_FULL && link_up)
+			goto out;
+
+		/* Allow module to change analog characteristics (10G->1G) */
+		msleep(40);
+
+		status = hw->mac.ops.setup_mac_link(hw,
+						    TXGBE_LINK_SPEED_1GB_FULL,
+						    autoneg_wait_to_complete);
+		if (status != 0)
+			return status;
+
+		/* Flap the Tx laser if it has not already been done */
+		hw->mac.ops.flap_tx_laser(hw);
+
+		/* Wait for the link partner to also set speed */
+		msleep(100);
+
+		/* If we have link, just jump out */
+		hw->mac.ops.check_link(hw, &link_speed, &link_up, false);
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
 	u32 i = 0, reg = 0;
@@ -1132,11 +1280,41 @@ int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit)
 	return err;
 }
 
+void txgbe_init_mac_link_ops(struct txgbe_hw *hw)
+{
+	struct txgbe_mac_info *mac = &hw->mac;
+
+	/* enable the laser control functions for SFP+ fiber
+	 * and MNG not enabled
+	 */
+	if (hw->phy.media_type == txgbe_media_type_fiber) {
+		mac->ops.disable_tx_laser = txgbe_disable_tx_laser_multispeed_fiber;
+		mac->ops.enable_tx_laser = txgbe_enable_tx_laser_multispeed_fiber;
+		mac->ops.flap_tx_laser = txgbe_flap_tx_laser_multispeed_fiber;
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
 /**
  *  txgbe_init_phy_ops - PHY/SFP specific init
  *  @hw: pointer to hardware structure
  *
- *  Perform the SFP init if necessary.
+ *  Initialize any function pointers that were not able to be
+ *  set during init_shared_code because the PHY/SFP type was
+ *  not known. Perform the SFP init if necessary.
  **/
 int txgbe_init_phy_ops(struct txgbe_hw *hw)
 {
@@ -1145,6 +1323,11 @@ int txgbe_init_phy_ops(struct txgbe_hw *hw)
 	txgbe_init_i2c(hw);
 	/* Identify the PHY or SFP module */
 	ret_val = hw->phy.ops.identify(hw);
+	if (ret_val != 0 && hw->phy.type == txgbe_phy_sfp_unsupported)
+		return ret_val;
+
+	/* Setup function pointers based on detected SFP module and speeds */
+	txgbe_init_mac_link_ops(hw);
 
 	return ret_val;
 }
@@ -1190,6 +1373,9 @@ void txgbe_init_ops(struct txgbe_hw *hw)
 	mac->ops.set_vmdq_san_mac = txgbe_set_vmdq_san_mac;
 	mac->ops.init_uta_tables = txgbe_init_uta_tables;
 
+	/* Link */
+	mac->ops.get_link_capabilities = txgbe_get_link_capabilities;
+	mac->ops.check_link = txgbe_check_mac_link;
 	mac->num_rar_entries    = TXGBE_SP_RAR_ENTRIES;
 	mac->max_rx_queues      = TXGBE_SP_MAX_RX_QUEUES;
 	mac->max_tx_queues      = TXGBE_SP_MAX_TX_QUEUES;
@@ -1206,6 +1392,121 @@ void txgbe_init_ops(struct txgbe_hw *hw)
 	mac->ops.init_thermal_sensor_thresh = txgbe_init_thermal_sensor_thresh;
 }
 
+/**
+ *  txgbe_get_link_capabilities - Determines link capabilities
+ *  @hw: pointer to hardware structure
+ *  @speed: pointer to link speed
+ *  @autoneg: true when autoneg or autotry is enabled
+ **/
+int txgbe_get_link_capabilities(struct txgbe_hw *hw,
+				u32 *speed,
+				bool *autoneg)
+{
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
+	else if (hw->phy.media_type == txgbe_media_type_fiber) {
+		*speed = TXGBE_LINK_SPEED_10GB_FULL;
+		*autoneg = false;
+	}
+	/* SGMII */
+	else if ((hw->subsystem_device_id & 0xF0) == TXGBE_ID_SGMII) {
+		*speed = TXGBE_LINK_SPEED_1GB_FULL |
+			TXGBE_LINK_SPEED_100_FULL |
+			TXGBE_LINK_SPEED_10_FULL;
+		*autoneg = false;
+		hw->phy.link_mode = TXGBE_PHYSICAL_LAYER_1000BASE_T |
+				TXGBE_PHYSICAL_LAYER_100BASE_TX;
+	/* MAC XAUI */
+	} else if ((hw->subsystem_device_id & 0xF0) == TXGBE_ID_MAC_XAUI) {
+		*speed = TXGBE_LINK_SPEED_10GB_FULL;
+		*autoneg = false;
+		hw->phy.link_mode = TXGBE_PHYSICAL_LAYER_10GBASE_KX4;
+	/* MAC SGMII */
+	} else if ((hw->subsystem_device_id & 0xF0) == TXGBE_ID_MAC_SGMII) {
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
+
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
+			return -ENODEV;
+		}
+	}
+
+	return 0;
+}
+
 /**
  *  txgbe_get_media_type - Get media type
  *  @hw: pointer to hardware structure
@@ -1245,12 +1546,887 @@ enum txgbe_media_type txgbe_get_media_type(struct txgbe_hw *hw)
 	return media_type;
 }
 
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
+	if (!(hw->phy.media_type == txgbe_media_type_fiber))
+		return;
+
+	/* Disable Tx laser; allow 100us to go dark per spec */
+	esdp_reg |= TXGBE_GPIO_DR_1 | TXGBE_GPIO_DR_0;
+	wr32(hw, TXGBE_GPIO_DR, esdp_reg);
+	TXGBE_WRITE_FLUSH(hw);
+	usleep_range(100, 200);
+}
+
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
+	if (hw->phy.media_type != txgbe_media_type_fiber)
+		return;
+
+	/* Enable Tx laser; allow 100ms to light up */
+	wr32m(hw, TXGBE_GPIO_DR,
+	      TXGBE_GPIO_DR_0 | TXGBE_GPIO_DR_1, 0);
+	TXGBE_WRITE_FLUSH(hw);
+	msleep(100);
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
+	if (hw->mac.autotry_restart) {
+		txgbe_disable_tx_laser_multispeed_fiber(hw);
+		txgbe_enable_tx_laser_multispeed_fiber(hw);
+		hw->mac.autotry_restart = false;
+	}
+}
+
+/**
+ *  txgbe_set_hard_rate_select_speed - Set module link speed
+ *  @hw: pointer to hardware structure
+ *  @speed: link speed to set
+ *
+ *  Set module link speed via RS0/RS1 rate select pins.
+ */
+void txgbe_set_hard_rate_select_speed(struct txgbe_hw *hw, u32 speed)
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
+		txgbe_info(hw, "Invalid fixed module speed\n");
+		return;
+	}
+
+	wr32(hw, TXGBE_GPIO_DDR,
+	     TXGBE_GPIO_DDR_5 | TXGBE_GPIO_DDR_4 |
+	     TXGBE_GPIO_DDR_1 | TXGBE_GPIO_DDR_0);
+
+	wr32(hw, TXGBE_GPIO_DR, esdp_reg);
+
+	TXGBE_WRITE_FLUSH(hw);
+}
+
+static void txgbe_set_sgmii_an37_ability(struct txgbe_hw *hw)
+{
+	u32 value;
+
+	txgbe_wr32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1, 0x3002);
+	/* for sgmii + external phy, set to 0x0105 (phy sgmii mode) */
+	/* for sgmii direct link, set to 0x010c (mac sgmii mode) */
+	if ((hw->subsystem_device_id & 0xF0) == TXGBE_ID_MAC_SGMII ||
+	    hw->phy.media_type == txgbe_media_type_fiber) {
+		txgbe_wr32_epcs(hw, TXGBE_SR_MII_MMD_AN_CTL, 0x010c);
+	} else if ((hw->subsystem_device_id & 0xF0) == TXGBE_ID_SGMII ||
+		   (hw->subsystem_device_id & 0xF0) == TXGBE_ID_XAUI) {
+		txgbe_wr32_epcs(hw, TXGBE_SR_MII_MMD_AN_CTL, 0x0105);
+	}
+	txgbe_wr32_epcs(hw, TXGBE_SR_MII_MMD_DIGI_CTL, 0x0200);
+	value = txgbe_rd32_epcs(hw, TXGBE_SR_MII_MMD_CTL);
+	value = (value & ~0x1200) | (0x1 << 12) | (0x1 << 9);
+	txgbe_wr32_epcs(hw, TXGBE_SR_MII_MMD_CTL, value);
+}
+
+void txgbe_set_link_to_kr(struct txgbe_hw *hw, bool autoneg)
+{
+	int status = 0;
+	u32 value;
+
+	/* 1. Wait xpcs power-up good */
+	status = read_poll_timeout(txgbe_rd32_epcs, value,
+				   (value & TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_MASK) ==
+				   TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_POWER_GOOD,
+				   10000, 1000000, false,
+				   hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS);
+	if (status == -ETIMEDOUT) {
+		txgbe_info(hw, "xpcs power-up timeout.\n");
+		return;
+	}
+
+	txgbe_dbg(hw, "It is set to kr.\n");
+
+	txgbe_wr32_epcs(hw, 0x78001, 0x7);
+
+	/* 2. Disable xpcs AN-73 */
+	txgbe_wr32_epcs(hw, TXGBE_SR_AN_MMD_CTL, 0x3000);
+	txgbe_wr32_epcs(hw, TXGBE_VR_AN_KR_MODE_CL, 0x1);
+
+	/* 3. Set VR_XS_PMA_Gen5_12G_MPLLA_CTRL3 Register */
+	/* Bit[10:0](MPLLA_BANDWIDTH) = 11'd123 (default: 11'd16) */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_MPLLA_CTL3,
+			TXGBE_PHY_MPLLA_CTL3_MULTIPLIER_BW_10GBASER_KR);
+
+	/* 4. Set VR_XS_PMA_Gen5_12G_MISC_CTRL0 Register */
+	/* Bit[12:8](RX_VREF_CTRL) = 5'hF (default: 5'h11) */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_MISC_CTL0, 0xCF00);
+
+	/* 5. Set VR_XS_PMA_Gen5_12G_RX_EQ_CTRL0 Register */
+	/* Bit[15:8](VGA1/2_GAIN_0) = 8'h77,
+	 * Bit[7:5](CTLE_POLE_0) = 3'h2
+	 * Bit[4:0](CTLE_BOOST_0) = 4'hA
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_CTL0, 0x774A);
+
+	/* 6. Set VR_MII_Gen5_12G_RX_GENCTRL3 Register */
+	/* Bit[2:0](LOS_TRSHLD_0) = 3'h4 (default: 3) */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_RX_GEN_CTL3, 0x0004);
+	/* 7. Initialize the mode by setting VR XS or PCS MMD Digital */
+	/* Control1 Register Bit[15](VR_RST) */
+	txgbe_wr32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1, 0xA000);
+	/* wait phy initialization done */
+	status = read_poll_timeout(txgbe_rd32_epcs, value,
+				   !(value & TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1_VR_RST),
+				   100000, 10000000, false,
+				   hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1);
+	if (status == -ETIMEDOUT)
+		txgbe_info(hw, "PHY initialization timeout.\n");
+}
+
+void txgbe_set_link_to_kx4(struct txgbe_hw *hw, bool autoneg)
+{
+	int status = 0;
+	u32 value, i;
+
+	/* check link status, if already set, skip setting it again */
+	if (hw->link_status == TXGBE_LINK_STATUS_KX4)
+		return;
+
+	txgbe_dbg(hw, "It is set to kx4.\n");
+
+	/* 1. Wait xpcs power-up good */
+	status = read_poll_timeout(txgbe_rd32_epcs, value,
+				   (value & TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_MASK) ==
+				   TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_POWER_GOOD,
+				   10000, 1000000, false,
+				   hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS);
+	if (status == -ETIMEDOUT) {
+		txgbe_info(hw, "xpcs power-up timeout.\n");
+		return;
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
+	/* Disable PHY MPLLA for eth mode change(after ECO) */
+	txgbe_wr32_ephy(hw, 0x4, 0x250A);
+	TXGBE_WRITE_FLUSH(hw);
+	msleep(20);
+
+	/* Set the eth change_mode bit first in mis_rst register
+	 * for corresponding LAN port
+	 */
+	if (hw->bus.lan_id == 0)
+		wr32(hw, TXGBE_MIS_RST,
+		     TXGBE_MIS_RST_LAN0_CHG_ETH_MODE);
+	else
+		wr32(hw, TXGBE_MIS_RST,
+		     TXGBE_MIS_RST_LAN1_CHG_ETH_MODE);
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
+	if ((hw->subsystem_device_id & 0xF0) == TXGBE_ID_MAC_XAUI)
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
+	status = read_poll_timeout(txgbe_rd32_epcs, value,
+				   !(value & TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1_VR_RST),
+				   100000, 10000000, false,
+				   hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1);
+	if (status == -ETIMEDOUT) {
+		txgbe_info(hw, "PHY initialization timeout.\n");
+		return;
+	}
+
+	/* if success, set link status */
+	hw->link_status = TXGBE_LINK_STATUS_KX4;
+}
+
+void txgbe_set_link_to_kx(struct txgbe_hw *hw, u32 speed, bool autoneg)
+{
+	int status = 0;
+	u32 wdata = 0;
+	u32 value, i;
+
+	/* check link status, if already set, skip setting it again */
+	if (hw->link_status == TXGBE_LINK_STATUS_KX)
+		return;
+
+	txgbe_dbg(hw, "It is set to kx. speed =0x%x\n", speed);
+
+	/* 1. Wait xpcs power-up good */
+	status = read_poll_timeout(txgbe_rd32_epcs, value,
+				   (value & TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_MASK) ==
+				   TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_POWER_GOOD,
+				   10000, 1000000, false,
+				   hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS);
+	if (status == -ETIMEDOUT) {
+		txgbe_info(hw, "xpcs power-up timeout.\n");
+		return;
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
+	/* Disable PHY MPLLA for eth mode change(after ECO) */
+	txgbe_wr32_ephy(hw, 0x4, 0x240A);
+	TXGBE_WRITE_FLUSH(hw);
+	msleep(20);
+
+	/* Set the eth change_mode bit first in mis_rst register */
+	/* for corresponding LAN port */
+	if (hw->bus.lan_id == 0)
+		wr32(hw, TXGBE_MIS_RST,
+		     TXGBE_MIS_RST_LAN0_CHG_ETH_MODE);
+	else
+		wr32(hw, TXGBE_MIS_RST,
+		     TXGBE_MIS_RST_LAN1_CHG_ETH_MODE);
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
+		if (i != 0)
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
+	status = read_poll_timeout(txgbe_rd32_epcs, value,
+				   !(value & TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1_VR_RST),
+				   100000, 10000000, false,
+				   hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1);
+	if (status == -ETIMEDOUT) {
+		txgbe_info(hw, "PHY initialization timeout.\n");
+		return;
+	}
+
+	/* if success, set link status */
+	hw->link_status = TXGBE_LINK_STATUS_KX;
+
+	txgbe_dbg(hw, "Set KX TX_EQ MAIN:24 PRE:4 POST:16\n");
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
+}
+
+static void txgbe_set_link_to_sfi(struct txgbe_hw *hw, u32 speed)
+{
+	int status = 0;
+	u32 value = 0;
+
+	/* Set the module link speed */
+	hw->mac.ops.set_rate_select_speed(hw, speed);
+
+	/* 1. Wait xpcs power-up good */
+	status = read_poll_timeout(txgbe_rd32_epcs, value,
+				   (value & TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_MASK) ==
+				   TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_POWER_GOOD,
+				   10000, 1000000, false,
+				   hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS);
+	if (status == -ETIMEDOUT) {
+		txgbe_info(hw, "xpcs power-up timeout.\n");
+		return;
+	}
+
+	wr32m(hw, TXGBE_MAC_TX_CFG, TXGBE_MAC_TX_CFG_TE, ~TXGBE_MAC_TX_CFG_TE);
+
+	/* 2. Disable xpcs AN-73 */
+	txgbe_wr32_epcs(hw, TXGBE_SR_AN_MMD_CTL, 0x0);
+
+	/* Disable PHY MPLLA for eth mode change(after ECO) */
+	txgbe_wr32_ephy(hw, 0x4, 0x243A);
+	TXGBE_WRITE_FLUSH(hw);
+	msleep(20);
+	/* Set the eth change_mode bit first in mis_rst register
+	 * for corresponding LAN port
+	 */
+	if (hw->bus.lan_id == 0)
+		wr32(hw, TXGBE_MIS_RST,
+		     TXGBE_MIS_RST_LAN0_CHG_ETH_MODE);
+	else
+		wr32(hw, TXGBE_MIS_RST,
+		     TXGBE_MIS_RST_LAN1_CHG_ETH_MODE);
+
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
+	status = read_poll_timeout(txgbe_rd32_epcs, value,
+				   !(value & TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1_VR_RST),
+				   100000, 10000000, false,
+				   hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1);
+	if (status == -ETIMEDOUT)
+		txgbe_info(hw, "PHY initialization timeout.\n");
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
+int txgbe_setup_mac_link(struct txgbe_hw *hw,
+			 u32 speed,
+			 bool __maybe_unused autoneg_wait_to_complete)
+{
+	u32 link_capabilities = TXGBE_LINK_SPEED_UNKNOWN;
+	u32 link_speed = TXGBE_LINK_SPEED_UNKNOWN;
+	u16 sub_dev_id = hw->subsystem_device_id;
+	bool autoneg = false;
+	bool link_up = false;
+	int status = 0;
+
+	/* Check to see if speed passed in is supported. */
+	status = hw->mac.ops.get_link_capabilities(hw, &link_capabilities,
+						   &autoneg);
+	if (status)
+		return status;
+
+	speed &= link_capabilities;
+
+	if (speed == TXGBE_LINK_SPEED_UNKNOWN)
+		return -EINVAL;
+
+	if (!(((sub_dev_id & TXGBE_DEV_MASK) == TXGBE_ID_KR_KX_KX4) ||
+	      ((sub_dev_id & TXGBE_DEV_MASK) == TXGBE_ID_MAC_XAUI) ||
+	      ((sub_dev_id & TXGBE_DEV_MASK) == TXGBE_ID_MAC_SGMII))) {
+		hw->mac.ops.check_link(hw, &link_speed, &link_up, false);
+		if (link_speed == speed && link_up)
+			return status;
+	}
+
+	if ((hw->subsystem_device_id & TXGBE_DEV_MASK) == TXGBE_ID_KR_KX_KX4) {
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
+				return -ENODEV;
+			}
+		} else {
+			txgbe_set_link_to_kr(hw, autoneg);
+		}
+	} else if ((hw->subsystem_device_id & TXGBE_DEV_MASK) == TXGBE_ID_XAUI ||
+		   (hw->subsystem_device_id & TXGBE_DEV_MASK) == TXGBE_ID_MAC_XAUI ||
+		   (hw->subsystem_device_id & TXGBE_DEV_MASK) == TXGBE_ID_SGMII ||
+		   (hw->subsystem_device_id & TXGBE_DEV_MASK) == TXGBE_ID_MAC_SGMII) {
+		if (speed == TXGBE_LINK_SPEED_10GB_FULL) {
+			txgbe_set_link_to_kx4(hw, 0);
+		} else {
+			txgbe_set_link_to_kx(hw, speed, 0);
+			txgbe_set_sgmii_an37_ability(hw);
+		}
+	} else if (hw->phy.media_type == txgbe_media_type_fiber) {
+		txgbe_set_link_to_sfi(hw, speed);
+		if (speed == TXGBE_LINK_SPEED_1GB_FULL)
+			txgbe_set_sgmii_an37_ability(hw);
+	}
+
+	return status;
+}
+
 void txgbe_reset_misc(struct txgbe_hw *hw)
 {
+	u32 value;
 	int i;
 
 	txgbe_init_i2c(hw);
 
+	value = txgbe_rd32_epcs(hw, TXGBE_SR_PCS_CTL2);
+	if ((value & 0x3) != TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_X)
+		hw->link_status = TXGBE_LINK_STATUS_NONE;
+
 	/* receive packets that size > 2048 */
 	wr32m(hw, TXGBE_MAC_RX_CFG,
 	      TXGBE_MAC_RX_CFG_JE, TXGBE_MAC_RX_CFG_JE);
@@ -1752,3 +2928,53 @@ int txgbe_validate_eeprom_checksum(struct txgbe_hw *hw,
 
 	return status;
 }
+
+/**
+ *  txgbe_check_mac_link - Determine link and speed status
+ *  @hw: pointer to hardware structure
+ *  @speed: pointer to link speed
+ *  @link_up: true when link is up
+ *  @link_up_wait_to_complete: bool used to wait for link up or not
+ *
+ *  Reads the links register to determine if link is up and the current speed
+ **/
+void txgbe_check_mac_link(struct txgbe_hw *hw, u32 *speed,
+			  bool *link_up, bool link_up_wait_to_complete)
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
+}
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index 77fc3ac38351..60b843bd8cda 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -54,9 +54,23 @@ bool txgbe_check_mng_access(struct txgbe_hw *hw);
 
 void txgbe_init_thermal_sensor_thresh(struct txgbe_hw *hw);
 void txgbe_disable_rx(struct txgbe_hw *hw);
+int txgbe_setup_mac_link_multispeed_fiber(struct txgbe_hw *hw,
+					  u32 speed,
+					  bool autoneg_wait_to_complete);
 int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit);
 
+int txgbe_get_link_capabilities(struct txgbe_hw *hw,
+				u32 *speed, bool *autoneg);
 enum txgbe_media_type txgbe_get_media_type(struct txgbe_hw *hw);
+void txgbe_disable_tx_laser_multispeed_fiber(struct txgbe_hw *hw);
+void txgbe_enable_tx_laser_multispeed_fiber(struct txgbe_hw *hw);
+void txgbe_flap_tx_laser_multispeed_fiber(struct txgbe_hw *hw);
+void txgbe_set_hard_rate_select_speed(struct txgbe_hw *hw, u32 speed);
+int txgbe_setup_mac_link(struct txgbe_hw *hw, u32 speed,
+			 bool autoneg_wait_to_complete);
+void txgbe_check_mac_link(struct txgbe_hw *hw, u32 *speed,
+			  bool *link_up, bool link_up_wait_to_complete);
+void txgbe_init_mac_link_ops(struct txgbe_hw *hw);
 void txgbe_reset_misc(struct txgbe_hw *hw);
 int txgbe_reset_hw(struct txgbe_hw *hw);
 int txgbe_identify_phy(struct txgbe_hw *hw);
@@ -75,6 +89,10 @@ u32 txgbe_rd32_epcs(struct txgbe_hw *hw, u32 addr);
 void txgbe_wr32_epcs(struct txgbe_hw *hw, u32 addr, u32 data);
 void txgbe_wr32_ephy(struct txgbe_hw *hw, u32 addr, u32 data);
 
+void txgbe_set_link_to_kr(struct txgbe_hw *hw, bool autoneg);
+void txgbe_set_link_to_kx4(struct txgbe_hw *hw, bool autoneg);
+void txgbe_set_link_to_kx(struct txgbe_hw *hw, u32 speed, bool autoneg);
+
 int txgbe_fmgr_cmd_op(struct txgbe_hw *hw, u32 cmd, u32 cmd_addr);
 int txgbe_flash_read_dword(struct txgbe_hw *hw, u32 addr, u32 *data);
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 52310b8c8455..678cac0b9f51 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -202,9 +202,71 @@ static bool txgbe_is_sfp(struct txgbe_hw *hw)
 	}
 }
 
+static bool txgbe_is_backplane(struct txgbe_hw *hw)
+{
+	switch (hw->phy.media_type) {
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
 static void txgbe_up_complete(struct txgbe_adapter *adapter)
 {
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 links_reg;
+
 	txgbe_get_hw_control(adapter);
+
+	/* enable the optics for SFP+ fiber */
+	hw->mac.ops.enable_tx_laser(hw);
+
+	/* make sure to complete pre-operations */
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
+	/* Set PF Reset Done bit so PF/VF Mail Ops can work */
+	wr32m(hw, TXGBE_CFG_PORT_CTL,
+	      TXGBE_CFG_PORT_CTL_PFRSTD, TXGBE_CFG_PORT_CTL_PFRSTD);
 }
 
 void txgbe_reset(struct txgbe_adapter *adapter)
@@ -214,12 +276,21 @@ void txgbe_reset(struct txgbe_adapter *adapter)
 	u8 old_addr[ETH_ALEN];
 	int err;
 
+	/* lock SFP init bit to prevent race conditions with the watchdog */
+	while (test_and_set_bit(__TXGBE_IN_SFP_INIT, &adapter->state))
+		usleep_range(1000, 2000);
+
+	/* clear all SFP and link config related flags while holding SFP_INIT */
+	adapter->flags2 &= ~TXGBE_FLAG2_SFP_NEEDS_RESET;
+	adapter->flags &= ~TXGBE_FLAG_NEED_LINK_CONFIG;
+
 	err = hw->mac.ops.init_hw(hw);
 	if (err != 0 &&
 	    hw->phy.sfp_type != txgbe_sfp_type_not_present &&
 	    hw->phy.type != txgbe_phy_sfp_unsupported)
 		dev_err(&adapter->pdev->dev, "Hardware Error: %d\n", err);
 
+	clear_bit(__TXGBE_IN_SFP_INIT, &adapter->state);
 	/* do not flush user set addresses */
 	memcpy(old_addr, &adapter->mac_table[0].addr, netdev->addr_len);
 	txgbe_flush_sw_mac_table(adapter);
@@ -246,6 +317,8 @@ void txgbe_disable_device(struct txgbe_adapter *adapter)
 	netif_carrier_off(netdev);
 	netif_tx_disable(netdev);
 
+	adapter->flags &= ~TXGBE_FLAG_NEED_LINK_UPDATE;
+
 	del_timer_sync(&adapter->service_timer);
 
 	if (hw->bus.lan_id == 0)
@@ -275,8 +348,14 @@ void txgbe_disable_device(struct txgbe_adapter *adapter)
 
 void txgbe_down(struct txgbe_adapter *adapter)
 {
+	struct txgbe_hw *hw = &adapter->hw;
+
 	txgbe_disable_device(adapter);
 	txgbe_reset(adapter);
+
+	if (!(((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP)))
+		/* power down the optics for SFP+ fiber */
+		hw->mac.ops.disable_tx_laser(hw);
 }
 
 /**
@@ -357,7 +436,11 @@ int txgbe_open(struct net_device *netdev)
  */
 static void txgbe_close_suspend(struct txgbe_adapter *adapter)
 {
+	struct txgbe_hw *hw = &adapter->hw;
+
 	txgbe_disable_device(adapter);
+	if (!((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP))
+		hw->mac.ops.disable_tx_laser(hw);
 }
 
 /**
@@ -412,12 +495,260 @@ static void txgbe_shutdown(struct pci_dev *pdev)
 	}
 }
 
+/**
+ * txgbe_watchdog_update_link - update the link status
+ * @adapter: pointer to the device adapter structure
+ **/
+static void txgbe_watchdog_update_link(struct txgbe_adapter *adapter)
+{
+	u32 link_speed = adapter->link_speed;
+	struct txgbe_hw *hw = &adapter->hw;
+	bool link_up = adapter->link_up;
+	u32 i = 1, reg;
+
+	if (!(adapter->flags & TXGBE_FLAG_NEED_LINK_UPDATE))
+		return;
+
+	link_speed = TXGBE_LINK_SPEED_10GB_FULL;
+	link_up = true;
+	hw->mac.ops.check_link(hw, &link_speed, &link_up, false);
+
+	if (link_up || time_after(jiffies, (adapter->link_check_timeout +
+					    TXGBE_TRY_LINK_TIMEOUT))) {
+		adapter->flags &= ~TXGBE_FLAG_NEED_LINK_UPDATE;
+	}
+
+	for (i = 0; i < 3; i++) {
+		hw->mac.ops.check_link(hw, &link_speed, &link_up, false);
+		msleep(20);
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
+ * @adapter: pointer to the device adapter structure
+ **/
+static void txgbe_watchdog_link_is_up(struct txgbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+	u32 link_speed = adapter->link_speed;
+	const char *speed_str;
+
+	/* only continue if link was previously down */
+	if (netif_carrier_ok(netdev))
+		return;
+
+	switch (link_speed) {
+	case TXGBE_LINK_SPEED_10GB_FULL:
+		speed_str = "10 Gbps";
+		break;
+	case TXGBE_LINK_SPEED_1GB_FULL:
+		speed_str = "1 Gbps";
+		break;
+	case TXGBE_LINK_SPEED_100_FULL:
+		speed_str = "100 Mbps";
+		break;
+	case TXGBE_LINK_SPEED_10_FULL:
+		speed_str = "10 Mbps";
+		break;
+	default:
+		speed_str = "unknown speed";
+		break;
+	}
+
+	netif_info(adapter, drv, netdev,
+		   "NIC Link is Up %s\n", speed_str);
+
+	netif_carrier_on(netdev);
+}
+
+/**
+ * txgbe_watchdog_link_is_down - update netif_carrier status and
+ *                               print link down message
+ * @adapter: pointer to the adapter structure
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
+	netif_info(adapter, drv, netdev, "NIC Link is Down\n");
+	netif_carrier_off(netdev);
+}
+
+/**
+ * txgbe_watchdog_subtask - check and bring link up
+ * @adapter: pointer to the device adapter structure
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
+ * @adapter: the txgbe adapter structure
+ **/
+static void txgbe_sfp_detection_subtask(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	struct txgbe_mac_info *mac = &hw->mac;
+	int err;
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
+	err = hw->phy.ops.identify_sfp(hw);
+	if (err != 0) {
+		if (hw->phy.sfp_type == txgbe_sfp_type_not_present) {
+			/* If no cable is present, then we need to reset
+			 * the next time we find a good cable.
+			 */
+			adapter->flags2 |= TXGBE_FLAG2_SFP_NEEDS_RESET;
+		}
+		/* exit on error */
+		goto sfp_out;
+	}
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
+	netif_info(adapter, probe, adapter->netdev,
+		   "detected SFP+: %d\n", hw->phy.sfp_type);
+
+sfp_out:
+	clear_bit(__TXGBE_IN_SFP_INIT, &adapter->state);
+
+	if (hw->phy.type == txgbe_phy_sfp_unsupported && adapter->netdev_registered)
+		dev_err(&adapter->pdev->dev,
+			"failed to initialize because an unsupported SFP+ module type was detected.\n");
+}
+
+/**
+ * txgbe_sfp_link_config_subtask - set up link SFP after module install
+ * @adapter: the txgbe adapter structure
+ **/
+static void txgbe_sfp_link_config_subtask(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u8 device_type = hw->subsystem_device_id & 0xF0;
+	bool autoneg = false;
+	u32 speed;
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
+		if (!speed) {
+			hw->mac.ops.get_link_capabilities(hw, &speed, &autoneg);
+			/* setup the highest link when no autoneg */
+			if (!autoneg) {
+				if (speed & TXGBE_LINK_SPEED_10GB_FULL)
+					speed = TXGBE_LINK_SPEED_10GB_FULL;
+			}
+		}
+	}
+
+	hw->mac.ops.setup_link(hw, speed, false);
+
+	adapter->flags |= TXGBE_FLAG_NEED_LINK_UPDATE;
+	adapter->link_check_timeout = jiffies;
+	clear_bit(__TXGBE_IN_SFP_INIT, &adapter->state);
+}
+
 static void txgbe_service_timer(struct timer_list *t)
 {
 	struct txgbe_adapter *adapter = from_timer(adapter, t, service_timer);
+	struct txgbe_hw *hw = &adapter->hw;
 	unsigned long next_event_offset;
 
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
@@ -435,6 +766,10 @@ static void txgbe_service_task(struct work_struct *work)
 						     struct txgbe_adapter,
 						     service_task);
 
+	txgbe_sfp_detection_subtask(adapter);
+	txgbe_sfp_link_config_subtask(adapter);
+	txgbe_watchdog_subtask(adapter);
+
 	txgbe_service_event_complete(adapter);
 }
 
@@ -706,6 +1041,10 @@ static int txgbe_probe(struct pci_dev *pdev,
 	pci_set_drvdata(pdev, adapter);
 	adapter->netdev_registered = true;
 
+	if (!((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP))
+		/* power down the optics for SFP+ fiber */
+		hw->mac.ops.disable_tx_laser(hw);
+
 	/* carrier off reporting is important to ethtool even BEFORE open */
 	netif_carrier_off(netdev);
 
@@ -723,6 +1062,11 @@ static int txgbe_probe(struct pci_dev *pdev,
 	else
 		dev_warn(&pdev->dev, "Failed to enumerate PF devices.\n");
 
+	if ((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP)
+		netif_info(adapter, probe, netdev, "NCSI : support");
+	else
+		netif_info(adapter, probe, netdev, "NCSI : unsupported");
+
 	/* First try to read PBA as a string */
 	err = txgbe_read_pba_string(hw, part_str, TXGBE_PBANUM_LENGTH);
 	if (err)
@@ -749,6 +1093,15 @@ static int txgbe_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_free_mac_table;
 
+	netif_info(adapter, probe, netdev,
+		   "WangXun(R) 10 Gigabit Network Connection\n");
+
+	/* setup link for SFP devices with MNG FW, else wait for TXGBE_UP */
+	if (txgbe_mng_present(hw) && txgbe_is_sfp(hw) &&
+	    ((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP))
+		hw->mac.ops.setup_link(hw, TXGBE_LINK_SPEED_10GB_FULL |
+				       TXGBE_LINK_SPEED_1GB_FULL, true);
+
 	return 0;
 
 err_release_hw:
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 57cd8158e508..51312fcbb97d 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -60,6 +60,14 @@
 #define TXGBE_SR_XS_PCS_MMD_STATUS1             0x30001
 #define TXGBE_SR_PCS_CTL2                       0x30007
 #define TXGBE_SR_PMA_MMD_CTL1                   0x10000
+#define TXGBE_SR_MII_MMD_CTL                    0x1F0000
+#define TXGBE_SR_MII_MMD_DIGI_CTL               0x1F8000
+#define TXGBE_SR_MII_MMD_AN_CTL                 0x1F8001
+#define TXGBE_SR_MII_MMD_AN_ADV                 0x1F0004
+#define TXGBE_SR_MII_MMD_AN_ADV_PAUSE(_v)       ((0x3 & (_v)) << 7)
+#define TXGBE_SR_MII_MMD_AN_ADV_PAUSE_ASM       0x80
+#define TXGBE_SR_MII_MMD_AN_ADV_PAUSE_SYM       0x100
+#define TXGBE_SR_MII_MMD_LP_BABL                0x1F0005
 #define TXGBE_SR_AN_MMD_CTL                     0x70000
 #define TXGBE_SR_AN_MMD_ADV_REG1                0x70010
 #define TXGBE_SR_AN_MMD_ADV_REG1_PAUSE(_v)      ((0x3 & (_v)) << 10)
@@ -70,10 +78,124 @@
 #define TXGBE_VR_AN_KR_MODE_CL                  0x78003
 #define TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1        0x38000
 #define TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS      0x38010
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
 
 #define TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_R        0x0
 #define TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_X        0x1
 #define TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_MASK     0x3
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
 
 /**************** Global Registers ****************************/
 /* chip control Registers */
@@ -277,6 +399,27 @@ struct txgbe_thermal_sensor_data {
 #define TXGBE_CFG_PORT_ST_LAN_ID(_r)    ((0x00000100U & (_r)) >> 8)
 #define TXGBE_LINK_UP_TIME              90
 
+/* GPIO Registers */
+#define TXGBE_GPIO_DR                   0x14800
+#define TXGBE_GPIO_DDR                  0x14804
+/*GPIO bit */
+#define TXGBE_GPIO_DR_0         0x00000001U /* SDP0 Data Value */
+#define TXGBE_GPIO_DR_1         0x00000002U /* SDP1 Data Value */
+#define TXGBE_GPIO_DR_2         0x00000004U /* SDP2 Data Value */
+#define TXGBE_GPIO_DR_3         0x00000008U /* SDP3 Data Value */
+#define TXGBE_GPIO_DR_4         0x00000010U /* SDP4 Data Value */
+#define TXGBE_GPIO_DR_5         0x00000020U /* SDP5 Data Value */
+#define TXGBE_GPIO_DR_6         0x00000040U /* SDP6 Data Value */
+#define TXGBE_GPIO_DR_7         0x00000080U /* SDP7 Data Value */
+#define TXGBE_GPIO_DDR_0        0x00000001U /* SDP0 IO direction */
+#define TXGBE_GPIO_DDR_1        0x00000002U /* SDP1 IO direction */
+#define TXGBE_GPIO_DDR_2        0x00000004U /* SDP1 IO direction */
+#define TXGBE_GPIO_DDR_3        0x00000008U /* SDP3 IO direction */
+#define TXGBE_GPIO_DDR_4        0x00000010U /* SDP4 IO direction */
+#define TXGBE_GPIO_DDR_5        0x00000020U /* SDP5 IO direction */
+#define TXGBE_GPIO_DDR_6        0x00000040U /* SDP6 IO direction */
+#define TXGBE_GPIO_DDR_7        0x00000080U /* SDP7 IO direction */
+
 /*********************** Transmit DMA registers **************************/
 /* transmit global control */
 #define TXGBE_TDM_CTL           0x18000
@@ -622,6 +765,38 @@ struct txgbe_hic_reset {
 
 /* Number of 80 microseconds we wait for PCI Express master disable */
 #define TXGBE_PCI_MASTER_DISABLE_TIMEOUT        80000
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
@@ -730,6 +905,20 @@ struct txgbe_mac_operations {
 	int (*acquire_swfw_sync)(struct txgbe_hw *hw, u32 mask);
 	void (*release_swfw_sync)(struct txgbe_hw *hw, u32 mask);
 
+	/* Link */
+	void (*disable_tx_laser)(struct txgbe_hw *hw);
+	void (*enable_tx_laser)(struct txgbe_hw *hw);
+	void (*flap_tx_laser)(struct txgbe_hw *hw);
+	int (*setup_link)(struct txgbe_hw *hw, u32 speed,
+			  bool autoneg_wait_to_complete);
+	int (*setup_mac_link)(struct txgbe_hw *hw, u32 speed,
+			      bool autoneg_wait_to_complete);
+	void (*check_link)(struct txgbe_hw *hw, u32 *speed,
+			   bool *link_up, bool link_up_wait_to_complete);
+	int (*get_link_capabilities)(struct txgbe_hw *hw, u32 *speed,
+				     bool *autoneg);
+	void (*set_rate_select_speed)(struct txgbe_hw *hw, u32 speed);
+
 	/* RAR */
 	void (*set_rar)(struct txgbe_hw *hw, u32 index, u8 *addr, u64 pools,
 			u32 enable_addr);
@@ -796,7 +985,9 @@ struct txgbe_phy_info {
 	enum txgbe_sfp_type sfp_type;
 	enum txgbe_media_type media_type;
 	u32 phy_semaphore_mask;
+	txgbe_autoneg_advertised autoneg_advertised;
 	bool multispeed_fiber;
+	txgbe_physical_layer link_mode;
 };
 
 enum txgbe_reset_type {
@@ -805,6 +996,12 @@ enum txgbe_reset_type {
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
 	struct txgbe_mac_info mac;
@@ -819,6 +1016,7 @@ struct txgbe_hw {
 	u8 revision_id;
 	bool adapter_stopped;
 	enum txgbe_reset_type reset_type;
+	enum txgbe_link_status link_status;
 	u16 oem_ssid;
 	u16 oem_svid;
 };
-- 
2.27.0

