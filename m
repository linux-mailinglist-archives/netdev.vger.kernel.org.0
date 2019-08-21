Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 061A9987D6
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 01:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731459AbfHUX2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 19:28:44 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:35598
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729076AbfHUX2o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 19:28:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dszJpk55pWYgPni40RNNSsTrGWWH3Y97PGcnHX4jbjXzmykIZd+8cyH97p4Vz5vJZxeZ/1HSsRlOFhuXQoyXYTn4tnLhPfBVln1edaSwJ3rEk/iRrwhH0crCDb1mrHPIJinTGe43IHaXYc70GzswCFF4wViZH8mTbEJmKDT38P35xf3U0R1xBNxeR6+1IbnwRwrca7p+kzYOcFg9hijLa6sKYM58D/H6E2hDpLyI664sKJybjreeF2awobDvZAWemud0tg/NyD2Gx9U6l+JCHXRgvWan27J3ncfNSco7GIxyhyAC5oiMvUZ0k0izWYIa6rlEdxsw7Brc4Btcz7xKPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpmG7oWwAxAQPP5Rh1QCuu/PW1lIHzh+NIA3ASAx9zA=;
 b=adGF/m2P5pDhxkmimqAy7owvwGgBmZnZzngqUqvHKTIrDXNrS9uXzYbjdrlj9FpvaCEsi3BiS012/eyOQdXvlWZUfRsd5BnKxdZGoKt/yvn1/495QpDZRZl9kJvxtrinutqZ44vzCKveBnWldoqLPZRO9VV1zQ9cOZW7ff+8qDhJnStSLFW6HNr8pY6ndxJ/HX/rNUKlIi9V8lIG9HbTt6RCGmDe0SvieH19M/CdYFYhU4DH+pr82zB8BsjQCO5NgMeON4SBs7LMwOkKehSbaVx6rumXRbEZtaZp0gyycnUCzJDtWQHJ5rvCFKivj93HkrmufTpZnXE/zgEyabGjeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpmG7oWwAxAQPP5Rh1QCuu/PW1lIHzh+NIA3ASAx9zA=;
 b=OEnrbBwPiywroiFf+xOFdCnXP/XM3pSjinWe0F1+woh/VLElTJiCPIy4GI/cT6QZPAuWLo0Wpu61v4/Bfza/E2/58Y6hXfARiPjzIZYhgAyU18cxlh/S91EQ1EGCpiyNwfVlTWiwfNuBRt7BOYAQKDPSJUK6awh8DCRoixbb9+4=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2674.eurprd05.prod.outlook.com (10.172.221.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 21 Aug 2019 23:28:38 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 23:28:38 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/11] net/mlx5e: Extend neigh hash entry with rcu
Thread-Topic: [net-next 03/11] net/mlx5e: Extend neigh hash entry with rcu
Thread-Index: AQHVWHgoZmp9WZZshU+mZA6HHnBW5w==
Date:   Wed, 21 Aug 2019 23:28:38 +0000
Message-ID: <20190821232806.21847-4-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: e32cf8f8-2033-417d-005b-08d7268f4b3e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2674;
x-ms-traffictypediagnostic: AM4PR0501MB2674:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2674E00A7B14CBABBF0E5085BEAA0@AM4PR0501MB2674.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(50226002)(5660300002)(6512007)(86362001)(3846002)(6116002)(305945005)(14444005)(66946007)(66556008)(7736002)(66476007)(256004)(66446008)(64756008)(66066001)(1076003)(71200400001)(71190400001)(4326008)(478600001)(6916009)(8936002)(6486002)(107886003)(2906002)(2616005)(81156014)(81166006)(8676002)(476003)(6506007)(386003)(99286004)(52116002)(26005)(486006)(53936002)(76176011)(316002)(36756003)(25786009)(186003)(54906003)(14454004)(102836004)(446003)(6436002)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2674;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6+ucuWNnIc48Rq7Fe+h/mUIQzSZHgE77u6JlKKxGsxPziKqvaPQGD43tVD5YhbzE6Ob/jKiDwAjmAHJY71AFAMNmcUhIC3FfDdQGB6Nh0qmEHmjofmx9l/lTUwLKpDsdsNV++LxvriWdwH/0kGT/Sbivz4Ts1FpHGayhQlnzX2mxJPkrBNkUcErt7ar4NYI4pfPWkdGFmd1HSkDpqvfeTcD7IUl1bNfgfO7f0eTy3kb3mC2MsiX5b0dplauvmaatArHa6RBZ2AN6aFXEVuEzlT99C1tYKtxg1ySL/2TWCqsMHu3BQPcfEYfil5YXWkWKtvaUGfD/JVf0bU8oN/tJXYZeEw35HMKv1TPNLYwG8akVBtJuFEjY8WuUG6qbGEZ2miYqd5k3e+I69+x+DEpLhs9oJbxFE0+JFrWJe46/x8Q=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e32cf8f8-2033-417d-005b-08d7268f4b3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 23:28:38.4006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ST7bI6elKwW6nzZD1LjFsj0jmQ90UuNAatDYuybB9hBbVk99k+YyjHriWr7KnwSEFWPO7R3/Qp5VzcQWItg25w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2674
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

To remove dependency on rtnl lock and to allow unlocked iteration over list
of neigh hash entries, extend nhe with rcu. Change operations on neigh list
to their rcu counterparts and free neigh hash entry with rcu timeout.

Introduce mlx5e_get_next_nhe() helper that is used to iterate over rcu
neigh list with reference to nhe taken.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 68 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  2 +
 2 files changed, 46 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index 23087f9abe74..a294dc6b5a0c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -535,28 +535,56 @@ static void mlx5e_rep_neigh_entry_release(struct mlx5=
e_neigh_hash_entry *nhe)
 {
 	if (refcount_dec_and_test(&nhe->refcnt)) {
 		mlx5e_rep_neigh_entry_remove(nhe);
-		kfree(nhe);
+		kfree_rcu(nhe, rcu);
 	}
 }
