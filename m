Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22C8431954
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 05:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfFADgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 23:36:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbfFADgY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 23:36:24 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25B36270D6;
        Sat,  1 Jun 2019 03:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559360184;
        bh=Yws4HhZHU3RJ+aFa4f6N1CumGHxMAm1zwUa77pyRGBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fypdlmgI27FtJWBwgAYHRUOtiw/ZPGvoUlnWDXJASdMbFmOMBJ+AUqGLhzm0hQSzV
         DkES3lFOsihTWdcXwKFYgndPkBhvxEpFiiOSs4yHFpAwqh34bM0NACGibMh4ouEjMJ
         0oq412GHaXWf/y7HUyPn7FMLEAw8UMGhBiMeftDg=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     alexei.starovoitov@gmail.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH RFC net-next 20/27] ipv6: Allow routes to use nexthop objects
Date:   Fri, 31 May 2019 20:36:11 -0700
Message-Id: <20190601033618.27702-21-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601033618.27702-1-dsahern@kernel.org>
References: <20190601033618.27702-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add support for RTA_NH_ID attribute to allow a user to specify a
nexthop id to use with a route. fc_nh_id is added to fib6_config to
hold the value passed in the RTA_NH_ID attribute. If a nexthop id
is given, the gateway, device, encap and multipath attributes can
not be set.

