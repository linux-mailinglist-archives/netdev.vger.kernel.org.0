Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22C0D987DA
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730646AbfHUX24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:28:56 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:35598
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729076AbfHUX2z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 19:28:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qnem/RnCEvlBjQkJnk6H9ecRgyw1bGCiIVcXNaq6y+70c2PC8G73VXUFUgJ2/fzwL1HLaTnFIXZNsJPE7d+2u1ohJPBauYwKlcBDMTN3X57COPxsl6stldvx75kHsAnp3j6K5QVXvOJaaCqdP7uZSvL7T36hxiA5QR53Q/Zp34iBcjeJ2nRRile9Su+i/2lW6tW0O/C+6H5jkBvN1IQoMUMfmBKh5RY1+FgucAkOYihyiI9osucMMQD3KmthRQbPH1BYeXIK1mQwz3Mcsn89RZSJIvWuxPWxca3mMyXk6Ysyo+7J+D4sBUoyjJqneDo0P7eauM+1PH0v5Fig7s4hYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cn3LSHQcBylOhSLPATDqAFYR97g6OjwVdPV4X3o9saE=;
 b=OD1Ctx2wjoIeofD8Q0wVxdlqSqhexS2Z5qSA0spRiBawX54ka4jxraC7w5z58PDfj+z2vWNJfXxIjm1iqLb6+bfNt3+aQ70dwilb2Z3mTMq84dDO9atYT5Do0FNkrOD8vLM5rh8XjftKFKnTGCPYxyvDH+LVbo7FdEyXzhjHvOvu0iubMHE0g5fCKOMMo8M5AAtMwoPvzFmulauMNX9UGpn6/R3O13u4pQor39ibeqAEUhrHq2YrpuKs3D6tUQeLhLP3hb9YECYvkQn4gl+f7+QU8nKfZS4xQ4LjwMZMGrTFNUyopTTN9d5Wfwe44bkWO4KNZ/XeXFr0aKNCaVuYFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cn3LSHQcBylOhSLPATDqAFYR97g6OjwVdPV4X3o9saE=;
 b=rDm+7/0UDwsg4YJmqwtb5LgDIy+gOzyE/Tj6YfKyKTMIcu7epsJX+0J9Su/SGQXDtMSKvb0nndTVNNJJtYVh2/t+X8N+jOcSU0GX2TfF7nCFtuYOaIMJCcIKToDpXWgMWT1NVGJbpRLpjRMoT+Wp2m3r8ODzWvnZjT5dn5YRzwQ=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2674.eurprd05.prod.outlook.com (10.172.221.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 21 Aug 2019 23:28:46 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 23:28:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/11] net/mlx5e: Refactor neigh update for concurrent
 execution
Thread-Topic: [net-next 07/11] net/mlx5e: Refactor neigh update for concurrent
 execution
Thread-Index: AQHVWHgt81tnZAamr0OLOtMSwKVF3Q==
Date:   Wed, 21 Aug 2019 23:28:46 +0000
Message-ID: <20190821232806.21847-8-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 979f6013-5d4a-425c-28e6-08d7268f4ff9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2674;
x-ms-traffictypediagnostic: AM4PR0501MB2674:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB267492CC3F1A2E0256EE0805BEAA0@AM4PR0501MB2674.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:556;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(15650500001)(50226002)(5660300002)(6512007)(86362001)(3846002)(6116002)(305945005)(14444005)(66946007)(66556008)(7736002)(66476007)(256004)(66446008)(64756008)(66066001)(1076003)(71200400001)(71190400001)(5024004)(4326008)(478600001)(6916009)(8936002)(6486002)(107886003)(2906002)(2616005)(81156014)(81166006)(8676002)(476003)(6506007)(386003)(99286004)(52116002)(26005)(486006)(53936002)(76176011)(316002)(36756003)(25786009)(186003)(54906003)(14454004)(102836004)(446003)(6436002)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2674;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9MB5pPyR1HwrBh+PSAhuBOjRgbVLGlM/9VylbbvhH5p0QfVsTgIKQMwefJ3GBCynyyRYvWmToGyBvsb8BSAfOQADGY5Uk2kIU6oPPqmQTLaA6TWlKvla6jueF1y6KTQ+qPG0P2uWqV/RVrIXx+2OJDC0u6EnaOZf41QQ1H6ipnhq652seK+ReCp0m2fSk0LpCcDsPCmKttEq+1x4x209qvi0+ZLpFMuOrAScs3ODpdl1vGI9FToeFSm4+5rHybChumLO15Oue7lB0NEEEdnO2V+CoJw7uYHtRn4sgJBD53hwrDBngyxC27oCLxdebVOYvN48xsetKcs1Tmxgmam/Y2zvckhzD4LhCXZ5txIQJVUOyLBKm89JCaLfOfRVIAFOmVaSQoKGEuPvrFfqEurAvMh6wpW6mpf2bMeS1JKLhIE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 979f6013-5d4a-425c-28e6-08d7268f4ff9
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 23:28:46.1911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: no7C971kE75G4u1cg2ZD3dKclvSkySELi4jdXCt52bpLQK2UoIXnSwlh6sEvi8NYhJYeiy7NH74uiObZWEvpDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2674
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

