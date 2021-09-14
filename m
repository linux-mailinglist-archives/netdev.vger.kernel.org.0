Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C0540B105
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 16:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234239AbhINOhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 10:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234434AbhINOg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 10:36:56 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA19C0613F0;
        Tue, 14 Sep 2021 07:35:26 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id k23so9046233pji.0;
        Tue, 14 Sep 2021 07:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DEZH2347d3OwB/ufoS8jLCYgqKcvh/fxAEugGWBuoms=;
        b=nFyHXq6mJg0k3WhrAEuBrSWVidp8bMsaN3A0CKzui5DLBcm0T4xCGVC1DnvLHBlUYL
         jZLAhmqJN5hirG9w4OFVaWMtM3r+PIteHTZquvLWCJms4Dg7wKfKjKha5BBJbI+n12/v
         NOkCUk/NBzFtm3Dw3U+AO0mlMeEAgGLWx69eKPE6bnSo711DQiP2U6op9roPPSN+1Bro
         CawsP59RYrdl3A1tb67+abdObmXv0B/O51Db9JwH++JBZHuqOaszD/7Xtileh2bQQ1mr
         K7sAcVpIeWyMkffHCR8pVEwTCV7lVWex5KEckjmLRyUacUKou+tCkauDcEJbLIyLMYNu
         PZzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DEZH2347d3OwB/ufoS8jLCYgqKcvh/fxAEugGWBuoms=;
        b=sdibb3yB12z0VKfnSDvjSDETaKDmW9WR8RRu3DR1Jt94lhLBnYl5z/9vsyycMNcZiY
         wiocqUrmpogGe/e/auGpcKXEOWgGi23sfbpIv4eL+1HxfAuo81NJ3OsXg29uBOMMjUZJ
         ADeENR3W9EPRTb2pPlVd8SVfprFC8nYRx25dzTJnSIjkKkXoAeRX86GrKeA6DWfjgt8V
         1/JjALA6Hf966HLIXoWNuvq0IWnIHaxBlPI4zCuDNfd3wBMTRJcPQyItWCIPTK5W4AOY
         M8O6ikXqjN4jMOanFaPBLBC7hmS7kclKb4d0qqqz/GlbhPOjKBh62ZrkQPjJI02Y+zXU
         jjDQ==
X-Gm-Message-State: AOAM531j2S36yOIsQd9cO+iyorYRJtOy94EDsUAYncv33lXMMOiETkaO
        EHo3L/51iLECzo6X3Y1mMks=
X-Google-Smtp-Source: ABdhPJyH4JVeyUknY0AVdbMvI+lashU1Ot27ZMSTrYoDL8w5hStQMAbr+paS2/4Jausb4cAinRyCVw==
X-Received: by 2002:a17:902:6b8a:b029:12d:3f99:9e5e with SMTP id p10-20020a1709026b8ab029012d3f999e5emr15341011plk.66.1631630126220;
        Tue, 14 Sep 2021 07:35:26 -0700 (PDT)
Received: from localhost.localdomain ([101.229.51.254])
        by smtp.googlemail.com with ESMTPSA id a20sm1843453pjh.46.2021.09.14.07.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 07:35:25 -0700 (PDT)
From:   Zhongya Yan <yan2228598786@gmail.com>
To:     edumazet@google.com, rostedt@goodmis.org, brendan.d.gregg@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, yhs@fb.com,
        2228598786@qq.com, Zhongya Yan <yan2228598786@gmail.com>
Subject: [PATCH] tcp: tcp_drop adds `SNMP` and `reason` parameter for tracing
Date:   Tue, 14 Sep 2021 07:35:15 -0700
Message-Id: <20210914143515.106394-1-yan2228598786@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we wanted to trace the use of the `tcp_drop(struct sock *sk, struct sk_buff *skb)` function, we didn't know why `tcp` was deleting `skb'. To solve this problem, I updated the function `tcp_drop(struct sock *sk, struct sk_buff *skb, int field, const char *reason)`.
This way you can understand the reason for the deletion based on the prompt message.
`field`: represents the SNMP-related value
`reason`: represents the reason why `tcp` deleted the current `skb`, and contains some hints.
Of course, if you want to know more about the reason for updating the current function, you can check: https://www.brendangregg.com/blog/2018-05-31/linux-tcpdrop.html

