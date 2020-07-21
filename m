Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80CF4227E26
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 13:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbgGULHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 07:07:24 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7807 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727940AbgGULHF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 07:07:05 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2B62AE29E8F847C15CE8;
        Tue, 21 Jul 2020 19:07:02 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Tue, 21 Jul 2020 19:06:55 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huzhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 1/4] net: hns3: fix for not unmapping TX buffer correctly
Date:   Tue, 21 Jul 2020 19:03:51 +0800
Message-ID: <1595329434-46766-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595329434-46766-1-git-send-email-tanhuazhong@huawei.com>
References: <1595329434-46766-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

When a big TX buffer is sent using multi BD, the driver maps the
whole TX buffer, and unmaps it using info in desc_cb corresponding
to each BD, but only the info in the desc_cb of first BD is correct,
other info in desc_cb is wrong, which causes TX unmapping problem
when SMMU is on.

Only set the mapping and freeing info in the desc_cb of first BD to
fix this problem, because the TX buffer only need to be unmapped and
freed once.

Fixes: 1e8a7977d09f("net: hns3: add handling for big TX fragment")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huzhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index fe7d57ae..18f7623 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1118,12 +1118,12 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 		return -ENOMEM;
 	}
 
+	desc_cb->priv = priv;
 	desc_cb->length = size;
+	desc_cb->dma = dma;
+	desc_cb->type = type;
 
 	if (likely(size <= HNS3_MAX_BD_SIZE)) {
-		desc_cb->priv = priv;
-		desc_cb->dma = dma;
-		desc_cb->type = type;
 		desc->addr = cpu_to_le64(dma);
 		desc->tx.send_size = cpu_to_le16(size);
 		desc->tx.bdtp_fe_sc_vld_ra_ri =
@@ -1140,13 +1140,6 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 
 	/* When frag size is bigger than hardware limit, split this frag */
 	for (k = 0; k < frag_buf_num; k++) {
-		/* The txbd's baseinfo of DESC_TYPE_PAGE & DESC_TYPE_SKB */
-		desc_cb->priv = priv;
-		desc_cb->dma = dma + HNS3_MAX_BD_SIZE * k;
-		desc_cb->type = ((type == DESC_TYPE_FRAGLIST_SKB ||
-				  type == DESC_TYPE_SKB) && !k) ?
-				type : DESC_TYPE_PAGE;
-
 		/* now, fill the descriptor */
 		desc->addr = cpu_to_le64(dma + HNS3_MAX_BD_SIZE * k);
 		desc->tx.send_size = cpu_to_le16((k == frag_buf_num - 1) ?
@@ -1158,7 +1151,6 @@ static int hns3_fill_desc(struct hns3_enet_ring *ring, void *priv,
 		/* move ring pointer to next */
 		ring_ptr_move_fw(ring, next_to_use);
 
-		desc_cb = &ring->desc_cb[ring->next_to_use];
 		desc = &ring->desc[ring->next_to_use];
 	}
 
-- 
2.7.4

