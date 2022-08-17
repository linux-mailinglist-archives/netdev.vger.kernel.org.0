Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD9C597729
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 21:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241632AbiHQTzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 15:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238264AbiHQTzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 15:55:14 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82550A345A;
        Wed, 17 Aug 2022 12:55:13 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id h4so11196379qtj.11;
        Wed, 17 Aug 2022 12:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Z4AUHN+ek6dotH0Cp1UdVsz9yh9QJVLMXRKj8LAjmQE=;
        b=TYEj+k/rSv4v8wFChVr3uLFdqGkbJ3AI8Bhg+vHibEUjUQ3+WBPSvHIfUhly+D8loE
         9E6reiMMqjFTTpsh4ZpyP9073eX9AUGu/c7yESd8FydgZ9DLkjBdD8ZUThVU2C9FV6bR
         wVIpye2oPkaTXBTcVweTY5DMFLmYnkP3MD198ms8gQJ09j7sHzLuaXIo+60T4YDRp7mH
         jVd/fENtpvrsikNXBBMXS00Mn9ndLW1mqV9ZDayoOWRkz6pFm9QncyLaUzry8w6OeQU5
         jeFVM5kuloe/uNQiQy5Tv0nsYF9tlzj4g7NfRp/hjQi10i//iVqDXUF5bStzBNtctySE
         PYLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Z4AUHN+ek6dotH0Cp1UdVsz9yh9QJVLMXRKj8LAjmQE=;
        b=iT3gyVwsrbfzUZlrs1MWPefOlXlpfoxLkKGTAqvk/MVnOK5aZjsOQ5Kg5bEbaP419t
         HqlQ5Q7mpvLIOPCuPs28HF5jbFwhGw2nsd81mmxMCDpWar6nRqexMAk+PqZfY5n4UnI4
         irtgePDT2xkJ+EKD7hd8ixGXIdzm7xnCxvAVHRL17j3XWdLMx2cM9/+u0yFb2UkyFsLf
         p8byvrnSp7lSbU98q8ld3aHIoWYnUQY+E/wXatbelzxkqzKzPjxztv2BRNo3KAyzYQ2Q
         Tmfktg+oFJOqyQeJteWBhbYNeDSXzPZGR5XBletYOioRTNjaqAbNxf1PWqCBNqdUNHqe
         PkRg==
X-Gm-Message-State: ACgBeo0d2a3A4/bBMjlydAbX1c4oS3tthX1aY+Nu5+D8mgHdIMq8JCTV
        Z4jPMl9QqAp+FSipKmODVExNiG2tHws=
X-Google-Smtp-Source: AA6agR5tnkoLZ8l7R0AT7XwlCbpFv1v7XdtGEyUgVhxD8bGel1Dy3I+uJy54JkIFxNJwJC81CjifLA==
X-Received: by 2002:a05:622a:18a8:b0:343:6c8c:13e5 with SMTP id v40-20020a05622a18a800b003436c8c13e5mr24157277qtc.544.1660766112424;
        Wed, 17 Aug 2022 12:55:12 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:b87a:4308:21ec:d026])
        by smtp.gmail.com with ESMTPSA id az30-20020a05620a171e00b006bb8b5b79efsm2225473qkb.129.2022.08.17.12.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 12:55:11 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch net v3 2/4] tcp: fix tcp_cleanup_rbuf() for tcp_read_skb()
Date:   Wed, 17 Aug 2022 12:54:43 -0700
Message-Id: <20220817195445.151609-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220817195445.151609-1-xiyou.wangcong@gmail.com>
References: <20220817195445.151609-1-xiyou.wangcong@gmail.com>
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

