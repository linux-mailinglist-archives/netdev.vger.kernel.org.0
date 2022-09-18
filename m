Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B445BBD2B
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiIRJu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiIRJt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:49:59 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4643211C3E
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:49 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MVjdK2KH1zpStg;
        Sun, 18 Sep 2022 17:47:01 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:46 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 02/55] net: replace general features macroes with global netdev_features variables
Date:   Sun, 18 Sep 2022 09:42:43 +0000
Message-ID: <20220918094336.28958-3-shenjian15@huawei.com>
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

There are many netdev_features bits group used in kernel. The definition
will be illegal when using feature bit more than 64. Replace these macroes
with global netdev_features variables, initialize them when net device
module init.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/wireguard/device.c         |  12 +-
 include/linux/netdev_feature_helpers.h | 112 +++++++++++++
 include/linux/netdev_features.h        |  84 ++++++----
 net/core/Makefile                      |   2 +-
 net/core/dev.c                         |   2 +
 net/core/dev.h                         |   2 +
 net/core/netdev_features.c             | 223 +++++++++++++++++++++++++
 7 files changed, 394 insertions(+), 43 deletions(-)
 create mode 100644 net/core/netdev_features.c

diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index d58e9f818d3b..32831d40d757 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -275,9 +275,9 @@ static const struct device_type device_type = { .name = KBUILD_MODNAME };
 static void wg_setup(struct net_device *dev)
 {
 	struct wg_device *wg = netdev_priv(dev);
-	enum { WG_NETDEV_FEATURES = NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
-				    NETIF_F_SG | NETIF_F_GSO |
-				    NETIF_F_GSO_SOFTWARE | NETIF_F_HIGHDMA };
+	netdev_features_t wg_netdev_features =
+		NETIF_F_HW_CSUM | NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
+		NETIF_F_GSO_SOFTWARE | NETIF_F_HIGHDMA;
 	const int overhead = MESSAGE_MINIMUM_LENGTH + sizeof(struct udphdr) +
 			     max(sizeof(struct ipv6hdr), sizeof(struct iphdr));
 
@@ -291,9 +291,9 @@ static void wg_setup(struct net_device *dev)
 	dev->flags = IFF_POINTOPOINT | IFF_NOARP;
 	dev->priv_flags |= IFF_NO_QUEUE;
 	dev->features |= NETIF_F_LLTX;
-	dev->features |= WG_NETDEV_FEATURES;
-	dev->hw_features |= WG_NETDEV_FEATURES;
-	dev->hw_enc_features |= WG_NETDEV_FEATURES;
+	dev->features |= wg_netdev_features;
+	dev->hw_features |= wg_netdev_features;
+	dev->hw_enc_features |= wg_netdev_features;
 	dev->mtu = ETH_DATA_LEN - overhead;
 	dev->max_mtu = round_down(INT_MAX, MESSAGE_PADDING_MULTIPLE) - overhead;
 
diff --git a/include/linux/netdev_feature_helpers.h b/include/linux/netdev_feature_helpers.h
index 4bb5de61e4e9..132bf0de1523 100644
--- a/include/linux/netdev_feature_helpers.h
+++ b/include/linux/netdev_feature_helpers.h
@@ -585,6 +585,118 @@ static inline bool __netdev_features_subset(const netdev_features_t *feats1,
 #define netdev_features_subset(feats1, feats2)	\
 		__netdev_features_subset(&(feats1), &(feats2))
 
+#define __netdev_features_set_set(feat, uniq, ...) ({	\
+	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
+	__netdev_features_set_array(&(uniq), &(feat));	\
+})
+#define netdev_features_set_set(feat, ...)		\
+	__netdev_features_set_set(feat, __UNIQUE_ID(feat_set), __VA_ARGS__)
+
+#define __netdev_active_features_set_set(ndev, uniq, ...) ({	\
+	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
+	netdev_active_features_set_array(ndev, uniq);	\
+})
+#define netdev_active_features_set_set(ndev, ...)		\
+	__netdev_active_features_set_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
+
+#define __netdev_hw_features_set_set(ndev, uniq, ...) ({	\
+	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
+	netdev_hw_features_set_array(ndev, uniq);	\
+})
+#define netdev_hw_features_set_set(ndev, ...)		\
+	__netdev_hw_features_set_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
+
+#define __netdev_wanted_features_set_set(ndev, uniq, ...) ({	\
+	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
+	netdev_wanted_features_set_array(ndev, uniq);	\
+})
+#define netdev_wanted_features_set_set(ndev, ...)		\
+	__netdev_wanted_features_set_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
+
+#define __netdev_vlan_features_set_set(ndev, uniq, ...) ({	\
+	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
+	netdev_vlan_features_set_array(ndev, uniq);	\
+})
+#define netdev_vlan_features_set_set(ndev, ...)		\
+	__netdev_vlan_features_set_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
+
+#define __netdev_hw_enc_features_set_set(ndev, uniq, ...) ({	\
+	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
+	netdev_hw_enc_features_set_array(ndev, uniq);	\
+})
+#define netdev_hw_enc_features_set_set(ndev, ...)		\
+	__netdev_hw_enc_features_set_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
+
+#define __netdev_mpls_features_set_set(ndev, uniq, ...) ({	\
+	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
+	netdev_mpls_features_set_array(ndev, uniq);	\
+})
+#define netdev_mpls_features_set_set(ndev, ...)		\
+	__netdev_mpls_features_set_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
+
+#define __netdev_gso_partial_features_set_set(ndev, uniq, ...) ({	\
+	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
+	netdev_gso_partial_features_set_array(ndev, uniq);	\
+})
+#define netdev_gso_partial_features_set_set(ndev, ...)		\
+	__netdev_gso_partial_features_set_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
+
+#define __netdev_features_clear_set(feat, uniq, ...) ({	\
+	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
+	__netdev_features_clear_array(&(uniq), &(feat));	\
+})
+#define netdev_features_clear_set(feat, ...)		\
+	__netdev_features_clear_set(feat, __UNIQUE_ID(feat_set), __VA_ARGS__)
+
+#define __netdev_active_features_clear_set(ndev, uniq, ...) ({	\
+	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
+	netdev_active_features_clear_array(ndev, uniq);	\
+})
+#define netdev_active_features_clear_set(ndev, ...)		\
+	__netdev_active_features_clear_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
+
+#define __netdev_hw_features_clear_set(ndev, uniq, ...) ({	\
+	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
+	netdev_hw_features_clear_array(ndev, uniq);	\
+})
+#define netdev_hw_features_clear_set(ndev, ...)		\
+	__netdev_hw_features_clear_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
+
+#define __netdev_wanted_features_clear_set(ndev, uniq, ...) ({	\
+	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
+	netdev_wanted_features_clear_array(ndev, uniq);	\
+})
+#define netdev_wanted_features_clear_set(ndev, ...)		\
+		__netdev_wanted_features_clear_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
+
+#define __netdev_vlan_features_clear_set(ndev, uniq, ...) ({	\
+	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
+	netdev_vlan_features_clear_array(ndev, uniq);	\
+})
+#define netdev_vlan_features_clear_set(ndev, ...)		\
+	__netdev_vlan_features_clear_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
+
+#define __netdev_hw_enc_features_clear_set(ndev, uniq, ...) ({	\
+	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
+	netdev_hw_enc_features_clear_array(ndev, uniq);	\
+})
+#define netdev_hw_enc_features_clear_set(ndev, ...)		\
+	__netdev_hw_enc_features_clear_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
+
+#define __netdev_mpls_features_clear_set(ndev, uniq, ...) ({	\
+	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
+	netdev_mpls_features_clear_array(ndev, uniq);	\
+})
+#define netdev_mpls_features_clear_set(ndev, ...)		\
+	__netdev_mpls_features_clear_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
+
+#define __netdev_gso_partial_features_clear_set(ndev, uniq, ...) ({	\
+	static DECLARE_NETDEV_FEATURE_SET(uniq, __VA_ARGS__);	\
+	netdev_gso_partial_features_clear_array(ndev, uniq);	\
+})
+#define netdev_gso_partial_features_clear_set(ndev, ...)		\
+	__netdev_gso_partial_features_clear_set(ndev, __UNIQUE_ID(feat_set), __VA_ARGS__)
+
 static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 							  netdev_features_t f2)
 {
diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 9d434b4e6e6e..664055209b2e 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -7,6 +7,7 @@
 
 #include <linux/types.h>
 #include <linux/bitops.h>
+#include <linux/cache.h>
 #include <asm/byteorder.h>
 
 typedef u64 netdev_features_t;
@@ -112,6 +113,37 @@ enum {
 	/**/NETDEV_FEATURE_COUNT
 };
 
+extern netdev_features_t netdev_ethtool_features __ro_after_init;
+extern netdev_features_t netdev_never_change_features __ro_after_init;
+extern netdev_features_t netdev_gso_features_mask __ro_after_init;
+extern netdev_features_t netdev_ip_csum_features __ro_after_init;
+extern netdev_features_t netdev_csum_features_mask __ro_after_init;
+extern netdev_features_t netdev_general_tso_features __ro_after_init;
+extern netdev_features_t netdev_all_tso_features __ro_after_init;
+extern netdev_features_t netdev_tso_ecn_features __ro_after_init;
+extern netdev_features_t netdev_all_fcoe_features __ro_after_init;
+extern netdev_features_t netdev_gso_software_features __ro_after_init;
+extern netdev_features_t netdev_one_for_all_features __ro_after_init;
+extern netdev_features_t netdev_all_for_all_features __ro_after_init;
+extern netdev_features_t netdev_upper_disable_features __ro_after_init;
+extern netdev_features_t netdev_soft_features __ro_after_init;
+extern netdev_features_t netdev_soft_off_features __ro_after_init;
+extern netdev_features_t netdev_all_vlan_features __ro_after_init;
+extern netdev_features_t netdev_rx_vlan_features __ro_after_init;
+extern netdev_features_t netdev_tx_vlan_features __ro_after_init;
+extern netdev_features_t netdev_ctag_vlan_offload_features __ro_after_init;
+extern netdev_features_t netdev_stag_vlan_offload_features __ro_after_init;
+extern netdev_features_t netdev_vlan_offload_features __ro_after_init;
+extern netdev_features_t netdev_ctag_vlan_features __ro_after_init;
+extern netdev_features_t netdev_stag_vlan_features __ro_after_init;
+extern netdev_features_t netdev_vlan_filter_features __ro_after_init;
+extern netdev_features_t netdev_multi_tags_features_mask __ro_after_init;
+extern netdev_features_t netdev_gso_encap_all_features __ro_after_init;
+extern netdev_features_t netdev_xfrm_features __ro_after_init;
+extern netdev_features_t netdev_tls_features __ro_after_init;
+extern netdev_features_t netdev_csum_gso_features_mask __ro_after_init;
+extern netdev_features_t netdev_empty_features __ro_after_init;
+
 /* copy'n'paste compression ;) */
 #define __NETIF_F_BIT(bit)	((netdev_features_t)1 << (bit))
 #define __NETIF_F(name)		__NETIF_F_BIT(NETIF_F_##name##_BIT)
@@ -203,73 +235,53 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 
 /* Features valid for ethtool to change */
 /* = all defined minus driver/device-class-related */
-#define NETIF_F_NEVER_CHANGE	(NETIF_F_VLAN_CHALLENGED | \
-				 NETIF_F_LLTX | NETIF_F_NETNS_LOCAL)
+#define NETIF_F_NEVER_CHANGE	netdev_never_change_features
 
 /* remember that ((t)1 << t_BITS) is undefined in C99 */
