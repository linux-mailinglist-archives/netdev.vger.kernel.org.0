Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDAF84F53C3
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343966AbiDFEVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1847245AbiDFCQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 22:16:54 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A0B25F644
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 16:35:45 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y10so891270pfa.7
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 16:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bKwct5kMbjjkjARg3Fiul0clX+2UBqG+OZGZAV9g6VA=;
        b=TGxb37idrva//6JzMsdF9hsUXM0sWc/KEXOKJdhfCqKXUaz92nCYhV2BvLgfr1e3DQ
         56jvehlRhR25fwlgO/N1GLByWtGdxA31hsLMhErCLHCAEMoY1rgk2QwpZPWBwZDDMG8P
         DEH/WMm399KWBv5eoANyk46rMDsDv0amtsE+3ZmPM7rF2G09GtIHC0u7qzQpCjlxCoOh
         hHTpBXhojQqmZnQraz8fZnat9JEAIsNO0Zk8OZibuxSuOwjlzDeCSw245PC43dgkxudR
         pSI3sozvhOl2McowWYBa6Brhm/nXnW5x4LS5H3CvIMoKtCRSZ00SZemZs+tW8LV23O6S
         htsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bKwct5kMbjjkjARg3Fiul0clX+2UBqG+OZGZAV9g6VA=;
        b=hEUOVPa6Q5P45HV60I46FE9//hTSuOTLnkPHykNpF2xa0CIVcLhZBGSFnmEKHst70I
         nOHeec0AtNJXZ51VORCdvpJO4tdZCTpHH1XB7AwpYyU1KmHrWZWuNSd/wGHy0kR9fjAi
         veho4GaZQtyCLHKrNmubwc8K0lzbqYghyZM8tcjfXI5iJMq9wN6HTBligLG+P8zHRem/
         kJ/BDTukJge7i+yD1axzDbZVsfKZZaZhVG54INbdmqex04hQFqEP+uoIjxR0SUwHoFk2
         8SgL1pIVC0/QpWkPMT4j5Q3tbWqruQBwGmU02fgh/yO+PJ+EnzeCxTpV/6GAOh5vYh3m
         2UIA==
X-Gm-Message-State: AOAM532VsInjHnejY0Yf8ul6G84e0qUk06hJqAGrvaVrrckRM8c3Prb4
        O4h4IxIqHmn88jGHlC7xQPs=
X-Google-Smtp-Source: ABdhPJw492A2HbpzQTFtJ9oRWPdZS3u0MK0+oVew/frs+pZ/lqk89mVthWCMlvMC6E1e5bh6Va3bRw==
X-Received: by 2002:a63:f047:0:b0:399:24bb:7fa1 with SMTP id s7-20020a63f047000000b0039924bb7fa1mr4696437pgj.397.1649201744355;
        Tue, 05 Apr 2022 16:35:44 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e8eb:193c:560a:1080])
        by smtp.gmail.com with ESMTPSA id k3-20020a056a00168300b004f7e60da26csm17155934pfc.182.2022.04.05.16.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 16:35:43 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH net-next] tcp: add accessors to read/set tp->snd_cwnd
Date:   Tue,  5 Apr 2022 16:35:38 -0700
Message-Id: <20220405233538.947344-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We had various bugs over the years with code
breaking the assumption that tp->snd_cwnd is greater
than zero.

Lately, syzbot reported the WARN_ON_ONCE(!tp->prior_cwnd) added
in commit 8b8a321ff72c ("tcp: fix zero cwnd in tcp_cwnd_reduction")
can trigger, and without a repro we would have to spend
considerable time finding the bug.

Instead of complaining too late, we want to catch where
and when tp->snd_cwnd is set to an illegal value.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Suggested-by: Yuchung Cheng <ycheng@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
---
 include/net/tcp.h          | 19 +++++++++++++++----
 include/trace/events/tcp.h |  2 +-
 net/core/filter.c          |  2 +-
 net/ipv4/tcp.c             |  8 ++++----
 net/ipv4/tcp_bbr.c         | 20 ++++++++++----------
 net/ipv4/tcp_bic.c         | 14 +++++++-------
 net/ipv4/tcp_cdg.c         | 30 +++++++++++++++---------------
 net/ipv4/tcp_cong.c        | 18 +++++++++---------
 net/ipv4/tcp_cubic.c       | 22 +++++++++++-----------
 net/ipv4/tcp_dctcp.c       | 11 ++++++-----
 net/ipv4/tcp_highspeed.c   | 18 +++++++++---------
 net/ipv4/tcp_htcp.c        | 10 +++++-----
 net/ipv4/tcp_hybla.c       | 18 +++++++++---------
 net/ipv4/tcp_illinois.c    | 12 +++++++-----
 net/ipv4/tcp_input.c       | 36 ++++++++++++++++++------------------
 net/ipv4/tcp_ipv4.c        |  2 +-
 net/ipv4/tcp_lp.c          |  6 +++---
 net/ipv4/tcp_metrics.c     | 12 ++++++------
 net/ipv4/tcp_nv.c          | 24 ++++++++++++------------
 net/ipv4/tcp_output.c      | 30 +++++++++++++++---------------
 net/ipv4/tcp_rate.c        |  2 +-
 net/ipv4/tcp_scalable.c    |  4 ++--
 net/ipv4/tcp_vegas.c       | 21 +++++++++++----------
 net/ipv4/tcp_veno.c        | 24 ++++++++++++------------
 net/ipv4/tcp_westwood.c    |  3 ++-
 net/ipv4/tcp_yeah.c        | 30 +++++++++++++++---------------
 net/ipv6/tcp_ipv6.c        |  2 +-
 27 files changed, 208 insertions(+), 192 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 70ca4a5e330a2002acffd7ddd4f685a758c7fbc4..54aa2f02bb6300b39e889469aa5504d886785ef6 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1207,9 +1207,20 @@ static inline unsigned int tcp_packets_in_flight(const struct tcp_sock *tp)
 
 #define TCP_INFINITE_SSTHRESH	0x7fffffff
 
+static inline u32 tcp_snd_cwnd(const struct tcp_sock *tp)
+{
+	return tp->snd_cwnd;
+}
+
+static inline void tcp_snd_cwnd_set(struct tcp_sock *tp, u32 val)
+{
+	WARN_ON_ONCE((int)val <= 0);
+	tp->snd_cwnd = val;
+}
+
 static inline bool tcp_in_slow_start(const struct tcp_sock *tp)
 {
-	return tp->snd_cwnd < tp->snd_ssthresh;
+	return tcp_snd_cwnd(tp) < tp->snd_ssthresh;
 }
 
 static inline bool tcp_in_initial_slowstart(const struct tcp_sock *tp)
@@ -1235,8 +1246,8 @@ static inline __u32 tcp_current_ssthresh(const struct sock *sk)
 		return tp->snd_ssthresh;
 	else
 		return max(tp->snd_ssthresh,
-			   ((tp->snd_cwnd >> 1) +
-			    (tp->snd_cwnd >> 2)));
+			   ((tcp_snd_cwnd(tp) >> 1) +
+			    (tcp_snd_cwnd(tp) >> 2)));
 }
 
 /* Use define here intentionally to get WARN_ON location shown at the caller */
@@ -1278,7 +1289,7 @@ static inline bool tcp_is_cwnd_limited(const struct sock *sk)
 
 	/* If in slow start, ensure cwnd grows to twice what was ACKed. */
 	if (tcp_in_slow_start(tp))
-		return tp->snd_cwnd < 2 * tp->max_packets_out;
+		return tcp_snd_cwnd(tp) < 2 * tp->max_packets_out;
 
 	return tp->is_cwnd_limited;
 }
diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
index 521059d8dc0a67087527e8a9aa2338e81d86bd37..edcd6369de1029f307dd0fec09e35e9f5723d190 100644
--- a/include/trace/events/tcp.h
+++ b/include/trace/events/tcp.h
@@ -279,7 +279,7 @@ TRACE_EVENT(tcp_probe,
 		__entry->data_len = skb->len - __tcp_hdrlen(th);
 		__entry->snd_nxt = tp->snd_nxt;
 		__entry->snd_una = tp->snd_una;
-		__entry->snd_cwnd = tp->snd_cwnd;
+		__entry->snd_cwnd = tcp_snd_cwnd(tp);
 		__entry->snd_wnd = tp->snd_wnd;
 		__entry->rcv_wnd = tp->rcv_wnd;
 		__entry->ssthresh = tcp_current_ssthresh(sk);
diff --git a/net/core/filter.c b/net/core/filter.c
index a7044e98765ec5e5b55724527aa61068ccaec20a..29986eda285d06b2ebd344b325a9b6f0de17507a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5173,7 +5173,7 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 				if (val <= 0 || tp->data_segs_out > tp->syn_data)
 					ret = -EINVAL;
 				else
-					tp->snd_cwnd = val;
+					tcp_snd_cwnd_set(tp, val);
 				break;
 			case TCP_BPF_SNDCWND_CLAMP:
 				if (val <= 0) {
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index cf18fbcbf123a864608a9603bfe215def9e4b70e..e31cf137c6140f76f838b4a0dcddf9f104ad653b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -429,7 +429,7 @@ void tcp_init_sock(struct sock *sk)
 	 * algorithms that we must have the following bandaid to talk
 	 * efficiently to them.  -DaveM
 	 */
-	tp->snd_cwnd = TCP_INIT_CWND;
+	tcp_snd_cwnd_set(tp, TCP_INIT_CWND);
 
 	/* There's a bubble in the pipe until at least the first ACK. */
 	tp->app_limited = ~0U;
@@ -3033,7 +3033,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	icsk->icsk_rto_min = TCP_RTO_MIN;
 	icsk->icsk_delack_max = TCP_DELACK_MAX;
 	tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
-	tp->snd_cwnd = TCP_INIT_CWND;
+	tcp_snd_cwnd_set(tp, TCP_INIT_CWND);
 	tp->snd_cwnd_cnt = 0;
 	tp->window_clamp = 0;
 	tp->delivered = 0;
@@ -3744,7 +3744,7 @@ void tcp_get_info(struct sock *sk, struct tcp_info *info)
 	info->tcpi_max_pacing_rate = rate64;
 
 	info->tcpi_reordering = tp->reordering;
-	info->tcpi_snd_cwnd = tp->snd_cwnd;
+	info->tcpi_snd_cwnd = tcp_snd_cwnd(tp);
 
 	if (info->tcpi_state == TCP_LISTEN) {
 		/* listeners aliased fields :
@@ -3915,7 +3915,7 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 	rate64 = tcp_compute_delivery_rate(tp);
 	nla_put_u64_64bit(stats, TCP_NLA_DELIVERY_RATE, rate64, TCP_NLA_PAD);
 
-	nla_put_u32(stats, TCP_NLA_SND_CWND, tp->snd_cwnd);
+	nla_put_u32(stats, TCP_NLA_SND_CWND, tcp_snd_cwnd(tp));
 	nla_put_u32(stats, TCP_NLA_REORDERING, tp->reordering);
 	nla_put_u32(stats, TCP_NLA_MIN_RTT, tcp_min_rtt(tp));
 
diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index 02e8626ccb278705b8c611332e47fe5b7c732cf5..c7d30a3bbd81d27e16e800ec446569b93a4123ba 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -276,7 +276,7 @@ static void bbr_init_pacing_rate_from_rtt(struct sock *sk)
 	} else {			 /* no RTT sample yet */
 		rtt_us = USEC_PER_MSEC;	 /* use nominal default RTT */
 	}
-	bw = (u64)tp->snd_cwnd * BW_UNIT;
+	bw = (u64)tcp_snd_cwnd(tp) * BW_UNIT;
 	do_div(bw, rtt_us);
 	sk->sk_pacing_rate = bbr_bw_to_pacing_rate(sk, bw, bbr_high_gain);
 }
@@ -323,9 +323,9 @@ static void bbr_save_cwnd(struct sock *sk)
 	struct bbr *bbr = inet_csk_ca(sk);
 
 	if (bbr->prev_ca_state < TCP_CA_Recovery && bbr->mode != BBR_PROBE_RTT)
-		bbr->prior_cwnd = tp->snd_cwnd;  /* this cwnd is good enough */
+		bbr->prior_cwnd = tcp_snd_cwnd(tp);  /* this cwnd is good enough */
 	else  /* loss recovery or BBR_PROBE_RTT have temporarily cut cwnd */
-		bbr->prior_cwnd = max(bbr->prior_cwnd, tp->snd_cwnd);
+		bbr->prior_cwnd = max(bbr->prior_cwnd, tcp_snd_cwnd(tp));
 }
 
 static void bbr_cwnd_event(struct sock *sk, enum tcp_ca_event event)
