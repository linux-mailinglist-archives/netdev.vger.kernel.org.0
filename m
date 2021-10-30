Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000DC4406DF
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 04:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhJ3CIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 22:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbhJ3CIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 22:08:39 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5055BC061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 19:06:10 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id bm16so11164799qkb.11
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 19:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WnUU/isj/uevdtWLb7sKx0+xdJI71Vr5BdggHN8JJSs=;
        b=PbXvB39mfZKouo7jNzNazdujCf1XE9LCEQD47mRBQDFbvizmoP0TdxizYsAbc8l2vz
         TfjKCk+Z9eNUa8px6jbhBG4zrq8CdkiQmfeBi2FukJvxw96uo4PH5ebLvwOVXv2ILYqr
         SACapEViBhil0RqqeARAyRxdeK94gOk3f265lgNFwF1preK12hoaNeQnSdueFI3oAd5h
         N7YjmPt0V+haQuYZtFYh4TP/3UPgpYPJpomWlsM3Sagp3dC3QaR780sp0R2L6KuvwNSh
         7XLsDtzfNVau7bLjjXCiajJRDtjxAWyaCsViAh8EkNyO/Mks3vUA3PE60nDgKzKh5FOc
         rapA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WnUU/isj/uevdtWLb7sKx0+xdJI71Vr5BdggHN8JJSs=;
        b=LlkzWesTw6m3XFeEgmUsv4njO9WJNEI1MIpGFtTW9cZlDZvjqwcwkWkL0O8l/i/zx/
         50rw4CVc5UhW7mbqP7hum2Tx2bSQzc0GtfilkkOTGwWJIbf8w+dp6ibuoEFE/U5G/6iB
         WLnHc344gj47YZAMoLBg5rok+1CbelS5NDfyZzSLvx9pW3zuVrkVIzPwB2L6BhPPC88z
         1jBsSQIRSybwUAemsxHpgKBczGdXHKF+o559W15N+wofhNI5v1h4J4wmci0DoxL5N0bt
         oDaj6b4WvG4fcmk9JOUvwvceSc644Ct9pcjajtNblug9yFozjbpY933LKWC+X3aA7Wls
         DztQ==
X-Gm-Message-State: AOAM530MQzDXnLSphSRPNDWB/QV/nCi8eSwvuV88Ebu9llg5C5ir66+R
        JHx9QJ4pVgAAr6lp84lC3v8=
X-Google-Smtp-Source: ABdhPJxDU/1BD7ah+kZUUResXH3mdxhGcaBhWVb5HGyZJdDcWHUizf8Zib4gPpn/G4ct8LBYQjPSxQ==
X-Received: by 2002:a05:620a:d85:: with SMTP id q5mr11923268qkl.64.1635559569486;
        Fri, 29 Oct 2021 19:06:09 -0700 (PDT)
Received: from talalahmad1.nyc.corp.google.com ([2620:0:1003:317:25ce:101f:81db:24e8])
        by smtp.gmail.com with ESMTPSA id az12sm5044391qkb.28.2021.10.29.19.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 19:06:09 -0700 (PDT)
From:   Talal Ahmad <mailtalalahmad@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com,
        willemb@google.com, dsahern@kernel.org, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, cong.wang@bytedance.com, haokexin@gmail.com,
        jonathan.lemon@gmail.com, alobakin@pm.me, pabeni@redhat.com,
        ilias.apalodimas@linaro.org, memxor@gmail.com, elver@google.com,
        nogikh@google.com, vvs@virtuozzo.com,
        Talal Ahmad <talalahmad@google.com>
Subject: [PATCH net-next v2 2/2] net: avoid double accounting for pure zerocopy skbs
Date:   Fri, 29 Oct 2021 22:05:42 -0400
Message-Id: <20211030020542.3870542-3-mailtalalahmad@gmail.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
In-Reply-To: <20211030020542.3870542-1-mailtalalahmad@gmail.com>
References: <20211030020542.3870542-1-mailtalalahmad@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Talal Ahmad <talalahmad@google.com>

Track skbs with only zerocopy data and avoid charging them to kernel
memory to correctly account the memory utilization for msg_zerocopy.
All of the data in such skbs is held in user pages which are already
accounted to user. Before this change, they are charged again in
kernel in __zerocopy_sg_from_iter. The charging in kernel is
excessive because data is not being copied into skb frags. This
excessive charging can lead to kernel going into memory pressure
state which impacts all sockets in the system adversely. Mark pure
zerocopy skbs with a SKBFL_PURE_ZEROCOPY flag and remove
charge/uncharge for data in such skbs.

