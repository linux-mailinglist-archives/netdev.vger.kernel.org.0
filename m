Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6B3222BA2
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 21:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbgGPTNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 15:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728374AbgGPTNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 15:13:15 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00C7C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 12:13:15 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id l12so4018195qvu.21
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 12:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=AD45KIJrGtvm/81jpHjrCF21PWqUxcvFBwihBNpamIA=;
        b=wQWW3cNg0fPXEythMMj7QAd27N6OWTh7UiVYKuAGEevrtcULD8SQf4iYzQeiNnV8Ji
         FYrCNYzuEYa4toqND3hXNzvbySPxsY94+MKutXyOtnp0WAjTut3bT0K13P4KPdy9WLNF
         I+rJXtQwZAqmc6FuqHTc4TmJ8IKv9ZJZokvqSlZx7aLJuJ/Kck8MAsuqBH+UrwbDV+tk
         /9CbIfwmbyK2Gdyd44r21++AwWfn1Jc4qgzyo5i5XVbolqEoLlwC+kmtl1mZezpfnLJC
         I4Zucf5LoZlIY9QkelkQEvMLU+KlaOzcZzCQbFZ6QlcsFOWqR5lXKSHxxHGza/at8YBP
         ON5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AD45KIJrGtvm/81jpHjrCF21PWqUxcvFBwihBNpamIA=;
        b=oHxuuk35Av5UYJy/+94QCsCTfEimEpN8fSnON64Z9hc12TwsfM+gjw3y0H+1KRyALy
         iKnQO43mZRy8QwodjGjv9ECuefGn5y+zAAQS62fc92kWdMyQEmb96TLLMSBA5rp26Ph2
         9mVgGVqRmsJTv+xW1ZDmdDeO/D55ymvgP5RSqbD/F8OGUe8/+xclhehwq0diqW2gFoym
         clssHolBTA0oB2i8iJbY+9Yq7+2yEy2YJ/5ey01Yvo4RmjPy1ea00uVmpppE42OYm92b
         Y4Va5L1YSJP+iEvGcT1CUTr46sheqYSGat/eUwI+1hgtYDCAzGfeuIhIgccUL9gkzvKx
         q32Q==
X-Gm-Message-State: AOAM531s2BF3Us4ToPMGAGREGBNkdGei2WBVvABVgNC2PwDe0x537vIF
        FHgil9XFRwGvkMmQunrIiPDvJbL3RjPkIZM=
X-Google-Smtp-Source: ABdhPJwK5noUUPE2HFyQSBoATpSYaS3ILmj/BpoLTDrSTVpyCctQTkM05QRywFPWQvfbu0xBszCmuqKeMjqJ+qE=
X-Received: by 2002:a05:6214:734:: with SMTP id c20mr5923932qvz.118.1594926794971;
 Thu, 16 Jul 2020 12:13:14 -0700 (PDT)
Date:   Thu, 16 Jul 2020 12:12:34 -0700
In-Reply-To: <20200716191235.1556723-1-priyarjha@google.com>
Message-Id: <20200716191235.1556723-2-priyarjha@google.com>
Mime-Version: 1.0
References: <20200716191235.1556723-1-priyarjha@google.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH net-next 1/2] tcp: fix segment accounting when DSACK range
 covers multiple segments
From:   Priyaranjan Jha <priyarjha@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Priyaranjan Jha <priyarjha@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Yousuk Seung <ysseung@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, while processing DSACK, we assume DSACK covers only one
segment. This leads to significant underestimation of DSACKs with
LRO/GRO. This patch fixes segment accounting with DSACK by estimating
segment count from DSACK sequence range / MSS.

Signed-off-by: Priyaranjan Jha <priyarjha@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Yousuk Seung <ysseung@google.com>
---
 net/ipv4/tcp_input.c | 80 ++++++++++++++++++++++++--------------------
 1 file changed, 44 insertions(+), 36 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index b03ca68d4111..5d6bbcb1e570 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -871,12 +871,41 @@ __u32 tcp_init_cwnd(const struct tcp_sock *tp, const struct dst_entry *dst)
 	return min_t(__u32, cwnd, tp->snd_cwnd_clamp);
 }
 
+struct tcp_sacktag_state {
+	/* Timestamps for earliest and latest never-retransmitted segment
+	 * that was SACKed. RTO needs the earliest RTT to stay conservative,
+	 * but congestion control should still get an accurate delay signal.
+	 */
+	u64	first_sackt;
+	u64	last_sackt;
+	u32	reord;
+	u32	sack_delivered;
+	int	flag;
+	unsigned int mss_now;
+	struct rate_sample *rate;
+};
+
 /* Take a notice that peer is sending D-SACKs */
