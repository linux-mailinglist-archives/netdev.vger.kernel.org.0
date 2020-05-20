Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6BC1DAE7A
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 11:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgETJQK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 20 May 2020 05:16:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28481 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726691AbgETJQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 05:16:10 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-yKBxMkvDNEOkWjf3VDffgw-1; Wed, 20 May 2020 05:16:04 -0400
X-MC-Unique: yKBxMkvDNEOkWjf3VDffgw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6CC481800D42;
        Wed, 20 May 2020 09:16:03 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.194.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D5325D9CA;
        Wed, 20 May 2020 09:16:02 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net] net: don't return invalid table id error when we fall back to PF_UNSPEC
Date:   Wed, 20 May 2020 11:15:46 +0200
Message-Id: <fc61912d585ccf3999c3cba5e481c1920af17ca6.1589961603.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 include/net/ip_fib.h    | 1 -
 net/ipv4/fib_frontend.c | 3 +--
 net/ipv4/ipmr.c         | 2 +-
 net/ipv6/ip6_fib.c      | 2 +-
 net/ipv6/ip6mr.c        | 2 +-
 5 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 59e0d4e99f94..b219a8fe0950 100644
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
index 5c218db2dede..b2363b82b48d 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2613,7 +2613,7 @@ static int ipmr_rtm_dumproute(struct sk_buff *skb, struct netlink_callback *cb)
 
 		mrt = ipmr_get_table(sock_net(skb->sk), filter.table_id);
 		if (!mrt) {
-			if (filter.dump_all_families)
+			if (rtnl_msg_family(cb->nlh) != RTNL_FAMILY_IPMR)
 				return skb->len;
 
 			NL_SET_ERR_MSG(cb->extack, "ipv4: MR table does not exist");
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 46ed56719476..20314895509c 100644
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
index 1e223e26f079..1f4d20e97c07 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -2503,7 +2503,7 @@ static int ip6mr_rtm_dumproute(struct sk_buff *skb, struct netlink_callback *cb)
 
 		mrt = ip6mr_get_table(sock_net(skb->sk), filter.table_id);
 		if (!mrt) {
-			if (filter.dump_all_families)
+			if (rtnl_msg_family(cb->nlh) != RTNL_FAMILY_IP6MR)
 				return skb->len;
 
 			NL_SET_ERR_MSG_MOD(cb->extack, "MR table does not exist");
-- 
2.26.2

