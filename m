Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F68655BCF
	for <lists+netdev@lfdr.de>; Sun, 25 Dec 2022 00:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiLXXdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Dec 2022 18:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiLXXdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Dec 2022 18:33:21 -0500
Received: from gw.red-soft.ru (red-soft.ru [188.246.186.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89A4A60EB;
        Sat, 24 Dec 2022 15:33:19 -0800 (PST)
Received: from localhost.biz (unknown [10.81.81.211])
        by gw.red-soft.ru (Postfix) with ESMTPA id 689123E1A04;
        Sun, 25 Dec 2022 02:33:16 +0300 (MSK)
From:   Artem Chernyshev <artem.chernyshev@red-soft.ru>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     Artem Chernyshev <artem.chernyshev@red-soft.ru>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH] batman-adv: Check return value
Date:   Sun, 25 Dec 2022 02:33:11 +0300
Message-Id: <20221224233311.48678-1-artem.chernyshev@red-soft.ru>
X-Mailer: git-send-email 2.30.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 174384 [Dec 24 2022]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: artem.chernyshev@red-soft.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 502 502 69dee8ef46717dd3cb3eeb129cb7cc8dab9e30f6, {Tracking_from_domain_doesnt_match_to}, red-soft.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;localhost.biz:7.1.1
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2022/12/24 20:53:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2022/12/24 20:35:00 #20705035
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check, if rtnl_link_register() call in batadv_init() was successful

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: a4ac28c0d06a ("batman-adv: Allow to use rntl_link for device creation/deletion")
Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
---
 net/batman-adv/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
index e8a449915566..04cd9682bd29 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -113,7 +113,11 @@ static int __init batadv_init(void)
 		goto err_create_wq;
 
 	register_netdevice_notifier(&batadv_hard_if_notifier);
-	rtnl_link_register(&batadv_link_ops);
+	ret = rtnl_link_register(&batadv_link_ops);
+	if (ret) {
+		pr_err("Can't register link_ops\n");
+		goto err_create_wq;
+	}
 	batadv_netlink_register();
 
 	pr_info("B.A.T.M.A.N. advanced %s (compatibility version %i) loaded\n",
-- 
2.30.3

