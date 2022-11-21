Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A328B631A6D
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 08:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiKUHjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 02:39:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiKUHjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 02:39:39 -0500
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764542AE0E;
        Sun, 20 Nov 2022 23:39:38 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4NFzmh6wGQz4f3mTF;
        Mon, 21 Nov 2022 15:39:32 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
        by APP4 (Coremail) with SMTP id gCh0CgC329g0K3tj2M2XAw--.53628S8;
        Mon, 21 Nov 2022 15:39:35 +0800 (CST)
From:   Ye Bin <yebin@huaweicloud.com>
To:     ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org,
        linux_oss@crudebyte.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, yebin10@huawei.com
Subject: [PATCH 4/5] 9p: factor out 'post_send()'
Date:   Mon, 21 Nov 2022 16:00:48 +0800
Message-Id: <20221121080049.3850133-5-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221121080049.3850133-1-yebin@huaweicloud.com>
References: <20221121080049.3850133-1-yebin@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgC329g0K3tj2M2XAw--.53628S8
X-Coremail-Antispam: 1UD129KBjvJXoWxCrWrXry3CrWrJF17Cr4Uurg_yoWrCr43p3
        yrJa9IvrZxKF13Aws5Ka4jgF1Yyr4rCayUtryxCws3AFs0vr90yF4jyayYgFyxAFZ7Ca1r
        KryDKFZ3CryUZrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBab4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
        Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
        rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
        AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E
        14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
        xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Y
        z7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2
        Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
        6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0x
        vE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY
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

Factor out 'post_send()' to send request. No functional change.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 net/9p/trans_rdma.c | 130 +++++++++++++++++++++++---------------------
 1 file changed, 69 insertions(+), 61 deletions(-)

diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index bcab550c2e2c..bb917389adc9 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -417,14 +417,72 @@ post_recv(struct p9_client *client, struct p9_rdma_context *c)
 	return err;
 }
 
-static int rdma_request(struct p9_client *client, struct p9_req_t *req)
+static int post_send(struct p9_client *client, struct p9_req_t *req)
 {
 	struct p9_trans_rdma *rdma = client->trans;
+	struct p9_rdma_context *c = NULL;
 	struct ib_send_wr wr;
 	struct ib_sge sge;
+	int err;
+
+	c = kmalloc(sizeof *c, GFP_NOFS);
+	if (!c) {
+		err = -ENOMEM;
+		goto error;
+	}
+	c->req = req;
+
+	c->busa = ib_dma_map_single(rdma->cm_id->device,
+				    c->req->tc.sdata, c->req->tc.size,
+				    DMA_TO_DEVICE);
+	if (ib_dma_mapping_error(rdma->cm_id->device, c->busa)) {
+		err = -EIO;
+		goto error;
+	}
+
+	c->cqe.done = send_done;
+
+	sge.addr = c->busa;
+	sge.length = c->req->tc.size;
+	sge.lkey = rdma->pd->local_dma_lkey;
+
+	wr.next = NULL;
+	wr.wr_cqe = &c->cqe;
+	wr.opcode = IB_WR_SEND;
+	wr.send_flags = IB_SEND_SIGNALED;
+	wr.sg_list = &sge;
+	wr.num_sge = 1;
+
+	if (down_interruptible(&rdma->sq_sem)) {
+		err = -EINTR;
+		goto mapping_error;
+	}
+
+	/* Mark request as `sent' *before* we actually send it,
+	 * because doing if after could erase the REQ_STATUS_RCVD
+	 * status in case of a very fast reply.
+	 */
+	req->status = REQ_STATUS_SENT;
+	err = ib_post_send(rdma->qp, &wr, NULL);
+	if (err)
+		goto sem_error;
+
+	return 0;
+sem_error:
+	up(&rdma->sq_sem);
+mapping_error:
+	ib_dma_unmap_single(rdma->cm_id->device, c->busa,
+			    c->req->tc.size, DMA_TO_DEVICE);
+error:
+	kfree(c);
+	return err;
+}
+
+static int rdma_request(struct p9_client *client, struct p9_req_t *req)
+{
+	struct p9_trans_rdma *rdma = client->trans;
 	int err = 0;
 	unsigned long flags;
-	struct p9_rdma_context *c = NULL;
 	struct p9_rdma_context *rpl_context = NULL;
 
 	/* When an error occurs between posting the recv and the send,
@@ -476,67 +534,17 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 	req->rc.sdata = NULL;
 
 dont_need_post_recv:
-	/* Post the request */
-	c = kmalloc(sizeof *c, GFP_NOFS);
-	if (!c) {
-		err = -ENOMEM;
-		goto send_error;
-	}
-	c->req = req;
-
-	c->busa = ib_dma_map_single(rdma->cm_id->device,
-				    c->req->tc.sdata, c->req->tc.size,
-				    DMA_TO_DEVICE);
-	if (ib_dma_mapping_error(rdma->cm_id->device, c->busa)) {
-		err = -EIO;
-		goto send_error;
-	}
-
-	c->cqe.done = send_done;
-
-	sge.addr = c->busa;
-	sge.length = c->req->tc.size;
-	sge.lkey = rdma->pd->local_dma_lkey;
-
-	wr.next = NULL;
-	wr.wr_cqe = &c->cqe;
-	wr.opcode = IB_WR_SEND;
-	wr.send_flags = IB_SEND_SIGNALED;
-	wr.sg_list = &sge;
-	wr.num_sge = 1;
-
-	if (down_interruptible(&rdma->sq_sem)) {
-		err = -EINTR;
-		goto mapping_error;
-	}
-
-	/* Mark request as `sent' *before* we actually send it,
-	 * because doing if after could erase the REQ_STATUS_RCVD
-	 * status in case of a very fast reply.
-	 */
-	req->status = REQ_STATUS_SENT;
-	err = ib_post_send(rdma->qp, &wr, NULL);
+	err = post_send(client, req);
 	if (err) {
-		up(&rdma->sq_sem);
-		goto mapping_error;
+		req->status = REQ_STATUS_ERROR;
+		p9_debug(P9_DEBUG_ERROR, "Error %d in rdma_request()\n", err);
+
+		/* Ach.
+		 *  We did recv_post(), but not send. We have one recv_post
+		 *  in excess.
+		 */
+		atomic_inc(&rdma->excess_rc);
 	}
-
-	/* Success */
-	return 0;
-
- /* Handle errors that happened during or while preparing the send: */
- mapping_error:
-	ib_dma_unmap_single(rdma->cm_id->device, c->busa,
-			    c->req->tc.size, DMA_TO_DEVICE);
- send_error:
-	req->status = REQ_STATUS_ERROR;
-	kfree(c);
-	p9_debug(P9_DEBUG_ERROR, "Error %d in rdma_request()\n", err);
-
-	/* Ach.
-	 *  We did recv_post(), but not send. We have one recv_post in excess.
-	 */
-	atomic_inc(&rdma->excess_rc);
 	return err;
 
  /* Handle errors that happened during or while preparing post_recv(): */
-- 
2.31.1

