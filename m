Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00D3C987D9
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730620AbfHUX2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:28:52 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:35598
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730432AbfHUX2v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 19:28:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=heXE2D20fIH1ASKU5RGcXHGOZmaQMmPuhjrfCThXjnmKF7Jg5BBi//5q0hfrXH7xNSf/GnwAhro9BsIbLzbvYbdkuPVspQ648DPllewqxBu6fHp+cgf/H2azSJDZWP/5z38RyyrZ85dALE6DdXAl7A35IdSuaQKYA7JFplLzndrxNqzKs2x9r90/omMS9q55PKrZe57+ou3C501JlZI3A24Nm5fM9E5bXdvVxeaWEG4jaKwIkdw5sdKdM6y2K2IWDl/OfzYpr/JqVFnsal1gCMIlKSXxg24SuWLWqU8xoPJfzo1hR3qd23K+7E07IxhYhFvtUI2QxkS80z4GmK81uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AY2ndb0Lni6QbWsSLkJra3RRHV3LuInjQcLYdvqF4A4=;
 b=MHAazzkAUP1pRSLXEoqEI/523LbktHm9UTgVV7xwQvod5wk+7PhZXt8ZknKtXf6lRW4AbFlWlsIouIMVhpQ/LzA87IaIRvsbRhUhpJ15OcMzuF8H/6mWzlCFTSkzNWWZoflr0W3CvXz59r2rv8GcrWiYVie3zWdpvMRIMpdhCPY3t2CaLPFd1s4C4NJe1s3OnUBsfZG5aIhdScWUbZ7ayzIOZEcYgeIOkbL2RR1xXQ60w9Q9MLaQzcRTxIceJQVt8dmMhuY7EGslbAu+NM+JK5f+ltYY4/LO6ZxjsMTfk4XME+rQv0nT851QKLs/dnkrC6p+ld9AMo6u3AX/Nx28iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AY2ndb0Lni6QbWsSLkJra3RRHV3LuInjQcLYdvqF4A4=;
 b=L1JJ9FlC+5EbL9doROUxZk1eP5hpnAlrkQ4yMmTXEEz449nmreA4RE2uab9leHyjy0gjq91GdM9UaVZrrLH0zg0OKeV49DgACBpyP86u1VWU8McYzRP/yfy0eHVeM2Ukb7TWvDE2TBq/TY+xkTz5BGCWjJz42e1lYwnxGWi7QUs=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2674.eurprd05.prod.outlook.com (10.172.221.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 21 Aug 2019 23:28:44 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 23:28:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/11] net/mlx5e: Refactor neigh used value update for
 concurrent execution
Thread-Topic: [net-next 06/11] net/mlx5e: Refactor neigh used value update for
 concurrent execution
Thread-Index: AQHVWHgsEolbq3TLqEql4yvU+BHa3w==
Date:   Wed, 21 Aug 2019 23:28:44 +0000
Message-ID: <20190821232806.21847-7-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: c6369591-f0cd-4eb3-605e-08d7268f4ebc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2674;
x-ms-traffictypediagnostic: AM4PR0501MB2674:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2674BE8EE3B055FE4816B099BEAA0@AM4PR0501MB2674.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(15650500001)(50226002)(5660300002)(6512007)(86362001)(3846002)(6116002)(305945005)(14444005)(66946007)(66556008)(7736002)(66476007)(256004)(66446008)(64756008)(66066001)(1076003)(71200400001)(71190400001)(5024004)(4326008)(478600001)(6916009)(8936002)(6486002)(107886003)(2906002)(2616005)(81156014)(81166006)(8676002)(476003)(6506007)(386003)(99286004)(52116002)(26005)(486006)(53936002)(76176011)(316002)(36756003)(25786009)(186003)(54906003)(14454004)(102836004)(446003)(6436002)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2674;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hj/TS7l7voBTifFUaiJiecJMCaMcqllVZs2Z+ppFj6MzPZvfHDodcOoPC5Ix2Ny4RlKJIJs1P0Dt0CORzSX8beXPt6H/e5tlKe4+k8eOhLnl3DChLk7Vvp4gj2EYy6ngw6oSDoAyb+7j6FSHtWSZpUopzmrG2sXZY39fV6WxWovzHaSyWc6N4FNs6DkOtxS8lEN6rxwIIs30inm5ustKEtLdw+dne6jJ4nP7oJFGxkBgA2pzqNIoKMXopNnOTADUnEMVOnmO9fAIGxIfAZXQFho5K/VsBG9hwSb+KvEGdWW8jU1iyhzTJi5CTwTIEMesK38cfnr9iK0YvHuD4bV12vFpTQq/o1wGSiyD9zvpX/DDBfixIj7E7JYZD1vhBeDsHgqUybB/4aNMQxOb6gVqGvELJqaMXm+RGLVNqHD3bFg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6369591-f0cd-4eb3-605e-08d7268f4ebc
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 23:28:44.2720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B9KldjnQzEC6C4RMKkbwjiZFJHlBavXvXzGs+WdodRVwP3mlpsf/LQgzNYu1ouaxpAJnwtFx2kRG2L/4NjhoRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2674
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

