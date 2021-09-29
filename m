Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4184241C974
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346086AbhI2QF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:05:27 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:24185 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345648AbhI2QAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:06 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKLbz6m7xz8tWH;
        Wed, 29 Sep 2021 23:57:19 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:12 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:12 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 109/167] net: qlogic: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:36 +0800
Message-ID: <20210929155334.12454-110-shenjian15@huawei.com>
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
 .../ethernet/qlogic/netxen/netxen_nic_init.c  |  3 +-
 .../ethernet/qlogic/netxen/netxen_nic_main.c  | 44 ++++++++-----
 .../net/ethernet/qlogic/qede/qede_ethtool.c   |  2 +-
 .../net/ethernet/qlogic/qede/qede_filter.c    | 14 ++--
 drivers/net/ethernet/qlogic/qede/qede_fp.c    |  9 ++-
 drivers/net/ethernet/qlogic/qede/qede_main.c  | 65 ++++++++++++-------
 drivers/net/ethernet/qlogic/qla3xxx.c         |  5 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    | 57 +++++++++-------
 .../net/ethernet/qlogic/qlcnic/qlcnic_io.c    |  3 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  | 48 ++++++++------
 10 files changed, 152 insertions(+), 98 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
index 35ec9aab3dc7..ffa7b517d470 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
@@ -1497,7 +1497,8 @@ static struct sk_buff *netxen_process_rxbuf(struct netxen_adapter *adapter,
 	if (!skb)
 		goto no_skb;
 
-	if (likely((adapter->netdev->features & NETIF_F_RXCSUM)
+	if (likely(netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					   adapter->netdev->features)
 	    && cksum == STATUS_CKSUM_OK)) {
 		adapter->stats.csummed++;
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 251668839926..487b2039a7b3 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -520,10 +520,10 @@ static void netxen_set_multicast_list(struct net_device *dev)
 static void netxen_fix_features(struct net_device *dev,
 				netdev_features_t *features)
 {
-	if (!(*features & NETIF_F_RXCSUM)) {
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features)) {
 		netdev_info(dev, "disabling LRO as RXCSUM is off\n");
 
-		*features &= ~NETIF_F_LRO;
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
 	}
 }
 
@@ -533,16 +533,18 @@ static int netxen_set_features(struct net_device *dev,
 	struct netxen_adapter *adapter = netdev_priv(dev);
 	int hw_lro;
 
-	if (!((dev->features ^ features) & NETIF_F_LRO))
+	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, dev->features) ==
+	    netdev_feature_test_bit(NETIF_F_LRO_BIT, features))
 		return 0;
 
-	hw_lro = (features & NETIF_F_LRO) ? NETXEN_NIC_LRO_ENABLED
-	         : NETXEN_NIC_LRO_DISABLED;
+	hw_lro = netdev_feature_test_bit(NETIF_F_LRO_BIT, features) ?
+		NETXEN_NIC_LRO_ENABLED : NETXEN_NIC_LRO_DISABLED;
 
 	if (netxen_config_hw_lro(adapter, hw_lro))
 		return -EIO;
 
-	if (!(features & NETIF_F_LRO) && netxen_send_lro_cleanup(adapter))
+	if (!netdev_feature_test_bit(NETIF_F_LRO_BIT, features) &&
+	    netxen_send_lro_cleanup(adapter))
 		return -EIO;
 
 	return 0;
@@ -1116,7 +1118,7 @@ __netxen_nic_up(struct netxen_adapter *adapter, struct net_device *netdev)
 	if (NX_IS_REVISION_P3(adapter->ahw.revision_id))
 		netxen_config_intr_coalesce(adapter);
 
-	if (netdev->features & NETIF_F_LRO)
+	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, netdev->features))
 		netxen_config_hw_lro(adapter, NETXEN_NIC_LRO_ENABLED);
 
 	netxen_napi_enable(adapter);
