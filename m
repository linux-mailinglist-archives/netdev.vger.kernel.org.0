Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE5A6D05C8
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 15:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbjC3NCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 09:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbjC3NCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 09:02:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64EC29EEF
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 06:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680181296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HxqtYWKgKbfjvx86WVpEFEl8GyNFF30+hE41KO//gFo=;
        b=D7BWLGPhD/LTYqQMRYh4qb9r7uwWxXj0OnW3blSxEKBv7rW/XEQ0C6rUsuMNJVV/fNPIlM
        SGmf4fmHZ1A3mfI4ts47FsQWGMHS5MvXNFLowYosOHS9hyyqJWztJPQmBEBYPwdwZKj4Wx
        ai6OsJ+sT0dWC3elZubmbg/e0fJ7IzE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-WjAFCiU1Pgy2CiKK5qhhIw-1; Thu, 30 Mar 2023 09:01:30 -0400
X-MC-Unique: WjAFCiU1Pgy2CiKK5qhhIw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18845884EC5;
        Thu, 30 Mar 2023 13:01:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A8A721402C07;
        Thu, 30 Mar 2023 13:01:25 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <6F2985FF-2474-4F36-BD94-5F8E97E46AC2@oracle.com>
References: <6F2985FF-2474-4F36-BD94-5F8E97E46AC2@oracle.com> <20230329141354.516864-1-dhowells@redhat.com> <20230329141354.516864-41-dhowells@redhat.com>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     dhowells@redhat.com, Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [RFC PATCH v2 40/48] sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <812033.1680181285.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 30 Mar 2023 14:01:25 +0100
Message-ID: <812034.1680181285@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chuck Lever III <chuck.lever@oracle.com> wrote:

> Simply replacing the kernel_sendpage() loop would be a
> straightforward change and easy to evaluate and test, and
> I'd welcome that without hesitation.

How about the attached for a first phase?

It does three sendmsgs, one for the marker + header, one for the body and =
one
for the tail.

David
---
sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage

When transmitting data, call down into TCP using sendmsg with
MSG_SPLICE_PAGES to indicate that content should be spliced rather than
performing sendpage calls to transmit header, data pages and trailer.

The marker and the header are passed in an array of kvecs.  The marker wil=
l
get copied and the header will get spliced.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Trond Myklebust <trond.myklebust@hammerspace.com>
cc: Anna Schumaker <anna@kernel.org>
cc: Chuck Lever <chuck.lever@oracle.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: linux-nfs@vger.kernel.org
cc: netdev@vger.kernel.org
---
 include/linux/sunrpc/svc.h |   11 +++---
 net/sunrpc/svcsock.c       |   75 ++++++++++++++-------------------------=
------
 2 files changed, 29 insertions(+), 57 deletions(-)

diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 877891536c2f..456ae554aa11 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -161,16 +161,15 @@ static inline bool svc_put_not_last(struct svc_serv =
*serv)
 extern u32 svc_max_payload(const struct svc_rqst *rqstp);
 =

 /*
- * RPC Requsts and replies are stored in one or more pages.
+ * RPC Requests and replies are stored in one or more pages.
  * We maintain an array of pages for each server thread.
  * Requests are copied into these pages as they arrive.  Remaining
  * pages are available to write the reply into.
  *
- * Pages are sent using ->sendpage so each server thread needs to
- * allocate more to replace those used in sending.  To help keep track
- * of these pages we have a receive list where all pages initialy live,
- * and a send list where pages are moved to when there are to be part
- * of a reply.
+ * Pages are sent using ->sendmsg with MSG_SPLICE_PAGES so each server th=
read
+ * needs to allocate more to replace those used in sending.  To help keep=
 track
+ * of these pages we have a receive list where all pages initialy live, a=
nd a
+ * send list where pages are moved to when there are to be part of a repl=
y.
  *
  * We use xdr_buf for holding responses as it fits well with NFS
  * read responses (that have a header, and some data pages, and possibly
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 03a4f5615086..14efcc08c6f8 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1060,16 +1060,8 @@ static int svc_tcp_recvfrom(struct svc_rqst *rqstp)
 	return 0;	/* record not complete */
 }
 =

