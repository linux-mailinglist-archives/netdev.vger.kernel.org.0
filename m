Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF5A58E92A
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 10:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbiHJI54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 04:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbiHJI5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 04:57:52 -0400
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 10 Aug 2022 01:57:44 PDT
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852286F55B
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 01:57:44 -0700 (PDT)
X-QQ-mid: bizesmtp82t1660121795t390bbpn
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 10 Aug 2022 16:56:34 +0800 (CST)
X-QQ-SSF: 01400000000000G0S000B00A0000000
X-QQ-FEAT: OICyp1OkQRKuXfVjFg+U92yJ3bPCazbRyO1PzKPgn30+D66CNTQwVPrca6Zh+
        oUwmxjVDJ9fUanHV1PY4VCseoYo1ZecCqZ1MK1LREFo9eAXHs/hSvqK0mjVn3m+Xrt7CUFq
        LKGxEqKBiLkRvkIsetmJNQxASokBNAigh8ksxbIJxNMWl8nG8ILtsZtGAfDrzi4iMX4mC2k
        bu+8YqegC9rdIXxR0BNU3qVAfbqFp14y+8olJeB7hbgbDTzvV2OT22VtZO5smMuz2bjrJ2m
        9brQ6GZ5y9I82hE9wCcGdpA5fqiiZH9Wk8QN0lmHq0Nj0ssgApcN6rKNf97aGAm57QPyBC6
        690qQOUyDGF4dSfYdEWb//vGNmuFUh7iEZJFrUc1lL1Iu60bb1C56Y+J3YWqUrENn/lsrZi
        eWSTpq2Fw4A=
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [RFC PATCH net-next 07/16] net: txgbe: Support to setup link
Date:   Wed, 10 Aug 2022 16:55:23 +0800
Message-Id: <20220810085532.246613-8-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220810085532.246613-1-jiawenwu@trustnetic.com>
References: <20220810085532.246613-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 1314 ++++++++++++++++-
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   21 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  359 ++++-
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    |   23 +
 .../net/ethernet/wangxun/txgbe/txgbe_phy.h    |    2 +
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  201 +++
 8 files changed, 1946 insertions(+), 4 deletions(-)

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
index 397241df4078..0f06efbcfef5 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -7,6 +7,7 @@
 #include <net/ip.h>
 #include <linux/pci.h>
 #include <linux/etherdevice.h>
+#include <linux/timecounter.h>
 
 #include "txgbe_type.h"
 
@@ -29,6 +30,22 @@ struct txgbe_mac_addr {
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
@@ -38,6 +55,8 @@ struct txgbe_adapter {
 
 	unsigned long state;
 
+	u32 flags;
+	u32 flags2;
 	/* Tx fast path data */
 	int num_tx_queues;
 
@@ -48,6 +67,11 @@ struct txgbe_adapter {
 	struct txgbe_hw hw;
 	u16 msg_enable;
 
+	u32 link_speed;
+	bool link_up;
+	unsigned long sfp_poll_time;
+	unsigned long link_check_timeout;
+
 	struct timer_list service_timer;
 	struct work_struct service_task;
 
@@ -67,6 +91,7 @@ enum txgbe_state_t {
 	__TXGBE_REMOVING,
 	__TXGBE_SERVICE_SCHED,
 	__TXGBE_SERVICE_INITED,
+	__TXGBE_IN_SFP_INIT,
 };
 
 /* needed by txgbe_main.c */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index 240c19c20e2c..89a67b158fa5 100644
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
 s32 txgbe_init_hw(struct txgbe_hw *hw)
 {
 	s32 status;
@@ -1104,11 +1132,12 @@ s32 txgbe_reset_hostif(struct txgbe_hw *hw)
 			continue;
 
 		if (reset_cmd.hdr.cmd_or_resp.ret_status ==
-		    FW_CEM_RESP_STATUS_SUCCESS)
+		    FW_CEM_RESP_STATUS_SUCCESS) {
 			status = 0;
-		else
+			hw->link_status = TXGBE_LINK_STATUS_NONE;
+		} else {
 			status = TXGBE_ERR_HOST_INTERFACE_COMMAND;
-
+		}
 		break;
 	}
 
@@ -1232,6 +1261,141 @@ bool txgbe_check_mng_access(struct txgbe_hw *hw)
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
+		msleep(40);
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
+			msleep(100);
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
+		msleep(40);
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
+		msleep(100);
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
 	u32 i = 0, reg = 0;
@@ -1255,6 +1419,34 @@ int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit)
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
@@ -1270,7 +1462,13 @@ s32 txgbe_init_phy_ops(struct txgbe_hw *hw)
 	txgbe_init_i2c(hw);
 	/* Identify the PHY or SFP module */
 	ret_val = TCALL(hw, phy.ops.identify);
+	if (ret_val == TXGBE_ERR_SFP_NOT_SUPPORTED)
+		goto init_phy_ops_out;
 
+	/* Setup function pointers based on detected SFP module and speeds */
+	txgbe_init_mac_link_ops(hw);
+
+init_phy_ops_out:
 	return ret_val;
 }
 
