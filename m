Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDE3C081C
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 16:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbfI0O6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 10:58:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46892 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727769AbfI0O6g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 10:58:36 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 46C1C369D3;
        Fri, 27 Sep 2019 14:58:35 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.206.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31A7C8DC00;
        Fri, 27 Sep 2019 14:58:34 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next v3 2/6] xfrm: introduce xfrm_trans_queue_net
Date:   Fri, 27 Sep 2019 16:58:57 +0200
Message-Id: <26101ca486b744bcb658c87d09d97972f047e7f9.1569491461.git.sd@queasysnail.net>
In-Reply-To: <cover.1569491461.git.sd@queasysnail.net>
References: <cover.1569491461.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 27 Sep 2019 14:58:35 +0000 (UTC)
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
index aa08a7a5f6ac..a0199f8251ec 100644
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

