Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE9279D0F
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 01:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729919AbfG2Xui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 19:50:38 -0400
Received: from mail-eopbgr130088.outbound.protection.outlook.com ([40.107.13.88]:24063
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729797AbfG2Xuf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 19:50:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OdXBzwbtOs78jOHHoPvrKhN4BZLoBlkiSdfshYbP9H7hE/Zjv+lAcdEZq86+a8ovTO1rk5Qe01DyLkac5cmGFp4BFgj9J5Cs/FKpRNL0vMLXTL8c1wiFxsN6OfcgFOssKHwUlr4sQUWtd2K2cKiNIPl943HetOygdE3cGISR42KGXgDpspH/7nSX585kL8NtB/TyfvOXuafYICU6Mh2vtctNCdUxqJeA7w3mCNeM/bGZABLyZRGZrOf0yIQP9SHvZdwJkqzr+SdwemEcB6hqkqQN13Km/3f/viG4MKJnzNzrH4em92EY7GWzzcCOpLOGXP9L2OIiqhzp9GsFkt22Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UmC7qnpzeufcyD41Pui3lRrUXnhz3P6cWa478MVj7xU=;
 b=jQwVdStw5nbM5k1QEMxXDD9yUVL7ERo/TjZGieWxPf/n3Ri/pg8PjU9rX9G0IXaa1zGgzSGDN8/F/lu+6UAwDXtqxANa7MsaJbgXazZ9FZ0729tRJ+vGHmI4dwbysDf/bfefHa1MNeWYMCPStUEPrYiixQ7flXqHcKT2i7iP26DC9RLndfvF77lAuQLk+V1G44z4UR78ml7RF0+335892+nDl7c81rlApVtVOtBiO/JhuQti9UUUe7gVcHStgFsugKuVZw+uZXHgPb+ES7dgcaQKX17lTzFJ4mRq9s+ks0KllqfqxiBY97HxLOk16ekVm5cqCnLj1EDEKlyJ5aMv3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UmC7qnpzeufcyD41Pui3lRrUXnhz3P6cWa478MVj7xU=;
 b=VtBFg46vmIbUFmptAVR6uRBjrPAUSpd9vo+Ec6JIMeXiOIVqJS55UHmC8+JFJw73WZjXw6SQogusdX3d3PL6jbG8VCgzm0ejvxCvbDPBsrfdb/4Wg5rHAfaa6szPl51mzDsjz3i039xZIdv0jy2GB/987DfoQSVG8tP58KvYy0I=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2343.eurprd05.prod.outlook.com (10.168.56.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 23:50:21 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 23:50:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        wenxu <wenxu@ucloud.cn>, Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/13] net/mlx5e: Fix unnecessary flow_block_cb_is_busy
 call
Thread-Topic: [net-next 04/13] net/mlx5e: Fix unnecessary
 flow_block_cb_is_busy call
Thread-Index: AQHVRmhiaIG/T9jnaUqG1ImdrOVpIQ==
Date:   Mon, 29 Jul 2019 23:50:21 +0000
Message-ID: <20190729234934.23595-5-saeedm@mellanox.com>
References: <20190729234934.23595-1-saeedm@mellanox.com>
In-Reply-To: <20190729234934.23595-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::28) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a576c75-71fe-4abc-ac0e-08d7147f844b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2343;
x-ms-traffictypediagnostic: DB6PR0501MB2343:
x-microsoft-antispam-prvs: <DB6PR0501MB234328CE86CBBA58246E7FA2BEDD0@DB6PR0501MB2343.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:576;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(199004)(189003)(14454004)(25786009)(71190400001)(71200400001)(386003)(6506007)(6512007)(81166006)(81156014)(76176011)(8936002)(6436002)(8676002)(6486002)(316002)(102836004)(54906003)(6916009)(7736002)(478600001)(52116002)(186003)(26005)(99286004)(256004)(476003)(5660300002)(1076003)(66446008)(66066001)(66556008)(66476007)(64756008)(36756003)(53936002)(486006)(86362001)(305945005)(107886003)(66946007)(68736007)(446003)(2616005)(11346002)(50226002)(6116002)(3846002)(4744005)(4326008)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2343;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7C8AY1aEVUT/J/BjgyNObuWU/Sg92OEvv0ry20UcLgGcflXIDob9B4tw5AOdCIirGWBHyLdDyoyl6CsO2BwQZ68Sw4nRjfojtHDz1WmeFvkTflT/UNVYenoeWM7Qwjcn09MxMBA2g+Hr4jNeGuPrnOJvdEau3+9Fw1ITtC+1X+g4SGIpgI69T0dzxPliaXNbn8EWIASQyNlOza8LY1DvhNWzUk8YjJQ2/LYCUqb/3nKH9+L5McDkEHeYXp6xMI5yaQSQa+0unBcf8U1JRwCTBw7wu9p1EoXUEygf90YLLnR0TEeBzwcX1pgFgNi1SIdVIz6LD1R8xAUgb0OEYf5B0ZU/0f8neRtC1QzdL+v1+nvLlqELbUi5FB8Hi5tEpBL8r8uZJRpn/TTxuWYytlZSsCR0kKFJ8Yu6Ynnpd0qPBc0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a576c75-71fe-4abc-ac0e-08d7147f844b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 23:50:21.3216
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2343
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

When call flow_block_cb_is_busy. The indr_priv is guaranteed to
NULL ptr. So there is no need to call flow_bock_cb_is_busy.

Fixes: 0d4fd02e7199 ("net: flow_offload: add flow_block_cb_is_busy() and us=
e it")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index 7f747cb1a4f4..496d3034e278 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -722,10 +722,6 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netde=
v,
 		if (indr_priv)
 			return -EEXIST;
=20
-		if (flow_block_cb_is_busy(mlx5e_rep_indr_setup_block_cb,
-					  indr_priv, &mlx5e_block_cb_list))
-			return -EBUSY;
-
 		indr_priv =3D kmalloc(sizeof(*indr_priv), GFP_KERNEL);
 		if (!indr_priv)
 			return -ENOMEM;
--=20
2.21.0

