Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6953829B
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 04:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfFGCPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 22:15:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33300 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbfFGCPn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 22:15:43 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9107531628E5;
        Fri,  7 Jun 2019 02:15:42 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21D327C5C5;
        Fri,  7 Jun 2019 02:15:37 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: [PATCH net v2 1/2] ipv6: Dump route exceptions too in rt6_dump_route()
Date:   Fri,  7 Jun 2019 04:14:56 +0200
Message-Id: <3bf118a6a3870e72011b6105b63fa0d012094394.1559872578.git.sbrivio@redhat.com>
In-Reply-To: <cover.1559872578.git.sbrivio@redhat.com>
References: <cover.1559872578.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 07 Jun 2019 02:15:42 +0000 (UTC)
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
only wants cloned entries").

As we do this, we also have to honour this flag while filtering routes in
rt6_dump_route() and, if this filter effectively causes some results to be
discarded, by passing the NLM_F_DUMP_FILTERED flag back.

To flush cached routes, a procfs entry could be introduced instead: that's
how it works for IPv4. We already have a rt6_flush_exception() function
ready to be wired to it. However, this would not solve the issue for
listing, and wouldn't fix the issue with current and previous versions of
iproute2.

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
 net/ipv6/ip6_fib.c      | 24 ++++++++++-----
 net/ipv6/route.c        | 65 +++++++++++++++++++++++++++++++++++++----
 4 files changed, 78 insertions(+), 14 deletions(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index d6d936cbf6b3..fcac02a8ba74 100644
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
index 008421b550c6..f468fa9b5da6 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -473,12 +473,22 @@ static int fib6_dump_node(struct fib6_walker *w)
 	struct fib6_info *rt;
 
 	for_each_fib6_walker_rt(w) {
-		res = rt6_dump_route(rt, w->args);
-		if (res < 0) {
+		res = rt6_dump_route(rt, w->args, w->skip_in_node);
+		if (res) {
 			/* Frame is full, suspend walking */
 			w->leaf = rt;
+
+			/* We'll restart from this node, so if some routes were
+			 * already dumped, skip them next time.
+			 */
+			if (res > 0)
+				w->skip_in_node += res;
+			else
+				w->skip_in_node = 0;
+
 			return 1;
 		}
+		w->skip_in_node = 0;
 
 		/* Multipath routes are dumped in one route with the
 		 * RTA_MULTIPATH attribute. Jump 'rt' to point to the
@@ -530,6 +540,7 @@ static int fib6_dump_table(struct fib6_table *table, struct sk_buff *skb,
 	if (cb->args[4] == 0) {
 		w->count = 0;
 		w->skip = 0;
+		w->skip_in_node = 0;
 
 		spin_lock_bh(&table->tb6_lock);
 		res = fib6_walk(net, w);
@@ -545,6 +556,7 @@ static int fib6_dump_table(struct fib6_table *table, struct sk_buff *skb,
 			w->state = FWS_INIT;
 			w->node = w->root;
 			w->skip = w->count;
+			w->skip_in_node = 0;
 		} else
 			w->skip = 0;
 
@@ -581,13 +593,10 @@ static int inet6_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -2045,6 +2054,7 @@ static void fib6_clean_tree(struct net *net, struct fib6_node *root,
 	c.w.func = fib6_clean_node;
 	c.w.count = 0;
 	c.w.skip = 0;
+	c.w.skip_in_node = 0;
 	c.func = func;
 	c.sernum = sernum;
 	c.arg = arg;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 848e944f07df..554f88bd64f3 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4858,12 +4858,16 @@ static bool fib6_info_uses_dev(const struct fib6_info *f6i,
 	return false;
 }
 
-int rt6_dump_route(struct fib6_info *rt, void *p_arg)
+/* Return count of handled routes on failure, -1 if all failed, 0 on success */
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
 		return 0;
@@ -4871,20 +4875,69 @@ int rt6_dump_route(struct fib6_info *rt, void *p_arg)
 	if ((filter->flags & RTM_F_PREFIX) &&
 	    !(rt->fib6_flags & RTF_PREFIX_RT)) {
 		/* success since this is not a prefix route */
-		return 1;
+		return 0;
 	}
 	if (filter->filter_set) {
 		if ((filter->rt_type && rt->fib6_type != filter->rt_type) ||
 		    (filter->dev && !fib6_info_uses_dev(rt, filter->dev)) ||
 		    (filter->protocol && rt->fib6_protocol != filter->protocol)) {
-			return 1;
+			return 0;
 		}
 		flags |= NLM_F_DUMP_FILTERED;
 	}
 
-	return rt6_fill_node(net, arg->skb, rt, NULL, NULL, NULL, 0,
-			     RTM_NEWROUTE, NETLINK_CB(arg->cb->skb).portid,
-			     arg->cb->nlh->nlmsg_seq, flags);
+	if (!(filter->flags & RTM_F_CLONED)) {
+		if (skip) {
+			skip--;
+		} else if (rt6_fill_node(net, arg->skb, rt, NULL, NULL, NULL,
+					 0, RTM_NEWROUTE,
+					 NETLINK_CB(arg->cb->skb).portid,
+					 arg->cb->nlh->nlmsg_seq, flags)) {
+			return -1;
+		} else {
+			count++;
+		}
+	} else {
+		flags |= NLM_F_DUMP_FILTERED;
+	}
+
+	bucket = rcu_dereference(rt->rt6i_exception_bucket);
+	if (!bucket)
+		return 0;
+
+	for (i = 0; i < FIB6_EXCEPTION_BUCKET_SIZE; i++) {
+		hlist_for_each_entry(rt6_ex, &bucket->chain, hlist) {
+			if (skip) {
+				skip--;
+				continue;
+			}
+
+			/* Expiration of entries doesn't bump sernum, insertion
+			 * does. Removal is triggered by insertion.
+			 *
+			 * Count expired entries we go through as handled
+			 * entries that we'll skip next time, in case of partial
+			 * node dump. Otherwise, if entries expire between two
+			 * partial dumps, we'll skip the wrong amount.
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
+				return count ? : -1;
+			}
+
+			count++;
+		}
+		bucket++;
+	}
+
+	return 0;
 }
 
 static int inet6_rtm_valid_getroute_req(struct sk_buff *skb,
-- 
2.20.1

