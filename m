Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4A0232B7C
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 07:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbgG3Fl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 01:41:56 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:56060 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728612AbgG3Flt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 01:41:49 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 30E0A205DB;
        Thu, 30 Jul 2020 07:41:47 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id i09RW5YaYz0O; Thu, 30 Jul 2020 07:41:46 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E3B28205AA;
        Thu, 30 Jul 2020 07:41:45 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 07:41:45 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 30 Jul
 2020 07:41:44 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 5CF7B318467C; Thu, 30 Jul 2020 07:41:44 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 12/19] xfrm interface: avoid xi lookup in xfrmi_decode_session()
Date:   Thu, 30 Jul 2020 07:41:23 +0200
Message-ID: <20200730054130.16923-13-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200730054130.16923-1-steffen.klassert@secunet.com>
References: <20200730054130.16923-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eyal Birger <eyal.birger@gmail.com>

The xfrmi context exists in the netdevice priv context.
Avoid looking for it in a separate list.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_interface.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index a79eb49a4e0d..36a765eac034 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -47,6 +47,7 @@ static int xfrmi_dev_init(struct net_device *dev);
 static void xfrmi_dev_setup(struct net_device *dev);
 static struct rtnl_link_ops xfrmi_link_ops __read_mostly;
 static unsigned int xfrmi_net_id __read_mostly;
+static const struct net_device_ops xfrmi_netdev_ops;
 
 struct xfrmi_net {
 	/* lists for storing interfaces in use */
@@ -73,8 +74,7 @@ static struct xfrm_if *xfrmi_lookup(struct net *net, struct xfrm_state *x)
 static struct xfrm_if *xfrmi_decode_session(struct sk_buff *skb,
 					    unsigned short family)
 {
-	struct xfrmi_net *xfrmn;
-	struct xfrm_if *xi;
+	struct net_device *dev;
 	int ifindex = 0;
 
 	if (!secpath_exists(skb) || !skb->dev)
@@ -88,18 +88,21 @@ static struct xfrm_if *xfrmi_decode_session(struct sk_buff *skb,
 		ifindex = inet_sdif(skb);
 		break;
 	}
-	if (!ifindex)
-		ifindex = skb->dev->ifindex;
 
-	xfrmn = net_generic(xs_net(xfrm_input_state(skb)), xfrmi_net_id);
+	if (ifindex) {
+		struct net *net = xs_net(xfrm_input_state(skb));
 
-	for_each_xfrmi_rcu(xfrmn->xfrmi[0], xi) {
-		if (ifindex == xi->dev->ifindex &&
-			(xi->dev->flags & IFF_UP))
-				return xi;
+		dev = dev_get_by_index_rcu(net, ifindex);
+	} else {
+		dev = skb->dev;
 	}
 
-	return NULL;
+	if (!dev || !(dev->flags & IFF_UP))
+		return NULL;
+	if (dev->netdev_ops != &xfrmi_netdev_ops)
+		return NULL;
+
+	return netdev_priv(dev);
 }
 
 static void xfrmi_link(struct xfrmi_net *xfrmn, struct xfrm_if *xi)
-- 
2.17.1

