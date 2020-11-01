Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970BB2A1E43
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 14:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgKANR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 08:17:26 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:23961 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbgKANRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 08:17:22 -0500
X-Greylist: delayed 76885 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Nov 2020 08:17:21 EST
Date:   Sun, 01 Nov 2020 13:17:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604236639; bh=PSBlUKp+w471ygVSGKtOZR8/NBsm90EQYMDdsaYJehU=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=ihTGOmfhDuJGrbKgQYXtnExCCrHyHea6aBpJvlELxbHejM4MoxqYcVd/bTS8++3zj
         SgT85hVBw872aLa0eJiIwh4BLP6nx7+qHNm+YcUwRqz+oA+6+T5vATxgOGPZ5N2xrl
         5sWAvDPFXqzIoxttiP9ZY+6QRoPq2ykdsPzA3CcCgc5lJuT5yyBmx3Ehq+YIwTDb+r
         7scphM2yqxqss4kXxB7CESQn5nMy7v821chvcLiVYOMZCU9DGV8mLXW8DXk2vHFfsH
         8N+qKEMSwEEugss2IIOnUMlvWticrAUKvQcVsM6DMQsQZFeN+X30I2bcR0IAFy8Oge
         EdnE8jMdocsag==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Antoine Tenart <atenart@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 net-next 2/2] net: bonding, dummy, ifb, team: advertise NETIF_F_GSO_SOFTWARE
Message-ID: <GtgHtyGO5jHKHT6zGMAzg3TDejXZT0HMQVoqNERZRdM@cp3-web-024.plabs.ch>
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

Virtual netdevs should use NETIF_F_GSO_SOFTWARE to forward GSO skbs
as-is and let the final drivers deal with them when supported.
Also remove NETIF_F_GSO_UDP_L4 from bonding and team drivers as it's
now included in the "software" list.

Suggested-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/net/bonding/bond_main.c | 11 +++++------
 drivers/net/dummy.c             |  2 +-
 drivers/net/ifb.c               |  3 +--
 drivers/net/team/team.c         |  9 ++++-----
 4 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_mai=
n.c
index 84ecbc6fa0ff..71c9677d135f 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1228,14 +1228,14 @@ static netdev_features_t bond_fix_features(struct n=
et_device *dev,
 }
=20
 #define BOND_VLAN_FEATURES=09(NETIF_F_HW_CSUM | NETIF_F_SG | \
-=09=09=09=09 NETIF_F_FRAGLIST | NETIF_F_ALL_TSO | \
+=09=09=09=09 NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE | \
 =09=09=09=09 NETIF_F_HIGHDMA | NETIF_F_LRO)
=20
 #define BOND_ENC_FEATURES=09(NETIF_F_HW_CSUM | NETIF_F_SG | \
-=09=09=09=09 NETIF_F_RXCSUM | NETIF_F_ALL_TSO)
+=09=09=09=09 NETIF_F_RXCSUM | NETIF_F_GSO_SOFTWARE)
=20
 #define BOND_MPLS_FEATURES=09(NETIF_F_HW_CSUM | NETIF_F_SG | \
-=09=09=09=09 NETIF_F_ALL_TSO)
+=09=09=09=09 NETIF_F_GSO_SOFTWARE)
=20
=20
 static void bond_compute_features(struct bonding *bond)
@@ -1291,8 +1291,7 @@ static void bond_compute_features(struct bonding *bon=
d)
 =09bond_dev->vlan_features =3D vlan_features;
 =09bond_dev->hw_enc_features =3D enc_features | NETIF_F_GSO_ENCAP_ALL |
 =09=09=09=09    NETIF_F_HW_VLAN_CTAG_TX |
-=09=09=09=09    NETIF_F_HW_VLAN_STAG_TX |
-=09=09=09=09    NETIF_F_GSO_UDP_L4;
+=09=09=09=09    NETIF_F_HW_VLAN_STAG_TX;
 #ifdef CONFIG_XFRM_OFFLOAD
 =09bond_dev->hw_enc_features |=3D xfrm_features;
 #endif /* CONFIG_XFRM_OFFLOAD */
@@ -4721,7 +4720,7 @@ void bond_setup(struct net_device *bond_dev)
 =09=09=09=09NETIF_F_HW_VLAN_CTAG_RX |
 =09=09=09=09NETIF_F_HW_VLAN_CTAG_FILTER;
