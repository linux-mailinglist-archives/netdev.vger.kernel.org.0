Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B4E3CFD6C
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241172AbhGTOlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:41:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239512AbhGTOUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 10:20:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 342EF61264;
        Tue, 20 Jul 2021 14:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626792436;
        bh=K/yvTrMp3mCCab4eZm4WuR+AlhcPZHMtV8lVdylh+eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bI9ZEQqvxJzQzGpC8kVjzcu7QfIl7DqUGd25ixHWLWxYZr/Uwx9vUpXHsJuCDCTu/
         NeXVHIDkdmYnR63ceA16fLaLQuPzDVP4Tn8K9v/8+8JPBYTD/YHc9UqsG5ta/8DhK9
         VTmZ1YFbyWkCwGCjK3x0zAiFnIHhtf6XB1AeS6w+VDg0FbvEUExd0lSEQGz2zG0ygr
         WyCr73ZxRrOEAkpS5KuzeHukP7uc1ePjLMXMauKx/cJmgHVqx2Q3mctOoWfa1Rv9Qn
         JfmSIU9Jyt8TTodVjIZHjSUGXoqDgbvdSgs/1C7Qd/cW2ecgkbeuUymyt/zRMiwbV0
         TGsEAb6JHvtjg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v2 20/31] ip_tunnel: use ndo_siocdevprivate
