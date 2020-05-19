Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CE41D970F
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbgESNEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728954AbgESNEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:04:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92715C08C5C2;
        Tue, 19 May 2020 06:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=EkXzTLPOr+6GnzCHQiliWbXKTGGj3a80vBWO+YwLdEQ=; b=AyXoTJt+DmxTh5K68HCGpvVMTy
        DnjJ0lbPKNU29fJc3Ipmix0KnMQXhJAt+iEyn67iDQBUC/VP7HAxEm4/l7XF+tTJduVx0ukvHTRyf
        hPBV804iU4VdKm6bZKYxeoUs1Ko5XvXeidpdJR7vWJI8AAfiFkn5h+EAaLe+zsXbzuy5q4M2vWfzc
        a33gl49D7qcohGm8NQGiK+a01qguYIYle/T5rcwBNu4hAJJ1Z6Yfz/l7iXJIrNYB6x9JLTHSs7PpP
        CVsqgib6u/iL4EQCfFA/71l+x3Gt8wcRNuFb5Eykjyqf4gi4/AcXGaMW7JXWlKyMlxGPWnJ0YL8ze
        1K+NGXbw==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jb1u6-000428-6A; Tue, 19 May 2020 13:03:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] net: add a new ndo_tunnel_ioctl method
Date:   Tue, 19 May 2020 15:03:13 +0200
Message-Id: <20200519130319.1464195-4-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200519130319.1464195-1-hch@lst.de>
References: <20200519130319.1464195-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This method is used to properly allow kernel callers of the IPv4 route
management ioctls.  The exsting ip_tunnel_ioctl helper is renamed to
ip_tunnel_ctl to better reflect that it doesn't directly implement ioctls
touching user memory, and is used for the guts of ndo_tunnel_ctl
implementations. A new ip_tunnel_ioctl helper is added that can be wired
up directly to the ndo_do_ioctl method and takes care of the copy to and
from userspace.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/netdevice.h |  6 ++++++
 include/net/ip_tunnels.h  |  3 ++-
 net/ipv4/ip_gre.c         | 35 ++++++++++++++---------------------
 net/ipv4/ip_tunnel.c      | 16 +++++++++++++++-
 net/ipv4/ip_vti.c         | 32 +++++++++++++-------------------
 net/ipv4/ipip.c           | 30 +++++++++---------------------
 6 files changed, 59 insertions(+), 63 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6a8f8daef09df..a18f8fdf4260a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -53,6 +53,7 @@ struct netpoll_info;
 struct device;
 struct phy_device;
 struct dsa_port;
+struct ip_tunnel_parm;
 struct macsec_context;
 struct macsec_ops;
 
