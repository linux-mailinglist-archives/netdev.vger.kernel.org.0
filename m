Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601553FEB6B
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 11:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343725AbhIBJfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 05:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343687AbhIBJfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 05:35:20 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA28C061575;
        Thu,  2 Sep 2021 02:34:22 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id e16so1176440pfc.6;
        Thu, 02 Sep 2021 02:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BIrFh4P2PXq0kmyCcxGTXIhBEy39OT8I4o6P4cr2nzg=;
        b=U7CpizVbKJaWTHmOGAw3EcIlmkC5UYQ7SRHgGUsD8Ycux2WhbM2lJnhJNuvQm1CIjD
         6CBZVdQ8ktrW0XArj67h6bfQPiIdNTyDDM1nSJKimWsiatbImjdvrQFwi0vZnRDO7kdp
         0nj9PYUEjPL/736x3Goyt29LcLHDZmbRVa8vPnrWE28QRPHB/7xL/H4Qv+lVHGGEXxty
         9lYyAZgzoHKadoZCZ83tW4uc72vEMthzXGzrqOodRNTSR0/EvoP5HUov48GcCwerDQDL
         kEaXBPDLq40Eu055todWVOXDH6JNUmrJBZB0vo+s8Iunf121zgKzn+qvlOSIbys8GPtI
         302Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BIrFh4P2PXq0kmyCcxGTXIhBEy39OT8I4o6P4cr2nzg=;
        b=oqI0+H2YWZiWNpltpTeq2JDMU7FKatuWdqM70G49rG/X7NdMVkkw+FDm12AaXKUiEj
         4WR6Aez39kpoYs6PJ52q/VnHVI+//rq1wgmnbLhcBg+0NWO9ezQHXydE/gUerXsrYE5T
         jdAjbNI8bUsElub2XINu1thY5FfwoA90+d7Yr1m+p6G7PoZpUBZWJdj6udhgy9GskHXP
         rsxihUOBtVEAlV21lDQ+Efcdt07ormf4nkvONkoSamc1+2F8QJk5D3MPXMCGcoO4hvWU
         2HejwvVWE+m0ZXdBJ3TIUDN0V/9+cJ3Tv1FDIklFOA06rZFe7xAY+4mSidAC7+ou5A1a
         xS+A==
X-Gm-Message-State: AOAM531kHrrhrXEeu0j/RQlfPF0GktmAqwpXC8ni1iiqDYw2qeZgxXKK
        80MgwC6QNO3UD/A2FsP1PdM=
X-Google-Smtp-Source: ABdhPJzrjSpoXaMBEAE2AmmMmbmdLgH4oV0j3o+h2NhKSwT2+9nvR0EKYpq/o8Du+A38L37v3HENew==
X-Received: by 2002:a63:5947:: with SMTP id j7mr2379012pgm.193.1630575261621;
        Thu, 02 Sep 2021 02:34:21 -0700 (PDT)
Received: from localhost.localdomain ([223.106.51.51])
        by smtp.googlemail.com with ESMTPSA id gn12sm1624961pjb.26.2021.09.02.02.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 02:34:21 -0700 (PDT)
From:   Zhongya Yan <yan2228598786@gmail.com>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        hengqi.chen@gmail.com, yhs@fb.com, brendan.d.gregg@gmail.com,
        2228598786@qq.com, Zhongya Yan <yan2228598786@gmail.com>
Subject: [PATCH] net: tcp_drop adds `reason` and SNMP parameters for tracing v3
Date:   Thu,  2 Sep 2021 02:33:58 -0700
Message-Id: <20210902093358.28345-1-yan2228598786@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I used the suggestion from `Brendan Gregg`. In addition to the
`reason` parameter there is also the `field` parameter pointing
to `SNMP` to distinguish the `tcp_drop` cause. I know what I
submitted is not accurate, so I am submitting the current
patch to get comments and criticism from everyone so that I
can submit better code and solutions.And of course to make me
more familiar and understand the `linux` kernel network code.
Thank you everyone!

