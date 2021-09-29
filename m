Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB79041C1C1
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 11:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245164AbhI2Jl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 05:41:59 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13393 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245100AbhI2Jlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 05:41:51 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKB7R2VJxz901L;
        Wed, 29 Sep 2021 17:35:31 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 17:40:09 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 17:40:09 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 7/8] net: hns3: fix always enable rx vlan filter problem after selftest
Date:   Wed, 29 Sep 2021 17:35:55 +0800
Message-ID: <20210929093556.9146-8-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929093556.9146-1-huangguangbin2@huawei.com>
References: <20210929093556.9146-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the rx vlan filter will always be disabled before selftest and
be enabled after selftest as the rx vlan filter feature is fixed on in
old device earlier than V3.

However, this feature is not fixed in some new devices and it can be
disabled by user. In this case, it is wrong if rx vlan filter is enabled
after selftest. So fix it.

Fixes: bcc26e8dc432 ("net: hns3: remove unused code in hns3_self_test()")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 7ea511d59e91..5ebd96f6833d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -334,7 +334,8 @@ static void hns3_selftest_prepare(struct net_device *ndev,
 
 #if IS_ENABLED(CONFIG_VLAN_8021Q)
 	/* Disable the vlan filter for selftest does not support it */
-	if (h->ae_algo->ops->enable_vlan_filter)
+	if (h->ae_algo->ops->enable_vlan_filter &&
+	    ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
 		h->ae_algo->ops->enable_vlan_filter(h, false);
 #endif
 
@@ -359,7 +360,8 @@ static void hns3_selftest_restore(struct net_device *ndev, bool if_running)
 		h->ae_algo->ops->halt_autoneg(h, false);
 
 #if IS_ENABLED(CONFIG_VLAN_8021Q)
-	if (h->ae_algo->ops->enable_vlan_filter)
+	if (h->ae_algo->ops->enable_vlan_filter &&
+	    ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
 		h->ae_algo->ops->enable_vlan_filter(h, true);
 #endif
 
-- 
2.33.0

