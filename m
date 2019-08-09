Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 448BF8857A
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfHIWEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:04:33 -0400
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:4427
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726053AbfHIWEc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 18:04:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=af+sfBU5f8tswE4WN7f1NARj8I1BgHdYYWxQljsryWwKQJqcRZ7bvEW5TfWOsE+1ePhwj3mjfsI3XkbKMGOSP2czZU0bdoBAkEIfBV4HmqNyKRtK4WJ8OmV9ParANophwModywsUjWg7xb5BHEVykna4hAbrhTeXGk3oxWwXwB+q8TIr8jnEXVbpV0qRzhvAbwmvqvi8HNnr2nVjjCJxWixcrM5ouqWbms3RS1wV7bxwetb3DwHKrQKIzFOwqoSVLcWk75NgS47Z1JjH4jb3P0my+wYrCgr4wQEdAAp0eD1Acce6+Xq/0/EVQQgh8URyf74+n3W9s0fDf3JuWozZHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+OacEPXRvy8nER5gRPmDvESH+xoGLGBLOSOhDQeFaE8=;
 b=e4ikaMWf5q4m7mM8lh2V9SsxN+xZfAgdXvSyu49ed2cNF8aKVq/7cyTvOA22+HC4GYK3QU0SejsZvvE9RbUVJy79lKVRK6zGuBe31CaSDHOoVtrlBzIO+e97beVV/Q4GA5GOoQIot3xiOsY2f85ieeysCtwK8zkOYzlgmopCcW791bN9NcoDCU9qkJxnaePS1GnMWSPzDOKMF4YrthLXP7oRGq6mBCylXIFajJXIdlxSZpG5Y5IJak7+53lfG3mi3QBkoQSD+yAs4l7woOYSoQLNEsx9BBvhRDTmjL8ku9IyHudXUDd6XQNQmplNu2KamSfdE9QUEkNVr+ovjsKx0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+OacEPXRvy8nER5gRPmDvESH+xoGLGBLOSOhDQeFaE8=;
 b=pO/fQ97087IIr/tKtHfdPWvT13KfPn6LXmPV7inswnoU4eNiJ1BWtSbIwqXbbDIiX8+TlJvZxIJ29+0KeDu0aFcZjdAY1Wrjyq2daIm3aiE6IhGPvxa9LnY4Oz4YYE/lk/qeiu2ogX+GSH+vQzW1G/DVtrO+vZmXAJIefjI+by8=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2856.eurprd05.prod.outlook.com (10.172.225.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Fri, 9 Aug 2019 22:04:19 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 22:04:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/15] net/mlx5e: Extend hairpin entry with reference
 counter
Thread-Topic: [net-next 01/15] net/mlx5e: Extend hairpin entry with reference
 counter
