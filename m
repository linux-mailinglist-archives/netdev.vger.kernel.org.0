Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20956D0650
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 15:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbjC3NR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 09:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbjC3NR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 09:17:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1EE599
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 06:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680182198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RJ8WcoQow4ucTg8JtWmjD6YfkfaI8HhqF7kGxaQnvWc=;
        b=ITuyMsP2CLo4vIdmP8TV72okoPGx65QaEGxh4XqEIi0O/jO7KPQEBrRB5+tu4nSoqwzjlP
        rinyJhvjucsufFsdiMM5kv2WM0/kKFJ+RWhtTzWqqH+umck88zXfrMJlBvK4JaQW2t4e+r
        r4coAdGbfk7tYzbVJQ002tMpgut4UcI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-RKrPMFXCPma0vF7S411Crg-1; Thu, 30 Mar 2023 09:16:35 -0400
X-MC-Unique: RKrPMFXCPma0vF7S411Crg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A788C8028B2;
        Thu, 30 Mar 2023 13:16:33 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E391492B00;
        Thu, 30 Mar 2023 13:16:31 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <812034.1680181285@warthog.procyon.org.uk>
References: <812034.1680181285@warthog.procyon.org.uk> <6F2985FF-2474-4F36-BD94-5F8E97E46AC2@oracle.com> <20230329141354.516864-1-dhowells@redhat.com> <20230329141354.516864-41-dhowells@redhat.com>
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
Content-ID: <812754.1680182190.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 30 Mar 2023 14:16:30 +0100
Message-ID: <812755.1680182190@warthog.procyon.org.uk>
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

David Howells <dhowells@redhat.com> wrote:

> Chuck Lever III <chuck.lever@oracle.com> wrote:
> =

> > Simply replacing the kernel_sendpage() loop would be a
> > straightforward change and easy to evaluate and test, and
> > I'd welcome that without hesitation.
> =

> How about the attached for a first phase?
> =

> It does three sendmsgs, one for the marker + header, one for the body an=
d one
> for the tail.

... And this as a second phase.

David
---
sunrpc: Allow xdr->bvec[] to be extended to do a single sendmsg

Allow xdr->bvec[] to be extended and insert the marker, the header and the
tail into it so that a single sendmsg() can be used to transmit the messag=
e.

I wonder if it would be possible to insert the marker at the beginning of =
the
head buffer.

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
 include/linux/sunrpc/xdr.h |    2 -
 net/sunrpc/svcsock.c       |   46 ++++++++++++++-------------------------=
------
 net/sunrpc/xdr.c           |   19 ++++++++++--------
 net/sunrpc/xprtsock.c      |    6 ++---
 4 files changed, 30 insertions(+), 43 deletions(-)

diff --git a/include/linux/sunrpc/xdr.h b/include/linux/sunrpc/xdr.h
index 72014c9216fc..c74ea483228b 100644
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -137,7 +137,7 @@ void	xdr_inline_pages(struct xdr_buf *, unsigned int,
 			 struct page **, unsigned int, unsigned int);
 void	xdr_terminate_string(const struct xdr_buf *, const u32);
 size_t	xdr_buf_pagecount(const struct xdr_buf *buf);
-int	xdr_alloc_bvec(struct xdr_buf *buf, gfp_t gfp);
+int	xdr_alloc_bvec(struct xdr_buf *buf, gfp_t gfp, unsigned int head, uns=
igned int tail);
 void	xdr_free_bvec(struct xdr_buf *buf);
 =

 static inline __be32 *xdr_encode_array(__be32 *p, const void *s, unsigned=
 int len)
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 14efcc08c6f8..e55761fe1ccf 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -569,7 +569,7 @@ static int svc_udp_sendto(struct svc_rqst *rqstp)
 	if (svc_xprt_is_dead(xprt))
 		goto out_notconn;
 =

-	err =3D xdr_alloc_bvec(xdr, GFP_KERNEL);
+	err =3D xdr_alloc_bvec(xdr, GFP_KERNEL, 0, 0);
 	if (err < 0)
 		goto out_unlock;
 =

@@ -1073,45 +1073,29 @@ static int svc_tcp_sendmsg(struct socket *sock, st=
ruct xdr_buf *xdr,
 {
 	const struct kvec *head =3D xdr->head;
 	const struct kvec *tail =3D xdr->tail;
-	struct kvec kv[2];
-	struct msghdr msg =3D { .msg_flags =3D MSG_SPLICE_PAGES | MSG_MORE, };
-	size_t sent;
+	struct msghdr msg =3D { .msg_flags =3D MSG_SPLICE_PAGES, };
+	size_t n;
 	int ret;
 =

 	*sentp =3D 0;
-	ret =3D xdr_alloc_bvec(xdr, GFP_KERNEL);
+	ret =3D xdr_alloc_bvec(xdr, GFP_KERNEL, 2, 1);
 	if (ret < 0)
 		return ret;
 =

-	kv[0].iov_base =3D &marker;
-	kv[0].iov_len =3D sizeof(marker);
-	kv[1] =3D *head;
-	iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, kv, 2, sizeof(marker) + head->=
iov_len);
+	n =3D 2 + xdr_buf_pagecount(xdr);
+	bvec_set_virt(&xdr->bvec[0], &marker, sizeof(marker));
+	bvec_set_virt(&xdr->bvec[1], head->iov_base, head->iov_len);
+	bvec_set_virt(&xdr->bvec[n], tail->iov_base, tail->iov_len);
+	if (tail->iov_len)
+		n++;
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, xdr->bvec, n,
+		      sizeof(marker) + xdr->len);
 	ret =3D sock_sendmsg(sock, &msg);
 	if (ret < 0)
 		return ret;
