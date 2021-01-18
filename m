Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A622FAA6B
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 20:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437063AbhARTmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 14:42:40 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:49746 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437340AbhARTdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 14:33:47 -0500
Date:   Mon, 18 Jan 2021 19:32:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610998379; bh=z2BgOHJQihEnZJluF+2PjwdFI80xZFFK5NdPVZjc2KU=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=RtXGISrjXU7lTSaAaDTkKXl/3TbgsmZk3CMUU+Y/Lv4b/vdC9DIOMcC9GiK0tMUVR
         pclzQoZkmqRAczGjRuTKEgbg+L8HMcSBxS41Uyb3qbDsSVlc29Xk7pzunDBx0IbjW/
         Uun5Ri1kLZrGZOpHWwnnQcvlWhuEcAloXEgWWNvrB3YSLUIwiDwzCFXPjUPsD0Lxjs
         rtcZo1z+m+nIqfk5925u7dVy/1I1GYmWEgsCy2IBThOg7WlV5J4UF+3RwNsAUCUEQ6
         mmdjqD3D8B+JQgvdZl3vPSvVY4Vb+VLPDsqcaPhCRHDJgpu/wW1GXg7MR7/gf/LCNO
         d5FYEWbBU8/Cg==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Igor Russkikh <irusskikh@marvell.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>,
        Meir Lichtinger <meirl@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next 1/2] net: introduce UDP GRO netdev feature
Message-ID: <20210118193232.87583-1-alobakin@pm.me>
In-Reply-To: <20210118193122.87271-1-alobakin@pm.me>
References: <20210118193122.87271-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new netdev_feature, NETIF_F_GRO_UDP, to allow user
to turn UDP GRO on and off when there is no socket, e.g. when
forwarding.
Defaults to off to not change current datapath.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 include/linux/netdev_features.h | 4 +++-
 net/ethtool/common.c            | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_feature=
s.h
index 934de56644e7..c6526aa13684 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -84,6 +84,7 @@ enum {
 =09NETIF_F_GRO_FRAGLIST_BIT,=09/* Fraglist GRO */
=20
 =09NETIF_F_HW_MACSEC_BIT,=09=09/* Offload MACsec operations */
+=09NETIF_F_GRO_UDP_BIT,=09=09/* Enable UDP GRO */
=20
 =09/*
 =09 * Add your fresh new feature above and remember to update
@@ -157,6 +158,7 @@ enum {
 #define NETIF_F_GRO_FRAGLIST=09__NETIF_F(GRO_FRAGLIST)
 #define NETIF_F_GSO_FRAGLIST=09__NETIF_F(GSO_FRAGLIST)
 #define NETIF_F_HW_MACSEC=09__NETIF_F(HW_MACSEC)
+#define NETIF_F_GRO_UDP=09=09__NETIF_F(GRO_UDP)
=20
 /* Finds the next feature with the highest number of the range of start ti=
ll 0.
  */
@@ -234,7 +236,7 @@ static inline int find_next_netdev_feature(u64 feature,=
 unsigned long start)
 #define NETIF_F_SOFT_FEATURES=09(NETIF_F_GSO | NETIF_F_GRO)
=20
 /* Changeable features with no special hardware requirements that defaults=
 to off. */
-#define NETIF_F_SOFT_FEATURES_OFF=09NETIF_F_GRO_FRAGLIST
+#define NETIF_F_SOFT_FEATURES_OFF=09(NETIF_F_GRO_FRAGLIST | NETIF_F_GRO_UD=
P)
=20
 #define NETIF_F_VLAN_FEATURES=09(NETIF_F_HW_VLAN_CTAG_FILTER | \
 =09=09=09=09 NETIF_F_HW_VLAN_CTAG_RX | \
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 24036e3055a1..e45128882372 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -68,6 +68,7 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][=
ETH_GSTRING_LEN] =3D {
 =09[NETIF_F_HW_TLS_RX_BIT] =3D=09 "tls-hw-rx-offload",
 =09[NETIF_F_GRO_FRAGLIST_BIT] =3D=09 "rx-gro-list",
 =09[NETIF_F_HW_MACSEC_BIT] =3D=09 "macsec-hw-offload",
+=09[NETIF_F_GRO_UDP_BIT] =3D=09=09 "rx-gro-udp",
 };
=20
 const char
--=20
2.30.0


