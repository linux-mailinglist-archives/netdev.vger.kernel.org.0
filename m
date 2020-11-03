Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857F52A5004
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729620AbgKCTWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:22:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:58404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729475AbgKCTWj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 14:22:39 -0500
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08FA9216C4;
        Tue,  3 Nov 2020 19:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604431357;
        bh=g6LOpE3schQKD04w3iMDGYjxBuBYn0n+PYTdrEvjQ98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V7YAUSXSsbSHVIDCiLg+Bz+msgpQF0RH/J7ikj5tiC/s+jN224Z6XffvYsobsdWPr
         VSMfMGsh6GAZetx1zrvXKZ5bvA7WECRHsRpd0koJhpkB1SnFi758zJvM0t+/baySQS
         YIm+kCtKLjR6NZyleytuUOROItzRUDofniTrgOrE=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 5/5] r8152: use *_modify helpers instead of read/write combos
Date:   Tue,  3 Nov 2020 20:22:26 +0100
Message-Id: <20201103192226.2455-6-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103192226.2455-1-kabel@kernel.org>
References: <20201103192226.2455-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add *_modify helpers to clear and set bits. Use these helpers such as
  x_modify(addr, clr, set);
instead of:
  reg = x_read(addr);
  reg &= ~clr;
  reg |= set;
  x_write(addr, reg);

This seems to be the way other parts of Linux are taking.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/usb/r8152.c | 841 +++++++++++-----------------------------
 1 file changed, 233 insertions(+), 608 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 1a427061da8e..e8785e9a6407 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1314,6 +1314,14 @@ static inline void _p ## _ocp_write_ ## _n(struct r8152 *tp, u16 index,	\
 					   _t data)			\
 {									\
 	ocp_write_ ## _n(tp, _mcutype, index, data);			\
+}									\
+static inline void _p ## _ocp_modify_ ## _n(struct r8152 *tp,		\
+					    u16 index, _t clr, _t set)	\
+{									\
+	_t val;								\
+	val = _p ## _ocp_read_ ## _n(tp, index);			\
+	val = (val & ~clr) | set;					\
+	_p ## _ocp_write_ ## _n(tp, index, val);			\
 }
 
 DEFINE_FUNCS_FOR_MCU_TYPE(pla, MCU_TYPE_PLA, u8, byte)
@@ -1352,6 +1360,11 @@ static void ocp_reg_write(struct r8152 *tp, u16 addr, u16 data)
 	pla_ocp_write_word(tp, ocp_index, data);
 }
 
+static void ocp_reg_modify(struct r8152 *tp, u16 addr, u16 clr, u16 set)
+{
+	ocp_reg_write(tp, addr, (ocp_reg_read(tp, addr) & ~clr) | set);
+}
+
 static inline void r8152_mdio_write(struct r8152 *tp, u32 reg_addr, u32 value)
 {
 	ocp_reg_write(tp, OCP_BASE_MII + reg_addr * 2, value);
@@ -1362,6 +1375,16 @@ static inline int r8152_mdio_read(struct r8152 *tp, u32 reg_addr)
 	return ocp_reg_read(tp, OCP_BASE_MII + reg_addr * 2);
 }
 
+static void r8152_mdio_modify(struct r8152 *tp, u32 reg_addr, u16 clr, u16 set)
+{
+	u16 val, nval;
+
+	val = r8152_mdio_read(tp, reg_addr);
+	nval = (val & ~clr) | set;
+	if (val != nval)
+		r8152_mdio_write(tp, reg_addr, nval);
+}
+
 static void sram_write(struct r8152 *tp, u16 addr, u16 data)
 {
 	ocp_reg_write(tp, OCP_SRAM_ADDR, addr);
@@ -1374,6 +1397,11 @@ static u16 sram_read(struct r8152 *tp, u16 addr)
 	return ocp_reg_read(tp, OCP_SRAM_DATA);
 }
 
