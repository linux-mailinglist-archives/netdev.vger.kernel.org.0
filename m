Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B93BD37D3
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 05:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfJKDSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 23:18:35 -0400
Received: from mail-ua1-f73.google.com ([209.85.222.73]:45083 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbfJKDSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 23:18:34 -0400
Received: by mail-ua1-f73.google.com with SMTP id j13so2186854uag.12
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 20:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=aiZd6qh3Kh+ZJjPQO3ecSHRneKdC5DqmN1qTHhKatX8=;
        b=cm4qXCfkxh2nHmKYBx6RFYvONBcvbL63NkGppqRC/oaHdihxiIOz+yZlMfeH81fgVv
         AsO2wDuOTBWXcRIniZf8mIPWYA5Jo9ZIjFOrEQ7snBb7elmiMD/wP9uX6SKKJQ4HdEkU
         3Pg0ruTUqEpqgLGOsQATxLMF0O9h79Lte+MUA3a11Pkg06uNw1N65E5CqZkLQDCHP4C0
         RepZJwdP1T74aUNUYlVtf76PF5A7H6G8H9Q3pMg+rYCBvPxrNPZLdBWmQYJ6JsBkExkL
         6RAJEPAURSlZPTO70ELZPQ274kzUtdlfyAebvO9io3OfeXAH9beL+gtuG6e34s7NNTd2
         mxjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aiZd6qh3Kh+ZJjPQO3ecSHRneKdC5DqmN1qTHhKatX8=;
        b=DBXJgXIx9AaxJ0LpMtod8qJbt2eEoIttr8GVwepC+zG2mfrrwR3J0U4z02LZxBaKTh
         5sY1V32ExQ6M09PNZyvpSfq/Ed2OKN7oBnMUsKTqd1Go3N6PZVVQknpZEKsHvy/oj0h5
         SDbnxhgA0PPNsXsUp5AyLjjCS/ZFrsxpC7EMvlkZIVQZfUP03ritlWy41Dih5KeAdhik
         apD6gLgeZ3RW36bbHeLDZM/76Wnx8TqNBeJzbaSWy+3psSlHQjPZEygLGYWYbUNf6PQ9
         t/N8qYcrcXqvX4u80Uhm5vHjEaD068M+W0mnPirtQvD4HBm119oTqVnZHpPbZLYUjMCf
         quGw==
X-Gm-Message-State: APjAAAV8zoPnyBHPzIhjLZGAv7BOlsysoSORrTpkiUtQ92uB1588rXzD
        MCntcmERMeyDuH5hlWZpPGtxfxiNwjQk2Q==
X-Google-Smtp-Source: APXvYqw6YPNT4gSxy7cLT37jred9J1b1hV1m2GH3C6JQO1T/JoWMYVq5dqr8UNb8+reV+t5RGbSrstPesfI2fA==
X-Received: by 2002:a67:f80e:: with SMTP id l14mr7388074vso.61.1570763913400;
 Thu, 10 Oct 2019 20:18:33 -0700 (PDT)
Date:   Thu, 10 Oct 2019 20:17:46 -0700
In-Reply-To: <20191011031746.16220-1-edumazet@google.com>
Message-Id: <20191011031746.16220-10-edumazet@google.com>
Mime-Version: 1.0
References: <20191011031746.16220-1-edumazet@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH net 9/9] tcp: annotate sk->sk_wmem_queued lockless reads
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the sake of tcp_poll(), there are few places where we fetch
sk->sk_wmem_queued while this field can change from IRQ or other cpu.

We need to add READ_ONCE() annotations, and also make sure write
sides use corresponding WRITE_ONCE() to avoid store-tearing.

sk_wmem_queued_add() helper is added so that we can in
the future convert to ADD_ONCE() or equivalent if/when
available.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h          | 15 ++++++++++-----
 include/trace/events/sock.h |  2 +-
 net/core/datagram.c         |  2 +-
 net/core/sock.c             |  2 +-
 net/ipv4/inet_diag.c        |  2 +-
 net/ipv4/tcp.c              |  4 ++--
 net/ipv4/tcp_output.c       | 14 +++++++-------
 net/sched/em_meta.c         |  2 +-
 8 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 3d1e7502333e7ea0ff866f8982048800193caf33..f69b58bff7e5c69537444d99d68db5afc3abfa27 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -878,12 +878,17 @@ static inline bool sk_acceptq_is_full(const struct sock *sk)
  */
 static inline int sk_stream_min_wspace(const struct sock *sk)
 {
-	return sk->sk_wmem_queued >> 1;
+	return READ_ONCE(sk->sk_wmem_queued) >> 1;
 }
 
 static inline int sk_stream_wspace(const struct sock *sk)
 {
-	return READ_ONCE(sk->sk_sndbuf) - sk->sk_wmem_queued;
+	return READ_ONCE(sk->sk_sndbuf) - READ_ONCE(sk->sk_wmem_queued);
+}
+
+static inline void sk_wmem_queued_add(struct sock *sk, int val)
+{
+	WRITE_ONCE(sk->sk_wmem_queued, sk->sk_wmem_queued + val);
 }
 
 void sk_stream_write_space(struct sock *sk);
