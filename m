Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA7B278970
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 15:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbgIYNXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 09:23:25 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:58805 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728880AbgIYNXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 09:23:24 -0400
Received: from threadripper.lan ([46.223.126.90]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1M6DSo-1kO0bn2Uye-006hqJ; Fri, 25 Sep 2020 15:23:11 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v2 2/2] dev_ioctl: split out SIOC?IFMAP ioctls
Date:   Fri, 25 Sep 2020 15:22:10 +0200
Message-Id: <20200925132237.2748992-2-arnd@arndb.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200925132237.2748992-1-arnd@arndb.de>
References: <20200925132237.2748992-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:ykJIQ3VEoGicwRH721LBFLPmBqknzCaJOXKV29g/3EEua8dPZIR
 j5Rlq34wBqFLyVQjP1qN0C9pUP/xaEgS8hgeT1zBejGSDvfZ7TLOnak/7xOrLuKQuDL0a+Q
 ffK7ZDjyIwPr+pH3stOqp2ZjFIOWnmpOVfw6kHkT+CJHH3SaOQ5PK7N305YLiFvPUJKo+rr
 Dfhf57XxHPD6FrzXZ12DQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:UVPRSwg1tRk=:yNfHd4cyH4uFwglPFQH0my
 pomGOyffbR/I5fMqycmX6jf2FncKTuH0yij+Q/Jfjv0yNPd1K+TqJxbxvIuq+oewkl6Tjy8bc
 WACsFI4fajs3iAXe6PfmMQzsEH9ZVw2e2v3QLFEOb1gCA/GZedWv2PRQGNn5GD1eV+EnOWnIB
 WrekSoYpY6+1+46UEzA58+g/8GrAZk61fNQQVc5B/kv58naYmqyXPwppFsb+Lon2btAEFyqwF
 Zu5zd7S42VAn3GVfMmAw8n01snTHTBZuP8emVcS57lc5hPu2XtAlYMP/3DbdaTkgJJiTHeAIL
 jWvSdvqwzxnPdCFJSLfsMbmMcPpHVyuL/1zRswTkolOltN3iNLo8vii0mYABvzkft89CN4bLM
 9lmU8BnTJj0ijza/fCn7EaE2k/Lb/m58UyTBw+l/oua8jae5mdK1daGHMFZxdrP681r+9kkMA
 viQ5KFATfLVKKk2GhDyqP+4gum/qstqUd8G3+P+xMzyYP/0LqHuYcVGzazbe4tUDLa7C0M6uO
 zV/DF1OZwy4t1YFNXmP12hpL9NyX3BlDqRt0xsTUAPJn/1WLdm0Z+P64RMBCln9sPu6mv4W6K
 q55SzhOrQI8ieoro1oJw9zCJP1xDe8hbg1+og6NhkTi47n/flS9b7RcOG+NW98mibWqWAyOqa
 q3dpy6qSwYx7Igd7OchxKVcSBLqujOXYpTnff7pYvKbbwjXKWxVxJGElvvOzFfls1fIvauUN1
 6tHNec5ZodaU4ekxWfrxSrjJHPosx0HbwL8QjTFWvBSLJ4qR/WpUmzeDnL/ITZm/mSHxHFQqM
 P3lBUfI/RM9Ws1GqvYVD4bB9Pi7SYWnwYGCcZZJs6A2RS7xegWuDAy6wq/uTxb3e6NtLU+1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ifreq ioctls need a special compat handler at the moment because of
the size difference between the struct on native and compat architectures,
but this difference exists only for one pair of ioctls, SIOCGIFMAP
and SIOCSIFMAP.

Splitting these two out of dev_ioctl() into their own higher level
implementation means the ifreq structure can be redefined in the kernel
to be identical for all applications, avoiding the need for copying the
structure around multiple times, and removing one of the call sites for
compat_alloc_user_space() and copy_in_user().

This should also make it easier for drivers to implement ioctls correct
that take an ifreq __user pointer and need to be careful about the size
difference. This has been a problem in the past, but currently the kernel
does not appear to have any drivers suffering from it.

Note that the user space definition is unchanged, so struct ifreq now
has a different size between user space and kernel, but this is not a
problem when the user space definition is larger, and the only time the
extra members are accessed is in the ifmap ioctls.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
changes in v2:
 - fix building with CONFIG_COMPAT disabled (0day bot)
 - split up dev_ifmap() into more readable helpers (hch)
 - move rcu_read_unlock() for readability (hch)
