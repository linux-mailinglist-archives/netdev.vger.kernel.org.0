Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3454988592
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfHIWG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:06:28 -0400
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:4427
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726053AbfHIWG2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 18:06:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BjCqjrBXBeWwBq5MPzaIzkU1pnco0/aMaK6nOvEt19x/Pm7iyZjLW6LRNLeDH4wFRQghqLb3J5gCCyhLQ+sDdaSXgzkEZRGo5pkWszUDMMyl/PRzC1CS5KGrSEzBGfK6G7dwGR8rIxQ3h69HplXy6tvTK60y4YQvijwFFo8QtnfLS+7Y1agjjdHNIeYHpqTImdauEiZA9b7zVGY5+OeHfL1MAxNX3kq787nn4o0KXp7nfEb99I984COguA57gOkYNXctewAVVl4ea1Ms96q9oqscEzdf1wzkovNxlXHAdwMeXXF/QwsBToU+a5S6dwBdPis0ZA9DvDRa9RB+qNXRHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0ohIwBuSI3I0XxpLmCH+elYbSxZycY7gzXqIyg0Uyc=;
 b=WZtipzF2lO0Efm9EhgDfnCvRxJJ3xfLX9HClZ2IJjp81pRU13w6zKf4NXcE5GZ8TD4fnnSePvDywBlJKMpFJMfE6fvRqa8Bv296qcZUhzhs/sSwn9DRKafzaktCcTJ+HiDc9eLTlrXHgwHTd7M4DytHLyMszgR8rtCWeEVeg89HV3YwoBd+4VYubjPdDuNcGyg7Chc2Ji7OtOK/ZfFgFOMTkkAHwj5gwBWaGma3uJgUL+o2fJcmuS1CVZNV7Wtjm6roLCrklW2f0I2n/h6qyjIZglo+o9dchrtRpabpsyyZmtmnHCR5FMzo9hv7W9q1Fuyz4EXkxeOaQi8cpt56dmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0ohIwBuSI3I0XxpLmCH+elYbSxZycY7gzXqIyg0Uyc=;
 b=n5kE2AvkEdAz67Y3VKXpRZwxZiUXBAPSte5pyi9JfCinigahsM3g3XNZwrZXmxOSPkpzkgj6ZQPR3XEzXxeijgdIC/2SlBhV9LjXivmvQBBDhjp0yUPloBDHHZX7VQr9j/IdgcL6ad2533erwNORGWjXthF15wbYCVMlXY5a6LM=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2856.eurprd05.prod.outlook.com (10.172.225.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Fri, 9 Aug 2019 22:04:23 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 22:04:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/15] net/mlx5e: Protect hairpin hash table with mutex
Thread-Topic: [net-next 03/15] net/mlx5e: Protect hairpin hash table with
 mutex
