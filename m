Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57532FCEF4
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 12:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388993AbhATLPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 06:15:03 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13479 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731541AbhATJim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 04:38:42 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6007f9e10000>; Wed, 20 Jan 2021 01:37:37 -0800
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 20 Jan 2021 09:37:34 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <mkubecek@suse.cz>,
        <mlxsw@nvidia.com>, <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next v3 3/7] ethtool: Expose the number of lanes in use
Date:   Wed, 20 Jan 2021 11:37:09 +0200
Message-ID: <20210120093713.4000363-4-danieller@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210120093713.4000363-1-danieller@nvidia.com>
References: <20210120093713.4000363-1-danieller@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611135457; bh=cvmwaNhfwJDtRkQdpCNkvt73xjNxEE0aYM1xtWcAAG4=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=KgHY+WCzSuTL3LQY2HNZmm5TBQDesIVkub6Addokkky/l1mBaQbaXmM7tZhsLddEO
         KYPrzXvMGdSicoPtetOG89VMZ58/WaIhYp/nvZ3s6YICKO/l1+cwQ6StOV0FEAtA37
         ZGLTGP0z5fjWUqbRlO2SHlOM28XcvobDgSryk9CulCb+al6RHpWrx34Q50Xu5nQcqH
         bIO8Cl1Ifr4TEI6XPYfA3Bp1l4b0nib4+8p4I5SbtfKmTUgSV1kYApZT9woOfOOwGz
         yUYpowDLp1EmnsJmG7poTwgN4g5ZlNWVqgA3ORkqJwHCOiMYXon40ynuAdCqfUPAAU
         pglqqh0T9P0hw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, ethtool does not expose how many lanes are used when the
link is up.

After adding a possibility to advertise or force a specific number of
lanes, the lanes in use value can be either the maximum width of the port
or below.

Extend ethtool to expose the number of lanes currently in use for
drivers that support it.

For example:

$ ethtool -s swp1 speed 100000 lanes 4
$ ethtool -s swp2 speed 100000 lanes 4
$ ip link set swp1 up
$ ip link set swp2 up
$ ethtool swp1
Settings for swp1:
        Supported ports: [ FIBRE         Backplane ]
        Supported link modes:   1000baseT/Full
                                10000baseT/Full
                                1000baseKX/Full
                                10000baseKR/Full
                                10000baseR_FEC
                                40000baseKR4/Full
                                40000baseCR4/Full
                                40000baseSR4/Full
                                40000baseLR4/Full
                                25000baseCR/Full
                                25000baseKR/Full
                                25000baseSR/Full
                                50000baseCR2/Full
                                50000baseKR2/Full
                                100000baseKR4/Full
                                100000baseSR4/Full
                                100000baseCR4/Full
                                100000baseLR4_ER4/Full
                                50000baseSR2/Full
                                10000baseCR/Full
                                10000baseSR/Full
                                10000baseLR/Full
                                10000baseER/Full
                                50000baseKR/Full
                                50000baseSR/Full
                                50000baseCR/Full
                                50000baseLR_ER_FR/Full
                                50000baseDR/Full
                                100000baseKR2/Full
                                100000baseSR2/Full
                                100000baseCR2/Full
                                100000baseLR2_ER2_FR2/Full
                                100000baseDR2/Full
                                200000baseKR4/Full
                                200000baseSR4/Full
                                200000baseLR4_ER4_FR4/Full
                                200000baseDR4/Full
                                200000baseCR4/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  1000baseT/Full
                                10000baseT/Full
                                1000baseKX/Full
                                1000baseKX/Full
                                10000baseKR/Full
                                10000baseR_FEC
                                40000baseKR4/Full
                                40000baseCR4/Full
                                40000baseSR4/Full
                                40000baseLR4/Full
                                25000baseCR/Full
                                25000baseKR/Full
                                25000baseSR/Full
                                50000baseCR2/Full
                                50000baseKR2/Full
                                100000baseKR4/Full
                                100000baseSR4/Full
                                100000baseCR4/Full
                                100000baseLR4_ER4/Full
                                50000baseSR2/Full
                                10000baseCR/Full
                                10000baseSR/Full
                                10000baseLR/Full
                                10000baseER/Full
                                200000baseKR4/Full
                                200000baseSR4/Full
                                200000baseLR4_ER4_FR4/Full
                                200000baseDR4/Full
                                200000baseCR4/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Advertised link modes:  100000baseKR4/Full
                                100000baseSR4/Full
                                100000baseCR4/Full
                                100000baseLR4_ER4/Full
	Advertised pause frame use: No
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Speed: 100000Mb/s
	Lanes: 4
	Duplex: Full
	Auto-negotiation: on
	Port: Direct Attach Copper
	PHYAD: 0
	Transceiver: internal
	Link detected: yes

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
---

Notes:
    v3:
    	* Change the condition for supporting the lanes parameter.
   =20
    v2:
    	* Reword commit message.
    	* Since now we get a link mode from driver, instead of each
    	  parameter separately, simply derive lanes from it.

 net/ethtool/linkmodes.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index caf9111c5270..0c18f8eda63d 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -45,6 +45,9 @@ static int linkmodes_prepare_data(const struct ethnl_req_=
info *req_base,
 		goto out;
 	}
=20
+	if (!dev->ethtool_ops->cap_link_lanes_supported)
+		data->ksettings.lanes =3D ETHTOOL_LANES_UNKNOWN;
+
 	data->peer_empty =3D
 		bitmap_empty(data->ksettings.link_modes.lp_advertising,
 			     __ETHTOOL_LINK_MODE_MASK_NBITS);
@@ -65,6 +68,7 @@ static int linkmodes_reply_size(const struct ethnl_req_in=
fo *req_base,
=20
 	len =3D nla_total_size(sizeof(u8)) /* LINKMODES_AUTONEG */
 		+ nla_total_size(sizeof(u32)) /* LINKMODES_SPEED */
+		+ nla_total_size(sizeof(u32)) /* LINKMODES_LANES */
 		+ nla_total_size(sizeof(u8)) /* LINKMODES_DUPLEX */
 		+ 0;
 	ret =3D ethnl_bitset_size(ksettings->link_modes.advertising,
@@ -122,6 +126,7 @@ static int linkmodes_fill_reply(struct sk_buff *skb,
 	}
=20
 	if (nla_put_u32(skb, ETHTOOL_A_LINKMODES_SPEED, lsettings->speed) ||
+	    nla_put_u32(skb, ETHTOOL_A_LINKMODES_LANES, ksettings->lanes) ||
 	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_DUPLEX, lsettings->duplex))
 		return -EMSGSIZE;
=20
--=20
2.26.2

