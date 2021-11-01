Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7114411C0
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 02:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhKABMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 21:12:46 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:25331 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhKABMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 21:12:45 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HjFFf5wwGzbhRJ;
        Mon,  1 Nov 2021 09:05:26 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 1 Nov 2021 09:10:05 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 1 Nov 2021 09:09:59 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv3 PATCH net-next] net: extend netdev_features_t
Date:   Mon, 1 Nov 2021 09:05:35 +0800
Message-ID: <20211101010535.32575-1-shenjian15@huawei.com>
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

The whole work is not complete yet. I just use these changes
on HNS3 drivers and part of net/core/dev.c, in order to show
how these helpers will be used. I want to get more suggestions
for this scheme, any comments would be appreciated.

The former discussion please see [1].

[1]:https://www.spinics.net/lists/netdev/msg769952.html

ChangeLog:
V2->V3:
use structure for bitmap, suggest by Edward Cree
V1->V2:
Extend the prototype from u64 to bitmap, suggest by Andrew Lunn

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  89 ++--
 include/linux/netdev_features.h               | 471 +++++++++++++++---
 net/core/dev.c                                | 119 +++--
 3 files changed, 528 insertions(+), 151 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index a2b993d62822..3352c38fd927 100644
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
+	if (netdev_features_test_bit(NETIF_F_NTUPLE_BIT, changed) &&
+	    h->ae_algo->ops->enable_fd) {
 		enable = !!(features & NETIF_F_NTUPLE);
 		h->ae_algo->ops->enable_fd(h, enable);
 	}
 
-	if ((netdev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
+	if (netdev_active_features_test_bit(netdev, NETIF_F_HW_TC_BIT) >
+	    netdev_features_test_bit(NETIF_F_NTUPLE_BIT, features) &&
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
 
@@ -2377,7 +2384,8 @@ static netdev_features_t hns3_features_check(struct sk_buff *skb,
 	 * len of 480 bytes.
 	 */
 	if (len > HNS3_MAX_HDR_LEN)
-		features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		netdev_features_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK,
+					   &features);
 
 	return features;
 }
@@ -3122,55 +3130,68 @@ static struct pci_driver hns3_driver = {
 	.err_handler    = &hns3_err_handler,
 };
 
+#define HNS3_DEFAULT_ACTIVE_FEATURES   \
+	(NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_TX |  \
+	NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_RXCSUM | NETIF_F_SG |  \
+	NETIF_F_GSO | NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | \
+	NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM | NETIF_F_SCTP_CRC \
+	NETIF_F_GSO_UDP_TUNNEL | NETIF_F_FRAGLIST)
+
 /* set default feature to hns3 */
 static void hns3_set_default_feature(struct net_device *netdev)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 	struct pci_dev *pdev = h->pdev;
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(pdev);
+	netdev_features_t tmp1, tmp2;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
-	netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
+	netdev_gso_partial_features_set_bit(netdev, NETIF_F_GSO_GRE_CSUM_BIT);
 
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
-		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
-		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
-		NETIF_F_SCTP_CRC | NETIF_F_FRAGLIST;
+	netdev_active_features_set_bits(netdev, HNS3_DEFAULT_ACTIVE_FEATURES);
 
 	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
-		netdev->features |= NETIF_F_GRO_HW;
+		netdev_active_features_set_bit(netdev, NETIF_F_GRO_HW_BIT);
 
 		if (!(h->flags & HNAE3_SUPPORT_VF))
-			netdev->features |= NETIF_F_NTUPLE;
+			netdev_active_features_set_bit(netdev,
+						       NETIF_F_NTUPLE_BIT);
 	}
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, ae_dev->caps))
-		netdev->features |= NETIF_F_GSO_UDP_L4;
+		netdev_active_features_set_bit(netdev, NETIF_F_GSO_UDP_L4_BIT);
 
 	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps))
-		netdev->features |= NETIF_F_HW_CSUM;
+		netdev_active_features_set_bit(netdev, NETIF_F_HW_CSUM_BIT);
 	else
-		netdev->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+		netdev_active_features_set_bits(netdev,
+						NETIF_F_IP_CSUM |
+						NETIF_F_IPV6_CSUM);
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps))
-		netdev->features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_active_features_set_bit(netdev,
+					       NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 
 	if (test_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps))
