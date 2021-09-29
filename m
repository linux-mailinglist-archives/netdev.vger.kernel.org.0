Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9231641C953
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346467AbhI2QEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:04:25 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24143 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345608AbhI2QAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:04 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbR4hwKz1DHD0;
        Wed, 29 Sep 2021 23:56:51 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
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
Subject: [RFCv2 net-next 100/167] net: ibm: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:27 +0800
Message-ID: <20210929155334.12454-101-shenjian15@huawei.com>
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
 drivers/net/ethernet/ibm/ehea/ehea_main.c | 22 ++++---
 drivers/net/ethernet/ibm/emac/core.c      |  7 ++-
 drivers/net/ethernet/ibm/ibmveth.c        | 70 ++++++++++++++---------
 drivers/net/ethernet/ibm/ibmvnic.c        | 62 +++++++++++++-------
 4 files changed, 104 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index d5df131b183c..dba57bb6684f 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -2991,14 +2991,20 @@ static struct ehea_port *ehea_setup_single_port(struct ehea_adapter *adapter,
 	dev->netdev_ops = &ehea_netdev_ops;
 	ehea_set_ethtool_ops(dev);
 
-	dev->hw_features = NETIF_F_SG | NETIF_F_TSO |
-		      NETIF_F_IP_CSUM | NETIF_F_HW_VLAN_CTAG_TX;
-	dev->features = NETIF_F_SG | NETIF_F_TSO |
-		      NETIF_F_HIGHDMA | NETIF_F_IP_CSUM |
-		      NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-		      NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXCSUM;
-	dev->vlan_features = NETIF_F_SG | NETIF_F_TSO | NETIF_F_HIGHDMA |
-			NETIF_F_IP_CSUM;
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_TSO |
+				NETIF_F_IP_CSUM | NETIF_F_HW_VLAN_CTAG_TX,
+				&dev->hw_features);
+	netdev_feature_zero(&dev->features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_TSO |
+				NETIF_F_HIGHDMA | NETIF_F_IP_CSUM |
+				NETIF_F_HW_VLAN_CTAG_TX |
+				NETIF_F_HW_VLAN_CTAG_RX |
+				NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXCSUM,
+				&dev->features);
+	netdev_feature_zero(&dev->vlan_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_TSO | NETIF_F_HIGHDMA |
+				NETIF_F_IP_CSUM, &dev->vlan_features);
 	dev->watchdog_timeo = EHEA_WATCH_DOG_TIMEOUT;
 
 	/* MTU range: 68 - 9022 */
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 523c488c71f6..a2a45f39d363 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -3168,8 +3168,11 @@ static int emac_probe(struct platform_device *ofdev)
 		goto err_detach_tah;
 
 	if (dev->tah_dev) {
-		ndev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG;
-		ndev->features |= ndev->hw_features | NETIF_F_RXCSUM;
+		netdev_feature_zero(&ndev->hw_features);
+		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG,
+					&ndev->hw_features);
+		netdev_feature_copy(&ndev->features, ndev->hw_features);
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &ndev->features);
 	}
 	ndev->watchdog_timeo = 5 * HZ;
 	if (emac_phy_supports_gige(dev->phy_mode)) {
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 7884d17d666f..834a9036469a 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -754,8 +754,8 @@ static void ibmveth_fix_features(struct net_device *dev,
 	 * checksummed.
 	 */
 
-	if (!(*features & NETIF_F_RXCSUM))
-		*features &= ~NETIF_F_CSUM_MASK;
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features))
+		netdev_feature_clear_bits(NETIF_F_CSUM_MASK, features);
 }
 
 static int ibmveth_set_csum_offload(struct net_device *dev, u32 data)
@@ -803,7 +803,8 @@ static int ibmveth_set_csum_offload(struct net_device *dev, u32 data)
 					   set_attr, clr_attr, &ret_attr);
 
 			if (data == 1)
-				dev->features &= ~NETIF_F_IP_CSUM;
+				netdev_feature_clear_bit(NETIF_F_IP_CSUM_BIT,
+							 &dev->features);
 
 		} else {
 			adapter->fw_ipv4_csum_support = data;
@@ -821,7 +822,8 @@ static int ibmveth_set_csum_offload(struct net_device *dev, u32 data)
 					   set_attr6, clr_attr6, &ret_attr);
 
 			if (data == 1)
-				dev->features &= ~NETIF_F_IPV6_CSUM;
+				netdev_feature_clear_bit(NETIF_F_IPV6_CSUM_BIT,
+							 &dev->features);
 
 		} else
 			adapter->fw_ipv6_csum_support = data;
@@ -881,7 +883,9 @@ static int ibmveth_set_tso(struct net_device *dev, u32 data)
 					   set_attr, clr_attr, &ret_attr);
 
 			if (data == 1)