+static void sram_modify(struct r8152 *tp, u16 addr, u16 clr, u16 set)
+{
+	sram_write(tp, addr, (sram_read(tp, addr) & ~clr) | set);
+}
+
 static int read_mii_word(struct net_device *netdev, int phy_id, int reg)
 {
 	struct r8152 *tp = netdev_priv(netdev);
@@ -2552,9 +2580,7 @@ static void _rtl8152_set_rx_mode(struct net_device *netdev)
 	u32 ocp_data;
 
 	netif_stop_queue(netdev);
-	ocp_data = pla_ocp_read_dword(tp, PLA_RCR);
-	ocp_data &= ~RCR_ACPT_ALL;
-	ocp_data |= RCR_AB | RCR_APM;
+	ocp_data = RCR_AB | RCR_APM;
 
 	if (netdev->flags & IFF_PROMISC) {
 		/* Unconditionally log net taps. */
@@ -2585,7 +2611,7 @@ static void _rtl8152_set_rx_mode(struct net_device *netdev)
 	tmp[1] = __cpu_to_le32(swab32(mc_filter[0]));
 
 	pla_ocp_write(tp, PLA_MAR, BYTE_EN_DWORD, sizeof(tmp), tmp);
-	pla_ocp_write_dword(tp, PLA_RCR, ocp_data);
+	pla_ocp_modify_dword(tp, PLA_RCR, RCR_ACPT_ALL, ocp_data);
 	netif_wake_queue(netdev);
 }
 
@@ -2631,13 +2657,8 @@ static netdev_tx_t rtl8152_start_xmit(struct sk_buff *skb,
 
 static void r8152b_reset_packet_filter(struct r8152 *tp)
 {
-	u32	ocp_data;
-
-	ocp_data = pla_ocp_read_word(tp, PLA_FMC);
-	ocp_data &= ~FMC_FCR_MCU_EN;
-	pla_ocp_write_word(tp, PLA_FMC, ocp_data);
-	ocp_data |= FMC_FCR_MCU_EN;
-	pla_ocp_write_word(tp, PLA_FMC, ocp_data);
+	pla_ocp_modify_word(tp, PLA_FMC, FMC_FCR_MCU_EN, 0);
+	pla_ocp_modify_word(tp, PLA_FMC, 0, FMC_FCR_MCU_EN);
 }
 
 static void rtl8152_nic_reset(struct r8152 *tp)
@@ -2668,31 +2689,17 @@ static inline u8 rtl8152_get_speed(struct r8152 *tp)
 
 static void rtl_set_eee_plus(struct r8152 *tp)
 {
-	u32 ocp_data;
 	u8 speed;
 
 	speed = rtl8152_get_speed(tp);
-	if (speed & _10bps) {
-		ocp_data = pla_ocp_read_word(tp, PLA_EEEP_CR);
-		ocp_data |= EEEP_CR_EEEP_TX;
-		pla_ocp_write_word(tp, PLA_EEEP_CR, ocp_data);
-	} else {
-		ocp_data = pla_ocp_read_word(tp, PLA_EEEP_CR);
-		ocp_data &= ~EEEP_CR_EEEP_TX;
-		pla_ocp_write_word(tp, PLA_EEEP_CR, ocp_data);
-	}
+	pla_ocp_modify_word(tp, PLA_EEEP_CR, EEEP_CR_EEEP_TX,
+			    (speed & _10bps) ? EEEP_CR_EEEP_TX : 0);
 }
 
 static void rxdy_gated_en(struct r8152 *tp, bool enable)
 {
-	u32 ocp_data;
-
-	ocp_data = pla_ocp_read_word(tp, PLA_MISC_1);
-	if (enable)
-		ocp_data |= RXDY_GATED_EN;
-	else
-		ocp_data &= ~RXDY_GATED_EN;
-	pla_ocp_write_word(tp, PLA_MISC_1, ocp_data);
+	pla_ocp_modify_word(tp, PLA_MISC_1, RXDY_GATED_EN,
+			    enable ? RXDY_GATED_EN : 0);
 }
 
 static int rtl_start_rx(struct r8152 *tp)
@@ -2785,13 +2792,9 @@ static inline void r8153b_rx_agg_chg_indicate(struct r8152 *tp)
 
 static int rtl_enable(struct r8152 *tp)
 {
-	u32 ocp_data;
-
 	r8152b_reset_packet_filter(tp);
 
-	ocp_data = pla_ocp_read_byte(tp, PLA_CR);
-	ocp_data |= CR_RE | CR_TE;
-	pla_ocp_write_byte(tp, PLA_CR, ocp_data);
+	pla_ocp_modify_byte(tp, PLA_CR, 0, CR_RE | CR_TE);
 
 	switch (tp->version) {
 	case RTL_VER_08:
@@ -2876,14 +2879,9 @@ static int rtl8153_enable(struct r8152 *tp)
 	r8153_set_rx_early_size(tp);
 
 	if (tp->version == RTL_VER_09) {
-		u32 ocp_data;
-
-		ocp_data = usb_ocp_read_word(tp, USB_FW_TASK);
-		ocp_data &= ~FC_PATCH_TASK;
-		usb_ocp_write_word(tp, USB_FW_TASK, ocp_data);
+		usb_ocp_modify_word(tp, USB_FW_TASK, FC_PATCH_TASK, 0);
 		usleep_range(1000, 2000);
-		ocp_data |= FC_PATCH_TASK;
-		usb_ocp_write_word(tp, USB_FW_TASK, ocp_data);
+		usb_ocp_modify_word(tp, USB_FW_TASK, 0, FC_PATCH_TASK);
 	}
 
 	return rtl_enable(tp);
@@ -2899,9 +2897,7 @@ static void rtl_disable(struct r8152 *tp)
 		return;
 	}
 
-	ocp_data = pla_ocp_read_dword(tp, PLA_RCR);
-	ocp_data &= ~RCR_ACPT_ALL;
-	pla_ocp_write_dword(tp, PLA_RCR, ocp_data);
+	pla_ocp_modify_dword(tp, PLA_RCR, RCR_ACPT_ALL, 0);
 
 	rtl_drop_queued_tx(tp);
 
@@ -2930,30 +2926,15 @@ static void rtl_disable(struct r8152 *tp)
 
 static void r8152_power_cut_en(struct r8152 *tp, bool enable)
 {
-	u32 ocp_data;
-
-	ocp_data = usb_ocp_read_word(tp, USB_UPS_CTRL);
-	if (enable)
-		ocp_data |= POWER_CUT;
-	else
-		ocp_data &= ~POWER_CUT;
-	usb_ocp_write_word(tp, USB_UPS_CTRL, ocp_data);
-
-	ocp_data = usb_ocp_read_word(tp, USB_PM_CTRL_STATUS);
-	ocp_data &= ~RESUME_INDICATE;
-	usb_ocp_write_word(tp, USB_PM_CTRL_STATUS, ocp_data);
+	usb_ocp_modify_word(tp, USB_UPS_CTRL, POWER_CUT,
+			    enable ? POWER_CUT : 0);
+	usb_ocp_modify_word(tp, USB_PM_CTRL_STATUS, RESUME_INDICATE, 0);
 }
 
 static void rtl_rx_vlan_en(struct r8152 *tp, bool enable)
 {
-	u32 ocp_data;
-
-	ocp_data = pla_ocp_read_word(tp, PLA_CPCR);
-	if (enable)
-		ocp_data |= CPCR_RX_VLAN;
-	else
-		ocp_data &= ~CPCR_RX_VLAN;
-	pla_ocp_write_word(tp, PLA_CPCR, ocp_data);
+	pla_ocp_modify_word(tp, PLA_CPCR, CPCR_RX_VLAN,
+			    enable ? CPCR_RX_VLAN : 0);
 }
 
 static int rtl8152_set_features(struct net_device *dev,
@@ -3012,33 +2993,20 @@ static u32 __rtl_get_wol(struct r8152 *tp)
 
 static void __rtl_set_wol(struct r8152 *tp, u32 wolopts)
 {
-	u32 ocp_data;
-
 	pla_ocp_write_byte(tp, PLA_CRWECR, CRWECR_CONFIG);
 
-	ocp_data = pla_ocp_read_word(tp, PLA_CONFIG34);
-	ocp_data &= ~LINK_ON_WAKE_EN;
-	if (wolopts & WAKE_PHY)
-		ocp_data |= LINK_ON_WAKE_EN;
-	pla_ocp_write_word(tp, PLA_CONFIG34, ocp_data);
+	pla_ocp_modify_word(tp, PLA_CONFIG34, LINK_ON_WAKE_EN,
+			    wolopts & WAKE_PHY ? LINK_ON_WAKE_EN : 0);
 
-	ocp_data = pla_ocp_read_word(tp, PLA_CONFIG5);
-	ocp_data &= ~(UWF_EN | BWF_EN | MWF_EN);
-	if (wolopts & WAKE_UCAST)
-		ocp_data |= UWF_EN;
-	if (wolopts & WAKE_BCAST)
-		ocp_data |= BWF_EN;
-	if (wolopts & WAKE_MCAST)
-		ocp_data |= MWF_EN;
-	pla_ocp_write_word(tp, PLA_CONFIG5, ocp_data);
+	pla_ocp_modify_word(tp, PLA_CONFIG5, UWF_EN | BWF_EN | MWF_EN,
+			    (wolopts & WAKE_UCAST ? UWF_EN : 0) |
+			    (wolopts & WAKE_BCAST ? BWF_EN : 0) |
+			    (wolopts & WAKE_MCAST ? MWF_EN : 0));
 
 	pla_ocp_write_byte(tp, PLA_CRWECR, CRWECR_NORAML);
 
-	ocp_data = pla_ocp_read_word(tp, PLA_CFG_WOL);
-	ocp_data &= ~MAGIC_EN;
-	if (wolopts & WAKE_MAGIC)
-		ocp_data |= MAGIC_EN;
-	pla_ocp_write_word(tp, PLA_CFG_WOL, ocp_data);
+	pla_ocp_modify_word(tp, PLA_CFG_WOL, MAGIC_EN,
+			    wolopts & WAKE_MAGIC ? MAGIC_EN : 0);
 
 	if (wolopts & WAKE_ANY)
 		device_set_wakeup_enable(&tp->udev->dev, true);
@@ -3082,27 +3050,14 @@ static void r8153_u1u2en(struct r8152 *tp, bool enable)
 
 static void r8153b_u1u2en(struct r8152 *tp, bool enable)
 {
-	u32 ocp_data;
-
-	ocp_data = usb_ocp_read_word(tp, USB_LPM_CONFIG);
-	if (enable)
-		ocp_data |= LPM_U1U2_EN;
-	else
-		ocp_data &= ~LPM_U1U2_EN;
-
-	usb_ocp_write_word(tp, USB_LPM_CONFIG, ocp_data);
+	usb_ocp_modify_word(tp, USB_LPM_CONFIG, LPM_U1U2_EN,
+			    enable ? LPM_U1U2_EN : 0);
 }
 
 static void r8153_u2p3en(struct r8152 *tp, bool enable)
 {
-	u32 ocp_data;
-
-	ocp_data = usb_ocp_read_word(tp, USB_U2P3_CTRL);
-	if (enable)
-		ocp_data |= U2P3_ENABLE;
-	else
-		ocp_data &= ~U2P3_ENABLE;
-	usb_ocp_write_word(tp, USB_U2P3_CTRL, ocp_data);
+	usb_ocp_modify_word(tp, USB_U2P3_CTRL, U2P3_ENABLE,
+			    enable ? U2P3_ENABLE : 0);
 }
 
 static void r8153b_ups_flags(struct r8152 *tp)
@@ -3179,8 +3134,6 @@ static void r8153b_ups_flags(struct r8152 *tp)
 
 static void r8153b_green_en(struct r8152 *tp, bool enable)
 {
-	u16 data;
-
 	if (enable) {
 		sram_write(tp, 0x8045, 0);	/* 10M abiq&ldvbias */
 		sram_write(tp, 0x804d, 0x1222);	/* 100M short abiq&ldvbias */
@@ -3191,9 +3144,7 @@ static void r8153b_green_en(struct r8152 *tp, bool enable)
 		sram_write(tp, 0x805d, 0x2444);	/* 1000M short abiq&ldvbias */
 	}
 
-	data = sram_read(tp, SRAM_GREEN_CFG);
-	data |= GREEN_ETH_EN;
-	sram_write(tp, SRAM_GREEN_CFG, data);
+	sram_modify(tp, SRAM_GREEN_CFG, 0, GREEN_ETH_EN);
 
 	tp->ups_info.green = enable;
 }
@@ -3224,43 +3175,27 @@ static u16 r8153_phy_status_wait(struct r8152 *tp, u16 desired)
 
 static void r8153b_ups_en(struct r8152 *tp, bool enable)
 {
-	u32 ocp_data = usb_ocp_read_byte(tp, USB_POWER_CUT);
-
-	if (enable) {
+	if (enable)
 		r8153b_ups_flags(tp);
 
-		ocp_data |= UPS_EN | USP_PREWAKE | PHASE2_EN;
-		usb_ocp_write_byte(tp, USB_POWER_CUT, ocp_data);
+	usb_ocp_modify_byte(tp, USB_POWER_CUT, UPS_EN | USP_PREWAKE,
+			    enable ? UPS_EN | USP_PREWAKE | PHASE2_EN : 0);
+	usb_ocp_modify_byte(tp, 0xcfff, BIT(0), enable ? BIT(0) : 0);
 
-		ocp_data = usb_ocp_read_byte(tp, 0xcfff);
-		ocp_data |= BIT(0);
-		usb_ocp_write_byte(tp, 0xcfff, ocp_data);
-	} else {
+	if (!enable) {
 		u16 data;
 
-		ocp_data &= ~(UPS_EN | USP_PREWAKE);
-		usb_ocp_write_byte(tp, USB_POWER_CUT, ocp_data);
-
-		ocp_data = usb_ocp_read_byte(tp, 0xcfff);
-		ocp_data &= ~BIT(0);
-		usb_ocp_write_byte(tp, 0xcfff, ocp_data);
-
-		ocp_data = usb_ocp_read_word(tp, USB_MISC_0);
-		ocp_data &= ~PCUT_STATUS;
-		usb_ocp_write_word(tp, USB_MISC_0, ocp_data);
+		usb_ocp_modify_word(tp, USB_MISC_0, PCUT_STATUS, 0);
 
 		data = r8153_phy_status_wait(tp, 0);
 
 		switch (data) {
 		case PHY_STAT_PWRDN:
 		case PHY_STAT_EXT_INIT:
-			r8153b_green_en(tp,
-					test_bit(GREEN_ETHERNET, &tp->flags));
+			r8153b_green_en(tp, test_bit(GREEN_ETHERNET,
+						     &tp->flags));
 
-			data = r8152_mdio_read(tp, MII_BMCR);
-			data &= ~BMCR_PDOWN;
-			data |= BMCR_RESET;
-			r8152_mdio_write(tp, MII_BMCR, data);
+			r8152_mdio_modify(tp, MII_BMCR, BMCR_PDOWN, BMCR_RESET);
 
 			data = r8153_phy_status_wait(tp, PHY_STAT_LAN_ON);
 			fallthrough;
@@ -3276,54 +3211,24 @@ static void r8153b_ups_en(struct r8152 *tp, bool enable)
 
 static void r8153_power_cut_en(struct r8152 *tp, bool enable)
 {
-	u32 ocp_data;
-
-	ocp_data = usb_ocp_read_word(tp, USB_POWER_CUT);
-	if (enable)
-		ocp_data |= PWR_EN | PHASE2_EN;
-	else
-		ocp_data &= ~(PWR_EN | PHASE2_EN);
-	usb_ocp_write_word(tp, USB_POWER_CUT, ocp_data);
-
-	ocp_data = usb_ocp_read_word(tp, USB_MISC_0);
-	ocp_data &= ~PCUT_STATUS;
-	usb_ocp_write_word(tp, USB_MISC_0, ocp_data);
+	usb_ocp_modify_word(tp, USB_POWER_CUT, PWR_EN | PHASE2_EN,
+			    enable ? PWR_EN | PHASE2_EN : 0);
+	usb_ocp_modify_word(tp, USB_MISC_0, PCUT_STATUS, 0);
 }
 
 static void r8153b_power_cut_en(struct r8152 *tp, bool enable)
 {
-	u32 ocp_data;
-
-	ocp_data = usb_ocp_read_word(tp, USB_POWER_CUT);
-	if (enable)
-		ocp_data |= PWR_EN | PHASE2_EN;
-	else
-		ocp_data &= ~PWR_EN;
-	usb_ocp_write_word(tp, USB_POWER_CUT, ocp_data);
-
-	ocp_data = usb_ocp_read_word(tp, USB_MISC_0);
-	ocp_data &= ~PCUT_STATUS;
-	usb_ocp_write_word(tp, USB_MISC_0, ocp_data);
+	usb_ocp_modify_word(tp, USB_POWER_CUT, PWR_EN,
+			    enable ? PWR_EN | PHASE2_EN : 0);
+	usb_ocp_modify_word(tp, USB_MISC_0, PCUT_STATUS, 0);
 }
 
 static void r8153_queue_wake(struct r8152 *tp, bool enable)
 {
-	u32 ocp_data;
-
-	ocp_data = pla_ocp_read_byte(tp, PLA_INDICATE_FALG);
-	if (enable)
-		ocp_data |= UPCOMING_RUNTIME_D3;
-	else
-		ocp_data &= ~UPCOMING_RUNTIME_D3;
-	pla_ocp_write_byte(tp, PLA_INDICATE_FALG, ocp_data);
-
-	ocp_data = pla_ocp_read_byte(tp, PLA_SUSPEND_FLAG);
-	ocp_data &= ~LINK_CHG_EVENT;
-	pla_ocp_write_byte(tp, PLA_SUSPEND_FLAG, ocp_data);
-
-	ocp_data = pla_ocp_read_word(tp, PLA_EXTRA_STATUS);
-	ocp_data &= ~LINK_CHANGE_FLAG;
-	pla_ocp_write_word(tp, PLA_EXTRA_STATUS, ocp_data);
+	pla_ocp_modify_byte(tp, PLA_INDICATE_FALG, UPCOMING_RUNTIME_D3,
+			    enable ? UPCOMING_RUNTIME_D3 : 0);
+	pla_ocp_modify_byte(tp, PLA_SUSPEND_FLAG, LINK_CHG_EVENT, 0);
+	pla_ocp_modify_word(tp, PLA_EXTRA_STATUS, LINK_CHANGE_FLAG, 0);
 }
 
 static bool rtl_can_wakeup(struct r8152 *tp)
@@ -3335,31 +3240,12 @@ static bool rtl_can_wakeup(struct r8152 *tp)
 
 static void rtl_runtime_suspend_enable(struct r8152 *tp, bool enable)
 {
-	if (enable) {
-		u32 ocp_data;
-
-		__rtl_set_wol(tp, WAKE_ANY);
-
-		pla_ocp_write_byte(tp, PLA_CRWECR, CRWECR_CONFIG);
-
-		ocp_data = pla_ocp_read_word(tp, PLA_CONFIG34);
-		ocp_data |= LINK_OFF_WAKE_EN;
-		pla_ocp_write_word(tp, PLA_CONFIG34, ocp_data);
-
-		pla_ocp_write_byte(tp, PLA_CRWECR, CRWECR_NORAML);
-	} else {
-		u32 ocp_data;
-
-		__rtl_set_wol(tp, tp->saved_wolopts);
-
-		pla_ocp_write_byte(tp, PLA_CRWECR, CRWECR_CONFIG);
+	__rtl_set_wol(tp, enable ? WAKE_ANY : tp->saved_wolopts);
 
-		ocp_data = pla_ocp_read_word(tp, PLA_CONFIG34);
-		ocp_data &= ~LINK_OFF_WAKE_EN;
-		pla_ocp_write_word(tp, PLA_CONFIG34, ocp_data);
-
-		pla_ocp_write_byte(tp, PLA_CRWECR, CRWECR_NORAML);
-	}
+	pla_ocp_write_byte(tp, PLA_CRWECR, CRWECR_CONFIG);
+	pla_ocp_modify_word(tp, PLA_CONFIG34, LINK_OFF_WAKE_EN,
+			    enable ? LINK_OFF_WAKE_EN : 0);
+	pla_ocp_write_byte(tp, PLA_CRWECR, CRWECR_NORAML);
 }
 
 static void rtl8153_runtime_enable(struct r8152 *tp, bool enable)
@@ -3407,8 +3293,6 @@ static void rtl8153b_runtime_enable(struct r8152 *tp, bool enable)
 
 static void r8153_teredo_off(struct r8152 *tp)
 {
-	u32 ocp_data;
-
 	switch (tp->version) {
 	case RTL_VER_01:
 	case RTL_VER_02:
@@ -3417,10 +3301,9 @@ static void r8153_teredo_off(struct r8152 *tp)
 	case RTL_VER_05:
 	case RTL_VER_06:
 	case RTL_VER_07:
-		ocp_data = pla_ocp_read_word(tp, PLA_TEREDO_CFG);
-		ocp_data &= ~(TEREDO_SEL | TEREDO_RS_EVENT_MASK |
-			      OOB_TEREDO_EN);
-		pla_ocp_write_word(tp, PLA_TEREDO_CFG, ocp_data);
+		pla_ocp_modify_word(tp, PLA_TEREDO_CFG,
+				    TEREDO_SEL | TEREDO_RS_EVENT_MASK |
+				    OOB_TEREDO_EN, 0);
 		break;
 
 	case RTL_VER_08:
@@ -3442,13 +3325,10 @@ static void r8153_teredo_off(struct r8152 *tp)
 
 static void rtl_reset_bmu(struct r8152 *tp)
 {
-	u32 ocp_data;
+	u8 bits = BMU_RESET_EP_IN | BMU_RESET_EP_OUT;
 
-	ocp_data = usb_ocp_read_byte(tp, USB_BMU_RESET);
-	ocp_data &= ~(BMU_RESET_EP_IN | BMU_RESET_EP_OUT);
-	usb_ocp_write_byte(tp, USB_BMU_RESET, ocp_data);
-	ocp_data |= BMU_RESET_EP_IN | BMU_RESET_EP_OUT;
-	usb_ocp_write_byte(tp, USB_BMU_RESET, ocp_data);
+	usb_ocp_modify_byte(tp, USB_BMU_RESET, bits, 0);
+	usb_ocp_modify_byte(tp, USB_BMU_RESET, 0, bits);
 }
 
 /* Clear the bp to stop the firmware before loading a new one */
@@ -3501,15 +3381,10 @@ static void rtl_clear_bp(struct r8152 *tp, u16 type)
 
 static int r8153_patch_request(struct r8152 *tp, bool request)
 {
-	u16 data;
 	int i;
 
-	data = ocp_reg_read(tp, OCP_PHY_PATCH_CMD);
-	if (request)
-		data |= PATCH_REQUEST;
-	else
-		data &= ~PATCH_REQUEST;
-	ocp_reg_write(tp, OCP_PHY_PATCH_CMD, data);
+	ocp_reg_modify(tp, OCP_PHY_PATCH_CMD, PATCH_REQUEST,
+		       request ? PATCH_REQUEST : 0);
 
 	for (i = 0; request && i < 5000; i++) {
 		usleep_range(1000, 2000);
@@ -3541,13 +3416,9 @@ static int r8153_pre_ram_code(struct r8152 *tp, u16 key_addr, u16 patch_key)
 
 static int r8153_post_ram_code(struct r8152 *tp, u16 key_addr)
 {
-	u16 data;
-
 	sram_write(tp, 0x0000, 0x0000);
 
-	data = ocp_reg_read(tp, OCP_PHY_LOCK);
-	data &= ~PATCH_LOCK;
-	ocp_reg_write(tp, OCP_PHY_LOCK, data);
+	ocp_reg_modify(tp, OCP_PHY_LOCK, PATCH_LOCK, 0);
 
 	sram_write(tp, key_addr, 0x0000);
 
@@ -4202,22 +4073,9 @@ static void r8152_eee_en(struct r8152 *tp, bool enable)
 
 static void r8153_eee_en(struct r8152 *tp, bool enable)
 {
-	u32 ocp_data;
-	u16 config;
-
-	ocp_data = pla_ocp_read_word(tp, PLA_EEE_CR);
-	config = ocp_reg_read(tp, OCP_EEE_CFG);
-
-	if (enable) {
-		ocp_data |= EEE_RX_EN | EEE_TX_EN;
-		config |= EEE10_EN;
-	} else {
-		ocp_data &= ~(EEE_RX_EN | EEE_TX_EN);
-		config &= ~EEE10_EN;
-	}
-
-	pla_ocp_write_word(tp, PLA_EEE_CR, ocp_data);
-	ocp_reg_write(tp, OCP_EEE_CFG, config);
+	pla_ocp_modify_word(tp, PLA_EEE_CR, EEE_RX_EN | EEE_TX_EN,
+			    enable ? EEE_RX_EN | EEE_TX_EN : 0);
+	ocp_reg_modify(tp, OCP_EEE_CFG, EEE10_EN, enable ? EEE10_EN : 0);
 
 	tp->ups_info.eee = enable;
 }
@@ -4258,11 +4116,8 @@ static void rtl_eee_enable(struct r8152 *tp, bool enable)
 
 static void r8152b_enable_fc(struct r8152 *tp)
 {
-	u16 anar;
-
-	anar = r8152_mdio_read(tp, MII_ADVERTISE);
-	anar |= ADVERTISE_PAUSE_CAP | ADVERTISE_PAUSE_ASYM;
-	r8152_mdio_write(tp, MII_ADVERTISE, anar);
+	r8152_mdio_modify(tp, MII_ADVERTISE, 0,
+			  ADVERTISE_PAUSE_CAP | ADVERTISE_PAUSE_ASYM);
 
 	tp->ups_info.flow_control = true;
 }
@@ -4299,30 +4154,19 @@ static void wait_oob_link_list_ready(struct r8152 *tp)
 
 static void r8152b_exit_oob(struct r8152 *tp)
 {
-	u32 ocp_data;
-
-	ocp_data = pla_ocp_read_dword(tp, PLA_RCR);
-	ocp_data &= ~RCR_ACPT_ALL;
-	pla_ocp_write_dword(tp, PLA_RCR, ocp_data);
+	pla_ocp_modify_dword(tp, PLA_RCR, RCR_ACPT_ALL, 0);
 
 	rxdy_gated_en(tp, true);
 	r8153_teredo_off(tp);
 	pla_ocp_write_byte(tp, PLA_CRWECR, CRWECR_NORAML);
 	pla_ocp_write_byte(tp, PLA_CR, 0x00);
 
-	ocp_data = pla_ocp_read_byte(tp, PLA_OOB_CTRL);
-	ocp_data &= ~NOW_IS_OOB;
-	pla_ocp_write_byte(tp, PLA_OOB_CTRL, ocp_data);
-
-	ocp_data = pla_ocp_read_word(tp, PLA_SFF_STS_7);
-	ocp_data &= ~MCU_BORW_EN;
-	pla_ocp_write_word(tp, PLA_SFF_STS_7, ocp_data);
+	pla_ocp_modify_byte(tp, PLA_OOB_CTRL, NOW_IS_OOB, 0);
+	pla_ocp_modify_word(tp, PLA_SFF_STS_7, MCU_BORW_EN, 0);
 
 	wait_oob_link_list_ready(tp);
 
-	ocp_data = pla_ocp_read_word(tp, PLA_SFF_STS_7);
-	ocp_data |= RE_INIT_LL;
-	pla_ocp_write_word(tp, PLA_SFF_STS_7, ocp_data);
+	pla_ocp_modify_word(tp, PLA_SFF_STS_7, 0, RE_INIT_LL);
 
 	wait_oob_link_list_ready(tp);
 
@@ -4354,18 +4198,12 @@ static void r8152b_exit_oob(struct r8152 *tp)
 
 	pla_ocp_write_word(tp, PLA_RMS, RTL8152_RMS);
 
-	ocp_data = pla_ocp_read_word(tp, PLA_TCR0);
-	ocp_data |= TCR0_AUTO_FIFO;
-	pla_ocp_write_word(tp, PLA_TCR0, ocp_data);
+	pla_ocp_modify_word(tp, PLA_TCR0, 0, TCR0_AUTO_FIFO);
 }
 
 static void r8152b_enter_oob(struct r8152 *tp)
 {
-	u32 ocp_data;
-
-	ocp_data = pla_ocp_read_byte(tp, PLA_OOB_CTRL);
-	ocp_data &= ~NOW_IS_OOB;
-	pla_ocp_write_byte(tp, PLA_OOB_CTRL, ocp_data);
+	pla_ocp_modify_byte(tp, PLA_OOB_CTRL, NOW_IS_OOB, 0);
 
 	pla_ocp_write_dword(tp, PLA_RXFIFO_CTRL0, RXFIFO_THR1_OOB);
 	pla_ocp_write_dword(tp, PLA_RXFIFO_CTRL1, RXFIFO_THR2_OOB);
@@ -4375,9 +4213,7 @@ static void r8152b_enter_oob(struct r8152 *tp)
 
 	wait_oob_link_list_ready(tp);
 
-	ocp_data = pla_ocp_read_word(tp, PLA_SFF_STS_7);
-	ocp_data |= RE_INIT_LL;
-	pla_ocp_write_word(tp, PLA_SFF_STS_7, ocp_data);
+	pla_ocp_modify_word(tp, PLA_SFF_STS_7, 0, RE_INIT_LL);
 
 	wait_oob_link_list_ready(tp);
 
@@ -4385,19 +4221,12 @@ static void r8152b_enter_oob(struct r8152 *tp)
 
 	rtl_rx_vlan_en(tp, true);
 
-	ocp_data = pla_ocp_read_word(tp, PLA_BDC_CR);
-	ocp_data |= ALDPS_PROXY_MODE;
-	pla_ocp_write_word(tp, PLA_BDC_CR, ocp_data);
-
-	ocp_data = pla_ocp_read_byte(tp, PLA_OOB_CTRL);
-	ocp_data |= NOW_IS_OOB | DIS_MCU_CLROOB;
-	pla_ocp_write_byte(tp, PLA_OOB_CTRL, ocp_data);
+	pla_ocp_modify_word(tp, PLA_BDC_CR, 0, ALDPS_PROXY_MODE);
+	pla_ocp_modify_byte(tp, PLA_OOB_CTRL, 0, NOW_IS_OOB | DIS_MCU_CLROOB);
 
 	rxdy_gated_en(tp, false);
 
-	ocp_data = pla_ocp_read_dword(tp, PLA_RCR);
-	ocp_data |= RCR_APM | RCR_AM | RCR_AB;
-	pla_ocp_write_dword(tp, PLA_RCR, ocp_data);
+	pla_ocp_modify_dword(tp, PLA_RCR, 0, RCR_APM | RCR_AM | RCR_AB);
 }
 
 static int r8153_pre_firmware_1(struct r8152 *tp)
@@ -4406,9 +4235,7 @@ static int r8153_pre_firmware_1(struct r8152 *tp)
 
 	/* Wait till the WTD timer is ready. It would take at most 104 ms. */
 	for (i = 0; i < 104; i++) {
-		u32 ocp_data = usb_ocp_read_byte(tp, USB_WDT1_CTRL);
-
-		if (!(ocp_data & WTD1_EN))
+		if (!(usb_ocp_read_byte(tp, USB_WDT1_CTRL) & WTD1_EN))
 			break;
 		usleep_range(1000, 2000);
 	}
@@ -4430,56 +4257,34 @@ static int r8153_post_firmware_1(struct r8152 *tp)
 
 static int r8153_pre_firmware_2(struct r8152 *tp)
 {
-	u32 ocp_data;
-
 	r8153_pre_firmware_1(tp);
 
-	ocp_data = usb_ocp_read_word(tp, USB_FW_FIX_EN0);
-	ocp_data &= ~FW_FIX_SUSPEND;
-	usb_ocp_write_word(tp, USB_FW_FIX_EN0, ocp_data);
+	usb_ocp_modify_word(tp, USB_FW_FIX_EN0, FW_FIX_SUSPEND, 0);
 
 	return 0;
 }
 
 static int r8153_post_firmware_2(struct r8152 *tp)
 {
-	u32 ocp_data;
-
 	/* enable bp0 if support USB_SPEED_SUPER only */
-	if (usb_ocp_read_byte(tp, USB_CSTMR) & FORCE_SUPER) {
-		ocp_data = pla_ocp_read_word(tp, PLA_BP_EN);
-		ocp_data |= BIT(0);
-		pla_ocp_write_word(tp, PLA_BP_EN, ocp_data);
-	}
+	if (usb_ocp_read_byte(tp, USB_CSTMR) & FORCE_SUPER)
+		pla_ocp_modify_word(tp, PLA_BP_EN, 0, BIT(0));
 
 	/* reset UPHY timer to 36 ms */
 	pla_ocp_write_word(tp, PLA_UPHY_TIMER, 36000 / 16);
 
 	/* enable U3P3 check, set the counter to 4 */
 	pla_ocp_write_word(tp, PLA_EXTRA_STATUS, U3P3_CHECK_EN | 4);
-
-	ocp_data = usb_ocp_read_word(tp, USB_FW_FIX_EN0);
-	ocp_data |= FW_FIX_SUSPEND;
-	usb_ocp_write_word(tp, USB_FW_FIX_EN0, ocp_data);
-
-	ocp_data = usb_ocp_read_byte(tp, USB_USB2PHY);
-	ocp_data |= USB2PHY_L1 | USB2PHY_SUSPEND;
-	usb_ocp_write_byte(tp, USB_USB2PHY, ocp_data);
+	usb_ocp_modify_word(tp, USB_FW_FIX_EN0, 0, FW_FIX_SUSPEND);
+	usb_ocp_modify_byte(tp, USB_USB2PHY, 0, USB2PHY_L1 | USB2PHY_SUSPEND);
 
 	return 0;
 }
 
 static int r8153_post_firmware_3(struct r8152 *tp)
 {
-	u32 ocp_data;
-
-	ocp_data = usb_ocp_read_byte(tp, USB_USB2PHY);
-	ocp_data |= USB2PHY_L1 | USB2PHY_SUSPEND;
-	usb_ocp_write_byte(tp, USB_USB2PHY, ocp_data);
-
-	ocp_data = usb_ocp_read_word(tp, USB_FW_FIX_EN1);
-	ocp_data |= FW_IP_RESET_EN;
-	usb_ocp_write_word(tp, USB_FW_FIX_EN1, ocp_data);
+	usb_ocp_modify_byte(tp, USB_USB2PHY, 0, USB2PHY_L1 | USB2PHY_SUSPEND);
+	usb_ocp_modify_word(tp, USB_FW_FIX_EN1, 0, FW_IP_RESET_EN);
 
 	return 0;
 }
@@ -4494,44 +4299,24 @@ static int r8153b_pre_firmware_1(struct r8152 *tp)
 
 static int r8153b_post_firmware_1(struct r8152 *tp)
 {
-	u32 ocp_data;
-
 	/* enable bp0 for RTL8153-BND */
-	ocp_data = usb_ocp_read_byte(tp, USB_MISC_1);
-	if (ocp_data & BND_MASK) {
-		ocp_data = pla_ocp_read_word(tp, PLA_BP_EN);
-		ocp_data |= BIT(0);
-		pla_ocp_write_word(tp, PLA_BP_EN, ocp_data);
-	}
-
-	ocp_data = usb_ocp_read_word(tp, USB_FW_CTRL);
-	ocp_data |= FLOW_CTRL_PATCH_OPT;
-	usb_ocp_write_word(tp, USB_FW_CTRL, ocp_data);
+	if (usb_ocp_read_byte(tp, USB_MISC_1) & BND_MASK)
+		pla_ocp_modify_word(tp, PLA_BP_EN, 0, BIT(0));
 
-	ocp_data = usb_ocp_read_word(tp, USB_FW_TASK);
-	ocp_data |= FC_PATCH_TASK;
-	usb_ocp_write_word(tp, USB_FW_TASK, ocp_data);
-
-	ocp_data = usb_ocp_read_word(tp, USB_FW_FIX_EN1);
-	ocp_data |= FW_IP_RESET_EN;
-	usb_ocp_write_word(tp, USB_FW_FIX_EN1, ocp_data);
+	usb_ocp_modify_word(tp, USB_FW_CTRL, 0, FLOW_CTRL_PATCH_OPT);
+	usb_ocp_modify_word(tp, USB_FW_TASK, 0, FC_PATCH_TASK);
+	usb_ocp_modify_word(tp, USB_FW_FIX_EN1, 0, FW_IP_RESET_EN);
 
 	return 0;
 }
 
 static void r8153_aldps_en(struct r8152 *tp, bool enable)
 {
-	u16 data;
+	ocp_reg_modify(tp, OCP_POWER_CFG, EN_ALDPS, enable ? EN_ALDPS : 0);
 
-	data = ocp_reg_read(tp, OCP_POWER_CFG);
-	if (enable) {
-		data |= EN_ALDPS;
-		ocp_reg_write(tp, OCP_POWER_CFG, data);
-	} else {
+	if (!enable) {
 		int i;
 
-		data &= ~EN_ALDPS;
-		ocp_reg_write(tp, OCP_POWER_CFG, data);
 		for (i = 0; i < 20; i++) {
 			usleep_range(1000, 2000);
 			if (pla_ocp_read_word(tp, 0xe000) & 0x0100)
@@ -4544,9 +4329,6 @@ static void r8153_aldps_en(struct r8152 *tp, bool enable)
 
 static void r8153_hw_phy_cfg(struct r8152 *tp)
 {
-	u32 ocp_data;
-	u16 data;
-
 	/* disable ALDPS before updating the PHY parameters */
 	r8153_aldps_en(tp, false);
 
@@ -4555,27 +4337,16 @@ static void r8153_hw_phy_cfg(struct r8152 *tp)
 
 	rtl8152_apply_firmware(tp);
 
-	if (tp->version == RTL_VER_03) {
-		data = ocp_reg_read(tp, OCP_EEE_CFG);
-		data &= ~CTAP_SHORT_EN;
-		ocp_reg_write(tp, OCP_EEE_CFG, data);
-	}
+	if (tp->version == RTL_VER_03)
+		ocp_reg_modify(tp, OCP_EEE_CFG, CTAP_SHORT_EN, 0);
 
-	data = ocp_reg_read(tp, OCP_POWER_CFG);
-	data |= EEE_CLKDIV_EN;
-	ocp_reg_write(tp, OCP_POWER_CFG, data);
+	ocp_reg_modify(tp, OCP_POWER_CFG, 0, EEE_CLKDIV_EN);
 
-	data = ocp_reg_read(tp, OCP_DOWN_SPEED);
-	data |= EN_10M_BGOFF;
-	ocp_reg_write(tp, OCP_DOWN_SPEED, data);
-	data = ocp_reg_read(tp, OCP_POWER_CFG);
-	data |= EN_10M_PLLOFF;
-	ocp_reg_write(tp, OCP_POWER_CFG, data);
+	ocp_reg_modify(tp, OCP_DOWN_SPEED, 0, EN_10M_BGOFF);
+	ocp_reg_modify(tp, OCP_POWER_CFG, 0, EN_10M_PLLOFF);
 	sram_write(tp, SRAM_IMPEDANCE, 0x0b13);
 
-	ocp_data = pla_ocp_read_word(tp, PLA_PHY_PWR);
-	ocp_data |= PFM_PWM_SWITCH;
-	pla_ocp_write_word(tp, PLA_PHY_PWR, ocp_data);
+	pla_ocp_modify_word(tp, PLA_PHY_PWR, 0, PFM_PWM_SWITCH);
 
 	/* Enable LPF corner auto tune */
 	sram_write(tp, SRAM_LPF_CFG, 0xf70f);
@@ -4618,8 +4389,7 @@ static u32 r8152_efuse_read(struct r8152 *tp, u8 addr)
 
 static void r8153b_hw_phy_cfg(struct r8152 *tp)
 {
-	u32 ocp_data;
-	u16 data;
+	u32 data;
 
 	/* disable ALDPS before updating the PHY parameters */
 	r8153_aldps_en(tp, false);
@@ -4631,20 +4401,16 @@ static void r8153b_hw_phy_cfg(struct r8152 *tp)
 
 	r8153b_green_en(tp, test_bit(GREEN_ETHERNET, &tp->flags));
 
-	data = sram_read(tp, SRAM_GREEN_CFG);
-	data |= R_TUNE_EN;
-	sram_write(tp, SRAM_GREEN_CFG, data);
-	data = ocp_reg_read(tp, OCP_NCTL_CFG);
-	data |= PGA_RETURN_EN;
-	ocp_reg_write(tp, OCP_NCTL_CFG, data);
+	sram_modify(tp, SRAM_GREEN_CFG, 0, R_TUNE_EN);
+	ocp_reg_modify(tp, OCP_NCTL_CFG, 0, PGA_RETURN_EN);
 
 	/* ADC Bias Calibration:
 	 * read efuse offset 0x7d to get a 17-bit data. Remove the dummy/fake
 	 * bit (bit3) to rebuild the real 16-bit data. Write the data to the
 	 * ADC ioffset.
 	 */
-	ocp_data = r8152_efuse_read(tp, 0x7d);
-	data = (u16)(((ocp_data & 0x1fff0) >> 1) | (ocp_data & 0x7));
+	data = r8152_efuse_read(tp, 0x7d);
+	data = ((data & 0x1fff0) >> 1) | (data & 0x7);
 	if (data != 0xffff)
 		ocp_reg_write(tp, OCP_ADC_IOFFSET, data);
 
@@ -4652,31 +4418,20 @@ static void r8153b_hw_phy_cfg(struct r8152 *tp)
 	 * rg_saw_cnt = OCP reg 0xC426 Bit[13:0]
 	 * swr_cnt_1ms_ini = 16000000 / rg_saw_cnt
 	 */
-	ocp_data = ocp_reg_read(tp, 0xc426);
-	ocp_data &= 0x3fff;
-	if (ocp_data) {
-		u32 swr_cnt_1ms_ini;
+	data = ocp_reg_read(tp, 0xc426) & 0x3fff;
+	if (data)
+		usb_ocp_modify_word(tp, USB_UPS_CFG, SAW_CNT_1MS_MASK,
+				    (16000000 / data) & SAW_CNT_1MS_MASK);
 
-		swr_cnt_1ms_ini = (16000000 / ocp_data) & SAW_CNT_1MS_MASK;
-		ocp_data = usb_ocp_read_word(tp, USB_UPS_CFG);
-		ocp_data = (ocp_data & ~SAW_CNT_1MS_MASK) | swr_cnt_1ms_ini;
-		usb_ocp_write_word(tp, USB_UPS_CFG, ocp_data);
-	}
-
-	ocp_data = pla_ocp_read_word(tp, PLA_PHY_PWR);
-	ocp_data |= PFM_PWM_SWITCH;
-	pla_ocp_write_word(tp, PLA_PHY_PWR, ocp_data);
+	pla_ocp_modify_word(tp, PLA_PHY_PWR, 0, PFM_PWM_SWITCH);
 
 	/* Advnace EEE */
 	if (!r8153_patch_request(tp, true)) {
-		data = ocp_reg_read(tp, OCP_POWER_CFG);
-		data |= EEE_CLKDIV_EN;
-		ocp_reg_write(tp, OCP_POWER_CFG, data);
+		ocp_reg_modify(tp, OCP_POWER_CFG, 0, EEE_CLKDIV_EN);
 		tp->ups_info.eee_ckdiv = true;
 
-		data = ocp_reg_read(tp, OCP_DOWN_SPEED);
-		data |= EN_EEE_CMODE | EN_EEE_1000 | EN_10M_CLKDIV;
-		ocp_reg_write(tp, OCP_DOWN_SPEED, data);
+		ocp_reg_modify(tp, OCP_DOWN_SPEED, 0,
+			       EN_EEE_CMODE | EN_EEE_1000 | EN_10M_CLKDIV);
 		tp->ups_info.eee_cmod_lv = true;
 		tp->ups_info._10m_ckdiv = true;
 		tp->ups_info.eee_plloff_giga = true;
@@ -4699,44 +4454,31 @@ static void r8153b_hw_phy_cfg(struct r8152 *tp)
 
 static void r8153_first_init(struct r8152 *tp)
 {
-	u32 ocp_data;
-
 	r8153_mac_clk_spd(tp, false);
 	rxdy_gated_en(tp, true);
 	r8153_teredo_off(tp);
 
-	ocp_data = pla_ocp_read_dword(tp, PLA_RCR);
-	ocp_data &= ~RCR_ACPT_ALL;
-	pla_ocp_write_dword(tp, PLA_RCR, ocp_data);
+	pla_ocp_modify_dword(tp, PLA_RCR, RCR_ACPT_ALL, 0);
 
 	rtl8152_nic_reset(tp);
 	rtl_reset_bmu(tp);
 
-	ocp_data = pla_ocp_read_byte(tp, PLA_OOB_CTRL);
-	ocp_data &= ~NOW_IS_OOB;
-	pla_ocp_write_byte(tp, PLA_OOB_CTRL, ocp_data);
-
-	ocp_data = pla_ocp_read_word(tp, PLA_SFF_STS_7);
-	ocp_data &= ~MCU_BORW_EN;
-	pla_ocp_write_word(tp, PLA_SFF_STS_7, ocp_data);
+	pla_ocp_modify_byte(tp, PLA_OOB_CTRL, NOW_IS_OOB, 0);
+	pla_ocp_modify_word(tp, PLA_SFF_STS_7, MCU_BORW_EN, 0);
 
 	wait_oob_link_list_ready(tp);
 
-	ocp_data = pla_ocp_read_word(tp, PLA_SFF_STS_7);
-	ocp_data |= RE_INIT_LL;
-	pla_ocp_write_word(tp, PLA_SFF_STS_7, ocp_data);
+	pla_ocp_modify_word(tp, PLA_SFF_STS_7, 0, RE_INIT_LL);
 
 	wait_oob_link_list_ready(tp);
 
 	rtl_rx_vlan_en(tp, tp->netdev->features & NETIF_F_HW_VLAN_CTAG_RX);
 
-	ocp_data = tp->netdev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
-	pla_ocp_write_word(tp, PLA_RMS, ocp_data);
+	pla_ocp_write_word(tp, PLA_RMS,
+			   tp->netdev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN);
 	pla_ocp_write_byte(tp, PLA_MTPS, MTPS_JUMBO);
 
-	ocp_data = pla_ocp_read_word(tp, PLA_TCR0);
-	ocp_data |= TCR0_AUTO_FIFO;
-	pla_ocp_write_word(tp, PLA_TCR0, ocp_data);
+	pla_ocp_modify_word(tp, PLA_TCR0, 0, TCR0_AUTO_FIFO);
 
 	rtl8152_nic_reset(tp);
 
@@ -4750,36 +4492,28 @@ static void r8153_first_init(struct r8152 *tp)
 
 static void r8153_enter_oob(struct r8152 *tp)
 {
-	u32 ocp_data;
-
 	r8153_mac_clk_spd(tp, true);
 
-	ocp_data = pla_ocp_read_byte(tp, PLA_OOB_CTRL);
-	ocp_data &= ~NOW_IS_OOB;
-	pla_ocp_write_byte(tp, PLA_OOB_CTRL, ocp_data);
+	pla_ocp_modify_byte(tp, PLA_OOB_CTRL, NOW_IS_OOB, 0);
 
 	rtl_disable(tp);
 	rtl_reset_bmu(tp);
 
 	wait_oob_link_list_ready(tp);
 
-	ocp_data = pla_ocp_read_word(tp, PLA_SFF_STS_7);
-	ocp_data |= RE_INIT_LL;
-	pla_ocp_write_word(tp, PLA_SFF_STS_7, ocp_data);
+	pla_ocp_modify_word(tp, PLA_SFF_STS_7, 0, RE_INIT_LL);
 
 	wait_oob_link_list_ready(tp);
 
-	ocp_data = tp->netdev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
-	pla_ocp_write_word(tp, PLA_RMS, ocp_data);
+	pla_ocp_write_word(tp, PLA_RMS,
+			   tp->netdev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN);
 
 	switch (tp->version) {
 	case RTL_VER_03:
 	case RTL_VER_04:
 	case RTL_VER_05:
 	case RTL_VER_06:
-		ocp_data = pla_ocp_read_word(tp, PLA_TEREDO_CFG);
-		ocp_data &= ~TEREDO_WAKE_MASK;
-		pla_ocp_write_word(tp, PLA_TEREDO_CFG, ocp_data);
+		pla_ocp_modify_word(tp, PLA_TEREDO_CFG, TEREDO_WAKE_MASK, 0);
 		break;
 
 	case RTL_VER_08:
@@ -4797,19 +4531,12 @@ static void r8153_enter_oob(struct r8152 *tp)
 
 	rtl_rx_vlan_en(tp, true);
 
-	ocp_data = pla_ocp_read_word(tp, PLA_BDC_CR);
-	ocp_data |= ALDPS_PROXY_MODE;
-	pla_ocp_write_word(tp, PLA_BDC_CR, ocp_data);
-
-	ocp_data = pla_ocp_read_byte(tp, PLA_OOB_CTRL);
-	ocp_data |= NOW_IS_OOB | DIS_MCU_CLROOB;
-	pla_ocp_write_byte(tp, PLA_OOB_CTRL, ocp_data);
+	pla_ocp_modify_word(tp, PLA_BDC_CR, 0, ALDPS_PROXY_MODE);
+	pla_ocp_modify_byte(tp, PLA_OOB_CTRL, 0, NOW_IS_OOB | DIS_MCU_CLROOB);
 
 	rxdy_gated_en(tp, false);
 
-	ocp_data = pla_ocp_read_dword(tp, PLA_RCR);
-	ocp_data |= RCR_APM | RCR_AM | RCR_AB;
-	pla_ocp_write_dword(tp, PLA_RCR, ocp_data);
+	pla_ocp_modify_dword(tp, PLA_RCR, 0, RCR_APM | RCR_AM | RCR_AB);
 }
 
 static void rtl8153_disable(struct r8152 *tp)
@@ -4868,7 +4595,7 @@ static int rtl8152_set_speed(struct r8152 *tp, u8 autoneg, u32 speed, u8 duplex,
 
 		tp->mii.force_media = 1;
 	} else {
-		u16 anar, tmp1;
+		u16 anar = 0;
 		u32 support;
 
 		support = RTL_ADVERTISED_10_HALF | RTL_ADVERTISED_10_FULL |
@@ -4880,46 +4607,42 @@ static int rtl8152_set_speed(struct r8152 *tp, u8 autoneg, u32 speed, u8 duplex,
 		if (!(advertising & support))
 			return -EINVAL;
 
-		anar = r8152_mdio_read(tp, MII_ADVERTISE);
-		tmp1 = anar & ~(ADVERTISE_10HALF | ADVERTISE_10FULL |
-				ADVERTISE_100HALF | ADVERTISE_100FULL);
 		if (advertising & RTL_ADVERTISED_10_HALF) {
-			tmp1 |= ADVERTISE_10HALF;
+			anar |= ADVERTISE_10HALF;
 			tp->ups_info.speed_duplex = NWAY_10M_HALF;
 		}
 		if (advertising & RTL_ADVERTISED_10_FULL) {
-			tmp1 |= ADVERTISE_10FULL;
+			anar |= ADVERTISE_10FULL;
 			tp->ups_info.speed_duplex = NWAY_10M_FULL;
 		}
 
 		if (advertising & RTL_ADVERTISED_100_HALF) {
-			tmp1 |= ADVERTISE_100HALF;
+			anar |= ADVERTISE_100HALF;
 			tp->ups_info.speed_duplex = NWAY_100M_HALF;
 		}
 		if (advertising & RTL_ADVERTISED_100_FULL) {
-			tmp1 |= ADVERTISE_100FULL;
+			anar |= ADVERTISE_100FULL;
 			tp->ups_info.speed_duplex = NWAY_100M_FULL;
 		}
 
-		if (anar != tmp1) {
-			r8152_mdio_write(tp, MII_ADVERTISE, tmp1);
-			tp->mii.advertising = tmp1;
-		}
+		r8152_mdio_modify(tp, MII_ADVERTISE,
+				  ADVERTISE_10HALF | ADVERTISE_10FULL |
+				  ADVERTISE_100HALF | ADVERTISE_100FULL,
+				  anar);
+		tp->mii.advertising = anar;
 
 		if (tp->mii.supports_gmii) {
-			u16 gbcr;
-
-			gbcr = r8152_mdio_read(tp, MII_CTRL1000);
-			tmp1 = gbcr & ~(ADVERTISE_1000FULL |
-					ADVERTISE_1000HALF);
+			u16 gbcr = 0;
 
 			if (advertising & RTL_ADVERTISED_1000_FULL) {
-				tmp1 |= ADVERTISE_1000FULL;
+				gbcr |= ADVERTISE_1000FULL;
 				tp->ups_info.speed_duplex = NWAY_1000M_FULL;
 			}
 
-			if (gbcr != tmp1)
-				r8152_mdio_write(tp, MII_CTRL1000, tmp1);
+			r8152_mdio_modify(tp, MII_CTRL1000,
+					  ADVERTISE_1000FULL |
+					  ADVERTISE_1000HALF,
+					  gbcr);
 		}
 
 		bmcr = BMCR_ANENABLE | BMCR_ANRESTART;
@@ -4971,8 +4694,6 @@ static void rtl8152_down(struct r8152 *tp)
 
 static void rtl8153_up(struct r8152 *tp)
 {
-	u32 ocp_data;
-
 	if (test_bit(RTL8152_UNPLUG, &tp->flags))
 		return;
 
@@ -4981,17 +4702,9 @@ static void rtl8153_up(struct r8152 *tp)
 	r8153_aldps_en(tp, false);
 	r8153_first_init(tp);
 
-	ocp_data = pla_ocp_read_byte(tp, PLA_CONFIG6);
-	ocp_data |= LANWAKE_CLR_EN;
-	pla_ocp_write_byte(tp, PLA_CONFIG6, ocp_data);
-
-	ocp_data = pla_ocp_read_byte(tp, PLA_LWAKE_CTRL_REG);
-	ocp_data &= ~LANWAKE_PIN;
-	pla_ocp_write_byte(tp, PLA_LWAKE_CTRL_REG, ocp_data);
-
-	ocp_data = usb_ocp_read_word(tp, USB_SSPHYLINK1);
-	ocp_data &= ~DELAY_PHY_PWR_CHG;
-	usb_ocp_write_word(tp, USB_SSPHYLINK1, ocp_data);
+	pla_ocp_modify_byte(tp, PLA_CONFIG6, 0, LANWAKE_CLR_EN);
+	pla_ocp_modify_byte(tp, PLA_LWAKE_CTRL_REG, LANWAKE_PIN, 0);
+	usb_ocp_modify_word(tp, USB_SSPHYLINK1, DELAY_PHY_PWR_CHG, 0);
 
 	r8153_aldps_en(tp, true);
 
@@ -5011,16 +4724,12 @@ static void rtl8153_up(struct r8152 *tp)
 
 static void rtl8153_down(struct r8152 *tp)
 {
-	u32 ocp_data;
-
 	if (test_bit(RTL8152_UNPLUG, &tp->flags)) {
 		rtl_drop_queued_tx(tp);
 		return;
 	}
 
-	ocp_data = pla_ocp_read_byte(tp, PLA_CONFIG6);
-	ocp_data &= ~LANWAKE_CLR_EN;
-	pla_ocp_write_byte(tp, PLA_CONFIG6, ocp_data);
+	pla_ocp_modify_byte(tp, PLA_CONFIG6, LANWAKE_CLR_EN, 0);
 
 	r8153_u1u2en(tp, false);
 	r8153_u2p3en(tp, false);
@@ -5032,8 +4741,6 @@ static void rtl8153_down(struct r8152 *tp)
 
 static void rtl8153b_up(struct r8152 *tp)
 {
-	u32 ocp_data;
-
 	if (test_bit(RTL8152_UNPLUG, &tp->flags))
 		return;
 
@@ -5044,9 +4751,7 @@ static void rtl8153b_up(struct r8152 *tp)
 	r8153_first_init(tp);
 	usb_ocp_write_dword(tp, USB_RX_BUF_TH, RX_THR_B);
 
-	ocp_data = pla_ocp_read_word(tp, PLA_MAC_PWR_CTRL3);
-	ocp_data &= ~PLA_MCU_SPDWN_EN;
-	pla_ocp_write_word(tp, PLA_MAC_PWR_CTRL3, ocp_data);
+	pla_ocp_modify_word(tp, PLA_MAC_PWR_CTRL3, PLA_MCU_SPDWN_EN, 0);
 
 	r8153_aldps_en(tp, true);
 
@@ -5056,16 +4761,12 @@ static void rtl8153b_up(struct r8152 *tp)
 
 static void rtl8153b_down(struct r8152 *tp)
 {
-	u32 ocp_data;
-
 	if (test_bit(RTL8152_UNPLUG, &tp->flags)) {
 		rtl_drop_queued_tx(tp);
 		return;
 	}
 
-	ocp_data = pla_ocp_read_word(tp, PLA_MAC_PWR_CTRL3);
-	ocp_data |= PLA_MCU_SPDWN_EN;
-	pla_ocp_write_word(tp, PLA_MAC_PWR_CTRL3, ocp_data);
+	pla_ocp_modify_word(tp, PLA_MAC_PWR_CTRL3, 0, PLA_MCU_SPDWN_EN);
 
 	r8153b_u1u2en(tp, false);
 	r8153_u2p3en(tp, false);
@@ -5327,60 +5028,40 @@ static int rtl8152_close(struct net_device *netdev)
 
 static void rtl_tally_reset(struct r8152 *tp)
 {
-	u32 ocp_data;
-
-	ocp_data = pla_ocp_read_word(tp, PLA_RSTTALLY);
-	ocp_data |= TALLY_RESET;
-	pla_ocp_write_word(tp, PLA_RSTTALLY, ocp_data);
+	pla_ocp_modify_word(tp, PLA_RSTTALLY, 0, TALLY_RESET);
 }
 
 static void r8152b_init(struct r8152 *tp)
 {
-	u32 ocp_data;
-	u16 data;
-
 	if (test_bit(RTL8152_UNPLUG, &tp->flags))
 		return;
 
-	data = r8152_mdio_read(tp, MII_BMCR);
-	if (data & BMCR_PDOWN) {
-		data &= ~BMCR_PDOWN;
-		r8152_mdio_write(tp, MII_BMCR, data);
-	}
+	r8152_mdio_modify(tp, MII_BMCR, BMCR_PDOWN, 0);
 
 	r8152_aldps_en(tp, false);
 
-	if (tp->version == RTL_VER_01) {
-		ocp_data = pla_ocp_read_word(tp, PLA_LED_FEATURE);
-		ocp_data &= ~LED_MODE_MASK;
-		pla_ocp_write_word(tp, PLA_LED_FEATURE, ocp_data);
-	}
+	if (tp->version == RTL_VER_01)
+		pla_ocp_modify_word(tp, PLA_LED_FEATURE, LED_MODE_MASK, 0);
 
 	r8152_power_cut_en(tp, false);
 
-	ocp_data = pla_ocp_read_word(tp, PLA_PHY_PWR);
-	ocp_data |= TX_10M_IDLE_EN | PFM_PWM_SWITCH;
-	pla_ocp_write_word(tp, PLA_PHY_PWR, ocp_data);
-	ocp_data = pla_ocp_read_dword(tp, PLA_MAC_PWR_CTRL);
-	ocp_data &= ~MCU_CLK_RATIO_MASK;
-	ocp_data |= MCU_CLK_RATIO | D3_CLK_GATED_EN;
-	pla_ocp_write_dword(tp, PLA_MAC_PWR_CTRL, ocp_data);
-	ocp_data = GPHY_STS_MSK | SPEED_DOWN_MSK |
-		   SPDWN_RXDV_MSK | SPDWN_LINKCHG_MSK;
-	pla_ocp_write_word(tp, PLA_GPHY_INTR_IMR, ocp_data);
+	pla_ocp_modify_word(tp, PLA_PHY_PWR, 0,
+			    TX_10M_IDLE_EN | PFM_PWM_SWITCH);
+	pla_ocp_modify_dword(tp, PLA_MAC_PWR_CTRL, MCU_CLK_RATIO_MASK,
+			     MCU_CLK_RATIO | D3_CLK_GATED_EN);
+	pla_ocp_write_word(tp, PLA_GPHY_INTR_IMR,
+			   GPHY_STS_MSK | SPEED_DOWN_MSK |
+			   SPDWN_RXDV_MSK | SPDWN_LINKCHG_MSK);
 
 	rtl_tally_reset(tp);
 
 	/* enable rx aggregation */
-	ocp_data = usb_ocp_read_word(tp, USB_USB_CTRL);
-	ocp_data &= ~(RX_AGG_DISABLE | RX_ZERO_EN);
-	usb_ocp_write_word(tp, USB_USB_CTRL, ocp_data);
+	usb_ocp_modify_word(tp, USB_USB_CTRL, RX_AGG_DISABLE | RX_ZERO_EN, 0);
 }
 
 static void r8153_init(struct r8152 *tp)
 {
-	u32 ocp_data;
-	u16 data;
+	u32 set;
 	int i;
 
 	if (test_bit(RTL8152_UNPLUG, &tp->flags))
@@ -5397,84 +5078,54 @@ static void r8153_init(struct r8152 *tp)
 			break;
 	}
 
-	data = r8153_phy_status_wait(tp, 0);
+	r8153_phy_status_wait(tp, 0);
 
 	if (tp->version == RTL_VER_03 || tp->version == RTL_VER_04 ||
 	    tp->version == RTL_VER_05)
 		ocp_reg_write(tp, OCP_ADC_CFG, CKADSEL_L | ADC_EN | EN_EMI_L);
 
-	data = r8152_mdio_read(tp, MII_BMCR);
-	if (data & BMCR_PDOWN) {
-		data &= ~BMCR_PDOWN;
-		r8152_mdio_write(tp, MII_BMCR, data);
-	}
+	r8152_mdio_modify(tp, MII_BMCR, BMCR_PDOWN, 0);
 
-	data = r8153_phy_status_wait(tp, PHY_STAT_LAN_ON);
+	r8153_phy_status_wait(tp, PHY_STAT_LAN_ON);
 
 	r8153_u2p3en(tp, false);
 
 	if (tp->version == RTL_VER_04) {
-		ocp_data = usb_ocp_read_word(tp, USB_SSPHYLINK2);
-		ocp_data &= ~pwd_dn_scale_mask;
-		ocp_data |= pwd_dn_scale(96);
-		usb_ocp_write_word(tp, USB_SSPHYLINK2, ocp_data);
-
-		ocp_data = usb_ocp_read_byte(tp, USB_USB2PHY);
-		ocp_data |= USB2PHY_L1 | USB2PHY_SUSPEND;
-		usb_ocp_write_byte(tp, USB_USB2PHY, ocp_data);
+		usb_ocp_modify_word(tp, USB_SSPHYLINK2, pwd_dn_scale_mask,
+				    pwd_dn_scale(96));
+		usb_ocp_modify_byte(tp, USB_USB2PHY, 0,
+				    USB2PHY_L1 | USB2PHY_SUSPEND);
 	} else if (tp->version == RTL_VER_05) {
-		ocp_data = pla_ocp_read_byte(tp, PLA_DMY_REG0);
-		ocp_data &= ~ECM_ALDPS;
-		pla_ocp_write_byte(tp, PLA_DMY_REG0, ocp_data);
+		pla_ocp_modify_byte(tp, PLA_DMY_REG0, ECM_ALDPS, 0);
 
-		ocp_data = usb_ocp_read_byte(tp, USB_CSR_DUMMY1);
-		if (usb_ocp_read_word(tp, USB_BURST_SIZE) == 0)
-			ocp_data &= ~DYNAMIC_BURST;
-		else
-			ocp_data |= DYNAMIC_BURST;
-		usb_ocp_write_byte(tp, USB_CSR_DUMMY1, ocp_data);
+		set = usb_ocp_read_word(tp, USB_BURST_SIZE) ? DYNAMIC_BURST : 0;
+		usb_ocp_modify_byte(tp, USB_CSR_DUMMY1, DYNAMIC_BURST, set);
 	} else if (tp->version == RTL_VER_06) {
-		ocp_data = usb_ocp_read_byte(tp, USB_CSR_DUMMY1);
-		if (usb_ocp_read_word(tp, USB_BURST_SIZE) == 0)
-			ocp_data &= ~DYNAMIC_BURST;
-		else
-			ocp_data |= DYNAMIC_BURST;
-		usb_ocp_write_byte(tp, USB_CSR_DUMMY1, ocp_data);
+		set = usb_ocp_read_word(tp, USB_BURST_SIZE) ? DYNAMIC_BURST : 0;
+		usb_ocp_modify_byte(tp, USB_CSR_DUMMY1, DYNAMIC_BURST, set);
 
 		r8153_queue_wake(tp, false);
 
-		ocp_data = pla_ocp_read_word(tp, PLA_EXTRA_STATUS);
+		set = POLL_LINK_CHG;
 		if (rtl8152_get_speed(tp) & LINK_STATUS)
-			ocp_data |= CUR_LINK_OK;
-		else
-			ocp_data &= ~CUR_LINK_OK;
-		ocp_data |= POLL_LINK_CHG;
-		pla_ocp_write_word(tp, PLA_EXTRA_STATUS, ocp_data);
+			set |= CUR_LINK_OK;
+		pla_ocp_modify_word(tp, PLA_EXTRA_STATUS, CUR_LINK_OK, set);
 	}
 
-	ocp_data = usb_ocp_read_byte(tp, USB_CSR_DUMMY2);
-	ocp_data |= EP4_FULL_FC;
-	usb_ocp_write_byte(tp, USB_CSR_DUMMY2, ocp_data);
-
-	ocp_data = usb_ocp_read_word(tp, USB_WDT11_CTRL);
-	ocp_data &= ~TIMER11_EN;
-	usb_ocp_write_word(tp, USB_WDT11_CTRL, ocp_data);
+	usb_ocp_modify_byte(tp, USB_CSR_DUMMY2, 0, EP4_FULL_FC);
+	usb_ocp_modify_word(tp, USB_WDT11_CTRL, TIMER11_EN, 0);
 
-	ocp_data = pla_ocp_read_word(tp, PLA_LED_FEATURE);
-	ocp_data &= ~LED_MODE_MASK;
-	pla_ocp_write_word(tp, PLA_LED_FEATURE, ocp_data);
+	pla_ocp_modify_word(tp, PLA_LED_FEATURE, LED_MODE_MASK, 0);
 
-	ocp_data = FIFO_EMPTY_1FB | ROK_EXIT_LPM;
+	set = FIFO_EMPTY_1FB | ROK_EXIT_LPM;
 	if (tp->version == RTL_VER_04 && tp->udev->speed < USB_SPEED_SUPER)
-		ocp_data |= LPM_TIMER_500MS;
+		set |= LPM_TIMER_500MS;
 	else
-		ocp_data |= LPM_TIMER_500US;
-	usb_ocp_write_byte(tp, USB_LPM_CTRL, ocp_data);
+		set |= LPM_TIMER_500US;
+	usb_ocp_write_byte(tp, USB_LPM_CTRL, set);
 
-	ocp_data = usb_ocp_read_word(tp, USB_AFE_CTRL2);
-	ocp_data &= ~SEN_VAL_MASK;
-	ocp_data |= SEN_VAL_NORMAL | SEL_RXIDLE;
-	usb_ocp_write_word(tp, USB_AFE_CTRL2, ocp_data);
+	usb_ocp_modify_word(tp, USB_AFE_CTRL2, SEN_VAL_MASK,
+			    SEN_VAL_NORMAL | SEL_RXIDLE);
 
 	usb_ocp_write_word(tp, USB_CONNECT_TIMER, 0x0001);
 
@@ -5484,21 +5135,13 @@ static void r8153_init(struct r8152 *tp)
 	r8153_mac_clk_spd(tp, false);
 	usb_enable_lpm(tp->udev);
 
-	ocp_data = pla_ocp_read_byte(tp, PLA_CONFIG6);
-	ocp_data |= LANWAKE_CLR_EN;
-	pla_ocp_write_byte(tp, PLA_CONFIG6, ocp_data);
-
-	ocp_data = pla_ocp_read_byte(tp, PLA_LWAKE_CTRL_REG);
-	ocp_data &= ~LANWAKE_PIN;
-	pla_ocp_write_byte(tp, PLA_LWAKE_CTRL_REG, ocp_data);
+	pla_ocp_modify_byte(tp, PLA_CONFIG6, 0, LANWAKE_CLR_EN);
+	pla_ocp_modify_byte(tp, PLA_LWAKE_CTRL_REG, LANWAKE_PIN, 0);
 
 	/* rx aggregation */
-	ocp_data = usb_ocp_read_word(tp, USB_USB_CTRL);
-	ocp_data &= ~(RX_AGG_DISABLE | RX_ZERO_EN);
-	if (test_bit(DELL_TB_RX_AGG_BUG, &tp->flags))
-		ocp_data |= RX_AGG_DISABLE;
-
-	usb_ocp_write_word(tp, USB_USB_CTRL, ocp_data);
+	usb_ocp_modify_word(tp, USB_USB_CTRL, RX_AGG_DISABLE | RX_ZERO_EN,
+			    test_bit(DELL_TB_RX_AGG_BUG, &tp->flags) ?
+				RX_AGG_DISABLE : 0);
 
 	rtl_tally_reset(tp);
 
@@ -5518,8 +5161,7 @@ static void r8153_init(struct r8152 *tp)
 
 static void r8153b_init(struct r8152 *tp)
 {
-	u32 ocp_data;
-	u16 data;
+	u32 set;
 	int i;
 
 	if (test_bit(RTL8152_UNPLUG, &tp->flags))
@@ -5536,15 +5178,11 @@ static void r8153b_init(struct r8152 *tp)
 			break;
 	}
 
-	data = r8153_phy_status_wait(tp, 0);
+	r8153_phy_status_wait(tp, 0);
 
-	data = r8152_mdio_read(tp, MII_BMCR);
-	if (data & BMCR_PDOWN) {
-		data &= ~BMCR_PDOWN;
-		r8152_mdio_write(tp, MII_BMCR, data);
-	}
+	r8152_mdio_modify(tp, MII_BMCR, BMCR_PDOWN, 0);
 
-	data = r8153_phy_status_wait(tp, PHY_STAT_LAN_ON);
+	r8153_phy_status_wait(tp, PHY_STAT_LAN_ON);
 
 	r8153_u2p3en(tp, false);
 
@@ -5559,42 +5197,30 @@ static void r8153b_init(struct r8152 *tp)
 	r8153_queue_wake(tp, false);
 	rtl_runtime_suspend_enable(tp, false);
 
-	ocp_data = pla_ocp_read_word(tp, PLA_EXTRA_STATUS);
+	set = POLL_LINK_CHG;
 	if (rtl8152_get_speed(tp) & LINK_STATUS)
-		ocp_data |= CUR_LINK_OK;
-	else
-		ocp_data &= ~CUR_LINK_OK;
-	ocp_data |= POLL_LINK_CHG;
-	pla_ocp_write_word(tp, PLA_EXTRA_STATUS, ocp_data);
+		set |= CUR_LINK_OK;
+	pla_ocp_modify_word(tp, PLA_EXTRA_STATUS, CUR_LINK_OK, set);
 
 	if (tp->udev->speed != USB_SPEED_HIGH)
 		r8153b_u1u2en(tp, true);
 	usb_enable_lpm(tp->udev);
 
 	/* MAC clock speed down */
-	ocp_data = pla_ocp_read_word(tp, PLA_MAC_PWR_CTRL2);
-	ocp_data |= MAC_CLK_SPDWN_EN;
-	pla_ocp_write_word(tp, PLA_MAC_PWR_CTRL2, ocp_data);
+	pla_ocp_modify_word(tp, PLA_MAC_PWR_CTRL2, 0, MAC_CLK_SPDWN_EN);
 
-	ocp_data = pla_ocp_read_word(tp, PLA_MAC_PWR_CTRL3);
-	ocp_data &= ~PLA_MCU_SPDWN_EN;
-	pla_ocp_write_word(tp, PLA_MAC_PWR_CTRL3, ocp_data);
+	pla_ocp_modify_word(tp, PLA_MAC_PWR_CTRL3, PLA_MCU_SPDWN_EN, 0);
 
 	if (tp->version == RTL_VER_09) {
 		/* Disable Test IO for 32QFN */
-		if (pla_ocp_read_byte(tp, 0xdc00) & BIT(5)) {
-			ocp_data = pla_ocp_read_word(tp, PLA_PHY_PWR);
-			ocp_data |= TEST_IO_OFF;
-			pla_ocp_write_word(tp, PLA_PHY_PWR, ocp_data);
-		}
+		if (pla_ocp_read_byte(tp, 0xdc00) & BIT(5))
+			pla_ocp_modify_word(tp, PLA_PHY_PWR, 0, TEST_IO_OFF);
 	}
 
 	set_bit(GREEN_ETHERNET, &tp->flags);
 
 	/* rx aggregation */
-	ocp_data = usb_ocp_read_word(tp, USB_USB_CTRL);
-	ocp_data &= ~(RX_AGG_DISABLE | RX_ZERO_EN);
-	usb_ocp_write_word(tp, USB_USB_CTRL, ocp_data);
+	usb_ocp_modify_word(tp, USB_USB_CTRL, RX_AGG_DISABLE | RX_ZERO_EN, 0);
 
 	rtl_tally_reset(tp);
 
@@ -6451,9 +6077,8 @@ static int rtl8152_change_mtu(struct net_device *dev, int new_mtu)
 	dev->mtu = new_mtu;
 
 	if (netif_running(dev)) {
-		u32 rms = new_mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
-
-		pla_ocp_write_word(tp, PLA_RMS, rms);
+		pla_ocp_write_word(tp, PLA_RMS,
+				   new_mtu + VLAN_ETH_HLEN + ETH_FCS_LEN);
 
 		if (netif_carrier_ok(dev))
 			r8153_set_rx_early_size(tp);
-- 
2.26.2

