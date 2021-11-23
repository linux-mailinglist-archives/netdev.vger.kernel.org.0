Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0128545AF93
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 23:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhKWW7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 17:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhKWW71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 17:59:27 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E03C061714
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 14:56:18 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id h63so370818pgc.12
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 14:56:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9jZ9SC7bifcCNJTyxULmXq+yd0s9LQHsNQXWkUcJfsI=;
        b=pJArH36nk4zk6iLGombW0xAxmgWyDJNva6CUK5ibIC7gd6sVMr7qWoc4YdTUxWjW4j
         iy7PnEMtf9SDemAayfA2sXjqaKujz0Rd9asMZtBY1EcnQ0c3soXuouw9YnR4QLHMlQEm
         34G3EKHefBE+cQnJCJxMiyr4r88cb/UEK7Rm5GAZjv3/m8WP6MaqGbLhTL1peR1ZWrd5
         V8Ob1QouRmpxieN/vfhX2egI8gKqiH9BfW3WCm/WIctNlfL/SQotoDw/ZBEhFdnUznrB
         uQXXVxUgFuBcWRYjOHDqFuocXUHTRrqAPxhe8X05Uxrm5mn/7AvVvwrJ3yRRgfQexssB
         oXow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9jZ9SC7bifcCNJTyxULmXq+yd0s9LQHsNQXWkUcJfsI=;
        b=OucXAT5phHVBJ0pdEG+ZNK0UsHssflcBdpFPuVZIYfieEPbBzlUf2a8puSmQQ+wQU1
         sRe2BL7uZca2DdtzYy2DuklL8NJoOxGHTUEcyLh8shSbs1OfjkLgHWELQPzdHWPLHnXX
         kvzR4/lRbEO4EedJYsQ1Lfo2NAM6LZeZcjWa3GnBSUsioKVAdXGIIuPudX+Ltmah40NR
         p2plDXB/U8P1GbmjWiQDyIxMzVWZsJCskE8RETBwLi0+4F0kkUybppz5IVXG03tFNZzK
         V89wx8JEuYGARDMWGasOuUMu+EXQu2jmUAbSe8rWknEitCEKLKrTcZ4djeZk2EjVbhgi
         z8Rg==
X-Gm-Message-State: AOAM532fhRKDIPxgau8lDLkCXk2lA5V97J1p4NaP/DgX5xRaoybttb7h
        T88J1Zr2RNai6Ak9vVzw1qM=
X-Google-Smtp-Source: ABdhPJxYL34O1db1/2Tj2n6AMhrcqu/bf9QtPoAEGimsVzHAxdVlPAXb8Rp6A8k9bGotnNwqvRhvfg==
X-Received: by 2002:a63:8e:: with SMTP id 136mr6377957pga.424.1637708178490;
        Tue, 23 Nov 2021 14:56:18 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8b31:9924:47bf:5e47])
        by smtp.gmail.com with ESMTPSA id u6sm14342185pfg.157.2021.11.23.14.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 14:56:18 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/2] gro: remove rcu_read_lock/rcu_read_unlock from gro_receive handlers
Date:   Tue, 23 Nov 2021 14:56:07 -0800
Message-Id: <20211123225608.2155163-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211123225608.2155163-1-eric.dumazet@gmail.com>
References: <20211123225608.2155163-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

All gro_receive() handlers are called from dev_gro_receive()
while rcu_read_lock() has been called.

