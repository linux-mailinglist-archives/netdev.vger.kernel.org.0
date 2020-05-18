Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3534C1D77BB
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 13:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgERLsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 07:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbgERLrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 07:47:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6553C061A0C;
        Mon, 18 May 2020 04:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=2mRmuV/P6NMDjmTXAahbjBNAP6s3hEMS+BquwrpwBZI=; b=h385KB8feLqFjOHpTJzq2VCr6O
        dAEaTGUZ5DoegrTLj2rHDn2dV+NxICfR4oJ63oTtSptVP1WO40hXAgEC6/VqVV7DT/n0ONSqfzS4Y
        y5OOfHEcP8eIhQxgXPseGx4Ajmg4tlr6l3VSYy+aj5EW+6UsDiM9kAXzUxnPUm+I3347xMl52gAov
        qgDlzVgCfG20veveGBA1udpBMCE5n08PM6AMZJ9hSYZaYXlUosoOBus+DzNuFa4snYu3ApFKk5/3I
        XyWYCIooryXZJzQrr6ipTjpjl2+Q4CazyST2ewsILDkDFDQDL1GQUsSB9iROWo9btBdCiH08t1U3B
        EU8KSj5g==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaeEh-0004OU-3o; Mon, 18 May 2020 11:47:11 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] sit: refactor ipip6_tunnel_ioctl
Date:   Mon, 18 May 2020 13:46:51 +0200
Message-Id: <20200518114655.987760-6-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518114655.987760-1-hch@lst.de>
References: <20200518114655.987760-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split the ioctl handler into one function per command instead of having
a all the logic sit in one giant switch statement.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/ipv6/sit.c | 368 ++++++++++++++++++++++++++++---------------------
 1 file changed, 210 insertions(+), 158 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 98954830c40ba..2909b2c53eaad 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -83,6 +83,13 @@ struct sit_net {
 	struct net_device *fb_tunnel_dev;
 };
 
+static inline struct sit_net *dev_to_sit_net(struct net_device *dev)
+{
+	struct ip_tunnel *t = netdev_priv(dev);
+
+	return net_generic(t->net, sit_net_id);
+}
+
 /*
  * Must be invoked with rcu_read_lock
  */
@@ -291,14 +298,18 @@ __ipip6_tunnel_locate_prl(struct ip_tunnel *t, __be32 addr)
 
 }
 
-static int ipip6_tunnel_get_prl(struct ip_tunnel *t,
-				struct ip_tunnel_prl __user *a)
+static int ipip6_tunnel_get_prl(struct net_device *dev, struct ifreq *ifr)
 {
+	struct ip_tunnel_prl __user *a = ifr->ifr_ifru.ifru_data;
+	struct ip_tunnel *t = netdev_priv(dev);
 	struct ip_tunnel_prl kprl, *kp;
 	struct ip_tunnel_prl_entry *prl;
 	unsigned int cmax, c = 0, ca, len;
 	int ret = 0;
 
+	if (dev == dev_to_sit_net(dev)->fb_tunnel_dev)
+		return -EINVAL;
+
 	if (copy_from_user(&kprl, a, sizeof(kprl)))
 		return -EFAULT;
 	cmax = kprl.datalen / sizeof(kprl);
@@ -441,6 +452,35 @@ ipip6_tunnel_del_prl(struct ip_tunnel *t, struct ip_tunnel_prl *a)
 	return err;
 }
 
