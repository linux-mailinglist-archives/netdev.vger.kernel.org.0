Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB44C38D45F
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 10:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhEVIKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 04:10:39 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5725 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbhEVIKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 04:10:39 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FnGHl6zvXzqVBN;
        Sat, 22 May 2021 16:05:39 +0800 (CST)
Received: from nkgeml708-chm.china.huawei.com (10.98.57.160) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 22 May 2021 16:09:07 +0800
Received: from huawei.com (10.179.179.12) by nkgeml708-chm.china.huawei.com
 (10.98.57.160) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Sat, 22 May
 2021 16:09:06 +0800
From:   guodeqing <geffrey.guo@huawei.com>
To:     <mst@redhat.com>
CC:     <jasowang@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <mgurtovoy@nvidia.com>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <geffrey.guo@huawei.com>
Subject: [PATCH] virtio-net: fix the kzalloc/kfree mismatch problem
Date:   Sat, 22 May 2021 16:02:31 +0800
Message-ID: <20210522080231.54760-1-geffrey.guo@huawei.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.179.179.12]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 nkgeml708-chm.china.huawei.com (10.98.57.160)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the virtio_net device does not suppurt the ctrl queue feature,
the vi->ctrl was not allocated, so there is no need to free it.

Here I adjust the initialization sequence and the check of vi->has_cvq
to slove this problem.

Fixes: 	122b84a1267a ("virtio-net: don't allocate control_buf if not supported")
Signed-off-by: guodeqing <geffrey.guo@huawei.com>
---
 drivers/net/virtio_net.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 9b6a4a875c55..894f894d3a29 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2691,7 +2691,8 @@ static void virtnet_free_queues(struct virtnet_info *vi)
 
 	kfree(vi->rq);
 	kfree(vi->sq);
-	kfree(vi->ctrl);
+	if (vi->has_cvq)
+		kfree(vi->ctrl);
 }
 
 static void _free_receive_bufs(struct virtnet_info *vi)
@@ -2870,13 +2871,6 @@ static int virtnet_alloc_queues(struct virtnet_info *vi)
 {
 	int i;
 
-	if (vi->has_cvq) {
-		vi->ctrl = kzalloc(sizeof(*vi->ctrl), GFP_KERNEL);
-		if (!vi->ctrl)
-			goto err_ctrl;
-	} else {
-		vi->ctrl = NULL;
-	}
 	vi->sq = kcalloc(vi->max_queue_pairs, sizeof(*vi->sq), GFP_KERNEL);
 	if (!vi->sq)
 		goto err_sq;
@@ -2884,6 +2878,12 @@ static int virtnet_alloc_queues(struct virtnet_info *vi)
 	if (!vi->rq)
 		goto err_rq;
 
+	if (vi->has_cvq) {
+		vi->ctrl = kzalloc(sizeof(*vi->ctrl), GFP_KERNEL);
+		if (!vi->ctrl)
+			goto err_ctrl;
+	}
+
 	INIT_DELAYED_WORK(&vi->refill, refill_work);
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		vi->rq[i].pages = NULL;
@@ -2902,11 +2902,11 @@ static int virtnet_alloc_queues(struct virtnet_info *vi)
 
 	return 0;
 
+err_ctrl:
+	kfree(vi->rq);
 err_rq:
 	kfree(vi->sq);
 err_sq:
-	kfree(vi->ctrl);
-err_ctrl:
 	return -ENOMEM;
 }
 
-- 
2.28.0

