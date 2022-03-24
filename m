Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC9D84E6662
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 16:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351442AbiCXP5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 11:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351445AbiCXP4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 11:56:51 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7F3AD10C
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 08:55:11 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KPVD141HZz1GD1G;
        Thu, 24 Mar 2022 23:54:57 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 23:55:07 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>,
        <lipeng321@huawei.com>
Subject: [RFCv5 PATCH net-next 01/20] net: rename net_device->features to net_device->active_features
Date:   Thu, 24 Mar 2022 23:49:13 +0800
Message-ID: <20220324154932.17557-2-shenjian15@huawei.com>
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

The net_device->features indicates the active features of the
net device, rename it to active_features, make it esaier to
define feature helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 32 ++++++-------
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  4 +-
 drivers/net/ethernet/sfc/ef10.c               |  4 +-
 drivers/net/ethernet/sfc/ef100_nic.c          |  4 +-
 drivers/net/ethernet/sfc/ef100_rx.c           |  4 +-
 drivers/net/ethernet/sfc/ef100_tx.c           |  8 ++--
 drivers/net/ethernet/sfc/efx.c                | 14 +++---
 drivers/net/ethernet/sfc/efx_common.c         | 14 +++---
 drivers/net/ethernet/sfc/falcon/efx.c         | 20 ++++----
 drivers/net/ethernet/sfc/falcon/net_driver.h  |  2 +-
 drivers/net/ethernet/sfc/falcon/rx.c          |  4 +-
 drivers/net/ethernet/sfc/farch.c              |  2 +-
 drivers/net/ethernet/sfc/mcdi_filters.c       |  6 +--
 drivers/net/ethernet/sfc/mcdi_port_common.c   |  2 +-
 drivers/net/ethernet/sfc/net_driver.h         |  2 +-
 drivers/net/ethernet/sfc/rx.c                 |  2 +-
 drivers/net/ethernet/sfc/rx_common.c          |  2 +-
 include/linux/netdevice.h                     | 14 +++---
 net/core/dev.c                                | 46 +++++++++----------
 net/ethtool/features.c                        |  6 +--
 net/ethtool/ioctl.c                           | 22 ++++-----
 21 files changed, 107 insertions(+), 107 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 0b8a73c40b12..24104eaae6d3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1492,7 +1492,7 @@ static int hns3_handle_vtags(struct hns3_enet_ring *tx_ring,
 		return -EINVAL;
 
 	if (skb->protocol == htons(ETH_P_8021Q) &&
-	    !(handle->kinfo.netdev->features & NETIF_F_HW_VLAN_CTAG_TX)) {
+	    !(handle->kinfo.netdev->active_features & NETIF_F_HW_VLAN_CTAG_TX)) {
 		/* When HW VLAN acceleration is turned off, and the stack
 		 * sets the protocol to 802.1q, the driver just need to
 		 * set the protocol to the encapsulated ethertype.
@@ -2394,7 +2394,7 @@ static int hns3_nic_do_ioctl(struct net_device *netdev,
 static int hns3_nic_set_features(struct net_device *netdev,
 				 netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed = netdev->active_features ^ features;
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = priv->ae_handle;
 	bool enable;
@@ -2420,7 +2420,7 @@ static int hns3_nic_set_features(struct net_device *netdev,
 		h->ae_algo->ops->enable_fd(h, enable);
 	}
 
-	if ((netdev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
+	if ((netdev->active_features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
 	    h->ae_algo->ops->cls_flower_active(h)) {
 		netdev_err(netdev,
 			   "there are offloaded TC filters active, cannot disable HW TC offload");
@@ -2435,7 +2435,7 @@ static int hns3_nic_set_features(struct net_device *netdev,
 			return ret;
 	}
 
-	netdev->features = features;
+	netdev->active_features = features;
 	return 0;
 }
 
@@ -3236,7 +3236,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 
 	netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
 
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
+	netdev->active_features |= NETIF_F_HW_VLAN_CTAG_FILTER |
 		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
 		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
 		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
@@ -3244,31 +3244,31 @@ static void hns3_set_default_feature(struct net_device *netdev)
 		NETIF_F_SCTP_CRC | NETIF_F_FRAGLIST;
 
 	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
-		netdev->features |= NETIF_F_GRO_HW;
+		netdev->active_features |= NETIF_F_GRO_HW;
 
 		if (!(h->flags & HNAE3_SUPPORT_VF))
-			netdev->features |= NETIF_F_NTUPLE;
+			netdev->active_features |= NETIF_F_NTUPLE;
 	}
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, ae_dev->caps))
-		netdev->features |= NETIF_F_GSO_UDP_L4;
+		netdev->active_features |= NETIF_F_GSO_UDP_L4;
 
 	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps))
-		netdev->features |= NETIF_F_HW_CSUM;
+		netdev->active_features |= NETIF_F_HW_CSUM;
 	else
-		netdev->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		netdev->active_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps))
-		netdev->features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->active_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
 
 	if (test_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps))
-		netdev->features |= NETIF_F_HW_TC;
+		netdev->active_features |= NETIF_F_HW_TC;
 
-	netdev->hw_features |= netdev->features;
+	netdev->hw_features |= netdev->active_features;
 	if (!test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
 		netdev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
 
-	netdev->vlan_features |= netdev->features &
+	netdev->vlan_features |= netdev->active_features &
 		~(NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_TX |
 		  NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_GRO_HW | NETIF_F_NTUPLE |
 		  NETIF_F_HW_TC);
@@ -3847,7 +3847,7 @@ static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
 
 	skb_checksum_none_assert(skb);
 
-	if (!(netdev->features & NETIF_F_RXCSUM))
+	if (!(netdev->active_features & NETIF_F_RXCSUM))
 		return;
 
 	if (test_bit(HNS3_NIC_STATE_RXD_ADV_LAYOUT_ENABLE, &priv->state))
@@ -4138,7 +4138,7 @@ static void hns3_handle_rx_vlan_tag(struct hns3_enet_ring *ring,
 	 * ot_vlan_tag in two layer tag case, and stored at vlan_tag
 	 * in one layer tag case.
 	 */
-	if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev->active_features & NETIF_F_HW_VLAN_CTAG_RX) {
 		u16 vlan_tag;
 
 		if (hns3_parse_vlan_tag(ring, desc, l234info, &vlan_tag))
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 6469238ae090..6db162eec2c2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -339,7 +339,7 @@ static void hns3_selftest_prepare(struct net_device *ndev,
 #if IS_ENABLED(CONFIG_VLAN_8021Q)
 	/* Disable the vlan filter for selftest does not support it */
 	if (h->ae_algo->ops->enable_vlan_filter &&
-	    ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	    ndev->active_features & NETIF_F_HW_VLAN_CTAG_FILTER)
 		h->ae_algo->ops->enable_vlan_filter(h, false);
 #endif
 
@@ -365,7 +365,7 @@ static void hns3_selftest_restore(struct net_device *ndev, bool if_running)
 
 #if IS_ENABLED(CONFIG_VLAN_8021Q)
 	if (h->ae_algo->ops->enable_vlan_filter &&
-	    ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	    ndev->active_features & NETIF_F_HW_VLAN_CTAG_FILTER)
 		h->ae_algo->ops->enable_vlan_filter(h, true);
 #endif
 
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 50d535981a35..56303984d936 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1360,7 +1360,7 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 			NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_GRE_CSUM;
 
 		hw_enc_features |= encap_tso_features | NETIF_F_TSO;
-		efx->net_dev->features |= encap_tso_features;
+		efx->net_dev->active_features |= encap_tso_features;
 	}
 	efx->net_dev->hw_enc_features = hw_enc_features;
 
@@ -2694,7 +2694,7 @@ static u16 efx_ef10_handle_rx_event_errors(struct efx_channel *channel,
 	bool handled = false;
 
 	if (EFX_QWORD_FIELD(*event, ESF_DZ_RX_ECRC_ERR)) {
-		if (!(efx->net_dev->features & NETIF_F_RXALL)) {
+		if (!(efx->net_dev->active_features & NETIF_F_RXALL)) {
 			if (!efx->loopback_selftest)
 				channel->n_rx_eth_crc_err += n_packets;
 			return EFX_RX_PKT_DISCARD;
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index a07cbf45a326..0ddd3d69bd5e 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -189,7 +189,7 @@ static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 					NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM |
 					NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM;
 
-		net_dev->features |= tso;
+		net_dev->active_features |= tso;
 		net_dev->hw_features |= tso;
 		net_dev->hw_enc_features |= tso;
 		/* EF100 HW can only offload outer checksums if they are UDP,
@@ -1123,7 +1123,7 @@ static int ef100_probe_main(struct efx_nic *efx)
 		return -ENOMEM;
 	efx->nic_data = nic_data;
 	nic_data->efx = efx;
-	net_dev->features |= efx->type->offload_features;
+	net_dev->active_features |= efx->type->offload_features;
 	net_dev->hw_features |= efx->type->offload_features;
 	net_dev->hw_enc_features |= efx->type->offload_features;
 	net_dev->vlan_features |= NETIF_F_HW_CSUM | NETIF_F_SG |
diff --git a/drivers/net/ethernet/sfc/ef100_rx.c b/drivers/net/ethernet/sfc/ef100_rx.c
index 85207acf7dee..63309527fb28 100644
--- a/drivers/net/ethernet/sfc/ef100_rx.c
+++ b/drivers/net/ethernet/sfc/ef100_rx.c
@@ -64,7 +64,7 @@ void __ef100_rx_packet(struct efx_channel *channel)
 	prefix = (u32 *)(eh - ESE_GZ_RX_PKT_PREFIX_LEN);
 
 	if (ef100_has_fcs_error(channel, prefix) &&
-	    unlikely(!(efx->net_dev->features & NETIF_F_RXALL)))
+	    unlikely(!(efx->net_dev->active_features & NETIF_F_RXALL)))
 		goto out;
 
 	rx_buf->len = le16_to_cpu((__force __le16)PREFIX_FIELD(prefix, LENGTH));
@@ -76,7 +76,7 @@ void __ef100_rx_packet(struct efx_channel *channel)
 		goto out;
 	}
 
-	if (likely(efx->net_dev->features & NETIF_F_RXCSUM)) {
+	if (likely(efx->net_dev->active_features & NETIF_F_RXCSUM)) {
 		if (PREFIX_FIELD(prefix, NT_OR_INNER_L3_CLASS) == 1) {
 			++channel->n_rx_ip_hdr_chksum_err;
 		} else {
diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
index 26ef51d6b542..c388f4c7d913 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.c
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -61,7 +61,7 @@ static bool ef100_tx_can_tso(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 
 	if (!skb_is_gso_tcp(skb))
 		return false;
-	if (!(efx->net_dev->features & NETIF_F_TSO))
+	if (!(efx->net_dev->active_features & NETIF_F_TSO))
 		return false;
 
 	mss = skb_shinfo(skb)->gso_size;
@@ -175,9 +175,9 @@ static void ef100_make_send_desc(struct efx_nic *efx,
 			     ESF_GZ_TX_SEND_LEN, buffer->len,
 			     ESF_GZ_TX_SEND_ADDR, buffer->dma_addr);
 
-	if (likely(efx->net_dev->features & NETIF_F_HW_CSUM))
+	if (likely(efx->net_dev->active_features & NETIF_F_HW_CSUM))
 		ef100_set_tx_csum_partial(skb, buffer, txd);
-	if (efx->net_dev->features & NETIF_F_HW_VLAN_CTAG_TX &&
+	if (efx->net_dev->active_features & NETIF_F_HW_VLAN_CTAG_TX &&
 	    skb && skb_vlan_tag_present(skb))
 		ef100_set_tx_hw_vlan(skb, txd);
 }
@@ -202,7 +202,7 @@ static void ef100_make_tso_desc(struct efx_nic *efx,
 
 	if (skb_shinfo(skb)->gso_type & SKB_GSO_TCP_FIXEDID)
 		mangleid = ESE_GZ_TX_DESC_IP4_ID_NO_OP;
-	if (efx->net_dev->features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (efx->net_dev->active_features & NETIF_F_HW_VLAN_CTAG_TX)
 		vlan_enable = skb_vlan_tag_present(skb);
 
 	len = skb->len - buffer->len;
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 302dc835ac3d..d7dff27a3e8e 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1004,29 +1004,29 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	}
 
 	/* Determine netdevice features */
-	net_dev->features |= (efx->type->offload_features | NETIF_F_SG |
+	net_dev->active_features |= (efx->type->offload_features | NETIF_F_SG |
 			      NETIF_F_TSO | NETIF_F_RXCSUM | NETIF_F_RXALL);
 	if (efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
-		net_dev->features |= NETIF_F_TSO6;
+		net_dev->active_features |= NETIF_F_TSO6;
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
-		net_dev->features &= ~NETIF_F_ALL_TSO;
+		net_dev->active_features &= ~NETIF_F_ALL_TSO;
 	/* Mask for features that also apply to VLAN devices */
 	net_dev->vlan_features |= (NETIF_F_HW_CSUM | NETIF_F_SG |
 				   NETIF_F_HIGHDMA | NETIF_F_ALL_TSO |
 				   NETIF_F_RXCSUM);
 
-	net_dev->hw_features |= net_dev->features & ~efx->fixed_features;
+	net_dev->hw_features |= net_dev->active_features & ~efx->fixed_features;
 
 	/* Disable receiving frames with bad FCS, by default. */
-	net_dev->features &= ~NETIF_F_RXALL;
+	net_dev->active_features &= ~NETIF_F_RXALL;
 
 	/* Disable VLAN filtering by default.  It may be enforced if
 	 * the feature is fixed (i.e. VLAN filters are required to
 	 * receive VLAN tagged packets due to vPort restrictions).
 	 */
-	net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-	net_dev->features |= efx->fixed_features;
+	net_dev->active_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+	net_dev->active_features |= efx->fixed_features;
 
 	rc = efx_register_netdev(efx);
 	if (!rc)
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index af37c990217e..cee20b4a34e7 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -215,7 +215,7 @@ int efx_set_features(struct net_device *net_dev, netdev_features_t data)
 	int rc;
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
-	if (net_dev->features & ~data & NETIF_F_NTUPLE) {
+	if (net_dev->active_features & ~data & NETIF_F_NTUPLE) {
 		rc = efx->type->filter_clear_rx(efx, EFX_FILTER_PRI_MANUAL);
 		if (rc)
 			return rc;
@@ -224,8 +224,8 @@ int efx_set_features(struct net_device *net_dev, netdev_features_t data)
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure.
 	 * If rx-fcs is changed, mac_reconfigure updates that too.
 	 */
-	if ((net_dev->features ^ data) & (NETIF_F_HW_VLAN_CTAG_FILTER |
-					  NETIF_F_RXFCS)) {
+	if ((net_dev->active_features ^ data) & (NETIF_F_HW_VLAN_CTAG_FILTER |
+						 NETIF_F_RXFCS)) {
 		/* efx_set_rx_mode() will schedule MAC work to update filters
 		 * when a new features are finally set in net_dev.
 		 */
@@ -364,7 +364,7 @@ void efx_start_monitor(struct efx_nic *efx)
  */
 static void efx_start_datapath(struct efx_nic *efx)
 {
-	netdev_features_t old_features = efx->net_dev->features;
+	netdev_features_t old_features = efx->net_dev->active_features;
 	bool old_rx_scatter = efx->rx_scatter;
 	size_t rx_buf_len;
 
@@ -410,10 +410,10 @@ static void efx_start_datapath(struct efx_nic *efx)
 	/* Restore previously fixed features in hw_features and remove
 	 * features which are fixed now
 	 */
-	efx->net_dev->hw_features |= efx->net_dev->features;
+	efx->net_dev->hw_features |= efx->net_dev->active_features;
 	efx->net_dev->hw_features &= ~efx->fixed_features;
-	efx->net_dev->features |= efx->fixed_features;
-	if (efx->net_dev->features != old_features)
+	efx->net_dev->active_features |= efx->fixed_features;
+	if (efx->net_dev->active_features != old_features)
 		netdev_features_change(efx->net_dev);
 
 	/* RX filters may also have scatter-enabled flags */
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 60c595ef7589..807ceda69c01 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -592,7 +592,7 @@ static int ef4_probe_channels(struct ef4_nic *efx)
  */
 static void ef4_start_datapath(struct ef4_nic *efx)
 {
-	netdev_features_t old_features = efx->net_dev->features;
+	netdev_features_t old_features = efx->net_dev->active_features;
 	bool old_rx_scatter = efx->rx_scatter;
 	struct ef4_tx_queue *tx_queue;
 	struct ef4_rx_queue *rx_queue;
@@ -640,10 +640,10 @@ static void ef4_start_datapath(struct ef4_nic *efx)
 	/* Restore previously fixed features in hw_features and remove
 	 * features which are fixed now
 	 */
-	efx->net_dev->hw_features |= efx->net_dev->features;
+	efx->net_dev->hw_features |= efx->net_dev->active_features;
 	efx->net_dev->hw_features &= ~efx->fixed_features;
-	efx->net_dev->features |= efx->fixed_features;
-	if (efx->net_dev->features != old_features)
+	efx->net_dev->active_features |= efx->fixed_features;
+	if (efx->net_dev->active_features != old_features)
 		netdev_features_change(efx->net_dev);
 
 	/* RX filters may also have scatter-enabled flags */
@@ -2191,14 +2191,14 @@ static int ef4_set_features(struct net_device *net_dev, netdev_features_t data)
 	int rc;
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
-	if (net_dev->features & ~data & NETIF_F_NTUPLE) {
+	if (net_dev->active_features & ~data & NETIF_F_NTUPLE) {
 		rc = efx->type->filter_clear_rx(efx, EF4_FILTER_PRI_MANUAL);
 		if (rc)
 			return rc;
 	}
 
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure */
-	if ((net_dev->features ^ data) & NETIF_F_HW_VLAN_CTAG_FILTER) {
+	if ((net_dev->active_features ^ data) & NETIF_F_HW_VLAN_CTAG_FILTER) {
 		/* ef4_set_rx_mode() will schedule MAC work to update filters
 		 * when a new features are finally set in net_dev.
 		 */
@@ -2904,20 +2904,20 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	if (rc)
 		goto fail3;
 
-	net_dev->features |= (efx->type->offload_features | NETIF_F_SG |
+	net_dev->active_features |= (efx->type->offload_features | NETIF_F_SG |
 			      NETIF_F_RXCSUM);
 	/* Mask for features that also apply to VLAN devices */
 	net_dev->vlan_features |= (NETIF_F_HW_CSUM | NETIF_F_SG |
 				   NETIF_F_HIGHDMA | NETIF_F_RXCSUM);
 
-	net_dev->hw_features = net_dev->features & ~efx->fixed_features;
+	net_dev->hw_features = net_dev->active_features & ~efx->fixed_features;
 
 	/* Disable VLAN filtering by default.  It may be enforced if
 	 * the feature is fixed (i.e. VLAN filters are required to
 	 * receive VLAN tagged packets due to vPort restrictions).
 	 */
-	net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-	net_dev->features |= efx->fixed_features;
+	net_dev->active_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+	net_dev->active_features |= efx->fixed_features;
 
 	rc = ef4_register_netdev(efx);
 	if (rc)
diff --git a/drivers/net/ethernet/sfc/falcon/net_driver.h b/drivers/net/ethernet/sfc/falcon/net_driver.h
index a381cf9ec4f3..48fca3bccd1b 100644
--- a/drivers/net/ethernet/sfc/falcon/net_driver.h
+++ b/drivers/net/ethernet/sfc/falcon/net_driver.h
@@ -1302,7 +1302,7 @@ static inline netdev_features_t ef4_supported_features(const struct ef4_nic *efx
 {
 	const struct net_device *net_dev = efx->net_dev;
 
-	return net_dev->features | net_dev->hw_features;
+	return net_dev->active_features | net_dev->hw_features;
 }
 
 /* Get the current TX queue insert index. */
diff --git a/drivers/net/ethernet/sfc/falcon/rx.c b/drivers/net/ethernet/sfc/falcon/rx.c
index 0c6cc2191369..49cc903768a6 100644
--- a/drivers/net/ethernet/sfc/falcon/rx.c
+++ b/drivers/net/ethernet/sfc/falcon/rx.c
@@ -443,7 +443,7 @@ ef4_rx_packet_gro(struct ef4_channel *channel, struct ef4_rx_buffer *rx_buf,
 		return;
 	}
 
-	if (efx->net_dev->features & NETIF_F_RXHASH)
+	if (efx->net_dev->active_features & NETIF_F_RXHASH)
 		skb_set_hash(skb, ef4_rx_buf_hash(efx, eh),
 			     PKT_HASH_TYPE_L3);
 	skb->ip_summed = ((rx_buf->flags & EF4_RX_PKT_CSUMMED) ?
@@ -672,7 +672,7 @@ void __ef4_rx_packet(struct ef4_channel *channel)
 		goto out;
 	}
 
-	if (unlikely(!(efx->net_dev->features & NETIF_F_RXCSUM)))
+	if (unlikely(!(efx->net_dev->active_features & NETIF_F_RXCSUM)))
 		rx_buf->flags &= ~EF4_RX_PKT_CSUMMED;
 
 	if ((rx_buf->flags & EF4_RX_PKT_TCP) && !channel->type->receive_skb)
diff --git a/drivers/net/ethernet/sfc/farch.c b/drivers/net/ethernet/sfc/farch.c
index 148dcd48b58d..8d0e328afb0d 100644
--- a/drivers/net/ethernet/sfc/farch.c
+++ b/drivers/net/ethernet/sfc/farch.c
@@ -921,7 +921,7 @@ static u16 efx_farch_handle_rx_not_ok(struct efx_rx_queue *rx_queue,
 	(void) rx_ev_other_err;
 #endif
 
-	if (efx->net_dev->features & NETIF_F_RXALL)
+	if (efx->net_dev->active_features & NETIF_F_RXALL)
 		/* don't discard frame for CRC error */
 		rx_ev_eth_crc_err = false;
 
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index 1523be77b9db..2ff62bc67e03 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -1326,7 +1326,7 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining)
 		(EFX_FILTER_MATCH_OUTER_VID | EFX_FILTER_MATCH_LOC_MAC_IG)))) {
 		netif_info(efx, probe, net_dev,
 			   "VLAN filters are not supported in this firmware variant\n");
-		net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+		net_dev->active_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
 		efx->fixed_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
 		net_dev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
 	}
@@ -1340,7 +1340,7 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining)
 
 	table->mc_promisc_last = false;
 	table->vlan_filter =
-		!!(efx->net_dev->features & NETIF_F_HW_VLAN_CTAG_FILTER);
+		!!(efx->net_dev->active_features & NETIF_F_HW_VLAN_CTAG_FILTER);
 	INIT_LIST_HEAD(&table->vlan_list);
 	init_rwsem(&table->lock);
 
@@ -1757,7 +1757,7 @@ void efx_mcdi_filter_sync_rx_mode(struct efx_nic *efx)
 	 * Do it in advance to avoid conflicts for unicast untagged and
 	 * VLAN 0 tagged filters.
 	 */
-	vlan_filter = !!(net_dev->features & NETIF_F_HW_VLAN_CTAG_FILTER);
+	vlan_filter = !!(net_dev->active_features & NETIF_F_HW_VLAN_CTAG_FILTER);
 	if (table->vlan_filter != vlan_filter) {
 		table->vlan_filter = vlan_filter;
 		efx_mcdi_filter_remove_old(efx);
diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/mcdi_port_common.c
index 899cc1671004..e6c8332e77fd 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
@@ -1110,7 +1110,7 @@ int efx_mcdi_set_mac(struct efx_nic *efx)
 
 	MCDI_POPULATE_DWORD_1(cmdbytes, SET_MAC_IN_FLAGS,
 			      SET_MAC_IN_FLAG_INCLUDE_FCS,
-			      !!(efx->net_dev->features & NETIF_F_RXFCS));
+			      !!(efx->net_dev->active_features & NETIF_F_RXFCS));
 
 	switch (efx->wanted_fc) {
 	case EFX_FC_RX | EFX_FC_TX:
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index c75dc75e2857..5aa4437a5768 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1687,7 +1687,7 @@ static inline netdev_features_t efx_supported_features(const struct efx_nic *efx
 {
 	const struct net_device *net_dev = efx->net_dev;
 
-	return net_dev->features | net_dev->hw_features;
+	return net_dev->active_features | net_dev->hw_features;
 }
 
 /* Get the current TX queue insert index. */
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 2375cef577e4..1f7463d5df91 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -387,7 +387,7 @@ void __efx_rx_packet(struct efx_channel *channel)
 	if (!efx_do_xdp(efx, channel, rx_buf, &eh))
 		goto out;
 
-	if (unlikely(!(efx->net_dev->features & NETIF_F_RXCSUM)))
+	if (unlikely(!(efx->net_dev->active_features & NETIF_F_RXCSUM)))
 		rx_buf->flags &= ~EFX_RX_PKT_CSUMMED;
 
 	if ((rx_buf->flags & EFX_RX_PKT_TCP) && !channel->type->receive_skb)
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 1b22c7be0088..c93e47f2d5bf 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -517,7 +517,7 @@ efx_rx_packet_gro(struct efx_channel *channel, struct efx_rx_buffer *rx_buf,
 		return;
 	}
 
-	if (efx->net_dev->features & NETIF_F_RXHASH &&
+	if (efx->net_dev->active_features & NETIF_F_RXHASH &&
 	    efx_rx_buf_hash_valid(efx, eh))
 		skb_set_hash(skb, efx_rx_buf_hash(efx, eh),
 			     PKT_HASH_TYPE_L3);
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8cbe96ce0a2c..7307b9553bcf 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1724,7 +1724,7 @@ enum netdev_ml_priv_type {
  *	@ptype_specific: Device-specific, protocol-specific packet handlers
  *
  *	@adj_list:	Directly linked devices, like slaves for bonding
- *	@features:	Currently active device features
+ *	@active_features:	Currently active device features
  *	@hw_features:	User-changeable features
  *
  *	@wanted_features:	User-requested features
@@ -2010,7 +2010,7 @@ struct net_device {
 	unsigned short		needed_headroom;
 	unsigned short		needed_tailroom;
 
-	netdev_features_t	features;
+	netdev_features_t	active_features;
 	netdev_features_t	hw_features;
 	netdev_features_t	wanted_features;
 	netdev_features_t	vlan_features;
@@ -2297,7 +2297,7 @@ struct net_device {
 
 static inline bool netif_elide_gro(const struct net_device *dev)
 {
-	if (!(dev->features & NETIF_F_GRO) || dev->xdp_prog)
+	if (!(dev->active_features & NETIF_F_GRO) || dev->xdp_prog)
 		return true;
 	return false;
 }
@@ -4318,7 +4318,7 @@ static inline void netif_tx_unlock_bh(struct net_device *dev)
 }
 
 #define HARD_TX_LOCK(dev, txq, cpu) {			\
-	if ((dev->features & NETIF_F_LLTX) == 0) {	\
+	if ((dev->active_features & NETIF_F_LLTX) == 0) {	\
 		__netif_tx_lock(txq, cpu);		\
 	} else {					\
 		__netif_tx_acquire(txq);		\
@@ -4326,12 +4326,12 @@ static inline void netif_tx_unlock_bh(struct net_device *dev)
 }
 
 #define HARD_TX_TRYLOCK(dev, txq)			\
-	(((dev->features & NETIF_F_LLTX) == 0) ?	\
+	(((dev->active_features & NETIF_F_LLTX) == 0) ?	\
 		__netif_tx_trylock(txq) :		\
 		__netif_tx_acquire(txq))
 
 #define HARD_TX_UNLOCK(dev, txq) {			\
-	if ((dev->features & NETIF_F_LLTX) == 0) {	\
+	if ((dev->active_features & NETIF_F_LLTX) == 0) {	\
 		__netif_tx_unlock(txq);			\
 	} else {					\
 		__netif_tx_release(txq);		\
@@ -4832,7 +4832,7 @@ static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 static inline netdev_features_t netdev_get_wanted_features(
 	struct net_device *dev)
 {
-	return (dev->features & ~dev->hw_features) | dev->wanted_features;
+	return (dev->active_features & ~dev->hw_features) | dev->wanted_features;
 }
 netdev_features_t netdev_increment_features(netdev_features_t all,
 	netdev_features_t one, netdev_features_t mask);
diff --git a/net/core/dev.c b/net/core/dev.c
index 75bab5b0dbae..a09ddbfb3086 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1580,7 +1580,7 @@ void dev_disable_lro(struct net_device *dev)
 	dev->wanted_features &= ~NETIF_F_LRO;
 	netdev_update_features(dev);
 
-	if (unlikely(dev->features & NETIF_F_LRO))
+	if (unlikely(dev->active_features & NETIF_F_LRO))
 		netdev_WARN(dev, "failed to disable LRO!\n");
 
 	netdev_for_each_lower_dev(dev, lower_dev, iter)
@@ -1601,7 +1601,7 @@ static void dev_disable_gro_hw(struct net_device *dev)
 	dev->wanted_features &= ~NETIF_F_GRO_HW;
 	netdev_update_features(dev);
 
-	if (unlikely(dev->features & NETIF_F_GRO_HW))
+	if (unlikely(dev->active_features & NETIF_F_GRO_HW))
 		netdev_WARN(dev, "failed to disable GRO_HW!\n");
 }
 
@@ -3172,7 +3172,7 @@ static void skb_warn_bad_offload(const struct sk_buff *skb)
 	}
 	skb_dump(KERN_WARNING, skb, false);
 	WARN(1, "%s: caps=(%pNF, %pNF)\n",
-	     name, dev ? &dev->features : &null_features,
+	     name, dev ? &dev->active_features : &null_features,
 	     skb->sk ? &skb->sk->sk_route_caps : &null_features);
 }
 
@@ -3325,7 +3325,7 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 		netdev_features_t partial_features = NETIF_F_GSO_ROBUST;
 		struct net_device *dev = skb->dev;
 
-		partial_features |= dev->features & dev->gso_partial_features;
+		partial_features |= dev->active_features & dev->gso_partial_features;
 		if (!skb_gso_ok(skb, features | partial_features))
 			features &= ~NETIF_F_GSO_PARTIAL;
 	}
@@ -3370,7 +3370,7 @@ static int illegal_highdma(struct net_device *dev, struct sk_buff *skb)
 #ifdef CONFIG_HIGHMEM
 	int i;
 
-	if (!(dev->features & NETIF_F_HIGHDMA)) {
+	if (!(dev->active_features & NETIF_F_HIGHDMA)) {
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
@@ -3477,7 +3477,7 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 netdev_features_t netif_skb_features(struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
-	netdev_features_t features = dev->features;
+	netdev_features_t features = dev->active_features;
 
 	if (skb_is_gso(skb))
 		features = gso_features_check(skb, dev, features);
@@ -4321,7 +4321,7 @@ set_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 
 		/* Should we steer this flow to a different hardware queue? */
 		if (!skb_rx_queue_recorded(skb) || !dev->rx_cpu_rmap ||
-		    !(dev->features & NETIF_F_NTUPLE))
+		    !(dev->active_features & NETIF_F_NTUPLE))
 			goto out;
 		rxq_index = cpu_rmap_lookup_index(dev->rx_cpu_rmap, next_cpu);
 		if (rxq_index == skb_get_rx_queue(skb))
@@ -9448,13 +9448,13 @@ static void netdev_sync_lower_features(struct net_device *upper,
 
 	for_each_netdev_feature(upper_disables, feature_bit) {
 		feature = __NETIF_F_BIT(feature_bit);
-		if (!(features & feature) && (lower->features & feature)) {
+		if (!(features & feature) && (lower->active_features & feature)) {
 			netdev_dbg(upper, "Disabling feature %pNF on lower dev %s.\n",
 				   &feature, lower->name);
 			lower->wanted_features &= ~feature;
 			__netdev_update_features(lower);
 
-			if (unlikely(lower->features & feature))
+			if (unlikely(lower->active_features & feature))
 				netdev_WARN(upper, "failed to disable %pNF on %s!\n",
 					    &feature, lower->name);
 			else
@@ -9584,11 +9584,11 @@ int __netdev_update_features(struct net_device *dev)
 	netdev_for_each_upper_dev_rcu(dev, upper, iter)
 		features = netdev_sync_upper_features(dev, upper, features);
 
-	if (dev->features == features)
+	if (dev->active_features == features)
 		goto sync_lower;
 
 	netdev_dbg(dev, "Features changed: %pNF -> %pNF\n",
-		&dev->features, &features);
+		&dev->active_features, &features);
 
 	if (dev->netdev_ops->ndo_set_features)
 		err = dev->netdev_ops->ndo_set_features(dev, features);
@@ -9598,7 +9598,7 @@ int __netdev_update_features(struct net_device *dev)
 	if (unlikely(err < 0)) {
 		netdev_err(dev,
 			"set_features() failed (%d); wanted %pNF, left %pNF\n",
-			err, &features, &dev->features);
+			err, &features, &dev->active_features);
 		/* return non-0 since some features might have changed and
 		 * it's better to fire a spurious notification than miss it
 		 */
@@ -9613,7 +9613,7 @@ int __netdev_update_features(struct net_device *dev)
 		netdev_sync_lower_features(dev, lower, features);
 
 	if (!err) {
-		netdev_features_t diff = features ^ dev->features;
+		netdev_features_t diff = features ^ dev->active_features;
 
 		if (diff & NETIF_F_RX_UDP_TUNNEL_PORT) {
 			/* udp_tunnel_{get,drop}_rx_info both need
@@ -9624,7 +9624,7 @@ int __netdev_update_features(struct net_device *dev)
 			 * but *after* calling udp_tunnel_drop_rx_info.
 			 */
 			if (features & NETIF_F_RX_UDP_TUNNEL_PORT) {
-				dev->features = features;
+				dev->active_features = features;
 				udp_tunnel_get_rx_info(dev);
 			} else {
 				udp_tunnel_drop_rx_info(dev);
@@ -9633,7 +9633,7 @@ int __netdev_update_features(struct net_device *dev)
 
 		if (diff & NETIF_F_HW_VLAN_CTAG_FILTER) {
 			if (features & NETIF_F_HW_VLAN_CTAG_FILTER) {
-				dev->features = features;
+				dev->active_features = features;
 				err |= vlan_get_rx_ctag_filter_info(dev);
 			} else {
 				vlan_drop_rx_ctag_filter_info(dev);
@@ -9642,14 +9642,14 @@ int __netdev_update_features(struct net_device *dev)
 
 		if (diff & NETIF_F_HW_VLAN_STAG_FILTER) {
 			if (features & NETIF_F_HW_VLAN_STAG_FILTER) {
-				dev->features = features;
+				dev->active_features = features;
 				err |= vlan_get_rx_stag_filter_info(dev);
 			} else {
 				vlan_drop_rx_stag_filter_info(dev);
 			}
 		}
 
-		dev->features = features;
+		dev->active_features = features;
 	}
 
 	return err < 0 ? 0 : 1;
@@ -9875,7 +9875,7 @@ int register_netdevice(struct net_device *dev)
 		}
 	}
 
-	if (((dev->hw_features | dev->features) &
+	if (((dev->hw_features | dev->active_features) &
 	     NETIF_F_HW_VLAN_CTAG_FILTER) &&
 	    (!dev->netdev_ops->ndo_vlan_rx_add_vid ||
 	     !dev->netdev_ops->ndo_vlan_rx_kill_vid)) {
@@ -9894,14 +9894,14 @@ int register_netdevice(struct net_device *dev)
 	 * software offloads (GSO and GRO).
 	 */
 	dev->hw_features |= (NETIF_F_SOFT_FEATURES | NETIF_F_SOFT_FEATURES_OFF);
-	dev->features |= NETIF_F_SOFT_FEATURES;
+	dev->active_features |= NETIF_F_SOFT_FEATURES;
 
 	if (dev->udp_tunnel_nic_info) {
-		dev->features |= NETIF_F_RX_UDP_TUNNEL_PORT;
+		dev->active_features |= NETIF_F_RX_UDP_TUNNEL_PORT;
 		dev->hw_features |= NETIF_F_RX_UDP_TUNNEL_PORT;
 	}
 
-	dev->wanted_features = dev->features & dev->hw_features;
+	dev->wanted_features = dev->active_features & dev->hw_features;
 
 	if (!(dev->flags & IFF_LOOPBACK))
 		dev->hw_features |= NETIF_F_NOCACHE_COPY;
@@ -10817,7 +10817,7 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 
 	/* Don't allow namespace local devices to be moved. */
 	err = -EINVAL;
-	if (dev->features & NETIF_F_NETNS_LOCAL)
+	if (dev->active_features & NETIF_F_NETNS_LOCAL)
 		goto out;
 
 	/* Ensure the device has been registrered */
@@ -11176,7 +11176,7 @@ static void __net_exit default_device_exit_net(struct net *net)
 		char fb_name[IFNAMSIZ];
 
 		/* Ignore unmoveable devices (i.e. loopback) */
-		if (dev->features & NETIF_F_NETNS_LOCAL)
+		if (dev->active_features & NETIF_F_NETNS_LOCAL)
 			continue;
 
 		/* Leave virtual devices for the generic cleanup */
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 55d449a2d3fc..a43f82515de8 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -43,7 +43,7 @@ static int features_prepare_data(const struct ethnl_req_info *req_base,
 
 	ethnl_features_to_bitmap32(data->hw, dev->hw_features);
 	ethnl_features_to_bitmap32(data->wanted, dev->wanted_features);
-	ethnl_features_to_bitmap32(data->active, dev->features);
+	ethnl_features_to_bitmap32(data->active, dev->active_features);
 	ethnl_features_to_bitmap32(data->nochange, NETIF_F_NEVER_CHANGE);
 	all_features = GENMASK_ULL(NETDEV_FEATURE_COUNT - 1, 0);
 	ethnl_features_to_bitmap32(data->all, all_features);
@@ -234,7 +234,7 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	dev = req_info.dev;
 
 	rtnl_lock();
-	ethnl_features_to_bitmap(old_active, dev->features);
+	ethnl_features_to_bitmap(old_active, dev->active_features);
 	ethnl_features_to_bitmap(old_wanted, dev->wanted_features);
 	ret = ethnl_parse_bitset(req_wanted, req_mask, NETDEV_FEATURE_COUNT,
 				 tb[ETHTOOL_A_FEATURES_WANTED],
@@ -256,7 +256,7 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 		dev->wanted_features |= ethnl_bitmap_to_features(req_wanted) & dev->hw_features;
 		__netdev_update_features(dev);
 	}
-	ethnl_features_to_bitmap(new_active, dev->features);
+	ethnl_features_to_bitmap(new_active, dev->active_features);
 	mod = !bitmap_equal(old_active, new_active, NETDEV_FEATURE_COUNT);
 
 	ret = 0;
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 326e14ee05db..1c7f24316b3d 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -98,7 +98,7 @@ static int ethtool_get_features(struct net_device *dev, void __user *useraddr)
 	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; ++i) {
 		features[i].available = (u32)(dev->hw_features >> (32 * i));
 		features[i].requested = (u32)(dev->wanted_features >> (32 * i));
-		features[i].active = (u32)(dev->features >> (32 * i));
+		features[i].active = (u32)(dev->active_features >> (32 * i));
 		features[i].never_changed =
 			(u32)(NETIF_F_NEVER_CHANGE >> (32 * i));
 	}
@@ -154,7 +154,7 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 	dev->wanted_features |= wanted & valid;
 	__netdev_update_features(dev);
 
-	if ((dev->wanted_features ^ dev->features) & valid)
+	if ((dev->wanted_features ^ dev->active_features) & valid)
 		ret |= ETHTOOL_F_WISH;
 
 	return ret;
@@ -254,7 +254,7 @@ static int ethtool_get_one_feature(struct net_device *dev,
 	netdev_features_t mask = ethtool_get_feature_mask(ethcmd);
 	struct ethtool_value edata = {
 		.cmd = ethcmd,
-		.data = !!(dev->features & mask),
+		.data = !!(dev->active_features & mask),
 	};
 
 	if (copy_to_user(useraddr, &edata, sizeof(edata)))
@@ -296,15 +296,15 @@ static u32 __ethtool_get_flags(struct net_device *dev)
 {
 	u32 flags = 0;
 
-	if (dev->features & NETIF_F_LRO)
+	if (dev->active_features & NETIF_F_LRO)
 		flags |= ETH_FLAG_LRO;
-	if (dev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (dev->active_features & NETIF_F_HW_VLAN_CTAG_RX)
 		flags |= ETH_FLAG_RXVLAN;
-	if (dev->features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (dev->active_features & NETIF_F_HW_VLAN_CTAG_TX)
 		flags |= ETH_FLAG_TXVLAN;
-	if (dev->features & NETIF_F_NTUPLE)
+	if (dev->active_features & NETIF_F_NTUPLE)
 		flags |= ETH_FLAG_NTUPLE;
-	if (dev->features & NETIF_F_RXHASH)
+	if (dev->active_features & NETIF_F_RXHASH)
 		flags |= ETH_FLAG_RXHASH;
 
 	return flags;
@@ -329,7 +329,7 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 		features |= NETIF_F_RXHASH;
 
 	/* allow changing only bits set in hw_features */
-	changed = (features ^ dev->features) & ETH_ALL_FEATURES;
+	changed = (features ^ dev->active_features) & ETH_ALL_FEATURES;
 	if (changed & ~dev->hw_features)
 		return (changed & dev->hw_features) ? -EINVAL : -EOPNOTSUPP;
 
@@ -2800,7 +2800,7 @@ __dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr,
 		if (rc < 0)
 			goto out;
 	}
-	old_features = dev->features;
+	old_features = dev->active_features;
 
 	switch (ethcmd) {
 	case ETHTOOL_GSET:
@@ -3015,7 +3015,7 @@ __dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr,
 	if (dev->ethtool_ops->complete)
 		dev->ethtool_ops->complete(dev);
 
-	if (old_features != dev->features)
+	if (old_features != dev->active_features)
 		netdev_features_change(dev);
 out:
 	if (dev->dev.parent)
-- 
2.33.0

