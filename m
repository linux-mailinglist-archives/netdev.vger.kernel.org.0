Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52201BAFD1
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgD0U44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726233AbgD0U4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:56:55 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC38C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:56:55 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id n16so9225227pgb.7
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SiRdbPViwxIMrz5HzQL0ns04IOMq5sMONt9N9D1KnwQ=;
        b=e9PBXj4Jjn6idG+Ym2uNon5N6dZgw+GIRwWex11wYoYwN4wfMZp0BB3z4PgNSbG7WG
         c9IpScYEfyIksuth1xv2S8+REb3SCMG9wRx2bGPLTo5GkJTQWaTkJkZVV2NVTXx2Csve
         B22t+r5Z+mxngcNt+wcZ8b8q8NEBNAa4X6gIY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SiRdbPViwxIMrz5HzQL0ns04IOMq5sMONt9N9D1KnwQ=;
        b=k16qvpaE5gDR0Wqbxbwr1KEqroB9b6zOxqk1Wtg3SgPNeiGak3RkFhakdzQ0UNPXhc
         bloVfvWmx2rwmmAwBFL4ahDtsRkc5Qdn6Y7XOWlsR44QyyLrPoumbZsH86WU2vt2rE46
         Gx4UgAaAjfbVMrG/E9zZHn/9BOAKsYUOfhzzqduaCaCX7v33DncfZTnSiZRqgx5HphRZ
         uIV29zOiWAfZenaRmw2AQb7O1FPCTmpaXQ0KV3wkJPb72pElN/WYIHqStoQ8tOzU0c0M
         xZuceSdCG13r3LbaUuZkMTAyQD7/FTIDq0X13ife0Ww4JweB96g7Pn44P++lOOm/+0Zw
         c6/Q==
X-Gm-Message-State: AGi0PuY7f053CVmzA33cLOdH5rAqD9vPZyDAttT/4nWkjDaI/q+/ldvG
        /IWQq/qFPhvJqUPS8sLCJn7AHw==
X-Google-Smtp-Source: APiQypLYrff0IhLBIj6o0U44P81Ww3HCAbJscyjcXTXRWdPp30xKoCO8asPka+eUgn/6hgUx3hFCZQ==
X-Received: by 2002:a62:764b:: with SMTP id r72mr25889144pfc.207.1588021014459;
        Mon, 27 Apr 2020 13:56:54 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id fh18sm443830pjb.0.2020.04.27.13.56.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 13:56:53 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, rdunlap@infradead.org,
        nikolay@cumulusnetworks.com, bpoirier@cumulusnetworks.com
Subject: [PATCH net-next v4 1/3] net: ipv6: new arg skip_notify to ip6_rt_del
Date:   Mon, 27 Apr 2020 13:56:45 -0700
Message-Id: <1588021007-16914-2-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1588021007-16914-1-git-send-email-roopa@cumulusnetworks.com>
References: <1588021007-16914-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

Used in subsequent work to skip route delete
notifications on nexthop deletes.

Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 include/net/ip6_route.h  |  2 +-
 include/net/ipv6_stubs.h |  2 +-
 net/ipv4/nexthop.c       |  2 +-
 net/ipv6/addrconf.c      | 12 ++++++------
 net/ipv6/addrconf_core.c |  3 ++-
 net/ipv6/anycast.c       |  4 ++--
 net/ipv6/ndisc.c         |  2 +-
 net/ipv6/route.c         | 11 +++++++----
 8 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 9947eb1..e525f00 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -123,7 +123,7 @@ int ipv6_route_ioctl(struct net *net, unsigned int cmd, void __user *arg);
 int ip6_route_add(struct fib6_config *cfg, gfp_t gfp_flags,
 		  struct netlink_ext_ack *extack);
 int ip6_ins_rt(struct net *net, struct fib6_info *f6i);
