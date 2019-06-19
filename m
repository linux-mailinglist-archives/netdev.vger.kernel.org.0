Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 663D64C444
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 02:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730836AbfFTAAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 20:00:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38424 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbfFTAAP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 20:00:15 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D3CE02DE417;
        Thu, 20 Jun 2019 00:00:14 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75BED19C5B;
        Thu, 20 Jun 2019 00:00:12 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v6 01/11] fib_frontend, ip6_fib: Select routes or exceptions dump from RTM_F_CLONED
Date:   Thu, 20 Jun 2019 01:59:41 +0200
Message-Id: <8efce539080961139a7f3c7524c1aae05899dc1c.1560987611.git.sbrivio@redhat.com>
In-Reply-To: <cover.1560987611.git.sbrivio@redhat.com>
References: <cover.1560987611.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 20 Jun 2019 00:00:15 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following patches add back the ability to dump IPv4 and IPv6 exception
routes, and we need to allow selection of regular routes or exceptions.

Use RTM_F_CLONED as filter to decide whether to dump routes or exceptions:
iproute2 passes it in dump requests (except for IPv6 cache flush requests,
this will be fixed in iproute2) and this used to work as long as
exceptions were stored directly in the FIB, for both IPv4 and IPv6.

Caveat: if strict checking is not requested (that is, if the dump request
doesn't go through ip_valid_fib_dump_req()), we can't filter on protocol,
tables or route types.

In this case, filtering on RTM_F_CLONED would be inconsistent: we would
fix 'ip route list cache' by returning exception routes and at the same
time introduce another bug in case another selector is present, e.g. on
'ip route list cache table main' we would return all exception routes,
without filtering on tables.

Keep this consistent by applying no filters at all, and dumping both
routes and exceptions, if strict checking is not requested. iproute2
currently filters results anyway, and no unwanted results will be
presented to the user. The kernel will just dump more data than needed.

v6: Rebase onto net-next, no changes

v5: New patch: add dump_routes and dump_exceptions flags in filter and
    simply clear the unwanted one if strict checking is enabled, don't
    ignore NLM_F_MATCH and don't set filter_set if NLM_F_MATCH is set.
    Skip filtering altogether if no strict checking is requested:
    selecting routes or exceptions only would be inconsistent with the
    fact we can't filter on tables.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 include/net/ip_fib.h    | 2 ++
 net/ipv4/fib_frontend.c | 8 +++++++-
 net/ipv6/ip6_fib.c      | 3 ++-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 7e1e621a56df..4c81846ccce8 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -245,6 +245,8 @@ struct fib_dump_filter {
 	/* filter_set is an optimization that an entry is set */
 	bool			filter_set;
 	bool			dump_all_families;
+	bool			dump_routes;
+	bool			dump_exceptions;
 	unsigned char		protocol;
 	unsigned char		rt_type;
 	unsigned int		flags;
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 108191667531..ed7fb5fd885c 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -912,10 +912,15 @@ int ip_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
 		NL_SET_ERR_MSG(extack, "Invalid values in header for FIB dump request");
 		return -EINVAL;
 	}
+
 	if (rtm->rtm_flags & ~(RTM_F_CLONED | RTM_F_PREFIX)) {
 		NL_SET_ERR_MSG(extack, "Invalid flags for FIB dump request");
 		return -EINVAL;
 	}
+	if (rtm->rtm_flags & RTM_F_CLONED)
+		filter->dump_routes = false;
+	else
+		filter->dump_exceptions = false;
 
 	filter->dump_all_families = (rtm->rtm_family == AF_UNSPEC);
 	filter->flags    = rtm->rtm_flags;
@@ -962,9 +967,10 @@ EXPORT_SYMBOL_GPL(ip_valid_fib_dump_req);
 
 static int inet_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 {
+	struct fib_dump_filter filter = { .dump_routes = true,
+					  .dump_exceptions = true };
 	const struct nlmsghdr *nlh = cb->nlh;
 	struct net *net = sock_net(skb->sk);
-	struct fib_dump_filter filter = {};
 	unsigned int h, s_h;
 	unsigned int e = 0, s_e;
 	struct fib_table *tb;
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 1d16a01eccf5..f2a3cc4c8f12 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -552,9 +552,10 @@ static int fib6_dump_table(struct fib6_table *table, struct sk_buff *skb,
 
 static int inet6_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 {
+	struct rt6_rtnl_dump_arg arg = { .filter.dump_exceptions = true,
+					 .filter.dump_routes = true };
 	const struct nlmsghdr *nlh = cb->nlh;
 	struct net *net = sock_net(skb->sk);
-	struct rt6_rtnl_dump_arg arg = {};
 	unsigned int h, s_h;
 	unsigned int e = 0, s_e;
 	struct fib6_walker *w;
-- 
2.20.1