@@ -1343,26 +1345,33 @@ netxen_setup_netdev(struct netxen_adapter *adapter,
 
 	netdev->ethtool_ops = &netxen_nic_ethtool_ops;
 
-	netdev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-	                      NETIF_F_RXCSUM;
+	netdev_feature_zero(&netdev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
+				NETIF_F_RXCSUM, &netdev->hw_features);
 
 	if (NX_IS_REVISION_P3(adapter->ahw.revision_id))
-		netdev->hw_features |= NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
+		netdev_feature_set_bits(NETIF_F_IPV6_CSUM | NETIF_F_TSO6,
+					&netdev->hw_features);
 
-	netdev->vlan_features |= netdev->hw_features;
+	netdev_feature_or(&netdev->vlan_features, netdev->vlan_features,
+			  netdev->hw_features);
 
 	if (adapter->pci_using_dac) {
-		netdev->features |= NETIF_F_HIGHDMA;
-		netdev->vlan_features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
+				       &netdev->vlan_features);
 	}
 
 	if (adapter->capabilities & NX_FW_CAPABILITY_FVLANTX)
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				       &netdev->hw_features);
 
 	if (adapter->capabilities & NX_FW_CAPABILITY_HW_LRO)
-		netdev->hw_features |= NETIF_F_LRO;
+		netdev_feature_set_bit(NETIF_F_LRO_BIT,
+				       &netdev->hw_features);
 
-	netdev->features |= netdev->hw_features;
+	netdev_feature_or(&netdev->features, netdev->features,
+			  netdev->hw_features);
 
 	netdev->irq = adapter->msix_entries[0].vector;
 
@@ -1870,7 +1879,8 @@ netxen_tso_check(struct net_device *netdev,
 		vlan_oob = 1;
 	}
 
-	if ((netdev->features & (NETIF_F_TSO | NETIF_F_TSO6)) &&
+	if (netdev_feature_test_bits(NETIF_F_TSO | NETIF_F_TSO6,
+				     netdev->features) &&
 			skb_shinfo(skb)->gso_size > 0) {
 
 		hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 8284c4c1528f..5a1c975c00e1 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -1027,7 +1027,7 @@ int qede_change_mtu(struct net_device *ndev, int new_mtu)
 		   "Configuring MTU size of %d\n", new_mtu);
 
 	if (new_mtu > PAGE_SIZE)
-		ndev->features &= ~NETIF_F_GRO_HW;
+		netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT, &ndev->features);
 
 	/* Set the mtu field and re-start the interface if needed */
 	args.u.mtu = new_mtu;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index ea89a3afa206..9fe5762b4eb6 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -907,7 +907,7 @@ void qede_vlan_mark_nonconfigured(struct qede_dev *edev)
 static void qede_set_features_reload(struct qede_dev *edev,
 				     struct qede_reload_args *args)
 {
-	edev->ndev->features = args->u.features;
+	netdev_feature_copy(&edev->ndev->features, args->u.features);
 }
 
 void qede_fix_features(struct net_device *dev, netdev_features_t *features)
@@ -915,23 +915,25 @@ void qede_fix_features(struct net_device *dev, netdev_features_t *features)
 	struct qede_dev *edev = netdev_priv(dev);
 
 	if (edev->xdp_prog || edev->ndev->mtu > PAGE_SIZE ||
-	    !(*features & NETIF_F_GRO))
-		*features &= ~NETIF_F_GRO_HW;
+	    !netdev_feature_test_bit(NETIF_F_GRO_BIT, *features))
+		netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT, features);
 }
 
 int qede_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct qede_dev *edev = netdev_priv(dev);
-	netdev_features_t changes = features ^ dev->features;
+	netdev_features_t changes;
 	bool need_reload = false;
 
