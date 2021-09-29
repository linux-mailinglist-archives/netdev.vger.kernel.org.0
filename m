Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46FA741C938
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344606AbhI2QCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:02:43 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13837 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345517AbhI2P7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:53 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKLWb2x5Rz8ysn;
        Wed, 29 Sep 2021 23:53:31 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:10 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:09 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 094/167] net: sfc: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:52:21 +0800
Message-ID: <20210929155334.12454-95-shenjian15@huawei.com>
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

For the driver initializes the offloaded_features when define
structure . So it's unable to change the prototype from u64 to
bitmap. Define it as u64 array instead.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/sfc/ef10.c              | 37 +++++++++++-----
 drivers/net/ethernet/sfc/ef100_nic.c         | 43 +++++++++++-------
 drivers/net/ethernet/sfc/ef100_rx.c          |  6 ++-
 drivers/net/ethernet/sfc/ef100_tx.c          | 11 +++--
 drivers/net/ethernet/sfc/ef10_sriov.c        |  6 ++-
 drivers/net/ethernet/sfc/efx.c               | 32 ++++++++------
 drivers/net/ethernet/sfc/efx_common.c        | 36 +++++++++------
 drivers/net/ethernet/sfc/falcon/efx.c        | 46 +++++++++++++-------
 drivers/net/ethernet/sfc/falcon/falcon.c     |  4 +-
 drivers/net/ethernet/sfc/falcon/net_driver.h |  4 +-
 drivers/net/ethernet/sfc/falcon/rx.c         |  6 ++-
 drivers/net/ethernet/sfc/farch.c             |  2 +-
 drivers/net/ethernet/sfc/mcdi_filters.c      | 18 +++++---
 drivers/net/ethernet/sfc/mcdi_port_common.c  |  3 +-
 drivers/net/ethernet/sfc/net_driver.h        |  4 +-
 drivers/net/ethernet/sfc/rx.c                |  3 +-
 drivers/net/ethernet/sfc/rx_common.c         |  5 ++-
 drivers/net/ethernet/sfc/siena.c             |  4 +-
 18 files changed, 172 insertions(+), 98 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index e7e2223aebbf..981c01acef51 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -627,7 +627,8 @@ static int efx_ef10_probe(struct efx_nic *efx)
 
 	if (nic_data->datapath_caps &
 	    (1 << MC_CMD_GET_CAPABILITIES_OUT_RX_INCLUDE_FCS_LBN))
-		efx->net_dev->hw_features |= NETIF_F_RXFCS;
+		netdev_feature_set_bit(NETIF_F_RXFCS_BIT,
+				       &efx->net_dev->hw_features);
 
 	rc = efx_mcdi_port_get_number(efx);
 	if (rc < 0)
@@ -1304,9 +1305,11 @@ static void efx_ef10_fini_nic(struct efx_nic *efx)
 static int efx_ef10_init_nic(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-	netdev_features_t hw_enc_features = 0;
+	netdev_features_t hw_enc_features;
 	int rc;
 
+	netdev_feature_zero(&hw_enc_features);
+
 	if (nic_data->must_check_datapath_caps) {
 		rc = efx_ef10_init_datapath_caps(efx);
 		if (rc)
@@ -1351,18 +1354,27 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 
 	/* add encapsulated checksum offload features */
 	if (efx_has_cap(efx, VXLAN_NVGRE) && !efx_ef10_is_vf(efx))
-		hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
+					&hw_enc_features);
 	/* add encapsulated TSO features */
 	if (efx_has_cap(efx, TX_TSO_V2_ENCAP)) {
 		netdev_features_t encap_tso_features;
 
-		encap_tso_features = NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
-			NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_GRE_CSUM;
-
-		hw_enc_features |= encap_tso_features | NETIF_F_TSO;
-		efx->net_dev->features |= encap_tso_features;
+		netdev_feature_zero(&encap_tso_features);
+		netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL |
+					NETIF_F_GSO_GRE |
+					NETIF_F_GSO_UDP_TUNNEL_CSUM |
+					NETIF_F_GSO_GRE_CSUM,
+					&encap_tso_features);
+
+		netdev_feature_or(&hw_enc_features, hw_enc_features,
+				  encap_tso_features);
+		netdev_feature_set_bit(NETIF_F_TSO_BIT, &hw_enc_features);
+		netdev_feature_or(&efx->net_dev->features,
+				  efx->net_dev->features,
+				  encap_tso_features);
 	}
