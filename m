Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 614133A135
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 20:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfFHSMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 14:12:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37340 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727220AbfFHSMW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 14:12:22 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0701E3086216;
        Sat,  8 Jun 2019 18:12:21 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 904A160BE5;
        Sat,  8 Jun 2019 18:12:16 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH net v3 1/2] ipv6: Dump route exceptions too in rt6_dump_route()
Date:   Sat,  8 Jun 2019 20:12:09 +0200
Message-Id: <f5ca22e91017e90842ee00aa4fd41dcdf7a6e99b.1560016091.git.sbrivio@redhat.com>
In-Reply-To: <cover.1560016091.git.sbrivio@redhat.com>
References: <cover.1560016091.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Sat, 08 Jun 2019 18:12:21 +0000 (UTC)
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

Look up exceptions in the hash table associated with the current fib6_info
in rt6_dump_route(), and, if present and not expired, add them to the
dump.

We might be unable to dump all the entries for a given node in a single
message, so keep track of how many entries were handled for the current
node in fib6_walker, and skip that amount in case we start from the same
partially dumped node.

Re-allow userspace to get FIB results by passing the RTM_F_CLONED flag as
filter, by reverting commit 08e814c9e8eb ("net/ipv6: Bail early if user
only wants cloned entries"). Note that this is needed only for 'ip -6
route list cache': on a flush command, iproute2 doesn't pass RTM_F_CLONED.
Due to this inconsistency, we can't filter on RTM_F_CLONED, because a
flush command would not set the flag in the dump request and get no routes
to flush.

Also note that iproute2 will actually filter unwanted routes (i.e. print
exceptions iff the 'cache' specifier is given).

To avoid dumping exceptions if not requested, we can, in the future, add
support for NLM_F_MATCH as described by RFC 3549. This would also require
some changes in iproute2: whenever a 'cache' argument is given,
RTM_F_CLONED should be set in the dump request and, when filtering in the
kernel is desired, NLM_F_MATCH should be also passed. We can then signal
filtering with the NLM_F_DUMP_FILTERED whenever a NLM_F_MATCH flag caused
it.

To flush cached routes, a procfs entry could be introduced instead: that's
how it works for IPv4. We already have a rt6_flush_exception() function
ready to be wired to it. However, this would not solve the issue for
listing, and wouldn't fix the issue with current and previous versions of
iproute2.

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
 net/ipv6/ip6_fib.c      | 21 ++++++++-----
 net/ipv6/route.c        | 67 ++++++++++++++++++++++++++++++++++++-----
 4 files changed, 76 insertions(+), 15 deletions(-)

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
index 9180c8b6f764..73dbad54baea 100644
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
 
@@ -577,13 +586,10 @@ static int inet6_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 	} else if (nlmsg_len(nlh) >= sizeof(struct rtmsg)) {
 		struct rtmsg *rtm = nlmsg_data(nlh);
 
-		arg.filter.flags = rtm->rtm_flags & (RTM_F_PREFIX|RTM_F_CLONED);
+		if (rtm->rtm_flags & RTM_F_PREFIX)
+			arg.filter.flags = RTM_F_PREFIX;
 	}
 
-	/* fib entries are never clones */
-	if (arg.filter.flags & RTM_F_CLONED)
-		goto out;
-
 	w = (void *)cb->args[2];
 	if (!w) {
 		/* New dump:
@@ -2041,6 +2047,7 @@ static void fib6_clean_tree(struct net *net, struct fib6_node *root,
 	c.w.func = fib6_clean_node;
 	c.w.count = 0;
 	c.w.skip = 0;
+	c.w.skip_in_node = 0;
 	c.func = func;
 	c.sernum = sernum;
 	c.arg = arg;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 0f60eb3a2873..45ada000a98e 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4854,33 +4854,86 @@ static bool fib6_info_uses_dev(const struct fib6_info *f6i,
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
 	if (filter->filter_set) {
 		if ((filter->rt_type && rt->fib6_type != filter->rt_type) ||
 		    (filter->dev && !fib6_info_uses_dev(rt, filter->dev)) ||
 		    (filter->protocol && rt->fib6_protocol != filter->protocol)) {
-			return 1;
+			return -1;
 		}
 		flags |= NLM_F_DUMP_FILTERED;
 	}
 
-	return rt6_fill_node(net, arg->skb, rt, NULL, NULL, NULL, 0,
-			     RTM_NEWROUTE, NETLINK_CB(arg->cb->skb).portid,
-			     arg->cb->nlh->nlmsg_seq, flags);
+	if (skip) {
+		skip--;
+	} else {
+		if (rt6_fill_node(net, arg->skb, rt, NULL, NULL, NULL, 0,
+				  RTM_NEWROUTE, NETLINK_CB(arg->cb->skb).portid,
+				  arg->cb->nlh->nlmsg_seq, flags)) {
+			return 0;
+		}
+
+		count++;
+	}
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