Initially, an skb is marked pure zerocopy when it is empty and in
zerocopy path. skb can then change from a pure zerocopy skb to mixed
data skb (zerocopy and copy data) if it is at tail of write queue and
there is room available in it and non-zerocopy data is being sent in
the next sendmsg call. At this time sk_mem_charge is done for the pure
zerocopied data and the pure zerocopy flag is unmarked. We found that
this happens very rarely on workloads that pass MSG_ZEROCOPY.

A pure zerocopy skb can later be coalesced into normal skb if they are
next to each other in queue but this patch prevents coalescing from
happening. This avoids complexity of charging when skb downgrades from
pure zerocopy to mixed. This is also rare.

In sk_wmem_free_skb, if it is a pure zerocopy skb, an sk_mem_uncharge
for SKB_TRUESIZE(MAX_TCP_HEADER) is done for sk_mem_charge in
tcp_skb_entail for an skb without data.

Testing with the msg_zerocopy.c benchmark between two hosts(100G nics)
with zerocopy showed that before this patch the 'sock' variable in
memory.stat for cgroup2 that tracks sum of sk_forward_alloc,
sk_rmem_alloc and sk_wmem_queued is around 1822720 and with this
change it is 0. This is due to no charge to sk_forward_alloc for
zerocopy data and shows memory utilization for kernel is lowered.

Signed-off-by: Talal Ahmad <talalahmad@google.com>
Acked-by: Arjun Roy <arjunroy@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/skbuff.h | 19 ++++++++++++++++++-
 include/net/tcp.h      |  8 ++++++--
 net/core/datagram.c    |  3 ++-
 net/core/skbuff.c      |  3 ++-
 net/ipv4/tcp.c         | 22 ++++++++++++++++++++--
 net/ipv4/tcp_output.c  |  7 +++++--
 6 files changed, 53 insertions(+), 9 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0bd6520329f6..10869906cc57 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -454,9 +454,15 @@ enum {
 	 * all frags to avoid possible bad checksum
 	 */
 	SKBFL_SHARED_FRAG = BIT(1),
+
+	/* segment contains only zerocopy data and should not be
+	 * charged to the kernel memory.
+	 */
+	SKBFL_PURE_ZEROCOPY = BIT(2),
 };
 
 #define SKBFL_ZEROCOPY_FRAG	(SKBFL_ZEROCOPY_ENABLE | SKBFL_SHARED_FRAG)
