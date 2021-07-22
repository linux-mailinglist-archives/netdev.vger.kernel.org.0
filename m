Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10443D25CA
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbhGVNtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:49:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232416AbhGVNsy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 09:48:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F14936127C;
        Thu, 22 Jul 2021 14:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626964169;
        bh=EOoIV2dalOPoEOZSfB56YVD829AJM/wltGQv+39YEKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eJPc+NbmXXXaKlj20nVhfscCVtIKkyAxPO7AioVBZYsLewdsbmpQIaYydtmRbVCuH
         rd9PFjnJ/59OdaKmCuXeE0a/CM7uK6dJbxFhqCjvejP+RyaEAM26TCNCs5kNzkSleJ
         z/z9I9kmy+XJ9YpsNVpzr58vQTXBcjzv0vdYR1Z5sRFgZyqMuGi4kpCBGG5iFMA5Ti
         EeMjmsZwypvBDlya1Ck8MJ9MedeQR4CgiH9PLKEDqIjR/2mPGFcYGV//E/t8QkGrzT
         HHnr14zixu2TEZr5MAZ6tcVgBaGyAGYZ8C2AGYPPKMSE6CCB5/rxFDreW1yfcqCItu
         k5Su1ydchP2zA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Christoph Hellwig <hch@lst.de>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [PATCH net-next v6 4/6] net: socket: remove register_gifconf
Date:   Thu, 22 Jul 2021 16:29:01 +0200
Message-Id: <20210722142903.213084-5-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210722142903.213084-1-arnd@kernel.org>
References: <20210722142903.213084-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Since dynamic registration of the gifconf() helper is only used for
IPv4, and this can not be in a loadable module, this can be simplified
noticeably by turning it into a direct function call as a preparation
for cleaning up the compat handling.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
changes in v6:
- split register_gifconf from compat changes
---
 include/linux/inetdevice.h |  9 ++++++++
 include/linux/netdevice.h  |  8 -------
 net/core/dev_ioctl.c       | 43 +++++++++-----------------------------
 net/ipv4/devinet.c         |  4 +---
 4 files changed, 20 insertions(+), 44 deletions(-)

diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index 53aa0343bf69..67e042932681 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -178,6 +178,15 @@ static inline struct net_device *ip_dev_find(struct net *net, __be32 addr)
 
 int inet_addr_onlink(struct in_device *in_dev, __be32 a, __be32 b);
 int devinet_ioctl(struct net *net, unsigned int cmd, struct ifreq *);
+#ifdef CONFIG_INET
+int inet_gifconf(struct net_device *dev, char __user *buf, int len, int size);
+#else
+static inline int inet_gifconf(struct net_device *dev, char __user *buf,
+			       int len, int size)
+{
+	return 0;
+}
+#endif
 void devinet_init(void);
 struct in_device *inetdev_by_index(struct net *, int);
 __be32 inet_select_addr(const struct net_device *dev, __be32 dst, int scope);
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 42f6f866d5f3..6630a9f0b0f0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3289,14 +3289,6 @@ static inline bool dev_has_header(const struct net_device *dev)
 	return dev->header_ops && dev->header_ops->create;
 }
 
-typedef int gifconf_func_t(struct net_device * dev, char __user * bufptr,
-			   int len, int size);
-int register_gifconf(unsigned int family, gifconf_func_t *gifconf);
-static inline int unregister_gifconf(unsigned int family)
-{
-	return register_gifconf(family, NULL);
-}
-
 #ifdef CONFIG_NET_FLOW_LIMIT
 #define FLOW_LIMIT_HISTORY	(1 << 7)  /* must be ^2 and !overflow buckets */
 struct sd_flow_limit {
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 62f45da7ecfe..c22c3dc15ce9 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/kmod.h>
 #include <linux/netdevice.h>
+#include <linux/inetdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/net_tstamp.h>
@@ -25,26 +26,6 @@ static int dev_ifname(struct net *net, struct ifreq *ifr)
 	return netdev_get_name(net, ifr->ifr_name, ifr->ifr_ifindex);
 }
 
-static gifconf_func_t *gifconf_list[NPROTO];
-
-/**
- *	register_gifconf	-	register a SIOCGIF handler
- *	@family: Address family
- *	@gifconf: Function handler
- *
- *	Register protocol dependent address dumping routines. The handler
- *	that is passed must not be freed or reused until it has been replaced
- *	by another handler.
- */
-int register_gifconf(unsigned int family, gifconf_func_t *gifconf)
-{
-	if (family >= NPROTO)
-		return -EINVAL;
-	gifconf_list[family] = gifconf;
-	return 0;
-}
-EXPORT_SYMBOL(register_gifconf);
-
 /*
  *	Perform a SIOCGIFCONF call. This structure will change
  *	size eventually, and there is nothing I can do about it.
@@ -72,19 +53,15 @@ int dev_ifconf(struct net *net, struct ifconf *ifc, int size)
 
 	total = 0;
 	for_each_netdev(net, dev) {
-		for (i = 0; i < NPROTO; i++) {
-			if (gifconf_list[i]) {
-				int done;
-				if (!pos)
-					done = gifconf_list[i](dev, NULL, 0, size);
-				else
-					done = gifconf_list[i](dev, pos + total,
-							       len - total, size);
-				if (done < 0)
-					return -EFAULT;
-				total += done;
-			}
-		}
+		int done;
+		if (!pos)
+			done = inet_gifconf(dev, NULL, 0, size);
+		else
+			done = inet_gifconf(dev, pos + total,
+					    len - total, size);
+		if (done < 0)
+			return -EFAULT;
+		total += done;
 	}
 
 	/*
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 94b648d9eaff..c82aded8da7d 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1243,7 +1243,7 @@ int devinet_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr)
 	return ret;
 }
 
-static int inet_gifconf(struct net_device *dev, char __user *buf, int len, int size)
+int inet_gifconf(struct net_device *dev, char __user *buf, int len, int size)
 {
 	struct in_device *in_dev = __in_dev_get_rtnl(dev);
 	const struct in_ifaddr *ifa;
@@ -2766,8 +2766,6 @@ void __init devinet_init(void)
 		INIT_HLIST_HEAD(&inet_addr_lst[i]);
 
 	register_pernet_subsys(&devinet_ops);
-
-	register_gifconf(PF_INET, inet_gifconf);
 	register_netdevice_notifier(&ip_netdev_notifier);
 
 	queue_delayed_work(system_power_efficient_wq, &check_lifetime_work, 0);
-- 
2.29.2

