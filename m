Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD2F149378
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 06:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgAYFMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 00:12:14 -0500
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:50912
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728449AbgAYFMN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 00:12:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gfTr3gyprjWqoMwbCIcsT3GfhCIQCr2N/WFjqQZS3+7PhPRJZOr+wa6mjI1CR7S0FaTng4VIAOc3Si7aVYQI3SlhaiCQaQkctkpxKh9iZ6iHJXUpreGjj/i/z2lCvDMKiqmSjt2/Ooxcj5DIy6LgNjCfF8ypliAILgs2jL9Z6J9t3SCHKOwl7mKjGQk4kXkV2s9wCHzoT4MqDYvgL9v7j9Q+VcCWwApp3Ix6GWqHZWmyUOchygG8ySiTRFJmXPbDgEkwv/A6HHnc5rBbPOFvydZ9py9Bu+CMVwVyGYOThQx3s67iIpknUPvmDMpjGspRvDwyWypj914sZsKOU712Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCJuRU8jAoJyIYuY6vofdZ+W4cZHXhElLJZvrKbkUbs=;
 b=Xq7qAIY49kiYPqVF9O7W4j3aVmyAFZkcN8ane9n6WivcA4NKgkPLrSutQ25MYmQR5FMZT/gFmzNorpP+agMY8gx5dhbprVyj9hT7TDNhvnlq6IquF2Disy370mrDYBlpWl8Bvesn4N9hJazbKC5y/q9b+YJNw4bb3+oZM3/xnJp/fN9wrZCiK2okjRgcp9q0RuIidc22329Klnr+rJ8y0XPOVJgJTzA2vdJnKW1peW0ghBBqrEOO3wu2zo8hJALIOM1B4ZKWxi2TZ4ROmXuDn/GiCPboY3z/NW0m+AzdhY9e87Ezh21Hkg20THOmbjuzLuhXMEB4fpuhNgcplhdlWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCJuRU8jAoJyIYuY6vofdZ+W4cZHXhElLJZvrKbkUbs=;
 b=LyyL882LF3bbJO9FdnhLlVbaW4cNG9h6tzKiZxG6jHISl0j4RrePPTJ4gEMsoL6ld2+huRUiDdzzI9uXtYRk1/OGtuGvlUkBwa4Aw9CQOBkJZqRA/7KgKJJbB8PnxiY2kwQAX8gMFlri1cRKavxDmJDeMAOqmBn06bJRrgsrchM=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0394.eurprd05.prod.outlook.com (10.186.159.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Sat, 25 Jan 2020 05:11:52 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Sat, 25 Jan 2020
 05:11:52 +0000
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0025.namprd16.prod.outlook.com (2603:10b6:a03:1a0::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Sat, 25 Jan 2020 05:11:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 11/14] ethtool: Add support for low latency RS FEC
Thread-Topic: [net-next V2 11/14] ethtool: Add support for low latency RS FEC
Thread-Index: AQHV0z30mWH9Qamk9kSgrdqkMYV+GA==
Date:   Sat, 25 Jan 2020 05:11:52 +0000
Message-ID: <20200125051039.59165-12-saeedm@mellanox.com>
References: <20200125051039.59165-1-saeedm@mellanox.com>
In-Reply-To: <20200125051039.59165-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BY5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8969d47d-7bf3-4146-f10b-08d7a15516c3
x-ms-traffictypediagnostic: VI1SPR01MB0394:|VI1SPR01MB0394:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB0394A3D67BE88D8FE1B7B9A9BE090@VI1SPR01MB0394.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:428;
x-forefront-prvs: 0293D40691
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(199004)(189003)(1076003)(71200400001)(8936002)(316002)(16526019)(6916009)(186003)(2616005)(956004)(478600001)(54906003)(5660300002)(6486002)(4326008)(107886003)(86362001)(52116002)(2906002)(36756003)(66946007)(66476007)(81166006)(66446008)(64756008)(8676002)(26005)(81156014)(19627235002)(6506007)(66556008)(6512007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0394;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xTYIPQxbYRQbLbRXytfjJkNz+Cfca+KgRJJmS2QQPquM9iDgRtELgXnXxzOAPewaAAIIf0wGCSi03iNpJAXIXRWbwk3yZ7i7ruyvrQSY9QRkMGMvZ3b8YEX1Bg0+2lkrrsLWbmTRjgKbGXr+gjuJ//pCUYhAsmBBBThQurZvJJ8UUk71VXM/lEB/e9CGP90UULS+U2e1z/zyKnca9VUz6c9IzQc97TKn+LJQ7QS0VNv51gDcNlAnbZMR4nUvilwS0HoR0ArESkUtq6CZiwt1gF8SV/xeK5ePW7eDzMlRJCPhDaenvEQQY+GfBVTP7LZgJz2QQoUFTAyVdRsszNET1MAhEYaqlZ4cm7k0pjXHjzjjTJ9gfMeODiTXmGfqETm0ZX7FkbwVGosjiUeq7kvi8BPAdOwR8V3TvrzcU6/Pw6kV2odBadmug85e5mGBzBEonv1tTCzDteg3ywmjJnJz4FDIwiLK9hg0rG2iqqFXR0hhJ5icMl+yc08+4XEtl1ySqqMSAlTVt3ofaJlUQsxmrIlLeR+ym4+3ezR2RcNGdfc=
x-ms-exchange-antispam-messagedata: ejexuzMZJPv49y7KpDiOSP3idyny1GuyHjQ3NQJPyl9uH+J3XwThPuKhDa426CaKJwn5OdEzlybNnuMOWHeyAKtblKh/6q+6kTPCbWojIvif5dYMvSB62hdhyNOfJjdqG8qBsFEE91gMseghi/3T6g==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8969d47d-7bf3-4146-f10b-08d7a15516c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2020 05:11:52.5634
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iYq9J8L2ljppmg6Nu1o0h2xU2yP1vEO5iq+JFOhK3R+tgcblxm4CRG7AmrQfOCofA8i0e5ETLI8c4ZMDwOxINw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0394
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add support for low latency Reed Solomon FEC as LLRS.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/phy/phy-core.c   | 2 +-
 include/uapi/linux/ethtool.h | 4 +++-
 net/ethtool/common.c         | 1 +
 net/ethtool/linkmodes.c      | 1 +
 4 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index a4d2d59fceca..e083e7a76ada 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -8,7 +8,7 @@
=20
 const char *phy_speed_to_str(int speed)
 {
-	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS !=3D 74,
+	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS !=3D 75,
 		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
 		"If a speed or mode has been added please update phy_speed_to_str "
 		"and the PHY settings array.\n");
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 116bcbf09c74..e0c4383ea952 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1326,6 +1326,7 @@ enum ethtool_fec_config_bits {
 	ETHTOOL_FEC_OFF_BIT,
 	ETHTOOL_FEC_RS_BIT,
 	ETHTOOL_FEC_BASER_BIT,
+	ETHTOOL_FEC_LLRS_BIT,
 };
=20
 #define ETHTOOL_FEC_NONE		(1 << ETHTOOL_FEC_NONE_BIT)
@@ -1333,6 +1334,7 @@ enum ethtool_fec_config_bits {
 #define ETHTOOL_FEC_OFF			(1 << ETHTOOL_FEC_OFF_BIT)
 #define ETHTOOL_FEC_RS			(1 << ETHTOOL_FEC_RS_BIT)
 #define ETHTOOL_FEC_BASER		(1 << ETHTOOL_FEC_BASER_BIT)
+#define ETHTOOL_FEC_LLRS		(1 << ETHTOOL_FEC_LLRS_BIT)
=20
 /* CMDs currently supported */
 #define ETHTOOL_GSET		0x00000001 /* DEPRECATED, Get settings.
@@ -1517,7 +1519,7 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_400000baseLR8_ER8_FR8_Full_BIT =3D 71,
 	ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT	 =3D 72,
 	ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT	 =3D 73,
-
+	ETHTOOL_LINK_MODE_FEC_LLRS_BIT			 =3D 74,
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
 };
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index e621b1694d2f..8e4e809340f0 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -167,6 +167,7 @@ const char link_mode_names[][ETH_GSTRING_LEN] =3D {
 	__DEFINE_LINK_MODE_NAME(400000, LR8_ER8_FR8, Full),
 	__DEFINE_LINK_MODE_NAME(400000, DR8, Full),
 	__DEFINE_LINK_MODE_NAME(400000, CR8, Full),
+	__DEFINE_SPECIAL_MODE_NAME(FEC_LLRS, "LLRS"),
 };
 static_assert(ARRAY_SIZE(link_mode_names) =3D=3D __ETHTOOL_LINK_MODE_MASK_=
NBITS);
=20
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index 96f20be64553..f049b97072fe 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -237,6 +237,7 @@ static const struct link_mode_info link_mode_params[] =
=3D {
 	__DEFINE_LINK_MODE_PARAMS(400000, LR8_ER8_FR8, Full),
 	__DEFINE_LINK_MODE_PARAMS(400000, DR8, Full),
 	__DEFINE_LINK_MODE_PARAMS(400000, CR8, Full),
+	__DEFINE_SPECIAL_MODE_PARAMS(FEC_LLRS),
 };
=20
 static const struct nla_policy
--=20
2.24.1

