Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744F92A5003
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729520AbgKCTWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:22:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:58382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbgKCTWi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 14:22:38 -0500
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1438722226;
        Tue,  3 Nov 2020 19:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604431354;
        bh=Go5WTMvG0t7hNYcHsjZbIcN1Uodb1I8GzBDsLquBOhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KKt4/1wLPbOdjqeHXXpxI9BbcCj+uJ32W2DCjojT3z7nT/M/K+vPbaxIjlRPBdTEp
         PLsnCaRn4NQE35xk7TQIT7MLgvI1MJ0c1ne8/4CSBe87+Pq+g8Uy7hzR1iUNMenn+E
         h1UWHHQw2uBnmtavfxPqW8gXZ3/QBVOllTM4dCP8=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 3/5] r8152: add MCU typed read/write functions
Date:   Tue,  3 Nov 2020 20:22:24 +0100
Message-Id: <20201103192226.2455-4-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103192226.2455-1-kabel@kernel.org>
References: <20201103192226.2455-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add pla_ and usb_ prefixed versions of ocp_read_* and ocp_write_*
functions. This saves us from always writing MCU_TYPE_PLA/MCU_TYPE_USB
as parameter.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/usb/r8152.c | 673 ++++++++++++++++++++--------------------
 1 file changed, 338 insertions(+), 335 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 96bef1c027f2..905859309db4 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1305,18 +1305,37 @@ static void ocp_write_byte(struct r8152 *tp, u16 type, u16 index, u32 data)
 	generic_ocp_write(tp, index, byen, sizeof(tmp), &tmp, type);
 }
 
+#define DEFINE_FUNCS_FOR_MCU_TYPE(_p, _mcutype, _t, _n)			\
+static inline _t _p ## _ocp_read_ ## _n(struct r8152 *tp, u16 index)	\
+{									\
+	return ocp_read_ ## _n(tp, _mcutype, index);			\
+}									\
+static inline void _p ## _ocp_write_ ## _n(struct r8152 *tp, u16 index,	\
+					   _t data)			\
+{									\
+	ocp_write_ ## _n(tp, _mcutype, index, data);			\
+}
+
+DEFINE_FUNCS_FOR_MCU_TYPE(pla, MCU_TYPE_PLA, u8, byte)
+DEFINE_FUNCS_FOR_MCU_TYPE(pla, MCU_TYPE_PLA, u16, word)
+DEFINE_FUNCS_FOR_MCU_TYPE(pla, MCU_TYPE_PLA, u32, dword)
+
+DEFINE_FUNCS_FOR_MCU_TYPE(usb, MCU_TYPE_USB, u8, byte)
+DEFINE_FUNCS_FOR_MCU_TYPE(usb, MCU_TYPE_USB, u16, word)
+DEFINE_FUNCS_FOR_MCU_TYPE(usb, MCU_TYPE_USB, u32, dword)
+
 static u16 ocp_reg_read(struct r8152 *tp, u16 addr)
 {
 	u16 ocp_base, ocp_index;
 
 	ocp_base = addr & 0xf000;
 	if (ocp_base != tp->ocp_base) {
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_OCP_GPHY_BASE, ocp_base);
+		pla_ocp_write_word(tp, PLA_OCP_GPHY_BASE, ocp_base);
 		tp->ocp_base = ocp_base;
 	}
 
 	ocp_index = (addr & 0x0fff) | 0xb000;
-	return ocp_read_word(tp, MCU_TYPE_PLA, ocp_index);
+	return pla_ocp_read_word(tp, ocp_index);
 }
 
 static void ocp_reg_write(struct r8152 *tp, u16 addr, u16 data)
@@ -1325,12 +1344,12 @@ static void ocp_reg_write(struct r8152 *tp, u16 addr, u16 data)
 
 	ocp_base = addr & 0xf000;
 	if (ocp_base != tp->ocp_base) {
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_OCP_GPHY_BASE, ocp_base);
+		pla_ocp_write_word(tp, PLA_OCP_GPHY_BASE, ocp_base);
 		tp->ocp_base = ocp_base;
 	}
 
 	ocp_index = (addr & 0x0fff) | 0xb000;
-	ocp_write_word(tp, MCU_TYPE_PLA, ocp_index, data);
+	pla_ocp_write_word(tp, ocp_index, data);
 }
 
 static inline void r8152_mdio_write(struct r8152 *tp, u32 reg_addr, u32 value)
@@ -1405,9 +1424,9 @@ static int rtl8152_set_mac_address(struct net_device *netdev, void *p)
 
 	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
 
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CRWECR, CRWECR_CONFIG);
+	pla_ocp_write_byte(tp, PLA_CRWECR, CRWECR_CONFIG);
 	pla_ocp_write(tp, PLA_IDR, BYTE_EN_SIX_BYTES, 8, addr->sa_data);
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CRWECR, CRWECR_NORAML);
+	pla_ocp_write_byte(tp, PLA_CRWECR, CRWECR_NORAML);
 
 	mutex_unlock(&tp->control);
 
@@ -1438,10 +1457,10 @@ static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
 		mac_strlen = 0x16;
 	} else {
 		/* test for -AD variant of RTL8153 */
-		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0);
+		ocp_data = usb_ocp_read_word(tp, USB_MISC_0);
 		if ((ocp_data & AD_MASK) == 0x1000) {
 			/* test for MAC address pass-through bit */
-			ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, EFUSE);
+			ocp_data = usb_ocp_read_byte(tp, EFUSE);
 			if ((ocp_data & PASS_THRU_MASK) != 1) {
 				netif_dbg(tp, probe, tp->netdev,
 						"No efuse for RTL8153-AD MAC pass through\n");
@@ -1449,7 +1468,7 @@ static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
 			}
 		} else {
 			/* test for RTL8153-BND and RTL8153-BD */
-			ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_MISC_1);
+			ocp_data = usb_ocp_read_byte(tp, USB_MISC_1);
 			if ((ocp_data & BND_MASK) == 0 && (ocp_data & BD_MASK) == 0) {
 				netif_dbg(tp, probe, tp->netdev,
 						"Invalid variant for MAC pass through\n");
@@ -2533,7 +2552,7 @@ static void _rtl8152_set_rx_mode(struct net_device *netdev)
 	u32 ocp_data;
 
 	netif_stop_queue(netdev);
-	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
+	ocp_data = pla_ocp_read_dword(tp, PLA_RCR);
 	ocp_data &= ~RCR_ACPT_ALL;
 	ocp_data |= RCR_AB | RCR_APM;
 
@@ -2566,7 +2585,7 @@ static void _rtl8152_set_rx_mode(struct net_device *netdev)
 	tmp[1] = __cpu_to_le32(swab32(mc_filter[0]));
 
 	pla_ocp_write(tp, PLA_MAR, BYTE_EN_DWORD, sizeof(tmp), tmp);
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, ocp_data);
+	pla_ocp_write_dword(tp, PLA_RCR, ocp_data);
 	netif_wake_queue(netdev);
 }
 
@@ -2614,21 +2633,21 @@ static void r8152b_reset_packet_filter(struct r8152 *tp)
 {
 	u32	ocp_data;
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_FMC);
+	ocp_data = pla_ocp_read_word(tp, PLA_FMC);
 	ocp_data &= ~FMC_FCR_MCU_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_FMC, ocp_data);
+	pla_ocp_write_word(tp, PLA_FMC, ocp_data);
 	ocp_data |= FMC_FCR_MCU_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_FMC, ocp_data);
+	pla_ocp_write_word(tp, PLA_FMC, ocp_data);
 }
 
 static void rtl8152_nic_reset(struct r8152 *tp)
 {
 	int	i;
 
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CR, CR_RST);
+	pla_ocp_write_byte(tp, PLA_CR, CR_RST);
 
 	for (i = 0; i < 1000; i++) {
-		if (!(ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CR) & CR_RST))
+		if (!(pla_ocp_read_byte(tp, PLA_CR) & CR_RST))
 			break;
 		usleep_range(100, 400);
 	}
@@ -2644,7 +2663,7 @@ static void set_tx_qlen(struct r8152 *tp)
 
 static inline u8 rtl8152_get_speed(struct r8152 *tp)
 {
-	return ocp_read_byte(tp, MCU_TYPE_PLA, PLA_PHYSTATUS);
+	return pla_ocp_read_byte(tp, PLA_PHYSTATUS);
 }
 
 static void rtl_set_eee_plus(struct r8152 *tp)
@@ -2654,13 +2673,13 @@ static void rtl_set_eee_plus(struct r8152 *tp)
 
 	speed = rtl8152_get_speed(tp);
 	if (speed & _10bps) {
-		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EEEP_CR);
+		ocp_data = pla_ocp_read_word(tp, PLA_EEEP_CR);
 		ocp_data |= EEEP_CR_EEEP_TX;
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_EEEP_CR, ocp_data);
+		pla_ocp_write_word(tp, PLA_EEEP_CR, ocp_data);
 	} else {
-		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EEEP_CR);
+		ocp_data = pla_ocp_read_word(tp, PLA_EEEP_CR);
 		ocp_data &= ~EEEP_CR_EEEP_TX;
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_EEEP_CR, ocp_data);
+		pla_ocp_write_word(tp, PLA_EEEP_CR, ocp_data);
 	}
 }
 
@@ -2668,12 +2687,12 @@ static void rxdy_gated_en(struct r8152 *tp, bool enable)
 {
 	u32 ocp_data;
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_MISC_1);
+	ocp_data = pla_ocp_read_word(tp, PLA_MISC_1);
 	if (enable)
 		ocp_data |= RXDY_GATED_EN;
 	else
 		ocp_data &= ~RXDY_GATED_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MISC_1, ocp_data);
+	pla_ocp_write_word(tp, PLA_MISC_1, ocp_data);
 }
 
 static int rtl_start_rx(struct r8152 *tp)
