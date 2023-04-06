Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCBE6D9308
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 11:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236782AbjDFJo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 05:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236587AbjDFJoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 05:44:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42177EE8
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680774203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tYeoTX9B8dad49qWPHePVLYzX6oyR1jBlVymL6Q5Zsc=;
        b=HLudmGwizP9wTKVQyySHfQDH0UjwNOttKjHzOkaqqvJbDFCxXGmSpESKW8iR77ZzpVHeqe
        Je8vA03DwFaH4s4M8WvJt1TzxiqNP9LCowo1qkHCglTqgQHDnsNcNezlSsEqB3GSruPOsZ
        8TaUy1ACRiJKyTYlRdAL9nfJdH+zCBs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-jk5GdTXgMCaItZ0dnoKllg-1; Thu, 06 Apr 2023 05:43:20 -0400
X-MC-Unique: jk5GdTXgMCaItZ0dnoKllg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 884003C0ED6C;
        Thu,  6 Apr 2023 09:43:19 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2FFAD2166B26;
        Thu,  6 Apr 2023 09:43:17 +0000 (UTC)
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
        linux-mm@kvack.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next v5 09/19] espintcp: Inline do_tcp_sendpages()
Date:   Thu,  6 Apr 2023 10:42:35 +0100
Message-Id: <20230406094245.3633290-10-dhowells@redhat.com>
In-Reply-To: <20230406094245.3633290-1-dhowells@redhat.com>
References: <20230406094245.3633290-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
cc: Steffen Klassert <steffen.klassert@secunet.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: David Ahern <dsahern@kernel.org>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: netdev@vger.kernel.org
---
 net/xfrm/espintcp.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index 872b80188e83..3504925babdb 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -205,14 +205,16 @@ static int espintcp_sendskb_locked(struct sock *sk, struct espintcp_msg *emsg,
 static int espintcp_sendskmsg_locked(struct sock *sk,
 				     struct espintcp_msg *emsg, int flags)
 {
+	struct msghdr msghdr = { .msg_flags = flags | MSG_SPLICE_PAGES, };
 	struct sk_msg *skmsg = &emsg->skmsg;
 	struct scatterlist *sg;
 	int done = 0;
 	int ret;
 
-	flags |= MSG_SENDPAGE_NOTLAST;
+	msghdr.msg_flags |= MSG_SENDPAGE_NOTLAST;
 	sg = &skmsg->sg.data[skmsg->sg.start];
 	do {
+		struct bio_vec bvec;
 		size_t size = sg->length - emsg->offset;
 		int offset = sg->offset + emsg->offset;
 		struct page *p;
@@ -220,11 +222,13 @@ static int espintcp_sendskmsg_locked(struct sock *sk,
 		emsg->offset = 0;
 
 		if (sg_is_last(sg))
-			flags &= ~MSG_SENDPAGE_NOTLAST;
+			msghdr.msg_flags &= ~MSG_SENDPAGE_NOTLAST;
 
 		p = sg_page(sg);
 retry:
-		ret = do_tcp_sendpages(sk, p, offset, size, flags);
+		bvec_set_page(&bvec, p, size, offset);
+		iov_iter_bvec(&msghdr.msg_iter, ITER_SOURCE, &bvec, 1, size);
+		ret = tcp_sendmsg_locked(sk, &msghdr, size);
 		if (ret < 0) {
 			emsg->offset = offset - sg->offset;
 			skmsg->sg.start += done;

