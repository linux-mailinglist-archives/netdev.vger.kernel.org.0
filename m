Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23580114881
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 22:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbfLEVMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 16:12:30 -0500
Received: from mail-eopbgr00063.outbound.protection.outlook.com ([40.107.0.63]:34533
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729799AbfLEVM3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 16:12:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uiu6ktQ1A1OZ/lCKBDTrRvT+rtZ6Yi4IIsmRtN3jR9BQE29gpyrUDED1AQjIJ65qUSvIlsjI9F2KnZCmXOG9N9/AD6heC3pqoWg1rvfP0R8Mhtp+IMAh203aAZ3W15/xDN+X7GzyS0RFNLJwxp++uVY4CF1fD/EBBV/v0FRhlGMBmtrvHrJvSchQTTsJPreYifZIEuwTUsnkvQgV7lcziSh8Al7sRLkgIUZtcPpf6udM16sI/SLI6dYbYvu2B+akyMgvp7s3wcrcgmnS74RbicRJsduZqarhv2OqJdMqnC+j5ZDnfFn3UhWYIr/bm+dAq2PFOVRo3Dnsc1QTG3IItg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62dMy/Aj06/2oM3HrhBilW1Z+E26fxxjFKYNSi/dZGs=;
 b=lydICCF7HCsLFbag7+/sSR0W0lh19mjB7nDov65PWHvdH3Bvh2jzPdtlRwL6VLXGVeclk//ETYEsu8fUJTgDL+uS/DGef1XM0menf3/KmEtcfWAvXVSZl1EcgNPigA26itD4RKHnmy4Mgr6MRgUsQmXozgcoConisuqCZUan4tavNQpU9sYyuw7trsVWPGC0cotCqR2V5Kis7mum5clnQlzF5V1qUXy5GV5NqdFpf9cNxIruwDZNHyO+0IeAqptzak2qMwr4MGqMZXdZUeqelOKu/7hxvcttmbRB3iTrZfuQo/pUWqcOLXvh4VI03YJrw4+KSYOUiiZjEIKGjo9org==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62dMy/Aj06/2oM3HrhBilW1Z+E26fxxjFKYNSi/dZGs=;
 b=YDAIBc+Y0/HggFbKvSruR+RThFHUdqAE9JfflKeQvcNpgbwZn/rDoC1RM/8ETCorHIxw3msyxfKMsWHLZf8KYfJRdvm0QGIPWt/IslWItZiJjKH/+Y0ZQp574MYAkbb/wgrzOc7jUjm4EiUmv5cxrfx6xXE6IQq+s6xSEgwAUtA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3326.eurprd05.prod.outlook.com (10.175.244.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Thu, 5 Dec 2019 21:12:18 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881%5]) with mapi id 15.20.2495.014; Thu, 5 Dec 2019
 21:12:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 7/8] net/mlx5e: ethtool, Fix analysis of speed setting
Thread-Topic: [net 7/8] net/mlx5e: ethtool, Fix analysis of speed setting
Thread-Index: AQHVq7CsjOf3VRFN9UWfQSVxZlhJEw==
Date:   Thu, 5 Dec 2019 21:12:18 +0000
Message-ID: <20191205211052.14584-8-saeedm@mellanox.com>
References: <20191205211052.14584-1-saeedm@mellanox.com>
In-Reply-To: <20191205211052.14584-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR08CA0018.namprd08.prod.outlook.com
 (2603:10b6:a03:100::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 93cb9f6d-9d58-4cf0-4595-08d779c7cf3b
x-ms-traffictypediagnostic: VI1PR05MB3326:|VI1PR05MB3326:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3326594B6C4BEBAD9C91E9C3BE5C0@VI1PR05MB3326.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(199004)(189003)(107886003)(478600001)(25786009)(102836004)(6512007)(86362001)(6486002)(14454004)(6506007)(54906003)(2616005)(316002)(64756008)(11346002)(26005)(186003)(5660300002)(76176011)(8676002)(4326008)(50226002)(305945005)(99286004)(66446008)(81166006)(52116002)(81156014)(1076003)(71190400001)(71200400001)(6916009)(8936002)(2906002)(66476007)(66946007)(66556008)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3326;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: knC0AOUnzuLOGqMhA83aNYRiEbZDX3eyq0JNHe441tFSdcdgVa4TjidQgt2qar5YBVNZvA1cD8T3Aj6+Df656ZZP3UjfR8BKQ9sRtnudHMOw6ipQwSTM4UBMpclMfilXZWzk3AfcriPbwCvHMWXsJqCQB6tD8KbLtyEsvRrciMPKFPVjtcNp4GqIczixvGvxYuSvEM2nDTzN6Cg/Z/tuzintFbeTzOa+azhgW51+hlcIEk5pgr6b7klYjhz9nnXvp1nANXndLpsNuybj4ty7H7xPCfXFaXzdtgfpBwZYBgQXCQilY3jHSzCVU1tySF+CjyqXq5X418EU2uygz5eA+OYDqCCi43pkIoXVtXzbzb83zZqpexPlyy4WTocBC2rvJHnLFT3STj96ZNoUBU4IUPNkyY9RgKSXlD737TsvCJaLF43+7qJnt6PL+Xtnaekt
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93cb9f6d-9d58-4cf0-4595-08d779c7cf3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 21:12:18.1243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K5vZ9pUy7rXkIcBG8wPFouh/G3xP0/Gvxp8y4GZw6U7LfAfLR0qbrANmZGaH269Qdoj5mDLL75L4wDM7DyJWGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3326
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

When setting speed to 100G via ethtool (AN is set to off), only 25G*4 is
configured while the user, who has an advanced HW which supports
extended PTYS, expects also 50G*2 to be configured.
With this patch, when extended PTYS mode is available, configure
PTYS via extended fields.

Fixes: 4b95840a6ced ("net/mlx5e: Fix matching of speed to PRM link modes")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c    | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index d5d80be1a6c7..c6776f308d5e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1027,18 +1027,11 @@ static bool ext_link_mode_requested(const unsigned =
long *adver)
 	return bitmap_intersects(modes, adver, __ETHTOOL_LINK_MODE_MASK_NBITS);
 }
=20
-static bool ext_speed_requested(u32 speed)
-{
-#define MLX5E_MAX_PTYS_LEGACY_SPEED 100000
-	return !!(speed > MLX5E_MAX_PTYS_LEGACY_SPEED);
-}
-
-static bool ext_requested(u8 autoneg, const unsigned long *adver, u32 spee=
d)
+static bool ext_requested(u8 autoneg, const unsigned long *adver, bool ext=
_supported)
 {
 	bool ext_link_mode =3D ext_link_mode_requested(adver);
-	bool ext_speed =3D ext_speed_requested(speed);
=20
-	return  autoneg =3D=3D AUTONEG_ENABLE ? ext_link_mode : ext_speed;
+	return  autoneg =3D=3D AUTONEG_ENABLE ? ext_link_mode : ext_supported;
 }
=20
 int mlx5e_ethtool_set_link_ksettings(struct mlx5e_priv *priv,
@@ -1065,8 +1058,8 @@ int mlx5e_ethtool_set_link_ksettings(struct mlx5e_pri=
v *priv,
 	autoneg =3D link_ksettings->base.autoneg;
 	speed =3D link_ksettings->base.speed;
=20
-	ext =3D ext_requested(autoneg, adver, speed),
 	ext_supported =3D MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
+	ext =3D ext_requested(autoneg, adver, ext_supported);
 	if (!ext_supported && ext)
 		return -EOPNOTSUPP;
=20
--=20
2.21.0

