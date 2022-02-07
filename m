Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A454AC74A
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358029AbiBGR1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384318AbiBGRSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:18:20 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4589BC0401D5
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:18:20 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id v4so7601281pjh.2
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 09:18:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4MfbMaZu275dw5aSyof6NzcxX8JCYParEayV3uN2EHs=;
        b=U87s9MdCw5CPdWle4eD6x9sKigZuC9bnXiVerULZ8FLeEfMQ2RmlxXehKL5FxWN0ZI
         5fYxSjvLHNYN9CTPBtkj+owf1YsEf1y/nsdHEvqcFt8HvEbXdm94g6FGukQJ+mXCreKN
         rLQE019SIQxe96GTNeF9KmdzMlmSJ1+i+qKIFMFPPZ7r6/1HlPgx3EtZ3F8CoryBl5t1
         KW9l563V+SIDfqOpw97UZpsQeJeK2bJx8VOgDGKmXVgntCxmbxD0Ah5IrslN8Lqrw00N
         xjoZkCaBEs8LquxYKopml8XklHwqrJ+bGdI/mAsSFfhIAH1N/e6Kh/hr57vPaGhAXoD9
         T40g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4MfbMaZu275dw5aSyof6NzcxX8JCYParEayV3uN2EHs=;
        b=uaLURM8zcQGn/+q7UhJuR0KD+m2r6LINwyCYZ97/hfFdyLFf53YmGofx1NMB8A/ThZ
         YagBlOTasK+qOyVWdIwnkBz/1r2GSdtyvyxYl3VX+k6A7XOXOE5Y3bAITePwDmovGL35
         9MDKAuVVdZsOMzDxB8DozzIo1O5PJw9v9cx/JpFyk0he/3d6cJJZyECQtJ7cSIWM4ewb
         lllQAbz+WXXsHz1N9SkRCrDRKSHVth891RVmVd6yaXc7lFqjVwkg7hHhyxdcd3dfQ6rT
         b4UoMXCcaqLCNdtueKzOz3U1iFHvF3Al5Kp8OK9M55C8YFL3z9aS7p4tl6yej7gSILpy
         a5uw==
X-Gm-Message-State: AOAM531hkKL79FbB88DYB32sAhTxE698uJL1B2Sutju8nrti3DDPdk0e
        MQAjFGSNtidCUH3pc0/jxSu+Hnilx4s=
X-Google-Smtp-Source: ABdhPJwbPRp+xlzkD5iZwqBT2OIgqvQNYJupTXBRhQaNhQMNaBijnOkTpzYWPiQwl1u0ORw2fRnTZQ==
X-Received: by 2002:a17:902:da88:: with SMTP id j8mr574946plx.105.1644254299802;
        Mon, 07 Feb 2022 09:18:19 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6dea:218:38e6:9e0])
        by smtp.gmail.com with ESMTPSA id lr8sm24415156pjb.11.2022.02.07.09.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 09:18:19 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 06/11] ipv6: change fib6_rules_net_exit() to batch mode
Date:   Mon,  7 Feb 2022 09:17:51 -0800
Message-Id: <20220207171756.1304544-7-eric.dumazet@gmail.com>
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

fib6_rules_net_exit() seems a good candidate for exit_batch(),
as this gives chance for cleanup_net() to progress much faster,
holding rtnl a bit longer.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Ahern <dsahern@kernel.org>
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

