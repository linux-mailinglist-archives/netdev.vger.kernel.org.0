Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92D4C11682D
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 09:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfLIIbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 03:31:03 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:36958 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727144AbfLIIbD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 03:31:03 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 887E82057B;
        Mon,  9 Dec 2019 09:31:01 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id JTCYIYR1m27q; Mon,  9 Dec 2019 09:31:01 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 052BF2008D;
        Mon,  9 Dec 2019 09:31:01 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 9 Dec 2019
 09:31:00 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id A88333180AFB;
 Mon,  9 Dec 2019 09:31:00 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Greg KH <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: [PATCH stable v4.19 4/4] xfrm interface: fix management of phydev
Date:   Mon, 9 Dec 2019 09:30:45 +0100
Message-ID: <20191209083045.20657-5-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191209083045.20657-1-steffen.klassert@secunet.com>
References: <20191209083045.20657-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit 22d6552f827ef76ade3edf6bbb3f05048a0a7d8b upstream

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
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h        |  1 -
 net/xfrm/xfrm_interface.c | 32 +++++++++++++++++---------------
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 4ddd2b13ac8d..fb9b19a3b749 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1062,7 +1062,6 @@ struct xfrm_if_parms {
 struct xfrm_if {
 	struct xfrm_if __rcu *next;	/* next interface in list */
 	struct net_device *dev;		/* virtual device associated with interface */
-	struct net_device *phydev;	/* physical device */
 	struct net *net;		/* netns for packet i/o */
 	struct xfrm_if_parms p;		/* interface parms */
 
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 2ed779db8769..d6a3cdf7885c 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -177,7 +177,6 @@ static void xfrmi_dev_uninit(struct net_device *dev)
 	struct xfrmi_net *xfrmn = net_generic(xi->net, xfrmi_net_id);
 
 	xfrmi_unlink(xfrmn, xi);
-	dev_put(xi->phydev);
 	dev_put(dev);
 }
 
@@ -364,7 +363,7 @@ static netdev_tx_t xfrmi_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto tx_err;
 	}
 
-	fl.flowi_oif = xi->phydev->ifindex;
+	fl.flowi_oif = xi->p.link;
 
 	ret = xfrmi_xmit2(skb, dev, &fl);
 	if (ret < 0)
@@ -553,7 +552,7 @@ static int xfrmi_get_iflink(const struct net_device *dev)
 {
 	struct xfrm_if *xi = netdev_priv(dev);
 
-	return xi->phydev->ifindex;
+	return xi->p.link;
 }
 
 
@@ -579,12 +578,14 @@ static void xfrmi_dev_setup(struct net_device *dev)
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
@@ -599,13 +600,19 @@ static int xfrmi_dev_init(struct net_device *dev)
 
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
@@ -655,13 +662,8 @@ static int xfrmi_newlink(struct net *src_net, struct net_device *dev,
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
2.17.1

