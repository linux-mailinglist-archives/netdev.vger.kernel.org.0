Return-Path: <netdev+bounces-9485-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAC99729633
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:02:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C60621C20A8D
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:02:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7706014A99;
	Fri,  9 Jun 2023 10:02:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C10414A98
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:02:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED0E4202
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 03:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686304953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pG6mXFErgEQ8ZgVFj/OVbi2iAUQF/l3Cm4NkJ83benc=;
	b=SSAGYpmK5Xp8pxjoH/VFE5LyU6IjJEPOiAFStULG6ldf/xXHbvWeKLUstZhPjRCqvdXxDc
	3eOyAWFx76vRVf8u0RZI9p6TFtqdfCpdnAiTlH0/51s5BPR0xcVK2o7X0Xu5I1tLr8cDn8
	KeVOAw+d39gxK7gJL17T7ryijYfMeIg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-66-QaZulYcBM26mge84teR9Xw-1; Fri, 09 Jun 2023 06:02:30 -0400
X-MC-Unique: QaZulYcBM26mge84teR9Xw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E214880013A;
	Fri,  9 Jun 2023 10:02:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.51])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 223D9492B00;
	Fri,  9 Jun 2023 10:02:28 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Subject: [PATCH net-next 2/6] algif: Remove hash_sendpage*()
Date: Fri,  9 Jun 2023 11:02:17 +0100
Message-ID: <20230609100221.2620633-3-dhowells@redhat.com>
In-Reply-To: <20230609100221.2620633-1-dhowells@redhat.com>
References: <20230609100221.2620633-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Remove hash_sendpage*() as nothing should now call it since the rewrite of
splice_to_socket()[1].

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: linux-crypto@vger.kernel.org
cc: netdev@vger.kernel.org
Link: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=2dc334f1a63a8839b88483a3e73c0f27c9c1791c [1]
---
 crypto/algif_hash.c | 66 ---------------------------------------------
 1 file changed, 66 deletions(-)

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 1a2d80c6c91a..dfb048cefb60 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -161,58 +161,6 @@ static int hash_sendmsg(struct socket *sock, struct msghdr *msg,
 	goto unlock;
 }
 
-static ssize_t hash_sendpage(struct socket *sock, struct page *page,
-			     int offset, size_t size, int flags)
-{
-	struct sock *sk = sock->sk;
-	struct alg_sock *ask = alg_sk(sk);
-	struct hash_ctx *ctx = ask->private;
-	int err;
-
-	if (flags & MSG_SENDPAGE_NOTLAST)
-		flags |= MSG_MORE;
-
-	lock_sock(sk);
-	sg_init_table(ctx->sgl.sgl, 1);
-	sg_set_page(ctx->sgl.sgl, page, size, offset);
-
-	if (!(flags & MSG_MORE)) {
-		err = hash_alloc_result(sk, ctx);
-		if (err)
-			goto unlock;
-	} else if (!ctx->more)
-		hash_free_result(sk, ctx);
-
-	ahash_request_set_crypt(&ctx->req, ctx->sgl.sgl, ctx->result, size);
-
-	if (!(flags & MSG_MORE)) {
-		if (ctx->more)
-			err = crypto_ahash_finup(&ctx->req);
-		else
-			err = crypto_ahash_digest(&ctx->req);
-	} else {
-		if (!ctx->more) {
-			err = crypto_ahash_init(&ctx->req);
-			err = crypto_wait_req(err, &ctx->wait);
-			if (err)
-				goto unlock;
-		}
-
-		err = crypto_ahash_update(&ctx->req);
-	}
-
-	err = crypto_wait_req(err, &ctx->wait);
-	if (err)
-		goto unlock;
-
-	ctx->more = flags & MSG_MORE;
-
-unlock:
-	release_sock(sk);
-
-	return err ?: size;
-}
-
 static int hash_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 			int flags)
 {
@@ -328,7 +276,6 @@ static struct proto_ops algif_hash_ops = {
 
 	.release	=	af_alg_release,
 	.sendmsg	=	hash_sendmsg,
-	.sendpage	=	hash_sendpage,
 	.recvmsg	=	hash_recvmsg,
 	.accept		=	hash_accept,
 };
@@ -380,18 +327,6 @@ static int hash_sendmsg_nokey(struct socket *sock, struct msghdr *msg,
 	return hash_sendmsg(sock, msg, size);
 }
 
-static ssize_t hash_sendpage_nokey(struct socket *sock, struct page *page,
-				   int offset, size_t size, int flags)
-{
-	int err;
-
-	err = hash_check_key(sock);
-	if (err)
-		return err;
-
-	return hash_sendpage(sock, page, offset, size, flags);
-}
-
 static int hash_recvmsg_nokey(struct socket *sock, struct msghdr *msg,
 			      size_t ignored, int flags)
 {
@@ -430,7 +365,6 @@ static struct proto_ops algif_hash_ops_nokey = {
 
 	.release	=	af_alg_release,
 	.sendmsg	=	hash_sendmsg_nokey,
-	.sendpage	=	hash_sendpage_nokey,
 	.recvmsg	=	hash_recvmsg_nokey,
 	.accept		=	hash_accept_nokey,
 };


