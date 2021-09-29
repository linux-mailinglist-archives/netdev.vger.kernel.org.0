Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8C641C8F6
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345727AbhI2QAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:25 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12980 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344312AbhI2P7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:45 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLbD1lXRzWX8X;
        Wed, 29 Sep 2021 23:56:40 +0800 (CST)
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
Subject: [RFCv2 net-next 020/167] net: qlogic: convert the prototype of qlcnic_process_flags
Date:   Wed, 29 Sep 2021 23:51:07 +0800
Message-ID: <20210929155334.12454-21-shenjian15@huawei.com>
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
qlcnic_process_flags for adaption.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    | 24 +++++++++----------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index e6ed7f8413b4..2367923e3e3f 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -1020,37 +1020,35 @@ int qlcnic_change_mtu(struct net_device *netdev, int mtu)
 	return rc;
 }
 
-static netdev_features_t qlcnic_process_flags(struct qlcnic_adapter *adapter,
-					      netdev_features_t features)
+static void qlcnic_process_flags(struct qlcnic_adapter *adapter,
+				 netdev_features_t *features)
 {
 	u32 offload_flags = adapter->offload_flags;
 
 	if (offload_flags & BIT_0) {
-		features |= NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
-			    NETIF_F_IPV6_CSUM;
+		*features |= NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
+			     NETIF_F_IPV6_CSUM;
 		adapter->rx_csum = 1;
 		if (QLCNIC_IS_TSO_CAPABLE(adapter)) {
 			if (!(offload_flags & BIT_1))
-				features &= ~NETIF_F_TSO;
+				*features &= ~NETIF_F_TSO;
 			else
-				features |= NETIF_F_TSO;
+				*features |= NETIF_F_TSO;
 
 			if (!(offload_flags & BIT_2))
-				features &= ~NETIF_F_TSO6;
+				*features &= ~NETIF_F_TSO6;
 			else
-				features |= NETIF_F_TSO6;
+				*features |= NETIF_F_TSO6;
 		}
 	} else {
-		features &= ~(NETIF_F_RXCSUM |
+		*features &= ~(NETIF_F_RXCSUM |
 			      NETIF_F_IP_CSUM |
 			      NETIF_F_IPV6_CSUM);
 
 		if (QLCNIC_IS_TSO_CAPABLE(adapter))
-			features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
+			*features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
 		adapter->rx_csum = 0;
 	}
-
-	return features;
 }
 
 void qlcnic_fix_features(struct net_device *netdev, netdev_features_t *features)
@@ -1061,7 +1059,7 @@ void qlcnic_fix_features(struct net_device *netdev, netdev_features_t *features)
 	if (qlcnic_82xx_check(adapter) &&
 	    (adapter->flags & QLCNIC_ESWITCH_ENABLED)) {
 		if (adapter->flags & QLCNIC_APP_CHANGED_FLAGS) {
-			*features = qlcnic_process_flags(adapter, *features);
+			qlcnic_process_flags(adapter, features);
 		} else {
 			changed = *features ^ netdev->features;
 			*features ^= changed & (NETIF_F_RXCSUM |
-- 
2.33.0

