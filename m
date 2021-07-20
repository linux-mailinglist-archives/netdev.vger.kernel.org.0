Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA493CFC69
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239817AbhGTN50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:57:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239449AbhGTNor (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:44:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D6196120A;
        Tue, 20 Jul 2021 14:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626791085;
        bh=LXiOMsHeuvMLXHSfirlvBsjSYuAJHWUh3Dll1U+uRsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bOXOs4OHY/52yvPmndK3hyz6BUpKIBF4mp7HNF0svxuE9yzku8yr9RYSsc7+aTwqy
         FtsLOyAEl079FJRAXuet36Vn5v9hW44mdcoW+O2sLb9FUm2B9c5HSJGy4XcetQ8zSQ
         CySBtoPaFlg9Z0gJK7wmwaOPvp1QQbPDf5dBayh6FZqqe169fiqDvz2Cg8SRjELhOi
         A9TuIGKr9+V+KwovVl//tZSF3MqPAVI7zo4CKRcMmORGEEeqV3JmsuajMylgAi/fZV
         OpKS/mqGnhFKLNA3W0f1OEIm3cGqN/FQx2LmUu3Dch7AK6u6ELt6W4EcVROG1YisRp
         lcthp6axK00wQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v5 4/4] net: socket: rework compat_ifreq_ioctl()
Date:   Tue, 20 Jul 2021 16:24:36 +0200
Message-Id: <20210720142436.2096733-5-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210720142436.2096733-1-arnd@kernel.org>
References: <20210720142436.2096733-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

compat_ifreq_ioctl() is one of the last users of copy_in_user() and
compat_alloc_user_space(), as it attempts to convert the 'struct ifreq'
arguments from 32-bit to 64-bit format as used by dev_ioctl() and a
couple of socket family specific interpretations.

The current implementation works correctly when calling dev_ioctl(),
inet_ioctl(), ieee802154_sock_ioctl(), atalk_ioctl(), qrtr_ioctl()
and packet_ioctl(). The ioctl handlers for x25, netrom, rose and x25 do
not interpret the arguments and only block the corresponding commands,
so they do not care.

For af_inet6 and af_decnet however, the compat conversion is slightly
incorrect, as it will copy more data than the native handler accesses,
both of them use a structure that is shorter than ifreq.

Replace the copy_in_user() conversion with a pair of accessor functions
to read and write the ifreq data in place with the correct length where
needed, while leaving the other ones to copy the (already compatible)
structures directly.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/compat.h    |  53 ++++++++++----------
 include/linux/netdevice.h |   2 +
 net/appletalk/ddp.c       |   4 +-
 net/ieee802154/socket.c   |   4 +-
 net/ipv4/af_inet.c        |   6 +--
 net/qrtr/qrtr.c           |   4 +-
 net/socket.c              | 103 ++++++++++++++++++++++++--------------
 7 files changed, 103 insertions(+), 73 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 4727c7a3a988..fa30c3c96cff 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -109,6 +109,33 @@ struct compat_ifconf {
 	compat_uptr_t	ifcbuf;
 };
 
+struct compat_if_settings {
+	unsigned int type;	/* Type of physical device or protocol */
+	unsigned int size;	/* Size of the data allocated by the caller */
+	compat_uptr_t ifs_ifsu;	/* union of pointers */
+};
+
+struct compat_ifreq {
+	union {
+		char	ifrn_name[IFNAMSIZ];    /* if name, e.g. "en0" */
+	} ifr_ifrn;
+	union {
+		struct	sockaddr ifru_addr;
+		struct	sockaddr ifru_dstaddr;
+		struct	sockaddr ifru_broadaddr;
+		struct	sockaddr ifru_netmask;
+		struct	sockaddr ifru_hwaddr;
+		short	ifru_flags;
+		compat_int_t	ifru_ivalue;
+		compat_int_t	ifru_mtu;
+		struct	compat_ifmap ifru_map;
+		char	ifru_slave[IFNAMSIZ];   /* Just fits the size */
+		char	ifru_newname[IFNAMSIZ];
+		compat_uptr_t	ifru_data;
+		struct	compat_if_settings ifru_settings;
+	} ifr_ifru;
+};
+
 #ifdef CONFIG_COMPAT
 
 #ifndef compat_user_stack_pointer
@@ -331,32 +358,6 @@ typedef struct compat_sigevent {
 	} _sigev_un;
 } compat_sigevent_t;
 
