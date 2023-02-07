Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203B068CC6D
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 03:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjBGCI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 21:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBGCIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 21:08:25 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A832BF3A
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 18:08:24 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id i17-20020a25be91000000b0082663f3eecbso13180925ybk.2
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 18:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CXxdpY4FsHFK8IFBjayqN1zHgv3WMBGTR2WpszrwFLg=;
        b=RRndyXi8rBHGENh/RaQbrdi5z1rsbkiOfR4JQ/UC7fMypNeqtiSN4xO5qTK2m6/iXZ
         OavIX0A4NwCKFMN0zCM/t55xfKgbfruxRj9V0iUVaNhV5764HlA11p5ieCXyIxCc72nn
         Uob5i8561B6i9G4La/VNA6b+zjeJC4tHD/Mkq8D5Sv6QyZM2gBKW9deeffdEviDX6KFO
         bO5UfxtNLnrZVAYYVjbw1MKeK1GtWnr9e3cw9OgtJHBS8FlxaeaTELBZ00q3x1VB6jVb
         JNKUmrH4d4gmeBMkwPzkXWlguJGRJikyFc9fHrbpFOdETLO/1PfKnUDeYbAuI5sJqto6
         faTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CXxdpY4FsHFK8IFBjayqN1zHgv3WMBGTR2WpszrwFLg=;
        b=50gR1lHuWzrr69Vge3j//3nMM2Jghdmi7nxMd0nZdjiXFCHslYVlBZG0O3LnYsmHhG
         1XghsBlTlmTMApmraqEkAP4tHElsxn7FzVg7R3qsVUh5qxsX+L+QTdAHGF7BRSZrTKPw
         FXeVpk70/GClke6tjnA242nEnohSygQMnu8smb3z+vp2pFa18JEyzkjsnm6gHxjpdGd7
         gh4pGeQLr5DFO21ZbVTU/dXZSr0GhynJY3+OXPSG7odKkc8oXApeE77bBA4QJxS/XrNt
         h0ErnMoCWIX3f3rdWcl6+8lfstPP8ejmIxlSk/fLT5+/d0W/2p3zjMkMTTzWw0dBNkpQ
         I6Tw==
X-Gm-Message-State: AO0yUKUK/QTAbBx8mz0r0pBLSwnRYXP7Pv7OtlwLjoVJqC8uTZ4Gljbb
        hxk69/wjKW//wyBTFVcffXtxI5Y=
X-Google-Smtp-Source: AK7set/k5wDNe0GideQiMCUlU5IEUwDsXjM+H9eR6EYrOlbKg348g/DsU9ch1OgdkHYiThOX9HhYoZ4=
X-Received: from cyyd.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:1313])
 (user=yyd job=sendgmr) by 2002:a25:44d:0:b0:8b0:e7b7:349 with SMTP id
 74-20020a25044d000000b008b0e7b70349mr0ybe.5.1675735702696; Mon, 06 Feb 2023
 18:08:22 -0800 (PST)
Date:   Tue,  7 Feb 2023 02:08:20 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230207020820.2704647-1-yyd@google.com>
Subject: [PATCH net] txhash: fix sk->sk_txrehash default
From:   Kevin Yang <yyd@google.com>
To:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Kevin Yang <yyd@google.com>
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

This code fix a bug that sk->sk_txrehash gets its default enable
value from sysctl_txrehash only when the socket is a TCP listener.

We should have sysctl_txrehash to set the default sk->sk_txrehash,
no matter TCP, nor listerner/connector.

Tested by following packetdrill:
  0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
  +0 socket(..., SOCK_DGRAM, IPPROTO_UDP) = 4
  // SO_TXREHASH == 74, default to sysctl_txrehash == 1
  +0 getsockopt(3, SOL_SOCKET, 74, [1], [4]) = 0
  +0 getsockopt(4, SOL_SOCKET, 74, [1], [4]) = 0

Fixes: 26859240e4ee ("txhash: Add socket option to control TX hash rethink behavior")
Signed-off-by: Kevin Yang <yyd@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/sock.c                 | 3 ++-
 net/ipv4/af_inet.c              | 1 +
 net/ipv4/inet_connection_sock.c | 3 ---
 net/ipv6/af_inet6.c             | 1 +
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index f954d5893e79..6f27c24016fe 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1531,6 +1531,8 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 			ret = -EINVAL;
 			break;
 		}
+		if ((u8)val == SOCK_TXREHASH_DEFAULT)
+			val = READ_ONCE(sock_net(sk)->core.sysctl_txrehash);
 		/* Paired with READ_ONCE() in tcp_rtx_synack() */
 		WRITE_ONCE(sk->sk_txrehash, (u8)val);
 		break;
@@ -3451,7 +3453,6 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	sk->sk_pacing_rate = ~0UL;
 	WRITE_ONCE(sk->sk_pacing_shift, 10);
 	sk->sk_incoming_cpu = -1;
-	sk->sk_txrehash = SOCK_TXREHASH_DEFAULT;
 
 	sk_rx_queue_clear(sk);
 	/*
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 6c0ec2789943..cf11f10927e1 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -347,6 +347,7 @@ static int inet_create(struct net *net, struct socket *sock, int protocol,
 	sk->sk_destruct	   = inet_sock_destruct;
 	sk->sk_protocol	   = protocol;
 	sk->sk_backlog_rcv = sk->sk_prot->backlog_rcv;
+	sk->sk_txrehash = READ_ONCE(net->core.sysctl_txrehash);
 
 	inet->uc_ttl	= -1;
 	inet->mc_loop	= 1;
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index d1f837579398..f2c43f67187d 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1225,9 +1225,6 @@ int inet_csk_listen_start(struct sock *sk)
 	sk->sk_ack_backlog = 0;
 	inet_csk_delack_init(sk);
 
-	if (sk->sk_txrehash == SOCK_TXREHASH_DEFAULT)
-		sk->sk_txrehash = READ_ONCE(sock_net(sk)->core.sysctl_txrehash);
-
 	/* There is race window here: we announce ourselves listening,
 	 * but this transition is still not validated by get_port().
 	 * It is OK, because this socket enters to hash table only
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index fee9163382c2..847934763868 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -222,6 +222,7 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
 	np->pmtudisc	= IPV6_PMTUDISC_WANT;
 	np->repflow	= net->ipv6.sysctl.flowlabel_reflect & FLOWLABEL_REFLECT_ESTABLISHED;
 	sk->sk_ipv6only	= net->ipv6.sysctl.bindv6only;
+	sk->sk_txrehash = READ_ONCE(net->core.sysctl_txrehash);
 
 	/* Init the ipv4 part of the socket since we can have sockets
 	 * using v6 API for ipv4.
-- 
2.39.1.519.gcb327c4b5f-goog

