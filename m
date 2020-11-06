Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A291F2A9AEA
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 18:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgKFRdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 12:33:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:45252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727699AbgKFRcz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 12:32:55 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE637208C7;
        Fri,  6 Nov 2020 17:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604683973;
        bh=Sn0an9I985hou8WPDGVTMqYUnZ7RLggcEPn1f0frA9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6TsnMr6Gn6CHP9zahGatqeJYyrIY0m6SCtkGPepm/ashBCuNdXOkwEdt+Q0vZTzd
         dHQA9TMqoXGV81qiXBeo87Ld0o5ImShQJUbnMXmOu+IFb4X1REsTqW9+c/aeoXJw2H
         MZcP9I+bgrNMz8hj4HaRdaVG2BlDfc1C6CxSeoSc=
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
Subject: [PATCH net-next v3 4/4] net: socket: rework compat_ifreq_ioctl()
Date:   Fri,  6 Nov 2020 18:32:31 +0100
Message-Id: <20201106173231.3031349-5-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106173231.3031349-1-arnd@kernel.org>
References: <20201106173231.3031349-1-arnd@kernel.org>
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
 include/linux/netdevice.h |   2 +
 net/appletalk/ddp.c       |   4 +-
 net/ieee802154/socket.c   |   4 +-
 net/ipv4/af_inet.c        |   6 +--
 net/qrtr/qrtr.c           |   4 +-
 net/socket.c              | 102 ++++++++++++++++++++++++--------------
 6 files changed, 76 insertions(+), 46 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b54d5308087d..d1b7fb1241b3 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3827,6 +3827,8 @@ int netdev_rx_handler_register(struct net_device *dev,
 void netdev_rx_handler_unregister(struct net_device *dev);
 
 bool dev_valid_name(const char *name);
+int get_user_ifreq(struct ifreq *ifr, void __user **ifrdata, void __user *arg);
+int put_user_ifreq(struct ifreq *ifr, void __user *arg);
 int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr,
 		bool *need_copyout);
 int dev_ifconf(struct net *net, struct ifconf __user *ifc);
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 1d48708c5a2e..3b3eccf90180 100644
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
index b7260c8cef2e..fb66d3f17a17 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -949,10 +949,10 @@ int inet_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
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
 
@@ -962,7 +962,7 @@ int inet_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 	case SIOCSIFDSTADDR:
 	case SIOCSIFPFLAGS:
 	case SIOCSIFFLAGS:
-		if (copy_from_user(&ifr, p, sizeof(struct ifreq)))
+		if (get_user_ifreq(&ifr, NULL, p))
 			return -EFAULT;
 		err = devinet_ioctl(net, cmd, &ifr);
 		break;
diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 957aa9263ba4..ad430b401e00 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -1134,14 +1134,14 @@ static int qrtr_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
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
index f26ef299b6c5..6917835d2f3e 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3092,6 +3092,55 @@ void socket_seq_show(struct seq_file *seq)
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
+
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
@@ -3100,7 +3149,7 @@ static int compat_siocwandev(struct net *net, struct compat_ifreq __user *uifr32
 	void __user *saved;
 	int err;
 
-	if (copy_from_user(&ifr, uifr32, sizeof(struct compat_ifreq)))
+	if (get_user_ifreq(&ifr, NULL, uifr32))
 		return -EFAULT;
 
 	if (get_user(uptr32, &uifr32->ifr_settings.ifs_ifsu))
@@ -3112,7 +3161,7 @@ static int compat_siocwandev(struct net *net, struct compat_ifreq __user *uifr32
 	err = dev_ioctl(net, SIOCWANDEV, &ifr, NULL);
 	if (!err) {
 		ifr.ifr_settings.ifs_ifsu.raw_hdlc = saved;
-		if (copy_to_user(uifr32, &ifr, sizeof(struct compat_ifreq)))
+		if (put_user_ifreq(&ifr, uifr32))
 			err = -EFAULT;
 	}
 	return err;
@@ -3138,47 +3187,26 @@ static int compat_ifreq_ioctl(struct net *net, struct socket *sock,
 			      unsigned int cmd,
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
+	/*
+	 * If this ioctl is unknown try to hand it down
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
 
-- 
2.27.0

