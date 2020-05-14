Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6B31D338D
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 16:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgENOvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 10:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728017AbgENOvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 10:51:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFE4C061A0E;
        Thu, 14 May 2020 07:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=0AUA+C35O90CNEqWuihWhLytXpVCKHU/MNxz8OyW+Og=; b=bHVMonzJJM6bd2Mw7qZZA5RVCZ
        9jYWddGzIR+yhHBBMOuK+6jTVuWG1SJszeWgxI3AOw5g5bHTUNKy5P8XagOC2kEVilXlIsprTCZnd
        TDpbJxzExaTxflRi6AksqgxgsIRtexQCgx6h3XGoNwtqn9ejWyH6d3yrYMfcE8rIXtFmNEeKlMlbi
        DPAEo18rOkVOYop4WksH37rCcY8WeDq4QTAzchGeDM3352feOsvq/0qiB8W0jtgYZbjYgzJyntJWX
        iQYryH/StjDY/YPcWm+HFoJcvkImjOMHe5OY2TjY50jdT7WwMi+FYheV45QE6hFE2qHOwU0fVdGVv
        bMHIBDNg==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jZFCd-0007w2-ON; Thu, 14 May 2020 14:51:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] ipv6: symbol_get to access a sit symbol
Date:   Thu, 14 May 2020 16:51:01 +0200
Message-Id: <20200514145101.3000612-5-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514145101.3000612-1-hch@lst.de>
References: <20200514145101.3000612-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of going through the ioctl handler from kernel space, use
symbol_get to the newly factored out ipip6_set_dstaddr helper, bypassing
addrconf.c entirely.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/addrconf.h |  1 -
 include/net/ipv6.h     |  2 ++
 net/ipv6/addrconf.c    | 66 ------------------------------------------
 net/ipv6/af_inet6.c    | 20 ++++++++++++-
 net/ipv6/sit.c         | 41 ++++++++++++++++++++++++++
 5 files changed, 62 insertions(+), 68 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index fdb07105384ca..569eb03ae2440 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -76,7 +76,6 @@ void addrconf_cleanup(void);
 
 int addrconf_add_ifaddr(struct net *net, void __user *arg);
 int addrconf_del_ifaddr(struct net *net, void __user *arg);
-int addrconf_set_dstaddr(struct net *net, void __user *arg);
 
 int ipv6_chk_addr(struct net *net, const struct in6_addr *addr,
 		  const struct net_device *dev, int strict);
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 955badd1e8ffc..1b983f32c87ce 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1080,6 +1080,8 @@ struct in6_addr *fl6_update_dst(struct flowi6 *fl6,
 				const struct ipv6_txoptions *opt,
 				struct in6_addr *orig);
 
+int ipip6_set_dstaddr(struct net *net, void __user *arg);
+
 /*
  *	socket options (ipv6_sockglue.c)
  */
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index fd885f06c4ed6..02186f00f91c5 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2783,72 +2783,6 @@ void addrconf_prefix_rcv(struct net_device *dev, u8 *opt, int len, bool sllao)
 	in6_dev_put(in6_dev);
 }
 
