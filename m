Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 144B96BBE42
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 21:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbjCOU6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 16:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbjCOU57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 16:57:59 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA64E99BEC
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 13:57:54 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y75-20020a25dc4e000000b00b4211cf2298so7689800ybe.5
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 13:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678913874;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BwM4GTHSdLVV0IU9aDlNH3IUm3i5veukJiqkUhjJUwc=;
        b=qWEBBxLK3ps05Hrv9UQyJIuYk+y4OeTMloIxdQWv5c1fywpmTvcTUiMmhQ1whRCytI
         ZsIehcus9Z6CK3fRfQaXpQb5QUqjI2btoo+JbKvy3uhYaruSsmqdzb+jZEXjzbbE9jEG
         O7mmnZ0hZgUO2mcv1ugADKAvqUg+vMG/riYxldA0GlzGLNPA7Ki0/OKI3L5yx/+zuqz9
         pA7IWNjaAW1D8IEz9g5jZb4dxoppxg2yFMSOmn+OrSvidRInS+04MEhXpT0kdOszCbrG
         p5GB4EQM8tM6sgI2IQQZrLfZkWaWeVyLb9GD1jNzjSp3n4GZfyNv9Q7pkyyskVZXPJVh
         UUCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678913874;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BwM4GTHSdLVV0IU9aDlNH3IUm3i5veukJiqkUhjJUwc=;
        b=nkFB5FpryiTl0xN8j/ll4kBWWb12C7e39faensFMQ2RCXfZrRs6o4bO+zvZYk4MHLv
         r/nwh9HAlCzbfBg5+/Y1sSqLGyTZk7ADuq00PA/5GTqsNvK6zClHM87nrq3FKBbtqWTy
         Sh60Dv03CrNEdP9VQm3l7fpQQqQT7zgjKp5PvNw14a0MrwFc2igRVSylwwr5MVqXRP3J
         CN+0IE6217zdfgEK/MpLNf92xhxbIb5XbCXkUOodc4hxgh1f6l5OYmFuUizSHdOxEox8
         oieR7arUH1Ktg5+uXd7qIYZHS1c/FBpygsjKU3UBUoWYn40PgveVMo8umiPiC/GC4Us7
         KZzw==
X-Gm-Message-State: AO0yUKU8WiJYbx317R1oILJ2yb6/ed7icvGzsoTzX0FpU9nsSPF4V+g9
        dUJuhmLQSQBTIYaQ++7Eq5fWmFGjONO7Ug==
X-Google-Smtp-Source: AK7set/MkwiQWN7JSsI6rFGCBH/XgvM4YFzRKquAKQTq6QTf9k3otHfpR0vOUVrDdIMC7AQG8Tav7809ghSpQA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:100a:b0:b54:c2d4:71cf with SMTP
 id w10-20020a056902100a00b00b54c2d471cfmr1260878ybt.3.1678913874000; Wed, 15
 Mar 2023 13:57:54 -0700 (PDT)
Date:   Wed, 15 Mar 2023 20:57:44 +0000
In-Reply-To: <20230315205746.3801038-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230315205746.3801038-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230315205746.3801038-5-edumazet@google.com>
Subject: [PATCH net-next 4/6] tcp: annotate lockless access to sk->sk_err
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_poll() reads sk->sk_err without socket lock held/owned.

We should used READ_ONCE() here, and update writers
to use WRITE_ONCE().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c        | 11 ++++++-----
 net/ipv4/tcp_input.c  |  6 +++---
 net/ipv4/tcp_ipv4.c   |  4 ++--
 net/ipv4/tcp_output.c |  2 +-
 net/ipv4/tcp_timer.c  |  2 +-
 net/ipv6/tcp_ipv6.c   |  4 ++--
 6 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 288693981b0060c028680033aee143466b2285e4..01569de651b65aa5641fb0c06e0fb81dc40cd85a 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -589,7 +589,8 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 	}
 	/* This barrier is coupled with smp_wmb() in tcp_reset() */
 	smp_rmb();
-	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
+	if (READ_ONCE(sk->sk_err) ||
+	    !skb_queue_empty_lockless(&sk->sk_error_queue))
 		mask |= EPOLLERR;
 
 	return mask;
@@ -3094,7 +3095,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	if (old_state == TCP_LISTEN) {
 		inet_csk_listen_stop(sk);
 	} else if (unlikely(tp->repair)) {
-		sk->sk_err = ECONNABORTED;
+		WRITE_ONCE(sk->sk_err, ECONNABORTED);
 	} else if (tcp_need_reset(old_state) ||
 		   (tp->snd_nxt != tp->write_seq &&
 		    (1 << old_state) & (TCPF_CLOSING | TCPF_LAST_ACK))) {
@@ -3102,9 +3103,9 @@ int tcp_disconnect(struct sock *sk, int flags)
 		 * states
 		 */
 		tcp_send_active_reset(sk, gfp_any());
-		sk->sk_err = ECONNRESET;
+		WRITE_ONCE(sk->sk_err, ECONNRESET);
 	} else if (old_state == TCP_SYN_SENT)
