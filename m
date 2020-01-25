Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71B15149371
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 06:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgAYFLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 00:11:47 -0500
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:50912
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727590AbgAYFLq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 00:11:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mfEF+qR3Daxrt7swR+a6jzk0MBoodaUO6iVockNG3HnBxJs7Kg/yfTRhvTOHKdGpj7v2gg5V3sTzJ7cq1oQsov2MehZIAbXdR1/elWUT0kdNsPzs0XlNvgKy+aXqmR9HNSGXLSR9J+0B/Rps7m1yeh/LEIZNSa5Ng0SqwPKmAfmTypKCTCSDpF+ZzrxI1JoqQNWnBg48DkgLqlCazmTnNfsgCYuE22Ijkxdnar4IvWSyLqj8Z9HNJOGdUVAoRtqWFh/86Y83ue6Y/mpjjh/3KgGgxKhkzDXlnjrRwCyWd+HqiizueM/0DYLNr6c6l/eknHNU4u2jPEykCcZuTzggMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nxV+DVW+l5LEMtna4GMdCvJf7TpAohvJV15WiZDUeAs=;
 b=QyXbLof5zX7ZQeF3GCJIApI/NdE8eDzDlfcHUCq0JWfsT9PKJ2814KIVqwqHaZKJwVkcvJ9txolypI+QDYc5tIf3aaP4j3WRtJATkDEJaB+lVhcM4Avrhrf8R4cPIsuNsPACETk49+7/2pr6KppPkB6VuA8tgA/z14mRlqwSJK5J6ug33Lqz8RzpzbvfDRSIkC4bGHhKwIA4WOmhnlM3R/U7y6ir3/17J21L2FHhNne/DDYgotd41+a6aDDJo/bWtSEtT93uIHwzDBIijYMWDcbeXwL+I38981XYFyjvW0/lunFTwBbQ0Fpc4wFVO7bSaObCE6iJtY+UXjXTAMI+Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nxV+DVW+l5LEMtna4GMdCvJf7TpAohvJV15WiZDUeAs=;
 b=Wb61yQEIsnoPSh8tQ6auoUssW0n7842MnfQedUWlV1UhqFtwoTlPbteljqp1XyrH5CdV5RuVdSVhJLf1wnUtV0PGRiBTmz/SWbHqu5+ZG7bFulC1hjyfwh5v+G1hD/oTOw0n026XKZ5nE47/6Ys9CRv9/JZEYsMfTPfMl6UfnUQ=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0394.eurprd05.prod.outlook.com (10.186.159.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Sat, 25 Jan 2020 05:11:34 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Sat, 25 Jan 2020
 05:11:34 +0000
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0025.namprd16.prod.outlook.com (2603:10b6:a03:1a0::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Sat, 25 Jan 2020 05:11:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 07/14] net/mlx5e: Set FEC to auto when configured mode
 is not supported
Thread-Topic: [net-next V2 07/14] net/mlx5e: Set FEC to auto when configured
 mode is not supported
Thread-Index: AQHV0z3noywReZv+qU2NrR87dwN0Eg==
Date:   Sat, 25 Jan 2020 05:11:33 +0000
Message-ID: <20200125051039.59165-8-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 1cd2d617-809b-403e-9a13-08d7a155091e
x-ms-traffictypediagnostic: VI1SPR01MB0394:|VI1SPR01MB0394:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB0394F9A2EBD7387CF8550F5DBE090@VI1SPR01MB0394.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0293D40691
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(199004)(189003)(1076003)(71200400001)(8936002)(316002)(16526019)(6916009)(186003)(2616005)(956004)(478600001)(54906003)(5660300002)(6486002)(4326008)(107886003)(86362001)(52116002)(2906002)(36756003)(66946007)(66476007)(81166006)(66446008)(64756008)(8676002)(6666004)(26005)(81156014)(6506007)(66556008)(6512007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0394;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +7hoaVqeHK5nG0S4i47+EpT2fUjYm9/LMUCrhLBm4Gf4eVLx42yHVgS0cSbfA6fpI5FKME73/vBH8sX9R35P4zsylhsT0OUBTxc/9iNsU/enAeA8Dmc/WIbJnl4a+bOT7o+7aGV0O/hCZSFqtuy2hOWwCMVYQrn0rjseba0AxEWMOTNqBUrsgFOSkyeKUlLdHy8mB9IBcvksgQJ1lOu65duhwvZV1c6f4pb9yXvhMBxYcLi0hsJ0eULSK8LOBQL3/zs2kvX40G+wDPZ0keiScVQewlYqfxG2M1R5+k5Q72kq0wLkOiShiQt1d95PP5dOjhk/3ttQVP2glUd9vRU3o3h4Bf1eJWQR14ZjPf8Xg8VddynbV48b4t7eJvzqFJEoP00LJNDMLxCPyAivvexhVHaNIyC0J/oxymnQ1zWW7AGpJGxKUeiUj+LoTFrgmsBoT1woZ4GUwqK3kbsbIC0W6Qn+cDf8xT17WF8Yvgm2R9JkFQArNWBjY8IIaQGQwJv43XsM4gLnkuIhGNsQnrU8aIMfb823i8EWCoc4PXotUN8=
x-ms-exchange-antispam-messagedata: 7A09dlfJHjvEvu9t/yBObOB8gtRFzyrBnW0G7cNJ9KAMwHb+jFL4kLz+Lj18n9++QZFmlolheXRrI8fjSzatCOyi77jm9CzKBfd7pUotnNv+OX1B+Wrn8fmTEHOdkHGyq0IcfXdfGjOVwAUQIF+Ygg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cd2d617-809b-403e-9a13-08d7a155091e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2020 05:11:34.1319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CytbAxoCduxCKqjTrUDMjIFL8UFR0ADRYDgS/G7QkD9KdH3taVPC6nfcGeScJ0B+t5qId1dk4YJPR9zSA85LiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0394
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

When configuring FEC mode, driver tries to set it for all available
link types. If a link type doesn't support a FEC mode, set this link
type to auto (FW best effort). Prior to this patch, when a link type
didn't support a FEC mode is was set to no FEC.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/port.c | 22 +++++--------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/port.c
index fce6eccdcf8b..f0dc0ca3ddc4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -501,8 +501,6 @@ int mlx5e_get_fec_mode(struct mlx5_core_dev *dev, u32 *=
fec_mode_active,
=20
 int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u8 fec_policy)
 {
-	u8 fec_policy_nofec =3D BIT(MLX5E_FEC_NOFEC);
-	bool fec_mode_not_supp_in_speed =3D false;
 	u32 out[MLX5_ST_SZ_DW(pplm_reg)] =3D {};
 	u32 in[MLX5_ST_SZ_DW(pplm_reg)] =3D {};
 	int sz =3D MLX5_ST_SZ_BYTES(pplm_reg);
@@ -526,23 +524,15 @@ int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u8 =
fec_policy)
=20
 	for (i =3D 0; i < MLX5E_FEC_SUPPORTED_SPEEDS; i++) {
 		mlx5e_get_fec_cap_field(out, &fec_caps, fec_supported_speeds[i]);
-		/* policy supported for link speed, or policy is auto */
-		if (fec_caps & fec_policy || fec_policy =3D=3D fec_policy_auto) {
+		/* policy supported for link speed */
+		if (fec_caps & fec_policy)
 			mlx5e_fec_admin_field(out, &fec_policy, 1,
 					      fec_supported_speeds[i]);
-		} else {
-			/* turn off FEC if supported. Else, leave it the same */
-			if (fec_caps & fec_policy_nofec)
-				mlx5e_fec_admin_field(out, &fec_policy_nofec, 1,
-						      fec_supported_speeds[i]);
-			fec_mode_not_supp_in_speed =3D true;
-		}
+		else
+			/* set FEC to auto*/
+			mlx5e_fec_admin_field(out, &fec_policy_auto, 1,
+					      fec_supported_speeds[i]);
 	}
=20
-	if (fec_mode_not_supp_in_speed)
-		mlx5_core_dbg(dev,
-			      "FEC policy 0x%x is not supported for some speeds",
-			      fec_policy);
-
 	return mlx5_core_access_reg(dev, out, sz, out, sz, MLX5_REG_PPLM, 0, 1);
 }
--=20
2.24.1

