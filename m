Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF61D20BE0A
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 06:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgF0EF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 00:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgF0EF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 00:05:58 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB39C03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 21:05:58 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id i62so8082536qkd.18
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 21:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0TyWh/BFeGzVeogO4Ds2cc5UCIjRSTHn5xRKvnkGpGA=;
        b=AaCwP2FbvNbi3KJM1W2RMYxXZ7wDb4n+2i3X5sfsxamcfgQM2kWlsN+QPqW1dQ5RB+
         F2bSnlUfwwf5k5TO36LsTszw2/STHTPzJJ/EVqk8SGKxUWHAmzVdIq5PCPTnfT6G7d4h
         v5PXwy29tG9uiZ3y6MWEqcGJUOZAhf6FyOvfPL7LqXmdsZgVt4kMCxc0JmceaFN8gZet
         zay5130geWl6WLoBdaYVYF7imjoOTRnXwCdvgQ+L3X6LDv8p2EAagM66FDVtH1cgO72i
         O6gkEeqs4jO26p0thJu9hs/srdsVtMTyycyA9rtrotydC09wKrzvqRipkvHFYNCZpSVn
         RqrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0TyWh/BFeGzVeogO4Ds2cc5UCIjRSTHn5xRKvnkGpGA=;
        b=SMhN39lKHG9npUKmZvCRq4ZIZLVqJ+Bc2tC8FzfRqxfVfXCNw7UCl6NELU/y9bxPK7
         uthdU4LDgBY7+SWk7p10nrfDSVYsXeHJvwYpPeOVXt43bKU3DvcZ5NTiAChIwQ/3b0IW
         an1H9iaCpphhdGYLZcev3rQA5o/up/E3Ics76eoj4jqgnpQZYL5MOPLi9+jgtDkL1kPo
         svgETTXmnhoHleNBdnfjA5NK4am4MgE1Hk0dE5ihwBmjcprJ106p6N/4gx1dhXR8ldxM
         tyHkfBxmxVoiYdH8i7XmriBQm54KoZW5bmoxQeNYurb6Zz6SQetIqiqHsFjlZkNcirYl
         DoeA==
X-Gm-Message-State: AOAM530OPYRMT35tqZtrOF0nF3WScHOlRjNIL2MM62IB4AL3TaW7215d
        X58KH5f1Xek3UauDLLvrZS+EMgEcEE9O
X-Google-Smtp-Source: ABdhPJycGOVDW7TUFCE2AVb6Py4MnPeg6PCi4SoJLx4Wz5Bkx56sPSr5fopufOGOfwXfyr1kOZfK+oCk3kKF
X-Received: by 2002:a0c:f691:: with SMTP id p17mr6321862qvn.157.1593230757327;
 Fri, 26 Jun 2020 21:05:57 -0700 (PDT)
Date:   Fri, 26 Jun 2020 21:05:33 -0700
In-Reply-To: <20200627040535.858564-1-ysseung@google.com>
Message-Id: <20200627040535.858564-3-ysseung@google.com>
Mime-Version: 1.0
References: <20200627040535.858564-1-ysseung@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH net-next 2/4] tcp: add ece_ack flag to reno sack functions
From:   Yousuk Seung <ysseung@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Yousuk Seung <ysseung@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass a boolean flag that tells the ECE state of the current ack to reno
sack functions. This is pure refactor for future patches to improve
tracking delivered counts.

Signed-off-by: Yousuk Seung <ysseung@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 net/ipv4/tcp_input.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 2a683e785cca..09bed29e3ef4 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1893,7 +1893,7 @@ static void tcp_check_reno_reordering(struct sock *sk, const int addend)
 
 /* Emulate SACKs for SACKless connection: account for a new dupack. */
 
