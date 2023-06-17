Return-Path: <netdev+bounces-11721-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E154C7340C6
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 14:14:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E6AA1C20946
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 12:14:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13C3AAD34;
	Sat, 17 Jun 2023 12:12:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07735BA4A
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 12:12:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE679213B
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 05:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687003954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fr8R9cUCocDj4LYXtGmeXkCgA5OgO4hqxYPqdNjfTX8=;
	b=KzjLxxkWunU3KoUPtsMBFo5XQrR6fLfyIFixffPEeLjocyWoH0B5syxHwPm6wsHiO4LL8J
	A5SEa6vfUvskxlPJ4XAT3Jxt41dMFF4zNn7E/teJ3hQIUtjRmprA28IOmZAiBkIbgmKpdn
	UWw1ACF+6cAC5xMSQsojXmsKQkd1Ni0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-5_avo79NPta2RKQidrmpCQ-1; Sat, 17 Jun 2023 08:12:32 -0400
X-MC-Unique: 5_avo79NPta2RKQidrmpCQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB1253803506;
	Sat, 17 Jun 2023 12:12:31 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.51])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0A20F1415102;
	Sat, 17 Jun 2023 12:12:29 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: netdev@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Alexander Duyck <alexander.duyck@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Santosh Shilimkar <santosh.shilimkar@oracle.com>,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com
Subject: [PATCH net-next v2 08/17] rds: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage
Date: Sat, 17 Jun 2023 13:11:37 +0100
Message-ID: <20230617121146.716077-9-dhowells@redhat.com>
In-Reply-To: <20230617121146.716077-1-dhowells@redhat.com>
References: <20230617121146.716077-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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
 net/rds/tcp_send.c | 74 +++++++++++++++++-----------------------------
 1 file changed, 27 insertions(+), 47 deletions(-)

diff --git a/net/rds/tcp_send.c b/net/rds/tcp_send.c
index 8c4d1d6e9249..550390d5ff2b 100644
--- a/net/rds/tcp_send.c
+++ b/net/rds/tcp_send.c
@@ -52,29 +52,23 @@ void rds_tcp_xmit_path_complete(struct rds_conn_path *cp)
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
@@ -101,41 +95,26 @@ int rds_tcp_xmit(struct rds_connection *conn, struct rds_message *rm,
 		/* see rds_tcp_write_space() */
 		set_bit(SOCK_NOSPACE, &tc->t_sock->sk->sk_socket->flags);
 
-		ret = rds_tcp_sendmsg(tc->t_sock,
-				      (void *)&rm->m_inc.i_hdr + hdr_off,
-				      sizeof(rm->m_inc.i_hdr) - hdr_off);
-		if (ret < 0)
-			goto out;
-		done += ret;
-		if (hdr_off + done != sizeof(struct rds_header))
-			goto out;
+		bvec_set_virt(&bvec[ix], (void *)&rm->m_inc.i_hdr + hdr_off,
+			      sizeof(rm->m_inc.i_hdr) - hdr_off);
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
@@ -158,6 +137,7 @@ int rds_tcp_xmit(struct rds_connection *conn, struct rds_message *rm,
 	}
 	if (done == 0)
 		done = ret;
+	kfree(bvec);
 	return done;
 }
 