+static int ipip6_tunnel_prl_ctl(struct net_device *dev, struct ifreq *ifr,
+		int cmd)
+{
+	struct ip_tunnel *t = netdev_priv(dev);
+	struct ip_tunnel_prl prl;
+	int err;
+
+	if (!ns_capable(t->net->user_ns, CAP_NET_ADMIN))
+		return -EPERM;
+	if (dev == dev_to_sit_net(dev)->fb_tunnel_dev)
+		return -EINVAL;
+
+	if (copy_from_user(&prl, ifr->ifr_ifru.ifru_data, sizeof(prl)))
+		return -EFAULT;
+
+	switch (cmd) {
+	case SIOCDELPRL:
+		err = ipip6_tunnel_del_prl(t, &prl);
+		break;
+	case SIOCADDPRL:
+	case SIOCCHGPRL:
+		err = ipip6_tunnel_add_prl(t, &prl, cmd == SIOCCHGPRL);
+		break;
+	}
+	dst_cache_reset(&t->dst_cache);
+	netdev_state_change(dev);
+	return 0;
+}
+
 static int
 isatap_chksrc(struct sk_buff *skb, const struct iphdr *iph, struct ip_tunnel *t)
 {
@@ -1151,7 +1191,53 @@ static int ipip6_tunnel_update_6rd(struct ip_tunnel *t,
 	netdev_state_change(t->dev);
 	return 0;
 }
-#endif
+
+static int
+ipip6_tunnel_get6rd(struct net_device *dev, struct ifreq *ifr)
+{
+	struct ip_tunnel *t = netdev_priv(dev);
+	struct ip_tunnel_6rd ip6rd;
+	struct ip_tunnel_parm p;
+
+	if (dev == dev_to_sit_net(dev)->fb_tunnel_dev) {
+		if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
+			return -EFAULT;
+		t = ipip6_tunnel_locate(t->net, &p, 0);
+	}
+	if (!t)
+		t = netdev_priv(dev);
+
+	ip6rd.prefix = t->ip6rd.prefix;
+	ip6rd.relay_prefix = t->ip6rd.relay_prefix;
+	ip6rd.prefixlen = t->ip6rd.prefixlen;
+	ip6rd.relay_prefixlen = t->ip6rd.relay_prefixlen;
+	if (copy_to_user(ifr->ifr_ifru.ifru_data, &ip6rd, sizeof(ip6rd)))
+		return -EFAULT;
+	return 0;
+}
+
+static int
+ipip6_tunnel_6rdctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	struct ip_tunnel *t = netdev_priv(dev);
+	struct ip_tunnel_6rd ip6rd;
+	int err;
+
+	if (!ns_capable(t->net->user_ns, CAP_NET_ADMIN))
+		return -EPERM;
+	if (copy_from_user(&ip6rd, ifr->ifr_ifru.ifru_data, sizeof(ip6rd)))
+		return -EFAULT;
+
+	if (cmd != SIOCDEL6RD) {
+		err = ipip6_tunnel_update_6rd(t, &ip6rd);
+		if (err < 0)
+			return err;
+	} else
+		ipip6_tunnel_clone_6rd(dev, dev_to_sit_net(dev));
+	return 0;
+}
+
+#endif /* CONFIG_IPV6_SIT_6RD */
 
 static bool ipip6_valid_ip_proto(u8 ipproto)
 {
@@ -1164,185 +1250,151 @@ static bool ipip6_valid_ip_proto(u8 ipproto)
 }
 
 static int
-ipip6_tunnel_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+__ipip6_tunnel_ioctl_validate(struct net *net, struct ip_tunnel_parm *p)
 {
-	int err = 0;
+	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		return -EPERM;
+
+	if (!ipip6_valid_ip_proto(p->iph.protocol))
+		return -EINVAL;
+	if (p->iph.version != 4 ||
+	    p->iph.ihl != 5 || (p->iph.frag_off & htons(~IP_DF)))
+		return -EINVAL;
+
+	if (p->iph.ttl)
+		p->iph.frag_off |= htons(IP_DF);
+	return 0;
+}
+
+static int
+ipip6_tunnel_get(struct net_device *dev, struct ifreq *ifr)
+{
+	struct ip_tunnel *t = netdev_priv(dev);
 	struct ip_tunnel_parm p;
-	struct ip_tunnel_prl prl;
+
+	if (dev == dev_to_sit_net(dev)->fb_tunnel_dev) {
+		if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
+			return -EFAULT;
+		t = ipip6_tunnel_locate(t->net, &p, 0);
+	}
+	if (!t)
+		t = netdev_priv(dev);
+
+	if (copy_to_user(ifr->ifr_ifru.ifru_data, &t->parms, sizeof(p)))
+		return -EFAULT;
+	return 0;
+}
+
+static int
+ipip6_tunnel_add(struct net_device *dev, struct ifreq *ifr)
+{
 	struct ip_tunnel *t = netdev_priv(dev);
-	struct net *net = t->net;
-	struct sit_net *sitn = net_generic(net, sit_net_id);
-#ifdef CONFIG_IPV6_SIT_6RD
-	struct ip_tunnel_6rd ip6rd;
-#endif
+	struct ip_tunnel_parm p;
+	int err;
 
-	switch (cmd) {
-	case SIOCGETTUNNEL:
-#ifdef CONFIG_IPV6_SIT_6RD
-	case SIOCGET6RD:
-#endif
-		if (dev == sitn->fb_tunnel_dev) {
-			if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p))) {
-				err = -EFAULT;
-				break;
-			}
-			t = ipip6_tunnel_locate(net, &p, 0);
-			if (!t)
-				t = netdev_priv(dev);
-		}
+	if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
+		return -EFAULT;
+	err = __ipip6_tunnel_ioctl_validate(t->net, &p);
+	if (err)
+		return err;
 
