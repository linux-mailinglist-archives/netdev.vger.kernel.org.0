Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C79F188B8C
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 18:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgCQRE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 13:04:58 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37223 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgCQRE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 13:04:58 -0400
Received: by mail-wm1-f65.google.com with SMTP id a141so80066wme.2
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 10:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0hUgEWAsZWr/sBCuSkbT1f0TalDz7qAAFKwMxJsuHJc=;
        b=rcUmQWSbXToo9qU01X9jrnaL3+0G7fkFZvohlYN76ayY5Ho1Zqb5X0Gl9uGisn36Rm
         o9IN4bkTTDph0K+OVtrQvkXg7xv/8tJxHxZBrRwKbWkwll3zLsokU9RA6Gc/FXq+K0Z7
         UXcYZPchkUPEIRb0M9hez+2ckhjUIkenkbrKg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0hUgEWAsZWr/sBCuSkbT1f0TalDz7qAAFKwMxJsuHJc=;
        b=OZUP4V+xTvKXqc4ApDVf4K+xo99VONdxudyAOXLkEKcBf++dUf+LoZhp6zA7hKrtyh
         /4wBY5ClJgtp6GUGiWBozY/Tu7Qx1WwKVSAoOtHL1F11oQaGkTg5KNOWEkXagbL+ubfH
         0JWjwTt6SynN1yUxuT8KJjh0hNsuN8VO2YiYRDnvfD2AehNfxUFfnpoXAy70pPZtLfKx
         L8wyrXzEZzQ2yvtaaPRyKEo9XUEGJasy1nR5zNSy33/WAN9hxzG5xtB3JznJRbEfkiIL
         UXcWMna6k2wJo2+aK7Goh39TXv0h9BygWrl8q5357A3GFaJfH9SPQE+fEFbWhCGY0e6Q
         fUHg==
X-Gm-Message-State: ANhLgQ0qhb5KaOqplHTssdQOCfyN+swbL9oh3BnmuBRAYUOzhOlDbw0j
        mTvRlJPDCkLUqny4NdR+02xpTxOqg4lBwg==
X-Google-Smtp-Source: ADFU+vvalgCRA/H4k7xLyFy/PfWpPewTxGUt5TFhuxeHY1FrXPqCwN4SPiZaluPMzCUwfnfZl8Jblw==
X-Received: by 2002:a1c:1d88:: with SMTP id d130mr13405wmd.138.1584464695696;
        Tue, 17 Mar 2020 10:04:55 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id u17sm4544620wra.63.2020.03.17.10.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 10:04:54 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH net-next 3/3] net/tls: Annotate access to sk_prot with READ_ONCE/WRITE_ONCE
Date:   Tue, 17 Mar 2020 18:04:39 +0100
Message-Id: <20200317170439.873532-4-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317170439.873532-1-jakub@cloudflare.com>
References: <20200317170439.873532-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sockmap performs lockless writes to sk->sk_prot on the following paths:

tcp_bpf_{recvmsg|sendmsg} / sock_map_unref
  sk_psock_put
    sk_psock_drop
      sk_psock_restore_proto
        WRITE_ONCE(sk->sk_prot, proto)

To prevent load/store tearing [1], and to make tooling aware of intentional
shared access [2], we need to annotate other sites that access sk_prot with
READ_ONCE/WRITE_ONCE macros.

Change done with Coccinelle with following semantic patch:

@@
expression E;
identifier I;
struct sock *sk;
identifier sk_prot =~ "^sk_prot$";
@@
(
 E =
-sk->sk_prot
+READ_ONCE(sk->sk_prot)
|
-sk->sk_prot = E
+WRITE_ONCE(sk->sk_prot, E)
|
-sk->sk_prot
+READ_ONCE(sk->sk_prot)
 ->I
)

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/tls/tls_device.c | 2 +-
 net/tls/tls_main.c   | 9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 1c5574e2e058..a562ebaaa33c 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -366,7 +366,7 @@ static int tls_do_allocation(struct sock *sk,
 	if (!offload_ctx->open_record) {
 		if (unlikely(!skb_page_frag_refill(prepend_size, pfrag,
 						   sk->sk_allocation))) {
-			sk->sk_prot->enter_memory_pressure(sk);
+			READ_ONCE(sk->sk_prot)->enter_memory_pressure(sk);
 			sk_stream_moderate_sndbuf(sk);
 			return -ENOMEM;
 		}
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index e7de0306a7df..156efce50dbd 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -69,7 +69,8 @@ void update_sk_prot(struct sock *sk, struct tls_context *ctx)
 {
 	int ip_ver = sk->sk_family == AF_INET6 ? TLSV6 : TLSV4;
 
-	sk->sk_prot = &tls_prots[ip_ver][ctx->tx_conf][ctx->rx_conf];
+	WRITE_ONCE(sk->sk_prot,
+		   &tls_prots[ip_ver][ctx->tx_conf][ctx->rx_conf]);
 }
 
 int wait_on_pending_writer(struct sock *sk, long *timeo)
@@ -312,7 +313,7 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 	write_lock_bh(&sk->sk_callback_lock);
 	if (free_ctx)
 		rcu_assign_pointer(icsk->icsk_ulp_data, NULL);
-	sk->sk_prot = ctx->sk_proto;
+	WRITE_ONCE(sk->sk_prot, ctx->sk_proto);
 	if (sk->sk_write_space == tls_write_space)
 		sk->sk_write_space = ctx->sk_write_space;
 	write_unlock_bh(&sk->sk_callback_lock);
@@ -621,14 +622,14 @@ struct tls_context *tls_ctx_create(struct sock *sk)
 
 	mutex_init(&ctx->tx_lock);
 	rcu_assign_pointer(icsk->icsk_ulp_data, ctx);
-	ctx->sk_proto = sk->sk_prot;
+	ctx->sk_proto = READ_ONCE(sk->sk_prot);
 	return ctx;
 }
 
 static void tls_build_proto(struct sock *sk)
 {
 	int ip_ver = sk->sk_family == AF_INET6 ? TLSV6 : TLSV4;
-	const struct proto *prot = sk->sk_prot;
+	const struct proto *prot = READ_ONCE(sk->sk_prot);
 
 	/* Build IPv6 TLS whenever the address of tcpv6 _prot changes */
 	if (ip_ver == TLSV6 &&
-- 
2.24.1