@@ -1317,6 +1515,9 @@ s32 txgbe_init_ops(struct txgbe_hw *hw)
 	mac->ops.set_vmdq_san_mac = txgbe_set_vmdq_san_mac;
 	mac->ops.init_uta_tables = txgbe_init_uta_tables;
 
+	/* Link */
+	mac->ops.get_link_capabilities = txgbe_get_link_capabilities;
+	mac->ops.check_link = txgbe_check_mac_link;
 	mac->num_rar_entries    = TXGBE_SP_RAR_ENTRIES;
 	mac->max_rx_queues      = TXGBE_SP_MAX_RX_QUEUES;
 	mac->max_tx_queues      = TXGBE_SP_MAX_TX_QUEUES;
@@ -1337,6 +1538,124 @@ s32 txgbe_init_ops(struct txgbe_hw *hw)
 	return 0;
 }
 
+/**
+ *  txgbe_get_link_capabilities - Determines link capabilities
+ *  @hw: pointer to hardware structure
+ *  @speed: pointer to link speed
+ *  @autoneg: true when autoneg or autotry is enabled
+ **/
+s32 txgbe_get_link_capabilities(struct txgbe_hw *hw,
+				u32 *speed,
+				bool *autoneg)
+{
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
+			status = TXGBE_ERR_LINK_SETUP;
+			goto out;
+		}
+	}
+
+out:
+	return status;
+}
+
 /**
  *  txgbe_get_media_type - Get media type
  *  @hw: pointer to hardware structure
@@ -1376,12 +1695,949 @@ enum txgbe_media_type txgbe_get_media_type(struct txgbe_hw *hw)
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
+s32 txgbe_disable_tx_laser_multispeed_fiber(struct txgbe_hw *hw)
+{
+	u32 esdp_reg = rd32(hw, TXGBE_GPIO_DR);
+
+	if (!(hw->phy.media_type == txgbe_media_type_fiber))
+		return 0;
+	/* Blocked by MNG FW so bail */
+	txgbe_check_reset_blocked(hw);
+
+	/* Disable Tx laser; allow 100us to go dark per spec */
+	esdp_reg |= TXGBE_GPIO_DR_1 | TXGBE_GPIO_DR_0;
+	wr32(hw, TXGBE_GPIO_DR, esdp_reg);
+	TXGBE_WRITE_FLUSH(hw);
+	usleep_range(100, 200);
+
+	return 0;
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
+s32 txgbe_enable_tx_laser_multispeed_fiber(struct txgbe_hw *hw)
+{
+	if (!(TCALL(hw, mac.ops.get_media_type) == txgbe_media_type_fiber))
+		return 0;
+
+	/* Enable Tx laser; allow 100ms to light up */
+	wr32m(hw, TXGBE_GPIO_DR,
+	      TXGBE_GPIO_DR_0 | TXGBE_GPIO_DR_1, 0);
+	TXGBE_WRITE_FLUSH(hw);
+	msleep(100);
+
+	return 0;
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
+s32 txgbe_flap_tx_laser_multispeed_fiber(struct txgbe_hw *hw)
+{
+	/* Blocked by MNG FW so bail */
+	txgbe_check_reset_blocked(hw);
+
+	if (hw->mac.autotry_restart) {
+		txgbe_disable_tx_laser_multispeed_fiber(hw);
+		txgbe_enable_tx_laser_multispeed_fiber(hw);
+		hw->mac.autotry_restart = false;
+	}
+
+	return 0;
+}
+
+/**
+ *  txgbe_set_hard_rate_select_speed - Set module link speed
+ *  @hw: pointer to hardware structure
+ *  @speed: link speed to set
+ *
+ *  Set module link speed via RS0/RS1 rate select pins.
+ */
+s32 txgbe_set_hard_rate_select_speed(struct txgbe_hw *hw,
+				     u32 speed)
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
+		txgbe_dbg(hw, "Invalid fixed module speed\n");
+		return 0;
+	}
+
+	wr32(hw, TXGBE_GPIO_DDR,
+	     TXGBE_GPIO_DDR_5 | TXGBE_GPIO_DDR_4 |
+	     TXGBE_GPIO_DDR_1 | TXGBE_GPIO_DDR_0);
+
+	wr32(hw, TXGBE_GPIO_DR, esdp_reg);
+
+	TXGBE_WRITE_FLUSH(hw);
+
+	return 0;
+}
+
+static s32 txgbe_set_sgmii_an37_ability(struct txgbe_hw *hw)
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
+	return 0;
+}
+
+s32 txgbe_set_link_to_kr(struct txgbe_hw *hw, bool autoneg)
+{
+	struct txgbe_adapter *adapter = container_of(hw, struct txgbe_adapter, hw);
+	s32 status = 0;
+	u32 i;
+
+	/* 1. Wait xpcs power-up good */
+	for (i = 0; i < TXGBE_XPCS_POWER_GOOD_MAX_POLLING_TIME; i++) {
+		if ((txgbe_rd32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS) &
+		    TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_MASK) ==
+		    TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_POWER_GOOD)
+			break;
+		msleep(20);
+	}
+	if (i == TXGBE_XPCS_POWER_GOOD_MAX_POLLING_TIME) {
+		status = TXGBE_ERR_XPCS_POWER_UP_FAILED;
+		goto out;
+	}
+	dev_info(&adapter->pdev->dev, "It is set to kr.\n");
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
+	for (i = 0; i < TXGBE_PHY_INIT_DONE_POLLING_TIME; i++) {
+		if ((txgbe_rd32_epcs(hw,
+				     TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1) &
+		    TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1_VR_RST) == 0)
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
+s32 txgbe_set_link_to_kx4(struct txgbe_hw *hw, bool autoneg)
+{
+	struct txgbe_adapter *adapter = container_of(hw, struct txgbe_adapter, hw);
+	s32 status = 0;
+	u32 value;
+	u32 i;
+
+	/* check link status, if already set, skip setting it again */
+	if (hw->link_status == TXGBE_LINK_STATUS_KX4)
+		goto out;
+
+	dev_info(&adapter->pdev->dev, "It is set to kx4.\n");
+
+	/* 1. Wait xpcs power-up good */
+	for (i = 0; i < TXGBE_XPCS_POWER_GOOD_MAX_POLLING_TIME; i++) {
+		if ((txgbe_rd32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS) &
+			TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_MASK) ==
+			TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_POWER_GOOD)
+			break;
+		msleep(20);
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
+	struct txgbe_adapter *adapter = container_of(hw, struct txgbe_adapter, hw);
+	s32 status = 0;
+	u32 wdata = 0;
+	u32 value;
+	u32 i;
+
+	/* check link status, if already set, skip setting it again */
+	if (hw->link_status == TXGBE_LINK_STATUS_KX)
+		goto out;
+
+	dev_info(&adapter->pdev->dev, "It is set to kx. speed =0x%x\n", speed);
+
+	/* 1. Wait xpcs power-up good */
+	for (i = 0; i < TXGBE_XPCS_POWER_GOOD_MAX_POLLING_TIME; i++) {
+		if ((txgbe_rd32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS) &
+			TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_MASK) ==
+			TXGBE_VR_XS_OR_PCS_MMD_DIGI_STATUS_PSEQ_POWER_GOOD)
+			break;
+		msleep(20);
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
+	dev_info(&adapter->pdev->dev, "Set KX TX_EQ MAIN:24 PRE:4 POST:16\n");
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
+static s32 txgbe_set_link_to_sfi(struct txgbe_hw *hw, u32 speed)
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
+		msleep(20);
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
+	u32 link_capabilities = TXGBE_LINK_SPEED_UNKNOWN;
+	u32 link_speed = TXGBE_LINK_SPEED_UNKNOWN;
+	u16 sub_dev_id = hw->subsystem_device_id;
+	bool autoneg = false;
+	bool link_up = false;
+	s32 status = 0;
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
+				status = TXGBE_ERR_PHY;
+				goto out;
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
+out:
+	return status;
+}
+
 int txgbe_reset_misc(struct txgbe_hw *hw)
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
@@ -1903,3 +3159,55 @@ s32 txgbe_validate_eeprom_checksum(struct txgbe_hw *hw,
 
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
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index eaa1a6fe4dd7..d620c88f6318 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -56,9 +56,23 @@ bool txgbe_check_mng_access(struct txgbe_hw *hw);
 
 s32 txgbe_init_thermal_sensor_thresh(struct txgbe_hw *hw);
 s32 txgbe_disable_rx(struct txgbe_hw *hw);
+s32 txgbe_setup_mac_link_multispeed_fiber(struct txgbe_hw *hw,
+					  u32 speed,
+					  bool autoneg_wait_to_complete);
 int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit);
 
+s32 txgbe_get_link_capabilities(struct txgbe_hw *hw,
+				u32 *speed, bool *autoneg);
 enum txgbe_media_type txgbe_get_media_type(struct txgbe_hw *hw);
+s32 txgbe_disable_tx_laser_multispeed_fiber(struct txgbe_hw *hw);
+s32 txgbe_enable_tx_laser_multispeed_fiber(struct txgbe_hw *hw);
+s32 txgbe_flap_tx_laser_multispeed_fiber(struct txgbe_hw *hw);
+s32 txgbe_set_hard_rate_select_speed(struct txgbe_hw *hw, u32 speed);
+s32 txgbe_setup_mac_link(struct txgbe_hw *hw, u32 speed,
+			 bool autoneg_wait_to_complete);
+s32 txgbe_check_mac_link(struct txgbe_hw *hw, u32 *speed,
+			 bool *link_up, bool link_up_wait_to_complete);
+void txgbe_init_mac_link_ops(struct txgbe_hw *hw);
 int txgbe_reset_misc(struct txgbe_hw *hw);
 s32 txgbe_reset_hw(struct txgbe_hw *hw);
 s32 txgbe_identify_phy(struct txgbe_hw *hw);
@@ -77,6 +91,13 @@ u32 txgbe_rd32_epcs(struct txgbe_hw *hw, u32 addr);
 void txgbe_wr32_epcs(struct txgbe_hw *hw, u32 addr, u32 data);
 void txgbe_wr32_ephy(struct txgbe_hw *hw, u32 addr, u32 data);
 
+s32 txgbe_set_link_to_kr(struct txgbe_hw *hw, bool autoneg);
+s32 txgbe_set_link_to_kx4(struct txgbe_hw *hw, bool autoneg);
+
+s32 txgbe_set_link_to_kx(struct txgbe_hw *hw,
+			 u32 speed,
+			 bool autoneg);
+
 u8 fmgr_cmd_op(struct txgbe_hw *hw, u32 cmd, u32 cmd_addr);
 u32 txgbe_flash_read_dword(struct txgbe_hw *hw, u32 addr);
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 30bac8a049df..7f5225004e28 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -200,9 +200,71 @@ static bool txgbe_is_sfp(struct txgbe_hw *hw)
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
+	TCALL(hw, mac.ops.enable_tx_laser);
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
@@ -214,6 +276,13 @@ void txgbe_reset(struct txgbe_adapter *adapter)
 
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
@@ -228,6 +297,7 @@ void txgbe_reset(struct txgbe_adapter *adapter)
 		dev_err(&adapter->pdev->dev, "Hardware Error: %d\n", err);
 	}
 