@@ -482,7 +482,7 @@ static bool bbr_set_cwnd_to_recover_or_restore(
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct bbr *bbr = inet_csk_ca(sk);
 	u8 prev_state = bbr->prev_ca_state, state = inet_csk(sk)->icsk_ca_state;
-	u32 cwnd = tp->snd_cwnd;
+	u32 cwnd = tcp_snd_cwnd(tp);
 
 	/* An ACK for P pkts should release at most 2*P packets. We do this
 	 * in two steps. First, here we deduct the number of lost packets.
@@ -520,7 +520,7 @@ static void bbr_set_cwnd(struct sock *sk, const struct rate_sample *rs,
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct bbr *bbr = inet_csk_ca(sk);
-	u32 cwnd = tp->snd_cwnd, target_cwnd = 0;
+	u32 cwnd = tcp_snd_cwnd(tp), target_cwnd = 0;
 
 	if (!acked)
 		goto done;  /* no packet fully ACKed; just apply caps */
@@ -544,9 +544,9 @@ static void bbr_set_cwnd(struct sock *sk, const struct rate_sample *rs,
 	cwnd = max(cwnd, bbr_cwnd_min_target);
 
 done:
-	tp->snd_cwnd = min(cwnd, tp->snd_cwnd_clamp);	/* apply global cap */
+	tcp_snd_cwnd_set(tp, min(cwnd, tp->snd_cwnd_clamp));	/* apply global cap */
 	if (bbr->mode == BBR_PROBE_RTT)  /* drain queue, refresh min_rtt */
-		tp->snd_cwnd = min(tp->snd_cwnd, bbr_cwnd_min_target);
+		tcp_snd_cwnd_set(tp, min(tcp_snd_cwnd(tp), bbr_cwnd_min_target));
 }
 
 /* End cycle phase if it's time and/or we hit the phase's in-flight target. */
@@ -856,7 +856,7 @@ static void bbr_update_ack_aggregation(struct sock *sk,
 	bbr->ack_epoch_acked = min_t(u32, 0xFFFFF,
 				     bbr->ack_epoch_acked + rs->acked_sacked);
 	extra_acked = bbr->ack_epoch_acked - expected_acked;
-	extra_acked = min(extra_acked, tp->snd_cwnd);
+	extra_acked = min(extra_acked, tcp_snd_cwnd(tp));
 	if (extra_acked > bbr->extra_acked[bbr->extra_acked_win_idx])
 		bbr->extra_acked[bbr->extra_acked_win_idx] = extra_acked;
 }
@@ -914,7 +914,7 @@ static void bbr_check_probe_rtt_done(struct sock *sk)
 		return;
 
 	bbr->min_rtt_stamp = tcp_jiffies32;  /* wait a while until PROBE_RTT */
-	tp->snd_cwnd = max(tp->snd_cwnd, bbr->prior_cwnd);
+	tcp_snd_cwnd_set(tp, max(tcp_snd_cwnd(tp), bbr->prior_cwnd));
 	bbr_reset_mode(sk);
 }
 
@@ -1093,7 +1093,7 @@ static u32 bbr_undo_cwnd(struct sock *sk)
 	bbr->full_bw = 0;   /* spurious slow-down; reset full pipe detection */
 	bbr->full_bw_cnt = 0;
 	bbr_reset_lt_bw_sampling(sk);
-	return tcp_sk(sk)->snd_cwnd;
+	return tcp_snd_cwnd(tcp_sk(sk));
 }
 
 /* Entering loss recovery, so save cwnd for when we exit or undo recovery. */
diff --git a/net/ipv4/tcp_bic.c b/net/ipv4/tcp_bic.c
index f5f588b1f6e9dcf2b37c465d46518af0b673af55..58358bf92e1b8ac43c07789dac9f6031fa2e03dd 100644
--- a/net/ipv4/tcp_bic.c
+++ b/net/ipv4/tcp_bic.c
@@ -150,7 +150,7 @@ static void bictcp_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 		if (!acked)
 			return;
 	}
-	bictcp_update(ca, tp->snd_cwnd);
+	bictcp_update(ca, tcp_snd_cwnd(tp));
 	tcp_cong_avoid_ai(tp, ca->cnt, acked);
 }
 
@@ -166,16 +166,16 @@ static u32 bictcp_recalc_ssthresh(struct sock *sk)
 	ca->epoch_start = 0;	/* end of epoch */
 
 	/* Wmax and fast convergence */
-	if (tp->snd_cwnd < ca->last_max_cwnd && fast_convergence)
-		ca->last_max_cwnd = (tp->snd_cwnd * (BICTCP_BETA_SCALE + beta))
+	if (tcp_snd_cwnd(tp) < ca->last_max_cwnd && fast_convergence)
+		ca->last_max_cwnd = (tcp_snd_cwnd(tp) * (BICTCP_BETA_SCALE + beta))
 			/ (2 * BICTCP_BETA_SCALE);
 	else
-		ca->last_max_cwnd = tp->snd_cwnd;
+		ca->last_max_cwnd = tcp_snd_cwnd(tp);
 
-	if (tp->snd_cwnd <= low_window)
-		return max(tp->snd_cwnd >> 1U, 2U);
+	if (tcp_snd_cwnd(tp) <= low_window)
+		return max(tcp_snd_cwnd(tp) >> 1U, 2U);
 	else
-		return max((tp->snd_cwnd * beta) / BICTCP_BETA_SCALE, 2U);
+		return max((tcp_snd_cwnd(tp) * beta) / BICTCP_BETA_SCALE, 2U);
 }
 
 static void bictcp_state(struct sock *sk, u8 new_state)
diff --git a/net/ipv4/tcp_cdg.c b/net/ipv4/tcp_cdg.c
index 709d23801823935b4eb2d3121b6e7ca1bdb08972..ddc7ba0554bddaa5df2fffdb61faba1f3cfbde5c 100644
--- a/net/ipv4/tcp_cdg.c
+++ b/net/ipv4/tcp_cdg.c
@@ -161,8 +161,8 @@ static void tcp_cdg_hystart_update(struct sock *sk)
 					      LINUX_MIB_TCPHYSTARTTRAINDETECT);
 				NET_ADD_STATS(sock_net(sk),
 					      LINUX_MIB_TCPHYSTARTTRAINCWND,
-					      tp->snd_cwnd);
-				tp->snd_ssthresh = tp->snd_cwnd;
+					      tcp_snd_cwnd(tp));
+				tp->snd_ssthresh = tcp_snd_cwnd(tp);
 				return;
 			}
 		}
@@ -180,8 +180,8 @@ static void tcp_cdg_hystart_update(struct sock *sk)
 					      LINUX_MIB_TCPHYSTARTDELAYDETECT);
 				NET_ADD_STATS(sock_net(sk),
 					      LINUX_MIB_TCPHYSTARTDELAYCWND,
-					      tp->snd_cwnd);
-				tp->snd_ssthresh = tp->snd_cwnd;
+					      tcp_snd_cwnd(tp));
+				tp->snd_ssthresh = tcp_snd_cwnd(tp);
 			}
 		}
 	}
@@ -252,7 +252,7 @@ static bool tcp_cdg_backoff(struct sock *sk, u32 grad)
 			return false;
 	}
 
-	ca->shadow_wnd = max(ca->shadow_wnd, tp->snd_cwnd);
+	ca->shadow_wnd = max(ca->shadow_wnd, tcp_snd_cwnd(tp));
 	ca->state = CDG_BACKOFF;
 	tcp_enter_cwr(sk);
 	return true;
@@ -285,14 +285,14 @@ static void tcp_cdg_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 	}
 
 	if (!tcp_is_cwnd_limited(sk)) {
-		ca->shadow_wnd = min(ca->shadow_wnd, tp->snd_cwnd);
+		ca->shadow_wnd = min(ca->shadow_wnd, tcp_snd_cwnd(tp));
 		return;
 	}
 