---
 include/linux/compat.h    |  18 +++---
 include/linux/netdevice.h |   1 +
 include/uapi/linux/if.h   |   6 ++
 net/core/dev_ioctl.c      | 122 ++++++++++++++++++++++++++++++++------
 net/socket.c              |  93 ++---------------------------
 5 files changed, 125 insertions(+), 115 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index b354ce58966e..6359c51b748f 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -91,6 +91,15 @@
 	static inline long __do_compat_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))
 #endif /* COMPAT_SYSCALL_DEFINEx */
 
+struct compat_ifmap {
+	compat_ulong_t mem_start;
+	compat_ulong_t mem_end;
+	unsigned short base_addr;
+	unsigned char irq;
+	unsigned char dma;
+	unsigned char port;
+};
+
 #ifdef CONFIG_COMPAT
 
 #ifndef compat_user_stack_pointer
@@ -314,15 +323,6 @@ typedef struct compat_sigevent {
 	} _sigev_un;
 } compat_sigevent_t;
 
-struct compat_ifmap {
-	compat_ulong_t mem_start;
-	compat_ulong_t mem_end;
-	unsigned short base_addr;
-	unsigned char irq;
-	unsigned char dma;
-	unsigned char port;
-};
-
 struct compat_if_settings {
 	unsigned int type;	/* Type of physical device or protocol */
 	unsigned int size;	/* Size of the data allocated by the caller */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a431c3229cbf..df4124442427 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3810,6 +3810,7 @@ void netdev_rx_handler_unregister(struct net_device *dev);
 bool dev_valid_name(const char *name);
 int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr,
 		bool *need_copyout);
+int dev_ifmap(struct net *net, struct ifreq __user *ifr, unsigned int cmd);
 int dev_ifconf(struct net *net, struct ifconf *, int);
 int dev_ethtool(struct net *net, struct ifreq *);
 unsigned int dev_get_flags(const struct net_device *);
diff --git a/include/uapi/linux/if.h b/include/uapi/linux/if.h
index 797ba2c1562a..a332d6ae4dc6 100644
--- a/include/uapi/linux/if.h
+++ b/include/uapi/linux/if.h
@@ -247,7 +247,13 @@ struct ifreq {
 		short	ifru_flags;
 		int	ifru_ivalue;
 		int	ifru_mtu;
+#ifndef __KERNEL__
+		/*
+		 * ifru_map is rarely used but causes the incompatibility
+		 * between native and compat mode.
+		 */
 		struct  ifmap ifru_map;
+#endif
 		char	ifru_slave[IFNAMSIZ];	/* Just fits the size */
 		char	ifru_newname[IFNAMSIZ];
 		void __user *	ifru_data;
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 205e92e604ef..79af316e5c19 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -98,6 +98,109 @@ int dev_ifconf(struct net *net, struct ifconf *ifc, int size)
 	return 0;
 }
 
