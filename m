Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456BB1D3358
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 16:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgENOpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 10:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgENOpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 10:45:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A30C061A0F;
        Thu, 14 May 2020 07:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=2BVQNCsHDXBi7WB9eP+yVXJsjaG+q+SsuFZ3NmsMQQw=; b=lX99B1uRP3pYmKlIgzDP5dMwJd
        4sl6qkveBzbWRcCpWh6rKL+2GmtW305SQ5q5U9RfPnEP4ILAaHpnO356HJu0e3lzvilfuf1DilPIF
        XaElNNUtP5CfvwQMzwDHxtl3E1mjT5MN0ExENrMVuOjSeCMh3cAWsixJqTwLDCGEGXpfyrzV9GSrN
        2JJDuVyT6vCsiuF4r2E1Y2PxeaMbrMOA6UBs2JCbjLetLRYADWLU97RIjRQrrFtcDorjf9TLzRk7m
        +ht9UdxNhLPRJ3FpEaKwD/bDtoEmAqjnr3Av33/YrGiyQfxQA9D4WvOAp40UjepwQNqrzArNqjVQY
        gsAAgk0A==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jZF7E-0004dC-31; Thu, 14 May 2020 14:45:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/4] ipv6: lift copy_from_user out of ipv6_route_ioctl
Date:   Thu, 14 May 2020 16:45:32 +0200
Message-Id: <20200514144535.3000410-2-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514144535.3000410-1-hch@lst.de>
References: <20200514144535.3000410-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare for better compat ioctl handling by moving the user copy out
of ipv6_route_ioctl.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/ip6_route.h |  3 ++-
 net/ipv6/af_inet6.c     | 16 +++++++++------
 net/ipv6/route.c        | 44 +++++++++++++++--------------------------
 3 files changed, 28 insertions(+), 35 deletions(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index e525f003e6197..2a5277758379e 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -118,7 +118,8 @@ void ip6_route_init_special_entries(void);
 int ip6_route_init(void);
 void ip6_route_cleanup(void);
 
-int ipv6_route_ioctl(struct net *net, unsigned int cmd, void __user *arg);
+int ipv6_route_ioctl(struct net *net, unsigned int cmd,
+		struct in6_rtmsg *rtmsg);
 
 int ip6_route_add(struct fib6_config *cfg, gfp_t gfp_flags,
 		  struct netlink_ext_ack *extack);
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 345baa0a754f4..066a85531edcd 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -542,19 +542,23 @@ int inet6_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 {
 	struct sock *sk = sock->sk;
 	struct net *net = sock_net(sk);
+	void __user *argp = (void __user *)arg;
 
 	switch (cmd) {
 	case SIOCADDRT:
-	case SIOCDELRT:
-
-		return ipv6_route_ioctl(net, cmd, (void __user *)arg);
+	case SIOCDELRT: {
+		struct in6_rtmsg rtmsg;
 
+		if (copy_from_user(&rtmsg, argp, sizeof(rtmsg)))
+			return -EFAULT;
+		return ipv6_route_ioctl(net, cmd, &rtmsg);
+	}
 	case SIOCSIFADDR:
-		return addrconf_add_ifaddr(net, (void __user *) arg);
+		return addrconf_add_ifaddr(net, argp);
 	case SIOCDIFADDR:
-		return addrconf_del_ifaddr(net, (void __user *) arg);
+		return addrconf_del_ifaddr(net, argp);
 	case SIOCSIFDSTADDR:
-		return addrconf_set_dstaddr(net, (void __user *) arg);
+		return addrconf_set_dstaddr(net, argp);
 	default:
 		if (!sk->sk_prot->ioctl)
 			return -ENOIOCTLCMD;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 4292653af533b..d4c344e6d1ac6 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4334,41 +4334,29 @@ static void rtmsg_to_fib6_config(struct net *net,
 	};
 }
 
-int ipv6_route_ioctl(struct net *net, unsigned int cmd, void __user *arg)
+int ipv6_route_ioctl(struct net *net, unsigned int cmd, struct in6_rtmsg *rtmsg)
 {
 	struct fib6_config cfg;
-	struct in6_rtmsg rtmsg;
 	int err;
 
-	switch (cmd) {
-	case SIOCADDRT:		/* Add a route */
-	case SIOCDELRT:		/* Delete a route */
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
-			return -EPERM;
-		err = copy_from_user(&rtmsg, arg,
-				     sizeof(struct in6_rtmsg));
-		if (err)
-			return -EFAULT;
+	if (cmd != SIOCADDRT && cmd != SIOCDELRT)
+		return -EINVAL;
+	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		return -EPERM;
 
-		rtmsg_to_fib6_config(net, &rtmsg, &cfg);
+	rtmsg_to_fib6_config(net, rtmsg, &cfg);
 
-		rtnl_lock();
-		switch (cmd) {
-		case SIOCADDRT:
-			err = ip6_route_add(&cfg, GFP_KERNEL, NULL);
-			break;
-		case SIOCDELRT:
-			err = ip6_route_del(&cfg, NULL);
-			break;
-		default:
-			err = -EINVAL;
-		}
-		rtnl_unlock();
-
-		return err;
+	rtnl_lock();
+	switch (cmd) {
+	case SIOCADDRT:
+		err = ip6_route_add(&cfg, GFP_KERNEL, NULL);
+		break;
+	case SIOCDELRT:
+		err = ip6_route_del(&cfg, NULL);
+		break;
 	}
-
-	return -EINVAL;
+	rtnl_unlock();
+	return err;
 }
 
 /*
-- 
2.26.2

