Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3E8433345
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 12:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235161AbhJSKOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 06:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbhJSKOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 06:14:21 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACABDC06161C;
        Tue, 19 Oct 2021 03:12:08 -0700 (PDT)
Date:   Tue, 19 Oct 2021 12:12:04 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634638326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XaZwPDPs6BMm72bV5GUdA1x8BDUEwYwXG80Oi6+Fk0c=;
        b=ifcSVBMPwIh5u0RlwHXmeIb6uIpqC1z7gSos7kWMbcw2ZRn8XHMRTEDkFeh5BdMo0ktUko
        moz367j5I3NTWaG7xwhqfEUQ9XS6e7rhgte7OCKR11P3ulB8VUqFA94iqrs1KeXOipyEg5
        dFarYCszI68NESnl945bZ5OpI4qzkV/WY3DKFBRQMt5kmBnqHbBI6SN9wegMOellKgRo8U
        XPsf2w9fKj4bMiW/LcYPYKylt2q3NMwKRN8LidXhj0RkThJmH63k9lYyApL9AidB7vGWby
        sTp3sJMnQwL+jd92Pkoe6JZh2gLsqLz/pdsMAO1/HTnv8d9rEKpv/YnMXsDySA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634638326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XaZwPDPs6BMm72bV5GUdA1x8BDUEwYwXG80Oi6+Fk0c=;
        b=7VKmpizP5d/w3vw5EPG7U7oVx04GLSZ2peCzRlohVhvZ+MaBl4yLOdyP1ppB5iUJOU/I9x
        4XnpzfhKjjrJr5DQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH net-next] net: sched: Allow statistics reads from softirq.
Message-ID: <20211019101204.4a7m2i3u5uoqrc6b@linutronix.de>
References: <20211016084910.4029084-1-bigeasy@linutronix.de>
 <20211016084910.4029084-10-bigeasy@linutronix.de>
 <1cdc197a-f9c8-34e4-b19c-132dbbbcafb5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1cdc197a-f9c8-34e4-b19c-132dbbbcafb5@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric reported that the rate estimator reads statics from the softirq
which in turn triggers a warning introduced in the statistics rework.

The warning is too cautious. The updates happen in the softirq context
so reads from softirq are fine since the writes can not be preempted.
The updates/writes happen during qdisc_run() which ensures one writer
and the softirq context.
The remaining bad context for reading statistics remains in hard-IRQ
because it may preempt a writer.

Fixes: 29cbcd8582837 ("net: sched: Remove Qdisc::running sequence counter")
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/core/gen_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
index 5516ea0d5da0b..15c270e22c5ef 100644
--- a/net/core/gen_stats.c
+++ b/net/core/gen_stats.c
@@ -154,7 +154,7 @@ void gnet_stats_add_basic(struct gnet_stats_basic_sync *bstats,
 	u64 bytes = 0;
 	u64 packets = 0;
 
-	WARN_ON_ONCE((cpu || running) && !in_task());
+	WARN_ON_ONCE((cpu || running) && in_hardirq());
 
 	if (cpu) {
 		gnet_stats_add_basic_cpu(bstats, cpu);
-- 
2.33.0

