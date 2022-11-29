Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D9463C239
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbiK2OQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:16:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235097AbiK2OOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:14:03 -0500
X-Greylist: delayed 344 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 29 Nov 2022 06:14:02 PST
Received: from gw.red-soft.ru (red-soft.ru [188.246.186.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A32D11A05A
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 06:14:02 -0800 (PST)
Received: from localhost.biz (unknown [10.81.81.211])
        by gw.red-soft.ru (Postfix) with ESMTPA id EF03F3E31CB;
        Tue, 29 Nov 2022 17:08:14 +0300 (MSK)
From:   Artem Chernyshev <artem.chernyshev@red-soft.ru>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Artem Chernyshev <artem.chernyshev@red-soft.ru>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH] net: dsa: ksz: Check proper trim in ksz_common_rcv()
Date:   Tue, 29 Nov 2022 17:08:09 +0300
Message-Id: <20221129140809.2755960-1-artem.chernyshev@red-soft.ru>
X-Mailer: git-send-email 2.30.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 173826 [Nov 29 2022]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: artem.chernyshev@red-soft.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 502 502 69dee8ef46717dd3cb3eeb129cb7cc8dab9e30f6, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;red-soft.ru:7.1.1;127.0.0.199:7.1.2;localhost.biz:7.1.1
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2022/11/29 11:22:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2022/11/29 08:46:00 #20623389
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return NULL if we got unexpected value from skb_trim_rcsum()

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: bafe9ba7d908 ("net: dsa: ksz: Factor out common tag code")
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
---
 net/dsa/tag_ksz.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 38fa19c1e2d5..429250298ac4 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -21,7 +21,8 @@ static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 	if (!skb->dev)
 		return NULL;
 
-	pskb_trim_rcsum(skb, skb->len - len);
+	if (pskb_trim_rcsum(skb, skb->len - len))
+		return NULL;
 
 	dsa_default_offload_fwd_mark(skb);
 
-- 
2.30.3

