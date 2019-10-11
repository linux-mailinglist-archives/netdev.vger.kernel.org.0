Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2E0D37D1
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 05:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfJKDSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 23:18:24 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:53406 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfJKDSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 23:18:24 -0400
Received: by mail-qk1-f201.google.com with SMTP id g62so7514176qkb.20
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 20:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZN/HN6UaL2cirdrSnF1wkRZ90mIgTPwOi8zns9KL1lc=;
        b=uWcF+ddJl8jsASv1c0jNXmDxUjGeshRbNn12/iQfgUyvDelpPnNcqRMgskLTTny2d2
         IAkLOL6GO2zADEey4fqMBcCNXZ3AY95Dy5ks1QJvrpRa5qOePu7GLOlxQ7f+VRvbe9Ng
         0xtkXXkVTjsZob/hpdkq09elmKUzJm77KPakj6XbE8KVKkpGQTOKYTT8rGtyPBI7x81/
         z1tAq66oheCpkrJ9Mj2yhYbA3c34JHQ4sZiKrYSfY2p5rCEDdC+047Y1jkwBzifoUEoj
         0P/6OghOwZZrW6bXIknwJox1R+Abu9akS/Rlz+dObSxfWqjOwlDnAbyTTYmhwjGMcxOU
         6/XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZN/HN6UaL2cirdrSnF1wkRZ90mIgTPwOi8zns9KL1lc=;
        b=oHAdCvrfiEiEei4Aiu5usGPtPSiu3X5SzsGMLPow2Kgj3mYUcs2AXjcf8pkbWqyIJu
         l8kxxGAsRo26BDKgo+JcdilFnOYkw87CZPiealakmaD2Ln+Buf+4ekQWCRmAH9ZpWavO
         LLEDtZbNAqzRScSvuWDOtdfAQyUqXJSClf4I/3PGI0Em44JY0O7YhxlbMtPAMRDsSa2g
         3NWuwnH7hNACYaR3kwYBcIbMeE5TqQco2t5sloOfOKhU17kr9ysG8kSKX2/ZSwevBxtt
         lYD81Cx9Mya/MaZCd6V4BMuulhWrp1pzW02gu+G40OXWuWHjoa48HACVYEgAIfQOANw0
         XmJA==
X-Gm-Message-State: APjAAAWiUp42ozaLGdFLhAPHSSWUQwgZzAvT+OlDAIvexOo9hr0Q6IHr
        497CrW5e1sKzIF+NLnEtbHrRvLQBL6jFiQ==
X-Google-Smtp-Source: APXvYqzXHnFCXJKjn/X7IoPauLZ/9wb+wLWIT9P2DZEPp2jNF4pm4CTVPlFlprLP8Ow0fITv9KXOt2M08zTwZw==
X-Received: by 2002:ad4:524c:: with SMTP id s12mr13536176qvq.244.1570763902833;
 Thu, 10 Oct 2019 20:18:22 -0700 (PDT)
Date:   Thu, 10 Oct 2019 20:17:44 -0700
In-Reply-To: <20191011031746.16220-1-edumazet@google.com>
Message-Id: <20191011031746.16220-8-edumazet@google.com>
Mime-Version: 1.0
References: <20191011031746.16220-1-edumazet@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH net 7/9] tcp: annotate sk->sk_rcvbuf lockless reads
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
sk->sk_rcvbuf while this field can change from IRQ or other cpu.

We need to add READ_ONCE() annotations, and also make sure write
sides use corresponding WRITE_ONCE() to avoid store-tearing.

