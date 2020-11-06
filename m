Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846252A9FF2
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbgKFWTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:19:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:42586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729150AbgKFWTE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:19:04 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEE9B22201;
        Fri,  6 Nov 2020 22:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701143;
        bh=ysYDM/vt/vv06eawnigqKaoLaPs4QVuHW9gnNpT3Bpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eR61PsmTfU34VqKAnAX8inE1MhMM4QOfgeqe42Vbbl+tT3v4wa0MnuL90l8vPHhzE
         7ZfEs2eiSLdcEz6L9q6k2/0dgWKXm1Na/8j5ZgJEy43EPeVoHcSEdezmayrwdUHP+n
         xSzlBqN1cQ7NxA6K1K8oUI2o0JnGwrXs2Cq2bCUs=
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
Subject: [RFC net-next 24/28] ip_tunnel: use ndo_siocdevprivate
Date:   Fri,  6 Nov 2020 23:17:39 +0100
Message-Id: <20201106221743.3271965-25-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106221743.3271965-1-arnd@kernel.org>
References: <20201106221743.3271965-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The various ipv4 and ipv6 tunnel drivers each implement a set
of 12 SIOCDEVPRIVATE commands for managing tunnels. These
all work correctly in compat mode.

Move them over to the new .ndo_siocdevprivate operation.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/net/ip_tunnels.h |  3 ++-
 net/ipv4/ip_gre.c        |  2 +-
 net/ipv4/ip_tunnel.c     |  9 +++++----
 net/ipv4/ip_vti.c        |  2 +-
 net/ipv4/ipip.c          |  2 +-
 net/ipv6/ip6_gre.c       | 16 ++++++++--------
 net/ipv6/ip6_tunnel.c    | 18 ++++++++++--------
 net/ipv6/ip6_vti.c       | 21 +++++++++++----------
 net/ipv6/sit.c           | 35 ++++++++++++++++++-----------------
 9 files changed, 57 insertions(+), 51 deletions(-)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 02ccd32542d0..98e813587e0e 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -270,7 +270,8 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 		       const u8 proto, int tunnel_hlen);
 int ip_tunnel_ctl(struct net_device *dev, struct ip_tunnel_parm *p, int cmd);
-int ip_tunnel_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
+int ip_tunnel_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+			     void __user *data, int cmd);
 int __ip_tunnel_change_mtu(struct net_device *dev, int new_mtu, bool strict);
 int ip_tunnel_change_mtu(struct net_device *dev, int new_mtu);
 
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index e70291748889..d72841adf05e 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -918,7 +918,7 @@ static const struct net_device_ops ipgre_netdev_ops = {
 	.ndo_stop		= ipgre_close,
 #endif
 	.ndo_start_xmit		= ipgre_xmit,
-	.ndo_do_ioctl		= ip_tunnel_ioctl,
+	.ndo_siocdevprivate	= ip_tunnel_siocdevprivate,
 	.ndo_change_mtu		= ip_tunnel_change_mtu,
 	.ndo_get_stats64	= ip_tunnel_get_stats64,
 	.ndo_get_iflink		= ip_tunnel_get_iflink,
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 8b04d1dcfec4..f2d8eec2737c 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -958,19 +958,20 @@ int ip_tunnel_ctl(struct net_device *dev, struct ip_tunnel_parm *p, int cmd)
 }
 EXPORT_SYMBOL_GPL(ip_tunnel_ctl);
 
-int ip_tunnel_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+int ip_tunnel_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+			     void __user *data, int cmd)
 {
 	struct ip_tunnel_parm p;
 	int err;
 
-	if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
+	if (copy_from_user(&p, data, sizeof(p)))
 		return -EFAULT;
 	err = dev->netdev_ops->ndo_tunnel_ctl(dev, &p, cmd);
-	if (!err && copy_to_user(ifr->ifr_ifru.ifru_data, &p, sizeof(p)))
+	if (!err && copy_to_user(data, &p, sizeof(p)))
 		return -EFAULT;
 	return err;
 }
