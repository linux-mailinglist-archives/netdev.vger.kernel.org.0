Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB01B40D360
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 08:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234532AbhIPGrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 02:47:31 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9738 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbhIPGra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 02:47:30 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H96yn48lGzW6mt;
        Thu, 16 Sep 2021 14:45:05 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (7.185.36.10) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 16 Sep 2021 14:46:07 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 16 Sep 2021 14:46:07 +0800
From:   Yufeng Mo <moyufeng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <shenjian15@huawei.com>,
        <lipeng321@huawei.com>, <yisen.zhuang@huawei.com>,
        <linyunsheng@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>, <salil.mehta@huawei.com>,
        <moyufeng@huawei.com>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>
Subject: [RFC PATCH net-next] net: hns3: add dql info when tx timeout
Date:   Thu, 16 Sep 2021 14:42:03 +0800
Message-ID: <20210916064203.24614-1-moyufeng@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When tx timeout occurs, the info of dql maybe helpful, so print
these info to hns3_get_tx_timeo_queue_info().

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 22af3d6ce178..d590f920ffee 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2677,6 +2677,13 @@ static bool hns3_get_tx_timeo_queue_info(struct net_device *ndev)
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

