Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16591522A5B
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 05:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241797AbiEKDUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 23:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241641AbiEKDTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 23:19:46 -0400
Received: from smtpproxy21.qq.com (smtpbg701.qq.com [203.205.195.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BEC6D4E1
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:19:37 -0700 (PDT)
X-QQ-mid: bizesmtp75t1652239161tl51wnb9
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 11 May 2022 11:19:20 +0800 (CST)
X-QQ-SSF: 01400000000000F0O000B00A0000000
X-QQ-FEAT: CHH+BzdEyPg6hhEU0CmX42FD1Cy+c6ZdvX/uELiPtrCBhzerdCZ0ZLt0FI5ud
        yGgFV1xvZ9sD/W46++L6wPE7QLRiKPZAx1WdXLZ4hyaKTKbgEBSQ3VNm272FWjCC7qMGwMj
        b8IILidrcG3rqEMy7e6oBF8WnYXoA1hB07bHCroRFpA7H/M7QkCnbw/HNyhI9LF1IxGm+fy
        q1idXIaA4+mqTwExL68aerGrt5jx4J3V8DA/EdvHpwQ5N0QiRLCj970UTOMtItGCk3Ir9GZ
        HYf8FywKMfQ1mT7VM/gxowov/1FFSGXnlHyzhPpmgmWPIAj/GuxwhVqZkxSOgxF4seb7pEc
        1WSuNy7cjRI+XfY0amYa2qEefVZg10K50xvrZsp
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next 07/14] net: txgbe: Support flow control
Date:   Wed, 11 May 2022 11:26:52 +0800
Message-Id: <20220511032659.641834-8-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220511032659.641834-1-jiawenwu@trustnetic.com>
References: <20220511032659.641834-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybgforeign:qybgforeign8
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add flow control support.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |   2 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 366 ++++++++++++++++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   4 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  96 ++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  70 ++++
 5 files changed, 536 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 487e38007ccc..2fd11dfa43b4 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -40,6 +40,8 @@
 #define TXGBE_MAX_RXD                   8192
 #define TXGBE_MIN_RXD                   128
 
+#define TXGBE_DEFAULT_FCPAUSE   0xFFFF
+
 /* Supported Rx Buffer Sizes */
 #define TXGBE_RXBUFFER_256       256  /* Used for skb receive header */
 #define TXGBE_RXBUFFER_2K       2048
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index d3ea9cb82690..70db88dfb412 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -158,6 +158,87 @@ s32 txgbe_clear_hw_cntrs(struct txgbe_hw *hw)
 	return 0;
 }
 