+	clear_bit(__TXGBE_IN_SFP_INIT, &adapter->state);
 	/* do not flush user set addresses */
 	memcpy(old_addr, &adapter->mac_table[0].addr, netdev->addr_len);
 	txgbe_flush_sw_mac_table(adapter);
@@ -254,6 +324,8 @@ void txgbe_disable_device(struct txgbe_adapter *adapter)
 	netif_carrier_off(netdev);
 	netif_tx_disable(netdev);
 
+	adapter->flags &= ~TXGBE_FLAG_NEED_LINK_UPDATE;
+
 	del_timer_sync(&adapter->service_timer);
 
 	if (hw->bus.lan_id == 0)
@@ -283,8 +355,14 @@ void txgbe_disable_device(struct txgbe_adapter *adapter)
 
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
@@ -382,7 +460,11 @@ int txgbe_open(struct net_device *netdev)
  */
 static void txgbe_close_suspend(struct txgbe_adapter *adapter)
 {
+	struct txgbe_hw *hw = &adapter->hw;
+
 	txgbe_disable_device(adapter);
+	if (!((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP))
+		TCALL(hw, mac.ops.disable_tx_laser);
 }
 
 /**
@@ -437,12 +519,264 @@ static void txgbe_shutdown(struct pci_dev *pdev)
 	}
 }
 
+/**
+ * txgbe_watchdog_update_link - update the link status
+ * @adapter: pointer to the device adapter structure
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
+	netif_info(adapter, probe, adapter->netdev,
+		   "detected SFP+: %d\n", hw->phy.sfp_type);
+
+sfp_out:
+	clear_bit(__TXGBE_IN_SFP_INIT, &adapter->state);
+
+	if (err == TXGBE_ERR_SFP_NOT_SUPPORTED && adapter->netdev_registered)
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
@@ -469,6 +803,10 @@ static void txgbe_service_task(struct work_struct *work)
 		return;
 	}
 
+	txgbe_sfp_detection_subtask(adapter);
+	txgbe_sfp_link_config_subtask(adapter);
+	txgbe_watchdog_subtask(adapter);
+
 	txgbe_service_event_complete(adapter);
 }
 
@@ -717,6 +1055,10 @@ static int txgbe_probe(struct pci_dev *pdev,
 	pci_set_drvdata(pdev, adapter);
 	adapter->netdev_registered = true;
 
+	if (!((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP))
+		/* power down the optics for SFP+ fiber */
+		TCALL(hw, mac.ops.disable_tx_laser);
+
 	/* carrier off reporting is important to ethtool even BEFORE open */
 	netif_carrier_off(netdev);
 
@@ -732,6 +1074,11 @@ static int txgbe_probe(struct pci_dev *pdev,
 	if (expected_gts > 0)
 		txgbe_check_minimum_link(adapter);
 
+	if ((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP)
+		netif_info(adapter, probe, netdev, "NCSI : support");
+	else
+		netif_info(adapter, probe, netdev, "NCSI : unsupported");
+
 	/* First try to read PBA as a string */
 	err = txgbe_read_pba_string(hw, part_str, TXGBE_PBANUM_LENGTH);
 	if (err)
@@ -756,6 +1103,16 @@ static int txgbe_probe(struct pci_dev *pdev,
 	/* add san mac addr to netdev */
 	txgbe_add_sanmac_netdev(netdev);
 
+	netif_info(adapter, probe, netdev,
+		   "WangXun(R) 10 Gigabit Network Connection\n");
+
+	/* setup link for SFP devices with MNG FW, else wait for TXGBE_UP */
+	if (txgbe_mng_present(hw) && txgbe_is_sfp(hw) &&
+	    ((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP))
+		TCALL(hw, mac.ops.setup_link,
+		      TXGBE_LINK_SPEED_10GB_FULL | TXGBE_LINK_SPEED_1GB_FULL,
+		      true);
+
 	return 0;
 
 err_release_hw:
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
index f3099103110b..be0185570b62 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -3,6 +3,29 @@
 
 #include "txgbe_phy.h"
 
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
+		ERROR_REPORT1(hw, TXGBE_ERROR_SOFTWARE,
+			      "MNG_VETO bit detected.\n");
+		return true;
+	}
+
+	return false;
+}
+
 /**
  *  txgbe_identify_module - Identifies module type
  *  @hw: pointer to hardware structure
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
index 7e172885f536..bb34e2dce2f8 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
@@ -39,6 +39,8 @@
 #define TXGBE_SFF_VENDOR_OUI_AVAGO      0x00176A00
 #define TXGBE_SFF_VENDOR_OUI_INTEL      0x001B2100
 
+s32 txgbe_check_reset_blocked(struct txgbe_hw *hw);
+
 s32 txgbe_identify_module(struct txgbe_hw *hw);
 s32 txgbe_identify_sfp_module(struct txgbe_hw *hw);
 s32 txgbe_init_i2c(struct txgbe_hw *hw);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 5539da638c09..a8f9a8af980e 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -58,6 +58,14 @@
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
@@ -68,10 +76,127 @@
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
+
+#define TXGBE_XPCS_POWER_GOOD_MAX_POLLING_TIME  100
+#define TXGBE_PHY_INIT_DONE_POLLING_TIME        100
 
 /**************** Global Registers ****************************/
 /* chip control Registers */
@@ -282,6 +407,27 @@ struct txgbe_thermal_sensor_data {
 #define TXGBE_CFG_LED_CTL_LINK_UP_SEL   0x00000001U
 #define TXGBE_CFG_LED_CTL_LINK_OD_SHIFT 16
 
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
@@ -662,6 +808,38 @@ struct txgbe_hic_reset {
 
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
@@ -812,6 +990,20 @@ struct txgbe_mac_operations {
 	s32 (*acquire_swfw_sync)(struct txgbe_hw *hw, u32 mask);
 	s32 (*release_swfw_sync)(struct txgbe_hw *hw, u32 mask);
 
+	/* Link */
+	s32 (*disable_tx_laser)(struct txgbe_hw *hw);
+	s32 (*enable_tx_laser)(struct txgbe_hw *hw);
+	s32 (*flap_tx_laser)(struct txgbe_hw *hw);
+	s32 (*setup_link)(struct txgbe_hw *hw, u32 speed,
+			  bool autoneg_wait_to_complete);
+	s32 (*setup_mac_link)(struct txgbe_hw *hw, u32 speed,
+			      bool autoneg_wait_to_complete);
+	s32 (*check_link)(struct txgbe_hw *hw, u32 *speed,
+			  bool *link_up, bool link_up_wait_to_complete);
+	s32 (*get_link_capabilities)(struct txgbe_hw *hw, u32 *speed,
+				     bool *autoneg);
+	s32 (*set_rate_select_speed)(struct txgbe_hw *hw, u32 speed);
+
 	/* RAR */
 	s32 (*set_rar)(struct txgbe_hw *hw, u32 index, u8 *addr, u64 pools,
 		       u32 enable_addr);
@@ -878,7 +1070,9 @@ struct txgbe_phy_info {
 	enum txgbe_sfp_type sfp_type;
 	enum txgbe_media_type media_type;
 	u32 phy_semaphore_mask;
+	txgbe_autoneg_advertised autoneg_advertised;
 	bool multispeed_fiber;
+	txgbe_physical_layer link_mode;
 };
 
 enum txgbe_reset_type {
@@ -887,6 +1081,12 @@ enum txgbe_reset_type {
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
@@ -901,6 +1101,7 @@ struct txgbe_hw {
 	u8 revision_id;
 	bool adapter_stopped;
 	enum txgbe_reset_type reset_type;
+	enum txgbe_link_status link_status;
 	u16 oem_ssid;
 	u16 oem_svid;
 };
-- 
2.27.0

