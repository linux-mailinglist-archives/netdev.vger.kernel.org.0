Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409D930B6B6
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 05:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbhBBEvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 23:51:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34301 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbhBBEtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 23:49:09 -0500
Received: from 36-229-239-87.dynamic-ip.hinet.net ([36.229.239.87] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1l6nbu-0003Ag-GN; Tue, 02 Feb 2021 04:48:19 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        nic_swsd@realtek.com (maintainer:8169 10/100/1000 GIGABIT ETHERNET
        DRIVER), "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:8169 10/100/1000 GIGABIT ETHERNET
        DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] r8169: Add support for another RTL8168FP
Date:   Tue,  2 Feb 2021 12:48:12 +0800
Message-Id: <20210202044813.1304266-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the vendor driver, the new chip with XID 0x54b is
essentially the same as the one with XID 0x54a, but it doesn't need the
firmware.

So add support accordingly.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v2:
 - Add phy support.
 - Rebase on net-next.

 drivers/net/ethernet/realtek/r8169.h            |  1 +
 drivers/net/ethernet/realtek/r8169_main.c       | 17 +++++++++++------
 drivers/net/ethernet/realtek/r8169_phy_config.c |  1 +
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
index 7be86ef5a584..2728df46ec41 100644
--- a/drivers/net/ethernet/realtek/r8169.h
+++ b/drivers/net/ethernet/realtek/r8169.h
@@ -63,6 +63,7 @@ enum mac_version {
 	RTL_GIGA_MAC_VER_50,
 	RTL_GIGA_MAC_VER_51,
 	RTL_GIGA_MAC_VER_52,
+	RTL_GIGA_MAC_VER_53,
 	RTL_GIGA_MAC_VER_60,
 	RTL_GIGA_MAC_VER_61,
 	RTL_GIGA_MAC_VER_63,
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 475e6f01ea10..48697ec36e55 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -146,6 +146,7 @@ static const struct {
 	[RTL_GIGA_MAC_VER_50] = {"RTL8168ep/8111ep"			},
 	[RTL_GIGA_MAC_VER_51] = {"RTL8168ep/8111ep"			},
 	[RTL_GIGA_MAC_VER_52] = {"RTL8168fp/RTL8117",  FIRMWARE_8168FP_3},
+	[RTL_GIGA_MAC_VER_53] = {"RTL8168fp/RTL8117",			},
 	[RTL_GIGA_MAC_VER_60] = {"RTL8125A"				},
 	[RTL_GIGA_MAC_VER_61] = {"RTL8125A",		FIRMWARE_8125A_3},
 	/* reserve 62 for CFG_METHOD_4 in the vendor driver */
@@ -696,7 +697,7 @@ static bool rtl_is_8168evl_up(struct rtl8169_private *tp)
 {
 	return tp->mac_version >= RTL_GIGA_MAC_VER_34 &&
 	       tp->mac_version != RTL_GIGA_MAC_VER_39 &&
-	       tp->mac_version <= RTL_GIGA_MAC_VER_52;
+	       tp->mac_version <= RTL_GIGA_MAC_VER_53;
 }
 
 static bool rtl_supports_eee(struct rtl8169_private *tp)
@@ -763,7 +764,9 @@ static bool name ## _check(struct rtl8169_private *tp)
 static void r8168fp_adjust_ocp_cmd(struct rtl8169_private *tp, u32 *cmd, int type)
 {
 	/* based on RTL8168FP_OOBMAC_BASE in vendor driver */
-	if (tp->mac_version == RTL_GIGA_MAC_VER_52 && type == ERIAR_OOB)
+	if (type == ERIAR_OOB &&
+	    (tp->mac_version == RTL_GIGA_MAC_VER_52 ||
+	     tp->mac_version == RTL_GIGA_MAC_VER_53))
 		*cmd |= 0x7f0 << 18;
 }
 
@@ -1238,7 +1241,7 @@ static enum rtl_dash_type rtl_check_dash(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_28:
 	case RTL_GIGA_MAC_VER_31:
 		return r8168dp_check_dash(tp) ? RTL_DASH_DP : RTL_DASH_NONE;
-	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_52:
+	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_53:
 		return r8168ep_check_dash(tp) ? RTL_DASH_EP : RTL_DASH_NONE;
 	default:
 		return RTL_DASH_NONE;
@@ -1962,6 +1965,7 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
 		{ 0x7c8, 0x608,	RTL_GIGA_MAC_VER_61 },
 
 		/* RTL8117 */
+		{ 0x7cf, 0x54b,	RTL_GIGA_MAC_VER_53 },
 		{ 0x7cf, 0x54a,	RTL_GIGA_MAC_VER_52 },
 
 		/* 8168EP family. */
@@ -2236,7 +2240,7 @@ static void rtl_init_rxcfg(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_38:
 		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST);
 		break;
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_52:
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_53:
 		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST | RX_EARLY_OFF);
 		break;
 	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
@@ -2410,7 +2414,7 @@ DECLARE_RTL_COND(rtl_rxtx_empty_cond_2)
 static void rtl_wait_txrx_fifo_empty(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_52:
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_53:
 		rtl_loop_wait_high(tp, &rtl_txcfg_empty_cond, 100, 42);
 		rtl_loop_wait_high(tp, &rtl_rxtx_empty_cond, 100, 42);
 		break;
@@ -3669,6 +3673,7 @@ static void rtl_hw_config(struct rtl8169_private *tp)
 		[RTL_GIGA_MAC_VER_50] = rtl_hw_start_8168ep_2,
 		[RTL_GIGA_MAC_VER_51] = rtl_hw_start_8168ep_3,
 		[RTL_GIGA_MAC_VER_52] = rtl_hw_start_8117,
+		[RTL_GIGA_MAC_VER_53] = rtl_hw_start_8117,
 		[RTL_GIGA_MAC_VER_60] = rtl_hw_start_8125a_1,
 		[RTL_GIGA_MAC_VER_61] = rtl_hw_start_8125a_2,
 		[RTL_GIGA_MAC_VER_63] = rtl_hw_start_8125b,
@@ -5055,7 +5060,7 @@ static void rtl_hw_init_8125(struct rtl8169_private *tp)
 static void rtl_hw_initialize(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_52:
+	case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_53:
 		rtl8168ep_stop_cmac(tp);
 		fallthrough;
 	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_48:
diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index 913d030d73eb..50f0f621b1aa 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -1358,6 +1358,7 @@ void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
 		[RTL_GIGA_MAC_VER_50] = rtl8168ep_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_51] = rtl8168ep_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_52] = rtl8117_hw_phy_config,
+		[RTL_GIGA_MAC_VER_53] = rtl8117_hw_phy_config,
 		[RTL_GIGA_MAC_VER_60] = rtl8125a_1_hw_phy_config,
 		[RTL_GIGA_MAC_VER_61] = rtl8125a_2_hw_phy_config,
 		[RTL_GIGA_MAC_VER_63] = rtl8125b_hw_phy_config,
-- 
2.29.2

