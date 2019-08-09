Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF41C8857E
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbfHIWEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:04:43 -0400
Received: from mail-eopbgr60050.outbound.protection.outlook.com ([40.107.6.50]:49633
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726078AbfHIWEm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 18:04:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IRrgnJXl/rrWIJJ8G26ROP3eLCppSM/OPYwX8mlnG+BIApF0VExQtMxYz3oEaANWD+wDodGm4xhpVwqzcWVBUof4U6V9iTT73nqy5Yaa3Leb90Gf0nTbwJaP9LPZJjuauATurr1RI+5XZ9ioeoduI2MrejOz7OVlZc2UxzrblL4c5CKYKdbuv8QAoFP6KvmfF/NRT1Zaq/2zSffyiDcbLz3ZmBatjWuxaLzVcyWtggopdmZQDio329UwLQxFQGQ3dqNi8H0EB/0kmJLPwhB0PR0B9garfbBHmjUCYa4ikoR+EB4PenZwr9/P9ebwDvj0mjJm6rRcjhrlrKBcuXq50A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwNDWHj8jhEAFJ77gh7SOYbg9LMBiEQGSgHIiuo451I=;
 b=Gd1oRck+RwYFiQsH0qBaUqZg5MoQS3uPQpwYtQ7EuQbb/tfyXbMJvOCSk7e9I0ogcDM+n66oEOKbV32M+ULytv8EL/Ni8cXLvc54W/fIkCgFZs4jJVAUTaffTjfeSWmtFSYF1LV2AA/a41afkuYy3s37x57kROhnokE2UgHkgosuIUruPsNQWGN0GDiGdoGURGuKtKQM9vaTfUeLLjObQGWRfOm/KhLs0l6sMohVyuXEHAr5GUbxDPiUrj4hIpfixpYpp3KxWut6TqIVmnKkBKjnZrlTSORHbFTLrbHBT7g4QmCIcycanSp7tzSd7RKBHPYYeCWEyNgdlNcw+AuoOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwNDWHj8jhEAFJ77gh7SOYbg9LMBiEQGSgHIiuo451I=;
 b=hslnBhgqGS7TR56XacqiMbU0lRwK+W5k/IhCninyabQ61JEIM6BS2w5zapHHB1SFVzcpnhGOqgz7uTnS5WJOSyVoENpeHf73YMcDN0psUF6YXWKLvf7rwqcEgw+WZ4WVZZHXNBEJd8AdWqvMr7fDtuBFaftN8W4xehJ3OlE32oc=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2856.eurprd05.prod.outlook.com (10.172.225.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Fri, 9 Aug 2019 22:04:27 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 22:04:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/15] net/mlx5e: Extend mod header entry with reference
 counter
Thread-Topic: [net-next 05/15] net/mlx5e: Extend mod header entry with
 reference counter
Thread-Index: AQHVTv5pcAS1PR1pDUiFUM7CzdliVQ==
Date:   Fri, 9 Aug 2019 22:04:26 +0000
Message-ID: <20190809220359.11516-6-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 718af3b5-a0cc-44bb-880b-08d71d158b6b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2856;
x-ms-traffictypediagnostic: DB6PR0501MB2856:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2856B72FBE7962CB330C891FBED60@DB6PR0501MB2856.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(199004)(189003)(2616005)(446003)(316002)(14444005)(256004)(5024004)(64756008)(54906003)(1076003)(476003)(26005)(6512007)(478600001)(186003)(486006)(36756003)(66066001)(6916009)(8936002)(6486002)(8676002)(81166006)(14454004)(71190400001)(50226002)(81156014)(71200400001)(66556008)(66476007)(5660300002)(66946007)(66446008)(52116002)(6436002)(11346002)(102836004)(99286004)(3846002)(107886003)(6116002)(4326008)(86362001)(386003)(7736002)(25786009)(2906002)(76176011)(305945005)(53936002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2856;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nSzQn4kHYABCBg9VWqH084B5ovKJKB7bYqnl0XIaN875EMIhHFQDPC1BPiSNGDmFTCf0MLU+PHK6QEQxa9p15t6JP1K1ZNIs74aOas7VDK6+hYJR0LFMdsCp82sjMMiY8lv4hoJavOXVClOWUi07qceCE3MoDlMWs8kNbW/BEyAPb7GuSCiT+lNBeu56OhyTGwyg9oCRkguwItv8DCltpxjHLehwuMh0Oa9Qmmwp2BRq5N8mnZDGNgQeBK9FZ9FN/WHi/+zB6u++uHEbiNKiRlc/Fal+l1IneKFTsRHuBslusUibxV/rc74qdEPv1MSBabT6DozaqekTSlWQT2SwbB/I3BGI6FH/Y8HSxAWrkfc/MBP1w77tiSprSfAEq2lB9w+qp0xe4cS8bNmqfROFhbn9+N/u0/jcTdWv6a09g7s=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 718af3b5-a0cc-44bb-880b-08d71d158b6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 22:04:26.9812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YZ9vN1tuyd1OxtuN+SlUBafRB+3t8VzGIpEEbC2qj8SBXh+4KzquSn7LesC4sGFNAYYP/3+cv3c73I/JiSGDFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2856
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

List of flows attached to mod header entry is used as implicit reference
counter (mod header entry is deallocated when list becomes free) and as a
mechanism to obtain mod header entry that flow is attached to (through list
head). This is not safe when concurrent modification of list of flows
attached to mod header entry is possible. Proper atomic reference counter
is required to support concurrent access.

As a preparation for extending mod header with reference counting, extract
code that lookups and deletes mod header entry into standalone put/get
helpers. In order to remove this dependency on external locking, extend mod
header entry with reference counter to manage its lifetime and extend flow
structure with direct pointer to mod header entry that flow is attached to.

To remove code duplication between legacy and switchdev mode
implementations that both support mod_hdr functionality, store mod_hdr
table in dedicated structure used by both fdb and kernel namespaces. New
table structure is extended with table lock by one of the following patches
in this series. Implement helper function to get correct mod_hdr table
depending on flow namespace.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 94 +++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  2 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  2 +-
 include/linux/mlx5/fs.h                       |  4 +
 5 files changed, 61 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/=
ethernet/mellanox/mlx5/core/en/fs.h
index 100506a3dd58..ca2161b42c7f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -16,7 +16,7 @@ struct mlx5e_tc_table {
=20
 	struct rhashtable               ht;
=20
-	DECLARE_HASHTABLE(mod_hdr_tbl, 8);
+	struct mod_hdr_tbl mod_hdr;
 	struct mutex hairpin_tbl_lock; /* protects hairpin_tbl */
 	DECLARE_HASHTABLE(hairpin_tbl, 8);
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index b6a91e3054c0..fe1b04aa910a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -119,6 +119,7 @@ struct mlx5e_tc_flow {
 	 */
 	struct encap_flow_item encaps[MLX5_MAX_FLOW_FWD_VPORTS];
 	struct mlx5e_tc_flow    *peer_flow;
+	struct mlx5e_mod_hdr_entry *mh; /* attached mod header instance */
 	struct list_head	mod_hdr; /* flows sharing the same mod hdr ID */
 	struct mlx5e_hairpin_entry *hpe; /* attached hairpin instance */
 	struct list_head	hairpin; /* flows sharing the same hairpin */
@@ -194,6 +195,8 @@ struct mlx5e_mod_hdr_entry {
 	struct mod_hdr_key key;
=20
 	u32 mod_hdr_id;
+
+	refcount_t refcnt;
 };
=20
 #define MLX5_MH_ACT_SZ MLX5_UN_SZ_BYTES(set_action_in_add_action_in_auto)
@@ -284,14 +287,51 @@ static inline int cmp_mod_hdr_info(struct mod_hdr_key=
 *a,
 	return memcmp(a->actions, b->actions, a->num_actions * MLX5_MH_ACT_SZ);
 }
=20
+static struct mod_hdr_tbl *
+get_mod_hdr_table(struct mlx5e_priv *priv, int namespace)
+{
+	struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch;
+
+	return namespace =3D=3D MLX5_FLOW_NAMESPACE_FDB ? &esw->offloads.mod_hdr =
:
+		&priv->fs.tc.mod_hdr;
+}
+
+static struct mlx5e_mod_hdr_entry *
+mlx5e_mod_hdr_get(struct mod_hdr_tbl *tbl, struct mod_hdr_key *key, u32 ha=
sh_key)
+{
+	struct mlx5e_mod_hdr_entry *mh, *found =3D NULL;
+
+	hash_for_each_possible(tbl->hlist, mh, mod_hdr_hlist, hash_key) {
+		if (!cmp_mod_hdr_info(&mh->key, key)) {
+			refcount_inc(&mh->refcnt);
+			found =3D mh;
+			break;
+		}
+	}
+
+	return found;
+}
+
+static void mlx5e_mod_hdr_put(struct mlx5e_priv *priv,
+			      struct mlx5e_mod_hdr_entry *mh)
+{
+	if (!refcount_dec_and_test(&mh->refcnt))
+		return;
+
+	WARN_ON(!list_empty(&mh->flows));
+	mlx5_modify_header_dealloc(priv->mdev, mh->mod_hdr_id);
+	hash_del(&mh->mod_hdr_hlist);
+	kfree(mh);
+}
+
 static int mlx5e_attach_mod_hdr(struct mlx5e_priv *priv,
 				struct mlx5e_tc_flow *flow,
 				struct mlx5e_tc_flow_parse_attr *parse_attr)
 {
-	struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch;
+	bool is_eswitch_flow =3D mlx5e_is_eswitch_flow(flow);
 	int num_actions, actions_size, namespace, err;
-	bool found =3D false, is_eswitch_flow;
 	struct mlx5e_mod_hdr_entry *mh;
+	struct mod_hdr_tbl *tbl;
 	struct mod_hdr_key key;
 	u32 hash_key;
=20
@@ -303,28 +343,12 @@ static int mlx5e_attach_mod_hdr(struct mlx5e_priv *pr=
iv,
=20
 	hash_key =3D hash_mod_hdr_info(&key);
=20
-	is_eswitch_flow =3D mlx5e_is_eswitch_flow(flow);
-	if (is_eswitch_flow) {
-		namespace =3D MLX5_FLOW_NAMESPACE_FDB;
-		hash_for_each_possible(esw->offloads.mod_hdr_tbl, mh,
-				       mod_hdr_hlist, hash_key) {
-			if (!cmp_mod_hdr_info(&mh->key, &key)) {
-				found =3D true;
-				break;
-			}
-		}
-	} else {
-		namespace =3D MLX5_FLOW_NAMESPACE_KERNEL;
-		hash_for_each_possible(priv->fs.tc.mod_hdr_tbl, mh,
-				       mod_hdr_hlist, hash_key) {
-			if (!cmp_mod_hdr_info(&mh->key, &key)) {
-				found =3D true;
-				break;
-			}
-		}
-	}
+	namespace =3D is_eswitch_flow ?
+		MLX5_FLOW_NAMESPACE_FDB : MLX5_FLOW_NAMESPACE_KERNEL;
+	tbl =3D get_mod_hdr_table(priv, namespace);
=20
-	if (found)
+	mh =3D mlx5e_mod_hdr_get(tbl, &key, hash_key);
+	if (mh)
 		goto attach_flow;
=20
 	mh =3D kzalloc(sizeof(*mh) + actions_size, GFP_KERNEL);
@@ -335,6 +359,7 @@ static int mlx5e_attach_mod_hdr(struct mlx5e_priv *priv=
,
 	memcpy(mh->key.actions, key.actions, actions_size);
 	mh->key.num_actions =3D num_actions;
 	INIT_LIST_HEAD(&mh->flows);
+	refcount_set(&mh->refcnt, 1);
=20
 	err =3D mlx5_modify_header_alloc(priv->mdev, namespace,
 				       mh->key.num_actions,
@@ -343,12 +368,10 @@ static int mlx5e_attach_mod_hdr(struct mlx5e_priv *pr=
iv,
 	if (err)
 		goto out_err;
=20
-	if (is_eswitch_flow)
-		hash_add(esw->offloads.mod_hdr_tbl, &mh->mod_hdr_hlist, hash_key);
-	else
-		hash_add(priv->fs.tc.mod_hdr_tbl, &mh->mod_hdr_hlist, hash_key);
+	hash_add(tbl->hlist, &mh->mod_hdr_hlist, hash_key);
=20
 attach_flow:
+	flow->mh =3D mh;
 	list_add(&flow->mod_hdr, &mh->flows);
 	if (is_eswitch_flow)
 		flow->esw_attr->mod_hdr_id =3D mh->mod_hdr_id;
@@ -365,23 +388,14 @@ static int mlx5e_attach_mod_hdr(struct mlx5e_priv *pr=
iv,
 static void mlx5e_detach_mod_hdr(struct mlx5e_priv *priv,
 				 struct mlx5e_tc_flow *flow)
 {
-	struct list_head *next =3D flow->mod_hdr.next;
-
 	/* flow wasn't fully initialized */
-	if (list_empty(&flow->mod_hdr))
+	if (!flow->mh)
 		return;
=20
 	list_del(&flow->mod_hdr);
=20
-	if (list_empty(next)) {
-		struct mlx5e_mod_hdr_entry *mh;
-
-		mh =3D list_entry(next, struct mlx5e_mod_hdr_entry, flows);
-
-		mlx5_modify_header_dealloc(priv->mdev, mh->mod_hdr_id);
-		hash_del(&mh->mod_hdr_hlist);
-		kfree(mh);
-	}
+	mlx5e_mod_hdr_put(priv, flow->mh);
+	flow->mh =3D NULL;
 }
=20
 static
@@ -3844,7 +3858,7 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	int err;
=20
 	mutex_init(&tc->t_lock);
-	hash_init(tc->mod_hdr_tbl);
+	hash_init(tc->mod_hdr.hlist);
 	mutex_init(&tc->hairpin_tbl_lock);
 	hash_init(tc->hairpin_tbl);
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 5fbebee7254d..5ce3c81e3083 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2000,7 +2000,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 		goto abort;
=20
 	hash_init(esw->offloads.encap_tbl);
-	hash_init(esw->offloads.mod_hdr_tbl);
+	hash_init(esw->offloads.mod_hdr.hlist);
 	atomic64_set(&esw->offloads.num_flows, 0);
 	mutex_init(&esw->state_lock);
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index 804912e38dee..fd63ba4ed0da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -182,7 +182,7 @@ struct mlx5_esw_offload {
 	struct list_head peer_flows;
 	struct mutex peer_mutex;
 	DECLARE_HASHTABLE(encap_tbl, 8);
-	DECLARE_HASHTABLE(mod_hdr_tbl, 8);
+	struct mod_hdr_tbl mod_hdr;
 	DECLARE_HASHTABLE(termtbl_tbl, 8);
 	struct mutex termtbl_mutex; /* protects termtbl hash */
 	const struct mlx5_eswitch_rep_ops *rep_ops[NUM_REP_TYPES];
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index f049af3f3cd8..96650a33aa91 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -126,6 +126,10 @@ struct mlx5_flow_destination {
 	};
 };
=20
+struct mod_hdr_tbl {
+	DECLARE_HASHTABLE(hlist, 8);
+};
+
 struct mlx5_flow_namespace *
 mlx5_get_fdb_sub_ns(struct mlx5_core_dev *dev, int n);
 struct mlx5_flow_namespace *
--=20
2.21.0