@@ -2761,8 +2780,7 @@ static int rtl_stop_rx(struct r8152 *tp)
 
 static inline void r8153b_rx_agg_chg_indicate(struct r8152 *tp)
 {
-	ocp_write_byte(tp, MCU_TYPE_USB, USB_UPT_RXDMA_OWN,
-		       OWN_UPDATE | OWN_CLEAR);
+	usb_ocp_write_byte(tp, USB_UPT_RXDMA_OWN, OWN_UPDATE | OWN_CLEAR);
 }
 
 static int rtl_enable(struct r8152 *tp)
@@ -2771,9 +2789,9 @@ static int rtl_enable(struct r8152 *tp)
 
 	r8152b_reset_packet_filter(tp);
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CR);
+	ocp_data = pla_ocp_read_byte(tp, PLA_CR);
 	ocp_data |= CR_RE | CR_TE;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CR, ocp_data);
+	pla_ocp_write_byte(tp, PLA_CR, ocp_data);
 
 	switch (tp->version) {
 	case RTL_VER_08:
@@ -2809,8 +2827,7 @@ static void r8153_set_rx_early_timeout(struct r8152 *tp)
 	case RTL_VER_04:
 	case RTL_VER_05:
 	case RTL_VER_06:
-		ocp_write_word(tp, MCU_TYPE_USB, USB_RX_EARLY_TIMEOUT,
-			       ocp_data);
+		usb_ocp_write_word(tp, USB_RX_EARLY_TIMEOUT, ocp_data);
 		break;
 
 	case RTL_VER_08:
@@ -2818,10 +2835,8 @@ static void r8153_set_rx_early_timeout(struct r8152 *tp)
 		/* The RTL8153B uses USB_RX_EXTRA_AGGR_TMR for rx timeout
 		 * primarily. For USB_RX_EARLY_TIMEOUT, we fix it to 128ns.
 		 */
-		ocp_write_word(tp, MCU_TYPE_USB, USB_RX_EARLY_TIMEOUT,
-			       128 / 8);
-		ocp_write_word(tp, MCU_TYPE_USB, USB_RX_EXTRA_AGGR_TMR,
-			       ocp_data);
+		usb_ocp_write_word(tp, USB_RX_EARLY_TIMEOUT, 128 / 8);
+		usb_ocp_write_word(tp, USB_RX_EXTRA_AGGR_TMR, ocp_data);
 		break;
 
 	default:
@@ -2838,13 +2853,11 @@ static void r8153_set_rx_early_size(struct r8152 *tp)
 	case RTL_VER_04:
 	case RTL_VER_05:
 	case RTL_VER_06:
-		ocp_write_word(tp, MCU_TYPE_USB, USB_RX_EARLY_SIZE,
-			       ocp_data / 4);
+		usb_ocp_write_word(tp, USB_RX_EARLY_SIZE, ocp_data / 4);
 		break;
 	case RTL_VER_08:
 	case RTL_VER_09:
-		ocp_write_word(tp, MCU_TYPE_USB, USB_RX_EARLY_SIZE,
-			       ocp_data / 8);
+		usb_ocp_write_word(tp, USB_RX_EARLY_SIZE, ocp_data / 8);
 		break;
 	default:
 		WARN_ON_ONCE(1);
@@ -2865,12 +2878,12 @@ static int rtl8153_enable(struct r8152 *tp)
 	if (tp->version == RTL_VER_09) {
 		u32 ocp_data;
 
-		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_TASK);
+		ocp_data = usb_ocp_read_word(tp, USB_FW_TASK);
 		ocp_data &= ~FC_PATCH_TASK;
-		ocp_write_word(tp, MCU_TYPE_USB, USB_FW_TASK, ocp_data);
+		usb_ocp_write_word(tp, USB_FW_TASK, ocp_data);
 		usleep_range(1000, 2000);
 		ocp_data |= FC_PATCH_TASK;
-		ocp_write_word(tp, MCU_TYPE_USB, USB_FW_TASK, ocp_data);
+		usb_ocp_write_word(tp, USB_FW_TASK, ocp_data);
 	}
 
 	return rtl_enable(tp);
@@ -2886,9 +2899,9 @@ static void rtl_disable(struct r8152 *tp)
 		return;
 	}
 
-	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
+	ocp_data = pla_ocp_read_dword(tp, PLA_RCR);
 	ocp_data &= ~RCR_ACPT_ALL;
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, ocp_data);
+	pla_ocp_write_dword(tp, PLA_RCR, ocp_data);
 
 	rtl_drop_queued_tx(tp);
 
@@ -2898,14 +2911,14 @@ static void rtl_disable(struct r8152 *tp)
 	rxdy_gated_en(tp, true);
 
 	for (i = 0; i < 1000; i++) {
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
+		ocp_data = pla_ocp_read_byte(tp, PLA_OOB_CTRL);
 		if ((ocp_data & FIFO_EMPTY) == FIFO_EMPTY)
 			break;
 		usleep_range(1000, 2000);
 	}
 
 	for (i = 0; i < 1000; i++) {
-		if (ocp_read_word(tp, MCU_TYPE_PLA, PLA_TCR0) & TCR0_TX_EMPTY)
+		if (pla_ocp_read_word(tp, PLA_TCR0) & TCR0_TX_EMPTY)
 			break;
 		usleep_range(1000, 2000);
 	}
@@ -2919,28 +2932,28 @@ static void r8152_power_cut_en(struct r8152 *tp, bool enable)
 {
 	u32 ocp_data;
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_UPS_CTRL);
+	ocp_data = usb_ocp_read_word(tp, USB_UPS_CTRL);
 	if (enable)
 		ocp_data |= POWER_CUT;
 	else
 		ocp_data &= ~POWER_CUT;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_UPS_CTRL, ocp_data);
+	usb_ocp_write_word(tp, USB_UPS_CTRL, ocp_data);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_PM_CTRL_STATUS);
+	ocp_data = usb_ocp_read_word(tp, USB_PM_CTRL_STATUS);
 	ocp_data &= ~RESUME_INDICATE;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_PM_CTRL_STATUS, ocp_data);
+	usb_ocp_write_word(tp, USB_PM_CTRL_STATUS, ocp_data);
 }
 
 static void rtl_rx_vlan_en(struct r8152 *tp, bool enable)
 {
 	u32 ocp_data;
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_CPCR);
+	ocp_data = pla_ocp_read_word(tp, PLA_CPCR);
 	if (enable)
 		ocp_data |= CPCR_RX_VLAN;
 	else
 		ocp_data &= ~CPCR_RX_VLAN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_CPCR, ocp_data);
+	pla_ocp_write_word(tp, PLA_CPCR, ocp_data);
 }
 
 static int rtl8152_set_features(struct net_device *dev,
@@ -2978,11 +2991,11 @@ static u32 __rtl_get_wol(struct r8152 *tp)
 	u32 ocp_data;
 	u32 wolopts = 0;
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_CONFIG34);
+	ocp_data = pla_ocp_read_word(tp, PLA_CONFIG34);
 	if (ocp_data & LINK_ON_WAKE_EN)
 		wolopts |= WAKE_PHY;
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_CONFIG5);
+	ocp_data = pla_ocp_read_word(tp, PLA_CONFIG5);
 	if (ocp_data & UWF_EN)
 		wolopts |= WAKE_UCAST;
 	if (ocp_data & BWF_EN)
@@ -2990,7 +3003,7 @@ static u32 __rtl_get_wol(struct r8152 *tp)
 	if (ocp_data & MWF_EN)
 		wolopts |= WAKE_MCAST;
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_CFG_WOL);
+	ocp_data = pla_ocp_read_word(tp, PLA_CFG_WOL);
 	if (ocp_data & MAGIC_EN)
 		wolopts |= WAKE_MAGIC;
 
@@ -3001,15 +3014,15 @@ static void __rtl_set_wol(struct r8152 *tp, u32 wolopts)
 {
 	u32 ocp_data;
 
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CRWECR, CRWECR_CONFIG);
+	pla_ocp_write_byte(tp, PLA_CRWECR, CRWECR_CONFIG);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_CONFIG34);
+	ocp_data = pla_ocp_read_word(tp, PLA_CONFIG34);
 	ocp_data &= ~LINK_ON_WAKE_EN;
 	if (wolopts & WAKE_PHY)
 		ocp_data |= LINK_ON_WAKE_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_CONFIG34, ocp_data);
+	pla_ocp_write_word(tp, PLA_CONFIG34, ocp_data);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_CONFIG5);
+	ocp_data = pla_ocp_read_word(tp, PLA_CONFIG5);
 	ocp_data &= ~(UWF_EN | BWF_EN | MWF_EN);
 	if (wolopts & WAKE_UCAST)
 		ocp_data |= UWF_EN;
@@ -3017,15 +3030,15 @@ static void __rtl_set_wol(struct r8152 *tp, u32 wolopts)
 		ocp_data |= BWF_EN;
 	if (wolopts & WAKE_MCAST)
 		ocp_data |= MWF_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_CONFIG5, ocp_data);
+	pla_ocp_write_word(tp, PLA_CONFIG5, ocp_data);
 
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CRWECR, CRWECR_NORAML);
+	pla_ocp_write_byte(tp, PLA_CRWECR, CRWECR_NORAML);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_CFG_WOL);
+	ocp_data = pla_ocp_read_word(tp, PLA_CFG_WOL);
 	ocp_data &= ~MAGIC_EN;
 	if (wolopts & WAKE_MAGIC)
 		ocp_data |= MAGIC_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_CFG_WOL, ocp_data);
+	pla_ocp_write_word(tp, PLA_CFG_WOL, ocp_data);
 
 	if (wolopts & WAKE_ANY)
 		device_set_wakeup_enable(&tp->udev->dev, true);
