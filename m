Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFE32029E8
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 11:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbgFUJ5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 05:57:09 -0400
Received: from mail-40131.protonmail.ch ([185.70.40.131]:26960 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729749AbgFUJ5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 05:57:08 -0400
Date:   Sun, 21 Jun 2020 09:56:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1592733425; bh=g0HP1Oqtt2tWvdPrfD8uRVaU3hxTt+LfGRRANNn2PNI=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=d69fPDedzbp0jZ8s3UAQUwPPwJOjzsWrIAEwc1TBZrR8d4myYLZwz/aVYqXYh0eUD
         6bt4H2iWD95vUrGusiPO7Zbw84WwLvGVSLWh8/i1iOFT/QJgk0vlc2PuBQWkFpDdNN
         KOweMuTWeUkKyBzKw3R+KvkCEMQb0mhwL9b+tFiTld5lDpIfqHbWeY2CJCNoSC277h
         pWTmKjQ0r6fVhtLbZOF9hpgRXghyIozzT4LQuCdKXJ5QlBEjCwaNI9caf1Zjtwxoeu
         Pq4MT52KSy/XHMx/FlTmu1KUKMDgPjgdz4tpQVKcUPkkmS9sMQ0GytGQcagvlHZVT7
         4MB2wk6zBYKfA==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@mellanox.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Aya Levin <ayal@mellanox.com>,
        Tom Herbert <therbert@google.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 net 3/3] net: ethtool: sync netdev_features_strings order with enum netdev_features
Message-ID: <jP-0hVQHflXY-Z617fzg4VjzmOQsz9bhRiFF5f_O2EugGy_LdUoHQrQl6AoT1RE8VH8vLs8lBDUQWVQSVIuohxIZHIYE3wP0_32SRuZQEJw=@pm.me>
In-Reply-To: <HPTrw9hrtm3e5151oH8oQfbr0HWTlzQ1n68bZn1hfd6yag38Tem57b4eTH-bhlaJgBxyhZb9U-qFFOafJoQqxcY-VX5fh5ZktTrnWhYeNB0=@pm.me>
References: <HPTrw9hrtm3e5151oH8oQfbr0HWTlzQ1n68bZn1hfd6yag38Tem57b4eTH-bhlaJgBxyhZb9U-qFFOafJoQqxcY-VX5fh5ZktTrnWhYeNB0=@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.protonmail.ch
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
 const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] =
