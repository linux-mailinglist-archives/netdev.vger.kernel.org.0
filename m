Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9457741C924
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345999AbhI2QBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:01:52 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27917 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345481AbhI2P7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:50 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLWw3wxpzbmvJ;
        Wed, 29 Sep 2021 23:53:48 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:05 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:05 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 068/167] net: dummy: use netdev_feature helpers
Date:   Wed, 29 Sep 2021 23:51:55 +0800
Message-ID: <20210929155334.12454-69-shenjian15@huawei.com>
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
 drivers/net/dummy.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index f82ad7419508..54ebb638a57b 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -123,12 +123,14 @@ static void dummy_setup(struct net_device *dev)
 	dev->flags |= IFF_NOARP;
 	dev->flags &= ~IFF_MULTICAST;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE | IFF_NO_QUEUE;
-	dev->features	|= NETIF_F_SG | NETIF_F_FRAGLIST;
-	dev->features	|= NETIF_F_GSO_SOFTWARE;
-	dev->features	|= NETIF_F_HW_CSUM | NETIF_F_HIGHDMA | NETIF_F_LLTX;
-	dev->features	|= NETIF_F_GSO_ENCAP_ALL;
-	dev->hw_features |= dev->features;
-	dev->hw_enc_features |= dev->features;
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_FRAGLIST, &dev->features);
+	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, &dev->features);
+	netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_HIGHDMA |
+				NETIF_F_LLTX, &dev->features);
+	netdev_feature_set_bits(NETIF_F_GSO_ENCAP_ALL, &dev->features);
+	netdev_feature_or(&dev->hw_features, dev->hw_features, dev->features);
+	netdev_feature_or(&dev->hw_enc_features, dev->hw_enc_features,
+			  dev->features);
 	eth_hw_addr_random(dev);
 
 	dev->min_mtu = 0;
-- 
2.33.0