-static void tcp_dsack_seen(struct tcp_sock *tp)
+static u32 tcp_dsack_seen(struct tcp_sock *tp, u32 start_seq,
+			  u32 end_seq, struct tcp_sacktag_state *state)
 {
+	u32 seq_len, dup_segs = 1;
+
+	if (before(start_seq, end_seq)) {
+		seq_len = end_seq - start_seq;
+		if (seq_len > tp->mss_cache)
+			dup_segs = DIV_ROUND_UP(seq_len, tp->mss_cache);
+	}
+
 	tp->rx_opt.sack_ok |= TCP_DSACK_SEEN;
 	tp->rack.dsack_seen = 1;
-	tp->dsack_dups++;
+	tp->dsack_dups += dup_segs;
+
+	state->flag |= FLAG_DSACKING_ACK;
+	/* A spurious retransmission is delivered */
+	state->sack_delivered += dup_segs;
+
+	return dup_segs;
 }
 
 /* It's reordering when higher sequence was delivered (i.e. sacked) before
@@ -1103,53 +1132,37 @@ static bool tcp_is_sackblock_valid(struct tcp_sock *tp, bool is_dsack,
 
 static bool tcp_check_dsack(struct sock *sk, const struct sk_buff *ack_skb,
 			    struct tcp_sack_block_wire *sp, int num_sacks,
-			    u32 prior_snd_una)
+			    u32 prior_snd_una, struct tcp_sacktag_state *state)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	u32 start_seq_0 = get_unaligned_be32(&sp[0].start_seq);
 	u32 end_seq_0 = get_unaligned_be32(&sp[0].end_seq);
-	bool dup_sack = false;
+	u32 dup_segs;
 
 	if (before(start_seq_0, TCP_SKB_CB(ack_skb)->ack_seq)) {
-		dup_sack = true;
-		tcp_dsack_seen(tp);
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPDSACKRECV);
 	} else if (num_sacks > 1) {
 		u32 end_seq_1 = get_unaligned_be32(&sp[1].end_seq);
 		u32 start_seq_1 = get_unaligned_be32(&sp[1].start_seq);
 
-		if (!after(end_seq_0, end_seq_1) &&
-		    !before(start_seq_0, start_seq_1)) {
-			dup_sack = true;
-			tcp_dsack_seen(tp);
-			NET_INC_STATS(sock_net(sk),
-					LINUX_MIB_TCPDSACKOFORECV);
-		}
+		if (after(end_seq_0, end_seq_1) || before(start_seq_0, start_seq_1))
+			return false;
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPDSACKOFORECV);
+	} else {
+		return false;
 	}
 
+	dup_segs = tcp_dsack_seen(tp, start_seq_0, end_seq_0, state);
+
 	/* D-SACK for already forgotten data... Do dumb counting. */
-	if (dup_sack && tp->undo_marker && tp->undo_retrans > 0 &&
+	if (tp->undo_marker && tp->undo_retrans > 0 &&
 	    !after(end_seq_0, prior_snd_una) &&
 	    after(end_seq_0, tp->undo_marker))
-		tp->undo_retrans--;
+		tp->undo_retrans = max_t(int, 0, tp->undo_retrans - dup_segs);
 
-	return dup_sack;
+	return true;
 }
 
-struct tcp_sacktag_state {
-	u32	reord;
-	/* Timestamps for earliest and latest never-retransmitted segment
-	 * that was SACKed. RTO needs the earliest RTT to stay conservative,
-	 * but congestion control should still get an accurate delay signal.
-	 */
-	u64	first_sackt;
-	u64	last_sackt;
-	struct rate_sample *rate;
-	int	flag;
-	unsigned int mss_now;
-	u32	sack_delivered;
-};
-
 /* Check if skb is fully within the SACK block. In presence of GSO skbs,
  * the incoming SACK may not exactly match but we can find smaller MSS
  * aligned portion of it that matches. Therefore we might need to fragment
@@ -1692,12 +1705,7 @@ tcp_sacktag_write_queue(struct sock *sk, const struct sk_buff *ack_skb,
 		tcp_highest_sack_reset(sk);
 
 	found_dup_sack = tcp_check_dsack(sk, ack_skb, sp_wire,
-					 num_sacks, prior_snd_una);
-	if (found_dup_sack) {
-		state->flag |= FLAG_DSACKING_ACK;
-		/* A spurious retransmission is delivered */
-		state->sack_delivered++;
-	}
+					 num_sacks, prior_snd_una, state);
 
 	/* Eliminate too old ACKs, but take into
 	 * account more or less fresh ones, they can
-- 
2.27.0.389.gc38d7665816-goog

