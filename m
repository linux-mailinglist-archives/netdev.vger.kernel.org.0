Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B840E7CF3
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731729AbfJ1XfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:35:15 -0400
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:40107
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729755AbfJ1XfP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 19:35:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nzzuvkHmlnQOiwcp1xcxJgqYiGlVwwPd04WQpkR7xTZxsqpvolP/i/GKFlow+OQkCBBWyK8tjBdOdwnAA5UJZXRwxa/2kNO1NZ+mjmdhX4wtXPYP16NGtaWWC0+YW/xshI3jM4ovl1+xw5K7MH89RsxkjnVYIVCdBexP97VCZcAgEWnJK9Sy76YyfX+nAXNw6thI5hnrGQ7za6GnP3Vjy3H+z72eHsuf5NW3q1garWfxlB1OUBYMHgtZAGUb7/Qd2T1qVpbI5ni9nwEBCrP3ICJo4O6ezwcaOIWebOXf0CuG0n8sEMTLJ9q7ItFf7U639LNvsg3Bmj+fU/+ZU1sh2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KbiEEwOB8KET73RtvH3f9LLk0hEuJHEXQHAhXPP6wjI=;
 b=dtF6v81X26DSb9YZKzSGo+3zWVuO/bL8xPdNqbzKyNJ8GvqUIfSj5RpgZ+4IkTJQFJQ9emTlNo6dbRhIqz8WbnxGQhhCKj1SUQC297q6AH9Ys3Y72Cpp/LwIh2+hIbLw1rbrMi0LzGiKNjdDOq6A9dFGDL4V7OdQJ0YFnVkFVH6osOu/KUBvcpF0LoKCdVkWTKLJi2YOn+zzfNlieHtnQqb5EbpE9Q6FbiHIKqG4FNzz4yDNbAdqVD3bMNtl8ADu9a95dOgVZ2zREqxcyZXjBr/1u8ZSPDtZfJw+i5F8h7vyhYgKJUMT+s08jjcnXAszoHDiCrLCGJZCQYugNgVmog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KbiEEwOB8KET73RtvH3f9LLk0hEuJHEXQHAhXPP6wjI=;
 b=bTsMP0+8+Sgo20a7ixA6DyZOxBv/WhqDRqG5lQn8KZ3c0eAOC9vOJX22UiCFwwYgCI/HsS3dyhstF/rdnL1ZW1xg9mcuSwYfrc3SskpgaA28Uho29jTB8RaEVODHC8hr0g5jf868vt546+FZby5idh8wXYhD4ToxfsIG27Bf88g=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6448.eurprd05.prod.outlook.com (20.179.28.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Mon, 28 Oct 2019 23:35:05 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Mon, 28 Oct 2019
 23:35:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>
Subject: [PATCH mlx5-next 05/18] net/mlx5: Introduce and use
 mlx5_esw_is_manager_vport()
Thread-Topic: [PATCH mlx5-next 05/18] net/mlx5: Introduce and use
 mlx5_esw_is_manager_vport()
Thread-Index: AQHVjehTWE2/McoxT0WL6pf/hvBG2w==
Date:   Mon, 28 Oct 2019 23:35:05 +0000
Message-ID: <20191028233440.5564-6-saeedm@mellanox.com>
References: <20191028233440.5564-1-saeedm@mellanox.com>
In-Reply-To: <20191028233440.5564-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:a03:180::34) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b0e0233b-3e7a-4892-f3c4-08d75bff761b
x-ms-traffictypediagnostic: VI1PR05MB6448:|VI1PR05MB6448:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6448957307BFD8F099E2DC68BE660@VI1PR05MB6448.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0204F0BDE2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(189003)(199004)(3846002)(305945005)(8936002)(450100002)(316002)(478600001)(50226002)(86362001)(99286004)(71200400001)(81156014)(8676002)(81166006)(107886003)(71190400001)(186003)(66446008)(386003)(102836004)(6636002)(6506007)(14444005)(66476007)(66946007)(256004)(36756003)(52116002)(476003)(2616005)(11346002)(486006)(446003)(64756008)(6512007)(76176011)(6116002)(4326008)(26005)(7736002)(5660300002)(66066001)(14454004)(2906002)(110136005)(6436002)(6486002)(54906003)(1076003)(25786009)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6448;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7YDtxNyFnk5XZu2C3dEd/cBDlBJ4IhYNlBxzHUMfj/yoweJ9+GpCytK3+gjyBWH54/SlK1K9kF1U0oA0y3r1vKk9ZiqJTblhe+M0FuljcZleaM2fgFL58sFVJkuv+xhnXmvH2R+pGEylxT4yv6UC59AXtUJGPAxmw7KlRAbU7cPe3Y3d43wp6RoCCLWPbEF/Laoy2U/5P0YTkqRE4L/Cp0HIzA2g8V9MCpR2+exrdcPY6t5onDylsMhCN1A9nHAbPDqdWUj0VSURp8F2M99A6SSUFWPo4imPb1w0jiWUzw3TcR1g+u61084mtGg+EXeHnVWDrNcGHj0n41dmaKFSW4oW3EYgW1x1woToZa4GeGmH6FUru7xB6VLGk1Jj9zEhs2vRXwDlWgZ6fQi2zgpXkd0rFnVMLMsDhCch8tYkCCDX8S9GJ2TLlOpu/ojI7ID8
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0e0233b-3e7a-4892-f3c4-08d75bff761b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2019 23:35:05.4584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MljbMK+t3gNVRNMXKGgKgAafALL0Vt4rbZahbLXK7Xx2TCJYTivmVI6rbI7bfM5T2yO6ocxcYStU1yXRQpEe5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6448
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Currently esw_enable_vport() does vport check for zero to enable drop
counters regardless of execution on ECPF/PF.
While esw_disable_vport() considers such scenario.

