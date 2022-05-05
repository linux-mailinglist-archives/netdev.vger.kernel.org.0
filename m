Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACB251BFD8
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 14:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbiEEMyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 08:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241981AbiEEMyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 08:54:09 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D6743EE3;
        Thu,  5 May 2022 05:50:30 -0700 (PDT)
Received: from kwepemi500010.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KvD796dDCzhYpr;
        Thu,  5 May 2022 20:49:57 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500010.china.huawei.com (7.221.188.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 5 May 2022 20:50:28 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 5 May 2022 20:50:27 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 1/5] net: hns3: fix access null pointer issue when set tx-buf-size as 0
Date:   Thu, 5 May 2022 20:44:40 +0800
Message-ID: <20220505124444.2233-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220505124444.2233-1-huangguangbin2@huawei.com>
References: <20220505124444.2233-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

When set tx-buf-size as 0 by ethtool, hns3_init_tx_spare_buffer()
will return directly and priv->ring->tx_spare->len is uninitialized,
then print function access priv->ring->tx_spare->len will cause
this issue.

When set tx-buf-size as 0 by ethtool, the print function will
print 0 directly and not access priv->ring->tx_spare->len.

Fixes: 2373b35c24ff ("net: hns3: add log for setting tx spare buf size")
Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 1db8a86f046d..6d20974519fe 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1915,8 +1915,11 @@ static int hns3_set_tunable(struct net_device *netdev,
 			return ret;
 		}
 
-		netdev_info(netdev, "the active tx spare buf size is %u, due to page order\n",
-			    priv->ring->tx_spare->len);
+		if (!priv->ring->tx_spare)
+			netdev_info(netdev, "the active tx spare buf size is 0, disable tx spare buffer\n");
+		else
+			netdev_info(netdev, "the active tx spare buf size is %u, due to page order\n",
+				    priv->ring->tx_spare->len);
 
 		break;
 	default:
-- 
2.33.0