Signed-off-by: Zhongya Yan <yan2228598786@gmail.com>
---
 include/trace/events/tcp.h |  62 ++++++++++++++++++
 net/ipv4/tcp_input.c       | 126 +++++++++++++++++++++++--------------
 2 files changed, 142 insertions(+), 46 deletions(-)

diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
index 521059d8dc0a..68bbe8741ce8 100644
--- a/include/trace/events/tcp.h
+++ b/include/trace/events/tcp.h
@@ -371,6 +371,68 @@ DEFINE_EVENT(tcp_event_skb, tcp_bad_csum,
 	TP_ARGS(skb)
 );
 
+TRACE_EVENT(tcp_drop,
+		TP_PROTO(struct sock *sk, struct sk_buff *skb, int field, const char *reason),
+
+		TP_ARGS(sk, skb, field, reason),
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
+			__field(int, field)
+			__string(reason, reason)
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
+				__entry->srtt = tp->srtt_us >> 3;
+				__entry->sock_cookie = sock_gen_cookie(sk);
+				__entry->field = field;
+
+				__assign_str(reason, reason);
+		),
+
+		TP_printk("src=%pISpc dest=%pISpc mark=%#x data_len=%d snd_nxt=%#x snd_una=%#x \
+				snd_cwnd=%u ssthresh=%u snd_wnd=%u srtt=%u rcv_wnd=%u \
+				sock_cookie=%llx field=%d reason=%s",
+				__entry->saddr, __entry->daddr, __entry->mark,
+				__entry->data_len, __entry->snd_nxt, __entry->snd_una,
+				__entry->snd_cwnd, __entry->ssthresh, __entry->snd_wnd,
+				__entry->srtt, __entry->rcv_wnd, __entry->sock_cookie,
+				__entry->field, __get_str(reason))
+);
+
 #endif /* _TRACE_TCP_H */
 
 /* This part must be outside protection */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 3f7bd7ae7d7a..1cebdcafb00f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4675,8 +4675,10 @@ static bool tcp_ooo_try_coalesce(struct sock *sk,
 	return res;
 }
 
-static void tcp_drop(struct sock *sk, struct sk_buff *skb)
+static void tcp_drop(struct sock *sk, struct sk_buff *skb,
+		int field, const char *reason)
 {
+	trace_tcp_drop(sk, skb, field, reason);
 	sk_drops_add(sk, skb);
 	__kfree_skb(skb);
 }
@@ -4708,7 +4710,7 @@ static void tcp_ofo_queue(struct sock *sk)
 		rb_erase(&skb->rbnode, &tp->out_of_order_queue);
 
 		if (unlikely(!after(TCP_SKB_CB(skb)->end_seq, tp->rcv_nxt))) {
-			tcp_drop(sk, skb);
+			tcp_drop(sk, skb, LINUX_MIB_TCPOFOQUEUE, "TCP queue error");
 			continue;
 		}
 
@@ -4764,7 +4766,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 	if (unlikely(tcp_try_rmem_schedule(sk, skb, skb->truesize))) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFODROP);
 		sk->sk_data_ready(sk);
-		tcp_drop(sk, skb);
+		tcp_drop(sk, skb, LINUX_MIB_TCPOFODROP, "TCP rmem failed");
 		return;
 	}
 
@@ -4827,7 +4829,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 				/* All the bits are present. Drop. */
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPOFOMERGE);
-				tcp_drop(sk, skb);
+				tcp_drop(sk, skb, LINUX_MIB_TCPOFOMERGE, "TCP bits are present");
 				skb = NULL;
 				tcp_dsack_set(sk, seq, end_seq);
 				goto add_sack;
