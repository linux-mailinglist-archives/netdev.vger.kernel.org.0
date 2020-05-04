Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F85F1C45DF
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 20:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731017AbgEDS2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 14:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730997AbgEDS16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 14:27:58 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620EFC061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 11:27:58 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id m138so465053ybf.12
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 11:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=obqneASt6Wqt24N90dV6OwEiCvPjJxf8YftfzVpRJVE=;
        b=Bb2UwohyGEsrs80XRQyMcl5f7WPW60weTydgxLnuLHSHH2sW92eIXO6/9hBKxp3PCV
         G1CMTY9YCk3TS+B3nQeGWgFeqPOclj1OkQ+SIPv2BniYruyoc9BsVBeQrMavmt7ShtB7
         lqA3nh5u/KV6H93dAAd+F6qJJc9FbqsTuZieuMxoff2el0C997gOJjW4E9ZxtZleau4A
         oiycvxt/ZUC3cTbsOW7aS+/vawcUojrUYv14ng/P/XyCNIcTD+vY1T+QijyksTEqD608
         Ui17Pr3dRFr5SFGdRQmqc4vK8mt/doEk78TnQxnUfFaZpE3hvsW6kWOshFgTujIPW7Tk
         Dq0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=obqneASt6Wqt24N90dV6OwEiCvPjJxf8YftfzVpRJVE=;
        b=l346Na27XwH7qyGd6xrz1karPi8coQVKxbfTVx8r4WS3gHPxuNRsV6K08UdfItt5xd
         aGZI9FbFXSc1JedJiqe5ebkBCErvkXgqz1nT9lVN2B7sCOMtcqvVcfW68gh3ZJNs2vhM
         1M1ihfXSdOmVc/Dh1V6JwzvFupDBso8powPHlzmLhBwoU4VxSE7bMpe5oTQGHET0pY31
         f3M08VXDjSNT/22xg3ypAzW96taQEv7DalfSUK15N3phLC9nScEpjOVeM9ZnZpTQvviE
         JiW9qvmZD3vxForUe6ciSqzErPrrey8jnh2J6LUGzrHSUehgA7TvDGDJ1CNt1Q5rpPQT
         2yaA==
X-Gm-Message-State: AGi0PuaqMYK2QB9D7ONT4K+V89oGozrdOG0IxyHQ1vwPruW+rMAq6MCE
        F60/UwMTJZ++NDNF21swxqx4llFvuJbE8A==
X-Google-Smtp-Source: APiQypKwEzr2nw0JR0QjKLmdDsGNrrsINS0gnfdTNhQmJ8spkSwU8oDm9ex+VmQTRPaszuK8ynNq+BLftZlCSA==
X-Received: by 2002:a25:d156:: with SMTP id i83mr859589ybg.449.1588616877631;
 Mon, 04 May 2020 11:27:57 -0700 (PDT)
Date:   Mon,  4 May 2020 11:27:49 -0700
In-Reply-To: <20200504182750.176486-1-edumazet@google.com>
Message-Id: <20200504182750.176486-2-edumazet@google.com>
Mime-Version: 1.0
References: <20200504182750.176486-1-edumazet@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH net-next 1/2] tcp: refine tcp_pacing_delay() for very low
 pacing rates
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the addition of horizon feature to sch_fq, we noticed some
suboptimal behavior of extremely low pacing rate TCP flows, especially
when TCP is not aware of a drop happening in lower stacks.

Back in commit 3f80e08f40cd ("tcp: add tcp_reset_xmit_timer() helper"),
tcp_pacing_delay() was added to estimate an extra delay to add to standard
rto timers.

This patch removes the skb argument from this helper and
tcp_reset_xmit_timer() because it makes more sense to simply
consider the time at which next packet is allowed to be sent,
instead of the time of whatever packet has been sent.

This avoids arming RTO timer too soon and removes
spurious horizon drops.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h     | 21 ++++++++-------------
 net/ipv4/tcp_input.c  |  4 ++--
 net/ipv4/tcp_output.c |  8 +++-----
 3 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 1beed50522b116e670887e7af132174d21c71744..43b87a8d4790658b28356b5394e07b1419e27b77 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1289,26 +1289,22 @@ static inline bool tcp_needs_internal_pacing(const struct sock *sk)
 	return smp_load_acquire(&sk->sk_pacing_status) == SK_PACING_NEEDED;
 }
 
-/* Return in jiffies the delay before one skb is sent.
- * If @skb is NULL, we look at EDT for next packet being sent on the socket.
+/* Estimates in how many jiffies next packet for this flow can be sent.
+ * Scheduling a retransmit timer too early would be silly.
  */