-	efx->net_dev->hw_enc_features = hw_enc_features;
+	netdev_feature_copy(&efx->net_dev->hw_enc_features, hw_enc_features);
 
 	/* don't fail init if RSS setup doesn't work */
 	rc = efx->type->rx_push_rss_config(efx, false,
@@ -2694,7 +2706,8 @@ static u16 efx_ef10_handle_rx_event_errors(struct efx_channel *channel,
 	bool handled = false;
 
 	if (EFX_QWORD_FIELD(*event, ESF_DZ_RX_ECRC_ERR)) {
-		if (!(efx->net_dev->features & NETIF_F_RXALL)) {
+		if (!netdev_feature_test_bit(NETIF_F_RXALL_BIT,
+					     efx->net_dev->features)) {
 			if (!efx->loopback_selftest)
 				channel->n_rx_eth_crc_err += n_packets;
 			return EFX_RX_PKT_DISCARD;
@@ -4097,7 +4110,7 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.always_rx_scatter = true,
 	.min_interrupt_mode = EFX_INT_MODE_MSIX,
 	.timer_period_max = 1 << ERF_DD_EVQ_IND_TIMER_VAL_WIDTH,
-	.offload_features = EF10_OFFLOAD_FEATURES,
+	.offload_features = { EF10_OFFLOAD_FEATURES },
 	.mcdi_max_ver = 2,
 	.max_rx_ip_filters = EFX_MCDI_FILTER_TBL_ROWS,
 	.hwtstamp_filters = 1 << HWTSTAMP_FILTER_NONE |
@@ -4234,7 +4247,7 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 	.option_descriptors = true,
 	.min_interrupt_mode = EFX_INT_MODE_LEGACY,
 	.timer_period_max = 1 << ERF_DD_EVQ_IND_TIMER_VAL_WIDTH,
-	.offload_features = EF10_OFFLOAD_FEATURES,
+	.offload_features = { EF10_OFFLOAD_FEATURES },
 	.mcdi_max_ver = 2,
 	.max_rx_ip_filters = EFX_MCDI_FILTER_TBL_ROWS,
 	.hwtstamp_filters = 1 << HWTSTAMP_FILTER_NONE |
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 518268ce2064..5127e03050d1 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -184,17 +184,26 @@ static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 
 	if (efx_ef100_has_cap(nic_data->datapath_caps2, TX_TSO_V3)) {
 		struct net_device *net_dev = efx->net_dev;
-		netdev_features_t tso = NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_PARTIAL |
-					NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM |
-					NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM;
-
-		net_dev->features |= tso;
-		net_dev->hw_features |= tso;
-		net_dev->hw_enc_features |= tso;
+		netdev_features_t tso;
+
+		netdev_feature_zero(&tso);
+		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6 |
+					NETIF_F_GSO_PARTIAL |
+					NETIF_F_GSO_UDP_TUNNEL |
+					NETIF_F_GSO_UDP_TUNNEL_CSUM |
+					NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM,
+					&tso);
+
+		netdev_feature_or(&net_dev->features, net_dev->features, tso);
+		netdev_feature_or(&net_dev->hw_features, net_dev->hw_features,
+				  tso);
+		netdev_feature_or(&net_dev->hw_enc_features,
+				  net_dev->hw_enc_features, tso);
 		/* EF100 HW can only offload outer checksums if they are UDP,
 		 * so for GRE_CSUM we have to use GSO_PARTIAL.
 		 */
-		net_dev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
+		netdev_feature_set_bit(NETIF_F_GSO_GRE_CSUM_BIT,
+				       &net_dev->gso_partial_features);
 	}
 	efx->num_mac_stats = MCDI_WORD(outbuf,
 				       GET_CAPABILITIES_V4_OUT_MAC_STATS_NUM_STATS);
@@ -704,7 +713,7 @@ const struct efx_nic_type ef100_pf_nic_type = {
 	.revision = EFX_REV_EF100,
 	.is_vf = false,
 	.probe = ef100_probe_pf,
-	.offload_features = EF100_OFFLOAD_FEATURES,
+	.offload_features = { EF100_OFFLOAD_FEATURES },
 	.mcdi_max_ver = 2,
 	.mcdi_request = ef100_mcdi_request,
 	.mcdi_poll_response = ef100_mcdi_poll_response,
@@ -789,7 +798,7 @@ const struct efx_nic_type ef100_vf_nic_type = {
 	.revision = EFX_REV_EF100,
 	.is_vf = true,
 	.probe = ef100_probe_vf,
-	.offload_features = EF100_OFFLOAD_FEATURES,
+	.offload_features = { EF100_OFFLOAD_FEATURES },
 	.mcdi_max_ver = 2,
 	.mcdi_request = ef100_mcdi_request,
 	.mcdi_poll_response = ef100_mcdi_poll_response,
@@ -1111,11 +1120,15 @@ static int ef100_probe_main(struct efx_nic *efx)
 		return -ENOMEM;
 	efx->nic_data = nic_data;
 	nic_data->efx = efx;
-	net_dev->features |= efx->type->offload_features;
-	net_dev->hw_features |= efx->type->offload_features;
-	net_dev->hw_enc_features |= efx->type->offload_features;
-	net_dev->vlan_features |= NETIF_F_HW_CSUM | NETIF_F_SG |
-				  NETIF_F_HIGHDMA | NETIF_F_ALL_TSO;
+	netdev_feature_set_bits(efx->type->offload_features[0],
+				&net_dev->features);
+	netdev_feature_set_bits(efx->type->offload_features[0],
+				&net_dev->hw_features);
+	netdev_feature_set_bits(efx->type->offload_features[0],
+				&net_dev->hw_enc_features);
+	netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_SG |
+				NETIF_F_HIGHDMA | NETIF_F_ALL_TSO,
+				&net_dev->vlan_features);
 
 	/* Populate design-parameter defaults */
 	nic_data->tso_max_hdr_len = ESE_EF100_DP_GZ_TSO_MAX_HDR_LEN_DEFAULT;
diff --git a/drivers/net/ethernet/sfc/ef100_rx.c b/drivers/net/ethernet/sfc/ef100_rx.c
index 85207acf7dee..ffd7d7c34af2 100644
--- a/drivers/net/ethernet/sfc/ef100_rx.c
+++ b/drivers/net/ethernet/sfc/ef100_rx.c
@@ -64,7 +64,8 @@ void __ef100_rx_packet(struct efx_channel *channel)
 	prefix = (u32 *)(eh - ESE_GZ_RX_PKT_PREFIX_LEN);
 
 	if (ef100_has_fcs_error(channel, prefix) &&
-	    unlikely(!(efx->net_dev->features & NETIF_F_RXALL)))
+	    unlikely(!netdev_feature_test_bit(NETIF_F_RXALL_BIT,
+					      efx->net_dev->features)))
 		goto out;
 
 	rx_buf->len = le16_to_cpu((__force __le16)PREFIX_FIELD(prefix, LENGTH));
@@ -76,7 +77,8 @@ void __ef100_rx_packet(struct efx_channel *channel)
 		goto out;
 	}
 
-	if (likely(efx->net_dev->features & NETIF_F_RXCSUM)) {
+	if (likely(netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					   efx->net_dev->features))) {
 		if (PREFIX_FIELD(prefix, NT_OR_INNER_L3_CLASS) == 1) {
 			++channel->n_rx_ip_hdr_chksum_err;
 		} else {
diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
index 26ef51d6b542..087c18e71f74 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.c
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -61,7 +61,7 @@ static bool ef100_tx_can_tso(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 
 	if (!skb_is_gso_tcp(skb))
 		return false;
-	if (!(efx->net_dev->features & NETIF_F_TSO))
+	if (!netdev_feature_test_bit(NETIF_F_TSO_BIT, efx->net_dev->features))
 		return false;
 
 	mss = skb_shinfo(skb)->gso_size;
@@ -175,9 +175,11 @@ static void ef100_make_send_desc(struct efx_nic *efx,
 			     ESF_GZ_TX_SEND_LEN, buffer->len,
 			     ESF_GZ_TX_SEND_ADDR, buffer->dma_addr);
 
-	if (likely(efx->net_dev->features & NETIF_F_HW_CSUM))
+	if (likely(netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT,
+					   efx->net_dev->features)))
 		ef100_set_tx_csum_partial(skb, buffer, txd);
-	if (efx->net_dev->features & NETIF_F_HW_VLAN_CTAG_TX &&
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				    efx->net_dev->features) &&
 	    skb && skb_vlan_tag_present(skb))
 		ef100_set_tx_hw_vlan(skb, txd);
 }
@@ -202,7 +204,8 @@ static void ef100_make_tso_desc(struct efx_nic *efx,
 
 	if (skb_shinfo(skb)->gso_type & SKB_GSO_TCP_FIXEDID)
 		mangleid = ESE_GZ_TX_DESC_IP4_ID_NO_OP;
-	if (efx->net_dev->features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				    efx->net_dev->features))
 		vlan_enable = skb_vlan_tag_present(skb);
 
 	len = skb->len - buffer->len;
diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 752d6406f07e..2e449b5b34e3 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -243,9 +243,11 @@ static int efx_ef10_vadaptor_alloc_set_features(struct efx_nic *efx)
 
 	if (port_flags &
 	    (1 << MC_CMD_VPORT_ALLOC_IN_FLAG_VLAN_RESTRICT_LBN))
-		efx->fixed_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_set_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				       &efx->fixed_features);
 	else
-		efx->fixed_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					 &efx->fixed_features);
 
 	return 0;
 
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 43ef4f529028..30cbfdbc100e 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -991,6 +991,7 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 {
 	struct net_device *net_dev = efx->net_dev;
 	int rc = efx_pci_probe_main(efx);
+	netdev_features_t tmp;
 
 	if (rc)
 		return rc;
@@ -1003,29 +1004,34 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	}
 
 	/* Determine netdevice features */
-	net_dev->features |= (efx->type->offload_features | NETIF_F_SG |
-			      NETIF_F_TSO | NETIF_F_RXCSUM | NETIF_F_RXALL);
-	if (efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
-		net_dev->features |= NETIF_F_TSO6;
+	netdev_feature_set_bits(efx->type->offload_features[0] | NETIF_F_SG |
+				NETIF_F_TSO | NETIF_F_RXCSUM | NETIF_F_RXALL,
+				&net_dev->features);
+
+	if (efx->type->offload_features[0] & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
+		netdev_feature_set_bit(NETIF_F_TSO6_BIT, &net_dev->features);
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
-		net_dev->features &= ~NETIF_F_ALL_TSO;
+		netdev_feature_clear_bits(NETIF_F_ALL_TSO, &net_dev->features);
 	/* Mask for features that also apply to VLAN devices */
-	net_dev->vlan_features |= (NETIF_F_HW_CSUM | NETIF_F_SG |
-				   NETIF_F_HIGHDMA | NETIF_F_ALL_TSO |
-				   NETIF_F_RXCSUM);
+	netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_SG |
+				NETIF_F_HIGHDMA | NETIF_F_ALL_TSO |
+				NETIF_F_RXCSUM, &net_dev->vlan_features);
 
-	net_dev->hw_features |= net_dev->features & ~efx->fixed_features;
+	netdev_feature_andnot(&tmp, net_dev->features, efx->fixed_features);
+	netdev_feature_or(&net_dev->hw_features, net_dev->hw_features, tmp);
 
 	/* Disable receiving frames with bad FCS, by default. */
-	net_dev->features &= ~NETIF_F_RXALL;
+	netdev_feature_clear_bit(NETIF_F_RXALL_BIT, &net_dev->features);
 
 	/* Disable VLAN filtering by default.  It may be enforced if
 	 * the feature is fixed (i.e. VLAN filters are required to
 	 * receive VLAN tagged packets due to vPort restrictions).
 	 */
-	net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-	net_dev->features |= efx->fixed_features;
+	netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				 &net_dev->features);
+	netdev_feature_or(&net_dev->features, net_dev->features,
+			  efx->fixed_features);
 
 	rc = efx_register_netdev(efx);
 	if (!rc)
@@ -1058,7 +1064,7 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 		return -ENOMEM;
 	efx = netdev_priv(net_dev);
 	efx->type = (const struct efx_nic_type *) entry->driver_data;
-	efx->fixed_features |= NETIF_F_HIGHDMA;
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &efx->fixed_features);
 
 	pci_set_drvdata(pci_dev, efx);
 	SET_NETDEV_DEV(net_dev, &pci_dev->dev);
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index a101fa50a5cc..01353739bae0 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -211,10 +211,12 @@ void efx_set_rx_mode(struct net_device *net_dev)
 int efx_set_features(struct net_device *net_dev, netdev_features_t data)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
