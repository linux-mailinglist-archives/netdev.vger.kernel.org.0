Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7890B987D8
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731464AbfHUX2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:28:50 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:35598
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729076AbfHUX2t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 19:28:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Savp0r641SnJXrdD7m0myv+YxtLVYEe5w+LUQ1qM1NY4eAnSOj6B/UEZGzEyuGmhUU1lV4HyXf+PyHQdpWEP6MrIXkKurlft+gMluul4hg4T1ONN7/iwrU8gOI7G+XPOKvTMb5qlpQ8AS5UotBheBufcGH6wZoX4NH2+mwhLEWLbpiKoROgj5CKK/6g935zF+5X6S68h2R9K0b5fhHUOWWi948vwhqz02ANu/zWwCvhasjp37NLtTM0PJ6xUGJauKWzgXk38RxrKm0nQd8ns8CfEbyGWnDmuNYLRqoi6DjsVBoGZJ0CjpEkZGpLQGvcPJlThgyro31UkFBa+WAWiAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZjThKLNRRnmx37LFFwVCcp3oFJY/+/HB1+SDbktQka0=;
 b=gAF2QfTptTaevY/v5sklM/H0Aafb66gEyutkB7DXptDsJeRV+Fat38gqgRodk+80QRSIFgQxry7zxRvzfR1PWn8tzAkLBwaboLc7PhK7c9AQW4M6+PIF4dmLH0CQ0AQHqGQ6Ud0aeLvr3X7Q/U++wBx+lfTjxQaDxpvqVpQKTxUEQ3/YDWyfodZhosC6SdI2osPE8SoW9FHhp0nzPq3G13AlvZAen8PXrKhMlGFlb8RYMmVXrt+LFLg2d18/k6gKGTJSCjllu21UwhdXnpzR75pvNftVYRdlAw+lsqhHDxfxfw31cK4YZFV+qUvVLTlYiQtrjG2utZGHtxDxoUzcBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZjThKLNRRnmx37LFFwVCcp3oFJY/+/HB1+SDbktQka0=;
 b=aTB9EzpqcDn0Eqyo1ZDHKqAZ/NOSJJYf1YKNs9A/wScwBJlJaxg6UBcCyJN7WllLgEwaz/Tx0uSYF27XVfEKpOXAwCNKzfgkGL6tNNbzLS2rcUe5noryEmm8YAE6gLbADN6ZzT7P4kaLEFgeYD+0m73HbZmTZ6W7ycdKAUL3liQ=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2674.eurprd05.prod.outlook.com (10.172.221.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 21 Aug 2019 23:28:42 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 23:28:42 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/11] net/mlx5e: Protect neigh hash encap list with
 spinlock and rcu
Thread-Topic: [net-next 05/11] net/mlx5e: Protect neigh hash encap list with
 spinlock and rcu
Thread-Index: AQHVWHgrbsNP5jHv+kmYtuYDwDMaxQ==
Date:   Wed, 21 Aug 2019 23:28:42 +0000
Message-ID: <20190821232806.21847-6-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 035ea886-25ff-4b5b-3660-08d7268f4db4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2674;
x-ms-traffictypediagnostic: AM4PR0501MB2674:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB26745A20DD59FA9866E399FDBEAA0@AM4PR0501MB2674.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(50226002)(5660300002)(6512007)(86362001)(3846002)(6116002)(305945005)(14444005)(66946007)(66556008)(7736002)(66476007)(256004)(66446008)(64756008)(66066001)(1076003)(71200400001)(71190400001)(5024004)(4326008)(478600001)(6916009)(8936002)(6486002)(107886003)(2906002)(2616005)(81156014)(81166006)(8676002)(476003)(6506007)(386003)(99286004)(52116002)(26005)(486006)(53936002)(76176011)(316002)(36756003)(25786009)(186003)(54906003)(14454004)(102836004)(446003)(6436002)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2674;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aCNFnvJDAtB6fvIntTlYE0JitBLzj8Gq85YlHXlQNsrIuB648TtsgQkVK6PLP5zVQvGjFh6gaRII4W8TYHJN/FBLZkhnzIwKsTrAa/27ANk2Z1fWRfcr1vbS1HP7GYyaK1nw2+OBs0YA3axfwFZJa4lowQxcqYPFgXPsWAhsmZEa/B47gouBOnKLj50nmpLo2kOKHBAnQfiDiKEj0pka8jEctgYuRI0fFTpurijaG7MpxiUs64E4h5FLomLEXNf0fjZFLTl+vfq/yiNL1XVBcvZ11+pt7TvJGFpkA+ecPpVSoBWn0mwJyJkZR+y2tkyJ0RGdRbYGWDWAMvE42DIPCYmaJlsJRqVqTUVlQmIyNT7ffTsCqs1swDhwwX/x+vU4oGi3KeRUpG5XxFrozmnJLtOkNw8sPIF3F+mSoU3pXzo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 035ea886-25ff-4b5b-3660-08d7268f4db4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 23:28:42.3918
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0mrkUz1hJ78BjI1nRFhJqydmL5HKjRV8Ai0ecH7HlWa8uO6O18eOBPGMY+Fcjp0TK9JvVWE+2IXe8dBI4WetCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2674
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

