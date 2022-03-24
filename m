Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC3B64E6668
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 16:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351478AbiCXP5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 11:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351446AbiCXP4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 11:56:51 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC49AD110
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 08:55:12 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KPV9m1zcLzCrFt;
        Thu, 24 Mar 2022 23:53:00 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 23:55:08 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>,
        <lipeng321@huawei.com>
Subject: [RFCv5 PATCH net-next 07/20] net: adjust variables definition for netdev_features_t
Date:   Thu, 24 Mar 2022 23:49:19 +0800
Message-ID: <20220324154932.17557-8-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220324154932.17557-1-shenjian15@huawei.com>
References: <20220324154932.17557-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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
 net/ethtool/features.c                          |  3 ++-
 net/ethtool/ioctl.c                             | 14 ++++++++++----
 7 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 87cd9187884c..dcdef392ab0c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2394,12 +2394,14 @@ static int hns3_nic_do_ioctl(struct net_device *netdev,
 static int hns3_nic_set_features(struct net_device *netdev,
 				 netdev_features_t features)
 {
-	netdev_features_t changed = netdev->active_features ^ features;
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = priv->ae_handle;
+	netdev_features_t changed;
 	bool enable;
 	int ret;
 
+	changed = netdev->active_features ^ features;
+
 	if (changed & (NETIF_F_GRO_HW) && h->ae_algo->ops->set_gro_en) {
 		enable = !!(features & NETIF_F_GRO_HW);
 		ret = h->ae_algo->ops->set_gro_en(h, enable);
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 0d75361f1acb..c4cab9d5436d 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1311,7 +1311,7 @@ static const int ef10_tso_features_array[] = {
 static int efx_ef10_init_nic(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-	netdev_features_t hw_enc_features = 0;
+	netdev_features_t hw_enc_features;
 	int rc;
 
 	if (nic_data->must_check_datapath_caps) {
@@ -1356,6 +1356,7 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 		nic_data->must_restore_piobufs = false;
 	}
 
+	netdev_features_zero(&hw_enc_features);
 	/* add encapsulated checksum offload features */
 	if (efx_has_cap(efx, VXLAN_NVGRE) && !efx_ef10_is_vf(efx))
 		hw_enc_features |= netdev_ip_csum_features;
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index d5f8a2b3189a..306f5cb24273 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -367,8 +367,8 @@ void efx_start_monitor(struct efx_nic *efx)
  */
 static void efx_start_datapath(struct efx_nic *efx)
 {
-	netdev_features_t old_features = efx->net_dev->active_features;
 	bool old_rx_scatter = efx->rx_scatter;
+	netdev_features_t old_features;
 	size_t rx_buf_len;
 
 	/* Calculate the rx buffer allocation parameters required to
@@ -413,6 +413,7 @@ static void efx_start_datapath(struct efx_nic *efx)
 	/* Restore previously fixed features in hw_features and remove
 	 * features which are fixed now
 	 */
+	old_features = efx->net_dev->active_features;
 	efx->net_dev->hw_features |= efx->net_dev->active_features;
 	efx->net_dev->hw_features &= ~efx->fixed_features;
 	efx->net_dev->active_features |= efx->fixed_features;
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 2eae365eb7e6..0b04e7e6a002 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -592,8 +592,8 @@ static int ef4_probe_channels(struct ef4_nic *efx)
  */
 static void ef4_start_datapath(struct ef4_nic *efx)
 {
-	netdev_features_t old_features = efx->net_dev->active_features;
 	bool old_rx_scatter = efx->rx_scatter;
+	netdev_features_t old_features;
 	struct ef4_tx_queue *tx_queue;
 	struct ef4_rx_queue *rx_queue;
 	struct ef4_channel *channel;
@@ -640,6 +640,7 @@ static void ef4_start_datapath(struct ef4_nic *efx)
 	/* Restore previously fixed features in hw_features and remove
 	 * features which are fixed now
 	 */
+	old_features = efx->net_dev->active_features;
 	efx->net_dev->hw_features |= efx->net_dev->active_features;
 	efx->net_dev->hw_features &= ~efx->fixed_features;
 	efx->net_dev->active_features |= efx->fixed_features;
diff --git a/net/core/dev.c b/net/core/dev.c
index 7d170f307128..5d7f8575438a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3478,9 +3478,11 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 netdev_features_t netif_skb_features(struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
-	netdev_features_t features = dev->active_features;
+	netdev_features_t features;
 	netdev_features_t tmp;
 
+	features = dev->active_features;
+
 	if (skb_is_gso(skb))
 		features = gso_features_check(skb, dev, features);
 
@@ -9423,10 +9425,11 @@ static void net_set_todo(struct net_device *dev)
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
@@ -9443,10 +9446,11 @@ static netdev_features_t netdev_sync_upper_features(struct net_device *lower,
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
 		if (!(features & feature) && (lower->active_features & feature)) {
@@ -9618,7 +9622,9 @@ int __netdev_update_features(struct net_device *dev)
 		netdev_sync_lower_features(dev, lower, features);
 
 	if (!err) {
-		netdev_features_t diff = features ^ dev->active_features;
+		netdev_features_t diff;
+
+		diff = features ^ dev->active_features;
 
 		if (diff & NETIF_F_RX_UDP_TUNNEL_PORT) {
 			/* udp_tunnel_{get,drop}_rx_info both need
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index d327c6032d7b..c0950d181b13 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -144,9 +144,10 @@ static netdev_features_t ethnl_bitmap_to_features(unsigned long *src)
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
index ab003dc2cfd8..2a6f5b9cf988 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -124,7 +124,8 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_sfeatures cmd;
 	struct ethtool_set_features_block features[ETHTOOL_DEV_FEATURE_WORDS];
-	netdev_features_t wanted = 0, valid = 0;
+	netdev_features_t wanted;
+	netdev_features_t valid;
 	netdev_features_t tmp;
 	int i, ret = 0;
 
@@ -138,6 +139,8 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 	if (copy_from_user(features, useraddr, sizeof(features)))
 		return -EFAULT;
 
+	netdev_features_zero(&wanted);
+	netdev_features_zero(&valid);
 	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; ++i) {
 		valid |= (netdev_features_t)features[i].valid << (32 * i);
 		wanted |= (netdev_features_t)features[i].requested << (32 * i);
@@ -266,12 +269,13 @@ static netdev_features_t ethtool_get_feature_mask(u32 eth_cmd)
 static int ethtool_get_one_feature(struct net_device *dev,
 	char __user *useraddr, u32 ethcmd)
 {
-	netdev_features_t mask = ethtool_get_feature_mask(ethcmd);
+	netdev_features_t mask;
 	struct ethtool_value edata = {
 		.cmd = ethcmd,
-		.data = !!(dev->active_features & mask),
 	};
 
+	mask = ethtool_get_feature_mask(ethcmd);
+	edata.data = !!(dev->active_features & mask);
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

