Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D46D41C932
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345772AbhI2QCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:02:25 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:23326 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhI2P7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:51 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWy1qhyzRbrt;
        Wed, 29 Sep 2021 23:53:50 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:07 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:07 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 082/167] net: wireless: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:09 +0800
Message-ID: <20210929155334.12454-83-shenjian15@huawei.com>
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

For iwiwifi, it initializes the features in struct. So it's
unable to change the prototype from u64 to bitmap. Define it
as u64 array instead.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/wireless/ath/ath10k/mac.c           |  7 +++++--
 drivers/net/wireless/ath/ath11k/mac.c           |  4 +++-
 drivers/net/wireless/ath/ath6kl/main.c          | 15 ++++++++++-----
 drivers/net/wireless/ath/ath6kl/txrx.c          |  6 ++++--
 drivers/net/wireless/ath/wil6210/netdev.c       | 11 +++++++----
 .../wireless/broadcom/brcm80211/brcmfmac/core.c |  4 ++--
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c  |  4 ++--
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c   |  2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c   |  2 +-
 .../net/wireless/intel/iwlwifi/dvm/mac80211.c   |  7 +++++--
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  2 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c   | 17 +++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c     |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c   |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c     | 10 +++++++---
 .../net/wireless/mediatek/mt76/mt7615/init.c    |  3 ++-
 .../net/wireless/mediatek/mt76/mt7915/init.c    |  3 ++-
 .../net/wireless/mediatek/mt76/mt7921/init.c    |  3 ++-
 net/wireless/core.c                             | 15 ++++++++++-----
 19 files changed, 77 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index c272b290fa73..493d15f4d4e9 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -10119,8 +10119,11 @@ int ath10k_mac_register(struct ath10k *ar)
 	if (ar->hw_params.dynamic_sar_support)
 		ar->hw->wiphy->sar_capa = &ath10k_sar_capa;
 
-	if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags))
-		ar->hw->netdev_features = NETIF_F_HW_CSUM;
+	if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
+		netdev_feature_zero(&ar->hw->netdev_features);
+		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT,
+				       &ar->hw->netdev_features);
+	}
 
 	if (IS_ENABLED(CONFIG_ATH10K_DFS_CERTIFIED)) {
 		/* Init ath dfs pattern detector */
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index e9b3689331ec..ba892c4ab3eb 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6570,7 +6570,9 @@ static int __ath11k_mac_register(struct ath11k *ar)
 	ath11k_reg_init(ar);
 
 	if (!test_bit(ATH11K_FLAG_RAW_MODE, &ab->dev_flags)) {
-		ar->hw->netdev_features = NETIF_F_HW_CSUM;
+		netdev_feature_zero(&ar->hw->netdev_features);
+		netdev_feature_set_bit(NETIF_F_HW_CSUM_BIT,
+				       &ar->hw->netdev_features);
 		ieee80211_hw_set(ar->hw, SW_CRYPTO_CONTROL);
 		ieee80211_hw_set(ar->hw, SUPPORT_FAST_XMIT);
 	}
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index d3aa9e7a37c2..cbf0e5dcac02 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1126,24 +1126,28 @@ static int ath6kl_set_features(struct net_device *dev,
 	struct ath6kl *ar = vif->ar;
 	int err = 0;
 
-	if ((features & NETIF_F_RXCSUM) &&
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features) &&
 	    (ar->rx_meta_ver != WMI_META_VERSION_2)) {
 		ar->rx_meta_ver = WMI_META_VERSION_2;
 		err = ath6kl_wmi_set_rx_frame_format_cmd(ar->wmi,
 							 vif->fw_vif_idx,
 							 ar->rx_meta_ver, 0, 0);
 		if (err) {
-			dev->features = features & ~NETIF_F_RXCSUM;
+			netdev_feature_copy(&dev->features, features);
+			netdev_feature_clear_bit(NETIF_F_RXCSUM_BIT,
+						 &dev->features);
 			return err;
 		}
-	} else if (!(features & NETIF_F_RXCSUM) &&
+	} else if (!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, features) &&
 		   (ar->rx_meta_ver == WMI_META_VERSION_2)) {
 		ar->rx_meta_ver = 0;
 		err = ath6kl_wmi_set_rx_frame_format_cmd(ar->wmi,
 							 vif->fw_vif_idx,
 							 ar->rx_meta_ver, 0, 0);
 		if (err) {
-			dev->features = features | NETIF_F_RXCSUM;
+			netdev_feature_copy(&dev->features, features);
+			netdev_feature_set_bit(NETIF_F_RXCSUM_BIT,
+					       &dev->features);
 			return err;
 		}
 	}
