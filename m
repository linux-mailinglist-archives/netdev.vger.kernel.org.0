Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4881AA9F82
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 12:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732407AbfIEKWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 06:22:10 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:57328 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730839AbfIEKWK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 06:22:10 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 9FC9B20080;
        Thu,  5 Sep 2019 12:22:09 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id AsSA7MAh1XA1; Thu,  5 Sep 2019 12:22:09 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2F69C2054D;
        Thu,  5 Sep 2019 12:22:09 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 5 Sep 2019
 12:22:07 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id C185E31826EA;
 Thu,  5 Sep 2019 12:22:08 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/5] xfrm interface: ifname may be wrong in logs
Date:   Thu, 5 Sep 2019 12:21:58 +0200
Message-ID: <20190905102201.1636-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905102201.1636-1-steffen.klassert@secunet.com>
References: <20190905102201.1636-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

The ifname is copied when the interface is created, but is never updated
later. In fact, this property is used only in one error message, where the
netdevice pointer is available, thus let's use it.

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h        |  1 -
 net/xfrm/xfrm_interface.c | 10 +---------
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index b22db30c3d88..ad761ef84797 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -983,7 +983,6 @@ static inline void xfrm_dst_destroy(struct xfrm_dst *xdst)
 void xfrm_dst_ifdown(struct dst_entry *dst, struct net_device *dev);
 
 struct xfrm_if_parms {
-	char name[IFNAMSIZ];	/* name of XFRM device */
 	int link;		/* ifindex of underlying L2 interface */
 	u32 if_id;		/* interface identifyer */
 };
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 2310dc9e35c2..68336ee00d72 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -145,8 +145,6 @@ static int xfrmi_create(struct net_device *dev)
 	if (err < 0)
 		goto out;
 
-	strcpy(xi->p.name, dev->name);
-
 	dev_hold(dev);
 	xfrmi_link(xfrmn, xi);
 
@@ -294,7 +292,7 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 	if (tdev == dev) {
 		stats->collisions++;
 		net_warn_ratelimited("%s: Local routing loop detected!\n",
-				     xi->p.name);
+				     dev->name);
 		goto tx_err_dst_release;
 	}
 
@@ -638,12 +636,6 @@ static int xfrmi_newlink(struct net *src_net, struct net_device *dev,
 	int err;
 
 	xfrmi_netlink_parms(data, &p);
-
-	if (!tb[IFLA_IFNAME])
-		return -EINVAL;
-
-	nla_strlcpy(p.name, tb[IFLA_IFNAME], IFNAMSIZ);
-
 	xi = xfrmi_locate(net, &p);
 	if (xi)
 		return -EEXIST;
-- 
2.17.1

