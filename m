Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6A72A9AE7
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 18:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbgKFRcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 12:32:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727674AbgKFRcw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 12:32:52 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F1B52151B;
        Fri,  6 Nov 2020 17:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604683971;
        bh=yEza5hTzjZgoh6zJHNuUl5eqkfjxO5JNXXNYliXmprw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z0nJsLaqRdODljru/MdCAClQc4u6miA5F8vH9JiRrL1/S+JfZXgV5CFyR5staPRrf
         KEsmfmewdolwHjtNmiAJVGklIpDlshwORotCCOfOucSQQytFA0kdhSVZoBaXQRxOxM
         UjcxZqhZ8W2NJRpgx9nO33nuFT0hetEdEfo+k5EA=
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 3/4] net: socket: simplify dev_ifconf handling
Date:   Fri,  6 Nov 2020 18:32:30 +0100
Message-Id: <20201106173231.3031349-4-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106173231.3031349-1-arnd@kernel.org>
References: <20201106173231.3031349-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The dev_ifconf() calling conventions make compat handling
more complicated than necessary, simplify this by moving
the in_compat_syscall() check into the function.
The implementation can be simplified further, based on the
knowledge that the dynamic registration is only ever used
for IPv4.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/inetdevice.h |  8 ++++
 include/linux/netdevice.h  | 10 +----
 net/core/dev_ioctl.c       | 92 +++++++++++++++-----------------------
 net/ipv4/devinet.c         |  4 +-
 net/socket.c               | 59 ++++++------------------
 5 files changed, 60 insertions(+), 113 deletions(-)

diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index 3515ca64e638..e8a957ca80f8 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -178,6 +178,14 @@ static inline struct net_device *ip_dev_find(struct net *net, __be32 addr)
 
 int inet_addr_onlink(struct in_device *in_dev, __be32 a, __be32 b);
 int devinet_ioctl(struct net *net, unsigned int cmd, struct ifreq *);
+#ifdef CONFIG_INET
+int inet_gifconf(struct net_device *dev, char __user *buf, int len, int size);
+#else
+static inline inet_gifconf(struct net_device *dev, char __user *buf, int len, int size)
+{
+	return 0;
+}
+#endif
 void devinet_init(void);
 struct in_device *inetdev_by_index(struct net *, int);
 __be32 inet_select_addr(const struct net_device *dev, __be32 dst, int scope);
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 964b494b0e8d..b54d5308087d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3137,14 +3137,6 @@ static inline bool dev_validate_header(const struct net_device *dev,
 	return false;
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
@@ -3837,7 +3829,7 @@ void netdev_rx_handler_unregister(struct net_device *dev);
 bool dev_valid_name(const char *name);
 int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr,
 		bool *need_copyout);
-int dev_ifconf(struct net *net, struct ifconf *, int);
+int dev_ifconf(struct net *net, struct ifconf __user *ifc);
 int dev_ethtool(struct net *net, struct ifreq *);
 unsigned int dev_get_flags(const struct net_device *);
 int __dev_change_flags(struct net_device *dev, unsigned int flags,
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 1c6da044754a..5822737a78f4 100644
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
@@ -25,77 +26,56 @@ static int dev_ifname(struct net *net, struct ifreq *ifr)
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
  *	Thus we will need a 'compatibility mode'.
  */
-
-int dev_ifconf(struct net *net, struct ifconf *ifc, int size)
+int dev_ifconf(struct net *net, struct ifconf __user *uifc)
 {
 	struct net_device *dev;
-	char __user *pos;
-	int len;
-	int total;
-	int i;
+	void __user *pos;
+	size_t size;
+	int len, total = 0, done;
 
-	/*
-	 *	Fetch the caller's info block.
-	 */
+	/* both the ifconf and the ifreq structures are slightly different */
+	if (in_compat_syscall()) {
+		struct compat_ifconf ifc32;
 
-	pos = ifc->ifc_buf;
-	len = ifc->ifc_len;
+		if (copy_from_user(&ifc32, uifc, sizeof(struct compat_ifconf)))
+			return -EFAULT;
 
-	/*
-	 *	Loop over the interfaces, and write an info block for each.
-	 */
+		pos = compat_ptr(ifc32.ifcbuf);
+		len = ifc32.ifc_len;
+		size = sizeof(struct compat_ifreq);
+	} else {
+		struct ifconf ifc;
 
-	total = 0;
+		if (copy_from_user(&ifc, uifc, sizeof(struct ifconf)))
+			return -EFAULT;
+
+		pos = ifc.ifc_buf;
+		len = ifc.ifc_len;
+		size = sizeof(struct ifreq);
+	}
+
+	/* Loop over the interfaces, and write an info block for each. */
+	rtnl_lock();
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
+		if (!pos)
+			done = inet_gifconf(dev, NULL, 0, size);
+		else
+			done = inet_gifconf(dev, pos + total,
+					    len - total, size);
+		if (done < 0) {
+			rtnl_unlock();
+			return -EFAULT;
 		}
+		total += done;
 	}
+	rtnl_unlock();
 
-	/*
-	 *	All done.  Write the updated control block back to the caller.
-	 */
-	ifc->ifc_len = total;
-
-	/*
-	 * 	Both BSD and Solaris return 0 here, so we do too.
-	 */
-	return 0;
+	return put_user(total, &uifc->ifc_len);
 }
 
 static int dev_getifmap(struct net_device *dev, struct ifreq *ifr)
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 123a6d39438f..3e910dedcb80 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1244,7 +1244,7 @@ int devinet_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr)
 	return ret;
 }
 
