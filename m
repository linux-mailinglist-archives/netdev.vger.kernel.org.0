Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B13433851
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 16:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbhJSOXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 10:23:19 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14828 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbhJSOXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 10:23:08 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HYbPn6PyCz90L7;
        Tue, 19 Oct 2021 22:15:57 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 19 Oct 2021 22:20:53 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 19 Oct 2021 22:20:52 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 6/8] net: hns3: schedule the polling again when allocation fails
Date:   Tue, 19 Oct 2021 22:16:33 +0800
Message-ID: <20211019141635.43695-7-huangguangbin2@huawei.com>
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

Currently when there is a rx page allocation failure, it is
possible that polling may be stopped if there is no more packet
to be reveiced, which may cause queue stall problem under memory
pressure.

This patch makes sure polling is scheduled again when there is
any rx page allocation failure, and polling will try to allocate
receive buffers until it succeeds.

Now the allocation retry is added, it is unnecessary to do the rx
page allocation at the end of rx cleaning, so remove it. And reset
the unused_count to zero after calling hns3_nic_alloc_rx_buffers()
to avoid calling hns3_nic_alloc_rx_buffers() repeatedly under
memory pressure.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 22 ++++++++++---------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 2ecc9abc02d6..4b886a13e079 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3486,7 +3486,8 @@ static int hns3_desc_unused(struct hns3_enet_ring *ring)
 	return ((ntc >= ntu) ? 0 : ring->desc_num) + ntc - ntu;
 }
 
-static void hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
+/* Return true if there is any allocation failure */
+static bool hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
 				      int cleand_count)
 {
 	struct hns3_desc_cb *desc_cb;
@@ -3511,7 +3512,10 @@ static void hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
 				hns3_rl_err(ring_to_netdev(ring),
 					    "alloc rx buffer failed: %d\n",
 					    ret);
-				break;
+
+				writel(i, ring->tqp->io_base +
+				       HNS3_RING_RX_RING_HEAD_REG);
+				return true;
 			}
 			hns3_replace_buffer(ring, ring->next_to_use, &res_cbs);
 
@@ -3524,6 +3528,7 @@ static void hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
 	}
 
 	writel(i, ring->tqp->io_base + HNS3_RING_RX_RING_HEAD_REG);
+	return false;
 }
 
 static bool hns3_can_reuse_page(struct hns3_desc_cb *cb)
@@ -4175,6 +4180,7 @@ int hns3_clean_rx_ring(struct hns3_enet_ring *ring, int budget,
 {
 #define RCB_NOF_ALLOC_RX_BUFF_ONCE 16
 	int unused_count = hns3_desc_unused(ring);
+	bool failure = false;
 	int recv_pkts = 0;
 	int err;
 
@@ -4183,9 +4189,9 @@ int hns3_clean_rx_ring(struct hns3_enet_ring *ring, int budget,
 	while (recv_pkts < budget) {
 		/* Reuse or realloc buffers */
 		if (unused_count >= RCB_NOF_ALLOC_RX_BUFF_ONCE) {
-			hns3_nic_alloc_rx_buffers(ring, unused_count);
-			unused_count = hns3_desc_unused(ring) -
-					ring->pending_buf;
+			failure = failure ||
+				hns3_nic_alloc_rx_buffers(ring, unused_count);
+			unused_count = 0;
 		}
 
 		/* Poll one pkt */
@@ -4204,11 +4210,7 @@ int hns3_clean_rx_ring(struct hns3_enet_ring *ring, int budget,
 	}
 
 out:
-	/* Make all data has been write before submit */
-	if (unused_count > 0)
-		hns3_nic_alloc_rx_buffers(ring, unused_count);
-
-	return recv_pkts;
+	return failure ? budget : recv_pkts;
 }
 
 static void hns3_update_rx_int_coalesce(struct hns3_enet_tqp_vector *tqp_vector)
-- 
2.33.0

