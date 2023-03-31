Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F90A6D250B
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbjCaQOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbjCaQMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:12:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D889422EB5
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mERLnHIZ7Ufhp5QAaSwmDcCxGjZ2CWUtcWDMeYUTupY=;
        b=gwG5FE3dD6oDSnG8oyYnunUWjfkBJ1xaS3YoQU3idWN+rmI453zIieNYCOjl6HRLSDIkhc
        xDmvDwdHos2bFrkSMMnnByyek530O2xJjdiXvm4V2ZMVNcGQbBmfEmj3FaIGcgoMqF5Bo8
        KJwFZT0X3RbmS6RfP9rjAX9cl2fvVAw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-nbKIJurtO2appj6WS6snYg-1; Fri, 31 Mar 2023 12:10:32 -0400
X-MC-Unique: nbKIJurtO2appj6WS6snYg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C13C3886068;
        Fri, 31 Mar 2023 16:10:30 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ADCA81121314;
        Fri, 31 Mar 2023 16:10:28 +0000 (UTC)
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
Subject: [PATCH v3 25/55] crypto: af_alg: Convert af_alg_sendpage() to use MSG_SPLICE_PAGES
Date:   Fri, 31 Mar 2023 17:08:44 +0100
Message-Id: <20230331160914.1608208-26-dhowells@redhat.com>
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

Convert af_alg_sendpage() to use sendmsg() with MSG_SPLICE_PAGES rather
than directly splicing in the pages itself.

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
 crypto/af_alg.c | 53 +++++++++----------------------------------------
 1 file changed, 9 insertions(+), 44 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 3088ab298632..7fe8c8db6bb5 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1118,53 +1118,18 @@ EXPORT_SYMBOL_GPL(af_alg_sendmsg);
 ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
 			int offset, size_t size, int flags)
 {
-	struct sock *sk = sock->sk;
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-	struct af_alg_tsgl *sgl;
-	int err = -EINVAL;
-
-	if (flags & MSG_SENDPAGE_NOTLAST)
-		flags |= MSG_MORE;
-
-	lock_sock(sk);
-	if (!ctx->more && ctx->used)
-		goto unlock;
-
-	if (!size)
-		goto done;
-
-	if (!af_alg_writable(sk)) {
-		err = af_alg_wait_for_wmem(sk, flags);
-		if (err)
-			goto unlock;
-	}
-
-	err = af_alg_alloc_tsgl(sk);
-	if (err)
-		goto unlock;
-
-	ctx->merge = 0;
-	sgl = list_entry(ctx->tsgl_list.prev, struct af_alg_tsgl, list);
-
-	if (sgl->cur)
-		sg_unmark_end(sgl->sg + sgl->cur - 1);
+	struct bio_vec bvec;
+	struct msghdr msg = {
+		.msg_flags = flags | MSG_SPLICE_PAGES,
+	};
 
-	sg_mark_end(sgl->sg + sgl->cur);
+	bvec_set_page(&bvec, page, size, offset);
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
 
-	get_page(page);
-	sg_set_page(sgl->sg + sgl->cur, page, size, offset);
-	sgl->cur++;
-	ctx->used += size;
-
-done:
-	ctx->more = flags & MSG_MORE;
-
-unlock:
-	af_alg_data_wakeup(sk);
-	release_sock(sk);
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		msg.msg_flags |= MSG_MORE;
 
-	return err ?: size;
+	return sock_sendmsg(sock, &msg);
 }
 EXPORT_SYMBOL_GPL(af_alg_sendpage);
 

