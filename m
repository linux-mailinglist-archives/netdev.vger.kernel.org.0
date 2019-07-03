Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0D05DF09
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 09:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfGCHji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 03:39:38 -0400
Received: from mail-eopbgr00088.outbound.protection.outlook.com ([40.107.0.88]:30325
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727275AbfGCHjf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 03:39:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uKeDy2mcb0g2sBJFiDHq3RLg65Jlci9g1xW/67jQzdw=;
 b=sPJoQTxe8N631Of5gS+C8jK+4Ln6i3YsAnQqwdig2R/+CKYUN7qIUERxNnBvphzqs38+zWCHAPGkGKcvBQoHeDntg1qgfswBTc+rGwH08EkrMy8hqACULsSZxCtFNuPjRU8Jluhv3yuQ/8+rESThgKBk48CEtygwjN5vsFdZvyo=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2309.eurprd05.prod.outlook.com (10.168.55.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Wed, 3 Jul 2019 07:39:30 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Wed, 3 Jul 2019
 07:39:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 3/5] net/mlx5: Refactor mlx5_esw_query_functions for
 modularity
Thread-Topic: [PATCH mlx5-next 3/5] net/mlx5: Refactor
 mlx5_esw_query_functions for modularity
Thread-Index: AQHVMXJyUjpHxxM+V0igX1IXp3wX5g==
Date:   Wed, 3 Jul 2019 07:39:30 +0000
Message-ID: <20190703073909.14965-4-saeedm@mellanox.com>
References: <20190703073909.14965-1-saeedm@mellanox.com>
In-Reply-To: <20190703073909.14965-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:a03:54::23) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f83237af-1954-4730-e5a6-08d6ff89952f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2309;
x-ms-traffictypediagnostic: DB6PR0501MB2309:
x-microsoft-antispam-prvs: <DB6PR0501MB23094F53ECB1D220B58319BABEFB0@DB6PR0501MB2309.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(199004)(189003)(66556008)(66946007)(66446008)(6512007)(64756008)(73956011)(66476007)(107886003)(5660300002)(1076003)(52116002)(54906003)(71200400001)(2906002)(66066001)(256004)(99286004)(76176011)(14444005)(3846002)(7736002)(6116002)(53936002)(6436002)(71190400001)(4326008)(6486002)(68736007)(81156014)(110136005)(305945005)(26005)(36756003)(316002)(2616005)(50226002)(8676002)(478600001)(476003)(8936002)(25786009)(86362001)(486006)(450100002)(386003)(6506007)(81166006)(186003)(11346002)(446003)(14454004)(6636002)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2309;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: THvpS56o2a0z7jXuWLCIvo8/dnOy5svqkU4oFPNOtzJbM3t2gAXmDf2q1AoiisyUaTPAcqtyquDnyZOsQLH3AO3k3qsijNxMgT657NkrvRnwtxAri+qgd9CxLu5jbC46R6ZS8ICFx01dZzHFUD3DVRR8y8zM2j5U5LPo6A/kpJirYZRxMGRGFPhPdAk1DCo3xWeVB8i3bo0eMF1XXbpqJf+XKhBvIJRlbQeZe7zsJcuaxPBNAck0tj7MENP+qZ9YjJc09YjbOpzVeDmkl4rM0WBEny0UNVJsyrPyE6myBmjfZ7zWmd3cQd+9sKvwNKLZBA/PCRvx5k0FyE2Ik/3XV1ELaP7hJyBU4JuENxLXmVSSke4gAEfSrPoOyuWHP9Z2TcsoV9gE8ZyUOJN1Ooh+kZTZPE18/ONK9VvIb19B9+Y=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f83237af-1954-4730-e5a6-08d6ff89952f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 07:39:30.2123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2309
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Functions change event output data size changes when functions other
than VFs will be enabled in HCA CAP.
With current API, multiple callers needs to align, calculate accurate
size of the output data depending on number on non VF functions enabled
in the device.
Instead of duplicating such math at multiple places, refactor
mlx5_esw_query_functions() to return raw output allocated by itself.

Caller must free the allocated memory using kvfree() as described in the
function comment section.
This hides calcuation within mlx5_esw_query_functions() and provides
simpler API.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 38 +++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  7 ++--
 .../mellanox/mlx5/core/eswitch_offloads.c     |  8 ++--
 .../net/ethernet/mellanox/mlx5/core/sriov.c   | 15 +++++---
 4 files changed, 46 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 9137a8390216..62954265b57c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1715,14 +1715,34 @@ static int eswitch_vport_event(struct notifier_bloc=
k *nb,
 	return NOTIFY_OK;
 }
=20
-int mlx5_esw_query_functions(struct mlx5_core_dev *dev, u32 *out, int outl=
en)
+/**
+ * mlx5_esw_query_functions - Returns raw output about functions state
+ * @dev:	Pointer to device to query
+ *
+ * mlx5_esw_query_functions() allocates and returns functions changed
+ * raw output memory pointer from device on success. Otherwise returns ERR=
_PTR.
+ * Caller must free the memory using kvfree() when valid pointer is return=
ed.
+ */
+const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
 {
+	int outlen =3D MLX5_ST_SZ_BYTES(query_esw_functions_out);
 	u32 in[MLX5_ST_SZ_DW(query_esw_functions_in)] =3D {};
+	u32 *out;
+	int err;
+
+	out =3D kvzalloc(outlen, GFP_KERNEL);
+	if (!out)
+		return ERR_PTR(-ENOMEM);
=20
 	MLX5_SET(query_esw_functions_in, in, opcode,
 		 MLX5_CMD_OP_QUERY_ESW_FUNCTIONS);
=20
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
+	err =3D mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
+	if (!err)
+		return out;
+
+	kvfree(out);
+	return ERR_PTR(err);
 }
