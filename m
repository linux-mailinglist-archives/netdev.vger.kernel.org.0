Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFC8300C29
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 20:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbhAVSk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 13:40:58 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:51381 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729034AbhAVSVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 13:21:00 -0500
Date:   Fri, 22 Jan 2021 18:19:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1611339592; bh=ZSWUd1j5nvzNHtj2fSy/5cVq2S7UqJlndcG8EsavUw8=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=f/6gnqOurPgFa/tJuMScK8/V/wtpQ63IoM8UAXSJFBqb7g1IfkNni+K0GZhcT0eXv
         rDBI3V9/JbOQJ/TFMmdXNmstQDS015ru+vHaoks7x43Ba0srDZRXW1RjIFXQ5HkazP
         xg6rgDuUGW2ffxj3b1LU0hk8rA+4am4f1Zq1ucZqXyTbBRJepj+zn3pqFLcQW3SH8U
         VuDwnOEd9Gl1Bm74c6OwqxKCQu+vyex1msS+ZLKzP8jsnA81Dqw0oUKSY3dt83IYVu
         KLGvZdXRsmzmlnpW6Rxs7rP6HUm85fDgCAhRICOWijQpwNsSnOyQjt8fkTYJeDhCo0
         yR9k63ltrZAYQ==
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
Subject: [PATCH v4 net-next 1/2] net: introduce a netdev feature for UDP GRO forwarding
Message-ID: <20210122181909.36340-2-alobakin@pm.me>
In-Reply-To: <20210122181909.36340-1-alobakin@pm.me>
References: <20210122181909.36340-1-alobakin@pm.me>
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

Introduce a new netdev feature, NETIF_F_GRO_UDP_FWD, to allow user
to turn UDP GRO on and off for forwarding.
Defaults to off to not change current datapath.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 include/linux/netdev_features.h | 4 +++-
 net/ethtool/common.c            | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_feature=
s.h
index 934de56644e7..c06d6aaba9df 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -84,6 +84,7 @@ enum {
 =09NETIF_F_GRO_FRAGLIST_BIT,=09/* Fraglist GRO */
=20
 =09NETIF_F_HW_MACSEC_BIT,=09=09/* Offload MACsec operations */
+=09NETIF_F_GRO_UDP_FWD_BIT,=09/* Allow UDP GRO for forwarding */
=20
 =09/*
 =09 * Add your fresh new feature above and remember to update
@@ -157,6 +158,7 @@ enum {
 #define NETIF_F_GRO_FRAGLIST=09__NETIF_F(GRO_FRAGLIST)
 #define NETIF_F_GSO_FRAGLIST=09__NETIF_F(GSO_FRAGLIST)
 #define NETIF_F_HW_MACSEC=09__NETIF_F(HW_MACSEC)
+#define NETIF_F_GRO_UDP_FWD=09__NETIF_F(GRO_UDP_FWD)
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
P_FWD)
=20
 #define NETIF_F_VLAN_FEATURES=09(NETIF_F_HW_VLAN_CTAG_FILTER | \
 =09=09=09=09 NETIF_F_HW_VLAN_CTAG_RX | \
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 24036e3055a1..181220101a6e 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -68,6 +68,7 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][=
ETH_GSTRING_LEN] =3D {
 =09[NETIF_F_HW_TLS_RX_BIT] =3D=09 "tls-hw-rx-offload",
 =09[NETIF_F_GRO_FRAGLIST_BIT] =3D=09 "rx-gro-list",
 =09[NETIF_F_HW_MACSEC_BIT] =3D=09 "macsec-hw-offload",
+=09[NETIF_F_GRO_UDP_FWD_BIT] =3D=09 "rx-udp-gro-forwarding",
 };
=20
 const char
--=20
2.30.0


