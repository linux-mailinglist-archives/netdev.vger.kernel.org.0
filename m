Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5498858D
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729769AbfHIWEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:04:55 -0400
Received: from mail-eopbgr60050.outbound.protection.outlook.com ([40.107.6.50]:49633
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729533AbfHIWEw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 18:04:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DlQe2ruBdNtPP8GxLWDSI0zSgpq7uOFeW0SCiGrVK3KKVPvs2FLVENZkfjBJfgPM4otxF9qpQqhN7GbtnLnGEs0aGL4qo3LxQ2VGAQLZftiS0s2Zti+A09OTyVyOVsPZmI3TAFNKmQslN7Rqv1yMTC/1kium+7CrftOwhDjB+KBGyBoh/3SeZ1XQQMwwKgNXGt8d6mRlapRy5gD4oM2QdE+6JybDIrQaQ8/DB+nczMxFLEaovPhR8EQ2kQfZlSRiHwq1LLor2zckoM7cqaLJtL0U8VQGaidLIBVbjM6P8kiDQVg8FN2VTojJ6eQP39g5yCuk3LM+e17ZSA64dOK63w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vrWFb+uNT16+0awW40wRnYVWl/s5nslG7sTXs6TZDa4=;
 b=YbLvaYBG9uNwXq3pDtJ1usYBOCL7J3bIYBxZQQi9LXZn3Kle/tcEevhdf6kmoZ1eoPUM8K/P6E+r+kABKMGLcGg73St3olmocFfgWi8XfKDn+wTP1Emw7w5qs3JMYD3D7jmk4a5GVrzBksQMjwOCBM6kg+x7toN9lhhvQd0h+zZ5J02H1I7dJgs7021yNLLmsfgwHv57EHKKXCbHtBW6nZU1xhFjG/qrilqalgB7DJbFrxBDsSAdGO+HRYCulvmmyby2rfQMHVYvs+pRQsVXTJ4voHKq62pfhx4w1kwqgP5YHfbwGAO0mYImH2iUj6U2de4uQiRmufdprswph2DwWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vrWFb+uNT16+0awW40wRnYVWl/s5nslG7sTXs6TZDa4=;
 b=myBecxz+piKNsmX8ABrV3P8mM0dBMz49K1v1yK30ZumfxyMjkFtWc/PIPWDqLwJLmClL5Mr22jSIrNpMRj8o3in5YWGBUbLfULmrP0j8zORqbMbrVTUARqLabwgOep/89sSomgcZK3GIRkeWytzYWkCeU0ow3zHMPFm4MOJRD0c=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2856.eurprd05.prod.outlook.com (10.172.225.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Fri, 9 Aug 2019 22:04:34 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 22:04:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/15] net/mlx5e: Extend encap entry with reference counter
Thread-Topic: [net-next 09/15] net/mlx5e: Extend encap entry with reference
 counter
Thread-Index: AQHVTv5tQlvaJCJpgkio3dSWgB0YDA==
Date:   Fri, 9 Aug 2019 22:04:34 +0000
Message-ID: <20190809220359.11516-10-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: d6e36cd8-b2d4-48ee-43f3-08d71d158ff7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2856;
x-ms-traffictypediagnostic: DB6PR0501MB2856:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB28565711B121F7725CF468CABED60@DB6PR0501MB2856.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(199004)(189003)(2616005)(446003)(316002)(14444005)(256004)(5024004)(64756008)(54906003)(1076003)(476003)(26005)(6512007)(478600001)(186003)(486006)(36756003)(66066001)(6916009)(8936002)(6486002)(8676002)(81166006)(14454004)(71190400001)(50226002)(81156014)(71200400001)(66556008)(66476007)(5660300002)(66946007)(66446008)(52116002)(6436002)(11346002)(102836004)(99286004)(3846002)(107886003)(6116002)(4326008)(86362001)(386003)(7736002)(25786009)(2906002)(76176011)(305945005)(53936002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2856;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vRm1RSggayptzpxKfaJpUAo3i6XJvw8pnCf4H0FW22OX4Htrv309N4flaQ2grR4Gf80i/vOSJ7MDT14v7ongkrVUwloMaC2p3F3k0e0B2A5K+s2d6UdG647rQlDRifpkgXWqHO1O1MED1OPWt+f+wTOJD8ChqzqRN5T7manxnv1gLmUEoP/BP8nLVmdGJ2XaW5AOrMDih5X0GAbpYqFpsE7L05J5Vq/z0KiqhYZKWO027mf2tFC9bFmQYxb0QU9ea0v9g4ncJPHkGRAFKbnx8IlPq/VAmIvW8ibmnFQsDFsT/2SlU/b0W7xPAbHZhzL62tq7s2sfLiYaXwjlrnxHclkiJlAYFT0LA8hrZZP79LfdMDKQIglpW52BBrvvbFXdnbRjBIcti0kJYkNSfbm/kIDerkvRic4owsNafN1ed5g=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6e36cd8-b2d4-48ee-43f3-08d71d158ff7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 22:04:34.4669
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kL/apT8EbxLyqHItmvPibxtifwVmw9lkQr6B1oY9320glfrOtyVEMECR7bZDEIOponUgy/Gi95MeXxVhy0ePAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2856
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

List of flows attached to encap entry is used as implicit reference
counter (encap entry is deallocated when list becomes free) and as a
mechanism to obtain encap entry that flow is attached to (through list
head). This is not safe when concurrent modification of list of flows
attached to encap entry is possible. Proper atomic reference counter is
required to support concurrent access.

As a preparation for extending encap with reference counting, extract code
that lookups and deletes encap entry into standalone put/get helpers. In
order to remove this dependency on external locking, extend encap entry
with reference counter to manage its lifetime and extend flow structure
with direct pointer to encap entry that flow is attached to.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  5 ++
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 84 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  2 +
 4 files changed, 64 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index b7f113e996e5..cd957ff4e207 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -613,12 +613,17 @@ static void mlx5e_rep_neigh_update(struct work_struct=
 *work)
 	neigh_connected =3D (nud_state & NUD_VALID) && !dead;
=20
 	list_for_each_entry(e, &nhe->encap_list, encap_list) {
+		if (!mlx5e_encap_take(e))
+			continue;
+
 		encap_connected =3D !!(e->flags & MLX5_ENCAP_ENTRY_VALID);
 		priv =3D netdev_priv(e->out_dev);
=20
 		if (encap_connected !=3D neigh_connected ||
 		    !ether_addr_equal(e->h_dest, ha))
 			mlx5e_rep_update_flows(priv, e, neigh_connected, ha);
+
+		mlx5e_encap_put(priv, e);
 	}
 	mlx5e_rep_neigh_entry_release(nhe);
 	rtnl_unlock();
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.h
index 43eeebe9c8d2..2e970d0729be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -164,6 +164,7 @@ struct mlx5e_encap_entry {
 	u8 flags;
 	char *encap_header;
 	int encap_size;
+	refcount_t refcnt;
 };
=20
 struct mlx5e_rep_sq {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index fcaf9ab9e373..4e378200a9d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -103,6 +103,7 @@ enum {
  *        container_of(helper item, containing struct type, helper field[i=
ndex])
  */
 struct encap_flow_item {
+	struct mlx5e_encap_entry *e; /* attached encap instance */
 	struct list_head list;
 	int index;
 };
@@ -1433,8 +1434,11 @@ void mlx5e_tc_update_neigh_used_value(struct mlx5e_n=
eigh_hash_entry *nhe)
=20
 	list_for_each_entry(e, &nhe->encap_list, encap_list) {
 		struct encap_flow_item *efi, *tmp;
-		if (!(e->flags & MLX5_ENCAP_ENTRY_VALID))
+
+		if (!(e->flags & MLX5_ENCAP_ENTRY_VALID) ||
+		    !mlx5e_encap_take(e))
 			continue;
+
 		list_for_each_entry_safe(efi, tmp, &e->flows, list) {
 			flow =3D container_of(efi, struct mlx5e_tc_flow,
 					    encaps[efi->index]);
@@ -1453,6 +1457,8 @@ void mlx5e_tc_update_neigh_used_value(struct mlx5e_ne=
igh_hash_entry *nhe)
=20
 			mlx5e_flow_put(netdev_priv(e->out_dev), flow);
 		}
+
+		mlx5e_encap_put(netdev_priv(e->out_dev), e);
 		if (neigh_used)
 			break;
 	}
@@ -1472,29 +1478,33 @@ void mlx5e_tc_update_neigh_used_value(struct mlx5e_=
neigh_hash_entry *nhe)
 	}
 }
=20
+void mlx5e_encap_put(struct mlx5e_priv *priv, struct mlx5e_encap_entry *e)
+{
+	if (!refcount_dec_and_test(&e->refcnt))
+		return;
+
+	WARN_ON(!list_empty(&e->flows));
+	mlx5e_rep_encap_entry_detach(netdev_priv(e->out_dev), e);
+
+	if (e->flags & MLX5_ENCAP_ENTRY_VALID)
+		mlx5_packet_reformat_dealloc(priv->mdev, e->encap_id);
+
+	hash_del_rcu(&e->encap_hlist);
+	kfree(e->encap_header);
+	kfree(e);
+}
+
 static void mlx5e_detach_encap(struct mlx5e_priv *priv,
 			       struct mlx5e_tc_flow *flow, int out_index)
 {
-	struct list_head *next =3D flow->encaps[out_index].list.next;
-
 	/* flow wasn't fully initialized */
-	if (list_empty(&flow->encaps[out_index].list))
+	if (!flow->encaps[out_index].e)
 		return;
=20
 	list_del(&flow->encaps[out_index].list);
-	if (list_empty(next)) {
-		struct mlx5e_encap_entry *e;
-
-		e =3D list_entry(next, struct mlx5e_encap_entry, flows);
-		mlx5e_rep_encap_entry_detach(netdev_priv(e->out_dev), e);
=20
-		if (e->flags & MLX5_ENCAP_ENTRY_VALID)
-			mlx5_packet_reformat_dealloc(priv->mdev, e->encap_id);
-
-		hash_del_rcu(&e->encap_hlist);
-		kfree(e->encap_header);
-		kfree(e);
-	}
+	mlx5e_encap_put(priv, flow->encaps[out_index].e);
+	flow->encaps[out_index].e =3D NULL;
 }
=20
 static void __mlx5e_tc_del_fdb_peer_flow(struct mlx5e_tc_flow *flow)
@@ -2817,6 +2827,31 @@ static bool is_merged_eswitch_dev(struct mlx5e_priv =
*priv,
=20
=20
=20
+bool mlx5e_encap_take(struct mlx5e_encap_entry *e)
+{
+	return refcount_inc_not_zero(&e->refcnt);
+}
+
+static struct mlx5e_encap_entry *
+mlx5e_encap_get(struct mlx5e_priv *priv, struct encap_key *key,
+		uintptr_t hash_key)
+{
+	struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch;
+	struct mlx5e_encap_entry *e;
+	struct encap_key e_key;
+
+	hash_for_each_possible_rcu(esw->offloads.encap_tbl, e,
+				   encap_hlist, hash_key) {
+		e_key.ip_tun_key =3D &e->tun_info->key;
+		e_key.tc_tunnel =3D e->tunnel;
+		if (!cmp_encap_info(&e_key, key) &&
+		    mlx5e_encap_take(e))
+			return e;
+	}
+
+	return NULL;
+}
+
 static int mlx5e_attach_encap(struct mlx5e_priv *priv,
 			      struct mlx5e_tc_flow *flow,
 			      struct net_device *mirred_dev,
@@ -2829,11 +2864,10 @@ static int mlx5e_attach_encap(struct mlx5e_priv *pr=
iv,
 	struct mlx5_esw_flow_attr *attr =3D flow->esw_attr;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	const struct ip_tunnel_info *tun_info;
-	struct encap_key key, e_key;
+	struct encap_key key;
 	struct mlx5e_encap_entry *e;
 	unsigned short family;
 	uintptr_t hash_key;
-	bool found =3D false;
 	int err =3D 0;
=20
 	parse_attr =3D attr->parse_attr;
@@ -2848,24 +2882,17 @@ static int mlx5e_attach_encap(struct mlx5e_priv *pr=
iv,
=20
 	hash_key =3D hash_encap_info(&key);
=20
-	hash_for_each_possible_rcu(esw->offloads.encap_tbl, e,
-				   encap_hlist, hash_key) {
-		e_key.ip_tun_key =3D &e->tun_info->key;
-		e_key.tc_tunnel =3D e->tunnel;
-		if (!cmp_encap_info(&e_key, &key)) {
-			found =3D true;
-			break;
-		}
-	}
+	e =3D mlx5e_encap_get(priv, &key, hash_key);
=20
 	/* must verify if encap is valid or not */
-	if (found)
+	if (e)
 		goto attach_flow;
=20
 	e =3D kzalloc(sizeof(*e), GFP_KERNEL);
 	if (!e)
 		return -ENOMEM;
=20
+	refcount_set(&e->refcnt, 1);
 	e->tun_info =3D tun_info;
 	err =3D mlx5e_tc_tun_init_encap_attr(mirred_dev, priv, e, extack);
 	if (err)
@@ -2884,6 +2911,7 @@ static int mlx5e_attach_encap(struct mlx5e_priv *priv=
,
 	hash_add_rcu(esw->offloads.encap_tbl, &e->encap_hlist, hash_key);
=20
 attach_flow:
+	flow->encaps[out_index].e =3D e;
 	list_add(&flow->encaps[out_index].list, &e->flows);
 	flow->encaps[out_index].index =3D out_index;
 	*encap_dev =3D e->out_dev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.h
index 20f045e96c92..ea2072e2fe84 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -75,6 +75,8 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
 			      struct mlx5e_encap_entry *e);
 void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 			      struct mlx5e_encap_entry *e);
+bool mlx5e_encap_take(struct mlx5e_encap_entry *e);
+void mlx5e_encap_put(struct mlx5e_priv *priv, struct mlx5e_encap_entry *e)=
;
=20
 struct mlx5e_neigh_hash_entry;
 void mlx5e_tc_update_neigh_used_value(struct mlx5e_neigh_hash_entry *nhe);
--=20
2.21.0