@@ -1274,6 +1275,9 @@ struct netdev_net_notifier {
  *	Get devlink port instance associated with a given netdev.
  *	Called with a reference on the netdevice and devlink locks only,
  *	rtnl_lock is not held.
+ * int (*ndo_tunnel_ctl)(struct net_device *dev, struct ip_tunnel_parm *p,
+ *			 int cmd);
+ *	Add, change, delete or get information on an IPv4 tunnel.
  */
 struct net_device_ops {
 	int			(*ndo_init)(struct net_device *dev);
@@ -1479,6 +1483,8 @@ struct net_device_ops {
 	int			(*ndo_xsk_wakeup)(struct net_device *dev,
 						  u32 queue_id, u32 flags);
 	struct devlink_port *	(*ndo_get_devlink_port)(struct net_device *dev);
+	int			(*ndo_tunnel_ctl)(struct net_device *dev,
+						  struct ip_tunnel_parm *p, int cmd);
 };
 
 /**
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 236503a50759a..076e5d7db7d3c 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -269,7 +269,8 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 		    const struct iphdr *tnl_params, const u8 protocol);
 void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 		       const u8 proto, int tunnel_hlen);
-int ip_tunnel_ioctl(struct net_device *dev, struct ip_tunnel_parm *p, int cmd);
+int ip_tunnel_ctl(struct net_device *dev, struct ip_tunnel_parm *p, int cmd);
+int ip_tunnel_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
 int __ip_tunnel_change_mtu(struct net_device *dev, int new_mtu, bool strict);
 int ip_tunnel_change_mtu(struct net_device *dev, int new_mtu);
 
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 0ce9b91ff55c0..4e31f23e4117e 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -768,45 +768,37 @@ static void ipgre_link_update(struct net_device *dev, bool set_mtu)
 	}
 }
 
-static int ipgre_tunnel_ioctl(struct net_device *dev,
-			      struct ifreq *ifr, int cmd)
+static int ipgre_tunnel_ctl(struct net_device *dev, struct ip_tunnel_parm *p,
+			    int cmd)
 {
-	struct ip_tunnel_parm p;
 	int err;
 
-	if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
-		return -EFAULT;
-
 	if (cmd == SIOCADDTUNNEL || cmd == SIOCCHGTUNNEL) {
-		if (p.iph.version != 4 || p.iph.protocol != IPPROTO_GRE ||
-		    p.iph.ihl != 5 || (p.iph.frag_off & htons(~IP_DF)) ||
-		    ((p.i_flags | p.o_flags) & (GRE_VERSION | GRE_ROUTING)))
+		if (p->iph.version != 4 || p->iph.protocol != IPPROTO_GRE ||
+		    p->iph.ihl != 5 || (p->iph.frag_off & htons(~IP_DF)) ||
+		    ((p->i_flags | p->o_flags) & (GRE_VERSION | GRE_ROUTING)))
 			return -EINVAL;
 	}
 
-	p.i_flags = gre_flags_to_tnl_flags(p.i_flags);
-	p.o_flags = gre_flags_to_tnl_flags(p.o_flags);
+	p->i_flags = gre_flags_to_tnl_flags(p->i_flags);
+	p->o_flags = gre_flags_to_tnl_flags(p->o_flags);
 
-	err = ip_tunnel_ioctl(dev, &p, cmd);
+	err = ip_tunnel_ctl(dev, p, cmd);
 	if (err)
 		return err;
 
 	if (cmd == SIOCCHGTUNNEL) {
 		struct ip_tunnel *t = netdev_priv(dev);
 
-		t->parms.i_flags = p.i_flags;
-		t->parms.o_flags = p.o_flags;
+		t->parms.i_flags = p->i_flags;
+		t->parms.o_flags = p->o_flags;
 
 		if (strcmp(dev->rtnl_link_ops->kind, "erspan"))
 			ipgre_link_update(dev, true);
 	}
 
-	p.i_flags = gre_tnl_flags_to_gre_flags(p.i_flags);
-	p.o_flags = gre_tnl_flags_to_gre_flags(p.o_flags);
-
-	if (copy_to_user(ifr->ifr_ifru.ifru_data, &p, sizeof(p)))
-		return -EFAULT;
-
+	p->i_flags = gre_tnl_flags_to_gre_flags(p->i_flags);
+	p->o_flags = gre_tnl_flags_to_gre_flags(p->o_flags);
 	return 0;
 }
 
@@ -924,10 +916,11 @@ static const struct net_device_ops ipgre_netdev_ops = {
 	.ndo_stop		= ipgre_close,
 #endif
 	.ndo_start_xmit		= ipgre_xmit,
-	.ndo_do_ioctl		= ipgre_tunnel_ioctl,
+	.ndo_do_ioctl		= ip_tunnel_ioctl,
 	.ndo_change_mtu		= ip_tunnel_change_mtu,
 	.ndo_get_stats64	= ip_tunnel_get_stats64,
 	.ndo_get_iflink		= ip_tunnel_get_iflink,
+	.ndo_tunnel_ctl		= ipgre_tunnel_ctl,
 };
 
 #define GRE_FEATURES (NETIF_F_SG |		\
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index cd4b84310d929..f4f1d11eab502 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -860,7 +860,7 @@ static void ip_tunnel_update(struct ip_tunnel_net *itn,
 	netdev_state_change(dev);
 }
 
-int ip_tunnel_ioctl(struct net_device *dev, struct ip_tunnel_parm *p, int cmd)
+int ip_tunnel_ctl(struct net_device *dev, struct ip_tunnel_parm *p, int cmd)
 {
 	int err = 0;
 	struct ip_tunnel *t = netdev_priv(dev);
@@ -960,6 +960,20 @@ int ip_tunnel_ioctl(struct net_device *dev, struct ip_tunnel_parm *p, int cmd)
 done:
 	return err;
 }
+EXPORT_SYMBOL_GPL(ip_tunnel_ctl);
+
+int ip_tunnel_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	struct ip_tunnel_parm p;
+	int err;
+
+	if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
+		return -EFAULT;
+	err = dev->netdev_ops->ndo_tunnel_ctl(dev, &p, cmd);
+	if (!err && copy_to_user(ifr->ifr_ifru.ifru_data, &p, sizeof(p)))
+		return -EFAULT;
+	return err;
+}
 EXPORT_SYMBOL_GPL(ip_tunnel_ioctl);
 
 int __ip_tunnel_change_mtu(struct net_device *dev, int new_mtu, bool strict)
diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 1b4e6f298648d..c8974360a99f4 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -378,38 +378,31 @@ static int vti4_err(struct sk_buff *skb, u32 info)
 }
 
 static int
-vti_tunnel_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+vti_tunnel_ctl(struct net_device *dev, struct ip_tunnel_parm *p, int cmd)
 {
 	int err = 0;
-	struct ip_tunnel_parm p;
-
-	if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
-		return -EFAULT;
 
 	if (cmd == SIOCADDTUNNEL || cmd == SIOCCHGTUNNEL) {
-		if (p.iph.version != 4 || p.iph.protocol != IPPROTO_IPIP ||
-		    p.iph.ihl != 5)
+		if (p->iph.version != 4 || p->iph.protocol != IPPROTO_IPIP ||
+		    p->iph.ihl != 5)
 			return -EINVAL;
 	}
 
-	if (!(p.i_flags & GRE_KEY))
-		p.i_key = 0;
-	if (!(p.o_flags & GRE_KEY))
-		p.o_key = 0;
+	if (!(p->i_flags & GRE_KEY))
+		p->i_key = 0;
+	if (!(p->o_flags & GRE_KEY))
+		p->o_key = 0;
 
-	p.i_flags = VTI_ISVTI;
+	p->i_flags = VTI_ISVTI;
 
-	err = ip_tunnel_ioctl(dev, &p, cmd);
+	err = ip_tunnel_ctl(dev, p, cmd);
 	if (err)
 		return err;
 
 	if (cmd != SIOCDELTUNNEL) {
-		p.i_flags |= GRE_KEY;
-		p.o_flags |= GRE_KEY;
+		p->i_flags |= GRE_KEY;
+		p->o_flags |= GRE_KEY;
 	}
-
-	if (copy_to_user(ifr->ifr_ifru.ifru_data, &p, sizeof(p)))
-		return -EFAULT;
 	return 0;
 }
 
@@ -417,10 +410,11 @@ static const struct net_device_ops vti_netdev_ops = {
 	.ndo_init	= vti_tunnel_init,
 	.ndo_uninit	= ip_tunnel_uninit,
 	.ndo_start_xmit	= vti_tunnel_xmit,
-	.ndo_do_ioctl	= vti_tunnel_ioctl,
+	.ndo_do_ioctl	= ip_tunnel_ioctl,
 	.ndo_change_mtu	= ip_tunnel_change_mtu,
 	.ndo_get_stats64 = ip_tunnel_get_stats64,
 	.ndo_get_iflink = ip_tunnel_get_iflink,
+	.ndo_tunnel_ctl	= vti_tunnel_ctl,
 };
 
 static void vti_tunnel_setup(struct net_device *dev)
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 2f01cf6fa0def..df663baf2516a 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -327,41 +327,29 @@ static bool ipip_tunnel_ioctl_verify_protocol(u8 ipproto)
 }
 
 static int
-ipip_tunnel_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+ipip_tunnel_ctl(struct net_device *dev, struct ip_tunnel_parm *p, int cmd)
 {
-	int err = 0;
-	struct ip_tunnel_parm p;
-
-	if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
-		return -EFAULT;
-
 	if (cmd == SIOCADDTUNNEL || cmd == SIOCCHGTUNNEL) {
-		if (p.iph.version != 4 ||
-		    !ipip_tunnel_ioctl_verify_protocol(p.iph.protocol) ||
-		    p.iph.ihl != 5 || (p.iph.frag_off&htons(~IP_DF)))
+		if (p->iph.version != 4 ||
+		    !ipip_tunnel_ioctl_verify_protocol(p->iph.protocol) ||
+		    p->iph.ihl != 5 || (p->iph.frag_off & htons(~IP_DF)))
 			return -EINVAL;
 	}
 
-	p.i_key = p.o_key = 0;
-	p.i_flags = p.o_flags = 0;
-	err = ip_tunnel_ioctl(dev, &p, cmd);
-	if (err)
-		return err;
-
-	if (copy_to_user(ifr->ifr_ifru.ifru_data, &p, sizeof(p)))
-		return -EFAULT;
-
-	return 0;
+	p->i_key = p->o_key = 0;
+	p->i_flags = p->o_flags = 0;
+	return ip_tunnel_ctl(dev, p, cmd);
 }
 
 static const struct net_device_ops ipip_netdev_ops = {
 	.ndo_init       = ipip_tunnel_init,
 	.ndo_uninit     = ip_tunnel_uninit,
 	.ndo_start_xmit	= ipip_tunnel_xmit,
-	.ndo_do_ioctl	= ipip_tunnel_ioctl,
+	.ndo_do_ioctl	= ip_tunnel_ioctl,
 	.ndo_change_mtu = ip_tunnel_change_mtu,
 	.ndo_get_stats64 = ip_tunnel_get_stats64,
 	.ndo_get_iflink = ip_tunnel_get_iflink,
+	.ndo_tunnel_ctl	= ipip_tunnel_ctl,
 };
 
 #define IPIP_FEATURES (NETIF_F_SG |		\
-- 
2.26.2

