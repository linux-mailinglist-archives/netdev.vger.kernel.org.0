Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E5445B108
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 02:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbhKXBOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 20:14:45 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:28097 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbhKXBOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 20:14:41 -0500
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HzNF6521Dz1DJRJ;
        Wed, 24 Nov 2021 09:08:58 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 24 Nov 2021 09:11:30 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 24 Nov 2021 09:11:29 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 4/4] net: hns3: add dql info when tx timeout
Date:   Wed, 24 Nov 2021 09:06:54 +0800
Message-ID: <20211124010654.6753-5-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124010654.6753-1-huangguangbin2@huawei.com>
References: <20211124010654.6753-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

When tx timeout occurs, the info of dql maybe helpful, so print
these info to hns3_get_tx_timeo_queue_info().

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 0225d6091cf2..496ddf397bd4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2683,6 +2683,13 @@ static bool hns3_get_tx_timeo_queue_info(struct net_device *ndev)
 		if (netif_xmit_stopped(q) &&
 		    time_after(jiffies,
 			       (trans_start + ndev->watchdog_timeo))) {
+#ifdef CONFIG_BQL
+			struct dql *dql = &q->dql;
+
+			netdev_info(ndev, "DQL info last_cnt: %u, queued: %u, adj_limit: %u, completed: %u\n",
+				    dql->last_obj_cnt, dql->num_queued,
+				    dql->adj_limit, dql->num_completed);
+#endif
 			timeout_queue = i;
 			netdev_info(ndev, "queue state: 0x%lx, delta msecs: %u\n",
 				    q->state,
-- 
2.33.0

