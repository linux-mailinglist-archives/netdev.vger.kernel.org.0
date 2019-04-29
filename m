Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED035ECEC
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbfD2Wqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:46:51 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:38190 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729662AbfD2Wqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 18:46:50 -0400
Received: by mail-qk1-f201.google.com with SMTP id 207so10327996qkn.5
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 15:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3+Hd/aLkQCBenZcRu1M3X4LM1hnWgsN1iWwgP2ItfZI=;
        b=lOBHMYss8deJ5jd4JggcZdzDKKYtHyU8X6kK8IgtiR6zjaaIU9ML/5lOPRrFIKEXCQ
         tU8DaajSgV9fjuW6zQL61qWCbpFPLkAhuJzJEQu8XVyi8VNxaPsF+I+L3gobU/7NQ3dG
         vwsC85JGw5C5HBFQQFW/gu2+knZjrPaMIzY/Rx8GTl53n8IPTXOh9m9LCmTkhWXoQszk
         CyMau1MxtN0OGTFX3UmQnVL10AXCHQSftIDxHHADGF/i3jI/uuitwrBML7pWZXIXuQUF
         AyH0E7vObTXm9OT+dI+DM2I9R47/n7JVaY68yVO1Fy/KR/SA84kVwzkvG/5wFzOQ6zmz
         fBfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3+Hd/aLkQCBenZcRu1M3X4LM1hnWgsN1iWwgP2ItfZI=;
        b=V61OyW3P7rOyHUJOBwc6zdAqKJa8BJCVHAibsVgM73vSx4+AF1TTg0zW+1AKVej7V3
         Xf4Ei+nHkH+dQBtWi+/8adT8/lfK6nrztGoVqz0J2jby2F/sQuadMYZ2kDbFvoLMbsod
         IlwqpMHvDR2KYzgyIHqYWv+X777GRBbYKLH/g8hH+46wOuG6gKM0hj07O3e9Hx+C4vPZ
         eIJDz7OjSj9C9WkLEqqZG90Cc0AIibD+wErjScWXsiPSaiqjgxdnTEnIceWGFHs/9p7q
         5YwlLUST1VAZ2cs9XX6t0B5txfEY+hS74foERxAwl/1OgBTZpN25NJYGjz1BKobpEO1M
         Dptw==
X-Gm-Message-State: APjAAAW1vy2FYzJKGTMLQWPlD3v5iX3IXGcVnfWQrS63O9BdEOmWSE7g
        FoSaadWytp+ib4i4S9H5+eBKUyqTNzU=
X-Google-Smtp-Source: APXvYqwj2bHvrVoVBWvvThc8IFu85ICbvFhPHjQw6tYveY+0Fre5FlajUDWDmIlYCPbyEPmIrS+ODZ6qgsk=
X-Received: by 2002:a0c:c950:: with SMTP id v16mr15718977qvj.152.1556578008896;
 Mon, 29 Apr 2019 15:46:48 -0700 (PDT)
Date:   Mon, 29 Apr 2019 15:46:20 -0700
In-Reply-To: <20190429224620.151064-1-ycheng@google.com>
Message-Id: <20190429224620.151064-9-ycheng@google.com>
Mime-Version: 1.0
References: <20190429224620.151064-1-ycheng@google.com>
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
Subject: [PATCH net-next 8/8] tcp: refactor setting the initial congestion window
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net, edumazet@google.com
Cc:     netdev@vger.kernel.org, ncardwell@google.com, soheil@google.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Relocate the congestion window initialization from tcp_init_metrics()
to tcp_init_transfer() to improve code readability.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c         | 12 ------------
 net/ipv4/tcp_input.c   | 26 ++++++++++++++++++++++++++
 net/ipv4/tcp_metrics.c | 10 ----------
 3 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f7567a3698eb..1fa15beb8380 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -457,18 +457,6 @@ void tcp_init_sock(struct sock *sk)
 }
 EXPORT_SYMBOL(tcp_init_sock);
 
-void tcp_init_transfer(struct sock *sk, int bpf_op)
-{
-	struct inet_connection_sock *icsk = inet_csk(sk);
-
-	tcp_mtup_init(sk);
-	icsk->icsk_af_ops->rebuild_header(sk);
-	tcp_init_metrics(sk);
-	tcp_call_bpf(sk, bpf_op, 0, NULL);
-	tcp_init_congestion_control(sk);
-	tcp_init_buffer_space(sk);
-}
-
 static void tcp_tx_timestamp(struct sock *sk, u16 tsflags)
 {
 	struct sk_buff *skb = tcp_write_queue_tail(sk);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 706a99ec73f6..077d9abdfcf5 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5647,6 +5647,32 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 }
 EXPORT_SYMBOL(tcp_rcv_established);
 
+void tcp_init_transfer(struct sock *sk, int bpf_op)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	tcp_mtup_init(sk);
+	icsk->icsk_af_ops->rebuild_header(sk);
+	tcp_init_metrics(sk);
+
+	/* Initialize the congestion window to start the transfer.
+	 * Cut cwnd down to 1 per RFC5681 if SYN or SYN-ACK has been
+	 * retransmitted. In light of RFC6298 more aggressive 1sec
+	 * initRTO, we only reset cwnd when more than 1 SYN/SYN-ACK
+	 * retransmission has occurred.
+	 */
+	if (tp->total_retrans > 1 && tp->undo_marker)
+		tp->snd_cwnd = 1;
+	else
+		tp->snd_cwnd = tcp_init_cwnd(tp, __sk_dst_get(sk));
+	tp->snd_cwnd_stamp = tcp_jiffies32;
+
+	tcp_call_bpf(sk, bpf_op, 0, NULL);
+	tcp_init_congestion_control(sk);
+	tcp_init_buffer_space(sk);
+}
+
 void tcp_finish_connect(struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index d4d687330e2b..c4848e7a0aad 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -512,16 +512,6 @@ void tcp_init_metrics(struct sock *sk)
 
 		inet_csk(sk)->icsk_rto = TCP_TIMEOUT_FALLBACK;
 	}
-	/* Cut cwnd down to 1 per RFC5681 if SYN or SYN-ACK has been
-	 * retransmitted. In light of RFC6298 more aggressive 1sec
-	 * initRTO, we only reset cwnd when more than 1 SYN/SYN-ACK
-	 * retransmission has occurred.
-	 */
-	if (tp->total_retrans > 1 && tp->undo_marker)
-		tp->snd_cwnd = 1;
-	else
-		tp->snd_cwnd = tcp_init_cwnd(tp, dst);
-	tp->snd_cwnd_stamp = tcp_jiffies32;
 }
 
 bool tcp_peer_is_proven(struct request_sock *req, struct dst_entry *dst)
-- 
2.21.0.593.g511ec345e18-goog

