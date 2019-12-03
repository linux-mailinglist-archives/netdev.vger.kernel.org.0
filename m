Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52E4510F573
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 04:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfLCDIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 22:08:46 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7190 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726254AbfLCDIp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Dec 2019 22:08:45 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 84BE163590DDBFB96CCA;
        Tue,  3 Dec 2019 11:08:43 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Tue, 3 Dec 2019 11:08:34 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 2/3] net: hns3: fix a use after free problem in hns3_nic_maybe_stop_tx()
Date:   Tue, 3 Dec 2019 11:08:54 +0800
Message-ID: <1575342535-2981-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1575342535-2981-1-git-send-email-tanhuazhong@huawei.com>
References: <1575342535-2981-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

Currently, hns3_nic_maybe_stop_tx() uses skb_copy() to linearize a
SKB if the BD num required by the SKB does not meet the hardware
limitation, and it linearizes the SKB by allocating a new SKB and
freeing the old SKB, if hns3_nic_maybe_stop_tx() returns -EBUSY,
the sch_direct_xmit() still hold reference to old SKB and try to
retransmit the old SKB when dev_hard_start_xmit() return TX_BUSY,
which may cause use after freed problem.

This patch fixes it by using __skb_linearize() to linearize the
SKB in hns3_nic_maybe_stop_tx().

Fixes: 51e8439f3496 ("net: hns3: add 8 BD limit for tx flow")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index b2bb8e2..cbdb688 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1287,33 +1287,26 @@ static bool hns3_skb_need_linearized(struct sk_buff *skb, unsigned int *bd_size,
 }
 
 static int hns3_nic_maybe_stop_tx(struct net_device *netdev,
-				  struct sk_buff **out_skb)
+				  struct sk_buff *skb)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	unsigned int bd_size[HNS3_MAX_TSO_BD_NUM + 1U];
-	struct sk_buff *skb = *out_skb;
 	struct hns3_enet_ring *ring;
 	unsigned int bd_num;
 
 	ring = &priv->ring[skb->queue_mapping];
 	bd_num = hns3_tx_bd_num(skb, bd_size);
 	if (unlikely(bd_num > HNS3_MAX_NON_TSO_BD_NUM)) {
-		struct sk_buff *new_skb;
 
 		if (bd_num <= HNS3_MAX_TSO_BD_NUM && skb_is_gso(skb) &&
 		    !hns3_skb_need_linearized(skb, bd_size, bd_num))
 			goto out;
 
-		/* manual split the send packet */
-		new_skb = skb_copy(skb, GFP_ATOMIC);
-		if (!new_skb)
+		if (__skb_linearize(skb))
 			return -ENOMEM;
-		dev_kfree_skb_any(skb);
-		*out_skb = new_skb;
-
-		bd_num = hns3_tx_bd_count(new_skb->len);
-		if ((skb_is_gso(new_skb) && bd_num > HNS3_MAX_TSO_BD_NUM) ||
-		    (!skb_is_gso(new_skb) &&
+		bd_num = hns3_tx_bd_count(skb->len);
+		if ((skb_is_gso(skb) && bd_num > HNS3_MAX_TSO_BD_NUM) ||
+		    (!skb_is_gso(skb) &&
 		     bd_num > HNS3_MAX_NON_TSO_BD_NUM))
 			return -ENOMEM;
 
@@ -1416,7 +1409,7 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 	/* Prefetch the data used later */
 	prefetch(skb->data);
 
-	ret = hns3_nic_maybe_stop_tx(netdev, &skb);
+	ret = hns3_nic_maybe_stop_tx(netdev, skb);
 	if (unlikely(ret <= 0)) {
 		if (ret == -EBUSY) {
 			u64_stats_update_begin(&ring->syncp);
-- 
2.7.4

