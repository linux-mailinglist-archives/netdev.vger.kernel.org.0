Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8761E1D77A5
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 13:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgERLrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 07:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727819AbgERLrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 07:47:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1444DC061A0C;
        Mon, 18 May 2020 04:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=JG7cNiOgg/hOsSQsUkokoKWvOJSFrvY/RNWtLfUXGZQ=; b=UM18kLTSzzFp+TWzF+wIPvs+nf
        bnQKAuW8KPZqQU2pND7jp0dZtomllJET/dic2qLX0XMloKz9N62tFIQEATuIbMjPy/ATEle1WiJcL
        w/QoUT74YnZhCGRwrDaDQIc23mVT1JtK3KkDzzkgEMS7O2PR0VAi0zDRFhZqnG49xCgUWGKevh4bl
        nkG8CXmxjmeCGox3SeD+2STwkLeiomweQRk0KpKvJc6ZKOPuW+YREcelKjp9qzNcpvzG+vjTVnwgC
        FVzYgs0TvLJpXwZrPgRjpfzUrm3QJy2MdM3RJXftD+/UKMZG5VG7YKLpoVBAzhfejuGuR33Rztzzb
        xbkz1HPQ==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaeEj-0004Op-LZ; Mon, 18 May 2020 11:47:14 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] sit: impement ->ndo_tunnel_ctl
Date:   Mon, 18 May 2020 13:46:52 +0200
Message-Id: <20200518114655.987760-7-hch@lst.de>
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

Implement the ->ndo_tunnel_ctl method, and use ip_tunnel_ioctl to
handle userspace requests for the SIOCGETTUNNEL, SIOCADDTUNNEL,
SIOCCHGTUNNEL and SIOCDELTUNNEL ioctls.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/ipv6/sit.c | 73 +++++++++++++++++++++++---------------------------
 1 file changed, 34 insertions(+), 39 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 2909b2c53eaad..8a08e4c4ebbbb 100644
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

