Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4282126C0C6
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 11:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgIPJhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 05:37:40 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:54002 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726727AbgIPJgy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 05:36:54 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 85235E417FF980579737;
        Wed, 16 Sep 2020 17:36:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Wed, 16 Sep 2020 17:36:39 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>, <saeed@kernel.org>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 5/6] net: hns3: use writel() to optimize the barrier operation
Date:   Wed, 16 Sep 2020 17:33:49 +0800
Message-ID: <1600248830-59477-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600248830-59477-1-git-send-email-tanhuazhong@huawei.com>
References: <1600248830-59477-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

writel() can be used to order I/O vs memory by default when
writing portable drivers. Use writel() to replace wmb() +
writel_relaxed(), and writel() is dma_wmb() + writel_relaxed()
for ARM64, so there is an optimization here because dma_wmb()
is a lighter barrier than wmb().

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 8 +++-----
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h | 3 ---
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 8490754..4a49a76 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1398,9 +1398,8 @@ static void hns3_tx_doorbell(struct hns3_enet_ring *ring, int num,
 	if (!ring->pending_buf)
 		return;
 
-	wmb(); /* Commit all data before submit */
-
-	hnae3_queue_xmit(ring->tqp, ring->pending_buf);
+	writel(ring->pending_buf,
+	       ring->tqp->io_base + HNS3_RING_TX_RING_TAIL_REG);
 	ring->pending_buf = 0;
 	WRITE_ONCE(ring->last_to_use, ring->next_to_use);
 }
@@ -2618,8 +2617,7 @@ static void hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
 		ring_ptr_move_fw(ring, next_to_use);
 	}
 
-	wmb(); /* Make all data has been write before submit */
-	writel_relaxed(i, ring->tqp->io_base + HNS3_RING_RX_RING_HEAD_REG);
+	writel(i, ring->tqp->io_base + HNS3_RING_RX_RING_HEAD_REG);
 }
 
 static bool hns3_page_is_reusable(struct page *page)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 876dc09..20e62ce 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -539,9 +539,6 @@ static inline bool hns3_nic_resetting(struct net_device *netdev)
 #define hns3_write_dev(a, reg, value) \
 	hns3_write_reg((a)->io_base, (reg), (value))
 
-#define hnae3_queue_xmit(tqp, buf_num) writel_relaxed(buf_num, \
-		(tqp)->io_base + HNS3_RING_TX_RING_TAIL_REG)
-
 #define ring_to_dev(ring) ((ring)->dev)
 
 #define ring_to_netdev(ring)	((ring)->tqp_vector->napi.dev)
-- 
2.7.4

