Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 894362EF4E2
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 16:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbhAHPdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 10:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbhAHPdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 10:33:01 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7ACC061380;
        Fri,  8 Jan 2021 07:32:21 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id q4so5827807plr.7;
        Fri, 08 Jan 2021 07:32:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=spFCEPnVm9qff+fH1Wbln13XJIpHbyb+5Fw9GfNHu/4=;
        b=VgPpzcQ4hoBpx9OQaVDkhRHyJEBfJl53Ds4R/whOhJ/ugwxFoHOTMA3N0WLtrzLMMi
         YSyAQuVCi2eW2AXNc2LtH0oqWiJ8a95tcXZnoaMwQwhVPrlh1PXK8mmC55n68gUWIfax
         /28Ji49xo14MuuVldvwl3FjuGR5WkDxmkJ+m/NYaccaJvaVcgACLIDRMx5QpHXkrPzRm
         xOhoP4IisH7kF5qJZ1Aa/EyiGSmKN7pKvVU5Kjkx4Z+I7TCqnuiuPd9ZPgelc20t1WRO
         z3IKIm4TE4q5YWds8dWz9tm9pkHHMSKI9x4Q6l9Whw/SxMQoalXqiffNoU4ESEuOM0EK
         CG9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=spFCEPnVm9qff+fH1Wbln13XJIpHbyb+5Fw9GfNHu/4=;
        b=l7bmP5CJwTTaMbUEpUjqCQKYqVsjt9dXWO/BGxLUZFoX6KI0xK49ImSdCfAo7eChkJ
         JyfGaQq03X11lo/AU9Pv/l9F/BYmyqnRNDTXJ7GRFElUT0mPI8NHwpQ9VzOOYaocUvd4
         tkPYDHill4AUWQvlnVOvdWsKs0DvfM/S42BoiNdOhV7nRbLG1ANDvXCWnWavTzpFZ8Om
         PSDz4pRInPJeuzgyzdcLMq1OoYzE3LJLFWMG0R+8ff3FjtN0EjoRKn7sP2g1xA9FhhLI
         djhRurS+JZrqZlVZD14g1VwZ8QNyMOzuKaHbgh+D1i5oLmGtso4kvcxiwen0q4J9ngFm
         hMKg==
X-Gm-Message-State: AOAM532mnm0YmWf9Vx/gjITydiwtf92aTh25kDh066uiyYWTKVIdHABL
        kuQ5Wm+9+wMwOGN/u/eAwc2X7KQcr77EjlvF
X-Google-Smtp-Source: ABdhPJwC2wTfVVR8u5R/Lw33ammfmy4vuPocjr63UnBeehn8Nq4AYnbFGi9IriLCRavN4e/4FcNbvA==
X-Received: by 2002:a17:90a:c592:: with SMTP id l18mr4400319pjt.212.1610119940149;
        Fri, 08 Jan 2021 07:32:20 -0800 (PST)
Received: from localhost.localdomain ([2405:201:600d:a089:9d25:60e2:6f4:74f8])
        by smtp.googlemail.com with ESMTPSA id 129sm9048265pfw.86.2021.01.08.07.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 07:32:19 -0800 (PST)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        lukas.bulwahn@gmail.com, yashsri421@gmail.com
Subject: [PATCH] drivers: net: wireless: rtlwifi: fix bool comparison in expressions
Date:   Fri,  8 Jan 2021 21:02:08 +0530
Message-Id: <20210108153208.24065-1-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are certain conditional expressions in rtlwifi, where a boolean
variable is compared with true/false, in forms such as (foo == true) or
(false != bar), which does not comply with checkpatch.pl (CHECK:
BOOL_COMPARISON), according to which boolean variables should be
themselves used in the condition, rather than comparing with true/false

E.g., in drivers/net/wireless/realtek/rtlwifi/ps.c,
"if (find_p2p_ie == true)" can be replaced with "if (find_p2p_ie)"

Replace all such expressions with the bool variables appropriately

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
- The changes made are compile tested
- Applies perfecly on next-20210108

 drivers/net/wireless/realtek/rtlwifi/ps.c                 | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c       | 8 ++++----
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c       | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c       | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c      | 8 ++++----
 6 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
index f99882255d48..629c03271bde 100644
--- a/drivers/net/wireless/realtek/rtlwifi/ps.c
+++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
@@ -798,9 +798,9 @@ static void rtl_p2p_noa_ie(struct ieee80211_hw *hw, void *data,
 		ie += 3 + noa_len;
 	}
 
-	if (find_p2p_ie == true) {
+	if (find_p2p_ie) {
 		if ((p2pinfo->p2p_ps_mode > P2P_PS_NONE) &&
-		    (find_p2p_ps_ie == false))
+		    (!find_p2p_ps_ie))
 			rtl_p2p_ps_cmd(hw, P2P_PS_DISABLE);
 	}
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
index d10c14c694da..6f61d6a10627 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
@@ -474,11 +474,11 @@ static void rtl88e_dm_dig(struct ieee80211_hw *hw)
 	u8 dm_dig_max, dm_dig_min;
 	u8 current_igi = dm_dig->cur_igvalue;
 
-	if (rtlpriv->dm.dm_initialgain_enable == false)
+	if (!rtlpriv->dm.dm_initialgain_enable)
 		return;
-	if (dm_dig->dig_enable_flag == false)
+	if (!dm_dig->dig_enable_flag)
 		return;
