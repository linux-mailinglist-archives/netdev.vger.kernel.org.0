Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24CF3645C41
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiLGOTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiLGOTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:19:03 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BEF755C94;
        Wed,  7 Dec 2022 06:19:02 -0800 (PST)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NRzsG1HM3zmWSZ;
        Wed,  7 Dec 2022 22:18:10 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500012.china.huawei.com
 (7.221.188.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 7 Dec
 2022 22:18:59 +0800
From:   Li Zetao <lizetao1@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <lizetao1@huawei.com>, <Larry.Finger@lwfinger.net>,
        <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] rtlwifi: rtl8821ae: Fix global-out-of-bounds bug in _rtl8812ae_phy_set_txpower_limit()
Date:   Wed, 7 Dec 2022 23:23:19 +0800
Message-ID: <20221207152319.3135500-1-lizetao1@huawei.com>
X-Mailer: git-send-email 2.31.1
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
strings, so this requires the length of the two strings be greater
than or equal to n. In the  _rtl8812ae_phy_set_txpower_limit(), it was
originally intended to meet this requirement by carefully designing
the comparison order. For example, "pregulation" and "pbandwidth" are
compared in order of length from small to large, first is 3 and last
is 4. However, the comparison order of "prate_section" dose not obey
such order requirement, therefore when "prate_section" is "HT", it will
lead to access out of bounds in _rtl8812ae_eq_n_byte().

Fix it by adding a length check in _rtl8812ae_eq_n_byte(). Although it
can be fixed by adjusting the comparison order of "prate_section", this
may cause the value of "rate_section" to not be from 0 to 5. In
addition, commit "21e4b0726dc6" not only moved driver from staging to
regular tree, but also added setting txpower limit function during the
driver config phase, so the problem was introduced by this commit.

Fixes: 21e4b0726dc6 ("rtlwifi: rtl8821ae: Move driver from staging to regular tree")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index a29321e2fa72..720114a9ddb2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -1600,7 +1600,7 @@ static bool _rtl8812ae_get_integer_from_string(const char *str, u8 *pint)
 
 static bool _rtl8812ae_eq_n_byte(const char *str1, const char *str2, u32 num)
 {
-	if (num == 0)
+	if (num == 0 || strlen(str1) < num)
 		return false;
 	while (num > 0) {
 		num--;
-- 
2.31.1

