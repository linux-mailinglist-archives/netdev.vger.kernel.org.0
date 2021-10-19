Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A0743384B
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 16:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbhJSOXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 10:23:15 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:25170 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhJSOXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 10:23:08 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HYbTR3W9xz1DHCx;
        Tue, 19 Oct 2021 22:19:07 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 19 Oct 2021 22:20:52 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 19 Oct 2021 22:20:52 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 5/8] net: hns3: fix for miscalculation of rx unused desc
Date:   Tue, 19 Oct 2021 22:16:32 +0800
Message-ID: <20211019141635.43695-6-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211019141635.43695-1-huangguangbin2@huawei.com>
References: <20211019141635.43695-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

rx unused desc is the desc that need attatching new buffer
before refilling to hw to receive new packet, the number of
desc need attatching new buffer is calculated using next_to_use
and next_to_clean. when next_to_use == next_to_clean, currently
hns3 driver assumes that all the desc has the buffer attatched,
but 'next_to_use == next_to_clean' also means all the desc need
attatching new buffer if hw has comsumed all the desc and the
driver has not attatched any buffer to the desc yet.

This patch adds 'refill' in desc_cb to indicate whether a new
buffer has been refilled to a desc.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 8 ++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index ea89772e8952..2ecc9abc02d6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3255,6 +3255,7 @@ static void hns3_buffer_detach(struct hns3_enet_ring *ring, int i)
 {
 	hns3_unmap_buffer(ring, &ring->desc_cb[i]);
 	ring->desc[i].addr = 0;
+	ring->desc_cb[i].refill = 0;
 }
 
 static void hns3_free_buffer_detach(struct hns3_enet_ring *ring, int i,
@@ -3333,6 +3334,7 @@ static int hns3_alloc_and_attach_buffer(struct hns3_enet_ring *ring, int i)
 
 	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma +
 					 ring->desc_cb[i].page_offset);
+	ring->desc_cb[i].refill = 1;
 
 	return 0;
 }
@@ -3362,6 +3364,7 @@ static void hns3_replace_buffer(struct hns3_enet_ring *ring, int i,
 {
 	hns3_unmap_buffer(ring, &ring->desc_cb[i]);
 	ring->desc_cb[i] = *res_cb;
+	ring->desc_cb[i].refill = 1;
 	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma +
 					 ring->desc_cb[i].page_offset);
 	ring->desc[i].rx.bd_base_info = 0;
@@ -3370,6 +3373,7 @@ static void hns3_replace_buffer(struct hns3_enet_ring *ring, int i,
 static void hns3_reuse_buffer(struct hns3_enet_ring *ring, int i)
 {
 	ring->desc_cb[i].reuse_flag = 0;
+	ring->desc_cb[i].refill = 1;
 	ring->desc[i].addr = cpu_to_le64(ring->desc_cb[i].dma +
 					 ring->desc_cb[i].page_offset);
 	ring->desc[i].rx.bd_base_info = 0;
@@ -3476,6 +3480,9 @@ static int hns3_desc_unused(struct hns3_enet_ring *ring)
 	int ntc = ring->next_to_clean;
 	int ntu = ring->next_to_use;
 
+	if (unlikely(ntc == ntu && !ring->desc_cb[ntc].refill))
+		return ring->desc_num;
+
 	return ((ntc >= ntu) ? 0 : ring->desc_num) + ntc - ntu;
 }
 
@@ -3821,6 +3828,7 @@ static void hns3_rx_ring_move_fw(struct hns3_enet_ring *ring)
 {
 	ring->desc[ring->next_to_clean].rx.bd_base_info &=
 		cpu_to_le32(~BIT(HNS3_RXD_VLD_B));
+	ring->desc_cb[ring->next_to_clean].refill = 0;
 	ring->next_to_clean += 1;
 
 	if (unlikely(ring->next_to_clean == ring->desc_num))
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 9d9be3665bb1..f09a61d9c626 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -330,6 +330,7 @@ struct hns3_desc_cb {
 	u32 length;     /* length of the buffer */
 
 	u16 reuse_flag;
+	u16 refill;
 
 	/* desc type, used by the ring user to mark the type of the priv data */
 	u16 type;
-- 
2.33.0

