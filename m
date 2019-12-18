Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC48312487E
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 14:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfLRNfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 08:35:17 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:34890 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726774AbfLRNfL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 08:35:11 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2EC7F200A7;
        Wed, 18 Dec 2019 14:35:10 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hTGlPLb4rcnQ; Wed, 18 Dec 2019 14:35:09 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 7E5102008D;
        Wed, 18 Dec 2019 14:35:09 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 18 Dec 2019
 14:35:09 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 4A9FF31809F4;
 Wed, 18 Dec 2019 14:35:09 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Subash Abhinov Kasiviswanathan" <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next 4/4] udp: Support UDP fraglist GRO/GSO.
Date:   Wed, 18 Dec 2019 14:34:58 +0100
Message-ID: <20191218133458.14533-5-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191218133458.14533-1-steffen.klassert@secunet.com>
References: <20191218133458.14533-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends UDP GRO to support fraglist GRO/GSO
by using the previously introduced infrastructure.
If the feature is enabled, all UDP packets are going to
fraglist GRO (local input and forward).

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/udp.h      |  2 +-
 net/ipv4/udp_offload.c | 99 ++++++++++++++++++++++++++++++++----------
 net/ipv6/udp_offload.c | 19 +++++++-
 3 files changed, 94 insertions(+), 26 deletions(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index bad74f780831..44e0e52b585c 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -167,7 +167,7 @@ typedef struct sock *(*udp_lookup_t)(struct sk_buff *skb, __be16 sport,
 				     __be16 dport);
 
 struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
-				struct udphdr *uh, udp_lookup_t lookup);
+				struct udphdr *uh, struct sock *sk);
 int udp_gro_complete(struct sk_buff *skb, int nhoff, udp_lookup_t lookup);
 
 struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index a3908e55ed89..03c67d37a5e5 100644
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
@@ -383,14 +400,40 @@ static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
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
+				if ((skb->ip_summed != p->ip_summed) ||
+				    (skb->csum_level != p->csum_level)) {
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
 
@@ -401,36 +444,29 @@ static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
 	return NULL;
 }
 
-INDIRECT_CALLABLE_DECLARE(struct sock *udp6_lib_lookup_skb(struct sk_buff *skb,
-						   __be16 sport, __be16 dport));
 struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