Signed-off-by: Zhongya Yan <yan2228598786@gmail.com>
---
 include/trace/events/tcp.h |  39 +++---------
 net/ipv4/tcp_input.c       | 126 ++++++++++++++-----------------------
 2 files changed, 57 insertions(+), 108 deletions(-)

diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
index 699539702ea9..80892660458e 100644
--- a/include/trace/events/tcp.h
+++ b/include/trace/events/tcp.h
@@ -371,28 +371,10 @@ DEFINE_EVENT(tcp_event_skb, tcp_bad_csum,
 	TP_ARGS(skb)
 );
 
-// from author @{Steven Rostedt}
-#define TCP_DROP_REASON							\
-	REASON_STRING(TCP_OFO_QUEUE,		ofo_queue)			\
-	REASON_STRING(TCP_DATA_QUEUE_OFO,		data_queue_ofo)			\
-	REASON_STRING(TCP_DATA_QUEUE,		data_queue)			\
-	REASON_STRING(TCP_PRUNE_OFO_QUEUE,		prune_ofo_queue)		\
-	REASON_STRING(TCP_VALIDATE_INCOMING,	validate_incoming)		\
-	REASON_STRING(TCP_RCV_ESTABLISHED,		rcv_established)		\
-	REASON_STRING(TCP_RCV_SYNSENT_STATE_PROCESS, rcv_synsent_state_process)	\
-	REASON_STRINGe(TCP_RCV_STATE_PROCESS,	rcv_state_proces)
-
-#undef REASON_STRING
-#undef REASON_STRINGe
-
-#define REASON_STRING(code, name) {code , #name},
-#define REASON_STRINGe(code, name) {code, #name}
-
-
 TRACE_EVENT(tcp_drop,
-		TP_PROTO(struct sock *sk, struct sk_buff *skb, __u32 reason),
+		TP_PROTO(struct sock *sk, struct sk_buff *skb, int field, const char *reason),
 
-		TP_ARGS(sk, skb, reason),
+		TP_ARGS(sk, skb, field, reason),
 
 		TP_STRUCT__entry(
 			__array(__u8, saddr, sizeof(struct sockaddr_in6))
@@ -409,9 +391,8 @@ TRACE_EVENT(tcp_drop,
 			__field(__u32, srtt)
 			__field(__u32, rcv_wnd)
 			__field(__u64, sock_cookie)
-			__field(__u32, reason)
-			__field(__u32, reason_code)
-			__field(__u32, reason_line)
+			__field(int, field)
+			__string(reason, reason)
 			),
 
 		TP_fast_assign(
@@ -437,21 +418,19 @@ TRACE_EVENT(tcp_drop,
 				__entry->ssthresh = tcp_current_ssthresh(sk);
 				__entry->srtt = tp->srtt_us >> 3;
 				__entry->sock_cookie = sock_gen_cookie(sk);
-				__entry->reason = reason;
-				__entry->reason_code = TCP_DROP_CODE(reason);
-				__entry->reason_line = TCP_DROP_LINE(reason);
+				__entry->field = field;
+
+				__assign_str(reason, reason);
 		),
 
 		TP_printk("src=%pISpc dest=%pISpc mark=%#x data_len=%d snd_nxt=%#x snd_una=%#x \
 				snd_cwnd=%u ssthresh=%u snd_wnd=%u srtt=%u rcv_wnd=%u \
-				sock_cookie=%llx reason=%d reason_type=%s reason_line=%d",
+				sock_cookie=%llx field=%d reason=%s",
 				__entry->saddr, __entry->daddr, __entry->mark,
 				__entry->data_len, __entry->snd_nxt, __entry->snd_una,
 				__entry->snd_cwnd, __entry->ssthresh, __entry->snd_wnd,
 				__entry->srtt, __entry->rcv_wnd, __entry->sock_cookie,
-				__entry->reason,
-				__print_symbolic(__entry->reason_code, TCP_DROP_REASON),
-				__entry->reason_line)
+				field, __get_str(reason))
 );
 
 #endif /* _TRACE_TCP_H */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index b2bc49f1f0de..bd33fd466e1e 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -100,7 +100,6 @@ int sysctl_tcp_max_orphans __read_mostly = NR_FILE;
 #define FLAG_UPDATE_TS_RECENT	0x4000 /* tcp_replace_ts_recent() */
 #define FLAG_NO_CHALLENGE_ACK	0x8000 /* do not call tcp_send_challenge_ack()	*/
 #define FLAG_ACK_MAYBE_DELAYED	0x10000 /* Likely a delayed ACK */
-#define FLAG_DSACK_TLP		0x20000 /* DSACK for tail loss probe */
 
 #define FLAG_ACKED		(FLAG_DATA_ACKED|FLAG_SYN_ACKED)
 #define FLAG_NOT_DUP		(FLAG_DATA|FLAG_WIN_UPDATE|FLAG_ACKED)
@@ -455,12 +454,11 @@ static void tcp_sndbuf_expand(struct sock *sk)
  */
 
 /* Slow part of check#2. */
-static int __tcp_grow_window(const struct sock *sk, const struct sk_buff *skb,
-			     unsigned int skbtruesize)
+static int __tcp_grow_window(const struct sock *sk, const struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	/* Optimize this! */
-	int truesize = tcp_win_from_space(sk, skbtruesize) >> 1;
+	int truesize = tcp_win_from_space(sk, skb->truesize) >> 1;
 	int window = tcp_win_from_space(sk, sock_net(sk)->ipv4.sysctl_tcp_rmem[2]) >> 1;
 
 	while (tp->rcv_ssthresh <= window) {
@@ -473,27 +471,7 @@ static int __tcp_grow_window(const struct sock *sk, const struct sk_buff *skb,
 	return 0;
 }
 
-/* Even if skb appears to have a bad len/truesize ratio, TCP coalescing
- * can play nice with us, as sk_buff and skb->head might be either
- * freed or shared with up to MAX_SKB_FRAGS segments.
- * Only give a boost to drivers using page frag(s) to hold the frame(s),
- * and if no payload was pulled in skb->head before reaching us.
- */
-static u32 truesize_adjust(bool adjust, const struct sk_buff *skb)
-{
-	u32 truesize = skb->truesize;
-
-	if (adjust && !skb_headlen(skb)) {
-		truesize -= SKB_TRUESIZE(skb_end_offset(skb));
-		/* paranoid check, some drivers might be buggy */
-		if (unlikely((int)truesize < (int)skb->len))
-			truesize = skb->truesize;
-	}
-	return truesize;
-}
-
-static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb,
-			    bool adjust)
+static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	int room;
@@ -502,16 +480,15 @@ static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb,
 
 	/* Check #1 */
 	if (room > 0 && !tcp_under_memory_pressure(sk)) {
-		unsigned int truesize = truesize_adjust(adjust, skb);
 		int incr;
 
 		/* Check #2. Increase window, if skb with such overhead
 		 * will fit to rcvbuf in future.
 		 */
-		if (tcp_win_from_space(sk, truesize) <= skb->len)
+		if (tcp_win_from_space(sk, skb->truesize) <= skb->len)
 			incr = 2 * tp->advmss;
 		else
-			incr = __tcp_grow_window(sk, skb, truesize);
+			incr = __tcp_grow_window(sk, skb);
 
 		if (incr) {
 			incr = max_t(int, incr, 2 * skb->len);
@@ -805,7 +782,7 @@ static void tcp_event_data_recv(struct sock *sk, struct sk_buff *skb)
 	tcp_ecn_check_ce(sk, skb);
 
 	if (skb->len >= 128)
-		tcp_grow_window(sk, skb, true);
+		tcp_grow_window(sk, skb);
 }
 
 /* Called to compute a smoothed rtt estimate. The data fed to this
@@ -992,8 +969,6 @@ static u32 tcp_dsack_seen(struct tcp_sock *tp, u32 start_seq,
 		return 0;
 	if (seq_len > tp->mss_cache)
 		dup_segs = DIV_ROUND_UP(seq_len, tp->mss_cache);
-	else if (tp->tlp_high_seq && tp->tlp_high_seq == end_seq)
-		state->flag |= FLAG_DSACK_TLP;
 
 	tp->dsack_dups += dup_segs;
 	/* Skip the DSACK if dup segs weren't retransmitted by sender */
@@ -1001,14 +976,7 @@ static u32 tcp_dsack_seen(struct tcp_sock *tp, u32 start_seq,
 		return 0;
 
 	tp->rx_opt.sack_ok |= TCP_DSACK_SEEN;
-	/* We increase the RACK ordering window in rounds where we receive
-	 * DSACKs that may have been due to reordering causing RACK to trigger
-	 * a spurious fast recovery. Thus RACK ignores DSACKs that happen
-	 * without having seen reordering, or that match TLP probes (TLP
-	 * is timer-driven, not triggered by RACK).
-	 */
-	if (tp->reord_seen && !(state->flag & FLAG_DSACK_TLP))
-		tp->rack.dsack_seen = 1;
+	tp->rack.dsack_seen = 1;
 
 	state->flag |= FLAG_DSACKING_ACK;
 	/* A spurious retransmission is delivered */
@@ -3660,7 +3628,7 @@ static void tcp_process_tlp_ack(struct sock *sk, u32 ack, int flag)
 	if (!tp->tlp_retrans) {
 		/* TLP of new data has been acknowledged */
 		tp->tlp_high_seq = 0;
-	} else if (flag & FLAG_DSACK_TLP) {
+	} else if (flag & FLAG_DSACKING_ACK) {
 		/* This DSACK means original and TLP probe arrived; no loss */
 		tp->tlp_high_seq = 0;
 	} else if (after(ack, tp->tlp_high_seq)) {
@@ -4679,9 +4647,10 @@ static bool tcp_ooo_try_coalesce(struct sock *sk,
 /* tcp_drop with reason
  */
 static void tcp_drop(struct sock *sk, struct sk_buff *skb,
-		 __u32 reason)
+		 int field, char *reason)
 {
-	trace_tcp_drop(sk, skb, reason);
+	trace_tcp_drop(sk, skb, field, reason);
+	sk_drops_add(sk, skb);
 	__kfree_skb(skb);
 }
 
@@ -4712,7 +4681,7 @@ static void tcp_ofo_queue(struct sock *sk)
 		rb_erase(&skb->rbnode, &tp->out_of_order_queue);
 
 		if (unlikely(!after(TCP_SKB_CB(skb)->end_seq, tp->rcv_nxt))) {
-			tcp_drop(sk, skb, TCP_OFO_QUEUE);
+			tcp_drop(sk, skb, LINUX_MIB_TCPOFOQUEUE, "Tcp queue error");
 			continue;
 		}
 
@@ -4768,7 +4737,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 	if (unlikely(tcp_try_rmem_schedule(sk, skb, skb->truesize))) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFODROP);
 		sk->sk_data_ready(sk);
-		tcp_drop(sk, skb, TCP_DATA_QUEUE_OFO);
+		tcp_drop(sk, skb, LINUX_MIB_TCPOFODROP, "Tcp rmem failed");
 		return;
 	}
 
@@ -4805,7 +4774,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 		 * and trigger fast retransmit.
 		 */
 		if (tcp_is_sack(tp))
-			tcp_grow_window(sk, skb, true);
+			tcp_grow_window(sk, skb);
 		kfree_skb_partial(skb, fragstolen);
 		skb = NULL;
 		goto add_sack;
@@ -4831,7 +4800,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 				/* All the bits are present. Drop. */
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPOFOMERGE);
-				tcp_drop(sk, skb, TCP_DATA_QUEUE_OFO);
+				tcp_drop(sk, skb, LINUX_MIB_TCPOFOMERGE, "Tcp bits are present");
 				skb = NULL;
 				tcp_dsack_set(sk, seq, end_seq);
 				goto add_sack;
@@ -4850,7 +4819,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 						 TCP_SKB_CB(skb1)->end_seq);
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPOFOMERGE);
-				tcp_drop(sk, skb1, TCP_DATA_QUEUE_OFO);
+				tcp_drop(sk, skb1, LINUX_MIB_TCPOFOMERGE, "Tcp replace(skb.seq eq skb1.seq)");
 				goto merge_right;
 			}
 		} else if (tcp_ooo_try_coalesce(sk, skb1,
@@ -4878,7 +4847,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 		tcp_dsack_extend(sk, TCP_SKB_CB(skb1)->seq,
 				 TCP_SKB_CB(skb1)->end_seq);
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFOMERGE);
-		tcp_drop(sk, skb1, TCP_DATA_QUEUE_OFO);
+		tcp_drop(sk, skb1, LINUX_MIB_TCPOFOMERGE, "Tcp useless other segments");
 	}
 	/* If there is no skb after us, we are the last_skb ! */
 	if (!skb1)
