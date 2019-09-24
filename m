Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30391BC511
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 11:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504354AbfIXJmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 05:42:13 -0400
Received: from mail-eopbgr10079.outbound.protection.outlook.com ([40.107.1.79]:4229
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2504324AbfIXJmM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 05:42:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hL8WDMtmce4JlZAIbcti7yIzGJ2cv+lQtki8avKGsRA+7bNOjS+XMQ2RTkzPVIFwfegs25wUoHwkkq5R8GxiaKCH/5flJIWKLQT9lIKi9RlFjJn824hzwoqNZYquGax5McTjDAGeQjv3EOt8LjDNWgLHcRxw1Eg5nUNVXmd/WgyJTFJSVFK4YISbmYdKITzL4s+vKpp+TZ2QjHDmk9bgT4Ud66mAkqHrNPP7MnNUhdp1ldm+E+oQBpnGuQp85xQs640aJcmNxVNj0eV3JWdn/rNPLi5oHqpIdJF1XO01lKUP7WL2qAD2GoohRiyt7/3hveqbIZSgUlPHkC1Ndqmz5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsfXjptiJV3bBS+H1frUoMoTVExDV8Rw5SvmSKu6+4w=;
 b=TL4pC4oEwGGpZHEhMzVa4PjLQwIw/gREpjzcZbz7O6asyHd+C8eTVtx5xmQsszyU943x29fZeD75Em9jSsM5dlZP+8Ju1kcZq9KgcIkNX0od9g3V/1YRsOh9AHMdWhYdQ8yAKGuAUHhRuilF2MJ/7fELGNS3Q6ke72n5xtiY4f9nTQyQRGGm27a45aMd5F5cWaxG+lgtwVZi1kD4Uoajfm75Ily9PPDPwYdElmfqBckoymSXXmgRXvnhiDfQw5Zc49Op5GYKS6xM79PgeCVLdaQ4/hu9TCB9kt3ppUpI5VREUkFQ6l1zr7qihMbP6JOL1eB1hDAqPOpx+SWMdRBVog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsfXjptiJV3bBS+H1frUoMoTVExDV8Rw5SvmSKu6+4w=;
 b=i24h7nRfAjLwzYo7D88FoevUgzvSf66l06XOXS2cIh1lV4o6KFjuqe02QsVO8zJ/1yUkm4nLO1O3XkpHiwi1rgQL2fKjcsqp9FPIn8S4Ma6s0QrgJMqZ/Y6lDvzWwyXsvG0EquhlLgi/RlcdRL935tQuqi371wydPPDLuHrnvdw=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2671.eurprd05.prod.outlook.com (10.172.14.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.21; Tue, 24 Sep 2019 09:41:41 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2284.023; Tue, 24 Sep 2019
 09:41:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>
Subject: [net 6/7] net/mlx5e: Fix traffic duplication in ethtool steering
Thread-Topic: [net 6/7] net/mlx5e: Fix traffic duplication in ethtool steering
Thread-Index: AQHVcrxEM7fI5uRmuUCq45vevzdPoQ==
Date:   Tue, 24 Sep 2019 09:41:41 +0000
Message-ID: <20190924094047.15915-7-saeedm@mellanox.com>
References: <20190924094047.15915-1-saeedm@mellanox.com>
In-Reply-To: <20190924094047.15915-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [193.47.165.251]
x-clientproxiedby: BYAPR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::44) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f75d5ce-c59f-4a12-2bbc-08d740d36741
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0501MB2671;
x-ms-traffictypediagnostic: VI1PR0501MB2671:|VI1PR0501MB2671:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB2671DF378FBD5488D9E7FDDBBE840@VI1PR0501MB2671.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(189003)(199004)(386003)(256004)(6512007)(186003)(6116002)(3846002)(50226002)(99286004)(36756003)(25786009)(107886003)(486006)(6436002)(102836004)(52116002)(26005)(76176011)(8676002)(4326008)(316002)(81156014)(81166006)(2616005)(54906003)(476003)(11346002)(6916009)(6506007)(86362001)(1076003)(5660300002)(66476007)(2906002)(66556008)(6486002)(66446008)(64756008)(66946007)(14454004)(478600001)(305945005)(7736002)(66066001)(71190400001)(446003)(71200400001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2671;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6qqynFiT1jASbdxoZWCHJSf54kOZy6DbROcZbfe/7Mo65gHKcV9+GcLSbOu+16lwvqvt+OVSOwS8txV6wRFx8q3lGRL2deJczHtb1GswNWX4xfmPewOrhBGNAaTITJg9kw5NRRAi6+bpMad5Q/5dXdjSE97FRRfvzf2M7IymqtPSTNpU5/cR2uZsZUfnA0AewGeQ81DReoo6Wwk3UW16J5vfgIoVoUTb67Qi7OVri4z2MNqe7lsrtjSHEhObryP1qWahrIklFAZy+8rLmS28tubfKaXxE7A+khRqb8lZmiw636dkusKKkBtSzBhbMCCM/WbKrJnUxxzFCq31sTgGTxmguP6qAwjZhizREv1onekKwAHoApbjoYHAEWax4EP6V2fmuy66wGsGob04h9VZR41gbVeX3lJqGP+UZTRU3GE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f75d5ce-c59f-4a12-2bbc-08d740d36741
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 09:41:41.5403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: STnMkhB70eT8TS+22Jpe0XVGIx7hZ4+dKOPrzR5WebHaMGkSbxSwiw8FkwBufkYBOfcus7tPmIcxyhMe65HV4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2671
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before this patch, when adding multiple ethtool steering rules with
identical classification, the driver used to append the new destination
to the already existing hw rule, which caused the hw to forward the
traffic to all destinations (rx queues).

Here we avoid this by setting the "no append" mlx5 fs core flag when
adding a new ethtool rule.

Fixes: 6dc6071cfcde ("net/mlx5e: Add ethtool flow steering support")
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c b/driv=
ers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
index eed7101e8bb7..acd946f2ddbe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
@@ -399,10 +399,10 @@ add_ethtool_flow_rule(struct mlx5e_priv *priv,
 		      struct mlx5_flow_table *ft,
 		      struct ethtool_rx_flow_spec *fs)
 {
+	struct mlx5_flow_act flow_act =3D { .flags =3D FLOW_ACT_NO_APPEND };
 	struct mlx5_flow_destination *dst =3D NULL;
-	struct mlx5_flow_act flow_act =3D {0};
-	struct mlx5_flow_spec *spec;
 	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_spec *spec;
 	int err =3D 0;
=20
 	spec =3D kvzalloc(sizeof(*spec), GFP_KERNEL);
--=20
2.21.0

