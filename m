Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB74F6D24FF
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbjCaQN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbjCaQMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:12:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D0822E88
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xCO1FTHFb6ixqT+m8PCC52zI8ZJyvPRkEVPay5Q0l+o=;
        b=N8O4AMPgO6f+6D+p0bJh8RPwTmNz9DqOpVKRsZWMv05Aa5uy00G/6j/evaScbHLPrURSLQ
        F484UWKLnel3IBpFdRhpLdoP9kSNXiwpNSi6n/US6XDvVPofSVC1SrYtzQcEOTvAwCTu05
        sekU18MD/T5so7FefYJXeVxpMsiqmMo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-E9J8PItkP7uGZG6CiLxyVg-1; Fri, 31 Mar 2023 12:10:25 -0400
X-MC-Unique: E9J8PItkP7uGZG6CiLxyVg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CDB988606A;
        Fri, 31 Mar 2023 16:10:22 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BDFC492B00;
        Fri, 31 Mar 2023 16:10:20 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 22/55] crypto: af_alg: Use netfs_extract_iter_to_sg() to create scatterlists
Date:   Fri, 31 Mar 2023 17:08:41 +0100
Message-Id: <20230331160914.1608208-23-dhowells@redhat.com>
In-Reply-To: <20230331160914.1608208-1-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netfs_extract_iter_to_sg() to decant the destination iterator into a
scatterlist in af_alg_get_rsgl().  af_alg_make_sg() can then be removed.

[!] Note that if this fits, netfs_extract_iter_to_sg() should move to core
code.

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
---
 crypto/af_alg.c         | 55 ++++++++++-------------------------------
 crypto/algif_aead.c     | 12 ++++-----
 crypto/algif_hash.c     | 18 ++++++++++----
 crypto/algif_skcipher.c |  2 +-
 include/crypto/if_alg.h |  6 ++---
 5 files changed, 35 insertions(+), 58 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 7caff10df643..1dafd088ad45 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -22,6 +22,7 @@
 #include <linux/sched/signal.h>
 #include <linux/security.h>
 #include <linux/string.h>
+#include <linux/netfs.h>
 #include <keys/user-type.h>
 #include <keys/trusted-type.h>
 #include <keys/encrypted-type.h>
@@ -531,45 +532,11 @@ static const struct net_proto_family alg_family = {
 	.owner	=	THIS_MODULE,
 };
 
-int af_alg_make_sg(struct af_alg_sgl *sgl, struct iov_iter *iter, int len)
-{
-	struct page **pages = sgl->pages;
-	size_t off;
-	ssize_t n;
-	int npages, i;
-
-	n = iov_iter_extract_pages(iter, &pages, len, ALG_MAX_PAGES, 0, &off);
-	if (n < 0)
-		return n;
-
-	sgl->need_unpin = iov_iter_extract_will_pin(iter);
-
-	npages = DIV_ROUND_UP(off + n, PAGE_SIZE);
-	if (WARN_ON(npages == 0))
-		return -EINVAL;
-	/* Add one extra for linking */
-	sg_init_table(sgl->sg, npages + 1);
-
-	for (i = 0, len = n; i < npages; i++) {
-		int plen = min_t(int, len, PAGE_SIZE - off);
-
-		sg_set_page(sgl->sg + i, sgl->pages[i], plen, off);
-
-		off = 0;
-		len -= plen;
-	}
-	sg_mark_end(sgl->sg + npages - 1);
-	sgl->npages = npages;
-
-	return n;
-}
-EXPORT_SYMBOL_GPL(af_alg_make_sg);
-
 static void af_alg_link_sg(struct af_alg_sgl *sgl_prev,
 			   struct af_alg_sgl *sgl_new)
 {
-	sg_unmark_end(sgl_prev->sg + sgl_prev->npages - 1);
-	sg_chain(sgl_prev->sg, sgl_prev->npages + 1, sgl_new->sg);
+	sg_unmark_end(sgl_prev->sgt.sgl + sgl_prev->sgt.nents - 1);
+	sg_chain(sgl_prev->sgt.sgl, sgl_prev->sgt.nents + 1, sgl_new->sgt.sgl);
 }
 
 void af_alg_free_sg(struct af_alg_sgl *sgl)
