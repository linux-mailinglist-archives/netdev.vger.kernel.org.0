Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6242941C908
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345832AbhI2QA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:56 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:23321 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345414AbhI2P7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:46 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWr5KXbzRJwr;
        Wed, 29 Sep 2021 23:53:44 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:02 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:00 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 040/167] macvtap: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:27 +0800
Message-ID: <20210929155334.12454-41-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_feature_xxx helpers to replace the logical operation
for netdev features.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/macvtap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 694e2f5dbbe5..2162080133bb 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -74,7 +74,7 @@ static void macvtap_update_features(struct tap_dev *tap,
 	struct macvtap_dev *vlantap = container_of(tap, struct macvtap_dev, tap);
 	struct macvlan_dev *vlan = &vlantap->vlan;
 
-	vlan->set_features = features;
+	netdev_feature_copy(&vlan->set_features, features);
 	netdev_update_features(vlan->dev);
 }
 
@@ -90,7 +90,8 @@ static int macvtap_newlink(struct net *src_net, struct net_device *dev,
 	/* Since macvlan supports all offloads by default, make
 	 * tap support all offloads also.
 	 */
-	vlantap->tap.tap_features = TUN_OFFLOADS;
+	netdev_feature_zero(&vlantap->tap.tap_features);
+	netdev_feature_set_bits(TUN_OFFLOADS, &vlantap->tap.tap_features);
 
 	/* Register callbacks for rx/tx drops accounting and updating
 	 * net_device features
-- 
2.33.0

