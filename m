Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5731B631A69
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 08:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiKUHjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 02:39:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiKUHji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 02:39:38 -0500
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B1D2936F;
        Sun, 20 Nov 2022 23:39:37 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4NFzmg3Sktz4f3mSm;
        Mon, 21 Nov 2022 15:39:31 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
        by APP4 (Coremail) with SMTP id gCh0CgC329g0K3tj2M2XAw--.53628S5;
        Mon, 21 Nov 2022 15:39:34 +0800 (CST)
From:   Ye Bin <yebin@huaweicloud.com>
To:     ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org,
        linux_oss@crudebyte.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, yebin10@huawei.com
Subject: [PATCH 1/5] 9p: fix miss unmap request in 'rdma_request()'
Date:   Mon, 21 Nov 2022 16:00:45 +0800
Message-Id: <20221121080049.3850133-2-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221121080049.3850133-1-yebin@huaweicloud.com>
References: <20221121080049.3850133-1-yebin@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgC329g0K3tj2M2XAw--.53628S5
X-Coremail-Antispam: 1UD129KBjvJXoWruw1xtw4DXF1DKr1UAw45trb_yoW8Jr4kpa
        y8uanIkrZxKr15Ar4xJFZIga4jyF4fCFWUCFW8K3ZxJF4qvryYyF4vk3yYqFyxCFWxAF4r
        Gryqgas5urWUZFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUB0b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
        A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
        w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
        W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
        6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
        Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
        Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij64
        vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
        jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
        x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
        8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
        0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU2mL9UUUUU
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

If send request failed or fail to get semaphore will not call 'send_done()',
request may miss to unmap. So add unmap handle above error.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 net/9p/trans_rdma.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 6ff706760676..e498208ed72b 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -500,7 +500,7 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 
 	if (down_interruptible(&rdma->sq_sem)) {
 		err = -EINTR;
-		goto send_error;
+		goto mapping_error;
 	}
 
 	/* Mark request as `sent' *before* we actually send it,
@@ -510,12 +510,15 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 	req->status = REQ_STATUS_SENT;
 	err = ib_post_send(rdma->qp, &wr, NULL);
 	if (err)
-		goto send_error;
+		goto mapping_error;
 
 	/* Success */
 	return 0;
 
  /* Handle errors that happened during or while preparing the send: */
+ mapping_error:
+	ib_dma_unmap_single(rdma->cm_id->device, c->busa,
+			    c->req->tc.size, DMA_TO_DEVICE);
  send_error:
 	req->status = REQ_STATUS_ERROR;
 	kfree(c);
-- 
2.31.1

