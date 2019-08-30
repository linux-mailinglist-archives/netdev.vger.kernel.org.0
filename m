Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6474CA2F6C
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 08:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbfH3GLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 02:11:15 -0400
Received: from mxhk.zte.com.cn ([63.217.80.70]:46068 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbfH3GLP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 02:11:15 -0400
Received: from mse-fl2.zte.com.cn (unknown [10.30.14.239])
        by Forcepoint Email with ESMTPS id F1867EBCD69760BD4332;
        Fri, 30 Aug 2019 14:11:12 +0800 (CST)
Received: from notes_smtp.zte.com.cn (notes_smtp.zte.com.cn [10.30.1.239])
        by mse-fl2.zte.com.cn with ESMTP id x7U6B1Mg089976;
        Fri, 30 Aug 2019 14:11:01 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019083014113696-3292051 ;
          Fri, 30 Aug 2019 14:11:36 +0800 
From:   Cheng Lin <wang.yi59@zte.com.cn>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn,
        wang.liang82@zte.com.cn, Cheng Lin <cheng.lin130@zte.com.cn>
Subject: [PATCH v3] ipv6: Not to probe neighbourless routes
Date:   Fri, 30 Aug 2019 14:11:16 +0800
Message-Id: <1567145476-33802-1-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-08-30 14:11:37,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-08-30 14:11:06,
        Serialize complete at 2019-08-30 14:11:06
X-MAIL: mse-fl2.zte.com.cn x7U6B1Mg089976
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

