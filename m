Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC4A44727F
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 11:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbhKGKWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 05:22:37 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:30925 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbhKGKWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 05:22:37 -0500
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hn9926GpnzcZxV;
        Sun,  7 Nov 2021 18:15:02 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 7 Nov 2021 18:19:50 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sun, 7 Nov 2021 18:19:49 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv4 PATCH net-next] net: extend netdev_features_t
Date:   Sun, 7 Nov 2021 18:15:19 +0800
Message-ID: <20211107101519.29264-1-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the prototype of netdev_features_t is u64, and the number
of netdevice feature bits is 64 now. So there is no space to
introduce new feature bit.

This patchset try to solve it by change the prototype of
netdev_features_t from u64 to structure below:
	typedef struct {
		DECLARE_BITMAP(bits, NETDEV_FEATURE_COUNT);
	} netdev_features_t;

With this change, it's necessary to introduce a set of bitmap
operation helpers for netdev features. As the nic drivers are
not supposed to modify netdev_features directly, it also
introduces wrappers helpers to this.

There are a set of helpes named as "netdev_features_xxx", and I
want to add similar helpers for netdev features members, named as
netdev_XXX_features_xxx.(xxx: and/or/xor.., XXX: hw/vlan/mpls...)
To make the helpers name differentiable, rename netdev->features
to netdev->active_features. For example:
	#define netdev_active_features_set_bit(ndev, nr) \
			netdev_features_set_bit(nr, &ndev->active_features)

To avoid mistake using NETIF_F_XXX as NETIF_F_XXX_BIT as
input macroes for above helpers, remove all the macroes
of NETIF_F_XXX.

The features group macroes in netdev_features.h are replaced
by a set of const features defined in netdev_features.c.
For example:
macro NETIF_F_ALL_TSO is replaced by netdev_all_tso_features

The whole work is not complete yet. I just use these changes
on HNS3 drivers and part of net/core/dev.c, in order to show
how these helpers will be used. I want to get more suggestions
for this scheme, any comments would be appreciated.

The former discussion please see [1][2].

[1]:https://www.spinics.net/lists/netdev/msg769952.html
[2]:https://www.spinics.net/lists/netdev/msg777764.html

ChangeLog:
V3->V4:
rename netdev->features to netdev->active_features
remove helpes for handle first 64 bits
remove __NETIF_F(name) macroes
replace features group macroes with const features
V2->V3:
use structure for bitmap, suggest by Edward Cree
V1->V2:
Extend the prototype from u64 to bitmap, suggest by Andrew Lunn

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 108 +++-
 include/linux/netdev_features.h               | 267 ++++----
 include/linux/netdevice.h                     | 580 +++++++++++++++++-
 net/core/Makefile                             |   3 +-
 net/core/dev.c                                | 364 +++++++----
 net/core/netdev_features.c                    | 209 +++++++
 6 files changed, 1231 insertions(+), 300 deletions(-)
 create mode 100644 net/core/netdev_features.c

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index a2b993d62822..d77c0b884226 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2306,48 +2306,55 @@ static int hns3_nic_do_ioctl(struct net_device *netdev,
 static int hns3_nic_set_features(struct net_device *netdev,
 				 netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(netdev,
+							       features);
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = priv->ae_handle;
 	bool enable;
 	int ret;
 
-	if (changed & (NETIF_F_GRO_HW) && h->ae_algo->ops->set_gro_en) {
-		enable = !!(features & NETIF_F_GRO_HW);
+	if (netdev_features_test_bit(NETIF_F_GRO_HW_BIT, changed) &&
+	    h->ae_algo->ops->set_gro_en) {
+		enable = netdev_features_test_bit(NETIF_F_GRO_HW_BIT, features);
 		ret = h->ae_algo->ops->set_gro_en(h, enable);
 		if (ret)
 			return ret;
 	}
 
-	if ((changed & NETIF_F_HW_VLAN_CTAG_RX) &&
+	if (netdev_features_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed) &&
 	    h->ae_algo->ops->enable_hw_strip_rxvtag) {
-		enable = !!(features & NETIF_F_HW_VLAN_CTAG_RX);
+		enable = netdev_features_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+						  features);
 		ret = h->ae_algo->ops->enable_hw_strip_rxvtag(h, enable);
 		if (ret)
 			return ret;
 	}
 
-	if ((changed & NETIF_F_NTUPLE) && h->ae_algo->ops->enable_fd) {
-		enable = !!(features & NETIF_F_NTUPLE);
+	if (netdev_features_test_bit(NETIF_F_NTUPLE_BIT, changed) &&
+	    h->ae_algo->ops->enable_fd) {
+		enable = netdev_features_test_bit(NETIF_F_NTUPLE_BIT, features);
 		h->ae_algo->ops->enable_fd(h, enable);
 	}
 
-	if ((netdev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
+	if ((netdev_active_features_test_bit(netdev, NETIF_F_HW_TC_BIT) >
+	    netdev_features_test_bit(NETIF_F_NTUPLE_BIT, features)) &&
 	    h->ae_algo->ops->cls_flower_active(h)) {
 		netdev_err(netdev,
 			   "there are offloaded TC filters active, cannot disable HW TC offload");
 		return -EINVAL;
 	}
 
-	if ((changed & NETIF_F_HW_VLAN_CTAG_FILTER) &&
+	if (netdev_features_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				     changed) &&
 	    h->ae_algo->ops->enable_vlan_filter) {
-		enable = !!(features & NETIF_F_HW_VLAN_CTAG_FILTER);
+		enable = netdev_features_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+						  features);
 		ret = h->ae_algo->ops->enable_vlan_filter(h, enable);
 		if (ret)
 			return ret;
 	}
 
-	netdev->features = features;
+	netdev_set_active_features(netdev, features);
 	return 0;
 }
 
@@ -2376,8 +2383,10 @@ static netdev_features_t hns3_features_check(struct sk_buff *skb,
 	/* Hardware only supports checksum on the skb with a max header
 	 * len of 480 bytes.
 	 */
-	if (len > HNS3_MAX_HDR_LEN)
-		features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	if (len > HNS3_MAX_HDR_LEN) {
+		features = netdev_features_andnot(features, NETIF_F_CSUM_MASK);
+		features = netdev_features_andnot(features, NETIF_F_GSO_MASK);
+	}
 
 	return features;
 }
@@ -3122,55 +3131,88 @@ static struct pci_driver hns3_driver = {
 	.err_handler    = &hns3_err_handler,
 };
 
+static const int hns3_default_features_array[] = {
+	NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+	NETIF_F_HW_VLAN_CTAG_RX_BIT,
+	NETIF_F_HW_VLAN_CTAG_TX_BIT,
+	NETIF_F_RXCSUM_BIT,
+	NETIF_F_SG_BIT,
+	NETIF_F_GSO_BIT,
+	NETIF_F_GRO_BIT,
+	NETIF_F_TSO_BIT,
+	NETIF_F_TSO6_BIT,
+	NETIF_F_GSO_GRE_BIT,
+	NETIF_F_GSO_GRE_CSUM_BIT,
+	NETIF_F_GSO_UDP_TUNNEL_BIT,
+	NETIF_F_SCTP_CRC_BIT,
+	NETIF_F_FRAGLIST,
+};
+
+static const int hns3_vlan_disable_features_array[] = {
+	NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+	NETIF_F_HW_VLAN_CTAG_RX_BIT,
+	NETIF_F_HW_VLAN_CTAG_TX_BIT,
+	NETIF_F_GRO_HW_BIT,
+	NETIF_F_NTUPLE_BIT,
+	NETIF_F_HW_TC_BIT,
+};
+
 /* set default feature to hns3 */
 static void hns3_set_default_feature(struct net_device *netdev)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 	struct pci_dev *pdev = h->pdev;
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(pdev);
+	netdev_features_t features, vlan_disable;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
 	netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
 
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
-		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
-		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
-		NETIF_F_SCTP_CRC | NETIF_F_FRAGLIST;
+	netdev_features_zero(&features);
+	netdev_features_set_array(hns3_default_features_array,
+				  ARRAY_SIZE(hns3_default_features_array),
+				  &features);
+
+	netdev_features_zero(&vlan_disable);
+	netdev_features_set_array(hns3_vlan_disable_features_array,
+				  ARRAY_SIZE(hns3_vlan_disable_features_array),
+				  &vlan_disable);
 
 	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
-		netdev->features |= NETIF_F_GRO_HW;
+		netdev_features_set_bit(NETIF_F_GRO_HW_BIT, &features);
 
 		if (!(h->flags & HNAE3_SUPPORT_VF))
-			netdev->features |= NETIF_F_NTUPLE;
+			netdev_features_set_bit(NETIF_F_NTUPLE_BIT, &features);
 	}
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, ae_dev->caps))
-		netdev->features |= NETIF_F_GSO_UDP_L4;
+		netdev_features_set_bit(NETIF_F_GSO_UDP_L4_BIT, &features);
 
 	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps))
-		netdev->features |= NETIF_F_HW_CSUM;
+		netdev_features_set_bit(NETIF_F_HW_CSUM_BIT, &features);
 	else
-		netdev->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		features = netdev_features_or(features, netdev_ip_csum_features);
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps))
-		netdev->features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_features_set_bit(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+					&features);
 
 	if (test_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps))
-		netdev->features |= NETIF_F_HW_TC;
+		netdev_features_set_bit(NETIF_F_HW_TC_BIT, &features);
+
+	netdev_active_features_direct_or(netdev, features);
 