-static void tcp_add_reno_sack(struct sock *sk, int num_dupack)
+static void tcp_add_reno_sack(struct sock *sk, int num_dupack, bool ece_ack)
 {
 	if (num_dupack) {
 		struct tcp_sock *tp = tcp_sk(sk);
@@ -1911,7 +1911,7 @@ static void tcp_add_reno_sack(struct sock *sk, int num_dupack)
 
 /* Account for ACK, ACKing some data in Reno Recovery phase. */
 
-static void tcp_remove_reno_sacks(struct sock *sk, int acked)
+static void tcp_remove_reno_sacks(struct sock *sk, int acked, bool ece_ack)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
@@ -2697,7 +2697,7 @@ static void tcp_process_loss(struct sock *sk, int flag, int num_dupack,
 		 * delivered. Lower inflight to clock out (re)tranmissions.
 		 */
 		if (after(tp->snd_nxt, tp->high_seq) && num_dupack)
-			tcp_add_reno_sack(sk, num_dupack);
+			tcp_add_reno_sack(sk, num_dupack, flag & FLAG_ECE);
 		else if (flag & FLAG_SND_UNA_ADVANCED)
 			tcp_reset_reno_sack(tp);
 	}
@@ -2779,6 +2779,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	int fast_rexmit = 0, flag = *ack_flag;
+	bool ece_ack = flag & FLAG_ECE;
 	bool do_lost = num_dupack || ((flag & FLAG_DATA_SACKED) &&
 				      tcp_force_fast_retransmit(sk));
 
@@ -2787,7 +2788,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 
 	/* Now state machine starts.
 	 * A. ECE, hence prohibit cwnd undoing, the reduction is required. */
-	if (flag & FLAG_ECE)
+	if (ece_ack)
 		tp->prior_ssthresh = 0;
 
 	/* B. In all the states check for reneging SACKs. */
@@ -2828,7 +2829,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 	case TCP_CA_Recovery:
 		if (!(flag & FLAG_SND_UNA_ADVANCED)) {
 			if (tcp_is_reno(tp))
-				tcp_add_reno_sack(sk, num_dupack);
+				tcp_add_reno_sack(sk, num_dupack, ece_ack);
 		} else {
 			if (tcp_try_undo_partial(sk, prior_snd_una))
 				return;
@@ -2853,7 +2854,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 		if (tcp_is_reno(tp)) {
 			if (flag & FLAG_SND_UNA_ADVANCED)
 				tcp_reset_reno_sack(tp);
-			tcp_add_reno_sack(sk, num_dupack);
+			tcp_add_reno_sack(sk, num_dupack, ece_ack);
 		}
 
 		if (icsk->icsk_ca_state <= TCP_CA_Disorder)
@@ -2877,7 +2878,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 		}
 
 		/* Otherwise enter Recovery state */
-		tcp_enter_recovery(sk, (flag & FLAG_ECE));
+		tcp_enter_recovery(sk, ece_ack);
 		fast_rexmit = 1;
 	}
 
@@ -3053,7 +3054,7 @@ static void tcp_ack_tstamp(struct sock *sk, struct sk_buff *skb,
  */
 static int tcp_clean_rtx_queue(struct sock *sk, u32 prior_fack,
 			       u32 prior_snd_una,
-			       struct tcp_sacktag_state *sack)
+			       struct tcp_sacktag_state *sack, bool ece_ack)
 {
 	const struct inet_connection_sock *icsk = inet_csk(sk);
 	u64 first_ackt, last_ackt;
@@ -3191,7 +3192,7 @@ static int tcp_clean_rtx_queue(struct sock *sk, u32 prior_fack,
 		}
 
 		if (tcp_is_reno(tp)) {
-			tcp_remove_reno_sacks(sk, pkts_acked);
+			tcp_remove_reno_sacks(sk, pkts_acked, ece_ack);
 
 			/* If any of the cumulatively ACKed segments was
 			 * retransmitted, non-SACK case cannot confirm that
@@ -3685,7 +3686,8 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 		goto no_queue;
 
 	/* See if we can take anything off of the retransmit queue. */
-	flag |= tcp_clean_rtx_queue(sk, prior_fack, prior_snd_una, &sack_state);
+	flag |= tcp_clean_rtx_queue(sk, prior_fack, prior_snd_una, &sack_state,
+				    flag & FLAG_ECE);
 
 	tcp_rack_update_reo_wnd(sk, &rs);
 
-- 
2.27.0.212.ge8ba1cc988-goog