There is no point stacking more rcu_read_lock()

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/geneve.c   |  5 +----
 net/8021q/vlan_core.c  |  5 +----
 net/ethernet/eth.c     |  5 +----
 net/ipv4/af_inet.c     | 12 ++++--------
 net/ipv4/fou.c         | 12 +++---------
 net/ipv4/gre_offload.c |  9 +++------
 net/ipv4/udp_offload.c |  2 --
 net/ipv6/ip6_offload.c |  6 +-----
 net/ipv6/udp_offload.c |  2 --
 9 files changed, 14 insertions(+), 44 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 9d26d1b965d221c7eefbce47fc5e504b7f35cff6..9caff2e01d19751bbd4a05bf5e204a16dde8a779 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -517,18 +517,15 @@ static struct sk_buff *geneve_gro_receive(struct sock *sk,
 
 	type = gh->proto_type;
 
-	rcu_read_lock();
 	ptype = gro_find_receive_by_type(type);
 	if (!ptype)
-		goto out_unlock;
+		goto out;
 
 	skb_gro_pull(skb, gh_len);
 	skb_gro_postpull_rcsum(skb, gh, gh_len);
 	pp = call_gro_receive(ptype->callbacks.gro_receive, head, skb);
 	flush = 0;
 
-out_unlock:
-	rcu_read_unlock();
 out:
 	skb_gro_flush_final(skb, pp, flush);
 
diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index 59bc13b5f14f6a24bef0b8916f67101ce8dc4376..534eebb5a2e6d10b8ecd893f0ed5e1dc2113f036 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -476,10 +476,9 @@ static struct sk_buff *vlan_gro_receive(struct list_head *head,
 
 	type = vhdr->h_vlan_encapsulated_proto;
 
-	rcu_read_lock();
 	ptype = gro_find_receive_by_type(type);
 	if (!ptype)
-		goto out_unlock;
+		goto out;
 
 	flush = 0;
 
@@ -501,8 +500,6 @@ static struct sk_buff *vlan_gro_receive(struct list_head *head,
 					    ipv6_gro_receive, inet_gro_receive,
 					    head, skb);
 
-out_unlock:
-	rcu_read_unlock();
 out:
 	skb_gro_flush_final(skb, pp, flush);
 
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index c7d9e08107cb437240e3e3ef1c3e564046400570..d4fa2f152efcbd7faf98ba4364e65cad8619ec1f 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -436,11 +436,10 @@ struct sk_buff *eth_gro_receive(struct list_head *head, struct sk_buff *skb)
 
 	type = eh->h_proto;
 
-	rcu_read_lock();
 	ptype = gro_find_receive_by_type(type);
 	if (ptype == NULL) {
 		flush = 1;
-		goto out_unlock;
+		goto out;
 	}
 
 	skb_gro_pull(skb, sizeof(*eh));
@@ -450,8 +449,6 @@ struct sk_buff *eth_gro_receive(struct list_head *head, struct sk_buff *skb)
 					    ipv6_gro_receive, inet_gro_receive,
 					    head, skb);
 
-out_unlock:
-	rcu_read_unlock();
 out:
 	skb_gro_flush_final(skb, pp, flush);
 
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index c66b0563a267546ccd045dda10fbd854a21fe5ce..7afd8c8b25e043b6cb6638b74f715ab65254da64 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1452,19 +1452,18 @@ struct sk_buff *inet_gro_receive(struct list_head *head, struct sk_buff *skb)
 
 	proto = iph->protocol;
 
-	rcu_read_lock();
 	ops = rcu_dereference(inet_offloads[proto]);
 	if (!ops || !ops->callbacks.gro_receive)
-		goto out_unlock;
+		goto out;
 
 	if (*(u8 *)iph != 0x45)
-		goto out_unlock;
+		goto out;
 
 	if (ip_is_fragment(iph))
-		goto out_unlock;
+		goto out;
 
 	if (unlikely(ip_fast_csum((u8 *)iph, 5)))
-		goto out_unlock;
+		goto out;
 
 	id = ntohl(*(__be32 *)&iph->id);
 	flush = (u16)((ntohl(*(__be32 *)iph) ^ skb_gro_len(skb)) | (id & ~IP_DF));
@@ -1541,9 +1540,6 @@ struct sk_buff *inet_gro_receive(struct list_head *head, struct sk_buff *skb)
 	pp = indirect_call_gro_receive(tcp4_gro_receive, udp4_gro_receive,
 				       ops->callbacks.gro_receive, head, skb);
 
-out_unlock:
-	rcu_read_unlock();
-
 out:
 	skb_gro_flush_final(skb, pp, flush);
 
diff --git a/net/ipv4/fou.c b/net/ipv4/fou.c
index b56d6b40c0a26f3b70226937779e355b504b79bd..6ebc345e6001c2b76926576acd6377ea6abeefbe 100644
--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -247,17 +247,14 @@ static struct sk_buff *fou_gro_receive(struct sock *sk,
 	/* Flag this frame as already having an outer encap header */
 	NAPI_GRO_CB(skb)->is_fou = 1;
 
-	rcu_read_lock();
 	offloads = NAPI_GRO_CB(skb)->is_ipv6 ? inet6_offloads : inet_offloads;
 	ops = rcu_dereference(offloads[proto]);
 	if (!ops || !ops->callbacks.gro_receive)
-		goto out_unlock;
+		goto out;
 
 	pp = call_gro_receive(ops->callbacks.gro_receive, head, skb);
 
-out_unlock:
-	rcu_read_unlock();
-
+out:
 	return pp;
 }
 
@@ -439,17 +436,14 @@ static struct sk_buff *gue_gro_receive(struct sock *sk,
 	/* Flag this frame as already having an outer encap header */
 	NAPI_GRO_CB(skb)->is_fou = 1;
 
-	rcu_read_lock();
 	offloads = NAPI_GRO_CB(skb)->is_ipv6 ? inet6_offloads : inet_offloads;
 	ops = rcu_dereference(offloads[proto]);
 	if (WARN_ON_ONCE(!ops || !ops->callbacks.gro_receive))
-		goto out_unlock;
+		goto out;
 
 	pp = call_gro_receive(ops->callbacks.gro_receive, head, skb);
 	flush = 0;
 
-out_unlock:
-	rcu_read_unlock();
 out:
 	skb_gro_flush_final_remcsum(skb, pp, flush, &grc);
 
diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index 740298dac7d32f7bef1d69214d65c665c18b649c..c6b5d327e3e14de1a0a77dbb6c53acced157bcfb 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -163,10 +163,9 @@ static struct sk_buff *gre_gro_receive(struct list_head *head,
 
 	type = greh->protocol;
 
-	rcu_read_lock();
 	ptype = gro_find_receive_by_type(type);
 	if (!ptype)
-		goto out_unlock;
+		goto out;
 
 	grehlen = GRE_HEADER_SECTION;
 
@@ -180,13 +179,13 @@ static struct sk_buff *gre_gro_receive(struct list_head *head,
 	if (skb_gro_header_hard(skb, hlen)) {
 		greh = skb_gro_header_slow(skb, hlen, off);
 		if (unlikely(!greh))
-			goto out_unlock;
+			goto out;
 	}
 
 	/* Don't bother verifying checksum if we're going to flush anyway. */
 	if ((greh->flags & GRE_CSUM) && !NAPI_GRO_CB(skb)->flush) {
 		if (skb_gro_checksum_simple_validate(skb))
-			goto out_unlock;
+			goto out;
 
 		skb_gro_checksum_try_convert(skb, IPPROTO_GRE,
 					     null_compute_pseudo);
@@ -230,8 +229,6 @@ static struct sk_buff *gre_gro_receive(struct list_head *head,
 	pp = call_gro_receive(ptype->callbacks.gro_receive, head, skb);
 	flush = 0;
 
-out_unlock:
-	rcu_read_unlock();
 out:
 	skb_gro_flush_final(skb, pp, flush);
 
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index cbeb8965d1b771b4d50c888a42279287904304e9..3be5c083879d98a6c100b05635d0818c328ced31 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -628,13 +628,11 @@ struct sk_buff *udp4_gro_receive(struct list_head *head, struct sk_buff *skb)
 					     inet_gro_compute_pseudo);
 skip:
 	NAPI_GRO_CB(skb)->is_ipv6 = 0;
-	rcu_read_lock();
 
 	if (static_branch_unlikely(&udp_encap_needed_key))
 		sk = udp4_gro_lookup_skb(skb, uh->source, uh->dest);
 
 	pp = udp_gro_receive(head, skb, uh, sk);
-	rcu_read_unlock();
 	return pp;
 
 flush:
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index 1b9827ff8ccf48e61e233e39d671aa67c8fff0ab..67b9ba5e159c3a83207310d2d0b7a42557da895b 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -208,7 +208,6 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
 
 	flush += ntohs(iph->payload_len) != skb_gro_len(skb);
 
-	rcu_read_lock();
 	proto = iph->nexthdr;
 	ops = rcu_dereference(inet6_offloads[proto]);
 	if (!ops || !ops->callbacks.gro_receive) {
@@ -221,7 +220,7 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
 
 		ops = rcu_dereference(inet6_offloads[proto]);
 		if (!ops || !ops->callbacks.gro_receive)
-			goto out_unlock;
+			goto out;
 
 		iph = ipv6_hdr(skb);
 	}
@@ -279,9 +278,6 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
 	pp = indirect_call_gro_receive_l4(tcp6_gro_receive, udp6_gro_receive,
 					 ops->callbacks.gro_receive, head, skb);
 
-out_unlock:
-	rcu_read_unlock();
-
 out:
 	skb_gro_flush_final(skb, pp, flush);
 
diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index 50a8a65fad2324d124bcd26eaa93b1ffb9cccc7f..7720d04ed396d0e190561e4d608cf5a7857050d8 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -145,13 +145,11 @@ struct sk_buff *udp6_gro_receive(struct list_head *head, struct sk_buff *skb)
 
 skip:
 	NAPI_GRO_CB(skb)->is_ipv6 = 1;
-	rcu_read_lock();
 
 	if (static_branch_unlikely(&udpv6_encap_needed_key))
 		sk = udp6_gro_lookup_skb(skb, uh->source, uh->dest);
 
 	pp = udp_gro_receive(head, skb, uh, sk);
-	rcu_read_unlock();
 	return pp;
 
 flush:
-- 
2.34.0.rc2.393.gf8c9666880-goog