To keep consistency across code for checking for manager_vport,
introduce and use mlx5_esw_is_manager_vport() to check if a specified
vport is eswitch manager vport or not.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 13 +++++++------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h |  6 ++++++
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index ef7d84a1dbc2..fa1228a8005f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -501,7 +501,7 @@ static int esw_add_uc_addr(struct mlx5_eswitch *esw, st=
ruct vport_addr *vaddr)
 	/* Skip mlx5_mpfs_add_mac for eswitch_managers,
 	 * it is already done by its netdev in mlx5e_execute_l2_action
 	 */
-	if (esw->manager_vport =3D=3D vport)
+	if (mlx5_esw_is_manager_vport(esw, vport))
 		goto fdb_add;
=20
 	err =3D mlx5_mpfs_add_mac(esw->dev, mac);
@@ -533,7 +533,7 @@ static int esw_del_uc_addr(struct mlx5_eswitch *esw, st=
ruct vport_addr *vaddr)
 	/* Skip mlx5_mpfs_del_mac for eswitch managers,
 	 * it is already done by its netdev in mlx5e_execute_l2_action
 	 */
-	if (!vaddr->mpfs || esw->manager_vport =3D=3D vport)
+	if (!vaddr->mpfs || mlx5_esw_is_manager_vport(esw, vport))
 		goto fdb_del;
=20
 	err =3D mlx5_mpfs_del_mac(esw->dev, mac);
@@ -1639,7 +1639,7 @@ static void esw_apply_vport_conf(struct mlx5_eswitch =
*esw,
 	u16 vport_num =3D vport->vport;
 	int flags;
=20
-	if (esw->manager_vport =3D=3D vport_num)
+	if (mlx5_esw_is_manager_vport(esw, vport_num))
 		return;
=20
 	mlx5_modify_vport_admin_state(esw->dev,
@@ -1713,7 +1713,8 @@ static void esw_enable_vport(struct mlx5_eswitch *esw=
, struct mlx5_vport *vport,
 	esw_debug(esw->dev, "Enabling VPORT(%d)\n", vport_num);
=20
 	/* Create steering drop counters for ingress and egress ACLs */
-	if (vport_num && esw->mode =3D=3D MLX5_ESWITCH_LEGACY)
+	if (!mlx5_esw_is_manager_vport(esw, vport_num) &&
+	    esw->mode =3D=3D MLX5_ESWITCH_LEGACY)
 		esw_vport_create_drop_counters(vport);
=20
 	/* Restore old vport configuration */
@@ -1731,7 +1732,7 @@ static void esw_enable_vport(struct mlx5_eswitch *esw=
, struct mlx5_vport *vport,
 	/* Esw manager is trusted by default. Host PF (vport 0) is trusted as wel=
l
 	 * in smartNIC as it's a vport group manager.
 	 */
-	if (esw->manager_vport =3D=3D vport_num ||
+	if (mlx5_esw_is_manager_vport(esw, vport_num) ||
 	    (!vport_num && mlx5_core_is_ecpf(esw->dev)))
 		vport->info.trusted =3D true;
=20
@@ -1766,7 +1767,7 @@ static void esw_disable_vport(struct mlx5_eswitch *es=
w,
 	esw_vport_change_handle_locked(vport);
 	vport->enabled_events =3D 0;
 	esw_vport_disable_qos(esw, vport);
-	if (esw->manager_vport !=3D vport_num &&
+	if (!mlx5_esw_is_manager_vport(esw, vport_num) &&
 	    esw->mode =3D=3D MLX5_ESWITCH_LEGACY) {
 		mlx5_modify_vport_admin_state(esw->dev,
 					      MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index 1824b0ad7c9f..75e69644d70e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -463,6 +463,12 @@ static inline u16 mlx5_eswitch_manager_vport(struct ml=
x5_core_dev *dev)
 		MLX5_VPORT_ECPF : MLX5_VPORT_PF;
 }
=20
+static inline bool
+mlx5_esw_is_manager_vport(const struct mlx5_eswitch *esw, u16 vport_num)
+{
+	return esw->manager_vport =3D=3D vport_num;
+}
+
 static inline u16 mlx5_eswitch_first_host_vport_num(struct mlx5_core_dev *=
dev)
 {
 	return mlx5_core_is_ecpf_esw_manager(dev) ?
--=20
2.21.0

