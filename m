Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CD51CF636
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 15:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgELNyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 09:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbgELNyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 09:54:35 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70F8C061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 06:54:34 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id z8so14142903qtu.17
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 06:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=H0ruRKFdAwDUkuK9CA84oNXddMkdhyP4tCO1rBRFjkM=;
        b=cJfj3zd/Zg3OO5u7MHnOCs90Jo+gZ9OhIPXlJQGfX2H6d6soyOA6guN6U+DLDKQDSn
         NsnxZ2DjulD8ft3ZaUaeX4UsV+VhGgSiGUKOK2l9K7VuZ6AXja5/TtHxDePFGEs8Wyq6
         6vv8vHFRU4VhqzBquj88byrvpoZxn1qFRDSfO3GrIT/Jhb8Iei7oJMTU64N/AQdyZzQD
         KJH2XeSjH9LfoDR0Ays/tor3pOXMEbZgigv+lA1OKP8z80XpzMjbGDcLK8UHeW6vIrHu
         a1j/LYYlWS7R6hhFUtTbUzxlBzfFOaXvYFGSjLquGyTF9YYuzuhpRiPByEK1FlSVCyI6
         Wd8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=H0ruRKFdAwDUkuK9CA84oNXddMkdhyP4tCO1rBRFjkM=;
        b=nJjHPN/mTs8udzDxVHa1PhyOvdGHAm8JtPlvWBJWKHeAonUsOk2fKkVQQFuaR54xKZ
         v+jyUtVsjttwakT6CJYy8YgPKfblXpnKS1jkYvctvZYU2g+aYSeQ86+iCeTfNlb2UgpS
         Rbz6dBO28tdNEfD5V59w8a2s67f+UqTP5Rhw6ieSYaWBebaqTNb3flLFcOBHV6BcbUyH
         q9BmcXmNfBaJDI5pe6M5WxPaHUUAO/Qmt/w/i3GGJZ4a9vlAB57o6CGiSDlPcIp6fCJI
         yHKw43jb2PI5kzy+J8p+S8JTYifjQU0oyo983WLx1yWitHSjSiyHF6b5sDLNpEwR3CXj
         07+g==
X-Gm-Message-State: AGi0PuZ4S5g9Aq6Bmj5YAt30CcL1eZLJ5MMhuD60bvTzqdv/vhrTjbrv
        pMg6kLTyjdgok80/qqANg0MEkU1vo1/XCw==
X-Google-Smtp-Source: APiQypLbi7ESoDFYP6Wg+EIu2OVUY5FxYyykbAPb4tvUV1eXkE5We9qmhWNY+9gjiTSTGZTkvRczZ9Lx0yMf4Q==
X-Received: by 2002:a0c:f50a:: with SMTP id j10mr19928883qvm.172.1589291674078;
 Tue, 12 May 2020 06:54:34 -0700 (PDT)
Date:   Tue, 12 May 2020 06:54:30 -0700
Message-Id: <20200512135430.201113-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
Subject: [PATCH net] tcp: fix SO_RCVLOWAT hangs with fat skbs
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

We autotune rcvbuf whenever SO_RCVLOWAT is set to account for 100%
overhead in tcp_set_rcvlowat()

This works well when skb->len/skb->truesize ratio is bigger than 0.5

But if we receive packets with small MSS, we can end up in a situation
where not enough bytes are available in the receive queue to satisfy
RCVLOWAT setting.
As our sk_rcvbuf limit is hit, we send zero windows in ACK packets,
preventing remote peer from sending more data.

Even autotuning does not help, because it only triggers at the time
user process drains the queue. If no EPOLLIN is generated, this
can not happen.

Note poll() has a similar issue, after commit
c7004482e8dc ("tcp: Respect SO_RCVLOWAT in tcp_poll().")

Fixes: 03f45c883c6f ("tcp: avoid extra wakeups for SO_RCVLOWAT users")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h    | 13 +++++++++++++
 net/ipv4/tcp.c       | 14 +++++++++++---
 net/ipv4/tcp_input.c |  3 ++-
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 64f84683feaede11fa0789baad277e2b4655ec7a..6f8e60c6fbc746ea7ed2c2ddc97bffdbb7da4fc1 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1420,6 +1420,19 @@ static inline int tcp_full_space(const struct sock *sk)
 	return tcp_win_from_space(sk, READ_ONCE(sk->sk_rcvbuf));
 }
 
+/* We provision sk_rcvbuf around 200% of sk_rcvlowat.
+ * If 87.5 % (7/8) of the space has been consumed, we want to override
+ * SO_RCVLOWAT constraint, since we are receiving skbs with too small
+ * len/truesize ratio.
+ */
+static inline bool tcp_rmem_pressure(const struct sock *sk)
+{
+	int rcvbuf = READ_ONCE(sk->sk_rcvbuf);
+	int threshold = rcvbuf - (rcvbuf >> 3);
+
+	return atomic_read(&sk->sk_rmem_alloc) > threshold;
+}
+
 extern void tcp_openreq_init_rwin(struct request_sock *req,
 				  const struct sock *sk_listener,
 				  const struct dst_entry *dst);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e72bd651d21acff036b856c1050bd86c31c468a0..a385fcaaa03beed9bfeabdebc12371e34e0649de 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -476,9 +476,17 @@ static void tcp_tx_timestamp(struct sock *sk, u16 tsflags)
 static inline bool tcp_stream_is_readable(const struct tcp_sock *tp,
 					  int target, struct sock *sk)
 {
-	return (READ_ONCE(tp->rcv_nxt) - READ_ONCE(tp->copied_seq) >= target) ||
-		(sk->sk_prot->stream_memory_read ?
-		sk->sk_prot->stream_memory_read(sk) : false);
+	int avail = READ_ONCE(tp->rcv_nxt) - READ_ONCE(tp->copied_seq);
+
+	if (avail > 0) {
+		if (avail >= target)
+			return true;
+		if (tcp_rmem_pressure(sk))
+			return true;
+	}
+	if (sk->sk_prot->stream_memory_read)
+		return sk->sk_prot->stream_memory_read(sk);
+	return false;
 }
 
 /*
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index b996dc1069c53ead2e1f3552716a6cd427942afd..29c6fc8c7716881ec37ad08fbd3497747b9350fe 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4757,7 +4757,8 @@ void tcp_data_ready(struct sock *sk)
 	const struct tcp_sock *tp = tcp_sk(sk);
 	int avail = tp->rcv_nxt - tp->copied_seq;
 
-	if (avail < sk->sk_rcvlowat && !sock_flag(sk, SOCK_DONE))
+	if (avail < sk->sk_rcvlowat && !tcp_rmem_pressure(sk) &&
+	    !sock_flag(sk, SOCK_DONE))
 		return;
 
 	sk->sk_data_ready(sk);
-- 
2.26.2.645.ge9eca65c58-goog