@@ -3037,22 +3050,21 @@ static void r8153_mac_clk_spd(struct r8152 *tp, bool enable)
 {
 	/* MAC clock speed down */
 	if (enable) {
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL,
-			       ALDPS_SPDWN_RATIO);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL2,
-			       EEE_SPDWN_RATIO);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3,
-			       PKT_AVAIL_SPDWN_EN | SUSPEND_SPDWN_EN |
-			       U1U2_SPDWN_EN | L1_SPDWN_EN);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL4,
-			       PWRSAVE_SPDWN_EN | RXDV_SPDWN_EN | TX10MIDLE_EN |
-			       TP100_SPDWN_EN | TP500_SPDWN_EN | EEE_SPDWN_EN |
-			       TP1000_SPDWN_EN);
+		pla_ocp_write_word(tp, PLA_MAC_PWR_CTRL, ALDPS_SPDWN_RATIO);
+		pla_ocp_write_word(tp, PLA_MAC_PWR_CTRL2, EEE_SPDWN_RATIO);
+		pla_ocp_write_word(tp, PLA_MAC_PWR_CTRL3,
+				   PKT_AVAIL_SPDWN_EN | SUSPEND_SPDWN_EN |
+				   U1U2_SPDWN_EN | L1_SPDWN_EN);
+		pla_ocp_write_word(tp, PLA_MAC_PWR_CTRL4,
+				   PWRSAVE_SPDWN_EN | RXDV_SPDWN_EN |
+				   TX10MIDLE_EN | TP100_SPDWN_EN |
+				   TP500_SPDWN_EN | EEE_SPDWN_EN |
+				   TP1000_SPDWN_EN);
 	} else {
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL, 0);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL2, 0);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3, 0);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL4, 0);
+		pla_ocp_write_word(tp, PLA_MAC_PWR_CTRL, 0);
+		pla_ocp_write_word(tp, PLA_MAC_PWR_CTRL2, 0);
+		pla_ocp_write_word(tp, PLA_MAC_PWR_CTRL3, 0);
+		pla_ocp_write_word(tp, PLA_MAC_PWR_CTRL4, 0);
 	}
 }
 
@@ -3072,25 +3084,25 @@ static void r8153b_u1u2en(struct r8152 *tp, bool enable)
 {
 	u32 ocp_data;
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_LPM_CONFIG);
+	ocp_data = usb_ocp_read_word(tp, USB_LPM_CONFIG);
 	if (enable)
 		ocp_data |= LPM_U1U2_EN;
 	else
 		ocp_data &= ~LPM_U1U2_EN;
 
-	ocp_write_word(tp, MCU_TYPE_USB, USB_LPM_CONFIG, ocp_data);
+	usb_ocp_write_word(tp, USB_LPM_CONFIG, ocp_data);
 }
 
 static void r8153_u2p3en(struct r8152 *tp, bool enable)
 {
 	u32 ocp_data;
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_U2P3_CTRL);
+	ocp_data = usb_ocp_read_word(tp, USB_U2P3_CTRL);
 	if (enable)
 		ocp_data |= U2P3_ENABLE;
 	else
 		ocp_data &= ~U2P3_ENABLE;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_U2P3_CTRL, ocp_data);
+	usb_ocp_write_word(tp, USB_U2P3_CTRL, ocp_data);
 }
 
 static void r8153b_ups_flags(struct r8152 *tp)
@@ -3162,7 +3174,7 @@ static void r8153b_ups_flags(struct r8152 *tp)
 		break;
 	}
 
-	ocp_write_dword(tp, MCU_TYPE_USB, USB_UPS_FLAGS, ups_flags);
+	usb_ocp_write_dword(tp, USB_UPS_FLAGS, ups_flags);
 }
 
 static void r8153b_green_en(struct r8152 *tp, bool enable)
@@ -3212,30 +3224,30 @@ static u16 r8153_phy_status(struct r8152 *tp, u16 desired)
 
 static void r8153b_ups_en(struct r8152 *tp, bool enable)
 {
-	u32 ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_POWER_CUT);
+	u32 ocp_data = usb_ocp_read_byte(tp, USB_POWER_CUT);
 
 	if (enable) {
 		r8153b_ups_flags(tp);
 
 		ocp_data |= UPS_EN | USP_PREWAKE | PHASE2_EN;
-		ocp_write_byte(tp, MCU_TYPE_USB, USB_POWER_CUT, ocp_data);
+		usb_ocp_write_byte(tp, USB_POWER_CUT, ocp_data);
 
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, 0xcfff);
+		ocp_data = usb_ocp_read_byte(tp, 0xcfff);
 		ocp_data |= BIT(0);
-		ocp_write_byte(tp, MCU_TYPE_USB, 0xcfff, ocp_data);
+		usb_ocp_write_byte(tp, 0xcfff, ocp_data);
 	} else {
 		u16 data;
 
 		ocp_data &= ~(UPS_EN | USP_PREWAKE);
-		ocp_write_byte(tp, MCU_TYPE_USB, USB_POWER_CUT, ocp_data);
+		usb_ocp_write_byte(tp, USB_POWER_CUT, ocp_data);
 
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, 0xcfff);
+		ocp_data = usb_ocp_read_byte(tp, 0xcfff);
 		ocp_data &= ~BIT(0);
-		ocp_write_byte(tp, MCU_TYPE_USB, 0xcfff, ocp_data);
+		usb_ocp_write_byte(tp, 0xcfff, ocp_data);
 
-		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0);
+		ocp_data = usb_ocp_read_word(tp, USB_MISC_0);
 		ocp_data &= ~PCUT_STATUS;
-		ocp_write_word(tp, MCU_TYPE_USB, USB_MISC_0, ocp_data);
+		usb_ocp_write_word(tp, USB_MISC_0, ocp_data);
 
 		data = r8153_phy_status(tp, 0);
 
@@ -3266,52 +3278,52 @@ static void r8153_power_cut_en(struct r8152 *tp, bool enable)
 {
 	u32 ocp_data;
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_POWER_CUT);
+	ocp_data = usb_ocp_read_word(tp, USB_POWER_CUT);
 	if (enable)
 		ocp_data |= PWR_EN | PHASE2_EN;
 	else
 		ocp_data &= ~(PWR_EN | PHASE2_EN);
-	ocp_write_word(tp, MCU_TYPE_USB, USB_POWER_CUT, ocp_data);
+	usb_ocp_write_word(tp, USB_POWER_CUT, ocp_data);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0);
+	ocp_data = usb_ocp_read_word(tp, USB_MISC_0);
 	ocp_data &= ~PCUT_STATUS;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_MISC_0, ocp_data);
+	usb_ocp_write_word(tp, USB_MISC_0, ocp_data);
 }
 
 static void r8153b_power_cut_en(struct r8152 *tp, bool enable)
 {
 	u32 ocp_data;
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_POWER_CUT);
+	ocp_data = usb_ocp_read_word(tp, USB_POWER_CUT);
 	if (enable)
 		ocp_data |= PWR_EN | PHASE2_EN;
 	else
 		ocp_data &= ~PWR_EN;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_POWER_CUT, ocp_data);
+	usb_ocp_write_word(tp, USB_POWER_CUT, ocp_data);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0);
+	ocp_data = usb_ocp_read_word(tp, USB_MISC_0);
 	ocp_data &= ~PCUT_STATUS;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_MISC_0, ocp_data);
+	usb_ocp_write_word(tp, USB_MISC_0, ocp_data);
 }
 
 static void r8153_queue_wake(struct r8152 *tp, bool enable)
 {
 	u32 ocp_data;
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_INDICATE_FALG);
+	ocp_data = pla_ocp_read_byte(tp, PLA_INDICATE_FALG);
 	if (enable)
 		ocp_data |= UPCOMING_RUNTIME_D3;
 	else
 		ocp_data &= ~UPCOMING_RUNTIME_D3;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_INDICATE_FALG, ocp_data);
+	pla_ocp_write_byte(tp, PLA_INDICATE_FALG, ocp_data);
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_SUSPEND_FLAG);
+	ocp_data = pla_ocp_read_byte(tp, PLA_SUSPEND_FLAG);
 	ocp_data &= ~LINK_CHG_EVENT;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_SUSPEND_FLAG, ocp_data);
+	pla_ocp_write_byte(tp, PLA_SUSPEND_FLAG, ocp_data);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS);
+	ocp_data = pla_ocp_read_word(tp, PLA_EXTRA_STATUS);
 	ocp_data &= ~LINK_CHANGE_FLAG;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS, ocp_data);
+	pla_ocp_write_word(tp, PLA_EXTRA_STATUS, ocp_data);
 }
 
 static bool rtl_can_wakeup(struct r8152 *tp)
@@ -3328,25 +3340,25 @@ static void rtl_runtime_suspend_enable(struct r8152 *tp, bool enable)
 
 		__rtl_set_wol(tp, WAKE_ANY);
 
-		ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CRWECR, CRWECR_CONFIG);
+		pla_ocp_write_byte(tp, PLA_CRWECR, CRWECR_CONFIG);
 
-		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_CONFIG34);
+		ocp_data = pla_ocp_read_word(tp, PLA_CONFIG34);
 		ocp_data |= LINK_OFF_WAKE_EN;
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_CONFIG34, ocp_data);
+		pla_ocp_write_word(tp, PLA_CONFIG34, ocp_data);
 
-		ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CRWECR, CRWECR_NORAML);
+		pla_ocp_write_byte(tp, PLA_CRWECR, CRWECR_NORAML);
 	} else {
 		u32 ocp_data;
 
 		__rtl_set_wol(tp, tp->saved_wolopts);
 
-		ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CRWECR, CRWECR_CONFIG);
+		pla_ocp_write_byte(tp, PLA_CRWECR, CRWECR_CONFIG);
 
-		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_CONFIG34);
+		ocp_data = pla_ocp_read_word(tp, PLA_CONFIG34);
 		ocp_data &= ~LINK_OFF_WAKE_EN;
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_CONFIG34, ocp_data);
+		pla_ocp_write_word(tp, PLA_CONFIG34, ocp_data);
 
-		ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CRWECR, CRWECR_NORAML);
+		pla_ocp_write_byte(tp, PLA_CRWECR, CRWECR_NORAML);
 	}
 }
 
