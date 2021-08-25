Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318903F793B
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 17:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240461AbhHYPlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 11:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbhHYPls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 11:41:48 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09869C061757;
        Wed, 25 Aug 2021 08:41:03 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so4187134pje.0;
        Wed, 25 Aug 2021 08:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E0acZteVNB6bdCtIp/5XbiopasQnADo+xEQHQFmWG/c=;
        b=S1RZH45kmE8OON74359skFQWMNEwZevH5vagQqDm95ydeqDjHPh0sXy/A10mXBVJxu
         1XgT9ZYN2u+quDla+N+i8sKm1HFVFNyxKmx1HD05aOkM+xP40uOxs4Ci0wwLGZHyS4k2
         LM1PD9Igf/t3rYAY66/ddjEZMrtI/Zlqakdg5ZRwYjTrVw/aGiw8uaghgj8HLYCERUWs
         YfZKcjnfPo7MNwlmSjoodFhD/8jJGlBVsKmvrsSjnvF+jOd8oFtC+3P11LiyVF0NU8GK
         zLAc0K0GB2Yl/2PFh3BNY4mbf6hE3Y49+wrs1Abylh80D21qc5vHFBZS9edaWD7wxrRQ
         qtvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E0acZteVNB6bdCtIp/5XbiopasQnADo+xEQHQFmWG/c=;
        b=qnFiMT63oKPOetjZtE0efcEc7TchhyF9JSzOVoErmpzVix2Ta7yq2TbGrSzH/FnZon
         QUBwgvEA7YLo8vVxxQ9JBUzCyfsgsD8b08r1O422Frw8nh8DthHuxQ4qSdBz9owwleq1
         NO+eLqOodKFxnIuLkt11sSrk16ge92dM9rjark9Yzi+g+oEMkS0326651x6D2+Wnhdcy
         m0rCPUC/w0dHsvAeWga8nYXOIn5SC98ULV33/rgXo0CLp8KU2bH4u60lJs9gcU9qOarE
         8lmKsbNUQct8k82SHjjOGkcYrcFNXni8HpSF638VyMNiK57hT3ISghdSpb6nQQ407T+q
         k6xg==
X-Gm-Message-State: AOAM532W3/GwV974h0mG0Gzbt9U0/SmWhw/Zu+dbFreUTZ7QCgsspJ5x
        jA9AbDForLx4CCkYIjeoKQM=
X-Google-Smtp-Source: ABdhPJzE+Hji5DahEjxMdpraFODw3NxPPd96N9e/YbCLcTiRGJBEuWyCAZhRsM2Xqz8lVeGrTpipfg==
X-Received: by 2002:a17:90a:8b8d:: with SMTP id z13mr11242309pjn.1.1629906062474;
        Wed, 25 Aug 2021 08:41:02 -0700 (PDT)
Received: from localhost.localdomain ([221.225.34.48])
        by smtp.googlemail.com with ESMTPSA id y13sm6038209pjr.50.2021.08.25.08.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 08:41:02 -0700 (PDT)
From:   Zhongya Yan <yan2228598786@gmail.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        edumazet@google.com, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        hengqi.chen@gmail.com, yhs@fb.com,
        Zhongya Yan <yan2228598786@gmail.com>
Subject: [PATCH] net: tcp_drop adds `reason` parameter for tracing v2
Date:   Wed, 25 Aug 2021 08:40:43 -0700
Message-Id: <20210825154043.247764-1-yan2228598786@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this version, fix and modify some code issues. Changed the reason for `tcp_drop` from an enumeration to a mask and enumeration usage in the trace output.
By shifting `__LINE__` left by 6 bits to accommodate the `tcp_drop` call method source, 6 bits are enough to use. This allows for a more granular identification of the reason for calling `tcp_drop` without conflicts and essentially without overflow.
Example.
```
enum {
TCP_OFO_QUEUE = 1
}
reason = __LINE__ << 6
reason |= TCP_OFO_QUEUE
```
Suggestions from Jakub Kicinski, Eric Dumazet, much appreciated.

Modified the expression of the enumeration, and the use of the output under the trace definition.
Suggestion from Steven Rostedt. Thanks.