+/**
+ *  txgbe_setup_fc - Set up flow control
+ *  @hw: pointer to hardware structure
+ *
+ *  Called at init time to set up flow control.
+ **/
+s32 txgbe_setup_fc(struct txgbe_hw *hw)
+{
+	s32 ret_val = 0;
+	u32 pcap = 0;
+	u32 value = 0;
+	u32 pcap_backplane = 0;
+
+	/* 10gig parts do not have a word in the EEPROM to determine the
+	 * default flow control setting, so we explicitly set it to full.
+	 */
+	if (hw->fc.requested_mode == txgbe_fc_default)
+		hw->fc.requested_mode = txgbe_fc_full;
+
+	/* The possible values of fc.requested_mode are:
+	 * 0: Flow control is completely disabled
+	 * 1: Rx flow control is enabled (we can receive pause frames,
+	 *    but not send pause frames).
+	 * 2: Tx flow control is enabled (we can send pause frames but
+	 *    we do not support receiving pause frames).
+	 * 3: Both Rx and Tx flow control (symmetric) are enabled.
+	 * other: Invalid.
+	 */
+	switch (hw->fc.requested_mode) {
+	case txgbe_fc_none:
+		/* Flow control completely disabled by software override. */
+		break;
+	case txgbe_fc_tx_pause:
+		/* Tx Flow control is enabled, and Rx Flow control is
+		 * disabled by software override.
+		 */
+		pcap |= TXGBE_SR_MII_MMD_AN_ADV_PAUSE_ASM;
+		pcap_backplane |= TXGBE_SR_AN_MMD_ADV_REG1_PAUSE_ASM;
+		break;
+	case txgbe_fc_rx_pause:
+		/* Rx Flow control is enabled and Tx Flow control is
+		 * disabled by software override. Since there really
+		 * isn't a way to advertise that we are capable of RX
+		 * Pause ONLY, we will advertise that we support both
+		 * symmetric and asymmetric Rx PAUSE, as such we fall
+		 * through to the fc_full statement.  Later, we will
+		 * disable the adapter's ability to send PAUSE frames.
+		 */
+	case txgbe_fc_full:
+		/* Flow control (both Rx and Tx) is enabled by SW override. */
+		pcap |= TXGBE_SR_MII_MMD_AN_ADV_PAUSE_SYM |
+			TXGBE_SR_MII_MMD_AN_ADV_PAUSE_ASM;
+		pcap_backplane |= TXGBE_SR_AN_MMD_ADV_REG1_PAUSE_SYM |
+				  TXGBE_SR_AN_MMD_ADV_REG1_PAUSE_ASM;
+		break;
+	default:
+		ERROR_REPORT1(TXGBE_ERROR_ARGUMENT,
+			      "Flow control param set incorrectly\n");
+		ret_val = TXGBE_ERR_CONFIG;
+		goto out;
+	}
+
+	/* Enable auto-negotiation between the MAC & PHY;
+	 * the MAC will advertise clause 37 flow control.
+	 */
+	value = txgbe_rd32_epcs(hw, TXGBE_SR_MII_MMD_AN_ADV);
+	value = (value & ~(TXGBE_SR_MII_MMD_AN_ADV_PAUSE_ASM |
+			   TXGBE_SR_MII_MMD_AN_ADV_PAUSE_SYM)) | pcap;
+	txgbe_wr32_epcs(hw, TXGBE_SR_MII_MMD_AN_ADV, value);
+
+	if (hw->phy.media_type == txgbe_media_type_backplane) {
+		value = txgbe_rd32_epcs(hw, TXGBE_SR_AN_MMD_ADV_REG1);
+		value = (value & ~(TXGBE_SR_AN_MMD_ADV_REG1_PAUSE_ASM |
+				   TXGBE_SR_AN_MMD_ADV_REG1_PAUSE_SYM)) |
+			pcap_backplane;
+		txgbe_wr32_epcs(hw, TXGBE_SR_AN_MMD_ADV_REG1, value);
+	}
+out:
+	return ret_val;
+}
+
 /**
  *  txgbe_read_pba_string - Reads part number string from EEPROM
  *  @hw: pointer to hardware structure
@@ -850,6 +931,285 @@ s32 txgbe_update_mc_addr_list(struct txgbe_hw *hw, u8 *mc_addr_list,
 	return 0;
 }
 
+/**
+ *  txgbe_fc_enable - Enable flow control
+ *  @hw: pointer to hardware structure
+ *
+ *  Enable flow control according to the current settings.
+ **/
+s32 txgbe_fc_enable(struct txgbe_hw *hw)
+{
+	s32 ret_val = 0;
+	u32 mflcn_reg, fccfg_reg;
+	u32 reg;
+	u32 fcrtl, fcrth;
+
+	/* Validate the water mark configuration */
+	if (!hw->fc.pause_time) {
+		ret_val = TXGBE_ERR_INVALID_LINK_SETTINGS;
+		goto out;
+	}
+
+	/* Low water mark of zero causes XOFF floods */
+	if ((hw->fc.current_mode & txgbe_fc_tx_pause) &&
+	    hw->fc.high_water) {
+		if (!hw->fc.low_water ||
+		    hw->fc.low_water >= hw->fc.high_water) {
+			DEBUGOUT("Invalid water mark configuration\n");
+			ret_val = TXGBE_ERR_INVALID_LINK_SETTINGS;
+			goto out;
+		}
+	}
+
+	/* Negotiate the fc mode to use */
+	txgbe_fc_autoneg(hw);
+
+	/* Disable any previous flow control settings */
+	mflcn_reg = rd32(hw, TXGBE_MAC_RX_FLOW_CTRL);
+	mflcn_reg &= ~(TXGBE_MAC_RX_FLOW_CTRL_PFCE |
+		       TXGBE_MAC_RX_FLOW_CTRL_RFE);
+
+	fccfg_reg = rd32(hw, TXGBE_RDB_RFCC);
+	fccfg_reg &= ~(TXGBE_RDB_RFCC_RFCE_802_3X |
+		       TXGBE_RDB_RFCC_RFCE_PRIORITY);
+
+	/* The possible values of fc.current_mode are:
+	 * 0: Flow control is completely disabled
+	 * 1: Rx flow control is enabled (we can receive pause frames,
+	 *    but not send pause frames).
+	 * 2: Tx flow control is enabled (we can send pause frames but
+	 *    we do not support receiving pause frames).
+	 * 3: Both Rx and Tx flow control (symmetric) are enabled.
+	 * other: Invalid.
+	 */
+	switch (hw->fc.current_mode) {
+	case txgbe_fc_none:
+		/* Flow control is disabled by software override or autoneg.
+		 * The code below will actually disable it in the HW.
+		 */
+		break;
+	case txgbe_fc_rx_pause:
+		/* Rx Flow control is enabled and Tx Flow control is
+		 * disabled by software override. Since there really
+		 * isn't a way to advertise that we are capable of RX
+		 * Pause ONLY, we will advertise that we support both
+		 * symmetric and asymmetric Rx PAUSE.  Later, we will
+		 * disable the adapter's ability to send PAUSE frames.
+		 */
+		mflcn_reg |= TXGBE_MAC_RX_FLOW_CTRL_RFE;
+		break;
+	case txgbe_fc_tx_pause:
+		/* Tx Flow control is enabled, and Rx Flow control is
+		 * disabled by software override.
+		 */
+		fccfg_reg |= TXGBE_RDB_RFCC_RFCE_802_3X;
+		break;
+	case txgbe_fc_full:
+		/* Flow control (both Rx and Tx) is enabled by SW override. */
+		mflcn_reg |= TXGBE_MAC_RX_FLOW_CTRL_RFE;
+		fccfg_reg |= TXGBE_RDB_RFCC_RFCE_802_3X;
+		break;
+	default:
+		ERROR_REPORT1(TXGBE_ERROR_ARGUMENT,
+			      "Flow control param set incorrectly\n");
+		ret_val = TXGBE_ERR_CONFIG;
+		goto out;
+	}
+
+	/* Set 802.3x based flow control settings. */
+	wr32(hw, TXGBE_MAC_RX_FLOW_CTRL, mflcn_reg);
+	wr32(hw, TXGBE_RDB_RFCC, fccfg_reg);
+
+	/* Set up and enable Rx high/low water mark thresholds, enable XON. */
+	if ((hw->fc.current_mode & txgbe_fc_tx_pause) &&
+	    hw->fc.high_water) {
+		fcrtl = (hw->fc.low_water << 10) |
+			TXGBE_RDB_RFCL_XONE;
+		wr32(hw, TXGBE_RDB_RFCL(0), fcrtl);
+		fcrth = (hw->fc.high_water << 10) |
+			TXGBE_RDB_RFCH_XOFFE;
+	} else {
+		wr32(hw, TXGBE_RDB_RFCL(0), 0);
+		/* In order to prevent Tx hangs when the internal Tx
+		 * switch is enabled we must set the high water mark
+		 * to the Rx packet buffer size - 24KB.  This allows
+		 * the Tx switch to function even under heavy Rx
+		 * workloads.
+		 */
+		fcrth = rd32(hw, TXGBE_RDB_PB_SZ(0)) - 24576;
+	}
+
+	wr32(hw, TXGBE_RDB_RFCH(0), fcrth);
+
+	/* Configure pause time */
+	reg = hw->fc.pause_time * 0x00010001;
+	wr32(hw, TXGBE_RDB_RFCV(0), reg);
+
+	/* Configure flow control refresh threshold value */
+	wr32(hw, TXGBE_RDB_RFCRT, hw->fc.pause_time / 2);
+
+out:
+	return ret_val;
+}
+
+/**
+ *  txgbe_negotiate_fc - Negotiate flow control
+ *  @hw: pointer to hardware structure
+ *  @adv_reg: flow control advertised settings
+ *  @lp_reg: link partner's flow control settings
+ *  @adv_sym: symmetric pause bit in advertisement
+ *  @adv_asm: asymmetric pause bit in advertisement
+ *  @lp_sym: symmetric pause bit in link partner advertisement
+ *  @lp_asm: asymmetric pause bit in link partner advertisement
+ *
+ *  Find the intersection between advertised settings and link partner's
+ *  advertised settings
+ **/
+static s32 txgbe_negotiate_fc(struct txgbe_hw *hw, u32 adv_reg, u32 lp_reg,
+			      u32 adv_sym, u32 adv_asm, u32 lp_sym, u32 lp_asm)
+{
+	if ((!(adv_reg)) ||  (!(lp_reg))) {
+		ERROR_REPORT3(TXGBE_ERROR_UNSUPPORTED,
+			      "Local or link partner's advertised flow control settings are NULL. Local: %x, link partner: %x\n",
+			      adv_reg, lp_reg);
+		return TXGBE_ERR_FC_NOT_NEGOTIATED;
+	}
+
+	if ((adv_reg & adv_sym) && (lp_reg & lp_sym)) {
+		/* Now we need to check if the user selected Rx ONLY
+		 * of pause frames.  In this case, we had to advertise
+		 * FULL flow control because we could not advertise RX
+		 * ONLY. Hence, we must now check to see if we need to
+		 * turn OFF the TRANSMISSION of PAUSE frames.
+		 */
+		if (hw->fc.requested_mode == txgbe_fc_full) {
+			hw->fc.current_mode = txgbe_fc_full;
+			DEBUGOUT("Flow Control = FULL.\n");
+		} else {
+			hw->fc.current_mode = txgbe_fc_rx_pause;
+			DEBUGOUT("Flow Control=RX PAUSE frames only\n");
+		}
+	} else if (!(adv_reg & adv_sym) && (adv_reg & adv_asm) &&
+		   (lp_reg & lp_sym) && (lp_reg & lp_asm)) {
+		hw->fc.current_mode = txgbe_fc_tx_pause;
+		DEBUGOUT("Flow Control = TX PAUSE frames only.\n");
+	} else if ((adv_reg & adv_sym) && (adv_reg & adv_asm) &&
+		   !(lp_reg & lp_sym) && (lp_reg & lp_asm)) {
+		hw->fc.current_mode = txgbe_fc_rx_pause;
+		DEBUGOUT("Flow Control = RX PAUSE frames only.\n");
+	} else {
+		hw->fc.current_mode = txgbe_fc_none;
+		DEBUGOUT("Flow Control = NONE.\n");
+	}
+	return 0;
+}
+
+/**
+ *  txgbe_fc_autoneg_fiber - Enable flow control on 1 gig fiber
+ *  @hw: pointer to hardware structure
+ *
+ *  Enable flow control according on 1 gig fiber.
+ **/
+static s32 txgbe_fc_autoneg_fiber(struct txgbe_hw *hw)
+{
+	u32 pcs_anadv_reg, pcs_lpab_reg;
+	s32 ret_val = TXGBE_ERR_FC_NOT_NEGOTIATED;
+
+	pcs_anadv_reg = txgbe_rd32_epcs(hw, TXGBE_SR_MII_MMD_AN_ADV);
+	pcs_lpab_reg = txgbe_rd32_epcs(hw, TXGBE_SR_MII_MMD_LP_BABL);
+
+	ret_val =  txgbe_negotiate_fc(hw, pcs_anadv_reg,
+				      pcs_lpab_reg,
+				      TXGBE_SR_MII_MMD_AN_ADV_PAUSE_SYM,
+				      TXGBE_SR_MII_MMD_AN_ADV_PAUSE_ASM,
+				      TXGBE_SR_MII_MMD_AN_ADV_PAUSE_SYM,
+				      TXGBE_SR_MII_MMD_AN_ADV_PAUSE_ASM);
+
+	return ret_val;
+}
+
+/**
+ *  txgbe_fc_autoneg_backplane - Enable flow control IEEE clause 37
+ *  @hw: pointer to hardware structure
+ *
+ *  Enable flow control according to IEEE clause 37.
+ **/
+static s32 txgbe_fc_autoneg_backplane(struct txgbe_hw *hw)
+{
+	u32 anlp1_reg, autoc_reg;
+	s32 ret_val = TXGBE_ERR_FC_NOT_NEGOTIATED;
+
+	/* Read the 10g AN autoc and LP ability registers and resolve
+	 * local flow control settings accordingly
+	 */
+	autoc_reg = txgbe_rd32_epcs(hw, TXGBE_SR_AN_MMD_ADV_REG1);
+	anlp1_reg = txgbe_rd32_epcs(hw, TXGBE_SR_AN_MMD_LP_ABL1);
+
+	ret_val = txgbe_negotiate_fc(hw, autoc_reg,
+				     anlp1_reg,
+				     TXGBE_SR_AN_MMD_ADV_REG1_PAUSE_SYM,
+				     TXGBE_SR_AN_MMD_ADV_REG1_PAUSE_ASM,
+				     TXGBE_SR_AN_MMD_ADV_REG1_PAUSE_SYM,
+				     TXGBE_SR_AN_MMD_ADV_REG1_PAUSE_ASM);
+
+	return ret_val;
+}
+
+/**
+ *  txgbe_fc_autoneg - Configure flow control
+ *  @hw: pointer to hardware structure
+ *
+ *  Compares our advertised flow control capabilities to those advertised by
+ *  our link partner, and determines the proper flow control mode to use.
+ **/
+void txgbe_fc_autoneg(struct txgbe_hw *hw)
+{
+	s32 ret_val = TXGBE_ERR_FC_NOT_NEGOTIATED;
+	u32 speed;
+	bool link_up;
+
+	/* AN should have completed when the cable was plugged in.
+	 * Look for reasons to bail out.  Bail out if:
+	 * - FC autoneg is disabled, or if
+	 * - link is not up.
+	 */
+	if (hw->fc.disable_fc_autoneg) {
+		ERROR_REPORT1(TXGBE_ERROR_UNSUPPORTED,
+			      "Flow control autoneg is disabled");
+		goto out;
+	}
+
+	TCALL(hw, mac.ops.check_link, &speed, &link_up, false);
+	if (!link_up) {
+		ERROR_REPORT1(TXGBE_ERROR_SOFTWARE, "The link is down");
+		goto out;
+	}
+
+	switch (hw->phy.media_type) {
+	/* Autoneg flow control on fiber adapters */
+	case txgbe_media_type_fiber:
+		if (speed == TXGBE_LINK_SPEED_1GB_FULL)
+			ret_val = txgbe_fc_autoneg_fiber(hw);
+		break;
+
+	/* Autoneg flow control on backplane adapters */
+	case txgbe_media_type_backplane:
+		ret_val = txgbe_fc_autoneg_backplane(hw);
+		break;
+
+	default:
+		break;
+	}
+
+out:
+	if (ret_val == 0) {
+		hw->fc.fc_was_autonegged = true;
+	} else {
+		hw->fc.fc_was_autonegged = false;
+		hw->fc.current_mode = hw->fc.requested_mode;
+	}
+}
+
 /**
  *  txgbe_disable_pcie_master - Disable PCI-express master access
  *  @hw: pointer to hardware structure
@@ -2313,6 +2673,9 @@ s32 txgbe_init_ops(struct txgbe_hw *hw)
 	mac->ops.clear_vfta = txgbe_clear_vfta;
 	mac->ops.init_uta_tables = txgbe_init_uta_tables;
 
+	/* Flow Control */
+	mac->ops.fc_enable = txgbe_fc_enable;
+	mac->ops.setup_fc = txgbe_setup_fc;
 
 	/* Link */
 	mac->ops.get_link_capabilities = txgbe_get_link_capabilities;
