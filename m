Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023B065193C
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 04:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbiLTDEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 22:04:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiLTDEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 22:04:14 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AD613D1E
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 19:04:13 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NbhGG3WNGzRq32;
        Tue, 20 Dec 2022 11:03:02 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 20 Dec
 2022 11:04:11 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <v9fs-developer@lists.sourceforge.net>, <netdev@vger.kernel.org>,
        <ericvh@gmail.com>, <lucho@ionkov.net>, <asmadeus@codewreck.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <linux_oss@crudebyte.com>, <tom@opengridcomputing.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH] 9p/rdma: unmap receive dma buffer in rdma_request()
Date:   Tue, 20 Dec 2022 11:12:23 +0800
Message-ID: <20221220031223.3890143-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When down_interruptible() failed in rdma_request(), receive dma buffer
is not unmapped. Add unmap action to error path.

Fixes: fc79d4b104f0 ("9p: rdma: RDMA Transport Support for 9P")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/9p/trans_rdma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 83f9100d46bf..da83023fecbf 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -499,6 +499,8 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 
 	if (down_interruptible(&rdma->sq_sem)) {
 		err = -EINTR;
+		ib_dma_unmap_single(rdma->cm_id->device, c->busa,
+				    c->req->tc.size, DMA_TO_DEVICE);
 		goto send_error;
 	}
 
-- 
2.34.1