@@ -4846,7 +4848,9 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 						 TCP_SKB_CB(skb1)->end_seq);
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPOFOMERGE);
-				tcp_drop(sk, skb1);
+				tcp_drop(sk, skb1, LINUX_MIB_TCPOFOMERGE,
+						"TCP replace(skb.seq eq skb1.seq)");
+
 				goto merge_right;
 			}
 		} else if (tcp_ooo_try_coalesce(sk, skb1,
@@ -4874,7 +4878,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 		tcp_dsack_extend(sk, TCP_SKB_CB(skb1)->seq,
 				 TCP_SKB_CB(skb1)->end_seq);
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFOMERGE);
-		tcp_drop(sk, skb1);
+		tcp_drop(sk, skb1, LINUX_MIB_TCPOFOMERGE, "TCP useless other segments");
 	}
 	/* If there is no skb after us, we are the last_skb ! */
 	if (!skb1)
@@ -5010,7 +5014,8 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 		else if (tcp_try_rmem_schedule(sk, skb, skb->truesize)) {
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPRCVQDROP);
 			sk->sk_data_ready(sk);
-			goto drop;
+			tcp_drop(sk, skb, LINUX_MIB_TCPRCVQDROP, "TCP rmem failed");
+			goto end;
 		}
 
 		eaten = tcp_queue_rcv(sk, skb, &fragstolen);
@@ -5050,8 +5055,8 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 out_of_window:
 		tcp_enter_quickack_mode(sk, TCP_MAX_QUICKACKS);
 		inet_csk_schedule_ack(sk);
-drop:
-		tcp_drop(sk, skb);
+		tcp_drop(sk, skb, LINUX_MIB_TCPZEROWINDOWDROP, "TCP out of order or zero window");
+end:
 		return;
 	}
 
@@ -5308,7 +5313,7 @@ static bool tcp_prune_ofo_queue(struct sock *sk)
 		prev = rb_prev(node);
 		rb_erase(node, &tp->out_of_order_queue);
 		goal -= rb_to_skb(node)->truesize;
-		tcp_drop(sk, rb_to_skb(node));
+		tcp_drop(sk, rb_to_skb(node), LINUX_MIB_OFOPRUNED, "TCP drop out-of-order queue");
 		if (!prev || goal <= 0) {
 			sk_mem_reclaim(sk);
 			if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf &&
@@ -5643,7 +5648,8 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 						  LINUX_MIB_TCPACKSKIPPEDPAWS,
 						  &tp->last_oow_ack_time))
 				tcp_send_dupack(sk, skb);
-			goto discard;
+			tcp_drop(sk, skb, LINUX_MIB_PAWSESTABREJECTED, "TCP PAWS seq first");
+			goto end;
 		}
 		/* Reset is accepted even if it did not pass PAWS. */
 	}
@@ -5666,7 +5672,8 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 		} else if (tcp_reset_check(sk, skb)) {
 			tcp_reset(sk, skb);
 		}
-		goto discard;
+		tcp_drop(sk, skb, LINUX_MIB_PAWSESTABREJECTED, "TCP check sequence number");
+		goto end;
 	}
 
 	/* Step 2: check RST bit */
@@ -5711,7 +5718,8 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 				tcp_fastopen_active_disable(sk);
 			tcp_send_challenge_ack(sk, skb);
 		}
-		goto discard;
+		tcp_drop(sk, skb, LINUX_MIB_TCPCHALLENGEACK, "TCP check RST bit ");
+		goto end;
 	}
 
 	/* step 3: check security and precedence [ignored] */
@@ -5725,15 +5733,15 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 			TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNCHALLENGE);
 		tcp_send_challenge_ack(sk, skb);
-		goto discard;
+		tcp_drop(sk, skb, LINUX_MIB_TCPSYNCHALLENGE, "TCP check for a SYN");
+		goto end;
 	}
 
 	bpf_skops_parse_hdr(sk, skb);
 
 	return true;
 
-discard:
-	tcp_drop(sk, skb);
+end:
 	return false;
 }
 