In order to remove dependency on rtnl lock and allow neigh update workqueue
task to execute concurrently with tc, refactor mlx5e_rep_neigh_update() for
concurrent execution:

- Lock encap table when accessing encap entry to prevent concurrent
  changes. To do this properly, the initial encap state check is moved from
  mlx5e_rep_neigh_update() into mlx5e_rep_update_flows() to be performed
  under encap_tbl_lock protection.

- Wait for encap to be fully initialized before accessing it by means of
  'res_ready' completion.

- Add mlx5e_take_all_encap_flows() helper which is used to construct a
  temporary list of flows and efi indexes that is used to access current
  encap data in flow which can be attached to multiple encaps
  simultaneously. Release the flows from temporary list after
  encap_tbl_lock critical section. This is necessary because
  mlx5e_flow_put() can't be called while holding encap_tbl_lock.

- Modify mlx5e_tc_encap_flows_add() and mlx5e_tc_encap_flows_del() to work
  with user-provided list of flows built by mlx5e_take_all_encap_flows(),
  instead of traversing encap flow list directly.

This is first step in complex neigh update refactoring, which is finished
by following commit in this series.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 29 ++++++---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 59 ++++++++++---------
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  9 ++-
 3 files changed, 59 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index f26edf458152..5217f39828a4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -595,12 +595,26 @@ static void mlx5e_rep_update_flows(struct mlx5e_priv =
*priv,
 				   unsigned char ha[ETH_ALEN])
 {
 	struct ethhdr *eth =3D (struct ethhdr *)e->encap_header;
+	struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch;
+	bool encap_connected;
+	LIST_HEAD(flow_list);
=20
 	ASSERT_RTNL();
=20
+	/* wait for encap to be fully initialized */
+	wait_for_completion(&e->res_ready);
+
+	mutex_lock(&esw->offloads.encap_tbl_lock);
+	encap_connected =3D !!(e->flags & MLX5_ENCAP_ENTRY_VALID);
+	if (e->compl_result || (encap_connected =3D=3D neigh_connected &&
+				ether_addr_equal(e->h_dest, ha)))
+		goto unlock;
+
+	mlx5e_take_all_encap_flows(e, &flow_list);
+
 	if ((e->flags & MLX5_ENCAP_ENTRY_VALID) &&
 	    (!neigh_connected || !ether_addr_equal(e->h_dest, ha)))
-		mlx5e_tc_encap_flows_del(priv, e);
+		mlx5e_tc_encap_flows_del(priv, e, &flow_list);
=20
 	if (neigh_connected && !(e->flags & MLX5_ENCAP_ENTRY_VALID)) {
 		ether_addr_copy(e->h_dest, ha);
@@ -610,8 +624,11 @@ static void mlx5e_rep_update_flows(struct mlx5e_priv *=
priv,
 		 */
 		ether_addr_copy(eth->h_source, e->route_dev->dev_addr);
=20
-		mlx5e_tc_encap_flows_add(priv, e);
+		mlx5e_tc_encap_flows_add(priv, e, &flow_list);
 	}
+unlock:
+	mutex_unlock(&esw->offloads.encap_tbl_lock);
+	mlx5e_put_encap_flow_list(priv, &flow_list);
 }
=20
 static void mlx5e_rep_neigh_update(struct work_struct *work)
@@ -623,7 +640,6 @@ static void mlx5e_rep_neigh_update(struct work_struct *=
work)
 	unsigned char ha[ETH_ALEN];
 	struct mlx5e_priv *priv;
 	bool neigh_connected;
-	bool encap_connected;
 	u8 nud_state, dead;
=20
 	rtnl_lock();
@@ -645,13 +661,8 @@ static void mlx5e_rep_neigh_update(struct work_struct =
*work)
 		if (!mlx5e_encap_take(e))
 			continue;
=20
-		encap_connected =3D !!(e->flags & MLX5_ENCAP_ENTRY_VALID);
 		priv =3D netdev_priv(e->out_dev);
-
-		if (encap_connected !=3D neigh_connected ||
-		    !ether_addr_equal(e->h_dest, ha))
-			mlx5e_rep_update_flows(priv, e, neigh_connected, ha);
-
+		mlx5e_rep_update_flows(priv, e, neigh_connected, ha);
 		mlx5e_encap_put(priv, e);
 	}
 	mlx5e_rep_neigh_entry_release(nhe);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 3a562189af71..b63bae05955b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -126,6 +126,7 @@ struct mlx5e_tc_flow {
 	struct list_head	hairpin; /* flows sharing the same hairpin */
 	struct list_head	peer;    /* flows with peer flow */
 	struct list_head	unready; /* flows not ready to be offloaded (e.g due to =
missing route) */
+	int			tmp_efi_index;
 	struct list_head	tmp_list; /* temporary flow list used by neigh update */
 	refcount_t		refcnt;
 	struct rcu_head		rcu_head;
@@ -1291,11 +1292,11 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv=
 *priv,
 }
