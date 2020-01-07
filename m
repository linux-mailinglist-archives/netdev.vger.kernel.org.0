Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF43132F1E
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 20:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgAGTOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 14:14:24 -0500
Received: from mail-vi1eur05on2055.outbound.protection.outlook.com ([40.107.21.55]:6105
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728726AbgAGTOX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 14:14:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZW8t8A4rbjg+Aum/dq5okHXzCXqQ/YQmdqr1pBRWd58+1ul894jyZSUzRIzlsOQ6T5IVwpQnDfliIOgbiKWym3x58Pp21EkFVlhxEa6y9Cr9clhcOz6h6oQkLrc6Vqw7e9Zx04B5Z9v4XptygOvcc2KchHbwBFWDQGjbACd+W4gYF/w6cpsR3+mKBDg7z7u2Cdg1Up7kyHMFaR+qKpAIr4lscdVuK9vaAgqB2UcPG6DweXnTjkbnU2gV7iqvbAsqeZnKn5KzRTJ/c7vJmXExxJKlIbzbk/MpyHawTQc9uAfUm5dmuBAjH1ltb6OYeO49J2KatKbegmMVb8xKDtEqmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U0vj5IS+yPzmFZhUWTtQCazBWCNRBx+qiRdo66VYcMQ=;
 b=Z7CKO1wrdIodOifS98HkRbvaa/3URfsPcuJpBeonKfjJtRHiBqWhsv+7bH1iCKTe50+SZmt8nvUhopmi0p0SQgXGOL9RqlsoYDWImcm16Crzf/1/0PHIzG+4ZCzuRFpbmHW5784lrrMZOevTef+U40e4Hi1d6aOmKfVUwpqXlhN0P5Hv2KmDAppLgettCHdQkb3hC2brLw2pnFgexdKx8rkM6RPudTGXHPxLD3Lf46ecIYEBu4fmDR5D+DcYfB2hPsL3oIzR5mV6jSbs2QwMs9+Jlt3FeBmx/8L7m3QvVgxAHhR1ovUei7eGHvUBkvufl8dtHe0OnEG7/au8degP1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U0vj5IS+yPzmFZhUWTtQCazBWCNRBx+qiRdo66VYcMQ=;
 b=l7J3l5qXtnAoqF6OOMCxIvMfoPN+m/hkIsnVMxlMrRK0aNCuiaWrmXPxBOzdsC+Tr9+74S7WJvrfI5EEo5awuMu8pC6c896go91BWMk7O8QsZV5oBqQZI7Y4xQnd6E/7mYmiKctuPdOld0irKA37i/nU5MgfKE+HNTulBnaGmuw=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (20.177.34.93) by
 AM6PR05MB5411.eurprd05.prod.outlook.com (20.177.189.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11; Tue, 7 Jan 2020 19:14:15 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a%7]) with mapi id 15.20.2602.015; Tue, 7 Jan 2020
 19:14:15 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR06CA0068.namprd06.prod.outlook.com (2603:10b6:a03:14b::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.12 via Frontend Transport; Tue, 7 Jan 2020 19:14:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/13] net/mlx5: Use async EQ setup cleanup helpers for
 multiple EQs
Thread-Topic: [net-next 06/13] net/mlx5: Use async EQ setup cleanup helpers
 for multiple EQs
