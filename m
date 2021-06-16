Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55C63A92D3
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 08:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhFPGln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 02:41:43 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7453 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbhFPGlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 02:41:37 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G4b7Q3kNWzZhbw;
        Wed, 16 Jun 2021 14:36:34 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:39:29 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:39:29 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/7] net: hns3: minor refactor related to desc_cb handling
Date:   Wed, 16 Jun 2021 14:36:11 +0800
Message-ID: <1623825377-41948-2-git-send-email-huangguangbin2@huawei.com>
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

desc_cb is used to store mapping and freeing info for the
corresponding desc, which is used in the cleaning process.
There will be more desc_cb type coming up when supporting the
tx bounce buffer, change desc_cb type to bit-wise value in order
to reduce the desc_cb type checking operation in the data path.

Also move the desc_cb type definition to hns3_enet.h because it
is only used in hns3_enet.c, and declare a local variable desc_cb
in hns3_clear_desc() to reduce lines of code.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h     |  7 -----
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 40 +++++++++++--------------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h |  7 +++++
 3 files changed, 25 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index ba883b0a19f0..5822fc06f767 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -159,13 +159,6 @@ enum HNAE3_PF_CAP_BITS {
 #define ring_ptr_move_bw(ring, p) \
 	((ring)->p = ((ring)->p - 1 + (ring)->desc_num) % (ring)->desc_num)
 
-enum hns_desc_type {
-	DESC_TYPE_UNKNOWN,
-	DESC_TYPE_SKB,
-	DESC_TYPE_FRAGLIST_SKB,
-	DESC_TYPE_PAGE,
-};
-
 struct hnae3_handle;
 
 struct hnae3_queue {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 9a45f3cde6a2..f03a7a962eb0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1413,7 +1413,7 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 }
 
 static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
-			  unsigned int size, enum hns_desc_type type)
+			  unsigned int size, unsigned int type)
 {
 #define HNS3_LIKELY_BD_NUM	1
 
@@ -1425,8 +1425,7 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 	int k, sizeoflast;
 	dma_addr_t dma;
 
-	if (type == DESC_TYPE_FRAGLIST_SKB ||
-	    type == DESC_TYPE_SKB) {
+	if (type & (DESC_TYPE_FRAGLIST_SKB | DESC_TYPE_SKB)) {
 		struct sk_buff *skb = (struct sk_buff *)priv;
 
 		dma = dma_map_single(dev, skb->data, size, DMA_TO_DEVICE);
@@ -1704,6 +1703,7 @@ static void hns3_clear_desc(struct hns3_enet_ring *ring, int next_to_use_orig)
 
 	for (i = 0; i < ring->desc_num; i++) {
 		struct hns3_desc *desc = &ring->desc[ring->next_to_use];
+		struct hns3_desc_cb *desc_cb;
 
 		memset(desc, 0, sizeof(*desc));
 
@@ -1714,31 +1714,27 @@ static void hns3_clear_desc(struct hns3_enet_ring *ring, int next_to_use_orig)
 		/* rollback one */
 		ring_ptr_move_bw(ring, next_to_use);
 
-		if (!ring->desc_cb[ring->next_to_use].dma)
+		desc_cb = &ring->desc_cb[ring->next_to_use];
+
+		if (!desc_cb->dma)
 			continue;
 
 		/* unmap the descriptor dma address */
-		if (ring->desc_cb[ring->next_to_use].type == DESC_TYPE_SKB ||
-		    ring->desc_cb[ring->next_to_use].type ==
-		    DESC_TYPE_FRAGLIST_SKB)
-			dma_unmap_single(dev,
-					 ring->desc_cb[ring->next_to_use].dma,
-					ring->desc_cb[ring->next_to_use].length,
-					DMA_TO_DEVICE);
-		else if (ring->desc_cb[ring->next_to_use].length)
-			dma_unmap_page(dev,
-				       ring->desc_cb[ring->next_to_use].dma,
-				       ring->desc_cb[ring->next_to_use].length,
+		if (desc_cb->type & (DESC_TYPE_SKB | DESC_TYPE_FRAGLIST_SKB))
+			dma_unmap_single(dev, desc_cb->dma, desc_cb->length,
+					 DMA_TO_DEVICE);
+		else if (desc_cb->length)
+			dma_unmap_page(dev, desc_cb->dma, desc_cb->length,
 				       DMA_TO_DEVICE);
 
-		ring->desc_cb[ring->next_to_use].length = 0;
-		ring->desc_cb[ring->next_to_use].dma = 0;
-		ring->desc_cb[ring->next_to_use].type = DESC_TYPE_UNKNOWN;
+		desc_cb->length = 0;
+		desc_cb->dma = 0;
+		desc_cb->type = DESC_TYPE_UNKNOWN;
 	}
 }
 
 static int hns3_fill_skb_to_desc(struct hns3_enet_ring *ring,
-				 struct sk_buff *skb, enum hns_desc_type type)
+				 struct sk_buff *skb, unsigned int type)
 {
 	unsigned int size = skb_headlen(skb);
 	struct sk_buff *frag_skb;
@@ -2859,7 +2855,7 @@ static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
 static void hns3_free_buffer(struct hns3_enet_ring *ring,
 			     struct hns3_desc_cb *cb, int budget)
 {
-	if (cb->type == DESC_TYPE_SKB)
+	if (cb->type & DESC_TYPE_SKB)
 		napi_consume_skb(cb->priv, budget);
 	else if (!HNAE3_IS_TX_RING(ring) && cb->pagecnt_bias)
 		__page_frag_cache_drain(cb->priv, cb->pagecnt_bias);
@@ -2880,7 +2876,7 @@ static int hns3_map_buffer(struct hns3_enet_ring *ring, struct hns3_desc_cb *cb)
 static void hns3_unmap_buffer(struct hns3_enet_ring *ring,
 			      struct hns3_desc_cb *cb)
 {
-	if (cb->type == DESC_TYPE_SKB || cb->type == DESC_TYPE_FRAGLIST_SKB)
+	if (cb->type & (DESC_TYPE_SKB | DESC_TYPE_FRAGLIST_SKB))
 		dma_unmap_single(ring_to_dev(ring), cb->dma, cb->length,
 				 ring_to_dma_dir(ring));
 	else if (cb->length)
@@ -3037,7 +3033,7 @@ static bool hns3_nic_reclaim_desc(struct hns3_enet_ring *ring,
 
 		desc_cb = &ring->desc_cb[ntc];
 
-		if (desc_cb->type == DESC_TYPE_SKB) {
+		if (desc_cb->type & DESC_TYPE_SKB) {
 			(*pkts)++;
 			(*bytes) += desc_cb->send_bytes;
 		}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 79821c7bdc16..9d18b9430b54 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -299,6 +299,13 @@ struct __packed hns3_desc {
 	};
 };
 
+enum hns3_desc_type {
+	DESC_TYPE_UNKNOWN		= 0,
+	DESC_TYPE_SKB			= 1 << 0,
+	DESC_TYPE_FRAGLIST_SKB		= 1 << 1,
+	DESC_TYPE_PAGE			= 1 << 2,
+};
+
 struct hns3_desc_cb {
 	dma_addr_t dma; /* dma address of this desc */
 	void *buf;      /* cpu addr for a desc */
-- 
2.8.1

