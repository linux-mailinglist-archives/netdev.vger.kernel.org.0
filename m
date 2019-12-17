Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF01312222C
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 03:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfLQCvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 21:51:08 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:50758 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfLQCvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 21:51:07 -0500
Received: by mail-pj1-f73.google.com with SMTP id e5so5641373pjr.17
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 18:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=nu9gySL5m0Kb0igy+KeuP4w9+RzXKH6C2Y3nSI8p9+I=;
        b=BHJ1U4XDzP96eZTtMyQsycKTf/stjJBjN9wk4abttxftuOFvHLJYNpHNlJAcJoDc+W
         B8YZNEGANZMfHL9gJ8hIN9QtLWqdSfb5aflO8EOfXEmSll619TuYdOj4Bj7OU4gGCgQx
         LaecmfKjwjWYZPaA9l0SWzQbzrKuLZGYFrL3v+cw2fO/s28y7l1Xx5NztRLXeYGXrvSN
         YRtNRSiNrCZURqMwwEUSXVJA2GdabOXCu0MV+Q5NQDHwCLxeILd4MhvkhWa/pLZLCX9A
         jhpXgjaX1u0Q2UT5d4AW96IdPUPWpLbi6cpGSS6EItQfDkujTwKBABtlzN5BwcdTvDmz
         JmRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=nu9gySL5m0Kb0igy+KeuP4w9+RzXKH6C2Y3nSI8p9+I=;
        b=Y3BAStuQtj1fTwkTPZM1WhpPWb7UYBIgWOejqLGTdDj6Dw+VLftn4fY5xyuJa2Jj/c
         X+jENgKIyVaxiputJ3ubectlnMbqve1lqm6v4ifkLpVOxxcxs5jEAs5JcRqf3CpQSMy5
         NJnAxGLuHnSWM3PhvMsfWLffohv/22ovaAZ9Fw/VsciMuUbF49qzPzsxfWSNtguHuWLY
         PSyRiTKZEe8mOSECfrOj6b+Qhrh2n/oIWIkFnr8A/6pPGZx9xihNAtYbmukLmOMlWPaL
         PJGCMTbdPmasmAT8y9NwQzw0luE5nx8rPJynBIK+uePId62f5FV5i89oCvBF38dpoTWg
         s3cA==
X-Gm-Message-State: APjAAAXGdAPeuEZK17meZJ+5bArrRt+EhXR+KcmU920p/h5gIbItVo+f
        TgJjzqdhgdVnTmBVvFrlVHTBaX3ms5xepA==
X-Google-Smtp-Source: APXvYqzhgXkp65GBDfBTSj2UVdFKqMY9POvyEPlP72MQVEBk72q7/+IULv+XGt3HMJefTxudi2gVX8bKugZWWg==
X-Received: by 2002:a63:5b59:: with SMTP id l25mr22866504pgm.382.1576551066708;
 Mon, 16 Dec 2019 18:51:06 -0800 (PST)
Date:   Mon, 16 Dec 2019 18:51:03 -0800
Message-Id: <20191217025103.252578-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net] net: annotate lockless accesses to sk->sk_pacing_shift
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk->sk_pacing_shift can be read and written without lock
synchronization. This patch adds annotations to
document this fact and avoid future syzbot complains.

This might also avoid unexpected false sharing
in sk_pacing_shift_update(), as the compiler
could remove the conditional check and always
write over sk->sk_pacing_shift :

if (sk->sk_pacing_shift != val)
	sk->sk_pacing_shift = val;

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h    | 4 ++--
 net/core/sock.c       | 2 +-
 net/ipv4/tcp_bbr.c    | 3 ++-
 net/ipv4/tcp_output.c | 4 ++--
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 87d54ef57f0040fd7bbd4344db0d3af7e6f6d992..09d56673c9e7fbe85699b07aa1e52f715632678b 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2583,9 +2583,9 @@ static inline int sk_get_rmem0(const struct sock *sk, const struct proto *proto)
  */
 static inline void sk_pacing_shift_update(struct sock *sk, int val)
 {
-	if (!sk || !sk_fullsock(sk) || sk->sk_pacing_shift == val)
+	if (!sk || !sk_fullsock(sk) || READ_ONCE(sk->sk_pacing_shift) == val)
 		return;
-	sk->sk_pacing_shift = val;
+	WRITE_ONCE(sk->sk_pacing_shift, val);
 }
 
 /* if a socket is bound to a device, check that the given device
diff --git a/net/core/sock.c b/net/core/sock.c
index 043db3ce023e592e9f1b6602376097c28f529cfd..8459ad579f735ce724b559f7114d1b77f360e5b2 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2916,7 +2916,7 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 
 	sk->sk_max_pacing_rate = ~0UL;
 	sk->sk_pacing_rate = ~0UL;
-	sk->sk_pacing_shift = 10;
+	WRITE_ONCE(sk->sk_pacing_shift, 10);
 	sk->sk_incoming_cpu = -1;
 
 	sk_rx_queue_clear(sk);
diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index 32772d6ded4ed359aa4d09ba67071e88a79ebdeb..a6545ef0d27b66d310b02affe14f41ab536243eb 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -306,7 +306,8 @@ static u32 bbr_tso_segs_goal(struct sock *sk)
 	/* Sort of tcp_tso_autosize() but ignoring
 	 * driver provided sk_gso_max_size.
 	 */
-	bytes = min_t(unsigned long, sk->sk_pacing_rate >> sk->sk_pacing_shift,
+	bytes = min_t(unsigned long,
+		      sk->sk_pacing_rate >> READ_ONCE(sk->sk_pacing_shift),
 		      GSO_MAX_SIZE - 1 - MAX_TCP_HEADER);
 	segs = max_t(u32, bytes / tp->mss_cache, bbr_min_tso_segs(sk));
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index b184f03d743715ef4b2d166ceae651529be77953..e5a0071039e1cc0f86cc14e168ec3ab3be8cf864 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1725,7 +1725,7 @@ static u32 tcp_tso_autosize(const struct sock *sk, unsigned int mss_now,
 	u32 bytes, segs;
 
 	bytes = min_t(unsigned long,
-		      sk->sk_pacing_rate >> sk->sk_pacing_shift,
+		      sk->sk_pacing_rate >> READ_ONCE(sk->sk_pacing_shift),
 		      sk->sk_gso_max_size - 1 - MAX_TCP_HEADER);
 
 	/* Goal is to send at least one packet per ms,
@@ -2260,7 +2260,7 @@ static bool tcp_small_queue_check(struct sock *sk, const struct sk_buff *skb,
 
 	limit = max_t(unsigned long,
 		      2 * skb->truesize,
-		      sk->sk_pacing_rate >> sk->sk_pacing_shift);
+		      sk->sk_pacing_rate >> READ_ONCE(sk->sk_pacing_shift));
 	if (sk->sk_pacing_status == SK_PACING_NONE)
 		limit = min_t(unsigned long, limit,
 			      sock_net(sk)->ipv4.sysctl_tcp_limit_output_bytes);
-- 
2.24.1.735.g03f4e72817-goog