In order to remove dependency on rtnl lock and allow neigh used value
update workqueue task to execute concurrently with tc, refactor
mlx5e_tc_update_neigh_used_value() for concurrent execution:

- Lock encap table when accessing encap entry to prevent concurrent
  changes.

- Save offloaded encap flows to temporary list and release them after encap
  entry is updated. Add mlx5e_put_encap_flow_list() helper which is
  intended to be shared with neigh update code in following patch in this
  series. This is necessary because mlx5e_flow_put() can't be called while
  holding encap_tbl_lock.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 23 +++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index a4d11274be30..3a562189af71 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -126,6 +126,7 @@ struct mlx5e_tc_flow {
 	struct list_head	hairpin; /* flows sharing the same hairpin */
 	struct list_head	peer;    /* flows with peer flow */
 	struct list_head	unready; /* flows not ready to be offloaded (e.g due to =
missing route) */
+	struct list_head	tmp_list; /* temporary flow list used by neigh update */
 	refcount_t		refcnt;
 	struct rcu_head		rcu_head;
 	union {
@@ -1412,6 +1413,15 @@ static struct mlx5_fc *mlx5e_tc_get_counter(struct m=
lx5e_tc_flow *flow)
 		return flow->nic_attr->counter;
 }
=20
+/* Iterate over tmp_list of flows attached to flow_list head. */
+static void mlx5e_put_encap_flow_list(struct mlx5e_priv *priv, struct list=
_head *flow_list)
+{
+	struct mlx5e_tc_flow *flow, *tmp;
+
+	list_for_each_entry_safe(flow, tmp, flow_list, tmp_list)
+		mlx5e_flow_put(priv, flow);
+}
+
 static struct mlx5e_encap_entry *
 mlx5e_get_next_valid_encap(struct mlx5e_neigh_hash_entry *nhe,
 			   struct mlx5e_encap_entry *e)
@@ -1481,30 +1491,35 @@ void mlx5e_tc_update_neigh_used_value(struct mlx5e_=
neigh_hash_entry *nhe)
 	 * next one.
 	 */
 	while ((e =3D mlx5e_get_next_valid_encap(nhe, e)) !=3D NULL) {
+		struct mlx5e_priv *priv =3D netdev_priv(e->out_dev);
 		struct encap_flow_item *efi, *tmp;
+		struct mlx5_eswitch *esw;
+		LIST_HEAD(flow_list);
=20
+		esw =3D priv->mdev->priv.eswitch;
+		mutex_lock(&esw->offloads.encap_tbl_lock);
 		list_for_each_entry_safe(efi, tmp, &e->flows, list) {
 			flow =3D container_of(efi, struct mlx5e_tc_flow,
 					    encaps[efi->index]);
 			if (IS_ERR(mlx5e_flow_get(flow)))
 				continue;
+			list_add(&flow->tmp_list, &flow_list);
=20
 			if (mlx5e_is_offloaded_flow(flow)) {
 				counter =3D mlx5e_tc_get_counter(flow);
 				lastuse =3D mlx5_fc_query_lastuse(counter);
 				if (time_after((unsigned long)lastuse, nhe->reported_lastuse)) {
-					mlx5e_flow_put(netdev_priv(e->out_dev), flow);
 					neigh_used =3D true;
 					break;
 				}
 			}
-
-			mlx5e_flow_put(netdev_priv(e->out_dev), flow);
 		}
+		mutex_unlock(&esw->offloads.encap_tbl_lock);
=20
+		mlx5e_put_encap_flow_list(priv, &flow_list);
 		if (neigh_used) {
 			/* release current encap before breaking the loop */
-			mlx5e_encap_put(netdev_priv(e->out_dev), e);
+			mlx5e_encap_put(priv, e);
 			break;
 		}
 	}
--=20
2.21.0

