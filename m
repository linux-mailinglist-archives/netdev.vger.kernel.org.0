Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95031D96FA
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbgESNED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728954AbgESNEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:04:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C6AC08C5C4;
        Tue, 19 May 2020 06:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=RjxiJywqJojajkQHo5ctJXUjgepAaAnx5XtlttT7D94=; b=o1x4fSlQCZi+V++zGwl1kfXPN5
        SzACjpzA0QeCobSM+iONMAKqCdCLyr8UFjaUKxCFtuNHcelBdUufoMqX1mheFlSDz5aRvxaD+6ltv
        PkLR0yVehkwudM746g7XUaeh72lwy7QcZ6Uaslqvs4cUjBgROvyfWrPLdrumLtM4Wxa8YRyktVvqq
        ImeRIRTGDIN8tbPZHSFQxPKlbZvtNKlZPlIrqJ2joaLNE9fc2Pogy8oB/dXTxQSPyTsAks8mCFn96
        AC/yzWRXaWiTskiQK4/M9YCegIOfx/eYMc9CA5ibtPtOzBZnFqMmHXrYTWTmjiVi/om0vBlfDH2FW
        3QiBKrXw==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jb1uE-00048D-Ez; Tue, 19 May 2020 13:03:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] sit: impement ->ndo_tunnel_ctl
Date:   Tue, 19 May 2020 15:03:16 +0200
Message-Id: <20200519130319.1464195-7-hch@lst.de>
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

Implement the ->ndo_tunnel_ctl method, and use ip_tunnel_ioctl to
handle userspace requests for the SIOCGETTUNNEL, SIOCADDTUNNEL,
SIOCCHGTUNNEL and SIOCDELTUNNEL ioctls.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/ipv6/sit.c | 73 +++++++++++++++++++++++---------------------------
 1 file changed, 34 insertions(+), 39 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 7c158fdc02daf..1fbb4dfbb191b 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1267,60 +1267,45 @@ __ipip6_tunnel_ioctl_validate(struct net *net, struct ip_tunnel_parm *p)
 }
 
 static int
-ipip6_tunnel_get(struct net_device *dev, struct ifreq *ifr)
+ipip6_tunnel_get(struct net_device *dev, struct ip_tunnel_parm *p)
 {
 	struct ip_tunnel *t = netdev_priv(dev);
-	struct ip_tunnel_parm p;
 
-	if (dev == dev_to_sit_net(dev)->fb_tunnel_dev) {
-		if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
-			return -EFAULT;
-		t = ipip6_tunnel_locate(t->net, &p, 0);
-	}
+	if (dev == dev_to_sit_net(dev)->fb_tunnel_dev)
+		t = ipip6_tunnel_locate(t->net, p, 0);
 	if (!t)
 		t = netdev_priv(dev);
-
-	if (copy_to_user(ifr->ifr_ifru.ifru_data, &t->parms, sizeof(p)))
-		return -EFAULT;
+	memcpy(p, &t->parms, sizeof(*p));
 	return 0;
 }
 
 static int
-ipip6_tunnel_add(struct net_device *dev, struct ifreq *ifr)
+ipip6_tunnel_add(struct net_device *dev, struct ip_tunnel_parm *p)
 {
 	struct ip_tunnel *t = netdev_priv(dev);
-	struct ip_tunnel_parm p;
 	int err;
 
-	if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
-		return -EFAULT;
-	err = __ipip6_tunnel_ioctl_validate(t->net, &p);
+	err = __ipip6_tunnel_ioctl_validate(t->net, p);
 	if (err)
 		return err;
 
-	t = ipip6_tunnel_locate(t->net, &p, 1);
+	t = ipip6_tunnel_locate(t->net, p, 1);
 	if (!t)
 		return -ENOBUFS;
-
-	if (copy_to_user(ifr->ifr_ifru.ifru_data, &t->parms, sizeof(p)))
-		return -EFAULT;
 	return 0;
 }
 
 static int
