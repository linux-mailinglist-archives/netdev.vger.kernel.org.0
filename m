Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4258564303
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 09:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfGJHpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 03:45:44 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:44452 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfGJHpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 03:45:43 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 665762E41CF;
        Wed, 10 Jul 2019 09:45:40 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.89)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1hl7IK-0001yV-A5; Wed, 10 Jul 2019 09:45:40 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH ipsec 2/2] xfrm interface: ifname may be wrong in logs
Date:   Wed, 10 Jul 2019 09:45:36 +0200
Message-Id: <20190710074536.7505-3-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190710074536.7505-1-nicolas.dichtel@6wind.com>
References: <20190710074536.7505-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ifname is copied when the interface is created, but is never updated
later. In fact, this property is used only in one error message, where the
netdevice pointer is available, thus let's use it.

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 include/net/xfrm.h        |  1 -
 net/xfrm/xfrm_interface.c | 10 +---------
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index a2907873ed56..287e39753d94 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -988,7 +988,6 @@ static inline void xfrm_dst_destroy(struct xfrm_dst *xdst)
 void xfrm_dst_ifdown(struct dst_entry *dst, struct net_device *dev);
 
 struct xfrm_if_parms {
-	char name[IFNAMSIZ];	/* name of XFRM device */
 	int link;		/* ifindex of underlying L2 interface */
 	u32 if_id;		/* interface identifyer */
 };
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index dfa5aebdec57..a60d391f7ebe 100644
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
2.21.0