-	netdev->hw_features |= netdev->features;
+	netdev_hw_features_direct_or(netdev, features);
 	if (!test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
-		netdev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_hw_features_clear_bit(netdev,
+					     NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
-	netdev->vlan_features |= netdev->features &
-		~(NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_TX |
-		  NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_GRO_HW | NETIF_F_NTUPLE |
-		  NETIF_F_HW_TC);
+	features = netdev_features_andnot(features, vlan_disable);
+	netdev_vlan_features_direct_or(netdev, features);
 
-	netdev->hw_enc_features |= netdev->vlan_features | NETIF_F_TSO_MANGLEID;
+	netdev_hw_enc_features_direct_or(netdev, features);
+	netdev_hw_enc_features_set_bit(netdev, NETIF_F_TSO_MANGLEID_BIT);
 }
 
 static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 2c6b9e416225..7ff17f236697 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -9,8 +9,6 @@
 #include <linux/bitops.h>
 #include <asm/byteorder.h>
 
-typedef u64 netdev_features_t;
-
 enum {
 	NETIF_F_SG_BIT,			/* Scatter/gather IO. */
 	NETIF_F_IP_CSUM_BIT,		/* Can checksum TCP/UDP over IPv4. */
@@ -101,164 +99,189 @@ enum {
 	/**/NETDEV_FEATURE_COUNT
 };
 
-/* copy'n'paste compression ;) */
-#define __NETIF_F_BIT(bit)	((netdev_features_t)1 << (bit))
-#define __NETIF_F(name)		__NETIF_F_BIT(NETIF_F_##name##_BIT)
-
-#define NETIF_F_FCOE_CRC	__NETIF_F(FCOE_CRC)
-#define NETIF_F_FCOE_MTU	__NETIF_F(FCOE_MTU)
-#define NETIF_F_FRAGLIST	__NETIF_F(FRAGLIST)
-#define NETIF_F_FSO		__NETIF_F(FSO)
-#define NETIF_F_GRO		__NETIF_F(GRO)
-#define NETIF_F_GRO_HW		__NETIF_F(GRO_HW)
-#define NETIF_F_GSO		__NETIF_F(GSO)
-#define NETIF_F_GSO_ROBUST	__NETIF_F(GSO_ROBUST)
-#define NETIF_F_HIGHDMA		__NETIF_F(HIGHDMA)
-#define NETIF_F_HW_CSUM		__NETIF_F(HW_CSUM)
-#define NETIF_F_HW_VLAN_CTAG_FILTER __NETIF_F(HW_VLAN_CTAG_FILTER)
-#define NETIF_F_HW_VLAN_CTAG_RX	__NETIF_F(HW_VLAN_CTAG_RX)
-#define NETIF_F_HW_VLAN_CTAG_TX	__NETIF_F(HW_VLAN_CTAG_TX)
-#define NETIF_F_IP_CSUM		__NETIF_F(IP_CSUM)
-#define NETIF_F_IPV6_CSUM	__NETIF_F(IPV6_CSUM)
-#define NETIF_F_LLTX		__NETIF_F(LLTX)
-#define NETIF_F_LOOPBACK	__NETIF_F(LOOPBACK)
-#define NETIF_F_LRO		__NETIF_F(LRO)
-#define NETIF_F_NETNS_LOCAL	__NETIF_F(NETNS_LOCAL)
-#define NETIF_F_NOCACHE_COPY	__NETIF_F(NOCACHE_COPY)
-#define NETIF_F_NTUPLE		__NETIF_F(NTUPLE)
-#define NETIF_F_RXCSUM		__NETIF_F(RXCSUM)
-#define NETIF_F_RXHASH		__NETIF_F(RXHASH)
-#define NETIF_F_SCTP_CRC	__NETIF_F(SCTP_CRC)
-#define NETIF_F_SG		__NETIF_F(SG)
-#define NETIF_F_TSO6		__NETIF_F(TSO6)
-#define NETIF_F_TSO_ECN		__NETIF_F(TSO_ECN)
-#define NETIF_F_TSO		__NETIF_F(TSO)
-#define NETIF_F_VLAN_CHALLENGED	__NETIF_F(VLAN_CHALLENGED)
-#define NETIF_F_RXFCS		__NETIF_F(RXFCS)
-#define NETIF_F_RXALL		__NETIF_F(RXALL)
-#define NETIF_F_GSO_GRE		__NETIF_F(GSO_GRE)
-#define NETIF_F_GSO_GRE_CSUM	__NETIF_F(GSO_GRE_CSUM)
-#define NETIF_F_GSO_IPXIP4	__NETIF_F(GSO_IPXIP4)
-#define NETIF_F_GSO_IPXIP6	__NETIF_F(GSO_IPXIP6)
-#define NETIF_F_GSO_UDP_TUNNEL	__NETIF_F(GSO_UDP_TUNNEL)
-#define NETIF_F_GSO_UDP_TUNNEL_CSUM __NETIF_F(GSO_UDP_TUNNEL_CSUM)
-#define NETIF_F_TSO_MANGLEID	__NETIF_F(TSO_MANGLEID)
-#define NETIF_F_GSO_PARTIAL	 __NETIF_F(GSO_PARTIAL)
-#define NETIF_F_GSO_TUNNEL_REMCSUM __NETIF_F(GSO_TUNNEL_REMCSUM)
-#define NETIF_F_GSO_SCTP	__NETIF_F(GSO_SCTP)
-#define NETIF_F_GSO_ESP		__NETIF_F(GSO_ESP)
-#define NETIF_F_GSO_UDP		__NETIF_F(GSO_UDP)
-#define NETIF_F_HW_VLAN_STAG_FILTER __NETIF_F(HW_VLAN_STAG_FILTER)
-#define NETIF_F_HW_VLAN_STAG_RX	__NETIF_F(HW_VLAN_STAG_RX)
-#define NETIF_F_HW_VLAN_STAG_TX	__NETIF_F(HW_VLAN_STAG_TX)
-#define NETIF_F_HW_L2FW_DOFFLOAD	__NETIF_F(HW_L2FW_DOFFLOAD)
-#define NETIF_F_HW_TC		__NETIF_F(HW_TC)
-#define NETIF_F_HW_ESP		__NETIF_F(HW_ESP)
-#define NETIF_F_HW_ESP_TX_CSUM	__NETIF_F(HW_ESP_TX_CSUM)
-#define	NETIF_F_RX_UDP_TUNNEL_PORT  __NETIF_F(RX_UDP_TUNNEL_PORT)
-#define NETIF_F_HW_TLS_RECORD	__NETIF_F(HW_TLS_RECORD)
-#define NETIF_F_GSO_UDP_L4	__NETIF_F(GSO_UDP_L4)
-#define NETIF_F_HW_TLS_TX	__NETIF_F(HW_TLS_TX)
-#define NETIF_F_HW_TLS_RX	__NETIF_F(HW_TLS_RX)
-#define NETIF_F_GRO_FRAGLIST	__NETIF_F(GRO_FRAGLIST)
-#define NETIF_F_GSO_FRAGLIST	__NETIF_F(GSO_FRAGLIST)
-#define NETIF_F_HW_MACSEC	__NETIF_F(HW_MACSEC)
-#define NETIF_F_GRO_UDP_FWD	__NETIF_F(GRO_UDP_FWD)
-#define NETIF_F_HW_HSR_TAG_INS	__NETIF_F(HW_HSR_TAG_INS)
-#define NETIF_F_HW_HSR_TAG_RM	__NETIF_F(HW_HSR_TAG_RM)
-#define NETIF_F_HW_HSR_FWD	__NETIF_F(HW_HSR_FWD)
-#define NETIF_F_HW_HSR_DUP	__NETIF_F(HW_HSR_DUP)
-
-/* Finds the next feature with the highest number of the range of start till 0.
- */
-static inline int find_next_netdev_feature(u64 feature, unsigned long start)
-{
-	/* like BITMAP_LAST_WORD_MASK() for u64
-	 * this sets the most significant 64 - start to 0.
-	 */
-	feature &= ~0ULL >> (-start & ((sizeof(feature) * 8) - 1));
-
-	return fls64(feature) - 1;
-}
+typedef struct {
+	DECLARE_BITMAP(bits, NETDEV_FEATURE_COUNT);
+} netdev_features_t;
 
 /* This goes for the MSB to the LSB through the set feature bits,
  * mask_addr should be a u64 and bit an int
  */
 #define for_each_netdev_feature(mask_addr, bit)				\
-	for ((bit) = find_next_netdev_feature((mask_addr),		\
-					      NETDEV_FEATURE_COUNT);	\
-	     (bit) >= 0;						\
-	     (bit) = find_next_netdev_feature((mask_addr), (bit) - 1))
+	for_each_set_bit(bit, (unsigned long *)(mask_addr.bits), NETDEV_FEATURE_COUNT)
+
+extern netdev_features_t netdev_ethtool_features __ro_after_init;
+extern netdev_features_t netdev_never_change_features __ro_after_init;
+extern netdev_features_t netdev_gso_mask_features __ro_after_init;
+extern netdev_features_t netdev_ip_csum_features __ro_after_init;
+extern netdev_features_t netdev_csum_mask_features __ro_after_init;
+extern netdev_features_t netdev_all_tso_features __ro_after_init;
+extern netdev_features_t netdev_tso_ecn_features __ro_after_init;
+extern netdev_features_t netdev_all_fcoe_features __ro_after_init;
+extern netdev_features_t netdev_gso_software_features __ro_after_init;
+extern netdev_features_t netdev_one_for_all_features __ro_after_init;
+extern netdev_features_t netdev_all_for_all_features __ro_after_init;
+extern netdev_features_t netdev_upper_disable_features __ro_after_init;
+extern netdev_features_t netdev_soft_features __ro_after_init;
+extern netdev_features_t netdev_soft_off_features __ro_after_init;
+extern netdev_features_t netdev_vlan_features __ro_after_init;
+extern netdev_features_t netdev_tx_vlan_features __ro_after_init;
+extern netdev_features_t netdev_gso_encap_all_features __ro_after_init;
 
 /* Features valid for ethtool to change */
 /* = all defined minus driver/device-class-related */
-#define NETIF_F_NEVER_CHANGE	(NETIF_F_VLAN_CHALLENGED | \
-				 NETIF_F_LLTX | NETIF_F_NETNS_LOCAL)
+#define NETIF_F_NEVER_CHANGE	netdev_never_change_features
 
-/* remember that ((t)1 << t_BITS) is undefined in C99 */
-#define NETIF_F_ETHTOOL_BITS	((__NETIF_F_BIT(NETDEV_FEATURE_COUNT - 1) | \
-		(__NETIF_F_BIT(NETDEV_FEATURE_COUNT - 1) - 1)) & \
-		~NETIF_F_NEVER_CHANGE)
+#define NETIF_F_ETHTOOL_BITS	netdev_ethtool_features
 
 /* Segmentation offload feature mask */
-#define NETIF_F_GSO_MASK	(__NETIF_F_BIT(NETIF_F_GSO_LAST + 1) - \
-		__NETIF_F_BIT(NETIF_F_GSO_SHIFT))
+#define NETIF_F_GSO_MASK	netdev_gso_mask_features
 
 /* List of IP checksum features. Note that NETIF_F_HW_CSUM should not be
  * set in features when NETIF_F_IP_CSUM or NETIF_F_IPV6_CSUM are set--
  * this would be contradictory
  */
-#define NETIF_F_CSUM_MASK	(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | \
-				 NETIF_F_HW_CSUM)
+#define NETIF_F_CSUM_MASK	netdev_csum_mask_features
 
-#define NETIF_F_ALL_TSO 	(NETIF_F_TSO | NETIF_F_TSO6 | \
-				 NETIF_F_TSO_ECN | NETIF_F_TSO_MANGLEID)
+#define NETIF_F_ALL_TSO		netdev_all_tso_features
 
-#define NETIF_F_ALL_FCOE	(NETIF_F_FCOE_CRC | NETIF_F_FCOE_MTU | \
-				 NETIF_F_FSO)
+#define NETIF_F_ALL_FCOE	netdev_all_fcoe_features
 
 /* List of features with software fallbacks. */
-#define NETIF_F_GSO_SOFTWARE	(NETIF_F_ALL_TSO | NETIF_F_GSO_SCTP |	     \
-				 NETIF_F_GSO_UDP_L4 | NETIF_F_GSO_FRAGLIST)
+#define NETIF_F_GSO_SOFTWARE	netdev_gso_software_features
 
 /*
  * If one device supports one of these features, then enable them
  * for all in netdev_increment_features.
  */
-#define NETIF_F_ONE_FOR_ALL	(NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ROBUST | \
-				 NETIF_F_SG | NETIF_F_HIGHDMA |		\
-				 NETIF_F_FRAGLIST | NETIF_F_VLAN_CHALLENGED)
+#define NETIF_F_ONE_FOR_ALL	netdev_one_for_all_features
 
 /*
  * If one device doesn't support one of these features, then disable it
  * for all in netdev_increment_features.
  */
-#define NETIF_F_ALL_FOR_ALL	(NETIF_F_NOCACHE_COPY | NETIF_F_FSO)
+#define NETIF_F_ALL_FOR_ALL	netdev_all_for_all_features
 
 /*
  * If upper/master device has these features disabled, they must be disabled
  * on all lower/slave devices as well.
  */
-#define NETIF_F_UPPER_DISABLES	NETIF_F_LRO
+#define NETIF_F_UPPER_DISABLES	netdev_upper_disable_features
 
 /* changeable features with no special hardware requirements */
-#define NETIF_F_SOFT_FEATURES	(NETIF_F_GSO | NETIF_F_GRO)
+#define NETIF_F_SOFT_FEATURES	netdev_soft_features
 
 /* Changeable features with no special hardware requirements that defaults to off. */
