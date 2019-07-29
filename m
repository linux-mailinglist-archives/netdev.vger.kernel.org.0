Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B393279D15
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 01:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729904AbfG2Xwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 19:52:33 -0400
Received: from mail-eopbgr130088.outbound.protection.outlook.com ([40.107.13.88]:24063
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729997AbfG2Xwc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 19:52:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iLBtGCP5Vt2D6FiKKZ9gbK4U7CkXOplpSqb1h1GSadqqm5S64rwYno7Fq+ML0bCkwgCqh4U3m9gLonzV7/0Om5FvKJGI2IG3+UcbeK0d+RnCSIiOm0Kx2vxiqJlF27bMZhNqkg7tdY7I15OOD2Qcfhg7F6S74bwqQ2f3qdUWA7PbGbOii+V1p1gb6Y8tqOl08fzBM1bBO0KW1qKknGZc6pZMv4VM3Z05nVxk61+xatTwUpXR3M+rP/hpytPh8CJyhHKPsDl9kkKuyW+UV0lsPAI0O4+usIcsDzhomb6DKFgbhFiocAwjuAdbLn4fv7gmGHbkDfqV4hnEeBAUBW32JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P81bLZGN3n2prdSQJHW1AX0uF4aAEto16NHAzDVRFgo=;
 b=nG5LulLMp7uSy0+ilonSCe3vB9jEpA1JMs3CQgxyIDXrouFBKUCTCfaAw2A6Gm8INwn65KFDgpnVymPxc5Y1F+EjWyy5NBxZDCe5YrTUuhcxCv6KhuLZunwxXT3EgY+4C4GbMNA1vDv7uPxJXtON5x7tzeZvwkssl+dOehQ18wTe86vTqj2UKha7WCYCJSKsa9G/PXuOHUXLR2qtX1N2iOTxOjqgJLlW9j1sRKUKvBYCrcdnm1yxhGy77ly+lIXakN49qxsZMEZfpleoGDtJXYn3pBEfdCPyoGRuc+CPFHPCHDfhYxIP8kGGXKLBPrX2UlrrfMcFj7PpL5VeDCzoJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P81bLZGN3n2prdSQJHW1AX0uF4aAEto16NHAzDVRFgo=;
 b=r2JnTtBpmOUf8FHrc8UuZoeIaXSThvC+Dsk3w7l5JymBN8cKq53a9uZuH0FR/chv7zoXSQQHWEPeXX6h9f7oh/n3z6r8HSbv4Qcq38RmAJZQFl/89y5gADHyvHAgZwtYVgDfAk3GTWsITgevZ4Bb00yYAPcEpwtA+KthxrZPpJk=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2343.eurprd05.prod.outlook.com (10.168.56.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 23:50:33 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 23:50:33 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/13] net/mlx5e: Eswitch, use state_lock to synchronize
 vlan change
Thread-Topic: [net-next 11/13] net/mlx5e: Eswitch, use state_lock to
 synchronize vlan change
Thread-Index: AQHVRmhp+MbVDf0udku6Gm5rhu7iQQ==
Date:   Mon, 29 Jul 2019 23:50:33 +0000
Message-ID: <20190729234934.23595-12-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: cb37ff2c-73ba-4e4d-e46e-08d7147f8b7c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2343;
x-ms-traffictypediagnostic: DB6PR0501MB2343:
x-microsoft-antispam-prvs: <DB6PR0501MB2343A5F875505DA76D3862C6BEDD0@DB6PR0501MB2343.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1107;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(199004)(189003)(14454004)(25786009)(71190400001)(71200400001)(386003)(6506007)(6512007)(81166006)(81156014)(76176011)(8936002)(6436002)(8676002)(6486002)(316002)(102836004)(54906003)(6916009)(7736002)(478600001)(52116002)(186003)(26005)(99286004)(14444005)(256004)(476003)(5660300002)(1076003)(66446008)(66066001)(66556008)(66476007)(64756008)(36756003)(53936002)(486006)(86362001)(305945005)(107886003)(66946007)(68736007)(446003)(2616005)(11346002)(50226002)(6116002)(3846002)(4326008)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2343;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jk3YH4lopAkw5Yb60E2g3rumantkTvmCSz0FeqG4ZoKy5/PAJOT8Wj+cXKzJP8OmfnBrbL4x0VBRMm/ibI0bN3JGX89mB9Bb5a0eSiaJWdJECP7Y+t0L0RbJ1A0KHV9CjHNmntBVaFsZ3RC8ChTegveyQ18sMwe2DdRBJ6udFcKFGBRN88RhB4BkQVAng5wmi7yNJ4JwIck8hNhbYCakTco/RHe03B9KR09PZmf68Q+n1bw3Mn0MrRKKN4QpgRZg9FcfzkOq0sbi5+SShZnYra1JRgwy7j5bsAAC4p4EbglHHRIOtoeUBml94g2lZKmfrcrvmoCspQ1KiAfjAq46htLWUo5TlFFu9B034fu6HEmXBbmvf/tSHReED6z25Q6GEpe3o2s5X/zLdSAH7V8x7DHg1NO7XwrzfwtRuNkLmQA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb37ff2c-73ba-4e4d-e46e-08d7147f8b7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 23:50:33.1963
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

From: Vlad Buslov <vladbu@mellanox.com>

esw->state_lock is already used to protect vlan vport configuration change.
However, all preparation and correctness checks, and code that sets vport
data are not protected by this lock and assume external synchronization by
rtnl lock. In order to remove dependency on rtnl lock, extend
esw->state_lock protection to whole eswitch vlan add/del functions.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c   | 15 ++++++++-------
 .../mellanox/mlx5/core/eswitch_offloads.c       | 17 ++++++++++++-----
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index d365551d2f10..7a0888470fae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2086,23 +2086,19 @@ int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswit=
ch *esw,
 	if (vlan > 4095 || qos > 7)
 		return -EINVAL;
=20
-	mutex_lock(&esw->state_lock);
-
 	err =3D modify_esw_vport_cvlan(esw->dev, vport, vlan, qos, set_flags);
 	if (err)
-		goto unlock;
+		return err;
=20
 	evport->info.vlan =3D vlan;
 	evport->info.qos =3D qos;
 	if (evport->enabled && esw->mode =3D=3D MLX5_ESWITCH_LEGACY) {
 		err =3D esw_vport_ingress_config(esw, evport);
 		if (err)
-			goto unlock;
+			return err;
 		err =3D esw_vport_egress_config(esw, evport);
 	}
=20
-unlock:
-	mutex_unlock(&esw->state_lock);
 	return err;
 }