Date:   Tue, 20 Jul 2021 16:46:27 +0200
Message-Id: <20210720144638.2859828-21-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210720144638.2859828-1-arnd@kernel.org>
References: <20210720144638.2859828-1-arnd@kernel.org>
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
 net/ipv6/ip6_gre.c       | 17 +++++++++--------
 net/ipv6/ip6_tunnel.c    | 21 +++++++++++----------
 net/ipv6/ip6_vti.c       | 21 +++++++++++----------
 net/ipv6/sit.c           | 35 ++++++++++++++++++-----------------
 9 files changed, 59 insertions(+), 53 deletions(-)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 548b65bd3973..bc3b13ec93c9 100644
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
index 12dca0c85f3c..6ebf05859acb 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -923,7 +923,7 @@ static const struct net_device_ops ipgre_netdev_ops = {
 	.ndo_stop		= ipgre_close,
 #endif
 	.ndo_start_xmit		= ipgre_xmit,
-	.ndo_do_ioctl		= ip_tunnel_ioctl,
+	.ndo_siocdevprivate	= ip_tunnel_siocdevprivate,
 	.ndo_change_mtu		= ip_tunnel_change_mtu,
 	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_get_iflink		= ip_tunnel_get_iflink,
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 0dca00745ac3..7f0e810c06f4 100644
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
index eb560eecee08..efe25a0172e6 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -405,7 +405,7 @@ static const struct net_device_ops vti_netdev_ops = {
 	.ndo_init	= vti_tunnel_init,
 	.ndo_uninit	= ip_tunnel_uninit,
 	.ndo_start_xmit	= vti_tunnel_xmit,
-	.ndo_do_ioctl	= ip_tunnel_ioctl,
+	.ndo_siocdevprivate = ip_tunnel_siocdevprivate,
 	.ndo_change_mtu	= ip_tunnel_change_mtu,
 	.ndo_get_stats64 = dev_get_tstats64,
 	.ndo_get_iflink = ip_tunnel_get_iflink,
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 266c65577ba6..3aa78ccbec3e 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -347,7 +347,7 @@ static const struct net_device_ops ipip_netdev_ops = {
 	.ndo_init       = ipip_tunnel_init,
 	.ndo_uninit     = ip_tunnel_uninit,
 	.ndo_start_xmit	= ipip_tunnel_xmit,
-	.ndo_do_ioctl	= ip_tunnel_ioctl,
+	.ndo_siocdevprivate = ip_tunnel_siocdevprivate,
 	.ndo_change_mtu = ip_tunnel_change_mtu,
 	.ndo_get_stats64 = dev_get_tstats64,
 	.ndo_get_iflink = ip_tunnel_get_iflink,
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index bc224f917bbd..3ad201d372d8 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1244,8 +1244,9 @@ static void ip6gre_tnl_parm_to_user(struct ip6_tnl_parm2 *u,
 	memcpy(u->name, p->name, sizeof(u->name));
 }
 
-static int ip6gre_tunnel_ioctl(struct net_device *dev,
-	struct ifreq *ifr, int cmd)
+static int ip6gre_tunnel_siocdevprivate(struct net_device *dev,
+					struct ifreq *ifr, void __user *data,
+					int cmd)
 {
 	int err = 0;
 	struct ip6_tnl_parm2 p;
@@ -1259,7 +1260,7 @@ static int ip6gre_tunnel_ioctl(struct net_device *dev,
 	switch (cmd) {
 	case SIOCGETTUNNEL:
 		if (dev == ign->fb_tunnel_dev) {
-			if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p))) {
+			if (copy_from_user(&p, data, sizeof(p))) {
 				err = -EFAULT;
 				break;
 			}
@@ -1270,7 +1271,7 @@ static int ip6gre_tunnel_ioctl(struct net_device *dev,
 		}
 		memset(&p, 0, sizeof(p));
 		ip6gre_tnl_parm_to_user(&p, &t->parms);
-		if (copy_to_user(ifr->ifr_ifru.ifru_data, &p, sizeof(p)))
+		if (copy_to_user(data, &p, sizeof(p)))
 			err = -EFAULT;
 		break;
 
@@ -1281,7 +1282,7 @@ static int ip6gre_tunnel_ioctl(struct net_device *dev,
 			goto done;
 
 		err = -EFAULT;
-		if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
+		if (copy_from_user(&p, data, sizeof(p)))
 			goto done;
 
 		err = -EINVAL;
@@ -1318,7 +1319,7 @@ static int ip6gre_tunnel_ioctl(struct net_device *dev,
 
 			memset(&p, 0, sizeof(p));
 			ip6gre_tnl_parm_to_user(&p, &t->parms);
-			if (copy_to_user(ifr->ifr_ifru.ifru_data, &p, sizeof(p)))
+			if (copy_to_user(data, &p, sizeof(p)))
 				err = -EFAULT;
 		} else
 			err = (cmd == SIOCADDTUNNEL ? -ENOBUFS : -ENOENT);
@@ -1331,7 +1332,7 @@ static int ip6gre_tunnel_ioctl(struct net_device *dev,
 
 		if (dev == ign->fb_tunnel_dev) {
 			err = -EFAULT;
-			if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
+			if (copy_from_user(&p, data, sizeof(p)))
 				goto done;
 			err = -ENOENT;
 			ip6gre_tnl_parm_from_user(&p1, &p);
@@ -1398,7 +1399,7 @@ static const struct net_device_ops ip6gre_netdev_ops = {
 	.ndo_init		= ip6gre_tunnel_init,
 	.ndo_uninit		= ip6gre_tunnel_uninit,
 	.ndo_start_xmit		= ip6gre_tunnel_xmit,
-	.ndo_do_ioctl		= ip6gre_tunnel_ioctl,
+	.ndo_siocdevprivate	= ip6gre_tunnel_siocdevprivate,
 	.ndo_change_mtu		= ip6_tnl_change_mtu,
 	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_get_iflink		= ip6_tnl_get_iflink,
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 322698d9fcf4..20a67efda47f 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1581,9 +1581,10 @@ ip6_tnl_parm_to_user(struct ip6_tnl_parm *u, const struct __ip6_tnl_parm *p)
 }
 
 /**
- * ip6_tnl_ioctl - configure ipv6 tunnels from userspace
+ * ip6_tnl_siocdevprivate - configure ipv6 tunnels from userspace
  *   @dev: virtual device associated with tunnel
- *   @ifr: parameters passed from userspace
+ *   @ifr: unused
+ *   @data: parameters passed from userspace
  *   @cmd: command to be performed
  *
  * Description:
@@ -1609,7 +1610,8 @@ ip6_tnl_parm_to_user(struct ip6_tnl_parm *u, const struct __ip6_tnl_parm *p)
  **/
 
 static int
-ip6_tnl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+ip6_tnl_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+		       void __user *data, int cmd)
 {
 	int err = 0;
 	struct ip6_tnl_parm p;
@@ -1623,7 +1625,7 @@ ip6_tnl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	switch (cmd) {
 	case SIOCGETTUNNEL:
 		if (dev == ip6n->fb_tnl_dev) {
-			if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p))) {
+			if (copy_from_user(&p, data, sizeof(p))) {
 				err = -EFAULT;
 				break;
 			}
@@ -1635,9 +1637,8 @@ ip6_tnl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			memset(&p, 0, sizeof(p));
 		}
 		ip6_tnl_parm_to_user(&p, &t->parms);
-		if (copy_to_user(ifr->ifr_ifru.ifru_data, &p, sizeof(p))) {
+		if (copy_to_user(data, &p, sizeof(p)))
 			err = -EFAULT;
-		}
 		break;
 	case SIOCADDTUNNEL:
 	case SIOCCHGTUNNEL:
@@ -1645,7 +1646,7 @@ ip6_tnl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 			break;
 		err = -EFAULT;
-		if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
+		if (copy_from_user(&p, data, sizeof(p)))
 			break;
 		err = -EINVAL;
 		if (p.proto != IPPROTO_IPV6 && p.proto != IPPROTO_IPIP &&
@@ -1669,7 +1670,7 @@ ip6_tnl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		if (!IS_ERR(t)) {
 			err = 0;
 			ip6_tnl_parm_to_user(&p, &t->parms);
-			if (copy_to_user(ifr->ifr_ifru.ifru_data, &p, sizeof(p)))
+			if (copy_to_user(data, &p, sizeof(p)))
 				err = -EFAULT;
 
 		} else {
@@ -1683,7 +1684,7 @@ ip6_tnl_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 		if (dev == ip6n->fb_tnl_dev) {
 			err = -EFAULT;
-			if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
+			if (copy_from_user(&p, data, sizeof(p)))
 				break;
 			err = -ENOENT;
 			ip6_tnl_parm_from_user(&p1, &p);
@@ -1802,7 +1803,7 @@ static const struct net_device_ops ip6_tnl_netdev_ops = {
 	.ndo_init	= ip6_tnl_dev_init,
 	.ndo_uninit	= ip6_tnl_dev_uninit,
 	.ndo_start_xmit = ip6_tnl_start_xmit,
-	.ndo_do_ioctl	= ip6_tnl_ioctl,
+	.ndo_siocdevprivate = ip6_tnl_siocdevprivate,
 	.ndo_change_mtu = ip6_tnl_change_mtu,
 	.ndo_get_stats64 = dev_get_tstats64,
 	.ndo_get_iflink = ip6_tnl_get_iflink,
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 2d048e21abbb..1d8e3ffa225d 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -771,13 +771,14 @@ vti6_parm_to_user(struct ip6_tnl_parm2 *u, const struct __ip6_tnl_parm *p)
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
@@ -798,7 +799,7 @@ vti6_parm_to_user(struct ip6_tnl_parm2 *u, const struct __ip6_tnl_parm *p)
  *   %-ENODEV if attempting to change or delete a nonexisting device
  **/
 static int
-vti6_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+vti6_siocdevprivate(struct net_device *dev, struct ifreq *ifr, void __user *data, int cmd)
 {
 	int err = 0;
 	struct ip6_tnl_parm2 p;
@@ -810,7 +811,7 @@ vti6_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	switch (cmd) {
 	case SIOCGETTUNNEL:
 		if (dev == ip6n->fb_tnl_dev) {
-			if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p))) {
+			if (copy_from_user(&p, data, sizeof(p))) {
 				err = -EFAULT;
 				break;
 			}
@@ -822,7 +823,7 @@ vti6_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		if (!t)
 			t = netdev_priv(dev);
 		vti6_parm_to_user(&p, &t->parms);
-		if (copy_to_user(ifr->ifr_ifru.ifru_data, &p, sizeof(p)))
+		if (copy_to_user(data, &p, sizeof(p)))
 			err = -EFAULT;
 		break;
 	case SIOCADDTUNNEL:
@@ -831,7 +832,7 @@ vti6_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 			break;
 		err = -EFAULT;
-		if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
+		if (copy_from_user(&p, data, sizeof(p)))
 			break;
 		err = -EINVAL;
 		if (p.proto != IPPROTO_IPV6  && p.proto != 0)
@@ -852,7 +853,7 @@ vti6_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		if (t) {
 			err = 0;
 			vti6_parm_to_user(&p, &t->parms);
-			if (copy_to_user(ifr->ifr_ifru.ifru_data, &p, sizeof(p)))
+			if (copy_to_user(data, &p, sizeof(p)))
 				err = -EFAULT;
 
 		} else
@@ -865,7 +866,7 @@ vti6_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 		if (dev == ip6n->fb_tnl_dev) {
 			err = -EFAULT;
-			if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
+			if (copy_from_user(&p, data, sizeof(p)))
 				break;
 			err = -ENOENT;
 			vti6_parm_from_user(&p1, &p);
@@ -890,7 +891,7 @@ static const struct net_device_ops vti6_netdev_ops = {
 	.ndo_init	= vti6_dev_init,
 	.ndo_uninit	= vti6_dev_uninit,
 	.ndo_start_xmit = vti6_tnl_xmit,
-	.ndo_do_ioctl	= vti6_ioctl,
+	.ndo_siocdevprivate = vti6_siocdevprivate,
 	.ndo_get_stats64 = dev_get_tstats64,
 	.ndo_get_iflink = ip6_tnl_get_iflink,
 };
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index df5bea818410..5a3729838880 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -299,9 +299,8 @@ __ipip6_tunnel_locate_prl(struct ip_tunnel *t, __be32 addr)
 
 }
 
-static int ipip6_tunnel_get_prl(struct net_device *dev, struct ifreq *ifr)
+static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __user *a)
 {
-	struct ip_tunnel_prl __user *a = ifr->ifr_ifru.ifru_data;
 	struct ip_tunnel *t = netdev_priv(dev);
 	struct ip_tunnel_prl kprl, *kp;
 	struct ip_tunnel_prl_entry *prl;
@@ -453,8 +452,8 @@ ipip6_tunnel_del_prl(struct ip_tunnel *t, struct ip_tunnel_prl *a)
 	return err;
 }
 
-static int ipip6_tunnel_prl_ctl(struct net_device *dev, struct ifreq *ifr,
-		int cmd)
+static int ipip6_tunnel_prl_ctl(struct net_device *dev,
+				struct ip_tunnel_prl __user *data, int cmd)
 {
 	struct ip_tunnel *t = netdev_priv(dev);
 	struct ip_tunnel_prl prl;
@@ -465,7 +464,7 @@ static int ipip6_tunnel_prl_ctl(struct net_device *dev, struct ifreq *ifr,
 	if (dev == dev_to_sit_net(dev)->fb_tunnel_dev)
 		return -EINVAL;
 
-	if (copy_from_user(&prl, ifr->ifr_ifru.ifru_data, sizeof(prl)))
+	if (copy_from_user(&prl, data, sizeof(prl)))
 		return -EFAULT;
 
 	switch (cmd) {
@@ -1197,14 +1196,14 @@ static int ipip6_tunnel_update_6rd(struct ip_tunnel *t,
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
@@ -1215,13 +1214,14 @@ ipip6_tunnel_get6rd(struct net_device *dev, struct ifreq *ifr)
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
@@ -1229,7 +1229,7 @@ ipip6_tunnel_6rdctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 	if (!ns_capable(t->net->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
-	if (copy_from_user(&ip6rd, ifr->ifr_ifru.ifru_data, sizeof(ip6rd)))
+	if (copy_from_user(&ip6rd, data, sizeof(ip6rd)))
 		return -EFAULT;
 
 	if (cmd != SIOCDEL6RD) {
@@ -1368,27 +1368,28 @@ ipip6_tunnel_ctl(struct net_device *dev, struct ip_tunnel_parm *p, int cmd)
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
@@ -1399,7 +1400,7 @@ static const struct net_device_ops ipip6_netdev_ops = {
 	.ndo_init	= ipip6_tunnel_init,
 	.ndo_uninit	= ipip6_tunnel_uninit,
 	.ndo_start_xmit	= sit_tunnel_xmit,
-	.ndo_do_ioctl	= ipip6_tunnel_ioctl,
+	.ndo_siocdevprivate = ipip6_tunnel_siocdevprivate,
 	.ndo_get_stats64 = dev_get_tstats64,
 	.ndo_get_iflink = ip_tunnel_get_iflink,
 	.ndo_tunnel_ctl = ipip6_tunnel_ctl,
-- 
2.29.2

