Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF6BF4A1F5
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbfFRNVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:21:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42860 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbfFRNVC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 09:21:02 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 31CB04DB11;
        Tue, 18 Jun 2019 13:21:02 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.112.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A789860D28;
        Tue, 18 Jun 2019 13:20:59 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>, David Ahern <dsahern@gmail.com>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH net v5 5/6] ipv6: Dump route exceptions if requested
Date:   Tue, 18 Jun 2019 15:20:38 +0200
Message-Id: <364403cca3d7836557f8ffe83c9c48b436be76eb.1560827176.git.sbrivio@redhat.com>
In-Reply-To: <cover.1560827176.git.sbrivio@redhat.com>
References: <cover.1560827176.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 18 Jun 2019 13:21:02 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 2b760fcf5cfb ("ipv6: hook up exception table to store dst
cache"), route exceptions reside in a separate hash table, and won't be
found by walking the FIB, so they won't be dumped to userspace on a
RTM_GETROUTE message.

This causes 'ip -6 route list cache' and 'ip -6 route flush cache' to
have no function anymore:

 # ip -6 route get fc00:3::1
 fc00:3::1 via fc00:1::2 dev veth_A-R1 src fc00:1::1 metric 1024 expires 539sec mtu 1400 pref medium
 # ip -6 route get fc00:4::1
 fc00:4::1 via fc00:2::2 dev veth_A-R2 src fc00:2::1 metric 1024 expires 536sec mtu 1500 pref medium
 # ip -6 route list cache
 # ip -6 route flush cache
 # ip -6 route get fc00:3::1
 fc00:3::1 via fc00:1::2 dev veth_A-R1 src fc00:1::1 metric 1024 expires 520sec mtu 1400 pref medium
 # ip -6 route get fc00:4::1
 fc00:4::1 via fc00:2::2 dev veth_A-R2 src fc00:2::1 metric 1024 expires 519sec mtu 1500 pref medium

because iproute2 lists cached routes using RTM_GETROUTE, and flushes them
by listing all the routes, and deleting them with RTM_DELROUTE one by one.

If cached routes are requested using the RTM_F_CLONED flag together with
strict checking, or if no strict checking is requested (and hence we can't
consistently apply filters), look up exceptions in the hash table
associated with the current fib6_info in rt6_dump_route(), and, if present
and not expired, add them to the dump.

We might be unable to dump all the entries for a given node in a single
message, so keep track of how many entries were handled for the current
node in fib6_walker, and skip that amount in case we start from the same
partially dumped node.

Note that, with the current version of iproute2, this only fixes the
'ip -6 route list cache': on a flush command, iproute2 doesn't pass
RTM_F_CLONED and, due to this inconsistency, 'ip -6 route flush cache' is
still unable to fetch the routes to be flushed. This is now addressed in a
patch for iproute2.

To flush cached routes, a procfs entry could be introduced instead: that's
how it works for IPv4. We already have a rt6_flush_exception() function
ready to be wired to it. However, this would not solve the issue for
listing.

Versions of iproute2 and kernel tested:

                    iproute2
kernel             4.14.0   4.15.0   4.19.0   5.0.0   5.1.0    5.1.0, patched
 3.18    list        +        +        +        +       +            +
         flush       +        +        +        +       +            +
 4.4     list        +        +        +        +       +            +
         flush       +        +        +        +       +            +
 4.9     list        +        +        +        +       +            +
         flush       +        +        +        +       +            +
 4.14    list        +        +        +        +       +            +
         flush       +        +        +        +       +            +
 4.15    list
         flush
 4.19    list
         flush
 5.0     list
         flush
 5.1     list
         flush
 with    list        +        +        +        +       +            +
 fix     flush       +        +        +                             +

v5:
  - use dump_routes and dump_exceptions from filter, ignore NLM_F_MATCH,
    update test results (flushing works with iproute2 < 5.0.0 now)

v4:
  - split NLM_F_MATCH and strict check handling in separate patches
  - filter routes using RTM_F_CLONED: if it's not set, only return
    non-cached routes, and if it's set, only return cached routes:
    change requested by David Ahern and Martin Lau. This implies that
    iproute2 needs a separate patch to be able to flush IPv6 cached
    routes. This is not ideal because we can't fix the breakage caused
    by 2b760fcf5cfb entirely in kernel. However, two years have passed
    since then, and this makes it more tolerable

v3:
  - more descriptive comment about expired exceptions in rt6_dump_route()
  - swap return values of rt6_dump_route() (suggested by Martin Lau)
  - don't zero skip_in_node in case we don't dump anything in a given pass
    (also suggested by Martin Lau)
  - remove check on RTM_F_CLONED altogether: in the current UAPI semantic,
    it's just a flag to indicate the route was cloned, not to filter on
    routes

v2: Add tracking of number of entries to be skipped in current node after
    a partial dump. As we restart from the same node, if not all the
    exceptions for a given node fit in a single message, the dump will
    not terminate, as suggested by Martin Lau. This is a concrete
    possibility, setting up a big number of exceptions for the same route
    actually causes the issue, suggested by David Ahern.

Reported-by: Jianlin Shi <jishi@redhat.com>
Fixes: 2b760fcf5cfb ("ipv6: hook up exception table to store dst cache")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
This will cause a non-trivial conflict with commit cc5c073a693f
("ipv6: Move exception bucket to fib6_nh") on net-next. I can submit
an equivalent patch against net-next, if it helps.

 include/net/ip6_fib.h   |  1 +
 include/net/ip6_route.h |  2 +-
 net/ipv6/ip6_fib.c      | 14 ++++++-
 net/ipv6/route.c        | 85 +++++++++++++++++++++++++++++++++++------
 4 files changed, 87 insertions(+), 15 deletions(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 855b352b660f..5909a9d8ff67 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -312,6 +312,7 @@ struct fib6_walker {
 	enum fib6_walk_state state;
 	unsigned int skip;
 	unsigned int count;
+	unsigned int skip_in_node;
 	int (*func)(struct fib6_walker *);
 	void *args;
 };
diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 4790beaa86e0..b66c4aac56ab 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -178,7 +178,7 @@ struct rt6_rtnl_dump_arg {
 	struct fib_dump_filter filter;
 };
 
-int rt6_dump_route(struct fib6_info *f6i, void *p_arg);
+int rt6_dump_route(struct fib6_info *f6i, void *p_arg, unsigned int skip);
 void rt6_mtu_change(struct net_device *dev, unsigned int mtu);
 void rt6_remove_prefsrc(struct inet6_ifaddr *ifp);
 void rt6_clean_tohost(struct net *net, struct in6_addr *gateway);
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index e846192573b0..fc93e1b439a3 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -469,12 +469,19 @@ static int fib6_dump_node(struct fib6_walker *w)
 	struct fib6_info *rt;
 
 	for_each_fib6_walker_rt(w) {
-		res = rt6_dump_route(rt, w->args);
-		if (res < 0) {
+		res = rt6_dump_route(rt, w->args, w->skip_in_node);
+		if (res >= 0) {
 			/* Frame is full, suspend walking */
 			w->leaf = rt;
+
+			/* We'll restart from this node, so if some routes were
+			 * already dumped, skip them next time.
+			 */
+			w->skip_in_node += res;
+
 			return 1;
 		}
+		w->skip_in_node = 0;
 
 		/* Multipath routes are dumped in one route with the
 		 * RTA_MULTIPATH attribute. Jump 'rt' to point to the
@@ -526,6 +533,7 @@ static int fib6_dump_table(struct fib6_table *table, struct sk_buff *skb,
 	if (cb->args[4] == 0) {
 		w->count = 0;
 		w->skip = 0;
+		w->skip_in_node = 0;
 
 		spin_lock_bh(&table->tb6_lock);
 		res = fib6_walk(net, w);
@@ -541,6 +549,7 @@ static int fib6_dump_table(struct fib6_table *table, struct sk_buff *skb,
 			w->state = FWS_INIT;
 			w->node = w->root;
 			w->skip = w->count;
+			w->skip_in_node = 0;
 		} else
 			w->skip = 0;
 
@@ -2039,6 +2048,7 @@ static void fib6_clean_tree(struct net *net, struct fib6_node *root,
 	c.w.func = fib6_clean_node;
 	c.w.count = 0;
 	c.w.skip = 0;
+	c.w.skip_in_node = 0;
 	c.func = func;
 	c.sernum = sernum;
 	c.arg = arg;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 0f60eb3a2873..7375f3b7d310 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4854,33 +4854,94 @@ static bool fib6_info_uses_dev(const struct fib6_info *f6i,
 	return false;
 }
 
-int rt6_dump_route(struct fib6_info *rt, void *p_arg)
+/* Return -1 if done with node, number of handled routes on partial dump */
+int rt6_dump_route(struct fib6_info *rt, void *p_arg, unsigned int skip)
 {
 	struct rt6_rtnl_dump_arg *arg = (struct rt6_rtnl_dump_arg *) p_arg;
 	struct fib_dump_filter *filter = &arg->filter;
+	struct rt6_exception_bucket *bucket;
 	unsigned int flags = NLM_F_MULTI;
+	struct rt6_exception *rt6_ex;
 	struct net *net = arg->net;
+	int i, count = 0;
 
 	if (rt == net->ipv6.fib6_null_entry)
-		return 0;
+		return -1;
 
 	if ((filter->flags & RTM_F_PREFIX) &&
 	    !(rt->fib6_flags & RTF_PREFIX_RT)) {
 		/* success since this is not a prefix route */
-		return 1;
+		return -1;
 	}
-	if (filter->filter_set) {
-		if ((filter->rt_type && rt->fib6_type != filter->rt_type) ||
-		    (filter->dev && !fib6_info_uses_dev(rt, filter->dev)) ||
-		    (filter->protocol && rt->fib6_protocol != filter->protocol)) {
-			return 1;
-		}
+	if (filter->filter_set &&
+	    ((filter->rt_type  && rt->fib6_type != filter->rt_type) ||
+	     (filter->dev      && !fib6_info_uses_dev(rt, filter->dev)) ||
+	     (filter->protocol && rt->fib6_protocol != filter->protocol))) {
+		return -1;
+	}
+
+	if (filter->filter_set ||
+	    !filter->dump_routes || !filter->dump_exceptions) {
 		flags |= NLM_F_DUMP_FILTERED;
 	}
 
-	return rt6_fill_node(net, arg->skb, rt, NULL, NULL, NULL, 0,
-			     RTM_NEWROUTE, NETLINK_CB(arg->cb->skb).portid,
-			     arg->cb->nlh->nlmsg_seq, flags);
+	if (filter->dump_routes) {
+		if (skip) {
+			skip--;
+		} else {
+			if (rt6_fill_node(net, arg->skb, rt, NULL, NULL, NULL,
+					  0, RTM_NEWROUTE,
+					  NETLINK_CB(arg->cb->skb).portid,
+					  arg->cb->nlh->nlmsg_seq, flags)) {
+				return 0;
+			}
+			count++;
+		}
+	}
+
+	if (!filter->dump_exceptions)
+		return -1;
+
+	bucket = rcu_dereference(rt->rt6i_exception_bucket);
+	if (!bucket)
+		return -1;
+
+	for (i = 0; i < FIB6_EXCEPTION_BUCKET_SIZE; i++) {
+		hlist_for_each_entry(rt6_ex, &bucket->chain, hlist) {
+			if (skip) {
+				skip--;
+				continue;
+			}
+
+			/* Expiration of entries doesn't bump sernum, insertion
+			 * does. Removal is triggered by insertion, so we can
+			 * rely on the fact that if entries change between two
+			 * partial dumps, this node is scanned again completely,
+			 * see rt6_insert_exception() and fib6_dump_table().
+			 *
+			 * Count expired entries we go through as handled
+			 * entries that we'll skip next time, in case of partial
+			 * node dump. Otherwise, if entries expire meanwhile,
+			 * we'll skip the wrong amount.
+			 */
+			if (rt6_check_expired(rt6_ex->rt6i)) {
+				count++;
+				continue;
+			}
+
+			if (rt6_fill_node(net, arg->skb, rt, &rt6_ex->rt6i->dst,
+					  NULL, NULL, 0, RTM_NEWROUTE,
+					  NETLINK_CB(arg->cb->skb).portid,
+					  arg->cb->nlh->nlmsg_seq, flags)) {
+				return count;
+			}
+
+			count++;
+		}
+		bucket++;
+	}
+
+	return -1;
 }
 
 static int inet6_rtm_valid_getroute_req(struct sk_buff *skb,
-- 
2.20.1

