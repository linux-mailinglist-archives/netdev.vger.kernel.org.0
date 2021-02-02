Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9F430C931
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 19:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238108AbhBBSMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 13:12:44 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:7574 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238276AbhBBSHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 13:07:21 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601994af0001>; Tue, 02 Feb 2021 10:06:39 -0800
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 2 Feb 2021 18:06:37 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <mkubecek@suse.cz>,
        <mlxsw@nvidia.com>, <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next v4 4/8] ethtool: Expose the number of lanes in use
Date:   Tue, 2 Feb 2021 20:06:08 +0200
Message-ID: <20210202180612.325099-5-danieller@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210202180612.325099-1-danieller@nvidia.com>
References: <20210202180612.325099-1-danieller@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612289199; bh=LcvHIWudnZ7o4SlWt5ZEk4I98bvwca/lxP3uZBZKA3w=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=OHNOcIDxd8iB94ulELhnAbmiYsFG7drdDILTsToXbiYtBlzeyMSSww+XHkANozXXF
         hho0oq/onjez3rZJu2/doaDYjUqRNkFz69ZoC2MUzYN5I3Eb7VUXRa6C0u8VNBU5xs
         wVbwS88q6FDipiYFjvmjssD00H9cazqr3XRfT/NTUPxwUpCu/9fCX74ra8ih2UgMzk
         WFeiRTk6ks/gqXgCtZtTQJkA/fp4hZbWDbGwnGCHA48WODy755joOpWIGZ/2GNbg03
         URRyBP7ykznh5M1shBa4R7Xpq/uul3u3OaOTPItCoBTpYm/BC0vUTi8hQJH5QKdwbE
         MUSurLmCzQ5zw==
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

 net/ethtool/linkmodes.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index fc986d035b01..f9eda596f301 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -45,6 +45,9 @@ static int linkmodes_prepare_data(const struct ethnl_req_=
info *req_base,
 		goto out;
 	}
=20
+	if (!dev->ethtool_ops->cap_link_lanes_supported)
+		data->ksettings.lanes =3D 0;
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
@@ -125,6 +129,10 @@ static int linkmodes_fill_reply(struct sk_buff *skb,
 	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_DUPLEX, lsettings->duplex))
 		return -EMSGSIZE;
=20
+	if (ksettings->lanes &&
+	    nla_put_u32(skb, ETHTOOL_A_LINKMODES_LANES, ksettings->lanes))
+		return -EMSGSIZE;
+
 	if (lsettings->master_slave_cfg !=3D MASTER_SLAVE_CFG_UNSUPPORTED &&
 	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,
 		       lsettings->master_slave_cfg))
--=20
2.26.2

