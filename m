Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2DBCF060
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 03:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbfJHBXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 21:23:03 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:52926 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729307AbfJHBWz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 21:22:55 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 38AC99F868F984062584;
        Tue,  8 Oct 2019 09:22:51 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Tue, 8 Oct 2019 09:22:44 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>
Subject: [PATCH net-next 6/6] net: hns3: support tx-scatter-gather-fraglist feature
Date:   Tue, 8 Oct 2019 09:20:09 +0800
Message-ID: <1570497609-36349-7-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1570497609-36349-1-git-send-email-tanhuazhong@huawei.com>
References: <1570497609-36349-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

The hardware supports up to 8 TX BD for non-tso skb and up to
63 TX BD for TSO skb. Currently, the hns3 driver supports RX skb
with fraglist when HW GRO is enabled, when the stack forwards a
RX skb with fraglist, the stack need to linearize the skb before
sending to other interface without TX fraglist support.

This patch adds support for TX fraglist. The performance increases
from 1 GByte to 1.5 GByte for one iperf TCP stream during
forwarding test after this patch. BTW, the minimum BD number of
ring should be updated to 72 for supporting TX fraglist.

This patch also changes the error handling of some function that
called by hns3_fill_desc, which returns BD num when there is no
error, change some macro to more meaningful name.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 249 +++++++++++++++---------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h |  12 +-
 2 files changed, 168 insertions(+), 93 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 4e304b4..6e0b261 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -681,7 +681,7 @@ static int hns3_set_tso(struct sk_buff *skb, u32 *paylen,
 		return 0;
 
 	ret = skb_cow_head(skb, 0);
-	if (unlikely(ret))
+	if (unlikely(ret < 0))
 		return ret;
 
 	l3.hdr = skb_network_header(skb);
@@ -962,14 +962,6 @@ static int hns3_set_l2l3l4(struct sk_buff *skb, u8 ol4_proto,
 	return 0;
 }
 
-static void hns3_set_txbd_baseinfo(u16 *bdtp_fe_sc_vld_ra_ri, int frag_end)
-{
-	/* Config bd buffer end */
-	if (!!frag_end)
-		hns3_set_field(*bdtp_fe_sc_vld_ra_ri, HNS3_TXD_FE_B, 1U);
-	hns3_set_field(*bdtp_fe_sc_vld_ra_ri, HNS3_TXD_VLD_B, 1U);
-}
-
 static int hns3_handle_vtags(struct hns3_enet_ring *tx_ring,
 			     struct sk_buff *skb)
 {
@@ -1062,7 +1054,7 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 		skb_reset_mac_len(skb);
 
 		ret = hns3_get_l4_protocol(skb, &ol4_proto, &il4_proto);
-		if (unlikely(ret)) {
+		if (unlikely(ret < 0)) {
 			u64_stats_update_begin(&ring->syncp);
 			ring->stats.tx_l4_proto_err++;
 			u64_stats_update_end(&ring->syncp);
@@ -1072,7 +1064,7 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 		ret = hns3_set_l2l3l4(skb, ol4_proto, il4_proto,
 				      &type_cs_vlan_tso,
 				      &ol_type_vlan_len_msec);
-		if (unlikely(ret)) {
+		if (unlikely(ret < 0)) {
 			u64_stats_update_begin(&ring->syncp);
 			ring->stats.tx_l2l3l4_err++;
 			u64_stats_update_end(&ring->syncp);
@@ -1081,7 +1073,7 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 
 		ret = hns3_set_tso(skb, &paylen, &mss,
 				   &type_cs_vlan_tso);
-		if (unlikely(ret)) {
+		if (unlikely(ret < 0)) {
 			u64_stats_update_begin(&ring->syncp);
 			ring->stats.tx_tso_err++;
 			u64_stats_update_end(&ring->syncp);
@@ -1102,9 +1094,10 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 }
 
 static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
-			  unsigned int size, int frag_end,
-			  enum hns_desc_type type)
+			  unsigned int size, enum hns_desc_type type)
 {
+#define HNS3_LIKELY_BD_NUM	1
+
 	struct hns3_desc_cb *desc_cb = &ring->desc_cb[ring->next_to_use];
 	struct hns3_desc *desc = &ring->desc[ring->next_to_use];
 	struct device *dev = ring_to_dev(ring);
@@ -1118,7 +1111,7 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 		int ret;
 
 		ret = hns3_fill_skb_desc(ring, skb, desc);
-		if (unlikely(ret))
+		if (unlikely(ret < 0))
 			return ret;
 
 		dma = dma_map_single(dev, skb->data, size, DMA_TO_DEVICE);
@@ -1137,19 +1130,16 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 	desc_cb->length = size;
 
 	if (likely(size <= HNS3_MAX_BD_SIZE)) {
-		u16 bdtp_fe_sc_vld_ra_ri = 0;
-
 		desc_cb->priv = priv;
 		desc_cb->dma = dma;
 		desc_cb->type = type;
 		desc->addr = cpu_to_le64(dma);
 		desc->tx.send_size = cpu_to_le16(size);
-		hns3_set_txbd_baseinfo(&bdtp_fe_sc_vld_ra_ri, frag_end);
 		desc->tx.bdtp_fe_sc_vld_ra_ri =
-			cpu_to_le16(bdtp_fe_sc_vld_ra_ri);
+			cpu_to_le16(BIT(HNS3_TXD_VLD_B));
 
 		ring_ptr_move_fw(ring, next_to_use);
-		return 0;
+		return HNS3_LIKELY_BD_NUM;
 	}
 
 	frag_buf_num = hns3_tx_bd_count(size);
@@ -1158,8 +1148,6 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 
 	/* When frag size is bigger than hardware limit, split this frag */
 	for (k = 0; k < frag_buf_num; k++) {
-		u16 bdtp_fe_sc_vld_ra_ri = 0;
-
 		/* The txbd's baseinfo of DESC_TYPE_PAGE & DESC_TYPE_SKB */
 		desc_cb->priv = priv;
 		desc_cb->dma = dma + HNS3_MAX_BD_SIZE * k;
@@ -1170,11 +1158,8 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 		desc->addr = cpu_to_le64(dma + HNS3_MAX_BD_SIZE * k);
 		desc->tx.send_size = cpu_to_le16((k == frag_buf_num - 1) ?
 				     (u16)sizeoflast : (u16)HNS3_MAX_BD_SIZE);
-		hns3_set_txbd_baseinfo(&bdtp_fe_sc_vld_ra_ri,
-				       frag_end && (k == frag_buf_num - 1) ?
-						1 : 0);
 		desc->tx.bdtp_fe_sc_vld_ra_ri =
-				cpu_to_le16(bdtp_fe_sc_vld_ra_ri);
+				cpu_to_le16(BIT(HNS3_TXD_VLD_B));
 
 		/* move ring pointer to next */
 		ring_ptr_move_fw(ring, next_to_use);
@@ -1183,23 +1168,78 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 		desc = &ring->desc[ring->next_to_use];
 	}
 
-	return 0;
+	return frag_buf_num;
 }
 
-static unsigned int hns3_nic_bd_num(struct sk_buff *skb)
+static unsigned int hns3_skb_bd_num(struct sk_buff *skb, unsigned int *bd_size,
+				    unsigned int bd_num)
 {
-	unsigned int bd_num;
+	unsigned int size;
 	int i;
 
-	/* if the total len is within the max bd limit */
-	if (likely(skb->len <= HNS3_MAX_BD_SIZE))
-		return skb_shinfo(skb)->nr_frags + 1;
+	size = skb_headlen(skb);
+	while (size > HNS3_MAX_BD_SIZE) {
+		bd_size[bd_num++] = HNS3_MAX_BD_SIZE;
+		size -= HNS3_MAX_BD_SIZE;
+
+		if (bd_num > HNS3_MAX_TSO_BD_NUM)
+			return bd_num;
+	}
 
-	bd_num = hns3_tx_bd_count(skb_headlen(skb));
+	if (size) {
+		bd_size[bd_num++] = size;
+		if (bd_num > HNS3_MAX_TSO_BD_NUM)
+			return bd_num;
+	}
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-		bd_num += hns3_tx_bd_count(skb_frag_size(frag));
+		size = skb_frag_size(frag);
+		if (!size)
+			continue;
+
+		while (size > HNS3_MAX_BD_SIZE) {
+			bd_size[bd_num++] = HNS3_MAX_BD_SIZE;
+			size -= HNS3_MAX_BD_SIZE;
+
+			if (bd_num > HNS3_MAX_TSO_BD_NUM)
+				return bd_num;
+		}
+
+		bd_size[bd_num++] = size;
+		if (bd_num > HNS3_MAX_TSO_BD_NUM)
+			return bd_num;
+	}
+
+	return bd_num;
+}
+
+static unsigned int hns3_tx_bd_num(struct sk_buff *skb, unsigned int *bd_size)
+{
+	struct sk_buff *frag_skb;
+	unsigned int bd_num = 0;
+
+	/* If the total len is within the max bd limit */
+	if (likely(skb->len <= HNS3_MAX_BD_SIZE && !skb_has_frag_list(skb) &&
+		   skb_shinfo(skb)->nr_frags < HNS3_MAX_NON_TSO_BD_NUM))
+		return skb_shinfo(skb)->nr_frags + 1U;
+
+	/* The below case will always be linearized, return
+	 * HNS3_MAX_BD_NUM_TSO + 1U to make sure it is linearized.
+	 */
+	if (unlikely(skb->len > HNS3_MAX_TSO_SIZE ||
+		     (!skb_is_gso(skb) && skb->len > HNS3_MAX_NON_TSO_SIZE)))
+		return HNS3_MAX_TSO_BD_NUM + 1U;
+
+	bd_num = hns3_skb_bd_num(skb, bd_size, bd_num);
+
+	if (!skb_has_frag_list(skb) || bd_num > HNS3_MAX_TSO_BD_NUM)
+		return bd_num;
+
+	skb_walk_frags(skb, frag_skb) {
+		bd_num = hns3_skb_bd_num(frag_skb, bd_size, bd_num);
+		if (bd_num > HNS3_MAX_TSO_BD_NUM)
+			return bd_num;
 	}
 
 	return bd_num;
@@ -1218,26 +1258,26 @@ static unsigned int hns3_gso_hdr_len(struct sk_buff *skb)
  * 7 frags to to be larger than gso header len + mss, and the remaining
  * continuous 7 frags to be larger than MSS except the last 7 frags.
  */
-static bool hns3_skb_need_linearized(struct sk_buff *skb)
+static bool hns3_skb_need_linearized(struct sk_buff *skb, unsigned int *bd_size,
+				     unsigned int bd_num)
 {
-	int bd_limit = HNS3_MAX_BD_NUM_NORMAL - 1;
 	unsigned int tot_len = 0;
 	int i;
 
-	for (i = 0; i < bd_limit; i++)
-		tot_len += skb_frag_size(&skb_shinfo(skb)->frags[i]);
+	for (i = 0; i < HNS3_MAX_NON_TSO_BD_NUM - 1U; i++)
+		tot_len += bd_size[i];
 
-	/* ensure headlen + the first 7 frags is greater than mss + header
-	 * and the first 7 frags is greater than mss.
-	 */
-	if (((tot_len + skb_headlen(skb)) < (skb_shinfo(skb)->gso_size +
-	    hns3_gso_hdr_len(skb))) || (tot_len < skb_shinfo(skb)->gso_size))
+	/* ensure the first 8 frags is greater than mss + header */
+	if (tot_len + bd_size[HNS3_MAX_NON_TSO_BD_NUM - 1U] <
+	    skb_shinfo(skb)->gso_size + hns3_gso_hdr_len(skb))
 		return true;
 
-	/* ensure the remaining continuous 7 buffer is greater than mss */
-	for (i = 0; i < (skb_shinfo(skb)->nr_frags - bd_limit - 1); i++) {
-		tot_len -= skb_frag_size(&skb_shinfo(skb)->frags[i]);
-		tot_len += skb_frag_size(&skb_shinfo(skb)->frags[i + bd_limit]);
+	/* ensure every continuous 7 buffer is greater than mss
+	 * except the last one.
+	 */
+	for (i = 0; i < bd_num - HNS3_MAX_NON_TSO_BD_NUM; i++) {
+		tot_len -= bd_size[i];
+		tot_len += bd_size[i + HNS3_MAX_NON_TSO_BD_NUM - 1U];
 
 		if (tot_len < skb_shinfo(skb)->gso_size)
 			return true;
@@ -1249,15 +1289,16 @@ static bool hns3_skb_need_linearized(struct sk_buff *skb)
 static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 				  struct sk_buff **out_skb)
 {
+	unsigned int bd_size[HNS3_MAX_TSO_BD_NUM + 1U];
 	struct sk_buff *skb = *out_skb;
 	unsigned int bd_num;
 
-	bd_num = hns3_nic_bd_num(skb);
-	if (unlikely(bd_num > HNS3_MAX_BD_NUM_NORMAL)) {
+	bd_num = hns3_tx_bd_num(skb, bd_size);
+	if (unlikely(bd_num > HNS3_MAX_NON_TSO_BD_NUM)) {
 		struct sk_buff *new_skb;
 
-		if (skb_is_gso(skb) && bd_num <= HNS3_MAX_BD_NUM_TSO &&
-		    !hns3_skb_need_linearized(skb))
+		if (bd_num <= HNS3_MAX_TSO_BD_NUM && skb_is_gso(skb) &&
+		    !hns3_skb_need_linearized(skb, bd_size, bd_num))
 			goto out;
 
 		/* manual split the send packet */
@@ -1267,9 +1308,10 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 		dev_kfree_skb_any(skb);
 		*out_skb = new_skb;
 
-		bd_num = hns3_nic_bd_num(new_skb);
-		if ((skb_is_gso(new_skb) && bd_num > HNS3_MAX_BD_NUM_TSO) ||
-		    (!skb_is_gso(new_skb) && bd_num > HNS3_MAX_BD_NUM_NORMAL))
+		bd_num = hns3_tx_bd_count(new_skb->len);
+		if ((skb_is_gso(new_skb) && bd_num > HNS3_MAX_TSO_BD_NUM) ||
+		    (!skb_is_gso(new_skb) &&
+		     bd_num > HNS3_MAX_NON_TSO_BD_NUM))
 			return -ENOMEM;
 
 		u64_stats_update_begin(&ring->syncp);
@@ -1314,6 +1356,37 @@ static void hns3_clear_desc(struct hns3_enet_ring *ring, int next_to_use_orig)
 	}
 }
 
+static int hns3_fill_skb_to_desc(struct hns3_enet_ring *ring,
+				 struct sk_buff *skb, enum hns_desc_type type)
+{
+	unsigned int size = skb_headlen(skb);
+	int i, ret, bd_num = 0;
+
+	if (size) {
+		ret = hns3_fill_desc(ring, skb, size, type);
+		if (unlikely(ret < 0))
+			return ret;
+
+		bd_num += ret;
+	}
+
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
+
+		size = skb_frag_size(frag);
+		if (!size)
+			continue;
+
+		ret = hns3_fill_desc(ring, frag, size, DESC_TYPE_PAGE);
+		if (unlikely(ret < 0))
+			return ret;
+
+		bd_num += ret;
+	}
+
+	return bd_num;
+}
+
 netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
@@ -1321,58 +1394,54 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 		&tx_ring_data(priv, skb->queue_mapping);
 	struct hns3_enet_ring *ring = ring_data->ring;
 	struct netdev_queue *dev_queue;
-	skb_frag_t *frag;
-	int next_to_use_head;
-	int buf_num;
-	int seg_num;
-	int size;
+	int pre_ntu, next_to_use_head;
+	struct sk_buff *frag_skb;
+	int bd_num = 0;
 	int ret;
-	int i;
 
 	/* Prefetch the data used later */
 	prefetch(skb->data);
 
-	buf_num = hns3_nic_maybe_stop_tx(ring, &skb);
-	if (unlikely(buf_num <= 0)) {
-		if (buf_num == -EBUSY) {
+	ret = hns3_nic_maybe_stop_tx(ring, &skb);
+	if (unlikely(ret <= 0)) {
+		if (ret == -EBUSY) {
 			u64_stats_update_begin(&ring->syncp);
 			ring->stats.tx_busy++;
 			u64_stats_update_end(&ring->syncp);
 			goto out_net_tx_busy;
-		} else if (buf_num == -ENOMEM) {
+		} else if (ret == -ENOMEM) {
 			u64_stats_update_begin(&ring->syncp);
 			ring->stats.sw_err_cnt++;
 			u64_stats_update_end(&ring->syncp);
 		}
 
-		hns3_rl_err(netdev, "xmit error: %d!\n", buf_num);
+		hns3_rl_err(netdev, "xmit error: %d!\n", ret);
 		goto out_err_tx_ok;
 	}
 
-	/* No. of segments (plus a header) */
-	seg_num = skb_shinfo(skb)->nr_frags + 1;
-	/* Fill the first part */
-	size = skb_headlen(skb);
-
 	next_to_use_head = ring->next_to_use;
 
-	ret = hns3_fill_desc(ring, skb, size, seg_num == 1 ? 1 : 0,
-			     DESC_TYPE_SKB);
-	if (unlikely(ret))
+	ret = hns3_fill_skb_to_desc(ring, skb, DESC_TYPE_SKB);
+	if (unlikely(ret < 0))
 		goto fill_err;
 
-	/* Fill the fragments */
-	for (i = 1; i < seg_num; i++) {
-		frag = &skb_shinfo(skb)->frags[i - 1];
-		size = skb_frag_size(frag);
+	bd_num += ret;
 
-		ret = hns3_fill_desc(ring, frag, size,
-				     seg_num - 1 == i ? 1 : 0,
-				     DESC_TYPE_PAGE);
+	if (!skb_has_frag_list(skb))
+		goto out;
 
-		if (unlikely(ret))
+	skb_walk_frags(skb, frag_skb) {
+		ret = hns3_fill_skb_to_desc(ring, frag_skb, DESC_TYPE_PAGE);
+		if (unlikely(ret < 0))
 			goto fill_err;
+
+		bd_num += ret;
 	}
+out:
+	pre_ntu = ring->next_to_use ? (ring->next_to_use - 1) :
+					(ring->desc_num - 1);
+	ring->desc[pre_ntu].tx.bdtp_fe_sc_vld_ra_ri |=
+				cpu_to_le16(BIT(HNS3_TXD_FE_B));
 
 	/* Complete translate all packets */
 	dev_queue = netdev_get_tx_queue(netdev, ring_data->queue_index);
@@ -1380,7 +1449,7 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	wmb(); /* Commit all data before submit */
 
-	hnae3_queue_xmit(ring->tqp, buf_num);
+	hnae3_queue_xmit(ring->tqp, bd_num);
 
 	return NETDEV_TX_OK;
 
@@ -2158,9 +2227,8 @@ static void hns3_set_default_feature(struct net_device *netdev)
 		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
 		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
 		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
-		NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_SCTP_CRC;
-
-	netdev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
+		NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_SCTP_CRC |
+		NETIF_F_TSO_MANGLEID | NETIF_F_FRAGLIST;
 
 	netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
 
@@ -2170,21 +2238,24 @@ static void hns3_set_default_feature(struct net_device *netdev)
 		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
 		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
 		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
-		NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_SCTP_CRC;
+		NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_SCTP_CRC |
+		NETIF_F_FRAGLIST;
 
 	netdev->vlan_features |=
 		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_RXCSUM |
 		NETIF_F_SG | NETIF_F_GSO | NETIF_F_GRO |
 		NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
 		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
-		NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_SCTP_CRC;
+		NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_SCTP_CRC |
+		NETIF_F_FRAGLIST;
 
 	netdev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
 		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
 		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
 		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
-		NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_SCTP_CRC;
+		NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_SCTP_CRC |
+		NETIF_F_FRAGLIST;
 
 	if (pdev->revision >= 0x21) {
 		netdev->hw_features |= NETIF_F_GRO_HW;
@@ -2447,7 +2518,7 @@ void hns3_clean_tx_ring(struct hns3_enet_ring *ring)
 	netdev_tx_completed_queue(dev_queue, pkts, bytes);
 
 	if (unlikely(pkts && netif_carrier_ok(netdev) &&
-		     (ring_space(ring) > HNS3_MAX_BD_PER_PKT))) {
+		     ring_space(ring) > HNS3_MAX_TSO_BD_NUM)) {
 		/* Make sure that anybody stopping the queue after this
 		 * sees the new next_to_clean.
 		 */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 2110fa3..c5b7c22 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -76,7 +76,7 @@ enum hns3_nic_state {
 #define HNS3_RING_NAME_LEN			16
 #define HNS3_BUFFER_SIZE_2048			2048
 #define HNS3_RING_MAX_PENDING			32760
-#define HNS3_RING_MIN_PENDING			24
+#define HNS3_RING_MIN_PENDING			72
 #define HNS3_RING_BD_MULTIPLE			8
 /* max frame size of mac */
 #define HNS3_MAC_MAX_FRAME			9728
@@ -195,9 +195,13 @@ enum hns3_nic_state {
 #define HNS3_VECTOR_INITED			1
 
 #define HNS3_MAX_BD_SIZE			65535
-#define HNS3_MAX_BD_NUM_NORMAL			8
-#define HNS3_MAX_BD_NUM_TSO			63
-#define HNS3_MAX_BD_PER_PKT			MAX_SKB_FRAGS
+#define HNS3_MAX_NON_TSO_BD_NUM			8U
+#define HNS3_MAX_TSO_BD_NUM			63U
+#define HNS3_MAX_TSO_SIZE \
+	(HNS3_MAX_BD_SIZE * HNS3_MAX_TSO_BD_NUM)
+
+#define HNS3_MAX_NON_TSO_SIZE \
+	(HNS3_MAX_BD_SIZE * HNS3_MAX_NON_TSO_BD_NUM)
 
 #define HNS3_VECTOR_GL0_OFFSET			0x100
 #define HNS3_VECTOR_GL1_OFFSET			0x200
-- 
2.7.4

