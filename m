Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C630E1A8ED8
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 01:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634339AbgDNXCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 19:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2634321AbgDNXCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 19:02:09 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BEB8C061A0C
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 16:02:09 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 20so7260827qkl.10
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 16:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G97zkBNRyySh5txmeGq9cKz6S6trOBJKgLryq5aO2f8=;
        b=CzsC+AD55ARAnqtGjSdW0gEVS9paXztBinbodLgrKeBOyZBLJSTTVGoTxqkIwVKh7V
         xQEl4pEHpg/8VkxEU/LV336i7gS/Egzc3NfL3jGqpnSHTpA4IqjUYfN8mKwvCmfQcV6y
         oslsQunsSMFfTLn0DMha19b8ghgxhQ5gvzRLlDpXfVjxuDmtY8BbdCOw+1kSXJGocAKc
         BSo4M8UOOqZ1jeopMbnwY/FOaSh1wa5jX8+EUzeeWj4Lh3chZuxyCOJ49xVv3JhDh4Sj
         PKLrW11F52rffDHt+kcws89w95blAtUg3/vChv37UW/uzbopeL4oQAY+2VCdAua2nnUK
         evmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G97zkBNRyySh5txmeGq9cKz6S6trOBJKgLryq5aO2f8=;
        b=l6wpamARgntWNBxUK+HGOZ2lVlC5tfpmehapKsRRLGsSF38ZNWjNbZwFQZmx1aUswN
         N6zao8St4D6T8tuykfn2UCr9oiPgioAC8hPLslfS2iJ9I7RwddsUy9buep4Zc03Fu3ar
         HfwIwdp9fnoL6MVFKiaM3imTGns1tvmIgIXwaagXH4Iud0GqXTV6zSZhhpRo2GUpplKb
         mwe2GyBlsC4OwXlpNoONycXoJ4XJLk1LDtuSoDYzzHSFrXgwGg5PSO0qYuoxT8jwBBN2
         s4uFxJ6Bwqaltml/1C+1oTXVSnn85AlvvH7B5qBrg+AlLSzuBqZVP0BOOw+pEfTpBDAA
         IQ2w==
X-Gm-Message-State: AGi0Pua/o6wPf0F9ucLIAjEQ2X3kjKN1FzFkS3Y/sG2jqnnCF7/B3aav
        we57JE8qwjnz+pNkfehD2Dp4A2Satv2odA==
X-Google-Smtp-Source: APiQypJbvZJiaA9elJAdioLrhcNR+T8+UbyllHK4lcqmPPC3dYKPMCD8rBfvtaDo1hoikcJGlwjpoA==
X-Received: by 2002:ae9:e011:: with SMTP id m17mr12572605qkk.103.1586905328317;
        Tue, 14 Apr 2020 16:02:08 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id w42sm9135530qtj.63.2020.04.14.16.02.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Apr 2020 16:02:07 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jOUZD-0002Fj-9V; Tue, 14 Apr 2020 20:02:07 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com
Subject: [PATCH] net/rds: Use ERR_PTR for rds_message_alloc_sgs()
Date:   Tue, 14 Apr 2020 20:02:07 -0300
Message-Id: <0-v1-a3e19ba593e0+f5-rds_gcc10%jgg@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

Returning the error code via a 'int *ret' when the function returns a
pointer is very un-kernely and causes gcc 10's static analysis to choke:

net/rds/message.c: In function ‘rds_message_map_pages’:
net/rds/message.c:358:10: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  358 |   return ERR_PTR(ret);

Use a typical ERR_PTR return instead.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 net/rds/message.c | 19 ++++++-------------
 net/rds/rdma.c    | 12 ++++++++----
 net/rds/rds.h     |  3 +--
 net/rds/send.c    |  6 ++++--
 4 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index 50f13f1d4ae091..2d43e13d6dd598 100644
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
index 585e6b3b69ce4c..554ea7f0277f01 100644
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
index e4a60352308369..b8b7ad766046cb 100644
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
index 82dcd8b84fe779..68e2bdb08fd099 100644
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
2.26.0

