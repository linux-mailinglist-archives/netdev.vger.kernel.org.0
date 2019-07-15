Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3630686C7
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 12:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbfGOKAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 06:00:38 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:35112 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729703AbfGOKAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 06:00:35 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 551922E8837;
        Mon, 15 Jul 2019 12:00:31 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.89)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1hmxmZ-0002EE-7s; Mon, 15 Jul 2019 12:00:31 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Julien Floret <julien.floret@6wind.com>
Subject: [PATCH ipsec v2 4/4] xfrm interface: fix management of phydev
Date:   Mon, 15 Jul 2019 12:00:23 +0200
Message-Id: <20190715100023.8475-5-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190715100023.8475-1-nicolas.dichtel@6wind.com>
References: <df990564-819a-314f-dda6-aab58a2e7b6e@6wind.com>
 <20190715100023.8475-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the current implementation, phydev cannot be removed:

$ ip link add dummy type dummy
$ ip link add xfrm1 type xfrm dev dummy if_id 1
$ ip l d dummy
 kernel:[77938.465445] unregister_netdevice: waiting for dummy to become free. Usage count = 1

Manage it like in ip tunnels, ie just keep the ifindex. Not that the side
effect, is that the phydev is now optional.

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Tested-by: Julien Floret <julien.floret@6wind.com>
---
 include/net/xfrm.h        |  1 -
 net/xfrm/xfrm_interface.c | 32 +++++++++++++++++---------------
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index ad761ef84797..aa08a7a5f6ac 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -990,7 +990,6 @@ struct xfrm_if_parms {
 struct xfrm_if {
 	struct xfrm_if __rcu *next;	/* next interface in list */
 	struct net_device *dev;		/* virtual device associated with interface */
-	struct net_device *phydev;	/* physical device */
 	struct net *net;		/* netns for packet i/o */
 	struct xfrm_if_parms p;		/* interface parms */
 
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 53e5e47b2c55..2ab4859df55a 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -175,7 +175,6 @@ static void xfrmi_dev_uninit(struct net_device *dev)
 	struct xfrmi_net *xfrmn = net_generic(xi->net, xfrmi_net_id);
 
 	xfrmi_unlink(xfrmn, xi);
-	dev_put(xi->phydev);
 	dev_put(dev);
 }
 
@@ -362,7 +361,7 @@ static netdev_tx_t xfrmi_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto tx_err;
 	}
 
-	fl.flowi_oif = xi->phydev->ifindex;
+	fl.flowi_oif = xi->p.link;
 
 	ret = xfrmi_xmit2(skb, dev, &fl);
 	if (ret < 0)
@@ -548,7 +547,7 @@ static int xfrmi_get_iflink(const struct net_device *dev)
 {
 	struct xfrm_if *xi = netdev_priv(dev);
 
-	return xi->phydev->ifindex;
+	return xi->p.link;
 }
 
 
@@ -574,12 +573,14 @@ static void xfrmi_dev_setup(struct net_device *dev)
 	dev->needs_free_netdev	= true;
 	dev->priv_destructor	= xfrmi_dev_free;
 	netif_keep_dst(dev);
+
+	eth_broadcast_addr(dev->broadcast);
 }
 
 static int xfrmi_dev_init(struct net_device *dev)
 {
 	struct xfrm_if *xi = netdev_priv(dev);
-	struct net_device *phydev = xi->phydev;
+	struct net_device *phydev = __dev_get_by_index(xi->net, xi->p.link);
 	int err;
 
 	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
@@ -594,13 +595,19 @@ static int xfrmi_dev_init(struct net_device *dev)
 
 	dev->features |= NETIF_F_LLTX;
 
-	dev->needed_headroom = phydev->needed_headroom;
-	dev->needed_tailroom = phydev->needed_tailroom;
+	if (phydev) {
+		dev->needed_headroom = phydev->needed_headroom;
+		dev->needed_tailroom = phydev->needed_tailroom;
 
-	if (is_zero_ether_addr(dev->dev_addr))
-		eth_hw_addr_inherit(dev, phydev);
-	if (is_zero_ether_addr(dev->broadcast))
-		memcpy(dev->broadcast, phydev->broadcast, dev->addr_len);
+		if (is_zero_ether_addr(dev->dev_addr))
+			eth_hw_addr_inherit(dev, phydev);
+		if (is_zero_ether_addr(dev->broadcast))
+			memcpy(dev->broadcast, phydev->broadcast,
+			       dev->addr_len);
+	} else {
+		eth_hw_addr_random(dev);
+		eth_broadcast_addr(dev->broadcast);
+	}
 
 	return 0;
 }
@@ -644,13 +651,8 @@ static int xfrmi_newlink(struct net *src_net, struct net_device *dev,
 	xi->p = p;
 	xi->net = net;
 	xi->dev = dev;
-	xi->phydev = dev_get_by_index(net, p.link);
-	if (!xi->phydev)
-		return -ENODEV;
 
 	err = xfrmi_create(dev);
-	if (err < 0)
-		dev_put(xi->phydev);
 	return err;
 }
 
-- 
2.21.0