+static int dev_getifmap(struct net *net, const char *ifname,
+			struct ifreq __user *ifr)
+{
+	struct net_device *dev;
+	struct ifmap ifmap;
+
+	rcu_read_lock();
+	dev = dev_get_by_name_rcu(net, ifname);
+	if (!dev) {
+		rcu_read_unlock();
+		return -ENODEV;
+	}
+
+	memset(&ifmap, 0, sizeof(ifmap));
+	ifmap.mem_start  = dev->mem_start;
+	ifmap.mem_end    = dev->mem_end;
+	ifmap.base_addr  = dev->base_addr;
+	ifmap.irq        = dev->irq;
+	ifmap.dma        = dev->dma;
+	ifmap.port       = dev->if_port;
+	rcu_read_unlock();
+
+	if (in_compat_syscall()) {
+		struct compat_ifmap cifmap;
+
+		memset(&cifmap, 0, sizeof(cifmap));
+		cifmap.mem_start = ifmap.mem_start;
+		cifmap.mem_end   = ifmap.mem_end;
+		cifmap.base_addr = ifmap.base_addr;
+		cifmap.irq       = ifmap.irq;
+		cifmap.dma       = ifmap.dma;
+		cifmap.port      = ifmap.port;
+
+		if (copy_to_user(&ifr->ifr_data, &cifmap, sizeof(cifmap)))
+			return -EFAULT;
+	} else {
+		if (copy_to_user(&ifr->ifr_data, &ifmap, sizeof(ifmap)))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int dev_setifmap(struct net *net, const char *ifname,
+			const struct ifreq __user *ifr)
+{
+	struct net_device *dev;
+	struct ifmap ifmap;
+	int ret;
+
+	if (!capable(CAP_NET_ADMIN) ||
+	    !ns_capable(net->user_ns, CAP_NET_ADMIN))
+		return -EPERM;
+
+	if (in_compat_syscall()) {
+		struct compat_ifmap cifmap;
+
+		if (copy_from_user(&cifmap, &ifr->ifr_data, sizeof(cifmap)))
+			return -EFAULT;
+
+		ifmap.mem_start  = cifmap.mem_start;
+		ifmap.mem_end    = cifmap.mem_end;
+		ifmap.base_addr  = cifmap.base_addr;
+		ifmap.irq        = cifmap.irq;
+		ifmap.dma        = cifmap.dma;
+		ifmap.port       = cifmap.port;
+	} else {
+		if (copy_from_user(&ifmap, &ifr->ifr_data, sizeof(ifmap)))
+			return -EFAULT;
+	}
+
+	rtnl_lock();
+	dev = __dev_get_by_name(net, ifname);
+	if (!dev || !netif_device_present(dev))
+		ret = -ENODEV;
+	else if (!dev->netdev_ops->ndo_set_config)
+		ret = -EOPNOTSUPP;
+	else
+		ret = dev->netdev_ops->ndo_set_config(dev, &ifmap);
+	rtnl_unlock();
+
+	return ret;
+}
+
+int dev_ifmap(struct net *net, struct ifreq __user *ifr, unsigned int cmd)
+{
+	char ifname[IFNAMSIZ];
+	char *colon;
+
+	if (copy_from_user(ifname, ifr->ifr_name, sizeof(ifname)))
+		return -EFAULT;
+	ifname[IFNAMSIZ-1] = 0;
+	colon = strchr(ifname, ':');
+	if (colon)
+		*colon = 0;
+	dev_load(net, ifname);
+
+	if (cmd == SIOCGIFMAP)
+		return dev_getifmap(net, ifname, ifr);
+
+	return dev_setifmap(net, ifname, ifr);
+}
+
 /*
  *	Perform the SIOCxIFxxx calls, inside rcu_read_lock()
  */
@@ -138,15 +241,6 @@ static int dev_ifsioc_locked(struct net *net, struct ifreq *ifr, unsigned int cm
 		err = -EINVAL;
 		break;
 
-	case SIOCGIFMAP:
-		ifr->ifr_map.mem_start = dev->mem_start;
-		ifr->ifr_map.mem_end   = dev->mem_end;
-		ifr->ifr_map.base_addr = dev->base_addr;
-		ifr->ifr_map.irq       = dev->irq;
-		ifr->ifr_map.dma       = dev->dma;
-		ifr->ifr_map.port      = dev->if_port;
-		return 0;
-
 	case SIOCGIFINDEX:
 		ifr->ifr_ifindex = dev->ifindex;
 		return 0;
@@ -285,14 +379,6 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, unsigned int cmd)
 		call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
 		return 0;
 
-	case SIOCSIFMAP:
-		if (ops->ndo_set_config) {
-			if (!netif_device_present(dev))
-				return -ENODEV;
-			return ops->ndo_set_config(dev, &ifr->ifr_map);
-		}
-		return -EOPNOTSUPP;
-
 	case SIOCADDMULTI:
 		if (!ops->ndo_set_rx_mode ||
 		    ifr->ifr_hwaddr.sa_family != AF_UNSPEC)
@@ -429,7 +515,6 @@ int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr, bool *need_c
 	case SIOCGIFMTU:
 	case SIOCGIFHWADDR:
 	case SIOCGIFSLAVE:
-	case SIOCGIFMAP:
 	case SIOCGIFINDEX:
 	case SIOCGIFTXQLEN:
 		dev_load(net, ifr->ifr_name);
@@ -474,7 +559,6 @@ int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr, bool *need_c
 	 *	- require strict serialization.
 	 *	- do not return a value
 	 */
-	case SIOCSIFMAP:
 	case SIOCSIFTXQLEN:
 		if (!capable(CAP_NET_ADMIN))
 			return -EPERM;
diff --git a/net/socket.c b/net/socket.c
index 8809db922574..4366900356f6 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1194,6 +1194,10 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 						   cmd == SIOCGSTAMP_NEW,
 						   false);
 			break;
+		case SIOCGIFMAP:
+		case SIOCSIFMAP:
+			err = dev_ifmap(net, argp, cmd);
+			break;
 		default:
 			err = sock_do_ioctl(net, sock, cmd, arg);
 			break;
@@ -3164,88 +3168,6 @@ static int compat_ifr_data_ioctl(struct net *net, unsigned int cmd,
 	return dev_ioctl(net, cmd, &ifreq, NULL);
 }
 
-static int compat_ifreq_ioctl(struct net *net, struct socket *sock,
-			      unsigned int cmd,
-			      struct compat_ifreq __user *uifr32)
-{
-	struct ifreq __user *uifr;
-	int err;
-
-	/* Handle the fact that while struct ifreq has the same *layout* on
-	 * 32/64 for everything but ifreq::ifru_ifmap and ifreq::ifru_data,
-	 * which are handled elsewhere, it still has different *size* due to
-	 * ifreq::ifru_ifmap (which is 16 bytes on 32 bit, 24 bytes on 64-bit,
-	 * resulting in struct ifreq being 32 and 40 bytes respectively).
-	 * As a result, if the struct happens to be at the end of a page and
-	 * the next page isn't readable/writable, we get a fault. To prevent
-	 * that, copy back and forth to the full size.
-	 */
-
-	uifr = compat_alloc_user_space(sizeof(*uifr));
-	if (copy_in_user(uifr, uifr32, sizeof(*uifr32)))
-		return -EFAULT;
-
-	err = sock_do_ioctl(net, sock, cmd, (unsigned long)uifr);
-
-	if (!err) {
-		switch (cmd) {
-		case SIOCGIFFLAGS:
-		case SIOCGIFMETRIC:
-		case SIOCGIFMTU:
-		case SIOCGIFMEM:
-		case SIOCGIFHWADDR:
-		case SIOCGIFINDEX:
-		case SIOCGIFADDR:
-		case SIOCGIFBRDADDR:
-		case SIOCGIFDSTADDR:
-		case SIOCGIFNETMASK:
-		case SIOCGIFPFLAGS:
-		case SIOCGIFTXQLEN:
-		case SIOCGMIIPHY:
-		case SIOCGMIIREG:
-		case SIOCGIFNAME:
-			if (copy_in_user(uifr32, uifr, sizeof(*uifr32)))
-				err = -EFAULT;
-			break;
-		}
-	}
-	return err;
-}
-
-static int compat_sioc_ifmap(struct net *net, unsigned int cmd,
-			struct compat_ifreq __user *uifr32)
-{
-	struct ifreq ifr;
-	struct compat_ifmap __user *uifmap32;
-	int err;
-
-	uifmap32 = &uifr32->ifr_ifru.ifru_map;
-	err = copy_from_user(&ifr, uifr32, sizeof(ifr.ifr_name));
-	err |= get_user(ifr.ifr_map.mem_start, &uifmap32->mem_start);
-	err |= get_user(ifr.ifr_map.mem_end, &uifmap32->mem_end);
-	err |= get_user(ifr.ifr_map.base_addr, &uifmap32->base_addr);
-	err |= get_user(ifr.ifr_map.irq, &uifmap32->irq);
-	err |= get_user(ifr.ifr_map.dma, &uifmap32->dma);
-	err |= get_user(ifr.ifr_map.port, &uifmap32->port);
-	if (err)
-		return -EFAULT;
-
-	err = dev_ioctl(net, cmd, &ifr, NULL);
-
-	if (cmd == SIOCGIFMAP && !err) {
-		err = copy_to_user(uifr32, &ifr, sizeof(ifr.ifr_name));
-		err |= put_user(ifr.ifr_map.mem_start, &uifmap32->mem_start);
-		err |= put_user(ifr.ifr_map.mem_end, &uifmap32->mem_end);
-		err |= put_user(ifr.ifr_map.base_addr, &uifmap32->base_addr);
-		err |= put_user(ifr.ifr_map.irq, &uifmap32->irq);
-		err |= put_user(ifr.ifr_map.dma, &uifmap32->dma);
-		err |= put_user(ifr.ifr_map.port, &uifmap32->port);
-		if (err)
-			err = -EFAULT;
-	}
-	return err;
-}
-
 /* Since old style bridge ioctl's endup using SIOCDEVPRIVATE
  * for some operations; this forces use of the newer bridge-utils that
  * use compatible ioctls
@@ -3279,9 +3201,6 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 		return compat_dev_ifconf(net, argp);
 	case SIOCWANDEV:
 		return compat_siocwandev(net, argp);
-	case SIOCGIFMAP:
-	case SIOCSIFMAP:
-		return compat_sioc_ifmap(net, cmd, argp);
 	case SIOCGSTAMP_OLD:
 	case SIOCGSTAMPNS_OLD:
 		if (!sock->ops->gettstamp)
@@ -3296,6 +3215,8 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 	case SIOCGHWTSTAMP:
 		return compat_ifr_data_ioctl(net, cmd, argp);
 
+	case SIOCGIFMAP:
+	case SIOCSIFMAP:
 	case FIOSETOWN:
 	case SIOCSPGRP:
 	case FIOGETOWN:
@@ -3349,8 +3270,6 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 	case SIOCBONDRELEASE:
 	case SIOCBONDSETHWADDR:
 	case SIOCBONDCHANGEACTIVE:
-		return compat_ifreq_ioctl(net, sock, cmd, argp);
-
 	case SIOCSARP:
 	case SIOCGARP:
 	case SIOCDARP:
-- 
2.27.0