@@ -4893,7 +4862,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 		 * and trigger fast retransmit.
 		 */
 		if (tcp_is_sack(tp))
-			tcp_grow_window(sk, skb, false);
+			tcp_grow_window(sk, skb);
 		skb_condense(skb);
 		skb_set_owner_r(skb, sk);
 	}
@@ -5014,7 +4983,8 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 		else if (tcp_try_rmem_schedule(sk, skb, skb->truesize)) {
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPRCVQDROP);
 			sk->sk_data_ready(sk);
-			goto drop;
+			tcp_drop(sk, skb, LINUX_MIB_TCPRCVQDROP, "Tcp rmem failed");
+			goto end;
 		}
 
 		eaten = tcp_queue_rcv(sk, skb, &fragstolen);
@@ -5054,8 +5024,8 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 out_of_window:
 		tcp_enter_quickack_mode(sk, TCP_MAX_QUICKACKS);
 		inet_csk_schedule_ack(sk);
-drop:
-		tcp_drop(sk, skb, TCP_DATA_QUEUE);
+		tcp_drop(sk, skb, LINUX_MIB_TCPZEROWINDOWDROP, "Tcp out of order or zero window");
+end:
 		return;
 	}
 
@@ -5312,7 +5282,7 @@ static bool tcp_prune_ofo_queue(struct sock *sk)
 		prev = rb_prev(node);
 		rb_erase(node, &tp->out_of_order_queue);
 		goal -= rb_to_skb(node)->truesize;
