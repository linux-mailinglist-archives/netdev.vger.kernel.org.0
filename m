Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B503C33E480
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbhCQBAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:00:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231557AbhCQA6K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:58:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9E9964FCF;
        Wed, 17 Mar 2021 00:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942689;
        bh=uxChkiT9kwx0wJFCpkTuGEJciCORHWx3NueifW3y3oU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FaRRM6EtIUdj76FYci1iBSUacDG988Xn3xQFrKQkn4G8yY86Wp+id+v+jdoJhEbr2
         V8mYHOHcriSNeX5rQd0Qgb37y+ZfTQNg+iLfIiXNCJrrijP4jUHkB41+1Jj+vF3WLM
         NVZ3G60E1yXX+6o1b7HifxNgCTJDr3DDqPm5WXWnMh++uZTeB4QlfleK9/M6QxoCT4
         HvQjYRP74YL9KdxwW28STv+tBpeH2FEPA0sqgEXx827nill3glgEe+XRtunYv34Uo0
         BoWrmW4R85XtpqT97GpUlb9fio4yImkAhNAfd57JpJ2J+bLG4ZyTozuZDq5a0hj+Qb
         D8qcLvNuXrQSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hayes Wang <hayeswang@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/37] Revert "r8152: adjust the settings about MAC clock speed down for RTL8153"
Date:   Tue, 16 Mar 2021 20:57:30 -0400
Message-Id: <20210317005802.725825-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005802.725825-1-sashal@kernel.org>
References: <20210317005802.725825-1-sashal@kernel.org>
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
index 22f093797f41..486cf511d2bf 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2836,29 +2836,6 @@ static void __rtl_set_wol(struct r8152 *tp, u32 wolopts)
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
@@ -3158,11 +3135,9 @@ static void rtl8153_runtime_enable(struct r8152 *tp, bool enable)
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
@@ -3727,7 +3702,6 @@ static void r8153_first_init(struct r8152 *tp)
 	u32 ocp_data;
 	int i;
 
-	r8153_mac_clk_spd(tp, false);
 	rxdy_gated_en(tp, true);
 	r8153_teredo_off(tp);
 
@@ -3789,8 +3763,6 @@ static void r8153_enter_oob(struct r8152 *tp)
 	u32 ocp_data;
 	int i;
 
-	r8153_mac_clk_spd(tp, true);
-
 	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
 	ocp_data &= ~NOW_IS_OOB;
 	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
@@ -4498,9 +4470,14 @@ static void r8153_init(struct r8152 *tp)
 
 	ocp_write_word(tp, MCU_TYPE_USB, USB_CONNECT_TIMER, 0x0001);
 
+	/* MAC clock speed down */
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL, 0);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL2, 0);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3, 0);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL4, 0);
+
 	r8153_power_cut_en(tp, false);
 	r8153_u1u2en(tp, true);
-	r8153_mac_clk_spd(tp, false);
 	usb_enable_lpm(tp->udev);
 
 	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6);
-- 
2.30.1

