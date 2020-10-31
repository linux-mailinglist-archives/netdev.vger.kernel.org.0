Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C272A12B4
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 02:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgJaBeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 21:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJaBeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 21:34:18 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD70C0613D5
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 18:34:16 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id w4so7660447ybq.21
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 18:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=6Lsq6x0GEWvGUa+uad28VCNidUhN5+0wxLSeWSqdAjY=;
        b=u5L6SJTm0+Zow1HIm/fnyQLlCIf9L+w1J4uGo0rvrK+YUpFWb6JzyvONSnG66EfV7A
         j2PAl0kH2GuGoCFh21puriEgJ8YI92o9mYBLeDutQsJ8EegKGSmWAmp5VMO51A8QZlw9
         ABMWPvrxYQ62/D/rch8OkcboA3RZsPJUUCMIWUe8vWgFV114ycX6xoFuVD7ProLkWuzl
         oi9kKp/D+0NpRdPbu5IFH0T4F8Tesnjsk+JZ/SM5hcEV+jD8spzFfe2m9HdkarV1TQ+6
         uJ+4NvW6GAgpN8+BAEg+VyF5cH0MY20+7Ds5Q1DYzp2WZs6+9g7x0Ur21ESEMRFHKPXX
         Ooxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=6Lsq6x0GEWvGUa+uad28VCNidUhN5+0wxLSeWSqdAjY=;
        b=JrFBCQN4KIag/fTzsdUdtsPwalPE5zrPFs+TaXZ8DbFhHBSpXnyhuf9wsIUsMNvl5f
         4GnD7BfYayGspYJtzIqa0eNa7IDqUPbA0PgRdKBT6xXFqz2MSGd7zthRMTAJragHaKQc
         OE8o0vMTEpxhikloQhD5k6NOo4++FLeiZ3BjLO0VjkuY9hK08q1ofbQP6lts24uBRqv/
         Z1e71OKpu3PdU1ryJOn1Dz9b7vH1Whu+gSes0FjI6ZK33ZbhNKEwbz4CYx1DldfbwcKJ
         TZEDaWIe4SzfoZNJOprLfqtgoSX/Y0qOwW0j4k9Vj0dtc8lDkEQO1fIYmncWZj8+pRwZ
         8hAA==
X-Gm-Message-State: AOAM533mLGbDS31HEmdhmUD17wtagBF3Ih2SBBbFNgTigzfK5c20L7h3
        y5yaAzUu5WHL8JVQGqo5cS3T4f++gO0=
X-Google-Smtp-Source: ABdhPJySi01mu/IiovXvShLnvxxAEeCti2GKF/voFA5qF26DjcxuffAV+ybhfvsci/ePyNA+G8XlyQQjA/8=
Sender: "ycheng via sendgmr" <ycheng@ycheng.svl.corp.google.com>
X-Received: from ycheng.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:fef4:fc76])
 (user=ycheng job=sendgmr) by 2002:a25:e80f:: with SMTP id k15mr6547108ybd.424.1604108055991;
 Fri, 30 Oct 2020 18:34:15 -0700 (PDT)
Date:   Fri, 30 Oct 2020 18:34:12 -0700
Message-Id: <20201031013412.1973112-1-ycheng@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
Subject: [PATCH net-next] tcp: avoid slow start during fast recovery on new losses
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, ncardwell@google.com,
        nanditad@google.com, Yuchung Cheng <ycheng@google.com>,
        Matt Mathis <mattmathis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During TCP fast recovery, the congestion control in charge is by
default the Proportional Rate Reduction (PRR) unless the congestion
control module specified otherwise (e.g. BBR).

Previously when tcp_packets_in_flight() is below snd_ssthresh PRR
would slow start upon receiving an ACK that
   1) cumulatively acknowledges retransmitted data
   and
   2) does not detect further lost retransmission

Such conditions indicate the repair is in good steady progress
after the first round trip of recovery. Otherwise PRR adopts the
packet conservation principle to send only the amount that was
newly delivered (indicated by this ACK).

This patch generalizes the previous design principle to include
also the newly sent data beside retransmission: as long as
the delivery is making good progress, both retransmission and
new data should be accounted to make PRR more cautious in slow
starting.