-#define NETIF_F_ETHTOOL_BITS	((__NETIF_F_BIT(NETDEV_FEATURE_COUNT - 1) | \
-		(__NETIF_F_BIT(NETDEV_FEATURE_COUNT - 1) - 1)) & \
-		~NETIF_F_NEVER_CHANGE)
+#define NETIF_F_ETHTOOL_BITS	netdev_ethtool_features
 
 /* Segmentation offload feature mask */
-#define NETIF_F_GSO_MASK	(__NETIF_F_BIT(NETIF_F_GSO_LAST + 1) - \
-		__NETIF_F_BIT(NETIF_F_GSO_SHIFT))
+#define NETIF_F_GSO_MASK	netdev_gso_features_mask
 
 /* List of IP checksum features. Note that NETIF_F_HW_CSUM should not be
  * set in features when NETIF_F_IP_CSUM or NETIF_F_IPV6_CSUM are set--
  * this would be contradictory
  */
-#define NETIF_F_CSUM_MASK	(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | \
-				 NETIF_F_HW_CSUM)
+#define NETIF_F_CSUM_MASK	netdev_csum_features_mask
 
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
+#define NETIF_F_VLAN_FEATURES	netdev_all_vlan_features
+
+#define NETIF_F_GSO_ENCAP_ALL	netdev_gso_encap_all_features
 
 #endif	/* _LINUX_NETDEV_FEATURES_H */