Thread-Index: AQHVTv5kzFgwr81un0WOHCXwGpMOnA==
Date:   Fri, 9 Aug 2019 22:04:19 +0000
Message-ID: <20190809220359.11516-2-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: a98171a7-c237-4e99-f9ad-08d71d15871a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2856;
x-ms-traffictypediagnostic: DB6PR0501MB2856:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2856DBEC7CEC04032B7953ACBED60@DB6PR0501MB2856.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:272;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(199004)(189003)(2616005)(446003)(316002)(14444005)(256004)(5024004)(64756008)(54906003)(1076003)(476003)(26005)(6512007)(478600001)(186003)(486006)(36756003)(66066001)(6916009)(8936002)(6486002)(8676002)(81166006)(14454004)(71190400001)(50226002)(81156014)(71200400001)(66556008)(66476007)(5660300002)(66946007)(66446008)(52116002)(6436002)(11346002)(102836004)(99286004)(3846002)(107886003)(6116002)(4326008)(86362001)(386003)(7736002)(25786009)(2906002)(76176011)(305945005)(53936002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2856;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hfzZhu8/SoXhNW0fGkOhPZKchbO+vh6QB4EW0RxC4TUcp41JXuUPX/mjqluBm72jzjh8PChVqTjx8kCYiXzkTMsgRyCj64EsemrqujpjTSnrSfDvprsE/OdA4xkXI7TDAM3CN6eKJKSXqZ/lpcxQZMtqdCQVFVK9dCQKe1U6Wp1rW8McmDQ3yMWi1bi4HE9P6+UVKrCy6i6YSFMJCP2uNeJN5D2fS8f+fyuKfpM0puISuYZX/NMPuQqTPl5v0VHiCteYrT488nd6dinswfmzW8Ck9l2pAPW955JyZJuetR1BoGK03BWLn6noyn0/GCM+ysvN58SuK8KmwmAN5HbD+bB1WVidwpWYNUYGI8lg2zFgkI7cVTX4A9CDUxmT+H/IU2VAOY2pg+yKkHiICA7Q0o2UF9cKl8f7T9AqfExLNzw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a98171a7-c237-4e99-f9ad-08d71d15871a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 22:04:19.7264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fzoXdrYQayYjgZyrdAHFYmDqRerjb+qs1YdvBl75CBdY8D+Rvx3mQsuoox2JXPwXAZSByhtHqkzoXK6qhstxgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2856
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

List of flows attached to hairpin entry is used as implicit reference
counter (hairpin entry is deallocated when list becomes free) and as a
mechanism to obtain hairpin entry that flow is attached to (through list
head). This is not safe when concurrent modification of list of flows
attached to hairpin entry is possible. Proper atomic reference counter is
required to support concurrent access.

As a preparation for extending hairpin with reference counting, extract
code that deletes hairpin entry into standalone function. In order to
remove this dependency on external locking, extend hairpin entry with
reference counter to manage its lifetime and extend flow structure with
direct pointer to hairpin entry that flow is attached to.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 44 +++++++++++--------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 4d97cc47835f..64ce762ec1e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -119,6 +119,7 @@ struct mlx5e_tc_flow {
 	struct encap_flow_item encaps[MLX5_MAX_FLOW_FWD_VPORTS];
 	struct mlx5e_tc_flow    *peer_flow;
 	struct list_head	mod_hdr; /* flows sharing the same mod hdr ID */
+	struct mlx5e_hairpin_entry *hpe; /* attached hairpin instance */
 	struct list_head	hairpin; /* flows sharing the same hairpin */
 	struct list_head	peer;    /* flows with peer flow */
 	struct list_head	unready; /* flows not ready to be offloaded (e.g due to =
missing route) */
@@ -167,6 +168,7 @@ struct mlx5e_hairpin_entry {
 	u16 peer_vhca_id;
 	u8 prio;
 	struct mlx5e_hairpin *hp;
+	refcount_t refcnt;
 };
=20
 struct mod_hdr_key {
@@ -635,13 +637,31 @@ static struct mlx5e_hairpin_entry *mlx5e_hairpin_get(=
struct mlx5e_priv *priv,
=20
 	hash_for_each_possible(priv->fs.tc.hairpin_tbl, hpe,
 			       hairpin_hlist, hash_key) {
-		if (hpe->peer_vhca_id =3D=3D peer_vhca_id && hpe->prio =3D=3D prio)
+		if (hpe->peer_vhca_id =3D=3D peer_vhca_id && hpe->prio =3D=3D prio) {
+			refcount_inc(&hpe->refcnt);
 			return hpe;
+		}
 	}
=20
 	return NULL;
 }
=20
+static void mlx5e_hairpin_put(struct mlx5e_priv *priv,
+			      struct mlx5e_hairpin_entry *hpe)
+{
+	/* no more hairpin flows for us, release the hairpin pair */
+	if (!refcount_dec_and_test(&hpe->refcnt))
+		return;
+
+	netdev_dbg(priv->netdev, "del hairpin: peer %s\n",
+		   dev_name(hpe->hp->pair->peer_mdev->device));
+
+	WARN_ON(!list_empty(&hpe->flows));
+	mlx5e_hairpin_destroy(hpe->hp);
+	hash_del(&hpe->hairpin_hlist);
+	kfree(hpe);
+}
+
 #define UNKNOWN_MATCH_PRIO 8
=20
 static int mlx5e_hairpin_get_prio(struct mlx5e_priv *priv,
@@ -718,6 +738,7 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *pr=
iv,
 	INIT_LIST_HEAD(&hpe->flows);
 	hpe->peer_vhca_id =3D peer_id;
 	hpe->prio =3D match_prio;
+	refcount_set(&hpe->refcnt, 1);
=20
 	params.log_data_size =3D 15;
 	params.log_data_size =3D min_t(u8, params.log_data_size,
@@ -760,6 +781,7 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *pr=
iv,
 	} else {
 		flow->nic_attr->hairpin_tirn =3D hpe->hp->tirn;
 	}
+	flow->hpe =3D hpe;
 	list_add(&flow->hairpin, &hpe->flows);
=20
 	return 0;
@@ -772,27 +794,13 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *=
priv,
 static void mlx5e_hairpin_flow_del(struct mlx5e_priv *priv,
 				   struct mlx5e_tc_flow *flow)
 {
-	struct list_head *next =3D flow->hairpin.next;
-
 	/* flow wasn't fully initialized */
-	if (list_empty(&flow->hairpin))
+	if (!flow->hpe)
 		return;
=20
 	list_del(&flow->hairpin);
-
-	/* no more hairpin flows for us, release the hairpin pair */
-	if (list_empty(next)) {
-		struct mlx5e_hairpin_entry *hpe;
-
-		hpe =3D list_entry(next, struct mlx5e_hairpin_entry, flows);
-
-		netdev_dbg(priv->netdev, "del hairpin: peer %s\n",
-			   dev_name(hpe->hp->pair->peer_mdev->device));
-
-		mlx5e_hairpin_destroy(hpe->hp);
-		hash_del(&hpe->hairpin_hlist);
-		kfree(hpe);
-	}
+	mlx5e_hairpin_put(priv, flow->hpe);
+	flow->hpe =3D NULL;
 }
=20
 static int
--=20
2.21.0

