Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11ED58E55F
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbiHJDPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiHJDN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:57 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381C082F94
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:52 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4M2ZhK2JKHzlVxx;
        Wed, 10 Aug 2022 11:10:57 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 11:13:50 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv7 PATCH net-next 36/36] net: redefine the prototype of netdev_features_t
Date:   Wed, 10 Aug 2022 11:06:24 +0800
Message-ID: <20220810030624.34711-37-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220810030624.34711-1-shenjian15@huawei.com>
References: <20220810030624.34711-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
of NETIF_F_XXX for single feature bit. Serveal macroes remained
temporarily, by some precompile dependency.

With the prototype is no longer u64, the implementation of print
interface for netdev features(%pNF) is changed to bitmap. So
does the implementation of net/ethtool/.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  12 +-
 .../net/ethernet/intel/i40e/i40e_debugfs.c    |  12 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   |   4 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   |   4 +-
 include/linux/netdev_features.h               | 101 ++----------
 include/linux/netdev_features_helper.h        | 149 +++++++++++-------
 include/linux/netdevice.h                     |   7 +-
 include/linux/skbuff.h                        |   4 +-
 include/net/ip_tunnels.h                      |   2 +-
 lib/vsprintf.c                                |  11 +-
 net/ethtool/features.c                        |  96 ++++-------
 net/ethtool/ioctl.c                           |  46 ++++--
 net/mac80211/main.c                           |   3 +-
 13 files changed, 201 insertions(+), 250 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 8386aac68c93..97e74c8aafe2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3936,10 +3936,14 @@ static void ena_update_hints(struct ena_adapter *adapter,
 static void ena_update_host_info(struct ena_admin_host_info *host_info,
 				 struct net_device *netdev)
 {
-	host_info->supported_network_features[0] =
-		netdev->features & GENMASK_ULL(31, 0);
-	host_info->supported_network_features[1] =
-		(netdev->features & GENMASK_ULL(63, 32)) >> 32;
+#define DEV_FEATURE_WORDS	DIV_ROUND_UP(NETDEV_FEATURE_COUNT, 32)
+
+	u32 features[DEV_FEATURE_WORDS] = {0};
+
+	bitmap_to_arr32(features, netdev->features.bits, DEV_FEATURE_WORDS);
+
+	host_info->supported_network_features[0] = features[0];
+	host_info->supported_network_features[1] = features[1];
 }
 
 static void ena_timer_service(struct timer_list *t)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index c9dcd6d92c83..046882ab5593 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -131,12 +131,12 @@ static void i40e_dbg_dump_vsi_seid(struct i40e_pf *pf, int seid)
 
 		dev_info(&pf->pdev->dev, "    netdev: name = %s, state = %lu, flags = 0x%08x\n",
 			 nd->name, nd->state, nd->flags);
-		dev_info(&pf->pdev->dev, "        features      = 0x%08lx\n",
-			 (unsigned long int)nd->features);
-		dev_info(&pf->pdev->dev, "        hw_features   = 0x%08lx\n",
-			 (unsigned long int)nd->hw_features);
-		dev_info(&pf->pdev->dev, "        vlan_features = 0x%08lx\n",
-			 (unsigned long int)nd->vlan_features);
+		dev_info(&pf->pdev->dev, "        features      = %pNF\n",
+			 &nd->features);
+		dev_info(&pf->pdev->dev, "        hw_features   = %pNF\n",
+			 &nd->hw_features);
+		dev_info(&pf->pdev->dev, "        vlan_features = %pNF\n",
+			 &nd->vlan_features);
 	}
 	dev_info(&pf->pdev->dev,
 		 "    flags = 0x%08lx, netdev_registered = %i, current_netdev_flags = 0x%04x\n",
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index bcd8513b3b43..9bcd420b0f36 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1736,8 +1736,8 @@ static int nfp_net_set_features(struct net_device *netdev,
 	if (err)
 		return err;
 
-	nn_dbg(nn, "Feature change 0x%llx -> 0x%llx (changed=0x%llx)\n",
-	       netdev->features, features, changed);
+	nn_dbg(nn, "Feature change %pNF -> %pNF (changed=%pNF)\n",
+	       &netdev->features, &features, &changed);
 
 	if (new_ctrl == nn->dp.ctrl)
 		return 0;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 75273f473caa..653c64091121 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1564,8 +1564,8 @@ static int ionic_set_features(struct net_device *netdev,
 	struct ionic_lif *lif = netdev_priv(netdev);
 	int err;
 
-	netdev_dbg(netdev, "%s: lif->features=0x%08llx new_features=0x%08llx\n",
-		   __func__, (u64)lif->netdev->features, (u64)features);
+	netdev_dbg(netdev, "%s: lif->features=%pNF new_features=%pNF\n",
+		   __func__, &lif->netdev->features, &features);
 
 	err = ionic_set_nic_features(lif, features);
 
diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index a005c781fabf..8836c957f365 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -10,8 +10,6 @@
 #include <linux/cache.h>
 #include <asm/byteorder.h>
 
-typedef u64 netdev_features_t;
-
 struct netdev_feature_set {
 	unsigned int cnt;
 	unsigned short feature_bits[];
@@ -113,6 +111,10 @@ enum {
 	/**/NETDEV_FEATURE_COUNT
 };
 
+typedef struct {
+	DECLARE_BITMAP(bits, NETDEV_FEATURE_COUNT);
+} netdev_features_t;
+
 extern netdev_features_t netdev_ethtool_features __ro_after_init;
 extern netdev_features_t netdev_never_change_features __ro_after_init;
 extern netdev_features_t netdev_gso_features_mask __ro_after_init;
@@ -171,94 +173,16 @@ extern const struct netdev_feature_set netif_f_xfrm_feature_set;
 extern const struct netdev_feature_set netif_f_tls_feature_set;
 extern const struct netdev_feature_set netvsc_supported_hw_feature_set;
 
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
-/* Finds the next feature with the highest number of the range of start-1 till 0.
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
+#define NETIF_F_HW_VLAN_CTAG_TX
+#define NETIF_F_IPV6_CSUM
+#define NETIF_F_TSO
+#define NETIF_F_GSO
 
 /* This goes for the MSB to the LSB through the set feature bits,
  * mask_addr should be a u64 and bit an int
  */
 #define for_each_netdev_feature(mask_addr, bit)				\
-	for ((bit) = find_next_netdev_feature((mask_addr),		\
-					      NETDEV_FEATURE_COUNT);	\
-	     (bit) >= 0;						\
-	     (bit) = find_next_netdev_feature((mask_addr), (bit)))
+	for_each_set_bit(bit, (unsigned long *)(mask_addr.bits), NETDEV_FEATURE_COUNT)
 
 /* Features valid for ethtool to change */
 /* = all defined minus driver/device-class-related */
@@ -311,4 +235,11 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 
 #define NETIF_F_GSO_ENCAP_ALL	netdev_gso_encap_all_features
 
+#define GSO_ENCAP_FEATURES	(((u64)1 << NETIF_F_GSO_GRE_BIT) |		\
+				 ((u64)1 << NETIF_F_GSO_GRE_CSUM_BIT) |		\
+				 ((u64)1 << NETIF_F_GSO_IPXIP4_BIT) |		\
+				 ((u64)1 << NETIF_F_GSO_IPXIP6_BIT) |		\
+				 (((u64)1 << NETIF_F_GSO_UDP_TUNNEL_BIT) |	\
+				  ((u64)1 << NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT)))
+
 #endif	/* _LINUX_NETDEV_FEATURES_H */
diff --git a/include/linux/netdev_features_helper.h b/include/linux/netdev_features_helper.h
index 476d36352160..479d120bd8bd 100644
--- a/include/linux/netdev_features_helper.h
+++ b/include/linux/netdev_features_helper.h
@@ -9,7 +9,7 @@
 
 static inline void netdev_features_zero(netdev_features_t *dst)
 {
-	*dst = 0;
+	bitmap_zero(dst->bits, NETDEV_FEATURE_COUNT);
 }
 
 /* active_feature prefer to netdev->features */
@@ -36,12 +36,12 @@ static inline void netdev_features_zero(netdev_features_t *dst)
 
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
 
 #define netdev_active_features_empty(ndev) \
@@ -69,7 +69,7 @@ static inline bool netdev_features_empty(const netdev_features_t src)
 static inline bool netdev_features_equal(const netdev_features_t src1,
 					 const netdev_features_t src2)
 {
-	return src1 == src2;
+	return bitmap_equal(src1.bits, src2.bits, NETDEV_FEATURE_COUNT);
 }
 
 #define netdev_active_features_equal(ndev, __features) \
@@ -97,7 +97,10 @@ static inline bool netdev_features_equal(const netdev_features_t src1,
 static inline netdev_features_t
 netdev_features_and(const netdev_features_t a, const netdev_features_t b)
 {
-	return a & b;
+	netdev_features_t dst;
+
+	bitmap_and(dst.bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
+	return dst;
 }
 
 #define netdev_active_features_and(ndev, __features) \
@@ -126,63 +129,74 @@ static inline void
 netdev_features_mask(netdev_features_t *dst,
 			   const netdev_features_t features)
 {
-	*dst = netdev_features_and(*dst, features);
+	bitmap_and(dst->bits, dst->bits, features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_active_features_mask(struct net_device *ndev,
 			    const netdev_features_t features)
 {
-	ndev->features = netdev_active_features_and(ndev, features);
+	bitmap_and(ndev->features.bits, ndev->features.bits, features.bits,
+		   NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_hw_features_mask(struct net_device *ndev,
 			const netdev_features_t features)
 {
-	ndev->hw_features = netdev_hw_features_and(ndev, features);
+	bitmap_and(ndev->hw_features.bits, ndev->hw_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_wanted_features_mask(struct net_device *ndev,
 			    const netdev_features_t features)
 {
-	ndev->wanted_features = netdev_wanted_features_and(ndev, features);
+	bitmap_and(ndev->wanted_features.bits, ndev->wanted_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_vlan_features_mask(struct net_device *ndev,
 			  const netdev_features_t features)
 {
-	ndev->vlan_features = netdev_vlan_features_and(ndev, features);
+	bitmap_and(ndev->vlan_features.bits, ndev->vlan_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_hw_enc_features_mask(struct net_device *ndev,
 			    const netdev_features_t features)
 {
-	ndev->hw_enc_features = netdev_hw_enc_features_and(ndev, features);
+	bitmap_and(ndev->hw_enc_features.bits, ndev->hw_enc_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_mpls_features_mask(struct net_device *ndev,
 			  const netdev_features_t features)
 {
-	ndev->mpls_features = netdev_mpls_features_and(ndev, features);
+	bitmap_and(ndev->mpls_features.bits, ndev->mpls_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_gso_partial_features_mask(struct net_device *ndev,
 				 const netdev_features_t features)
 {
-	ndev->gso_partial_features = netdev_mpls_features_and(ndev, features);
+	bitmap_and(ndev->gso_partial_features.bits,
+		   ndev->gso_partial_features.bits, features.bits,
+		   NETDEV_FEATURE_COUNT);
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
 
 #define netdev_active_features_or(ndev, __features) \
@@ -210,64 +224,69 @@ netdev_features_or(const netdev_features_t a, const netdev_features_t b)
 static inline void
 netdev_features_set(netdev_features_t *dst, const netdev_features_t features)
 {
-	*dst = netdev_features_or(*dst, features);
+	bitmap_or(dst->bits, dst->bits, features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_active_features_set(struct net_device *ndev,
 			   const netdev_features_t features)
 {
-	ndev->features = netdev_active_features_or(ndev, features);
+	bitmap_or(ndev->features.bits, ndev->features.bits, features.bits,
+		  NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_hw_features_set(struct net_device *ndev,
 		       const netdev_features_t features)
 {
-	ndev->hw_features = netdev_hw_features_or(ndev, features);
+	bitmap_or(ndev->hw_features.bits, ndev->hw_features.bits, features.bits,
+		  NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_wanted_features_set(struct net_device *ndev,
 			   const netdev_features_t features)
 {
-	ndev->wanted_features = netdev_wanted_features_or(ndev, features);
+	bitmap_or(ndev->wanted_features.bits, ndev->wanted_features.bits,
+		  features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_vlan_features_set(struct net_device *ndev,
 			 const netdev_features_t features)
 {
-	ndev->vlan_features = netdev_vlan_features_or(ndev, features);
+	bitmap_or(ndev->vlan_features.bits, ndev->vlan_features.bits,
+		  features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_hw_enc_features_set(struct net_device *ndev,
 			   const netdev_features_t features)
 {
-	ndev->hw_enc_features = netdev_hw_enc_features_or(ndev, features);
+	bitmap_or(ndev->hw_enc_features.bits, ndev->hw_enc_features.bits,
+		  features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_mpls_features_set(struct net_device *ndev,
 			 const netdev_features_t features)
 {
-	ndev->mpls_features = netdev_mpls_features_or(ndev, features);
+	bitmap_or(ndev->mpls_features.bits, ndev->mpls_features.bits,
+		  features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_gso_partial_features_set(struct net_device *ndev,
 				const netdev_features_t features)
 {
-	ndev->gso_partial_features = netdev_mpls_features_or(ndev, features);
+	bitmap_or(ndev->gso_partial_features.bits,
+		  ndev->gso_partial_features.bits, features.bits,
+		  NETDEV_FEATURE_COUNT);
 }
 
 static inline void netdev_feature_change(int nr, netdev_features_t *src)
 {
-	if (*src & __NETIF_F_BIT(nr))
-		*src &= ~(__NETIF_F_BIT(nr));
-	else
-		*src |= __NETIF_F_BIT(nr);
+	__change_bit(nr, src->bits);
 }
 
 #define netdev_active_feature_change(ndev, nr) \
@@ -295,7 +314,10 @@ static inline void netdev_feature_change(int nr, netdev_features_t *src)
 static inline netdev_features_t
 netdev_features_xor(const netdev_features_t a, const netdev_features_t b)
 {
-	return a ^ b;
+	netdev_features_t dst;
+
+	bitmap_xor(dst.bits, a.bits, b.bits, NETDEV_FEATURE_COUNT);
+	return dst;
 }
 
 #define netdev_active_features_xor(ndev, __features) \
@@ -323,64 +345,74 @@ netdev_features_xor(const netdev_features_t a, const netdev_features_t b)
 static inline void
 netdev_features_toggle(netdev_features_t *dst, const netdev_features_t features)
 {
-	*dst = netdev_features_xor(*dst, features);
+	bitmap_xor(dst->bits, dst->bits, features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_active_features_toggle(struct net_device *ndev,
 			      const netdev_features_t features)
 {
-	ndev->features = netdev_active_features_xor(ndev, features);
+	bitmap_xor(ndev->features.bits, ndev->features.bits, features.bits,
+		   NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_hw_features_toggle(struct net_device *ndev,
 			      const netdev_features_t features)
 {
-	ndev->hw_features = netdev_hw_features_xor(ndev, features);
+	bitmap_xor(ndev->hw_features.bits, ndev->hw_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_wanted_features_toggle(struct net_device *ndev,
 				  const netdev_features_t features)
 {
-	ndev->wanted_features = netdev_wanted_features_xor(ndev, features);
+	bitmap_xor(ndev->wanted_features.bits, ndev->wanted_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_vlan_features_toggle(struct net_device *ndev,
 				const netdev_features_t features)
 {
-	ndev->vlan_features = netdev_vlan_features_xor(ndev, features);
+	bitmap_xor(ndev->vlan_features.bits, ndev->vlan_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_hw_enc_features_toggle(struct net_device *ndev,
 			      const netdev_features_t features)
 {
-	ndev->hw_enc_features = netdev_hw_enc_features_xor(ndev, features);
+	bitmap_xor(ndev->hw_enc_features.bits, ndev->hw_enc_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_mpls_features_toggle(struct net_device *ndev,
 			    const netdev_features_t features)
 {
-	ndev->mpls_features = netdev_mpls_features_xor(ndev, features);
+	bitmap_xor(ndev->mpls_features.bits, ndev->mpls_features.bits,
+		   features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_gso_partial_features_toggle(struct net_device *ndev,
 				   const netdev_features_t features)
 {
-	ndev->gso_partial_features =
-			netdev_gso_partial_features_xor(ndev, features);
+	bitmap_xor(ndev->gso_partial_features.bits,
+		   ndev->gso_partial_features.bits, features.bits,
+		   NETDEV_FEATURE_COUNT);
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
 
 #define netdev_active_features_andnot(ndev, __features) \
@@ -428,63 +460,71 @@ netdev_features_andnot(const netdev_features_t a, const netdev_features_t b)
 static inline void
 netdev_features_clear(netdev_features_t *dst, const netdev_features_t features)
 {
-	*dst = netdev_features_andnot(*dst, features);
+	bitmap_andnot(dst->bits, dst->bits, features.bits,
+		      NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_active_features_clear(struct net_device *ndev,
 			     const netdev_features_t features)
 {
-	ndev->features = netdev_active_features_andnot(ndev, features);
+	bitmap_andnot(ndev->features.bits, ndev->features.bits, features.bits,
+		      NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_hw_features_clear(struct net_device *ndev,
 			 const netdev_features_t features)
 {
-	ndev->hw_features = netdev_hw_features_andnot(ndev, features);
+	bitmap_andnot(ndev->features.bits, ndev->features.bits, features.bits,
+		      NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_wanted_features_clear(struct net_device *ndev,
 			     const netdev_features_t features)
 {
-	ndev->wanted_features = netdev_wanted_features_andnot(ndev, features);
+	bitmap_andnot(ndev->wanted_features.bits, ndev->wanted_features.bits,
+		      features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_vlan_features_clear(struct net_device *ndev,
 			   const netdev_features_t features)
 {
-	ndev->vlan_features = netdev_vlan_features_andnot(ndev, features);
+	bitmap_andnot(ndev->vlan_features.bits, ndev->vlan_features.bits,
+		      features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_hw_enc_features_clear(struct net_device *ndev,
 			     const netdev_features_t features)
 {
-	ndev->hw_enc_features = netdev_hw_enc_features_andnot(ndev, features);
+	bitmap_andnot(ndev->hw_enc_features.bits, ndev->hw_enc_features.bits,
+		      features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_mpls_features_clear(struct net_device *ndev,
 			   const netdev_features_t features)
 {
-	ndev->mpls_features = netdev_mpls_features_andnot(ndev, features);
+	bitmap_andnot(ndev->mpls_features.bits, ndev->mpls_features.bits,
+		      features.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline void
 netdev_gso_partial_features_clear(struct net_device *ndev,
 				  const netdev_features_t features)
 {
-	ndev->gso_partial_features =
-		netdev_gso_partial_features_andnot(ndev, features);
+	bitmap_andnot(ndev->gso_partial_features.bits,
+		      ndev->gso_partial_features.bits, features.bits,
+		      NETDEV_FEATURE_COUNT);
 }
 
 /* helpers for netdev features 'set bit' operation */
 static inline void netdev_feature_add(int nr, netdev_features_t *src)
 {
-	*src |= __NETIF_F_BIT(nr);
+	__set_bit(nr, src->bits);
 }
 
 #define netdev_active_feature_add(ndev, nr) \
@@ -543,7 +583,7 @@ netdev_features_set_array(const struct netdev_feature_set *set,
 /* helpers for netdev features 'clear bit' operation */
 static inline void netdev_feature_del(int nr, netdev_features_t *src)
 {
-	*src &= ~__NETIF_F_BIT(nr);
+	__clear_bit(nr, src->bits);
 }
 
 #define netdev_active_feature_del(ndev, nr) \
@@ -602,7 +642,7 @@ netdev_features_clear_array(const struct netdev_feature_set *set,
 static inline bool netdev_features_intersects(const netdev_features_t src1,
 					      const netdev_features_t src2)
 {
-	return (src1 & src2) > 0;
+	return bitmap_intersects(src1.bits, src2.bits, NETDEV_FEATURE_COUNT);
 }
 
 #define netdev_active_features_intersects(ndev, __features) \
@@ -669,20 +709,11 @@ static inline void netdev_gso_partial_features_copy(struct net_device *ndev,
 	ndev->gso_partial_features = src;
 }
 
-/* helpers for netdev features 'get' operation */
-#define netdev_active_features(ndev)	((ndev)->features)
-#define netdev_hw_features(ndev)	((ndev)->hw_features)
-#define netdev_wanted_features(ndev)	((ndev)->wanted_features)
-#define netdev_vlan_features(ndev)	((ndev)->vlan_features)
-#define netdev_hw_enc_features(ndev)	((ndev)->hw_enc_features)
-#define netdev_mpls_features(ndev)	((ndev)->mpls_features)
-#define netdev_gso_partial_features(ndev)	((ndev)->gso_partial_features)
-
 /* helpers for netdev features 'subset' */
 static inline bool netdev_features_subset(const netdev_features_t src1,
 					  const netdev_features_t src2)
 {
-	return (src1 & src2) == src2;
+	return bitmap_subset(src1.bits, src2.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 4741f81fa968..11b31e512d68 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2338,7 +2338,7 @@ struct net_device {
 /* helpers for netdev features 'test bit' operation */
 static inline bool netdev_feature_test(int nr, const netdev_features_t src)
 {
-	return (src & __NETIF_F_BIT(nr)) > 0;
+	return test_bit(nr, src.bits);
 }
 
 #define netdev_active_feature_test(ndev, nr) \
@@ -4888,7 +4888,7 @@ static inline bool net_gso_ok(netdev_features_t features, int gso_type)
 {
 #define GSO_INDEX(x)	((1ULL << (x)) >> NETIF_F_GSO_SHIFT)
 
-	netdev_features_t feature = (netdev_features_t)gso_type << NETIF_F_GSO_SHIFT;
+	netdev_features_t feature = netdev_empty_features;
 
 	/* check flags correspondence */
 	BUILD_BUG_ON(SKB_GSO_TCPV4   != GSO_INDEX(NETIF_F_TSO_BIT));
@@ -4911,7 +4911,8 @@ static inline bool net_gso_ok(netdev_features_t features, int gso_type)
 	BUILD_BUG_ON(SKB_GSO_UDP_L4 != GSO_INDEX(NETIF_F_GSO_UDP_L4_BIT));
 	BUILD_BUG_ON(SKB_GSO_FRAGLIST != GSO_INDEX(NETIF_F_GSO_FRAGLIST_BIT));
 
-	return (features & feature) == feature;
+	bitmap_from_u64(feature.bits, (u64)gso_type << NETIF_F_GSO_SHIFT);
+	return bitmap_subset(features.bits, feature.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline bool skb_gso_ok(struct sk_buff *skb, netdev_features_t features)
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ca8afa382bf2..2f4e6cd05754 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3989,8 +3989,8 @@ static inline bool skb_needs_linearize(struct sk_buff *skb,
 				       netdev_features_t features)
 {
 	return skb_is_nonlinear(skb) &&
-	       ((skb_has_frag_list(skb) && !(features & NETIF_F_FRAGLIST)) ||
-		(skb_shinfo(skb)->nr_frags && !(features & NETIF_F_SG)));
+	       ((skb_has_frag_list(skb) && !test_bit(NETIF_F_FRAGLIST_BIT, features.bits)) ||
+		(skb_shinfo(skb)->nr_frags && !test_bit(NETIF_F_SG_BIT, features.bits)));
 }
 
 static inline void skb_copy_from_linear_data(const struct sk_buff *skb,
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 63fac94f9ace..4cf7e596eb53 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -447,7 +447,7 @@ static inline int iptunnel_pull_offloads(struct sk_buff *skb)
 		err = skb_unclone(skb, GFP_ATOMIC);
 		if (unlikely(err))
 			return err;
-		skb_shinfo(skb)->gso_type &= ~(NETIF_F_GSO_ENCAP_ALL >>
+		skb_shinfo(skb)->gso_type &= ~(GSO_ENCAP_FEATURES >>
 					       NETIF_F_GSO_SHIFT);
 	}
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 3c1853a9d1c0..d44e47681563 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1729,25 +1729,24 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
 }
 
 static noinline_for_stack
-char *netdev_bits(char *buf, char *end, const void *addr,
+char *netdev_bits(char *buf, char *end, void *addr,
 		  struct printf_spec spec,  const char *fmt)
 {
-	unsigned long long num;
-	int size;
+	netdev_features_t *features;
 
 	if (check_pointer(&buf, end, addr, spec))
 		return buf;
 
 	switch (fmt[1]) {
 	case 'F':
-		num = *(const netdev_features_t *)addr;
-		size = sizeof(netdev_features_t);
+		features = (netdev_features_t *)addr;
+		spec.field_width = NETDEV_FEATURE_COUNT;
 		break;
 	default:
 		return error_string(buf, end, "(%pN?)", spec);
 	}
 
-	return special_hex_number(buf, end, num, size);
+	return bitmap_string(buf, end, features->bits, spec, fmt);
 }
 
 static noinline_for_stack
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 38efdab960ba..7650a63cb234 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -27,10 +27,7 @@ const struct nla_policy ethnl_features_get_policy[] = {
 
 static void ethnl_features_to_bitmap32(u32 *dest, netdev_features_t src)
 {
-	unsigned int i;
-
-	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; i++)
-		dest[i] = src >> (32 * i);
+	bitmap_to_arr32(dest, src.bits, NETDEV_FEATURE_COUNT);
 }
 
 static int features_prepare_data(const struct ethnl_req_info *req_base,
@@ -45,7 +42,7 @@ static int features_prepare_data(const struct ethnl_req_info *req_base,
 	ethnl_features_to_bitmap32(data->wanted, dev->wanted_features);
 	ethnl_features_to_bitmap32(data->active, dev->features);
 	ethnl_features_to_bitmap32(data->nochange, NETIF_F_NEVER_CHANGE);
-	all_features = GENMASK_ULL(NETDEV_FEATURE_COUNT - 1, 0);
+	netdev_features_fill(&all_features);
 	ethnl_features_to_bitmap32(data->all, all_features);
 
 	return 0;
@@ -131,28 +128,6 @@ const struct nla_policy ethnl_features_set_policy[] = {
 	[ETHTOOL_A_FEATURES_WANTED]	= { .type = NLA_NESTED },
 };
 
-static void ethnl_features_to_bitmap(unsigned long *dest, netdev_features_t val)
-{
-	const unsigned int words = BITS_TO_LONGS(NETDEV_FEATURE_COUNT);
-	unsigned int i;
-
-	for (i = 0; i < words; i++)
-		dest[i] = (unsigned long)(val >> (i * BITS_PER_LONG));
-}
-
-static netdev_features_t ethnl_bitmap_to_features(unsigned long *src)
-{
-	const unsigned int nft_bits = sizeof(netdev_features_t) * BITS_PER_BYTE;
-	const unsigned int words = BITS_TO_LONGS(NETDEV_FEATURE_COUNT);
-	netdev_features_t ret = netdev_empty_features;
-	unsigned int i;
-
-	for (i = 0; i < words; i++)
-		ret |= (netdev_features_t)(src[i]) << (i * BITS_PER_LONG);
-	ret &= ~(netdev_features_t)0 >> (nft_bits - NETDEV_FEATURE_COUNT);
-	return ret;
-}
-
 static int features_send_reply(struct net_device *dev, struct genl_info *info,
 			       const unsigned long *wanted,
 			       const unsigned long *wanted_mask,
@@ -209,16 +184,16 @@ static int features_send_reply(struct net_device *dev, struct genl_info *info,
 
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
 	netdev_features_t tmp;
 	bool mod;
@@ -235,50 +210,47 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	dev = req_info.dev;
 
 	rtnl_lock();
-	ethnl_features_to_bitmap(old_active, dev->features);
-	ethnl_features_to_bitmap(old_wanted, dev->wanted_features);
-	ret = ethnl_parse_bitset(req_wanted, req_mask, NETDEV_FEATURE_COUNT,
+	old_active = dev->features;
+	old_wanted = dev->wanted_features;
+	ret = ethnl_parse_bitset(req_wanted.bits, req_mask.bits,
+				 NETDEV_FEATURE_COUNT,
 				 tb[ETHTOOL_A_FEATURES_WANTED],
 				 netdev_features_strings, info->extack);
 	if (ret < 0)
 		goto out_rtnl;
-	if (ethnl_bitmap_to_features(req_mask) & ~NETIF_F_ETHTOOL_BITS) {
+
+	if (!netdev_features_subset(req_mask, NETIF_F_ETHTOOL_BITS)) {
 		GENL_SET_ERR_MSG(info, "attempt to change non-ethtool features");
 		ret = -EINVAL;
 		goto out_rtnl;
 	}
 
 	/* set req_wanted bits not in req_mask from old_wanted */
-	bitmap_and(req_wanted, req_wanted, req_mask, NETDEV_FEATURE_COUNT);
-	bitmap_andnot(new_wanted, old_wanted, req_mask, NETDEV_FEATURE_COUNT);
-	bitmap_or(req_wanted, new_wanted, req_wanted, NETDEV_FEATURE_COUNT);
-	if (!bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
-		dev->wanted_features &= ~dev->hw_features;
-		tmp = ethnl_bitmap_to_features(req_wanted) & dev->hw_features;
-		dev->wanted_features |= tmp;
+	netdev_features_mask(&req_wanted, req_mask);
+	new_wanted = netdev_features_andnot(old_wanted, req_mask);
+	netdev_features_set(&req_wanted, new_wanted);
+	if (!netdev_features_equal(req_wanted, old_wanted)) {
+		netdev_wanted_features_clear(dev, dev->hw_features);
+		tmp = netdev_hw_features_and(dev, req_wanted);
+		netdev_wanted_features_set(dev, tmp);
 		__netdev_update_features(dev);
 	}
-	ethnl_features_to_bitmap(new_active, dev->features);
-	mod = !bitmap_equal(old_active, new_active, NETDEV_FEATURE_COUNT);
+	new_active = dev->features;
+	mod = !netdev_features_equal(old_active, new_active);
 
 	ret = 0;
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
-
-		ret = features_send_reply(dev, info, req_wanted,
-					  wanted_diff_mask, new_active,
-					  active_diff_mask, compact);
+		wanted_diff_mask = netdev_features_xor(req_wanted, new_active);
+		active_diff_mask = netdev_features_xor(old_active, new_active);
+		netdev_features_mask(&wanted_diff_mask, req_mask);
+		netdev_features_mask(&req_wanted, wanted_diff_mask);
+		netdev_features_mask(&new_active, active_diff_mask);
+
+		ret = features_send_reply(dev, info, req_wanted.bits,
+					  wanted_diff_mask.bits, new_active.bits,
+					  active_diff_mask.bits, compact);
 	}
 	if (mod)
 		netdev_features_change(dev);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index e4718b24dd38..97df79c62420 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -89,6 +89,10 @@ static int ethtool_get_features(struct net_device *dev, void __user *useraddr)
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
@@ -96,12 +100,16 @@ static int ethtool_get_features(struct net_device *dev, void __user *useraddr)
 	/* in case feature bits run out again */
 	BUILD_BUG_ON(ETHTOOL_DEV_FEATURE_WORDS * sizeof(u32) > sizeof(netdev_features_t));
 
+	bitmap_to_arr32(hw_arr, dev->hw_features.bits, NETDEV_FEATURE_COUNT);
+	bitmap_to_arr32(wanted_arr, dev->wanted_features.bits, NETDEV_FEATURE_COUNT);
+	bitmap_to_arr32(active_arr, dev->features.bits, NETDEV_FEATURE_COUNT);
+	bitmap_to_arr32(never_changed_arr, netdev_never_change_features.bits,
+			NETDEV_FEATURE_COUNT);
 	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; ++i) {
-		features[i].available = (u32)(dev->hw_features >> (32 * i));
-		features[i].requested = (u32)(dev->wanted_features >> (32 * i));
-		features[i].active = (u32)(dev->features >> (32 * i));
-		features[i].never_changed =
-			(u32)(NETIF_F_NEVER_CHANGE >> (32 * i));
+		features[i].available = hw_arr[i];
+		features[i].requested = wanted_arr[i];
+		features[i].active = active_arr[i];
+		features[i].never_changed = never_changed_arr[i];
 	}
 
 	sizeaddr = useraddr + offsetof(struct ethtool_gfeatures, size);
@@ -125,6 +133,8 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_sfeatures cmd;
 	struct ethtool_set_features_block features[ETHTOOL_DEV_FEATURE_WORDS];
+	u32 wanted_arr[ETHTOOL_DEV_FEATURE_WORDS];
+	u32 valid_arr[ETHTOOL_DEV_FEATURE_WORDS];
 	netdev_features_t wanted = netdev_empty_features;
 	netdev_features_t valid = netdev_empty_features;
 	netdev_features_t tmp;
@@ -141,27 +151,29 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 		return -EFAULT;
 
 	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; ++i) {
-		valid |= (netdev_features_t)features[i].valid << (32 * i);
-		wanted |= (netdev_features_t)features[i].requested << (32 * i);
+		valid_arr[i] = features[i].valid;
+		wanted_arr[i] = features[i].requested;
 	}
+	bitmap_from_arr32(valid.bits, valid_arr, NETDEV_FEATURE_COUNT);
+	bitmap_from_arr32(wanted.bits, wanted_arr, NETDEV_FEATURE_COUNT);
 
-	tmp = valid & ~NETIF_F_ETHTOOL_BITS;
-	if (tmp)
+	tmp = netdev_features_andnot(valid, NETIF_F_ETHTOOL_BITS);
+	if (!netdev_features_empty(tmp))
 		return -EINVAL;
 
-	tmp = valid & ~dev->hw_features;
-	if (tmp) {
-		valid &= dev->hw_features;
+	tmp = netdev_hw_features_andnot_r(dev, valid);
+	if (!netdev_features_empty(tmp)) {
+		netdev_features_mask(&valid, dev->hw_features);
 		ret |= ETHTOOL_F_UNSUPPORTED;
 	}
 
-	dev->wanted_features &= ~valid;
-	tmp = wanted & valid;
-	dev->wanted_features |= tmp;
+	netdev_wanted_features_clear(dev, valid);
+	tmp = netdev_features_and(wanted, valid);
+	netdev_wanted_features_set(dev, tmp);
 	__netdev_update_features(dev);
 
-	tmp = dev->wanted_features ^ dev->features;
-	if (tmp & valid)
+	tmp = netdev_wanted_features_xor(dev, dev->features);
+	if (netdev_features_intersects(tmp, valid))
 		ret |= ETHTOOL_F_WISH;
 
 	return ret;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 7a3d98473a0a..614f2e7b3eb7 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1046,7 +1046,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	}
 
 	/* Only HW csum features are currently compatible with mac80211 */
-	if (WARN_ON(hw->netdev_features & ~MAC80211_SUPPORTED_FEATURES))
+	if (WARN_ON(!netdev_features_empty(netdev_features_andnot(hw->netdev_features,
+								  MAC80211_SUPPORTED_FEATURES))))
 		return -EINVAL;
 
 	if (hw->max_report_rates == 0)
-- 
2.33.0