-struct compat_ifreq {
-	union {
-		char	ifrn_name[IFNAMSIZ];    /* if name, e.g. "en0" */
-	} ifr_ifrn;
-	union {
-		struct	sockaddr ifru_addr;
-		struct	sockaddr ifru_dstaddr;
-		struct	sockaddr ifru_broadaddr;
-		struct	sockaddr ifru_netmask;
-		struct	sockaddr ifru_hwaddr;
-		short	ifru_flags;
-		compat_int_t	ifru_ivalue;
-		compat_int_t	ifru_mtu;
-		struct	compat_ifmap ifru_map;
-		char	ifru_slave[IFNAMSIZ];   /* Just fits the size */
-		char	ifru_newname[IFNAMSIZ];
-		compat_caddr_t	ifru_data;
-		struct	compat_if_settings ifru_settings;
-	} ifr_ifru;
-};
-
-struct compat_ifconf {
-	compat_int_t	ifc_len;                /* size of buffer */
-	compat_caddr_t  ifcbuf;
-};
-
 struct compat_robust_list {
 	compat_uptr_t			next;
 };
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c88290a33080..5c39129101c0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4004,6 +4004,8 @@ int netdev_rx_handler_register(struct net_device *dev,
 void netdev_rx_handler_unregister(struct net_device *dev);
 
 bool dev_valid_name(const char *name);
+int get_user_ifreq(struct ifreq *ifr, void __user **ifrdata, void __user *arg);
+int put_user_ifreq(struct ifreq *ifr, void __user *arg);
 int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr,
 		bool *need_copyout);
 int dev_ifconf(struct net *net, struct ifconf __user *ifc);
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 8ade5a4ceaf5..bf5736c1d458 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -666,7 +666,7 @@ static int atif_ioctl(int cmd, void __user *arg)
 	struct rtentry rtdef;
 	int add_route;
 
-	if (copy_from_user(&atreq, arg, sizeof(atreq)))
+	if (get_user_ifreq(&atreq, NULL, arg))
 		return -EFAULT;
 
 	dev = __dev_get_by_name(&init_net, atreq.ifr_name);
@@ -865,7 +865,7 @@ static int atif_ioctl(int cmd, void __user *arg)
 		return 0;
 	}
 
