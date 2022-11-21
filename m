Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B824E63180B
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 02:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiKUBAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 20:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiKUBAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 20:00:33 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEF220BF5
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 17:00:31 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NFpvk11b6z15Mll;
        Mon, 21 Nov 2022 09:00:02 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 21 Nov
 2022 09:00:29 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <michal.simek@xilinx.com>, <harini.katakam@amd.com>,
        <xuhaoyue1@hisilicon.com>, <huangjunxian6@hisilicon.com>,
        <wangqing@vivo.com>, <chenhao288@hisilicon.com>,
        <yangyingliang@huawei.com>, <trix@redhat.com>,
        <afleming@freescale.com>, <grant.likely@secretlab.ca>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH] net: ll_temac: stop phy when request_irq() failed in temac_open()
Date:   Mon, 21 Nov 2022 09:06:58 +0800
Message-ID: <20221121010658.106749-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When request_irq() failed in temac_open(), phy is not stopped. Compiled
test only.

Fixes: 92744989533c ("net: add Xilinx ll_temac device driver")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 1066420d6a83..2b61fa2c04a2 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1193,8 +1193,10 @@ static int temac_open(struct net_device *ndev)
  err_rx_irq:
 	free_irq(lp->tx_irq, ndev);
  err_tx_irq:
-	if (phydev)
+	if (phydev) {
+		phy_stop(phydev);
 		phy_disconnect(phydev);
+	}
 	dev_err(lp->dev, "request_irq() failed\n");
 	return rc;
 }
@@ -1211,8 +1213,10 @@ static int temac_stop(struct net_device *ndev)
 	free_irq(lp->tx_irq, ndev);
 	free_irq(lp->rx_irq, ndev);
 
-	if (phydev)
+	if (phydev) {
+		phy_stop(phydev);
 		phy_disconnect(phydev);
+	}
 
 	temac_dma_bd_release(ndev);
 
-- 
2.17.1