-		tcp_drop(sk, rb_to_skb(node), TCP_PRUNE_OFO_QUEUE);
+		tcp_drop(sk, rb_to_skb(node), LINUX_MIB_OFOPRUNED, "Tcp drop out-of-order queue");
 		if (!prev || goal <= 0) {
 			sk_mem_reclaim(sk);
 			if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf &&
@@ -5419,7 +5389,7 @@ static void tcp_new_space(struct sock *sk)
 		tp->snd_cwnd_stamp = tcp_jiffies32;
 	}
 
-	INDIRECT_CALL_1(sk->sk_write_space, sk_stream_write_space, sk);
+	sk->sk_write_space(sk);
 }
 
 static void tcp_check_space(struct sock *sk)
@@ -5647,7 +5617,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 						  LINUX_MIB_TCPACKSKIPPEDPAWS,
 						  &tp->last_oow_ack_time))
 				tcp_send_dupack(sk, skb);
-			tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_VALIDATE_INCOMING));
+			tcp_drop(sk, skb, LINUX_MIB_PAWSESTABREJECTED, "Tcp PAWS seq first");
 			goto end;
 		}
 		/* Reset is accepted even if it did not pass PAWS. */
@@ -5671,7 +5641,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 		} else if (tcp_reset_check(sk, skb)) {
 			tcp_reset(sk, skb);
 		}
