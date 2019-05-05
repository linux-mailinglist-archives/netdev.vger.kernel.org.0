Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B33DD14125
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 18:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbfEEQjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 12:39:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727232AbfEEQjm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 12:39:42 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1407A208CA;
        Sun,  5 May 2019 16:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557074381;
        bh=oS6pyNLSe0WRCRZhD66o8fSkifjyMnl8OQHP7StbAW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=st0xVTcabZ18Ko5ZTSGZl206OsmILiWoiQRewwOrOEa4+c9wxa2HN6YPIJKf6tM+c
         f2fjVJne/wh7Mda4HNup7kG+mxHaiMlEEwtzYWRbZ/NtwaZrKB9+9HWw2GBVvwu1oM
         KtPLnYdD062RECvZSDgT/F0i5qWt+PRI0rM5Vv1s=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 3/7] ipv6: export function to send route updates
Date:   Sun,  5 May 2019 09:40:52 -0700
Message-Id: <20190505164056.1742-4-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190505164056.1742-1-dsahern@kernel.org>
References: <20190505164056.1742-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add fib6_rt_update to send RTM_NEWROUTE with NLM_F_REPLACE set. This
helper will be used by the nexthop code to notify userspace of routes
that are impacted when a nexthop config is updated via replace.

This notification is needed for legacy apps that do not understand
the new nexthop object. Apps that are nexthop aware can use the
RTA_NH_ID attribute in the route notification to just ignore it.

In the future this should be wrapped in a sysctl to allow OS'es that
are fully updated to avoid the notificaton storm.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/ip6_fib.h    |  6 ++++++
 include/net/ipv6_stubs.h |  3 +++
 net/ipv6/af_inet6.c      |  1 +
 net/ipv6/ip6_fib.c       |  8 ++++----
 net/ipv6/route.c         | 32 ++++++++++++++++++++++++++++++++
 5 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index d1f1f94e0267..296939183bdb 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -451,6 +451,12 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 		 struct netlink_ext_ack *extack);
 void fib6_nh_release(struct fib6_nh *fib6_nh);
 
+int call_fib6_entry_notifiers(struct net *net,
+			      enum fib_event_type event_type,
+			      struct fib6_info *rt,
+			      struct netlink_ext_ack *extack);
+void fib6_rt_update(struct net *net, struct fib6_info *rt,
+		    struct nl_info *info);
 void inet6_rt_notify(int event, struct fib6_info *rt, struct nl_info *info,
 		     unsigned int flags);
 
diff --git a/include/net/ipv6_stubs.h b/include/net/ipv6_stubs.h
index 97f42e16b3b3..5c93e942c50b 100644
--- a/include/net/ipv6_stubs.h
+++ b/include/net/ipv6_stubs.h
@@ -47,6 +47,9 @@ struct ipv6_stub {
 	void (*fib6_nh_release)(struct fib6_nh *fib6_nh);
 	void (*fib6_update_sernum)(struct net *net, struct fib6_info *rt);
 	int (*ip6_del_rt)(struct net *net, struct fib6_info *rt);
+	void (*fib6_rt_update)(struct net *net, struct fib6_info *rt,
+			       struct nl_info *info);
+
 	void (*udpv6_encap_enable)(void);
 	void (*ndisc_send_na)(struct net_device *dev, const struct in6_addr *daddr,
 			      const struct in6_addr *solicited_addr,
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 55138f0d2b9d..cc6f8d0c625a 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -927,6 +927,7 @@ static const struct ipv6_stub ipv6_stub_impl = {
 	.fib6_nh_init	   = fib6_nh_init,
 	.fib6_nh_release   = fib6_nh_release,
 	.fib6_update_sernum = fib6_update_sernum_stub,
+	.fib6_rt_update	   = fib6_rt_update,
 	.ip6_del_rt	   = ip6_del_rt,
 	.udpv6_encap_enable = udpv6_encap_enable,
 	.ndisc_send_na = ndisc_send_na,
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index c333a9710034..305a5ed0f8d8 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -393,10 +393,10 @@ static int call_fib6_entry_notifier(struct notifier_block *nb, struct net *net,
 	return call_fib6_notifier(nb, net, event_type, &info.info);
 }
 
-static int call_fib6_entry_notifiers(struct net *net,
-				     enum fib_event_type event_type,
-				     struct fib6_info *rt,
-				     struct netlink_ext_ack *extack)
+int call_fib6_entry_notifiers(struct net *net,
+			      enum fib_event_type event_type,
+			      struct fib6_info *rt,
+			      struct netlink_ext_ack *extack)
 {
 	struct fib6_entry_notifier_info info = {
 		.info.extack = extack,
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 23a20d62daac..e737b4fb61af 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5113,6 +5113,38 @@ void inet6_rt_notify(int event, struct fib6_info *rt, struct nl_info *info,
 		rtnl_set_sk_err(net, RTNLGRP_IPV6_ROUTE, err);
 }
 
+void fib6_rt_update(struct net *net, struct fib6_info *rt,
+		    struct nl_info *info)
+{
+	u32 seq = info->nlh ? info->nlh->nlmsg_seq : 0;
+	struct sk_buff *skb;
+	int err = -ENOBUFS;
+
+	/* call_fib6_entry_notifiers will be removed when in-kernel notifier
+	 * is implemented and supported for nexthop objects
+	 */
+	call_fib6_entry_notifiers(net, FIB_EVENT_ENTRY_REPLACE, rt, NULL);
+
+	skb = nlmsg_new(rt6_nlmsg_size(rt), gfp_any());
+	if (!skb)
+		goto errout;
+
+	err = rt6_fill_node(net, skb, rt, NULL, NULL, NULL, 0,
+			    RTM_NEWROUTE, info->portid, seq, NLM_F_REPLACE);
+	if (err < 0) {
+		/* -EMSGSIZE implies BUG in rt6_nlmsg_size() */
+		WARN_ON(err == -EMSGSIZE);
+		kfree_skb(skb);
+		goto errout;
+	}
+	rtnl_notify(skb, net, info->portid, RTNLGRP_IPV6_ROUTE,
+		    info->nlh, gfp_any());
+	return;
+errout:
+	if (err < 0)
+		rtnl_set_sk_err(net, RTNLGRP_IPV6_ROUTE, err);
+}
+
 static int ip6_route_dev_notify(struct notifier_block *this,
 				unsigned long event, void *ptr)
 {
-- 
2.11.0

