Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2AB141C969
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346338AbhI2QD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:03:56 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13848 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345597AbhI2QAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:03 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWc15Zvz8yvp;
        Wed, 29 Sep 2021 23:53:32 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:10 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:10 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 099/167] net: hinic: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:26 +0800
Message-ID: <20210929155334.12454-100-shenjian15@huawei.com>
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
 .../net/ethernet/huawei/hinic/hinic_main.c    | 74 ++++++++++++-------
 drivers/net/ethernet/huawei/hinic/hinic_rx.c  |  5 +-
 2 files changed, 50 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index cce66faa477c..c33bb3dd5614 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -894,9 +894,9 @@ static void hinic_fix_features(struct net_device *netdev,
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 
 	/* If Rx checksum is disabled, then LRO should also be disabled */
-	if (!(*features & NETIF_F_RXCSUM)) {
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features)) {
 		netif_info(nic_dev, drv, netdev, "disabling LRO as RXCSUM is off\n");
-		*features &= ~NETIF_F_LRO;
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
 	}
 }
 
@@ -941,19 +941,25 @@ static const struct net_device_ops hinicvf_netdev_ops = {
 
 static void netdev_features_init(struct net_device *netdev)
 {
-	netdev->hw_features = NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_IP_CSUM |
-			      NETIF_F_IPV6_CSUM | NETIF_F_TSO | NETIF_F_TSO6 |
-			      NETIF_F_RXCSUM | NETIF_F_LRO |
-			      NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-			      NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM;
 
-	netdev->vlan_features = netdev->hw_features;
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_IP_CSUM |
+				NETIF_F_IPV6_CSUM | NETIF_F_TSO | NETIF_F_TSO6 |
+				NETIF_F_RXCSUM | NETIF_F_LRO |
+				NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM,
+				&netdev->hw_features);
 
-	netdev->features = netdev->hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_feature_copy(&netdev->vlan_features, netdev->hw_features);
 
-	netdev->hw_enc_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_SCTP_CRC |
-				  NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_TSO_ECN |
-				  NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_UDP_TUNNEL;
+	netdev_feature_copy(&netdev->features, netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, &netdev->features);
+
+	netdev_feature_zero(&netdev->hw_enc_features);
+	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | NETIF_F_SCTP_CRC |
+				NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_TSO_ECN |
+				NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_UDP_TUNNEL,
+				&netdev->hw_enc_features);
 }
 
 static void hinic_refresh_nic_cfg(struct hinic_dev *nic_dev)
@@ -1073,52 +1079,66 @@ static int set_features(struct hinic_dev *nic_dev,
 			netdev_features_t pre_features,
 			netdev_features_t features, bool force_change)
 {
-	netdev_features_t changed = force_change ? ~0 : pre_features ^ features;
 	u32 csum_en = HINIC_RX_CSUM_OFFLOAD_EN;
-	netdev_features_t failed_features = 0;
+	netdev_features_t failed_features;
+	netdev_features_t changed;
 	int ret = 0;
 	int err = 0;
 
-	if (changed & NETIF_F_TSO) {
-		ret = hinic_port_set_tso(nic_dev, (features & NETIF_F_TSO) ?
+	if (force_change)
+		netdev_feature_fill(&changed);
+	else
+		netdev_feature_xor(&changed, pre_features, features);
+
+	netdev_feature_zero(&failed_features);
+
+	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, changed)) {
+		ret = hinic_port_set_tso(nic_dev,
+					 netdev_feature_test_bit(NETIF_F_TSO_BIT,
+								 features) ?
 					 HINIC_TSO_ENABLE : HINIC_TSO_DISABLE);
 		if (ret) {
 			err = ret;
-			failed_features |= NETIF_F_TSO;
+			netdev_feature_set_bit(NETIF_F_TSO_BIT,
+					       &failed_features);
 		}
 	}
 
-	if (changed & NETIF_F_RXCSUM) {
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, changed)) {
 		ret = hinic_set_rx_csum_offload(nic_dev, csum_en);
 		if (ret) {
 			err = ret;
-			failed_features |= NETIF_F_RXCSUM;
+			netdev_feature_set_bit(NETIF_F_RXCSUM_BIT,
+					       &failed_features);
 		}
 	}
 
-	if (changed & NETIF_F_LRO) {
+	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, changed)) {
 		ret = hinic_set_rx_lro_state(nic_dev,
-					     !!(features & NETIF_F_LRO),
+					     netdev_feature_test_bit(NETIF_F_LRO_BIT,
+								     features),
 					     HINIC_LRO_RX_TIMER_DEFAULT,
 					     HINIC_LRO_MAX_WQE_NUM_DEFAULT);
 		if (ret) {
 			err = ret;
-			failed_features |= NETIF_F_LRO;
+			netdev_feature_set_bit(NETIF_F_LRO_BIT,
+					       &failed_features);
 		}
 	}
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed)) {
 		ret = hinic_set_rx_vlan_offload(nic_dev,
-						!!(features &
-						   NETIF_F_HW_VLAN_CTAG_RX));
+						netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+									features));
 		if (ret) {
 			err = ret;
-			failed_features |= NETIF_F_HW_VLAN_CTAG_RX;
+			netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					       &failed_features);
 		}
 	}
 
 	if (err) {
-		nic_dev->netdev->features = features ^ failed_features;
+		netdev_feature_xor(&nic_dev->netdev->features, features, failed_features);
 		return -EIO;
 	}
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
index fed3b6bc0d76..1e07978ec8a7 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -106,7 +106,7 @@ static void rx_csum(struct hinic_rxq *rxq, u32 status,
 
 	csum_err = HINIC_RQ_CQE_STATUS_GET(status, CSUM_ERR);
 
-	if (!(netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, netdev->features))
 		return;
 
 	if (!csum_err) {
@@ -411,7 +411,8 @@ static int rxq_recv(struct hinic_rxq *rxq, int budget)
 
 		offload_type = be32_to_cpu(cqe->offload_type);
 		vlan_len = be32_to_cpu(cqe->len);
-		if ((netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					    netdev->features) &&
 		    HINIC_GET_RX_VLAN_OFFLOAD_EN(offload_type)) {
 			vid = HINIC_GET_RX_VLAN_TAG(vlan_len);
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vid);
-- 
2.33.0

