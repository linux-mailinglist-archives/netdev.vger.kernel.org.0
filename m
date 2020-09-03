Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9E425C30A
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 16:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbgICOnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 10:43:10 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:45840 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729266AbgICOgy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 10:36:54 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D8081AB3C08D33EAB48D;
        Thu,  3 Sep 2020 22:36:44 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Thu, 3 Sep 2020 22:36:37 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RFC V2 net-next 1/2] udp: add a GSO type for UDPv6
Date:   Thu, 3 Sep 2020 22:34:18 +0800
Message-ID: <1599143659-62176-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599143659-62176-1-git-send-email-tanhuazhong@huawei.com>
References: <1599143659-62176-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some cases, for UDP GSO, UDPv4 and UDPv6 need to be handled
separately, for example, checksum offload, so add new GSO type
SKB_GSO_UDPV6_L4 for UDPv6, and the old SKB_GSO_UDP_L4 stands
for UDPv4.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/bonding/bond_main.c                         |  4 +++-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c         |  3 ++-
 .../net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c   |  1 +
 .../net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c    |  1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c         |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c                | 17 ++++++++---------
 drivers/net/ethernet/intel/i40e/i40e_main.c             |  1 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c             |  2 +-
 drivers/net/ethernet/intel/ice/ice_main.c               |  3 ++-
 drivers/net/ethernet/intel/ice/ice_txrx.c               |  2 +-
 drivers/net/ethernet/intel/igb/igb_main.c               |  9 ++++++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c           |  9 ++++++---
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.c    |  2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c    |  2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c       |  9 ++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c         |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c       | 11 +++++++----
 drivers/net/team/team.c                                 |  5 +++--
 include/linux/netdev_features.h                         |  4 +++-
 include/linux/netdevice.h                               |  1 +
 include/linux/skbuff.h                                  |  8 ++++++++
 include/linux/udp.h                                     |  4 ++--
 net/core/filter.c                                       |  6 ++----
 net/core/skbuff.c                                       |  2 +-
 net/ethtool/common.c                                    |  1 +
 net/ipv6/udp.c                                          |  2 +-
 net/ipv6/udp_offload.c                                  |  6 +++---
 29 files changed, 76 insertions(+), 47 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index c5d3032..12b1ced 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1292,6 +1292,7 @@ static void bond_compute_features(struct bonding *bond)
 	bond_dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
 				    NETIF_F_HW_VLAN_CTAG_TX |
 				    NETIF_F_HW_VLAN_STAG_TX |
+				    NETIF_F_GSO_UDPV6_L4 |
 				    NETIF_F_GSO_UDP_L4;
 #ifdef CONFIG_XFRM_OFFLOAD
 	bond_dev->hw_enc_features |= xfrm_features;
@@ -4716,7 +4717,8 @@ void bond_setup(struct net_device *bond_dev)
 				NETIF_F_HW_VLAN_CTAG_RX |
 				NETIF_F_HW_VLAN_CTAG_FILTER;
 
-	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
+	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4 |
+				 NETIF_F_GSO_UDPV6_L4;
 #ifdef CONFIG_XFRM_OFFLOAD
 	bond_dev->hw_features |= BOND_XFRM_FEATURES;
 #endif /* CONFIG_XFRM_OFFLOAD */
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index c6bdf1d..d8d288e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -372,7 +372,8 @@ void aq_nic_ndev_init(struct aq_nic_s *self)
 	self->ndev->vlan_features |= NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
 				     NETIF_F_RXHASH | NETIF_F_SG |
 				     NETIF_F_LRO | NETIF_F_TSO | NETIF_F_TSO6;
-	self->ndev->gso_partial_features = NETIF_F_GSO_UDP_L4;
+	self->ndev->gso_partial_features = NETIF_F_GSO_UDP_L4 |
+					   NETIF_F_GSO_UDPV6_L4;
 	self->ndev->priv_flags = aq_hw_caps->hw_priv_flags;
 	self->ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 8941ac4d..41522a3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -48,6 +48,7 @@
 			NETIF_F_HW_VLAN_CTAG_RX |     \
 			NETIF_F_HW_VLAN_CTAG_TX |     \
 			NETIF_F_GSO_UDP_L4      |     \