-		sk->sk_err = ECONNRESET;
+		WRITE_ONCE(sk->sk_err, ECONNRESET);
 
 	tcp_clear_xmit_timers(sk);
 	__skb_queue_purge(&sk->sk_receive_queue);
@@ -4692,7 +4693,7 @@ int tcp_abort(struct sock *sk, int err)
 	bh_lock_sock(sk);
 
 	if (!sock_flag(sk, SOCK_DEAD)) {
-		sk->sk_err = err;
+		WRITE_ONCE(sk->sk_err, err);
 		/* This barrier is coupled with smp_rmb() in tcp_poll() */
 		smp_wmb();
 		sk_error_report(sk);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 8b5b6ca6617d0f6e2b03cf7164a6e8929fc521e1..754ddbe0577f139d209032b4f15787392fe9a1d5 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4322,15 +4322,15 @@ void tcp_reset(struct sock *sk, struct sk_buff *skb)
 	/* We want the right error as BSD sees it (and indeed as we do). */
 	switch (sk->sk_state) {
 	case TCP_SYN_SENT:
-		sk->sk_err = ECONNREFUSED;
+		WRITE_ONCE(sk->sk_err, ECONNREFUSED);
 		break;
 	case TCP_CLOSE_WAIT:
-		sk->sk_err = EPIPE;
+		WRITE_ONCE(sk->sk_err, EPIPE);
 		break;
 	case TCP_CLOSE:
 		return;
 	default:
-		sk->sk_err = ECONNRESET;
+		WRITE_ONCE(sk->sk_err, ECONNRESET);
 	}
 	/* This barrier is coupled with smp_rmb() in tcp_poll() */
 	smp_wmb();
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 4f6894469b620a75963b9329fc9944d835671515..89daa6b953ff4c49284959b2500618a963685d7d 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -596,7 +596,7 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 		ip_icmp_error(sk, skb, err, th->dest, info, (u8 *)th);
 
 		if (!sock_owned_by_user(sk)) {
-			sk->sk_err = err;
+			WRITE_ONCE(sk->sk_err, err);
 
 			sk_error_report(sk);
 
@@ -625,7 +625,7 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 
 	inet = inet_sk(sk);
 	if (!sock_owned_by_user(sk) && inet->recverr) {
-		sk->sk_err = err;
+		WRITE_ONCE(sk->sk_err, err);
 		sk_error_report(sk);
 	} else	{ /* Only an error on timeout */
 		WRITE_ONCE(sk->sk_err_soft, err);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 71d01cf3c13eb4bd3d314ef140568d2ffd6a499e..f7e00d90a7304cdbaee493d994c6ab1063392d34 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3699,7 +3699,7 @@ static void tcp_connect_init(struct sock *sk)
 	tp->rx_opt.rcv_wscale = rcv_wscale;
 	tp->rcv_ssthresh = tp->rcv_wnd;
 
-	sk->sk_err = 0;
+	WRITE_ONCE(sk->sk_err, 0);
 	sock_reset_flag(sk, SOCK_DONE);
 	tp->snd_wnd = 0;
 	tcp_init_wl(tp, 0);
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 8823e2182713a26fa42ce44a21b9ec7a4d7e1c73..b839c2f91292f7346f33d6dcbf597594473a5aca 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -67,7 +67,7 @@ u32 tcp_clamp_probe0_to_user_timeout(const struct sock *sk, u32 when)
 
 static void tcp_write_err(struct sock *sk)
 {
-	sk->sk_err = READ_ONCE(sk->sk_err_soft) ? : ETIMEDOUT;
+	WRITE_ONCE(sk->sk_err, READ_ONCE(sk->sk_err_soft) ? : ETIMEDOUT);
 	sk_error_report(sk);
 
 	tcp_write_queue_purge(sk);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index dc963eebc668f7d24981de21650608a27e431d41..35cf523c9efd4370bf3110f6777592eabb15ca9e 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -493,7 +493,7 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 		ipv6_icmp_error(sk, skb, err, th->dest, ntohl(info), (u8 *)th);
 
 		if (!sock_owned_by_user(sk)) {
-			sk->sk_err = err;
+			WRITE_ONCE(sk->sk_err, err);
 			sk_error_report(sk);		/* Wake people up to see the error (see connect in sock.c) */
 
 			tcp_done(sk);
@@ -513,7 +513,7 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	}
 
 	if (!sock_owned_by_user(sk) && np->recverr) {
-		sk->sk_err = err;
+		WRITE_ONCE(sk->sk_err, err);
 		sk_error_report(sk);
 	} else {
 		WRITE_ONCE(sk->sk_err_soft, err);
-- 
2.40.0.rc2.332.ga46443480c-goog

