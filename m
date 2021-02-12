Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED3831A843
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 00:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbhBLXXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 18:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbhBLXXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 18:23:05 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F9CC0613D6
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 15:22:25 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id b8so613898plh.12
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 15:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HQFoYYRpVCfzGnqKCG9yNHIeFisJB8uMhi3j26ItGgI=;
        b=CgKV1TAwl3VHHsQeq/QrQz96zfCPn9jIptQ8Fw1UhxDbP46lHs+NNTGlTsLA5j0YJi
         ZmesZbYow3EiTjxV2qIRYBK6uCVUkTl9MJ40Jy4NUMNWwVm+DKdEnI5o3H4Bv4aexThf
         IL8bcBZhSX8C8DieHJFVe1aaImfv4SKmkMMla4to8Nf8JRDP2mOKLQrGo4H38AJMn8qE
         OV/d35VNA02X+r4UDrpZY3H6LL8rjb+r2vWTkuKMB1TvD4664rJj7LcKWIGw/mwLQn24
         Ppx+78WwiHIDvx/nSxzeurr1segVJmV89PuBRdSImko1juQaIf2QTnNAyjhN3ugkUKXC
         f4OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HQFoYYRpVCfzGnqKCG9yNHIeFisJB8uMhi3j26ItGgI=;
        b=npMHnVgu6qWGeHG5V2C4XopihjU966HAxvgWiIzoplg18wAslTOEIv1DqRjbKg0I+5
         cEqdiv5Ew2ZpvfSUT6THzQuXQcbdA+n8xJjJ1JkH/8WXxs7vshEiVPyy596AFhtoqUQ/
         U2Z9nuwS7s9EgjOZFYmmk6q2yUIJxOv6k9yJI8i8FRhbkhO+qDrer8fVeU+cEDIlae/e
         XP7OHXxiWyi+PF/5MMWiIdsElQSnWXbmwouT23ytnKiUrtuJHD3DnrKsnEwoLMcMzvjj
         rHhHJ+/gd0gogOuc/gq5NDEy7an7Nq85s8VchHk0coVjFmDtVWFt5bpX8yYydWUYZfmW
         5d7g==
X-Gm-Message-State: AOAM532ecAPkxdI8j7fQxh2r0cnfKFCV9W7APq3V0ea+t4YfcPavrxK0
        MCVq92grlh73y7Y8Yzwwd10=
X-Google-Smtp-Source: ABdhPJw2r2xxTYzfozTB7qEcukpHbyfTDPA2+O72cjTZv18shLJ7JIGcx5NK/rYXBLOvgNGLmy233Q==
X-Received: by 2002:a17:90b:1b50:: with SMTP id nv16mr4584602pjb.153.1613172144597;
        Fri, 12 Feb 2021 15:22:24 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:449f:1ef7:3640:824a])
        by smtp.gmail.com with ESMTPSA id f7sm9160614pjh.45.2021.02.12.15.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 15:22:24 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Arjun Roy <arjunroy@google.com>, Wei Wang <weiwan@google.com>
Subject: [PATCH net-next 2/2] tcp: factorize logic into tcp_epollin_ready()
Date:   Fri, 12 Feb 2021 15:22:14 -0800
Message-Id: <20210212232214.2869897-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
In-Reply-To: <20210212232214.2869897-1-eric.dumazet@gmail.com>
References: <20210212232214.2869897-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Both tcp_data_ready() and tcp_stream_is_readable() share the same logic.

Add tcp_epollin_ready() helper to avoid duplication.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Wei Wang <weiwan@google.com>
---
 include/net/tcp.h    | 12 ++++++++++++
 net/ipv4/tcp.c       | 16 ++++------------
 net/ipv4/tcp_input.c | 11 ++---------
 3 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 244208f6f6c2ace87920b633e469421f557427a6..484eb2362645fd478f59b26b42457ecf4510eb14 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1442,6 +1442,18 @@ static inline bool tcp_rmem_pressure(const struct sock *sk)
 	return atomic_read(&sk->sk_rmem_alloc) > threshold;
 }
 
+static inline bool tcp_epollin_ready(const struct sock *sk, int target)
+{
+	const struct tcp_sock *tp = tcp_sk(sk);
+	int avail = READ_ONCE(tp->rcv_nxt) - READ_ONCE(tp->copied_seq);
+
+	if (avail <= 0)
+		return false;
+
+	return (avail >= target) || tcp_rmem_pressure(sk) ||
+	       (tcp_receive_window(tp) <= inet_csk(sk)->icsk_ack.rcv_mss);
+}
+
 extern void tcp_openreq_init_rwin(struct request_sock *req,
 				  const struct sock *sk_listener,
 				  const struct dst_entry *dst);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 9896ca10bb340924b779cb6a7606d57fdd5c3357..7a6b58ae408d1fb1e5536ccfed8215be123f3b57 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -481,19 +481,11 @@ static void tcp_tx_timestamp(struct sock *sk, u16 tsflags)
 	}
 }
 
-static inline bool tcp_stream_is_readable(const struct tcp_sock *tp,
-					  int target, struct sock *sk)
+static bool tcp_stream_is_readable(struct sock *sk, int target)
 {
-	int avail = READ_ONCE(tp->rcv_nxt) - READ_ONCE(tp->copied_seq);
+	if (tcp_epollin_ready(sk, target))
+		return true;
 
-	if (avail > 0) {
-		if (avail >= target)
-			return true;
-		if (tcp_rmem_pressure(sk))
-			return true;
-		if (tcp_receive_window(tp) <= inet_csk(sk)->icsk_ack.rcv_mss)
-			return true;
-	}
 	if (sk->sk_prot->stream_memory_read)
 		return sk->sk_prot->stream_memory_read(sk);
 	return false;
@@ -568,7 +560,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 		    tp->urg_data)
 			target++;
 
-		if (tcp_stream_is_readable(tp, target, sk))
+		if (tcp_stream_is_readable(sk, target))
 			mask |= EPOLLIN | EPOLLRDNORM;
 
 		if (!(sk->sk_shutdown & SEND_SHUTDOWN)) {
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index a8f8f98159531e5d1c80660972148986f6acd20a..e32a7056cb7640c67ef2d6a4d9484684d2602fcd 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4924,15 +4924,8 @@ int tcp_send_rcvq(struct sock *sk, struct msghdr *msg, size_t size)
 
 void tcp_data_ready(struct sock *sk)
 {
-	const struct tcp_sock *tp = tcp_sk(sk);
-	int avail = tp->rcv_nxt - tp->copied_seq;
-
-	if (avail < sk->sk_rcvlowat && !tcp_rmem_pressure(sk) &&
-	    !sock_flag(sk, SOCK_DONE) &&
-	    tcp_receive_window(tp) > inet_csk(sk)->icsk_ack.rcv_mss)
-		return;
-
-	sk->sk_data_ready(sk);
+	if (tcp_epollin_ready(sk, sk->sk_rcvlowat))
+		sk->sk_data_ready(sk);
 }
 
 static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
-- 
2.30.0.478.g8a0d178c01-goog

