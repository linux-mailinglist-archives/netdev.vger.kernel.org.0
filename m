Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98FAA624A10
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 20:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiKJTCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 14:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiKJTCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 14:02:42 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A505B31EE1
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 11:02:41 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3735edd4083so24269787b3.0
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 11:02:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+GkBRanQJoPDlLARop/W3q/va8TContehPM8t17+Cu4=;
        b=OwnvuwfUfm6HTNHe+CU6HfTmJ2R3ljA0rbkzDZCw3SoUD5nFg+V0Bc1OZ8WMP2NtYH
         HwbBYlijGo6KMBoCb3MVl/VG57/drwnYhvOcPQwxEN10KgRx2yS0lKXsMat04P4QhUfb
         rpX/1pqKckc3wicWrYiaM7bVrCv5KOO+0AYmNn9kc4HttdM8vJsDf1w1CsRDrq8FJo2A
         mf8Pv43nD4bjS/cZIYJIXa2FGPX2Dh7HxnIPSYQjr7zLT6NyKbfn2QUBmTDd+5VQytx6
         yGkE7+VPY1L4+ufABFH571Qdivmrctfupr+5aTmY5XaFxHyNsd+QH9c/7cJHev+tN7E6
         2lGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+GkBRanQJoPDlLARop/W3q/va8TContehPM8t17+Cu4=;
        b=cFG7y8ipQSHsl5S9HA/guXrzH1hKpC4lKh7x+e3bpFGGLx46XF0B/OejJFKkcfIeF/
         pJ3NOeMKGL2xkyxTGLTogGCzwo4lU3462ctGAMgDAtHkt9lOb574FzVFSR3OGxOsieNJ
         YeuRYn1bZm7XNxsJyKN1ew6eNxn6FUl2mYGiz48A4VltD9fSdz6HPh+J854UNTexjCT5
         32p8Lx443XVsKFTMAd28Y4UJqY+rHwnYbtYA3gA6HrOc0QlOY2KGhURtokl+IbDVm5DT
         OsoB5edmcgVArK8EutogLAA0t63JXxTdG0mQxb8H7dmOBt18wDnaac18W8rZK6QQf2a8
         2rxA==
X-Gm-Message-State: ACrzQf1JuoenUageuMgYgB6VCZdhUR7vX4W5shhHTmvg8H1650fMq9WZ
        WHhSrKip4FZWUqwrqrS+1Bsfp3qEXLBqTQ==
X-Google-Smtp-Source: AMsMyM5GRA9+XFDCb4aaGMfK4/HK88ibirGozwVoz4W5v9S9nT7w2yeSZNB/dMaQcFndYPzPRWi7+SqJK3yCmQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:5216:0:b0:373:6d43:2edd with SMTP id
 g22-20020a815216000000b003736d432eddmr1155114ywb.441.1668106960915; Thu, 10
 Nov 2022 11:02:40 -0800 (PST)
Date:   Thu, 10 Nov 2022 19:02:39 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221110190239.3531280-1-edumazet@google.com>
Subject: [PATCH net-next] tcp: tcp_wfree() refactoring
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

Use try_cmpxchg() (instead of cmpxchg()) in a more readable way.

oval = smp_load_acquire(&sk->sk_tsq_flags);
do {
	...
} while (!try_cmpxchg(&sk->sk_tsq_flags, &oval, nval));

Reduce indentation level.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_output.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index d1cb1ecf8f216dc810ca08ea35ae752fd19ba706..894410dc9293680d6944a1ad9186f2ab504734eb 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1139,6 +1139,8 @@ void tcp_wfree(struct sk_buff *skb)
 	struct sock *sk = skb->sk;
 	struct tcp_sock *tp = tcp_sk(sk);
 	unsigned long flags, nval, oval;
+	struct tsq_tasklet *tsq;
+	bool empty;
 
 	/* Keep one reference on sk_wmem_alloc.
 	 * Will be released by sk_free() from here or tcp_tasklet_func()
@@ -1155,28 +1157,23 @@ void tcp_wfree(struct sk_buff *skb)
 	if (refcount_read(&sk->sk_wmem_alloc) >= SKB_TRUESIZE(1) && this_cpu_ksoftirqd() == current)
 		goto out;
 
-	for (oval = READ_ONCE(sk->sk_tsq_flags);; oval = nval) {
-		struct tsq_tasklet *tsq;
-		bool empty;
-
+	oval = smp_load_acquire(&sk->sk_tsq_flags);
+	do {
 		if (!(oval & TSQF_THROTTLED) || (oval & TSQF_QUEUED))
 			goto out;
 
 		nval = (oval & ~TSQF_THROTTLED) | TSQF_QUEUED;
-		nval = cmpxchg(&sk->sk_tsq_flags, oval, nval);
-		if (nval != oval)
-			continue;
+	} while (!try_cmpxchg(&sk->sk_tsq_flags, &oval, nval));
 
-		/* queue this socket to tasklet queue */
-		local_irq_save(flags);
-		tsq = this_cpu_ptr(&tsq_tasklet);
-		empty = list_empty(&tsq->head);
-		list_add(&tp->tsq_node, &tsq->head);
-		if (empty)
-			tasklet_schedule(&tsq->tasklet);
-		local_irq_restore(flags);
-		return;
-	}
+	/* queue this socket to tasklet queue */
+	local_irq_save(flags);
+	tsq = this_cpu_ptr(&tsq_tasklet);
+	empty = list_empty(&tsq->head);
+	list_add(&tp->tsq_node, &tsq->head);
+	if (empty)
+		tasklet_schedule(&tsq->tasklet);
+	local_irq_restore(flags);
+	return;
 out:
 	sk_free(sk);
 }
-- 
2.38.1.431.g37b22c650d-goog

