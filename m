Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E78627C156
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 11:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgI2Jey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 05:34:54 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14774 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725786AbgI2Jex (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 05:34:53 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B0F7E92014C61CC9479E;
        Tue, 29 Sep 2020 17:34:50 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Tue, 29 Sep 2020 17:34:44 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guojia Liao <liaoguojia@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 5/7] net: hns3: remove unused code in hns3_self_test()
Date:   Tue, 29 Sep 2020 17:32:03 +0800
Message-ID: <1601371925-49426-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1601371925-49426-1-git-send-email-tanhuazhong@huawei.com>
References: <1601371925-49426-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

NETIF_F_HW_VLAN_CTAG_FILTER is not set in netdev->hw_feature,
but set in netdev->features.

So the handler of NETIF_F_HW_VLAN_CTAG_FILTER in hns3_self_test() is
always true, remove it.

Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index bf3504d..6b07b27 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -311,9 +311,6 @@ static void hns3_self_test(struct net_device *ndev,
 	struct hnae3_handle *h = priv->ae_handle;
 	int st_param[HNS3_SELF_TEST_TYPE_NUM][2];
 	bool if_running = netif_running(ndev);
-#if IS_ENABLED(CONFIG_VLAN_8021Q)
-	bool dis_vlan_filter;
-#endif
 	int test_index = 0;
 	u32 i;
 
@@ -350,9 +347,7 @@ static void hns3_self_test(struct net_device *ndev,
 
 #if IS_ENABLED(CONFIG_VLAN_8021Q)
 	/* Disable the vlan filter for selftest does not support it */
-	dis_vlan_filter = (ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
-				h->ae_algo->ops->enable_vlan_filter;
-	if (dis_vlan_filter)
+	if (h->ae_algo->ops->enable_vlan_filter)
 		h->ae_algo->ops->enable_vlan_filter(h, false);
 #endif
 
@@ -389,7 +384,7 @@ static void hns3_self_test(struct net_device *ndev,
 		h->ae_algo->ops->halt_autoneg(h, false);
 
 #if IS_ENABLED(CONFIG_VLAN_8021Q)
-	if (dis_vlan_filter)
+	if (h->ae_algo->ops->enable_vlan_filter)
 		h->ae_algo->ops->enable_vlan_filter(h, true);
 #endif
 
-- 
2.7.4

