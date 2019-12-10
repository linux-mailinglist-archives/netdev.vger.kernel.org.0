Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 487C9118930
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 14:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbfLJNIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 08:08:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:49276 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727335AbfLJNIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 08:08:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B544CAD0F;
        Tue, 10 Dec 2019 13:08:08 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 669C1E00E0; Tue, 10 Dec 2019 14:08:08 +0100 (CET)
Message-Id: <dc15c317b1979aec8276cc2eb36f541f29a67b6e.1575982069.git.mkubecek@suse.cz>
In-Reply-To: <cover.1575982069.git.mkubecek@suse.cz>
References: <cover.1575982069.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v2 4/5] ethtool: move string arrays into common file
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Tue, 10 Dec 2019 14:08:08 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce file net/ethtool/common.c for code shared by ioctl and netlink
ethtool interface. Move name tables of features, RSS hash functions,
tunables and PHY tunables into this file.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 net/ethtool/Makefile |  2 +-
 net/ethtool/common.c | 85 ++++++++++++++++++++++++++++++++++++++++++++
 net/ethtool/common.h | 17 +++++++++
 net/ethtool/ioctl.c  | 84 ++-----------------------------------------
 4 files changed, 105 insertions(+), 83 deletions(-)
 create mode 100644 net/ethtool/common.c
 create mode 100644 net/ethtool/common.h

diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 3ebfab2bca66..fe70d3a1d545 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-y		+= ioctl.o
+obj-y		+= ioctl.o common.o
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
new file mode 100644
index 000000000000..220d6b539180
--- /dev/null
+++ b/net/ethtool/common.c
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
+
+#include "common.h"
+
+const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
+	[NETIF_F_SG_BIT] =               "tx-scatter-gather",
+	[NETIF_F_IP_CSUM_BIT] =          "tx-checksum-ipv4",
+	[NETIF_F_HW_CSUM_BIT] =          "tx-checksum-ip-generic",
+	[NETIF_F_IPV6_CSUM_BIT] =        "tx-checksum-ipv6",
+	[NETIF_F_HIGHDMA_BIT] =          "highdma",
+	[NETIF_F_FRAGLIST_BIT] =         "tx-scatter-gather-fraglist",
+	[NETIF_F_HW_VLAN_CTAG_TX_BIT] =  "tx-vlan-hw-insert",
+
+	[NETIF_F_HW_VLAN_CTAG_RX_BIT] =  "rx-vlan-hw-parse",
+	[NETIF_F_HW_VLAN_CTAG_FILTER_BIT] = "rx-vlan-filter",
+	[NETIF_F_HW_VLAN_STAG_TX_BIT] =  "tx-vlan-stag-hw-insert",
+	[NETIF_F_HW_VLAN_STAG_RX_BIT] =  "rx-vlan-stag-hw-parse",
+	[NETIF_F_HW_VLAN_STAG_FILTER_BIT] = "rx-vlan-stag-filter",
+	[NETIF_F_VLAN_CHALLENGED_BIT] =  "vlan-challenged",
+	[NETIF_F_GSO_BIT] =              "tx-generic-segmentation",
+	[NETIF_F_LLTX_BIT] =             "tx-lockless",
+	[NETIF_F_NETNS_LOCAL_BIT] =      "netns-local",
+	[NETIF_F_GRO_BIT] =              "rx-gro",
+	[NETIF_F_GRO_HW_BIT] =           "rx-gro-hw",
+	[NETIF_F_LRO_BIT] =              "rx-lro",
+
+	[NETIF_F_TSO_BIT] =              "tx-tcp-segmentation",
+	[NETIF_F_GSO_ROBUST_BIT] =       "tx-gso-robust",
+	[NETIF_F_TSO_ECN_BIT] =          "tx-tcp-ecn-segmentation",
+	[NETIF_F_TSO_MANGLEID_BIT] =	 "tx-tcp-mangleid-segmentation",
+	[NETIF_F_TSO6_BIT] =             "tx-tcp6-segmentation",
+	[NETIF_F_FSO_BIT] =              "tx-fcoe-segmentation",
+	[NETIF_F_GSO_GRE_BIT] =		 "tx-gre-segmentation",
+	[NETIF_F_GSO_GRE_CSUM_BIT] =	 "tx-gre-csum-segmentation",
+	[NETIF_F_GSO_IPXIP4_BIT] =	 "tx-ipxip4-segmentation",
+	[NETIF_F_GSO_IPXIP6_BIT] =	 "tx-ipxip6-segmentation",
+	[NETIF_F_GSO_UDP_TUNNEL_BIT] =	 "tx-udp_tnl-segmentation",
+	[NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT] = "tx-udp_tnl-csum-segmentation",
+	[NETIF_F_GSO_PARTIAL_BIT] =	 "tx-gso-partial",
+	[NETIF_F_GSO_SCTP_BIT] =	 "tx-sctp-segmentation",
+	[NETIF_F_GSO_ESP_BIT] =		 "tx-esp-segmentation",
+	[NETIF_F_GSO_UDP_L4_BIT] =	 "tx-udp-segmentation",
+
+	[NETIF_F_FCOE_CRC_BIT] =         "tx-checksum-fcoe-crc",
+	[NETIF_F_SCTP_CRC_BIT] =        "tx-checksum-sctp",
+	[NETIF_F_FCOE_MTU_BIT] =         "fcoe-mtu",
+	[NETIF_F_NTUPLE_BIT] =           "rx-ntuple-filter",
+	[NETIF_F_RXHASH_BIT] =           "rx-hashing",
+	[NETIF_F_RXCSUM_BIT] =           "rx-checksum",
+	[NETIF_F_NOCACHE_COPY_BIT] =     "tx-nocache-copy",
+	[NETIF_F_LOOPBACK_BIT] =         "loopback",
+	[NETIF_F_RXFCS_BIT] =            "rx-fcs",
+	[NETIF_F_RXALL_BIT] =            "rx-all",
+	[NETIF_F_HW_L2FW_DOFFLOAD_BIT] = "l2-fwd-offload",
+	[NETIF_F_HW_TC_BIT] =		 "hw-tc-offload",
+	[NETIF_F_HW_ESP_BIT] =		 "esp-hw-offload",
+	[NETIF_F_HW_ESP_TX_CSUM_BIT] =	 "esp-tx-csum-hw-offload",
+	[NETIF_F_RX_UDP_TUNNEL_PORT_BIT] =	 "rx-udp_tunnel-port-offload",
+	[NETIF_F_HW_TLS_RECORD_BIT] =	"tls-hw-record",
+	[NETIF_F_HW_TLS_TX_BIT] =	 "tls-hw-tx-offload",
+	[NETIF_F_HW_TLS_RX_BIT] =	 "tls-hw-rx-offload",
+};
+
+const char
+rss_hash_func_strings[ETH_RSS_HASH_FUNCS_COUNT][ETH_GSTRING_LEN] = {
+	[ETH_RSS_HASH_TOP_BIT] =	"toeplitz",
+	[ETH_RSS_HASH_XOR_BIT] =	"xor",
+	[ETH_RSS_HASH_CRC32_BIT] =	"crc32",
+};
+
+const char
+tunable_strings[__ETHTOOL_TUNABLE_COUNT][ETH_GSTRING_LEN] = {
+	[ETHTOOL_ID_UNSPEC]     = "Unspec",
+	[ETHTOOL_RX_COPYBREAK]	= "rx-copybreak",
+	[ETHTOOL_TX_COPYBREAK]	= "tx-copybreak",
+	[ETHTOOL_PFC_PREVENTION_TOUT] = "pfc-prevention-tout",
+};
+
+const char
+phy_tunable_strings[__ETHTOOL_PHY_TUNABLE_COUNT][ETH_GSTRING_LEN] = {
+	[ETHTOOL_ID_UNSPEC]     = "Unspec",
+	[ETHTOOL_PHY_DOWNSHIFT]	= "phy-downshift",
+	[ETHTOOL_PHY_FAST_LINK_DOWN] = "phy-fast-link-down",
+	[ETHTOOL_PHY_EDPD]	= "phy-energy-detect-power-down",
+};
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
new file mode 100644
index 000000000000..41b2efc1e4e1
--- /dev/null
+++ b/net/ethtool/common.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+#ifndef _ETHTOOL_COMMON_H
+#define _ETHTOOL_COMMON_H
+
+#include <linux/ethtool.h>
+
+extern const char
+netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN];
+extern const char
+rss_hash_func_strings[ETH_RSS_HASH_FUNCS_COUNT][ETH_GSTRING_LEN];
+extern const char
+tunable_strings[__ETHTOOL_TUNABLE_COUNT][ETH_GSTRING_LEN];
+extern const char
+phy_tunable_strings[__ETHTOOL_PHY_TUNABLE_COUNT][ETH_GSTRING_LEN];
+
+#endif /* _ETHTOOL_COMMON_H */
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index cd9bc67381b2..b262db5a1d91 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -27,6 +27,8 @@
 #include <net/xdp_sock.h>
 #include <net/flow_offload.h>
 
