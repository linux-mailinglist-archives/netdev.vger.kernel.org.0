Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEEC2FCEEB
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 12:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730671AbhATLMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 06:12:45 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9525 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731536AbhATJiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 04:38:13 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6007f9db0000>; Wed, 20 Jan 2021 01:37:31 -0800
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 20 Jan 2021 09:37:28 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <mkubecek@suse.cz>,
        <mlxsw@nvidia.com>, <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next v3 1/7] ethtool: Extend link modes settings uAPI with lanes
Date:   Wed, 20 Jan 2021 11:37:07 +0200
Message-ID: <20210120093713.4000363-2-danieller@nvidia.com>
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
        t=1611135451; bh=76alY6PFgscyUtzOMbuE1UJJKSGydR5iTodpkNO+zXA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=RiXUxzbQ3gz7l5YWh9EkMJWR5LtoDJY9oIG3Fc6Ius/aP3JdfFRrPQuh0dSyxk1l8
         nd5FaWXy8lW4RYDiMho7V3QkocksmCKG/QeAy1P29b8I1HR1Pi+thwA5o+vWJJSJ+I
         i8bgLmBZrCd3XQ8RzkIe1RsAdUZrhR2aXMcVEeiqiJnNRQG3txZWarhPkuRleoOf1V
         gCfZC5q2gEyTyeUxtFHFydIokNJ2+78m4+Gt2zGsz18fPoW5uaWQ6lJdZgowZZUoKZ
         fRZgc/8lmfYl+WoGc3+bWDYIQmp9IdiuW/RQh0NXob/GuMDYSeJYfs0F/lAZnM+c9N
         bAhpdCf9jRQCw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when auto negotiation is on, the user can advertise all the
linkmodes which correspond to a specific speed, but does not have a
similar selector for the number of lanes. This is significant when a
specific speed can be achieved using different number of lanes.  For
example, 2x50 or 4x25.

Add 'ETHTOOL_A_LINKMODES_LANES' attribute and expand 'struct
ethtool_link_settings' with lanes field in order to implement a new
lanes-selector that will enable the user to advertise a specific number
of lanes as well.

When auto negotiation is off, lanes parameter can be forced only if the
driver supports it. Add a capability bit in 'struct ethtool_ops' that
allows ethtool know if the driver can handle the lanes parameter when
auto negotiation is off, so if it does not, an error message will be
returned when trying to set lanes.

Example:

$ ethtool -s swp1 lanes 4
$ ethtool swp1
  Settings for swp1:
	Supported ports: [ FIBRE ]
        Supported link modes:   1000baseKX/Full
                                10000baseKR/Full
                                40000baseCR4/Full
				40000baseSR4/Full
				40000baseLR4/Full
                                25000baseCR/Full
                                25000baseSR/Full
				50000baseCR2/Full
                                100000baseSR4/Full
				100000baseCR4/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  40000baseCR4/Full
				40000baseSR4/Full
				40000baseLR4/Full
                                100000baseSR4/Full
				100000baseCR4/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: Unknown!
        Duplex: Unknown! (255)
        Auto-negotiation: on
        Port: Direct Attach Copper
        PHYAD: 0
        Transceiver: internal
        Link detected: no

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
---

Notes:
    v3:
    	* Change ethtool_ops.capabilities to be a bitfield and rename it.
    	* Add an according kdoc.
    	* Set min and max for the lanes policy.
    	* Change the lanes validation to be the power of two, now that the
    	  min and max are set.
   =20
    v2:
    	* Remove ETHTOOL_LANES defines and simply use a number instead.

 Documentation/networking/ethtool-netlink.rst |  11 +-
 include/linux/ethtool.h                      |   4 +
 include/uapi/linux/ethtool.h                 |   2 +
 include/uapi/linux/ethtool_netlink.h         |   1 +
 net/ethtool/linkmodes.c                      | 214 +++++++++++--------
 net/ethtool/netlink.h                        |   2 +-
 6 files changed, 139 insertions(+), 95 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/n=
etworking/ethtool-netlink.rst
index 30b98245979f..05073482db05 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -431,16 +431,17 @@ Request contents:
   ``ETHTOOL_A_LINKMODES_SPEED``               u32     link speed (Mb/s)
   ``ETHTOOL_A_LINKMODES_DUPLEX``              u8      duplex mode
   ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG``    u8      Master/slave port mo=