-	return copy_to_user(arg, &atreq, sizeof(atreq)) ? -EFAULT : 0;
+	return put_user_ifreq(&atreq, arg);
 }
 
 static int atrtr_ioctl_addrt(struct rtentry *rt)
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index a45a0401adc5..f5077de3619e 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -129,7 +129,7 @@ static int ieee802154_dev_ioctl(struct sock *sk, struct ifreq __user *arg,
 	int ret = -ENOIOCTLCMD;
 	struct net_device *dev;
 
-	if (copy_from_user(&ifr, arg, sizeof(struct ifreq)))
+	if (get_user_ifreq(&ifr, NULL, arg))
 		return -EFAULT;
 
 	ifr.ifr_name[IFNAMSIZ-1] = 0;
@@ -143,7 +143,7 @@ static int ieee802154_dev_ioctl(struct sock *sk, struct ifreq __user *arg,
 	if (dev->type == ARPHRD_IEEE802154 && dev->netdev_ops->ndo_do_ioctl)
 		ret = dev->netdev_ops->ndo_do_ioctl(dev, &ifr, cmd);
 
-	if (!ret && copy_to_user(arg, &ifr, sizeof(struct ifreq)))
+	if (!ret && put_user_ifreq(&ifr, arg))
 		ret = -EFAULT;
 	dev_put(dev);
 
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 54648181dd56..0e4d758c2585 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -953,10 +953,10 @@ int inet_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 	case SIOCGIFNETMASK:
 	case SIOCGIFDSTADDR:
 	case SIOCGIFPFLAGS:
-		if (copy_from_user(&ifr, p, sizeof(struct ifreq)))
+		if (get_user_ifreq(&ifr, NULL, p))
 			return -EFAULT;
 		err = devinet_ioctl(net, cmd, &ifr);
-		if (!err && copy_to_user(p, &ifr, sizeof(struct ifreq)))
+		if (!err && put_user_ifreq(&ifr, p))
 			err = -EFAULT;
 		break;
 
@@ -966,7 +966,7 @@ int inet_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 	case SIOCSIFDSTADDR:
 	case SIOCSIFPFLAGS:
 	case SIOCSIFFLAGS:
-		if (copy_from_user(&ifr, p, sizeof(struct ifreq)))
+		if (get_user_ifreq(&ifr, NULL, p))
 			return -EFAULT;
 		err = devinet_ioctl(net, cmd, &ifr);
 		break;
diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index e6f4a6202f82..e71847877248 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -1153,14 +1153,14 @@ static int qrtr_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 		rc = put_user(len, (int __user *)argp);
 		break;
 	case SIOCGIFADDR:
-		if (copy_from_user(&ifr, argp, sizeof(ifr))) {
+		if (get_user_ifreq(&ifr, NULL, argp)) {
 			rc = -EFAULT;
 			break;
 		}
 
 		sq = (struct sockaddr_qrtr *)&ifr.ifr_addr;
 		*sq = ipc->us;
-		if (copy_to_user(argp, &ifr, sizeof(ifr))) {
+		if (put_user_ifreq(&ifr, argp)) {
 			rc = -EFAULT;
 			break;
 		}
diff --git a/net/socket.c b/net/socket.c
index ecdb7913a3bd..84de89c1ee9d 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3121,6 +3121,54 @@ void socket_seq_show(struct seq_file *seq)
 }
 #endif				/* CONFIG_PROC_FS */
 
+/* Handle the fact that while struct ifreq has the same *layout* on
+ * 32/64 for everything but ifreq::ifru_ifmap and ifreq::ifru_data,
+ * which are handled elsewhere, it still has different *size* due to
+ * ifreq::ifru_ifmap (which is 16 bytes on 32 bit, 24 bytes on 64-bit,
+ * resulting in struct ifreq being 32 and 40 bytes respectively).
+ * As a result, if the struct happens to be at the end of a page and
+ * the next page isn't readable/writable, we get a fault. To prevent
+ * that, copy back and forth to the full size.
+ */
+int get_user_ifreq(struct ifreq *ifr, void __user **ifrdata, void __user *arg)
+{
+	if (in_compat_syscall()) {
+		struct compat_ifreq *ifr32 = (struct compat_ifreq *)ifr;
+
+		memset(ifr, 0, sizeof(*ifr));
+		if (copy_from_user(ifr32, arg, sizeof(*ifr32)))
+			return -EFAULT;
+
+		if (ifrdata)
+			*ifrdata = compat_ptr(ifr32->ifr_data);
+
+		return 0;
+	}
+
+	if (copy_from_user(ifr, arg, sizeof(*ifr)))
+		return -EFAULT;
+
+	if (ifrdata)
+		*ifrdata = ifr->ifr_data;
+
+	return 0;
+}
+EXPORT_SYMBOL(get_user_ifreq);
+
+int put_user_ifreq(struct ifreq *ifr, void __user *arg)
+{
+	size_t size = sizeof(*ifr);
+
+	if (in_compat_syscall())
+		size = sizeof(struct compat_ifreq);
+
+	if (copy_to_user(arg, ifr, size))
+		return -EFAULT;
+
+	return 0;
+}
+EXPORT_SYMBOL(put_user_ifreq);
+
 #ifdef CONFIG_COMPAT
 static int compat_siocwandev(struct net *net, struct compat_ifreq __user *uifr32)
 {
@@ -3129,7 +3177,7 @@ static int compat_siocwandev(struct net *net, struct compat_ifreq __user *uifr32
 	void __user *saved;
 	int err;
 
-	if (copy_from_user(&ifr, uifr32, sizeof(struct compat_ifreq)))
+	if (get_user_ifreq(&ifr, NULL, uifr32))
 		return -EFAULT;
 
 	if (get_user(uptr32, &uifr32->ifr_settings.ifs_ifsu))
@@ -3141,7 +3189,7 @@ static int compat_siocwandev(struct net *net, struct compat_ifreq __user *uifr32
 	err = dev_ioctl(net, SIOCWANDEV, &ifr, NULL);
 	if (!err) {
 		ifr.ifr_settings.ifs_ifsu.raw_hdlc = saved;
-		if (copy_to_user(uifr32, &ifr, sizeof(struct compat_ifreq)))
+		if (put_user_ifreq(&ifr, uifr32))
 			err = -EFAULT;
 	}
 	return err;
@@ -3165,49 +3213,28 @@ static int compat_ifr_data_ioctl(struct net *net, unsigned int cmd,
 
 static int compat_ifreq_ioctl(struct net *net, struct socket *sock,
 			      unsigned int cmd,
+			      unsigned long arg,
 			      struct compat_ifreq __user *uifr32)
 {
-	struct ifreq __user *uifr;
+	struct ifreq ifr;
+	bool need_copyout;
 	int err;
 
-	/* Handle the fact that while struct ifreq has the same *layout* on
-	 * 32/64 for everything but ifreq::ifru_ifmap and ifreq::ifru_data,
-	 * which are handled elsewhere, it still has different *size* due to
-	 * ifreq::ifru_ifmap (which is 16 bytes on 32 bit, 24 bytes on 64-bit,
-	 * resulting in struct ifreq being 32 and 40 bytes respectively).
-	 * As a result, if the struct happens to be at the end of a page and
-	 * the next page isn't readable/writable, we get a fault. To prevent
-	 * that, copy back and forth to the full size.
+	err = sock->ops->ioctl(sock, cmd, arg);
+
+	/* If this ioctl is unknown try to hand it down
+	 * to the NIC driver.
 	 */
+	if (err != -ENOIOCTLCMD)
+		return err;
 
-	uifr = compat_alloc_user_space(sizeof(*uifr));
-	if (copy_in_user(uifr, uifr32, sizeof(*uifr32)))
+	if (get_user_ifreq(&ifr, NULL, uifr32))
 		return -EFAULT;
+	err = dev_ioctl(net, cmd, &ifr, &need_copyout);
+	if (!err && need_copyout)
+		if (put_user_ifreq(&ifr, uifr32))
+			return -EFAULT;
 
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
 	return err;
 }
 
@@ -3310,7 +3337,7 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 	case SIOCBONDRELEASE:
 	case SIOCBONDSETHWADDR:
 	case SIOCBONDCHANGEACTIVE:
-		return compat_ifreq_ioctl(net, sock, cmd, argp);
+		return compat_ifreq_ioctl(net, sock, cmd, arg, argp);
 
 	case SIOCSARP:
 	case SIOCGARP:
-- 
2.29.2

