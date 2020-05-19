Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0DF1D9705
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbgESND4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728612AbgESNDz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:03:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC03C08C5C3;
        Tue, 19 May 2020 06:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=gEcIlXPDOpnjvuoYXNVQDG0cqiJg1ipM9BnENUoDM9Q=; b=FC/urf85XUhNkvWEarFUJfLYXl
        D0qap657f9owFUlDM1LtU+iPuzbkNh41C2wdmm37ZyKELnsRI+whloZRQNX1Vjzd5CwGwt7AbhrqV
        25Seun/TJmnTbFOePC4umXhonVpPNKudcKP16353gZM83xgTOLw+e9/PbtP7qrjQ+cZCDlYywpoHG
        0Bk9yD061Qpho+z4HpDH3q6V4ewx4ck2EUXzcHPxyVKHdYU1sFrtQlAbZkebjj+dR4wLzcEwI3KcS
        gmMIeA2kmquoJpe+qaHhOIskGXGX1rtK2RqZIDReKjO/5qIs16SxoPneMcogIeNziwwgTJ6NWnRfy
        H8fCXskg==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jb1u3-0003zW-Bo; Tue, 19 May 2020 13:03:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] ipv4: consolidate the VIFF_TUNNEL handling in ipmr_new_tunnel
Date:   Tue, 19 May 2020 15:03:12 +0200
Message-Id: <20200519130319.1464195-3-hch@lst.de>
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

Also move the dev_set_allmulti call and the error handling into the
ioctl helper.  This allows reusing already looked up tunnel_dev pointer
and the set up argument structure for the deletion in the error handler.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/ipv4/ipmr.c | 53 ++++++++++++-------------------------------------
 1 file changed, 13 insertions(+), 40 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index a1169b6941134..cd1a3260a99af 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -421,37 +421,6 @@ static void ipmr_free_table(struct mr_table *mrt)
 
 /* Service routines creating virtual interfaces: DVMRP tunnels and PIMREG */
 
-static void ipmr_del_tunnel(struct net_device *dev, struct vifctl *v)
-{
-	struct net *net = dev_net(dev);
-
-	dev_close(dev);
-
-	dev = __dev_get_by_name(net, "tunl0");
-	if (dev) {
-		const struct net_device_ops *ops = dev->netdev_ops;
-		struct ifreq ifr;
-		struct ip_tunnel_parm p;
-
-		memset(&p, 0, sizeof(p));
-		p.iph.daddr = v->vifc_rmt_addr.s_addr;
-		p.iph.saddr = v->vifc_lcl_addr.s_addr;
-		p.iph.version = 4;
-		p.iph.ihl = 5;
-		p.iph.protocol = IPPROTO_IPIP;
-		sprintf(p.name, "dvmrp%d", v->vifc_vifi);
-		ifr.ifr_ifru.ifru_data = (__force void __user *)&p;
-
-		if (ops->ndo_do_ioctl) {
-			mm_segment_t oldfs = get_fs();
-
-			set_fs(KERNEL_DS);
-			ops->ndo_do_ioctl(dev, &ifr, SIOCDELTUNNEL);
-			set_fs(oldfs);
-		}
-	}
-}
-
 /* Initialize ipmr pimreg/tunnel in_device */
 static bool ipmr_init_vif_indev(const struct net_device *dev)
 {
@@ -509,12 +478,22 @@ static struct net_device *ipmr_new_tunnel(struct net *net, struct vifctl *v)
 	if (dev_open(new_dev, NULL))
 		goto out_unregister;
 	dev_hold(new_dev);
+	err = dev_set_allmulti(new_dev, 1);
+	if (err) {
+		dev_close(new_dev);
+		set_fs(KERNEL_DS);
+		tunnel_dev->netdev_ops->ndo_do_ioctl(tunnel_dev, &ifr,
+				SIOCDELTUNNEL);
+		set_fs(oldfs);
+		dev_put(new_dev);
+		new_dev = ERR_PTR(err);
+	}
 	return new_dev;
 
 out_unregister:
 	unregister_netdevice(new_dev);
 out:
-	return NULL;
+	return ERR_PTR(-ENOBUFS);
 }
 
 #if defined(CONFIG_IP_PIMSM_V1) || defined(CONFIG_IP_PIMSM_V2)
@@ -866,14 +845,8 @@ static int vif_add(struct net *net, struct mr_table *mrt,
 		break;
 	case VIFF_TUNNEL:
 		dev = ipmr_new_tunnel(net, vifc);
-		if (!dev)
-			return -ENOBUFS;
-		err = dev_set_allmulti(dev, 1);
-		if (err) {
-			ipmr_del_tunnel(dev, vifc);
-			dev_put(dev);
-			return err;
-		}
+		if (IS_ERR(dev))
+			return PTR_ERR(dev);
 		break;
 	case VIFF_USE_IFINDEX:
 	case 0:
-- 
2.26.2

