Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5080558E543
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiHJDNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiHJDNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:48 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1270281B21
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:46 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4M2Zgr4DZxzjXj1;
        Wed, 10 Aug 2022 11:10:32 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 11:13:43 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv7 PATCH net-next 02/36] net: replace general features macroes with global netdev_features variables
Date:   Wed, 10 Aug 2022 11:05:50 +0800
Message-ID: <20220810030624.34711-3-shenjian15@huawei.com>
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

There are many netdev_features bits group used in kernel. The definition
will be illegal when using feature bit more than 64. Replace these macroes
with global netdev_features variables, initialize them when netdev module
init.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/hyperv/hyperv_net.h |   5 +-
 include/linux/netdev_features.h | 111 +++++++++----
 net/core/Makefile               |   2 +-
 net/core/dev.c                  |  83 ++++++++++
 net/core/netdev_features.c      | 281 ++++++++++++++++++++++++++++++++
 5 files changed, 441 insertions(+), 41 deletions(-)
 create mode 100644 net/core/netdev_features.c

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 25b38a374e3c..6336ed81fb8c 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -873,10 +873,7 @@ struct nvsp_message {
 #define NETVSC_RECEIVE_BUFFER_ID		0xcafe
 #define NETVSC_SEND_BUFFER_ID			0
 
-#define NETVSC_SUPPORTED_HW_FEATURES (NETIF_F_RXCSUM | NETIF_F_IP_CSUM | \
-				      NETIF_F_TSO | NETIF_F_IPV6_CSUM | \
-				      NETIF_F_TSO6 | NETIF_F_LRO | \
-				      NETIF_F_SG | NETIF_F_RXHASH)
+#define NETVSC_SUPPORTED_HW_FEATURES	netvsc_supported_hw_features
 
 #define VRSS_SEND_TAB_SIZE 16  /* must be power of 2 */
 #define VRSS_CHANNEL_MAX 64
diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 9d434b4e6e6e..a005c781fabf 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -7,6 +7,7 @@
 
 #include <linux/types.h>
 #include <linux/bitops.h>
+#include <linux/cache.h>
 #include <asm/byteorder.h>
 
 typedef u64 netdev_features_t;