-		tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_VALIDATE_INCOMING));
+		tcp_drop(sk, skb, LINUX_MIB_PAWSESTABREJECTED, "Tcp check sequence number");
 		goto end;
 	}
 
@@ -5717,7 +5687,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 				tcp_fastopen_active_disable(sk);
 			tcp_send_challenge_ack(sk, skb);
 		}
-		tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_VALIDATE_INCOMING));
+		tcp_drop(sk, skb, LINUX_MIB_TCPCHALLENGEACK, "Tcp check RST bit ");
 		goto end;
 	}
 
@@ -5732,7 +5702,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 			TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNCHALLENGE);
 		tcp_send_challenge_ack(sk, skb);
-		tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_VALIDATE_INCOMING));
+		tcp_drop(sk, skb, LINUX_MIB_TCPSYNCHALLENGE, "Tcp check for a SYN");
 		goto end;
 	}
 
@@ -5858,7 +5828,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 				return;
 			} else { /* Header too small */
 				TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
-				tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_ESTABLISHED));
+				tcp_drop(sk, skb, TCP_MIB_INERRS, "Tcp header too small");
 				goto end;
 			}
 		} else {
@@ -5914,7 +5884,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 		goto csum_error;
 
 	if (!th->ack && !th->rst && !th->syn) {
-		tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_ESTABLISHED));
+		tcp_drop(sk, skb, LINUX_MIB_TCPSLOWSTARTRETRANS, "Tcp state not in ack|rst|syn");
 		goto end;
 	}
 
