Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF8E400A2E
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 09:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350841AbhIDGmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 02:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbhIDGmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Sep 2021 02:42:02 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE16C061575;
        Fri,  3 Sep 2021 23:41:01 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id u1so815887plq.5;
        Fri, 03 Sep 2021 23:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tl+ImmPjzuBFEoIZSG9CLVpXxsYLD8orIBBTyrlgIKk=;
        b=ewY2fWiuJCvHDfLaYczUDuM/xTjcx4hYkTflLpw5tFjTaI/r2uLq4W0c0z5Y6FXL2T
         ynolpdUGXzd/2yk/rOkrUWwkPdobsipGQbFfwDZ2XCcnuGPxNru16A1CdOk6BMj8a6Sn
         UL1yH58xxrgCuPWhNMWyffh8U+DH7gcHmnV4DYgvJv8bJkVEYrsXcI0Uk6yphoLu8CEv
         9fyJRfrMTqG/lgvU6RENGxQ/HiF1XevjdhFBm3HihZIHRqKU7uk1D9CBQqO+ZIXX9kuc
         or7/PfgXdSPrgb++w14vGSOr4yGETY+CUe+O9aB6lNVcaqop7cAnuPmLsuY5eCk8kAEY
         slgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tl+ImmPjzuBFEoIZSG9CLVpXxsYLD8orIBBTyrlgIKk=;
        b=QaR0hQrWvlw2onlCtDh1ANSKrQgO0mXnLDzsYvRlB+61V+iK//ULusU1nmPNwren2h
         Aju2Yv2qFENxkSKka6PtlN33kDVy01IkyUBQhCh9FdtxhuIWwMuhNKKT6M0TXIksyj91
         1EGAE2gHgTBSXk5jjtAtogzVTE0vQG1mfxWt1kr/DOihRsZzEvNYdQd3uRVqU0HhlBZg
         h7FpJT44I7IgZ3DoZK6kRLaPZDCLVzFE4yig509DxXY9zCWr+XBKl0N96w9xEiazZe5A
         ArivwMiw3BnmEGtMniGx36kGCUZ/spuTKSnqx7dUTQhQ/ofwbwW+jVvYs5OcrH0FQcw4
         F27A==
X-Gm-Message-State: AOAM533AeJVvj/mcGWSrMGiEQrBUXdmH04BpkC8Ztb/UXImOKyAB1TAf
        zuUW9P3uciMY9adhlUNWO6Y=
X-Google-Smtp-Source: ABdhPJwFMaEAbqxd8FHcyrMT6A8uoIozoBDcsh6hfoCxkNduzud5lIJy1CBu4+5KCXLxQ+ca3z/xeQ==
X-Received: by 2002:a17:903:41d0:b0:138:8d81:95d5 with SMTP id u16-20020a17090341d000b001388d8195d5mr2214780ple.67.1630737660472;
        Fri, 03 Sep 2021 23:41:00 -0700 (PDT)
Received: from localhost.localdomain ([223.106.51.51])
        by smtp.googlemail.com with ESMTPSA id q22sm1390407pgn.67.2021.09.03.23.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 23:41:00 -0700 (PDT)
From:   Zhongya Yan <yan2228598786@gmail.com>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        hengqi.chen@gmail.com, yhs@fb.com, brendan.d.gregg@gmail.com,
        2228598786@qq.com, Zhongya Yan <yan2228598786@gmail.com>
Subject: [PATCH] net: tcp_drop adds `reason` and SNMP parameters for tracing v4
Date:   Fri,  3 Sep 2021 23:40:44 -0700
Message-Id: <20210904064044.125549-1-yan2228598786@gmail.com>
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
index 3f7bd7ae7d7a..f16eeea9d00b 100644
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
+			tcp_drop(sk, skb, LINUX_MIB_TCPOFOQUEUE, "Tcp queue error");
 			continue;
 		}
 
@@ -4764,7 +4766,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 	if (unlikely(tcp_try_rmem_schedule(sk, skb, skb->truesize))) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFODROP);
 		sk->sk_data_ready(sk);
-		tcp_drop(sk, skb);
+		tcp_drop(sk, skb, LINUX_MIB_TCPOFODROP, "Tcp rmem failed");
 		return;
 	}
 
@@ -4827,7 +4829,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 				/* All the bits are present. Drop. */
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPOFOMERGE);
-				tcp_drop(sk, skb);
+				tcp_drop(sk, skb, LINUX_MIB_TCPOFOMERGE, "Tcp bits are present");
 				skb = NULL;
 				tcp_dsack_set(sk, seq, end_seq);
 				goto add_sack;
