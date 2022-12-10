Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1F2648F69
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 16:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiLJPTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 10:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiLJPTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 10:19:50 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF6412AB9;
        Sat, 10 Dec 2022 07:19:48 -0800 (PST)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NTs3w3X5qzJqKw;
        Sat, 10 Dec 2022 23:18:52 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500012.china.huawei.com
 (7.221.188.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sat, 10 Dec
 2022 23:19:16 +0800
From:   Li Zetao <lizetao1@huawei.com>
To:     <pkshih@realtek.com>
CC:     <Larry.Finger@lwfinger.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kvalo@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <linville@tuxdriver.com>, <lizetao1@huawei.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: [PATCH v2] rtlwifi: rtl8821ae: Fix global-out-of-bounds bug in _rtl8812ae_phy_set_txpower_limit()
Date:   Sun, 11 Dec 2022 00:23:36 +0800
Message-ID: <20221210162336.1383856-1-lizetao1@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <e985ead3ea7841b8b3a94201dfb18776@realtek.com>
References: <e985ead3ea7841b8b3a94201dfb18776@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a global-out-of-bounds reported by KASAN:

  BUG: KASAN: global-out-of-bounds in
  _rtl8812ae_eq_n_byte.part.0+0x3d/0x84 [rtl8821ae]
  Read of size 1 at addr ffffffffa0773c43 by task NetworkManager/411

  CPU: 6 PID: 411 Comm: NetworkManager Tainted: G      D
  6.1.0-rc8+ #144 e15588508517267d37
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
  Call Trace:
   <TASK>
   ...
   kasan_report+0xbb/0x1c0
   _rtl8812ae_eq_n_byte.part.0+0x3d/0x84 [rtl8821ae]
   rtl8821ae_phy_bb_config.cold+0x346/0x641 [rtl8821ae]
   rtl8821ae_hw_init+0x1f5e/0x79b0 [rtl8821ae]
   ...
   </TASK>

The root cause of the problem is that the comparison order of
"prate_section" in _rtl8812ae_phy_set_txpower_limit() is wrong. The
_rtl8812ae_eq_n_byte() is used to compare the first n bytes of the two
strings from tail to head, which causes the problem. In the
_rtl8812ae_phy_set_txpower_limit(), it was originally intended to meet
this requirement by carefully designing the comparison order.
For example, "pregulation" and "pbandwidth" are compared in order of
length from small to large, first is 3 and last is 4. However, the
comparison order of "prate_section" dose not obey such order requirement,
therefore when "prate_section" is "HT", when comparing from tail to head,
it will lead to access out of bounds in _rtl8812ae_eq_n_byte(). As
mentioned above, the _rtl8812ae_eq_n_byte() has the same function as
strcmp(), so just strcmp() is enough.

Fix it by replacing _rtl8812ae_eq_n_byte() with strcmp(). Although it
can be fixed by adjusting the comparison order of "prate_section", this
may cause the value of "rate_section" to not be from 0 to 5. In
addition, commit "21e4b0726dc6" not only moved driver from staging to
regular tree, but also added setting txpower limit function during the
driver config phase, so the problem was introduced by this commit.

Fixes: 21e4b0726dc6 ("rtlwifi: rtl8821ae: Move driver from staging to regular tree")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
---
v1 was posted at: https://lore.kernel.org/all/20221207152319.3135500-1-lizetao1@huawei.com/
v1 -> v2: delete the third parameter of _rtl8812ae_eq_n_byte() and use
strcmp to replace loop comparison.

 .../wireless/realtek/rtlwifi/rtl8821ae/phy.c  | 51 ++++++++-----------
 1 file changed, 22 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index a29321e2fa72..14b569d7d8fa 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -1598,16 +1598,9 @@ static bool _rtl8812ae_get_integer_from_string(const char *str, u8 *pint)
 	return true;
 }
 
