Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3008522B64A
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 21:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbgGWTAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 15:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbgGWTAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 15:00:12 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31729C0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 12:00:12 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id em19so4208362qvb.14
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 12:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=PwLQhft3gPmqJgkEC8yiC1UARhoKixQoFK9ZHLB+OsI=;
        b=KdhPY4PBcHVA3mf4JsTUsIQUGE+LGyv+X21HqUOTZayaNQpkGCQeXd+MaW2kKqyw3S
         QmfOKMd9PPv8jvAO+MBLk+Xc8BEq8rTYB5WJv9FqpQSBL/zfdwCI32/rkxlN4BVbhBkl
         bgYNZnFZUyDBk0b2rWx8wzcFecA3vnnP6gZGLHx3ooDIQnJmHXnf59rtZIwepG11OiSi
         YEnS5hcV/qtbxxC9OcjuZCQvZXfetRpUlSAnHgoOyTiF4hu7OYP6kCkrLQfb4iij7vMV
         trmUSY8yiCB2Lccqw7KE+YZz4ck6Mmn2jIpsqfgOjAPbdvliHVfGhi3LXaoa6KqHSldB
         RMCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=PwLQhft3gPmqJgkEC8yiC1UARhoKixQoFK9ZHLB+OsI=;
        b=E/IUW24Ed5i/dXeKpJh+113hSipQs+yUKSZH6HT9ko1hlXc6w0a5lozsq9o66xxlkW
         HHy8GoCqHbNexRLSTlmtbEGAsmwA/A0M6pOl9d0W9DpZ98Ju9VcBmFK1YYIvgU0JNbYn
         QTFFxQg5J1wuHoXVXrh0fHYDxPgLdz7zF+aBg8lHJn0VbzrVBkix+0cZz8YKvMWrIHAV
         5xMed7c8rg0YfXfy7mMluvQFLoi+EhqMhhCWMa+9JJVFvCtl/6qrkLGQGFmQ4NkXyo6M
         8+/3yWYsJJJBaX4Pfm9yZ8LtL5d5OX0GY3VPlzjJd2nnCFL8yL+UdUlD1R4+FSLShkhW
         m+EA==
X-Gm-Message-State: AOAM530KEpMgOGAvaBpL9zz/bsSpKL0eqxnffc5uSPaAUoRlU/huaV3c
        coEmhWLQw/Pr2yYLXO14ehDJE3mtwks=
X-Google-Smtp-Source: ABdhPJyKI0TugAyzBnWRZnd2c3mgsPfe5EYK8fMphMOdRfHQYWqcZqm2obunphQLz5tS8H2uPGecX2ZLC9s=
X-Received: by 2002:a0c:b284:: with SMTP id r4mr6138120qve.141.1595530811286;
 Thu, 23 Jul 2020 12:00:11 -0700 (PDT)
Date:   Thu, 23 Jul 2020 12:00:06 -0700
Message-Id: <20200723190006.1687271-1-ycheng@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH net] tcp: allow at most one TLP probe per flight
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, ncardwell@google.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously TLP may send multiple probes of new data in one
flight. This happens when the sender is cwnd limited. After the
initial TLP containing new data is sent, the sender receives another
ACK that acks partial inflight.  It may re-arm another TLP timer
to send more, if no further ACK returns before the next TLP timeout
(PTO) expires. The sender may send in theory a large amount of TLP
until send queue is depleted. This only happens if the sender sees
such irregular uncommon ACK pattern. But it is generally undesirable
behavior during congestion especially.

The original TLP design restrict only one TLP probe per inflight as
published in "Reducing Web Latency: the Virtue of Gentle Aggression",
SIGCOMM 2013. This patch changes TLP to send at most one probe
per inflight.

Note that if the sender is app-limited, TLP retransmits old data
and did not have this issue.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/tcp.h   |  6 ++++--
 net/ipv4/tcp_input.c  | 11 ++++++-----
 net/ipv4/tcp_output.c | 13 ++++++++-----
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 9aac824c523c..a1bbaa1c1a3a 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -220,7 +220,9 @@ struct tcp_sock {
 	} rack;
 	u16	advmss;		/* Advertised MSS			*/
 	u8	compressed_ack;