Signed-off-by: Zhongya Yan <yan2228598786@gmail.com>
---
 include/net/tcp.h          |  18 +++---
 include/trace/events/tcp.h |  39 +++++++++++--
 net/ipv4/tcp_input.c       | 114 ++++++++++++++++++++++---------------
 3 files changed, 112 insertions(+), 59 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index dd8cd8d6f2f1..75614a252675 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -256,15 +256,19 @@ extern unsigned long tcp_memory_pressure;
 
 enum tcp_drop_reason {
 	TCP_OFO_QUEUE = 1,
-	TCP_DATA_QUEUE_OFO = 2,
-	TCP_DATA_QUEUE = 3,
-	TCP_PRUNE_OFO_QUEUE = 4,
-	TCP_VALIDATE_INCOMING = 5,
-	TCP_RCV_ESTABLISHED = 6,
-	TCP_RCV_SYNSENT_STATE_PROCESS = 7,
-	TCP_RCV_STATE_PROCESS = 8
+	TCP_DATA_QUEUE_OFO,
+	TCP_DATA_QUEUE,
+	TCP_PRUNE_OFO_QUEUE,
+	TCP_VALIDATE_INCOMING,
+	TCP_RCV_ESTABLISHED,
+	TCP_RCV_SYNSENT_STATE_PROCESS,
+	TCP_RCV_STATE_PROCESS
 };
 
+#define TCP_DROP_MASK(line, code)	((line << 6) | code) /* reason for masking */
+#define TCP_DROP_LINE(mask)		(mask >> 6)	/* Cause decode to get unique identifier */
+#define TCP_DROP_CODE(mask)		(mask&0x3F) /* Cause decode get function code */
+
 /* optimized version of sk_under_memory_pressure() for TCP sockets */
 static inline bool tcp_under_memory_pressure(const struct sock *sk)
 {
diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
index a0d3d31eb591..699539702ea9 100644
--- a/include/trace/events/tcp.h
+++ b/include/trace/events/tcp.h
@@ -371,8 +371,26 @@ DEFINE_EVENT(tcp_event_skb, tcp_bad_csum,
 	TP_ARGS(skb)
 );
 
+// from author @{Steven Rostedt}
+#define TCP_DROP_REASON							\
+	REASON_STRING(TCP_OFO_QUEUE,		ofo_queue)			\
+	REASON_STRING(TCP_DATA_QUEUE_OFO,		data_queue_ofo)			\
+	REASON_STRING(TCP_DATA_QUEUE,		data_queue)			\
+	REASON_STRING(TCP_PRUNE_OFO_QUEUE,		prune_ofo_queue)		\
+	REASON_STRING(TCP_VALIDATE_INCOMING,	validate_incoming)		\
+	REASON_STRING(TCP_RCV_ESTABLISHED,		rcv_established)		\
+	REASON_STRING(TCP_RCV_SYNSENT_STATE_PROCESS, rcv_synsent_state_process)	\
+	REASON_STRINGe(TCP_RCV_STATE_PROCESS,	rcv_state_proces)
+
+#undef REASON_STRING
+#undef REASON_STRINGe
+
+#define REASON_STRING(code, name) {code , #name},
+#define REASON_STRINGe(code, name) {code, #name}
+
+
 TRACE_EVENT(tcp_drop,
-		TP_PROTO(struct sock *sk, struct sk_buff *skb, enum tcp_drop_reason reason),
+		TP_PROTO(struct sock *sk, struct sk_buff *skb, __u32 reason),
 
 		TP_ARGS(sk, skb, reason),
 
@@ -392,6 +410,8 @@ TRACE_EVENT(tcp_drop,
 			__field(__u32, rcv_wnd)
 			__field(__u64, sock_cookie)
 			__field(__u32, reason)
+			__field(__u32, reason_code)
+			__field(__u32, reason_line)
 			),
 
 		TP_fast_assign(
@@ -415,16 +435,23 @@ TRACE_EVENT(tcp_drop,
 				__entry->snd_wnd = tp->snd_wnd;
 				__entry->rcv_wnd = tp->rcv_wnd;
 				__entry->ssthresh = tcp_current_ssthresh(sk);
-		__entry->srtt = tp->srtt_us >> 3;
-		__entry->sock_cookie = sock_gen_cookie(sk);
-		__entry->reason = reason;
+				__entry->srtt = tp->srtt_us >> 3;
+				__entry->sock_cookie = sock_gen_cookie(sk);
+				__entry->reason = reason;
+				__entry->reason_code = TCP_DROP_CODE(reason);
+				__entry->reason_line = TCP_DROP_LINE(reason);
 		),
 
-		TP_printk("src=%pISpc dest=%pISpc mark=%#x data_len=%d snd_nxt=%#x snd_una=%#x snd_cwnd=%u ssthresh=%u snd_wnd=%u srtt=%u rcv_wnd=%u sock_cookie=%llx reason=%d",
+		TP_printk("src=%pISpc dest=%pISpc mark=%#x data_len=%d snd_nxt=%#x snd_una=%#x \
+				snd_cwnd=%u ssthresh=%u snd_wnd=%u srtt=%u rcv_wnd=%u \
+				sock_cookie=%llx reason=%d reason_type=%s reason_line=%d",
 				__entry->saddr, __entry->daddr, __entry->mark,
 				__entry->data_len, __entry->snd_nxt, __entry->snd_una,
 				__entry->snd_cwnd, __entry->ssthresh, __entry->snd_wnd,
-				__entry->srtt, __entry->rcv_wnd, __entry->sock_cookie, __entry->reason)
+				__entry->srtt, __entry->rcv_wnd, __entry->sock_cookie,
+				__entry->reason,
+				__print_symbolic(__entry->reason_code, TCP_DROP_REASON),
+				__entry->reason_line)
 );
 
 #endif /* _TRACE_TCP_H */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 83e31661876b..7dfcc4253c35 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4643,20 +4643,14 @@ static bool tcp_ooo_try_coalesce(struct sock *sk,
 	return res;
 }
 
-static void __tcp_drop(struct sock *sk,
-		   struct sk_buff *skb)
-{
-	sk_drops_add(sk, skb);
-	__kfree_skb(skb);
-}
 
-/* tcp_drop whit reason,for epbf trace
+/* tcp_drop with reason
  */
 static void tcp_drop(struct sock *sk, struct sk_buff *skb,
-		 enum tcp_drop_reason reason)
+		 __u32 reason)
 {
 	trace_tcp_drop(sk, skb, reason);
-	__tcp_drop(sk, skb);
+	__kfree_skb(skb);
 }
 
 /* This one checks to see if we can put data from the
@@ -5621,7 +5615,8 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 						  LINUX_MIB_TCPACKSKIPPEDPAWS,
 						  &tp->last_oow_ack_time))
 				tcp_send_dupack(sk, skb);
-			goto discard;
+			tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_VALIDATE_INCOMING));
+			goto end;
 		}
 		/* Reset is accepted even if it did not pass PAWS. */
 	}