-EXPORT_SYMBOL_GPL(ip_tunnel_ioctl);
+EXPORT_SYMBOL_GPL(ip_tunnel_siocdevprivate);
 
 int __ip_tunnel_change_mtu(struct net_device *dev, int new_mtu, bool strict)
 {
diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index b957cbee2cf7..83207ffb4007 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -402,7 +402,7 @@ static const struct net_device_ops vti_netdev_ops = {
 	.ndo_init	= vti_tunnel_init,
 	.ndo_uninit	= ip_tunnel_uninit,
 	.ndo_start_xmit	= vti_tunnel_xmit,
-	.ndo_do_ioctl	= ip_tunnel_ioctl,
+	.ndo_siocdevprivate = ip_tunnel_siocdevprivate,
 	.ndo_change_mtu	= ip_tunnel_change_mtu,
 	.ndo_get_stats64 = ip_tunnel_get_stats64,
 	.ndo_get_iflink = ip_tunnel_get_iflink,
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 75d35e76bec2..5f03ef42ba19 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -345,7 +345,7 @@ static const struct net_device_ops ipip_netdev_ops = {
 	.ndo_init       = ipip_tunnel_init,
 	.ndo_uninit     = ip_tunnel_uninit,
 	.ndo_start_xmit	= ipip_tunnel_xmit,
-	.ndo_do_ioctl	= ip_tunnel_ioctl,
+	.ndo_siocdevprivate = ip_tunnel_siocdevprivate,
 	.ndo_change_mtu = ip_tunnel_change_mtu,
 	.ndo_get_stats64 = ip_tunnel_get_stats64,
 	.ndo_get_iflink = ip_tunnel_get_iflink,
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 931b186d2e48..5dddb73e0a3b 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1235,8 +1235,8 @@ static void ip6gre_tnl_parm_to_user(struct ip6_tnl_parm2 *u,
 	memcpy(u->name, p->name, sizeof(u->name));
 }
 
-static int ip6gre_tunnel_ioctl(struct net_device *dev,
-	struct ifreq *ifr, int cmd)
+static int ip6gre_tunnel_siocdevprivate(struct net_device *dev,
+	struct ifreq *ifr, void __user *data, int cmd)
 {
 	int err = 0;
 	struct ip6_tnl_parm2 p;
@@ -1250,7 +1250,7 @@ static int ip6gre_tunnel_ioctl(struct net_device *dev,
 	switch (cmd) {
 	case SIOCGETTUNNEL:
 		if (dev == ign->fb_tunnel_dev) {
-			if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p))) {
+			if (copy_from_user(&p, data, sizeof(p))) {
 				err = -EFAULT;
 				break;
 			}
@@ -1261,7 +1261,7 @@ static int ip6gre_tunnel_ioctl(struct net_device *dev,
 		}
 		memset(&p, 0, sizeof(p));
 		ip6gre_tnl_parm_to_user(&p, &t->parms);
-		if (copy_to_user(ifr->ifr_ifru.ifru_data, &p, sizeof(p)))
+		if (copy_to_user(data, &p, sizeof(p)))
 			err = -EFAULT;
 		break;
 
@@ -1272,7 +1272,7 @@ static int ip6gre_tunnel_ioctl(struct net_device *dev,
 			goto done;
 
 		err = -EFAULT;
-		if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
+		if (copy_from_user(&p, data, sizeof(p)))
 			goto done;
 
 		err = -EINVAL;
@@ -1309,7 +1309,7 @@ static int ip6gre_tunnel_ioctl(struct net_device *dev,
 
 			memset(&p, 0, sizeof(p));
 			ip6gre_tnl_parm_to_user(&p, &t->parms);
-			if (copy_to_user(ifr->ifr_ifru.ifru_data, &p, sizeof(p)))
+			if (copy_to_user(data, &p, sizeof(p)))
 				err = -EFAULT;
 		} else
 			err = (cmd == SIOCADDTUNNEL ? -ENOBUFS : -ENOENT);
@@ -1322,7 +1322,7 @@ static int ip6gre_tunnel_ioctl(struct net_device *dev,
 
 		if (dev == ign->fb_tunnel_dev) {
 			err = -EFAULT;
-			if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
+			if (copy_from_user(&p, data, sizeof(p)))
 				goto done;
 			err = -ENOENT;
 			ip6gre_tnl_parm_from_user(&p1, &p);
@@ -1389,7 +1389,7 @@ static const struct net_device_ops ip6gre_netdev_ops = {
 	.ndo_init		= ip6gre_tunnel_init,
 	.ndo_uninit		= ip6gre_tunnel_uninit,
 	.ndo_start_xmit		= ip6gre_tunnel_xmit,
-	.ndo_do_ioctl		= ip6gre_tunnel_ioctl,
+	.ndo_siocdevprivate	= ip6gre_tunnel_siocdevprivate,
 	.ndo_change_mtu		= ip6_tnl_change_mtu,
 	.ndo_get_stats64	= ip_tunnel_get_stats64,
 	.ndo_get_iflink		= ip6_tnl_get_iflink,
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index a0217e5bf3bc..35853fc7db7d 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1614,7 +1614,8 @@ ip6_tnl_parm_to_user(struct ip6_tnl_parm *u, const struct __ip6_tnl_parm *p)
 /**
  * ip6_tnl_ioctl - configure ipv6 tunnels from userspace
  *   @dev: virtual device associated with tunnel
- *   @ifr: parameters passed from userspace
+ *   @ifr: unused
+ *   @data: parameters passed from userspace
  *   @cmd: command to be performed
  *
  * Description:
@@ -1640,7 +1641,8 @@ ip6_tnl_parm_to_user(struct ip6_tnl_parm *u, const struct __ip6_tnl_parm *p)
  **/
 
 static int
-ip6_tnl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+ip6_tnl_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+		       void __user *data, int cmd)
 {
 	int err = 0;
 	struct ip6_tnl_parm p;
@@ -1654,7 +1656,7 @@ ip6_tnl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	switch (cmd) {
 	case SIOCGETTUNNEL:
 		if (dev == ip6n->fb_tnl_dev) {
-			if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p))) {
+			if (copy_from_user(&p, data, sizeof(p))) {
 				err = -EFAULT;
 				break;
 			}
@@ -1666,7 +1668,7 @@ ip6_tnl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			memset(&p, 0, sizeof(p));
 		}
 		ip6_tnl_parm_to_user(&p, &t->parms);
-		if (copy_to_user(ifr->ifr_ifru.ifru_data, &p, sizeof(p))) {
+		if (copy_to_user(data, &p, sizeof(p))) {
 			err = -EFAULT;
 		}
 		break;
@@ -1676,7 +1678,7 @@ ip6_tnl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 			break;
 		err = -EFAULT;
-		if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
+		if (copy_from_user(&p, data, sizeof(p)))
 			break;
 		err = -EINVAL;
 		if (p.proto != IPPROTO_IPV6 && p.proto != IPPROTO_IPIP &&
@@ -1700,7 +1702,7 @@ ip6_tnl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		if (!IS_ERR(t)) {
 			err = 0;
 			ip6_tnl_parm_to_user(&p, &t->parms);
-			if (copy_to_user(ifr->ifr_ifru.ifru_data, &p, sizeof(p)))
+			if (copy_to_user(data, &p, sizeof(p)))
 				err = -EFAULT;
 
 		} else {
@@ -1714,7 +1716,7 @@ ip6_tnl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 		if (dev == ip6n->fb_tnl_dev) {
 			err = -EFAULT;
-			if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
+			if (copy_from_user(&p, data, sizeof(p)))
 				break;
 			err = -ENOENT;
 			ip6_tnl_parm_from_user(&p1, &p);
@@ -1833,7 +1835,7 @@ static const struct net_device_ops ip6_tnl_netdev_ops = {
 	.ndo_init	= ip6_tnl_dev_init,
 	.ndo_uninit	= ip6_tnl_dev_uninit,
 	.ndo_start_xmit = ip6_tnl_start_xmit,
-	.ndo_do_ioctl	= ip6_tnl_ioctl,
+	.ndo_siocdevprivate = ip6_tnl_siocdevprivate,
 	.ndo_change_mtu = ip6_tnl_change_mtu,
 	.ndo_get_stats	= ip6_get_stats,
 	.ndo_get_iflink = ip6_tnl_get_iflink,
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 5f9c4fdc120d..c4fe54eedd5c 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -769,13 +769,14 @@ vti6_parm_to_user(struct ip6_tnl_parm2 *u, const struct __ip6_tnl_parm *p)
 }
 
 /**
- * vti6_ioctl - configure vti6 tunnels from userspace
+ * vti6_siocdevprivate - configure vti6 tunnels from userspace
  *   @dev: virtual device associated with tunnel
- *   @ifr: parameters passed from userspace
+ *   @ifr: unused
+ *   @data: parameters passed from userspace
  *   @cmd: command to be performed
  *
  * Description:
- *   vti6_ioctl() is used for managing vti6 tunnels
+ *   vti6_siocdevprivate() is used for managing vti6 tunnels
  *   from userspace.
  *
  *   The possible commands are the following:
@@ -796,7 +797,7 @@ vti6_parm_to_user(struct ip6_tnl_parm2 *u, const struct __ip6_tnl_parm *p)
  *   %-ENODEV if attempting to change or delete a nonexisting device
  **/
 static int
-vti6_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+vti6_siocdevprivate(struct net_device *dev, struct ifreq *ifr, void __user *data, int cmd)
 {
 	int err = 0;
 	struct ip6_tnl_parm2 p;
@@ -808,7 +809,7 @@ vti6_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	switch (cmd) {
 	case SIOCGETTUNNEL:
 		if (dev == ip6n->fb_tnl_dev) {
-			if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p))) {
+			if (copy_from_user(&p, data, sizeof(p))) {
 				err = -EFAULT;
 				break;
 			}
@@ -820,7 +821,7 @@ vti6_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		if (!t)
 			t = netdev_priv(dev);
 		vti6_parm_to_user(&p, &t->parms);
-		if (copy_to_user(ifr->ifr_ifru.ifru_data, &p, sizeof(p)))
+		if (copy_to_user(data, &p, sizeof(p)))
 			err = -EFAULT;
 		break;
 	case SIOCADDTUNNEL:
@@ -829,7 +830,7 @@ vti6_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 			break;
 		err = -EFAULT;
-		if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
+		if (copy_from_user(&p, data, sizeof(p)))
 			break;
 		err = -EINVAL;
 		if (p.proto != IPPROTO_IPV6  && p.proto != 0)
@@ -850,7 +851,7 @@ vti6_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		if (t) {
 			err = 0;
 			vti6_parm_to_user(&p, &t->parms);
-			if (copy_to_user(ifr->ifr_ifru.ifru_data, &p, sizeof(p)))
+			if (copy_to_user(data, &p, sizeof(p)))
 				err = -EFAULT;
 
 		} else
@@ -863,7 +864,7 @@ vti6_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 		if (dev == ip6n->fb_tnl_dev) {
 			err = -EFAULT;
-			if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
+			if (copy_from_user(&p, data, sizeof(p)))
 				break;
 			err = -ENOENT;
 			vti6_parm_from_user(&p1, &p);
@@ -888,7 +889,7 @@ static const struct net_device_ops vti6_netdev_ops = {
 	.ndo_init	= vti6_dev_init,
 	.ndo_uninit	= vti6_dev_uninit,
 	.ndo_start_xmit = vti6_tnl_xmit,
-	.ndo_do_ioctl	= vti6_ioctl,
+	.ndo_siocdevprivate = vti6_siocdevprivate,
 	.ndo_get_stats64 = ip_tunnel_get_stats64,
 	.ndo_get_iflink = ip6_tnl_get_iflink,
 };
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 5e2c34c0ac97..2812941c7779 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -298,9 +298,8 @@ __ipip6_tunnel_locate_prl(struct ip_tunnel *t, __be32 addr)
 
 }
 
-static int ipip6_tunnel_get_prl(struct net_device *dev, struct ifreq *ifr)
+static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __user *a)
 {
-	struct ip_tunnel_prl __user *a = ifr->ifr_ifru.ifru_data;
 	struct ip_tunnel *t = netdev_priv(dev);
 	struct ip_tunnel_prl kprl, *kp;
 	struct ip_tunnel_prl_entry *prl;
@@ -452,8 +451,8 @@ ipip6_tunnel_del_prl(struct ip_tunnel *t, struct ip_tunnel_prl *a)
 	return err;
 }
 
-static int ipip6_tunnel_prl_ctl(struct net_device *dev, struct ifreq *ifr,
-		int cmd)
+static int ipip6_tunnel_prl_ctl(struct net_device *dev,
+				struct ip_tunnel_prl __user *data, int cmd)
 {
 	struct ip_tunnel *t = netdev_priv(dev);
 	struct ip_tunnel_prl prl;
@@ -464,7 +463,7 @@ static int ipip6_tunnel_prl_ctl(struct net_device *dev, struct ifreq *ifr,
 	if (dev == dev_to_sit_net(dev)->fb_tunnel_dev)
 		return -EINVAL;
 
-	if (copy_from_user(&prl, ifr->ifr_ifru.ifru_data, sizeof(prl)))
+	if (copy_from_user(&prl, data, sizeof(prl)))
 		return -EFAULT;
 
 	switch (cmd) {
@@ -1193,14 +1192,14 @@ static int ipip6_tunnel_update_6rd(struct ip_tunnel *t,
 }
 
 static int
-ipip6_tunnel_get6rd(struct net_device *dev, struct ifreq *ifr)
+ipip6_tunnel_get6rd(struct net_device *dev, struct ip_tunnel_parm __user *data)
 {
 	struct ip_tunnel *t = netdev_priv(dev);
 	struct ip_tunnel_6rd ip6rd;
 	struct ip_tunnel_parm p;
 
 	if (dev == dev_to_sit_net(dev)->fb_tunnel_dev) {
-		if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
+		if (copy_from_user(&p, data, sizeof(p)))
 			return -EFAULT;
 		t = ipip6_tunnel_locate(t->net, &p, 0);
 	}
@@ -1211,13 +1210,14 @@ ipip6_tunnel_get6rd(struct net_device *dev, struct ifreq *ifr)
 	ip6rd.relay_prefix = t->ip6rd.relay_prefix;
 	ip6rd.prefixlen = t->ip6rd.prefixlen;
 	ip6rd.relay_prefixlen = t->ip6rd.relay_prefixlen;
-	if (copy_to_user(ifr->ifr_ifru.ifru_data, &ip6rd, sizeof(ip6rd)))
+	if (copy_to_user(data, &ip6rd, sizeof(ip6rd)))
 		return -EFAULT;
 	return 0;
 }
 
 static int
-ipip6_tunnel_6rdctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+ipip6_tunnel_6rdctl(struct net_device *dev, struct ip_tunnel_6rd __user *data,
+		    int cmd)
 {
 	struct ip_tunnel *t = netdev_priv(dev);
 	struct ip_tunnel_6rd ip6rd;
@@ -1225,7 +1225,7 @@ ipip6_tunnel_6rdctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 	if (!ns_capable(t->net->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
-	if (copy_from_user(&ip6rd, ifr->ifr_ifru.ifru_data, sizeof(ip6rd)))
+	if (copy_from_user(&ip6rd, data, sizeof(ip6rd)))
 		return -EFAULT;
 
 	if (cmd != SIOCDEL6RD) {
@@ -1364,27 +1364,28 @@ ipip6_tunnel_ctl(struct net_device *dev, struct ip_tunnel_parm *p, int cmd)
 }
 
 static int
-ipip6_tunnel_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+ipip6_tunnel_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+			    void __user *data, int cmd)
 {
 	switch (cmd) {
 	case SIOCGETTUNNEL:
 	case SIOCADDTUNNEL:
 	case SIOCCHGTUNNEL:
 	case SIOCDELTUNNEL:
-		return ip_tunnel_ioctl(dev, ifr, cmd);
+		return ip_tunnel_siocdevprivate(dev, ifr, data, cmd);
 	case SIOCGETPRL:
-		return ipip6_tunnel_get_prl(dev, ifr);
+		return ipip6_tunnel_get_prl(dev, data);
 	case SIOCADDPRL:
 	case SIOCDELPRL:
 	case SIOCCHGPRL:
-		return ipip6_tunnel_prl_ctl(dev, ifr, cmd);
+		return ipip6_tunnel_prl_ctl(dev, data, cmd);
 #ifdef CONFIG_IPV6_SIT_6RD
 	case SIOCGET6RD:
-		return ipip6_tunnel_get6rd(dev, ifr);
+		return ipip6_tunnel_get6rd(dev, data);
 	case SIOCADD6RD:
 	case SIOCCHG6RD:
 	case SIOCDEL6RD:
-		return ipip6_tunnel_6rdctl(dev, ifr, cmd);
+		return ipip6_tunnel_6rdctl(dev, data, cmd);
 #endif
 	default:
 		return -EINVAL;
@@ -1395,7 +1396,7 @@ static const struct net_device_ops ipip6_netdev_ops = {
 	.ndo_init	= ipip6_tunnel_init,
 	.ndo_uninit	= ipip6_tunnel_uninit,
 	.ndo_start_xmit	= sit_tunnel_xmit,
-	.ndo_do_ioctl	= ipip6_tunnel_ioctl,
+	.ndo_siocdevprivate = ipip6_tunnel_siocdevprivate,
 	.ndo_get_stats64 = ip_tunnel_get_stats64,
 	.ndo_get_iflink = ip_tunnel_get_iflink,
 	.ndo_tunnel_ctl = ipip6_tunnel_ctl,
-- 
2.27.0

