Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8934AD0E7
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 06:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiBHFdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 00:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347046AbiBHEvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:51:11 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5255DC0401E5
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 20:51:11 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id c3so12877738pls.5
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 20:51:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zsNMXE+P45OQsH5Dutxol2CPtyXwO7PMwPm5gWuakjs=;
        b=Dy6sluPV98pHSN6HjX+d8ZqNevr0X2lkD9OOBtGZbFN9bMeVHLFXdKlnq6Tk4MW46S
         0A231bN7Jhum+BX05rh6EKpoPC6FBtwsLFJjFGDd/RPPal72Wo3T3tD8elcy0U6mAx/e
         Xldxu7YNVjigA7yI4U6x+behMo13vOimBDO+gNhK6ZNtG5yV8ohBNaqpQgD1zJOSbN0N
         d9JyiC9ozru5VzIqy7BUJQQgT8OI5hNLRMvBOOHe0IFJrg2QHm2b2MSu1IS0aHpauYbt
         0XEMDF4eH2urPyAKxbzrpXnwy7LYWzQLSRfAnWAYXQLiKKaOT1nq7BThTE4kSAZJW03l
         NMzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zsNMXE+P45OQsH5Dutxol2CPtyXwO7PMwPm5gWuakjs=;
        b=ZRYvudOMvx7zTgjE5kOMQ8vWVv9NalE/YWuWbYO47lrzZDcNvkQHmqUrx6P1YhlCqM
         7+torR+NS+ARl7aOZQtU8690VCpinucNf2auZraL6mJoC+sJzl2KvfoSAmXkg+Ahnhkk
         7vfY5VeM8Y5I1dLtZWRcNU3aYiNYHTtEiMgAH+QIZL2ylkR1jADqShOOZgN9BtkFvBmn
         8fjwgn3xh9yEep0VMhjAF9bZrGFutnFPKPdAKPDFRAYduErKbYF3ahcu18YVGItQjc28
         aBsYaQ89n8dZlDoiiwjqTBwsgLvXsFW1ocdQvUjHHTQj0TVk9iefI++kTIUotIIOcbu3
         YSYw==
X-Gm-Message-State: AOAM531HcTPtrrc5W9Og+66Mez6OL0l4Nj/EfBqW9iYcWArV7a1XqYmQ
        Waa3CxNza8FJSO/I+7J/GYk=
X-Google-Smtp-Source: ABdhPJwUjvW9Zg1bEeA7mdRcRMHLLqLe3BJ8f5/tyB37sAcjWuaoJol53x7D5Tw5lxUf0sGl1RycDw==
X-Received: by 2002:a17:902:8ec5:: with SMTP id x5mr2791258plo.161.1644295870893;
        Mon, 07 Feb 2022 20:51:10 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8f56:515b:a442:2bd5])
        by smtp.gmail.com with ESMTPSA id j23sm9810257pgb.75.2022.02.07.20.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 20:51:10 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 06/11] ipv6: change fib6_rules_net_exit() to batch mode
Date:   Mon,  7 Feb 2022 20:50:33 -0800
Message-Id: <20220208045038.2635826-7-eric.dumazet@gmail.com>
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

fib6_rules_net_exit() seems a good candidate for exit_batch(),
as this gives chance for cleanup_net() to progress much faster,
holding rtnl a bit longer.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 net/ipv6/fib6_rules.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index ec029c86ae06828c1cfe886ad0f401318b114310..8ad4f49cbe0bb1a31645bbdd4735c69b9b52d8bb 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -486,16 +486,21 @@ static int __net_init fib6_rules_net_init(struct net *net)
 	goto out;
 }
 
-static void __net_exit fib6_rules_net_exit(struct net *net)
+static void __net_exit fib6_rules_net_exit_batch(struct list_head *net_list)
 {
+	struct net *net;
+
 	rtnl_lock();
-	fib_rules_unregister(net->ipv6.fib6_rules_ops);
+	list_for_each_entry(net, net_list, exit_list) {
+		fib_rules_unregister(net->ipv6.fib6_rules_ops);
+		cond_resched();
+	}
 	rtnl_unlock();
 }
 
 static struct pernet_operations fib6_rules_net_ops = {
 	.init = fib6_rules_net_init,
-	.exit = fib6_rules_net_exit,
+	.exit_batch = fib6_rules_net_exit_batch,
 };
 
 int __init fib6_rules_init(void)
-- 
2.35.0.263.gb82422642f-goog

