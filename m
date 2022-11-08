Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB56620E85
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 12:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbiKHLTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 06:19:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234014AbiKHLTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 06:19:48 -0500
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CC9275CE
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 03:19:42 -0800 (PST)
X-QQ-mid: bizesmtp85t1667906376tc0mugfp
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 08 Nov 2022 19:19:34 +0800 (CST)
X-QQ-SSF: 01400000000000M0M000000A0000000
X-QQ-FEAT: ElntjVByhgXghUpQiFTCp8EuGNPoYH9R+hPkaH7t+z5RK2hU3E3ahANPZAiEK
        4T4Ib0ZCFT8K8tSW44aQKqvmackND8XPfp3Pv4rnHA9RD2Hj0OxjhHAPK1VOJdlJxNPYofU
        kvGm0qJLVeV2y5avly/zRM4A0tCCiQkuEhv5ZauqHKrMab3vlcLPUaDXQ8Mu3SgbZi6j9aE
        uU2G7DBP2vJR2ZQEqqBG+MDB0t8aZVJW34ar3C5uOFKPhvvnf9TBplcKZA6ZSkUsOEl2DC7
        8JVzH1lZIU3oPp/AZSos7jSf3pVWKsBT16Y2AheXxMRM1HZMvvIxWLejQg4y9Ml0M9DBFmX
        j9nmV79qfer15Q7nc7Q5mIdeTR7glFuPCejgLuJBDGoHP/zQWMJxksA9xxYAFMtDZc5WwWo
        B50UdFfA2mh/wSAI5E53CA==
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com
Subject: [PATCH net-next 3/5] net: txgbe: Support to setup link
Date:   Tue,  8 Nov 2022 19:19:05 +0800
Message-Id: <20221108111907.48599-4-mengyuanlou@net-swift.com>
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

Get link capabilities, setup MAC and PHY link, and support to enable
or disable Tx laser.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 .../device_drivers/ethernet/wangxun/txgbe.rst |    5 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |    6 +
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |   16 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 1171 ++++++++++++++++-
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |    9 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  335 ++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  103 ++
 7 files changed, 1640 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst b/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
index 3cb9549fb7b0..a41acd88bfb6 100644
--- a/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
+++ b/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
@@ -50,6 +50,11 @@ The following is a list of 3rd party SFP+ modules that have been tested and veri
 | WTD      | SFP+                 | RTXM228-551          |
 +----------+----------------------+----------------------+
 
+Laser turns off for SFP+ when ifconfig ethX down
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+"ifconfig ethX down" turns off the laser for SFP+ fiber adapters.
+"ifconfig ethX up" turns on the laser.
+
 
 Support
 =======
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index c95cda53bf67..a5de626608d0 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -22,6 +22,7 @@
 /* chip control Registers */
 #define WX_MIS_PWR                   0x10000
 #define WX_MIS_RST                   0x1000C
+#define WX_MIS_RST_LAN_ETH_MODE(_i)  BIT((_i) + 29)
 #define WX_MIS_RST_LAN_RST(_i)       BIT((_i) + 1)
 #define WX_MIS_RST_SW_RST            BIT(0)
 #define WX_MIS_ST                    0x10028
@@ -63,6 +64,7 @@
 /************************* Port Registers ************************************/
 /* port cfg Registers */
 #define WX_CFG_PORT_CTL              0x14400
+#define WX_CFG_PORT_CTL_PFRSTD       BIT(14) /* Phy Function Reset Done */
 #define WX_CFG_PORT_CTL_DRV_LOAD     BIT(3)
 
 /*********************** Transmit DMA registers **************************/
@@ -134,11 +136,15 @@
 /************************************* ETH MAC *****************************/
 #define WX_MAC_TX_CFG                0x11000
 #define WX_MAC_TX_CFG_TE             BIT(0)
+#define WX_MAC_TX_CFG_SPEED_MASK     (0x3 << 29)
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
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index fb8fd413b755..021c348a2784 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -33,8 +33,17 @@ enum txgbe_state_t {
 	__TXGBE_REMOVING,
 	__TXGBE_SERVICE_SCHED,
 	__TXGBE_SERVICE_INITED,
+	__TXGBE_IN_SFP_INIT,
 };
 
