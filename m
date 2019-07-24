Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 189037254E
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 05:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfGXDU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 23:20:58 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:50688 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725827AbfGXDU6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 23:20:58 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 84E6B647C03281143F2B;
        Wed, 24 Jul 2019 11:20:52 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Wed, 24 Jul 2019 11:20:45 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 10/11] net: hns3: Add support for using order 1 pages with a 4K buffer
Date:   Wed, 24 Jul 2019 11:18:46 +0800
Message-ID: <1563938327-9865-11-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
References: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

Hardware supports 0.5K, 1K, 2K, 4K RX buffer size, the
RX buffer can not be reused because the hns3_page_order
return 0 when page size and RX buffer size are both 4096.

So this patch changes the hns3_page_order to return 1 when
RX buffer is greater than half of the page size and page size
is less the 8192, and dev_alloc_pages has already been used
to allocate the compound page for RX buffer.

This patch also changes hnae3_* to hns3_* for page order
and RX buffer size calculation because they are used in
hns3 module.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Reviewed-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 10 +++++-----
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h | 15 ++++++++++++---
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index cff5d59..56af4be 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2086,7 +2086,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
 			     struct hns3_desc_cb *cb)
 {
-	unsigned int order = hnae3_page_order(ring);
+	unsigned int order = hns3_page_order(ring);
 	struct page *p;
 
 	p = dev_alloc_pages(order);
@@ -2097,7 +2097,7 @@ static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
 	cb->page_offset = 0;
 	cb->reuse_flag = 0;
 	cb->buf  = page_address(p);
-	cb->length = hnae3_page_size(ring);
+	cb->length = hns3_page_size(ring);
 	cb->type = DESC_TYPE_PAGE;
 
 	return 0;
@@ -2400,7 +2400,7 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 {
 	struct hns3_desc *desc = &ring->desc[ring->next_to_clean];
 	int size = le16_to_cpu(desc->rx.size);
-	u32 truesize = hnae3_buf_size(ring);
+	u32 truesize = hns3_buf_size(ring);
 
 	skb_add_rx_frag(skb, i, desc_cb->priv, desc_cb->page_offset + pull_len,
 			size - pull_len, truesize);
@@ -2415,7 +2415,7 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 	/* Move offset up to the next cache line */
 	desc_cb->page_offset += truesize;
 
-	if (desc_cb->page_offset + truesize <= hnae3_page_size(ring)) {
+	if (desc_cb->page_offset + truesize <= hns3_page_size(ring)) {
 		desc_cb->reuse_flag = 1;
 		/* Bump ref count on page before it is given */
 		get_page(desc_cb->priv);
@@ -2697,7 +2697,7 @@ static int hns3_add_frag(struct hns3_enet_ring *ring, struct hns3_desc *desc,
 		}
 
 		if (ring->tail_skb) {
-			head_skb->truesize += hnae3_buf_size(ring);
+			head_skb->truesize += hns3_buf_size(ring);
 			head_skb->data_len += le16_to_cpu(desc->rx.size);
 			head_skb->len += le16_to_cpu(desc->rx.size);
 			skb = ring->tail_skb;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 848b866..1a17856 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -608,9 +608,18 @@ static inline bool hns3_nic_resetting(struct net_device *netdev)
 
 #define tx_ring_data(priv, idx) ((priv)->ring_data[idx])
 
-#define hnae3_buf_size(_ring) ((_ring)->buf_size)
-#define hnae3_page_order(_ring) (get_order(hnae3_buf_size(_ring)))
-#define hnae3_page_size(_ring) (PAGE_SIZE << (u32)hnae3_page_order(_ring))
+#define hns3_buf_size(_ring) ((_ring)->buf_size)
+
+static inline unsigned int hns3_page_order(struct hns3_enet_ring *ring)
+{
+#if (PAGE_SIZE < 8192)
+	if (ring->buf_size > (PAGE_SIZE / 2))
+		return 1;
+#endif
+	return 0;
+}
+
+#define hns3_page_size(_ring) (PAGE_SIZE << hns3_page_order(_ring))
 
 /* iterator for handling rings in ring group */
 #define hns3_for_each_ring(pos, head) \
-- 
2.7.4

