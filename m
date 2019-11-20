Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08B0D10453D
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbfKTUgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:36:47 -0500
Received: from mail-eopbgr20043.outbound.protection.outlook.com ([40.107.2.43]:18430
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726846AbfKTUgp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 15:36:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Apf2St834WbT0MFzEFTgQjrUE9DWPRdTMWibzWMaLyigJ0xVqbcijPy99fk+9qZ4RwnIPoqnJY7dhH/61b9x5/FTKrUS+INnlbFTotSY4MODGgVWVV+ciWQ4P3PjlOqAup+JeYNMzoknV5cPdtDdl6upsXXiZOdwUR+jcXl2ZeEFcKDRHpqu5P30Ds/EpNOChD7Ixx/BO4M0HwlHDBJOL1EzxBxYjy3d33wNrqmzTTz46lWX/iMAmyYMYnTuYYTElTQz7iF/GVCvsYkcCjEehFdKMp20aHNXupdZEy+Pb9uI3W5+j7YYy0YIJFc8A56wBdxIO05zC9soSSJZ8Xf/hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+W2y7pAS7hk6379U7cm4IhXch29DcLaBMLFo2SivsBI=;
 b=VLy/6ySclK/FVx+EzkBQZpcB9uJvjuXfEE058zHAQAopz8LE2MdecTUjFQkUe0vdNfKXTYGa+hdgGLOnFIFf+rBHGRJjbydaXbX4oxal/ucXo/5zP7Zwo++nckqlkChLUru6+JXBGqp18pl8mTGS6VBanj0gLBW2PC3enV4VNQ/rWeSr9rHV0YJ7irgYvZTSqxpR8mdwJmHgqffzYxw8NG7ZCElkt1tjHR3UBAz+7GPGSokWjoNwVaiSu+bExAcqn10PlAe0qz3XXR8t32FGd2C6DCaAPtIMuYDmtg3QVwKtYpJUjN+DlcIDcX8hQseYlZvt4EO7OHmJnCP/rrQ7KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+W2y7pAS7hk6379U7cm4IhXch29DcLaBMLFo2SivsBI=;
 b=PfhHx454oQoRlzLB63FrMjGlGE7DYTG6vwg5elU3W6bN+znDwYHH1N/5aICvCeZCR4KTG3Ts5yitdBUMY31bTAblbGFrAsuWNwqKyaJyYxtAOYdqFPLAOgTB+plTiMIiB4eqwARLkFNl6S0LLgRiewyVX0CaxoTvG6vySAoZIxY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6110.eurprd05.prod.outlook.com (20.178.204.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 20 Nov 2019 20:36:00 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 20:36:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 10/12] net/mlx5: Fix auto group size calculation
Thread-Topic: [net 10/12] net/mlx5: Fix auto group size calculation
Thread-Index: AQHVn+IeD8h1nAkYtkm4wG0tn4cDXg==
Date:   Wed, 20 Nov 2019 20:36:00 +0000
Message-ID: <20191120203519.24094-11-saeedm@mellanox.com>
References: <20191120203519.24094-1-saeedm@mellanox.com>
In-Reply-To: <20191120203519.24094-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0044.namprd02.prod.outlook.com
 (2603:10b6:a03:54::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 93f83f60-58d8-4386-8e3b-08d76df94119
x-ms-traffictypediagnostic: VI1PR05MB6110:|VI1PR05MB6110:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6110E285E567BC7DFD2CA806BE4F0@VI1PR05MB6110.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(189003)(199004)(66946007)(6512007)(446003)(11346002)(66476007)(64756008)(2616005)(476003)(52116002)(76176011)(107886003)(5660300002)(8936002)(66446008)(66556008)(186003)(26005)(478600001)(25786009)(14454004)(6506007)(6436002)(386003)(8676002)(50226002)(81156014)(102836004)(99286004)(2906002)(81166006)(6486002)(71200400001)(256004)(7736002)(305945005)(36756003)(4326008)(486006)(6916009)(54906003)(316002)(71190400001)(1076003)(66066001)(3846002)(6116002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6110;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gmHWb52fbu0cEYxr5ph5X5wb0tyB2+4Xr6hvSRD9uN1b0e5gVVqOlBJmgnpqebde0TNTnrSSgIp1shxgVOhb0wXBxVU/+eFhwn81qBP9rpyxxkAX/0m+MyMHcBqxMYdQs4EqCcwQaL6US42kkk6ea34iHIlNCsMBQ2zBlKnuIUULjgmC83mgH9/d/oYcNxaYufIXvILKfXo2hXk5YuTQjpAFzjiCv2bdkSID5MF0RhqUITZ9acF5hb3HKQ+/v4yt4GBjZeOWwewNcXS8OacLmGnK1aHUCD/02yMbWx5sl2jVprV4f3WpQED3O5xj/Gvsv2Ih6VgAOTl6S5ra4tP2ZmMdzsO6fnKDcIBNOKCmcYmNXFlIT9dRCOrXmRv8crDRslrQJ7nY8pGOpO+pzkp0eRCtUnpKC9hjJx1EcATrpdh4sE1wBSqbL2TwNlue1Z99
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93f83f60-58d8-4386-8e3b-08d76df94119
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 20:36:00.4681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RSM+7oX3L66Sfa0couOfctwXTic/HKmzIkqT2zj8ldEkCiR6ulOItl3d9lhBqKrPj8nzcxoLMGdOdolNHPiJ1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

Once all the large flow groups (defined by the user when the flow table
is created - max_num_groups) were created, then all the following new
flow groups will have only one flow table entry, even though the flow table
has place to larger groups.
Fix the condition to prefer large flow group.

Fixes: f0d22d187473 ("net/mlx5_core: Introduce flow steering autogrouped fl=
ow table")
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 10 ++++++----
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h |  1 +
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.c
index 3bbb49354829..791e14ac26f4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -579,7 +579,7 @@ static void del_sw_flow_group(struct fs_node *node)
=20
 	rhashtable_destroy(&fg->ftes_hash);
 	ida_destroy(&fg->fte_allocator);
-	if (ft->autogroup.active)
+	if (ft->autogroup.active && fg->max_ftes =3D=3D ft->autogroup.group_size)
 		ft->autogroup.num_groups--;
 	err =3D rhltable_remove(&ft->fgs_hash,
 			      &fg->hash,
@@ -1126,6 +1126,8 @@ mlx5_create_auto_grouped_flow_table(struct mlx5_flow_=
namespace *ns,
=20
 	ft->autogroup.active =3D true;
 	ft->autogroup.required_groups =3D max_num_groups;
+	/* We save place for flow groups in addition to max types */
+	ft->autogroup.group_size =3D ft->max_fte / (max_num_groups + 1);
=20
 	return ft;
 }
@@ -1328,8 +1330,7 @@ static struct mlx5_flow_group *alloc_auto_flow_group(=
struct mlx5_flow_table  *ft
 		return ERR_PTR(-ENOENT);
=20
 	if (ft->autogroup.num_groups < ft->autogroup.required_groups)
-		/* We save place for flow groups in addition to max types */
-		group_size =3D ft->max_fte / (ft->autogroup.required_groups + 1);
+		group_size =3D ft->autogroup.group_size;
=20
 	/*  ft->max_fte =3D=3D ft->autogroup.max_types */
 	if (group_size =3D=3D 0)
@@ -1356,7 +1357,8 @@ static struct mlx5_flow_group *alloc_auto_flow_group(=
struct mlx5_flow_table  *ft
 	if (IS_ERR(fg))
 		goto out;
=20
-	ft->autogroup.num_groups++;
+	if (group_size =3D=3D ft->autogroup.group_size)
+		ft->autogroup.num_groups++;
=20
 out:
 	return fg;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.h
index 00717eba2256..c2621b911563 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -162,6 +162,7 @@ struct mlx5_flow_table {
 	struct {
 		bool			active;
 		unsigned int		required_groups;
+		unsigned int		group_size;
 		unsigned int		num_groups;
 	} autogroup;
 	/* Protect fwd_rules */
--=20
2.21.0

