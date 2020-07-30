Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4218B232B86
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 07:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbgG3FsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 01:48:03 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:56292 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbgG3FsC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 01:48:02 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id A39FE205E5;
        Thu, 30 Jul 2020 07:48:00 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id iGE8PXaK28Uk; Thu, 30 Jul 2020 07:48:00 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D79B92049A;
        Thu, 30 Jul 2020 07:47:59 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 30 Jul 2020 07:47:59 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 30 Jul
 2020 07:47:58 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 60FB6318467F;
 Thu, 30 Jul 2020 07:41:44 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 13/19] xfrm interface: store xfrmi contexts in a hash by if_id
Date:   Thu, 30 Jul 2020 07:41:24 +0200
Message-ID: <20200730054130.16923-14-steffen.klassert@secunet.com>
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

xfrmi_lookup() is called on every packet. Using a single list for
looking up if_id becomes a bottleneck when having many xfrm interfaces.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_interface.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 36a765eac034..96496fdfe3ce 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -49,20 +49,28 @@ static struct rtnl_link_ops xfrmi_link_ops __read_mostly;
 static unsigned int xfrmi_net_id __read_mostly;
 static const struct net_device_ops xfrmi_netdev_ops;
 
+#define XFRMI_HASH_BITS	8
+#define XFRMI_HASH_SIZE	BIT(XFRMI_HASH_BITS)
+
 struct xfrmi_net {
 	/* lists for storing interfaces in use */
-	struct xfrm_if __rcu *xfrmi[1];
+	struct xfrm_if __rcu *xfrmi[XFRMI_HASH_SIZE];
 };
 
 #define for_each_xfrmi_rcu(start, xi) \
 	for (xi = rcu_dereference(start); xi; xi = rcu_dereference(xi->next))
 
+static u32 xfrmi_hash(u32 if_id)
+{
+	return hash_32(if_id, XFRMI_HASH_BITS);
+}
+
 static struct xfrm_if *xfrmi_lookup(struct net *net, struct xfrm_state *x)
 {
 	struct xfrmi_net *xfrmn = net_generic(net, xfrmi_net_id);
 	struct xfrm_if *xi;
 
-	for_each_xfrmi_rcu(xfrmn->xfrmi[0], xi) {
+	for_each_xfrmi_rcu(xfrmn->xfrmi[xfrmi_hash(x->if_id)], xi) {
 		if (x->if_id == xi->p.if_id &&
 		    (xi->dev->flags & IFF_UP))
 			return xi;
@@ -107,7 +115,7 @@ static struct xfrm_if *xfrmi_decode_session(struct sk_buff *skb,
 
 static void xfrmi_link(struct xfrmi_net *xfrmn, struct xfrm_if *xi)
 {
-	struct xfrm_if __rcu **xip = &xfrmn->xfrmi[0];
+	struct xfrm_if __rcu **xip = &xfrmn->xfrmi[xfrmi_hash(xi->p.if_id)];
 
 	rcu_assign_pointer(xi->next , rtnl_dereference(*xip));
 	rcu_assign_pointer(*xip, xi);
@@ -118,7 +126,7 @@ static void xfrmi_unlink(struct xfrmi_net *xfrmn, struct xfrm_if *xi)
 	struct xfrm_if __rcu **xip;
 	struct xfrm_if *iter;
 
-	for (xip = &xfrmn->xfrmi[0];
+	for (xip = &xfrmn->xfrmi[xfrmi_hash(xi->p.if_id)];
 	     (iter = rtnl_dereference(*xip)) != NULL;
 	     xip = &iter->next) {
 		if (xi == iter) {
@@ -162,7 +170,7 @@ static struct xfrm_if *xfrmi_locate(struct net *net, struct xfrm_if_parms *p)
 	struct xfrm_if *xi;
 	struct xfrmi_net *xfrmn = net_generic(net, xfrmi_net_id);
 
-	for (xip = &xfrmn->xfrmi[0];
+	for (xip = &xfrmn->xfrmi[xfrmi_hash(p->if_id)];
 	     (xi = rtnl_dereference(*xip)) != NULL;
 	     xip = &xi->next)
 		if (xi->p.if_id == p->if_id)
@@ -761,11 +769,14 @@ static void __net_exit xfrmi_exit_batch_net(struct list_head *net_exit_list)
 		struct xfrmi_net *xfrmn = net_generic(net, xfrmi_net_id);
 		struct xfrm_if __rcu **xip;
 		struct xfrm_if *xi;
+		int i;
 
-		for (xip = &xfrmn->xfrmi[0];
-		     (xi = rtnl_dereference(*xip)) != NULL;
-		     xip = &xi->next)
-			unregister_netdevice_queue(xi->dev, &list);
+		for (i = 0; i < XFRMI_HASH_SIZE; i++) {
+			for (xip = &xfrmn->xfrmi[i];
+			     (xi = rtnl_dereference(*xip)) != NULL;
+			     xip = &xi->next)
+				unregister_netdevice_queue(xi->dev, &list);
+		}
 	}
 	unregister_netdevice_many(&list);
 	rtnl_unlock();
-- 
2.17.1

