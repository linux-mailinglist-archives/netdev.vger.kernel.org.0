Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9AA1D3387
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 16:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgENOvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 10:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727930AbgENOvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 10:51:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2D8C061A0C;
        Thu, 14 May 2020 07:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=9aeupGr/vYCGhcnA5BL5/A+kju2wf0xeZ9G4QPK75kk=; b=OtJCogSSSaiBxkBNZ4yJOfrXZU
        dI9zMSPuNJmV+rSZltYlRcxDsXi3GjXO461DNt6dNJFuj5gHnDjgn2nR0evlkSKB3/S9FQ1H9mw/3
        QtZygveZZFW4IcvmDV5KKrGqK9l/6U6VdTTvQP+IVF5V8N7UGd3EMRRmtMejKvmi/mnGnNpiSr3XR
        jTy3jDb3B3E3wVeYCMufyF50QqUdbhVvTMu52TISn8gQvwGOH5dky+bkQpgTiOwqEIFZULZ6LRJYi
        Ut3GVAmeVUc5y8WUYxrURS402agSCAc2b776F9poc51HkMJ3pFjsO1DjIi+P1IywafvANtmlnUer9
        0dOdyRpA==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jZFCU-0007sz-Li; Thu, 14 May 2020 14:51:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] ipv4: streamline ipmr_new_tunnel
Date:   Thu, 14 May 2020 16:50:58 +0200
Message-Id: <20200514145101.3000612-2-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514145101.3000612-1-hch@lst.de>
References: <20200514145101.3000612-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reduce a few level of indentation to simplify the function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/ipv4/ipmr.c | 73 ++++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 37 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 9cf83cc85e4ad..84541c601cfab 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -469,50 +469,49 @@ static bool ipmr_init_vif_indev(const struct net_device *dev)
 
 static struct net_device *ipmr_new_tunnel(struct net *net, struct vifctl *v)
 {
-	struct net_device  *dev;
+	mm_segment_t oldfs = get_fs();
+	struct net_device *tunnel_dev, *new_dev;
+	struct ip_tunnel_parm p = { };
+	struct ifreq ifr;
+	int err;
 
-	dev = __dev_get_by_name(net, "tunl0");
+	tunnel_dev = __dev_get_by_name(net, "tunl0");
+	if (!tunnel_dev)
+		goto out;
 
-	if (dev) {
-		const struct net_device_ops *ops = dev->netdev_ops;
-		int err;
-		struct ifreq ifr;
-		struct ip_tunnel_parm p;
+	p.iph.daddr = v->vifc_rmt_addr.s_addr;
+	p.iph.saddr = v->vifc_lcl_addr.s_addr;
+	p.iph.version = 4;
+	p.iph.ihl = 5;
+	p.iph.protocol = IPPROTO_IPIP;
+	sprintf(p.name, "dvmrp%d", v->vifc_vifi);
+	ifr.ifr_ifru.ifru_data = (__force void __user *)&p;
 
-		memset(&p, 0, sizeof(p));
-		p.iph.daddr = v->vifc_rmt_addr.s_addr;
-		p.iph.saddr = v->vifc_lcl_addr.s_addr;
-		p.iph.version = 4;
-		p.iph.ihl = 5;
-		p.iph.protocol = IPPROTO_IPIP;
-		sprintf(p.name, "dvmrp%d", v->vifc_vifi);
-		ifr.ifr_ifru.ifru_data = (__force void __user *)&p;
+	if (!tunnel_dev->netdev_ops->ndo_do_ioctl)
+		goto out;
 
-		if (ops->ndo_do_ioctl) {
-			mm_segment_t oldfs = get_fs();
+	set_fs(KERNEL_DS);
+	err = tunnel_dev->netdev_ops->ndo_do_ioctl(tunnel_dev, &ifr,
+			SIOCADDTUNNEL);
+	set_fs(oldfs);
+	if (err)
+		goto out;
 
-			set_fs(KERNEL_DS);
-			err = ops->ndo_do_ioctl(dev, &ifr, SIOCADDTUNNEL);
-			set_fs(oldfs);
-		} else {
-			err = -EOPNOTSUPP;
-		}
-		dev = NULL;
+	new_dev = __dev_get_by_name(net, p.name);
+	if (!new_dev)
+		goto out;
 
-		if (err == 0 &&
-		    (dev = __dev_get_by_name(net, p.name)) != NULL) {
-			dev->flags |= IFF_MULTICAST;
-			if (!ipmr_init_vif_indev(dev))
-				goto failure;
-			if (dev_open(dev, NULL))
-				goto failure;
-			dev_hold(dev);
-		}
-	}
-	return dev;
+	new_dev->flags |= IFF_MULTICAST;
+	if (!ipmr_init_vif_indev(new_dev))
+		goto out_unregister;
+	if (dev_open(new_dev, NULL))
+		goto out_unregister;
+	dev_hold(new_dev);
+	return new_dev;
 
-failure:
-	unregister_netdevice(dev);
+out_unregister:
+	unregister_netdevice(new_dev);
+out:
 	return NULL;
 }
 
-- 
2.26.2