-	prior_snd_cwnd = tp->snd_cwnd;
+	prior_snd_cwnd = tcp_snd_cwnd(tp);
 	tcp_reno_cong_avoid(sk, ack, acked);
 
-	incr = tp->snd_cwnd - prior_snd_cwnd;
+	incr = tcp_snd_cwnd(tp) - prior_snd_cwnd;
 	ca->shadow_wnd = max(ca->shadow_wnd, ca->shadow_wnd + incr);
 }
 
@@ -331,15 +331,15 @@ static u32 tcp_cdg_ssthresh(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	if (ca->state == CDG_BACKOFF)
-		return max(2U, (tp->snd_cwnd * min(1024U, backoff_beta)) >> 10);
+		return max(2U, (tcp_snd_cwnd(tp) * min(1024U, backoff_beta)) >> 10);
 
 	if (ca->state == CDG_NONFULL && use_tolerance)
-		return tp->snd_cwnd;
+		return tcp_snd_cwnd(tp);
 
-	ca->shadow_wnd = min(ca->shadow_wnd >> 1, tp->snd_cwnd);
+	ca->shadow_wnd = min(ca->shadow_wnd >> 1, tcp_snd_cwnd(tp));
 	if (use_shadow)
-		return max3(2U, ca->shadow_wnd, tp->snd_cwnd >> 1);
-	return max(2U, tp->snd_cwnd >> 1);
+		return max3(2U, ca->shadow_wnd, tcp_snd_cwnd(tp) >> 1);
+	return max(2U, tcp_snd_cwnd(tp) >> 1);
 }
 
 static void tcp_cdg_cwnd_event(struct sock *sk, const enum tcp_ca_event ev)
@@ -357,7 +357,7 @@ static void tcp_cdg_cwnd_event(struct sock *sk, const enum tcp_ca_event ev)
 
 		ca->gradients = gradients;
 		ca->rtt_seq = tp->snd_nxt;
-		ca->shadow_wnd = tp->snd_cwnd;
+		ca->shadow_wnd = tcp_snd_cwnd(tp);
 		break;
 	case CA_EVENT_COMPLETE_CWR:
 		ca->state = CDG_UNKNOWN;
@@ -380,7 +380,7 @@ static void tcp_cdg_init(struct sock *sk)
 		ca->gradients = kcalloc(window, sizeof(ca->gradients[0]),
 					GFP_NOWAIT | __GFP_NOWARN);
 	ca->rtt_seq = tp->snd_nxt;
-	ca->shadow_wnd = tp->snd_cwnd;
+	ca->shadow_wnd = tcp_snd_cwnd(tp);
 }
 
 static void tcp_cdg_release(struct sock *sk)
diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index dc95572163df322c97bd7181c420c1ceb6355eec..d854bcfb990607d88e241bfaab8192119e4488f2 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -393,10 +393,10 @@ int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
  */
 u32 tcp_slow_start(struct tcp_sock *tp, u32 acked)
 {
-	u32 cwnd = min(tp->snd_cwnd + acked, tp->snd_ssthresh);
+	u32 cwnd = min(tcp_snd_cwnd(tp) + acked, tp->snd_ssthresh);
 
-	acked -= cwnd - tp->snd_cwnd;
-	tp->snd_cwnd = min(cwnd, tp->snd_cwnd_clamp);
+	acked -= cwnd - tcp_snd_cwnd(tp);
+	tcp_snd_cwnd_set(tp, min(cwnd, tp->snd_cwnd_clamp));
 
 	return acked;
 }
@@ -410,7 +410,7 @@ void tcp_cong_avoid_ai(struct tcp_sock *tp, u32 w, u32 acked)
 	/* If credits accumulated at a higher w, apply them gently now. */
 	if (tp->snd_cwnd_cnt >= w) {
 		tp->snd_cwnd_cnt = 0;
-		tp->snd_cwnd++;
+		tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) + 1);
 	}
 
 	tp->snd_cwnd_cnt += acked;
@@ -418,9 +418,9 @@ void tcp_cong_avoid_ai(struct tcp_sock *tp, u32 w, u32 acked)
 		u32 delta = tp->snd_cwnd_cnt / w;
 
 		tp->snd_cwnd_cnt -= delta * w;
-		tp->snd_cwnd += delta;
+		tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) + delta);
 	}
-	tp->snd_cwnd = min(tp->snd_cwnd, tp->snd_cwnd_clamp);
+	tcp_snd_cwnd_set(tp, min(tcp_snd_cwnd(tp), tp->snd_cwnd_clamp));
 }
 EXPORT_SYMBOL_GPL(tcp_cong_avoid_ai);
 
@@ -445,7 +445,7 @@ void tcp_reno_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 			return;
 	}
 	/* In dangerous area, increase slowly. */
-	tcp_cong_avoid_ai(tp, tp->snd_cwnd, acked);
+	tcp_cong_avoid_ai(tp, tcp_snd_cwnd(tp), acked);
 }
 EXPORT_SYMBOL_GPL(tcp_reno_cong_avoid);
 
@@ -454,7 +454,7 @@ u32 tcp_reno_ssthresh(struct sock *sk)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 
-	return max(tp->snd_cwnd >> 1U, 2U);
+	return max(tcp_snd_cwnd(tp) >> 1U, 2U);
 }
 EXPORT_SYMBOL_GPL(tcp_reno_ssthresh);
 
@@ -462,7 +462,7 @@ u32 tcp_reno_undo_cwnd(struct sock *sk)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 
-	return max(tp->snd_cwnd, tp->prior_cwnd);
+	return max(tcp_snd_cwnd(tp), tp->prior_cwnd);
 }
 EXPORT_SYMBOL_GPL(tcp_reno_undo_cwnd);
 
diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 24d562dd62254d6e50dd08236f8967400d81e1ea..b0918839bee7cf0264ec3bbcdfc1417daa86d197 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -334,7 +334,7 @@ static void cubictcp_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 		if (!acked)
 			return;
 	}
-	bictcp_update(ca, tp->snd_cwnd, acked);
+	bictcp_update(ca, tcp_snd_cwnd(tp), acked);
 	tcp_cong_avoid_ai(tp, ca->cnt, acked);
 }
 
@@ -346,13 +346,13 @@ static u32 cubictcp_recalc_ssthresh(struct sock *sk)
 	ca->epoch_start = 0;	/* end of epoch */
 
 	/* Wmax and fast convergence */
-	if (tp->snd_cwnd < ca->last_max_cwnd && fast_convergence)
-		ca->last_max_cwnd = (tp->snd_cwnd * (BICTCP_BETA_SCALE + beta))
+	if (tcp_snd_cwnd(tp) < ca->last_max_cwnd && fast_convergence)
+		ca->last_max_cwnd = (tcp_snd_cwnd(tp) * (BICTCP_BETA_SCALE + beta))
 			/ (2 * BICTCP_BETA_SCALE);
 	else
-		ca->last_max_cwnd = tp->snd_cwnd;
+		ca->last_max_cwnd = tcp_snd_cwnd(tp);
 
-	return max((tp->snd_cwnd * beta) / BICTCP_BETA_SCALE, 2U);
+	return max((tcp_snd_cwnd(tp) * beta) / BICTCP_BETA_SCALE, 2U);
 }
 
 static void cubictcp_state(struct sock *sk, u8 new_state)
@@ -413,13 +413,13 @@ static void hystart_update(struct sock *sk, u32 delay)
 				ca->found = 1;
 				pr_debug("hystart_ack_train (%u > %u) delay_min %u (+ ack_delay %u) cwnd %u\n",
 					 now - ca->round_start, threshold,
-					 ca->delay_min, hystart_ack_delay(sk), tp->snd_cwnd);
+					 ca->delay_min, hystart_ack_delay(sk), tcp_snd_cwnd(tp));
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPHYSTARTTRAINDETECT);
 				NET_ADD_STATS(sock_net(sk),
 					      LINUX_MIB_TCPHYSTARTTRAINCWND,
-					      tp->snd_cwnd);
-				tp->snd_ssthresh = tp->snd_cwnd;
+					      tcp_snd_cwnd(tp));
+				tp->snd_ssthresh = tcp_snd_cwnd(tp);
 			}
 		}
 	}
@@ -438,8 +438,8 @@ static void hystart_update(struct sock *sk, u32 delay)
 					      LINUX_MIB_TCPHYSTARTDELAYDETECT);
 				NET_ADD_STATS(sock_net(sk),
 					      LINUX_MIB_TCPHYSTARTDELAYCWND,
-					      tp->snd_cwnd);
-				tp->snd_ssthresh = tp->snd_cwnd;
+					      tcp_snd_cwnd(tp));
+				tp->snd_ssthresh = tcp_snd_cwnd(tp);
 			}
 		}
 	}
@@ -469,7 +469,7 @@ static void cubictcp_acked(struct sock *sk, const struct ack_sample *sample)
 
 	/* hystart triggers when cwnd is larger than some threshold */
 	if (!ca->found && tcp_in_slow_start(tp) && hystart &&
-	    tp->snd_cwnd >= hystart_low_window)
+	    tcp_snd_cwnd(tp) >= hystart_low_window)
 		hystart_update(sk, delay);
 }
 
diff --git a/net/ipv4/tcp_dctcp.c b/net/ipv4/tcp_dctcp.c
index 1943a6630341c67f98a43dc1052321fe9edebfaa..ab034a4e9324a1116c40185811e7597ff8dea06d 100644
--- a/net/ipv4/tcp_dctcp.c
+++ b/net/ipv4/tcp_dctcp.c
@@ -106,8 +106,8 @@ static u32 dctcp_ssthresh(struct sock *sk)
 	struct dctcp *ca = inet_csk_ca(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	ca->loss_cwnd = tp->snd_cwnd;
-	return max(tp->snd_cwnd - ((tp->snd_cwnd * ca->dctcp_alpha) >> 11U), 2U);
+	ca->loss_cwnd = tcp_snd_cwnd(tp);
+	return max(tcp_snd_cwnd(tp) - ((tcp_snd_cwnd(tp) * ca->dctcp_alpha) >> 11U), 2U);
 }
 
 static void dctcp_update_alpha(struct sock *sk, u32 flags)