diff --git a/net/core/Makefile b/net/core/Makefile
index 5857cec87b83..77618bfaa890 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -12,7 +12,7 @@ obj-$(CONFIG_SYSCTL) += sysctl_net_core.o
 obj-y		     += dev.o dev_addr_lists.o dst.o netevent.o \
 			neighbour.o rtnetlink.o utils.o link_watch.o filter.o \
 			sock_diag.o dev_ioctl.o tso.o sock_reuseport.o \
-			fib_notifier.o xdp.o flow_offload.o gro.o
+			fib_notifier.o xdp.o flow_offload.o gro.o netdev_features.o
 
 obj-$(CONFIG_NETDEV_ADDR_LIST_TEST) += dev_addr_lists_test.o
 
diff --git a/net/core/dev.c b/net/core/dev.c
index fdae614ecffa..491130bdbbad 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11390,6 +11390,8 @@ static int __init net_dev_init(void)
 	if (register_pernet_subsys(&netdev_net_ops))
 		goto out;
 
+	netdev_features_init();
+
 	/*
 	 *	Initialise the packet receive queues.
 	 */
diff --git a/net/core/dev.h b/net/core/dev.h
index cbb8a925175a..b4aae4f2bd9b 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -88,6 +88,8 @@ int dev_change_carrier(struct net_device *dev, bool new_carrier);
 
 void __dev_set_rx_mode(struct net_device *dev);
 
