Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF64A3CFD7D
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240756AbhGTOop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:44:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239022AbhGTOUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 10:20:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2582561285;
        Tue, 20 Jul 2021 14:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626792442;
        bh=bWLsSWC8k39t+r2sQli/s2h9YNWqsNT0poD4Vj+F8Tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KR26fH1dwu0vMQ5fI5wCmiT4+PWuBbSGf1voSRTh0frUZXDLghbQWsloR07lDbJlI
         lcnuXxuamhn3uABVsgpkH27PZQNRCnutst20Pg/nyBr3Ifmyh82OLUOaSOa/aweqMy
         66uRRE3CbAFoMSshXJ65dHn5msVwboiUSWkoLyOf1sgSW3+mmgUxHWP2Q88avSIRbC
         +bEIGEqdAKuTMI/tvBN6MJ+mwZLlnjb9/8PqCd3r3SJvsa19XUjpPKygc55wKjZb2v
         K9CPPSfPLCF8zRlv49DCHl5aOJ3SDyXCqvvFKol0DvqID++ZGO+oom4EVje305by5z
         o0hII5yEsOQPQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v2 26/31] dev_ioctl: pass SIOCDEVPRIVATE data separately
Date:   Tue, 20 Jul 2021 16:46:33 +0200
Message-Id: <20210720144638.2859828-27-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210720144638.2859828-1-arnd@kernel.org>
References: <20210720144638.2859828-1-arnd@kernel.org>
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
index 05d70143715b..2db3c39648ac 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4010,9 +4010,9 @@ bool dev_valid_name(const char *name);
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
index a54414590c81..754a38912e6d 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -258,11 +258,10 @@ static int dev_do_ioctl(struct net_device *dev,
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
@@ -272,13 +271,15 @@ static int dev_siocdevprivate(struct net_device *dev,
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
@@ -354,7 +355,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, unsigned int cmd)
 	default:
 		if (cmd >= SIOCDEVPRIVATE &&
 		    cmd <= SIOCDEVPRIVATE + 15)
-			return dev_siocdevprivate(dev, ifr, cmd);
+			return dev_siocdevprivate(dev, ifr, data, cmd);
 
 		if (cmd == SIOCBONDENSLAVE ||
 		    cmd == SIOCBONDRELEASE ||
@@ -423,7 +424,8 @@ EXPORT_SYMBOL(dev_load);
  *	positive or a negative errno code on error.
  */
 
-int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr, bool *need_copyout)
+int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr,
+	      void __user *data, bool *need_copyout)
 {
 	int ret;
 	char *colon;
@@ -474,7 +476,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr, bool *need_c
 	case SIOCETHTOOL:
 		dev_load(net, ifr->ifr_name);
 		rtnl_lock();
-		ret = dev_ethtool(net, ifr);
+		ret = dev_ethtool(net, ifr, data);
 		rtnl_unlock();
 		if (colon)
 			*colon = ':';
@@ -493,7 +495,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr, bool *need_c
 		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 		rtnl_lock();
-		ret = dev_ifsioc(net, ifr, cmd);
+		ret = dev_ifsioc(net, ifr, data, cmd);
 		rtnl_unlock();
 		if (colon)
 			*colon = ':';
@@ -539,7 +541,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr, bool *need_c
 	case SIOCBONDINFOQUERY:
 		dev_load(net, ifr->ifr_name);
 		rtnl_lock();
-		ret = dev_ifsioc(net, ifr, cmd);
+		ret = dev_ifsioc(net, ifr, data, cmd);
 		rtnl_unlock();
 		if (need_copyout)
 			*need_copyout = false;
@@ -564,7 +566,7 @@ int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr, bool *need_c
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

