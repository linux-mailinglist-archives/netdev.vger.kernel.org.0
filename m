Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D4F2019EE
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 20:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387423AbgFSSEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 14:04:11 -0400
Received: from forward102p.mail.yandex.net ([77.88.28.102]:44305 "EHLO
        forward102p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727003AbgFSSEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 14:04:11 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Jun 2020 14:04:08 EDT
Received: from mxback28g.mail.yandex.net (mxback28g.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:328])
        by forward102p.mail.yandex.net (Yandex) with ESMTP id 169E21D40CA2;
        Fri, 19 Jun 2020 20:58:17 +0300 (MSK)
Received: from myt5-ca5ec8faf378.qloud-c.yandex.net (myt5-ca5ec8faf378.qloud-c.yandex.net [2a02:6b8:c12:2514:0:640:ca5e:c8fa])
        by mxback28g.mail.yandex.net (mxback/Yandex) with ESMTP id yrlIGU87mc-wFO0RYVi;
        Fri, 19 Jun 2020 20:58:17 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1592589497;
        bh=dTABDPAC0TIJvPPbhyKvGl6SRvL9aurhWCWf7c3kue0=;
        h=Subject:To:From:Cc:Date:Message-Id;
        b=O3ucnUXJHdobJao47TJC+LUhCY9isFAos37C5xg8vuMACmoE1qNZczvvirtVNiPqk
         BBMom4SxcxJf85ZK4ygJgy/6JndshlILOcHoN75TwzQ9odRQdovmIOFCPGzb7TdTTE
         aALW6UyH/6oFzsj06x8eVwcTm2s0+bvmwVDTVN5A=
Authentication-Results: mxback28g.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt5-ca5ec8faf378.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 8kc9Js6YU8-wE0uc5mT;
        Fri, 19 Jun 2020 20:58:15 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Alexander Lobakin <bloodyreaper@yandex.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@mellanox.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Aya Levin <ayal@mellanox.com>,
        Tom Herbert <therbert@google.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Lobakin <bloodyreaper@yandex.ru>
Subject: [PATCH net 3/3] net: ethtool: sync netdev_features_strings order with enum netdev_features
Date:   Fri, 19 Jun 2020 20:58:05 +0300
Message-Id: <20200619175805.34331-1-bloodyreaper@yandex.ru>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ordering of netdev_features_strings[] makes no sense when it comes
to user interaction, as list of features in `ethtool -k` input is sorted
according to the corresponding bit's position.
Instead, it *does* make sense when it comes to adding new netdev_features
or modifying existing ones. We have at least 2 occasions of forgetting to
add the strings for newly introduced features, and one of them existed
since 3.1x times till now.

Let's keep this stringtable sorted according to bit's position in enum
netdev_features, as this simplifies both reading and modification of the
source code and can help not to miss or forget anything.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/ethtool/common.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index c8e3fce6e48d..24f35d47832d 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -8,25 +8,25 @@
 const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
 	[NETIF_F_SG_BIT]			= "tx-scatter-gather",
 	[NETIF_F_IP_CSUM_BIT]			= "tx-checksum-ipv4",
+
+	/* __UNUSED_NETIF_F_1 - deprecated */
+
 	[NETIF_F_HW_CSUM_BIT]			= "tx-checksum-ip-generic",
 	[NETIF_F_IPV6_CSUM_BIT]			= "tx-checksum-ipv6",
 	[NETIF_F_HIGHDMA_BIT]			= "highdma",
 	[NETIF_F_FRAGLIST_BIT]			= "tx-scatter-gather-fraglist",
 	[NETIF_F_HW_VLAN_CTAG_TX_BIT]		= "tx-vlan-hw-insert",
-
 	[NETIF_F_HW_VLAN_CTAG_RX_BIT]		= "rx-vlan-hw-parse",
 	[NETIF_F_HW_VLAN_CTAG_FILTER_BIT]	= "rx-vlan-filter",