=20
 void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
-			      struct mlx5e_encap_entry *e)
+			      struct mlx5e_encap_entry *e,
+			      struct list_head *flow_list)
 {
 	struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch;
 	struct mlx5_esw_flow_attr slow_attr, *esw_attr;
-	struct encap_flow_item *efi, *tmp;
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
 	struct mlx5e_tc_flow *flow;
@@ -1314,19 +1315,15 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *pr=
iv,
 	e->flags |=3D MLX5_ENCAP_ENTRY_VALID;
 	mlx5e_rep_queue_neigh_stats_work(priv);
=20
-	list_for_each_entry_safe(efi, tmp, &e->flows, list) {
+	list_for_each_entry(flow, flow_list, tmp_list) {
 		bool all_flow_encaps_valid =3D true;
 		int i;
=20
-		flow =3D container_of(efi, struct mlx5e_tc_flow, encaps[efi->index]);
-		if (IS_ERR(mlx5e_flow_get(flow)))
-			continue;
-
 		esw_attr =3D flow->esw_attr;
 		spec =3D &esw_attr->parse_attr->spec;
=20
-		esw_attr->dests[efi->index].encap_id =3D e->encap_id;
-		esw_attr->dests[efi->index].flags |=3D MLX5_ESW_DEST_ENCAP_VALID;
+		esw_attr->dests[flow->tmp_efi_index].encap_id =3D e->encap_id;
+		esw_attr->dests[flow->tmp_efi_index].flags |=3D MLX5_ESW_DEST_ENCAP_VALI=
D;
 		/* Flow can be associated with multiple encap entries.
 		 * Before offloading the flow verify that all of them have
 		 * a valid neighbour.
@@ -1341,63 +1338,53 @@ void mlx5e_tc_encap_flows_add(struct mlx5e_priv *pr=
iv,
 		}
 		/* Do not offload flows with unresolved neighbors */
 		if (!all_flow_encaps_valid)
-			goto loop_cont;
+			continue;
 		/* update from slow path rule to encap rule */
 		rule =3D mlx5e_tc_offload_fdb_rules(esw, flow, spec, esw_attr);
 		if (IS_ERR(rule)) {
 			err =3D PTR_ERR(rule);
 			mlx5_core_warn(priv->mdev, "Failed to update cached encapsulation flow,=
 %d\n",
 				       err);
-			goto loop_cont;
+			continue;
 		}
=20
 		mlx5e_tc_unoffload_from_slow_path(esw, flow, &slow_attr);
 		flow->rule[0] =3D rule;
 		/* was unset when slow path rule removed */
 		flow_flag_set(flow, OFFLOADED);
-
-loop_cont:
-		mlx5e_flow_put(priv, flow);
 	}
 }
=20
 void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
-			      struct mlx5e_encap_entry *e)
+			      struct mlx5e_encap_entry *e,
+			      struct list_head *flow_list)
 {
 	struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch;
 	struct mlx5_esw_flow_attr slow_attr;
-	struct encap_flow_item *efi, *tmp;
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
 	struct mlx5e_tc_flow *flow;
 	int err;
=20
-	list_for_each_entry_safe(efi, tmp, &e->flows, list) {
-		flow =3D container_of(efi, struct mlx5e_tc_flow, encaps[efi->index]);
-		if (IS_ERR(mlx5e_flow_get(flow)))
-			continue;
-
+	list_for_each_entry(flow, flow_list, tmp_list) {
 		spec =3D &flow->esw_attr->parse_attr->spec;
=20
 		/* update from encap rule to slow path rule */
 		rule =3D mlx5e_tc_offload_to_slow_path(esw, flow, spec, &slow_attr);
 		/* mark the flow's encap dest as non-valid */
-		flow->esw_attr->dests[efi->index].flags &=3D ~MLX5_ESW_DEST_ENCAP_VALID;
+		flow->esw_attr->dests[flow->tmp_efi_index].flags &=3D ~MLX5_ESW_DEST_ENC=
AP_VALID;
=20
 		if (IS_ERR(rule)) {
 			err =3D PTR_ERR(rule);
 			mlx5_core_warn(priv->mdev, "Failed to update slow path (encap) flow, %d=
\n",
 				       err);
-			goto loop_cont;
+			continue;
 		}
=20
 		mlx5e_tc_unoffload_fdb_rules(esw, flow, flow->esw_attr);
 		flow->rule[0] =3D rule;
 		/* was unset when fast path rule removed */
 		flow_flag_set(flow, OFFLOADED);
-
-loop_cont:
-		mlx5e_flow_put(priv, flow);
 	}
=20
 	/* we know that the encap is valid */
@@ -1413,8 +1400,26 @@ static struct mlx5_fc *mlx5e_tc_get_counter(struct m=
lx5e_tc_flow *flow)
 		return flow->nic_attr->counter;
 }
=20
+/* Takes reference to all flows attached to encap and adds the flows to
+ * flow_list using 'tmp_list' list_head in mlx5e_tc_flow.
+ */
+void mlx5e_take_all_encap_flows(struct mlx5e_encap_entry *e, struct list_h=
ead *flow_list)
+{
+	struct encap_flow_item *efi;
+	struct mlx5e_tc_flow *flow;
+
+	list_for_each_entry(efi, &e->flows, list) {
+		flow =3D container_of(efi, struct mlx5e_tc_flow, encaps[efi->index]);
+		if (IS_ERR(mlx5e_flow_get(flow)))
+			continue;
+
+		flow->tmp_efi_index =3D efi->index;
+		list_add(&flow->tmp_list, flow_list);
+	}
+}
+
 /* Iterate over tmp_list of flows attached to flow_list head. */
-static void mlx5e_put_encap_flow_list(struct mlx5e_priv *priv, struct list=
_head *flow_list)
+void mlx5e_put_encap_flow_list(struct mlx5e_priv *priv, struct list_head *=
flow_list)
 {
 	struct mlx5e_tc_flow *flow, *tmp;
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.h
index ea2072e2fe84..924c6ef86a14 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -72,12 +72,17 @@ void mlx5e_tc_stats_matchall(struct mlx5e_priv *priv,
=20
 struct mlx5e_encap_entry;
 void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
-			      struct mlx5e_encap_entry *e);
+			      struct mlx5e_encap_entry *e,
+			      struct list_head *flow_list);
 void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
-			      struct mlx5e_encap_entry *e);
+			      struct mlx5e_encap_entry *e,
+			      struct list_head *flow_list);
 bool mlx5e_encap_take(struct mlx5e_encap_entry *e);
 void mlx5e_encap_put(struct mlx5e_priv *priv, struct mlx5e_encap_entry *e)=
;
=20
+void mlx5e_take_all_encap_flows(struct mlx5e_encap_entry *e, struct list_h=
ead *flow_list);
+void mlx5e_put_encap_flow_list(struct mlx5e_priv *priv, struct list_head *=
flow_list);
+
 struct mlx5e_neigh_hash_entry;
 void mlx5e_tc_update_neigh_used_value(struct mlx5e_neigh_hash_entry *nhe);
=20
--=20
2.21.0

