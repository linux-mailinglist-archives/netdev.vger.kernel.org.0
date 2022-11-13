Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD2762704A
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 16:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235258AbiKMPt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 10:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233930AbiKMPt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 10:49:26 -0500
Received: from smtp.smtpout.orange.fr (smtp-18.smtpout.orange.fr [80.12.242.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9E02BFE
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 07:49:26 -0800 (PST)
Received: from pop-os.home ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id uFEXoEoZTXaJmuFEYoHaCh; Sun, 13 Nov 2022 16:49:24 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Nov 2022 16:49:24 +0100
X-ME-IP: 86.243.100.34
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Ping-Ke Shih <pkshih@realtek.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] wifi: rtw89: Fix some error handling path in rtw89_core_sta_assoc()
Date:   Sun, 13 Nov 2022 16:49:18 +0100
Message-Id: <7b1d82594635e4406d3438f33d8da29eaa056c5a.1668354547.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'ret' is not updated after a function call in rtw89_core_sta_assoc().
This prevent error handling from working.

Add the missing assignment.

Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/realtek/rtw89/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index e716b96d0f56..f30aadc41f2b 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -2535,7 +2535,7 @@ int rtw89_core_sta_assoc(struct rtw89_dev *rtwdev,
 	}
 
 	/* update cam aid mac_id net_type */
-	rtw89_fw_h2c_cam(rtwdev, rtwvif, rtwsta, NULL);
+	ret = rtw89_fw_h2c_cam(rtwdev, rtwvif, rtwsta, NULL);
 	if (ret) {
 		rtw89_warn(rtwdev, "failed to send h2c cam\n");
 		return ret;
-- 
2.34.1