-		err = -EFAULT;
-		if (cmd == SIOCGETTUNNEL) {
-			memcpy(&p, &t->parms, sizeof(p));
-			if (copy_to_user(ifr->ifr_ifru.ifru_data, &p,
-					 sizeof(p)))
-				goto done;
-#ifdef CONFIG_IPV6_SIT_6RD
+	t = ipip6_tunnel_locate(t->net, &p, 1);
+	if (!t)
+		return -ENOBUFS;
+
+	if (copy_to_user(ifr->ifr_ifru.ifru_data, &t->parms, sizeof(p)))
+		return -EFAULT;
+	return 0;
+}
+
+static int
+ipip6_tunnel_change(struct net_device *dev, struct ifreq *ifr)
+{
+	struct ip_tunnel *t = netdev_priv(dev);
+	struct ip_tunnel_parm p;
+	int err;
+
+	if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
+		return -EFAULT;
+	err = __ipip6_tunnel_ioctl_validate(t->net, &p);
+	if (err)
+		return err;
+
+	t = ipip6_tunnel_locate(t->net, &p, 0);
+	if (dev == dev_to_sit_net(dev)->fb_tunnel_dev) {
+		if (!t)
+			return -ENOENT;
+	} else {
+		if (t) {
+			if (t->dev != dev)
+				return -EEXIST;
 		} else {
-			ip6rd.prefix = t->ip6rd.prefix;
-			ip6rd.relay_prefix = t->ip6rd.relay_prefix;
-			ip6rd.prefixlen = t->ip6rd.prefixlen;
-			ip6rd.relay_prefixlen = t->ip6rd.relay_prefixlen;
-			if (copy_to_user(ifr->ifr_ifru.ifru_data, &ip6rd,
-					 sizeof(ip6rd)))
-				goto done;
-#endif
+			if (((dev->flags & IFF_POINTOPOINT) && !p.iph.daddr) ||
+			    (!(dev->flags & IFF_POINTOPOINT) && p.iph.daddr))
+				return -EINVAL;
+			t = netdev_priv(dev);
 		}
-		err = 0;
-		break;
 
-	case SIOCADDTUNNEL:
-	case SIOCCHGTUNNEL:
-		err = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
-			goto done;
+		ipip6_tunnel_update(t, &p, t->fwmark);
+	}
 
-		err = -EFAULT;
-		if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
-			goto done;
-
-		err = -EINVAL;
-		if (!ipip6_valid_ip_proto(p.iph.protocol))
-			goto done;
-		if (p.iph.version != 4 ||
-		    p.iph.ihl != 5 || (p.iph.frag_off&htons(~IP_DF)))
-			goto done;
-		if (p.iph.ttl)
-			p.iph.frag_off |= htons(IP_DF);
-
-		t = ipip6_tunnel_locate(net, &p, cmd == SIOCADDTUNNEL);
-
-		if (dev != sitn->fb_tunnel_dev && cmd == SIOCCHGTUNNEL) {
-			if (t) {
-				if (t->dev != dev) {
-					err = -EEXIST;
-					break;
-				}
-			} else {
-				if (((dev->flags&IFF_POINTOPOINT) && !p.iph.daddr) ||
-				    (!(dev->flags&IFF_POINTOPOINT) && p.iph.daddr)) {
-					err = -EINVAL;
-					break;
-				}
-				t = netdev_priv(dev);
-			}
+	if (copy_to_user(ifr->ifr_ifru.ifru_data, &t->parms, sizeof(p)))
+		return -EFAULT;
+	return 0;
+}
 
-			ipip6_tunnel_update(t, &p, t->fwmark);
-		}
+static int
+ipip6_tunnel_del(struct net_device *dev, struct ifreq *ifr)
+{
+	struct ip_tunnel *t = netdev_priv(dev);
+	struct ip_tunnel_parm p;
 
-		if (t) {
-			err = 0;
-			if (copy_to_user(ifr->ifr_ifru.ifru_data, &t->parms, sizeof(p)))
-				err = -EFAULT;
-		} else
-			err = (cmd == SIOCADDTUNNEL ? -ENOBUFS : -ENOENT);
-		break;
+	if (!ns_capable(t->net->user_ns, CAP_NET_ADMIN))
+		return -EPERM;
 
-	case SIOCDELTUNNEL:
-		err = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
-			goto done;
-
-		if (dev == sitn->fb_tunnel_dev) {
-			err = -EFAULT;
-			if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
-				goto done;
-			err = -ENOENT;
-			t = ipip6_tunnel_locate(net, &p, 0);
-			if (!t)
-				goto done;
-			err = -EPERM;
-			if (t == netdev_priv(sitn->fb_tunnel_dev))
-				goto done;
-			dev = t->dev;
-		}
-		unregister_netdevice(dev);
-		err = 0;
-		break;
+	if (dev == dev_to_sit_net(dev)->fb_tunnel_dev) {
+		if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
+			return -EFAULT;
+		t = ipip6_tunnel_locate(t->net, &p, 0);
+		if (!t)
+			return -ENOENT;
+		if (t == netdev_priv(dev_to_sit_net(dev)->fb_tunnel_dev))
+			return -EPERM;
+		dev = t->dev;
+	}
+	unregister_netdevice(dev);
+	return 0;
+}
 
