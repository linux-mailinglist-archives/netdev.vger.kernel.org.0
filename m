Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCEF416753
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 23:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243265AbhIWVTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 17:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243174AbhIWVTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 17:19:24 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93C5C061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 14:17:52 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mv7-20020a17090b198700b0019c843e7233so5798554pjb.4
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 14:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CoGqnc71bIzTRMAscp0HDPzEwuydiwhP+OmpAS43Y2E=;
        b=XERv7qnlosdlJPBo1fAzrqDymqC7t3yXmgtZBAOk8FJ73S/7+tA5yzlso4ACSrXeDf
         7NjEIGHIg6JAFMT+v01at7I/5mcbSe1j3VSI6S5BK7WQL5VJtEoORVbjb3mNKlZefpUN
         iVzibHqytQvBDn/ne+kUn0Zo3OJmMPp95KxhR+rARd/M6920CqjHRmuErvTRQ2CXFChg
         9ZG4xsm92eaVt2EVgFqrH7x2uEZL7IR4chQ49kxjpIurkxYk2R1QIOvwL3h7iruScQ0i
         G7TnS/BcURBbzZkFv8OXhb+XvZSnZYG/2F0EG/r2F0G15dJSyJr/qbCpctRTIcPFqWBa
         mgGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CoGqnc71bIzTRMAscp0HDPzEwuydiwhP+OmpAS43Y2E=;
        b=y5sf9libZbbXqD7FNCr/BMCf0Rdrb1FN8GuMvdtVN6aSJq6e7oTNsKCXZ8jz7nswUS
         G7bNpFNfa8KrggcEaKL/cz6rQK7dW2BGfT347WgW/yuVG4DETmEbdTBbYlJEZLHeL3EQ
         y7BxSg0pthGah2JqrqMWI3N/huiyiywjvOW/mxdSQBSUnSi2y9+xASx/HELnsL0lAE7X
         O4PogD1kS7uYL4/6W28jKYA5FGWFfPrddDJcPqthg9GhvttODkDANu3PQf16JavER0YR
         b0zrjikVMjipf3Cr5n7qEv2NXXTQ/b+brCo5GuGziBprHR7gdyHOXJMn5du5JELRRchQ
         Rlyg==
X-Gm-Message-State: AOAM531bT7I6/M8VXmSnAguntbjPMNlN3h0cBYmSn2iPyRbPZGa30OO8
        nZOzFeZibReNVa30rPcJ3cM=
X-Google-Smtp-Source: ABdhPJzhML5NIOPszbG+RKOcBUYt0+815sWe1Pal6WjLoGwxZ2+Y+6yxkoVVM2TFZfVTjrJio1qJhA==
X-Received: by 2002:a17:90a:734a:: with SMTP id j10mr7722700pjs.14.1632431872303;
        Thu, 23 Sep 2021 14:17:52 -0700 (PDT)
Received: from lukehsiao.c.googlers.com.com (190.40.105.34.bc.googleusercontent.com. [34.105.40.190])
        by smtp.gmail.com with ESMTPSA id e12sm4003405pgv.82.2021.09.23.14.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 14:17:51 -0700 (PDT)
From:   Luke Hsiao <luke.w.hsiao@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Luke Hsiao <lukehsiao@google.com>
Subject: [PATCH net-next] tcp: tracking packets with CE marks in BW rate sample
Date:   Thu, 23 Sep 2021 21:17:07 +0000
Message-Id: <20210923211706.2553282-1-luke.w.hsiao@gmail.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>

In order to track CE marks per rate sample (one round trip), TCP needs a
per-skb header field to record the tp->delivered_ce count when the skb
was sent. To make space, we replace the "last_in_flight" field which is
used exclusively for NV congestion control. The stat needed by NV can be
alternatively approximated by existing stats tcp_sock delivered and
mss_cache.

This patch counts the number of packets delivered which have CE marks in
the rate sample, using similar approach of delivery accounting.

