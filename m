Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE0A88593
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbfHIWGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:06:35 -0400
Received: from mail-eopbgr60050.outbound.protection.outlook.com ([40.107.6.50]:49633
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728985AbfHIWGe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 18:06:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hiSsdAAyz6o9almvL6puY3uv3PvVnlaMcGEywx9g9swJYK9q6/guz5cujZcrYG7gMXSJSuMg+vlOM/7tkoZjmg1+D/ifRBtQr62U2OvoOM8kXZ94t/CW7DPGLO7rN+DFMQpRepTmBspCV68HdePHZ71GluHPXEiYhgd0mh3SRiOn+niSm8ugGVcrPYz64/zRhoqWrTfGRTFyndTM6oUNQS4CHUpjN3ii50OkAK57v+akZ3gYEHC8XTPgNq2y4SUc1vxW4d7cWViVfNxH0bmzmnHKGEl7EnDdJyvfAEQ4HGWZj82bKG0bT1bxL4U+mKS3knq0smm5k+65UkXgjsdf5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iba1xIMUNp9IiCfJjAjyCe3VIh5mwvLoEhX0QpCyq1I=;
 b=hwrtKCjG9M77uUCXrojw4MiR0a2D1RjAbFv9ts07OvdE9VjB6oxRoP4TjOdgLsM2KiIo5f5zsOL7oPHuS4Ftd9lnRiJKYpfJc8gBT3ZJmMpPLMrriVV0pk2J1pMFjBPpyWrK85c/gQzMqN0AfbivftdQxNw8cvMmX8BOXENjrWqI+Q7ytUXdF0vRHZ82vc7Uc0pHqJE5IakqFFG3pD852GnDhh91UWEX6AG2gzGWtV1CNseaPvtgGpT/uXPQAZ4tQrShPeNwanbYkcpbRBHm7sefYxwrhn94yOAccHMnKz7pLIbRKIR9fgwiMIY2nh9AHshdwE/WNYGtA1v5bdkWug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iba1xIMUNp9IiCfJjAjyCe3VIh5mwvLoEhX0QpCyq1I=;
 b=n/7PZoVsn58ISq3hHApcWHSdvCvrN/LHB+Q72GWaEy5Oup20x7DWC4SsG+zpO/XD4PDdOGU0/jX7Y/3K8euwdaeuk6T8xwckeEU3ufqk6GLjIp1+prZIuyJShbXxl2X9IaX70pqjeDsoLTZyUNzuHhPFpQiY9UHOSeXgPx9WKfs=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2856.eurprd05.prod.outlook.com (10.172.225.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Fri, 9 Aug 2019 22:04:36 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 22:04:36 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/15] net/mlx5e: Protect encap hash table with mutex
Thread-Topic: [net-next 10/15] net/mlx5e: Protect encap hash table with mutex
Thread-Index: AQHVTv5u9f89NENgwkqNmaGYgZLW+A==
Date:   Fri, 9 Aug 2019 22:04:36 +0000
Message-ID: <20190809220359.11516-11-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 947652ef-4980-4003-5dd0-08d71d1590ec
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2856;
x-ms-traffictypediagnostic: DB6PR0501MB2856:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB285601F9C93E0A80A0644ABABED60@DB6PR0501MB2856.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:449;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(199004)(189003)(2616005)(446003)(316002)(14444005)(256004)(5024004)(64756008)(54906003)(1076003)(476003)(26005)(6512007)(478600001)(186003)(486006)(36756003)(66066001)(6916009)(8936002)(6486002)(8676002)(81166006)(14454004)(71190400001)(50226002)(81156014)(71200400001)(66556008)(66476007)(5660300002)(66946007)(66446008)(52116002)(6436002)(11346002)(102836004)(99286004)(3846002)(107886003)(6116002)(4326008)(86362001)(386003)(7736002)(25786009)(2906002)(76176011)(305945005)(53936002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2856;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0cg6As6bnlgc+K4RLbJOdRwxoLzG6lXqdNLS5k49XwB9T5hR4opfj7vUv/yn6kncawzWFspIA62Ok/yqoEH3N89UK4b0wJPYRJDBUgysEmMVHYomM7lntJ0+kFsMIqI72uMZ0DLmYkFFow6nTLLdZzjymYGbWAHTHwZDwSUTQO9tzd1+d+HlqGeziMWVhGxmpwBgjPpTEaKXwRIAmVK8L/gGZwE6NJRkVsNe38o3eBJG9HO9oGHW2h2VfjcAJWls0+/S9u6h0OBfFxK7gEyRz8fnvB3CTGVr2ocExfnk5M77xiZA8PkdIJCTe7r+3y7PQAQ97eSasdg1+DQey7iIA5VA/P5H68gLAXDbKI14QUaSCRbLUfVlx72DNO0TYTv59k/JO19QN+WTKhc/xIHaCAZsJogQxzvq2nO78kuMTes=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 947652ef-4980-4003-5dd0-08d71d1590ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 22:04:36.0972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hl7ZfCxIev/eypqdMsGSuYGK6MDsJ5afV4HI4yd1Eq5B+gyrOow4w4+ovqdtCUEeFHdQHPBvETRXFY5QE6csEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2856
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

To remove dependency on rtnl lock, protect encap hash table from concurrent
modifications with new "encap_tbl_lock" mutex. Use the mutex to protect
internal encap entry state from concurrent modification. This is necessary
because a flow can be attached to multiple encap entries simultaneously,
which significantly complicates using finer grained per-entry lock.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 43 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  2 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 3 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 4e378200a9d2..c13db9bc1f9b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1478,33 +1478,51 @@ void mlx5e_tc_update_neigh_used_value(struct mlx5e_=
neigh_hash_entry *nhe)
 	}
 }
