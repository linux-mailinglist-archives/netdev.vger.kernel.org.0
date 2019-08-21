Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3EF6987D5
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731455AbfHUX2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:28:42 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:35598
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728605AbfHUX2m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 19:28:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dGaMxkmdLkb3JaHBndVsR9lCNuYRFkQSKUteZOQvUr16Vlqgl3N4Gvolsj8HXGFlnl4BR/PyIC7CCegzyoQdZ1kTUVxBHTaVNq+vYSWNeg7Vk0WrMoWLkaomP+xz7a2HU8Tz5FXGW1hZERC5AIsP1y21usGNPABTjh+walDB8pFVnZTLix2idXwtYV/bKQ7ITRZITIKSeFaFLihH+heRVOZq3REZowMLoGhzeEWExA8iuxAY1UQsPWc+CyymIbkx1/A0PJJsGnpFv1Q2Yh+u327mQvys60OEo53AbvcqX3y5kLOwMOCrM6LrONMi9gCOGqTXn5Tkl70xubdPnP69eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dtlQEVEHDvzFX3naXzPf4HLByHXp+FFY99DsVNeltGk=;
 b=d/+fgJI1h0Y8ZlOdiFnahPuCcn1Q5kk1qIn7mH0GbPz0ZgjvILI1TOWAjiQde/AEu+Tc+fodCfXaoazixG/zL9Quye34YwyfH4Xa2ZVybqZ8sFJQWDGCbMzW7sN4QbOCi0+EJFm7iCOZpd1maNPbLOerR9S63/FRKbN1P1ox7XC6I3HGN/BXrbTNLZ14Ghvflju5w5CUu80oiGU8beClEUxbXJCy+Mw0ilV2q8tuCRWcvLVlG63mEQkA4oJxVryXWn9NcPWazcn4IvxWxAuV+bwQPQwwhCFpzkpq2HnvjLwbwhdjyRMGlLMDqdTlFE3lX/Z8Z2c8+wmwwUbmxBmNNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dtlQEVEHDvzFX3naXzPf4HLByHXp+FFY99DsVNeltGk=;
 b=P32QOh6aDtRbFDc4ya5pIgtj86byJMuB5x8jMOgazkibG9eJ6iEDa3EJeYmCpH63qIjyW0Eo7DFNfpS6XI/kRoavsxW1fyW+XezxffDMWlFnHLQSz9+d3o+aXtJ9I3UytbqHJtcj28hetmaGwf1bantCLoL9/mqQn5LYTwUE4ds=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2674.eurprd05.prod.outlook.com (10.172.221.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 21 Aug 2019 23:28:36 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 23:28:36 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/11] net/mlx5e: Always take reference to neigh entry
Thread-Topic: [net-next 02/11] net/mlx5e: Always take reference to neigh entry
Thread-Index: AQHVWHgnWI5HmhapuEKvDSsri8f6Ag==
Date:   Wed, 21 Aug 2019 23:28:36 +0000
Message-ID: <20190821232806.21847-3-saeedm@mellanox.com>
References: <20190821232806.21847-1-saeedm@mellanox.com>
In-Reply-To: <20190821232806.21847-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0032.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::45) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ca1ef77-38bc-4f94-5f8d-08d7268f49ef
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2674;
x-ms-traffictypediagnostic: AM4PR0501MB2674:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2674CA8119E846EC4E025D72BEAA0@AM4PR0501MB2674.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(50226002)(5660300002)(6512007)(86362001)(3846002)(6116002)(305945005)(14444005)(66946007)(66556008)(7736002)(66476007)(256004)(66446008)(64756008)(66066001)(1076003)(71200400001)(71190400001)(5024004)(4326008)(478600001)(6916009)(8936002)(6486002)(107886003)(2906002)(2616005)(81156014)(81166006)(8676002)(476003)(6506007)(386003)(99286004)(52116002)(26005)(486006)(53936002)(76176011)(316002)(36756003)(25786009)(186003)(54906003)(14454004)(102836004)(446003)(6436002)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2674;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kRkcnFEBbV3hEe5jMVbRhh7dCslg7BMw0f7LoH1PEkEhuMR8qtwmqCkM6vpPQNgcyPowM9w+2giyZ5zRgEFKGlneQbSwfmXqDSx8FoAlYPIyvfFf+OxKZRPUDWTRZ+hp8vspTh/ECRN+wBP/cS3CJAMhUD6cddiLHjpWpXLW/HFOvLiah6QGC/MVtosFTfJeDlV1xrxNcR5d6JI9p1o8xJOa9YnsDceP1k/So0Wx3Lcl0Mbym/D/InCuDrCkSiJODgMZFR5fH26AoaW6Zs1ebN6/Wd4AQ9UX2Ms6ByWw2/mnMq5JYJdXfCHdCAriuSY+hhT8jXzkmqVjD4jGBoabjmf6RrnyGsRkTaIxUxJcAcJN7vpyVWH5X5Ad01XsvI/3vuXGcddCjdoVxKukOdUIcdX1nj6O/Y5wl0Zjefz7jYg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ca1ef77-38bc-4f94-5f8d-08d7268f49ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 23:28:36.2076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DXbWezp9HAe6jVZ13Z1pBOVjH3F82XunXrsY8vEKm+QS3NP2QrILdvrKLLK1wPaIdUPZjw0QupWcqNeV3sy8Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2674
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