@@ -148,8 +148,8 @@ static void dctcp_react_to_loss(struct sock *sk)
 	struct dctcp *ca = inet_csk_ca(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	ca->loss_cwnd = tp->snd_cwnd;
-	tp->snd_ssthresh = max(tp->snd_cwnd >> 1U, 2U);
+	ca->loss_cwnd = tcp_snd_cwnd(tp);
+	tp->snd_ssthresh = max(tcp_snd_cwnd(tp) >> 1U, 2U);
 }
 
 static void dctcp_state(struct sock *sk, u8 new_state)
@@ -211,8 +211,9 @@ static size_t dctcp_get_info(struct sock *sk, u32 ext, int *attr,
 static u32 dctcp_cwnd_undo(struct sock *sk)
 {
 	const struct dctcp *ca = inet_csk_ca(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
 
-	return max(tcp_sk(sk)->snd_cwnd, ca->loss_cwnd);
+	return max(tcp_snd_cwnd(tp), ca->loss_cwnd);
 }
 
 static struct tcp_congestion_ops dctcp __read_mostly = {
diff --git a/net/ipv4/tcp_highspeed.c b/net/ipv4/tcp_highspeed.c
index 349069d6cd0aabbdb1e4c10c95ec0cf887b7b56b..c6de5ce79ad3c582618f3ea62310bfb257b1350f 100644
--- a/net/ipv4/tcp_highspeed.c
+++ b/net/ipv4/tcp_highspeed.c
@@ -127,22 +127,22 @@ static void hstcp_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 		 *     snd_cwnd <=
 		 *     hstcp_aimd_vals[ca->ai].cwnd
 		 */
-		if (tp->snd_cwnd > hstcp_aimd_vals[ca->ai].cwnd) {
-			while (tp->snd_cwnd > hstcp_aimd_vals[ca->ai].cwnd &&
+		if (tcp_snd_cwnd(tp) > hstcp_aimd_vals[ca->ai].cwnd) {
+			while (tcp_snd_cwnd(tp) > hstcp_aimd_vals[ca->ai].cwnd &&
 			       ca->ai < HSTCP_AIMD_MAX - 1)
 				ca->ai++;
-		} else if (ca->ai && tp->snd_cwnd <= hstcp_aimd_vals[ca->ai-1].cwnd) {
-			while (ca->ai && tp->snd_cwnd <= hstcp_aimd_vals[ca->ai-1].cwnd)
+		} else if (ca->ai && tcp_snd_cwnd(tp) <= hstcp_aimd_vals[ca->ai-1].cwnd) {
+			while (ca->ai && tcp_snd_cwnd(tp) <= hstcp_aimd_vals[ca->ai-1].cwnd)
 				ca->ai--;
 		}
 
 		/* Do additive increase */
-		if (tp->snd_cwnd < tp->snd_cwnd_clamp) {
+		if (tcp_snd_cwnd(tp) < tp->snd_cwnd_clamp) {
 			/* cwnd = cwnd + a(w) / cwnd */
 			tp->snd_cwnd_cnt += ca->ai + 1;
-			if (tp->snd_cwnd_cnt >= tp->snd_cwnd) {
-				tp->snd_cwnd_cnt -= tp->snd_cwnd;
-				tp->snd_cwnd++;
+			if (tp->snd_cwnd_cnt >= tcp_snd_cwnd(tp)) {
+				tp->snd_cwnd_cnt -= tcp_snd_cwnd(tp);
+				tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) + 1);
 			}
 		}
 	}
@@ -154,7 +154,7 @@ static u32 hstcp_ssthresh(struct sock *sk)
 	struct hstcp *ca = inet_csk_ca(sk);
 
 	/* Do multiplicative decrease */
-	return max(tp->snd_cwnd - ((tp->snd_cwnd * hstcp_aimd_vals[ca->ai].md) >> 8), 2U);
+	return max(tcp_snd_cwnd(tp) - ((tcp_snd_cwnd(tp) * hstcp_aimd_vals[ca->ai].md) >> 8), 2U);
 }
 
 static struct tcp_congestion_ops tcp_highspeed __read_mostly = {
diff --git a/net/ipv4/tcp_htcp.c b/net/ipv4/tcp_htcp.c
index 55adcfcf96feaca1032198c1931e569ee80b3668..52b1f2665dfae81f63440c63f088232bd247fb7b 100644
--- a/net/ipv4/tcp_htcp.c
+++ b/net/ipv4/tcp_htcp.c
@@ -124,7 +124,7 @@ static void measure_achieved_throughput(struct sock *sk,
 
 	ca->packetcount += sample->pkts_acked;
 
-	if (ca->packetcount >= tp->snd_cwnd - (ca->alpha >> 7 ? : 1) &&
+	if (ca->packetcount >= tcp_snd_cwnd(tp) - (ca->alpha >> 7 ? : 1) &&
 	    now - ca->lasttime >= ca->minRTT &&
 	    ca->minRTT > 0) {
 		__u32 cur_Bi = ca->packetcount * HZ / (now - ca->lasttime);
@@ -225,7 +225,7 @@ static u32 htcp_recalc_ssthresh(struct sock *sk)
 	const struct htcp *ca = inet_csk_ca(sk);
 
 	htcp_param_update(sk);
-	return max((tp->snd_cwnd * ca->beta) >> 7, 2U);
+	return max((tcp_snd_cwnd(tp) * ca->beta) >> 7, 2U);
 }
 
 static void htcp_cong_avoid(struct sock *sk, u32 ack, u32 acked)
@@ -242,9 +242,9 @@ static void htcp_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 		/* In dangerous area, increase slowly.
 		 * In theory this is tp->snd_cwnd += alpha / tp->snd_cwnd
 		 */
-		if ((tp->snd_cwnd_cnt * ca->alpha)>>7 >= tp->snd_cwnd) {
-			if (tp->snd_cwnd < tp->snd_cwnd_clamp)
-				tp->snd_cwnd++;
+		if ((tp->snd_cwnd_cnt * ca->alpha)>>7 >= tcp_snd_cwnd(tp)) {
+			if (tcp_snd_cwnd(tp) < tp->snd_cwnd_clamp)
+				tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) + 1);
 			tp->snd_cwnd_cnt = 0;
 			htcp_alpha_update(ca);
 		} else
diff --git a/net/ipv4/tcp_hybla.c b/net/ipv4/tcp_hybla.c
index be39327e04e6c33cc7bc1ec26f3745c1c59cc70a..abd7d91807e542dee0a32913274de958b731e013 100644
--- a/net/ipv4/tcp_hybla.c
+++ b/net/ipv4/tcp_hybla.c
@@ -54,7 +54,7 @@ static void hybla_init(struct sock *sk)
 	ca->rho2_7ls = 0;
 	ca->snd_cwnd_cents = 0;
 	ca->hybla_en = true;
-	tp->snd_cwnd = 2;
+	tcp_snd_cwnd_set(tp, 2);
 	tp->snd_cwnd_clamp = 65535;
 
 	/* 1st Rho measurement based on initial srtt */
@@ -62,7 +62,7 @@ static void hybla_init(struct sock *sk)
 
 	/* set minimum rtt as this is the 1st ever seen */
 	ca->minrtt_us = tp->srtt_us;
-	tp->snd_cwnd = ca->rho;
+	tcp_snd_cwnd_set(tp, ca->rho);
 }
 
 static void hybla_state(struct sock *sk, u8 ca_state)
@@ -137,31 +137,31 @@ static void hybla_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 		 * as long as increment is estimated as (rho<<7)/window
 		 * it already is <<7 and we can easily count its fractions.
 		 */
-		increment = ca->rho2_7ls / tp->snd_cwnd;
+		increment = ca->rho2_7ls / tcp_snd_cwnd(tp);
 		if (increment < 128)
 			tp->snd_cwnd_cnt++;
 	}
 
 	odd = increment % 128;
-	tp->snd_cwnd += increment >> 7;
+	tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) + (increment >> 7));
 	ca->snd_cwnd_cents += odd;
 
 	/* check when fractions goes >=128 and increase cwnd by 1. */
 	while (ca->snd_cwnd_cents >= 128) {
-		tp->snd_cwnd++;
+		tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) + 1);
 		ca->snd_cwnd_cents -= 128;
 		tp->snd_cwnd_cnt = 0;
 	}
 	/* check when cwnd has not been incremented for a while */
-	if (increment == 0 && odd == 0 && tp->snd_cwnd_cnt >= tp->snd_cwnd) {
-		tp->snd_cwnd++;
+	if (increment == 0 && odd == 0 && tp->snd_cwnd_cnt >= tcp_snd_cwnd(tp)) {
+		tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) + 1);
 		tp->snd_cwnd_cnt = 0;
 	}
 	/* clamp down slowstart cwnd to ssthresh value. */
 	if (is_slowstart)
-		tp->snd_cwnd = min(tp->snd_cwnd, tp->snd_ssthresh);
+		tcp_snd_cwnd_set(tp, min(tcp_snd_cwnd(tp), tp->snd_ssthresh));
 
