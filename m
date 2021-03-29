Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5175634C261
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 06:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhC2D7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 23:59:15 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14506 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhC2D60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 23:58:26 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F7zK16DRKzrbX8;
        Mon, 29 Mar 2021 11:56:21 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Mon, 29 Mar 2021 11:58:14 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, <linuxarm@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 7/9] net: hns3: add tx send size handling for tso skb
Date:   Mon, 29 Mar 2021 11:57:51 +0800
Message-ID: <1616990273-46426-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616990273-46426-1-git-send-email-tanhuazhong@huawei.com>
References: <1616990273-46426-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

The actual size on wire for tso skb should be (gso_segs - 1) *
hdr + skb->len instead of skb->len, which can be seen by user using
'ethtool -S ethX' cmd, and 'Byte Queue Limit' also use the send size
stat to do the queue limiting, so add send_bytes in the desc_cb to
record the actual send size for a skb. And send_bytes is only for tx
desc_cb and page_offset is only for rx desc, so reuse the same space
for both of them.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 25 ++++++++++++++++++-------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h |  7 ++++++-
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 2dbcd95..5e08ac9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -694,7 +694,7 @@ void hns3_enable_vlan_filter(struct net_device *netdev, bool enable)
 }
 
 static int hns3_set_tso(struct sk_buff *skb, u32 *paylen_fdop_ol4cs,
-			u16 *mss, u32 *type_cs_vlan_tso)
+			u16 *mss, u32 *type_cs_vlan_tso, u32 *send_bytes)
 {
 	u32 l4_offset, hdr_len;
 	union l3_hdr_info l3;
@@ -750,6 +750,8 @@ static int hns3_set_tso(struct sk_buff *skb, u32 *paylen_fdop_ol4cs,
 				     (__force __wsum)htonl(l4_paylen));
 	}
 
+	*send_bytes = (skb_shinfo(skb)->gso_segs - 1) * hdr_len + skb->len;
+
 	/* find the txbd field values */
 	*paylen_fdop_ol4cs = skb->len - hdr_len;
 	hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_TSO_B, 1);
@@ -1076,7 +1078,8 @@ static bool hns3_check_hw_tx_csum(struct sk_buff *skb)
 }
 
 static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
-			      struct sk_buff *skb, struct hns3_desc *desc)
+			      struct sk_buff *skb, struct hns3_desc *desc,
+			      struct hns3_desc_cb *desc_cb)
 {
 	u32 ol_type_vlan_len_msec = 0;
 	u32 paylen_ol4cs = skb->len;
@@ -1105,6 +1108,8 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 			       1);
 	}
 
+	desc_cb->send_bytes = skb->len;
+
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		u8 ol4_proto, il4_proto;
 
@@ -1140,7 +1145,7 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 		}
 
 		ret = hns3_set_tso(skb, &paylen_ol4cs, &mss_hw_csum,
-				   &type_cs_vlan_tso);
+				   &type_cs_vlan_tso, &desc_cb->send_bytes);
 		if (unlikely(ret < 0)) {
 			u64_stats_update_begin(&ring->syncp);
 			ring->stats.tx_tso_err++;
@@ -1553,6 +1558,7 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hns3_enet_ring *ring = &priv->ring[skb->queue_mapping];
+	struct hns3_desc_cb *desc_cb = &ring->desc_cb[ring->next_to_use];
 	struct netdev_queue *dev_queue;
 	int pre_ntu, next_to_use_head;
 	bool doorbell;
@@ -1580,7 +1586,8 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	next_to_use_head = ring->next_to_use;
 
-	ret = hns3_fill_skb_desc(ring, skb, &ring->desc[ring->next_to_use]);
+	ret = hns3_fill_skb_desc(ring, skb, &ring->desc[ring->next_to_use],
+				 desc_cb);
 	if (unlikely(ret < 0))
 		goto fill_err;
 
@@ -1600,7 +1607,7 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	/* Complete translate all packets */
 	dev_queue = netdev_get_tx_queue(netdev, ring->queue_index);
-	doorbell = __netdev_tx_sent_queue(dev_queue, skb->len,
+	doorbell = __netdev_tx_sent_queue(dev_queue, desc_cb->send_bytes,
 					  netdev_xmit_more());
 	hns3_tx_doorbell(ring, ret, doorbell);
 
@@ -2721,8 +2728,12 @@ static bool hns3_nic_reclaim_desc(struct hns3_enet_ring *ring,
 			break;
 
 		desc_cb = &ring->desc_cb[ntc];
-		(*pkts) += (desc_cb->type == DESC_TYPE_SKB);
-		(*bytes) += desc_cb->length;
+
+		if (desc_cb->type == DESC_TYPE_SKB) {
+			(*pkts)++;
+			(*bytes) += desc_cb->send_bytes;
+		}
+
 		/* desc_cb will be cleaned, after hnae3_free_buffer_detach */
 		hns3_free_buffer_detach(ring, ntc, budget);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index e44224e..daa04ae 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -298,7 +298,12 @@ struct hns3_desc_cb {
 
 	/* priv data for the desc, e.g. skb when use with ip stack */
 	void *priv;
-	u32 page_offset;
+
+	union {
+		u32 page_offset;	/* for rx */
+		u32 send_bytes;		/* for tx */
+	};
+
 	u32 length;     /* length of the buffer */
 
 	u16 reuse_flag;
-- 
2.7.4

