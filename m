Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0E24ECA99
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 22:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbfKAV7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 17:59:14 -0400
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:44510
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727316AbfKAV7O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 17:59:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wohec59Go1OKSZn6WwOE2ZRKLpuVAG31EAJg9GGEvUaJJRadwwUui5o6LAV+vYxXSXGopkG2SahcYQao8IDISplYsacQvwnttAHKVo5Q4QN0bJktN1eIk8kuNs0783W6BzlPG3LgSYEC3pe6udTkkeDims5w8yscWMtBH5RlEL60vTalUWWnDOnzICNQl++AXDpV4GnhUtRjxhLPLBNQekl5Sj/VGK2VngXwT9MU8iUoxIb3ELnkddOka3l+k3GIjK/ryYJhHEiHOt6wSgzv/3TqhGk/IcCShsNDmaPv6qTy3tG1AZlBA/dtxTqsfkMenIIKL2210Af0C+gZEbL3tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D3yo5oRiJtKj9HEgyVzXD77h5SRnplQUMIt5wKbN+Mo=;
 b=m4w8rJZaxgyCniCOnLQM0rLTFoOKE+5D7q09Y85q0CVsC5J6qz3zmYOcdTraWX5aeCwSOUIL/fHbUkGlbD+Js1tSqe2lDsQLsM/QrTRo+VqJ9UR+q2xjeDMVRrmrgeii4fcIZddaKnRwrwOemrGkzeNe4MvhImCe+jA9pyOoY0bNSs0xJpg6SyR/FPxdtUjeRSOmeTHu/373cXWaZ5mWdZHGu+qTOAH5/7PkkKbA3SY7q9C9I4KC2kQJXiBt5uZJdHauhh2l3m9vmj7wNxZ/SnbXGa/wWQ08GjlLyjl0pfUgfe8nXEXZLSwrGW8gABOTiOipE98oxYaFaCDbX5szHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D3yo5oRiJtKj9HEgyVzXD77h5SRnplQUMIt5wKbN+Mo=;
 b=FxsQI0ay7QAr6e/jE5HViz/iiy0ggb136Hb63CvBYD3+Db4t2asqYaQkWhv4fVhybeJQM57Uj1Yh6oF0+hRJUl8GHskXIui7poocFWLJxrDy7/3/HFIruia+eL+tOSOL0+UUWzbtU2Z+sA6eUylvUmmGnz9J0+1rIVHz1IsHXCg=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6173.eurprd05.prod.outlook.com (20.178.123.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 21:59:07 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 21:59:07 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Daniel Jurgens <danielj@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/15] net/mlx5: Do not hold group lock while allocating
 FTE in software
Thread-Topic: [net-next 06/15] net/mlx5: Do not hold group lock while
 allocating FTE in software
Thread-Index: AQHVkP+VKWcQdZnnp0e4j66TFVXb5A==
Date:   Fri, 1 Nov 2019 21:59:07 +0000
Message-ID: <20191101215833.23975-7-saeedm@mellanox.com>
References: <20191101215833.23975-1-saeedm@mellanox.com>
In-Reply-To: <20191101215833.23975-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0076.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 563485eb-f7ff-47aa-8cae-08d75f16b7f8
x-ms-traffictypediagnostic: VI1PR05MB6173:|VI1PR05MB6173:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB61738D452D4958D12CD02830BE620@VI1PR05MB6173.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1079;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(189003)(199004)(476003)(5660300002)(486006)(14454004)(107886003)(76176011)(7736002)(478600001)(66066001)(52116002)(2906002)(71190400001)(8676002)(71200400001)(6486002)(102836004)(81166006)(36756003)(81156014)(50226002)(6436002)(386003)(8936002)(6506007)(25786009)(66446008)(66476007)(6512007)(6116002)(3846002)(6916009)(26005)(99286004)(11346002)(66946007)(64756008)(86362001)(305945005)(54906003)(4326008)(316002)(1076003)(14444005)(186003)(446003)(2616005)(256004)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6173;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jc6TPfjDBCu+gE36d3Unr/bzfBPYEKPlsmHseAGZpvrbp8U5F4/EFnizf5O7hGO173ZsnLY5ywNoB1oGl5Sq0ZN5puk5uHGF0p14AlLUaTl0QNNzCkCSdDHo6GE5hGUesjARChpQQgRj9Uzc5BUmHnAr2HF5R8qBOYw2xmJhsHm4EmBviddAbJjKKyqEapCiY/akKg5o5EeZzVJ3/jGoXZZv8Jo7qfMXKXBwgOKY8bBYxq6Je3wH35FTE9I3wx1+DmRDweF+2xM3PsnDJG/gIlVpszT5zfnH1zUGRIrARkmr7D4HlckhfEAen0WLX2KJfShYV9DJL2XmJyuxDurqUhQ3pe3rzjaQD/yEZqkb0JG0ipvDiNoi+EyWy9Tuwoko6giz59wkhjh2eQbqQZAzyvJSZvi02UMZ280zOUpuJVvq9olH0x4Z5dNzbu6+wi/H
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 563485eb-f7ff-47aa-8cae-08d75f16b7f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 21:59:07.8442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1QqdvX+HTGu2gTt6bKB4nBBCx3JJXaW/xkMgzVVqhB79t9akK25hlBtjVm2WbXNQelP5qBf2Wdk9aNMG2NBzCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6173
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

FTE memory allocation using alloc_fte() doesn't have any dependency
on the flow group.
Hence, do not hold flow group lock while performing alloc_fte().
This helps to reduce contention of flow group lock.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Daniel Jurgens <danielj@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.c
index 3bbb49354829..e5591f4f19b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1814,6 +1814,13 @@ _mlx5_add_flow_rules(struct mlx5_flow_table *ft,
 		return rule;
 	}
=20
+	fte =3D alloc_fte(ft, spec, flow_act);
+	if (IS_ERR(fte)) {
+		up_write_ref_node(&ft->node, false);
+		err =3D PTR_ERR(fte);
+		goto err_alloc_fte;
+	}
+
 	nested_down_write_ref_node(&g->node, FS_LOCK_PARENT);
 	up_write_ref_node(&ft->node, false);
=20
@@ -1821,17 +1828,9 @@ _mlx5_add_flow_rules(struct mlx5_flow_table *ft,
 	if (err)
 		goto err_release_fg;
=20
-	fte =3D alloc_fte(ft, spec, flow_act);
-	if (IS_ERR(fte)) {
-		err =3D PTR_ERR(fte);
-		goto err_release_fg;
-	}
-
 	err =3D insert_fte(g, fte);
-	if (err) {
-		kmem_cache_free(steering->ftes_cache, fte);
+	if (err)
 		goto err_release_fg;
-	}
=20
 	nested_down_write_ref_node(&fte->node, FS_LOCK_CHILD);
 	up_write_ref_node(&g->node, false);
@@ -1843,6 +1842,8 @@ _mlx5_add_flow_rules(struct mlx5_flow_table *ft,
=20
 err_release_fg:
 	up_write_ref_node(&g->node, false);
+	kmem_cache_free(steering->ftes_cache, fte);
+err_alloc_fte:
 	tree_put_node(&g->node, false);
 	return ERR_PTR(err);
 }
--=20
2.21.0