+#include "common.h"
+
 /*
  * Some useful ethtool_ops methods that're device independent.
  * If we find that all drivers want to do the same thing here,
@@ -54,88 +56,6 @@ EXPORT_SYMBOL(ethtool_op_get_ts_info);
 
 #define ETHTOOL_DEV_FEATURE_WORDS	((NETDEV_FEATURE_COUNT + 31) / 32)
 
-static const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
-	[NETIF_F_SG_BIT] =               "tx-scatter-gather",
-	[NETIF_F_IP_CSUM_BIT] =          "tx-checksum-ipv4",
-	[NETIF_F_HW_CSUM_BIT] =          "tx-checksum-ip-generic",
-	[NETIF_F_IPV6_CSUM_BIT] =        "tx-checksum-ipv6",
-	[NETIF_F_HIGHDMA_BIT] =          "highdma",
-	[NETIF_F_FRAGLIST_BIT] =         "tx-scatter-gather-fraglist",
-	[NETIF_F_HW_VLAN_CTAG_TX_BIT] =  "tx-vlan-hw-insert",
-
-	[NETIF_F_HW_VLAN_CTAG_RX_BIT] =  "rx-vlan-hw-parse",
-	[NETIF_F_HW_VLAN_CTAG_FILTER_BIT] = "rx-vlan-filter",
-	[NETIF_F_HW_VLAN_STAG_TX_BIT] =  "tx-vlan-stag-hw-insert",
-	[NETIF_F_HW_VLAN_STAG_RX_BIT] =  "rx-vlan-stag-hw-parse",
-	[NETIF_F_HW_VLAN_STAG_FILTER_BIT] = "rx-vlan-stag-filter",
-	[NETIF_F_VLAN_CHALLENGED_BIT] =  "vlan-challenged",
-	[NETIF_F_GSO_BIT] =              "tx-generic-segmentation",
-	[NETIF_F_LLTX_BIT] =             "tx-lockless",
-	[NETIF_F_NETNS_LOCAL_BIT] =      "netns-local",
-	[NETIF_F_GRO_BIT] =              "rx-gro",
-	[NETIF_F_GRO_HW_BIT] =           "rx-gro-hw",
-	[NETIF_F_LRO_BIT] =              "rx-lro",
-
-	[NETIF_F_TSO_BIT] =              "tx-tcp-segmentation",
-	[NETIF_F_GSO_ROBUST_BIT] =       "tx-gso-robust",
-	[NETIF_F_TSO_ECN_BIT] =          "tx-tcp-ecn-segmentation",
-	[NETIF_F_TSO_MANGLEID_BIT] =	 "tx-tcp-mangleid-segmentation",
-	[NETIF_F_TSO6_BIT] =             "tx-tcp6-segmentation",
-	[NETIF_F_FSO_BIT] =              "tx-fcoe-segmentation",
-	[NETIF_F_GSO_GRE_BIT] =		 "tx-gre-segmentation",
-	[NETIF_F_GSO_GRE_CSUM_BIT] =	 "tx-gre-csum-segmentation",
-	[NETIF_F_GSO_IPXIP4_BIT] =	 "tx-ipxip4-segmentation",
-	[NETIF_F_GSO_IPXIP6_BIT] =	 "tx-ipxip6-segmentation",
-	[NETIF_F_GSO_UDP_TUNNEL_BIT] =	 "tx-udp_tnl-segmentation",
-	[NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT] = "tx-udp_tnl-csum-segmentation",
-	[NETIF_F_GSO_PARTIAL_BIT] =	 "tx-gso-partial",
-	[NETIF_F_GSO_SCTP_BIT] =	 "tx-sctp-segmentation",
-	[NETIF_F_GSO_ESP_BIT] =		 "tx-esp-segmentation",
-	[NETIF_F_GSO_UDP_L4_BIT] =	 "tx-udp-segmentation",
-
-	[NETIF_F_FCOE_CRC_BIT] =         "tx-checksum-fcoe-crc",
-	[NETIF_F_SCTP_CRC_BIT] =        "tx-checksum-sctp",
-	[NETIF_F_FCOE_MTU_BIT] =         "fcoe-mtu",
-	[NETIF_F_NTUPLE_BIT] =           "rx-ntuple-filter",
-	[NETIF_F_RXHASH_BIT] =           "rx-hashing",
-	[NETIF_F_RXCSUM_BIT] =           "rx-checksum",
-	[NETIF_F_NOCACHE_COPY_BIT] =     "tx-nocache-copy",
-	[NETIF_F_LOOPBACK_BIT] =         "loopback",
-	[NETIF_F_RXFCS_BIT] =            "rx-fcs",
-	[NETIF_F_RXALL_BIT] =            "rx-all",
-	[NETIF_F_HW_L2FW_DOFFLOAD_BIT] = "l2-fwd-offload",
-	[NETIF_F_HW_TC_BIT] =		 "hw-tc-offload",
-	[NETIF_F_HW_ESP_BIT] =		 "esp-hw-offload",
-	[NETIF_F_HW_ESP_TX_CSUM_BIT] =	 "esp-tx-csum-hw-offload",
-	[NETIF_F_RX_UDP_TUNNEL_PORT_BIT] =	 "rx-udp_tunnel-port-offload",
-	[NETIF_F_HW_TLS_RECORD_BIT] =	"tls-hw-record",
-	[NETIF_F_HW_TLS_TX_BIT] =	 "tls-hw-tx-offload",
-	[NETIF_F_HW_TLS_RX_BIT] =	 "tls-hw-rx-offload",
-};
-
-static const char
-rss_hash_func_strings[ETH_RSS_HASH_FUNCS_COUNT][ETH_GSTRING_LEN] = {
-	[ETH_RSS_HASH_TOP_BIT] =	"toeplitz",
-	[ETH_RSS_HASH_XOR_BIT] =	"xor",
-	[ETH_RSS_HASH_CRC32_BIT] =	"crc32",
-};
-
-static const char
-tunable_strings[__ETHTOOL_TUNABLE_COUNT][ETH_GSTRING_LEN] = {
-	[ETHTOOL_ID_UNSPEC]     = "Unspec",
-	[ETHTOOL_RX_COPYBREAK]	= "rx-copybreak",
-	[ETHTOOL_TX_COPYBREAK]	= "tx-copybreak",
-	[ETHTOOL_PFC_PREVENTION_TOUT] = "pfc-prevention-tout",
-};
-
-static const char
-phy_tunable_strings[__ETHTOOL_PHY_TUNABLE_COUNT][ETH_GSTRING_LEN] = {
-	[ETHTOOL_ID_UNSPEC]     = "Unspec",
-	[ETHTOOL_PHY_DOWNSHIFT]	= "phy-downshift",
-	[ETHTOOL_PHY_FAST_LINK_DOWN] = "phy-fast-link-down",
-	[ETHTOOL_PHY_EDPD]	= "phy-energy-detect-power-down",
-};
-
 static int ethtool_get_features(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_gfeatures cmd = {
-- 
2.24.0