Neigh entry has reference counter, however it is only used when scheduling
neigh update event. In all other cases reference to neigh entry is not
taken while working with it. Neigh code relies on synchronization provided
by rtnl lock and uses encap list size as implicit reference counter.

To remove dependency on rtnl lock, always take reference to neigh entry
while using it. Remove neigh entry from hash table and delete it only when
reference counter reaches zero. This can result spurious neigh update
events, when there is an event on entry that has zero encaps attached.
However, such events are rare and properly handled by neigh update handler.

Extend encap entry with reference to neigh hash entry in order to be able
to directly release it when encap is detached, instead of lookup nhe by key
through hash table. Extend nhe with reference to device priv structure to
guarantee correctness when nhe is used with stack devices, bond setup, in
which case it is non-trivial to determine correct device when releasing the
nhe.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 76 +++++++++----------
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  3 +
 2 files changed, 39 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index 85a503f0423b..23087f9abe74 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -524,6 +524,21 @@ void mlx5e_rep_queue_neigh_stats_work(struct mlx5e_pri=
v *priv)
 				 neigh_update->min_interval);
 }
=20
+static bool mlx5e_rep_neigh_entry_hold(struct mlx5e_neigh_hash_entry *nhe)
+{
+	return refcount_inc_not_zero(&nhe->refcnt);
+}
+
+static void mlx5e_rep_neigh_entry_remove(struct mlx5e_neigh_hash_entry *nh=
e);
+
+static void mlx5e_rep_neigh_entry_release(struct mlx5e_neigh_hash_entry *n=
he)
+{
+	if (refcount_dec_and_test(&nhe->refcnt)) {
+		mlx5e_rep_neigh_entry_remove(nhe);
+		kfree(nhe);
+	}
+}
+
 static void mlx5e_rep_neigh_stats_work(struct work_struct *work)
 {
 	struct mlx5e_rep_priv *rpriv =3D container_of(work, struct mlx5e_rep_priv=
,
@@ -536,23 +551,16 @@ static void mlx5e_rep_neigh_stats_work(struct work_st=
ruct *work)
 	if (!list_empty(&rpriv->neigh_update.neigh_list))
 		mlx5e_rep_queue_neigh_stats_work(priv);
=20
-	list_for_each_entry(nhe, &rpriv->neigh_update.neigh_list, neigh_list)
-		mlx5e_tc_update_neigh_used_value(nhe);
+	list_for_each_entry(nhe, &rpriv->neigh_update.neigh_list, neigh_list) {
+		if (mlx5e_rep_neigh_entry_hold(nhe)) {
+			mlx5e_tc_update_neigh_used_value(nhe);
+			mlx5e_rep_neigh_entry_release(nhe);
+		}
+	}
=20
 	rtnl_unlock();
 }
=20
-static void mlx5e_rep_neigh_entry_hold(struct mlx5e_neigh_hash_entry *nhe)
-{
-	refcount_inc(&nhe->refcnt);
-}
-
-static void mlx5e_rep_neigh_entry_release(struct mlx5e_neigh_hash_entry *n=
he)
-{
-	if (refcount_dec_and_test(&nhe->refcnt))
-		kfree(nhe);
-}
-
 static void mlx5e_rep_update_flows(struct mlx5e_priv *priv,
 				   struct mlx5e_encap_entry *e,
 				   bool neigh_connected,
@@ -881,14 +889,11 @@ static int mlx5e_rep_netevent_event(struct notifier_b=
lock *nb,
 		 */
 		spin_lock_bh(&neigh_update->encap_lock);
 		nhe =3D mlx5e_rep_neigh_entry_lookup(priv, &m_neigh);
-		if (!nhe) {
-			spin_unlock_bh(&neigh_update->encap_lock);
+		spin_unlock_bh(&neigh_update->encap_lock);
+		if (!nhe)
 			return NOTIFY_DONE;
-		}
=20
-		mlx5e_rep_neigh_entry_hold(nhe);
 		mlx5e_rep_queue_neigh_update_work(priv, nhe, n);
-		spin_unlock_bh(&neigh_update->encap_lock);
 		break;
=20
 	case NETEVENT_DELAY_PROBE_TIME_UPDATE:
@@ -995,10 +1000,9 @@ static int mlx5e_rep_neigh_entry_insert(struct mlx5e_=
priv *priv,
 	return err;
 }
=20
-static void mlx5e_rep_neigh_entry_remove(struct mlx5e_priv *priv,
-					 struct mlx5e_neigh_hash_entry *nhe)
+static void mlx5e_rep_neigh_entry_remove(struct mlx5e_neigh_hash_entry *nh=
e)
 {
-	struct mlx5e_rep_priv *rpriv =3D priv->ppriv;
+	struct mlx5e_rep_priv *rpriv =3D nhe->priv->ppriv;
=20
 	spin_lock_bh(&rpriv->neigh_update.encap_lock);
=20
@@ -1019,9 +1023,11 @@ mlx5e_rep_neigh_entry_lookup(struct mlx5e_priv *priv=
,
 {
 	struct mlx5e_rep_priv *rpriv =3D priv->ppriv;
 	struct mlx5e_neigh_update_table *neigh_update =3D &rpriv->neigh_update;
+	struct mlx5e_neigh_hash_entry *nhe;
=20
-	return rhashtable_lookup_fast(&neigh_update->neigh_ht, m_neigh,
-				      mlx5e_neigh_ht_params);
+	nhe =3D rhashtable_lookup_fast(&neigh_update->neigh_ht, m_neigh,
+				     mlx5e_neigh_ht_params);
+	return nhe && mlx5e_rep_neigh_entry_hold(nhe) ? nhe : NULL;
 }
=20
 static int mlx5e_rep_neigh_entry_create(struct mlx5e_priv *priv,
@@ -1034,6 +1040,7 @@ static int mlx5e_rep_neigh_entry_create(struct mlx5e_=
priv *priv,
 	if (!*nhe)
 		return -ENOMEM;
=20
+	(*nhe)->priv =3D priv;
 	memcpy(&(*nhe)->m_neigh, &e->m_neigh, sizeof(e->m_neigh));
 	INIT_WORK(&(*nhe)->neigh_update_work, mlx5e_rep_neigh_update);
 	INIT_LIST_HEAD(&(*nhe)->encap_list);
@@ -1049,19 +1056,6 @@ static int mlx5e_rep_neigh_entry_create(struct mlx5e=
_priv *priv,
 	return err;
 }
=20
-static void mlx5e_rep_neigh_entry_destroy(struct mlx5e_priv *priv,
-					  struct mlx5e_neigh_hash_entry *nhe)
-{
-	/* The neigh hash entry must be removed from the hash table regardless
-	 * of the reference count value, so it won't be found by the next
-	 * neigh notification call. The neigh hash entry reference count is
-	 * incremented only during creation and neigh notification calls and
-	 * protects from freeing the nhe struct.
-	 */
-	mlx5e_rep_neigh_entry_remove(priv, nhe);
-	mlx5e_rep_neigh_entry_release(nhe);
-}
-
 int mlx5e_rep_encap_entry_attach(struct mlx5e_priv *priv,
 				 struct mlx5e_encap_entry *e)
 {
@@ -1083,6 +1077,7 @@ int mlx5e_rep_encap_entry_attach(struct mlx5e_priv *p=
riv,
 			return err;
 		}
 	}
+	e->nhe =3D nhe;
 	list_add(&e->encap_list, &nhe->encap_list);
 	return 0;
 }
@@ -1093,13 +1088,14 @@ void mlx5e_rep_encap_entry_detach(struct mlx5e_priv=
 *priv,
 	struct mlx5e_rep_priv *rpriv =3D priv->ppriv;
 	struct mlx5_rep_uplink_priv *uplink_priv =3D &rpriv->uplink_priv;
 	struct mlx5_tun_entropy *tun_entropy =3D &uplink_priv->tun_entropy;
-	struct mlx5e_neigh_hash_entry *nhe;
+
+	if (!e->nhe)
+		return;
=20
 	list_del(&e->encap_list);
-	nhe =3D mlx5e_rep_neigh_entry_lookup(priv, &e->m_neigh);
=20
-	if (list_empty(&nhe->encap_list))
-		mlx5e_rep_neigh_entry_destroy(priv, nhe);
+	mlx5e_rep_neigh_entry_release(e->nhe);
+	e->nhe =3D NULL;
 	mlx5_tun_entropy_refcount_dec(tun_entropy, e->reformat_type);
 }
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.h
index 8ac96727cad8..f5bc9772be98 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -110,6 +110,7 @@ struct mlx5e_neigh {
 struct mlx5e_neigh_hash_entry {
 	struct rhash_head rhash_node;
 	struct mlx5e_neigh m_neigh;
+	struct mlx5e_priv *priv;
=20
 	/* Save the neigh hash entry in a list on the representor in
 	 * addition to the hash table. In order to iterate easily over the
@@ -145,6 +146,8 @@ enum {
 };
=20
 struct mlx5e_encap_entry {
+	/* attached neigh hash entry */
+	struct mlx5e_neigh_hash_entry *nhe;
 	/* neigh hash entry list of encaps sharing the same neigh */
 	struct list_head encap_list;
 	struct mlx5e_neigh m_neigh;
--=20
2.21.0

