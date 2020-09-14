Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFFD2269398
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgINRhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:37:04 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11842 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726415AbgINM1S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 08:27:18 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id F229487B0A614F5AF26E;
        Mon, 14 Sep 2020 20:09:33 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Mon, 14 Sep 2020 20:09:23 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 4/6] net: hns3: optimize the rx clean process
Date:   Mon, 14 Sep 2020 20:06:55 +0800
Message-ID: <1600085217-26245-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600085217-26245-1-git-send-email-tanhuazhong@huawei.com>
References: <1600085217-26245-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

Currently HNS3_RING_RX_RING_FBDNUM_REG register is read to determine
how many rx desc can be cleaned. To avoid the register read operation
in the critical data path, use the valid bit in the rx desc to determine
if a specific rx desc can be cleaned.

The hns3 driver clear valid bit in the rx desc before notifying the
rx desc to the hw, and hw will only set the valid bit of the rx desc
after corresponding buffer is filled with packet data and other field
in the rx desc is set accordingly.

Add hns3_rx_ring_move_fw() function to clear the valid bit in the rx
desc before moving rx ring's next_to_clean forward to avoid double
cleaning a rx desc, also add a dma_rmb() barrier in hns3_handle_rx_bd()
to make sure valid bit is set before reading other field in the rx desc.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 61 +++++++++++++------------
 1 file changed, 31 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 2db6c03..8490754 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2845,6 +2845,16 @@ static bool hns3_parse_vlan_tag(struct hns3_enet_ring *ring,
 	}
 }
 
+static void hns3_rx_ring_move_fw(struct hns3_enet_ring *ring)
+{
+	ring->desc[ring->next_to_clean].rx.bd_base_info &=
+		cpu_to_le32(~BIT(HNS3_RXD_VLD_B));
+	ring->next_to_clean += 1;
+
+	if (unlikely(ring->next_to_clean == ring->desc_num))
+		ring->next_to_clean = 0;
+}
+
 static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
 			  unsigned char *va)
 {
@@ -2880,7 +2890,7 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
 			__page_frag_cache_drain(desc_cb->priv,
 						desc_cb->pagecnt_bias);
 
-		ring_ptr_move_fw(ring, next_to_clean);
+		hns3_rx_ring_move_fw(ring);
 		return 0;
 	}
 	u64_stats_update_begin(&ring->syncp);
@@ -2891,7 +2901,7 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
 	__skb_put(skb, ring->pull_len);
 	hns3_nic_reuse_page(skb, ring->frag_num++, ring, ring->pull_len,
 			    desc_cb);
-	ring_ptr_move_fw(ring, next_to_clean);
+	hns3_rx_ring_move_fw(ring);
 
 	return 0;
 }
@@ -2946,7 +2956,7 @@ static int hns3_add_frag(struct hns3_enet_ring *ring)
 
 		hns3_nic_reuse_page(skb, ring->frag_num++, ring, 0, desc_cb);
 		trace_hns3_rx_desc(ring);
-		ring_ptr_move_fw(ring, next_to_clean);
+		hns3_rx_ring_move_fw(ring);
 		ring->pending_buf++;
 	} while (!(bd_base_info & BIT(HNS3_RXD_FE_B)));
 
@@ -3088,32 +3098,32 @@ static int hns3_handle_rx_bd(struct hns3_enet_ring *ring)
 
 	prefetch(desc);
 
-	length = le16_to_cpu(desc->rx.size);
-	bd_base_info = le32_to_cpu(desc->rx.bd_base_info);
+	if (!skb) {
+		bd_base_info = le32_to_cpu(desc->rx.bd_base_info);
+
+		/* Check valid BD */
+		if (unlikely(!(bd_base_info & BIT(HNS3_RXD_VLD_B))))
+			return -ENXIO;
 
-	/* Check valid BD */
-	if (unlikely(!(bd_base_info & BIT(HNS3_RXD_VLD_B))))
-		return -ENXIO;
+		dma_rmb();
+		length = le16_to_cpu(desc->rx.size);
 
-	if (!skb) {
 		ring->va = desc_cb->buf + desc_cb->page_offset;
 
 		dma_sync_single_for_cpu(ring_to_dev(ring),
 				desc_cb->dma + desc_cb->page_offset,
 				hns3_buf_size(ring),
 				DMA_FROM_DEVICE);
-	}
 
-	/* Prefetch first cache line of first page
-	 * Idea is to cache few bytes of the header of the packet. Our L1 Cache
-	 * line size is 64B so need to prefetch twice to make it 128B. But in
-	 * actual we can have greater size of caches with 128B Level 1 cache
-	 * lines. In such a case, single fetch would suffice to cache in the
-	 * relevant part of the header.
-	 */
-	net_prefetch(ring->va);
+		/* Prefetch first cache line of first page.
+		 * Idea is to cache few bytes of the header of the packet.
+		 * Our L1 Cache line size is 64B so need to prefetch twice to make
+		 * it 128B. But in actual we can have greater size of caches with
+		 * 128B Level 1 cache lines. In such a case, single fetch would
+		 * suffice to cache in the relevant part of the header.
+		 */
+		net_prefetch(ring->va);
 
-	if (!skb) {
 		ret = hns3_alloc_skb(ring, length, ring->va);
 		skb = ring->skb;
 
@@ -3153,19 +3163,11 @@ int hns3_clean_rx_ring(struct hns3_enet_ring *ring, int budget,
 #define RCB_NOF_ALLOC_RX_BUFF_ONCE 16
 	int unused_count = hns3_desc_unused(ring);
 	int recv_pkts = 0;
-	int recv_bds = 0;
-	int err, num;
+	int err;
 
-	num = readl_relaxed(ring->tqp->io_base + HNS3_RING_RX_RING_FBDNUM_REG);
-	num -= unused_count;
 	unused_count -= ring->pending_buf;
 
-	if (num <= 0)
-		goto out;
-
-	rmb(); /* Make sure num taken effect before the other data is touched */
-
-	while (recv_pkts < budget && recv_bds < num) {
+	while (recv_pkts < budget) {
 		/* Reuse or realloc buffers */
 		if (unused_count >= RCB_NOF_ALLOC_RX_BUFF_ONCE) {
 			hns3_nic_alloc_rx_buffers(ring, unused_count);
@@ -3183,7 +3185,6 @@ int hns3_clean_rx_ring(struct hns3_enet_ring *ring, int budget,
 			recv_pkts++;
 		}
 
-		recv_bds += ring->pending_buf;
 		unused_count += ring->pending_buf;
 		ring->skb = NULL;
 		ring->pending_buf = 0;
-- 
2.7.4

