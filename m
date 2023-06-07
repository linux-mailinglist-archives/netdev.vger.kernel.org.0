Return-Path: <netdev+bounces-9001-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29A2E726863
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:21:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8ED7280F44
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:21:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 447403922D;
	Wed,  7 Jun 2023 18:20:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3276938CC0
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 18:20:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CF810D7
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686162003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XqvSAbXVPa8XwKzNr0PvZXw2FsrUtjvMm73oMSig34E=;
	b=GVv0lUv+mi+vUq/sBMaukckmfGHxoogweveadMhrWZ3LpExnFMvF37ghL/qj1l+ooI04fJ
	y2m+YGcEsFUJS0Q9B8pOnM2uo54Q1RTfQP49NePpN2ZcW09lAZSGcARH18xr/43HScy16E
	qT2yw5L6ST/5cVeot4UTAAprUdwZfLs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-EoBIkxF_MvKXdSL0ouQGYQ-1; Wed, 07 Jun 2023 14:20:00 -0400
X-MC-Unique: EoBIkxF_MvKXdSL0ouQGYQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A04B23806704;
	Wed,  7 Jun 2023 18:19:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 249F82166B25;
	Wed,  7 Jun 2023 18:19:41 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Boris Pismenny <borisp@nvidia.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v6 05/14] tls/sw: Use splice_eof() to flush
Date: Wed,  7 Jun 2023 19:19:11 +0100
Message-ID: <20230607181920.2294972-6-dhowells@redhat.com>
In-Reply-To: <20230607181920.2294972-1-dhowells@redhat.com>
References: <20230607181920.2294972-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Allow splice to end a TLS record after prematurely ending a splice/sendfile
due to getting an EOF condition (->splice_read() returned 0) after splice
had called TLS with a sendmsg() with MSG_MORE set when the user didn't set
MSG_MORE.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/CAHk-=wh=V579PDYvkpnTobCLGczbgxpMgGmmhqiTyE34Cpi5Gg@mail.gmail.com/
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
cc: Chuck Lever <chuck.lever@oracle.com>
cc: Boris Pismenny <borisp@nvidia.com>
cc: John Fastabend <john.fastabend@gmail.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 net/tls/tls.h      |  1 +
 net/tls/tls_main.c |  2 ++
 net/tls/tls_sw.c   | 74 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 77 insertions(+)

diff --git a/net/tls/tls.h b/net/tls/tls.h
index 0672acab2773..4922668fefaa 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -97,6 +97,7 @@ void tls_update_rx_zc_capable(struct tls_context *tls_ctx);
 void tls_sw_strparser_arm(struct sock *sk, struct tls_context *ctx);
 void tls_sw_strparser_done(struct tls_context *tls_ctx);
 int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
+void tls_sw_splice_eof(struct socket *sock);
 int tls_sw_sendpage_locked(struct sock *sk, struct page *page,
 			   int offset, size_t size, int flags);
 int tls_sw_sendpage(struct sock *sk, struct page *page,
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index e02a0d882ed3..82ec5c654f32 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -957,6 +957,7 @@ static void build_proto_ops(struct proto_ops ops[TLS_NUM_CONFIG][TLS_NUM_CONFIG]
 	ops[TLS_BASE][TLS_BASE] = *base;
 
 	ops[TLS_SW  ][TLS_BASE] = ops[TLS_BASE][TLS_BASE];
+	ops[TLS_SW  ][TLS_BASE].splice_eof	= tls_sw_splice_eof;
 	ops[TLS_SW  ][TLS_BASE].sendpage_locked	= tls_sw_sendpage_locked;
 
 	ops[TLS_BASE][TLS_SW  ] = ops[TLS_BASE][TLS_BASE];
@@ -1027,6 +1028,7 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 
 	prot[TLS_SW][TLS_BASE] = prot[TLS_BASE][TLS_BASE];
 	prot[TLS_SW][TLS_BASE].sendmsg		= tls_sw_sendmsg;
+	prot[TLS_SW][TLS_BASE].splice_eof	= tls_sw_splice_eof;
 	prot[TLS_SW][TLS_BASE].sendpage		= tls_sw_sendpage;
 
 	prot[TLS_BASE][TLS_SW] = prot[TLS_BASE][TLS_BASE];
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 38acc27a0dd0..a2fb0256ff1c 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1157,6 +1157,80 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	return copied > 0 ? copied : ret;
 }
 
+/*
+ * Handle unexpected EOF during splice without SPLICE_F_MORE set.
+ */
+void tls_sw_splice_eof(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
+	struct tls_rec *rec;
+	struct sk_msg *msg_pl;
+	ssize_t copied = 0;
+	bool retrying = false;
+	int ret = 0;
+	int pending;
+
+	if (!ctx->open_rec)
+		return;
+
+	mutex_lock(&tls_ctx->tx_lock);
+	lock_sock(sk);
+
+retry:
+	rec = ctx->open_rec;
+	if (!rec)
+		goto unlock;
+
+	msg_pl = &rec->msg_plaintext;
+
+	/* Check the BPF advisor and perform transmission. */
+	ret = bpf_exec_tx_verdict(msg_pl, sk, false, TLS_RECORD_TYPE_DATA,
+				  &copied, 0);
+	switch (ret) {
+	case 0:
+	case -EAGAIN:
+		if (retrying)
+			goto unlock;
+		retrying = true;
+		goto retry;
+	case -EINPROGRESS:
+		break;
+	default:
+		goto unlock;
+	}
+
+	/* Wait for pending encryptions to get completed */
+	spin_lock_bh(&ctx->encrypt_compl_lock);
+	ctx->async_notify = true;
+
+	pending = atomic_read(&ctx->encrypt_pending);
+	spin_unlock_bh(&ctx->encrypt_compl_lock);
+	if (pending)
+		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
+	else
+		reinit_completion(&ctx->async_wait.completion);
+
+	/* There can be no concurrent accesses, since we have no pending
+	 * encrypt operations
+	 */
+	WRITE_ONCE(ctx->async_notify, false);
+
+	if (ctx->async_wait.err)
+		goto unlock;
+
+	/* Transmit if any encryptions have completed */
+	if (test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask)) {
+		cancel_delayed_work(&ctx->tx_work.work);
+		tls_tx_records(sk, 0);
+	}
+
+unlock:
+	release_sock(sk);
+	mutex_unlock(&tls_ctx->tx_lock);
+}
+
 static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 			      int offset, size_t size, int flags)
 {


