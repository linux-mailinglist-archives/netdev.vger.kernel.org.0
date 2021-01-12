Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553102F3A49
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 20:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406586AbhALT0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 14:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406358AbhALT01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 14:26:27 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39610C061794;
        Tue, 12 Jan 2021 11:25:47 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id 15so3508175oix.8;
        Tue, 12 Jan 2021 11:25:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=agpYVbTUpFBim8yf9DoPgOvysuVnRXJq/ItxbXzT54s=;
        b=uDL/S/q9cQw72DHWF6Kv4XFvA7UO1b06EVBJP/zgT/SRai2OlbI1J6pFqolp+0TmH1
         fmv+C0k4iRrfh9wFxnmX20nmaje5hs/ya+G2wu/NtVd6zalHMJGsYZ3r0PANNtc5CBHg
         19HKUymyARr4Sr9MZGShdXpHth1rrAIsLW/nlKQ9BwyzgU0qBe/50PIdfiYdl0zHB7w2
         J6SFVPtmhyRmsG9HRYVAK44wcqyqDNfzGZVhlzbxczzTtf+wQyqZJDYG5AiZRvUBnOtI
         uqceiEWHbvMlxN0ILrotDjMpiFk68O1LQ3TZc9uY2c+iqwgsFCaNHk1Qnrpyhvo/mGyV
         3c5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=agpYVbTUpFBim8yf9DoPgOvysuVnRXJq/ItxbXzT54s=;
        b=e8KPh6XGfB0is51zGFboPnqUGns49HxL3+Sh5eBl3Z0ajvEswNMcyE/OCNoPUvGb3F
         f9NnoefTOlZ7g1CZ1QtpPAgEIQKaLAKwYM/5XW7+yz0r5yDrGLhEzz3UmZ2dXo2HBgGd
         ySXO115JD68x9GtF2LIIrGFpAwAXKJrXrq3GgpiVmS6Mn+kMQlCgEL+ciBt3d3toFpxu
         HjLqhqy0va5ZMQnQ9LhXzq8Snm/5OvO3gg88kbBR0oDMUHoLk2js8Dj7HtH2vOiYvN3u
         MOFggTRmeD2cUfEtGjnBjaS8ielsDyZP52tzqNbLwjT/ZpjANynTNURLYRKb7E66cdXI
         uJgg==
X-Gm-Message-State: AOAM530tWt4bShUtTzdmWGX4TcwHGQ/Vl1Zds3HAD+Qz4kCEzCzEBkRb
        dA7ggX7zG683m5zgs+fw21MM7v2myT8=
X-Google-Smtp-Source: ABdhPJwAG70iF+1HmdRCCkcNnpB/ArfFgpaXmhVKK1a37zXNCeU8gSW9X6jSwVZKPWmvkxrV3XApwA==
X-Received: by 2002:aca:c1d6:: with SMTP id r205mr449911oif.37.1610479546574;
        Tue, 12 Jan 2021 11:25:46 -0800 (PST)
Received: from localhost.localdomain (99-6-134-177.lightspeed.snmtca.sbcglobal.net. [99.6.134.177])
        by smtp.gmail.com with ESMTPSA id k10sm816827otn.71.2021.01.12.11.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 11:25:46 -0800 (PST)
Date:   Tue, 12 Jan 2021 11:25:44 -0800
From:   Enke Chen <enkechen2020@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        enkechen2020@gmail.com
Subject: [PATCH] tcp: keepalive fixes
Message-ID: <20210112192544.GA12209@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Enke Chen <enchen@paloaltonetworks.com>

In this patch two issues with TCP keepalives are fixed:

1) TCP keepalive does not timeout when there are data waiting to be
   delivered and then the connection got broken. The TCP keepalive
   timeout is not evaluated in that condition.

   The fix is to remove the code that prevents TCP keepalive from
   being evaluated for timeout.

2) With the fix for #1, TCP keepalive can erroneously timeout after
   the 0-window probe kicks in. The 0-window probe counter is wrongly
   applied to TCP keepalives.

   The fix is to use the elapsed time instead of the 0-window probe
   counter in evaluating TCP keepalive timeout.

Cc: stable@vger.kernel.org
Signed-off-by: Enke Chen <enchen@paloaltonetworks.com>
---
 net/ipv4/tcp_timer.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 6c62b9ea1320..40953aa40d53 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -696,12 +696,6 @@ static void tcp_keepalive_timer (struct timer_list *t)
 	    ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_SYN_SENT)))
 		goto out;
 
-	elapsed = keepalive_time_when(tp);
-
-	/* It is alive without keepalive 8) */
-	if (tp->packets_out || !tcp_write_queue_empty(sk))
-		goto resched;
-
 	elapsed = keepalive_time_elapsed(tp);
 
 	if (elapsed >= keepalive_time_when(tp)) {
@@ -709,16 +703,15 @@ static void tcp_keepalive_timer (struct timer_list *t)
 		 * to determine when to timeout instead.
 		 */
 		if ((icsk->icsk_user_timeout != 0 &&
-		    elapsed >= msecs_to_jiffies(icsk->icsk_user_timeout) &&
-		    icsk->icsk_probes_out > 0) ||
+		     elapsed >= msecs_to_jiffies(icsk->icsk_user_timeout)) ||
 		    (icsk->icsk_user_timeout == 0 &&
-		    icsk->icsk_probes_out >= keepalive_probes(tp))) {
+		     (elapsed >= keepalive_time_when(tp) +
+		      keepalive_intvl_when(tp) * keepalive_probes(tp)))) {
 			tcp_send_active_reset(sk, GFP_ATOMIC);
 			tcp_write_err(sk);
 			goto out;
 		}
 		if (tcp_write_wakeup(sk, LINUX_MIB_TCPKEEPALIVE) <= 0) {
-			icsk->icsk_probes_out++;
 			elapsed = keepalive_intvl_when(tp);
 		} else {
 			/* If keepalive was lost due to local congestion,
@@ -732,8 +725,6 @@ static void tcp_keepalive_timer (struct timer_list *t)
 	}
 
 	sk_mem_reclaim(sk);
-
-resched:
 	inet_csk_reset_keepalive_timer (sk, elapsed);
 	goto out;
 
-- 
2.29.2