-static inline unsigned long tcp_pacing_delay(const struct sock *sk,
-					     const struct sk_buff *skb)
+static inline unsigned long tcp_pacing_delay(const struct sock *sk)
 {
-	s64 pacing_delay = skb ? skb->tstamp : tcp_sk(sk)->tcp_wstamp_ns;
+	s64 delay = tcp_sk(sk)->tcp_wstamp_ns - tcp_sk(sk)->tcp_clock_cache;
 
-	pacing_delay -= tcp_sk(sk)->tcp_clock_cache;
-
-	return pacing_delay > 0 ? nsecs_to_jiffies(pacing_delay) : 0;
+	return delay > 0 ? nsecs_to_jiffies(delay) : 0;
 }
 
 static inline void tcp_reset_xmit_timer(struct sock *sk,
 					const int what,
 					unsigned long when,
-					const unsigned long max_when,
-					const struct sk_buff *skb)
+					const unsigned long max_when)
 {
-	inet_csk_reset_xmit_timer(sk, what, when + tcp_pacing_delay(sk, skb),
+	inet_csk_reset_xmit_timer(sk, what, when + tcp_pacing_delay(sk),
 				  max_when);
 }
 
@@ -1336,8 +1332,7 @@ static inline void tcp_check_probe_timer(struct sock *sk)
 {
 	if (!tcp_sk(sk)->packets_out && !inet_csk(sk)->icsk_pending)
 		tcp_reset_xmit_timer(sk, ICSK_TIME_PROBE0,
-				     tcp_probe0_base(sk), TCP_RTO_MAX,
-				     NULL);
+				     tcp_probe0_base(sk), TCP_RTO_MAX);
 }
 
 static inline void tcp_init_wl(struct tcp_sock *tp, u32 seq)
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index d68128a672ab05899d26eb9b1978c4a34023d51f..7d205b2a733ce940dba289a89ca7b78974b52caf 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3014,7 +3014,7 @@ void tcp_rearm_rto(struct sock *sk)
 			rto = usecs_to_jiffies(max_t(int, delta_us, 1));
 		}
 		tcp_reset_xmit_timer(sk, ICSK_TIME_RETRANS, rto,
-				     TCP_RTO_MAX, tcp_rtx_queue_head(sk));
+				     TCP_RTO_MAX);
 	}
 }
 
@@ -3291,7 +3291,7 @@ static void tcp_ack_probe(struct sock *sk)
 		unsigned long when = tcp_probe0_when(sk, TCP_RTO_MAX);
 
 		tcp_reset_xmit_timer(sk, ICSK_TIME_PROBE0,
-				     when, TCP_RTO_MAX, NULL);
+				     when, TCP_RTO_MAX);
 	}
 }
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index c414aeb1efa927c84bd4cd6afd0c21d46f049d5b..32c9db902f180aad3776b85bcdeb482443a9a5be 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2593,8 +2593,7 @@ bool tcp_schedule_loss_probe(struct sock *sk, bool advancing_rto)
 	if (rto_delta_us > 0)
 		timeout = min_t(u32, timeout, usecs_to_jiffies(rto_delta_us));
 
-	tcp_reset_xmit_timer(sk, ICSK_TIME_LOSS_PROBE, timeout,
-			     TCP_RTO_MAX, NULL);
+	tcp_reset_xmit_timer(sk, ICSK_TIME_LOSS_PROBE, timeout, TCP_RTO_MAX);
 	return true;
 }
 
@@ -3174,8 +3173,7 @@ void tcp_xmit_retransmit_queue(struct sock *sk)
 		    icsk->icsk_pending != ICSK_TIME_REO_TIMEOUT)
 			tcp_reset_xmit_timer(sk, ICSK_TIME_RETRANS,
 					     inet_csk(sk)->icsk_rto,
-					     TCP_RTO_MAX,
-					     skb);
+					     TCP_RTO_MAX);
 	}
 }
 
@@ -3907,7 +3905,7 @@ void tcp_send_probe0(struct sock *sk)
 		 */
 		timeout = TCP_RESOURCE_PROBE_INTERVAL;
 	}
-	tcp_reset_xmit_timer(sk, ICSK_TIME_PROBE0, timeout, TCP_RTO_MAX, NULL);
+	tcp_reset_xmit_timer(sk, ICSK_TIME_PROBE0, timeout, TCP_RTO_MAX);
 }
 
 int tcp_rtx_synack(const struct sock *sk, struct request_sock *req)
-- 
2.26.2.526.g744177e7f7-goog

