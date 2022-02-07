Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D554AC752
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358767AbiBGR1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384330AbiBGRSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:18:23 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E937C0401D5
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:18:23 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id v5-20020a17090a4ec500b001b8b702df57so3837887pjl.2
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 09:18:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dQpQM4iUZjuMJjkLRdye2zNOEEpVCXxMY8XwFdiYAng=;
        b=EVrF9WxR5ej8XTSpBO1LkmL16RPo24jgQFdur1aNjW1NcIdc34BY5VqEXK8L7ly8t0
         LV6XCCc7lDFuyN5UXwV+zvE5PelY4zPCpvi8in7T94EhCsJMbGxm/HuBCZliLmdRBoFF
         ir73vSxejhZdWQJ+eCkR9fXhUyavpJAXLP0nRgPJPScCyGuvxd01PSVxfBZKBHpsdyn5
         f2ajc7gZh8JkNbCUbjjg5OYxZGMDZWZ24ECJseGWcHO50FBCiDQS7j44M5NaAYrEdGx1
         adlVil8YmTfCB7SmygBUA8fPC6UXkf3SnphT6Z7bAcktHwIKGW0OMzaiJJQPg2Y8rwbT
         sobQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dQpQM4iUZjuMJjkLRdye2zNOEEpVCXxMY8XwFdiYAng=;
        b=nKeLTwVvg6qsNa6++uHUFWdNXHVnKH2kiLbhdqr6QXEfJHu7x9fQsBMMb/mIB4hKdm
         6r7U5mapEo6xzNFxrkRg42OSLNC/YaHMPaUKcU+BJga3RUMIgLa2zuk+joZVMUqLueWK
         G0I+cqYJEwJgVr4Gja0RqrGMGspI2fKd3iupGaISuqqS6XjJzPNE0Svfks13jyBlZE21
         XOrVooTIPtanoVVqICwh45t2n2o4ldoyCU77r8h9hqL5+m8iGR6VruvyqufhzLrRwvn6
         pW01+6r3X76f8MU5zbVbJL8NOAk3u8UqII2axeWlLCa3eklR65/cytIBckWBslETX7G7
         qQXw==
X-Gm-Message-State: AOAM530735vtWTiBM+USTvfMjg39/bbkOlWhozkWI/TDuabQ8pcyduvr
        0OO3B72XuNstXtFyhtE2L1iSMMbFJoM=
X-Google-Smtp-Source: ABdhPJw4aC2leAwzHmLrUU+FN7gGCDXRlix8vJ7BJ7a6Kxu+m4XetMHpJuf0jOoj582brAhffM6JeQ==
X-Received: by 2002:a17:903:2350:: with SMTP id c16mr630147plh.4.1644254302610;
        Mon, 07 Feb 2022 09:18:22 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6dea:218:38e6:9e0])
        by smtp.gmail.com with ESMTPSA id lr8sm24415156pjb.11.2022.02.07.09.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 09:18:22 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 07/11] ip6mr: introduce ip6mr_net_exit_batch()
Date:   Mon,  7 Feb 2022 09:17:52 -0800
Message-Id: <20220207171756.1304544-8-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
In-Reply-To: <20220207171756.1304544-1-eric.dumazet@gmail.com>
References: <20220207171756.1304544-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

cleanup_net() is competing with other rtnl users.

Avoiding to acquire rtnl for each netns before calling
ip6mr_rules_exit() gives chance for cleanup_net()
to progress much faster, holding rtnl a bit longer.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ip6mr.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index fd660414d482a30c6d339bb7360bd91d8f3c6f05..881fe6b503072598384b7d935eab66087cd555b6 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -253,13 +253,12 @@ static void __net_exit ip6mr_rules_exit(struct net *net)
 {
 	struct mr_table *mrt, *next;
 
-	rtnl_lock();
+	ASSERT_RTNL();
 	list_for_each_entry_safe(mrt, next, &net->ipv6.mr6_tables, list) {
 		list_del(&mrt->list);
 		ip6mr_free_table(mrt);
 	}
 	fib_rules_unregister(net->ipv6.mr6_rules_ops);
-	rtnl_unlock();
 }
 
 static int ip6mr_rules_dump(struct net *net, struct notifier_block *nb,
@@ -316,10 +315,9 @@ static int __net_init ip6mr_rules_init(struct net *net)
 
 static void __net_exit ip6mr_rules_exit(struct net *net)
 {
-	rtnl_lock();
+	ASSERT_RTNL();
 	ip6mr_free_table(net->ipv6.mrt6);
 	net->ipv6.mrt6 = NULL;
-	rtnl_unlock();
 }
 
 static int ip6mr_rules_dump(struct net *net, struct notifier_block *nb,
@@ -1323,7 +1321,9 @@ static int __net_init ip6mr_net_init(struct net *net)
 proc_cache_fail:
 	remove_proc_entry("ip6_mr_vif", net->proc_net);
 proc_vif_fail:
+	rtnl_lock();
 	ip6mr_rules_exit(net);
+	rtnl_unlock();
 #endif
 ip6mr_rules_fail:
 	ip6mr_notifier_exit(net);
@@ -1336,13 +1336,23 @@ static void __net_exit ip6mr_net_exit(struct net *net)
 	remove_proc_entry("ip6_mr_cache", net->proc_net);
 	remove_proc_entry("ip6_mr_vif", net->proc_net);
 #endif
-	ip6mr_rules_exit(net);
 	ip6mr_notifier_exit(net);
 }
 
+static void __net_exit ip6mr_net_exit_batch(struct list_head *net_list)
+{
+	struct net *net;
+
+	rtnl_lock();
+	list_for_each_entry(net, net_list, exit_list)
+		ip6mr_rules_exit(net);
+	rtnl_unlock();
+}
+
 static struct pernet_operations ip6mr_net_ops = {
 	.init = ip6mr_net_init,
 	.exit = ip6mr_net_exit,
+	.exit_batch = ip6mr_net_exit_batch,
 };
 
 int __init ip6_mr_init(void)
-- 
2.35.0.263.gb82422642f-goog

