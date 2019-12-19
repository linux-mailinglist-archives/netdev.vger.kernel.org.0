Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5915125BBF
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 07:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfLSG6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 01:58:05 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:51226 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726754AbfLSG5u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 01:57:50 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id ED6C5DD63AB7E1A3E850;
        Thu, 19 Dec 2019 14:57:46 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Thu, 19 Dec 2019 14:57:38 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 1/8] net: hns3: check FE bit before calling hns3_add_frag()
Date:   Thu, 19 Dec 2019 14:57:40 +0800
Message-ID: <1576738667-37960-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576738667-37960-1-git-send-email-tanhuazhong@huawei.com>
References: <1576738667-37960-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

A BD with FE bit means that it is the last BD of a packet,
currently the FE bit is checked before calling hns3_add_frag(),
which is unnecessary because the FE bit may have been checked
in some case.

This patch checks the FE bit before calling hns3_add_frag()
after processing the first BD of a SKB and adjust the location
of memcpy() to reduce duplication.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 46 +++++++------------------
 1 file changed, 13 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index b113b89..5679a0c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2788,7 +2788,6 @@ static bool hns3_parse_vlan_tag(struct hns3_enet_ring *ring,
 static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
 			  unsigned char *va)
 {
-#define HNS3_NEED_ADD_FRAG	1
 	struct hns3_desc_cb *desc_cb = &ring->desc_cb[ring->next_to_clean];
 	struct net_device *netdev = ring_to_netdev(ring);
 	struct sk_buff *skb;
@@ -2832,33 +2831,19 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
 			    desc_cb);
 	ring_ptr_move_fw(ring, next_to_clean);
 
-	return HNS3_NEED_ADD_FRAG;
+	return 0;
 }
 
-static int hns3_add_frag(struct hns3_enet_ring *ring, struct hns3_desc *desc,
-			 bool pending)
+static int hns3_add_frag(struct hns3_enet_ring *ring)
 {
 	struct sk_buff *skb = ring->skb;
 	struct sk_buff *head_skb = skb;
 	struct sk_buff *new_skb;
 	struct hns3_desc_cb *desc_cb;
-	struct hns3_desc *pre_desc;
+	struct hns3_desc *desc;
 	u32 bd_base_info;
-	int pre_bd;
-
-	/* if there is pending bd, the SW param next_to_clean has moved
-	 * to next and the next is NULL
-	 */
-	if (pending) {
-		pre_bd = (ring->next_to_clean - 1 + ring->desc_num) %
-			 ring->desc_num;
-		pre_desc = &ring->desc[pre_bd];
-		bd_base_info = le32_to_cpu(pre_desc->rx.bd_base_info);
-	} else {
-		bd_base_info = le32_to_cpu(desc->rx.bd_base_info);
-	}
 
-	while (!(bd_base_info & BIT(HNS3_RXD_FE_B))) {
+	do {
 		desc = &ring->desc[ring->next_to_clean];
 		desc_cb = &ring->desc_cb[ring->next_to_clean];
 		bd_base_info = le32_to_cpu(desc->rx.bd_base_info);
@@ -2895,7 +2880,7 @@ static int hns3_add_frag(struct hns3_enet_ring *ring, struct hns3_desc *desc,
 		hns3_nic_reuse_page(skb, ring->frag_num++, ring, 0, desc_cb);
 		ring_ptr_move_fw(ring, next_to_clean);
 		ring->pending_buf++;
-	}
+	} while (!(bd_base_info & BIT(HNS3_RXD_FE_B)));
 
 	return 0;
 }
@@ -3063,28 +3048,23 @@ static int hns3_handle_rx_bd(struct hns3_enet_ring *ring)
 
 		if (ret < 0) /* alloc buffer fail */
 			return ret;
-		if (ret > 0) { /* need add frag */
-			ret = hns3_add_frag(ring, desc, false);
+		if (!(bd_base_info & BIT(HNS3_RXD_FE_B))) { /* need add frag */
+			ret = hns3_add_frag(ring);
 			if (ret)
 				return ret;
-
-			/* As the head data may be changed when GRO enable, copy
-			 * the head data in after other data rx completed
-			 */
-			memcpy(skb->data, ring->va,
-			       ALIGN(ring->pull_len, sizeof(long)));
 		}
 	} else {
-		ret = hns3_add_frag(ring, desc, true);
+		ret = hns3_add_frag(ring);
 		if (ret)
 			return ret;
+	}
 
-		/* As the head data may be changed when GRO enable, copy
-		 * the head data in after other data rx completed
-		 */
+	/* As the head data may be changed when GRO enable, copy
+	 * the head data in after other data rx completed
+	 */
+	if (skb->len > HNS3_RX_HEAD_SIZE)
 		memcpy(skb->data, ring->va,
 		       ALIGN(ring->pull_len, sizeof(long)));
-	}
 
 	ret = hns3_handle_bdinfo(ring, skb);
 	if (unlikely(ret)) {
-- 
2.7.4

