Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2AEC3F5E68
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 14:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237240AbhHXMwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 08:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237063AbhHXMwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 08:52:42 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22FEEC061757;
        Tue, 24 Aug 2021 05:51:58 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id h1so8324251pjs.2;
        Tue, 24 Aug 2021 05:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DvLQbm0Ty3NQtjMeizQYgOKEyU1Gv/bb1V4BEqqzMKw=;
        b=ctMxmWZcu988FrDiEkWUIUlZL3g1kvdtKjFmKEY1trLrCY24tCkaucUPPOl6JTewfe
         g0BORneGWXphjqTXq8RHs01IvmJc8NDhwRqJYNAepyESPBGMjutj04fQmCG3wB97hF5k
         R8o2gDdlqibG3dF3muu5Di2Pa6AW2WSTi8sXmoUBbjG0epituaR6gmETQUf/G2GvsFFY
         zeVBHDe3nAugyaTCne5wAH7X0NMcYCqrLMo2fODf9qs5/3Kmdv1V/CuBe0WwHVNOAGQI
         yF3SllHFqkIVgJihXau126NUcDKXhmN9H1qfoxjIerrYyBj5Y33JEyate/Gq0C6bKKZn
         zgZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DvLQbm0Ty3NQtjMeizQYgOKEyU1Gv/bb1V4BEqqzMKw=;
        b=j6yKZY4wgiZocy9oSSKCC1D+viHeQ10OaAaAmL17bLRX5Iu3zXzFhrUEdQ6oVbMMJ6
         BIt+dPwJwZxsftoFmCHdrwuPwrZoyDoQsNPoyJ0oQXaLw5ceyVTtHdSDn4tbiU1UuT7K
         yQBNAeJwFygWx+tE4EH9Wmq6QXNIXyqWPFuLz7VTjQdMBDDp4YK5IBV5DwMboMJjecNe
         u7Y2T2joeytjHS7i+KkAESBBmJFSDHvkJAS7BHRUgpzfrSWAxrTaNWiQX08GdOOpwdqg
         E+5zMzMKIrZsVmBXeQHgEI35NwbWu1UYvpL0kdSP/gtiqrM12QFeGDogm2MUtG2lifgT
         4rIw==
X-Gm-Message-State: AOAM532phl6IWY5BCuHrLcVbBFK0bt2JjkB8WyWnNEi4g+u/lEpoKotB
        4WEFiTzdFRfmnxVfdbn4Jg/5yrgGeWYcVTrr
X-Google-Smtp-Source: ABdhPJx5YXHeLIk4/X6hbxC6HKJCPnUQ/QgIJN1DUHBdo1f3kAyBRzLoUlSfkMMLVoKsHpRApyGssw==
X-Received: by 2002:a17:90a:744c:: with SMTP id o12mr4373891pjk.139.1629809517684;
        Tue, 24 Aug 2021 05:51:57 -0700 (PDT)
Received: from localhost.localdomain ([221.225.34.48])
        by smtp.googlemail.com with ESMTPSA id on15sm2348032pjb.19.2021.08.24.05.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 05:51:57 -0700 (PDT)
From:   Zhongya Yan <yan2228598786@gmail.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        edumazet@google.com, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        hengqi.chen@gmail.com, yhs@fb.com,
        Zhongya Yan <yan2228598786@gmail.com>
Subject: [PATCH] net: tcp_drop adds `reason` parameter for tracing
Date:   Tue, 24 Aug 2021 05:51:40 -0700
Message-Id: <20210824125140.190253-1-yan2228598786@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using `tcp_drop(struct sock *sk, struct sk_buff *skb)` we can
not tell why we need to delete `skb`. To solve this problem I updated the
method `tcp_drop(struct sock *sk, struct sk_buff *skb, enum tcp_drop_reason reason)`
to include the source of the deletion when it is done, so you can
get an idea of the reason for the deletion based on the source.

The current purpose is mainly derived from the suggestions
of `Yonghong Song` and `brendangregg`:

https://github.com/iovisor/bcc/issues/3533.

"It is worthwhile to mention the context/why we want to this
tracepoint with bcc issue https://github.com/iovisor/bcc/issues/3533.
Mainly two reasons: (1). tcp_drop is a tiny function which
may easily get inlined, a tracepoint is more stable, and (2).
tcp_drop does not provide enough information on why it is dropped.
" by Yonghong Song

