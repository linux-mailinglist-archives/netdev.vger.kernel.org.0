Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220894E803C
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 10:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbiCZJ6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 05:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbiCZJ6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 05:58:14 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838CE1EEE3;
        Sat, 26 Mar 2022 02:56:38 -0700 (PDT)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KQZ9N1Pqjz1GDG7;
        Sat, 26 Mar 2022 17:56:24 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500009.china.huawei.com (7.221.188.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 17:56:36 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 17:56:35 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 4/6] net: hns3: add netdev reset check for hns3_set_tunable()
Date:   Sat, 26 Mar 2022 17:51:03 +0800
Message-ID: <20220326095105.54075-5-huangguangbin2@huawei.com>
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

When pci device reset failed, it does uninit operation and priv->ring
is NULL, it causes accessing NULL pointer error.

Add netdev reset check for hns3_set_tunable() to fix it.

Fixes: 99f6b5fb5f63 ("net: hns3: use bounce buffer when rx page can not be reused")
Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index ae30dbe7ef52..49e7b022caaa 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -1766,9 +1766,6 @@ static int hns3_set_tx_spare_buf_size(struct net_device *netdev,
 	struct hnae3_handle *h = priv->ae_handle;
 	int ret;
 
-	if (hns3_nic_resetting(netdev))
-		return -EBUSY;
-
 	h->kinfo.tx_spare_buf_size = data;
 
 	ret = hns3_reset_notify(h, HNAE3_DOWN_CLIENT);
@@ -1799,6 +1796,11 @@ static int hns3_set_tunable(struct net_device *netdev,
 	struct hnae3_handle *h = priv->ae_handle;
 	int i, ret = 0;
 
+	if (hns3_nic_resetting(netdev) || !priv->ring) {
+		netdev_err(netdev, "failed to set tunable value, dev resetting!");
+		return -EBUSY;
+	}
+
 	switch (tuna->id) {
 	case ETHTOOL_TX_COPYBREAK:
 		priv->tx_copybreak = *(u32 *)data;
-- 
2.33.0

