Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4E733E3E6
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbhCQA5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:57:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231434AbhCQA5E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2344864FB4;
        Wed, 17 Mar 2021 00:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942623;
        bh=nWky4vFhQDdYKpN9K8dl5nP1GlaeP8D4IR9UQnpH4kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gOAsSURciJCxiFER1/S4svNmt7yeXjfaEKxESfaRzKRE7+nZD4fCKAfMneLEj5Irt
         edVAFt4Ezfa18NTBTsbgevs1kHaAfxqvJFv+sqx9MiSLFTsAGoNG+J/Gnk6gNz+4wT
         X0xJ4cb+C0FogMG5vWTS8FyuGKcqHO47oHa7VIhVU45i2A8EzI7MOutLV8P5DTu/gT
         8uUBogUmlLesSeYnt1eb6ENDedJ9PZ6f1zahjtJuhxWjRCBvNfM8cYfK8o0OILz7OK
         DEF42/zOn471LWuQFVq65oXEBy24zuKP2JLlNuM58gw/tPEZw/YJ8YBgA3iL4eO6a5
         2ZSDv4kbOjICA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hayes Wang <hayeswang@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/54] Revert "r8152: adjust the settings about MAC clock speed down for RTL8153"
Date:   Tue, 16 Mar 2021 20:56:06 -0400
Message-Id: <20210317005654.724862-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>

[ Upstream commit 4b5dc1a94d4f92b5845e98bd9ae344b26d933aad ]

This reverts commit 134f98bcf1b898fb9d6f2b91bc85dd2e5478b4b8.

The r8153_mac_clk_spd() is used for RTL8153A only, because the register
table of RTL8153B is different from RTL8153A. However, this function would
be called when RTL8153B calls r8153_first_init() and r8153_enter_oob().
That causes RTL8153B becomes unstable when suspending and resuming. The
worst case may let the device stop working.

Besides, revert this commit to disable MAC clock speed down for RTL8153A.
It would avoid the known issue when enabling U1. The data of the first
control transfer may be wrong when exiting U1.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 35 ++++++-----------------------------
 1 file changed, 6 insertions(+), 29 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 88f177aca342..d2862071b697 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3033,29 +3033,6 @@ static void __rtl_set_wol(struct r8152 *tp, u32 wolopts)
 		device_set_wakeup_enable(&tp->udev->dev, false);
 }
 
-static void r8153_mac_clk_spd(struct r8152 *tp, bool enable)
-{
-	/* MAC clock speed down */
-	if (enable) {
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
-	} else {
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL, 0);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL2, 0);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3, 0);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL4, 0);
-	}
-}
-
 static void r8153_u1u2en(struct r8152 *tp, bool enable)
 {
 	u8 u1u2[8];
@@ -3355,11 +3332,9 @@ static void rtl8153_runtime_enable(struct r8152 *tp, bool enable)
 	if (enable) {
 		r8153_u1u2en(tp, false);
 		r8153_u2p3en(tp, false);
-		r8153_mac_clk_spd(tp, true);
 		rtl_runtime_suspend_enable(tp, true);
 	} else {
 		rtl_runtime_suspend_enable(tp, false);
-		r8153_mac_clk_spd(tp, false);
 
 		switch (tp->version) {
 		case RTL_VER_03:
@@ -4695,7 +4670,6 @@ static void r8153_first_init(struct r8152 *tp)
 {
 	u32 ocp_data;
 
-	r8153_mac_clk_spd(tp, false);
 	rxdy_gated_en(tp, true);
 	r8153_teredo_off(tp);
 
@@ -4746,8 +4720,6 @@ static void r8153_enter_oob(struct r8152 *tp)
 {
 	u32 ocp_data;
 
-	r8153_mac_clk_spd(tp, true);
-
 	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
 	ocp_data &= ~NOW_IS_OOB;
 	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
@@ -5473,10 +5445,15 @@ static void r8153_init(struct r8152 *tp)
 
 	ocp_write_word(tp, MCU_TYPE_USB, USB_CONNECT_TIMER, 0x0001);
 
+	/* MAC clock speed down */
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL, 0);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL2, 0);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3, 0);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL4, 0);
+
 	r8153_power_cut_en(tp, false);
 	rtl_runtime_suspend_enable(tp, false);
 	r8153_u1u2en(tp, true);
-	r8153_mac_clk_spd(tp, false);
 	usb_enable_lpm(tp->udev);
 
 	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6);
-- 
2.30.1