@@ -1305,7 +1309,8 @@ void init_netdev(struct net_device *dev)
 
 	if (!test_bit(ATH6KL_FW_CAPABILITY_NO_IP_CHECKSUM,
 		      ar->fw_capabilities))
-		dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
+		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_RXCSUM,
+					&dev->hw_features);
 
 	return;
 }
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index b22ed499f7ba..6c7569c20d00 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -391,7 +391,8 @@ netdev_tx_t ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	if (test_bit(WMI_ENABLED, &ar->flag)) {
-		if ((dev->features & NETIF_F_IP_CSUM) &&
+		if (netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT,
+					    dev->features) &&
 		    (csum == CHECKSUM_PARTIAL)) {
 			csum_start = skb->csum_start -
 					(skb_network_header(skb) - skb->head) +
@@ -410,7 +411,8 @@ netdev_tx_t ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 			goto fail_tx;
 		}
 
-		if ((dev->features & NETIF_F_IP_CSUM) &&
+		if (netdev_feature_test_bit(NETIF_F_IP_CSUM_BIT,
+					    dev->features) &&
 		    (csum == CHECKSUM_PARTIAL)) {
 			meta_v2.csum_start = csum_start;
 			meta_v2.csum_dest = csum_dest;
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 0913f0bf60e7..b29a4d6c3c0f 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -335,11 +335,14 @@ wil_vif_alloc(struct wil6210_priv *wil, const char *name,
 	ndev->netdev_ops = &wil_netdev_ops;
 	wil_set_ethtoolops(ndev);
 	ndev->ieee80211_ptr = wdev;
-	ndev->hw_features = NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
-			    NETIF_F_SG | NETIF_F_GRO |
-			    NETIF_F_TSO | NETIF_F_TSO6;
+	netdev_feature_zero(&ndev->hw_features);
+	netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
+				NETIF_F_SG | NETIF_F_GRO |
+				NETIF_F_TSO | NETIF_F_TSO6,
+				&ndev->hw_features);
+
+	netdev_feature_or(&ndev->features, ndev->features, ndev->hw_features);
 
-	ndev->features |= ndev->hw_features;
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
 	wdev->netdev = ndev;
 	return vif;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index db5f8535fdb5..d04bff1a60f4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -616,9 +616,9 @@ static int brcmf_netdev_open(struct net_device *ndev)
 	/* Get current TOE mode from dongle */
 	if (brcmf_fil_iovar_int_get(ifp, "toe_ol", &toe_ol) >= 0
 	    && (toe_ol & TOE_TX_CSUM_OL) != 0)
-		ndev->features |= NETIF_F_IP_CSUM;
+		netdev_feature_set_bit(NETIF_F_IP_CSUM_BIT, &ndev->features);
 	else
-		ndev->features &= ~NETIF_F_IP_CSUM;
+		netdev_feature_clear_bit(NETIF_F_IP_CSUM_BIT, &ndev->features);
 
 	if (brcmf_cfg80211_up(ndev)) {
 		bphy_err(drvr, "failed to bring up cfg80211\n");
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index d8231cc821ae..fd2408f80676 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -150,7 +150,7 @@ static const struct iwl_ht_params iwl_22000_ht_params = {
 	.dccm2_len = IWL_22000_DCCM2_LEN,				\
 	.smem_offset = IWL_22000_SMEM_OFFSET,				\
 	.smem_len = IWL_22000_SMEM_LEN,					\
-	.features = IWL_TX_CSUM_NETIF_FLAGS | NETIF_F_RXCSUM,		\
+	.features = { IWL_TX_CSUM_NETIF_FLAGS | NETIF_F_RXCSUM },		\
 	.apmg_not_supported = true,					\
 	.trans.mq_rx_supported = true,					\
 	.vht_mu_mimo_supported = true,					\
@@ -227,7 +227,7 @@ static const struct iwl_ht_params iwl_22000_ht_params = {
 	.dccm2_len = IWL_22000_DCCM2_LEN,				\
 	.smem_offset = IWL_22000_SMEM_OFFSET,				\
 	.smem_len = IWL_22000_SMEM_LEN,					\
-	.features = IWL_TX_CSUM_NETIF_FLAGS | NETIF_F_RXCSUM,		\
+	.features = { IWL_TX_CSUM_NETIF_FLAGS | NETIF_F_RXCSUM },	\
 	.apmg_not_supported = true,					\
 	.trans.mq_rx_supported = true,					\
 	.vht_mu_mimo_supported = true,					\
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/8000.c b/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
index a6454287d506..d4e33cd76702 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
@@ -81,7 +81,7 @@ static const struct iwl_tt_params iwl8000_tt_params = {
 	.trans.base_params = &iwl8000_base_params,			\
 	.led_mode = IWL_LED_RF_STATE,					\
 	.nvm_hw_section_num = 10,					\
-	.features = NETIF_F_RXCSUM,					\
+	.features = { NETIF_F_RXCSUM },					\
 	.non_shared_ant = ANT_A,					\
 	.dccm_offset = IWL8260_DCCM_OFFSET,				\
 	.dccm_len = IWL8260_DCCM_LEN,					\
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
index 7a7ca06d46c1..36d0049cb900 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
@@ -84,7 +84,7 @@ static const struct iwl_tt_params iwl9000_tt_params = {
 	.dccm2_len = IWL9000_DCCM2_LEN,					\
 	.smem_offset = IWL9000_SMEM_OFFSET,				\
 	.smem_len = IWL9000_SMEM_LEN,					\
-	.features = IWL_TX_CSUM_NETIF_FLAGS | NETIF_F_RXCSUM,		\
+	.features = { IWL_TX_CSUM_NETIF_FLAGS | NETIF_F_RXCSUM },	\
 	.thermal_params = &iwl9000_tt_params,				\
 	.apmg_not_supported = true,					\
 	.num_rbds = 512,						\
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
index 75e7665773c5..81df8565a22f 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -101,8 +101,11 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
 	ieee80211_hw_set(hw, WANT_MONITOR_VIF);
 
-	if (priv->trans->max_skb_frags)
-		hw->netdev_features = NETIF_F_HIGHDMA | NETIF_F_SG;
+	if (priv->trans->max_skb_frags) {
+		netdev_feature_zero(&hw->netdev_features);
+		netdev_feature_set_bits(NETIF_F_HIGHDMA | NETIF_F_SG,
+					&hw->netdev_features);
+	}
 
 	hw->offchannel_tx_hw_queue = IWL_AUX_QUEUE;
 	hw->radiotap_mcs_details |= IEEE80211_RADIOTAP_MCS_HAVE_FMT;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 7eb534df5331..01acacf0219e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -366,7 +366,7 @@ struct iwl_cfg {
 	enum iwl_nvm_type nvm_type;
 	u32 max_data_size;
 	u32 max_inst_size;
-	netdev_features_t features;
+	u64 features[NETDEV_FEATURE_DWORDS];
 	u32 dccm_offset;
 	u32 dccm_len;
 	u32 dccm2_offset;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 3a4585222d6d..fdfda9cc55f3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -387,8 +387,11 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	if (mvm->trans->num_rx_queues > 1)
 		ieee80211_hw_set(hw, USES_RSS);
 
-	if (mvm->trans->max_skb_frags)
-		hw->netdev_features = NETIF_F_HIGHDMA | NETIF_F_SG;
+	if (mvm->trans->max_skb_frags) {
+		netdev_feature_zero(&hw->netdev_features);
+		netdev_feature_set_bits(NETIF_F_HIGHDMA | NETIF_F_SG,
+					&hw->netdev_features);
+	}
 
 	hw->queues = IEEE80211_NUM_ACS;
 	hw->offchannel_tx_hw_queue = IWL_MVM_OFFCHANNEL_QUEUE;
@@ -703,10 +706,11 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		hw->wiphy->features |= NL80211_FEATURE_TDLS_CHANNEL_SWITCH;
 	}
 
-	hw->netdev_features |= mvm->cfg->features;
+	netdev_feature_set_bits(mvm->cfg->features[0], &hw->netdev_features);
 	if (!iwl_mvm_is_csum_supported(mvm))
-		hw->netdev_features &= ~(IWL_TX_CSUM_NETIF_FLAGS |
-					 NETIF_F_RXCSUM);
+		netdev_feature_clear_bits(IWL_TX_CSUM_NETIF_FLAGS |
+					  NETIF_F_RXCSUM,
+					  &hw->netdev_features);
 
 	if (mvm->cfg->vht_mu_mimo_supported)
 		wiphy_ext_feature_set(hw->wiphy,
@@ -1451,7 +1455,8 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 		goto out_unlock;
 	}
 
-	mvmvif->features |= hw->netdev_features;
+	netdev_feature_or(&mvmvif->features, mvmvif->features,
+			  hw->netdev_features);
 
 	ret = iwl_mvm_mac_ctxt_add(mvm, vif);
 	if (ret)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 8ef5399ad9be..21d97eb6c207 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -276,7 +276,7 @@ static void iwl_mvm_rx_csum(struct ieee80211_sta *sta,
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(mvmsta->vif);
 
-	if (mvmvif->features & NETIF_F_RXCSUM &&
+	if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, mvmvif->features) &&
 	    status & RX_MPDU_RES_STATUS_CSUM_DONE &&
 	    status & RX_MPDU_RES_STATUS_CSUM_OK)
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index c12f303cf652..a0daf93c36c1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -472,7 +472,7 @@ static void iwl_mvm_rx_csum(struct iwl_mvm *mvm,
 
 		mvmvif = iwl_mvm_vif_from_mac80211(mvmsta->vif);
 
-		if (mvmvif->features & NETIF_F_RXCSUM &&
+		if (netdev_feature_test_bit(NETIF_F_RXCSUM_BIT, mvmvif->features) &&
 		    flags & IWL_RX_L3L4_TCP_UDP_CSUM_OK &&
 		    (flags & IWL_RX_L3L4_IP_HDR_CSUM_OK ||
 		     l3_prot == IWL_RX_L3_TYPE_IPV6 ||
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 0a13c2bda2ee..cfe0fcb1a0ba 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -53,7 +53,8 @@ static u16 iwl_mvm_tx_csum(struct iwl_mvm *mvm, struct sk_buff *skb,
 		goto out;
 
 	/* We do not expect to be requested to csum stuff we do not support */
-	if (WARN_ONCE(!(mvm->hw->netdev_features & IWL_TX_CSUM_NETIF_FLAGS) ||
+	if (WARN_ONCE(!netdev_feature_test_bits(IWL_TX_CSUM_NETIF_FLAGS,
+						mvm->hw->netdev_features) ||
 		      (skb->protocol != htons(ETH_P_IP) &&
 		       skb->protocol != htons(ETH_P_IPV6)),
 		      "No support for requested checksum\n")) {
@@ -836,9 +837,12 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	unsigned int mss = skb_shinfo(skb)->gso_size;
 	unsigned int num_subframes, tcp_payload_len, subf_len, max_amsdu_len;
 	u16 snap_ip_tcp, pad;
-	netdev_features_t netdev_flags = NETIF_F_CSUM_MASK | NETIF_F_SG;
+	netdev_features_t netdev_flags;
 	u8 tid;
 
+	netdev_feature_zero(&netdev_flags);
+	netdev_feature_set_bits(NETIF_F_CSUM_MASK | NETIF_F_SG, &netdev_flags);
+
 	snap_ip_tcp = 8 + skb_transport_header(skb) - skb_network_header(skb) +
 		tcp_hdrlen(skb);
 
@@ -854,7 +858,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if (skb->protocol == htons(ETH_P_IPV6) &&
 	    ((struct ipv6hdr *)skb_network_header(skb))->nexthdr !=
 	    IPPROTO_TCP) {
-		netdev_flags &= ~NETIF_F_CSUM_MASK;
+		netdev_feature_clear_bits(NETIF_F_CSUM_MASK, &netdev_flags);
 		return iwl_mvm_tx_tso_segment(skb, 1, netdev_flags, mpdus_skb);
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index 2f1ac644e018..e690e095ba60 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -363,7 +363,8 @@ mt7615_init_wiphy(struct ieee80211_hw *hw)
 	hw->max_rates = 3;
 	hw->max_report_rates = 7;
 	hw->max_rate_tries = 11;
-	hw->netdev_features = NETIF_F_RXCSUM;
+	netdev_feature_zero(&hw->netdev_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &hw->netdev_features);
 
 	hw->radiotap_timestamp.units_pos =
 		IEEE80211_RADIOTAP_TIMESTAMP_UNIT_US;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index 4798d6344305..a3ab1a5f3f94 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -217,7 +217,8 @@ mt7915_init_wiphy(struct ieee80211_hw *hw)
 	hw->queues = 4;
 	hw->max_rx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF;
 	hw->max_tx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF;
-	hw->netdev_features = NETIF_F_RXCSUM;
+	netdev_feature_zero(&hw->netdev_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &hw->netdev_features);
 
 	hw->radiotap_timestamp.units_pos =
 		IEEE80211_RADIOTAP_TIMESTAMP_UNIT_US;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index a9ce10b98827..368d6cfb2881 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -51,7 +51,8 @@ mt7921_init_wiphy(struct ieee80211_hw *hw)
 	hw->queues = 4;
 	hw->max_rx_aggregation_subframes = 64;
 	hw->max_tx_aggregation_subframes = 128;
-	hw->netdev_features = NETIF_F_RXCSUM;
+	netdev_feature_zero(&hw->netdev_features);
+	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &hw->netdev_features);
 
 	hw->radiotap_timestamp.units_pos =
 		IEEE80211_RADIOTAP_TIMESTAMP_UNIT_US;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 03323121ca50..5849ebf7ca5f 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -164,11 +164,13 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 		if (!wdev->netdev)
 			continue;
-		wdev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
+		netdev_feature_clear_bit(NETIF_F_NETNS_LOCAL_BIT,
+					 &wdev->netdev->features);
 		err = dev_change_net_namespace(wdev->netdev, net, "wlan%d");
 		if (err)
 			break;
-		wdev->netdev->features |= NETIF_F_NETNS_LOCAL;
+		netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT,
+				       &wdev->netdev->features);
 	}
 
 	if (err) {
@@ -180,11 +182,13 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 						     list) {
 			if (!wdev->netdev)
 				continue;
-			wdev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
+			netdev_feature_clear_bit(NETIF_F_NETNS_LOCAL_BIT,
+						 &wdev->netdev->features);
 			err = dev_change_net_namespace(wdev->netdev, net,
 							"wlan%d");
 			WARN_ON(err);
-			wdev->netdev->features |= NETIF_F_NETNS_LOCAL;
+			netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT,
+					       &wdev->netdev->features);
 		}
 
 		return err;
@@ -1384,7 +1388,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		SET_NETDEV_DEVTYPE(dev, &wiphy_type);
 		wdev->netdev = dev;
 		/* can only change netns with wiphy */
-		dev->features |= NETIF_F_NETNS_LOCAL;
+		netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT,
+				       &dev->features);
 
 		cfg80211_init_wdev(wdev);
 		break;
-- 
2.33.0

