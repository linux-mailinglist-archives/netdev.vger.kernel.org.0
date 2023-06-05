Return-Path: <netdev+bounces-8005-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 93D1D722656
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EE7B28099B
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D0AE18B10;
	Mon,  5 Jun 2023 12:50:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406A7F9FF
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:50:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734F3E58
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 05:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685969417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uXvpsAJrK5w03LYiEcU7w+tO1rfwJo4A6Bo4opbn2SA=;
	b=T4BH6mRqj4u9pwNkmMktGLvvrly8iXeTj50N6TExXvRTW2LeH5zLxNJEHQkevPyFUL/Eu+
	J+5fdlCHyo9wOEsm33paQ11lTfWxxKz5HOzIZimdHG+ZHUZJovLbK1DtvoZvgcNP/Dbmhe
	jnDY6Qfq2o9hZT4X1kSDPn9+OBUEyUE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-n2hFhH1TMHWqAqgk0i2fyg-1; Mon, 05 Jun 2023 08:48:53 -0400
X-MC-Unique: n2hFhH1TMHWqAqgk0i2fyg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 112E1101B040;
	Mon,  5 Jun 2023 12:46:23 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0EDA1C154D1;
	Mon,  5 Jun 2023 12:46:20 +0000 (UTC)
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
Subject: [PATCH net-next v4 06/11] tls/device: Use splice_eof() to flush
Date: Mon,  5 Jun 2023 13:45:55 +0100
Message-ID: <20230605124600.1722160-7-dhowells@redhat.com>
In-Reply-To: <20230605124600.1722160-1-dhowells@redhat.com>
References: <20230605124600.1722160-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
cc: Chuck Lever <chuck.lever@oracle.com>
cc: Boris Pismenny <borisp@nvidia.com>
cc: John Fastabend <john.fastabend@gmail.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 net/tls/tls.h        |  1 +
 net/tls/tls_device.c | 23 +++++++++++++++++++++++
 net/tls/tls_main.c   |  2 ++
 3 files changed, 26 insertions(+)

diff --git a/net/tls/tls.h b/net/tls/tls.h
index 4922668fefaa..d002c3af1966 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -116,6 +116,7 @@ ssize_t tls_sw_splice_read(struct socket *sock, loff_t *ppos,
 			   size_t len, unsigned int flags);
 
 int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
+void tls_device_splice_eof(struct socket *sock);
 int tls_device_sendpage(struct sock *sk, struct page *page,
 			int offset, size_t size, int flags);
 int tls_tx_records(struct sock *sk, int flags);
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 9ef766e41c7a..439be833dcf9 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -590,6 +590,29 @@ int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	return rc;
 }
 
+void tls_device_splice_eof(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	union tls_iter_offset iter;
+	struct iov_iter iov_iter = {};
+
+	if (!tls_is_partially_sent_record(tls_ctx))
+		return;
+
+	mutex_lock(&tls_ctx->tx_lock);
+	lock_sock(sk);
+
+	if (tls_is_partially_sent_record(tls_ctx)) {
+		iov_iter_bvec(&iov_iter, ITER_SOURCE, NULL, 0, 0);
+		iter.msg_iter = &iov_iter;
+		tls_push_data(sk, iter, 0, 0, TLS_RECORD_TYPE_DATA, NULL);
+	}
+
+	release_sock(sk);
+	mutex_unlock(&tls_ctx->tx_lock);
+}
+
 int tls_device_sendpage(struct sock *sk, struct page *page,
 			int offset, size_t size, int flags)
 {
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 83fa15e52af6..113f3ff91d6c 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -1009,10 +1009,12 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 #ifdef CONFIG_TLS_DEVICE
 	prot[TLS_HW][TLS_BASE] = prot[TLS_BASE][TLS_BASE];
 	prot[TLS_HW][TLS_BASE].sendmsg		= tls_device_sendmsg;
+	prot[TLS_HW][TLS_BASE].splice_eof	= tls_device_splice_eof;
 	prot[TLS_HW][TLS_BASE].sendpage		= tls_device_sendpage;
 
 	prot[TLS_HW][TLS_SW] = prot[TLS_BASE][TLS_SW];
 	prot[TLS_HW][TLS_SW].sendmsg		= tls_device_sendmsg;
+	prot[TLS_HW][TLS_SW].splice_eof		= tls_device_splice_eof;
 	prot[TLS_HW][TLS_SW].sendpage		= tls_device_sendpage;
 
 	prot[TLS_BASE][TLS_HW] = prot[TLS_BASE][TLS_SW];


