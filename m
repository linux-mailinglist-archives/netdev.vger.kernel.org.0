Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347E541C8FE
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345767AbhI2QAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:38 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12984 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344334AbhI2P7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:45 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLbF6HFSzWXfs;
        Wed, 29 Sep 2021 23:56:41 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:01 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:59 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 033/167] net: geneve: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:20 +0800
Message-ID: <20210929155334.12454-34-shenjian15@huawei.com>
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
 drivers/net/geneve.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 1ab94b5f9bbf..d2179c103300 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1219,14 +1219,16 @@ static void geneve_setup(struct net_device *dev)
 
 	SET_NETDEV_DEVTYPE(dev, &geneve_type);
 
-	dev->features    |= NETIF_F_LLTX;
-	dev->features    |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST;
-	dev->features    |= NETIF_F_RXCSUM;
-	dev->features    |= NETIF_F_GSO_SOFTWARE;
-
-	dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST;
-	dev->hw_features |= NETIF_F_RXCSUM;
-	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST,
+				&dev->features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->features);
+	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, &dev->features);
+
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_FRAGLIST,
+				&dev->hw_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, &dev->hw_features);
 
 	/* MTU range: 68 - (something less than 65535) */
 	dev->min_mtu = ETH_MIN_MTU;
-- 
2.33.0

