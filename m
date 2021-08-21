Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B893F3B46
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 17:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235250AbhHUPyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 11:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbhHUPyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 11:54:47 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151B2C061224;
        Sat, 21 Aug 2021 08:53:53 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id w68so11385190pfd.0;
        Sat, 21 Aug 2021 08:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zRpYwGeL8XTo33SfCVOcmqX7DUSwoGgUjS+gHhg53uE=;
        b=VFe1LSLOInW6zThI798Aqu4wyQ95LRYKLefq/NWxyh9ABl56vmV9Ji3DMl6plCNz+p
         q4vku+63l/YMQNfB5v3oL49xKZDY8pqaBTfiHfvrkJPGnkJD7DIXhWSRxc39jgkjQZMa
         LN3PGr+d5dAgx97c5PtxENWLKXkfuQdhda7i+qVAKQsfKVHv/KxcsvM06Vmg8UZsK/Cl
         OV6tAvmSEFYo8c/YD6HqQ1HHunMo4B8UIcjvOOjrCWm/Pmjd8OBt1Qsv+En7lSIKhFQd
         HU7GGsEY8mhtYp7qoUbMqgyplJBKCNaY6yivneoATa+ZTiDK8O0Q0rqluaB5al8EW2CW
         D3XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zRpYwGeL8XTo33SfCVOcmqX7DUSwoGgUjS+gHhg53uE=;
        b=EFqvD+M6bptgxgHQ5MBgIznl/uRnEJD5oSw4CyYn9RJQOSymxhlSRgHGy6wptP/kmp
         9I6hdUOL9oDjlDA2bsCVDUC07/qvSleLVhfgal5aWtEsvD1IGKjJJ43iLO57snF9MCSr
         zapdtsMpLN5ihFyKzNtxcWVPUPfYzi8gqkLRGuRwQR/aLirLD1V2tdLOjAZH7TdJJ1Dg
         ZCENvD27Ud/abtOCzm8aBzeRwG4l2Lkq6h9Dp+Eym7l5n9F3GFZMi2AFZhKEllwDnZ7D
         pVWlpbLeAF6+puAog3tWdCLTIlLW6hgg5b9PL+nxg4pxmHG4XvR6x95eA2H91uUzD7An
         UezA==
X-Gm-Message-State: AOAM5311rMGy+scDp3tWgdkxHTOM385pA0BEL7wT1gH1fAc4WP15fZ+p
        +CSK6aLT/CcwBUA9k1lBUtE=
X-Google-Smtp-Source: ABdhPJz0wOXLZrc/S73w9devvoQzXg/4smtNR7mKHf3B4mkxetFnKFDGAZ6FHf5mrcbURHL4dWru3Q==
X-Received: by 2002:a63:6602:: with SMTP id a2mr24241086pgc.93.1629561232644;
        Sat, 21 Aug 2021 08:53:52 -0700 (PDT)
Received: from localhost.localdomain ([223.106.48.93])
        by smtp.googlemail.com with ESMTPSA id x42sm10615384pfh.205.2021.08.21.08.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 08:53:52 -0700 (PDT)
From:   jony-one <yan2228598786@gmail.com>
To:     kuba@kernel.org
Cc:     edumazet@google.com, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hengqi.chen@gmail.com, yhs@fb.com,
        jony-one <yan2228598786@gmail.com>
Subject: [PATCH] net/mlx4: tcp_drop replace of tcp_drop_new
Date:   Sat, 21 Aug 2021 08:53:27 -0700
Message-Id: <20210821155327.251284-1-yan2228598786@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We never know why we are deleting a tcp packet when we delete it,
and the tcp_drop_new() function can effectively solve this problem.
The tcp_drop_new() will learn from the specified status code why the
packet was deleted, and the caller from whom the packet was deleted.
The kernel should be a little more open to data that is about to be
destroyed and useless, and users should be able to keep track of it.

Signed-off-by: jony-one <yan2228598786@gmail.com>
---
 include/trace/events/tcp.h | 51 ++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_input.c       | 29 ++++++++++++++--------
 2 files changed, 69 insertions(+), 11 deletions(-)

diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
index 521059d8d..5a0478440 100644
--- a/include/trace/events/tcp.h
+++ b/include/trace/events/tcp.h
@@ -371,6 +371,57 @@ DEFINE_EVENT(tcp_event_skb, tcp_bad_csum,
 	TP_ARGS(skb)
 );
 
