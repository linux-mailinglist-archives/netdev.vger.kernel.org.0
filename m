Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93FC5196416
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 08:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgC1HLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 03:11:24 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35120 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725810AbgC1HLY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Mar 2020 03:11:24 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8CC8DB7F545C39E14CDB;
        Sat, 28 Mar 2020 15:10:52 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Sat, 28 Mar 2020 15:10:44 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>
Subject: [PATCH net 2/4] net: hns3: fix for fraglist SKB headlen not handling correctly
Date:   Sat, 28 Mar 2020 15:09:56 +0800
Message-ID: <1585379398-36224-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585379398-36224-1-git-send-email-tanhuazhong@huawei.com>
References: <1585379398-36224-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the fraglist SKB headlen is larger than zero, current code
still handle the fraglist SKB linear data as frag data, which may
cause TX error.

This patch adds a new DESC_TYPE_FRAGLIST_SKB type to handle the
mapping and unmapping of the fraglist SKB linear data buffer.

Fixes: 8ae10cfb5089 ("net: hns3: support tx-scatter-gather-fraglist feature")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h     |  1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 18 +++++++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index a3e4081..5587605 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -78,6 +78,7 @@
 
 enum hns_desc_type {
 	DESC_TYPE_SKB,
+	DESC_TYPE_FRAGLIST_SKB,
 	DESC_TYPE_PAGE,
 };
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index a7f40aa..6936384 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1107,6 +1107,10 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 			return ret;
 
 		dma = dma_map_single(dev, skb->data, size, DMA_TO_DEVICE);
+	} else if (type == DESC_TYPE_FRAGLIST_SKB) {
+		struct sk_buff *skb = (struct sk_buff *)priv;
+
+		dma = dma_map_single(dev, skb->data, size, DMA_TO_DEVICE);
 	} else {
 		frag = (skb_frag_t *)priv;
 		dma = skb_frag_dma_map(dev, frag, 0, size, DMA_TO_DEVICE);
@@ -1144,8 +1148,9 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 		/* The txbd's baseinfo of DESC_TYPE_PAGE & DESC_TYPE_SKB */
 		desc_cb->priv = priv;
 		desc_cb->dma = dma + HNS3_MAX_BD_SIZE * k;
-		desc_cb->type = (type == DESC_TYPE_SKB && !k) ?
-				DESC_TYPE_SKB : DESC_TYPE_PAGE;
+		desc_cb->type = ((type == DESC_TYPE_FRAGLIST_SKB ||
+				  type == DESC_TYPE_SKB) && !k) ?
+				type : DESC_TYPE_PAGE;
 
 		/* now, fill the descriptor */
 		desc->addr = cpu_to_le64(dma + HNS3_MAX_BD_SIZE * k);
@@ -1354,7 +1359,9 @@ static void hns3_clear_desc(struct hns3_enet_ring *ring, int next_to_use_orig)
 		ring_ptr_move_bw(ring, next_to_use);
 
 		/* unmap the descriptor dma address */
-		if (ring->desc_cb[ring->next_to_use].type == DESC_TYPE_SKB)
+		if (ring->desc_cb[ring->next_to_use].type == DESC_TYPE_SKB ||
+		    ring->desc_cb[ring->next_to_use].type ==
+		    DESC_TYPE_FRAGLIST_SKB)
 			dma_unmap_single(dev,
 					 ring->desc_cb[ring->next_to_use].dma,
 					ring->desc_cb[ring->next_to_use].length,
@@ -1447,7 +1454,8 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 		goto out;
 
 	skb_walk_frags(skb, frag_skb) {
-		ret = hns3_fill_skb_to_desc(ring, frag_skb, DESC_TYPE_PAGE);
+		ret = hns3_fill_skb_to_desc(ring, frag_skb,
+					    DESC_TYPE_FRAGLIST_SKB);
 		if (unlikely(ret < 0))
 			goto fill_err;
 
@@ -2356,7 +2364,7 @@ static int hns3_map_buffer(struct hns3_enet_ring *ring, struct hns3_desc_cb *cb)
 static void hns3_unmap_buffer(struct hns3_enet_ring *ring,
 			      struct hns3_desc_cb *cb)
 {
-	if (cb->type == DESC_TYPE_SKB)
+	if (cb->type == DESC_TYPE_SKB || cb->type == DESC_TYPE_FRAGLIST_SKB)
 		dma_unmap_single(ring_to_dev(ring), cb->dma, cb->length,
 				 ring_to_dma_dir(ring));
 	else if (cb->length)
-- 
2.7.4

