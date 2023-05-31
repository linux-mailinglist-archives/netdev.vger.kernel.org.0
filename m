Return-Path: <netdev+bounces-6846-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A5F171867C
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:36:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF8F6281516
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CF14174C1;
	Wed, 31 May 2023 15:35:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA3416438
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88E4C433EF;
	Wed, 31 May 2023 15:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685547356;
	bh=3XcAmIFSrnOkTTIvaLbHDeAzQQeOsMTCKo2LBSckIcE=;
	h=From:To:Cc:Subject:Date:From;
	b=sDeCRDLwnQy/Bxy+3qmQjJgUVCi17SQ5EuF7qGaiWSri0+EscsjzzSGVlbX5oT6aW
	 CXBmHxAow3QWd8vN4EOMLl1bM97SO3R0ujk9E2einZiies/jWOTVGbCy/E26nZjE8i
	 iknyMMLJtyH/L+BexiZt9uDyvvVUfLDPbSZKaebhJch35BrO3Tv99yHwVqxcd1QH4P
	 I+NaskzzJf0G+fh1utazXKKMRlXll8xQKSkzinrTmhYji7I4C8DRhFSOGP9bt0Iefk
	 yCtJOo2xrpKwHxOXobUGUyIqxSR9Ns7HDg9sLGPeBYZXBFMPu1yDx1dNO9WfSmTFox
	 jsZgz3FDZyMYQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	borisp@nvidia.com,
	john.fastabend@gmail.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/2] tls: suppress wakeups unless we have a full record
Date: Wed, 31 May 2023 08:35:50 -0700
Message-Id: <20230531153551.187141-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TLS does not override .poll() so TLS-enabled socket will generate
an event whenever data arrives at the TCP socket. This leads to
unnecessary wakeups on slow connections.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_main.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 3d45fdb5c4e9..e02a0d882ed3 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -358,6 +358,39 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 		tls_ctx_free(sk, ctx);
 }
 
+static __poll_t tls_sk_poll(struct file *file, struct socket *sock,
+			    struct poll_table_struct *wait)
+{
+	struct tls_sw_context_rx *ctx;
+	struct tls_context *tls_ctx;
+	struct sock *sk = sock->sk;
+	struct sk_psock *psock;
+	__poll_t mask = 0;
+	u8 shutdown;
+	int state;
+
+	mask = tcp_poll(file, sock, wait);
+
+	state = inet_sk_state_load(sk);
+	shutdown = READ_ONCE(sk->sk_shutdown);
+	if (unlikely(state != TCP_ESTABLISHED || shutdown & RCV_SHUTDOWN))
+		return mask;
+
+	tls_ctx = tls_get_ctx(sk);
+	ctx = tls_sw_ctx_rx(tls_ctx);
+	psock = sk_psock_get(sk);
+
+	if (skb_queue_empty_lockless(&ctx->rx_list) &&
+	    !tls_strp_msg_ready(ctx) &&
+	    sk_psock_queue_empty(psock))
+		mask &= ~(EPOLLIN | EPOLLRDNORM);
+
+	if (psock)
+		sk_psock_put(sk, psock);
+
+	return mask;
+}
+
 static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 				  int __user *optlen, int tx)
 {
@@ -928,9 +961,11 @@ static void build_proto_ops(struct proto_ops ops[TLS_NUM_CONFIG][TLS_NUM_CONFIG]
 
 	ops[TLS_BASE][TLS_SW  ] = ops[TLS_BASE][TLS_BASE];
 	ops[TLS_BASE][TLS_SW  ].splice_read	= tls_sw_splice_read;
+	ops[TLS_BASE][TLS_SW  ].poll		= tls_sk_poll;
 
 	ops[TLS_SW  ][TLS_SW  ] = ops[TLS_SW  ][TLS_BASE];
 	ops[TLS_SW  ][TLS_SW  ].splice_read	= tls_sw_splice_read;
+	ops[TLS_SW  ][TLS_SW  ].poll		= tls_sk_poll;
 
 #ifdef CONFIG_TLS_DEVICE
 	ops[TLS_HW  ][TLS_BASE] = ops[TLS_BASE][TLS_BASE];
-- 
2.40.1


