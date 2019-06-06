Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 092B536E7B
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 10:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbfFFIX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 04:23:28 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41890 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727242AbfFFIWr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 04:22:47 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A347D25D15E1FCF24AAF;
        Thu,  6 Jun 2019 16:22:43 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Thu, 6 Jun 2019 16:22:35 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 04/12] net: hns3: replace numa_node_id with numa_mem_id for buffer reusing
Date:   Thu, 6 Jun 2019 16:20:59 +0800
Message-ID: <1559809267-53805-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559809267-53805-1-git-send-email-tanhuazhong@huawei.com>
References: <1559809267-53805-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

This patch replaces numa_node_id with numa_mem_id when doing buffer
reusing checking, because the buffer still can be reused when the
buffer is from the nearest node and the local node has no memory
attached.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index c37509e..969d4c1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2367,7 +2367,7 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 	/* Avoid re-using remote pages, or the stack is still using the page
 	 * when page_offset rollback to zero, flag default unreuse
 	 */
-	if (unlikely(page_to_nid(desc_cb->priv) != numa_node_id()) ||
+	if (unlikely(page_to_nid(desc_cb->priv) != numa_mem_id()) ||
 	    (!desc_cb->page_offset && page_count(desc_cb->priv) > 1))
 		return;
 
@@ -2583,7 +2583,7 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, int length,
 		memcpy(__skb_put(skb, length), va, ALIGN(length, sizeof(long)));
 
 		/* We can reuse buffer as-is, just make sure it is local */
-		if (likely(page_to_nid(desc_cb->priv) == numa_node_id()))
+		if (likely(page_to_nid(desc_cb->priv) == numa_mem_id()))
 			desc_cb->reuse_flag = 1;
 		else /* This page cannot be reused so discard it */
 			put_page(desc_cb->priv);
-- 
2.7.4

