Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3AE41C915
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345937AbhI2QBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:01:23 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27916 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345491AbhI2P7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:49 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLWw3k28zbmsr;
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
Subject: [RFCv2 net-next 067/167] net: loopback: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:54 +0800
Message-ID: <20210929155334.12454-68-shenjian15@huawei.com>
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
 drivers/net/loopback.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index a1c77cc00416..23cad6442959 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -174,17 +174,15 @@ static void gen_lo_setup(struct net_device *dev,
 	dev->flags		= IFF_LOOPBACK;
 	dev->priv_flags		|= IFF_LIVE_ADDR_CHANGE | IFF_NO_QUEUE;
 	netif_keep_dst(dev);
-	dev->hw_features	= NETIF_F_GSO_SOFTWARE;
-	dev->features		= NETIF_F_SG | NETIF_F_FRAGLIST
-		| NETIF_F_GSO_SOFTWARE
-		| NETIF_F_HW_CSUM
-		| NETIF_F_RXCSUM
-		| NETIF_F_SCTP_CRC
-		| NETIF_F_HIGHDMA
-		| NETIF_F_LLTX
-		| NETIF_F_NETNS_LOCAL
-		| NETIF_F_VLAN_CHALLENGED
-		| NETIF_F_LOOPBACK;
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_GSO_SOFTWARE, &dev->hw_features);
+	netdev_feature_zero(&dev->features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_FRAGLIST |
+				NETIF_F_GSO_SOFTWARE | NETIF_F_HW_CSUM |
+				NETIF_F_RXCSUM | NETIF_F_SCTP_CRC |
+				NETIF_F_HIGHDMA | NETIF_F_LLTX |
+				NETIF_F_NETNS_LOCAL | NETIF_F_VLAN_CHALLENGED |
+				NETIF_F_LOOPBACK, &dev->hw_features);
 	dev->ethtool_ops	= eth_ops;
 	dev->header_ops		= hdr_ops;
 	dev->netdev_ops		= dev_ops;
-- 
2.33.0