-static bool _rtl8812ae_eq_n_byte(const char *str1, const char *str2, u32 num)
+static bool _rtl8812ae_eq_n_byte(const char *str1, const char *str2)
 {
-	if (num == 0)
-		return false;
-	while (num > 0) {
-		num--;
-		if (str1[num] != str2[num])
-			return false;
-	}
-	return true;
+	return strcmp(str1, str2) == 0;
 }
 
 static s8 _rtl8812ae_phy_get_chnl_idx_of_txpwr_lmt(struct ieee80211_hw *hw,
@@ -1659,42 +1652,42 @@ static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw,
 	power_limit = power_limit > MAX_POWER_INDEX ?
 		      MAX_POWER_INDEX : power_limit;
 
-	if (_rtl8812ae_eq_n_byte(pregulation, "FCC", 3))
+	if (_rtl8812ae_eq_n_byte(pregulation, "FCC"))
 		regulation = 0;
-	else if (_rtl8812ae_eq_n_byte(pregulation, "MKK", 3))
+	else if (_rtl8812ae_eq_n_byte(pregulation, "MKK"))
 		regulation = 1;
-	else if (_rtl8812ae_eq_n_byte(pregulation, "ETSI", 4))
+	else if (_rtl8812ae_eq_n_byte(pregulation, "ETSI"))
 		regulation = 2;
-	else if (_rtl8812ae_eq_n_byte(pregulation, "WW13", 4))
+	else if (_rtl8812ae_eq_n_byte(pregulation, "WW13"))
 		regulation = 3;
 
-	if (_rtl8812ae_eq_n_byte(prate_section, "CCK", 3))
+	if (_rtl8812ae_eq_n_byte(prate_section, "CCK"))
 		rate_section = 0;
-	else if (_rtl8812ae_eq_n_byte(prate_section, "OFDM", 4))
+	else if (_rtl8812ae_eq_n_byte(prate_section, "OFDM"))
 		rate_section = 1;
-	else if (_rtl8812ae_eq_n_byte(prate_section, "HT", 2) &&
-		 _rtl8812ae_eq_n_byte(prf_path, "1T", 2))
+	else if (_rtl8812ae_eq_n_byte(prate_section, "HT") &&
+		 _rtl8812ae_eq_n_byte(prf_path, "1T"))
 		rate_section = 2;
-	else if (_rtl8812ae_eq_n_byte(prate_section, "HT", 2) &&
-		 _rtl8812ae_eq_n_byte(prf_path, "2T", 2))
+	else if (_rtl8812ae_eq_n_byte(prate_section, "HT") &&
+		 _rtl8812ae_eq_n_byte(prf_path, "2T"))
 		rate_section = 3;
-	else if (_rtl8812ae_eq_n_byte(prate_section, "VHT", 3) &&
-		 _rtl8812ae_eq_n_byte(prf_path, "1T", 2))
+	else if (_rtl8812ae_eq_n_byte(prate_section, "VHT") &&
+		 _rtl8812ae_eq_n_byte(prf_path, "1T"))
 		rate_section = 4;
-	else if (_rtl8812ae_eq_n_byte(prate_section, "VHT", 3) &&
-		 _rtl8812ae_eq_n_byte(prf_path, "2T", 2))
+	else if (_rtl8812ae_eq_n_byte(prate_section, "VHT") &&
+		 _rtl8812ae_eq_n_byte(prf_path, "2T"))
 		rate_section = 5;
 
-	if (_rtl8812ae_eq_n_byte(pbandwidth, "20M", 3))
+	if (_rtl8812ae_eq_n_byte(pbandwidth, "20M"))
 		bandwidth = 0;
-	else if (_rtl8812ae_eq_n_byte(pbandwidth, "40M", 3))
+	else if (_rtl8812ae_eq_n_byte(pbandwidth, "40M"))
 		bandwidth = 1;
-	else if (_rtl8812ae_eq_n_byte(pbandwidth, "80M", 3))
+	else if (_rtl8812ae_eq_n_byte(pbandwidth, "80M"))
 		bandwidth = 2;
-	else if (_rtl8812ae_eq_n_byte(pbandwidth, "160M", 4))
+	else if (_rtl8812ae_eq_n_byte(pbandwidth, "160M"))
 		bandwidth = 3;
 
-	if (_rtl8812ae_eq_n_byte(pband, "2.4G", 4)) {
+	if (_rtl8812ae_eq_n_byte(pband, "2.4G")) {
 		ret = _rtl8812ae_phy_get_chnl_idx_of_txpwr_lmt(hw,
 							       BAND_ON_2_4G,
 							       channel);
@@ -1718,7 +1711,7 @@ static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw,
 			regulation, bandwidth, rate_section, channel_index,
 			rtlphy->txpwr_limit_2_4g[regulation][bandwidth]
 				[rate_section][channel_index][RF90_PATH_A]);
-	} else if (_rtl8812ae_eq_n_byte(pband, "5G", 2)) {
+	} else if (_rtl8812ae_eq_n_byte(pband, "5G")) {
 		ret = _rtl8812ae_phy_get_chnl_idx_of_txpwr_lmt(hw,
 							       BAND_ON_5G,
 							       channel);
-- 
2.31.1

