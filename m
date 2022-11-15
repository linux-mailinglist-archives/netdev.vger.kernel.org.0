Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3716293F3
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237899AbiKOJLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237885AbiKOJLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:11:14 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32804B52
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:11:13 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-373582569edso129029167b3.2
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/KnDPmLiLROE2x+/oI+9SLuVYCuUAikRvTz6TZve5eg=;
        b=SiFwt1Maic3Hskls/JE6DELx9xMsqexIwazw57Hiw5sEj8Eb//Lt+4QVwYDnQUjFwC
         WsqWT/bl4fBuIPIDn4ekxKPT5zbH5TDtCvld+q2SXMTYoUfqgDxm+KXv3wQkEAhUxqZk
         lO+UdM/FEPPPBFXftOA7+8XvQydzThPAjja1FZLO1b7UsyeLMvanBNUkvhVz0r2uKhVB
         wILs0LTb8S9ru/IfXD6zHfY7zQg6O3y6g05g1P8QyGQqg3YjHlBdgzibCmusa9XlQZO4
         kMYsQaOnBWoSpclO72rirul3LjZTLsiy9hC/tCbXImwDR6J7VXCS6rKP0pXG+laOEkAF
         yxMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/KnDPmLiLROE2x+/oI+9SLuVYCuUAikRvTz6TZve5eg=;
        b=c7r1Lwq87PHkZtb6vj9GIABzybfUCV45qTtYBZ++dF2zbiWewNcG1CuaOP5gfItXmA
         P2bmBItGgUJnFCKropix6U5dyjUnUeIgZcKb+xE4OC5pVYCzAf+LDOljhy81MGAlPkP9
         qnKRu2SnFwuA56uKqFpBigpA+EZb8jNziBJgxyaCPOP3IrD5Bk8mFXsYkGMOLmXjv3Md
         Fq6BwTWKu1J9IWDJwpliZpjMqKqy2Pijlr9oUv5w+Wq4RvyETmaTKLEdMDXvVXnIX4kH
         VP02LnIphbRfo1Tv+IKcVegVuFA8BROpLIvq8+QYw4PxsK5aJNXjW3Wzafu1omZwIfCj
         7Aww==
X-Gm-Message-State: ANoB5pmBvshV7utqwIDeez9UVefslPppQtwLTMUJXt3h/K3FZJNXrFBV
        iViYiYj24JHlWuFAHHKnq9AMp/YVGX7FlQ==
X-Google-Smtp-Source: AA0mqf4d7gvPBejyqmSOpYyr3Pf/YswwIitZGipRZbXHtyt0FEYHiC0efPqJatJsozEgjLoPy0u5nyPdL8iOWw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:ca4f:0:b0:6cc:6a92:7a17 with SMTP id
 a76-20020a25ca4f000000b006cc6a927a17mr16011719ybg.282.1668503472536; Tue, 15
 Nov 2022 01:11:12 -0800 (PST)
Date:   Tue, 15 Nov 2022 09:11:00 +0000
In-Reply-To: <20221115091101.2234482-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221115091101.2234482-1-edumazet@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115091101.2234482-6-edumazet@google.com>
Subject: [PATCH net-next 5/6] net: adopt try_cmpxchg() in napi_{enable|disable}()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes code a bit cleaner.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 0c12c7ad04f21da05fef4c60ca5570bff48ec491..fb943dad96513e0f9eb1c3ce30c5bb7170edea5e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6397,8 +6397,8 @@ void napi_disable(struct napi_struct *n)
 	might_sleep();
 	set_bit(NAPI_STATE_DISABLE, &n->state);
 
-	for ( ; ; ) {
-		val = READ_ONCE(n->state);
+	val = READ_ONCE(n->state);
+	do {
 		if (val & (NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC)) {
 			usleep_range(20, 200);
 			continue;
@@ -6406,10 +6406,7 @@ void napi_disable(struct napi_struct *n)
 
 		new = val | NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC;
 		new &= ~(NAPIF_STATE_THREADED | NAPIF_STATE_PREFER_BUSY_POLL);
-
-		if (cmpxchg(&n->state, val, new) == val)
-			break;
-	}
+	} while (!try_cmpxchg(&n->state, &val, new));
 
 	hrtimer_cancel(&n->timer);
 
@@ -6426,16 +6423,15 @@ EXPORT_SYMBOL(napi_disable);
  */
 void napi_enable(struct napi_struct *n)
 {
-	unsigned long val, new;
+	unsigned long new, val = READ_ONCE(n->state);
 
 	do {
-		val = READ_ONCE(n->state);
 		BUG_ON(!test_bit(NAPI_STATE_SCHED, &val));
 
 		new = val & ~(NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC);
 		if (n->dev->threaded && n->thread)
 			new |= NAPIF_STATE_THREADED;
-	} while (cmpxchg(&n->state, val, new) != val);
+	} while (!try_cmpxchg(&n->state, &val, new));
 }
 EXPORT_SYMBOL(napi_enable);
 
-- 
2.38.1.431.g37b22c650d-goog