@@ -3405,10 +3417,10 @@ static void r8153_teredo_off(struct r8152 *tp)
 	case RTL_VER_05:
 	case RTL_VER_06:
 	case RTL_VER_07:
-		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_TEREDO_CFG);
+		ocp_data = pla_ocp_read_word(tp, PLA_TEREDO_CFG);
 		ocp_data &= ~(TEREDO_SEL | TEREDO_RS_EVENT_MASK |
 			      OOB_TEREDO_EN);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_TEREDO_CFG, ocp_data);
+		pla_ocp_write_word(tp, PLA_TEREDO_CFG, ocp_data);
 		break;
 
 	case RTL_VER_08:
@@ -3416,27 +3428,27 @@ static void r8153_teredo_off(struct r8152 *tp)
 		/* The bit 0 ~ 7 are relative with teredo settings. They are
 		 * W1C (write 1 to clear), so set all 1 to disable it.
 		 */
-		ocp_write_byte(tp, MCU_TYPE_PLA, PLA_TEREDO_CFG, 0xff);
+		pla_ocp_write_byte(tp, PLA_TEREDO_CFG, 0xff);
 		break;
 
 	default:
 		break;
 	}
 
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_WDT6_CTRL, WDT6_SET_MODE);
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_REALWOW_TIMER, 0);
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_TEREDO_TIMER, 0);
+	pla_ocp_write_word(tp, PLA_WDT6_CTRL, WDT6_SET_MODE);
+	pla_ocp_write_word(tp, PLA_REALWOW_TIMER, 0);
+	pla_ocp_write_dword(tp, PLA_TEREDO_TIMER, 0);
 }
 
 static void rtl_reset_bmu(struct r8152 *tp)
 {
 	u32 ocp_data;
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_BMU_RESET);
+	ocp_data = usb_ocp_read_byte(tp, USB_BMU_RESET);
 	ocp_data &= ~(BMU_RESET_EP_IN | BMU_RESET_EP_OUT);
-	ocp_write_byte(tp, MCU_TYPE_USB, USB_BMU_RESET, ocp_data);
+	usb_ocp_write_byte(tp, USB_BMU_RESET, ocp_data);
 	ocp_data |= BMU_RESET_EP_IN | BMU_RESET_EP_OUT;
-	ocp_write_byte(tp, MCU_TYPE_USB, USB_BMU_RESET, ocp_data);
+	usb_ocp_write_byte(tp, USB_BMU_RESET, ocp_data);
 }
 
 /* Clear the bp to stop the firmware before loading a new one */
@@ -3457,18 +3469,18 @@ static void rtl_clear_bp(struct r8152 *tp, u16 type)
 	case RTL_VER_09:
 	default:
 		if (type == MCU_TYPE_USB) {
-			ocp_write_byte(tp, MCU_TYPE_USB, USB_BP2_EN, 0);
-
-			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_8, 0);
-			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_9, 0);
-			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_10, 0);
-			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_11, 0);
-			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_12, 0);
-			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_13, 0);
-			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_14, 0);
-			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_15, 0);
+			usb_ocp_write_byte(tp, USB_BP2_EN, 0);
+
+			usb_ocp_write_word(tp, USB_BP_8, 0);
+			usb_ocp_write_word(tp, USB_BP_9, 0);
+			usb_ocp_write_word(tp, USB_BP_10, 0);
+			usb_ocp_write_word(tp, USB_BP_11, 0);
+			usb_ocp_write_word(tp, USB_BP_12, 0);
+			usb_ocp_write_word(tp, USB_BP_13, 0);
+			usb_ocp_write_word(tp, USB_BP_14, 0);
+			usb_ocp_write_word(tp, USB_BP_15, 0);
 		} else {
-			ocp_write_byte(tp, MCU_TYPE_PLA, PLA_BP_EN, 0);
+			pla_ocp_write_byte(tp, PLA_BP_EN, 0);
 		}
 		break;
 	}
@@ -3541,7 +3553,7 @@ static int r8153_post_ram_code(struct r8152 *tp, u16 key_addr)
 
 	r8153_patch_request(tp, false);
 
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_OCP_GPHY_BASE, tp->ocp_base);
+	pla_ocp_write_word(tp, PLA_OCP_GPHY_BASE, tp->ocp_base);
 
 	return 0;
 }
@@ -3987,9 +3999,9 @@ static void rtl8152_fw_mac_apply(struct r8152 *tp, struct fw_mac *mac)
 	 * break points and before applying the PLA firmware.
 	 */
 	if (tp->version == RTL_VER_04 && type == MCU_TYPE_PLA &&
-	    !(ocp_read_word(tp, MCU_TYPE_PLA, PLA_MACDBG_POST) & DEBUG_OE)) {
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MACDBG_PRE, DEBUG_LTSSM);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MACDBG_POST, DEBUG_LTSSM);
+	    !(pla_ocp_read_word(tp, PLA_MACDBG_POST) & DEBUG_OE)) {
+		pla_ocp_write_word(tp, PLA_MACDBG_PRE, DEBUG_LTSSM);
+		pla_ocp_write_word(tp, PLA_MACDBG_POST, DEBUG_LTSSM);
 	}
 
 	length = __le32_to_cpu(mac->blk_hdr.length);
@@ -4018,8 +4030,7 @@ static void rtl8152_fw_mac_apply(struct r8152 *tp, struct fw_mac *mac)
 
 	fw_ver_reg = __le16_to_cpu(mac->fw_ver_reg);
 	if (fw_ver_reg)
-		ocp_write_byte(tp, MCU_TYPE_USB, fw_ver_reg,
-			       mac->fw_ver_data);
+		usb_ocp_write_byte(tp, fw_ver_reg, mac->fw_ver_data);
 
 	dev_dbg(&tp->intf->dev, "successfully applied %s\n", mac->info);
 }
@@ -4163,7 +4174,7 @@ static void r8152_eee_en(struct r8152 *tp, bool enable)
 	u16 config1, config2, config3;
 	u32 ocp_data;
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EEE_CR);
+	ocp_data = pla_ocp_read_word(tp, PLA_EEE_CR);
 	config1 = ocp_reg_read(tp, OCP_EEE_CONFIG1) & ~sd_rise_time_mask;
 	config2 = ocp_reg_read(tp, OCP_EEE_CONFIG2);
 	config3 = ocp_reg_read(tp, OCP_EEE_CONFIG3) & ~fast_snr_mask;
@@ -4183,7 +4194,7 @@ static void r8152_eee_en(struct r8152 *tp, bool enable)
 		config3 |= fast_snr(511);
 	}
 
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EEE_CR, ocp_data);
+	pla_ocp_write_word(tp, PLA_EEE_CR, ocp_data);
 	ocp_reg_write(tp, OCP_EEE_CONFIG1, config1);
 	ocp_reg_write(tp, OCP_EEE_CONFIG2, config2);
 	ocp_reg_write(tp, OCP_EEE_CONFIG3, config3);
@@ -4194,7 +4205,7 @@ static void r8153_eee_en(struct r8152 *tp, bool enable)
 	u32 ocp_data;
 	u16 config;
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EEE_CR);
+	ocp_data = pla_ocp_read_word(tp, PLA_EEE_CR);
 	config = ocp_reg_read(tp, OCP_EEE_CFG);
 
 	if (enable) {
@@ -4205,7 +4216,7 @@ static void r8153_eee_en(struct r8152 *tp, bool enable)
 		config &= ~EEE10_EN;
 	}
 
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EEE_CR, ocp_data);
+	pla_ocp_write_word(tp, PLA_EEE_CR, ocp_data);
 	ocp_reg_write(tp, OCP_EEE_CFG, config);
 
 	tp->ups_info.eee = enable;
@@ -4279,7 +4290,7 @@ static void wait_oob_link_list_ready(struct r8152 *tp)
 	int i;
 
 	for (i = 0; i < 1000; i++) {
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
+		ocp_data = pla_ocp_read_byte(tp, PLA_OOB_CTRL);
 		if (ocp_data & LINK_LIST_READY)
 			break;
 		usleep_range(1000, 2000);
@@ -4290,107 +4301,103 @@ static void r8152b_exit_oob(struct r8152 *tp)
 {
 	u32 ocp_data;
 
-	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
+	ocp_data = pla_ocp_read_dword(tp, PLA_RCR);
 	ocp_data &= ~RCR_ACPT_ALL;
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, ocp_data);
+	pla_ocp_write_dword(tp, PLA_RCR, ocp_data);
 
 	rxdy_gated_en(tp, true);
 	r8153_teredo_off(tp);
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CRWECR, CRWECR_NORAML);
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CR, 0x00);
+	pla_ocp_write_byte(tp, PLA_CRWECR, CRWECR_NORAML);
+	pla_ocp_write_byte(tp, PLA_CR, 0x00);
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
+	ocp_data = pla_ocp_read_byte(tp, PLA_OOB_CTRL);
 	ocp_data &= ~NOW_IS_OOB;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
+	pla_ocp_write_byte(tp, PLA_OOB_CTRL, ocp_data);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
+	ocp_data = pla_ocp_read_word(tp, PLA_SFF_STS_7);
 	ocp_data &= ~MCU_BORW_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
+	pla_ocp_write_word(tp, PLA_SFF_STS_7, ocp_data);
 
 	wait_oob_link_list_ready(tp);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
+	ocp_data = pla_ocp_read_word(tp, PLA_SFF_STS_7);
 	ocp_data |= RE_INIT_LL;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
