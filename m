Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 222852A4F3
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 16:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfEYOre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 10:47:34 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:17577 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726126AbfEYOrd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 May 2019 10:47:33 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 25EE0E8D61B30CE3F6ED;
        Sat, 25 May 2019 22:47:30 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Sat, 25 May 2019
 22:47:20 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] rtlwifi: btcoex: Remove set but not used variable 'len' and 'asso_type_v2'
Date:   Sat, 25 May 2019 22:46:34 +0800
Message-ID: <20190525144634.10696-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c: In function rtl_btc_btmpinfo_notify:
drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c:319:17: warning: variable len set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c: In function exhalbtc_connect_notify:
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c:1581:16: warning: variable asso_type_v2 set but not used [-Wunused-but-set-variable]

'len' is never used since commit 6aad6075ccd5 ("rtlwifi:
Add BT_MP_INFO to c2h handler.") so can be removed.

'asso_type_v2' is not used since introduction in
commit 0843e98a3b9a ("rtlwifi: btcoex: add assoc
type v2 to connection notify")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 .../wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c | 11 +++--------
 .../net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c  |  3 +--
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 2ac0481b29ef..041326e6dd2f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -1578,7 +1578,7 @@ void exhalbtc_scan_notify_wifi_only(struct wifi_only_cfg *wifionly_cfg,
 
 void exhalbtc_connect_notify(struct btc_coexist *btcoexist, u8 action)
 {
-	u8 asso_type, asso_type_v2;
+	u8 asso_type;
 	bool wifi_under_5g;
 
 	if (!halbtc_is_bt_coexist_available(btcoexist))
@@ -1589,15 +1589,10 @@ void exhalbtc_connect_notify(struct btc_coexist *btcoexist, u8 action)
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
 
-	if (action) {
+	if (action)
 		asso_type = BTC_ASSOCIATE_START;
-		asso_type_v2 = wifi_under_5g ? BTC_ASSOCIATE_5G_START :
-					       BTC_ASSOCIATE_START;
-	} else {
+	else
 		asso_type = BTC_ASSOCIATE_FINISH;
-		asso_type_v2 = wifi_under_5g ? BTC_ASSOCIATE_5G_FINISH :
-					       BTC_ASSOCIATE_FINISH;
-	}
 
 	halbtc_leave_low_power(btcoexist);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
index 0e509c33e9e6..b8c4536af6c0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
@@ -316,7 +316,7 @@ void rtl_btc_btinfo_notify(struct rtl_priv *rtlpriv, u8 *tmp_buf, u8 length)
 void rtl_btc_btmpinfo_notify(struct rtl_priv *rtlpriv, u8 *tmp_buf, u8 length)
 {
 	struct btc_coexist *btcoexist = rtl_btc_coexist(rtlpriv);
-	u8 extid, seq, len;
+	u8 extid, seq;
 	u16 bt_real_fw_ver;
 	u8 bt_fw_ver;
 	u8 *data;
@@ -332,7 +332,6 @@ void rtl_btc_btmpinfo_notify(struct rtl_priv *rtlpriv, u8 *tmp_buf, u8 length)
 	if (extid != 1) /* C2H_TRIG_BY_BT_FW = 1 */
 		return;
 
-	len = tmp_buf[1] >> 4;
 	seq = tmp_buf[2] >> 4;
 	data = &tmp_buf[3];
 
-- 
2.17.1


