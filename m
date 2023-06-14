Return-Path: <netdev+bounces-8479-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 016A9724402
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:12:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6722C1C20F00
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 939FB2A9ED;
	Tue,  6 Jun 2023 13:10:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8090C2A9DB
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:10:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFC8173B
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 06:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686056981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QtAp9m6xIHUM3JsWZ2D0eSySkKsfORU9VhNMC8xMOaU=;
	b=jOhZDL48m9Jn5MYlpGJzF4XLbldG2y8QVXAlo0gY1cP/Ae2AGk+g1rxSK3fiKFjEM1sJcE
	veb5zFEM12uA30wp2BKOtcyBnFJKGNdo1zU3Ye9Z3rMew13Nq3lTS2fNmDvCmf+EuJPCi7
	ibiWwk0KrLkN5cf7pMtoQGPdEow9Ems=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580-s44Ua1LEO8mHiDWBHNf86w-1; Tue, 06 Jun 2023 09:09:39 -0400
X-MC-Unique: s44Ua1LEO8mHiDWBHNf86w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6168F80120A;
	Tue,  6 Jun 2023 13:09:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CCC8D2026D6A;
	Tue,  6 Jun 2023 13:09:35 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-crypto@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 08/10] crypto: af_alg: Support MSG_SPLICE_PAGES
Date: Tue,  6 Jun 2023 14:08:54 +0100
Message-ID: <20230606130856.1970660-9-dhowells@redhat.com>
In-Reply-To: <20230606130856.1970660-1-dhowells@redhat.com>
References: <20230606130856.1970660-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Make AF_ALG sendmsg() support MSG_SPLICE_PAGES.  This causes pages to be
spliced from the source iterator.

This allows ->sendpage() to be replaced by something that can handle
multiple multipage folios in a single transaction.

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

Notes:
    ver #3)
     - Remove BVEC iter restriction when using MSG_SPLICE_PAGES.

 crypto/af_alg.c         | 24 ++++++++++++++++++++++--
 crypto/algif_aead.c     | 22 +++++++++++-----------
 crypto/algif_skcipher.c |  8 ++++----
 3 files changed, 37 insertions(+), 17 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index fd56ccff6fed..9c12530d604a 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -985,7 +985,7 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	while (size) {
 		struct scatterlist *sg;
 		size_t len = size;
-		size_t plen;
+		ssize_t plen;
 
 		/* use the existing memory in an allocated page */
 		if (ctx->merge) {
@@ -1030,7 +1030,27 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		if (sgl->cur)
 			sg_unmark_end(sg + sgl->cur - 1);
 
-		if (1 /* TODO check MSG_SPLICE_PAGES */) {
+		if (msg->msg_flags & MSG_SPLICE_PAGES) {
+			struct sg_table sgtable = {
+				.sgl		= sg,
+				.nents		= sgl->cur,
+				.orig_nents	= sgl->cur,
+			};
+
+			plen = extract_iter_to_sg(&msg->msg_iter, len, &sgtable,
+						  MAX_SGL_ENTS, 0);
+			if (plen < 0) {
+				err = plen;
+				goto unlock;
+			}
+
+			for (; sgl->cur < sgtable.nents; sgl->cur++)
+				get_page(sg_page(&sg[sgl->cur]));
+			len -= plen;
+			ctx->used += plen;
+			copied += plen;
+			size -= plen;
+		} else {
 			do {
 				struct page *pg;
 				unsigned int i = sgl->cur;
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 829878025dba..35bfa283748d 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -9,8 +9,8 @@
  * The following concept of the memory management is used:
  *
  * The kernel maintains two SGLs, the TX SGL and the RX SGL. The TX SGL is
- * filled by user space with the data submitted via sendpage/sendmsg. Filling
- * up the TX SGL does not cause a crypto operation -- the data will only be
+ * filled by user space with the data submitted via sendpage. Filling up
+ * the TX SGL does not cause a crypto operation -- the data will only be
  * tracked by the kernel. Upon receipt of one recvmsg call, the caller must
  * provide a buffer which is tracked with the RX SGL.
  *
@@ -113,19 +113,19 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	}
 
 	/*
-	 * Data length provided by caller via sendmsg/sendpage that has not
-	 * yet been processed.
+	 * Data length provided by caller via sendmsg that has not yet been
+	 * processed.
 	 */
 	used = ctx->used;
 
 	/*
-	 * Make sure sufficient data is present -- note, the same check is
-	 * also present in sendmsg/sendpage. The checks in sendpage/sendmsg
-	 * shall provide an information to the data sender that something is
-	 * wrong, but they are irrelevant to maintain the kernel integrity.
-	 * We need this check here too in case user space decides to not honor
-	 * the error message in sendmsg/sendpage and still call recvmsg. This
-	 * check here protects the kernel integrity.
+	 * Make sure sufficient data is present -- note, the same check is also
+	 * present in sendmsg. The checks in sendmsg shall provide an
+	 * information to the data sender that something is wrong, but they are
+	 * irrelevant to maintain the kernel integrity.  We need this check
+	 * here too in case user space decides to not honor the error message
+	 * in sendmsg and still call recvmsg. This check here protects the
+	 * kernel integrity.
 	 */
 	if (!aead_sufficient_data(sk))
 		return -EINVAL;
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index a251cd6bd5b9..b1f321b9f846 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -9,10 +9,10 @@
  * The following concept of the memory management is used:
  *
  * The kernel maintains two SGLs, the TX SGL and the RX SGL. The TX SGL is
- * filled by user space with the data submitted via sendpage/sendmsg. Filling
- * up the TX SGL does not cause a crypto operation -- the data will only be
- * tracked by the kernel. Upon receipt of one recvmsg call, the caller must
- * provide a buffer which is tracked with the RX SGL.
+ * filled by user space with the data submitted via sendmsg. Filling up the TX
+ * SGL does not cause a crypto operation -- the data will only be tracked by
+ * the kernel. Upon receipt of one recvmsg call, the caller must provide a
+ * buffer which is tracked with the RX SGL.
  *
  * During the processing of the recvmsg operation, the cipher request is
  * allocated and prepared. As part of the recvmsg operation, the processed