-	tp->snd_cwnd = min_t(u32, tp->snd_cwnd, tp->snd_cwnd_clamp);
+	tcp_snd_cwnd_set(tp, min(tcp_snd_cwnd(tp), tp->snd_cwnd_clamp));
 }
 
 static struct tcp_congestion_ops tcp_hybla __read_mostly = {
diff --git a/net/ipv4/tcp_illinois.c b/net/ipv4/tcp_illinois.c
index 00e54873213e87566eda45d8f5fbbe4c69f78262..c0c81a2c77faebc4fa55ae387adf738a20406827 100644
--- a/net/ipv4/tcp_illinois.c
+++ b/net/ipv4/tcp_illinois.c
@@ -224,7 +224,7 @@ static void update_params(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct illinois *ca = inet_csk_ca(sk);
 
-	if (tp->snd_cwnd < win_thresh) {
+	if (tcp_snd_cwnd(tp) < win_thresh) {
 		ca->alpha = ALPHA_BASE;
 		ca->beta = BETA_BASE;
 	} else if (ca->cnt_rtt > 0) {
@@ -284,9 +284,9 @@ static void tcp_illinois_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 		 * tp->snd_cwnd += alpha/tp->snd_cwnd
 		*/
 		delta = (tp->snd_cwnd_cnt * ca->alpha) >> ALPHA_SHIFT;
-		if (delta >= tp->snd_cwnd) {
-			tp->snd_cwnd = min(tp->snd_cwnd + delta / tp->snd_cwnd,
-					   (u32)tp->snd_cwnd_clamp);
+		if (delta >= tcp_snd_cwnd(tp)) {
+			tcp_snd_cwnd_set(tp, min(tcp_snd_cwnd(tp) + delta / tcp_snd_cwnd(tp),
+						 (u32)tp->snd_cwnd_clamp));
 			tp->snd_cwnd_cnt = 0;
 		}
 	}
@@ -296,9 +296,11 @@ static u32 tcp_illinois_ssthresh(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct illinois *ca = inet_csk_ca(sk);
+	u32 decr;
 
 	/* Multiplicative decrease */
-	return max(tp->snd_cwnd - ((tp->snd_cwnd * ca->beta) >> BETA_SHIFT), 2U);
+	decr = (tcp_snd_cwnd(tp) * ca->beta) >> BETA_SHIFT;
+	return max(tcp_snd_cwnd(tp) - decr, 2U);
 }
 
 /* Extract info for Tcp socket info provided via netlink. */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 2088f93fa37b5fb9110e7933242a27bd4009990e..1595b76ea2bea195b8896f4cd533beb14b56dd96 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -414,7 +414,7 @@ static void tcp_sndbuf_expand(struct sock *sk)
 	per_mss = roundup_pow_of_two(per_mss) +
 		  SKB_DATA_ALIGN(sizeof(struct sk_buff));
 
-	nr_segs = max_t(u32, TCP_INIT_CWND, tp->snd_cwnd);
+	nr_segs = max_t(u32, TCP_INIT_CWND, tcp_snd_cwnd(tp));
 	nr_segs = max_t(u32, nr_segs, tp->reordering + 1);
 
 	/* Fast Recovery (RFC 5681 3.2) :
@@ -909,12 +909,12 @@ static void tcp_update_pacing_rate(struct sock *sk)
 	 *	 If snd_cwnd >= (tp->snd_ssthresh / 2), we are approaching
 	 *	 end of slow start and should slow down.
 	 */
-	if (tp->snd_cwnd < tp->snd_ssthresh / 2)
+	if (tcp_snd_cwnd(tp) < tp->snd_ssthresh / 2)
 		rate *= sock_net(sk)->ipv4.sysctl_tcp_pacing_ss_ratio;
 	else
 		rate *= sock_net(sk)->ipv4.sysctl_tcp_pacing_ca_ratio;
 
-	rate *= max(tp->snd_cwnd, tp->packets_out);
+	rate *= max(tcp_snd_cwnd(tp), tp->packets_out);
 
 	if (likely(tp->srtt_us))
 		do_div(rate, tp->srtt_us);
@@ -2147,12 +2147,12 @@ void tcp_enter_loss(struct sock *sk)
 	    !after(tp->high_seq, tp->snd_una) ||
 	    (icsk->icsk_ca_state == TCP_CA_Loss && !icsk->icsk_retransmits)) {
 		tp->prior_ssthresh = tcp_current_ssthresh(sk);
-		tp->prior_cwnd = tp->snd_cwnd;
+		tp->prior_cwnd = tcp_snd_cwnd(tp);
 		tp->snd_ssthresh = icsk->icsk_ca_ops->ssthresh(sk);
 		tcp_ca_event(sk, CA_EVENT_LOSS);
 		tcp_init_undo(tp);
 	}
-	tp->snd_cwnd	   = tcp_packets_in_flight(tp) + 1;
+	tcp_snd_cwnd_set(tp, tcp_packets_in_flight(tp) + 1);
 	tp->snd_cwnd_cnt   = 0;
 	tp->snd_cwnd_stamp = tcp_jiffies32;
 
@@ -2458,7 +2458,7 @@ static void DBGUNDO(struct sock *sk, const char *msg)
 		pr_debug("Undo %s %pI4/%u c%u l%u ss%u/%u p%u\n",
 			 msg,
 			 &inet->inet_daddr, ntohs(inet->inet_dport),
-			 tp->snd_cwnd, tcp_left_out(tp),
+			 tcp_snd_cwnd(tp), tcp_left_out(tp),
 			 tp->snd_ssthresh, tp->prior_ssthresh,
 			 tp->packets_out);
 	}
@@ -2467,7 +2467,7 @@ static void DBGUNDO(struct sock *sk, const char *msg)
 		pr_debug("Undo %s %pI6/%u c%u l%u ss%u/%u p%u\n",
 			 msg,
 			 &sk->sk_v6_daddr, ntohs(inet->inet_dport),
-			 tp->snd_cwnd, tcp_left_out(tp),
+			 tcp_snd_cwnd(tp), tcp_left_out(tp),
 			 tp->snd_ssthresh, tp->prior_ssthresh,
 			 tp->packets_out);
 	}
@@ -2492,7 +2492,7 @@ static void tcp_undo_cwnd_reduction(struct sock *sk, bool unmark_loss)
 	if (tp->prior_ssthresh) {
 		const struct inet_connection_sock *icsk = inet_csk(sk);
 
-		tp->snd_cwnd = icsk->icsk_ca_ops->undo_cwnd(sk);
+		tcp_snd_cwnd_set(tp, icsk->icsk_ca_ops->undo_cwnd(sk));
 
 		if (tp->prior_ssthresh > tp->snd_ssthresh) {
 			tp->snd_ssthresh = tp->prior_ssthresh;
@@ -2599,7 +2599,7 @@ static void tcp_init_cwnd_reduction(struct sock *sk)
 	tp->high_seq = tp->snd_nxt;
 	tp->tlp_high_seq = 0;
 	tp->snd_cwnd_cnt = 0;
-	tp->prior_cwnd = tp->snd_cwnd;
+	tp->prior_cwnd = tcp_snd_cwnd(tp);
 	tp->prr_delivered = 0;
 	tp->prr_out = 0;
 	tp->snd_ssthresh = inet_csk(sk)->icsk_ca_ops->ssthresh(sk);
@@ -2629,7 +2629,7 @@ void tcp_cwnd_reduction(struct sock *sk, int newly_acked_sacked, int newly_lost,
 	}
 	/* Force a fast retransmit upon entering fast recovery */
 	sndcnt = max(sndcnt, (tp->prr_out ? 0 : 1));
-	tp->snd_cwnd = tcp_packets_in_flight(tp) + sndcnt;
+	tcp_snd_cwnd_set(tp, tcp_packets_in_flight(tp) + sndcnt);
 }
 
 static inline void tcp_end_cwnd_reduction(struct sock *sk)
@@ -2642,7 +2642,7 @@ static inline void tcp_end_cwnd_reduction(struct sock *sk)
 	/* Reset cwnd to ssthresh in CWR or Recovery (unless it's undone) */
 	if (tp->snd_ssthresh < TCP_INFINITE_SSTHRESH &&
 	    (inet_csk(sk)->icsk_ca_state == TCP_CA_CWR || tp->undo_marker)) {
-		tp->snd_cwnd = tp->snd_ssthresh;
+		tcp_snd_cwnd_set(tp, tp->snd_ssthresh);
 		tp->snd_cwnd_stamp = tcp_jiffies32;
 	}
 	tcp_ca_event(sk, CA_EVENT_COMPLETE_CWR);
@@ -2709,9 +2709,9 @@ static void tcp_mtup_probe_success(struct sock *sk)
 
 	/* FIXME: breaks with very large cwnd */
 	tp->prior_ssthresh = tcp_current_ssthresh(sk);
-	tp->snd_cwnd = tp->snd_cwnd *
-		       tcp_mss_to_mtu(sk, tp->mss_cache) /
-		       icsk->icsk_mtup.probe_size;
+	tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) *
+			     tcp_mss_to_mtu(sk, tp->mss_cache) /
+			     icsk->icsk_mtup.probe_size);
 	tp->snd_cwnd_cnt = 0;
 	tp->snd_cwnd_stamp = tcp_jiffies32;
 	tp->snd_ssthresh = tcp_current_ssthresh(sk);
@@ -3034,7 +3034,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 		    tp->snd_una == tp->mtu_probe.probe_seq_start) {
 			tcp_mtup_probe_failed(sk);
 			/* Restores the reduction we did in tcp_mtup_probe() */
-			tp->snd_cwnd++;
+			tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) + 1);
 			tcp_simple_retransmit(sk);
 			return;
 		}
@@ -5436,7 +5436,7 @@ static bool tcp_should_expand_sndbuf(struct sock *sk)
 		return false;
 
 	/* If we filled the congestion window, do not expand.  */
-	if (tcp_packets_in_flight(tp) >= tp->snd_cwnd)
+	if (tcp_packets_in_flight(tp) >= tcp_snd_cwnd(tp))
 		return false;
 
 	return true;
@@ -5998,9 +5998,9 @@ void tcp_init_transfer(struct sock *sk, int bpf_op, struct sk_buff *skb)
 	 * retransmission has occurred.
 	 */
 	if (tp->total_retrans > 1 && tp->undo_marker)
-		tp->snd_cwnd = 1;
+		tcp_snd_cwnd_set(tp, 1);
 	else
-		tp->snd_cwnd = tcp_init_cwnd(tp, __sk_dst_get(sk));
+		tcp_snd_cwnd_set(tp, tcp_init_cwnd(tp, __sk_dst_get(sk)));
 	tp->snd_cwnd_stamp = tcp_jiffies32;
 
 	bpf_skops_established(sk, bpf_op, skb);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index f9cec624068dfa1d218357d7e88c89459d7d54f4..157265aecbedd1761de2d892b5a54f4a0cfe1912 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2621,7 +2621,7 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i)
 		jiffies_to_clock_t(icsk->icsk_rto),
 		jiffies_to_clock_t(icsk->icsk_ack.ato),
 		(icsk->icsk_ack.quick << 1) | inet_csk_in_pingpong_mode(sk),
-		tp->snd_cwnd,
+		tcp_snd_cwnd(tp),
 		state == TCP_LISTEN ?
 		    fastopenq->max_qlen :
 		    (tcp_in_initial_slowstart(tp) ? -1 : tp->snd_ssthresh));
