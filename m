Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF242300C5D
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 20:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729467AbhAVTVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 14:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729543AbhAVTNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 14:13:49 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C194CC0613D6;
        Fri, 22 Jan 2021 11:13:09 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id q6so1664748ooo.8;
        Fri, 22 Jan 2021 11:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=D/lSjSk7J5m6AHoucCYZNXORDMKdSvYqMceGCBgaJYE=;
        b=mIHu+C/K8nooWwtwDwe/e6+nxCG1bOHOsXQ1H9v/jnxnqXWBgdOjYGY1ooD++rrx77
         52cqDCkWfFwH4dxehwpfUpFXXGUqt8NWOiIdmAiUuq0Cm2BW5hX/AhsYA5iRDXw3+Su+
         mxbTcEc7QND/elGKfMnQUZkVdMxQ9Um/g/ZRUAPMHdPTS5fWepM73yfODcThRjxE+jgS
         kKz5K9ef7ko+pY/3LTNfx5B4izBiIjyf3rp0eteMrYUg0YFt18TSYUi5ZKAFA03D3MtF
         NrgYVUb69H4WVD8LiQS3oyhHvLK22tHxfP+a1kN0cRD+Vp+UIb0KUuHbgMmsPF7RXF7C
         U5dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=D/lSjSk7J5m6AHoucCYZNXORDMKdSvYqMceGCBgaJYE=;
        b=nXrnAN37i0w9P+LEMeP33ZtdyO9MAXSlZdUV8CBd9gI9kK9VrQC00sD9AnLU5IszR2
         7JkeD9bf7Pj/rxz4Sae+wjGyFCKcuZFWSIXae5arXYALHCNz2JMr2o65ptVV8sd54/8R
         B4Du3bzfsxDNNFC5rPDFh/WSLH7/RVsgw5tqKC8qDyHFQSuI7USoctzX2RNlvFRDMjFy
         +V30ro0+Amt5YtVMAyZcZgiB0o+CvWUkk87eXBGRYhvfSOhPy7/gf0lI4qhkPHU5YZDL
         BmuT6t+K6H1pSufU36dPDgJWGxpnj+aCHeImE6y6wALy09we2031T3WiAa0gnn1+73Dy
         BO5Q==
X-Gm-Message-State: AOAM532xX7Oxa1eyB/pSQhk1vMg0sMPa+LN6xvc68E+I+7WbvtZxl2QU
        tSziG5m3GxCI5gypAYbvyF0=
X-Google-Smtp-Source: ABdhPJz2amLxxGlTqM6m5dPlVewfBbm+4vMI/BflGGEfNh/NDHbdfCBSkIsy2hqLK557mAFBIl3f1w==
X-Received: by 2002:a4a:e294:: with SMTP id k20mr4881858oot.82.1611342789240;
        Fri, 22 Jan 2021 11:13:09 -0800 (PST)
Received: from localhost.localdomain (99-6-134-177.lightspeed.snmtca.sbcglobal.net. [99.6.134.177])
        by smtp.gmail.com with ESMTPSA id z14sm1753636oot.5.2021.01.22.11.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 11:13:08 -0800 (PST)
Date:   Fri, 22 Jan 2021 11:13:06 -0800
From:   Enke Chen <enkechen2020@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neal Cardwell <ncardwell@google.com>, enkechen2020@gmail.com
Subject: [PATCH net] tcp: make TCP_USER_TIMEOUT accurate for zero window
 probes
Message-ID: <20210122191306.GA99540@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Enke Chen <enchen@paloaltonetworks.com>

The TCP_USER_TIMEOUT is checked by the 0-window probe timer. As the
timer has backoff with a max interval of about two minutes, the
actual timeout for TCP_USER_TIMEOUT can be off by up to two minutes.

In this patch the TCP_USER_TIMEOUT is made more accurate by taking it
into account when computing the timer value for the 0-window probes.

This patch is similar to the one that made TCP_USER_TIMEOUT accurate for
RTOs in commit b701a99e431d ("tcp: Add tcp_clamp_rto_to_user_timeout()
helper to improve accuracy").

Signed-off-by: Enke Chen <enchen@paloaltonetworks.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
---
 include/net/tcp.h     |  1 +
 net/ipv4/tcp_input.c  |  4 ++--
 net/ipv4/tcp_output.c |  2 ++
 net/ipv4/tcp_timer.c  | 18 ++++++++++++++++++
 4 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 78d13c88720f..ca7e2c6cc663 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -630,6 +630,7 @@ static inline void tcp_clear_xmit_timers(struct sock *sk)
 
 unsigned int tcp_sync_mss(struct sock *sk, u32 pmtu);
 unsigned int tcp_current_mss(struct sock *sk);
+u32 tcp_clamp_probe0_to_user_timeout(const struct sock *sk, u32 when);
 
 /* Bound MSS / TSO packet size with the half of the window */
 static inline int tcp_bound_to_half_wnd(struct tcp_sock *tp, int pktsize)
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index bafcab75f425..4923cdbea95a 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3392,8 +3392,8 @@ static void tcp_ack_probe(struct sock *sk)
 	} else {
 		unsigned long when = tcp_probe0_when(sk, TCP_RTO_MAX);
 
-		tcp_reset_xmit_timer(sk, ICSK_TIME_PROBE0,
-				     when, TCP_RTO_MAX);
+		when = tcp_clamp_probe0_to_user_timeout(sk, when);
+		tcp_reset_xmit_timer(sk, ICSK_TIME_PROBE0, when, TCP_RTO_MAX);
 	}
 }
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index ab458697881e..8478cf749821 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4099,6 +4099,8 @@ void tcp_send_probe0(struct sock *sk)
 		 */
 		timeout = TCP_RESOURCE_PROBE_INTERVAL;
 	}
+
+	timeout = tcp_clamp_probe0_to_user_timeout(sk, timeout);
 	tcp_reset_xmit_timer(sk, ICSK_TIME_PROBE0, timeout, TCP_RTO_MAX);
 }
 
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 454732ecc8f3..90722e30ad90 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -40,6 +40,24 @@ static u32 tcp_clamp_rto_to_user_timeout(const struct sock *sk)
 	return min_t(u32, icsk->icsk_rto, msecs_to_jiffies(remaining));
 }
 
+u32 tcp_clamp_probe0_to_user_timeout(const struct sock *sk, u32 when)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+	u32 remaining;
+	s32 elapsed;
+
+	if (!icsk->icsk_user_timeout || !icsk->icsk_probes_tstamp)
+		return when;
+
+	elapsed = tcp_jiffies32 - icsk->icsk_probes_tstamp;
+	if (unlikely(elapsed < 0))
+		elapsed = 0;
+	remaining = msecs_to_jiffies(icsk->icsk_user_timeout) - elapsed;
+	remaining = max_t(u32, remaining, TCP_TIMEOUT_MIN);
+
+	return min_t(u32, remaining, when);
+}
+
 /**
  *  tcp_write_err() - close socket and save error info
  *  @sk:  The socket the error has appeared on.
-- 
2.29.2

