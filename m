Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369D55BBCFA
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiIRJuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiIRJt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:49:56 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624C712099
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:49 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MVjbr30WtzlVm5;
        Sun, 18 Sep 2022 17:45:44 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:47 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 05/55] net: atlantic: replace const features initialization with NETDEV_FEATURE_SET
Date:   Sun, 18 Sep 2022 09:42:46 +0000
Message-ID: <20220918094336.28958-6-shenjian15@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918094336.28958-1-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The atlantic driver uses netdev features in global structure
initialization. Changed the netdev_features_t memeber to
netdev_features_t *, and make it refer to a global constant
netdev_features_t variable.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/aquantia/atlantic/aq_hw.h    |  2 +-
 .../net/ethernet/aquantia/atlantic/aq_main.c  | 51 ++++++++++++++++++-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  6 +--
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  6 ++-
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      |  8 +--
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 15 +-----
 .../aquantia/atlantic/hw_atl2/hw_atl2.c       | 15 +-----
 7 files changed, 62 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
index dbd284660135..b4ee2625fbba 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw.h
@@ -43,7 +43,7 @@ enum aq_tc_mode {
 
 /* NIC H/W capabilities */
 struct aq_hw_caps_s {
-	u64 hw_features;
+	const netdev_features_t *hw_features;
 	u64 link_speed_msk;
 	unsigned int hw_priv_flags;
 	u32 media_type;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 88595863d8bc..2cee6182cc76 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -17,6 +17,7 @@
 #include "aq_vec.h"
 
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/module.h>
 #include <linux/ip.h>
 #include <linux/udp.h>
@@ -36,6 +37,10 @@ static const struct net_device_ops aq_ndev_ops;
 
 static struct workqueue_struct *aq_ndev_wq;
 
+netdev_features_t hw_atl2_features __ro_after_init;
+netdev_features_t hw_atl_a0_features __ro_after_init;
+netdev_features_t hw_atl_b0_features __ro_after_init;
+
 void aq_ndev_schedule_work(struct work_struct *work)
 {
 	queue_work(aq_ndev_wq, work);
@@ -184,7 +189,7 @@ static int aq_ndev_set_features(struct net_device *ndev,
 
 	aq_cfg->features = features;
 
-	if (aq_cfg->aq_hw_caps->hw_features & NETIF_F_LRO) {
+	if (*aq_cfg->aq_hw_caps->hw_features & NETIF_F_LRO) {
 		is_lro = features & NETIF_F_LRO;
 
 		if (aq_cfg->is_lro != is_lro) {
@@ -511,6 +516,48 @@ static const struct net_device_ops aq_ndev_ops = {
 	.ndo_xdp_xmit = aq_xdp_xmit,
 };
 
+static void __init aq_features_init(void)
+{
+	netdev_features_set_set(hw_atl2_features,
+				NETIF_F_HW_CSUM_BIT,
+				NETIF_F_RXCSUM_BIT,
+				NETIF_F_RXHASH_BIT,
+				NETIF_F_SG_BIT,
+				NETIF_F_TSO_BIT,
+				NETIF_F_TSO6_BIT,
+				NETIF_F_LRO_BIT,
+				NETIF_F_NTUPLE_BIT,
+				NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				NETIF_F_GSO_UDP_L4_BIT,
+				NETIF_F_GSO_PARTIAL_BIT,
+				NETIF_F_HW_TC_BIT);
+	netdev_features_set_set(hw_atl_a0_features,
+				NETIF_F_HW_CSUM_BIT,
+				NETIF_F_RXHASH_BIT,
+				NETIF_F_RXCSUM_BIT,
+				NETIF_F_SG_BIT,
+				NETIF_F_TSO_BIT,
+				NETIF_F_NTUPLE_BIT,
+				NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
+	netdev_features_set_set(hw_atl_b0_features,
+				NETIF_F_HW_CSUM_BIT,
+				NETIF_F_RXCSUM_BIT,
+				NETIF_F_RXHASH_BIT,
+				NETIF_F_SG_BIT,
+				NETIF_F_TSO_BIT,
+				NETIF_F_TSO6_BIT,
+				NETIF_F_LRO_BIT,
+				NETIF_F_NTUPLE_BIT,
+				NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				NETIF_F_GSO_UDP_L4_BIT,
+				NETIF_F_GSO_PARTIAL_BIT,
+				NETIF_F_HW_TC_BIT);
+}
+
 static int __init aq_ndev_init_module(void)
 {
 	int ret;
@@ -527,6 +574,8 @@ static int __init aq_ndev_init_module(void)
 		return ret;
 	}
 
+	aq_features_init();
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 11b3425562fe..d678db5bce42 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -145,7 +145,7 @@ void aq_nic_cfg_start(struct aq_nic_s *self)
 		cfg->link_irq_vec = 0;
 
 	cfg->link_speed_msk &= cfg->aq_hw_caps->link_speed_msk;
-	cfg->features = cfg->aq_hw_caps->hw_features;
+	cfg->features = *cfg->aq_hw_caps->hw_features;
 	cfg->is_vlan_rx_strip = !!(cfg->features & NETIF_F_HW_VLAN_CTAG_RX);
 	cfg->is_vlan_tx_insert = !!(cfg->features & NETIF_F_HW_VLAN_CTAG_TX);
 	cfg->is_vlan_force_promisc = true;
@@ -372,8 +372,8 @@ void aq_nic_ndev_init(struct aq_nic_s *self)
 	const struct aq_hw_caps_s *aq_hw_caps = self->aq_nic_cfg.aq_hw_caps;
 	struct aq_nic_cfg_s *aq_nic_cfg = &self->aq_nic_cfg;
 
-	self->ndev->hw_features |= aq_hw_caps->hw_features;
-	self->ndev->features = aq_hw_caps->hw_features;
+	self->ndev->hw_features |= *aq_hw_caps->hw_features;
+	self->ndev->features = *aq_hw_caps->hw_features;
 	netdev_vlan_features_set_set(self->ndev, NETIF_F_HW_CSUM_BIT,
 				     NETIF_F_RXCSUM_BIT, NETIF_F_RXHASH_BIT,
 				     NETIF_F_SG_BIT, NETIF_F_LRO_BIT,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 935ba889bd9a..cf9ac3084e3f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -26,6 +26,10 @@ struct aq_macsec_cfg;
 struct aq_ptp_s;
 enum aq_rx_filter_type;
 
+extern netdev_features_t hw_atl2_features __ro_after_init;
+extern netdev_features_t hw_atl_a0_features __ro_after_init;
+extern netdev_features_t hw_atl_b0_features __ro_after_init;
+
 enum aq_fc_mode {
 	AQ_NIC_FC_OFF = 0,
 	AQ_NIC_FC_TX,
@@ -40,7 +44,7 @@ struct aq_fc_info {
 
 struct aq_nic_cfg_s {
 	const struct aq_hw_caps_s *aq_hw_caps;
-	u64 features;
+	netdev_features_t features;
 	u32 rxds;		/* rx ring size, descriptors # */
 	u32 txds;		/* tx ring size, descriptors # */
 	u32 vecs;		/* allocated rx/tx vectors */
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
index 9dfd68f0fda9..539e90af7615 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
@@ -34,13 +34,7 @@
 	.txhwb_alignment = 4096U,		     \
 	.tx_rings = HW_ATL_A0_TX_RINGS,		     \
 	.rx_rings = HW_ATL_A0_RX_RINGS,		     \
-	.hw_features = NETIF_F_HW_CSUM |	     \
-			NETIF_F_RXHASH |	     \
-			NETIF_F_RXCSUM |	     \
-			NETIF_F_SG |		     \
-			NETIF_F_TSO |		     \
-			NETIF_F_NTUPLE |	     \
-			NETIF_F_HW_VLAN_CTAG_FILTER, \
+	.hw_features = &hw_atl_a0_features,          \
 	.hw_priv_flags = IFF_UNICAST_FLT,	     \
 	.flow_control = true,			     \
 	.mtu = HW_ATL_A0_MTU_JUMBO,		     \
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 54e70f07b573..0ba71726238a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -36,20 +36,7 @@
 	.txhwb_alignment = 4096U,	  \
 	.tx_rings = HW_ATL_B0_TX_RINGS,   \
 	.rx_rings = HW_ATL_B0_RX_RINGS,   \
-	.hw_features = NETIF_F_HW_CSUM |  \
-			NETIF_F_RXCSUM |  \
-			NETIF_F_RXHASH |  \
-			NETIF_F_SG |      \
-			NETIF_F_TSO |     \
-			NETIF_F_TSO6 |    \
-			NETIF_F_LRO |     \
-			NETIF_F_NTUPLE |  \
-			NETIF_F_HW_VLAN_CTAG_FILTER | \
-			NETIF_F_HW_VLAN_CTAG_RX |     \
-			NETIF_F_HW_VLAN_CTAG_TX |     \
-			NETIF_F_GSO_UDP_L4      |     \
-			NETIF_F_GSO_PARTIAL |         \
-			NETIF_F_HW_TC,                \
+	.hw_features = &hw_atl_b0_features, \
 	.hw_priv_flags = IFF_UNICAST_FLT, \
 	.flow_control = true,		  \
 	.mtu = HW_ATL_B0_MTU_JUMBO,	  \
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
index 5dfc751572ed..34613222e9ff 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -37,20 +37,7 @@ static int hw_atl2_act_rslvr_table_set(struct aq_hw_s *self, u8 location,
 	.txhwb_alignment = 4096U,	  \
 	.tx_rings = HW_ATL2_TX_RINGS,   \
 	.rx_rings = HW_ATL2_RX_RINGS,   \
-	.hw_features = NETIF_F_HW_CSUM |  \
-			NETIF_F_RXCSUM |  \
-			NETIF_F_RXHASH |  \
-			NETIF_F_SG |      \
-			NETIF_F_TSO |     \
-			NETIF_F_TSO6 |    \
-			NETIF_F_LRO |     \
-			NETIF_F_NTUPLE |  \
-			NETIF_F_HW_VLAN_CTAG_FILTER | \
-			NETIF_F_HW_VLAN_CTAG_RX |     \
-			NETIF_F_HW_VLAN_CTAG_TX |     \
-			NETIF_F_GSO_UDP_L4      |     \
-			NETIF_F_GSO_PARTIAL     |     \
-			NETIF_F_HW_TC,                \
+	.hw_features = &hw_atl2_features, \
 	.hw_priv_flags = IFF_UNICAST_FLT, \
 	.flow_control = true,		  \
 	.mtu = HW_ATL2_MTU_JUMBO,	  \
-- 
2.33.0