=20
-void mlx5e_encap_put(struct mlx5e_priv *priv, struct mlx5e_encap_entry *e)
+static void mlx5e_encap_dealloc(struct mlx5e_priv *priv, struct mlx5e_enca=
p_entry *e)
 {
-	if (!refcount_dec_and_test(&e->refcnt))
-		return;
-
 	WARN_ON(!list_empty(&e->flows));
 	mlx5e_rep_encap_entry_detach(netdev_priv(e->out_dev), e);
=20
 	if (e->flags & MLX5_ENCAP_ENTRY_VALID)
 		mlx5_packet_reformat_dealloc(priv->mdev, e->encap_id);
=20
-	hash_del_rcu(&e->encap_hlist);
 	kfree(e->encap_header);
 	kfree(e);
 }
=20
+void mlx5e_encap_put(struct mlx5e_priv *priv, struct mlx5e_encap_entry *e)
+{
+	struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch;
+
+	if (!refcount_dec_and_mutex_lock(&e->refcnt, &esw->offloads.encap_tbl_loc=
k))
+		return;
+	hash_del_rcu(&e->encap_hlist);
+	mutex_unlock(&esw->offloads.encap_tbl_lock);
+
+	mlx5e_encap_dealloc(priv, e);
+}
+
 static void mlx5e_detach_encap(struct mlx5e_priv *priv,
 			       struct mlx5e_tc_flow *flow, int out_index)
 {
+	struct mlx5e_encap_entry *e =3D flow->encaps[out_index].e;
+	struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch;
+
 	/* flow wasn't fully initialized */
-	if (!flow->encaps[out_index].e)
+	if (!e)
 		return;
=20
+	mutex_lock(&esw->offloads.encap_tbl_lock);
 	list_del(&flow->encaps[out_index].list);
-
-	mlx5e_encap_put(priv, flow->encaps[out_index].e);
 	flow->encaps[out_index].e =3D NULL;
+	if (!refcount_dec_and_test(&e->refcnt)) {
+		mutex_unlock(&esw->offloads.encap_tbl_lock);
+		return;
+	}
+	hash_del_rcu(&e->encap_hlist);
+	mutex_unlock(&esw->offloads.encap_tbl_lock);
+
+	mlx5e_encap_dealloc(priv, e);
 }
=20
 static void __mlx5e_tc_del_fdb_peer_flow(struct mlx5e_tc_flow *flow)
@@ -2882,6 +2900,7 @@ static int mlx5e_attach_encap(struct mlx5e_priv *priv=
,
=20
 	hash_key =3D hash_encap_info(&key);
=20
+	mutex_lock(&esw->offloads.encap_tbl_lock);
 	e =3D mlx5e_encap_get(priv, &key, hash_key);
=20
 	/* must verify if encap is valid or not */
@@ -2889,8 +2908,10 @@ static int mlx5e_attach_encap(struct mlx5e_priv *pri=
v,
 		goto attach_flow;
=20
 	e =3D kzalloc(sizeof(*e), GFP_KERNEL);
-	if (!e)
-		return -ENOMEM;
+	if (!e) {
+		err =3D -ENOMEM;
+		goto out_err;
+	}
=20
 	refcount_set(&e->refcnt, 1);
 	e->tun_info =3D tun_info;
@@ -2922,10 +2943,12 @@ static int mlx5e_attach_encap(struct mlx5e_priv *pr=
iv,
 	} else {
 		*encap_valid =3D false;
 	}
+	mutex_unlock(&esw->offloads.encap_tbl_lock);
=20
 	return err;
=20
 out_err:
+	mutex_unlock(&esw->offloads.encap_tbl_lock);
 	kfree(e);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 2d734ecae719..f0692407f617 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1999,6 +1999,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	if (err)
 		goto abort;
=20
+	mutex_init(&esw->offloads.encap_tbl_lock);
 	hash_init(esw->offloads.encap_tbl);
 	mutex_init(&esw->offloads.mod_hdr.lock);
 	hash_init(esw->offloads.mod_hdr.hlist);
@@ -2039,6 +2040,7 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 	destroy_workqueue(esw->work_queue);
 	esw_offloads_cleanup_reps(esw);
 	mutex_destroy(&esw->offloads.mod_hdr.lock);
+	mutex_destroy(&esw->offloads.encap_tbl_lock);
 	kfree(esw->vports);
 	kfree(esw);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index fd63ba4ed0da..86db0e9776da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -181,6 +181,7 @@ struct mlx5_esw_offload {
 	struct mlx5_eswitch_rep *vport_reps;
 	struct list_head peer_flows;
 	struct mutex peer_mutex;
+	struct mutex encap_tbl_lock; /* protects encap_tbl */
 	DECLARE_HASHTABLE(encap_tbl, 8);
 	struct mod_hdr_tbl mod_hdr;
 	DECLARE_HASHTABLE(termtbl_tbl, 8);
--=20
2.21.0

