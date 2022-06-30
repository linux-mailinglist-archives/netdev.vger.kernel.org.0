Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4766561988
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 13:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbiF3Lqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 07:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiF3Lqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 07:46:42 -0400
X-Greylist: delayed 166521 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 30 Jun 2022 04:46:41 PDT
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D52958FDC
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 04:46:41 -0700 (PDT)
X-QQ-mid: bizesmtp78t1656589589tuvgz5rg
Received: from localhost.localdomain ( [58.240.82.166])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 30 Jun 2022 19:46:23 +0800 (CST)
X-QQ-SSF: 01400000002000G0S000B00A0000000
X-QQ-FEAT: KW3QVT31YreSECNQZBZXGPz7IqsT51g4EWvPhu8C7SBOUUi5kLMQ4+OIWZCfr
        /qfoTuJvmM8WfyAe2VaC8t9qNZMWCr0GlgFgPEjxPOYJXoW6053qLUGWzqmMFhPy96s01LD
        dosYsjA84JSimPvtVUIkgs6KigYUAkiHSon8bFTZ6Wa1exIzr7nMqy1K1GuTXTH9jbhMal5
        o9PksIoBkfAgTJAHeYNpKsIBpdwdG3DS6f36ZsVs065b+kkS0KV2I0Jzb1CceAnBq3Jnqd6
        Ji5BwNr9/YNeSuSxuLMHe/+8oLav8E6KphGiEGZ3qMbKBrD1GzBIob3WpFbw0QFcVPGZxM5
        4ssi0wVUWCpnjILUujNkJk/cZniQW2h3P7iRR5L
X-QQ-GoodBg: 2
From:   Meng Tang <tangmeng@uniontech.com>
To:     stable@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guo-Feng Fan <vincent_fann@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Meng Tang <tangmeng@uniontech.com>
Subject: [PATCH 5.15 1/2] rtw88: 8821c: support RFE type4 wifi NIC
Date:   Thu, 30 Jun 2022 19:46:20 +0800
Message-Id: <20220630114621.19688-1-tangmeng@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign8
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guo-Feng Fan <vincent_fann@realtek.com>

commit b789e3fe7047296be0ccdbb7ceb0b58856053572 upstream.

RFE type4 is a new NIC which has one RF antenna shares with BT.
RFE type4 HW is the same as RFE type2 but attaching antenna to
aux antenna connector.

RFE type2 attach antenna to main antenna connector.
Load the same parameter as RFE type2 when initializing NIC.

Signed-off-by: Guo-Feng Fan <vincent_fann@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210922023637.9357-1-pkshih@realtek.com
Signed-off-by: Meng Tang <tangmeng@uniontech.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8821c.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.c b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
index f405f42d1c1b..746f6f8967d8 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
@@ -304,7 +304,8 @@ static void rtw8821c_set_channel_rf(struct rtw_dev *rtwdev, u8 channel, u8 bw)
 	if (channel <= 14) {
 		if (rtwdev->efuse.rfe_option == 0)
 			rtw8821c_switch_rf_set(rtwdev, SWITCH_TO_WLG);
-		else if (rtwdev->efuse.rfe_option == 2)
+		else if (rtwdev->efuse.rfe_option == 2 ||
+			 rtwdev->efuse.rfe_option == 4)
 			rtw8821c_switch_rf_set(rtwdev, SWITCH_TO_BTG);
 		rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTDBG, BIT(6), 0x1);
 		rtw_write_rf(rtwdev, RF_PATH_A, 0x64, 0xf, 0xf);
@@ -777,6 +778,15 @@ static void rtw8821c_coex_cfg_ant_switch(struct rtw_dev *rtwdev, u8 ctrl_type,
 	if (switch_status == coex_dm->cur_switch_status)
 		return;
 
+	if (coex_rfe->wlg_at_btg) {
+		ctrl_type = COEX_SWITCH_CTRL_BY_BBSW;
+
+		if (coex_rfe->ant_switch_polarity)
+			pos_type = COEX_SWITCH_TO_WLA;
+		else
+			pos_type = COEX_SWITCH_TO_WLG_BT;
+	}
+
 	coex_dm->cur_switch_status = switch_status;
 
 	if (coex_rfe->ant_switch_diversity &&
@@ -1502,6 +1512,7 @@ static const struct rtw_intf_phy_para_table phy_para_table_8821c = {
 static const struct rtw_rfe_def rtw8821c_rfe_defs[] = {
 	[0] = RTW_DEF_RFE(8821c, 0, 0),
 	[2] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
+	[4] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
 };
 
 static struct rtw_hw_reg rtw8821c_dig[] = {
-- 
2.20.1



