Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4184AD0FB
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 06:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242961AbiBHFd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 00:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347044AbiBHEvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:51:08 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C99C0401E5
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 20:51:07 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id u130so16839063pfc.2
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 20:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MO0sIC6aoDSHuE1A77wb7716OltOM6QAoh5qnGMh2Os=;
        b=nUiSgYkcAATTYcKmRrIUmZ2D70W7aZUVeLkwWoacnQrT9IdEJWdIMWpEHPyacz9TNr
         aXR+ZaMu7Wl/pOZJ1Fdm7ZcoXHgQT4Fc/fjB/xESEp01bq5s8CUYpJa6yW3MgiQDAs2r
         OIWzVSEbY2TGKDgRqFsokJmmgC0jZulmdDMm6R383ewjMZX4f95qTwJ6GgfhGutKdK/X
         EUOTAcCvrrseBeAQB7u7OpLEC6CeYohcb4tMaR4jcl/99KDcTF63+38n+L1pgPmJzEam
         RGdpKSNOsfBC7QDTpskxArzSVgpz6mrE5PJcq6VKlyAO8r6l7G6TOLV78iMdG8CQC8mB
         3Vnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MO0sIC6aoDSHuE1A77wb7716OltOM6QAoh5qnGMh2Os=;
        b=p+fYDxpwPsZxvY0QGlMSdXYp6J96zVmzI6c4ZLiFR3O/jDBNexebvvZPQ4ZLSHMDKq
         KcCu0e/0kjwWd2fGLsGOKB1azweO15HSiXsJ4V27dto5Da+JPoTl9dWvQMgS+H7leG+q
         BgNBlzi9rGcidtiNVHsW6er7rxCqFmS5+2ZyX8OoLQTZbQoLZ2ogk3kAoZ9Y+UI1J5IG
         0ICHjxMiD9gDMywg9tHnP4z76z7s9Ai8Ygj6PJZ3VOokw0yizWmAbfAP9X7KUrCBtSo/
         x+rJ8VeRGSOTV+iyqCKH0hIksUg2EpRXvga5dzRAm7TzpAAj5ONgpUV8uadcucZnglUs
         wRxg==
X-Gm-Message-State: AOAM533W1vEJwWnswVIvnTJUNsQEHMC6I72QYPRvEAEX1Ow+WVFo8bfH
        B7m6IQ1HpDxKViZ+xewEfRw=
X-Google-Smtp-Source: ABdhPJwksc0PYZZqCsTLGAhfRJfxmh/cuQhzoGyaOL4JE4KByUsmRTVKwjvijW7YG8XiPiNpRPphQA==
X-Received: by 2002:a05:6a00:1588:: with SMTP id u8mr2690475pfk.4.1644295867415;
        Mon, 07 Feb 2022 20:51:07 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8f56:515b:a442:2bd5])
        by smtp.gmail.com with ESMTPSA id j23sm9810257pgb.75.2022.02.07.20.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 20:51:07 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 05/11] ipv4: add fib_net_exit_batch()
Date:   Mon,  7 Feb 2022 20:50:32 -0800
Message-Id: <20220208045038.2635826-6-eric.dumazet@gmail.com>
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

Instead of acquiring rtnl at each fib_net_exit() invocation,
add fib_net_exit_batch() so that rtnl is acquired once.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 net/ipv4/fib_frontend.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 4d61ddd8a0ecfc4cc47b4802eb5a573beb84ee44..8c10f671d24db7f5751b6aed8e90a902bd1be5b4 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1547,7 +1547,7 @@ static void ip_fib_net_exit(struct net *net)
 {
 	int i;
 
-	rtnl_lock();
+	ASSERT_RTNL();
 #ifdef CONFIG_IP_MULTIPLE_TABLES
 	RCU_INIT_POINTER(net->ipv4.fib_main, NULL);
 	RCU_INIT_POINTER(net->ipv4.fib_default, NULL);
@@ -1572,7 +1572,7 @@ static void ip_fib_net_exit(struct net *net)
 #ifdef CONFIG_IP_MULTIPLE_TABLES
 	fib4_rules_exit(net);
 #endif
-	rtnl_unlock();
+
 	kfree(net->ipv4.fib_table_hash);
 	fib4_notifier_exit(net);
 }
@@ -1599,7 +1599,9 @@ static int __net_init fib_net_init(struct net *net)
 out_proc:
 	nl_fib_lookup_exit(net);
 out_nlfl:
+	rtnl_lock();
 	ip_fib_net_exit(net);
+	rtnl_unlock();
 	goto out;
 }
 
@@ -1607,12 +1609,23 @@ static void __net_exit fib_net_exit(struct net *net)
 {
 	fib_proc_exit(net);
 	nl_fib_lookup_exit(net);
-	ip_fib_net_exit(net);
+}
+
+static void __net_exit fib_net_exit_batch(struct list_head *net_list)
+{
+	struct net *net;
+
+	rtnl_lock();
+	list_for_each_entry(net, net_list, exit_list)
+		ip_fib_net_exit(net);
+
+	rtnl_unlock();
 }
 
 static struct pernet_operations fib_net_ops = {
 	.init = fib_net_init,
 	.exit = fib_net_exit,
+	.exit_batch = fib_net_exit_batch,
 };
 
 void __init ip_fib_init(void)
-- 
2.35.0.263.gb82422642f-goog