-	if (changes & NETIF_F_GRO_HW)
+	netdev_feature_xor(&changes, features, dev->features);
+
+	if (netdev_feature_test_bit(NETIF_F_GRO_HW_BIT, changes))
 		need_reload = true;
 
 	if (need_reload) {
 		struct qede_reload_args args;
 
-		args.u.features = features;
+		netdev_feature_copy(&args.u.features, features);
 		args.func = &qede_set_features_reload;
 
 		/* Make sure that we definitely need to reload.
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 8a459d2ca983..2d49c95c8b45 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1780,15 +1780,18 @@ void qede_features_check(struct sk_buff *skb, struct net_device *dev,
 			     skb_transport_header(skb)) > hdrlen ||
 			     (ntohs(udp_hdr(skb)->dest) != vxln_port &&
 			      ntohs(udp_hdr(skb)->dest) != gnv_port)) {
-				*features &= ~(NETIF_F_CSUM_MASK |
-					       NETIF_F_GSO_MASK);
+				netdev_feature_clear_bits(NETIF_F_CSUM_MASK |
+							  NETIF_F_GSO_MASK,
+							  features);
 				return;
 			}
 		} else if (l4_proto == IPPROTO_IPIP) {
 			/* IPIP tunnels are unknown to the device or at least unsupported natively,
 			 * offloads for them can't be done trivially, so disable them for such skb.
 			 */
-			*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+			netdev_feature_clear_bits(NETIF_F_CSUM_MASK |
+						  NETIF_F_GSO_MASK,
+						  features);
 			return;
 		}
 	}
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index ee4c3bd28a93..e7c3139af274 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -789,47 +789,59 @@ static void qede_init_ndev(struct qede_dev *edev)
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 
 	/* user-changeble features */
-	hw_features = NETIF_F_GRO | NETIF_F_GRO_HW | NETIF_F_SG |
-		      NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		      NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_HW_TC;
+	netdev_feature_zero(&hw_features);
+	netdev_feature_set_bits(NETIF_F_GRO | NETIF_F_GRO_HW | NETIF_F_SG |
+				NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_HW_TC,
+				&hw_features);
 
 	if (edev->dev_info.common.b_arfs_capable)
-		hw_features |= NETIF_F_NTUPLE;
+		netdev_feature_set_bit(NETIF_F_NTUPLE_BIT, &hw_features);
 
 	if (edev->dev_info.common.vxlan_enable ||
 	    edev->dev_info.common.geneve_enable)
 		udp_tunnel_enable = true;
 
 	if (udp_tunnel_enable || edev->dev_info.common.gre_enable) {
-		hw_features |= NETIF_F_TSO_ECN;
-		ndev->hw_enc_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+		netdev_feature_set_bit(NETIF_F_TSO_ECN_BIT, &hw_features);
+		netdev_feature_zero(&ndev->hw_enc_features);
+		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 					NETIF_F_SG | NETIF_F_TSO |
 					NETIF_F_TSO_ECN | NETIF_F_TSO6 |
-					NETIF_F_RXCSUM;
+					NETIF_F_RXCSUM,
+					&ndev->hw_enc_features);
 	}
 
 	if (udp_tunnel_enable) {
-		hw_features |= (NETIF_F_GSO_UDP_TUNNEL |
-				NETIF_F_GSO_UDP_TUNNEL_CSUM);
-		ndev->hw_enc_features |= (NETIF_F_GSO_UDP_TUNNEL |
-					  NETIF_F_GSO_UDP_TUNNEL_CSUM);
+		netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL |
+					NETIF_F_GSO_UDP_TUNNEL_CSUM,
+					&hw_features);
+		netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL |
+					NETIF_F_GSO_UDP_TUNNEL_CSUM,
+					&ndev->hw_enc_features);
 
 		qede_set_udp_tunnels(edev);
 	}
 
 	if (edev->dev_info.common.gre_enable) {
-		hw_features |= (NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM);
-		ndev->hw_enc_features |= (NETIF_F_GSO_GRE |
-					  NETIF_F_GSO_GRE_CSUM);
+		netdev_feature_set_bits(NETIF_F_GSO_GRE |
+					NETIF_F_GSO_GRE_CSUM,
+					&hw_features);
+		netdev_feature_set_bits(NETIF_F_GSO_GRE |
+					NETIF_F_GSO_GRE_CSUM,
+					&ndev->hw_enc_features);
 	}
 
