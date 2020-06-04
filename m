Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1ED1EE06F
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 11:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgFDJBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 05:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728089AbgFDJBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 05:01:31 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63214C03E96D;
        Thu,  4 Jun 2020 02:01:31 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id s88so917787pjb.5;
        Thu, 04 Jun 2020 02:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PFq0vXrRaSmgWvfmDIPgyoV5VxCvXpSfHJA3tFT8WZg=;
        b=sVYb4xQhEF7N02+Uf9U0zOPXvoWAfJrAPHSODAEDPsUyPO7LjluXEJSg568Ur1R6fS
         058N0SrkET5XvVxx77XyKw7l5pPcwkkkFscicMP2l3j93wf+NwZ2vk1SrZF9y8Fw8RDu
         wepxC7TOXIZ2Lo8Z1I0I5jDF+NxMOiit6FAT108oH+hhUcpelTTXDWKH1avmGAhgxmcz
         LzdzBDnvas3xLC/QAIvrtQl4eLB3l9RMVm7ouOtOrs8ELospfFFmX+MUuaptbj4IVn3d
         HiPrxlDUjBtI1VBvLeGfbPaSG9cl2Fsws22EF6jz+yVKcasUModYlX7B8TFJzMTj45e0
         rmIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PFq0vXrRaSmgWvfmDIPgyoV5VxCvXpSfHJA3tFT8WZg=;
        b=frF4yL4R3+x0eY3+dIeN9u1EeMP8OS+SQ/D8cuxtI/iQT2ohemuhbDrMXYax2ZQNEN
         8cqatafx0VHjzarEpuezKJpHQOhJRENA3+ZhTnOr5egloVa4IYaG6Wx0FqPGt4A3KdJB
         9BC2rxHfW3jIag4UY87psbdD2Dt2pvSldCbs9hCpN+MR1jjGTEp7Cdz0gRBNa0IxLhkv
         tSEOSKipXfAm6uFpiV/ShJS+Qd3AyObBB3zRR7W0M8Ylm0Dw0iyWpn/vm92vwkGtk0m+
         Fyef319z2bMtZxWcSDhRQTYWyV43T6OHL7BjKtC9NPTOwpt1y+RgtosAB7MszyrN6q+/
         B38Q==
X-Gm-Message-State: AOAM532b4Mey/UN4ihvU+V3pRuX+6H8m6uZDBJRAT6cl0K58z7+dsnby
        +ahf6nR1NIG+1IDxLgAyyTs=
X-Google-Smtp-Source: ABdhPJxtCyXiehCK/eWYd3f9upvwKzw3NM8IBsK8vq7igCwcZfq0WI6FS0endAzwaYf28jVOpCay5A==
X-Received: by 2002:a17:90a:8089:: with SMTP id c9mr5084842pjn.126.1591261290908;
        Thu, 04 Jun 2020 02:01:30 -0700 (PDT)
Received: from localhost.localdomain ([45.192.173.253])
        by smtp.gmail.com with ESMTPSA id g21sm4595307pjl.3.2020.06.04.02.01.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jun 2020 02:01:29 -0700 (PDT)
From:   kerneljasonxing@gmail.com
To:     gregkh@linuxfoundation.org, edumazet@google.com,
        ncardwell@google.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org, kerneljasonxing@gmail.com,
        linux-kernel@vger.kernel.org, liweishi@kuaishou.com,
        lishujin@kuaishou.com
Subject: [PATCH v2 4.19] tcp: fix TCP socks unreleased in BBR mode
Date:   Thu,  4 Jun 2020 17:00:14 +0800
Message-Id: <20200604090014.23266-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20200602080425.93712-1-kerneljasonxing@gmail.com>
References: <20200602080425.93712-1-kerneljasonxing@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <kerneljasonxing@gmail.com>