+	netdev_features_t changed;
 	int rc;
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
-	if (net_dev->features & ~data & NETIF_F_NTUPLE) {
+	if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, net_dev->features) &&
+	    !netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, data)) {
 		rc = efx->type->filter_clear_rx(efx, EFX_FILTER_PRI_MANUAL);
 		if (rc)
 			return rc;
@@ -223,8 +225,9 @@ int efx_set_features(struct net_device *net_dev, netdev_features_t data)
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure.
 	 * If rx-fcs is changed, mac_reconfigure updates that too.
 	 */
-	if ((net_dev->features ^ data) & (NETIF_F_HW_VLAN_CTAG_FILTER |
-					  NETIF_F_RXFCS)) {
+	netdev_feature_xor(&changed, net_dev->features, data);
+	if (netdev_feature_test_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
+				     NETIF_F_RXFCS, changed)) {
 		/* efx_set_rx_mode() will schedule MAC work to update filters
 		 * when a new features are finally set in net_dev.
 		 */
@@ -363,8 +366,8 @@ void efx_start_monitor(struct efx_nic *efx)
  */
 static void efx_start_datapath(struct efx_nic *efx)
 {
-	netdev_features_t old_features = efx->net_dev->features;
 	bool old_rx_scatter = efx->rx_scatter;
+	netdev_features_t old_features;
 	size_t rx_buf_len;
 
 	/* Calculate the rx buffer allocation parameters required to
@@ -409,10 +412,14 @@ static void efx_start_datapath(struct efx_nic *efx)
 	/* Restore previously fixed features in hw_features and remove
 	 * features which are fixed now
 	 */
-	efx->net_dev->hw_features |= efx->net_dev->features;
-	efx->net_dev->hw_features &= ~efx->fixed_features;
-	efx->net_dev->features |= efx->fixed_features;
-	if (efx->net_dev->features != old_features)
+	netdev_feature_copy(&old_features, efx->net_dev->features);
+	netdev_feature_or(&efx->net_dev->hw_features,
+			  efx->net_dev->hw_features, efx->net_dev->features);
+	netdev_feature_andnot(&efx->net_dev->hw_features,
+			      efx->net_dev->hw_features, efx->fixed_features);
+	netdev_feature_or(&efx->net_dev->features, efx->net_dev->features,
+			  efx->fixed_features);
+	if (!netdev_feature_equal(efx->net_dev->features, old_features))
 		netdev_features_change(efx->net_dev);
 
 	/* RX filters may also have scatter-enabled flags */
@@ -1359,17 +1366,20 @@ void efx_features_check(struct sk_buff *skb, struct net_device *dev,
 	struct efx_nic *efx = netdev_priv(dev);
 
 	if (skb->encapsulation) {
-		if (*features & NETIF_F_GSO_MASK)
+		if (netdev_feature_test_bits(NETIF_F_GSO_MASK, *features))
 			/* Hardware can only do TSO with at most 208 bytes
 			 * of headers.
 			 */
 			if (skb_inner_transport_offset(skb) >
 			    EFX_TSO2_MAX_HDRLEN)
-				*features &= ~(NETIF_F_GSO_MASK);
-		if (*features & (NETIF_F_GSO_MASK | NETIF_F_CSUM_MASK))
+				netdev_feature_clear_bits(NETIF_F_GSO_MASK,
+							  features);
+		if (netdev_feature_test_bits(NETIF_F_GSO_MASK |
+					     NETIF_F_CSUM_MASK, *features))
 			if (!efx_can_encap_offloads(efx, skb))
-				*features &= ~(NETIF_F_GSO_MASK |
-					      NETIF_F_CSUM_MASK);
+				netdev_feature_clear_bits(NETIF_F_GSO_MASK |
+							  NETIF_F_CSUM_MASK,
+							  features);
 	}
 }
 
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 423bdf81200f..a6301c8dd9cb 100644
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
@@ -640,10 +640,14 @@ static void ef4_start_datapath(struct ef4_nic *efx)
 	/* Restore previously fixed features in hw_features and remove
 	 * features which are fixed now
 	 */
-	efx->net_dev->hw_features |= efx->net_dev->features;
-	efx->net_dev->hw_features &= ~efx->fixed_features;
-	efx->net_dev->features |= efx->fixed_features;
-	if (efx->net_dev->features != old_features)
+	netdev_feature_copy(&old_features, efx->net_dev->features);
+	netdev_feature_or(&efx->net_dev->hw_features,
+			  efx->net_dev->hw_features, efx->net_dev->features);
+	netdev_feature_andnot(&efx->net_dev->hw_features,
+			      efx->net_dev->hw_features, efx->fixed_features);
+	netdev_feature_or(&efx->net_dev->features, efx->net_dev->features,
+			  efx->fixed_features);
+	if (!netdev_feature_equal(efx->net_dev->features, old_features))
 		netdev_features_change(efx->net_dev);
 
 	/* RX filters may also have scatter-enabled flags */
@@ -1698,7 +1702,7 @@ static int ef4_probe_filters(struct ef4_nic *efx)
 		goto out_unlock;
 
 #ifdef CONFIG_RFS_ACCEL
-	if (efx->type->offload_features & NETIF_F_NTUPLE) {
+	if (efx->type->offload_features[0] & NETIF_F_NTUPLE) {
 		struct ef4_channel *channel;
 		int i, success = 1;
 
@@ -2192,17 +2196,21 @@ static void ef4_set_rx_mode(struct net_device *net_dev)
 static int ef4_set_features(struct net_device *net_dev, netdev_features_t data)
 {
 	struct ef4_nic *efx = netdev_priv(net_dev);
+	netdev_features_t changed;
 	int rc;
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
-	if (net_dev->features & ~data & NETIF_F_NTUPLE) {
+	if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, net_dev->features) &&
+	    !netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, data)) {
 		rc = efx->type->filter_clear_rx(efx, EF4_FILTER_PRI_MANUAL);
 		if (rc)
 			return rc;
 	}
 
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure */
-	if ((net_dev->features ^ data) & NETIF_F_HW_VLAN_CTAG_FILTER) {
+	netdev_feature_xor(&changed, net_dev->features, data);
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				    changed)) {
 		/* ef4_set_rx_mode() will schedule MAC work to update filters
 		 * when a new features are finally set in net_dev.
 		 */
@@ -2886,7 +2894,7 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 		return -ENOMEM;
 	efx = netdev_priv(net_dev);
 	efx->type = (const struct ef4_nic_type *) entry->driver_data;
-	efx->fixed_features |= NETIF_F_HIGHDMA;
+	netdev_feature_set_bit(NETIF_F_HIGHDMA_BIT, &efx->fixed_features);
 
 	pci_set_drvdata(pci_dev, efx);
 	SET_NETDEV_DEV(net_dev, &pci_dev->dev);
@@ -2908,20 +2916,26 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	if (rc)
 		goto fail3;
 
-	net_dev->features |= (efx->type->offload_features | NETIF_F_SG |
-			      NETIF_F_RXCSUM);
+	netdev_feature_set_bits(efx->type->offload_features[0],
+				&net_dev->features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_RXCSUM,
+				&net_dev->features);
 	/* Mask for features that also apply to VLAN devices */
-	net_dev->vlan_features |= (NETIF_F_HW_CSUM | NETIF_F_SG |
-				   NETIF_F_HIGHDMA | NETIF_F_RXCSUM);
+	netdev_feature_set_bits(NETIF_F_HW_CSUM | NETIF_F_SG |
+				NETIF_F_HIGHDMA | NETIF_F_RXCSUM,
+				&net_dev->vlan_features);
 
-	net_dev->hw_features = net_dev->features & ~efx->fixed_features;
+	netdev_feature_andnot(&net_dev->hw_features, net_dev->features,
+			      efx->fixed_features);
 
 	/* Disable VLAN filtering by default.  It may be enforced if
 	 * the feature is fixed (i.e. VLAN filters are required to
 	 * receive VLAN tagged packets due to vPort restrictions).
 	 */
-	net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-	net_dev->features |= efx->fixed_features;
+	netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				 &net_dev->features);
+	netdev_feature_or(&net_dev->features, net_dev->features,
+			  efx->fixed_features);
 
 	rc = ef4_register_netdev(efx);
 	if (rc)
diff --git a/drivers/net/ethernet/sfc/falcon/falcon.c b/drivers/net/ethernet/sfc/falcon/falcon.c
index 3324a6219a09..cb8465b056ff 100644
--- a/drivers/net/ethernet/sfc/falcon/falcon.c
+++ b/drivers/net/ethernet/sfc/falcon/falcon.c
@@ -2799,7 +2799,7 @@ const struct ef4_nic_type falcon_a1_nic_type = {
 	.can_rx_scatter = false,
 	.max_interrupt_mode = EF4_INT_MODE_MSI,
 	.timer_period_max =  1 << FRF_AB_TC_TIMER_VAL_WIDTH,
-	.offload_features = NETIF_F_IP_CSUM,
+	.offload_features = { NETIF_F_IP_CSUM },
 };
 
 const struct ef4_nic_type falcon_b0_nic_type = {
@@ -2898,6 +2898,6 @@ const struct ef4_nic_type falcon_b0_nic_type = {
 	.can_rx_scatter = true,
 	.max_interrupt_mode = EF4_INT_MODE_MSIX,
 	.timer_period_max =  1 << FRF_AB_TC_TIMER_VAL_WIDTH,
-	.offload_features = NETIF_F_IP_CSUM | NETIF_F_RXHASH | NETIF_F_NTUPLE,
+	.offload_features = { NETIF_F_IP_CSUM | NETIF_F_RXHASH | NETIF_F_NTUPLE },
 	.max_rx_ip_filters = FR_BZ_RX_FILTER_TBL0_ROWS,
 };
diff --git a/drivers/net/ethernet/sfc/falcon/net_driver.h b/drivers/net/ethernet/sfc/falcon/net_driver.h
index 6fabfe7f02f5..942c539c76c2 100644
--- a/drivers/net/ethernet/sfc/falcon/net_driver.h
+++ b/drivers/net/ethernet/sfc/falcon/net_driver.h
@@ -1153,7 +1153,7 @@ struct ef4_nic_type {
 	bool always_rx_scatter;
 	unsigned int max_interrupt_mode;
 	unsigned int timer_period_max;
-	netdev_features_t offload_features;
+	u64 offload_features[NETDEV_FEATURE_DWORDS];
 	unsigned int max_rx_ip_filters;
 };
 
@@ -1303,7 +1303,7 @@ static inline void ef4_supported_features(const struct ef4_nic *efx,
 {
 	const struct net_device *net_dev = efx->net_dev;
 
-	*supported = net_dev->features | net_dev->hw_features;
+	netdev_feature_or(supported, net_dev->features, net_dev->hw_features);
 }
 
 /* Get the current TX queue insert index. */
diff --git a/drivers/net/ethernet/sfc/falcon/rx.c b/drivers/net/ethernet/sfc/falcon/rx.c
index 966f13e7475d..0fc41f8f4c85 100644
--- a/drivers/net/ethernet/sfc/falcon/rx.c
+++ b/drivers/net/ethernet/sfc/falcon/rx.c
@@ -438,7 +438,8 @@ ef4_rx_packet_gro(struct ef4_channel *channel, struct ef4_rx_buffer *rx_buf,
 		return;
 	}
 
-	if (efx->net_dev->features & NETIF_F_RXHASH)
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+				    efx->net_dev->features))
 		skb_set_hash(skb, ef4_rx_buf_hash(efx, eh),
 			     PKT_HASH_TYPE_L3);
 	skb->ip_summed = ((rx_buf->flags & EF4_RX_PKT_CSUMMED) ?
@@ -667,7 +668,8 @@ void __ef4_rx_packet(struct ef4_channel *channel)
 		goto out;
 	}
 
-	if (unlikely(!(efx->net_dev->features & NETIF_F_RXCSUM)))
+	if (unlikely(!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					      efx->net_dev->features)))
 		rx_buf->flags &= ~EF4_RX_PKT_CSUMMED;
 
 	if ((rx_buf->flags & EF4_RX_PKT_TCP) && !channel->type->receive_skb)
diff --git a/drivers/net/ethernet/sfc/farch.c b/drivers/net/ethernet/sfc/farch.c
index 148dcd48b58d..8e9507524b46 100644
--- a/drivers/net/ethernet/sfc/farch.c
+++ b/drivers/net/ethernet/sfc/farch.c
@@ -921,7 +921,7 @@ static u16 efx_farch_handle_rx_not_ok(struct efx_rx_queue *rx_queue,
 	(void) rx_ev_other_err;
 #endif
 
-	if (efx->net_dev->features & NETIF_F_RXALL)
+	if (netdev_feature_test_bit(NETIF_F_RXALL_BIT, efx->net_dev->features))
 		/* don't discard frame for CRC error */
 		rx_ev_eth_crc_err = false;
 
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index 8e788c3a6f2a..2a9a692da100 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -1322,16 +1322,20 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining)
 		goto fail;
 
 	efx_supported_features(efx, &supported);
-	if ((supported & NETIF_F_HW_VLAN_CTAG_FILTER) &&
+	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				    supported) &&
 	    !(efx_mcdi_filter_match_supported(table, false,
 		(EFX_FILTER_MATCH_OUTER_VID | EFX_FILTER_MATCH_LOC_MAC)) &&
 	      efx_mcdi_filter_match_supported(table, false,
 		(EFX_FILTER_MATCH_OUTER_VID | EFX_FILTER_MATCH_LOC_MAC_IG)))) {
 		netif_info(efx, probe, net_dev,
 			   "VLAN filters are not supported in this firmware variant\n");
-		net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-		efx->fixed_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-		net_dev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					 &net_dev->features);
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					 &efx->fixed_features);
+		netdev_feature_clear_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					 &net_dev->hw_features);
 	}
 
 	table->entry = vzalloc(array_size(EFX_MCDI_FILTER_TBL_ROWS,
@@ -1343,7 +1347,8 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining)
 
 	table->mc_promisc_last = false;
 	table->vlan_filter =
-		!!(efx->net_dev->features & NETIF_F_HW_VLAN_CTAG_FILTER);
+		netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					efx->net_dev->features);
 	INIT_LIST_HEAD(&table->vlan_list);
 	init_rwsem(&table->lock);
 