Thread-Index: AQHVxY6muTL8UF7jEEum8ietOBBP1Q==
Date:   Tue, 7 Jan 2020 19:14:15 +0000
Message-ID: <20200107191335.12272-7-saeedm@mellanox.com>
References: <20200107191335.12272-1-saeedm@mellanox.com>
In-Reply-To: <20200107191335.12272-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0068.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::45) To AM6PR05MB5094.eurprd05.prod.outlook.com
 (2603:10a6:20b:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e639808d-7927-490e-6aa2-08d793a5c955
x-ms-traffictypediagnostic: AM6PR05MB5411:|AM6PR05MB5411:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB5411BFB43D3927DC5059EF78BE3F0@AM6PR05MB5411.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:133;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(189003)(81166006)(52116002)(6916009)(8936002)(81156014)(8676002)(26005)(86362001)(36756003)(316002)(5660300002)(107886003)(6506007)(4326008)(478600001)(1076003)(16526019)(956004)(2616005)(2906002)(66446008)(64756008)(66556008)(66476007)(71200400001)(66946007)(6486002)(6512007)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5411;H:AM6PR05MB5094.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vsdbmht7LUEjy6g2rsxaNBDCPIQ5+4ThitOL365/REEszEmdH2AA/NMdj9IAls15TWqESCpHo1B+WOrcdCq56h2IWQ9NHfyHFy5Cle4JFxlJJ+nTjDMDBgCkzPVKpiSxmZGxVqJWs5I88BxoJJV/YRZkSZ0GPUPYc8OXUsRN9FMXbGRftH3qsmb2RcLugviET3kKXktWZW4PamsuGkMEYOjZ1swWErBxPn7aYDuMjABqk7cYrYsEVefKZSNDfTOwovvRZKwM0S0BI+2Wsfr7N4JxVZuqKqpswJGGaj67Kec7ZcBw1E3RZkiqJr17F1bFWBAOqqcQ8SpUFkrkiGLxkreynQ8iLu1sEhrmQ+w86PwslZz+VOD+EX7z9sgXCrH7SpMz5kKYfhUrCsRZi+YyNLqrUezzU+JnX4oWzePo3DmEXxplMgBq/ZZ1Z41iN2D9cIFme+/mqjPJ2IswQ4OhkZjsBnhy6IdEe2M7swd1emgSpsxydQ8QPEFDf1OT2+qIOLdrWrd7eQplhWb3hRze7tQ7ffp58YIP0sDs3vO32KE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e639808d-7927-490e-6aa2-08d793a5c955
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 19:14:15.4218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NldXV/HxTsLGS/vl2Wxx/Wxkita41eWQlexJEGXdTGJ6gJAwBw99DGQLPW1WFJSM7wcFQWJwLdxP5qhkzqAjSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5411
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Use helper routines to setup and teardown multiple EQs and reuse the
code in setup, cleanup and error unwinding flows.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 114 ++++++++-----------
 1 file changed, 49 insertions(+), 65 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/eth=
ernet/mellanox/mlx5/core/eq.c
index 2c716abc0f27..cccea3a8eddd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -564,6 +564,39 @@ static void gather_async_events_mask(struct mlx5_core_=
dev *dev, u64 mask[4])
 		gather_user_async_events(dev, mask);
 }
=20
+static int
+setup_async_eq(struct mlx5_core_dev *dev, struct mlx5_eq_async *eq,
+	       struct mlx5_eq_param *param, const char *name)
+{
+	int err;
+
+	eq->irq_nb.notifier_call =3D mlx5_eq_async_int;
+
+	err =3D create_async_eq(dev, &eq->core, param);
+	if (err) {
+		mlx5_core_warn(dev, "failed to create %s EQ %d\n", name, err);
+		return err;
+	}
+	err =3D mlx5_eq_enable(dev, &eq->core, &eq->irq_nb);
+	if (err) {
+		mlx5_core_warn(dev, "failed to enable %s EQ %d\n", name, err);
+		destroy_async_eq(dev, &eq->core);
+	}
+	return err;
+}
+
+static void cleanup_async_eq(struct mlx5_core_dev *dev,
+			     struct mlx5_eq_async *eq, const char *name)
+{
+	int err;
+
+	mlx5_eq_disable(dev, &eq->core, &eq->irq_nb);
+	err =3D destroy_async_eq(dev, &eq->core);
+	if (err)
+		mlx5_core_err(dev, "failed to destroy %s eq, err(%d)\n",
+			      name, err);
+}
+
 static int create_async_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table =3D dev->priv.eq_table;
@@ -573,77 +606,45 @@ static int create_async_eqs(struct mlx5_core_dev *dev=
)
 	MLX5_NB_INIT(&table->cq_err_nb, cq_err_event_notifier, CQ_ERROR);
 	mlx5_eq_notifier_register(dev, &table->cq_err_nb);
=20
-	table->cmd_eq.irq_nb.notifier_call =3D mlx5_eq_async_int;
 	param =3D (struct mlx5_eq_param) {
 		.irq_index =3D 0,
 		.nent =3D MLX5_NUM_CMD_EQE,
+		.mask[0] =3D 1ull << MLX5_EVENT_TYPE_CMD,
 	};
-
-	param.mask[0] =3D 1ull << MLX5_EVENT_TYPE_CMD;
-	err =3D create_async_eq(dev, &table->cmd_eq.core, &param);
-	if (err) {
-		mlx5_core_warn(dev, "failed to create cmd EQ %d\n", err);
-		goto err0;
-	}
-	err =3D mlx5_eq_enable(dev, &table->cmd_eq.core, &table->cmd_eq.irq_nb);
-	if (err) {
-		mlx5_core_warn(dev, "failed to enable cmd EQ %d\n", err);
+	err =3D setup_async_eq(dev, &table->cmd_eq, &param, "cmd");
+	if (err)
 		goto err1;
-	}
+
 	mlx5_cmd_use_events(dev);
