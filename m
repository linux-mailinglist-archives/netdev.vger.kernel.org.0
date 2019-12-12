Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02C3711D831
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 21:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730975AbfLLUzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 15:55:47 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:48411 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730860AbfLLUzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 15:55:47 -0500
Received: by mail-pg1-f202.google.com with SMTP id c8so4842pgl.15
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 12:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XwTT7BwYBU+Ltpe3P2LwfTj6gh4SU3larayRNS5W3rM=;
        b=ZXRiSmvAsk7byV3bCC0hNWh7HrGRCTSmPdXZ8mBdVZkHJ+gRTBazqpTKZNqrHeiXwn
         1Hp+m6S1HYPfO4evHZ1lyACG2tMjiI4LrjnRMHWahMVMp8gGvnyJ5jVTKbG+CQKFqZN9
         22dTc8D44uk9zBTY7pch3xW+T+eU1XGnxjEaSBkigoHUGjmBBcNiTU4HoBl8Gbxa/5+/
         HMdwBj9+Rt2ImXmATD7+jairPSwXu9KPFAJ0AiEBK+MD/kluIjuR6drw1YEYQVVzDnec
         F6wi3jjIhSzYyE68Jt5e9/Iun9Iz8QbLy6MlUIuCnm4F04qFXDGO6x1GNhS+STOpNEtJ
         OOZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XwTT7BwYBU+Ltpe3P2LwfTj6gh4SU3larayRNS5W3rM=;
        b=pNu/joJPmc1t6eMc1Ei/6RuwVL7WiKRES+d8KSBkEX6/okaUZweA5iakFGcaid8wbT
         SDesNSUop11a+/n771HP30hWrjFEOyP4wmEpK0H2drz+zM0fIamOaeYc6LEosOgbEkhS
         r0vgMuqE5Je5pDiqGAZz5H9OF7JrGG9TvwwxykP2ScJxY6+7f+BcTVuuJnBVEVMSoDR1
         dtx8v4tGwe8OgSl6KbeO8taYP0B0J6hNt+syqisOZxFdPfDtJNtcMTGyz+IaQohKgOh+
         LCWjNvOs9rGveGrhPGrwLxjom1kIDowQy2t6QsasOlVAMPWbQlcz8BKMxePyfYd3OO9E
         PWNQ==
X-Gm-Message-State: APjAAAXF8mbA5NdufLdhoOOgaXyrPwPq43VoFcsvxY67FhoNK5YNtL8x
        ol9smF2IAksdAZJJ2hFgz941jIrSw/w6+g==
X-Google-Smtp-Source: APXvYqx+SUnWnhKiKfM8uJEeYsKHCAf1mWgjC9bl7zXYiByyH5cubm8ld+U0bRc2a4JaK6AJMin8iBgaDzsVdg==
X-Received: by 2002:a63:130a:: with SMTP id i10mr11722527pgl.199.1576184146438;
 Thu, 12 Dec 2019 12:55:46 -0800 (PST)
Date:   Thu, 12 Dec 2019 12:55:30 -0800
In-Reply-To: <20191212205531.213908-1-edumazet@google.com>
Message-Id: <20191212205531.213908-3-edumazet@google.com>
Mime-Version: 1.0
References: <20191212205531.213908-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net 2/3] tcp: refine tcp_write_queue_empty() implementation
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Jason Baron <jbaron@akamai.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to how tcp_sendmsg() is implemented, we can have an empty
skb at the tail of the write queue.

Most [1] tcp_write_queue_empty() callers want to know if there is
anything to send (payload and/or FIN)

Instead of checking if the sk_write_queue is empty, we need
to test if tp->write_seq == tp->snd_nxt

[1] tcp_send_fin() was the only caller that expected to
 see if an skb was in the write queue, I have changed the code
 to reuse the tcp_write_queue_tail() result.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
---
 include/net/tcp.h     | 11 ++++++++++-
 net/ipv4/tcp_output.c |  5 +++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 86b9a8766648824c0f122f6c01f55d59bd0d7d72..e460ea7f767ba627972a63a974cae80357808366 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1766,9 +1766,18 @@ static inline bool tcp_skb_is_last(const struct sock *sk,
 	return skb_queue_is_last(&sk->sk_write_queue, skb);
 }
 
+/**
+ * tcp_write_queue_empty - test if any payload (or FIN) is available in write queue
+ * @sk: socket
+ *
+ * Since the write queue can have a temporary empty skb in it,
+ * we must not use "return skb_queue_empty(&sk->sk_write_queue)"
+ */
 static inline bool tcp_write_queue_empty(const struct sock *sk)
 {
-	return skb_queue_empty(&sk->sk_write_queue);
+	const struct tcp_sock *tp = tcp_sk(sk);
+
+	return tp->write_seq == tp->snd_nxt;
 }
 
 static inline bool tcp_rtx_queue_empty(const struct sock *sk)
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 57f434a8e41ffd6bc584cb4d9e87703491a378c1..36902d08473ec7e45a654234b407217ee6c65fb1 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3129,7 +3129,7 @@ void sk_forced_mem_schedule(struct sock *sk, int size)
  */
 void tcp_send_fin(struct sock *sk)
 {
-	struct sk_buff *skb, *tskb = tcp_write_queue_tail(sk);
+	struct sk_buff *skb, *tskb, *tail = tcp_write_queue_tail(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	/* Optimization, tack on the FIN if we have one skb in write queue and
@@ -3137,6 +3137,7 @@ void tcp_send_fin(struct sock *sk)
 	 * Note: in the latter case, FIN packet will be sent after a timeout,
 	 * as TCP stack thinks it has already been transmitted.
 	 */
+	tskb = tail;
 	if (!tskb && tcp_under_memory_pressure(sk))
 		tskb = skb_rb_last(&sk->tcp_rtx_queue);
 
@@ -3144,7 +3145,7 @@ void tcp_send_fin(struct sock *sk)
 		TCP_SKB_CB(tskb)->tcp_flags |= TCPHDR_FIN;
 		TCP_SKB_CB(tskb)->end_seq++;
 		tp->write_seq++;
-		if (tcp_write_queue_empty(sk)) {
+		if (!tail) {
 			/* This means tskb was already sent.
 			 * Pretend we included the FIN on previous transmit.
 			 * We need to set tp->snd_nxt to the value it would have
-- 
2.24.1.735.g03f4e72817-goog

