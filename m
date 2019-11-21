Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5F6105053
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 11:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfKUKSo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 Nov 2019 05:18:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57949 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726197AbfKUKSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 05:18:44 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-OVkqvGurM4qHbV77mTxZ0A-1; Thu, 21 Nov 2019 05:18:39 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 360BA1005509;
        Thu, 21 Nov 2019 10:18:38 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-31.ams2.redhat.com [10.36.116.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B76556FDCE;
        Thu, 21 Nov 2019 10:18:36 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH ipsec-next v6 2/6] xfrm: introduce xfrm_trans_queue_net
Date:   Thu, 21 Nov 2019 11:18:24 +0100
Message-Id: <604dec3599799dc765e13b82d225777499fabf14.1574329035.git.sd@queasysnail.net>
In-Reply-To: <cover.1574329035.git.sd@queasysnail.net>
References: <cover.1574329035.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: OVkqvGurM4qHbV77mTxZ0A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
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
Acked-by: David S. Miller <davem@davemloft.net>
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
index 9b599ed66d97..7a6c2731839d 100644
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