@@ -5851,7 +5859,8 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 				return;
 			} else { /* Header too small */
 				TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
-				goto discard;
+				tcp_drop(sk, skb, TCP_MIB_INERRS, "TCP header too small");
+				goto end;
 			}
 		} else {
 			int eaten = 0;
@@ -5905,8 +5914,10 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 	if (len < (th->doff << 2) || tcp_checksum_complete(skb))
 		goto csum_error;
 
-	if (!th->ack && !th->rst && !th->syn)
-		goto discard;
+	if (!th->ack && !th->rst && !th->syn) {
+		tcp_drop(sk, skb, LINUX_MIB_TCPSLOWSTARTRETRANS, "TCP state not in ack|rst|syn");
+		goto end;
+	}
 
 	/*
 	 *	Standard slow path.
@@ -5916,8 +5927,10 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 		return;
 
 step5:
-	if (tcp_ack(sk, skb, FLAG_SLOWPATH | FLAG_UPDATE_TS_RECENT) < 0)
-		goto discard;
+	if (tcp_ack(sk, skb, FLAG_SLOWPATH | FLAG_UPDATE_TS_RECENT) < 0) {
+		tcp_drop(sk, skb, LINUX_MIB_TCPSACKDISCARD, "TCP ack have not sent yet");
+		goto end;
+	}
 
 	tcp_rcv_rtt_measure_ts(sk, skb);
 
@@ -5935,9 +5948,10 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 	trace_tcp_bad_csum(skb);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_CSUMERRORS);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
+	tcp_drop(sk, skb, TCP_MIB_CSUMERRORS, "TCP csum error");
 
-discard:
-	tcp_drop(sk, skb);
+end:
+	return;
 }
 EXPORT_SYMBOL(tcp_rcv_established);
 
@@ -6137,7 +6151,8 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 
 		if (th->rst) {
 			tcp_reset(sk, skb);
-			goto discard;
+			tcp_drop(sk, skb, LINUX_MIB_NUM, "TCP reset");
+			goto end;
 		}
 
 		/* rfc793:
@@ -6226,9 +6241,9 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 			tcp_enter_quickack_mode(sk, TCP_MAX_QUICKACKS);
 			inet_csk_reset_xmit_timer(sk, ICSK_TIME_DACK,
 						  TCP_DELACK_MAX, TCP_RTO_MAX);
+			tcp_drop(sk, skb, LINUX_MIB_TCPFASTOPENACTIVE, "TCP fast open ack error");
 
-discard:
-			tcp_drop(sk, skb);
+end:
 			return 0;
 		} else {
 			tcp_send_ack(sk);
@@ -6301,7 +6316,8 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		 */
 		return -1;
 #else
-		goto discard;
+		tcp_drop(sk, skb, LINUX_MIB_SYNCOOKIESRECV, "TCP syn received error");
+		goto end;
 #endif
 	}
 	/* "fifth, if neither of the SYN or RST bits is set then
@@ -6311,7 +6327,8 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 discard_and_undo:
 	tcp_clear_options(&tp->rx_opt);
 	tp->rx_opt.mss_clamp = saved_clamp;
-	goto discard;
+	tcp_drop(sk, skb, LINUX_MIB_TCPSACKDISCARD, "TCP not neither of SYN or RST");
+	goto end;
 
 reset_and_undo:
 	tcp_clear_options(&tp->rx_opt);
@@ -6369,18 +6386,23 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 
 	switch (sk->sk_state) {
 	case TCP_CLOSE:
-		goto discard;
+		tcp_drop(sk, skb, LINUX_MIB_TCPABORTONCLOSE, "TCP close");
+		goto end;
 
 	case TCP_LISTEN:
 		if (th->ack)
 			return 1;
 
-		if (th->rst)
-			goto discard;
+		if (th->rst) {
+			tcp_drop(sk, skb, LINUX_MIB_LISTENDROPS, "TCP rst");
+			goto end;
+		}
 
 		if (th->syn) {
-			if (th->fin)
-				goto discard;
+			if (th->fin) {
+				tcp_drop(sk, skb, LINUX_MIB_LISTENDROPS, "TCP fin");
+				goto end;
+			}
 			/* It is possible that we process SYN packets from backlog,
 			 * so we need to make sure to disable BH and RCU right there.
 			 */