-	ndev->vlan_features = hw_features | NETIF_F_RXHASH | NETIF_F_RXCSUM |
-			      NETIF_F_HIGHDMA;
-	ndev->features = hw_features | NETIF_F_RXHASH | NETIF_F_RXCSUM |
-			 NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HIGHDMA |
-			 NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_TX;
+	netdev_feature_copy(&ndev->vlan_features, hw_features);
+	netdev_feature_set_bits(NETIF_F_RXHASH | NETIF_F_RXCSUM |
+				NETIF_F_HIGHDMA, &ndev->vlan_features);
+	netdev_feature_copy(&ndev->features, hw_features);
+	netdev_feature_set_bits(NETIF_F_RXHASH | NETIF_F_RXCSUM |
+				NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HIGHDMA |
+				NETIF_F_HW_VLAN_CTAG_FILTER |
+				NETIF_F_HW_VLAN_CTAG_TX, &ndev->features);
 
-	ndev->hw_features = hw_features;
+	netdev_feature_copy(&ndev->hw_features, hw_features);
 
 	/* MTU range: 46 - 9600 */
 	ndev->min_mtu = ETH_ZLEN - ETH_HLEN;
@@ -1493,7 +1505,8 @@ static int qede_alloc_mem_rxq(struct qede_dev *edev, struct qede_rx_queue *rxq)
 		rxq->rx_buf_seg_size = roundup_pow_of_two(size);
 	} else {
 		rxq->rx_buf_seg_size = PAGE_SIZE;
-		edev->ndev->features &= ~NETIF_F_GRO_HW;
+		netdev_feature_clear_bit(NETIF_F_GRO_HW_BIT,
+					 &edev->ndev->features);
 	}
 
 	/* Allocate the parallel driver ring for Rx buffers */
@@ -1534,7 +1547,8 @@ static int qede_alloc_mem_rxq(struct qede_dev *edev, struct qede_rx_queue *rxq)
 		}
 	}
 
-	edev->gro_disable = !(edev->ndev->features & NETIF_F_GRO_HW);
+	edev->gro_disable = !netdev_feature_test_bit(NETIF_F_GRO_HW_BIT,
+						     edev->ndev->features);
 	if (!edev->gro_disable)
 		qede_set_tpa_param(rxq);
 err:
@@ -2383,7 +2397,8 @@ static int qede_load(struct qede_dev *edev, enum qede_load_mode mode,
 		goto err2;
 
 	if (qede_alloc_arfs(edev)) {
-		edev->ndev->features &= ~NETIF_F_NTUPLE;
+		netdev_feature_clear_bit(NETIF_F_NTUPLE_BIT,
+					 &edev->ndev->features);
 		edev->dev_info.common.b_arfs_capable = false;
 	}
 
@@ -2718,9 +2733,9 @@ static void qede_get_generic_tlv_data(void *dev, struct qed_generic_tlvs *data)
 	struct netdev_hw_addr *ha;
 	int i;
 
-	if (edev->ndev->features & NETIF_F_IP_CSUM)
+	if (netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT, edev->ndev->features))
 		data->feat_flags |= QED_TLV_IP_CSUM;
-	if (edev->ndev->features & NETIF_F_TSO)
+	if (netdev_feature_test_bit(NETIF_F_TSO_BIT, edev->ndev->features))
 		data->feat_flags |= QED_TLV_LSO;
 
 	ether_addr_copy(data->mac[0], edev->ndev->dev_addr);
diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index c00ad57575ea..c396ee012915 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -3797,9 +3797,10 @@ static int ql3xxx_probe(struct pci_dev *pdev,
 	qdev->msg_enable = netif_msg_init(debug, default_msg);
 
 	if (pci_using_dac)
-		ndev->features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &ndev->features);
 	if (qdev->device_id == QL3032_DEVICE_ID)
