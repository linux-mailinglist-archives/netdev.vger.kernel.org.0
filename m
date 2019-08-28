Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBF69F862
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 04:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbfH1Cj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 22:39:27 -0400
Received: from out1.zte.com.cn ([202.103.147.172]:42878 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbfH1Cj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 22:39:27 -0400
Received: from mse-fl2.zte.com.cn (unknown [10.30.14.239])
        by Forcepoint Email with ESMTPS id 2AF0C45E1332F6B18411;
        Wed, 28 Aug 2019 10:39:25 +0800 (CST)
Received: from notes_smtp.zte.com.cn (notessmtp.zte.com.cn [10.30.1.239])
        by mse-fl2.zte.com.cn with ESMTP id x7S2JCiK083635;
        Wed, 28 Aug 2019 10:19:12 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019082810193054-3226640 ;
          Wed, 28 Aug 2019 10:19:30 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn,
        wang.liang82@zte.com.cn, Cheng Lin <cheng.lin130@zte.com.cn>
Subject: [PATCH v2] ipv6: Not to probe neighbourless routes
Date:   Wed, 28 Aug 2019 10:19:25 +0800
Message-Id: <1566958765-1686-1-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-08-28 10:19:30,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-08-28 10:19:14,
        Serialize complete at 2019-08-28 10:19:14
X-MAIL: mse-fl2.zte.com.cn x7S2JCiK083635
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cheng Lin <cheng.lin130@zte.com.cn>

Originally, Router Reachability Probing require a neighbour entry
existed. Commit 2152caea7196 ("ipv6: Do not depend on rt->n in
rt6_probe().") removed the requirement for a neighbour entry. And
commit f547fac624be ("ipv6: rate-limit probes for neighbourless
routes") adds rate-limiting for neighbourless routes.

And, the Neighbor Discovery for IP version 6 (IPv6)(rfc4861) says,
"
7.2.5.  Receipt of Neighbor Advertisements

When a valid Neighbor Advertisement is received (either solicited or
unsolicited), the Neighbor Cache is searched for the target's entry.
If no entry exists, the advertisement SHOULD be silently discarded.
There is no need to create an entry if none exists, since the
recipient has apparently not initiated any communication with the
target.
".

In rt6_probe(), just a Neighbor Solicitation message are transmited.
When receiving a Neighbor Advertisement, the node does nothing in a
Neighborless condition.

Not sure it's needed to create a neighbor entry in Router
Reachability Probing. And the Original way may be the right way.

This patch recover the requirement for a neighbour entry.

Signed-off-by: Cheng Lin <cheng.lin130@zte.com.cn>
---
 include/net/ip6_fib.h | 5 -----
 net/ipv6/route.c      | 6 +-----
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 4b5656c..8c2e022 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -124,11 +124,6 @@ struct rt6_exception {
 
 struct fib6_nh {
 	struct fib_nh_common	nh_common;
-
-#ifdef CONFIG_IPV6_ROUTER_PREF
-	unsigned long		last_probe;
-#endif
-
 	struct rt6_info * __percpu *rt6i_pcpu;
 	struct rt6_exception_bucket __rcu *rt6i_exception_bucket;
 };
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index fd059e0..1839dd7 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -639,12 +639,12 @@ static void rt6_probe(struct fib6_nh *fib6_nh)
 	nh_gw = &fib6_nh->fib_nh_gw6;
 	dev = fib6_nh->fib_nh_dev;
 	rcu_read_lock_bh();
-	idev = __in6_dev_get(dev);
 	neigh = __ipv6_neigh_lookup_noref(dev, nh_gw);
 	if (neigh) {
 		if (neigh->nud_state & NUD_VALID)
 			goto out;
 
+		idev = __in6_dev_get(dev);
 		write_lock(&neigh->lock);
 		if (!(neigh->nud_state & NUD_VALID) &&
 		    time_after(jiffies,
@@ -654,13 +654,9 @@ static void rt6_probe(struct fib6_nh *fib6_nh)
 				__neigh_set_probe_once(neigh);
 		}
 		write_unlock(&neigh->lock);
-	} else if (time_after(jiffies, fib6_nh->last_probe +
-				       idev->cnf.rtr_probe_interval)) {
-		work = kmalloc(sizeof(*work), GFP_ATOMIC);
 	}
 
 	if (work) {
-		fib6_nh->last_probe = jiffies;
 		INIT_WORK(&work->work, rt6_probe_deferred);
 		work->target = *nh_gw;
 		dev_hold(dev);
-- 
1.8.3.1