@@ -112,6 +113,64 @@ enum {
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
+extern netdev_features_t netvsc_supported_hw_features __ro_after_init;
+extern const struct netdev_feature_set netif_f_never_change_feature_set;
+extern const struct netdev_feature_set netif_f_gso_feature_set_mask;
+extern const struct netdev_feature_set netif_f_ip_csum_feature_set;
+extern const struct netdev_feature_set netif_f_csum_feature_set_mask;
+extern const struct netdev_feature_set netif_f_general_tso_feature_set;
+extern const struct netdev_feature_set netif_f_all_tso_feature_set;
+extern const struct netdev_feature_set netif_f_tso_ecn_feature_set;
+extern const struct netdev_feature_set netif_f_all_fcoe_feature_set;
+extern const struct netdev_feature_set netif_f_gso_soft_feature_set;
+extern const struct netdev_feature_set netif_f_one_for_all_feature_set;
+extern const struct netdev_feature_set netif_f_all_for_all_feature_set;
+extern const struct netdev_feature_set netif_f_upper_disables_feature_set;
+extern const struct netdev_feature_set netif_f_soft_feature_set;
+extern const struct netdev_feature_set netif_f_soft_off_feature_set;
+extern const struct netdev_feature_set netif_f_tx_vlan_feature_set;
+extern const struct netdev_feature_set netif_f_rx_vlan_feature_set;
+extern const struct netdev_feature_set netif_f_vlan_filter_feature_set;
+extern const struct netdev_feature_set netif_f_ctag_vlan_feature_set;
+extern const struct netdev_feature_set netif_f_stag_vlan_feature_set;
+extern const struct netdev_feature_set netif_f_ctag_vlan_offload_feature_set;
+extern const struct netdev_feature_set netif_f_stag_vlan_offload_feature_set;
+extern const struct netdev_feature_set netif_f_multi_tags_feature_set_mask;
+extern const struct netdev_feature_set netif_f_gso_encap_feature_set;
+extern const struct netdev_feature_set netif_f_xfrm_feature_set;
+extern const struct netdev_feature_set netif_f_tls_feature_set;
+extern const struct netdev_feature_set netvsc_supported_hw_feature_set;
+
 /* copy'n'paste compression ;) */
 #define __NETIF_F_BIT(bit)	((netdev_features_t)1 << (bit))
 #define __NETIF_F(name)		__NETIF_F_BIT(NETIF_F_##name##_BIT)
@@ -203,73 +262,53 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 
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
index e8ce3bd283a6..360a101584c8 100644
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
index 45e80c84497f..9603bac63ffb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -146,6 +146,7 @@
 #include <linux/sctp.h>
 #include <net/udp_tunnel.h>
 #include <linux/net_namespace.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/indirect_call_wrapper.h>
 #include <net/devlink.h>
 #include <linux/pm_runtime.h>
@@ -11362,6 +11363,86 @@ static struct pernet_operations __net_initdata default_device_ops = {
 	.exit_batch = default_device_exit_batch,
 };
 
+static void __init netdev_features_init(void)
+{
+	netdev_features_t features;
+
+	netdev_features_set_array(&netif_f_ip_csum_feature_set,
+				  &netdev_ip_csum_features);
+	netdev_features_set_array(&netif_f_csum_feature_set_mask,
+				  &netdev_csum_features_mask);
+
+	netdev_features_set_array(&netif_f_gso_feature_set_mask,
+				  &netdev_gso_features_mask);
+	netdev_features_set_array(&netif_f_general_tso_feature_set,
+				  &netdev_general_tso_features);
+	netdev_features_set_array(&netif_f_all_tso_feature_set,
+				  &netdev_all_tso_features);
+	netdev_features_set_array(&netif_f_tso_ecn_feature_set,
+				  &netdev_tso_ecn_features);
+	netdev_features_set_array(&netif_f_all_fcoe_feature_set,
+				  &netdev_all_fcoe_features);
+	netdev_features_set_array(&netif_f_gso_soft_feature_set,
+				  &netdev_gso_software_features);
+	netdev_features_set_array(&netif_f_gso_encap_feature_set,
+				  &netdev_gso_encap_all_features);
+
+	netdev_csum_gso_features_mask =
+		netdev_features_or(netdev_gso_features_mask,
+				   netdev_csum_features_mask);
+
+	netdev_features_set_array(&netif_f_one_for_all_feature_set,
+				  &netdev_one_for_all_features);
+	netdev_features_set_array(&netif_f_all_for_all_feature_set,
+				  &netdev_all_for_all_features);
+
+	netdev_features_set_array(&netif_f_upper_disables_feature_set,
+				  &netdev_upper_disable_features);
+
+	netdev_features_set_array(&netif_f_soft_feature_set,
+				  &netdev_soft_features);
+	netdev_features_set_array(&netif_f_soft_off_feature_set,
+				  &netdev_soft_off_features);
+
+	netdev_features_set_array(&netif_f_rx_vlan_feature_set,
+				  &netdev_rx_vlan_features);
+	netdev_features_set_array(&netif_f_tx_vlan_feature_set,
+				  &netdev_tx_vlan_features);
+	netdev_features_set_array(&netif_f_vlan_filter_feature_set,
+				  &netdev_vlan_filter_features);
+	netdev_all_vlan_features = netdev_features_or(netdev_rx_vlan_features,
+						      netdev_tx_vlan_features);
+	netdev_features_set_array(&netif_f_ctag_vlan_offload_feature_set,
+				  &netdev_ctag_vlan_offload_features);
+	netdev_features_set_array(&netif_f_stag_vlan_offload_feature_set,
+				  &netdev_stag_vlan_offload_features);
+	netdev_vlan_offload_features =
+			netdev_features_or(netdev_ctag_vlan_offload_features,
+					   netdev_stag_vlan_offload_features);
+	netdev_features_set_array(&netif_f_ctag_vlan_feature_set,
+				  &netdev_ctag_vlan_features);
+	netdev_features_set_array(&netif_f_stag_vlan_feature_set,
+				  &netdev_stag_vlan_features);
+	netdev_features_set_array(&netif_f_multi_tags_feature_set_mask,
+				  &netdev_multi_tags_features_mask);
+
+	netdev_features_set_array(&netif_f_xfrm_feature_set,
+				  &netdev_xfrm_features);
+	netdev_features_set_array(&netif_f_tls_feature_set,
+				  &netdev_tls_features);
+
+	netdev_features_set_array(&netif_f_never_change_feature_set,
+				  &netdev_never_change_features);
+	netdev_features_fill(&features);
+	netdev_ethtool_features =
+		netdev_features_andnot(features, netdev_never_change_features);
+
+	netdev_features_zero(&netdev_empty_features);
+
+	netdev_features_set_array(&netvsc_supported_hw_feature_set,
+				  &netvsc_supported_hw_features);
+}
+
 /*
  *	Initialize the DEV module. At boot time this walks the device list and
  *	unhooks any devices that fail to initialise (normally hardware not
@@ -11392,6 +11473,8 @@ static int __init net_dev_init(void)
 	if (register_pernet_subsys(&netdev_net_ops))
 		goto out;
 
+	netdev_features_init();
+
 	/*
 	 *	Initialise the packet receive queues.
 	 */
diff --git a/net/core/netdev_features.c b/net/core/netdev_features.c
new file mode 100644
index 000000000000..158c750ea7a2
--- /dev/null
+++ b/net/core/netdev_features.c
@@ -0,0 +1,281 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Network device features.
+ */
+
+#include <linux/netdev_features.h>
+
+netdev_features_t netdev_ethtool_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_ethtool_features);
+
+netdev_features_t netdev_never_change_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_never_change_features);
+
+netdev_features_t netdev_gso_features_mask __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_gso_features_mask);
+
+netdev_features_t netdev_ip_csum_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_ip_csum_features);
+
+netdev_features_t netdev_csum_features_mask __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_csum_features_mask);
+
+netdev_features_t netdev_general_tso_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_general_tso_features);
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
+netdev_features_t netdev_all_vlan_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_all_vlan_features);
+
+netdev_features_t netdev_vlan_filter_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_vlan_filter_features);
+
+netdev_features_t netdev_rx_vlan_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_rx_vlan_features);
+
+netdev_features_t netdev_tx_vlan_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_tx_vlan_features);
+
+netdev_features_t netdev_ctag_vlan_offload_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_ctag_vlan_offload_features);
+
+netdev_features_t netdev_stag_vlan_offload_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_stag_vlan_offload_features);
+
+netdev_features_t netdev_vlan_offload_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_vlan_offload_features);
+
+netdev_features_t netdev_ctag_vlan_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_ctag_vlan_features);
+
+netdev_features_t netdev_stag_vlan_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_stag_vlan_features);
+
+netdev_features_t netdev_multi_tags_features_mask __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_multi_tags_features_mask);
+
+netdev_features_t netdev_gso_encap_all_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_gso_encap_all_features);
+
+netdev_features_t netdev_xfrm_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_xfrm_features);
+
+netdev_features_t netdev_tls_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_tls_features);
+
+netdev_features_t netdev_csum_gso_features_mask __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_csum_gso_features_mask);
+
+netdev_features_t netdev_empty_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_empty_features);
+
+netdev_features_t netvsc_supported_hw_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netvsc_supported_hw_features);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_never_change_feature_set,
+			   NETIF_F_VLAN_CHALLENGED_BIT,
+			   NETIF_F_LLTX_BIT,
+			   NETIF_F_NETNS_LOCAL_BIT);
+EXPORT_SYMBOL_GPL(netif_f_never_change_feature_set);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_gso_feature_set_mask,
+			   NETIF_F_TSO_BIT,
+			   NETIF_F_GSO_ROBUST_BIT,
+			   NETIF_F_TSO_ECN_BIT,
+			   NETIF_F_TSO_MANGLEID_BIT,
+			   NETIF_F_TSO6_BIT,
+			   NETIF_F_FSO_BIT,
+			   NETIF_F_GSO_GRE_BIT,
+			   NETIF_F_GSO_GRE_CSUM_BIT,
+			   NETIF_F_GSO_IPXIP4_BIT,
+			   NETIF_F_GSO_IPXIP6_BIT,
+			   NETIF_F_GSO_UDP_TUNNEL_BIT,
+			   NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+			   NETIF_F_GSO_PARTIAL_BIT,
+			   NETIF_F_GSO_TUNNEL_REMCSUM_BIT,
+			   NETIF_F_GSO_SCTP_BIT,
+			   NETIF_F_GSO_ESP_BIT,
+			   NETIF_F_GSO_UDP_BIT,
+			   NETIF_F_GSO_UDP_L4_BIT,
+			   NETIF_F_GSO_FRAGLIST_BIT);
+EXPORT_SYMBOL_GPL(netif_f_gso_feature_set_mask);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_ip_csum_feature_set,
+			   NETIF_F_IP_CSUM_BIT,
+			   NETIF_F_IPV6_CSUM_BIT);
+EXPORT_SYMBOL_GPL(netif_f_ip_csum_feature_set);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_csum_feature_set_mask,
+			   NETIF_F_IP_CSUM_BIT,
+			   NETIF_F_IPV6_CSUM_BIT,
+			   NETIF_F_HW_CSUM_BIT);
+EXPORT_SYMBOL_GPL(netif_f_csum_feature_set_mask);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_general_tso_feature_set,
+			   NETIF_F_TSO_BIT,
+			   NETIF_F_TSO6_BIT);
+EXPORT_SYMBOL_GPL(netif_f_general_tso_feature_set);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_all_tso_feature_set,
+			   NETIF_F_TSO_BIT,
+			   NETIF_F_TSO6_BIT,
+			   NETIF_F_TSO_ECN_BIT,
+			   NETIF_F_TSO_MANGLEID_BIT);
+EXPORT_SYMBOL_GPL(netif_f_all_tso_feature_set);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_tso_ecn_feature_set,
+			   NETIF_F_TSO_ECN_BIT);
+EXPORT_SYMBOL_GPL(netif_f_tso_ecn_feature_set);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_all_fcoe_feature_set,
+			   NETIF_F_FCOE_CRC_BIT,
+			   NETIF_F_FCOE_MTU_BIT,
+			   NETIF_F_FSO_BIT);
+EXPORT_SYMBOL_GPL(netif_f_all_fcoe_feature_set);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_gso_soft_feature_set,
+			   NETIF_F_TSO_BIT,
+			   NETIF_F_TSO6_BIT,
+			   NETIF_F_TSO_ECN_BIT,
+			   NETIF_F_TSO_MANGLEID_BIT,
+			   NETIF_F_GSO_SCTP_BIT,
+			   NETIF_F_GSO_UDP_L4_BIT,
+			   NETIF_F_GSO_FRAGLIST_BIT);
+EXPORT_SYMBOL_GPL(netif_f_gso_soft_feature_set);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_one_for_all_feature_set,
+			   NETIF_F_TSO_BIT,
+			   NETIF_F_TSO6_BIT,
+			   NETIF_F_TSO_ECN_BIT,
+			   NETIF_F_TSO_MANGLEID_BIT,
+			   NETIF_F_GSO_SCTP_BIT,
+			   NETIF_F_GSO_UDP_L4_BIT,
+			   NETIF_F_GSO_FRAGLIST_BIT,
+			   NETIF_F_GSO_ROBUST_BIT,
+			   NETIF_F_SG_BIT,
+			   NETIF_F_HIGHDMA_BIT,
+			   NETIF_F_FRAGLIST_BIT,
+			   NETIF_F_VLAN_CHALLENGED_BIT);
+EXPORT_SYMBOL_GPL(netif_f_one_for_all_feature_set);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_all_for_all_feature_set,
+			   NETIF_F_NOCACHE_COPY_BIT,
+			   NETIF_F_FSO_BIT);
+EXPORT_SYMBOL_GPL(netif_f_all_for_all_feature_set);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_upper_disables_feature_set,
+			   NETIF_F_LRO_BIT);
+EXPORT_SYMBOL_GPL(netif_f_upper_disables_feature_set);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_soft_feature_set,
+			   NETIF_F_GSO_BIT,
+			   NETIF_F_GRO_BIT);
+EXPORT_SYMBOL_GPL(netif_f_soft_feature_set);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_soft_off_feature_set,
+			   NETIF_F_GRO_FRAGLIST_BIT,
+			   NETIF_F_GRO_UDP_FWD_BIT);
+EXPORT_SYMBOL_GPL(netif_f_soft_off_feature_set);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_tx_vlan_feature_set,
+			   NETIF_F_HW_VLAN_CTAG_TX_BIT,
+			   NETIF_F_HW_VLAN_STAG_TX_BIT);
+EXPORT_SYMBOL_GPL(netif_f_tx_vlan_feature_set);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_rx_vlan_feature_set,
+			   NETIF_F_HW_VLAN_CTAG_RX_BIT,
+			   NETIF_F_HW_VLAN_STAG_RX_BIT);
+EXPORT_SYMBOL_GPL(netif_f_rx_vlan_feature_set);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_vlan_filter_feature_set,
+			   NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+			   NETIF_F_HW_VLAN_STAG_FILTER_BIT);
+EXPORT_SYMBOL_GPL(netif_f_vlan_filter_feature_set);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_ctag_vlan_offload_feature_set,
+			   NETIF_F_HW_VLAN_CTAG_TX_BIT,
+			   NETIF_F_HW_VLAN_CTAG_RX_BIT);
+EXPORT_SYMBOL_GPL(netif_f_ctag_vlan_offload_feature_set);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_stag_vlan_offload_feature_set,
+			   NETIF_F_HW_VLAN_STAG_TX_BIT,
+			   NETIF_F_HW_VLAN_STAG_RX_BIT);
+EXPORT_SYMBOL_GPL(netif_f_stag_vlan_offload_feature_set);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_ctag_vlan_feature_set,
+			   NETIF_F_HW_VLAN_CTAG_TX_BIT,
+			   NETIF_F_HW_VLAN_CTAG_RX_BIT,
+			   NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
+EXPORT_SYMBOL_GPL(netif_f_ctag_vlan_feature_set);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_stag_vlan_feature_set,
+			   NETIF_F_HW_VLAN_STAG_TX_BIT,
+			   NETIF_F_HW_VLAN_STAG_RX_BIT,
+			   NETIF_F_HW_VLAN_STAG_FILTER_BIT);
+EXPORT_SYMBOL_GPL(netif_f_stag_vlan_feature_set);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_multi_tags_feature_set_mask,
+			   NETIF_F_SG_BIT,
+			   NETIF_F_HIGHDMA_BIT,
+			   NETIF_F_HW_CSUM_BIT,
+			   NETIF_F_FRAGLIST_BIT,
+			   NETIF_F_HW_VLAN_CTAG_TX_BIT,
+			   NETIF_F_HW_VLAN_STAG_TX_BIT);
+EXPORT_SYMBOL_GPL(netif_f_multi_tags_feature_set_mask);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_gso_encap_feature_set,
+			   NETIF_F_GSO_GRE_BIT,
+			   NETIF_F_GSO_GRE_CSUM_BIT,
+			   NETIF_F_GSO_IPXIP4_BIT,
+			   NETIF_F_GSO_IPXIP6_BIT,
+			   NETIF_F_GSO_UDP_TUNNEL_BIT,
+			   NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+EXPORT_SYMBOL_GPL(netif_f_gso_encap_feature_set);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_xfrm_feature_set,
+			   NETIF_F_HW_ESP_BIT,
+			   NETIF_F_HW_ESP_TX_CSUM_BIT,
+			   NETIF_F_GSO_ESP_BIT);
+EXPORT_SYMBOL_GPL(netif_f_xfrm_feature_set);
+
+DECLARE_NETDEV_FEATURE_SET(netif_f_tls_feature_set,
+			   NETIF_F_HW_TLS_TX_BIT,
+			   NETIF_F_HW_TLS_RX_BIT);
+EXPORT_SYMBOL_GPL(netif_f_tls_feature_set);
+
+DECLARE_NETDEV_FEATURE_SET(netvsc_supported_hw_feature_set,
+			   NETIF_F_RXCSUM_BIT,
+			   NETIF_F_IP_CSUM_BIT,
+			   NETIF_F_TSO_BIT,
+			   NETIF_F_IPV6_CSUM_BIT,
+			   NETIF_F_TSO6_BIT,
+			   NETIF_F_LRO_BIT,
+			   NETIF_F_SG_BIT,
+			   NETIF_F_RXHASH_BIT);
+EXPORT_SYMBOL_GPL(netvsc_supported_hw_feature_set);
-- 
2.33.0

