Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6CE7DD741
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 10:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbfJSID2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 04:03:28 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33790 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727146AbfJSID2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Oct 2019 04:03:28 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D8B7910AD808497FE72E;
        Sat, 19 Oct 2019 16:03:25 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Sat, 19 Oct 2019 16:03:15 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/8] net: hns3: minor optimization for barrier in IO path
Date:   Sat, 19 Oct 2019 16:03:51 +0800
Message-ID: <1571472236-17401-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571472236-17401-1-git-send-email-tanhuazhong@huawei.com>
References: <1571472236-17401-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

Currently, the TX and RX ring in a queue is bounded to the
same IRQ, there may be unnecessary barrier op when only one of
the ring need to be processed.

This patch adjusts the location of rmb() in hns3_clean_tx_ring()
and adds a checking in hns3_clean_rx_ring() to avoid unnecessary
barrier op when there is nothing to do for the ring.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 635bdda..089cd58 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2485,11 +2485,12 @@ void hns3_clean_tx_ring(struct hns3_enet_ring *ring)
 	int head;
 
 	head = readl_relaxed(ring->tqp->io_base + HNS3_RING_TX_RING_HEAD_REG);
-	rmb(); /* Make sure head is ready before touch any data */
 
 	if (is_ring_empty(ring) || head == ring->next_to_clean)
 		return; /* no data to poll */
 
+	rmb(); /* Make sure head is ready before touch any data */
+
 	if (unlikely(!is_valid_clean_head(ring, head))) {
 		netdev_err(netdev, "wrong head (%d, %d-%d)\n", head,
 			   ring->next_to_use, ring->next_to_clean);
@@ -3105,11 +3106,14 @@ int hns3_clean_rx_ring(struct hns3_enet_ring *ring, int budget,
 	int err, num;
 
 	num = readl_relaxed(ring->tqp->io_base + HNS3_RING_RX_RING_FBDNUM_REG);
-	rmb(); /* Make sure num taken effect before the other data is touched */
-
 	num -= unused_count;
 	unused_count -= ring->pending_buf;
 
+	if (num <= 0)
+		goto out;
+
+	rmb(); /* Make sure num taken effect before the other data is touched */
+
 	while (recv_pkts < budget && recv_bds < num) {
 		/* Reuse or realloc buffers */
 		if (unused_count >= RCB_NOF_ALLOC_RX_BUFF_ONCE) {
-- 
2.7.4