@@ -4846,7 +4848,9 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 						 TCP_SKB_CB(skb1)->end_seq);
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPOFOMERGE);
-				tcp_drop(sk, skb1);
+				tcp_drop(sk, skb1, LINUX_MIB_TCPOFOMERGE,
+						"Tcp replace(skb.seq eq skb1.seq)");
+
 				goto merge_right;
 			}
 		} else if (tcp_ooo_try_coalesce(sk, skb1,
@@ -4874,7 +4878,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 		tcp_dsack_extend(sk, TCP_SKB_CB(skb1)->seq,
 				 TCP_SKB_CB(skb1)->end_seq);
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFOMERGE);
-		tcp_drop(sk, skb1);
+		tcp_drop(sk, skb1, LINUX_MIB_TCPOFOMERGE, "Tcp useless other segments");
 	}
 	/* If there is no skb after us, we are the last_skb ! */
 	if (!skb1)
@@ -5010,7 +5014,8 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 		else if (tcp_try_rmem_schedule(sk, skb, skb->truesize)) {
 			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPRCVQDROP);
 			sk->sk_data_ready(sk);
-			goto drop;
+			tcp_drop(sk, skb, LINUX_MIB_TCPRCVQDROP, "Tcp rmem failed");
+			goto end;
 		}
 
 		eaten = tcp_queue_rcv(sk, skb, &fragstolen);
@@ -5050,8 +5055,8 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 out_of_window:
 		tcp_enter_quickack_mode(sk, TCP_MAX_QUICKACKS);
 		inet_csk_schedule_ack(sk);
-drop:
-		tcp_drop(sk, skb);
+		tcp_drop(sk, skb, LINUX_MIB_TCPZEROWINDOWDROP, "Tcp out of order or zero window");
+end:
 		return;
 	}
 
@@ -5308,7 +5313,7 @@ static bool tcp_prune_ofo_queue(struct sock *sk)
 		prev = rb_prev(node);
 		rb_erase(node, &tp->out_of_order_queue);
 		goal -= rb_to_skb(node)->truesize;
-		tcp_drop(sk, rb_to_skb(node));
+		tcp_drop(sk, rb_to_skb(node), LINUX_MIB_OFOPRUNED, "Tcp drop out-of-order queue");
 		if (!prev || goal <= 0) {
 			sk_mem_reclaim(sk);
 			if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf &&
@@ -5643,7 +5648,8 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 						  LINUX_MIB_TCPACKSKIPPEDPAWS,
 						  &tp->last_oow_ack_time))
 				tcp_send_dupack(sk, skb);
-			goto discard;
+			tcp_drop(sk, skb, LINUX_MIB_PAWSESTABREJECTED, "Tcp PAWS seq first");
+			goto end;
 		}
 		/* Reset is accepted even if it did not pass PAWS. */
 	}
@@ -5666,7 +5672,8 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 		} else if (tcp_reset_check(sk, skb)) {
 			tcp_reset(sk, skb);
 		}
-		goto discard;
+		tcp_drop(sk, skb, LINUX_MIB_PAWSESTABREJECTED, "Tcp check sequence number");
+		goto end;
 	}
 
 	/* Step 2: check RST bit */
@@ -5711,7 +5718,8 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 				tcp_fastopen_active_disable(sk);
 			tcp_send_challenge_ack(sk, skb);
 		}
-		goto discard;
+		tcp_drop(sk, skb, LINUX_MIB_TCPCHALLENGEACK, "Tcp check RST bit ");
+		goto end;
 	}
 
 	/* step 3: check security and precedence [ignored] */
@@ -5725,15 +5733,15 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 			TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNCHALLENGE);
 		tcp_send_challenge_ack(sk, skb);
-		goto discard;
+		tcp_drop(sk, skb, LINUX_MIB_TCPSYNCHALLENGE, "Tcp check for a SYN");
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
+				tcp_drop(sk, skb, TCP_MIB_INERRS, "Tcp header too small");
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
+		tcp_drop(sk, skb, LINUX_MIB_TCPSLOWSTARTRETRANS, "Tcp state not in ack|rst|syn");
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
+		tcp_drop(sk, skb, LINUX_MIB_TCPSACKDISCARD, "Tcp ack have not sent yet");
+		goto end;
+	}
 
 	tcp_rcv_rtt_measure_ts(sk, skb);
 
@@ -5935,9 +5948,10 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 	trace_tcp_bad_csum(skb);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_CSUMERRORS);
 	TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