-		netdev->features |= NETIF_F_HW_TC;
+		netdev_active_features_set_bit(netdev, NETIF_F_HW_TC_BIT);
 
-	netdev->hw_features |= netdev->features;
+	tmp1 = netdev_get_active_features(netdev);
+	tmp2 = netdev_hw_features_or(netdev, tmp1);
+	netdev_set_hw_features(tmp2);
 	if (!test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
-		netdev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-
-	netdev->vlan_features |= netdev->features &
-		~(NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_TX |
-		  NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_GRO_HW | NETIF_F_NTUPLE |
-		  NETIF_F_HW_TC);
-
-	netdev->hw_enc_features |= netdev->vlan_features | NETIF_F_TSO_MANGLEID;
+		netdev_hw_features_clear_bit(netdev,
+					     NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
+
+	netdev_features_clear_bits(NETIF_F_HW_VLAN_CTAG_FILTER |
+				  NETIF_F_HW_VLAN_CTAG_TX |
+				  NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_GRO_HW |
+				  NETIF_F_NTUPLE | NETIF_F_HW_TC, &tmp1);
+	netdev_set_vlan_features(tmp1);
+
+	netdev_features_set_bit(NETIF_F_TSO_MANGLEID_BIT, &tmp1);
+	tmp1 = netdev_hw_enc_features_or(netdev, tmp1);
+	netdev_set_hw_enc_features(tmp1);
 }
 
 static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 16f778887e14..9b3ab11e19c8 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -101,12 +101,12 @@ enum {
 
 typedef struct {
 	DECLARE_BITMAP(bits, NETDEV_FEATURE_COUNT);
-} netdev_features_t; 
+} netdev_features_t;
 
 #define NETDEV_FEATURE_DWORDS	DIV_ROUND_UP(NETDEV_FEATURE_COUNT, 64)
 
 /* copy'n'paste compression ;) */
-#define __NETIF_F_BIT(bit)	((netdev_features_t)1 << (bit))
+#define __NETIF_F_BIT(bit)	((u64)1 << (bit))
 #define __NETIF_F(name)		__NETIF_F_BIT(NETIF_F_##name##_BIT)
 
 #define NETIF_F_FCOE_CRC	__NETIF_F(FCOE_CRC)
@@ -189,10 +189,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
  * mask_addr should be a u64 and bit an int
  */
 #define for_each_netdev_feature(mask_addr, bit)				\
-	for ((bit) = find_next_netdev_feature((mask_addr),		\
-					      NETDEV_FEATURE_COUNT);	\
-	     (bit) >= 0;						\
-	     (bit) = find_next_netdev_feature((mask_addr), (bit) - 1))
+	for_each_set_bit(bit, (unsigned long *)mask_addr, NETDEV_FEATURE_COUNT)
 
 /* Features valid for ethtool to change */
 /* = all defined minus driver/device-class-related */
@@ -265,131 +262,471 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 				 NETIF_F_GSO_UDP_TUNNEL |		\
 				 NETIF_F_GSO_UDP_TUNNEL_CSUM)
 
-static inline void netdev_feature_zero(netdev_features_t *dst)
+static inline void netdev_features_zero(netdev_features_t *dst)
 {
 	bitmap_zero(dst->bits, NETDEV_FEATURE_COUNT);
 }
 
-static inline void netdev_feature_fill(netdev_features_t *dst)
+static inline void netdev_features_fill(netdev_features_t *dst)
 {
 	bitmap_fill(dst->bits, NETDEV_FEATURE_COUNT);
 }
 