+	pla_ocp_write_word(tp, PLA_SFF_STS_7, ocp_data);
 
 	wait_oob_link_list_ready(tp);
 
 	rtl8152_nic_reset(tp);
 
 	/* rx share fifo credit full threshold */
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL0, RXFIFO_THR1_NORMAL);
+	pla_ocp_write_dword(tp, PLA_RXFIFO_CTRL0, RXFIFO_THR1_NORMAL);
 
 	if (tp->udev->speed == USB_SPEED_FULL ||
 	    tp->udev->speed == USB_SPEED_LOW) {
 		/* rx share fifo credit near full threshold */
-		ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL1,
-				RXFIFO_THR2_FULL);
-		ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL2,
-				RXFIFO_THR3_FULL);
+		pla_ocp_write_dword(tp, PLA_RXFIFO_CTRL1, RXFIFO_THR2_FULL);
+		pla_ocp_write_dword(tp, PLA_RXFIFO_CTRL2, RXFIFO_THR3_FULL);
 	} else {
 		/* rx share fifo credit near full threshold */
-		ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL1,
-				RXFIFO_THR2_HIGH);
-		ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL2,
-				RXFIFO_THR3_HIGH);
+		pla_ocp_write_dword(tp, PLA_RXFIFO_CTRL1, RXFIFO_THR2_HIGH);
+		pla_ocp_write_dword(tp, PLA_RXFIFO_CTRL2, RXFIFO_THR3_HIGH);
 	}
 
 	/* TX share fifo free credit full threshold */
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_TXFIFO_CTRL, TXFIFO_THR_NORMAL);
+	pla_ocp_write_dword(tp, PLA_TXFIFO_CTRL, TXFIFO_THR_NORMAL);
 
-	ocp_write_byte(tp, MCU_TYPE_USB, USB_TX_AGG, TX_AGG_MAX_THRESHOLD);
-	ocp_write_dword(tp, MCU_TYPE_USB, USB_RX_BUF_TH, RX_THR_HIGH);
-	ocp_write_dword(tp, MCU_TYPE_USB, USB_TX_DMA,
-			TEST_MODE_DISABLE | TX_SIZE_ADJUST1);
+	usb_ocp_write_byte(tp, USB_TX_AGG, TX_AGG_MAX_THRESHOLD);
+	usb_ocp_write_dword(tp, USB_RX_BUF_TH, RX_THR_HIGH);
+	usb_ocp_write_dword(tp, USB_TX_DMA,
+			    TEST_MODE_DISABLE | TX_SIZE_ADJUST1);
 
 	rtl_rx_vlan_en(tp, tp->netdev->features & NETIF_F_HW_VLAN_CTAG_RX);
 
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, RTL8152_RMS);
+	pla_ocp_write_word(tp, PLA_RMS, RTL8152_RMS);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_TCR0);
+	ocp_data = pla_ocp_read_word(tp, PLA_TCR0);
 	ocp_data |= TCR0_AUTO_FIFO;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_TCR0, ocp_data);
+	pla_ocp_write_word(tp, PLA_TCR0, ocp_data);
 }
 
 static void r8152b_enter_oob(struct r8152 *tp)
 {
 	u32 ocp_data;
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
+	ocp_data = pla_ocp_read_byte(tp, PLA_OOB_CTRL);
 	ocp_data &= ~NOW_IS_OOB;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
+	pla_ocp_write_byte(tp, PLA_OOB_CTRL, ocp_data);
 
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL0, RXFIFO_THR1_OOB);
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL1, RXFIFO_THR2_OOB);
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL2, RXFIFO_THR3_OOB);
+	pla_ocp_write_dword(tp, PLA_RXFIFO_CTRL0, RXFIFO_THR1_OOB);
+	pla_ocp_write_dword(tp, PLA_RXFIFO_CTRL1, RXFIFO_THR2_OOB);
+	pla_ocp_write_dword(tp, PLA_RXFIFO_CTRL2, RXFIFO_THR3_OOB);
 
 	rtl_disable(tp);
 
 	wait_oob_link_list_ready(tp);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
+	ocp_data = pla_ocp_read_word(tp, PLA_SFF_STS_7);
 	ocp_data |= RE_INIT_LL;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
+	pla_ocp_write_word(tp, PLA_SFF_STS_7, ocp_data);
 
 	wait_oob_link_list_ready(tp);
 
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, RTL8152_RMS);
+	pla_ocp_write_word(tp, PLA_RMS, RTL8152_RMS);
 
 	rtl_rx_vlan_en(tp, true);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_BDC_CR);
+	ocp_data = pla_ocp_read_word(tp, PLA_BDC_CR);
 	ocp_data |= ALDPS_PROXY_MODE;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_BDC_CR, ocp_data);
+	pla_ocp_write_word(tp, PLA_BDC_CR, ocp_data);
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
+	ocp_data = pla_ocp_read_byte(tp, PLA_OOB_CTRL);
 	ocp_data |= NOW_IS_OOB | DIS_MCU_CLROOB;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
+	pla_ocp_write_byte(tp, PLA_OOB_CTRL, ocp_data);
 
 	rxdy_gated_en(tp, false);
 
-	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
+	ocp_data = pla_ocp_read_dword(tp, PLA_RCR);
 	ocp_data |= RCR_APM | RCR_AM | RCR_AB;
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, ocp_data);
+	pla_ocp_write_dword(tp, PLA_RCR, ocp_data);
 }
 
 static int r8153_pre_firmware_1(struct r8152 *tp)
@@ -4399,7 +4406,7 @@ static int r8153_pre_firmware_1(struct r8152 *tp)
 
 	/* Wait till the WTD timer is ready. It would take at most 104 ms. */
 	for (i = 0; i < 104; i++) {
-		u32 ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_WDT1_CTRL);
+		u32 ocp_data = usb_ocp_read_byte(tp, USB_WDT1_CTRL);
 
 		if (!(ocp_data & WTD1_EN))
 			break;
@@ -4412,11 +4419,11 @@ static int r8153_pre_firmware_1(struct r8152 *tp)
 static int r8153_post_firmware_1(struct r8152 *tp)
 {
 	/* set USB_BP_4 to support USB_SPEED_SUPER only */
-	if (ocp_read_byte(tp, MCU_TYPE_USB, USB_CSTMR) & FORCE_SUPER)
-		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_4, BP4_SUPER_ONLY);
+	if (usb_ocp_read_byte(tp, USB_CSTMR) & FORCE_SUPER)
+		usb_ocp_write_word(tp, USB_BP_4, BP4_SUPER_ONLY);
 
 	/* reset UPHY timer to 36 ms */
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_UPHY_TIMER, 36000 / 16);
+	pla_ocp_write_word(tp, PLA_UPHY_TIMER, 36000 / 16);
 
 	return 0;
 }
@@ -4427,9 +4434,9 @@ static int r8153_pre_firmware_2(struct r8152 *tp)
 
 	r8153_pre_firmware_1(tp);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN0);
+	ocp_data = usb_ocp_read_word(tp, USB_FW_FIX_EN0);
 	ocp_data &= ~FW_FIX_SUSPEND;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN0, ocp_data);
+	usb_ocp_write_word(tp, USB_FW_FIX_EN0, ocp_data);
 
 	return 0;
 }
@@ -4439,25 +4446,25 @@ static int r8153_post_firmware_2(struct r8152 *tp)
 	u32 ocp_data;
 
 	/* enable bp0 if support USB_SPEED_SUPER only */
-	if (ocp_read_byte(tp, MCU_TYPE_USB, USB_CSTMR) & FORCE_SUPER) {
-		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_BP_EN);
+	if (usb_ocp_read_byte(tp, USB_CSTMR) & FORCE_SUPER) {
+		ocp_data = pla_ocp_read_word(tp, PLA_BP_EN);
 		ocp_data |= BIT(0);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_EN, ocp_data);
+		pla_ocp_write_word(tp, PLA_BP_EN, ocp_data);
 	}
 
 	/* reset UPHY timer to 36 ms */
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_UPHY_TIMER, 36000 / 16);
+	pla_ocp_write_word(tp, PLA_UPHY_TIMER, 36000 / 16);
 
 	/* enable U3P3 check, set the counter to 4 */
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS, U3P3_CHECK_EN | 4);
+	pla_ocp_write_word(tp, PLA_EXTRA_STATUS, U3P3_CHECK_EN | 4);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN0);
+	ocp_data = usb_ocp_read_word(tp, USB_FW_FIX_EN0);
 	ocp_data |= FW_FIX_SUSPEND;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN0, ocp_data);
+	usb_ocp_write_word(tp, USB_FW_FIX_EN0, ocp_data);
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_USB2PHY);
+	ocp_data = usb_ocp_read_byte(tp, USB_USB2PHY);
 	ocp_data |= USB2PHY_L1 | USB2PHY_SUSPEND;
-	ocp_write_byte(tp, MCU_TYPE_USB, USB_USB2PHY, ocp_data);
+	usb_ocp_write_byte(tp, USB_USB2PHY, ocp_data);
 
 	return 0;
 }
@@ -4466,13 +4473,13 @@ static int r8153_post_firmware_3(struct r8152 *tp)
 {
 	u32 ocp_data;
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_USB2PHY);
+	ocp_data = usb_ocp_read_byte(tp, USB_USB2PHY);
 	ocp_data |= USB2PHY_L1 | USB2PHY_SUSPEND;
-	ocp_write_byte(tp, MCU_TYPE_USB, USB_USB2PHY, ocp_data);
+	usb_ocp_write_byte(tp, USB_USB2PHY, ocp_data);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1);
+	ocp_data = usb_ocp_read_word(tp, USB_FW_FIX_EN1);
 	ocp_data |= FW_IP_RESET_EN;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1, ocp_data);
+	usb_ocp_write_word(tp, USB_FW_FIX_EN1, ocp_data);
 
 	return 0;
 }
@@ -4480,8 +4487,7 @@ static int r8153_post_firmware_3(struct r8152 *tp)
 static int r8153b_pre_firmware_1(struct r8152 *tp)
 {
 	/* enable fc timer and set timer to 1 second. */
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FC_TIMER,
-		       CTRL_TIMER_EN | (1000 / 8));
+	usb_ocp_write_word(tp, USB_FC_TIMER, CTRL_TIMER_EN | (1000 / 8));
 
 	return 0;
 }
