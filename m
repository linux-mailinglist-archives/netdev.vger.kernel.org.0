Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237B02678C5
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 10:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbgILIKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 04:10:49 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:59278 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725809AbgILIKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Sep 2020 04:10:47 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 04CE93AEB0A555743A31;
        Sat, 12 Sep 2020 16:10:44 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Sat, 12 Sep 2020
 16:10:34 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <idos@mellanox.com>,
        <ogerlitz@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH net-next] net: ethernet: mlx4: Avoid assigning a value to ring_cons but not used it anymore in mlx4_en_xmit()
Date:   Sat, 12 Sep 2020 16:08:15 +0800
Message-ID: <1599898095-10712-1-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We found a set but not used variable 'ring_cons' in mlx4_en_xmit(), it will
cause a warning when build the kernel. And after checking the commit record
of this function, we found that it was introduced by a previous patch.

So, We delete this redundant assignment code.

Fixes: 488a9b48e398 ("net/mlx4_en: Wake TX queues only when there's enough room")

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 9dff7b0..d554344 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -1075,7 +1075,6 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 		 */
 		smp_rmb();
 
-		ring_cons = READ_ONCE(ring->cons);
 		if (unlikely(!mlx4_en_is_tx_ring_full(ring))) {
 			netif_tx_wake_queue(ring->tx_queue);
 			ring->wake_queue++;
-- 
2.7.4

