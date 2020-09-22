Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F45C27491B
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 21:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgIVT2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 15:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgIVT2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 15:28:21 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435BCC061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 12:28:21 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 34so12777950pgo.13
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 12:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zqOGYQ68XVYhrL0PtN5XdTVOnGkL7sLHCaFIwBHcIu0=;
        b=QJo6TPdCmtEfunCz/9CJ3UkgCFgKVZ3ZKk8bbZQrvCwlhsAt5NMxLSAtjSkW7xPqVt
         WXsVfWfoj+wG94xflr9P7jRfvNkJOzxbAM/kgtwWpIvc/mxU4zEkjH2vu2LgcgxTrOKf
         qucHYZVYzu3nmU8akrMYMkd4yImmfHUbkEkXOVw7GMbDmzcOqJrCcwjpX7hE7xFjucTr
         bJMFv0kX99j2Hy0JgSvGsGP8XE4Ki5m63yz/FIb23eNbWZY4tVrdZ7blESXhI0tV/SlD
         cTfWB7+vDSKWMNwr60bvQ1hr9gqJjf34AfA7lIzVRsN3WwDfW4dX8TQuK1T7P33xFE3d
         SChg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zqOGYQ68XVYhrL0PtN5XdTVOnGkL7sLHCaFIwBHcIu0=;
        b=fqUswILqNrZVBZseuLVGXs1p8atu+I4A0HYLUtE/84XR8VQjlUVSyrESTaBpB5tv4V
         tPJygA1pp2fAjrOZ0TexEIXxBJ7+GnrtD7Hg3sqNAWLLaJNGASX1xVB6G7Gr58P7kh1u
         2ycDYCOTsZYfvmw5YTb6BDaBnMDVvY0cj50c72XG2reUYVFgViQMsMdODlfcmJwOFZXQ
         MEwzNwY38w13qCOGYkkeG4IC8iW8rshZFkvwc1SFP076sgKq6n4JFSunntSA1AZAJLxk
         vlC7g3yJD2Dulqi0g2D+knsDhzQRwabUpzFkXpSUf82X0LsMFUYFpSLvNiix1FgnwiKN
         YfnA==
X-Gm-Message-State: AOAM53023AC1HnTBPGbZhLBGJbozZWOjmZp2i2UwaUCGe21S8+KI4s1u
        l6rxKXS0MfBpPeYQNkPmpPk=
X-Google-Smtp-Source: ABdhPJzLwV+zWLeuXrwXJoTTAnk31TYlV/1gEk6/IEhs+n7NdgTmWbC+muJsceWsZAzXcpLb1epTEA==
X-Received: by 2002:a63:78b:: with SMTP id 133mr882725pgh.381.1600802900743;
        Tue, 22 Sep 2020 12:28:20 -0700 (PDT)
Received: from priyarjha.svl.corp.google.com ([2620:15c:2c4:201:a28c:fdff:fee3:2bbe])
        by smtp.gmail.com with ESMTPSA id 126sm16108245pfg.192.2020.09.22.12.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 12:28:20 -0700 (PDT)
From:   Priyaranjan Jha <priyarjha.kernel@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, gregkh@linuxfoundation.org,
        Priyaranjan Jha <priyarjha@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: [PATCH linux-4.19.y 1/2] tcp_bbr: refactor bbr_target_cwnd() for general inflight provisioning
Date:   Tue, 22 Sep 2020 12:27:34 -0700
Message-Id: <20200922192735.3976618-2-priyarjha.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
In-Reply-To: <20200922192735.3976618-1-priyarjha.kernel@gmail.com>
References: <20200922192735.3976618-1-priyarjha.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Priyaranjan Jha <priyarjha@google.com>

commit 232aa8ec3ed979d4716891540c03a806ecab0c37 upstream.

Because bbr_target_cwnd() is really a general-purpose BBR helper for
computing some volume of inflight data as a function of the estimated
BDP, refactor it into following helper functions:
- bbr_bdp()
- bbr_quantization_budget()
- bbr_inflight()

Signed-off-by: Priyaranjan Jha <priyarjha@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/tcp_bbr.c | 60 ++++++++++++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 21 deletions(-)

diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index b371e66502c3..4ee6cf1235f7 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -315,30 +315,19 @@ static void bbr_cwnd_event(struct sock *sk, enum tcp_ca_event event)
 	}
 }
 
-/* Find target cwnd. Right-size the cwnd based on min RTT and the
- * estimated bottleneck bandwidth:
+/* Calculate bdp based on min RTT and the estimated bottleneck bandwidth:
  *
- * cwnd = bw * min_rtt * gain = BDP * gain
+ * bdp = bw * min_rtt * gain
  *
  * The key factor, gain, controls the amount of queue. While a small gain
  * builds a smaller queue, it becomes more vulnerable to noise in RTT
  * measurements (e.g., delayed ACKs or other ACK compression effects). This
  * noise may cause BBR to under-estimate the rate.
- *
- * To achieve full performance in high-speed paths, we budget enough cwnd to
- * fit full-sized skbs in-flight on both end hosts to fully utilize the path:
- *   - one skb in sending host Qdisc,
- *   - one skb in sending host TSO/GSO engine
- *   - one skb being received by receiver host LRO/GRO/delayed-ACK engine
- * Don't worry, at low rates (bbr_min_tso_rate) this won't bloat cwnd because
- * in such cases tso_segs_goal is 1. The minimum cwnd is 4 packets,
- * which allows 2 outstanding 2-packet sequences, to try to keep pipe
- * full even with ACK-every-other-packet delayed ACKs.
  */
