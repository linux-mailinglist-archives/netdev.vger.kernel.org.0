Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E2D1F2E84
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgFHXM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:12:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729085AbgFHXMY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06A7C208C7;
        Mon,  8 Jun 2020 23:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657944;
        bh=1APZRQmaZ94RwQ1cAvwgySx9/rkDQcEWWledK+r1HSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mRN5rnbmbKWlM10fJD3bnsquRGyu0uhXHh08+EFQrsZKyfrXfDo8DG0DY0IKRkjae
         mYCAtfaf2dqljTKn6deWnbeWlv+zbHY4MpmKMqhyKAUrBlZnrNGJsww8pLt7PiYw8w
         T+RzibRFuZny+tfiOFUeHRhtauFM6EVvOWYjDYYo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Subject: [PATCH AUTOSEL 5.6 009/606] net/rds: Use ERR_PTR for rds_message_alloc_sgs()
Date:   Mon,  8 Jun 2020 19:02:14 -0400
Message-Id: <20200608231211.3363633-9-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit 7dba92037baf3fa00b4880a31fd532542264994c upstream.

Returning the error code via a 'int *ret' when the function returns a
pointer is very un-kernely and causes gcc 10's static analysis to choke:

net/rds/message.c: In function ‘rds_message_map_pages’:
net/rds/message.c:358:10: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  358 |   return ERR_PTR(ret);

Use a typical ERR_PTR return instead.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/message.c | 19 ++++++-------------
 net/rds/rdma.c    | 12 ++++++++----
 net/rds/rds.h     |  3 +--
 net/rds/send.c    |  6 ++++--
 4 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index 50f13f1d4ae0..2d43e13d6dd5 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -308,26 +308,20 @@ struct rds_message *rds_message_alloc(unsigned int extra_len, gfp_t gfp)
 /*
  * RDS ops use this to grab SG entries from the rm's sg pool.
  */
-struct scatterlist *rds_message_alloc_sgs(struct rds_message *rm, int nents,
-					  int *ret)
+struct scatterlist *rds_message_alloc_sgs(struct rds_message *rm, int nents)
 {
 	struct scatterlist *sg_first = (struct scatterlist *) &rm[1];
 	struct scatterlist *sg_ret;
 
-	if (WARN_ON(!ret))
-		return NULL;
-
 	if (nents <= 0) {
 		pr_warn("rds: alloc sgs failed! nents <= 0\n");
-		*ret = -EINVAL;
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	if (rm->m_used_sgs + nents > rm->m_total_sgs) {
 		pr_warn("rds: alloc sgs failed! total %d used %d nents %d\n",
 			rm->m_total_sgs, rm->m_used_sgs, nents);
-		*ret = -ENOMEM;
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	sg_ret = &sg_first[rm->m_used_sgs];
@@ -343,7 +337,6 @@ struct rds_message *rds_message_map_pages(unsigned long *page_addrs, unsigned in
 	unsigned int i;
 	int num_sgs = DIV_ROUND_UP(total_len, PAGE_SIZE);
 	int extra_bytes = num_sgs * sizeof(struct scatterlist);
-	int ret;
 
 	rm = rds_message_alloc(extra_bytes, GFP_NOWAIT);
 	if (!rm)
@@ -352,10 +345,10 @@ struct rds_message *rds_message_map_pages(unsigned long *page_addrs, unsigned in
 	set_bit(RDS_MSG_PAGEVEC, &rm->m_flags);
 	rm->m_inc.i_hdr.h_len = cpu_to_be32(total_len);
 	rm->data.op_nents = DIV_ROUND_UP(total_len, PAGE_SIZE);
-	rm->data.op_sg = rds_message_alloc_sgs(rm, num_sgs, &ret);
-	if (!rm->data.op_sg) {
+	rm->data.op_sg = rds_message_alloc_sgs(rm, num_sgs);
+	if (IS_ERR(rm->data.op_sg)) {
 		rds_message_put(rm);
-		return ERR_PTR(ret);
+		return ERR_CAST(rm->data.op_sg);
 	}
 
 	for (i = 0; i < rm->data.op_nents; ++i) {
diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 585e6b3b69ce..554ea7f0277f 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -664,9 +664,11 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rds_message *rm,
 	op->op_odp_mr = NULL;
 
 	WARN_ON(!nr_pages);
-	op->op_sg = rds_message_alloc_sgs(rm, nr_pages, &ret);
-	if (!op->op_sg)
+	op->op_sg = rds_message_alloc_sgs(rm, nr_pages);
+	if (IS_ERR(op->op_sg)) {
+		ret = PTR_ERR(op->op_sg);
 		goto out_pages;
+	}
 
 	if (op->op_notify || op->op_recverr) {
 		/* We allocate an uninitialized notifier here, because
@@ -905,9 +907,11 @@ int rds_cmsg_atomic(struct rds_sock *rs, struct rds_message *rm,
 	rm->atomic.op_silent = !!(args->flags & RDS_RDMA_SILENT);
 	rm->atomic.op_active = 1;
 	rm->atomic.op_recverr = rs->rs_recverr;
-	rm->atomic.op_sg = rds_message_alloc_sgs(rm, 1, &ret);
-	if (!rm->atomic.op_sg)
+	rm->atomic.op_sg = rds_message_alloc_sgs(rm, 1);
+	if (IS_ERR(rm->atomic.op_sg)) {
+		ret = PTR_ERR(rm->atomic.op_sg);
 		goto err;
+	}
 
 	/* verify 8 byte-aligned */
 	if (args->local_addr & 0x7) {
diff --git a/net/rds/rds.h b/net/rds/rds.h
index e4a603523083..b8b7ad766046 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -852,8 +852,7 @@ rds_conn_connecting(struct rds_connection *conn)
 
 /* message.c */
 struct rds_message *rds_message_alloc(unsigned int nents, gfp_t gfp);
-struct scatterlist *rds_message_alloc_sgs(struct rds_message *rm, int nents,
-					  int *ret);
+struct scatterlist *rds_message_alloc_sgs(struct rds_message *rm, int nents);
 int rds_message_copy_from_user(struct rds_message *rm, struct iov_iter *from,
 			       bool zcopy);
 struct rds_message *rds_message_map_pages(unsigned long *page_addrs, unsigned int total_len);
diff --git a/net/rds/send.c b/net/rds/send.c
index 82dcd8b84fe7..68e2bdb08fd0 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1274,9 +1274,11 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 
 	/* Attach data to the rm */
 	if (payload_len) {
-		rm->data.op_sg = rds_message_alloc_sgs(rm, num_sgs, &ret);
-		if (!rm->data.op_sg)
+		rm->data.op_sg = rds_message_alloc_sgs(rm, num_sgs);
+		if (IS_ERR(rm->data.op_sg)) {
+			ret = PTR_ERR(rm->data.op_sg);
 			goto out;
+		}
 		ret = rds_message_copy_from_user(rm, &msg->msg_iter, zcopy);
 		if (ret)
 			goto out;
-- 
2.25.1