-				dev->features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
+				netdev_feature_clear_bits(NETIF_F_TSO |
+							  NETIF_F_TSO6,
+							  &dev->features);
 			rc1 = -EIO;
 
 		} else {
@@ -893,7 +897,8 @@ static int ibmveth_set_tso(struct net_device *dev, u32 data)
 		 * support tcp6/ipv6
 		 */
 		if (data == 1) {
-			dev->features &= ~NETIF_F_TSO6;
+			netdev_feature_clear_bit(NETIF_F_TSO6_BIT,
+						 &dev->features);
 			netdev_info(dev, "TSO feature requires all partitions to have updated driver");
 		}
 		adapter->large_send = data;
@@ -909,23 +914,32 @@ static int ibmveth_set_features(struct net_device *dev,
 	netdev_features_t features)
 {
 	struct ibmveth_adapter *adapter = netdev_priv(dev);
-	int rx_csum = !!(features & NETIF_F_RXCSUM);
-	int large_send = !!(features & (NETIF_F_TSO | NETIF_F_TSO6));
 	int rc1 = 0, rc2 = 0;
+	int large_send;
+	int rx_csum;
+
+	rx_csum = netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features);
+	large_send = netdev_feature_test_bits(NETIF_F_TSO | NETIF_F_TSO6,
+					      features);
 
 	if (rx_csum != adapter->rx_csum) {
 		rc1 = ibmveth_set_csum_offload(dev, rx_csum);
-		if (rc1 && !adapter->rx_csum)
-			dev->features =
-				features & ~(NETIF_F_CSUM_MASK |
-					     NETIF_F_RXCSUM);
+		if (rc1 && !adapter->rx_csum) {
+			netdev_feature_copy(&dev->features, features);
+			netdev_feature_clear_bits(NETIF_F_CSUM_MASK |
+						  NETIF_F_RXCSUM,
+						  &dev->features);
+		}
 	}
 
 	if (large_send != adapter->large_send) {
 		rc2 = ibmveth_set_tso(dev, large_send);
-		if (rc2 && !adapter->large_send)
-			dev->features =
-				features & ~(NETIF_F_TSO | NETIF_F_TSO6);
+		if (rc2 && !adapter->large_send) {
+			netdev_feature_copy(&dev->features, features);
+			netdev_feature_clear_bits(NETIF_F_TSO |
+						  NETIF_F_TSO6,
+						  &dev->features);
+		}
 	}
 
 	return rc1 ? rc1 : rc2;
@@ -1689,30 +1703,34 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	netdev->netdev_ops = &ibmveth_netdev_ops;
 	netdev->ethtool_ops = &netdev_ethtool_ops;
 	SET_NETDEV_DEV(netdev, &dev->dev);
-	netdev->hw_features = NETIF_F_SG;
-	if (vio_get_attribute(dev, "ibm,illan-options", NULL) != NULL) {
-		netdev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				       NETIF_F_RXCSUM;
-	}
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bit(NETIF_F_SG_BIT, &netdev->hw_features);
+	if (vio_get_attribute(dev, "ibm,illan-options", NULL) != NULL)
+		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+					NETIF_F_RXCSUM, &netdev->hw_features);
 
-	netdev->features |= netdev->hw_features;
+	netdev_feature_or(&netdev->features, netdev->features,
+			  netdev->hw_features);
 
 	ret = h_illan_attributes(adapter->vdev->unit_address, 0, 0, &ret_attr);
 
 	/* If running older firmware, TSO should not be enabled by default */
 	if (ret == H_SUCCESS && (ret_attr & IBMVETH_ILLAN_LRG_SND_SUPPORT) &&
 	    !old_large_send) {
-		netdev->hw_features |= NETIF_F_TSO | NETIF_F_TSO6;
-		netdev->features |= netdev->hw_features;
+		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6,
+					&netdev->hw_features);
+		netdev_feature_or(&netdev->features, netdev->features,
+				  netdev->hw_features);
 	} else {
-		netdev->hw_features |= NETIF_F_TSO;
+		netdev_feature_set_bit(NETIF_F_TSO_BIT, &netdev->hw_features);
 	}
 
 	adapter->is_active_trunk = false;
 	if (ret == H_SUCCESS && (ret_attr & IBMVETH_ILLAN_ACTIVE_TRUNK)) {
 		adapter->is_active_trunk = true;
-		netdev->hw_features |= NETIF_F_FRAGLIST;
-		netdev->features |= NETIF_F_FRAGLIST;
+		netdev_feature_set_bit(NETIF_F_FRAGLIST_BIT,
+				       &netdev->hw_features);
+		netdev_feature_set_bit(NETIF_F_FRAGLIST_BIT, &netdev->features);
 	}
 
 	netdev->min_mtu = IBMVETH_MIN_MTU;
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index b8ee2e3977b5..4dfabea91db6 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3013,7 +3013,7 @@ static void ibmvnic_features_check(struct sk_buff *skb, struct net_device *dev,
 	if (skb_is_gso(skb)) {
 		if (skb_shinfo(skb)->gso_size < 224 ||
 		    skb_shinfo(skb)->gso_segs == 1)
-			*features &= ~NETIF_F_GSO_MASK;
+			netdev_feature_clear_bits(NETIF_F_GSO_MASK, features);
 	}
 }
 
