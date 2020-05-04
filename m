Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED6571C45E0
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 20:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730871AbgEDS2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 14:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731031AbgEDS2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 14:28:01 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82ACC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 11:28:00 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i62so471883ybc.11
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 11:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OnX2KU5w3g+k8zVLiUmujhqVjHfZoHuApD9BlEoH9Hk=;
        b=JlzcaRKpftQzYi50cuJXOYFvWvCCXzp7Hdjw9BqjXLQt2vU7lBtPEZvP0rhO9SQO2x
         /RwAwE2VMVO/YFq1cwpAopQPKVm9uazwOWFJgEirUTczJrcPSEeKAP5wtZyp8/kCuYEm
         WQ52mB/cEcoz7zagPHkHQ+0qXcXY+GOAFNt3psLsWZWZWSjWIbHVI1Yg7nND7zqXJQNK
         dZypB2Jdr5XkdbJgoXJCVzG1UW1duSi0aRTe/rl1jQcJ8Yc0lxRtAsd5hfyyIBg4ocOI
         3PNBmRsOK86gAs3M7xu1LduP/xNXKyY5k3is+xNZlPti2norPqgIlk4ael2ougRc8zcY
         bxog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OnX2KU5w3g+k8zVLiUmujhqVjHfZoHuApD9BlEoH9Hk=;
        b=ZovEQeO+KV4L0O6yVsjd8frwsZJlO5S3B9gZH9sh6Tp+LVp0BxugSSRqmMTL8xUJ4G
         XY8+OhlVMMDAkpTHGfhlMCweGHX5OU2CoKtx/022AXMVwAMMHbodVXuiNjvFGaGqeRcb
         v4o8yIwCYGkC6wLY1n3oRDYonjn1B8oCfswTnSdZSvPAHEoUC+ZukPKq2JBgwy7sJ+Jr
         4iexOpgfX3/mqeQKuAy1laOpecIxzKREj16F9D2iGfdW4+h3NiUGveCz1QHnXjAA/5gy
         Esmw30iYKDpkWW8mR/BqO3q9zggreCZhcmcCLrvkh4HPubffBJjaoCVfipb9JHM4T4E8
         Nf/w==
X-Gm-Message-State: AGi0PuZ5CsJPUxX2DwP4gSjlFEGBVDwUH1ZYA4F0RewOxvOFfGQWsb68
        suntPYspbFaD3fQnmf4d8NemgT+DOxIoxA==
X-Google-Smtp-Source: APiQypJN7zx711PxQ883Mhj78qyUEHaHz+yGpWSp96l1pwv1mWbjfBWs9h3pHWGnIu/Ue+YlMKETRrQR05uwPQ==
X-Received: by 2002:a25:da8b:: with SMTP id n133mr853922ybf.418.1588616880091;
 Mon, 04 May 2020 11:28:00 -0700 (PDT)
Date:   Mon,  4 May 2020 11:27:50 -0700
In-Reply-To: <20200504182750.176486-1-edumazet@google.com>
Message-Id: <20200504182750.176486-3-edumazet@google.com>
Mime-Version: 1.0
References: <20200504182750.176486-1-edumazet@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH net-next 2/2] tcp: defer xmit timer reset in tcp_xmit_retransmit_queue()
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

As hinted in prior change ("tcp: refine tcp_pacing_delay()
for very low pacing rates"), it is probably best arming
the xmit timer only when all the packets have been scheduled,
rather than when the head of rtx queue has been re-sent.

This does matter for flows having extremely low pacing rates,
since their tp->tcp_wstamp_ns could be far in the future.

Note that the regular xmit path has a stronger limit
in tcp_small_queue_check(), meaning it is less likely to
go beyond the pacing horizon.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_output.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 32c9db902f180aad3776b85bcdeb482443a9a5be..a50e1990a845a258d4cc6a2a989d09068ea3a973 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3112,6 +3112,7 @@ void tcp_xmit_retransmit_queue(struct sock *sk)
 	const struct inet_connection_sock *icsk = inet_csk(sk);
 	struct sk_buff *skb, *rtx_head, *hole = NULL;
 	struct tcp_sock *tp = tcp_sk(sk);
+	bool rearm_timer = false;
 	u32 max_segs;
 	int mib_idx;
 
@@ -3134,7 +3135,7 @@ void tcp_xmit_retransmit_queue(struct sock *sk)
 
 		segs = tp->snd_cwnd - tcp_packets_in_flight(tp);
 		if (segs <= 0)
-			return;
+			break;
 		sacked = TCP_SKB_CB(skb)->sacked;
 		/* In case tcp_shift_skb_data() have aggregated large skbs,
 		 * we need to make sure not sending too bigs TSO packets
@@ -3159,10 +3160,10 @@ void tcp_xmit_retransmit_queue(struct sock *sk)
 			continue;
 
 		if (tcp_small_queue_check(sk, skb, 1))
-			return;
+			break;
 
 		if (tcp_retransmit_skb(sk, skb, segs))
-			return;
+			break;
 
 		NET_ADD_STATS(sock_net(sk), mib_idx, tcp_skb_pcount(skb));
 
@@ -3171,10 +3172,13 @@ void tcp_xmit_retransmit_queue(struct sock *sk)
 
 		if (skb == rtx_head &&
 		    icsk->icsk_pending != ICSK_TIME_REO_TIMEOUT)
-			tcp_reset_xmit_timer(sk, ICSK_TIME_RETRANS,
-					     inet_csk(sk)->icsk_rto,
-					     TCP_RTO_MAX);
+			rearm_timer = true;
+
 	}
+	if (rearm_timer)
+		tcp_reset_xmit_timer(sk, ICSK_TIME_RETRANS,
+				     inet_csk(sk)->icsk_rto,
+				     TCP_RTO_MAX);
 }
 
 /* We allow to exceed memory limits for FIN packets to expedite
-- 
2.26.2.526.g744177e7f7-goog