Suggested-by: Matt Mathis <mattmathis@google.com>
Suggested-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h       | 2 +-
 net/ipv4/tcp_input.c    | 9 ++++-----
 net/ipv4/tcp_recovery.c | 3 ++-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index d4ef5bf94168..4aba0f069b05 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -386,7 +386,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 int tcp_child_process(struct sock *parent, struct sock *child,
 		      struct sk_buff *skb);
 void tcp_enter_loss(struct sock *sk);
-void tcp_cwnd_reduction(struct sock *sk, int newly_acked_sacked, int flag);
+void tcp_cwnd_reduction(struct sock *sk, int newly_acked_sacked, int newly_lost, int flag);
 void tcp_clear_retrans(struct tcp_sock *tp);
 void tcp_update_metrics(struct sock *sk);
 void tcp_init_metrics(struct sock *sk);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 389d1b340248..fb3a7750f623 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2546,7 +2546,7 @@ static bool tcp_try_undo_loss(struct sock *sk, bool frto_undo)
  *   1) If the packets in flight is larger than ssthresh, PRR spreads the
  *	cwnd reductions across a full RTT.
  *   2) Otherwise PRR uses packet conservation to send as much as delivered.
- *      But when the retransmits are acked without further losses, PRR
+ *      But when SND_UNA is acked without further losses,
  *      slow starts cwnd up to ssthresh to speed up the recovery.
  */
 static void tcp_init_cwnd_reduction(struct sock *sk)
@@ -2563,7 +2563,7 @@ static void tcp_init_cwnd_reduction(struct sock *sk)
 	tcp_ecn_queue_cwr(tp);
 }
 
-void tcp_cwnd_reduction(struct sock *sk, int newly_acked_sacked, int flag)
+void tcp_cwnd_reduction(struct sock *sk, int newly_acked_sacked, int newly_lost, int flag)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	int sndcnt = 0;
@@ -2577,8 +2577,7 @@ void tcp_cwnd_reduction(struct sock *sk, int newly_acked_sacked, int flag)
 		u64 dividend = (u64)tp->snd_ssthresh * tp->prr_delivered +
 			       tp->prior_cwnd - 1;
 		sndcnt = div_u64(dividend, tp->prior_cwnd) - tp->prr_out;
-	} else if ((flag & (FLAG_RETRANS_DATA_ACKED | FLAG_LOST_RETRANS)) ==
-		   FLAG_RETRANS_DATA_ACKED) {
+	} else if (flag & FLAG_SND_UNA_ADVANCED && !newly_lost) {
 		sndcnt = min_t(int, delta,
 			       max_t(int, tp->prr_delivered - tp->prr_out,
 				     newly_acked_sacked) + 1);
@@ -3419,7 +3418,7 @@ static void tcp_cong_control(struct sock *sk, u32 ack, u32 acked_sacked,
 
 	if (tcp_in_cwnd_reduction(sk)) {
 		/* Reduce cwnd if state mandates */
-		tcp_cwnd_reduction(sk, acked_sacked, flag);
+		tcp_cwnd_reduction(sk, acked_sacked, rs->losses, flag);
 	} else if (tcp_may_raise_cwnd(sk, flag)) {
 		/* Advance cwnd if state allows */
 		tcp_cong_avoid(sk, ack, acked_sacked);
diff --git a/net/ipv4/tcp_recovery.c b/net/ipv4/tcp_recovery.c
index f65a3ddd0d58..177307a3081f 100644
--- a/net/ipv4/tcp_recovery.c
+++ b/net/ipv4/tcp_recovery.c
@@ -153,6 +153,7 @@ void tcp_rack_reo_timeout(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	u32 timeout, prior_inflight;
+	u32 lost = tp->lost;
 
 	prior_inflight = tcp_packets_in_flight(tp);
 	tcp_rack_detect_loss(sk, &timeout);
@@ -160,7 +161,7 @@ void tcp_rack_reo_timeout(struct sock *sk)
 		if (inet_csk(sk)->icsk_ca_state != TCP_CA_Recovery) {
 			tcp_enter_recovery(sk, false);
 			if (!inet_csk(sk)->icsk_ca_ops->cong_control)
-				tcp_cwnd_reduction(sk, 1, 0);
+				tcp_cwnd_reduction(sk, 1, tp->lost - lost, 0);
 		}
 		tcp_xmit_retransmit_queue(sk);
 	}
-- 
2.29.1.341.ge80a0c044ae-goog

