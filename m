Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42642D3960
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 05:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgLID6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 22:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgLID6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 22:58:42 -0500
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDD2C0613D6
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 19:58:02 -0800 (PST)
Received: by mail-qt1-x841.google.com with SMTP id z20so104795qtq.3
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 19:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kgZeCN3oPweOI0xBcuDAEG7obzNvbTAoiX1Vk8MgdGg=;
        b=SsOgnk9p9g4uY+VKa+Y1VIVXksaqaNxaLDfa4Y7HfWcDAndTTUhgWI713WCZAHty5V
         8q4V5OmL4UwD7D9wK158pgEV+eUOyRX7VdgKRiVe6Q8wix84UUZ5DQEfmbvVXjbMlL0R
         6xzaPkT35am4C4D3I0Dc4CfMqr18z4jkkmKJ+koRGL5/R74Mtk9QX7kJrVZZooIrlvW+
         40yKYDHpxOW9y9dPKMVatMmx59cdWx8WWZ/AelI/iu9Q+W5kL3NqhNkBlWZsd9cWJQ/u
         YfeYnOv192yhDb/jR2JBTZv5l6JLNU/WpjwXBv2piM0uwvPumxtGdmNBweM2kOByP+1d
         8qog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kgZeCN3oPweOI0xBcuDAEG7obzNvbTAoiX1Vk8MgdGg=;
        b=Z7KjNUllQIOtlEOSZGoaoPJYA4rnkk3WG741fOMTN0Yf9TzKFL7a+bz3FxVcozSuoz
         yiMbszn5h+6itBN6DQCI14uCsnw5vT47Kdz6Ej40o5VOFRoWGB5VW0u/N+Kw4BvLAr1T
         fZlJqCHkNNLyrCaOIVjztQBMIZ/gt4IFaS28qKfw/xC1WRW5X2D6YGvd/h2t/j/7BQog
         V81vKbPxO0cqkkOrqTaKPHgNqzmAIBzaQzSIHi1Hy14vOIbsolI3TQ6mjGrtA8tmV/iH
         v+58WvrIeW1D3FdxK1UQibf68Jxhxnv1E77u0aoEPRdIKzL3l7kvrYG/UEVRfYdd8UJR
         uw8w==
X-Gm-Message-State: AOAM533q49VWR+8akzYZXYecp1bPvzAfwZJr8W+hQG/dV607wD+QCSEg
        7tacw6ohaek2hchp2QcUJeI=
X-Google-Smtp-Source: ABdhPJxGmq3a3YT1/mfk888gZ8MbZ+TpJrL2IDkvdkyrQuRsPaCdwDnpGArH7+pZyyGyelns+lWIsQ==
X-Received: by 2002:aed:30c2:: with SMTP id 60mr885802qtf.86.1607486281563;
        Tue, 08 Dec 2020 19:58:01 -0800 (PST)
Received: from soy.nyc.corp.google.com ([2620:0:1003:312:7220:84ff:fe09:3008])
        by smtp.gmail.com with ESMTPSA id k128sm384077qkd.48.2020.12.08.19.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 19:58:01 -0800 (PST)
From:   Neal Cardwell <ncardwell.kernel@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Ingemar Johansson <ingemar.s.johansson@ericsson.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] tcp: fix cwnd-limited bug for TSO deferral where we send nothing
Date:   Tue,  8 Dec 2020 22:57:59 -0500
Message-Id: <20201209035759.1225145-1-ncardwell.kernel@gmail.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>

When cwnd is not a multiple of the TSO skb size of N*MSS, we can get
into persistent scenarios where we have the following sequence:

(1) ACK for full-sized skb of N*MSS arrives
  -> tcp_write_xmit() transmit full-sized skb with N*MSS
  -> move pacing release time forward
  -> exit tcp_write_xmit() because pacing time is in the future

(2) TSQ callback or TCP internal pacing timer fires
  -> try to transmit next skb, but TSO deferral finds remainder of
     available cwnd is not big enough to trigger an immediate send
     now, so we defer sending until the next ACK.

(3) repeat...

So we can get into a case where we never mark ourselves as
cwnd-limited for many seconds at a time, even with
bulk/infinite-backlog senders, because:

o In case (1) above, every time in tcp_write_xmit() we have enough
cwnd to send a full-sized skb, we are not fully using the cwnd
(because cwnd is not a multiple of the TSO skb size). So every time we
send data, we are not cwnd limited, and so in the cwnd-limited
tracking code in tcp_cwnd_validate() we mark ourselves as not
cwnd-limited.

o In case (2) above, every time in tcp_write_xmit() that we try to
transmit the "remainder" of the cwnd but defer, we set the local
variable is_cwnd_limited to true, but we do not send any packets, so
sent_pkts is zero, so we don't call the cwnd-limited logic to update
tp->is_cwnd_limited.

Fixes: ca8a22634381 ("tcp: make cwnd-limited checks measurement-based, and gentler")
Reported-by: Ingemar Johansson <ingemar.s.johansson@ericsson.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_output.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index bf48cd73e967..99011768c264 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1880,7 +1880,8 @@ static void tcp_cwnd_validate(struct sock *sk, bool is_cwnd_limited)
 	 * window, and remember whether we were cwnd-limited then.
 	 */
 	if (!before(tp->snd_una, tp->max_packets_seq) ||
-	    tp->packets_out > tp->max_packets_out) {
+	    tp->packets_out > tp->max_packets_out ||
+	    is_cwnd_limited) {
 		tp->max_packets_out = tp->packets_out;
 		tp->max_packets_seq = tp->snd_nxt;
 		tp->is_cwnd_limited = is_cwnd_limited;
@@ -2702,6 +2703,10 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
 	else
 		tcp_chrono_stop(sk, TCP_CHRONO_RWND_LIMITED);
 
+	is_cwnd_limited |= (tcp_packets_in_flight(tp) >= tp->snd_cwnd);
+	if (likely(sent_pkts || is_cwnd_limited))
+		tcp_cwnd_validate(sk, is_cwnd_limited);
+
 	if (likely(sent_pkts)) {
 		if (tcp_in_cwnd_reduction(sk))
 			tp->prr_out += sent_pkts;
@@ -2709,8 +2714,6 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
 		/* Send one loss probe per tail loss episode. */
 		if (push_one != 2)
 			tcp_schedule_loss_probe(sk, false);
-		is_cwnd_limited |= (tcp_packets_in_flight(tp) >= tp->snd_cwnd);
-		tcp_cwnd_validate(sk, is_cwnd_limited);
 		return false;
 	}
 	return !tp->packets_out && !tcp_write_queue_empty(sk);
-- 
2.29.2.576.ga3fc446d84-goog

