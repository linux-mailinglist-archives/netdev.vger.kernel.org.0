Return-Path: <netdev+bounces-3636-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FB7970823F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:10:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F04962814F6
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 13:10:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8618220990;
	Thu, 18 May 2023 13:08:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC5F125A2
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 13:08:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFA01738
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 06:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684415285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tEe6KsGIUg5Ug9eymZUK4cq5L1lxhWlwpIXxPsGo3ck=;
	b=YXo6YaKO7c9gZTvxNyFqemUvc+5buEfTjekKrIFMDZepxLY3CKbJnAhV/WTWldW6N/hb++
	w+dkeSb7D74svtYRwdWP20y/jne92eHeyoSt7nQEJDna5peE1ZLwGDGWebYa8P0m/aAipg
	3ZGmIMQiPaEK+8O+JFh0fPrtTI6EVN0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-159-rWJ6E0svM2ScwbkcEaLtzw-1; Thu, 18 May 2023 09:08:03 -0400
X-MC-Unique: rWJ6E0svM2ScwbkcEaLtzw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE5503815F79;
	Thu, 18 May 2023 13:08:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.221])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5DF3B492B01;
	Thu, 18 May 2023 13:07:57 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Chuck Lever III <chuck.lever@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Tom Talpey <tom@talpey.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org
Subject: [PATCH net-next v9 09/16] siw: Inline do_tcp_sendpages()
Date: Thu, 18 May 2023 14:07:06 +0100
Message-Id: <20230518130713.1515729-10-dhowells@redhat.com>
In-Reply-To: <20230518130713.1515729-1-dhowells@redhat.com>
References: <20230518130713.1515729-1-dhowells@redhat.com>
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
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

do_tcp_sendpages() is now just a small wrapper around tcp_sendmsg_locked(),
so inline it, allowing do_tcp_sendpages() to be removed.  This is part of
replacing ->sendpage() with a call to sendmsg() with MSG_SPLICE_PAGES set.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Bernard Metzler <bmt@zurich.ibm.com>
Reviewed-by: Tom Talpey <tom@talpey.com>
cc: Jason Gunthorpe <jgg@ziepe.ca>
cc: Leon Romanovsky <leon@kernel.org>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: linux-rdma@vger.kernel.org
cc: netdev@vger.kernel.org
---

Notes:
    ver #6)
     - Don't clear MSG_SPLICE_PAGES on the last page.

 drivers/infiniband/sw/siw/siw_qp_tx.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index 4b292e0504f1..ffb16beb6c30 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -312,7 +312,7 @@ static int siw_tx_ctrl(struct siw_iwarp_tx *c_tx, struct socket *s,
 }
 
 /*
- * 0copy TCP transmit interface: Use do_tcp_sendpages.
+ * 0copy TCP transmit interface: Use MSG_SPLICE_PAGES.
  *
  * Using sendpage to push page by page appears to be less efficient
  * than using sendmsg, even if data are copied.
@@ -323,20 +323,27 @@ static int siw_tx_ctrl(struct siw_iwarp_tx *c_tx, struct socket *s,
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
+			msg.msg_flags &= ~MSG_SENDPAGE_NOTLAST;
 
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


