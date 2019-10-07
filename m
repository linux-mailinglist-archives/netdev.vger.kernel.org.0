Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E056CE44A
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 15:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbfJGNxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 09:53:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50101 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfJGNxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 09:53:17 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iHTRp-0000r2-Rj; Mon, 07 Oct 2019 13:53:13 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rtl8xxxu: make arrays static, makes object smaller
Date:   Mon,  7 Oct 2019 14:53:13 +0100
Message-Id: <20191007135313.8443-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate const arrays on the stack but instead make them
static. Makes the object code smaller by 60 bytes.

Before:
   text	   data	    bss	    dec	    hex	filename
  15133	   8768	      0	  23901	   5d5d	realtek/rtl8xxxu/rtl8xxxu_8192e.o
  15209	   6392	      0	  21601	   5461	realtek/rtl8xxxu/rtl8xxxu_8723b.o
 103254	  31202	    576	 135032	  20f78	realtek/rtl8xxxu/rtl8xxxu_core.o

After:
   text	   data	    bss	    dec	    hex	filename
  14861	   9024	      0	  23885	   5d4d	realtek/rtl8xxxu/rtl8xxxu_8192e.o
  14953	   6616	      0	  21569	   5441	realtek/rtl8xxxu/rtl8xxxu_8723b.o
 102986	  31458	    576	 135020	  20f6c	realtek/rtl8xxxu/rtl8xxxu_core.o

(gcc version 9.2.1, amd64)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 6 +++---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c | 6 +++---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
index c747f6a1922d..9f1f93d04145 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
@@ -1011,7 +1011,7 @@ static void rtl8192eu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
 	u32 i, val32;
 	int path_a_ok, path_b_ok;
 	int retry = 2;
-	const u32 adda_regs[RTL8XXXU_ADDA_REGS] = {
+	static const u32 adda_regs[RTL8XXXU_ADDA_REGS] = {
 		REG_FPGA0_XCD_SWITCH_CTRL, REG_BLUETOOTH,
 		REG_RX_WAIT_CCA, REG_TX_CCK_RFON,
 		REG_TX_CCK_BBON, REG_TX_OFDM_RFON,
@@ -1021,11 +1021,11 @@ static void rtl8192eu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
 		REG_RX_TO_RX, REG_STANDBY,
 		REG_SLEEP, REG_PMPD_ANAEN
 	};
-	const u32 iqk_mac_regs[RTL8XXXU_MAC_REGS] = {
+	static const u32 iqk_mac_regs[RTL8XXXU_MAC_REGS] = {
 		REG_TXPAUSE, REG_BEACON_CTRL,
 		REG_BEACON_CTRL_1, REG_GPIO_MUXCFG
 	};
-	const u32 iqk_bb_regs[RTL8XXXU_BB_REGS] = {
+	static const u32 iqk_bb_regs[RTL8XXXU_BB_REGS] = {
 		REG_OFDM0_TRX_PATH_ENABLE, REG_OFDM0_TR_MUX_PAR,
 		REG_FPGA0_XCD_RF_SW_CTRL, REG_CONFIG_ANT_A, REG_CONFIG_ANT_B,
 		REG_FPGA0_XAB_RF_SW_CTRL, REG_FPGA0_XA_RF_INT_OE,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
index ceffe05bd65b..61f5d2c24799 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
@@ -882,7 +882,7 @@ static void rtl8723bu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
 	u32 i, val32;
 	int path_a_ok /*, path_b_ok */;
 	int retry = 2;
-	const u32 adda_regs[RTL8XXXU_ADDA_REGS] = {
+	static const u32 adda_regs[RTL8XXXU_ADDA_REGS] = {
 		REG_FPGA0_XCD_SWITCH_CTRL, REG_BLUETOOTH,
 		REG_RX_WAIT_CCA, REG_TX_CCK_RFON,
 		REG_TX_CCK_BBON, REG_TX_OFDM_RFON,
@@ -892,11 +892,11 @@ static void rtl8723bu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
 		REG_RX_TO_RX, REG_STANDBY,
 		REG_SLEEP, REG_PMPD_ANAEN
 	};
-	const u32 iqk_mac_regs[RTL8XXXU_MAC_REGS] = {
+	static const u32 iqk_mac_regs[RTL8XXXU_MAC_REGS] = {
 		REG_TXPAUSE, REG_BEACON_CTRL,
 		REG_BEACON_CTRL_1, REG_GPIO_MUXCFG
 	};
-	const u32 iqk_bb_regs[RTL8XXXU_BB_REGS] = {
+	static const u32 iqk_bb_regs[RTL8XXXU_BB_REGS] = {
 		REG_OFDM0_TRX_PATH_ENABLE, REG_OFDM0_TR_MUX_PAR,
 		REG_FPGA0_XCD_RF_SW_CTRL, REG_CONFIG_ANT_A, REG_CONFIG_ANT_B,
 		REG_FPGA0_XAB_RF_SW_CTRL, REG_FPGA0_XA_RF_INT_OE,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 776bbae14a8d..de6e1efd526f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -3115,7 +3115,7 @@ static void rtl8xxxu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
 	u32 i, val32;
 	int path_a_ok, path_b_ok;
 	int retry = 2;
-	const u32 adda_regs[RTL8XXXU_ADDA_REGS] = {
+	static const u32 adda_regs[RTL8XXXU_ADDA_REGS] = {
 		REG_FPGA0_XCD_SWITCH_CTRL, REG_BLUETOOTH,
 		REG_RX_WAIT_CCA, REG_TX_CCK_RFON,
 		REG_TX_CCK_BBON, REG_TX_OFDM_RFON,
@@ -3125,11 +3125,11 @@ static void rtl8xxxu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
 		REG_RX_TO_RX, REG_STANDBY,
 		REG_SLEEP, REG_PMPD_ANAEN
 	};
-	const u32 iqk_mac_regs[RTL8XXXU_MAC_REGS] = {
+	static const u32 iqk_mac_regs[RTL8XXXU_MAC_REGS] = {
 		REG_TXPAUSE, REG_BEACON_CTRL,
 		REG_BEACON_CTRL_1, REG_GPIO_MUXCFG
 	};
-	const u32 iqk_bb_regs[RTL8XXXU_BB_REGS] = {
+	static const u32 iqk_bb_regs[RTL8XXXU_BB_REGS] = {
 		REG_OFDM0_TRX_PATH_ENABLE, REG_OFDM0_TR_MUX_PAR,
 		REG_FPGA0_XCD_RF_SW_CTRL, REG_CONFIG_ANT_A, REG_CONFIG_ANT_B,
 		REG_FPGA0_XAB_RF_SW_CTRL, REG_FPGA0_XA_RF_INT_OE,
-- 
2.20.1