Cc: Lawrence Brakmo <brakmo@fb.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Luke Hsiao <lukehsiao@google.com>
---
 include/net/tcp.h     |  9 ++++++---
 net/ipv4/tcp_input.c  | 11 +++++------
 net/ipv4/tcp_output.c |  2 --
 net/ipv4/tcp_rate.c   |  6 ++++++
 4 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 673c3b01e287..32cf6c01f403 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -874,10 +874,11 @@ struct tcp_skb_cb {
 	__u32		ack_seq;	/* Sequence number ACK'd	*/
 	union {
 		struct {
+#define TCPCB_DELIVERED_CE_MASK ((1U<<20) - 1)
 			/* There is space for up to 24 bytes */
-			__u32 in_flight:30,/* Bytes in flight at transmit */
-			      is_app_limited:1, /* cwnd not fully used? */
-			      unused:1;
+			__u32 is_app_limited:1, /* cwnd not fully used? */
+			      delivered_ce:20,
+			      unused:11;
 			/* pkts S/ACKed so far upon tx of skb, incl retrans: */
 			__u32 delivered;
 			/* start of send pipeline phase */
@@ -1029,7 +1030,9 @@ struct ack_sample {
 struct rate_sample {
 	u64  prior_mstamp; /* starting timestamp for interval */
 	u32  prior_delivered;	/* tp->delivered at "prior_mstamp" */
+	u32  prior_delivered_ce;/* tp->delivered_ce at "prior_mstamp" */
 	s32  delivered;		/* number of packets delivered over interval */
+	s32  delivered_ce;	/* number of packets delivered w/ CE marks*/
 	long interval_us;	/* time for tp->delivered to incr "delivered" */
 	u32 snd_interval_us;	/* snd interval for delivered packets */
 	u32 rcv_interval_us;	/* rcv interval for delivered packets */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 141e85e6422b..53675e284841 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3221,7 +3221,6 @@ static int tcp_clean_rtx_queue(struct sock *sk, const struct sk_buff *ack_skb,
 	long seq_rtt_us = -1L;
 	long ca_rtt_us = -1L;
 	u32 pkts_acked = 0;
-	u32 last_in_flight = 0;
 	bool rtt_update;
 	int flag = 0;
 
@@ -3257,7 +3256,6 @@ static int tcp_clean_rtx_queue(struct sock *sk, const struct sk_buff *ack_skb,
 			if (!first_ackt)
 				first_ackt = last_ackt;
 
-			last_in_flight = TCP_SKB_CB(skb)->tx.in_flight;
 			if (before(start_seq, reord))
 				reord = start_seq;
 			if (!after(scb->end_seq, tp->high_seq))
@@ -3323,8 +3321,8 @@ static int tcp_clean_rtx_queue(struct sock *sk, const struct sk_buff *ack_skb,
 		seq_rtt_us = tcp_stamp_us_delta(tp->tcp_mstamp, first_ackt);
 		ca_rtt_us = tcp_stamp_us_delta(tp->tcp_mstamp, last_ackt);
 
-		if (pkts_acked == 1 && last_in_flight < tp->mss_cache &&
-		    last_in_flight && !prior_sacked && fully_acked &&
+		if (pkts_acked == 1 && fully_acked && !prior_sacked &&
+		    (tp->snd_una - prior_snd_una) < tp->mss_cache &&
 		    sack->rate->prior_delivered + 1 == tp->delivered &&
 		    !(flag & (FLAG_CA_ALERT | FLAG_SYN_ACKED))) {
 			/* Conservatively mark a delayed ACK. It's typically
@@ -3381,9 +3379,10 @@ static int tcp_clean_rtx_queue(struct sock *sk, const struct sk_buff *ack_skb,
 
 	if (icsk->icsk_ca_ops->pkts_acked) {
 		struct ack_sample sample = { .pkts_acked = pkts_acked,
-					     .rtt_us = sack->rate->rtt_us,
-					     .in_flight = last_in_flight };
+					     .rtt_us = sack->rate->rtt_us };
 
+		sample.in_flight = tp->mss_cache *
+			(tp->delivered - sack->rate->prior_delivered);
 		icsk->icsk_ca_ops->pkts_acked(sk, &sample);
 	}
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6d72f3ea48c4..fdc39b4fbbfa 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1256,8 +1256,6 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 	tp->tcp_wstamp_ns = max(tp->tcp_wstamp_ns, tp->tcp_clock_cache);
 	skb->skb_mstamp_ns = tp->tcp_wstamp_ns;
 	if (clone_it) {
-		TCP_SKB_CB(skb)->tx.in_flight = TCP_SKB_CB(skb)->end_seq
-			- tp->snd_una;
 		oskb = skb;
 
 		tcp_skb_tsorted_save(oskb) {
diff --git a/net/ipv4/tcp_rate.c b/net/ipv4/tcp_rate.c
index 0de693565963..fbab921670cc 100644
--- a/net/ipv4/tcp_rate.c
+++ b/net/ipv4/tcp_rate.c
@@ -65,6 +65,7 @@ void tcp_rate_skb_sent(struct sock *sk, struct sk_buff *skb)
 	TCP_SKB_CB(skb)->tx.first_tx_mstamp	= tp->first_tx_mstamp;
 	TCP_SKB_CB(skb)->tx.delivered_mstamp	= tp->delivered_mstamp;
 	TCP_SKB_CB(skb)->tx.delivered		= tp->delivered;
+	TCP_SKB_CB(skb)->tx.delivered_ce	= tp->delivered_ce;
 	TCP_SKB_CB(skb)->tx.is_app_limited	= tp->app_limited ? 1 : 0;
 }
 
@@ -86,6 +87,7 @@ void tcp_rate_skb_delivered(struct sock *sk, struct sk_buff *skb,
 
 	if (!rs->prior_delivered ||
 	    after(scb->tx.delivered, rs->prior_delivered)) {
+		rs->prior_delivered_ce  = scb->tx.delivered_ce;
 		rs->prior_delivered  = scb->tx.delivered;
 		rs->prior_mstamp     = scb->tx.delivered_mstamp;
 		rs->is_app_limited   = scb->tx.is_app_limited;
@@ -138,6 +140,10 @@ void tcp_rate_gen(struct sock *sk, u32 delivered, u32 lost,
 	}
 	rs->delivered   = tp->delivered - rs->prior_delivered;
 
+	rs->delivered_ce = tp->delivered_ce - rs->prior_delivered_ce;
+	/* delivered_ce occupies less than 32 bits in the skb control block */
+	rs->delivered_ce &= TCPCB_DELIVERED_CE_MASK;
+
 	/* Model sending data and receiving ACKs as separate pipeline phases
 	 * for a window. Usually the ACK phase is longer, but with ACK
 	 * compression the send phase can be longer. To be safe we use the
-- 
2.33.0.685.g46640cef36-goog

