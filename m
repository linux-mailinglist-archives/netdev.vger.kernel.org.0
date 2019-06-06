Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4C937DE5
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 22:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728658AbfFFUON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 16:14:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55434 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728641AbfFFUOM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 16:14:12 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BB9F265CE2;
        Thu,  6 Jun 2019 20:14:09 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0634277CC;
        Thu,  6 Jun 2019 20:14:05 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: [PATCH net 1/2] ipv6: Dump route exceptions too in rt6_dump_route()
Date:   Thu,  6 Jun 2019 22:13:41 +0200
Message-Id: <085ce9fbe0206be0d1d090b36e656aa89cef3d98.1559851514.git.sbrivio@redhat.com>
In-Reply-To: <cover.1559851514.git.sbrivio@redhat.com>
References: <cover.1559851514.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 06 Jun 2019 20:14:12 +0000 (UTC)
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

Reported-by: Jianlin Shi <jishi@redhat.com>
Fixes: 2b760fcf5cfb ("ipv6: hook up exception table to store dst cache")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
This will cause a non-trivial conflict with commit cc5c073a693f
("ipv6: Move exception bucket to fib6_nh") on net-next. I can submit
an equivalent patch against net-next, if it helps.

 net/ipv6/ip6_fib.c |  7 ++-----
 net/ipv6/route.c   | 38 +++++++++++++++++++++++++++++++++++---
 2 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 008421b550c6..5be133565819 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -581,13 +581,10 @@ static int inet6_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
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
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 848e944f07df..51f923b3ad26 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4862,8 +4862,11 @@ int rt6_dump_route(struct fib6_info *rt, void *p_arg)
 {
 	struct rt6_rtnl_dump_arg *arg = (struct rt6_rtnl_dump_arg *) p_arg;
 	struct fib_dump_filter *filter = &arg->filter;
+	struct rt6_exception_bucket *bucket;
 	unsigned int flags = NLM_F_MULTI;
+	struct rt6_exception *rt6_ex;
 	struct net *net = arg->net;
+	int i, err;
 
 	if (rt == net->ipv6.fib6_null_entry)
 		return 0;
@@ -4882,9 +4885,38 @@ int rt6_dump_route(struct fib6_info *rt, void *p_arg)
 		flags |= NLM_F_DUMP_FILTERED;
 	}
 
-	return rt6_fill_node(net, arg->skb, rt, NULL, NULL, NULL, 0,
-			     RTM_NEWROUTE, NETLINK_CB(arg->cb->skb).portid,
-			     arg->cb->nlh->nlmsg_seq, flags);
+	if (!(filter->flags & RTM_F_CLONED)) {
+		err = rt6_fill_node(net, arg->skb, rt, NULL, NULL, NULL, 0,
+				    RTM_NEWROUTE,
+				    NETLINK_CB(arg->cb->skb).portid,
+				    arg->cb->nlh->nlmsg_seq, flags);
+		if (err)
+			return err;
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
+			if (rt6_check_expired(rt6_ex->rt6i))
+				continue;
+
+			err = rt6_fill_node(net, arg->skb, rt,
+					    &rt6_ex->rt6i->dst,
+					    NULL, NULL, 0, RTM_NEWROUTE,
+					    NETLINK_CB(arg->cb->skb).portid,
+					    arg->cb->nlh->nlmsg_seq, flags);
+			if (err)
+				return err;
+		}
+		bucket++;
+	}
+
+	return 0;
 }
 
 static int inet6_rtm_valid_getroute_req(struct sk_buff *skb,
-- 
2.20.1