-	[NETIF_F_HW_VLAN_STAG_TX_BIT]		= "tx-vlan-stag-hw-insert",
-	[NETIF_F_HW_VLAN_STAG_RX_BIT]		= "rx-vlan-stag-hw-parse",
-	[NETIF_F_HW_VLAN_STAG_FILTER_BIT]	= "rx-vlan-stag-filter",
 	[NETIF_F_VLAN_CHALLENGED_BIT]		= "vlan-challenged",
 	[NETIF_F_GSO_BIT]			= "tx-generic-segmentation",
 	[NETIF_F_LLTX_BIT]			= "tx-lockless",
 	[NETIF_F_NETNS_LOCAL_BIT]		= "netns-local",
 	[NETIF_F_GRO_BIT]			= "rx-gro",
-	[NETIF_F_GRO_HW_BIT]			= "rx-gro-hw",
 	[NETIF_F_LRO_BIT]			= "rx-lro",
 
+	/* NETIF_F_GSO_SHIFT = NETIF_F_TSO_BIT */
+
 	[NETIF_F_TSO_BIT]			= "tx-tcp-segmentation",
 	[NETIF_F_GSO_ROBUST_BIT]		= "tx-gso-robust",
 	[NETIF_F_TSO_ECN_BIT]			= "tx-tcp-ecn-segmentation",
@@ -43,9 +43,14 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
 	[NETIF_F_GSO_TUNNEL_REMCSUM_BIT]	= "tx-tunnel-remcsum-segmentation",
 	[NETIF_F_GSO_SCTP_BIT]			= "tx-sctp-segmentation",
 	[NETIF_F_GSO_ESP_BIT]			= "tx-esp-segmentation",
+
+	/* NETIF_F_GSO_UDP_BIT - deprecated */
+
 	[NETIF_F_GSO_UDP_L4_BIT]		= "tx-udp-segmentation",
 	[NETIF_F_GSO_FRAGLIST_BIT]		= "tx-gso-list",
 
+	/* NETIF_F_GSO_LAST = NETIF_F_GSO_FRAGLIST_BIT */
+
 	[NETIF_F_FCOE_CRC_BIT]			= "tx-checksum-fcoe-crc",
 	[NETIF_F_SCTP_CRC_BIT]			= "tx-checksum-sctp",
 	[NETIF_F_FCOE_MTU_BIT]			= "fcoe-mtu",
@@ -56,16 +61,25 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
 	[NETIF_F_LOOPBACK_BIT]			= "loopback",
 	[NETIF_F_RXFCS_BIT]			= "rx-fcs",
 	[NETIF_F_RXALL_BIT]			= "rx-all",
+	[NETIF_F_HW_VLAN_STAG_TX_BIT]		= "tx-vlan-stag-hw-insert",
+	[NETIF_F_HW_VLAN_STAG_RX_BIT]		= "rx-vlan-stag-hw-parse",
+	[NETIF_F_HW_VLAN_STAG_FILTER_BIT]	= "rx-vlan-stag-filter",
 	[NETIF_F_HW_L2FW_DOFFLOAD_BIT]		= "l2-fwd-offload",
+
 	[NETIF_F_HW_TC_BIT]			= "hw-tc-offload",
 	[NETIF_F_HW_ESP_BIT]			= "esp-hw-offload",
 	[NETIF_F_HW_ESP_TX_CSUM_BIT]		= "esp-tx-csum-hw-offload",
 	[NETIF_F_RX_UDP_TUNNEL_PORT_BIT]	= "rx-udp_tunnel-port-offload",
-	[NETIF_F_HW_TLS_RECORD_BIT]		= "tls-hw-record",
 	[NETIF_F_HW_TLS_TX_BIT]			= "tls-hw-tx-offload",
 	[NETIF_F_HW_TLS_RX_BIT]			= "tls-hw-rx-offload",
+
+	[NETIF_F_GRO_HW_BIT]			= "rx-gro-hw",
+	[NETIF_F_HW_TLS_RECORD_BIT]		= "tls-hw-record",
 	[NETIF_F_GRO_FRAGLIST_BIT]		= "rx-gro-list",
+
 	[NETIF_F_HW_MACSEC_BIT]			= "macsec-hw-offload",
+
+	/* NETDEV_FEATURE_COUNT */
 };
 
 const char
-- 
2.27.0

