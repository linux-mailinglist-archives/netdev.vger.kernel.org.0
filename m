Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0304E4E6669
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 16:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351443AbiCXP4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 11:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351430AbiCXP4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 11:56:46 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE39AC93B
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 08:55:11 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KPVBP2JSqzfZhN;
        Thu, 24 Mar 2022 23:53:33 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Mar 2022 23:55:07 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>,
        <lipeng321@huawei.com>
Subject: [RFCv5 PATCH net-next 03/20] net: replace general features macroes with global netdev_features variables
Date:   Thu, 24 Mar 2022 23:49:15 +0800
Message-ID: <20220324154932.17557-4-shenjian15@huawei.com>
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

There are many netdev_features bits group used in kernel. The definition
will be illegal when using feature bit more than 64. Replace these macroes
with global netdev_features variables, initialize them when netdev module
init.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 include/linux/netdev_features.h | 104 +++++++-----
 net/core/dev.c                  | 113 +++++++++++++
 net/core/netdev_features.c      | 276 ++++++++++++++++++++++++++++++++
 3 files changed, 457 insertions(+), 36 deletions(-)
 create mode 100644 net/core/netdev_features.c

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 2c6b9e416225..b25f2bb31f94 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -190,75 +190,107 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 	     (bit) >= 0;						\
 	     (bit) = find_next_netdev_feature((mask_addr), (bit) - 1))
 
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
+extern netdev_features_t netdev_ctag_vlan_features __ro_after_init;
+extern netdev_features_t netdev_stag_vlan_features __ro_after_init;
+extern netdev_features_t netdev_vlan_filter_features __ro_after_init;
+extern netdev_features_t netdev_gso_encap_all_features __ro_after_init;
+extern netdev_features_t netdev_xfrm_features __ro_after_init;
+extern netdev_features_t netdev_tls_features __ro_after_init;
+extern netdev_features_t netdev_csum_gso_features_mask __ro_after_init;
+extern netdev_features_t netdev_vlan_features_mask __ro_after_init;
+
+extern const int netif_f_never_change_array[3];
+extern const int netif_f_gso_mask_array[19];
+extern const int netif_f_ip_csum_array[2];
+extern const int netif_f_csum_mask_array[3];
+extern const int netif_f_general_tso_array[2];
+extern const int netif_f_all_tso_array[4];
+extern const int netif_f_tso_ecn_array[1];
+extern const int netif_f_all_fcoe_array[3];
+extern const int netif_f_gso_soft_array[7];
+extern const int netif_f_one_for_all_array[12];
+extern const int netif_f_all_for_all_array[2];
+extern const int netif_f_upper_disables_array[1];
+extern const int netif_f_soft_array[2];
+extern const int netif_f_soft_off_array[2];
+extern const int netif_f_vlan_array[6];
+extern const int netif_f_tx_vlan_array[2];
+extern const int netif_f_rx_vlan_array[2];
+extern const int netif_f_ctag_vlan_array[2];
+extern const int netif_f_stag_vlan_array[2];
+extern const int netif_f_vlan_filter_array[2];
+extern const int netif_f_gso_encap_array[6];
+extern const int netif_f_xfrm_array[3];
+extern const int netif_f_tls_array[2];
+extern const int netif_f_vlan_mask_array[6];
+
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
diff --git a/net/core/dev.c b/net/core/dev.c
index a09ddbfb3086..67e4c67f5064 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11229,6 +11229,117 @@ static struct pernet_operations __net_initdata default_device_ops = {
 	.exit_batch = default_device_exit_batch,
 };
 
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
+				  &netdev_gso_features_mask);
+
+	netdev_features_set_array(netif_f_ip_csum_array,
+				  ARRAY_SIZE(netif_f_ip_csum_array),
+				  &netdev_ip_csum_features);
+
+	netdev_features_set_array(netif_f_csum_mask_array,
+				  ARRAY_SIZE(netif_f_csum_mask_array),
+				  &netdev_csum_features_mask);
+
+	netdev_features_set_array(netif_f_general_tso_array,
+				  ARRAY_SIZE(netif_f_general_tso_array),
+				  &netdev_general_tso_features);
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
+				  &netdev_upper_disable_features);
+
+	netdev_features_set_array(netif_f_soft_array,
+				  ARRAY_SIZE(netif_f_soft_array),
+				  &netdev_soft_features);
+
+	netdev_features_set_array(netif_f_soft_off_array,
+				  ARRAY_SIZE(netif_f_soft_off_array),
+				  &netdev_soft_off_features);
+
+	netdev_features_set_array(netif_f_rx_vlan_array,
+				  ARRAY_SIZE(netif_f_rx_vlan_array),
+				  &netdev_rx_vlan_features);
+
+	netdev_features_set_array(netif_f_tx_vlan_array,
+				  ARRAY_SIZE(netif_f_tx_vlan_array),
+				  &netdev_tx_vlan_features);
+
+	netdev_features_set_array(netif_f_vlan_filter_array,
+				  ARRAY_SIZE(netif_f_vlan_filter_array),
+				  &netdev_vlan_filter_features);
+
+	netdev_all_vlan_features = netdev_rx_vlan_features;
+	netdev_features_direct_or(&netdev_all_vlan_features,
+				  netdev_tx_vlan_features);
+	netdev_features_direct_or(&netdev_all_vlan_features,
+				  netdev_vlan_filter_features);
+
+	netdev_features_set_array(netif_f_ctag_vlan_array,
+				  ARRAY_SIZE(netif_f_ctag_vlan_array),
+				  &netdev_ctag_vlan_features);
+
+	netdev_features_set_array(netif_f_stag_vlan_array,
+				  ARRAY_SIZE(netif_f_stag_vlan_array),
+				  &netdev_stag_vlan_features);
+
+	netdev_features_set_array(netif_f_gso_encap_array,
+				  ARRAY_SIZE(netif_f_gso_encap_array),
+				  &netdev_gso_encap_all_features);
+
+	netdev_features_set_array(netif_f_xfrm_array,
+				  ARRAY_SIZE(netif_f_xfrm_array),
+				  &netdev_xfrm_features);
+
+	netdev_features_set_array(netif_f_tls_array,
+				  ARRAY_SIZE(netif_f_tls_array),
+				  &netdev_tls_features);
+
+	netdev_features_set_array(netif_f_vlan_mask_array,
+				  ARRAY_SIZE(netif_f_vlan_mask_array),
+				  &netdev_vlan_features_mask);
+
+	netdev_csum_gso_features_mask =
+		netdev_features_or(netdev_gso_software_features,
+				   netdev_csum_features_mask);
+
+	netdev_features_fill(&features);
+	netdev_ethtool_features =
+		netdev_features_andnot(features, netdev_never_change_features);
+}
+
 /*
  *	Initialize the DEV module. At boot time this walks the device list and
  *	unhooks any devices that fail to initialise (normally hardware not
@@ -11259,6 +11370,8 @@ static int __init net_dev_init(void)
 	if (register_pernet_subsys(&netdev_net_ops))
 		goto out;
 
+	netdev_features_init();
+
 	/*
 	 *	Initialise the packet receive queues.
 	 */
