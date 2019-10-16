Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F36D8943
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 09:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389797AbfJPHUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 03:20:39 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4175 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732949AbfJPHUO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 03:20:14 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B30DB5067084C23336A1;
        Wed, 16 Oct 2019 15:20:08 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Wed, 16 Oct 2019 15:19:59 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 09/12] net: hns3: minor cleanup for hns3_handle_rx_bd()
Date:   Wed, 16 Oct 2019 15:17:08 +0800
Message-ID: <1571210231-29154-10-git-send-email-tanhuazhong@huawei.com>
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

Since commit e55970950556 ("net: hns3: Add handling of GRO Pkts
not fully RX'ed in NAPI poll"), ring->skb is used to record the
current SKB when processing the RX BD in hns3_handle_rx_bd(),
so the parameter out_skb is unnecessary.

This patch also adjusts the err checking to reduce duplication
in hns3_handle_rx_bd(), and "err == -ENXIO" is rare case, so put
it in the unlikely annotation.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 38 +++++++++----------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 7ddeb9c..6172eb2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2834,10 +2834,10 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
 }
 
 static int hns3_add_frag(struct hns3_enet_ring *ring, struct hns3_desc *desc,
-			 struct sk_buff **out_skb, bool pending)
+			 bool pending)
 {
-	struct sk_buff *skb = *out_skb;
-	struct sk_buff *head_skb = *out_skb;
+	struct sk_buff *skb = ring->skb;
+	struct sk_buff *head_skb = skb;
 	struct sk_buff *new_skb;
 	struct hns3_desc_cb *desc_cb;
 	struct hns3_desc *pre_desc;
@@ -3020,8 +3020,7 @@ static int hns3_handle_bdinfo(struct hns3_enet_ring *ring, struct sk_buff *skb)
 	return 0;
 }
 
-static int hns3_handle_rx_bd(struct hns3_enet_ring *ring,
-			     struct sk_buff **out_skb)
+static int hns3_handle_rx_bd(struct hns3_enet_ring *ring)
 {
 	struct sk_buff *skb = ring->skb;
 	struct hns3_desc_cb *desc_cb;
@@ -3059,12 +3058,12 @@ static int hns3_handle_rx_bd(struct hns3_enet_ring *ring,
 
 	if (!skb) {
 		ret = hns3_alloc_skb(ring, length, ring->va);
-		*out_skb = skb = ring->skb;
+		skb = ring->skb;
 
 		if (ret < 0) /* alloc buffer fail */
 			return ret;
 		if (ret > 0) { /* need add frag */
-			ret = hns3_add_frag(ring, desc, &skb, false);
+			ret = hns3_add_frag(ring, desc, false);
 			if (ret)
 				return ret;
 
@@ -3075,7 +3074,7 @@ static int hns3_handle_rx_bd(struct hns3_enet_ring *ring,
 			       ALIGN(ring->pull_len, sizeof(long)));
 		}
 	} else {
-		ret = hns3_add_frag(ring, desc, &skb, true);
+		ret = hns3_add_frag(ring, desc, true);
 		if (ret)
 			return ret;
 
@@ -3093,8 +3092,6 @@ static int hns3_handle_rx_bd(struct hns3_enet_ring *ring,
 	}
 
 	skb_record_rx_queue(skb, ring->tqp->tqp_index);
-	*out_skb = skb;
-
 	return 0;
 }
 
@@ -3103,7 +3100,6 @@ int hns3_clean_rx_ring(struct hns3_enet_ring *ring, int budget,
 {
 #define RCB_NOF_ALLOC_RX_BUFF_ONCE 16
 	int unused_count = hns3_desc_unused(ring);
-	struct sk_buff *skb = ring->skb;
 	int recv_pkts = 0;
 	int recv_bds = 0;
 	int err, num;
@@ -3126,27 +3122,19 @@ int hns3_clean_rx_ring(struct hns3_enet_ring *ring, int budget,
 		}
 
 		/* Poll one pkt */
-		err = hns3_handle_rx_bd(ring, &skb);
-		if (unlikely(!skb)) /* This fault cannot be repaired */
+		err = hns3_handle_rx_bd(ring);
+		/* Do not get FE for the packet or failed to alloc skb */
+		if (unlikely(!ring->skb || err == -ENXIO)) {
 			goto out;
-
-		if (err == -ENXIO) { /* Do not get FE for the packet */
-			goto out;
-		} else if (unlikely(err)) {  /* Do jump the err */
-			recv_bds += ring->pending_buf;
-			unused_count += ring->pending_buf;
-			ring->skb = NULL;
-			ring->pending_buf = 0;
-			continue;
+		} else if (likely(!err)) {
+			rx_fn(ring, ring->skb);
+			recv_pkts++;
 		}
 
-		rx_fn(ring, skb);
 		recv_bds += ring->pending_buf;
 		unused_count += ring->pending_buf;
 		ring->skb = NULL;
 		ring->pending_buf = 0;
-
-		recv_pkts++;
 	}
 
 out:
-- 
2.7.4

