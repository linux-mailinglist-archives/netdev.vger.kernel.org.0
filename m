Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E2341C8ED
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345624AbhI2QAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:03 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13834 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343776AbhI2P7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:41 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWN0wR4z4whn;
        Wed, 29 Sep 2021 23:53:20 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:58 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:56 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 012/167] net: convert the prototype of netdev_fix_features
Date:   Wed, 29 Sep 2021 23:50:59 +0800
Message-ID: <20210929155334.12454-13-shenjian15@huawei.com>
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
netdev_fix_features for adaption.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 net/core/dev.c | 78 ++++++++++++++++++++++++--------------------------
 1 file changed, 38 insertions(+), 40 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8a2de66e709b..a03a01e5339e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9826,99 +9826,97 @@ static void netdev_sync_lower_features(struct net_device *upper,
 	}
 }
 
-static netdev_features_t netdev_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void netdev_fix_features(struct net_device *dev,
+				netdev_features_t *features)
 {
 	/* Fix illegal checksum combinations */
-	if ((features & NETIF_F_HW_CSUM) &&
-	    (features & (NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM))) {
+	if ((*features & NETIF_F_HW_CSUM) &&
+	    (*features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM))) {
 		netdev_warn(dev, "mixed HW and IP checksum settings.\n");
-		features &= ~(NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM);
+		*features &= ~(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
 	}
 
 	/* TSO requires that SG is present as well. */
-	if ((features & NETIF_F_ALL_TSO) && !(features & NETIF_F_SG)) {
+	if ((*features & NETIF_F_ALL_TSO) && !(*features & NETIF_F_SG)) {
 		netdev_dbg(dev, "Dropping TSO features since no SG feature.\n");
-		features &= ~NETIF_F_ALL_TSO;
+		*features &= ~NETIF_F_ALL_TSO;
 	}
 
-	if ((features & NETIF_F_TSO) && !(features & NETIF_F_HW_CSUM) &&
-					!(features & NETIF_F_IP_CSUM)) {
+	if ((*features & NETIF_F_TSO) && !(*features & NETIF_F_HW_CSUM) &&
+	    !(*features & NETIF_F_IP_CSUM)) {
 		netdev_dbg(dev, "Dropping TSO features since no CSUM feature.\n");
-		features &= ~NETIF_F_TSO;
-		features &= ~NETIF_F_TSO_ECN;
+		*features &= ~NETIF_F_TSO;
+		*features &= ~NETIF_F_TSO_ECN;
 	}
 
-	if ((features & NETIF_F_TSO6) && !(features & NETIF_F_HW_CSUM) &&
-					 !(features & NETIF_F_IPV6_CSUM)) {
+	if ((*features & NETIF_F_TSO6) && !(*features & NETIF_F_HW_CSUM) &&
+	    !(*features & NETIF_F_IPV6_CSUM)) {
 		netdev_dbg(dev, "Dropping TSO6 features since no CSUM feature.\n");
-		features &= ~NETIF_F_TSO6;
+		*features &= ~NETIF_F_TSO6;
 	}
 
 	/* TSO with IPv4 ID mangling requires IPv4 TSO be enabled */
-	if ((features & NETIF_F_TSO_MANGLEID) && !(features & NETIF_F_TSO))
-		features &= ~NETIF_F_TSO_MANGLEID;
+	if ((*features & NETIF_F_TSO_MANGLEID) && !(*features & NETIF_F_TSO))
+		*features &= ~NETIF_F_TSO_MANGLEID;
 
 	/* TSO ECN requires that TSO is present as well. */
-	if ((features & NETIF_F_ALL_TSO) == NETIF_F_TSO_ECN)
-		features &= ~NETIF_F_TSO_ECN;
+	if ((*features & NETIF_F_ALL_TSO) == NETIF_F_TSO_ECN)
+		*features &= ~NETIF_F_TSO_ECN;
 
 	/* Software GSO depends on SG. */
-	if ((features & NETIF_F_GSO) && !(features & NETIF_F_SG)) {
+	if ((*features & NETIF_F_GSO) && !(*features & NETIF_F_SG)) {
 		netdev_dbg(dev, "Dropping NETIF_F_GSO since no SG feature.\n");
-		features &= ~NETIF_F_GSO;
+		*features &= ~NETIF_F_GSO;
 	}
 
 	/* GSO partial features require GSO partial be set */
-	if ((features & dev->gso_partial_features) &&
-	    !(features & NETIF_F_GSO_PARTIAL)) {
+	if ((*features & dev->gso_partial_features) &&
+	    !(*features & NETIF_F_GSO_PARTIAL)) {
 		netdev_dbg(dev,
 			   "Dropping partially supported GSO features since no GSO partial.\n");
-		features &= ~dev->gso_partial_features;
+		*features &= ~dev->gso_partial_features;
 	}
 
-	if (!(features & NETIF_F_RXCSUM)) {
+	if (!(*features & NETIF_F_RXCSUM)) {
 		/* NETIF_F_GRO_HW implies doing RXCSUM since every packet
 		 * successfully merged by hardware must also have the
 		 * checksum verified by hardware.  If the user does not
 		 * want to enable RXCSUM, logically, we should disable GRO_HW.
 		 */
-		if (features & NETIF_F_GRO_HW) {
+		if (*features & NETIF_F_GRO_HW) {
 			netdev_dbg(dev, "Dropping NETIF_F_GRO_HW since no RXCSUM feature.\n");
-			features &= ~NETIF_F_GRO_HW;
+			*features &= ~NETIF_F_GRO_HW;
 		}
 	}
 
 	/* LRO/HW-GRO features cannot be combined with RX-FCS */
-	if (features & NETIF_F_RXFCS) {
-		if (features & NETIF_F_LRO) {
+	if (*features & NETIF_F_RXFCS) {
+		if (*features & NETIF_F_LRO) {
 			netdev_dbg(dev, "Dropping LRO feature since RX-FCS is requested.\n");
-			features &= ~NETIF_F_LRO;
+			*features &= ~NETIF_F_LRO;
 		}
 
-		if (features & NETIF_F_GRO_HW) {
+		if (*features & NETIF_F_GRO_HW) {
 			netdev_dbg(dev, "Dropping HW-GRO feature since RX-FCS is requested.\n");
-			features &= ~NETIF_F_GRO_HW;
+			*features &= ~NETIF_F_GRO_HW;
 		}
 	}
 
-	if (features & NETIF_F_HW_TLS_TX) {
-		bool ip_csum = (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) ==
+	if (*features & NETIF_F_HW_TLS_TX) {
+		bool ip_csum = (*features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) ==
 			(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
-		bool hw_csum = features & NETIF_F_HW_CSUM;
+		bool hw_csum = *features & NETIF_F_HW_CSUM;
 
 		if (!ip_csum && !hw_csum) {
 			netdev_dbg(dev, "Dropping TLS TX HW offload feature since no CSUM feature.\n");
-			features &= ~NETIF_F_HW_TLS_TX;
+			*features &= ~NETIF_F_HW_TLS_TX;
 		}
 	}
 
-	if ((features & NETIF_F_HW_TLS_RX) && !(features & NETIF_F_RXCSUM)) {
+	if ((*features & NETIF_F_HW_TLS_RX) && !(*features & NETIF_F_RXCSUM)) {
 		netdev_dbg(dev, "Dropping TLS RX HW offload feature since no RXCSUM feature.\n");
-		features &= ~NETIF_F_HW_TLS_RX;
+		*features &= ~NETIF_F_HW_TLS_RX;
 	}
-
-	return features;
 }
 
 int __netdev_update_features(struct net_device *dev)
@@ -9936,7 +9934,7 @@ int __netdev_update_features(struct net_device *dev)
 		dev->netdev_ops->ndo_fix_features(dev, &features);
 
 	/* driver might be less strict about feature dependencies */
-	features = netdev_fix_features(dev, features);
+	netdev_fix_features(dev, &features);
 
 	/* some features can't be enabled if they're off on an upper device */
 	netdev_for_each_upper_dev_rcu(dev, upper, iter)
-- 
2.33.0

