Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26811D9710
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbgESNEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729012AbgESNEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:04:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD9CC08C5C0;
        Tue, 19 May 2020 06:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=6MCEXCuyQ19zofaOQkoasXyj8+vdtyHO059Nwuls9kQ=; b=pVRYa8P8bX4OourdMSFgaj7CfH
        wgfdDRSNF7nE8bZxTmLI9WZgwFUM/XdyNezoZ6V8IeYKOF1agYGFL2noI7uIsXgYfEchMI4DPi9k3
        Osek2/27/3Xk961xDr+JEdKPb9l5dIC7UpJA9SjqFmoMh7gcQGPf5U/j1UcIuk40voPpVMLET5K7A
        BwR7LtGblzn/2DMlUv7H45CmsdT6Fum5i2vSQbBaZ1eAJg6kGPbTvioqqVJ2LE2qf1byNQdOOoYiA
        q76K9h79hYxc8bBgeckfksEOFJlaA+pxBHxBwX2nVq3B3eySKs1Kps/7q1+NFepHh+3FZWofl36Pg
        ZLOL9YTg==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jb1u0-0003xC-Ev; Tue, 19 May 2020 13:03:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] ipv4: streamline ipmr_new_tunnel
Date:   Tue, 19 May 2020 15:03:11 +0200
Message-Id: <20200519130319.1464195-2-hch@lst.de>
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

Reduce a few level of indentation to simplify the function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/ipv4/ipmr.c | 73 ++++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 37 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 5c218db2dede7..a1169b6941134 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -471,50 +471,49 @@ static bool ipmr_init_vif_indev(const struct net_device *dev)
 
 static struct net_device *ipmr_new_tunnel(struct net *net, struct vifctl *v)
 {
-	struct net_device  *dev;
+	struct net_device *tunnel_dev, *new_dev;
+	struct ip_tunnel_parm p = { };
+	mm_segment_t oldfs = get_fs();
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

