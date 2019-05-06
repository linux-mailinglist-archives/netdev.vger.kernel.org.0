Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E52C14390
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 04:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfEFCu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 22:50:28 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58428 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726477AbfEFCu0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 22:50:26 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A3BEC207D4745634FBC4;
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
Subject: [PATCH net-next 11/12] net: hns3: some cleanup for struct hns3_enet_ring
Date:   Mon, 6 May 2019 10:48:51 +0800
Message-ID: <1557110932-683-12-git-send-email-tanhuazhong@huawei.com>
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

This patch removes some unused field in struct hns3_enet_ring,
use ring->dev for ring_to_dev macro, and use dev consistently
in hns3_fill_desc.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h | 9 +--------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index b6e73fe..65fb421 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1051,7 +1051,7 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 		dma = skb_frag_dma_map(dev, frag, 0, size, DMA_TO_DEVICE);
 	}
 
-	if (unlikely(dma_mapping_error(ring->dev, dma))) {
+	if (unlikely(dma_mapping_error(dev, dma))) {
 		ring->stats.sw_err_cnt++;
 		return -ENOMEM;
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 9680a68..c14480f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -401,7 +401,6 @@ struct hns3_enet_ring {
 	struct hns3_enet_ring *next;
 	struct hns3_enet_tqp_vector *tqp_vector;
 	struct hnae3_queue *tqp;
-	char ring_name[HNS3_RING_NAME_LEN];
 	struct device *dev; /* will be used for DMA mapping of descriptors */
 
 	/* statistic */
@@ -411,9 +410,6 @@ struct hns3_enet_ring {
 	dma_addr_t desc_dma_addr;
 	u32 buf_size;       /* size for hnae_desc->addr, preset by AE */
 	u16 desc_num;       /* total number of desc */
-	u16 max_desc_num_per_pkt;
-	u16 max_raw_data_sz_per_desc;
-	u16 max_pkt_size;
 	int next_to_use;    /* idx of next spare desc */
 
 	/* idx of lastest sent desc, the ring is empty when equal to
@@ -427,9 +423,6 @@ struct hns3_enet_ring {
 
 	u32 flag;          /* ring attribute */
 
-	int numa_node;
-	cpumask_t affinity_mask;
-
 	int pending_buf;
 	struct sk_buff *skb;
 	struct sk_buff *tail_skb;
@@ -629,7 +622,7 @@ static inline bool hns3_nic_resetting(struct net_device *netdev)
 #define hnae3_queue_xmit(tqp, buf_num) writel_relaxed(buf_num, \
 		(tqp)->io_base + HNS3_RING_TX_RING_TAIL_REG)
 
-#define ring_to_dev(ring) (&(ring)->tqp->handle->pdev->dev)
+#define ring_to_dev(ring) ((ring)->dev)
 
 #define ring_to_dma_dir(ring) (HNAE3_IS_TX_RING(ring) ? \
 	DMA_TO_DEVICE : DMA_FROM_DEVICE)
-- 
2.7.4