-static inline void netdev_feature_and(netdev_features_t *dst,
-				      const netdev_features_t a,
-				      const netdev_features_t b)
+static inline netdev_features_t netdev_features_and(netdev_features_t a,
+						    netdev_features_t b)
 {
-	bitmap_and(dst->bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
+	netdev_features_t dst;
+
+	bitmap_and(dst.bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
+	return dst;
 }
 
-static inline void netdev_feature_or(netdev_features_t *dst,
-				     const netdev_features_t a,
-				     const netdev_features_t b)
+static inline netdev_features_t netdev_features_or(netdev_features_t a,
+						   netdev_features_t b)
 {
-	bitmap_or(dst->bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
+	netdev_features_t dst;
+
+	bitmap_or(dst.bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
+	return dst;
 }
 
-static inline void netdev_feature_xor(netdev_features_t *dst,
-				      const netdev_features_t a,
-				      const netdev_features_t b)
+static inline netdev_features_t netdev_features_xor(netdev_features_t a,
+						    netdev_features_t b)
 {
-	bitmap_xor(dst->bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
+	netdev_features_t dst;
+
+	bitmap_xor(dst.bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
+	return dst;
 }
 
-static inline bool netdev_feature_empty(netdev_features_t src)
+static inline bool netdev_features_empty(netdev_features_t src)
 {
 	return bitmap_empty(src.bits, NETDEV_FEATURE_COUNT);
 }
 
-static inline bool netdev_feature_equal(const netdev_features_t src1,
-					const netdev_features_t src2)
+static inline bool netdev_features_equal(netdev_features_t src1,
+					 netdev_features_t src2)
 {
-	return src1 == src2;
+	return bitmap_equal(src1.bits, src2.bits, NETDEV_FEATURE_COUNT);
 }
 
-static inline int netdev_feature_andnot(netdev_features_t *dst,
-					const netdev_features_t src1,
-					const netdev_features_t src2)
+static inline netdev_features_t netdev_features_andnot(netdev_features_t src1,
+						       netdev_features_t src2)
 {
-	*dst = src1 & ~src2;
-	return 0;
+	netdev_features_t dst;
+
+	bitmap_andnot(dst.bits, src1.bits, src2.bits, NETDEV_FEATURE_COUNT);
+	return dst;
 }
 
-static inline void netdev_feature_set_bit(int nr, netdev_features_t *addr)
+static inline void netdev_features_set_bit(int nr, netdev_features_t *src)
 {
-	*addr |= __NETIF_F_BIT(nr);
+	__set_bit(nr, src->bits);
 }
 
-static inline void netdev_feature_clear_bit(int nr, netdev_features_t *addr)
+static inline void netdev_features_clear_bit(int nr, netdev_features_t *src)
 {
-	*addr &= ~(__NETIF_F_BIT(nr));
+	__clear_bit(nr, src->bits);
 }
 
-static inline void netdev_feature_mod_bit(int nr, netdev_features_t *addr,
-					  int set)
+static inline void netdev_features_change_bit(int nr, netdev_features_t *src)
 {
-	if (set)
-		netdev_feature_set_bit(nr, addr);
-	else
-		netdev_feature_clear_bit(nr, addr);
+	__change_bit(nr, src->bits);
 }
 
-static inline void netdev_feature_change_bit(int nr, netdev_features_t *addr)
+static inline bool netdev_features_test_bit(int nr, netdev_features_t src)
 {
-	*addr ^= __NETIF_F_BIT(nr);
+	return test_bit(nr, src.bits);
 }
 
-static inline int netdev_feature_test_bit(int nr, const netdev_features_t addr)
+/* only be used for the first 64 bits features */
+static inline void netdev_features_set_bits(u64 bits, netdev_features_t *src)
 {
-	return (addr & __NETIF_F_BIT(nr)) > 0;
+	netdev_features_t tmp;
+
+	bitmap_from_u64(tmp.bits, bits);
+	*src = netdev_features_or(*src, tmp);
 }
 
-static inline void netdev_feature_set_bit_array(const int *array,
-						int array_size,
-						netdev_features_t *addr)
+/* only be used for the first 64 bits features */
+static inline void netdev_features_clear_bits(u64 bits, netdev_features_t *src)
 {
-	int i;
+	netdev_features_t tmp;
 
-	for (i = 0; i < array_size; i++)
-		netdev_feature_set_bit(array[i], addr);
+	bitmap_from_u64(tmp.bits, bits);
+	*src = netdev_features_andnot(*src, tmp);
 }
 
 /* only be used for the first 64 bits features */
-static inline void netdev_feature_set_bits(u64 bits, netdev_features_t *addr)
+static inline bool netdev_features_test_bits(u64 bits, netdev_features_t src)
 {
-	*addr |= bits;
+	netdev_features_t tmp;
+
+	bitmap_from_u64(tmp.bits, bits);
+	tmp = netdev_features_and(tmp, src);
+	return netdev_features_empty(tmp);
 }
 
 /* only be used for the first 64 bits features */
-static inline void netdev_feature_clear_bits(u64 bits, netdev_features_t *addr)
+static inline void netdev_features_and_bits(u64 bits, netdev_features_t *src)
 {
-	*addr &= ~bits;
+	netdev_features_t tmp;
+
+	bitmap_from_u64(tmp.bits, bits);
+	*src = netdev_features_and(tmp, *src);
 }
 
-/* only be used for the first 64 bits features */
-static inline bool netdev_feature_test_bits(u64 bits,
-					    const netdev_features_t addr)
+static inline bool netdev_features_intersects(netdev_features_t src1,
+					      netdev_features_t src2)
 {
-	return (addr & bits) > 0;
+	return bitmap_intersects(src1.bits, src2.bits, NETDEV_FEATURE_COUNT);
 }
 
-/* only be used for the first 64 bits features */
-static inline void netdev_feature_and_bits(u64 bits,
-					   netdev_features_t *addr)
+static inline bool netdev_features_subset(netdev_features_t src1,
+					  netdev_features_t src2)
+{
+	return bitmap_subset(src1.bits, src2.bits, NETDEV_FEATURE_COUNT);
+}
+
+static inline void netdev_set_active_features(struct net_device *netdev,
+					      netdev_features_t src)
+{
+	netdev->features = src;
+}
+
+static inline netdev_features_t
+netdev_get_active_features(struct net_device *netdev)
+{
+	return netdev->features;
+}
+
+#define netdev_active_features_zero(ndev) \
+		netdev_features_zero(&ndev->features)
+
+#define netdev_active_features_and(ndev, features) \
+		netdev_features_and(ndev->features, features)
+
+#define netdev_active_features_or(ndev, features) \
+		netdev_features_or(ndev->features, features)
+
+#define netdev_active_features_xor(ndev, features) \
+		netdev_features_xor(ndev->features, features)
+
+#define netdev_active_features_andnot(ndev, features) \
+		netdev_features_andnot(ndev->features, features)
+
+#define netdev_active_features_set_bit(ndev, nr) \
+		netdev_features_set_bit(nr, &ndev->features)
+
+#define netdev_active_features_clear_bit(ndev, nr) \
+		netdev_features_clear_bit(nr, &ndev->features)
+
+#define netdev_active_features_test_bit(ndev, nr) \
+		netdev_features_test_bit(nr, &ndev->features)
+
+#define netdev_active_features_set_bits(ndev, bits) \
+		netdev_features_set_bits(bits, &ndev->features)
+
+#define netdev_active_features_clear_bits(ndev, bits) \
+		netdev_features_clear_bits(bits, &ndev->features)
+
+#define netdev_active_features_test_bits(ndev, bits) \
+		netdev_features_test_bits(bits, &ndev->features)
+
+#define netdev_active_features_and_bits(ndev, bits) \
+		netdev_features_and_bits(bits, &ndev->features)
+
+
+static inline void netdev_set_hw_features(struct net_device *netdev,
+					  netdev_features_t src)
+{
+	netdev->hw_features = src;
+}
+
+static inline netdev_features_t
+netdev_get_hw_features(struct net_device *netdev)
+{
+	return netdev->hw_features;
+}
+
+#define netdev_hw_features_zero(ndev) \
+		netdev_features_zero(&ndev->hw_features)
+
+#define netdev_hw_features_copy(features) \
+	netdev_features_copy(&ndev->hw_features)
+
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
+#define netdev_hw_features_set_bit(ndev, nr) \
+		netdev_features_set_bit(nr, &ndev->hw_features)
+
+#define netdev_hw_features_clear_bit(ndev, nr) \
+		netdev_features_clear_bit(nr, &ndev->hw_features)
+
+#define netdev_hw_features_test_bit(ndev, nr) \
+		netdev_features_test_bit(nr, &ndev->hw_features)
+
+#define netdev_hw_features_set_bits(ndev, bits) \
+		netdev_features_set_bits(bits, &ndev->hw_features)
+
+#define netdev_hw_features_clear_bits(ndev, bits) \
+		netdev_features_clear_bits(bits, &ndev->hw_features)
+
+#define netdev_hw_features_test_bits(ndev, bits) \
+		netdev_features_test_bits(bits, &ndev->hw_features)
+
+#define netdev_hw_features_and_bits(ndev, bits) \
+		netdev_features_and_bits(bits, &ndev->hw_features)
+
+static inline void netdev_set_wanted_features(struct net_device *netdev,
+					  netdev_features_t src)
+{
+	netdev->wanted_features = src;
+}
+
+static inline netdev_features_t
+netdev_get_wanted_features(struct net_device *netdev)
+{
+	return netdev->wanted_features;
+}
+
+#define netdev_wanted_features_zero(ndev) \
+		netdev_features_zero(&ndev->wanted_features)
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
+#define netdev_wanted_features_set_bit(ndev, nr) \
+		netdev_features_set_bit(nr, &ndev->wanted_features)
+
+#define netdev_wanted_features_clear_bit(ndev, nr) \
+		netdev_features_clear_bit(nr, &ndev->wanted_features)
+
+#define netdev_wanted_features_test_bit(ndev, nr) \
+		netdev_features_test_bit(nr, &ndev->wanted_features)
+
+#define netdev_wanted_features_set_bits(ndev, bits) \
+		netdev_features_set_bits(bits, &ndev->wanted_features)
+
+#define netdev_wanted_features_clear_bits(ndev, bits) \
+		netdev_features_clear_bits(bits, &ndev->wanted_features)
+
+#define netdev_wanted_features_test_bits(ndev, bits) \
+		netdev_features_test_bits(bits, &ndev->wanted_features)
+
+#define netdev_wanted_features_and_bits(ndev, bits) \
+		netdev_features_and_bits(bits, &ndev->wanted_features)
+
+static inline void netdev_set_vlan_features(struct net_device *netdev,
+					  netdev_features_t src)
+{
+	netdev->vlan_features = src;
+}
+
+static inline netdev_features_t
+netdev_get_vlan_features(struct net_device *netdev)
+{
+	return netdev->vlan_features;
+}
+
+#define netdev_vlan_features_zero(ndev) \
+		netdev_features_zero(&ndev->vlan_features)
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
+#define netdev_vlan_features_set_bit(ndev, nr) \
+		netdev_features_set_bit(nr, &ndev->vlan_features)
+
+#define netdev_vlan_features_clear_bit(ndev, nr) \
+		netdev_features_clear_bit(nr, &ndev->vlan_features)
+
+#define netdev_vlan_features_test_bit(ndev, nr) \
+		netdev_features_test_bit(nr, &ndev->vlan_features)
+
+#define netdev_vlan_features_set_bits(ndev, bits) \
+		netdev_features_set_bits(bits, &ndev->vlan_features)
+
+#define netdev_vlan_features_clear_bits(ndev, bits) \
+		netdev_features_clear_bits(bits, &ndev->vlan_features)
+
+#define netdev_vlan_features_test_bits(ndev, bits) \
+		netdev_features_test_bits(bits, &ndev->vlan_features)
+
+#define netdev_vlan_features_and_bits(ndev, bits) \
+		netdev_features_and_bits(bits, &ndev->vlan_features)
+
+static inline void netdev_set_hw_enc_features(struct net_device *netdev,
+					      netdev_features_t src)
 {
-	*addr &= bits;
+	netdev->hw_enc_features = src;
 }
 
-static inline int netdev_feature_intersects(const netdev_features_t src1,
-					    const netdev_features_t src2)
+static inline netdev_features_t
+netdev_get_hw_enc_features(struct net_device *netdev)
 {
-	return (src1 & src2) > 0;
+	return netdev->hw_enc_features;
 }
 
-static inline int netdev_feature_subset(const netdev_features_t src1,
-					const netdev_features_t src2)
+#define netdev_hw_enc_features_zero(ndev) \
+		netdev_features_zero(&ndev->hw_enc_features)
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
+#define netdev_hw_enc_features_set_bit(ndev, nr) \
+		netdev_features_set_bit(nr, &ndev->hw_enc_features)
+
+#define netdev_hw_enc_features_clear_bit(ndev, nr) \
+		netdev_features_clear_bit(nr, &ndev->hw_enc_features)
+
+#define netdev_hw_enc_features_test_bit(ndev, nr) \
+		netdev_features_test_bit(nr, &ndev->hw_enc_features)
+
+#define netdev_hw_enc_features_set_bits(ndev, bits) \
+		netdev_features_set_bits(bits, &ndev->hw_enc_features)
+
+#define netdev_hw_enc_features_clear_bits(ndev, bits) \
+		netdev_features_clear_bits(bits, &ndev->hw_enc_features)
+
+#define netdev_hw_enc_features_test_bits(ndev, bits) \
+		netdev_features_test_bits(bits, &ndev->hw_enc_features)
+
+#define netdev_hw_enc_features_and_bits(ndev, bits) \
+		netdev_features_and_bits(bits, &ndev->hw_enc_features)
+
+static inline void netdev_set_mpls_features(struct net_device *netdev,
+					    netdev_features_t src)
 {
-	return (src1 & src2) == src2;
+	netdev->mpls_features = src;
 }
 
+static inline netdev_features_t
+netdev_get_mpls_features(struct net_device *netdev)
+{
+	return netdev->mpls_features;
+}
+
+#define netdev_mpls_features_zero(ndev) \
+		netdev_features_zero(&ndev->mpls_features)
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
+#define netdev_mpls_features_set_bit(ndev, nr) \
+		netdev_features_set_bit(nr, &ndev->mpls_features)
+
+#define netdev_mpls_features_clear_bit(ndev, nr) \
+		netdev_features_clear_bit(nr, &ndev->mpls_features)
+
+#define netdev_mpls_features_test_bit(ndev, nr) \
+		netdev_features_test_bit(nr, &ndev->mpls_features)
+
+#define netdev_mpls_features_set_bits(ndev, bits) \
+		netdev_features_set_bits(bits, &ndev->mpls_features)
+
+#define netdev_mpls_features_clear_bits(ndev, bits) \
+		netdev_features_clear_bits(bits, &ndev->mpls_features)
+
+#define netdev_mpls_features_test_bits(ndev, bits) \
+		netdev_features_test_bits(bits, &ndev->mpls_features)
+
+#define netdev_mpls_features_and_bits(ndev, bits) \
+		netdev_features_and_bits(bits, &ndev->mpls_features)
+
+static inline void netdev_set_gso_partial_features(struct net_device *netdev,
+						   netdev_features_t src)
+{
+	netdev->gso_partial_features = src;
+}
+
+static inline netdev_features_t
+netdev_get_gso_partial_features(struct net_device *netdev)
+{
+	return netdev->gso_partial_features;
+}
+
+#define netdev_gso_partial_features_zero(ndev) \
+		netdev_features_zero(&ndev->gso_partial_features)
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
+#define netdev_gso_partial_features_set_bit(ndev, nr) \
+		netdev_features_set_bit(nr, &ndev->gso_partial_features)
+
+#define netdev_gso_partial_features_clear_bit(ndev, nr) \
+		netdev_features_clear_bit(nr, &ndev->gso_partial_features)
+
+#define netdev_gso_partial_features_test_bit(ndev, nr) \
+		netdev_features_test_bit(nr, &ndev->gso_partial_features)
+
+#define netdev_gso_partial_features_set_bits(ndev, bits) \
+		netdev_features_set_bits(bits, &ndev->gso_partial_features)
+
+#define netdev_gso_partial_features_clear_bits(ndev, bits) \
+		netdev_features_clear_bits(bits, &ndev->gso_partial_features)
+
+#define netdev_gso_partial_features_test_bits(ndev, bits) \
+		netdev_features_test_bits(bits, &ndev->gso_partial_features)
+
+#define netdev_gso_partial_features_and_bits(ndev, bits) \
+		netdev_features_and_bits(bits, &ndev->gso_partial_features)
+
 #endif	/* _LINUX_NETDEV_FEATURES_H */
diff --git a/net/core/dev.c b/net/core/dev.c
index edeb811c454e..58aa2f4789b9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1642,10 +1642,10 @@ void dev_disable_lro(struct net_device *dev)
 	struct net_device *lower_dev;
 	struct list_head *iter;
 
-	dev->wanted_features &= ~NETIF_F_LRO;
+	netdev_wanted_features_clear_bit(dev, NETIF_F_LRO_BIT);
 	netdev_update_features(dev);
 
-	if (unlikely(dev->features & NETIF_F_LRO))
+	if (unlikely(netdev_active_features_test_bits(dev, NETIF_F_LRO_BIT)))
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
+	if (unlikely(netdev_active_features_test_bits(dev, NETIF_F_GRO_HW_BIT)))
 		netdev_WARN(dev, "failed to disable GRO_HW!\n");
 }
 
@@ -3391,13 +3391,17 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 	 * support segmentation on this frame without needing additional
 	 * work.
 	 */
-	if (features & NETIF_F_GSO_PARTIAL) {
-		netdev_features_t partial_features = NETIF_F_GSO_ROBUST;
+	if (netdev_features_test_bit(NETIF_F_GSO_PARTIAL_BIT, features)) {
+		netdev_features_t partial_features;
 		struct net_device *dev = skb->dev;
 
-		partial_features |= dev->features & dev->gso_partial_features;
-		if (!skb_gso_ok(skb, features | partial_features))
-			features &= ~NETIF_F_GSO_PARTIAL;
+		partial_features = netdev_features_and(dev->features,
+						       dev->gso_partial_features);
+		netdev_features_set_bit(NETIF_F_GSO_ROBUST_BIT, &partial_features);
+		if (!skb_gso_ok(skb,
+				netdev_features_or(features, partial_features)))
+			netdev_features_clear_bit(NETIF_F_GSO_PARTIAL_BIT,
+						  &features);
 	}
 
 	BUILD_BUG_ON(SKB_GSO_CB_OFFSET +
@@ -3440,7 +3444,7 @@ static int illegal_highdma(struct net_device *dev, struct sk_buff *skb)
 #ifdef CONFIG_HIGHMEM
 	int i;
 
-	if (!(dev->features & NETIF_F_HIGHDMA)) {
+	if (!netdev_active_features_test_bit(dev, NETIF_F_HIGHDMA_BIT)) {
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 			skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
@@ -3460,8 +3464,11 @@ static netdev_features_t net_mpls_features(struct sk_buff *skb,
 					   netdev_features_t features,
 					   __be16 type)
 {
-	if (eth_p_mpls(type))
-		features &= skb->dev->mpls_features;
+	if (eth_p_mpls(type)) {
+		netdev_features_t mpls = netdev_get_mpls_features(skb->dev);
+
+		features = netdev_features_and(features, mpls);
+	}
 
 	return features;
 }
@@ -3484,10 +3491,11 @@ static netdev_features_t harmonize_features(struct sk_buff *skb,
 
 	if (skb->ip_summed != CHECKSUM_NONE &&
 	    !can_checksum_protocol(features, type)) {
-		features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		netdev_features_clear_bits(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK,
+					   &features);
 	}
 	if (illegal_highdma(skb->dev, skb))
-		features &= ~NETIF_F_SG;
+		netdev_features_clear_bit(NETIF_F_SG_BIT, &features);
 
 	return features;
 }
@@ -3513,12 +3521,15 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 {
 	u16 gso_segs = skb_shinfo(skb)->gso_segs;
 
-	if (gso_segs > dev->gso_max_segs)
-		return features & ~NETIF_F_GSO_MASK;
+	if (gso_segs > dev->gso_max_segs) {
+		netdev_features_clear_bits(NETIF_F_GSO_MASK, &features);
+		return features;
+	}
 
 	if (!skb_shinfo(skb)->gso_type) {
 		skb_warn_bad_offload(skb);
-		return features & ~NETIF_F_GSO_MASK;
+		netdev_features_clear_bits(NETIF_F_GSO_MASK, &features);
+		return features;
 	}
 
 	/* Support for GSO partial features requires software
@@ -3527,8 +3538,11 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	 * and we can pull them back in after we have partially
 	 * segmented the frame.
 	 */
-	if (!(skb_shinfo(skb)->gso_type & SKB_GSO_PARTIAL))
-		features &= ~dev->gso_partial_features;
+	if (!(skb_shinfo(skb)->gso_type & SKB_GSO_PARTIAL)) {
+		netdev_features_t gso = netdev_get_gso_partial_features(dev);
+
+		features = netdev_features_andnot(features, gso);
+	}
 
 	/* Make sure to clear the IPv4 ID mangling feature if the
 	 * IPv4 header has the potential to be fragmented.
@@ -3538,7 +3552,8 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 				    inner_ip_hdr(skb) : ip_hdr(skb);
 
 		if (!(iph->frag_off & htons(IP_DF)))
-			features &= ~NETIF_F_TSO_MANGLEID;
+			netdev_features_clear_bit(NETIF_F_TSO_MANGLEID_BIT,
+						  &features);
 	}
 
 	return features;
@@ -3547,7 +3562,8 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 netdev_features_t netif_skb_features(struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
-	netdev_features_t features = dev->features;
+	netdev_features_t features = netdev_get_active_features(dev);
+	netdev_features_t tmp;
 
 	if (skb_is_gso(skb))
 		features = gso_features_check(skb, dev, features);
@@ -3557,19 +3573,20 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 	 * features for the netdev
 	 */
 	if (skb->encapsulation)
-		features &= dev->hw_enc_features;
+		features = netdev_hw_enc_features_and(dev, features)
 
 	if (skb_vlan_tagged(skb))
-		features = netdev_intersect_features(features,
-						     dev->vlan_features |
-						     NETIF_F_HW_VLAN_CTAG_TX |
-						     NETIF_F_HW_VLAN_STAG_TX);
+		tmp = netdev_get_vlan_features(dev);
+
+		netdev_features_set_bits(NETIF_F_HW_VLAN_CTAG_TX |
+					 NETIF_F_HW_VLAN_STAG_TX, &tmp);
+		features = netdev_intersect_features(features, tmp);
 
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
@@ -3634,13 +3651,14 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
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
+	if (netdev_features_test_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM,
+				      features)) {
 		switch (skb->csum_offset) {
 		case offsetof(struct tcphdr, check):
 		case offsetof(struct udphdr, check):
@@ -9812,17 +9830,17 @@ static void net_set_todo(struct net_device *dev)
 static netdev_features_t netdev_sync_upper_features(struct net_device *lower,
 	struct net_device *upper, netdev_features_t features)
 {
-	netdev_features_t upper_disables = NETIF_F_UPPER_DISABLES;
-	netdev_features_t feature;
+	netdev_features_t upper_disables;
 	int feature_bit;
 
+	netdev_features_zero(upper_disables);
+	netdev_features_set_bits(NETIF_F_UPPER_DISABLES, upper_disables);
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
+			netdev_features_clear_bit(feature_bit, &features)
 		}
 	}
 
@@ -9833,20 +9851,21 @@ static void netdev_sync_lower_features(struct net_device *upper,
 	struct net_device *lower, netdev_features_t features)
 {
 	netdev_features_t upper_disables = NETIF_F_UPPER_DISABLES;
-	netdev_features_t feature;
 	int feature_bit;
 
+	netdev_features_zero(upper_disables);
+	netdev_features_set_bits(NETIF_F_UPPER_DISABLES, upper_disables);
 	for_each_netdev_feature(upper_disables, feature_bit) {
-		feature = __NETIF_F_BIT(feature_bit);
-		if (!(features & feature) && (lower->features & feature)) {
-			netdev_dbg(upper, "Disabling feature %pNF on lower dev %s.\n",
-				   &feature, lower->name);
-			lower->wanted_features &= ~feature;
+		if (!netdev_features_test_bit(feature_bit, features) &&
+		    netdev_active_features_test_bit(lower, feature_bit)) {
+			netdev_dbg(upper, "Disabling feature %d on lower dev %s.\n",
+				   feature_bit, lower->name);
+			netdev_wanted_features_clear_bit(lower, feature_bit);
 			__netdev_update_features(lower);
 
-			if (unlikely(lower->features & feature))
-				netdev_WARN(upper, "failed to disable %pNF on %s!\n",
-					    &feature, lower->name);
+			if (unlikely(netdev_active_features_test_bit(lower, feature_bit))
+				netdev_WARN(upper, "failed to disable %d on %s!\n",
+					    feature_bit, lower->name);
 			else
 				netdev_features_change(lower);
 		}
-- 
2.33.0

