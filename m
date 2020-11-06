Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2019F2A9FE7
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729105AbgKFWSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:18:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:42310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729092AbgKFWSt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:18:49 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CD9A20B80;
        Fri,  6 Nov 2020 22:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701128;
        bh=DGkbWw7wjmAMM5ZBe2lu9569wYUoHpHLpYIRPiD7wVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RuNu4yRVDyrwIhAAfUVh6EgSYsGe7j7/QQ+iZjZiLtyW/C9+nb6HukDfcO5mMt5rX
         yv1aaaUDZFKlEvBUStuhWHMw0UraCwb/uQKW/ROw+XCP5FRNO/MLUAOvG2GIEp4VQh
         he+wZw3HIZ9rBgBE8/gqLnx6qvhvDiTAkOS/BWiI=
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-hams@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [RFC net-next 19/28] dev_ioctl: pass SIOCDEVPRIVATE data separately
Date:   Fri,  6 Nov 2020 23:17:34 +0100
Message-Id: <20201106221743.3271965-20-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106221743.3271965-1-arnd@kernel.org>
References: <20201106221743.3271965-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The compat handlers for SIOCDEVPRIVATE are incorrect for any driver that
passes data as part of struct ifreq rather than as an ifr_data pointer, or
that passes data back this way, since the compat_ifr_data_ioctl() helper
overwrites the ifr_data pointer and does not copy anything back out.

Since all drivers using devprivate commands are now converted to the
new .ndo_siocdevprivate callback, fix this by adding the missing piece
and passing the pointer separately the whole way.

This further unifies the native and compat logic for socket ioctls,
as the new code now passes the correct pointer as well as the correct
data for both native and compat ioctls.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/netdevice.h |  4 +--
 net/core/dev_ioctl.c      | 22 +++++++++-------
 net/ethtool/ioctl.c       |  3 +--
 net/socket.c              | 55 +++++++++------------------------------
 4 files changed, 28 insertions(+), 56 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 93f980e1d69b..931a4a0668f6 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3833,9 +3833,9 @@ bool dev_valid_name(const char *name);
 int get_user_ifreq(struct ifreq *ifr, void __user **ifrdata, void __user *arg);
 int put_user_ifreq(struct ifreq *ifr, void __user *arg);
 int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr,
-		bool *need_copyout);
+		void __user *data, bool *need_copyout);
 int dev_ifconf(struct net *net, struct ifconf __user *ifc);
-int dev_ethtool(struct net *net, struct ifreq *);
+int dev_ethtool(struct net *net, struct ifreq *, void __user *userdata);
 unsigned int dev_get_flags(const struct net_device *);
 int __dev_change_flags(struct net_device *dev, unsigned int flags,
 		       struct netlink_ext_ack *extack);
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 58daf41a4a08..1fdacd7ab210 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -269,11 +269,10 @@ static int dev_do_ioctl(struct net_device *dev,
 	return err;
 }
 
-static int dev_siocdevprivate(struct net_device *dev,
-			      struct ifreq *ifr, unsigned int cmd)
+static int dev_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+			      void __user *data, unsigned int cmd)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
-	void __user *data = ifr->ifr_data;
 
 	if (ops->ndo_siocdevprivate) {
 		if (netif_device_present(dev))
@@ -283,13 +282,15 @@ static int dev_siocdevprivate(struct net_device *dev,
 	}
 
 	/* fall back to do_ioctl for drivers not yet converted */
+	ifr->ifr_data = data;
 	return dev_do_ioctl(dev, ifr, cmd);
 }
 
 /*
  *	Perform the SIOCxIFxxx calls, inside rtnl_lock()
  */
-static int dev_ifsioc(struct net *net, struct ifreq *ifr, unsigned int cmd)
+static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
+	              unsigned int cmd)
 {
 	int err;
 	struct net_device *dev = __dev_get_by_name(net, ifr->ifr_name);
@@ -365,7 +366,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, unsigned int cmd)
 	default:
 		if (cmd >= SIOCDEVPRIVATE &&
 		    cmd <= SIOCDEVPRIVATE + 15)
-			return dev_siocdevprivate(dev, ifr, cmd);
+			return dev_siocdevprivate(dev, ifr, data, cmd);
 
 		if (cmd == SIOCBONDENSLAVE ||
 		    cmd == SIOCBONDRELEASE ||
@@ -434,7 +435,8 @@ EXPORT_SYMBOL(dev_load);
  *	positive or a negative errno code on error.
  */
 
-int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr, bool *need_copyout)
+int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr,
+		void __user *data, bool *need_copyout)
 {
 	int ret;
 	char *colon;
@@ -480,7 +482,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr, bool *need_c
 	case SIOCETHTOOL:
 		dev_load(net, ifr->ifr_name);
 		rtnl_lock();
-		ret = dev_ethtool(net, ifr);
+		ret = dev_ethtool(net, ifr, data);
 		rtnl_unlock();
 		if (colon)
 			*colon = ':';
@@ -499,7 +501,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr, bool *need_c
 		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 		rtnl_lock();
-		ret = dev_ifsioc(net, ifr, cmd);
+		ret = dev_ifsioc(net, ifr, data, cmd);
 		rtnl_unlock();
 		if (colon)
 			*colon = ':';
@@ -545,7 +547,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr, bool *need_c
 	case SIOCBONDINFOQUERY:
 		dev_load(net, ifr->ifr_name);
 		rtnl_lock();
-		ret = dev_ifsioc(net, ifr, cmd);
+		ret = dev_ifsioc(net, ifr, data, cmd);
 		rtnl_unlock();
 		if (need_copyout)
 			*need_copyout = false;
@@ -570,7 +572,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr, bool *need_c
 		     cmd <= SIOCDEVPRIVATE + 15)) {
 			dev_load(net, ifr->ifr_name);
 			rtnl_lock();
-			ret = dev_ifsioc(net, ifr, cmd);
+			ret = dev_ifsioc(net, ifr, data, cmd);
 			rtnl_unlock();
 			return ret;
 		}
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index f9dcb126baf6..3d3306fb28a8 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2671,10 +2671,9 @@ static int ethtool_set_fecparam(struct net_device *dev, void __user *useraddr)
 
 /* The main entry point in this file.  Called from net/core/dev_ioctl.c */
 