@@ -5644,7 +5639,8 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 		} else if (tcp_reset_check(sk, skb)) {
 			tcp_reset(sk, skb);
 		}
-		goto discard;
+		tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_VALIDATE_INCOMING));
+		goto end;
 	}
 
 	/* Step 2: check RST bit */
@@ -5689,7 +5685,8 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 				tcp_fastopen_active_disable(sk);
 			tcp_send_challenge_ack(sk, skb);
 		}
-		goto discard;
+		tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_VALIDATE_INCOMING));
+		goto end;
 	}
 
 	/* step 3: check security and precedence [ignored] */
@@ -5703,15 +5700,15 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 			TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNCHALLENGE);
 		tcp_send_challenge_ack(sk, skb);
-		goto discard;
+		tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_VALIDATE_INCOMING));
+		goto end;
 	}
 
 	bpf_skops_parse_hdr(sk, skb);
 
 	return true;
 
-discard:
-	tcp_drop(sk, skb, TCP_VALIDATE_INCOMING);
+end:
 	return false;
 }
 
@@ -5829,7 +5826,8 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 				return;
 			} else { /* Header too small */
 				TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
-				goto discard;
+				tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_ESTABLISHED));
+				goto end;
 			}
 		} else {
 			int eaten = 0;
@@ -5883,8 +5881,10 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 	if (len < (th->doff << 2) || tcp_checksum_complete(skb))
 		goto csum_error;
 
-	if (!th->ack && !th->rst && !th->syn)
-		goto discard;
+	if (!th->ack && !th->rst && !th->syn) {
+		tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_ESTABLISHED));
+		goto end;
+	}
 
 	/*
 	 *	Standard slow path.
@@ -5894,8 +5894,10 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 		return;
 
 step5:
-	if (tcp_ack(sk, skb, FLAG_SLOWPATH | FLAG_UPDATE_TS_RECENT) < 0)
-		goto discard;
+	if (tcp_ack(sk, skb, FLAG_SLOWPATH | FLAG_UPDATE_TS_RECENT) < 0) {
+		tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_ESTABLISHED));
+		goto end;
+	}
 
 	tcp_rcv_rtt_measure_ts(sk, skb);
 
@@ -5913,9 +5915,9 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 	trace_tcp_bad_csum(skb);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_CSUMERRORS);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
-
-discard:
-	tcp_drop(sk, skb, TCP_RCV_ESTABLISHED);
+	tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_ESTABLISHED));
+end:
+	return;
 }
 EXPORT_SYMBOL(tcp_rcv_established);
 
@@ -6115,7 +6117,8 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 
 		if (th->rst) {
 			tcp_reset(sk, skb);
-			goto discard;
+			tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_SYNSENT_STATE_PROCESS));
+			goto end;
 		}
 
 		/* rfc793:
@@ -6204,9 +6207,9 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 			tcp_enter_quickack_mode(sk, TCP_MAX_QUICKACKS);
 			inet_csk_reset_xmit_timer(sk, ICSK_TIME_DACK,
 						  TCP_DELACK_MAX, TCP_RTO_MAX);
+			tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_SYNSENT_STATE_PROCESS));
 
-discard:
-			tcp_drop(sk, skb, TCP_RCV_SYNSENT_STATE_PROCESS);
+end:
 			return 0;
 		} else {
 			tcp_send_ack(sk);
@@ -6279,7 +6282,8 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		 */
 		return -1;
 #else
