Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E385B5DF04
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 09:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbfGCHja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 03:39:30 -0400
Received: from mail-eopbgr00088.outbound.protection.outlook.com ([40.107.0.88]:30325
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727008AbfGCHja (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 03:39:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruCPl2nAkZt2VGXdznt/iiiiYw8Bz8BicneSybgO/bk=;
 b=EQAPVKXFkZ9Bg1rUoPPLvEayEljMVJ+I86B7FjDbgy9hzseOMP4eau8XYFoILvUhTEMwmyUIUoPF/S1kBWsgm/jRQ9UmbJIDtpGGJeV/XGT23LunTgKaecJnh5FmDACs32q5xD8VBGsDjenexNB6FMj5WCicMUvl2xMIGWFg0K0=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2309.eurprd05.prod.outlook.com (10.168.55.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Wed, 3 Jul 2019 07:39:26 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Wed, 3 Jul 2019
 07:39:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 1/5] net/mlx5: Introduce and use
 mlx5_eswitch_get_total_vports()
Thread-Topic: [PATCH mlx5-next 1/5] net/mlx5: Introduce and use
 mlx5_eswitch_get_total_vports()
Thread-Index: AQHVMXJwI8lGwKNfGEq5GuvAYG2m3A==
Date:   Wed, 3 Jul 2019 07:39:26 +0000
Message-ID: <20190703073909.14965-2-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: b8963808-5f82-49b8-d933-08d6ff8992dd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2309;
x-ms-traffictypediagnostic: DB6PR0501MB2309:
x-microsoft-antispam-prvs: <DB6PR0501MB230987B8F154378B76E6D910BEFB0@DB6PR0501MB2309.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(199004)(189003)(66556008)(66946007)(66446008)(6512007)(64756008)(73956011)(66476007)(107886003)(5660300002)(1076003)(52116002)(54906003)(71200400001)(2906002)(66066001)(256004)(99286004)(76176011)(3846002)(7736002)(6116002)(53936002)(6436002)(71190400001)(4326008)(6486002)(68736007)(81156014)(110136005)(305945005)(26005)(36756003)(316002)(2616005)(50226002)(8676002)(478600001)(476003)(8936002)(25786009)(86362001)(486006)(450100002)(386003)(6506007)(81166006)(186003)(11346002)(446003)(14454004)(6636002)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2309;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: k0CO5Ah8GaUwCYfk/HWvdIetEo9YXea3crYOVNFD3WBjsxt5N1XcIdddTnoWctccvu1dQFzc9om/OBxyoUZ+hE3KMHDI+xIshY5UYikB7snxaCSwPJh4u4zP2C4FSQ1Aue78BADSraJmf1/Cgq73QMgdTyEV3/To7sxWcPIkPPfFsGnTYdy/hp25PHq8ZRJtxBTN0xepCXjivbY1a9vVFxrZyL7AbeCBr1qs4zJ0nFnoaQfkf+KuQmY+KXFJ8FtiIGy4XuGU1iCcFLUJ//NJgmwGDT2cFDRdKuB54Xg5rZZsegseGa45anLzX5WecwAVx5Dc9AB6Th3OS5WY74iOl8EvO+MF1YFgenO09oD1LpGS/E+1BT0y0Ln4dJOMJUSsAuN5kCJ+fLL1qMmSDDx2fWAXURZhgdOi9DH+qhk4Q/g=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8963808-5f82-49b8-d933-08d6ff8992dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 07:39:26.3672
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

Instead MLX5_TOTAL_VPORTS, use mlx5_eswitch_get_total_vports().
mlx5_eswitch_get_total_vports() in subsequent patch accounts for SF
vports as well.
Expanding MLX5_TOTAL_VPORTS macro would require exposing SF internals to
more generic vport.h header file. Such exposure is not desired.
Hence a mlx5_eswitch_get_total_vports() is introduced.

Given that mlx5_eswitch_get_total_vports() API wants to work on const
mlx5_core_dev*, change its helper functions also to accept const *dev.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/ib_rep.c           |  2 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  4 ++-
 .../mellanox/mlx5/core/eswitch_offloads.c     |  2 +-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 26 +++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/vport.c   | 15 +++++++++++
 include/linux/mlx5/driver.h                   |  9 ++++---
 include/linux/mlx5/eswitch.h                  |  3 +++
 include/linux/mlx5/vport.h                    |  3 ---
 8 files changed, 43 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/ml=
x5/ib_rep.c
index 3065c5d0ee96..f2cb789d2331 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -29,7 +29,7 @@ mlx5_ib_set_vport_rep(struct mlx5_core_dev *dev, struct m=
lx5_eswitch_rep *rep)
 static int
 mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep =
*rep)
 {
-	int num_ports =3D MLX5_TOTAL_VPORTS(dev);
+	int num_ports =3D mlx5_eswitch_get_total_vports(dev);
 	const struct mlx5_ib_profile *profile;
 	struct mlx5_ib_dev *ibdev;
 	int vport_index;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 89f52370e770..9137a8390216 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1868,14 +1868,16 @@ void mlx5_eswitch_disable(struct mlx5_eswitch *esw)
=20
 int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 {
-	int total_vports =3D MLX5_TOTAL_VPORTS(dev);
 	struct mlx5_eswitch *esw;
 	struct mlx5_vport *vport;
+	int total_vports;
 	int err, i;
=20
 	if (!MLX5_VPORT_MANAGER(dev))
 		return 0;
=20
+	total_vports =3D mlx5_eswitch_get_total_vports(dev);
+
 	esw_info(dev,
 		 "Total vports %d, per vport: max uc(%d) max mc(%d)\n",
 		 total_vports,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 50e5841c1698..5c8fb2597bfa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1394,7 +1394,7 @@ void esw_offloads_cleanup_reps(struct mlx5_eswitch *e=
sw)
=20
 int esw_offloads_init_reps(struct mlx5_eswitch *esw)
 {
-	int total_vports =3D MLX5_TOTAL_VPORTS(esw->dev);
+	int total_vports =3D esw->total_vports;
 	struct mlx5_core_dev *dev =3D esw->dev;
 	struct mlx5_eswitch_rep *rep;
 	u8 hw_id[ETH_ALEN], rep_type;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.c
index 9f5544ac6b8a..8162252585ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2090,7 +2090,7 @@ struct mlx5_flow_namespace *mlx5_get_flow_vport_acl_n=
amespace(struct mlx5_core_d
 {
 	struct mlx5_flow_steering *steering =3D dev->priv.steering;
=20
-	if (!steering || vport >=3D MLX5_TOTAL_VPORTS(dev))
+	if (!steering || vport >=3D mlx5_eswitch_get_total_vports(dev))
 		return NULL;
=20
 	switch (type) {
@@ -2421,7 +2421,7 @@ static void cleanup_egress_acls_root_ns(struct mlx5_c=
ore_dev *dev)
 	if (!steering->esw_egress_root_ns)
 		return;
=20
-	for (i =3D 0; i < MLX5_TOTAL_VPORTS(dev); i++)
+	for (i =3D 0; i < mlx5_eswitch_get_total_vports(dev); i++)
 		cleanup_root_ns(steering->esw_egress_root_ns[i]);
=20
 	kfree(steering->esw_egress_root_ns);
@@ -2435,7 +2435,7 @@ static void cleanup_ingress_acls_root_ns(struct mlx5_=
core_dev *dev)
 	if (!steering->esw_ingress_root_ns)
 		return;
=20
-	for (i =3D 0; i < MLX5_TOTAL_VPORTS(dev); i++)
+	for (i =3D 0; i < mlx5_eswitch_get_total_vports(dev); i++)
 		cleanup_root_ns(steering->esw_ingress_root_ns[i]);
=20
 	kfree(steering->esw_ingress_root_ns);
@@ -2614,16 +2614,18 @@ static int init_ingress_acl_root_ns(struct mlx5_flo=
w_steering *steering, int vpo
 static int init_egress_acls_root_ns(struct mlx5_core_dev *dev)
 {
 	struct mlx5_flow_steering *steering =3D dev->priv.steering;
+	int total_vports =3D mlx5_eswitch_get_total_vports(dev);
 	int err;
 	int i;
=20
-	steering->esw_egress_root_ns =3D kcalloc(MLX5_TOTAL_VPORTS(dev),
-					       sizeof(*steering->esw_egress_root_ns),
-					       GFP_KERNEL);
+	steering->esw_egress_root_ns =3D
+			kcalloc(total_vports,
+				sizeof(*steering->esw_egress_root_ns),
+				GFP_KERNEL);
 	if (!steering->esw_egress_root_ns)
 		return -ENOMEM;
=20
-	for (i =3D 0; i < MLX5_TOTAL_VPORTS(dev); i++) {
+	for (i =3D 0; i < total_vports; i++) {
 		err =3D init_egress_acl_root_ns(steering, i);
 		if (err)
 			goto cleanup_root_ns;
@@ -2641,16 +2643,18 @@ static int init_egress_acls_root_ns(struct mlx5_cor=
e_dev *dev)
 static int init_ingress_acls_root_ns(struct mlx5_core_dev *dev)
 {
 	struct mlx5_flow_steering *steering =3D dev->priv.steering;
+	int total_vports =3D mlx5_eswitch_get_total_vports(dev);
 	int err;
 	int i;
=20
-	steering->esw_ingress_root_ns =3D kcalloc(MLX5_TOTAL_VPORTS(dev),
-						sizeof(*steering->esw_ingress_root_ns),
-						GFP_KERNEL);
+	steering->esw_ingress_root_ns =3D
+			kcalloc(total_vports,
+				sizeof(*steering->esw_ingress_root_ns),
+				GFP_KERNEL);
 	if (!steering->esw_ingress_root_ns)
 		return -ENOMEM;
=20
-	for (i =3D 0; i < MLX5_TOTAL_VPORTS(dev); i++) {
+	for (i =3D 0; i < total_vports; i++) {
 		err =3D init_ingress_acl_root_ns(steering, i);
 		if (err)
 			goto cleanup_root_ns;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/=
ethernet/mellanox/mlx5/core/vport.c
index 670fa493c5f5..c912d82ca64b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -34,6 +34,7 @@
 #include <linux/etherdevice.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/vport.h>
+#include <linux/mlx5/eswitch.h>
 #include "mlx5_core.h"
=20
 /* Mutex to hold while enabling or disabling RoCE */
@@ -1165,3 +1166,17 @@ u64 mlx5_query_nic_system_image_guid(struct mlx5_cor=
e_dev *mdev)
 	return tmp;
 }
 EXPORT_SYMBOL_GPL(mlx5_query_nic_system_image_guid);
+
+/**
+ * mlx5_eswitch_get_total_vports - Get total vports of the eswitch
+ *
+ * @dev:	Pointer to core device
+ *
+ * mlx5_eswitch_get_total_vports returns total number of vports for
+ * the eswitch.
+ */
+u16 mlx5_eswitch_get_total_vports(const struct mlx5_core_dev *dev)
+{
+	return MLX5_SPECIAL_VPORTS(dev) + mlx5_core_max_vfs(dev);
+}
+EXPORT_SYMBOL(mlx5_eswitch_get_total_vports);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 7658a4908431..2c3e8d86e12d 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1083,7 +1083,7 @@ enum {
 	MLX5_PCI_DEV_IS_VF		=3D 1 << 0,
 };
=20
-static inline bool mlx5_core_is_pf(struct mlx5_core_dev *dev)
+static inline bool mlx5_core_is_pf(const struct mlx5_core_dev *dev)
 {
 	return dev->coredev_type =3D=3D MLX5_COREDEV_PF;
 }
@@ -1093,17 +1093,18 @@ static inline bool mlx5_core_is_ecpf(struct mlx5_co=
re_dev *dev)
 	return dev->caps.embedded_cpu;
 }
=20
-static inline bool mlx5_core_is_ecpf_esw_manager(struct mlx5_core_dev *dev=
)
+static inline bool
+mlx5_core_is_ecpf_esw_manager(const struct mlx5_core_dev *dev)
 {
 	return dev->caps.embedded_cpu && MLX5_CAP_GEN(dev, eswitch_manager);
 }
=20
-static inline bool mlx5_ecpf_vport_exists(struct mlx5_core_dev *dev)
+static inline bool mlx5_ecpf_vport_exists(const struct mlx5_core_dev *dev)
 {
 	return mlx5_core_is_pf(dev) && MLX5_CAP_ESW(dev, ecpf_vport_exists);
 }
=20
-static inline u16 mlx5_core_max_vfs(struct mlx5_core_dev *dev)
+static inline u16 mlx5_core_max_vfs(const struct mlx5_core_dev *dev)
 {
 	return dev->priv.sriov.max_vfs;
 }
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index d4731199edb4..61db37aa9642 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -66,6 +66,8 @@ struct mlx5_flow_handle *
 mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *esw,
 				    int vport, u32 sqn);
=20
+u16 mlx5_eswitch_get_total_vports(const struct mlx5_core_dev *dev);
+
 #ifdef CONFIG_MLX5_ESWITCH
 enum devlink_eswitch_encap_mode
 mlx5_eswitch_get_encap_mode(const struct mlx5_core_dev *dev);
@@ -93,4 +95,5 @@ mlx5_eswitch_get_vport_metadata_for_match(const struct ml=
x5_eswitch *esw,
 	return 0;
 };
 #endif /* CONFIG_MLX5_ESWITCH */
+
 #endif
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index 6cbf29229749..16060fb9b5e5 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -44,9 +44,6 @@
 				   MLX5_VPORT_UPLINK_PLACEHOLDER +	\
 				   MLX5_VPORT_ECPF_PLACEHOLDER(mdev))
=20
-#define MLX5_TOTAL_VPORTS(mdev)	(MLX5_SPECIAL_VPORTS(mdev) +		\
-				 mlx5_core_max_vfs(mdev))
-
 #define MLX5_VPORT_MANAGER(mdev)					\
 	(MLX5_CAP_GEN(mdev, vport_group_manager) &&			\
 	 (MLX5_CAP_GEN(mdev, port_type) =3D=3D MLX5_CAP_PORT_TYPE_ETH) &&	\
--=20
2.21.0

