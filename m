Return-Path: <netdev+bounces-10940-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8100F730B88
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:28:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0BAD281409
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7AA1156EA;
	Wed, 14 Jun 2023 23:28:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9570B154BE
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 23:28:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0B61BE8
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686785280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=aH8zwLa8Ht2nXaE8fo3wqv7zLHm1tw4+70R/cDKjh3s=;
	b=Pib7553m97gLDb/s0E3V+7jCoW58jZS1t2ygyRC3W7QMAac1p0Sq5dX/2Dl2zYWSUouRHl
	y6nssujR7lIzBoi4HSx69+yp+7uUIAEugKCZzc1pZlqRo0ix07AtEinXcrul7CHlH7RP4N
	LsA5s3QmdWxiYniv6S3TZ9b4qMWeA1s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-n6p0z6GaO3ei54QFL73rZQ-1; Wed, 14 Jun 2023 19:27:56 -0400
X-MC-Unique: n6p0z6GaO3ei54QFL73rZQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1504A296A603;
	Wed, 14 Jun 2023 23:27:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.67])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 559E240C6F5E;
	Wed, 14 Jun 2023 23:27:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
To: netdev@vger.kernel.org
cc: dhowells@redhat.com,
    syzbot+13a08c0bf4d212766c3c@syzkaller.appspotmail.com,
    syzbot+14234ccf6d0ef629ec1a@syzkaller.appspotmail.com,
    syzbot+4e2e47f32607d0f72d43@syzkaller.appspotmail.com,
    syzbot+472626bb5e7c59fb768f@syzkaller.appspotmail.com,
    Herbert Xu <herbert@gondor.apana.org.au>,
    "David S. Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
    Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
    Matthew Wilcox <willy@infradead.org>, linux-crypto@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: [PATCH net-next] crypto: af_alg/hash: Fix recvmsg() after sendmsg(MSG_MORE)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1679811.1686785244.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
From: David Howells <dhowells@redhat.com>
Date: Thu, 15 Jun 2023 00:27:53 +0100
Message-ID: <1679829.1686785273@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

    =

If an AF_ALG socket bound to a hashing algorithm is sent a zero-length
message with MSG_MORE set and then recvmsg() is called without first
sending another message without MSG_MORE set to end the operation, an oops
will occur because the crypto context and result doesn't now get set up in
advance because hash_sendmsg() now defers that as long as possible in the
hope that it can use crypto_ahash_digest() - and then because the message
is zero-length, it the data wrangling loop is skipped.

Fix this by always making a pass of the loop, even in the case that no dat=
a
is provided to the sendmsg().

Fix also extract_iter_to_sg() to handle a zero-length iterator by returnin=
g
0 immediately.

Whilst we're at it, remove the code to create a kvmalloc'd scatterlist if
we get more than ALG_MAX_PAGES - this shouldn't happen.

Fixes: c662b043cdca ("crypto: af_alg/hash: Support MSG_SPLICE_PAGES")
Reported-by: syzbot+13a08c0bf4d212766c3c@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/000000000000b928f705fdeb873a@google.com/
Reported-by: syzbot+14234ccf6d0ef629ec1a@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/000000000000c047db05fdeb8790@google.com/
Reported-by: syzbot+4e2e47f32607d0f72d43@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/000000000000bcca3205fdeb87fb@google.com/
Reported-by: syzbot+472626bb5e7c59fb768f@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/000000000000b55d8805fdeb8385@google.com/
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: syzbot+13a08c0bf4d212766c3c@syzkaller.appspotmail.com
Tested-by: syzbot+14234ccf6d0ef629ec1a@syzkaller.appspotmail.com
Tested-by: syzbot+4e2e47f32607d0f72d43@syzkaller.appspotmail.com
Tested-by: syzbot+472626bb5e7c59fb768f@syzkaller.appspotmail.com
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: linux-crypto@vger.kernel.org
cc: netdev@vger.kernel.org
---
 crypto/algif_hash.c |   21 +++++----------------
 lib/scatterlist.c   |    2 +-
 2 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index dfb048cefb60..1176533a55c9 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -83,26 +83,14 @@ static int hash_sendmsg(struct socket *sock, struct ms=
ghdr *msg,
 =

 	ctx->more =3D false;
 =

-	while (msg_data_left(msg)) {
+	do {
 		ctx->sgl.sgt.sgl =3D ctx->sgl.sgl;
 		ctx->sgl.sgt.nents =3D 0;
 		ctx->sgl.sgt.orig_nents =3D 0;
 =

 		err =3D -EIO;
 		npages =3D iov_iter_npages(&msg->msg_iter, max_pages);
-		if (npages =3D=3D 0)
-			goto unlock_free;
-
-		if (npages > ARRAY_SIZE(ctx->sgl.sgl)) {
-			err =3D -ENOMEM;
-			ctx->sgl.sgt.sgl =3D
-				kvmalloc(array_size(npages,
-						    sizeof(*ctx->sgl.sgt.sgl)),
-					 GFP_KERNEL);
-			if (!ctx->sgl.sgt.sgl)
-				goto unlock_free;
-		}
-		sg_init_table(ctx->sgl.sgl, npages);
+		sg_init_table(ctx->sgl.sgl, max_t(size_t, npages, 1));
 =

 		ctx->sgl.need_unpin =3D iov_iter_extract_will_pin(&msg->msg_iter);
 =

@@ -111,7 +99,8 @@ static int hash_sendmsg(struct socket *sock, struct msg=
hdr *msg,
 		if (err < 0)
 			goto unlock_free;
 		len =3D err;
-		sg_mark_end(ctx->sgl.sgt.sgl + ctx->sgl.sgt.nents - 1);
+		if (len > 0)
+			sg_mark_end(ctx->sgl.sgt.sgl + ctx->sgl.sgt.nents - 1);
 =

 		if (!msg_data_left(msg)) {
 			err =3D hash_alloc_result(sk, ctx);
@@ -148,7 +137,7 @@ static int hash_sendmsg(struct socket *sock, struct ms=
ghdr *msg,
 =

 		copied +=3D len;
 		af_alg_free_sg(&ctx->sgl);
-	}
+	} while (msg_data_left(msg));
 =

 	ctx->more =3D msg->msg_flags & MSG_MORE;
 	err =3D 0;
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index e97d7060329e..77a7b18ee751 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -1340,7 +1340,7 @@ ssize_t extract_iter_to_sg(struct iov_iter *iter, si=
ze_t maxsize,
 			   struct sg_table *sgtable, unsigned int sg_max,
 			   iov_iter_extraction_t extraction_flags)
 {
-	if (maxsize =3D=3D 0)
+	if (!maxsize || !iter->count)
 		return 0;
 =

 	switch (iov_iter_type(iter)) {


