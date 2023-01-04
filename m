Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438C465CBA8
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 02:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbjADBzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 20:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbjADBzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 20:55:00 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4671B164AC
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 17:54:59 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Nmsy962l2zJpnd;
        Wed,  4 Jan 2023 09:50:57 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 4 Jan
 2023 09:54:56 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <v9fs-developer@lists.sourceforge.net>, <netdev@vger.kernel.org>,
        <ericvh@gmail.com>, <lucho@ionkov.net>, <asmadeus@codewreck.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <linux_oss@crudebyte.com>, <tom@opengridcomputing.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH v2] 9p/rdma: unmap receive dma buffer in rdma_request()/post_recv()
Date:   Wed, 4 Jan 2023 10:04:24 +0800
Message-ID: <20230104020424.611926-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When down_interruptible() or ib_post_send() failed in rdma_request(),
receive dma buffer is not unmapped. Add unmap action to error path.
Also if ib_post_recv() failed in post_recv(), dma buffer is not unmapped.
Add unmap action to error path.

Fixes: fc79d4b104f0 ("9p: rdma: RDMA Transport Support for 9P")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
v2: add unmap action if ib_post_send() or ib_post_recv() failed
---
 net/9p/trans_rdma.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 83f9100d46bf..b84748baf9cb 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -385,6 +385,7 @@ post_recv(struct p9_client *client, struct p9_rdma_context *c)
 	struct p9_trans_rdma *rdma = client->trans;
 	struct ib_recv_wr wr;
 	struct ib_sge sge;
+	int ret;
 
 	c->busa = ib_dma_map_single(rdma->cm_id->device,
 				    c->rc.sdata, client->msize,
@@ -402,7 +403,12 @@ post_recv(struct p9_client *client, struct p9_rdma_context *c)
 	wr.wr_cqe = &c->cqe;
 	wr.sg_list = &sge;
 	wr.num_sge = 1;
-	return ib_post_recv(rdma->qp, &wr, NULL);
+
+	ret = ib_post_recv(rdma->qp, &wr, NULL);
+	if (ret)
+		ib_dma_unmap_single(rdma->cm_id->device, c->busa,
+				    client->msize, DMA_FROM_DEVICE);
+	return ret;
 
  error:
 	p9_debug(P9_DEBUG_ERROR, "EIO\n");
@@ -499,7 +505,7 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 
 	if (down_interruptible(&rdma->sq_sem)) {
 		err = -EINTR;
-		goto send_error;
+		goto dma_unmap;
 	}
 
 	/* Mark request as `sent' *before* we actually send it,
@@ -509,11 +515,14 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 	WRITE_ONCE(req->status, REQ_STATUS_SENT);
 	err = ib_post_send(rdma->qp, &wr, NULL);
 	if (err)
-		goto send_error;
+		goto dma_unmap;
 
 	/* Success */
 	return 0;
 
+dma_unmap:
+	ib_dma_unmap_single(rdma->cm_id->device, c->busa,
+			    c->req->tc.size, DMA_TO_DEVICE);
  /* Handle errors that happened during or while preparing the send: */
  send_error:
 	WRITE_ONCE(req->status, REQ_STATUS_ERROR);
-- 
2.34.1

