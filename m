Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64331143896
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 09:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgAUImb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 03:42:31 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10111 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725789AbgAUImb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 03:42:31 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BC7011909D144116436D;
        Tue, 21 Jan 2020 16:42:29 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Tue, 21 Jan 2020 16:42:21 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/9] net: hns3: do not reuse pfmemalloc pages
Date:   Tue, 21 Jan 2020 16:42:06 +0800
Message-ID: <1579596133-54842-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579596133-54842-1-git-send-email-tanhuazhong@huawei.com>
References: <1579596133-54842-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

HNS3 driver allocates pages for DMA with dev_alloc_pages(), which
calls alloc_pages_node() with the __GFP_MEMALLOC flag. So, in case
of OOM condition, HNS3 can get pages with pfmemalloc flag set.

So do not reuse the pages with pfmemalloc flag set because those
pages are reserved for special cases, such as low memory case.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index f579028..06c58ed 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2627,6 +2627,12 @@ static void hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
 	writel_relaxed(i, ring->tqp->io_base + HNS3_RING_RX_RING_HEAD_REG);
 }
 
+static bool hns3_page_is_reusable(struct page *page)
+{
+	return page_to_nid(page) == numa_mem_id() &&
+		!page_is_pfmemalloc(page);
+}
+
 static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 				struct hns3_enet_ring *ring, int pull_len,
 				struct hns3_desc_cb *desc_cb)
@@ -2641,7 +2647,7 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 	/* Avoid re-using remote pages, or the stack is still using the page
 	 * when page_offset rollback to zero, flag default unreuse
 	 */
-	if (unlikely(page_to_nid(desc_cb->priv) != numa_mem_id()) ||
+	if (unlikely(!hns3_page_is_reusable(desc_cb->priv)) ||
 	    (!desc_cb->page_offset && page_count(desc_cb->priv) > 1))
 		return;
 
@@ -2860,7 +2866,7 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
 		memcpy(__skb_put(skb, length), va, ALIGN(length, sizeof(long)));
 
 		/* We can reuse buffer as-is, just make sure it is local */
-		if (likely(page_to_nid(desc_cb->priv) == numa_mem_id()))
+		if (likely(hns3_page_is_reusable(desc_cb->priv)))
 			desc_cb->reuse_flag = 1;
 		else /* This page cannot be reused so discard it */
 			put_page(desc_cb->priv);
-- 
2.7.4

