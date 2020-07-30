Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311D2232B8A
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 07:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbgG3FsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 01:48:12 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:56310 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728195AbgG3FsD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 01:48:03 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id A4A27205AA;
        Thu, 30 Jul 2020 07:48:01 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4b7ZJYHWdzQN; Thu, 30 Jul 2020 07:48:01 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 78EE2205E3;
        Thu, 30 Jul 2020 07:48:00 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 30 Jul 2020 07:48:00 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 30 Jul
 2020 07:47:58 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 7DC2D318468D;
 Thu, 30 Jul 2020 07:41:44 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 19/19] xfrm: Make the policy hold queue work with VTI.
Date:   Thu, 30 Jul 2020 07:41:30 +0200
Message-ID: <20200730054130.16923-20-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200730054130.16923-1-steffen.klassert@secunet.com>
References: <20200730054130.16923-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We forgot to support the xfrm policy hold queue when
VTI was implemented. This patch adds everything we
need so that we can use the policy hold queue together
with VTI interfaces.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/ip_vti.c      |  6 +++++-
 net/ipv6/ip6_vti.c     |  6 +++++-
 net/xfrm/xfrm_policy.c | 11 +++++++++++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 3e5d54517145..8b962eac9ed8 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -218,12 +218,15 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	dst_hold(dst);
-	dst = xfrm_lookup(tunnel->net, dst, fl, NULL, 0);
+	dst = xfrm_lookup_route(tunnel->net, dst, fl, NULL, 0);
 	if (IS_ERR(dst)) {
 		dev->stats.tx_carrier_errors++;
 		goto tx_error_icmp;
 	}
 
+	if (dst->flags & DST_XFRM_QUEUE)
+		goto queued;
+
 	if (!vti_state_check(dst->xfrm, parms->iph.daddr, parms->iph.saddr)) {
 		dev->stats.tx_carrier_errors++;
 		dst_release(dst);
@@ -255,6 +258,7 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
 		goto tx_error;
 	}
 
+queued:
 	skb_scrub_packet(skb, !net_eq(tunnel->net, dev_net(dev)));
 	skb_dst_set(skb, dst);
 	skb->dev = skb_dst(skb)->dev;
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 53f12b40528e..f5a4c4a6492b 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -491,13 +491,16 @@ vti6_xmit(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 	}
 
 	dst_hold(dst);
-	dst = xfrm_lookup(t->net, dst, fl, NULL, 0);
+	dst = xfrm_lookup_route(t->net, dst, fl, NULL, 0);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		dst = NULL;
 		goto tx_err_link_failure;
 	}
 
+	if (dst->flags & DST_XFRM_QUEUE)
+		goto queued;
+
 	x = dst->xfrm;
 	if (!vti6_state_check(x, &t->parms.raddr, &t->parms.laddr))
 		goto tx_err_link_failure;
@@ -533,6 +536,7 @@ vti6_xmit(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 		goto tx_err_dst_release;
 	}
 
+queued:
 	skb_scrub_packet(skb, !net_eq(t->net, dev_net(dev)));
 	skb_dst_set(skb, dst);
 	skb->dev = skb_dst(skb)->dev;
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 564aa6492e7c..be150475b28b 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2758,6 +2758,7 @@ static void xfrm_policy_queue_process(struct timer_list *t)
 	struct xfrm_policy_queue *pq = &pol->polq;
 	struct flowi fl;
 	struct sk_buff_head list;
+	__u32 skb_mark;
 
 	spin_lock(&pq->hold_queue.lock);
 	skb = skb_peek(&pq->hold_queue);
@@ -2767,7 +2768,12 @@ static void xfrm_policy_queue_process(struct timer_list *t)
 	}
 	dst = skb_dst(skb);
 	sk = skb->sk;
+
+	/* Fixup the mark to support VTI. */
+	skb_mark = skb->mark;
+	skb->mark = pol->mark.v;
 	xfrm_decode_session(skb, &fl, dst->ops->family);
+	skb->mark = skb_mark;
 	spin_unlock(&pq->hold_queue.lock);
 
 	dst_hold(xfrm_dst_path(dst));
@@ -2799,7 +2805,12 @@ static void xfrm_policy_queue_process(struct timer_list *t)
 	while (!skb_queue_empty(&list)) {
 		skb = __skb_dequeue(&list);
 
+		/* Fixup the mark to support VTI. */
+		skb_mark = skb->mark;
+		skb->mark = pol->mark.v;
 		xfrm_decode_session(skb, &fl, skb_dst(skb)->ops->family);
+		skb->mark = skb_mark;
+
 		dst_hold(xfrm_dst_path(skb_dst(skb)));
 		dst = xfrm_lookup(net, xfrm_dst_path(skb_dst(skb)), &fl, skb->sk, 0);
 		if (IS_ERR(dst)) {
-- 
2.17.1