+#define SKBFL_ALL_ZEROCOPY	(SKBFL_ZEROCOPY_FRAG | SKBFL_PURE_ZEROCOPY)
 
 /*
  * The callback notifies userspace to release buffers when skb DMA is done in
@@ -1464,6 +1470,17 @@ static inline struct ubuf_info *skb_zcopy(struct sk_buff *skb)
 	return is_zcopy ? skb_uarg(skb) : NULL;
 }
 
+static inline bool skb_zcopy_pure(const struct sk_buff *skb)
+{
+	return skb_shinfo(skb)->flags & SKBFL_PURE_ZEROCOPY;
+}
+
+static inline bool skb_pure_zcopy_same(const struct sk_buff *skb1,
+				       const struct sk_buff *skb2)
+{
+	return skb_zcopy_pure(skb1) == skb_zcopy_pure(skb2);
+}
+
 static inline void net_zcopy_get(struct ubuf_info *uarg)
 {
 	refcount_inc(&uarg->refcnt);
@@ -1528,7 +1545,7 @@ static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy_success)
 		if (!skb_zcopy_is_nouarg(skb))
 			uarg->callback(skb, uarg, zerocopy_success);
 
-		skb_shinfo(skb)->flags &= ~SKBFL_ZEROCOPY_FRAG;
+		skb_shinfo(skb)->flags &= ~SKBFL_ALL_ZEROCOPY;
 	}
 }
 
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 70972f3ac8fa..af91f370432e 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -293,7 +293,10 @@ static inline bool tcp_out_of_memory(struct sock *sk)
 static inline void tcp_wmem_free_skb(struct sock *sk, struct sk_buff *skb)
 {
 	sk_wmem_queued_add(sk, -skb->truesize);
-	sk_mem_uncharge(sk, skb->truesize);
+	if (!skb_zcopy_pure(skb))
+		sk_mem_uncharge(sk, skb->truesize);
+	else
+		sk_mem_uncharge(sk, SKB_TRUESIZE(MAX_TCP_HEADER));
 	__kfree_skb(skb);
 }
 
@@ -974,7 +977,8 @@ static inline bool tcp_skb_can_collapse(const struct sk_buff *to,
 					const struct sk_buff *from)
 {
 	return likely(tcp_skb_can_collapse_to(to) &&
-		      mptcp_skb_can_collapse(to, from));
+		      mptcp_skb_can_collapse(to, from) &&
+		      skb_pure_zcopy_same(to, from));
 }
 
 /* Events passed to congestion control interface */
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 15ab9ffb27fe..ee290776c661 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -646,7 +646,8 @@ int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 		skb->truesize += truesize;
 		if (sk && sk->sk_type == SOCK_STREAM) {
 			sk_wmem_queued_add(sk, truesize);
-			sk_mem_charge(sk, truesize);
+			if (!skb_zcopy_pure(skb))
+				sk_mem_charge(sk, truesize);
 		} else {
 			refcount_add(truesize, &skb->sk->sk_wmem_alloc);
 		}
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 67a9188d8a49..29e617d8d7fb 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3433,8 +3433,9 @@ static inline void skb_split_no_header(struct sk_buff *skb,
 void skb_split(struct sk_buff *skb, struct sk_buff *skb1, const u32 len)
 {
 	int pos = skb_headlen(skb);
+	const int zc_flags = SKBFL_SHARED_FRAG | SKBFL_PURE_ZEROCOPY;
 
-	skb_shinfo(skb1)->flags |= skb_shinfo(skb)->flags & SKBFL_SHARED_FRAG;
+	skb_shinfo(skb1)->flags |= skb_shinfo(skb)->flags & zc_flags;
 	skb_zerocopy_clone(skb1, skb, 0);
 	if (len < pos)	/* Split line is inside header. */
 		skb_split_inside_header(skb, skb1, len, pos);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index bc7f419184aa..2561c14a6e63 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -863,6 +863,7 @@ struct sk_buff *tcp_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
 	if (likely(skb)) {
 		bool mem_scheduled;
 
+		skb->truesize = SKB_TRUESIZE(size + MAX_TCP_HEADER);
 		if (force_schedule) {
 			mem_scheduled = true;
 			sk_forced_mem_schedule(sk, skb->truesize);
@@ -1319,6 +1320,15 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 			copy = min_t(int, copy, pfrag->size - pfrag->offset);
 
+			/* skb changing from pure zc to mixed, must charge zc */
+			if (unlikely(skb_zcopy_pure(skb))) {
+				if (!sk_wmem_schedule(sk, skb->data_len))
+					goto wait_for_space;
+
+				sk_mem_charge(sk, skb->data_len);
+				skb_shinfo(skb)->flags &= ~SKBFL_PURE_ZEROCOPY;
+			}
+
 			if (!sk_wmem_schedule(sk, copy))
 				goto wait_for_space;
 
@@ -1339,8 +1349,16 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			}
 			pfrag->offset += copy;
 		} else {
-			if (!sk_wmem_schedule(sk, copy))
-				goto wait_for_space;
+			/* First append to a fragless skb builds initial
+			 * pure zerocopy skb
+			 */
+			if (!skb->len)
+				skb_shinfo(skb)->flags |= SKBFL_PURE_ZEROCOPY;
+
+			if (!skb_zcopy_pure(skb)) {
+				if (!sk_wmem_schedule(sk, copy))
+					goto wait_for_space;
+			}
 
 			err = skb_zerocopy_iter_stream(sk, skb, msg, copy, uarg);
 			if (err == -EMSGSIZE || err == -EEXIST) {
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6fbbf1558033..287b57aadc37 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1677,7 +1677,8 @@ int tcp_trim_head(struct sock *sk, struct sk_buff *skb, u32 len)
 	if (delta_truesize) {
 		skb->truesize	   -= delta_truesize;
 		sk_wmem_queued_add(sk, -delta_truesize);
-		sk_mem_uncharge(sk, delta_truesize);
+		if (!skb_zcopy_pure(skb))
+			sk_mem_uncharge(sk, delta_truesize);
 	}
 
 	/* Any change of skb->len requires recalculation of tso factor. */
@@ -2295,7 +2296,9 @@ static bool tcp_can_coalesce_send_queue_head(struct sock *sk, int len)
 		if (len <= skb->len)
 			break;
 
-		if (unlikely(TCP_SKB_CB(skb)->eor) || tcp_has_tx_tstamp(skb))
+		if (unlikely(TCP_SKB_CB(skb)->eor) ||
+		    tcp_has_tx_tstamp(skb) ||
+		    !skb_pure_zcopy_same(skb, next))
 			return false;
 
 		len -= skb->len;
-- 
2.33.1.1089.g2158813163f-goog

