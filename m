Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F19C41C8FB
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345754AbhI2QAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:31 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13837 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344349AbhI2P7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:45 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWR1s6Hz8yrD;
        Wed, 29 Sep 2021 23:53:23 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:01 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:00 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 037/167] net: tls: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:24 +0800
Message-ID: <20210929155334.12454-38-shenjian15@huawei.com>
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
 net/tls/tls_device.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index b932469ee69c..94189107995f 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1125,7 +1125,7 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 		goto disable_cad;
 	}
 
-	if (!(netdev->features & NETIF_F_HW_TLS_TX)) {
+	if (!netdev_feature_test_bit(NETIF_F_HW_TLS_TX_BIT, netdev->features)) {
 		rc = -EOPNOTSUPP;
 		goto release_netdev;
 	}
@@ -1200,7 +1200,7 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
 		return -EINVAL;
 	}
 
-	if (!(netdev->features & NETIF_F_HW_TLS_RX)) {
+	if (!netdev_feature_test_bit(NETIF_F_HW_TLS_RX_BIT, netdev->features)) {
 		rc = -EOPNOTSUPP;
 		goto release_netdev;
 	}
@@ -1361,7 +1361,8 @@ static int tls_dev_event(struct notifier_block *this, unsigned long event,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 
 	if (!dev->tlsdev_ops &&
-	    !(dev->features & (NETIF_F_HW_TLS_RX | NETIF_F_HW_TLS_TX)))
+	    !netdev_feature_test_bits(NETIF_F_HW_TLS_RX | NETIF_F_HW_TLS_TX,
+				      dev->features))
 		return NOTIFY_DONE;
 
 	switch (event) {
@@ -1369,7 +1370,8 @@ static int tls_dev_event(struct notifier_block *this, unsigned long event,
 	case NETDEV_FEAT_CHANGE:
 		if (netif_is_bond_master(dev))
 			return NOTIFY_DONE;
-		if ((dev->features & NETIF_F_HW_TLS_RX) &&
+		if (netdev_feature_test_bit(NETIF_F_HW_TLS_RX_BIT,
+					    dev->features) &&
 		    !dev->tlsdev_ops->tls_dev_resync)
 			return NOTIFY_BAD;
 
-- 
2.33.0

