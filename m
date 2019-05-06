Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87C951439F
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 04:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfEFCuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 22:50:21 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7163 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725786AbfEFCuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 22:50:20 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A5A02311E24576F1D02E;
        Mon,  6 May 2019 10:50:18 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Mon, 6 May 2019 10:50:11 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <nhorman@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 05/12] net: hns3: fix for tunnel type handling in hns3_rx_checksum
Date:   Mon, 6 May 2019 10:48:45 +0800
Message-ID: <1557110932-683-6-git-send-email-tanhuazhong@huawei.com>
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

According to hardware user manual, the tunnel packet type is
available in the rx.ol_info field of struct hns3_desc. Currently
the tunnel packet type is decided by the rx.l234_info, which may
cause RX checksum handling error.

This patch fixes it by using the correct field in struct hns3_desc
to decide the tunnel packet type.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 944e0ae..14312ff 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2463,7 +2463,7 @@ static int hns3_gro_complete(struct sk_buff *skb)
 }
 
 static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
-			     u32 l234info, u32 bd_base_info)
+			     u32 l234info, u32 bd_base_info, u32 ol_info)
 {
 	struct net_device *netdev = ring->tqp->handle->kinfo.netdev;
 	int l3_type, l4_type;
@@ -2490,7 +2490,7 @@ static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
 		return;
 	}
 
-	ol4_type = hnae3_get_field(l234info, HNS3_RXD_OL4ID_M,
+	ol4_type = hnae3_get_field(ol_info, HNS3_RXD_OL4ID_M,
 				   HNS3_RXD_OL4ID_S);
 	switch (ol4_type) {
 	case HNS3_OL4_TYPE_MAC_IN_UDP:
@@ -2694,7 +2694,7 @@ static int hns3_add_frag(struct hns3_enet_ring *ring, struct hns3_desc *desc,
 
 static int hns3_set_gro_and_checksum(struct hns3_enet_ring *ring,
 				     struct sk_buff *skb, u32 l234info,
-				     u32 bd_base_info)
+				     u32 bd_base_info, u32 ol_info)
 {
 	u16 gro_count;
 	u32 l3_type;
@@ -2703,7 +2703,7 @@ static int hns3_set_gro_and_checksum(struct hns3_enet_ring *ring,
 				    HNS3_RXD_GRO_COUNT_S);
 	/* if there is no HW GRO, do not set gro params */
 	if (!gro_count) {
-		hns3_rx_checksum(ring, skb, l234info, bd_base_info);
+		hns3_rx_checksum(ring, skb, l234info, bd_base_info, ol_info);
 		return 0;
 	}
 
@@ -2743,7 +2743,7 @@ static int hns3_handle_bdinfo(struct hns3_enet_ring *ring, struct sk_buff *skb)
 {
 	struct net_device *netdev = ring->tqp->handle->kinfo.netdev;
 	enum hns3_pkt_l2t_type l2_frame_type;
-	u32 bd_base_info, l234info;
+	u32 bd_base_info, l234info, ol_info;
 	struct hns3_desc *desc;
 	unsigned int len;
 	int pre_ntc, ret;
@@ -2757,6 +2757,7 @@ static int hns3_handle_bdinfo(struct hns3_enet_ring *ring, struct sk_buff *skb)
 	desc = &ring->desc[pre_ntc];
 	bd_base_info = le32_to_cpu(desc->rx.bd_base_info);
 	l234info = le32_to_cpu(desc->rx.l234_info);
+	ol_info = le32_to_cpu(desc->rx.ol_info);
 
 	/* Based on hw strategy, the tag offloaded will be stored at
 	 * ot_vlan_tag in two layer tag case, and stored at vlan_tag
@@ -2796,7 +2797,8 @@ static int hns3_handle_bdinfo(struct hns3_enet_ring *ring, struct sk_buff *skb)
 	skb->protocol = eth_type_trans(skb, netdev);
 
 	/* This is needed in order to enable forwarding support */
-	ret = hns3_set_gro_and_checksum(ring, skb, l234info, bd_base_info);
+	ret = hns3_set_gro_and_checksum(ring, skb, l234info,
+					bd_base_info, ol_info);
 	if (unlikely(ret)) {
 		u64_stats_update_begin(&ring->syncp);
 		ring->stats.rx_err_cnt++;
-- 
2.7.4

