Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1CDEF215F
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 23:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732692AbfKFWFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 17:05:47 -0500
Received: from mail-eopbgr20050.outbound.protection.outlook.com ([40.107.2.50]:38020
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732615AbfKFWFq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 17:05:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NMa19AY6kxFxE05n6Y0IZI19B4NXHX2RZ/XJqvEYXTzI9xagFFrO4b2D98+2koYrn0qjX8SRE6Oxy8M77W3ozGxOKWyq9S0y4EHPZ27lF3hh9bLvINIGyeMkA/Mh+uxeqLmyQZhXj7S5od1MuQclbjTanhnLrHpKwaF8zaV1+2DFUcMFwLOKJnBsEQY96I5XsLNLPVx2QFUZ6GOLagKnFqFh3EJ5v0PEuU2hHRTkNNQExUQVZfkSgPLjK6NMq+eVjtgqP+z1kkcfQuYysJ1xjkUCjVH4ego32i0kRuIb9FNJlvim3+jk6JXFBxVo3I3pVUI9MLSUoKkD5iXIzwM+ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cwv9SNIeWBZ+VIUhqTiCZWtvWNWStSXhKvo+GIFA9cs=;
 b=nyLoGI/H/5J+JTW3kyOzgH5RCY88DYCkT/NWFKZXN9XXrlNxXTvBNeHt89FwF0SOIEPrbYYbNmwp4Ja9TZ6e7MP3X1DTu7LB0WeRl+avVxVJAMoKLX5Ey6pqH/VMGGvdXzC53tUo7UeHpaszI+IEHj+W/sVyz6Aen682Npna5cOLbDF51vhWcw+iMmZFo3AZPyfrukaVcfqgeNKZXgQSGh+q2xj4Mtp1wKctWNQ3vHBo1/P+iNnbRlwKk+t0/x5wEAfPbzdGOHlrN30LJxNjPrSck8zqRk7RB6GL9l5i4A/3TVzart4cXNlka1oyapmYGo8/FlgTpFGuX0nF6ZdYZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cwv9SNIeWBZ+VIUhqTiCZWtvWNWStSXhKvo+GIFA9cs=;
 b=gRyeBsWyRX7rcGCEp8IoDbMKe5w2WI530oJRi+0kpMdBRXvi/DcInsIx9A6a1hR+Xjjib2dPfOU2MRIGbS+7qz9zKEhF9w7jkW7GL8Mntd1xKQLsxC+gpN75KdBPUmi/DIe5AbpWW5u2jLUWy574s1iTwQiajDrvgcLf70YuXfk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5549.eurprd05.prod.outlook.com (20.177.203.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Wed, 6 Nov 2019 22:05:41 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Wed, 6 Nov 2019
 22:05:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 2/4] net/mlx5: DR, Fix memory leak in modify action destroy
Thread-Topic: [net 2/4] net/mlx5: DR, Fix memory leak in modify action destroy
Thread-Index: AQHVlO5Uui3/SX5JMk6vI5sQuMnXsw==
Date:   Wed, 6 Nov 2019 22:05:41 +0000
Message-ID: <20191106220523.18855-3-saeedm@mellanox.com>
References: <20191106220523.18855-1-saeedm@mellanox.com>
In-Reply-To: <20191106220523.18855-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0041.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3d8057ec-d934-4b99-17d2-08d7630576c7
x-ms-traffictypediagnostic: VI1PR05MB5549:|VI1PR05MB5549:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB55499A4C9E4B29ED078C1CC7BE790@VI1PR05MB5549.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:36;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(366004)(376002)(346002)(199004)(189003)(66066001)(71200400001)(6512007)(6486002)(316002)(476003)(25786009)(305945005)(36756003)(86362001)(66476007)(66556008)(52116002)(64756008)(256004)(66946007)(2616005)(11346002)(4326008)(446003)(386003)(26005)(186003)(7736002)(50226002)(107886003)(478600001)(6506007)(102836004)(8936002)(1076003)(66446008)(14454004)(99286004)(81166006)(5660300002)(6916009)(486006)(8676002)(81156014)(54906003)(6436002)(4744005)(6116002)(3846002)(2906002)(76176011)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5549;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jla4xumH1vxzbsXLCvk3WS2rxkI8iHgzcXAote+SkL4Do7dJrVc5cVH4SHORU7LC1InrJ/R3FTufFUg5lULRr14tJfrD53hcISO3eL+IwU3sIx9juq0KaWepm7Y/k1Q9cVOzxonlaN31fxm3xu39pUoYWsE6MTWmavssl/jKWWanfH9s6nT5bIgJA/K3vrcT1lmSB26tgk6kvhuCpYiRjQ0G9Ybw1bB7pleBdTahxP8HPhCzyTXm943jF2uelZmHSs9PfFVEKiMHPLDqrvqAdwx9n/1ZziRFtQGokDNYLeHie0pRhsk5aZCqpHQm+z+3Bt8o/LVumCnQo1RnFa9MucGm5Nab9WON7X6vfHkNQxa0U+Yl+d+EXGTb2JsdRmVrjY7CYB+zutxAar5cdwiwcBPsROm9WgjVfl5AOaIZZ5A2S/sLZMpU+xZ2EPXf0j5K
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d8057ec-d934-4b99-17d2-08d7630576c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 22:05:41.8417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RXXlL7eDaB1ZorXJJ3vQhWg914AfC0f8GCvtkEhOYME2EQmJpcutAdNES8uNY5nLLIckGVSdmsELfxazvg5RKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5549
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

The rewrite data was no freed.

Fixes: 9db810ed2d37 ("net/mlx5: DR, Expose steering action functionality")
Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b=
/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index b74b7d0f6590..004c56c2fc0c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -1577,6 +1577,7 @@ int mlx5dr_action_destroy(struct mlx5dr_action *actio=
n)
 		break;
 	case DR_ACTION_TYP_MODIFY_HDR:
 		mlx5dr_icm_free_chunk(action->rewrite.chunk);
+		kfree(action->rewrite.data);
 		refcount_dec(&action->rewrite.dmn->refcount);
 		break;
 	default:
--=20
2.21.0

