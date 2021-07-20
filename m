Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60293CFC71
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239337AbhGTN5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:57:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239448AbhGTNor (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:44:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F3CD61208;
        Tue, 20 Jul 2021 14:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626791084;
        bh=MvPfX6qG3/4u+OYgIUkaF24Jgj5JPh3olmvdqjxGpMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rU3nIsUkIO1PLX0UtC9qcxx6x17pjdoehpgMJXasU6GgGSgKI9jKbcC6t9RfWnSlN
         8XEc9yJcvNXq+YLnneSAJLSVlT/lv9kBaCb+lw6FXMg4ehrBBNEn8rp2Yjya3UNLhA
         0HCwcmzPc6orhCkdKrELeon2Dj3Fie9b1BVX51FqZ5KTwa9M24V3WcsJR+wakVlnIw
         1cBrc5jxN4qHAfKTCBBIzMPfo1V9nn1zR6yqz4+i0rcrNPTaMkrScBCkZ+8CB3StwU
         Z5Q/Qo7+W9ztxxoYr6GFOjSv0ue5rXOuF4vLLRsJQ0TzATTYxWMFtqsB6gVlZ0P9yu
         4kmk3pGfb56DA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v5 3/4] net: socket: simplify dev_ifconf handling
Date:   Tue, 20 Jul 2021 16:24:35 +0200
Message-Id: <20210720142436.2096733-4-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210720142436.2096733-1-arnd@kernel.org>
References: <20210720142436.2096733-1-arnd@kernel.org>
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
index e6231837aff5..4727c7a3a988 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -104,6 +104,11 @@ struct compat_ifmap {
 	unsigned char port;
 };
 
+struct compat_ifconf {
+	compat_int_t	ifc_len;                /* size of buffer */
+	compat_uptr_t	ifcbuf;
+};
+
 #ifdef CONFIG_COMPAT
 
 #ifndef compat_user_stack_pointer
@@ -326,12 +331,6 @@ typedef struct compat_sigevent {
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
index eaf5bb008aa9..c88290a33080 100644
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
@@ -4014,7 +4006,7 @@ void netdev_rx_handler_unregister(struct net_device *dev);
 bool dev_valid_name(const char *name);
 int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr,
 		bool *need_copyout);
-int dev_ifconf(struct net *net, struct ifconf *, int);
+int dev_ifconf(struct net *net, struct ifconf __user *ifc);
 int dev_ethtool(struct net *net, struct ifreq *);
 unsigned int dev_get_flags(const struct net_device *);
 int __dev_change_flags(struct net_device *dev, unsigned int flags,
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 336d75d58357..0af7b9f09970 100644
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
index 73721a4448bd..0683449650e7 100644
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
@@ -2762,8 +2762,6 @@ void __init devinet_init(void)
 		INIT_HLIST_HEAD(&inet_addr_lst[i]);
 
 	register_pernet_subsys(&devinet_ops);
-
-	register_gifconf(PF_INET, inet_gifconf);
 	register_netdevice_notifier(&ip_netdev_notifier);
 
 	queue_delayed_work(system_power_efficient_wq, &check_lifetime_work, 0);
diff --git a/net/socket.c b/net/socket.c
index 62005a12ec70..ecdb7913a3bd 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1088,6 +1088,8 @@ EXPORT_SYMBOL(vlan_ioctl_set);
 static long sock_do_ioctl(struct net *net, struct socket *sock,
 			  unsigned int cmd, unsigned long arg)
 {
+	struct ifreq ifr;
+	bool need_copyout;
 	int err;
 	void __user *argp = (void __user *)arg;
 
@@ -1100,25 +1102,13 @@ static long sock_do_ioctl(struct net *net, struct socket *sock,
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
 
@@ -1217,6 +1207,11 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
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
@@ -3127,31 +3122,6 @@ void socket_seq_show(struct seq_file *seq)
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
@@ -3270,8 +3240,6 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 	case SIOCSIFBR:
 	case SIOCGIFBR:
 		return old_bridge_ioctl(argp);
-	case SIOCGIFCONF:
-		return compat_dev_ifconf(net, argp);
 	case SIOCWANDEV:
 		return compat_siocwandev(net, argp);
 	case SIOCGSTAMP_OLD:
@@ -3299,6 +3267,7 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 	case SIOCGSKNS:
 	case SIOCGSTAMP_NEW:
 	case SIOCGSTAMPNS_NEW:
+	case SIOCGIFCONF:
 		return sock_ioctl(file, cmd, arg);
 
 	case SIOCGIFFLAGS:
-- 
2.29.2

