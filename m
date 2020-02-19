Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9690163B17
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgBSDXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:23:30 -0500
Received: from mail-db8eur05on2089.outbound.protection.outlook.com ([40.107.20.89]:22272
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726346AbgBSDX0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:23:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fKLkk0e2u789Va9I5RQ8wCcX0LGrae0DYS65kgZaGW2osMEGaBWb5X8IezKXLWaZve4SxMQs5iY86F/HGZDDGhYK+qZdvdctBLcG3OLRWtpMR2pFSq2Ebt0LmdssO1lUtIA31OJZ6hA7Lkrr32MRSC7h3QyyKaNrRROVN0HQnYqj30pXGZQFVq7/JDERMqLQ3iN8K4K0JKb7FdyDTi6s5pKgsltgdePt5VUwX5JRyVwA2KDm4A3Ep9xsGJ4FwSAp49ico3j/xcB2Gxgz3mugF3yMojpgjiYHQzWAIufykAr5LjKPCndh++6JeVUXW32EI5Ek6HAAZcX4xUQwa3QmUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o3x2pFfyESIyobL1mJ9/Mp6CQ82E4j5XbiQdvAjGnA0=;
 b=oZYdjwNfzSOpwMetWIiJ5fOvQNYBu3AJhSpXZTMjK7G3yaTwOFRlA/8DLLcCNKDuPUcNWsYfCdRCo62s2kXpwpVLxDqB9XYFaO4uuNyfnsOIi6CFC9eTpBggWk5CFfZ2vn92Ah4EZmMVKh+99pbtSpvKLAN44h/5dp6uil1nOlOh4yOxyYKs87RHAmG3G+mOTxfmM3cdlBCoXeDwlX9LFOKvLgw4M/hGek/kyCuREHdyeP2C5Wt4IBzgozm2+jQGfS8ti2sBgVrxO8z6xx9IiD0N6tK+L1oXufi2Itho+kNVhHSLYj2LziTTilI249t3pvVFJqZD0zxPFuIx7k/60Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o3x2pFfyESIyobL1mJ9/Mp6CQ82E4j5XbiQdvAjGnA0=;
 b=mXeTrpM413O8voZc4kgX7cBB1LsMUcwtR6N5nbBztUjRK/AkNU91hA7dmbeEtq2nqLBbd8RsdzDnVZWxp2KtCSr5EjmhTEIt8bwRUKpomfy/CF0ZBBjaQ0hORtwxZl4kfe2hxpXl6Ig8noNiNTeKY63CSud6sQFSmO5OXEP+xno=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4590.eurprd05.prod.outlook.com (20.176.5.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.27; Wed, 19 Feb 2020 03:23:16 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Wed, 19 Feb 2020
 03:23:16 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0001.namprd02.prod.outlook.com (2603:10b6:a02:ee::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Wed, 19 Feb 2020 03:23:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V4 08/13] net/mlx5e: Enforce setting of a single FEC mode
Thread-Topic: [net-next V4 08/13] net/mlx5e: Enforce setting of a single FEC
 mode
Thread-Index: AQHV5tPt/zc1HV1EcE6YBPEmoRDzWQ==
Date:   Wed, 19 Feb 2020 03:23:16 +0000
Message-ID: <20200219032205.15264-9-saeedm@mellanox.com>
References: <20200219032205.15264-1-saeedm@mellanox.com>
In-Reply-To: <20200219032205.15264-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR02CA0001.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 69b7b273-536e-4f3b-d577-08d7b4eb0f56
x-ms-traffictypediagnostic: VI1PR05MB4590:|VI1PR05MB4590:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4590941CC24FF4099F2AE91FBE100@VI1PR05MB4590.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(189003)(199004)(2616005)(956004)(16526019)(186003)(478600001)(66446008)(66556008)(71200400001)(26005)(86362001)(66946007)(66476007)(6512007)(36756003)(6486002)(64756008)(107886003)(4326008)(110136005)(8676002)(2906002)(5660300002)(316002)(54906003)(8936002)(52116002)(4744005)(81156014)(81166006)(6506007)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4590;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 14qwKj1Zq84s8JI2+MYzAEsRB3WTkcF/bWxd/+QWpy+8PaMDn9A3Itk5GASZFOPZJfvFwGChFdjhbCbdxEY4cy/ei4QGDYpZVctS30zjSneVWu8JYXEnmBjjtjjrdZQJYOA8NpUjOJdOrbI9U8pMacqfGvupPJF/H2bNDh7SDSNV15RksPC1DDzGT6Ix3yMmppH+NTKhFLCoavmHR3KH7FeN1xiCgX8sXY0t8zJSdlrISaZbU9eg/tiyB6zRk+P2Yeci4OODp2AUKXa0nkLL0egNsPp9tbBFwB4EZXI9r0FhQThroIK/D1ajj5S6YuB85fXNX9kaxfA2CdX+qIsd5mhTbAeuNIGKhIrX628+hd11K+U3e0QUS+fFjTQbI2wO9xFfIpB5LIt1Dx/S4tOiO1NZn4F44qc07cxlKccBAoWnBCdCqC2Q0Cu3oFZUQAnG+/o6MhUmvQdCjXASsbqNAxRnLyHpKEmGi+bHPKRfpWovKOV9ivhsvRpnkNu0OCo/3Qwp1fGZFidDEPTIonqWOzlWSq5MXmklINt5xJ6fIfE=
x-ms-exchange-antispam-messagedata: Y674JqmVpGLHLRvUs4GVVt+nSzCe2uiStXi9+kq+jnbRJ3M473w00wNzH+/kZ66Sbf8TdWYgNjxMtpZQLBfjMh4yu5I2BEMUBmueDl+GuoxZCPsmJ+V/BenBh6l6iolLIhdYHvTw34bYGvHZx5o48g==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69b7b273-536e-4f3b-d577-08d7b4eb0f56
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 03:23:16.7045
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nbC78KONChhU7AdEcUz+qG1lDjcwpin5p37k45r5ZgKQXXWuKfy9BkXVIVl/ON2hQkSabiRgVOCkJJ3krnTD2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4590
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Ethtool command allow setting of several FEC modes in a single set
command. The driver can only set a single FEC mode at a time. With this
patch driver will reply not-supported on setting several FEC modes.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index d674cb679895..d1664ff1772b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1541,6 +1541,10 @@ static int mlx5e_set_fecparam(struct net_device *net=
dev,
 	int mode;
 	int err;
=20
+	if (bitmap_weight((unsigned long *)&fecparam->fec,
+			  ETHTOOL_FEC_BASER_BIT + 1) > 1)
+		return -EOPNOTSUPP;
+
 	for (mode =3D 0; mode < ARRAY_SIZE(pplm_fec_2_ethtool); mode++) {
 		if (!(pplm_fec_2_ethtool[mode] & fecparam->fec))
 			continue;
--=20
2.24.1

