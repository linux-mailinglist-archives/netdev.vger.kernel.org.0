Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61488506217
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 04:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344815AbiDSCbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 22:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344693AbiDSCa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 22:30:58 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1882E6B0
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 19:27:57 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Kj74k6p0hzhXYR;
        Tue, 19 Apr 2022 10:27:50 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Apr 2022 10:27:55 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>,
        <lipeng321@huawei.com>
Subject: [RFCv6 PATCH net-next 12/19] net: use netdev_feature_test helpers
Date:   Tue, 19 Apr 2022 10:21:59 +0800
Message-ID: <20220419022206.36381-13-shenjian15@huawei.com>
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

Replace the '&' operations of single feature bit by
netdev_feature_test helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 30 +++---
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  4 +-
 drivers/net/ethernet/sfc/ef10.c               |  2 +-
 drivers/net/ethernet/sfc/ef100_rx.c           |  4 +-
 drivers/net/ethernet/sfc/ef100_tx.c           |  8 +-
 drivers/net/ethernet/sfc/efx_common.c         |  6 +-
 drivers/net/ethernet/sfc/falcon/efx.c         |  7 +-
 drivers/net/ethernet/sfc/falcon/rx.c          |  4 +-
 drivers/net/ethernet/sfc/farch.c              |  2 +-
 drivers/net/ethernet/sfc/mcdi_filters.c       |  4 +-
 drivers/net/ethernet/sfc/mcdi_port_common.c   |  2 +-
 drivers/net/ethernet/sfc/rx.c                 |  2 +-
 drivers/net/ethernet/sfc/rx_common.c          |  4 +-
 include/linux/netdev_features_helper.h        |  4 +-
 include/linux/netdevice.h                     | 19 ++--
 net/core/dev.c                                | 93 ++++++++++---------
 net/ethtool/ioctl.c                           | 10 +-
 17 files changed, 111 insertions(+), 94 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 38706313aa6c..f872a624faad 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1503,7 +1503,8 @@ static int hns3_handle_vtags(struct hns3_enet_ring *tx_ring,
 		return -EINVAL;
 
 	if (skb->protocol == htons(ETH_P_8021Q) &&
-	    !(handle->kinfo.netdev->features & NETIF_F_HW_VLAN_CTAG_TX)) {
+	    !netdev_active_feature_test(handle->kinfo.netdev,
+					NETIF_F_HW_VLAN_CTAG_TX_BIT)) {
 		/* When HW VLAN acceleration is turned off, and the stack
 		 * sets the protocol to 802.1q, the driver just need to
 		 * set the protocol to the encapsulated ethertype.
@@ -2413,36 +2414,41 @@ static int hns3_nic_set_features(struct net_device *netdev,
 
 	changed = netdev_active_features_xor(netdev, features);
 
-	if (changed & (NETIF_F_GRO_HW) && h->ae_algo->ops->set_gro_en) {
-		enable = !!(features & NETIF_F_GRO_HW);
+	if (netdev_feature_test(NETIF_F_GRO_HW_BIT, changed) &&
+	    h->ae_algo->ops->set_gro_en) {
+		enable = netdev_feature_test(NETIF_F_GRO_HW_BIT, features);
 		ret = h->ae_algo->ops->set_gro_en(h, enable);
 		if (ret)
 			return ret;
 	}
 
-	if ((changed & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed) &&
 	    h->ae_algo->ops->enable_hw_strip_rxvtag) {
-		enable = !!(features & NETIF_F_HW_VLAN_CTAG_RX);
+		enable = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					     features);
 		ret = h->ae_algo->ops->enable_hw_strip_rxvtag(h, enable);
 		if (ret)
 			return ret;
 	}
 
-	if ((changed & NETIF_F_NTUPLE) && h->ae_algo->ops->enable_fd) {
-		enable = !!(features & NETIF_F_NTUPLE);
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, changed) &&
+	    h->ae_algo->ops->enable_fd) {
+		enable = netdev_feature_test(NETIF_F_NTUPLE_BIT, features);
 		h->ae_algo->ops->enable_fd(h, enable);
 	}
 
-	if ((netdev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
+	if (netdev_active_feature_test(netdev, NETIF_F_HW_TC_BIT) &&
+	    !netdev_feature_test(NETIF_F_HW_TC_BIT, features) &&
 	    h->ae_algo->ops->cls_flower_active(h)) {
 		netdev_err(netdev,
 			   "there are offloaded TC filters active, cannot disable HW TC offload");
 		return -EINVAL;
 	}
 
-	if ((changed & NETIF_F_HW_VLAN_CTAG_FILTER) &&
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, changed) &&
 	    h->ae_algo->ops->enable_vlan_filter) {
-		enable = !!(features & NETIF_F_HW_VLAN_CTAG_FILTER);
+		enable = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+					     features);
 		ret = h->ae_algo->ops->enable_vlan_filter(h, enable);
 		if (ret)
 			return ret;
@@ -3905,7 +3911,7 @@ static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
 
 	skb_checksum_none_assert(skb);
 
-	if (!(netdev->features & NETIF_F_RXCSUM))
+	if (!netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT))
 		return;
 
 	if (test_bit(HNS3_NIC_STATE_RXD_ADV_LAYOUT_ENABLE, &priv->state))
@@ -4196,7 +4202,7 @@ static void hns3_handle_rx_vlan_tag(struct hns3_enet_ring *ring,
 	 * ot_vlan_tag in two layer tag case, and stored at vlan_tag
 	 * in one layer tag case.
 	 */
-	if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
+	if (netdev_active_feature_test(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT)) {
 		u16 vlan_tag;
 
 		if (hns3_parse_vlan_tag(ring, desc, l234info, &vlan_tag))
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index f4da77452126..088243621641 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -339,7 +339,7 @@ static void hns3_selftest_prepare(struct net_device *ndev,
 #if IS_ENABLED(CONFIG_VLAN_8021Q)
 	/* Disable the vlan filter for selftest does not support it */
 	if (h->ae_algo->ops->enable_vlan_filter &&
-	    ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	    netdev_active_feature_test(ndev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT))
 		h->ae_algo->ops->enable_vlan_filter(h, false);
 #endif
 
@@ -365,7 +365,7 @@ static void hns3_selftest_restore(struct net_device *ndev, bool if_running)
 
 #if IS_ENABLED(CONFIG_VLAN_8021Q)
 	if (h->ae_algo->ops->enable_vlan_filter &&
-	    ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	    netdev_active_feature_test(ndev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT))
 		h->ae_algo->ops->enable_vlan_filter(h, true);
 #endif
 
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 0674565d9ed1..bf8274c03176 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -2703,7 +2703,7 @@ static u16 efx_ef10_handle_rx_event_errors(struct efx_channel *channel,
 	bool handled = false;
 
 	if (EFX_QWORD_FIELD(*event, ESF_DZ_RX_ECRC_ERR)) {
-		if (!(efx->net_dev->features & NETIF_F_RXALL)) {
+		if (!netdev_active_feature_test(efx->net_dev, NETIF_F_RXALL_BIT)) {
 			if (!efx->loopback_selftest)
 				channel->n_rx_eth_crc_err += n_packets;
 			return EFX_RX_PKT_DISCARD;
diff --git a/drivers/net/ethernet/sfc/ef100_rx.c b/drivers/net/ethernet/sfc/ef100_rx.c
index 85207acf7dee..cebd442c2261 100644
--- a/drivers/net/ethernet/sfc/ef100_rx.c
+++ b/drivers/net/ethernet/sfc/ef100_rx.c
@@ -64,7 +64,7 @@ void __ef100_rx_packet(struct efx_channel *channel)
 	prefix = (u32 *)(eh - ESE_GZ_RX_PKT_PREFIX_LEN);
 
 	if (ef100_has_fcs_error(channel, prefix) &&
-	    unlikely(!(efx->net_dev->features & NETIF_F_RXALL)))
+	    unlikely(!netdev_active_feature_test(efx->net_dev, NETIF_F_RXALL_BIT)))
 		goto out;
 
 	rx_buf->len = le16_to_cpu((__force __le16)PREFIX_FIELD(prefix, LENGTH));
@@ -76,7 +76,7 @@ void __ef100_rx_packet(struct efx_channel *channel)
 		goto out;
 	}
 
-	if (likely(efx->net_dev->features & NETIF_F_RXCSUM)) {
+	if (likely(netdev_active_feature_test(efx->net_dev, NETIF_F_RXCSUM_BIT))) {
 		if (PREFIX_FIELD(prefix, NT_OR_INNER_L3_CLASS) == 1) {
 			++channel->n_rx_ip_hdr_chksum_err;
 		} else {
diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
index 26ef51d6b542..4a85f53d672a 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.c
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -61,7 +61,7 @@ static bool ef100_tx_can_tso(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 
 	if (!skb_is_gso_tcp(skb))
 		return false;
-	if (!(efx->net_dev->features & NETIF_F_TSO))
+	if (!netdev_active_feature_test(efx->net_dev, NETIF_F_TSO_BIT))
 		return false;
 
 	mss = skb_shinfo(skb)->gso_size;
@@ -175,9 +175,9 @@ static void ef100_make_send_desc(struct efx_nic *efx,
 			     ESF_GZ_TX_SEND_LEN, buffer->len,
 			     ESF_GZ_TX_SEND_ADDR, buffer->dma_addr);
 
-	if (likely(efx->net_dev->features & NETIF_F_HW_CSUM))
+	if (likely(netdev_active_feature_test(efx->net_dev, NETIF_F_HW_CSUM_BIT)))
 		ef100_set_tx_csum_partial(skb, buffer, txd);
-	if (efx->net_dev->features & NETIF_F_HW_VLAN_CTAG_TX &&
+	if (netdev_active_feature_test(efx->net_dev, NETIF_F_HW_VLAN_CTAG_TX_BIT) &&
 	    skb && skb_vlan_tag_present(skb))
 		ef100_set_tx_hw_vlan(skb, txd);
 }
@@ -202,7 +202,7 @@ static void ef100_make_tso_desc(struct efx_nic *efx,
 
 	if (skb_shinfo(skb)->gso_type & SKB_GSO_TCP_FIXEDID)
 		mangleid = ESE_GZ_TX_DESC_IP4_ID_NO_OP;
-	if (efx->net_dev->features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (netdev_active_feature_test(efx->net_dev, NETIF_F_HW_VLAN_CTAG_TX_BIT))
 		vlan_enable = skb_vlan_tag_present(skb);
 
 	len = skb->len - buffer->len;
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 8b95525aad20..31363adcf5f1 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -217,7 +217,7 @@ int efx_set_features(struct net_device *net_dev, netdev_features_t data)
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
 	tmp = netdev_active_features_andnot(net_dev, data);
-	if (tmp & NETIF_F_NTUPLE) {
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, tmp)) {
 		rc = efx->type->filter_clear_rx(efx, EFX_FILTER_PRI_MANUAL);
 		if (rc)
 			return rc;
@@ -227,8 +227,8 @@ int efx_set_features(struct net_device *net_dev, netdev_features_t data)
 	 * If rx-fcs is changed, mac_reconfigure updates that too.
 	 */
 	tmp = netdev_active_features_xor(net_dev, data);
-	if (tmp & NETIF_F_HW_VLAN_CTAG_FILTER ||
-	    tmp & NETIF_F_RXFCS) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, tmp) ||
+	    netdev_feature_test(NETIF_F_RXFCS_BIT, tmp)) {
 		/* efx_set_rx_mode() will schedule MAC work to update filters
 		 * when a new features are finally set in net_dev.
 		 */
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 921617de3638..52d3ced17602 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -1695,7 +1695,8 @@ static int ef4_probe_filters(struct ef4_nic *efx)
 		goto out_unlock;
 
 #ifdef CONFIG_RFS_ACCEL
-	if (*efx->type->offload_features & NETIF_F_NTUPLE) {
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT,
+				*efx->type->offload_features)) {
 		struct ef4_channel *channel;
 		int i, success = 1;
 
@@ -2194,7 +2195,7 @@ static int ef4_set_features(struct net_device *net_dev, netdev_features_t data)
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
 	tmp = netdev_active_features_andnot(net_dev, data);
-	if (tmp & NETIF_F_NTUPLE) {
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, tmp)) {
 		rc = efx->type->filter_clear_rx(efx, EF4_FILTER_PRI_MANUAL);
 		if (rc)
 			return rc;
@@ -2202,7 +2203,7 @@ static int ef4_set_features(struct net_device *net_dev, netdev_features_t data)
 
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure */
 	tmp = netdev_active_features_xor(net_dev, data);
-	if (tmp & NETIF_F_HW_VLAN_CTAG_FILTER) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, tmp)) {
 		/* ef4_set_rx_mode() will schedule MAC work to update filters
 		 * when a new features are finally set in net_dev.
 		 */
diff --git a/drivers/net/ethernet/sfc/falcon/rx.c b/drivers/net/ethernet/sfc/falcon/rx.c
index 0c6cc2191369..2b587735b4ad 100644
--- a/drivers/net/ethernet/sfc/falcon/rx.c
+++ b/drivers/net/ethernet/sfc/falcon/rx.c
@@ -443,7 +443,7 @@ ef4_rx_packet_gro(struct ef4_channel *channel, struct ef4_rx_buffer *rx_buf,
 		return;
 	}
 
-	if (efx->net_dev->features & NETIF_F_RXHASH)
+	if (netdev_active_feature_test(efx->net_dev, NETIF_F_RXHASH_BIT))
 		skb_set_hash(skb, ef4_rx_buf_hash(efx, eh),
 			     PKT_HASH_TYPE_L3);
 	skb->ip_summed = ((rx_buf->flags & EF4_RX_PKT_CSUMMED) ?
@@ -672,7 +672,7 @@ void __ef4_rx_packet(struct ef4_channel *channel)
 		goto out;
 	}
 
-	if (unlikely(!(efx->net_dev->features & NETIF_F_RXCSUM)))
+	if (unlikely(!netdev_active_feature_test(efx->net_dev, NETIF_F_RXCSUM_BIT)))
 		rx_buf->flags &= ~EF4_RX_PKT_CSUMMED;
 
 	if ((rx_buf->flags & EF4_RX_PKT_TCP) && !channel->type->receive_skb)
diff --git a/drivers/net/ethernet/sfc/farch.c b/drivers/net/ethernet/sfc/farch.c
index 148dcd48b58d..061e67724f2e 100644
--- a/drivers/net/ethernet/sfc/farch.c
+++ b/drivers/net/ethernet/sfc/farch.c
@@ -921,7 +921,7 @@ static u16 efx_farch_handle_rx_not_ok(struct efx_rx_queue *rx_queue,
 	(void) rx_ev_other_err;
 #endif
 
-	if (efx->net_dev->features & NETIF_F_RXALL)
+	if (netdev_active_feature_test(efx->net_dev, NETIF_F_RXALL_BIT))
 		/* don't discard frame for CRC error */
 		rx_ev_eth_crc_err = false;
 
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index 508549db124b..d0bb15312e28 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -1343,7 +1343,7 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining)
 
 	table->mc_promisc_last = false;
 	table->vlan_filter =
-		!!(efx->net_dev->features & NETIF_F_HW_VLAN_CTAG_FILTER);
+		netdev_active_feature_test(efx->net_dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	INIT_LIST_HEAD(&table->vlan_list);
 	init_rwsem(&table->lock);
 
@@ -1760,7 +1760,7 @@ void efx_mcdi_filter_sync_rx_mode(struct efx_nic *efx)
 	 * Do it in advance to avoid conflicts for unicast untagged and
 	 * VLAN 0 tagged filters.
 	 */
-	vlan_filter = !!(net_dev->features & NETIF_F_HW_VLAN_CTAG_FILTER);
+	vlan_filter = netdev_active_feature_test(net_dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	if (table->vlan_filter != vlan_filter) {
 		table->vlan_filter = vlan_filter;
 		efx_mcdi_filter_remove_old(efx);
diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/mcdi_port_common.c
index 899cc1671004..52f24c51cdfc 100644
--- a/drivers/net/ethernet/sfc/mcdi_port_common.c
+++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
@@ -1110,7 +1110,7 @@ int efx_mcdi_set_mac(struct efx_nic *efx)
 
 	MCDI_POPULATE_DWORD_1(cmdbytes, SET_MAC_IN_FLAGS,
 			      SET_MAC_IN_FLAG_INCLUDE_FCS,
-			      !!(efx->net_dev->features & NETIF_F_RXFCS));
+			      netdev_active_feature_test(efx->net_dev, NETIF_F_RXFCS_BIT));
 
 	switch (efx->wanted_fc) {
 	case EFX_FC_RX | EFX_FC_TX:
diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
index 2375cef577e4..f64ae5623309 100644
--- a/drivers/net/ethernet/sfc/rx.c
+++ b/drivers/net/ethernet/sfc/rx.c
@@ -387,7 +387,7 @@ void __efx_rx_packet(struct efx_channel *channel)
 	if (!efx_do_xdp(efx, channel, rx_buf, &eh))
 		goto out;
 
-	if (unlikely(!(efx->net_dev->features & NETIF_F_RXCSUM)))
+	if (unlikely(!netdev_active_feature_test(efx->net_dev, NETIF_F_RXCSUM_BIT)))
 		rx_buf->flags &= ~EFX_RX_PKT_CSUMMED;
 
 	if ((rx_buf->flags & EFX_RX_PKT_TCP) && !channel->type->receive_skb)
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index acdc3c84aaaa..ce0f78135f81 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -517,7 +517,7 @@ efx_rx_packet_gro(struct efx_channel *channel, struct efx_rx_buffer *rx_buf,
 		return;
 	}
 
-	if (efx->net_dev->features & NETIF_F_RXHASH &&
+	if (netdev_active_feature_test(efx->net_dev, NETIF_F_RXHASH_BIT) &&
 	    efx_rx_buf_hash_valid(efx, eh))
 		skb_set_hash(skb, efx_rx_buf_hash(efx, eh),
 			     PKT_HASH_TYPE_L3);
@@ -796,7 +796,7 @@ int efx_probe_filters(struct efx_nic *efx)
 		goto out_unlock;
 
 #ifdef CONFIG_RFS_ACCEL
-	if (*efx->type->offload_features & NETIF_F_NTUPLE) {
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, *efx->type->offload_features)) {
 		struct efx_channel *channel;
 		int i, success = 1;
 
diff --git a/include/linux/netdev_features_helper.h b/include/linux/netdev_features_helper.h
index 067b90ca3084..56bdec209b1c 100644
--- a/include/linux/netdev_features_helper.h
+++ b/include/linux/netdev_features_helper.h
@@ -588,8 +588,8 @@ static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 	netdev_features_t tmp;
 
 	tmp = netdev_features_xor(f1, f2);
-	if (tmp & NETIF_F_HW_CSUM) {
-		if (f1 & NETIF_F_HW_CSUM)
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, tmp)) {
+		if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, f1))
 			netdev_features_set(&f1, netdev_ip_csum_features);
 		else
 			netdev_features_set(&f2, netdev_ip_csum_features);
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a092423653e2..91983aede92c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2333,7 +2333,7 @@ static inline bool netdev_feature_test(int nr, const netdev_features_t src)
 
 static inline bool netif_elide_gro(const struct net_device *dev)
 {
-	if (!(dev->features & NETIF_F_GRO) || dev->xdp_prog)
+	if (!netdev_active_feature_test(dev, NETIF_F_GRO_BIT) || dev->xdp_prog)
 		return true;
 	return false;
 }
@@ -4354,7 +4354,7 @@ static inline void netif_tx_unlock_bh(struct net_device *dev)
 }
 
 #define HARD_TX_LOCK(dev, txq, cpu) {			\
-	if ((dev->features & NETIF_F_LLTX) == 0) {	\
+	if (!netdev_active_feature_test(dev, NETIF_F_LLTX_BIT)) {	\
 		__netif_tx_lock(txq, cpu);		\
 	} else {					\
 		__netif_tx_acquire(txq);		\
@@ -4362,12 +4362,12 @@ static inline void netif_tx_unlock_bh(struct net_device *dev)
 }
 
 #define HARD_TX_TRYLOCK(dev, txq)			\
-	(((dev->features & NETIF_F_LLTX) == 0) ?	\
+	(!netdev_active_feature_test(dev, NETIF_F_LLTX_BIT) ?	\
 		__netif_tx_trylock(txq) :		\
 		__netif_tx_acquire(txq))
 
 #define HARD_TX_UNLOCK(dev, txq) {			\
-	if ((dev->features & NETIF_F_LLTX) == 0) {	\
+	if (!netdev_active_feature_test(dev, NETIF_F_LLTX_BIT)) {	\
 		__netif_tx_unlock(txq);			\
 	} else {					\
 		__netif_tx_release(txq);		\
@@ -4768,20 +4768,20 @@ static inline bool can_checksum_protocol(netdev_features_t features,
 					 __be16 protocol)
 {
 	if (protocol == htons(ETH_P_FCOE))
-		return !!(features & NETIF_F_FCOE_CRC);
+		return netdev_feature_test(NETIF_F_FCOE_CRC_BIT, features);
 
 	/* Assume this is an IP checksum (not SCTP CRC) */
 
-	if (features & NETIF_F_HW_CSUM) {
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, features)) {
 		/* Can checksum everything */
 		return true;
 	}
 
 	switch (protocol) {
 	case htons(ETH_P_IP):
-		return !!(features & NETIF_F_IP_CSUM);
+		return netdev_feature_test(NETIF_F_IP_CSUM_BIT, features);
 	case htons(ETH_P_IPV6):
-		return !!(features & NETIF_F_IPV6_CSUM);
+		return netdev_feature_test(NETIF_F_IPV6_CSUM_BIT, features);
 	default:
 		return false;
 	}
@@ -4898,7 +4898,8 @@ static inline bool net_gso_ok(netdev_features_t features, int gso_type)
 static inline bool skb_gso_ok(struct sk_buff *skb, netdev_features_t features)
 {
 	return net_gso_ok(features, skb_shinfo(skb)->gso_type) &&
-	       (!skb_has_frag_list(skb) || (features & NETIF_F_FRAGLIST));
+	       (!skb_has_frag_list(skb) ||
+	       netdev_feature_test(NETIF_F_FRAGLIST_BIT, features));
 }
 
 static inline bool netif_needs_gso(struct sk_buff *skb,
diff --git a/net/core/dev.c b/net/core/dev.c
index 124d48b5d61a..2bcb65722583 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1586,7 +1586,7 @@ void dev_disable_lro(struct net_device *dev)
 	netdev_wanted_feature_del(dev, NETIF_F_LRO_BIT);
 	netdev_update_features(dev);
 
-	if (unlikely(dev->features & NETIF_F_LRO))
+	if (unlikely(netdev_active_feature_test(dev, NETIF_F_LRO_BIT)))
 		netdev_WARN(dev, "failed to disable LRO!\n");
 
 	netdev_for_each_lower_dev(dev, lower_dev, iter)
@@ -1607,7 +1607,7 @@ static void dev_disable_gro_hw(struct net_device *dev)
 	netdev_wanted_feature_del(dev, NETIF_F_GRO_HW_BIT);
 	netdev_update_features(dev);
 
-	if (unlikely(dev->features & NETIF_F_GRO_HW))
+	if (unlikely(netdev_active_feature_test(dev, NETIF_F_GRO_HW_BIT)))
 		netdev_WARN(dev, "failed to disable GRO_HW!\n");
 }
 
@@ -3339,7 +3339,7 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 	 * support segmentation on this frame without needing additional
 	 * work.
 	 */
-	if (features & NETIF_F_GSO_PARTIAL) {
+	if (netdev_feature_test(NETIF_F_GSO_PARTIAL_BIT, features)) {
 		netdev_features_t partial_features;
 		struct net_device *dev = skb->dev;
 
@@ -3389,7 +3389,7 @@ static int illegal_highdma(struct net_device *dev, struct sk_buff *skb)
 #ifdef CONFIG_HIGHMEM
 	int i;
 
-	if (!(dev->features & NETIF_F_HIGHDMA)) {
+	if (!netdev_active_feature_test(dev, NETIF_F_HIGHDMA_BIT)) {
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
@@ -3587,10 +3587,10 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 			    const netdev_features_t features)
 {
 	if (unlikely(skb_csum_is_sctp(skb)))
-		return !!(features & NETIF_F_SCTP_CRC) ? 0 :
+		return netdev_feature_test(NETIF_F_SCTP_CRC_BIT, features) ? 0 :
 			skb_crc32c_csum_help(skb);
 
-	if (features & NETIF_F_HW_CSUM)
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, features))
 		return 0;
 
 	if (features & netdev_ip_csum_features) {
@@ -4343,7 +4343,7 @@ set_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 
 		/* Should we steer this flow to a different hardware queue? */
 		if (!skb_rx_queue_recorded(skb) || !dev->rx_cpu_rmap ||
-		    !(dev->features & NETIF_F_NTUPLE))
+		    !netdev_active_feature_test(dev, NETIF_F_NTUPLE_BIT))
 			goto out;
 		rxq_index = cpu_rmap_lookup_index(dev->rx_cpu_rmap, next_cpu);
 		if (rxq_index == skb_get_rx_queue(skb))
@@ -9503,89 +9503,94 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 	netdev_features_t tmp;
 
 	/* Fix illegal checksum combinations */
-	if ((features & NETIF_F_HW_CSUM) &&
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, features) &&
 	    (features & netdev_ip_csum_features)) {
 		netdev_warn(dev, "mixed HW and IP checksum settings.\n");
 		netdev_features_clear(&features, netdev_ip_csum_features);
 	}
 
 	/* TSO requires that SG is present as well. */
-	if ((features & NETIF_F_ALL_TSO) && !(features & NETIF_F_SG)) {
+	if (features & NETIF_F_ALL_TSO && !netdev_feature_test(NETIF_F_SG_BIT, features)) {
 		netdev_dbg(dev, "Dropping TSO features since no SG feature.\n");
 		netdev_features_clear(&features, NETIF_F_ALL_TSO);
 	}
 
-	if ((features & NETIF_F_TSO) && !(features & NETIF_F_HW_CSUM) &&
-					!(features & NETIF_F_IP_CSUM)) {
+	if (netdev_feature_test(NETIF_F_TSO_BIT, features) &&
+	    !netdev_feature_test(NETIF_F_HW_CSUM_BIT, features) &&
+	    !netdev_feature_test(NETIF_F_IP_CSUM_BIT, features)) {
 		netdev_dbg(dev, "Dropping TSO features since no CSUM feature.\n");
 		netdev_feature_del(NETIF_F_TSO_BIT, &features);
 		netdev_feature_del(NETIF_F_TSO_ECN_BIT, &features);
 	}
 
-	if ((features & NETIF_F_TSO6) && !(features & NETIF_F_HW_CSUM) &&
-					 !(features & NETIF_F_IPV6_CSUM)) {
+	if (netdev_feature_test(NETIF_F_TSO6_BIT, features) &&
+	    !netdev_feature_test(NETIF_F_HW_CSUM_BIT, features) &&
+	    !netdev_feature_test(NETIF_F_IPV6_CSUM_BIT, features)) {
 		netdev_dbg(dev, "Dropping TSO6 features since no CSUM feature.\n");
 		netdev_feature_del(NETIF_F_TSO6_BIT, &features);
 	}
 
 	/* TSO with IPv4 ID mangling requires IPv4 TSO be enabled */
-	if ((features & NETIF_F_TSO_MANGLEID) && !(features & NETIF_F_TSO))
+	if (netdev_feature_test(NETIF_F_TSO_MANGLEID_BIT, features) &&
+	    !netdev_feature_test(NETIF_F_TSO_BIT, features))
 		netdev_feature_del(NETIF_F_TSO_MANGLEID_BIT, &features);
 
 	/* TSO ECN requires that TSO is present as well. */
 	tmp = NETIF_F_ALL_TSO;
 	netdev_feature_del(NETIF_F_TSO_ECN_BIT, &tmp);
-	if (!(features & tmp) && (features & NETIF_F_TSO_ECN))
+	if (!(features & tmp) && netdev_feature_test(NETIF_F_TSO_ECN_BIT, features))
 		netdev_feature_del(NETIF_F_TSO_ECN_BIT, &features);
 
 	/* Software GSO depends on SG. */
-	if ((features & NETIF_F_GSO) && !(features & NETIF_F_SG)) {
+	if ((netdev_feature_test(NETIF_F_GSO_BIT, features)) && !(netdev_feature_test(NETIF_F_SG_BIT, features))) {
 		netdev_dbg(dev, "Dropping NETIF_F_GSO since no SG feature.\n");
 		netdev_feature_del(NETIF_F_GSO_BIT, &features);
 	}
 
 	/* GSO partial features require GSO partial be set */
 	if ((features & dev->gso_partial_features) &&
-	    !(features & NETIF_F_GSO_PARTIAL)) {
+	    !netdev_feature_test(NETIF_F_GSO_PARTIAL_BIT, features)) {
 		netdev_dbg(dev,
 			   "Dropping partially supported GSO features since no GSO partial.\n");
 		netdev_features_clear(&features, dev->gso_partial_features);
 	}
 
-	if (!(features & NETIF_F_RXCSUM)) {
+	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features)) {
 		/* NETIF_F_GRO_HW implies doing RXCSUM since every packet
 		 * successfully merged by hardware must also have the
 		 * checksum verified by hardware.  If the user does not
 		 * want to enable RXCSUM, logically, we should disable GRO_HW.
 		 */
-		if (features & NETIF_F_GRO_HW) {
+		if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features)) {
 			netdev_dbg(dev, "Dropping NETIF_F_GRO_HW since no RXCSUM feature.\n");
 			netdev_feature_del(NETIF_F_GRO_HW_BIT, &features);
 		}
 	}
 
 	/* LRO/HW-GRO features cannot be combined with RX-FCS */
-	if (features & NETIF_F_RXFCS) {
-		if (features & NETIF_F_LRO) {
+	if (netdev_feature_test(NETIF_F_RXFCS_BIT, features)) {
+		if (netdev_feature_test(NETIF_F_LRO_BIT, features)) {
 			netdev_dbg(dev, "Dropping LRO feature since RX-FCS is requested.\n");
 			netdev_feature_del(NETIF_F_LRO_BIT, &features);
 		}
 
-		if (features & NETIF_F_GRO_HW) {
+		if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features)) {
 			netdev_dbg(dev, "Dropping HW-GRO feature since RX-FCS is requested.\n");
 			netdev_feature_del(NETIF_F_GRO_HW_BIT, &features);
 		}
 	}
 
-	if ((features & NETIF_F_GRO_HW) && (features & NETIF_F_LRO)) {
+	if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features) &&
+	    netdev_feature_test(NETIF_F_LRO_BIT, features)) {
 		netdev_dbg(dev, "Dropping LRO feature since HW-GRO is requested.\n");
 		netdev_feature_del(NETIF_F_LRO_BIT, &features);
 	}
 
-	if (features & NETIF_F_HW_TLS_TX) {
+	if (netdev_feature_test(NETIF_F_HW_TLS_TX_BIT, features)) {
 		bool ip_csum = (features & netdev_ip_csum_features) ==
 			netdev_ip_csum_features;
-		bool hw_csum = features & NETIF_F_HW_CSUM;
+		bool hw_csum = netdev_feature_test(NETIF_F_HW_CSUM_BIT,
+						   features);
 
 		if (!ip_csum && !hw_csum) {
 			netdev_dbg(dev, "Dropping TLS TX HW offload feature since no CSUM feature.\n");
@@ -9593,7 +9598,8 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 		}
 	}
 
-	if ((features & NETIF_F_HW_TLS_RX) && !(features & NETIF_F_RXCSUM)) {
+	if (netdev_feature_test(NETIF_F_HW_TLS_RX_BIT, features) &&
+	    !netdev_feature_test(NETIF_F_RXCSUM_BIT, features)) {
 		netdev_dbg(dev, "Dropping TLS RX HW offload feature since no RXCSUM feature.\n");
 		netdev_feature_del(NETIF_F_HW_TLS_RX_BIT, &features);
 	}
@@ -9655,7 +9661,7 @@ int __netdev_update_features(struct net_device *dev)
 
 		diff = netdev_features_xor(features, dev->features);
 
-		if (diff & NETIF_F_RX_UDP_TUNNEL_PORT) {
+		if (netdev_feature_test(NETIF_F_RX_UDP_TUNNEL_PORT_BIT, diff)) {
 			/* udp_tunnel_{get,drop}_rx_info both need
 			 * NETIF_F_RX_UDP_TUNNEL_PORT enabled on the
 			 * device, or they won't do anything.
@@ -9663,7 +9669,8 @@ int __netdev_update_features(struct net_device *dev)
 			 * *before* calling udp_tunnel_get_rx_info,
 			 * but *after* calling udp_tunnel_drop_rx_info.
 			 */
-			if (features & NETIF_F_RX_UDP_TUNNEL_PORT) {
+			if (netdev_feature_test(NETIF_F_RX_UDP_TUNNEL_PORT_BIT,
+						features)) {
 				dev->features = features;
 				udp_tunnel_get_rx_info(dev);
 			} else {
@@ -9671,8 +9678,9 @@ int __netdev_update_features(struct net_device *dev)
 			}
 		}
 
-		if (diff & NETIF_F_HW_VLAN_CTAG_FILTER) {
-			if (features & NETIF_F_HW_VLAN_CTAG_FILTER) {
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, diff)) {
+			if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+						features)) {
 				dev->features = features;
 				err |= vlan_get_rx_ctag_filter_info(dev);
 			} else {
@@ -9680,8 +9688,9 @@ int __netdev_update_features(struct net_device *dev)
 			}
 		}
 
-		if (diff & NETIF_F_HW_VLAN_STAG_FILTER) {
-			if (features & NETIF_F_HW_VLAN_STAG_FILTER) {
+		if (netdev_feature_test(NETIF_F_HW_VLAN_STAG_FILTER_BIT, diff)) {
+			if (netdev_feature_test(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
+						features)) {
 				dev->features = features;
 				err |= vlan_get_rx_stag_filter_info(dev);
 			} else {
@@ -9915,8 +9924,8 @@ int register_netdevice(struct net_device *dev)
 		}
 	}
 
-	if ((dev->hw_features & NETIF_F_HW_VLAN_CTAG_FILTER ||
-	     dev->features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
+	if ((netdev_hw_feature_test(dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT) ||
+	     netdev_active_feature_test(dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT)) &&
 	    (!dev->netdev_ops->ndo_vlan_rx_add_vid ||
 	     !dev->netdev_ops->ndo_vlan_rx_kill_vid)) {
 		netdev_WARN(dev, "Buggy VLAN acceleration in driver!\n");
@@ -9952,13 +9961,13 @@ int register_netdevice(struct net_device *dev)
 	 * of ignoring a static IP ID value.  This doesn't enable the
 	 * feature itself but allows the user to enable it later.
 	 */
-	if (dev->hw_features & NETIF_F_TSO)
+	if (netdev_hw_feature_test(dev, NETIF_F_TSO_BIT))
 		netdev_hw_feature_add(dev, NETIF_F_TSO_MANGLEID_BIT);
-	if (dev->vlan_features & NETIF_F_TSO)
+	if (netdev_vlan_feature_test(dev, NETIF_F_TSO_BIT))
 		netdev_vlan_feature_add(dev, NETIF_F_TSO_MANGLEID_BIT);
-	if (dev->mpls_features & NETIF_F_TSO)
+	if (netdev_mpls_feature_test(dev, NETIF_F_TSO_BIT))
 		netdev_mpls_feature_add(dev, NETIF_F_TSO_MANGLEID_BIT);
-	if (dev->hw_enc_features & NETIF_F_TSO)
+	if (netdev_hw_enc_feature_test(dev, NETIF_F_TSO_BIT))
 		netdev_hw_enc_feature_add(dev, NETIF_F_TSO_MANGLEID_BIT);
 
 	/* Make NETIF_F_HIGHDMA inheritable to VLAN devices.
@@ -10859,7 +10868,7 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 
 	/* Don't allow namespace local devices to be moved. */
 	err = -EINVAL;
-	if (dev->features & NETIF_F_NETNS_LOCAL)
+	if (netdev_active_feature_test(dev, NETIF_F_NETNS_LOCAL_BIT))
 		goto out;
 
 	/* Ensure the device has been registrered */
@@ -11057,7 +11066,7 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 {
 	netdev_features_t tmp;
 
-	if (mask & NETIF_F_HW_CSUM)
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, mask))
 		netdev_features_set(&mask, NETIF_F_CSUM_MASK);
 	netdev_feature_add(NETIF_F_VLAN_CHALLENGED_BIT, &mask);
 
@@ -11072,7 +11081,7 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 	all &= tmp;
 
 	/* If one device supports hw checksumming, set for all. */
-	if (all & NETIF_F_HW_CSUM) {
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, all)) {
 		tmp = NETIF_F_CSUM_MASK;
 		netdev_feature_del(NETIF_F_HW_CSUM_BIT, &tmp);
 		netdev_features_clear(&all, tmp);
@@ -11230,7 +11239,7 @@ static void __net_exit default_device_exit_net(struct net *net)
 		char fb_name[IFNAMSIZ];
 
 		/* Ignore unmoveable devices (i.e. loopback) */
-		if (dev->features & NETIF_F_NETNS_LOCAL)
+		if (netdev_active_feature_test(dev, NETIF_F_NETNS_LOCAL_BIT))
 			continue;
 
 		/* Leave virtual devices for the generic cleanup */
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 3c951a883076..77f57fe00160 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -322,15 +322,15 @@ static u32 __ethtool_get_flags(struct net_device *dev)
 {
 	u32 flags = 0;
 
-	if (dev->features & NETIF_F_LRO)
+	if (netdev_active_feature_test(dev, NETIF_F_LRO_BIT))
 		flags |= ETH_FLAG_LRO;
-	if (dev->features & NETIF_F_HW_VLAN_CTAG_RX)
+	if (netdev_active_feature_test(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT))
 		flags |= ETH_FLAG_RXVLAN;
-	if (dev->features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (netdev_active_feature_test(dev, NETIF_F_HW_VLAN_CTAG_TX_BIT))
 		flags |= ETH_FLAG_TXVLAN;
-	if (dev->features & NETIF_F_NTUPLE)
+	if (netdev_active_feature_test(dev, NETIF_F_NTUPLE_BIT))
 		flags |= ETH_FLAG_NTUPLE;
-	if (dev->features & NETIF_F_RXHASH)
+	if (netdev_active_feature_test(dev, NETIF_F_RXHASH_BIT))
 		flags |= ETH_FLAG_RXHASH;
 
 	return flags;
-- 
2.33.0

