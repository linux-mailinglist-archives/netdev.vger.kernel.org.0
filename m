Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B37888580
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbfHIWEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:04:46 -0400
Received: from mail-eopbgr60050.outbound.protection.outlook.com ([40.107.6.50]:49633
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726078AbfHIWEq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 18:04:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BqHPEhUOd5/0BitNdmTuib53K1pLkCD+tZWsYDyC+U4eQ3Q2nw5oeKTxH5b1kUMDMMGt33IIbrn+lTrjj5L7tbQriZt4PtLilKIUI1rbQKApf79S8wwxD8QNYVqqwALBGwzBF0NdhXWEwJrEXgJXnj0E/TDzXU3RMtJbZkg09pO4NaRGEI8tPkbbp4TCjXkx5ZbkIPoF2BTHh1QlvV4jTX6oaPo0585MR+UtzMtNZIE8ZSdAfFfTi6qk1LrbChSsD0wIHm8b6TfCS33NQg5ptQSFQgiGBuE7yeyJQZFdfianXByydFCtbScs0qzJ+qSXDayb3YF+YtErmlEh/GKncg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+X5BvdsvOvRLPXYWpZmBgZ5oLfBFBrDwVxByte05bTg=;
 b=DCDI2VUqydXIL7d/7wxx/h20G8cYnPYgpYzcawyjMFyECmjj8H1uyNRtwusz9yeKguus0u9ELuJRaJTi0hO0Gty/grrHZVci88wVCgs1Op5K9rFVbjAssPbtyEjciyN08+TKQHhigyUyMAlcsLTc+IGxf6vsoerBpizdjg5ZtJVv/8BYRvuVbJ4mLexR5BF6Yo6ZUStAUejwXcRgfAKVSkO0EB6wRHUUfLZ+Re7/aqnpXQfTd9Qhj87Wkt0gAWeQW5mme+Ojw3dubEg8B4MDzYug9zH342tBzljlmwdEsSxEAROC57xGHcq3i79/Yv4C+0XHIRL2G74xSI/3h+9jcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+X5BvdsvOvRLPXYWpZmBgZ5oLfBFBrDwVxByte05bTg=;
 b=FUbKdkerZmIl6yR7FriIk2BAGsk76rGaXBCjzQw6SZbqL5ko/225pAqHupuWdBSiLEV3J011UXB+2KYKFDPctHTcUQNlcSOxJEza72rpPUcMhAfgEGC8xQEXpy6EmjucokrJjdBAbJF5WAvsjwHJrWnH+MZV80LSFHgaEohUERo=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2856.eurprd05.prod.outlook.com (10.172.225.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Fri, 9 Aug 2019 22:04:31 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 22:04:31 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/15] net/mlx5e: Protect mod_hdr hash table with mutex
Thread-Topic: [net-next 07/15] net/mlx5e: Protect mod_hdr hash table with
 mutex
Thread-Index: AQHVTv5rOlzxrJrTaUSlJE3g17zrAA==
Date:   Fri, 9 Aug 2019 22:04:30 +0000
Message-ID: <20190809220359.11516-8-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 3fc6889d-b308-4f2a-34d6-08d71d158dd9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2856;
x-ms-traffictypediagnostic: DB6PR0501MB2856:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2856853198EA77050EFC0134BED60@DB6PR0501MB2856.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:191;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(199004)(189003)(2616005)(446003)(316002)(14444005)(256004)(5024004)(64756008)(54906003)(1076003)(476003)(26005)(6512007)(478600001)(186003)(486006)(36756003)(66066001)(6916009)(8936002)(6486002)(8676002)(81166006)(14454004)(71190400001)(50226002)(81156014)(71200400001)(66556008)(66476007)(5660300002)(66946007)(66446008)(52116002)(6436002)(11346002)(102836004)(99286004)(3846002)(107886003)(6116002)(4326008)(86362001)(386003)(7736002)(25786009)(2906002)(76176011)(305945005)(53936002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2856;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: R78kLM/9T5KKwzHwz1FtTiE6Jpd3u7HVNLtSF9q5AjI+9H4/ZseaM8BvCaJjzeB/m9wDhJqEYkjraaSby7Rd7aDFL7KBejO5exDmR5nxd+t63LAnAWEDbjSN/kMA9jUt5kPYNJS/CpQYtrYT5qvBm8y3/GK+sr7MjKbxc/rtpyyglg+CjPzQAqXaa3c/iT031sqpji3inYQs8ptBkOXBJWO9LX0T8bQkYHfTwtnftxuM7HjJh+6LTGHVtV3nQe7i8t+A4Cptj+5yjQwtlLQkje3QTlqK0qf4f0ypBN//txanr+J7CFl9aZtehUQ4nBalCFTGlo3tZDTWGSZAIc2h3MiRTCMQiVhqV1X65E/GwiysNjx1qe/M3BOXCy6sV4d6bjE6KFZ56khFOZR+9iIBiWZtI4u80pf2fZh+fD8sTeo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fc6889d-b308-4f2a-34d6-08d71d158dd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 22:04:30.8934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kl1ocM1nm2XLftVaREiYym1xd7t+7miV48frkQVwjJB8QxKhZXqgX8zv2y7uOHQ2q24HgtAOzTSCKTifslY5Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2856
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

To remove dependency on rtnl lock, protect mod_hdr hash table from
concurrent modifications with new mutex.

Implement helper function to get flow namespace to prevent code
duplication.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 35 +++++++++++++------
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  2 ++
 include/linux/mlx5/fs.h                       |  1 +
 3 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 09d5cc700297..0600b7878600 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -315,22 +315,31 @@ mlx5e_mod_hdr_get(struct mod_hdr_tbl *tbl, struct mod=
_hdr_key *key, u32 hash_key
 }
=20
 static void mlx5e_mod_hdr_put(struct mlx5e_priv *priv,
-			      struct mlx5e_mod_hdr_entry *mh)
+			      struct mlx5e_mod_hdr_entry *mh,
+			      int namespace)
 {
-	if (!refcount_dec_and_test(&mh->refcnt))
+	struct mod_hdr_tbl *tbl =3D get_mod_hdr_table(priv, namespace);
+
+	if (!refcount_dec_and_mutex_lock(&mh->refcnt, &tbl->lock))
 		return;
+	hash_del(&mh->mod_hdr_hlist);
+	mutex_unlock(&tbl->lock);
=20
 	WARN_ON(!list_empty(&mh->flows));
 	mlx5_modify_header_dealloc(priv->mdev, mh->mod_hdr_id);
-	hash_del(&mh->mod_hdr_hlist);
+
 	kfree(mh);
 }
=20
+static int get_flow_name_space(struct mlx5e_tc_flow *flow)
+{
+	return mlx5e_is_eswitch_flow(flow) ?
+		MLX5_FLOW_NAMESPACE_FDB : MLX5_FLOW_NAMESPACE_KERNEL;
+}
 static int mlx5e_attach_mod_hdr(struct mlx5e_priv *priv,
 				struct mlx5e_tc_flow *flow,
 				struct mlx5e_tc_flow_parse_attr *parse_attr)
 {
-	bool is_eswitch_flow =3D mlx5e_is_eswitch_flow(flow);
 	int num_actions, actions_size, namespace, err;
 	struct mlx5e_mod_hdr_entry *mh;
 	struct mod_hdr_tbl *tbl;
@@ -345,17 +354,19 @@ static int mlx5e_attach_mod_hdr(struct mlx5e_priv *pr=
iv,
=20
 	hash_key =3D hash_mod_hdr_info(&key);
=20
-	namespace =3D is_eswitch_flow ?
-		MLX5_FLOW_NAMESPACE_FDB : MLX5_FLOW_NAMESPACE_KERNEL;
+	namespace =3D get_flow_name_space(flow);
 	tbl =3D get_mod_hdr_table(priv, namespace);
=20
+	mutex_lock(&tbl->lock);
 	mh =3D mlx5e_mod_hdr_get(tbl, &key, hash_key);
 	if (mh)
 		goto attach_flow;
=20
 	mh =3D kzalloc(sizeof(*mh) + actions_size, GFP_KERNEL);
-	if (!mh)
-		return -ENOMEM;
+	if (!mh) {
+		err =3D -ENOMEM;
+		goto out_err;
+	}
=20
 	mh->key.actions =3D (void *)mh + sizeof(*mh);
 	memcpy(mh->key.actions, key.actions, actions_size);
@@ -374,11 +385,12 @@ static int mlx5e_attach_mod_hdr(struct mlx5e_priv *pr=
iv,
 	hash_add(tbl->hlist, &mh->mod_hdr_hlist, hash_key);
=20
 attach_flow:
+	mutex_unlock(&tbl->lock);
 	flow->mh =3D mh;
 	spin_lock(&mh->flows_lock);
 	list_add(&flow->mod_hdr, &mh->flows);
 	spin_unlock(&mh->flows_lock);
-	if (is_eswitch_flow)
+	if (mlx5e_is_eswitch_flow(flow))
 		flow->esw_attr->mod_hdr_id =3D mh->mod_hdr_id;
 	else
 		flow->nic_attr->mod_hdr_id =3D mh->mod_hdr_id;
@@ -386,6 +398,7 @@ static int mlx5e_attach_mod_hdr(struct mlx5e_priv *priv=
,
 	return 0;
=20
 out_err:
+	mutex_unlock(&tbl->lock);
 	kfree(mh);
 	return err;
 }
@@ -401,7 +414,7 @@ static void mlx5e_detach_mod_hdr(struct mlx5e_priv *pri=
v,
 	list_del(&flow->mod_hdr);
 	spin_unlock(&flow->mh->flows_lock);
=20
-	mlx5e_mod_hdr_put(priv, flow->mh);
+	mlx5e_mod_hdr_put(priv, flow->mh, get_flow_name_space(flow));
 	flow->mh =3D NULL;
 }
=20
@@ -3865,6 +3878,7 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	int err;
=20
 	mutex_init(&tc->t_lock);
+	mutex_init(&tc->mod_hdr.lock);
 	hash_init(tc->mod_hdr.hlist);
 	mutex_init(&tc->hairpin_tbl_lock);
 	hash_init(tc->hairpin_tbl);
@@ -3898,6 +3912,7 @@ void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv)
 	if (tc->netdevice_nb.notifier_call)
 		unregister_netdevice_notifier(&tc->netdevice_nb);
=20
+	mutex_destroy(&tc->mod_hdr.lock);
 	mutex_destroy(&tc->hairpin_tbl_lock);
=20
 	rhashtable_destroy(&tc->ht);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 5ce3c81e3083..2d734ecae719 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2000,6 +2000,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 		goto abort;
=20
 	hash_init(esw->offloads.encap_tbl);
+	mutex_init(&esw->offloads.mod_hdr.lock);
 	hash_init(esw->offloads.mod_hdr.hlist);
 	atomic64_set(&esw->offloads.num_flows, 0);
 	mutex_init(&esw->state_lock);
@@ -2037,6 +2038,7 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 	esw->dev->priv.eswitch =3D NULL;
 	destroy_workqueue(esw->work_queue);
 	esw_offloads_cleanup_reps(esw);
+	mutex_destroy(&esw->offloads.mod_hdr.lock);
 	kfree(esw->vports);
 	kfree(esw);
 }
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 96650a33aa91..1cb1045ce313 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -127,6 +127,7 @@ struct mlx5_flow_destination {
 };
=20
 struct mod_hdr_tbl {
+	struct mutex lock; /* protects hlist */
 	DECLARE_HASHTABLE(hlist, 8);
 };
=20
--=20
2.21.0

