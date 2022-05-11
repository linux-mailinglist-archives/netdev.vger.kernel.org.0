Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6813C52291B
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 03:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240680AbiEKBqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 21:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240637AbiEKBqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 21:46:15 -0400
Received: from hust.edu.cn (mail.hust.edu.cn [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF973586D;
        Tue, 10 May 2022 18:46:07 -0700 (PDT)
Received: from localhost.localdomain ([172.16.0.254])
        (user=dzm91@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 24B1isWb014794-24B1isWe014794
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Wed, 11 May 2022 09:44:59 +0800
From:   Dongliang Mu <dzm91@hust.edu.cn>
To:     Ping-Ke Shih <pkshih@realtek.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        syzkaller <syzkaller@googlegroups.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: rtlwifi: Use pr_warn instead of WARN_ONCE
Date:   Wed, 11 May 2022 09:44:52 +0800
Message-Id: <20220511014453.1621366-1-dzm91@hust.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: dzm91@hust.edu.cn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

This memory allocation failure can be triggered by fault injection or
high pressure testing, resulting a WARN.

Fix this by replacing WARN with pr_warn.

Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
v1->v2: change to pr_warn as suggested by Kalle Valo
 drivers/net/wireless/realtek/rtlwifi/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 86a236873254..a8eebafb9a7e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1014,7 +1014,7 @@ int rtl_usb_probe(struct usb_interface *intf,
 	hw = ieee80211_alloc_hw(sizeof(struct rtl_priv) +
 				sizeof(struct rtl_usb_priv), &rtl_ops);
 	if (!hw) {
-		WARN_ONCE(true, "rtl_usb: ieee80211 alloc failed\n");
+		pr_warn("rtl_usb: ieee80211 alloc failed\n");
 		return -ENOMEM;
 	}
 	rtlpriv = hw->priv;
-- 
2.25.1

