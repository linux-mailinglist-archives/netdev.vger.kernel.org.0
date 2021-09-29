Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B8441C8F5
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345712AbhI2QAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:22 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27909 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344192AbhI2P7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:43 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLWp4WxRzbmrT;
        Wed, 29 Sep 2021 23:53:42 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:59 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:58 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 022/167] ethtool: convert the prototype of ethtool_get_feature_mask
Date:   Wed, 29 Sep 2021 23:51:09 +0800
Message-ID: <20210929155334.12454-23-shenjian15@huawei.com>
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

For the origin type for netdev_features_t would be changed to
be unsigned long * from u64, so changes the prototype of
ethtool_get_feature_mask for adaption.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 net/ethtool/ioctl.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index bf6e8c2f9bf7..661b75dee9fd 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -195,30 +195,35 @@ static void __ethtool_get_strings(struct net_device *dev,
 		ops->get_strings(dev, stringset, data);
 }
 
-static netdev_features_t ethtool_get_feature_mask(u32 eth_cmd)
+static void ethtool_get_feature_mask(u32 eth_cmd, netdev_features_t *mask)
 {
 	/* feature masks of legacy discrete ethtool ops */
 
 	switch (eth_cmd) {
 	case ETHTOOL_GTXCSUM:
 	case ETHTOOL_STXCSUM:
-		return NETIF_F_CSUM_MASK | NETIF_F_FCOE_CRC |
-		       NETIF_F_SCTP_CRC;
+		*mask = NETIF_F_CSUM_MASK | NETIF_F_FCOE_CRC | NETIF_F_SCTP_CRC;
+		break;
 	case ETHTOOL_GRXCSUM:
 	case ETHTOOL_SRXCSUM:
-		return NETIF_F_RXCSUM;
+		*mask = NETIF_F_RXCSUM;
+		break;
 	case ETHTOOL_GSG:
 	case ETHTOOL_SSG:
-		return NETIF_F_SG | NETIF_F_FRAGLIST;
+		*mask = NETIF_F_SG | NETIF_F_FRAGLIST;
+		break;
 	case ETHTOOL_GTSO:
 	case ETHTOOL_STSO:
-		return NETIF_F_ALL_TSO;
+		*mask = NETIF_F_ALL_TSO;
+		break;
 	case ETHTOOL_GGSO:
 	case ETHTOOL_SGSO:
-		return NETIF_F_GSO;
+		*mask = NETIF_F_GSO;
+		break;
 	case ETHTOOL_GGRO:
 	case ETHTOOL_SGRO:
-		return NETIF_F_GRO;
+		*mask = NETIF_F_GRO;
+		break;
 	default:
 		BUG();
 	}
@@ -227,11 +232,12 @@ static netdev_features_t ethtool_get_feature_mask(u32 eth_cmd)
 static int ethtool_get_one_feature(struct net_device *dev,
 	char __user *useraddr, u32 ethcmd)
 {
-	netdev_features_t mask = ethtool_get_feature_mask(ethcmd);
-	struct ethtool_value edata = {
-		.cmd = ethcmd,
-		.data = !!(dev->features & mask),
-	};
+	struct ethtool_value edata;
+	netdev_features_t mask;
+
+	ethtool_get_feature_mask(ethcmd, &mask);
+	edata.cmd = ethcmd;
+	edata.data = !!(dev->features & mask);
 
 	if (copy_to_user(useraddr, &edata, sizeof(edata)))
 		return -EFAULT;
@@ -247,7 +253,7 @@ static int ethtool_set_one_feature(struct net_device *dev,
 	if (copy_from_user(&edata, useraddr, sizeof(edata)))
 		return -EFAULT;
 
-	mask = ethtool_get_feature_mask(ethcmd);
+	ethtool_get_feature_mask(ethcmd, &mask);
 	mask &= dev->hw_features;
 	if (!mask)
 		return -EOPNOTSUPP;
-- 
2.33.0