-	u8	dup_ack_counter;
+	u8	dup_ack_counter:2,
+		tlp_retrans:1,	/* TLP is a retransmission */
+		unused:5;
 	u32	chrono_start;	/* Start time in jiffies of a TCP chrono */
 	u32	chrono_stat[3];	/* Time in jiffies for chrono_stat stats */
 	u8	chrono_type:2,	/* current chronograph type */
@@ -243,7 +245,7 @@ struct tcp_sock {
 		save_syn:1,	/* Save headers of SYN packet */
 		is_cwnd_limited:1,/* forward progress limited by snd_cwnd? */
 		syn_smc:1;	/* SYN includes SMC */
-	u32	tlp_high_seq;	/* snd_nxt at the time of TLP retransmit. */
+	u32	tlp_high_seq;	/* snd_nxt at the time of TLP */
 
 	u32	tcp_tx_delay;	/* delay (in usec) added to TX packets */
 	u64	tcp_wstamp_ns;	/* departure time for next sent data packet */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 9615e72656d1..518f04355fbf 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3488,10 +3488,8 @@ static void tcp_replace_ts_recent(struct tcp_sock *tp, u32 seq)
 	}
 }
 
-/* This routine deals with acks during a TLP episode.
- * We mark the end of a TLP episode on receiving TLP dupack or when
- * ack is after tlp_high_seq.
- * Ref: loss detection algorithm in draft-dukkipati-tcpm-tcp-loss-probe.
+/* This routine deals with acks during a TLP episode and ends an episode by
+ * resetting tlp_high_seq. Ref: TLP algorithm in draft-ietf-tcpm-rack
  */
 static void tcp_process_tlp_ack(struct sock *sk, u32 ack, int flag)
 {
@@ -3500,7 +3498,10 @@ static void tcp_process_tlp_ack(struct sock *sk, u32 ack, int flag)
 	if (before(ack, tp->tlp_high_seq))
 		return;
 
-	if (flag & FLAG_DSACKING_ACK) {
+	if (!tp->tlp_retrans) {
+		/* TLP of new data has been acknowledged */
+		tp->tlp_high_seq = 0;
+	} else if (flag & FLAG_DSACKING_ACK) {
 		/* This DSACK means original and TLP probe arrived; no loss */
 		tp->tlp_high_seq = 0;
 	} else if (after(ack, tp->tlp_high_seq)) {
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 5f5b2f0b0e60..0bc05d68cd74 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2624,6 +2624,11 @@ void tcp_send_loss_probe(struct sock *sk)
 	int pcount;
 	int mss = tcp_current_mss(sk);
 
+	/* At most one outstanding TLP */
+	if (tp->tlp_high_seq)
+		goto rearm_timer;
+
+	tp->tlp_retrans = 0;
 	skb = tcp_send_head(sk);
 	if (skb && tcp_snd_wnd_test(tp, skb, mss)) {
 		pcount = tp->packets_out;
@@ -2641,10 +2646,6 @@ void tcp_send_loss_probe(struct sock *sk)
 		return;
 	}
 
-	/* At most one outstanding TLP retransmission. */
-	if (tp->tlp_high_seq)
-		goto rearm_timer;
-
 	if (skb_still_in_host_queue(sk, skb))
 		goto rearm_timer;
 
@@ -2666,10 +2667,12 @@ void tcp_send_loss_probe(struct sock *sk)
 	if (__tcp_retransmit_skb(sk, skb, 1))
 		goto rearm_timer;
 
+	tp->tlp_retrans = 1;
+
+probe_sent:
 	/* Record snd_nxt for loss detection. */
 	tp->tlp_high_seq = tp->snd_nxt;
 
-probe_sent:
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPLOSSPROBES);
 	/* Reset s.t. tcp_rearm_rto will restart timer from now */
 	inet_csk(sk)->icsk_pending = 0;
-- 
2.28.0.rc0.105.gf9edc3c819-goog