-static int inet_gifconf(struct net_device *dev, char __user *buf, int len, int size)
+int inet_gifconf(struct net_device *dev, char __user *buf, int len, int size)
 {
 	struct in_device *in_dev = __in_dev_get_rtnl(dev);
 	const struct in_ifaddr *ifa;
@@ -2762,8 +2762,6 @@ void __init devinet_init(void)
 		INIT_HLIST_HEAD(&inet_addr_lst[i]);
 
 	register_pernet_subsys(&devinet_ops);
-
-	register_gifconf(PF_INET, inet_gifconf);
 	register_netdevice_notifier(&ip_netdev_notifier);
 
 	queue_delayed_work(system_power_efficient_wq, &check_lifetime_work, 0);
diff --git a/net/socket.c b/net/socket.c
index 2b58b1d87cad..f26ef299b6c5 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1041,6 +1041,8 @@ EXPORT_SYMBOL(dlci_ioctl_set);
 static long sock_do_ioctl(struct net *net, struct socket *sock,
 			  unsigned int cmd, unsigned long arg)
 {
+	struct ifreq ifr;
+	bool need_copyout;
 	int err;
 	void __user *argp = (void __user *)arg;
 
@@ -1053,25 +1055,13 @@ static long sock_do_ioctl(struct net *net, struct socket *sock,
 	if (err != -ENOIOCTLCMD)
 		return err;
 
-	if (cmd == SIOCGIFCONF) {
-		struct ifconf ifc;
-		if (copy_from_user(&ifc, argp, sizeof(struct ifconf)))
-			return -EFAULT;
-		rtnl_lock();
-		err = dev_ifconf(net, &ifc, sizeof(struct ifreq));
-		rtnl_unlock();
-		if (!err && copy_to_user(argp, &ifc, sizeof(struct ifconf)))
-			err = -EFAULT;
-	} else {
-		struct ifreq ifr;
-		bool need_copyout;
-		if (copy_from_user(&ifr, argp, sizeof(struct ifreq)))
+	if (copy_from_user(&ifr, argp, sizeof(struct ifreq)))
+		return -EFAULT;
+	err = dev_ioctl(net, cmd, &ifr, &need_copyout);
+	if (!err && need_copyout)
+		if (copy_to_user(argp, &ifr, sizeof(struct ifreq)))
 			return -EFAULT;
-		err = dev_ioctl(net, cmd, &ifr, &need_copyout);
-		if (!err && need_copyout)
-			if (copy_to_user(argp, &ifr, sizeof(struct ifreq)))
-				return -EFAULT;
-	}
+
 	return err;
 }
 
@@ -1194,6 +1184,11 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 						   cmd == SIOCGSTAMP_NEW,
 						   false);
 			break;
+
+		case SIOCGIFCONF:
+			err = dev_ifconf(net, argp);
+			break;
+
 		default:
 			err = sock_do_ioctl(net, sock, cmd, arg);
 			break;
@@ -3098,31 +3093,6 @@ void socket_seq_show(struct seq_file *seq)
 #endif				/* CONFIG_PROC_FS */
 
 #ifdef CONFIG_COMPAT
-static int compat_dev_ifconf(struct net *net, struct compat_ifconf __user *uifc32)
-{
-	struct compat_ifconf ifc32;
-	struct ifconf ifc;
-	int err;
-
-	if (copy_from_user(&ifc32, uifc32, sizeof(struct compat_ifconf)))
-		return -EFAULT;
-
-	ifc.ifc_len = ifc32.ifc_len;
-	ifc.ifc_req = compat_ptr(ifc32.ifcbuf);
-
-	rtnl_lock();
-	err = dev_ifconf(net, &ifc, sizeof(struct compat_ifreq));
-	rtnl_unlock();
-	if (err)
-		return err;
-
-	ifc32.ifc_len = ifc.ifc_len;
-	if (copy_to_user(uifc32, &ifc32, sizeof(struct compat_ifconf)))
-		return -EFAULT;
-
-	return 0;
-}
-
 static int compat_siocwandev(struct net *net, struct compat_ifreq __user *uifr32)
 {
 	compat_uptr_t uptr32;
@@ -3241,8 +3211,6 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 	case SIOCSIFBR:
 	case SIOCGIFBR:
 		return old_bridge_ioctl(argp);
-	case SIOCGIFCONF:
-		return compat_dev_ifconf(net, argp);
 	case SIOCWANDEV:
 		return compat_siocwandev(net, argp);
 	case SIOCGSTAMP_OLD:
@@ -3272,6 +3240,7 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 	case SIOCGSKNS:
 	case SIOCGSTAMP_NEW:
 	case SIOCGSTAMPNS_NEW:
+	case SIOCGIFCONF:
 		return sock_ioctl(file, cmd, arg);
 
 	case SIOCGIFFLAGS:
-- 
2.27.0

