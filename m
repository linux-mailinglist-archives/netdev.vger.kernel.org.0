Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3421988582
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729571AbfHIWEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:04:49 -0400
Received: from mail-eopbgr60050.outbound.protection.outlook.com ([40.107.6.50]:49633
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729237AbfHIWEs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 18:04:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qy+N1gere85C4xVdUSiDd9IzajKtHQm4GdbzNssYLkSsyV5mEPNwgfVk5vq55EPO0KiJ1xtyr8vVxhtBM7EGQ4YVvrUzIldcYjK7h0Phs87EcazDyYAJdmNoddpeQxcrgrVThShRkwMvmWpwEyh7NNxMAltUSlqs4VpNV813CsUaxS3OYz2dkNZNCfwLnwzz1IWuyfCaRHzARcXInz5epjSPapMMctbe9uYkKqzJSOTPMTEx5fZaDEz4u3uckru1XC3DfFTu/a8JUxdKFv80y7yFK1nTk1ldX9IpcbxoM4JzWgJTTNeze3KFLcAazYfJjypiBbYSfm9fRVbHfvh4AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HqaACNKMd5mSgq8sKoeJntzX+TxYA0edCUSXvGTgi6U=;
 b=NqlnHiN4n8mVpzcFmt6MaKsyi+lCyR8bG5kx2kQAce9l5WCG5I+3w6IRHgJxJFc4LzUzkTioZ/tfK0vRG3YCtuvj4af8icrCZ+6SRx/jsYyXWAR/H+hvZNA/HdQPCrOumxn69J1GtAuC+/5khxLEglMyPEIWtvzG2LRLUJ+MvKOCcYbFKRtlxOlpkTCZD1ot92tXsOIVC826UwQDJ1RC46OESAlolnx3D6QvUbTEOZ3Rf+PdYUkJE6cxtzUzNH3+3+a2tDaYcY1Vnlzq2Topa98EIxfCSqVo9fgglGjT9Fdi6UzNAox6OjHfbbWD9A/bpuIz9CRbCM635fQdxdxG5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HqaACNKMd5mSgq8sKoeJntzX+TxYA0edCUSXvGTgi6U=;
 b=pwR+c+dXkZy04urBXYDnW3p7JEAt+JL6+cvhwYGDnJrnvye0+IcyFX5i4tzdM8Ilkv+gs8Je5RGGz+TGbCBORxbyqOgiNOljFXy2XyUFdUC5Ub9zUW0naWHy7fPcpvFgyr9M+n6hGJh27RQxyyagZsGO9r9gHFGISzVM5qCayTc=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2856.eurprd05.prod.outlook.com (10.172.225.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Fri, 9 Aug 2019 22:04:32 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 22:04:32 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/15] net/mlx5e: Allow concurrent creation of mod_hdr
 entries
Thread-Topic: [net-next 08/15] net/mlx5e: Allow concurrent creation of mod_hdr
 entries
Thread-Index: AQHVTv5sgZWR5zX8TEqslfCzWfxTLQ==
Date:   Fri, 9 Aug 2019 22:04:32 +0000
Message-ID: <20190809220359.11516-9-saeedm@mellanox.com>
References: <20190809220359.11516-1-saeedm@mellanox.com>
In-Reply-To: <20190809220359.11516-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0d58bfed-0ecf-49ea-3026-08d71d158ed3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2856;
x-ms-traffictypediagnostic: DB6PR0501MB2856:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB28566F3433AD282B38F51788BED60@DB6PR0501MB2856.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(199004)(189003)(2616005)(446003)(316002)(14444005)(256004)(5024004)(64756008)(54906003)(1076003)(476003)(26005)(6512007)(478600001)(186003)(486006)(36756003)(66066001)(6916009)(8936002)(6486002)(8676002)(81166006)(14454004)(71190400001)(50226002)(81156014)(71200400001)(66556008)(66476007)(5660300002)(66946007)(66446008)(52116002)(6436002)(11346002)(102836004)(99286004)(3846002)(107886003)(6116002)(4326008)(86362001)(386003)(7736002)(25786009)(2906002)(76176011)(305945005)(53936002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2856;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zEEK9tV1fcawCibJoG/6P1WFJfgtCA4BfXQhC0WbEjkX96l/qxP1ijTlw3z9/dEq1HslHsdqAbrFttf+agIKUdDL6nkDiVGLfJC2Dv3o463XGe9nFAFG/iaL8gXEjm5k12AoMoro0n/yS8Y4N+gGqr3HppuHlnSuECe0yh6tGclfKBrjI3Qxbdr/lTFxIV8isN/yB2zSXhmTzKeD2wfOqcG2ullUVJyTZ0mD8/6TQKRl5ExFqU2eflFP8AGh+a4zk7qzxa/QyWiC4gRwuFrgHYvucMAIJISeTns14bQtar+THY/dAKou0UO6RZLNhrw8//qbELSpE33IF1ZjfPZPwcAx0sdjfWSWGVLD9MMiOqkQHjJiOui9hhZmBpJrFWqgJ28CAZto3HKzORrBAxggT5qmR52bEAV9H+wmKLPubXY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d58bfed-0ecf-49ea-3026-08d71d158ed3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 22:04:32.6637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d70zTnXvyvapnIFbkoG7ZB/JtypFviH785oE++77VZws9sFZ9QW+fudseoJ5E6RTEhtDZxMR7mFZ48yb+eYSaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2856
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

Mod_hdr entries creation is fully synchronized by mod_hdr_tbl->lock. In
order to allow concurrent allocation of hardware resources used to offload
header rewrite, extend mlx5e_mod_hdr_entry with 'res_ready' completion.
Move call to mlx5_modify_header_alloc() out of mod_hdr_tbl->lock critical
section. Modify code that attaches new flows to existing mh to wait for
'res_ready' completion before using the entry. Insert mh to mod_hdr table
before provisioning it to hardware and modify all users of mod_hdr table to
verify that mh was fully initialized by checking completion result for
negative value (and to wait for 'res_ready' completion, if necessary).

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 41 +++++++++++++------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 0600b7878600..fcaf9ab9e373 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -199,6 +199,8 @@ struct mlx5e_mod_hdr_entry {
 	u32 mod_hdr_id;
=20
 	refcount_t refcnt;
+	struct completion res_ready;
+	int compl_result;
 };
=20
 #define MLX5_MH_ACT_SZ MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto)
@@ -326,7 +328,8 @@ static void mlx5e_mod_hdr_put(struct mlx5e_priv *priv,
 	mutex_unlock(&tbl->lock);
=20
 	WARN_ON(!list_empty(&mh->flows));
-	mlx5_modify_header_dealloc(priv->mdev, mh->mod_hdr_id);
+	if (mh->compl_result > 0)
+		mlx5_modify_header_dealloc(priv->mdev, mh->mod_hdr_id);
=20
 	kfree(mh);
 }
@@ -359,13 +362,21 @@ static int mlx5e_attach_mod_hdr(struct mlx5e_priv *pr=
iv,
=20
 	mutex_lock(&tbl->lock);
 	mh =3D mlx5e_mod_hdr_get(tbl, &key, hash_key);
-	if (mh)
+	if (mh) {
+		mutex_unlock(&tbl->lock);
+		wait_for_completion(&mh->res_ready);
+
+		if (mh->compl_result < 0) {
+			err =3D -EREMOTEIO;
+			goto attach_header_err;
+		}
 		goto attach_flow;
+	}
=20
 	mh =3D kzalloc(sizeof(*mh) + actions_size, GFP_KERNEL);
 	if (!mh) {
-		err =3D -ENOMEM;
-		goto out_err;
+		mutex_unlock(&tbl->lock);
+		return -ENOMEM;
 	}
=20
 	mh->key.actions =3D (void *)mh + sizeof(*mh);
@@ -374,18 +385,23 @@ static int mlx5e_attach_mod_hdr(struct mlx5e_priv *pr=
iv,
 	spin_lock_init(&mh->flows_lock);
 	INIT_LIST_HEAD(&mh->flows);
 	refcount_set(&mh->refcnt, 1);
+	init_completion(&mh->res_ready);
+
+	hash_add(tbl->hlist, &mh->mod_hdr_hlist, hash_key);
+	mutex_unlock(&tbl->lock);
=20
 	err =3D mlx5_modify_header_alloc(priv->mdev, namespace,
 				       mh->key.num_actions,
 				       mh->key.actions,
 				       &mh->mod_hdr_id);
-	if (err)
-		goto out_err;
-
-	hash_add(tbl->hlist, &mh->mod_hdr_hlist, hash_key);
+	if (err) {
+		mh->compl_result =3D err;
+		goto alloc_header_err;
+	}
+	mh->compl_result =3D 1;
+	complete_all(&mh->res_ready);
=20
 attach_flow:
-	mutex_unlock(&tbl->lock);
 	flow->mh =3D mh;
 	spin_lock(&mh->flows_lock);
 	list_add(&flow->mod_hdr, &mh->flows);
@@ -397,9 +413,10 @@ static int mlx5e_attach_mod_hdr(struct mlx5e_priv *pri=
v,
=20
 	return 0;
=20
-out_err:
-	mutex_unlock(&tbl->lock);
-	kfree(mh);
+alloc_header_err:
+	complete_all(&mh->res_ready);
+attach_header_err:
+	mlx5e_mod_hdr_put(priv, mh, namespace);
 	return err;
 }
=20
--=20
2.21.0