@@ -4491,24 +4497,24 @@ static int r8153b_post_firmware_1(struct r8152 *tp)
 	u32 ocp_data;
 
 	/* enable bp0 for RTL8153-BND */
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_MISC_1);
+	ocp_data = usb_ocp_read_byte(tp, USB_MISC_1);
 	if (ocp_data & BND_MASK) {
-		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_BP_EN);
+		ocp_data = pla_ocp_read_word(tp, PLA_BP_EN);
 		ocp_data |= BIT(0);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_EN, ocp_data);
+		pla_ocp_write_word(tp, PLA_BP_EN, ocp_data);
 	}
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_CTRL);
+	ocp_data = usb_ocp_read_word(tp, USB_FW_CTRL);
 	ocp_data |= FLOW_CTRL_PATCH_OPT;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_CTRL, ocp_data);
+	usb_ocp_write_word(tp, USB_FW_CTRL, ocp_data);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_TASK);
+	ocp_data = usb_ocp_read_word(tp, USB_FW_TASK);
 	ocp_data |= FC_PATCH_TASK;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_TASK, ocp_data);
+	usb_ocp_write_word(tp, USB_FW_TASK, ocp_data);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1);
+	ocp_data = usb_ocp_read_word(tp, USB_FW_FIX_EN1);
 	ocp_data |= FW_IP_RESET_EN;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1, ocp_data);
+	usb_ocp_write_word(tp, USB_FW_FIX_EN1, ocp_data);
 
 	return 0;
 }
@@ -4528,7 +4534,7 @@ static void r8153_aldps_en(struct r8152 *tp, bool enable)
 		ocp_reg_write(tp, OCP_POWER_CFG, data);
 		for (i = 0; i < 20; i++) {
 			usleep_range(1000, 2000);
-			if (ocp_read_word(tp, MCU_TYPE_PLA, 0xe000) & 0x0100)
+			if (pla_ocp_read_word(tp, 0xe000) & 0x0100)
 				break;
 		}
 	}
@@ -4567,9 +4573,9 @@ static void r8153_hw_phy_cfg(struct r8152 *tp)
 	ocp_reg_write(tp, OCP_POWER_CFG, data);
 	sram_write(tp, SRAM_IMPEDANCE, 0x0b13);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR);
+	ocp_data = pla_ocp_read_word(tp, PLA_PHY_PWR);
 	ocp_data |= PFM_PWM_SWITCH;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR, ocp_data);
+	pla_ocp_write_word(tp, PLA_PHY_PWR, ocp_data);
 
 	/* Enable LPF corner auto tune */
 	sram_write(tp, SRAM_LPF_CFG, 0xf70f);
@@ -4602,10 +4608,10 @@ static u32 r8152_efuse_read(struct r8152 *tp, u8 addr)
 {
 	u32 ocp_data;
 
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EFUSE_CMD, EFUSE_READ_CMD | addr);
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EFUSE_CMD);
+	pla_ocp_write_word(tp, PLA_EFUSE_CMD, EFUSE_READ_CMD | addr);
+	ocp_data = pla_ocp_read_word(tp, PLA_EFUSE_CMD);
 	ocp_data = (ocp_data & EFUSE_DATA_BIT16) << 9;	/* data of bit16 */
-	ocp_data |= ocp_read_word(tp, MCU_TYPE_PLA, PLA_EFUSE_DATA);
+	ocp_data |= pla_ocp_read_word(tp, PLA_EFUSE_DATA);
 
 	return ocp_data;
 }
@@ -4652,14 +4658,14 @@ static void r8153b_hw_phy_cfg(struct r8152 *tp)
 		u32 swr_cnt_1ms_ini;
 
 		swr_cnt_1ms_ini = (16000000 / ocp_data) & SAW_CNT_1MS_MASK;
-		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_UPS_CFG);
+		ocp_data = usb_ocp_read_word(tp, USB_UPS_CFG);
 		ocp_data = (ocp_data & ~SAW_CNT_1MS_MASK) | swr_cnt_1ms_ini;
-		ocp_write_word(tp, MCU_TYPE_USB, USB_UPS_CFG, ocp_data);
+		usb_ocp_write_word(tp, USB_UPS_CFG, ocp_data);
 	}
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR);
+	ocp_data = pla_ocp_read_word(tp, PLA_PHY_PWR);
 	ocp_data |= PFM_PWM_SWITCH;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR, ocp_data);
+	pla_ocp_write_word(tp, PLA_PHY_PWR, ocp_data);
 
 	/* Advnace EEE */
 	if (!r8153_patch_request(tp, true)) {
@@ -4699,47 +4705,47 @@ static void r8153_first_init(struct r8152 *tp)
 	rxdy_gated_en(tp, true);
 	r8153_teredo_off(tp);
 
-	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
+	ocp_data = pla_ocp_read_dword(tp, PLA_RCR);
 	ocp_data &= ~RCR_ACPT_ALL;
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, ocp_data);
+	pla_ocp_write_dword(tp, PLA_RCR, ocp_data);
 
 	rtl8152_nic_reset(tp);
 	rtl_reset_bmu(tp);
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
+	ocp_data = pla_ocp_read_byte(tp, PLA_OOB_CTRL);
 	ocp_data &= ~NOW_IS_OOB;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
+	pla_ocp_write_byte(tp, PLA_OOB_CTRL, ocp_data);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
+	ocp_data = pla_ocp_read_word(tp, PLA_SFF_STS_7);
 	ocp_data &= ~MCU_BORW_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
+	pla_ocp_write_word(tp, PLA_SFF_STS_7, ocp_data);
 
 	wait_oob_link_list_ready(tp);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
+	ocp_data = pla_ocp_read_word(tp, PLA_SFF_STS_7);
 	ocp_data |= RE_INIT_LL;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
+	pla_ocp_write_word(tp, PLA_SFF_STS_7, ocp_data);
 
 	wait_oob_link_list_ready(tp);
 
 	rtl_rx_vlan_en(tp, tp->netdev->features & NETIF_F_HW_VLAN_CTAG_RX);
 
 	ocp_data = tp->netdev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, ocp_data);
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_MTPS, MTPS_JUMBO);
+	pla_ocp_write_word(tp, PLA_RMS, ocp_data);
+	pla_ocp_write_byte(tp, PLA_MTPS, MTPS_JUMBO);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_TCR0);
+	ocp_data = pla_ocp_read_word(tp, PLA_TCR0);
 	ocp_data |= TCR0_AUTO_FIFO;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_TCR0, ocp_data);
+	pla_ocp_write_word(tp, PLA_TCR0, ocp_data);
 
 	rtl8152_nic_reset(tp);
 
 	/* rx share fifo credit full threshold */
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL0, RXFIFO_THR1_NORMAL);
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL1, RXFIFO_THR2_NORMAL);
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL2, RXFIFO_THR3_NORMAL);
+	pla_ocp_write_dword(tp, PLA_RXFIFO_CTRL0, RXFIFO_THR1_NORMAL);
+	pla_ocp_write_word(tp, PLA_RXFIFO_CTRL1, RXFIFO_THR2_NORMAL);
+	pla_ocp_write_word(tp, PLA_RXFIFO_CTRL2, RXFIFO_THR3_NORMAL);
 	/* TX share fifo free credit full threshold */
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_TXFIFO_CTRL, TXFIFO_THR_NORMAL2);
+	pla_ocp_write_dword(tp, PLA_TXFIFO_CTRL, TXFIFO_THR_NORMAL2);
 }
 
 static void r8153_enter_oob(struct r8152 *tp)
@@ -4748,32 +4754,32 @@ static void r8153_enter_oob(struct r8152 *tp)
 
 	r8153_mac_clk_spd(tp, true);
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
+	ocp_data = pla_ocp_read_byte(tp, PLA_OOB_CTRL);
 	ocp_data &= ~NOW_IS_OOB;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
+	pla_ocp_write_byte(tp, PLA_OOB_CTRL, ocp_data);
 
 	rtl_disable(tp);
 	rtl_reset_bmu(tp);
 
 	wait_oob_link_list_ready(tp);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
+	ocp_data = pla_ocp_read_word(tp, PLA_SFF_STS_7);
 	ocp_data |= RE_INIT_LL;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
+	pla_ocp_write_word(tp, PLA_SFF_STS_7, ocp_data);
 
 	wait_oob_link_list_ready(tp);
 
 	ocp_data = tp->netdev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, ocp_data);
+	pla_ocp_write_word(tp, PLA_RMS, ocp_data);
 
 	switch (tp->version) {
 	case RTL_VER_03:
 	case RTL_VER_04:
 	case RTL_VER_05:
 	case RTL_VER_06:
-		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_TEREDO_CFG);
+		ocp_data = pla_ocp_read_word(tp, PLA_TEREDO_CFG);
 		ocp_data &= ~TEREDO_WAKE_MASK;
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_TEREDO_CFG, ocp_data);
+		pla_ocp_write_word(tp, PLA_TEREDO_CFG, ocp_data);
 		break;
 
 	case RTL_VER_08:
@@ -4782,7 +4788,7 @@ static void r8153_enter_oob(struct r8152 *tp)
 		 * type. Set it to zero. bits[7:0] are the W1C bits about
 		 * the events. Set them to all 1 to clear them.
 		 */
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_TEREDO_WAKE_BASE, 0x00ff);
+		pla_ocp_write_word(tp, PLA_TEREDO_WAKE_BASE, 0x00ff);
 		break;
 
 	default:
@@ -4791,19 +4797,19 @@ static void r8153_enter_oob(struct r8152 *tp)
 
 	rtl_rx_vlan_en(tp, true);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_BDC_CR);
+	ocp_data = pla_ocp_read_word(tp, PLA_BDC_CR);
 	ocp_data |= ALDPS_PROXY_MODE;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_BDC_CR, ocp_data);
+	pla_ocp_write_word(tp, PLA_BDC_CR, ocp_data);
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
+	ocp_data = pla_ocp_read_byte(tp, PLA_OOB_CTRL);
 	ocp_data |= NOW_IS_OOB | DIS_MCU_CLROOB;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