diff --git a/net/core/netdev_features.c b/net/core/netdev_features.c
new file mode 100644
index 000000000000..e92353428ee7
--- /dev/null
+++ b/net/core/netdev_features.c
@@ -0,0 +1,276 @@
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
+netdev_features_t netdev_ctag_vlan_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_ctag_vlan_features);
+
+netdev_features_t netdev_stag_vlan_features __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_stag_vlan_features);
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
+netdev_features_t netdev_vlan_features_mask __ro_after_init;
+EXPORT_SYMBOL_GPL(netdev_vlan_features_mask);
+
+const int netif_f_never_change_array[] = {
+	NETIF_F_VLAN_CHALLENGED_BIT,
+	NETIF_F_LLTX_BIT,
+	NETIF_F_NETNS_LOCAL_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_never_change_array);
+
+const int netif_f_gso_mask_array[] = {
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
+const int netif_f_ip_csum_array[] = {
+	NETIF_F_IP_CSUM_BIT,
+	NETIF_F_IPV6_CSUM_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_ip_csum_array);
+
+const int netif_f_csum_mask_array[] = {
+	NETIF_F_IP_CSUM_BIT,
+	NETIF_F_IPV6_CSUM_BIT,
+	NETIF_F_HW_CSUM_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_csum_mask_array);
+
+const int netif_f_general_tso_array[] = {
+	NETIF_F_TSO_BIT,
+	NETIF_F_TSO6_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_general_tso_array);
+
+const int netif_f_all_tso_array[] = {
+	NETIF_F_TSO_BIT,
+	NETIF_F_TSO6_BIT,
+	NETIF_F_TSO_ECN_BIT,
+	NETIF_F_TSO_MANGLEID_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_all_tso_array);
+
+const int netif_f_tso_ecn_array[] = {
+	NETIF_F_TSO_ECN_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_tso_ecn_array);
+
+const int netif_f_all_fcoe_array[] = {
+	NETIF_F_FCOE_CRC_BIT,
+	NETIF_F_FCOE_MTU_BIT,
+	NETIF_F_FSO_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_all_fcoe_array);
+
+const int netif_f_gso_soft_array[] = {
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
+const int netif_f_one_for_all_array[] = {
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
+const int netif_f_all_for_all_array[] = {
+	NETIF_F_NOCACHE_COPY_BIT,
+	NETIF_F_FSO_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_all_for_all_array);
+
+const int netif_f_upper_disables_array[] = {
+	NETIF_F_LRO_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_upper_disables_array);
+
+const int netif_f_soft_array[] = {
+	NETIF_F_GSO_BIT,
+	NETIF_F_GRO_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_soft_array);
+
+const int netif_f_soft_off_array[] = {
+	NETIF_F_GRO_FRAGLIST_BIT,
+	NETIF_F_GRO_UDP_FWD_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_soft_off_array);
+
+const int netif_f_vlan_array[] = {
+	NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+	NETIF_F_HW_VLAN_CTAG_RX_BIT,
+	NETIF_F_HW_VLAN_CTAG_TX_BIT,
+	NETIF_F_HW_VLAN_STAG_FILTER_BIT,
+	NETIF_F_HW_VLAN_STAG_RX_BIT,
+	NETIF_F_HW_VLAN_STAG_TX_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_vlan_array);
+
+const int netif_f_tx_vlan_array[] = {
+	NETIF_F_HW_VLAN_CTAG_TX_BIT,
+	NETIF_F_HW_VLAN_STAG_TX_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_tx_vlan_array);
+
+const int netif_f_rx_vlan_array[] = {
+	NETIF_F_HW_VLAN_CTAG_RX_BIT,
+	NETIF_F_HW_VLAN_STAG_RX_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_rx_vlan_array);
+
+const int netif_f_vlan_filter_array[] = {
+	NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+	NETIF_F_HW_VLAN_STAG_FILTER_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_vlan_filter_array);
+
+const int netif_f_ctag_vlan_array[] = {
+	NETIF_F_HW_VLAN_CTAG_TX_BIT,
+	NETIF_F_HW_VLAN_CTAG_RX_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_ctag_vlan_array);
+
+const int netif_f_stag_vlan_array[] = {
+	NETIF_F_HW_VLAN_STAG_TX_BIT,
+	NETIF_F_HW_VLAN_STAG_RX_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_stag_vlan_array);
+
+const int netif_f_gso_encap_array[] = {
+	NETIF_F_GSO_GRE_BIT,
+	NETIF_F_GSO_GRE_CSUM_BIT,
+	NETIF_F_GSO_IPXIP4_BIT,
+	NETIF_F_GSO_IPXIP6_BIT,
+	NETIF_F_GSO_UDP_TUNNEL_BIT,
+	NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+};
+EXPORT_SYMBOL_GPL(netif_f_gso_encap_array);
+
+const int netif_f_xfrm_array[] = {
+	NETIF_F_HW_ESP_BIT,
+	NETIF_F_HW_ESP_TX_CSUM_BIT,
+	NETIF_F_GSO_ESP_BIT
+};
+EXPORT_SYMBOL_GPL(netif_f_xfrm_array);
+
+const int netif_f_tls_array[] = {
+	NETIF_F_HW_TLS_TX_BIT,
+	NETIF_F_HW_TLS_RX_BIT
+};
+EXPORT_SYMBOL_GPL(netif_f_tls_array);
+
+const int netif_f_vlan_mask_array[] = {
+	NETIF_F_SG_BIT,
+	NETIF_F_HIGHDMA_BIT,
+	NETIF_F_HW_CSUM_BIT,
+	NETIF_F_FRAGLIST_BIT,
+	NETIF_F_HW_VLAN_CTAG_TX_BIT,
+	NETIF_F_HW_VLAN_STAG_TX_BIT
+};
+EXPORT_SYMBOL_GPL(netif_f_vlan_mask_array);
-- 
2.33.0

