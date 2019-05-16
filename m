Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 316E01FDC4
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 04:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfEPCkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 22:40:01 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:48155 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfEPCkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 22:40:01 -0400
Received: by mail-pf1-f201.google.com with SMTP id r75so1170274pfc.15
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 19:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=EHZcq62/FV/j/Z+viEbcBYxM6riJuDHBG8cItPgqXSE=;
        b=RppkjVy21wQRh4UucaWkGKOCUk1S2z3hePMj26g+8K545vRtKljFnKSDImNK59lMSP
         d2PD4VEz//Wz8IckTi+/FNDBLU4YPDxZ51zvFz8O7VY31T2V8CEEIFph2DKGeDYIR0me
         jyviQ8h23FQ/Q9jpuattAJnlfAu4gXGZ1P34sTmvPVA2Mvn2OGTu6SYWKCqEe3DWvGx6
         M2wzU7jNABeUbb7nwuXBqfpPAnlNoIGZ76RW3kRWGLeG/dwyGeSK5/7PavoUfIRehVtQ
         lm19n/H9pq26GtFQ2swjiBlq10mYFs0cStbL+s797Cvfbs2J7DWy08ydYODQBMEAp17s
         UjbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=EHZcq62/FV/j/Z+viEbcBYxM6riJuDHBG8cItPgqXSE=;
        b=fGXVDX7NxPmZecXR77Uhu4NLQWPYB1TqfQ51AA+kRYttC32dVCBhyohT8zWiGpQoqi
         Xw8GQ6fVhYXwRMBMBsQ+IBMBOZmSVglgoRqnlbNeRq66cem0IAZxqA8GGtWY9aQoDFqY
         wqxWVkQTnSExRLHVtGkyLYKtuHM1kWhol4lAo/ABCpKUBvRAIu/9RghkTlkaEZz39zc1
         AK230hLbWEFC9rL8f5HbSL1uFWNtLGY3FXYJKyJ4xbiNsNgHdj5mSIphIshECsUl95pS
         qyBpPygLwHVMrLm69Pa3xEF6U71qsgt3sskQacrFew2bju4rzTSGRDPSYkhDOhB4sIR0
         bQIQ==
X-Gm-Message-State: APjAAAU3b1rU1oc5sFnYN+IyVCtrhp3JCXcvpU5Ou2maax/P2ndRRsN0
        BuqYUO4lDTR+0wqe3tVAkKvmr/Zn1bbEkA==
X-Google-Smtp-Source: APXvYqzjb/COro6HSnilmHI96Fk6z9bMlv8gMFyF+Q+QSEwjypA6gqfiXtdABy+rhKg6d96s4Y022j1Ox6lNww==
X-Received: by 2002:a63:8b4b:: with SMTP id j72mr47667281pge.318.1557974400356;
 Wed, 15 May 2019 19:40:00 -0700 (PDT)
Date:   Wed, 15 May 2019 19:39:52 -0700
Message-Id: <20190516023952.28943-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH net] ipv6: prevent possible fib6 leaks
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Wei Wang <weiwan@google.com>, David Ahern <dsahern@gmail.com>,
        Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At ipv6 route dismantle, fib6_drop_pcpu_from() is responsible
for finding all percpu routes and set their ->from pointer
to NULL, so that fib6_ref can reach its expected value (1).

The problem right now is that other cpus can still catch the
route being deleted, since there is no rcu grace period
between the route deletion and call to fib6_drop_pcpu_from()

This can leak the fib6 and associated resources, since no
notifier will take care of removing the last reference(s).

I decided to add another boolean (fib6_destroying) instead
of reusing/renaming exception_bucket_flushed to ease stable backports,
and properly document the memory barriers used to implement this fix.

This patch has been co-developped with Wei Wang.

Fixes: 93531c674315 ("net/ipv6: separate handling of FIB entries from dst based routes")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Wei Wang <weiwan@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Martin Lau <kafai@fb.com>
---
 include/net/ip6_fib.h |  3 ++-
 net/ipv6/ip6_fib.c    | 12 +++++++++---
 net/ipv6/route.c      |  7 +++++++
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 40105738e2f6b8e37adac1ff46879ce6c09381b8..525f701653ca69596b941f5f3b4a438d634c4e6c 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -167,7 +167,8 @@ struct fib6_info {
 					dst_nocount:1,
 					dst_nopolicy:1,
 					dst_host:1,
-					unused:3;
+					fib6_destroying:1,
+					unused:2;
 
 	struct fib6_nh			fib6_nh;
 	struct rcu_head			rcu;
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 08e0390e001c270ae21013f3fd3ef3bf2a52e039..008421b550c6bfd449665aa5e7ba5505fcabe53d 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -904,6 +904,12 @@ static void fib6_drop_pcpu_from(struct fib6_info *f6i,
 {
 	int cpu;
 
+	/* Make sure rt6_make_pcpu_route() wont add other percpu routes
+	 * while we are cleaning them here.
+	 */
+	f6i->fib6_destroying = 1;
+	mb(); /* paired with the cmpxchg() in rt6_make_pcpu_route() */
+
 	/* release the reference to this fib entry from
 	 * all of its cached pcpu routes
 	 */
@@ -927,6 +933,9 @@ static void fib6_purge_rt(struct fib6_info *rt, struct fib6_node *fn,
 {
 	struct fib6_table *table = rt->fib6_table;
 
+	if (rt->rt6i_pcpu)
+		fib6_drop_pcpu_from(rt, table);
+
 	if (refcount_read(&rt->fib6_ref) != 1) {
 		/* This route is used as dummy address holder in some split
 		 * nodes. It is not leaked, but it still holds other resources,
@@ -948,9 +957,6 @@ static void fib6_purge_rt(struct fib6_info *rt, struct fib6_node *fn,
 			fn = rcu_dereference_protected(fn->parent,
 				    lockdep_is_held(&table->tb6_lock));
 		}
-
-		if (rt->rt6i_pcpu)
-			fib6_drop_pcpu_from(rt, table);
 	}
 }
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 23a20d62daac29e3252725b8cf95d1d1c2b567c4..27c0cc5d9d30e3689ebe6b8428cd4c586669d808 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1295,6 +1295,13 @@ static struct rt6_info *rt6_make_pcpu_route(struct net *net,
 	prev = cmpxchg(p, NULL, pcpu_rt);
 	BUG_ON(prev);
 
+	if (res->f6i->fib6_destroying) {
+		struct fib6_info *from;
+
+		from = xchg((__force struct fib6_info **)&pcpu_rt->from, NULL);
+		fib6_info_release(from);
+	}
+
 	return pcpu_rt;
 }
 
-- 
2.21.0.1020.gf2820cf01a-goog