de
+  ``ETHTOOL_A_LINKMODES_LANES``               u32     lanes
   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D =
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
=20
 ``ETHTOOL_A_LINKMODES_OURS`` bit set allows setting advertised link modes.=
 If
 autonegotiation is on (either set now or kept from before), advertised mod=
es
 are not changed (no ``ETHTOOL_A_LINKMODES_OURS`` attribute) and at least o=
ne
-of speed and duplex is specified, kernel adjusts advertised modes to all
-supported modes matching speed, duplex or both (whatever is specified). Th=
is
-autoselection is done on ethtool side with ioctl interface, netlink interf=
ace
-is supposed to allow requesting changes without knowing what exactly kerne=
l
-supports.
+of speed, duplex and lanes is specified, kernel adjusts advertised modes t=
o all
+supported modes matching speed, duplex, lanes or all (whatever is specifie=
d).
+This autoselection is done on ethtool side with ioctl interface, netlink
+interface is supposed to allow requesting changes without knowing what exa=
ctly
+kernel supports.
=20
=20
 LINKSTATE_GET
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index e3da25b51ae4..1ab13c5dfb2f 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -128,6 +128,7 @@ struct ethtool_link_ksettings {
 		__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
 		__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising);
 	} link_modes;
+	u32	lanes;
 };
=20
 /**
@@ -265,6 +266,8 @@ struct ethtool_pause_stats {
=20
 /**
  * struct ethtool_ops - optional netdev operations
+ * @cap_link_lanes_supported: indicates if the driver supports lanes
+ *	parameter.
  * @supported_coalesce_params: supported types of interrupt coalescing.
  * @get_drvinfo: Report driver/device information.  Should only set the
  *	@driver, @version, @fw_version and @bus_info fields.  If not
@@ -420,6 +423,7 @@ struct ethtool_pause_stats {
  * of the generic netdev features interface.
  */
 struct ethtool_ops {
+	u32     cap_link_lanes_supported:1;
 	u32	supported_coalesce_params;
 	void	(*get_drvinfo)(struct net_device *, struct ethtool_drvinfo *);
 	int	(*get_regs_len)(struct net_device *);
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index cde753bb2093..80edae2c24f7 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1738,6 +1738,8 @@ static inline int ethtool_validate_speed(__u32 speed)
 	return speed <=3D INT_MAX || speed =3D=3D (__u32)SPEED_UNKNOWN;
 }
