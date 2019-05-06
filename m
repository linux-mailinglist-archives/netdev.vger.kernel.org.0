Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 926881439D
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 04:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725786AbfEFCuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 22:50:21 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:46888 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726149AbfEFCuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 22:50:20 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BE8CDBA711E53CF67B7D;
        Mon,  6 May 2019 10:50:18 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Mon, 6 May 2019 10:50:12 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <nhorman@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 08/12] net: hns3: fix error handling for desc filling
Date:   Mon, 6 May 2019 10:48:48 +0800
Message-ID: <1557110932-683-9-git-send-email-tanhuazhong@huawei.com>
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

When desc filling fails in hns3_nic_net_xmit, it will call
hns3_clear_desc to unmap the dma mapping. But currently the
ring->next_to_use points to the desc where the desc filling
or dma mapping return error, which means the desc that
ring->next_to_use points to has not done the dma mapping,
the desc that need unmapping is before the ring->next_to_use.

This patch fixes it by calling ring_ptr_move_bw(next_to_use)
before doing unmapping operation, and set desc_cb->dma to
zero to avoid freeing it again when unloading.

Also, when filling skb head or frag fails, both need to unmap
all the way back to next_to_use_head, so remove one desc filling
error handling.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 7224b38..21eac68 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1224,6 +1224,9 @@ static void hns3_clear_desc(struct hns3_enet_ring *ring, int next_to_use_orig)
 		if (ring->next_to_use == next_to_use_orig)
 			break;
 
+		/* rollback one */
+		ring_ptr_move_bw(ring, next_to_use);
+
 		/* unmap the descriptor dma address */
 		if (ring->desc_cb[ring->next_to_use].type == DESC_TYPE_SKB)
 			dma_unmap_single(dev,
@@ -1237,9 +1240,7 @@ static void hns3_clear_desc(struct hns3_enet_ring *ring, int next_to_use_orig)
 				       DMA_TO_DEVICE);
 
 		ring->desc_cb[ring->next_to_use].length = 0;
-
-		/* rollback one */
-		ring_ptr_move_bw(ring, next_to_use);
+		ring->desc_cb[ring->next_to_use].dma = 0;
 	}
 }
 
@@ -1252,7 +1253,6 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 	struct netdev_queue *dev_queue;
 	struct skb_frag_struct *frag;
 	int next_to_use_head;
-	int next_to_use_frag;
 	int buf_num;
 	int seg_num;
 	int size;
@@ -1291,9 +1291,8 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 	ret = hns3_fill_desc(ring, skb, size, seg_num == 1 ? 1 : 0,
 			     DESC_TYPE_SKB);
 	if (unlikely(ret))
-		goto head_fill_err;
+		goto fill_err;
 
-	next_to_use_frag = ring->next_to_use;
 	/* Fill the fragments */
 	for (i = 1; i < seg_num; i++) {
 		frag = &skb_shinfo(skb)->frags[i - 1];
@@ -1304,7 +1303,7 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 				     DESC_TYPE_PAGE);
 
 		if (unlikely(ret))
-			goto frag_fill_err;
+			goto fill_err;
 	}
 
 	/* Complete translate all packets */
@@ -1317,10 +1316,7 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	return NETDEV_TX_OK;
 
-frag_fill_err:
-	hns3_clear_desc(ring, next_to_use_frag);
-
-head_fill_err:
+fill_err:
 	hns3_clear_desc(ring, next_to_use_head);
 
 out_err_tx_ok:
-- 
2.7.4