Thread-Index: AQHVTv5maM0hNFe8tkGDogVc7fb6lw==
Date:   Fri, 9 Aug 2019 22:04:23 +0000
Message-ID: <20190809220359.11516-4-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 458f6e4c-50bf-4005-babf-08d71d158938
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2856;
x-ms-traffictypediagnostic: DB6PR0501MB2856:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB285623386660EA7695C3ED98BED60@DB6PR0501MB2856.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:446;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(199004)(189003)(2616005)(446003)(316002)(14444005)(256004)(5024004)(64756008)(54906003)(1076003)(476003)(26005)(6512007)(478600001)(186003)(486006)(36756003)(66066001)(6916009)(8936002)(6486002)(8676002)(81166006)(14454004)(71190400001)(50226002)(81156014)(71200400001)(66556008)(66476007)(5660300002)(66946007)(66446008)(52116002)(6436002)(11346002)(102836004)(99286004)(3846002)(107886003)(6116002)(4326008)(86362001)(386003)(7736002)(25786009)(2906002)(76176011)(305945005)(53936002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2856;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hcTtRNc95ZuSx60ammne+QKtDWULHSJVMBGu2EE9VcdBAS5vKk7Lti8OQV38eafQ5Mtt26Re+tT7ko/W3Xtg0cjqXVZfqLJ0w1jUipnzo5HnFSw1+jet6uuPoLCJtl7kecNidC3PTTLt602gM2H5oLYbevFdDLEVeoCtrn3KP9HGUX8QhWaFtaJ9ZPjg532L+OMarnyAo+hTcMdbz5HlplgnCDLBLhWQIx6UlUh9NlqMIwY6g7wxfUJxDeV1NEGL7ojppYXjD3BlatBxZ7UtGPBsYzcYlXguaH1M75SUEe6p4hwHb72cbFN6mmfkORLR1nX7FIclE2YolqKBUNggyWGxEd3OwO6OwxxrpYEGLnLa2L7EUl1FIpcod9+EU4d4Rl6VD4pNTy6behboBB+VTEh5xEJ2+XQqF/Nb8A8213o=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 458f6e4c-50bf-4005-babf-08d71d158938
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 22:04:23.2798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pETSnlJzpZAUAz0HuSd3e0rJ2VdxjtR5v/dE+BwDcPpYSPiunohpznju/szCMb/d0fQ02HVvo/2akP1OjR06Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2856
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

To remove dependency on rtnl lock, protect hairpin hash table from
concurrent modifications with new "hairpin_tbl_lock" mutex.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 21 +++++++++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/=
ethernet/mellanox/mlx5/core/en/fs.h
index 4518ce19112e..100506a3dd58 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -17,6 +17,7 @@ struct mlx5e_tc_table {
 	struct rhashtable               ht;
=20
 	DECLARE_HASHTABLE(mod_hdr_tbl, 8);
+	struct mutex hairpin_tbl_lock; /* protects hairpin_tbl */
 	DECLARE_HASHTABLE(hairpin_tbl, 8);
=20
 	struct notifier_block     netdevice_nb;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 0abfa9b3ec54..a7acb7fcbf5a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -652,15 +652,16 @@ static void mlx5e_hairpin_put(struct mlx5e_priv *priv=
,
 			      struct mlx5e_hairpin_entry *hpe)
 {
 	/* no more hairpin flows for us, release the hairpin pair */
-	if (!refcount_dec_and_test(&hpe->refcnt))
+	if (!refcount_dec_and_mutex_lock(&hpe->refcnt, &priv->fs.tc.hairpin_tbl_l=
ock))
 		return;
+	hash_del(&hpe->hairpin_hlist);
+	mutex_unlock(&priv->fs.tc.hairpin_tbl_lock);
=20
 	netdev_dbg(priv->netdev, "del hairpin: peer %s\n",
 		   dev_name(hpe->hp->pair->peer_mdev->device));
=20
 	WARN_ON(!list_empty(&hpe->flows));
 	mlx5e_hairpin_destroy(hpe->hp);
-	hash_del(&hpe->hairpin_hlist);
 	kfree(hpe);
 }
=20
@@ -729,13 +730,17 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *=
priv,
 				     extack);
 	if (err)
 		return err;
+
+	mutex_lock(&priv->fs.tc.hairpin_tbl_lock);
 	hpe =3D mlx5e_hairpin_get(priv, peer_id, match_prio);
 	if (hpe)
 		goto attach_flow;
=20
 	hpe =3D kzalloc(sizeof(*hpe), GFP_KERNEL);
-	if (!hpe)
-		return -ENOMEM;
+	if (!hpe) {
+		err =3D -ENOMEM;
+		goto create_hairpin_err;
+	}
=20
 	spin_lock_init(&hpe->flows_lock);
 	INIT_LIST_HEAD(&hpe->flows);
@@ -784,6 +789,8 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *pr=
iv,
 	} else {
 		flow->nic_attr->hairpin_tirn =3D hpe->hp->tirn;
 	}
+	mutex_unlock(&priv->fs.tc.hairpin_tbl_lock);
+
 	flow->hpe =3D hpe;
 	spin_lock(&hpe->flows_lock);
 	list_add(&flow->hairpin, &hpe->flows);
@@ -792,6 +799,7 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *pr=
iv,
 	return 0;
=20
 create_hairpin_err:
+	mutex_unlock(&priv->fs.tc.hairpin_tbl_lock);
 	kfree(hpe);
 	return err;
 }
@@ -3768,10 +3776,12 @@ static void mlx5e_tc_hairpin_update_dead_peer(struc=
t mlx5e_priv *priv,
=20
 	peer_vhca_id =3D MLX5_CAP_GEN(peer_mdev, vhca_id);
=20
+	mutex_lock(&priv->fs.tc.hairpin_tbl_lock);
 	hash_for_each(priv->fs.tc.hairpin_tbl, bkt, hpe, hairpin_hlist) {
 		if (hpe->peer_vhca_id =3D=3D peer_vhca_id)
 			hpe->hp->pair->peer_gone =3D true;
 	}
+	mutex_unlock(&priv->fs.tc.hairpin_tbl_lock);
 }
=20
 static int mlx5e_tc_netdev_event(struct notifier_block *this,
@@ -3808,6 +3818,7 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
=20
 	mutex_init(&tc->t_lock);
 	hash_init(tc->mod_hdr_tbl);
+	mutex_init(&tc->hairpin_tbl_lock);
 	hash_init(tc->hairpin_tbl);
=20
 	err =3D rhashtable_init(&tc->ht, &tc_ht_params);
@@ -3839,6 +3850,8 @@ void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv)
 	if (tc->netdevice_nb.notifier_call)
 		unregister_netdevice_notifier(&tc->netdevice_nb);
=20
+	mutex_destroy(&tc->hairpin_tbl_lock);
+
 	rhashtable_destroy(&tc->ht);
=20
 	if (!IS_ERR_OR_NULL(tc->t)) {
--=20
2.21.0

