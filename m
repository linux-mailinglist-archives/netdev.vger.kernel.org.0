Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B55DF357B
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 18:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbfKGRLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 12:11:52 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:5744 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726231AbfKGRLw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 12:11:52 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6B610380FE4F07C059D1;
        Fri,  8 Nov 2019 01:11:47 +0800 (CST)
Received: from A190218597.china.huawei.com (10.202.226.45) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Fri, 8 Nov 2019 01:11:39 +0800
From:   Salil Mehta <salil.mehta@huawei.com>
To:     <davem@davemloft.net>, <maz@kernel.org>
CC:     <edumazet@google.com>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <lipeng321@huawei.com>,
        <mehta.salil@opnsrc.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [PATCH V2 net] net: hns: Fix the stray netpoll locks causing deadlock in NAPI path
Date:   Thu, 7 Nov 2019 17:09:53 +0000
Message-ID: <20191107170953.7672-1-salil.mehta@huawei.com>
X-Mailer: git-send-email 2.8.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.202.226.45]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the problem of the spin locks, originally
meant for the netpoll path of hns driver, causing deadlock in
the normal NAPI poll path. The issue happened due to the presence
of the stray leftover spin lock code related to the netpoll,
whose support was earlier removed from the HNS[1], got activated
due to enabling of NET_POLL_CONTROLLER switch.

Earlier background:
The netpoll handling code originally had this bug(as identified
by Marc Zyngier[2]) of wrong spin lock API being used which did
not disable the interrupts and hence could cause locking issues.
i.e. if the lock were first acquired in context to thread like
'ip' util and this lock if ever got later acquired again in
context to the interrupt context like TX/RX (Interrupts could
always pre-empt the lock holding task and acquire the lock again)
and hence could cause deadlock.

Proposed Solution:
1. If the netpoll was enabled in the HNS driver, which is not
   right now, we could have simply used spin_[un]lock_irqsave()
2. But as netpoll is disabled, therefore, it is best to get rid
   of the existing locks and stray code for now. This should
   solve the problem reported by Marc.

[1] https://git.kernel.org/torvalds/c/4bd2c03be7
[2] https://patchwork.ozlabs.org/patch/1189139/

Fixes: 4bd2c03be707 ("net: hns: remove ndo_poll_controller")
Cc: lipeng <lipeng321@huawei.com>
Cc: Yisen Zhuang <yisen.zhuang@huawei.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: David S. Miller <davem@davemloft.net>
Reported-by: Marc Zyngier <maz@kernel.org>
Acked-by: Marc Zyngier <maz@kernel.org>
Tested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hnae.c     |  1 -
 drivers/net/ethernet/hisilicon/hns/hnae.h     |  3 ---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c | 22 +------------------
 3 files changed, 1 insertion(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hnae.c b/drivers/net/ethernet/hisilicon/hns/hnae.c
index 6d0457eb4faa..08339278c722 100644
--- a/drivers/net/ethernet/hisilicon/hns/hnae.c
+++ b/drivers/net/ethernet/hisilicon/hns/hnae.c
@@ -199,7 +199,6 @@ hnae_init_ring(struct hnae_queue *q, struct hnae_ring *ring, int flags)
 
 	ring->q = q;
 	ring->flags = flags;
-	spin_lock_init(&ring->lock);
 	ring->coal_param = q->handle->coal_param;
 	assert(!ring->desc && !ring->desc_cb && !ring->desc_dma_addr);
 
diff --git a/drivers/net/ethernet/hisilicon/hns/hnae.h b/drivers/net/ethernet/hisilicon/hns/hnae.h
index e9c67c06bfd2..6ab9458302e1 100644
--- a/drivers/net/ethernet/hisilicon/hns/hnae.h
+++ b/drivers/net/ethernet/hisilicon/hns/hnae.h
@@ -274,9 +274,6 @@ struct hnae_ring {
 	/* statistic */
 	struct ring_stats stats;
 
-	/* ring lock for poll one */
-	spinlock_t lock;
-
 	dma_addr_t desc_dma_addr;
 	u32 buf_size;       /* size for hnae_desc->addr, preset by AE */
 	u16 desc_num;       /* total number of desc */
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index a48396dd4ebb..14ab20491fd0 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -943,15 +943,6 @@ static int is_valid_clean_head(struct hnae_ring *ring, int h)
 	return u > c ? (h > c && h <= u) : (h > c || h <= u);
 }
 
-/* netif_tx_lock will turn down the performance, set only when necessary */
-#ifdef CONFIG_NET_POLL_CONTROLLER
-#define NETIF_TX_LOCK(ring) spin_lock(&(ring)->lock)
-#define NETIF_TX_UNLOCK(ring) spin_unlock(&(ring)->lock)
-#else
-#define NETIF_TX_LOCK(ring)
-#define NETIF_TX_UNLOCK(ring)
-#endif
-
 /* reclaim all desc in one budget
  * return error or number of desc left
  */
@@ -965,21 +956,16 @@ static int hns_nic_tx_poll_one(struct hns_nic_ring_data *ring_data,
 	int head;
 	int bytes, pkts;
 
-	NETIF_TX_LOCK(ring);
-
 	head = readl_relaxed(ring->io_base + RCB_REG_HEAD);
 	rmb(); /* make sure head is ready before touch any data */
 
-	if (is_ring_empty(ring) || head == ring->next_to_clean) {
-		NETIF_TX_UNLOCK(ring);
+	if (is_ring_empty(ring) || head == ring->next_to_clean)
 		return 0; /* no data to poll */
-	}
 
 	if (!is_valid_clean_head(ring, head)) {
 		netdev_err(ndev, "wrong head (%d, %d-%d)\n", head,
 			   ring->next_to_use, ring->next_to_clean);
 		ring->stats.io_err_cnt++;
-		NETIF_TX_UNLOCK(ring);
 		return -EIO;
 	}
 
@@ -994,8 +980,6 @@ static int hns_nic_tx_poll_one(struct hns_nic_ring_data *ring_data,
 	ring->stats.tx_pkts += pkts;
 	ring->stats.tx_bytes += bytes;
 
-	NETIF_TX_UNLOCK(ring);
-
 	dev_queue = netdev_get_tx_queue(ndev, ring_data->queue_index);
 	netdev_tx_completed_queue(dev_queue, pkts, bytes);
 
@@ -1055,16 +1039,12 @@ static void hns_nic_tx_clr_all_bufs(struct hns_nic_ring_data *ring_data)
 	int head;
 	int bytes, pkts;
 
-	NETIF_TX_LOCK(ring);
-
 	head = ring->next_to_use; /* ntu :soft setted ring position*/
 	bytes = 0;
 	pkts = 0;
 	while (head != ring->next_to_clean)
 		hns_nic_reclaim_one_desc(ring, &bytes, &pkts);
 
-	NETIF_TX_UNLOCK(ring);
-
 	dev_queue = netdev_get_tx_queue(ndev, ring_data->queue_index);
 	netdev_tx_reset_queue(dev_queue);
 }
-- 
2.17.1