@@ -577,8 +544,8 @@ void af_alg_free_sg(struct af_alg_sgl *sgl)
 	int i;
 
 	if (sgl->need_unpin)
-		for (i = 0; i < sgl->npages; i++)
-			unpin_user_page(sgl->pages[i]);
+		for (i = 0; i < sgl->sgt.nents; i++)
+			unpin_user_page(sg_page(&sgl->sgt.sgl[i]));
 }
 EXPORT_SYMBOL_GPL(af_alg_free_sg);
 
@@ -1292,8 +1259,8 @@ int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
 
 	while (maxsize > len && msg_data_left(msg)) {
 		struct af_alg_rsgl *rsgl;
+		ssize_t err;
 		size_t seglen;
-		int err;
 
 		/* limit the amount of readable buffers */
 		if (!af_alg_readable(sk))
@@ -1310,16 +1277,20 @@ int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
 				return -ENOMEM;
 		}
 
-		rsgl->sgl.npages = 0;
+		rsgl->sgl.sgt.sgl = rsgl->sgl.sgl;
+		rsgl->sgl.sgt.nents = 0;
+		rsgl->sgl.sgt.orig_nents = 0;
 		list_add_tail(&rsgl->list, &areq->rsgl_list);
 
-		/* make one iovec available as scatterlist */
-		err = af_alg_make_sg(&rsgl->sgl, &msg->msg_iter, seglen);
+		err = netfs_extract_iter_to_sg(&msg->msg_iter, seglen,
+					       &rsgl->sgl.sgt, ALG_MAX_PAGES, 0);
 		if (err < 0) {
 			rsgl->sg_num_bytes = 0;
 			return err;
 		}
 
+		rsgl->sgl.need_unpin = iov_iter_extract_will_pin(&msg->msg_iter);
+
 		/* chain the new scatterlist with previous one */
 		if (areq->last_rsgl)
 			af_alg_link_sg(&areq->last_rsgl->sgl, &rsgl->sgl);
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 42493b4d8ce4..f6aa3856d8d5 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -210,7 +210,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	 */
 
 	/* Use the RX SGL as source (and destination) for crypto op. */
-	rsgl_src = areq->first_rsgl.sgl.sg;
+	rsgl_src = areq->first_rsgl.sgl.sgt.sgl;
 
 	if (ctx->enc) {
 		/*
@@ -224,7 +224,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 		 * RX SGL: AAD || PT || Tag
 		 */
 		err = crypto_aead_copy_sgl(null_tfm, tsgl_src,
-					   areq->first_rsgl.sgl.sg, processed);
+					   areq->first_rsgl.sgl.sgt.sgl, processed);
 		if (err)
 			goto free;
 		af_alg_pull_tsgl(sk, processed, NULL, 0);
@@ -242,7 +242,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 
 		 /* Copy AAD || CT to RX SGL buffer for in-place operation. */
 		err = crypto_aead_copy_sgl(null_tfm, tsgl_src,
-					   areq->first_rsgl.sgl.sg, outlen);
+					   areq->first_rsgl.sgl.sgt.sgl, outlen);
 		if (err)
 			goto free;
 
@@ -268,8 +268,8 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 			/* RX SGL present */
 			struct af_alg_sgl *sgl_prev = &areq->last_rsgl->sgl;
 
-			sg_unmark_end(sgl_prev->sg + sgl_prev->npages - 1);
-			sg_chain(sgl_prev->sg, sgl_prev->npages + 1,
+			sg_unmark_end(sgl_prev->sgt.sgl + sgl_prev->sgt.nents - 1);
+			sg_chain(sgl_prev->sgt.sgl, sgl_prev->sgt.nents + 1,
 				 areq->tsgl);
 		} else
 			/* no RX SGL present (e.g. authentication only) */