-		ndev->features |= NETIF_F_IP_CSUM | NETIF_F_SG;
+		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_SG,
+					&ndev->features);
 
 	qdev->mem_map_registers = pci_ioremap_bar(pdev, 1);
 	if (!qdev->mem_map_registers) {
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index 2367923e3e3f..625fcf3ecb12 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -1026,27 +1026,33 @@ static void qlcnic_process_flags(struct qlcnic_adapter *adapter,
 	u32 offload_flags = adapter->offload_flags;
 
 	if (offload_flags & BIT_0) {
-		*features |= NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
-			     NETIF_F_IPV6_CSUM;
+		netdev_feature_set_bits(NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
+					NETIF_F_IPV6_CSUM, features);
 		adapter->rx_csum = 1;
 		if (QLCNIC_IS_TSO_CAPABLE(adapter)) {
 			if (!(offload_flags & BIT_1))
-				*features &= ~NETIF_F_TSO;
+				netdev_feature_clear_bit(NETIF_F_TSO_BIT,
+							 features);
 			else
-				*features |= NETIF_F_TSO;
+				netdev_feature_set_bit(NETIF_F_TSO_BIT,
+						       features);
 
 			if (!(offload_flags & BIT_2))
-				*features &= ~NETIF_F_TSO6;
+				netdev_feature_clear_bit(NETIF_F_TSO6_BIT,
+							 features);
 			else
-				*features |= NETIF_F_TSO6;
+				netdev_feature_set_bit(NETIF_F_TSO6_BIT,
+						       features);
 		}
 	} else {
-		*features &= ~(NETIF_F_RXCSUM |
-			      NETIF_F_IP_CSUM |
-			      NETIF_F_IPV6_CSUM);
+		netdev_feature_clear_bits(NETIF_F_RXCSUM |
+					  NETIF_F_IP_CSUM |
+					  NETIF_F_IPV6_CSUM,
+					  features);
 
 		if (QLCNIC_IS_TSO_CAPABLE(adapter))
-			*features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
+			netdev_feature_clear_bits(NETIF_F_TSO | NETIF_F_TSO6,
+						  features);
 		adapter->rx_csum = 0;
 	}
 }
@@ -1061,30 +1067,37 @@ void qlcnic_fix_features(struct net_device *netdev, netdev_features_t *features)
 		if (adapter->flags & QLCNIC_APP_CHANGED_FLAGS) {
 			qlcnic_process_flags(adapter, features);
 		} else {
-			changed = *features ^ netdev->features;
-			*features ^= changed & (NETIF_F_RXCSUM |
-					       NETIF_F_IP_CSUM |
-					       NETIF_F_IPV6_CSUM |
-					       NETIF_F_TSO |
-					       NETIF_F_TSO6);
+			netdev_feature_xor(&changed, *features,
+					   netdev->features);
+			netdev_feature_and_bits(NETIF_F_RXCSUM |
+						NETIF_F_IP_CSUM |
+						NETIF_F_IPV6_CSUM |
+						NETIF_F_TSO |
+						NETIF_F_TSO6,
+						&changed);
+			netdev_feature_xor(features, *features, changed);
 		}
 	}
 
