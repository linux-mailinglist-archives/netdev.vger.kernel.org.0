Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FE01D9707
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgESND6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728821AbgESND4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:03:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7A6C08C5C3;
        Tue, 19 May 2020 06:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=K/zO8lsMaXBqAf5AELefHDXlMaRm3kqITdpQDdOoyHI=; b=VjbqGRrZuhkRtgBLWAlhsB+Nbx
        GiM0vbjz8silwYtjzjT4Ww65OuLAUY612fxVu5pLM/KNgtywkX16SE3ddR6VMVaimIN8/eHpJTzwi
        xkRE8OsTWl8bI9bMm6J7hNEWrKQGCGsBXfvk+QEW27nyhD6NfCdYsTbeskLE8t2HyNNHA9/s6nUyF
        jQ3Iji5a+m8WLJp1J6z9HkVTBLMzfi9fFYnkY7j7YsV1O4SYD8mBTfV7CRAP5VVPHlhyI0AvexiQ+
        a84XEziULx8G1OKx1AeH4E3diF0WewUeRQqrblAukOYF7hiSFEzT+cVTFe0p+DrzCQO2MEXg+FcS6
        sqGDYSSQ==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jb1u8-00043w-U4; Tue, 19 May 2020 13:03:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] impr: use ->ndo_tunnel_ctl in ipmr_new_tunnel
Date:   Tue, 19 May 2020 15:03:14 +0200
Message-Id: <20200519130319.1464195-5-hch@lst.de>
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

Use the new ->ndo_tunnel_ctl instead of overriding the address limit
and using ->ndo_do_ioctl just to do a pointless user copy.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/ipv4/ipmr.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index cd1a3260a99af..d3e9b80a57de2 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -442,8 +442,6 @@ static struct net_device *ipmr_new_tunnel(struct net *net, struct vifctl *v)
 {
 	struct net_device *tunnel_dev, *new_dev;
 	struct ip_tunnel_parm p = { };
-	mm_segment_t oldfs = get_fs();
-	struct ifreq ifr;
 	int err;
 
 	tunnel_dev = __dev_get_by_name(net, "tunl0");
@@ -456,15 +454,11 @@ static struct net_device *ipmr_new_tunnel(struct net *net, struct vifctl *v)
 	p.iph.ihl = 5;
 	p.iph.protocol = IPPROTO_IPIP;
 	sprintf(p.name, "dvmrp%d", v->vifc_vifi);
-	ifr.ifr_ifru.ifru_data = (__force void __user *)&p;
 
-	if (!tunnel_dev->netdev_ops->ndo_do_ioctl)
+	if (!tunnel_dev->netdev_ops->ndo_tunnel_ctl)
 		goto out;
-
-	set_fs(KERNEL_DS);
-	err = tunnel_dev->netdev_ops->ndo_do_ioctl(tunnel_dev, &ifr,
+	err = tunnel_dev->netdev_ops->ndo_tunnel_ctl(tunnel_dev, &p,
 			SIOCADDTUNNEL);
-	set_fs(oldfs);
 	if (err)
 		goto out;
 
@@ -481,10 +475,8 @@ static struct net_device *ipmr_new_tunnel(struct net *net, struct vifctl *v)
 	err = dev_set_allmulti(new_dev, 1);
 	if (err) {
 		dev_close(new_dev);
-		set_fs(KERNEL_DS);
-		tunnel_dev->netdev_ops->ndo_do_ioctl(tunnel_dev, &ifr,
+		tunnel_dev->netdev_ops->ndo_tunnel_ctl(tunnel_dev, &p,
 				SIOCDELTUNNEL);
-		set_fs(oldfs);
 		dev_put(new_dev);
 		new_dev = ERR_PTR(err);
 	}
-- 
2.26.2