-		goto discard;
+		tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_SYNSENT_STATE_PROCESS));
+		goto end;
 #endif
 	}
 	/* "fifth, if neither of the SYN or RST bits is set then
@@ -6289,7 +6293,8 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 discard_and_undo:
 	tcp_clear_options(&tp->rx_opt);
 	tp->rx_opt.mss_clamp = saved_clamp;
-	goto discard;
+	tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_SYNSENT_STATE_PROCESS));
+	goto end;
 
 reset_and_undo:
 	tcp_clear_options(&tp->rx_opt);
@@ -6347,18 +6352,23 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 
 	switch (sk->sk_state) {
 	case TCP_CLOSE:
-		goto discard;
+		tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
+		goto end;
 
 	case TCP_LISTEN:
 		if (th->ack)
 			return 1;
 
-		if (th->rst)
-			goto discard;
+		if (th->rst) {
+			tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
+			goto end;
+		}
 
 		if (th->syn) {
-			if (th->fin)
-				goto discard;
+			if (th->fin) {
+				tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
+				goto end;
+			}
 			/* It is possible that we process SYN packets from backlog,
 			 * so we need to make sure to disable BH and RCU right there.
 			 */
@@ -6373,7 +6383,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			consume_skb(skb);
 			return 0;
 		}
-		goto discard;
+		tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
+		goto end;
 
 	case TCP_SYN_SENT:
 		tp->rx_opt.saw_tstamp = 0;
@@ -6399,12 +6410,16 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		WARN_ON_ONCE(sk->sk_state != TCP_SYN_RECV &&
 		    sk->sk_state != TCP_FIN_WAIT1);
 
-		if (!tcp_check_req(sk, skb, req, true, &req_stolen))
-			goto discard;
+		if (!tcp_check_req(sk, skb, req, true, &req_stolen)) {
+			tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
+			goto end;
+		}
 	}
 
-	if (!th->ack && !th->rst && !th->syn)
-		goto discard;
+	if (!th->ack && !th->rst && !th->syn) {
+		tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
+		goto end;
+	}
 
 	if (!tcp_validate_incoming(sk, skb, th, 0))
 		return 0;
@@ -6418,7 +6433,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		if (sk->sk_state == TCP_SYN_RECV)
 			return 1;	/* send one RST */
 		tcp_send_challenge_ack(sk, skb);
-		goto discard;
+		tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
+		goto end;
 	}
 	switch (sk->sk_state) {
 	case TCP_SYN_RECV:
@@ -6511,7 +6527,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			inet_csk_reset_keepalive_timer(sk, tmo);
 		} else {
 			tcp_time_wait(sk, TCP_FIN_WAIT2, tmo);
-			goto discard;
+			tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
+			goto end;
 		}
 		break;
 	}
@@ -6519,7 +6536,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 	case TCP_CLOSING:
 		if (tp->snd_una == tp->write_seq) {
 			tcp_time_wait(sk, TCP_TIME_WAIT, 0);
-			goto discard;
+			tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
+			goto end;
 		}
 		break;
 
@@ -6527,7 +6545,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		if (tp->snd_una == tp->write_seq) {
 			tcp_update_metrics(sk);
 			tcp_done(sk);
-			goto discard;
+			tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
+			goto end;
 		}
 		break;
 	}
@@ -6544,8 +6563,10 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			/* If a subflow has been reset, the packet should not
 			 * continue to be processed, drop the packet.
 			 */
-			if (sk_is_mptcp(sk) && !mptcp_incoming_options(sk, skb))
-				goto discard;
+			if (sk_is_mptcp(sk) && !mptcp_incoming_options(sk, skb)) {
+				tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
+				goto end;
+			}
 			break;
 		}
 		fallthrough;
@@ -6577,9 +6598,10 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 	}
 
 	if (!queued) {
-discard:
-		tcp_drop(sk, skb, TCP_RCV_STATE_PROCESS);
+		tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_RCV_STATE_PROCESS));
 	}
+
+end:
 	return 0;
 }
 EXPORT_SYMBOL(tcp_rcv_state_process);
-- 
2.25.1