=20
+#define ETHTOOL_LANES_UNKNOWN		0
+
 /* Duplex, half or full. */
 #define DUPLEX_HALF		0x00
 #define DUPLEX_FULL		0x01
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/etht=
ool_netlink.h
index e2bf36e6964b..a286635ac9b8 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -227,6 +227,7 @@ enum {
 	ETHTOOL_A_LINKMODES_DUPLEX,		/* u8 */
 	ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,	/* u8 */
 	ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,	/* u8 */
+	ETHTOOL_A_LINKMODES_LANES,		/* u32 */
=20
 	/* add new constants above here */
 	__ETHTOOL_A_LINKMODES_CNT,
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index c5bcb9abc8b9..fb7d73250864 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -152,12 +152,14 @@ const struct ethnl_request_ops ethnl_linkmodes_reques=
t_ops =3D {
=20
 struct link_mode_info {
 	int				speed;
+	u32				lanes;
 	u8				duplex;
 };
=20
-#define __DEFINE_LINK_MODE_PARAMS(_speed, _type, _duplex) \
+#define __DEFINE_LINK_MODE_PARAMS(_speed, _type, _lanes, _duplex) \
 	[ETHTOOL_LINK_MODE(_speed, _type, _duplex)] =3D { \
 		.speed	=3D SPEED_ ## _speed, \
+		.lanes	=3D _lanes, \
 		.duplex	=3D __DUPLEX_ ## _duplex \
 	}
 #define __DUPLEX_Half DUPLEX_HALF
@@ -165,105 +167,106 @@ struct link_mode_info {
 #define __DEFINE_SPECIAL_MODE_PARAMS(_mode) \
 	[ETHTOOL_LINK_MODE_ ## _mode ## _BIT] =3D { \
 		.speed	=3D SPEED_UNKNOWN, \
+		.lanes	=3D ETHTOOL_LANES_UNKNOWN, \
 		.duplex	=3D DUPLEX_UNKNOWN, \
 	}
=20
 static const struct link_mode_info link_mode_params[] =3D {
-	__DEFINE_LINK_MODE_PARAMS(10, T, Half),
-	__DEFINE_LINK_MODE_PARAMS(10, T, Full),
-	__DEFINE_LINK_MODE_PARAMS(100, T, Half),
-	__DEFINE_LINK_MODE_PARAMS(100, T, Full),
-	__DEFINE_LINK_MODE_PARAMS(1000, T, Half),
-	__DEFINE_LINK_MODE_PARAMS(1000, T, Full),
+	__DEFINE_LINK_MODE_PARAMS(10, T, 1, Half),
+	__DEFINE_LINK_MODE_PARAMS(10, T, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100, T, 1, Half),
+	__DEFINE_LINK_MODE_PARAMS(100, T, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(1000, T, 1, Half),
+	__DEFINE_LINK_MODE_PARAMS(1000, T, 1, Full),
 	__DEFINE_SPECIAL_MODE_PARAMS(Autoneg),
 	__DEFINE_SPECIAL_MODE_PARAMS(TP),
 	__DEFINE_SPECIAL_MODE_PARAMS(AUI),
 	__DEFINE_SPECIAL_MODE_PARAMS(MII),
 	__DEFINE_SPECIAL_MODE_PARAMS(FIBRE),
 	__DEFINE_SPECIAL_MODE_PARAMS(BNC),
-	__DEFINE_LINK_MODE_PARAMS(10000, T, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, T, 1, Full),
 	__DEFINE_SPECIAL_MODE_PARAMS(Pause),
 	__DEFINE_SPECIAL_MODE_PARAMS(Asym_Pause),
-	__DEFINE_LINK_MODE_PARAMS(2500, X, Full),
+	__DEFINE_LINK_MODE_PARAMS(2500, X, 1, Full),
 	__DEFINE_SPECIAL_MODE_PARAMS(Backplane),
-	__DEFINE_LINK_MODE_PARAMS(1000, KX, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, KX4, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, KR, Full),
+	__DEFINE_LINK_MODE_PARAMS(1000, KX, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, KX4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, KR, 1, Full),
 	[ETHTOOL_LINK_MODE_10000baseR_FEC_BIT] =3D {
 		.speed	=3D SPEED_10000,
 		.duplex =3D DUPLEX_FULL,
 	},
-	__DEFINE_LINK_MODE_PARAMS(20000, MLD2, Full),
-	__DEFINE_LINK_MODE_PARAMS(20000, KR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(40000, KR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(40000, CR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(40000, SR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(40000, LR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(56000, KR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(56000, CR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(56000, SR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(56000, LR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(25000, CR, Full),
-	__DEFINE_LINK_MODE_PARAMS(25000, KR, Full),
-	__DEFINE_LINK_MODE_PARAMS(25000, SR, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, CR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, KR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, KR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, SR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, CR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, LR4_ER4, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, SR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(1000, X, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, CR, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, SR, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, LR, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, LRM, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, ER, Full),
-	__DEFINE_LINK_MODE_PARAMS(2500, T, Full),
-	__DEFINE_LINK_MODE_PARAMS(5000, T, Full),
+	__DEFINE_LINK_MODE_PARAMS(20000, MLD2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(20000, KR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(40000, KR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(40000, CR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(40000, SR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(40000, LR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(56000, KR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(56000, CR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(56000, SR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(56000, LR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(25000, CR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(25000, KR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(25000, SR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, CR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, KR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, KR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, SR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, CR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, LR4_ER4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, SR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(1000, X, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, CR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, SR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, LR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, LRM, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, ER, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(2500, T, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(5000, T, 1, Full),
 	__DEFINE_SPECIAL_MODE_PARAMS(FEC_NONE),
 	__DEFINE_SPECIAL_MODE_PARAMS(FEC_RS),
 	__DEFINE_SPECIAL_MODE_PARAMS(FEC_BASER),
-	__DEFINE_LINK_MODE_PARAMS(50000, KR, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, SR, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, CR, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, LR_ER_FR, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, DR, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, KR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, SR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, CR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, LR2_ER2_FR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, DR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, KR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, SR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, LR4_ER4_FR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, DR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, CR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100, T1, Full),
-	__DEFINE_LINK_MODE_PARAMS(1000, T1, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, KR8, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, SR8, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, LR8_ER8_FR8, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, DR8, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, CR8, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, KR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, SR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, CR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, LR_ER_FR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(50000, DR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, KR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, SR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, CR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, LR2_ER2_FR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, DR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, KR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, SR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, LR4_ER4_FR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, DR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, CR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100, T1, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(1000, T1, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, KR8, 8, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, SR8, 8, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, LR8_ER8_FR8, 8, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, DR8, 8, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, CR8, 8, Full),
 	__DEFINE_SPECIAL_MODE_PARAMS(FEC_LLRS),
-	__DEFINE_LINK_MODE_PARAMS(100000, KR, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, SR, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, LR_ER_FR, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, DR, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, CR, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, KR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, SR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, LR2_ER2_FR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, DR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, CR2, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, KR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, SR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, LR4_ER4_FR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, DR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, CR4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100, FX, Half),
-	__DEFINE_LINK_MODE_PARAMS(100, FX, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, KR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, SR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, LR_ER_FR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, DR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100000, CR, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, KR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, SR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, LR2_ER2_FR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, DR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(200000, CR2, 2, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, KR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, SR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, LR4_ER4_FR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, DR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(400000, CR4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(100, FX, 1, Half),
+	__DEFINE_LINK_MODE_PARAMS(100, FX, 1, Full),
 };
=20
 const struct nla_policy ethnl_linkmodes_set_policy[] =3D {
@@ -274,16 +277,17 @@ const struct nla_policy ethnl_linkmodes_set_policy[] =
=3D {
 	[ETHTOOL_A_LINKMODES_SPEED]		=3D { .type =3D NLA_U32 },
 	[ETHTOOL_A_LINKMODES_DUPLEX]		=3D { .type =3D NLA_U8 },
 	[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG]	=3D { .type =3D NLA_U8 },
+	[ETHTOOL_A_LINKMODES_LANES]		=3D NLA_POLICY_RANGE(NLA_U32, 1, 8),
 };
=20
-/* Set advertised link modes to all supported modes matching requested spe=
ed
- * and duplex values. Called when autonegotiation is on, speed or duplex i=
s
- * requested but no link mode change. This is done in userspace with ioctl=
()
- * interface, move it into kernel for netlink.
+/* Set advertised link modes to all supported modes matching requested spe=
ed,
+ * lanes and duplex values. Called when autonegotiation is on, speed, lane=
s or
+ * duplex is requested but no link mode change. This is done in userspace =
with
+ * ioctl() interface, move it into kernel for netlink.
  * Returns true if advertised modes bitmap was modified.
  */
 static bool ethnl_auto_linkmodes(struct ethtool_link_ksettings *ksettings,
-				 bool req_speed, bool req_duplex)
+				 bool req_speed, bool req_lanes, bool req_duplex)
 {
 	unsigned long *advertising =3D ksettings->link_modes.advertising;
 	unsigned long *supported =3D ksettings->link_modes.supported;
@@ -302,6 +306,7 @@ static bool ethnl_auto_linkmodes(struct ethtool_link_ks=
ettings *ksettings,
 			continue;
 		if (test_bit(i, supported) &&
 		    (!req_speed || info->speed =3D=3D ksettings->base.speed) &&
+		    (!req_lanes || info->lanes =3D=3D ksettings->lanes) &&
 		    (!req_duplex || info->duplex =3D=3D ksettings->base.duplex))
 			set_bit(i, advertising);
 		else
@@ -327,10 +332,10 @@ static bool ethnl_validate_master_slave_cfg(u8 cfg)
=20
 static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **=
tb,
 				  struct ethtool_link_ksettings *ksettings,
-				  bool *mod)
+				  bool *mod, const struct net_device *dev)
 {
 	struct ethtool_link_settings *lsettings =3D &ksettings->base;
-	bool req_speed, req_duplex;
+	bool req_speed, req_lanes, req_duplex;
 	const struct nlattr *master_slave_cfg;
 	int ret;
=20
@@ -353,10 +358,39 @@ static int ethnl_update_linkmodes(struct genl_info *i=
nfo, struct nlattr **tb,
=20
 	*mod =3D false;
 	req_speed =3D tb[ETHTOOL_A_LINKMODES_SPEED];
+	req_lanes =3D tb[ETHTOOL_A_LINKMODES_LANES];
 	req_duplex =3D tb[ETHTOOL_A_LINKMODES_DUPLEX];
=20
 	ethnl_update_u8(&lsettings->autoneg, tb[ETHTOOL_A_LINKMODES_AUTONEG],
 			mod);
+
+	if (req_lanes) {
+		u32 lanes_cfg =3D nla_get_u32(tb[ETHTOOL_A_LINKMODES_LANES]);
+
+		if (!is_power_of_2(lanes_cfg)) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[ETHTOOL_A_LINKMODES_LANES],
+					    "lanes value is invalid");
+			return -EINVAL;
+		}
+
+		/* If autoneg is off and lanes parameter is not supported by the
+		 * driver, return an error.
+		 */
+		if (!lsettings->autoneg &&
+		    !dev->ethtool_ops->cap_link_lanes_supported) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    tb[ETHTOOL_A_LINKMODES_LANES],
+					    "lanes configuration not supported by device");
+			return -EOPNOTSUPP;
+		}
+	} else if (!lsettings->autoneg) {
+		/* If autoneg is off and lanes parameter is not passed from user,
+		 * set the lanes parameter to UNKNOWN.
+		 */
+		ksettings->lanes =3D ETHTOOL_LANES_UNKNOWN;
+	}
+
 	ret =3D ethnl_update_bitset(ksettings->link_modes.advertising,
 				  __ETHTOOL_LINK_MODE_MASK_NBITS,
 				  tb[ETHTOOL_A_LINKMODES_OURS], link_mode_names,
@@ -365,13 +399,15 @@ static int ethnl_update_linkmodes(struct genl_info *i=
nfo, struct nlattr **tb,
 		return ret;
 	ethnl_update_u32(&lsettings->speed, tb[ETHTOOL_A_LINKMODES_SPEED],
 			 mod);
+	ethnl_update_u32(&ksettings->lanes, tb[ETHTOOL_A_LINKMODES_LANES],
+			 mod);
 	ethnl_update_u8(&lsettings->duplex, tb[ETHTOOL_A_LINKMODES_DUPLEX],
 			mod);
 	ethnl_update_u8(&lsettings->master_slave_cfg, master_slave_cfg, mod);
=20
 	if (!tb[ETHTOOL_A_LINKMODES_OURS] && lsettings->autoneg &&
-	    (req_speed || req_duplex) &&
-	    ethnl_auto_linkmodes(ksettings, req_speed, req_duplex))
+	    (req_speed || req_lanes || req_duplex) &&
+	    ethnl_auto_linkmodes(ksettings, req_speed, req_lanes, req_duplex))
 		*mod =3D true;
=20
 	return 0;
@@ -409,7 +445,7 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct gen=
l_info *info)
 		goto out_ops;
 	}
=20
-	ret =3D ethnl_update_linkmodes(info, tb, &ksettings, &mod);
+	ret =3D ethnl_update_linkmodes(info, tb, &ksettings, &mod, dev);
 	if (ret < 0)
 		goto out_ops;
=20
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index d8efec516d86..6eabd58d81bf 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -351,7 +351,7 @@ extern const struct nla_policy ethnl_strset_get_policy[=
ETHTOOL_A_STRSET_COUNTS_O
 extern const struct nla_policy ethnl_linkinfo_get_policy[ETHTOOL_A_LINKINF=
O_HEADER + 1];
 extern const struct nla_policy ethnl_linkinfo_set_policy[ETHTOOL_A_LINKINF=
O_TP_MDIX_CTRL + 1];
 extern const struct nla_policy ethnl_linkmodes_get_policy[ETHTOOL_A_LINKMO=
DES_HEADER + 1];
-extern const struct nla_policy ethnl_linkmodes_set_policy[ETHTOOL_A_LINKMO=
DES_MASTER_SLAVE_CFG + 1];
+extern const struct nla_policy ethnl_linkmodes_set_policy[ETHTOOL_A_LINKMO=
DES_LANES + 1];
 extern const struct nla_policy ethnl_linkstate_get_policy[ETHTOOL_A_LINKST=
ATE_HEADER + 1];
 extern const struct nla_policy ethnl_debug_get_policy[ETHTOOL_A_DEBUG_HEAD=
ER + 1];
 extern const struct nla_policy ethnl_debug_set_policy[ETHTOOL_A_DEBUG_MSGM=
ASK + 1];
--=20
2.26.2