+#define TXGBE_TRY_LINK_TIMEOUT  (4 * HZ)       /* trying for four seconds */
+#define TXGBE_SFP_POLL_JIFFIES  (2 * HZ)       /* SFP poll every 2 seconds */
+
+/* txgbe_adapter.flag */
+#define TXGBE_FLAG_NEED_LINK_UPDATE             BIT(0)
+#define TXGBE_FLAG_NEED_LINK_CONFIG             BIT(1)
+#define TXGBE_FLAG_SFP_NEEDS_RESET              BIT(2)
+
 /* board specific private data structure */
 struct txgbe_adapter {
 	u8 __iomem *io_addr;    /* Mainly for iounmap use */
@@ -46,6 +55,13 @@ struct txgbe_adapter {
 	struct timer_list service_timer;
 	struct work_struct service_task;
 
+	u32 flags;
+
+	bool link_up;
+	u32 link_speed;
+	unsigned long sfp_poll_time;
+	unsigned long link_check_timeout;
+
 	/* structs defined in txgbe_type.h */
 	struct txgbe_hw hw;
 	u16 msg_enable;
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index 77a44e48fc9e..2fcc097854dc 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -3,6 +3,7 @@
 
 #include <linux/etherdevice.h>
 #include <linux/if_ether.h>
+#include <linux/ethtool.h>
 #include <linux/string.h>
 #include <linux/iopoll.h>
 #include <linux/types.h>
@@ -29,6 +30,36 @@ static u32 txgbe_rd32_epcs(struct txgbe_hw *hw, u32 addr)
 	return rd32(wxhw, offset);
 }
 
+static void txgbe_wr32_ephy(struct txgbe_hw *hw, u32 addr, u32 data)
+{
+	struct wx_hw *wxhw = &hw->wxhw;
+	u32 offset;
+
+	/* Set the LAN port indicator to offset[1] */
+	/* 1st, write the offset to IDA_ADDR register */
+	offset = TXGBE_ETHPHY_IDA_ADDR;
+	wr32(wxhw, offset, addr);
+
+	/* 2nd, read the data from IDA_DATA register */
+	offset = TXGBE_ETHPHY_IDA_DATA;
+	wr32(wxhw, offset, data);
+}
+
+static void txgbe_wr32_epcs(struct txgbe_hw *hw, u32 addr, u32 data)
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
+	wr32(wxhw, offset, data);
+}
+
 static void txgbe_init_i2c(struct txgbe_hw *hw)
 {
 	struct wx_hw *wxhw = &hw->wxhw;
@@ -152,7 +183,7 @@ static int txgbe_read_i2c_eeprom(struct txgbe_hw *hw, u8 byte_offset,
  *
  *  Searches for and identifies the SFP module and assigns appropriate PHY type.
  **/
-static int txgbe_identify_sfp_module(struct txgbe_hw *hw)
+int txgbe_identify_sfp_module(struct txgbe_hw *hw)
 {
 	u8 oui_bytes[3] = {0, 0, 0};
 	u8 comp_codes_10g = 0;
@@ -383,6 +414,1102 @@ static int txgbe_init_phy(struct txgbe_hw *hw)
 	return ret_val;
 }
 
+/**
+ *  txgbe_set_hard_rate_select_speed - Set module link speed
+ *  @hw: pointer to hardware structure
+ *  @speed: link speed to set
+ *
+ *  Set module link speed via RS0/RS1 rate select pins.
+ */
+static void txgbe_set_hard_rate_select_speed(struct txgbe_hw *hw, u32 speed)
+{
+	struct wx_hw *wxhw = &hw->wxhw;
+	u32 esdp_reg;
+
+	esdp_reg = rd32(wxhw, TXGBE_GPIO_DR);
+
+	switch (speed) {
+	case SPEED_10000:
+		esdp_reg |= TXGBE_GPIO_DR_5 | TXGBE_GPIO_DR_4;
+		break;
+	case SPEED_1000:
+		esdp_reg &= ~(TXGBE_GPIO_DR_5 | TXGBE_GPIO_DR_4);
+		break;
+	default:
+		wx_err(wxhw, "Invalid fixed module speed\n");
+		return;
+	}
+
+	wr32(wxhw, TXGBE_GPIO_DDR,
+	     TXGBE_GPIO_DDR_5 | TXGBE_GPIO_DDR_4 |
+	     TXGBE_GPIO_DDR_1 | TXGBE_GPIO_DDR_0);
+
+	wr32(wxhw, TXGBE_GPIO_DR, esdp_reg);
+
+	WX_WRITE_FLUSH(wxhw);
+}
+
+static void txgbe_set_sgmii_an37_ability(struct txgbe_hw *hw)
+{
+	u16 sub_dev_id = hw->wxhw.subsystem_device_id & TXGBE_DEV_MASK;
+	u32 value;
+
+	txgbe_wr32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1, 0x3002);
+	/* for sgmii + external phy, set to 0x0105 (phy sgmii mode) */
+	/* for sgmii direct link, set to 0x010c (mac sgmii mode) */
+	if (sub_dev_id == TXGBE_ID_MAC_SGMII ||
+	    hw->phy.media_type == txgbe_media_type_fiber) {
+		txgbe_wr32_epcs(hw, TXGBE_SR_MII_MMD_AN_CTL, 0x010c);
+	} else if (sub_dev_id == TXGBE_ID_SGMII ||
+		   sub_dev_id == TXGBE_ID_XAUI) {
+		txgbe_wr32_epcs(hw, TXGBE_SR_MII_MMD_AN_CTL, 0x0105);
+	}
+	txgbe_wr32_epcs(hw, TXGBE_SR_MII_MMD_DIGI_CTL, TXGBE_SR_MII_MMD_DIGI_CTL_AS);
+	value = txgbe_rd32_epcs(hw, TXGBE_SR_MII_MMD_CTL);
+	value |= TXGBE_SR_MII_MMD_CTL_AN_EN | TXGBE_SR_MII_MMD_CTL_RESTART_AN;
+	txgbe_wr32_epcs(hw, TXGBE_SR_MII_MMD_CTL, value);
+}
+
+static void txgbe_set_link_to_kr(struct txgbe_hw *hw, bool autoneg)
+{
+	int status = 0;
+	u32 value;
+
+	/* 1. Wait xpcs power-up good */
+	status = read_poll_timeout(txgbe_rd32_epcs, value,
+				   (value & TXGBE_VR_XS_OR_PCS_MMD_DIGI_ST_PS_M) ==
+				   TXGBE_VR_XS_OR_PCS_MMD_DIGI_ST_PS_PG,
+				   10000, 1000000, false,
+				   hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_ST);
+	if (status < 0) {
+		wx_err(&hw->wxhw, "xpcs power-up timeout.\n");
+		return;
+	}
+
+	wx_dbg(&hw->wxhw, "It is set to kr.\n");
+
+	txgbe_wr32_epcs(hw, TXGBE_VR_AN_INTR_MSK,
+			TXGBE_VR_AN_INTR_MSK_AN_PG_RCV_IE |
+			TXGBE_VR_AN_INTR_MSK_AN_INC_LINK_IE |
+			TXGBE_VR_AN_INTR_MSK_AN_INT_CMPLT_IE);
+
+	/* 2. Disable xpcs AN-73 */
+	txgbe_wr32_epcs(hw, TXGBE_SR_AN_MMD_CTL,
+			TXGBE_SR_AN_MMD_CTL_EXT_NP_CTL | TXGBE_SR_AN_MMD_CTL_ENABLE);
+	txgbe_wr32_epcs(hw, TXGBE_VR_AN_KR_MODE_CL, TXGBE_VR_AN_KR_MODE_CL_PDET_EN);
+
+	/* 3. Set VR_XS_PMA_Gen5_12G_MPLLA_CTRL3 Register */
+	/* Bit[10:0](MPLLA_BANDWIDTH) = 11'd123 (default: 11'd16) */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_MPLLA_CTL3, 0x7B);
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
+	if (status < 0)
+		wx_err(&hw->wxhw, "PHY initialization timeout.\n");
+}
+
+static void txgbe_set_link_to_kx4(struct txgbe_hw *hw, bool autoneg)
+{
+	struct wx_hw *wxhw = &hw->wxhw;
+	int status = 0;
+	u32 value, i;
+
+	/* check link status, if already set, skip setting it again */
+	if (hw->link_status == TXGBE_LINK_STATUS_KX4)
+		return;
+
+	wx_dbg(wxhw, "It is set to kx4.\n");
+
+	/* Wait xpcs power-up good */
+	status = read_poll_timeout(txgbe_rd32_epcs, value,
+				   (value & TXGBE_VR_XS_OR_PCS_MMD_DIGI_ST_PS_M) ==
+				   TXGBE_VR_XS_OR_PCS_MMD_DIGI_ST_PS_PG,
+				   10000, 1000000, false,
+				   hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_ST);
+	if (status < 0) {
+		wx_err(wxhw, "xpcs power-up timeout.\n");
+		return;
+	}
+
+	wr32m(wxhw, WX_MAC_TX_CFG, WX_MAC_TX_CFG_TE, 0);
+
+	/* Disable xpcs AN-73 */
+	if (!autoneg)
+		txgbe_wr32_epcs(hw, TXGBE_SR_AN_MMD_CTL, 0);
+	else
+		txgbe_wr32_epcs(hw, TXGBE_SR_AN_MMD_CTL,
+				TXGBE_SR_AN_MMD_CTL_EXT_NP_CTL | TXGBE_SR_AN_MMD_CTL_ENABLE);
+
+	/* Disable PHY MPLLA for eth mode change(after ECO) */
+	txgbe_wr32_ephy(hw, TXGBE_SUP_DIG_MPLLA_OVRD_IN_0, 0x250A);
+	WX_WRITE_FLUSH(wxhw);
+	msleep(20);
+
+	/* Set the eth change_mode bit first in mis_rst register
+	 * for corresponding LAN port
+	 */
+	wr32(wxhw, WX_MIS_RST, WX_MIS_RST_LAN_ETH_MODE(wxhw->bus.func));
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
+	if ((wxhw->subsystem_device_id & TXGBE_DEV_MASK) == TXGBE_ID_MAC_XAUI)
+		txgbe_wr32_epcs(hw, TXGBE_PHY_MISC_CTL0, 0xCF00);
+	else
+		txgbe_wr32_epcs(hw, TXGBE_PHY_MISC_CTL0, 0x4F00);
+
+	for (i = 0; i < 4; i++) {
+		if (i == 0)
+			value = (0x45 & ~0xFFFF) | (0x7 << 12) | (0x7 << 8) | 0x6;
+		else
+			value = (0xff06 & ~0xFFFF) | (0x7 << 12) | (0x7 << 8) | 0x6;
+
+		txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_CTL0 + i, value);
+	}
+
+	txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_ATT_LVL0, 0x0);
+
+	txgbe_wr32_epcs(hw, TXGBE_PHY_DFE_TAP_CTL0, 0x0);
+
+	value = (0x6db & ~0xFFF) | (0x1 << 9) | (0x1 << 6) | (0x1 << 3) | 0x1;
+	txgbe_wr32_epcs(hw, TXGBE_PHY_RX_GEN_CTL3, value);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY MPLLA */
+	/* Control 0 Register Bit[7:0] = 8'd40  MPLLA_MULTIPLIER */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_MPLLA_CTL0, 0x28);
+
+	/* Set VR XS, PMA or MII Synopsys Enterprise Gen5 12G PHY MPLLA */
+	/* Control 3 Register Bit[10:0] = 11'd86  MPLLA_BANDWIDTH */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_MPLLA_CTL3, 0x56);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY VCO */
+	/* Calibration Load 0 Register  Bit[12:0] = 13'd1360 VCO_LD_VAL_0 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_LD0, 0x550);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY VCO */
+	/* Calibration Load 1 Register  Bit[12:0] = 13'd1360 VCO_LD_VAL_1 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_LD1, 0x550);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY VCO */
+	/* Calibration Load 2 Register  Bit[12:0] = 13'd1360 VCO_LD_VAL_2 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_LD2, 0x550);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY VCO */
+	/* Calibration Load 3 Register  Bit[12:0] = 13'd1360 VCO_LD_VAL_3 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_LD3, 0x550);
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
+	txgbe_wr32_epcs(hw, TXGBE_PHY_MPLLA_CTL2, 0x200);
+
+	txgbe_wr32_epcs(hw, TXGBE_SR_MII_MMD_CTL, 0x0);
+	txgbe_wr32_epcs(hw, TXGBE_SR_MII_MMD_AN_CTL, 0x0);
+	txgbe_wr32_epcs(hw, TXGBE_SR_MII_MMD_DIGI_CTL, 0x0);
+
+	/* Initialize the mode by setting VR XS or PCS MMD Digital Control1
+	 * Register Bit[15](VR_RST)
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1, 0xA000);
+
+	/* wait phy initialization done */
+	status = read_poll_timeout(txgbe_rd32_epcs, value,
+				   !(value & TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1_VR_RST),
+				   100000, 10000000, false,
+				   hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1);
+	if (status < 0) {
+		wx_err(wxhw, "PHY initialization timeout.\n");
+		return;
+	}
+
+	/* if success, set link status */
+	hw->link_status = TXGBE_LINK_STATUS_KX4;
+}
+
+static void txgbe_set_link_to_kx(struct txgbe_hw *hw, u32 speed, bool autoneg)
+{
+	struct wx_hw *wxhw = &hw->wxhw;
+	int status = 0;
+	u32 wdata = 0;
+	u32 value, i;
+
+	/* check link status, if already set, skip setting it again */
+	if (hw->link_status == TXGBE_LINK_STATUS_KX)
+		return;
+
+	wx_dbg(wxhw, "It is set to kx. speed =0x%x\n", speed);
+
+	/* Wait xpcs power-up good */
+	status = read_poll_timeout(txgbe_rd32_epcs, value,
+				   (value & TXGBE_VR_XS_OR_PCS_MMD_DIGI_ST_PS_M) ==
+				   TXGBE_VR_XS_OR_PCS_MMD_DIGI_ST_PS_PG,
+				   10000, 1000000, false,
+				   hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_ST);
+	if (status < 0) {
+		wx_err(wxhw, "xpcs power-up timeout.\n");
+		return;
+	}
+
+	wr32m(wxhw, WX_MAC_TX_CFG, WX_MAC_TX_CFG_TE, 0);
+
+	/* Disable xpcs AN-73 */
+	if (!autoneg)
+		txgbe_wr32_epcs(hw, TXGBE_SR_AN_MMD_CTL, 0);
+	else
+		txgbe_wr32_epcs(hw, TXGBE_SR_AN_MMD_CTL,
+				TXGBE_SR_AN_MMD_CTL_EXT_NP_CTL | TXGBE_SR_AN_MMD_CTL_ENABLE);
+
+	/* Disable PHY MPLLA for eth mode change(after ECO) */
+	txgbe_wr32_ephy(hw, TXGBE_SUP_DIG_MPLLA_OVRD_IN_0, 0x240A);
+	WX_WRITE_FLUSH(wxhw);
+	msleep(20);
+
+	/* Set the eth change_mode bit first in mis_rst register */
+	/* for corresponding LAN port */
+	wr32(wxhw, WX_MIS_RST, WX_MIS_RST_LAN_ETH_MODE(wxhw->bus.func));
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
+	wdata = TXGBE_SR_MII_MMD_CTL_DUPLEX_MODE;
+	if (speed == SPEED_100)
+		wdata |= TXGBE_SR_MII_MMD_CTL_SGMII_100;
+	else if (speed == SPEED_1000)
+		wdata |= TXGBE_SR_MII_MMD_CTL_SGMII_1000;
+	else if (speed == SPEED_10)
+		wdata |= TXGBE_SR_MII_MMD_CTL_SGMII_10;
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
+	txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_ATT_LVL0, 0x0);
+
+	txgbe_wr32_epcs(hw, TXGBE_PHY_DFE_TAP_CTL0, 0x0);
+
+	value = (0x6db & ~0x7) | 0x4;
+	txgbe_wr32_epcs(hw, TXGBE_PHY_RX_GEN_CTL3, value);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY MPLLA Control
+	 * 0 Register Bit[7:0] = 8'd32  MPLLA_MULTIPLIER
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_MPLLA_CTL0, 0x20);
+
+	/* Set VR XS, PMA or MII Synopsys Enterprise Gen5 12G PHY MPLLA Control
+	 * 3 Register Bit[10:0] = 11'd70  MPLLA_BANDWIDTH
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_MPLLA_CTL3, 0x56);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY VCO
+	 * Calibration Load 0 Register  Bit[12:0] = 13'd1344  VCO_LD_VAL_0
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_LD0, 0x540);
+
+	txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_LD1, 0x549);
+	txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_LD2, 0x549);
+	txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_LD3, 0x549);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY VCO
+	 * Calibration Reference 0 Register Bit[5:0] = 6'd42  VCO_REF_LD_0
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_VCO_CAL_REF0, 0x2A);
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
+	txgbe_wr32_epcs(hw, TXGBE_PHY_TX_RATE_CTL, 0x3);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY Rx Rate
+	 * Control Register Bit[2:0] = 3'b011 RX0_RATE
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_RX_RATE_CTL, 0x3);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY Tx General
+	 * Control 2 Register Bit[9:8] = 2'b01  TX0_WIDTH: 10bits
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_TX_GEN_CTL2, 0x100);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY Rx General
+	 * Control 2 Register Bit[9:8] = 2'b01  RX0_WIDTH: 10bits
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_RX_GEN_CTL2, 0x100);
+
+	/* Set VR XS, PMA, or MII Synopsys Enterprise Gen5 12G PHY MPLLA Control
+	 * 2 Register Bit[10:8] = 3'b010	MPLLA_DIV16P5_CLK_EN=0,
+	 * MPLLA_DIV10_CLK_EN=1, MPLLA_DIV8_CLK_EN=0
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_PHY_MPLLA_CTL2, 0x200);
+
+	/* VR MII MMD AN Control Register Bit[8] = 1'b1 MII_CTRL */
+	/* Set to 8bit MII (required in 10M/100M SGMII) */
+	txgbe_wr32_epcs(hw, TXGBE_SR_MII_MMD_AN_CTL, 0x100);
+
+	/* Initialize the mode by setting VR XS or PCS MMD Digital Control1
+	 * Register Bit[15](VR_RST)
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1, 0xA000);
+	/* wait phy initialization done */
+	status = read_poll_timeout(txgbe_rd32_epcs, value,
+				   !(value & TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1_VR_RST),
+				   100000, 10000000, false,
+				   hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1);
+	if (status < 0) {
+		wx_err(wxhw, "PHY initialization timeout.\n");
+		return;
+	}
+
+	/* if success, set link status */
+	hw->link_status = TXGBE_LINK_STATUS_KX;
+}
+
+static void txgbe_set_link_to_sfi(struct txgbe_hw *hw, u32 speed)
+{
+	struct wx_hw *wxhw = &hw->wxhw;
+	int status = 0;
+	u32 value = 0;
+
+	/* Set the module link speed */
+	txgbe_set_hard_rate_select_speed(hw, speed);
+
+	/* Wait xpcs power-up good */
+	status = read_poll_timeout(txgbe_rd32_epcs, value,
+				   (value & TXGBE_VR_XS_OR_PCS_MMD_DIGI_ST_PS_M) ==
+				   TXGBE_VR_XS_OR_PCS_MMD_DIGI_ST_PS_PG,
+				   10000, 1000000, false,
+				   hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_ST);
+	if (status < 0) {
+		wx_err(wxhw, "xpcs power-up timeout.\n");
+		return;
+	}
+
+	wr32m(wxhw, WX_MAC_TX_CFG, WX_MAC_TX_CFG_TE, 0);
+
+	/* Disable xpcs AN-73 */
+	txgbe_wr32_epcs(hw, TXGBE_SR_AN_MMD_CTL, 0x0);
+
+	/* Disable PHY MPLLA for eth mode change(after ECO) */
+	txgbe_wr32_ephy(hw, TXGBE_SUP_DIG_MPLLA_OVRD_IN_0, 0x243A);
+	WX_WRITE_FLUSH(wxhw);
+	msleep(20);
+
+	/* Set the eth change_mode bit first in mis_rst register
+	 * for corresponding LAN port
+	 */
+	wr32(wxhw, WX_MIS_RST, WX_MIS_RST_LAN_ETH_MODE(wxhw->bus.func));
+
+	if (speed == SPEED_10000) {
+		/* Set SR PCS Control2 Register Bits[1:0] = 2'b00
+		 * PCS_TYPE_SEL: KR
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_SR_PCS_CTL2, 0);
+		value = txgbe_rd32_epcs(hw, TXGBE_SR_PMA_MMD_CTL1);
+		value |= TXGBE_SR_PMA_MMD_CTL1_SPEED_SEL_10G;
+		txgbe_wr32_epcs(hw, TXGBE_SR_PMA_MMD_CTL1, value);
+		/* Set VR_XS_PMA_Gen5_12G_MPLLA_CTRL0 Register Bit[7:0] = 8'd33
+		 * MPLLA_MULTIPLIER
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_MPLLA_CTL0, 0x0021);
+		/* Set VR_XS_PMA_Gen5_12G_MPLLA_CTRL3 Register
+		 * Bit[10:0](MPLLA_BANDWIDTH) = 11'd0
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_MPLLA_CTL3, 0);
+		value = txgbe_rd32_epcs(hw, TXGBE_PHY_TX_GENCTRL1);
+		value = (value & ~0x700) | 0x500;
+		txgbe_wr32_epcs(hw, TXGBE_PHY_TX_GENCTRL1, value);
+		/* Set VR_XS_PMA_Gen5_12G_MISC_CTRL0 Register
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
+		if (hw->phy.sfp_type == txgbe_sfp_type_da_cu_core) {
+			/* Set VR_XS_PMA_Gen5_12G_RX_EQ_CTRL0 Register
+			 * Bit[15:8](VGA1/2_GAIN_0) = 8'h77, Bit[7:5]
+			 * (CTLE_POLE_0) = 3'h2, Bit[4:0](CTLE_BOOST_0) = 4'hF
+			 */
+			txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_CTL0, 0x774F);
+		} else {
+			/* Set VR_XS_PMA_Gen5_12G_RX_EQ_CTRL0 Register
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
+		if (hw->phy.sfp_type == txgbe_sfp_type_da_cu_core) {
+			/* Set VR_XS_PMA_Gen5_12G_DFE_TAP_CTRL0 Register
+			 * Bit[7:0](DFE_TAP1_0) = 8'd20
+			 */
+			txgbe_wr32_epcs(hw, TXGBE_PHY_DFE_TAP_CTL0, 0x0014);
+			value = txgbe_rd32_epcs(hw, TXGBE_PHY_AFE_DFE_ENABLE);
+			value |= 0x11;
+			txgbe_wr32_epcs(hw, TXGBE_PHY_AFE_DFE_ENABLE, value);
+		} else {
+			/* Set VR_XS_PMA_Gen5_12G_DFE_TAP_CTRL0 Register
+			 * Bit[7:0](DFE_TAP1_0) = 8'd20
+			 */
+			txgbe_wr32_epcs(hw, TXGBE_PHY_DFE_TAP_CTL0, 0xBE);
+			/* Set VR_MII_Gen5_12G_AFE_DFE_EN_CTRL Register
+			 * Bit[4](DFE_EN_0) = 1'b0, Bit[0](AFE_EN_0) = 1'b0
+			 */
+			value = txgbe_rd32_epcs(hw, TXGBE_PHY_AFE_DFE_ENABLE);
+			value &= ~0x11;
+			txgbe_wr32_epcs(hw, TXGBE_PHY_AFE_DFE_ENABLE, value);
+		}
+		value = txgbe_rd32_epcs(hw, TXGBE_PHY_RX_EQ_CTL);
+		value &= ~0x1;
+		txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_CTL, value);
+	} else {
+		/* Set SR PCS Control2 Register Bits[1:0] = 2'b00
+		 * PCS_TYPE_SEL: KR
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_SR_PCS_CTL2, 0x1);
+		/* Set SR PMA MMD Control1 Register Bit[13] = 1'b0
+		 * SS13: 1G speed
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_SR_PMA_MMD_CTL1, 0x0);
+		/* Set SR MII MMD Control Register to corresponding speed: */
+		txgbe_wr32_epcs(hw, TXGBE_SR_MII_MMD_CTL, 0x0140);
+
+		value = txgbe_rd32_epcs(hw, TXGBE_PHY_TX_GENCTRL1);
+		value = (value & ~0x710) | 0x500;
+		txgbe_wr32_epcs(hw, TXGBE_PHY_TX_GENCTRL1, value);
+		/* Set VR_XS_PMA_Gen5_12G_MISC_CTRL0 Register
+		 * Bit[12:8](RX_VREF_CTRL) = 5'hF
+		 */
+		txgbe_wr32_epcs(hw, TXGBE_PHY_MISC_CTL0, 0xCF00);
+
+		if (hw->phy.sfp_type == txgbe_sfp_type_da_cu_core) {
+			txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_CTL0, 0x774F);
+		} else {
+			/* Set VR_XS_PMA_Gen5_12G_RX_EQ_CTRL0 Register
+			 * Bit[15:8] (VGA1/2_GAIN_0) = 8'h00,
+			 * Bit[7:5](CTLE_POLE_0) = 3'h2,
+			 * Bit[4:0](CTLE_BOOST_0) = 4'hA
+			 */
+			value = txgbe_rd32_epcs(hw, TXGBE_PHY_RX_EQ_CTL0);
+			value = (value & ~0xFFFF) | 0x7706;
+			txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_CTL0, value);
+		}
+		value = txgbe_rd32_epcs(hw, TXGBE_PHY_RX_EQ_ATT_LVL0);
+		value &= ~0x7;
+		txgbe_wr32_epcs(hw, TXGBE_PHY_RX_EQ_ATT_LVL0, value);
+		/* Set VR_XS_PMA_Gen5_12G_DFE_TAP_CTRL0 Register
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
+	/* Initialize the mode by setting VR XS or PCS MMD Digital Control1
+	 * Register Bit[15](VR_RST)
+	 */
+	txgbe_wr32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1, 0xA000);
+	/* wait phy initialization done */
+	status = read_poll_timeout(txgbe_rd32_epcs, value,
+				   !(value & TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1_VR_RST),
+				   100000, 10000000, false,
+				   hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1);
+	if (status < 0)
+		wx_err(wxhw, "PHY initialization timeout.\n");
+}
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
+	struct wx_hw *wxhw = &hw->wxhw;
+	u32 links_reg = 0;
+	int ret;
+
+	*link_up = false;
+
+	if (link_up_wait_to_complete) {
+		ret = read_poll_timeout(rd32, links_reg,
+					links_reg & TXGBE_CFG_PORT_ST_LINK_UP,
+					10000, 10000 * 900, false,
+					wxhw, TXGBE_CFG_PORT_ST);
+		if (!ret)
+			*link_up = true;
+	} else {
+		links_reg = rd32(wxhw, TXGBE_CFG_PORT_ST);
+		if (links_reg & TXGBE_CFG_PORT_ST_LINK_UP)
+			*link_up = true;
+	}
+
+	if (*link_up) {
+		if (links_reg & TXGBE_CFG_PORT_ST_LINK_10G)
+			*speed = SPEED_10000;
+		else if (links_reg & TXGBE_CFG_PORT_ST_LINK_1G)
+			*speed = SPEED_1000;
+		else if (links_reg & TXGBE_CFG_PORT_ST_LINK_100M)
+			*speed = SPEED_100;
+		else
+			*speed = SPEED_10;
+	} else {
+		*speed = SPEED_UNKNOWN;
+	}
+}
+
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
+	u16 sub_dev_id = hw->wxhw.subsystem_device_id & TXGBE_DEV_MASK;
+	u32 sr_pcs_ctl, sr_pma_mmd_ctl1, sr_an_mmd_ctl;
+	u32 sr_an_mmd_adv_reg2;
+
+	/* Check if 1G SFP module. */
+	if (hw->phy.sfp_type == txgbe_sfp_type_1g_cu_core ||
+	    hw->phy.sfp_type == txgbe_sfp_type_1g_lx_core ||
+	    hw->phy.sfp_type == txgbe_sfp_type_1g_sx_core) {
+		*speed = SPEED_1000;
+		*autoneg = false;
+	} else if (hw->phy.multispeed_fiber) {
+		*speed = SPEED_10000 | SPEED_1000;
+		*autoneg = true;
+	}
+	/* SFP */
+	else if (hw->phy.media_type == txgbe_media_type_fiber) {
+		*speed = SPEED_10000;
+		*autoneg = false;
+	}
+	/* SGMII */
+	else if (sub_dev_id == TXGBE_ID_SGMII) {
+		*speed = SPEED_1000 | SPEED_100 | SPEED_10;
+		*autoneg = false;
+		hw->phy.link_mode = TXGBE_PHYSICAL_LAYER_1000BASE_T |
+				TXGBE_PHYSICAL_LAYER_100BASE_TX;
+	/* MAC XAUI */
+	} else if (sub_dev_id == TXGBE_ID_MAC_XAUI) {
+		*speed = SPEED_10000;
+		*autoneg = false;
+		hw->phy.link_mode = TXGBE_PHYSICAL_LAYER_10GBASE_KX4;
+	/* MAC SGMII */
+	} else if (sub_dev_id == TXGBE_ID_MAC_SGMII) {
+		*speed = SPEED_1000;
+		*autoneg = false;
+		hw->phy.link_mode = TXGBE_PHYSICAL_LAYER_1000BASE_KX;
+	} else { /* KR KX KX4 */
+		/* Determine link capabilities based on the stored value,
+		 * which represents EEPROM defaults.  If value has not
+		 * been stored, use the current register values.
+		 */
+		if (hw->phy.orig_link_settings_stored) {
+			sr_pcs_ctl = hw->phy.orig_sr_pcs_ctl2;
+			sr_pma_mmd_ctl1 = hw->phy.orig_sr_pma_mmd_ctl1;
+			sr_an_mmd_ctl = hw->phy.orig_sr_an_mmd_ctl;
+			sr_an_mmd_adv_reg2 = hw->phy.orig_sr_an_mmd_adv_reg2;
+		} else {
+			sr_pcs_ctl = txgbe_rd32_epcs(hw, TXGBE_SR_PCS_CTL2);
+			sr_pma_mmd_ctl1 = txgbe_rd32_epcs(hw, TXGBE_SR_PMA_MMD_CTL1);
+			sr_an_mmd_ctl = txgbe_rd32_epcs(hw, TXGBE_SR_AN_MMD_CTL);
+			sr_an_mmd_adv_reg2 = txgbe_rd32_epcs(hw, TXGBE_SR_AN_MMD_ADV_REG2);
+		}
+
+		if ((sr_pcs_ctl & TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_MASK) ==
+				TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_X &&
+		    (sr_pma_mmd_ctl1 & TXGBE_SR_PMA_MMD_CTL1_SPEED_SEL_MASK) ==
+				TXGBE_SR_PMA_MMD_CTL1_SPEED_SEL_1G &&
+		    (sr_an_mmd_ctl & TXGBE_SR_AN_MMD_CTL_ENABLE) == 0) {
+			/* 1G or KX - no backplane auto-negotiation */
+			*speed = SPEED_1000;
+			*autoneg = false;
+			hw->phy.link_mode = TXGBE_PHYSICAL_LAYER_1000BASE_KX;
+		} else if ((sr_pcs_ctl & TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_MASK) ==
+				TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_X &&
+			   (sr_pma_mmd_ctl1 & TXGBE_SR_PMA_MMD_CTL1_SPEED_SEL_MASK) ==
+				TXGBE_SR_PMA_MMD_CTL1_SPEED_SEL_10G &&
+			   (sr_an_mmd_ctl & TXGBE_SR_AN_MMD_CTL_ENABLE) == 0) {
+			*speed = SPEED_10000;
+			*autoneg = false;
+			hw->phy.link_mode = TXGBE_PHYSICAL_LAYER_10GBASE_KX4;
+		} else if ((sr_pcs_ctl & TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_MASK) ==
+				TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_R &&
+			   (sr_an_mmd_ctl & TXGBE_SR_AN_MMD_CTL_ENABLE) == 0) {
+			/* 10 GbE serial link (KR -no backplane auto-negotiation) */
+			*speed = SPEED_10000;
+			*autoneg = false;
+			hw->phy.link_mode = TXGBE_PHYSICAL_LAYER_10GBASE_KR;
+		} else if (sr_an_mmd_ctl & TXGBE_SR_AN_MMD_CTL_ENABLE) {
+			/* KX/KX4/KR backplane auto-negotiation enable */
+			*speed = SPEED_UNKNOWN;
+			if (sr_an_mmd_adv_reg2 & TXGBE_SR_AN_MMD_ADV_REG2_BP_TYPE_KR)
+				*speed |= SPEED_10000;
+			if (sr_an_mmd_adv_reg2 & TXGBE_SR_AN_MMD_ADV_REG2_BP_TYPE_KX4)
+				*speed |= SPEED_10000;
+			if (sr_an_mmd_adv_reg2 & TXGBE_SR_AN_MMD_ADV_REG2_BP_TYPE_KX)
+				*speed |= SPEED_1000;
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
+/**
+ *  txgbe_disable_tx_laser - Disable Tx laser
+ *  @hw: pointer to hardware structure
+ *
+ *  The base drivers may require better control over SFP+ module
+ *  PHY states.  This includes selectively shutting down the Tx
+ *  laser on the PHY, effectively halting physical link.
+ **/
+void txgbe_disable_tx_laser(struct txgbe_hw *hw)
+{
+	struct wx_hw *wxhw = &hw->wxhw;
+	u32 esdp_reg;
+
+	if (hw->phy.media_type != txgbe_media_type_fiber)
+		return;
+
+	/* Disable Tx laser; allow 100us to go dark per spec */
+	esdp_reg = rd32(wxhw, TXGBE_GPIO_DR);
+	esdp_reg |= TXGBE_GPIO_DR_1 | TXGBE_GPIO_DR_0;
+	wr32(wxhw, TXGBE_GPIO_DR, esdp_reg);
+	WX_WRITE_FLUSH(wxhw);
+	usleep_range(100, 200);
+}
+
+/**
+ *  txgbe_enable_tx_laser - Enable Tx laser
+ *  @hw: pointer to hardware structure
+ *
+ *  The base drivers may require better control over SFP+ module
+ *  PHY states.  This includes selectively turning on the Tx
+ *  laser on the PHY, effectively starting physical link.
+ **/
+void txgbe_enable_tx_laser(struct txgbe_hw *hw)
+{
+	struct wx_hw *wxhw = &hw->wxhw;
+
+	if (hw->phy.media_type != txgbe_media_type_fiber)
+		return;
+
+	/* Enable Tx laser; allow 100ms to light up */
+	wr32m(wxhw, TXGBE_GPIO_DR,
+	      TXGBE_GPIO_DR_0 | TXGBE_GPIO_DR_1, 0);
+	WX_WRITE_FLUSH(wxhw);
+	msleep(100);
+}
+
+/**
+ *  txgbe_flap_tx_laser - Flap Tx laser
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
+static void txgbe_flap_tx_laser(struct txgbe_hw *hw)
+{
+	if (hw->phy.media_type != txgbe_media_type_fiber)
+		return;
+
+	if (hw->phy.autotry_restart) {
+		txgbe_disable_tx_laser(hw);
+		txgbe_enable_tx_laser(hw);
+		hw->phy.autotry_restart = false;
+	}
+}
+
+/**
+ *  txgbe_setup_mac_link - Set MAC link speed
+ *  @hw: pointer to hardware structure
+ *  @speed: new link speed
+ *
+ *  Set the link speed.
+ **/
+static int txgbe_setup_mac_link(struct txgbe_hw *hw, u32 speed)
+{
+	u16 sub_dev_id = hw->wxhw.subsystem_device_id & TXGBE_DEV_MASK;
+	u32 link_capabilities = SPEED_UNKNOWN;
+	u32 link_speed = SPEED_UNKNOWN;
+	bool autoneg = false;
+	bool link_up = false;
+	int status = 0;
+
+	/* Check to see if speed passed in is supported. */
+	status = txgbe_get_link_capabilities(hw, &link_capabilities, &autoneg);
+	if (status)
+		return status;
+
+	speed &= link_capabilities;
+	if (speed == SPEED_UNKNOWN)
+		return -EINVAL;
+
+	if (!(sub_dev_id == TXGBE_ID_KR_KX_KX4 ||
+	      sub_dev_id == TXGBE_ID_MAC_XAUI ||
+	      sub_dev_id == TXGBE_ID_MAC_SGMII)) {
+		txgbe_check_mac_link(hw, &link_speed, &link_up, false);
+		if (link_speed == speed && link_up)
+			return 0;
+	}
+
+	if (sub_dev_id == TXGBE_ID_KR_KX_KX4) {
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
+	} else if (sub_dev_id == TXGBE_ID_XAUI ||
+		   sub_dev_id == TXGBE_ID_MAC_XAUI ||
+		   sub_dev_id == TXGBE_ID_SGMII ||
+		   sub_dev_id == TXGBE_ID_MAC_SGMII) {
+		if (speed == SPEED_10000) {
+			txgbe_set_link_to_kx4(hw, 0);
+		} else {
+			txgbe_set_link_to_kx(hw, speed, 0);
+			txgbe_set_sgmii_an37_ability(hw);
+		}
+	} else if (hw->phy.media_type == txgbe_media_type_fiber) {
+		txgbe_set_link_to_sfi(hw, speed);
+		if (speed == SPEED_1000)
+			txgbe_set_sgmii_an37_ability(hw);
+	}
+
+	return 0;
+}
+
+/**
+ *  txgbe_setup_link - Set MAC link speed
+ *  @hw: pointer to hardware structure
+ *  @speed: new link speed
+ *  @autoneg_wait_to_complete: true when waiting for completion is needed
+ *
+ *  Set the link speed in the MAC and/or PHY register and restarts link.
+ **/
+int txgbe_setup_link(struct txgbe_hw *hw, u32 speed,
+		     bool autoneg_wait_to_complete)
+{
+	u32 highest_link_speed = SPEED_UNKNOWN;
+	u32 link_speed = SPEED_UNKNOWN;
+	bool autoneg, link_up = false;
+	u32 speedcnt = 0;
+	int status = 0;
+	u32 i = 0;
+
+	if (!hw->phy.multispeed_fiber)
+		return txgbe_setup_mac_link(hw, speed);
+
+	/* Mask off requested but non-supported speeds */
+	status = txgbe_get_link_capabilities(hw, &link_speed, &autoneg);
+	if (status != 0)
+		return status;
+
+	speed &= link_speed;
+
+	/* Try each speed one by one, highest priority first.  We do this in
+	 * software because 10Gb fiber doesn't support speed autonegotiation.
+	 */
+	if (speed & SPEED_10000) {
+		speedcnt++;
+		highest_link_speed = SPEED_10000;
+
+		/* If we already have link at this speed, just jump out */
+		txgbe_check_mac_link(hw, &link_speed, &link_up, false);
+		if (link_speed == SPEED_10000 && link_up)
+			goto out;
+
+		/* Allow module to change analog characteristics (1G->10G) */
+		msleep(40);
+
+		status = txgbe_setup_mac_link(hw, SPEED_10000);
+		if (status != 0)
+			return status;
+
+		/* Flap the Tx laser if it has not already been done */
+		txgbe_flap_tx_laser(hw);
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
+			txgbe_check_mac_link(hw, &link_speed, &link_up, false);
+			if (link_up)
+				goto out;
+		}
+	}
+
+	if (speed & SPEED_1000) {
+		speedcnt++;
+		if (highest_link_speed == SPEED_UNKNOWN)
+			highest_link_speed = SPEED_1000;
+
+		/* If we already have link at this speed, just jump out */
+		txgbe_check_mac_link(hw, &link_speed, &link_up, false);
+		if (link_speed == SPEED_1000 && link_up)
+			goto out;
+
+		/* Allow module to change analog characteristics (10G->1G) */
+		msleep(40);
+
+		status = txgbe_setup_mac_link(hw, SPEED_1000);
+		if (status != 0)
+			return status;
+
+		/* Flap the Tx laser if it has not already been done */
+		txgbe_flap_tx_laser(hw);
+
+		/* Wait for the link partner to also set speed */
+		msleep(100);
+
+		/* If we have link, just jump out */
+		txgbe_check_mac_link(hw, &link_speed, &link_up, false);
+		if (link_up)
+			goto out;
+	}
+
+	/* We didn't get link.  Configure back to the highest speed we tried,
+	 * (if there was more than one).  We call ourselves back with just the
+	 * single highest speed that the user requested.
+	 */
+	if (speedcnt > 1)
+		status = txgbe_setup_link(hw, highest_link_speed,
+					  autoneg_wait_to_complete);
+
+out:
+	/* Set autoneg_advertised value based on input link speed */
+	hw->phy.autoneg_advertised = 0;
+
+	if (speed & SPEED_10000)
+		hw->phy.autoneg_advertised |= SPEED_10000;
+
+	if (speed & SPEED_1000)
+		hw->phy.autoneg_advertised |= SPEED_1000;
+
+	return status;
+}
+
 /**
  *  txgbe_init_thermal_sensor_thresh - Inits thermal sensor thresholds
  *  @hw: pointer to hardware structure
@@ -628,8 +1755,14 @@ int txgbe_validate_eeprom_checksum(struct txgbe_hw *hw, u16 *checksum_val)
 static void txgbe_reset_misc(struct txgbe_hw *hw)
 {
 	struct wx_hw *wxhw = &hw->wxhw;
+	u32 value;
 
 	txgbe_init_i2c(hw);
+
+	value = txgbe_rd32_epcs(hw, TXGBE_SR_PCS_CTL2);
+	if ((value & 0x3) != TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_X)
+		hw->link_status = TXGBE_LINK_STATUS_NONE;
+
 	wx_reset_misc(wxhw);
 	txgbe_init_thermal_sensor_thresh(hw);
 }
@@ -672,8 +1805,11 @@ int txgbe_reset_hw(struct txgbe_hw *hw)
 		txgbe_rd32_epcs(hw, TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1);
 
 	if (!(((wxhw->subsystem_device_id & WX_NCSI_MASK) == WX_NCSI_SUP) ||
-	      ((wxhw->subsystem_device_id & WX_WOL_MASK) == WX_WOL_SUP)))
-		wx_reset_hostif(wxhw);
+	      ((wxhw->subsystem_device_id & WX_WOL_MASK) == WX_WOL_SUP))) {
+		status = wx_reset_hostif(wxhw);
+		if (status == 0)
+			hw->link_status = TXGBE_LINK_STATUS_NONE;
+	}
 
 	usleep_range(10, 100);
 
@@ -729,3 +1865,32 @@ int txgbe_reset_hw(struct txgbe_hw *hw)
 
 	return 0;
 }
+
+/**
+ *  txgbe_start_hw - Prepare hardware for Tx/Rx
+ *  @hw: pointer to hardware structure
+ *
+ *  Starts the hardware using the generic start_hw function
+ *  and the generation start_hw function.
+ *  Then performs revision-specific operations, if any.
+ **/
+void txgbe_start_hw(struct txgbe_hw *hw)
+{
+	/* We need to run link autotry after the driver loads */
+	hw->phy.autotry_restart = true;
+}
+
+int txgbe_init_hw(struct txgbe_hw *hw)
+{
+	int status;
+
+	/* Reset the hardware */
+	status = txgbe_reset_hw(hw);
+
+	if (status == 0) {
+		/* Start the HW */
+		txgbe_start_hw(hw);
+	}
+
+	return status;
+}
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index 6a751a69177b..32d3f9d7c0e5 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -4,8 +4,17 @@
 #ifndef _TXGBE_HW_H_
 #define _TXGBE_HW_H_
 
+int txgbe_identify_sfp_module(struct txgbe_hw *hw);
+void txgbe_check_mac_link(struct txgbe_hw *hw, u32 *speed,
+			  bool *link_up, bool link_up_wait_to_complete);
+int txgbe_get_link_capabilities(struct txgbe_hw *hw, u32 *speed, bool *autoneg);
+void txgbe_disable_tx_laser(struct txgbe_hw *hw);
+void txgbe_enable_tx_laser(struct txgbe_hw *hw);
+int txgbe_setup_link(struct txgbe_hw *hw, u32 speed, bool autoneg_wait_to_complete);
 int txgbe_read_pba_string(struct txgbe_hw *hw, u8 *pba_num, u32 pba_num_size);
 int txgbe_validate_eeprom_checksum(struct txgbe_hw *hw, u16 *checksum_val);
 int txgbe_reset_hw(struct txgbe_hw *hw);
+void txgbe_start_hw(struct txgbe_hw *hw);
+int txgbe_init_hw(struct txgbe_hw *hw);
 
 #endif /* _TXGBE_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index cb86c001baa6..a0efe4259fdc 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -7,7 +7,9 @@
 #include <linux/netdevice.h>
 #include <linux/string.h>
 #include <linux/aer.h>
+#include <linux/timecounter.h>
 #include <linux/etherdevice.h>
+#include <linux/ethtool.h>
 #include <net/ip.h>
 
 #include "../libwx/wx_type.h"
@@ -93,12 +95,250 @@ static void txgbe_service_event_complete(struct txgbe_adapter *adapter)
 	clear_bit(__TXGBE_SERVICE_SCHED, &adapter->state);
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
+	struct wx_hw *wxhw = &hw->wxhw;
+	u32 i, reg;
+
+	if (!(adapter->flags & TXGBE_FLAG_NEED_LINK_UPDATE))
+		return;
+
+	link_speed = SPEED_10000;
+	link_up = true;
+	txgbe_check_mac_link(hw, &link_speed, &link_up, false);
+
+	if (link_up || time_after(jiffies, (adapter->link_check_timeout +
+					    TXGBE_TRY_LINK_TIMEOUT))) {
+		adapter->flags &= ~TXGBE_FLAG_NEED_LINK_UPDATE;
+	}
+
+	for (i = 0; i < 3; i++) {
+		txgbe_check_mac_link(hw, &link_speed, &link_up, false);
+		msleep(20);
+	}
+
+	adapter->link_up = link_up;
+	adapter->link_speed = link_speed;
+
+	if (link_up) {
+		if (link_speed & SPEED_10000) {
+			reg = rd32(wxhw, WX_MAC_TX_CFG);
+			reg &= ~WX_MAC_TX_CFG_SPEED_MASK;
+			reg |= WX_MAC_TX_CFG_SPEED_10G | WX_MAC_TX_CFG_TE;
+			wr32(wxhw, WX_MAC_TX_CFG, reg);
+		} else if (link_speed & (SPEED_1000 | SPEED_100 | SPEED_10)) {
+			reg = rd32(wxhw, WX_MAC_TX_CFG);
+			reg &= ~WX_MAC_TX_CFG_SPEED_MASK;
+			reg |= WX_MAC_TX_CFG_SPEED_1G | WX_MAC_TX_CFG_TE;
+			wr32(wxhw, WX_MAC_TX_CFG, reg);
+		}
+
+		/* Re configure MAC RX */
+		reg = rd32(wxhw, WX_MAC_RX_CFG);
+		wr32(wxhw, WX_MAC_RX_CFG, reg);
+		wr32(wxhw, WX_MAC_PKT_FLT, WX_MAC_PKT_FLT_PR);
+		reg = rd32(wxhw, WX_MAC_WDG_TIMEOUT);
+		wr32(wxhw, WX_MAC_WDG_TIMEOUT, reg);
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
+	const char *speed_str;
+
+	/* only continue if link was previously down */
+	if (netif_carrier_ok(netdev))
+		return;
+
+	switch (adapter->link_speed) {
+	case SPEED_10000:
+		speed_str = "10 Gbps";
+		break;
+	case SPEED_1000:
+		speed_str = "1 Gbps";
+		break;
+	case SPEED_100:
+		speed_str = "100 Mbps";
+		break;
+	case SPEED_10:
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
+	int err;
+
+	/* not searching for SFP so there is nothing to do here */
+	if (!(adapter->flags & TXGBE_FLAG_SFP_NEEDS_RESET))
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
+	err = txgbe_identify_sfp_module(hw);
+	if (err != 0) {
+		if (hw->phy.sfp_type == txgbe_sfp_type_not_present) {
+			/* If no cable is present, then we need to reset
+			 * the next time we find a good cable.
+			 */
+			adapter->flags |= TXGBE_FLAG_SFP_NEEDS_RESET;
+		}
+		/* exit on error */
+		goto sfp_out;
+	}
+
+	/* exit if reset not needed */
+	if (!(adapter->flags & TXGBE_FLAG_SFP_NEEDS_RESET))
+		goto sfp_out;
+
+	adapter->flags &= ~TXGBE_FLAG_SFP_NEEDS_RESET;
+
+	if (!hw->phy.multispeed_fiber)
+		hw->phy.autoneg_advertised = 0;
+
+	adapter->flags |= TXGBE_FLAG_NEED_LINK_CONFIG;
+	netif_info(adapter, probe, adapter->netdev,
+		   "detected SFP+: %d\n", hw->phy.sfp_type);
+
+sfp_out:
+	clear_bit(__TXGBE_IN_SFP_INIT, &adapter->state);
+
+	if (hw->phy.type == txgbe_phy_sfp_unsupported)
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
+	if ((hw->wxhw.subsystem_device_id & TXGBE_DEV_MASK) ==
+	    TXGBE_ID_MAC_SGMII) {
+		speed = SPEED_10000;
+	} else {
+		speed = hw->phy.autoneg_advertised;
+		if (!speed) {
+			txgbe_get_link_capabilities(hw, &speed, &autoneg);
+			/* setup the highest link when no autoneg */
+			if (!autoneg) {
+				if (speed & SPEED_10000)
+					speed = SPEED_10000;
+			}
+		}
+	}
+
+	txgbe_setup_link(hw, speed, false);
+
+	adapter->flags |= TXGBE_FLAG_NEED_LINK_UPDATE;
+	adapter->link_check_timeout = jiffies;
+	clear_bit(__TXGBE_IN_SFP_INIT, &adapter->state);
+}
+
 static void txgbe_service_timer(struct timer_list *t)
 {
 	struct txgbe_adapter *adapter = from_timer(adapter, t, service_timer);
 	unsigned long next_event_offset;
 
-	next_event_offset = HZ * 2;
+	/* poll faster when waiting for link */
+	if (adapter->flags & TXGBE_FLAG_NEED_LINK_UPDATE) {
+		if ((adapter->hw.wxhw.subsystem_device_id & TXGBE_DEV_MASK) ==
+		    TXGBE_ID_KR_KX_KX4)
+			next_event_offset = HZ;
+		else
+			next_event_offset = HZ / 10;
+	} else {
+		next_event_offset = HZ * 2;
+	}
 
 	/* Reset the timer */
 	mod_timer(&adapter->service_timer, next_event_offset + jiffies);
@@ -116,6 +356,9 @@ static void txgbe_service_task(struct work_struct *work)
 						     struct txgbe_adapter,
 						     service_task);
 
+	txgbe_sfp_detection_subtask(adapter);
+	txgbe_sfp_link_config_subtask(adapter);
+	txgbe_watchdog_subtask(adapter);
 	txgbe_service_event_complete(adapter);
 }
 
@@ -208,8 +451,55 @@ static void txgbe_up_complete(struct txgbe_adapter *adapter)
 {
 	struct txgbe_hw *hw = &adapter->hw;
 	struct wx_hw *wxhw = &hw->wxhw;
+	u32 links_reg;
 
 	wx_control_hw(wxhw, true);
+
+	/* enable the optics for SFP+ fiber */
+	txgbe_enable_tx_laser(hw);
+
+	/* make sure to complete pre-operations */
+	smp_mb__before_atomic();
+	clear_bit(__TXGBE_DOWN, &adapter->state);
+
+	if (hw->phy.media_type == txgbe_media_type_fiber) {
+		/* We are assuming the worst case scenerio here, and that
+		 * is that an SFP was inserted/removed after the reset
+		 * but before SFP detection was enabled.  As such the best
+		 * solution is to just start searching as soon as we start
+		 */
+		adapter->flags |= TXGBE_FLAG_SFP_NEEDS_RESET;
+		adapter->sfp_poll_time = 0;
+	} else if (hw->phy.media_type == txgbe_media_type_backplane) {
+		adapter->flags |= TXGBE_FLAG_NEED_LINK_CONFIG;
+		txgbe_service_event_schedule(adapter);
+	}
+
+	links_reg = rd32(wxhw, TXGBE_CFG_PORT_ST);
+	if (links_reg & TXGBE_CFG_PORT_ST_LINK_UP) {
+		if (links_reg & TXGBE_CFG_PORT_ST_LINK_10G) {
+			wr32(wxhw, WX_MAC_TX_CFG,
+			     (rd32(wxhw, WX_MAC_TX_CFG) & ~WX_MAC_TX_CFG_SPEED_MASK) |
+			     WX_MAC_TX_CFG_SPEED_10G);
+		} else if (links_reg & (TXGBE_CFG_PORT_ST_LINK_1G |
+					TXGBE_CFG_PORT_ST_LINK_100M)) {
+			wr32(wxhw, WX_MAC_TX_CFG,
+			     (rd32(wxhw, WX_MAC_TX_CFG) & ~WX_MAC_TX_CFG_SPEED_MASK) |
+			     WX_MAC_TX_CFG_SPEED_1G);
+		}
+	}
+
+	/* bring the link up in the watchdog, this could race with our first
+	 * link up interrupt but shouldn't be a problem
+	 */
+	adapter->flags |= TXGBE_FLAG_NEED_LINK_UPDATE;
+	adapter->link_check_timeout = jiffies;
+
+	mod_timer(&adapter->service_timer, jiffies);
+
+	/* Set PF Reset Done bit so PF/VF Mail Ops can work */
+	wr32m(wxhw, WX_CFG_PORT_CTL,
+	      WX_CFG_PORT_CTL_PFRSTD, WX_CFG_PORT_CTL_PFRSTD);
 }
 
 static void txgbe_reset(struct txgbe_adapter *adapter)
@@ -219,12 +509,21 @@ static void txgbe_reset(struct txgbe_adapter *adapter)
 	u8 old_addr[ETH_ALEN];
 	int err;
 
-	err = txgbe_reset_hw(hw);
+	/* lock SFP init bit to prevent race conditions with the watchdog */
+	while (test_and_set_bit(__TXGBE_IN_SFP_INIT, &adapter->state))
+		usleep_range(1000, 2000);
+
+	/* clear all SFP and link config related flags while holding SFP_INIT */
+	adapter->flags &= ~TXGBE_FLAG_SFP_NEEDS_RESET;
+	adapter->flags &= ~TXGBE_FLAG_NEED_LINK_CONFIG;
+
+	err = txgbe_init_hw(hw);
 	if (err != 0 &&
 	    hw->phy.type != txgbe_phy_sfp_unsupported &&
 	    hw->phy.sfp_type != txgbe_sfp_type_not_present)
 		dev_err(&adapter->pdev->dev, "Hardware Error: %d\n", err);
 
+	clear_bit(__TXGBE_IN_SFP_INIT, &adapter->state);
 	/* do not flush user set addresses */
 	memcpy(old_addr, &adapter->mac_table[0].addr, netdev->addr_len);
 	txgbe_flush_sw_mac_table(adapter);
@@ -247,6 +546,8 @@ static void txgbe_disable_device(struct txgbe_adapter *adapter)
 	netif_carrier_off(netdev);
 	netif_tx_disable(netdev);
 
+	adapter->flags &= ~TXGBE_FLAG_NEED_LINK_UPDATE;
+
 	del_timer_sync(&adapter->service_timer);
 
 	if (wxhw->bus.func < 2)
@@ -268,8 +569,14 @@ static void txgbe_disable_device(struct txgbe_adapter *adapter)
 
 static void txgbe_down(struct txgbe_adapter *adapter)
 {
+	struct txgbe_hw *hw = &adapter->hw;
+
 	txgbe_disable_device(adapter);
 	txgbe_reset(adapter);
+
+	if ((hw->wxhw.subsystem_device_id & WX_NCSI_MASK) != WX_NCSI_SUP)
+		/* power down the optics for SFP+ fiber */
+		txgbe_disable_tx_laser(hw);
 }
 
 /**
@@ -350,7 +657,11 @@ static int txgbe_open(struct net_device *netdev)
  */
 static void txgbe_close_suspend(struct txgbe_adapter *adapter)
 {
+	struct txgbe_hw *hw = &adapter->hw;
+
 	txgbe_disable_device(adapter);
+	if ((hw->wxhw.subsystem_device_id & WX_NCSI_MASK) != WX_NCSI_SUP)
+		txgbe_disable_tx_laser(hw);
 }
 
 /**
@@ -618,12 +929,18 @@ static int txgbe_probe(struct pci_dev *pdev,
 			 "0x%08x", etrack_id);
 	}
 
+	txgbe_start_hw(hw);
+
 	err = register_netdev(netdev);
 	if (err)
 		goto err_release_hw;
 
 	pci_set_drvdata(pdev, adapter);
 
+	if (!((wxhw->subsystem_device_id & WX_NCSI_MASK) == WX_NCSI_SUP))
+		/* power down the optics for SFP+ fiber */
+		txgbe_disable_tx_laser(hw);
+
 	/* calculate the expected PCIe bandwidth required for optimal
 	 * performance. Note that some older parts will never have enough
 	 * bandwidth due to being older generation PCIe parts. We clamp these
@@ -638,6 +955,11 @@ static int txgbe_probe(struct pci_dev *pdev,
 	else
 		dev_warn(&pdev->dev, "Failed to enumerate PF devices.\n");
 
+	if ((wxhw->subsystem_device_id & WX_NCSI_MASK) == WX_NCSI_SUP)
+		netif_info(adapter, probe, netdev, "NCSI : support");
+	else
+		netif_info(adapter, probe, netdev, "NCSI : unsupported");
+
 	/* First try to read PBA as a string */
 	err = txgbe_read_pba_string(hw, part_str, TXGBE_PBANUM_LENGTH);
 	if (err)
@@ -654,6 +976,14 @@ static int txgbe_probe(struct pci_dev *pdev,
 
 	netif_info(adapter, probe, netdev, "%pM\n", netdev->dev_addr);
 
+	netif_info(adapter, probe, netdev,
+		   "WangXun(R) 10 Gigabit Network Connection\n");
+
+	/* setup link for SFP devices with MNG FW, else wait for TXGBE_UP */
+	if (hw->phy.media_type == txgbe_media_type_fiber &&
+	    ((wxhw->subsystem_device_id & WX_NCSI_MASK) == WX_NCSI_SUP))
+		txgbe_setup_link(hw, SPEED_10000 | SPEED_1000, true);
+
 	return 0;
 
 err_release_hw:
@@ -692,6 +1022,7 @@ static void txgbe_remove(struct pci_dev *pdev)
 	cancel_work_sync(&adapter->service_task);
 
 	unregister_netdev(netdev);
+	wx_control_hw(&adapter->hw.wxhw, false);
 
 	pci_release_selected_regions(pdev,
 				     pci_select_bars(pdev, IORESOURCE_MEM));
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 2f8be0118157..0c5d62892ba1 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -36,6 +36,8 @@
 /* Combined interface*/
 #define TXGBE_ID_SFI_XAUI			0x50
 
+#define TXGBE_DEV_MASK                          0xF0
+
 /* Revision ID */
 #define TXGBE_SP_MPW  1
 
@@ -56,12 +58,67 @@
 /*********************** ETH PHY ***********************/
 #define TXGBE_XPCS_IDA_ADDR                     0x13000
 #define TXGBE_XPCS_IDA_DATA                     0x13004
+#define TXGBE_ETHPHY_IDA_ADDR                   0x13008
+#define TXGBE_ETHPHY_IDA_DATA                   0x1300C
 /* ETH PHY Registers */
 #define TXGBE_SR_PCS_CTL2                       0x30007
+#define TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_R        0x0
+#define TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_X        BIT(0)
+#define TXGBE_SR_PCS_CTL2_PCS_TYPE_SEL_MASK     0x3
 #define TXGBE_SR_PMA_MMD_CTL1                   0x10000
+#define TXGBE_SR_PMA_MMD_CTL1_SPEED_SEL_1G      0x0
+#define TXGBE_SR_PMA_MMD_CTL1_SPEED_SEL_10G     BIT(13)
+#define TXGBE_SR_PMA_MMD_CTL1_SPEED_SEL_MASK    BIT(13)
 #define TXGBE_SR_AN_MMD_CTL                     0x70000
+#define TXGBE_SR_AN_MMD_CTL_EXT_NP_CTL          BIT(13)
+#define TXGBE_SR_AN_MMD_CTL_ENABLE              BIT(12)
 #define TXGBE_SR_AN_MMD_ADV_REG2                0x70011
+#define TXGBE_SR_AN_MMD_ADV_REG2_BP_TYPE_KX     BIT(5)
+#define TXGBE_SR_AN_MMD_ADV_REG2_BP_TYPE_KX4    BIT(6)
+#define TXGBE_SR_AN_MMD_ADV_REG2_BP_TYPE_KR     BIT(7)
+#define TXGBE_SR_MII_MMD_CTL                    0x1F0000
+#define TXGBE_SR_MII_MMD_CTL_AN_EN              BIT(12)
+#define TXGBE_SR_MII_MMD_CTL_RESTART_AN         BIT(9)
+#define TXGBE_SR_MII_MMD_CTL_DUPLEX_MODE        BIT(8)
+#define TXGBE_SR_MII_MMD_CTL_SGMII_1000         BIT(6)
+#define TXGBE_SR_MII_MMD_CTL_SGMII_100          BIT(13)
+#define TXGBE_SR_MII_MMD_CTL_SGMII_10           0
+#define TXGBE_SR_MII_MMD_DIGI_CTL               0x1F8000
+#define TXGBE_SR_MII_MMD_DIGI_CTL_AS            BIT(9)
+#define TXGBE_SR_MII_MMD_AN_CTL                 0x1F8001
 #define TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1        0x38000
+#define TXGBE_VR_XS_OR_PCS_MMD_DIGI_CTL1_VR_RST BIT(15)
+#define TXGBE_VR_XS_OR_PCS_MMD_DIGI_ST          0x38010
+#define TXGBE_VR_XS_OR_PCS_MMD_DIGI_ST_PS_M     (0x7 << 2)
+#define TXGBE_VR_XS_OR_PCS_MMD_DIGI_ST_PS_PG    (BIT(2) << 2)
+#define TXGBE_VR_AN_INTR_MSK                    0x78001
+#define TXGBE_VR_AN_INTR_MSK_AN_PG_RCV_IE       BIT(2)
+#define TXGBE_VR_AN_INTR_MSK_AN_INC_LINK_IE     BIT(1)
+#define TXGBE_VR_AN_INTR_MSK_AN_INT_CMPLT_IE    BIT(0)
+#define TXGBE_VR_AN_KR_MODE_CL                  0x78003
+#define TXGBE_VR_AN_KR_MODE_CL_PDET_EN          BIT(0)
+#define TXGBE_PHY_TX_GENCTRL1                   0x18031
+#define TXGBE_PHY_TX_GEN_CTL2                   0x18032
+#define TXGBE_PHY_TX_RATE_CTL                   0x18034
+#define TXGBE_PHY_RX_GEN_CTL2                   0x18052
+#define TXGBE_PHY_RX_GEN_CTL3                   0x18053
+#define TXGBE_PHY_RX_RATE_CTL                   0x18054
+#define TXGBE_PHY_RX_EQ_ATT_LVL0                0x18057
+#define TXGBE_PHY_RX_EQ_CTL0                    0x18058
+#define TXGBE_PHY_RX_EQ_CTL                     0x1805C
+#define TXGBE_PHY_AFE_DFE_ENABLE                0x1805D
+#define TXGBE_PHY_DFE_TAP_CTL0                  0x1805E
+#define TXGBE_PHY_MPLLA_CTL0                    0x18071
+#define TXGBE_PHY_MPLLA_CTL2                    0x18073
+#define TXGBE_PHY_MPLLA_CTL3                    0x18077
+#define TXGBE_PHY_MISC_CTL0                     0x18090
+#define TXGBE_PHY_VCO_CAL_LD0                   0x18092
+#define TXGBE_PHY_VCO_CAL_LD1                   0x18093
+#define TXGBE_PHY_VCO_CAL_LD2                   0x18094
+#define TXGBE_PHY_VCO_CAL_LD3                   0x18095
+#define TXGBE_PHY_VCO_CAL_REF0                  0x18096
+#define TXGBE_PHY_VCO_CAL_REF1                  0x18097
+#define TXGBE_SUP_DIG_MPLLA_OVRD_IN_0           0x4
 /* I2C registers */
 #define TXGBE_I2C_CON                           0x14900 /* I2C Control */
 #define TXGBE_I2C_CON_SLAVE_DISABLE             BIT(6)
@@ -87,6 +144,25 @@
 #define TXGBE_I2C_SLAVE_ADDR                    (0xA0 >> 1)
 #define TXGBE_I2C_EEPROM_DEV_ADDR               0xA0
 
+/* port cfg Registers */
+#define TXGBE_CFG_PORT_ST                       0x14404
+#define TXGBE_CFG_PORT_ST_LINK_UP               BIT(0)
+#define TXGBE_CFG_PORT_ST_LINK_10G              BIT(1)
+#define TXGBE_CFG_PORT_ST_LINK_1G               BIT(2)
+#define TXGBE_CFG_PORT_ST_LINK_100M             BIT(3)
+
+/* GPIO Registers */
+#define TXGBE_GPIO_DR                           0x14800
+#define TXGBE_GPIO_DR_0                         BIT(0) /* SDP0 Data Value */
+#define TXGBE_GPIO_DR_1                         BIT(1) /* SDP1 Data Value */
+#define TXGBE_GPIO_DR_4                         BIT(4) /* SDP4 Data Value */
+#define TXGBE_GPIO_DR_5                         BIT(5) /* SDP5 Data Value */
+#define TXGBE_GPIO_DDR                          0x14804
+#define TXGBE_GPIO_DDR_0                        BIT(0) /* SDP0 IO direction */
+#define TXGBE_GPIO_DDR_1                        BIT(1) /* SDP1 IO direction */
+#define TXGBE_GPIO_DDR_4                        BIT(4) /* SDP4 IO direction */
+#define TXGBE_GPIO_DDR_5                        BIT(5) /* SDP5 IO direction */
+
 /* EEPROM byte offsets */
 #define TXGBE_SFF_IDENTIFIER                    0x0
 #define TXGBE_SFF_IDENTIFIER_SFP                0x3
@@ -133,6 +209,22 @@
 #define TXGBE_PBANUM1_PTR                       0x06
 #define TXGBE_PBANUM_PTR_GUARD                  0xFAFA
 
+/* Link speed */
+#define TXGBE_LINK_SPEED_AUTONEG                (SPEED_10 | \
+						 SPEED_100 | \
+						 SPEED_1000 | \
+						 SPEED_10000)
+
+/* Physical layer type */
+#define TXGBE_PHYSICAL_LAYER_UNKNOWN            0
+#define TXGBE_PHYSICAL_LAYER_10GBASE_T          BIT(0)
+#define TXGBE_PHYSICAL_LAYER_1000BASE_T         BIT(1)
+#define TXGBE_PHYSICAL_LAYER_100BASE_TX         BIT(2)
+#define TXGBE_PHYSICAL_LAYER_10GBASE_KX4        BIT(3)
+#define TXGBE_PHYSICAL_LAYER_1000BASE_KX        BIT(4)
+#define TXGBE_PHYSICAL_LAYER_10GBASE_KR         BIT(5)
+#define TXGBE_PHYSICAL_LAYER_10GBASE_XAUI       BIT(6)
+
 /* SFP+ module type IDs:
  *
  * ID   Module Type
@@ -188,11 +280,22 @@ struct txgbe_phy_info {
 	u32 orig_vr_xs_or_pcs_mmd_digi_ctl1;
 	bool orig_link_settings_stored;
 	bool multispeed_fiber;
+	bool autotry_restart;
+	u32 autoneg_advertised;
+	u32 link_mode;
+};
+
+/* link status for KX/KX4 */
+enum txgbe_link_status {
+	TXGBE_LINK_STATUS_NONE = 0,
+	TXGBE_LINK_STATUS_KX,
+	TXGBE_LINK_STATUS_KX4
 };
 
 struct txgbe_hw {
 	struct wx_hw wxhw;
 	struct txgbe_phy_info phy;
+	enum txgbe_link_status link_status;
 };
 
 #endif /* _TXGBE_TYPE_H_ */
-- 
2.38.1

