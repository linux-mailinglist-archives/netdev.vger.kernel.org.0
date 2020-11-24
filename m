Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820C62C2B13
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389427AbgKXPSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 10:18:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:36490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389372AbgKXPSr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 10:18:47 -0500
Received: from threadripper.lan (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43CFE20715;
        Tue, 24 Nov 2020 15:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606231125;
        bh=vGtAKcFnyf4V+AdErGElAJ94wwKSpVtzEuuc+JOpH1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ls1NurtF3JHJ5hEO0mscCox8vsqkQbInQcqGdARsoarT75oaTi6RAKxF7sXo78lqs
         hH3oiwnZP+aFV7WB4aDP5KuUQSULQ2hrSzExT+arpO2as9xW6mHaH3k4Ujp2XwSoR5
         vlmyncL9GSybblOXszxeYNVXc/SyAIOEWYRlIjeY=
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v4 3/4] net: socket: simplify dev_ifconf handling
Date:   Tue, 24 Nov 2020 16:18:27 +0100
Message-Id: <20201124151828.169152-4-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201124151828.169152-1-arnd@kernel.org>
References: <20201124151828.169152-1-arnd@kernel.org>
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
 include/linux/compat.h     | 11 +++--
 include/linux/inetdevice.h |  9 ++++
 include/linux/netdevice.h  | 10 +----
 net/core/dev_ioctl.c       | 92 +++++++++++++++-----------------------
 net/ipv4/devinet.c         |  4 +-
 net/socket.c               | 59 ++++++------------------
 6 files changed, 66 insertions(+), 119 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 47496c5eb5eb..a97f80b704ab 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -105,6 +105,11 @@ struct compat_ifmap {
 	unsigned char port;
 };
 
+struct compat_ifconf {
+	compat_int_t	ifc_len;                /* size of buffer */
+	compat_uptr_t	ifcbuf;
+};
+
 #ifdef CONFIG_COMPAT
 
 #ifndef compat_user_stack_pointer
@@ -323,12 +328,6 @@ typedef struct compat_sigevent {
 	} _sigev_un;
 } compat_sigevent_t;
 
-struct compat_if_settings {
-	unsigned int type;	/* Type of physical device or protocol */
-	unsigned int size;	/* Size of the data allocated by the caller */
-	compat_uptr_t ifs_ifsu;	/* union of pointers */
-};
-
 struct compat_ifreq {
 	union {
 		char	ifrn_name[IFNAMSIZ];    /* if name, e.g. "en0" */
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
index 03433a4c929e..e99450a60d8e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3163,14 +3163,6 @@ static inline bool dev_validate_header(const struct net_device *dev,
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
@@ -3870,7 +3862,7 @@ void netdev_rx_handler_unregister(struct net_device *dev);
 bool dev_valid_name(const char *name);
 int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr,
 		bool *need_copyout);
-int dev_ifconf(struct net *net, struct ifconf *, int);
+int dev_ifconf(struct net *net, struct ifconf __user *ifc);
 int dev_ethtool(struct net *net, struct ifreq *);
 unsigned int dev_get_flags(const struct net_device *);
 int __dev_change_flags(struct net_device *dev, unsigned int flags,
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index de3df6fe65fe..de5478b2ef77 100644
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
index 75f67994fc85..3c51395a49c8 100644
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
@@ -2761,8 +2761,6 @@ void __init devinet_init(void)
 		INIT_HLIST_HEAD(&inet_addr_lst[i]);
 
 	register_pernet_subsys(&devinet_ops);
-
-	register_gifconf(PF_INET, inet_gifconf);
 	register_netdevice_notifier(&ip_netdev_notifier);
 
 	queue_delayed_work(system_power_efficient_wq, &check_lifetime_work, 0);
diff --git a/net/socket.c b/net/socket.c
index 2d32c8576e95..41158e459f0b 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1029,6 +1029,8 @@ EXPORT_SYMBOL(vlan_ioctl_set);
 static long sock_do_ioctl(struct net *net, struct socket *sock,
 			  unsigned int cmd, unsigned long arg)
 {
+	struct ifreq ifr;
+	bool need_copyout;
 	int err;
 	void __user *argp = (void __user *)arg;
 
@@ -1041,25 +1043,13 @@ static long sock_do_ioctl(struct net *net, struct socket *sock,
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
 
@@ -1171,6 +1161,11 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
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
@@ -3084,31 +3079,6 @@ void socket_seq_show(struct seq_file *seq)
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
@@ -3227,8 +3197,6 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 	case SIOCSIFBR:
 	case SIOCGIFBR:
 		return old_bridge_ioctl(argp);
-	case SIOCGIFCONF:
-		return compat_dev_ifconf(net, argp);
 	case SIOCWANDEV:
 		return compat_siocwandev(net, argp);
 	case SIOCGSTAMP_OLD:
@@ -3256,6 +3224,7 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 	case SIOCGSKNS:
 	case SIOCGSTAMP_NEW:
 	case SIOCGSTAMPNS_NEW:
+	case SIOCGIFCONF:
 		return sock_ioctl(file, cmd, arg);
 
 	case SIOCGIFFLAGS:
-- 
2.27.0

