Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDE941C96A
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346394AbhI2QEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:04:04 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:23246 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345610AbhI2QAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:03 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKLbw5kZkz8tVq;
        Wed, 29 Sep 2021 23:57:16 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:09 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:08 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 088/167] net: atlantic: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:15 +0800
Message-ID: <20210929155334.12454-89-shenjian15@huawei.com>
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
 .../ethernet/aquantia/atlantic/aq_filters.c   | 12 +++++---
 .../ethernet/aquantia/atlantic/aq_macsec.c    |  2 +-
 .../net/ethernet/aquantia/atlantic/aq_main.c  | 27 ++++++++++++------
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 28 +++++++++++++------
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  2 +-
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |  3 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  3 +-
 7 files changed, 51 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
index 1bc4d33a0ce5..8d0c174be6b2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
@@ -164,7 +164,8 @@ aq_check_approve_fvlan(struct aq_nic_s *aq_nic,
 		return -EINVAL;
 	}
 
-	if ((aq_nic->ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				    aq_nic->ndev->features) &&
 	    (!test_bit(be16_to_cpu(fsp->h_ext.vlan_tci) & VLAN_VID_MASK,
 		       aq_nic->active_vlans))) {
 		netdev_err(aq_nic->ndev,
@@ -236,7 +237,8 @@ aq_rule_is_not_support(struct aq_nic_s *aq_nic,
 {
 	bool rule_is_not_support = false;
 
-	if (!(aq_nic->ndev->features & NETIF_F_NTUPLE)) {
+	if (!netdev_feature_test_bit(NETIF_F_NTUPLE_BIT,
+				     aq_nic->ndev->features)) {
 		netdev_err(aq_nic->ndev,
 			   "ethtool: Please, to enable the RX flow control:\n"
 			   "ethtool -K %s ntuple on\n", aq_nic->ndev->name);
@@ -836,7 +838,8 @@ int aq_filters_vlans_update(struct aq_nic_s *aq_nic)
 	aq_fvlan_rebuild(aq_nic, aq_nic->active_vlans,
 			 aq_nic->aq_hw_rx_fltrs.fl2.aq_vlans);
 
-	if (aq_nic->ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER) {
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				    aq_nic->ndev->features)) {
 		for (i = 0; i < BITS_TO_LONGS(VLAN_N_VID); i++)
 			hweight += hweight_long(aq_nic->active_vlans[i]);
 
@@ -851,7 +854,8 @@ int aq_filters_vlans_update(struct aq_nic_s *aq_nic)
 	if (err)
 		return err;
 
-	if (aq_nic->ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER) {
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				    aq_nic->ndev->features)) {
 		if (hweight <= AQ_VLAN_MAX_FILTERS && hweight > 0) {
 			err = aq_hw_ops->hw_filter_vlan_ctrl(aq_hw,
 				!(aq_nic->packet_filter & IFF_PROMISC));
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
index 4a6dfac857ca..0c10d8ba11c2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -1490,7 +1490,7 @@ int aq_macsec_init(struct aq_nic_s *nic)
 	if (!nic->macsec_cfg)
 		return -ENOMEM;
 
-	nic->ndev->features |= NETIF_F_HW_MACSEC;
+	netdev_feature_set_bit(NETIF_F_HW_MACSEC_BIT, &nic->ndev->features);
 	nic->ndev->macsec_ops = &aq_macsec_ops;
 
 	return 0;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index e22935ce9573..a153b99f2166 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -142,35 +142,42 @@ static int aq_ndev_change_mtu(struct net_device *ndev, int new_mtu)
 static int aq_ndev_set_features(struct net_device *ndev,
 				netdev_features_t features)
 {
-	bool is_vlan_tx_insert = !!(features & NETIF_F_HW_VLAN_CTAG_TX);
-	bool is_vlan_rx_strip = !!(features & NETIF_F_HW_VLAN_CTAG_RX);
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	bool need_ndev_restart = false;
 	struct aq_nic_cfg_s *aq_cfg;
+	bool is_vlan_tx_insert;
+	bool is_vlan_rx_strip;
 	bool is_lro = false;
 	int err = 0;
 
+	is_vlan_tx_insert = netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+						    features);
+	is_vlan_rx_strip = netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+						   features);
 	aq_cfg = aq_nic_get_cfg(aq_nic);
 
-	if (!(features & NETIF_F_NTUPLE)) {
-		if (aq_nic->ndev->features & NETIF_F_NTUPLE) {
+	if (!netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, features)) {
+		if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT,
+					    aq_nic->ndev->features)) {
 			err = aq_clear_rxnfc_all_rules(aq_nic);
 			if (unlikely(err))
 				goto err_exit;
 		}
 	}
-	if (!(features & NETIF_F_HW_VLAN_CTAG_FILTER)) {
-		if (aq_nic->ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER) {
+	if (!netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				     features)) {
+		if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					    aq_nic->ndev->features)) {
 			err = aq_filters_vlan_offload_off(aq_nic);
 			if (unlikely(err))
 				goto err_exit;
 		}
 	}
 
-	aq_cfg->features = features;
+	netdev_feature_copy(&aq_cfg->features, features);
 
 	if (aq_cfg->aq_hw_caps->hw_features & NETIF_F_LRO) {
-		is_lro = features & NETIF_F_LRO;
+		is_lro = netdev_feature_test_bit(NETIF_F_LRO_BIT, features);
 
 		if (aq_cfg->is_lro != is_lro) {
 			aq_cfg->is_lro = is_lro;
@@ -178,7 +185,9 @@ static int aq_ndev_set_features(struct net_device *ndev,
 		}
 	}
 
-	if ((aq_nic->ndev->features ^ features) & NETIF_F_RXCSUM) {
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+				    aq_nic->ndev->features) !=
+	    netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features)) {
 		err = aq_nic->aq_hw_ops->hw_set_offload(aq_nic->aq_hw,
 							aq_cfg);
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 6c049864dac0..5e73a469861d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -144,9 +144,14 @@ void aq_nic_cfg_start(struct aq_nic_s *self)
 		cfg->link_irq_vec = 0;
 
 	cfg->link_speed_msk &= cfg->aq_hw_caps->link_speed_msk;
-	cfg->features = cfg->aq_hw_caps->hw_features;
-	cfg->is_vlan_rx_strip = !!(cfg->features & NETIF_F_HW_VLAN_CTAG_RX);
-	cfg->is_vlan_tx_insert = !!(cfg->features & NETIF_F_HW_VLAN_CTAG_TX);
+	netdev_feature_zero(&cfg->features);
+	netdev_feature_set_bits(cfg->aq_hw_caps->hw_features, &cfg->features);
+	cfg->is_vlan_rx_strip =
+		netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					cfg->features);
+	cfg->is_vlan_tx_insert =
+		netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+					cfg->features);
 	cfg->is_vlan_force_promisc = true;
 
 	for (i = 0; i < sizeof(cfg->prio_tc_map); i++)
@@ -367,12 +372,17 @@ void aq_nic_ndev_init(struct aq_nic_s *self)
 	const struct aq_hw_caps_s *aq_hw_caps = self->aq_nic_cfg.aq_hw_caps;
 	struct aq_nic_cfg_s *aq_nic_cfg = &self->aq_nic_cfg;
 
-	self->ndev->hw_features |= aq_hw_caps->hw_features;
-	self->ndev->features = aq_hw_caps->hw_features;
-	self->ndev->vlan_features |= NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
-				     NETIF_F_RXHASH | NETIF_F_SG |
-				     NETIF_F_LRO | NETIF_F_TSO | NETIF_F_TSO6;
-	self->ndev->gso_partial_features = NETIF_F_GSO_UDP_L4;
+	netdev_feature_set_bits(aq_hw_caps->hw_features,
+				&self->ndev->hw_features);
+	netdev_feature_zero(&self->ndev->features);
+	netdev_feature_set_bits(aq_hw_caps->hw_features, &self->ndev->features);
+	netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
+				NETIF_F_RXHASH | NETIF_F_SG |
+				NETIF_F_LRO | NETIF_F_TSO | NETIF_F_TSO6,
+				&self->ndev->vlan_features);
+	netdev_feature_zero(&self->ndev->gso_partial_features);
+	netdev_feature_set_bit(NETIF_F_GSO_UDP_L4_BIT,
+			       &self->ndev->gso_partial_features);
 	self->ndev->priv_flags = aq_hw_caps->hw_priv_flags;
 	self->ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 1a7148041e3d..685adb52d44a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -38,7 +38,7 @@ struct aq_fc_info {
 
 struct aq_nic_cfg_s {
 	const struct aq_hw_caps_s *aq_hw_caps;
-	u64 features;
+	netdev_features_t features;
 	u32 rxds;		/* rx ring size, descriptors # */
 	u32 txds;		/* tx ring size, descriptors # */
 	u32 vecs;		/* allocated rx/tx vectors */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 24122ccda614..63f3cef1c9fc 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -318,7 +318,8 @@ static void aq_rx_checksum(struct aq_ring_s *self,
 			   struct aq_ring_buff_s *buff,
 			   struct sk_buff *skb)
 {
-	if (!(self->aq_nic->ndev->features & NETIF_F_RXCSUM))
+	if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+				     self->aq_nic->ndev->features))
 		return;
 
 	if (unlikely(buff->is_cso_err)) {
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 9f1b15077e7d..778c78bcd992 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -273,7 +273,8 @@ static int hw_atl_b0_hw_rss_set(struct aq_hw_s *self,
 int hw_atl_b0_hw_offload_set(struct aq_hw_s *self,
 			     struct aq_nic_cfg_s *aq_nic_cfg)
 {
-	u64 rxcsum = !!(aq_nic_cfg->features & NETIF_F_RXCSUM);
+	u64 rxcsum = netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					     aq_nic_cfg->features);
 	unsigned int i;
 
 	/* TX checksums offloads*/
-- 
2.33.0