+			NETIF_F_GSO_UDPV6_L4      |     \
 			NETIF_F_GSO_PARTIAL |         \
 			NETIF_F_HW_TC,                \
 	.hw_priv_flags = IFF_UNICAST_FLT, \
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
index 92f6404..c96d216 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c
@@ -49,6 +49,7 @@ static int hw_atl2_act_rslvr_table_set(struct aq_hw_s *self, u8 location,
 			NETIF_F_HW_VLAN_CTAG_RX |     \
 			NETIF_F_HW_VLAN_CTAG_TX |     \
 			NETIF_F_GSO_UDP_L4      |     \
+			NETIF_F_GSO_UDPV6_L4      |     \
 			NETIF_F_GSO_PARTIAL     |     \
 			NETIF_F_HW_TC,                \
 	.hw_priv_flags = IFF_UNICAST_FLT, \
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index de078a5..45c0cb6 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6213,7 +6213,7 @@ static void free_some_resources(struct adapter *adapter)
 }
 
 #define TSO_FLAGS (NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_TSO_ECN | \
-		   NETIF_F_GSO_UDP_L4)
+		   NETIF_F_GSO_UDP_L4 | NETIF_F_GSO_UDPV6_L4)
 #define VLAN_FEAT (NETIF_F_SG | NETIF_F_IP_CSUM | TSO_FLAGS | \
 		   NETIF_F_GRO | NETIF_F_IPV6_CSUM | NETIF_F_HIGHDMA)
 #define SEGMENT_SIZE 128
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index fddd70e..c96a0af 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -735,7 +735,7 @@ static inline int is_eth_imm(const struct sk_buff *skb, unsigned int chip_ver)
 	    chip_ver > CHELSIO_T5) {
 		hdrlen = sizeof(struct cpl_tx_tnl_lso);
 		hdrlen += sizeof(struct cpl_tx_pkt_core);
-	} else if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
+	} else if (skb_is_gso_udp(skb)) {
 		return 0;
 	} else {
 		hdrlen = skb_shinfo(skb)->gso_size ?
@@ -782,7 +782,7 @@ static inline unsigned int calc_tx_flits(const struct sk_buff *skb,
 		if (skb->encapsulation && chip_ver > CHELSIO_T5) {
 			hdrlen = sizeof(struct fw_eth_tx_pkt_wr) +
 				 sizeof(struct cpl_tx_tnl_lso);
-		} else if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
+		} else if (skb_is_gso_udp(skb)) {
 			u32 pkt_hdrlen;
 
 			pkt_hdrlen = eth_get_headlen(skb->dev, skb->data,
@@ -1498,14 +1498,15 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 	eowr = (void *)&q->q.desc[q->q.pidx];
 	wr->equiq_to_len16 = htonl(wr_mid);
 	wr->r3 = cpu_to_be64(0);
-	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
+	if (skb_is_gso_udp(skb))
 		end = (u64 *)eowr + flits;
 	else
 		end = (u64 *)wr + flits;
 
 	len = immediate ? skb->len : 0;
 	len += sizeof(*cpl);
-	if (ssi->gso_size && !(ssi->gso_type & SKB_GSO_UDP_L4)) {
+	if (ssi->gso_size &&
+	    !(ssi->gso_type & (SKB_GSO_UDP_L4 | SKB_GSO_UDPV6_L4))) {
 		struct cpl_tx_pkt_lso_core *lso = (void *)(wr + 1);
 		struct cpl_tx_tnl_lso *tnl_lso = (void *)(wr + 1);
 
@@ -2061,8 +2062,7 @@ static inline u8 ethofld_calc_tx_flits(struct adapter *adap,
 	u32 wrlen;
 
 	wrlen = sizeof(struct fw_eth_tx_eo_wr) + sizeof(struct cpl_tx_pkt_core);
-	if (skb_shinfo(skb)->gso_size &&
-	    !(skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4))
+	if (skb_shinfo(skb)->gso_size && !skb_is_gso_udp(skb))
 		wrlen += sizeof(struct cpl_tx_pkt_lso_core);
 
 	wrlen += roundup(hdr_len, 16);
@@ -2097,8 +2097,7 @@ static void *write_eo_wr(struct adapter *adap, struct sge_eosw_txq *eosw_txq,
 
 	wrlen16 = DIV_ROUND_UP(wrlen, 16);
 	immd_len = sizeof(struct cpl_tx_pkt_core);
-	if (skb_shinfo(skb)->gso_size &&
-	    !(skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4))
+	if (skb_shinfo(skb)->gso_size && !skb_is_gso_udp(skb))
 		immd_len += sizeof(struct cpl_tx_pkt_lso_core);
 	immd_len += hdr_len;
 
@@ -2259,7 +2258,7 @@ static int ethofld_hard_xmit(struct net_device *dev,
 	}
 
 	if (skb_shinfo(skb)->gso_size) {
-		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
+		if (skb_is_gso_udp(skb))
 			eohw_txq->uso++;
 		else
 			eohw_txq->tso++;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 05c6d3e..7d4488f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13015,6 +13015,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 			  NETIF_F_GSO_UDP_TUNNEL	|
 			  NETIF_F_GSO_UDP_TUNNEL_CSUM	|
 			  NETIF_F_GSO_UDP_L4		|
+			  NETIF_F_GSO_UDPV6_L4		|
 			  NETIF_F_SCTP_CRC		|
 			  NETIF_F_RXHASH		|
 			  NETIF_F_RXCSUM		|
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 91ab824..1c5b621 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2957,7 +2957,7 @@ static int i40e_tso(struct i40e_tx_buffer *first, u8 *hdr_len,
 	/* remove payload length from inner checksum */
 	paylen = skb->len - l4_offset;
 
-	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
+	if (skb_shinfo(skb)->gso_type & skb_is_gso_udp(skb)) {
 		csum_replace_by_diff(&l4.udp->check, (__force __wsum)htonl(paylen));
 		/* compute length of segmentation header */
 		*hdr_len = sizeof(*l4.udp) + l4_offset;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2297ee7..c3c8337 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2919,7 +2919,8 @@ static void ice_set_netdev_features(struct net_device *netdev)
 		       NETIF_F_GSO_PARTIAL		|
 		       NETIF_F_GSO_IPXIP4		|
 		       NETIF_F_GSO_IPXIP6		|
-		       NETIF_F_GSO_UDP_L4;
+		       NETIF_F_GSO_UDP_L4		|
+		       NETIF_F_GSO_UDPV6_L4;
 
 	netdev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM |
 					NETIF_F_GSO_GRE_CSUM;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index eae7526..f8b6471 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2153,7 +2153,7 @@ int ice_tso(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 	/* remove payload length from checksum */
 	paylen = skb->len - l4_start;
 
-	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
+	if (skb_shinfo(skb)->gso_type & skb_is_gso_udp(skb)) {
 		csum_replace_by_diff(&l4.udp->check,
 				     (__force __wsum)htonl(paylen));
 		/* compute length of UDP segmentation header */
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 698bb6a..188532a 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2510,6 +2510,7 @@ igb_features_check(struct sk_buff *skb, struct net_device *dev,
 		return features & ~(NETIF_F_HW_CSUM |
 				    NETIF_F_SCTP_CRC |
 				    NETIF_F_GSO_UDP_L4 |
+				    NETIF_F_GSO_UDPV6_L4 |
 				    NETIF_F_HW_VLAN_CTAG_TX |
 				    NETIF_F_TSO |
 				    NETIF_F_TSO6);
@@ -2519,6 +2520,7 @@ igb_features_check(struct sk_buff *skb, struct net_device *dev,
 		return features & ~(NETIF_F_HW_CSUM |
 				    NETIF_F_SCTP_CRC |
 				    NETIF_F_GSO_UDP_L4 |
+				    NETIF_F_GSO_UDPV6_L4 |
 				    NETIF_F_TSO |
 				    NETIF_F_TSO6);
 
@@ -3115,7 +3117,8 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			    NETIF_F_HW_CSUM;
 
 	if (hw->mac.type >= e1000_82576)
-		netdev->features |= NETIF_F_SCTP_CRC | NETIF_F_GSO_UDP_L4;
+		netdev->features |= NETIF_F_SCTP_CRC | NETIF_F_GSO_UDP_L4 |
+				    NETIF_F_GSO_UDPV6_L4;
 
 	if (hw->mac.type >= e1000_i350)
 		netdev->features |= NETIF_F_HW_TC;
@@ -5728,8 +5731,8 @@ static int igb_tso(struct igb_ring *tx_ring,
 	l4.hdr = skb_checksum_start(skb);
 
 	/* ADV DTYP TUCMD MKRLOC/ISCSIHEDLEN */
-	type_tucmd = (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) ?
-		      E1000_ADVTXD_TUCMD_L4T_UDP : E1000_ADVTXD_TUCMD_L4T_TCP;
+	type_tucmd = skb_is_gso_udp(skb) ?
+		     E1000_ADVTXD_TUCMD_L4T_UDP : E1000_ADVTXD_TUCMD_L4T_TCP;
 
 	/* initialize outer IP header fields */
 	if (ip.v4->version == 4) {
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 0b675c3..f3738592 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -7957,8 +7957,8 @@ static int ixgbe_tso(struct ixgbe_ring *tx_ring,
 	l4.hdr = skb_checksum_start(skb);
 
 	/* ADV DTYP TUCMD MKRLOC/ISCSIHEDLEN */
-	type_tucmd = (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) ?
-		      IXGBE_ADVTXD_TUCMD_L4T_UDP : IXGBE_ADVTXD_TUCMD_L4T_TCP;
+	type_tucmd = skb_is_gso_udp(skb) ?
+		     IXGBE_ADVTXD_TUCMD_L4T_UDP : IXGBE_ADVTXD_TUCMD_L4T_TCP;
 
 	/* initialize outer IP header fields */
 	if (ip.v4->version == 4) {
@@ -10057,6 +10057,7 @@ ixgbe_features_check(struct sk_buff *skb, struct net_device *dev,
 		return features & ~(NETIF_F_HW_CSUM |
 				    NETIF_F_SCTP_CRC |
 				    NETIF_F_GSO_UDP_L4 |
+				    NETIF_F_GSO_UDPV6_L4 |
 				    NETIF_F_HW_VLAN_CTAG_TX |
 				    NETIF_F_TSO |
 				    NETIF_F_TSO6);
@@ -10066,6 +10067,7 @@ ixgbe_features_check(struct sk_buff *skb, struct net_device *dev,
 		return features & ~(NETIF_F_HW_CSUM |
 				    NETIF_F_SCTP_CRC |
 				    NETIF_F_GSO_UDP_L4 |
+				    NETIF_F_GSO_UDPV6_L4 |
 				    NETIF_F_TSO |
 				    NETIF_F_TSO6);
 
@@ -10788,7 +10790,8 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			    IXGBE_GSO_PARTIAL_FEATURES;
 
 	if (hw->mac.type >= ixgbe_mac_82599EB)
-		netdev->features |= NETIF_F_SCTP_CRC | NETIF_F_GSO_UDP_L4;
+		netdev->features |= NETIF_F_SCTP_CRC | NETIF_F_GSO_UDP_L4 |
+				    NETIF_F_GSO_UDPV6_L4;
 
 #ifdef CONFIG_IXGBE_IPSEC
 #define IXGBE_ESP_FEATURES	(NETIF_F_HW_ESP | \
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 820fc66..dea624a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -451,7 +451,7 @@ void otx2_setup_segmentation(struct otx2_nic *pfvf)
 	mutex_unlock(&pfvf->mbox.lock);
 	netdev_info(pfvf->netdev,
 		    "Failed to get LSO index for UDP GSO offload, disabling\n");
-	pfvf->netdev->hw_features &= ~NETIF_F_GSO_UDP_L4;
+	pfvf->netdev->hw_features &= ~(NETIF_F_GSO_UDP_L4 | NETIF_F_GSO_UDPV6_L4);
 }
 
 void otx2_config_irq_coalescing(struct otx2_nic *pfvf, int qidx)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index aac2845..5c29b2c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2095,7 +2095,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	netdev->hw_features = (NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
 			       NETIF_F_IPV6_CSUM | NETIF_F_RXHASH |
 			       NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
-			       NETIF_F_GSO_UDP_L4);
+			       NETIF_F_GSO_UDP_L4 | NETIF_F_GSO_UDPV6_L4);
 	netdev->features |= netdev->hw_features;
 
 	netdev->hw_features |= NETIF_F_LOOPBACK | NETIF_F_RXALL;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 70e0d4c..f3a01fb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -554,7 +554,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	netdev->hw_features = NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
 			      NETIF_F_IPV6_CSUM | NETIF_F_RXHASH |
 			      NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |
-			      NETIF_F_GSO_UDP_L4;
+			      NETIF_F_GSO_UDP_L4 | NETIF_F_GSO_UDPV6_L4;
 	netdev->features = netdev->hw_features;
 
 	netdev->gso_max_segs = OTX2_MAX_GSO_SEGS;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 110476b..e6f098d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -114,7 +114,7 @@ static inline bool mlx5e_accel_tx_begin(struct net_device *dev,
 					struct sk_buff *skb,
 					struct mlx5e_accel_tx_state *state)
 {
-	if (skb_is_gso(skb) && skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
+	if (skb_is_gso(skb) && skb_is_gso_udp(skb))
 		mlx5e_udp_gso_handle_tx_skb(skb);
 
 #ifdef CONFIG_MLX5_EN_TLS
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 2683462..7417f3d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4890,9 +4890,12 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	}
 
 	netdev->hw_features	                 |= NETIF_F_GSO_PARTIAL;
-	netdev->gso_partial_features             |= NETIF_F_GSO_UDP_L4;
-	netdev->hw_features                      |= NETIF_F_GSO_UDP_L4;
-	netdev->features                         |= NETIF_F_GSO_UDP_L4;
+	netdev->gso_partial_features             |= NETIF_F_GSO_UDP_L4 |
+						    NETIF_F_GSO_UDPV6_L4;
+	netdev->hw_features                      |= NETIF_F_GSO_UDP_L4 |
+						    NETIF_F_GSO_UDPV6_L4;
+	netdev->features                         |= NETIF_F_GSO_UDP_L4 |
+						    NETIF_F_GSO_UDPV6_L4;
 
 	mlx5_query_port_fcs(mdev, &fcs_supported, &fcs_enabled);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index da596de..0a17ce9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -172,7 +172,7 @@ mlx5e_tx_get_gso_ihs(struct mlx5e_txqsq *sq, struct sk_buff *skb)
 		stats->tso_inner_packets++;
 		stats->tso_inner_bytes += skb->len - ihs;
 	} else {
-		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
+		if (skb_is_gso_udp(skb))
 			ihs = skb_transport_offset(skb) + sizeof(struct udphdr);
 		else
 			ihs = skb_transport_offset(skb) + tcp_hdrlen(skb);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 89b2b34..3b6c033 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3061,7 +3061,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	first_tx = tx_q->cur_tx;
 
 	/* Compute header lengths */
-	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
+	if (skb_is_gso_udp(skb)) {
 		proto_hdr_len = skb_transport_offset(skb) + sizeof(struct udphdr);
 		hdr = sizeof(struct udphdr);
 	} else {
@@ -3313,7 +3313,8 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (skb_is_gso(skb) && priv->tso) {
 		if (gso & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6))
 			return stmmac_tso_xmit(skb, dev);
-		if (priv->plat->has_gmac4 && (gso & SKB_GSO_UDP_L4))
+		if (priv->plat->has_gmac4 &&
+		    (gso & (SKB_GSO_UDP_L4 | SKB_GSO_UDPV6_L4)))
 			return stmmac_tso_xmit(skb, dev);
 	}
 
@@ -4236,7 +4237,8 @@ static u16 stmmac_select_queue(struct net_device *dev, struct sk_buff *skb,
 {
 	int gso = skb_shinfo(skb)->gso_type;
 
-	if (gso & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6 | SKB_GSO_UDP_L4)) {
+	if (gso & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6 | SKB_GSO_UDP_L4 |
+		   SKB_GSO_UDPV6_L4)) {
 		/*
 		 * There is no way to determine the number of TSO/USO
 		 * capable Queues. Let's use always the Queue 0
@@ -4837,7 +4839,8 @@ int stmmac_dvr_probe(struct device *device,
 	if ((priv->plat->tso_en) && (priv->dma_cap.tsoen)) {
 		ndev->hw_features |= NETIF_F_TSO | NETIF_F_TSO6;
 		if (priv->plat->has_gmac4)
-			ndev->hw_features |= NETIF_F_GSO_UDP_L4;
+			ndev->hw_features |= NETIF_F_GSO_UDP_L4 |
+					     NETIF_F_GSO_UDPV6_L4;
 		priv->tso = true;
 		dev_info(priv->device, "TSO feature enabled\n");
 	}
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 8c1e027..576da5f 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1010,7 +1010,8 @@ static void __team_compute_features(struct team *team)
 	team->dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
 				     NETIF_F_HW_VLAN_CTAG_TX |
 				     NETIF_F_HW_VLAN_STAG_TX |
-				     NETIF_F_GSO_UDP_L4;
+				     NETIF_F_GSO_UDP_L4 |
+				     NETIF_F_GSO_UDPV6_L4;
 	team->dev->hard_header_len = max_hard_header_len;
 
 	team->dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
@@ -2174,7 +2175,7 @@ static void team_setup(struct net_device *dev)
 			   NETIF_F_HW_VLAN_CTAG_RX |
 			   NETIF_F_HW_VLAN_CTAG_FILTER;
 
-	dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
+	dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4 | NETIF_F_GSO_UDPV6_L4;
 	dev->features |= dev->hw_features;
 	dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
 }
diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 2cc3cf8..4806a9f 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -54,8 +54,9 @@ enum {
 	NETIF_F_GSO_UDP_BIT,		/* ... UFO, deprecated except tuntap */
 	NETIF_F_GSO_UDP_L4_BIT,		/* ... UDP payload GSO (not UFO) */
 	NETIF_F_GSO_FRAGLIST_BIT,		/* ... Fraglist GSO */
+	NETIF_F_GSO_UDPV6_L4_BIT,	/* ... UDPv6 payload GSO (not UFO) */
 	/**/NETIF_F_GSO_LAST =		/* last bit, see GSO_MASK */
-		NETIF_F_GSO_FRAGLIST_BIT,
+		NETIF_F_GSO_UDPV6_L4_BIT,
 
 	NETIF_F_FCOE_CRC_BIT,		/* FCoE CRC32 */
 	NETIF_F_SCTP_CRC_BIT,		/* SCTP checksum offload */
@@ -157,6 +158,7 @@ enum {
 #define NETIF_F_GRO_FRAGLIST	__NETIF_F(GRO_FRAGLIST)
 #define NETIF_F_GSO_FRAGLIST	__NETIF_F(GSO_FRAGLIST)
 #define NETIF_F_HW_MACSEC	__NETIF_F(HW_MACSEC)
+#define NETIF_F_GSO_UDPV6_L4	__NETIF_F(GSO_UDPV6_L4)
 
 /* Finds the next feature with the highest number of the range of start till 0.
  */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7f9fcfd..7ad7f6e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4760,6 +4760,7 @@ static inline bool net_gso_ok(netdev_features_t features, int gso_type)
 	BUILD_BUG_ON(SKB_GSO_UDP != (NETIF_F_GSO_UDP >> NETIF_F_GSO_SHIFT));
 	BUILD_BUG_ON(SKB_GSO_UDP_L4 != (NETIF_F_GSO_UDP_L4 >> NETIF_F_GSO_SHIFT));
 	BUILD_BUG_ON(SKB_GSO_FRAGLIST != (NETIF_F_GSO_FRAGLIST >> NETIF_F_GSO_SHIFT));
+	BUILD_BUG_ON(SKB_GSO_UDPV6_L4 != (NETIF_F_GSO_UDPV6_L4 >> NETIF_F_GSO_SHIFT));
 
 	return (features & feature) == feature;
 }
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 46881d9..10b3264 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -596,6 +596,8 @@ enum {
 	SKB_GSO_UDP_L4 = 1 << 17,
 
 	SKB_GSO_FRAGLIST = 1 << 18,
+
+	SKB_GSO_UDPV6_L4 = 1 << 19,
 };
 
 #if BITS_PER_LONG > 32
@@ -4454,6 +4456,12 @@ static inline bool skb_is_gso_tcp(const struct sk_buff *skb)
 	return skb_shinfo(skb)->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6);
 }
 
+/* Note: Should be called only if skb_is_gso(skb) is true */
+static inline bool skb_is_gso_udp(const struct sk_buff *skb)
+{
+	return skb_shinfo(skb)->gso_type & (SKB_GSO_UDP_L4 | SKB_GSO_UDPV6_L4);
+}
+
 static inline void skb_gso_reset(struct sk_buff *skb)
 {
 	skb_shinfo(skb)->gso_size = 0;
diff --git a/include/linux/udp.h b/include/linux/udp.h
index aa84597..b151804 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -123,7 +123,7 @@ static inline void udp_cmsg_recv(struct msghdr *msg, struct sock *sk,
 {
 	int gso_size;
 
-	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
+	if (skb_is_gso_udp(skb)) {
 		gso_size = skb_shinfo(skb)->gso_size;
 		put_cmsg(msg, SOL_UDP, UDP_GRO, sizeof(gso_size), &gso_size);
 	}
@@ -132,7 +132,7 @@ static inline void udp_cmsg_recv(struct msghdr *msg, struct sock *sk,
 static inline bool udp_unexpected_gso(struct sock *sk, struct sk_buff *skb)
 {
 	return !udp_sk(sk)->gro_enabled && skb_is_gso(skb) &&
-	       skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4;
+	       skb_is_gso_udp(skb);
 }
 
 #define udp_portaddr_for_each_entry(__sk, list) \
diff --git a/net/core/filter.c b/net/core/filter.c
index 47eef9a..a68f178 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3083,8 +3083,7 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
 
 	if (skb_is_gso(skb) && !skb_is_gso_tcp(skb)) {
 		/* udp gso_size delineates datagrams, only allow if fixed */
-		if (!(skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) ||
-		    !(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
+		if (!skb_is_gso_udp(skb) || !(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
 			return -ENOTSUPP;
 	}
 
@@ -3181,8 +3180,7 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
 
 	if (skb_is_gso(skb) && !skb_is_gso_tcp(skb)) {
 		/* udp gso_size delineates datagrams, only allow if fixed */
-		if (!(skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) ||
-		    !(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
+		if (!skb_is_gso_udp(skb) || !(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
 			return -ENOTSUPP;
 	}
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index a5c11aa..f233567 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5263,7 +5263,7 @@ static unsigned int skb_gso_transport_seglen(const struct sk_buff *skb)
 		thlen = tcp_hdrlen(skb);
 	} else if (unlikely(skb_is_gso_sctp(skb))) {
 		thlen = sizeof(struct sctphdr);
-	} else if (shinfo->gso_type & SKB_GSO_UDP_L4) {
+	} else if (shinfo->gso_type & (SKB_GSO_UDP_L4 | SKB_GSO_UDPV6_L4)) {
 		thlen = sizeof(struct udphdr);
 	}
 	/* UFO sets gso_size to the size of the fragmentation
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index ed19573..134491b 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -47,6 +47,7 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
 	[NETIF_F_GSO_ESP_BIT] =		 "tx-esp-segmentation",
 	[NETIF_F_GSO_UDP_L4_BIT] =	 "tx-udp-segmentation",
 	[NETIF_F_GSO_FRAGLIST_BIT] =	 "tx-gso-list",
+	[NETIF_F_GSO_UDPV6_L4_BIT] =	 "tx-udpv6-segmentation",
 
 	[NETIF_F_FCOE_CRC_BIT] =         "tx-checksum-fcoe-crc",
 	[NETIF_F_SCTP_CRC_BIT] =        "tx-checksum-sctp",
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 29d9691..df5cc92 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1204,7 +1204,7 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
 
 		if (datalen > cork->gso_size) {
 			skb_shinfo(skb)->gso_size = cork->gso_size;
-			skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
+			skb_shinfo(skb)->gso_type = SKB_GSO_UDPV6_L4;
 			skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(datalen,
 								 cork->gso_size);
 		}
diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index 584157a..a02c9c3 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -39,13 +39,13 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 		const struct ipv6hdr *ipv6h;
 		struct udphdr *uh;
 
-		if (!(skb_shinfo(skb)->gso_type & (SKB_GSO_UDP | SKB_GSO_UDP_L4)))
+		if (!(skb_shinfo(skb)->gso_type & (SKB_GSO_UDP | SKB_GSO_UDPV6_L4)))
 			goto out;
 
 		if (!pskb_may_pull(skb, sizeof(struct udphdr)))
 			goto out;
 
-		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
+		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDPV6_L4)
 			return __udp_gso_segment(skb, features);
 
 		/* Do software UFO. Complete and fill in the UDP checksum as HW cannot
@@ -153,7 +153,7 @@ INDIRECT_CALLABLE_SCOPE int udp6_gro_complete(struct sk_buff *skb, int nhoff)
 	if (NAPI_GRO_CB(skb)->is_flist) {
 		uh->len = htons(skb->len - nhoff);
 
-		skb_shinfo(skb)->gso_type |= (SKB_GSO_FRAGLIST|SKB_GSO_UDP_L4);
+		skb_shinfo(skb)->gso_type |= (SKB_GSO_FRAGLIST | SKB_GSO_UDPV6_L4);
 		skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
 
 		if (skb->ip_summed == CHECKSUM_UNNECESSARY) {
-- 
2.7.4

