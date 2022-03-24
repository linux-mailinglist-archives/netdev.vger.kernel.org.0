Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B514E665E
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 16:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351479AbiCXP5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 11:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351460AbiCXP4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 11:56:53 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EACAD11F
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 08:55:13 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KPVBS1VngzfZdh;
        Thu, 24 Mar 2022 23:53:36 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 23:55:10 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>,
        <lipeng321@huawei.com>
Subject: [RFCv5 PATCH net-next 20/20] net: redefine the prototype of netdev_features_t
Date:   Thu, 24 Mar 2022 23:49:32 +0800
Message-ID: <20220324154932.17557-21-shenjian15@huawei.com>
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

For the prototype of netdev_features_t is u64, and the number
of netdevice feature bits is 64 now. So there is no space to
introduce new feature bit. Change the prototype of netdev_features_t
from u64 to structure below:
	typedef struct {
		DECLARE_BITMAP(bits, NETDEV_FEATURE_COUNT);
	} netdev_features_t;

Rewrite the netdev_features helpers to adapt with new prototype.

To avoid mistake using NETIF_F_XXX as NETIF_F_XXX_BIT as
input macroes for above helpers, remove all the macroes
of NETIF_F_XXX for single feature bit.

With the prototype is no longer u64, the implementation of print
interface for netdev features(%pNF) is changed to bitmap. So
does the implementation of net/ethtool/.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 include/linux/netdev_features.h |  89 +---------------
 include/linux/netdevice.h       | 173 ++++++++++++++++++++------------
 lib/vsprintf.c                  |  11 +-
 net/core/dev.c                  |  30 +++---
 net/ethtool/features.c          |  67 ++++++-------
 net/ethtool/ioctl.c             |  31 +++---
 6 files changed, 176 insertions(+), 225 deletions(-)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index b25f2bb31f94..4126016c8d1d 100644
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
@@ -101,94 +99,15 @@ enum {
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
 
 extern netdev_features_t netdev_ethtool_features __ro_after_init;
 extern netdev_features_t netdev_never_change_features __ro_after_init;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 13f397c5960c..77d78a4bae9d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2297,24 +2297,24 @@ struct net_device {
 
 static inline void netdev_features_zero(netdev_features_t *dst)
 {
-	*dst = 0;
+	bitmap_zero(dst->bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void netdev_features_fill(netdev_features_t *dst)
 {
-	*dst = ~0ULL;
+	bitmap_fill(dst->bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline bool netdev_features_empty(const netdev_features_t src)
 {
-	return src == 0;
+	return bitmap_empty(src.bits, NETDEV_FEATURE_COUNT);
 }
 
 /* helpers for netdev features '==' operation */
 static inline bool netdev_features_equal(const netdev_features_t src1,
 					 const netdev_features_t src2)
 {
-	return src1 == src2;
+	return bitmap_equal(src1.bits, src2.bits, NETDEV_FEATURE_COUNT);
 }
 
 #define netdev_active_features_equal(ndev, features) \
@@ -2342,7 +2342,10 @@ static inline bool netdev_features_equal(const netdev_features_t src1,
 static inline netdev_features_t
 netdev_features_and(const netdev_features_t a, const netdev_features_t b)
 {
-	return a & b;
+	netdev_features_t dst;
+
+	bitmap_and(dst.bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
+	return dst;
 }
 
 #define netdev_active_features_and(ndev, features) \
@@ -2371,63 +2374,73 @@ static inline void
 netdev_features_direct_and(netdev_features_t *dst,
 			   const netdev_features_t features)
 {
-	*dst = netdev_features_and(*dst, features);
+	bitmap_and(dst->bits, dst->bits, features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_active_features_direct_and(struct net_device *ndev,
 				  const netdev_features_t features)
 {
-	ndev->active_features = netdev_active_features_and(ndev, features);
+	bitmap_and(ndev->active_features.bits, ndev->active_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_hw_features_direct_and(struct net_device *ndev,
 			      const netdev_features_t features)
 {
-	ndev->hw_features = netdev_hw_features_and(ndev, features);
+	bitmap_and(ndev->hw_features.bits, ndev->hw_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_wanted_features_direct_and(struct net_device *ndev,
 				  const netdev_features_t features)
 {
-	ndev->wanted_features = netdev_wanted_features_and(ndev, features);
+	bitmap_and(ndev->wanted_features.bits, ndev->wanted_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_vlan_features_direct_and(struct net_device *ndev,
 				const netdev_features_t features)
 {
-	ndev->vlan_features = netdev_vlan_features_and(ndev, features);
+	bitmap_and(ndev->vlan_features.bits, ndev->vlan_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_hw_enc_features_direct_and(struct net_device *ndev,
 				  const netdev_features_t features)
 {
-	ndev->hw_enc_features = netdev_hw_enc_features_and(ndev, features);
+	bitmap_and(ndev->hw_enc_features.bits, ndev->hw_enc_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_mpls_features_direct_and(struct net_device *ndev,
 				const netdev_features_t features)
 {
-	ndev->mpls_features = netdev_mpls_features_and(ndev, features);
+	bitmap_and(ndev->mpls_features.bits, ndev->mpls_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_gso_partial_features_direct_and(struct net_device *ndev,
 				       const netdev_features_t features)
 {
-	ndev->gso_partial_features = netdev_mpls_features_and(ndev, features);
+	bitmap_and(ndev->gso_partial_features.bits, ndev->gso_partial_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 /* helpers for netdev features '|' operation */
 static inline netdev_features_t
 netdev_features_or(const netdev_features_t a, const netdev_features_t b)
 {
-	return a | b;
+	netdev_features_t dst;
+
+	bitmap_or(dst.bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
+	return dst;
 }
 
 #define netdev_active_features_or(ndev, features) \
@@ -2456,63 +2469,73 @@ static inline void
 netdev_features_direct_or(netdev_features_t *dst,
 			  const netdev_features_t features)
 {
-	*dst = netdev_features_or(*dst, features);
+	bitmap_or(dst->bits, dst->bits, features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_active_features_direct_or(struct net_device *ndev,
 				 const netdev_features_t features)
 {
-	ndev->active_features = netdev_active_features_or(ndev, features);
+	bitmap_or(ndev->active_features.bits, ndev->active_features.bits,
+		  features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_hw_features_direct_or(struct net_device *ndev,
 			     const netdev_features_t features)
 {
-	ndev->hw_features = netdev_hw_features_or(ndev, features);
+	bitmap_or(ndev->hw_features.bits, ndev->hw_features.bits,
+		  features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_wanted_features_direct_or(struct net_device *ndev,
 				 const netdev_features_t features)
 {
-	ndev->wanted_features = netdev_wanted_features_or(ndev, features);
+	bitmap_or(ndev->wanted_features.bits, ndev->wanted_features.bits,
+		  features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_vlan_features_direct_or(struct net_device *ndev,
 			       const netdev_features_t features)
 {
-	ndev->vlan_features = netdev_vlan_features_or(ndev, features);
+	bitmap_or(ndev->vlan_features.bits, ndev->vlan_features.bits,
+		  features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_hw_enc_features_direct_or(struct net_device *ndev,
 				 const netdev_features_t features)
 {
-	ndev->hw_enc_features = netdev_hw_enc_features_or(ndev, features);
+	bitmap_or(ndev->hw_enc_features.bits, ndev->hw_enc_features.bits,
+		  features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_mpls_features_direct_or(struct net_device *ndev,
 			       const netdev_features_t features)
 {
-	ndev->mpls_features = netdev_mpls_features_or(ndev, features);
+	bitmap_or(ndev->mpls_features.bits, ndev->mpls_features.bits,
+		  features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_gso_partial_features_direct_or(struct net_device *ndev,
 				      const netdev_features_t features)
 {
-	ndev->gso_partial_features = netdev_mpls_features_or(ndev, features);
+	bitmap_or(ndev->gso_partial_features.bits, ndev->gso_partial_features.bits,
+		  features.bits, NETDEV_FEATURE_COUNT);
 }
 
 /* helpers for netdev features '^' operation */
 static inline netdev_features_t
 netdev_features_xor(const netdev_features_t a, const netdev_features_t b)
 {
-	return a ^ b;
+	netdev_features_t dst;
+
+	bitmap_xor(dst.bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
+	return dst;
 }
 
 #define netdev_active_features_xor(ndev, features) \
@@ -2541,57 +2564,66 @@ static inline void
 netdev_active_features_direct_xor(struct net_device *ndev,
 				  const netdev_features_t features)
 {
-	ndev->active_features = netdev_active_features_xor(ndev, features);
+	bitmap_xor(ndev->active_features.bits, ndev->active_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_hw_features_direct_xor(struct net_device *ndev,
 			      const netdev_features_t features)
 {
-	ndev->hw_features = netdev_hw_features_xor(ndev, features);
+	bitmap_xor(ndev->hw_features.bits, ndev->hw_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_wanted_features_direct_xor(struct net_device *ndev,
 				  const netdev_features_t features)
 {
-	ndev->wanted_features = netdev_wanted_features_xor(ndev, features);
+	bitmap_xor(ndev->wanted_features.bits, ndev->wanted_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_vlan_features_direct_xor(struct net_device *ndev,
 				const netdev_features_t features)
 {
-	ndev->vlan_features = netdev_vlan_features_xor(ndev, features);
+	bitmap_xor(ndev->vlan_features.bits, ndev->vlan_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_hw_enc_features_direct_xor(struct net_device *ndev,
 				  const netdev_features_t features)
 {
-	ndev->hw_enc_features = netdev_hw_enc_features_xor(ndev, features);
+	bitmap_xor(ndev->hw_enc_features.bits, ndev->hw_enc_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_mpls_features_direct_xor(struct net_device *ndev,
 				const netdev_features_t features)
 {
-	ndev->mpls_features = netdev_mpls_features_xor(ndev, features);
+	bitmap_xor(ndev->mpls_features.bits, ndev->mpls_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_gso_partial_features_direct_xor(struct net_device *ndev,
 				       const netdev_features_t features)
 {
-	ndev->gso_partial_features =
-			netdev_gso_partial_features_xor(ndev, features);
+	bitmap_xor(ndev->gso_partial_features.bits, ndev->gso_partial_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 /* helpers for netdev features '& ~' operation */
 static inline netdev_features_t
 netdev_features_andnot(const netdev_features_t a, const netdev_features_t b)
 {
-	return a & ~b;
+	netdev_features_t dst;
+
+	bitmap_andnot(dst.bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
+	return dst;
 }
 
 #define netdev_active_features_andnot(ndev, features) \
@@ -2640,63 +2672,69 @@ static inline void
 netdev_features_direct_andnot(netdev_features_t *dst,
 			     const netdev_features_t features)
 {
-	*dst = netdev_features_andnot(*dst, features);
+	bitmap_andnot(dst->bits, dst->bits, features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_active_features_direct_andnot(struct net_device *ndev,
 			     const netdev_features_t features)
 {
-	ndev->active_features = netdev_active_features_andnot(ndev, features);
+	bitmap_andnot(ndev->active_features.bits, ndev->active_features.bits,
+		      features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_hw_features_direct_andnot(struct net_device *ndev,
 			 const netdev_features_t features)
 {
-	ndev->hw_features = netdev_hw_features_andnot(ndev, features);
+	bitmap_andnot(ndev->hw_features.bits, ndev->hw_features.bits,
+		      features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_wanted_features_direct_andnot(struct net_device *ndev,
 			     const netdev_features_t features)
 {
-	ndev->wanted_features = netdev_wanted_features_andnot(ndev, features);
+	bitmap_andnot(ndev->wanted_features.bits, ndev->wanted_features.bits,
+		      features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_vlan_features_direct_andnot(struct net_device *ndev,
 			   const netdev_features_t features)
 {
-	ndev->vlan_features = netdev_vlan_features_andnot(ndev, features);
+	bitmap_andnot(ndev->vlan_features.bits, ndev->vlan_features.bits,
+		      features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_hw_enc_features_direct_andnot(struct net_device *ndev,
 			     const netdev_features_t features)
 {
-	ndev->hw_enc_features = netdev_hw_enc_features_andnot(ndev, features);
+	bitmap_andnot(ndev->hw_enc_features.bits, ndev->hw_enc_features.bits,
+		      features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_mpls_features_direct_andnot(struct net_device *ndev,
 			   const netdev_features_t features)
 {
-	ndev->mpls_features = netdev_mpls_features_andnot(ndev, features);
+	bitmap_andnot(ndev->mpls_features.bits, ndev->mpls_features.bits,
+		      features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_gso_partial_features_direct_andnot(struct net_device *ndev,
 				  const netdev_features_t features)
 {
-	ndev->gso_partial_features =
-		netdev_gso_partial_features_andnot(ndev, features);
+	bitmap_andnot(ndev->gso_partial_features.bits, ndev->gso_partial_features.bits,
+		      features.bits, NETDEV_FEATURE_COUNT);
 }
 
 /* helpers for netdev features 'set bit' operation */
 static inline void netdev_features_set_bit(int nr, netdev_features_t *src)
 {
-	*src |= __NETIF_F_BIT(nr);
+	__set_bit(nr, src->bits);
 }
 
 #define netdev_active_features_set_bit(ndev, nr) \
@@ -2754,7 +2792,7 @@ static inline void netdev_features_set_array(const int *array, int array_size,
 /* helpers for netdev features 'clear bit' operation */
 static inline void netdev_features_clear_bit(int nr, netdev_features_t *src)
 {
-	*src &= ~__NETIF_F_BIT(nr);
+	__clear_bit(nr, src->bits);
 }
 
 #define netdev_active_features_clear_bit(ndev, nr) \
@@ -2781,7 +2819,7 @@ static inline void netdev_features_clear_bit(int nr, netdev_features_t *src)
 /* helpers for netdev features 'test bit' operation */
 static inline bool netdev_features_test_bit(int nr, const netdev_features_t src)
 {
-	return (src & __NETIF_F_BIT(nr)) > 0;
+	return test_bit(nr, src.bits);
 }
 
 #define netdev_active_features_test_bit(ndev, nr) \
@@ -2808,7 +2846,7 @@ static inline bool netdev_features_test_bit(int nr, const netdev_features_t src)
 static inline bool netdev_features_intersects(const netdev_features_t src1,
 					      const netdev_features_t src2)
 {
-	return (src1 & src2) > 0;
+	return bitmap_intersects(src1.bits, src2.bits, NETDEV_FEATURE_COUNT);
 }
 
 #define netdev_active_features_intersects(ndev, features) \
@@ -2889,7 +2927,7 @@ static inline void netdev_set_gso_partial_features(struct net_device *ndev,
 static inline bool netdev_features_subset(const netdev_features_t src1,
 					  const netdev_features_t src2)
 {
-	return (src1 & src2) == src2;
+	return bitmap_subset(src1.bits, src2.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline bool netif_elide_gro(const struct net_device *dev)
@@ -5464,28 +5502,31 @@ netdev_features_t netif_skb_features(struct sk_buff *skb);
 
 static inline bool net_gso_ok(netdev_features_t features, int gso_type)
 {
-	netdev_features_t feature = (netdev_features_t)gso_type << NETIF_F_GSO_SHIFT;
+#define GSO_INDEX(x)	((1ULL << (x)) >> NETIF_F_GSO_SHIFT)
+	netdev_features_t feature;
+
+	bitmap_from_u64(feature.bits, (u64)gso_type << NETIF_F_GSO_SHIFT));
 
 	/* check flags correspondence */
-	BUILD_BUG_ON(SKB_GSO_TCPV4   != (NETIF_F_TSO >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_DODGY   != (NETIF_F_GSO_ROBUST >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_TCP_ECN != (NETIF_F_TSO_ECN >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_TCP_FIXEDID != (NETIF_F_TSO_MANGLEID >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_TCPV6   != (NETIF_F_TSO6 >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_FCOE    != (NETIF_F_FSO >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_GRE     != (NETIF_F_GSO_GRE >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_GRE_CSUM != (NETIF_F_GSO_GRE_CSUM >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_IPXIP4  != (NETIF_F_GSO_IPXIP4 >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_IPXIP6  != (NETIF_F_GSO_IPXIP6 >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_UDP_TUNNEL != (NETIF_F_GSO_UDP_TUNNEL >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_UDP_TUNNEL_CSUM != (NETIF_F_GSO_UDP_TUNNEL_CSUM >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_PARTIAL != (NETIF_F_GSO_PARTIAL >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_TUNNEL_REMCSUM != (NETIF_F_GSO_TUNNEL_REMCSUM >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_SCTP    != (NETIF_F_GSO_SCTP >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_ESP != (NETIF_F_GSO_ESP >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_UDP != (NETIF_F_GSO_UDP >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_UDP_L4 != (NETIF_F_GSO_UDP_L4 >> NETIF_F_GSO_SHIFT));
-	BUILD_BUG_ON(SKB_GSO_FRAGLIST != (NETIF_F_GSO_FRAGLIST >> NETIF_F_GSO_SHIFT));
+	BUILD_BUG_ON(SKB_GSO_TCPV4   != GSO_INDEX(NETIF_F_TSO_BIT));
+	BUILD_BUG_ON(SKB_GSO_DODGY   != GSO_INDEX(NETIF_F_GSO_ROBUST_BIT));
+	BUILD_BUG_ON(SKB_GSO_TCP_ECN != GSO_INDEX(NETIF_F_TSO_ECN_BIT));
+	BUILD_BUG_ON(SKB_GSO_TCP_FIXEDID != GSO_INDEX(NETIF_F_TSO_MANGLEID_BIT));
+	BUILD_BUG_ON(SKB_GSO_TCPV6   != GSO_INDEX(NETIF_F_TSO6_BIT));
+	BUILD_BUG_ON(SKB_GSO_FCOE    != GSO_INDEX(NETIF_F_FSO_BIT));
+	BUILD_BUG_ON(SKB_GSO_GRE     != GSO_INDEX(NETIF_F_GSO_GRE_BIT));
+	BUILD_BUG_ON(SKB_GSO_GRE_CSUM != GSO_INDEX(NETIF_F_GSO_GRE_CSUM_BIT));
+	BUILD_BUG_ON(SKB_GSO_IPXIP4  != GSO_INDEX(NETIF_F_GSO_IPXIP4_BIT));
+	BUILD_BUG_ON(SKB_GSO_IPXIP6  != GSO_INDEX(NETIF_F_GSO_IPXIP6_BIT));
+	BUILD_BUG_ON(SKB_GSO_UDP_TUNNEL != GSO_INDEX(NETIF_F_GSO_UDP_TUNNEL_BIT));
+	BUILD_BUG_ON(SKB_GSO_UDP_TUNNEL_CSUM != GSO_INDEX(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT));
+	BUILD_BUG_ON(SKB_GSO_PARTIAL != GSO_INDEX(NETIF_F_GSO_PARTIAL_BIT));
+	BUILD_BUG_ON(SKB_GSO_TUNNEL_REMCSUM != GSO_INDEX(NETIF_F_GSO_TUNNEL_REMCSUM_BIT));
+	BUILD_BUG_ON(SKB_GSO_SCTP    != GSO_INDEX(NETIF_F_GSO_SCTP_BIT));
+	BUILD_BUG_ON(SKB_GSO_ESP != GSO_INDEX(NETIF_F_GSO_ESP_BIT));
+	BUILD_BUG_ON(SKB_GSO_UDP != GSO_INDEX(NETIF_F_GSO_UDP_BIT));
+	BUILD_BUG_ON(SKB_GSO_UDP_L4 != GSO_INDEX(NETIF_F_GSO_UDP_L4_BIT));
+	BUILD_BUG_ON(SKB_GSO_FRAGLIST != GSO_INDEX(NETIF_F_GSO_FRAGLIST_BIT));
 
 	return netdev_features_subset(features, features);
 }
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 3b8129dd374c..be018453fae5 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1733,25 +1733,24 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
 }
 
 static noinline_for_stack
-char *netdev_bits(char *buf, char *end, const void *addr,
+char *netdev_bits(char *buf, char *end, void *addr,
 		  struct printf_spec spec,  const char *fmt)
 {
-	unsigned long long num;
-	int size;
+	unsigned long *bitmap;
 
 	if (check_pointer(&buf, end, addr, spec))
 		return buf;
 
 	switch (fmt[1]) {
 	case 'F':
-		num = *(const netdev_features_t *)addr;
-		size = sizeof(netdev_features_t);
+		bitmap = *(netdev_features_t *)addr->bits;
+		spec->field_width = NETDEV_FEATURE_COUNT;
 		break;
 	default:
 		return error_string(buf, end, "(%pN?)", spec);
 	}
 
-	return special_hex_number(buf, end, num, size);
+	return bitmap_string(buf, end, add->bits, spec, fmt);
 }
 
 static noinline_for_stack
diff --git a/net/core/dev.c b/net/core/dev.c
index c7f95ff8cf10..c98464c11d75 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9433,17 +9433,15 @@ static netdev_features_t netdev_sync_upper_features(struct net_device *lower,
 	struct net_device *upper, netdev_features_t features)
 {
 	netdev_features_t upper_disables;
-	netdev_features_t feature;
 	int feature_bit;
 
 	upper_disables = NETIF_F_UPPER_DISABLES;
 	for_each_netdev_feature(upper_disables, feature_bit) {
-		feature = __NETIF_F_BIT(feature_bit);
-		if (!netdev_wanted_features_intersects(upper, feature) &&
-		    netdev_features_intersects(features, feature)) {
-			netdev_dbg(lower, "Dropping feature %pNF, upper dev %s has it off.\n",
-				   &feature, upper->name);
-			netdev_features_direct_andnot(&features, feature);
+		if (!netdev_wanted_features_test_bit(upper, feature_bit) &&
+		    netdev_features_test_bit(features)) {
+			netdev_dbg(lower, "Dropping feature bit %d, upper dev %s has it off.\n",
+				   feature_bit, upper->name);
+			netdev_features_clear_bit(feature_bit, &features);
 		}
 	}
 
@@ -9454,22 +9452,20 @@ static void netdev_sync_lower_features(struct net_device *upper,
 	struct net_device *lower, netdev_features_t features)
 {
 	netdev_features_t upper_disables;
-	netdev_features_t feature;
 	int feature_bit;
 
 	upper_disables = NETIF_F_UPPER_DISABLES;
 	for_each_netdev_feature(upper_disables, feature_bit) {
-		feature = __NETIF_F_BIT(feature_bit);
-		if (!netdev_features_intersects(features, feature) &&
-		    netdev_active_features_intersects(lower, feature)) {
-			netdev_dbg(upper, "Disabling feature %pNF on lower dev %s.\n",
-				   &feature, lower->name);
-			netdev_wanted_features_direct_andnot(lower, feature);
+		if (!netdev_features_test_bit(feature_bit, features) &&
+		    netdev_active_features_test_bit(lower, feature_bit)) {
+			netdev_dbg(upper, "Disabling feature bit %d on lower dev %s.\n",
+				   feature_bit, lower->name);
+			netdev_wanted_features_clear_bit(lower, feature_bit);
 			__netdev_update_features(lower);
 
-			if (unlikely(netdev_active_features_intersects(lower, feature)))
-				netdev_WARN(upper, "failed to disable %pNF on %s!\n",
-					    &feature, lower->name);
+			if (unlikely(netdev_active_features_test_bit(lower, feature_bit)))
+				netdev_WARN(upper, "failed to disable feature bit %d on %s!\n",
+					    feature_bit, lower->name);
 			else
 				netdev_features_change(lower);
 		}
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 01dd727299ed..d4ee659b1420 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -27,10 +27,7 @@ const struct nla_policy ethnl_features_get_policy[] = {
 
 static void ethnl_features_to_bitmap32(u32 *dest, netdev_features_t src)
 {
-	unsigned int i;
-
-	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; i++)
-		dest[i] = src >> (32 * i);
+	bitmap_to_arr32(dest, src.bits, ETHTOOL_DEV_FEATURE_WORDS);
 }
 
 static int features_prepare_data(const struct ethnl_req_info *req_base,
@@ -45,7 +42,7 @@ static int features_prepare_data(const struct ethnl_req_info *req_base,
 	ethnl_features_to_bitmap32(data->wanted, netdev_wanted_features(dev));
 	ethnl_features_to_bitmap32(data->active, netdev_active_features(dev));
 	ethnl_features_to_bitmap32(data->nochange, NETIF_F_NEVER_CHANGE);
-	all_features = GENMASK_ULL(NETDEV_FEATURE_COUNT - 1, 0);
+	netdev_features_fill(&all_features);
 	ethnl_features_to_bitmap32(data->all, all_features);
 
 	return 0;
@@ -137,21 +134,18 @@ static void ethnl_features_to_bitmap(unsigned long *dest, netdev_features_t val)
 	unsigned int i;
 
 	for (i = 0; i < words; i++)
-		dest[i] = (unsigned long)(val >> (i * BITS_PER_LONG));
+		dest[i] = val.bits[i];
 }
 
 static netdev_features_t ethnl_bitmap_to_features(unsigned long *src)
 {
-	const unsigned int nft_bits = sizeof(netdev_features_t) * BITS_PER_BYTE;
 	const unsigned int words = BITS_TO_LONGS(NETDEV_FEATURE_COUNT);
 	netdev_features_t ret;
 	unsigned int i;
 
-	netdev_features_zero(&ret);
 	for (i = 0; i < words; i++)
-		netdev_features_direct_or(&ret,
-					  (netdev_features_t)(src[i]) << (i * BITS_PER_LONG));
-	ret &= ~(netdev_features_t)0 >> (nft_bits - NETDEV_FEATURE_COUNT);
+		ret.bits[i] = dest[i];
+
 	return ret;
 }
 
@@ -211,18 +205,17 @@ static int features_send_reply(struct net_device *dev, struct genl_info *info,
 
 int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 {
-	DECLARE_BITMAP(wanted_diff_mask, NETDEV_FEATURE_COUNT);
-	DECLARE_BITMAP(active_diff_mask, NETDEV_FEATURE_COUNT);
-	DECLARE_BITMAP(old_active, NETDEV_FEATURE_COUNT);
-	DECLARE_BITMAP(old_wanted, NETDEV_FEATURE_COUNT);
-	DECLARE_BITMAP(new_active, NETDEV_FEATURE_COUNT);
-	DECLARE_BITMAP(new_wanted, NETDEV_FEATURE_COUNT);
-	DECLARE_BITMAP(req_wanted, NETDEV_FEATURE_COUNT);
-	DECLARE_BITMAP(req_mask, NETDEV_FEATURE_COUNT);
 	struct ethnl_req_info req_info = {};
 	struct nlattr **tb = info->attrs;
+	netdev_features_t wanted_diff_mask;
+	netdev_features_t active_diff_mask;
+	netdev_features_t old_active;
+	netdev_features_t old_wanted;
+	netdev_features_t new_active;
+	netdev_features_t new_wanted;
+	netdev_features_t req_wanted;
+	netdev_features_t req_mask;
 	struct net_device *dev;
-	netdev_features_t tmp;
 	bool mod;
 	int ret;
 
@@ -237,28 +230,29 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	dev = req_info.dev;
 
 	rtnl_lock();
-	ethnl_features_to_bitmap(old_active, netdev_active_features(dev));
-	ethnl_features_to_bitmap(old_wanted, netdev_wanted_features(dev));
+	old_active = netdev_active_features(dev);
+	old_wanted = netdev_wanted_features(dev);
 	ret = ethnl_parse_bitset(req_wanted, req_mask, NETDEV_FEATURE_COUNT,
 				 tb[ETHTOOL_A_FEATURES_WANTED],
 				 netdev_features_strings, info->extack);
 	if (ret < 0)
 		goto out_rtnl;
-	if (ethnl_bitmap_to_features(req_mask) & ~NETIF_F_ETHTOOL_BITS) {
+	if (!netdev_features_subset(NETIF_F_ETHTOOL_BITS, req_mask)) {
 		GENL_SET_ERR_MSG(info, "attempt to change non-ethtool features");
 		ret = -EINVAL;
 		goto out_rtnl;
 	}
 
 	/* set req_wanted bits not in req_mask from old_wanted */
-	bitmap_and(req_wanted, req_wanted, req_mask, NETDEV_FEATURE_COUNT);
-	bitmap_andnot(new_wanted, old_wanted, req_mask, NETDEV_FEATURE_COUNT);
-	bitmap_or(req_wanted, new_wanted, req_wanted, NETDEV_FEATURE_COUNT);
-	if (!bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
+	netdev_features_direct_and(&req_wanted, req_mask);
+	new_wanted = netdev_features_andnot(old_wanted, req_mask);
+	netdev_features_direct_or(&req_wanted, new_wanted);
+	if (!netdev_features_equal(req_wanted, old_wanted)) {
+		netdev_features_t tmp;
+
 		netdev_wanted_features_direct_andnot(dev,
 						     netdev_hw_features(dev));
-		tmp = netdev_hw_features_and(dev,
-					     ethnl_bitmap_to_features(req_wanted));
+		tmp = netdev_hw_features_and(dev, ethnl_bitmap_to_features(req_wanted)););
 		netdev_wanted_features_direct_or(dev, tmp);
 		__netdev_update_features(dev);
 	}
@@ -269,16 +263,11 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	if (!(req_info.flags & ETHTOOL_FLAG_OMIT_REPLY)) {
 		bool compact = req_info.flags & ETHTOOL_FLAG_COMPACT_BITSETS;
 
-		bitmap_xor(wanted_diff_mask, req_wanted, new_active,
-			   NETDEV_FEATURE_COUNT);
-		bitmap_xor(active_diff_mask, old_active, new_active,
-			   NETDEV_FEATURE_COUNT);
-		bitmap_and(wanted_diff_mask, wanted_diff_mask, req_mask,
-			   NETDEV_FEATURE_COUNT);
-		bitmap_and(req_wanted, req_wanted, wanted_diff_mask,
-			   NETDEV_FEATURE_COUNT);
-		bitmap_and(new_active, new_active, active_diff_mask,
-			   NETDEV_FEATURE_COUNT);
+		wanted_diff_mask = netdev_features_xor(req_wanted, new_active);
+		active_diff_mask = netdev_features_xor(old_active, new_active);
+		netdev_features_direct_and(&wanted_diff_mask, req_mask);
+		netdev_features_direct_and(&req_wanted, wanted_diff_mask);
+		netdev_features_direct_and(&new_active, active_diff_mask);
 
 		ret = features_send_reply(dev, info, req_wanted,
 					  wanted_diff_mask, new_active,
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 90fb4c2a313d..460a5c12a13e 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -88,6 +88,10 @@ static int ethtool_get_features(struct net_device *dev, void __user *useraddr)
 		.size = ETHTOOL_DEV_FEATURE_WORDS,
 	};
 	struct ethtool_get_features_block features[ETHTOOL_DEV_FEATURE_WORDS];
+	u32 never_changed_arr[ETHTOOL_DEV_FEATURE_WORDS];
+	u32 wanted_arr[ETHTOOL_DEV_FEATURE_WORDS];
+	u32 active_arr[ETHTOOL_DEV_FEATURE_WORDS];
+	u32 hw_arr[ETHTOOL_DEV_FEATURE_WORDS];
 	u32 __user *sizeaddr;
 	u32 copy_size;
 	int i;
@@ -95,12 +99,15 @@ static int ethtool_get_features(struct net_device *dev, void __user *useraddr)
 	/* in case feature bits run out again */
 	BUILD_BUG_ON(ETHTOOL_DEV_FEATURE_WORDS * sizeof(u32) > sizeof(netdev_features_t));
 
+	bitmap_to_arr32(hw_arr, netdev_hw_features(dev), NETDEV_FEATURE_COUNT);
+	bitmap_to_arr32(wanted_arr, netdev_wanted_features(dev), NETDEV_FEATURE_COUNT);
+	bitmap_to_arr32(active_arr, netdev_active_features(dev), NETDEV_FEATURE_COUNT);
+	bitmap_to_arr32(never_changed_arr, NETIF_F_NEVER_CHANGE, NETDEV_FEATURE_COUNT);
 	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; ++i) {
-		features[i].available = (u32)(netdev_hw_features(dev) >> (32 * i));
-		features[i].requested = (u32)(netdev_wanted_features(dev) >> (32 * i));
-		features[i].active = (u32)(netdev_active_features(dev) >> (32 * i));
-		features[i].never_changed =
-			(u32)(NETIF_F_NEVER_CHANGE >> (32 * i));
+		features[i].available = hw_arr[i];
+		features[i].requested = wanted_arr[i];
+		features[i].active = active_arr[i];
+		features[i].never_changed = never_changed_arr[i];
 	}
 
 	sizeaddr = useraddr + offsetof(struct ethtool_gfeatures, size);
@@ -124,6 +131,8 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_sfeatures cmd;
 	struct ethtool_set_features_block features[ETHTOOL_DEV_FEATURE_WORDS];
+	u32 wanted_arr[ETHTOOL_DEV_FEATURE_WORDS];
+	u32 valid_arr[ETHTOOL_DEV_FEATURE_WORDS];
 	netdev_features_t wanted;
 	netdev_features_t valid;
 	netdev_features_t tmp;
@@ -139,14 +148,12 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 	if (copy_from_user(features, useraddr, sizeof(features)))
 		return -EFAULT;
 
-	netdev_features_zero(&wanted);
-	netdev_features_zero(&valid);
 	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; ++i) {
-		netdev_features_direct_or(&valid,
-					  (netdev_features_t)features[i].valid << (32 * i));
-		netdev_features_direct_or(&wanted,
-					  (netdev_features_t)features[i].requested << (32 * i));
+		valid_arr[i] = features[i].valid;
+		wanted_arr[i] = features[i].requested;
 	}
+	bitmap_from_arr32(valid.bits, valid_arr, NETDEV_FEATURE_COUNT);
+	bitmap_from_arr32(wanted.bits, wanted_arr, NETDEV_FEATURE_COUNT);
 
 	tmp = netdev_features_andnot(valid, NETIF_F_ETHTOOL_BITS);
 	if (tmp)
@@ -370,7 +377,7 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 	changed = netdev_active_features_xor(dev, features);
 	netdev_features_direct_and(&changed, eth_all_features);
 	tmp = netdev_hw_features_andnot_r(dev, changed);
-	if (tmp)
+	if (!netdev_features_empty(tmp))
 		return netdev_hw_features_intersects(dev, changed) ? -EINVAL : -EOPNOTSUPP;
 
 	netdev_wanted_features_direct_andnot(dev, changed);
-- 
2.33.0