=3D {
 =09[NETIF_F_SG_BIT]=09=09=09=3D "tx-scatter-gather",
 =09[NETIF_F_IP_CSUM_BIT]=09=09=09=3D "tx-checksum-ipv4",
+
+=09/* __UNUSED_NETIF_F_1 - deprecated */
+
 =09[NETIF_F_HW_CSUM_BIT]=09=09=09=3D "tx-checksum-ip-generic",
 =09[NETIF_F_IPV6_CSUM_BIT]=09=09=09=3D "tx-checksum-ipv6",
 =09[NETIF_F_HIGHDMA_BIT]=09=09=09=3D "highdma",
 =09[NETIF_F_FRAGLIST_BIT]=09=09=09=3D "tx-scatter-gather-fraglist",
 =09[NETIF_F_HW_VLAN_CTAG_TX_BIT]=09=09=3D "tx-vlan-hw-insert",
-
 =09[NETIF_F_HW_VLAN_CTAG_RX_BIT]=09=09=3D "rx-vlan-hw-parse",
 =09[NETIF_F_HW_VLAN_CTAG_FILTER_BIT]=09=3D "rx-vlan-filter",
-=09[NETIF_F_HW_VLAN_STAG_TX_BIT]=09=09=3D "tx-vlan-stag-hw-insert",
-=09[NETIF_F_HW_VLAN_STAG_RX_BIT]=09=09=3D "rx-vlan-stag-hw-parse",
-=09[NETIF_F_HW_VLAN_STAG_FILTER_BIT]=09=3D "rx-vlan-stag-filter",
 =09[NETIF_F_VLAN_CHALLENGED_BIT]=09=09=3D "vlan-challenged",
 =09[NETIF_F_GSO_BIT]=09=09=09=3D "tx-generic-segmentation",
 =09[NETIF_F_LLTX_BIT]=09=09=09=3D "tx-lockless",
 =09[NETIF_F_NETNS_LOCAL_BIT]=09=09=3D "netns-local",
 =09[NETIF_F_GRO_BIT]=09=09=09=3D "rx-gro",
-=09[NETIF_F_GRO_HW_BIT]=09=09=09=3D "rx-gro-hw",
 =09[NETIF_F_LRO_BIT]=09=09=09=3D "rx-lro",
=20
+=09/* NETIF_F_GSO_SHIFT =3D NETIF_F_TSO_BIT */
+
 =09[NETIF_F_TSO_BIT]=09=09=09=3D "tx-tcp-segmentation",
 =09[NETIF_F_GSO_ROBUST_BIT]=09=09=3D "tx-gso-robust",
 =09[NETIF_F_TSO_ECN_BIT]=09=09=09=3D "tx-tcp-ecn-segmentation",
@@ -43,9 +43,14 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT]=
[ETH_GSTRING_LEN] =3D {
 =09[NETIF_F_GSO_TUNNEL_REMCSUM_BIT]=09=3D "tx-tunnel-remcsum-segmentation"=
,
 =09[NETIF_F_GSO_SCTP_BIT]=09=09=09=3D "tx-sctp-segmentation",
 =09[NETIF_F_GSO_ESP_BIT]=09=09=09=3D "tx-esp-segmentation",
+
+=09/* NETIF_F_GSO_UDP_BIT - deprecated */
+
 =09[NETIF_F_GSO_UDP_L4_BIT]=09=09=3D "tx-udp-segmentation",
 =09[NETIF_F_GSO_FRAGLIST_BIT]=09=09=3D "tx-gso-list",
=20
+=09/* NETIF_F_GSO_LAST =3D NETIF_F_GSO_FRAGLIST_BIT */
+
 =09[NETIF_F_FCOE_CRC_BIT]=09=09=09=3D "tx-checksum-fcoe-crc",
 =09[NETIF_F_SCTP_CRC_BIT]=09=09=09=3D "tx-checksum-sctp",
 =09[NETIF_F_FCOE_MTU_BIT]=09=09=09=3D "fcoe-mtu",
@@ -56,16 +61,25 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT=
][ETH_GSTRING_LEN] =3D {
 =09[NETIF_F_LOOPBACK_BIT]=09=09=09=3D "loopback",
 =09[NETIF_F_RXFCS_BIT]=09=09=09=3D "rx-fcs",
 =09[NETIF_F_RXALL_BIT]=09=09=09=3D "rx-all",
+=09[NETIF_F_HW_VLAN_STAG_TX_BIT]=09=09=3D "tx-vlan-stag-hw-insert",
+=09[NETIF_F_HW_VLAN_STAG_RX_BIT]=09=09=3D "rx-vlan-stag-hw-parse",
+=09[NETIF_F_HW_VLAN_STAG_FILTER_BIT]=09=3D "rx-vlan-stag-filter",
 =09[NETIF_F_HW_L2FW_DOFFLOAD_BIT]=09=09=3D "l2-fwd-offload",
+
 =09[NETIF_F_HW_TC_BIT]=09=09=09=3D "hw-tc-offload",
 =09[NETIF_F_HW_ESP_BIT]=09=09=09=3D "esp-hw-offload",
 =09[NETIF_F_HW_ESP_TX_CSUM_BIT]=09=09=3D "esp-tx-csum-hw-offload",
 =09[NETIF_F_RX_UDP_TUNNEL_PORT_BIT]=09=3D "rx-udp_tunnel-port-offload",
-=09[NETIF_F_HW_TLS_RECORD_BIT]=09=09=3D "tls-hw-record",
 =09[NETIF_F_HW_TLS_TX_BIT]=09=09=09=3D "tls-hw-tx-offload",
 =09[NETIF_F_HW_TLS_RX_BIT]=09=09=09=3D "tls-hw-rx-offload",
+
+=09[NETIF_F_GRO_HW_BIT]=09=09=09=3D "rx-gro-hw",
+=09[NETIF_F_HW_TLS_RECORD_BIT]=09=09=3D "tls-hw-record",
 =09[NETIF_F_GRO_FRAGLIST_BIT]=09=09=3D "rx-gro-list",
+
 =09[NETIF_F_HW_MACSEC_BIT]=09=09=09=3D "macsec-hw-offload",
+
+=09/* NETDEV_FEATURE_COUNT */
 };
=20
 const char
--=20
2.27.0