=20
+static struct mlx5e_neigh_hash_entry *
+mlx5e_get_next_nhe(struct mlx5e_rep_priv *rpriv,
+		   struct mlx5e_neigh_hash_entry *nhe)
+{
+	struct mlx5e_neigh_hash_entry *next =3D NULL;
+
+	rcu_read_lock();
+
+	for (next =3D nhe ?
+		     list_next_or_null_rcu(&rpriv->neigh_update.neigh_list,
+					   &nhe->neigh_list,
+					   struct mlx5e_neigh_hash_entry,
+					   neigh_list) :
+		     list_first_or_null_rcu(&rpriv->neigh_update.neigh_list,
+					    struct mlx5e_neigh_hash_entry,
+					    neigh_list);
+	     next;
+	     next =3D list_next_or_null_rcu(&rpriv->neigh_update.neigh_list,
+					  &next->neigh_list,
+					  struct mlx5e_neigh_hash_entry,
+					  neigh_list))
+		if (mlx5e_rep_neigh_entry_hold(next))
+			break;
+
+	rcu_read_unlock();
+
+	if (nhe)
+		mlx5e_rep_neigh_entry_release(nhe);
+
+	return next;
+}
+
 static void mlx5e_rep_neigh_stats_work(struct work_struct *work)
 {
 	struct mlx5e_rep_priv *rpriv =3D container_of(work, struct mlx5e_rep_priv=
,
 						    neigh_update.neigh_stats_work.work);
 	struct net_device *netdev =3D rpriv->netdev;
 	struct mlx5e_priv *priv =3D netdev_priv(netdev);
-	struct mlx5e_neigh_hash_entry *nhe;
+	struct mlx5e_neigh_hash_entry *nhe =3D NULL;
=20
 	rtnl_lock();
 	if (!list_empty(&rpriv->neigh_update.neigh_list))
 		mlx5e_rep_queue_neigh_stats_work(priv);
=20
-	list_for_each_entry(nhe, &rpriv->neigh_update.neigh_list, neigh_list) {
-		if (mlx5e_rep_neigh_entry_hold(nhe)) {
-			mlx5e_tc_update_neigh_used_value(nhe);
-			mlx5e_rep_neigh_entry_release(nhe);
-		}
-	}
+	while ((nhe =3D mlx5e_get_next_nhe(rpriv, nhe)) !=3D NULL)
+		mlx5e_tc_update_neigh_used_value(nhe);
=20
 	rtnl_unlock();
 }
@@ -883,13 +911,9 @@ static int mlx5e_rep_netevent_event(struct notifier_bl=
ock *nb,
 		m_neigh.family =3D n->ops->family;
 		memcpy(&m_neigh.dst_ip, n->primary_key, n->tbl->key_len);
=20
-		/* We are in atomic context and can't take RTNL mutex, so use
-		 * spin_lock_bh to lookup the neigh table. bh is used since
-		 * netevent can be called from a softirq context.
-		 */
-		spin_lock_bh(&neigh_update->encap_lock);
+		rcu_read_lock();
 		nhe =3D mlx5e_rep_neigh_entry_lookup(priv, &m_neigh);
-		spin_unlock_bh(&neigh_update->encap_lock);
+		rcu_read_unlock();
 		if (!nhe)
 			return NOTIFY_DONE;
=20
@@ -910,19 +934,15 @@ static int mlx5e_rep_netevent_event(struct notifier_b=
lock *nb,
 #endif
 			return NOTIFY_DONE;
=20
-		/* We are in atomic context and can't take RTNL mutex,
-		 * so use spin_lock_bh to walk the neigh list and look for
-		 * the relevant device. bh is used since netevent can be
-		 * called from a softirq context.
-		 */
-		spin_lock_bh(&neigh_update->encap_lock);
-		list_for_each_entry(nhe, &neigh_update->neigh_list, neigh_list) {
+		rcu_read_lock();
+		list_for_each_entry_rcu(nhe, &neigh_update->neigh_list,
+					neigh_list) {
 			if (p->dev =3D=3D nhe->m_neigh.dev) {
 				found =3D true;
 				break;
 			}
 		}
-		spin_unlock_bh(&neigh_update->encap_lock);
+		rcu_read_unlock();
 		if (!found)
 			return NOTIFY_DONE;
=20
@@ -995,7 +1015,7 @@ static int mlx5e_rep_neigh_entry_insert(struct mlx5e_p=
riv *priv,
 	if (err)
 		return err;
=20
-	list_add(&nhe->neigh_list, &rpriv->neigh_update.neigh_list);
+	list_add_rcu(&nhe->neigh_list, &rpriv->neigh_update.neigh_list);
=20
 	return err;
 }
@@ -1006,7 +1026,7 @@ static void mlx5e_rep_neigh_entry_remove(struct mlx5e=
_neigh_hash_entry *nhe)
=20
 	spin_lock_bh(&rpriv->neigh_update.encap_lock);
=20
-	list_del(&nhe->neigh_list);
+	list_del_rcu(&nhe->neigh_list);
=20
 	rhashtable_remove_fast(&rpriv->neigh_update.neigh_ht,
 			       &nhe->rhash_node,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.h
index f5bc9772be98..d057e401b0de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -138,6 +138,8 @@ struct mlx5e_neigh_hash_entry {
 	 * 'used' value and avoid neigh deleting by the kernel.
 	 */
 	unsigned long reported_lastuse;
+
+	struct rcu_head rcu;
 };
=20
 enum {
--=20
2.21.0

