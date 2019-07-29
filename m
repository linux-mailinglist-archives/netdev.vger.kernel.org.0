Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B22079D0E
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 01:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbfG2Xup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 19:50:45 -0400
Received: from mail-eopbgr130088.outbound.protection.outlook.com ([40.107.13.88]:24063
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729922AbfG2Xun (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 19:50:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EipXT5VExYgnTy3XJUSEFT+XQqj5v8HJM0/HgCcMtoty2Jo6olmFGn/LZe/2aMFDrn56rOe6mj2OsUB9ZbfERxuO4YCaUyvJ1VJ5SJ9lDLzUs8bg2RBdgXzDRm5GfJHGsTxKkceieWSVQGvfif6sjsRq/8u81YO2Pok1vXfdb4val8yfNMctfVr2aVHdPSGF32RcVS/maQI//vF7ozuqeR4BHtlCf2pNeirv6kx8DGWW2RD/MGyQP8yY1Hf7+o9grYpx5IrPYpAGImEDPScLgDUrKJ1bOAL5NaFKCANZuvwW57LB54qZNYjrA356ej1siHnGfG9//5PQnu/x0Xnv9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMRqlyNiW+eBjMwO/nG2ZPxsanSg89w7IWhvVsbHxX0=;
 b=iuV+x+j83eoyanJ8U6AlNU0SXWsP4Y6iuGEnPWGiDvMjmxqecfU8CMQ0FgrhNZtFkHDIGgATQOcvk+Y9Sht4hHwTT+9gkwRRXHXm4Ku3roQ9MdgnhanCU0RE0+0BsECEt/DNzjPwRWz9VuZHw1qKwM0/n7Z97ZRMox2sSIj1Q4srWPUITwworWvXMAnjEEkVPoNZSoXTuo8/pX37mlFpSybQ+l65atgeNDFuBzeQrjR0sPeqKHxBd3f++qraC/IapnXFfnQ4p7pTRzODRT2K6BX9wKmqIsBO5POslhrHbH69YZhM6EB5tTt1/pgJCAQ0WlrEjSAtjwgiIZDqoByJQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMRqlyNiW+eBjMwO/nG2ZPxsanSg89w7IWhvVsbHxX0=;
 b=sZQ39ENyYy0kx/Vyam8tnoUkD+MF/2XbYPEtxkHYMjDpuRr7pWfPg8iLSYQf3pt9kDPcIjghEwT3RREsOifrObqpP9bX3bxZNqmPcpQxWhlwUIedJVIFazuMvxlZiGZW+4oydejIM7N0n97DYSfeTGcP1sTPs0zdLZXlhP+JFyw=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2343.eurprd05.prod.outlook.com (10.168.56.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 23:50:28 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 23:50:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/13] net/mlx5e: Protect tc flows hashtable with rcu
Thread-Topic: [net-next 08/13] net/mlx5e: Protect tc flows hashtable with rcu
Thread-Index: AQHVRmhmeTi75BdH60+Po7jjBFRT4A==
Date:   Mon, 29 Jul 2019 23:50:27 +0000
Message-ID: <20190729234934.23595-9-saeedm@mellanox.com>
References: <20190729234934.23595-1-saeedm@mellanox.com>
In-Reply-To: <20190729234934.23595-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::28) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da7d1e8d-e70a-410c-1d26-08d7147f8850
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2343;
x-ms-traffictypediagnostic: DB6PR0501MB2343:
x-microsoft-antispam-prvs: <DB6PR0501MB23433EF7CF4833DDF58AAFCDBEDD0@DB6PR0501MB2343.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(199004)(189003)(14454004)(25786009)(71190400001)(71200400001)(386003)(6506007)(6512007)(81166006)(81156014)(76176011)(8936002)(6436002)(8676002)(6486002)(316002)(102836004)(54906003)(6916009)(7736002)(478600001)(52116002)(186003)(26005)(99286004)(14444005)(256004)(476003)(5660300002)(1076003)(66446008)(66066001)(66556008)(66476007)(64756008)(36756003)(53936002)(486006)(86362001)(305945005)(107886003)(66946007)(68736007)(446003)(2616005)(11346002)(50226002)(6116002)(3846002)(4326008)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2343;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BYdz/dE+rKILD/DpFfhOxvC0MMT+zuNqOR/wldF4mR3WCvF8gLN7TFd+x7qE3oa/8p0YGS8vf1zf809dmK85ub1XfyXwlTYb5cno6Jg8sFd9pg2CcJTzbszulrgSK5NjGnKrdRroXtiYHCmhN3SUIxQoRUdcvl+NBbpZMOJ9C7FO/37dDSkC1e+zji6EoW/FHVTj8pRNdmKtnFq+f5yEtZVND2srox6iw2jnE5joay8EtEYFmt1ULbvaW4I1kMNNd51sIsBarNUN9JlRY7uAViPMuLzrwdpr//M5kHMcUfsb2PAyV6o9225+Fem+iHW59Q9/W07TsWhgMot6qs+vt4zmvqOMciK3EAJPeFeyUMv3Dulq0iS8NHKY56WxVqor4RfcqcDG01qb/5Ufdfb7ExUZohRYYbWQ3V9w8tgilQo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da7d1e8d-e70a-410c-1d26-08d7147f8850
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 23:50:27.9996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2343
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

In order to remove dependency on rtnl lock, access to tc flows hashtable
must be explicitly protected from concurrent flows removal.

Extend tc flow structure with rcu to allow concurrent parallel access. Use
rcu read lock to safely lookup flow in tc flows hash table, and take
reference to it. Use rcu free for flow deletion to accommodate concurrent
stats requests.

Add new DELETED flow flag. Imlement new flow_flag_test_and_set() helper
that is used to set a flag and return its previous value. Use it to
atomically set the flag in mlx5e_delete_flower() to guarantee that flow can
only be deleted once, even when same flow is deleted concurrently by
multiple tasks.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 47 ++++++++++++++++---
 1 file changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 241157b699df..a39f8a07de0a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -79,6 +79,7 @@ enum {
 	MLX5E_TC_FLOW_FLAG_SLOW		=3D MLX5E_TC_FLOW_BASE + 3,
 	MLX5E_TC_FLOW_FLAG_DUP		=3D MLX5E_TC_FLOW_BASE + 4,
 	MLX5E_TC_FLOW_FLAG_NOT_READY	=3D MLX5E_TC_FLOW_BASE + 5,
+	MLX5E_TC_FLOW_FLAG_DELETED	=3D MLX5E_TC_FLOW_BASE + 6,
 };
=20
 #define MLX5E_TC_MAX_SPLITS 1
@@ -122,6 +123,7 @@ struct mlx5e_tc_flow {
 	struct list_head	peer;    /* flows with peer flow */
 	struct list_head	unready; /* flows not ready to be offloaded (e.g due to =
missing route) */
 	refcount_t		refcnt;
+	struct rcu_head		rcu_head;
 	union {
 		struct mlx5_esw_flow_attr esw_attr[0];
 		struct mlx5_nic_flow_attr nic_attr[0];
@@ -201,7 +203,7 @@ static void mlx5e_flow_put(struct mlx5e_priv *priv,
 {
 	if (refcount_dec_and_test(&flow->refcnt)) {
 		mlx5e_tc_del_flow(priv, flow);
-		kfree(flow);
+		kfree_rcu(flow, rcu_head);
 	}
 }
=20
@@ -214,6 +216,17 @@ static void __flow_flag_set(struct mlx5e_tc_flow *flow=
, unsigned long flag)
=20
 #define flow_flag_set(flow, flag) __flow_flag_set(flow, MLX5E_TC_FLOW_FLAG=
_##flag)
=20
+static bool __flow_flag_test_and_set(struct mlx5e_tc_flow *flow,
+				     unsigned long flag)
+{
+	/* test_and_set_bit() provides all necessary barriers */
+	return test_and_set_bit(flag, &flow->flags);
+}
+
+#define flow_flag_test_and_set(flow, flag)			\
+	__flow_flag_test_and_set(flow,				\
+				 MLX5E_TC_FLOW_FLAG_##flag)
+
 static void __flow_flag_clear(struct mlx5e_tc_flow *flow, unsigned long fl=
ag)
 {
 	/* Complete all memory stores before clearing bit. */
@@ -3451,7 +3464,9 @@ int mlx5e_configure_flower(struct net_device *dev, st=
ruct mlx5e_priv *priv,
 	struct mlx5e_tc_flow *flow;
 	int err =3D 0;
=20
-	flow =3D rhashtable_lookup_fast(tc_ht, &f->cookie, tc_ht_params);
+	rcu_read_lock();
+	flow =3D rhashtable_lookup(tc_ht, &f->cookie, tc_ht_params);
+	rcu_read_unlock();
 	if (flow) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "flow cookie already exists, ignoring");
@@ -3466,7 +3481,7 @@ int mlx5e_configure_flower(struct net_device *dev, st=
ruct mlx5e_priv *priv,
 	if (err)
 		goto out;
=20
-	err =3D rhashtable_insert_fast(tc_ht, &flow->node, tc_ht_params);
+	err =3D rhashtable_lookup_insert_fast(tc_ht, &flow->node, tc_ht_params);
 	if (err)
 		goto err_free;
=20
@@ -3492,16 +3507,32 @@ int mlx5e_delete_flower(struct net_device *dev, str=
uct mlx5e_priv *priv,
 {
 	struct rhashtable *tc_ht =3D get_tc_ht(priv, flags);
 	struct mlx5e_tc_flow *flow;
+	int err;
=20
+	rcu_read_lock();
 	flow =3D rhashtable_lookup_fast(tc_ht, &f->cookie, tc_ht_params);
-	if (!flow || !same_flow_direction(flow, flags))
-		return -EINVAL;
+	if (!flow || !same_flow_direction(flow, flags)) {
+		err =3D -EINVAL;
+		goto errout;
+	}
=20
+	/* Only delete the flow if it doesn't have MLX5E_TC_FLOW_DELETED flag
+	 * set.
+	 */
+	if (flow_flag_test_and_set(flow, DELETED)) {
+		err =3D -EINVAL;
+		goto errout;
+	}
 	rhashtable_remove_fast(tc_ht, &flow->node, tc_ht_params);
+	rcu_read_unlock();
=20
 	mlx5e_flow_put(priv, flow);
=20
 	return 0;
+
+errout:
+	rcu_read_unlock();
+	return err;
 }
=20
 int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
@@ -3517,8 +3548,10 @@ int mlx5e_stats_flower(struct net_device *dev, struc=
t mlx5e_priv *priv,
 	u64 bytes =3D 0;
 	int err =3D 0;
=20
-	flow =3D mlx5e_flow_get(rhashtable_lookup_fast(tc_ht, &f->cookie,
-						     tc_ht_params));
+	rcu_read_lock();
+	flow =3D mlx5e_flow_get(rhashtable_lookup(tc_ht, &f->cookie,
+						tc_ht_params));
+	rcu_read_unlock();
 	if (IS_ERR(flow))
 		return PTR_ERR(flow);
=20
--=20
2.21.0

