Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1E262703C
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 16:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235179AbiKMPmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 10:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiKMPmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 10:42:35 -0500
Received: from smtp.smtpout.orange.fr (smtp-12.smtpout.orange.fr [80.12.242.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C9A633C
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 07:42:34 -0800 (PST)
Received: from pop-os.home ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id uF7so4X3g9RnzuF7sou3uq; Sun, 13 Nov 2022 16:42:32 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Nov 2022 16:42:32 +0100
X-ME-IP: 86.243.100.34
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Ping-Ke Shih <pkshih@realtek.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chin-Yen Lee <timlee@realtek.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] wifi: rtw89: Fix some error handling path in rtw89_wow_enable()
Date:   Sun, 13 Nov 2022 16:42:21 +0100
Message-Id: <32320176eeff1c635baeea25ef0e87d116859e65.1668354083.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'ret' is not updated after several function calls in rtw89_wow_enable().
This prevent error handling from working.

Add the missing assignments.

Fixes: 19e28c7fcc74 ("wifi: rtw89: add WoWLAN function support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/realtek/rtw89/wow.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/wow.c b/drivers/net/wireless/realtek/rtw89/wow.c
index 7de4dd047d6b..b2b826b2e09a 100644
--- a/drivers/net/wireless/realtek/rtw89/wow.c
+++ b/drivers/net/wireless/realtek/rtw89/wow.c
@@ -744,13 +744,13 @@ static int rtw89_wow_enable(struct rtw89_dev *rtwdev)
 		goto out;
 	}
 
-	rtw89_wow_swap_fw(rtwdev, true);
+	ret = rtw89_wow_swap_fw(rtwdev, true);
 	if (ret) {
 		rtw89_err(rtwdev, "wow: failed to swap to wow fw\n");
 		goto out;
 	}
 
-	rtw89_wow_fw_start(rtwdev);
+	ret = rtw89_wow_fw_start(rtwdev);
 	if (ret) {
 		rtw89_err(rtwdev, "wow: failed to let wow fw start\n");
 		goto out;
@@ -758,7 +758,7 @@ static int rtw89_wow_enable(struct rtw89_dev *rtwdev)
 
 	rtw89_wow_enter_lps(rtwdev);
 
-	rtw89_wow_enable_trx_post(rtwdev);
+	ret = rtw89_wow_enable_trx_post(rtwdev);
 	if (ret) {
 		rtw89_err(rtwdev, "wow: failed to enable trx_post\n");
 		goto out;
-- 
2.34.1

