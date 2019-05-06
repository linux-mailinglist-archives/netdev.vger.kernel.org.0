Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11712143A2
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 04:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfEFCvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 22:51:43 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:46890 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726156AbfEFCuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 22:50:20 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C426A8DC97BF788801BE;
        Mon,  6 May 2019 10:50:18 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Mon, 6 May 2019 10:50:12 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <nhorman@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 09/12] net: hns3: optimize the barrier using when cleaning TX BD
Date:   Mon, 6 May 2019 10:48:49 +0800
Message-ID: <1557110932-683-10-git-send-email-tanhuazhong@huawei.com>
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

Currently, a barrier is used when cleaning each TX BD, which may
cause performance degradation.

This patch optimizes it to use one barrier when cleaning TX BD
each round.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 29 +++++++++++++------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 21eac68..25d607c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2186,20 +2186,25 @@ static void hns3_reuse_buffer(struct hns3_enet_ring *ring, int i)
 	ring->desc[i].rx.bd_base_info = 0;
 }
 
-static void hns3_nic_reclaim_one_desc(struct hns3_enet_ring *ring, int *bytes,
-				      int *pkts)
+static void hns3_nic_reclaim_desc(struct hns3_enet_ring *ring, int head,
+				  int *bytes, int *pkts)
 {
 	int ntc = ring->next_to_clean;
 	struct hns3_desc_cb *desc_cb;
 
-	desc_cb = &ring->desc_cb[ntc];
-	(*pkts) += (desc_cb->type == DESC_TYPE_SKB);
-	(*bytes) += desc_cb->length;
-	/* desc_cb will be cleaned, after hnae3_free_buffer_detach*/
-	hns3_free_buffer_detach(ring, ntc);
+	while (head != ntc) {
+		desc_cb = &ring->desc_cb[ntc];
+		(*pkts) += (desc_cb->type == DESC_TYPE_SKB);
+		(*bytes) += desc_cb->length;
+		/* desc_cb will be cleaned, after hnae3_free_buffer_detach */
+		hns3_free_buffer_detach(ring, ntc);
 
-	if (++ntc == ring->desc_num)
-		ntc = 0;
+		if (++ntc == ring->desc_num)
+			ntc = 0;
+
+		/* Issue prefetch for next Tx descriptor */
+		prefetch(&ring->desc_cb[ntc]);
+	}
 
 	/* This smp_store_release() pairs with smp_load_acquire() in
 	 * ring_space called by hns3_nic_net_xmit.
@@ -2244,11 +2249,7 @@ void hns3_clean_tx_ring(struct hns3_enet_ring *ring)
 
 	bytes = 0;
 	pkts = 0;
-	while (head != ring->next_to_clean) {
-		hns3_nic_reclaim_one_desc(ring, &bytes, &pkts);
-		/* Issue prefetch for next Tx descriptor */
-		prefetch(&ring->desc_cb[ring->next_to_clean]);
-	}
+	hns3_nic_reclaim_desc(ring, head, &bytes, &pkts);
 
 	ring->tqp_vector->tx_group.total_bytes += bytes;
 	ring->tqp_vector->tx_group.total_packets += pkts;
-- 
2.7.4

