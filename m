Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8CB4E803D
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 10:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbiCZJ61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 05:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbiCZJ6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 05:58:14 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DB61F606;
        Sat, 26 Mar 2022 02:56:38 -0700 (PDT)
Received: from kwepemi500010.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KQZ7n2CSwzfZX2;
        Sat, 26 Mar 2022 17:55:01 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500010.china.huawei.com (7.221.188.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 17:56:36 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 17:56:36 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 5/6] net: hns3: add NULL pointer check for hns3_set/get_ringparam()
Date:   Sat, 26 Mar 2022 17:51:04 +0800
Message-ID: <20220326095105.54075-6-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220326095105.54075-1-huangguangbin2@huawei.com>
References: <20220326095105.54075-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

When pci devices init failed and haven't reinit, priv->ring is
NULL and hns3_set/get_ringparam() will access priv->ring. it
causes call trace.

So, add NULL pointer check for hns3_set/get_ringparam() to
avoid this situation.

Fixes: 5668abda0931 ("net: hns3: add support for set_ringparam")
Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 49e7b022caaa..f4da77452126 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -653,8 +653,8 @@ static void hns3_get_ringparam(struct net_device *netdev,
 	struct hnae3_handle *h = priv->ae_handle;
 	int rx_queue_index = h->kinfo.num_tqps;
 
-	if (hns3_nic_resetting(netdev)) {
-		netdev_err(netdev, "dev resetting!");
+	if (hns3_nic_resetting(netdev) || !priv->ring) {
+		netdev_err(netdev, "failed to get ringparam value, due to dev resetting or uninited\n");
 		return;
 	}
 
@@ -1074,8 +1074,14 @@ static int hns3_check_ringparam(struct net_device *ndev,
 {
 #define RX_BUF_LEN_2K 2048
 #define RX_BUF_LEN_4K 4096
-	if (hns3_nic_resetting(ndev))
+
+	struct hns3_nic_priv *priv = netdev_priv(ndev);
+
+	if (hns3_nic_resetting(ndev) || !priv->ring) {
+		netdev_err(ndev, "failed to set ringparam value, due to dev resetting or uninited\n");
 		return -EBUSY;
+	}
+
 
 	if (param->rx_mini_pending || param->rx_jumbo_pending)
 		return -EINVAL;
-- 
2.33.0

