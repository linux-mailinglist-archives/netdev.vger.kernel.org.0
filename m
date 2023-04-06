Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353B36D930F
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 11:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235943AbjDFJpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 05:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236610AbjDFJoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 05:44:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBCA83DC
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680774212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c83k4BnXfg8o4jtTDXWGTM6Kn2fXWMyaDkEU8sjy210=;
        b=jCuq9mFEM6qdujBDBxjhi5kY8DqIBYCtP+F2aCpz7gZ8Ds/3fRJllOvg1ER96QLBFu6CqV
        dlXdELL7VMJOVhvccBO01yqc75ZgD72YAK92gDMiJGDcMBVgCoZaYMVBiMTj7PJzrJCu00
        q4PCfePi7mgi90rCQkeCQo6g8889HTo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-TYObJh0zMq67k0lTYOLEeg-1; Thu, 06 Apr 2023 05:43:26 -0400
X-MC-Unique: TYObJh0zMq67k0lTYOLEeg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95B0E800B23;
        Thu,  6 Apr 2023 09:43:25 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F305A440D8;
        Thu,  6 Apr 2023 09:43:22 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, Tom Talpey <tom@talpey.com>,
        linux-rdma@vger.kernel.org
Subject: [PATCH net-next v5 11/19] siw: Inline do_tcp_sendpages()
Date:   Thu,  6 Apr 2023 10:42:37 +0100
Message-Id: <20230406094245.3633290-12-dhowells@redhat.com>
In-Reply-To: <20230406094245.3633290-1-dhowells@redhat.com>
References: <20230406094245.3633290-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

do_tcp_sendpages() is now just a small wrapper around tcp_sendmsg_locked(),
so inline it, allowing do_tcp_sendpages() to be removed.  This is part of
replacing ->sendpage() with a call to sendmsg() with MSG_SPLICE_PAGES set.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Bernard Metzler <bmt@zurich.ibm.com>
cc: Jason Gunthorpe <jgg@ziepe.ca>
cc: Leon Romanovsky <leon@kernel.org>
cc: Tom Talpey <tom@talpey.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: linux-rdma@vger.kernel.org
cc: netdev@vger.kernel.org
---
 drivers/infiniband/sw/siw/siw_qp_tx.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index 05052b49107f..fa5de40d85d5 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -313,7 +313,7 @@ static int siw_tx_ctrl(struct siw_iwarp_tx *c_tx, struct socket *s,
 }
 
 /*
- * 0copy TCP transmit interface: Use do_tcp_sendpages.
+ * 0copy TCP transmit interface: Use MSG_SPLICE_PAGES.
  *
  * Using sendpage to push page by page appears to be less efficient
  * than using sendmsg, even if data are copied.
@@ -324,20 +324,27 @@ static int siw_tx_ctrl(struct siw_iwarp_tx *c_tx, struct socket *s,
 static int siw_tcp_sendpages(struct socket *s, struct page **page, int offset,
 			     size_t size)
 {
+	struct bio_vec bvec;
+	struct msghdr msg = {
+		.msg_flags = (MSG_MORE | MSG_DONTWAIT | MSG_SENDPAGE_NOTLAST |
+			      MSG_SPLICE_PAGES),
+	};
 	struct sock *sk = s->sk;
-	int i = 0, rv = 0, sent = 0,
-	    flags = MSG_MORE | MSG_DONTWAIT | MSG_SENDPAGE_NOTLAST;
+	int i = 0, rv = 0, sent = 0;
 
 	while (size) {
 		size_t bytes = min_t(size_t, PAGE_SIZE - offset, size);
 
 		if (size + offset <= PAGE_SIZE)
-			flags = MSG_MORE | MSG_DONTWAIT;
+			msg.msg_flags = MSG_MORE | MSG_DONTWAIT;
 
 		tcp_rate_check_app_limited(sk);
+		bvec_set_page(&bvec, page[i], bytes, offset);
+		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
+
 try_page_again:
 		lock_sock(sk);
-		rv = do_tcp_sendpages(sk, page[i], offset, bytes, flags);
+		rv = tcp_sendmsg_locked(sk, &msg, size);
 		release_sock(sk);
 
 		if (rv > 0) {