-int dev_ethtool(struct net *net, struct ifreq *ifr)
+int dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr)
 {
 	struct net_device *dev = __dev_get_by_name(net, ifr->ifr_name);
-	void __user *useraddr = ifr->ifr_data;
 	u32 ethcmd, sub_cmd;
 	int rc;
 	netdev_features_t old_features;
diff --git a/net/socket.c b/net/socket.c
index 6917835d2f3e..1e077182d0fd 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1045,6 +1045,7 @@ static long sock_do_ioctl(struct net *net, struct socket *sock,
 	bool need_copyout;
 	int err;
 	void __user *argp = (void __user *)arg;
+	void __user *data;
 
 	err = sock->ops->ioctl(sock, cmd, arg);
 
@@ -1055,11 +1056,11 @@ static long sock_do_ioctl(struct net *net, struct socket *sock,
 	if (err != -ENOIOCTLCMD)
 		return err;
 
-	if (copy_from_user(&ifr, argp, sizeof(struct ifreq)))
+	if (get_user_ifreq(&ifr, &data, argp))
 		return -EFAULT;
-	err = dev_ioctl(net, cmd, &ifr, &need_copyout);
+	err = dev_ioctl(net, cmd, &ifr, data, &need_copyout);
 	if (!err && need_copyout)
-		if (copy_to_user(argp, &ifr, sizeof(struct ifreq)))
+		if (put_user_ifreq(&ifr, argp))
 			return -EFAULT;
 
 	return err;
@@ -1096,12 +1097,13 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	net = sock_net(sk);
 	if (unlikely(cmd >= SIOCDEVPRIVATE && cmd <= (SIOCDEVPRIVATE + 15))) {
 		struct ifreq ifr;
+		void __user *data;
 		bool need_copyout;
-		if (copy_from_user(&ifr, argp, sizeof(struct ifreq)))
+		if (get_user_ifreq(&ifr, &data, argp))
 			return -EFAULT;
-		err = dev_ioctl(net, cmd, &ifr, &need_copyout);
+		err = dev_ioctl(net, cmd, &ifr, data, &need_copyout);
 		if (!err && need_copyout)
-			if (copy_to_user(argp, &ifr, sizeof(struct ifreq)))
+			if (put_user_ifreq(&ifr, argp))
 				return -EFAULT;
 	} else
 #ifdef CONFIG_WEXT_CORE
@@ -3158,7 +3160,7 @@ static int compat_siocwandev(struct net *net, struct compat_ifreq __user *uifr32
 	saved = ifr.ifr_settings.ifs_ifsu.raw_hdlc;
 	ifr.ifr_settings.ifs_ifsu.raw_hdlc = compat_ptr(uptr32);
 
-	err = dev_ioctl(net, SIOCWANDEV, &ifr, NULL);
+	err = dev_ioctl(net, SIOCWANDEV, &ifr, NULL, NULL);
 	if (!err) {
 		ifr.ifr_settings.ifs_ifsu.raw_hdlc = saved;
 		if (put_user_ifreq(&ifr, uifr32))
@@ -3172,42 +3174,13 @@ static int compat_ifr_data_ioctl(struct net *net, unsigned int cmd,
 				 struct compat_ifreq __user *u_ifreq32)
 {
 	struct ifreq ifreq;
-	u32 data32;
+	void __user *data;
 
-	if (copy_from_user(ifreq.ifr_name, u_ifreq32->ifr_name, IFNAMSIZ))
+	if (get_user_ifreq(&ifreq, &data, u_ifreq32))
 		return -EFAULT;
-	if (get_user(data32, &u_ifreq32->ifr_data))
-		return -EFAULT;
-	ifreq.ifr_data = compat_ptr(data32);
+	ifreq.ifr_data = data;
 
-	return dev_ioctl(net, cmd, &ifreq, NULL);
-}
-
-static int compat_ifreq_ioctl(struct net *net, struct socket *sock,
-			      unsigned int cmd,
-			      struct compat_ifreq __user *uifr32)
-{
-	struct ifreq ifr;
-	bool need_copyout;
-	int err;
-
-	err = sock->ops->ioctl(sock, cmd, arg);
-
-	/*
-	 * If this ioctl is unknown try to hand it down
-	 * to the NIC driver.
-	 */
-	if (err != -ENOIOCTLCMD)
-		return err;
-
-	if (get_user_ifreq(&ifr, NULL, uifr32))
-		return -EFAULT;
-	err = dev_ioctl(net, cmd, &ifr, &need_copyout);
-	if (!err && need_copyout)
-		if (put_user_ifreq(&ifr, uifr32))
-			return -EFAULT;
-
-	return err;
+	return dev_ioctl(net, cmd, &ifreq, data, NULL);
 }
 
 /* Since old style bridge ioctl's endup using SIOCDEVPRIVATE
@@ -3311,8 +3284,6 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
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