diff --git a/net/ipv4/tcp_lp.c b/net/ipv4/tcp_lp.c
index 82b36ec3f2f82b3f5c33f3cd21fda34a4d015a4f..ae36780977d2762066cdd59e40116d1240492b90 100644
--- a/net/ipv4/tcp_lp.c
+++ b/net/ipv4/tcp_lp.c
@@ -297,7 +297,7 @@ static void tcp_lp_pkts_acked(struct sock *sk, const struct ack_sample *sample)
 		lp->flag &= ~LP_WITHIN_THR;
 
 	pr_debug("TCP-LP: %05o|%5u|%5u|%15u|%15u|%15u\n", lp->flag,
-		 tp->snd_cwnd, lp->remote_hz, lp->owd_min, lp->owd_max,
+		 tcp_snd_cwnd(tp), lp->remote_hz, lp->owd_min, lp->owd_max,
 		 lp->sowd >> 3);
 
 	if (lp->flag & LP_WITHIN_THR)
@@ -313,12 +313,12 @@ static void tcp_lp_pkts_acked(struct sock *sk, const struct ack_sample *sample)
 	/* happened within inference
 	 * drop snd_cwnd into 1 */
 	if (lp->flag & LP_WITHIN_INF)
-		tp->snd_cwnd = 1U;
+		tcp_snd_cwnd_set(tp, 1U);
 
 	/* happened after inference
 	 * cut snd_cwnd into half */
 	else
-		tp->snd_cwnd = max(tp->snd_cwnd >> 1U, 1U);
+		tcp_snd_cwnd_set(tp, max(tcp_snd_cwnd(tp) >> 1U, 1U));
 
 	/* record this drop time */
 	lp->last_drop = now;
diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 0588b004ddac1636be7ef1c5e57f5910dbfd8756..7029b0e98edb285102dcab4521f296511a70dc57 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -388,15 +388,15 @@ void tcp_update_metrics(struct sock *sk)
 		if (!net->ipv4.sysctl_tcp_no_ssthresh_metrics_save &&
 		    !tcp_metric_locked(tm, TCP_METRIC_SSTHRESH)) {
 			val = tcp_metric_get(tm, TCP_METRIC_SSTHRESH);
-			if (val && (tp->snd_cwnd >> 1) > val)
+			if (val && (tcp_snd_cwnd(tp) >> 1) > val)
 				tcp_metric_set(tm, TCP_METRIC_SSTHRESH,
-					       tp->snd_cwnd >> 1);
+					       tcp_snd_cwnd(tp) >> 1);
 		}
 		if (!tcp_metric_locked(tm, TCP_METRIC_CWND)) {
 			val = tcp_metric_get(tm, TCP_METRIC_CWND);
-			if (tp->snd_cwnd > val)
+			if (tcp_snd_cwnd(tp) > val)
 				tcp_metric_set(tm, TCP_METRIC_CWND,
-					       tp->snd_cwnd);
+					       tcp_snd_cwnd(tp));
 		}
 	} else if (!tcp_in_slow_start(tp) &&
 		   icsk->icsk_ca_state == TCP_CA_Open) {
@@ -404,10 +404,10 @@ void tcp_update_metrics(struct sock *sk)
 		if (!net->ipv4.sysctl_tcp_no_ssthresh_metrics_save &&
 		    !tcp_metric_locked(tm, TCP_METRIC_SSTHRESH))
 			tcp_metric_set(tm, TCP_METRIC_SSTHRESH,
-				       max(tp->snd_cwnd >> 1, tp->snd_ssthresh));
+				       max(tcp_snd_cwnd(tp) >> 1, tp->snd_ssthresh));
 		if (!tcp_metric_locked(tm, TCP_METRIC_CWND)) {
 			val = tcp_metric_get(tm, TCP_METRIC_CWND);
-			tcp_metric_set(tm, TCP_METRIC_CWND, (val + tp->snd_cwnd) >> 1);
+			tcp_metric_set(tm, TCP_METRIC_CWND, (val + tcp_snd_cwnd(tp)) >> 1);
 		}
 	} else {
 		/* Else slow start did not finish, cwnd is non-sense,
diff --git a/net/ipv4/tcp_nv.c b/net/ipv4/tcp_nv.c
index ab552356bdba8f92f414aec55a5a9cd93b7975b2..a60662f4bdf92cba1d92a3eedd7c607d1537d7f2 100644
--- a/net/ipv4/tcp_nv.c
+++ b/net/ipv4/tcp_nv.c
@@ -197,10 +197,10 @@ static void tcpnv_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 	}
 
 	if (ca->cwnd_growth_factor < 0) {
-		cnt = tp->snd_cwnd << -ca->cwnd_growth_factor;
+		cnt = tcp_snd_cwnd(tp) << -ca->cwnd_growth_factor;
 		tcp_cong_avoid_ai(tp, cnt, acked);
 	} else {
-		cnt = max(4U, tp->snd_cwnd >> ca->cwnd_growth_factor);
+		cnt = max(4U, tcp_snd_cwnd(tp) >> ca->cwnd_growth_factor);
 		tcp_cong_avoid_ai(tp, cnt, acked);
 	}
 }
@@ -209,7 +209,7 @@ static u32 tcpnv_recalc_ssthresh(struct sock *sk)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 
-	return max((tp->snd_cwnd * nv_loss_dec_factor) >> 10, 2U);
+	return max((tcp_snd_cwnd(tp) * nv_loss_dec_factor) >> 10, 2U);
 }
 
 static void tcpnv_state(struct sock *sk, u8 new_state)
@@ -257,7 +257,7 @@ static void tcpnv_acked(struct sock *sk, const struct ack_sample *sample)
 		return;
 
 	/* Stop cwnd growth if we were in catch up mode */
-	if (ca->nv_catchup && tp->snd_cwnd >= nv_min_cwnd) {
+	if (ca->nv_catchup && tcp_snd_cwnd(tp) >= nv_min_cwnd) {
 		ca->nv_catchup = 0;
 		ca->nv_allow_cwnd_growth = 0;
 	}
@@ -371,7 +371,7 @@ static void tcpnv_acked(struct sock *sk, const struct ack_sample *sample)
 		 * if cwnd < max_win, grow cwnd
 		 * else leave the same
 		 */
-		if (tp->snd_cwnd > max_win) {
+		if (tcp_snd_cwnd(tp) > max_win) {
 			/* there is congestion, check that it is ok
 			 * to make a CA decision
 			 * 1. We should have at least nv_dec_eval_min_calls
@@ -398,20 +398,20 @@ static void tcpnv_acked(struct sock *sk, const struct ack_sample *sample)
 			ca->nv_allow_cwnd_growth = 0;
 			tp->snd_ssthresh =
 				(nv_ssthresh_factor * max_win) >> 3;
-			if (tp->snd_cwnd - max_win > 2) {
+			if (tcp_snd_cwnd(tp) - max_win > 2) {
 				/* gap > 2, we do exponential cwnd decrease */
 				int dec;
 
-				dec = max(2U, ((tp->snd_cwnd - max_win) *
+				dec = max(2U, ((tcp_snd_cwnd(tp) - max_win) *
 					       nv_cong_dec_mult) >> 7);
-				tp->snd_cwnd -= dec;
+				tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) - dec);
 			} else if (nv_cong_dec_mult > 0) {
-				tp->snd_cwnd = max_win;
+				tcp_snd_cwnd_set(tp, max_win);
 			}
 			if (ca->cwnd_growth_factor > 0)
 				ca->cwnd_growth_factor = 0;
 			ca->nv_no_cong_cnt = 0;
-		} else if (tp->snd_cwnd <= max_win - nv_pad_buffer) {
+		} else if (tcp_snd_cwnd(tp) <= max_win - nv_pad_buffer) {
 			/* There is no congestion, grow cwnd if allowed*/
 			if (ca->nv_eval_call_cnt < nv_inc_eval_min_calls)
 				return;
@@ -444,8 +444,8 @@ static void tcpnv_acked(struct sock *sk, const struct ack_sample *sample)
 		 * (it wasn't before, if it is now is because nv
 		 *  decreased it).
 		 */
-		if (tp->snd_cwnd < nv_min_cwnd)
-			tp->snd_cwnd = nv_min_cwnd;
+		if (tcp_snd_cwnd(tp) < nv_min_cwnd)
+			tcp_snd_cwnd_set(tp, nv_min_cwnd);
 	}
 }
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 9ede847f4199844c5884e3f62ea450562072a0a7..c221f3bce975ef17189d6250a6b52f5c80f142c8 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -142,7 +142,7 @@ void tcp_cwnd_restart(struct sock *sk, s32 delta)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	u32 restart_cwnd = tcp_init_cwnd(tp, __sk_dst_get(sk));
-	u32 cwnd = tp->snd_cwnd;
+	u32 cwnd = tcp_snd_cwnd(tp);
 
 	tcp_ca_event(sk, CA_EVENT_CWND_RESTART);
 
@@ -151,7 +151,7 @@ void tcp_cwnd_restart(struct sock *sk, s32 delta)
 
 	while ((delta -= inet_csk(sk)->icsk_rto) > 0 && cwnd > restart_cwnd)
 		cwnd >>= 1;
-	tp->snd_cwnd = max(cwnd, restart_cwnd);
+	tcp_snd_cwnd_set(tp, max(cwnd, restart_cwnd));
 	tp->snd_cwnd_stamp = tcp_jiffies32;
 	tp->snd_cwnd_used = 0;
 }
@@ -1013,7 +1013,7 @@ static void tcp_tsq_write(struct sock *sk)
 		struct tcp_sock *tp = tcp_sk(sk);
 
 		if (tp->lost_out > tp->retrans_out &&
-		    tp->snd_cwnd > tcp_packets_in_flight(tp)) {
+		    tcp_snd_cwnd(tp) > tcp_packets_in_flight(tp)) {
 			tcp_mstamp_refresh(tp);
 			tcp_xmit_retransmit_queue(sk);
 		}
@@ -1860,9 +1860,9 @@ static void tcp_cwnd_application_limited(struct sock *sk)
 		/* Limited by application or receiver window. */
 		u32 init_win = tcp_init_cwnd(tp, __sk_dst_get(sk));
 		u32 win_used = max(tp->snd_cwnd_used, init_win);