@@ -5927,7 +5897,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 
 step5:
 	if (tcp_ack(sk, skb, FLAG_SLOWPATH | FLAG_UPDATE_TS_RECENT) < 0) {
-		tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_ESTABLISHED));
+		tcp_drop(sk, skb, LINUX_MIB_TCPSACKDISCARD, "Tcp ack have not sent yet");
 		goto end;
 	}
 
@@ -5947,7 +5917,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 	trace_tcp_bad_csum(skb);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_CSUMERRORS);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
-	tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_ESTABLISHED));
+	tcp_drop(sk, skb, TCP_MIB_CSUMERRORS, "Tcp csum error");
 end:
 	return;
 }
@@ -6149,7 +6119,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 
 		if (th->rst) {
 			tcp_reset(sk, skb);
-			tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_SYNSENT_STATE_PROCESS));
+			tcp_drop(sk, skb, LINUX_MIB_NUM, "Tcp reset");
 			goto end;
 		}
 
@@ -6239,7 +6209,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 			tcp_enter_quickack_mode(sk, TCP_MAX_QUICKACKS);
 			inet_csk_reset_xmit_timer(sk, ICSK_TIME_DACK,
 						  TCP_DELACK_MAX, TCP_RTO_MAX);
-			tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_SYNSENT_STATE_PROCESS));
+			tcp_drop(sk, skb, LINUX_MIB_TCPFASTOPENACTIVE, "Tcp fast open ack error");
 
 end:
 			return 0;
@@ -6314,7 +6284,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		 */
 		return -1;
 #else
-		tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_SYNSENT_STATE_PROCESS));
+		tcp_drop(sk, skb, LINUX_MIB_SYNCOOKIESRECV, "Tcp syn received error");
 		goto end;
 #endif
 	}
@@ -6325,7 +6295,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 discard_and_undo:
 	tcp_clear_options(&tp->rx_opt);
 	tp->rx_opt.mss_clamp = saved_clamp;