+/*
+ * tcp event whit argument sk, skb, reason
+ */
+TRACE_EVENT(tcp_drop_new,
+
+		TP_PROTO(struct sock *sk, struct sk_buff *skb, const char *reason),
+
+		TP_ARGS(sk, skb, reason),
+
+		TP_STRUCT__entry(
+			__field(const void *, skbaddr)
+			__field(const void *, skaddr)
+			__string(reason, reason)
+			__field(int, state)
+			__field(__u16, sport)
+			__field(__u16, dport)
+			__array(__u8, saddr, 4)
+			__array(__u8, daddr, 4)
+			__array(__u8, saddr_v6, 16)
+			__array(__u8, daddr_v6, 16)
+		),
+
+		TP_fast_assign(
+			struct inet_sock *inet = inet_sk(sk);
+			__be32 *p32;
+
+			__assign_str(reason, reason);
+
+			__entry->skbaddr = skb;
+			__entry->skaddr = sk;
+			__entry->state = sk->sk_state;
+
+			__entry->sport = ntohs(inet->inet_sport);
+			__entry->dport = ntohs(inet->inet_dport);
+
+			p32 = (__be32 *) __entry->saddr;
+			*p32 = inet->inet_saddr;
+
+			p32 = (__be32 *) __entry->daddr;
+			*p32 =  inet->inet_daddr;
+
+			TP_STORE_ADDRS(__entry, inet->inet_saddr, inet->inet_daddr,
+				sk->sk_v6_rcv_saddr, sk->sk_v6_daddr);
+		),
+
+		TP_printk("sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c state=%s reason=%s",
+				__entry->sport, __entry->dport, __entry->saddr, __entry->daddr,
+				__entry->saddr_v6, __entry->daddr_v6,
+				show_tcp_state_name(__entry->state), __get_str(reason))
+);
+
 #endif /* _TRACE_TCP_H */
 
 /* This part must be outside protection */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 149ceb5c9..988989e25 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4649,6 +4649,13 @@ static void tcp_drop(struct sock *sk, struct sk_buff *skb)
 	__kfree_skb(skb);
 }
 
+static void tcp_drop_new(struct sock *sk, struct sk_buff *skb, const char *reason)
+{
+	trace_tcp_drop_new(sk, skb, reason);
+	sk_drops_add(sk, skb);
+	__kfree_skb(skb);
+}
+
 /* This one checks to see if we can put data from the
  * out_of_order queue into the receive_queue.
  */
@@ -4676,7 +4683,7 @@ static void tcp_ofo_queue(struct sock *sk)
 		rb_erase(&skb->rbnode, &tp->out_of_order_queue);
 
 		if (unlikely(!after(TCP_SKB_CB(skb)->end_seq, tp->rcv_nxt))) {
-			tcp_drop(sk, skb);
+			tcp_drop_new(sk, skb, __func__);
 			continue;
 		}
 
@@ -4732,7 +4739,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 	if (unlikely(tcp_try_rmem_schedule(sk, skb, skb->truesize))) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFODROP);
 		sk->sk_data_ready(sk);
-		tcp_drop(sk, skb);
+		tcp_drop_new(sk, skb, __func__);
 		return;
 	}
 
@@ -4795,7 +4802,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 				/* All the bits are present. Drop. */
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPOFOMERGE);
-				tcp_drop(sk, skb);
+				tcp_drop_new(sk, skb, __func__);
 				skb = NULL;
 				tcp_dsack_set(sk, seq, end_seq);
 				goto add_sack;
@@ -4814,7 +4821,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 						 TCP_SKB_CB(skb1)->end_seq);
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPOFOMERGE);
-				tcp_drop(sk, skb1);
+				tcp_drop_new(sk, skb1, __func__);
 				goto merge_right;
 			}
 		} else if (tcp_ooo_try_coalesce(sk, skb1,
@@ -4842,7 +4849,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 		tcp_dsack_extend(sk, TCP_SKB_CB(skb1)->seq,
 				 TCP_SKB_CB(skb1)->end_seq);
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFOMERGE);
-		tcp_drop(sk, skb1);
+		tcp_drop_new(sk, skb1, __func__);
 	}
 	/* If there is no skb after us, we are the last_skb ! */
 	if (!skb1)
@@ -5019,7 +5026,7 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 		tcp_enter_quickack_mode(sk, TCP_MAX_QUICKACKS);
 		inet_csk_schedule_ack(sk);
 drop:
-		tcp_drop(sk, skb);
+		tcp_drop_new(sk, skb, __func__);
 		return;
 	}
 
@@ -5276,7 +5283,7 @@ static bool tcp_prune_ofo_queue(struct sock *sk)
 		prev = rb_prev(node);
 		rb_erase(node, &tp->out_of_order_queue);
 		goal -= rb_to_skb(node)->truesize;
-		tcp_drop(sk, rb_to_skb(node));
+		tcp_drop_new(sk, rb_to_skb(node), __func__);
 		if (!prev || goal <= 0) {
 			sk_mem_reclaim(sk);
 			if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf &&
@@ -5701,7 +5708,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 	return true;
 
 discard:
-	tcp_drop(sk, skb);
+	tcp_drop_new(sk, skb, __func__);
 	return false;
 }
 
@@ -5905,7 +5912,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
 
 discard:
-	tcp_drop(sk, skb);
+	tcp_drop_new(sk, skb, __func__);
 }
 EXPORT_SYMBOL(tcp_rcv_established);
 
@@ -6196,7 +6203,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 						  TCP_DELACK_MAX, TCP_RTO_MAX);
 
 discard:
-			tcp_drop(sk, skb);
+			tcp_drop_new(sk, skb, __func__);
 			return 0;
 		} else {
 			tcp_send_ack(sk);
@@ -6568,7 +6575,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 
 	if (!queued) {
 discard:
-		tcp_drop(sk, skb);
+		tcp_drop_new(sk, skb, __func__);
 	}
 	return 0;
 }
-- 
2.25.1

