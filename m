Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D342693A2
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgINRiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:38:15 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:42922 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726110AbgINM1F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 08:27:05 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DAFADEBE15ECF5961EB8;
        Mon, 14 Sep 2020 20:09:28 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Mon, 14 Sep 2020 20:09:22 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/6] net: hns3: batch the page reference count updates
Date:   Mon, 14 Sep 2020 20:06:52 +0800
Message-ID: <1600085217-26245-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600085217-26245-1-git-send-email-tanhuazhong@huawei.com>
References: <1600085217-26245-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

Batch the page reference count updates instead of doing them
one at a time. By doing this we can improve the overall receive
performance by avoid some atomic increment operations when the
rx page is reused.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 32 ++++++++++++++++++-------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h |  1 +
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 93825a4..3762142 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2302,6 +2302,8 @@ static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
 	cb->buf  = page_address(p);
 	cb->length = hns3_page_size(ring);
 	cb->type = DESC_TYPE_PAGE;
+	page_ref_add(p, USHRT_MAX - 1);
+	cb->pagecnt_bias = USHRT_MAX;
 
 	return 0;
 }
@@ -2311,8 +2313,8 @@ static void hns3_free_buffer(struct hns3_enet_ring *ring,
 {
 	if (cb->type == DESC_TYPE_SKB)
 		dev_kfree_skb_any((struct sk_buff *)cb->priv);
-	else if (!HNAE3_IS_TX_RING(ring))
-		put_page((struct page *)cb->priv);
+	else if (!HNAE3_IS_TX_RING(ring) && cb->pagecnt_bias)
+		__page_frag_cache_drain(cb->priv, cb->pagecnt_bias);
 	memset(cb, 0, sizeof(*cb));
 }
 
@@ -2610,6 +2612,11 @@ static bool hns3_page_is_reusable(struct page *page)
 		!page_is_pfmemalloc(page);
 }
 
+static bool hns3_can_reuse_page(struct hns3_desc_cb *cb)
+{
+	return (page_count(cb->priv) - cb->pagecnt_bias) == 1;
+}
+
 static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 				struct hns3_enet_ring *ring, int pull_len,
 				struct hns3_desc_cb *desc_cb)
@@ -2618,6 +2625,7 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 	int size = le16_to_cpu(desc->rx.size);
 	u32 truesize = hns3_buf_size(ring);
 
+	desc_cb->pagecnt_bias--;
 	skb_add_rx_frag(skb, i, desc_cb->priv, desc_cb->page_offset + pull_len,
 			size - pull_len, truesize);
 
@@ -2625,20 +2633,27 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 	 * when page_offset rollback to zero, flag default unreuse
 	 */
 	if (unlikely(!hns3_page_is_reusable(desc_cb->priv)) ||
-	    (!desc_cb->page_offset && page_count(desc_cb->priv) > 1))
+	    (!desc_cb->page_offset && !hns3_can_reuse_page(desc_cb))) {
+		__page_frag_cache_drain(desc_cb->priv, desc_cb->pagecnt_bias);
 		return;
+	}
 
 	/* Move offset up to the next cache line */
 	desc_cb->page_offset += truesize;
 
 	if (desc_cb->page_offset + truesize <= hns3_page_size(ring)) {
 		desc_cb->reuse_flag = 1;
-		/* Bump ref count on page before it is given */
-		get_page(desc_cb->priv);
-	} else if (page_count(desc_cb->priv) == 1) {
+	} else if (hns3_can_reuse_page(desc_cb)) {
 		desc_cb->reuse_flag = 1;
 		desc_cb->page_offset = 0;
-		get_page(desc_cb->priv);
+	} else if (desc_cb->pagecnt_bias) {
+		__page_frag_cache_drain(desc_cb->priv, desc_cb->pagecnt_bias);
+		return;
+	}
+
+	if (unlikely(!desc_cb->pagecnt_bias)) {
+		page_ref_add(desc_cb->priv, USHRT_MAX);
+		desc_cb->pagecnt_bias = USHRT_MAX;
 	}
 }
 
@@ -2846,7 +2861,8 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
 		if (likely(hns3_page_is_reusable(desc_cb->priv)))
 			desc_cb->reuse_flag = 1;
 		else /* This page cannot be reused so discard it */
-			put_page(desc_cb->priv);
+			__page_frag_cache_drain(desc_cb->priv,
+						desc_cb->pagecnt_bias);
 
 		ring_ptr_move_fw(ring, next_to_clean);
 		return 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 98ca6ea..8f784094 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -287,6 +287,7 @@ struct hns3_desc_cb {
 
 	/* desc type, used by the ring user to mark the type of the priv data */
 	u16 type;
+	u16 pagecnt_bias;
 };
 
 enum hns3_pkt_l3type {
-- 
2.7.4

