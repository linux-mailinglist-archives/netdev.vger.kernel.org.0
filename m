Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8561438E
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 04:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfEFCu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 22:50:27 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58430 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726479AbfEFCuZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 22:50:25 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A85A266489F02E471172;
        Mon,  6 May 2019 10:50:23 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Mon, 6 May 2019 10:50:13 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <nhorman@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 12/12] net: hns3: use devm_kcalloc when allocating desc_cb
Date:   Mon, 6 May 2019 10:48:52 +0800
Message-ID: <1557110932-683-13-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557110932-683-1-git-send-email-tanhuazhong@huawei.com>
References: <1557110932-683-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

This patch uses devm_kcalloc instead of kcalloc when allocating
ring->desc_cb, because devm_kcalloc not only ensure to free the
memory when the dev is deallocted, but also allocate the memory
from it's device memory node.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 65fb421..18711e0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3478,8 +3478,8 @@ static int hns3_alloc_ring_memory(struct hns3_enet_ring *ring)
 	if (ring->desc_num <= 0 || ring->buf_size <= 0)
 		return -EINVAL;
 
-	ring->desc_cb = kcalloc(ring->desc_num, sizeof(ring->desc_cb[0]),
-				GFP_KERNEL);
+	ring->desc_cb = devm_kcalloc(ring_to_dev(ring), ring->desc_num,
+				     sizeof(ring->desc_cb[0]), GFP_KERNEL);
 	if (!ring->desc_cb) {
 		ret = -ENOMEM;
 		goto out;
@@ -3500,7 +3500,7 @@ static int hns3_alloc_ring_memory(struct hns3_enet_ring *ring)
 out_with_desc:
 	hns3_free_desc(ring);
 out_with_desc_cb:
-	kfree(ring->desc_cb);
+	devm_kfree(ring_to_dev(ring), ring->desc_cb);
 	ring->desc_cb = NULL;
 out:
 	return ret;
@@ -3509,7 +3509,7 @@ static int hns3_alloc_ring_memory(struct hns3_enet_ring *ring)
 static void hns3_fini_ring(struct hns3_enet_ring *ring)
 {
 	hns3_free_desc(ring);
-	kfree(ring->desc_cb);
+	devm_kfree(ring_to_dev(ring), ring->desc_cb);
 	ring->desc_cb = NULL;
 	ring->next_to_clean = 0;
 	ring->next_to_use = 0;
-- 
2.7.4

