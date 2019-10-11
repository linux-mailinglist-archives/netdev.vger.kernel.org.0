Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF96D438A
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 16:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfJKO47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 10:56:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40692 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbfJKO47 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 10:56:59 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 832EE10CC1EE;
        Fri, 11 Oct 2019 14:56:58 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.206.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6BC595C1B2;
        Fri, 11 Oct 2019 14:56:57 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net-next v4 2/6] xfrm: introduce xfrm_trans_queue_net
Date:   Fri, 11 Oct 2019 16:57:25 +0200
Message-Id: <edbf3f32bdc5087cc683fe24e83cafbba1dce35e.1570787286.git.sd@queasysnail.net>
In-Reply-To: <cover.1570787286.git.sd@queasysnail.net>
References: <cover.1570787286.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Fri, 11 Oct 2019 14:56:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will be used by TCP encapsulation to write packets to the encap
socket without holding the user socket's lock. Without this reinjection,
we're already holding the lock of the user socket, and then try to lock
the encap socket as well when we enqueue the encrypted packet.

While at it, add a BUILD_BUG_ON like we usually do for skb->cb, since
it's missing for struct xfrm_trans_cb.

Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 include/net/xfrm.h    |  3 +++
 net/xfrm/xfrm_input.c | 21 +++++++++++++++++----
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index dda3c025452e..56ff86621bb4 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1547,6 +1547,9 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload);
 int xfrm_init_state(struct xfrm_state *x);
 int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type);
 int xfrm_input_resume(struct sk_buff *skb, int nexthdr);
+int xfrm_trans_queue_net(struct net *net, struct sk_buff *skb,
+			 int (*finish)(struct net *, struct sock *,
+				       struct sk_buff *));
 int xfrm_trans_queue(struct sk_buff *skb,
 		     int (*finish)(struct net *, struct sock *,
 				   struct sk_buff *));
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 6088bc2dc11e..eb0f0e64c71c 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -36,6 +36,7 @@ struct xfrm_trans_cb {
 #endif
 	} header;
 	int (*finish)(struct net *net, struct sock *sk, struct sk_buff *skb);
+	struct net *net;
 };
 
 #define XFRM_TRANS_SKB_CB(__skb) ((struct xfrm_trans_cb *)&((__skb)->cb[0]))
@@ -763,12 +764,13 @@ static void xfrm_trans_reinject(unsigned long data)
 	skb_queue_splice_init(&trans->queue, &queue);
 
 	while ((skb = __skb_dequeue(&queue)))
-		XFRM_TRANS_SKB_CB(skb)->finish(dev_net(skb->dev), NULL, skb);
+		XFRM_TRANS_SKB_CB(skb)->finish(XFRM_TRANS_SKB_CB(skb)->net,
+					       NULL, skb);
 }
 
-int xfrm_trans_queue(struct sk_buff *skb,
-		     int (*finish)(struct net *, struct sock *,
-				   struct sk_buff *))
+int xfrm_trans_queue_net(struct net *net, struct sk_buff *skb,
+			 int (*finish)(struct net *, struct sock *,
+				       struct sk_buff *))
 {
 	struct xfrm_trans_tasklet *trans;
 
@@ -777,11 +779,22 @@ int xfrm_trans_queue(struct sk_buff *skb,
 	if (skb_queue_len(&trans->queue) >= netdev_max_backlog)
 		return -ENOBUFS;
 
+	BUILD_BUG_ON(sizeof(struct xfrm_trans_cb) > sizeof(skb->cb));
+
 	XFRM_TRANS_SKB_CB(skb)->finish = finish;
+	XFRM_TRANS_SKB_CB(skb)->net = net;
 	__skb_queue_tail(&trans->queue, skb);
 	tasklet_schedule(&trans->tasklet);
 	return 0;
 }
+EXPORT_SYMBOL(xfrm_trans_queue_net);
+
+int xfrm_trans_queue(struct sk_buff *skb,
+		     int (*finish)(struct net *, struct sock *,
+				   struct sk_buff *))
+{
+	return xfrm_trans_queue_net(dev_net(skb->dev), skb, finish);
+}
 EXPORT_SYMBOL(xfrm_trans_queue);
 
 void __init xfrm_input_init(void)
-- 
2.23.0

