Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4648149085
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 22:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgAXVzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 16:55:25 -0500
Received: from mail-eopbgr40047.outbound.protection.outlook.com ([40.107.4.47]:56737
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726454AbgAXVzV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 16:55:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VO+rEOyT7rpuM4NLGK4c9vwYyl1fd5bD0Xpq3fOuTRv55rkhGm7Ro6hj8CosHqjcEFNUZV4bwW4ZsX1fc+M5PJiHxFK1cEafh56bMZSff9zmo6yDABSWhJcFwldlFadPdGM54NKKDQg5oV9HPu9/OIHTzhNVxC2aizaMNAlLiOz/eMjIpsVLzMrrYce4+Z9uJGo8Kadsem+kPQyMoR0ts1YAcXFBVMdxw4IJhE3g4ZrUi0Jvqqr5UNHJrlrD3377K1ADzy3iTe/+9nupG6fcFyxMgg5okCXwxLdjE1du4DCNwiNLZpsbh6jX02iM5KdXM89/CqZBZkkYl9psUbPAdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nxV+DVW+l5LEMtna4GMdCvJf7TpAohvJV15WiZDUeAs=;
 b=Q+mb5vifWVJq+TXtzGS5014OA46ds4dl2nV83AoETK5fjRWoYDQVmpCSqxc9FpVK6k8G8ryCJTxASGkJ79swcy0qeOpzVgpp0BGfSk7+9yejSd3U2gTp19bAx3pjk/UwiyLi1puTaVlny1PI3/VV+dDRNTB9mqL9lPHKKKuM/L7MRIMX46jYG3EhU+vcSPEIizr5sWjm8H5bfCfqUChcR1vTtrAmnfowo/wqCqYWp5G9J5Kav9UrPkbthhkZ8N0M/lAdmtkxH2sEcdtdlwOrA8jo0RZqVaYdrEkaoGcWDIK3M+MRu5P7edd04Yx+POEjS4VyNKbyJZbD4YlXSLUjxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nxV+DVW+l5LEMtna4GMdCvJf7TpAohvJV15WiZDUeAs=;
 b=C/3DEPt3ekh3MWk5rD3KHcLm4VpwnX7BGpU3hg2iTQGRJSFtOB2tW3sL7f/PsvZSLXojwFBoo02PAvjhwSFd0321YN23/ffwrxNkxlPgIf6QYbumZ9zY+ZcsO2lZGupkKMSGlOkJpk8WfXVuCnYopjlQhRXASRnL0UOqPVMEwlY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5456.eurprd05.prod.outlook.com (20.177.201.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Fri, 24 Jan 2020 21:55:09 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 21:55:09 +0000
Received: from smtp.office365.com (209.116.155.178) by BY5PR17CA0038.namprd17.prod.outlook.com (2603:10b6:a03:167::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend Transport; Fri, 24 Jan 2020 21:55:07 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/14] net/mlx5e: Set FEC to auto when configured mode is
 not supported
Thread-Topic: [net-next 07/14] net/mlx5e: Set FEC to auto when configured mode
 is not supported
Thread-Index: AQHV0wDxpKpJbEir+0K+84aGKPa6Tw==
Date:   Fri, 24 Jan 2020 21:55:08 +0000
Message-ID: <20200124215431.47151-8-saeedm@mellanox.com>
References: <20200124215431.47151-1-saeedm@mellanox.com>
In-Reply-To: <20200124215431.47151-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR17CA0038.namprd17.prod.outlook.com
 (2603:10b6:a03:167::15) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2c9a1ffa-dec0-4863-861c-08d7a1181428
x-ms-traffictypediagnostic: VI1PR05MB5456:|VI1PR05MB5456:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5456A53EF4283BDE34AFD809BE0E0@VI1PR05MB5456.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(199004)(189003)(956004)(4326008)(107886003)(5660300002)(316002)(54906003)(478600001)(8936002)(2616005)(6916009)(26005)(52116002)(6506007)(36756003)(8676002)(81166006)(81156014)(86362001)(16526019)(186003)(1076003)(66946007)(66476007)(66556008)(64756008)(66446008)(2906002)(6486002)(71200400001)(6512007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5456;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: csoB77I3BpImg2KzDOmTlx+DFB61QRwKnZqz2CS0MFsbz+WptsLh5HGXMnI34zdAGRTHa6Egwjbqqt7YyVuBlzvW+4IGRhphXn4fkRd+dJBbEO206AvnHDCDiaSFqKr+xNBtGWSx/TasPTJ8PLQMpbzey1zXluuFfG/aHe7hKI19LnTDtV3DqcI/l3QZFp6NVoc9Kg6bBIokODBWTes01C2WBJDN/ufyblWxgaj2lT8boyemct7xgic1QZ1E3Ovtsu2wLoFXZPR2QEqjQBRVy78YNGnLlacSqBtmAXwazEW/Q3Xax38QI+DSOduRgnYdS4WQGocDe4U2CX4WiAzYPraEkxPLNvWnSQs0OEDn34T9vHlX8URJp3Gip3cxTb3WtUvh4cI+ymnq24NSaNlxs3gvBWHk7GGjrzTIsWfTlI0XF9ko3FQsHtaEypijAtA8gBJDIxqbqHpKUIBoVpGi37ZKfH+M83U1Z7bRbE7bEU/iP6AYpwB2EpXQCM//u3UpUI8aiNxBMijltVm3qi72/dPDeuz7rU1Hb76JehkcghA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c9a1ffa-dec0-4863-861c-08d7a1181428
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 21:55:09.0209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xo2/ewz858AOwHUMOBrywTIN5cG5iJwPpkKX0EqTdflbxQRb54B0z4NAGHqsxjwnMfw8SHtgbfFcyZiOPx/REA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5456
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

