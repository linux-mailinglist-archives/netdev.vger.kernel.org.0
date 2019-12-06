Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0663115714
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 19:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfLFSUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 13:20:21 -0500
Received: from mail-yb1-f201.google.com ([209.85.219.201]:45418 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfLFSUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 13:20:21 -0500
Received: by mail-yb1-f201.google.com with SMTP id e11so5834983ybn.12
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 10:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=h3doiQ6jnOTBdPQIr0JbngwOXKSG9/1I9MWow1YzCz0=;
        b=r8LCpsgs4idJQ2Pn4wj2++ZTB5vul0ZwbhDP9dCVok2Hrz6NA72gv8+CaKIhWEuo1X
         OtZEl6Qk8kQnJ85tZMsZOknNh5S99wZOOlJEUY4b6+NChY69SegtckUqLU1VN4GaqlrT
         QMwhIMOeczkEy9W1YrZOeKoxkdG7Lsw1HVGayfVoRbRuG3gFtRNhch4G66NH/Lsun52a
         CfGNU+Pqc6SXkDW1t6VuNUdeVHryNGxWNxDE8pvOqHJuxKDO41IYwCsY8s1tWy9kc8xd
         me0BGYOuPbQNu2rP+Z0N74xMmI9dkWTfAu8aFpxXALYQSZ4NxXs20F0gOqWhIVvK1vC+
         WG3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=h3doiQ6jnOTBdPQIr0JbngwOXKSG9/1I9MWow1YzCz0=;
        b=b8AGHgI+7ncCrUwC4rf0cH4JezwMdYQr9G8hrBUSncwCJQPpgPjNS/6Z1jPhJ67T8K
         QNohiqQTXIPoFnC74ot1JaROFu5EbpRdEfdbJ0UPZ4SW0QAmalmxrkHac7bEHytxflG9
         LUkpqb54n7ZrlNuYQxz0K5MsaLJTEWT+BWkqmc9J+jYfpIi/LgKxWgHEL35qBvUyd4y1
         hRt4pDnH8fLZLnFpy/JlLMJin8M7+6YR0Nub6mW6DoQhx5PNOhv7h3Ettn1k+33wB1wC
         dlqFwKgIeWETFIR1+hdS4PFCvLgtRW2y1JKGDto5UN1tUFOCd+1SIN8GPkH4ToJ4Tg6R
         x1pQ==
X-Gm-Message-State: APjAAAWjVOYtW+Ig2SnN/75Q4Bm9KtNYxD4aNA1sH+BWbpLqc3LLO4D9
        IBPz8AL3Lm+lR3X7Hj9/ve+E3uZ+WFnchg==
X-Google-Smtp-Source: APXvYqxH1c6ctR0TlKtA/dq+OdFXeJht7I9n4uNxNSeT99IufffWu4ty3X36UtASmbtMKl2iMIaqs8MYO0W7rg==
X-Received: by 2002:a0d:e003:: with SMTP id j3mr10175209ywe.322.1575656420306;
 Fri, 06 Dec 2019 10:20:20 -0800 (PST)
Date:   Fri,  6 Dec 2019 10:20:16 -0800
Message-Id: <20191206182016.137529-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH v4.14] tcp: exit if nothing to retransmit on RTO timeout
From:   Eric Dumazet <edumazet@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two upstream commits squashed together for v4.14 stable :

 commit 88f8598d0a302a08380eadefd09b9f5cb1c4c428 upstream.

  Previously TCP only warns if its RTO timer fires and the
  retransmission queue is empty, but it'll cause null pointer
  reference later on. It's better to avoid such catastrophic failure
  and simply exit with a warning.

Squashed with "tcp: refactor tcp_retransmit_timer()" :

 commit 0d580fbd2db084a5c96ee9c00492236a279d5e0f upstream.

  It appears linux-4.14 stable needs a backport of commit
  88f8598d0a30 ("tcp: exit if nothing to retransmit on RTO timeout")

  Since tcp_rtx_queue_empty() is not in pre 4.15 kernels,
  let's refactor tcp_retransmit_timer() to only use tcp_rtx_queue_head()

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/tcp_timer.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 592d6e9967a916076ffcab37857d703c1567d7df..95dca02f8c4fc0154016b8bc5ee027fcc19e1061 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -413,6 +413,7 @@ void tcp_retransmit_timer(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct net *net = sock_net(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
+	struct sk_buff *skb;
 
 	if (tp->fastopen_rsk) {
 		WARN_ON_ONCE(sk->sk_state != TCP_SYN_RECV &&
@@ -423,10 +424,13 @@ void tcp_retransmit_timer(struct sock *sk)
 		 */
 		return;
 	}
+
 	if (!tp->packets_out)
-		goto out;
+		return;
 
-	WARN_ON(tcp_write_queue_empty(sk));
+	skb = tcp_rtx_queue_head(sk);
+	if (WARN_ON_ONCE(!skb))
+		return;
 
 	tp->tlp_high_seq = 0;
 
@@ -459,7 +463,7 @@ void tcp_retransmit_timer(struct sock *sk)
 			goto out;
 		}
 		tcp_enter_loss(sk);
-		tcp_retransmit_skb(sk, tcp_write_queue_head(sk), 1);
+		tcp_retransmit_skb(sk, skb, 1);
 		__sk_dst_reset(sk);
 		goto out_reset_timer;
 	}
-- 
2.24.0.393.g34dc348eaf-goog