Note that other transports probably need similar fixes.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h           | 4 ++--
 include/trace/events/sock.h | 2 +-
 net/core/filter.c           | 3 ++-
 net/core/skbuff.c           | 2 +-
 net/core/sock.c             | 5 +++--
 net/ipv4/tcp.c              | 4 ++--
 net/ipv4/tcp_input.c        | 7 ++++---
 7 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index e1d08f69fd39f7c06c246a6f871400ad4cda6aed..ab4eb5eb5d0705b815e5eec3a772d4776be8653e 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1380,14 +1380,14 @@ static inline int tcp_win_from_space(const struct sock *sk, int space)
 /* Note: caller must be prepared to deal with negative returns */
 static inline int tcp_space(const struct sock *sk)
 {
-	return tcp_win_from_space(sk, sk->sk_rcvbuf -
+	return tcp_win_from_space(sk, READ_ONCE(sk->sk_rcvbuf) -
 				  READ_ONCE(sk->sk_backlog.len) -
 				  atomic_read(&sk->sk_rmem_alloc));
 }
 
 static inline int tcp_full_space(const struct sock *sk)
 {
-	return tcp_win_from_space(sk, sk->sk_rcvbuf);
+	return tcp_win_from_space(sk, READ_ONCE(sk->sk_rcvbuf));
 }
 
 extern void tcp_openreq_init_rwin(struct request_sock *req,
diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
index a0c4b8a3096604a9817a0f78f58409123a300352..f720c32e7dfd6f41c04194318d6c3f2e68b821cb 100644
--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -82,7 +82,7 @@ TRACE_EVENT(sock_rcvqueue_full,
 	TP_fast_assign(
 		__entry->rmem_alloc = atomic_read(&sk->sk_rmem_alloc);
 		__entry->truesize   = skb->truesize;
-		__entry->sk_rcvbuf  = sk->sk_rcvbuf;
+		__entry->sk_rcvbuf  = READ_ONCE(sk->sk_rcvbuf);
 	),
 
 	TP_printk("rmem_alloc=%d truesize=%u sk_rcvbuf=%d",
diff --git a/net/core/filter.c b/net/core/filter.c
index a50c0b6846f29006268b2fb18303d692533bc081..7deceaeeed7bace2bb805d110190b98819cfc7b1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4252,7 +4252,8 @@ BPF_CALL_5(bpf_setsockopt, struct bpf_sock_ops_kern *, bpf_sock,
 		case SO_RCVBUF:
 			val = min_t(u32, val, sysctl_rmem_max);
 			sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
-			sk->sk_rcvbuf = max_t(int, val * 2, SOCK_MIN_RCVBUF);
+			WRITE_ONCE(sk->sk_rcvbuf,
+				   max_t(int, val * 2, SOCK_MIN_RCVBUF));
 			break;
 		case SO_SNDBUF:
 			val = min_t(u32, val, sysctl_wmem_max);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 529133611ea2947b1b1af51394756b7797f8cde3..8c178703467bcfe193d4726cd82ae5dee4991bff 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4415,7 +4415,7 @@ static void skb_set_err_queue(struct sk_buff *skb)
 int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
 {
 	if (atomic_read(&sk->sk_rmem_alloc) + skb->truesize >=
-	    (unsigned int)sk->sk_rcvbuf)
+	    (unsigned int)READ_ONCE(sk->sk_rcvbuf))
 		return -ENOMEM;
 
 	skb_orphan(skb);
diff --git a/net/core/sock.c b/net/core/sock.c
index 2a053999df112665bbd8d0b5a8a59cd587e786c9..8c8f61e70141583afe52420b58fea4bcce3a74f0 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -831,7 +831,8 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		 * returning the value we actually used in getsockopt
 		 * is the most desirable behavior.
 		 */
-		sk->sk_rcvbuf = max_t(int, val * 2, SOCK_MIN_RCVBUF);
+		WRITE_ONCE(sk->sk_rcvbuf,
+			   max_t(int, val * 2, SOCK_MIN_RCVBUF));
 		break;
 
 	case SO_RCVBUFFORCE:
@@ -3204,7 +3205,7 @@ void sk_get_meminfo(const struct sock *sk, u32 *mem)
 	memset(mem, 0, sizeof(*mem) * SK_MEMINFO_VARS);
 
 	mem[SK_MEMINFO_RMEM_ALLOC] = sk_rmem_alloc_get(sk);
-	mem[SK_MEMINFO_RCVBUF] = sk->sk_rcvbuf;
+	mem[SK_MEMINFO_RCVBUF] = READ_ONCE(sk->sk_rcvbuf);
 	mem[SK_MEMINFO_WMEM_ALLOC] = sk_wmem_alloc_get(sk);
 	mem[SK_MEMINFO_SNDBUF] = sk->sk_sndbuf;
 	mem[SK_MEMINFO_FWD_ALLOC] = sk->sk_forward_alloc;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 577a8c6eef9f520ba5d96485ab866af89aa0a046..bc0481aa6633c0c871c57a89d38ef57734b51f12 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -451,7 +451,7 @@ void tcp_init_sock(struct sock *sk)
 	icsk->icsk_sync_mss = tcp_sync_mss;
 
 	sk->sk_sndbuf = sock_net(sk)->ipv4.sysctl_tcp_wmem[1];
-	sk->sk_rcvbuf = sock_net(sk)->ipv4.sysctl_tcp_rmem[1];
+	WRITE_ONCE(sk->sk_rcvbuf, sock_net(sk)->ipv4.sysctl_tcp_rmem[1]);
 
 	sk_sockets_allocated_inc(sk);
 	sk->sk_route_forced_caps = NETIF_F_GSO;
@@ -1711,7 +1711,7 @@ int tcp_set_rcvlowat(struct sock *sk, int val)
 
 	val <<= 1;
 	if (val > sk->sk_rcvbuf) {
-		sk->sk_rcvbuf = val;
+		WRITE_ONCE(sk->sk_rcvbuf, val);
 		tcp_sk(sk)->window_clamp = tcp_win_from_space(sk, val);
 	}
 	return 0;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 16342e043ab353bfe1b10d8099117395a396fbd4..6995df20710a7bf48d9aca88c14e5980f4fc9615 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -483,8 +483,9 @@ static void tcp_clamp_window(struct sock *sk)
 	    !(sk->sk_userlocks & SOCK_RCVBUF_LOCK) &&
 	    !tcp_under_memory_pressure(sk) &&
 	    sk_memory_allocated(sk) < sk_prot_mem_limits(sk, 0)) {
-		sk->sk_rcvbuf = min(atomic_read(&sk->sk_rmem_alloc),
-				    net->ipv4.sysctl_tcp_rmem[2]);
+		WRITE_ONCE(sk->sk_rcvbuf,
+			   min(atomic_read(&sk->sk_rmem_alloc),
+			       net->ipv4.sysctl_tcp_rmem[2]));
 	}
 	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf)
 		tp->rcv_ssthresh = min(tp->window_clamp, 2U * tp->advmss);
@@ -648,7 +649,7 @@ void tcp_rcv_space_adjust(struct sock *sk)
 		rcvbuf = min_t(u64, rcvwin * rcvmem,
 			       sock_net(sk)->ipv4.sysctl_tcp_rmem[2]);
 		if (rcvbuf > sk->sk_rcvbuf) {
-			sk->sk_rcvbuf = rcvbuf;
+			WRITE_ONCE(sk->sk_rcvbuf, rcvbuf);
 
 			/* Make the window clamp follow along.  */
 			tp->window_clamp = tcp_win_from_space(sk, rcvbuf);
-- 
2.23.0.700.g56cf767bdb-goog