Update ip6_route_del to check metric and protocol before nexthop
specs. If fc_nh_id is set, then it must match the id in the route
entry. Since IPv6 allows delete of a cached entry (an exception),
add ip6_del_cached_rt_nh to cycle through all of the fib6_nh in
a fib entry if it is using a nexthop.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/ip6_fib.h |  1 +
 net/ipv6/route.c      | 89 ++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 82 insertions(+), 8 deletions(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 1a8acd51b277..ef946578341f 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -53,6 +53,7 @@ struct fib6_config {
 	u16		fc_delete_all_nh : 1,
 			fc_ignore_dev_down:1,
 			__unused : 14;
+	u32		fc_nh_id;
 
 	struct in6_addr	fc_dst;
 	struct in6_addr	fc_src;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index d967753bc75a..29c2f5086116 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3541,6 +3541,16 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 		goto out;
 	}
 #endif
+	if (cfg->fc_nh_id) {
+		nh = nexthop_find_by_id(net, cfg->fc_nh_id);
+		if (!nh) {
+			NL_SET_ERR_MSG(extack, "Nexthop id does not exist");
+			goto out;
+		}
+		err = fib6_check_nexthop(nh, cfg, extack);
+		if (err)
+			goto out;
+	}
 
 	err = -ENOBUFS;
 	if (cfg->fc_nlinfo.nlh &&
@@ -3772,6 +3782,30 @@ static int ip6_del_cached_rt(struct fib6_config *cfg, struct fib6_info *rt,
 	return 0;
 }
 
+struct fib6_nh_del_cached_rt_arg {
+	struct fib6_config *cfg;
+	struct fib6_info *f6i;
+};
+
+static int fib6_nh_del_cached_rt(struct fib6_nh *nh, void *_arg)
+{
+	struct fib6_nh_del_cached_rt_arg *arg = _arg;
+	int rc;
+
+	rc = ip6_del_cached_rt(arg->cfg, arg->f6i, nh);
+	return rc != -ESRCH ? rc : 0;
+}
+
+static int ip6_del_cached_rt_nh(struct fib6_config *cfg, struct fib6_info *f6i)
+{
+	struct fib6_nh_del_cached_rt_arg arg = {
+		.cfg = cfg,
+		.f6i = f6i
+	};
+
+	return nexthop_for_each_fib6_nh(f6i->nh, fib6_nh_del_cached_rt, &arg);
+}
+
 static int ip6_route_del(struct fib6_config *cfg,
 			 struct netlink_ext_ack *extack)
 {
@@ -3797,11 +3831,20 @@ static int ip6_route_del(struct fib6_config *cfg,
 		for_each_fib6_node_rt_rcu(fn) {
 			struct fib6_nh *nh;
 
-			nh = rt->fib6_nh;
-			if (cfg->fc_flags & RTF_CACHE) {
-				int rc;
+			if (rt->nh && rt->nh->id != cfg->fc_nh_id)
+				continue;
 
-				rc = ip6_del_cached_rt(cfg, rt, nh);
+			if (cfg->fc_flags & RTF_CACHE) {
+				int rc = 0;
+
+				if (rt->nh) {
+					rc = ip6_del_cached_rt_nh(cfg, rt);
+				} else if (cfg->fc_nh_id) {
+					continue;
+				} else {
+					nh = rt->fib6_nh;
+					rc = ip6_del_cached_rt(cfg, rt, nh);
+				}
 				if (rc != -ESRCH) {
 					rcu_read_unlock();
 					return rc;
@@ -3809,6 +3852,23 @@ static int ip6_route_del(struct fib6_config *cfg,
 				continue;
 			}
 
+			if (cfg->fc_metric && cfg->fc_metric != rt->fib6_metric)
+				continue;
+			if (cfg->fc_protocol &&
+			    cfg->fc_protocol != rt->fib6_protocol)
+				continue;
+
+			if (rt->nh) {
+				if (!fib6_info_hold_safe(rt))
+					continue;
+				rcu_read_unlock();
+
+				return __ip6_del_rt(rt, &cfg->fc_nlinfo);
+			}
+			if (cfg->fc_nh_id)
+				continue;
+
+			nh = rt->fib6_nh;
 			if (cfg->fc_ifindex &&
 			    (!nh->fib_nh_dev ||
 			     nh->fib_nh_dev->ifindex != cfg->fc_ifindex))
@@ -3816,10 +3876,6 @@ static int ip6_route_del(struct fib6_config *cfg,
 			if (cfg->fc_flags & RTF_GATEWAY &&
 			    !ipv6_addr_equal(&cfg->fc_gateway, &nh->fib_nh_gw6))
 				continue;
-			if (cfg->fc_metric && cfg->fc_metric != rt->fib6_metric)
-				continue;
-			if (cfg->fc_protocol && cfg->fc_protocol != rt->fib6_protocol)
-				continue;
 			if (!fib6_info_hold_safe(rt))
 				continue;
 			rcu_read_unlock();
@@ -4719,6 +4775,7 @@ static const struct nla_policy rtm_ipv6_policy[RTA_MAX+1] = {
 	[RTA_IP_PROTO]		= { .type = NLA_U8 },
 	[RTA_SPORT]		= { .type = NLA_U16 },
 	[RTA_DPORT]		= { .type = NLA_U16 },
+	[RTA_NH_ID]		= { .type = NLA_U32 },
 };
 
 static int rtm_to_fib6_config(struct sk_buff *skb, struct nlmsghdr *nlh,
@@ -4765,6 +4822,16 @@ static int rtm_to_fib6_config(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	cfg->fc_flags |= (rtm->rtm_flags & RTNH_F_ONLINK);
 
+	if (tb[RTA_NH_ID]) {
+		if (tb[RTA_GATEWAY]   || tb[RTA_OIF] ||
+		    tb[RTA_MULTIPATH] || tb[RTA_ENCAP]) {
+			NL_SET_ERR_MSG(extack,
+				       "Nexthop specification and nexthop id are mutually exclusive");
+			goto errout;
+		}
+		cfg->fc_nh_id = nla_get_u32(tb[RTA_NH_ID]);
+	}
+
 	if (tb[RTA_GATEWAY]) {
 		cfg->fc_gateway = nla_get_in6_addr(tb[RTA_GATEWAY]);
 		cfg->fc_flags |= RTF_GATEWAY;
@@ -5099,6 +5166,12 @@ static int inet6_rtm_delroute(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err < 0)
 		return err;
 
+	if (cfg.fc_nh_id &&
+	    !nexthop_find_by_id(sock_net(skb->sk), cfg.fc_nh_id)) {
+		NL_SET_ERR_MSG(extack, "Nexthop id does not exist");
+		return -EINVAL;
+	}
+
 	if (cfg.fc_mp)
 		return ip6_route_multipath_del(&cfg, extack);
 	else {
-- 
2.11.0

