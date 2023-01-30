Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4AE68097F
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236344AbjA3J2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235793AbjA3J2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:28:24 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C84F30EA0;
        Mon, 30 Jan 2023 01:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=H1w/sob2deIb9pxt4pAEZWp01So4kETnigr7yzrrzGg=; b=ykPzBC64zt0+24f/idcoY5rPHl
        IsFgekhQQBB15Wh2AupkIyS/+sF/MEgiCkwkAzgtsu3rOUsznVfVUdBr0/uyOlhk5rx+h6DR0d9Oq
        gLrt+9Bh4LcQxj8juVhz0PYX3bpL3oDqD7A7afZtVPoATxq+y4I8dtDm7Fx4FySiMWhyJMVEXE5S5
        IeDwhKFrXApv9OFQJhn1/to8z+gpYIhjxn4yvN9X71cbtbfi5fbILaUAJrrmpPdUhZHmWkHIRSHQb
        LJjeyTDO81kNei1tQOu95oSLdNf1G2DlmwqbKXJcHxLcuUQRAtvvSjB9dI7ZC0svAqSMARkOGYONl
        UAzlVl5Q==;
Received: from [2001:4bb8:19a:272a:732e:e417:47d7:2f4a] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pMQNy-002oTE-C6; Mon, 30 Jan 2023 09:23:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Xiubo Li <xiubli@redhat.com>, Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        devel@lists.orangefs.org, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 23/23] net-ceph: use bvec_set_page to initialize bvecs
Date:   Mon, 30 Jan 2023 10:21:57 +0100
Message-Id: <20230130092157.1759539-24-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230130092157.1759539-1-hch@lst.de>
References: <20230130092157.1759539-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,T_SPF_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the bvec_set_page helper to initialize bvecs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/ceph/messenger_v1.c |  7 ++-----
 net/ceph/messenger_v2.c | 28 +++++++++++-----------------
 2 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index d1787d7d33ef9a..d664cb1593a777 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -40,15 +40,12 @@ static int ceph_tcp_recvmsg(struct socket *sock, void *buf, size_t len)
 static int ceph_tcp_recvpage(struct socket *sock, struct page *page,
 		     int page_offset, size_t length)
 {
-	struct bio_vec bvec = {
-		.bv_page = page,
-		.bv_offset = page_offset,
-		.bv_len = length
-	};
+	struct bio_vec bvec;
 	struct msghdr msg = { .msg_flags = MSG_DONTWAIT | MSG_NOSIGNAL };
 	int r;
 
 	BUG_ON(page_offset + length > PAGE_SIZE);
+	bvec_set_page(&bvec, page, length, page_offset);
 	iov_iter_bvec(&msg.msg_iter, ITER_DEST, &bvec, 1, length);
 	r = sock_recvmsg(sock, &msg, msg.msg_flags);
 	if (r == -EAGAIN)
diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index 3009028c4fa28f..301a991dc6a68e 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -149,10 +149,10 @@ static int do_try_sendpage(struct socket *sock, struct iov_iter *it)
 
 	while (iov_iter_count(it)) {
 		/* iov_iter_iovec() for ITER_BVEC */
-		bv.bv_page = it->bvec->bv_page;
-		bv.bv_offset = it->bvec->bv_offset + it->iov_offset;
-		bv.bv_len = min(iov_iter_count(it),
-				it->bvec->bv_len - it->iov_offset);
+		bvec_set_page(&bv, it->bvec->bv_page,
+			      min(iov_iter_count(it),
+				  it->bvec->bv_len - it->iov_offset),
+			      it->bvec->bv_offset + it->iov_offset);
 
 		/*
 		 * sendpage cannot properly handle pages with
@@ -286,9 +286,8 @@ static void set_out_bvec_zero(struct ceph_connection *con)
 	WARN_ON(iov_iter_count(&con->v2.out_iter));
 	WARN_ON(!con->v2.out_zero);
 
-	con->v2.out_bvec.bv_page = ceph_zero_page;
-	con->v2.out_bvec.bv_offset = 0;
-	con->v2.out_bvec.bv_len = min(con->v2.out_zero, (int)PAGE_SIZE);
+	bvec_set_page(&con->v2.out_bvec, ceph_zero_page,
+		      min(con->v2.out_zero, (int)PAGE_SIZE), 0);
 	con->v2.out_iter_sendpage = true;
 	iov_iter_bvec(&con->v2.out_iter, ITER_SOURCE, &con->v2.out_bvec, 1,
 		      con->v2.out_bvec.bv_len);
@@ -863,10 +862,7 @@ static void get_bvec_at(struct ceph_msg_data_cursor *cursor,
 
 	/* get a piece of data, cursor isn't advanced */
 	page = ceph_msg_data_next(cursor, &off, &len);
-
-	bv->bv_page = page;
-	bv->bv_offset = off;
-	bv->bv_len = len;
+	bvec_set_page(bv, page, len, off);
 }
 
 static int calc_sg_cnt(void *buf, int buf_len)
@@ -1855,9 +1851,8 @@ static void prepare_read_enc_page(struct ceph_connection *con)
 	     con->v2.in_enc_resid);
 	WARN_ON(!con->v2.in_enc_resid);
 
-	bv.bv_page = con->v2.in_enc_pages[con->v2.in_enc_i];
-	bv.bv_offset = 0;
-	bv.bv_len = min(con->v2.in_enc_resid, (int)PAGE_SIZE);
+	bvec_set_page(&bv, con->v2.in_enc_pages[con->v2.in_enc_i],
+		      min(con->v2.in_enc_resid, (int)PAGE_SIZE), 0);
 
 	set_in_bvec(con, &bv);
 	con->v2.in_enc_i++;
@@ -2998,9 +2993,8 @@ static void queue_enc_page(struct ceph_connection *con)
 	     con->v2.out_enc_resid);
 	WARN_ON(!con->v2.out_enc_resid);
 
-	bv.bv_page = con->v2.out_enc_pages[con->v2.out_enc_i];
-	bv.bv_offset = 0;
-	bv.bv_len = min(con->v2.out_enc_resid, (int)PAGE_SIZE);
+	bvec_set_page(&bv, con->v2.out_enc_pages[con->v2.out_enc_i],
+		      min(con->v2.out_enc_resid, (int)PAGE_SIZE), 0);
 
 	set_out_bvec(con, &bv, false);
 	con->v2.out_enc_i++;
-- 
2.39.0

