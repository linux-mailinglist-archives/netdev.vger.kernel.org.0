Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8F91D77B3
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 13:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgERLr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 07:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727981AbgERLrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 07:47:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB4AC061A0C;
        Mon, 18 May 2020 04:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=vbZ3Gk3U+uf9dFZUpTloiSgwD+BngwLojurLSGg3KgY=; b=fKEIar/65McHGvCOqw7+0riAkY
        x0Yv2OX3nt1H76Riz+J+hemJFksyKj3N2DDTn2h9qCWWRZE2jdQEqM+EPjnTKp8BxG552nYsZfi/H
        f5qlLEMaVEhW6/KpdYnJkNg6s1W4NBQHylarcMiJs5lW3yWECWdK16KzR3cAx8s9L9twYl1PCu36H
        He6MoFfkkxYZSn7qTfYnVteIBB2zShc9C9qQOrhVlE2c1aRKgyy+d5bnojbBUFISW553mIYUfwsbt
        8BoDYZ9eS4b9/dhBCS/lAj/CQCS88NkSuMxoQGuA1pr21HHMgFPPmdxQ2VeOoCsK4EHEScyDtgB+R
        ul4JotKw==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaeEo-0004Po-Lm; Mon, 18 May 2020 11:47:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] ipv6: streamline addrconf_set_dstaddr
Date:   Mon, 18 May 2020 13:46:54 +0200
Message-Id: <20200518114655.987760-9-hch@lst.de>
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

Factor out a addrconf_set_sit_dstaddr helper for the actual work if we
found a SIT device, and only hold the rtnl lock around the device lookup
and that new helper, as there is no point in holding it over a
copy_from_user call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/ipv6/addrconf.c | 87 ++++++++++++++++++++-------------------------
 1 file changed, 38 insertions(+), 49 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 8300176f91e74..c827edf877414 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2783,6 +2783,38 @@ void addrconf_prefix_rcv(struct net_device *dev, u8 *opt, int len, bool sllao)
 	in6_dev_put(in6_dev);
 }
 
+static int addrconf_set_sit_dstaddr(struct net *net, struct net_device *dev,
+		struct in6_ifreq *ireq)
+{
+	struct ip_tunnel_parm p = { };
+	mm_segment_t oldfs = get_fs();
+	struct ifreq ifr;
+	int err;
+
+	if (!(ipv6_addr_type(&ireq->ifr6_addr) & IPV6_ADDR_COMPATv4))
+		return -EADDRNOTAVAIL;
+
+	p.iph.daddr = ireq->ifr6_addr.s6_addr32[3];
+	p.iph.version = 4;
+	p.iph.ihl = 5;
+	p.iph.protocol = IPPROTO_IPV6;
+	p.iph.ttl = 64;
+	ifr.ifr_ifru.ifru_data = (__force void __user *)&p;
+
+	if (!dev->netdev_ops->ndo_do_ioctl)
+		return -EOPNOTSUPP;
+	set_fs(KERNEL_DS);
+	err = dev->netdev_ops->ndo_do_ioctl(dev, &ifr, SIOCADDTUNNEL);
+	set_fs(oldfs);
+	if (err)
+		return err;
+
+	dev = __dev_get_by_name(net, p.name);
+	if (!dev)
+		return -ENOBUFS;
+	return dev_open(dev, NULL);
+}
+
 /*
  *	Set destination address.
  *	Special case for SIT interfaces where we create a new "virtual"
@@ -2790,62 +2822,19 @@ void addrconf_prefix_rcv(struct net_device *dev, u8 *opt, int len, bool sllao)
  */
 int addrconf_set_dstaddr(struct net *net, void __user *arg)
 {
-	struct in6_ifreq ireq;
 	struct net_device *dev;
-	int err = -EINVAL;
+	struct in6_ifreq ireq;
+	int err = -ENODEV;
 
 	if (!IS_ENABLED(CONFIG_IPV6_SIT))
 		return -ENODEV;
-
-	rtnl_lock();
-
-	err = -EFAULT;
 	if (copy_from_user(&ireq, arg, sizeof(struct in6_ifreq)))
-		goto err_exit;
+		return -EFAULT;
 
+	rtnl_lock();
 	dev = __dev_get_by_index(net, ireq.ifr6_ifindex);
-
-	err = -ENODEV;
-	if (!dev)
-		goto err_exit;
-
-	if (dev->type == ARPHRD_SIT) {
-		const struct net_device_ops *ops = dev->netdev_ops;
-		struct ifreq ifr;
-		struct ip_tunnel_parm p;
-
-		err = -EADDRNOTAVAIL;
-		if (!(ipv6_addr_type(&ireq.ifr6_addr) & IPV6_ADDR_COMPATv4))
-			goto err_exit;
-
-		memset(&p, 0, sizeof(p));
-		p.iph.daddr = ireq.ifr6_addr.s6_addr32[3];
-		p.iph.saddr = 0;
-		p.iph.version = 4;
-		p.iph.ihl = 5;
-		p.iph.protocol = IPPROTO_IPV6;
-		p.iph.ttl = 64;
-		ifr.ifr_ifru.ifru_data = (__force void __user *)&p;
-
-		if (ops->ndo_do_ioctl) {
-			mm_segment_t oldfs = get_fs();
-
-			set_fs(KERNEL_DS);
-			err = ops->ndo_do_ioctl(dev, &ifr, SIOCADDTUNNEL);
-			set_fs(oldfs);
-		} else
-			err = -EOPNOTSUPP;
-
-		if (err == 0) {
-			err = -ENOBUFS;
-			dev = __dev_get_by_name(net, p.name);
-			if (!dev)
-				goto err_exit;
-			err = dev_open(dev, NULL);
-		}
-	}
-
-err_exit:
+	if (dev && dev->type == ARPHRD_SIT)
+		err = addrconf_set_sit_dstaddr(net, dev, &ireq);
 	rtnl_unlock();
 	return err;
 }
-- 
2.26.2