+void __init netdev_features_init(void);
+
 static inline void netif_set_gso_max_size(struct net_device *dev,
 					  unsigned int size)
 {
diff --git a/net/core/netdev_features.c b/net/core/netdev_features.c
new file mode 100644
index 000000000000..a017c8fc6e65
--- /dev/null
+++ b/net/core/netdev_features.c
@@ -0,0 +1,223 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Network device features.
+ */
+
+#include <linux/netdev_features.h>
+#include <linux/netdev_feature_helpers.h>
+
+netdev_features_t netdev_ethtool_features __ro_after_init;
+EXPORT_SYMBOL(netdev_ethtool_features);
+
+netdev_features_t netdev_never_change_features __ro_after_init;
+EXPORT_SYMBOL(netdev_never_change_features);
+
+netdev_features_t netdev_gso_features_mask __ro_after_init;
+EXPORT_SYMBOL(netdev_gso_features_mask);
+
+netdev_features_t netdev_ip_csum_features __ro_after_init;
+EXPORT_SYMBOL(netdev_ip_csum_features);
+
+netdev_features_t netdev_csum_features_mask __ro_after_init;
+EXPORT_SYMBOL(netdev_csum_features_mask);
+
+netdev_features_t netdev_general_tso_features __ro_after_init;
+EXPORT_SYMBOL(netdev_general_tso_features);
+
+netdev_features_t netdev_all_tso_features __ro_after_init;
+EXPORT_SYMBOL(netdev_all_tso_features);
+
+netdev_features_t netdev_tso_ecn_features __ro_after_init;
+EXPORT_SYMBOL(netdev_tso_ecn_features);
+
+netdev_features_t netdev_all_fcoe_features __ro_after_init;
+EXPORT_SYMBOL(netdev_all_fcoe_features);
+
+netdev_features_t netdev_gso_software_features __ro_after_init;
+EXPORT_SYMBOL(netdev_gso_software_features);
+
+netdev_features_t netdev_one_for_all_features __ro_after_init;
+EXPORT_SYMBOL(netdev_one_for_all_features);
+
+netdev_features_t netdev_all_for_all_features __ro_after_init;
+EXPORT_SYMBOL(netdev_all_for_all_features);
+
+netdev_features_t netdev_upper_disable_features __ro_after_init;
+EXPORT_SYMBOL(netdev_upper_disable_features);
+
+netdev_features_t netdev_soft_features __ro_after_init;
+EXPORT_SYMBOL(netdev_soft_features);
+
+netdev_features_t netdev_soft_off_features __ro_after_init;
+EXPORT_SYMBOL(netdev_soft_off_features);
+
+netdev_features_t netdev_all_vlan_features __ro_after_init;
+EXPORT_SYMBOL(netdev_all_vlan_features);
+
+netdev_features_t netdev_vlan_filter_features __ro_after_init;
+EXPORT_SYMBOL(netdev_vlan_filter_features);
+
+netdev_features_t netdev_rx_vlan_features __ro_after_init;
+EXPORT_SYMBOL(netdev_rx_vlan_features);
+
+netdev_features_t netdev_tx_vlan_features __ro_after_init;
+EXPORT_SYMBOL(netdev_tx_vlan_features);
+
+netdev_features_t netdev_ctag_vlan_offload_features __ro_after_init;
+EXPORT_SYMBOL(netdev_ctag_vlan_offload_features);
+
+netdev_features_t netdev_stag_vlan_offload_features __ro_after_init;
+EXPORT_SYMBOL(netdev_stag_vlan_offload_features);
+
+netdev_features_t netdev_vlan_offload_features __ro_after_init;
+EXPORT_SYMBOL(netdev_vlan_offload_features);
+
+netdev_features_t netdev_ctag_vlan_features __ro_after_init;
+EXPORT_SYMBOL(netdev_ctag_vlan_features);
+
+netdev_features_t netdev_stag_vlan_features __ro_after_init;
+EXPORT_SYMBOL(netdev_stag_vlan_features);
+
+netdev_features_t netdev_multi_tags_features_mask __ro_after_init;
+EXPORT_SYMBOL(netdev_multi_tags_features_mask);
+
+netdev_features_t netdev_gso_encap_all_features __ro_after_init;
+EXPORT_SYMBOL(netdev_gso_encap_all_features);
+
+netdev_features_t netdev_xfrm_features __ro_after_init;
+EXPORT_SYMBOL(netdev_xfrm_features);
+
+netdev_features_t netdev_tls_features __ro_after_init;
+EXPORT_SYMBOL(netdev_tls_features);
+
+netdev_features_t netdev_csum_gso_features_mask __ro_after_init;
+EXPORT_SYMBOL(netdev_csum_gso_features_mask);
+
+netdev_features_t netdev_empty_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_empty_features);
+
+void __init netdev_features_init(void)
+{
+	netdev_features_t features;
+
+	netdev_features_set_set(netdev_ip_csum_features,
+				NETIF_F_IP_CSUM_BIT, NETIF_F_IPV6_CSUM_BIT);
+	netdev_features_set_set(netdev_csum_features_mask,
+				NETIF_F_IP_CSUM_BIT, NETIF_F_IPV6_CSUM_BIT,
+				NETIF_F_HW_CSUM_BIT);
+
+	netdev_features_set_set(netdev_gso_features_mask,
+				NETIF_F_TSO_BIT,
+				NETIF_F_GSO_ROBUST_BIT,
+				NETIF_F_TSO_ECN_BIT,
+				NETIF_F_TSO_MANGLEID_BIT,
+				NETIF_F_TSO6_BIT,
+				NETIF_F_FSO_BIT,
+				NETIF_F_GSO_GRE_BIT,
+				NETIF_F_GSO_GRE_CSUM_BIT,
+				NETIF_F_GSO_IPXIP4_BIT,
+				NETIF_F_GSO_IPXIP6_BIT,
+				NETIF_F_GSO_UDP_TUNNEL_BIT,
+				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				NETIF_F_GSO_PARTIAL_BIT,
+				NETIF_F_GSO_TUNNEL_REMCSUM_BIT,
+				NETIF_F_GSO_SCTP_BIT,
+				NETIF_F_GSO_ESP_BIT,
+				NETIF_F_GSO_UDP_BIT,
+				NETIF_F_GSO_UDP_L4_BIT,
+				NETIF_F_GSO_FRAGLIST_BIT);
+	netdev_features_set_set(netdev_general_tso_features,
+				NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT);
+	netdev_features_set_set(netdev_all_tso_features,
+				NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
+				NETIF_F_TSO_ECN_BIT, NETIF_F_TSO_MANGLEID_BIT);
+	netdev_features_set_set(netdev_tso_ecn_features,
+				NETIF_F_TSO_ECN_BIT);
+	netdev_features_set_set(netdev_all_fcoe_features,
+				NETIF_F_FCOE_CRC_BIT, NETIF_F_FCOE_MTU_BIT,
+				NETIF_F_FSO_BIT);
+	netdev_features_set_set(netdev_gso_software_features,
+				NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
+				NETIF_F_TSO_ECN_BIT, NETIF_F_TSO_MANGLEID_BIT,
+				NETIF_F_GSO_SCTP_BIT, NETIF_F_GSO_UDP_L4_BIT,
+				NETIF_F_GSO_FRAGLIST_BIT);
+	netdev_features_set_set(netdev_gso_encap_all_features,
+				NETIF_F_GSO_GRE_BIT, NETIF_F_GSO_GRE_CSUM_BIT,
+				NETIF_F_GSO_IPXIP4_BIT, NETIF_F_GSO_IPXIP6_BIT,
+				NETIF_F_GSO_UDP_TUNNEL_BIT,
+				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+
+	netdev_features_or(netdev_csum_gso_features_mask,
+			   netdev_gso_features_mask, netdev_csum_features_mask);
+
+	netdev_features_set_set(netdev_one_for_all_features,
+				NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
+				NETIF_F_TSO_ECN_BIT, NETIF_F_TSO_MANGLEID_BIT,
+				NETIF_F_GSO_SCTP_BIT, NETIF_F_GSO_UDP_L4_BIT,
+				NETIF_F_GSO_FRAGLIST_BIT,
+				NETIF_F_GSO_ROBUST_BIT, NETIF_F_SG_BIT,
+				NETIF_F_HIGHDMA_BIT, NETIF_F_FRAGLIST_BIT,
+				NETIF_F_VLAN_CHALLENGED_BIT);
+	netdev_features_set_set(netdev_all_for_all_features,
+				NETIF_F_NOCACHE_COPY_BIT, NETIF_F_FSO_BIT);
+
+	netdev_features_set_set(netdev_upper_disable_features, NETIF_F_LRO_BIT);
+
+	netdev_features_set_set(netdev_soft_features,
+				NETIF_F_GSO_BIT, NETIF_F_GRO_BIT);
+	netdev_features_set_set(netdev_soft_off_features,
+				NETIF_F_GRO_FRAGLIST_BIT,
+				NETIF_F_GRO_UDP_FWD_BIT);
+
+	netdev_features_set_set(netdev_rx_vlan_features,
+				NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				NETIF_F_HW_VLAN_STAG_RX_BIT);
+	netdev_features_set_set(netdev_tx_vlan_features,
+				NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				NETIF_F_HW_VLAN_STAG_TX_BIT);
+	netdev_features_set_set(netdev_vlan_filter_features,
+				NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				NETIF_F_HW_VLAN_STAG_FILTER_BIT);
+	netdev_features_set_set(netdev_ctag_vlan_offload_features,
+				NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				NETIF_F_HW_VLAN_CTAG_RX_BIT);
+	netdev_features_set_set(netdev_stag_vlan_offload_features,
+				NETIF_F_HW_VLAN_STAG_TX_BIT,
+				NETIF_F_HW_VLAN_STAG_RX_BIT);
+	netdev_features_or(netdev_vlan_offload_features,
+			   netdev_ctag_vlan_offload_features,
+			   netdev_stag_vlan_offload_features);
+	netdev_features_set_set(netdev_ctag_vlan_features,
+				NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
+	netdev_features_set_set(netdev_stag_vlan_features,
+				NETIF_F_HW_VLAN_STAG_TX_BIT,
+				NETIF_F_HW_VLAN_STAG_RX_BIT,
+				NETIF_F_HW_VLAN_STAG_FILTER_BIT);
+	netdev_features_or(netdev_all_vlan_features, netdev_ctag_vlan_features,
+			   netdev_stag_vlan_features);
+	netdev_features_set_set(netdev_multi_tags_features_mask,
+				NETIF_F_SG_BIT, NETIF_F_HIGHDMA_BIT,
+				NETIF_F_HW_CSUM_BIT, NETIF_F_FRAGLIST_BIT,
+				NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				NETIF_F_HW_VLAN_STAG_TX_BIT);
+
+	netdev_features_set_set(netdev_xfrm_features,
+				NETIF_F_HW_ESP_BIT,
+				NETIF_F_HW_ESP_TX_CSUM_BIT,
+				NETIF_F_GSO_ESP_BIT);
+	netdev_features_set_set(netdev_tls_features,
+				NETIF_F_HW_TLS_TX_BIT,
+				NETIF_F_HW_TLS_RX_BIT);
+
+	netdev_features_set_set(netdev_never_change_features,
+				NETIF_F_VLAN_CHALLENGED_BIT,
+				NETIF_F_LLTX_BIT,
+				NETIF_F_NETNS_LOCAL_BIT);
+	netdev_features_fill(features);
+	netdev_features_andnot(netdev_ethtool_features, features,
+			       netdev_never_change_features);
+
+	netdev_features_zero(netdev_empty_features);
+}
-- 
2.33.0