-static u32 bbr_target_cwnd(struct sock *sk, u32 bw, int gain)
+static u32 bbr_bdp(struct sock *sk, u32 bw, int gain)
 {
 	struct bbr *bbr = inet_csk_ca(sk);
-	u32 cwnd;
+	u32 bdp;
 	u64 w;
 
 	/* If we've never had a valid RTT sample, cap cwnd at the initial
@@ -353,7 +342,24 @@ static u32 bbr_target_cwnd(struct sock *sk, u32 bw, int gain)
 	w = (u64)bw * bbr->min_rtt_us;
 
 	/* Apply a gain to the given value, then remove the BW_SCALE shift. */
-	cwnd = (((w * gain) >> BBR_SCALE) + BW_UNIT - 1) / BW_UNIT;
+	bdp = (((w * gain) >> BBR_SCALE) + BW_UNIT - 1) / BW_UNIT;
+
+	return bdp;
+}
+
+/* To achieve full performance in high-speed paths, we budget enough cwnd to
+ * fit full-sized skbs in-flight on both end hosts to fully utilize the path:
+ *   - one skb in sending host Qdisc,
+ *   - one skb in sending host TSO/GSO engine
+ *   - one skb being received by receiver host LRO/GRO/delayed-ACK engine
+ * Don't worry, at low rates (bbr_min_tso_rate) this won't bloat cwnd because
+ * in such cases tso_segs_goal is 1. The minimum cwnd is 4 packets,
+ * which allows 2 outstanding 2-packet sequences, to try to keep pipe
+ * full even with ACK-every-other-packet delayed ACKs.
+ */
+static u32 bbr_quantization_budget(struct sock *sk, u32 cwnd, int gain)
+{
+	struct bbr *bbr = inet_csk_ca(sk);
 
 	/* Allow enough full-sized skbs in flight to utilize end systems. */
 	cwnd += 3 * bbr_tso_segs_goal(sk);
@@ -368,6 +374,17 @@ static u32 bbr_target_cwnd(struct sock *sk, u32 bw, int gain)
 	return cwnd;
 }
 
+/* Find inflight based on min RTT and the estimated bottleneck bandwidth. */
+static u32 bbr_inflight(struct sock *sk, u32 bw, int gain)
+{
+	u32 inflight;
+
+	inflight = bbr_bdp(sk, bw, gain);
+	inflight = bbr_quantization_budget(sk, inflight, gain);
+
+	return inflight;
+}
+
 /* An optimization in BBR to reduce losses: On the first round of recovery, we
  * follow the packet conservation principle: send P packets per P packets acked.
  * After that, we slow-start and send at most 2*P packets per P packets acked.
@@ -429,7 +446,8 @@ static void bbr_set_cwnd(struct sock *sk, const struct rate_sample *rs,
 		goto done;
 
 	/* If we're below target cwnd, slow start cwnd toward target cwnd. */
-	target_cwnd = bbr_target_cwnd(sk, bw, gain);
+	target_cwnd = bbr_bdp(sk, bw, gain);
+	target_cwnd = bbr_quantization_budget(sk, target_cwnd, gain);
 	if (bbr_full_bw_reached(sk))  /* only cut cwnd if we filled the pipe */
 		cwnd = min(cwnd + acked, target_cwnd);
 	else if (cwnd < target_cwnd || tp->delivered < TCP_INIT_CWND)
@@ -470,14 +488,14 @@ static bool bbr_is_next_cycle_phase(struct sock *sk,
 	if (bbr->pacing_gain > BBR_UNIT)
 		return is_full_length &&
 			(rs->losses ||  /* perhaps pacing_gain*BDP won't fit */
-			 inflight >= bbr_target_cwnd(sk, bw, bbr->pacing_gain));
+			 inflight >= bbr_inflight(sk, bw, bbr->pacing_gain));
 
 	/* A pacing_gain < 1.0 tries to drain extra queue we added if bw
 	 * probing didn't find more bw. If inflight falls to match BDP then we
 	 * estimate queue is drained; persisting would underutilize the pipe.
 	 */
 	return is_full_length ||
-		inflight <= bbr_target_cwnd(sk, bw, BBR_UNIT);
+		inflight <= bbr_inflight(sk, bw, BBR_UNIT);
 }
 
 static void bbr_advance_cycle_phase(struct sock *sk)
@@ -736,11 +754,11 @@ static void bbr_check_drain(struct sock *sk, const struct rate_sample *rs)
 		bbr->pacing_gain = bbr_drain_gain;	/* pace slow to drain */
 		bbr->cwnd_gain = bbr_high_gain;	/* maintain cwnd */
 		tcp_sk(sk)->snd_ssthresh =
-				bbr_target_cwnd(sk, bbr_max_bw(sk), BBR_UNIT);
+				bbr_inflight(sk, bbr_max_bw(sk), BBR_UNIT);
 	}	/* fall through to check if in-flight is already small: */
 	if (bbr->mode == BBR_DRAIN &&
 	    tcp_packets_in_flight(tcp_sk(sk)) <=
-	    bbr_target_cwnd(sk, bbr_max_bw(sk), BBR_UNIT))
+	    bbr_inflight(sk, bbr_max_bw(sk), BBR_UNIT))
 		bbr_reset_probe_bw_mode(sk);  /* we estimate queue is drained */
 }
 
-- 
2.28.0.681.g6f77f65b4e-goog