When using BBR mode, too many tcp socks cannot be released because of
duplicate use of the sock_hold() in the manner of tcp_internal_pacing()
when RTO happens. Therefore, this situation maddly increases the slab
memory and then constantly triggers the OOM until crash.

Besides, in addition to BBR mode, if some mode applies pacing function,
it could trigger what we've discussed above,

Reproduce procedure:
0) cat /proc/slabinfo | grep TCP
1) switch net.ipv4.tcp_congestion_control to bbr
2) using wrk tool something like that to send packages
3) using tc to increase the delay and loss to simulate the RTO case.
4) cat /proc/slabinfo | grep TCP
5) kill the wrk command and observe the number of objects and slabs in
TCP.
6) at last, you could notice that the number would not decrease.

v2: extend the timer which could cover all those related potential risks
(suggested by Eric Dumazet and Neal Cardwell)

Signed-off-by: Jason Xing <kerneljasonxing@gmail.com>
Signed-off-by: liweishi <liweishi@kuaishou.com>
Signed-off-by: Shujin Li <lishujin@kuaishou.com>
---
 net/ipv4/tcp_output.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index cc4ba42..4626f4e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -966,6 +966,8 @@ enum hrtimer_restart tcp_pace_kick(struct hrtimer *timer)
 
 static void tcp_internal_pacing(struct sock *sk, const struct sk_buff *skb)
 {
+	struct tcp_sock *tp = tcp_sk(sk);
+	ktime_t expire, now;
 	u64 len_ns;
 	u32 rate;
 
@@ -977,12 +979,28 @@ static void tcp_internal_pacing(struct sock *sk, const struct sk_buff *skb)
 
 	len_ns = (u64)skb->len * NSEC_PER_SEC;
 	do_div(len_ns, rate);
-	hrtimer_start(&tcp_sk(sk)->pacing_timer,
-		      ktime_add_ns(ktime_get(), len_ns),
+	now = ktime_get();
+	/* If hrtimer is already armed, then our caller has not
+	 * used tcp_pacing_check().
+	 */
+	if (unlikely(hrtimer_is_queued(&tp->pacing_timer))) {
+		expire = hrtimer_get_softexpires(&tp->pacing_timer);
+		if (ktime_after(expire, now))
+			now = expire;
+		if (hrtimer_try_to_cancel(&tp->pacing_timer) == 1)
+			__sock_put(sk);
+	}
+	hrtimer_start(&tp->pacing_timer, ktime_add_ns(now, len_ns),
 		      HRTIMER_MODE_ABS_PINNED_SOFT);
 	sock_hold(sk);
 }
 
+static bool tcp_pacing_check(const struct sock *sk)
+{
+	return tcp_needs_internal_pacing(sk) &&
+	       hrtimer_is_queued(&tcp_sk(sk)->pacing_timer);
+}
+
 static void tcp_update_skb_after_send(struct tcp_sock *tp, struct sk_buff *skb)
 {
 	skb->skb_mstamp = tp->tcp_mstamp;
@@ -2117,6 +2135,9 @@ static int tcp_mtu_probe(struct sock *sk)
 	if (!tcp_can_coalesce_send_queue_head(sk, probe_size))
 		return -1;
 
+	if (tcp_pacing_check(sk))
+		return -1;
+
 	/* We're allowed to probe.  Build it now. */
 	nskb = sk_stream_alloc_skb(sk, probe_size, GFP_ATOMIC, false);
 	if (!nskb)
@@ -2190,12 +2211,6 @@ static int tcp_mtu_probe(struct sock *sk)
 	return -1;
 }
 
-static bool tcp_pacing_check(const struct sock *sk)
-{
-	return tcp_needs_internal_pacing(sk) &&
-	       hrtimer_is_queued(&tcp_sk(sk)->pacing_timer);
-}
-
 /* TCP Small Queues :
  * Control number of packets in qdisc/devices to two packets / or ~1 ms.
  * (These limits are doubled for retransmits)
-- 
1.8.3.1