+static int
+ipip6_tunnel_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	switch (cmd) {
+	case SIOCGETTUNNEL:
+		return ipip6_tunnel_get(dev, ifr);
+	case SIOCADDTUNNEL:
+		return ipip6_tunnel_add(dev, ifr);
+	case SIOCCHGTUNNEL:
+		return ipip6_tunnel_change(dev, ifr);
+	case SIOCDELTUNNEL:
+		return ipip6_tunnel_del(dev, ifr);
 	case SIOCGETPRL:
-		err = -EINVAL;
-		if (dev == sitn->fb_tunnel_dev)
-			goto done;
-		err = ipip6_tunnel_get_prl(t, ifr->ifr_ifru.ifru_data);
-		break;
-
+		return ipip6_tunnel_get_prl(dev, ifr);
 	case SIOCADDPRL:
 	case SIOCDELPRL:
 	case SIOCCHGPRL:
-		err = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
-			goto done;
-		err = -EINVAL;
-		if (dev == sitn->fb_tunnel_dev)
-			goto done;
-		err = -EFAULT;
-		if (copy_from_user(&prl, ifr->ifr_ifru.ifru_data, sizeof(prl)))
-			goto done;
-
-		switch (cmd) {
-		case SIOCDELPRL:
-			err = ipip6_tunnel_del_prl(t, &prl);
-			break;
-		case SIOCADDPRL:
-		case SIOCCHGPRL:
-			err = ipip6_tunnel_add_prl(t, &prl, cmd == SIOCCHGPRL);
-			break;
-		}
-		dst_cache_reset(&t->dst_cache);
-		netdev_state_change(dev);
-		break;
-
+		return ipip6_tunnel_prl_ctl(dev, ifr, cmd);
 #ifdef CONFIG_IPV6_SIT_6RD
+	case SIOCGET6RD:
+		return ipip6_tunnel_get6rd(dev, ifr);
 	case SIOCADD6RD:
 	case SIOCCHG6RD:
 	case SIOCDEL6RD:
-		err = -EPERM;
-		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
-			goto done;
-
-		err = -EFAULT;
-		if (copy_from_user(&ip6rd, ifr->ifr_ifru.ifru_data,
-				   sizeof(ip6rd)))
-			goto done;
-
-		if (cmd != SIOCDEL6RD) {
-			err = ipip6_tunnel_update_6rd(t, &ip6rd);
-			if (err < 0)
-				goto done;
-		} else
-			ipip6_tunnel_clone_6rd(dev, sitn);
-
-		err = 0;
-		break;
+		return ipip6_tunnel_6rdctl(dev, ifr, cmd);
 #endif
-
 	default:
-		err = -EINVAL;
+		return -EINVAL;
 	}
-
-done:
-	return err;
 }
 
 static const struct net_device_ops ipip6_netdev_ops = {
-- 
2.26.2