@@ -1760,7 +1765,8 @@ void efx_mcdi_filter_sync_rx_mode(struct efx_nic *efx)
 	 * Do it in advance to avoid conflicts for unicast untagged and
 	 * VLAN 0 tagged filters.
 	 */
-	vlan_filter = !!(net_dev->features & NETIF_F_HW_VLAN_CTAG_FILTER);
+	vlan_filter = netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					      net_dev->features);
 	if (table->vlan_filter != vlan_filter) {
 		table->vlan_filter = vlan_filter;
 		efx_mcdi_filter_remove_old(efx);
diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/mcdi_port_common.c
index 4bd3ef8f3384..81c4a8d79fba 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
@@ -1097,7 +1097,8 @@ int efx_mcdi_set_mac(struct efx_nic *efx)
 
 	MCDI_POPULATE_DWORD_1(cmdbytes, SET_MAC_IN_FLAGS,
 			      SET_MAC_IN_FLAG_INCLUDE_FCS,
-			      !!(efx->net_dev->features & NETIF_F_RXFCS));
+			      netdev_feature_test_bit(NETIF_F_RXFCS_BIT,
+						      efx->net_dev->features));
 
 	switch (efx->wanted_fc) {
 	case EFX_FC_RX | EFX_FC_TX:
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index bf962ca160e7..0c47ba740445 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1477,7 +1477,7 @@ struct efx_nic_type {
 	bool option_descriptors;
 	unsigned int min_interrupt_mode;
 	unsigned int timer_period_max;
-	netdev_features_t offload_features;
+	u64 offload_features[NETDEV_FEATURE_DWORDS];
 	int mcdi_max_ver;
 	unsigned int max_rx_ip_filters;
 	u32 hwtstamp_filters;
@@ -1686,7 +1686,7 @@ static inline void efx_supported_features(const struct efx_nic *efx,
 {
 	const struct net_device *net_dev = efx->net_dev;
 
-	*supported = net_dev->features | net_dev->hw_features;
+	netdev_feature_or(supported, net_dev->features, net_dev->hw_features);
 }
 
 /* Get the current TX queue insert index. */
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 606750938b89..1a9cb9aa400c 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -387,7 +387,8 @@ void __efx_rx_packet(struct efx_channel *channel)
 	if (!efx_do_xdp(efx, channel, rx_buf, &eh))
 		goto out;
 
-	if (unlikely(!(efx->net_dev->features & NETIF_F_RXCSUM)))
+	if (unlikely(!netdev_feature_test_bit(NETIF_F_RXCSUM_BIT,
+					      efx->net_dev->features)))
 		rx_buf->flags &= ~EFX_RX_PKT_CSUMMED;
 
 	if ((rx_buf->flags & EFX_RX_PKT_TCP) && !channel->type->receive_skb)
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 68fc7d317693..dc01d246682b 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -525,7 +525,8 @@ efx_rx_packet_gro(struct efx_channel *channel, struct efx_rx_buffer *rx_buf,
 		return;
 	}
 
-	if (efx->net_dev->features & NETIF_F_RXHASH &&
+	if (netdev_feature_test_bit(NETIF_F_RXHASH_BIT,
+				    efx->net_dev->features) &&
 	    efx_rx_buf_hash_valid(efx, eh))
 		skb_set_hash(skb, efx_rx_buf_hash(efx, eh),
 			     PKT_HASH_TYPE_L3);
@@ -804,7 +805,7 @@ int efx_probe_filters(struct efx_nic *efx)
 		goto out_unlock;
 
 #ifdef CONFIG_RFS_ACCEL
-	if (efx->type->offload_features & NETIF_F_NTUPLE) {
+	if (efx->type->offload_features[0] & NETIF_F_NTUPLE) {
 		struct efx_channel *channel;
 		int i, success = 1;
 
diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
index 16347a6d0c47..d9578baad5a0 100644
--- a/drivers/net/ethernet/sfc/siena.c
+++ b/drivers/net/ethernet/sfc/siena.c
@@ -1088,8 +1088,8 @@ const struct efx_nic_type siena_a0_nic_type = {
 	.option_descriptors = false,
 	.min_interrupt_mode = EFX_INT_MODE_LEGACY,
 	.timer_period_max = 1 << FRF_CZ_TC_TIMER_VAL_WIDTH,
-	.offload_features = (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			     NETIF_F_RXHASH | NETIF_F_NTUPLE),
+	.offload_features = { (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+			       NETIF_F_RXHASH | NETIF_F_NTUPLE) },
 	.mcdi_max_ver = 1,
 	.max_rx_ip_filters = FR_BZ_RX_FILTER_TBL0_ROWS,
 	.hwtstamp_filters = (1 << HWTSTAMP_FILTER_NONE |
-- 
2.33.0