-/*
- *	Set destination address.
- *	Special case for SIT interfaces where we create a new "virtual"
- *	device.
- */
-int addrconf_set_dstaddr(struct net *net, void __user *arg)
-{
-	struct in6_ifreq ireq;
-	struct net_device *dev;
-	int err = -EINVAL;
-
-	rtnl_lock();
-
-	err = -EFAULT;
-	if (copy_from_user(&ireq, arg, sizeof(struct in6_ifreq)))
-		goto err_exit;
-
-	dev = __dev_get_by_index(net, ireq.ifr6_ifindex);
-
-	err = -ENODEV;
-	if (!dev)
-		goto err_exit;
-
-#if IS_ENABLED(CONFIG_IPV6_SIT)
-	if (dev->type == ARPHRD_SIT) {
-		const struct net_device_ops *ops = dev->netdev_ops;
-		struct ifreq ifr;
-		struct ip_tunnel_parm p;
-
-		err = -EADDRNOTAVAIL;
-		if (!(ipv6_addr_type(&ireq.ifr6_addr) & IPV6_ADDR_COMPATv4))
-			goto err_exit;
-
-		memset(&p, 0, sizeof(p));
-		p.iph.daddr = ireq.ifr6_addr.s6_addr32[3];
-		p.iph.saddr = 0;
-		p.iph.version = 4;
-		p.iph.ihl = 5;
-		p.iph.protocol = IPPROTO_IPV6;
-		p.iph.ttl = 64;
-		ifr.ifr_ifru.ifru_data = (__force void __user *)&p;
-
-		if (ops->ndo_do_ioctl) {
-			mm_segment_t oldfs = get_fs();
-
-			set_fs(KERNEL_DS);
-			err = ops->ndo_do_ioctl(dev, &ifr, SIOCADDTUNNEL);
-			set_fs(oldfs);
-		} else
-			err = -EOPNOTSUPP;
-
-		if (err == 0) {
-			err = -ENOBUFS;
-			dev = __dev_get_by_name(net, p.name);
-			if (!dev)
-				goto err_exit;
-			err = dev_open(dev, NULL);
-		}
-	}
-#endif
-
-err_exit:
-	rtnl_unlock();
-	return err;
-}
-
 static int ipv6_mc_config(struct sock *sk, bool join,
 			  const struct in6_addr *addr, int ifindex)
 {
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 345baa0a754f4..3ec9734c7bb11 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -538,6 +538,19 @@ int inet6_getname(struct socket *sock, struct sockaddr *uaddr,
 }
 EXPORT_SYMBOL(inet6_getname);
 
+static int inet6_ioctl_set_dstaddr(struct net *net, void __user *arg)
+{
+	int (*set_dstaddr)(struct net *, void __user *);
+	int err;
+
+	set_dstaddr = symbol_get(ipip6_set_dstaddr);
+	if (!set_dstaddr)
+		return -EOPNOTSUPP;
+	err = set_dstaddr(net, arg);
+	symbol_put(ipip6_set_dstaddr);
+	return err;
+}
+
 int inet6_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 {
 	struct sock *sk = sock->sk;
@@ -554,7 +567,12 @@ int inet6_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 	case SIOCDIFADDR:
 		return addrconf_del_ifaddr(net, (void __user *) arg);
 	case SIOCSIFDSTADDR:
-		return addrconf_set_dstaddr(net, (void __user *) arg);
+		/* Special case for SIT interfaces where we create a new
+		 * "virtual" device.
+		 */
+		if (!IS_ENABLED(CONFIG_IPV6_SIT))
+			return -ENODEV;
+		return inet6_ioctl_set_dstaddr(net, (void __user *) arg);
 	default:
 		if (!sk->sk_prot->ioctl)
 			return -ENOIOCTLCMD;
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 98954830c40ba..cb2cfa297f72e 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -274,6 +274,47 @@ static struct ip_tunnel *ipip6_tunnel_locate(struct net *net,
 	return NULL;
 }
 
+int ipip6_set_dstaddr(struct net *net, void __user *arg)
+{
+	struct ip_tunnel_parm p = { };
+	struct in6_ifreq ireq;
+	struct net_device *tunnel_dev, *new_dev;
+	int err;
+
+	rtnl_lock();
+	err = -EFAULT;
+	if (copy_from_user(&ireq, arg, sizeof(struct in6_ifreq)))
+		goto out_unlock;
+
+	err = -ENODEV;
+	tunnel_dev = __dev_get_by_index(net, ireq.ifr6_ifindex);
+	if (!tunnel_dev || tunnel_dev->type != ARPHRD_SIT)
+		goto out_unlock;
+
+	err = -EADDRNOTAVAIL;
+	if (!(ipv6_addr_type(&ireq.ifr6_addr) & IPV6_ADDR_COMPATv4))
+		goto out_unlock;
+
+	p.iph.daddr = ireq.ifr6_addr.s6_addr32[3];
+	p.iph.version = 4;
+	p.iph.ihl = 5;
+	p.iph.protocol = IPPROTO_IPV6;
+	p.iph.ttl = 64;
+	p.iph.frag_off |= htons(IP_DF);
+
+	err = -ENOBUFS;
+	if (!ipip6_tunnel_locate(dev_net(tunnel_dev), &p, true))
+		goto out_unlock;
+	new_dev = __dev_get_by_name(net, p.name);
+	if (!new_dev)
+		goto out_unlock;
+	err = dev_open(new_dev, NULL);
+out_unlock:
+	rtnl_unlock();
+	return err;
+}
+EXPORT_SYMBOL_GPL(ipip6_set_dstaddr);
+
 #define for_each_prl_rcu(start)			\
 	for (prl = rcu_dereference(start);	\
 	     prl;				\
-- 
2.26.2