Signed-off-by: Zhongya Yan <yan2228598786@gmail.com>
---
 include/net/tcp.h          | 11 ++++++++
 include/trace/events/tcp.h | 56 ++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_input.c       | 34 +++++++++++++++--------
 3 files changed, 89 insertions(+), 12 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 784d5c3ef1c5..dd8cd8d6f2f1 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -254,6 +254,17 @@ extern atomic_long_t tcp_memory_allocated;
 extern struct percpu_counter tcp_sockets_allocated;
 extern unsigned long tcp_memory_pressure;
 
+enum tcp_drop_reason {
+	TCP_OFO_QUEUE = 1,
+	TCP_DATA_QUEUE_OFO = 2,
+	TCP_DATA_QUEUE = 3,
+	TCP_PRUNE_OFO_QUEUE = 4,
+	TCP_VALIDATE_INCOMING = 5,
+	TCP_RCV_ESTABLISHED = 6,
+	TCP_RCV_SYNSENT_STATE_PROCESS = 7,
+	TCP_RCV_STATE_PROCESS = 8
+};
+
 /* optimized version of sk_under_memory_pressure() for TCP sockets */
 static inline bool tcp_under_memory_pressure(const struct sock *sk)
 {
diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
index 521059d8dc0a..a0d3d31eb591 100644
--- a/include/trace/events/tcp.h
+++ b/include/trace/events/tcp.h
@@ -371,6 +371,62 @@ DEFINE_EVENT(tcp_event_skb, tcp_bad_csum,
 	TP_ARGS(skb)
 );
 
+TRACE_EVENT(tcp_drop,
+		TP_PROTO(struct sock *sk, struct sk_buff *skb, enum tcp_drop_reason reason),
+
+		TP_ARGS(sk, skb, reason),
+
+		TP_STRUCT__entry(
+			__array(__u8, saddr, sizeof(struct sockaddr_in6))
+			__array(__u8, daddr, sizeof(struct sockaddr_in6))
+			__field(__u16, sport)
+			__field(__u16, dport)
+			__field(__u32, mark)
+			__field(__u16, data_len)
+			__field(__u32, snd_nxt)
+			__field(__u32, snd_una)
+			__field(__u32, snd_cwnd)
+			__field(__u32, ssthresh)
+			__field(__u32, snd_wnd)
+			__field(__u32, srtt)
+			__field(__u32, rcv_wnd)
+			__field(__u64, sock_cookie)
+			__field(__u32, reason)
+			),
+
+		TP_fast_assign(
+				const struct tcphdr *th = (const struct tcphdr *)skb->data;
+				const struct inet_sock *inet = inet_sk(sk);
+				const struct tcp_sock *tp = tcp_sk(sk);
+
+				memset(__entry->saddr, 0, sizeof(struct sockaddr_in6));
+				memset(__entry->daddr, 0, sizeof(struct sockaddr_in6));
+
+				TP_STORE_ADDR_PORTS(__entry, inet, sk);
+
+				__entry->sport = ntohs(inet->inet_sport);
+				__entry->dport = ntohs(inet->inet_dport);
+				__entry->mark = skb->mark;
+
+				__entry->data_len = skb->len - __tcp_hdrlen(th);
+				__entry->snd_nxt = tp->snd_nxt;
+				__entry->snd_una = tp->snd_una;
+				__entry->snd_cwnd = tp->snd_cwnd;
+				__entry->snd_wnd = tp->snd_wnd;
+				__entry->rcv_wnd = tp->rcv_wnd;
+				__entry->ssthresh = tcp_current_ssthresh(sk);
+		__entry->srtt = tp->srtt_us >> 3;
+		__entry->sock_cookie = sock_gen_cookie(sk);
+		__entry->reason = reason;
+		),
+
+		TP_printk("src=%pISpc dest=%pISpc mark=%#x data_len=%d snd_nxt=%#x snd_una=%#x snd_cwnd=%u ssthresh=%u snd_wnd=%u srtt=%u rcv_wnd=%u sock_cookie=%llx reason=%d",
+				__entry->saddr, __entry->daddr, __entry->mark,
+				__entry->data_len, __entry->snd_nxt, __entry->snd_una,
+				__entry->snd_cwnd, __entry->ssthresh, __entry->snd_wnd,
+				__entry->srtt, __entry->rcv_wnd, __entry->sock_cookie, __entry->reason)
+);
+
 #endif /* _TRACE_TCP_H */
 
 /* This part must be outside protection */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 149ceb5c94ff..83e31661876b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4643,12 +4643,22 @@ static bool tcp_ooo_try_coalesce(struct sock *sk,
 	return res;
 }
 
-static void tcp_drop(struct sock *sk, struct sk_buff *skb)
+static void __tcp_drop(struct sock *sk,
+		   struct sk_buff *skb)
 {
 	sk_drops_add(sk, skb);
 	__kfree_skb(skb);
 }
 
+/* tcp_drop whit reason,for epbf trace
+ */
+static void tcp_drop(struct sock *sk, struct sk_buff *skb,
+		 enum tcp_drop_reason reason)
+{
+	trace_tcp_drop(sk, skb, reason);
+	__tcp_drop(sk, skb);
+}
+
 /* This one checks to see if we can put data from the
  * out_of_order queue into the receive_queue.
  */
@@ -4676,7 +4686,7 @@ static void tcp_ofo_queue(struct sock *sk)
 		rb_erase(&skb->rbnode, &tp->out_of_order_queue);
 
 		if (unlikely(!after(TCP_SKB_CB(skb)->end_seq, tp->rcv_nxt))) {
-			tcp_drop(sk, skb);
+			tcp_drop(sk, skb, TCP_OFO_QUEUE);
 			continue;
 		}
 
@@ -4732,7 +4742,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 	if (unlikely(tcp_try_rmem_schedule(sk, skb, skb->truesize))) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFODROP);
 		sk->sk_data_ready(sk);