@@ -278,7 +278,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 
 	/* Initialize the crypto operation */
 	aead_request_set_crypt(&areq->cra_u.aead_req, rsgl_src,
-			       areq->first_rsgl.sgl.sg, used, ctx->iv);
+			       areq->first_rsgl.sgl.sgt.sgl, used, ctx->iv);
 	aead_request_set_ad(&areq->cra_u.aead_req, ctx->aead_assoclen);
 	aead_request_set_tfm(&areq->cra_u.aead_req, tfm);
 
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 1d017ec5c63c..f051fa624bd7 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -14,6 +14,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/net.h>
+#include <linux/netfs.h>
 #include <net/sock.h>
 
 struct hash_ctx {
@@ -91,13 +92,20 @@ static int hash_sendmsg(struct socket *sock, struct msghdr *msg,
 		if (len > limit)
 			len = limit;
 
-		len = af_alg_make_sg(&ctx->sgl, &msg->msg_iter, len);
+		ctx->sgl.sgt.sgl = ctx->sgl.sgl;
+		ctx->sgl.sgt.nents = 0;
+		ctx->sgl.sgt.orig_nents = 0;
+
+		len = netfs_extract_iter_to_sg(&msg->msg_iter, len,
+					       &ctx->sgl.sgt, ALG_MAX_PAGES, 0);
 		if (len < 0) {
 			err = copied ? 0 : len;
 			goto unlock;
 		}
 
-		ahash_request_set_crypt(&ctx->req, ctx->sgl.sg, NULL, len);
+		ctx->sgl.need_unpin = iov_iter_extract_will_pin(&msg->msg_iter);
+
+		ahash_request_set_crypt(&ctx->req, ctx->sgl.sgt.sgl, NULL, len);
 
 		err = crypto_wait_req(crypto_ahash_update(&ctx->req),
 				      &ctx->wait);
@@ -141,8 +149,8 @@ static ssize_t hash_sendpage(struct socket *sock, struct page *page,
 		flags |= MSG_MORE;
 
 	lock_sock(sk);
-	sg_init_table(ctx->sgl.sg, 1);
-	sg_set_page(ctx->sgl.sg, page, size, offset);
+	sg_init_table(ctx->sgl.sgl, 1);
+	sg_set_page(ctx->sgl.sgl, page, size, offset);
 
 	if (!(flags & MSG_MORE)) {
 		err = hash_alloc_result(sk, ctx);
@@ -151,7 +159,7 @@ static ssize_t hash_sendpage(struct socket *sock, struct page *page,
 	} else if (!ctx->more)
 		hash_free_result(sk, ctx);
 
-	ahash_request_set_crypt(&ctx->req, ctx->sgl.sg, ctx->result, size);
+	ahash_request_set_crypt(&ctx->req, ctx->sgl.sgl, ctx->result, size);
 
 	if (!(flags & MSG_MORE)) {
 		if (ctx->more)
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index ee8890ee8f33..a251cd6bd5b9 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -105,7 +105,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	/* Initialize the crypto operation */
 	skcipher_request_set_tfm(&areq->cra_u.skcipher_req, tfm);
 	skcipher_request_set_crypt(&areq->cra_u.skcipher_req, areq->tsgl,
-				   areq->first_rsgl.sgl.sg, len, ctx->iv);
+				   areq->first_rsgl.sgl.sgt.sgl, len, ctx->iv);
 
 	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) {
 		/* AIO operation */
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 46494b33f5bc..34224e77f5a2 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -56,9 +56,8 @@ struct af_alg_type {
 };
 
 struct af_alg_sgl {
-	struct scatterlist sg[ALG_MAX_PAGES + 1];
-	struct page *pages[ALG_MAX_PAGES];
-	unsigned int npages;
+	struct sg_table sgt;
+	struct scatterlist sgl[ALG_MAX_PAGES + 1];
 	bool need_unpin;
 };
 
@@ -164,7 +163,6 @@ int af_alg_release(struct socket *sock);
 void af_alg_release_parent(struct sock *sk);
 int af_alg_accept(struct sock *sk, struct socket *newsock, bool kern);
 
-int af_alg_make_sg(struct af_alg_sgl *sgl, struct iov_iter *iter, int len);
 void af_alg_free_sg(struct af_alg_sgl *sgl);
 
 static inline struct alg_sock *alg_sk(struct sock *sk)