-	tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_SYNSENT_STATE_PROCESS));
+	tcp_drop(sk, skb, LINUX_MIB_TCPSACKDISCARD, "Tcp not neither of SYN or RST");
 	goto end;
 
 reset_and_undo:
@@ -6384,7 +6354,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 
 	switch (sk->sk_state) {
 	case TCP_CLOSE:
-		tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
+		tcp_drop(sk, skb, LINUX_MIB_TCPABORTONCLOSE, "Tcp close");
 		goto end;
 
 	case TCP_LISTEN:
@@ -6392,13 +6362,13 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			return 1;
 
 		if (th->rst) {
-			tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
+			tcp_drop(sk, skb, LINUX_MIB_LISTENDROPS, "Tcp rst");
 			goto end;
 		}
 
 		if (th->syn) {
 			if (th->fin) {
-				tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
+				tcp_drop(sk, skb, LINUX_MIB_LISTENDROPS, "Tcp fin");
 				goto end;
 			}
 			/* It is possible that we process SYN packets from backlog,
@@ -6415,7 +6385,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			consume_skb(skb);
 			return 0;
 		}
-		tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
+		tcp_drop(sk, skb, LINUX_MIB_LISTENDROPS, "Tcp syn");
 		goto end;
 
 	case TCP_SYN_SENT:
@@ -6443,13 +6413,13 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		    sk->sk_state != TCP_FIN_WAIT1);
 
 		if (!tcp_check_req(sk, skb, req, true, &req_stolen)) {
-			tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
+			tcp_drop(sk, skb, LINUX_MIB_LISTENDROPS, "Tcp check req error");
 			goto end;
 		}
 	}
 
 	if (!th->ack && !th->rst && !th->syn) {
-		tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
+		tcp_drop(sk, skb, LINUX_MIB_LISTENDROPS, "Tcp not ack|rst|syn");
 		goto end;
 	}
 
@@ -6465,7 +6435,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		if (sk->sk_state == TCP_SYN_RECV)
 			return 1;	/* send one RST */
 		tcp_send_challenge_ack(sk, skb);
-		tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
+		tcp_drop(sk, skb, LINUX_MIB_TCPCHALLENGEACK, "Tcp check ack failed");
 		goto end;
 	}
 	switch (sk->sk_state) {
@@ -6559,7 +6529,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			inet_csk_reset_keepalive_timer(sk, tmo);
 		} else {
 			tcp_time_wait(sk, TCP_FIN_WAIT2, tmo);
-			tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
+			tcp_drop(sk, skb, LINUX_MIB_TCPABORTONDATA, "Tcp fin wait2");
 			goto end;
 		}
 		break;
@@ -6568,7 +6538,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 	case TCP_CLOSING:
 		if (tp->snd_una == tp->write_seq) {
 			tcp_time_wait(sk, TCP_TIME_WAIT, 0);
-			tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
+			tcp_drop(sk, skb, LINUX_MIB_TIMEWAITED, "Tcp time wait");
 			goto end;
 		}
 		break;
@@ -6577,7 +6547,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		if (tp->snd_una == tp->write_seq) {
 			tcp_update_metrics(sk);
 			tcp_done(sk);
-			tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
+			tcp_drop(sk, skb, LINUX_MIB_TCPPUREACKS, "Tcp last ack");
 			goto end;
 		}
 		break;
@@ -6596,7 +6566,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			 * continue to be processed, drop the packet.
 			 */
 			if (sk_is_mptcp(sk) && !mptcp_incoming_options(sk, skb)) {
-				tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
+				tcp_drop(sk, skb, LINUX_MIB_TCPPUREACKS, "Tcp subflow been reset");
 				goto end;
 			}
 			break;
@@ -6630,7 +6600,7 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 	}
 
 	if (!queued) {
-		tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
+		tcp_drop(sk, skb, LINUX_MIB_TCPOFOQUEUE, "Tcp rcv synsent state process");
 	}
 
 end:
-- 
2.25.1