=20
-	table->async_eq.irq_nb.notifier_call =3D mlx5_eq_async_int;
 	param =3D (struct mlx5_eq_param) {
 		.irq_index =3D 0,
 		.nent =3D MLX5_NUM_ASYNC_EQE,
 	};
=20
 	gather_async_events_mask(dev, param.mask);
-	err =3D create_async_eq(dev, &table->async_eq.core, &param);
-	if (err) {
-		mlx5_core_warn(dev, "failed to create async EQ %d\n", err);
+	err =3D setup_async_eq(dev, &table->async_eq, &param, "async");
+	if (err)
 		goto err2;
-	}
-	err =3D mlx5_eq_enable(dev, &table->async_eq.core,
-			     &table->async_eq.irq_nb);
-	if (err) {
-		mlx5_core_warn(dev, "failed to enable async EQ %d\n", err);
-		goto err3;
-	}
=20
-	table->pages_eq.irq_nb.notifier_call =3D mlx5_eq_async_int;
 	param =3D (struct mlx5_eq_param) {
 		.irq_index =3D 0,
 		.nent =3D /* TODO: sriov max_vf + */ 1,
+		.mask[0] =3D 1ull << MLX5_EVENT_TYPE_PAGE_REQUEST,
 	};
=20
-	param.mask[0] =3D 1ull << MLX5_EVENT_TYPE_PAGE_REQUEST;
-	err =3D create_async_eq(dev, &table->pages_eq.core, &param);
-	if (err) {
-		mlx5_core_warn(dev, "failed to create pages EQ %d\n", err);
-		goto err4;
-	}
-	err =3D mlx5_eq_enable(dev, &table->pages_eq.core,
-			     &table->pages_eq.irq_nb);
-	if (err) {
-		mlx5_core_warn(dev, "failed to enable pages EQ %d\n", err);
-		goto err5;
-	}
+	err =3D setup_async_eq(dev, &table->pages_eq, &param, "pages");
+	if (err)
+		goto err3;
=20
-	return err;
+	return 0;
=20
-err5:
-	destroy_async_eq(dev, &table->pages_eq.core);
-err4:
-	mlx5_eq_disable(dev, &table->async_eq.core, &table->async_eq.irq_nb);
 err3:
-	destroy_async_eq(dev, &table->async_eq.core);
+	cleanup_async_eq(dev, &table->async_eq, "async");
 err2:
 	mlx5_cmd_use_polling(dev);
-	mlx5_eq_disable(dev, &table->cmd_eq.core, &table->cmd_eq.irq_nb);
+	cleanup_async_eq(dev, &table->cmd_eq, "cmd");
 err1:
-	destroy_async_eq(dev, &table->cmd_eq.core);
-err0:
 	mlx5_eq_notifier_unregister(dev, &table->cq_err_nb);
 	return err;
 }
@@ -651,28 +652,11 @@ static int create_async_eqs(struct mlx5_core_dev *dev=
)
 static void destroy_async_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table =3D dev->priv.eq_table;
-	int err;
-
-	mlx5_eq_disable(dev, &table->pages_eq.core, &table->pages_eq.irq_nb);
-	err =3D destroy_async_eq(dev, &table->pages_eq.core);
-	if (err)
-		mlx5_core_err(dev, "failed to destroy pages eq, err(%d)\n",
-			      err);
-
-	mlx5_eq_disable(dev, &table->async_eq.core, &table->async_eq.irq_nb);
-	err =3D destroy_async_eq(dev, &table->async_eq.core);
-	if (err)
-		mlx5_core_err(dev, "failed to destroy async eq, err(%d)\n",
-			      err);
=20
+	cleanup_async_eq(dev, &table->pages_eq, "pages");
+	cleanup_async_eq(dev, &table->async_eq, "async");
 	mlx5_cmd_use_polling(dev);
-
-	mlx5_eq_disable(dev, &table->cmd_eq.core, &table->cmd_eq.irq_nb);
-	err =3D destroy_async_eq(dev, &table->cmd_eq.core);
-	if (err)
-		mlx5_core_err(dev, "failed to destroy command eq, err(%d)\n",
-			      err);
-
+	cleanup_async_eq(dev, &table->cmd_eq, "cmd");
 	mlx5_eq_notifier_unregister(dev, &table->cq_err_nb);
 }
=20
--=20
2.24.1