Rcu-ify mlx5e_neigh_hash_entry->encap_list by changing operations on encap
list to their rcu counterparts and extending encap structure with rcu_head
to free the encap instances after rcu grace period. Use rcu read lock when
traversing encap list. Implement helper mlx5e_get_next_valid_encap()
function that is used by mlx5e_tc_update_neigh_used_value() to safely
iterate over valid entries of nhe->encap_list.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 10 ++-
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  3 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 64 ++++++++++++++++---
 3 files changed, 66 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index 218772d5c062..f26edf458152 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1064,6 +1064,7 @@ static int mlx5e_rep_neigh_entry_create(struct mlx5e_=
priv *priv,
 	(*nhe)->priv =3D priv;
 	memcpy(&(*nhe)->m_neigh, &e->m_neigh, sizeof(e->m_neigh));
 	INIT_WORK(&(*nhe)->neigh_update_work, mlx5e_rep_neigh_update);
+	spin_lock_init(&(*nhe)->encap_list_lock);
 	INIT_LIST_HEAD(&(*nhe)->encap_list);
 	refcount_set(&(*nhe)->refcnt, 1);
=20
@@ -1103,7 +1104,10 @@ int mlx5e_rep_encap_entry_attach(struct mlx5e_priv *=
priv,
 	}
=20
 	e->nhe =3D nhe;
-	list_add(&e->encap_list, &nhe->encap_list);
+	spin_lock(&nhe->encap_list_lock);
+	list_add_rcu(&e->encap_list, &nhe->encap_list);
+	spin_unlock(&nhe->encap_list_lock);
+
 	mutex_unlock(&rpriv->neigh_update.encap_lock);
=20
 	return 0;
@@ -1119,7 +1123,9 @@ void mlx5e_rep_encap_entry_detach(struct mlx5e_priv *=
priv,
 	if (!e->nhe)
 		return;
=20
-	list_del(&e->encap_list);
+	spin_lock(&e->nhe->encap_list_lock);
+	list_del_rcu(&e->encap_list);
+	spin_unlock(&e->nhe->encap_list_lock);
=20
 	mlx5e_rep_neigh_entry_release(e->nhe);
 	e->nhe =3D NULL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.h
index 8fa27832bd81..a0ae5069d8c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -119,6 +119,8 @@ struct mlx5e_neigh_hash_entry {
 	 */
 	struct list_head neigh_list;
=20
+	/* protects encap list */
+	spinlock_t encap_list_lock;
 	/* encap list sharing the same neigh */
 	struct list_head encap_list;
=20
@@ -173,6 +175,7 @@ struct mlx5e_encap_entry {
 	refcount_t refcnt;
 	struct completion res_ready;
 	int compl_result;
+	struct rcu_head rcu;
 };
=20
 struct mlx5e_rep_sq {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 3917834b48ff..a4d11274be30 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1412,11 +1412,56 @@ static struct mlx5_fc *mlx5e_tc_get_counter(struct =
mlx5e_tc_flow *flow)
 		return flow->nic_attr->counter;
 }
=20
+static struct mlx5e_encap_entry *
+mlx5e_get_next_valid_encap(struct mlx5e_neigh_hash_entry *nhe,
+			   struct mlx5e_encap_entry *e)
+{
+	struct mlx5e_encap_entry *next =3D NULL;
+
+retry:
+	rcu_read_lock();
+
+	/* find encap with non-zero reference counter value */
+	for (next =3D e ?
+		     list_next_or_null_rcu(&nhe->encap_list,
+					   &e->encap_list,
+					   struct mlx5e_encap_entry,
+					   encap_list) :
+		     list_first_or_null_rcu(&nhe->encap_list,
+					    struct mlx5e_encap_entry,
+					    encap_list);
+	     next;
+	     next =3D list_next_or_null_rcu(&nhe->encap_list,
+					  &next->encap_list,
+					  struct mlx5e_encap_entry,
+					  encap_list))
+		if (mlx5e_encap_take(next))
+			break;
+
+	rcu_read_unlock();
+
+	/* release starting encap */
+	if (e)
+		mlx5e_encap_put(netdev_priv(e->out_dev), e);
+	if (!next)
+		return next;
+
+	/* wait for encap to be fully initialized */
+	wait_for_completion(&next->res_ready);
+	/* continue searching if encap entry is not in valid state after completi=
on */
+	if (!(next->flags & MLX5_ENCAP_ENTRY_VALID)) {
+		e =3D next;
+		goto retry;
+	}
+
+	return next;
+}
+
 void mlx5e_tc_update_neigh_used_value(struct mlx5e_neigh_hash_entry *nhe)
 {
 	struct mlx5e_neigh *m_neigh =3D &nhe->m_neigh;
+	struct mlx5e_encap_entry *e =3D NULL;
 	struct mlx5e_tc_flow *flow;
-	struct mlx5e_encap_entry *e;
 	struct mlx5_fc *counter;
 	struct neigh_table *tbl;
 	bool neigh_used =3D false;
@@ -1432,13 +1477,12 @@ void mlx5e_tc_update_neigh_used_value(struct mlx5e_=
neigh_hash_entry *nhe)
 	else
 		return;
=20
-	list_for_each_entry(e, &nhe->encap_list, encap_list) {
+	/* mlx5e_get_next_valid_encap() releases previous encap before returning
+	 * next one.
+	 */
+	while ((e =3D mlx5e_get_next_valid_encap(nhe, e)) !=3D NULL) {
 		struct encap_flow_item *efi, *tmp;
=20
-		if (!(e->flags & MLX5_ENCAP_ENTRY_VALID) ||
-		    !mlx5e_encap_take(e))
-			continue;
-
 		list_for_each_entry_safe(efi, tmp, &e->flows, list) {
 			flow =3D container_of(efi, struct mlx5e_tc_flow,
 					    encaps[efi->index]);
@@ -1458,9 +1502,11 @@ void mlx5e_tc_update_neigh_used_value(struct mlx5e_n=
eigh_hash_entry *nhe)
 			mlx5e_flow_put(netdev_priv(e->out_dev), flow);
 		}
=20
-		mlx5e_encap_put(netdev_priv(e->out_dev), e);
-		if (neigh_used)
+		if (neigh_used) {
+			/* release current encap before breaking the loop */
+			mlx5e_encap_put(netdev_priv(e->out_dev), e);
 			break;
+		}
 	}
=20
 	if (neigh_used) {
@@ -1490,7 +1536,7 @@ static void mlx5e_encap_dealloc(struct mlx5e_priv *pr=
iv, struct mlx5e_encap_entr
 	}
=20
 	kfree(e->encap_header);
-	kfree(e);
+	kfree_rcu(e, rcu);
 }
=20
 void mlx5e_encap_put(struct mlx5e_priv *priv, struct mlx5e_encap_entry *e)
--=20
2.21.0

