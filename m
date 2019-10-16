Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A35D894E
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 09:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403937AbfJPHU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 03:20:59 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4171 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732727AbfJPHUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 03:20:11 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9EA743DCAB29E3FA70E5;
        Wed, 16 Oct 2019 15:20:08 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Wed, 16 Oct 2019 15:19:58 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 02/12] net: hns3: fix TX queue not restarted problem
Date:   Wed, 16 Oct 2019 15:17:01 +0800
Message-ID: <1571210231-29154-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571210231-29154-1-git-send-email-tanhuazhong@huawei.com>
References: <1571210231-29154-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

There is timing window between ring_space checking and
netif_stop_subqueue when transmiting a SKB, and the TX BD
cleaning may be executed during the time window, which may
caused TX queue not restarted problem.

This patch fixes it by rechecking the ring_space after
netif_stop_subqueue to make sure TX queue is restarted.

Also, the ring->next_to_clean is updated even when PKTs is
zero, because all the TX BD cleaned may be non-SKB, so it
needs to check if TX queue need to be restarted.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 36 ++++++++++++++++---------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 635bdda..2cfdfbb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1286,13 +1286,16 @@ static bool hns3_skb_need_linearized(struct sk_buff *skb, unsigned int *bd_size,
 	return false;
 }
 
-static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
+static int hns3_nic_maybe_stop_tx(struct net_device *netdev,
 				  struct sk_buff **out_skb)
 {
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	unsigned int bd_size[HNS3_MAX_TSO_BD_NUM + 1U];
 	struct sk_buff *skb = *out_skb;
+	struct hns3_enet_ring *ring;
 	unsigned int bd_num;
 
+	ring = &priv->ring[skb->queue_mapping];
 	bd_num = hns3_tx_bd_num(skb, bd_size);
 	if (unlikely(bd_num > HNS3_MAX_NON_TSO_BD_NUM)) {
 		struct sk_buff *new_skb;
@@ -1320,10 +1323,23 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 	}
 
 out:
-	if (unlikely(ring_space(ring) < bd_num))
-		return -EBUSY;
+	if (likely(ring_space(ring) >= bd_num))
+		return bd_num;
 
-	return bd_num;
+	netif_stop_subqueue(netdev, ring->queue_index);
+	smp_mb(); /* Memory barrier before checking ring_space */
+
+	/* Start queue in case hns3_clean_tx_ring has just made room
+	 * available and has not seen the queue stopped state performed
+	 * by netif_stop_subqueue above.
+	 */
+	if (ring_space(ring) >= bd_num && netif_carrier_ok(netdev) &&
+	    !test_bit(HNS3_NIC_STATE_DOWN, &priv->state)) {
+		netif_start_subqueue(netdev, ring->queue_index);
+		return bd_num;
+	}
+
+	return -EBUSY;
 }
 
 static void hns3_clear_desc(struct hns3_enet_ring *ring, int next_to_use_orig)
@@ -1400,13 +1416,13 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 	/* Prefetch the data used later */
 	prefetch(skb->data);
 
-	ret = hns3_nic_maybe_stop_tx(ring, &skb);
+	ret = hns3_nic_maybe_stop_tx(netdev, &skb);
 	if (unlikely(ret <= 0)) {
 		if (ret == -EBUSY) {
 			u64_stats_update_begin(&ring->syncp);
 			ring->stats.tx_busy++;
 			u64_stats_update_end(&ring->syncp);
-			goto out_net_tx_busy;
+			return NETDEV_TX_BUSY;
 		} else if (ret == -ENOMEM) {
 			u64_stats_update_begin(&ring->syncp);
 			ring->stats.sw_err_cnt++;
@@ -1457,12 +1473,6 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 out_err_tx_ok:
 	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
-
-out_net_tx_busy:
-	netif_stop_subqueue(netdev, ring->queue_index);
-	smp_mb(); /* Commit all data before submit */
-
-	return NETDEV_TX_BUSY;
 }
 
 static int hns3_nic_net_set_mac_address(struct net_device *netdev, void *p)
@@ -2515,7 +2525,7 @@ void hns3_clean_tx_ring(struct hns3_enet_ring *ring)
 	dev_queue = netdev_get_tx_queue(netdev, ring->tqp->tqp_index);
 	netdev_tx_completed_queue(dev_queue, pkts, bytes);
 
-	if (unlikely(pkts && netif_carrier_ok(netdev) &&
+	if (unlikely(netif_carrier_ok(netdev) &&
 		     ring_space(ring) > HNS3_MAX_TSO_BD_NUM)) {
 		/* Make sure that anybody stopping the queue after this
 		 * sees the new next_to_clean.
-- 
2.7.4

