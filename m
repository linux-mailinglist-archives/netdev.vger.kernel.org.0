Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D01E1D4F1E
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 15:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgEONTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 09:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728137AbgEONTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 09:19:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84767C061A0C;
        Fri, 15 May 2020 06:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=3aA4Dy5irn9KUfPetvGr9uuC2NSR5Zc/mpWqXYNfG7Q=; b=HqdBAbP16PND4yP8/kylBzQf09
        dOG1qgp1wB4KLhm9e9lxMwJiO8fFq+FyTS+sk03v+1DGs+qJCeTje5Uxc0lX0JLWhkBtaNvfHQS7l
        d453gDfsnUl1zJq4RuIz2nBEPyzPHiW9YR5RtaQa9bkKRuJ5HunQsIVBnZDrOwgWHxGcrZz+aTe1V
        hXhUnlwVAHuu1VOzesm30Uvlbp28vp9nYr9m3Z7/XTnkXdyrXc6BvzwWwoSM0KV03MLbab52pyNnR
        NiNChbhm2pTqlZW4xq3D4oQmE1OEn0CCG32hvlsiwS5bfVmukhfdjt0D7tnaV7Kybum686PHWWtD6
        JRkk6O6A==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jZaFN-0006YT-Ni; Fri, 15 May 2020 13:19:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/4] ipv6: lift copy_from_user out of ipv6_route_ioctl
Date:   Fri, 15 May 2020 15:19:22 +0200
Message-Id: <20200515131925.3855053-2-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515131925.3855053-1-hch@lst.de>
References: <20200515131925.3855053-1-hch@lst.de>
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
index 771a462a8322b..a618beb9b6d54 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -542,21 +542,25 @@ EXPORT_SYMBOL(inet6_getname);
 
 int inet6_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 {
+	void __user *argp = (void __user *)arg;
 	struct sock *sk = sock->sk;
 	struct net *net = sock_net(sk);
 
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
index fcf0d5c87d097..883702fddc065 100644
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

