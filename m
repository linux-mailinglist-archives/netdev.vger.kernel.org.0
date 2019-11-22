Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0635D1079EF
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 22:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfKVV0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 16:26:54 -0500
Received: from mail-eopbgr50063.outbound.protection.outlook.com ([40.107.5.63]:59697
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726620AbfKVV0y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 16:26:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hoyqDMfhLxVjnDr637RJ2fIK4Z/TYXiW01hFJlg3uOJwha7CKRHHn0xG75WDXqXgITHiMf7RHiTgy5/OOJ6Q3KFXMfKyDA5NoWJ1VGn5p88vsdgyS/aGRf1VuwT3UW9vn3g0IvjQnbyNID5wPC3MpvSwvq17+FDX2rkYmwIyhlWjTZuGDT0LbzPCxyOycOtPJyrzK2mWFe23lhalFAkiCLFh8ZHnuwGJ7fYuvELRehDqFmTcKrvhzm3P/Wc0EX9AH2UDT/Ycoaz29LwnTFntBCczXT0bq1z7FPeoK8N57BLUKl7riXnrUSlc64AjtJbZJoI5Cmw6+G6VBAjZZIaeGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpDI0/3DL94oYdGq6NEI0tMQZImoHE5XLzNyEA4HH2s=;
 b=Ay0ELGxYE2zOxNnL3EXWJGsSg1QBUnRfr14+7iCCsYOpoiS7CCBFO8U83P1yNRFz2SFy85aufiKjvwNaWVShBRVMGcSZR9jLnIt7swYJgAZ+f51Zw6DT4Y9hgVBb+fapO2ru1HytbDCXrbICQWE7l7UPQLHnfaidMVw8WRO+uTW+uwAyThKVuc3QfiZRF3lRWBWJTgki01euW7nfXpBfqtaIDntadmXBu01WKIjnhM6SKyjKDt1gx9IKhdjVRL1kYaqLUyQMxK3Eh6ynfDyxoncYdFPSuoCXkU1PUT0FZX9G05bT4YJF8NZkOpcSg9/i9503MnDq6fjwhrULjalkXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpDI0/3DL94oYdGq6NEI0tMQZImoHE5XLzNyEA4HH2s=;
 b=KB47SGACgFnT4C5BKJPPvBfEIWexFW3JcPm2tGq8QRNUNOuKp1SObqmTd83skViXeBAbn2Pn3a1YCFCD6U5+PMVLSjQdAyHI460A9txtioMA8N6wC7HYUjbLuSh2twTRZ63PSUjyQz4PN1xKBPbpi/U0t4dvYHV1JzrIv3In4sw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4350.eurprd05.prod.outlook.com (52.134.31.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Fri, 22 Nov 2019 21:26:48 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 21:26:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 1/6] net/mlx5: Don't write read-only fields in
 MODIFY_HCA_VPORT_CONTEXT command
Thread-Topic: [net-next 1/6] net/mlx5: Don't write read-only fields in
 MODIFY_HCA_VPORT_CONTEXT command
Thread-Index: AQHVoXuMBjgjYj+5nUy0VN7pJ/xAIA==
Date:   Fri, 22 Nov 2019 21:26:48 +0000
Message-ID: <20191122212541.17715-2-saeedm@mellanox.com>
References: <20191122212541.17715-1-saeedm@mellanox.com>
In-Reply-To: <20191122212541.17715-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::26) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: eeacc35a-230a-4886-a366-08d76f92aeb6
x-ms-traffictypediagnostic: VI1PR05MB4350:|VI1PR05MB4350:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4350E70930A977BA7055023ABE490@VI1PR05MB4350.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(189003)(199004)(256004)(6512007)(1076003)(76176011)(107886003)(66946007)(50226002)(6506007)(66476007)(86362001)(52116002)(66066001)(8676002)(6916009)(386003)(81166006)(25786009)(64756008)(8936002)(4326008)(99286004)(66556008)(66446008)(81156014)(6436002)(6486002)(5660300002)(36756003)(2906002)(54906003)(102836004)(316002)(7736002)(71200400001)(71190400001)(3846002)(6116002)(305945005)(186003)(26005)(478600001)(2616005)(14454004)(11346002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4350;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: phPPa/KTJBzvEUfFCgx0hXd/nhUvTnJEBqkom9ifp/ksxq6/VYRsVsFmfFiBXXW5cy2J6TPBYYOqLZ917PN0++dRri2rERrZHPOijjAsskQNTYM2UaOfz9JiWKBwBA7omHtq4MAWV6kHjvrKmm0DFn3+HL3MyNTjZpP06+6L7ndcv2D7uWmzHMo4wPXNQrx3bUhk3UD28uykiS0kUCvq0Xqck8nz+91kZHpkUz4vSGxbxNn8ZVHuCE+QCwgvCsNz597N0ce1na0a6cjWYmGEzm3sNb7iyiSOfI/Xbfi0srGoHBB5tKOKk0LCra5RsCp2NvbddPqrpWjzL+P0tSqAMKs6JVhAl8BMxP6CvjbLAuoewn88pTmhdnhSdR2F5+icpIIFBEUz6rLC9aej7x6XCtwrwKi3U1HyR1eKfIzWfeTAcLWkDwOs0xdoeQzZbcoJ
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeacc35a-230a-4886-a366-08d76f92aeb6
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 21:26:48.4227
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wgjhddHQbxyUGPWNDFTLgXneTICyGtI0yyFlmzdVgXNVHDlZZGTtjfcZhJZuGXgS3YUVJblJN6FhWuNXDYJ8lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4350
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

