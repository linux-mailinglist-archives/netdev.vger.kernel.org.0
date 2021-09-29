Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4532B41C8F2
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345504AbhI2QAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:19 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27908 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343944AbhI2P7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:43 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLWp07VHzbmrc;
        Wed, 29 Sep 2021 23:53:42 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:59 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:57 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 017/167] net: convert the prototype of hsr_features_recompute
Date:   Wed, 29 Sep 2021 23:51:04 +0800
Message-ID: <20210929155334.12454-18-shenjian15@huawei.com>
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
hsr_features_recompute for adaption.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 net/hsr/hsr_device.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 16e0efd8b528..7e6dd372711f 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -177,13 +177,13 @@ static int hsr_dev_close(struct net_device *dev)
 	return 0;
 }
 
-static netdev_features_t hsr_features_recompute(struct hsr_priv *hsr,
-						netdev_features_t features)
+static void hsr_features_recompute(struct hsr_priv *hsr,
+				   netdev_features_t *features)
 {
 	netdev_features_t mask;
 	struct hsr_port *port;
 
-	mask = features;
+	mask = *features;
 
 	/* Mask out all features that, if supported by one device, should be
 	 * enabled for all devices (see NETIF_F_ONE_FOR_ALL).
@@ -192,12 +192,10 @@ static netdev_features_t hsr_features_recompute(struct hsr_priv *hsr,
 	 * that were in features originally, and also is in NETIF_F_ONE_FOR_ALL,
 	 * may become enabled.
 	 */
-	features &= ~NETIF_F_ONE_FOR_ALL;
+	*features &= ~NETIF_F_ONE_FOR_ALL;
 	hsr_for_each_port(hsr, port)
-		netdev_increment_features(&features, features,
+		netdev_increment_features(features, *features,
 					  port->dev->features, mask);
-
-	return features;
 }
 
 static void hsr_fix_features(struct net_device *dev,
@@ -205,7 +203,7 @@ static void hsr_fix_features(struct net_device *dev,
 {
 	struct hsr_priv *hsr = netdev_priv(dev);
 
-	*features = hsr_features_recompute(hsr, *features);
+	hsr_features_recompute(hsr, features);
 }
 
 static netdev_tx_t hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
-- 
2.33.0

