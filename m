Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B28B45D131
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 00:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352570AbhKXXaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 18:30:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:59976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346454AbhKXXaE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 18:30:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69461610D0;
        Wed, 24 Nov 2021 23:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637796413;
        bh=lRJ/N5GUjhcYrGnjq6ZEVTUkHUeayPbcrhjVHjroWcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KdilPeLyuIcAulZw8oCCv5J+At5owH7pcy5MRyKvjFjC+kmOkt1l6ON6L/oOSrapG
         xH+Dojj9Tw2Et0JDfXVY/cPTg9/CPZn9Rux2gVgdngxYoZmEjKNgwCz9cFPVga3Auv
         ngBHSffuJ8taEuvBor/UBNRbYtD0PSUtNGJHxLJgTVuGLNB6ydDYZ3NZW0xqC1Zxmp
         1lkqEGbtWF1SUQeG+Jamc9uIprD0TR95PPAil6ti6vXdzzFWvhEoflmZJNZA4Ysf6P
         DBQ0uDvgbOlRoUoKpaqM/z2cIyHg2qnN1FH0do0uANOmcySyMzV8WOzy7Bpu95TwB2
         LsbUX1dE1mRug==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, davejwatson@fb.com,
        borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        vakul.garg@nxp.com, willemb@google.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 8/9] tls: fix replacing proto_ops
Date:   Wed, 24 Nov 2021 15:25:56 -0800
Message-Id: <20211124232557.2039757-9-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124232557.2039757-1-kuba@kernel.org>
References: <20211124232557.2039757-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We replace proto_ops whenever TLS is configured for RX. But our
replacement also overrides sendpage_locked, which will crash
unless TX is also configured. Similarly we plug both of those
in for TLS_HW (NIC crypto offload) even tho TLS_HW has a completely
different implementation for TX.

Last but not least we always plug in something based on inet_stream_ops
even though a few of the callbacks differ for IPv6 (getname, release,
bind).

Use a callback building method similar to what we do for struct proto.

Fixes: c46234ebb4d1 ("tls: RX path for ktls")
Fixes: d4ffb02dee2f ("net/tls: enable sk_msg redirect to tls socket egress")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_main.c | 47 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 7 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index acfba9f1ba72..6bc2879ba637 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -61,7 +61,7 @@ static DEFINE_MUTEX(tcpv6_prot_mutex);
 static const struct proto *saved_tcpv4_prot;
 static DEFINE_MUTEX(tcpv4_prot_mutex);
 static struct proto tls_prots[TLS_NUM_PROTS][TLS_NUM_CONFIG][TLS_NUM_CONFIG];
-static struct proto_ops tls_sw_proto_ops;
+static struct proto_ops tls_proto_ops[TLS_NUM_PROTS][TLS_NUM_CONFIG][TLS_NUM_CONFIG];
 static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 			 const struct proto *base);
 
@@ -71,6 +71,8 @@ void update_sk_prot(struct sock *sk, struct tls_context *ctx)
 
 	WRITE_ONCE(sk->sk_prot,
 		   &tls_prots[ip_ver][ctx->tx_conf][ctx->rx_conf]);
+	WRITE_ONCE(sk->sk_socket->ops,
+		   &tls_proto_ops[ip_ver][ctx->tx_conf][ctx->rx_conf]);
 }
 
 int wait_on_pending_writer(struct sock *sk, long *timeo)
@@ -669,8 +671,6 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
 	if (tx) {
 		ctx->sk_write_space = sk->sk_write_space;
 		sk->sk_write_space = tls_write_space;
-	} else {
-		sk->sk_socket->ops = &tls_sw_proto_ops;
 	}
 	goto out;
 
@@ -728,6 +728,39 @@ struct tls_context *tls_ctx_create(struct sock *sk)
 	return ctx;
 }
 
+static void build_proto_ops(struct proto_ops ops[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
+			    const struct proto_ops *base)
+{
+	ops[TLS_BASE][TLS_BASE] = *base;
+
+	ops[TLS_SW  ][TLS_BASE] = ops[TLS_BASE][TLS_BASE];
+	ops[TLS_SW  ][TLS_BASE].sendpage_locked	= tls_sw_sendpage_locked;
+
+	ops[TLS_BASE][TLS_SW  ] = ops[TLS_BASE][TLS_BASE];
+	ops[TLS_BASE][TLS_SW  ].splice_read	= tls_sw_splice_read;
+
+	ops[TLS_SW  ][TLS_SW  ] = ops[TLS_SW  ][TLS_BASE];
+	ops[TLS_SW  ][TLS_SW  ].splice_read	= tls_sw_splice_read;
+
+#ifdef CONFIG_TLS_DEVICE
+	ops[TLS_HW  ][TLS_BASE] = ops[TLS_BASE][TLS_BASE];
+	ops[TLS_HW  ][TLS_BASE].sendpage_locked	= NULL;
+
+	ops[TLS_HW  ][TLS_SW  ] = ops[TLS_BASE][TLS_SW  ];
+	ops[TLS_HW  ][TLS_SW  ].sendpage_locked	= NULL;
+
+	ops[TLS_BASE][TLS_HW  ] = ops[TLS_BASE][TLS_SW  ];
+
+	ops[TLS_SW  ][TLS_HW  ] = ops[TLS_SW  ][TLS_SW  ];
+
+	ops[TLS_HW  ][TLS_HW  ] = ops[TLS_HW  ][TLS_SW  ];
+	ops[TLS_HW  ][TLS_HW  ].sendpage_locked	= NULL;
+#endif
+#ifdef CONFIG_TLS_TOE
+	ops[TLS_HW_RECORD][TLS_HW_RECORD] = *base;
+#endif
+}
+
 static void tls_build_proto(struct sock *sk)
 {
 	int ip_ver = sk->sk_family == AF_INET6 ? TLSV6 : TLSV4;
@@ -739,6 +772,8 @@ static void tls_build_proto(struct sock *sk)
 		mutex_lock(&tcpv6_prot_mutex);
 		if (likely(prot != saved_tcpv6_prot)) {
 			build_protos(tls_prots[TLSV6], prot);
+			build_proto_ops(tls_proto_ops[TLSV6],
+					sk->sk_socket->ops);
 			smp_store_release(&saved_tcpv6_prot, prot);
 		}
 		mutex_unlock(&tcpv6_prot_mutex);
@@ -749,6 +784,8 @@ static void tls_build_proto(struct sock *sk)
 		mutex_lock(&tcpv4_prot_mutex);
 		if (likely(prot != saved_tcpv4_prot)) {
 			build_protos(tls_prots[TLSV4], prot);
+			build_proto_ops(tls_proto_ops[TLSV4],
+					sk->sk_socket->ops);
 			smp_store_release(&saved_tcpv4_prot, prot);
 		}
 		mutex_unlock(&tcpv4_prot_mutex);
@@ -959,10 +996,6 @@ static int __init tls_register(void)
 	if (err)
 		return err;
 
-	tls_sw_proto_ops = inet_stream_ops;
-	tls_sw_proto_ops.splice_read = tls_sw_splice_read;
-	tls_sw_proto_ops.sendpage_locked   = tls_sw_sendpage_locked;
-
 	tls_device_init();
 	tcp_register_ulp(&tcp_tls_ulp_ops);
 
-- 
2.31.1