@@ -6395,7 +6417,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			consume_skb(skb);
 			return 0;
 		}
-		goto discard;
+		tcp_drop(sk, skb, LINUX_MIB_LISTENDROPS, "TCP syn");
+		goto end;
 
 	case TCP_SYN_SENT:
 		tp->rx_opt.saw_tstamp = 0;
@@ -6421,12 +6444,16 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		WARN_ON_ONCE(sk->sk_state != TCP_SYN_RECV &&
 		    sk->sk_state != TCP_FIN_WAIT1);
 
-		if (!tcp_check_req(sk, skb, req, true, &req_stolen))
-			goto discard;
+		if (!tcp_check_req(sk, skb, req, true, &req_stolen)) {
+			tcp_drop(sk, skb, LINUX_MIB_LISTENDROPS, "TCP check req error");
+			goto end;
+		}
 	}
 
-	if (!th->ack && !th->rst && !th->syn)
-		goto discard;
+	if (!th->ack && !th->rst && !th->syn) {
+		tcp_drop(sk, skb, LINUX_MIB_LISTENDROPS, "TCP not ack|rst|syn");
+		goto end;
+	}
 
 	if (!tcp_validate_incoming(sk, skb, th, 0))
 		return 0;
@@ -6440,7 +6467,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		if (sk->sk_state == TCP_SYN_RECV)
 			return 1;	/* send one RST */
 		tcp_send_challenge_ack(sk, skb);
-		goto discard;
+		tcp_drop(sk, skb, LINUX_MIB_TCPCHALLENGEACK, "TCP check ack failed");
+		goto end;
 	}
 	switch (sk->sk_state) {
 	case TCP_SYN_RECV:
@@ -6533,7 +6561,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			inet_csk_reset_keepalive_timer(sk, tmo);
 		} else {
 			tcp_time_wait(sk, TCP_FIN_WAIT2, tmo);
-			goto discard;
+			tcp_drop(sk, skb, LINUX_MIB_TCPABORTONDATA, "TCP fin wait2");
+			goto end;
 		}
 		break;
 	}
@@ -6541,7 +6570,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 	case TCP_CLOSING:
 		if (tp->snd_una == tp->write_seq) {
 			tcp_time_wait(sk, TCP_TIME_WAIT, 0);
-			goto discard;
+			tcp_drop(sk, skb, LINUX_MIB_TIMEWAITED, "TCP time wait");
+			goto end;
 		}
 		break;
 
@@ -6549,7 +6579,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		if (tp->snd_una == tp->write_seq) {
 			tcp_update_metrics(sk);
 			tcp_done(sk);
-			goto discard;
+			tcp_drop(sk, skb, LINUX_MIB_TCPPUREACKS, "TCP last ack");
+			goto end;
 		}
 		break;
 	}
@@ -6566,8 +6597,10 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			/* If a subflow has been reset, the packet should not
 			 * continue to be processed, drop the packet.
 			 */
-			if (sk_is_mptcp(sk) && !mptcp_incoming_options(sk, skb))
-				goto discard;
+			if (sk_is_mptcp(sk) && !mptcp_incoming_options(sk, skb)) {
+				tcp_drop(sk, skb, LINUX_MIB_TCPPUREACKS, "TCP subflow been reset");
+				goto end;
+			}
 			break;
 		}
 		fallthrough;
@@ -6599,9 +6632,10 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 	}
 
 	if (!queued) {
-discard:
-		tcp_drop(sk, skb);
+		tcp_drop(sk, skb, LINUX_MIB_TCPOFOQUEUE, "TCP rcv synsent state process");
 	}
+
+end:
 	return 0;
 }
 EXPORT_SYMBOL(tcp_rcv_state_process);
-- 
2.25.1

