Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981003D25C9
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbhGVNtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:49:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232462AbhGVNs5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 09:48:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D31166120C;
        Thu, 22 Jul 2021 14:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626964172;
        bh=W9+e8IrFAfPvah86bUNMrcJYs6r3bs9IuXWRBwh35Zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3FMmzoRoQ5drSNc2LsO9o70OC6zOy7OWlVeIlSPiXdvtQFiTJVmooudOcNPe2kNe
         HRDEOQn/pxoVjqF+nCoT7ON5GmcEhANNqQlHSvEJQSB6OnIaKbuf9MsGBPv527VeY9
         kjjAiDnsCh3meFgqZGsKhEVGLroPeqG+GAYSN32dVlZVtSJD+DVJuFINPpmX1eisoR
         ltFrs7ttGgok84jmIC/eY2DRsCevwuhFnxdoxC58NrshEhSmzYljghdOBVluGRvcNP
         Pwf8YnVJe4kDXjmXjdqYQIY0aF2H78jhvQYvGsKOCUvVK7O4NG86qspNG0MWmsi+5N
         qEW8I8Z9i6YIw==
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
Subject: [PATCH net-next v6 5/6] net: socket: simplify dev_ifconf handling
Date:   Thu, 22 Jul 2021 16:29:02 +0200
Message-Id: <20210722142903.213084-6-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210722142903.213084-1-arnd@kernel.org>
References: <20210722142903.213084-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The dev_ifconf() calling conventions make compat handling
more complicated than necessary, simplify this by moving
the in_compat_syscall() check into the function.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
changes in v6:
- split register_gifconf from compat changes
---
 include/linux/netdevice.h |  2 +-
 net/core/dev_ioctl.c      | 55 +++++++++++++++++++-----------------
 net/socket.c              | 59 ++++++++++-----------------------------
 3 files changed, 44 insertions(+), 72 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6630a9f0b0f0..da2c273c7e0a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4008,7 +4008,7 @@ void netdev_rx_handler_unregister(struct net_device *dev);
 bool dev_valid_name(const char *name);
 int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr,
 		bool *need_copyout);
-int dev_ifconf(struct net *net, struct ifconf *, int);
+int dev_ifconf(struct net *net, struct ifconf __user *ifc);
 int dev_ethtool(struct net *net, struct ifreq *);
 unsigned int dev_get_flags(const struct net_device *);
 int __dev_change_flags(struct net_device *dev, unsigned int flags,
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index c22c3dc15ce9..950e2fe5d56a 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -31,48 +31,51 @@ static int dev_ifname(struct net *net, struct ifreq *ifr)
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
+
+		if (copy_from_user(&ifc32, uifc, sizeof(struct compat_ifconf)))
+			return -EFAULT;
 
-	pos = ifc->ifc_buf;
-	len = ifc->ifc_len;
+		pos = compat_ptr(ifc32.ifcbuf);
+		len = ifc32.ifc_len;
+		size = sizeof(struct compat_ifreq);
+	} else {
+		struct ifconf ifc;
 
-	/*
-	 *	Loop over the interfaces, and write an info block for each.
-	 */
+		if (copy_from_user(&ifc, uifc, sizeof(struct ifconf)))
+			return -EFAULT;
 
-	total = 0;
+		pos = ifc.ifc_buf;
+		len = ifc.ifc_len;
+		size = sizeof(struct ifreq);
+	}
+
+	/* Loop over the interfaces, and write an info block for each. */
+	rtnl_lock();
 	for_each_netdev(net, dev) {
-		int done;
 		if (!pos)
 			done = inet_gifconf(dev, NULL, 0, size);
 		else
 			done = inet_gifconf(dev, pos + total,
 					    len - total, size);
-		if (done < 0)
+		if (done < 0) {
+			rtnl_unlock();
 			return -EFAULT;
+		}
 		total += done;
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

