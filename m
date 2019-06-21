Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9F954EC7B
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 17:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfFUPrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 11:47:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12915 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbfFUPrO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 11:47:14 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A868A87620;
        Fri, 21 Jun 2019 15:47:13 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59DDF19C68;
        Fri, 21 Jun 2019 15:47:09 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>, David Ahern <dsahern@gmail.com>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v7 07/11] ipv6/route: Change return code of rt6_dump_route() for partial node dumps
Date:   Fri, 21 Jun 2019 17:45:26 +0200
Message-Id: <e1fd0f3be3b6ca71107e6adfafea3d6eee5603a9.1561131177.git.sbrivio@redhat.com>
In-Reply-To: <cover.1561131177.git.sbrivio@redhat.com>
References: <cover.1561131177.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 21 Jun 2019 15:47:13 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the next patch, we are going to add optional dump of exceptions to
rt6_dump_route().

Change the return code of rt6_dump_route() to accomodate partial node
dumps: we might dump multiple routes per node, and might be able to dump
only a given number of them, so fib6_dump_node() will need to know how
many routes have been dumped on partial dump, to restart the dump from the
point where it was interrupted.

Note that fib6_dump_node() is the only caller and already handles all
non-negative return codes as success: those become -1 to signal that we're
done with the node. If we fail, return 0, as we were unable to dump the
single route in the node, but we're not done with it.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
v7: No changes

v6: New patch

 net/ipv6/ip6_fib.c |  2 +-
 net/ipv6/route.c   | 16 ++++++++++------
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 2baca6ef9e01..0e9a2ec69336 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -464,7 +464,7 @@ static int fib6_dump_node(struct fib6_walker *w)
 
 	for_each_fib6_walker_rt(w) {
 		res = rt6_dump_route(rt, w->args);
-		if (res < 0) {
+		if (res >= 0) {
 			/* Frame is full, suspend walking */
 			w->leaf = rt;
 			return 1;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 86859023cd01..1282f5a55b08 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5503,6 +5503,7 @@ static bool fib6_info_uses_dev(const struct fib6_info *f6i,
 	return false;
 }
 
+/* Return -1 if done with node, number of handled routes on partial dump */
 int rt6_dump_route(struct fib6_info *rt, void *p_arg)
 {
 	struct rt6_rtnl_dump_arg *arg = (struct rt6_rtnl_dump_arg *) p_arg;
@@ -5511,25 +5512,28 @@ int rt6_dump_route(struct fib6_info *rt, void *p_arg)
 	struct net *net = arg->net;
 
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
+	if (rt6_fill_node(net, arg->skb, rt, NULL, NULL, NULL, 0, RTM_NEWROUTE,
+			  NETLINK_CB(arg->cb->skb).portid,
+			  arg->cb->nlh->nlmsg_seq, flags))
+		return 0;
+
+	return -1;
 }
 
 static int inet6_rtm_valid_getroute_req(struct sk_buff *skb,
-- 
2.20.1