+	pla_ocp_write_byte(tp, PLA_OOB_CTRL, ocp_data);
 
 	rxdy_gated_en(tp, false);
 
-	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
+	ocp_data = pla_ocp_read_dword(tp, PLA_RCR);
 	ocp_data |= RCR_APM | RCR_AM | RCR_AB;
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, ocp_data);
+	pla_ocp_write_dword(tp, PLA_RCR, ocp_data);
 }
 
 static void rtl8153_disable(struct r8152 *tp)
@@ -4975,17 +4981,17 @@ static void rtl8153_up(struct r8152 *tp)
 	r8153_aldps_en(tp, false);
 	r8153_first_init(tp);
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6);
+	ocp_data = pla_ocp_read_byte(tp, PLA_CONFIG6);
 	ocp_data |= LANWAKE_CLR_EN;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6, ocp_data);
+	pla_ocp_write_byte(tp, PLA_CONFIG6, ocp_data);
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_LWAKE_CTRL_REG);
+	ocp_data = pla_ocp_read_byte(tp, PLA_LWAKE_CTRL_REG);
 	ocp_data &= ~LANWAKE_PIN;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_LWAKE_CTRL_REG, ocp_data);
+	pla_ocp_write_byte(tp, PLA_LWAKE_CTRL_REG, ocp_data);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_SSPHYLINK1);
+	ocp_data = usb_ocp_read_word(tp, USB_SSPHYLINK1);
 	ocp_data &= ~DELAY_PHY_PWR_CHG;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_SSPHYLINK1, ocp_data);
+	usb_ocp_write_word(tp, USB_SSPHYLINK1, ocp_data);
 
 	r8153_aldps_en(tp, true);
 
@@ -5012,9 +5018,9 @@ static void rtl8153_down(struct r8152 *tp)
 		return;
 	}
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6);
+	ocp_data = pla_ocp_read_byte(tp, PLA_CONFIG6);
 	ocp_data &= ~LANWAKE_CLR_EN;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6, ocp_data);
+	pla_ocp_write_byte(tp, PLA_CONFIG6, ocp_data);
 
 	r8153_u1u2en(tp, false);
 	r8153_u2p3en(tp, false);
@@ -5036,11 +5042,11 @@ static void rtl8153b_up(struct r8152 *tp)
 	r8153_aldps_en(tp, false);
 
 	r8153_first_init(tp);
-	ocp_write_dword(tp, MCU_TYPE_USB, USB_RX_BUF_TH, RX_THR_B);
+	usb_ocp_write_dword(tp, USB_RX_BUF_TH, RX_THR_B);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3);
+	ocp_data = pla_ocp_read_word(tp, PLA_MAC_PWR_CTRL3);
 	ocp_data &= ~PLA_MCU_SPDWN_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3, ocp_data);
+	pla_ocp_write_word(tp, PLA_MAC_PWR_CTRL3, ocp_data);
 
 	r8153_aldps_en(tp, true);
 
@@ -5057,9 +5063,9 @@ static void rtl8153b_down(struct r8152 *tp)
 		return;
 	}
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3);
+	ocp_data = pla_ocp_read_word(tp, PLA_MAC_PWR_CTRL3);
 	ocp_data |= PLA_MCU_SPDWN_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3, ocp_data);
+	pla_ocp_write_word(tp, PLA_MAC_PWR_CTRL3, ocp_data);
 
 	r8153b_u1u2en(tp, false);
 	r8153_u2p3en(tp, false);
@@ -5073,10 +5079,10 @@ static bool rtl8152_in_nway(struct r8152 *tp)
 {
 	u16 nway_state;
 
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_OCP_GPHY_BASE, 0x2000);
+	pla_ocp_write_word(tp, PLA_OCP_GPHY_BASE, 0x2000);
 	tp->ocp_base = 0x2000;
-	ocp_write_byte(tp, MCU_TYPE_PLA, 0xb014, 0x4c);		/* phy state */
-	nway_state = ocp_read_word(tp, MCU_TYPE_PLA, 0xb01a);
+	pla_ocp_write_byte(tp, 0xb014, 0x4c);		/* phy state */
+	nway_state = pla_ocp_read_word(tp, 0xb01a);
 
 	/* bit 15: TXDIS_STATE, bit 14: ABD_STATE */
 	if (nway_state & 0xc000)
@@ -5323,9 +5329,9 @@ static void rtl_tally_reset(struct r8152 *tp)
 {
 	u32 ocp_data;
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_RSTTALLY);
+	ocp_data = pla_ocp_read_word(tp, PLA_RSTTALLY);
 	ocp_data |= TALLY_RESET;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RSTTALLY, ocp_data);
+	pla_ocp_write_word(tp, PLA_RSTTALLY, ocp_data);
 }
 
 static void r8152b_init(struct r8152 *tp)
@@ -5345,30 +5351,30 @@ static void r8152b_init(struct r8152 *tp)
 	r8152_aldps_en(tp, false);
 
 	if (tp->version == RTL_VER_01) {
-		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_LED_FEATURE);
+		ocp_data = pla_ocp_read_word(tp, PLA_LED_FEATURE);
 		ocp_data &= ~LED_MODE_MASK;
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_LED_FEATURE, ocp_data);
+		pla_ocp_write_word(tp, PLA_LED_FEATURE, ocp_data);
 	}
 
 	r8152_power_cut_en(tp, false);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR);
+	ocp_data = pla_ocp_read_word(tp, PLA_PHY_PWR);
 	ocp_data |= TX_10M_IDLE_EN | PFM_PWM_SWITCH;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR, ocp_data);
-	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL);
+	pla_ocp_write_word(tp, PLA_PHY_PWR, ocp_data);
+	ocp_data = pla_ocp_read_dword(tp, PLA_MAC_PWR_CTRL);
 	ocp_data &= ~MCU_CLK_RATIO_MASK;
 	ocp_data |= MCU_CLK_RATIO | D3_CLK_GATED_EN;
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL, ocp_data);
+	pla_ocp_write_dword(tp, PLA_MAC_PWR_CTRL, ocp_data);
 	ocp_data = GPHY_STS_MSK | SPEED_DOWN_MSK |
 		   SPDWN_RXDV_MSK | SPDWN_LINKCHG_MSK;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_GPHY_INTR_IMR, ocp_data);
+	pla_ocp_write_word(tp, PLA_GPHY_INTR_IMR, ocp_data);
 
 	rtl_tally_reset(tp);
 
 	/* enable rx aggregation */
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_USB_CTRL);
+	ocp_data = usb_ocp_read_word(tp, USB_USB_CTRL);
 	ocp_data &= ~(RX_AGG_DISABLE | RX_ZERO_EN);
-	ocp_write_word(tp, MCU_TYPE_USB, USB_USB_CTRL, ocp_data);
+	usb_ocp_write_word(tp, USB_USB_CTRL, ocp_data);
 }
 
 static void r8153_init(struct r8152 *tp)
@@ -5383,8 +5389,7 @@ static void r8153_init(struct r8152 *tp)
 	r8153_u1u2en(tp, false);
 
 	for (i = 0; i < 500; i++) {
-		if (ocp_read_word(tp, MCU_TYPE_PLA, PLA_BOOT_CTRL) &
-		    AUTOLOAD_DONE)
+		if (pla_ocp_read_word(tp, PLA_BOOT_CTRL) & AUTOLOAD_DONE)
 			break;
 
 		msleep(20);
@@ -5409,69 +5414,69 @@ static void r8153_init(struct r8152 *tp)
 	r8153_u2p3en(tp, false);
 
 	if (tp->version == RTL_VER_04) {
-		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_SSPHYLINK2);
+		ocp_data = usb_ocp_read_word(tp, USB_SSPHYLINK2);
 		ocp_data &= ~pwd_dn_scale_mask;
 		ocp_data |= pwd_dn_scale(96);
-		ocp_write_word(tp, MCU_TYPE_USB, USB_SSPHYLINK2, ocp_data);
+		usb_ocp_write_word(tp, USB_SSPHYLINK2, ocp_data);
 
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_USB2PHY);
+		ocp_data = usb_ocp_read_byte(tp, USB_USB2PHY);
 		ocp_data |= USB2PHY_L1 | USB2PHY_SUSPEND;
-		ocp_write_byte(tp, MCU_TYPE_USB, USB_USB2PHY, ocp_data);
+		usb_ocp_write_byte(tp, USB_USB2PHY, ocp_data);
 	} else if (tp->version == RTL_VER_05) {
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_DMY_REG0);
+		ocp_data = pla_ocp_read_byte(tp, PLA_DMY_REG0);
 		ocp_data &= ~ECM_ALDPS;
-		ocp_write_byte(tp, MCU_TYPE_PLA, PLA_DMY_REG0, ocp_data);
+		pla_ocp_write_byte(tp, PLA_DMY_REG0, ocp_data);
 
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_CSR_DUMMY1);
-		if (ocp_read_word(tp, MCU_TYPE_USB, USB_BURST_SIZE) == 0)
+		ocp_data = usb_ocp_read_byte(tp, USB_CSR_DUMMY1);
+		if (usb_ocp_read_word(tp, USB_BURST_SIZE) == 0)
 			ocp_data &= ~DYNAMIC_BURST;
 		else
 			ocp_data |= DYNAMIC_BURST;
-		ocp_write_byte(tp, MCU_TYPE_USB, USB_CSR_DUMMY1, ocp_data);
+		usb_ocp_write_byte(tp, USB_CSR_DUMMY1, ocp_data);
 	} else if (tp->version == RTL_VER_06) {
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_CSR_DUMMY1);
-		if (ocp_read_word(tp, MCU_TYPE_USB, USB_BURST_SIZE) == 0)
+		ocp_data = usb_ocp_read_byte(tp, USB_CSR_DUMMY1);
+		if (usb_ocp_read_word(tp, USB_BURST_SIZE) == 0)
 			ocp_data &= ~DYNAMIC_BURST;
 		else
 			ocp_data |= DYNAMIC_BURST;