-ipip6_tunnel_change(struct net_device *dev, struct ifreq *ifr)
+ipip6_tunnel_change(struct net_device *dev, struct ip_tunnel_parm *p)
 {
 	struct ip_tunnel *t = netdev_priv(dev);
-	struct ip_tunnel_parm p;
 	int err;
 
-	if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
-		return -EFAULT;
-	err = __ipip6_tunnel_ioctl_validate(t->net, &p);
+	err = __ipip6_tunnel_ioctl_validate(t->net, p);
 	if (err)
 		return err;
 
-	t = ipip6_tunnel_locate(t->net, &p, 0);
+	t = ipip6_tunnel_locate(t->net, p, 0);
 	if (dev == dev_to_sit_net(dev)->fb_tunnel_dev) {
 		if (!t)
 			return -ENOENT;
@@ -1329,33 +1314,28 @@ ipip6_tunnel_change(struct net_device *dev, struct ifreq *ifr)
 			if (t->dev != dev)
 				return -EEXIST;
 		} else {
-			if (((dev->flags & IFF_POINTOPOINT) && !p.iph.daddr) ||
-			    (!(dev->flags & IFF_POINTOPOINT) && p.iph.daddr))
+			if (((dev->flags & IFF_POINTOPOINT) && !p->iph.daddr) ||
+			    (!(dev->flags & IFF_POINTOPOINT) && p->iph.daddr))
 				return -EINVAL;
 			t = netdev_priv(dev);
 		}
 
-		ipip6_tunnel_update(t, &p, t->fwmark);
+		ipip6_tunnel_update(t, p, t->fwmark);
 	}
 
-	if (copy_to_user(ifr->ifr_ifru.ifru_data, &t->parms, sizeof(p)))
-		return -EFAULT;
 	return 0;
 }
 
 static int
-ipip6_tunnel_del(struct net_device *dev, struct ifreq *ifr)
+ipip6_tunnel_del(struct net_device *dev, struct ip_tunnel_parm *p)
 {
 	struct ip_tunnel *t = netdev_priv(dev);
-	struct ip_tunnel_parm p;
 
 	if (!ns_capable(t->net->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	if (dev == dev_to_sit_net(dev)->fb_tunnel_dev) {
-		if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
-			return -EFAULT;
-		t = ipip6_tunnel_locate(t->net, &p, 0);
+		t = ipip6_tunnel_locate(t->net, p, 0);
 		if (!t)
 			return -ENOENT;
 		if (t == netdev_priv(dev_to_sit_net(dev)->fb_tunnel_dev))
@@ -1366,18 +1346,32 @@ ipip6_tunnel_del(struct net_device *dev, struct ifreq *ifr)
 	return 0;
 }
 
+static int
+ipip6_tunnel_ctl(struct net_device *dev, struct ip_tunnel_parm *p, int cmd)
+{
+	switch (cmd) {
+	case SIOCGETTUNNEL:
+		return ipip6_tunnel_get(dev, p);
+	case SIOCADDTUNNEL:
+		return ipip6_tunnel_add(dev, p);
+	case SIOCCHGTUNNEL:
+		return ipip6_tunnel_change(dev, p);
+	case SIOCDELTUNNEL:
+		return ipip6_tunnel_del(dev, p);
+	default:
+		return -EINVAL;
+	}
+}
+
 static int
 ipip6_tunnel_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	switch (cmd) {
 	case SIOCGETTUNNEL:
-		return ipip6_tunnel_get(dev, ifr);
 	case SIOCADDTUNNEL:
-		return ipip6_tunnel_add(dev, ifr);
 	case SIOCCHGTUNNEL:
-		return ipip6_tunnel_change(dev, ifr);
 	case SIOCDELTUNNEL:
-		return ipip6_tunnel_del(dev, ifr);
+		return ip_tunnel_ioctl(dev, ifr, cmd);
 	case SIOCGETPRL:
 		return ipip6_tunnel_get_prl(dev, ifr);
 	case SIOCADDPRL:
@@ -1404,6 +1398,7 @@ static const struct net_device_ops ipip6_netdev_ops = {
 	.ndo_do_ioctl	= ipip6_tunnel_ioctl,
 	.ndo_get_stats64 = ip_tunnel_get_stats64,
 	.ndo_get_iflink = ip_tunnel_get_iflink,
+	.ndo_tunnel_ctl = ipip6_tunnel_ctl,
 };
 
 static void ipip6_dev_free(struct net_device *dev)
-- 
2.26.2

