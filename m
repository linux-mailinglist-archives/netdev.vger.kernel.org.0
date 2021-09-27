Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C69C419E2C
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 20:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236220AbhI0S1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 14:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236205AbhI0S1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 14:27:13 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE2FC061770
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 11:25:32 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id v14-20020a05620a0f0e00b0043355ed67d1so74837941qkl.7
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 11:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GqanaaDr8VJLk6JgbwW4zip5DujZM1l8logVEBUxoME=;
        b=TrPoRYeKTlmu+V5XdhcD110XtcW/ajFWWuVuYMwy043mLYFJu/4us/sNNOQbFrEHaZ
         4hYzxnz7Pu2Yd46EuiJ89SQHxwjjjcbnnlq3V4VHRx799gNB4TN2GBbOOzVafQtsH8Vo
         VCfeCcK3N6uJxh/pvqguN0/7uem7l+DjRPq5AT1da9hqR7wucwfRcpyqHOOTIaOq83Xe
         z1Lg5V2ksVTHFhUHztHJXFVrGXdICSClR/VVNIM6d5zw9U28g49ViphK0yRqsahlOQfh
         gPNRpNapnBXciV1lEt6XflOznx84Q/PdzxLy6MvpMsJF1eqXn1IfQx9xHdqzv0+FiAOZ
         3GYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GqanaaDr8VJLk6JgbwW4zip5DujZM1l8logVEBUxoME=;
        b=WCG98x7oC2JGGfoh3QI+vlQHHXXE9Nqkoa0SmSXuDf+hw8njG529edxXjHCUYmwYJ2
         HBnA9Zu6JzGgtfwzP+Ia5ff7y1mJa2bk6yRdE6sWImS4o2psOzFkVYxiM/1PEOqP2YAC
         yl2MHDhYApy/ZkRreZwqqmtGb+eS7p0krQrFhTEoRH2j1XmRgFxqcXU7Py1T/ivVHl4C
         YQxHeiMbperAhNXvGT1Ngsco+VzQGC8wA8waByh05MKiXSLNhsJy/WMjKRqjc78UBDjz
         Jmu+Fq5BDW8L9Oit5BOhVYzvnauaCoTFTn6NW1UTZ1Oblc83MAgLC4l16w8JB/OC/TZz
         fxFw==
X-Gm-Message-State: AOAM530+OR0i1/Yo/zw9KDYCg0KvysOYFbu+zB2HTPfISB4Bf+LTZH+Z
        G3XgH7Y0qmvQLaNsQFmScZM75vVx+u8=
X-Google-Smtp-Source: ABdhPJz/ci2ClxMv+0Kj+l3ejgziOn4gfqLEeROgiPfTqLD+6luLebl6ANuy6bu8XnrN8vTpExnSZkW/OPU=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:889:3fd7:84f6:f39c])
 (user=weiwan job=sendgmr) by 2002:a05:6214:1233:: with SMTP id
 p19mr1196281qvv.20.1632767131985; Mon, 27 Sep 2021 11:25:31 -0700 (PDT)
Date:   Mon, 27 Sep 2021 11:25:23 -0700
In-Reply-To: <20210927182523.2704818-1-weiwan@google.com>
Message-Id: <20210927182523.2704818-4-weiwan@google.com>
Mime-Version: 1.0
References: <20210927182523.2704818-1-weiwan@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH net-next 3/3] tcp: adjust rcv_ssthresh according to sk_reserved_mem
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Eric Dumazet <edumazet@google.com>
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
index 3166dc15d7d6..27743a97d6cb 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1418,6 +1418,17 @@ static inline int tcp_full_space(const struct sock *sk)
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
index a7611256f235..b79a571a752e 100644
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
 
@@ -5346,7 +5354,7 @@ static int tcp_prune_queue(struct sock *sk)
 	if (atomic_read(&sk->sk_rmem_alloc) >= sk->sk_rcvbuf)
 		tcp_clamp_window(sk);
 	else if (tcp_under_memory_pressure(sk))
-		tp->rcv_ssthresh = min(tp->rcv_ssthresh, 4U * tp->advmss);
+		tcp_adjust_rcv_ssthresh(sk);
 
 	if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf)
 		return 0;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6d72f3ea48c4..062d6cf13d06 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2969,8 +2969,7 @@ u32 __tcp_select_window(struct sock *sk)
 		icsk->icsk_ack.quick = 0;
 
 		if (tcp_under_memory_pressure(sk))
-			tp->rcv_ssthresh = min(tp->rcv_ssthresh,
-					       4U * tp->advmss);
+			tcp_adjust_rcv_ssthresh(sk);
 
 		/* free_space might become our new window, make sure we don't
 		 * increase it due to wscale.
-- 
2.33.0.685.g46640cef36-goog

