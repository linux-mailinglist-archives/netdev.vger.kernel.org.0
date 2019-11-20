Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE2EC104664
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 23:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfKTWWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 17:22:38 -0500
Received: from mail-eopbgr10048.outbound.protection.outlook.com ([40.107.1.48]:31714
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726554AbfKTWWg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 17:22:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lM3sDxob0sDI668L3ZIwK8c49CkqgnbqDxEqIJUDScPbwPhnJJuZKbap408PPyj+MjyDQIRGfDYl2h8UO7NVLefngmjuBUuPlHYu6WY60hGomZAEevHgO0RU2bo/sG66z4Kn/U12G24+8DPCk3y2AbWdLAx4HtT5yGCqiyV0td84ne4ZE2EJRODVJkvuOvxuaf04INd0wMucS9ZMGqQSeULb3ZMG+jTK4ZwZHlf4euHQPNOm/fVMY6YIiRUHlsVex+YSgPB5Zz3uk/7bejf7Cme9Dce2Ie9X5ICJD7chG9UXCQ+XbZm4UR1BiXBouZKJpX/Hp1TT3rDE9LgYfF1Btg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpDI0/3DL94oYdGq6NEI0tMQZImoHE5XLzNyEA4HH2s=;
 b=BQyBtuQnESD8BxAtxugfEzueQnTHMVj/sBgyytYUl49+bbkscHbu1PNfySfY+v1d02qAtP/1ngPU7YXze8Yih+Pv6mENtPKBM1AftnLOaTF3Mn1KW1VeiRroR5xvGwJNagABSKvOEvbnd4BQayfKwgrowvQYOj0kkcCko4f94TDgX8y/VOakdoa06WzSBgn10p0FPzyX9TEIPOhxFcRvbbCKc2xsEwO2IKNBGbn0us2uwAQQoqgHGncAwP4Pn+8wyyynCLNzMdRWn421U5JfNKlID7gxZYkq4iQS5SO+kPoC/Owdct5h1Cl/gGIecCYHRUZ3BYfcM9HLYpK5J39RuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpDI0/3DL94oYdGq6NEI0tMQZImoHE5XLzNyEA4HH2s=;
 b=bvV6om+ck90CEH6dtkBnME0SMwICXQ3LrVEueiTNlmT6BhbRUVSxw4A7M904APXO+CqUUpj1fiCTQ4z0p4XS/MJ8Nz1Wq4updyNAIjEg9Te7ehMtDyZCI8Ni4lNViPVWrPS6hLD518KdVJNy16OzGrA40KppweQ/Sq0B26jIF2s=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5341.eurprd05.prod.outlook.com (20.178.8.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Wed, 20 Nov 2019 22:22:28 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 22:22:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: [PATCH mlx5-next 4/5] net/mlx5: Don't write read-only fields in
 MODIFY_HCA_VPORT_CONTEXT command
Thread-Topic: [PATCH mlx5-next 4/5] net/mlx5: Don't write read-only fields in
 MODIFY_HCA_VPORT_CONTEXT command
Thread-Index: AQHVn/D+dS//M7IU6EyiqH1+Sgw20A==
Date:   Wed, 20 Nov 2019 22:22:28 +0000
Message-ID: <20191120222128.29646-5-saeedm@mellanox.com>
References: <20191120222128.29646-1-saeedm@mellanox.com>
In-Reply-To: <20191120222128.29646-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b52a7df8-817e-449f-403f-08d76e082083
x-ms-traffictypediagnostic: VI1PR05MB5341:|VI1PR05MB5341:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5341B07609D3D63171CF4C32BE4F0@VI1PR05MB5341.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(366004)(396003)(39860400002)(376002)(199004)(189003)(476003)(102836004)(316002)(99286004)(66476007)(76176011)(8936002)(14454004)(386003)(2906002)(6506007)(52116002)(110136005)(6436002)(446003)(6486002)(66556008)(54906003)(2616005)(66446008)(478600001)(64756008)(66066001)(66946007)(6636002)(5660300002)(11346002)(486006)(50226002)(81166006)(71190400001)(71200400001)(7736002)(186003)(305945005)(81156014)(36756003)(25786009)(8676002)(4326008)(6512007)(450100002)(256004)(86362001)(6116002)(3846002)(1076003)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5341;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tK3DnvYyLRH3lVEW758dngHke1wBAWhfcTdhFHdEANj7PNTcmbtVtEvQea5U9BgCBNrU8aiOnul4q7C/wWQhpg7vPZvpNqgZ/RyWpqFSqHDiSsY9bLawlvSxtY2oxJHZudjN3I++es62t977IOv18mGgldA0zoht0j7y6BmJBeMKtqIbJYQ3eVzJlshTCF3GEoOtBiS0dq/96YWnKVMNtly74/mK1USQ1SEgHCqfICjYEJQ8A56YljLopLdN7PBmkteQotqAd2S10DIjgZaERUMU+MMCPXGhfLAnMg4e+8/EDEAzwZhlIuK+i1jWyhPkOGOS77zLxoSHq0e8Js0P1jpnYcku4dwfI/RwEwMmRFycxFdvvulcHcW753scrgDiaCZb733b+HOOPSl0+CvYBt24i4v7wuZzsRs5k9f1vbpDaDLEkZY43N5WzVNEGHKs
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b52a7df8-817e-449f-403f-08d76e082083
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 22:22:28.1910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eIeKH3aaTwcc0GszFAKYgmSyoT0U+2bZzCn4ZzcWXf5FFUIuH+Ve4DjNSgrOFB/mvTljutgzpJTDHn6xttCHsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5341
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

The MODIFY_HCA_VPORT_CONTEXT uses field_selector to mask fields needed
to be written, other fields are required to be zero according to the
HW specification. The supported fields are controlled by bitfield
and limited to vport state, node and port GUIDs.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/vport.c   | 27 +++++--------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/=
ethernet/mellanox/mlx5/core/vport.c
index 30f7848a6f88..1faac31f74d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -1064,26 +1064,13 @@ int mlx5_core_modify_hca_vport_context(struct mlx5_=
core_dev *dev,
=20
 	ctx =3D MLX5_ADDR_OF(modify_hca_vport_context_in, in, hca_vport_context);
 	MLX5_SET(hca_vport_context, ctx, field_select, req->field_select);
-	MLX5_SET(hca_vport_context, ctx, sm_virt_aware, req->sm_virt_aware);
-	MLX5_SET(hca_vport_context, ctx, has_smi, req->has_smi);
-	MLX5_SET(hca_vport_context, ctx, has_raw, req->has_raw);
-	MLX5_SET(hca_vport_context, ctx, vport_state_policy, req->policy);
-	MLX5_SET(hca_vport_context, ctx, port_physical_state, req->phys_state);
-	MLX5_SET(hca_vport_context, ctx, vport_state, req->vport_state);
-	MLX5_SET64(hca_vport_context, ctx, port_guid, req->port_guid);
-	MLX5_SET64(hca_vport_context, ctx, node_guid, req->node_guid);
-	MLX5_SET(hca_vport_context, ctx, cap_mask1, req->cap_mask1);
-	MLX5_SET(hca_vport_context, ctx, cap_mask1_field_select, req->cap_mask1_p=
erm);
-	MLX5_SET(hca_vport_context, ctx, cap_mask2, req->cap_mask2);
-	MLX5_SET(hca_vport_context, ctx, cap_mask2_field_select, req->cap_mask2_p=
erm);
-	MLX5_SET(hca_vport_context, ctx, lid, req->lid);
-	MLX5_SET(hca_vport_context, ctx, init_type_reply, req->init_type_reply);
-	MLX5_SET(hca_vport_context, ctx, lmc, req->lmc);
-	MLX5_SET(hca_vport_context, ctx, subnet_timeout, req->subnet_timeout);
-	MLX5_SET(hca_vport_context, ctx, sm_lid, req->sm_lid);
-	MLX5_SET(hca_vport_context, ctx, sm_sl, req->sm_sl);
-	MLX5_SET(hca_vport_context, ctx, qkey_violation_counter, req->qkey_violat=
ion_counter);
-	MLX5_SET(hca_vport_context, ctx, pkey_violation_counter, req->pkey_violat=
ion_counter);
+	if (req->field_select & MLX5_HCA_VPORT_SEL_STATE_POLICY)
+		MLX5_SET(hca_vport_context, ctx, vport_state_policy,
+			 req->policy);
+	if (req->field_select & MLX5_HCA_VPORT_SEL_PORT_GUID)
+		MLX5_SET64(hca_vport_context, ctx, port_guid, req->port_guid);
+	if (req->field_select & MLX5_HCA_VPORT_SEL_NODE_GUID)
+		MLX5_SET64(hca_vport_context, ctx, node_guid, req->node_guid);
 	err =3D mlx5_cmd_exec(dev, in, in_sz, out, sizeof(out));
 ex:
 	kfree(in);
--=20
2.21.0

