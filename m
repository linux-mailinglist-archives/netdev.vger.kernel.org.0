Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EEF41C968
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346304AbhI2QDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:03:54 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:23332 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345599AbhI2QAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:03 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLX24P6VzQs09;
        Wed, 29 Sep 2021 23:53:54 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:12 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:11 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 108/167] net: socionext: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:35 +0800
Message-ID: <20210929155334.12454-109-shenjian15@huawei.com>
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
 drivers/net/ethernet/socionext/netsec.c  | 10 ++++++----
 drivers/net/ethernet/socionext/sni_ave.c |  6 ++++--
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index f80a2aef9972..9e1943434e7e 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1751,7 +1751,8 @@ static int netsec_netdev_set_features(struct net_device *ndev,
 {
 	struct netsec_priv *priv = netdev_priv(ndev);
 
-	priv->rx_cksum_offload_flag = !!(features & NETIF_F_RXCSUM);
+	priv->rx_cksum_offload_flag =
+		netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features);
 
 	return 0;
 }
@@ -2102,9 +2103,10 @@ static int netsec_probe(struct platform_device *pdev)
 	ndev->netdev_ops = &netsec_netdev_ops;
 	ndev->ethtool_ops = &netsec_ethtool_ops;
 
-	ndev->features |= NETIF_F_HIGHDMA | NETIF_F_RXCSUM | NETIF_F_GSO |
-				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-	ndev->hw_features = ndev->features;
+	netdev_feature_set_bits(NETIF_F_HIGHDMA | NETIF_F_RXCSUM | NETIF_F_GSO |
+				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
+				&ndev->features);
+	netdev_feature_copy(&ndev->hw_features, ndev->features);
 
 	priv->rx_cksum_offload_flag = true;
 
diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index ae31ed93aaf0..efdcb7f3853f 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1594,8 +1594,10 @@ static int ave_probe(struct platform_device *pdev)
 	ndev->ethtool_ops = &ave_ethtool_ops;
 	SET_NETDEV_DEV(ndev, dev);
 
-	ndev->features    |= (NETIF_F_IP_CSUM | NETIF_F_RXCSUM);
-	ndev->hw_features |= (NETIF_F_IP_CSUM | NETIF_F_RXCSUM);
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_RXCSUM,
+				&ndev->features);
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_RXCSUM,
+				&ndev->hw_features);
 
 	ndev->max_mtu = AVE_MAX_ETHFRAME - (ETH_HLEN + ETH_FCS_LEN);
 
-- 
2.33.0