-	sent =3D ret;
-
-	if (!tail->iov_len)
-		msg.msg_flags &=3D ~MSG_MORE;
-	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, xdr->bvec,
-		      xdr_buf_pagecount(xdr), xdr->page_len);
-	ret =3D sock_sendmsg(sock, &msg);
-	if (ret < 0)
-		return ret;
-	sent +=3D ret;
-
-	if (tail->iov_len) {
-		msg.msg_flags &=3D ~MSG_MORE;
-		iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, tail, 1, tail->iov_len);
-		ret =3D sock_sendmsg(sock, &msg);
-		if (ret < 0)
-			return ret;
-		sent +=3D ret;
-	}
-	if (sent > 0)
-		*sentp =3D sent;
-	if (sent !=3D sizeof(marker) + xdr->len)
+	if (ret > 0)
+		*sentp =3D ret;
+	if (ret !=3D sizeof(marker) + xdr->len)
 		return -EAGAIN;
 	return 0;
 }
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 36835b2f5446..695821963849 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -141,18 +141,21 @@ size_t xdr_buf_pagecount(const struct xdr_buf *buf)
 }
 =

 int
-xdr_alloc_bvec(struct xdr_buf *buf, gfp_t gfp)
+xdr_alloc_bvec(struct xdr_buf *buf, gfp_t gfp, unsigned int head, unsigne=
d int tail)
 {
-	size_t i, n =3D xdr_buf_pagecount(buf);
+	size_t i, j =3D 0, n =3D xdr_buf_pagecount(buf);
 =

-	if (n !=3D 0 && buf->bvec =3D=3D NULL) {
-		buf->bvec =3D kmalloc_array(n, sizeof(buf->bvec[0]), gfp);
+	if (head + n + tail !=3D 0 && buf->bvec =3D=3D NULL) {
+		buf->bvec =3D kmalloc_array(head + n + tail,
+					  sizeof(buf->bvec[0]), gfp);
 		if (!buf->bvec)
 			return -ENOMEM;
-		for (i =3D 0; i < n; i++) {
-			bvec_set_page(&buf->bvec[i], buf->pages[i], PAGE_SIZE,
-				      0);
-		}
+		for (i =3D 0; i < head; i++)
+			bvec_set_page(&buf->bvec[j++], NULL, 0, 0);
+		for (i =3D 0; i < n; i++)
+			bvec_set_page(&buf->bvec[j++], buf->pages[i], PAGE_SIZE, 0);
+		for (i =3D 0; i < tail; i++)
+			bvec_set_page(&buf->bvec[j++], NULL, 0, 0);
 	}
 	return 0;
 }
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index adcbedc244d6..fdf67e84b1c7 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -825,7 +825,7 @@ static int xs_stream_nospace(struct rpc_rqst *req, boo=
l vm_wait)
 =

 static int xs_stream_prepare_request(struct rpc_rqst *req, struct xdr_buf=
 *buf)
 {
-	return xdr_alloc_bvec(buf, rpc_task_gfp_mask());
+	return xdr_alloc_bvec(buf, rpc_task_gfp_mask(), 0, 0);
 }
 =

 /*
@@ -954,7 +954,7 @@ static int xs_udp_send_request(struct rpc_rqst *req)
 	if (!xprt_request_get_cong(xprt, req))
 		return -EBADSLT;
 =

-	status =3D xdr_alloc_bvec(xdr, rpc_task_gfp_mask());
+	status =3D xdr_alloc_bvec(xdr, rpc_task_gfp_mask(), 0, 0);
 	if (status < 0)
 		return status;
 	req->rq_xtime =3D ktime_get();
@@ -2591,7 +2591,7 @@ static int bc_sendto(struct rpc_rqst *req)
 	int err;
 =

 	req->rq_xtime =3D ktime_get();
-	err =3D xdr_alloc_bvec(xdr, rpc_task_gfp_mask());
+	err =3D xdr_alloc_bvec(xdr, rpc_task_gfp_mask(), 0, 0);
 	if (err < 0)
 		return err;
 	err =3D xprt_sock_sendmsg(transport->sock, &msg, xdr, 0, marker, &sent);

