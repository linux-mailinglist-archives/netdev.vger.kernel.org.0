Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69CC4AD0DD
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 06:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347055AbiBHFc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 00:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347048AbiBHEvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:51:15 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21D5C0401E5
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 20:51:14 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id c3so12877829pls.5
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 20:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kVKXyuZ9ByNL5gRoA1X/9lUBlGLA/Ue4kD0z9O4JtmE=;
        b=ndm/EqwT20dbUfQaQoP68hxyiyTrMqRB8BNRcWIqlkuq4+gqqT5bmAZtWz+nAMxHsY
         26wE2zWfawlZ8yqCE/i0WE2n08/f/iF0mWVSZ3FoSRjyjGsa12Vmghm2CUu0oPKh8TEF
         lE9I6ibYtN8QxkeHbjYJJTPMPGt9971FEQdfpya+nfp0slF3tt2JTptJvCFUrsbVRK0X
         qP0WIVs/ZySsFn9WWFyeZus2uU4bR32IJtp8boMWK9iFESedW1gfdsjDQrc8jEmJ1e8e
         U9tg0gmVsLJCbPxhTQOPaneVdHMKFKga9dUwnFulfyq03ItF9F2ewTNSPwND8U9FZKw8
         Gz3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kVKXyuZ9ByNL5gRoA1X/9lUBlGLA/Ue4kD0z9O4JtmE=;
        b=s4q4alyuPiOehUMU1fZY9IHJlXDPyGkC9HbBO9FtMdxFhPoFodpfl7T9Dti2XAY8Ki
         ExASnaBbHWVELh/tBr6Rp7h9z3QIVrSmWinKTWb3dXLmiG9p3TYTl7Pg7QvvEZXzpKCg
         mIeQSvvyac7HWJXiNVAVsCFZ5r3QvtmbESNh2VtIka6nB+/iN5HnZmPGk8w7LSK5f6FN
         WrFY4dqzHGbHWN3zJumK/jKJZ1AUMeOV6WMf3mRGcAhQyXmvqUrjZofNkMK/7GgvSmR+
         SVqv1vnJae/rhSrDSA5Z0u9WWqz97796+miDc4spTr/thdrjOiePlz+SqltJKTPbTe0n
         g6SA==
X-Gm-Message-State: AOAM532dV6m/44gmG9+SaNph6Q0rz/bEBg5DGT3CTrY1HTrU+tEa2CZJ
        M/PxyR5SHIjwajUfPrJJZB43CR6M6XQ=
X-Google-Smtp-Source: ABdhPJyPJKUjx5OQIumhTyzp5EB1OwduSeQGNOe/QOByCordY1RiCft0Wmk7RGWmhw0SEMMzHjBfCg==
X-Received: by 2002:a17:902:d4c1:: with SMTP id o1mr2995240plg.167.1644295874393;
        Mon, 07 Feb 2022 20:51:14 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8f56:515b:a442:2bd5])
        by smtp.gmail.com with ESMTPSA id j23sm9810257pgb.75.2022.02.07.20.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 20:51:14 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 07/11] ip6mr: introduce ip6mr_net_exit_batch()
Date:   Mon,  7 Feb 2022 20:50:34 -0800
Message-Id: <20220208045038.2635826-8-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
In-Reply-To: <20220208045038.2635826-1-eric.dumazet@gmail.com>
References: <20220208045038.2635826-1-eric.dumazet@gmail.com>
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
Reviewed-by: David Ahern <dsahern@kernel.org>
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