=20
 static void mlx5_eswitch_event_handlers_register(struct mlx5_eswitch *esw)
@@ -2527,8 +2547,7 @@ bool mlx5_esw_multipath_prereq(struct mlx5_core_dev *=
dev0,
=20
 void mlx5_eswitch_update_num_of_vfs(struct mlx5_eswitch *esw, const int nu=
m_vfs)
 {
-	u32 out[MLX5_ST_SZ_DW(query_esw_functions_out)] =3D {};
-	int err;
+	const u32 *out;
=20
 	WARN_ON_ONCE(esw->mode !=3D MLX5_ESWITCH_NONE);
=20
@@ -2537,8 +2556,11 @@ void mlx5_eswitch_update_num_of_vfs(struct mlx5_eswi=
tch *esw, const int num_vfs)
 		return;
 	}
=20
-	err =3D mlx5_esw_query_functions(esw->dev, out, sizeof(out));
-	if (!err)
-		esw->esw_funcs.num_vfs =3D MLX5_GET(query_esw_functions_out, out,
-						  host_params_context.host_num_of_vfs);
+	out =3D mlx5_esw_query_functions(esw->dev);
+	if (IS_ERR(out))
+		return;
+
+	esw->esw_funcs.num_vfs =3D MLX5_GET(query_esw_functions_out, out,
+					  host_params_context.host_num_of_vfs);
+	kvfree(out);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index f59183440d7f..d2d33a9893bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -403,7 +403,7 @@ bool mlx5_esw_lag_prereq(struct mlx5_core_dev *dev0,
 bool mlx5_esw_multipath_prereq(struct mlx5_core_dev *dev0,
 			       struct mlx5_core_dev *dev1);
=20
-int mlx5_esw_query_functions(struct mlx5_core_dev *dev, u32 *out, int outl=
en);
+const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev);
=20
 #define MLX5_DEBUG_ESWITCH_MASK BIT(3)
=20
@@ -560,10 +560,9 @@ static inline int  mlx5_eswitch_enable(struct mlx5_esw=
itch *esw, int mode) { ret
 static inline void mlx5_eswitch_disable(struct mlx5_eswitch *esw) {}
 static inline bool mlx5_esw_lag_prereq(struct mlx5_core_dev *dev0, struct =
mlx5_core_dev *dev1) { return true; }
 static inline bool mlx5_eswitch_is_funcs_handler(struct mlx5_core_dev *dev=
) { return false; }
-static inline int
-mlx5_esw_query_functions(struct mlx5_core_dev *dev, u32 *out, int outlen)
+static inline const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *de=
v)
 {
-	return -EOPNOTSUPP;
+	return ERR_PTR(-EOPNOTSUPP);
 }
=20
 static inline void mlx5_eswitch_update_num_of_vfs(struct mlx5_eswitch *esw=
, const int num_vfs) {}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 42c0db585561..74ab7bd264ed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2075,19 +2075,19 @@ esw_vfs_changed_event_handler(struct mlx5_eswitch *=
esw, const u32 *out)
=20
 static void esw_functions_changed_event_handler(struct work_struct *work)
 {
-	u32 out[MLX5_ST_SZ_DW(query_esw_functions_out)] =3D {};
 	struct mlx5_host_work *host_work;
 	struct mlx5_eswitch *esw;
-	int err;
+	const u32 *out;
=20
 	host_work =3D container_of(work, struct mlx5_host_work, work);
 	esw =3D host_work->esw;
=20
-	err =3D mlx5_esw_query_functions(esw->dev, out, sizeof(out));
-	if (err)
+	out =3D mlx5_esw_query_functions(esw->dev);
+	if (IS_ERR(out))
 		goto out;
=20
 	esw_vfs_changed_event_handler(esw, out);
+	kvfree(out);
 out:
 	kfree(host_work);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/=
ethernet/mellanox/mlx5/core/sriov.c
index 547d0be9025e..61fcfd8b39b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -197,22 +197,25 @@ void mlx5_sriov_detach(struct mlx5_core_dev *dev)
=20
 static u16 mlx5_get_max_vfs(struct mlx5_core_dev *dev)
 {
-	u32 out[MLX5_ST_SZ_DW(query_esw_functions_out)] =3D {};
 	u16 host_total_vfs;
-	int err;
+	const u32 *out;
=20
 	if (mlx5_core_is_ecpf_esw_manager(dev)) {
-		err =3D mlx5_esw_query_functions(dev, out, sizeof(out));
-		host_total_vfs =3D MLX5_GET(query_esw_functions_out, out,
-					  host_params_context.host_total_vfs);
+		out =3D mlx5_esw_query_functions(dev);
=20
 		/* Old FW doesn't support getting total_vfs from esw func
 		 * but supports getting it from pci_sriov.
 		 */
-		if (!err && host_total_vfs)
+		if (IS_ERR(out))
+			goto done;
+		host_total_vfs =3D MLX5_GET(query_esw_functions_out, out,
+					  host_params_context.host_total_vfs);
+		kvfree(out);
+		if (host_total_vfs)
 			return host_total_vfs;
 	}
=20
+done:
 	return pci_sriov_get_totalvfs(dev->pdev);
 }
=20
--=20
2.21.0

