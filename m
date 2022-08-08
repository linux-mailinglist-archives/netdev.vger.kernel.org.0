Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A739D58C211
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 05:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236927AbiHHDb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 23:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236423AbiHHDb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 23:31:26 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DB9B482;
        Sun,  7 Aug 2022 20:31:26 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-10ea30a098bso9244239fac.8;
        Sun, 07 Aug 2022 20:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z4AUHN+ek6dotH0Cp1UdVsz9yh9QJVLMXRKj8LAjmQE=;
        b=WbkucuJcwwyI7FHRb3HdCgnGUhbSm+bdcJM8EibgbMSRELHLqGyyJanCbMoxRmhtQZ
         5U9+wP9m74JH38RhNvZEDrcqnZXqlb6Hqza8tI1peGz0TBvf1X7+zsN5vz5JqDzBzNQM
         IqayEFm+foZDylpUEkKmsn8KTCtxdzAJI0ca7fh8FxPk2SuCOca28UmNj0DZBUsZPtcl
         vbirPyAAOoUGHOiJBpAouVKqcz/OoUl2oQeUty4Sh5ZfgHXAAXkC7SIsw3/5Laq0JDD9
         IeU0f9PivOO7K5Zb+nGo+BlLsBNlKL1aIdRr9kob6v4K8AJNnEH8XOsEFZWISfSG5Wh8
         zadg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z4AUHN+ek6dotH0Cp1UdVsz9yh9QJVLMXRKj8LAjmQE=;
        b=pSycDZBmZ4RWGGU6ROULMStRvwpRqAFVfanrnGX8u1/YXzRu8k4ZZLp6ND1And6cEG
         gOVLGTRYZTenGK78ncUfOfWSVNO7MiYbZDw2M9Lnh7oF0XGhyeHKHl0XAsR6OI/w5Ygq
         cNf8t8/jZFNoSakV0Yg5NTZN2vZ9gKiPakCW/lxjRZOBKqEzz6l2Vy2gsWrNbQ9WUKG0
         8EeCpyfQNp3UlwpYOazm/XHDd/oqvmA9EKf8Z7fVs2T5qdhWKlDoYn6l9Uu8bMEblga6
         Bh06WLRVc+9S98Q0WROv/XIHY/CjFyAUD3JFRnQ8wen36rd6txaSf9RNaw4I3PpeODaj
         JBig==
X-Gm-Message-State: ACgBeo0ewPbfFFkFHiIfBsBx7zOVL6410TTYJZVx+pggwyFfd4y0vlyk
        TrAroKh9Gr1FZIRO/UJHAQwsZoYzpvY=
X-Google-Smtp-Source: AA6agR7y72mPLXM3Qz8u6Bh9Z5Ye80VEIDfCBgE/fkypJiPUXhqU1gIGP+XNgUL9/kf2zwJemRHH0g==
X-Received: by 2002:a05:6871:8f:b0:116:861f:2684 with SMTP id u15-20020a056871008f00b00116861f2684mr14822oaa.70.1659929484621;
        Sun, 07 Aug 2022 20:31:24 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:ad03:d88f:99fe:9487])
        by smtp.gmail.com with ESMTPSA id k39-20020a4a94aa000000b00425806a20f5sm1945138ooi.3.2022.08.07.20.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Aug 2022 20:31:24 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch net v2 2/4] tcp: fix tcp_cleanup_rbuf() for tcp_read_skb()
Date:   Sun,  7 Aug 2022 20:31:04 -0700
Message-Id: <20220808033106.130263-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220808033106.130263-1-xiyou.wangcong@gmail.com>
References: <20220808033106.130263-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

tcp_cleanup_rbuf() retrieves the skb from sk_receive_queue, it
assumes the skb is not yet dequeued. This is no longer true for
tcp_read_skb() case where we dequeue the skb first.

Fix this by introducing a helper __tcp_cleanup_rbuf() which does
not require any skb and calling it in tcp_read_skb().

Fixes: 04919bed948d ("tcp: Introduce tcp_read_skb()")
Cc: Eric Dumazet <edumazet@google.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/ipv4/tcp.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 05da5cac080b..181a0d350123 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1567,17 +1567,11 @@ static int tcp_peek_sndq(struct sock *sk, struct msghdr *msg, int len)
  * calculation of whether or not we must ACK for the sake of
  * a window update.
  */
-void tcp_cleanup_rbuf(struct sock *sk, int copied)
+static void __tcp_cleanup_rbuf(struct sock *sk, int copied)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	bool time_to_ack = false;
 
-	struct sk_buff *skb = skb_peek(&sk->sk_receive_queue);
-
-	WARN(skb && !before(tp->copied_seq, TCP_SKB_CB(skb)->end_seq),
-	     "cleanup rbuf bug: copied %X seq %X rcvnxt %X\n",
-	     tp->copied_seq, TCP_SKB_CB(skb)->end_seq, tp->rcv_nxt);
-
 	if (inet_csk_ack_scheduled(sk)) {
 		const struct inet_connection_sock *icsk = inet_csk(sk);
 
@@ -1623,6 +1617,17 @@ void tcp_cleanup_rbuf(struct sock *sk, int copied)
 		tcp_send_ack(sk);
 }
 
+void tcp_cleanup_rbuf(struct sock *sk, int copied)
+{
+	struct sk_buff *skb = skb_peek(&sk->sk_receive_queue);
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	WARN(skb && !before(tp->copied_seq, TCP_SKB_CB(skb)->end_seq),
+	     "cleanup rbuf bug: copied %X seq %X rcvnxt %X\n",
+	     tp->copied_seq, TCP_SKB_CB(skb)->end_seq, tp->rcv_nxt);
+	__tcp_cleanup_rbuf(sk, copied);
+}
+
 static void tcp_eat_recv_skb(struct sock *sk, struct sk_buff *skb)
 {
 	__skb_unlink(skb, &sk->sk_receive_queue);
@@ -1771,20 +1776,19 @@ int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 		copied += used;
 
 		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
-			consume_skb(skb);
 			++seq;
 			break;
 		}
-		consume_skb(skb);
 		break;
 	}
+	consume_skb(skb);
 	WRITE_ONCE(tp->copied_seq, seq);
 
 	tcp_rcv_space_adjust(sk);
 
 	/* Clean up data we have read: This will do ACK frames. */
 	if (copied > 0)
-		tcp_cleanup_rbuf(sk, copied);
+		__tcp_cleanup_rbuf(sk, copied);
 
 	return copied;
 }
-- 
2.34.1

