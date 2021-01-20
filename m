Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8149A2FCEED
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 12:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388937AbhATLOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 06:14:17 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9536 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731540AbhATJiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 04:38:14 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6007f9de0000>; Wed, 20 Jan 2021 01:37:34 -0800
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 20 Jan 2021 09:37:31 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <mkubecek@suse.cz>,
        <mlxsw@nvidia.com>, <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next v3 2/7] ethtool: Get link mode in use instead of speed and duplex parameters
Date:   Wed, 20 Jan 2021 11:37:08 +0200
Message-ID: <20210120093713.4000363-3-danieller@nvidia.com>
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
        t=1611135454; bh=i9YHLKrUzhqmidhuDG4rotkoTWu9EgeqtmjSHTwik9c=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=gNtXitp4r5XZHX8hkwGSb+SG/xN7WhrhFKHuBSh8LO0sNa8kjqoC4vB6ANnDU/j+r
         A2hGu/PjnlSaEsEtVN9ahnhuyMLdkxvOiNVrxfSJMaFtevz/5uee72PFraJB8q3o0c
         waG3UMx3DPlaKHy0+en5/4guGHjZ2275w17EkE/ojVQvsn3iRk8V5LTUtQelvndwTT
         YpEJ2jZb0nHT2mdD6rxWe1aNuEpVaSMS9rHBrlnXzcU24hhVWF1/wFJ/ai8Ld85jm8
         AE0FP7w2iIwLs9BESToFTz6D6Xt8K53gT3P2J4m1y5yfXmSoUDyu9GnDsSag8mPLCA
         bIOXs1DJZiIkw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when user space queries the link's parameters, as speed and
duplex, each parameter is passed from the driver to ethtool.

Instead, get the link mode bit in use, and derive each of the parameters
from it in ethtool.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
---

Notes:
    v3:
    	* Remove 'ETHTOOL_A_LINKMODES_LINK_MODE' from Documentation since
    	  it is not used.
    	* Remove LINK_MODE_UNKNOWN from uapi.
    	* Remove an unnecessary loop.
    	* Move link_mode_info and link_mode_params to common file.
    	* Move the speed, duplex and lanes derivation to the wrapper
    	  __ethtool_get_link_ksettings().

 include/linux/ethtool.h |   1 +
 net/ethtool/common.c    | 114 ++++++++++++++++++++++++++++++++++++
 net/ethtool/common.h    |   7 +++
 net/ethtool/ioctl.c     |  18 +++++-
 net/ethtool/linkmodes.c | 124 +---------------------------------------
 5 files changed, 141 insertions(+), 123 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 1ab13c5dfb2f..ec4cd3921c67 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -129,6 +129,7 @@ struct ethtool_link_ksettings {
 		__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising);
 	} link_modes;
 	u32	lanes;
+	enum ethtool_link_mode_bit_indices link_mode;
 };
