Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A49346D8E
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 03:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfFOBc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 21:32:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40936 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbfFOBc4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 21:32:56 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3D616307D863;
        Sat, 15 Jun 2019 01:32:47 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98ACF5C257;
        Sat, 15 Jun 2019 01:32:44 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
Subject: [PATCH net v4 1/8] ipv4/fib_frontend: Rename ip_valid_fib_dump_req, provide non-strict version
Date:   Sat, 15 Jun 2019 03:32:09 +0200
Message-Id: <fb2bbc9568a7d7d21a00b791a2d4f488cfcd8a50.1560561432.git.sbrivio@redhat.com>
In-Reply-To: <cover.1560561432.git.sbrivio@redhat.com>
References: <cover.1560561432.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Sat, 15 Jun 2019 01:32:55 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ip_valid_fib_dump_req() does two things: performs strict checking on
netlink attributes for dump requests, and sets a dump filter if netlink
attributes require it.

We might want to just set a filter, without performing strict validation.

Rename it to ip_filter_fib_dump_req(), and add a 'strict' boolean
argument that must be set if strict validation is requested.

This patch doesn't introduce any functional changes.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
v4: New patch

 include/net/ip_fib.h    |  6 +++---
 net/ipv4/fib_frontend.c | 34 ++++++++++++++++++++++------------
 net/ipv4/ipmr.c         |  4 ++--
 net/ipv6/ip6_fib.c      |  2 +-
 net/ipv6/ip6mr.c        |  4 ++--
 net/mpls/af_mpls.c      |  2 +-
 6 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index bbeff32fb6cb..76094a0b97cf 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -493,9 +493,9 @@ static inline void fib_proc_exit(struct net *net)
 
 u32 ip_mtu_from_fib_result(struct fib_result *res, __be32 daddr);
 
-int ip_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
-			  struct fib_dump_filter *filter,
-			  struct netlink_callback *cb);
+int ip_filter_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
+			   struct fib_dump_filter *filter,
+			   struct netlink_callback *cb, bool strict);
 
 int fib_nexthop_info(struct sk_buff *skb, const struct fib_nh_common *nh,
 		     unsigned char *flags, bool skip_oif);
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index e54c2bcbb465..873fc5c4721c 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -859,9 +859,9 @@ static int inet_rtm_newroute(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
-int ip_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
-			  struct fib_dump_filter *filter,
-			  struct netlink_callback *cb)
+int ip_filter_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
+			   struct fib_dump_filter *filter,
+			   struct netlink_callback *cb, bool strict)
 {
 	struct netlink_ext_ack *extack = cb->extack;
 	struct nlattr *tb[RTA_MAX + 1];
@@ -876,12 +876,12 @@ int ip_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
 	}
 
 	rtm = nlmsg_data(nlh);
-	if (rtm->rtm_dst_len || rtm->rtm_src_len  || rtm->rtm_tos   ||
-	    rtm->rtm_scope) {
+	if (strict && (rtm->rtm_dst_len || rtm->rtm_src_len || rtm->rtm_tos ||
+		       rtm->rtm_scope)) {
 		NL_SET_ERR_MSG(extack, "Invalid values in header for FIB dump request");
 		return -EINVAL;
 	}
-	if (rtm->rtm_flags & ~(RTM_F_CLONED | RTM_F_PREFIX)) {
+	if (strict && rtm->rtm_flags & ~(RTM_F_CLONED | RTM_F_PREFIX)) {
 		NL_SET_ERR_MSG(extack, "Invalid flags for FIB dump request");
 		return -EINVAL;
 	}
@@ -892,10 +892,18 @@ int ip_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
 	filter->rt_type  = rtm->rtm_type;
 	filter->table_id = rtm->rtm_table;
 
-	err = nlmsg_parse_deprecated_strict(nlh, sizeof(*rtm), tb, RTA_MAX,
-					    rtm_ipv4_policy, extack);
-	if (err < 0)
-		return err;
+	if (strict) {
+		err = nlmsg_parse_deprecated_strict(nlh, sizeof(*rtm), tb,
+						    RTA_MAX, rtm_ipv4_policy,
+						    extack);
+		if (err < 0)
+			return err;
+	} else {
+		err = nlmsg_parse_deprecated(nlh, sizeof(*rtm), tb, RTA_MAX,
+					     rtm_ipv4_policy, extack);
+		if (err < 0)
+			return err;
+	}
 
 	for (i = 0; i <= RTA_MAX; ++i) {
 		int ifindex;
@@ -914,6 +922,8 @@ int ip_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
 				return -ENODEV;
 			break;
 		default:
+			if (!strict)
+				break;
 			NL_SET_ERR_MSG(extack, "Unsupported attribute in dump request");
 			return -EINVAL;
 		}
@@ -927,7 +937,7 @@ int ip_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(ip_valid_fib_dump_req);
+EXPORT_SYMBOL_GPL(ip_filter_fib_dump_req);
 
 static int inet_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 {
@@ -941,7 +951,7 @@ static int inet_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 	int dumped = 0, err;
 
 	if (cb->strict_check) {
-		err = ip_valid_fib_dump_req(net, nlh, &filter, cb);
+		err = ip_filter_fib_dump_req(net, nlh, &filter, cb, true);
 		if (err < 0)
 			return err;
 	} else if (nlmsg_len(nlh) >= sizeof(struct rtmsg)) {
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index c07bc82cbbe9..1e089acc9479 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2597,8 +2597,8 @@ static int ipmr_rtm_dumproute(struct sk_buff *skb, struct netlink_callback *cb)
 	int err;
 
 	if (cb->strict_check) {
-		err = ip_valid_fib_dump_req(sock_net(skb->sk), cb->nlh,
-					    &filter, cb);
+		err = ip_filter_fib_dump_req(sock_net(skb->sk), cb->nlh,
+					     &filter, cb, true);
 		if (err < 0)
 			return err;
 	}
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 9180c8b6f764..b21a9ec02891 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -571,7 +571,7 @@ static int inet6_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 	if (cb->strict_check) {
 		int err;
 
-		err = ip_valid_fib_dump_req(net, nlh, &arg.filter, cb);
+		err = ip_filter_fib_dump_req(net, nlh, &arg.filter, cb, true);
 		if (err < 0)
 			return err;
 	} else if (nlmsg_len(nlh) >= sizeof(struct rtmsg)) {
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index e80d36c5073d..4960c3fe8e83 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -2487,8 +2487,8 @@ static int ip6mr_rtm_dumproute(struct sk_buff *skb, struct netlink_callback *cb)
 	int err;
 
 	if (cb->strict_check) {
-		err = ip_valid_fib_dump_req(sock_net(skb->sk), nlh,
-					    &filter, cb);
+		err = ip_filter_fib_dump_req(sock_net(skb->sk), nlh, &filter,
+					     cb, true);
 		if (err < 0)
 			return err;
 	}
diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 198ec4fe4148..f54d2f5834f8 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -2078,7 +2078,7 @@ static int mpls_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
 				   struct fib_dump_filter *filter,
 				   struct netlink_callback *cb)
 {
-	return ip_valid_fib_dump_req(net, nlh, filter, cb);
+	return ip_filter_fib_dump_req(net, nlh, filter, cb, true);
 }
 #else
 static int mpls_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
-- 
2.20.1

