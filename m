Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D926D254B
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbjCaQTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233509AbjCaQS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:18:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1D022204
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gZm+OH3nuU2w5lgBIDJ5zMpRPGFGHnStb+oddo8E9cs=;
        b=RBrFM4XYpM+ziuhf1hmIjqOm1JH2sgRenm2aeUvUQNqeGwURuTu+ZpQYnktwtpn23CfVWO
        rngOoa4wbVWsg07Nh50IzF8uT3kBHkIR5JuWJPgUPYm+LvoDF/9iuH5lMWHOyp9BaANXlp
        18DQ1GXM2h2F+VkLGiAXzzgv7+sgs9Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-aQ6YNqtSNLCDJnr_-8NcqQ-1; Fri, 31 Mar 2023 12:11:12 -0400
X-MC-Unique: aQ6YNqtSNLCDJnr_-8NcqQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83939802D1A;
        Fri, 31 Mar 2023 16:11:11 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5AF014020C82;
        Fri, 31 Mar 2023 16:11:09 +0000 (UTC)
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
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH v3 40/55] iscsi: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage
Date:   Fri, 31 Mar 2023 17:08:59 +0100
Message-Id: <20230331160914.1608208-41-dhowells@redhat.com>
In-Reply-To: <20230331160914.1608208-1-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use sendmsg() with MSG_SPLICE_PAGES rather than sendpage.  This allows
multiple pages and multipage folios to be passed through.

TODO: iscsit_fe_sendpage_sg() should perhaps set up a bio_vec array for the
entire set of pages it's going to transfer plus two for the header and
trailer and page fragments to hold the header and trailer - and then call
sendmsg once for the entire message.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: "Martin K. Petersen" <martin.petersen@oracle.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: linux-scsi@vger.kernel.org
cc: target-devel@vger.kernel.org
cc: netdev@vger.kernel.org
---
 drivers/scsi/iscsi_tcp.c                 | 31 ++++++++++++------------
 drivers/scsi/iscsi_tcp.h                 |  2 +-
 drivers/target/iscsi/iscsi_target_util.c | 14 ++++++-----
 3 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index c76f82fb8b63..cf3eb55d2a76 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -301,35 +301,37 @@ static int iscsi_sw_tcp_xmit_segment(struct iscsi_tcp_conn *tcp_conn,
 
 	while (!iscsi_tcp_segment_done(tcp_conn, segment, 0, r)) {
 		struct scatterlist *sg;
+		struct msghdr msg = {};
+		union {
+			struct kvec kv;
+			struct bio_vec bv;
+		} vec;
 		unsigned int offset, copy;
-		int flags = 0;
 
 		r = 0;
 		offset = segment->copied;
 		copy = segment->size - offset;
 
 		if (segment->total_copied + segment->size < segment->total_size)
-			flags |= MSG_MORE | MSG_SENDPAGE_NOTLAST;
+			msg.msg_flags |= MSG_MORE | MSG_SENDPAGE_NOTLAST;
 
 		if (tcp_sw_conn->queue_recv)
-			flags |= MSG_DONTWAIT;
+			msg.msg_flags |= MSG_DONTWAIT;
 
-		/* Use sendpage if we can; else fall back to sendmsg */
 		if (!segment->data) {
+			if (tcp_conn->iscsi_conn->datadgst_en)
+				msg.msg_flags |= MSG_SPLICE_PAGES;
 			sg = segment->sg;
 			offset += segment->sg_offset + sg->offset;
-			r = tcp_sw_conn->sendpage(sk, sg_page(sg), offset,
-						  copy, flags);
+			bvec_set_page(&vec.bv, sg_page(sg), copy, offset);
+			iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &vec.bv, 1, copy);
 		} else {
-			struct msghdr msg = { .msg_flags = flags };
-			struct kvec iov = {
-				.iov_base = segment->data + offset,
-				.iov_len = copy
-			};
-
-			r = kernel_sendmsg(sk, &msg, &iov, 1, copy);
+			vec.kv.iov_base = segment->data + offset;
+			vec.kv.iov_len  = copy;
+			iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, &vec.kv, 1, copy);
 		}
 
+		r = sock_sendmsg(sk, &msg);
 		if (r < 0) {
 			iscsi_tcp_segment_unmap(segment);
 			return r;
@@ -746,7 +748,6 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 	sock_no_linger(sk);
 
 	iscsi_sw_tcp_conn_set_callbacks(conn);
-	tcp_sw_conn->sendpage = tcp_sw_conn->sock->ops->sendpage;
 	/*
 	 * set receive state machine into initial state
 	 */
@@ -778,8 +779,6 @@ static int iscsi_sw_tcp_conn_set_param(struct iscsi_cls_conn *cls_conn,
 			mutex_unlock(&tcp_sw_conn->sock_lock);
 			return -ENOTCONN;
 		}
-		tcp_sw_conn->sendpage = conn->datadgst_en ?
-			sock_no_sendpage : tcp_sw_conn->sock->ops->sendpage;
 		mutex_unlock(&tcp_sw_conn->sock_lock);
 		break;
 	case ISCSI_PARAM_MAX_R2T:
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index 68e14a344904..d6ec08d7eb63 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -48,7 +48,7 @@ struct iscsi_sw_tcp_conn {
 	uint32_t		sendpage_failures_cnt;
 	uint32_t		discontiguous_hdr_cnt;
 
-	ssize_t (*sendpage)(struct socket *, struct page *, int, size_t, int);
+	bool			can_splice_to_tcp;
 };
 
 struct iscsi_sw_tcp_host {
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 26dc8ed3045b..c7d58e41ac3b 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -1078,6 +1078,8 @@ int iscsit_fe_sendpage_sg(
 	struct iscsit_conn *conn)
 {
 	struct scatterlist *sg = cmd->first_data_sg;
+	struct bio_vec bvec;
+	struct msghdr msghdr = { .msg_flags = MSG_SPLICE_PAGES,	};
 	struct kvec iov;
 	u32 tx_hdr_size, data_len;
 	u32 offset = cmd->first_data_sg_off;
@@ -1121,17 +1123,17 @@ int iscsit_fe_sendpage_sg(
 		u32 space = (sg->length - offset);
 		u32 sub_len = min_t(u32, data_len, space);
 send_pg:
-		tx_sent = conn->sock->ops->sendpage(conn->sock,
-					sg_page(sg), sg->offset + offset, sub_len, 0);
+		bvec_set_page(&bvec, sg_page(sg), sub_len, sg->offset + offset);
+		iov_iter_bvec(&msghdr.msg_iter, ITER_SOURCE, &bvec, 1, sub_len);
+
+		tx_sent = conn->sock->ops->sendmsg(conn->sock, &msghdr, sub_len);
 		if (tx_sent != sub_len) {
 			if (tx_sent == -EAGAIN) {
-				pr_err("tcp_sendpage() returned"
-						" -EAGAIN\n");
+				pr_err("sendmsg/splice returned -EAGAIN\n");
 				goto send_pg;
 			}
 
-			pr_err("tcp_sendpage() failure: %d\n",
-					tx_sent);
+			pr_err("sendmsg/splice failure: %d\n", tx_sent);
 			return -1;
 		}
 