@@ -4511,7 +4511,7 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 	struct ibmvnic_control_ip_offload_buffer *ctrl_buf = &adapter->ip_offload_ctrl;
 	struct ibmvnic_query_ip_offload_buffer *buf = &adapter->ip_offload_buf;
 	struct device *dev = &adapter->vdev->dev;
-	netdev_features_t old_hw_features = 0;
+	netdev_features_t old_hw_features;
 	union ibmvnic_crq crq;
 
 	adapter->ip_offload_ctrl_tok =
@@ -4540,40 +4540,59 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 	ctrl_buf->large_rx_ipv4 = 0;
 	ctrl_buf->large_rx_ipv6 = 0;
 
+	netdev_feature_zero(&old_hw_features);
+
 	if (adapter->state != VNIC_PROBING) {
-		old_hw_features = adapter->netdev->hw_features;
-		adapter->netdev->hw_features = 0;
+		netdev_feature_copy(&old_hw_features,
+				    adapter->netdev->hw_features);
+		netdev_feature_zero(&adapter->netdev->hw_features);
 	}
 
-	adapter->netdev->hw_features = NETIF_F_SG | NETIF_F_GSO | NETIF_F_GRO;
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_GSO | NETIF_F_GRO,
+				&adapter->netdev->hw_features);
 
 	if (buf->tcp_ipv4_chksum || buf->udp_ipv4_chksum)
-		adapter->netdev->hw_features |= NETIF_F_IP_CSUM;
+		netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT,
+				       &adapter->netdev->hw_features);
 
 	if (buf->tcp_ipv6_chksum || buf->udp_ipv6_chksum)
-		adapter->netdev->hw_features |= NETIF_F_IPV6_CSUM;
+		netdev_feature_set_bit(NETIF_F_IPV6_CSUM_BIT,
+				       &adapter->netdev->hw_features);
 
-	if ((adapter->netdev->features &
-	    (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)))
-		adapter->netdev->hw_features |= NETIF_F_RXCSUM;
+	if (netdev_feature_test_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
+				     adapter->netdev->features))
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT,
+				       &adapter->netdev->hw_features);
 
 	if (buf->large_tx_ipv4)
-		adapter->netdev->hw_features |= NETIF_F_TSO;
+		netdev_feature_set_bit(NETIF_F_TSO_BIT,
+				       &adapter->netdev->hw_features);
 	if (buf->large_tx_ipv6)
-		adapter->netdev->hw_features |= NETIF_F_TSO6;
+		netdev_feature_set_bit(NETIF_F_TSO6_BIT,
+				       &adapter->netdev->hw_features);
 
 	if (adapter->state == VNIC_PROBING) {
-		adapter->netdev->features |= adapter->netdev->hw_features;
-	} else if (old_hw_features != adapter->netdev->hw_features) {
-		netdev_features_t tmp = 0;
+		netdev_feature_or(&adapter->netdev->features,
+				  adapter->netdev->features,
+				  adapter->netdev->hw_features);
+	} else if (!netdev_feature_equal(old_hw_features,
+					 adapter->netdev->hw_features)) {
+		netdev_features_t tmp;
+
+		netdev_feature_zero(&tmp);
 
 		/* disable features no longer supported */
-		adapter->netdev->features &= adapter->netdev->hw_features;
+		netdev_feature_and(&adapter->netdev->features,
+				   adapter->netdev->features,
+				   adapter->netdev->hw_features);
 		/* turn on features now supported if previously enabled */
-		tmp = (old_hw_features ^ adapter->netdev->hw_features) &
-			adapter->netdev->hw_features;
-		adapter->netdev->features |=
-				tmp & adapter->netdev->wanted_features;
+		netdev_feature_xor(&tmp, old_hw_features,
+				   adapter->netdev->hw_features);
+		netdev_feature_and(&tmp, tmp, adapter->netdev->hw_features);
+		netdev_feature_and(&tmp, tmp,
+				   adapter->netdev->wanted_features);
+		netdev_feature_or(&adapter->netdev->features,
+				  adapter->netdev->features, tmp);
 	}
 
 	memset(&crq, 0, sizeof(crq));
@@ -5088,7 +5107,8 @@ static void handle_query_cap_rsp(union ibmvnic_crq *crq,
 		adapter->vlan_header_insertion =
 		    be64_to_cpu(crq->query_capability.number);
 		if (adapter->vlan_header_insertion)
-			netdev->features |= NETIF_F_HW_VLAN_STAG_TX;
+			netdev_feature_set_bit(NETIF_F_HW_VLAN_STAG_TX_BIT,
+					       &netdev->features);
 		netdev_dbg(netdev, "vlan_header_insertion = %lld\n",
 			   adapter->vlan_header_insertion);
 		break;
-- 
2.33.0

