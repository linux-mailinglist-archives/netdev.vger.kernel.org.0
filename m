Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F045BB5DFB
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 09:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbfIRHZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 03:25:44 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:60590 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbfIRHZl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 03:25:41 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5FDEB205B5;
        Wed, 18 Sep 2019 09:25:39 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id uVjPs_3IHLsX; Wed, 18 Sep 2019 09:25:38 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 100E320422;
        Wed, 18 Sep 2019 09:25:38 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 18 Sep 2019
 09:25:36 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 43D2C3180024;
 Wed, 18 Sep 2019 09:25:37 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <netdev@vger.kernel.org>
CC:     Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH RFC v3 5/5] udp: Support UDP fraglist GRO/GSO.
Date:   Wed, 18 Sep 2019 09:25:17 +0200
Message-ID: <20190918072517.16037-6-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190918072517.16037-1-steffen.klassert@secunet.com>
References: <20190918072517.16037-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends UDP GRO to support fraglist GRO/GSO
by using the previously introduced infrastructure.
All UDP packets that are not targeted to a GRO capable
UDP sockets are going to fraglist GRO now (local input
and forward).

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/udp_offload.c | 61 +++++++++++++++++++++++++++++++++++++-----
 net/ipv6/udp_offload.c |  9 +++++++
 2 files changed, 64 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index e0b835890507..37daafb06d4c 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -184,6 +184,20 @@ struct sk_buff *skb_udp_tunnel_segment(struct sk_buff *skb,
 }
 EXPORT_SYMBOL(skb_udp_tunnel_segment);
 
+static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
+					      netdev_features_t features)
+{
+	unsigned int mss = skb_shinfo(skb)->gso_size;
+
+	skb = skb_segment_list(skb, features, skb_mac_header_len(skb));
+	if (IS_ERR(skb))
+		return skb;
+
+	udp_hdr(skb)->len = htons(sizeof(struct udphdr) + mss);
+
+	return skb;
+}
+
 struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 				  netdev_features_t features)
 {
@@ -196,6 +210,9 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 	__sum16 check;
 	__be16 newlen;
 
+	if (skb_shinfo(gso_skb)->gso_type & SKB_GSO_FRAGLIST)
+		return __udp_gso_segment_list(gso_skb, features);
+
 	mss = skb_shinfo(gso_skb)->gso_size;
 	if (gso_skb->len <= sizeof(*uh) + mss)
 		return ERR_PTR(-EINVAL);
@@ -354,6 +371,7 @@ static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
 	struct udphdr *uh2;
 	struct sk_buff *p;
 	unsigned int ulen;
+	int ret = 0;
 
 	/* requires non zero csum, for symmetry with GSO */
 	if (!uh->check) {
@@ -369,7 +387,6 @@ static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
 	}
 	/* pull encapsulating udp header */
 	skb_gro_pull(skb, sizeof(struct udphdr));
-	skb_gro_postpull_rcsum(skb, uh, sizeof(struct udphdr));
 
 	list_for_each_entry(p, head, list) {
 		if (!NAPI_GRO_CB(p)->same_flow)
@@ -383,14 +400,35 @@ static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
 			continue;
 		}
 
+		if (NAPI_GRO_CB(skb)->is_flist != NAPI_GRO_CB(p)->is_flist) {
+			NAPI_GRO_CB(skb)->flush = 1;
+			return p;
+		}
+
 		/* Terminate the flow on len mismatch or if it grow "too much".
 		 * Under small packet flood GRO count could elsewhere grow a lot
 		 * leading to excessive truesize values.
 		 * On len mismatch merge the first packet shorter than gso_size,
 		 * otherwise complete the GRO packet.
 		 */
-		if (ulen > ntohs(uh2->len) || skb_gro_receive(p, skb) ||
-		    ulen != ntohs(uh2->len) ||
+		if (ulen > ntohs(uh2->len)) {
+			pp = p;
+		} else {
+			if (NAPI_GRO_CB(skb)->is_flist) {
+				if (!pskb_may_pull(skb, skb_gro_offset(skb))) {
+					NAPI_GRO_CB(skb)->flush = 1;
+					return NULL;
+				}
+				ret = skb_gro_receive_list(p, skb);
+			} else {
+				skb_gro_postpull_rcsum(skb, uh,
+						       sizeof(struct udphdr));
+
+				ret = skb_gro_receive(p, skb);
+			}
+		}
+
+		if (ret || ulen != ntohs(uh2->len) ||
 		    NAPI_GRO_CB(p)->count >= UDP_GRO_CNT_MAX)
 			pp = p;
 
@@ -411,6 +449,9 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
 	int flush = 1;
 
 	if (!sk || !udp_sk(sk)->gro_receive) {
+		if (skb->dev->features & NETIF_F_GRO_LIST)
+			NAPI_GRO_CB(skb)->is_flist = sk ? !udp_sk(sk)->gro_enabled: 1;
+
 		pp = call_gro_receive(udp_gro_receive_segment, head, skb);
 		return pp;
 	}
@@ -419,7 +460,7 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
 	    (skb->ip_summed != CHECKSUM_PARTIAL &&
 	     NAPI_GRO_CB(skb)->csum_cnt == 0 &&
 	     !NAPI_GRO_CB(skb)->csum_valid))
-		goto out_unlock;
+		goto out;
 
 	/* mark that this skb passed once through the tunnel gro layer */
 	NAPI_GRO_CB(skb)->encap_mark = 1;
@@ -446,8 +487,7 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
 	skb_gro_postpull_rcsum(skb, uh, sizeof(struct udphdr));
 	pp = call_gro_receive_sk(udp_sk(sk)->gro_receive, sk, head, skb);
 
-out_unlock:
-	rcu_read_unlock();
+out:
 	skb_gro_flush_final(skb, pp, flush);
 	return pp;
 }
@@ -539,6 +579,15 @@ INDIRECT_CALLABLE_SCOPE int udp4_gro_complete(struct sk_buff *skb, int nhoff)
 	const struct iphdr *iph = ip_hdr(skb);
 	struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
 
+	if (NAPI_GRO_CB(skb)->is_flist) {
+		uh->len = htons(skb->len - nhoff);
+
+		skb_shinfo(skb)->gso_type |= (SKB_GSO_FRAGLIST|SKB_GSO_UDP_L4);
+		skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
+
+		return 0;
+	}
+
 	if (uh->check)
 		uh->check = ~udp_v4_check(skb->len - nhoff, iph->saddr,
 					  iph->daddr, 0);
diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index 47a3b1348371..e503b5cf9023 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -150,6 +150,15 @@ INDIRECT_CALLABLE_SCOPE int udp6_gro_complete(struct sk_buff *skb, int nhoff)
 	const struct ipv6hdr *ipv6h = ipv6_hdr(skb);
 	struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
 
+	if (NAPI_GRO_CB(skb)->is_flist) {
+		uh->len = htons(skb->len - nhoff);
+
+		skb_shinfo(skb)->gso_type |= (SKB_GSO_FRAGLIST|SKB_GSO_UDP_L4);
+		skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
+
+		return 0;
+	}
+
 	if (uh->check)
 		uh->check = ~udp_v6_check(skb->len - nhoff, &ipv6h->saddr,
 					  &ipv6h->daddr, 0);
-- 
2.17.1