=20
@@ -2110,11 +2106,16 @@ int mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch=
 *esw,
 				u16 vport, u16 vlan, u8 qos)
 {
 	u8 set_flags =3D 0;
+	int err;
=20
 	if (vlan || qos)
 		set_flags =3D SET_VLAN_STRIP | SET_VLAN_INSERT;
=20
-	return __mlx5_eswitch_set_vport_vlan(esw, vport, vlan, qos, set_flags);
+	mutex_lock(&esw->state_lock);
+	err =3D __mlx5_eswitch_set_vport_vlan(esw, vport, vlan, qos, set_flags);
+	mutex_unlock(&esw->state_lock);
+
+	return err;
 }
=20
 int mlx5_eswitch_set_vport_spoofchk(struct mlx5_eswitch *esw,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 244ad1893691..d502c91c148c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -442,9 +442,11 @@ int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *=
esw,
 	fwd  =3D !!((attr->action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) &&
 		   !attr->dest_chain);
=20
+	mutex_lock(&esw->state_lock);
+
 	err =3D esw_add_vlan_action_check(attr, push, pop, fwd);
 	if (err)
-		return err;
+		goto unlock;
=20
 	attr->vlan_handled =3D false;
=20
@@ -457,11 +459,11 @@ int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch =
*esw,
 			attr->vlan_handled =3D true;
 		}
=20
-		return 0;
+		goto unlock;
 	}
=20
 	if (!push && !pop)
-		return 0;
+		goto unlock;
=20
 	if (!(offloads->vlan_push_pop_refcount)) {
 		/* it's the 1st vlan rule, apply global vlan pop policy */
@@ -486,6 +488,8 @@ int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *e=
sw,
 out:
 	if (!err)
 		attr->vlan_handled =3D true;
+unlock:
+	mutex_unlock(&esw->state_lock);
 	return err;
 }
=20
@@ -508,6 +512,8 @@ int mlx5_eswitch_del_vlan_action(struct mlx5_eswitch *e=
sw,
 	pop  =3D !!(attr->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP);
 	fwd  =3D !!(attr->action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST);
=20
+	mutex_lock(&esw->state_lock);
+
 	vport =3D esw_vlan_action_get_vport(attr, push, pop);
=20
 	if (!push && !pop && fwd) {
@@ -515,7 +521,7 @@ int mlx5_eswitch_del_vlan_action(struct mlx5_eswitch *e=
sw,
 		if (attr->dests[0].rep->vport =3D=3D MLX5_VPORT_UPLINK)
 			vport->vlan_refcount--;
=20
-		return 0;
+		goto out;
 	}
=20
 	if (push) {
@@ -533,12 +539,13 @@ int mlx5_eswitch_del_vlan_action(struct mlx5_eswitch =
*esw,
 skip_unset_push:
 	offloads->vlan_push_pop_refcount--;
 	if (offloads->vlan_push_pop_refcount)
-		return 0;
+		goto out;
=20
 	/* no more vlan rules, stop global vlan pop policy */
 	err =3D esw_set_global_vlan_pop(esw, 0);
=20
 out:
+	mutex_unlock(&esw->state_lock);
 	return err;
 }
=20
--=20
2.21.0

