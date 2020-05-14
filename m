Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4184F1D3389
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 16:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgENOvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 10:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgENOvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 10:51:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8780FC061A0C;
        Thu, 14 May 2020 07:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=g3yEEkwwk4Q3j5s04IMTk/eTfXLS0xuwowPPt0s7L98=; b=nplF2gXenKKVcqt+1wEdBUqj7v
        Loe8nt/+DW1iGJ7jhXvkukFBLmvY/rM0giFPOjt3RMSkIIgWuw7OjznSnNWVNLgPcoLHjhqJ9gmSG
        BPKe+Xx/pJHbr6UURqoOlBVJZWFUSpGhfj4Hh8aAILxyXtU/1jufGJzpLyvZCo0hJsML3xE2wmfIi
        kWUXF1h8kfdnF2Rn+pFW5i3+Xsccz8wEXC7H8eCv5dRNNEzlVC6vWCDnzyui6Lp16VtcvfamREUBs
        tmeGi3X6/+LUsCx/kQ4+nokVaKMfQAbovxmAQO2KwUNGY4m+JSc47xyNwJu6+Ai1aVSdotj5Rdd6y
        H0aw5AqQ==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jZFCa-0007uA-PK; Thu, 14 May 2020 14:51:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] ipv4: use symbol_get to access ipip symbols
Date:   Thu, 14 May 2020 16:51:00 +0200
Message-Id: <20200514145101.3000612-4-hch@lst.de>
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

Instead of going through the ioctl handler from kernel space, use
symbol_get to access the ip_tunnel_ioctl directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/ipv4/ipmr.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 6bf2a88abe86e..3780ab694c574 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -438,10 +438,9 @@ static bool ipmr_init_vif_indev(const struct net_device *dev)
 
 static struct net_device *ipmr_new_tunnel(struct net *net, struct vifctl *v)
 {
-	mm_segment_t oldfs = get_fs();
+	int (*tunnel_ctl)(struct net_device *, struct ip_tunnel_parm *, int);
 	struct net_device *tunnel_dev, *new_dev;
 	struct ip_tunnel_parm p = { };
-	struct ifreq ifr;
 	int err;
 
 	tunnel_dev = __dev_get_by_name(net, "tunl0");
@@ -454,21 +453,17 @@ static struct net_device *ipmr_new_tunnel(struct net *net, struct vifctl *v)
 	p.iph.ihl = 5;
 	p.iph.protocol = IPPROTO_IPIP;
 	sprintf(p.name, "dvmrp%d", v->vifc_vifi);
-	ifr.ifr_ifru.ifru_data = (__force void __user *)&p;
 
-	if (!tunnel_dev->netdev_ops->ndo_do_ioctl)
-		goto out;
+	tunnel_ctl = symbol_get(ip_tunnel_ioctl);
+	if (!tunnel_ctl)
+		return ERR_PTR(-ENOBUFS);
 
-	set_fs(KERNEL_DS);
-	err = tunnel_dev->netdev_ops->ndo_do_ioctl(tunnel_dev, &ifr,
-			SIOCADDTUNNEL);
-	set_fs(oldfs);
-	if (err)
-		goto out;
+	if (tunnel_ctl(tunnel_dev, &p, SIOCADDTUNNEL))
+		goto out_symbol_put;
 
 	new_dev = __dev_get_by_name(net, p.name);
 	if (!new_dev)
-		goto out;
+		goto out_symbol_put;
 
 	new_dev->flags |= IFF_MULTICAST;
 	if (!ipmr_init_vif_indev(new_dev))
@@ -479,17 +474,18 @@ static struct net_device *ipmr_new_tunnel(struct net *net, struct vifctl *v)
 	err = dev_set_allmulti(new_dev, 1);
 	if (err) {
 		dev_close(new_dev);
-		set_fs(KERNEL_DS);
-		tunnel_dev->netdev_ops->ndo_do_ioctl(tunnel_dev, &ifr,
-				SIOCDELTUNNEL);
-		set_fs(oldfs);
+		tunnel_ctl(tunnel_dev, &p, SIOCDELTUNNEL);
 		dev_put(new_dev);
 		new_dev = ERR_PTR(err);
 	}
+
+	symbol_put(ip_tunnel_ioctl);
 	return new_dev;
 
 out_unregister:
 	unregister_netdevice(new_dev);
+out_symbol_put:
+	symbol_put(ipmr_new_tunnel);
 out:
 	return ERR_PTR(-ENOBUFS);
 }
-- 
2.26.2

