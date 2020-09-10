Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29A82651BB
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgIJVAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:00:46 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12220 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730826AbgIJOpe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 10:45:34 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E32177AABAC7776F98AE;
        Thu, 10 Sep 2020 21:52:30 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 21:52:23 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH -next 3/3] rtlwifi: rtl8188ee: fix comparison pointer to bool warning in hw.c
Date:   Thu, 10 Sep 2020 21:59:17 +0800
Message-ID: <20200910135917.143723-4-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
In-Reply-To: <20200910135917.143723-1-zhengbin13@huawei.com>
References: <20200910135917.143723-1-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes coccicheck warning:

drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c:777:14-20: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c:782:13-19: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c:787:14-20: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c:792:13-19: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c:871:6-33: WARNING: Comparison to bool
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c:1070:5-13: WARNING: Comparison to bool

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
index 4c8d71fbdd7a..63f9ea21962f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
@@ -774,22 +774,22 @@ static bool _rtl88ee_llt_table_init(struct ieee80211_hw *hw)

 	for (i = 0; i < (txpktbuf_bndy - 1); i++) {
 		status = _rtl88ee_llt_write(hw, i, i + 1);
-		if (true != status)
+		if (!status)
 			return status;
 	}

 	status = _rtl88ee_llt_write(hw, (txpktbuf_bndy - 1), 0xFF);
-	if (true != status)
+	if (!status)
 		return status;

 	for (i = txpktbuf_bndy; i < maxpage; i++) {
 		status = _rtl88ee_llt_write(hw, i, (i + 1));
-		if (true != status)
+		if (!status)
 			return status;
 	}

 	status = _rtl88ee_llt_write(hw, maxpage, txpktbuf_bndy);
-	if (true != status)
+	if (!status)
 		return status;

 	return true;
@@ -868,7 +868,7 @@ static bool _rtl88ee_init_mac(struct ieee80211_hw *hw)
 	rtl_write_byte(rtlpriv, MSR, 0x00);

 	if (!rtlhal->mac_func_enable) {
-		if (_rtl88ee_llt_table_init(hw) == false) {
+		if (!_rtl88ee_llt_table_init(hw)) {
 			rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD,
 				"LLT table init fail\n");
 			return false;
@@ -1067,7 +1067,7 @@ int rtl88ee_hw_init(struct ieee80211_hw *hw)
 	}

 	rtstatus = _rtl88ee_init_mac(hw);
-	if (rtstatus != true) {
+	if (!rtstatus) {
 		pr_info("Init MAC failed\n");
 		err = 1;
 		goto exit;
--
2.26.0.106.g9fadedd

