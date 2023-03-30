Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23EE56D084A
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 16:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbjC3O2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 10:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbjC3O1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 10:27:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D837126
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 07:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680186427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iywXSeja+4hH/ErrL8m8CoW+J3pVfduyOhfyme6hsWE=;
        b=SvhqIG5b1FGJ8k2Ezz11qLHpJawCGWlvM5HIohPgr6WcWUmNsqvPWfI1IloCExHOai2ari
        QDsf8yL0mINEtR+HCyxeBaYPF4SbHPNoLVPedpaoEWIB6H4Fpbo6Q81t+TXkzqiywxY5o8
        fxUzZBM5frQkNuE3xmZVF4yDdpvshfc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-0cvLYY7SPAuqjcSsQFN8FA-1; Thu, 30 Mar 2023 10:27:03 -0400
X-MC-Unique: 0cvLYY7SPAuqjcSsQFN8FA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9AC95100DEA9;
        Thu, 30 Mar 2023 14:27:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56203404DC50;
        Thu, 30 Mar 2023 14:27:00 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <3A132FA8-A764-416E-9753-08E368D6877A@oracle.com>
References: <3A132FA8-A764-416E-9753-08E368D6877A@oracle.com> <812034.1680181285@warthog.procyon.org.uk> <6F2985FF-2474-4F36-BD94-5F8E97E46AC2@oracle.com> <20230329141354.516864-1-dhowells@redhat.com> <20230329141354.516864-41-dhowells@redhat.com> <812755.1680182190@warthog.procyon.org.uk>
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
Content-ID: <822316.1680186419.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 30 Mar 2023 15:26:59 +0100
Message-ID: <822317.1680186419@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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

> Don't. Just change svc_tcp_send_kvec() to use sock_sendmsg, and
> leave the marker alone for now, please.

If you insist.  See attached.

David
---
sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather then sendpage

When transmitting data, call down into TCP using sendmsg with
MSG_SPLICE_PAGES to indicate that content should be spliced rather than
performing sendpage calls to transmit header, data pages and trailer.

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
 include/linux/sunrpc/svc.h |   11 +++++------
 net/sunrpc/svcsock.c       |   40 +++++++++++++--------------------------=
-
 2 files changed, 18 insertions(+), 33 deletions(-)

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
index 03a4f5615086..af146e053dfc 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1059,17 +1059,18 @@ static int svc_tcp_recvfrom(struct svc_rqst *rqstp=
)
 	svc_xprt_received(rqstp->rq_xprt);
 	return 0;	/* record not complete */
 }
-
+ =

 static int svc_tcp_send_kvec(struct socket *sock, const struct kvec *vec,
 			      int flags)
 {
-	return kernel_sendpage(sock, virt_to_page(vec->iov_base),
-			       offset_in_page(vec->iov_base),
-			       vec->iov_len, flags);
+	struct msghdr msg =3D { .msg_flags =3D MSG_SPLICE_PAGES | flags, };
+
+	iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, vec, 1, vec->iov_len);
+	return sock_sendmsg(sock, &msg);
 }
 =

 /*
- * kernel_sendpage() is used exclusively to reduce the number of
+ * MSG_SPLICE_PAGES is used exclusively to reduce the number of
  * copy operations in this path. Therefore the caller must ensure
  * that the pages backing @xdr are unchanging.
  *
@@ -1109,28 +1110,13 @@ static int svc_tcp_sendmsg(struct socket *sock, st=
ruct xdr_buf *xdr,
 	if (ret !=3D head->iov_len)
 		goto out;
 =

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
+	msg.msg_flags =3D MSG_SPLICE_PAGES;
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, xdr->bvec,
+		      xdr_buf_pagecount(xdr), xdr->page_len);
+	ret =3D sock_sendmsg(sock, &msg);
+	if (ret < 0)
+		return ret;
+	*sentp +=3D ret;
 =

 	if (tail->iov_len) {
 		ret =3D svc_tcp_send_kvec(sock, tail, 0);

