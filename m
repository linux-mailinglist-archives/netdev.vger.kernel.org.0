Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF8D3A92D4
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 08:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhFPGlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 02:41:44 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4798 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbhFPGlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 02:41:37 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4b5145hBzWsv9;
        Wed, 16 Jun 2021 14:34:29 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:39:30 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:39:30 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 6/7] net: hns3: optimize the rx page reuse handling process
Date:   Wed, 16 Jun 2021 14:36:16 +0800
Message-ID: <1623825377-41948-7-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623825377-41948-1-git-send-email-huangguangbin2@huawei.com>
References: <1623825377-41948-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

Current rx page offset only reset to zero when all the below
conditions are satisfied:
1. rx page is only owned by driver.
2. rx page is reusable.
3. the page offset that is above to be given to the stack has
reached the end of the page.

If the page offset is over the hns3_buf_size(), it means the
buffer below the offset of the page is usable when the above
condition 1 & 2 are satisfied, so page offset can be reset to
zero instead of increasing the offset. We may be able to always
reuse the first 4K buffer of a 64K page, which means we can
limit the hot buffer size as much as possible.

The above optimization is a side effect when refacting the
rx page reuse handling in order to support the rx copybreak.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 44 ++++++++++++-------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index f60a344a6a9f..98e8a548edb8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3525,7 +3525,7 @@ static void hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
 
 static bool hns3_can_reuse_page(struct hns3_desc_cb *cb)
 {
-	return (page_count(cb->priv) - cb->pagecnt_bias) == 1;
+	return page_count(cb->priv) == cb->pagecnt_bias;
 }
 
 static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
@@ -3533,40 +3533,40 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 				struct hns3_desc_cb *desc_cb)
 {
 	struct hns3_desc *desc = &ring->desc[ring->next_to_clean];
+	u32 frag_offset = desc_cb->page_offset + pull_len;
 	int size = le16_to_cpu(desc->rx.size);
 	u32 truesize = hns3_buf_size(ring);
+	u32 frag_size = size - pull_len;
 
-	desc_cb->pagecnt_bias--;
-	skb_add_rx_frag(skb, i, desc_cb->priv, desc_cb->page_offset + pull_len,
-			size - pull_len, truesize);
+	/* Avoid re-using remote or pfmem page */
+	if (unlikely(!dev_page_is_reusable(desc_cb->priv)))
+		goto out;
 
-	/* Avoid re-using remote and pfmemalloc pages, or the stack is still
-	 * using the page when page_offset rollback to zero, flag default
-	 * unreuse
+	/* Stack is not using and current page_offset is non-zero, we can
+	 * reuse from the zero offset.
 	 */
-	if (!dev_page_is_reusable(desc_cb->priv) ||
-	    (!desc_cb->page_offset && !hns3_can_reuse_page(desc_cb))) {
-		__page_frag_cache_drain(desc_cb->priv, desc_cb->pagecnt_bias);
-		return;
-	}
-
-	/* Move offset up to the next cache line */
-	desc_cb->page_offset += truesize;
-
-	if (desc_cb->page_offset + truesize <= hns3_page_size(ring)) {
+	if (desc_cb->page_offset && hns3_can_reuse_page(desc_cb)) {
+		desc_cb->page_offset = 0;
 		desc_cb->reuse_flag = 1;
-	} else if (hns3_can_reuse_page(desc_cb)) {
+	} else if (desc_cb->page_offset + truesize * 2 <=
+		   hns3_page_size(ring)) {
+		desc_cb->page_offset += truesize;
 		desc_cb->reuse_flag = 1;
-		desc_cb->page_offset = 0;
-	} else if (desc_cb->pagecnt_bias) {
-		__page_frag_cache_drain(desc_cb->priv, desc_cb->pagecnt_bias);
-		return;
 	}
 
+out:
+	desc_cb->pagecnt_bias--;
+
 	if (unlikely(!desc_cb->pagecnt_bias)) {
 		page_ref_add(desc_cb->priv, USHRT_MAX);
 		desc_cb->pagecnt_bias = USHRT_MAX;
 	}
+
+	skb_add_rx_frag(skb, i, desc_cb->priv, frag_offset,
+			frag_size, truesize);
+
+	if (unlikely(!desc_cb->reuse_flag))
+		__page_frag_cache_drain(desc_cb->priv, desc_cb->pagecnt_bias);
 }
 
 static int hns3_gro_complete(struct sk_buff *skb, u32 l234info)
-- 
2.8.1

