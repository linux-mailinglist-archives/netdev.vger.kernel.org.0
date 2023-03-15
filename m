Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12C66BBE40
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 21:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbjCOU6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 16:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjCOU56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 16:57:58 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FE39E06E
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 13:57:50 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id fy14-20020a05622a5a0e00b003d2f39d3ab5so1113633qtb.14
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 13:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678913869;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1f8sXYBP3YMmAIIL0T1T7/3j3IddAw3pD/EYg7W3iQ8=;
        b=SjSi5MtYAhguuatGPmT1zONTXZzTZ0Hajh8XByj76jWGD4VKOtNUpZX7x+6Em8gP8O
         2Yuq8Kf/TlYz+iDHq/1u2htN5fTQAj5QkUTGtsKtt7xyO31GhOIppLOvII7cARvpJtwB
         qrnHt5n52XJOtvlqnagUhN/drKfOepMO3YpS+ZpWzWmbBxgbb+vxopnxypYmc0z7ZVTi
         jVKx67LDnqYFqIgVPLgkkWZACqBfufP3gtfG0dW41XhVeWATDjQoxiHOtfBtpDCeaFrT
         MWakCVde9MVAMivjAMp6GShlB3mrvM1Hqe4EnjYhXZ41BWfiAnNQ4b2P/OjNKvg6o9O7
         rJcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678913869;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1f8sXYBP3YMmAIIL0T1T7/3j3IddAw3pD/EYg7W3iQ8=;
        b=YBXk1OG5hSJ2vLm3p71Xs9pHhdFtk3GE96nVKVsUMIhLqADFAAEuguTb5kESEpOYiY
         VJaeo1eTgu57vWDiworyhZn47TIFdDk9o1pR351h7hp5zsd9LPsjg7tW51uQ6KD0wo9P
         Cfab3eRccn2nU2/Km/0eCN7YGy7u2uzcTpeCmVqX2fK6H44O9+Em3zPZRvQ6GZ5k7k6/
         wV8MSi7yTbANRqobKmplug37PAahCXsPIHKoGhfsD47wN7OKFQdJCGvGenZNXjtWaOCZ
         tepqGBo05PxwEhKUzLqoGGJy3XP4eDQ9gVVsT5nL+emOcyqMQ5NbEyqmotmtoxxQrRNl
         bHPA==
X-Gm-Message-State: AO0yUKVBKAeEeLaQzUnz+7yP6mey+8UocELwblVb7ZEg3sbELmog3bqK
        WuWeYxC3gdTXdZo08TiVQX1qTw024RgtfQ==
X-Google-Smtp-Source: AK7set/1AehckSxJxL+fWW/TOyTvENakSIrBxZ0eZbiUiLEQ+1bvts6AxdUPjUMpJxNdmdqleiyAUAoRDwlItQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:ad4:4ae3:0:b0:56e:9c1c:c64 with SMTP id
 cp3-20020ad44ae3000000b0056e9c1c0c64mr3994594qvb.6.1678913869687; Wed, 15 Mar
 2023 13:57:49 -0700 (PDT)
Date:   Wed, 15 Mar 2023 20:57:41 +0000
In-Reply-To: <20230315205746.3801038-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230315205746.3801038-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230315205746.3801038-2-edumazet@google.com>
Subject: [PATCH net-next 1/6] tcp: annotate lockless accesses to sk->sk_err_soft
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

This field can be read/written without lock synchronization.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c |  2 +-
 net/ipv4/tcp_ipv4.c  |  6 +++---
 net/ipv4/tcp_timer.c |  6 +++---
 net/ipv6/tcp_ipv6.c  | 11 ++++++-----
 4 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index cc072d2cfcd82c8b91b83ac4cb9466a278763c82..8b5b6ca6617d0f6e2b03cf7164a6e8929fc521e1 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3874,7 +3874,7 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	/* We passed data and got it acked, remove any soft error
 	 * log. Something worked...
 	 */
-	sk->sk_err_soft = 0;
+	WRITE_ONCE(sk->sk_err_soft, 0);
 	icsk->icsk_probes_out = 0;
 	tp->rcv_tstamp = tcp_jiffies32;
 	if (!prior_packets)
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index ea370afa70ed979266dbeea474b034e833b15db4..4f6894469b620a75963b9329fc9944d835671515 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -361,7 +361,7 @@ void tcp_v4_mtu_reduced(struct sock *sk)
 	 * for the case, if this connection will not able to recover.
 	 */
 	if (mtu < dst_mtu(dst) && ip_dont_fragment(sk, dst))
-		sk->sk_err_soft = EMSGSIZE;
+		WRITE_ONCE(sk->sk_err_soft, EMSGSIZE);
 
 	mtu = dst_mtu(dst);
 
@@ -602,7 +602,7 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 
 			tcp_done(sk);
 		} else {
-			sk->sk_err_soft = err;
+			WRITE_ONCE(sk->sk_err_soft, err);
 		}
 		goto out;
 	}
@@ -628,7 +628,7 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 		sk->sk_err = err;
 		sk_error_report(sk);
 	} else	{ /* Only an error on timeout */
-		sk->sk_err_soft = err;
+		WRITE_ONCE(sk->sk_err_soft, err);
 	}
 
 out:
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index cb79127f45c341e13bb66f8dc61c4fa84dbd340d..8823e2182713a26fa42ce44a21b9ec7a4d7e1c73 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -67,7 +67,7 @@ u32 tcp_clamp_probe0_to_user_timeout(const struct sock *sk, u32 when)
 
 static void tcp_write_err(struct sock *sk)
 {
-	sk->sk_err = sk->sk_err_soft ? : ETIMEDOUT;
+	sk->sk_err = READ_ONCE(sk->sk_err_soft) ? : ETIMEDOUT;
 	sk_error_report(sk);
 
 	tcp_write_queue_purge(sk);
@@ -110,7 +110,7 @@ static int tcp_out_of_resources(struct sock *sk, bool do_reset)
 		shift++;
 
 	/* If some dubious ICMP arrived, penalize even more. */
-	if (sk->sk_err_soft)
+	if (READ_ONCE(sk->sk_err_soft))
 		shift++;
 
 	if (tcp_check_oom(sk, shift)) {
@@ -146,7 +146,7 @@ static int tcp_orphan_retries(struct sock *sk, bool alive)
 	int retries = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_orphan_retries); /* May be zero. */
 
 	/* We know from an ICMP that something is wrong. */
-	if (sk->sk_err_soft && !alive)
+	if (READ_ONCE(sk->sk_err_soft) && !alive)
 		retries = 0;
 
 	/* However, if socket sent something recently, select some safe
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 1bf93b61aa06ffe9536fb5a041e7724fa9eef5b1..dc963eebc668f7d24981de21650608a27e431d41 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -497,8 +497,9 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 			sk_error_report(sk);		/* Wake people up to see the error (see connect in sock.c) */
 
 			tcp_done(sk);
-		} else
-			sk->sk_err_soft = err;
+		} else {
+			WRITE_ONCE(sk->sk_err_soft, err);
+		}
 		goto out;
 	case TCP_LISTEN:
 		break;
@@ -514,9 +515,9 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	if (!sock_owned_by_user(sk) && np->recverr) {
 		sk->sk_err = err;
 		sk_error_report(sk);
-	} else
-		sk->sk_err_soft = err;
-
+	} else {
+		WRITE_ONCE(sk->sk_err_soft, err);
+	}
 out:
 	bh_unlock_sock(sk);
 	sock_put(sk);
-- 
2.40.0.rc2.332.ga46443480c-goog

