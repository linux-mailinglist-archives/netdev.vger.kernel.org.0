Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51930631A6F
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 08:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiKUHjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 02:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiKUHjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 02:39:39 -0500
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAFC13DC4;
        Sun, 20 Nov 2022 23:39:38 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4NFzmj33PDz4f3v7Z;
        Mon, 21 Nov 2022 15:39:33 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
        by APP4 (Coremail) with SMTP id gCh0CgC329g0K3tj2M2XAw--.53628S9;
        Mon, 21 Nov 2022 15:39:36 +0800 (CST)
From:   Ye Bin <yebin@huaweicloud.com>
To:     ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org,
        linux_oss@crudebyte.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, yebin10@huawei.com
Subject: [PATCH 5/5] 9p: refactor 'post_recv()'
Date:   Mon, 21 Nov 2022 16:00:49 +0800
Message-Id: <20221121080049.3850133-6-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221121080049.3850133-1-yebin@huaweicloud.com>
References: <20221121080049.3850133-1-yebin@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgC329g0K3tj2M2XAw--.53628S9
X-Coremail-Antispam: 1UD129KBjvJXoWxJF4fGr1rKF1fJFykAFyUAwb_yoWrXr1fpF
        4fuwsIyrZ0qF17Cw4kKa4UZF12kr4rCa1rG3y8Kws3JFn8trn5KF4jyryFgFWxuFZ7J3WF
        yr1DKFWruF1UZrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBab4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
        Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
        rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267
        AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E
        14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
        xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Y
        z7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2
        Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
        6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0x
        vE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY
        6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aV
        CY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07UZo7tUUUUU=
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

Refactor 'post_recv()', move receive resource request from 'rdma_request()' to
'post_recv()'.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 net/9p/trans_rdma.c | 77 +++++++++++++++++++++++----------------------
 1 file changed, 39 insertions(+), 38 deletions(-)

diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index bb917389adc9..78452c289f35 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -380,19 +380,40 @@ static void rdma_destroy_trans(struct p9_trans_rdma *rdma)
 	kfree(rdma);
 }
 
-static int
-post_recv(struct p9_client *client, struct p9_rdma_context *c)
+static int post_recv(struct p9_client *client, struct p9_req_t *req)
 {
 	struct p9_trans_rdma *rdma = client->trans;
+	struct p9_rdma_context *c = NULL;
 	struct ib_recv_wr wr;
 	struct ib_sge sge;
-	int err = -EIO;
+	int err;
+
+	c = kmalloc(sizeof *c, GFP_NOFS);
+	if (!c) {
+		err = -ENOMEM;
+		goto error;
+	}
+	c->rc.sdata = req->rc.sdata;
+
+	/*
+	 * Post a receive buffer for this request. We need to ensure
+	 * there is a reply buffer available for every outstanding
+	 * request. A flushed request can result in no reply for an
+	 * outstanding request, so we must keep a count to avoid
+	 * overflowing the RQ.
+	 */
+	if (down_interruptible(&rdma->rq_sem)) {
+		err = -EINTR;
+		goto error;
+	}
 
 	c->busa = ib_dma_map_single(rdma->cm_id->device,
 				    c->rc.sdata, client->msize,
 				    DMA_FROM_DEVICE);
-	if (ib_dma_mapping_error(rdma->cm_id->device, c->busa))
-		goto error;
+	if (ib_dma_mapping_error(rdma->cm_id->device, c->busa)) {
+		err = -EIO;
+		goto sem_error;
+	}
 
 	c->cqe.done = recv_done;
 
@@ -405,15 +426,18 @@ post_recv(struct p9_client *client, struct p9_rdma_context *c)
 	wr.sg_list = &sge;
 	wr.num_sge = 1;
 	err = ib_post_recv(rdma->qp, &wr, NULL);
-	if (err) {
-		ib_dma_unmap_single(rdma->cm_id->device, c->busa,
-				    client->msize, DMA_FROM_DEVICE);
-		goto error;
-	}
+	if (err)
+		goto mapping_error;
+
 	return 0;
- error:
+
+mapping_error:
+	ib_dma_unmap_single(rdma->cm_id->device, c->busa,
+			    client->msize, DMA_FROM_DEVICE);
+sem_error:
 	up(&rdma->rq_sem);
-	p9_debug(P9_DEBUG_ERROR, "EIO\n");
+error:
+	kfree(c);
 	return err;
 }
 
@@ -481,9 +505,8 @@ static int post_send(struct p9_client *client, struct p9_req_t *req)
 static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 {
 	struct p9_trans_rdma *rdma = client->trans;
-	int err = 0;
 	unsigned long flags;
-	struct p9_rdma_context *rpl_context = NULL;
+	int err;
 
 	/* When an error occurs between posting the recv and the send,
 	 * there will be a receive context posted without a pending request.
@@ -505,27 +528,7 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 		}
 	}
 
-	/* Allocate an fcall for the reply */
-	rpl_context = kmalloc(sizeof *rpl_context, GFP_NOFS);
-	if (!rpl_context) {
-		err = -ENOMEM;
-		goto recv_error;
-	}
-	rpl_context->rc.sdata = req->rc.sdata;
-
-	/*
-	 * Post a receive buffer for this request. We need to ensure
-	 * there is a reply buffer available for every outstanding
-	 * request. A flushed request can result in no reply for an
-	 * outstanding request, so we must keep a count to avoid
-	 * overflowing the RQ.
-	 */
-	if (down_interruptible(&rdma->rq_sem)) {
-		err = -EINTR;
-		goto recv_error;
-	}
-
-	err = post_recv(client, rpl_context);
+	err = post_recv(client, req);
 	if (err) {
 		p9_debug(P9_DEBUG_ERROR, "POST RECV failed: %d\n", err);
 		goto recv_error;
@@ -547,9 +550,7 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 	}
 	return err;
 
- /* Handle errors that happened during or while preparing post_recv(): */
- recv_error:
-	kfree(rpl_context);
+recv_error:
 	spin_lock_irqsave(&rdma->req_lock, flags);
 	if (err != -EINTR && rdma->state < P9_RDMA_CLOSING) {
 		rdma->state = P9_RDMA_CLOSING;
-- 
2.31.1