-		tcp_drop(sk, skb);
+		tcp_drop(sk, skb, TCP_DATA_QUEUE_OFO);
 		return;
 	}
 
@@ -4795,7 +4805,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 				/* All the bits are present. Drop. */
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPOFOMERGE);
-				tcp_drop(sk, skb);
+				tcp_drop(sk, skb, TCP_DATA_QUEUE_OFO);
 				skb = NULL;
 				tcp_dsack_set(sk, seq, end_seq);
 				goto add_sack;
@@ -4814,7 +4824,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 						 TCP_SKB_CB(skb1)->end_seq);
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPOFOMERGE);
-				tcp_drop(sk, skb1);
+				tcp_drop(sk, skb1, TCP_DATA_QUEUE_OFO);
 				goto merge_right;
 			}
 		} else if (tcp_ooo_try_coalesce(sk, skb1,
@@ -4842,7 +4852,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 		tcp_dsack_extend(sk, TCP_SKB_CB(skb1)->seq,
 				 TCP_SKB_CB(skb1)->end_seq);
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFOMERGE);
-		tcp_drop(sk, skb1);
+		tcp_drop(sk, skb1, TCP_DATA_QUEUE_OFO);
 	}
 	/* If there is no skb after us, we are the last_skb ! */
 	if (!skb1)
@@ -5019,7 +5029,7 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 		tcp_enter_quickack_mode(sk, TCP_MAX_QUICKACKS);
 		inet_csk_schedule_ack(sk);
 drop:
-		tcp_drop(sk, skb);
+		tcp_drop(sk, skb, TCP_DATA_QUEUE);
 		return;
 	}
 
@@ -5276,7 +5286,7 @@ static bool tcp_prune_ofo_queue(struct sock *sk)
 		prev = rb_prev(node);
 		rb_erase(node, &tp->out_of_order_queue);
 		goal -= rb_to_skb(node)->truesize;
-		tcp_drop(sk, rb_to_skb(node));
+		tcp_drop(sk, rb_to_skb(node), TCP_PRUNE_OFO_QUEUE);
 		if (!prev || goal <= 0) {
 			sk_mem_reclaim(sk);
 			if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf &&
@@ -5701,7 +5711,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 	return true;
 
 discard:
-	tcp_drop(sk, skb);
+	tcp_drop(sk, skb, TCP_VALIDATE_INCOMING);
 	return false;
 }
 
@@ -5905,7 +5915,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
 
 discard:
-	tcp_drop(sk, skb);
+	tcp_drop(sk, skb, TCP_RCV_ESTABLISHED);
 }
 EXPORT_SYMBOL(tcp_rcv_established);
 
@@ -6196,7 +6206,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 						  TCP_DELACK_MAX, TCP_RTO_MAX);
 
 discard:
-			tcp_drop(sk, skb);
+			tcp_drop(sk, skb, TCP_RCV_SYNSENT_STATE_PROCESS);
 			return 0;
 		} else {
 			tcp_send_ack(sk);
@@ -6568,7 +6578,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 
 	if (!queued) {
 discard:
-		tcp_drop(sk, skb);
+		tcp_drop(sk, skb, TCP_RCV_STATE_PROCESS);
 	}
 	return 0;
 }
-- 
2.25.1