-				struct udphdr *uh, udp_lookup_t lookup)
+				struct udphdr *uh, struct sock *sk)
 {
 	struct sk_buff *pp = NULL;
 	struct sk_buff *p;
 	struct udphdr *uh2;
 	unsigned int off = skb_gro_offset(skb);
 	int flush = 1;
-	struct sock *sk;
 
-	rcu_read_lock();
-	sk = INDIRECT_CALL_INET(lookup, udp6_lib_lookup_skb,
-				udp4_lib_lookup_skb, skb, uh->source, uh->dest);
-	if (!sk)
-		goto out_unlock;
+	if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
+		NAPI_GRO_CB(skb)->is_flist = sk ? !udp_sk(sk)->gro_enabled: 1;
 
-	if (udp_sk(sk)->gro_enabled) {
+	if ((sk && udp_sk(sk)->gro_enabled) ||  NAPI_GRO_CB(skb)->is_flist) {
 		pp = call_gro_receive(udp_gro_receive_segment, head, skb);
-		rcu_read_unlock();
 		return pp;
 	}
 
-	if (NAPI_GRO_CB(skb)->encap_mark ||
+	if (!sk || NAPI_GRO_CB(skb)->encap_mark ||
 	    (skb->ip_summed != CHECKSUM_PARTIAL &&
 	     NAPI_GRO_CB(skb)->csum_cnt == 0 &&
 	     !NAPI_GRO_CB(skb)->csum_valid) ||
 	    !udp_sk(sk)->gro_receive)
-		goto out_unlock;
+		goto out;
 
 	/* mark that this skb passed once through the tunnel gro layer */
 	NAPI_GRO_CB(skb)->encap_mark = 1;
@@ -457,8 +493,7 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
 	skb_gro_postpull_rcsum(skb, uh, sizeof(struct udphdr));
 	pp = call_gro_receive_sk(udp_sk(sk)->gro_receive, sk, head, skb);
 
-out_unlock:
-	rcu_read_unlock();
+out:
 	skb_gro_flush_final(skb, pp, flush);
 	return pp;
 }
@@ -468,8 +503,10 @@ INDIRECT_CALLABLE_SCOPE
 struct sk_buff *udp4_gro_receive(struct list_head *head, struct sk_buff *skb)
 {
 	struct udphdr *uh = udp_gro_udphdr(skb);
+	struct sk_buff *pp;
+	struct sock *sk;
 
-	if (unlikely(!uh) || !static_branch_unlikely(&udp_encap_needed_key))
+	if (unlikely(!uh))
 		goto flush;
 
 	/* Don't bother verifying checksum if we're going to flush anyway. */
@@ -484,7 +521,11 @@ struct sk_buff *udp4_gro_receive(struct list_head *head, struct sk_buff *skb)
 					     inet_gro_compute_pseudo);
 skip:
 	NAPI_GRO_CB(skb)->is_ipv6 = 0;
-	return udp_gro_receive(head, skb, uh, udp4_lib_lookup_skb);
+	rcu_read_lock();
+	sk = static_branch_unlikely(&udp_encap_needed_key) ? udp4_lib_lookup_skb(skb, uh->source, uh->dest) : NULL;
+	pp = udp_gro_receive(head, skb, uh, sk);
+	rcu_read_unlock();
+	return pp;
 
 flush:
 	NAPI_GRO_CB(skb)->flush = 1;
@@ -517,9 +558,7 @@ int udp_gro_complete(struct sk_buff *skb, int nhoff,
 	rcu_read_lock();
 	sk = INDIRECT_CALL_INET(lookup, udp6_lib_lookup_skb,
 				udp4_lib_lookup_skb, skb, uh->source, uh->dest);
-	if (sk && udp_sk(sk)->gro_enabled) {
-		err = udp_gro_complete_segment(skb);
-	} else if (sk && udp_sk(sk)->gro_complete) {
+	if (sk && udp_sk(sk)->gro_complete) {
 		skb_shinfo(skb)->gso_type = uh->check ? SKB_GSO_UDP_TUNNEL_CSUM
 					: SKB_GSO_UDP_TUNNEL;
 
@@ -529,6 +568,8 @@ int udp_gro_complete(struct sk_buff *skb, int nhoff,
 		skb->encapsulation = 1;
 		err = udp_sk(sk)->gro_complete(sk, skb,
 				nhoff + sizeof(struct udphdr));
+	} else {
+		err = udp_gro_complete_segment(skb);
 	}
 	rcu_read_unlock();
 
@@ -544,6 +585,18 @@ INDIRECT_CALLABLE_SCOPE int udp4_gro_complete(struct sk_buff *skb, int nhoff)
 	const struct iphdr *iph = ip_hdr(skb);
 	struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
 
+	if (NAPI_GRO_CB(skb)->is_flist) {
+		uh->len = htons(skb->len - nhoff);
+
+		skb_shinfo(skb)->gso_type |= (SKB_GSO_FRAGLIST|SKB_GSO_UDP_L4);
+		skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
+
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+		skb->csum_level = ~0;
+
+		return 0;
+	}
+
 	if (uh->check)
 		uh->check = ~udp_v4_check(skb->len - nhoff, iph->saddr,
 					  iph->daddr, 0);
diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index 64b8f05d6735..8836f2b69ef3 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -115,8 +115,10 @@ INDIRECT_CALLABLE_SCOPE
 struct sk_buff *udp6_gro_receive(struct list_head *head, struct sk_buff *skb)
 {
 	struct udphdr *uh = udp_gro_udphdr(skb);
+	struct sk_buff *pp;
+	struct sock *sk;
 
-	if (unlikely(!uh) || !static_branch_unlikely(&udpv6_encap_needed_key))
+	if (unlikely(!uh))
 		goto flush;
 
 	/* Don't bother verifying checksum if we're going to flush anyway. */
@@ -132,7 +134,11 @@ struct sk_buff *udp6_gro_receive(struct list_head *head, struct sk_buff *skb)
 
 skip:
 	NAPI_GRO_CB(skb)->is_ipv6 = 1;
-	return udp_gro_receive(head, skb, uh, udp6_lib_lookup_skb);
+	rcu_read_lock();
+	sk = static_branch_unlikely(&udpv6_encap_needed_key) ? udp6_lib_lookup_skb(skb, uh->source, uh->dest) : NULL;
+	pp = udp_gro_receive(head, skb, uh, sk);
+	rcu_read_unlock();
+	return pp;
 
 flush:
 	NAPI_GRO_CB(skb)->flush = 1;
@@ -144,6 +150,15 @@ INDIRECT_CALLABLE_SCOPE int udp6_gro_complete(struct sk_buff *skb, int nhoff)
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

