Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C73FBF513
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 16:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbfIZOaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 10:30:08 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:34213 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbfIZOaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 10:30:08 -0400
Received: by mail-qt1-f201.google.com with SMTP id y10so2511845qti.1
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 07:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=JtDSdiJIqNLtOWP26GaNgqVmHbxGnp05V+SB40UMfls=;
        b=UHINjKLQI7wQnF7Tj687eSC1R8hFJvUtpRV6UwdmOwI9ZSq8oebro+t69cwK8SGhfB
         K6p8goSJd2XdyvBXxmXnYh2IB5VX26owIbDTt1A+6X9K8sjsN1nO09L41n4FTgLw8Oup
         1MClGg2Cz4zmo1DhsoSdw0F1wDgc0gU7dv7Qgp+cmNgCrwiELBwh/WS7TXHVOWW+xgLR
         oyKcjfwlL/eNSU/jIs9L4PzVvEWn6nhejvsjelLxQU6pXx7wyRCf6wDy1Bd7LDbCO8f0
         JvPfWS6hUw1g1vExIAsvDoM10FLEUa+3KxQWpon9R6xmOwC3FSNeYF56evpHuTP8PmJN
         oydQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=JtDSdiJIqNLtOWP26GaNgqVmHbxGnp05V+SB40UMfls=;
        b=PdmF9+xHHi8d/V70bJhgDRR2ndLffDDxuQtyK76y0IF79e9N/8q1nGf8VUL+tOTlqR
         XZZk5h9ObNWuCr03pyppj/xOf2QGfqGRPxNHiGKO6dJpGfTp3O3Qd1rGD4CVRMTtW9D7
         NNz/Ycq0r6UN7F62U9GFa0lYI7ng0C4fGEmeJsK0vYiV4R95+C7tmMyha9ZHiVPuU9JQ
         lmZCZAPkoA5sd3tPzm4PYJrjKlCqaTnA8qnsnzlfLL1p3EaG0IlOSKqSYiEHOCrcqlkb
         h+63GGp22VQha7fGHcDgKDveZDuboiWlSlGgYg/zRXFmGgghMTBASAXCte88y8mIMaTz
         C/aA==
X-Gm-Message-State: APjAAAVlVWEx11GK1u83mFWr8YqnaZ6IDUrxqhl2YS8Pp6W2hhV0PUoz
        gRUKtQljE/gwMSCC5JmwFlQwsbo=
X-Google-Smtp-Source: APXvYqwabqgUN7IPHB7upNxNbrBMppdVmQHZgvvG5MVAxiBN5PTvOZR6Mw4bNwQhfut6+W7pvfO3Kdo=
X-Received: by 2002:ac8:44c9:: with SMTP id b9mr4138750qto.175.1569508206816;
 Thu, 26 Sep 2019 07:30:06 -0700 (PDT)
Date:   Thu, 26 Sep 2019 10:30:05 -0400
Message-Id: <20190926143005.106045-1-yyd@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [PATCH net] tcp_bbr: fix quantization code to not raise cwnd if not
 probing bandwidth
From:   "Kevin(Yudong) Yang" <yyd@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, "Kevin(Yudong) Yang" <yyd@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Priyaranjan Jha <priyarjha@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There was a bug in the previous logic that attempted to ensure gain cycling
gets inflight above BDP even for small BDPs. This code correctly raised and
lowered target inflight values during the gain cycle. And this code
correctly ensured that cwnd was raised when probing bandwidth. However, it
did not correspondingly ensure that cwnd was *not* raised in this way when
*not* probing for bandwidth. The result was that small-BDP flows that were
always cwnd-bound could go for many cycles with a fixed cwnd, and not probe
or yield bandwidth at all. This meant that multiple small-BDP flows could
fail to converge in their bandwidth allocations.

Fixes: 383d470 ("tcp_bbr: fix bw probing to raise in-flight data for very small BDPs")
Signed-off-by: Kevin(Yudong) Yang <yyd@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Priyaranjan Jha <priyarjha@google.com>
---
 net/ipv4/tcp_bbr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index 95b59540eee1..32772d6ded4e 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -388,7 +388,7 @@ static u32 bbr_bdp(struct sock *sk, u32 bw, int gain)
  * which allows 2 outstanding 2-packet sequences, to try to keep pipe
  * full even with ACK-every-other-packet delayed ACKs.
  */
-static u32 bbr_quantization_budget(struct sock *sk, u32 cwnd, int gain)
+static u32 bbr_quantization_budget(struct sock *sk, u32 cwnd)
 {
 	struct bbr *bbr = inet_csk_ca(sk);
 
@@ -399,7 +399,7 @@ static u32 bbr_quantization_budget(struct sock *sk, u32 cwnd, int gain)
 	cwnd = (cwnd + 1) & ~1U;
 
 	/* Ensure gain cycling gets inflight above BDP even for small BDPs. */
-	if (bbr->mode == BBR_PROBE_BW && gain > BBR_UNIT)
+	if (bbr->mode == BBR_PROBE_BW && bbr->cycle_idx == 0)
 		cwnd += 2;
 
 	return cwnd;
@@ -411,7 +411,7 @@ static u32 bbr_inflight(struct sock *sk, u32 bw, int gain)
 	u32 inflight;
 
 	inflight = bbr_bdp(sk, bw, gain);
-	inflight = bbr_quantization_budget(sk, inflight, gain);
+	inflight = bbr_quantization_budget(sk, inflight);
 
 	return inflight;
 }
@@ -531,7 +531,7 @@ static void bbr_set_cwnd(struct sock *sk, const struct rate_sample *rs,
 	 * due to aggregation (of data and/or ACKs) visible in the ACK stream.
 	 */
 	target_cwnd += bbr_ack_aggregation_cwnd(sk);
-	target_cwnd = bbr_quantization_budget(sk, target_cwnd, gain);
+	target_cwnd = bbr_quantization_budget(sk, target_cwnd);
 
 	/* If we're below target cwnd, slow start cwnd toward target cwnd. */
 	if (bbr_full_bw_reached(sk))  /* only cut cwnd if we filled the pipe */
-- 
2.23.0.444.g18eeb5a265-goog