@@ -3726,6 +4089,9 @@ s32 txgbe_start_hw(struct txgbe_hw *hw)
 
 	TXGBE_WRITE_FLUSH(hw);
 
+	/* Setup flow control */
+	ret_val = TCALL(hw, mac.ops.setup_fc);
+
 	/* Clear the rate limiters */
 	for (i = 0; i < hw->mac.max_tx_queues; i++) {
 		wr32(hw, TXGBE_TDM_RP_IDX, i);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index e400b0333cc4..1b11735cc278 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -90,6 +90,10 @@ s32 txgbe_update_mc_addr_list(struct txgbe_hw *hw, u8 *mc_addr_list,
 s32 txgbe_disable_sec_rx_path(struct txgbe_hw *hw);
 s32 txgbe_enable_sec_rx_path(struct txgbe_hw *hw);
 
+s32 txgbe_fc_enable(struct txgbe_hw *hw);
+void txgbe_fc_autoneg(struct txgbe_hw *hw);
+s32 txgbe_setup_fc(struct txgbe_hw *hw);
+
 s32 txgbe_acquire_swfw_sync(struct txgbe_hw *hw, u32 mask);
 void txgbe_release_swfw_sync(struct txgbe_hw *hw, u32 mask);
 s32 txgbe_disable_pcie_master(struct txgbe_hw *hw);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 550af406de8d..6f1836a61711 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -1948,12 +1948,13 @@ void txgbe_set_rx_drop_en(struct txgbe_adapter *adapter)
 	int i;
 
 	/* We should set the drop enable bit if:
-	 *  Number of Rx queues > 1
+	 *  Number of Rx queues > 1 and flow control is disabled
 	 *
 	 *  This allows us to avoid head of line blocking for security
 	 *  and performance reasons.
 	 */
-	if (adapter->num_rx_queues > 1) {
+	if ((adapter->num_rx_queues > 1 &&
+	     !(adapter->hw.fc.current_mode & txgbe_fc_tx_pause))) {
 		for (i = 0; i < adapter->num_rx_queues; i++)
 			txgbe_enable_rx_drop(adapter, adapter->rx_ring[i]);
 	} else {
@@ -2767,11 +2768,94 @@ void txgbe_clear_vxlan_port(struct txgbe_adapter *adapter)
 				    NETIF_F_GSO_UDP_TUNNEL | \
 				    NETIF_F_GSO_UDP_TUNNEL_CSUM)
 
+/* Additional bittime to account for TXGBE framing */
+#define TXGBE_ETH_FRAMING 20
+
+/**
+ * txgbe_hpbthresh - calculate high water mark for flow control
+ *
+ * @adapter: board private structure to calculate for
+ * @pb - packet buffer to calculate
+ **/
+static int txgbe_hpbthresh(struct txgbe_adapter *adapter, int pb)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	struct net_device *dev = adapter->netdev;
+	int link, tc, kb, marker;
+	u32 dv_id, rx_pba;
+
+	/* Calculate max LAN frame size */
+	link = dev->mtu + ETH_HLEN + ETH_FCS_LEN + TXGBE_ETH_FRAMING;
+	tc = link;
+
+	/* Calculate delay value for device */
+	dv_id = TXGBE_DV(link, tc);
+
+	/* Delay value is calculated in bit times convert to KB */
+	kb = TXGBE_BT2KB(dv_id);
+	rx_pba = rd32(hw, TXGBE_RDB_PB_SZ(pb)) >> TXGBE_RDB_PB_SZ_SHIFT;
+
+	marker = rx_pba - kb;
+
+	/* It is possible that the packet buffer is not large enough
+	 * to provide required headroom. In this case throw an error
+	 * to user and a do the best we can.
+	 */
+	if (marker < 0) {
+		txgbe_warn(drv,
+			   "Packet Buffer(%i) can not provide enough headroom to support flow control. Decrease MTU or number of traffic classes\n",
+			   pb);
+		marker = tc + 1;
+	}
+
+	return marker;
+}
+
+/**
+ * txgbe_lpbthresh - calculate low water mark for flow control
+ *
+ * @adapter: board private structure to calculate for
+ * @pb - packet buffer to calculate
+ **/
+static int txgbe_lpbthresh(struct txgbe_adapter *adapter, int __maybe_unused pb)
+{
+	struct net_device *dev = adapter->netdev;
+	int tc;
+	u32 dv_id;
+
+	/* Calculate max LAN frame size */
+	tc = dev->mtu + ETH_HLEN + ETH_FCS_LEN;
+
+	/* Calculate delay value for device */
+	dv_id = TXGBE_LOW_DV(tc);
+
+	/* Delay value is calculated in bit times convert to KB */
+	return TXGBE_BT2KB(dv_id);
+}
+
+/**
+ * txgbe_pbthresh_setup - calculate and setup high low water marks
+ **/
+static void txgbe_pbthresh_setup(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+
+	hw->fc.high_water = txgbe_hpbthresh(adapter, 0);
+	hw->fc.low_water = txgbe_lpbthresh(adapter, 0);
+
+	/* Low water marks must not be larger than high water marks */
+	if (hw->fc.low_water > hw->fc.high_water)
+		hw->fc.low_water = 0;
+
+	hw->fc.high_water = 0;
+}
+
 static void txgbe_configure_pb(struct txgbe_adapter *adapter)
 {
 	struct txgbe_hw *hw = &adapter->hw;
 
 	TCALL(hw, mac.ops.setup_rxpba, 0, 0, PBA_STRATEGY_EQUAL);
+	txgbe_pbthresh_setup(adapter);
 }
 
 void txgbe_configure_isb(struct txgbe_adapter *adapter)
@@ -3295,6 +3379,13 @@ static int txgbe_sw_init(struct txgbe_adapter *adapter)
 
 	adapter->max_q_vectors = TXGBE_MAX_MSIX_Q_VECTORS_SAPPHIRE;
 
+	/* default flow control settings */
+	hw->fc.requested_mode = txgbe_fc_full;
+	hw->fc.current_mode = txgbe_fc_full;
+
+	hw->fc.pause_time = TXGBE_DEFAULT_FCPAUSE;
+	hw->fc.disable_fc_autoneg = false;
+
 	/* set default ring sizes */
 	adapter->tx_ring_count = TXGBE_DEFAULT_TXD;
 	adapter->rx_ring_count = TXGBE_DEFAULT_RXD;
@@ -4004,6 +4095,7 @@ static void txgbe_watchdog_update_link(struct txgbe_adapter *adapter)
 	adapter->link_speed = link_speed;
 
 	if (link_up) {
+		TCALL(hw, mac.ops.fc_enable);
 		txgbe_set_rx_drop_en(adapter);
 
 		if (link_speed & TXGBE_LINK_SPEED_10GB_FULL) {
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index c673c5d86b1a..af9339777ea5 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -2085,6 +2085,51 @@ typedef u32 txgbe_physical_layer;
 #define TXGBE_PHYSICAL_LAYER_10GBASE_XAUI       0x1000
 #define TXGBE_PHYSICAL_LAYER_SFP_ACTIVE_DA      0x2000
 #define TXGBE_PHYSICAL_LAYER_1000BASE_SX        0x4000
+/* Flow Control Data Sheet defined values
+ * Calculation and defines taken from 802.1bb Annex O
+ */
+
+/* BitTimes (BT) conversion */
+#define TXGBE_BT2KB(BT)         (((BT) + (8 * 1024 - 1)) / (8 * 1024))
+#define TXGBE_B2BT(BT)          ((BT) * 8)
+
+/* Calculate Delay to respond to PFC */
+#define TXGBE_PFC_D     672
+
+/* Calculate Cable Delay */
+#define TXGBE_CABLE_DC  5556
+
+/* Calculate Interface Delay */
+#define TXGBE_PHY_D     12800
+#define TXGBE_MAC_D     4096
+#define TXGBE_XAUI_D    (2 * 1024)
+
+#define TXGBE_ID        (TXGBE_MAC_D + TXGBE_XAUI_D + TXGBE_PHY_D)
+
+/* Calculate Delay incurred from higher layer */
+#define TXGBE_HD        6144
+
+/* Calculate PCI Bus delay for low thresholds */
+#define TXGBE_PCI_DELAY 10000
+
+/* Calculate delay value in bit times */
+#define TXGBE_DV(_max_frame_link, _max_frame_tc) \
+			((36 * \
+			  (TXGBE_B2BT(_max_frame_link) + \
+			   TXGBE_PFC_D + \
+			   (2 * TXGBE_CABLE_DC) + \
+			   (2 * TXGBE_ID) + \
+			   TXGBE_HD) / 25 + 1) + \
+			 2 * TXGBE_B2BT(_max_frame_tc))
+
+/* Calculate low threshold delay values */
+#define TXGBE_LOW_DV_SP(_max_frame_tc) \
+			(2 * TXGBE_B2BT(_max_frame_tc) + \
+			(36 * TXGBE_PCI_DELAY / 25) + 1)
+
+#define TXGBE_LOW_DV(_max_frame_tc) \
+			(2 * TXGBE_LOW_DV_SP(_max_frame_tc))
+
 
 enum txgbe_eeprom_type {
 	txgbe_eeprom_uninitialized = 0,
@@ -2154,6 +2199,15 @@ enum txgbe_media_type {
 	txgbe_media_type_virtual
 };
 
+/* Flow Control Settings */
+enum txgbe_fc_mode {
+	txgbe_fc_none = 0,
+	txgbe_fc_rx_pause,
+	txgbe_fc_tx_pause,
+	txgbe_fc_full,
+	txgbe_fc_default
+};
+
 /* PCI bus types */
 enum txgbe_bus_type {
 	txgbe_bus_type_unknown = 0,
@@ -2208,6 +2262,17 @@ struct txgbe_bus_info {
 	u16 lan_id;
 };
 
+/* Flow control parameters */
+struct txgbe_fc_info {
+	u32 high_water; /* Flow Ctrl High-water */
+	u32 low_water; /* Flow Ctrl Low-water */
+	u16 pause_time; /* Flow Control Pause timer */
+	bool disable_fc_autoneg; /* Do not autonegotiate FC */
+	bool fc_was_autonegged; /* Is current_mode the result of autonegging? */
+	enum txgbe_fc_mode current_mode; /* FC mode in effect */
+	enum txgbe_fc_mode requested_mode; /* FC mode requested by caller */
+};
+
 /* Statistics counters collected by the MAC */
 struct txgbe_hw_stats {
 	u64 crcerrs;
@@ -2349,6 +2414,10 @@ struct txgbe_mac_operations {
 	s32 (*set_vfta)(struct txgbe_hw *hw, u32 vlan, u32 vind, bool vlan_on);
 	s32 (*init_uta_tables)(struct txgbe_hw *hw);
 
+	/* Flow Control */
+	s32 (*fc_enable)(struct txgbe_hw *hw);
+	s32 (*setup_fc)(struct txgbe_hw *hw);
+
 	/* Manageability interface */
 	s32 (*set_fw_drv_ver)(struct txgbe_hw *hw, u8 maj, u8 min,
 			      u8 build, u8 ver);
@@ -2437,6 +2506,7 @@ struct txgbe_hw {
 	void *back;
 	struct txgbe_mac_info mac;
 	struct txgbe_addr_filter_info addr_ctrl;
+	struct txgbe_fc_info fc;
 	struct txgbe_phy_info phy;
 	struct txgbe_eeprom_info eeprom;
 	struct txgbe_bus_info bus;
-- 
2.27.0



