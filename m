Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73EF41CB0B
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 19:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344547AbhI2R1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 13:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344622AbhI2R1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 13:27:01 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91FAC061764
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 10:25:20 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id x1-20020a056902102100b005b6233ad6b5so4418722ybt.6
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 10:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CvGJ4Z6Bljun4/eGYY7fseGY0GSY3h9OiPiupWWA5tM=;
        b=GmVWBnuZOe5ZD8VYrxEiLtAht1qo7Y2Bl7bNPQzenuVHdWV54pCQPSAKq7nzw5xYJo
         L4OmmU4Ik5NsjNGO2gCeWsM/7J4yYIZC1oJ8zAiTXwckp0n8KM4CUwHVjmATzSQjMAsA
         o8VU8geh9+p1mRuN6nfF1XomVTdMqC6jJP1Df1E51+81/OGWwPr88eS9m8KCcxJksv1a
         OyU8X+1Vp8+jOUZOoCXJshEmfT5rJEPgdoxCliRSKt0wo5SrrlLkbNTC5vP97yVFiZRh
         bXGXqC8GOqPDz3hHbWmqmp+uTrz/NPN4bei7JGfXjGVXsJdm+Ztb6uVL8MevYj95Oc0g
         wiaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CvGJ4Z6Bljun4/eGYY7fseGY0GSY3h9OiPiupWWA5tM=;
        b=K/3bUF6txuDiwWgNHhmpS82JcoyP1CPq4SJ9rhv0BkB/Q7QDx0O1avbcl4WlJ0PTRx
         Z0LyOIJ6tEMQ9gqdrgRLJjBZ9rro1HWNCaBoKBzGxqlEBBGOqCT6TfSCDpQ7XGkLXl5i
         23weUL5lDz+VdV8tFOcm/BkBSrWi6yRnbYRS0Kk/c7ZAtQqBQPvwKVg3l4o94pS1DvzN
         SL7ysRLvBoCandJcnS6WwaYpin0982kIGQ7+xUffg2rUhxpk+fTWy/b1JT5eL28f0vt9
         cZ2UrvvPVtrMWRL3UTIKRJ9LXlfCV3MLiZmtmudi91gVvn4++7xo+54ts/JEwvdY3DFD
         +YbA==
X-Gm-Message-State: AOAM5319HANHPM8MXW54uO7OQIUnCKkUHKJU40aXP+rCzHagDJBQLhw1
        8w/PCtVQ0bIVfMdsx9DebvPpNmNlOe4=
X-Google-Smtp-Source: ABdhPJyirv41GoyDFtvThYOZQFwQH03dbIYyS2zrfDcFmCaW02hz7uwzGedyyfegq3IedWEltsm2ng9JT4s=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:a9d9:bcda:fa5:99c6])
 (user=weiwan job=sendgmr) by 2002:a25:59d5:: with SMTP id n204mr1115249ybb.189.1632936320022;
 Wed, 29 Sep 2021 10:25:20 -0700 (PDT)
Date:   Wed, 29 Sep 2021 10:25:13 -0700
In-Reply-To: <20210929172513.3930074-1-weiwan@google.com>
Message-Id: <20210929172513.3930074-4-weiwan@google.com>
Mime-Version: 1.0
References: <20210929172513.3930074-1-weiwan@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 net-next 3/3] tcp: adjust rcv_ssthresh according to sk_reserved_mem
From:   Wei Wang <weiwan@google.com>
To:     "'David S . Miller'" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Shakeel Butt <shakeelb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When user sets SO_RESERVE_MEM socket option, in order to utilize the
reserved memory when in memory pressure state, we adjust rcv_ssthresh
according to the available reserved memory for the socket, instead of
using 4 * advmss always.

Signed-off-by: Wei Wang <weiwan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com> 
---
 include/net/tcp.h     | 11 +++++++++++
 net/ipv4/tcp_input.c  | 12 ++++++++++--
 net/ipv4/tcp_output.c |  3 +--
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 32cf6c01f403..4c2898ac6569 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1421,6 +1421,17 @@ static inline int tcp_full_space(const struct sock *sk)
 	return tcp_win_from_space(sk, READ_ONCE(sk->sk_rcvbuf));
 }
 
+static inline void tcp_adjust_rcv_ssthresh(struct sock *sk)
+{
+	int unused_mem = sk_unused_reserved_mem(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	tp->rcv_ssthresh = min(tp->rcv_ssthresh, 4U * tp->advmss);
+	if (unused_mem)
+		tp->rcv_ssthresh = max_t(u32, tp->rcv_ssthresh,
+					 tcp_win_from_space(sk, unused_mem));
+}
+
 void tcp_cleanup_rbuf(struct sock *sk, int copied);
 
 /* We provision sk_rcvbuf around 200% of sk_rcvlowat.
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 06020395cc8d..246ab7b5e857 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -500,8 +500,11 @@ static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb,
 
 	room = min_t(int, tp->window_clamp, tcp_space(sk)) - tp->rcv_ssthresh;
 
+	if (room <= 0)
+		return;
+
 	/* Check #1 */
-	if (room > 0 && !tcp_under_memory_pressure(sk)) {
+	if (!tcp_under_memory_pressure(sk)) {
 		unsigned int truesize = truesize_adjust(adjust, skb);
 		int incr;
 
@@ -518,6 +521,11 @@ static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb,
 			tp->rcv_ssthresh += min(room, incr);
 			inet_csk(sk)->icsk_ack.quick |= 1;
 		}
+	} else {
+		/* Under pressure:
+		 * Adjust rcv_ssthresh according to reserved mem
+		 */
+		tcp_adjust_rcv_ssthresh(sk);
 	}
 }
 
@@ -5345,7 +5353,7 @@ static int tcp_prune_queue(struct sock *sk)
 	if (atomic_read(&sk->sk_rmem_alloc) >= sk->sk_rcvbuf)
 		tcp_clamp_window(sk);
 	else if (tcp_under_memory_pressure(sk))
-		tp->rcv_ssthresh = min(tp->rcv_ssthresh, 4U * tp->advmss);
+		tcp_adjust_rcv_ssthresh(sk);
 
 	if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf)
 		return 0;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index fdc39b4fbbfa..3a01e5593a17 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2967,8 +2967,7 @@ u32 __tcp_select_window(struct sock *sk)
 		icsk->icsk_ack.quick = 0;
 
 		if (tcp_under_memory_pressure(sk))
-			tp->rcv_ssthresh = min(tp->rcv_ssthresh,
-					       4U * tp->advmss);
+			tcp_adjust_rcv_ssthresh(sk);
 
 		/* free_space might become our new window, make sure we don't
 		 * increase it due to wscale.
-- 
2.33.0.685.g46640cef36-goog