-static int svc_tcp_send_kvec(struct socket *sock, const struct kvec *vec,
-			      int flags)
-{
-	return kernel_sendpage(sock, virt_to_page(vec->iov_base),
-			       offset_in_page(vec->iov_base),
-			       vec->iov_len, flags);
-}
-
 /*
- * kernel_sendpage() is used exclusively to reduce the number of
+ * MSG_SPLICE_PAGES is used exclusively to reduce the number of
  * copy operations in this path. Therefore the caller must ensure
  * that the pages backing @xdr are unchanging.
  *
@@ -1081,13 +1073,9 @@ static int svc_tcp_sendmsg(struct socket *sock, str=
uct xdr_buf *xdr,
 {
 	const struct kvec *head =3D xdr->head;
 	const struct kvec *tail =3D xdr->tail;
-	struct kvec rm =3D {
-		.iov_base	=3D &marker,
-		.iov_len	=3D sizeof(marker),
-	};
-	struct msghdr msg =3D {
-		.msg_flags	=3D 0,
-	};
+	struct kvec kv[2];
+	struct msghdr msg =3D { .msg_flags =3D MSG_SPLICE_PAGES | MSG_MORE, };
+	size_t sent;
 	int ret;
 =

 	*sentp =3D 0;
@@ -1095,51 +1083,36 @@ static int svc_tcp_sendmsg(struct socket *sock, st=
ruct xdr_buf *xdr,
 	if (ret < 0)
 		return ret;
 =

-	ret =3D kernel_sendmsg(sock, &msg, &rm, 1, rm.iov_len);
+	kv[0].iov_base =3D &marker;
+	kv[0].iov_len =3D sizeof(marker);
+	kv[1] =3D *head;
+	iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, kv, 2, sizeof(marker) + head->=
iov_len);
+	ret =3D sock_sendmsg(sock, &msg);
 	if (ret < 0)
 		return ret;
-	*sentp +=3D ret;
-	if (ret !=3D rm.iov_len)
-		return -EAGAIN;
+	sent =3D ret;
 =

-	ret =3D svc_tcp_send_kvec(sock, head, 0);
+	if (!tail->iov_len)
+		msg.msg_flags &=3D ~MSG_MORE;
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, xdr->bvec,
+		      xdr_buf_pagecount(xdr), xdr->page_len);
+	ret =3D sock_sendmsg(sock, &msg);
 	if (ret < 0)
 		return ret;
-	*sentp +=3D ret;
-	if (ret !=3D head->iov_len)
-		goto out;
-
-	if (xdr->page_len) {
-		unsigned int offset, len, remaining;
-		struct bio_vec *bvec;
-
-		bvec =3D xdr->bvec + (xdr->page_base >> PAGE_SHIFT);
-		offset =3D offset_in_page(xdr->page_base);
-		remaining =3D xdr->page_len;
-		while (remaining > 0) {
-			len =3D min(remaining, bvec->bv_len - offset);
-			ret =3D kernel_sendpage(sock, bvec->bv_page,
-					      bvec->bv_offset + offset,
-					      len, 0);
-			if (ret < 0)
-				return ret;
-			*sentp +=3D ret;
-			if (ret !=3D len)
-				goto out;
-			remaining -=3D len;
-			offset =3D 0;
-			bvec++;
-		}
-	}
+	sent +=3D ret;
 =

 	if (tail->iov_len) {
-		ret =3D svc_tcp_send_kvec(sock, tail, 0);
+		msg.msg_flags &=3D ~MSG_MORE;
+		iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, tail, 1, tail->iov_len);
+		ret =3D sock_sendmsg(sock, &msg);
 		if (ret < 0)
 			return ret;
-		*sentp +=3D ret;
+		sent +=3D ret;
 	}
-
-out:
+	if (sent > 0)
+		*sentp =3D sent;
+	if (sent !=3D sizeof(marker) + xdr->len)
+		return -EAGAIN;
 	return 0;
 }
 =

