Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA8AEE904
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 20:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbfKDT4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 14:56:22 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:45632 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728322AbfKDT4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 14:56:22 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iRiSa-0002Sc-78; Mon, 04 Nov 2019 20:56:20 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lipeng <lipeng321@huawei.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH] net: hns: Ensure that interface teardown cannot race with TX interrupt
Date:   Mon,  4 Nov 2019 19:56:04 +0000
Message-Id: <20191104195604.17109-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: netdev@vger.kernel.org, lipeng321@huawei.com, yisen.zhuang@huawei.com, salil.mehta@huawei.com, davem@davemloft.net
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On a lockdep-enabled kernel, bringing down a HNS interface results
in a loud splat. It turns out that  the per-ring spinlock is taken
both in the TX interrupt path, and when bringing down the interface.

Lockdep sums it up with:

[32099.424453]        CPU0
[32099.426885]        ----
[32099.429318]   lock(&(&ring->lock)->rlock);
[32099.433402]   <Interrupt>
[32099.436008]     lock(&(&ring->lock)->rlock);
[32099.440264]
[32099.440264]  *** DEADLOCK ***

To solve this, turn the NETIF_TX_{LOCK,UNLOCK} macros from standard
spin_[un]lock to their irqsave/irqrestore version.

Fixes: f2aaed557ecff ("net: hns: Replace netif_tx_lock to ring spin lock")
Cc: lipeng <lipeng321@huawei.com>
Cc: Yisen Zhuang <yisen.zhuang@huawei.com>
Cc: Salil Mehta <salil.mehta@huawei.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c | 22 ++++++++++---------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index a48396dd4ebb..9fbe4e1e6853 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -945,11 +945,11 @@ static int is_valid_clean_head(struct hnae_ring *ring, int h)
 
 /* netif_tx_lock will turn down the performance, set only when necessary */
 #ifdef CONFIG_NET_POLL_CONTROLLER
-#define NETIF_TX_LOCK(ring) spin_lock(&(ring)->lock)
-#define NETIF_TX_UNLOCK(ring) spin_unlock(&(ring)->lock)
+#define NETIF_TX_LOCK(ring, flags) spin_lock_irqsave(&(ring)->lock, flags)
+#define NETIF_TX_UNLOCK(ring, flags) spin_unlock_irqrestore(&(ring)->lock, flags)
 #else
-#define NETIF_TX_LOCK(ring)
-#define NETIF_TX_UNLOCK(ring)
+#define NETIF_TX_LOCK(ring, flags)
+#define NETIF_TX_UNLOCK(ring, flags)
 #endif
 
 /* reclaim all desc in one budget
@@ -962,16 +962,17 @@ static int hns_nic_tx_poll_one(struct hns_nic_ring_data *ring_data,
 	struct net_device *ndev = ring_data->napi.dev;
 	struct netdev_queue *dev_queue;
 	struct hns_nic_priv *priv = netdev_priv(ndev);
+	unsigned long flags;
 	int head;
 	int bytes, pkts;
 
-	NETIF_TX_LOCK(ring);
+	NETIF_TX_LOCK(ring, flags);
 
 	head = readl_relaxed(ring->io_base + RCB_REG_HEAD);
 	rmb(); /* make sure head is ready before touch any data */
 
 	if (is_ring_empty(ring) || head == ring->next_to_clean) {
-		NETIF_TX_UNLOCK(ring);
+		NETIF_TX_UNLOCK(ring, flags);
 		return 0; /* no data to poll */
 	}
 
@@ -979,7 +980,7 @@ static int hns_nic_tx_poll_one(struct hns_nic_ring_data *ring_data,
 		netdev_err(ndev, "wrong head (%d, %d-%d)\n", head,
 			   ring->next_to_use, ring->next_to_clean);
 		ring->stats.io_err_cnt++;
-		NETIF_TX_UNLOCK(ring);
+		NETIF_TX_UNLOCK(ring, flags);
 		return -EIO;
 	}
 
@@ -994,7 +995,7 @@ static int hns_nic_tx_poll_one(struct hns_nic_ring_data *ring_data,
 	ring->stats.tx_pkts += pkts;
 	ring->stats.tx_bytes += bytes;
 
-	NETIF_TX_UNLOCK(ring);
+	NETIF_TX_UNLOCK(ring, flags);
 
 	dev_queue = netdev_get_tx_queue(ndev, ring_data->queue_index);
 	netdev_tx_completed_queue(dev_queue, pkts, bytes);
@@ -1052,10 +1053,11 @@ static void hns_nic_tx_clr_all_bufs(struct hns_nic_ring_data *ring_data)
 	struct hnae_ring *ring = ring_data->ring;
 	struct net_device *ndev = ring_data->napi.dev;
 	struct netdev_queue *dev_queue;
+	unsigned long flags;
 	int head;
 	int bytes, pkts;
 
-	NETIF_TX_LOCK(ring);
+	NETIF_TX_LOCK(ring, flags);
 
 	head = ring->next_to_use; /* ntu :soft setted ring position*/
 	bytes = 0;
@@ -1063,7 +1065,7 @@ static void hns_nic_tx_clr_all_bufs(struct hns_nic_ring_data *ring_data)
 	while (head != ring->next_to_clean)
 		hns_nic_reclaim_one_desc(ring, &bytes, &pkts);
 
-	NETIF_TX_UNLOCK(ring);
+	NETIF_TX_UNLOCK(ring, flags);
 
 	dev_queue = netdev_get_tx_queue(ndev, ring_data->queue_index);
 	netdev_tx_reset_queue(dev_queue);
-- 
2.20.1

