Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2AC1D77BA
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 13:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgERLrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 07:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbgERLrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 07:47:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F29C05BD09;
        Mon, 18 May 2020 04:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=6MCEXCuyQ19zofaOQkoasXyj8+vdtyHO059Nwuls9kQ=; b=YWaIC1jSxLFmVUgP8VzngFKSka
        4Ume2ZHHUVUKxG4/P/m4UzRlZrZtDCCvHTlaWU9T1HCahZPDFhIhc1V4psuJVoC+7vF9o6PETi7Se
        l3ixZ0SgToQrazDhPS4U3/RjeCxSgxmGFZ1ZXrvc7EGV9FTcR0UnTtMALSho/XDl1xF9GGsj66/7K
        3klRhofRJTG9Nq4nXVn+dmDeqya20XraqzI0IMHK5ZVMURysBN5u3EwKWcj2YrnLqSbdlM9Wh8gFy
        IZ4rSfopcuNP9H4+bm319HKigKysJEWI/gNATquWBSMVo68aP61+iVYVNsF2UHV+XrQSRK7nCYd6m
        ndiiV27g==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaeEW-0004NS-Uw; Mon, 18 May 2020 11:47:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] ipv4: streamline ipmr_new_tunnel
Date:   Mon, 18 May 2020 13:46:47 +0200
Message-Id: <20200518114655.987760-2-hch@lst.de>
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

