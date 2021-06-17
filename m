Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741343AB28C
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 13:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbhFQL34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 07:29:56 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5025 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbhFQL34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 07:29:56 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G5KR80jC9zXgnq;
        Thu, 17 Jun 2021 19:22:44 +0800 (CST)
Received: from dggpemm500016.china.huawei.com (7.185.36.25) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 19:27:46 +0800
Received: from huawei.com (10.67.174.205) by dggpemm500016.china.huawei.com
 (7.185.36.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 17 Jun
 2021 19:27:46 +0800
From:   Chen Jiahao <chenjiahao16@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <grygorii.strashko@ti.com>, <jesse.brandeburg@intel.com>,
        <vigneshr@ti.com>, <peter.ujfalusi@ti.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <chenjiahao16@huawei.com>, <heying24@huawei.com>
Subject: [PATCH] net: ethernet: ti: fix netdev_queue compiling error
Date:   Thu, 17 Jun 2021 19:28:38 +0800
Message-ID: <20210617112838.143314-1-chenjiahao16@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.174.205]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500016.china.huawei.com (7.185.36.25)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a compiling error in am65-cpsw-nuss.c while not selecting
CONFIG_BQL:

drivers/net/ethernet/ti/am65-cpsw-nuss.c: In function
‘am65_cpsw_nuss_ndo_host_tx_timeout’:
drivers/net/ethernet/ti/am65-cpsw-nuss.c:353:26: error:
‘struct netdev_queue’ has no member named ‘dql’
  353 |      dql_avail(&netif_txq->dql),
      |                          ^~

This problem is solved by adding the #ifdef CONFIG_BQL directive
where struct dql is used.

Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Signed-off-by: Chen Jiahao <chenjiahao16@huawei.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 6a67b026df0b..a0b30bb763ea 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -346,12 +346,20 @@ static void am65_cpsw_nuss_ndo_host_tx_timeout(struct net_device *ndev,
 	tx_chn = &common->tx_chns[txqueue];
 	trans_start = netif_txq->trans_start;
 
+#ifdef CONFIG_BQL
 	netdev_err(ndev, "txq:%d DRV_XOFF:%d tmo:%u dql_avail:%d free_desc:%zu\n",
 		   txqueue,
 		   netif_tx_queue_stopped(netif_txq),
 		   jiffies_to_msecs(jiffies - trans_start),
 		   dql_avail(&netif_txq->dql),
 		   k3_cppi_desc_pool_avail(tx_chn->desc_pool));
+#else
+	netdev_err(ndev, "txq:%d DRV_XOFF:%d tmo:%u free_desc:%zu\n",
+		   txqueue,
+		   netif_tx_queue_stopped(netif_txq),
+		   jiffies_to_msecs(jiffies - trans_start),
+		   k3_cppi_desc_pool_avail(tx_chn->desc_pool));
+#endif
 
 	if (netif_tx_queue_stopped(netif_txq)) {
 		/* try recover if stopped by us */
-- 
2.31.1