=20
 /**
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 24036e3055a1..399eee4a2051 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -197,6 +197,120 @@ const char link_mode_names[][ETH_GSTRING_LEN] =3D {
 };
 static_assert(ARRAY_SIZE(link_mode_names) =3D=3D __ETHTOOL_LINK_MODE_MASK_=
NBITS);
=20
+#define __DEFINE_LINK_MODE_PARAMS(_speed, _type, _lanes, _duplex) \
+	[ETHTOOL_LINK_MODE(_speed, _type, _duplex)] =3D { \
+		.speed	=3D SPEED_ ## _speed, \
+		.lanes	=3D _lanes, \
+		.duplex	=3D __DUPLEX_ ## _duplex \
+	}
+#define __DUPLEX_Half DUPLEX_HALF
+#define __DUPLEX_Full DUPLEX_FULL
+#define __DEFINE_SPECIAL_MODE_PARAMS(_mode) \
+	[ETHTOOL_LINK_MODE_ ## _mode ## _BIT] =3D { \
+		.speed	=3D SPEED_UNKNOWN, \
+		.lanes	=3D ETHTOOL_LANES_UNKNOWN, \
+		.duplex	=3D DUPLEX_UNKNOWN, \
+	}
+
+const struct link_mode_info link_mode_params[] =3D {
+	__DEFINE_LINK_MODE_PARAMS(10, T, 1, Half),
+	__DEFINE_LINK_MODE_PARAMS(10, T, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(100, T, 1, Half),
+	__DEFINE_LINK_MODE_PARAMS(100, T, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(1000, T, 1, Half),
+	__DEFINE_LINK_MODE_PARAMS(1000, T, 1, Full),
+	__DEFINE_SPECIAL_MODE_PARAMS(Autoneg),
+	__DEFINE_SPECIAL_MODE_PARAMS(TP),
+	__DEFINE_SPECIAL_MODE_PARAMS(AUI),
+	__DEFINE_SPECIAL_MODE_PARAMS(MII),
+	__DEFINE_SPECIAL_MODE_PARAMS(FIBRE),
+	__DEFINE_SPECIAL_MODE_PARAMS(BNC),
+	__DEFINE_LINK_MODE_PARAMS(10000, T, 1, Full),
+	__DEFINE_SPECIAL_MODE_PARAMS(Pause),
+	__DEFINE_SPECIAL_MODE_PARAMS(Asym_Pause),
+	__DEFINE_LINK_MODE_PARAMS(2500, X, 1, Full),
+	__DEFINE_SPECIAL_MODE_PARAMS(Backplane),
+	__DEFINE_LINK_MODE_PARAMS(1000, KX, 1, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, KX4, 4, Full),
+	__DEFINE_LINK_MODE_PARAMS(10000, KR, 1, Full),
+	[ETHTOOL_LINK_MODE_10000baseR_FEC_BIT] =3D {
+		.speed	=3D SPEED_10000,
+		.duplex =3D DUPLEX_FULL,
+	},
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
+	__DEFINE_SPECIAL_MODE_PARAMS(FEC_NONE),
+	__DEFINE_SPECIAL_MODE_PARAMS(FEC_RS),
+	__DEFINE_SPECIAL_MODE_PARAMS(FEC_BASER),
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
+	__DEFINE_SPECIAL_MODE_PARAMS(FEC_LLRS),
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
+};
+static_assert(ARRAY_SIZE(link_mode_params) =3D=3D __ETHTOOL_LINK_MODE_MASK=
_NBITS);
+
 const char netif_msg_class_names[][ETH_GSTRING_LEN] =3D {
 	[NETIF_MSG_DRV_BIT]		=3D "drv",
 	[NETIF_MSG_PROBE_BIT]		=3D "probe",
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index 3d9251c95a8b..625c8472700c 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -14,6 +14,12 @@
=20
 #define __SOF_TIMESTAMPING_CNT (const_ilog2(SOF_TIMESTAMPING_LAST) + 1)
=20
+struct link_mode_info {
+	int				speed;
+	u32				lanes;
+	u8				duplex;
+};
+
 extern const char
 netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN];
 extern const char
@@ -23,6 +29,7 @@ tunable_strings[__ETHTOOL_TUNABLE_COUNT][ETH_GSTRING_LEN]=
;
 extern const char
 phy_tunable_strings[__ETHTOOL_PHY_TUNABLE_COUNT][ETH_GSTRING_LEN];
 extern const char link_mode_names[][ETH_GSTRING_LEN];
+extern const struct link_mode_info link_mode_params[];
 extern const char netif_msg_class_names[][ETH_GSTRING_LEN];
 extern const char wol_mode_names[][ETH_GSTRING_LEN];
 extern const char sof_timestamping_names[][ETH_GSTRING_LEN];
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 771688e1b0da..24783b71c584 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -426,13 +426,29 @@ struct ethtool_link_usettings {
 int __ethtool_get_link_ksettings(struct net_device *dev,
 				 struct ethtool_link_ksettings *link_ksettings)
 {
+	const struct link_mode_info *link_info;
+	int err;
+
 	ASSERT_RTNL();
=20
 	if (!dev->ethtool_ops->get_link_ksettings)
 		return -EOPNOTSUPP;
=20
 	memset(link_ksettings, 0, sizeof(*link_ksettings));
-	return dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
+
+	link_ksettings->link_mode =3D -1;
+	err =3D dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
+	if (err)
+		return err;
+
+	if (link_ksettings->link_mode !=3D -1) {
+		link_info =3D &link_mode_params[link_ksettings->link_mode];
+		link_ksettings->base.speed =3D link_info->speed;
+		link_ksettings->lanes =3D link_info->lanes;
+		link_ksettings->base.duplex =3D link_info->duplex;
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL(__ethtool_get_link_ksettings);
=20
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index fb7d73250864..caf9111c5270 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -4,6 +4,8 @@
 #include "common.h"
 #include "bitset.h"
=20
+/* LINKMODES_GET */
+
 struct linkmodes_req_info {
 	struct ethnl_req_info		base;
 };