-	if (mac->act_scanning == true)
+	if (mac->act_scanning)
 		return;
 
 	if (mac->link_state >= MAC80211_LINKED)
@@ -1637,7 +1637,7 @@ static void rtl88e_dm_fast_ant_training(struct ieee80211_hw *hw)
 			}
 		}
 
-		if (bpkt_filter_match == false) {
+		if (!bpkt_filter_match) {
 			rtl_set_bbreg(hw, DM_REG_TXAGC_A_1_MCS32_11N,
 				      BIT(16), 0);
 			rtl_set_bbreg(hw, DM_REG_IGI_A_11N, BIT(7), 0);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
index bd9160b166c5..861cc663ca93 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
@@ -1269,12 +1269,12 @@ void rtl88ee_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
 	if (rtlpriv->psc.rfpwr_state != ERFON)
 		return;
 
-	if (check_bssid == true) {
+	if (check_bssid) {
 		reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
 					      (u8 *)(&reg_rcr));
 		_rtl88ee_set_bcn_ctrl_reg(hw, 0, BIT(4));
-	} else if (check_bssid == false) {
+	} else if (!check_bssid) {
 		reg_rcr &= (~(RCR_CBSSID_DATA | RCR_CBSSID_BCN));
 		_rtl88ee_set_bcn_ctrl_reg(hw, BIT(4), 0);
 		rtlpriv->cfg->ops->set_hw_reg(hw,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
index 265a1a336304..0b6a15c2e5cc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
@@ -380,7 +380,7 @@ static void rtl92c_dm_initial_gain_multi_sta(struct ieee80211_hw *hw)
 		initialized = false;
 		dm_digtable->dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
 		return;
-	} else if (initialized == false) {
+	} else if (!initialized) {
 		initialized = true;
 		dm_digtable->dig_ext_port_stage = DIG_EXT_PORT_STAGE_0;
 		dm_digtable->cur_igvalue = 0x20;
@@ -509,7 +509,7 @@ static void rtl92c_dm_dig(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
-	if (rtlpriv->dm.dm_initialgain_enable == false)
+	if (!rtlpriv->dm.dm_initialgain_enable)
 		return;
 	if (!(rtlpriv->dm.dm_flag & DYNAMIC_FUNC_DIG))
 		return;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
index 47fabce5c235..73a5d8a068fc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
@@ -458,7 +458,7 @@ static u8 _rtl92se_halset_sysclk(struct ieee80211_hw *hw, u8 data)
 	tmpvalue = rtl_read_byte(rtlpriv, SYS_CLKR + 1);
 	bresult = ((tmpvalue & BIT(7)) == (data & BIT(7)));
 
-	if ((data & (BIT(6) | BIT(7))) == false) {
+	if (!(data & (BIT(6) | BIT(7)))) {
 		waitcount = 100;
 		tmpvalue = 0;
 
@@ -1268,7 +1268,7 @@ static u8 _rtl92s_set_sysclk(struct ieee80211_hw *hw, u8 data)
 	tmp = rtl_read_byte(rtlpriv, SYS_CLKR + 1);
 	result = ((tmp & BIT(7)) == (data & BIT(7)));
 
-	if ((data & (BIT(6) | BIT(7))) == false) {
+	if (!(data & (BIT(6) | BIT(7)))) {
 		waitcnt = 100;
 		tmp = 0;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 372d6f8caf06..e214b9062cc1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -1812,7 +1812,7 @@ static bool _rtl8821ae_phy_bb8821a_config_parafile(struct ieee80211_hw *hw)
 		return false;
 	}
 	_rtl8821ae_phy_init_tx_power_by_rate(hw);
-	if (rtlefuse->autoload_failflag == false) {
+	if (!rtlefuse->autoload_failflag) {
 		rtstatus = _rtl8821ae_phy_config_bb_with_pgheaderfile(hw,
 						    BASEBAND_CONFIG_PHY_REG);
 	}
@@ -3980,7 +3980,7 @@ static void _rtl8821ae_iqk_tx(struct ieee80211_hw *hw, enum radio_path path)
 				}
 			}
 
-			if (tx0iqkok == false)
+			if (!tx0iqkok)
 				break;				/* TXK fail, Don't do RXK */
 
 			if (vdf_enable == 1) {
@@ -4090,7 +4090,7 @@ static void _rtl8821ae_iqk_tx(struct ieee80211_hw *hw, enum radio_path path)
 						}
 					}
 
-					if (tx0iqkok == false) {   /* If RX mode TXK fail, then take TXK Result */
+					if (!tx0iqkok) {   /* If RX mode TXK fail, then take TXK Result */
 						tx_x0_rxk[cal] = tx_x0[cal];
 						tx_y0_rxk[cal] = tx_y0[cal];
 						tx0iqkok = true;
@@ -4249,7 +4249,7 @@ static void _rtl8821ae_iqk_tx(struct ieee80211_hw *hw, enum radio_path path)
 					}
 				}
 
-				if (tx0iqkok == false) {   /* If RX mode TXK fail, then take TXK Result */
+				if (!tx0iqkok) {   /* If RX mode TXK fail, then take TXK Result */
 					tx_x0_rxk[cal] = tx_x0[cal];
 					tx_y0_rxk[cal] = tx_y0[cal];
 					tx0iqkok = true;
-- 
2.17.1

