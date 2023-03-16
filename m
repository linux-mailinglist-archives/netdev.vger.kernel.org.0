Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC9C6BD399
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjCPP2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbjCPP2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:28:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1EC3ADC2D
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678980410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2QKge+op/Hl6BMrdVZzEnNbF4IaGzItNcXZtJUNSCtc=;
        b=gCpB4h4a6oL6mfboDOqIbv/FxmM/tkL5cP/ln9iFa5/mlXHAxkGDzfywrOE5qgiSglp7Xj
        JIfRvxs81Y+oWUEEnvrIlmgtOgTo3Nug4dnXCVSR46H1FlkDv1PtvfQj6oW05JJHCj9+aN
        HA69xtuTk9NBC/RfH0MfQIXjE38iwko=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-75WtpKLgNty4TtjE6A487g-1; Thu, 16 Mar 2023 11:26:45 -0400
X-MC-Unique: 75WtpKLgNty4TtjE6A487g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4412F858F09;
        Thu, 16 Mar 2023 15:26:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 319582166B26;
        Thu, 16 Mar 2023 15:26:42 +0000 (UTC)
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
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Tom Talpey <tom@talpey.com>, linux-rdma@vger.kernel.org
Subject: [RFC PATCH 08/28] siw: Inline do_tcp_sendpages()
Date:   Thu, 16 Mar 2023 15:25:58 +0000
Message-Id: <20230316152618.711970-9-dhowells@redhat.com>
In-Reply-To: <20230316152618.711970-1-dhowells@redhat.com>
References: <20230316152618.711970-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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
index 05052b49107f..8fc179321e2b 100644
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
+		.msg_flags = (MSG_SPLICE_PAGES | MSG_MORE | MSG_DONTWAIT |
+			      MSG_SENDPAGE_NOTLAST),
+	};
 	struct sock *sk = s->sk;
-	int i = 0, rv = 0, sent = 0,
-	    flags = MSG_MORE | MSG_DONTWAIT | MSG_SENDPAGE_NOTLAST;
+	int i = 0, rv = 0, sent = 0;
 
 	while (size) {
 		size_t bytes = min_t(size_t, PAGE_SIZE - offset, size);
 
 		if (size + offset <= PAGE_SIZE)
-			flags = MSG_MORE | MSG_DONTWAIT;
+			msg.msg_flags = MSG_SPLICE_PAGES | MSG_MORE | MSG_DONTWAIT;
 
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

