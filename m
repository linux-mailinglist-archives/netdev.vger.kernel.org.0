Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82211320250
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 01:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbhBTAzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 19:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbhBTAza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 19:55:30 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A61AC061574;
        Fri, 19 Feb 2021 16:54:50 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id o10so6753951ote.13;
        Fri, 19 Feb 2021 16:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=Sl18xJK0FBSUcbbYuyh+oreHTjQxjE1dyshoc+jjlUI=;
        b=K7XCW1WWWeAL73AOb5FLLcLtM9+VV2lCYoajJA7RPceu3wu6hrJf+Gtj+D/j11sQI6
         iZBucvwZ5S6JSA3T4TmFnM8zFrc95/bujHMA6ObGe2N9kw/ioi/x2PCB2K6LCuy9jG6n
         WA3Sxja+fyHbA8nStBSJTtC+bAt4oZwCP2zgts4yK0QhpnBZlNiaoOebbb5mhQiOJvPB
         035EXtKGWpPUqcvxhqyyyMd5/MhYfVe2E3AheXdqOyyvCo8YEwTQ9Nx3NqrHEH3U42OZ
         ZMiPsSRKp089gIBox6Ecn6vf/6/NU/o2Hll47SmLgzcLHhOjdwIWXb+seieSxgIWCRQS
         SWTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Sl18xJK0FBSUcbbYuyh+oreHTjQxjE1dyshoc+jjlUI=;
        b=T2oyh4o8rfAc3VH0cAH9WC2MihbEVHgrYXsAiZo/5qFQRseRjkiJp9GmNlAlkoJ97I
         bv9/0iJ1oKyh2jps9/wYSYlisSBeSByOtveaoMKByWmVPMIwCcrBUoYiTOCckyOQzSXr
         ssecb8b8D3sNAg+08LqtmJ2uyq7y0zjyCI+f5Uf6ZM9+KaBARl3E/k50X07RW6mwSF/z
         0vnDxwL7SpIQbL3+8fFnC6iZGMYoHDprmL2P+WYo1oluynseeyFlil/qLDvxlh6+zeCU
         brSsaIlXR7GavMSMrjJB8rflv0hmVnO2o4IdCEqZF66a/1y0y15IqI2gYubMBC0ME4ex
         tOtg==
X-Gm-Message-State: AOAM53379TOQ3wbSxEiS3zxh3vYE9KCD5XK9RqKqgHvzOL+ZfUmhfR/C
        qGgZ4Y8ptjDEOW/tZFpvaCg=
X-Google-Smtp-Source: ABdhPJwPRmY9a0WjZK0JIk246VwicuAgC8AShTzOXy0zbGunJ7038NI7+oHlKVZ3tF1Mcgc2qSppHg==
X-Received: by 2002:a05:6830:1d68:: with SMTP id l8mr8939616oti.238.1613782489766;
        Fri, 19 Feb 2021 16:54:49 -0800 (PST)
Received: from localhost.localdomain (99-6-134-177.lightspeed.snmtca.sbcglobal.net. [99.6.134.177])
        by smtp.gmail.com with ESMTPSA id u126sm2224426oig.55.2021.02.19.16.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 16:54:49 -0800 (PST)
Date:   Fri, 19 Feb 2021 16:54:47 -0800
From:   Enke Chen <enkechen2020@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, enkechen2020@gmai.com
Subject: [PATCH net] tcp: fix keepalive when data remain undelivered
Message-ID: <20210220005447.GA93678@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Enke Chen <enchen@paloaltonetworks.com>

TCP keepalive does not timeout under the condition that network connection
is lost and data remain undelivered (incl. retransmit). A very simple
scenarios of the failure is to write data to a tcp socket after the network
connection is lost.

Under the specified condition the keepalive timeout is not evaluated in
the keepalive timer. That is the primary cause of the failure. In addition,
the keepalive probe is not sent out in the keepalive timer. Although packet
retransmit or 0-window probe can serve a similar purpose, they have their
own timers and backoffs that are generally not aligned with the keepalive
parameters for probes and timeout.

As the timing and conditions of the events involved are random, the tcp
keepalive can fail randomly. Given the randomness of the failures, fixing
the issue would not cause any backward compatibility issues. As was well
said, "Determinism is a special case of randomness".

The fix in this patch consists of the following:

  a. Always evaluate the keepalive timeout in the keepalive timer.

  b. Always send out the keepalive probe in the keepalive timer (post the
     keepalive idle time). Given that the keepalive intervals are usually
     in the range of 30 - 60 seconds, there is no need for an optimization
     to further reduce the number of keepalive probes in the presence of
     packet retransmit.

  c. Use the elapsed time (instead of the 0-window probe counter) in
     evaluating tcp keepalive timeout.

Thanks to Eric Dumazet, Neal Cardwell, and Yuchung Cheng for helpful
discussions about the issue and options for fixing it.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2 Initial git repository build")
Signed-off-by: Enke Chen <enchen@paloaltonetworks.com>
---
 net/ipv4/tcp_timer.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 4ef08079ccfa..16a044da20db 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -708,29 +708,23 @@ static void tcp_keepalive_timer (struct timer_list *t)
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
 		/* If the TCP_USER_TIMEOUT option is enabled, use that
 		 * to determine when to timeout instead.
 		 */
-		if ((icsk->icsk_user_timeout != 0 &&
-		    elapsed >= msecs_to_jiffies(icsk->icsk_user_timeout) &&
-		    icsk->icsk_probes_out > 0) ||
-		    (icsk->icsk_user_timeout == 0 &&
-		    icsk->icsk_probes_out >= keepalive_probes(tp))) {
+		u32 timeout = icsk->icsk_user_timeout ?
+		  msecs_to_jiffies(icsk->icsk_user_timeout) :
+		  keepalive_intvl_when(tp) * keepalive_probes(tp) +
+		  keepalive_time_when(tp);
+
+		if (elapsed >= timeout) {
 			tcp_send_active_reset(sk, GFP_ATOMIC);
 			tcp_write_err(sk);
 			goto out;
 		}
 		if (tcp_write_wakeup(sk, LINUX_MIB_TCPKEEPALIVE) <= 0) {
-			icsk->icsk_probes_out++;
 			elapsed = keepalive_intvl_when(tp);
 		} else {
 			/* If keepalive was lost due to local congestion,
@@ -744,8 +738,6 @@ static void tcp_keepalive_timer (struct timer_list *t)
 	}
 
 	sk_mem_reclaim(sk);
-
-resched:
 	inet_csk_reset_keepalive_timer (sk, elapsed);
 	goto out;
 
-- 
2.29.2

