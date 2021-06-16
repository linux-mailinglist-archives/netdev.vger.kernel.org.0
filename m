Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71EF13A92CF
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 08:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhFPGlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 02:41:42 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:7292 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbhFPGlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 02:41:37 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G4b5115HWz1BMlW;
        Wed, 16 Jun 2021 14:34:29 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:39:30 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 14:39:29 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 2/7] net: hns3: refactor for hns3_fill_desc() function
Date:   Wed, 16 Jun 2021 14:36:12 +0800
Message-ID: <1623825377-41948-3-git-send-email-huangguangbin2@huawei.com>
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

Factor out hns3_fill_desc() so that it can be reused in the
tx bounce supporting.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 87 ++++++++++++++-----------
 1 file changed, 48 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index f03a7a962eb0..6fa1ed5c4098 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1412,39 +1412,14 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 	return 0;
 }
 
-static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
-			  unsigned int size, unsigned int type)
+static int hns3_fill_desc(struct hns3_enet_ring *ring, dma_addr_t dma,
+			  unsigned int size)
 {
 #define HNS3_LIKELY_BD_NUM	1
 
-	struct hns3_desc_cb *desc_cb = &ring->desc_cb[ring->next_to_use];
 	struct hns3_desc *desc = &ring->desc[ring->next_to_use];
-	struct device *dev = ring_to_dev(ring);
-	skb_frag_t *frag;
 	unsigned int frag_buf_num;
 	int k, sizeoflast;
-	dma_addr_t dma;
-
-	if (type & (DESC_TYPE_FRAGLIST_SKB | DESC_TYPE_SKB)) {
-		struct sk_buff *skb = (struct sk_buff *)priv;
-
-		dma = dma_map_single(dev, skb->data, size, DMA_TO_DEVICE);
-	} else {
-		frag = (skb_frag_t *)priv;
-		dma = skb_frag_dma_map(dev, frag, 0, size, DMA_TO_DEVICE);
-	}
-
-	if (unlikely(dma_mapping_error(dev, dma))) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.sw_err_cnt++;
-		u64_stats_update_end(&ring->syncp);
-		return -ENOMEM;
-	}
-
-	desc_cb->priv = priv;
-	desc_cb->length = size;
-	desc_cb->dma = dma;
-	desc_cb->type = type;
 
 	if (likely(size <= HNS3_MAX_BD_SIZE)) {
 		desc->addr = cpu_to_le64(dma);
@@ -1480,6 +1455,47 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 	return frag_buf_num;
 }
 
+static int hns3_map_and_fill_desc(struct hns3_enet_ring *ring, void *priv,
+				  unsigned int type)
+{
+	struct hns3_desc_cb *desc_cb = &ring->desc_cb[ring->next_to_use];
+	struct device *dev = ring_to_dev(ring);
+	unsigned int size;
+	dma_addr_t dma;
+
+	if (type & (DESC_TYPE_FRAGLIST_SKB | DESC_TYPE_SKB)) {
+		struct sk_buff *skb = (struct sk_buff *)priv;
+
+		size = skb_headlen(skb);
+		if (!size)
+			return 0;
+
+		dma = dma_map_single(dev, skb->data, size, DMA_TO_DEVICE);
+	} else {
+		skb_frag_t *frag = (skb_frag_t *)priv;
+
+		size = skb_frag_size(frag);
+		if (!size)
+			return 0;
+
+		dma = skb_frag_dma_map(dev, frag, 0, size, DMA_TO_DEVICE);
+	}
+
+	if (unlikely(dma_mapping_error(dev, dma))) {
+		u64_stats_update_begin(&ring->syncp);
+		ring->stats.sw_err_cnt++;
+		u64_stats_update_end(&ring->syncp);
+		return -ENOMEM;
+	}
+
+	desc_cb->priv = priv;
+	desc_cb->length = size;
+	desc_cb->dma = dma;
+	desc_cb->type = type;
+
+	return hns3_fill_desc(ring, dma, size);
+}
+
 static unsigned int hns3_skb_bd_num(struct sk_buff *skb, unsigned int *bd_size,
 				    unsigned int bd_num)
 {
@@ -1736,26 +1752,19 @@ static void hns3_clear_desc(struct hns3_enet_ring *ring, int next_to_use_orig)
 static int hns3_fill_skb_to_desc(struct hns3_enet_ring *ring,
 				 struct sk_buff *skb, unsigned int type)
 {
-	unsigned int size = skb_headlen(skb);
 	struct sk_buff *frag_skb;
 	int i, ret, bd_num = 0;
 
-	if (size) {
-		ret = hns3_fill_desc(ring, skb, size, type);
-		if (unlikely(ret < 0))
-			return ret;
+	ret = hns3_map_and_fill_desc(ring, skb, type);
+	if (unlikely(ret < 0))
+		return ret;
 
-		bd_num += ret;
-	}
+	bd_num += ret;
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
-		size = skb_frag_size(frag);
-		if (!size)
-			continue;
-
-		ret = hns3_fill_desc(ring, frag, size, DESC_TYPE_PAGE);
+		ret = hns3_map_and_fill_desc(ring, frag, DESC_TYPE_PAGE);
 		if (unlikely(ret < 0))
 			return ret;
 
-- 
2.8.1

