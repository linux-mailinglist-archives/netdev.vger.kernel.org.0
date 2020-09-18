Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590B426F4EA
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 06:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgIREJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 00:09:02 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:38890 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726117AbgIREJC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 00:09:02 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BB484326D40EB9A528F6;
        Fri, 18 Sep 2020 12:08:39 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Fri, 18 Sep 2020 12:08:31 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>,
        <zengweiliang.zengweiliang@huawei.com>
Subject: [PATCH net] hinic: fix sending pkts from core while self testing
Date:   Fri, 18 Sep 2020 12:09:38 +0800
Message-ID: <20200918040938.20177-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call netif_tx_disable firstly before starting doing self-test to
avoid sending packet from networking core and self-test packet
simultaneously which may cause self-test failure or hw abnormal.

Fixes: 4aa218a4fe77 ("hinic: add self test support")
Signed-off-by: Luo bin <luobin9@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c | 4 ++++
 drivers/net/ethernet/huawei/hinic/hinic_tx.c      | 4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index 6bb65ade1d77..c340d9acba80 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -1654,6 +1654,7 @@ static void hinic_diag_test(struct net_device *netdev,
 	}
 
 	netif_carrier_off(netdev);
+	netif_tx_disable(netdev);
 
 	err = do_lp_test(nic_dev, eth_test->flags, LP_DEFAULT_TIME,
 			 &test_index);
@@ -1662,9 +1663,12 @@ static void hinic_diag_test(struct net_device *netdev,
 		data[test_index] = 1;
 	}
 
+	netif_tx_wake_all_queues(netdev);
+
 	err = hinic_port_link_state(nic_dev, &link_state);
 	if (!err && link_state == HINIC_LINK_STATE_UP)
 		netif_carrier_on(netdev);
+
 }
 
 static int hinic_set_phys_id(struct net_device *netdev,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index 2b418b568767..c1f81e9144a1 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -717,8 +717,8 @@ static int free_tx_poll(struct napi_struct *napi, int budget)
 		netdev_txq = netdev_get_tx_queue(txq->netdev, qp->q_id);
 
 		__netif_tx_lock(netdev_txq, smp_processor_id());
-
-		netif_wake_subqueue(nic_dev->netdev, qp->q_id);
+		if (!netif_testing(nic_dev->netdev))
+			netif_wake_subqueue(nic_dev->netdev, qp->q_id);
 
 		__netif_tx_unlock(netdev_txq);
 
-- 
2.17.1

