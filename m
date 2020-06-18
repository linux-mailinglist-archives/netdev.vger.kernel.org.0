Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35F81FDAB8
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 03:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgFRBFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:05:06 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6277 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726893AbgFRBFG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:05:06 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 92C832C2A3F5508B2D0E;
        Thu, 18 Jun 2020 09:05:04 +0800 (CST)
Received: from SWX921481.china.huawei.com (10.126.203.42) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Thu, 18 Jun 2020 09:04:54 +0800
From:   Barry Song <song.bao.hua@hisilicon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <netdev@vger.kernel.org>, <linyunsheng@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>
Subject: [PATCH 5/5] net: hns3: streaming dma buffer sync between cpu and device
Date:   Thu, 18 Jun 2020 13:02:11 +1200
Message-ID: <20200618010211.75840-6-song.bao.hua@hisilicon.com>
X-Mailer: git-send-email 2.21.0.windows.1
In-Reply-To: <20200618010211.75840-1-song.bao.hua@hisilicon.com>
References: <20200618010211.75840-1-song.bao.hua@hisilicon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.126.203.42]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now they are empty functions for our SoC since hardware can keep
cache coherent, but it is still good to align with streaming DMA APIs
as device drivers should not make an assumption of SoC.

Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c    | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 1330820152fa..b319a766889f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2473,6 +2473,11 @@ static void hns3_reuse_buffer(struct hns3_enet_ring *ring, int i)
 	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma +
 					 ring->desc_cb[i].page_offset);
 	ring->desc[i].rx.bd_base_info = 0;
+
+	dma_sync_single_for_device(ring_to_dev(ring),
+			ring->desc_cb[i].dma + ring->desc_cb[i].page_offset,
+			hns3_buf_size(ring),
+			DMA_FROM_DEVICE);
 }
 
 static void hns3_nic_reclaim_desc(struct hns3_enet_ring *ring, int head,
@@ -2918,6 +2923,11 @@ static int hns3_add_frag(struct hns3_enet_ring *ring)
 			skb = ring->tail_skb;
 		}
 
+		dma_sync_single_for_cpu(ring_to_dev(ring),
+				desc_cb->dma + desc_cb->page_offset,
+				hns3_buf_size(ring),
+				DMA_FROM_DEVICE);
+
 		hns3_nic_reuse_page(skb, ring->frag_num++, ring, 0, desc_cb);
 		trace_hns3_rx_desc(ring);
 		ring_ptr_move_fw(ring, next_to_clean);
@@ -3069,9 +3079,15 @@ static int hns3_handle_rx_bd(struct hns3_enet_ring *ring)
 	if (unlikely(!(bd_base_info & BIT(HNS3_RXD_VLD_B))))
 		return -ENXIO;
 
-	if (!skb)
+	if (!skb) {
 		ring->va = desc_cb->buf + desc_cb->page_offset;
 
+		dma_sync_single_for_cpu(ring_to_dev(ring),
+				desc_cb->dma + desc_cb->page_offset,
+				hns3_buf_size(ring),
+				DMA_FROM_DEVICE);
+	}
+
 	/* Prefetch first cache line of first page
 	 * Idea is to cache few bytes of the header of the packet. Our L1 Cache
 	 * line size is 64B so need to prefetch twice to make it 128B. But in
-- 
2.23.0


