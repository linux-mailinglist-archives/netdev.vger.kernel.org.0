Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CA21F2CC2
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730267AbgFHXQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730245AbgFHXQa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:16:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF0CB20774;
        Mon,  8 Jun 2020 23:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658189;
        bh=Pl6/OwYMuFQSJin0eDP55gHkwKVndJdJlhJr9bBUni0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mw/+hVL5GPbwt0CIx+Y9bX4dxIQlknOOsDtHvuBnIADNE9ToaOuwJxaEgJzXO1DhB
         6OcaNzdsOTui8O+iquXUhg2S48VQoZGWdsUg0ZCozMYKq+aqinq8lZx7TrHbrPYeog
         oN0VmcZRiIH4L/4U8/76UXJhl+0V0P6CbxY12+Mo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 211/606] net: don't return invalid table id error when we fall back to PF_UNSPEC
Date:   Mon,  8 Jun 2020 19:05:36 -0400
Message-Id: <20200608231211.3363633-211-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 41b4bd986f86331efc599b9a3f5fb86ad92e9af9 ]

In case we can't find a ->dumpit callback for the requested
(family,type) pair, we fall back to (PF_UNSPEC,type). In effect, we're
in the same situation as if userspace had requested a PF_UNSPEC
dump. For RTM_GETROUTE, that handler is rtnl_dump_all, which calls all
the registered RTM_GETROUTE handlers.

The requested table id may or may not exist for all of those
families. commit ae677bbb4441 ("net: Don't return invalid table id
error when dumping all families") fixed the problem when userspace
explicitly requests a PF_UNSPEC dump, but missed the fallback case.

For example, when we pass ipv6.disable=1 to a kernel with
CONFIG_IP_MROUTE=y and CONFIG_IP_MROUTE_MULTIPLE_TABLES=y,
the (PF_INET6, RTM_GETROUTE) handler isn't registered, so we end up in
rtnl_dump_all, and listing IPv6 routes will unexpectedly print:

  # ip -6 r
  Error: ipv4: MR table does not exist.
  Dump terminated

commit ae677bbb4441 introduced the dump_all_families variable, which
gets set when userspace requests a PF_UNSPEC dump. However, we can't
simply set the family to PF_UNSPEC in rtnetlink_rcv_msg in the
fallback case to get dump_all_families == true, because some messages
types (for example RTM_GETRULE and RTM_GETNEIGH) only register the
PF_UNSPEC handler and use the family to filter in the kernel what is
dumped to userspace. We would then export more entries, that userspace
would have to filter. iproute does that, but other programs may not.

Instead, this patch removes dump_all_families and updates the
RTM_GETROUTE handlers to check if the family that is being dumped is
their own. When it's not, which covers both the intentional PF_UNSPEC
dumps (as dump_all_families did) and the fallback case, ignore the
missing table id error.

Fixes: cb167893f41e ("net: Plumb support for filtering ipv4 and ipv6 multicast route dumps")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip_fib.h    | 1 -
 net/ipv4/fib_frontend.c | 3 +--
 net/ipv4/ipmr.c         | 2 +-
 net/ipv6/ip6_fib.c      | 2 +-
 net/ipv6/ip6mr.c        | 2 +-
 5 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 6a1ae49809de..a89c0885fd2a 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -257,7 +257,6 @@ struct fib_dump_filter {
 	u32			table_id;
 	/* filter_set is an optimization that an entry is set */
 	bool			filter_set;
-	bool			dump_all_families;
 	bool			dump_routes;
 	bool			dump_exceptions;
 	unsigned char		protocol;
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 213be9c050ad..1bf9da3a75f9 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -918,7 +918,6 @@ int ip_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
 	else
 		filter->dump_exceptions = false;
 
-	filter->dump_all_families = (rtm->rtm_family == AF_UNSPEC);
 	filter->flags    = rtm->rtm_flags;
 	filter->protocol = rtm->rtm_protocol;
 	filter->rt_type  = rtm->rtm_type;
@@ -990,7 +989,7 @@ static int inet_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 	if (filter.table_id) {
 		tb = fib_get_table(net, filter.table_id);
 		if (!tb) {
-			if (filter.dump_all_families)
+			if (rtnl_msg_family(cb->nlh) != PF_INET)
 				return skb->len;
 
 			NL_SET_ERR_MSG(cb->extack, "ipv4: FIB table does not exist");
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 6e68def66822..2508b4c37af3 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2611,7 +2611,7 @@ static int ipmr_rtm_dumproute(struct sk_buff *skb, struct netlink_callback *cb)
 
 		mrt = ipmr_get_table(sock_net(skb->sk), filter.table_id);
 		if (!mrt) {
-			if (filter.dump_all_families)
+			if (rtnl_msg_family(cb->nlh) != RTNL_FAMILY_IPMR)
 				return skb->len;
 
 			NL_SET_ERR_MSG(cb->extack, "ipv4: MR table does not exist");
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 72abf892302f..9a53590ef79c 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -664,7 +664,7 @@ static int inet6_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 	if (arg.filter.table_id) {
 		tb = fib6_get_table(net, arg.filter.table_id);
 		if (!tb) {
-			if (arg.filter.dump_all_families)
+			if (rtnl_msg_family(cb->nlh) != PF_INET6)
 				goto out;
 
 			NL_SET_ERR_MSG_MOD(cb->extack, "FIB table does not exist");
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index bfa49ff70531..2ddb7c513e54 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -2501,7 +2501,7 @@ static int ip6mr_rtm_dumproute(struct sk_buff *skb, struct netlink_callback *cb)
 
 		mrt = ip6mr_get_table(sock_net(skb->sk), filter.table_id);
 		if (!mrt) {
-			if (filter.dump_all_families)
+			if (rtnl_msg_family(cb->nlh) != RTNL_FAMILY_IP6MR)
 				return skb->len;
 
 			NL_SET_ERR_MSG_MOD(cb->extack, "MR table does not exist");
-- 
2.25.1