-		if (win_used < tp->snd_cwnd) {
+		if (win_used < tcp_snd_cwnd(tp)) {
 			tp->snd_ssthresh = tcp_current_ssthresh(sk);
-			tp->snd_cwnd = (tp->snd_cwnd + win_used) >> 1;
+			tcp_snd_cwnd_set(tp, (tcp_snd_cwnd(tp) + win_used) >> 1);
 		}
 		tp->snd_cwnd_used = 0;
 	}
@@ -2043,7 +2043,7 @@ static inline unsigned int tcp_cwnd_test(const struct tcp_sock *tp,
 		return 1;
 
 	in_flight = tcp_packets_in_flight(tp);
-	cwnd = tp->snd_cwnd;
+	cwnd = tcp_snd_cwnd(tp);
 	if (in_flight >= cwnd)
 		return 0;
 
@@ -2196,12 +2196,12 @@ static bool tcp_tso_should_defer(struct sock *sk, struct sk_buff *skb,
 	in_flight = tcp_packets_in_flight(tp);
 
 	BUG_ON(tcp_skb_pcount(skb) <= 1);
-	BUG_ON(tp->snd_cwnd <= in_flight);
+	BUG_ON(tcp_snd_cwnd(tp) <= in_flight);
 
 	send_win = tcp_wnd_end(tp) - TCP_SKB_CB(skb)->seq;
 
 	/* From in_flight test above, we know that cwnd > in_flight.  */
-	cong_win = (tp->snd_cwnd - in_flight) * tp->mss_cache;
+	cong_win = (tcp_snd_cwnd(tp) - in_flight) * tp->mss_cache;
 
 	limit = min(send_win, cong_win);
 
@@ -2215,7 +2215,7 @@ static bool tcp_tso_should_defer(struct sock *sk, struct sk_buff *skb,
 
 	win_divisor = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_tso_win_divisor);
 	if (win_divisor) {
-		u32 chunk = min(tp->snd_wnd, tp->snd_cwnd * tp->mss_cache);
+		u32 chunk = min(tp->snd_wnd, tcp_snd_cwnd(tp) * tp->mss_cache);
 
 		/* If at least some fraction of a window is available,
 		 * just use it.
@@ -2345,7 +2345,7 @@ static int tcp_mtu_probe(struct sock *sk)
 	if (likely(!icsk->icsk_mtup.enabled ||
 		   icsk->icsk_mtup.probe_size ||
 		   inet_csk(sk)->icsk_ca_state != TCP_CA_Open ||
-		   tp->snd_cwnd < 11 ||
+		   tcp_snd_cwnd(tp) < 11 ||
 		   tp->rx_opt.num_sacks || tp->rx_opt.dsack))
 		return -1;
 
@@ -2381,7 +2381,7 @@ static int tcp_mtu_probe(struct sock *sk)
 		return 0;
 
 	/* Do we need to wait to drain cwnd? With none in flight, don't stall */
-	if (tcp_packets_in_flight(tp) + 2 > tp->snd_cwnd) {
+	if (tcp_packets_in_flight(tp) + 2 > tcp_snd_cwnd(tp)) {
 		if (!tcp_packets_in_flight(tp))
 			return -1;
 		else
@@ -2450,7 +2450,7 @@ static int tcp_mtu_probe(struct sock *sk)
 	if (!tcp_transmit_skb(sk, nskb, 1, GFP_ATOMIC)) {
 		/* Decrement cwnd here because we are sending
 		 * effectively two packets. */
-		tp->snd_cwnd--;
+		tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) - 1);
 		tcp_event_new_data_sent(sk, nskb);
 
 		icsk->icsk_mtup.probe_size = tcp_mss_to_mtu(sk, nskb->len);
@@ -2708,7 +2708,7 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
 	else
 		tcp_chrono_stop(sk, TCP_CHRONO_RWND_LIMITED);
 
-	is_cwnd_limited |= (tcp_packets_in_flight(tp) >= tp->snd_cwnd);
+	is_cwnd_limited |= (tcp_packets_in_flight(tp) >= tcp_snd_cwnd(tp));
 	if (likely(sent_pkts || is_cwnd_limited))
 		tcp_cwnd_validate(sk, is_cwnd_limited);
 
@@ -2818,7 +2818,7 @@ void tcp_send_loss_probe(struct sock *sk)
 	if (unlikely(!skb)) {
 		WARN_ONCE(tp->packets_out,
 			  "invalid inflight: %u state %u cwnd %u mss %d\n",
-			  tp->packets_out, sk->sk_state, tp->snd_cwnd, mss);
+			  tp->packets_out, sk->sk_state, tcp_snd_cwnd(tp), mss);
 		inet_csk(sk)->icsk_pending = 0;
 		return;
 	}
@@ -3302,7 +3302,7 @@ void tcp_xmit_retransmit_queue(struct sock *sk)
 		if (!hole)
 			tp->retransmit_skb_hint = skb;
 
-		segs = tp->snd_cwnd - tcp_packets_in_flight(tp);
+		segs = tcp_snd_cwnd(tp) - tcp_packets_in_flight(tp);
 		if (segs <= 0)
 			break;
 		sacked = TCP_SKB_CB(skb)->sacked;
diff --git a/net/ipv4/tcp_rate.c b/net/ipv4/tcp_rate.c
index fbab921670cc91a121f2ab8cd7aa6ecfd3748535..617b8187c03d9c339958089258ab30e149364eef 100644
--- a/net/ipv4/tcp_rate.c
+++ b/net/ipv4/tcp_rate.c
@@ -195,7 +195,7 @@ void tcp_rate_check_app_limited(struct sock *sk)
 	    /* Nothing in sending host's qdisc queues or NIC tx queue. */
 	    sk_wmem_alloc_get(sk) < SKB_TRUESIZE(1) &&
 	    /* We are not limited by CWND. */
-	    tcp_packets_in_flight(tp) < tp->snd_cwnd &&
+	    tcp_packets_in_flight(tp) < tcp_snd_cwnd(tp) &&
 	    /* All lost packets have been retransmitted. */
 	    tp->lost_out <= tp->retrans_out)
 		tp->app_limited =
diff --git a/net/ipv4/tcp_scalable.c b/net/ipv4/tcp_scalable.c
index 5842081bc8a25b53bc10745688d97ac59a0ee200..862b96248a92dc1b7fa15d688d31ae043fc446a7 100644
--- a/net/ipv4/tcp_scalable.c
+++ b/net/ipv4/tcp_scalable.c
@@ -27,7 +27,7 @@ static void tcp_scalable_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 		if (!acked)
 			return;
 	}
-	tcp_cong_avoid_ai(tp, min(tp->snd_cwnd, TCP_SCALABLE_AI_CNT),
+	tcp_cong_avoid_ai(tp, min(tcp_snd_cwnd(tp), TCP_SCALABLE_AI_CNT),
 			  acked);
 }
 
@@ -35,7 +35,7 @@ static u32 tcp_scalable_ssthresh(struct sock *sk)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 
-	return max(tp->snd_cwnd - (tp->snd_cwnd>>TCP_SCALABLE_MD_SCALE), 2U);
+	return max(tcp_snd_cwnd(tp) - (tcp_snd_cwnd(tp)>>TCP_SCALABLE_MD_SCALE), 2U);
 }
 
 static struct tcp_congestion_ops tcp_scalable __read_mostly = {
diff --git a/net/ipv4/tcp_vegas.c b/net/ipv4/tcp_vegas.c
index c8003c8aad2c00835a57d6084e788fb453a96026..786848ad37ea8d5f9bd817666181905f3f6ec9d4 100644
--- a/net/ipv4/tcp_vegas.c
+++ b/net/ipv4/tcp_vegas.c
@@ -159,7 +159,7 @@ EXPORT_SYMBOL_GPL(tcp_vegas_cwnd_event);
 
 static inline u32 tcp_vegas_ssthresh(struct tcp_sock *tp)
 {
-	return  min(tp->snd_ssthresh, tp->snd_cwnd);
+	return  min(tp->snd_ssthresh, tcp_snd_cwnd(tp));
 }
 
 static void tcp_vegas_cong_avoid(struct sock *sk, u32 ack, u32 acked)
@@ -217,14 +217,14 @@ static void tcp_vegas_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 			 * This is:
 			 *     (actual rate in segments) * baseRTT
 			 */
-			target_cwnd = (u64)tp->snd_cwnd * vegas->baseRTT;
+			target_cwnd = (u64)tcp_snd_cwnd(tp) * vegas->baseRTT;
 			do_div(target_cwnd, rtt);
 
 			/* Calculate the difference between the window we had,
 			 * and the window we would like to have. This quantity
 			 * is the "Diff" from the Arizona Vegas papers.
 			 */
-			diff = tp->snd_cwnd * (rtt-vegas->baseRTT) / vegas->baseRTT;
+			diff = tcp_snd_cwnd(tp) * (rtt-vegas->baseRTT) / vegas->baseRTT;
 
 			if (diff > gamma && tcp_in_slow_start(tp)) {
 				/* Going too fast. Time to slow down
@@ -238,7 +238,8 @@ static void tcp_vegas_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 				 * truncation robs us of full link
 				 * utilization.
 				 */
-				tp->snd_cwnd = min(tp->snd_cwnd, (u32)target_cwnd+1);
+				tcp_snd_cwnd_set(tp, min(tcp_snd_cwnd(tp),
+							 (u32)target_cwnd + 1));
 				tp->snd_ssthresh = tcp_vegas_ssthresh(tp);
 
 			} else if (tcp_in_slow_start(tp)) {
@@ -254,14 +255,14 @@ static void tcp_vegas_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 					/* The old window was too fast, so
 					 * we slow down.
 					 */
-					tp->snd_cwnd--;
+					tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) - 1);
 					tp->snd_ssthresh
 						= tcp_vegas_ssthresh(tp);
 				} else if (diff < alpha) {
 					/* We don't have enough extra packets
 					 * in the network, so speed up.
 					 */
-					tp->snd_cwnd++;
+					tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) + 1);
 				} else {
 					/* Sending just as fast as we
 					 * should be.
@@ -269,10 +270,10 @@ static void tcp_vegas_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 				}
 			}
 
-			if (tp->snd_cwnd < 2)
-				tp->snd_cwnd = 2;
-			else if (tp->snd_cwnd > tp->snd_cwnd_clamp)
-				tp->snd_cwnd = tp->snd_cwnd_clamp;
+			if (tcp_snd_cwnd(tp) < 2)
+				tcp_snd_cwnd_set(tp, 2);
+			else if (tcp_snd_cwnd(tp) > tp->snd_cwnd_clamp)
+				tcp_snd_cwnd_set(tp, tp->snd_cwnd_clamp);
 
 			tp->snd_ssthresh = tcp_current_ssthresh(sk);
 		}
diff --git a/net/ipv4/tcp_veno.c b/net/ipv4/tcp_veno.c
index cd50a61c9976d78dbcc5fc27b8f687ee2f3fbebe..366ff6f214b2ee746cecdf10353e4624252478e0 100644
--- a/net/ipv4/tcp_veno.c
+++ b/net/ipv4/tcp_veno.c
@@ -146,11 +146,11 @@ static void tcp_veno_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 
 		rtt = veno->minrtt;
 
-		target_cwnd = (u64)tp->snd_cwnd * veno->basertt;
+		target_cwnd = (u64)tcp_snd_cwnd(tp) * veno->basertt;
 		target_cwnd <<= V_PARAM_SHIFT;
 		do_div(target_cwnd, rtt);
 
-		veno->diff = (tp->snd_cwnd << V_PARAM_SHIFT) - target_cwnd;
+		veno->diff = (tcp_snd_cwnd(tp) << V_PARAM_SHIFT) - target_cwnd;
 
 		if (tcp_in_slow_start(tp)) {
 			/* Slow start. */
@@ -164,15 +164,15 @@ static void tcp_veno_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 			/* In the "non-congestive state", increase cwnd
 			 * every rtt.
 			 */
-			tcp_cong_avoid_ai(tp, tp->snd_cwnd, acked);
+			tcp_cong_avoid_ai(tp, tcp_snd_cwnd(tp), acked);
 		} else {
 			/* In the "congestive state", increase cwnd
 			 * every other rtt.
 			 */
-			if (tp->snd_cwnd_cnt >= tp->snd_cwnd) {
+			if (tp->snd_cwnd_cnt >= tcp_snd_cwnd(tp)) {
 				if (veno->inc &&
-				    tp->snd_cwnd < tp->snd_cwnd_clamp) {
-					tp->snd_cwnd++;
+				    tcp_snd_cwnd(tp) < tp->snd_cwnd_clamp) {
+					tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) + 1);
 					veno->inc = 0;
 				} else
 					veno->inc = 1;
@@ -181,10 +181,10 @@ static void tcp_veno_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 				tp->snd_cwnd_cnt += acked;
 		}
 done:
-		if (tp->snd_cwnd < 2)
-			tp->snd_cwnd = 2;
-		else if (tp->snd_cwnd > tp->snd_cwnd_clamp)
-			tp->snd_cwnd = tp->snd_cwnd_clamp;
+		if (tcp_snd_cwnd(tp) < 2)
+			tcp_snd_cwnd_set(tp, 2);
+		else if (tcp_snd_cwnd(tp) > tp->snd_cwnd_clamp)
+			tcp_snd_cwnd_set(tp, tp->snd_cwnd_clamp);
 	}
 	/* Wipe the slate clean for the next rtt. */
 	/* veno->cntrtt = 0; */
@@ -199,10 +199,10 @@ static u32 tcp_veno_ssthresh(struct sock *sk)
 
 	if (veno->diff < beta)
 		/* in "non-congestive state", cut cwnd by 1/5 */
-		return max(tp->snd_cwnd * 4 / 5, 2U);
+		return max(tcp_snd_cwnd(tp) * 4 / 5, 2U);
 	else
 		/* in "congestive state", cut cwnd by 1/2 */
-		return max(tp->snd_cwnd >> 1U, 2U);
+		return max(tcp_snd_cwnd(tp) >> 1U, 2U);
 }
 
 static struct tcp_congestion_ops tcp_veno __read_mostly = {
diff --git a/net/ipv4/tcp_westwood.c b/net/ipv4/tcp_westwood.c
index b2e05c4cea00fd7b524e061ca9d095fd9f656e64..c6e97141eef2591c5ab50f4058a5377e0855313f 100644
--- a/net/ipv4/tcp_westwood.c
+++ b/net/ipv4/tcp_westwood.c
@@ -244,7 +244,8 @@ static void tcp_westwood_event(struct sock *sk, enum tcp_ca_event event)
 
 	switch (event) {
 	case CA_EVENT_COMPLETE_CWR:
-		tp->snd_cwnd = tp->snd_ssthresh = tcp_westwood_bw_rttmin(sk);
+		tp->snd_ssthresh = tcp_westwood_bw_rttmin(sk);
+		tcp_snd_cwnd_set(tp, tp->snd_ssthresh);
 		break;
 	case CA_EVENT_LOSS:
 		tp->snd_ssthresh = tcp_westwood_bw_rttmin(sk);
diff --git a/net/ipv4/tcp_yeah.c b/net/ipv4/tcp_yeah.c
index 07c4c93b9fdb65a513d99532ed7c066cec7d89f4..18b07ff5d20e6c5eefe9ab54c6b8e429f01d64b9 100644
--- a/net/ipv4/tcp_yeah.c
+++ b/net/ipv4/tcp_yeah.c
@@ -71,11 +71,11 @@ static void tcp_yeah_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 
 	if (!yeah->doing_reno_now) {
 		/* Scalable */
-		tcp_cong_avoid_ai(tp, min(tp->snd_cwnd, TCP_SCALABLE_AI_CNT),
+		tcp_cong_avoid_ai(tp, min(tcp_snd_cwnd(tp), TCP_SCALABLE_AI_CNT),
 				  acked);
 	} else {
 		/* Reno */
-		tcp_cong_avoid_ai(tp, tp->snd_cwnd, acked);
+		tcp_cong_avoid_ai(tp, tcp_snd_cwnd(tp), acked);
 	}
 
 	/* The key players are v_vegas.beg_snd_una and v_beg_snd_nxt.
@@ -130,7 +130,7 @@ static void tcp_yeah_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 			/* Compute excess number of packets above bandwidth
 			 * Avoid doing full 64 bit divide.
 			 */
-			bw = tp->snd_cwnd;
+			bw = tcp_snd_cwnd(tp);
 			bw *= rtt - yeah->vegas.baseRTT;
 			do_div(bw, rtt);
 			queue = bw;
@@ -138,20 +138,20 @@ static void tcp_yeah_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 			if (queue > TCP_YEAH_ALPHA ||
 			    rtt - yeah->vegas.baseRTT > (yeah->vegas.baseRTT / TCP_YEAH_PHY)) {
 				if (queue > TCP_YEAH_ALPHA &&
-				    tp->snd_cwnd > yeah->reno_count) {
+				    tcp_snd_cwnd(tp) > yeah->reno_count) {
 					u32 reduction = min(queue / TCP_YEAH_GAMMA ,
-							    tp->snd_cwnd >> TCP_YEAH_EPSILON);
+							    tcp_snd_cwnd(tp) >> TCP_YEAH_EPSILON);
 
-					tp->snd_cwnd -= reduction;
+					tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) - reduction);
 
-					tp->snd_cwnd = max(tp->snd_cwnd,
-							   yeah->reno_count);
+					tcp_snd_cwnd_set(tp, max(tcp_snd_cwnd(tp),
+								 yeah->reno_count));
 
-					tp->snd_ssthresh = tp->snd_cwnd;
+					tp->snd_ssthresh = tcp_snd_cwnd(tp);
 				}
 
 				if (yeah->reno_count <= 2)
-					yeah->reno_count = max(tp->snd_cwnd>>1, 2U);
+					yeah->reno_count = max(tcp_snd_cwnd(tp)>>1, 2U);
 				else
 					yeah->reno_count++;
 
@@ -176,7 +176,7 @@ static void tcp_yeah_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 		 */
 		yeah->vegas.beg_snd_una  = yeah->vegas.beg_snd_nxt;
 		yeah->vegas.beg_snd_nxt  = tp->snd_nxt;
-		yeah->vegas.beg_snd_cwnd = tp->snd_cwnd;
+		yeah->vegas.beg_snd_cwnd = tcp_snd_cwnd(tp);
 
 		/* Wipe the slate clean for the next RTT. */
 		yeah->vegas.cntRTT = 0;
@@ -193,16 +193,16 @@ static u32 tcp_yeah_ssthresh(struct sock *sk)
 	if (yeah->doing_reno_now < TCP_YEAH_RHO) {
 		reduction = yeah->lastQ;
 
-		reduction = min(reduction, max(tp->snd_cwnd>>1, 2U));
+		reduction = min(reduction, max(tcp_snd_cwnd(tp)>>1, 2U));
 
-		reduction = max(reduction, tp->snd_cwnd >> TCP_YEAH_DELTA);
+		reduction = max(reduction, tcp_snd_cwnd(tp) >> TCP_YEAH_DELTA);
 	} else
-		reduction = max(tp->snd_cwnd>>1, 2U);
+		reduction = max(tcp_snd_cwnd(tp)>>1, 2U);
 
 	yeah->fast_count = 0;
 	yeah->reno_count = max(yeah->reno_count>>1, 2U);
 
-	return max_t(int, tp->snd_cwnd - reduction, 2);
+	return max_t(int, tcp_snd_cwnd(tp) - reduction, 2);
 }
 
 static struct tcp_congestion_ops tcp_yeah __read_mostly = {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 13678d3908fac9990e5b0c0df87fa4cca685baaf..782df529ff69e0b2fc5f9d12fc72538b7041a392 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2044,7 +2044,7 @@ static void get_tcp6_sock(struct seq_file *seq, struct sock *sp, int i)
 		   jiffies_to_clock_t(icsk->icsk_rto),
 		   jiffies_to_clock_t(icsk->icsk_ack.ato),
 		   (icsk->icsk_ack.quick << 1) | inet_csk_in_pingpong_mode(sp),
-		   tp->snd_cwnd,
+		   tcp_snd_cwnd(tp),
 		   state == TCP_LISTEN ?
 			fastopenq->max_qlen :
 			(tcp_in_initial_slowstart(tp) ? -1 : tp->snd_ssthresh)
-- 
2.35.1.1094.g7c7d902a7c-goog

