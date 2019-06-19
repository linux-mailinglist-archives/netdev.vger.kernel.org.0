Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C51DC4C44B
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 02:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730927AbfFTAAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 20:00:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32886 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbfFTAAf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 20:00:35 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 938517FDF0;
        Thu, 20 Jun 2019 00:00:34 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3211719C5B;
        Thu, 20 Jun 2019 00:00:31 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v6 08/11] ipv6: Dump route exceptions if requested
Date:   Thu, 20 Jun 2019 01:59:48 +0200
Message-Id: <13c143591fe786dc452ec6c99b8ff1414ef8929d.1560987611.git.sbrivio@redhat.com>
In-Reply-To: <cover.1560987611.git.sbrivio@redhat.com>
References: <cover.1560987611.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 20 Jun 2019 00:00:34 +0000 (UTC)
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
still unable to fetch the routes to be flushed. This will be addressed in
a patch for iproute2.

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

v6:
  - Rebase onto net-next, use recently introduced nexthop walker
  - Make rt6_nh_dump_exceptions() a separate function, suggested by David
    Ahern
  - Move change of rt6_dump_route() return codes to separate patch, 7/11,
    also suggested by David Ahern

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
 include/net/ip6_fib.h   |   1 +
 include/net/ip6_route.h |   2 +-
 net/ipv6/ip6_fib.c      |  12 ++++-
 net/ipv6/route.c        | 114 ++++++++++++++++++++++++++++++++++++----
 4 files changed, 116 insertions(+), 13 deletions(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 87331f2c4af0..4b5656c71abc 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -316,6 +316,7 @@ struct fib6_walker {
 	enum fib6_walk_state state;
 	unsigned int skip;
 	unsigned int count;
+	unsigned int skip_in_node;
 	int (*func)(struct fib6_walker *);
 	void *args;
 };
diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 7375a165fd98..a849a379f426 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -182,7 +182,7 @@ struct rt6_rtnl_dump_arg {
 	struct fib_dump_filter filter;
 };
 
-int rt6_dump_route(struct fib6_info *f6i, void *p_arg);
+int rt6_dump_route(struct fib6_info *f6i, void *p_arg, unsigned int skip);
 void rt6_mtu_change(struct net_device *dev, unsigned int mtu);
 void rt6_remove_prefsrc(struct inet6_ifaddr *ifp);
 void rt6_clean_tohost(struct net *net, struct in6_addr *gateway);
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 0e9a2ec69336..92a6bde57594 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -463,12 +463,19 @@ static int fib6_dump_node(struct fib6_walker *w)
 	struct fib6_info *rt;
 
 	for_each_fib6_walker_rt(w) {
-		res = rt6_dump_route(rt, w->args);
+		res = rt6_dump_route(rt, w->args, w->skip_in_node);
 		if (res >= 0) {
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
@@ -520,6 +527,7 @@ static int fib6_dump_table(struct fib6_table *table, struct sk_buff *skb,
 	if (cb->args[4] == 0) {
 		w->count = 0;
 		w->skip = 0;
+		w->skip_in_node = 0;
 
 		spin_lock_bh(&table->tb6_lock);
 		res = fib6_walk(net, w);
@@ -535,6 +543,7 @@ static int fib6_dump_table(struct fib6_table *table, struct sk_buff *skb,
 			w->state = FWS_INIT;
 			w->node = w->root;
 			w->skip = w->count;
+			w->skip_in_node = 0;
 		} else
 			w->skip = 0;
 
@@ -2093,6 +2102,7 @@ static void fib6_clean_tree(struct net *net, struct fib6_node *root,
 	c.w.func = fib6_clean_node;
 	c.w.count = 0;
 	c.w.skip = 0;
+	c.w.skip_in_node = 0;
 	c.func = func;
 	c.sernum = sernum;
 	c.arg = arg;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 1282f5a55b08..e2900cd0410c 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5503,13 +5503,73 @@ static bool fib6_info_uses_dev(const struct fib6_info *f6i,
 	return false;
 }
 
+struct fib6_nh_exception_dump_walker {
+	struct rt6_rtnl_dump_arg *dump;
+	struct fib6_info *rt;
+	unsigned int flags;
+	unsigned int skip;
+	unsigned int count;
+};
+
+static int rt6_nh_dump_exceptions(struct fib6_nh *nh, void *arg)
+{
+	struct fib6_nh_exception_dump_walker *w = arg;
+	struct rt6_rtnl_dump_arg *dump = w->dump;
+	struct rt6_exception_bucket *bucket;
+	struct rt6_exception *rt6_ex;
+	int i, err;
+
+	bucket = fib6_nh_get_excptn_bucket(nh, NULL);
+	if (!bucket)
+		return 0;
+
+	for (i = 0; i < FIB6_EXCEPTION_BUCKET_SIZE; i++) {
+		hlist_for_each_entry(rt6_ex, &bucket->chain, hlist) {
+			if (w->skip) {
+				w->skip--;
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
+				w->count++;
+				continue;
+			}
+
+			err = rt6_fill_node(dump->net, dump->skb, w->rt,
+					    &rt6_ex->rt6i->dst, NULL, NULL, 0,
+					    RTM_NEWROUTE,
+					    NETLINK_CB(dump->cb->skb).portid,
+					    dump->cb->nlh->nlmsg_seq, w->flags);
+			if (err)
+				return err;
+
+			w->count++;
+		}
+		bucket++;
+	}
+
+	return 0;
+}
+
 /* Return -1 if done with node, number of handled routes on partial dump */
-int rt6_dump_route(struct fib6_info *rt, void *p_arg)
+int rt6_dump_route(struct fib6_info *rt, void *p_arg, unsigned int skip)
 {
 	struct rt6_rtnl_dump_arg *arg = (struct rt6_rtnl_dump_arg *) p_arg;
 	struct fib_dump_filter *filter = &arg->filter;
 	unsigned int flags = NLM_F_MULTI;
 	struct net *net = arg->net;
+	int count = 0;
 
 	if (rt == net->ipv6.fib6_null_entry)
 		return -1;
@@ -5519,19 +5579,51 @@ int rt6_dump_route(struct fib6_info *rt, void *p_arg)
 		/* success since this is not a prefix route */
 		return -1;
 	}
-	if (filter->filter_set) {
-		if ((filter->rt_type && rt->fib6_type != filter->rt_type) ||
-		    (filter->dev && !fib6_info_uses_dev(rt, filter->dev)) ||
-		    (filter->protocol && rt->fib6_protocol != filter->protocol)) {
-			return -1;
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
 
-	if (rt6_fill_node(net, arg->skb, rt, NULL, NULL, NULL, 0, RTM_NEWROUTE,
-			  NETLINK_CB(arg->cb->skb).portid,
-			  arg->cb->nlh->nlmsg_seq, flags))
-		return 0;
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
+	if (filter->dump_exceptions) {
+		struct fib6_nh_exception_dump_walker w = { .dump = arg,
+							   .rt = rt,
+							   .flags = flags,
+							   .skip = skip,
+							   .count = 0 };
+		int err;
+
+		if (rt->nh) {
+			err = nexthop_for_each_fib6_nh(rt->nh,
+						       rt6_nh_dump_exceptions,
+						       &w);
+		} else {
+			err = rt6_nh_dump_exceptions(rt->fib6_nh, &w);
+		}
+
+		if (err)
+			return count += w.count;
+	}
 
 	return -1;
 }
-- 
2.20.1