+	tcp_drop(sk, skb, TCP_MIB_CSUMERRORS, "Tcp csum error");
 
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
+			tcp_drop(sk, skb, LINUX_MIB_NUM, "Tcp reset");
+			goto end;
 		}
 
 		/* rfc793:
@@ -6226,9 +6241,9 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 			tcp_enter_quickack_mode(sk, TCP_MAX_QUICKACKS);
 			inet_csk_reset_xmit_timer(sk, ICSK_TIME_DACK,
 						  TCP_DELACK_MAX, TCP_RTO_MAX);
+			tcp_drop(sk, skb, LINUX_MIB_TCPFASTOPENACTIVE, "Tcp fast open ack error");
 
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
+		tcp_drop(sk, skb, LINUX_MIB_SYNCOOKIESRECV, "Tcp syn received error");
+		goto end;
 #endif
 	}
 	/* "fifth, if neither of the SYN or RST bits is set then
@@ -6311,7 +6327,8 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 discard_and_undo:
 	tcp_clear_options(&tp->rx_opt);
 	tp->rx_opt.mss_clamp = saved_clamp;
-	goto discard;
+	tcp_drop(sk, skb, LINUX_MIB_TCPSACKDISCARD, "Tcp not neither of SYN or RST");
+	goto end;
 
 reset_and_undo:
 	tcp_clear_options(&tp->rx_opt);
@@ -6369,18 +6386,23 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 
 	switch (sk->sk_state) {
 	case TCP_CLOSE:
-		goto discard;
+		tcp_drop(sk, skb, LINUX_MIB_TCPABORTONCLOSE, "Tcp close");
+		goto end;
 
 	case TCP_LISTEN:
 		if (th->ack)
 			return 1;
 
-		if (th->rst)
-			goto discard;
+		if (th->rst) {
+			tcp_drop(sk, skb, LINUX_MIB_LISTENDROPS, "Tcp rst");
+			goto end;
+		}
 
 		if (th->syn) {
-			if (th->fin)
-				goto discard;
+			if (th->fin) {
+				tcp_drop(sk, skb, LINUX_MIB_LISTENDROPS, "Tcp fin");
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
+		tcp_drop(sk, skb, LINUX_MIB_LISTENDROPS, "Tcp syn");
+		goto end;
 
 	case TCP_SYN_SENT:
 		tp->rx_opt.saw_tstamp = 0;
@@ -6421,12 +6444,16 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		WARN_ON_ONCE(sk->sk_state != TCP_SYN_RECV &&
 		    sk->sk_state != TCP_FIN_WAIT1);
 
-		if (!tcp_check_req(sk, skb, req, true, &req_stolen))
-			goto discard;
+		if (!tcp_check_req(sk, skb, req, true, &req_stolen)) {
+			tcp_drop(sk, skb, LINUX_MIB_LISTENDROPS, "Tcp check req error");
+			goto end;
+		}
 	}
 
-	if (!th->ack && !th->rst && !th->syn)
-		goto discard;
+	if (!th->ack && !th->rst && !th->syn) {
+		tcp_drop(sk, skb, LINUX_MIB_LISTENDROPS, "Tcp not ack|rst|syn");
+		goto end;
+	}
 
 	if (!tcp_validate_incoming(sk, skb, th, 0))
 		return 0;
@@ -6440,7 +6467,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		if (sk->sk_state == TCP_SYN_RECV)
 			return 1;	/* send one RST */
 		tcp_send_challenge_ack(sk, skb);
-		goto discard;
+		tcp_drop(sk, skb, LINUX_MIB_TCPCHALLENGEACK, "Tcp check ack failed");
+		goto end;
 	}
 	switch (sk->sk_state) {
 	case TCP_SYN_RECV:
@@ -6533,7 +6561,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			inet_csk_reset_keepalive_timer(sk, tmo);
 		} else {
 			tcp_time_wait(sk, TCP_FIN_WAIT2, tmo);
-			goto discard;
+			tcp_drop(sk, skb, LINUX_MIB_TCPABORTONDATA, "Tcp fin wait2");
+			goto end;
 		}
 		break;
 	}
@@ -6541,7 +6570,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 	case TCP_CLOSING:
 		if (tp->snd_una == tp->write_seq) {
 			tcp_time_wait(sk, TCP_TIME_WAIT, 0);
-			goto discard;
+			tcp_drop(sk, skb, LINUX_MIB_TIMEWAITED, "Tcp time wait");
+			goto end;
 		}
 		break;
 
@@ -6549,7 +6579,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		if (tp->snd_una == tp->write_seq) {
 			tcp_update_metrics(sk);
 			tcp_done(sk);
-			goto discard;
+			tcp_drop(sk, skb, LINUX_MIB_TCPPUREACKS, "Tcp last ack");
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
+				tcp_drop(sk, skb, LINUX_MIB_TCPPUREACKS, "Tcp subflow been reset");
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
+		tcp_drop(sk, skb, LINUX_MIB_TCPOFOQUEUE, "Tcp rcv synsent state process");
 	}
+
+end:
 	return 0;
 }
 EXPORT_SYMBOL(tcp_rcv_state_process);
-- 
2.25.1

