Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF25B631A6A
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 08:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiKUHjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 02:39:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiKUHji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 02:39:38 -0500
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F156D2D1E4;
        Sun, 20 Nov 2022 23:39:37 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4NFzmh2tT2z4f3tqC;
        Mon, 21 Nov 2022 15:39:32 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
        by APP4 (Coremail) with SMTP id gCh0CgC329g0K3tj2M2XAw--.53628S7;
        Mon, 21 Nov 2022 15:39:35 +0800 (CST)
From:   Ye Bin <yebin@huaweicloud.com>
To:     ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org,
        linux_oss@crudebyte.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, yebin10@huawei.com
Subject: [PATCH 3/5] 9p: fix error handle in 'post_recv()'
Date:   Mon, 21 Nov 2022 16:00:47 +0800
Message-Id: <20221121080049.3850133-4-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221121080049.3850133-1-yebin@huaweicloud.com>
References: <20221121080049.3850133-1-yebin@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgC329g0K3tj2M2XAw--.53628S7
X-Coremail-Antispam: 1UD129KBjvJXoW7ur13XF1kWw47ZF45XF1fJFb_yoW8Gw18pF
        Z3uwsxZr9Igr17Aw4kKayDuFySkrsYkF4fG34jkanxJ3WDtr98KF4Ut3yYqFyxGF4xJF4f
        Gr1DtayruF1UZrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUBYb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
        A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
        w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
        W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
        6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
        Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
        Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij64
        vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
        jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
        x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
        8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
        0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IU1c4S7UUUUU==
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

There are two issues in 'post_recv()':
1. Miss unmap request if receive request failed;
2. Miss release 'rdma->rq_sem' if post receive failed or mapping failed;

So add miss release 'rdma->rq_sem' and unmap request when do error handle.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 net/9p/trans_rdma.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index ae2bac9bf510..bcab550c2e2c 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -386,6 +386,7 @@ post_recv(struct p9_client *client, struct p9_rdma_context *c)
 	struct p9_trans_rdma *rdma = client->trans;
 	struct ib_recv_wr wr;
 	struct ib_sge sge;
+	int err = -EIO;
 
 	c->busa = ib_dma_map_single(rdma->cm_id->device,
 				    c->rc.sdata, client->msize,
@@ -403,11 +404,17 @@ post_recv(struct p9_client *client, struct p9_rdma_context *c)
 	wr.wr_cqe = &c->cqe;
 	wr.sg_list = &sge;
 	wr.num_sge = 1;
-	return ib_post_recv(rdma->qp, &wr, NULL);
-
+	err = ib_post_recv(rdma->qp, &wr, NULL);
+	if (err) {
+		ib_dma_unmap_single(rdma->cm_id->device, c->busa,
+				    client->msize, DMA_FROM_DEVICE);
+		goto error;
+	}
+	return 0;
  error:
+	up(&rdma->rq_sem);
 	p9_debug(P9_DEBUG_ERROR, "EIO\n");
-	return -EIO;
+	return err;
 }
 
 static int rdma_request(struct p9_client *client, struct p9_req_t *req)
-- 
2.31.1

