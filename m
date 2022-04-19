Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECBC50621A
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 04:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344950AbiDSCbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 22:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344630AbiDSCai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 22:30:38 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789002E6A7
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 19:27:56 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Kj73z4HdDz1GCYb;
        Tue, 19 Apr 2022 10:27:11 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 10:27:54 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>,
        <lipeng321@huawei.com>
Subject: [RFCv6 PATCH net-next 06/19] net: adjust variables definition for netdev_features_t
Date:   Tue, 19 Apr 2022 10:21:53 +0800
Message-ID: <20220419022206.36381-7-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220419022206.36381-1-shenjian15@huawei.com>
References: <20220419022206.36381-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the prototype of netdev_features_t will be changed to be
structure with bitmap, it's unable to be initialized when
define it. So adjust it.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c |  4 +++-
 drivers/net/ethernet/sfc/ef10.c                 |  3 ++-
 drivers/net/ethernet/sfc/efx_common.c           |  3 ++-
 drivers/net/ethernet/sfc/falcon/efx.c           |  3 ++-
 net/core/dev.c                                  | 14 ++++++++++----
 net/ethtool/features.c                          |  4 +++-
 net/ethtool/ioctl.c                             | 14 ++++++++++----
 7 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 0234d9755a9f..34484d599e1b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2405,12 +2405,14 @@ static int hns3_nic_do_ioctl(struct net_device *netdev,
 static int hns3_nic_set_features(struct net_device *netdev,
 				 netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = priv->ae_handle;
+	netdev_features_t changed;
 	bool enable;
 	int ret;
 
+	changed = netdev->features ^ features;
+
 	if (changed & (NETIF_F_GRO_HW) && h->ae_algo->ops->set_gro_en) {
 		enable = !!(features & NETIF_F_GRO_HW);
 		ret = h->ae_algo->ops->set_gro_en(h, enable);
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 01bc65ba0d31..42cc17a1d540 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1310,7 +1310,7 @@ DECLARE_NETDEV_FEATURE_SET(ef10_tso_feature_set,
 static int efx_ef10_init_nic(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-	netdev_features_t hw_enc_features = 0;
+	netdev_features_t hw_enc_features;
 	int rc;
 
 	if (nic_data->must_check_datapath_caps) {
@@ -1355,6 +1355,7 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 		nic_data->must_restore_piobufs = false;
 	}
 
+	netdev_features_zero(&hw_enc_features);
 	/* add encapsulated checksum offload features */
 	if (efx_has_cap(efx, VXLAN_NVGRE) && !efx_ef10_is_vf(efx))
 		hw_enc_features |= netdev_ip_csum_features;
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 815acba14394..4b890e68c5de 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -367,8 +367,8 @@ void efx_start_monitor(struct efx_nic *efx)
  */
 static void efx_start_datapath(struct efx_nic *efx)
 {
-	netdev_features_t old_features = efx->net_dev->features;
 	bool old_rx_scatter = efx->rx_scatter;
+	netdev_features_t old_features;
 	size_t rx_buf_len;
 
 	/* Calculate the rx buffer allocation parameters required to
@@ -413,6 +413,7 @@ static void efx_start_datapath(struct efx_nic *efx)
 	/* Restore previously fixed features in hw_features and remove
 	 * features which are fixed now
 	 */
+	old_features = efx->net_dev->features;
 	efx->net_dev->hw_features |= efx->net_dev->features;
 	efx->net_dev->hw_features &= ~efx->fixed_features;
 	efx->net_dev->features |= efx->fixed_features;
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 665190413841..352ae87d901c 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -592,8 +592,8 @@ static int ef4_probe_channels(struct ef4_nic *efx)
  */
 static void ef4_start_datapath(struct ef4_nic *efx)
 {
-	netdev_features_t old_features = efx->net_dev->features;
 	bool old_rx_scatter = efx->rx_scatter;
+	netdev_features_t old_features;
 	struct ef4_tx_queue *tx_queue;
 	struct ef4_rx_queue *rx_queue;
 	struct ef4_channel *channel;
@@ -640,6 +640,7 @@ static void ef4_start_datapath(struct ef4_nic *efx)
 	/* Restore previously fixed features in hw_features and remove
 	 * features which are fixed now
 	 */
+	old_features = efx->net_dev->features;
 	efx->net_dev->hw_features |= efx->net_dev->features;
 	efx->net_dev->hw_features &= ~efx->fixed_features;
 	efx->net_dev->features |= efx->fixed_features;
diff --git a/net/core/dev.c b/net/core/dev.c
index ccf170a5f151..48b0a49ebb39 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3496,9 +3496,11 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 netdev_features_t netif_skb_features(struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
-	netdev_features_t features = dev->features;
+	netdev_features_t features;
 	netdev_features_t tmp;
 
+	features = dev->features;
+
 	if (skb_is_gso(skb))
 		features = gso_features_check(skb, dev, features);
 
@@ -9450,10 +9452,11 @@ static void net_set_todo(struct net_device *dev)
 static netdev_features_t netdev_sync_upper_features(struct net_device *lower,
 	struct net_device *upper, netdev_features_t features)
 {
-	netdev_features_t upper_disables = NETIF_F_UPPER_DISABLES;
+	netdev_features_t upper_disables;
 	netdev_features_t feature;
 	int feature_bit;
 
+	upper_disables = NETIF_F_UPPER_DISABLES;
 	for_each_netdev_feature(upper_disables, feature_bit) {
 		feature = __NETIF_F_BIT(feature_bit);
 		if (!(upper->wanted_features & feature)
@@ -9470,10 +9473,11 @@ static netdev_features_t netdev_sync_upper_features(struct net_device *lower,
 static void netdev_sync_lower_features(struct net_device *upper,
 	struct net_device *lower, netdev_features_t features)
 {
-	netdev_features_t upper_disables = NETIF_F_UPPER_DISABLES;
+	netdev_features_t upper_disables;
 	netdev_features_t feature;
 	int feature_bit;
 
+	upper_disables = NETIF_F_UPPER_DISABLES;
 	for_each_netdev_feature(upper_disables, feature_bit) {
 		feature = __NETIF_F_BIT(feature_bit);
 		if (!(features & feature) && (lower->features & feature)) {
@@ -9645,7 +9649,9 @@ int __netdev_update_features(struct net_device *dev)
 		netdev_sync_lower_features(dev, lower, features);
 
 	if (!err) {
-		netdev_features_t diff = features ^ dev->features;
+		netdev_features_t diff;
+
+		diff = features ^ dev->features;
 
 		if (diff & NETIF_F_RX_UDP_TUNNEL_PORT) {
 			/* udp_tunnel_{get,drop}_rx_info both need
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 67a837d44491..2c64183012c1 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+#include <linux/netdev_features_helper.h>
 #include "netlink.h"
 #include "common.h"
 #include "bitset.h"
@@ -144,9 +145,10 @@ static netdev_features_t ethnl_bitmap_to_features(unsigned long *src)
 {
 	const unsigned int nft_bits = sizeof(netdev_features_t) * BITS_PER_BYTE;
 	const unsigned int words = BITS_TO_LONGS(NETDEV_FEATURE_COUNT);
-	netdev_features_t ret = 0;
+	netdev_features_t ret;
 	unsigned int i;
 
+	netdev_features_zero(&ret);
 	for (i = 0; i < words; i++)
 		ret |= (netdev_features_t)(src[i]) << (i * BITS_PER_LONG);
 	ret &= ~(netdev_features_t)0 >> (nft_bits - NETDEV_FEATURE_COUNT);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index b2d500b27a5b..28164e990201 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -125,7 +125,8 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_sfeatures cmd;
 	struct ethtool_set_features_block features[ETHTOOL_DEV_FEATURE_WORDS];
-	netdev_features_t wanted = 0, valid = 0;
+	netdev_features_t wanted;
+	netdev_features_t valid;
 	netdev_features_t tmp;
 	int i, ret = 0;
 
@@ -139,6 +140,8 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 	if (copy_from_user(features, useraddr, sizeof(features)))
 		return -EFAULT;
 
+	netdev_features_zero(&wanted);
+	netdev_features_zero(&valid);
 	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; ++i) {
 		valid |= (netdev_features_t)features[i].valid << (32 * i);
 		wanted |= (netdev_features_t)features[i].requested << (32 * i);
@@ -267,12 +270,13 @@ static netdev_features_t ethtool_get_feature_mask(u32 eth_cmd)
 static int ethtool_get_one_feature(struct net_device *dev,
 	char __user *useraddr, u32 ethcmd)
 {
-	netdev_features_t mask = ethtool_get_feature_mask(ethcmd);
+	netdev_features_t mask;
 	struct ethtool_value edata = {
 		.cmd = ethcmd,
-		.data = !!(dev->features & mask),
 	};
 
+	mask = ethtool_get_feature_mask(ethcmd);
+	edata.data = !!(dev->features & mask);
 	if (copy_to_user(useraddr, &edata, sizeof(edata)))
 		return -EFAULT;
 	return 0;
@@ -332,13 +336,15 @@ static u32 __ethtool_get_flags(struct net_device *dev)
 
 static int __ethtool_set_flags(struct net_device *dev, u32 data)
 {
-	netdev_features_t features = 0, changed;
 	netdev_features_t eth_all_features;
+	netdev_features_t features;
+	netdev_features_t changed;
 	netdev_features_t tmp;
 
 	if (data & ~ETH_ALL_FLAGS)
 		return -EINVAL;
 
+	netdev_features_zero(&features);
 	if (data & ETH_FLAG_LRO)
 		features |= NETIF_F_LRO;
 	if (data & ETH_FLAG_RXVLAN)
-- 
2.33.0