-		ocp_write_byte(tp, MCU_TYPE_USB, USB_CSR_DUMMY1, ocp_data);
+		usb_ocp_write_byte(tp, USB_CSR_DUMMY1, ocp_data);
 
 		r8153_queue_wake(tp, false);
 
-		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS);
+		ocp_data = pla_ocp_read_word(tp, PLA_EXTRA_STATUS);
 		if (rtl8152_get_speed(tp) & LINK_STATUS)
 			ocp_data |= CUR_LINK_OK;
 		else
 			ocp_data &= ~CUR_LINK_OK;
 		ocp_data |= POLL_LINK_CHG;
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS, ocp_data);
+		pla_ocp_write_word(tp, PLA_EXTRA_STATUS, ocp_data);
 	}
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_CSR_DUMMY2);
+	ocp_data = usb_ocp_read_byte(tp, USB_CSR_DUMMY2);
 	ocp_data |= EP4_FULL_FC;
-	ocp_write_byte(tp, MCU_TYPE_USB, USB_CSR_DUMMY2, ocp_data);
+	usb_ocp_write_byte(tp, USB_CSR_DUMMY2, ocp_data);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_WDT11_CTRL);
+	ocp_data = usb_ocp_read_word(tp, USB_WDT11_CTRL);
 	ocp_data &= ~TIMER11_EN;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_WDT11_CTRL, ocp_data);
+	usb_ocp_write_word(tp, USB_WDT11_CTRL, ocp_data);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_LED_FEATURE);
+	ocp_data = pla_ocp_read_word(tp, PLA_LED_FEATURE);
 	ocp_data &= ~LED_MODE_MASK;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_LED_FEATURE, ocp_data);
+	pla_ocp_write_word(tp, PLA_LED_FEATURE, ocp_data);
 
 	ocp_data = FIFO_EMPTY_1FB | ROK_EXIT_LPM;
 	if (tp->version == RTL_VER_04 && tp->udev->speed < USB_SPEED_SUPER)
 		ocp_data |= LPM_TIMER_500MS;
 	else
 		ocp_data |= LPM_TIMER_500US;
-	ocp_write_byte(tp, MCU_TYPE_USB, USB_LPM_CTRL, ocp_data);
+	usb_ocp_write_byte(tp, USB_LPM_CTRL, ocp_data);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_AFE_CTRL2);
+	ocp_data = usb_ocp_read_word(tp, USB_AFE_CTRL2);
 	ocp_data &= ~SEN_VAL_MASK;
 	ocp_data |= SEN_VAL_NORMAL | SEL_RXIDLE;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_AFE_CTRL2, ocp_data);
+	usb_ocp_write_word(tp, USB_AFE_CTRL2, ocp_data);
 
-	ocp_write_word(tp, MCU_TYPE_USB, USB_CONNECT_TIMER, 0x0001);
+	usb_ocp_write_word(tp, USB_CONNECT_TIMER, 0x0001);
 
 	r8153_power_cut_en(tp, false);
 	rtl_runtime_suspend_enable(tp, false);
@@ -5479,21 +5484,21 @@ static void r8153_init(struct r8152 *tp)
 	r8153_mac_clk_spd(tp, false);
 	usb_enable_lpm(tp->udev);
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6);
+	ocp_data = pla_ocp_read_byte(tp, PLA_CONFIG6);
 	ocp_data |= LANWAKE_CLR_EN;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6, ocp_data);
+	pla_ocp_write_byte(tp, PLA_CONFIG6, ocp_data);
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_LWAKE_CTRL_REG);
+	ocp_data = pla_ocp_read_byte(tp, PLA_LWAKE_CTRL_REG);
 	ocp_data &= ~LANWAKE_PIN;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_LWAKE_CTRL_REG, ocp_data);
+	pla_ocp_write_byte(tp, PLA_LWAKE_CTRL_REG, ocp_data);
 
 	/* rx aggregation */
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_USB_CTRL);
+	ocp_data = usb_ocp_read_word(tp, USB_USB_CTRL);
 	ocp_data &= ~(RX_AGG_DISABLE | RX_ZERO_EN);
 	if (test_bit(DELL_TB_RX_AGG_BUG, &tp->flags))
 		ocp_data |= RX_AGG_DISABLE;
 
-	ocp_write_word(tp, MCU_TYPE_USB, USB_USB_CTRL, ocp_data);
+	usb_ocp_write_word(tp, USB_USB_CTRL, ocp_data);
 
 	rtl_tally_reset(tp);
 
@@ -5523,8 +5528,7 @@ static void r8153b_init(struct r8152 *tp)
 	r8153b_u1u2en(tp, false);
 
 	for (i = 0; i < 500; i++) {
-		if (ocp_read_word(tp, MCU_TYPE_PLA, PLA_BOOT_CTRL) &
-		    AUTOLOAD_DONE)
+		if (pla_ocp_read_word(tp, PLA_BOOT_CTRL) & AUTOLOAD_DONE)
 			break;
 
 		msleep(20);
@@ -5545,52 +5549,52 @@ static void r8153b_init(struct r8152 *tp)
 	r8153_u2p3en(tp, false);
 
 	/* MSC timer = 0xfff * 8ms = 32760 ms */
-	ocp_write_word(tp, MCU_TYPE_USB, USB_MSC_TIMER, 0x0fff);
+	usb_ocp_write_word(tp, USB_MSC_TIMER, 0x0fff);
 
 	/* U1/U2/L1 idle timer. 500 us */
-	ocp_write_word(tp, MCU_TYPE_USB, USB_U1U2_TIMER, 500);
+	usb_ocp_write_word(tp, USB_U1U2_TIMER, 500);
 
 	r8153b_power_cut_en(tp, false);
 	r8153b_ups_en(tp, false);
 	r8153_queue_wake(tp, false);
 	rtl_runtime_suspend_enable(tp, false);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS);
+	ocp_data = pla_ocp_read_word(tp, PLA_EXTRA_STATUS);
 	if (rtl8152_get_speed(tp) & LINK_STATUS)
 		ocp_data |= CUR_LINK_OK;
 	else
 		ocp_data &= ~CUR_LINK_OK;
 	ocp_data |= POLL_LINK_CHG;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS, ocp_data);
+	pla_ocp_write_word(tp, PLA_EXTRA_STATUS, ocp_data);
 
 	if (tp->udev->speed != USB_SPEED_HIGH)
 		r8153b_u1u2en(tp, true);
 	usb_enable_lpm(tp->udev);
 
 	/* MAC clock speed down */
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL2);
+	ocp_data = pla_ocp_read_word(tp, PLA_MAC_PWR_CTRL2);
 	ocp_data |= MAC_CLK_SPDWN_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL2, ocp_data);
+	pla_ocp_write_word(tp, PLA_MAC_PWR_CTRL2, ocp_data);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3);
+	ocp_data = pla_ocp_read_word(tp, PLA_MAC_PWR_CTRL3);
 	ocp_data &= ~PLA_MCU_SPDWN_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3, ocp_data);
+	pla_ocp_write_word(tp, PLA_MAC_PWR_CTRL3, ocp_data);
 
 	if (tp->version == RTL_VER_09) {
 		/* Disable Test IO for 32QFN */
-		if (ocp_read_byte(tp, MCU_TYPE_PLA, 0xdc00) & BIT(5)) {
-			ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR);
+		if (pla_ocp_read_byte(tp, 0xdc00) & BIT(5)) {
+			ocp_data = pla_ocp_read_word(tp, PLA_PHY_PWR);
 			ocp_data |= TEST_IO_OFF;
-			ocp_write_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR, ocp_data);
+			pla_ocp_write_word(tp, PLA_PHY_PWR, ocp_data);
 		}
 	}
 
 	set_bit(GREEN_ETHERNET, &tp->flags);
 
 	/* rx aggregation */
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_USB_CTRL);
+	ocp_data = usb_ocp_read_word(tp, USB_USB_CTRL);
 	ocp_data &= ~(RX_AGG_DISABLE | RX_ZERO_EN);
-	ocp_write_word(tp, MCU_TYPE_USB, USB_USB_CTRL, ocp_data);
+	usb_ocp_write_word(tp, USB_USB_CTRL, ocp_data);
 
 	rtl_tally_reset(tp);
 
@@ -5756,15 +5760,14 @@ static int rtl8152_runtime_suspend(struct r8152 *tp)
 		if (netif_carrier_ok(netdev)) {
 			u32 ocp_data;
 
-			rcr = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
+			rcr = pla_ocp_read_dword(tp, PLA_RCR);
 			ocp_data = rcr & ~RCR_ACPT_ALL;
-			ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, ocp_data);
+			pla_ocp_write_dword(tp, PLA_RCR, ocp_data);
 			rxdy_gated_en(tp, true);
-			ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA,
-						 PLA_OOB_CTRL);
+			ocp_data = pla_ocp_read_byte(tp, PLA_OOB_CTRL);
 			if (!(ocp_data & RXFIFO_EMPTY)) {
 				rxdy_gated_en(tp, false);
-				ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, rcr);
+				pla_ocp_write_dword(tp, PLA_RCR, rcr);
 				clear_bit(SELECTIVE_SUSPEND, &tp->flags);
 				smp_mb__after_atomic();
 				ret = -EBUSY;
@@ -5783,7 +5786,7 @@ static int rtl8152_runtime_suspend(struct r8152 *tp)
 			napi_disable(napi);
 			rtl_stop_rx(tp);
 			rxdy_gated_en(tp, false);
-			ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, rcr);
+			pla_ocp_write_dword(tp, PLA_RCR, rcr);
 			napi_enable(napi);
 		}
 
@@ -6450,7 +6453,7 @@ static int rtl8152_change_mtu(struct net_device *dev, int new_mtu)
 	if (netif_running(dev)) {
 		u32 rms = new_mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
 
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, rms);
+		pla_ocp_write_word(tp, PLA_RMS, rms);
 
 		if (netif_carrier_ok(dev))
 			r8153_set_rx_early_size(tp);
-- 
2.26.2