=20
-=09bond_dev->hw_features |=3D NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
+=09bond_dev->hw_features |=3D NETIF_F_GSO_ENCAP_ALL;
 #ifdef CONFIG_XFRM_OFFLOAD
 =09bond_dev->hw_features |=3D BOND_XFRM_FEATURES;
 #endif /* CONFIG_XFRM_OFFLOAD */
diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index bab3a9bb5e6f..f82ad7419508 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -124,7 +124,7 @@ static void dummy_setup(struct net_device *dev)
 =09dev->flags &=3D ~IFF_MULTICAST;
 =09dev->priv_flags |=3D IFF_LIVE_ADDR_CHANGE | IFF_NO_QUEUE;
 =09dev->features=09|=3D NETIF_F_SG | NETIF_F_FRAGLIST;
-=09dev->features=09|=3D NETIF_F_ALL_TSO;
+=09dev->features=09|=3D NETIF_F_GSO_SOFTWARE;
 =09dev->features=09|=3D NETIF_F_HW_CSUM | NETIF_F_HIGHDMA | NETIF_F_LLTX;
 =09dev->features=09|=3D NETIF_F_GSO_ENCAP_ALL;
 =09dev->hw_features |=3D dev->features;
diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 7fe306e76281..fa63d4dee0ba 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -187,8 +187,7 @@ static const struct net_device_ops ifb_netdev_ops =3D {
 };
=20
 #define IFB_FEATURES (NETIF_F_HW_CSUM | NETIF_F_SG  | NETIF_F_FRAGLIST=09|=
 \
-=09=09      NETIF_F_TSO_ECN | NETIF_F_TSO | NETIF_F_TSO6=09| \
-=09=09      NETIF_F_GSO_ENCAP_ALL =09=09=09=09| \
+=09=09      NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL=09| \
 =09=09      NETIF_F_HIGHDMA | NETIF_F_HW_VLAN_CTAG_TX=09=09| \
 =09=09      NETIF_F_HW_VLAN_STAG_TX)
=20
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 07f1f3933927..b4092127a92c 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -975,11 +975,11 @@ static void team_port_disable(struct team *team,
 }
=20
 #define TEAM_VLAN_FEATURES (NETIF_F_HW_CSUM | NETIF_F_SG | \
-=09=09=09    NETIF_F_FRAGLIST | NETIF_F_ALL_TSO | \
+=09=09=09    NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE | \
 =09=09=09    NETIF_F_HIGHDMA | NETIF_F_LRO)
=20
 #define TEAM_ENC_FEATURES=09(NETIF_F_HW_CSUM | NETIF_F_SG | \
-=09=09=09=09 NETIF_F_RXCSUM | NETIF_F_ALL_TSO)
+=09=09=09=09 NETIF_F_RXCSUM | NETIF_F_GSO_SOFTWARE)
=20
 static void __team_compute_features(struct team *team)
 {
@@ -1009,8 +1009,7 @@ static void __team_compute_features(struct team *team=
)
 =09team->dev->vlan_features =3D vlan_features;
 =09team->dev->hw_enc_features =3D enc_features | NETIF_F_GSO_ENCAP_ALL |
 =09=09=09=09     NETIF_F_HW_VLAN_CTAG_TX |
-=09=09=09=09     NETIF_F_HW_VLAN_STAG_TX |
-=09=09=09=09     NETIF_F_GSO_UDP_L4;
+=09=09=09=09     NETIF_F_HW_VLAN_STAG_TX;
 =09team->dev->hard_header_len =3D max_hard_header_len;
=20
 =09team->dev->priv_flags &=3D ~IFF_XMIT_DST_RELEASE;
@@ -2175,7 +2174,7 @@ static void team_setup(struct net_device *dev)
 =09=09=09   NETIF_F_HW_VLAN_CTAG_RX |
 =09=09=09   NETIF_F_HW_VLAN_CTAG_FILTER;
=20
-=09dev->hw_features |=3D NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
+=09dev->hw_features |=3D NETIF_F_GSO_ENCAP_ALL;
 =09dev->features |=3D dev->hw_features;
 =09dev->features |=3D NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
 }
--=20
2.29.2


