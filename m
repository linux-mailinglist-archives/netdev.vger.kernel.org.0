Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3B941C978
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345692AbhI2QFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:05:39 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:23325 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345661AbhI2QAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:08 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLX71y72zRd1x;
        Wed, 29 Sep 2021 23:53:59 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:16 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:16 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 138/167] net: apm: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:53:05 +0800
Message-ID: <20210929155334.12454-139-shenjian15@huawei.com>
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
 drivers/net/ethernet/apm/xgene-v2/main.c      |  5 ++---
 .../net/ethernet/apm/xgene/xgene_enet_main.c  | 21 +++++++++++--------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ethernet/apm/xgene-v2/main.c
index 80399c8980bd..2903a0fea0c3 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.c
+++ b/drivers/net/ethernet/apm/xgene-v2/main.c
@@ -648,14 +648,13 @@ static int xge_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, pdata);
 	ndev->netdev_ops = &xgene_ndev_ops;
 
-	ndev->features |= NETIF_F_GSO |
-			  NETIF_F_GRO;
+	netdev_feature_set_bits(NETIF_F_GSO | NETIF_F_GRO, &ndev->features);
 
 	ret = xge_get_resources(pdata);
 	if (ret)
 		goto err;
 
-	ndev->hw_features = ndev->features;
+	netdev_feature_copy(&ndev->hw_features, ndev->features);
 	xge_set_ethtool_ops(ndev);
 
 	ret = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(64));
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 5f1fc6582d74..ed67becb8654 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -320,7 +320,8 @@ static int xgene_enet_work_msg(struct sk_buff *skb, u64 *hopinfo)
 	    unlikely(skb->protocol != htons(ETH_P_8021Q)))
 		goto out;
 
-	if (unlikely(!(skb->dev->features & NETIF_F_IP_CSUM)))
+	if (unlikely(!netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT,
+					      skb->dev->features)))
 		goto out;
 
 	iph = ip_hdr(skb);
@@ -331,7 +332,7 @@ static int xgene_enet_work_msg(struct sk_buff *skb, u64 *hopinfo)
 		l4hlen = tcp_hdrlen(skb) >> 2;
 		csum_enable = 1;
 		proto = TSO_IPPROTO_TCP;
-		if (ndev->features & NETIF_F_TSO) {
+		if (netdev_feature_test_bit(NETIF_F_TSO_BIT, ndev->features))  {
 			hdr_len = ethhdr + ip_hdrlen(skb) + tcp_hdrlen(skb);
 			mss = skb_shinfo(skb)->gso_size;
 
@@ -590,7 +591,7 @@ static void xgene_enet_rx_csum(struct sk_buff *skb)
 	struct net_device *ndev = skb->dev;
 	struct iphdr *iph = ip_hdr(skb);
 
-	if (!(ndev->features & NETIF_F_RXCSUM))
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, ndev->features))
 		return;
 
 	if (skb->protocol != htons(ETH_P_IP))
@@ -2032,10 +2033,11 @@ static int xgene_enet_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, pdata);
 	ndev->netdev_ops = &xgene_ndev_ops;
 	xgene_enet_set_ethtool_ops(ndev);
-	ndev->features |= NETIF_F_IP_CSUM |
-			  NETIF_F_GSO |
-			  NETIF_F_GRO |
-			  NETIF_F_SG;
+	netdev_feature_set_bits(NETIF_F_IP_CSUM |
+				NETIF_F_GSO |
+				NETIF_F_GRO |
+				NETIF_F_SG,
+				&ndev->features);
 
 	of_id = of_match_device(xgene_enet_of_match, &pdev->dev);
 	if (of_id) {
@@ -2063,10 +2065,11 @@ static int xgene_enet_probe(struct platform_device *pdev)
 	spin_lock_init(&pdata->mac_lock);
 
 	if (pdata->phy_mode == PHY_INTERFACE_MODE_XGMII) {
-		ndev->features |= NETIF_F_TSO | NETIF_F_RXCSUM;
+		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_RXCSUM,
+					&ndev->features);
 		spin_lock_init(&pdata->mss_lock);
 	}
-	ndev->hw_features = ndev->features;
+	netdev_feature_copy(&ndev->hw_features, ndev->features);
 
 	ret = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(64));
 	if (ret) {
-- 
2.33.0