-	if (!(*features & NETIF_F_RXCSUM))
-		*features &= ~NETIF_F_LRO;
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, *features))
+		netdev_feature_clear_bit(NETIF_F_LRO_BIT, features);
 }
 
 
 int qlcnic_set_features(struct net_device *netdev, netdev_features_t features)
 {
 	struct qlcnic_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed = netdev->features ^ features;
-	int hw_lro = (features & NETIF_F_LRO) ? QLCNIC_LRO_ENABLED : 0;
+	netdev_features_t changed;
+	int hw_lro;
+
+	netdev_feature_xor(&changed, netdev->features, features);
+	hw_lro = netdev_feature_test_bit(NETIF_F_LRO_BIT, features) ?
+		QLCNIC_LRO_ENABLED : 0;
 
-	if (!(changed & NETIF_F_LRO))
+	if (!netdev_feature_test_bit(NETIF_F_LRO_BIT, changed))
 		return 0;
 
-	netdev->features ^= NETIF_F_LRO;
+	netdev_feature_change_bit(NETIF_F_LRO_BIT, &netdev->features);
 
 	if (qlcnic_config_hw_lro(adapter, hw_lro))
 		return -EIO;
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
index 29cdcb2285b1..364bf94e5fd1 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
@@ -1151,7 +1151,8 @@ static struct sk_buff *qlcnic_process_rxbuf(struct qlcnic_adapter *adapter,
 			 DMA_FROM_DEVICE);
 
 	skb = buffer->skb;
-	if (likely((adapter->netdev->features & NETIF_F_RXCSUM) &&
+	if (likely(netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					   adapter->netdev->features) &&
 		   (cksum == STATUS_CKSUM_OK || cksum == STATUS_CKSUM_LOOP))) {
 		adapter->stats.csummed++;
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 192d74665c20..53f33fb6d80b 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -1886,7 +1886,7 @@ int __qlcnic_up(struct qlcnic_adapter *adapter, struct net_device *netdev)
 
 	qlcnic_config_def_intr_coalesce(adapter);
 
-	if (netdev->features & NETIF_F_LRO)
+	if (netdev_feature_test_bit(NETIF_F_LRO_BIT, netdev->features))
 		qlcnic_config_hw_lro(adapter, QLCNIC_LRO_ENABLED);
 
 	set_bit(__QLCNIC_DEV_UP, &adapter->state);
@@ -2275,48 +2275,56 @@ qlcnic_setup_netdev(struct qlcnic_adapter *adapter, struct net_device *netdev,
 	netdev->ethtool_ops = (qlcnic_sriov_vf_check(adapter)) ?
 		&qlcnic_sriov_vf_ethtool_ops : &qlcnic_ethtool_ops;
 
-	netdev->features |= (NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
-			     NETIF_F_IPV6_CSUM | NETIF_F_GRO |
-			     NETIF_F_HW_VLAN_CTAG_RX);
-	netdev->vlan_features |= (NETIF_F_SG | NETIF_F_IP_CSUM |
-				  NETIF_F_IPV6_CSUM);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
+				NETIF_F_IPV6_CSUM | NETIF_F_GRO |
+				NETIF_F_HW_VLAN_CTAG_RX, &netdev->features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_IP_CSUM |
+				NETIF_F_IPV6_CSUM, &netdev->vlan_features);
 
 	if (QLCNIC_IS_TSO_CAPABLE(adapter)) {
-		netdev->features |= (NETIF_F_TSO | NETIF_F_TSO6);
-		netdev->vlan_features |= (NETIF_F_TSO | NETIF_F_TSO6);
+		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6,
+					&netdev->features);
+		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6,
+					&netdev->vlan_features);
 	}
 
 	if (pci_using_dac) {
-		netdev->features |= NETIF_F_HIGHDMA;
-		netdev->vlan_features |= NETIF_F_HIGHDMA;
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &netdev->features);
+		netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT,
+				       &netdev->vlan_features);
 	}
 
 	if (qlcnic_vlan_tx_check(adapter))
-		netdev->features |= (NETIF_F_HW_VLAN_CTAG_TX);
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				       &netdev->features);
 
 	if (qlcnic_sriov_vf_check(adapter))
-		netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       &netdev->features);
 
 	if (adapter->ahw->capabilities & QLCNIC_FW_CAPABILITY_HW_LRO)
-		netdev->features |= NETIF_F_LRO;
+		netdev_feature_set_bit(NETIF_F_LRO_BIT, &netdev->features);
 
 	if (qlcnic_encap_tx_offload(adapter)) {
-		netdev->features |= NETIF_F_GSO_UDP_TUNNEL;
+		netdev_feature_set_bit(NETIF_F_GSO_UDP_TUNNEL_BIT,
+				       &netdev->features);
 
 		/* encapsulation Tx offload supported by Adapter */
-		netdev->hw_enc_features = NETIF_F_IP_CSUM        |
-					  NETIF_F_GSO_UDP_TUNNEL |
-					  NETIF_F_TSO            |
-					  NETIF_F_TSO6;
+		netdev_feature_set_bits(NETIF_F_IP_CSUM		|
+					NETIF_F_GSO_UDP_TUNNEL	|
+					NETIF_F_TSO		|
+					NETIF_F_TSO6,
+					&netdev->hw_enc_features);
 	}
 
 	if (qlcnic_encap_rx_offload(adapter)) {
-		netdev->hw_enc_features |= NETIF_F_RXCSUM;
+		netdev_feature_set_bit(NETIF_F_RXCSUM_BIT,
+				       &netdev->hw_enc_features);
 
 		netdev->udp_tunnel_nic_info = &qlcnic_udp_tunnels;
 	}
 
-	netdev->hw_features = netdev->features;
+	netdev_feature_copy(&netdev->hw_features, netdev->features);
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 	netdev->irq = adapter->msix_entries[0].vector;
 
-- 
2.33.0

