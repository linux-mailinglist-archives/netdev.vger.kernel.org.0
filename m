Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20682601E5
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731157AbgIGROT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 13:14:19 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11249 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729636AbgIGOO4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 10:14:56 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C94C9136E6560B3A4875;
        Mon,  7 Sep 2020 22:14:18 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Mon, 7 Sep 2020 22:14:08 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net] hinic: fix rewaking txq after netif_tx_disable
Date:   Mon, 7 Sep 2020 22:15:16 +0800
Message-ID: <20200907141516.16817-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling hinic_close in hinic_set_channels, all queues are
stopped after netif_tx_disable, but some queue may be rewaken in
free_tx_poll by mistake while drv is handling tx irq. If one queue
is rewaken core may call hinic_xmit_frame to send pkt after
netif_tx_disable within a short time which may results in accessing
memory that has been already freed in hinic_close. So we judge
whether the netdev is in down state before waking txq in free_tx_poll
to fix this bug.

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index a97498ee6914..6eac6bdf164e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -718,7 +718,8 @@ static int free_tx_poll(struct napi_struct *napi, int budget)
 
 		__netif_tx_lock(netdev_txq, smp_processor_id());
 
-		netif_wake_subqueue(nic_dev->netdev, qp->q_id);
+		if (nic_dev->flags & HINIC_INTF_UP)
+			netif_wake_subqueue(nic_dev->netdev, qp->q_id);
 
 		__netif_tx_unlock(netdev_txq);
 
-- 
2.17.1