@@ -1207,7 +1212,7 @@ static inline void sk_refcnt_debug_release(const struct sock *sk)
 
 static inline bool __sk_stream_memory_free(const struct sock *sk, int wake)
 {
-	if (sk->sk_wmem_queued >= READ_ONCE(sk->sk_sndbuf))
+	if (READ_ONCE(sk->sk_wmem_queued) >= READ_ONCE(sk->sk_sndbuf))
 		return false;
 
 	return sk->sk_prot->stream_memory_free ?
@@ -1467,7 +1472,7 @@ DECLARE_STATIC_KEY_FALSE(tcp_tx_skb_cache_key);
 static inline void sk_wmem_free_skb(struct sock *sk, struct sk_buff *skb)
 {
 	sock_set_flag(sk, SOCK_QUEUE_SHRUNK);
-	sk->sk_wmem_queued -= skb->truesize;
+	sk_wmem_queued_add(sk, -skb->truesize);
 	sk_mem_uncharge(sk, skb->truesize);
 	if (static_branch_unlikely(&tcp_tx_skb_cache_key) &&
 	    !sk->sk_tx_skb_cache && !skb_cloned(skb)) {
@@ -2014,7 +2019,7 @@ static inline int skb_copy_to_page_nocache(struct sock *sk, struct iov_iter *fro
 	skb->len	     += copy;
 	skb->data_len	     += copy;
 	skb->truesize	     += copy;
-	sk->sk_wmem_queued   += copy;
+	sk_wmem_queued_add(sk, copy);
 	sk_mem_charge(sk, copy);
 	return 0;
 }
diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
index f720c32e7dfd6f41c04194318d6c3f2e68b821cb..51fe9f6719eb13d872054676078df87e293fcd01 100644
--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -115,7 +115,7 @@ TRACE_EVENT(sock_exceed_buf_limit,
 		__entry->rmem_alloc = atomic_read(&sk->sk_rmem_alloc);
 		__entry->sysctl_wmem = sk_get_wmem0(sk, prot);
 		__entry->wmem_alloc = refcount_read(&sk->sk_wmem_alloc);
-		__entry->wmem_queued = sk->sk_wmem_queued;
+		__entry->wmem_queued = READ_ONCE(sk->sk_wmem_queued);
 		__entry->kind = kind;
 	),
 
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 4cc8dc5db2b73471ae3a15fda753912d5e869624..c210fc116103d9915a2a4abc5225e0eb75825b0b 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -640,7 +640,7 @@ int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 		skb->len += copied;
 		skb->truesize += truesize;
 		if (sk && sk->sk_type == SOCK_STREAM) {
-			sk->sk_wmem_queued += truesize;
+			sk_wmem_queued_add(sk, truesize);
 			sk_mem_charge(sk, truesize);
 		} else {
 			refcount_add(truesize, &skb->sk->sk_wmem_alloc);
diff --git a/net/core/sock.c b/net/core/sock.c
index cd075bc86407a5816bd448521955525ebe941694..a515392ba84b67b2bf5400e0cfb7c3454fa87af8 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3212,7 +3212,7 @@ void sk_get_meminfo(const struct sock *sk, u32 *mem)
 	mem[SK_MEMINFO_WMEM_ALLOC] = sk_wmem_alloc_get(sk);
 	mem[SK_MEMINFO_SNDBUF] = READ_ONCE(sk->sk_sndbuf);
 	mem[SK_MEMINFO_FWD_ALLOC] = sk->sk_forward_alloc;
-	mem[SK_MEMINFO_WMEM_QUEUED] = sk->sk_wmem_queued;
+	mem[SK_MEMINFO_WMEM_QUEUED] = READ_ONCE(sk->sk_wmem_queued);
 	mem[SK_MEMINFO_OPTMEM] = atomic_read(&sk->sk_omem_alloc);
 	mem[SK_MEMINFO_BACKLOG] = READ_ONCE(sk->sk_backlog.len);
 	mem[SK_MEMINFO_DROPS] = atomic_read(&sk->sk_drops);
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index bbb005eb5218c2765567b1d14ef564d2332479cc..7dc79b973e6edcc64e668e14c71c732ca1187e8f 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -193,7 +193,7 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 	if (ext & (1 << (INET_DIAG_MEMINFO - 1))) {
 		struct inet_diag_meminfo minfo = {
 			.idiag_rmem = sk_rmem_alloc_get(sk),
-			.idiag_wmem = sk->sk_wmem_queued,
+			.idiag_wmem = READ_ONCE(sk->sk_wmem_queued),
 			.idiag_fmem = sk->sk_forward_alloc,
 			.idiag_tmem = sk_wmem_alloc_get(sk),
 		};
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 11185326297211bee3746edd725d106643b78720..b2ac4f074e2da21db57923fda722b6d23f170de9 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -659,7 +659,7 @@ static void skb_entail(struct sock *sk, struct sk_buff *skb)
 	tcb->sacked  = 0;
 	__skb_header_release(skb);
 	tcp_add_write_queue_tail(sk, skb);
-	sk->sk_wmem_queued += skb->truesize;
+	sk_wmem_queued_add(sk, skb->truesize);
 	sk_mem_charge(sk, skb->truesize);
 	if (tp->nonagle & TCP_NAGLE_PUSH)
 		tp->nonagle &= ~TCP_NAGLE_PUSH;
@@ -1034,7 +1034,7 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 		skb->len += copy;
 		skb->data_len += copy;
 		skb->truesize += copy;
-		sk->sk_wmem_queued += copy;
+		sk_wmem_queued_add(sk, copy);
 		sk_mem_charge(sk, copy);
 		skb->ip_summed = CHECKSUM_PARTIAL;
 		WRITE_ONCE(tp->write_seq, tp->write_seq + copy);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index a115a991dfb5b36c5b3dafd8c9ad94d07685f3a0..0488607c5cd3615633af207f0bb41bea0c0176ce 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1199,7 +1199,7 @@ static void tcp_queue_skb(struct sock *sk, struct sk_buff *skb)
 	WRITE_ONCE(tp->write_seq, TCP_SKB_CB(skb)->end_seq);
 	__skb_header_release(skb);
 	tcp_add_write_queue_tail(sk, skb);
-	sk->sk_wmem_queued += skb->truesize;
+	sk_wmem_queued_add(sk, skb->truesize);
 	sk_mem_charge(sk, skb->truesize);
 }
 
@@ -1333,7 +1333,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 		return -ENOMEM; /* We'll just try again later. */
 	skb_copy_decrypted(buff, skb);
 
-	sk->sk_wmem_queued += buff->truesize;
+	sk_wmem_queued_add(sk, buff->truesize);
 	sk_mem_charge(sk, buff->truesize);
 	nlen = skb->len - len - nsize;
 	buff->truesize += nlen;
@@ -1443,7 +1443,7 @@ int tcp_trim_head(struct sock *sk, struct sk_buff *skb, u32 len)
 
 	if (delta_truesize) {
 		skb->truesize	   -= delta_truesize;
-		sk->sk_wmem_queued -= delta_truesize;
+		sk_wmem_queued_add(sk, -delta_truesize);
 		sk_mem_uncharge(sk, delta_truesize);
 		sock_set_flag(sk, SOCK_QUEUE_SHRUNK);
 	}
@@ -1888,7 +1888,7 @@ static int tso_fragment(struct sock *sk, struct sk_buff *skb, unsigned int len,
 		return -ENOMEM;
 	skb_copy_decrypted(buff, skb);
 
-	sk->sk_wmem_queued += buff->truesize;
+	sk_wmem_queued_add(sk, buff->truesize);
 	sk_mem_charge(sk, buff->truesize);
 	buff->truesize += nlen;
 	skb->truesize -= nlen;
@@ -2152,7 +2152,7 @@ static int tcp_mtu_probe(struct sock *sk)
 	nskb = sk_stream_alloc_skb(sk, probe_size, GFP_ATOMIC, false);
 	if (!nskb)
 		return -1;
-	sk->sk_wmem_queued += nskb->truesize;
+	sk_wmem_queued_add(sk, nskb->truesize);
 	sk_mem_charge(sk, nskb->truesize);
 
 	skb = tcp_send_head(sk);
@@ -3222,7 +3222,7 @@ int tcp_send_synack(struct sock *sk)
 			tcp_rtx_queue_unlink_and_free(skb, sk);
 			__skb_header_release(nskb);
 			tcp_rbtree_insert(&sk->tcp_rtx_queue, nskb);
-			sk->sk_wmem_queued += nskb->truesize;
+			sk_wmem_queued_add(sk, nskb->truesize);
 			sk_mem_charge(sk, nskb->truesize);
 			skb = nskb;
 		}
@@ -3447,7 +3447,7 @@ static void tcp_connect_queue_skb(struct sock *sk, struct sk_buff *skb)
 
 	tcb->end_seq += skb->len;
 	__skb_header_release(skb);
-	sk->sk_wmem_queued += skb->truesize;
+	sk_wmem_queued_add(sk, skb->truesize);
 	sk_mem_charge(sk, skb->truesize);
 	WRITE_ONCE(tp->write_seq, tcb->end_seq);
 	tp->packets_out += tcp_skb_pcount(skb);
diff --git a/net/sched/em_meta.c b/net/sched/em_meta.c
index 4c9122fc35c9d5f86ed60bc03427da1cde57b636..3177dcb173161629a801278db38fabeb6fcdbdd9 100644
--- a/net/sched/em_meta.c
+++ b/net/sched/em_meta.c
@@ -446,7 +446,7 @@ META_COLLECTOR(int_sk_wmem_queued)
 		*err = -1;
 		return;
 	}
-	dst->value = sk->sk_wmem_queued;
+	dst->value = READ_ONCE(sk->sk_wmem_queued);
 }
 
 META_COLLECTOR(int_sk_fwd_alloc)
-- 
2.23.0.700.g56cf767bdb-goog

