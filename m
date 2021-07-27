Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E849B3D7750
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237480AbhG0Nra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:47:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237155AbhG0Nqt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F4DB61AAD;
        Tue, 27 Jul 2021 13:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393604;
        bh=eXkkQpZec8cCxJcTy5NJvtTTIjMadUBotcGwOAgG0FY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XShI4VpnGp7XjbN2UhuPtD2z5e4+EXudGSJdIWwkxdX72H69ULuLWGlI5vv8uTXS0
         eJUgvwW/LmozNF0FylLYxaQmOQJm8D8W6i/ZGrSootwBSPA9cbtSZqW4E7TFxQm/ne
         00ZqGJEFl96gE43aHMjnPaKOIiP7hACv/mPEB9kQP0NBkx9jMRh8N1Pq9IlVQNwtUx
         RWtmm5OPuzMeuzmIriv++HahJODqZXp/Z+HxD0HDhOtGjfQK0xT9JS+cFrnWVckt60
         4FePHLQk644zqZ3S3MJNwIyDxVSH6Hbzw14p+ocnNe/72SXRbUeCgXs8icuBMNdHYU
         Al3uAJuKXIS2g==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v3 26/31] dev_ioctl: pass SIOCDEVPRIVATE data separately
Date:   Tue, 27 Jul 2021 15:45:12 +0200
Message-Id: <20210727134517.1384504-27-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
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
index 670e1a8e5928..658d8cf57342 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4012,9 +4012,9 @@ bool dev_valid_name(const char *name);
 int get_user_ifreq(struct ifreq *ifr, void __user **ifrdata, void __user *arg);
 int put_user_ifreq(struct ifreq *ifr, void __user *arg);
 int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr,
-		bool *need_copyout);
+		void __user *data, bool *need_copyout);
 int dev_ifconf(struct net *net, struct ifconf __user *ifc);
-int dev_ethtool(struct net *net, struct ifreq *);
+int dev_ethtool(struct net *net, struct ifreq *ifr, void __user *userdata);
 unsigned int dev_get_flags(const struct net_device *);
 int __dev_change_flags(struct net_device *dev, unsigned int flags,
 		       struct netlink_ext_ack *extack);
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 75e3e340d884..3ace1e4f6b80 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -259,11 +259,10 @@ static int dev_do_ioctl(struct net_device *dev,
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
@@ -273,13 +272,15 @@ static int dev_siocdevprivate(struct net_device *dev,
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
+		      unsigned int cmd)
 {
 	int err;
 	struct net_device *dev = __dev_get_by_name(net, ifr->ifr_name);
@@ -355,7 +356,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, unsigned int cmd)
 	default:
 		if (cmd >= SIOCDEVPRIVATE &&
 		    cmd <= SIOCDEVPRIVATE + 15)
-			return dev_siocdevprivate(dev, ifr, cmd);
+			return dev_siocdevprivate(dev, ifr, data, cmd);
 
 		if (cmd == SIOCBONDENSLAVE ||
 		    cmd == SIOCBONDRELEASE ||
@@ -424,7 +425,8 @@ EXPORT_SYMBOL(dev_load);
  *	positive or a negative errno code on error.
  */
 
-int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr, bool *need_copyout)
+int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr,
+	      void __user *data, bool *need_copyout)
 {
 	int ret;
 	char *colon;
@@ -475,7 +477,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr, bool *need_c
 	case SIOCETHTOOL:
 		dev_load(net, ifr->ifr_name);
 		rtnl_lock();
-		ret = dev_ethtool(net, ifr);
+		ret = dev_ethtool(net, ifr, data);
 		rtnl_unlock();
 		if (colon)
 			*colon = ':';
@@ -494,7 +496,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr, bool *need_c
 		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 		rtnl_lock();
-		ret = dev_ifsioc(net, ifr, cmd);
+		ret = dev_ifsioc(net, ifr, data, cmd);
 		rtnl_unlock();
 		if (colon)
 			*colon = ':';
@@ -540,7 +542,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr, bool *need_c
 	case SIOCBONDINFOQUERY:
 		dev_load(net, ifr->ifr_name);
 		rtnl_lock();
-		ret = dev_ifsioc(net, ifr, cmd);
+		ret = dev_ifsioc(net, ifr, data, cmd);
 		rtnl_unlock();
 		if (need_copyout)
 			*need_copyout = false;
@@ -565,7 +567,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr, bool *need_c
 		     cmd <= SIOCDEVPRIVATE + 15)) {
 			dev_load(net, ifr->ifr_name);
 			rtnl_lock();
-			ret = dev_ifsioc(net, ifr, cmd);
+			ret = dev_ifsioc(net, ifr, data, cmd);
 			rtnl_unlock();
 			return ret;
 		}
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 6134b180f59f..e17dd751c390 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2685,10 +2685,9 @@ static int ethtool_set_fecparam(struct net_device *dev, void __user *useraddr)
 
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
index 84de89c1ee9d..ddce6327633e 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1092,6 +1092,7 @@ static long sock_do_ioctl(struct net *net, struct socket *sock,
 	bool need_copyout;
 	int err;
 	void __user *argp = (void __user *)arg;
+	void __user *data;
 
 	err = sock->ops->ioctl(sock, cmd, arg);
 
@@ -1102,11 +1103,11 @@ static long sock_do_ioctl(struct net *net, struct socket *sock,
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
@@ -1130,12 +1131,13 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
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
@@ -3186,7 +3188,7 @@ static int compat_siocwandev(struct net *net, struct compat_ifreq __user *uifr32
 	saved = ifr.ifr_settings.ifs_ifsu.raw_hdlc;
 	ifr.ifr_settings.ifs_ifsu.raw_hdlc = compat_ptr(uptr32);
 
-	err = dev_ioctl(net, SIOCWANDEV, &ifr, NULL);
+	err = dev_ioctl(net, SIOCWANDEV, &ifr, NULL, NULL);
 	if (!err) {
 		ifr.ifr_settings.ifs_ifsu.raw_hdlc = saved;
 		if (put_user_ifreq(&ifr, uifr32))
@@ -3200,42 +3202,13 @@ static int compat_ifr_data_ioctl(struct net *net, unsigned int cmd,
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
-			      unsigned long arg,
-			      struct compat_ifreq __user *uifr32)
-{
-	struct ifreq ifr;
-	bool need_copyout;
-	int err;
-
-	err = sock->ops->ioctl(sock, cmd, arg);
-
-	/* If this ioctl is unknown try to hand it down
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
@@ -3337,8 +3310,6 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 	case SIOCBONDRELEASE:
 	case SIOCBONDSETHWADDR:
 	case SIOCBONDCHANGEACTIVE:
-		return compat_ifreq_ioctl(net, sock, cmd, arg, argp);
-
 	case SIOCSARP:
 	case SIOCGARP:
 	case SIOCDARP:
-- 
2.29.2

