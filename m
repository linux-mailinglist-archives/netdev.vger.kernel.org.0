Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C128C270B3F
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 08:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgISGrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 02:47:09 -0400
Received: from smtprelay0231.hostedemail.com ([216.40.44.231]:46882 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726097AbgISGrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 02:47:08 -0400
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Sep 2020 02:47:08 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave03.hostedemail.com (Postfix) with ESMTP id EB9591802748A;
        Sat, 19 Sep 2020 06:37:51 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 1B737837F24A;
        Sat, 19 Sep 2020 06:37:50 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:2:41:69:355:379:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3865:3868:4049:4118:4321:4419:5007:6119:6120:7901:7903:9036:9592:10004:10848:11026:11232:11473:11657:11658:11914:12043:12114:12296:12297:12438:12555:12760:12986:13439:14096:14097:14394:14659:21080:21627:21990:30054,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: chair70_13139a027131
X-Filterd-Recvd-Size: 7493
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf10.hostedemail.com (Postfix) with ESMTPA;
        Sat, 19 Sep 2020 06:37:48 +0000 (UTC)
Message-ID: <e2ab424d24b74901bc0c39f0c60f75e871adf2ba.camel@perches.com>
Subject: [PATCH] rtlwifi: Use ffs in <foo>_phy_calculate_bit_shift
From:   Joe Perches <joe@perches.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 18 Sep 2020 23:37:47 -0700
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the loop and use the generic ffs instead.

Signed-off-by: Joe Perches <joe@perches.com>
---
Just saw one by happenstance, might as well fix them all.

 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c   | 18 ++++++------------
 .../net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c |  8 ++------
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |  9 ++-------
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c   |  8 ++------
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c   |  9 ++-------
 .../wireless/realtek/rtlwifi/rtl8723com/phy_common.c   |  8 ++------
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   | 18 ++++++------------
 7 files changed, 22 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
index 38d4432767e8..9be032e8ec95 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
@@ -16,7 +16,12 @@ static u32 _rtl88e_phy_rf_serial_read(struct ieee80211_hw *hw,
 static void _rtl88e_phy_rf_serial_write(struct ieee80211_hw *hw,
 					enum radio_path rfpath, u32 offset,
 					u32 data);
-static u32 _rtl88e_phy_calculate_bit_shift(u32 bitmask);
+static u32 _rtl88e_phy_calculate_bit_shift(u32 bitmask)
+{
+	u32 i = ffs(bitmask);
+
+	return i ? i - 1 : 32;
+}
 static bool _rtl88e_phy_bb8188e_config_parafile(struct ieee80211_hw *hw);
 static bool _rtl88e_phy_config_mac_with_headerfile(struct ieee80211_hw *hw);
 static bool phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
@@ -208,17 +213,6 @@ static void _rtl88e_phy_rf_serial_write(struct ieee80211_hw *hw,
 		rfpath, pphyreg->rf3wire_offset, data_and_addr);
 }
 
-static u32 _rtl88e_phy_calculate_bit_shift(u32 bitmask)
-{
-	u32 i;
-
-	for (i = 0; i <= 31; i++) {
-		if (((bitmask >> i) & 0x1) == 1)
-			break;
-	}
-	return i;
-}
-
 bool rtl88e_phy_mac_config(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
index fc6c81291cf5..238b6e010769 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
@@ -145,13 +145,9 @@ EXPORT_SYMBOL(_rtl92c_phy_rf_serial_write);
 
 u32 _rtl92c_phy_calculate_bit_shift(u32 bitmask)
 {
-	u32 i;
+	u32 i = ffs(bitmask);
 
-	for (i = 0; i <= 31; i++) {
-		if (((bitmask >> i) & 0x1) == 1)
-			break;
-	}
-	return i;
+	return i ? i - 1 : 32;
 }
 EXPORT_SYMBOL(_rtl92c_phy_calculate_bit_shift);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index 87804325928a..e34d33e73e52 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -162,14 +162,9 @@ static u32 targetchnl_2g[TARGET_CHNL_NUM_2G] = {
 
 static u32 _rtl92d_phy_calculate_bit_shift(u32 bitmask)
 {
-	u32 i;
-
-	for (i = 0; i <= 31; i++) {
-		if (((bitmask >> i) & 0x1) == 1)
-			break;
-	}
+	u32 i = ffs(bitmask);
 
-	return i;
+	return i ? i - 1 : 32;
 }
 
 u32 rtl92d_phy_query_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
index f107a30a96f0..cc0bcaf13e96 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
@@ -203,13 +203,9 @@ static void _rtl92ee_phy_rf_serial_write(struct ieee80211_hw *hw,
 
 static u32 _rtl92ee_phy_calculate_bit_shift(u32 bitmask)
 {
-	u32 i;
+	u32 i = ffs(bitmask);
 
-	for (i = 0; i <= 31; i++) {
-		if (((bitmask >> i) & 0x1) == 1)
-			break;
-	}
-	return i;
+	return i ? i - 1 : 32;
 }
 
 bool rtl92ee_phy_mac_config(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
index 3d482b8675e2..63283d9e7485 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
@@ -16,14 +16,9 @@
 
 static u32 _rtl92s_phy_calculate_bit_shift(u32 bitmask)
 {
-	u32 i;
-
-	for (i = 0; i <= 31; i++) {
-		if (((bitmask >> i) & 0x1) == 1)
-			break;
-	}
+	u32 i = ffs(bitmask);
 
-	return i;
+	return i ? i - 1 : 32;
 }
 
 u32 rtl92s_phy_query_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.c
index 097f21f6d35b..47b6c1aa36b0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.c
@@ -53,13 +53,9 @@ EXPORT_SYMBOL_GPL(rtl8723_phy_set_bb_reg);
 
 u32 rtl8723_phy_calculate_bit_shift(u32 bitmask)
 {
-	u32 i;
+	u32 i = ffs(bitmask);
 
-	for (i = 0; i <= 31; i++) {
-		if (((bitmask >> i) & 0x1) == 1)
-			break;
-	}
-	return i;
+	return i ? i - 1 : 32;
 }
 EXPORT_SYMBOL_GPL(rtl8723_phy_calculate_bit_shift);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 7832fae3d00f..e2af0b4a99df 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -27,7 +27,12 @@ static u32 _rtl8821ae_phy_rf_serial_read(struct ieee80211_hw *hw,
 static void _rtl8821ae_phy_rf_serial_write(struct ieee80211_hw *hw,
 					   enum radio_path rfpath, u32 offset,
 					   u32 data);
-static u32 _rtl8821ae_phy_calculate_bit_shift(u32 bitmask);
+static u32 _rtl8821ae_phy_calculate_bit_shift(u32 bitmask)
+{
+	u32 i = ffs(bitmask);
+
+	return i ? i - 1 : 32;
+}
 static bool _rtl8821ae_phy_bb8821a_config_parafile(struct ieee80211_hw *hw);
 /*static bool _rtl8812ae_phy_config_mac_with_headerfile(struct ieee80211_hw *hw);*/
 static bool _rtl8821ae_phy_config_mac_with_headerfile(struct ieee80211_hw *hw);
@@ -272,17 +277,6 @@ static void _rtl8821ae_phy_rf_serial_write(struct ieee80211_hw *hw,
 		rfpath, pphyreg->rf3wire_offset, data_and_addr);
 }
 
-static u32 _rtl8821ae_phy_calculate_bit_shift(u32 bitmask)
-{
-	u32 i;
-
-	for (i = 0; i <= 31; i++) {
-		if (((bitmask >> i) & 0x1) == 1)
-			break;
-	}
-	return i;
-}
-
 bool rtl8821ae_phy_mac_config(struct ieee80211_hw *hw)
 {
 	bool rtstatus = 0;


