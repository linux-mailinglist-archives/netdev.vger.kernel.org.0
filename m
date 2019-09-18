Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC58B5DF9
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 09:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbfIRHZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 03:25:40 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:60584 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728707AbfIRHZk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 03:25:40 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id DCC5F2056D;
        Wed, 18 Sep 2019 09:25:38 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FVR9UwjVMMxh; Wed, 18 Sep 2019 09:25:38 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 86F19205B5;
        Wed, 18 Sep 2019 09:25:37 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 18 Sep 2019
 09:25:35 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 288E0318001B;
 Wed, 18 Sep 2019 09:25:37 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <netdev@vger.kernel.org>
CC:     Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH RFC v3 1/5] UDP: enable GRO by default.
Date:   Wed, 18 Sep 2019 09:25:13 +0200
Message-ID: <20190918072517.16037-2-steffen.klassert@secunet.com>
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

This patch enables UDP GRO regardless if a GRO capable
socket is present. With this GRO is done by default
for the local input and forwarding path.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/udp.h      |  2 +-
 net/ipv4/udp_offload.c | 33 ++++++++++++++-------------------
 net/ipv6/udp_offload.c | 10 ++++++++--
 3 files changed, 23 insertions(+), 22 deletions(-)

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
index a3908e55ed89..e0b835890507 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -401,35 +401,24 @@ static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
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
-
-	rcu_read_lock();
-	sk = INDIRECT_CALL_INET(lookup, udp6_lib_lookup_skb,
-				udp4_lib_lookup_skb, skb, uh->source, uh->dest);
-	if (!sk)
-		goto out_unlock;
 
-	if (udp_sk(sk)->gro_enabled) {
+	if (!sk || !udp_sk(sk)->gro_receive) {
 		pp = call_gro_receive(udp_gro_receive_segment, head, skb);
-		rcu_read_unlock();
 		return pp;
 	}
 
 	if (NAPI_GRO_CB(skb)->encap_mark ||
 	    (skb->ip_summed != CHECKSUM_PARTIAL &&
 	     NAPI_GRO_CB(skb)->csum_cnt == 0 &&
-	     !NAPI_GRO_CB(skb)->csum_valid) ||
-	    !udp_sk(sk)->gro_receive)
+	     !NAPI_GRO_CB(skb)->csum_valid))
 		goto out_unlock;
 
 	/* mark that this skb passed once through the tunnel gro layer */
@@ -468,8 +457,10 @@ INDIRECT_CALLABLE_SCOPE
 struct sk_buff *udp4_gro_receive(struct list_head *head, struct sk_buff *skb)
 {
 	struct udphdr *uh = udp_gro_udphdr(skb);
+	struct sk_buff *pp;
+	struct sock *sk;
 
-	if (unlikely(!uh) || !static_branch_unlikely(&udp_encap_needed_key))
+	if (unlikely(!uh))
 		goto flush;
 
 	/* Don't bother verifying checksum if we're going to flush anyway. */
@@ -484,7 +475,11 @@ struct sk_buff *udp4_gro_receive(struct list_head *head, struct sk_buff *skb)
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
@@ -517,9 +512,7 @@ int udp_gro_complete(struct sk_buff *skb, int nhoff,
 	rcu_read_lock();
 	sk = INDIRECT_CALL_INET(lookup, udp6_lib_lookup_skb,
 				udp4_lib_lookup_skb, skb, uh->source, uh->dest);
-	if (sk && udp_sk(sk)->gro_enabled) {
-		err = udp_gro_complete_segment(skb);
-	} else if (sk && udp_sk(sk)->gro_complete) {
+	if (sk && udp_sk(sk)->gro_complete) {
 		skb_shinfo(skb)->gso_type = uh->check ? SKB_GSO_UDP_TUNNEL_CSUM
 					: SKB_GSO_UDP_TUNNEL;
 
@@ -529,6 +522,8 @@ int udp_gro_complete(struct sk_buff *skb, int nhoff,
 		skb->encapsulation = 1;
 		err = udp_sk(sk)->gro_complete(sk, skb,
 				nhoff + sizeof(struct udphdr));
+	} else {
+		err = udp_gro_complete_segment(skb);
 	}
 	rcu_read_unlock();
 
diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index 64b8f05d6735..47a3b1348371 100644
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
+	sk = static_branch_unlikely(&udp_encap_needed_key) ? udp6_lib_lookup_skb(skb, uh->source, uh->dest) : NULL;
+	pp = udp_gro_receive(head, skb, uh, sk);
+	rcu_read_unlock();
+	return pp;
 
 flush:
 	NAPI_GRO_CB(skb)->flush = 1;
-- 
2.17.1