@@ -150,125 +152,6 @@ const struct ethnl_request_ops ethnl_linkmodes_reques=
t_ops =3D {
=20
 /* LINKMODES_SET */
=20
-struct link_mode_info {
-	int				speed;
-	u32				lanes;
-	u8				duplex;
-};
-
-#define __DEFINE_LINK_MODE_PARAMS(_speed, _type, _lanes, _duplex) \
-	[ETHTOOL_LINK_MODE(_speed, _type, _duplex)] =3D { \
-		.speed	=3D SPEED_ ## _speed, \
-		.lanes	=3D _lanes, \
-		.duplex	=3D __DUPLEX_ ## _duplex \
-	}
-#define __DUPLEX_Half DUPLEX_HALF
-#define __DUPLEX_Full DUPLEX_FULL
-#define __DEFINE_SPECIAL_MODE_PARAMS(_mode) \
-	[ETHTOOL_LINK_MODE_ ## _mode ## _BIT] =3D { \
-		.speed	=3D SPEED_UNKNOWN, \
-		.lanes	=3D ETHTOOL_LANES_UNKNOWN, \
-		.duplex	=3D DUPLEX_UNKNOWN, \
-	}
-
-static const struct link_mode_info link_mode_params[] =3D {
-	__DEFINE_LINK_MODE_PARAMS(10, T, 1, Half),
-	__DEFINE_LINK_MODE_PARAMS(10, T, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(100, T, 1, Half),
-	__DEFINE_LINK_MODE_PARAMS(100, T, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(1000, T, 1, Half),
-	__DEFINE_LINK_MODE_PARAMS(1000, T, 1, Full),
-	__DEFINE_SPECIAL_MODE_PARAMS(Autoneg),
-	__DEFINE_SPECIAL_MODE_PARAMS(TP),
-	__DEFINE_SPECIAL_MODE_PARAMS(AUI),
-	__DEFINE_SPECIAL_MODE_PARAMS(MII),
-	__DEFINE_SPECIAL_MODE_PARAMS(FIBRE),
-	__DEFINE_SPECIAL_MODE_PARAMS(BNC),
-	__DEFINE_LINK_MODE_PARAMS(10000, T, 1, Full),
-	__DEFINE_SPECIAL_MODE_PARAMS(Pause),
-	__DEFINE_SPECIAL_MODE_PARAMS(Asym_Pause),
-	__DEFINE_LINK_MODE_PARAMS(2500, X, 1, Full),
-	__DEFINE_SPECIAL_MODE_PARAMS(Backplane),
-	__DEFINE_LINK_MODE_PARAMS(1000, KX, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, KX4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, KR, 1, Full),
-	[ETHTOOL_LINK_MODE_10000baseR_FEC_BIT] =3D {
-		.speed	=3D SPEED_10000,
-		.duplex =3D DUPLEX_FULL,
-	},
-	__DEFINE_LINK_MODE_PARAMS(20000, MLD2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(20000, KR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(40000, KR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(40000, CR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(40000, SR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(40000, LR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(56000, KR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(56000, CR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(56000, SR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(56000, LR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(25000, CR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(25000, KR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(25000, SR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, CR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, KR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, KR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, SR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, CR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, LR4_ER4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, SR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(1000, X, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, CR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, SR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, LR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, LRM, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(10000, ER, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(2500, T, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(5000, T, 1, Full),
-	__DEFINE_SPECIAL_MODE_PARAMS(FEC_NONE),
-	__DEFINE_SPECIAL_MODE_PARAMS(FEC_RS),
-	__DEFINE_SPECIAL_MODE_PARAMS(FEC_BASER),
-	__DEFINE_LINK_MODE_PARAMS(50000, KR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, SR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, CR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, LR_ER_FR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(50000, DR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, KR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, SR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, CR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, LR2_ER2_FR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, DR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, KR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, SR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, LR4_ER4_FR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, DR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, CR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100, T1, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(1000, T1, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, KR8, 8, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, SR8, 8, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, LR8_ER8_FR8, 8, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, DR8, 8, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, CR8, 8, Full),
-	__DEFINE_SPECIAL_MODE_PARAMS(FEC_LLRS),
-	__DEFINE_LINK_MODE_PARAMS(100000, KR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, SR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, LR_ER_FR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, DR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(100000, CR, 1, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, KR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, SR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, LR2_ER2_FR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, DR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(200000, CR2, 2, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, KR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, SR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, LR4_ER4_FR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, DR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(400000, CR4, 4, Full),
-	__DEFINE_LINK_MODE_PARAMS(100, FX, 1, Half),
-	__DEFINE_LINK_MODE_PARAMS(100, FX, 1, Full),
-};
-
 const struct nla_policy ethnl_linkmodes_set_policy[] =3D {
 	[ETHTOOL_A_LINKMODES_HEADER]		=3D
 		NLA_POLICY_NESTED(ethnl_header_policy),
@@ -294,9 +177,6 @@ static bool ethnl_auto_linkmodes(struct ethtool_link_ks=
ettings *ksettings,
 	DECLARE_BITMAP(old_adv, __ETHTOOL_LINK_MODE_MASK_NBITS);
 	unsigned int i;
=20
-	BUILD_BUG_ON(ARRAY_SIZE(link_mode_params) !=3D
-		     __ETHTOOL_LINK_MODE_MASK_NBITS);
-
 	bitmap_copy(old_adv, advertising, __ETHTOOL_LINK_MODE_MASK_NBITS);
=20
 	for (i =3D 0; i < __ETHTOOL_LINK_MODE_MASK_NBITS; i++) {
--=20
2.26.2

