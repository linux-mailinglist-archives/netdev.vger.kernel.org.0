Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251F16BD3C4
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbjCPPag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbjCPP32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:29:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63422DFB7A
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678980452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=92bJ6Ynf1CSTwRAMP7lCPtKM1kI8JBpDgRb6Ls1sSMY=;
        b=T0560YF+UveLKxyIQx6ZoR8+u2KbXX6nJFjTC5hjHOz+cSSMCuSj4NAPRca4lgCrGFvgOY
        a5IlhQiCB/0Aed3TQL2WKKrNXo6k9MZyAW77v+B0xLHNLqx5CmWnWpMmza8FxDQXdGGKmy
        oRdN18ieOdADNNnOI62KEaUJGuRjw54=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-Uky157iCM7O_1XjnKbwmzg-1; Thu, 16 Mar 2023 11:27:30 -0400
X-MC-Unique: Uky157iCM7O_1XjnKbwmzg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D062185A791;
        Thu, 16 Mar 2023 15:27:29 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 150B540B3ED6;
        Thu, 16 Mar 2023 15:27:26 +0000 (UTC)
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
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Subject: [RFC PATCH 25/28] rds: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage
Date:   Thu, 16 Mar 2023 15:26:15 +0000
Message-Id: <20230316152618.711970-26-dhowells@redhat.com>
In-Reply-To: <20230316152618.711970-1-dhowells@redhat.com>
References: <20230316152618.711970-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When transmitting data, call down into TCP using a single sendmsg with
MSG_SPLICE_PAGES to indicate that content should be spliced rather than
performing several sendmsg and sendpage calls to transmit header and data
pages.

To make this work, the data is assembled in a bio_vec array and attached to
a BVEC-type iterator.  The header are copied into memory acquired from
zcopy_alloc() which just breaks a page up into small pieces that can be
freed with put_page().

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: linux-rdma@vger.kernel.org
cc: rds-devel@oss.oracle.com
cc: netdev@vger.kernel.org
---
 net/rds/tcp_send.c | 80 ++++++++++++++++++++--------------------------
 1 file changed, 35 insertions(+), 45 deletions(-)

diff --git a/net/rds/tcp_send.c b/net/rds/tcp_send.c
index 8c4d1d6e9249..0d6eb85a930d 100644
--- a/net/rds/tcp_send.c
+++ b/net/rds/tcp_send.c
@@ -32,6 +32,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/in.h>
+#include <linux/zcopy_alloc.h>
 #include <net/tcp.h>
 
 #include "rds_single_path.h"
@@ -52,29 +53,24 @@ void rds_tcp_xmit_path_complete(struct rds_conn_path *cp)
 	tcp_sock_set_cork(tc->t_sock->sk, false);
 }
 
-/* the core send_sem serializes this with other xmit and shutdown */
-static int rds_tcp_sendmsg(struct socket *sock, void *data, unsigned int len)
-{
-	struct kvec vec = {
-		.iov_base = data,
-		.iov_len = len,
-	};
-	struct msghdr msg = {
-		.msg_flags = MSG_DONTWAIT | MSG_NOSIGNAL,
-	};
-
-	return kernel_sendmsg(sock, &msg, &vec, 1, vec.iov_len);
-}
-
 /* the core send_sem serializes this with other xmit and shutdown */
 int rds_tcp_xmit(struct rds_connection *conn, struct rds_message *rm,
 		 unsigned int hdr_off, unsigned int sg, unsigned int off)
 {
 	struct rds_conn_path *cp = rm->m_inc.i_conn_path;
 	struct rds_tcp_connection *tc = cp->cp_transport_data;
+	struct msghdr msg = {
+		.msg_flags = MSG_SPLICE_PAGES | MSG_DONTWAIT | MSG_NOSIGNAL,
+	};
+	struct bio_vec *bvec;
+	unsigned int i, size = 0, ix = 0;
+	bool free_hdr = false;
 	int done = 0;
-	int ret = 0;
-	int more;
+	int ret = -ENOMEM;
+
+	bvec = kmalloc_array(1 + sg, sizeof(struct bio_vec), GFP_KERNEL);
+	if (!bvec)
+		goto out;
 
 	if (hdr_off == 0) {
 		/*
@@ -101,41 +97,30 @@ int rds_tcp_xmit(struct rds_connection *conn, struct rds_message *rm,
 		/* see rds_tcp_write_space() */
 		set_bit(SOCK_NOSPACE, &tc->t_sock->sk->sk_socket->flags);
 
-		ret = rds_tcp_sendmsg(tc->t_sock,
-				      (void *)&rm->m_inc.i_hdr + hdr_off,
-				      sizeof(rm->m_inc.i_hdr) - hdr_off);
+		ret = zcopy_memdup(sizeof(rm->m_inc.i_hdr) - hdr_off,
+				   (void *)&rm->m_inc.i_hdr + hdr_off,
+				   &bvec[ix], GFP_KERNEL);
 		if (ret < 0)
 			goto out;
-		done += ret;
-		if (hdr_off + done != sizeof(struct rds_header))
-			goto out;
+		free_hdr = true;
+		size += bvec[ix].bv_len;
+		ix++;
 	}
 
-	more = rm->data.op_nents > 1 ? (MSG_MORE | MSG_SENDPAGE_NOTLAST) : 0;
-	while (sg < rm->data.op_nents) {
-		int flags = MSG_DONTWAIT | MSG_NOSIGNAL | more;
-
-		ret = tc->t_sock->ops->sendpage(tc->t_sock,
-						sg_page(&rm->data.op_sg[sg]),
-						rm->data.op_sg[sg].offset + off,
-						rm->data.op_sg[sg].length - off,
-						flags);
-		rdsdebug("tcp sendpage %p:%u:%u ret %d\n", (void *)sg_page(&rm->data.op_sg[sg]),
-			 rm->data.op_sg[sg].offset + off, rm->data.op_sg[sg].length - off,
-			 ret);
-		if (ret <= 0)
-			break;
-
-		off += ret;
-		done += ret;
-		if (off == rm->data.op_sg[sg].length) {
-			off = 0;
-			sg++;
-		}
-		if (sg == rm->data.op_nents - 1)
-			more = 0;
+	for (i = sg; i < rm->data.op_nents; i++) {
+		bvec_set_page(&bvec[ix],
+			      sg_page(&rm->data.op_sg[i]),
+			      rm->data.op_sg[i].length - off,
+			      rm->data.op_sg[i].offset + off);
+		off = 0;
+		size += bvec[ix].bv_len;
+		ix++;
 	}
 
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, bvec, ix, size);
+	ret = sock_sendmsg(tc->t_sock, &msg);
+	rdsdebug("tcp sendmsg-splice %u,%u ret %d\n", ix, size, ret);
+
 out:
 	if (ret <= 0) {
 		/* write_space will hit after EAGAIN, all else fatal */
@@ -158,6 +143,11 @@ int rds_tcp_xmit(struct rds_connection *conn, struct rds_message *rm,
 	}
 	if (done == 0)
 		done = ret;
+	if (bvec) {
+		if (free_hdr)
+			put_page(bvec[0].bv_page);
+		kfree(bvec);
+	}
 	return done;
 }
 

