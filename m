Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9316D250C
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbjCaQOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbjCaQMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:12:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85E822EB2
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bQ5QnEnteMQfZ4j7G0XrCpLzGl+D3sZ9ge7q0vobANw=;
        b=QKHyd+NmcNjlz/dPFtD68lRjq/Ww8laBF2msaBW0p3QFakYi4e0nnLRrZlAcY6l+hdKflQ
        gPqFzu7sItxe7dmCTjAHyjEWR0F8q0pii2WlYQZzA92EAWizO/EiKrToUL8oHMtIPmehC5
        vdXr5CYY/tD3Hhpw80kF2oYOyXQ/Alo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-zyE999oJOe6JnagrFD2R3w-1; Fri, 31 Mar 2023 12:10:29 -0400
X-MC-Unique: zyE999oJOe6JnagrFD2R3w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1847B85A5B1;
        Fri, 31 Mar 2023 16:10:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0691D1121315;
        Fri, 31 Mar 2023 16:10:25 +0000 (UTC)
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
Subject: [PATCH v3 24/55] crypto: af_alg: Support MSG_SPLICE_PAGES
Date:   Fri, 31 Mar 2023 17:08:43 +0100
Message-Id: <20230331160914.1608208-25-dhowells@redhat.com>
In-Reply-To: <20230331160914.1608208-1-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make AF_ALG sendmsg() support MSG_SPLICE_PAGES.  This causes pages to be
spliced from the source iterator.

This allows ->sendpage() to be replaced by something that can handle
multiple multipage folios in a single transaction.

[!] Note that this makes use of netfs_extract_iter_to_sg() from netfslib.
    This probably needs moving to core code somewhere.

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
 crypto/Kconfig          |  1 +
 crypto/af_alg.c         | 28 ++++++++++++++++++++++++++--
 crypto/algif_aead.c     | 22 +++++++++++-----------
 crypto/algif_skcipher.c |  8 ++++----
 4 files changed, 42 insertions(+), 17 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9c86f7045157..8c04ecbb4395 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1297,6 +1297,7 @@ menu "Userspace interface"
 
 config CRYPTO_USER_API
 	tristate
+	select NETFS_SUPPORT # for netfs_extract_iter_to_sg()
 
 config CRYPTO_USER_API_HASH
 	tristate "Hash algorithms"
diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 483821e310e9..3088ab298632 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -941,6 +941,10 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	bool init = false;
 	int err = 0;
 
+	if ((msg->msg_flags & MSG_SPLICE_PAGES) &&
+	    !iov_iter_is_bvec(&msg->msg_iter))
+		return -EINVAL;
+
 	if (msg->msg_controllen) {
 		err = af_alg_cmsg_send(msg, &con);
 		if (err)
@@ -986,7 +990,7 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	while (size) {
 		struct scatterlist *sg;
 		size_t len = size;
-		size_t plen;
+		ssize_t plen;
 
 		/* use the existing memory in an allocated page */
 		if (ctx->merge) {
@@ -1031,7 +1035,27 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
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
+			plen = netfs_extract_iter_to_sg(&msg->msg_iter, len,
+							&sgtable, MAX_SGL_ENTS, 0);
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
index f6aa3856d8d5..b16111a3025a 100644
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

