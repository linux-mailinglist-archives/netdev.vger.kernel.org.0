Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36795BBD25
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiIRJvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiIRJuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:23 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D769E17E07
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:58 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MVjc12k0Rz14QYP;
        Sun, 18 Sep 2022 17:45:53 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:56 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 55/55] net: redefine the prototype of netdev_features_t
Date:   Sun, 18 Sep 2022 09:43:36 +0000
Message-ID: <20220918094336.28958-56-shenjian15@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918094336.28958-1-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/3com/typhoon.c           |   7 -
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  12 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |   2 +-
 drivers/net/ethernet/atheros/atlx/atl2.c      |   4 +-
 drivers/net/ethernet/brocade/bna/bnad.c       |   2 -
 .../net/ethernet/intel/i40e/i40e_debugfs.c    |  12 +-
 .../net/ethernet/intel/ixgbe/ixgbe_sriov.c    |   2 -
 .../ethernet/netronome/nfp/nfp_net_common.c   |   4 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   |   4 +-
 .../net/ethernet/synopsys/dwc-xlgmac-net.c    |   2 +-
 include/linux/netdev_feature_helpers.h        |  37 +++---
 include/linux/netdev_features.h               |  91 +------------
 include/linux/netdevice.h                     |   6 +-
 include/linux/skbuff.h                        |   8 +-
 include/net/ip_tunnels.h                      |   3 +-
 lib/vsprintf.c                                |   9 +-
 net/ethtool/features.c                        | 123 ++++++++----------
 net/ethtool/ioctl.c                           |  33 +++--
 18 files changed, 136 insertions(+), 225 deletions(-)

diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index d42a53748f40..4f9bc14ed44b 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -315,16 +315,9 @@ enum state_values {
 #define TYPHOON_RESET_TIMEOUT_NOSLEEP	((6 * 1000000) / TYPHOON_UDELAY)
 #define TYPHOON_WAIT_TIMEOUT		((1000000 / 2) / TYPHOON_UDELAY)
 
-#if defined(NETIF_F_TSO)
 #define skb_tso_size(x)		(skb_shinfo(x)->gso_size)
 #define TSO_NUM_DESCRIPTORS	2
 #define TSO_OFFLOAD_ON		TYPHOON_OFFLOAD_TCP_SEGMENT
-#else
-#define NETIF_F_TSO 		0
-#define skb_tso_size(x) 	0
-#define TSO_NUM_DESCRIPTORS	0
-#define TSO_OFFLOAD_ON		0
-#endif
 
 static inline void
 typhoon_inc_index(u32 *index, const int count, const int num_entries)
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 47beaab0d963..487409678cfb 100644
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
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 3709f8674724..17647ebbfdf0 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2227,7 +2227,7 @@ static int xgbe_set_features(struct net_device *netdev,
 {
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	struct xgbe_hw_if *hw_if = &pdata->hw_if;
-	netdev_features_t rxhash, rxcsum, rxvlan, rxvlan_filter;
+	bool rxhash, rxcsum, rxvlan, rxvlan_filter;
 	int ret = 0;
 
 	rxhash = netdev_feature_test(NETIF_F_RXHASH_BIT, pdata->netdev_features);
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index 2bc574a1cc25..11d82ae06d14 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -866,7 +866,7 @@ static netdev_tx_t atl2_xmit_frame(struct sk_buff *skb,
 			skb->len-copy_len);
 		offset = ((u32)(skb->len-copy_len + 3) & ~3);
 	}
-#ifdef NETIF_F_HW_VLAN_CTAG_TX
+
 	if (skb_vlan_tag_present(skb)) {
 		u16 vlan_tag = skb_vlan_tag_get(skb);
 		vlan_tag = (vlan_tag << 4) |
@@ -875,7 +875,7 @@ static netdev_tx_t atl2_xmit_frame(struct sk_buff *skb,
 		txph->ins_vlan = 1;
 		txph->vlan = vlan_tag;
 	}
-#endif
+
 	if (offset >= adapter->txd_ring_size)
 		offset -= adapter->txd_ring_size;
 	adapter->txd_write_ptr = offset;
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index cef5f7704d69..418c52c976f0 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -2857,12 +2857,10 @@ bnad_txq_wi_prepare(struct bnad *bnad, struct bna_tcb *tcb,
 
 			if (net_proto == htons(ETH_P_IP))
 				proto = ip_hdr(skb)->protocol;
-#ifdef NETIF_F_IPV6_CSUM
 			else if (net_proto == htons(ETH_P_IPV6)) {
 				/* nexthdr may not be TCP immediately. */
 				proto = ipv6_hdr(skb)->nexthdr;
 			}
-#endif
 			if (proto == IPPROTO_TCP) {
 				flags |= BNA_TXQ_WI_CF_TCP_CKSUM;
 				txqent->hdr.wi.l4_hdr_size_n_offset =
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
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index ae9e2259fe10..83a11924da60 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -12,9 +12,7 @@
 #include <linux/tcp.h>
 #include <linux/ipv6.h>
 #include <linux/if_bridge.h>
-#ifdef NETIF_F_HW_VLAN_CTAG_TX
 #include <linux/if_vlan.h>
-#endif
 
 #include "ixgbe.h"
 #include "ixgbe_type.h"
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index fad9d4337eb5..f10f3c0362e3 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1739,8 +1739,8 @@ static int nfp_net_set_features(struct net_device *netdev,
 	if (err)
 		return err;
 
-	nn_dbg(nn, "Feature change 0x%llx -> 0x%llx (changed=0x%llx)\n",
-	       netdev->features, *features, changed);
+	nn_dbg(nn, "Feature change %pNF -> %pNF (changed=%pNF)\n",
+	       &netdev->features, features, &changed);
 
 	if (new_ctrl == nn->dp.ctrl)
 		return 0;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 79f5d936a49f..caa6a7200790 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1562,8 +1562,8 @@ static int ionic_set_features(struct net_device *netdev,
 	struct ionic_lif *lif = netdev_priv(netdev);
 	int err;
 
-	netdev_dbg(netdev, "%s: lif->features=0x%08llx new_features=0x%08llx\n",
-		   __func__, (u64)lif->netdev->features, (u64)*features);
+	netdev_dbg(netdev, "%s: lif->features=%pNF new_features=%pNF\n",
+		   __func__, &lif->netdev->features, features);
 
 	err = ionic_set_nic_features(lif, features);
 
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
index 9f283d13e4f7..ff9d21aea3aa 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
@@ -879,9 +879,9 @@ static void xlgmac_poll_controller(struct net_device *netdev)
 static int xlgmac_set_features(struct net_device *netdev,
 			       const netdev_features_t *features)
 {
-	netdev_features_t rxhash, rxcsum, rxvlan, rxvlan_filter;
 	struct xlgmac_pdata *pdata = netdev_priv(netdev);
 	struct xlgmac_hw_ops *hw_ops = &pdata->hw_ops;
+	bool rxhash, rxcsum, rxvlan, rxvlan_filter;
 	int ret = 0;
 
 	rxhash = netdev_feature_test(NETIF_F_RXHASH_BIT, pdata->netdev_features);
diff --git a/include/linux/netdev_feature_helpers.h b/include/linux/netdev_feature_helpers.h
index a15bd3a3b574..4e0a84dd8017 100644
--- a/include/linux/netdev_feature_helpers.h
+++ b/include/linux/netdev_feature_helpers.h
@@ -9,7 +9,7 @@
 
 static inline void __netdev_features_zero(netdev_features_t *dst)
 {
-	*dst = 0;
+	bitmap_zero(dst->bits, NETDEV_FEATURE_COUNT);
 }
 
 #define netdev_features_zero(features) __netdev_features_zero(&(features))
@@ -38,14 +38,14 @@ static inline void __netdev_features_zero(netdev_features_t *dst)
 
 static inline void __netdev_features_fill(netdev_features_t *dst)
 {
-	*dst = ~0ULL;
+	bitmap_fill(dst->bits, NETDEV_FEATURE_COUNT);
 }
 
 #define netdev_features_fill(features) __netdev_features_fill(&(features))
 
 static inline bool __netdev_features_empty(const netdev_features_t *src)
 {
-	return *src == 0;
+	return bitmap_empty(src->bits, NETDEV_FEATURE_COUNT);
 }
 
 #define netdev_features_empty(features) __netdev_features_empty(&(features))
@@ -75,7 +75,7 @@ static inline bool __netdev_features_empty(const netdev_features_t *src)
 static inline bool __netdev_features_equal(const netdev_features_t *feats1,
 					   const netdev_features_t *feats2)
 {
-	return *feats1 == *feats2;
+	return bitmap_equal(feats1->bits, feats2->bits, NETDEV_FEATURE_COUNT);
 }
 
 #define netdev_features_equal(feat1, feat2)	\
@@ -107,8 +107,7 @@ static inline bool
 __netdev_features_and(netdev_features_t *dst, const netdev_features_t *a,
 		      const netdev_features_t *b)
 {
-	*dst = *a & *b;
-	return *dst != 0;
+	return bitmap_and(dst->bits, a->bits, b->bits, NETDEV_FEATURE_COUNT);
 }
 
 #define netdev_features_and(dst, a, b) __netdev_features_and(&(dst), &(a), &(b))
@@ -171,7 +170,7 @@ static inline void
 __netdev_features_or(netdev_features_t *dst, const netdev_features_t *a,
 		     const netdev_features_t *b)
 {
-	*dst = *a | *b;
+	bitmap_or(dst->bits, a->bits, b->bits, NETDEV_FEATURE_COUNT);
 }
 
 #define netdev_features_or(dst, a, b) __netdev_features_or(&(dst), &(a), &(b))
@@ -230,10 +229,7 @@ __netdev_features_set(netdev_features_t *dst, const netdev_features_t *features)
 
 static inline void __netdev_feature_change(int nr, netdev_features_t *src)
 {
-	if (*src & __NETIF_F_BIT(nr))
-		*src &= ~(__NETIF_F_BIT(nr));
-	else
-		*src |= __NETIF_F_BIT(nr);
+	__change_bit(nr, src->bits);
 }
 
 #define netdev_feature_change(nr, src)	\
@@ -265,7 +261,7 @@ static inline void
 __netdev_features_xor(netdev_features_t *dst, const netdev_features_t *a,
 		      const netdev_features_t *b)
 {
-	*dst = *a ^ *b;
+	bitmap_xor(dst->bits, a->bits, b->bits, NETDEV_FEATURE_COUNT);
 }
 
 #define netdev_features_xor(dst, a, b) __netdev_features_xor(&(dst), &(a), &(b))
@@ -328,8 +324,7 @@ static inline bool
 __netdev_features_andnot(netdev_features_t *dst, const netdev_features_t *a,
 			 const netdev_features_t *b)
 {
-	*dst = *a & ~(*b);
-	return *dst == 0;
+	return bitmap_andnot(dst->bits, a->bits, b->bits, NETDEV_FEATURE_COUNT);
 }
 
 #define netdev_features_andnot(dst, a, b)	\
@@ -360,7 +355,8 @@ static inline void
 __netdev_features_clear(netdev_features_t *dst,
 			const netdev_features_t *features)
 {
-	__netdev_features_andnot(dst, dst, features);
+	bitmap_andnot(dst->bits, dst->bits, features->bits,
+		      NETDEV_FEATURE_COUNT);
 }
 
 #define netdev_features_clear(dst, __features)	\
@@ -390,7 +386,7 @@ __netdev_features_clear(netdev_features_t *dst,
 /* helpers for netdev features 'set bit' operation */
 static inline void __netdev_feature_add(int nr, netdev_features_t *src)
 {
-	*src |= __NETIF_F_BIT(nr);
+	__set_bit(nr, src->bits);
 }
 
 #define netdev_feature_add(nr, src) __netdev_feature_add(nr, &(src))
@@ -454,7 +450,7 @@ __netdev_features_set_array(const struct netdev_feature_set *set,
 /* helpers for netdev features 'clear bit' operation */
 static inline void __netdev_feature_del(int nr, netdev_features_t *src)
 {
-	*src &= ~__NETIF_F_BIT(nr);
+	__clear_bit(nr, src->bits);
 }
 
 #define netdev_feature_del(nr, src) __netdev_feature_del(nr, &(src))
@@ -518,7 +514,8 @@ __netdev_features_clear_array(const struct netdev_feature_set *set,
 static inline bool __netdev_features_intersects(const netdev_features_t *feats1,
 						const netdev_features_t *feats2)
 {
-	return (*feats1 & *feats2) > 0;
+	return bitmap_intersects(feats1->bits, feats2->bits,
+				 NETDEV_FEATURE_COUNT);
 }
 
 #define netdev_features_intersects(feats1, feats2)	\
@@ -549,7 +546,7 @@ static inline bool __netdev_features_intersects(const netdev_features_t *feats1,
 static inline void __netdev_features_copy(netdev_features_t *dst,
 					  const netdev_features_t *src)
 {
-	*dst = *src;
+	bitmap_copy(dst->bits, src->bits, NETDEV_FEATURE_COUNT);
 }
 
 #define netdev_features_copy(dst, src)	__netdev_features_copy(&(dst), &(src))
@@ -579,7 +576,7 @@ static inline void __netdev_features_copy(netdev_features_t *dst,
 static inline bool __netdev_features_subset(const netdev_features_t *feats1,
 					    const netdev_features_t *feats2)
 {
-	return (*feats1 & *feats2) == *feats2;
+	return bitmap_subset(feats1->bits, feats2->bits, NETDEV_FEATURE_COUNT);
 }
 
 #define netdev_features_subset(feats1, feats2)	\
diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 664055209b2e..d41e74748927 100644
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
@@ -144,94 +146,11 @@ extern netdev_features_t netdev_tls_features __ro_after_init;
 extern netdev_features_t netdev_csum_gso_features_mask __ro_after_init;
 extern netdev_features_t netdev_empty_features __ro_after_init;
 
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
-
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
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 4620af4591fc..33486b2aa9f1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2348,7 +2348,7 @@ struct net_device {
 /* helpers for netdev features 'test bit' operation */
 static inline bool __netdev_feature_test(int nr, const netdev_features_t *src)
 {
-	return (*src & __NETIF_F_BIT(nr)) > 0;
+	return test_bit(nr, src->bits);
 }
 
 #define netdev_feature_test(nr, __features)	\
@@ -4947,12 +4947,12 @@ static inline bool net_gso_ok(const netdev_features_t *features, int gso_type)
 	ASSERT_GSO_TYPE(SKB_GSO_FRAGLIST_BIT, NETIF_F_GSO_FRAGLIST_BIT);
 
 	if (classic_gso_type)
-		feature = (netdev_features_t)gso_type << NETIF_F_GSO_SHIFT;
+		bitmap_from_u64(feature.bits, (u64)gso_type << NETIF_F_GSO_SHIFT);
 
 	if (new_gso_type) { /* placeholder for new gso type */
 	}
 
-	return (*features & feature) == feature;
+	return bitmap_subset(features->bits, feature.bits, NETDEV_FEATURE_COUNT);
 }
 
 static inline bool skb_gso_ok(struct sk_buff *skb,
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 122190c334cb..33df942ed6da 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -693,6 +693,10 @@ enum {
 	SKB_GSO_FRAGLIST = __SKB_GSO_FLAG(FRAGLIST),
 };
 
+#define SKB_GSO_ENCAP_ALL	\
+		(SKB_GSO_GRE_CSUM | SKB_GSO_GRE_CSUM | SKB_GSO_IPXIP4 |	\
+		 SKB_GSO_IPXIP6 | SKB_GSO_UDP_TUNNEL | SKB_GSO_UDP_TUNNEL_CSUM)
+
 #if BITS_PER_LONG > 32
 #define NET_SKBUFF_DATA_USES_OFFSET 1
 #endif
@@ -4038,8 +4042,8 @@ static inline bool skb_needs_linearize(struct sk_buff *skb,
 				       const netdev_features_t *features)
 {
 	return skb_is_nonlinear(skb) &&
-	       ((skb_has_frag_list(skb) && !(*features & NETIF_F_FRAGLIST)) ||
-		(skb_shinfo(skb)->nr_frags && !(*features & NETIF_F_SG)));
+	       ((skb_has_frag_list(skb) && !test_bit(NETIF_F_FRAGLIST_BIT, features->bits)) ||
+		(skb_shinfo(skb)->nr_frags && !test_bit(NETIF_F_SG_BIT, features->bits)));
 }
 
 static inline void skb_copy_from_linear_data(const struct sk_buff *skb,
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index ced80e2f8b58..d3f028d31e0b 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -449,8 +449,7 @@ static inline int iptunnel_pull_offloads(struct sk_buff *skb)
 		err = skb_unclone(skb, GFP_ATOMIC);
 		if (unlikely(err))
 			return err;
-		skb_shinfo(skb)->gso_type &= ~(NETIF_F_GSO_ENCAP_ALL >>
-					       NETIF_F_GSO_SHIFT);
+		skb_shinfo(skb)->gso_type &= ~SKB_GSO_ENCAP_ALL;
 	}
 
 	skb->encapsulation = 0;
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 3c1853a9d1c0..fa1cb5ff6de2 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1732,22 +1732,21 @@ static noinline_for_stack
 char *netdev_bits(char *buf, char *end, const void *addr,
 		  struct printf_spec spec,  const char *fmt)
 {
-	unsigned long long num;
-	int size;
+	const netdev_features_t *features;
 
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
index 496dfd45faac..2607a8b46cee 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -25,12 +25,9 @@ const struct nla_policy ethnl_features_get_policy[] = {
 		NLA_POLICY_NESTED(ethnl_header_policy),
 };
 
-static void ethnl_features_to_bitmap32(u32 *dest, netdev_features_t src)
+static void ethnl_features_to_bitmap32(u32 *dest, const netdev_features_t *src)
 {
-	unsigned int i;
-
-	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; i++)
-		dest[i] = src >> (32 * i);
+	bitmap_to_arr32(dest, src->bits, NETDEV_FEATURE_COUNT);
 }
 
 static int features_prepare_data(const struct ethnl_req_info *req_base,
@@ -41,12 +38,12 @@ static int features_prepare_data(const struct ethnl_req_info *req_base,
 	struct net_device *dev = reply_base->dev;
 	netdev_features_t all_features;
 
-	ethnl_features_to_bitmap32(data->hw, dev->hw_features);
-	ethnl_features_to_bitmap32(data->wanted, dev->wanted_features);
-	ethnl_features_to_bitmap32(data->active, dev->features);
-	ethnl_features_to_bitmap32(data->nochange, NETIF_F_NEVER_CHANGE);
-	all_features = GENMASK_ULL(NETDEV_FEATURE_COUNT - 1, 0);
-	ethnl_features_to_bitmap32(data->all, all_features);
+	ethnl_features_to_bitmap32(data->hw, &dev->hw_features);
+	ethnl_features_to_bitmap32(data->wanted, &dev->wanted_features);
+	ethnl_features_to_bitmap32(data->active, &dev->features);
+	ethnl_features_to_bitmap32(data->nochange, &NETIF_F_NEVER_CHANGE);
+	netdev_features_fill(all_features);
+	ethnl_features_to_bitmap32(data->all, &all_features);
 
 	return 0;
 }
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
-	netdev_features_t ret = 0;
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
@@ -207,18 +182,23 @@ static int features_send_reply(struct net_device *dev, struct genl_info *info,
 	return ret;
 }
 
+enum {
+	OLD_ACTIVE = 0,
+	OLD_WANTED = 1,
+	NEW_ACTIVE = 2,
+	NEW_WANTED = 3,
+	REQ_WANTED = 4,
+	REQ_MASK = 5,
+	ACTIVE_DIFF_MASK = 6,
+	WANTED_DIFF_MASK = 7,
+	FEATURES_NUM = 8
+};
+
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
+	netdev_features_t *features;
 	struct net_device *dev;
 	netdev_features_t tmp;
 	bool mod;
@@ -234,52 +214,60 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 		return ret;
 	dev = req_info.dev;
 
+	features = kzalloc(sizeof(netdev_features_t) * FEATURES_NUM, GFP_KERNEL);
+	if (!features)
+		return -ENOMEM;
+
 	rtnl_lock();
-	ethnl_features_to_bitmap(old_active, dev->features);
-	ethnl_features_to_bitmap(old_wanted, dev->wanted_features);
-	ret = ethnl_parse_bitset(req_wanted, req_mask, NETDEV_FEATURE_COUNT,
+	netdev_features_copy(features[OLD_ACTIVE], dev->features);
+	netdev_features_copy(features[OLD_WANTED], dev->wanted_features);
+	ret = ethnl_parse_bitset(features[REQ_WANTED].bits, features[REQ_MASK].bits,
+				 NETDEV_FEATURE_COUNT,
 				 tb[ETHTOOL_A_FEATURES_WANTED],
 				 netdev_features_strings, info->extack);
 	if (ret < 0)
 		goto out_rtnl;
-	if (ethnl_bitmap_to_features(req_mask) & ~NETIF_F_ETHTOOL_BITS) {
+	if (!netdev_features_subset(features[REQ_MASK], NETIF_F_ETHTOOL_BITS)) {
 		GENL_SET_ERR_MSG(info, "attempt to change non-ethtool features");
 		ret = -EINVAL;
 		goto out_rtnl;
 	}
 
 	/* set req_wanted bits not in req_mask from old_wanted */
-	bitmap_and(req_wanted, req_wanted, req_mask, NETDEV_FEATURE_COUNT);
-	bitmap_andnot(new_wanted, old_wanted, req_mask, NETDEV_FEATURE_COUNT);
-	bitmap_or(req_wanted, new_wanted, req_wanted, NETDEV_FEATURE_COUNT);
-	if (!bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
+	netdev_features_mask(features[REQ_WANTED], features[REQ_MASK]);
+	netdev_features_andnot(features[NEW_WANTED], features[OLD_WANTED],
+			       features[REQ_MASK]);
+	netdev_features_set(features[REQ_WANTED], features[NEW_WANTED]);
+	if (!netdev_features_equal(features[REQ_WANTED], features[OLD_WANTED])) {
 		netdev_wanted_features_clear(dev, dev->hw_features);
-		tmp = ethnl_bitmap_to_features(req_wanted);
-		netdev_features_mask(tmp, dev->hw_features);
+		netdev_features_and(tmp, dev->hw_features, features[REQ_WANTED]);
 		netdev_wanted_features_set(dev, tmp);
 		__netdev_update_features(dev);
 	}
-	ethnl_features_to_bitmap(new_active, dev->features);
-	mod = !bitmap_equal(old_active, new_active, NETDEV_FEATURE_COUNT);
+	netdev_features_copy(features[NEW_ACTIVE], dev->features);
+	mod = !netdev_features_equal(features[OLD_ACTIVE], features[NEW_ACTIVE]);
 
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
+		netdev_features_xor(features[WANTED_DIFF_MASK],
+				    features[REQ_WANTED], features[NEW_ACTIVE]);
+		netdev_features_xor(features[ACTIVE_DIFF_MASK],
+				    features[OLD_ACTIVE],
+				    features[NEW_ACTIVE]);
+		netdev_features_mask(features[WANTED_DIFF_MASK],
+				     features[REQ_MASK]);
+		netdev_features_mask(features[REQ_WANTED],
+				     features[WANTED_DIFF_MASK]);
+		netdev_features_mask(features[NEW_ACTIVE],
+				     features[ACTIVE_DIFF_MASK]);
+
+		ret = features_send_reply(dev, info, features[REQ_WANTED].bits,
+					  features[WANTED_DIFF_MASK].bits,
+					  features[NEW_ACTIVE].bits,
+					  features[ACTIVE_DIFF_MASK].bits,
+					  compact);
 	}
 	if (mod)
 		netdev_features_change(dev);
@@ -287,5 +275,6 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 out_rtnl:
 	rtnl_unlock();
 	ethnl_parse_header_dev_put(&req_info);
+	kfree(features);
 	return ret;
 }
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 12bf982a5d2d..c4537aacc6f1 100644
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
 	netdev_features_t wanted;
 	netdev_features_t valid;
 	netdev_features_t tmp;
@@ -143,16 +153,18 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 	netdev_features_zero(wanted);
 	netdev_features_zero(valid);
 	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; ++i) {
-		valid |= (netdev_features_t)features[i].valid << (32 * i);
-		wanted |= (netdev_features_t)features[i].requested << (32 * i);
+		valid_arr[i] = features[i].valid;
+		wanted_arr[i] = features[i].requested;
 	}
+	bitmap_from_arr32(valid.bits, valid_arr, NETDEV_FEATURE_COUNT);
+	bitmap_from_arr32(wanted.bits, wanted_arr, NETDEV_FEATURE_COUNT);
 
 	netdev_features_andnot(tmp, valid, NETIF_F_ETHTOOL_BITS);
-	if (tmp)
+	if (!netdev_features_empty(tmp))
 		return -EINVAL;
 
 	netdev_features_andnot(tmp, valid, dev->hw_features);
-	if (tmp) {
+	if (!netdev_features_empty(tmp)) {
 		netdev_features_mask(valid, dev->hw_features);
 		ret |= ETHTOOL_F_UNSUPPORTED;
 	}
@@ -163,8 +175,7 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 	__netdev_update_features(dev);
 
 	netdev_features_xor(tmp, dev->wanted_features, dev->features);
-
-	if (tmp & valid)
+	if (netdev_features_intersects(tmp, valid))
 		ret |= ETHTOOL_F_WISH;
 
 	return ret;
-- 
2.33.0

