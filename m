Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536266497CA
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 02:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiLLByB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 20:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiLLByA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 20:54:00 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A640B1F2;
        Sun, 11 Dec 2022 17:53:58 -0800 (PST)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NVl5D237HzJqSJ;
        Mon, 12 Dec 2022 09:53:04 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500012.china.huawei.com
 (7.221.188.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 12 Dec
 2022 09:53:55 +0800
From:   Li Zetao <lizetao1@huawei.com>
To:     <pkshih@realtek.com>
CC:     <Larry.Finger@lwfinger.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kvalo@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <linville@tuxdriver.com>, <lizetao1@huawei.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: [PATCH v4] wifi: rtlwifi: Fix global-out-of-bounds bug in _rtl8812ae_phy_set_txpower_limit()
Date:   Mon, 12 Dec 2022 10:58:12 +0800
Message-ID: <20221212025812.1541311-1-lizetao1@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <58dbf9a4aa57417bb40cbabc8ae9cd17@realtek.com>
References: <58dbf9a4aa57417bb40cbabc8ae9cd17@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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

Fix it by removing _rtl8812ae_eq_n_byte() and use strcmp() barely.
Although it can be fixed by adjusting the comparison order of
"prate_section", this may cause the value of "rate_section" to not be
from 0 to 5. In addition, commit "21e4b0726dc6" not only moved driver
from staging to regular tree, but also added setting txpower limit
function during the driver config phase, so the problem was introduced
by this commit.

Fixes: 21e4b0726dc6 ("rtlwifi: rtl8821ae: Move driver from staging to regular tree")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
---
v1 -> v2: delete the third parameter of _rtl8812ae_eq_n_byte() and use
strcmp to replace loop comparison.
v2 -> v3: remove _rtl8812ae_eq_n_byte() and use strcmp() barely.
v3 -> v4: fix subject prefix.

 .../wireless/realtek/rtlwifi/rtl8821ae/phy.c  | 52 +++++++------------
 1 file changed, 20 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index a29321e2fa72..5323ead30db0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -1598,18 +1598,6 @@ static bool _rtl8812ae_get_integer_from_string(const char *str, u8 *pint)
 	return true;
 }
 
-static bool _rtl8812ae_eq_n_byte(const char *str1, const char *str2, u32 num)
-{
-	if (num == 0)
-		return false;
-	while (num > 0) {
-		num--;
-		if (str1[num] != str2[num])
-			return false;
-	}
-	return true;
-}
-
 static s8 _rtl8812ae_phy_get_chnl_idx_of_txpwr_lmt(struct ieee80211_hw *hw,
 					      u8 band, u8 channel)
 {
@@ -1659,42 +1647,42 @@ static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw,
 	power_limit = power_limit > MAX_POWER_INDEX ?
 		      MAX_POWER_INDEX : power_limit;
 
-	if (_rtl8812ae_eq_n_byte(pregulation, "FCC", 3))
+	if (strcmp(pregulation, "FCC") == 0)
 		regulation = 0;
-	else if (_rtl8812ae_eq_n_byte(pregulation, "MKK", 3))
+	else if (strcmp(pregulation, "MKK") == 0)
 		regulation = 1;
-	else if (_rtl8812ae_eq_n_byte(pregulation, "ETSI", 4))
+	else if (strcmp(pregulation, "ETSI") == 0)
 		regulation = 2;
-	else if (_rtl8812ae_eq_n_byte(pregulation, "WW13", 4))
+	else if (strcmp(pregulation, "WW13") == 0)
 		regulation = 3;
 
-	if (_rtl8812ae_eq_n_byte(prate_section, "CCK", 3))
+	if (strcmp(prate_section, "CCK") == 0)
 		rate_section = 0;
-	else if (_rtl8812ae_eq_n_byte(prate_section, "OFDM", 4))
+	else if (strcmp(prate_section, "OFDM") == 0)
 		rate_section = 1;
-	else if (_rtl8812ae_eq_n_byte(prate_section, "HT", 2) &&
-		 _rtl8812ae_eq_n_byte(prf_path, "1T", 2))
+	else if (strcmp(prate_section, "HT") == 0 &&
+		 strcmp(prf_path, "1T") == 0)
 		rate_section = 2;
-	else if (_rtl8812ae_eq_n_byte(prate_section, "HT", 2) &&
-		 _rtl8812ae_eq_n_byte(prf_path, "2T", 2))
+	else if (strcmp(prate_section, "HT") == 0 &&
+		 strcmp(prf_path, "2T") == 0)
 		rate_section = 3;
-	else if (_rtl8812ae_eq_n_byte(prate_section, "VHT", 3) &&
-		 _rtl8812ae_eq_n_byte(prf_path, "1T", 2))
+	else if (strcmp(prate_section, "VHT") == 0 &&
+		 strcmp(prf_path, "1T") == 0)
 		rate_section = 4;
-	else if (_rtl8812ae_eq_n_byte(prate_section, "VHT", 3) &&
-		 _rtl8812ae_eq_n_byte(prf_path, "2T", 2))
+	else if (strcmp(prate_section, "VHT") == 0 &&
+		 strcmp(prf_path, "2T") == 0)
 		rate_section = 5;
 
-	if (_rtl8812ae_eq_n_byte(pbandwidth, "20M", 3))
+	if (strcmp(pbandwidth, "20M") == 0)
 		bandwidth = 0;
-	else if (_rtl8812ae_eq_n_byte(pbandwidth, "40M", 3))
+	else if (strcmp(pbandwidth, "40M") == 0)
 		bandwidth = 1;
-	else if (_rtl8812ae_eq_n_byte(pbandwidth, "80M", 3))
+	else if (strcmp(pbandwidth, "80M") == 0)
 		bandwidth = 2;
-	else if (_rtl8812ae_eq_n_byte(pbandwidth, "160M", 4))
+	else if (strcmp(pbandwidth, "160M") == 0)
 		bandwidth = 3;
 
-	if (_rtl8812ae_eq_n_byte(pband, "2.4G", 4)) {
+	if (strcmp(pband, "2.4G") == 0) {
 		ret = _rtl8812ae_phy_get_chnl_idx_of_txpwr_lmt(hw,
 							       BAND_ON_2_4G,
 							       channel);
@@ -1718,7 +1706,7 @@ static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw,
 			regulation, bandwidth, rate_section, channel_index,
 			rtlphy->txpwr_limit_2_4g[regulation][bandwidth]
 				[rate_section][channel_index][RF90_PATH_A]);
-	} else if (_rtl8812ae_eq_n_byte(pband, "5G", 2)) {
+	} else if (strcmp(pband, "5G") == 0) {
 		ret = _rtl8812ae_phy_get_chnl_idx_of_txpwr_lmt(hw,
 							       BAND_ON_5G,
 							       channel);
-- 
2.31.1