-int ip6_del_rt(struct net *net, struct fib6_info *f6i);
+int ip6_del_rt(struct net *net, struct fib6_info *f6i, bool skip_notify);
 
 void rt6_flush_exceptions(struct fib6_info *f6i);
 void rt6_age_exceptions(struct fib6_info *f6i, struct fib6_gc_args *gc_args,
diff --git a/include/net/ipv6_stubs.h b/include/net/ipv6_stubs.h
index 3e7d2c0..a5f7c12 100644
--- a/include/net/ipv6_stubs.h
+++ b/include/net/ipv6_stubs.h
@@ -48,7 +48,7 @@ struct ipv6_stub {
 			    struct netlink_ext_ack *extack);
 	void (*fib6_nh_release)(struct fib6_nh *fib6_nh);
 	void (*fib6_update_sernum)(struct net *net, struct fib6_info *rt);
-	int (*ip6_del_rt)(struct net *net, struct fib6_info *rt);
+	int (*ip6_del_rt)(struct net *net, struct fib6_info *rt, bool skip_notify);
 	void (*fib6_rt_update)(struct net *net, struct fib6_info *rt,
 			       struct nl_info *info);
 
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index fdfca53..9999687 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -784,7 +784,7 @@ static void __remove_nexthop_fib(struct net *net, struct nexthop *nh)
 	list_for_each_entry_safe(f6i, tmp, &nh->f6i_list, nh_list) {
 		/* __ip6_del_rt does a release, so do a hold here */
 		fib6_info_hold(f6i);
-		ipv6_stub->ip6_del_rt(net, f6i);
+		ipv6_stub->ip6_del_rt(net, f6i, false);
 	}
 }
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 24e319d..e49b9e9 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1238,7 +1238,7 @@ cleanup_prefix_route(struct inet6_ifaddr *ifp, unsigned long expires,
 					ifp->idev->dev, 0, RTF_DEFAULT, true);
 	if (f6i) {
 		if (del_rt)
-			ip6_del_rt(dev_net(ifp->idev->dev), f6i);
+			ip6_del_rt(dev_net(ifp->idev->dev), f6i, false);
 		else {
 			if (!(f6i->fib6_flags & RTF_EXPIRES))
 				fib6_set_expires(f6i, expires);
@@ -2731,7 +2731,7 @@ void addrconf_prefix_rcv(struct net_device *dev, u8 *opt, int len, bool sllao)
 		if (rt) {
 			/* Autoconf prefix route */
 			if (valid_lft == 0) {
-				ip6_del_rt(net, rt);
+				ip6_del_rt(net, rt, false);
 				rt = NULL;
 			} else if (addrconf_finite_timeout(rt_expires)) {
 				/* not infinity */
@@ -3826,7 +3826,7 @@ static int addrconf_ifdown(struct net_device *dev, int how)
 		spin_unlock_bh(&ifa->lock);
 
 		if (rt)
-			ip6_del_rt(net, rt);
+			ip6_del_rt(net, rt, false);
 
 		if (state != INET6_IFADDR_STATE_DEAD) {
 			__ipv6_ifa_notify(RTM_DELADDR, ifa);
@@ -4665,7 +4665,7 @@ static int modify_prefix_route(struct inet6_ifaddr *ifp,
 	prio = ifp->rt_priority ? : IP6_RT_PRIO_ADDRCONF;
 	if (f6i->fib6_metric != prio) {
 		/* delete old one */
-		ip6_del_rt(dev_net(ifp->idev->dev), f6i);
+		ip6_del_rt(dev_net(ifp->idev->dev), f6i, false);
 
 		/* add new one */
 		addrconf_prefix_route(modify_peer ? &ifp->peer_addr : &ifp->addr,
@@ -6086,10 +6086,10 @@ static void __ipv6_ifa_notify(int event, struct inet6_ifaddr *ifp)
 						       ifp->idev->dev, 0, 0,
 						       false);
 			if (rt)
-				ip6_del_rt(net, rt);
+				ip6_del_rt(net, rt, false);
 		}
 		if (ifp->rt) {
-			ip6_del_rt(net, ifp->rt);
+			ip6_del_rt(net, ifp->rt, false);
 			ifp->rt = NULL;
 		}
 		rt_genid_bump_ipv6(net);
diff --git a/net/ipv6/addrconf_core.c b/net/ipv6/addrconf_core.c
index ea00ce3..9ebf3fe 100644
--- a/net/ipv6/addrconf_core.c
+++ b/net/ipv6/addrconf_core.c
@@ -185,7 +185,8 @@ static int eafnosupport_fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 	return -EAFNOSUPPORT;
 }
 
-static int eafnosupport_ip6_del_rt(struct net *net, struct fib6_info *rt)
+static int eafnosupport_ip6_del_rt(struct net *net, struct fib6_info *rt,
+				   bool skip_notify)
 {
 	return -EAFNOSUPPORT;
 }
diff --git a/net/ipv6/anycast.c b/net/ipv6/anycast.c
index fed91ab..8932612 100644
--- a/net/ipv6/anycast.c
+++ b/net/ipv6/anycast.c
@@ -364,7 +364,7 @@ int __ipv6_dev_ac_dec(struct inet6_dev *idev, const struct in6_addr *addr)
 	ipv6_del_acaddr_hash(aca);
 	addrconf_leave_solict(idev, &aca->aca_addr);
 
-	ip6_del_rt(dev_net(idev->dev), aca->aca_rt);
+	ip6_del_rt(dev_net(idev->dev), aca->aca_rt, false);
 
 	aca_put(aca);
 	return 0;
@@ -393,7 +393,7 @@ void ipv6_ac_destroy_dev(struct inet6_dev *idev)
 
 		addrconf_leave_solict(idev, &aca->aca_addr);
 
-		ip6_del_rt(dev_net(idev->dev), aca->aca_rt);
+		ip6_del_rt(dev_net(idev->dev), aca->aca_rt, false);
 
 		aca_put(aca);
 
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 1ecd4e9..2d09c4d 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1302,7 +1302,7 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 		}
 	}
 	if (rt && lifetime == 0) {
-		ip6_del_rt(net, rt);
+		ip6_del_rt(net, rt, false);
 		rt = NULL;
 	}
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 310cbdd..486c36a 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -984,7 +984,7 @@ int rt6_route_rcv(struct net_device *dev, u8 *opt, int len,
 					gwaddr, dev);
 
 	if (rt && !lifetime) {
-		ip6_del_rt(net, rt);
+		ip6_del_rt(net, rt, false);
 		rt = NULL;
 	}
 
@@ -3729,9 +3729,12 @@ static int __ip6_del_rt(struct fib6_info *rt, struct nl_info *info)
 	return err;
 }
 
-int ip6_del_rt(struct net *net, struct fib6_info *rt)
+int ip6_del_rt(struct net *net, struct fib6_info *rt, bool skip_notify)
 {
-	struct nl_info info = { .nl_net = net };
+	struct nl_info info = {
+		.nl_net = net,
+		.skip_notify = skip_notify
+	};
 
 	return __ip6_del_rt(rt, &info);
 }
@@ -4252,7 +4255,7 @@ static void __rt6_purge_dflt_routers(struct net *net,
 		    (!idev || idev->cnf.accept_ra != 2) &&
 		    fib6_info_hold_safe(rt)) {
 			rcu_read_unlock();
-			ip6_del_rt(net, rt);
+			ip6_del_rt(net, rt, false);
 			goto restart;
 		}
 	}
-- 
2.1.4