-#define NETIF_F_SOFT_FEATURES_OFF	(NETIF_F_GRO_FRAGLIST | NETIF_F_GRO_UDP_FWD)
-
-#define NETIF_F_VLAN_FEATURES	(NETIF_F_HW_VLAN_CTAG_FILTER | \
-				 NETIF_F_HW_VLAN_CTAG_RX | \
-				 NETIF_F_HW_VLAN_CTAG_TX | \
-				 NETIF_F_HW_VLAN_STAG_FILTER | \
-				 NETIF_F_HW_VLAN_STAG_RX | \
-				 NETIF_F_HW_VLAN_STAG_TX)
-
-#define NETIF_F_GSO_ENCAP_ALL	(NETIF_F_GSO_GRE |			\
-				 NETIF_F_GSO_GRE_CSUM |			\
-				 NETIF_F_GSO_IPXIP4 |			\
-				 NETIF_F_GSO_IPXIP6 |			\
-				 NETIF_F_GSO_UDP_TUNNEL |		\
-				 NETIF_F_GSO_UDP_TUNNEL_CSUM)
+#define NETIF_F_SOFT_FEATURES_OFF	netdev_soft_off_features
+
+#define NETIF_F_VLAN_FEATURES	netdev_vlan_features
+
+#define NETIF_F_GSO_ENCAP_ALL	netdev_gso_encap_all_features
+
+static inline void netdev_features_zero(netdev_features_t *dst)
+{
+	bitmap_zero(dst->bits, NETDEV_FEATURE_COUNT);
+}
+
+static inline void netdev_features_fill(netdev_features_t *dst)
+{
+	bitmap_fill(dst->bits, NETDEV_FEATURE_COUNT);
+}
+
+static inline bool netdev_features_empty(netdev_features_t src)
+{
+	return bitmap_empty(src.bits, NETDEV_FEATURE_COUNT);
+}
+
+static inline bool netdev_features_equal(netdev_features_t src1,
+					 netdev_features_t src2)
+{
+	return bitmap_equal(src1.bits, src2.bits, NETDEV_FEATURE_COUNT);
+}
+
+static inline netdev_features_t
+netdev_features_and(netdev_features_t a, netdev_features_t b)
+{
+	netdev_features_t dst;
+
+	bitmap_and(dst.bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
+	return dst;
+}
+
+static inline netdev_features_t
+netdev_features_or(netdev_features_t a, netdev_features_t b)
+{
+	netdev_features_t dst;
+
+	bitmap_or(dst.bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
+	return dst;
+}
+
+static inline netdev_features_t
+netdev_features_xor(netdev_features_t a, netdev_features_t b)
+{
+	netdev_features_t dst;
+
+	bitmap_xor(dst.bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
+	return dst;
+}
+
+static inline netdev_features_t
+netdev_features_andnot(netdev_features_t a, netdev_features_t b)
+{
+	netdev_features_t dst;
+
+	bitmap_andnot(dst.bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
+	return dst;
+}
+
+static inline void netdev_features_set_bit(int nr, netdev_features_t *src)
+{
+	__set_bit(nr, src->bits);
+}
+
+static inline void netdev_features_clear_bit(int nr, netdev_features_t *src)
+{
+	__clear_bit(nr, src->bits);
+}
+
+static inline void netdev_features_mod_bit(int nr, netdev_features_t *src,
+					   int set)
+{
+	if (set)
+		netdev_features_set_bit(nr, src);
+	else
+		netdev_features_clear_bit(nr, src);
+}
+
+static inline void netdev_features_change_bit(int nr, netdev_features_t *src)
+{
+	__change_bit(nr, src->bits);
+}
+
+static inline bool netdev_features_test_bit(int nr, netdev_features_t src)
+{
+	return test_bit(nr, src.bits);
+}
+
+static inline void netdev_features_set_array(const int *array, int array_size,
+					     netdev_features_t *src)
+{
+	int i;
+
+	for (i = 0; i < array_size; i++)
+		netdev_features_set_bit(array[i], src);
+}
+
+static inline bool netdev_features_intersects(netdev_features_t src1,
+					      netdev_features_t src2)
+{
+	return bitmap_intersects(src1.bits, src2.bits, NETDEV_FEATURE_COUNT);
+}
+
+static inline bool netdev_features_subset(netdev_features_t src1,
+					  netdev_features_t src2)
+{
+	return bitmap_subset(src1.bits, src2.bits, NETDEV_FEATURE_COUNT);
+}
 
 #endif	/* _LINUX_NETDEV_FEATURES_H */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3ec42495a43a..0cd39c093eef 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1715,7 +1715,7 @@ enum netdev_ml_priv_type {
  *	@ptype_specific: Device-specific, protocol-specific packet handlers
  *
  *	@adj_list:	Directly linked devices, like slaves for bonding
- *	@features:	Currently active device features
+ *	@active_features:	Currently active device features
  *	@hw_features:	User-changeable features
  *
  *	@wanted_features:	User-requested features
@@ -1995,7 +1995,7 @@ struct net_device {
 	unsigned short		needed_headroom;
 	unsigned short		needed_tailroom;
 
-	netdev_features_t	features;
+	netdev_features_t	active_features;
 	netdev_features_t	hw_features;
 	netdev_features_t	wanted_features;
 	netdev_features_t	vlan_features;
@@ -2271,9 +2271,545 @@ struct net_device {
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
+#define netdev_active_features_zero(ndev) \
+		netdev_features_zero(&ndev->active_features)
+
+#define netdev_active_features_equal(ndev, features) \
+		netdev_features_equal(ndev->active_features, features)
+
+#define netdev_active_features_and(ndev, features) \
+		netdev_features_and(ndev->active_features, features)
+
+#define netdev_active_features_or(ndev, features) \
+		netdev_features_or(ndev->active_features, features)
+
+#define netdev_active_features_xor(ndev, features) \
+		netdev_features_xor(ndev->active_features, features)
+
+#define netdev_active_features_andnot(ndev, features) \
+		netdev_features_andnot(ndev->active_features, features)
+
+#define netdev_active_features_andnot_r(ndev, features) \
+		netdev_features_andnot(features, ndev->active_features)
+
+#define netdev_active_features_set_bit(ndev, nr) \
+		netdev_features_set_bit(nr, &ndev->active_features)
+
+#define netdev_active_features_set_array(ndev, array, array_size) \
+		netdev_features_set_array(array, array_size, &ndev->active_features)
+
+#define netdev_active_features_clear_bit(ndev, nr) \
+		netdev_features_clear_bit(nr, &ndev->active_features)
+
+#define netdev_active_features_test_bit(ndev, nr) \
+		netdev_features_test_bit(nr, ndev->active_features)
+
+#define netdev_active_features_intersects(ndev, features) \
+		netdev_features_intersects(ndev->active_features, features)
+
+static inline void netdev_set_active_features(struct net_device *netdev,
+					      netdev_features_t src)
+{
+	netdev->active_features = src;
+}
+
+static inline netdev_features_t netdev_get_active_features(struct net_device *ndev)
+{
+	return ndev->active_features;
+}
+
+static inline void
+netdev_active_features_direct_and(struct net_device *ndev,
+				  netdev_features_t features)
+{
+	ndev->active_features = netdev_active_features_and(ndev, features);
+}
+
+static inline void
+netdev_active_features_direct_or(struct net_device *ndev,
+				 netdev_features_t features)
+{
+	ndev->active_features = netdev_active_features_or(ndev, features);
+}
+
+static inline void
+netdev_active_features_direct_xor(struct net_device *ndev,
+				  netdev_features_t features)
+{
+	ndev->active_features = netdev_active_features_xor(ndev, features);
+}
+
+static inline void
+netdev_active_features_direct_andnot(struct net_device *ndev,
+				     netdev_features_t features)
+{
+	ndev->active_features = netdev_active_features_andnot(ndev, features);
+}
+
+#define netdev_hw_features_zero(ndev) \
+		netdev_features_zero(&ndev->hw_features)
+
+#define netdev_hw_features_equal(ndev, features) \
+		netdev_features_equal(ndev->hw_features, features)
+
+#define netdev_hw_features_copy(features) \
+		netdev_features_copy(&ndev->hw_features)
+
+#define netdev_hw_features_and(ndev, features) \
+		netdev_features_and(ndev->hw_features, features)
+
+#define netdev_hw_features_or(ndev, features) \
+		netdev_features_or(ndev->hw_features, features)
+
+#define netdev_hw_features_xor(ndev, features) \
+		netdev_features_xor(ndev->hw_features, features)
+
+#define netdev_hw_features_andnot(ndev, features) \
+		netdev_features_andnot(ndev->hw_features, features)
+
+#define netdev_hw_features_andnot_r(ndev, features) \
+		netdev_features_andnot(features, ndev->hw_features)
+
+#define netdev_hw_features_set_bit(ndev, nr) \
+		netdev_features_set_bit(nr, &ndev->hw_features)
+
+#define netdev_hw_features_set_array(ndev, array, array_size) \
+		netdev_features_set_array(array, array_size, &ndev->hw_features)
+
+#define netdev_hw_features_clear_bit(ndev, nr) \
+		netdev_features_clear_bit(nr, &ndev->hw_features)
+
+#define netdev_hw_features_test_bit(ndev, nr) \
+		netdev_features_test_bit(nr, &ndev->hw_features)
+
+#define netdev_hw_features_intersects(ndev, features) \
+		netdev_features_intersects(ndev->hw_features, features)
+
+static inline void netdev_set_hw_features(struct net_device *ndev,
+					  netdev_features_t src)
+{
+	ndev->hw_features = src;
+}
+
+static inline netdev_features_t netdev_get_hw_features(struct net_device *ndev)
+{
+	return ndev->hw_features;
+}
+
+static inline void
+netdev_hw_features_direct_and(struct net_device *ndev,
+			      netdev_features_t features)
+{
+	ndev->hw_features = netdev_hw_features_and(ndev, features);
+}
+
+static inline void
+netdev_hw_features_direct_or(struct net_device *ndev,
+			     netdev_features_t features)
+{
+	ndev->hw_features = netdev_hw_features_or(ndev, features);
+}
+
+static inline void
+netdev_hw_features_direct_xor(struct net_device *ndev,
+			      netdev_features_t features)
+{
+	ndev->hw_features = netdev_hw_features_xor(ndev, features);
+}
+
+static inline void
+netdev_hw_features_direct_andnot(struct net_device *ndev,
+				 netdev_features_t features)
+{
+	ndev->hw_features = netdev_hw_features_andnot(ndev, features);
+}
+
+#define netdev_wanted_features_zero(ndev) \
+		netdev_features_zero(&ndev->wanted_features)
+
+#define netdev_wanted_features_equal(ndev, features) \
+		netdev_features_equal(ndev->wanted_features, features)
+
+#define netdev_wanted_features_and(ndev, features) \
+		netdev_features_and(ndev->wanted_features, features)
+
+#define netdev_wanted_features_or(ndev, features) \
+		netdev_features_or(ndev->wanted_features, features)
+
+#define netdev_wanted_features_xor(ndev, features) \
+		netdev_features_xor(ndev->wanted_features, features)
+
+#define netdev_wanted_features_andnot(ndev, features) \
+		netdev_features_andnot(ndev->wanted_features, features)
+
+#define netdev_wanted_features_andnot_r(ndev, features) \
+		netdev_features_andnot(features, ndev->wanted_features)
+
+#define netdev_wanted_features_set_bit(ndev, nr) \
+		netdev_features_set_bit(nr, &ndev->wanted_features)
+
+#define netdev_wanted_features_set_array(ndev, array, array_size) \
+		netdev_features_set_array(array, array_size, &ndev->wanted_features)
+
+#define netdev_wanted_features_clear_bit(ndev, nr) \
+		netdev_features_clear_bit(nr, &ndev->wanted_features)
+
+#define netdev_wanted_features_test_bit(ndev, nr) \
+		netdev_features_test_bit(nr, &ndev->wanted_features)
+
+#define netdev_wanted_features_intersects(ndev, features) \
+		netdev_features_intersects(ndev->wanted_features, features)
+
+static inline void netdev_set_wanted_features(struct net_device *ndev,
+					      netdev_features_t src)
+{
+	ndev->wanted_features = src;
+}
+
+static inline netdev_features_t
+netdev_get_wanted_features(struct net_device *ndev)
+{
+	return ndev->wanted_features;
+}
+
+static inline void
+netdev_wanted_features_direct_and(struct net_device *ndev,
+				  netdev_features_t features)
+{
+	ndev->wanted_features = netdev_wanted_features_and(ndev, features);
+}
+
+static inline void
+netdev_wanted_features_direct_or(struct net_device *ndev,
+				 netdev_features_t features)
+{
+	ndev->wanted_features = netdev_wanted_features_or(ndev, features);
+}
+
+static inline void
+netdev_wanted_features_direct_xor(struct net_device *ndev,
+				  netdev_features_t features)
+{
+	ndev->wanted_features = netdev_wanted_features_xor(ndev, features);
+}
+
+static inline void
+netdev_wanted_features_direct_andnot(struct net_device *ndev,
+				     netdev_features_t features)
+{
+	ndev->wanted_features = netdev_wanted_features_andnot(ndev, features);
+}
+
+#define netdev_vlan_features_zero(ndev) \
+		netdev_features_zero(&ndev->vlan_features)
+
+#define netdev_vlan_features_equal(ndev, features) \
+		netdev_features_equal(ndev->vlan_features, features)
+
+#define netdev_vlan_features_and(ndev, features) \
+		netdev_features_and(ndev->vlan_features, features)
+
+#define netdev_vlan_features_or(ndev, features) \
+		netdev_features_or(ndev->vlan_features, features)
+
+#define netdev_vlan_features_xor(ndev, features) \
+		netdev_features_xor(ndev->vlan_features, features)
+
+#define netdev_vlan_features_andnot(ndev, features) \
+		netdev_features_andnot(ndev->vlan_features, features)
+
+#define netdev_vlan_features_andnot_r(ndev, features) \
+		netdev_features_andnot(features, ndev->vlan_features)
+
+#define netdev_vlan_features_set_bit(ndev, nr) \
+		netdev_features_set_bit(nr, &ndev->vlan_features)
+
+#define netdev_vlan_features_set_array(ndev, array, array_size) \
+		netdev_features_set_array(array, array_size, &ndev->vlan_features)
+
+#define netdev_vlan_features_clear_bit(ndev, nr) \
+		netdev_features_clear_bit(nr, &ndev->vlan_features)
+
+#define netdev_vlan_features_test_bit(ndev, nr) \
+		netdev_features_test_bit(nr, &ndev->vlan_features)
+
+#define netdev_vlan_features_intersects(ndev, features) \
+		netdev_features_intersects(ndev->vlan_features, features)
+
+static inline void netdev_set_vlan_features(struct net_device *ndev,
+					    netdev_features_t src)
+{
+	ndev->vlan_features = src;
+}
+
+static inline netdev_features_t
+netdev_get_vlan_features(struct net_device *ndev)
+{
+	return ndev->vlan_features;
+}
+
+static inline void
+netdev_vlan_features_direct_and(struct net_device *ndev,
+				netdev_features_t features)
+{
+	ndev->vlan_features = netdev_vlan_features_and(ndev, features);
+}
+
+static inline void
+netdev_vlan_features_direct_or(struct net_device *ndev,
+			       netdev_features_t features)
+{
+	ndev->vlan_features = netdev_vlan_features_or(ndev, features);
+}
+
+static inline void
+netdev_vlan_features_direct_xor(struct net_device *ndev,
+				netdev_features_t features)
+{
+	ndev->vlan_features = netdev_vlan_features_xor(ndev, features);
+}
+
+static inline void
+netdev_vlan_features_direct_andnot(struct net_device *ndev,
+				   netdev_features_t features)
+{
+	ndev->vlan_features = netdev_vlan_features_andnot(ndev, features);
+}
+
+#define netdev_hw_enc_features_zero(ndev) \
+		netdev_features_zero(&ndev->hw_enc_features)
+
+#define netdev_hw_enc_features_equal(ndev, features) \
+		netdev_features_equal(ndev->hw_enc_features, features)
+
+#define netdev_hw_enc_features_and(ndev, features) \
+		netdev_features_and(ndev->hw_enc_features, features)
+
+#define netdev_hw_enc_features_or(ndev, features) \
+		netdev_features_or(ndev->hw_enc_features, features)
+
+#define netdev_hw_enc_features_xor(ndev, features) \
+		netdev_features_xor(ndev->hw_enc_features, features)
+
+#define netdev_hw_enc_features_andnot(ndev, features) \
+		netdev_features_andnot(ndev->hw_enc_features, features)
+
+#define netdev_hw_enc_features_andnot_r(ndev, features) \
+		netdev_features_andnot(features, ndev->hw_enc_features)
+
+#define netdev_hw_enc_features_set_bit(ndev, nr) \
+		netdev_features_set_bit(nr, &ndev->hw_enc_features)
+
+#define netdev_hw_enc_features_set_array(ndev, array, array_size) \
+		netdev_features_set_array(array, array_size, &ndev->hw_enc_features)
+
+#define netdev_hw_enc_features_clear_bit(ndev, nr) \
+		netdev_features_clear_bit(nr, &ndev->hw_enc_features)
+
+#define netdev_hw_enc_features_test_bit(ndev, nr) \
+		netdev_features_test_bit(nr, &ndev->hw_enc_features)
+
+#define netdev_hw_enc_features_intersects(ndev, features) \
+		netdev_features_intersects(ndev->hw_enc_features, features)
+
+static inline void netdev_set_hw_enc_features(struct net_device *ndev,
+					      netdev_features_t src)
+{
+	ndev->hw_enc_features = src;
+}
+
+static inline netdev_features_t
+netdev_get_hw_enc_features(struct net_device *ndev)
+{
+	return ndev->hw_enc_features;
+}
+
+static inline void
+netdev_hw_enc_features_direct_and(struct net_device *ndev,
+				  netdev_features_t features)
+{
+	ndev->hw_enc_features = netdev_hw_enc_features_and(ndev, features);
+}
+
+static inline void
+netdev_hw_enc_features_direct_or(struct net_device *ndev,
+				 netdev_features_t features)
+{
+	ndev->hw_enc_features = netdev_hw_enc_features_or(ndev, features);
+}
+
+static inline void
+netdev_hw_enc_features_direct_xor(struct net_device *ndev,
+				  netdev_features_t features)
+{
+	ndev->hw_enc_features = netdev_hw_enc_features_xor(ndev, features);
+}
+
+static inline void
+netdev_hw_enc_features_direct_andnot(struct net_device *ndev,
+				     netdev_features_t features)
+{
+	ndev->hw_enc_features = netdev_hw_enc_features_andnot(ndev, features);
+}
+
+#define netdev_mpls_features_zero(ndev) \
+		netdev_features_zero(&ndev->mpls_features)
+
+#define netdev_mpls_features_equal(ndev, features) \
+		netdev_features_equal(ndev->mpls_features, features)
+
+#define netdev_mpls_features_and(ndev, features) \
+		netdev_features_and(ndev->mpls_features, features)
+
+#define netdev_mpls_features_or(ndev, features) \
+		netdev_features_or(ndev->mpls_features, features)
+
+#define netdev_mpls_features_xor(ndev, features) \
+		netdev_features_xor(ndev->mpls_features, features)
+
+#define netdev_mpls_features_andnot(ndev, features) \
+		netdev_features_andnot(ndev->mpls_features, features)
+
+#define netdev_mpls_features_andnot_r(ndev, features) \
+		netdev_features_andnot(features, ndev->mpls_features)
+
+#define netdev_mpls_features_set_bit(ndev, nr) \
+		netdev_features_set_bit(nr, &ndev->mpls_features)
+
+#define netdev_mpls_features_set_array(ndev, array, array_size) \
+		netdev_features_set_array(array, array_size, &ndev->mpls_features)
+
+#define netdev_mpls_features_clear_bit(ndev, nr) \
+		netdev_features_clear_bit(nr, &ndev->mpls_features)
+
+#define netdev_mpls_features_test_bit(ndev, nr) \
+		netdev_features_test_bit(nr, &ndev->mpls_features)
+
+#define netdev_mpls_features_intersects(ndev, features) \
+		netdev_features_intersects(ndev->mpls_features, features)
+
+static inline void netdev_set_mpls_features(struct net_device *ndev,
+					    netdev_features_t src)
+{
+	ndev->mpls_features = src;
+}
+
+static inline netdev_features_t
+netdev_get_mpls_features(struct net_device *ndev)
+{
+	return ndev->mpls_features;
+}
+
+static inline void
+netdev_mpls_features_direct_and(struct net_device *ndev,
+				netdev_features_t features)
+{
+	ndev->mpls_features = netdev_mpls_features_and(ndev, features);
+}
+
+static inline void
+netdev_mpls_features_direct_or(struct net_device *ndev,
+			       netdev_features_t features)
+{
+	ndev->mpls_features = netdev_mpls_features_or(ndev, features);
+}
+
+static inline void
+netdev_mpls_features_direct_xor(struct net_device *ndev,
+				netdev_features_t features)
+{
+	ndev->mpls_features = netdev_mpls_features_xor(ndev, features);
+}
+
+static inline void
+netdev_mpls_features_direct_andnot(struct net_device *ndev,
+				   netdev_features_t features)
+{
+	ndev->mpls_features = netdev_mpls_features_andnot(ndev, features);
+}
+
+#define netdev_gso_partial_features_zero(ndev) \
+		netdev_features_zero(&ndev->gso_partial_features)
+
+#define netdev_gso_partial_features_equal(ndev, features) \
+		netdev_features_equal(ndev->gso_partial_features, features)
+
+#define netdev_gso_partial_features_and(ndev, features) \
+		netdev_features_and(ndev->gso_partial_features, features)
+
+#define netdev_gso_partial_features_or(ndev, features) \
+		netdev_features_or(ndev->gso_partial_features, features)
+
+#define netdev_gso_partial_features_xor(ndev, features) \
+		netdev_features_xor(ndev->gso_partial_features, features)
+
+#define netdev_gso_partial_features_andnot(ndev, features) \
+		netdev_features_andnot(ndev->gso_partial_features, features)
+
+#define netdev_gso_partial_features_andnot_r(ndev, features) \
+		netdev_features_andnot(features, ndev->gso_partial_features)
+
+#define netdev_gso_partial_features_set_bit(ndev, nr) \
+		netdev_features_set_bit(nr, &ndev->gso_partial_features)
+
+#define netdev_gso_partial_features_set_array(ndev, array, array_size) \
+		netdev_features_set_array(array, array_size, &ndev->gso_partial_features)
+
+#define netdev_gso_partial_features_clear_bit(ndev, nr) \
+		netdev_features_clear_bit(nr, &ndev->gso_partial_features)
+
+#define netdev_gso_partial_features_test_bit(ndev, nr) \
+		netdev_features_test_bit(nr, &ndev->gso_partial_features)
+
+#define netdev_gso_partial_features_intersects(ndev, features) \
+		netdev_features_intersects(ndev->gso_partial_features, features)
+
+static inline void netdev_set_gso_partial_features(struct net_device *ndev,
+					    netdev_features_t src)
+{
+	ndev->gso_partial_features = src;
+}
+
+static inline netdev_features_t
+netdev_get_gso_partial_features(struct net_device *ndev)
+{
+	return ndev->gso_partial_features;
+}
+
+static inline void
+netdev_gso_partial_features_direct_and(struct net_device *ndev,
+				       netdev_features_t features)
+{
+	ndev->gso_partial_features = netdev_mpls_features_and(ndev, features);
+}
+
+static inline void
+netdev_gso_partial_features_direct_or(struct net_device *ndev,
+				      netdev_features_t features)
+{
+	ndev->gso_partial_features = netdev_mpls_features_or(ndev, features);
+}
+
+static inline void
+netdev_gso_partial_features_direct_xor(struct net_device *ndev,
+				       netdev_features_t features)
+{
+	ndev->gso_partial_features =
+			netdev_gso_partial_features_xor(ndev, features);
+}
+
+static inline void
+netdev_gso_partial_features_direct_andnot(struct net_device *ndev,
+					  netdev_features_t features)
+{
+	ndev->gso_partial_features =
+			netdev_gso_partial_features_andnot(ndev, features);
+}
+
 static inline bool netif_elide_gro(const struct net_device *dev)
 {
-	if (!(dev->features & NETIF_F_GRO) || dev->xdp_prog)
+	if (!netdev_active_features_test_bit(dev, NETIF_F_GRO_BIT) ||
+	    dev->xdp_prog)
 		return true;
 	return false;
 }
@@ -4517,7 +5053,7 @@ static inline void netif_tx_unlock_bh(struct net_device *dev)
 }
 
 #define HARD_TX_LOCK(dev, txq, cpu) {			\
-	if ((dev->features & NETIF_F_LLTX) == 0) {	\
+	if (!netdev_active_features_test_bit(dev, NETIF_F_LLTX_BIT)) {	\
 		__netif_tx_lock(txq, cpu);		\
 	} else {					\
 		__netif_tx_acquire(txq);		\
@@ -4525,12 +5061,12 @@ static inline void netif_tx_unlock_bh(struct net_device *dev)
 }
 
 #define HARD_TX_TRYLOCK(dev, txq)			\
-	(((dev->features & NETIF_F_LLTX) == 0) ?	\
+	((!netdev_active_features_test_bit(dev, NETIF_F_LLTX_BIT)) ?	\
 		__netif_tx_trylock(txq) :		\
 		__netif_tx_acquire(txq))
 
 #define HARD_TX_UNLOCK(dev, txq) {			\
-	if ((dev->features & NETIF_F_LLTX) == 0) {	\
+	if ((!netdev_active_features_test_bit(dev, NETIF_F_LLTX_BIT)) {	\
 		__netif_tx_unlock(txq);			\
 	} else {					\
 		__netif_tx_release(txq);		\
@@ -4942,20 +5478,20 @@ static inline bool can_checksum_protocol(netdev_features_t features,
 					 __be16 protocol)
 {
 	if (protocol == htons(ETH_P_FCOE))
-		return !!(features & NETIF_F_FCOE_CRC);
+		return netdev_features_test_bit(NETIF_F_FCOE_CRC_BIT, features);
 
 	/* Assume this is an IP checksum (not SCTP CRC) */
 
-	if (features & NETIF_F_HW_CSUM) {
+	if (netdev_features_test_bit(NETIF_F_HW_CSUM_BIT, features)) {
 		/* Can checksum everything */
 		return true;
 	}
 
 	switch (protocol) {
 	case htons(ETH_P_IP):
-		return !!(features & NETIF_F_IP_CSUM);
+		return netdev_features_test_bit(NETIF_F_IP_CSUM_BIT, features);
 	case htons(ETH_P_IPV6):
-		return !!(features & NETIF_F_IPV6_CSUM);
+		return netdev_features_test_bit(NETIF_F_IPV6_CSUM_BIT, features);
 	default:
 		return false;
 	}
@@ -5019,20 +5555,25 @@ void linkwatch_run_queue(void);
 static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 							  netdev_features_t f2)
 {
-	if ((f1 ^ f2) & NETIF_F_HW_CSUM) {
-		if (f1 & NETIF_F_HW_CSUM)
-			f1 |= (NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM);
+	if (netdev_features_test_bit(NETIF_F_HW_CSUM_BIT, f1) !=
+	    netdev_features_test_bit(NETIF_F_HW_CSUM_BIT, f2)) {
+		if (netdev_features_test_bit(NETIF_F_HW_CSUM_BIT, f1))
+			f1 = netdev_features_or(f1, netdev_ip_csum_features);
 		else
-			f2 |= (NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM);
+			f2 = netdev_features_or(f2, netdev_ip_csum_features);
 	}
 
-	return f1 & f2;
+	return netdev_features_and(f1, f2);
 }
 
-static inline netdev_features_t netdev_get_wanted_features(
-	struct net_device *dev)
+static inline netdev_features_t
+netdev_get_full_wanted_features(struct net_device *dev)
 {
-	return (dev->features & ~dev->hw_features) | dev->wanted_features;
+	netdev_features_t features = netdev_get_active_features(dev);
+
+	features = netdev_hw_features_andnot_r(dev, features);
+
+	return netdev_wanted_features_or(dev, features);
 }
 netdev_features_t netdev_increment_features(netdev_features_t all,
 	netdev_features_t one, netdev_features_t mask);
@@ -5090,7 +5631,8 @@ static inline bool net_gso_ok(netdev_features_t features, int gso_type)
 static inline bool skb_gso_ok(struct sk_buff *skb, netdev_features_t features)
 {
 	return net_gso_ok(features, skb_shinfo(skb)->gso_type) &&
-	       (!skb_has_frag_list(skb) || (features & NETIF_F_FRAGLIST));
+	       (!skb_has_frag_list(skb) ||
+	       (netdev_features_test_bit(NETIF_F_FRAGLIST_BIT, features)));
 }
 
 static inline bool netif_needs_gso(struct sk_buff *skb,
diff --git a/net/core/Makefile b/net/core/Makefile
index 4268846f2f47..10d869ac3735 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -4,7 +4,8 @@
 #
 
 obj-y := sock.o request_sock.o skbuff.o datagram.o stream.o scm.o \
-	 gen_stats.o gen_estimator.o net_namespace.o secure_seq.o flow_dissector.o
+	 gen_stats.o gen_estimator.o net_namespace.o secure_seq.o flow_dissector.o \
+	 netdev_features.o
 
 obj-$(CONFIG_SYSCTL) += sysctl_net_core.o
 
diff --git a/net/core/dev.c b/net/core/dev.c
index edeb811c454e..c5badde8051c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1642,10 +1642,10 @@ void dev_disable_lro(struct net_device *dev)
 	struct net_device *lower_dev;
 	struct list_head *iter;
 
-	dev->wanted_features &= ~NETIF_F_LRO;
+	netdev_wanted_features_clear_bit(dev, NETIF_F_LRO_BIT);
 	netdev_update_features(dev);
 
-	if (unlikely(dev->features & NETIF_F_LRO))
+	if (unlikely(netdev_active_features_test_bit(dev, NETIF_F_LRO_BIT)))
 		netdev_WARN(dev, "failed to disable LRO!\n");
 
 	netdev_for_each_lower_dev(dev, lower_dev, iter)
@@ -1663,10 +1663,10 @@ EXPORT_SYMBOL(dev_disable_lro);
  */
 static void dev_disable_gro_hw(struct net_device *dev)
 {
-	dev->wanted_features &= ~NETIF_F_GRO_HW;
+	netdev_wanted_features_clear_bit(dev, NETIF_F_GRO_HW_BIT);
 	netdev_update_features(dev);
 
-	if (unlikely(dev->features & NETIF_F_GRO_HW))
+	if (unlikely(netdev_active_features_test_bit(dev, NETIF_F_GRO_HW_BIT)))
 		netdev_WARN(dev, "failed to disable GRO_HW!\n");
 }
 
@@ -3391,13 +3391,14 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 	 * support segmentation on this frame without needing additional
 	 * work.
 	 */
-	if (features & NETIF_F_GSO_PARTIAL) {
-		netdev_features_t partial_features = NETIF_F_GSO_ROBUST;
+	if (netdev_features_test_bit(NETIF_F_GSO_PARTIAL_BIT, features)) {
+		netdev_features_t partial_features = netdev_get_active_features(dev);
 		struct net_device *dev = skb->dev;
 
-		partial_features |= dev->features & dev->gso_partial_features;
-		if (!skb_gso_ok(skb, features | partial_features))
-			features &= ~NETIF_F_GSO_PARTIAL;
+		partial_features = netdev_gso_partial_features_and(dev, partial_features);
+		netdev_features_set_bit(NETIF_F_GSO_PARTIAL_BIT, &partial_features);
+		if (!skb_gso_ok(skb, netdev_features_or(features, partial_features)))
+			netdev_features_clear_bit(NETIF_F_GSO_PARTIAL_BIT, &features);
 	}
 
 	BUILD_BUG_ON(SKB_GSO_CB_OFFSET +
@@ -3440,7 +3441,7 @@ static int illegal_highdma(struct net_device *dev, struct sk_buff *skb)
 #ifdef CONFIG_HIGHMEM
 	int i;
 
-	if (!(dev->features & NETIF_F_HIGHDMA)) {
+	if (!netdev_active_features_test_bit(dev, NETIF_F_HIGHDMA_BIT)) {
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
@@ -3461,7 +3462,7 @@ static netdev_features_t net_mpls_features(struct sk_buff *skb,
 					   __be16 type)
 {
 	if (eth_p_mpls(type))
-		features &= skb->dev->mpls_features;
+		features = netdev_mpls_features_and(skb->dev, features)
 
 	return features;
 }
@@ -3484,10 +3485,11 @@ static netdev_features_t harmonize_features(struct sk_buff *skb,
 
 	if (skb->ip_summed != CHECKSUM_NONE &&
 	    !can_checksum_protocol(features, type)) {
-		features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		features = netdev_features_andnot(features, NETIF_F_CSUM_MASK);
+		features = netdev_features_andnot(features, NETIF_F_GSO_MASK);
 	}
 	if (illegal_highdma(skb->dev, skb))
-		features &= ~NETIF_F_SG;
+		netdev_features_clear_bit(NETIF_F_SG_BIT, &features);
 
 	return features;
 }
@@ -3514,11 +3516,11 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	u16 gso_segs = skb_shinfo(skb)->gso_segs;
 
 	if (gso_segs > dev->gso_max_segs)
-		return features & ~NETIF_F_GSO_MASK;
+		return netdev_features_andnot(features, NETIF_F_GSO_MASK);
 
 	if (!skb_shinfo(skb)->gso_type) {
 		skb_warn_bad_offload(skb);
-		return features & ~NETIF_F_GSO_MASK;
+		return netdev_features_andnot(features, NETIF_F_GSO_MASK);
 	}
 
 	/* Support for GSO partial features requires software
@@ -3528,7 +3530,7 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	 * segmented the frame.
 	 */
 	if (!(skb_shinfo(skb)->gso_type & SKB_GSO_PARTIAL))
-		features &= ~dev->gso_partial_features;
+		features = netdev_gso_partial_features_andnot_r(dev, features);
 
 	/* Make sure to clear the IPv4 ID mangling feature if the
 	 * IPv4 header has the potential to be fragmented.
@@ -3538,7 +3540,8 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 				    inner_ip_hdr(skb) : ip_hdr(skb);
 
 		if (!(iph->frag_off & htons(IP_DF)))
-			features &= ~NETIF_F_TSO_MANGLEID;
+			netdev_features_clear_bit(NETIF_F_TSO_MANGLEID_BIT,
+						  features);
 	}
 
 	return features;
@@ -3547,7 +3550,8 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 netdev_features_t netif_skb_features(struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
-	netdev_features_t features = dev->features;
+	netdev_features_t features = netdev_get_active_features(dev);
+	netdev_features_t tmp;
 
 	if (skb_is_gso(skb))
 		features = gso_features_check(skb, dev, features);
@@ -3557,20 +3561,20 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 	 * features for the netdev
 	 */
 	if (skb->encapsulation)
-		features &= dev->hw_enc_features;
+		features = netdev_hw_enc_features_and(dev, features);
 
-	if (skb_vlan_tagged(skb))
-		features = netdev_intersect_features(features,
-						     dev->vlan_features |
-						     NETIF_F_HW_VLAN_CTAG_TX |
-						     NETIF_F_HW_VLAN_STAG_TX);
+	if (skb_vlan_tagged(skb)) {
+		tmp = netdev_vlan_features_or(dev, netdev_tx_vlan_features);
+
+		features = netdev_intersect_features(features, tmp);
+	}
 
 	if (dev->netdev_ops->ndo_features_check)
-		features &= dev->netdev_ops->ndo_features_check(skb, dev,
-								features);
+		tmp = dev->netdev_ops->ndo_features_check(skb, dev, features);
 	else
-		features &= dflt_features_check(skb, dev, features);
+		tmp = dflt_features_check(skb, dev, features);
 
+	features = netdev_features_and(features, tmp);
 	return harmonize_features(skb, features);
 }
 EXPORT_SYMBOL(netif_skb_features);
@@ -3634,13 +3638,13 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 			    const netdev_features_t features)
 {
 	if (unlikely(skb_csum_is_sctp(skb)))
-		return !!(features & NETIF_F_SCTP_CRC) ? 0 :
-			skb_crc32c_csum_help(skb);
+		return netdev_features_test_bit(NETIF_F_SCTP_CRC_BIT, features) ?
+			0 : skb_crc32c_csum_help(skb);
 
-	if (features & NETIF_F_HW_CSUM)
+	if (netdev_features_test_bit(NETIF_F_HW_CSUM_BIT, features))
 		return 0;
 
-	if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
+	if (netdev_features_intersects(features, netdev_ip_csum_features)) {
 		switch (skb->csum_offset) {
 		case offsetof(struct tcphdr, check):
 		case offsetof(struct udphdr, check):
@@ -4382,7 +4386,7 @@ set_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 
 		/* Should we steer this flow to a different hardware queue? */
 		if (!skb_rx_queue_recorded(skb) || !dev->rx_cpu_rmap ||
-		    !(dev->features & NETIF_F_NTUPLE))
+		    !netdev_active_features_test_bit(dev, NETIF_F_NTUPLE_BIT))
 			goto out;
 		rxq_index = cpu_rmap_lookup_index(dev->rx_cpu_rmap, next_cpu);
 		if (rxq_index == skb_get_rx_queue(skb))
@@ -9813,16 +9817,14 @@ static netdev_features_t netdev_sync_upper_features(struct net_device *lower,
 	struct net_device *upper, netdev_features_t features)
 {
 	netdev_features_t upper_disables = NETIF_F_UPPER_DISABLES;
-	netdev_features_t feature;
 	int feature_bit;
 
 	for_each_netdev_feature(upper_disables, feature_bit) {
-		feature = __NETIF_F_BIT(feature_bit);
-		if (!(upper->wanted_features & feature)
-		    && (features & feature)) {
-			netdev_dbg(lower, "Dropping feature %pNF, upper dev %s has it off.\n",
-				   &feature, upper->name);
-			features &= ~feature;
+		if (!netdev_wanted_features_test_bit(upper, feature_bit) &&
+		    netdev_features_test_bit(feature_bit, features)) {
+			netdev_dbg(lower, "Dropping feature bit %d, upper dev %s has it off.\n",
+				   feature_bit, upper->name);
+			netdev_features_clear_bit(feature_bit, &features);
 		}
 	}
 
@@ -9833,20 +9835,19 @@ static void netdev_sync_lower_features(struct net_device *upper,
 	struct net_device *lower, netdev_features_t features)
 {
 	netdev_features_t upper_disables = NETIF_F_UPPER_DISABLES;
-	netdev_features_t feature;
 	int feature_bit;
 
 	for_each_netdev_feature(upper_disables, feature_bit) {
-		feature = __NETIF_F_BIT(feature_bit);
-		if (!(features & feature) && (lower->features & feature)) {
-			netdev_dbg(upper, "Disabling feature %pNF on lower dev %s.\n",
-				   &feature, lower->name);
-			lower->wanted_features &= ~feature;
+		if (!netdev_features_test_bit(feature_bit, features) &&
+		    netdev_active_features_test_bit(lower, feature_bit)) {
+			netdev_dbg(upper, "Disabling feature bit %d on lower dev %s.\n",
+				   feature_bit, lower->name);
+			netdev_wanted_features_clear_bit(lower, feature_bit);
 			__netdev_update_features(lower);
 
-			if (unlikely(lower->features & feature))
-				netdev_WARN(upper, "failed to disable %pNF on %s!\n",
-					    &feature, lower->name);
+			if (unlikely(netdev_active_features_test_bit(lower, feature_bit))
+				netdev_WARN(upper, "failed to disable feature bit %d on %s!\n",
+					    feature_bit, lower->name);
 			else
 				netdev_features_change(lower);
 		}
@@ -9856,98 +9857,109 @@ static void netdev_sync_lower_features(struct net_device *upper,
 static netdev_features_t netdev_fix_features(struct net_device *dev,
 	netdev_features_t features)
 {
+	netdev_features_t tmp;
+
 	/* Fix illegal checksum combinations */
-	if ((features & NETIF_F_HW_CSUM) &&
-	    (features & (NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM))) {
+	if (netdev_features_test_bit(NETIF_F_HW_CSUM_BIT, features) &&
+	    netdev_features_intersects(features, netdev_ip_csum_features)) {
 		netdev_warn(dev, "mixed HW and IP checksum settings.\n");
-		features &= ~(NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM);
+		features = netdev_features_andnot(features,
+						  netdev_ip_csum_features);
 	}
 
 	/* TSO requires that SG is present as well. */
-	if ((features & NETIF_F_ALL_TSO) && !(features & NETIF_F_SG)) {
+	if (netdev_features_intersects(features, NETIF_F_ALL_TSO) &&
+	    !netdev_features_test_bit(NETIF_F_SG_BIT, features)) {
 		netdev_dbg(dev, "Dropping TSO features since no SG feature.\n");
-		features &= ~NETIF_F_ALL_TSO;
+		features = netdev_features_andnot(features, NETIF_F_ALL_TSO);
 	}
 
-	if ((features & NETIF_F_TSO) && !(features & NETIF_F_HW_CSUM) &&
-					!(features & NETIF_F_IP_CSUM)) {
+	if (netdev_features_test_bit(NETIF_F_TSO_BIT, features) &&
+	    !netdev_features_test_bit(NETIF_F_HW_CSUM_BIT, features) &&
+	    !netdev_features_test_bit(NETIF_F_IP_CSUM_BIT, features)) {
 		netdev_dbg(dev, "Dropping TSO features since no CSUM feature.\n");
-		features &= ~NETIF_F_TSO;
-		features &= ~NETIF_F_TSO_ECN;
+		netdev_features_clear_bit(NETIF_F_TSO_BIT, &features);
+		netdev_features_clear_bit(NETIF_F_TSO_ECN_BIT, &features);
 	}
 
-	if ((features & NETIF_F_TSO6) && !(features & NETIF_F_HW_CSUM) &&
-					 !(features & NETIF_F_IPV6_CSUM)) {
+	if (netdev_features_test_bit(NETIF_F_TSO6_BIT, features) &&
+	    !netdev_features_test_bit(NETIF_F_HW_CSUM_BIT, features) &&
+	    !!netdev_features_test_bit(NETIF_F_IPV6_CSUM_BIT, features)) {
 		netdev_dbg(dev, "Dropping TSO6 features since no CSUM feature.\n");
-		features &= ~NETIF_F_TSO6;
+		netdev_features_clear_bit(NETIF_F_TSO6_BIT, &features);
 	}
 
 	/* TSO with IPv4 ID mangling requires IPv4 TSO be enabled */
-	if ((features & NETIF_F_TSO_MANGLEID) && !(features & NETIF_F_TSO))
-		features &= ~NETIF_F_TSO_MANGLEID;
+	if (netdev_features_test_bit(NETIF_F_TSO_MANGLEID_BIT, features) &&
+	    !netdev_features_test_bit(NETIF_F_TSO_BIT, features))
+		netdev_features_clear_bit(NETIF_F_TSO_MANGLEID_BIT, &features);
 
 	/* TSO ECN requires that TSO is present as well. */
-	if ((features & NETIF_F_ALL_TSO) == NETIF_F_TSO_ECN)
-		features &= ~NETIF_F_TSO_ECN;
+	tmp = netdev_features_and(features, NETIF_F_ALL_TSO);
+	if (netdev_features_equal(tmp, netdev_tso_ecn_features)
+		features = netdev_features_andnot(features,
+						  netdev_tso_ecn_features);
 
 	/* Software GSO depends on SG. */
-	if ((features & NETIF_F_GSO) && !(features & NETIF_F_SG)) {
+	if (netdev_features_test_bit(NETIF_F_GSO_BIT, features) &&
+	    !netdev_features_test_bit(NETIF_F_SG_BIT, features)) {
 		netdev_dbg(dev, "Dropping NETIF_F_GSO since no SG feature.\n");
-		features &= ~NETIF_F_GSO;
+		netdev_features_clear_bit(NETIF_F_GSO_BIT, &features);
 	}
 
 	/* GSO partial features require GSO partial be set */
-	if ((features & dev->gso_partial_features) &&
-	    !(features & NETIF_F_GSO_PARTIAL)) {
+	if (netdev_gso_partial_features_intersects(dev, features) &&
+	    !netdev_features_test_bit(NETIF_F_GSO_PARTIAL_BIT, features)) {
 		netdev_dbg(dev,
 			   "Dropping partially supported GSO features since no GSO partial.\n");
-		features &= ~dev->gso_partial_features;
+		features = netdev_gso_partial_features_andnot_r(dev, features);
 	}
 
-	if (!(features & NETIF_F_RXCSUM)) {
+	if (!netdev_features_test_bit(NETIF_F_RXCSUM_BIT, features)) {
 		/* NETIF_F_GRO_HW implies doing RXCSUM since every packet
 		 * successfully merged by hardware must also have the
 		 * checksum verified by hardware.  If the user does not
 		 * want to enable RXCSUM, logically, we should disable GRO_HW.
 		 */
-		if (features & NETIF_F_GRO_HW) {
+		if (netdev_features_test_bit(NETIF_F_GRO_HW_BIT, features)) {
 			netdev_dbg(dev, "Dropping NETIF_F_GRO_HW since no RXCSUM feature.\n");
-			features &= ~NETIF_F_GRO_HW;
+			netdev_features_clear_bit(NETIF_F_GRO_HW_BIT, &features);
 		}
 	}
 
 	/* LRO/HW-GRO features cannot be combined with RX-FCS */
-	if (features & NETIF_F_RXFCS) {
-		if (features & NETIF_F_LRO) {
+	if (netdev_features_test_bit(NETIF_F_RXFCS_BIT, features)) {
+		if (netdev_features_test_bit(NETIF_F_LRO_BIT, features)) {
 			netdev_dbg(dev, "Dropping LRO feature since RX-FCS is requested.\n");
-			features &= ~NETIF_F_LRO;
+			netdev_features_clear_bit(NETIF_F_LRO_BIT, &features);
 		}
 
-		if (features & NETIF_F_GRO_HW) {
+		if (netdev_features_test_bit(NETIF_F_GRO_HW_BIT, features)) {
 			netdev_dbg(dev, "Dropping HW-GRO feature since RX-FCS is requested.\n");
-			features &= ~NETIF_F_GRO_HW;
+			netdev_features_clear_bit(NETIF_F_GRO_HW_BIT, &features);
 		}
 	}
 
-	if ((features & NETIF_F_GRO_HW) && (features & NETIF_F_LRO)) {
+	if (netdev_features_test_bit(NETIF_F_GRO_HW_BIT, features) &&
+	    netdev_features_test_bit(NETIF_F_LRO_BIT, features)) {
 		netdev_dbg(dev, "Dropping LRO feature since HW-GRO is requested.\n");
-		features &= ~NETIF_F_LRO;
+		netdev_features_clear_bit(NETIF_F_LRO_BIT, &features);
 	}
 
-	if (features & NETIF_F_HW_TLS_TX) {
-		bool ip_csum = (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) ==
-			(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
-		bool hw_csum = features & NETIF_F_HW_CSUM;
+	if (netdev_features_test_bit(NETIF_F_HW_TLS_TX_BIT, features)) {
+		bool ip_csum = netdev_features_subset(features, netdev_ip_csum_features);
+		bool hw_csum = netdev_features_test_bit(NETIF_F_HW_CSUM_BIT, features);
 
 		if (!ip_csum && !hw_csum) {
 			netdev_dbg(dev, "Dropping TLS TX HW offload feature since no CSUM feature.\n");
-			features &= ~NETIF_F_HW_TLS_TX;
+			netdev_features_clear_bit(NETIF_F_HW_TLS_TX_BIT, &features);
 		}
 	}
 
-	if ((features & NETIF_F_HW_TLS_RX) && !(features & NETIF_F_RXCSUM)) {
+	if (netdev_features_test_bit(NETIF_F_HW_TLS_RX_BIT, features) &&
+	    !netdev_features_test_bit(NETIF_F_RXCSUM_BIT, features)) {
 		netdev_dbg(dev, "Dropping TLS RX HW offload feature since no RXCSUM feature.\n");
-		features &= ~NETIF_F_HW_TLS_RX;
+		netdev_features_clear_bit(NETIF_F_HW_TLS_RX_BIT, &features);
 	}
 
 	return features;
@@ -9974,7 +9986,7 @@ int __netdev_update_features(struct net_device *dev)
 	netdev_for_each_upper_dev_rcu(dev, upper, iter)
 		features = netdev_sync_upper_features(dev, upper, features);
 
-	if (dev->features == features)
+	if (netdev_active_features_equal(dev, features))
 		goto sync_lower;
 
 	netdev_dbg(dev, "Features changed: %pNF -> %pNF\n",
@@ -10003,9 +10015,9 @@ int __netdev_update_features(struct net_device *dev)
 		netdev_sync_lower_features(dev, lower, features);
 
 	if (!err) {
-		netdev_features_t diff = features ^ dev->features;
+		netdev_features_t diff = netdev_active_features_xor(dev, features);
 
-		if (diff & NETIF_F_RX_UDP_TUNNEL_PORT) {
+		if (netdev_features_test_bit(NETIF_F_RX_UDP_TUNNEL_PORT_BIT, diff)) {
 			/* udp_tunnel_{get,drop}_rx_info both need
 			 * NETIF_F_RX_UDP_TUNNEL_PORT enabled on the
 			 * device, or they won't do anything.
@@ -10013,33 +10025,36 @@ int __netdev_update_features(struct net_device *dev)
 			 * *before* calling udp_tunnel_get_rx_info,
 			 * but *after* calling udp_tunnel_drop_rx_info.
 			 */
-			if (features & NETIF_F_RX_UDP_TUNNEL_PORT) {
-				dev->features = features;
+			if (netdev_features_test_bit(NETIF_F_RX_UDP_TUNNEL_PORT_BIT,
+						     features)) {
+				netdev_set_active_features(dev, features);
 				udp_tunnel_get_rx_info(dev);
 			} else {
 				udp_tunnel_drop_rx_info(dev);
 			}
 		}
 
-		if (diff & NETIF_F_HW_VLAN_CTAG_FILTER) {
-			if (features & NETIF_F_HW_VLAN_CTAG_FILTER) {
-				dev->features = features;
+		if (netdev_features_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, diff)) {
+			if (netdev_features_test_bit(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+						     features)) {
+				netdev_set_active_features(dev, features);
 				err |= vlan_get_rx_ctag_filter_info(dev);
 			} else {
 				vlan_drop_rx_ctag_filter_info(dev);
 			}
 		}
 
-		if (diff & NETIF_F_HW_VLAN_STAG_FILTER) {
-			if (features & NETIF_F_HW_VLAN_STAG_FILTER) {
-				dev->features = features;
+		if (netdev_features_test_bit(NETIF_F_HW_VLAN_STAG_FILTER_BIT, diff)) {
+			if (netdev_features_test_bit(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
+						     features)) {
+				netdev_set_active_features(dev, features);
 				err |= vlan_get_rx_stag_filter_info(dev);
 			} else {
 				vlan_drop_rx_stag_filter_info(dev);
 			}
 		}
 
-		dev->features = features;
+		netdev_set_active_features(dev, features);
 	}
 
 	return err < 0 ? 0 : 1;
@@ -10227,6 +10242,7 @@ int register_netdevice(struct net_device *dev)
 {
 	int ret;
 	struct net *net = dev_net(dev);
+	netdev_features_t features;
 
 	BUILD_BUG_ON(sizeof(netdev_features_t) * BITS_PER_BYTE <
 		     NETDEV_FEATURE_COUNT);
@@ -10265,8 +10281,8 @@ int register_netdevice(struct net_device *dev)
 		}
 	}
 
-	if (((dev->hw_features | dev->features) &
-	     NETIF_F_HW_VLAN_CTAG_FILTER) &&
+	if ((netdev_hw_features_test_bit(dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT) ||
+	     netdev_active_features_test_bit(dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT)) &&
 	    (!dev->netdev_ops->ndo_vlan_rx_add_vid ||
 	     !dev->netdev_ops->ndo_vlan_rx_kill_vid)) {
 		netdev_WARN(dev, "Buggy VLAN acceleration in driver!\n");
@@ -10283,44 +10299,48 @@ int register_netdevice(struct net_device *dev)
 	/* Transfer changeable features to wanted_features and enable
 	 * software offloads (GSO and GRO).
 	 */
-	dev->hw_features |= (NETIF_F_SOFT_FEATURES | NETIF_F_SOFT_FEATURES_OFF);
-	dev->features |= NETIF_F_SOFT_FEATURES;
+	netdev_hw_features_direct_or(dev, NETIF_F_SOFT_FEATURES);
+	netdev_hw_features_direct_or(dev, NETIF_F_SOFT_FEATURES_OFF);
+	netdev_active_features_direct_or(dev, NETIF_F_SOFT_FEATURES);
 
 	if (dev->udp_tunnel_nic_info) {
-		dev->features |= NETIF_F_RX_UDP_TUNNEL_PORT;
-		dev->hw_features |= NETIF_F_RX_UDP_TUNNEL_PORT;
+		netdev_active_features_set_bit(dev, NETIF_F_RX_UDP_TUNNEL_PORT_BIT);
+		netdev_hw_features_set_bit(dev, NETIF_F_RX_UDP_TUNNEL_PORT_BIT);
 	}
 
-	dev->wanted_features = dev->features & dev->hw_features;
+	features = netdev_get_active_features(dev);
+	features = netdev_hw_features_and(dev, features);
+	netdev_set_wanted_features(features);
 
 	if (!(dev->flags & IFF_LOOPBACK))
-		dev->hw_features |= NETIF_F_NOCACHE_COPY;
+		netdev_hw_features_clear_bit(dev, NETIF_F_NOCACHE_COPY_BIT);
 
 	/* If IPv4 TCP segmentation offload is supported we should also
 	 * allow the device to enable segmenting the frame with the option
 	 * of ignoring a static IP ID value.  This doesn't enable the
 	 * feature itself but allows the user to enable it later.
 	 */
-	if (dev->hw_features & NETIF_F_TSO)
-		dev->hw_features |= NETIF_F_TSO_MANGLEID;
-	if (dev->vlan_features & NETIF_F_TSO)
-		dev->vlan_features |= NETIF_F_TSO_MANGLEID;
-	if (dev->mpls_features & NETIF_F_TSO)
-		dev->mpls_features |= NETIF_F_TSO_MANGLEID;
-	if (dev->hw_enc_features & NETIF_F_TSO)
-		dev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
+	if (netdev_hw_features_test_bit(dev, NETIF_F_TSO_BIT))
+		netdev_hw_features_set_bit(dev, NETIF_F_TSO_MANGLEID_BIT);
+	if (netdev_vlan_features_test_bit(dev, NETIF_F_TSO_BIT))
+		netdev_vlan_features_set_bit(dev, NETIF_F_TSO_MANGLEID_BIT);
+	if (netdev_mpls_features_test_bit(dev, NETIF_F_TSO_BIT))
+		netdev_mpls_features_set_bit(dev, NETIF_F_TSO_MANGLEID_BIT);
+	if (netdev_hw_enc_features_test_bit(dev, NETIF_F_TSO_BIT))
+		netdev_hw_enc_features_set_bit(dev, NETIF_F_TSO_MANGLEID_BIT);
 
 	/* Make NETIF_F_HIGHDMA inheritable to VLAN devices.
 	 */
-	dev->vlan_features |= NETIF_F_HIGHDMA;
+	netdev_vlan_features_set_bit(dev, NETIF_F_HIGHDMA_BIT);
 
 	/* Make NETIF_F_SG inheritable to tunnel devices.
 	 */
-	dev->hw_enc_features |= NETIF_F_SG | NETIF_F_GSO_PARTIAL;
+	netdev_hw_enc_features_set_bit(dev, NETIF_F_SG_BIT);
+	netdev_hw_enc_features_set_bit(dev, NETIF_F_GSO_PARTIAL_BIT);
 
 	/* Make NETIF_F_SG inheritable to MPLS.
 	 */
-	dev->mpls_features |= NETIF_F_SG;
+	netdev_mpls_features_set_bit(dev, NETIF_F_SG_BIT);
 
 	ret = call_netdevice_notifiers(NETDEV_POST_INIT, dev);
 	ret = notifier_to_errno(ret);
@@ -11161,7 +11181,7 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 
 	/* Don't allow namespace local devices to be moved. */
 	err = -EINVAL;
-	if (dev->features & NETIF_F_NETNS_LOCAL)
+	if (netdev_active_features_test_bit(dev, NETIF_F_NETNS_LOCAL_BIT))
 		goto out;
 
 	/* Ensure the device has been registrered */
@@ -11357,16 +11377,29 @@ static int dev_cpu_dead(unsigned int oldcpu)
 netdev_features_t netdev_increment_features(netdev_features_t all,
 	netdev_features_t one, netdev_features_t mask)
 {
-	if (mask & NETIF_F_HW_CSUM)
-		mask |= NETIF_F_CSUM_MASK;
-	mask |= NETIF_F_VLAN_CHALLENGED;
+	netdev_features_t tmp;
 
-	all |= one & (NETIF_F_ONE_FOR_ALL | NETIF_F_CSUM_MASK) & mask;
-	all &= one | ~NETIF_F_ALL_FOR_ALL;
+	if (netdev_features_test_bit(NETIF_F_HW_CSUM_BIT, mask))
+		mask = netdev_features_or(mask, NETIF_F_CSUM_MASK);
+	netdev_features_set_bit(NETIF_F_VLAN_CHALLENGED_BIT, &mask);
+
+	tmp = netdev_features_or(NETIF_F_ONE_FOR_ALL, NETIF_F_CSUM_MASK);
+	tmp = netdev_features_and(tmp, one);
+	tmp = netdev_features_and(tmp, mask);
+	all = netdev_features_or(tmp, all);
+
+	tmp = netdev_features_fill(&tmp);
+	tmp = netdev_features_andnot(tmp, NETIF_F_ALL_FOR_ALL);
+	tmp = netdev_features_or(tmp, one);
+	all = netdev_features_and(tmp, all);
 
 	/* If one device supports hw checksumming, set for all. */
-	if (all & NETIF_F_HW_CSUM)
-		all &= ~(NETIF_F_CSUM_MASK & ~NETIF_F_HW_CSUM);
+	if (netdev_features_test_bit(NETIF_F_HW_CSUM_BIT, all)) {
+		tmp = netdev_features_fill(&tmp);
+		netdev_features_clear_bit(NETIF_F_HW_CSUM_BIT, &tmp);
+		tmp = netdev_features_and(tmp, NETIF_F_CSUM_MASK);
+		all = netdev_features_andnot(all, tmp);
+	}
 
 	return all;
 }
@@ -11495,6 +11528,85 @@ define_netdev_printk_level(netdev_warn, KERN_WARNING);
 define_netdev_printk_level(netdev_notice, KERN_NOTICE);
 define_netdev_printk_level(netdev_info, KERN_INFO);
 
+static void netdev_features_init(void)
+{
+	netdev_features_t features;
+
+	netdev_features_set_array(netif_f_never_change_array,
+				  ARRAY_SIZE(netif_f_never_change_array),
+				  &netdev_never_change_features);
+
+	netdev_features_set_array(netif_f_gso_mask_array,
+				  ARRAY_SIZE(netif_f_gso_mask_array),
+				  &netdev_gso_mask_features);
+
+	netdev_features_set_array(netif_f_ip_csum_array,
+				  ARRAY_SIZE(netif_f_ip_csum_array),
+				  &netdev_ip_csum_features);
+
+	netdev_features_set_array(netif_f_csum_mask_array,
+				  ARRAY_SIZE(netif_f_csum_mask_array),
+				  &netdev_csum_mask_features);
+
+	netdev_features_set_array(netif_f_all_tso_array,
+				  ARRAY_SIZE(netif_f_all_tso_array),
+				  &netdev_all_tso_features);
+
+	netdev_features_set_array(netif_f_tso_ecn_array,
+				  ARRAY_SIZE(netif_f_tso_ecn_array),
+				  &netdev_tso_ecn_features);
+
+	netdev_features_set_array(netif_f_all_fcoe_array,
+				  ARRAY_SIZE(netif_f_all_fcoe_array),
+				  &netdev_all_fcoe_features);
+
+	netdev_features_set_array(netif_f_gso_soft_array,
+				  ARRAY_SIZE(netif_f_gso_soft_array),
+				  &netdev_gso_software_features);
+
+	netdev_features_set_array(netif_f_one_for_all_array,
+				  ARRAY_SIZE(netif_f_one_for_all_array),
+				  &netdev_one_for_all_features);
+
+	netdev_features_set_array(netif_f_all_for_all_array,
+				  ARRAY_SIZE(netif_f_all_for_all_array),
+				  &netdev_all_for_all_features);
+
+	netdev_features_set_array(netif_f_upper_disables_array,
+				  ARRAY_SIZE(netif_f_upper_disables_array),
+				  &netdev_upper_disables_features);
+
+	netdev_features_set_array(netif_f_soft_array,
+				  ARRAY_SIZE(netif_f_soft_array),
+				  &netdev_soft_features);
+
+	netdev_features_set_array(netif_f_soft_off_array,
+				  ARRAY_SIZE(netif_f_soft_off_array),
+				  &netdev_soft_off_features);
+
+	netdev_features_set_array(netif_f_tx_vlan_array,
+				  ARRAY_SIZE(netif_f_tx_vlan_array),
+				  &netdev_tx_vlan_features);
+
+	netdev_features_set_array(netif_f_tx_vlan_array,
+				  ARRAY_SIZE(netif_f_tx_vlan_array),
+				  &netdev_vlan_features);
+	netdev_features_set_array(netif_f_rx_vlan_array,
+				  ARRAY_SIZE(netif_f_rx_vlan_array),
+				  &netdev_vlan_features);
+	netdev_features_set_array(netif_f_vlan_filter_array,
+				  ARRAY_SIZE(netif_f_vlan_filter_array),
+				  &netdev_vlan_features);
+
+	netdev_features_set_array(netif_f_gso_encap_array,
+				  ARRAY_SIZE(netif_f_gso_encap_array),
+				  &netdev_gso_encap_features);
+
+	netdev_features_fill(&features);
+	netdev_ethtool_features =
+		netdev_features_andnot(features, netdev_never_change_features);
+}
+
 static void __net_exit netdev_exit(struct net *net)
 {
 	kfree(net->dev_name_head);
@@ -11642,6 +11754,8 @@ static int __init net_dev_init(void)
 	if (register_pernet_subsys(&netdev_net_ops))
 		goto out;
 
+	netdev_features_init();
+
 	/*
 	 *	Initialise the packet receive queues.
 	 */
diff --git a/net/core/netdev_features.c b/net/core/netdev_features.c
new file mode 100644
index 000000000000..e47a6773ed9c
--- /dev/null
+++ b/net/core/netdev_features.c
@@ -0,0 +1,209 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Network device features.
+ */
+
+#include <netdev_features.h>
+
+netdev_features_t netdev_ethtool_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_ethtool_features);
+
+netdev_features_t netdev_never_change_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_never_change_features);
+
+netdev_features_t netdev_gso_mask_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_gso_mask_features);
+
+netdev_features_t netdev_ip_csum_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_ip_csum_features);
+
+netdev_features_t netdev_csum_mask_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_csum_mask_features);
+
+netdev_features_t netdev_all_tso_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_all_tso_features);
+
+netdev_features_t netdev_tso_ecn_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_tso_ecn_features);
+
+netdev_features_t netdev_all_fcoe_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_all_fcoe_features);
+
+netdev_features_t netdev_gso_software_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_gso_software_features);
+
+netdev_features_t netdev_one_for_all_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_one_for_all_features);
+
+netdev_features_t netdev_all_for_all_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_all_for_all_features);
+
+netdev_features_t netdev_upper_disable_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_upper_disable_features);
+
+netdev_features_t netdev_soft_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_soft_features);
+
+netdev_features_t netdev_soft_off_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_soft_off_features);
+
+netdev_features_t netdev_vlan_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_vlan_features);
+
+netdev_features_t netdev_tx_vlan_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_tx_vlan_features);
+
+netdev_features_t netdev_gso_encap_all_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_gso_encap_all_features);
+
+const u8 netif_f_never_change_array[] = {
+	NETIF_F_VLAN_CHALLENGED_BIT,
+	NETIF_F_LLTX_BIT,
+	NETIF_F_NETNS_LOCAL_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_never_change_array);
+
+const u8 netif_f_gso_mask_array[] = {
+	NETIF_F_TSO_BIT,
+	NETIF_F_GSO_ROBUST_BIT,
+	NETIF_F_TSO_ECN_BIT,
+	NETIF_F_TSO_MANGLEID_BIT,
+	NETIF_F_TSO6_BIT,
+	NETIF_F_FSO_BIT,
+	NETIF_F_GSO_GRE_BIT,
+	NETIF_F_GSO_GRE_CSUM_BIT,
+	NETIF_F_GSO_IPXIP4_BIT,
+	NETIF_F_GSO_IPXIP6_BIT,
+	NETIF_F_GSO_UDP_TUNNEL_BIT,
+	NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+	NETIF_F_GSO_PARTIAL_BIT,
+	NETIF_F_GSO_TUNNEL_REMCSUM_BIT,
+	NETIF_F_GSO_SCTP_BIT,
+	NETIF_F_GSO_ESP_BIT,
+	NETIF_F_GSO_UDP_BIT,
+	NETIF_F_GSO_UDP_L4_BIT,
+	NETIF_F_GSO_FRAGLIST_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_gso_mask_array);
+
+const u8 netif_f_ip_csum_array[] = {
+	NETIF_F_IP_CSUM_BIT,
+	NETIF_F_IPV6_CSUM_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_ip_csum_array);
+
+const u8 netif_f_csum_mask_array[] = {
+	NETIF_F_IP_CSUM_BIT,
+	NETIF_F_IPV6_CSUM_BIT,
+	NETIF_F_HW_CSUM_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_csum_mask_array);
+
+const u8 netif_f_all_tso_array[] = {
+	NETIF_F_TSO_BIT,
+	NETIF_F_TSO6_BIT,
+	NETIF_F_TSO_ECN_BIT,
+	NETIF_F_TSO_MANGLEID_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_all_tso_array);
+
+const u8 netif_f_tso_ecn_array[] = {
+	NETIF_F_TSO_ECN_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_tso_ecn_array);
+
+const u8 netif_f_all_fcoe_array[] = {
+	NETIF_F_FCOE_CRC_BIT,
+	NETIF_F_FCOE_MTU_BIT,
+	NETIF_F_FSO_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_all_fcoe_array);
+
+const u8 netif_f_gso_soft_array[] = {
+	NETIF_F_TSO_BIT,
+	NETIF_F_TSO6_BIT,
+	NETIF_F_TSO_ECN_BIT,
+	NETIF_F_TSO_MANGLEID_BIT,
+	NETIF_F_GSO_SCTP_BIT,
+	NETIF_F_GSO_UDP_L4_BIT,
+	NETIF_F_GSO_FRAGLIST_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_gso_soft_array);
+
+const u8 netif_f_one_for_all_array[] = {
+	NETIF_F_TSO_BIT,
+	NETIF_F_TSO6_BIT,
+	NETIF_F_TSO_ECN_BIT,
+	NETIF_F_TSO_MANGLEID_BIT,
+	NETIF_F_GSO_SCTP_BIT,
+	NETIF_F_GSO_UDP_L4_BIT,
+	NETIF_F_GSO_FRAGLIST_BIT,
+	NETIF_F_GSO_ROBUST_BIT,
+	NETIF_F_SG_BIT,
+	NETIF_F_HIGHDMA_BIT,
+	NETIF_F_FRAGLIST_BIT,
+	NETIF_F_VLAN_CHALLENGED,
+};
+EXPORT_SYMBOL_GPL(netif_f_one_for_all_array);
+
+const u8 netif_f_all_for_all_array[] = {
+	NETIF_F_NOCACHE_COPY_BIT,
+	NETIF_F_FSO_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_all_for_all_array);
+
+const u8 netif_f_upper_disables_array[] = {
+	NETIF_F_LRO_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_upper_disables_array);
+
+const u8 netif_f_soft_array[] = {
+	NETIF_F_GSO_BIT,
+	NETIF_F_GRO_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_soft_array);
+
+const u8 netif_f_soft_off_array[] = {
+	NETIF_F_GRO_FRAGLIST_BIT,
+	NETIF_F_GRO_UDP_FWD_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_soft_off_array);
+
+const u8 netif_f_vlan_array[] = {
+	NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+	NETIF_F_HW_VLAN_CTAG_RX_BIT,
+	NETIF_F_HW_VLAN_CTAG_TX_BIT,
+	NETIF_F_HW_VLAN_STAG_FILTER_BIT,
+	NETIF_F_HW_VLAN_STAG_RX_BIT,
+	NETIF_F_HW_VLAN_STAG_TX_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_vlan_array);
+
+const u8 netif_f_tx_vlan_array[] = {
+	NETIF_F_HW_VLAN_CTAG_TX_BIT,
+	NETIF_F_HW_VLAN_STAG_TX_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_tx_vlan_array);
+
+const u8 netif_f_rx_vlan_array[] = {
+	NETIF_F_HW_VLAN_CTAG_RX_BIT,
+	NETIF_F_HW_VLAN_STAG_RX_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_rx_vlan_array);
+
+const u8 netif_f_vlan_filter_array[] = {
+	NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+	NETIF_F_HW_VLAN_STAG_FILTER_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_vlan_filter_array);
+
+const u8 netif_f_gso_encap_array[] = {
+	NETIF_F_GSO_GRE_BIT,
+	NETIF_F_GSO_GRE_CSUM_BIT,
+	NETIF_F_GSO_IPXIP4_BIT,
+	NETIF_F_GSO_IPXIP6_BIT,
+	NETIF_F_GSO_UDP_TUNNEL_BIT,
+	NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_gso_encap_array);
+
-- 
2.33.0

